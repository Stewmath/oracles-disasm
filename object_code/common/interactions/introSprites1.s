; ==================================================================================================
; INTERAC_INTRO_SPRITES_1
; ==================================================================================================
interactionCode4a:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw introSpritesState1

@state0:
	call introSpriteIncStateAndLoadGraphics
	ld e,$42
	ld a,(de)
	rst_jumpTable
	.dw @initSubid00
	.dw @initSubid01
	.dw @initSubid02
	.dw @initSubid03
	.dw @initSubid04
	.dw introSpriteIncStateAndLoadGraphics
	.dw introSpriteIncStateAndLoadGraphics
	.dw @initSubid07
	.dw objectSetVisible82
	.dw @initSubid09
	.dw @initSubid0a


; Triforce pieces
@initSubid00:
@initSubid01:
@initSubid02:
	call getFreeInteractionSlot
	jr nz,++

	; Create the "glow" behind the triforce
	ld (hl),INTERAC_INTRO_SPRITES_1
	inc l
	ld (hl),$04
	inc l
	ld e,Interaction.subid
	ld a,(de)
	inc a
	ld (hl),a
	call introSpriteSetChildRelatedObject1ToSelf
++
	jp objectSetVisible82

@initSubid03:
@initSubid07:
@initSubid0a:
	ld e,Interaction.var03
	ld a,(de)
	add a
	add a
	ld h,d
	ld l,Interaction.animCounter
	add (hl)
	ld (hl),a

	call interactionSetAlwaysUpdateBit
	call introSpriteFunc_461a
	jp objectSetVisible80

@initSubid09:
	ld e,Interaction.var03
	ld a,(de)
	ld hl,@data
	rst_addDoubleIndex
	ldi a,(hl)
	ld e,Interaction.yh
	ld (de),a
	inc e
	inc e
	ld a,(hl)
	ld (de),a
	ld b,$03
--
	call getFreeInteractionSlot
	jr nz,++

	ld (hl),INTERAC_INTRO_SPRITES_1
	inc l
	ld (hl),$0a
	inc l
	ld (hl),b
	dec (hl)
	call introSpriteSetChildRelatedObject1ToSelf
	dec b
	jr nz,--
++
	jp objectSetVisible82

@data:
	.db $40 $78
	.db $40 $48
	.db $18 $60

@initSubid04:
	call objectSetVisible83
	xor $80
	ld (de),a
	ret

;;
introSpriteIncStateAndLoadGraphics:
	ld h,d
	ld l,Interaction.state
	inc (hl)
	jp interactionInitGraphics

;;
; Sets up X and Y positions with some slight random variance?
introSpriteFunc_461a:
	call objectGetRelatedObject1Var
	call objectTakePosition
	push bc
	ld e,Interaction.subid
	ld a,(de)
	ld hl,@data_4660
	cp $03
	jr z,@label_09_043
	cp $0a
	jr z,@label_09_043

	ld hl,@data_4666
	ld e,Interaction.counter2
	ld a,(de)
	inc a
	ld (de),a
	and $03
	ld c,a
	add a
	add c
	rst_addDoubleIndex

@label_09_043:
	ld e,Interaction.var03
	ld a,(de)
	rst_addDoubleIndex

	ldi a,(hl)
	call @addRandomVariance
	ld b,a
	ld e,Interaction.yh
	ld a,(de)
	add b
	ld (de),a

	ld a,(hl)
	call @addRandomVariance
	ld h,d
	ld l,Interaction.xh
	add (hl)
	ld (hl),a
	pop bc
	ret

; Adds a random value between -2 and +1 to the given number.
@addRandomVariance:
	ld b,a
	call getRandomNumber
	and $03
	sub $02
	add b
	ret

@data_4660:
	.db $fc $fc
	.db $07 $ff
	.db $ff $06

@data_4666:
	.db $f4 $f4
	.db $0e $fe
	.db $fa $09

	.db $fb $f0
	.db $09 $ff
	.db $04 $0e

	.db $06 $f8
	.db $f4 $08
	.db $0a $07

	.db $0b $fa
	.db $f4 $00
	.db $03 $0a


;;
introSpritesState1:
	ld e,Interaction.subid
	ld a,(de)
	cp $05
	jr nc,++

	; For subids 0-4 (triforce objects): watch for signal to delete self
	ld a,(wIntro.triforceState)
	cp $04
	jp z,interactionDelete
++
	ld a,(de)
	rst_jumpTable
	.dw introSpriteTriforceSubid
	.dw introSpriteTriforceSubid
	.dw introSpriteTriforceSubid
	.dw introSpriteRunTriforceGlowSubid
	.dw introSpriteRunSubid04
	.dw introSpriteRunSubid05
	.dw introSpriteRunSubid06
	.dw introSpriteRunSubid07
	.dw introSpriteRunSubid08
	.dw interactionAnimate
	.dw introSpriteRunTriforceGlowSubid


; Triforce pieces
introSpriteTriforceSubid:
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3
	.dw @substate4
	.dw interactionAnimate

@substate0:
	ld a,(wIntro.triforceState)
	cp $01
	jp nz,interactionAnimate

	ld b,$00
	ld e,Interaction.subid
	ld a,(de)
	cp $01
	jr z,+
	ld b,$0a
+
	call func_2d48
	call interactionIncSubstate
	ld l,Interaction.counter1
	ld (hl),b

@substate1:
	call interactionDecCounter1
	jp nz,interactionAnimate

	ld l,Interaction.subid
	ld a,(hl)
	cp $01
	jr nz,@centerTriforcePiece
	ld l,Interaction.angle
	ld (hl),$00
	ld l,Interaction.speed
	ld (hl),SPEED_20
	ld b,$01
	jr @label_09_048

@centerTriforcePiece:
	or a
	ld a,$18
	jr z,+
	ld a,$08
+
	ld l,Interaction.angle
	ld (hl),a
	ld l,Interaction.speed
	ld (hl),SPEED_20
	ld b,$0b

@label_09_048:
	call func_2d48
	call interactionIncSubstate
	ld l,Interaction.counter1
	ld (hl),b

@substate2:
	call interactionDecCounter1
	jr nz,++

	ld b,$02
	call func_2d48
	call interactionIncSubstate
	ld l,Interaction.counter1
	ld (hl),b
++
	call objectApplySpeed
	jp interactionAnimate

@substate3:
	call interactionDecCounter1
	jp nz,interactionAnimate

	ld b,$03
	call func_2d48
	call interactionIncSubstate
	ld l,Interaction.counter1
	ld (hl),b

	ld e,Interaction.subid
	ld a,(de)
	cp $01
	jr z,+

	jp interactionIncSubstate
+
	ld a,SND_ENERGYTHING
	jp playSound

@substate4:
	call interactionAnimate
	call interactionDecCounter1
	ret nz

	call interactionIncSubstate
	ld a,$02
	ld (wIntro.triforceState),a

	ld a,SND_AQUAMENTUS_HOVER
	jp playSound


introSpriteRunSubid07:
	call objectSetVisible
	ld e,Interaction.var03
	ld a,(de)
	and $01
	ld b,a
	ld a,(wIntro.frameCounter)
	and $01
	xor b
	call z,objectSetInvisible

introSpriteRunTriforceGlowSubid:
	ld e,Interaction.animParameter
	ld a,(de)
	inc a
	call z,introSpriteFunc_461a
	jp interactionAnimate

introSpriteRunSubid04:
introSpriteRunSubid05:
introSpriteRunSubid06:
	call interactionAnimate

	ld a,Object.start
	call objectGetRelatedObject1Var
	call objectTakePosition
	ld e,Interaction.var03
	ld a,(de)
	ld h,d
	ld l,Interaction.animCounter
	cp (hl)
	ld l,Interaction.visible
	jr nz,++

	set 7,(hl)
	ret
++
	res 7,(hl)
	ret


; Extra tree branches in intro
introSpriteRunSubid08:
	ld a,(wGfxRegs1.SCY)
	or a
	jp z,interactionDelete

	ld b,a
	ld e,Interaction.y
	ld a,(de)
	sub b
	inc e
	ld (de),a
	ret

;;
; Sets relatedObj1 of object 'h' to object 'd' (self).
introSpriteSetChildRelatedObject1ToSelf:
	ld l,Interaction.relatedObj1
	ld (hl),Interaction.start
	inc l
	ld (hl),d
	ret
