; ==================================================================================================
; PART_51
; Used by Ganon
; ==================================================================================================
partCode51:
	ld a,$04
	call objectGetRelatedObject1Var
	ld a,(hl)
	cp $0e
	jp z,partDelete
	ld e,$c2
	ld a,(de)
	ld e,$c4
	rst_jumpTable
	.dw @subid0
	.dw @subid1
	.dw @subid2

@subid0:
	ld a,(de)
	or a
	jr nz,+
	ld h,d
	ld l,e
	inc (hl)
	ld l,$c6
	ld (hl),$40
	ld l,$e8
	ld (hl),$f0
	ld l,$da
	ld (hl),$02
	ld a,SND_ENERGYTHING
	call playSound
+
	call partCommon_decCounter1IfNonzero
	jp z,partDelete
	jr +

@subid2:
	ld a,(de)
	or a
	jr z,++
	ld e,$e1
	ld a,(de)
	rlca
	jp c,partDelete
+
	ld e,$da
	ld a,(de)
	xor $80
	ld (de),a
	jp partAnimate
++
	ld h,d
	ld l,e
	inc (hl)
	ld l,$e4
	set 7,(hl)
	ld l,$c9
	ld a,(hl)
	ld b,$01
	cp $0c
	jr c,+
	inc b
	cp $19
	jr c,+
	inc b
+
	ld a,b
	dec a
	and $01
	ld hl,@table_5bde
	rst_addDoubleIndex
	ld e,$e6
	ldi a,(hl)
	ld (de),a
	inc e
	ld a,(hl)
	ld (de),a
	ld a,b
	call partSetAnimation
	jp objectSetVisible83

@table_5bde:
	.db $08 $0a
	.db $0a $0a

@subid1:
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2

@state0:
	ld h,d
	ld l,e
	inc (hl)
	ld l,$dd
	ld a,(hl)
	add $0e
	ld (hl),a
	ld l,$c6
	ld (hl),$18
	ld a,$04
	call partSetAnimation
	jp objectSetVisible82

@state1:
	call partCommon_decCounter1IfNonzero
	jr nz,@animate
	dec (hl)
	ld l,e
	inc (hl)
	ld l,$e4
	set 7,(hl)
	ld l,$db
	ld a,$05
	ldi (hl),a
	ld (hl),a
	ld l,$cb
	ld a,(hl)
	add $08
	ldi (hl),a
	inc l
	ld a,(hl)
	sub $10
	ld (hl),a
	call objectGetAngleTowardLink
	ld e,$c9
	ld (de),a
	ld c,a
	ld b,$50
	ld a,$02
	jp objectSetComponentSpeedByScaledVelocity

@state2:
	call partCommon_checkTileCollisionOrOutOfBounds
	jr nc,+
	ld b,INTERAC_EXPLOSION
	call objectCreateInteractionWithSubid00
	ld a,$3c
	call z,setScreenShakeCounter
	jp partDelete
+
	call partCommon_decCounter1IfNonzero
	ld a,(hl)
	and $07
	jr nz,+
	call getFreePartSlot
	jr nz,+
	ld (hl),PART_51
	inc l
	ld (hl),$02
	ld l,$c9
	ld e,l
	ld a,(de)
	ld (hl),a
	call objectCopyPosition
+
	call objectApplyComponentSpeed
@animate:
	jp partAnimate
