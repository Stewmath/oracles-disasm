; ==================================================================================================
; PART_LIGHTABLE_TORCH
; ==================================================================================================
partCode06:
	jr z,@normalStatus

	; Just hit
	ld h,d
	ld l,Part.subid
	ld a,(hl)
	cp $02
	jr z,@normalStatus

	ld l,Part.counter2
	ldd a,(hl)
	ld (hl),a ; [counter1] = [counter2]
	ld l,Part.state
	ld (hl),$02

@normalStatus:
	ld e,Part.subid
	ld a,(de)
	rst_jumpTable
	.dw @subid0
	.dw @subid1
	.dw @subid2


; Subid 0: Once the torch is lit, it stays lit.
@subid0:
	ld e,Part.state
	ld a,(de)
	rst_jumpTable
	.dw @gotoState1
	.dw @ret
	.dw @subid0State2

@gotoState1:
	ld a,$01
	ld (de),a

@ret:
	ret

@subid0State2:
	ld hl,wNumTorchesLit
	inc (hl)
	ld a,SND_LIGHTTORCH
	call playSound
	call objectGetShortPosition
	ld c,a

	ld a,(wActiveGroup)
	or a
	ld a,TILEINDEX_OVERWORLD_LIT_TORCH
	jr z,+
	ld a,TILEINDEX_LIT_TORCH
+
	call setTile
	jp partDelete


; Subid 1: Once lit, the torch stays lit for [counter2] frames.
@subid1:
	ld e,Part.state
	ld a,(de)
	rst_jumpTable
	.dw @gotoState1
	.dw @ret
	.dw @subid1State2
	.dw @subid1State3

@subid1State2:
	ld h,d
	ld l,e
	inc (hl) ; [state] = 3

	ld l,Part.collisionType
	res 7,(hl)

	; [counter1] = [counter2]
	ld l,Part.counter2
	ldd a,(hl)
	ld (hl),a

	ld hl,wNumTorchesLit
	inc (hl)
	ld a,SND_LIGHTTORCH
	call playSound

	call objectGetShortPosition
	ld c,a
	ld a,TILEINDEX_LIT_TORCH
	jr @setTile

@subid1State3:
	ld a,(wFrameCounter)
	and $03
	ret nz
	call partCommon_decCounter1IfNonzero
	ret nz

	ld l,Part.collisionType
	set 7,(hl)
	ld l,Part.state
	ld (hl),$01

	ld hl,wNumTorchesLit
	dec (hl)

	call objectGetShortPosition
	ld c,a
	ld a,TILEINDEX_UNLIT_TORCH
	jr @setTile


; Subid 2: ?
@subid2:
	ld e,Part.state
	ld a,(de)
	rst_jumpTable
	.dw @gotoState1
	.dw @subid2State1
	.dw @subid2State2
	.dw @subid2State3
	.dw @subid2State4

@subid2State1:
	call @getTileAtRelatedObjPosition
	cp TILEINDEX_LIT_TORCH
	ret z

	ld h,d
	ld l,Part.state
	inc (hl)
	ld l,Part.counter1
	ld (hl),$f0
	ret

@subid2State2:
	call partCommon_decCounter1IfNonzero
	jp nz,@gotoState1IfTileAtRelatedObjPositionIsNotLit

	; [state] = 3
	ld l,e
	inc (hl)

	ld hl,wNumTorchesLit
	dec (hl)
	call objectGetShortPosition
	ld c,a
	ld a,TILEINDEX_UNLIT_TORCH
@setTile:
	jp setTile

@subid2State3:
	call @getTileAtRelatedObjPosition
	cp TILEINDEX_UNLIT_TORCH
	ret z
	ld e,Part.state
	ld a,$04
	ld (de),a
	ret

@subid2State4:
	ld a,$01
	ld (de),a ; [state]
	ld hl,wNumTorchesLit
	inc (hl)
	call objectGetShortPosition
	ld c,a
	ld a,TILEINDEX_LIT_TORCH
	jr @setTile

;;
@getTileAtRelatedObjPosition:
	ld a,Object.yh
	call objectGetRelatedObject2Var
	ld b,(hl)
	ld l,Part.xh
	ld c,(hl)
	jp getTileAtPosition

@gotoState1IfTileAtRelatedObjPositionIsNotLit:
	call @getTileAtRelatedObjPosition
	cp TILEINDEX_LIT_TORCH
	ret nz
	ld e,Part.state
	ld a,$01
	ld (de),a
	ret
