; ==================================================================================================
; PART_BEAM
; ==================================================================================================
partCode29:
	jr z,@normalStatus
	ld e,$ea
	ld a,(de)
	cp $83
	jp z,partDelete
@normalStatus:
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
	ld (hl),$02
	ld l,$c9
	ld c,(hl)
	ld b,$50
	ld a,$04
	call objectSetComponentSpeedByScaledVelocity
	ld e,$c9
	ld a,(de)
	and $0f
	ld hl,@table_5737
	rst_addAToHl
	ld a,(hl)
	jp partSetAnimation

@table_5737:
	.db $00 $00 $01 $02
	.db $02 $02 $03 $04
	.db $04 $04 $05 $06
	.db $06 $06 $07 $00

@state1:
	call partCommon_decCounter1IfNonzero
	jr nz,func_5758
	ld l,e
	inc (hl)

@state2:
	call func_5758
	call partCommon_checkTileCollisionOrOutOfBounds
	jp c,partDelete
	ret

func_5758:
	call objectApplyComponentSpeed
	ld e,$c2
	ld a,(de)
	ld b,a
	ld a,(wFrameCounter)
	and b
	jp z,objectSetVisible81
	jp objectSetInvisible
