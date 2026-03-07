; Unlike "itemCodeXX", "itemCodeXXPost" functions run after all other objects have updated and
; aren't subject to certain conditions that would otherwise disable updating of items.
;
; This file starts with some helper functions but see below for the "itemCodeXXPost" functions.


;;
; Used for sword, cane of somaria, rod of seasons. Updates animation, deals with
; destroying tiles?
;
updateSwingableItemAnimation:
	ld l,Item.animParameter
.ifdef ROM_AGES
	cp ITEM_CANE_OF_SOMARIA
.else
	cp ITEM_ROD_OF_SEASONS
.endif
	jr z,label_07_227
	bit 6,(hl)
	jr z,label_07_227

	res 6,(hl)
	ld a,(hl)
	and $1f
	cp $10
	jr nc,+
	ld a,(w1Link.direction)
	add a
+
	and $07
	push hl
	call tryBreakTileWithSword_calculateLevel
	pop hl

label_07_227:
	ld c,$10
	ld a,(hl)
	and $1f
	cp c
	jr nc,+

	srl a
	ld c,a
	ld a,(w1Link.direction)
	add a
	add a
	add c
	ld c,$00
+
	ld hl,@data
	rst_addAToHl
	ld a,(hl)
	and $f0
	swap a
	add c
	ld e,Item.var30
	ld (de),a

	ld a,(hl)
	and $07
	jp itemSetAnimation


; For each byte:
;  Bits 4-7: value for Item.var30?
;  Bits 0-2: Animation index?
@data:
	.db $02 $41 $80 $c0 $10 $51 $92 $d2
	.db $26 $65 $a4 $e4 $30 $77 $b6 $f6

	.db $00 $11 $22 $33 $44 $55 $66 $77

;;
; Analagous to updateSwingableItemAnimation, but specifically for biggoron's sword
;
updateBiggoronSwordAnimation:
	ld b,$00
	ld l,Item.animParameter
	bit 6,(hl)
	jr z,+
	res 6,(hl)
	inc b
+
	ld a,(hl)
	and $0e
	rrca
	ld c,a
	ld a,(w1Link.direction)
	cp $01
	jr nz,+
	ld a,c
	jr ++
+
	inc a
	add a
	sub c
++
	and $07
	bit 0,b
	jr z,++

	push af
	ld c,a
	ld a,BREAKABLETILESOURCE_SWORD_L2
	call tryBreakTileWithSword
	pop af
++
	ld e,Item.var30
	ld (de),a
	jp itemSetAnimation

;;
; ITEM_MAGNET_GLOVES
;
itemCode08Post:
	call cpRelatedObject1ID
	jp nz,itemDelete

	ld hl,w1Link.yh
	call objectTakePosition
	ld a,(wFrameCounter)
	rrca
	rrca
	ld a,(w1Link.direction)
	adc a
	ld e,Item.var30
	ld (de),a
	jp itemSetAnimation

;;
; ITEM_SLINGSHOT
;
itemCode13Post:
	call cpRelatedObject1ID
	jp nz,itemDelete

	ld hl,w1Link.yh
	call objectTakePosition
	ld a,(w1Link.direction)
	ld e,Item.var30
	ld (de),a
	jp itemSetAnimation

;;
; ITEM_FOOLS_ORE
;
itemCode1ePost:
	call cpRelatedObject1ID
	jp nz,itemDelete

	ld l,Item.animParameter
	ld a,(hl)
	and $06
	add a
	ld b,a
	ld a,(w1Link.direction)
	add b
	ld e,Item.var30
	ld (de),a
	ld hl,swordArcData
	jr itemSetPositionInSwordArc

;;
; ITEM_PUNCH
;
itemCode00Post:
itemCode02Post:
	ld a,(w1Link.direction)
	add $18
	ld hl,swordArcData
	jr itemSetPositionInSwordArc

;;
; ITEM_BIGGORON_SWORD
;
itemCode0cPost:
	call cpRelatedObject1ID
	jp nz,itemDelete

	call updateBiggoronSwordAnimation
	ld e,Item.var30
	ld a,(de)
	ld hl,biggoronSwordArcData
	call itemSetPositionInSwordArc
	jp itemCalculateSwordDamage

;;
; ITEM_CANE_OF_SOMARIA
; ITEM_SWORD
; ITEM_ROD_OF_SEASONS
;
itemCode04Post:
itemCode05Post:
itemCode07Post:
	call cpRelatedObject1ID
	jp nz,itemDelete

	call updateSwingableItemAnimation

	ld e,Item.var30
	ld a,(de)
	ld hl,swordArcData
	call itemSetPositionInSwordArc

	jp itemCalculateSwordDamage

;;
; @param	a	Index for table 'hl'
; @param	hl	Usually points to swordArcData
itemSetPositionInSwordArc:
	add a
	rst_addDoubleIndex

;;
; Copy Link's position (accounting for raised floors, with Z position 2 higher than Link)
;
; @param	hl	Pointer to data for collision radii and position offsets
itemInitializeFromLinkPosition:
	ld e,Item.collisionRadiusY
	ldi a,(hl)
	ld (de),a
	inc e
	ldi a,(hl)
	ld (de),a

	; Y
.ifdef ROM_AGES
	ld a,(wLinkRaisedFloorOffset)
	ld b,a
	ld a,(w1Link.yh)
	add b
.else
	ld a,(w1Link.yh)
.endif
	add (hl)
	ld e,Item.yh
	ld (de),a

	; X
	inc hl
	ld e,Item.xh
	ld a,(w1Link.xh)
	add (hl)
	ld (de),a

	; Z
	ld a,(w1Link.zh)
	ld e,Item.zh
	sub $02
	ld (de),a
	ret


; Each row probably corresponds to part of a sword's arc? (Also used by punches.)
; b0/b1: collisionRadiusY/X
; b2/b3: Y/X offsets relative to Link
swordArcData:
	.db $09 $06 $fe $10
	.db $06 $09 $f2 $00
	.db $09 $06 $00 $f1
	.db $06 $09 $f2 $00
	.db $07 $07 $f5 $0d
	.db $07 $07 $f5 $0d
	.db $07 $07 $11 $f3
	.db $07 $07 $f5 $f3
	.db $09 $06 $ef $fc
	.db $06 $09 $02 $13
	.db $09 $06 $15 $03
	.db $06 $09 $02 $ed
	.db $09 $06 $f6 $fc
	.db $04 $09 $02 $0c
	.db $09 $06 $10 $03
	.db $06 $09 $02 $f4
	.db $09 $09 $ef $fc
	.db $09 $09 $f2 $10
	.db $09 $09 $02 $13
	.db $09 $09 $12 $10
	.db $09 $09 $15 $03
	.db $09 $09 $11 $f3
	.db $09 $09 $02 $ed
	.db $09 $09 $f5 $f3
	.db $05 $05 $f4 $fd
	.db $05 $05 $00 $0c
	.db $05 $05 $0c $03
	.db $05 $05 $00 $f4

biggoronSwordArcData:
	.db $0b $0b $ef $fe
	.db $09 $0c $f2 $10
	.db $0b $0b $02 $13
	.db $0c $09 $12 $10
	.db $0b $0b $15 $01
	.db $09 $0c $11 $f3
	.db $0b $0b $02 $ed
	.db $0c $09 $f5 $f3
