; ==================================================================================================
; INTERAC_9a
; ==================================================================================================
interactionCode9a:
	ld e,$44
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
@state0:
	ld a,GLOBALFLAG_MOBLINS_KEEP_DESTROYED
	call checkGlobalFlag
	jp z,interactionDelete
	ld a,$01
	ld (de),a
	ld e,$42
	ld a,(de)
	cp $02
	jr z,@@subid2
	call interactionInitGraphics
	jp objectSetVisible82
@@subid2:
	ld a,($cc36)
	or a
	jp z,interactionDelete
	xor a
	ld ($cc36),a
	ld a,GLOBALFLAG_DESTROYED_MOBLIN_HOUSE_REPAIRED
	call unsetGlobalFlag
	call getThisRoomFlags
	rlca
	jr nc,@bit7NotSet
	ld a,GLOBALFLAG_DESTROYED_MOBLIN_HOUSE_REPAIRED
	call setGlobalFlag
	xor a
	ld hl,$d100
	ld (hl),a
	ld l,$1a
	ld (hl),a
	push de
	ld de,@table_59e4
	call @func_59ba
	pop de

	ld e,$42
	ld a,$03
	ld (de),a
	ld a,$b9
	jr ++
@bit7NotSet:
	call getThisRoomFlags
	call func_5b49@func_5b65
	ld c,(hl)
	ld a,$03
	ld b,$aa
	call getRoomFlags
	ld (hl),c
	ld a,$b4
++
	ld h,d
	ld l,$70
	ld (hl),a
	ld a,$01
	ld (wDisabledObjects),a
	ld ($cc02),a
	ld l,$46
	ld (hl),$5a
	ret
@state1:
	ld e,$42
	ld a,(de)
	rst_jumpTable
	.dw @@subid0
	.dw @@subid1
	.dw @@subid2
	.dw state1_subid3
@@subid0:
	call interactionAnimate
	ld e,$61
	ld a,(de)
	or a
	ret z
	inc a
	jp z,interactionDelete
	xor a
	ld (de),a
	ld e,$43
	ld a,(de)
	or a
	ret z
	dec a
	ld hl,table_5a5e
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	push de
	ld b,(hl)
	inc hl
-
	ld c,(hl)
	inc hl
	ldi a,(hl)
	push bc
	push hl
	call setTile
	pop hl
	pop bc
	dec b
	jr nz,-
	pop de
	call getRandomNumber_noPreserveVars
	and $03
	add $02
	ld c,a
	ld b,$04
--
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERAC_9a
	inc l
	ld (hl),$01
	ld a,b
	add a
	add a
	add a
	add c
	and $1f
	ld l,$49
	ld (hl),a
	call getRandomNumber
	and $03
	push hl
	ld hl,@@table_5972
	rst_addAToHl
	ld a,(hl)
	pop hl
	ld l,$50
	ld (hl),a
	ld bc,$fe80
	call objectSetSpeedZ
	call objectCopyPosition
	dec b
	jr nz,--
	ret
@@table_5972:
	.db $3c $46 $50 $5a
@@subid1:
	call objectApplySpeed
	ld c,$28
	call objectUpdateSpeedZ_paramC
	jp z,interactionDelete
	ret
@@subid2:
	ld e,$45
	ld a,(de)
	rst_jumpTable
	.dw @@@substate0
	.dw @@@substate1
	.dw @@@substate2
@@@substate0:
	call returnIfScrollMode01Unset
	ld a,$01
	ld e,$45
	ld (de),a
	ret
@@@substate1:
	ld h,d
	ld l,$70
	dec (hl)
	jr nz,@@@substate2
	ld l,$45
	inc (hl)
	push de
	ld de,@table_59d8
	call @func_59ba
	pop de
@@@substate2:
	xor a
	call func_5a82
	ret nz
	ld hl,$cc69
	res 1,(hl)
	xor a
	ld (wDisabledObjects),a
	ld ($cc02),a
	jp interactionDelete

;;
; @param	de	Pointer to Interaction code to create 3 times
@func_59ba:
	ld b,$03
--
	call getFreeInteractionSlot
	jr nz,@ret
	ld a,(de)
	inc de
	ldi (hl),a
	ld a,(de)
	inc de
	ld (hl),a
	ld l,$4b
	ld a,(de)
	inc de
	ldi (hl),a
	inc l
	ld a,(de)
	inc de
	ld (hl),a
	ld l,$46
	ld (hl),$0a
	dec b
	jr nz,--
@ret:
	ret

@table_59d8:
	.db INTERAC_KING_MOBLIN, $01 $40 $78
	.db INTERAC_MOBLIN,      $02 $48 $68
	.db INTERAC_MOBLIN,      $02 $48 $88

@table_59e4:
	.db INTERAC_KING_MOBLIN, $02 $68 $78
	.db INTERAC_MOBLIN,      $03 $60 $58
	.db INTERAC_MOBLIN,      $03 $40 $58

state1_subid3:
	ld e,$45
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3
@substate0:
	call returnIfScrollMode01Unset
	ld a,$01
	ld e,$45
	ld (de),a
	ret
@substate1:
	ld h,d
	ld l,$70
	dec (hl)
	jr nz,+
	ld l,$45
	inc (hl)
	call fadeoutToWhite
+
	xor a
	jp func_5a82
@substate2:
	ld a,($c4ab)
	or a
	ret nz
	ldh (<hSprPaletteSources),a
	dec a
	ldh (<hDirtySprPalettes),a
	ld ($cfd0),a
	call interactionIncSubstate
	ld l,$46
	ld (hl),$1e
	ld hl,w1Link.yh
	ld a,$40
	ldi (hl),a
	inc l
	ld (hl),$50
	ld a,$80
	ld ($d01a),a
	ld a,$02
	ld ($d008),a
	call setLinkForceStateToState08
	push de
	call hideStatusBar
	pop de
	ld c,$02
	jpab bank1.loadDeathRespawnBufferPreset
@substate3:
	call interactionDecCounter1
	ret nz
	ld a,$03
	ld ($cc6a),a
	xor a
	ld (wLinkHealth),a
	jp interactionDelete
table_5a5e:
	; tile replacement tables
	; position - tiletype
	.dw @5a6a
	.dw @5a6d
	.dw @5a70
	.dw @5a73
	.dw @5a78
	.dw @5a7d
@5a6a:
	.db $01
	.db $36 $fd
@5a6d:
	.db $01
	.db $48 $fc
@5a70:
	.db $01
	.db $56 $fd
@5a73:
	.db $02
	.db $57 $fb
	.db $58 $fd
@5a78:
	.db $02
	.db $37 $fd
	.db $38 $fc
@5a7d:
	.db $02
	.db $46 $fb
	.db $47 $fd
func_5a82:
	ld h,d
	ld e,Interaction.counter1
	ld l,e
	dec (hl)
	ret nz
	ld hl,table_5ac4
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	; counter2
	inc e
	ld a,(de)
	add a
	rst_addDoubleIndex
	ld e,Interaction.counter1
	ldi a,(hl)
	ld (de),a
	inc a
	ret z

	; counter2 += 1 (next entry in the table next)
	inc e
	ld a,(de)
	inc a
	ld (de),a

	push de
	ld d,h
	ld e,l
	call getFreeInteractionSlot
	jr nz,++
	ld (hl),INTERAC_9a
	inc l
	ld (hl),$00
	inc l
	ld a,(de)
	inc de
	ld (hl),a
	ld l,$4b
	ld a,(de)
	ldi (hl),a
	inc de
	inc l
	ld a,(de)
	ld (hl),a
	ld a,$6f
	call playSound
	ld a,$08
	call setScreenShakeCounter
++
	pop de
	or $01
	ret
table_5ac4:
	.dw @5ac8
	.dw @5ae1
@5ac8:
	; 0 - into counter1 (time to create next entry)
	; 1 - into new interaction $9a00 var03
	; 2 - into new interaction $9a00 yh
	; 3 - into new interaction $9a00 xh
	.db $14 $01 $3a $68
	.db $14 $02 $46 $8a
	.db $10 $03 $56 $6a
	.db $10 $04 $58 $86
	.db $0c $05 $32 $7e
	.db $0c $06 $48 $73
	.db $ff
@5ae1:
	.db $0a $00 $58 $80
	.db $0a $00 $18 $38
	.db $0a $00 $48 $30
	.db $0a $00 $28 $68
	.db $0a $00 $68 $60
	.db $0a $00 $38 $40
	.db $0a $00 $58 $80
	.db $0a $00 $18 $20
	.db $0a $00 $48 $30
	.db $0a $00 $28 $68
	.db $0a $00 $68 $60
	.db $0a $00 $38 $40
	.db $ff
