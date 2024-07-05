; ==================================================================================================
; PART_DEKU_SCRUB_PROJECTILE
; ==================================================================================================
partCode1e:
	jr z,@normalStatus
	ld e,$ea
	ld a,(de)
	cp $80
	jr z,@normalStatus
	call func_52fd
	ld h,d
	ld l,$c4
	ld (hl),$03
	ld l,$e4
	res 7,(hl)
@normalStatus:
	ld e,$c4
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3
	.dw partCommon_updateSpeedAndDeleteWhenCounter1Is0
	.dw @state5

@state0:
	ld h,d
	ld l,e
	inc (hl)
	ld l,$d0
	ld (hl),$50
	ld l,$c6
	ld (hl),$08
	ld a,SND_STRIKE
	call playSound
	jp objectSetVisible81

@state1:
	call partCommon_decCounter1IfNonzero
	jr nz,+
	ld l,e
	inc (hl)

@state2:
	call partCommon_checkTileCollisionOrOutOfBounds
	jr nc,+
	jr nz,func_52f4
	jr @state5
+
	call objectCheckWithinScreenBoundary
	jp c,objectApplySpeed
	jr @state5

@state3:
	call func_5336
	jr @state2

@state5:
	jp partDelete

func_52f4:
	ld e,$c4
	ld a,$04
	ld (de),a
	xor a
	jp partCommon_bounceWhenCollisionsEnabled

func_52fd:
	ld e,$c9
	ld a,(de)
	bit 2,a
	jr nz,func_5313
	sub $08
	rrca
	ld b,a
	ld a,(w1Link.direction)
	add b
	ld hl,table_532a
	rst_addAToHl
	ld a,(hl)
	ld (de),a
	ret

func_5313:
	sub $0c
	rrca
	ld b,a
	ld a,(w1Link.direction)
	add b
	ld hl,table_5322
	rst_addAToHl
	ld a,(hl)
	ld (de),a
	ret

table_5322:
	.db $04 $08 $10 $14
	.db $1c $0c $10 $18

table_532a:
	.db $04 $08 $0c $18
	.db $00 $0c $10 $14
	.db $1c $08 $14 $18

func_5336:
	ld a,$24
	call objectGetRelatedObject1Var
	bit 7,(hl)
	ret z
	call checkObjectsCollided
	ret nc
	ld l,$aa
	ld (hl),$82
	ld l,$b0
	dec (hl)
	ld l,$ab
	ld (hl),$0c
	ld e,$c4
	ld a,$04
	ld (de),a
	ret
