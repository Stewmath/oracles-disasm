; ==================================================================================================
; PART_PUMPKIN_HEAD_PROJECTILE
; ==================================================================================================
partCode42:
	jp nz,partDelete
	ld e,$c4
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2

@state0:
	ld h,d
	ld l,e
	inc (hl)
	ld l,$c6
	ld (hl),$08
	ld l,$d0
	ld (hl),$3c
	ld e,$cb
	ld l,$cf
	ld a,(de)
	add (hl)
	ld (de),a
	ld (hl),$00
	ld e,$c2
	ld a,(de)
	ld bc,@table_7421
	call addAToBc
	ld l,$c9
	ld a,(bc)
	add (hl)
	and $1f
	ld (hl),a
	ld a,(de)
	or a
	jr nz,++
	ld a,(hl)
	rrca
	rrca
	ld hl,@table_7424
	rst_addAToHl
	ld e,$cb
	ld a,(de)
	add (hl)
	ld (de),a
	ld e,$cd
	inc hl
	ld a,(de)
	add (hl)
	ld (de),a
	ld b,$02
-
	call getFreePartSlot
	jr nz,++
	ld (hl),PART_PUMPKIN_HEAD_PROJECTILE
	inc l
	ld (hl),b
	ld l,$c9
	ld e,l
	ld a,(de)
	ld (hl),a
	call objectCopyPosition
	dec b
	jr nz,-
++
	ld e,$c9
	ld a,(de)
	or a
	jp z,objectSetVisible82
	jp objectSetVisible81

@table_7421:
	.db $00 $02 $fe

@table_7424:
	.db $fc $00 $02 $04
	.db $04 $00 $02 $fc

@state1:
	call partCommon_decCounter1IfNonzero
	jr nz,@state2
	ld l,e
	inc (hl)
	call objectSetVisible82

@state2:
	call partAnimate
	call objectApplySpeed
	call partCommon_checkTileCollisionOrOutOfBounds
	ret nc
	jp partDelete
