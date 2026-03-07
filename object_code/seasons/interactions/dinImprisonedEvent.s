; ==================================================================================================
; INTERAC_DIN_IMPRISONED_EVENT
; ==================================================================================================
interactionCode4f:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw interactionCode4f_state0
	.dw interactionCode4f_state1

interactionCode4f_state0:
	call interactionIncState
	call interactionInitGraphics
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw @subid0
	.dw @subid1
	.dw objectSetVisible81
	.dw @subid3
	.dw @subid4
	.dw @subid5

@subid0:
	ld hl,mainScripts.dinImprisonedScript_setDinCoords
	call interactionSetScript
	jp objectSetVisiblec2

@subid1:
	ld hl,mainScripts.dinImprisonedScript_OnoxExplainsMotive
	call interactionSetScript
	jp objectSetVisible82

@subid3:
	call @setCounter2Between1To8
	ld e,Interaction.var03
	ld a,(de)
	add a
	add a
	add $10
	and $1f
	ld e,$49
	ld (de),a
	ld e,$50
	ld a,$78
	ld (de),a
	call objectSetVisible80
	jp objectSetInvisible

@subid4:
	ld e,Interaction.var03
	ld a,(de)
	or a
	jr z,+
	ld a,$05
	call interactionSetAnimation
	jp objectSetVisible82
+
	jp objectSetVisible83

@subid5:
	ld hl,mainScripts.dinImprisonedScript_OnoxSaysComeIfYouDare
	call interactionSetScript
	jp objectSetVisible82

@func_7784:
	ld e,Interaction.var03
	ld a,(de)
	add $06
	ld b,a
	ld e,Interaction.var32
	ld a,(de)
	or a
	ld a,b
	jr z,+
	add $0b
+
	jp interactionSetAnimation

@func_7796:
	ld h,d
	ld l,$70
	ld e,Interaction.var32
	ld a,(de)
	or a
	jr nz,+
	ld e,Interaction.var03
	ld a,(de)
	add a
	add a
	ld e,$48
	ld (de),a
	ld b,(hl)
	inc l
	ld c,(hl)
	ld a,$38
	ld e,$48
	jp objectSetPositionInCircleArc
+
	ld e,Interaction.yh
	ldi a,(hl)
	ld (de),a
	inc e
	inc e
	ld a,(hl)
	ld (de),a
	ret

@setCounter2Between1To8:
	call getRandomNumber
	and $07
	inc a
	ld e,Interaction.counter2
	ld (de),a
	ret

interactionCode4f_state1:
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw @subid0
	.dw @subid1
	.dw @subid2
	.dw @subid3
	.dw @subid4
	.dw @subid5

@subid0:
	ld a,($cfd0)
	cp $0e
	jp z,interactionDelete
	cp $0d
	jr nz,++
	call checkInteractionSubstate
	jr nz,+
	call interactionIncSubstate
	ld l,$4b
	ld (hl),$4a
	inc l
	inc l
	ld (hl),$81
	ld a,$0e
	call interactionSetAnimation
+
	call objectOscillateZ
++
	call interactionAnimate
	jp interactionRunScript

@subid2:
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @@substate0
	.dw @@substate1
	.dw @@substate2
	.dw @@substate3
	.dw @@substate4
	.dw @@substate5
	.dw @@substate6
	.dw @@substate7
	.dw @@substate8

@@substate0:
	call interactionIncSubstate
	ld a,$7c
	call @func_7957
	ld e,Interaction.var03
	ld a,(de)
	add a
	ld hl,@@table_784e
	rst_addDoubleIndex
	ld e,$49
	ldi a,(hl)
	ld (de),a
	ld e,$70
	ldi a,(hl)
	ld (de),a
	inc de
	ldi a,(hl)
	ld (de),a
	inc de
	ld a,(hl)
	ld (de),a
	xor a
	call @func_791f
	ld e,$46
	ld a,$3c
	ld (de),a

@@substate1:
	call interactionDecCounter1
	ld e,$5a
	jr nz,+
	ld a,(de)
	or $80
	ld (de),a
	jp interactionIncSubstate
+
	ld a,(de)
	xor $80
	ld (de),a
	ret

@@table_784e:
	.db $1c $30 $3c $5a
	.db $04 $30 $46 $50
	.db $1c $60 $50 $46
	.db $04 $60 $5a $3c

@@substate2:
	ld h,d
	ld l,$71
	dec (hl)
	ret nz
	ld l,$50
	ld (hl),$78
	jp interactionIncSubstate

@@substate3:
	call objectApplySpeed
	ld e,$70
	ld a,(de)
	ld b,a
	ld e,$4b
	ld a,(de)
	ld c,a
	cp b
	ld e,$43
	ld a,(de)
	jr nc,+
	xor a
	call @func_7941
	jp interactionIncSubstate
+
	or a
	ret nz
	jp @func_7a1e

@@substate4:
	ld h,d
	ld l,$72
	dec (hl)
	ret nz
	call interactionIncSubstate
	ld l,$46
	ld (hl),$a0
	ld l,$43
	ld a,(hl)
	or a
	ld bc,$4882
	ld a,$fe
	call z,@func_7968
	ret

@@substate5:
	call interactionDecCounter1
	jr nz,+
	call objectSetVisible
	ld l,$46
	ld (hl),$28
	ld a,$04
	call @func_791f
	jp interactionIncSubstate
+
	ld l,$49
	inc (hl)
	ld a,(hl)
	and $1f
	ld (hl),a
	ld a,$20
	ld e,$49
	ld bc,$4882
	jp objectSetPositionInCircleArc

@@substate6:
	call interactionDecCounter1
	ret nz
	ld l,$50
	ld (hl),$14
	ld l,$46
	ld (hl),$3c
	ld a,$04
	call @func_7941
	ld b,$02
--
	call getFreeInteractionSlot
	jr nz,++
	ld (hl),INTERAC_DIN_IMPRISONED_EVENT
	inc l
	ld (hl),$04
	inc l
	ld a,b
	dec a
	ld (hl),a
	ld l,$46
	ld (hl),$0a
	jr z,+
	ld (hl),$14
+
	call objectCopyPosition
	ld e,$49
	ld l,e
	ld a,(de)
	ld (hl),a
	ld e,$50
	ld l,e
	ld a,(de)
	ld (hl),a
	dec b
	jr nz,--
++
	jp interactionIncSubstate

@@substate7:
	call objectApplySpeed
	call interactionDecCounter1
	ret nz
	ld hl,$cfd0
	ld (hl),$0c
	ld a,$79
	call @func_7957
	jp interactionIncSubstate

@@substate8:
	ld hl,$cfd0
	ld a,(hl)
	cp $0d
	ret nz
	jp interactionDelete

@func_791f:
	ld b,a
	ld e,$43
	ld a,(de)
	add b
	ld hl,@table_7931
	rst_addDoubleIndex
	ld e,$4b
	ldi a,(hl)
	ld (de),a
	inc de
	inc de
	ldi a,(hl)
	ld (de),a
	ret

@table_7931:
	.db $60 $98
	.db $60 $68
	.db $90 $98
	.db $90 $68
	.db $30 $68
	.db $30 $98
	.db $60 $68
	.db $60 $98

@func_7941:
	ld b,a
	ld e,$43
	ld a,(de)
	add b
	ld hl,@table_794f
	rst_addAToHl
	ld e,$49
	ld a,(hl)
	ld (de),a
	ret

@table_794f:
	.db $1c
	.db $04
	.db $14
	.db $0c
	.db $0c
	.db $14
	.db $04
	.db $1c

@func_7957:
	ld b,a
	ld e,$43
	ld a,(de)
	or a
	ret nz
	ld a,b
	jp playSound
	ld hl,$ff8c
	ld (hl),$01
	jr +

@func_7968:
	ld hl,$ff8c
	ld (hl),$00
+
	ldh (<hFF8B),a
	ld a,$08
	ldh (<hFF8D),a
-
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERAC_DIN_IMPRISONED_EVENT
	inc l
	ld (hl),$03
	ld l,$46
	ldh a,(<hFF8B)
	ld (hl),a
	ld l,$70
	ld (hl),b
	inc l
	ld (hl),c
	ld l,$72
	ldh a,(<hFF8C)
	ld (hl),a
	ldh a,(<hFF8D)
	dec a
	ldh (<hFF8D),a
	ld l,$43
	ld (hl),a
	jr nz,-
	ld a,$5c
	jp playSound

@subid3:
	ld h,d
	ld l,$46
	ld a,(hl)
	inc a
	jr z,+
	dec (hl)
	jp z,interactionDelete
+
	ld e,$45
	ld a,(de)
	or a
	jr nz,+
	call interactionDecCounter2
	ret nz
	call interactionCode4f_state0@func_7784
	call interactionCode4f_state0@func_7796
	call objectSetVisible
	jp interactionIncSubstate
+
	call objectApplySpeed
	call interactionAnimate
	ld e,$61
	ld a,(de)
	inc a
	ret nz
	ld h,d
	ld l,$45
	ld (hl),$00
	call interactionCode4f_state0@setCounter2Between1To8
	jp objectSetInvisible

@subid4:
	call checkInteractionSubstate
	jr nz,+
	call interactionDecCounter1
	ret nz
	jp interactionIncSubstate
+
	ld hl,$cfd0
	ld a,(hl)
	cp $0c
	jp z,interactionDelete
	jp objectApplySpeed

@subid1:
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @@substate0
	.dw @@substate1
	.dw interactionRunScript

@@substate0:
	call interactionRunScript
	jr c,+
	call interactionAnimate
	jr @@func_7a00
+
	jp interactionIncSubstate

@@func_7a00:
	ld h,d
	ld l,$61
	ld a,(hl)
	cp $70
	ld (hl),$00
	ret nz
	jp playSound

@@substate1:
	ld a,($cfd0)
	cp $0e
	ret nz
	call objectSetInvisible
	ld hl,mainScripts.dinImprisonedScript_OnoxSendsTempleDown
	call interactionSetScript
	jp interactionIncSubstate

@func_7a1e:
	ld a,($c486)
	ld b,a
	ld a,c
	sub b
	sub $40
	ld b,a
	ld a,($c486)
	add b
	cp $10
	ret nc
	ld ($c486),a
	ldh (<hCameraY),a
	ret

@subid5:
	call interactionAnimate
	call @subid1@func_7a00
	jp interactionRunScript
