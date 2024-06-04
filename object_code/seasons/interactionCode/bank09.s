 m_section_free Seasons_Interactions_Bank09 NAMESPACE seasonsInteractionsBank09

; ==============================================================================
; INTERACID_QUICKSAND
; ==============================================================================
interactionCode5e:
	call returnIfScrollMode01Unset
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
@state0:
	ld a,$01
	ld (de),a
@state1:
	ld a,$21
	call objectSetCollideRadius
	call _findItemDropAddress
	call _findPirateSkullAddress
	call _findBombOrScentSeedAddress
	ld a,(w1Link.state)
	cp LINK_STATE_NORMAL
	ret nz
	ld a,(w1Link.zh)
	or a
	ret nz
	ld bc,$2105
	call @checkLinkWithinAPartOfQuicksand
	ret nc
	ld a,QUICKSAND_RING
	call cpActiveRing
	jr z,+
	call objectGetAngleTowardLink
	xor ANGLE_DOWN
	ld c,a
	ld b,$14
	call updateLinkPositionGivenVelocity
+
	call _matchSkullNumberWithSubid
	ld bc,$0300
	call @checkLinkWithinAPartOfQuicksand
	ret nc
; If subid $00, respawn Link
	ld e,Interaction.subid
	ld a,(de)
	or a
	ld a,$01
	jr z,@respawnLink
; Initiate warp
	call dropLinkHeldItem
	call clearAllParentItems
	ld h,d
	ld l,Interaction.state
	ld (hl),$02
; Puts bit 7 (subid matched) into counter2
	ld a,(wPirateSkullRandomNumber)
	and $7f
	ld l,Interaction.counter2
	ldd (hl),a ; Interaction.counter1
	ld (hl),60
	ld a,$03
@respawnLink:
	ld (wLinkStateParameter),a
	ld a,LINK_STATE_RESPAWNING
	ld (wLinkForceState),a
	ld hl,w1Link.yh
	jp objectCopyPosition
@state2:
	xor a
	ld (wPirateSkullRandomNumber),a
	call interactionDecCounter1
	ret nz
; c is destination index
	ld c,$03
; If subid is $05, skip to warp
	ld l,Interaction.subid
	ld a,(hl)
	cp $05
	jr z,+
	dec c
; If subid matched wPirateSkullRandomNumber, choose index $02
	ld e,Interaction.counter2
	ld a,(de)
	cp (hl)
	jr z,+
; Pseudo-randomly choose either $00 or $01
	ld a,(wFrameCounter)
	and $01
	ld c,a
+
	ld a,c
	add a
	add c
	ld hl,@warpDestLocations
	rst_addAToHl
	ldi a,(hl)
	ld (wWarpDestGroup),a
	ldi a,(hl)
	ld (wWarpDestRoom),a
	ldi a,(hl)
	ld (wWarpDestPos),a
	ld a,TRANSITION_DEST_FALL
	ld (wWarpTransition),a
; Fadeout
	ld a,$03
	ld (wWarpTransition2),a
	jp interactionDelete
@warpDestLocations:
	.db $80|(>ROOM_SEASONS_5d0), <ROOM_SEASONS_5d0, $57 ; has like likes
	.db $80|(>ROOM_SEASONS_5d1), <ROOM_SEASONS_5d1, $57 ; business scrub selling shield
	.db $80|(>ROOM_SEASONS_5d2), <ROOM_SEASONS_5d2, $57 ; pirate skull
	.db $80|(>ROOM_SEASONS_4f4), <ROOM_SEASONS_4f4, $27 ; leads to chest

; Param		b	Radius Y collision
; Param		c	Radius X collision
; Param[out]	cflag	Set if Link HAS collided
@checkLinkWithinAPartOfQuicksand:
	ld h,d
	ld l,Interaction.collisionRadiusY
	ld (hl),b
	inc l
	ld (hl),b
	ld a,(w1Link.yh)
	add c
	ld b,a
	ld a,(w1Link.xh)
	ld c,a
	jp interactionCheckContainsPoint

; Set bit 7 of wPirateSkullRandomNumber if that value and subid match
_matchSkullNumberWithSubid:
	ld hl,wPirateSkullRandomNumber
	ld a,(hl)
	or a
	ret z
	ld e,Interaction.subid
	ld a,(de)
	cp (hl)
	ret nz
	set 7,(hl)
	ret

; Checks for Pirate Skull, Bomb, Used Scent Seed, or Item Drop to pull into the center
_findPirateSkullAddress:
	ld c,INTERACID_PIRATE_SKULL
	call objectFindSameTypeObjectWithID
	ret nz
	ld l,Interaction.zh
	ld e,Interaction.var3a
	jr _moveObjectIfGrounded
_findItemDropAddress:
	ld h,$d0
-
	ld l,Part.id
	ld a,(hl)
	cp PARTID_ITEM_DROP
	call z,_objectIsPart
	inc h
	ld a,h
	cp $e0
	jr c,-
	ret

; Object is a part
_objectIsPart:
	ld l,Part.zh
	ld e,Part.var31

; Param     hl      Object.zh
; Param     e       Object's yh variable to tell it to move toward quicksand
_moveObjectIfGrounded:
; Checks if object is in the air
	ldd a,(hl)
	rlca
	ret c
	dec l
	ld c,(hl)		;Object.xh
	dec l
	dec l
	ld b,(hl)		;Object.yh
	ld l,e			;hl = Object.var3a or var31
	push hl
; Ret if object has not collided with quicksand
	call interactionCheckContainsPoint
	pop hl
	ret nc

	call objectGetPosition
	ld (hl),b
	inc l
	ld (hl),c
	ret

_findBombOrScentSeedAddress:
	ld c,ITEMID_BOMB
	call findItemWithID
	call z,_objectIsItem
	ld c,ITEMID_BOMB
	call findItemWithID_startingAfterH
	call z,_objectIsItem
	ld c,ITEMID_SCENT_SEED
	call findItemWithID
	ret nz

; Object is an item
_objectIsItem:
	ld l,Item.zh
	ld e,Item.var31
	jr _moveObjectIfGrounded

.include "object_code/common/interactionCode/companionSpawner.s"


; ==============================================================================
; INTERACID_D5_4_CHEST_PUZZLE
; ==============================================================================
interactionCode62:
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw @subid0
	.dw @subid1
@subid0:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @@state0
	.dw @@state1
	.dw @subid1
	.dw @subid1
@@state0:
	call getThisRoomFlags
	bit 5,(hl)
	jp nz,interactionDelete
	ld e,Interaction.state
	ld a,$01
	ld (de),a
	ld ($ccbb),a
	xor a
	ld ($cfd8),a
	ld ($cfd9),a
@@state1:
	ld a,(wNumEnemies)
	or a
	ret nz
	ld a,($cfd0)
	ld b,a
	ld c,$00
	call @@func_4fa5
	ld a,($cfd1)
	ld b,a
	ld c,$01
	call @@func_4fa5
	ld a,($cfd2)
	ld b,a
	ld c,$02
	call @@func_4fa5
	ld a,($cfd3)
	ld b,a
	ld c,$03
	call @@func_4fa5
	jp interactionDelete
@@func_4fa5:
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERACID_D5_4_CHEST_PUZZLE
	inc l
	ld (hl),$01
	ld l,$70
	ld (hl),b
	ld l,$43
	ld (hl),c
	ret
@subid1:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @@state0
	.dw @@state1
	.dw @@state2
	.dw @@state3
	.dw @@state4
@@state0:
	ld a,$01
	ld (de),a
	ld e,$70
	ld a,(de)
	ld h,d
	ld l,$4b
	call setShortPosition
	ld l,$66
	ld (hl),$04
	inc l
	ld (hl),$06
	ld l,$46
	ld (hl),$1e
	call objectCreatePuff
@@state1:
	call interactionDecCounter1
	ret nz
	ld l,$44
	inc (hl)
	ld l,$70
	ld c,(hl)
	ld a,TILEINDEX_CHEST
	call setTile
@@state2:
	ld a,($cfd9)
	or a
	jp nz,func_5076
	call objectPreventLinkFromPassing
	ld a,(wcca2)
	or a
	ret z
	ld b,a
	ld e,$70
	ld a,(de)
	cp b
	ret nz
	ld a,($cfd8)
	ld b,a
	ld e,$43
	ld a,(de)
	cp b
	jr nz,@@func_5040
	inc a
	ld ($cfd8),a
	ld hl,$d040
	ld b,$40
	call clearMemory
	ld hl,$d040
	inc (hl)
	inc l
	ld (hl),$60
	inc l
	ld a,($cfd8)
	dec a
	ld bc,@@table_504b
	call addDoubleIndexToBc
	ld a,(bc)
	ld (hl),a
	inc l
	inc bc
	ld a,(bc)
	ld (hl),a
	ld bc,$f800
	call objectCopyPositionWithOffset
	ld e,Interaction.state
	ld a,$03
	ld (de),a
	ld a,$81
	ld ($cca4),a
	ret
@@func_5040:
	ld a,$5a
	call playSound
	ld a,$01
	ld ($cfd9),a
	ret
@@table_504b:
	; $d042 - $d043
	.db TREASURE_RUPEES      RUPEEVAL_070
	.db TREASURE_BOMBS       $01
	.db TREASURE_EMBER_SEEDS $00
	.db TREASURE_SMALL_KEY   $03
@@state3:
	ld a,($cfd9)
	or a
	jr nz,func_5076
	ret
@@state4:
	call interactionDecCounter1
	ret nz
	call objectCreatePuff
	call getFreeEnemySlot
	ret nz
	ld (hl),ENEMYID_WHISP
	call objectCopyPosition
	ld e,$70
	ld a,(de)
	ld c,a
	ld a,TILEINDEX_STANDARD_FLOOR
	call setTile
	jp interactionDelete
func_5076:
	ld e,Interaction.state
	ld a,$04
	ld (de),a
	ld e,$46
	ld a,$3c
	ld (de),a
	ret


; ==============================================================================
; INTERACID_D5_REVERSE_MOVING_ARMOS
; ==============================================================================
interactionCode63:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
@state0:
	ld a,(wBlockPushAngle)
	or a
	ret z
	add $10
	and $1f
	add $04
	add a
	swap a
	and $03
	ld hl,@table_50da
	rst_addAToHl
	ld c,(hl)
	call objectGetShortPosition
	add c
	ld b,$ce
	ld c,a
	ldh (<hFF8C),a
	ld a,(bc)
	or a
	jr nz,@func_50e3
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERACID_PUSHBLOCK
	ld l,$49
	ld a,(wBlockPushAngle)
	add $10
	and $1f
	ld (hl),a
	ldh (<hFF8B),a
	ld bc,$fe00
	call objectCopyPositionWithOffset
	call objectGetShortPosition
	ld l,$70
	ld (hl),a
	ld h,d
	ld l,$4b
	ldh a,(<hFF8C)
	call setShortPosition
	ld l,$44
	ld (hl),$01
	xor a
	ld (wBlockPushAngle),a
	ret
@table_50da:
	.db $f0 $01 $10 $ff
@state1:
	ld a,(wBlockPushAngle)
	or a
	ret z
@func_50e3:
	ld e,Interaction.state
	xor a
	ld (de),a
	ld (wBlockPushAngle),a
	ret


; ==============================================================================
; INTERACID_D5_FALLING_MAGNET_BALL
; ==============================================================================
interactionCode64:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3
	.dw @state4
	.dw interactionDelete
@state0:
	call interactionInitGraphics
	call getThisRoomFlags
	bit 7,(hl)
	jr nz,@createBall
	call objectGetZAboveScreen
	ld h,d
	ld l,Interaction.state
	ld (hl),$01
	ld l,Interaction.zh
	ld (hl),a
	ret
@createBall:
	ld e,Interaction.state
	ld a,$04
	ld (de),a
	jp objectSetVisiblec2
@state1:
	call getThisRoomFlags
	bit 7,(hl)
	ret z
	ld e,Interaction.state
	ld a,$02
	ld (de),a
	ld e,Interaction.counter1
	ld a,$1e
	ld (de),a
	ld a,SND_SOLVEPUZZLE
	call playSound
	jp objectSetVisiblec1
@state2:
	call interactionDecCounter1
	ret nz
	ld l,Interaction.state
	inc (hl)
@state3:
	ld c,$10
	call objectUpdateSpeedZAndBounce
	ret nc
	ld e,Interaction.state
	ld a,$04
	ld (de),a
@state4:
	ld hl,w1MagnetBall
	ld a,(hl)
	or a
	ret nz
	ld (hl),$01
	inc l
	ld (hl),ITEMID_MAGNET_BALL
	call objectCopyPosition
	ld e,Interaction.relatedObj1
	ld l,Object.relatedObj1
	ld a,(de)
	ldi (hl),a
	inc e
	ld a,(de)
	ld (hl),a
	ld e,Interaction.state
	ld a,$05
	ld (de),a
	ret


; ==============================================================================
; INTERACID_LOST_WOODS_DEKU_SCRUB
; ==============================================================================
interactionCode65:
	call returnIfScrollMode01Unset
	call func_5258
	jp nz,interactionDelete
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
@state0:
	ld a,$01
	ld (de),a
	call objectSetReservedBit1
	ld e,Interaction.subid
	ld a,(de)
	or a
	jr nz,@notSubId0
	ld e,$46
	ld a,$78
	ld (de),a

	ld a,$02
	ld ($ff00+R_SVBK),a

	ld a,$80
	ld hl,$d000
	call @func_51c0

	ld hl,$d0a0
	call @func_51c0

	ld a,$0b
	ld hl,$d400
	call @func_51c0

	ld hl,$d4a0
	call @func_51c0

	xor a
	ld ($ff00+R_SVBK),a

	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERACID_D6_CRYSTAL_TRAP_ROOM
	inc l
	ld (hl),$01
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERACID_D6_CRYSTAL_TRAP_ROOM
	inc l
	ld (hl),$02
	ret
@notSubId0:
	ld e,Interaction.state
	ld a,$02
	ld (de),a
	ret
@func_51c0:
	ld b,$20
-
	ldi (hl),a
	dec b
	jr nz,-
	ret
@state1:
	xor a
	ld ($ccab),a
	ld a,$3c
	ld ($cd19),a
	call interactionDecCounter1
	ret nz
	ld (hl),$78
	ld a,$01
	ld ($ccab),a
	ld hl,$cfd0
	inc (hl)
	call func_5261
	call func_545a
	call func_52d9
	call func_537e
	xor a
	ld ($ff00+R_SVBK),a
	ldh a,(<hActiveObject)
	ld d,a
	ld a,$70
	call playSound
	ld a,$0f
	ld ($cd18),a
	ld a,($cfd0)
	cp $09
	ret c
	call func_5258
	jp nz,interactionDelete
	ld a,$11
	ld ($cc6a),a
	ld a,$81
	ld ($cc6b),a
	jp interactionDelete
@state2:
	call func_5258
	jp nz,interactionDelete
	ld a,($cfd0)
	cp $09
	jr z,func_524d
	ld a,($cfd0)
	ld c,$08
	call multiplyAByC
	ld a,l
	add $10
	ld b,a
	ld hl,$d00b
	ld a,(hl)
	cp b
	jr nc,+
	ld (hl),b
+
	ld a,($cfd0)
	ld b,a
	ld a,$15
	sub b
	ld c,$08
	call multiplyAByC
	ld a,l
	sub $0e
	ld b,a
	ld hl,$d00b
	ld a,(hl)
	cp b
	ret c
	ld (hl),b
	ret
func_524d:
	ld a,$08
	call setScreenShakeCounter
	ld a,$58
	ld ($d00b),a
	ret
func_5258:
	ld a,(wActiveRoom)
	cp $c5
	ret z
	cp $c6
	ret
func_5261:
	ld a,$02
	ld ($ff00+R_SVBK),a
	ld a,($cd09)
	cpl
	inc a
	swap a
	rlca
	ldh (<hFF8B),a
	xor a
	call func_5293
	ld a,$04
	call func_5293
	ld a,$08
	call func_5293
	ld a,$0c
	call func_5293
	ld a,$10
	call func_5293
	ld a,$14
	call func_5293
	ld a,$18
	call func_5293
	ld a,$1c
func_5293:
	ld hl,table_52a6
	rst_addAToHl
	ldi a,(hl)
	ld d,(hl)
	ld e,a
	inc hl
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	ldh a,(<hFF8B)
	ld c,a
	ld b,$00
	add hl,bc
	jr func_52c6
table_52a6:
	.dw $d020 $d0c0
	.dw $d040 $d0e0
	.dw $d060 $d100
	.dw $d080 $d120
	.dw $d420 $d4c0
	.dw $d440 $d4e0
	.dw $d460 $d500
	.dw $d480 $d520
func_52c6:
	ld b,$20
--
	ld a,(hl)
	ld (de),a
	inc de
	inc l
	ld a,l
	and $1f
	jr nz,+
	ld a,l
	sub $20
	ld l,a
+
	dec b
	jr nz,--
	ret
func_52d9:
	push de
	ld a,($cfd0)
	add a
	ld hl,table_5326
	rst_addDoubleIndex
	ldi a,(hl)
	ld d,(hl)
	ld e,a
	inc hl
	push hl
	ld hl,$d400
	ld b,$05
	ld c,$02
	call queueDmaTransfer
	pop hl
	ldi a,(hl)
	ld d,(hl)
	ld e,a
	ld hl,$d000
	ld b,$05
	ld c,$02
	call queueDmaTransfer
	ld a,($cfd0)
	add a
	ld hl,table_5352
	rst_addDoubleIndex
	ldi a,(hl)
	ld d,(hl)
	ld e,a
	inc hl
	push hl
	ld hl,$d460
	ld b,$05
	ld c,$02
	call queueDmaTransfer
	pop hl
	ldi a,(hl)
	ld d,(hl)
	ld e,a
	ld hl,$d060
	ld b,$05
	ld c,$02
	call queueDmaTransfer
	pop de
	ret
table_5326:
	.db $01 $98 $00 $98
	.db $01 $98 $00 $98
	.db $21 $98 $20 $98
	.db $41 $98 $40 $98
	.db $61 $98 $60 $98
	.db $81 $98 $80 $98
	.db $a1 $98 $a0 $98
	.db $c1 $98 $c0 $98
	.db $e1 $98 $e0 $98
	.db $01 $99 $00 $99
	.db $21 $99 $20 $99
table_5352:
	.db $61 $9a $60 $9a
	.db $61 $9a $60 $9a
	.db $41 $9a $40 $9a
	.db $21 $9a $20 $9a
	.db $01 $9a $00 $9a
	.db $e1 $99 $e0 $99
	.db $c1 $99 $c0 $99
	.db $a1 $99 $a0 $99
	.db $81 $99 $80 $99
	.db $61 $99 $60 $99
	.db $41 $99 $40 $99
func_537e:
	ld a,($cfd0)
	or a
	ret z
	bit 0,a
	jr nz,func_53a1
	srl a
	swap a
	ld l,a
	ld a,$0f
	call func_53bb
	ld a,($cfd0)
	srl a
	ld b,a
	ld a,$0a
	sub b
	swap a
	ld l,a
	ld a,$0f
	jr func_53bb
func_53a1:
	inc a
	srl a
	swap a
	ld l,a
	ld a,$0c
	call func_53bb
	ld a,($cfd0)
	inc a
	srl a
	ld b,a
	ld a,$0a
	sub b
	swap a
	ld l,a
	ld a,$03
func_53bb:
	ld e,a
	ld b,$10
	ld h,$ce
-
	ld a,(hl)
	or e
	ldi (hl),a
	dec b
	jr nz,-
	ret
func_53c7:
	ld a,($cfd0)
	or a
	ret z
	bit 0,a
	ret nz
	srl a
	swap a
	ld l,a
	ld a,$b0
	call func_53e7
	ld a,($cfd0)
	srl a
	ld b,a
	ld a,$0a
	sub b
	swap a
	ld l,a
	ld a,$b2
func_53e7:
	ld b,$10
	ld h,$cf
-
	ldi (hl),a
	dec b
	jr nz,-
	ret

;;
; $02: D6 wall-closing room
roomTileChangesAfterLoad02_body:
	call func_537e
	call func_53c7
	ld hl,$d800
	ld de,$d0c0
	call func_5440
	ld hl,$d820
	ld de,$d0e0
	call func_5440
	ld hl,$dc00
	ld de,$d4c0
	call func_5440
	ld hl,$dc20
	ld de,$d4e0
	call func_5440
	ld hl,$da80
	ld de,$d100
	call func_5440
	ld hl,$daa0
	ld de,$d120
	call func_5440
	ld hl,$de80
	ld de,$d500
	call func_5440
	ld hl,$dea0
	ld de,$d520
	call func_5440
	jr func_545a
func_5440:
	ld a,$03
	ld ($ff00+R_SVBK),a
	push de
	ld de,$cd40
	ld b,$20
	call copyMemory
	pop de
	ld a,$02
	ld ($ff00+R_SVBK),a
	ld hl,$cd40
	ld b,$20
	jp copyMemory

func_545a:
	ld a,($cfd0)
	or a
	ret z
	push de
	push hl
	ld hl,$d0c0
	ld de,$cd40
	ld b,$40
	ld c,$02
	call func_553a
	ld a,($cfd0)
	ld hl,table_5544
	rst_addDoubleIndex
	ldi a,(hl)
	ld d,(hl)
	ld e,a
	ld hl,$cd40
	ld b,$40
	ld c,$03
	call func_553a
	ld hl,$d100
	ld de,$cd40
	ld b,$40
	ld c,$02
	call func_553a
	ld a,($cfd0)
	ld hl,table_5558
	rst_addDoubleIndex
	ldi a,(hl)
	ld d,(hl)
	ld e,a
	ld hl,$cd40
	ld b,$40
	ld c,$03
	call func_553a
	ld hl,$d4c0
	ld de,$cd40
	ld b,$40
	ld c,$02
	call func_553a
	ld a,($cfd0)
	ld hl,table_5544
	rst_addDoubleIndex
	ldi a,(hl)
	ld e,a
	ld a,(hl)
	add $04
	ld d,a
	ld hl,$cd40
	ld b,$40
	ld c,$03
	call func_553a
	ld hl,$d500
	ld de,$cd40
	ld b,$40
	ld c,$02
	call func_553a
	ld a,($cfd0)
	ld hl,table_5558
	rst_addDoubleIndex
	ldi a,(hl)
	ld e,a
	ld a,(hl)
	add $04
	ld d,a
	ld hl,$cd40
	ld b,$40
	ld c,$03
	call func_553a
	ld a,$03
	ld ($ff00+R_SVBK),a
	ld hl,$d800
	ld a,$80
	call func_552a
	ld hl,$dc00
	ld a,$0b
	call func_552a
	ld a,($cfd0)
	ld c,a
	ld b,$00
	ld a,$16
	sub c
	ld c,a
	ld a,$20
	call multiplyAByC
	ld c,l
	ld b,h
	ld hl,$d800
	add hl,bc
	ld a,$80
	push hl
	call func_552a
	pop hl
	ld bc,$0400
	add hl,bc
	ld a,$0b
	call func_552a
	xor a
	ld ($ff00+R_SVBK),a
	pop hl
	pop de
	ret
func_552a:
	ld e,a
	ld a,($cfd0)
	ld c,a
	ld a,e
--
	ld b,$20
-
	ldi (hl),a
	dec b
	jr nz,-
	dec c
	jr nz,--
	ret
func_553a:
	ld a,c
	ld ($ff00+R_SVBK),a
	call copyMemory
	xor a
	ld ($ff00+R_SVBK),a
	ret
table_5544:
	.db $00 $d8
	.db $20 $d8
	.db $40 $d8
	.db $60 $d8
	.db $80 $d8
	.db $a0 $d8
	.db $c0 $d8
	.db $e0 $d8
	.db $00 $d9
	.db $20 $d9
table_5558:
	.db $80 $da
	.db $60 $da
	.db $40 $da
	.db $20 $da
	.db $00 $da
	.db $e0 $d9
	.db $c0 $d9
	.db $a0 $d9
	.db $80 $d9
	.db $60 $d9


; ==============================================================================
; INTERACID_D7_4_ARMOS_BUTTON_PUZZLE
; ==============================================================================
interactionCode66:
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw @subid0
	.dw @subid1
@subid1:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @@state0
	.dw @@state1
@@state0:
	ld a,$01
	ld (de),a
	call interactionInitGraphics
	ld a,$27
	call objectMimicBgTile
	ld a,$06
	call objectSetCollideRadius
	ld l,$50
	ld (hl),$28
	ld l,$46
	ld (hl),$10
	inc l
	ld (hl),$02
	ld l,$4b
	dec (hl)
	dec (hl)
	push de
	call @@func_55c8
	pop de
	ld a,$71
	call playSound
	jp objectSetVisible82
@@state1:
	call objectApplySpeed
	call objectPreventLinkFromPassing
	call interactionDecCounter1
	ret nz
	ld (hl),$10
	inc l
	dec (hl)
	jr z,+
	call interactionCheckAdjacentTileIsSolid
	ret z
+
	call objectGetShortPosition
	ld c,a
	ld a,$27
	call setTile
	jp interactionDelete
@@func_55c8:
	call objectGetShortPosition
	ld c,a
	ld a,$03
	ld ($ff00+R_SVBK),a
	ld b,$df
	ld a,(bc)
	ld b,a
	xor a
	ld ($ff00+R_SVBK),a
	ld a,b
	jp setTile
@subid0:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @@state0
	.dw @@state1
	.dw @@state2
@@state0:
	ld e,Interaction.state
	ld a,$01
	ld (de),a
	ld a,$03
	ld ($ff00+R_SVBK),a
	ld b,$df
	ld hl,@@table_5610
	ld a,$a3
-
	ld c,(hl)
	inc hl
	ld (bc),a
	dec e
	jr nz,-
	ld h,b
	ld l,$17
	ld (hl),$a0
	ld l,$3b
	ld (hl),$a0
	ld l,$5b
	ld (hl),$a0
	ld l,$57
	ld (hl),$a2
	xor a
	ld ($ff00+R_SVBK),a
	ret
@@table_5610:
	.db $35 $37 $39 $55
	.db $59 $75 $77 $79
@@state1:
	ld hl,wActiveTriggers
	bit 4,(hl)
	jr nz,+
	bit 0,(hl)
	jr z,+
	set 4,(hl)
	ld c,$32
	call nz,func_5694
+
	ld hl,wActiveTriggers
	bit 5,(hl)
	jr nz,+
	bit 1,(hl)
	jr z,+
	set 5,(hl)
	ld c,$52
	call nz,func_5694
+
	ld hl,wActiveTriggers
	bit 6,(hl)
	jr nz,+
	bit 2,(hl)
	jr z,+
	set 6,(hl)
	ld c,$95
	call nz,func_56a5
+
	ld hl,wActiveTriggers
	bit 7,(hl)
	jr nz,+
	bit 3,(hl)
	jr z,+
	set 7,(hl)
	ld c,$97
	call nz,func_56a5
+
	ld a,(wActiveTriggers)
	inc a
	ret nz
	call getThisRoomFlags
	bit 5,(hl)
	jp nz,interactionDelete
	ld e,$46
	ld a,$3c
	ld (de),a
	jp interactionIncState
@@state2:
	call interactionDecCounter1
	ret nz
	ld a,$a3
	call findTileInRoom
	jr nz,+
	ld a,$5a
	call playSound
	jp interactionDelete
+
	ldbc TREASURE_SMALL_KEY $01
	call createTreasure
	call objectCopyPosition
	jp interactionDelete
func_5694:
	ld b,$cf
-
	ld a,(bc)
	cp $27
	ld e,$18
	call z,func_56b8
	inc c
	ld a,c
	and $0f
	ret z
	jr -
func_56a5:
	ld b,$cf
-
	ld a,(bc)
	cp $27
	ld e,$10
	call z,func_56b8
	ld a,c
	sub $10
	ld c,a
	and $f0
	ret z
	jr -
func_56b8:
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERACID_D7_4_ARMOS_BUTTON_PUZZLE
	inc l
	ld (hl),$01
	push bc
	ld l,$4b
	call setShortPosition_paramC
	pop bc
	ld l,$49
	ld (hl),e
	ret


; ==============================================================================
; INTERACID_D8_ARMOS_PATTERN_PUZZLE
; ==============================================================================
interactionCode67:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3
	.dw @state4
@state0:
	call getThisRoomFlags
	bit 5,(hl)
	jp nz,interactionDelete
	ld a,$0a
	call objectSetCollideRadius
	ld l,$44
	inc (hl)
	jp interactionInitGraphics
@state1:
	call objectCheckCollidedWithLink_notDead
	ret nc
	call getRandomNumber
	and $0f
	ld hl,@table_5727
	rst_addAToHl
	ld a,(hl)
	ld e,$43
	ld (de),a
	ld hl,@table_571f
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	call interactionSetScript
	call interactionIncState
	ld a,$81
	ld ($cca4),a
	call objectSetVisible82
	call setCameraFocusedObject
	call func_57f3
	ld e,$79
	ld (de),a
	jp objectCreatePuff
@table_571f:
	.dw mainScripts.d8ArmosScript_pattern1
	.dw mainScripts.d8ArmosScript_pattern2
	.dw mainScripts.d8ArmosScript_pattern3
	.dw mainScripts.d8ArmosScript_pattern4
@table_5727:
	.db $00 $01 $02 $03
	.db $00 $01 $02 $03
	.db $00 $01 $02 $03
	.db $00 $01 $02 $03
@state2:
	ld a,(wFrameCounter)
	rrca
	jr nc,+
	ld a,$80
	ld h,d
	ld l,$5a
	xor (hl)
	ld (hl),a
+
	call interactionAnimate
	jp interactionRunScript
@state3:
	ld e,$5a
	xor a
	ld (de),a
	call func_57f3
	ld b,a
	ld e,$79
	ld a,(de)
	cp b
	ret z
	ld e,$43
	ld a,(de)
	ld hl,@table_579a
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	ld e,$78
	ld a,(de)
	rst_addAToHl
	ld a,(hl)
	cp b
	jr nz,@func_5792
	cp $1c
	jr z,@func_577f
	ld c,a
	ld a,(de)
	inc a
	ld (de),a
	ld a,b
	ld e,$79
	ld (de),a
@func_5775:
	ld a,$a2
	call setTile
	ld a,$62
	jp playSound
@func_577f:
	ld c,$1c
	call @func_5775
	call interactionIncState
	ld a,$4d
	call playSound
	ld hl,mainScripts.d8ArmosScript_giveKey
	jp interactionSetScript
@func_5792:
	ld a,$5a
	call playSound
	jp interactionDelete
@table_579a:
	.dw @@table_57a2
	.dw @@table_57b3
	.dw @@table_57c2
	.dw @@table_57d7
@@table_57a2:
	.db $9c $8c $7c $7d
	.db $6d $6c $6b $6a
	.db $5a $4a $3a $2a
	.db $1a $1b $2b $2c
	.db $1c
@@table_57b3:
	.db $9c $8c $7c $7d
	.db $6d $5d $4d $4c
	.db $4b $4a $3a $2a
	.db $1a $1b $1c
@@table_57c2:
	.db $9c $9b $9a $8a
	.db $8b $8c $8d $7d
	.db $7c $7b $7a $6a
	.db $5a $4a $3a $2a
	.db $2b $2c $2d $1d
	.db $1c
@@table_57d7:
	.db $9c $8c $7c $6c
	.db $5c $5b $6b $7b
	.db $7c $7d $6d $6c
	.db $6b $6a $5a $4a
	.db $3a $2a $1a $1b
	.db $1c
@state4:
	call interactionRunScript
	jp c,interactionDelete
	ret
func_57f3:
	ld hl,$d00b
	ldi a,(hl)
	add $04
	and $f0
	ld b,a
	inc l
	ld a,(hl)
	swap a
	and $0f
	or b
	ret


; ==============================================================================
; INTERACID_D8_GRABBABLE_ICE
; ==============================================================================
interactionCode68:
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
	call interactionInitGraphics
	ld a,$06
	call objectSetCollideRadius
	jp objectSetVisiblec2
@state1:
	ld c,$20
	call objectUpdateSpeedZ_paramC
	ld a,($cc77)
	or a
	jr nz,+
	ld a,($cc48)
	rrca
	call nc,objectPushLinkAwayOnCollision
+
	call objectAddToGrabbableObjectBuffer
@func_5833:
	call objectCheckIsOnHazard
	ret nc
	bit 6,a
	jr nz,+
	dec a
	jp z,objectReplaceWithSplash
	jp objectReplaceWithFallingDownHoleInteraction
+
	call getThisRoomFlags
	bit 6,(hl)
	jp nz,objectReplaceWithFallingDownHoleInteraction
	call objectSetInvisible
	ld l,$44
	ld (hl),$03
	ld l,$46
	ld (hl),$1e
	ld b,INTERACID_FALLDOWNHOLE
	jp objectCreateInteractionWithSubid00
@state2:
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @@substate0
	.dw @@substate1
	.dw @@substate2
	.dw @@substate3
@@substate0:
	ld h,d
	ld l,e
	inc (hl)
	xor a
	ld (wLinkGrabState2),a
	jp objectSetVisible81
@@substate1:
	ret
@@substate2:
	call objectCheckWithinRoomBoundary
	jp nc,interactionDelete
	call objectSetVisiblec1
	ld h,d
	ld l,$40
	res 1,(hl)
	ld e,$4f
	ld a,(de)
	or a
	jr z,@func_5833
	ret
@@substate3:
	ld h,d
	ld l,$40
	res 1,(hl)
	ld l,$45
	xor a
	ldd (hl),a
	inc a
	ld (hl),a
	jp objectSetVisible82
@state3:
	call interactionDecCounter1
	ret nz
	ld a,($d004)
	cp $01
	jr nz,delete
	ld a,($cc34)
	or a
	jr nz,delete
	ld a,($cc48)
	cp $d0
	jr nz,delete
	call resetLinkInvincibility
	ld a,$80
	ld ($cc02),a
	ld (wDisableWarpTiles),a
	ld ($ccab),a
	call getThisRoomFlags
	set 6,(hl)
	call func_58e4
	ldh a,(<hActiveObject)
	ld d,a
	ld a,(wDungeonFloor)
	dec a
	ld (wDungeonFloor),a
	call getActiveRoomFromDungeonMapPosition
	ld (wWarpDestRoom),a
	ld a,$85
	ld (wWarpDestGroup),a
	ld a,$0f
	ld (wWarpTransition),a
	ld a,$03
	ld (wWarpTransition2),a
delete:
	jp interactionDelete
func_58e4:
	call objectGetTileAtPosition
	dec h
	ld b,l
	ld a,(wActiveTileIndex)
	cp $d0
	ld a,(wActiveTilePos)
	jr nz,func_590c
	ld a,b
	sub $10
	call func_5907
	jr z,func_590b
	ld a,b
	inc a
	call func_5907
	jr z,func_590b
	ld a,b
	add $10
	jr func_590c
func_5907:
	ld l,a
	ld a,(hl)
	or a
	ret
func_590b:
	ld a,l
func_590c:
	ld ($cfd0),a
	ld a,(wActiveRoom)
	cp $7f
	jr nz,+
	ld b,$27
+
	ld a,b
	ld (wWarpDestPos),a
	ret


; ==============================================================================
; INTERACID_D8_FREEZING_LAVA_EVENT
; ==============================================================================
interactionCode69:
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw @subid0
	.dw @subid1
	.dw @subid2
	.dw @subid3
	.dw @subid4
@subid0:
	ld e,$44
	ld a,(de)
	rst_jumpTable
	.dw @@state0
	.dw @@state1
	.dw @@state2
	.dw @@state3
@@state0:
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @@@substate0
	.dw @@@substate1
@@@substate0:
	call getThisRoomFlags
	bit 6,(hl)
	jp nz,interactionDelete
	ld e,$4d
	ld a,(de)
	ld e,$43
	ld (de),a
	ld hl,@@@table_5976
	rst_addAToHl
	ld b,(hl)
	call getThisRoomFlags
	ld l,b
	bit 6,(hl)
	jp z,interactionDelete
	call getThisRoomFlags
	set 6,(hl)
	ld e,Interaction.substate
	ld a,$01
	ld (de),a
	ld a,$f0
	call playSound
	ld a,$ff
	ld (wActiveMusic),a
	ld a,$80
	ld ($cca4),a
	jr @@@substate1
@@@table_5976:
	.db $7e $7f $88 $89
@@@substate1:
	call func_5ae0
	ld a,($c4ab)
	or a
	ret nz
	ld e,Interaction.state
	ld a,$01
	ld (de),a
	xor a
	inc e
	ld (de),a
	call getFreeInteractionSlot
	jp nz,interactionDelete
	ld (hl),INTERACID_D8_FREEZING_LAVA_EVENT
	inc l
	ld (hl),$01
	ld e,$4b
	ld a,(de)
	ld l,$4b
	jp setShortPosition
@@state1:
	ld a,($cfc0)
	inc a
	ret nz
	ld e,Interaction.state
	ld a,$02
	ld (de),a
	ld e,$43
	ld a,(de)
	ld hl,table_5b0d
	rst_addDoubleIndex
	ld e,$58
	ldi a,(hl)
	ld (de),a
	inc e
	ld a,(hl)
	ld (de),a
	ld h,d
	ld l,$46
	ld (hl),$14
	inc l
	ld (hl),$03
	call fastFadeoutToWhite
@@state2:
	ld a,$3c
	call setScreenShakeCounter
	call interactionDecCounter1
	ret nz
	ld (hl),$14
	inc l
	dec (hl)
	jp nz,fastFadeoutToWhite
	ld l,$44
	inc (hl)
	call clearPaletteFadeVariablesAndRefreshPalettes
	call getFreeInteractionSlot
	jr nz,@@state3
	ld (hl),INTERACID_D8_FREEZING_LAVA_EVENT
	inc l
	ld (hl),$04
	ld e,$58
	ld l,e
	ld a,(de)
	ldi (hl),a
	inc e
	ld a,(de)
	ld (hl),a
	ld l,$46
	ld (hl),$84
@@state3:
	ld a,$3c
	call setScreenShakeCounter
	ld a,($c4ab)
	or a
	ret nz
	call interactionDecCounter1
	ret nz
	ld (hl),$08
	ld a,$7a
	call playSound
	ld b,$d6
	call func_5af7
	ret nz
	jp interactionDelete
@func_5a0a:
	ld a,($cc57)
	inc a
	ld ($cc57),a
	call getActiveRoomFromDungeonMapPosition
	ld ($cc64),a
	ld a,($cfd0)
	ld ($cc66),a
	ld a,($cc49)
	or $80
	ld ($cc63),a
	xor a
	ld ($cc65),a
	ld a,$03
	ld (wWarpTransition2),a
	call getThisRoomFlags
	res 4,(hl)
	xor a
	ld ($cca4),a
	ld ($cc02),a
	jp interactionDelete
@subid1:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @@state0
	.dw @@state1
@@state0:
	ld a,$01
	ld (de),a
	call interactionInitGraphics
	call objectGetZAboveScreen
	ld e,$4f
	ld (de),a
	call objectSetVisiblec0
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERACID_D8_FREEZING_LAVA_EVENT
	inc l
	ld (hl),$02
	ld e,$59
	ld a,h
	ld (de),a
	jp objectCopyPosition
@@state1:
	ld e,$59
	ld a,(de)
	ld h,a
	ld l,$4a
	ld e,l
	ld b,$06
	call copyMemoryReverse
	ld c,$08
	call objectUpdateSpeedZ_paramC
	ret nz
	ldbc INTERACID_D8_FREEZING_LAVA_EVENT $03
	call objectCreateInteraction
	jr nz,+
	ld a,$01
	ld ($cfc0),a
+
	jp interactionDelete
@subid2:
	ld e,Interaction.state
	ld a,(de)
	or a
	jr nz,+
	ld a,$01
	ld (de),a
	call interactionInitGraphics
	call objectSetVisible83
+
	ld a,($cfc0)
	or a
	jp nz,interactionDelete
	jp interactionAnimate
@subid3:
	ld e,Interaction.state
	ld a,(de)
	or a
	jr nz,+
	ld a,$01
	ld (de),a
	call interactionInitGraphics
	call objectSetVisible83
	ld a,$5c
	call playSound
+
	call interactionAnimate
	ld e,$61
	ld a,(de)
	inc a
	ret nz
	ld a,$ff
	ld ($cfc0),a
	call objectGetShortPosition
	ld c,a
	ld a,$d5
	call setTile
	jp interactionDelete
@subid4:
	ld a,($c4ab)
	or a
	ret nz
	call interactionDecCounter1
	ret nz
	ld (hl),$08
	ld b,$d7
	call func_5af7
	ret nz
	jp @func_5a0a
func_5ae0:
	ld hl,$d080
-
	ld a,(hl)
	or a
	call nz,func_5aef
	inc h
	ld a,h
	cp $e0
	jr c,-
	ret
func_5aef:
	xor a
	ld l,$9a
	ld (hl),a
	ld l,$80
	ld (hl),a
	ret
func_5af7:
	ld h,d
	ld l,$58
	ld e,l
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	ldi a,(hl)
	or a
	ret z
	ld c,a
	ld a,l
	ld (de),a
	inc e
	ld a,h
	ld (de),a
	ld a,b
	call setTile
	or d
	ret
table_5b0d:
	.dw table_5b15
	.dw table_5b3f
	.dw table_5b73
	.dw table_5bbb
table_5b15:
	.db $34 $44 $43 $45 $42 $46 $41 $47
	.db $53 $55 $52 $31 $37 $21 $27 $28
	.db $11 $17 $18 $51 $62 $61 $64 $66
	.db $67 $68 $74 $73 $75 $72 $76 $71
	.db $77 $81 $82 $83 $84 $85 $86 $87
	.db $88 $00
table_5b3f:
	.db $27 $37 $36 $47 $38 $46 $48 $35
	.db $39 $3a $4a $49 $59 $58 $57 $56
	.db $45 $44 $55 $54 $2a $1a $1b $53
	.db $63 $64 $4b $5b $5a $1c $2c $3c
	.db $6a $69 $68 $67 $66 $62 $76 $77
	.db $6b $5c $6c $7c $7b $7a $79 $78
	.db $72 $73 $74 $00
table_5b73:
	.db $37 $47 $57 $46 $56 $66 $67 $48
	.db $58 $68 $45 $55 $65 $49 $59 $69
	.db $64 $54 $44 $34 $5a $6a $6b $5b
	.db $4b $7b $7a $79 $5c $6c $7c $74
	.db $73 $63 $53 $43 $77 $78 $3a $2a
	.db $1a $33 $23 $22 $32 $42 $52 $62
	.db $72 $24 $14 $13 $03 $02 $12 $04
	.db $05 $3b $2b $1b $0b $2c $3c $4c
	.db $0a $09 $08 $0c $1c $06 $07 $00
table_5bbb:
	.db $79 $89 $88 $99 $8a $87 $97 $98
	.db $9a $9b $8b $76 $86 $9c $9d $8d
	.db $7d $6d $5d $2d $2c $2a $29 $4d
	.db $3d $4c $4a $3c $3b $49 $38 $3a
	.db $39 $75 $85 $65 $95 $84 $94 $27
	.db $26 $24 $00


; ==============================================================================
; INTERACID_DANCE_HALL_MINIGAME
; ==============================================================================
interactionCode6a:
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw @subid0
	.dw @subid1
	.dw @subid2
	.dw @subid3
@subid0:
	ld a,$01
	ld ($ccea),a
	ld b,$20
	ld hl,$cfc0
	call clearMemory
	ld hl,objectData.objectData7e6c
	call parseGivenObjectData
	jp interactionDelete
@subid1:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @@state0
	.dw @@state1
	.dw @@state2
	.dw @@state3
	.dw @@state4
	.dw @@state5
@@state0:
	call @@func_5c21
	ld hl,mainScripts.dancecLeaderScript_promptToStartDancing
	jp interactionSetScript
@@func_5c21:
	ld a,$01
	ld (de),a
	call interactionSetAlwaysUpdateBit
	ld l,$48
	ld (hl),$02
	inc l
	ld (hl),$10
	call interactionInitGraphics
	jp objectSetVisiblec2
@@state2:
	ld c,$28
	call objectUpdateSpeedZ_paramC
	call interactionRunScript
	jp interactionAnimate
@@state3:
	call interactionAnimate
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @@@substate0
	.dw interactionRunScript
	.dw @@@substate2
@@@substate0:
	ld a,$01
	ld (de),a
	ld ($cfda),a
	ld a,$50
	ld ($cfd3),a
	ld hl,mainScripts.danceLeaderScript_promptForTutorial
	jp interactionSetScript
@@@substate2:
	ld a,($c4ab)
	or a
	ret nz
	xor a
	ld h,d
	ld l,e
	ldd (hl),a
	inc (hl)
	ld a,$01
	call setLinkIDOverride
	jp fastFadeinFromWhite

@@func_5c6f:
	ld a,$01
	ld ($cfd2),a
	ld a,$04
	jr +++

@@func_5c78:
	ld a,$ff
	ld ($cfd2),a
	ld a,$04
	jr +++

@@func_5c81:
	ld a,$05
	jr +++
	
	ld a,$03
+++
	ld ($cfd4),a
	ld a,$09
	ld ($cfd1),a
	ld hl,$cfda
	inc (hl)
	ret

@@state4:
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @@@substate0
	.dw @@@substate1
	.dw @@@substate2
	.dw @@@substate3
	.dw @@@substate4
@@@substate0:
	ld a,$01
	ld (de),a
	ld a,(wNumTimesPlayedSubrosianDance)
	cp $08
	jr c,+
	ld a,$08
+
	ld ($cfd7),a
	ld ($cfdc),a
	call @@@func_5cdd
	ld a,($cfd7)
	ld hl,@@@table_5d0b
	rst_addAToHl
	call getRandomNumber
	and $03
	add (hl)
	ld ($cfd5),a
	xor a
	ld ($cfd4),a
	ld ($cfdb),a
	ld a,$cc
	call playSound
	ld e,$47
	ld a,$3c
	ld (de),a
	ld a,$22
	jp playSound
@@@func_5cdd:
	ld a,($cfd7)
	ld hl,@@@table_5ced
	rst_addDoubleIndex
	ldi a,(hl)
	ld ($cfd3),a
	ldi a,(hl)
	ld ($cfd6),a
	ret
@@@table_5ced:
	.db $28 $20
	.db $32 $1e
	.db $32 $1c
	.db $3c $1a
	.db $3c $18
	.db $46 $16
	.db $46 $14
	.db $50 $14
	.db $50 $12
	.db $5a $12
	.db $64 $10
	.db $64 $10
	.db $64 $0e
	.db $78 $0d
	.db $78 $0c
@@@table_5d0b:
	.db $09 $09 $0a
	.db $0c $0e $10
	.db $12 $14 $18
@@@substate1:
	call interactionDecCounter2
	ret nz
	ld (hl),$01
	ld a,$02
	ld (de),a
	ld hl,$cfc8
	call @func_5ec4
	ldi (hl),a
	call @func_5ec4
	ldi (hl),a
	call @func_5ec4
	ldi (hl),a
	xor a
	ld (hl),a
	ld e,$46
	ld a,($cfd6)
	ld (de),a
	call @func_5eb9
@@@substate2:
	call @func_5f1d
	ret nz
	ld a,($cfcb)
	cp $03
	jr z,+
	jp @func_5ee1
+
	call interactionIncSubstate
	ld a,($cfd6)
	ld l,$46
	ld (hl),a
	xor a
	ld ($cfcb),a
	ld ($cfd9),a
	ld a,$ff
	ld ($cfd8),a
	ld a,$02
	call interactionSetAnimation
@@@substate3:
	call @func_5e97
	jr nz,@@@func_5d91
	call @func_5f1d
	ret nz
	ld a,($cfd1)
	or a
	ret nz
	ld a,($cfcb)
	cp $03
	jr z,+
	jp @func_5eea
+
	ld a,($cfd9)
	cp $03
	jr nz,@@@func_5d91
	ld hl,$cfd5
	dec (hl)
	jr z,@@@func_5dab
	call @@func_5e77
	ld e,Interaction.substate
	ld a,$01
	ld (de),a
	xor a
	ld ($cfcb),a
	ret
@@@func_5d91:
	ld bc,TX_0104
	call showText
	ld a,$04
	ld e,Interaction.substate
	ld (de),a
	ld a,$ff
	ld ($cfd0),a
	ld a,$cc
	call playSound
	ld a,$fb
	jp playSound
@@@func_5dab:
	call interactionIncState
	inc l
	ld (hl),$00
	ld a,$01
	ld ($cfd0),a
	ld a,$fb
	call playSound
	ld bc,TX_010a
	jp showText
@@@substate4:
	call retIfTextIsActive
	ld hl,@@@warpDestVariables
	jp setWarpDestVariables
@@@warpDestVariables:
	m_HardcodedWarpA ROOM_SEASONS_124 $00 $14 $03
@@state5:
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @@@substate0
	.dw @@@substate1
	.dw @@@substate2
	.dw interactionRunScript
	.dw @@state4@substate4
@@@substate0:
	call retIfTextIsActive
	ld e,Interaction.substate
	ld a,$01
	ld (de),a
	jp fastFadeoutToWhite
@@@substate1:
	ld a,($c4ab)
	or a
	ret nz
	xor a
	call setLinkIDOverride
	ld l,$0b
	ld (hl),$30
	ld l,$0d
	ld (hl),$48
	ld l,$08
	ld (hl),$02
	call interactionIncSubstate
	ld a,$81
	ld ($cca4),a
	ld ($cbca),a
	ld a,$1e
	call addToGashaMaturity
	jp fastFadeinFromWhite
@@@substate2:
	ld a,($c4ab)
	or a
	ret nz
	ld a,$81
	ld ($cca4),a
	ld ($cc02),a
	ld hl,wNumTimesPlayedSubrosianDance
	call incHlRefWithCap
	ld a,(hl)
	dec a
	jr z,@@@func_5e25
	cp $08
	jr z,@@@func_5e40
	cp $05
	jr nz,@@@func_5e56
	call checkIsLinkedGame
	jr nz,@@@func_5e56
	ld a,(wRickyState)
	and $20
	jr nz,@@@func_5e56
	ld hl,mainScripts.danceLeaderScript_giveFlute
	jr @@@func_5e68
@@@func_5e40:
	callab scriptHelp.seasonsFunc_15_5e20
	bit 7,b
	jr nz,+
	ld c,$00
	call giveRingToLink
	ld hl,mainScripts.danceLeaderScript_itemGiven
	jr @@@func_5e68
@@@func_5e56:
	call getRandomNumber
	cp $60
	ld hl,mainScripts.danceLeaderScript_giveOreChunks
	jr nc,@@@func_5e68
+
	ld hl,mainScripts.danceLeaderScript_gashaSeed
	jr @@@func_5e68
@@@func_5e25:
	ld hl,mainScripts.danceLeaderScript_boomerang
@@@func_5e68:
	call interactionSetScript
	ld e,Interaction.substate
	ld a,$03
	ld (de),a
	ret
@@state1:
	call interactionRunScript
	jp npcFaceLinkAndAnimate
@@func_5e77:
	ld hl,$cfdb
	ld a,(hl)
	cp $08
	jr c,+
	ld a,$08
+
	inc a
	ld (hl),a
	ld b,a
	and $03
	ret nz
	ld a,b
	rrca
	rrca
	and $03
	ld b,a
	ld a,($cfd7)
	add b
	ld ($cfd7),a
	jp @@state4@func_5cdd
@func_5e97:
	ld a,($cfdd)
	or a
	ret nz
	ld a,($cfd8)
	ld b,a
	inc a
	ret z
	ld a,($cfd9)
	cp $03
	ret z
	ld hl,$cfd9
	inc (hl)
	ld hl,$cfc8
	rst_addAToHl
	ld a,(hl)
	cp b
	ret nz
	ld a,$ff
	ld ($cfd8),a
	ret
@func_5eb9:
	ld a,$02
	call interactionSetAnimation
	ld bc,$fe80
	jp objectSetSpeedZ
@func_5ec4:
	call getRandomNumber
	and $0f
	ld bc,@table_5ed1
	call addAToBc
	ld a,(bc)
	ret
@table_5ed1:
	.db $00 $00 $00 $00
	.db $00 $00 $00 $00
	.db $01 $01 $01 $01
	.db $02 $02 $02 $02
@func_5ee1:
	call @func_5efd
	ld a,e
	call interactionSetAnimation
	jr +
@func_5eea:
	call @func_5efd
	ldh a,(<hFF8B)
	call @func_5f10
+
	ld hl,$cfcb
	inc (hl)
	ld e,$46
	ld a,($cfd6)
	ld (de),a
	ret
@func_5efd:
	ld a,($cfcb)
	ld hl,$cfc8
	rst_addAToHl
	ld a,(hl)
	ldh (<hFF8B),a
	ld hl,@table_5f17
	rst_addDoubleIndex
	ldi a,(hl)
	ld e,(hl)
	jp playSound
@func_5f10:
	rst_jumpTable
	.dw @subid1@func_5c6f
	.dw @subid1@func_5c78
	.dw @subid1@func_5c81
@table_5f17:
	; sound - stored in e (unused?)
	.db SND_DANCE_MOVE,    $05
	.db SND_SEEDSHOOTER,   $06
	.db SND_GORON_DANCE_B, $04
@func_5f1d:
	ld c,$28
	call objectUpdateSpeedZ_paramC
	call interactionAnimate
	ld h,d
	ld l,$61
	ld a,(hl)
	or a
	jr z,+
	inc a
	jr z,+
	dec a
	ld (hl),$00
	ld l,$4d
	add (hl)
	ld (hl),a
+
	ld l,$46
	ld a,(hl)
	or a
	ret z
	dec (hl)
	ret
@subid2:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @@state0
	.dw @@state1
	.dw @@state2
	.dw @@state3
	.dw @@state4
	.dw @@state5
	.dw interactionAnimate
@@state0:
	call @subid1@func_5c21
	ld e,$4d
	ld a,(de)
	ld hl,@@table_5f72
	rst_addAToHl
	ld e,$72
	ld a,(hl)
	ld (de),a
	ld a,>TX_0100
	inc e
	ld (de),a
	ld h,d
	ld l,$7b
	ld (hl),$01
	ld l,$4b
	ld a,(hl)
	call setShortPosition
	ld hl,mainScripts.danceLeaderScript_showLoadedText
	jp interactionSetScript
@@table_5f72:
	.db <TX_010b, <TX_010c, <TX_010d
	.db <TX_010e, <TX_010f, <TX_0110
	.db <TX_0111, <TX_0112, <TX_0113
@@state1:
	ld a,($cfda)
	or a
	jr nz,+
	call interactionRunScript
	jp npcFaceLinkAndAnimate
+
	ld e,Interaction.state
	ld a,$02
	ld (de),a
	ld a,$02
	jp interactionSetAnimation
@@state2:
	call @func_60a4
	jr c,@@func_5fb8
	call interactionAnimate
	ld a,($cfd0)
	or a
	jr nz,@@func_5fb8
	ld h,d
	ld l,$7b
	ld a,($cfda)
	cp (hl)
	ret z
	ld (hl),a
	ld a,($cfd4)
	ld l,$44
	ld (hl),a
	cp $04
	call z,@@func_5fc3
	xor a
	ld e,$78
	ld (de),a
	ret
@@func_5fb8:
	ld a,$02
	call interactionSetAnimation
	ld e,Interaction.state
	ld a,$06
	ld (de),a
	ret
@@func_5fc3:
	call objectGetShortPosition
	ld c,a
	ld hl,@@table_5ff1
-
	ldi a,(hl)
	cp c
	jr z,+
	inc hl
	jr -
+
	ld a,($cfd2)
	bit 7,a
	jr nz,+
	ld a,(hl)
	jr ++
+
	ld a,(hl)
	swap a
++
	and $0f
	ld e,$48
	ld (de),a
	ldh (<hFF8B),a
	call interactionSetAnimation
	ldh a,(<hFF8B)
	swap a
	rrca
	ld e,$49
	ld (de),a
	ret
@@table_5ff1:
	.db $11 $21
	.db $21 $20
	.db $31 $20
	.db $41 $20
	.db $51 $20
	.db $61 $10
	.db $62 $13
	.db $63 $13
	.db $64 $13
	.db $65 $13
	.db $66 $03
	.db $56 $02
	.db $46 $02
	.db $36 $02
	.db $26 $02
	.db $16 $32
	.db $15 $31
	.db $14 $31
	.db $13 $31
	.db $12 $31
@@state3:
	ld a,$02
	ld (de),a
	ld a,$02
	call interactionSetAnimation
	jr @func_6037
@@state4:
	call @func_603f
	ret c
	ld l,$44
	ld (hl),$02
	jr @func_6037
@@state5:
	ld a,$02
	ld (de),a
	ld a,$04
	call interactionSetAnimation
	jr @func_6037
@func_6037:
	ld hl,$cfd1
	ld a,(hl)
	or a
	ret z
	dec (hl)
	ret
@func_603f:
	ld h,d
	ld e,$4b
	ld l,$79
	ld a,(de)
	ldi (hl),a
	ld e,$4d
	ld a,(de)
	ld (hl),a
	ld a,($cfd3)
	ld e,$50
	ld (de),a
	call objectApplySpeed
	call @func_6058
	jr @func_607e
@func_6058:
	ld h,d
	ld l,$4b
	call @func_6061
	ld h,d
	ld l,$4d
@func_6061:
	ld a,$17
	cp (hl)
	inc a
	jr nc,+
	ld a,$68
	cp (hl)
	ret nc
+
	ld (hl),a
	ld a,($cfd2)
	ld l,$48
	add (hl)
	and $03
	ldi (hl),a
	ld b,a
	swap a
	rrca
	ld (hl),a
	ld a,b
	jp interactionSetAnimation
@func_607e:
	ld e,$4b
	ld a,(de)
	ld b,a
	ld e,$79
	ld a,(de)
	sub b
	jr nc,+
	cpl
	inc a
+
	ld c,a
	ld e,$4d
	ld a,(de)
	ld b,a
	ld e,$7a
	ld a,(de)
	sub b
	jr nc,+
	cpl
	inc a
+
	add c
	ld b,a
	ld e,$78
	ld a,(de)
	add b
	ld (de),a
	cp $10
	ret c
	jp objectCenterOnTile
@func_60a4:
	call objectCheckCollidedWithLink
	ret nc
	ld a,$01
	ld ($cfdd),a
	ret
@subid3:
	ld e,Interaction.state
	ld a,(de)
	or a
	jr nz,+
	ld a,$01
	ld (de),a
	ld e,$40
	ld a,$81
	ld (de),a
	call interactionInitGraphics
+
	ld a,($cfdf)
	ld b,a
	or a
	jp z,objectSetInvisible
	call objectSetVisible80
	ld a,b
	cp $ff
	jp z,interactionDelete
	add a
	add b
	ld hl,@table_60e2
	rst_addAToHl
	ldi a,(hl)
	ld e,$4b
	ld (de),a
	ld e,$4d
	ldi a,(hl)
	ld (de),a
	ld a,(hl)
	jp interactionSetAnimation
@table_60e2:
	.db $30 $58 $07
	.db $30 $58 $07
	.db $30 $38 $08
	.db $30 $58 $09


; ==============================================================================
; INTERACID_S_MISCELLANEOUS_1
; ==============================================================================
interactionCode6b:
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	/* $00 */ .dw floodgateKeeper
	/* $01 */ .dw floodgateKeeperSwitchScript
	/* $02 */ .dw floodgateKeyhole
	/* $03 */ .dw d4KeyHole
	/* $04 */ .dw floodgateKey
	/* $05 */ .dw dragonKey
	/* $06 */ .dw tarmArmosUnlockingStairs
	/* $07 */ .dw tarmArmosWallByStump
	/* $08 */ .dw tarmEscapedLostWoods
	/* $09 */ .dw oreChunkDigSpot
	/* $0a */ .dw staticHeartPiece
	/* $0b */ .dw permanentlyRemovableObjects
	/* $0c */ .dw piratesBellRoomWhenFallingIn
	/* $0d */ .dw greenJoyRing
	/* $0e */ .dw masterDiverPuzzle
	/* $0f */ .dw piratesBell
	/* $10 */ .dw armosBlockingFlowerPathToD6
	/* $11 */ .dw natzuSwitch
	/* $12 */ .dw onoxCastleCutscene
	/* $13 */ .dw savingZeldaNoEnemiesHandler
	/* $14 */ .dw unblockingD3Dam
	/* $15 */ .dw replacePirateShipWithQuicksand
	/* $16 */ .dw stolenFeatherGottenHandler
	/* $17 */ .dw horonVillagePortalBridgeSpawner
	/* $18 */ .dw randomRingDigSpot
	/* $19 */ .dw staticGashaSeed
	/* $1a */ .dw underwaterGashaSeed
	/* $1b */ .dw tickTockSecretEntrance
	/* $1c */ .dw graveSecretEntrance
	/* $1d */ .dw d4MinibossRoom
	/* $1e */ .dw sentBackFromOnoxCastleBarrier
	/* $1f */ .dw sidescrollingStaticGashaSeed
	/* $20 */ .dw sidescrollingStaticSeedSatchel
	/* $21 */ .dw mtCuccoBananaTree
	/* $22 */ .dw hardOre
	.dw interactionCode6bSubid23
	.dw interactionCode6bSubid24
	.dw interactionCode6bSubid25
	.dw interactionCode6bSubid26

floodgateKeeper:
	call checkInteractionState
	jr nz,@state1
	ld a,$01
	ld (de),a
	call interactionInitGraphics
	ld hl,mainScripts.floodgateKeeperScript
	call interactionSetScript
	call objectSetVisible82
	xor a
	ld ($cfc1),a
@state1:
	call interactionAnimate
	call objectPreventLinkFromPassing
	jp interactionRunScript

floodgateKeeperSwitchScript:
	call checkInteractionState
	jr nz,@state1
	ld a,$01
	ld (de),a
	call getThisRoomFlags
	bit 6,(hl)
	jr z,+
	ld bc,wRoomLayout|$68
	ld a,TILEINDEX_DUNGEON_SWITCH_ON
	ld (bc),a
	jp interactionDelete
+
	call interactionInitGraphics
	call objectSetVisible83
	call objectSetInvisible
	xor a
	ld (wSwitchState),a
	ld hl,mainScripts.floodgateSwitchScript
	jp interactionSetScript
@state1:
	call interactionAnimate
runScriptDeleteWhenDone:
	call interactionRunScript
	ret nc
	jp interactionDelete

floodgateKeyhole:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw interactionRunScript
	.dw @state2
@state0:
	ld a,$01
	ld (de),a
	call getThisRoomFlags
	bit 7,(hl)
	jp nz,interactionDelete
	ld hl,mainScripts.floodgateKeyholeScript_keyEntered
	jp interactionSetScript
@state2:
	ld a,$04
	call setScreenShakeCounter
	ld a,($cfc0)
	bit 7,a
	ret z
	ld a,($cc62)
	ld (wActiveMusic),a
	call playSound
	jr ++

resetMusicThenSolvePuzzleSound:
	ld a,$ff
	ld (wActiveMusic),a
++
	xor a
	ld ($cc02),a
	ld ($cca4),a
	ld a,$f1
	call playSound
	ld a,SND_SOLVEPUZZLE
	call playSound
	jp interactionDelete


d4KeyHole:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3
	.dw @state4
@state0:
	ld a,$01
	ld (de),a
	call getThisRoomFlags
	bit 7,(hl)
	jp nz,interactionDelete
	call objectSetReservedBit1
	ld a,$01
	ld (wScreenShakeMagnitude),a
	ld hl,mainScripts.d4KeyholeScript_disableThingsAndScreenShake
	jp interactionSetScript
@state1:
	ld a,(wActiveRoom)
	cp <ROOM_SEASONS_00d
	jp nz,interactionDelete
	call interactionRunScript
	ret nc
	call interactionIncState
	ld hl,scripts2.simpleScript_waterfallEmptyingAboveD4
	jp interactionSetSimpleScript
@func_621c:
	ld h,d
	ld l,$46
	ld a,(hl)
	or a
	ret z
	dec (hl)
	ret
@state2:
	call @func_621c
	ret nz
	call interactionRunSimpleScript
	ret nc
	call interactionIncState
	ld a,$1d
	ld b,$02
	call func_1383
	callab scriptHelp.d4KeyHolw_disableAllSorts
	ret
@state3:
	ld a,($cd00)
	and $01
	ret z
	call getThisRoomFlags
	set 7,(hl)
	call interactionIncState
	ld hl,scripts2.simpleScript_waterfallEmptyingAtD4
	jp interactionSetSimpleScript
@state4:
	ld a,$3c
	call setScreenShakeCounter
	call @func_621c
	ret nz
	call interactionRunSimpleScript
	ret nc
	ld hl,@warpDestVariables
	call setWarpDestVariables
	jp resetMusicThenSolvePuzzleSound
@warpDestVariables:
	.db $c0 $0d $01 $23 $03

floodgateKey:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw interactionRunScript
@state0:
	call getThisRoomFlags
	and $60
	cp $40
	ret nz
	ldbc TREASURE_FLOODGATE_KEY $00
	call misc1_spawnTreasureBC
	jp interactionIncState
@state1:
	ld a,TREASURE_FLOODGATE_KEY
	call checkTreasureObtained
	ret nc
	call interactionIncState
	ld hl,$cca4
	set 7,(hl)
	ld a,$01
	ld ($cc02),a
	ld hl,mainScripts.floodgateKeyScript_keeperNoticesKey
	jp interactionSetScript

dragonKey:
	ldbc TREASURE_DRAGON_KEY $00
	jp misc1_spawnTreasureBCifRoomFlagBit5NotSet
	
tarmArmosUnlockingStairs:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw runScriptDeleteWhenDone
@state0:
	call getThisRoomFlags
	and $40
	jp nz,interactionDelete
	call interactionIncState
	ld hl,mainScripts.tarmArmosUnlockingStairsScript
	jp interactionSetScript
@state1:
	call objectGetTileAtPosition
	cp $04
	ret nz
	call interactionIncState
	jp runScriptDeleteWhenDone

tarmArmosWallByStump:
	ld a,($cc4c)
	cp $42
	jp nz,interactionDelete
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
@state0:
	ld a,$01
	ld (de),a
	ld a,(wRoomStateModifier)
	cp SEASON_WINTER
	jp nz,interactionDelete
	call getThisRoomFlags
	ld e,$4b
	ld a,(de)
	and (hl)
	jp nz,interactionDelete
	jp objectSetReservedBit1
@state1:
	ld a,(wRoomStateModifier)
	cp SEASON_WINTER
	jp nz,interactionDelete
	ld e,$4d
	ld a,(de)
	ld l,a
	ld h,$cf
	ld a,$9c
	cp (hl)
	ret nz
	jp interactionIncState
@state2:
	ld a,(wRoomStateModifier)
	cp SEASON_WINTER
	ret z
	ld a,($c4ab)
	or a
	ret z
	call getThisRoomFlags
	ld e,$4b
	ld a,(de)
	or (hl)
	ld (hl),a
	ld e,$4d
	ld a,(de)
	dec a
	ld c,a
	ld a,$09
	call setTile
	inc c
	ld a,$bc
	call setTile
	jr ++

tarmEscapedLostWoods:
	call returnIfScrollMode01Unset
	ld a,($cd02)
	or a
	jp nz,interactionDelete
++
	ld a,$4d
	call playSound
	jp interactionDelete

oreChunkDigSpot:
	call checkInteractionState
	jr nz,@state1
	ld a,$01
	ld (de),a
	ld e,$43
	ld a,(de)
	or a
	jr nz,+
	call getThisRoomFlags
	and $20
	jp nz,interactionDelete
+
	call objectGetShortPosition
	ld ($ccc5),a
@state1:
	ld a,($ccc5)
	inc a
	ret nz
	call getFreePartSlot
	ret nz
	ld (hl),PARTID_ITEM_DROP
	inc l
	ld (hl),$0e
	inc l
	ld (hl),$01
	ld a,($d008)
	swap a
	rrca
	ld l,$c9
	ld (hl),a
	call objectCopyPosition
	jp interactionDelete
	
staticHeartPiece:
	ldbc TREASURE_HEART_PIECE $00
misc1_spawnTreasureBCifRoomFlagBit5NotSet:
	call getThisRoomFlags
	and $20
	jr nz,+
	call misc1_spawnTreasureBC
+
	jp interactionDelete

misc1_spawnTreasureBC:
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERACID_TREASURE
	inc l
	ld (hl),b
	inc l
	ld (hl),c
	jp objectCopyPosition

; eg rocks, ember trees that should stay removed
permanentlyRemovableObjects:
	call checkInteractionState
	jr nz,@state1
	call returnIfScrollMode01Unset
	call getThisRoomFlags
	ld e,Interaction.xh
	ld a,(de)
	and (hl)
	jp nz,interactionDelete
	ld b,>wRoomLayout
	ld e,Interaction.yh
	ld a,(de)
	ld c,a
	ld a,(bc)
	ld e,Interaction.var03
	ld (de),a
	ld e,Interaction.state
	ld a,$01
	ld (de),a
@state1:
	ld a,(wScrollMode)
	and $01
	jp z,interactionDelete
	ld e,Interaction.var03
	ld a,(de)
	ld b,a
	ld e,Interaction.yh
	ld a,(de)
	ld l,a
	ld h,>wRoomLayout
	ld a,b
	cp (hl)
	ret z
	call getThisRoomFlags
	ld e,Interaction.xh
	ld a,(de)
	or (hl)
	ld (hl),a
	jp interactionDelete

piratesBellRoomWhenFallingIn:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw runScriptDeleteWhenDone
@state0:
	call getThisRoomFlags
	and $20
	jp nz,interactionDelete
	call interactionIncState
@state1:
	call getThisRoomFlags
	and $20
	ret z
	ld hl,$cca4
	set 0,(hl)
	ld a,$01
	ld ($cc02),a
	call interactionIncState
	ld hl,mainScripts.piratesBellRoomDroppingInScript
	jp interactionSetScript

greenJoyRing:
	call getThisRoomFlags
	and $20
	jp nz,interactionDelete
	ld a,(wActiveTriggers)
	or a
	ret z
	ldbc GREEN_JOY_RING $01
createRingTreasureAtPosition:
	call createRingTreasure
	ret nz
	call objectCopyPosition
	jp interactionDelete

masterDiverPuzzle:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3
@state0:
	call getThisRoomFlags
	bit 5,(hl)
	jp nz,interactionDelete
	ld h,d
	ld l,$44
	ld (hl),$01
	ld l,$70
	ld b,$06
	jp clearMemory
@state1:
	call @checkLinkSwordSpin
	ret nz
	ld a,$02
	ld (de),a
@state2:
	call @checkLinkSwordSpin
	jr nz,@state0
	ld a,(wccaf)
	cp $2b
	jr z,+
	cp TILEINDEX_PUSHABLE_STATUE
	ret nz
+
	ld h,d
	ld l,$70
	ld a,(wccb0)
	ld c,a
-
	ldi a,(hl)
	cp c
	ret z
	or a
	jr nz,-
	dec l
	ld (hl),c
	ld a,l
	cp $73
	jr nc,+
	ret
+
	ld l,$44
	ld (hl),$03
	ld hl,mainScripts.masterDiverPuzzleScript_solved
	call interactionSetScript
@state3:
	call interactionRunScript
	jp c,interactionDelete
	ret
@checkLinkSwordSpin:
	ld a,(wcc63)
	and $0f
	cp $02
	ret

piratesBell:
	ldbc TREASURE_PIRATES_BELL $00
	jp misc1_spawnTreasureBCifRoomFlagBit5NotSet

armosBlockingFlowerPathToD6:
	call returnIfScrollMode01Unset
	call getThisRoomFlags
	bit 7,(hl)
	jp nz,interactionDelete
	bit 6,(hl)
	jp nz,interactionDelete
	call objectGetTileAtPosition
	cp $d6
	ret z
	ld a,(wBlockPushAngle)
	and $7f
	cp ANGLE_LEFT
	ld b,$80
	jr z,+
	ld b,$40
+
	call getThisRoomFlags
	or b
	ld (hl),a
	jp interactionDelete

natzuSwitch:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
@state0:
	ld a,$01
	ld (de),a
	ld a,(wAnimalCompanion)
	cp SPECIALOBJECTID_DIMITRI
	jp z,interactionDelete
	call getThisRoomFlags
	and $40
	jp nz,interactionDelete
	call getFreePartSlot
	ret nz
	ld (hl),PARTID_SWITCH
	inc l
	ld (hl),$01
	jp objectCopyPosition
@state1:
	ld a,(wSwitchState)
	or a
	ret z
	ld a,$81
	ld ($cc02),a
	ld ($cca4),a
	ld ($ccab),a
	call getThisRoomFlags
	set 6,(hl)
	call interactionIncState
	ld hl,scripts2.simpleScript_creatingBridgeToNatzu
	jp interactionSetSimpleScript
@state2:
	call d4KeyHole@func_621c
	ret nz
	call interactionRunSimpleScript
	ret nc
	xor a
	ld ($cc02),a
	ld ($cca4),a
	ld ($ccab),a
	jp interactionDelete

onoxCastleCutscene:
	ld a,GLOBALFLAG_WITCHES_2_SEEN
	call checkGlobalFlag
	jp nz,interactionDelete
	ld a,GLOBALFLAG_ZELDA_KIDNAPPED_SEEN
	call checkGlobalFlag
	jp nz,interactionDelete
	ld a,$01
	ld ($cca4),a
	ld ($cc02),a
	call returnIfScrollMode01Unset
	ld a,CUTSCENE_S_ONOX_CASTLE_FORCE
	ld (wCutsceneTrigger),a
	xor a
	ld ($d008),a
	call dropLinkHeldItem
	call clearAllParentItems
	jp interactionDelete

savingZeldaNoEnemiesHandler:
	ld a,GLOBALFLAG_IMPA_ASKED_TO_SAVE_ZELDA
	call checkGlobalFlag
	ret z
	ld a,GLOBALFLAG_ZELDA_SAVED_FROM_VIRE
	call checkGlobalFlag
	ret nz
	ld a,$80
	ld (wcc85),a
	jp interactionDelete

unblockingD3Dam:
	ld h,d
	ld l,$46
	ld a,(hl)
	or a
	jr z,+
	dec (hl)
	ret nz
+
	call checkInteractionState
	jr nz,@state1
	call interactionIncState
	ld hl,scripts2.simpleScript_unblockingD3Dam
	jp interactionSetSimpleScript
@state1:
	call interactionRunSimpleScript
	ret nc
	ld hl,$cfc0
	set 7,(hl)
	jp interactionDelete
	
replacePirateShipWithQuicksand:
	ld a,GLOBALFLAG_PIRATE_SHIP_DOCKED
	call checkGlobalFlag
	jp z,interactionDelete
	ld b,INTERACID_QUICKSAND
	call objectCreateInteractionWithSubid00
	jp interactionDelete
	
stolenFeatherGottenHandler:
	call checkInteractionState
	jr nz,@state1
	call objectGetTileAtPosition
	ld h,d
	ld l,$49
	ld (hl),a
	ld l,$44
	inc (hl)
@state1:
	ld a,$01
	ld ($ccab),a
	call objectGetTileAtPosition
	ld e,$49
	ld a,(de)
	cp (hl)
	ret z
	xor a
	ld ($ccab),a
	jp interactionDelete
	
horonVillagePortalBridgeSpawner:
	call checkInteractionState
	jr nz,@state1
	xor a
	ld (wSwitchState),a
	call getThisRoomFlags
	and $40
	jp nz,interactionDelete
	call interactionIncState
@state1:
	ld a,(wSwitchState)
	or a
	ret z
	call getThisRoomFlags
	set 6,(hl)
	ld a,$4d
	call playSound
	ld bc,$0047
	ld e,$08
	call @spawnBridge
	ld bc,$0114
	ld e,$06
	call @spawnBridge
	jp interactionDelete
@spawnBridge:
	call getFreePartSlot
	ret nz
	ld (hl),PARTID_BRIDGE_SPAWNER
	ld l,$c7
	ld (hl),e
	ld l,$c9
	ld (hl),b
	ld l,$cb
	ld (hl),c
	ret

; Under Vasu's sign, and by wilds ore
randomRingDigSpot:
	call getThisRoomFlags
	and $20
	jp nz,interactionDelete
	ld c,$02
	call getRandomRingOfGivenTier
	ld b,c
	ld c,$03
	jp createRingTreasureAtPosition

staticGashaSeed:
	ldbc TREASURE_GASHA_SEED $04
	jp misc1_spawnTreasureBCifRoomFlagBit5NotSet

underwaterGashaSeed:
	ldbc TREASURE_GASHA_SEED $05
	jp misc1_spawnTreasureBCifRoomFlagBit5NotSet

tickTockSecretEntrance:
	call checkInteractionState
	jr nz,@state1
	call objectGetTileAtPosition
	cp $04
	ret nz
	ld a,l
	ld ($ccc5),a
	ld e,Interaction.state
	ld a,$01
	ld (de),a
	ret
@state1:
	call returnIfScrollMode01Unset
	call objectGetTileAtPosition
	cp $04
	ret z
setEnteredWarpSetStairsPlaySolvedSound:
	ld c,l
	ld a,c
	ld (wEnteredWarpPosition),a
	ld a,$e7
	call setTile
	ld a,$4d
	call playSound
	jp interactionDelete

graveSecretEntrance:
	call returnIfScrollMode01Unset
	call objectGetTileAtPosition
	cp $01
	ret z
	ld a,l
	ld ($ccc5),a
	jr setEnteredWarpSetStairsPlaySolvedSound

d4MinibossRoom:
	call checkInteractionState
	jr nz,+
	ld a,$01
	ld (de),a
	call getThisRoomFlags
	bit 7,(hl)
	jp nz,interactionDelete
	ld hl,objectData.objectData7e96
	jp parseGivenObjectData
+
	ld a,(wNumTorchesLit)
	cp $02
	ret nz
	call getThisRoomFlags
	set 7,(hl)
	jp interactionDelete
	
sentBackFromOnoxCastleBarrier:
	call checkInteractionState
	jr nz,@state1
	ld a,GLOBALFLAG_ONOX_CASTLE_BARRIER_GONE
	call checkGlobalFlag
	jp z,interactionDelete
	ld a,GLOBALFLAG_ONOX_CASTLE_BARRIER_GONE
	call unsetGlobalFlag
	ld h,d
	ld l,$44
	inc (hl)
	ld l,$46
	ld (hl),$3c
@state1:
	ld a,$01
	ld ($cca4),a
	call interactionDecCounter1
	ret nz
	xor a
	ld ($cc02),a
	ld ($cca4),a
	ld bc,TX_501b
	call showText
	jp interactionDelete
	
sidescrollingStaticGashaSeed:
	ldbc TREASURE_GASHA_SEED $04
	jp misc1_spawnTreasureBCifRoomFlagBit5NotSet

sidescrollingStaticSeedSatchel:
	ldbc TREASURE_SEED_SATCHEL $00
	jp misc1_spawnTreasureBCifRoomFlagBit5NotSet

mtCuccoBananaTree:
	ld a,($cc4e)
	or a
	jp nz,interactionDelete
	call getThisRoomFlags
	and $20
	jp nz,interactionDelete
	ldbc TREASURE_SPRING_BANANA $00
	call misc1_spawnTreasureBC
	ld b,h
	ld a,$06
	ldi (hl),a
	ld (hl),a
	call getFreePartSlot
	jp nz,interactionDelete
	ld (hl),PARTID_GASHA_TREE
	ld l,$d6
	ld (hl),$40
	inc l
	ld (hl),b
	jp interactionDelete

hardOre:
	call getThisRoomFlags
	and $40
	jp z,interactionDelete
	ldbc TREASURE_HARD_ORE $00
	jp misc1_spawnTreasureBCifRoomFlagBit5NotSet

; TODO: has 3 buttons, 2 keese (linked hero's cave?)
interactionCode6bSubid23:
	call checkInteractionState
	jr nz,@state1
	call getThisRoomFlags
	and $80
	jp nz,interactionDelete
	ld hl,wActiveTriggers
	ld a,(hl)
	cp $04
	jr nz,+
	set 7,(hl)
+
	cp $85
	jr nz,+
	set 6,(hl)
+
	and $07
	cp $07
	ret nz
	ld a,$1e
	ld e,$46
	ld (de),a
	jp interactionIncState
@state1:
	call interactionDecCounter1
	ret nz
	ld a,(wActiveTriggers)
	bit 6,a
	ld b,$5a
	jr z,+
	ld c,$5c
	ld a,$05
	call setTile
	call objectCreatePuff
	call getThisRoomFlags
	set 7,(hl)
	ld b,$4d
+
	ld a,b
	call playSound
	jp interactionDelete
	
; TODO: 4 orbs (linked hero's cave?)
interactionCode6bSubid24:
	ld a,(wToggleBlocksState)
	and $0f
	cp $0e
	ld a,$01
	jr z,+
	dec a
+
	ld (wActiveTriggers),a
	ret

; TODO: spawns up stair case when all enemies defeated
interactionCode6bSubid25:
	call checkInteractionState
	jr nz,@state1
	ld a,(wNumEnemies)
	or a
	ret nz
	call interactionIncState
	ld l,$46
	ld (hl),$3c
@state1:
	call interactionDecCounter1
	ret nz
	call objectCreatePuff
	call objectGetShortPosition
	ld c,a
	ld a,TILEINDEX_INDOOR_UPSTAIRCASE
	call setTile
	xor a
	ld ($cbca),a
	jp interactionDelete

; TODO: there is a subrosian where this one should be?
interactionCode6bSubid26:
	call checkInteractionState
	jp nz,interactionRunScript
	ld hl,mainScripts.subrosianScript_templeFallenText
	call interactionSetScript
	jp interactionIncState


; ==============================================================================
; INTERACID_ROSA_HIDING
; ==============================================================================
interactionCode6c:
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw rosaSubId0
	.dw rosaSubId1


; ==============================================================================
; INTERACID_STRANGE_BROTHERS_HIDING
; ==============================================================================
interactionCode6d:
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw strangeBrothersSubId0
	.dw strangeBrothersSubId1
	.dw strangeBrothersSubId2

rosaSubId0:
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
@substate0:
	ld a,$01
	ld (de),a
	ld a,TREASURE_ESSENCE
	call checkTreasureObtained
	and $01
	jp z,interactionDelete
	call getThisRoomFlags
	bit 7,a
	jp nz,interactionDelete
	call interactionSetAlwaysUpdateBit
	call objectSetReservedBit1
	ld a,$01
	ld ($cca4),a
	ld ($cc02),a
	ld e,$79
	ld a,($cc4c)
	ld (de),a
	xor a
	ld (wActiveMusic),a
	ld a,$0b
	call playSound
@func_67d1:
	ld a,$80
	ld ($cc9f),a
	ld a,$01
	ld ($ccab),a
	ldbc $01 INTERACID_ROSA_HIDING
	call spawnHider
	ld e,a
	ld bc,@table_67f1
	call addDoubleIndexToBc
	call func_69ac
	ld a,e
	cp $04
	jr z,@func_680c
	ret
@table_67f1:
	; yh - xh
	.db $28 $50
	.db $58 $68
	.db $58 $58
	.db $58 $58
	.db $58 $58
@func_67fb:
	ld a,($cc4c)
	cp $cb
	jp z,interactionDelete
	ld a,($cc62)
	ld (wActiveMusic),a
	call playSound
@func_680c:
	xor a
	ld ($cc9f),a
	ld ($ccab),a
	jp interactionDelete
@substate1:
	ld e,$78
	ld a,(de)
	rst_jumpTable
	.dw @var38_00
	.dw @var38_01
@var38_00:
	ld a,($cc4c)
	cp $cb
	jr nz,@func_67fb
	ld a,($cc9e)
	cp $02
	ret nz
	ld e,$78
	ld a,$01
	ld (de),a
	ret
@var38_01:
	ld a,($cfc0)
	or a
	jr z,+
	ld e,$7a
	ld a,$01
	ld (de),a
	xor a
	ld ($ccab),a
+
	ld e,$79
	ld a,(de)
	ld b,a
	ld a,($cc4c)
	cp b
	ret z
	ld (de),a
	cp $cb
	jr z,@func_67fb
	ld e,$7a
	ld a,(de)
	or a
	jr z,@func_67fb
	xor a
	ld (de),a
	ld h,d
	ld l,$46
	inc (hl)
	ld a,(hl)
	ld bc,@table_686c
	call addAToBc
	ld a,(bc)
	ld b,a
	ld a,($cc4c)
	cp b
	jr nz,@func_67fb
	jp @func_67d1
@table_686c:
	.db $cb $bb $ab $9b $9a

rosaSubId1:
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3
	.dw @substate4
	.dw @substate5
@substate0:
	ld a,$01
	ld (de),a
	call interactionInitGraphics
	ld e,$43
	ld a,(de)
	ld hl,table_6931
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	call interactionSetScript
	ld e,$6d
	ld a,$08
	ld (de),a
	call objectSetVisiblec2
@substate1:
	call interactionRunScript
	jp c,interactionDelete
@func_68a2:
	ld c,$20
	jp objectUpdateSpeedZ_paramC
@substate2:
	call interactionRunScript
	jp c,interactionDelete
	ld c,$20
	call objectUpdateSpeedZ_paramC
	ret nz
	ld bc,$fe40
	jp objectSetSpeedZ
@substate3:
	call interactionAnimate
	call @func_68a2
	ret nz
	call interactionRunScript
	jp c,interactionDelete
	ret
@substate4:
	ld e,$7b
	ld a,(de)
	inc a
	jr z,+
	jr @substate3
+
	ld hl,mainScripts.rosaHidingScript_caught
	call interactionSetScript
	jp interactionRunScript
@substate5:
	call interactionAnimate
	call @func_68a2
	ret nz
	ld a,$09
	call objectGetShortPosition_withYOffset
	ld c,a
	ld b,$ce
	ld a,(bc)
	cp $ff
	jr z,+
	or a
	jr nz,++
+
	ld a,$10
	jr func_6919
++
	ld e,$6d
	ld a,(de)
	ldh (<hFF8B),a
	ld e,$49
	ld (de),a
	call convertAngleDeToDirection
	xor $02
	sub $02
	add c
	ld c,a
	ld a,(bc)
	or a
	ldh a,(<hFF8B)
	jr z,func_6919
	ld e,$6d
	ld a,(de)
	cp $08
	jr z,+
	ld a,$08
	ld (de),a
	jr func_6919
+
	ld a,$18
	ld (de),a
func_6919:
	ld e,$49
	ld (de),a
	call objectApplySpeed
	ld e,$4b
	ld a,(de)
	cp $90
	jr nc,+
	ret
+
	xor a
	ld ($cca4),a
	ld ($ccab),a
	jp interactionDelete
table_6931:
	.dw mainScripts.rosaHidingScript_1stScreen
	.dw mainScripts.rosaHidingScript_2ndScreen
	.dw mainScripts.rosaHidingScript_3rdScreen
	.dw mainScripts.rosaHidingScript_4thScreen
	.dw mainScripts.rosaHidingScript_portalScreen
	.dw mainScripts.rosaHidingScript_caught

strangeBrothersSubId0:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw strangeBrothersSubId0State1
	.dw strangeBrothersSubId0State2
	.dw strangeBrothersSubId0State3
@state0:
	ld a,$01
	ld (de),a
	ld a,GLOBALFLAG_STRANGE_BROTHERS_HIDING_IN_PROGRESS
	call checkGlobalFlag
	jp nz,interactionDelete
	ld e,$40
	ld a,$83
	ld (de),a
	ld a,($cc4c)
	ld ($cfd1),a
	ld a,GLOBALFLAG_STRANGE_BROTHERS_HIDING_IN_PROGRESS
	call setGlobalFlag
func_6964:
	ld a,$01
	ld ($ccab),a
	ldbc $01 INTERACID_STRANGE_BROTHERS_HIDING
	call spawnHider
	ldbc $02 INTERACID_STRANGE_BROTHERS_HIDING
	call spawnHider
	ld a,TREASURE_FEATHER
	call checkTreasureObtained
	ld a,$01
	jr nc,+
	call getRandomNumber
	and $01
+
	ld ($cfd0),a
	ld e,$46
	ld a,(de)
	cp $06
	jp z,func_6995
	ret
func_698f:
	ld a,(wActiveMusic)
	call playSound
func_6995:
	xor a
	ld ($cc9e),a
	jp interactionDelete
	
;;
; @param[out]	b	subid
; @param[out]	c	id
spawnHider:
	call getFreeInteractionSlot
	dec l
	set 7,(hl)
	inc l
	ld (hl),c
	inc l
	ld (hl),b
	inc l
	ld e,$46
	ld a,(de)
	ld (hl),a
	ret

func_69ac:
	ld l,$4b
	ld a,(bc)
	ldi (hl),a
	inc l
	inc bc
	ld a,(bc)
	ld (hl),a
	ret

strangeBrothersSubId0State1:
	ld a,($cd00)
	and $01
	ret z
	ld a,($cc9e)
	cp $02
	ret nz
	xor a
	ld ($cfc0),a
	ld e,Interaction.state
	ld a,$02
	ld (de),a
	ld a,GLOBALFLAG_JUST_CAUGHT_BY_STRANGE_BROTHERS
	call unsetGlobalFlag
	ld a,$0b
	jp playSound
	
strangeBrothersSubId0State2:
	ld a,($cfc0)
	cp $ff
	jr z,func_6a23
	and $03
	cp $03
	jr nz,+
	ld e,$7a
	ld (de),a
	xor a
	ld ($ccab),a
	ld ($cfc0),a
+
	ld a,($cc4c)
	ld b,a
	ld a,($cfd1)
	cp b
	ret z
	ld a,b
	ld ($cfd1),a
	cp $51
	jr z,func_698f
	ld e,$7a
	ld a,(de)
	cp $03
	jr nz,func_698f
	xor a
	ld (de),a
	ld h,d
	ld l,$46
	inc (hl)
	ld a,(hl)
	ld bc,@table_6a1c
	call addAToBc
	ld a,(bc)
	ld b,a
	ld a,($cc4c)
	cp b
	jp nz,func_698f
	jp func_6964
@table_6a1c:
	.db $51 $61 $71 $70
	.db $60 $50 $60
func_6a23:
	ld e,Interaction.state
	ld a,$03
	ld (de),a
	ld a,$01
	ld ($cc02),a
	ld bc,TX_2804
	jp showText

strangeBrothersSubId0State3:
	ld a,($cfc0)
	or a
	ret nz
	ld a,GLOBALFLAG_JUST_CAUGHT_BY_STRANGE_BROTHERS
	call setGlobalFlag
	ld a,GLOBALFLAG_STRANGE_BROTHERS_HIDING_IN_PROGRESS
	call unsetGlobalFlag
	xor a
	ld ($ccab),a
	ld hl,@warpDestVariables
	call setWarpDestVariables
	jp interactionDelete
@warpDestVariables:
	m_HardcodedWarpA ROOM_SEASONS_151 $00 $28 $03

strangeBrothersSubId1:
strangeBrothersSubId2:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
@state0:
	ld a,$01
	ld (de),a
	call interactionInitGraphics
	ld e,$50
	ld a,$28
	ld (de),a
	ld e,Interaction.subid
	ld a,(de)
	ld b,a
	dec a
	ld a,$02
	jr z,+
	dec a
+
	ld e,$5c
	ld (de),a
	ld a,b
	dec a
	ld hl,@table_6a92
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	ld e,$43
	ld a,(de)
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	call interactionSetScript
	call interactionRunScript
	call interactionRunScript
	jp objectSetVisiblec2
@table_6a92:
	.dw @table_6a96
	.dw @table_6aa4
@table_6a96:
	.dw mainScripts.strangeBrother1Script_1stScreen
	.dw mainScripts.strangeBrother1Script_2ndScreen
	.dw mainScripts.strangeBrother1Script_3rdScreen
	.dw mainScripts.strangeBrother1Script_4thScreen
	.dw mainScripts.strangeBrother1Script_5thScreen
	.dw mainScripts.strangeBrother1Script_6thScreen
	.dw mainScripts.strangeBrother1Script_finishedScreen
@table_6aa4:
	.dw mainScripts.strangeBrother2Script_1stScreen
	.dw mainScripts.strangeBrother2Script_2ndScreen
	.dw mainScripts.strangeBrother2Script_3rdScreen
	.dw mainScripts.strangeBrother2Script_4thScreen
	.dw mainScripts.strangeBrother2Script_5thScreen
	.dw mainScripts.strangeBrother2Script_6thScreen
	.dw mainScripts.strangeBrother2Script_finishedScreen
@state1:
	ld a,(wLinkPlayingInstrument)
	or a
	jr nz,@func_6add
	ld e,$7b
	ld a,(de)
	or a
	jr nz,@func_6add
	ld a,($cfc0)
	cp $ff
	jr z,@func_6add
	call interactionAnimate
	call interactionAnimate
	call interactionRunScript
	jp c,interactionDelete
@func_6ad1:
	ld c,$60
	call objectUpdateSpeedZ_paramC
	ret nz
	ld bc,$fe00
	jp objectSetSpeedZ
@func_6add:
	ld a,$ff
	ld ($cfc0),a
	ld a,$01
	ld ($cca4),a
	ld h,d
	ld l,$44
	inc (hl)
	ld l,$50
	ld (hl),$64
	call objectGetAngleTowardLink
	add $10
	and $1f
	ld e,$49
	ld (de),a
	call convertAngleDeToDirection
	jp interactionSetAnimation
@state2:
	call interactionAnimate
	call interactionAnimate
	call @func_6ad1
	call retIfTextIsActive
	call objectApplySpeed
	call objectCheckWithinScreenBoundary
	ret c
	call objectSetInvisible
	ld h,d
	ld l,$44
	inc (hl)
	jr +
+
	xor a
	ld ($cfc0),a
	jp interactionDelete


; ==============================================================================
; INTERACID_STEALING_FEATHER
; ==============================================================================
interactionCode6e:
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw @subid0
	.dw @subid1
	.dw @subid2
@subid0:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @@state0
	.dw @@state1
	.dw @@state2
@@state0:
	ld a,$01
	ld (de),a
	call interactionInitGraphics
	ld a,TREASURE_FEATHER
	call loseTreasure
	ld bc,$fd80
	call objectSetSpeedZ
	ld l,$50
	ld (hl),$0f
	ld l,$49
	ld (hl),$18
	ld l,$46
	ld (hl),$3c
	call interactionSetAlwaysUpdateBit
	jp objectSetVisiblec0
@@state1:
	call objectApplySpeed
	ld h,d
	ld l,$4d
	ld a,$18
	cp (hl)
	jr c,+
	ld (hl),a
+
	call interactionAnimate
	ld c,$14
	call objectUpdateSpeedZ_paramC
	call interactionDecCounter1
	ret nz
	ld l,$4f
	ld a,(hl)
	ld l,$52
	ld (hl),a
	ld l,$44
	inc (hl)
	ld l,$4d
	ld a,(hl)
	ld ($cfc1),a
	ld hl,$cfc0
	set 2,(hl)
	xor a
	call interactionSetAnimation
@@state2:
	ld hl,$cfc0
	bit 7,(hl)
	jp nz,interactionDelete
	ld a,(wFrameCounter)
	and $03
	ret nz
	ld h,d
	ld l,$46
	inc (hl)
	ld a,(hl)
	and $0f
	ld hl,@@table_6baa
	rst_addAToHl
	ld e,$52
	ld a,(de)
	add (hl)
	ld e,$4f
	ld (de),a
	ret
@@table_6baa:
	.db $00 $00 $ff $ff $ff $fe $fe $fe
	.db $fe $fe $fe $ff $ff $ff $ff $00
@subid1:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @@state0
	.dw interactionRunScript
	.dw @@state2
@@state0:
	ld a,$01
	ld (de),a
	call getThisRoomFlags
	bit 6,(hl)
	jp nz,interactionDelete
	ld hl,mainScripts.stealingFeatherScript
	jp interactionSetScript
@@state2:
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @@substate0
	.dw @@substate1
@@substate0:
	ld a,$01
	ld (de),a
	ld bc,$fe00
	call objectSetSpeedZ
	ld l,$4b
	ld a,($d00b)
	ldi (hl),a
	inc l
	ld a,($d00d)
	ld (hl),a
@@substate1:
	ld a,(wFrameCounter)
	rrca
	call c,@@func_6c19
	call objectApplySpeed
	ld e,$4b
	ld a,(de)
	cp $08
	jr nc,+
	ld e,$49
	ld a,$0c
	ld (de),a
+
	ld c,$40
	call objectUpdateSpeedZAndBounce
	jr nc,@@func_6c22
	call @@func_6c22
	ld a,$02
	ld ($cc6b),a
	jp interactionDelete
@@func_6c19:
	ld hl,$d008
	ld a,(hl)
	inc a
	and $03
	ld (hl),a
	ret
@@func_6c22:
	ld hl,$d000
	jp objectCopyPosition
@subid2:
	ld a,GLOBALFLAG_SAW_STRANGE_BROTHERS_IN_HOUSE
	call unsetGlobalFlag
	ld a,GLOBALFLAG_STRANGE_BROTHERS_HIDING_IN_PROGRESS
	call unsetGlobalFlag
	ld a,GLOBALFLAG_JUST_CAUGHT_BY_STRANGE_BROTHERS
	call unsetGlobalFlag
	jp interactionDelete


; ==============================================================================
; INTERACID_HOLLY
; ==============================================================================
interactionCode70:
	ld e,Interaction.subid
	ld a,(de)
	or a
	jr nz,@subid1
	call checkInteractionState
	jr nz,@state1
	ld a,$01
	ld (de),a
	ld a,(wWarpDestPos)
	cp $04
	ld hl,mainScripts.hollyScript_enteredFromChimney
	jr z,@setScript
	ld hl,mainScripts.hollyScript_enteredNormally
@setScript:
	call interactionSetScript
	call interactionInitGraphics
	jp objectSetVisiblec2
@state1:
	call interactionRunScript
	ld c,$0e
	call objectUpdateSpeedZ_paramC
	jp npcFaceLinkAndAnimate
@subid1:
	call returnIfScrollMode01Unset
	call interactionDeleteAndRetIfEnabled02
	ld a,$d9
	call findTileInRoom
	jr nz,+
	ld b,$00
-
	inc b
	dec l
	call backwardsSearch
	jr z,-
	ld a,b
	cp $04
	jr z,++
+
	ld a,GLOBALFLAG_ALL_HOLLYS_SNOW_SHOVELLED
	jp setGlobalFlag
++
	ld a,GLOBALFLAG_ALL_HOLLYS_SNOW_SHOVELLED
	jp unsetGlobalFlag


; ==============================================================================
; INTERACID_S_COMPANION_SCRIPTS
; ==============================================================================
interactionCode71:
	ld a,(wLinkDeathTrigger)
	or a
	jr z,+
	xor a
	ld (wDisabledObjects),a
	jp interactionDelete
+
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw companionScript_subid00
	.dw companionScript_subid01
	.dw companionScript_subid02
	.dw companionScript_subid03
	.dw companionScript_subid04
	.dw companionScript_subid05
	.dw companionScript_subid06
	.dw companionScript_subid07
	.dw companionScript_subid08
	.dw companionScript_subid09

; Ricky running off after jumping up cliff in North Horon
companionScript_subid00:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw companionScript_runScriptDeleteWhenDone
@state0:
	ld a,$01
	ld (de),a
	ld a,($cc48)
	and $01
	jr z,companionScript_delete
	ld a,($d101)
	cp $0b
	jr nz,companionScript_delete
	ld a,(wAnimalCompanion)
	cp $0b
	jp z,interactionDelete
	ld a,$0a
	ld hl,$d104
	ldi (hl),a
	ld l,$03
	ld a,$02
	ld (hl),a
	ld l,$30
	ld a,(hl)
	ld l,$3f
	ld (hl),a
	ld hl,mainScripts.companionScript_RickyLeavingYouInSpoolSwamp
	jp interactionSetScript

; Moosh being bullied in Spool
companionScript_subid01:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw companionScript_runScriptDeleteWhenDone
	.dw companionScript_giveFlute
	.dw companionScriptFunc_6eaf
@state0:
	ld a,($d101)
	cp $0d
	jr nz,companionScript_delete
	ld a,(wAnimalCompanion)
	cp $0d
	jr nz,companionScript_delete
	ld a,$01
	ld (de),a
	ld e,$79
	ld a,$0d
	ld (de),a
	call companionScript_setSubId0AndInitGraphics
	ld e,$42
	ld a,$01
	ld (de),a
	ld a,$1c
	ld e,$4b
	ld (de),a
	ld a,$2c
	ld e,$4d
	ld (de),a
	ld hl,mainScripts.companionScript_mooshInSpoolSwamp
	call interactionSetScript
	ld a,(wMooshState)
	bit 5,a
	jr nz,companionScript_delete
	or a
	ld a,$01
	ld ($ccf4),a
	ret nz
	jp interactionAnimateAsNpc

companionScript_runScriptDeleteWhenDone:
	call interactionRunScript
	ret nc
	call setStatusBarNeedsRefreshBit1
companionScript_delete:
	jp interactionDelete

; Sunken city entrance
companionScript_subid02:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
@state0:
	ld a,$01
	ld (de),a
	ld a,(wLinkObjectIndex)
	and $01
	jr z,companionScript_delete
	ld a,($d101)
	cp SPECIALOBJECTID_RICKY
	jr z,@func_6d72
	cp SPECIALOBJECTID_MOOSH
	jr nz,companionScript_delete
	ld a,$0a
	ld hl,$d104
	ldi (hl),a
	ld l,$03
	ld a,$08
	ld (hl),a
	ld l,$3f
	ld (hl),$14
	ld hl,mainScripts.companionScript_mooshEnteringSunkenCity
	jp interactionSetScript
@func_6d72:
	ld hl,$d104
	ld a,$0a
	ldi (hl),a
	ld l,$03
	ld a,$09
	ld (hl),a
	jr companionScript_delete
@state1:
	call interactionRunScript
	jr c,companionScript_delete
	ret

; Moosh in Mt Cucco
companionScript_subid06:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
@state0:
	ld a,(wMooshState)
	and $80
	jr nz,companionScript_delete
	ld a,$01
	ld (de),a
	ld a,$1c
	ld e,$4b
	ld (de),a
	ld a,$2c
	ld e,$4d
	ld (de),a
	ld a,TREASURE_SPRING_BANANA
	call checkTreasureObtained
	ld a,$00
	rla
	ld e,$78
	ld (de),a
	ld hl,mainScripts.companionScript_mooshInMtCucco
	jp interactionSetScript
@state1:
	ld a,($d13d)
	or a
	jr z,@goToRunScriptThenDelete
	ld e,$78
	ld a,(de)
	or a
	jr z,@goToRunScriptThenDelete
	ld e,$7a
	ld a,(de)
	or a
	jr nz,@goToRunScriptThenDelete
	inc a
	ld (de),a
	ld ($cc02),a
	ld hl,$d000
	call objectTakePosition
	ld a,($d10b)
	ld b,a
	ld a,($d10d)
	ld c,a
	call objectGetRelativeAngle
	ld e,$49
	ld (de),a
	ld a,$02
	ld ($d108),a
	add $01
	ld ($d13f),a
@goToRunScriptThenDelete:
	jp companionScript_runScriptDeleteWhenDone
@state2:
	ld h,d
	ld l,$5a
	bit 7,(hl)
	jr nz,++
	ld l,$50
	ld (hl),$32
	ld bc,$fec0
	call objectSetSpeedZ
	call objectSetVisible80
	call companionScript_setSubId0AndInitGraphics
	ld a,$06
	ld e,Interaction.subid
	ld (de),a
	ld e,$46
	ld a,$10
	ld (de),a
++
	call retIfTextIsActive
	ld c,$40
	call objectUpdateSpeedZ_paramC
	jp nz,objectApplySpeed
	call interactionDecCounter1
	ret nz
	ld l,$44
	dec (hl)
	ld a,TREASURE_SPRING_BANANA
	call loseTreasure
	jp objectSetInvisible

; Ricky in North Horon
companionScript_subid03:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw companionScript_runScriptDeleteWhenDone
	.dw @state2
	.dw companionScriptFunc_6eaf
@state0:
	ld a,(wRickyState)
	and $80
	jp nz,companionScript_delete2
	ld a,$01
	ld (de),a
	ld e,$79
	ld a,$0b
	ld (de),a
	call interactionSetAlwaysUpdateBit
	ld hl,mainScripts.companionScript_RickyInNorthHoron
	jp interactionSetScript
@state2:
	ld a,TREASURE_RICKY_GLOVES
	call loseTreasure
companionScript_giveFlute:
	ld a,$01
	ld ($cc02),a
	call interactionIncState
	ld e,$79
	ld a,(de)
	ld c,a
	cp $0d
	jr z,+
	ld hl,wLastAnimalMountPointY
	rst_addAToHl
	set 7,(hl)
+
	ld a,c
	ld hl,wAnimalCompanion
	cp (hl)
	ret nz
	sub $0a
	ld l,<wFluteIcon
	ld (hl),a
	ld a,(de)
	ld c,a
	ld a,TREASURE_FLUTE
	call giveTreasure
	ld hl,$cbea
	set 0,(hl)
	ld e,Interaction.subid
	ld a,$01
	ld (de),a
	call interactionInitGraphics
	ld e,Interaction.subid
	ld a,$03
	ld (de),a
	ld e,$79
	ld a,(de)
	sub $0a
	ld c,a
	and $01
	add a
	xor c
	ld e,$5c
	ld (de),a
	ld hl,$cc6a
	ld a,$04
	ldi (hl),a
	ld (hl),$01
	ld hl,$d000
	ld bc,$f200
	call objectTakePositionWithOffset
	call objectSetVisible80
	jp interactionRunScript

companionScriptFunc_6eaf:
	call retIfTextIsActive
	ld ($cca4),a
	call objectSetInvisible
	ld a,($cc48)
	and $0f
	add a
	swap a
	ld ($cca4),a
	call interactionRunScript
	ret nc
	xor a
	ld ($cca4),a
	ld ($cc02),a
	jr companionScript_delete2

; Dimitri in Spool Swamp
companionScript_subid04:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw companionScript_runScriptDeleteWhenDone
	.dw companionScript_giveFlute
	.dw companionScriptFunc_6eaf
@state0:
	ld a,(wDimitriState)
	and $80
	jr nz,companionScript_delete2
	ld a,(wAnimalCompanion)
	cp $0c
	jr nz,companionScript_delete2
	ld a,$01
	ld (de),a
	ld e,$79
	ld a,$0c
	ld (de),a
	ld hl,mainScripts.companionScript_dimitriInSpoolSwamp
	jp interactionSetScript

; Dimitri being bullied
companionScript_subid05:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw companionScript_runScriptDeleteWhenDone
@state0:
	ld a,(wDimitriState)
	and $80
	jr nz,companionScript_delete2
	ld a,(wAnimalCompanion)
	cp $0c
	jr z,companionScript_delete2
	ld a,$01
	ld (de),a
	ld hl,mainScripts.companionScript_dimitriBeingBullied
	jp interactionSetScript

; Moblin rest house
companionScript_subid07:
	ld a,(wDimitriState)
	or $20
	ld (wDimitriState),a
companionScript_delete2:
	jp interactionDelete

; Sunken city entrance
companionScript_subid08:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
@state0:
	ld a,$01
	ld (de),a
	ld a,($d101)
	cp SPECIALOBJECTID_DIMITRI
	jr nz,companionScript_delete2
	ld a,(wAnimalCompanion)
	cp SPECIALOBJECTID_DIMITRI
	jr z,companionScript_delete2
@state1:
	ld a,($cd00)
	and $0e
	ret nz
	ld hl,$d10b
	ldi a,(hl)
	cp $50
	ret nc
	cp $30
	ret c
	inc l
	ld a,(hl)
	cp $10
	ret nc
	ld a,$10
	ld (hl),a
	ld l,$04
	ld a,(hl)
	cp $08
	jr z,+
	cp $02
	jr nz,+
	ld (hl),$01
	call dropLinkHeldItem
+
	ld l,$04
	ld (hl),$0d
	ld bc,TX_211e
	jp showText

; 1st screen of North Horon from Eyeglass lake area
companionScript_subid09:
	ld h,>wc600Block
	call checkIsLinkedGame
	jr nz,+
	ld a,TREASURE_FLUTE
	call checkTreasureObtained
	jr c,+
	ld l,<wAnimalCompanion
	ld (hl),SPECIALOBJECTID_RICKY
+
	ld l,<wRickyState
	set 5,(hl)
	jr companionScript_delete2

companionScript_setSubId0AndInitGraphics:
	ld e,Interaction.subid
	xor a
	ld (de),a
	jp interactionInitGraphics


; ==============================================================================
; INTERACID_BLAINO
; var37 - 0 if enough rupees, else 1
; var38 - RUPEEVAL_10 if cheated, otherwise RUPEEVAL_20
; var39 - pointer to Blaino / script ???
; $ccec - result of fight - $01 if won, $02 if lost, $03 if cheated
; $cced - $00 on init, $01 when starting fight, $03 when fight done
; ==============================================================================
interactionCode72:
	ld e,Interaction.subid
	ld a,(de)
	or a
	jr nz,blainoSubid01
	; subid00
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw interactionDelete

@state0:
	call interactionIncState
	ld a,($cced)
	cp $00
	jr z,+
	cp $01
	jr z,++
	cp $03
	jr z,+
+
	ld l,Interaction.var38
	ld (hl),$01
	ld l,Interaction.var37
	ld (hl),$02
	ld a,$06
	call objectSetCollideRadius
	call seasonsFunc_09_7055
	call interactionInitGraphics
	jr @animate
++
	ld l,Interaction.var38
	ld (hl),$00
	call interactionInitGraphics
	ld a,$01
	jp interactionSetAnimation
	jr +

@state1:
	ld e,Interaction.var38
	ld a,(de)
	or a
	jr z,+
	call seasonsFunc_09_7036
	call seasonsFunc_09_704f
@animate:
	call interactionAnimate
+
	call objectPreventLinkFromPassing
	jp objectSetPriorityRelativeToLink_withTerrainEffects

blainoSubid01:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1

@state0:
	ld a,$01
	ld (de),a
	call interactionInitGraphics
	ld a,$04
	call interactionSetAnimation
	jp objectSetVisiblec1

@state1:
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2

@substate0:
	ld a,($cbb5)
	or a
	jr z,@substate2
	ld h,d
	ld l,Interaction.substate
	inc (hl)
	ld l,Interaction.animCounter
	ld (hl),$01
	xor a
	ld l,Interaction.z
	ldi (hl),a
	; zh
	ld (hl),a
	jp interactionAnimate

@substate1:
	ld h,d
	ld l,Interaction.animParameter
	ld a,(hl)
	or a
	jr z,+
	ld l,Interaction.substate
	inc (hl)
+
	jp interactionAnimate

@substate2:
	ld c,$20
	call objectUpdateSpeedZ_paramC
	ret nz
	ld h,d
	ld bc,$ff40
	jp objectSetSpeedZ

seasonsFunc_09_7036:
	ld a,(wFrameCounter)
	and $07
	ret nz
	call objectGetAngleTowardLink
	add $04
	and $18
	swap a
	rlca
	ld h,d
	ld l,Interaction.var37		; fickleOldManScript_text2
	cp (hl)
	ret z			; fickleOldManScript_text3
	ld (hl),a
	jp interactionSetAnimation

seasonsFunc_09_704f:
	ld c,$0e
	call objectUpdateSpeedZ_paramC
	ret nz

seasonsFunc_09_7055:
	ld e,Interaction.speedZ
	ld a,$80
	ld (de),a
	inc e
	ld a,$ff
	ld (de),a
	ret


; ==============================================================================
; INTERACID_ANIMAL_MOBLIN_BULLIES
; ==============================================================================
interactionCode73:
	ld h,d
	ld l,$42
	ldi a,(hl)
	or a
	jr nz,@func_7078
	inc l
	ld a,(hl)
	or a
	jr z,@func_7078
	ld a,($cd00)
	and $0e
	jr z,@func_7078
	ld a,$3c
	ld (wInstrumentsDisabledCounter),a
	ret
@func_7078:
	ld e,$44
	ld a,(wAnimalCompanion)
	cp SPECIALOBJECTID_RICKY
	or a
	jr z,@func_70fd_delete
	cp SPECIALOBJECTID_MOOSH
	jr z,@moosh
	ld a,(de)
	rst_jumpTable
	; Dimitri
	.dw @state0
	.dw @dimitriState1
	.dw @dimitriState2
@moosh:
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @mooshState1
@state0:
	ld a,$01
	ld (de),a
	call interactionInitGraphics
	ld hl,$d101
	ld a,(wAnimalCompanion)
	cp SPECIALOBJECTID_MOOSH
	jr z,@func_70c1
	cp SPECIALOBJECTID_DIMITRI
	jr nz,@func_70fd_delete
	; companion is dimitri
	cp (hl)
	jr nz,@func_70fd_delete
	ld a,(wDimitriState)
	and $88
	jr nz,@func_70fd_delete
	call @func_71ac
	ld hl,@table_71cd
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	call interactionSetScript
	jr @func_70f3
@func_70c1:
	cp (hl)
	jr nz,@func_70fd_delete
	ld a,(wMooshState)
	bit 5,a
	jr nz,@func_70fd_delete
	bit 7,a
	jr nz,@func_70fd_delete
	bit 2,a
	jr nz,@func_70fd_delete
	and $03
	jr z,+
	ld h,d
	ld l,$42
	ld a,(hl)
	or a
	jr nz,+
	ld l,$4b
	ld (hl),$28
	ld l,$4d
	ld (hl),$a8
+
	call @func_71ac
	ld hl,@table_71d9
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	call interactionSetScript
@func_70f3:
	call interactionAnimateAsNpc
	call objectCheckWithinScreenBoundary
	ret c
	jp objectSetInvisible
@func_70fd_delete:
	jp interactionDelete
@dimitriState1:
	call interactionAnimateAsNpc
	ld e,Interaction.subid
	ld a,(de)
	and $1f
	call z,@func_7183
	ld a,(wDimitriState)
	and $08
	jr nz,@func_7131
	ld a,($c4ab)
	or a
	ret nz
	call @func_71c0
	ld e,$71
	ld a,(de)
	or a
	jr z,+
	call objectGetAngleTowardLink
	ld e,$49
	ld (de),a
	call convertAngleDeToDirection
	dec e
	ld (de),a
	call interactionSetAnimation
+
	jp interactionRunScript
@func_7131:
	ld a,$01
	ld ($cca4),a
	ld e,Interaction.state
	ld a,$02
	ld (de),a
	ld e,Interaction.subid
	ld a,(de)
	ld hl,@table_71d3
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	jp interactionSetScript
@dimitriState2:
	call @func_71c0
	call interactionAnimate
	call objectSetPriorityRelativeToLink_withTerrainEffects
	call interactionRunScript
	ret nc
@func_7155:
	jr @func_70fd_delete
@mooshState1:
	call interactionAnimate
	call objectSetPriorityRelativeToLink_withTerrainEffects
	ld a,($c4ab)
	or a
	ret nz
	ld a,(wNumEnemies)
	or a
	jr z,+
	ld a,$01
+
	ld e,$7b
	ld (de),a
	call @func_71c0
	call objectCheckWithinScreenBoundary
	jr nc,+
	call objectSetVisible
	jr ++
+
	call objectSetInvisible
++
	call interactionRunScript
	jr c,@func_7155
	ret
@func_7183:
	xor a
	ld e,$78
	ld (de),a
	inc e
	ld (de),a
	ld a,RUPEEVAL_030
	call cpRupeeValue
	jr nz,+
	ld e,$78
	ld a,$01
	ld (de),a
	ld a,RUPEEVAL_050
	call cpRupeeValue
	jr nz,+
	ld e,$79
	ld a,$01
	ld (de),a
+
	ld h,d
	ld l,$7a
	ld a,(hl)
	or a
	ret z
	ld (hl),$00
	jp removeRupeeValue
@func_71ac:
	call interactionSetAlwaysUpdateBit
	ld l,$66
	ld a,$06
	ldi (hl),a
	ld a,$06
	ld (hl),a
	ld l,$50
	ld a,$32
	ld (hl),a
	ld e,Interaction.subid
	ld a,(de)
	ret
@func_71c0:
	ld c,$40
	call objectUpdateSpeedZ_paramC
	jr z,+
	ld a,$01
+
	ld e,$77
	ld (de),a
	ret
@table_71cd:
	; Dimitri
	.dw mainScripts.moblinBulliesScript_dimitriBully1BeforeSaving
	.dw mainScripts.moblinBulliesScript_dimitriBully2BeforeSaving
	.dw mainScripts.moblinBulliesScript_dimitriBully3BeforeSaving
@table_71d3:
	; Dimitri
	.dw mainScripts.moblinBulliesScript_dimitriBully1AfterSaving
	.dw mainScripts.moblinBulliesScript_dimitriBully2AfterSaving
	.dw mainScripts.moblinBulliesScript_dimitriBully3AfterSaving
@table_71d9:
	.dw mainScripts.moblinBulliesScript_mooshBully1
	.dw mainScripts.moblinBulliesScript_mooshBully2
	.dw mainScripts.moblinBulliesScript_mooshBully3
	.dw mainScripts.moblinBulliesScript_maskedMoblin1MovingUp
	.dw mainScripts.moblinBulliesScript_maskedMoblin2MovingUp
	.dw mainScripts.moblinBulliesScript_maskedMoblinMovingLeft


; pirate ship parts?
interactionCode74:
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw @subid0
	.dw @subid1
	.dw @subid2
	.dw @subid3
	.dw @subid4
	.dw @subid5
	.dw @subid6
	.dw @subid7
	.dw @subid8
	.dw @subid9
	.dw @subidA
	.dw @subidB
	.dw @subidC
@subid0:
@subid1:
@subid3:
@subid5:
@subid8:
@subid9:
	call @func_7283
	jr nz,@func_7218
@func_7208:
	ld e,Interaction.state
	ld a,$01
	ld (de),a
	ld a,$57
	call loadPaletteHeader
	call interactionInitGraphics
	jp objectSetVisible80
@func_7218:
	ld e,Interaction.subid
	ld a,(de)
	ld hl,@table_7229
	rst_addAToHl
	ld a,($cbbf)
	add (hl)
	ld e,$4b
	ld (de),a
	jp interactionAnimate
@table_7229:
	.db $e8 $58 $00 $e0
	.db $00 $10 $00 $00
	.db $10 $10
@subid2:
	call @func_7283
	ret nz
	ld a,GLOBALFLAG_PIRATE_SHIP_DOCKED
	call checkGlobalFlag
	jp nz,interactionDelete
	call @func_725b
	jr @func_7208
@subid4:
@subid7:
	call @func_7283
	jp nz,interactionAnimate
	ld a,GLOBALFLAG_PIRATE_SHIP_DOCKED
	call checkGlobalFlag
	jp z,interactionDelete
	call @func_7208
	ld e,Interaction.subid
	ld a,(de)
	cp $04
	ret nz
@func_725b:
	ld bc,$30e8
	ld e,$0a
	call @func_7268
	ld bc,$3018
	ld e,$0b
@func_7268:
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERACID_74
	inc l
	ld (hl),e
	ld e,$4b
	ld a,(de)
	add b
	ld l,e
	ld (hl),a
	ld e,$4d
	ld a,(de)
	add c
	ld l,e
	ld (hl),a
	ret
@subid6:
@subidA:
@subidB:
	call @func_7283
	ret nz
	jr @func_7208
@func_7283:
	ld e,Interaction.state
	ld a,(de)
	or a
	ret
@subidC:
	call @func_7283
	jp nz,interactionAnimate
	ld a,GLOBALFLAG_MOBLINS_KEEP_DESTROYED
	call checkGlobalFlag
	jp nz,interactionDelete
	jp @func_7208


; INTERACID_INTRO_SPRITE?
interactionCode75:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
@state0:
	call interactionIncState
	call interactionInitGraphics
	ld e,Interaction.subid
	ld a,(de)
	or a
	jr nz,@notSubdId0
	ld hl,mainScripts.script6f48
	call interactionSetScript
	jp objectSetVisible82
@notSubdId0:
	ld h,d
	ld l,$4b
	ld (hl),$70
	inc l
	inc l
	ld (hl),$80
	ld l,$49
	ld (hl),$18
	ld l,$50
	ld (hl),$05
	ld l,$42
	ld a,(hl)
	cp $02
	jp z,objectSetVisible83
	ld l,$46
	ld (hl),$05
	jp objectSetVisible82
@state1:
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw @subid0
	.dw @subid1
	.dw @subid2
@subid0:
	call interactionRunScript
	jp c,interactionDelete
	call interactionAnimate
	ld h,d
	ld l,$61
	ld a,(hl)
	or a
	ret z
	ld (hl),$00
	dec a
	add $30
	push de
	call loadGfxHeader
	ld a,UNCMP_GFXH_0c
	call loadUncompressedGfxHeader
	pop de
	ret
@subid1:
	call checkInteractionSubstate
	jr nz,@subid2
	call interactionAnimate
	ld h,d
	ld l,$61
	ld a,(hl)
	or a
	jr z,@subid2
	ld (hl),$00
	ld l,$46
	dec (hl)
	jr nz,@subid2
	ld l,$45
	inc (hl)
	ld a,$04
	call interactionSetAnimation
@subid2:
	ld hl,$cbb6
	ld a,(hl)
	or a
	ret z
	jp objectApplySpeed


; ==============================================================================
; INTERACID_SUNKEN_CITY_BULLIES
; ==============================================================================
interactionCode76:
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
	ld a,GLOBALFLAG_FINISHEDGAME
	call checkGlobalFlag
	jp nz,@delete
	ld a,(wDimitriState)
	and $40
	jr z,@func_7375
	ld a,$03
	ld (de),a
	call func_745b
	ld e,Interaction.subid
	ld a,(de)
	and $1f
	ld e,Interaction.subid
	ld a,(de)
	and $1f
	ld c,a
	ld hl,table_748f
	rst_addDoubleIndex
	ld e,$4b
	ldi a,(hl)
	ld (de),a
	ld e,$4d
	ldi a,(hl)
	ld (de),a
	ld a,c
	ld hl,table_7483
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	call interactionSetScript
	ld a,c
	ld hl,table_7495
	rst_addAToHl
	ld a,(hl)
	jp interactionSetAnimation
@func_7375:
	ld hl,$d101
	ld a,(hl)
	cp SPECIALOBJECTID_DIMITRI
	jr nz,@delete
	ld a,(wAnimalCompanion)
	cp SPECIALOBJECTID_DIMITRI
	jr z,@delete
	ld a,(wDimitriState)
	bit 5,a
	jr z,@delete
	bit 4,a
	jr nz,@delete
	call func_745b
	ld e,Interaction.subid
	ld a,(de)
	and $1f
	ld c,a
	ld hl,table_7489
	rst_addDoubleIndex
	ld e,$4b
	ldi a,(hl)
	ld (de),a
	ld e,$4d
	ldi a,(hl)
	ld (de),a
	ld a,c
	ld hl,table_7477
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	call interactionSetScript
	ld e,Interaction.subid
	ld a,(de)
	and $1f
	call z,func_743e
	ld a,$78
	ld ($cc85),a
	ret
@state2:
	ld c,$40
	call objectUpdateSpeedZ_paramC
	jr z,+
	ld a,$01
+
	ld e,$77
	ld (de),a
	call interactionAnimate
	call objectSetPriorityRelativeToLink_withTerrainEffects
	call interactionRunScript
	ld e,$4b
	ld a,(de)
	bit 7,a
	ret z
	ld e,Interaction.subid
	ld a,(de)
	and $1f
	cp $01
	jr nz,@delete
	xor a
	ld ($cba0),a
	ld ($cca4),a
	ld ($cc02),a
@delete:
	jp interactionDelete
@state3:
	ld a,($cd00)
	and $0e
	ret nz
	call interactionAnimateAsNpc
	jr ++
@state1:
	ld a,($cd00)
	and $0e
	ret nz
	call interactionAnimateAsNpc
	ld e,Interaction.subid
	ld a,(de)
	and $1f
	call z,func_743e
	ld a,(wDimitriState)
	and $08
	jr nz,func_742a
++
	ld a,($c4ab)
	or a
	ret nz
	ld c,$40
	call objectUpdateSpeedZ_paramC
	jr z,++
	ld a,$c0
	ld e,$5a
	ld (de),a
	ld a,$01
++
	ld e,$77
	ld (de),a
	jp interactionRunScript
func_742a:
	ld e,Interaction.state
	ld a,$02
	ld (de),a
	ld e,Interaction.subid
	ld a,(de)
	and $1f
	ld hl,table_747d
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	jp interactionSetScript
func_743e:
	xor a
	ld e,$78
	ld (de),a
	ld hl,wNumBombs
	ld a,(hl)
	or a
	jr z,+
	ld a,$01
	ld e,$78
	ld (de),a
+
	ld e,$79
	ld a,(de)
	or a
	ret z
	xor a
	ld (de),a
	xor a
	ld (hl),a
	call setStatusBarNeedsRefreshBit1
	ret
func_745b:
	call interactionInitGraphics
	call interactionSetAlwaysUpdateBit
	call interactionAnimateAsNpc
	ld h,d
	ld l,$66
	ld a,$06
	ldi (hl),a
	ld a,$06
	ld (hl),a
	ld l,$50
	ld a,$32
	ld (hl),a
	ld a,>TX_2100
	jp interactionSetHighTextIndex
table_7477:
	.dw mainScripts.sunkenCityBulliesScript1_bully1
	.dw mainScripts.sunkenCityBulliesScript1_bully2
	.dw mainScripts.sunkenCityBulliesScript1_bully3
table_747d:
	.dw mainScripts.sunkenCityBulliesScript2_bully1
	.dw mainScripts.sunkenCityBulliesScript2_bully2
	.dw mainScripts.sunkenCityBulliesScript2_bully3
table_7483:
	.dw mainScripts.sunkenCityBulliesScript3_bully1
	.dw mainScripts.sunkenCityBulliesScript3_bully2
	.dw mainScripts.sunkenCityBulliesScript3_bully3
table_7489:
	.db $38 $58
	.db $38 $68
	.db $28 $48
table_748f:
	.db $38 $48
	.db $38 $58
	.db $58 $48
table_7495:
	; animation
	.db $02 $02 $00


; Called by temple sinking cutscene
interactionCode77:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
@state0:
	ld a,$01
	ld (de),a
	call interactionInitGraphics
	ld e,Interaction.subid
	ld a,(de)
	call interactionSetAnimation
	ld e,Interaction.subid
	ld a,(de)
	or a
	jp z,objectSetVisible82
	jp objectSetVisible83
@state1:
	ld hl,$cfd3
	ld a,(hl)
	and $80
	jp nz,objectSetInvisible
	call objectSetVisible
	ld e,Interaction.subid
	ld a,(de)
	or a
	jr nz,@func_74dd
	ld a,($c486)
	ld b,a
	ld a,$7d
	sub b
	ld e,$4b
	ld (de),a
	ld a,($c487)
	ld b,a
	ld a,$54
	sub b
	ld e,$4d
	ld (de),a
	ret
@func_74dd:
	ld a,($c488)
	ld b,a
	ld a,$e9
	add b
	ld e,$4b
	ld (de),a
	ld a,($c489)
	ld b,a
	ld a,$19
	add b
	ld e,$4d
	ld (de),a
	ret


; ==============================================================================
; INTERACID_MAGNET_SPINNER
; ==============================================================================
interactionCode7b:
	ld h,d
	ld l,$46
	ld a,(hl)
	or a
	jr z,+
	dec (hl)
	jr z,+
	ld a,d
	ld ($ccb0),a
+
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
@state0:
	ld a,$01
	ld (de),a
	call interactionInitGraphics
	ld a,$07
	call objectSetCollideRadius
	jp objectSetVisible82
@state1:
	call objectGetTileAtPosition
	ld (hl),$3f
	call func_75e7
	call nc,interactionAnimate
	call objectPreventLinkFromPassing
	ret nc
	ld a,(wMagnetGloveState)
	or a
	jr z,@func_754e
	ld e,$61
	ld a,(de)
	or a
	ret nz
	ld c,$18
	call objectCheckLinkWithinDistance
	srl a
	ld e,$48
	ld (de),a
	ld b,a
	ld a,($d008)
	xor $02
	cp b
	ret nz
	call func_75e7
	ret c
	call interactionIncState
	jp func_75e1
@func_754e:
	ld a,($ccb0)
	or a
	ret nz
	ld c,$18
	call objectCheckLinkWithinDistance
	srl a
	ret nz
	ld a,($ccb4)
	cp $3f
	ret nz
	ld a,($d004)
	cp $01
	ret nz
	ld a,$02
	ld ($cc6a),a
	xor a
	ld ($cc6c),a
	ret
@state2:
	call func_75e1
	call interactionAnimate
	ld a,($cc79)
	or a
	jr z,@func_75bb
	bit 1,a
	jr z,@func_75bb
	ld e,$61
	ld a,(de)
	cp $ff
	jr z,@func_75a7
	add a
	ld c,a
	ld e,$48
	ld a,(de)
@func_758d:
	swap a
	rrca
	ld hl,@table_75c1
	rst_addAToHl
	ld b,$00
	add hl,bc
	ld e,$4b
	ld a,(de)
	add (hl)
	ld ($d00b),a
	inc hl
	ld e,$4d
	ld a,(de)
	add (hl)
	ld ($d00d),a
	ret
@func_75a7:
	ld e,$48
	ld a,(de)
	inc a
	and $03
	ldh (<hFF8B),a
	ld c,$00
	call @func_758d
	ldh a,(<hFF8B)
	xor $02
	ld ($d008),a
@func_75bb:
	ld e,Interaction.state
	ld a,$01
	ld (de),a
	ret
@table_75c1:
	.db $f0 $00 $f4 $04 $f8 $08 $fc $0c
	.db $00 $10 $04 $0c $08 $08 $0c $04
	.db $10 $00 $0c $fc $08 $f8 $04 $f4
	.db $00 $f0 $fc $f4 $f8 $f8 $f4 $fc
func_75e1:
	ld e,$46
	ld a,$14
	ld (de),a
	ret
func_75e7:
	ld e,Interaction.subid
	ld a,(de)
	ld b,a
	and $80
	ret z
	ld a,b
	and $07
	ld hl,wToggleBlocksState
	call checkFlag
	ret nz
	scf
	ret


; ==============================================================================
; INTERACID_TRAMPOLINE
; ==============================================================================
interactionCode7c:
	call objectSetPriorityRelativeToLink
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3
	.dw @state4
@state0:
	ld a,$01
	ld (de),a
	call interactionInitGraphics
	ld a,$07
	call objectSetCollideRadius
	ld a,$14
	ld l,$50
	ld (hl),a
	jp objectSetVisible82
@state1:
	call returnIfScrollMode01Unset
	ld e,Interaction.state
	ld a,$02
	ld (de),a
	jp func_76d4
@state2:
	ld a,($d00f)
	or a
	jr nz,@func_7677
	xor a
	ld e,$70
	ld (de),a
	ld a,$07
	call objectSetCollideRadius
	call objectPreventLinkFromPassing
	jr nc,@func_7671
	call objectCheckLinkPushingAgainstCenter
	jr nc,@func_7671
	ld a,$01
	ld (wForceLinkPushAnimation),a
	call interactionDecCounter1
	ret nz
	ld c,$28
	call objectCheckLinkWithinDistance
	ld e,$48
	xor $04
	ld (de),a
	call interactionCheckAdjacentTileIsSolid_viaDirection
	ret nz
	ld h,d
	ld l,$48
	ld a,(hl)
	add a
	add a
	ld l,$49
	ld (hl),a
	ld l,$46
	ld (hl),$20
	ld l,$44
	inc (hl)
	call func_76e0
	ld a,$71
	jp playSound
@func_7671:
	ld e,$46
	ld a,$1e
	ld (de),a
	ret
@func_7677:
	ld a,$0a
	call objectSetCollideRadius
	ld a,($d00b)
	ld b,a
	ld a,($d00d)
	ld c,a
	call interactionCheckContainsPoint
	ret nc
	ld a,($d00f)
	ld b,a
	cp $e8
	jr nc,+
	ld e,$70
	ld (de),a
+
	ld a,b
	cp $fc
	ret c
	ld e,$70
	ld a,(de)
	or a
	jr nz,+
	callab scriptHelp.trampoline_bounce
+
	ld e,Interaction.state
	ld a,$04
	ld (de),a
	xor a
	call interactionSetAnimation
	ld a,$53
	jp playSound
@state3:
	call objectApplySpeed
	call objectPreventLinkFromPassing
	call interactionDecCounter1
	ret nz
	ld l,$44
	dec (hl)
	ld l,$46
	ld (hl),$1e
	jr func_76d4
@state4:
	call interactionAnimate
	ld e,$61
	ld a,(de)
	inc a
	ret nz
	ld e,Interaction.state
	ld a,$02
	ld (de),a
	ret
func_76d4:
	call objectGetTileAtPosition
	ld e,$71
	ld (de),a
	ld (hl),$07
	dec h
	ld (hl),$14
	ret
func_76e0:
	call objectGetTileAtPosition
	ld e,$71
	ld a,(de)
	ld (hl),a
	dec h
	ld (hl),$00
	ret


; ==============================================================================
; INTERACID_FICKLE_OLD_MAN
; ==============================================================================
interactionCode80:
	call checkInteractionState
	jr nz,@state1
	ld a,$01
	ld (de),a
	call interactionInitGraphics
	ld b,$07
	call checkIfHoronVillageNPCShouldBeSeen
	ld a,c
	or a
	jp z,interactionDelete
	ld e,Interaction.subid
	ld a,b
	ld (de),a
	ld hl,@table_7717
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	call interactionSetScript
	jp objectSetVisible82
@state1:
	call interactionRunScript
	jp interactionAnimateAsNpc
@table_7717:
	.dw mainScripts.fickleOldManScript_text1
	.dw mainScripts.fickleOldManScript_text1
	.dw mainScripts.fickleOldManScript_text2
	.dw mainScripts.fickleOldManScript_text2
	.dw mainScripts.fickleOldManScript_text3
	.dw mainScripts.fickleOldManScript_text4
	.dw mainScripts.fickleOldManScript_text4
	.dw mainScripts.fickleOldManScript_text4
	.dw mainScripts.fickleOldManScript_text5
	.dw mainScripts.fickleOldManScript_text2
	.dw mainScripts.fickleOldManScript_text6


; ==============================================================================
; INTERACID_SUBROSIAN_SHOP
; Variables:
;   var37 - wram variable to check for number of 2nd currency
;   var38 - number of 2nd currency required
;   var39 - ore chunk cost
; ==============================================================================
interactionCode81:
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
	ld e,$40
	ld a,(de)
	or $80
	ld (de),a
@func_7742:
	ld e,Interaction.subid
	ld a,(de)
	cp $0a
	jr z,@shield
	cp $0d
	jr nz,@func_7770
	; member's card
	ld a,(wEssencesObtained)
	bit 2,a
	jr z,@func_776b
	ld a,TREASURE_MEMBERS_CARD
	call checkTreasureObtained
	jr c,@func_776b
	jr @func_7770
@shield:
	ld a,(wShieldLevel)
	cp $02
	jr nc,@func_776b
	ld a,TREASURE_SHIELD
	call checkTreasureObtained
	jr nc,@func_7770
@func_776b:
	ld a,(de)
	inc a
	ld (de),a
	jr @func_7770
@func_7770:
	ld a,(de)
	add a
	ld hl,@table_779e
	rst_addDoubleIndex
	ld a,(wBoughtSubrosianShopItems)
	and (hl)
	jr nz,@func_7799
	inc hl
	ld e,$77
	ld b,$03
-
	ldi a,(hl)
	ld (de),a
	inc e
	dec b
	jr nz,-
	call interactionInitGraphics
	ld e,$66
	ld a,$06
	ld (de),a
	inc e
	ld (de),a
	ld e,$71
	call objectAddToAButtonSensitiveObjectList
	jp objectSetVisible82
@func_7799:
	; already bought item
	ld a,(de)
	inc a
	ld (de),a
	jr @func_7742
@table_779e:
	; Byte 0: wBoughtSubrosianShopItems flag it sets
	; Byte 1: variable to check for other currency
	; Byte 2: number of other currency required
	; Byte 3: ore chunk cost
	.db $01, $00,             $00, $00
	.db $04, <wNumBombs,      $10, RUPEEVAL_050
	.db $08, <wNumScentSeeds, $20, RUPEEVAL_040
	.db $00, <wNumScentSeeds, $20, RUPEEVAL_100
	.db $02, <wNumEmberSeeds, $10, RUPEEVAL_020
	.db $10, $00,             $00, RUPEEVAL_030
	.db $20, $00,             $00, RUPEEVAL_040
	.db $40, $00,             $00, RUPEEVAL_050
	.db $80, $00,             $00, RUPEEVAL_070
	.db $00, $00,             $00, RUPEEVAL_005
	.db $00, <wNumEmberSeeds, $05, $00
	.db $00, $00,             $00, RUPEEVAL_025
	.db $00, $00,             $00, RUPEEVAL_010
	.db $00, $00,             $00, RUPEEVAL_005
	.db $00, <wNumGaleSeeds,  $20, $00
@table_77da:
	.db TREASURE_RIBBON,        $00
	.db TREASURE_BOMBS,         $10
	.db TREASURE_GASHA_SEED,    $01
	.db TREASURE_GASHA_SEED,    $01
	.db TREASURE_HEART_PIECE,   $01
	.db TREASURE_RING,          $03
	.db TREASURE_RING,          $03
	.db TREASURE_RING,          $03
	.db TREASURE_RING,          $02
	.db TREASURE_EMBER_SEEDS,   $04
	.db TREASURE_SHIELD,        $01
	.db TREASURE_PEGASUS_SEEDS, $10
	.db TREASURE_HEART_REFILL,  $0c
	.db TREASURE_MEMBERS_CARD,  $10
	.db TREASURE_ORE_CHUNKS,    $04
@state1:
	call interactionAnimateAsNpc
	ld e,$71
	ld a,(de)
	or a
	ret z
	xor a
	ld (de),a
	ld e,$7d
	ld (de),a
	call func_7931
	ld e,Interaction.state
	ld a,$02
	ld (de),a
	ld e,Interaction.subid
	ld a,(de)
	ld hl,table_7994
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	jp interactionSetScript
@state2:
	call interactionAnimateAsNpc
	call interactionRunScript
	ret nc
	ld e,$7d
	ld a,(de)
	bit 7,a
	ld e,Interaction.state
	ld a,$01
	ld (de),a
	ret nz
	ld a,$03
	ld (de),a
	inc e
	xor a
	ld (de),a
	ld a,$80
	ld ($cc02),a
	ret
@state3:
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3
	.dw @substate4
@substate0:
	call objectSetVisible80
	ld a,($ccea)
	dec a
	ld ($ccea),a
	call func_7973
	ld a,$04
	ld ($cc6a),a
	ld a,$01
	ld ($cc6b),a
	ld h,d
	ld l,$4b
	ld a,($d00b)
	sub $0e
	ld (hl),a
	ld l,$4d
	ld a,($d00d)
	ld (hl),a
	ld l,$46
	ld a,$80
	ldi (hl),a
	ld (hl),$04
	ld l,$45
	ld a,$01
	ld (hl),a
	ld hl,$cbea
	set 2,(hl)
	ld e,Interaction.subid
	ld a,(de)
	cp $01
	jr z,@func_78ac
	ld hl,@table_77da
	rst_addDoubleIndex
	ldi a,(hl)
	ld c,(hl)
	cp $2d
	jr nz,+
	call getRandomRingOfGivenTier
+
	call giveTreasure
	ld e,Interaction.subid
	ld a,(de)
	ld hl,@table_78b1
	rst_addAToHl
	ld c,(hl)
	ld b,$00
	call showText
	ld e,Interaction.subid
	ld a,(de)
	cp $04
	ret z
	ld a,$4c
	jp playSound
@func_78ac:
	ld h,d
	ld l,$45
	inc (hl)
	ret
@table_78b1:
	.db <TX_0041 ; Ribbon
	.db <TX_0000 ; this table not used for bomb upgrade
	.db <TX_004b ; Gasha seed
	.db <TX_004b ; Gasha seed
	.db <TX_0017 ; Piece of heart
	.db <TX_0054 ; Ring
	.db <TX_0054 ; Ring
	.db <TX_0054 ; Ring
	.db <TX_0054 ; Ring
	.db <TX_004f ; 4 ember seeds
	.db <TX_001f ; Shield
	.db <TX_0050 ; 10 pegasus seeds
	.db <TX_004c ; 3 hearts
	.db <TX_0045 ; Member's card
	.db <TX_004e ; 10 ore chunks
@substate1:
	call retIfTextIsActive
	xor a
	ld ($cca4),a
	ld ($cc02),a
	jp interactionDelete
@substate2:
	call interactionDecCounter1
	jr z,+
	inc l
	dec (hl)
	ret nz
	ld (hl),$04
	ld a,$01
	ld l,$5c
	xor (hl)
	ld (hl),a
	ret
+
	ld l,$5b
	ld a,$0a
	ldi (hl),a
	ldi (hl),a
	ld (hl),$0c
	ld l,$45
	ld (hl),$03
	ld l,$47
	ld (hl),$1e
	ld a,$08
	call interactionSetAnimation
	ld a,$bc
	call playSound
	jp fadeoutToWhite
@substate3:
	call interactionAnimate
	ld a,($c4ab)
	or a
	ret nz
	call interactionDecCounter2
	ret nz
	ld l,$5a
	ld (hl),a
	ld l,$45
	ld (hl),$04
	ld hl,wMaxBombs
	ld a,(hl)
	add $20
	ldd (hl),a
	ld (hl),a
	call setStatusBarNeedsRefreshBit1
	jp fadeinFromWhite
@substate4:
	ld a,($c4ab)
	or a
	ret nz
	xor a
	ld ($cca4),a
	ld ($cc02),a
	ld bc,TX_2b0e
	call showText
	jp interactionDelete
	
func_7931:
	ld e,$7b
	xor a
	ld (de),a
	ld e,Interaction.subid
	ld a,(de)
	or a
	jr z,buyingRibbon
	ld e,$77
	ld a,(de)
	or a
	jr z,+
	ld l,a
	ld h,>wc600Block
	inc e
	ld a,(de)
	ld b,a
	ld a,(hl)
	cp b
	jr c,++
+
	ld e,$7b
	ld a,$01
	ld (de),a
++
	ld e,$79
	ld a,(de)
	call cpOreChunkValue
	ld hl,$cba8
	ld (hl),c
	inc l
	ld (hl),b
	ld e,$7b
	xor $01
	jr z,+
	ld c,a
	ld a,(de)
	and c
+
	ld (de),a
	ret

buyingRibbon:
	ld a,TREASURE_STAR_ORE
	call checkTreasureObtained
	ret nc
	ld e,$7b
	ld a,$01
	ld (de),a
	ret

func_7973:
	ld e,Interaction.subid
	ld a,(de)
	or a
	ret z
	ld a,$ff
	ld ($cbea),a
	ld e,$77
	ld a,(de)
	or a
	jr z,+
	ld l,a
	ld h,>wc600Block
	inc e
	ld a,(de)
	ld c,a
	ld a,(hl)
	sub c
	daa
	ld (hl),a
+
	ld e,$79
	ld a,(de)
	ld c,a
	jp removeOreChunkValue
	
table_7994:
	.dw mainScripts.subrosianShopScript_ribbon
	.dw mainScripts.subrosianShopScript_bombUpgrade
	.dw mainScripts.subrosianShopScript_gashaSeed
	.dw mainScripts.subrosianShopScript_gashaSeed
	.dw mainScripts.subrosianShopScript_pieceOfHeart
	.dw mainScripts.subrosianShopScript_ring1
	.dw mainScripts.subrosianShopScript_ring2
	.dw mainScripts.subrosianShopScript_ring3
	.dw mainScripts.subrosianShopScript_ring4
	.dw mainScripts.subrosianShopScript_emberSeeds
	.dw mainScripts.subrosianShopScript_shield
	.dw mainScripts.subrosianShopScript_pegasusSeeds
	.dw mainScripts.subrosianShopScript_heartRefill
	.dw mainScripts.subrosianShopScript_membersCard
	.dw mainScripts.subrosianShopScript_oreChunks


; ==============================================================================
; INTERACID_DOG_PLAYING_WITH_BOY
; ==============================================================================
interactionCode82:
	call checkInteractionState
	jr nz,@state1
	ld a,$01
	ld (de),a
	ld h,d
	ld l,$4e
	xor a
	ldi (hl),a
	ld (hl),a
	call func_7a99
	ld l,$46
	ld (hl),$5a
	call interactionInitGraphics
	jp objectSetVisible82
@state1:
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3
	.dw @substate4
	.dw @substate5
@substate0:
	call @func_7a09
	call objectGetRelatedObject1Var
	ld l,$4d
	ld a,(hl)
	add $08
	ld b,a
	ld e,l
	ld a,(de)
	cp b
	jr c,@func_79fc
	call interactionIncSubstate
	ld l,$46
	ld (hl),$14
	ld a,$06
	call interactionSetAnimation
	jr @func_7a06
@func_79fc:
	ld e,$46
	ld a,(de)
	or a
	jp z,func_7a93
	jp interactionDecCounter1
@func_7a06:
	call func_7a93
@func_7a09:
	call interactionAnimate
	jp objectSetPriorityRelativeToLink_withTerrainEffects
@substate1:
	call @func_7a06
	call interactionDecCounter1
	ret nz
	ld l,$49
	ld (hl),$18
	ld l,$50
	ld (hl),$28
	jp interactionIncSubstate
@substate2:
	call @func_7a06
	call objectGetRelatedObject1Var
	ld l,$4d
	ld a,(hl)
	add $04
	call func_7a9f
	jp nz,objectApplySpeed
	call interactionIncSubstate
	ld l,$46
	ld (hl),$0c
	ld l,$4e
	xor a
	ldi (hl),a
	ld (hl),a
	jp func_7aa5
@substate3:
	call @func_7a09
	call interactionDecCounter1
	jp z,@func_7a4f
	call objectApplySpeed
	jr ++
@func_7a4f:
	call interactionIncSubstate
	ld l,$46
	ld (hl),$1e
	ld l,$49
	ld (hl),$08
	ld a,$05
	call interactionSetAnimation
++
	jp func_7aa5
@substate4:
	call @func_7a09
	call func_7aa5
	call interactionDecCounter1
	ret nz
	jp interactionIncSubstate
@substate5:
	call @func_7a06
	call func_7aa5
	call objectApplySpeed
	ld e,$76
	ld a,(de)
	call func_7a9f
	ret nz
	ld hl,$cceb
	ld (hl),$02
	ld h,d
	ld l,$45
	ld (hl),$00
	ld l,$4e
	xor a
	ldi (hl),a
	ld (hl),a
	ld l,$46
	ld (hl),$3c
	ret
func_7a93:
	ld c,$20
	call objectUpdateSpeedZ_paramC
	ret nz
func_7a99:
	ld bc,$ff40
	jp objectSetSpeedZ
func_7a9f:
	ld b,a
	ld e,$4d
	ld a,(de)
	cp b
	ret
func_7aa5:
	ld a,$40
	call objectGetRelatedObject1Var
	ld e,$49
	ld a,(de)
	cp $18
	ld c,$07
	jr nz,+
	ld c,$fb
+
	ld b,$fe
	jp objectCopyPositionWithOffset


; ==============================================================================
; INTERACID_BALL_THROWN_TO_DOG
; ==============================================================================
interactionCode83:
	call checkInteractionState
	jr nz,@state1
	ld a,$01
	ld (de),a
	ld h,d
	call @func_7aea
	ld l,$50
	ld (hl),$3c
	ld l,$49
	ld (hl),$18
	call getFreeInteractionSlot
	jr nz,+
	ld (hl),INTERACID_DOG_PLAYING_WITH_BOY
	ld l,$57
	ld (hl),d
	ld bc,$00f4
	call objectCopyPositionWithOffset
	ld l,$4d
	ld a,(hl)
	ld l,$76
	ld (hl),a
+
	call interactionInitGraphics
	jp objectSetVisible82
@func_7aea:
	ld l,$4e
	ld (hl),$ff
	inc l
	ld (hl),$fc
	ret
@state1:
	call objectSetPriorityRelativeToLink_withTerrainEffects
	ld h,d
	ld l,$5a
	res 6,(hl)
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @@susbtate0
	.dw @@susbtate1
	.dw @@susbtate2
@@susbtate0:
	ld a,($cceb)
	cp $01
	ret nz
	call getRandomNumber_noPreserveVars
	and $03
	ld hl,table_7b59
	rst_addDoubleIndex
	ldi a,(hl)
	ld e,$54
	ld (de),a
	ld a,(hl)
	inc e
	ld (de),a
	jp interactionIncSubstate
@@susbtate1:
	ld c,$20
	call objectUpdateSpeedZ_paramC
	jp nz,objectApplySpeed
	ld l,$55
	ldd a,(hl)
	srl a
	ld b,a
	ld a,(hl)
	rra
	cpl
	add $01
	ldi (hl),a
	ld a,b
	cpl
	adc $00
	ldd (hl),a
	ld bc,$ffa0
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	call compareHlToBc
	ret c
	jp interactionIncSubstate
@@susbtate2:
	ld a,($cceb)
	cp $02
	ret nz
	xor a
	ld (de),a
	ld h,d
	ld l,$76
	ld e,$4b
	ldi a,(hl)
	ld (de),a
	inc e
	inc e
	ld a,(hl)
	ld (de),a
	jp @func_7aea
table_7b59:
	; speedZ
	.dw $fee0
	.dw $fe80
	.dw $fe20
	.dw $fdc0


; ==============================================================================
; INTERACID_SPARKLE
; ==============================================================================
interactionCode84:
	call checkInteractionState
	jr nz,@state1

	call interactionInitGraphics
	call interactionSetAlwaysUpdateBit
	ld l,$44
	inc (hl)
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw @initSubid00
	.dw @mediumDrawPriority
	.dw @initSubid02
	.dw @initSubid03
	.dw @lowDrawPriority
	.dw @mediumDrawPriority
	.dw @mediumDrawPriority
	.dw @highDrawPriority
	.dw @initSubid08
	.dw @mediumDrawPriority

@initSubid00:
	ld h,d
	ld l,$46
	ld (hl),$78
@highDrawPriority:
	jp objectSetVisible82

@initSubid02:
	ld h,d
	ld l,$50
	ld (hl),$80
	inc l
	ld (hl),$ff
@mediumDrawPriority:
	jp objectSetVisible81

@initSubid03:
	ld h,d
	ld l,$50
	ld (hl),$c0
	inc l
	ld (hl),$ff
	jp objectSetVisible81

@lowDrawPriority:
	jp objectSetVisible80

@initSubid08:
	ld h,d
	ld l,$46
	ld (hl),$c2
	jp objectSetVisible80

@state1:
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw @runSubid00
	.dw @runSubid01
	.dw @runSubid02
	.dw @runSubid03
	.dw @runSubid04
	.dw @runSubid05
	.dw @runSubid06
	.dw @runSubid07
	.dw @runSubid08
	.dw @runSubid09

@runSubid00:
@runSubid07:
@animateAndFlickerAndDeleteWhenCounter1Zero:
	call interactionDecCounter1
	jp z,interactionDelete
@animateAndFlicker:
	call interactionAnimate
	ld a,(wFrameCounter)
@flicker4:
	rrca
	jp c,objectSetInvisible
	jp objectSetVisible
	
@runSubid02:
@runSubid03:
	call objectApplyComponentSpeed

@runSubid01:
@runSubid05:
	ld e,$61
	ld a,(de)
	cp $ff
	jp z,interactionDelete
	jp interactionAnimate

@runSubid04:
	ld a,($cfc0)
	bit 0,a
	jp nz,interactionDelete
	jr @animateAndFlicker

@runSubid09:
	ld a,($cbb9)
	cp $06
	jp z,interactionDelete
	jr @animateFlickerAndTakeRelatedObj1Position

@runSubid06:
	ld a,($cbb9)
	cp $07
	jp z,interactionDelete

@animateFlickerAndTakeRelatedObj1Position:
	call interactionAnimate
	ld a,$0b
	call objectGetRelatedObject1Var
	call objectTakePosition
	ld a,($cbb7)
	jr @flicker4

@runSubid08:
	ld a,$0b
	call objectGetRelatedObject1Var
	call objectTakePosition
	jr @animateAndFlickerAndDeleteWhenCounter1Zero


; ==============================================================================
; INTERACID_INTRO_SCENE_MUSIC
; ==============================================================================
interactionCode85:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
@state0:
	ld a,$01
	ld (de),a
	; room where Din dances
	ld a,<ROOM_SEASONS_098
	call getARoomFlags
	and $40
	jp nz,interactionDelete
	ld hl,$cfd7
	ld a,(hl)
	or a
	ret nz
	inc a
	ld (hl),a
	ld ($cc02),a
	ld a,MUS_CARNIVAL
	call playSound
@state1:
	ld a,($d00d)
	cp $70
	ld a,$01
	jr c,+
	inc a
+
	ld h,d
	ld l,$77
	cp (hl)
	ret z
	ld (hl),a
	jp setMusicVolume


; ==============================================================================
; INTERACID_TEMPLE_SINKING_EXPLOSION
; ==============================================================================
interactionCode86:
	call checkInteractionState
	jr nz,@state1
	ld a,$01
	ld (de),a
	call interactionInitGraphics
	ld e,Interaction.subid
	ld a,(de)
	ld b,a
	add a
	add b
	ld b,a
	ld h,d
	ld l,$62
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	ld a,b
	rst_addAToHl
	ld e,$62
	ld a,l
	ld (de),a
	inc e
	ld a,h
	ld (de),a
	call func_7cb3
	jp objectSetVisible81
@state1:
	ld hl,$cfd3
	ld a,(hl)
	inc a
	jp z,interactionDelete
	dec a
	and $7f
	ld b,a
	ld h,d
	ld l,$43
	ld a,(hl)
	cp b
	jr z,+
	ld (hl),b
	call func_7cb3
	jr ++
+
	ld e,$61
	ld a,(de)
	inc a
	call z,func_7cb3
++
	call interactionAnimate
	ld e,Interaction.subid
	ld a,(de)
	and $01
	ld b,a
	ld a,(wFrameCounter)
	and $01
	xor b
	jp z,objectSetInvisible
	jp objectSetVisible
func_7cb3:
	ld hl,$cfd3
	ld a,(hl)
	and $7f
	ld hl,table_7cd8
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	ld e,Interaction.subid
	ld a,(de)
	rst_addDoubleIndex
	ldi a,(hl)
	ld e,$4b
	call func_7ccd
	ld a,(hl)
	ld e,$4d
func_7ccd:
	ld b,a
	call getRandomNumber
	and $03
	sub $02
	add b
	ld (de),a
	ret
table_7cd8:
	.dw table_7ce2
	.dw table_7cec
	.dw table_7cf6
	.dw table_7d00
	.dw table_7d0a
table_7ce2:
	.db $79 $42
	.db $7b $4e
	.db $7e $5b
	.db $80 $70
	.db $81 $8a
table_7cec:
	.db $00 $38
	.db $6c $20
	.db $48 $40
	.db $3c $91
	.db $34 $64
table_7cf6:
	.db $2c $7e
	.db $1e $9e
	.db $50 $6e
	.db $28 $24
	.db $60 $20
table_7d00:
	.db $1c $18
	.db $44 $64
	.db $00 $5c
	.db $68 $70
	.db $74 $34
table_7d0a:
	.db $e0 $e0
	.db $7b $4e
	.db $7e $58
	.db $80 $68
	.db $81 $80


; ==============================================================================
; INTERACID_MAKU_TREE
; TODO: finish
; Variables:
;   ws_cc39: Maku tree stage
;   wc6e5: ???
;   ws_c6e0: ???
; ==============================================================================
interactionCode87:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3

@state0:
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw @subid0
	.dw @subid1
	.dw @subid2

@subid0:
	call interactionInitGraphics
	call objectSetVisible83
	call interactionSetAlwaysUpdateBit
	call makuTree_setAppropriateStage
	call makuTree_spawnGnarledKey
	ld hl,mainScripts.script710b
	call interactionSetScript
	ld a,($cc39)
	or a
	jr nz,+
	ld a,$01
	jr ++
+
	ld a,$02
++
	ld e,Interaction.state
	ld (de),a
	call interactionRunScript
	call interactionRunScript
	jp interactionRunScript

@subid1:
	ld e,Interaction.state
	ld a,$02
	ld (de),a
	call interactionInitGraphics
	call objectSetVisible83
	ld hl,mainScripts.script7255
	call interactionSetScript
	jp interactionRunScript

@subid2:
	ld e,Interaction.state
	ld a,$02
	ld (de),a
	call interactionInitGraphics
	call objectSetVisible83
	call interactionSetAlwaysUpdateBit
	ld hl,mainScripts.script7261
	call interactionSetScript
	jp interactionRunScript

@state1:
	call makuTree_setRoomFlag40OnGnarledKeyGet

@state2:
	call interactionRunScript

@state3:
	jp interactionAnimate


; This label in used directly from bank 0.
makuTree_setAppropriateStage:
	ld a,GLOBALFLAG_FINISHEDGAME
	call checkGlobalFlag
	jp nz,@setStageToLast
	ld a,TREASURE_ESSENCE
	call checkTreasureObtained
	jr c,+
	xor a
+
	; dungeon 1,2,3,5?
	cp $17
	jr z,@highestEssenceIs5Except4
	; dungeon 1 to 5?
	cp $1f
	jr z,@highestEssenceIs5
	call getHighestSetBit
	jr nc,+
	inc a
+
	; 0 if no essences, 1-8 based on highest essence, otherwise
	call @setStage
	cp $01
	jr z,@highestEssenceIs1
	cp $08
	jr z,@highestEssenceIs8
	ret
	
@highestEssenceIs1:
	; highest essence is 1st essence
	ld a,>ROOM_SEASONS_12a
	ld b,<ROOM_SEASONS_12a
	call getRoomFlags
	and $40
	ret z
	ld a,$09
	jr @setStage
	
@highestEssenceIs5Except4:
	ld a,GLOBALFLAG_MET_MAKU_WITH_FIRST_5_ESSENCES_EXCEPT_4TH
	call setGlobalFlag
	ld a,$0a
	jr @setStage
	
@highestEssenceIs5:
	ld a,GLOBALFLAG_MET_MAKU_WITH_FIRST_5_ESSENCES_EXCEPT_4TH
	call checkGlobalFlag
	jr nz,+
	ld a,$05
	jr @setStage
+
	ld a,$0b
	jr @setStage
	
@highestEssenceIs8:
	ld a,(wc6e5)
	cp $09
	jr z,@all8Essences
	ld a,GLOBALFLAG_GOT_MAKU_SEED
	call checkGlobalFlag
	ret z
	ld a,$0c
	jr @setStage

@all8Essences:
	ld a,$0d
	jr @setStage

@setStageToLast:
	ld a,$0e
@setStage:
	ld ($cc39),a
	ret

makuTree_setRoomFlag40OnGnarledKeyGet:
	call getThisRoomFlags
	and $40
	ret nz
	ld a,TREASURE_GNARLED_KEY
	call checkTreasureObtained
	ret nc
	set 6,(hl)
	ret

makuTree_spawnGnarledKey:
	call getThisRoomFlags
	bit 6,a
	ret nz
	; not yet gotten gnarled key
	bit 7,a
	ret z
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERACID_TREASURE
	inc l
	ld (hl),TREASURE_GNARLED_KEY
	inc l
	ld (hl),$01
	ld l,Interaction.yh
	ld a,$58
	ldi (hl),a
	ld a,(ws_c6e0)
	ld l,Interaction.xh
	ld (hl),a
	ret


; INTERACID_88
; clouds above Onox castle?
interactionCode88:
	call checkInteractionState
	jr nz,@nonZeroState
	ld a,(wPaletteThread_mode)
	or a
	ret nz
	ld a,$01
	ld (de),a
	ld e,$40
	ld a,(de)
	or $80
	ld (de),a
	call interactionInitGraphics
	call objectSetVisible82
	call objectSetInvisible
	ld e,Interaction.subid
	ld a,(de)
	or a
	jr z,+
	ld a,(wGfxRegs1.SCY)
	cpl
	inc a
+
	add $28
	ld l,$4b
	ld (hl),a
	ld e,Interaction.subid
	ld a,(de)
	or a
	jr nz,+
	call interactionIncSubstate
	ld hl,seasonsTable_09_7f33
	jp seasonsFunc_09_7f01
+
	ld a,GLOBALFLAG_SEASON_ALWAYS_SPRING
	call checkGlobalFlag
	jp nz,interactionDelete
	ld e,$46
	ld a,$3c
	ld (de),a
	ret
@nonZeroState:
	ld a,GLOBALFLAG_INTRO_DONE
	call checkGlobalFlag
	jr nz,+
	ld a,(wPaletteThread_mode)
	or a
	jp nz,interactionDelete
+
	call checkInteractionSubstate
	jr nz,+
	call interactionDecCounter1
	ret nz
	ld l,$46
	ld (hl),$3c
	call getRandomNumber_noPreserveVars
	and $01
	ret z
	call interactionIncSubstate
	call getRandomNumber_noPreserveVars
	and $03
	ld hl,seasonsTable_09_7f2b
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	jp seasonsFunc_09_7f01
+
	ld e,$70
	ld a,(de)
	or a
	jr nz,seasonsFunc_09_7ee2
	ld a,$01
	ld (de),a
	ld e,$47
	ld a,(de)
	ld hl,seasonsTable_09_7f28
	rst_addAToHl
	ld a,(hl)
	call loadPaletteHeader
	ld a,$ff
	ld ($cd29),a
	ld a,(de)
	or a
	ld a,$d2
	call nz,playSound
	ld a,(de)
	cp $02
	jr z,+
	call objectSetInvisible
	jr seasonsFunc_09_7ee2
+
	call getRandomNumber
	and $01
	ld b,a
	ld a,$13
	jr z,+
	ld a,$8d
+
	ld e,$4d
	ld (de),a
	ld a,b
	call interactionSetAnimation
	call objectSetVisible

seasonsFunc_09_7ee2:
	ld e,$47
	ld a,(de)
	cp $02
	jr nz,+
	call interactionAnimate
	ld e,$61
	ld a,(de)
	inc a
	jr nz,+
	call objectSetInvisible
+
	call interactionDecCounter1
	ret nz
	ld h,d
	ld l,$58
	ldi a,(hl)
	ld l,(hl)
	ld h,a
	inc hl
	inc hl

seasonsFunc_09_7f01:
	ld e,Interaction.relatedObj2
	ld a,h
	ld (de),a
	inc e
	ld a,l
	ld (de),a
	ldi a,(hl)
	inc a
	jr z,seasonsFunc_09_7f17
	ld e,$46
	ld (de),a
	inc e
	ld a,(hl)
	ld (de),a
	ld e,$70
	xor a
	ld (de),a
	ret

seasonsFunc_09_7f17:
	ld h,d
	ld l,$42
	ld a,(hl)
	or a
	jp z,interactionDelete
	ld l,$45
	ld (hl),$00
	ld l,$46
	ld (hl),$3c
	ret

seasonsTable_09_7f28:
	.db SEASONS_PALH_3b
	.db SEASONS_PALH_99
	.db SEASONS_PALH_9a

seasonsTable_09_7f2b:
	.dw seasonsTable_09_7f33
	.dw seasonsTable_09_7f33
	.dw seasonsTable_09_7f33
	.dw seasonsTable_09_7f33

seasonsTable_09_7f33:
	.db $3c $00
	.db $02 $01
	.db $04 $00
	.db $02 $02
	.db $78 $00
	.db $02 $01
	.db $02 $00
	.db $02 $01
	.db $02 $00
	.db $03 $01
	.db $01 $00
	.db $0c $02
	.db $3c $00
	.db $ff

.ends
