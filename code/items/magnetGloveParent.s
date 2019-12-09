; Variables:
;  var37: ?
_parentItemCode_magnetGloves:
.ifdef ROM_SEASONS
	ld a,(wLinkClimbingVine)		; $51cd
	inc a			; $51d0
	jr z,@deleteSelf	; $51d1
	ld e,Item.state		; $51d3
	ld a,(de)		; $51d5
	rst_jumpTable			; $51d6
	.dw @state0
	.dw @state1

@state0:
	ld a,(wLinkSwimmingState)		; $51db
	or a			; $51de
	jr nz,@deleteSelf	; $51df

	call itemIncState		; $51e1
	ld l,Item.var37		; $51e4
	ld (hl),$ff		; $51e6
	ld l,Item.relatedObj2		; $51e8
	xor a			; $51ea
	ldi (hl),a		; $51eb
	ld (hl),>w1WeaponItem		; $51ec
	call itemCreateChild		; $51ee
	call updateLinkDirectionFromAngle		; $51f1
	call setStatusBarNeedsRefreshBit1		; $51f4

@state1:
	ld a,(wLinkSwimmingState)		; $51f7
	or a			; $51fa
	jr nz,@invertPolarityAndStop	; $51fb
	ld a,(wLinkInAir)		; $51fd
	rlca			; $5200
	jr c,@invertPolarityAndStop	; $5201
	call _parentItemCheckButtonPressed		; $5203
	jr z,@invertPolarityAndStop	; $5206

	ld a,SND_MAGNET_GLOVES		; $5208
	call playSound		; $520a
	ld a,(wMagnetGlovePolarity)		; $520d
	scf			; $5210
	adc a			; $5211
	ld (wMagnetGloveState),a		; $5212
	call _itemDisableLinkTurning		; $5215
	call @checkLatchedOntoTile		; $5218
	ret z			; $521b

	; Link moves toward something
	call objectGetRelativeAngleWithTempVars		; $521c
	ld hl,wMagnetGloveState		; $521f
	set 6,(hl)		; $5222
	bit 1,(hl)		; $5224
	jr nz,+			; $5226
	xor $10			; $5228
+
	ld e,Item.angle		; $522a
	ld (de),a		; $522c
	ld c,a			; $522d
	ld a,$ff		; $522e
	ld (w1Link.angle),a		; $5230
	ld b,SPEED_180		; $5233
	jp updateLinkPositionGivenVelocity		; $5235

@invertPolarityAndStop:
	ld hl,wMagnetGlovePolarity		; $5238
	ld a,(hl)		; $523b
	xor $01			; $523c
	ld (hl),a		; $523e
	ld hl,wStatusBarNeedsRefresh		; $523f
	set 0,(hl)		; $5242

@deleteSelf:
	xor a			; $5244
	ld (wMagnetGloveState),a		; $5245
	jp _clearParentItem		; $5248

;;
; @param[out]	bc	Position of object locked on to
; @param[out]	zflag	nz if Link should move toward something
; @addr{524b}
@checkLatchedOntoTile:
	ld a,(wLinkObjectIndex)		; $524b
	xor $01			; $524e
	and $01			; $5250
	ret z			; $5252

	ld a,(wActiveGroup)		; $5253
	ld hl,@magnetTilesTable		; $5256
	rst_addAToHl			; $5259
	ld a,(hl)		; $525a
	or a			; $525b
	ret z			; $525c

	push de			; $525d
	ld d,a			; $525e
	ld a,(w1Link.direction)		; $525f
	ld e,a			; $5262
	add a			; $5263
	add a			; $5264
	add e			; $5265
	ld hl,@offsetsToCheck		; $5266
	rst_addAToHl			; $5269
	ldi a,(hl)		; $526a
	ld e,a			; $526b
	call @searchForTile		; $526c
	call z,@searchForTile		; $526f
	pop de			; $5272
	ret			; $5273

;;
; @param	d	Tile index to check for
; @param	e	Offset value (ie. $10 for down)
; @param	hl	Y and X offsets (2 bytes)
; @addr{5274}
@searchForTile:
	ld a,(w1Link.yh)		; $5274
	ldh (<hFF8F),a	; $5277
	add (hl)		; $5279
	ld b,a			; $527a
	inc hl			; $527b
	ld a,(w1Link.xh)		; $527c
	ldh (<hFF8E),a	; $527f
	add (hl)		; $5281
	ld c,a			; $5282

	; Get tile in front of Link
	inc hl			; $5283
	push hl			; $5284
	call getTileAtPosition		; $5285
	ld c,l			; $5288
	ld b,h			; $5289
	pop hl			; $528a

@checkNextTile:
	or a			; $528b
	jr z,@ret	; $528c
	cp d			; $528e
	jr z,@foundTile			; $528f
	ld a,c			; $5291
	add e			; $5292
	ld c,a			; $5293
	ld a,(bc)		; $5294
	jr @checkNextTile		; $5295

@foundTile:
	ld a,c			; $5297
	and $f0			; $5298
	or $08			; $529a
	ld b,a			; $529c
	ld a,c			; $529d
	swap a			; $529e
	and $f0			; $52a0
	or $08			; $52a2
	ld c,a			; $52a4
@ret:
	ret			; $52a5

; First byte is the direction to check for magnet tiles in.
; The next pairs of bytes are position offsets to check (it doesn't just check for a straight line
; from Link, rather it's more like a rectangle.)
@offsetsToCheck:
	.db $f0  $00 $fd  $00 $02 ; DIR_UP
	.db $01  $00 $00  $04 $00 ; DIR_RIGHT
	.db $10  $00 $fd  $00 $02 ; DIR_DOWN
	.db $ff  $00 $00  $04 $00 ; DIR_LEFT


; Tile indices for magnet tiles (per group)
@magnetTilesTable:
	.db $00 $e3 $00 $3f $3f $3f $3f $3f

.endif ; ROM_SEASONS
