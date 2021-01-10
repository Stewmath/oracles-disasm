; Namespace "bank4".

.ifdef ROM_SEASONS

;;
; If entering certain warps blocked by snow piles, mushrooms, or bushes, set the animal companion to
; appear right outside the entrance instead of where you left them.
updateAnimalSavePointForRando:
	ld a,(wActiveRoom)
	ld b,a
	ld a,(wRememberedCompanionRoom)
	ld c,a
	ld e,$02
	ld hl,@animalSavePointTable
	call searchDoubleKey
	jr nc,@done
	ld de,wRememberedCompanionY
	ldi a,(hl)
	ld (de),a
	inc de
	ld a,(hl)
	ld (de),a
@done:
	ret


; Format: source room; animal room; saved y; saved x.
@animalSavePointTable:
      .db $c2, $c2, $18, $68 ; spool swamp cave
      .db $29, $2a, $38, $18 ; goron mountain east cave
      .db $8e, $8e, $58, $88 ; cave outside d2
      .db $87, $86, $48, $68 ; cave north of d1
      .db $28, $2a, $38, $18 ; goron mountain main
      .db $0f, $2f, $18, $68 ; spring banana cave
      .db $1f, $2f, $18, $68 ; cave below spring banana cave
      .db $9a, $9a, $38, $48 ; rosa portal
      .db $8d, $8d, $38, $38 ; d2 entrance
      .db $ff

.endif
