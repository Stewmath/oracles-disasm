; ==================================================================================================
; PART_3e
;
; Variables:
;   var30-3f: stores enemy index of every loaded Ambi Guard
; ==================================================================================================
partCode3e:
	ld e,$c4
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3
@state0:
	ld h,d
	ld l,e
	inc (hl)
	ld e,Part.var30
	ldhl FIRST_ENEMY_INDEX, Enemy.id
-
	ld a,(hl)
	cp ENEMY_AMBI_GUARD
	jr nz,+
	ld a,h
	ld (de),a
	inc e
+
	inc h
	ld a,h
	cp LAST_ENEMY_INDEX+1
	jr c,-
	ret

@state1:
	ld hl,$d700
-
	ld l,Object.collisionType
	ld a,(hl)
	cp $98
	jr z,+
	inc h
	ld a,h
	cp $dc
	jr c,-
	ret
+
	ld a,$02
	ld (de),a

	ld e,Part.relatedObj2+1
	ld a,h
	ld (de),a
	ret

@state2:
	ld h,d
	ld l,Part.state
	inc (hl)

	ld l,Part.counter1
	ld (hl),$3c

	ld l,Part.relatedObj2+1
	ld b,(hl)
	ld e,Part.var30
-
	ld a,(de)
	or a
	ret z

	ld h,a
	ld l,Enemy.var3a
	ld (hl),$ff
	ld l,Enemy.relatedObj2
	ld (hl),$00
	inc l
	ld (hl),b
	inc e
	ld a,e
	cp Part.var34
	jr c,-
	ret

@state3:
	call partCommon_decCounter1IfNonzero
	ret nz
	ld l,e
	ld (hl),$01
	ret
