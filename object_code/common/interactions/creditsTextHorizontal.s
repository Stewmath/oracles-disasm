; ==================================================================================================
; INTERAC_CREDITS_TEXT_HORIZONTAL
;
; Variables:
;   var03: ?
;   var30: ?
;   var31: ?
;   var32: ?
;   var33: ?
; ==================================================================================================
interactionCodeae:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1

@state0:
	ld a,$01
	ld (de),a ; [state]
	ld e,Interaction.var03
	ld a,(de)
	or a
	jr nz,@var03Nonzero

	ld h,d
	ld l,Interaction.subid
	ld a,(hl)
	ld hl,horizontalCreditsText_scriptTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	call creditsTextHorizontal_6559

	ld e,Interaction.subid
	ld a,(de)
	ld hl,horizontalCreditsText_65b1
	rst_addDoubleIndex
	ldi a,(hl)
	ld e,Interaction.var32
	ld (de),a
	ldi a,(hl)
	ld e,Interaction.counter2
	ld (de),a
	ret

@var03Nonzero:
	call interactionInitGraphics
	ld h,d
	ld l,Interaction.var30
	ld (hl),$14
	ld l,Interaction.speed
	ld (hl),SPEED_200

	ld l,Interaction.counter2
	ld a,(hl)
	call interactionSetAnimation

	ld h,d
	ld l,Interaction.subid
	ld a,(hl)
	or a
	ld bc,$f018
	jr z,+
	ld bc,$0008
+
	ld l,Interaction.xh
	ld (hl),b
	ld l,Interaction.angle
	ld (hl),c
	jp objectSetVisible82

@state1:
	ld a,$01
	ld (de),a ; [state]
	ld e,Interaction.var03
	ld a,(de)
	or a
	jp nz,horizontalCreditsText_var03Nonzero

	ld a,(wPaletteThread_mode)
	or a
	ret nz
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2

@substate0:
	ld h,d
	ld l,Interaction.var30
	call decHlRef16WithCap
	ret nz
	call creditsTextHorizontal_6537

@func_6457:
	ld e,Interaction.var30
	ld a,(de)
	rlca
	ret nc

	ld b,$01
	rlca
	jr nc,+
	ld b,$02
+
	ld h,d
	ld l,Interaction.counter1
	ld (hl),180
	ld l,Interaction.substate
	ld (hl),b
	ret

@substate1:
	ld e,Interaction.var33
	ld a,(de)
	rst_jumpTable
	.dw @subsubstate0
	.dw @subsubstate1
	.dw @subsubstate2
	.dw @subsubstate3

@subsubstate0:
	call interactionDecCounter1
	ret nz
	ld h,d
	ld l,Interaction.var33
	inc (hl)
	ret

@subsubstate1:
	ld a,(wFrameCounter)
	and $03
	ret nz

	ld h,d
	ld l,Interaction.counter1
	ld a,(hl)
	cp $10
	jr nz,@label_0b_234

	ld l,Interaction.var33
	inc (hl)

	ld l,Interaction.scriptPtr
	ld a,(hl)
	sub $03
	ldi (hl),a
	ld a,(hl)
	sbc $00
	ld (hl),a

	call creditsTextHorizontal_6554
	ld h,d
	ld l,Interaction.counter1
	ld (hl),30
	ret

@label_0b_234:
	ld a,($ff00+R_SVBK)
	push af
	ld l,Interaction.counter1
	ld a,(hl)
	ld b,a
	ld a,:w4TileMap
	ld ($ff00+R_SVBK),a
	ld a,b
	ld hl,w4TileMap
	rst_addDoubleIndex
	ld b,$30
@loop:
	xor a
	ldi (hl),a
	ld (hl),a
	ld a,$1f
	rst_addAToHl
	dec b
	jr nz,@loop

	push de
	ld a,UNCMP_GFXH_09
	call loadUncompressedGfxHeader
	pop de
	pop af
	ld ($ff00+R_SVBK),a

	ld h,d
	ld l,Interaction.counter1
	inc (hl)
	ret

@subsubstate2:
	call interactionDecCounter1
	ret nz
	ld l,Interaction.var33
	inc (hl)
	ld l,Interaction.counter1
	ld (hl),$10
	ret

@subsubstate3:
	ld a,(wFrameCounter)
	and $03
	ret nz
	call interactionDecCounter1
	jr nz,@label_0b_236

	xor a
	ld l,Interaction.substate
	ld (hl),a
	ld l,Interaction.var33
	ld (hl),a
	jp @func_6457

@label_0b_236:
	push de
	ld a,($ff00+R_SVBK)
	push af
	ld a,(hl) ; [counter1]
	ld b,a

	ld a,b
	ld hl,w4TileMap
	rst_addDoubleIndex
	ld a,b
	ld de,w3VramTiles
	call addDoubleIndexToDe
	ld b,$30
@tileLoop:
	push bc
	ld a,:w3VramTiles
	ld ($ff00+R_SVBK),a
	ld a,(de)
	ld b,a
	inc de
	ld a,(de)
	ld c,a
	ld a,:w4TileMap
	ld ($ff00+R_SVBK),a
	ld (hl),b
	inc hl
	ld (hl),c
	ld a,$1f
	ld c,a
	rst_addAToHl
	ld a,c
	call addAToDe
	pop bc
	dec b
	jr nz,@tileLoop

	ld a,UNCMP_GFXH_09
	call loadUncompressedGfxHeader
	pop af
	ld ($ff00+R_SVBK),a
	pop de
	ret

@substate2:
	call interactionDecCounter1
	ret nz
.ifdef ROM_AGES
	ld hl,wTmpcfc0.genericCutscene.cfdf
	ld (hl),$ff
.else
	ld hl,$cfde
	ld (hl),$01
.endif
	jp interactionDelete

;;
creditsTextHorizontal_6537:
	call getFreeInteractionSlot
	jr nz,++
	ld (hl),INTERAC_CREDITS_TEXT_HORIZONTAL
	inc l
	ld e,Interaction.var32
	ld a,(de)
	ldi (hl),a  ; [child.subid]
	ld (hl),$01 ; [child.var03]

	ld l,Interaction.counter1
	ld e,l
	ld a,(de)
	inc e
	ldi (hl),a
	ld a,(de) ; [counter2]
	ld (hl),a
	call objectCopyPosition
++
	ld h,d
	ld l,Interaction.counter2
	inc (hl)

;;
creditsTextHorizontal_6554:
	ld l,Interaction.scriptPtr
	ldi a,(hl)
	ld h,(hl)
	ld l,a

;;
; @param	hl	Script pointer
creditsTextHorizontal_6559:
	ldi a,(hl)
	ld e,Interaction.var30
	ld (de),a

	inc e
	ldi a,(hl)
	ld (de),a ; [var31]

	ldi a,(hl)
	ld e,Interaction.counter1
	ld (de),a

	ldi a,(hl)
	ld e,Interaction.yh
	ld (de),a

	ld e,Interaction.scriptPtr
	ld a,l
	ld (de),a
	inc e
	ld a,h
	ld (de),a

	ld e,Interaction.var31
	ld a,(de)
	or a
	ret nz

	dec e
	ld a,(de) ; [var30]
	or a
	ret nz
	jp creditsTextHorizontal_6537

;;
horizontalCreditsText_var03Nonzero:
	ld a,(wPaletteThread_mode)
	or a
	ret nz
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1

@substate0:
	ld h,d
	ld l,Interaction.var30
	dec (hl)
	jr nz,@applySpeed

	call interactionIncSubstate
	ld b,$a0
	ld l,Interaction.subid
	ld a,(hl)
	or a
	jr z,+
	ld b,$50
+
	ld l,Interaction.xh
	ld (hl),b
	ret

@applySpeed:
	call objectApplySpeed
	jp objectApplySpeed

@substate1:
	ld e,Interaction.counter1
	ld a,(de)
	inc a
	ret z
	call interactionDecCounter1
	jp z,interactionDelete
	ret

horizontalCreditsText_65b1:
	.db $00 $00 $01 $04 $00 $0b $01 $13
	.db $00 $00 $01 $04 $00 $0b $01 $13


; Custom script format? TODO: figure this out
horizontalCreditsText_scriptTable:
	.dw @script0
	.dw @script1
	.dw @script2
	.dw @script3
	.dw @script0
	.dw @script1
	.dw @script2
	.dw @script3

@script0:
	.db $20 $00 $ff $f8
	.db $30 $00 $f0 $18
	.db $20 $00 $f0 $38
	.db $20 $00 $f0 $50
	.db $ff

@script1:
	.db $20 $00 $ff $f8
	.db $20 $00 $f8 $18
	.db $10 $00 $e8 $38
	.db $10 $00 $d8 $58
	.db $80 $00 $00 $ff
	.db $10 $00 $00 $ff
	.db $28 $00 $00 $ff
	.db $50 $ff

@script2:
	.db $20 $00 $fe $f8
	.db $10 $00 $e8 $18
	.db $0a $00 $d8 $38
	.db $0a $00 $c8 $58
	.db $80 $00 $00 $ff
	.db $f8 $00 $00 $ff
	.db $18 $00 $00 $ff
	.db $38 $00 $00 $ff
	.db $58 $ff

@script3:
	.db $20 $00 $f8 $f8
	.db $20 $00 $d8 $18
	.db $00 $00 $d8 $38
	.db $00 $00 $d8 $58
	.db $80 $00 $00 $ff
	.db $f8 $00 $00 $ff
	.db $18 $00 $00 $ff
	.db $38 $00 $00 $ff
	.db $58 $ff
