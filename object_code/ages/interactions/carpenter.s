; ==================================================================================================
; INTERAC_CARPENTER
;
; Variables:
;   var3f: Nonzero if the carpenter has returned to the boss
; ==================================================================================================
interactionCode9a:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2

@state0:
	ld e,Interaction.subid
	ld a,(de)
	cp $09
	jr z,@initialize

	ld a,GLOBALFLAG_SYMMETRY_BRIDGE_BUILT
	call checkGlobalFlag
	jp nz,@delete

	; Carpenters don't appear in linked game until Zelda's saved
	call checkIsLinkedGame
	jr z,++
	ld a,GLOBALFLAG_GOT_RING_FROM_ZELDA
	call checkGlobalFlag
	jr z,@delete
++
	ld e,Interaction.subid
	ld a,(de)
	inc a
	jr z,@runSubidFF

@initialize:
	call interactionIncState
	call interactionInitGraphics
	call objectSetVisiblec2
	ld a,>TX_2300
	call interactionSetHighTextIndex
	ld e,Interaction.subid
	ld a,(de)
	and $0f
	rst_jumpTable
	.dw @initSubid00
	.dw @initSubid01
	.dw @initSubid02
	.dw @initSubid03
	.dw @initSubid04
	.dw $0000
	.dw $0000
	.dw $0000
	.dw $0000
	.dw @initSubid09


; Checks if you leave the area without finding all the carpenters
@runSubidFF:
	ld a,(wTmpcfc0.carpenterSearch.cfd0)
	or a
	ret z
	ld a,(wScrollMode)
	and SCROLLMODE_08 | SCROLLMODE_04 | SCROLLMODE_02
	ret nz

	ld e,Interaction.var3f
	ld a,(de)
	or a
	jr z,++
	dec a
	ld (de),a
	ld (wDisallowMountingCompanion),a
++
	ld e,Interaction.substate
	ld a,(de)
	dec a
	jr z,@@substate1

@@substate0:
	ld a,(wLinkObjectIndex)
	ld h,a
	ld l,SpecialObject.xh
	ld a,$10
	cp (hl)
	ret c

.ifdef REGION_JP
	add $02
	ld (hl),a
.endif

	ld a,$01 ; [substate] = $01
	ld (de),a
	ld bc,TX_2307
	jp showText

@@substate1:
	call retIfTextIsActive
	ld a,(wSelectedTextOption)
	dec a
	jr z,@option0
	ld hl,wTmpcfc0.carpenterSearch.cfd0
	ld b,$10
	call clearMemory
@delete:
	jp interactionDelete

@option0:
	call resetLinkInvincibility
	ld a,-60
	ld (w1Link.invincibilityCounter),a
	ld a,$78
	ld (wDisallowMountingCompanion),a
	ld e,Interaction.var3f
	ld (de),a
	ld a,ANGLE_RIGHT
	ld (w1Link.angle),a
	ld e,Interaction.substate
	xor a
	ld (de),a
	ld a,(wLinkObjectIndex)
	ld h,a

.ifndef REGION_JP
	ld l,SpecialObject.xh
	ld (hl),$12
.endif

	rrca
	ret nc

	ld l,SpecialObject.id
	ld a,(hl)

.ifdef REGION_JP
	cp SPECIALOBJECT_DIMITRI
	ret nz
	ld l,SpecialObject.state
	; Fall through to @@dimitri label below

.else

	ld l,SpecialObject.state
	cp SPECIALOBJECT_RICKY
	jr nz,++

@@ricky:
	; Do something with Ricky's state?
	ldi a,(hl)
	cp $05
	ret nz
	ld a,$03
	ld (hl),a
	ret

++
	cp SPECIALOBJECT_DIMITRI
	ret nz

.endif

@@dimitri:
	; Do something with Dimitri's state?
	ld a,(hl)
	cp $08
	ret nz
	ld (hl),$0d
	ret

@initSubid01:
	xor a
	ld e,Interaction.oamFlags
	ld (de),a
	call objectMakeTileSolid
	ld h,>wRoomLayout
	ld (hl),$00
	jr @checkDoBridgeBuildingCutscene

@initSubid02:
@initSubid03:
@initSubid04:
	ld a,(wActiveRoom)
	cp <ROOM_AGES_025
	jr z,@@inBridgeRoom

	ld a,(de)
	swap a
	and $0f
	ld hl,wAnimalCompanion
	cp (hl)
	jr nz,@delete
	ld a,(de)
	and $0f
	ld hl,wTmpcfc0.carpenterSearch.carpentersFound
	call checkFlag
	jr nz,@delete2
	jr @checkDoBridgeBuildingCutscene

@@inBridgeRoom:
	ld a,(de)
	and $0f
	ld hl,wTmpcfc0.carpenterSearch.carpentersFound
	call checkFlag
	ld e,Interaction.var3f
	ld (de),a
	jr z,@delete2

	; Check if all 3 have been found
	ld a,(hl)
	cp $1c
	jr nz,@checkDoBridgeBuildingCutscene

	ld e,Interaction.subid
	ld a,(de)
	add $04
	ld (de),a
	jr @checkDoBridgeBuildingCutscene

@initSubid00:
	ld a,$03
	ld e,Interaction.oamFlags
	ld (de),a
	ld a,(wTmpcfc0.carpenterSearch.carpentersFound)
	cp $1c
	jr nz,@checkDoBridgeBuildingCutscene
	ld e,Interaction.subid
	ld a,$05
	ld (de),a
	ld a,$58
	ld e,Interaction.xh
	ld (de),a

@checkDoBridgeBuildingCutscene:
	ld a,GLOBALFLAG_SYMMETRY_BRIDGE_BUILT
	call checkGlobalFlag
	jr nz,@delete2

@initSubid09:
	call objectMarkSolidPosition
	ld e,Interaction.subid
	ld a,(de)
	and $0f
	ld hl,@animationsForBridgeBuildCutsceneStart
	rst_addAToHl
	ld a,(hl)
	call interactionSetAnimation
	ld a,$06
	call objectSetCollideRadius
	call interactionSetAlwaysUpdateBit
	jp @loadScript


@state1:
	ld e,Interaction.subid
	ld a,(de)
	and $0f
	rst_jumpTable
	.dw @runSubid
	.dw @runSubid01
	.dw @runSubid
	.dw @runSubid
	.dw @runSubid
	.dw @runSubid
	.dw @runSubid
	.dw @runSubid
	.dw @runSubid
	.dw @runSubid

@runSubid:
	call interactionAnimateAsNpc
	ld c,$40
	call objectUpdateSpeedZ_paramC
	call interactionRunScript
	ret nc
@delete2:
	jp interactionDelete

@runSubid01:
	ld a,(wTmpcfc0.carpenterSearch.cfd0)
	cp $0b
	ret nz
	ld a,$3a
	ld c,$55
	call setTile
	jr @delete2

; State 2: carpender jumping away until he goes off-screen
@state2:
	call interactionAnimate
	ld h,d
	ld l,Interaction.angle
	ld (hl),ANGLE_LEFT
	ld l,Interaction.speed
	ld (hl),SPEED_100
	call objectApplySpeed
	call objectCheckWithinScreenBoundary
	jr nc,@@leftScreen

	ld c,$10
	call objectUpdateSpeedZ_paramC
	ret nz
	ld bc,-$200
	call objectSetSpeedZ
	ld a,SND_JUMP
	jp playSound

@@leftScreen:
	; If that was the last carpenter, warp Link to the bridge screen
	ld e,Interaction.subid
	ld a,(de)
	and $0f
	ld hl,wTmpcfc0.carpenterSearch.carpentersFound
	call setFlag
	ld a,(hl)
	cp $1c
	ld hl,@warpDest
	jp z,setWarpDestVariables
	xor a
	ld (wMenuDisabled),a
	ld (wDisabledObjects),a
	jr @delete2

@warpDest:
	m_HardcodedWarpA ROOM_AGES_025, $00, $48, $03


@loadScript:
	ld e,Interaction.subid
	ld a,(de)
	and $0f
	ld hl,@scriptTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	jp interactionSetScript

@scriptTable:
	.dw mainScripts.carpenter_subid00Script
	.dw mainScripts.carpenter_subid00Script
	.dw mainScripts.carpenter_subid02Script
	.dw mainScripts.carpenter_subid03Script
	.dw mainScripts.carpenter_subid04Script
	.dw mainScripts.carpenter_subid05Script
	.dw mainScripts.carpenter_subid06Script
	.dw mainScripts.carpenter_subid07Script
	.dw mainScripts.carpenter_subid08Script
	.dw mainScripts.carpenter_subid09Script

; Animations for each subid
@animationsForBridgeBuildCutsceneStart:
	.db $04 $06 $02 $02 $02 $05 $03 $02
	.db $02 $00
