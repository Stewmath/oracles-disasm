; ==================================================================================================
; PART_VIRE_PROJECTILE
; ==================================================================================================
partCode3a:
	jr z,+	 
	ld e,$ea
	ld a,(de)
	res 7,a
	cp $04
	jp c,partDelete
	jp func_6e4a
+
	ld e,$c2
	ld a,(de)
	ld e,$c4
	rst_jumpTable
	.dw @subid0
	.dw @subid1
	.dw @subid2
	.dw @subid3
	
@subid0:
	ld a,(de)
	or a
	jr z,@subid0_state0
@func_6ceb:
	call partCommon_checkOutOfBounds
	jp z,partDelete
	call objectApplySpeed
	jp partAnimate
@subid0_state0:
	call func_6e50
	call objectGetAngleTowardEnemyTarget
	ld e,$c9
	ld (de),a
	call func_6e5d
	jp objectSetVisible80
	
@subid1:
	ld a,(de)
	or a
	jr nz,@func_6ceb
	call func_6e50
	call func_6e2f
	ld e,$c3
	ld a,(de)
	or a
	ret nz
	call objectGetAngleTowardEnemyTarget
	ld e,$c9
	ld (de),a
	sub $02
	and $1f
	ld b,a
	ld e,$01
;;
; @param	b	angle of new part
; @param	e	subid of new part
@func_6d22:
	call getFreePartSlot
	ld (hl),PART_VIRE_PROJECTILE
	inc l
	ld (hl),e
	inc l
	inc (hl)
	ld l,$c9
	ld (hl),b
	ld l,$d6
	ld e,l
	ld a,(de)
	ldi (hl),a
	inc e
	ld a,(de)
	ld (hl),a
	jp objectCopyPosition

@subid2:
	ld a,(de)
	rst_jumpTable
	.dw @subid2_state0
	.dw @subid2_state1
	.dw @subid2_state2
	.dw @func_6ceb
@subid2_state0:
	ld h,d
	ld l,$db
	ld a,$03
	ldi (hl),a
	ld (hl),a
	ld l,$c3
	ld a,(hl)
	or a
	jr z,@fimc_6d5e
	ld l,e
	ld (hl),$03
	call func_6e5d
	ld a,$01
	call partSetAnimation
	jp objectSetVisible82
	
@fimc_6d5e:
	call func_6e50
	ld l,$f0
	ldh a,(<hEnemyTargetY)
	ldi (hl),a
	ldh a,(<hEnemyTargetX)
	ld (hl),a
	ld a,$29
	call objectGetRelatedObject1Var
	ld a,(hl)
	ld b,$19
	cp $10
	jr nc,+
	ld b,$2d
	cp $0a
	jr nc,+
	ld b,$41
+
	ld e,$d0
	ld a,b
	ld (de),a
	jp objectSetVisible80
	
@subid2_state1:
	ld h,d
	ld l,$f0
	ld b,(hl)
	inc l
	ld c,(hl)
	ld l,$cb
	ldi a,(hl)
	ldh (<hFF8F),a
	inc l
	ld a,(hl)
	ldh (<hFF8E),a
	sub c
	add $02
	cp $05
	jr nc,@func_6dba
	ldh a,(<hFF8F)
	sub b
	add $02
	cp $05
	jr nc,@func_6dba
	ldbc INTERAC_PUFF $02
	call objectCreateInteraction
	ret nz
	ld e,$d8
	ld a,$40
	ld (de),a
	inc e
	ld a,h
	ld (de),a
	ld e,$c4
	ld a,$02
	ld (de),a
	jp objectSetInvisible

@func_6dba:
	call objectGetRelativeAngleWithTempVars
	ld e,$c9
	ld (de),a
	call objectApplySpeed
	jp partAnimate
	
@subid2_state2:
	ld a,$21
	call objectGetRelatedObject2Var
	bit 7,(hl)
	ret z
	ld b,$05
	call checkBPartSlotsAvailable
	ret nz
	ld c,$05
-
	ld a,c
	dec a
	ld hl,@table_6df8
	rst_addAToHl
	ld b,(hl)
	ld e,$02
	call @func_6d22
	dec c
	jr nz,-
	ld h,d
	ld l,$c4
	inc (hl)
	ld l,$c9
	ld (hl),$1d
	call func_6e5d
	ld a,$01
	call partSetAnimation
	jp objectSetVisible82
@table_6df8:
	.db $03 $08 $0d $13 $18
	
@subid3:
	ld a,(de)
	or a
	jr z,@subid3_state0
	call partCommon_decCounter1IfNonzero
	jp z,func_6e4a
	inc l
	dec (hl)
	jr nz,+
	ld (hl),$07
	call objectGetAngleTowardEnemyTarget
	call objectNudgeAngleTowards
+
	call objectApplySpeed
	jp partAnimate

@subid3_state0:
	call func_6e50
	ld l,$c6
	ld (hl),$f0
	inc l
	ld (hl),$07
	ld l,$db
	ld a,$02
	ldi (hl),a
	ld (hl),a
	call objectGetAngleTowardEnemyTarget
	ld e,$c9
	ld (de),a
	
func_6e2f:
	ld a,$29
	call objectGetRelatedObject1Var
	ld a,(hl)
	ld b,$1e
	cp $10
	jr nc,+
	ld b,$2d
	cp $0a
	jr nc,+
	ld b,$3c
+
	ld e,$d0
	ld a,b
	ld (de),a
	jp objectSetVisible80

func_6e4a:
	call objectCreatePuff
	jp partDelete

func_6e50:
	ld h,d
	ld l,e
	inc (hl)
	ld l,$cf
	ld a,(hl)
	ld (hl),$00
	ld l,$cb
	add (hl)
	ld (hl),a
	ret
	
func_6e5d:
	ld a,$29
	call objectGetRelatedObject1Var
	ld a,(hl)
	ld b,$3c
	cp $10
	jr nc,+
	ld b,$5a
	cp $0a
	jr nc,+
	ld b,$78
+
	ld e,$d0
	ld a,b
	ld (de),a
	ret
