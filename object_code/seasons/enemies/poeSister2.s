; ==================================================================================================
; ENEMY_POE_SISTER_2
; ==================================================================================================
enemyCode76:
	jr z,@normalStatus
	sub $03
	ret c
	jr nz,+
	ld bc,$0a07
	jp poeSister5f7e
+
	call poeSister5fc2
	ret z
@normalStatus:
	call poeSister604b
	call poeSister602e
	ld e,$84
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @stateStub
	.dw @stateStub
	.dw @stateStub
	.dw @stateStub
	.dw @state5
	.dw @stateStub
	.dw @stateStub
	.dw @state8
	.dw @state9
	.dw @stateA
	.dw @stateB
	.dw @stateC
	.dw @stateD
	.dw @stateE
	.dw @stateF
	.dw @state10
	.dw @state11

@state0:
	ld a,$76
	ld ($cc1c),a
	call getRandomNumber_noPreserveVars
	ld e,$b8
	ld (de),a
	ld h,d
	ld l,$88
	ld (hl),$ff
	ld l,$90
	ld (hl),$46
	ld l,$82
	ld a,(hl)
	or a
	jr z,@func5c6d
	call getFreePartSlot
	ret nz
	ld (hl),PART_DARK_ROOM_HANDLER
	ld l,$c6
	ld a,$04
	ldi (hl),a
	ld (hl),a
	ld ($cca9),a
	ld hl,$d081
-
	ld a,(hl)
	cp $7e
	jr z,+
	inc h
	jr -
+
	ld e,$96
	ld l,e
	ld a,$80
	ld (de),a
	ldi (hl),a
	inc e
	ld a,h
	ld (de),a
	ld (hl),d
	ld h,d
	jp enemyCode7e@func_5dd5

; Also used by ENEMY_POE_SISTER_1
@func5c6d:
	ld l,$84
	ld (hl),$0b
	ld l,Enemy.enemyCollisionMode
	ld (hl),ENEMYCOLLISION_POE_SISTER_FIRSTFIGHT
	ld l,$86
	ld (hl),$3c
	ld a,$01
	ld (wLoadedTreeGfxIndex),a
	call objectSetVisible82
	ld a,$02
	jp enemySetAnimation
	
@state5:
	call ecom_galeSeedEffect
	jp nc,enemyDelete
	ld e,$87
	ld a,(de)
	dec a
	ret nz
	ld bc,TX_0a08
	jp showText
	
@stateStub:
	ret
	
@state8:
	ld a,(wcc93)
	or a
	ret nz
	inc a
	ld ($cca4),a
	ld h,d
	ld l,e
	inc (hl)
	ld l,$86
	ld (hl),$2d
	ret
	
@state9:
	call ecom_decCounter1
	jp nz,ecom_flickerVisibility
	ld (hl),$1f
	ld l,e
	inc (hl)
	jp objectSetVisible82
	
@stateA:
	call ecom_decCounter1
	jr z,+
	ld a,(hl)
	dec a
	jr nz,@animate
	xor a
	ld ($cca4),a
	ld bc,TX_0a05
	jp showText
+
	ld (hl),$2d
	ld l,e
	inc (hl)
	ld a,$2d
	ld (wActiveMusic),a
	jp playSound
	
@stateB:
	call ecom_decCounter1
	jp nz,ecom_flickerVisibility
	ld (hl),$10
	ld l,e
	inc (hl)
	ld l,$b7
	bit 1,(hl)
	jr z,+
	res 1,(hl)
	ld l,$86
	ld a,(hl)
	add $2c
	ld (hl),a
+
	jp objectSetInvisible
	
@stateC:
	call ecom_decCounter1
	ret nz
	ld (hl),$18
	ld l,e
	inc (hl)
	jp func_5e45
	
@stateD:
@stateF:
	call ecom_decCounter1
	jp nz,ecom_flickerVisibility
	ld (hl),$30
	ld l,e
	inc (hl)
	ld l,$a4
	set 7,(hl)
	jp objectSetVisible82
	
@stateE:
	call ecom_decCounter1
	jp z,poeSister5f3b
	ld a,(hl)
	and $07
	jr nz,+
	ld l,$89
	ld e,$b1
	ld a,(de)
	add (hl)
	and $1f
	ld (hl),a
	call ecom_updateAnimationFromAngle
+
	call func_5f49
	call objectApplySpeed
@animate:
	jp enemyAnimate
	
@state10:
	ld h,d
	ld l,$b4
	call ecom_readPositionVars
	sub c
	add $0c
	cp $19
	jr nc,+
	ldh a,(<hFF8F)
	sub b
	add $07
	cp $0f
	jr nc,+
	ld l,e
	inc (hl)
	ld l,$89
	ld a,(hl)
	and $10
	swap a
	add $04
	ld l,$88
	ld (hl),a
	jp enemySetAnimation
+
	call ecom_moveTowardPosition
	jr @animate
	
@state11:
	call enemyAnimate
	ld e,$a1
	ld a,(de)
	inc a
	jp z,poeSister5f3b
	sub $02
	ret nz
	call func_5f54
	ret nz
	ld e,$a1
	ld a,$02
	ld (de),a
	ret
