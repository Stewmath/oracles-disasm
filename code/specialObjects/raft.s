;;
; @addr{57ef}
specialObjectCode_raft:
.ifdef ROM_AGES
	ld a,d			; $57ef
	ld (wLinkRidingObject),a		; $57f0
	ld e,Item.state		; $57f3
	ld a,(de)		; $57f5
	rst_jumpTable			; $57f6
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3

@state0:
	callab bank5.specialObjectSetOamVariables		; $57ff
	xor a			; $5807
	call specialObjectSetAnimation		; $5808
	call itemIncState		; $580b

	ld l,SpecialObject.collisionType		; $580e
	ld a,$80|ITEMCOLLISION_LINK		; $5810
	ldi (hl),a		; $5812

	; collisionRadiusY/X
	inc l			; $5813
	ld a,$06		; $5814
	ldi (hl),a		; $5816
	ldi (hl),a		; $5817

	ld l,SpecialObject.counter1		; $5818
	ld (hl),$0c		; $581a

	ld a,d			; $581c
	ld (wLinkObjectIndex),a		; $581d
	call setCameraFocusedObjectToLink		; $5820
	jp @saveRaftPosition		; $5823


; State 1: riding the raft
@state1:
	ld a,(wPaletteThread_mode)		; $5826
	or a			; $5829
	ret nz			; $582a
	call retIfTextIsActive		; $582b
	ld a,(wScrollMode)		; $582e
	and $0e			; $5831
	ret nz			; $5833
	ld a,(wDisabledObjects)		; $5834
	and $81			; $5837
	ret nz			; $5839

	ld a,(wLinkForceState)		; $583a
	cp LINK_STATE_RESPAWNING			; $583d
	jr z,@respawning			; $583f
	ld a,(w1Link.state)		; $5841
	cp LINK_STATE_RESPAWNING			; $5844
	jr nz,++		; $5846

@respawning:
	ld hl,wLinkLocalRespawnY		; $5848
	ld e,SpecialObject.yh		; $584b
	ldi a,(hl)		; $584d
	ld (de),a		; $584e
	ld e,SpecialObject.xh		; $584f
	ldi a,(hl)		; $5851
	ld (de),a		; $5852
	jp objectSetInvisible		; $5853

++
	; Update direction; if changed, re-initialize animation
	call updateCompanionDirectionFromAngle		; $5856
	jr c,+			; $5859
	call specialObjectAnimate		; $585b
	jr ++			; $585e
+
	call specialObjectSetAnimation		; $5860
++
	call @raftCalculateAdjacentWallsBitset		; $5863
	call @transferKnockbackToLink		; $5866
	ld hl,w1Link.knockbackCounter		; $5869
	ld a,(hl)		; $586c
	or a			; $586d
	jr z,@updateMovement	; $586e

	; Experiencing knockback; decrement counter, apply knockback speed
	dec (hl)		; $5870
	dec l			; $5871
	ld c,(hl)		; $5872
	ld b,SPEED_100		; $5873
	callab bank5.specialObjectUpdatePositionGivenVelocity		; $5875

	ld a,$88		; $587d
	ld (wcc92),a		; $587f
	jr @notDismounting		; $5882

@updateMovement:
	ld e,SpecialObject.speed		; $5884
	ld a,SPEED_e0		; $5886
	ld (de),a		; $5888

	ld e,SpecialObject.angle		; $5889
	ld a,(wLinkAngle)		; $588b
	ld (de),a		; $588e
	bit 7,a			; $588f
	jr nz,@notDismounting	; $5891
	ld a,(wLinkImmobilized)		; $5893
	or a			; $5896
	jr nz,@notDismounting	; $5897

	callab bank5.specialObjectUpdatePosition	; $5899
	ld a,c			; $58a1
	or a			; $58a2
	jr z,@positionUnchanged	; $58a3

	ld a,$08		; $58a5
	ld (wcc92),a		; $58a7


	; If not dismounting this frame, reset 'dismounting angle' (var3e) and
	; 'dismounting counter' (var3f).
@notDismounting:
	ld h,d			; $58aa
	ld l,SpecialObject.var3e		; $58ab
	ld a,$ff		; $58ad
	ldi (hl),a		; $58af

	; [var3f] = $04
	ld (hl),$04		; $58b0
	ret			; $58b2


	; If position is unchanged, check whether to dismount
@positionUnchanged:
	; Return if "dismount angle" changed from before
	ld h,d			; $58b3
	ld e,SpecialObject.angle		; $58b4
	ld a,(de)		; $58b6
	ld l,SpecialObject.var3e		; $58b7
	cp (hl)			; $58b9
	ldi (hl),a		; $58ba
	ret nz			; $58bb

	; [var3f]--
	dec (hl)		; $58bc
	ret nz			; $58bd

	; Get angle from var3e
	dec e			; $58be
	ld a,(de)		; $58bf
	ld hl,@dismountTileOffsets		; $58c0
	rst_addDoubleIndex			; $58c3

	; Get Y/X offset from this object in 'bc'
	ldi a,(hl)		; $58c4
	ld c,(hl)		; $58c5
	ld h,d			; $58c6
	ld l,SpecialObject.yh		; $58c7
	add (hl)		; $58c9
	ld b,a			; $58ca
	ld l,SpecialObject.xh		; $58cb
	ld a,(hl)		; $58cd
	add c			; $58ce
	ld c,a			; $58cf

	; If Link can walk on the adjacent tile, check whether to dismount
	call getTileAtPosition		; $58d0
	ld h,>wRoomCollisions		; $58d3
	ld a,(hl)		; $58d5
	or a			; $58d6
	jr z,@checkDismount	; $58d7
	cp SPECIALCOLLISION_STAIRS			; $58d9
	jr nz,@notDismounting	; $58db

@checkDismount:
	callab bank5.calculateAdjacentWallsBitset		; $58dd
	ldh a,(<hFF8B)	; $58e5
	or a			; $58e7
	jr nz,@notDismounting	; $58e8

	; Disable menu, force Link to walk for 14 frames
	inc a			; $58ea
	ld (wMenuDisabled),a		; $58eb
	ld a,LINK_STATE_FORCE_MOVEMENT		; $58ee
	ld (wLinkForceState),a		; $58f0
	ld a,14		; $58f3
	ld (wLinkStateParameter),a		; $58f5

	; Update angle; copy direction + angle to Link
	call itemUpdateAngle		; $58f8
	ld e,l			; $58fb
	ld h,>w1Link		; $58fc
	ld a,(de)		; $58fe
	ldi (hl),a		; $58ff
	inc e			; $5900
	ld a,(de)		; $5901
	ldi (hl),a		; $5902

	; Link is no longer riding the raft, set object index to $d0
	ld a,h			; $5903
	ld (wLinkObjectIndex),a		; $5904

	call setCameraFocusedObjectToLink		; $5907
	call itemIncState		; $590a
	jr @saveRaftPosition		; $590d


; These are offsets from the raft's position at which to check whether the tile there can
; be dismounted onto. (the only requirement is that it's non-solid.)
@dismountTileOffsets:
	.db $f7 $00 ; DIR_UP
	.db $fd $08 ; DIR_RIGHT
	.db $08 $00 ; DIR_DOWN
	.db $fd $f7 ; DIR_LEFT


; State 2: started dismounting
@state2:
	ld a,$80		; $5917
	ld (wcc92),a		; $5919
	call itemDecCounter1		; $591c
	ret nz			; $591f

	xor a			; $5920
	ld (wMenuDisabled),a		; $5921
	ld e,SpecialObject.enabled		; $5924
	inc a			; $5926
	ld (de),a		; $5927
	call updateLinkLocalRespawnPosition		; $5928
	call itemIncState		; $592b


; State 3: replace self with raft interaction
@state3:
	ldbc INTERACID_RAFT, $02		; $592e
	call objectCreateInteraction		; $5931
	ret nz			; $5934
	ld e,SpecialObject.direction		; $5935
	ld a,(de)		; $5937
	ld l,Interaction.direction		; $5938
	ld (hl),a		; $593a
	jp itemDelete		; $593b

;;
; @addr{593e}
@saveRaftPosition:
	ld bc,wLastAnimalMountPointY		; $593e
	ld h,d			; $5941
	ld l,SpecialObject.yh		; $5942
	ldi a,(hl)		; $5944
	ld (bc),a		; $5945
	inc c			; $5946
	inc l			; $5947
	ld a,(hl)		; $5948
	ld (bc),a		; $5949
	jpab bank5.saveLinkLocalRespawnAndCompanionPosition		; $594a

;;
; Calculates the "adjacent walls bitset" for the raft specifically, treating everything as
; solid except for water tiles.
;
; @addr{5952}
@raftCalculateAdjacentWallsBitset:
	ld a,$01		; $5952
	ldh (<hFF8B),a	; $5954
	ld hl,@@wallPositionOffsets		; $5956
--
	ldi a,(hl)		; $5959
	ld b,a			; $595a
	ldi a,(hl)		; $595b
	ld c,a			; $595c
	push hl			; $595d
	call objectGetRelativeTile		; $595e
	or a			; $5961
	jr z,+			; $5962
	ld e,a			; $5964
	ld hl,@@validTiles		; $5965
	call findByteAtHl		; $5968
	ccf			; $596b
+
	pop hl			; $596c
	ldh a,(<hFF8B)	; $596d
	rla			; $596f
	ldh (<hFF8B),a	; $5970
	jr nc,--		; $5972

	ld e,SpecialObject.adjacentWallsBitset		; $5974
	ld (de),a		; $5976
	ret			; $5977

; Offsets at which to check for solid walls (8 positions to check)
@@wallPositionOffsets:
	.db $fa $fb
	.db $fa $04
	.db $05 $fb
	.db $05 $04
	.db $fb $fa
	.db $04 $fa
	.db $fb $05
	.db $04 $05


; A list of tiles that the raft may cross.
@@validTiles:
	.db TILEINDEX_DEEP_WATER
	.db TILEINDEX_CURRENT_UP
	.db TILEINDEX_CURRENT_DOWN
	.db TILEINDEX_CURRENT_LEFT
	.db TILEINDEX_CURRENT_RIGHT
	.db TILEINDEX_WATER
	.db TILEINDEX_WHIRLPOOL
	.db $00


;;
; @addr{5990}
@transferKnockbackToLink:
	; Check Link's invincibilityCounter and var2a
	ld hl,w1Link.invincibilityCounter		; $5990
	ldd a,(hl)		; $5993
	or (hl)			; $5994
	jr nz,@@end		; $5995

	; Ret if raft's var2a is zero
	ld e,l			; $5997
	ld a,(de)		; $5998
	or a			; $5999
	ret z			; $599a

	; Transfer raft's var2a, invincibilityCounter, knockbackCounter, knockbackAngle,
	; and damageToApply to Link.
	ldi (hl),a		; $599b
	inc e			; $599c
	ld a,(de)		; $599d
	ldi (hl),a		; $599e
	inc e			; $599f
	ld a,(de)		; $59a0
	ldi (hl),a		; $59a1
	inc e			; $59a2
	ld a,(de)		; $59a3
	ldi (hl),a		; $59a4
	ld e,SpecialObject.damageToApply		; $59a5
	ld a,(de)		; $59a7
	ld l,e			; $59a8
	ld (hl),a		; $59a9

@@end:
	; Clear raft's invincibilityCounter and var2a
	ld e,SpecialObject.var2a		; $59aa
	xor a			; $59ac
	ld (de),a		; $59ad
	inc e			; $59ae
	ld (de),a		; $59af
	ret			; $59b0
.endif
