; ==================================================================================================
; INTERAC_MINIBOSS_PORTAL
; ==================================================================================================
interactionCode7e:
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw @subid00
	.dw @subid01
.ifdef ROM_SEASONS
	.dw @subid02
.endif


; Subid $00: miniboss portals
@subid00:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @minibossState0
	.dw @state1
	.dw @state2
	.dw @minibossState3

@minibossState0:
	ld a,(wDungeonIndex)
	ld hl,@dungeonRoomTable
	rst_addDoubleIndex
	ld c,(hl)
	ld a,(wActiveGroup)
	ld hl,flagLocationGroupTable
	rst_addAToHl
	ld h,(hl)
	ld l,c

	; hl now points to room flags for the miniboss room
	; Delete if miniboss is not dead.
	ld a,(hl)
	and $80
	jp z,interactionDelete

	ld c,$57
	call objectSetShortPosition

@commonState0:
	call interactionInitGraphics
	ld a,$03
	call objectSetCollideRadius

	; Go to state 1 if Link's not touching the portal, state 2 if he is.
	call objectCheckCollidedWithLink_notDeadAndNotGrabbing
	ld a,$01
	jr nc,+
	inc a
+
	ld e,Interaction.state
	ld (de),a
	jp objectSetVisible83


; State 1: waiting for Link to touch the portal to initiate the warp.
@state1:
	call interactionAnimate
	call objectCheckCollidedWithLink_notDeadAndNotGrabbing
	ret nc

	; Check that [w1Link.id] == SPECIALOBJECT_LINK, check collisions are enabled
	ld a,(w1Link.id)
	or a
	call z,checkLinkCollisionsEnabled
	ret nc

	call resetLinkInvincibility
	ld a,$03
	ld e,Interaction.state
	ld (de),a
	ld (wLinkCanPassNpcs),a

	ld a,$30
	ld e,Interaction.counter1
	ld (de),a
	call setLinkForceStateToState08
	ld hl,w1Link.visible
	ld (hl),$82
	call objectCopyPosition ; Link.position = this.position

	ld a,$01
	ld (wDisabledObjects),a
	ld a,SND_TELEPORT
	jp playSound


; State 2: wait for Link to get off the portal before detecting collisions
@state2:
	call interactionAnimate
	call objectCheckCollidedWithLink_notDeadAndNotGrabbing
	ret c
	ld a,$01
	ld e,Interaction.state
	ld (de),a
	ret


; State 3: Do the warp
@minibossState3:
	ld hl,w1Link
	call objectCopyPosition
	call @spinLink
	ret nz

	; Get starting room in 'b', miniboss room in 'c'
	ld a,(wDungeonIndex)
	ld hl,@dungeonRoomTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld c,(hl)
	ld b,a

	ld hl,wWarpDestGroup
	ld a,(wActiveGroup)
	or $80
	ldi (hl),a
	ld a,(wActiveRoom)
	cp b
	jr nz,+
	ld b,c
+
	ld a,b
	ldi (hl),a  ; [wWarpDestRoom] = b
	lda TRANSITION_DEST_BASIC
	ldi (hl),a  ; [wWarpTransition] = TRANSITION_DEST_BASIC
	ld (hl),$57 ; [wWarpDestPos] = $57
	inc l
	ld (hl),$03 ; [wWarpTransition2] = $03 (fadeout)
	ret

; Each row corresponds to a dungeon. The first byte is the miniboss room index, the second
; is the dungeon entrance (the two locations of the portal).
; If bit 7 is set in the miniboss room's flags, the portal is enabled.
@dungeonRoomTable:
.ifdef ROM_AGES
	.db $01 $04
	.db $18 $24
	.db $34 $46
	.db $4d $66
	.db $80 $91
	.db $b4 $bb
	.db $12 $26
	.db $4d $56
	.db $82 $aa
.else
	.db $01 $01
	.db $0b $15
	.db $21 $39
	.db $48 $4b
	.db $6a $81
	.db $a2 $a7
	.db $c8 $ba
	.db $42 $5b
	.db $72 $87
.endif


@spinLink:
	call resetLinkInvincibility
	call interactionAnimate
	ld a,(wLinkDeathTrigger)
	or a
	ret nz
	ld a,(wFrameCounter)
	and $03
	jr nz,++
	ld hl,w1Link.direction
	ld a,(hl)
	inc a
	and $03
	ld (hl),a
++
	jp interactionDecCounter1


; Subid $01: miscellaneous portals used in Hero's Cave
@subid01:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @herosCaveState0
	.dw @state1
	.dw @state2
	.dw @herosCaveState3

@herosCaveState0:
.ifdef ROM_AGES
	call interactionDeleteAndRetIfEnabled02
	ld e,Interaction.xh
	ld a,(de)
	ld e,Interaction.var03
	ld (de),a
	bit 7,a
	jr z,+
	call getThisRoomFlags
	and ROOMFLAG_ITEM
	ret z
+
	ld h,d
	ld e,Interaction.yh
	ld l,e
	ld a,(de)
	call setShortPosition
.else
	ld a,(wc64a)
	or a
	jp z,interactionDelete
.endif
	jp @commonState0

@herosCaveState3:
	call @spinLink
	ret nz

.ifdef ROM_AGES
	; Initiate the warp
	ld e,Interaction.var03
	ld a,(de)
	and $0f
	call @initHerosCaveWarp
	ld a,$84
	ld (wWarpDestGroup),a
	ret
.else
	ld a,(wc64a)
	jr @initHerosCaveWarp

@subid02:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @herosCave2State0
	.dw @state1
	.dw @state2
	.dw @herosCave2State3

@herosCave2State0:
	call getThisRoomFlags
	and $20
	jp z,interactionDelete
	jp @commonState0

@herosCave2State3:
	call @spinLink
	ret nz
	xor a
.endif

@initHerosCaveWarp:
	ld hl,@herosCaveWarps
	rst_addDoubleIndex
	ldi a,(hl)
	ld (wWarpDestRoom),a
	ldi a,(hl)
	ld (wWarpDestPos),a
	ld a,$85
	ld (wWarpDestGroup),a
	lda TRANSITION_DEST_BASIC
	ld (wWarpTransition),a
	ld a,$03
	ld (wWarpTransition2),a ; Fadeout transition
	ret


; Each row corresponds to a value for bits 0-3 of "X" (later var03).
; First byte is "wWarpDestRoom" (room index), second is "wWarpDestPos".
@herosCaveWarps:
.ifdef ROM_AGES
	.db $c2 $11
	.db $c3 $2c
	.db $c4 $11
	.db $c5 $2c
	.db $c6 $7a
	.db $c9 $86
	.db $ce $57
	.db $cf $91
.else
	.db $30 $37
	.db $31 $9d
	.db $2f $95
	.db $28 $59
	.db $24 $57
	.db $34 $17
.endif
