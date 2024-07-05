; ==================================================================================================
; PART_SEA_EFFECTS
; When this object exists, it applies the effects of whirlpool and pollution tiles.
; It's a bit weird to put this functionality in an object...
; ==================================================================================================
partCode2e:
	ld e,Part.state
	ld a,(de)
	or a
	jr nz,@initialized

	inc a
	ld (de),a
	jp @setCounter1To20

@initialized:
	ld a,(w1Link.state)
	sub LINK_STATE_NORMAL
	ret nz

	ld (wDisableScreenTransitions),a
	call checkLinkCollisionsEnabled
	jr c,+

	; Check if diving underwater
	ld a,(wLinkSwimmingState)
	rlca
	ret nc
+
	ld a,(wLinkObjectIndex)
	ld h,a
	ld l,SpecialObject.start
	call objectTakePosition

	ld l,SpecialObject.id
	ld a,(hl)
	cp SPECIALOBJECT_RAFT
	ld a,$05
	jr nz,+
	add a
+
	ld h,d
	ld l,Part.counter2
	ld (hl),a

	; Get position in bc
	ld l,Part.yh
	ldi a,(hl)
	ld b,a
	inc l
	ld c,(hl)

	ld hl,hFF8B
	ld (hl),$06
--
	ld hl,hFF8B
	dec (hl)
	jr z,@applyCurrentsDirection

	ld h,d
	ld l,Part.counter2
	dec (hl)
	ld a,(hl)
	ld hl,@positionOffsets
	rst_addDoubleIndex
	ldi a,(hl)
	add b
	ld b,a
	ld a,(hl)
	add c
	ld c,a
	call getTileAtPosition
	ld e,a
	ld a,l
	ldh (<hFF8A),a
	ld hl,harmfulWaterTilesCollisionTable
	call lookupCollisionTable_paramE
	jr nc,--

	rst_jumpTable
	.dw @collision0
	.dw @collision1
	.dw @collision2

@applyCurrentsDirection:
	ld a,(wTilesetFlags)
	and TILESETFLAG_OUTDOORS
	jr z,@setCounter1To20
	call objectGetTileAtPosition
	ld hl,currentsCollisionTable
	call lookupCollisionTable
	jr nc,@setCounter1To20
	ld c,a
	ld b,$3c
	call updateLinkPositionGivenVelocity

@setCounter1To20:
	ld e,$c6
	ld a,$20
	ld (de),a
	ret

@collision0:
	ldh a,(<hFF8A)
	call convertShortToLongPosition
	ld e,$cb
	ld a,(de)
	ldh (<hFF8F),a
	ld e,$cd
	ld a,(de)
	ldh (<hFF8E),a
	call objectGetRelativeAngleWithTempVars
	xor $10
	ld b,a
	ld a,(wLinkObjectIndex)
	ld h,a
	ld l,$2b
	ldd a,(hl)
	or (hl)
	ret nz
	ld (hl),$01
	inc l
	ld (hl),$18
	inc l
	ld (hl),b
	inc l
	ld (hl),$0c
	ld l,$25
	ld (hl),$fe
	ld a,SND_DAMAGE_LINK
	jp playSound

@collision1:
	ld a,(wLinkObjectIndex)
	rrca
	jr c,@collision2
	ld a,(wLinkSwimmingState)
	or a
	ret z

@collision2:
	ldh a,(<hFF8A)
	call convertShortToLongPosition
	ld e,$cb
	ld a,(de)
	ldh (<hFF8F),a
	ld e,$cd
	ld a,(de)
	ldh (<hFF8E),a
	sub c
	inc a
	cp $03
	jr nc,@func_63d6
	ldh a,(<hFF8F)
	sub b
	inc a
	cp $03
	jr nc,@func_63d6
	ld a,(wLinkObjectIndex)
	ld h,a
	ld l,$0b
	ld (hl),b
	ld l,$0d
	ld (hl),c
	ld a,$02
	ld (wLinkForceState),a
	xor a
	ld (wLinkStateParameter),a
	jp clearAllParentItems

@func_63d6:
	ld a,$ff
	ld (wDisableScreenTransitions),a
	call objectGetRelativeAngleWithTempVars
	ld c,a
	call partCommon_decCounter1IfNonzero
	ld a,(hl)
	and $1c
	rrca
	rrca
	ld hl,@speedValues
	rst_addAToHl
	ld a,(hl)
	ld b,a
	cp $19
	jr c,+
	ld a,(wLinkObjectIndex)
	ld h,a
	ld l,Object.speed
	ld (hl),$00
+
	jp updateLinkPositionGivenVelocity

@positionOffsets:
	.db $00 $f7
	.db $0a $00
	.db $00 $09
	.db $fd $fb
	.db $00 $00
	.db $00 $f5
	.db $0b $00
	.db $00 $0b
	.db $fa $fa
	.db $00 $00

@speedValues:
	.db $3c $32 $28 $1e
	.db $19 $14 $0f $0a
	
.include {"{GAME_DATA_DIR}/tile_properties/seaEffectTiles2.s"}
