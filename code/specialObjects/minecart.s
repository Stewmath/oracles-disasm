;;
; Update a minecart object.
; (Called from bank5._specialObjectCode_minecart)
; @addr{563e}
specialObjectCode_minecart:
	call _minecartCreateCollisionItem		; $563e
	ld e,SpecialObject.state		; $5641
	ld a,(de)		; $5643
	rst_jumpTable			; $5644

	.dw @state0
	.dw @state1

@state0:
	; Set state to $01
	ld a,$01		; $5649
	ld (de),a		; $564b

	; Setup palette, etc
	callab bank5.specialObjectSetOamVariables		; $564c

	ld h,d			; $5654
	ld l,SpecialObject.speed		; $5655
	ld (hl),SPEED_100		; $5657

	ld l,SpecialObject.direction		; $5659
	ld a,(hl)		; $565b
	call specialObjectSetAnimation		; $565c

	ld a,d			; $565f
	ld (wLinkObjectIndex),a		; $5660
	call setCameraFocusedObjectToLink		; $5663

	; Resets link's animation if he's using an item, maybe?
	call clearVar3fForParentItems		; $5666

	call clearPegasusSeedCounter		; $5669

	ld hl,w1Link.z		; $566c
	xor a			; $566f
	ldi (hl),a		; $5670
	ldi (hl),a		; $5671

	jp objectSetVisiblec2		; $5672

@state1:
	ld a,(wPaletteThread_mode)		; $5675
	or a			; $5678
	ret nz			; $5679

	call retIfTextIsActive		; $567a

	ld a,(wScrollMode)		; $567d
	and $0e			; $5680
	ret nz			; $5682

	ld a,(wDisabledObjects)		; $5683
	and $81			; $5686
	ret nz			; $5688

	; Disable link's collisions?
	ld hl,w1Link.collisionType		; $5689
	res 7,(hl)		; $568c

	xor a			; $568e
	ld l,<w1Link.knockbackCounter		; $568f
	ldi (hl),a		; $5691

	; Check if on the center of the tile (y)
	ld h,d			; $5692
	ld l,SpecialObject.yh		; $5693
	ldi a,(hl)		; $5695
	ld b,a			; $5696
	and $0f			; $5697
	cp $08			; $5699
	jr nz,++		; $569b

	; Check if on the center of the tile (x)
	inc l			; $569d
	ldi a,(hl)		; $569e
	ld c,a			; $569f
	and $0f			; $56a0
	cp $08			; $56a2
	jr nz,++		; $56a4

	; Minecart is centered on the tile

	call _minecartCheckCollisions		; $56a6
	jr c,@minecartStopped	; $56a9

	; Compare direction to angle, ensure they're synchronized
	ld h,d			; $56ab
	ld l,SpecialObject.direction		; $56ac
	ldi a,(hl)		; $56ae
	swap a			; $56af
	rrca			; $56b1
	cp (hl)			; $56b2
	jr z,++			; $56b3

	ldd (hl),a		; $56b5
	ld a,(hl)		; $56b6
	call specialObjectSetAnimation		; $56b7

++
	ld h,d			; $56ba
	ld l,SpecialObject.var35		; $56bb
	dec (hl)		; $56bd
	bit 7,(hl)		; $56be
	jr z,+			; $56c0

	ld (hl),$1a		; $56c2
	ld a,SND_MINECART		; $56c4
	call playSound		; $56c6
+
	call objectApplySpeed		; $56c9
	jp specialObjectAnimate		; $56cc

@minecartStopped:
	; Go to state $02.
	; State $02 doesn't exist, so, good thing this is getting deleted anyway.
	ld e,SpecialObject.state		; $56cf
	ld a,$02		; $56d1
	ld (de),a		; $56d3

	call clearVar3fForParentItems		; $56d4

	; Force link to jump, lock his direction?
	ld a,$81		; $56d7
	ld (wLinkInAir),a		; $56d9

	; Copy / initialize various link variables

	ld hl,w1Link.angle		; $56dc
	ld e,SpecialObject.angle		; $56df
	ld a,(de)		; $56e1
	ld (hl),a		; $56e2

	ld l,<w1Link.yh		; $56e3
	ld a,(hl)		; $56e5
	add $06			; $56e6
	ld (hl),a		; $56e8

	ld l,<w1Link.zh		; $56e9
	ld (hl),$fa		; $56eb

	ld l,<w1Link.speed		; $56ed
	ld (hl),SPEED_80		; $56ef

	ld l,<w1Link.speedZ		; $56f1
	ld (hl),$40		; $56f3
	inc l			; $56f5
	ld (hl),$fe		; $56f6

	; Re-enable terrain effects (shadow)
	ld l,<w1Link.visible		; $56f8
	set 6,(hl)		; $56fa

	; Change main object back to w1Link ($d000) instead of this object ($d100)
	ld a,>w1Link		; $56fc
	ld (wLinkObjectIndex),a		; $56fe
	call setCameraFocusedObjectToLink		; $5701

	; Create the "interaction" minecart to replace the "special object" minecart
	ld b,INTERACID_MINECART		; $5704
	call objectCreateInteractionWithSubid00		; $5706
	jp objectDelete_useActiveObjectType		; $5709

;;
; Check for collisions, check the track for changing direction.
; @param[out] cflag Set if the minecart should stop (reached a platform)
; @addr{570c}
_minecartCheckCollisions:
	; Get minecart position in c, tile it's on in e
	call getTileAtPosition		; $570c
	ld e,a			; $570f
	ld c,l			; $5710

	; Try to find the relevant data in @trackData based on the tile the minecart is
	; currently on.
	ld h,d			; $5711
	ld l,SpecialObject.direction		; $5712
	ld a,(hl)		; $5714
	swap a			; $5715
	ld hl,@trackData		; $5717
	rst_addAToHl			; $571a
--
	ldi a,(hl)		; $571b
	or a			; $571c
	jr z,@noTrackFound		; $571d

	cp e			; $571f
	jr z,++			; $5720

	ld a,$04		; $5722
	rst_addAToHl			; $5724
	jr --		; $5725

	; Found a matching tile in @trackData
++
	; Add value to c to get the position of the next tile the minecart will move to.
	ldi a,(hl)		; $5727
	add c			; $5728
	ld c,a			; $5729
	ldh (<hFF8B),a	; $572a

	; Check for the edge of the room
	ld b,>wRoomCollisions		; $572c
	ld a,(bc)		; $572e
	cp $ff			; $572f
	ret z			; $5731

	; Check for a platform to disembark at
	ld b,>wRoomLayout		; $5732
	ld a,(bc)		; $5734
	cp TILEINDEX_MINECART_PLATFORM			; $5735
	jr z,@stopMinecart	; $5737

	; c will now store the value of the next tile.
	ld c,a			; $5739

	; Check the next 3 bytes of @trackData to see if the next track tile is acceptable
	ld b,$03		; $573a
--
	ldi a,(hl)		; $573c
	cp c			; $573d
	jr z,@updateDirection	; $573e
	dec b			; $5740
	jr nz,--		; $5741
	jr @noTrackFound		; $5743

@stopMinecart:
	; Set carry flag to give the signal that the ride is over.
	scf			; $5745
	ret			; $5746

@updateDirection:
	ld a,e			; $5747
	sub TILEINDEX_TRACK_TL		; $5748
	cp TILEINDEX_MINECART_PLATFORM - TILEINDEX_TRACK_TL	; $574a
	jr c,++			; $574c

@noTrackFound:
	; Index $06 will jump to @notTrack.
	ld a,$06		; $574e
++
	ld e,SpecialObject.direction		; $5750
	rst_jumpTable			; $5752
.dw @trackTL
.dw @trackBR
.dw @trackBL
.dw @trackTR
.dw @trackHorizontal
.dw @trackVertical
.dw @notTrack

@trackTL:
@trackBR:
	ld a,(de)		; $5761
	xor $01			; $5762
	ld (de),a		; $5764
	ret			; $5765

@trackBL:
@trackTR:
	ld a,(de)		; $5766
	xor $03			; $5767
	ld (de),a		; $5769
	ret			; $576a

@trackHorizontal:
	ld a,(de)		; $576b
	and $02			; $576c
	or $01			; $576e
	ld (de),a		; $5770
	ret			; $5771

@trackVertical:
	ld a,(de)		; $5772
	and $02			; $5773
	ld (de),a		; $5775
	ret			; $5776

@notTrack:
	call @checkMinecartDoor		; $5777
	jr nc,+			; $577a

	; Next tile is a minecart door, keep going
	xor a			; $577c
	ret			; $577d
+
	; Reverse direction
	ld a,(de)		; $577e
	xor $02			; $577f
	ld (de),a		; $5781
	ret			; $5782

; b0: Tile to check for ($00 to end list)
; b1: Value to add to position (where the next tile is)
; b2-b4: Other tiles that are allowed to link to the current tile
; @addr{5783}
@trackData:
	; DIR_UP
	.db TILEINDEX_TRACK_VERTICAL $f0 TILEINDEX_TRACK_VERTICAL   TILEINDEX_TRACK_TL TILEINDEX_TRACK_TR
	.db TILEINDEX_TRACK_TL       $01 TILEINDEX_TRACK_HORIZONTAL TILEINDEX_TRACK_BR TILEINDEX_TRACK_TR
	.db TILEINDEX_TRACK_TR       $ff TILEINDEX_TRACK_HORIZONTAL TILEINDEX_TRACK_BL TILEINDEX_TRACK_TL
	.db $00

	; DIR_RIGHT
	.db TILEINDEX_TRACK_HORIZONTAL $01 TILEINDEX_TRACK_HORIZONTAL TILEINDEX_TRACK_BR TILEINDEX_TRACK_TR
	.db TILEINDEX_TRACK_BR         $f0 TILEINDEX_TRACK_VERTICAL   TILEINDEX_TRACK_TL TILEINDEX_TRACK_TR
	.db TILEINDEX_TRACK_TR         $10 TILEINDEX_TRACK_VERTICAL   TILEINDEX_TRACK_BL TILEINDEX_TRACK_BR
	.db $00

	; DIR_DOWN
	.db TILEINDEX_TRACK_VERTICAL $10 TILEINDEX_TRACK_VERTICAL   TILEINDEX_TRACK_BR TILEINDEX_TRACK_BL
	.db TILEINDEX_TRACK_BR       $ff TILEINDEX_TRACK_HORIZONTAL TILEINDEX_TRACK_BL TILEINDEX_TRACK_TL
	.db TILEINDEX_TRACK_BL       $01 TILEINDEX_TRACK_HORIZONTAL TILEINDEX_TRACK_BR TILEINDEX_TRACK_TR
	.db $00

	; DIR_LEFT
	.db TILEINDEX_TRACK_HORIZONTAL $ff TILEINDEX_TRACK_HORIZONTAL TILEINDEX_TRACK_BL TILEINDEX_TRACK_TL
	.db TILEINDEX_TRACK_BL         $f0 TILEINDEX_TRACK_VERTICAL   TILEINDEX_TRACK_TR TILEINDEX_TRACK_TL
	.db TILEINDEX_TRACK_TL         $10 TILEINDEX_TRACK_VERTICAL   TILEINDEX_TRACK_BR TILEINDEX_TRACK_BL
	.db $00

;;
; @param	c	Next tile
; @param[out]	cflag	Set if the next tile is a minecart door that will open
; @addr{57c3}
@checkMinecartDoor:
	; Check if the next tile is a minecart door
	ld a,c			; $57c3
	sub TILEINDEX_MINECART_DOOR_UP			; $57c4
	cp $04			; $57c6
	ret nc			; $57c8

	; Calculate the angle for the interaction to be created (?)
	add $0c			; $57c9
	add a			; $57cb
	ld b,a			; $57cc

	call getFreeInteractionSlot		; $57cd
	ret nz			; $57d0

	ld (hl),INTERACID_DOOR_CONTROLLER		; $57d1

	ld l,Interaction.angle		; $57d3
	ld (hl),b		; $57d5

	; Set position (this interaction stuffs both X and Y in the yh variable)
	ld l,Interaction.yh		; $57d6
	ldh a,(<hFF8B)	; $57d8
	ld (hl),a		; $57da

	scf			; $57db
	ret			; $57dc

;;
; Creates an invisible item object which stays with the minecart to give it collision with enemies
; @addr{57dd}
_minecartCreateCollisionItem:
	; Check if the "item" has been created already
	ld e,SpecialObject.var36		; $57dd
	ld a,(de)		; $57df
	or a			; $57e0
	ret nz			; $57e1

	call getFreeItemSlot		; $57e2
	ret nz			; $57e5

	; Mark it as created
	ld e,SpecialObject.var36		; $57e6
	ld a,$01		; $57e8
	ld (de),a		; $57ea

	; Set Item.enabled
	ldi (hl),a		; $57eb

	; Set Item.id
	ld (hl),ITEMID_MINECART_COLLISION		; $57ec
	ret			; $57ee
