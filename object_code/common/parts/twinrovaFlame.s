; ==================================================================================================
; PART_TWINROVA_FLAME
; ==================================================================================================
partCode4c:
	jr z,@normalStatus
	ld e,$ea
	ld a,(de)
	cp $80
	jp nz,partDelete
@normalStatus:
	ld e,$c2
	ld a,(de)
	or a
	ld e,$c4
	ld a,(de)
	jr z,@subid0
	or a
	jr z,+
	call partAnimate
	call objectApplySpeed
	call partCommon_checkTileCollisionOrOutOfBounds
	ret nz
	jp partDelete
+
	ld h,d
	ld l,e
	inc (hl)
	ld l,$d0
	ld (hl),$50
	ld l,$db
	ld a,$05
	ldi (hl),a
	ld (hl),a
	ld l,$e6
	ld a,$02
	ldi (hl),a
	ld (hl),a
	ld a,SND_BEAM2
	call playSound
	ld a,$01
	call partSetAnimation
	jp objectSetVisible82

@subid0:
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2

@state0:
	ld h,d
	ld l,e
	inc (hl)
	ld l,$d0
	ld (hl),$46
	ld l,$c6
	ld (hl),$1e
	jp objectSetVisible82

@state1:
	call partCommon_decCounter1IfNonzero
	jp nz,partAnimate
	ld l,e
	inc (hl)
	call objectGetAngleTowardEnemyTarget
	ld e,$c9
	ld (de),a

@state2:
	call partAnimate
	call objectApplySpeed
	call partCommon_checkTileCollisionOrOutOfBounds
	ret nc
	call objectGetAngleTowardEnemyTarget
	sub $02
	and $1f
	ld c,a
	ld b,$03
-
	call getFreePartSlot
	jr nz,+
	ld (hl),PART_TWINROVA_FLAME
	inc l
	inc (hl)
	ld l,$c9
	ld (hl),c
	call objectCopyPosition
+
	ld a,c
	add $02
	and $1f
	ld c,a
	dec b
	jr nz,-
	call objectCreatePuff
	jp partDelete
