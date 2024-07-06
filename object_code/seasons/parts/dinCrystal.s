; ==================================================================================================
; PART_DIN_CRYSTAL
; ==================================================================================================
partCode4f:
	jr z,@normalStatus
	ld e,Part.state
	ld a,(de)
	cp $06
	jr nc,@normalStatus
	ld e,Part.var2a
	ld a,(de)
	res 7,a
	cp $04
	jr c,@normalStatus
	cp $0c
	jp z,seasonsFunc_10_7bc2
	cp $20
	jr nz,+
	ld a,Object.collisionType
	call objectGetRelatedObject2Var
	res 7,(hl)
	ld e,Part.var33
	ld a,$01
	ld (de),a
+
	ld h,d
	ld l,Part.health
	ld (hl),$40
	ld l,Part.var32
	ld (hl),$3c

@normalStatus:
	ld e,Part.subid
	ld a,(de)
	ld e,Part.state
	rst_jumpTable
	.dw @subid0
	.dw @subid1
	
@subid0:
	ld h,d
	ld l,Part.var32
	ld a,(hl)
	or a
	jr z,+
	dec (hl)
	jr nz,+
	ld l,Part.collisionType
	set 7,(hl)
+
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @stateStub
	.dw @state3
	.dw @state4
	.dw @state5
	.dw @state6
	.dw @state7

@state0:
	call getFreePartSlot
	ret nz
	ld (hl),PART_SHADOW
	inc l
	ld (hl),$00
	inc l
	ld (hl),$08
	ld l,Part.relatedObj1
	ld a,$c0
	ldi (hl),a
	ld (hl),d
	ld a,$0f
	ld (wLinkForceState),a
	ld h,d
	ld l,Part.state
	inc (hl)
	ld l,Part.yh
	ld (hl),$50
	ld l,Part.xh
	ld (hl),$78
	ld l,Part.zh
	ld (hl),$fc
	jp objectSetVisible82

@state1:
	inc e
	ld a,(de)
	rst_jumpTable
	.dw @@substate0
	.dw @@substate1
	.dw @@substate2

@@substate0:
	ld a,(w1Link.yh)
	cp $78
	jp nc,partAnimate
	ld a,$01
	ld (de),a
	ld a,SND_TELEPORT
	call playSound

@@substate1:
	ld b,$04
	call checkBPartSlotsAvailable
	ret nz
	ld bc,$0404
-
	call getFreePartSlot
	ld (hl),PART_DIN_CRYSTAL
	inc l
	inc (hl)
	ld l,Part.angle
	ld (hl),c
	call objectCopyPosition
	ld a,c
	add $08
	ld c,a
	dec b
	jr nz,-
	ld h,d
	ld l,Part.substate
	inc (hl)
	; counter1
	inc l
	ld (hl),$5a
	ld l,Part.zh
	ld (hl),$00
	jp objectSetInvisible

@@substate2:
	call partCommon_decCounter1IfNonzero
	ret nz
	call getFreeEnemySlot
	ret nz
	ld (hl),ENEMY_GENERAL_ONOX
	ld e,Part.relatedObj2
	ld a,$80
	ld (de),a
	inc e
	ld a,h
	ld (de),a

	ld l,Enemy.relatedObj1
	ld a,$c0
	ldi (hl),a
	ld (hl),d

	ld h,d
	ld l,Part.state
	inc (hl)
	; substate
	inc l
	ld (hl),$00
	ret

@stateStub:
	ret

@state3:
	ld h,d
	ld l,Part.zh
	inc (hl)
	ld a,(hl)
	cp $fc
	jr c,@animate
	ld l,e
	inc (hl)
	ld l,Part.collisionType
	set 7,(hl)
	ld l,Part.speed
	ld (hl),SPEED_80
@animate:
	jp partAnimate

@state4:
	ld a,$01
	call objectGetRelatedObject2Var
	ld a,(hl)
	cp $02
	jr nz,+++
	call seasonsFunc_10_7bd6
	ld l,$8b
	ldi a,(hl)
	srl a
	ld b,a
	ld a,(w1Link.yh)
	srl a
	add b
	ld b,a
	inc l
	ld a,(hl)
	srl a
	ld c,a
	ld a,(w1Link.xh)
	srl a
	add c
	ld c,a
	ld e,$cd
	ld a,(de)
	ldh (<hFF8E),a
	ld e,$cb
	ld a,(de)
	ldh (<hFF8F),a
	sub b
	add $04
	cp $09
	jr nc,+
	ldh a,(<hFF8E)
	sub c
	add $04
	cp $09
	jr c,@animate
	ld a,(wFrameCounter)
	and $1f
	jr nz,++
+
	call objectGetRelativeAngleWithTempVars
	ld e,$c9
	ld (de),a
++
	call objectApplySpeed
	jr @animate
+++
	ld h,d
	ld l,$c4
	ld e,l
	ld (hl),$06
	inc l
	ld (hl),$00
	ld l,$f2
	ld (hl),$00
	ld l,$e4
	res 7,(hl)
	ret

@state5:
	call seasonsFunc_10_7bd6
	call partCommon_decCounter1IfNonzero
	jr z,+
	call objectCheckTileCollision_allowHoles
	call nc,objectApplySpeed
	jr @animate
+
	ld l,$c4
	dec (hl)
	ld l,$d0
	ld (hl),$14
	jr @animate

@state6:
	inc e
	ld a,(de)
	rst_jumpTable
	.dw @@substate0
	.dw @@substate1
	.dw @state1@substate1
	.dw @@substate3

@@substate0:
	ld h,d
	ld l,e
	inc (hl)
	ld l,$e6
	ld a,$10
	ldi (hl),a
	ld (hl),a
	ret

@@substate1:
	call objectCheckCollidedWithLink
	jr nc,+
	ld e,$c5
	ld a,$02
	ld (de),a
	ld a,$8d
	call playSound
+
	jp partAnimate

@@substate3:
	ld h,d
	ld l,$c4
	inc (hl)
	ld l,$c6
	ld a,$3c
	ld (hl),a
	call setScreenShakeCounter

@state7:
	call partCommon_decCounter1IfNonzero
	ret nz
	ld a,$0f
	ld (hl),a
	call setScreenShakeCounter
--
	call getRandomNumber_noPreserveVars
	and $0f
	cp $0d
	jr nc,--
	inc a
	ld c,a
	push bc
-
	call getRandomNumber_noPreserveVars
	and $0f
	cp $09
	jr nc,-
	pop bc
	inc a
	swap a
	or c
	ld c,a
	ld b,$ce
	ld a,(bc)
	or a
	jr nz,--
	ld a,$48
	call breakCrackedFloor
	ld e,$c7
	ld a,(de)
	inc a
	cp $75
	jp z,partDelete
	ld (de),a
	ret
	
@subid1:
	ld a,(de)
	or a
	jr nz,+
	ld h,d
	ld l,e
	inc (hl)
	ld l,Part.counter1
	ld (hl),$5a
	ld l,Part.speed
	ld (hl),SPEED_60
+
	call partCommon_decCounter1IfNonzero
	jp z,partDelete
	ld l,Part.visible
	ld a,(hl)
	xor $80
	ld (hl),a
	jp objectApplySpeed

seasonsFunc_10_7bc2:
	ld h,d
	ld l,Part.counter1
	ld (hl),$78
	ld l,Part.knockbackAngle
	ld a,(hl)
	ld l,Part.angle
	ld (hl),a
	ld l,Part.state
	ld (hl),$05
	ld l,Part.speed
	ld (hl),SPEED_200
	ret

seasonsFunc_10_7bd6:
	ld e,Part.var33
	ld a,(de)
	or a
	ret z
	ld a,(wIsLinkBeingShocked)
	or a
	ret nz
	ld (de),a
	ld a,Object.health
	call objectGetRelatedObject2Var
	ld a,(hl)
	or a
	ret z
	ld l,Enemy.collisionType
	set 7,(hl)
	ret
