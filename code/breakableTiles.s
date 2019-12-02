;;
; This is always called from the tryToBreakTile function in bank 0.
;
; @param	bc	Position of tile to try to break
; @param	ff8f	Type of breakage (digging, sword slashing). Set bit 7 if no tiles
;			should be modified, in that case this function will only check if
;			it can be broken.
; @param[out]	hFF8D	4th parameter from "_breakableTileModes"
; @param[out]	hFF8E	The interaction ID to create when the tile is destroyed
; @param[out]	hFF92	Former tile index
; @param[out]	hFF93	Tile position
; @param[out]	cflag	Set if the tile was broken (or can be broken).
;
; Internal variables:
;  ff8d-ff8e: values read from _breakableTileModes
;  ff90: Y
;  ff91: X
;
; @addr{4734}
tryToBreakTile_body:
	ld a,b			; $4734
	and $f0			; $4735
	or $08			; $4737
	ldh (<hFF90),a	; $4739
	ld a,c			; $473b
	and $f0			; $473c
	or $08			; $473e
	ldh (<hFF91),a	; $4740

	call getTileAtPosition		; $4742
	ldh (<hFF92),a	; $4745
	ld e,a			; $4747
	ld a,l			; $4748
	ldh (<hFF93),a	; $4749

	ld hl,_breakableTileCollisionTable	; $474b
	call lookupCollisionTable_paramE		; $474e
	ret nc			; $4751

	; hl = _breakableTileModes + a*5
	ld e,a			; $4752
	add a			; $4753
	ld hl,_breakableTileModes	; $4754
	rst_addDoubleIndex			; $4757
	ld a,e			; $4758
	rst_addAToHl			; $4759

	ldh a,(<hFF8F)	; $475a
	ld e,a			; $475c
	and $1f			; $475d
	call checkFlag		; $475f
	ret z			; $4762
	rl e			; $4763
	ret c			; $4765

	inc hl			; $4766
	inc hl			; $4767
	ldi a,(hl)		; $4768
	swap a			; $4769
	and $0f			; $476b
	ldh (<hFF8D),a	; $476d
	ldi a,(hl)		; $476f
	ldh (<hFF8E),a	; $4770
	push de			; $4772
	ld a,(hl)		; $4773
	or a			; $4774
	jr z,@doneSettingTile	; $4775

.ifdef ROM_AGES
	ldh a,(<hFF92)	; $4777
	cp TILEINDEX_SWITCH_DIAMOND	; $4779
	jr z,@useOriginalLayout	; $477b

	ld a,(wActiveCollisions)		; $477d
	cp $02			; $4780
	jr z,@activeCollisions1Or2	; $4782
	cp $01			; $4784
	jr nz,@useGivenValue	; $4786

.else; ROM_SEASONS
	ld a,(wActiveGroup)
	cp $03
	jr c,@useGivenValue
.endif

@activeCollisions1Or2:
	; Check value $10 (a kind of pot). What's the significance?
	ldh a,(<hFF92)	; $4788
	cp TILEINDEX_MOVING_POT			; $478a
	jr nz,@useGivenValue	; $478c

@useOriginalLayout:
	; Check the original layout of the room, set the tile to its original
	; value if it was non-solid
	ldh a,(<hFF93)	; $478e
	push hl			; $4790
	call getTileIndexFromRoomLayoutBuffer		; $4791
	pop hl			; $4794
	jr nc,@setTile		; $4795

@useGivenValue:
	ldh a,(<hFF93)	; $4797
	ld c,a			; $4799
	ld b,(hl)		; $479a
	call setTileInRoomLayoutBuffer		; $479b
	ld a,(hl)		; $479e

@setTile:
	call setTile		; $479f

@doneSettingTile:
	ldh a,(<hFF92)	; $47a2

.ifdef ROM_AGES
	cp TILEINDEX_SOMARIA_BLOCK	; $47a4
	jr z,@somariaBlock	; $47a6
.endif

	cp TILEINDEX_SIGN	; $47a8
	ld hl,wTotalSignsDestroyed	; $47aa
	call z,incHlRefWithCap		; $47ad

	ldh a,(<hFF8E)	; $47b0
	rlca			; $47b2
	ldh a,(<hFF92)	; $47b3
	call c,updateRoomFlagsForBrokenTile		; $47b5

	ldh a,(<hFF8E)	; $47b8
	bit 6,a			; $47ba
	ld a,SND_SOLVEPUZZLE		; $47bc
	call nz,playSound		; $47be

	ld hl,wccaa		; $47c1
	ldh a,(<hFF93)	; $47c4
	cp (hl)			; $47c6
	jr nz,+			; $47c7

	ld (hl),$ff		; $47c9
	jr ++			; $47cb
+
	ldh a,(<hFF8D)	; $47cd
	or a			; $47cf
	call nz,func_483d		; $47d0
++
	ldh a,(<hFF8F)	; $47d3
	or a			; $47d5
	jr z,@done		; $47d6
	cp $0c			; $47d8
	jr z,@done		; $47da
	cp $08			; $47dc
	jr z,@done		; $47de
	cp $12			; $47e0
	ldh a,(<hFF8E)	; $47e2
	call nz,_makeInteractionForBreakableTile		; $47e4
@done:
	pop de			; $47e7
	scf			; $47e8
	ret			; $47e9

.ifdef ROM_AGES
@somariaBlock:
	ld c,ITEMID_18		; $47ea
	call findItemWithID		; $47ec
	jr nz,@done		; $47ef

	call @deleteSomariaBlock		; $47f1
	call findItemWithID_startingAfterH		; $47f4
	jr nz,@done		; $47f7

	call @deleteSomariaBlock		; $47f9
	jr @done		; $47fc

;;
; @param	h	Somaria block to slate for deletion
; @addr{47fe}
@deleteSomariaBlock:
	ld l,Item.state		; $47fe
	ld a,(hl)		; $4800
	cp $03			; $4801
	ret nz			; $4803

	ld l,Item.var2f		; $4804
	set 5,(hl)		; $4806
	ret			; $4808
.endif ; ROM_AGES

;;
; Makes an interaction for a breakable tile at the item's location.
; The effect that will be made is based on the Item.var03 variable.
; @addr{4809}
itemMakeInteractionForBreakableTile:
	ld h,d			; $4809
	ld l,Item.yh		; $480a
	ldi a,(hl)		; $480c
	ldh (<hFF90),a	; $480d
	inc l			; $480f
	ldi a,(hl)		; $4810
	ldh (<hFF91),a	; $4811
	ld l,Item.var03		; $4813
	ld a,(hl)		; $4815
;;
; @addr{4816}
_makeInteractionForBreakableTile:
	and $1f			; $4816
	cp $1f			; $4818
	ret z			; $481a

	ld c,a			; $481b
	call getFreeInteractionSlot		; $481c
	ret nz			; $481f

	ld a,c			; $4820
	and $0f			; $4821
	ldi (hl),a		; $4823
	ld a,c			; $4824
	and $10			; $4825
	swap a			; $4827
	ldi (hl),a		; $4829
	ld a,(w1Link.direction)		; $482a
	ld l,Interaction.direction		; $482d
	ldi (hl),a		; $482f
	swap a			; $4830
	rrca			; $4832
	ldi (hl),a		; $4833
	inc l			; $4834
	ldh a,(<hFF90)	; $4835
	ldi (hl),a		; $4837
	inc l			; $4838
	ldh a,(<hFF91)	; $4839
	ldi (hl),a		; $483b
	ret			; $483c

;;
; @addr{483d}
func_483d:
	push hl			; $483d
	call func_16eb		; $483e
	jr z,@done		; $4841

	call getFreePartSlot		; $4843
	jr nz,@done		; $4846

	ld (hl),PARTID_ITEM_DROP	; $4848
	inc l			; $484a
	ld (hl),c		; $484b
	ld l,Part.yh		; $484c
	ldh a,(<hFF90)	; $484e
	ldi (hl),a		; $4850
	inc l			; $4851
	ldh a,(<hFF91)	; $4852
	ld (hl),a		; $4854
	ld a,(w1Link.direction)		; $4855
	swap a			; $4858
	rrca			; $485a
	ld l,Part.angle	; $485b
	ld (hl),a		; $485d
	ld l,Part.var03		; $485e
	ld a,c			; $4860
	cp $0f			; $4861
	jr nz,+			; $4863
	ld (hl),$02		; $4865
+
	ldh a,(<hFF8F)	; $4867
	cp $06			; $4869
	jr nz,@done		; $486b
	inc (hl)		; $486d
@done:
	pop hl			; $486e
	ret			; $486f
