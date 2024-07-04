m_section_free staticObjects NAMESPACE staticObjects

;;
; Reads the static object buffer and creates the objects for the room.
parseStaticObjects:
	ld de,wStaticObjects
@next:
	ld c,e
	ld a,(de)
	or a
	jr z,@noMatch

	inc e
	ld a,(de)
	ld b,a
	ld a,(wActiveRoom)
	cp b
	jr z,@foundRoom
@noMatch:
	ld a,c
	add $08
	ld e,a
.ifdef ROM_AGES
	cp <(wStaticObjects+_sizeof_wStaticObjects)
	jr c,@next
.else
	or a
	jr nz,@next
.endif
	ret

@foundRoom:
	dec e
	ld a,(de)
	bit 7,a
	jr nz,@noMatch

	and $7f
	rst_jumpTable
	.dw @end
	.dw @end
	.dw @end
	.dw @interaction
	.dw @enemy
	.dw @part

@end:
	ld a,e
	add $08
	ld e,a
	jr @next

@interaction:
	call getFreeInteractionSlot
	jr nz,@end
	jr ++

@enemy:
	call getFreeEnemySlot
	jr nz,@end
	jr ++

@part:
	call getFreePartSlot
	jr nz,@end
++
	inc e
	inc e
	ld a,(de)
	bit 7,a
	jr z,+

	dec l
	set 1,(hl)
	inc l
+
	; B2: ID
	and $7f
	ldi (hl),a

	; B3: Sub ID
	inc e
	ld a,(de)
	ld (hl),a

	; B4: Y
	ld a,l
	add Object.yh-Object.subid
	ld l,a
	inc e
	ld a,(de)
	ldi (hl),a

	; B5: X
	inc l
	inc e
	ld a,(de)
	ld (hl),a

	; Set RelatedObj1 (actually a pointer to its position in wStaticObjects)
	ld a,l
	add Object.relatedObj1-Object.xh
	ld l,a
	ld a,e
	and $f8
	ld e,a
	ldi (hl),a
	ld (hl),d
	jr @end

;;
; This function is called from "loadStaticObjects" in bank 0.
; Loads the static objects for the current dungeon. (Doesn't check whether you're actually
; in a dungeon.)
loadStaticObjects_body:
	call clearStaticObjects
	ld a,(wDungeonIndex)
	ld hl,staticDungeonObjects
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	ld de,wStaticObjects
@next:
	ldi a,(hl)
	cp $ff
	ret z
	ld (de),a
	ld b,$05
@copyLoop:
	ldi a,(hl)
	inc e
	ld (de),a
	dec b
	jr nz,@copyLoop

	inc e
	inc e
	inc e
	jr @next

.ends
