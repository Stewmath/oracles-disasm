; ==================================================================================================
; INTERAC_DOOR_CONTROLLER
; ==================================================================================================
interactionCode1e:
	call interactionDeleteAndRetIfEnabled02
	call returnIfScrollMode01Unset
.ifdef ROM_AGES
	ld a,(wSwitchHookState)
	cp $02
	ret z
.endif

	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3

@state0:
	ld a,$01
	ld (de),a

	; "xh" is actually a parameter. It's a value from 0-7; a bit for wActiveTriggers.
	ld h,d
	ld l,Interaction.xh
	ld e,Interaction.var3f
	ld a,(hl)
	ld (de),a
	and $07
	ld bc,bitTable
	add c
	ld c,a
	ld a,(bc)
	ld l,Interaction.var3d
	ld (hl),a

	; Convert short-form position in yh to full y/x position
	ld l,Interaction.yh
	ld e,Interaction.var3e
	ld a,(hl)
	ld (de),a
	ld l,Interaction.yh
	call setShortPosition

	; Decide what script to run based on subid. The script will decide when to proceed
	; to state 2 (open door) or 3 (close door).
	ld e,Interaction.subid
	ld a,(de)
	ld hl,@scriptSubidTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	call interactionSetScript
	call @func_47e5

@state1:
	call interactionRunScript
	jp c,interactionDelete

	ld e,Interaction.substate
	xor a
	ld (de),a
	ret


; State 2: a door is opening
@state2:
	ld a,(wPaletteThread_mode)
	or a
	ret nz

	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @state2Substate0
	.dw @state2Substate1

@state2Substate0:
	; The tile at this position must be solid
	call objectCheckTileCollision_allowHoles
	jr nc,@gotoState1

@interleaveDoorTile:
	ld a,SND_DOORCLOSE
	call @playSoundIfInScreenBoundary

	ld e,Interaction.angle
	ld a,(de)
	ld hl,@shutterTiles
	rst_addAToHl
	ld e,Interaction.var3e
	ld a,(de)
	ldh (<hFF8C),a
	ldi a,(hl)
	ldh (<hFF8F),a
	ldi a,(hl)
	ldh (<hFF8E),a
	and $03
	call setInterleavedTile

	ldh a,(<hActiveObject)
	ld d,a
	ld h,d
	ld l,Interaction.substate
	inc (hl)

	ld l,Interaction.counter1
	ld (hl),$06

	; Set the new tile in the room layout (but since we're not calling "setTile", the
	; visuals won't be updated just yet?)
	ld l,Interaction.var3e
	ld c,(hl)
	ld b,>wRoomLayout
	ldh a,(<hFF8F)
	ld (bc),a
	ret

@state2Substate1:
	call interactionDecCounter1
	ret nz

; Door will now open fully

	call @func_47ee
	ld e,Interaction.angle
	ld a,(de)
	ld hl,@shutterTiles
	rst_addAToHl
	jr @setTileAndPlaySound


; State 3: a door is closing
@state3:
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @state3Substate0
	.dw @state3Substate1

@state3Substate0:
.ifdef ROM_AGES
	; The tile at this position must not be solid
	call objectGetTileAtPosition
	cp TILEINDEX_SOMARIA_BLOCK
	jr z,@interleaveDoorTile
.endif
	call objectCheckTileCollision_allowHoles
	jr c,@gotoState1
	jr @interleaveDoorTile

@state3Substate1:
	call interactionDecCounter1
	ret nz

; Door will now close fully

	call @checkRespawnLink
	call @func_47f9

	ld e,Interaction.angle
	ld a,(de)
	ld hl,@shutterTiles
	rst_addAToHl
	inc hl

@setTileAndPlaySound:
	ld e,Interaction.var3e
	ld a,(de)
	ld c,a
	ld a,(hl)
	call setTile
	ld a,SND_DOORCLOSE
	call @playSoundIfInScreenBoundary

@gotoState1:
	ld e,Interaction.state
	ld a,$01
	ld (de),a
	inc e
	xor a
	ld (de),a
	jp @state1

;;
; Force Link to respawn if he's on the same tile as this object.
@checkRespawnLink:
	ld a,(w1Link.yh)
	and $f0
	ld b,a
	ld a,(w1Link.xh)
	swap a
	and $0f
	or b
	ld b,a
	ld e,Interaction.var3e
	ld a,(de)
	cp b
	ret nz
	ld a,$02
	ld (wScreenTransitionDelay),a
	jp respawnLink

@func_47e5:
	ld e,Interaction.var3e
	ld a,(de)
	ld c,a
	ld b,>wRoomCollisions
	ld a,(bc)
	or a
	ret nz

@func_47ee:
	ld e,Interaction.subid
	ld a,(de)
	cp $04
	ret c
	ld hl,wcc93
	inc (hl)
	ret

@func_47f9:
	ld e,Interaction.subid
	ld a,(de)
	cp $04
	ret c
	ld hl,wcc93
	ld a,(hl)
	or a
	ret z
	dec (hl)
	ld a,(hl)
	and $7f
	ret nz
	res 7,(hl)
	ret

;;
; @param	a	Sound to play
@playSoundIfInScreenBoundary:
	ldh (<hFF8B),a
	call objectCheckWithinScreenBoundary
	ret nc
	ldh a,(<hFF8B)
	jp playSound


; Data format:
;   b0: tile to transition into
;   b1: tile to transition from

@shutterTiles:
	.db $a0 $70 ; Key doors
	.db $a0 $71
	.db $a0 $72
	.db $a0 $73
	.db $a0 $74 ; Boss doors
	.db $a0 $75
	.db $a0 $76
	.db $a0 $77
	.db $a0 $78 ; Shutters
	.db $a0 $79
	.db $a0 $7a
	.db $a0 $7b
	.db $5e $7c ; Minecart shutters
	.db $5d $7d
	.db $5e $7e
	.db $5d $7f


@scriptSubidTable:
	/* $00 */ .dw mainScripts.doorOpenerScript
	/* $01 */ .dw mainScripts.stubScript
	/* $02 */ .dw mainScripts.stubScript
	/* $03 */ .dw mainScripts.stubScript
	/* $04 */ .dw mainScripts.doorController_controlledByTriggers_up
	/* $05 */ .dw mainScripts.doorController_controlledByTriggers_right
	/* $06 */ .dw mainScripts.doorController_controlledByTriggers_down
	/* $07 */ .dw mainScripts.doorController_controlledByTriggers_left
	/* $08 */ .dw mainScripts.doorController_shutUntilEnemiesDead_up
	/* $09 */ .dw mainScripts.doorController_shutUntilEnemiesDead_right
	/* $0a */ .dw mainScripts.doorController_shutUntilEnemiesDead_down
	/* $0b */ .dw mainScripts.doorController_shutUntilEnemiesDead_left
	/* $0c */ .dw mainScripts.doorController_minecartDoor_up
	/* $0d */ .dw mainScripts.doorController_minecartDoor_right
	/* $0e */ .dw mainScripts.doorController_minecartDoor_down
	/* $0f */ .dw mainScripts.doorController_minecartDoor_left
	/* $10 */ .dw mainScripts.doorController_closeAfterLinkEnters_up
	/* $11 */ .dw mainScripts.doorController_closeAfterLinkEnters_right
	/* $12 */ .dw mainScripts.doorController_closeAfterLinkEnters_down
	/* $13 */ .dw mainScripts.doorController_closeAfterLinkEnters_left
	/* $14 */ .dw mainScripts.doorController_openWhenTorchesLit_up_2Torches
	/* $15 */ .dw mainScripts.doorController_openWhenTorchesLit_left_2Torches
.ifdef ROM_AGES
	/* $16 */ .dw mainScripts.doorController_openWhenTorchesLit_down_1Torch
	/* $17 */ .dw mainScripts.doorController_openWhenTorchesLit_left_1Torch
.endif
