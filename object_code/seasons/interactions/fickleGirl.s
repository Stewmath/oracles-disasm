; ==================================================================================================
; INTERAC_FICKLE_GIRL
; ==================================================================================================
interactionCode2e:
	ld e,$44
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
@state0:
	ld a,$01
	ld (de),a
	call getSunkenCityNPCVisibleSubId@main
	ld e,$42
	ld a,(de)
	cp b
	jp nz,interactionDelete
	call interactionInitGraphics
	ld a,(wActiveRoom)
	cp <ROOM_SEASONS_06d
	jr z,+
	ld a,$01
	ld e,$48
	ld (de),a
	call interactionSetAnimation
+
	ld e,$42
	ld a,(de)
	ld hl,table_5f7e
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	call interactionSetScript
	call getFreeInteractionSlot
	jr nz,+
	ld (hl),INTERAC_8e
	inc l
	ld (hl),$00
	ld l,$57
	ld (hl),d
	ld l,$49
	call @func_5f4e
+
	jr @var03_00
@state1:
	call interactionRunScript
	ld e,$43
	ld a,(de)
	rst_jumpTable
	.dw @var03_00
	.dw @var03_01
	.dw @var03_02
	.dw @var03_03
@var03_00:
	call interactionAnimate
	ld e,$61
	ld a,(de)
	inc a
	jr nz,@pushLinkAwayUpdateDrawPriority
@func_5efa:
	call func_5f70
@pushLinkAwayUpdateDrawPriority:
	jp interactionPushLinkAwayAndUpdateDrawPriority
@var03_01:
	call interactionAnimate
	ld e,$61
	ld a,(de)
	or a
	jr z,@pushLinkAwayUpdateDrawPriority
	call @func_5f65
	call getRandomNumber_noPreserveVars
	and $03
	jr nz,@func_5f3b
	inc a
	jr @func_5f3b
@var03_02:
@var03_03:
	call interactionAnimate
	ld e,$61
	ld a,(de)
	cp $02
	jr nz,@pushLinkAwayUpdateDrawPriority
	call @func_5f65
	call getFreePartSlot
	jr nz,+
	ld (hl),PART_POPPABLE_BUBBLE
	inc l
	ld (hl),$01
	ld l,$c9
	call @func_5f4e
+
	call getRandomNumber_noPreserveVars
	and $03
	sub $02
	ret c
	inc a
@func_5f3b:
	ld b,a
-
	call getFreePartSlot
	ret nz
	ld (hl),PART_POPPABLE_BUBBLE
	inc l
	ld (hl),$00
	ld l,$c9
	call @func_5f4e
	dec b
	jr nz,-
	ret
@func_5f4e:
	push bc
	ld e,$48
	ld a,(de)
	rrca
	ld c,$f8
	ld a,$1c
	jr nc,+
	ld c,$0a
	ld a,$06
+
	ld (hl),a
	ld b,$02
	call objectCopyPositionWithOffset
	pop bc
	ret
@func_5f65:
	ld e,$48
	ld a,(de)
	and $01
	call interactionSetAnimation
	call @func_5efa
func_5f70:
	ld e,$76
	ld a,$01
	ld (de),a
	call getRandomNumber_noPreserveVars
	and $03
	ld e,$43
	ld (de),a
	ret

table_5f7e:
	.dw mainScripts.sunkenCityFickleGirlScript_text1
	.dw mainScripts.sunkenCityFickleGirlScript_text2
	.dw mainScripts.sunkenCityFickleGirlScript_text2
	.dw mainScripts.sunkenCityFickleGirlScript_text3
	.dw mainScripts.sunkenCityFickleGirlScript_text2
