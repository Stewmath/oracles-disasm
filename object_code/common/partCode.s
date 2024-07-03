label_11_212:
	ld d,$d0
	ld a,d
-
	ldh (<hActiveObject),a
	ld e,$c0
	ld a,(de)
	or a
	jr z,++
	rlca
	jr c,+
	ld e,$c4
	ld a,(de)
	or a
	jr nz,++
+
	call func_11_5e8a
++
	inc d
	ld a,d
	cp $e0
	jr c,-
	ret

;;
updateParts:
	ld a,$c0
	ldh (<hActiveObjectType),a
	ld a,(wScrollMode)
	cp $08
	jr z,label_11_212
	ld a,(wTextIsActive)
	or a
	jr nz,label_11_212

	ld a,(wDisabledObjects)
	and $88
	jr nz,label_11_212

	ld d,FIRST_PART_INDEX
	ld a,d
-
	ldh (<hActiveObject),a
	ld e,Part.enabled
	ld a,(de)
	or a
	jr z,+

	call func_11_5e8a
	ld h,d
	ld l,Part.var2a
	res 7,(hl)
+
	inc d
	ld a,d
	cp LAST_PART_INDEX+1
	jr c,-
	ret

;;
func_11_5e8a:
	call partCommon_standardUpdate

	; hl = partCodeTable + [Part.id] * 2
	ld e,Part.id
	ld a,(de)
	add a
	add <partCodeTable
	ld l,a
	ld a,$00
	adc >partCodeTable
	ld h,a

	ldi a,(hl)
	ld h,(hl)
	ld l,a

	ld a,c
	or a
	jp hl
