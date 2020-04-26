 m_section_force "staticObjects" NAMESPACE staticObjects

;;
; Reads the static object buffer and creates the objects for the room.
; @addr{5015}
parseStaticObjects:
	ld de,wStaticObjects		; $5015
@next:
	ld c,e			; $5018
	ld a,(de)		; $5019
	or a			; $501a
	jr z,@noMatch		; $501b

	inc e			; $501d
	ld a,(de)		; $501e
	ld b,a			; $501f
	ld a,(wActiveRoom)		; $5020
	cp b			; $5023
	jr z,@foundRoom		; $5024
@noMatch:
	ld a,c			; $5026
	add $08			; $5027
	ld e,a			; $5029
.ifdef ROM_AGES
	cp <(wStaticObjects+_sizeof_wStaticObjects)	; $502a
	jr c,@next		; $502c
.else
	or a			; $4e4a
	jr nz,@next	; $4e4b
.endif
	ret			; $502e

@foundRoom:
	dec e			; $502f
	ld a,(de)		; $5030
	bit 7,a			; $5031
	jr nz,@noMatch		; $5033

	and $7f			; $5035
	rst_jumpTable			; $5037
.dw @end
.dw @end
.dw @end
.dw @interaction
.dw @enemy
.dw @part

@end:
	ld a,e			; $5044
	add $08			; $5045
	ld e,a			; $5047
	jr @next		; $5048

@interaction:
	call getFreeInteractionSlot		; $504a
	jr nz,@end		; $504d
	jr ++			; $504f

@enemy:
	call getFreeEnemySlot		; $5051
	jr nz,@end		; $5054
	jr ++			; $5056

@part:
	call getFreePartSlot		; $5058
	jr nz,@end		; $505b
++
	inc e			; $505d
	inc e			; $505e
	ld a,(de)		; $505f
	bit 7,a			; $5060
	jr z,+			; $5062

	dec l			; $5064
	set 1,(hl)		; $5065
	inc l			; $5067
+
	; B2: ID
	and $7f			; $5068
	ldi (hl),a		; $506a

	; B3: Sub ID
	inc e			; $506b
	ld a,(de)		; $506c
	ld (hl),a		; $506d

	; B4: Y
	ld a,l			; $506e
	add Object.yh-Object.subid	; $506f
	ld l,a			; $5071
	inc e			; $5072
	ld a,(de)		; $5073
	ldi (hl),a		; $5074

	; B5: X
	inc l			; $5075
	inc e			; $5076
	ld a,(de)		; $5077
	ld (hl),a		; $5078

	; Set RelatedObj1 (actually a pointer to its position in wStaticObjects)
	ld a,l			; $5079
	add Object.relatedObj1-Object.xh		; $507a
	ld l,a			; $507c
	ld a,e			; $507d
	and $f8			; $507e
	ld e,a			; $5080
	ldi (hl),a		; $5081
	ld (hl),d		; $5082
	jr @end		; $5083

;;
; This function is called from "loadStaticObjects" in bank 0.
; Loads the static objects for the current dungeon. (Doesn't check whether you're actually
; in a dungeon.)
; @addr{5085}
loadStaticObjects_body:
	call clearStaticObjects		; $5085
	ld a,(wDungeonIndex)		; $5088
	ld hl,staticDungeonObjects	; $508b
	rst_addDoubleIndex			; $508e
	ldi a,(hl)		; $508f
	ld h,(hl)		; $5090
	ld l,a			; $5091
	ld de,wStaticObjects		; $5092
@next:
	ldi a,(hl)		; $5095
	cp $ff			; $5096
	ret z			; $5098
	ld (de),a		; $5099
	ld b,$05		; $509a
@copyLoop:
	ldi a,(hl)		; $509c
	inc e			; $509d
	ld (de),a		; $509e
	dec b			; $509f
	jr nz,@copyLoop		; $50a0

	inc e			; $50a2
	inc e			; $50a3
	inc e			; $50a4
	jr @next		; $50a5

.ends
