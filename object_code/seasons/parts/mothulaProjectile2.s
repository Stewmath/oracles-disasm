; ==================================================================================================
; PART_MOTHULA_PROJECTILE_2
; ==================================================================================================
partCode42:
	jr z,@normalStatus
	ld e,$ea
	ld a,(de)
	res 7,a
	cp $04
	jr c,@delete
@normalStatus:
	ld e,$c4
	ld a,(de)
	or a
	jr z,@state0
	call partCode.partCommon_checkTileCollisionOrOutOfBounds
	jr z,@delete
	ld e,$c2
	ld a,(de)
	cp $02
	jr z,+
	call partCommon_decCounter1IfNonzero
	jr nz,+
	inc l
	ld e,$f0
	ld a,(de)
	inc a
	and $01
	ld (de),a
	add (hl)
	ldd (hl),a
	ld (hl),a
	ld l,$c9
	ld a,(hl)
	add $02
	and $1f
	ld (hl),a
+
	call objectApplySpeed
	call partAnimate
	ld e,$e1
	ld a,(de)
	inc a
	ret nz
@delete:
	jp partDelete
@state0:
	call func_7174
	ret nz
	call objectSetVisible82
	ld h,d
	ld l,$c4
	inc (hl)
	ld e,$c2
	ld a,(de)
	cp $02
	jr nz,+
	ld l,$cf
	ld a,(hl)
	ld (hl),$00
	ld l,$cb
	add (hl)
	ld (hl),a
	ld l,$d0
	ld (hl),$32
	ret
+
	ld l,$cf
	ld a,(hl)
	ld (hl),$fa
	add $06
	ld l,$cb
	add (hl)
	ld (hl),a
	ld l,$d0
	ld (hl),$78
	ld l,$c6
	ld a,$02
	ldi (hl),a
	ld (hl),a
	ld a,$01
	jp partSetAnimation
func_7174:
	ld e,$c2
	ld a,(de)
	bit 7,a
	jr z,func_71b5
	rrca
	ld a,$04
	ld bc,$0300
	jr nc,+
	ld a,$03
	ld bc,$0503
+
	ld e,$c9
	ld (de),a
	ld e,$c2
	xor a
	ld (de),a
	push bc
	call checkBPartSlotsAvailable
	pop bc
	ret nz
	ld a,b
	ldh (<hFF8B),a
	ld a,c
	ld bc,table_71fc
	call addAToBc
-
	push bc
	call getFreePartSlot
	ld (hl),PART_MOTHULA_PROJECTILE_2
	call objectCopyPosition
	pop bc
	ld l,$c9
	ld a,(bc)
	ld (hl),a
	inc bc
	ld hl,$ff8b
	dec (hl)
	jr nz,-
	ret
func_71b5:
	dec a
	jr z,+
	xor a
	ret
+
	ld b,$05
	call checkBPartSlotsAvailable
	ret nz
	ld a,$09
	call objectGetRelatedObject1Var
	ld a,(hl)
	add $08
	and $1f
	ld b,a
	ld c,$02
	ld h,d
	ld l,$c9
	sub c
	and $1f
	ld (hl),a
	ld l,$c2
	ld (hl),c
	call func_71e2
	ld a,b
	add $0c
	and $1f
	ld b,a
	ld c,$03

func_71e2:
	push bc
	call getFreePartSlot
	ld (hl),PART_MOTHULA_PROJECTILE_2
	inc l
	ld (hl),$02
	call objectCopyPosition
	pop bc
	ld l,$c9
	ld (hl),b
	ld a,b
	add $02
	and $1f
	ld b,a
	dec c
	jr nz,func_71e2
	ret
table_71fc:
	.db $0c $14 $1c $08
	.db $0d $13 $18 $1d
