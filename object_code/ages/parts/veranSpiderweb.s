; ==================================================================================================
; PART_VERAN_SPIDERWEB
; ==================================================================================================
partCode56:
	jr z,@normalStatus
	ld e,$ea
	ld a,(de)
	cp $80
	jr nz,@normalStatus
	ld hl,$d031
	ld (hl),$10
	ld l,$30
	ld (hl),$00
	ld l,$24
	res 7,(hl)
	ld bc,$fa00
	call objectCopyPositionWithOffset
	ld h,d
	ld l,$f0
	ld (hl),$01
	ld l,$c4
	ldi a,(hl)
	dec a
	jr nz,@normalStatus
	inc l
	ld a,$01
	ldi (hl),a
	ld (hl),a
@normalStatus:
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
	jr z,@func_7c2e
	call partCommon_decCounter1IfNonzero
	jr nz,++
	ld (hl),$04
	call getFreePartSlot
	jr nz,++
	ld (hl),PART_VERAN_SPIDERWEB
	inc l
	ld (hl),$02
	ld l,$d6
	ld e,l
	ld a,(de)
	ldi (hl),a
	inc e
	ld a,(de)
	ld (hl),a
	call objectCopyPosition
++
	ld a,$02
	call objectGetRelatedObject1Var
	ld a,(hl)
	dec a
	jp nz,@func_7c28
	ld c,h
	ldh a,(<hCameraY)
	ld b,a
	ld e,$cf
	ld a,(de)
	sub $04
	ld (de),a
	ld h,d
	ld l,$cb
	add (hl)
	sub b
	cp $b0
	ret c
	ld h,c
	ld l,$b8
	inc (hl)
	jp partDelete

@func_7c28:
	call objectCreatePuff
	jp partDelete
	
@func_7c2e:
	ld h,d
	ld l,e
	inc (hl)
	ld l,$c6
	inc (hl)
	call objectSetVisible80
@beamSound:
	ld a,SND_BEAM2
	jp playSound
	
@subid1:
	ld a,$02
	call objectGetRelatedObject1Var
	ld a,(hl)
	dec a
	jr nz,@func_7c28
	ld l,$ad
	ld a,(hl)
	or a
	jr nz,@func_7c28
	ld e,$c4
	ld a,(de)
	rst_jumpTable
	.dw @@state0
	.dw @@state1
	.dw @@state2
	.dw @@state3
	.dw @@state4
	
@@state0:
	ld h,d
	ld l,e
	inc (hl)
	ld l,$c6
	ld (hl),$01
	inc l
	ld (hl),$05
	ld l,$e4
	set 7,(hl)
	ld l,$d0
	ld (hl),$50
	ld l,$f1
	ld e,$cb
	ld a,(de)
	add $10
	ldi (hl),a
	ld (de),a
	ld e,$cd
	ld a,(de)
	ld (hl),a
	call objectGetAngleTowardLink
	cp $0e
	ld b,$0c
	jr c,+
	ld b,$10
	cp $13
	jr c,+
	ld b,$14
+
	ld e,$c9
	ld a,b
	ld (de),a
	call objectSetVisible81
	jr @beamSound
	
@@state1:
	call partCommon_decCounter1IfNonzero
	jr nz,+
	ld (hl),$08
	inc l
	dec (hl)
	jr z,++
	call getFreePartSlot
	jr nz,+
	ld (hl),PART_VERAN_SPIDERWEB
	inc l
	ld (hl),$03
	ld l,$d6
	ld a,$c0
	ldi (hl),a
	ld (hl),d
	call objectCopyPosition
+
	call partCommon_checkTileCollisionOrOutOfBounds
	jp nc,objectApplySpeed
++
	ld h,d
	ld l,$c4
	inc (hl)
	ld l,$c6
	ld (hl),$1e
	ld l,$d0
	ld (hl),$3c
	ld l,$c9
	ld a,(hl)
	xor $10
	ld (hl),a
	ret
	
@@state2:
	call partCommon_decCounter1IfNonzero
	ret nz
	ld l,$c4
	inc (hl)
	ret
	
@@state3:
	call objectApplySpeed
	ld e,$f0
	ld a,(de)
	or a
	jr z,+
	ld bc,$fa00
	ld hl,$d000
	call objectCopyPositionWithOffset
+
	ld h,d
	ld l,$f1
	ld e,$cb
	ld a,(de)
	sub (hl)
	add $02
	cp $05
	ret nc
	ld l,$f2
	ld e,$cd
	ld a,(de)
	sub (hl)
	add $02
	cp $05
	ret nc
	ld a,$38
	call objectGetRelatedObject1Var
	inc (hl)
	ld e,$f0
	ld a,(de)
	or a
	jp z,partDelete
	ld l,$86
	ld (hl),$08
	ld h,d
	ld l,$c4
	inc (hl)
	ret
	
@@state4:
	ld hl,$d005
	ld a,(hl)
	cp $02
	jp z,partDelete
	ld bc,$0600
	jp objectTakePositionWithOffset
	
@subid2:
	ld a,(de)
	or a
	jr z,@func_7d39
	ld a,$1a
	call objectGetRelatedObject1Var
	bit 7,(hl)
	jr z,@@delete
	ld l,$8f
	ld b,(hl)
	dec b
	ld e,$cf
	ld a,(de)
	dec a
	cp b
	ret c
@@delete:
	jp partDelete
	
@func_7d39:
	inc a
	ld (de),a
	inc a
	call partSetAnimation
	jp objectSetVisible80
	
@subid3:
	ld a,(de)
	or a
	jr z,@func_7d59
	ld a,$01
	call objectGetRelatedObject1Var
	ld a,(hl)
	cp $56
	jr nz,@@delete
	ld l,$cb
	ld e,l
	ld a,(de)
	cp (hl)
	ret c
@@delete:
	jp partDelete

@func_7d59:
	inc a
	ld (de),a
	ld a,$09
	call objectGetRelatedObject1Var
	ld a,(hl)
	sub $0c
	rrca
	rrca
	inc a
	call partSetAnimation
	jp objectSetVisible83
