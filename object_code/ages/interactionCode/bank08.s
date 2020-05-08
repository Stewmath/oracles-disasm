; ==============================================================================
; INTERACID_TOGGLE_FLOOR: red/yellow/blue floor tiles that change color when jumped over.
; ==============================================================================
interactionCode15:
	ld e,Interaction.subid		; $4868
	ld a,(de)		; $486a
	or a			; $486b
	jp nz,@subid01		; $486c


; Subid 0: this checks Link's position and spawns new instances of subid 1 when needed.
@subid00:
	call interactionDeleteAndRetIfEnabled02		; $486f
	call checkInteractionState		; $4872
	jr nz,@initialized	; $4875

	call interactionIncState		; $4877

@updateTilePos:
	ld e,Interaction.var30		; $487a
	ld a,(wActiveTilePos)		; $487c
	ld (de),a		; $487f
	ret			; $4880

@initialized:
	ld a,(wLinkInAir)		; $4881
	or a			; $4884
	jr z,@updateTilePos	; $4885

	; Check that link's position is within 4 pixels of the tile's center on both axes
	ld a,(w1Link.yh)		; $4887
	add $05			; $488a
	and $0f			; $488c
	sub $04			; $488e
	cp $09			; $4890
	ret nc			; $4892
	ld a,(w1Link.xh)		; $4893
	and $0f			; $4896
	sub $04			; $4898
	cp $09			; $489a
	ret nc			; $489c

	; Check that Link's tile position has changed
	ld e,Interaction.var30		; $489d
	ld a,(de)		; $489f
	ld c,a			; $48a0
	call getLinkTilePosition		; $48a1
	cp c			; $48a4
	ret z			; $48a5

	; Position has changed. Check that the new tile is one of the colored floor tiles.
	ld (de),a		; $48a6
	ld c,a			; $48a7
	ld b,>wRoomLayout		; $48a8
	ld a,(bc)		; $48aa
	sub TILEINDEX_RED_TOGGLE_FLOOR			; $48ab
	cp $03			; $48ad
	ret nc			; $48af

	; Spawn an instance of this object with subid 1.
	call getFreeInteractionSlot		; $48b0
	ret nz			; $48b3
	ld (hl),INTERACID_TOGGLE_FLOOR		; $48b4
	inc l			; $48b6
	ld (hl),$01 ; [subid] = $01
	inc l			; $48b9
	ld (hl),c   ; [var03] = position

	ld l,Interaction.var30		; $48bb
	ld a,(wActiveTilePos)		; $48bd
	ld (hl),a		; $48c0
	ret			; $48c1


; Subid 1: toggles tile at position [var03] when Link lands.
@subid01:
	ld a,(wLinkInAir)		; $48c2
	or a			; $48c5
	ret nz			; $48c6

	; Get position of tile in 'c'.
	ld e,Interaction.var03		; $48c7
	ld a,(de)		; $48c9
	ld c,a			; $48ca

	; var30 contains Link's position from before he jumped; if he's landed on the same
	; spot, don't toggle the block.
	ld e,Interaction.var30		; $48cb
	ld a,(de)		; $48cd
	ld b,a			; $48ce
	call getLinkTilePosition		; $48cf
	cp b			; $48d2
	jp z,interactionDelete		; $48d3

	ld b,>wRoomLayout		; $48d6
	ld a,(bc)		; $48d8
	inc a			; $48d9
	cp TILEINDEX_RED_TOGGLE_FLOOR+3			; $48da
	jr c,+			; $48dc
	ld a,TILEINDEX_RED_TOGGLE_FLOOR		; $48de
+
	ldh (<hFF92),a	; $48e0
	call setTile		; $48e2
	ldh a,(<hFF92)	; $48e5
	ld b,a			; $48e7
	call setTileInRoomLayoutBuffer		; $48e8

	ld a,SND_GETSEED		; $48eb
	call playSound		; $48ed

	jp interactionDelete		; $48f0

;;
; @param[out]	a,l	The position of the tile Link's standing on
; @addr{48f3}
getLinkTilePosition:
	push bc			; $48f3
	ld a,(w1Link.yh)		; $48f4
	add $05			; $48f7
	and $f0			; $48f9
	ld b,a			; $48fb
	ld a,(w1Link.xh)		; $48fc
	swap a			; $48ff
	and $0f			; $4901
	or b			; $4903
	ld l,a			; $4904
	pop bc			; $4905
	ret			; $4906


; ==============================================================================
; INTERACID_COLORED_CUBE
; ==============================================================================
interactionCode19:
	call objectReplaceWithAnimationIfOnHazard		; $4907
	ret c			; $490a
	ld e,Interaction.state		; $490b
	ld a,(de)		; $490d
	rst_jumpTable			; $490e
	.dw @state0
	.dw @state1
	.dw @state2


; State 0: initialization
@state0:
	ld h,d			; $4915
	ld l,e			; $4916
	inc (hl)		; $4917

	ld l,Interaction.counter1		; $4918
	ld (hl),$14 ; counter1: frames it takes to push it
	inc l			; $491c
	ld (hl),$0a ; counter2: frames it takes to fall into a hole

	ld a,$06		; $491f
	call objectSetCollideRadius		; $4921
	call interactionInitGraphics		; $4924

	ld e,Interaction.subid		; $4927
	ld a,(de)		; $4929
	ld e,Interaction.direction		; $492a
	ld (de),a		; $492c

	call @setColor		; $492d

	; Load palettes 6 and 7. Since it uses palette 6, you shouldn't be able to move
	; any blocks or hold anything while one of these blocks is on screen, since this
	; would interfere with the "objectMimicBgTile" function.
	ld a,PALH_89		; $4930
	call loadPaletteHeader		; $4932

	call @updatePosition		; $4935
	jp objectSetVisible82		; $4938


; State 1: waiting to be pushed
@state1:
	call interactionDecCounter2		; $493b
	jr nz,+			; $493e
	call objectGetTileAtPosition		; $4940
	cp TILEINDEX_CRACKED_FLOOR			; $4943
	jp z,@fallDownHole		; $4945
+
	call @checkLinkPushingTowardBlock		; $4948
	jr nz,@resetCounter1	; $494b
	call interactionDecCounter1		; $494d
	ret nz			; $4950

; Block has been pushed for 20 frames.

	ld a,b			; $4951
	swap a			; $4952
	rrca			; $4954
	ld e,Interaction.angle		; $4955
	ld (de),a		; $4957
	call interactionCheckAdjacentTileIsSolid		; $4958
	jr nz,@resetCounter1	; $495b

	; Set collisions to 0
	call objectGetShortPosition		; $495d
	ld h,>wRoomCollisions		; $4960
	ld l,a			; $4962
	ld (hl),$00		; $4963

	call interactionIncState		; $4965
	ld l,Interaction.direction		; $4968
	ldi a,(hl)		; $496a
	add a			; $496b
	add a			; $496c
	ld b,a			; $496d
	ld a,(hl)		; $496e
	swap a			; $496f
	rlca			; $4971
	add b			; $4972
	ld hl,@animations		; $4973
	rst_addAToHl			; $4976
	ld a,(hl)		; $4977
	call interactionSetAnimation		; $4978
	jr @checkAnimParameter		; $497b

@resetCounter1:
	ld e,Interaction.counter1		; $497d
	ld a,$14		; $497f
	ld (de),a		; $4981
	ret			; $4982


; State 2: being pushed
@state2:
	call interactionAnimate		; $4983

@checkAnimParameter:
	ld e,Interaction.animParameter		; $4986
	ld a,(de)		; $4988
	or a			; $4989
	ret z			; $498a
	ld b,a			; $498b
	rlca			; $498c
	jr c,@finishMovement	; $498d

	xor a			; $498f
	ld (de),a		; $4990
	ld a,b			; $4991
	sub $02			; $4992
	ld hl,@directionOffsets		; $4994
	rst_addAToHl			; $4997
	ld e,Interaction.yh		; $4998
	ld a,(de)		; $499a
	add (hl)		; $499b
	ld (de),a		; $499c
	inc hl			; $499d
	ld e,Interaction.xh		; $499e
	ld a,(de)		; $49a0
	add (hl)		; $49a1
	ld (de),a		; $49a2
	ret			; $49a3

@finishMovement:
	ld h,d			; $49a4
	ld l,Interaction.state		; $49a5
	dec (hl)		; $49a7
	ld l,Interaction.counter1		; $49a8
	ld (hl),$14		; $49aa
	inc l			; $49ac
	ld (hl),$0a		; $49ad
	ld a,b			; $49af
	and $7f			; $49b0
	ld e,Interaction.direction		; $49b2
	ld (de),a		; $49b4
	call @setColor		; $49b5
	call objectCenterOnTile		; $49b8

.ifdef ROM_AGES
	ld a,SND_MOVE_BLOCK_2		; $49bb
.else
	ld a,$7f
.endif
	call playSound		; $49bd

;;
; Updates wRotatingCubePos and wRoomCollisions based on the object's current position.
; @addr{49c0}
@updatePosition:
	call objectGetShortPosition		; $49c0
	ld h,>wRoomCollisions		; $49c3
	ld l,a			; $49c5
	ld (hl),$0f		; $49c6
	ld (wRotatingCubePos),a		; $49c8

	; Push Link away? (only called once since solidity is handled by modifying
	; wRoomCollisions)
	jp objectPreventLinkFromPassing		; $49cb


@directionOffsets:
	.db $fc $00
	.db $00 $04
	.db $04 $00
	.db $00 $fc

;;
; @param[out]	b	Direction it's being pushed in
; @param[out]	zflag	Set if Link is pushing toward the block
; @addr{49e5}
@checkLinkPushingTowardBlock:
	ld a,(wLinkGrabState)		; $49d6
	or a			; $49d9
	ret nz			; $49da
	ld a,(wLinkAngle)		; $49db
	rlca			; $49de
	ret c			; $49df
	ld a,(w1Link.zh)		; $49e0
	rlca			; $49e3
	ret c			; $49e4

	ld a,(wGameKeysPressed)		; $49e5
	and (BTN_A | BTN_B)			; $49e8
	ret nz			; $49ea
	ld c,$14		; $49eb
	call objectCheckLinkWithinDistance		; $49ed
	jr nc,++		; $49f0
	srl a			; $49f2
	xor $02			; $49f4
	ld b,a			; $49f6
	ld a,(w1Link.direction)		; $49f7
	cp b			; $49fa
	ret			; $49fb
++
	or d			; $49fc
	ret			; $49fd

; These are the animations values to use when the tile is being pushed.
; Each row corresponds to an orientation of the cube (value of Interaction.direction).
; Each column corresponds to the direction it's being pushed in (Interaction.angle).
@animations:
	.db $12 $07 $13 $06 ; 0: yellow/red
	.db $14 $11 $15 $10 ; 1: red/yellow
	.db $16 $0b $17 $0a ; 2: red/blue
	.db $18 $09 $19 $08 ; 3: blue/red
	.db $1a $0f $1b $0e ; 4: blue/yellow
	.db $1c $0d $1d $0c ; 5: yellow/blue


;;
; Sets wRotatingCubeColor as well as the animation to use.
;
; @param	a	Orientation of cube (value of Interaction.direction)
; @addr{4a16}
@setColor:
	ld b,a			; $4a16
	ld hl,@colors		; $4a17
	rst_addAToHl			; $4a1a
	ld a,(hl)		; $4a1b
	ld (wRotatingCubeColor),a		; $4a1c
	ld a,b			; $4a1f
	jp interactionSetAnimation		; $4a20

@colors:
	.db $01 $00 $00 $02 $02 $01


@fallDownHole:
	ld c,l			; $4a29
	ld a,TILEINDEX_HOLE		; $4a2a
	call setTile		; $4a2c
	call objectCreateFallingDownHoleInteraction		; $4a2f
	jp interactionDelete		; $4a32


; ==============================================================================
; INTERACID_COLORED_CUBE_FLAME
; ==============================================================================
interactionCode1a:
	call checkInteractionState		; $4a35
	jr nz,@initialized	; $4a38
	ld a,(wRotatingCubePos)		; $4a3a
	or a			; $4a3d
	ret z			; $4a3e

	call @updateColor		; $4a3f
	call interactionInitGraphics		; $4a42
	call objectSetVisible82		; $4a45
	call interactionIncState		; $4a48

@initialized:
	ld a,(wRotatingCubeColor)		; $4a4b
	rlca			; $4a4e
	jp nc,objectSetInvisible		; $4a4f
	call objectSetVisible		; $4a52
	call @updateColor		; $4a55
	jp interactionAnimate		; $4a58

@updateColor:
	ld a,(wRotatingCubeColor)		; $4a5b
	and $7f			; $4a5e
	ld hl,@palettes		; $4a60
	rst_addAToHl			; $4a63
	ld e,Interaction.oamFlags		; $4a64
	ld a,(de)		; $4a66
	and $f8			; $4a67
	or (hl)			; $4a69
	ld (de),a		; $4a6a
	ret			; $4a6b

@palettes:
	.db $02 $03 $01


; ==============================================================================
; INTERACID_MINECART_GATE
; ==============================================================================
interactionCode1b:
	ld e,Interaction.state		; $4a6f
	ld a,(de)		; $4a71
	rst_jumpTable			; $4a72
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3

@state0:
	ld a,$01		; $4a7b
	ld (de),a		; $4a7d

	; Move bits 4-7 of subid to bits 0-3 (direction of gate)
	ld e,Interaction.subid		; $4a7e
	ld a,(de)		; $4a80
	ld b,a			; $4a81
	swap a			; $4a82
	and $0f			; $4a84
	ld (de),a		; $4a86

	; Set var03 to a bitmask based on bits 0-2 of subid
	ld a,b			; $4a87
	and $07			; $4a88
	ld hl,bitTable		; $4a8a
	add l			; $4a8d
	ld l,a			; $4a8e
	inc e			; $4a8f
	ld a,(hl)		; $4a90
	ld (de),a		; $4a91

	call interactionInitGraphics		; $4a92
	call objectSetVisible82		; $4a95

	call @setAnimationAndUpdateCollisions		; $4a98
	ld e,Interaction.var30		; $4a9b
	ld a,(de)		; $4a9d
	ld b,a			; $4a9e
	and $01			; $4a9f
	inc a			; $4aa1
	ld e,Interaction.state		; $4aa2
	ld (de),a		; $4aa4
	ld a,b			; $4aa5
	xor $01			; $4aa6
	jp interactionSetAnimation		; $4aa8

;;
; Sets var30 to the animation to be done. Bit 0 set if the gate is open.
; Also modifies tile collisions appropriately.
; @addr{4aab}
@setAnimationAndUpdateCollisions:
	ld a,(wSwitchState)		; $4aab
	ld b,a			; $4aae
	ld e,Interaction.var03		; $4aaf
	ld a,(de)		; $4ab1
	and b			; $4ab2
	ld c,$00		; $4ab3
	jr nz,+			; $4ab5
	ld c,$01		; $4ab7
+
	dec e			; $4ab9
	ld a,(de) ; a = [subid] (subid is 0 if facing left, 2 if facing right)
	or c			; $4abb
	ld e,Interaction.var30		; $4abc
	ld (de),a		; $4abe

	call interactionSetAnimation		; $4abf

	call objectGetTileAtPosition		; $4ac2
	dec h ; h points to wRoomCollisions
	dec l			; $4ac6

	; a = [var30]*3
	ld e,Interaction.var30		; $4ac7
	ld a,(de)		; $4ac9
	ld b,a			; $4aca
	add a			; $4acb
	add b			; $4acc

	ld bc,@collisions		; $4acd
	call addAToBc		; $4ad0
	ld a,(bc)		; $4ad3
	ldi (hl),a		; $4ad4
	inc bc			; $4ad5
	ld a,(bc)		; $4ad6
	ld (hl),a		; $4ad7

	inc bc			; $4ad8
	ld a,(bc)		; $4ad9
	add l			; $4ada
	ld l,a			; $4adb
	inc h			; $4adc
	ld a,(de)		; $4add
	rrca			; $4ade
	jr c,+			; $4adf
	ld (hl),$5e		; $4ae1
	ret			; $4ae3
+
	ld (hl),$00		; $4ae4
	ret			; $4ae6

@collisions:
	.db $00 $0a  $ff ; Gate facing right
	.db $0c $0a  $ff
	.db $05 $00  $00 ; Gate facing left
	.db $05 $0c  $00


; State 1: waiting for switch to be pressed
@state1:
	call objectSetPriorityRelativeToLink		; $4af3
	ld a,(wSwitchState)		; $4af6
	cpl			; $4af9
	jr ++			; $4afa

; State 2: waiting for switch to be released
@state2:
	call objectSetPriorityRelativeToLink		; $4afc
	ld a,(wSwitchState)		; $4aff
++
	ld b,a			; $4b02
	ld e,Interaction.var03		; $4b03
	ld a,(de)		; $4b05
	and b			; $4b06
	ret z			; $4b07

	ld e,Interaction.state		; $4b08
	ld a,$03		; $4b0a
	ld (de),a		; $4b0c
.ifdef ROM_AGES
	ld a,SND_OPEN_GATE		; $4b0d
.else
	ld a,$7d
.endif
	call playSound		; $4b0f
	jp @setAnimationAndUpdateCollisions		; $4b12


; State 3: in the process of opening or closing
@state3:
	call interactionAnimate		; $4b15
	call objectSetPriorityRelativeToLink		; $4b18

	ld e,Interaction.animParameter		; $4b1b
	ld a,(de)		; $4b1d
	inc a			; $4b1e
	ret nz			; $4b1f

	ld e,Interaction.var30		; $4b20
	ld a,(de)		; $4b22
	and $01			; $4b23
	inc a			; $4b25
	ld e,Interaction.state		; $4b26
	ld (de),a		; $4b28
	ret			; $4b29


; ==============================================================================
; INTERACID_SPECIAL_WARP
; ==============================================================================
interactionCode1f:
	ld e,Interaction.subid		; $4b2a
	ld a,(de)		; $4b2c
	rst_jumpTable			; $4b2d
	.dw @subid0
	.dw @subid1
	.dw @subid2

; Subid 0: Trigger a warp when Link dives touching this object
@subid0:
	call checkInteractionState		; $4b34
	jr z,@@initialize	; $4b37

	; Check that Link has collided with this object, he's not holding anything, and
	; he's diving.
	ld a,(wLinkSwimmingState)		; $4b39
	rlca			; $4b3c
	ret nc			; $4b3d
	call objectCheckCollidedWithLink_notDeadAndNotGrabbing		; $4b3e
	ret nc			; $4b41

	ld e,Interaction.var03		; $4b42
	ld a,(de)		; $4b44
	ld hl,@@warpData		; $4b45
	rst_addDoubleIndex			; $4b48
	ldi a,(hl)		; $4b49
	ld (wWarpDestRoom),a		; $4b4a
	ld a,(hl)		; $4b4d
	ld (wWarpDestPos),a		; $4b4e
	ld a,$87		; $4b51
	ld (wWarpDestGroup),a		; $4b53
	ld a,$01		; $4b56
	ld (wWarpTransition),a		; $4b58
	ld a,$03		; $4b5b
	ld (wWarpTransition2),a		; $4b5d
	jp interactionDelete		; $4b60

@@warpData:
	.db $09 $01
	.db $05 $03

@@initialize:
	ld a,$01		; $4b67
	ld (de),a		; $4b69
	ld a,$02		; $4b6a
	call objectSetCollideRadius		; $4b6c

	ld l,Interaction.xh		; $4b6f
	ld a,(hl)		; $4b71
	ld l,Interaction.var03		; $4b72
	ld (hl),a		; $4b74

	ld l,Interaction.yh		; $4b75
	ld c,(hl)		; $4b77
	jp setShortPosition_paramC		; $4b78


; Subid 1: a warp at the top of a waterfall
@subid1:
	ld e,Interaction.state		; $4b7b
	ld a,(de)		; $4b7d
	rst_jumpTable			; $4b7e
	.dw @subid1State0
	.dw @subid1State1
	.dw @subid1State2

@subid1State0:
	ld a,(wAnimalCompanion)		; $4b85
	cp SPECIALOBJECTID_DIMITRI			; $4b88
	jp nz,interactionDelete		; $4b8a

	ld bc,$0810		; $4b8d
	call objectSetCollideRadii		; $4b90
	call objectCheckCollidedWithLink_notDeadAndNotGrabbing		; $4b93
	call nc,interactionIncState		; $4b96
	jp interactionIncState		; $4b99

@subid1State1:
	call objectCheckCollidedWithLink_notDeadAndNotGrabbing		; $4b9c
	ret c			; $4b9f
	jp interactionIncState		; $4ba0

@subid1State2:
	ld a,d			; $4ba3
	ld (wcc90),a		; $4ba4
	ld a,(wLinkObjectIndex)		; $4ba7
	cp >w1Companion			; $4baa
	ret nz			; $4bac
	call objectCheckCollidedWithLink_notDeadAndNotGrabbing		; $4bad
	ret nc			; $4bb0
	ld hl,@@warpDestVariables		; $4bb1
	jp setWarpDestVariables		; $4bb4

@@warpDestVariables:
	m_HardcodedWarpA ROOM_AGES_5b8, $00, $93, $03


; Subid 2: a warp in a cave in a waterfall
@subid2:
	ld a,d			; $4bbc
	ld (wDisableScreenTransitions),a		; $4bbd
	call checkInteractionState		; $4bc0
	jr z,@@initialize	; $4bc3

	call checkLinkCollisionsEnabled		; $4bc5
	ret nc			; $4bc8
	ld a,(wLinkObjectIndex)		; $4bc9
	bit 0,a			; $4bcc
	ret z			; $4bce

	ld h,a			; $4bcf
	ld l,<w1Companion.yh		; $4bd0
	ld a,(hl)		; $4bd2
	cp $a8			; $4bd3
	ret c			; $4bd5

	ld a,$ff		; $4bd6
	ld (wDisabledObjects),a		; $4bd8

	ld hl,@@warpDestVariables		; $4bdb
	call setWarpDestVariables		; $4bde
	jp interactionDelete		; $4be1

@@warpDestVariables:
	m_HardcodedWarpB ROOM_AGES_037, $0e, $22, $03

@@initialize:
	call interactionIncState		; $4be9
	jp interactionSetAlwaysUpdateBit		; $4bec


; ==============================================================================
; INTERACID_DUNGEON_SCRIPT
; ==============================================================================
interactionCode20:
	call interactionDeleteAndRetIfEnabled02		; $4bef
	ld e,Interaction.state		; $4bf2
	ld a,(de)		; $4bf4
	rst_jumpTable			; $4bf5
	.dw @state0
	.dw @state1
	.dw @state2

@state0:
	ld a,$01		; $4bfc
	ld (de),a		; $4bfe

	xor a			; $4bff
	ld ($cfc1),a		; $4c00
	ld ($cfc2),a		; $4c03

	ld a,(wDungeonIndex)		; $4c06
	cp $ff			; $4c09
	jp z,interactionDelete		; $4c0b

	ld hl,@scriptTable		; $4c0e
	rst_addDoubleIndex			; $4c11
	ldi a,(hl)		; $4c12
	ld h,(hl)		; $4c13
	ld l,a			; $4c14
	ld e,Interaction.subid		; $4c15
	ld a,(de)		; $4c17
	rst_addDoubleIndex			; $4c18
	ldi a,(hl)		; $4c19
	ld h,(hl)		; $4c1a
	ld l,a			; $4c1b
	call interactionSetScript		; $4c1c
	jp interactionRunScript		; $4c1f

@state2:
	call objectPreventLinkFromPassing		; $4c22

@state1:
	call interactionRunScript		; $4c25
	ret nc			; $4c28
	jp interactionDelete		; $4c29

; @addr{4c2c}
@scriptTable:
	.dw @dungeon0
	.dw @dungeon1
	.dw @dungeon2
	.dw @dungeon3
	.dw @dungeon4
	.dw @dungeon5
	.dw @dungeon6
	.dw @dungeon7
	.dw @dungeon8
	.dw @dungeon9
	.dw @dungeona
	.dw @dungeonb
	.dw @dungeonc
	.dw @dungeond

@dungeon0:
@dungeond:
	.dw makuPathScript_spawnChestWhenActiveTriggersEq01
	.dw makuPathScript_spawnDownStairsWhenEnemiesKilled
	.dw makuPathScript_spawn30Rupees
	.dw makuPathScript_keyFallsFromCeilingWhen1TorchLit
	.dw makuPathScript_spawnUpStairsWhen2TorchesLit
@dungeon1:
	.dw dungeonScript_spawnChestOnTriggerBit0
	.dw spiritsGraveScript_spawnBracelet
	.dw dungeonScript_minibossDeath
	.dw dungeonScript_bossDeath
	.dw spiritsGraveScript_stairsToBraceletRoom
	.dw spiritsGraveScript_spawnMovingPlatform
@dungeon2:
	.dw wingDungeonScript_spawnFeather
	.dw wingDungeonScript_spawn30Rupees
	.dw dungeonScript_minibossDeath
	.dw wingDungeonScript_bossDeath
@dungeon3:
	.dw dungeonScript_minibossDeath
	.dw dungeonScript_bossDeath
	.dw moonlitGrottoScript_spawnChestWhen2TorchesLit
@dungeon4:
	.dw dungeonScript_minibossDeath
	.dw dungeonScript_bossDeath
	.dw skullDungeonScript_spawnChestWhenOrb0Hit
	.dw skullDungeonScript_spawnChestWhenOrb1Hit
@dungeon5:
	.dw dungeonScript_minibossDeath
	.dw dungeonScript_bossDeath
	.dw crownDungeonScript_spawnChestWhen3TriggersActive
@dungeon6:
	.dw dungeonScript_minibossDeath
@dungeon7:
	.dw dungeonScript_bossDeath
@dungeon8:
	.dw dungeonScript_minibossDeath
	.dw dungeonScript_bossDeath
	.dw ancientTombScript_spawnSouthStairsWhenTrigger0Active
	.dw ancientTombScript_spawnNorthStairsWhenTrigger0Active
	.dw ancientTombScript_retractWallWhenTrigger0Active
	.dw ancientTombScript_spawnDownStairsWhenEnemiesKilled
	.dw ancientTombScript_spawnVerticalBridgeWhenTorchLit
@dungeon9:
@dungeona:
@dungeonb:
	.dw dungeonScript_spawnChestOnTriggerBit0
	.dw herosCaveScript_spawnChestWhen4TriggersActive
	.dw herosCaveScript_spawnBridgeWhenTriggerPressed
	.dw herosCaveScript_spawnNorthStairsWhenEnemiesKilled
@dungeonc:
	.dw dungeonScript_bossDeath
	.dw mermaidsCaveScript_spawnBridgeWhenOrbHit
	.dw mermaidsCaveScript_updateTrigger2BasedOnTriggers0And1


; ==============================================================================
; INTERACID_DUNGEON_EVENTS
; ==============================================================================
interactionCode21:
	ld e,Interaction.subid		; $4c9a
	ld a,(de)		; $4c9c
	rst_jumpTable			; $4c9d
	.dw interactionDelete
	.dw _interaction21_subid01
	.dw _interaction21_subid02
	.dw _interaction21_subid03
	.dw _interaction21_subid04
	.dw _interaction21_subid05
	.dw _interaction21_subid06
	.dw _interaction21_subid07
	.dw _interaction21_subid08
	.dw _interaction21_subid09
	.dw _interaction21_subid0a
	.dw _interaction21_subid0b
	.dw _interaction21_subid0c
	.dw _interaction21_subid0d
	.dw _interaction21_subid0e
	.dw _interaction21_subid0f
	.dw _interaction21_subid10
	.dw _interaction21_subid11
	.dw _interaction21_subid12
	.dw _interaction21_subid13
	.dw _interaction21_subid14
	.dw _interaction21_subid15
	.dw _interaction21_subid16
	.dw _interaction21_subid17
	.dw _interaction21_subid18
	.dw _interaction21_subid19


; D2: Verify a 2x2 floor pattern
_interaction21_subid01:
	call _interactionDeleteAndRetIfItemFlagSet		; $4cd2
	ld hl,_subid01_tileData		; $4cd5

_verifyTilesAndDropSmallKey:
	call _verifyTiles		; $4cd8
	ret nz			; $4cdb
	jp _spawnSmallKeyFromCeiling		; $4cdc

_subid01_tileData:
	.db TILEINDEX_YELLOW_TOGGLE_FLOOR  $67 $77 $ff ; Tiles at $67 and $77 must be red
	.db TILEINDEX_BLUE_TOGGLE_FLOOR    $68 $78 $00 ; Tiles at $68 and $78 must be blue


; D2: Verify a floor tile is red to open a door
_interaction21_subid02:
	ld a,(wRoomLayout+$5a)		; $4ce7
	cp TILEINDEX_RED_TOGGLE_FLOOR			; $4cea
	ld a,$01		; $4cec
	jr z,+			; $4cee
	dec a			; $4cf0
+
	ld (wActiveTriggers),a		; $4cf1
	ret			; $4cf4


; Light torches when a colored cube rolls into this position.
_interaction21_subid03:
	call checkInteractionState		; $4cf5
	jr nz,@initialized	; $4cf8

	call interactionIncState		; $4cfa
	call objectGetTileAtPosition		; $4cfd
	ld a,(wRotatingCubePos)		; $4d00
	ld e,Interaction.var03		; $4d03
	ld (de),a		; $4d05
	cp l			; $4d06
	call z,@lightCubeTorches		; $4d07

@initialized:
	ld e,Interaction.var03		; $4d0a
	ld a,(de)		; $4d0c
	ld b,a			; $4d0d
	ld a,(wRotatingCubePos)		; $4d0e
	cp b			; $4d11
	ret z			; $4d12

	call objectGetTileAtPosition		; $4d13
	ld a,(wRotatingCubePos)		; $4d16
	cp l			; $4d19
	call z,@lightCubeTorches		; $4d1a
	ld a,(wRotatingCubePos)		; $4d1d
	ld e,Interaction.var03		; $4d20
	ld (de),a		; $4d22
	ret			; $4d23

@lightCubeTorches:
	ld hl,wRotatingCubeColor		; $4d24
	set 7,(hl)		; $4d27
	ld a,SND_LIGHTTORCH		; $4d29
	jp playSound		; $4d2b


; d2: Set torch color based on the color of the tile at this position.
_interaction21_subid04:
	call checkInteractionState		; $4d2e
	jr nz,@initialized	; $4d31

	call interactionIncState		; $4d33
	call objectGetTileAtPosition		; $4d36
	ld e,Interaction.var03		; $4d39
	ld (de),a		; $4d3b
	sub TILEINDEX_RED_TOGGLE_FLOOR			; $4d3c
	set 7,a			; $4d3e
	ld (wRotatingCubeColor),a		; $4d40
	ld a,$57		; $4d43
	ld (wRotatingCubePos),a		; $4d45

@initialized:
	call objectGetTileAtPosition		; $4d48
	ld b,a			; $4d4b
	sub TILEINDEX_RED_TOGGLE_FLOOR			; $4d4c
	cp $03			; $4d4e
	ret nc			; $4d50

	ld e,Interaction.var03		; $4d51
	ld a,(de)		; $4d53
	cp b			; $4d54
	ret z			; $4d55

	ld a,b			; $4d56
	ld (de),a		; $4d57
	sub TILEINDEX_RED_TOGGLE_FLOOR			; $4d58
	set 7,a			; $4d5a
	ld (wRotatingCubeColor),a		; $4d5c
	ret			; $4d5f


; d2: Drop a small key here when a colored block puzzle has been solved.
_interaction21_subid05:
	call _interactionDeleteAndRetIfItemFlagSet		; $4d60
	ld hl,@tileData		; $4d63
	jp _verifyTilesAndDropSmallKey		; $4d66

@tileData:
	.db TILEINDEX_RED_PUSHABLE_BLOCK     $49 $4b $69 $6b $ff
	.db TILEINDEX_YELLOW_PUSHABLE_BLOCK  $5a $ff
	.db TILEINDEX_BLUE_PUSHABLE_BLOCK    $4a $59 $5b $6a $00


; d2: Set trigger 0 when the colored flames are lit red.
_interaction21_subid06:
	ld b,$80		; $4d78
	jr ++			; $4d7a

; d1: Set trigger 0 when the colored flames are lit blue.
_interaction21_subid19:
	ld b,$82		; $4d7c
++
	ld a,(wRotatingCubeColor)		; $4d7e
	cp b			; $4d81
	ld a,$01		; $4d82
	jr z,+			; $4d84
	dec a			; $4d86
+
	ld (wActiveTriggers),a		; $4d87
	ret			; $4d8a


; Toggle a bit in wSwitchState based on whether a toggleable floor tile at position Y is
; blue. The bitmask to use is X.
_interaction21_subid07:
	ld e,Interaction.yh		; $4d8b
	ld a,(de)		; $4d8d
	ld c,a			; $4d8e
	ld b,>wRoomLayout		; $4d8f
	ld a,(bc)		; $4d91
	sub TILEINDEX_RED_TOGGLE_FLOOR			; $4d92
	cp $03			; $4d94
	ret nc			; $4d96

	ld a,(bc)		; $4d97
	cp TILEINDEX_RED_TOGGLE_FLOOR			; $4d98
	jr z,_unsetSwitch	; $4d9a
	cp TILEINDEX_YELLOW_TOGGLE_FLOOR			; $4d9c
	jr z,_unsetSwitch	; $4d9e

_setSwitch:
	ld e,Interaction.xh		; $4da0
	ld a,(de)		; $4da2
	ld hl,wSwitchState		; $4da3
	or (hl)			; $4da6
	ld (hl),a		; $4da7
	ret			; $4da8

_unsetSwitch:
	ld e,Interaction.xh		; $4da9
	ld a,(de)		; $4dab
	cpl			; $4dac
	ld hl,wSwitchState		; $4dad
	and (hl)		; $4db0
	ld (hl),a		; $4db1
	ret			; $4db2


; Toggle a bit in wSwitchState based on whether blue flames are lit. The bitmask to use is
; X.
_interaction21_subid08:
	ld hl,wRotatingCubeColor		; $4db3
	bit 7,(hl)		; $4db6
	ret z			; $4db8
	res 7,(hl)		; $4db9
	ld a,(hl)		; $4dbb
	cp $02			; $4dbc
	jr z,_setSwitch	; $4dbe
	jr _unsetSwitch		; $4dc0


; d3: Drop a small key when 3 blocks have been pushed.
_interaction21_subid09:
	call _interactionDeleteAndRetIfItemFlagSet		; $4dc2
	ld hl,@tileData		; $4dc5
	jp _verifyTilesAndDropSmallKey		; $4dc8

@tileData:
	.db TILEINDEX_PUSHABLE_BLOCK $3b $59 $5d $00


; d3: When an orb is hit, spawn an armos, as well as interaction which will spawn a chest
; when it's killed.
_interaction21_subid0a:
	call checkInteractionState		; $4dd0
	jr nz,@initialized	; $4dd3

	ld hl,wToggleBlocksState		; $4dd5
	res 4,(hl)		; $4dd8

	ld hl,objectData.moonlitGrotto_orb		; $4dda
	call parseGivenObjectData		; $4ddd

	call _interactionDeleteAndRetIfItemFlagSet		; $4de0
	call interactionIncState		; $4de3

@initialized:
	ld hl,wToggleBlocksState		; $4de6
	bit 4,(hl)		; $4de9
	ret z			; $4deb

	; Do something with the chest?
	ld a,$01		; $4dec
	ld ($cca2),a		; $4dee

	ld hl,objectData.moonlitGrotto_onOrbActivation		; $4df1
	call parseGivenObjectData		; $4df4

	jp interactionDelete		; $4df7


; Unused? A chest appears when 4 torches in a diamond formation are lit?
_interaction21_subid0b:
	call checkInteractionState		; $4dfa
	jr nz,@initialized	; $4dfd

	call getThisRoomFlags		; $4dff
	and $80			; $4e02
	jp nz,interactionDelete		; $4e04

	ld hl,objectData.objectData77d4		; $4e07
	call parseGivenObjectData		; $4e0a

	ldbc $4b,$35		; $4e0d
	call _makeTorchAtPositionTemporarilyLightable		; $4e10
	jp nz,interactionDelete		; $4e13

	ldbc $4b,$53		; $4e16
	call _makeTorchAtPositionTemporarilyLightable		; $4e19
	jp nz,interactionDelete		; $4e1c

	ldbc $4b,$57		; $4e1f
	call _makeTorchAtPositionTemporarilyLightable		; $4e22
	jp nz,interactionDelete		; $4e25

	ldbc $4b,$75		; $4e28
	call _makeTorchAtPositionTemporarilyLightable		; $4e2b
	jp nz,interactionDelete		; $4e2e

	call interactionIncState		; $4e31

@initialized:
	ld a,(wNumTorchesLit)		; $4e34
	cp $04			; $4e37
	ret nz			; $4e39
	ld hl,wDisabledObjects		; $4e3a
	set 3,(hl)		; $4e3d
	call getThisRoomFlags		; $4e3f
	set 7,(hl)		; $4e42
	ld a,$01		; $4e44
	ld (wActiveTriggers),a		; $4e46
	jp interactionDelete		; $4e49


; d3: 4 armos spawn when trigger 0 is activated.
_interaction21_subid0c:
	ld a,(wActiveTriggers)		; $4e4c
	or a			; $4e4f
	ret z			; $4e50
	ld ($cca2),a		; $4e51
	ld hl,objectData.moonlitGrotto_onArmosSwitchPressed		; $4e54
	call parseGivenObjectData		; $4e57
	jp interactionDelete		; $4e5a


; d3: Crystal breakage handler
_interaction21_subid0d:
	ld e,Interaction.state		; $4e5d
	ld a,(de)		; $4e5f
	rst_jumpTable			; $4e60
	.dw @state0
	.dw @state1
	.dw interactionRunScript
	.dw @state3

@state0:
	ld a,GLOBALFLAG_D3_CRYSTALS		; $4e69
	call checkGlobalFlag		; $4e6b
	jp nz,interactionDelete		; $4e6e
	call getThisRoomFlags		; $4e71
	and $40			; $4e74
	jp nz,interactionDelete		; $4e76

	ld a,(wSwitchState)		; $4e79
	ld e,Interaction.counter2		; $4e7c
	ld (de),a		; $4e7e
	jp interactionIncState		; $4e7f

@state1:
	ld a,(wSwitchState)		; $4e82
	ld b,a			; $4e85
	ld e,Interaction.counter2		; $4e86
	ld a,(de)		; $4e88
	cp b			; $4e89
	ret z			; $4e8a

	ld a,(wLinkDeathTrigger)		; $4e8b
	or a			; $4e8e
	ret nz			; $4e8f

	inc a			; $4e90
	ld (wDisabledObjects),a		; $4e91
	ld (wMenuDisabled),a		; $4e94
	ld (wDisableScreenTransitions),a		; $4e97
	ld (wcc90),a		; $4e9a

	ld hl,moonlitGrottoScript_brokeCrystal		; $4e9d
	call interactionSetScript		; $4ea0
	call interactionRunScript		; $4ea3
	jp interactionIncState		; $4ea6

@state3:
	ld a,(wSwitchState)		; $4ea9
	and $f0			; $4eac
	cp $f0			; $4eae
	jr nz,@enableControl	; $4eb0

	ld a,$02		; $4eb2
	ld (wScreenShakeMagnitude),a		; $4eb4

	ld hl,moonlitGrottoScript_brokeAllCrystals		; $4eb7
	call interactionSetScript		; $4eba

	ld e,Interaction.state		; $4ebd
	ld a,$02		; $4ebf
	ld (de),a		; $4ec1

	xor a			; $4ec2
	ld (wSpinnerState),a		; $4ec3
	ret			; $4ec6

@enableControl:
	jpab scriptHlp.moonlitGrotto_enableControlAfterBreakingCrystal		; $4ec7


; d3: Small key falls when a block is pushed into place
_interaction21_subid0e:
	call _interactionDeleteAndRetIfItemFlagSet		; $4ecf
	ld hl,wRoomLayout+$4a		; $4ed2
	ld a,(hl)		; $4ed5
	cp $2a			; $4ed6
	ret nz			; $4ed8
	jp _spawnSmallKeyFromCeiling		; $4ed9


; d4: A door opens when a certain floor pattern is achieved
_interaction21_subid0f:
	call interactionDeleteAndRetIfEnabled02		; $4edc
	ld hl,@tileData		; $4edf
	call _verifyTiles		; $4ee2
	ld a,$01		; $4ee5
	jr z,+			; $4ee7
	dec a			; $4ee9
+
	ld (wActiveTriggers),a		; $4eea
	ret			; $4eed

@tileData:
	.db TILEINDEX_RED_TOGGLE_FLOOR    $43 $45 $64 $ff
	.db TILEINDEX_YELLOW_TOGGLE_FLOOR $54 $63 $65 $ff
	.db TILEINDEX_BLUE_TOGGLE_FLOOR   $44 $53 $55 $00


; d4: A small key falls when a certain froor pattern is achieved
_interaction21_subid10:
	call interactionDeleteAndRetIfEnabled02		; $4efd
	call _interactionDeleteAndRetIfItemFlagSet		; $4f00
	ld hl,@tileData		; $4f03
	jp _verifyTilesAndDropSmallKey		; $4f06

@tileData:
	.db TILEINDEX_RED_TOGGLE_FLOOR  $54 $58 $ff
	.db TILEINDEX_BLUE_TOGGLE_FLOOR $55 $57 $00


; Tile-filling puzzle: when all the blue turns red, a chest will spawn here.
_interaction21_subid11:
	call interactionDeleteAndRetIfEnabled02		; $4f11
	call _interactionDeleteAndRetIfItemFlagSet		; $4f14

	ld a,TILEINDEX_BLUE_FLOOR		; $4f17
	call findTileInRoom		; $4f19
	ret z			; $4f1c

spawnChestAndDeleteSelf:
	ld a,SND_SOLVEPUZZLE		; $4f1d
	call playSound		; $4f1f
	call objectGetTileAtPosition		; $4f22
	ld c,l			; $4f25
	ld a,TILEINDEX_CHEST		; $4f26
	call setTile		; $4f28
	call objectCreatePuff		; $4f2b
	jp interactionDelete		; $4f2e


; d4: A chest spawns here when the torches light up with the color blue.
_interaction21_subid12:
	call _interactionDeleteAndRetIfItemFlagSet		; $4f31
	ld a,(wRotatingCubeColor)		; $4f34
	bit 7,a			; $4f37
	ret z			; $4f39
	and $03			; $4f3a
	cp $02			; $4f3c
	ret nz			; $4f3e
	jr spawnChestAndDeleteSelf		; $4f3f


; d5: A chest spawns here when all the spaces around the owl statue are filled.
_interaction21_subid13:
	call interactionDeleteAndRetIfEnabled02		; $4f41
	call _interactionDeleteAndRetIfItemFlagSet		; $4f44
	ld b,>wRoomLayout		; $4f47
	ld hl,@positionsToCheck		; $4f49
@next:
	ldi a,(hl)		; $4f4c
	or a			; $4f4d
	jr z,spawnChestAndDeleteSelf	; $4f4e
	ld c,a			; $4f50
	ld a,(bc)		; $4f51
	sub TILEINDEX_RED_PUSHABLE_BLOCK			; $4f52
	cp $03			; $4f54
	jr c,@next		; $4f56
	ret			; $4f58

@positionsToCheck: ; The positions in a circle around the owl statue
	.db $47 $48 $49 $57 $59 $67 $68 $69 $00


; d5: A chest spawns here when two blocks are pushed to the right places
_interaction21_subid14:
	call interactionDeleteAndRetIfEnabled02		; $4f62
	call _interactionDeleteAndRetIfItemFlagSet		; $4f65
	ld hl,@tileData		; $4f68
	call _verifyTiles		; $4f6b
	ret nz			; $4f6e
	jp spawnChestAndDeleteSelf		; $4f6f

@tileData:
	.db TILEINDEX_PUSHABLE_STATUE  $45 $49 $00


; d5: Cane of Somaria chest spawns here when blocks are pushed into a pattern
_interaction21_subid15:
	call interactionDeleteAndRetIfEnabled02		; $4f76
	call _interactionDeleteAndRetIfItemFlagSet		; $4f79
	ld hl,@tileData		; $4f7c
	call _verifyTiles		; $4f7f
	ret nz			; $4f82
	jp spawnChestAndDeleteSelf		; $4f83

@tileData:
	.db TILEINDEX_RED_PUSHABLE_BLOCK    $54 $62 $ff
	.db TILEINDEX_YELLOW_PUSHABLE_BLOCK $33 $52 $ff
	.db TILEINDEX_BLUE_PUSHABLE_BLOCK   $44 $73 $00


; d5: Sets floor tiles to show a pattern when a switch is held down.
_interaction21_subid16:
	call interactionDeleteAndRetIfEnabled02		; $4f92
	ld e,Interaction.state		; $4f95
	ld a,(de)		; $4f97
	rst_jumpTable			; $4f98
	.dw @state0
	.dw _interaction21_subid16_state1

@state0:
	ld a,(wActiveTriggers)		; $4f9d
	or a			; $4fa0
	ret z			; $4fa1

	call interactionIncState		; $4fa2

	ld c,$5c		; $4fa5
	ld a,TILEINDEX_RED_TOGGLE_FLOOR		; $4fa7
	call _setTileWithPuff		; $4fa9

	ld c,$6a		; $4fac
	ld a,TILEINDEX_RED_TOGGLE_FLOOR		; $4fae
	call _setTileWithPuff		; $4fb0

	ld c,$3b		; $4fb3
	ld a,TILEINDEX_YELLOW_TOGGLE_FLOOR		; $4fb5
	call _setTileWithPuff		; $4fb7

	ld c,$5a		; $4fba
	ld a,TILEINDEX_YELLOW_TOGGLE_FLOOR		; $4fbc
	call _setTileWithPuff		; $4fbe

	ld c,$4c		; $4fc1
	ld a,TILEINDEX_BLUE_TOGGLE_FLOOR		; $4fc3
	call _setTileWithPuff		; $4fc5

	ld c,$7b		; $4fc8
	ld a,TILEINDEX_BLUE_TOGGLE_FLOOR		; $4fca
	jr _setTileWithPuff		; $4fcc

_setTileToStandardFloor:
	ld a,TILEINDEX_STANDARD_FLOOR		; $4fce

_setTileWithPuff:
	call setTile		; $4fd0

;;
; @param	c	Position to create puff at
; @addr{4fd3}
_createPuffAt:
	call getFreeInteractionSlot		; $4fd3
	ret nz			; $4fd6
	ld (hl),INTERACID_PUFF		; $4fd7
	ld l,Interaction.yh		; $4fd9
	jp setShortPosition_paramC		; $4fdb

_interaction21_subid16_state1:
	ld a,(wActiveTriggers)		; $4fde
	or a			; $4fe1
	ret nz			; $4fe2

	ld c,$5c		; $4fe3
	call _setTileToStandardFloor		; $4fe5
	ld c,$6a		; $4fe8
	call _setTileToStandardFloor		; $4fea
	ld c,$3b		; $4fed
	call _setTileToStandardFloor		; $4fef
	ld c,$5a		; $4ff2
	call _setTileToStandardFloor		; $4ff4
	ld c,$4c		; $4ff7
	call _setTileToStandardFloor		; $4ff9
	ld c,$7b		; $4ffc
	call _setTileToStandardFloor		; $4ffe

	ld e,Interaction.state		; $5001
	xor a			; $5003
	ld (de),a		; $5004
	ret			; $5005


; Create a chest at position Y which appears when [wActiveTriggers] == X, but which also
; disappears when the trigger is released.
_interaction21_subid17:
	call interactionDeleteAndRetIfEnabled02		; $5006
	call getThisRoomFlags		; $5009
	and ROOMFLAG_ITEM			; $500c
	jp nz,interactionDelete		; $500e

	ld e,Interaction.xh		; $5011
	ld a,(de)		; $5013
	ld b,a			; $5014
	ld a,(wActiveTriggers)		; $5015
	cp b			; $5018
	jr nz,@triggerInactive	; $5019

@triggerActive:
	ld e,Interaction.yh		; $501b
	ld a,(de)		; $501d
	ld c,a			; $501e
	ld b,>wRoomLayout		; $501f
	ld a,(bc)		; $5021
	cp TILEINDEX_CHEST			; $5022
	ret z			; $5024

	ld a,TILEINDEX_CHEST		; $5025
	call setTile		; $5027
	call _createPuffAt		; $502a
	ld a,SND_SOLVEPUZZLE		; $502d
	jp playSound		; $502f

@triggerInactive:
	ld e,Interaction.yh		; $5032
	ld a,(de)		; $5034
	ld c,a			; $5035
	ld b,>wRoomLayout		; $5036
	ld a,(bc)		; $5038
	cp TILEINDEX_CHEST			; $5039
	ret nz			; $503b

	; Retrieve whatever tile was there before the chest
	ld a,:w3RoomLayoutBuffer		; $503c
	ld ($ff00+R_SVBK),a	; $503e
	ld b,>w3RoomLayoutBuffer		; $5040
	ld a,(bc)		; $5042
	ld l,a			; $5043
	xor a			; $5044
	ld ($ff00+R_SVBK),a	; $5045

	ld a,l			; $5047
	call setTile		; $5048
	jp _createPuffAt		; $504b


; d3: Calculate the value for [wSwitchState] based on which crystals are broken.
_interaction21_subid18:
	call getThisRoomFlags		; $504e
	ld b,$00		; $5051

	ld l,$5d		; $5053
	bit 6,(hl)		; $5055
	jr z,+			; $5057
	set 4,b			; $5059
+
	ld l,$5f		; $505b
	bit 6,(hl)		; $505d
	jr z,+			; $505f
	set 5,b			; $5061
+
	ld l,$61		; $5063
	bit 6,(hl)		; $5065
	jr z,+			; $5067
	set 6,b			; $5069
+
	ld l,$63		; $506b
	bit 6,(hl)		; $506d
	jr z,+			; $506f
	set 7,b			; $5071
+
	ld a,(wSwitchState)		; $5073
	or b			; $5076
	ld (wSwitchState),a		; $5077
	jp interactionDelete		; $507a


;;
; @addr{507d}
_interactionDeleteAndRetIfItemFlagSet:
	call getThisRoomFlags		; $507d
	and ROOMFLAG_ITEM			; $5080
	ret z			; $5082
	pop hl			; $5083
	jp interactionDelete		; $5084

;;
; @addr{5087}
_spawnSmallKeyFromCeiling:
	ldbc TREASURE_SMALL_KEY, $01		; $5087
	call createTreasure		; $508a
	ret nz			; $508d
	call objectCopyPosition		; $508e
	jp interactionDelete		; $5091

;;
; Verifies that certain tiles in the room layout equal specified values.
;
; @param	hl	Data structure where the first byte is a tile index, and
;			subsequent bytes are positions where the tile is expected to equal
;			that index. Value $ff starts a new "group", and $00 ends the
;			structure.
; @param[out]	zflag	Set if the tiles all match the expected values.
; @addr{5094}
_verifyTiles:
	ld b,>wRoomLayout		; $5094
@nextTileIndex:
	ldi a,(hl)		; $5096
	or a			; $5097
	ret z			; $5098
	ld e,a			; $5099
@nextPosition:
	ldi a,(hl)		; $509a
	ld c,a			; $509b
	or a			; $509c
	ret z			; $509d
	inc a			; $509e
	jr z,@nextTileIndex	; $509f
	ld a,(bc)		; $50a1
	cp e			; $50a2
	ret nz			; $50a3
	jr @nextPosition		; $50a4

;;
; @param	b	Number of frames it can stay lit before burning out
; @param	c	Position
; @param[out]	zflag	Set if the part object was created successfully
; @addr{50a6}
_makeTorchAtPositionTemporarilyLightable:
	call getFreePartSlot		; $50a6
	ret nz			; $50a9

	ld (hl),PARTID_LIGHTABLE_TORCH		; $50aa
	inc l			; $50ac
	ld (hl),$01		; $50ad
	ld l,Part.counter2		; $50af
	ld (hl),b		; $50b1
	ld l,Part.yh		; $50b2
	call setShortPosition_paramC		; $50b4
	xor a			; $50b7
	ret			; $50b8


; ==============================================================================
; INTERACID_FLOOR_COLOR_CHANGER
; ==============================================================================
interactionCode22:
	ld e,Interaction.subid		; $50b9
	ld a,(de)		; $50bb
	rst_jumpTable			; $50bc
	.dw @subid0
	.dw @subid1

; Subid 0: the "controller"; detects when the tile has been changed.
@subid0:
	call checkInteractionState		; $50c1
	jr nz,++		; $50c4

	call objectGetTileAtPosition		; $50c6
	ld e,Interaction.var03		; $50c9
	ld (de),a		; $50cb
	call interactionIncState		; $50cc
++
	; Check if the tile changed color
	call objectGetTileAtPosition		; $50cf
	ld e,Interaction.var03		; $50d2
	ld a,(de)		; $50d4
	cp (hl)			; $50d5
	ret z			; $50d6

	ld a,(hl)		; $50d7
	sub TILEINDEX_RED_TOGGLE_FLOOR			; $50d8
	cp $03			; $50da
	ret nc			; $50dc

	ld a,(hl)		; $50dd
	ld (de),a		; $50de
	sub TILEINDEX_RED_TOGGLE_FLOOR			; $50df
	add TILEINDEX_RED_FLOOR			; $50e1
	ld b,a			; $50e3
	call getFreeInteractionSlot		; $50e4
	ret nz			; $50e7

	ld (hl),INTERACID_FLOOR_COLOR_CHANGER		; $50e8
	inc l			; $50ea
	ld (hl),$01 ; [subid] = $01

	; Set var03 to the tile index to convert tiles to
	ld l,Interaction.var03		; $50ed
	ld (hl),b		; $50ef

	jp objectCopyPosition		; $50f0


; Subid 1: performs the updates to all tiles in the room in a random order.
@subid1:
	call checkInteractionState		; $50f3
	jr nz,@@initialized	; $50f6

	call objectGetTileAtPosition		; $50f8
	ld e,Interaction.var30		; $50fb
	ld (de),a		; $50fd
	call interactionIncState		; $50fe

	ld l,Interaction.counter1		; $5101
	ld (hl),$ff		; $5103

	; Generate all values from $00-$ff in a random order, and copy those values to
	; wBigBuffer.
	callab roomInitialization.generateRandomBuffer		; $5105
	ld a,:w4RandomBuffer		; $510d
	ld ($ff00+R_SVBK),a	; $510f
	ld hl,w4RandomBuffer		; $5111
	ld de,wBigBuffer		; $5114
	ld b,$00		; $5117
	call copyMemory		; $5119
	ld a,$01		; $511c
	ld ($ff00+R_SVBK),a	; $511e

	ldh a,(<hActiveObject)	; $5120
	ld d,a			; $5122

@@initialized:
	call objectGetTileAtPosition		; $5123
	ld e,Interaction.var30		; $5126
	ld a,(de)		; $5128
	cp (hl)			; $5129
	jp z,++			; $512a
	ld a,(hl)		; $512d
	cp TILEINDEX_SOMARIA_BLOCK			; $512e
	jp nz,interactionDelete		; $5130
++
	ld a,l			; $5133
	ldh (<hFF8C),a	; $5134
	call @convertNextTile		; $5136
	jr z,@done	; $5139
	call @convertNextTile		; $513b
	jr z,@done	; $513e
	call @convertNextTile		; $5140
	jr z,@done	; $5143
	call @convertNextTile		; $5145
	ret nz			; $5148
@done:
	call @convertNextTile		; $5149
	jp interactionDelete		; $514c

;;
; @param	hFF8C	Position of this object
; @param[out]	zflag	Set if we've converted the last tile
; @addr{514f}
@convertNextTile:
	ld e,Interaction.counter1		; $514f
	ld a,(de)		; $5151
	ld hl,wBigBuffer		; $5152
	rst_addAToHl			; $5155
	ldh a,(<hFF8C)	; $5156
	ld c,a			; $5158
	ld a,(hl) ; Get next position to update in 'a'

	; Check that the position is in-bounds, and is not this object's position
	cp LARGE_ROOM_HEIGHT*16 - 17			; $515a
	jr nc,@decCounter1	; $515c
	cp c			; $515e
	jr z,@decCounter1	; $515f

	; Position can't be on the screen edge (but it doesn't appear to check the right
	; edge?)
	and $0f			; $5161
	jr z,@decCounter1	; $5163
	ld a,(hl)		; $5165
	and $f0			; $5166
	jr z,@decCounter1	; $5168
	cp LARGE_ROOM_HEIGHT*16 - 16			; $516a
	jr z,@decCounter1	; $516c

	; Check if this is a tile that should be replaced
	ld a,(hl)		; $516e
	ld l,a			; $516f
	ld h,>wRoomLayout		; $5170
	ld a,(hl)		; $5172
	sub TILEINDEX_RED_FLOOR			; $5173
	cp $03			; $5175
	jr nc,@notColoredFloor	; $5177

	; Replace the tile
	ld e,Interaction.var03		; $5179
	ld a,(de)		; $517b
	ld c,l			; $517c
	call setTile		; $517d
@decCounter1:
	jp interactionDecCounter1		; $5180

@notColoredFloor:
	; If it's not a colored floor, we should at least change the tile "underneath" it
	; in w3RoomLayoutBuffer, in case it's pushable or something.
	ld e,Interaction.var03		; $5183
	ld a,(de)		; $5185
	ld b,a			; $5186
	ld c,l			; $5187
	call setTileInRoomLayoutBuffer		; $5188
	jp interactionDecCounter1		; $518b

; ==============================================================================
; INTERACID_EXTENDABLE_BRIDGE
; ==============================================================================
interactionCode23:
	ld e,Interaction.state		; $518e
	ld a,(de)		; $5190
	rst_jumpTable			; $5191
	.dw @state0
	.dw @state1
	.dw @state2

@state0:
	ld e,Interaction.subid		; $5198
	ld a,(de)		; $519a
	ld b,a			; $519b
	and $07			; $519c
	ld hl,bitTable		; $519e
	add l			; $51a1
	ld l,a			; $51a2
	ld a,(hl)		; $51a3
	inc e			; $51a4
	ld (de),a ; [var03] = bitmask corresponding to [subid]

	; Check whether the tile here is a bridge; go to state 2 if so, state 1 otherwise
	ld e,Interaction.yh		; $51a6
	ld a,(de)		; $51a8
	ld c,a			; $51a9
	ld b,>wRoomLayout		; $51aa
	ld a,(bc)		; $51ac
	sub TILEINDEX_VERTICAL_BRIDGE			; $51ad
	sub $06			; $51af
	ld a,$02		; $51b1
	jr c,+			; $51b3
	dec a			; $51b5
+
	ld e,Interaction.state		; $51b6
	ld (de),a		; $51b8
	ld e,Interaction.var30		; $51b9
	ld a,(wSwitchState)		; $51bb
	ld (de),a		; $51be
	ret			; $51bf

; State 1: waiting for switch to toggle to create bridge
@state1:
	ld e,Interaction.state2		; $51c0
	ld a,(de)		; $51c2
	rst_jumpTable			; $51c3
	.dw @state1Substate0
	.dw @state1Substate1

@state1Substate0:
	call @checkSwitchStateChanged		; $51c8
	ret z			; $51cb
	ld hl,@bridgeCreationData		; $51cc

@startLoadingBridgeData:
	ld e,Interaction.var30		; $51cf
	ld a,(wSwitchState)		; $51d1
	ld (de),a		; $51d4

	ld e,Interaction.xh		; $51d5
	ld a,(de)		; $51d7
	rst_addDoubleIndex			; $51d8
	ldi a,(hl)		; $51d9
	ld h,(hl)		; $51da
	ld l,a			; $51db

	ldi a,(hl)		; $51dc
	ld e,Interaction.var31		; $51dd
	ld (de),a		; $51df
	ld e,Interaction.relatedObj2		; $51e0
	ld a,l			; $51e2
	ld (de),a		; $51e3
	inc e			; $51e4
	ld a,h			; $51e5
	ld (de),a		; $51e6
	ld a,$0a		; $51e7
	ld e,Interaction.counter1		; $51e9
	ld (de),a		; $51eb
	jp interactionIncState2		; $51ec

@state1Substate1:
	call interactionDecCounter1		; $51ef
	ret nz			; $51f2
	ld (hl),$0a		; $51f3
	call @updateNextTile		; $51f5
	ld a,c			; $51f8
	inc a			; $51f9
	jr z,@gotoNextState	; $51fa
	ld e,Interaction.var31		; $51fc
	ld a,(de)		; $51fe
	call setTile		; $51ff
	ld a,SND_DOORCLOSE		; $5202
	jp playSound		; $5204

@gotoNextState:
	call interactionIncState		; $5207
	inc l			; $520a
	ld (hl),$00		; $520b
	ret			; $520d

; State 2: waiting for switch to toggle to remove bridge
@state2:
	ld e,Interaction.state2		; $520e
	ld a,(de)		; $5210
	rst_jumpTable			; $5211
	.dw @state2Substate0
	.dw @state2Substate1

@state2Substate0:
	call @checkSwitchStateChanged		; $5216
	ret z			; $5219
	ld hl,@bridgeRemovalData		; $521a
	jr @startLoadingBridgeData		; $521d

@state2Substate1:
	call interactionDecCounter1		; $521f
	ret nz			; $5222
	ld (hl),$0a		; $5223

	call @updateNextTile		; $5225
	ld a,c			; $5228
	inc a			; $5229
	jr z,@gotoState1	; $522a
	ld e,Interaction.var31		; $522c
	ld a,(de)		; $522e
	call setTile		; $522f
	ld a,SND_DOORCLOSE		; $5232
	jp playSound		; $5234

@gotoState1:
	ld h,d			; $5237
	ld l,Interaction.state		; $5238
	ld (hl),$01		; $523a
	inc l			; $523c
	ld (hl),$00		; $523d
	ret			; $523f

;;
; @param[out]	zflag	nz if the switch has been toggled
; @addr{5240}
@checkSwitchStateChanged:
	ld a,(wSwitchState)		; $5240
	ld b,a			; $5243
	ld e,Interaction.var30		; $5244
	ld a,(de)		; $5246
	xor b			; $5247
	ld b,a			; $5248
	ld e,Interaction.var03		; $5249
	ld a,(de)		; $524b
	and b			; $524c
	ret			; $524d

;;
; @param[out]	c	Next byte
; @addr{524e}
@updateNextTile:
	ld h,d			; $524e
	ld l,Interaction.relatedObj2		; $524f
	ld e,l			; $5251
	ldi a,(hl)		; $5252
	ld h,(hl)		; $5253
	ld l,a			; $5254

	ldi a,(hl)		; $5255
	ld c,a			; $5256

	ld a,l			; $5257
	ld (de),a		; $5258
	inc e			; $5259
	ld a,h			; $525a
	ld (de),a		; $525b
	ret			; $525c


; Which data is read from here depends on the value of "Interaction.xh".
@bridgeCreationData:
	.dw @creation0
	.dw @creation1
	.dw @creation2
	.dw @creation3
	.dw @creation4
	.dw @creation5
	.dw @creation6

; Data format:
;   First byte is the tile index to create for the bridge.
;   Subsequent bytes are positions at which to create that tile until it reaches $ff.

@creation0:
	.db TILEINDEX_VERTICAL_BRIDGE   $43 $53 $63 $ff
@creation1:
	.db TILEINDEX_HORIZONTAL_BRIDGE $76 $77 $78 $79 $ff
@creation2:
	.db TILEINDEX_HORIZONTAL_BRIDGE $39 $38 $37 $36 $ff
@creation3:
	.db TILEINDEX_VERTICAL_BRIDGE   $42 $52 $62 $ff
@creation4:
	.db TILEINDEX_VERTICAL_BRIDGE   $4c $5c $6c $ff
@creation5:
	.db TILEINDEX_HORIZONTAL_BRIDGE $2a $29 $28 $27 $ff
@creation6:
	.db TILEINDEX_VERTICAL_BRIDGE   $3d $4d $5d $6d $ff


@bridgeRemovalData:
	.dw @removal0
	.dw @removal1
	.dw @removal2
	.dw @removal3
	.dw @removal4
	.dw @removal5
	.dw @removal6

; Data format is the same as above.
; TILEINDEX_HOLE+1 is a hole that's completely black (doesn't have "ground" surrounding
; it.)

@removal0:
	.db TILEINDEX_HOLE+1  $63 $53 $43 $ff
@removal1:
	.db TILEINDEX_HOLE+1  $79 $78 $77 $76 $ff
@removal2:
	.db TILEINDEX_HOLE+1  $36 $37 $38 $39 $ff
@removal3:
	.db TILEINDEX_HOLE+1  $62 $52 $42 $ff
@removal4:
	.db TILEINDEX_HOLE+1  $6c $5c $4c $ff
@removal5:
	.db TILEINDEX_HOLE+1  $27 $28 $29 $2a $ff
@removal6:
	.db TILEINDEX_HOLE+1  $6d $5d $4d $3d $ff


; ==============================================================================
; INTERACID_TRIGGER_TRANSLATOR
; ==============================================================================
interactionCode24:
	call interactionDeleteAndRetIfEnabled02		; $52c7
	ld e,Interaction.subid		; $52ca
	ld a,(de)		; $52cc
	and $0f			; $52cd
	rst_jumpTable			; $52cf
	.dw @subid0
	.dw @subid1
	.dw @subid2

; Subid 0: control a bit in wActiveTriggers based on wToggleBlocksState.
@subid0:
	ld a,(wToggleBlocksState)		; $52d6
	ld c,a			; $52d9

@label_08_081:
	ld e,Interaction.subid		; $52da
	ld a,(de)		; $52dc
	swap a			; $52dd
	and $07			; $52df
	ld hl,bitTable		; $52e1
	add l			; $52e4
	ld l,a			; $52e5

	ld a,c			; $52e6
	and (hl)		; $52e7
	ld b,a			; $52e8
	ld a,(hl)		; $52e9
	cpl			; $52ea
	ld c,a			; $52eb
	ld a,(wActiveTriggers)		; $52ec
	and c			; $52ef
	or b			; $52f0
	ld (wActiveTriggers),a		; $52f1
	ret			; $52f4

; Subid 0: control a bit in wActiveTriggers based on wSwitchState.
@subid1:
	ld a,(wSwitchState)		; $52f5
	ld c,a			; $52f8
	jr @label_08_081		; $52f9

; Subid 2: check that [wNumLitTorches] == Y.
@subid2:
	ld e,Interaction.yh		; $52fb
	ld a,(de)		; $52fd
	ld b,a			; $52fe
	ld e,Interaction.xh		; $52ff
	ld a,(de)		; $5301
	ld c,a			; $5302
	ld a,(wNumTorchesLit)		; $5303
	cp b			; $5306
	jr nz,++		; $5307
	ld a,(wActiveTriggers)		; $5309
	or c			; $530c
	ld (wActiveTriggers),a		; $530d
	ret			; $5310
++
	ld a,c			; $5311
	cpl			; $5312
	ld c,a			; $5313
	ld a,(wActiveTriggers)		; $5314
	and c			; $5317
	ld (wActiveTriggers),a		; $5318
	ret			; $531b


; ==============================================================================
; INTERACID_TILE_FILLER
; ==============================================================================
interactionCode25:
	call returnIfScrollMode01Unset		; $531c
	ld e,Interaction.state		; $531f
	ld a,(de)		; $5321
	rst_jumpTable			; $5322
	.dw @state0
	.dw @state1

@state0:
	ld a,$01		; $5327
	ld (de),a		; $5329

	call objectGetTileAtPosition		; $532a
	ld c,l			; $532d
	ld a,TILEINDEX_YELLOW_FLOOR		; $532e
	call setTile		; $5330

	ld a,c			; $5333
	ld e,Interaction.var30		; $5334
	ld (de),a		; $5336

	call getFreeInteractionSlot		; $5337
	jr nz,@state1	; $533a
	ld (hl),INTERACID_PUFF		; $533c
	ld l,Interaction.yh		; $533e
	call setShortPosition_paramC		; $5340

@state1:
	; Check if Link's position has changed
	callab getLinkTilePosition		; $5343
	ld e,Interaction.var30		; $534b
	ld a,(de)		; $534d
	cp l			; $534e
	ret z			; $534f

	; Check that the position changed by exactly one tile horizontally or vertically
	ld b,a			; $5350
	ld a,l			; $5351
	add $f0			; $5352
	cp b			; $5354
	jr z,@updateFloor	; $5355
	ld a,l			; $5357
	inc a			; $5358
	cp b			; $5359
	jr z,@updateFloor	; $535a
	ld a,l			; $535c
	add $10			; $535d
	cp b			; $535f
	jr z,@updateFloor	; $5360
	ld a,l			; $5362
	dec a			; $5363
	cp b			; $5364
	ret nz			; $5365

@updateFloor:
	ld h,>wRoomLayout		; $5366
	ld a,(hl)		; $5368
	cp TILEINDEX_BLUE_FLOOR			; $5369
	ret nz			; $536b

	ld a,l			; $536c
	ldh (<hFF8B),a	; $536d
	ld e,Interaction.var30		; $536f
	ld (de),a		; $5371

	; Update the tile at the old position
	ld c,b			; $5372
	ld a,TILEINDEX_RED_FLOOR		; $5373
	call setTile		; $5375

	; Update the tile at the new position
	ldh a,(<hFF8B)	; $5378
	ld c,a			; $537a
	ld a,TILEINDEX_YELLOW_FLOOR		; $537b
	call setTile		; $537d

	ld a,SND_GETSEED		; $5380
	jp playSound		; $5382


; ==============================================================================
; INTERACID_BIPIN
; ==============================================================================
interactionCode28:
	ld e,Interaction.state		; $5385
	ld a,(de)		; $5387
	rst_jumpTable			; $5388
	.dw @state0
	.dw @state1

@state0:
	call interactionInitGraphics		; $538d
	call interactionIncState		; $5390

	; Decide what script to load based on subid
	ld e,Interaction.subid		; $5393
	ld a,(de)		; $5395
	ld hl,@scriptTable		; $5396
	rst_addDoubleIndex			; $5399
	ldi a,(hl)		; $539a
	ld h,(hl)		; $539b
	ld l,a			; $539c
	call interactionSetScript		; $539d

	ld e,Interaction.subid		; $53a0
	ld a,(de)		; $53a2
	rst_jumpTable			; $53a3
	.dw @bipin0
	.dw @bipin1
	.dw @bipin1
	.dw @bipin1
	.dw @bipin1
	.dw @bipin2
	.dw @bipin1
	.dw @bipin1
	.dw @bipin1
	.dw @bipin1
	.dw @bipin3


; Bipin running around, baby just born
@bipin0:
	ld h,d			; $53ba
	ld l,Interaction.speed		; $53bb
	ld (hl),SPEED_100		; $53bd
	ld l,Interaction.angle		; $53bf
	ld (hl),$18		; $53c1

	ld l,Interaction.var3a		; $53c3
	ld a,$04		; $53c5
	ld (hl),a		; $53c7
	call interactionSetAnimation		; $53c8

	jp @updateCollisionAndVisibility		; $53cb


; Bipin gives you a random tip
@bipin1:
	ld a,$03		; $53ce
	call interactionSetAnimation		; $53d0
	jp @updateCollisionAndVisibility		; $53d3


; Bipin just moved to Labrynna/Holodrum?
@bipin2:
	ld a,$02		; $53d6
	call interactionSetAnimation		; $53d8
	jp @updateCollisionAndVisibility		; $53db


; "Past" version of Bipin who gives you a gasha seed
@bipin3:
	ld a,$09		; $53de
	call interactionSetAnimation		; $53e0
	jp @updateCollisionAndVisibility		; $53e3


@state1:
	ld e,Interaction.subid		; $53e6
	ld a,(de)		; $53e8
	rst_jumpTable			; $53e9
	.dw @bipinSubid0
	.dw @runScriptAndAnimate
	.dw @runScriptAndAnimate
	.dw @runScriptAndAnimate
	.dw @runScriptAndAnimate
	.dw @runScriptAndAnimate
	.dw @runScriptAndAnimate
	.dw @runScriptAndAnimate
	.dw @runScriptAndAnimate
	.dw @runScriptAndAnimate
	.dw @runScriptAndAnimate

@bipinSubid0:
	call @updateSpeed		; $5400

@runScriptAndAnimate:
	call interactionRunScript		; $5403
	jp @updateAnimation		; $5406

@updateAnimation:
	call interactionAnimate		; $5409

@updateCollisionAndVisibility:
	call objectPreventLinkFromPassing		; $540c
	jp objectSetPriorityRelativeToLink_withTerrainEffects		; $540f


; Bipin runs around like a madman when his baby is first born
@updateSpeed:
	call objectApplySpeed		; $5412
	ld e,Interaction.xh		; $5415
	ld a,(de)		; $5417
	sub $28			; $5418
	cp $30			; $541a
	ret c			; $541c

	; Reverse direction
	ld h,d			; $541d
	ld l,Interaction.angle		; $541e
	ld a,(hl)		; $5420
	xor $10			; $5421
	ld (hl),a		; $5423

	ld l,Interaction.var3a		; $5424
	ld a,(hl)		; $5426
	xor $01			; $5427
	ld (hl),a		; $5429
	jp interactionSetAnimation		; $542a


@scriptTable:
	.dw bipinScript0
	.dw bipinScript1
	.dw bipinScript1
	.dw bipinScript1
	.dw bipinScript1
	.dw bipinScript2
	.dw bipinScript1
	.dw bipinScript1
	.dw bipinScript1
	.dw bipinScript1
	.dw bipinScript3


; ==============================================================================
; INTERACID_ADLAR
; ==============================================================================
interactionCode29:
	call checkInteractionState		; $5443
	jr z,@state0		; $5446

@state1:
	call interactionRunScript		; $5448
	jp interactionAnimateAsNpc		; $544b

@state0:
	call interactionInitGraphics		; $544e
	call interactionIncState		; $5451

	; Decide on a value to write to var38; this will affect the script.

	ld a,GLOBALFLAG_FINISHEDGAME		; $5454
	call checkGlobalFlag		; $5456
	ld a,$04		; $5459
	jr nz,@setVar38		; $545b

	ld hl,wGroup4Flags+$fc		; $545d
	bit 7,(hl)		; $5460
	ld a,$03		; $5462
	jr nz,@setVar38		; $5464

	ld a,GLOBALFLAG_SAVED_NAYRU		; $5466
	call checkGlobalFlag		; $5468
	ld a,$02		; $546b
	jr nz,@setVar38		; $546d

	call getThisRoomFlags		; $546f
	bit 6,(hl)		; $5472
	ld a,$01		; $5474
	jr nz,@setVar38		; $5476
	xor a			; $5478
@setVar38:
	ld e,Interaction.var38		; $5479
	ld (de),a		; $547b
	call objectSetVisiblec2		; $547c

	ld hl,adlarScript		; $547f
	jp interactionSetScript		; $5482


; ==============================================================================
; INTERACID_LIBRARIAN
; ==============================================================================
interactionCode2a:
	call checkInteractionState		; $5485
	jr z,@state0		; $5488

@state1:
	call interactionRunScript		; $548a
	jp interactionAnimateAsNpc		; $548d

@state0:
	call interactionInitGraphics		; $5490
	call interactionIncState		; $5493

	ld l,Interaction.textID+1		; $5496
	ld (hl),>TX_2700		; $5498

	ld l,Interaction.collisionRadiusY		; $549a
	ld (hl),$0c		; $549c
	inc l			; $549e
	ld (hl),$06		; $549f

	ld a,GLOBALFLAG_WATER_POLLUTION_FIXED		; $54a1
	call checkGlobalFlag		; $54a3
	ld a,<TX_2715		; $54a6
	jr z,+			; $54a8
	ld a,<TX_2716		; $54aa
+
	ld e,Interaction.textID		; $54ac
	ld (de),a		; $54ae

	call objectSetVisiblec2		; $54af

	ld hl,librarianScript		; $54b2
	jp interactionSetScript		; $54b5


; ==============================================================================
; INTERACID_BLOSSOM
; ==============================================================================
interactionCode2b:
	ld e,Interaction.state		; $54b8
	ld a,(de)		; $54ba
	rst_jumpTable			; $54bb
	.dw @state0
	.dw @state1

@state0:
	call interactionInitGraphics		; $54c0
	ld a,>TX_4400		; $54c3
	call interactionSetHighTextIndex		; $54c5
	call interactionIncState		; $54c8

	ld e,Interaction.subid		; $54cb
	ld a,(de)		; $54cd
	ld hl,@scriptTable		; $54ce
	rst_addDoubleIndex			; $54d1
	ldi a,(hl)		; $54d2
	ld h,(hl)		; $54d3
	ld l,a			; $54d4
	call interactionSetScript		; $54d5

	ld e,Interaction.subid		; $54d8
	ld a,(de)		; $54da
	rst_jumpTable			; $54db
	.dw @initAnimation0
	.dw @initAnimation0
	.dw @initAnimation4
	.dw @initAnimation0
	.dw @initAnimation4
	.dw @initAnimation4
	.dw @initAnimation4
	.dw @initAnimation4
	.dw @initAnimation4
	.dw @initAnimation4

@initAnimation0:
	ld a,$00		; $54f0
	call interactionSetAnimation		; $54f2
	jp @updateCollisionAndVisibility		; $54f5

@initAnimation4:
	ld a,$04		; $54f8
	call interactionSetAnimation		; $54fa
	jp @updateCollisionAndVisibility		; $54fd

@state1:
	call interactionRunScript		; $5500
	jp @updateAnimation		; $5503

@updateAnimation:
	call interactionAnimate		; $5506

@updateCollisionAndVisibility:
	call objectPreventLinkFromPassing		; $5509
	jp objectSetPriorityRelativeToLink_withTerrainEffects		; $550c

@scriptTable:
	.dw blossomScript0
	.dw blossomScript1
	.dw blossomScript2
	.dw blossomScript3
	.dw blossomScript4
	.dw blossomScript5
	.dw blossomScript6
	.dw blossomScript7
	.dw blossomScript8
	.dw blossomScript9


; ==============================================================================
; INTERACID_VERAN_CUTSCENE_WALLMASTER
; ==============================================================================
interactionCode2c:
	ld e,Interaction.state		; $5523
	ld a,(de)		; $5525
	rst_jumpTable			; $5526
	.dw @state0
	.dw @state1

@state0:
	ld a,$01		; $552b
	ld (de),a		; $552d
	call interactionInitGraphics		; $552e

	ld bc,$0140		; $5531
	call objectSetSpeedZ		; $5534
	ld l,Interaction.counter1		; $5537
	ld (hl),$14		; $5539
	ld l,Interaction.zh		; $553b
	ld (hl),$a0		; $553d

	call objectSetVisiblec3		; $553f

@state1:
	call interactionAnimate		; $5542
	ld e,Interaction.state2		; $5545
	ld a,(de)		; $5547
	rst_jumpTable			; $5548
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3

@substate0:
	call interactionDecCounter1		; $5551
	ret nz			; $5554
	jp interactionIncState2		; $5555

@substate1:
	ld c,$00		; $5558
	call objectUpdateSpeedZ_paramC		; $555a
	ret nz			; $555d
	ld a,$01		; $555e
	call interactionSetAnimation		; $5560
	jp interactionIncState2		; $5563

@substate2:
	ld e,Interaction.animParameter		; $5566
	ld a,(de)		; $5568
	bit 7,a			; $5569
	jp nz,interactionIncState2		; $556b

	or a			; $556e
	ret z			; $556f

	xor a			; $5570
	ld (w1Link.visible),a		; $5571
	ld a,$1e		; $5574
	ld e,Interaction.counter1		; $5576
	ld (de),a		; $5578
	ld a,SND_BOSS_DEAD		; $5579
	jp playSound		; $557b

@substate3:
	ld e,Interaction.counter1		; $557e
	ld a,(de)		; $5580
	or a			; $5581
	jr z,++			; $5582
	dec a			; $5584
	ld (de),a		; $5585
	ret			; $5586
++
	ld e,Interaction.zh		; $5587
	ld a,(de)		; $5589
	dec a			; $558a
	ld (de),a		; $558b
	cp $b0			; $558c
	ret nz			; $558e
	ld a,$08		; $558f
	ld (wTmpcbb5),a		; $5591
	jp interactionDelete		; $5594


; ==============================================================================
; INTERACID_VERAN_CUTSCENE_FACE
; ==============================================================================
interactionCode2d:
	ld e,Interaction.state		; $5597
	ld a,(de)		; $5599
	rst_jumpTable			; $559a
	.dw @state0
	.dw @state1
	.dw @state2

@state0:
	ld a,$01		; $55a1
	ld (de),a		; $55a3
	call interactionInitGraphics		; $55a4
	call interactionSetAlwaysUpdateBit		; $55a7
	ld a,PALH_87		; $55aa
	call loadPaletteHeader		; $55ac
	ld hl,veranFaceCutsceneScript		; $55af
	call interactionSetScript		; $55b2

@state2:
	ret			; $55b5

@state1:
	call interactionAnimate		; $55b6
	call interactionRunScript		; $55b9
	ret nc			; $55bc
	ld hl,@warpDestVariables		; $55bd
	call setWarpDestVariables		; $55c0
	xor a			; $55c3
	ld (wcc50),a		; $55c4
	jp interactionIncState		; $55c7

@warpDestVariables:
	m_HardcodedWarpA ROOM_AGES_4d4, $0c, $67, $03


; ==============================================================================
; INTERACID_OLD_MAN_WITH_RUPEES
; ==============================================================================
interactionCode2e:
	call checkInteractionState		; $55cf
	jr nz,@state1		; $55d2

@state0:
	inc a			; $55d4
	ld (de),a		; $55d5
	call interactionInitGraphics		; $55d6
	ld a,>TX_3300		; $55d9
	call interactionSetHighTextIndex		; $55db

	ld e,Interaction.subid		; $55de
	ld a,(de)		; $55e0
	ld hl,@scriptTable		; $55e1
	rst_addDoubleIndex			; $55e4
	ldi a,(hl)		; $55e5
	ld h,(hl)		; $55e6
	ld l,a			; $55e7
	call interactionSetScript		; $55e8

	ld h,d			; $55eb
	ld l,Interaction.yh		; $55ec
	ld (hl),$38		; $55ee
	ld l,Interaction.xh		; $55f0
	ld (hl),$28		; $55f2

@state1:
	call interactionRunScript		; $55f4
	jp npcFaceLinkAndAnimate		; $55f7

@scriptTable:
	.dw oldManScript_givesRupees
	.dw oldManScript_takesRupees


; ==============================================================================
; INTERACID_PLAY_NAYRU_MUSIC
; ==============================================================================
interactionCode2f:
	ld a,GLOBALFLAG_INTRO_DONE		; $55fe
	call checkGlobalFlag		; $5600
	jp nz,interactionDelete		; $5603
	ld hl,wActiveMusic		; $5606
	ld a,MUS_NAYRU		; $5609
	cp (hl)			; $560b
	jr z,+			; $560c

	ld (hl),a		; $560e
	call playSound		; $560f
+
	ld a,$02		; $5612
	call setMusicVolume		; $5614
	jp interactionDelete		; $5617


; ==============================================================================
; INTERACID_SHOOTING_GALLERY
; ==============================================================================
interactionCode30:
	ld e,Interaction.subid		; $561a
	ld a,(de)		; $561c
	rst_jumpTable			; $561d
	.dw shootingGalleryNpc
	.dw shootingGalleryNpc
	.dw shootingGalleryNpc
	.dw _shootingGalleryGame


;;
; Interaction $8b (goron elder) also calls this.
; @addr{5626}
shootingGalleryNpc:
	ld e,Interaction.state		; $5626
	ld a,(de)		; $5628
	rst_jumpTable			; $5629
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3

; State 0: initializing
@state0:
	ld a,$01		; $5632
	ld (de),a		; $5634
	call interactionInitGraphics		; $5635
	xor a			; $5638
	ld (wTmpcfc0.shootingGallery.disableGoronNpcs),a		; $5639
	call @setScript		; $563c

; State 1: waiting for player to talk to the npc and start the game
@state1:
	call interactionRunScript		; $563f
	jr nc,@updateAnimation	; $5642
	xor a			; $5644
	ld (wTmpcfc0.shootingGallery.gameStatus),a		; $5645
	call interactionIncState		; $5648

; State 2: waiting for the game to finish
@state2:
	ld a,(wTmpcfc0.shootingGallery.gameStatus)		; $564b
	or a			; $564e
	jr z,@updateAnimation	; $564f
	ld a,$01		; $5651
	call @setScript		; $5653
	call interactionIncState		; $5656

; State 3: waiting for "game wrapup" script to finish, then asks you to try again
@state3:
	call interactionRunScript		; $5659
	call c,@loadRetryScriptAndGotoState1		; $565c

@updateAnimation:
	ld e,Interaction.subid		; $565f
	ld a,(de)		; $5661
	cp $02			; $5662
	jp nz,interactionAnimateAsNpc		; $5664
	jp npcFaceLinkAndAnimate		; $5667

;;
; @addr{566a}
@loadRetryScriptAndGotoState1:
	ld h,d			; $566a
	ld l,Interaction.state		; $566b
	ld (hl),$01		; $566d
	ld a,$02		; $566f

;;
; @param	a	Script index.
; @addr{5671}
@setScript:
	; a *= 3
	ld b,a			; $5671
	add a			; $5672
	add b			; $5673

	ld h,d			; $5674
	ld l,Interaction.subid		; $5675
	add (hl)		; $5677
	ld hl,_shootingGalleryScriptTable		; $5678
	rst_addDoubleIndex			; $567b
	ldi a,(hl)		; $567c
	ld h,(hl)		; $567d
	ld l,a			; $567e
	jp interactionSetScript		; $567f

;;
; Interaction $30, subid $03 runs the shooting gallery game.
; It cycles through states 1-6 a total of 10 times.
; var3f is the round counter.
; @addr{5682}
_shootingGalleryGame:
	ld e,Interaction.state		; $5682
	ld a,(de)		; $5684
	rst_jumpTable			; $5685
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3
	.dw @state4
	.dw @state5
	.dw @state6

@state0:
	ld a,$01		; $5694
	ld (wTmpcfc0.shootingGallery.disableGoronNpcs),a		; $5696

	ld b,$0a		; $5699
	call shootingGallery_initializeGameRounds		; $569b

	; Initialize score
	xor a			; $569e
	ld (wTextNumberSubstitution),a		; $569f
	ld (wTextNumberSubstitution+1),a		; $56a2

	ld e,Interaction.var3f		; $56a5
	ld (de),a		; $56a7
	call interactionIncState		; $56a8

	ld l,Interaction.yh		; $56ab
	ld (hl),$2a		; $56ad
	ld l,Interaction.xh		; $56af
	ld (hl),$50		; $56b1

	ld l,Interaction.counter1		; $56b3
	ld (hl),$78		; $56b5

	ld a,SND_WHISTLE		; $56b7
	call playSound		; $56b9

@state1:
	call interactionDecCounter1		; $56bc
	ret nz			; $56bf

	; These variables will be set by the "ball" object later?
	xor a			; $56c0
	ld (wShootingGalleryBallStatus),a		; $56c1
	ld (wShootingGalleryccd5),a		; $56c4
	ld (wShootingGalleryHitTargets),a		; $56c7

	call interactionIncState		; $56ca

	ld l,Interaction.counter1		; $56cd
	ld (hl),$28		; $56cf
	ld a,SND_BASEBALL		; $56d1
	call playSound		; $56d3

@state2:
	call interactionDecCounter1		; $56d6
	ret nz			; $56d9

	call _shootingGallery_createPuffAtEachTargetPosition		; $56da
	call interactionIncState		; $56dd
	ld l,Interaction.counter1		; $56e0
	ld (hl),$0a		; $56e2
	ret			; $56e4

@state3:
	call interactionDecCounter1		; $56e5
	ret nz			; $56e8

	call _shootingGallery_setRandomTargetLayout		; $56e9
	call interactionIncState		; $56ec
	ld l,Interaction.counter1		; $56ef
	ld (hl),$5a		; $56f1
	ret			; $56f3

@state4:
	call interactionDecCounter1		; $56f4
	ret nz			; $56f7

	call interactionIncState		; $56f8

	; Increment the "round" of the game
	ld l,Interaction.var3f		; $56fb
	inc (hl)		; $56fd

	jp _shootingGallery_createBallHere		; $56fe

@state5:
	ld a,(wShootingGalleryBallStatus)		; $5701
	bit 7,a			; $5704
	ret z			; $5706

; Ball has gone out-of-bounds

	and $7f			; $5707
	jr nz,@hitSomething	; $5709

	ld a,(wTmpcfc0.shootingGallery.isStrike)		; $570b
	or a			; $570e
	jr nz,@strike	; $570f

	; Hit nothing, but not a strike.
	ld a,$14		; $5711
	jr @setScript		; $5713

@strike:
	ld a,$14		; $5715
	call _shootingGallery_addValueToScore		; $5717
	ld a,$15		; $571a
	jr @setScript		; $571c

@hitSomething:
	cp $02			; $571e
	jr z,@hit2Things	; $5720

	ld a,(wShootingGalleryHitTargets)		; $5722
	and $0f			; $5725
	call getHighestSetBit		; $5727
	jr @addValueToScore		; $572a

@hit2Things:
	ld a,(wShootingGalleryHitTargets)		; $572c
	and $0f			; $572f
	call getHighestSetBit		; $5731
	inc a			; $5734
	add a			; $5735
	add a			; $5736
	ld b,a			; $5737
	ld a,(wShootingGalleryHitTargets)		; $5738
	swap a			; $573b
	and $0f			; $573d
	call getHighestSetBit		; $573f
	add b			; $5742

@addValueToScore:
	ldh (<hFF93),a	; $5743
	call _shootingGallery_addValueToScore		; $5745
	ldh a,(<hFF93)	; $5748

@setScript:
	ld hl,_shootingGalleryHitScriptTable		; $574a
	rst_addDoubleIndex			; $574d
	ldi a,(hl)		; $574e
	ld h,(hl)		; $574f
	ld l,a			; $5750
	call interactionSetScript		; $5751
	call interactionIncState		; $5754

	ld l,Interaction.counter1		; $5757
	ld (hl),$28		; $5759
	ld a,$81		; $575b
	ld (wDisabledObjects),a		; $575d
	ld a,$80		; $5760
	ld (wMenuDisabled),a		; $5762

@state6:
	call interactionRunScript		; $5765
	ret nc			; $5768

	; End the game on the tenth round
	ld e,Interaction.var3f		; $5769
	ld a,(de)		; $576b
	cp $0a			; $576c
	jr z,++			; $576e

	ld h,d			; $5770
	ld l,Interaction.state		; $5771
	ld (hl),$01		; $5773
	ld l,Interaction.counter1		; $5775
	ld (hl),$14		; $5777
	ret			; $5779
++
	; Game is over
	ld a,$01		; $577a
	ld (wTmpcfc0.shootingGallery.gameStatus),a		; $577c
	xor a			; $577f
	ld (wTmpcfc0.shootingGallery.disableGoronNpcs),a		; $5780
	jp interactionDelete		; $5783

;;
; Also used by goron dance minigame.
;
; @param	b	Number of rounds
; @addr{5786}
shootingGallery_initializeGameRounds:
	ld hl,wShootingGalleryTileLayoutsToShow		; $5786
	xor a			; $5789
--
	ldi (hl),a		; $578a
	inc a			; $578b
	cp b			; $578c
	jr nz,--		; $578d

	ld (wTmpcfc0.shootingGallery.remainingRounds),a		; $578f
	ret			; $5792

;;
; Randomly choose the next layout to use. This uses a 10-byte buffer; each time a layout
; is picked, that value is removed from the buffer, and the buffer's size decreases by
; one.
;
; @param[out]	wTmpcfc0.shootingGallery.targetLayoutIndex	Index of the layout to use
; @addr{5793}
shootingGallery_getNextTargetLayout:
	ld a,(wTmpcfc0.shootingGallery.remainingRounds)		; $5793
	ld b,a			; $5796
	dec a			; $5797
	ld (wTmpcfc0.shootingGallery.remainingRounds),a		; $5798

	; Get a random number between 0 and b-1
	call getRandomNumber		; $579b
--
	sub b			; $579e
	jr nc,--		; $579f
	add b			; $57a1

	ld c,a			; $57a2
	ld hl,wShootingGalleryTileLayoutsToShow		; $57a3
	rst_addAToHl			; $57a6
	ld a,(hl)		; $57a7
	ld (wTmpcfc0.shootingGallery.targetLayoutIndex),a		; $57a8

	; Now shift the contents of the buffer down so that its total size decreases by
	; one, and the value we just read gets overwritten.
	push de			; $57ab
	ld d,c			; $57ac
	ld e,b			; $57ad
	dec e			; $57ae
	ld b,h			; $57af
	ld c,l			; $57b0
--
	ld a,d			; $57b1
	cp e			; $57b2
	jr z,++			; $57b3
	inc bc			; $57b5
	ld a,(bc)		; $57b6
	ldi (hl),a		; $57b7
	inc d			; $57b8
	jr --			; $57b9
++
	pop de			; $57bb
	ret			; $57bc

;;
; @addr{57bd}
shootingGallery_removeAllTargets:
	ld a,$01		; $57bd
	ld (wTmpcfc0.shootingGallery.useTileIndexData),a		; $57bf
	ld e,Interaction.subid		; $57c2
	ld a,(de)		; $57c4
	sub $01			; $57c5
	jr z,@subid1		; $57c7
	jr nc,@subid2		; $57c9

@subid0:
	ld bc,_shootingGallery_targetPositions_lynna		; $57cb
	jr _shootingGallery_setTiles		; $57ce
@subid1:
	ld bc,_shootingGallery_targetPositions_goron		; $57d0
	jr _shootingGallery_setTiles		; $57d3
@subid2:
	ld bc,_shootingGallery_targetPositions_biggoron		; $57d5
	jr _shootingGallery_setTiles		; $57d8


;;
; Chooses one of the 10 target layouts to use and loads the tiles. (It never uses the same
; layout more than once, though.)
; @addr{57da}
_shootingGallery_setRandomTargetLayout:
	xor a			; $57da
	ld (wTmpcfc0.shootingGallery.useTileIndexData),a		; $57db
	call shootingGallery_getNextTargetLayout		; $57de

	ld a,(wTmpcfc0.shootingGallery.targetLayoutIndex)		; $57e1

	; l = a*5
	ld l,a			; $57e4
	add a			; $57e5
	add a			; $57e6
	add l			; $57e7
	ld l,a			; $57e8

	ld e,Interaction.var03		; $57e9
	ld a,(de)		; $57eb
	sub $01			; $57ec
	ld a,l			; $57ee
	jr z,@goronGallery	; $57ef
	jr nc,@biggoronGallery	; $57f1

@lynnaGallery:
	ld hl,_shootingGallery_targetTiles_lynna		; $57f3
	rst_addDoubleIndex			; $57f6
	ld bc,_shootingGallery_targetPositions_lynna		; $57f7
	jr _shootingGallery_setTiles		; $57fa

@goronGallery:
	ld hl,_shootingGallery_targetTiles_goron		; $57fc
	rst_addDoubleIndex			; $57ff
	ld bc,_shootingGallery_targetPositions_goron		; $5800
	jr _shootingGallery_setTiles		; $5803

@biggoronGallery:
	ld hl,_shootingGallery_targetTiles_biggoron		; $5805
	rst_addDoubleIndex			; $5808
	ld bc,_shootingGallery_targetPositions_biggoron		; $5809

;;
; @param	bc	Pointer to data containing positions of tiles to be replaced.
; @param	hl	Pointer to data containing tile indices for tiles to be replaced.
;			(optional)
; @param	wTmpcfc0.shootingGallery.useTileIndexData
;			If zero, it uses hl to get the tile indices; otherwise, all tiles
;			are replaced with TILEINDEX_STANDARD_FLOOR.
; @addr{580c}
_shootingGallery_setTiles:
	ld a,$0a		; $580c
@nextTile:
	ldh (<hFF92),a	; $580e
	ld a,(bc)		; $5810
	inc bc			; $5811
	push bc			; $5812
	ld c,a			; $5813
	ld a,(wTmpcfc0.shootingGallery.useTileIndexData)		; $5814
	or a			; $5817
	ld a,TILEINDEX_STANDARD_FLOOR		; $5818
	jr nz,+			; $581a
	ldi a,(hl)		; $581c
+
	push hl			; $581d
	call setTile		; $581e
	pop hl			; $5821
	pop bc			; $5822
	ldh a,(<hFF92)	; $5823
	dec a			; $5825
	jr nz,@nextTile	; $5826
	ret			; $5828


; These are the positions of the tiles for the respective shooting gallery games.
_shootingGallery_targetPositions_lynna:
	.db $31 $21 $12 $03 $04 $05 $06 $17 $28 $38

_shootingGallery_targetPositions_goron:
	.db $21 $32 $12 $23 $04 $05 $26 $37 $17 $28

_shootingGallery_targetPositions_biggoron:
	.db $21 $12 $03 $23 $14 $15 $06 $26 $17 $28


; These are the possible layouts of the tiles for the respective shooting gallery games.
; (One layout per line.)
_shootingGallery_targetTiles_lynna:
	.db $d9 $dc $d9 $d9 $dc $d8 $d9 $d9 $dc $d9
	.db $dc $d9 $d9 $d8 $d9 $dc $dc $d9 $dc $d9
	.db $d9 $dc $d9 $dc $d7 $d9 $dc $d9 $d9 $d9
	.db $d9 $d9 $dc $d9 $d8 $d9 $dc $d8 $d9 $d9
	.db $dc $d8 $d9 $d9 $dc $d9 $d9 $dc $d9 $dc
	.db $d9 $d7 $d9 $d9 $d9 $d9 $d7 $d9 $d9 $d9
	.db $dc $dc $d9 $d9 $dc $d9 $d9 $d8 $d9 $d9
	.db $d9 $d9 $dc $d7 $d9 $d8 $d9 $d8 $d9 $d9
	.db $d9 $d9 $dc $d9 $d9 $dc $d9 $d9 $dc $dc
	.db $dc $d9 $d9 $d9 $d8 $d9 $dc $d9 $d9 $d9

_shootingGallery_targetTiles_goron:
	.db $d9 $dc $d9 $d9 $d9 $d8 $d9 $d9 $dc $d9
	.db $dc $d9 $d9 $d8 $d9 $dc $d7 $d9 $dc $d9
	.db $d9 $dc $d9 $dc $d7 $d9 $d9 $dc $d9 $d9
	.db $d9 $d9 $dc $d9 $d8 $d9 $dc $d7 $d9 $d9
	.db $dc $d9 $d9 $d9 $d8 $d9 $d9 $dc $d9 $dc
	.db $d9 $dc $d9 $d9 $d9 $dc $d9 $d7 $d8 $d9
	.db $dc $d9 $d9 $d9 $dc $d9 $d9 $dc $d9 $d9
	.db $d9 $d9 $dc $d7 $d9 $d8 $d9 $d8 $d9 $d9
	.db $d9 $d9 $dc $d9 $d9 $dc $d8 $d9 $dc $d9
	.db $dc $d9 $d9 $dc $d9 $d9 $dc $d9 $d9 $dc

_shootingGallery_targetTiles_biggoron:
	.db $d9 $d9 $dc $d7 $d9 $dc $d9 $d9 $d8 $dc
	.db $d9 $dc $d9 $d9 $d9 $d8 $dc $d9 $d9 $d8
	.db $d9 $d9 $d7 $dc $dc $d9 $dc $d9 $d9 $dc
	.db $d9 $d9 $dc $d9 $d8 $d9 $dc $d7 $d9 $d9
	.db $dc $d9 $d9 $dc $d9 $dc $dc $d9 $d9 $d8
	.db $d9 $dc $d9 $d9 $dc $d7 $dc $d9 $d9 $d9
	.db $d9 $d9 $d8 $d9 $dc $dc $d7 $d9 $d9 $dc
	.db $d9 $dc $d9 $dc $d9 $d8 $d9 $dc $dc $dc
	.db $dc $d9 $dc $d9 $d9 $dc $d9 $d8 $d9 $d7
	.db $d9 $d9 $d7 $d8 $dc $dc $d9 $dc $d9 $d9

;;
; @addr{5973}
_shootingGallery_createPuffAtEachTargetPosition:
	ld e,Interaction.var03		; $5973
	ld a,(de)		; $5975
	sub $01			; $5976
	jr z,@subid1		; $5978
	jr nc,@subid2		; $597a

@subid0:
	ld bc,_shootingGallery_targetPositions_lynna		; $597c
	jr ++			; $597f
@subid1:
	ld bc,_shootingGallery_targetPositions_goron		; $5981
	jr ++			; $5984
@subid2:
	ld bc,_shootingGallery_targetPositions_biggoron		; $5986

++
	ld a,$0a		; $5989
@nextTile:
	ldh (<hFF92),a	; $598b
	call getFreeInteractionSlot		; $598d
	ret nz			; $5990

	ld (hl),INTERACID_PUFF		; $5991
	ld a,(bc)		; $5993
	inc bc			; $5994
	push bc			; $5995
	ld l,Interaction.yh		; $5996
	call setShortPosition		; $5998
	pop bc			; $599b
	ldh a,(<hFF92)	; $599c
	dec a			; $599e
	jr nz,@nextTile		; $599f
	ret			; $59a1

;;
; @addr{59a2}
_shootingGallery_createBallHere:
	call getFreePartSlot		; $59a2
	ret nz			; $59a5
	ld (hl),PARTID_BALL		; $59a6
	jp objectCopyPosition		; $59a8

;;
; @param	a	Index?
; @addr{59ab}
_shootingGallery_addValueToScore:
	ld hl,@scores		; $59ab
	rst_addDoubleIndex			; $59ae
	ld c,(hl)		; $59af
	inc hl			; $59b0
	ld b,(hl)		; $59b1
	ld hl,wTextNumberSubstitution		; $59b2
	bit 0,c			; $59b5
	jr nz,+			; $59b7
	jp addDecimalToHlRef		; $59b9
+
	res 0,c			; $59bc
	jp subDecimalFromHlRef		; $59be


; If the last digit is "1", the score is subtracted instead of added.
@scores:
	.dw $0030 ; $00
	.dw $0100 ; $01
	.dw $0011 ; $02
	.dw $0051 ; $03
	.dw $0060 ; $04
	.dw $0130 ; $05
	.dw $0020 ; $06
	.dw $0021 ; $07
	.dw $0130 ; $08
	.dw $0200 ; $09
	.dw $0090 ; $0a
	.dw $0050 ; $0b
	.dw $0020 ; $0c
	.dw $0090 ; $0d
	.dw $0021 ; $0e
	.dw $0061 ; $0f
	.dw $0021 ; $10
	.dw $0050 ; $11
	.dw $0061 ; $12
	.dw $00a1 ; $13
	.dw $0051 ; $14 (strike)


; Scripts for INTERACID_SHOOTING_GALLERY.

; NPC scripts
_shootingGalleryScriptTable:
	; NPCs waiting to be talked to
	.dw shootingGalleryScript_humanNpc
	.dw shootingGalleryScript_goronNpc
	.dw shootingGalleryScript_goronElderNpc

	; Cleanup after finishing a game
	.dw shootingGalleryScript_humanNpc_gameDone
	.dw shootingGalleryScript_goronNpc_gameDone
	.dw shootingGalleryScript_goronElderNpc_gameDone

	; NPCs ask if you want to play again
	.dw shootingGalleryScript_humanNpc@tryAgain
	.dw shootingGalleryScript_goronNpc@tryAgain
	.dw shootingGalleryScript_goronElderNpc@beginGame


; Scripts to run when tile(s) of the corresponding types are hit.
_shootingGalleryHitScriptTable:
	.dw shootingGalleryScript_hit1Blue        ; $00
	.dw shootingGalleryScript_hit1Fairy       ; $01
	.dw shootingGalleryScript_hit1Red         ; $02
	.dw shootingGalleryScript_hit1Imp         ; $03
	.dw shootingGalleryScript_hit2Blue        ; $04
	.dw shootingGalleryScript_hit1Blue1Fairy  ; $05
	.dw shootingGalleryScript_hit1Red1Blue    ; $06
	.dw shootingGalleryScript_hit1Blue1Imp    ; $07
	.dw shootingGalleryScript_hit1Blue1Fairy  ; $08
	.dw shootingGalleryScript_hit2Blue        ; $09
	.dw shootingGalleryScript_hit1Red1Fairy   ; $0a
	.dw shootingGalleryScript_hit1Fairy1Imp   ; $0b
	.dw shootingGalleryScript_hit1Red1Blue    ; $0c
	.dw shootingGalleryScript_hit1Red1Fairy   ; $0d
	.dw shootingGalleryScript_hit2Red         ; $0e
	.dw shootingGalleryScript_hit1Red1Imp     ; $0f
	.dw shootingGalleryScript_hit1Blue1Imp    ; $10
	.dw shootingGalleryScript_hit1Fairy1Imp   ; $11
	.dw shootingGalleryScript_hit1Red1Imp     ; $12
	.dw shootingGalleryScript_hit2Red         ; $13

	.dw shootingGalleryScript_hitNothing      ; $14
	.dw shootingGalleryScript_strike          ; $15


; ==============================================================================
; INTERACID_IMPA_IN_CUTSCENE
;
; Variables:
;   var3b: For subid 1, saves impa's "oamTileIndexBase" so it can be restored after Impa
;          gets up (she references a different sprite sheet for her "collapsed" sprite)
; ==============================================================================
interactionCode31:
	ld e,Interaction.state		; $5a29
	ld a,(de)		; $5a2b
	rst_jumpTable			; $5a2c
	.dw @state0
	.dw _impaState1

@state0:
	ld a,$01		; $5a31
	ld (de),a		; $5a33
	call interactionInitGraphics		; $5a34
	call objectSetVisiblec2		; $5a37
	call @initSubid		; $5a3a
	ld e,Interaction.enabled		; $5a3d
	ld a,(de)		; $5a3f
	or a			; $5a40
	jp nz,objectMarkSolidPosition		; $5a41
	ret			; $5a44

@initSubid:
	ld e,Interaction.subid		; $5a45
	ld a,(de)		; $5a47
	rst_jumpTable			; $5a48
	.dw @init0
	.dw @init1
	.dw @init2
	.dw @init3
	.dw @init4
	.dw @init5
	.dw @loadScript
	.dw @init7
	.dw @init8
	.dw @init9
	.dw @initA

@init0:
	call getThisRoomFlags	; $5a5f
	bit 6,a			; $5a62
	jp nz,interactionDelete		; $5a64

	; Load a custom palette and use it for possessed impa
	ld a,PALH_97		; $5a67
	call loadPaletteHeader		; $5a69
	ld e,Interaction.oamFlags		; $5a6c
	ld a,$07		; $5a6e
	ld (de),a		; $5a70

	ld hl,objectData.impaOctoroks		; $5a71
	call parseGivenObjectData		; $5a74

	ld a,LINK_STATE_08		; $5a77
	call setLinkIDOverride		; $5a79
	ld l,<w1Link.subid		; $5a7c
	ld (hl),$01		; $5a7e
	jr @loadScript		; $5a80

@init1:
	ld h,d			; $5a82
	ld l,Interaction.oamTileIndexBase		; $5a83
	ld a,(hl)		; $5a85
	ld l,Interaction.var3b		; $5a86
	ld (hl),a	; $5a88

	call _impaLoadCollapsedGraphic		; $5a89

@loadScript:
	ld e,Interaction.subid		; $5a8c
	ld a,(de)		; $5a8e
	ld hl,_impaScriptTable		; $5a8f
	rst_addDoubleIndex			; $5a92
	ldi a,(hl)		; $5a93
	ld h,(hl)		; $5a94
	ld l,a			; $5a95
	jp interactionSetScript		; $5a96

@init2:
	ld h,d			; $5a99
	ld l,Interaction.counter1		; $5a9a
	ld (hl),$1e		; $5a9c
	jp objectSetVisible82		; $5a9e

@init7:
	; Delete self if Zelda hasn't been kidnapped by vire yet, or she's been rescued
	; already, or this isn't a linked game
	ld a,(wEssencesObtained)		; $5aa1
	bit 2,a			; $5aa4
	jp z,interactionDelete		; $5aa6
	call checkIsLinkedGame		; $5aa9
	jp z,interactionDelete		; $5aac
	ld a,GLOBALFLAG_GOT_RING_FROM_ZELDA		; $5aaf
	call checkGlobalFlag		; $5ab1
	jp nz,interactionDelete		; $5ab4

	ld a,GLOBALFLAG_IMPA_MOVED_AFTER_ZELDA_KIDNAPPED		; $5ab7
	call checkGlobalFlag		; $5ab9
	ld a,$09		; $5abc
	jr z,@setAnimationAndLoadScript	; $5abe

	ld e,Interaction.xh		; $5ac0
	ld a,$38		; $5ac2
	ld (de),a		; $5ac4

	ld a,GLOBALFLAG_ZELDA_SAVED_FROM_VIRE		; $5ac5
	call checkGlobalFlag		; $5ac7
	ld a,$02		; $5aca
	jr z,@setAnimationAndLoadScript	; $5acc

	ld a,$48		; $5ace
	ld (de),a ; [xh] = $48
	ld e,Interaction.yh		; $5ad1
	ld a,$58		; $5ad3
	ld (de),a ; [yh] = $58		; $5ad5

	ld a,$81		; $5ad6
	ld (wMenuDisabled),a		; $5ad8
	ld (wDisabledObjects),a		; $5adb
	ld a,$00		; $5ade
	ld (wScrollMode),a		; $5ae0
	ld hl,$cfd0		; $5ae3
	ld b,$10		; $5ae6
	call clearMemory		; $5ae8

	ldbc INTERACID_ZELDA, $06		; $5aeb
	call objectCreateInteraction		; $5aee
	ld l,Interaction.yh		; $5af1
	ld (hl),$8c		; $5af3
	ld l,Interaction.xh		; $5af5
	ld (hl),$50		; $5af7

	ld a,$02		; $5af9
	jr @setAnimationAndLoadScript		; $5afb

@init3:
	ld a,$03		; $5afd

@setAnimationAndLoadScript:
	call interactionSetAnimation		; $5aff
	call objectSetVisible82		; $5b02
	jr @loadScript		; $5b05

@init4:
	call checkIsLinkedGame		; $5b07
	jp nz,interactionDelete		; $5b0a
	xor a			; $5b0d
	ld ($cfc0),a		; $5b0e

@preBlackTowerCutscene:
	ld a,TREASURE_MAKU_SEED		; $5b11
	call checkTreasureObtained		; $5b13
	jp nc,interactionDelete		; $5b16
	ld a,GLOBALFLAG_PRE_BLACK_TOWER_CUTSCENE_DONE		; $5b19
	call checkGlobalFlag		; $5b1b
	jp nz,interactionDelete		; $5b1e
	jp @loadScript		; $5b21

@init5:
	call checkIsLinkedGame		; $5b24
	jp z,interactionDelete		; $5b27
	ld a,$03		; $5b2a
	call interactionSetAnimation		; $5b2c
	jr @preBlackTowerCutscene		; $5b2f

@initA:
	ld a,$02		; $5b31
	jp interactionSetAnimation		; $5b33

@init9:
	call checkIsLinkedGame		; $5b36
	jp z,interactionDelete		; $5b39

@init8:
	ld a,$03		; $5b3c
	call interactionSetAnimation		; $5b3e
	call @loadScript		; $5b41

_impaState1:
	ld e,Interaction.subid		; $5b44
	ld a,(de)		; $5b46
	rst_jumpTable			; $5b47
	.dw _impaSubid0
	.dw _impaSubid1
	.dw _impaSubid2
	.dw _impaAnimateAndRunScript
	.dw _impaSubid4
	.dw _impaSubid5
	.dw _impaAnimateAndRunScript
	.dw _impaSubid7
	.dw _impaSubid8
	.dw _impaSubid9
	.dw interactionAnimate

;;
; Possessed Impa.
;
; Variables:
;   var37-var3a: Last frame's Y, X, and Direction values. Used for checking whether to
;                update Impa's animation (update if any one has changed).
; @addr{5b5e}
_impaSubid0:
	ld e,Interaction.state2		; $5b5e
	ld a,(de)		; $5b60
	cp $0e			; $5b61
	jr nc,+			; $5b63

	ld hl,wActiveMusic		; $5b65
	ld a,MUS_FAIRY		; $5b68
	cp (hl)			; $5b6a
	jr z,+			; $5b6b

	ld a,(wActiveRoom)		; $5b6d
	cp $39			; $5b70
	jr z,+			; $5b72
	cp $49			; $5b74
	jr z,+			; $5b76

	ld a,MUS_FAIRY		; $5b78
	ld (hl),a		; $5b7a
	call playSound		; $5b7b
	ld a,$03		; $5b7e
	call setMusicVolume		; $5b80

	ld e,Interaction.state2		; $5b83
+
	ld a,(de)		; $5b85
	rst_jumpTable			; $5b86
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3
	.dw @substate4
	.dw @substate5
	.dw @substate6
	.dw @substate7
	.dw @substate8
	.dw @substate9
	.dw @substateA
	.dw @substateB
	.dw @substateC
	.dw @substateD
	.dw @substateE
	.dw @substateF
	.dw _impaRet


; Running a script until Impa joins Link
@substate0:
	call _impaAnimateAndRunScript		; $5ba9
	ret nc			; $5bac

; When the script has finished, make Impa follow Link and go to substate 1

	xor a			; $5bad
	ld (wUseSimulatedInput),a		; $5bae
	call setLinkIDOverride		; $5bb1
	ld l,<w1Link.direction		; $5bb4
	ld (hl),DIR_UP		; $5bb6

@beginFollowingLink:
	call interactionIncState2		; $5bb8
	call makeActiveObjectFollowLink		; $5bbb
	call interactionSetAlwaysUpdateBit		; $5bbe
	call objectSetReservedBit1		; $5bc1

	ld l,Interaction.var37		; $5bc4
	ld e,Interaction.yh		; $5bc6
	ld a,(de)		; $5bc8
	ldi (hl),a		; $5bc9
	ld e,Interaction.xh		; $5bca
	ld a,(de)		; $5bcc
	ldi (hl),a		; $5bcd
	ld e,Interaction.direction		; $5bce
	ld a,(w1Link.direction)		; $5bd0
	ld (de),a		; $5bd3
	ld (hl),$00		; $5bd4

	call interactionSetAnimation		; $5bd6
	call objectSetVisiblec3		; $5bd9
	jp objectSetPriorityRelativeToLink_withTerrainEffects		; $5bdc

; Impa following Link (before stone is pushed)
@substate1:
	call objectSetPriorityRelativeToLink_withTerrainEffects		; $5bdf
	call _impaCheckApproachedStone		; $5be2
	jr nc,@updateAnimationWhileFollowingLink	; $5be5

; Link has approached the stone; trigger cutscene.

	ld a,LINK_STATE_08		; $5be7
	call setLinkIDOverride		; $5be9
	ld l,<w1Link.subid		; $5bec
	ld (hl),$02		; $5bee

	call interactionIncState2		; $5bf0
	ld l,Interaction.counter1		; $5bf3
	ld (hl),$1e		; $5bf5
	ld l,Interaction.enabled		; $5bf7
	res 7,(hl)		; $5bf9

	ld a,SND_CLINK		; $5bfb
	call playSound		; $5bfd

	ld bc,-$1c0		; $5c00
	call objectSetSpeedZ		; $5c03
	call clearFollowingLinkObject		; $5c06
	call @setAngleTowardStone		; $5c09
	call convertAngleDeToDirection		; $5c0c
	jp interactionSetAnimation		; $5c0f

@updateAnimationWhileFollowingLink:
	; Nothing to do here except check whether to update the animation. (It must update
	; if her position or direction has changed.)
	call _impaUpdateAnimationIfDirectionChanged		; $5c12
	ld h,d			; $5c15
	ld l,Interaction.yh		; $5c16
	ld a,(hl)		; $5c18
	ld b,a			; $5c19
	ld l,Interaction.var37		; $5c1a
	cp (hl)			; $5c1c
	jr nz,++		; $5c1d

	ld l,Interaction.xh		; $5c1f
	ld a,(hl)		; $5c21
	ld c,a			; $5c22
	ld l,Interaction.var38		; $5c23
	cp (hl)			; $5c25
	ret z			; $5c26
++
	ld l,Interaction.var37		; $5c27
	ld (hl),b		; $5c29
	inc l			; $5c2a
	ld (hl),c		; $5c2b
	call interactionAnimate		; $5c2c
	jp interactionAnimate		; $5c2f

;;
; @addr{5c32}
@setAngleTowardStone:
	ldbc $38,$38		; $5c32
	call objectGetRelativeAngle		; $5c35
	ld e,Interaction.angle		; $5c38
	ld (de),a		; $5c3a
	ret			; $5c3b

; Jumping after spotting stone
@substate2:
	call _impaAnimateAndDecCounter1		; $5c3c
	ret nz			; $5c3f

	; Wait until she lands
	ld c,$20		; $5c40
	call objectUpdateSpeedZ_paramC		; $5c42
	ret nz			; $5c45

	call interactionIncState2		; $5c46
	ld l,Interaction.counter1		; $5c49
	ld (hl),$0a		; $5c4b
	ret			; $5c4d

@substate3:
	call _impaAnimateAndDecCounter1		; $5c4e
	ret nz			; $5c51

	ld (hl),$14		; $5c52

	ld bc,TX_0104		; $5c54
	call showText		; $5c57
	jp interactionIncState2		; $5c5a

@substate4:
	call interactionDecCounter1IfTextNotActive		; $5c5d
	ret nz			; $5c60

	ld l,Interaction.speed		; $5c61
	ld (hl),SPEED_300		; $5c63
	jp interactionIncState2		; $5c65

; Moving toward stone
@substate5:
	call interactionAnimate3Times		; $5c68
	call objectApplySpeed		; $5c6b
	call @setAngleTowardStone		; $5c6e

	ld a,$02		; $5c71
	ldh (<hFF8B),a	; $5c73
	ldbc $38,$38		; $5c75
	ld h,d			; $5c78
	ld l,Interaction.yh		; $5c79
	call checkObjectIsCloseToPosition		; $5c7b
	ret nc			; $5c7e

; Reached the stone

	ld h,d			; $5c7f
	call interactionIncState2		; $5c80
	ld a,$38		; $5c83
	ld l,Interaction.yh		; $5c85
	ldi (hl),a		; $5c87
	inc l			; $5c88
	ld (hl),a		; $5c89
	ld l,Interaction.counter1		; $5c8a
	ld (hl),$1e		; $5c8c
	xor a			; $5c8e
	jp interactionSetAnimation		; $5c8f

@substate6:
	call _impaAnimateAndDecCounter1		; $5c92
	ret nz			; $5c95

	; Start a jump
	ld (hl),$1e		; $5c96
	ld bc,-$180		; $5c98
	call objectSetSpeedZ		; $5c9b
	jp interactionIncState2		; $5c9e

; Jumping in front of stone
@substate7:
	call _impaAnimateAndDecCounter1		; $5ca1
	ret nz			; $5ca4

	ld c,$20		; $5ca5
	call objectUpdateSpeedZ_paramC		; $5ca7
	ret nz			; $5caa

	call interactionIncState2		; $5cab
	ld l,Interaction.counter1		; $5cae
	ld (hl),$0a		; $5cb0
	ret			; $5cb2

@substate8:
	call interactionDecCounter1		; $5cb3
	ret nz			; $5cb6

	ld (hl),$1e		; $5cb7
	call interactionIncState2		; $5cb9
	ld bc,TX_0105		; $5cbc
	jp showText		; $5cbf

@substate9:
	call interactionDecCounter1IfTextNotActive		; $5cc2
	ret nz			; $5cc5

	ld hl,$cfd0		; $5cc6
	ld (hl),$02		; $5cc9
	ld hl,impaScript_moveAwayFromRock		; $5ccb
	call interactionSetScript		; $5cce
	jp interactionIncState2		; $5cd1

; Moving away from rock (the previously loaded script handles this)
@substateA:
	call _impaAnimateAndRunScript		; $5cd4
	ret nc			; $5cd7

; Done moving away; return control to Link

	xor a			; $5cd8
	call setLinkIDOverride		; $5cd9
	ld l,<w1Link.direction		; $5cdc
	ld (hl),DIR_UP		; $5cde
	ld hl,impaScript_waitForRockToBeMoved		; $5ce0
	call interactionSetScript		; $5ce3
	jp interactionIncState2		; $5ce6

; Waiting for Link to start pushing the rock
@substateB:
	call interactionAnimateAsNpc		; $5ce9
	call interactionRunScript		; $5cec
	call _impaPreventLinkFromLeavingStoneScreen		; $5cef
	ld a,($cfd0)		; $5cf2
	cp $06			; $5cf5
	ret nz			; $5cf7

; The rock has started moving.

	ld hl,impaScript_rockJustMoved		; $5cf8
	call interactionSetScript		; $5cfb
	jp interactionIncState2		; $5cfe

@substateC:
	call _impaAnimateAndRunScript		; $5d01
	ret nc			; $5d04
	xor a			; $5d05
	call setLinkIDOverride		; $5d06
	ld l,<w1Link.direction		; $5d09
	ld (hl),DIR_DOWN		; $5d0b
	jp @beginFollowingLink		; $5d0d

; Following Link, waiting for signal to begin the part of the cutscene where she reveals
; she's evil
@substateD:
	call objectSetPriorityRelativeToLink_withTerrainEffects		; $5d10
	ld a,($cfd0)		; $5d13
	cp $09			; $5d16
	jp nz,@updateAnimationWhileFollowingLink		; $5d18

	; Start the next part of the cutscene
	call interactionIncState2		; $5d1b
	call clearFollowingLinkObject		; $5d1e
	ldbc $68,$38		; $5d21
	call interactionSetPosition		; $5d24
	ld hl,impaScript_revealPossession		; $5d27
	jp interactionSetScript		; $5d2a

@substateE:
	call _impaAnimateAndRunScript		; $5d2d
	ret nc			; $5d30

; Impa has just moved into the corner, Veran will now come out.

	call interactionIncState2		; $5d31
	ld l,Interaction.oamFlags		; $5d34
	ld (hl),$02		; $5d36
	ld a,$05		; $5d38
	call interactionSetAnimation		; $5d3a

	ld b,INTERACID_GHOST_VERAN		; $5d3d
	call objectCreateInteractionWithSubid00		; $5d3f

	ld a,SND_BOSS_DEAD		; $5d42
	call playSound		; $5d44
	jp objectSetVisiblec2		; $5d47

@substateF:
	call interactionAnimate		; $5d4a
	ld h,d			; $5d4d
	ld l,Interaction.animParameter		; $5d4e
	ld a,(hl)		; $5d50
	or a			; $5d51
	ret nz			; $5d52
	call interactionIncState2		; $5d53

;;
; Changes impa's "oamTileIndexBase" to reference her "collapsed" graphic, which is not in
; her normal sprite sheet.
; @addr{5d56}
_impaLoadCollapsedGraphic:
	ld l,Interaction.oamFlags		; $5d56
	ld (hl),$0a		; $5d58
	ld l,Interaction.oamTileIndexBase		; $5d5a
	ld (hl),$60		; $5d5c

_impaRet:
	ret			; $5d5e


;;
; Impa talking to you after Nayru is kidnapped
; @addr{5d5f}
_impaSubid1:
	ld e,Interaction.state2		; $5d5f
	ld a,(de)		; $5d61
	rst_jumpTable			; $5d62
	.dw @substate0
	.dw @substate1
	.dw _impaSubid1Substate2

@substate0:
	ld a,($cfd0)		; $5d69
	cp $20			; $5d6c
	jp nz,interactionAnimate		; $5d6e

	call interactionIncState2		; $5d71
	ld e,Interaction.xh		; $5d74
	ld a,(de)		; $5d76
	ld l,Interaction.var3d		; $5d77
	ld (hl),a		; $5d79
	ld l,Interaction.counter1		; $5d7a
	ld (hl),$3c		; $5d7c
	ret			; $5d7e

@substate1:
	call interactionDecCounter1		; $5d7f
	jr nz,interactionOscillateXRandomly	; $5d82
	jp interactionIncState2		; $5d84

;;
; Uses var3d as the interaction's "base" position, and randomly shifts this position left
; by one or not at all.
; @addr{5d87}
interactionOscillateXRandomly:
	call getRandomNumber		; $5d87
	and $01			; $5d8a
	sub $01			; $5d8c
	ld h,d			; $5d8e
	ld l,Interaction.var3d		; $5d8f
	add (hl)		; $5d91
	ld l,Interaction.xh		; $5d92
	ld (hl),a		; $5d94
	ret			; $5d95

_impaSubid1Substate2:
	call interactionRunScript		; $5d96
	jp c,interactionDelete		; $5d99
	ld e,Interaction.counter2		; $5d9c
	ld a,(de)		; $5d9e
	or a			; $5d9f
	jp nz,interactionAnimate2Times		; $5da0
	jp interactionAnimate		; $5da3

;;
; Impa in the credits cutscene
; @addr{5da6}
_impaSubid2:
	ld e,Interaction.state2		; $5da6
	ld a,(de)		; $5da8
	rst_jumpTable			; $5da9
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw _impaAnimateAndRunScript
	.dw _impaSubid2Substate4
	.dw _impaSubid2Substate5
	.dw _impaSubid2Substate6
	.dw _impaSubid2Substate7

@substate0:
	call interactionDecCounter1IfPaletteNotFading		; $5dba
	ret nz			; $5dbd
	ld (hl),$3c		; $5dbe
	call interactionIncState2		; $5dc0
	ld a,$50		; $5dc3
	ld bc,$6050		; $5dc5
	jp createEnergySwirlGoingIn		; $5dc8

@substate1:
	call interactionDecCounter1		; $5dcb
	ret nz			; $5dce
	ld hl,wTmpcbb3		; $5dcf
	xor a			; $5dd2
	ld (hl),a		; $5dd3
	dec a			; $5dd4
	ld (wTmpcbba),a		; $5dd5
	jp interactionIncState2		; $5dd8

@substate2:
	ld hl,wTmpcbb3		; $5ddb
	ld b,$02		; $5dde
	call flashScreen		; $5de0
	ret z			; $5de3

	call interactionIncState2		; $5de4
	call interactionCode31@loadScript		; $5de7
	ld a,$01		; $5dea
	ld ($cfc0),a		; $5dec
	jp fadeinFromWhite		; $5def

;;
; @addr{5df2}
_impaAnimateAndRunScript:
	call interactionAnimateBasedOnSpeed		; $5df2
	jp interactionRunScript		; $5df5


_impaSubid2Substate4:
	ld h,d			; $5df8
	ld l,Interaction.var38		; $5df9
	dec (hl)		; $5dfb
	ret nz			; $5dfc
	call interactionIncState2		; $5dfd
	ld l,Interaction.counter1		; $5e00
	ld (hl),$02		; $5e02

_impaSetVisibleAndJump:
	call objectSetVisiblec2		; $5e04
	ld bc,-$180		; $5e07
	jp objectSetSpeedZ		; $5e0a

_impaSubid2Substate5:
	ld c,$20		; $5e0d
	call objectUpdateSpeedZ_paramC		; $5e0f
	ret nz			; $5e12

	call interactionDecCounter1		; $5e13
	jr nz,_impaSetVisibleAndJump	; $5e16

	call objectSetVisible82		; $5e18
	ld h,d			; $5e1b
	ld l,Interaction.var38		; $5e1c
	ld (hl),$10		; $5e1e
	jp interactionIncState2		; $5e20

_impaSubid2Substate6:
	ld h,d			; $5e23
	ld l,Interaction.var38		; $5e24
	dec (hl)		; $5e26
	ret nz			; $5e27

	ld (hl),$10		; $5e28

	ld l,Interaction.counter2		; $5e2a
	ld a,(hl)		; $5e2c
	inc (hl)		; $5e2d
	cp $02			; $5e2e
	jr z,@nextState		; $5e30
	or a			; $5e32
	ld a,$03		; $5e33
	jr z,+			; $5e35
	xor $02			; $5e37
+
	ld l,Interaction.state2		; $5e39
	dec (hl)		; $5e3b
	dec (hl)		; $5e3c
	jp interactionSetAnimation		; $5e3d

@nextState:
	ld (hl),$00		; $5e40
	ld a,$02		; $5e42
	ld ($cfc0),a		; $5e44
	jp interactionIncState2		; $5e47

_impaSubid2Substate7:
	call _impaAnimateAndRunScript		; $5e4a
	ld a,($cfc0)		; $5e4d
	cp $03			; $5e50
	ret c			; $5e52
	jpab scriptHlp.turnToFaceSomething		; $5e53

;;
; Impa tells you about Ralph's heritage (unlinked)
; @addr{5e5b}
_impaSubid4:
	call checkInteractionState2		; $5e5b
	jr nz,@substate1	; $5e5e

@substate0:
	; Wait for Link to move a certain distance down
	ld hl,w1Link.yh		; $5e60
	ldi a,(hl)		; $5e63
	cp $60			; $5e64
	ret c			; $5e66

	ld l,<w1Link.zh		; $5e67
	bit 7,(hl)		; $5e69
	ret nz			; $5e6b
	call checkLinkCollisionsEnabled		; $5e6c
	ret nc			; $5e6f

	call resetLinkInvincibility		; $5e70
	call setLinkForceStateToState08		; $5e73
	inc a			; $5e76
	ld (wDisabledObjects),a		; $5e77
	ld (wMenuDisabled),a		; $5e7a
	jp interactionIncState2		; $5e7d

@substate1:
	ld c,$20		; $5e80
	call objectUpdateSpeedZ_paramC		; $5e82
	ret nz			; $5e85
	call interactionRunScript		; $5e86
	jp c,interactionDelete		; $5e89
	call interactionAnimateBasedOnSpeed		; $5e8c
	ld e,Interaction.var38		; $5e8f
	ld a,(de)		; $5e91
	rst_jumpTable			; $5e92
	.dw @thing0
	.dw @thing1
	.dw @thing2
	.dw @thing3
	.dw @thing4

@thing0:
	ld a,($cfc0)		; $5e9d
	rrca			; $5ea0
	ret nc			; $5ea1
	ld e,Interaction.var39		; $5ea2
	ld a,$10		; $5ea4
	ld (de),a		; $5ea6
	jr @incVar38		; $5ea7

; Move Link horizontally toward Impa
@thing1:
	ld h,d			; $5ea9
	ld l,Interaction.var39		; $5eaa
	dec (hl)		; $5eac
	ret nz			; $5ead

	ld a,(w1Link.xh)		; $5eae
	sub $50			; $5eb1
	ld b,a			; $5eb3
	add $02			; $5eb4
	cp $05			; $5eb6
	jr c,@incVar38	; $5eb8

	ld a,b			; $5eba
	bit 7,a			; $5ebb
	ld b,$18		; $5ebd
	jr z,+			; $5ebf

	ld b,$08		; $5ec1
	cpl			; $5ec3
	inc a			; $5ec4
+
	ld (wLinkStateParameter),a		; $5ec5
	ld a,LINK_STATE_FORCE_MOVEMENT		; $5ec8
	ld (wLinkForceState),a		; $5eca

	ld hl,w1Link.angle		; $5ecd
	ld a,b			; $5ed0
	ldd (hl),a		; $5ed1
	swap a			; $5ed2
	rlca			; $5ed4
	ld (hl),a		; $5ed5

@incVar38:
	ld h,d			; $5ed6
	ld l,$78		; $5ed7
	inc (hl)		; $5ed9
	ret			; $5eda

; Move Link vertically toward Impa
@thing2:
	ld a,(w1Link.state)		; $5edb
	cp LINK_STATE_FORCE_MOVEMENT			; $5ede
	ret z			; $5ee0

	ld a,(w1Link.yh)		; $5ee1
	sub $48			; $5ee4
	ld (wLinkStateParameter),a		; $5ee6
	xor a			; $5ee9
	ld hl,w1Link.direction		; $5eea
	ldi (hl),a		; $5eed
	ld (hl),a		; $5eee
	ld a,LINK_STATE_FORCE_MOVEMENT		; $5eef
	ld (wLinkForceState),a		; $5ef1
	jp @incVar38		; $5ef4

@thing3:
	ld a,(w1Link.state)		; $5ef7
	cp LINK_STATE_FORCE_MOVEMENT			; $5efa
	ret z			; $5efc
	call setLinkForceStateToState08		; $5efd
	jp @incVar38		; $5f00

@thing4:
	ret			; $5f03

;;
; Like above (explaining ralph's heritage), but for linked game
; @addr{5f04}
_impaSubid5:
	ld c,$20		; $5f04
	call objectUpdateSpeedZ_paramC		; $5f06
	ret nz			; $5f09
	call interactionRunScript		; $5f0a
	jr nc,++		; $5f0d

	; Script over
	xor a			; $5f0f
	ld (wDisabledObjects),a		; $5f10
	ld (wMenuDisabled),a		; $5f13
	ld a,GLOBALFLAG_PRE_BLACK_TOWER_CUTSCENE_DONE		; $5f16
	call setGlobalFlag		; $5f18
	jp interactionDelete		; $5f1b
++
	call interactionAnimateBasedOnSpeed		; $5f1e
	ld e,Interaction.state2		; $5f21
	ld a,(de)		; $5f23
	rst_jumpTable			; $5f24
	.dw @substate0
	.dw @substate1
	.dw @substate2

@substate0:
	ld a,($cfd0)		; $5f2b
	cp $04			; $5f2e
	ret nz			; $5f30

	ld a,$29		; $5f31
	ld (wLinkStateParameter),a		; $5f33
	ld a,LINK_STATE_FORCE_MOVEMENT		; $5f36
	ld (wLinkForceState),a		; $5f38
	ld a,$10		; $5f3b
	ld (w1Link.angle),a		; $5f3d
	jp interactionIncState2		; $5f40

@substate1:
	ld a,(w1Link.state)		; $5f43
	cp LINK_STATE_FORCE_MOVEMENT			; $5f46
	ret z			; $5f48
	call setLinkForceStateToState08		; $5f49
	jp interactionIncState2		; $5f4c

@substate2:
	ret			; $5f4f

;;
; Impa tells you that zelda's been kidnapped by Vire
; @addr{5f50}
_impaSubid7:
	ld c,$20		; $5f50
	call objectUpdateSpeedZ_paramC		; $5f52
	call interactionRunScript		; $5f55
	jp c,interactionDelete		; $5f58

	ld a,GLOBALFLAG_IMPA_MOVED_AFTER_ZELDA_KIDNAPPED		; $5f5b
	call checkGlobalFlag		; $5f5d
	jp z,interactionAnimateAsNpc		; $5f60

	ld a,GLOBALFLAG_ZELDA_SAVED_FROM_VIRE		; $5f63
	call checkGlobalFlag		; $5f65
	jp nz,interactionAnimate		; $5f68
	jp npcFaceLinkAndAnimate		; $5f6b

;;
; @addr{5f6e}
_impaSubid8:
	call _impaAnimateAndRunScript		; $5f6e
	jp c,interactionDelete		; $5f71
	ret			; $5f74

;;
; Impa tells you that Zelda's been kidnapped by Twinrova
; @addr{5f75}
_impaSubid9:
	ld e,Interaction.var38		; $5f75
	ld a,(de)		; $5f77
	or a			; $5f78
	jr z,++			; $5f79
	callab scriptHlp.objectWritePositionTocfd5		; $5f7b
++
	jp _impaAnimateAndRunScript		; $5f83

;;
; Checks that an object is within [hFF8B] pixels of a position on both axes.
;
; @param	bc	Target position
; @param	hl	Object's Y position
; @param	hFF8B	Range we must be within on each axis
; @param[out]	cflag	c if the object is within [hFF8B] pixels of the position
; @addr{5f86}
checkObjectIsCloseToPosition:
	push hl			; $5f86
	call @checkComponent		; $5f87
	pop hl			; $5f8a
	ret nc			; $5f8b

	inc l			; $5f8c
	inc l			; $5f8d
	ld b,c			; $5f8e

;;
; @param	b	Position
; @param	hl	Object position component
; @param	hFF8B
; @param[out]	cflag	Set if we're within [hFF8B] pixels of 'b'.
; @addr{5f8f}
@checkComponent:
	ld a,b			; $5f8f
	sub (hl)		; $5f90
	ld hl,hFF8B		; $5f91
	ld b,(hl)		; $5f94
	add b			; $5f95
	ldh (<hFF8D),a	; $5f96

	ld a,b			; $5f98
	add a			; $5f99
	ld b,a			; $5f9a
	inc b			; $5f9b
	ldh a,(<hFF8D)	; $5f9c
	cp b			; $5f9e
	ret			; $5f9f

;;
; @addr{5fa0}
_impaUpdateAnimationIfDirectionChanged:
	ld h,d			; $5fa0
	ld l,Interaction.direction		; $5fa1
	ld a,(hl)		; $5fa3
	ld l,Interaction.var39		; $5fa4
	cp (hl)			; $5fa6
	ret z			; $5fa7
	ld (hl),a		; $5fa8
	jp interactionSetAnimation		; $5fa9

;;
; @param[out]	cflag	c if Link has approached the stone to trigger Impa's reaction
; @addr{5fac}
_impaCheckApproachedStone:
	ld a,(wActiveRoom)		; $5fac
	cp $59			; $5faf
	jr nz,@notClose		; $5fb1

	ld a,(wScrollMode)		; $5fb3
	and $01			; $5fb6
	ret z			; $5fb8

	ld hl,w1Link.yh		; $5fb9
	ldi a,(hl)		; $5fbc
	cp $58			; $5fbd
	jr nc,@notClose		; $5fbf
	inc l			; $5fc1
	ld a,(hl)		; $5fc2
	cp $78			; $5fc3
	ret			; $5fc5
@notClose:
	xor a			; $5fc6
	ret			; $5fc7

;;
; @param[out]	zflag	z if counter1 has reached 0.
; @addr{5fc8}
_impaAnimateAndDecCounter1:
	ld h,d			; $5fc8
	ld l,Interaction.counter1		; $5fc9
	ld a,(hl)		; $5fcb
	or a			; $5fcc
	ret z			; $5fcd
	dec (hl)		; $5fce
	call interactionAnimate		; $5fcf
	or $01			; $5fd2
	ret			; $5fd4

;;
; Shows text if Link tries to leave the screen with the stone.
; @addr{5fd5}
_impaPreventLinkFromLeavingStoneScreen:
	ld hl,w1Link.yh		; $5fd5
	ld a,(hl)		; $5fd8
	ld b,$76		; $5fd9
	cp b			; $5fdb
	jr c,++			; $5fdc
	ld a,(wKeysPressed)		; $5fde
	and BTN_DOWN			; $5fe1
	jr nz,@showText		; $5fe3
++
	ld l,<w1Link.xh		; $5fe5
	ld a,(hl)		; $5fe7
	ld b,$96		; $5fe8
	cp b			; $5fea
	ret c			; $5feb
	ld a,(wKeysPressed)		; $5fec
	and BTN_RIGHT			; $5fef
	ret z			; $5ff1
@showText:
	ld (hl),b		; $5ff2
	ld bc,TX_010a		; $5ff3
	jp showText		; $5ff6

; @addr{5ff9}
_impaScriptTable:
	.dw impaScript0
	.dw impaScript1
	.dw impaScript2
	.dw impaScript3
	.dw impaScript4
	.dw impaScript5
	.dw impaScript6
	.dw impaScript7
	.dw impaScript8
	.dw impaScript9


; ==============================================================================
; INTERACID_FAKE_OCTOROK
; ==============================================================================
interactionCode32:
	ld e,Interaction.state		; $600d
	ld a,(de)		; $600f
	rst_jumpTable			; $6010
	.dw @state0
	.dw @state1

@state0:
	ld a,$01		; $6015
	ld (de),a		; $6017
	call interactionInitGraphics		; $6018
	ld e,Interaction.subid		; $601b
	ld a,(de)		; $601d
	rst_jumpTable			; $601e
	.dw @init0
	.dw @init1
	.dw @init2

@init0:
	call getThisRoomFlags		; $6025
	bit 6,a			; $6028
	jp nz,interactionDelete		; $602a
	call objectSetVisible82		; $602d

	ld e,Interaction.var03		; $6030
	ld a,(de)		; $6032
	ld b,a			; $6033
	ld hl,_impaOctorokScriptTable		; $6034
	rst_addDoubleIndex			; $6037
	ldi a,(hl)		; $6038
	ld h,(hl)		; $6039
	ld l,a			; $603a
	call interactionSetScript		; $603b
	ld a,b			; $603e
	ld hl,@animations		; $603f
	rst_addAToHl			; $6042
	ld a,(hl)		; $6043
	jp interactionSetAnimation		; $6044

; Each animation faces a different direction.
@animations:
	.db $02 $01 $03

@init2:
	ld a,GLOBALFLAG_WATER_POLLUTION_FIXED		; $604a
	call checkGlobalFlag	; $604c
	jr z,++			; $604f
	ld a,ENEMYID_GREAT_FAIRY		; $6051
	call getFreeEnemySlot		; $6053
	ld (hl),ENEMYID_GREAT_FAIRY		; $6056
	call objectCopyPosition		; $6058
	jp interactionDelete		; $605b
++
	ld bc,-$80		; $605e
	call objectSetSpeedZ		; $6061
	ld a,>TX_4100		; $6064
	call interactionSetHighTextIndex		; $6066
	ld hl,greatFairyOctorokScript		; $6069
	jr @init1		; $606c

@init1:
	call interactionSetScript		; $606e
	call objectSetVisiblec0		; $6071

@state1:
	ld e,Interaction.subid		; $6074
	ld a,(de)		; $6076
	rst_jumpTable			; $6077
	.dw _impaOctorokCode
	.dw _greatFairyOctorokCode
	.dw _greatFairyOctorokCode

_impaOctorokCode:
	call interactionAnimate		; $607e
	ld e,Interaction.state2		; $6081
	ld a,(de)		; $6083
	rst_jumpTable			; $6084
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3

@substate0:
	ld a,($cfd0)		; $608d
	cp $01			; $6090
	ret nz			; $6092
	call interactionIncState2		; $6093
	ld l,Interaction.counter1		; $6096
	ld (hl),$14		; $6098
	ret			; $609a

@substate1:
	call interactionDecCounter1		; $609b
	ret nz			; $609e
	call interactionIncState2		; $609f
	ld l,Interaction.speed		; $60a2
	ld (hl),SPEED_300		; $60a4

	ld l,Interaction.var03		; $60a6
	ld a,(hl)		; $60a8
	ld bc,@countersAndAngles		; $60a9
	call addDoubleIndexToBc		; $60ac
	ld a,(bc)		; $60af
	ld l,Interaction.counter1		; $60b0
	ld (hl),a		; $60b2
	inc bc			; $60b3
	ld a,(bc)		; $60b4
	ld l,Interaction.angle		; $60b5
	ld (hl),a		; $60b7
	swap a			; $60b8
	rlca			; $60ba
	jp interactionSetAnimation		; $60bb

@countersAndAngles:
	.db $50 $00
	.db $3c $18
	.db $5a $00

@substate2:
	call interactionAnimate2Times		; $60c4
	call interactionDecCounter1		; $60c7
	ret nz			; $60ca
	ld a,SND_THROW		; $60cb
	call playSound		; $60cd
	jp interactionIncState2		; $60d0

@substate3:
	call objectCheckWithinScreenBoundary		; $60d3
	jp nc,interactionDelete		; $60d6
	call interactionAnimate2Times		; $60d9
	jp objectApplySpeed		; $60dc


_impaOctorokScriptTable: ; These scripts do nothing
	.dw impaOctorokScript
	.dw impaOctorokScript
	.dw impaOctorokScript


_greatFairyOctorokCode:
	call npcFaceLinkAndAnimate		; $60e5
	call interactionRunScript		; $60e8
	ret nc			; $60eb

; Script over; just used fairy powder.

	xor a			; $60ec
	call objectUpdateSpeedZ		; $60ed
	ld e,Interaction.zh		; $60f0
	ld a,(de)		; $60f2
	cp $f0			; $60f3
	ret nz			; $60f5

	ldbc INTERACID_GREAT_FAIRY, $01		; $60f6
	call objectCreateInteraction		; $60f9
	ld a,TREASURE_FAIRY_POWDER		; $60fc
	call loseTreasure		; $60fe
	jp interactionDelete		; $6101


; ==============================================================================
; INTERACID_SMOG_BOSS
;
; Variables:
;   subid:    The index of the last enemy spawned. Incremented each time "@spawnEnemy" is
;             called. This should start at $ff.
;   var03:    Phase of fight
;   var18/19: Pointer to "tile replacement data" while in the process of replacing the
;             room's tiles
;   var30/31: Destination at which to place Link for the next phase
;   var32-34: For the purpose of removing blocks at the end of a phase, this keeps track
;             of the position we're at in the removal loop, and the number of columns or
;             rows remaining to check.
;   var35:    Remembers the value of "subid" at the start of this phase so it can be
;             restored if Link hits the reset button.
; ==============================================================================
interactionCode33:
	ld e,Interaction.state		; $6104
	ld a,(de)		; $6106
	rst_jumpTable			; $6107
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3
	.dw @state4
	.dw @state5
	.dw @state6
	.dw @state7
	.dw @state8
	.dw @state9
	.dw @stateA

@state0:
	call getThisRoomFlags		; $611e
	bit 7,a			; $6121
	jp nz,interactionDelete		; $6123

	ld a,$01		; $6126
	ld (wMenuDisabled),a		; $6128
	ld (wDisabledObjects),a		; $612b
	ld a,($cc93)		; $612e
	or a			; $6131
	ret nz			; $6132

	inc a			; $6133
	ld (de),a ; [state] = 1

	call @spawnEnemy		; $6135
	jp objectCreatePuff		; $6138

; Waiting for Link to complete this phase
@state1:
	ld a,(wNumEnemies)		; $613b
	dec a			; $613e
	ret nz			; $613f
	ld a,$01		; $6140
	ld (wMenuDisabled),a		; $6142
	ld (wDisabledObjects),a		; $6145
	jp interactionIncState		; $6148

@state2:
	; Raise Link off the floor
	ld hl,w1Link.zh		; $614b
	dec (hl)		; $614e
	ld a,$f9		; $614f
	cp (hl)			; $6151
	ret c			; $6152

	; Get the position to place Link at
	ld e,Interaction.var03		; $6153
	ld a,(de)		; $6155
	ld hl,@linkPlacementPositions		; $6156
	rst_addDoubleIndex			; $6159
	ld e,Interaction.var30		; $615a
	ldi a,(hl)		; $615c
	ld (de),a		; $615d
	inc e			; $615e
	ldi a,(hl)		; $615f
	ld (de),a		; $6160
	jp interactionIncState		; $6161

; Moving Link to the target position (var30/var31)
@state3:
	ld hl,w1Link.yh		; $6164
	ld e,Interaction.var30		; $6167
	ld a,(de)		; $6169
	cp (hl)			; $616a
	jp nz,@incOrDecPosition		; $616b

	ld l,<w1Link.xh		; $616e
	inc e			; $6170
	ld a,(de)		; $6171
	cp (hl)			; $6172
	jp nz,@incOrDecPosition		; $6173
	jp interactionIncState		; $6176

@incOrDecPosition:
	jr c,+			; $6179
	inc (hl)		; $617b
	ret			; $617c
+
	dec (hl)		; $617d
	ret			; $617e

; Moving Link back to the ground
@state4:
	ld hl,w1Link.zh		; $617f
	inc (hl)		; $6182
	ret nz			; $6183
	jp interactionIncState		; $6184

; Waiting for Link to complete this phase?
@state5:
	ld a,(wNumEnemies)		; $6187
	dec a			; $618a
	ret nz			; $618b

	ld e,Interaction.var03		; $618c
	ld a,(de)		; $618e
	ld hl,@tileReplacementTable		; $618f
	rst_addAToHl			; $6192
	ld a,(hl)		; $6193
	rst_addAToHl			; $6194
	ld e,Interaction.var18		; $6195
	ld a,l			; $6197
	ld (de),a		; $6198
	inc e			; $6199
	ld a,h			; $619a
	ld (de),a		; $619b
	ld e,Interaction.counter1		; $619c
	ld a,$05		; $619e
	ld (de),a		; $61a0
	jp interactionIncState		; $61a1

; Generate the tiles to be used in this phase
@state6:
	call interactionDecCounter1		; $61a4
	ret nz			; $61a7

	ld (hl),$05		; $61a8

	; Retrieve pointer to tile replacement data
	ld l,Interaction.var18		; $61aa
	ldi a,(hl)		; $61ac
	ld h,(hl)		; $61ad
	ld l,a			; $61ae

	ld a,(hl)		; $61af
	or a			; $61b0
	jp z,interactionIncState		; $61b1

	; First byte read was position; move interaction here for the purpose of creating
	; the "poof".
	call convertShortToLongPosition		; $61b4
	ld e,Interaction.yh		; $61b7
	ld a,b			; $61b9
	ld (de),a		; $61ba
	ld e,Interaction.xh		; $61bb
	ld a,c			; $61bd
	ld (de),a		; $61be

	; Change the tile index
	ldi a,(hl)		; $61bf
	ld c,a			; $61c0
	ldi a,(hl)		; $61c1
	push hl			; $61c2
	call setTile		; $61c3
	pop hl			; $61c6
	ret z			; $61c7

	; Save pointer
	ld e,Interaction.var18		; $61c8
	ld a,l			; $61ca
	ld (de),a		; $61cb
	inc e			; $61cc
	ld a,h			; $61cd
	ld (de),a		; $61ce

	jp objectCreatePuff		; $61cf

; Spawn the enemies
@state7:
	call interactionDecCounter1		; $61d2
	ret nz			; $61d5

	call getThisRoomFlags		; $61d6
	res 6,(hl)		; $61d9

	ld e,Interaction.subid		; $61db
	ld a,(de)		; $61dd
	ld e,Interaction.var35		; $61de
	ld (de),a		; $61e0

	; Spawn the enemies
	ld e,Interaction.var03		; $61e1
	ld a,(de)		; $61e3
	ld hl,@numEnemiesToSpawn		; $61e4
	rst_addAToHl			; $61e7
	ld a,(hl)		; $61e8
--
	call @spawnEnemy		; $61e9
	dec a			; $61ec
	jr nz,--		; $61ed

	ld (wDisableLinkCollisionsAndMenu),a		; $61ef

	; Return position to top-left corner
	ld a,$18		; $61f2
	ld e,Interaction.xh		; $61f4
	ld (de),a		; $61f6
	sub $04			; $61f7
	ld e,Interaction.yh		; $61f9
	ld (de),a		; $61fb

	jp interactionIncState		; $61fc


; Run the phase; constantly checks whether any 2 enemies are close enough to merge.
@state8:
	; If [wNumEnemies] == 1, this phase is over
	ld a,(wNumEnemies)		; $61ff
	dec a			; $6202
	jp z,interactionIncState		; $6203

	; If [wNumEnemies] == 2, there's only one, big smog on-screen. Don't allow Link to
	; reset the phase at this point?
	dec a			; $6206
	jr z,@checkMergeSmogs	; $6207

	; Check whether the switch tile has changed (Link's stepped on it)
	call objectGetTileAtPosition		; $6209
	cp TILEINDEX_BUTTON			; $620c
	jr nz,@buttonPressed	; $620e

	ld a,(w1Link.state)		; $6210
	cp LINK_STATE_NORMAL			; $6213
	jr nz,@checkMergeSmogs	; $6215

	ld a,(wLinkInAir)		; $6217
	or a			; $621a
	jr nz,@checkMergeSmogs	; $621b

	ld c,$04		; $621d
	call objectCheckLinkWithinDistance		; $621f
	jr nc,@checkMergeSmogs	; $6222

	; Switch pressed
	ld a,TILEINDEX_PRESSED_BUTTON		; $6224
	ld c,$11		; $6226
	call setTile		; $6228

@buttonPressed:
	; Subtract health as a penalty
	ld hl,wLinkHealth		; $622b
	ld a,(hl)		; $622e
	cp $0c			; $622f
	jr c,+			; $6231
	sub $04			; $6233
	ld (hl),a		; $6235
+
	ld a,SND_SPLASH		; $6236
	call playSound		; $6238
	call getThisRoomFlags		; $623b
	set 6,(hl)		; $623e
	ld e,Interaction.var35		; $6240
	ld a,(de)		; $6242
	ld e,Interaction.subid		; $6243
	ld (de),a		; $6245
	call interactionIncState		; $6246
	jr @nextPhase		; $6249

; Check up to 3 smog enemies to see whether they should merge
@checkMergeSmogs:
	call @findFirstSmogEnemy		; $624b
	ret nz			; $624e
	push hl			; $624f
	call @findNextSmogEnemy		; $6250
	pop bc			; $6253
	ret nz			; $6254

	call @checkEnemiesCloseEnoughToMerge		; $6255
	jr c,@mergeSmogs	; $6258

	call @findNextSmogEnemy		; $625a
	ret nz			; $625d
	call @checkEnemiesCloseEnoughToMerge		; $625e
	jr c,@mergeSmogs	; $6261

	push hl			; $6263
	ld h,b			; $6264
	call @findNextSmogEnemy		; $6265
	push hl			; $6268
	pop bc			; $6269
	pop hl			; $626a
	call @checkEnemiesCloseEnoughToMerge		; $626b
	ret nc			; $626e

; Merge smogs 'b' and 'h'
@mergeSmogs:
	ld l,Enemy.subid		; $626f
	ld c,l			; $6271
	ld a,(bc)		; $6272
	xor (hl)		; $6273
	and $80			; $6274
	ld (bc),a		; $6276

	; Set subid to $06; slate it for deletion, maybe?
	ld (hl),$06		; $6277

	; This sets hl to a brand new enemy slot
	call getFreeEnemySlot		; $6279
	ld (hl),ENEMYID_SMOG		; $627c

	ld a,(bc)		; $627e
	ld l,c			; $627f
	or $03			; $6280
	ldi (hl),a ; [new subid] = [old subid] | 3

	; Slate the other old smog for deletion?
	ld a,$06		; $6283
	ld (bc),a		; $6285

	; [New var03] = [Interaction.var03]
	ld e,Interaction.var03		; $6286
	ld a,(de)		; $6288
	ldi (hl),a		; $6289

	ld l,Enemy.counter2		; $628a
	ld (hl),$05		; $628c

	; Copy old smog's direction
	inc l			; $628e
	ld c,l			; $628f
	ld a,(bc)		; $6290
	ld (hl),a		; $6291

	; Copy old smog's position
	ld l,Enemy.yh		; $6292
	ld c,l			; $6294
	ld a,(bc)		; $6295
	ldi (hl),a		; $6296
	inc l			; $6297
	ld c,l			; $6298
	ld a,(bc)		; $6299
	ld (hl),a		; $629a
	ret			; $629b


; Smog destroyed; proceed to the next phase
@state9:
	ld e,Interaction.var03		; $629c
	ld a,(de)		; $629e
	inc a			; $629f
	ld (de),a		; $62a0
	cp $04			; $62a1
	jr nz,@nextPhase	; $62a3

	; Final phase completed
	call decNumEnemies		; $62a5
	jp interactionDelete		; $62a8

@nextPhase:
	ld e,Interaction.counter1		; $62ab
	ld a,$05		; $62ad
	ld (de),a		; $62af

	ld a,$01		; $62b0
	ld (wMenuDisabled),a		; $62b2
	ld (wDisabledObjects),a		; $62b5

; Initialize variables for the next phase (they keep track of the position we're at for
; removing block tiles)

	ld e,Interaction.var32
	ld a,$11
	ld (de),a ; var32

	ld a, LARGE_ROOM_HEIGHT-2
	inc e
	ld (de),a ; var33

	inc e
	ld a, LARGE_ROOM_WIDTH-2
	ld (de),a ; var34

	jp interactionIncState


; Clearing out all blocks on-screen in preparation for next phase
@stateA:
	call interactionDecCounter1		; $62c8
	ret nz			; $62cb

	ld a,$05		; $62cc
	ld (hl),a		; $62ce

	ld l,Interaction.var32		; $62cf
	ldi a,(hl)		; $62d1
	ld b,(hl)		; $62d2
	ld l,a			; $62d3
	ld h,>wRoomCollisions		; $62d4
@nextRow:
	ld e,Interaction.var34		; $62d6
	ld a,(de)		; $62d8
	ld c,a			; $62d9
@nextColumn:
	ld a,(hl)		; $62da
	or a			; $62db
	jr nz,@foundNextBlockTile	; $62dc

	ld e,Interaction.var32		; $62de
	inc l			; $62e0
	ld a,l			; $62e1
	ld (de),a		; $62e2
	dec c			; $62e3
	ld e,Interaction.var34		; $62e4
	ld a,c			; $62e6
	ld (de),a		; $62e7
	jr nz,@nextColumn	; $62e8

	; Reset number of columns to check for the next row
	ld a,LARGE_ROOM_WIDTH-2		; $62ea
	ld (de),a		; $62ec

	; Adjust position for the next row
	ld c,a			; $62ed
	ld e,Interaction.var32		; $62ee
	ld a,l			; $62f0
	add ($10 - (LARGE_ROOM_WIDTH-2))			; $62f1
	ld (de),a		; $62f3

	ld l,a			; $62f4
	inc e ; e = var33
	dec b			; $62f6
	ld a,b			; $62f7
	ld (de),a		; $62f8
	jr nz,@nextRow	; $62f9

	; Return to state 1 to begin the next phase
	ld a,$01		; $62fb
	ld e,Interaction.state		; $62fd
	ld (de),a		; $62ff
	ret			; $6300

@foundNextBlockTile:
	ld a,l			; $6301
	ld e,Interaction.yh		; $6302
	and $f0			; $6304
	or $08			; $6306
	ld (de),a		; $6308
	ld e,Interaction.xh		; $6309
	ld a,l			; $630b
	swap a			; $630c
	and $f0			; $630e
	or $08			; $6310
	ld (de),a		; $6312

	ld c,l			; $6313
	ld a,$a3		; $6314
	call setTile		; $6316
	jp objectCreatePuff		; $6319


;;
; @addr{631c}
@findFirstSmogEnemy:
	ld h,FIRST_ENEMY_INDEX-1		; $631c

;;
; @param	h	Enemy index after which to start looking
; @param[out]	h	Index of first found smog enemy
; @param[out]	zflag	nz if no such enemy was found
; @addr{631c}
@findNextSmogEnemy:
	inc h			; $631e
---
	ld l,Enemy.enabled		; $631f
	ldi a,(hl)		; $6321
	or a			; $6322
	jr z,@nextEnemy	; $6323
	ldi a,(hl)		; $6325
	cp ENEMYID_SMOG			; $6326
	jr nz,@nextEnemy	; $6328
	ldi a,(hl)		; $632a
	bit 1,a			; $632b
	jr z,@nextEnemy	; $632d
	xor a			; $632f
	ret			; $6330

@nextEnemy:
	inc h			; $6331
	ld a,h			; $6332
	cp LAST_ENEMY_INDEX+1			; $6333
	jr c,---		; $6335
	or d			; $6337
	ret			; $6338

;;
; @addr{6339}
@spawnEnemy:
	push af			; $6339
	call getFreeEnemySlot		; $633a
	ld (hl),ENEMYID_SMOG		; $633d

	; Increment this.subid, which acts as the "enemy index" to spawn
	ld b,h			; $633f
	ld e,Interaction.subid		; $6340
	ld a,(de)		; $6342
	inc a			; $6343
	ld (de),a		; $6344
	add a			; $6345
	ld hl,@smogEnemyData		; $6346
	rst_addDoubleIndex			; $6349

	ld c,Enemy.subid		; $634a
	ldi a,(hl)		; $634c
	ld (bc),a		; $634d
	inc c			; $634e
	ld e,Interaction.var03		; $634f
	ld a,(de)		; $6351
	ld (bc),a		; $6352
	ld c,Enemy.yh		; $6353
	ldi a,(hl)		; $6355
	ld (bc),a		; $6356
	ld c,Enemy.xh		; $6357
	ldi a,(hl)		; $6359
	ld (bc),a		; $635a
	ld c,Enemy.direction		; $635b
	ldi a,(hl)		; $635d
	ld (bc),a		; $635e
	pop af			; $635f
	ret			; $6360

;;
; @param	b	Enemy 1
; @param	h	Enemy 2
; @param[out]	cflag	Set if they're close enough to merge (within 4 pixels)
; @addr{6361}
@checkEnemiesCloseEnoughToMerge:
	ld l,Enemy.var31		; $6361
	ld c,l			; $6363
	ld a,(bc)		; $6364
	sub (hl)		; $6365
	add $03			; $6366
	cp $07			; $6368
	ret nc			; $636a

	ld l,Enemy.yh		; $636b
	ld c,l			; $636d
	ld a,(bc)		; $636e
	sub (hl)		; $636f
	add $04			; $6370
	cp $09			; $6372
	ret nc			; $6374

	ld l,Enemy.xh		; $6375
	ld c,l			; $6377
	ld a,(bc)		; $6378
	sub (hl)		; $6379
	add $04			; $637a
	cp $09			; $637c
	ret			; $637e

@tileReplacementTable:
	.db @phase0Tiles - CADDR
	.db @phase1Tiles - CADDR
	.db @phase2Tiles - CADDR
	.db @phase3Tiles - CADDR

; Data format:
;   b0: position
;   b1: tile index to place at that position

@phase0Tiles:
	.db $11 $0c
	.db $37 $1d
	.db $46 $1d
	.db $47 $1d
	.db $48 $1d
	.db $76 $1d
	.db $77 $1d
	.db $78 $1d
	.db $87 $1d
	.db $00

@phase1Tiles:
	.db $11 $0c
	.db $3a $1c
	.db $44 $1d
	.db $47 $1d
	.db $4a $1d
	.db $54 $1c
	.db $57 $1d
	.db $64 $1d
	.db $67 $1d
	.db $00

@phase2Tiles:
	.db $11 $0c
	.db $57 $1c
	.db $62 $1d
	.db $63 $1d
	.db $64 $1d
	.db $6a $1d
	.db $6b $1d
	.db $6c $1d
	.db $77 $1c
	.db $00

@phase3Tiles:
	.db $11 $0c
	.db $25 $1d
	.db $26 $1d
	.db $27 $1d
	.db $32 $1d
	.db $37 $1d
	.db $3a $1c
	.db $3c $1d
	.db $42 $1d
	.db $46 $1d
	.db $4c $1d
	.db $52 $1d
	.db $59 $1d
	.db $5c $1d
	.db $62 $1c
	.db $68 $1d
	.db $6c $1d
	.db $72 $1d
	.db $74 $1d
	.db $77 $1c
	.db $7c $1d
	.db $00

@numEnemiesToSpawn: ; Each byte is for a different phase
	.db $02 $03 $02 $03


; Data format:
;   b0: var03
;   b1: Y position
;   b2: X position
;   b3: direction

@smogEnemyData: ; Each row is for a different enemy (across all phases)
	.db $00 $58 $78 $00
	.db $02 $38 $68 $01
	.db $02 $88 $88 $03
	.db $82 $58 $a8 $01
	.db $02 $38 $48 $01
	.db $02 $78 $78 $03
	.db $02 $58 $38 $01
	.db $82 $78 $b8 $01
	.db $02 $28 $28 $01
	.db $82 $58 $88 $03
	.db $82 $88 $c8 $01


@linkPlacementPositions: ; Positions to drop Link at for each phase
	.db $58 $78
	.db $28 $78
	.db $38 $78
	.db $38 $68


; ==============================================================================
; INTERACID_TRIFORCE_STONE
; ==============================================================================
interactionCode34:
	ld e,Interaction.state		; $641f
	ld a,(de)		; $6421
	rst_jumpTable			; $6422
	.dw @state0
	.dw @state1

@state0:
	ld a,$01		; $6427
	ld (de),a		; $6429

	; Delete self if the stone was pushed already
	call getThisRoomFlags		; $642a
	and $c0			; $642d
	jp nz,interactionDelete		; $642f

	ld h,d			; $6432
	ld l,Interaction.collisionRadiusY		; $6433
	ld (hl),$03		; $6435
	inc l			; $6437
	ld (hl),$0a		; $6438

	call objectMarkSolidPosition		; $643a
	call interactionInitGraphics		; $643d
	ld a,PALH_98		; $6440
	call loadPaletteHeader		; $6442
	jp objectSetVisible83		; $6445

@state1:
	ld e,Interaction.state2		; $6448
	ld a,(de)		; $644a
	rst_jumpTable			; $644b
	.dw @substate0
	.dw @substate1
	.dw @substate2

@substate0:
	call objectPreventLinkFromPassing		; $6452
	call @checkPushedStoneLongEnough		; $6455
	ret nz			; $6458

; Begin stone-pushing cutscene

	call interactionIncState2		; $6459
	ld l,Interaction.speed		; $645c
	ld (hl),SPEED_40		; $645e
	ld l,Interaction.counter1		; $6460
	ld (hl),$40		; $6462

	ld a,SPECIALOBJECTID_LINK_CUTSCENE		; $6464
	call setLinkIDOverride		; $6466
	ld l,<w1Link.subid		; $6469
	ld (hl),$06		; $646b

	ld e,Interaction.angle		; $646d
	ld l,<w1Link.angle		; $646f
	ld a,(de)		; $6471
	ld (hl),a		; $6472

	ld l,<w1Link.speed		; $6473
	ld (hl),SPEED_80		; $6475

	ld hl,$cfd0		; $6477
	ld (hl),$06		; $647a
	ld a,SND_MAKUDISAPPEAR		; $647c
	jp playSound		; $647e

;;
; @param[out]	zflag	Set if Link has pushed against the stone long enough
; @addr{6481}
@checkPushedStoneLongEnough:
	; Check Link's X is close enough
	ld e,Interaction.xh		; $6481
	ld a,(de)		; $6483
	ld hl,w1Link.xh		; $6484
	sub (hl)		; $6487
	jr nc,+			; $6488
	cpl			; $648a
	inc a			; $648b
+
	cp $11			; $648c
	jr nc,@notPushing	; $648e

	; Check Link's Y is close enough
	ld l,<w1Link.yh		; $6490
	ld a,(hl)		; $6492
	cp $2a			; $6493
	jr nc,@notPushing	; $6495

	; Check he's facing left or right
	ld l,<w1Link.direction		; $6497
	ld a,(hl)		; $6499
	and $01			; $649a
	jr z,@notPushing	; $649c

	; Check if he's pushing
	call objectCheckLinkPushingAgainstCenter		; $649e
	jr nc,@notPushing	; $64a1

	; Make Link do the push animation
	ld a,$01		; $64a3
	ld (wForceLinkPushAnimation),a		; $64a5

	; Wait for him to push for enough frames
	call interactionDecCounter1		; $64a8
	ret nz			; $64ab

	; Get the direction Link is relative to the stone
	ld c,$28		; $64ac
	call objectCheckLinkWithinDistance		; $64ae

	ld e,Interaction.angle		; $64b1
	and $07			; $64b3
	xor $04			; $64b5
	add a			; $64b7
	add a			; $64b8
	ld (de),a		; $64b9
	xor a			; $64ba
	ret			; $64bb

@notPushing:
	xor a			; $64bc
	ld (wForceLinkPushAnimation),a		; $64bd
	ld a,$14		; $64c0
	ld e,Interaction.counter1		; $64c2
	ld (de),a		; $64c4
	or a			; $64c5
	ret			; $64c6


; In the process of pushing the stone
@substate1:
	call objectPreventLinkFromPassing		; $64c7
	call interactionDecCounter1		; $64ca
	jr nz,@applySpeed	; $64cd

; Finished pushing

	; Determine new X-position
	ld b,$48		; $64cf
	ld e,Interaction.angle		; $64d1
	ld a,(de)		; $64d3
	and $10			; $64d4
	jr z,+			; $64d6
	ld b,$28		; $64d8
+
	ld l,Interaction.xh		; $64da
	ld (hl),b		; $64dc

	call interactionIncState2		; $64dd

	; Determine bit to set on room flags (depends which way it was pushed)
	call getThisRoomFlags		; $64e0
	ld a,b			; $64e3
	cp $28			; $64e4
	ld b,$40		; $64e6
	jr z,+			; $64e8
	ld b,$80		; $64ea
+
	ld a,(hl)		; $64ec
	or b			; $64ed
	ld (hl),a		; $64ee

	call @setSolidTile		; $64ef

	ld a,SNDCTRL_STOPSFX		; $64f2
	call playSound		; $64f4
	ld a,SND_SOLVEPUZZLE_2		; $64f7
	jp playSound		; $64f9

@applySpeed:
	jp objectApplySpeed		; $64fc

@substate2:
	ret			; $64ff

;;
; @param	c	Tile to set collisions to "solid" for
; @addr{6500}
@setSolidTile:
	call objectGetShortPosition		; $6500
	ld c,a			; $6503
	ld b,>wRoomLayout		; $6504
	ld a,$00		; $6506
	ld (bc),a		; $6508
	ld b,>wRoomCollisions		; $6509
	ld a,$0f		; $650b
	ld (bc),a		; $650d
	ret			; $650e


; ==============================================================================
; INTERACID_CHILD
;
; Variables:
;   subid: personality type (0-6)
;   var03: index of script and code to run (changes based on personality and growth stage)
;   var37: animation base (depends on subid, or his personality type)
;   var39: $00 is normal; $01 gives "light" solidity (when he moves); $02 gives no solidity.
;   var3a: animation index? (added to base)
;   var3b: scratch variable for scripts
;   var3c: current index in "position list" data
;   var3d: number of entries in "position list" data (minus one)?
;   var3e/3f: pointer to "position list" data for when the child moves around
; ==============================================================================
interactionCode35:
	ld e,Interaction.state		; $650f
	ld a,(de)		; $6511
	rst_jumpTable			; $6512
	.dw @state0
	.dw _interac65_state1

@state0:
	call _childDetermineAnimationBase		; $6517
	call interactionInitGraphics		; $651a
	call interactionIncState		; $651d

	ld e,Interaction.var03		; $6520
	ld a,(de)		; $6522
	ld hl,_childScriptTable		; $6523
	rst_addDoubleIndex			; $6526
	ldi a,(hl)		; $6527
	ld h,(hl)		; $6528
	ld l,a			; $6529
	call interactionSetScript		; $652a

	ld e,Interaction.var03		; $652d
	ld a,(de)		; $652f
	rst_jumpTable			; $6530

	/* $00 */ .dw @initAnimation
	/* $01 */ .dw @hyperactiveStage4Or5
	/* $02 */ .dw @shyStage4Or5
	/* $03 */ .dw @curious
	/* $04 */ .dw @hyperactiveStage4Or5
	/* $05 */ .dw @shyStage4Or5
	/* $06 */ .dw @curious
	/* $07 */ .dw @hyperactiveStage6
	/* $08 */ .dw @shyStage6
	/* $09 */ .dw @curious
	/* $0a */ .dw @slacker
	/* $0b */ .dw @warrior
	/* $0c */ .dw @arborist
	/* $0d */ .dw @singer
	/* $0e */ .dw @slacker
	/* $0f */ .dw @script0f
	/* $10 */ .dw @arborist
	/* $11 */ .dw @singer
	/* $12 */ .dw @slacker
	/* $13 */ .dw @warrior
	/* $14 */ .dw @arborist
	/* $15 */ .dw @singer
	/* $16 */ .dw @val16
	/* $17 */ .dw @initAnimation
	/* $18 */ .dw @curious
	/* $19 */ .dw @slacker
	/* $1a */ .dw @initAnimation
	/* $1b */ .dw @initAnimation
	/* $1c */ .dw @singer

@initAnimation:
	ld e,Interaction.var37		; $656b
	ld a,(de)		; $656d
	call interactionSetAnimation		; $656e
	jp _childUpdateSolidityAndVisibility		; $6571

@hyperactiveStage6:
	ld a,$02		; $6574
	call _childLoadPositionListPointer		; $6576

@hyperactiveStage4Or5:
	ld h,d			; $6579
	ld l,Interaction.var39		; $657a
	ld (hl),$01		; $657c

	ld l,Interaction.speed		; $657e
	ld (hl),SPEED_180		; $6580
	ld l,Interaction.angle		; $6582
	ld (hl),$18		; $6584

	ld a,$00		; $6586

@setAnimation:
	ld h,d			; $6588
	ld l,Interaction.var3a		; $6589
	ld (hl),a		; $658b
	ld l,Interaction.var37		; $658c
	add (hl)		; $658e
	call interactionSetAnimation		; $658f
	jp _childUpdateSolidityAndVisibility		; $6592

@val16:
	call @hyperactiveStage4Or5		; $6595
	ld h,d			; $6598
	ld l,Interaction.speed		; $6599
	ld (hl),SPEED_100		; $659b
	ret			; $659d

@shyStage4Or5:
	ld a,$00		; $659e
	call _childLoadPositionListPointer		; $65a0
	jr ++			; $65a3

@shyStage6:
	ld a,$01		; $65a5
	call _childLoadPositionListPointer		; $65a7
++
	ld h,d			; $65aa
	ld l,Interaction.var39		; $65ab
	ld (hl),$01		; $65ad
	ld l,Interaction.speed		; $65af
	ld (hl),SPEED_200		; $65b1
	ld a,$00		; $65b3
	jr @setAnimation		; $65b5

@curious:
	ld h,d			; $65b7
	ld l,Interaction.var39		; $65b8
	ld (hl),$02		; $65ba
	ld a,$00		; $65bc
	jr @setAnimation		; $65be

@slacker:
	ld a,$00		; $65c0
	jr @setAnimation		; $65c2

@warrior:
	ld a,$03		; $65c4
	call _childLoadPositionListPointer		; $65c6
	jr ++			; $65c9

@script0f:
	ld a,$04		; $65cb
	call _childLoadPositionListPointer		; $65cd
++
	ld h,d			; $65d0
	ld l,Interaction.var39		; $65d1
	ld (hl),$01		; $65d3
	ld l,Interaction.speed		; $65d5
	ld (hl),SPEED_80		; $65d7
	ld a,$00		; $65d9
	jr @setAnimation		; $65db

@arborist:
	ld a,$03		; $65dd
	jr @setAnimation		; $65df

@singer:
	ld a,$00		; $65e1
	jr @setAnimation		; $65e3


_interac65_state1:
	ld e,Interaction.var03		; $65e5
	ld a,(de)		; $65e7
	rst_jumpTable			; $65e8

	/* $00 */ .dw @updateAnimationAndSolidity
	/* $01 */ .dw @hyperactiveMovement
	/* $02 */ .dw @shyMovement
	/* $03 */ .dw @curiousMovement
	/* $04 */ .dw @hyperactiveMovement
	/* $05 */ .dw @shyMovement
	/* $06 */ .dw @curiousMovement
	/* $07 */ .dw @usePositionList
	/* $08 */ .dw @shyMovement
	/* $09 */ .dw @curiousMovement
	/* $0a */ .dw @slackerMovement
	/* $0b */ .dw @usePositionList
	/* $0c */ .dw @arboristMovement
	/* $0d */ .dw @singerMovement
	/* $0e */ .dw @slackerMovement
	/* $0f */ .dw @usePositionList
	/* $10 */ .dw @arboristMovement
	/* $11 */ .dw @singerMovement
	/* $12 */ .dw @slackerMovement
	/* $13 */ .dw @usePositionList
	/* $14 */ .dw @arboristMovement
	/* $15 */ .dw @singerMovement
	/* $16 */ .dw @val16
	/* $17 */ .dw @updateAnimationAndSolidity
	/* $18 */ .dw @val1b
	/* $19 */ .dw @slackerMovement
	/* $1a */ .dw @updateAnimationAndSolidity
	/* $1b */ .dw @updateAnimationAndSolidity
	/* $1c */ .dw @singerMovement

@hyperactiveMovement:
	ld e,Interaction.counter1		; $6623
	ld a,(de)		; $6625
	or a			; $6626
	jr nz,+			; $6627
	call _childUpdateHyperactiveMovement		; $6629
+

@arboristMovement:
	call interactionRunScript		; $662c

@updateAnimationAndSolidity:
	jp _childUpdateAnimationAndSolidity		; $662f

@val16:
	call _childUpdateUnknownMovement		; $6632
	jp _childUpdateAnimationAndSolidity		; $6635

@shyMovement:
	ld e,Interaction.counter1		; $6638
	ld a,(de)		; $663a
	or a			; $663b
	jr nz,+			; $663c
	call _childUpdateShyMovement		; $663e
+
	jr @runScriptAndUpdateAnimation		; $6641

@usePositionList:
	ld e,Interaction.counter1		; $6643
	ld a,(de)		; $6645
	or a			; $6646
	jr nz,++		; $6647
	call _childUpdateAngleAndApplySpeed		; $6649
	call _childCheckAnimationDirectionChanged		; $664c
	call _childCheckReachedDestination		; $664f
	call c,_childIncPositionIndex		; $6652
++
	jr @runScriptAndUpdateAnimation		; $6655

@curiousMovement:
	call _childUpdateCuriousMovement		; $6657
	ld e,Interaction.var3d		; $665a
	ld a,(de)		; $665c
	or a			; $665d
	call z,interactionRunScript		; $665e

@val1b:
	jp _childUpdateAnimationAndSolidity		; $6661

@slackerMovement:
	ld a,(wFrameCounter)		; $6664
	and $1f			; $6667
	jr nz,++		; $6669
	ld e,Interaction.animParameter		; $666b
	ld a,(de)		; $666d
	and $01			; $666e
	ld c,$08		; $6670
	jr nz,+			; $6672
	ld c,$fc		; $6674
+
	ld b,$f4		; $6676
	call objectCreateFloatingMusicNote		; $6678
++
	jr @runScriptAndUpdateAnimation		; $667b

@singerMovement:
	ld a,(wFrameCounter)		; $667d
	and $1f			; $6680
	jr nz,@runScriptAndUpdateAnimation	; $6682
	ld e,Interaction.direction		; $6684
	ld a,(de)		; $6686
	or a			; $6687
	ld c,$fc		; $6688
	jr z,+			; $668a
	ld c,$00		; $668c
+
	ld b,$fc		; $668e
	call objectCreateFloatingMusicNote		; $6690

@runScriptAndUpdateAnimation:
	call interactionRunScript		; $6693
	jp _childUpdateAnimationAndSolidity		; $6696


;;
; @addr{6699}
_childUpdateAnimationAndSolidity:
	call interactionAnimate		; $6699

;;
; @addr{669c}
_childUpdateSolidityAndVisibility:
	ld e,Interaction.var39		; $669c
	ld a,(de)		; $669e
	cp $01			; $669f
	jr z,++			; $66a1
	cp $02			; $66a3
	jp z,objectSetPriorityRelativeToLink_withTerrainEffects		; $66a5
	call objectPreventLinkFromPassing		; $66a8
	jp objectSetPriorityRelativeToLink_withTerrainEffects		; $66ab
++
	call objectPushLinkAwayOnCollision		; $66ae
	jp objectSetPriorityRelativeToLink_withTerrainEffects		; $66b1

;;
; Writes the "base" animation index to var37 based on subid (personality type)?
; @addr{66b4}
_childDetermineAnimationBase:
	ld e,Interaction.subid		; $66b4
	ld a,(de)		; $66b6
	ld hl,@animations		; $66b7
	rst_addAToHl			; $66ba
	ld a,(hl)		; $66bb
	ld e,Interaction.var37		; $66bc
	ld (de),a		; $66be
	ret			; $66bf

@animations:
	.db $00 $02 $05 $08 $0b $11 $15 $17

;;
; @addr{66c8}
_childUpdateHyperactiveMovement:
	call objectApplySpeed		; $66c8
	ld h,d			; $66cb
	ld l,Interaction.xh		; $66cc
	ld a,(hl)		; $66ce
	sub $29			; $66cf
	cp $40			; $66d1
	ret c			; $66d3
	bit 7,a			; $66d4
	jr nz,+			; $66d6
	dec (hl)		; $66d8
	dec (hl)		; $66d9
+
	inc (hl)		; $66da
	ld l,Interaction.var3c		; $66db
	ld a,(hl)		; $66dd
	inc a			; $66de
	and $03			; $66df
	ld (hl),a		; $66e1
	ld bc,_childHyperactiveMovementAngles		; $66e2
	call addAToBc		; $66e5
	ld a,(bc)		; $66e8
	ld l,Interaction.angle		; $66e9
	ld (hl),a		; $66eb

_childFlipAnimation:
	ld l,Interaction.var3a		; $66ec
	ld a,(hl)		; $66ee
	xor $01			; $66ef
	ld (hl),a		; $66f1
	ld l,Interaction.var37		; $66f2
	add (hl)		; $66f4
	jp interactionSetAnimation		; $66f5

_childHyperactiveMovementAngles:
	.db $18 $0a $18 $06

;;
; @addr{66fc}
_childUpdateUnknownMovement:
	call objectApplySpeed		; $66fc
	ld e,Interaction.xh		; $66ff
	ld a,(de)		; $6701
	sub $14			; $6702
	cp $28			; $6704
	ret c			; $6706
	ld h,d			; $6707
	ld l,Interaction.angle		; $6708
	ld a,(hl)		; $670a
	xor $10			; $670b
	ld (hl),a		; $670d
	jr _childFlipAnimation		; $670e

;;
; Updates movement for "shy" personality type (runs away when Link approaches)
; @addr{6710}
_childUpdateShyMovement:
	ld e,Interaction.state2		; $6710
	ld a,(de)		; $6712
	rst_jumpTable			; $6713
	.dw @substate0
	.dw @substate1

@substate0:
	ld c,$18		; $6718
	call objectCheckLinkWithinDistance		; $671a
	ret nc			; $671d

	call interactionIncState2		; $671e

@substate1:
	call _childUpdateAngleAndApplySpeed		; $6721
	call _childCheckReachedDestination		; $6724
	ret nc			; $6727

	ld h,d			; $6728
	ld l,Interaction.state2		; $6729
	ld (hl),$00		; $672b
	jp _childIncPositionIndex		; $672d

;;
; @addr{6730}
_childUpdateAngleAndApplySpeed:
	ld h,d			; $6730
	ld l,Interaction.var3c		; $6731
	ld a,(hl)		; $6733
	add a			; $6734
	ld b,a			; $6735
	ld e,Interaction.var3f		; $6736
	ld a,(de)		; $6738
	ld l,a			; $6739
	ld e,Interaction.var3e		; $673a
	ld a,(de)		; $673c
	ld h,a			; $673d
	ld a,b			; $673e
	rst_addAToHl			; $673f
	ld b,(hl)		; $6740
	inc hl			; $6741
	ld c,(hl)		; $6742
	call objectGetRelativeAngle		; $6743
	ld e,Interaction.angle		; $6746
	ld (de),a		; $6748
	jp objectApplySpeed		; $6749

;;
; @param[out]	cflag	Set if the child's reached the position he's moving toward (or is
;			within 1 pixel from the destination on both axes)
; @addr{674c}
_childCheckReachedDestination:
	ld h,d			; $674c
	ld l,Interaction.var3c		; $674d
	ld a,(hl)		; $674f
	add a			; $6750
	push af			; $6751

	ld e,Interaction.var3f		; $6752
	ld a,(de)		; $6754
	ld c,a			; $6755
	ld e,Interaction.var3e		; $6756
	ld a,(de)		; $6758
	ld b,a			; $6759

	pop af			; $675a
	call addAToBc		; $675b
	ld l,Interaction.yh		; $675e
	ld a,(bc)		; $6760
	sub (hl)		; $6761
	add $01			; $6762
	cp $03			; $6764
	ret nc			; $6766
	inc bc			; $6767
	ld l,Interaction.xh		; $6768
	ld a,(bc)		; $676a
	sub (hl)		; $676b
	add $01			; $676c
	cp $03			; $676e
	ret			; $6770

;;
; Updates animation if the child's direction has changed?
; @addr{6771}
_childCheckAnimationDirectionChanged:
	ld h,d			; $6771
	ld l,Interaction.angle		; $6772
	ld a,(hl)		; $6774
	swap a			; $6775
	and $01			; $6777
	xor $01			; $6779
	ld l,Interaction.direction		; $677b
	cp (hl)			; $677d
	ret z			; $677e
	ld (hl),a		; $677f
	ld l,Interaction.var3a		; $6780
	add (hl)		; $6782
	ld l,Interaction.var37		; $6783
	add (hl)		; $6785
	jp interactionSetAnimation		; $6786

;;
; @addr{6789}
_childIncPositionIndex:
	ld h,d			; $6789
	ld l,Interaction.var3d		; $678a
	ld a,(hl)		; $678c
	ld l,Interaction.var3c		; $678d
	inc (hl)		; $678f
	cp (hl)			; $6790
	ret nc			; $6791
	ld (hl),$00		; $6792
	ret			; $6794

;;
; Loads address of position list into var3e/var3f, and the number of positions to loop
; through (minus one) into var3d.
;
; @param	a	Data index
; @addr{6795}
_childLoadPositionListPointer:
	add a			; $6795
	add a			; $6796
	ld hl,@positionTable		; $6797
	rst_addAToHl			; $679a
	ld e,Interaction.var3f		; $679b
	ldi a,(hl)		; $679d
	ld (de),a		; $679e
	ld e,Interaction.var3e		; $679f
	ldi a,(hl)		; $67a1
	ld (de),a		; $67a2
	ld e,Interaction.var3d		; $67a3
	ldi a,(hl)		; $67a5
	ld (de),a		; $67a6
	ret			; $67a7


; Data format:
;  word: pointer to position list
;  byte: number of entries in the list (minus one)
;  byte: unused
@positionTable:
	dwbb @list0 $07 $00
	dwbb @list1 $03 $00
	dwbb @list2 $0b $00
	dwbb @list3 $01 $00
	dwbb @list4 $03 $00

; Each 2 bytes is a position the child will move to.
@list0:
	.db $68 $18
	.db $68 $68
	.db $28 $68
	.db $68 $18
	.db $38 $18
	.db $68 $68
	.db $28 $68
	.db $38 $18

@list1:
	.db $18 $18
	.db $58 $18
	.db $58 $48
	.db $18 $48

@list2:
	.db $28 $48
	.db $18 $44
	.db $18 $28
	.db $20 $18
	.db $2c $0c
	.db $38 $08
	.db $44 $0c
	.db $50 $18
	.db $58 $28
	.db $58 $44
	.db $48 $48
	.db $38 $4c

@list3:
	.db $48 $18
	.db $48 $68
@list4:
	.db $18 $30
	.db $58 $30
	.db $58 $48
	.db $18 $48

;;
; @addr{67f8}
_childUpdateCuriousMovement:
	ld e,Interaction.state2		; $67f8
	ld a,(de)		; $67fa
	rst_jumpTable			; $67fb
	.dw @substate0
	.dw @substate1
	.dw @substate2

@substate0:
	ld h,d			; $6802
	ld l,Interaction.speed		; $6803
	ld (hl),SPEED_100		; $6805
	ld l,Interaction.angle		; $6807
	ld (hl),$18		; $6809

@gotoSubstate1AndJump:
	ld h,d			; $680b
	ld l,Interaction.state2		; $680c
	ld (hl),$01		; $680e
	ld l,Interaction.var3d		; $6810
	ld (hl),$01		; $6812

	ld l,Interaction.speedZ		; $6814
	ld (hl),$00		; $6816
	inc hl			; $6818
	ld (hl),$fb		; $6819
	ld a,SND_JUMP		; $681b
	jp playSound		; $681d

@substate1:
	ld c,$50		; $6820
	call objectUpdateSpeedZ_paramC		; $6822
	jp nz,objectApplySpeed		; $6825

	call interactionIncState2		; $6828

	ld l,Interaction.var3d		; $682b
	ld (hl),$00		; $682d
	ld l,Interaction.var3c		; $682f
	ld (hl),$78		; $6831

	ld l,Interaction.angle		; $6833
	ld a,(hl)		; $6835
	xor $10			; $6836
	ld (hl),a		; $6838
	ret			; $6839

@substate2:
	ld h,d			; $683a
	ld l,Interaction.var3c		; $683b
	dec (hl)		; $683d
	ret nz			; $683e
	jr @gotoSubstate1AndJump		; $683f


_childScriptTable:
	.dw childScript00
	.dw childScript_stage4_hyperactive
	.dw childScript_stage4_shy
	.dw childScript_stage4_curious
	.dw childScript_stage5_hyperactive
	.dw childScript_stage5_shy
	.dw childScript_stage5_curious
	.dw childScript_stage6_hyperactive
	.dw childScript_stage6_shy
	.dw childScript_stage6_curious
	.dw childScript_stage7_slacker
	.dw childScript_stage7_warrior
	.dw childScript_stage7_arborist
	.dw childScript_stage7_singer
	.dw childScript_stage8_slacker
	.dw childScript_stage8_warrior
	.dw childScript_stage8_arborist
	.dw childScript_stage8_singer
	.dw childScript_stage9_slacker
	.dw childScript_stage9_warrior
	.dw childScript_stage9_arborist
	.dw childScript_stage9_singer
	.dw childScript00
	.dw childScript00
	.dw childScript00
	.dw childScript00
	.dw childScript00
	.dw childScript00
	.dw childScript00


; ==============================================================================
; INTERACID_NAYRU
; ==============================================================================
interactionCode36:
	ld e,Interaction.state		; $687b
	ld a,(de)		; $687d
	rst_jumpTable			; $687e
	.dw nayruState0
	.dw _nayruState1

;;
; @addr{6883}
nayruState0:
	ld a,$01		; $6883
	ld (de),a		; $6885
	call interactionInitGraphics		; $6886
	call objectSetVisiblec2		; $6889
	call @initSubid		; $688c

	ld e,Interaction.enabled		; $688f
	ld a,(de)		; $6891
	or a			; $6892
	jp nz,objectMarkSolidPosition		; $6893
	ret			; $6896

@initSubid:
	ld e,Interaction.subid		; $6897
	ld a,(de)		; $6899
	rst_jumpTable			; $689a
	.dw @init00
	.dw @init01
	.dw @init02
	.dw @init03
	.dw @init04
	.dw @init05
	.dw @init06
	.dw @init07
	.dw @init08
	.dw @init09
	.dw @init0a
	.dw @init0b
	.dw @init0c
	.dw @init0d
	.dw @init0e
	.dw @init0f
	.dw @init10
	.dw @init11
	.dw @init12
	.dw @init13

@init00:
	ld a,$03		; $68c3
	call setMusicVolume		; $68c5
	call @loadEvilPalette		; $68c8

@setSingingAnimation:
	ld a,$04		; $68cb
	call interactionSetAnimation		; $68cd
	jp interactionLoadExtraGraphics		; $68d0

@init01:
	ld a,GLOBALFLAG_0b		; $68d3
	call checkGlobalFlag		; $68d5
	jp nz,interactionDelete		; $68d8

	call objectSetInvisible		; $68db

	ld hl,nayruScript01		; $68de
	call interactionSetScript		; $68e1

@init0e: ; This is also called from ambi subids 4 and 5 (to initialize possessed palettes)
	ld a,$06		; $68e4
	ld e,Interaction.oamFlags		; $68e6
	ld (de),a		; $68e8

@loadEvilPalette:
	; Load the possessed version of her palette into palette 6.
	ld a,PALH_97		; $68e9
	jp loadPaletteHeader		; $68eb

@init02:
	ld a,($cfd0)		; $68ee
	cp $03			; $68f1
	jr z,++			; $68f3

	ld a,$05		; $68f5
	call interactionSetAnimation		; $68f7
	ld hl,nayruScript02_part1		; $68fa
	call interactionSetScript		; $68fd
	jp objectSetInvisible		; $6900
++
	ld a,$02		; $6903
	call interactionSetAnimation		; $6905

	ld hl,nayruScript02_part2		; $6908
	jp interactionSetScript		; $690b

@init04:
	ld hl,nayruScript04_part1		; $690e
	ld a,($cfd0)		; $6911
	cp $0b			; $6914
	jr nz,++		; $6916

	ld bc,$4840		; $6918
	call interactionSetPosition		; $691b
	call checkIsLinkedGame		; $691e
	jr nz,@init03	; $6921

	ld hl,nayruScript04_part2		; $6923
++
	call interactionSetScript		; $6926

@init03:
	xor a			; $6929
	jp interactionSetAnimation		; $692a

@init05:
	ld a,$05		; $692d
	call interactionSetAnimation		; $692f
	ld hl,nayruScript05		; $6932
	call interactionSetScript		; $6935
	jp objectSetInvisible		; $6938

@init06:
	ld a,$07		; $693b
	jp interactionSetAnimation		; $693d

@init07:
	ld e,Interaction.counter1		; $6940
	ld a,$1e		; $6942
	ld (de),a		; $6944
	call interactionLoadExtraGraphics		; $6945
	jp interactionSetAlwaysUpdateBit		; $6948

@init08:
	ld hl,nayruScript08		; $694b
	call interactionSetScript		; $694e
	call objectSetVisible82		; $6951
	ld a,$03		; $6954
	jp interactionSetAnimation		; $6956

@init09:
	ld hl,nayruScript09		; $6959
	jp interactionSetScript		; $695c

@init0a:
	call checkIsLinkedGame		; $695f
	jp z,interactionDelete		; $6962

	ld a,TREASURE_MAKU_SEED		; $6965
	call checkTreasureObtained		; $6967
	jp nc,interactionDelete		; $696a

	ld a,GLOBALFLAG_PRE_BLACK_TOWER_CUTSCENE_DONE		; $696d
	call checkGlobalFlag		; $696f
	jp nz,interactionDelete		; $6972

	ld a,$01		; $6975
	call interactionSetAnimation		; $6977
	ld hl,nayruScript0a		; $697a
	jp interactionSetScript		; $697d

@init0b:
	ld a,GLOBALFLAG_FINISHEDGAME		; $6980
	call checkGlobalFlag		; $6982
	jp nz,interactionDelete		; $6985

	ld a,GLOBALFLAG_SAVED_NAYRU		; $6988
	call checkGlobalFlag		; $698a
	jp z,interactionDelete		; $698d

	ld a,TREASURE_MAKU_SEED		; $6990
	call checkTreasureObtained		; $6992
	jp c,interactionDelete		; $6995

	ld a,<TX_1d14		; $6998

@runGenericNpc:
	ld e,Interaction.textID		; $699a
	ld (de),a		; $699c
	inc e			; $699d
	ld a,>TX_1d00		; $699e
	ld (de),a		; $69a0
	ld hl,genericNpcScript		; $69a1
	jp interactionSetScript		; $69a4

@init0c:
	ld a,GLOBALFLAG_FINISHEDGAME		; $69a7
	call checkGlobalFlag		; $69a9
	jp nz,interactionDelete		; $69ac

	ld a,GLOBALFLAG_PRE_BLACK_TOWER_CUTSCENE_DONE		; $69af
	call checkGlobalFlag		; $69b1
	jp z,interactionDelete		; $69b4

	ld a,GLOBALFLAG_FLAME_OF_DESPAIR_LIT		; $69b7
	call checkGlobalFlag		; $69b9
	jp nz,interactionDelete		; $69bc

	ld a,<TX_1d15		; $69bf
	jr @runGenericNpc		; $69c1

@init0d:
	ld a,GLOBALFLAG_FLAME_OF_DESPAIR_LIT		; $69c3
	call checkGlobalFlag		; $69c5
	jp z,interactionDelete		; $69c8

	ld a,GLOBALFLAG_FINISHEDGAME		; $69cb
	call checkGlobalFlag		; $69cd
	jp nz,interactionDelete		; $69d0

	ld a,<TX_1d17		; $69d3
	jr @runGenericNpc		; $69d5

@init0f:
	ld a,TREASURE_MAKU_SEED		; $69d7
	call checkTreasureObtained		; $69d9
	jp nc,interactionDelete		; $69dc

	ld a,GLOBALFLAG_PRE_BLACK_TOWER_CUTSCENE_DONE		; $69df
	call checkGlobalFlag		; $69e1
	jp nz,interactionDelete		; $69e4

	call checkIsLinkedGame		; $69e7
	ld c,$32		; $69ea
	call nz,objectSetShortPosition		; $69ec
	ld a,<TX_1d20		; $69ef
	jr @runGenericNpc		; $69f1

@init10:
	ld a,>TX_1d00		; $69f3
	call interactionSetHighTextIndex		; $69f5
	ld e,Interaction.var3f		; $69f8
	ld a,$ff		; $69fa
	ld (de),a		; $69fc
	ld hl,nayruScript10		; $69fd
	jp interactionSetScript		; $6a00

@init11:
	xor a			; $6a03
	call interactionSetAnimation		; $6a04
	callab scriptHlp.objectWritePositionTocfd5		; $6a07
	ld a,>TX_1d00		; $6a0f
	call interactionSetHighTextIndex		; $6a11
	ld hl,nayruScript11		; $6a14
	jp interactionSetScript		; $6a17

@init12:
	call interactionSetAlwaysUpdateBit		; $6a1a
	ld bc,$4870		; $6a1d
	jp interactionSetPosition		; $6a20

@init13:
	ld a,GLOBALFLAG_FINISHEDGAME		; $6a23
	call checkGlobalFlag		; $6a25
	jp z,interactionDelete		; $6a28

	ld hl,nayruScript13		; $6a2b
	call interactionSetScript		; $6a2e

	ld a,>TX_1d00		; $6a31
	call interactionSetHighTextIndex		; $6a33

	ld a,MUS_OVERWORLD_PRES		; $6a36
	ld (wActiveMusic2),a		; $6a38
	ld a,$ff		; $6a3b
	ld (wActiveMusic),a		; $6a3d
	jp @setSingingAnimation		; $6a40

;;
; @addr{6a43}
_nayruState1:
	ld e,Interaction.subid		; $6a43
	ld a,(de)		; $6a45
	rst_jumpTable			; $6a46
	.dw _nayruSubid00
	.dw _nayruSubid01
	.dw _nayruSubid02
	.dw _nayruSubid03
	.dw _nayruSubid04
	.dw _nayruSubid05
	.dw _nayruSubid00
	.dw _nayruSubid07
	.dw _nayruAnimateAndRunScript
	.dw _nayruSubid09
	.dw _nayruSubid0a
	.dw _nayruAsNpc
	.dw _nayruAsNpc
	.dw _nayruAsNpc
	.dw interactionAnimate
	.dw _nayruAsNpc
	.dw _nayruSubid10
	.dw _nayruAnimateAndRunScript
	.dw interactionAnimate
	.dw _nayruSubid13


; Subid $00: cutscene at the beginning of the game (Nayru talks, gets possessed, goes back
; in time).
; Variables:
;   var38:    "Status" of possession flickering
;   var39:    Counter for number of times to flicker palette while being possessed.
;   var3a/3b: Number of frames to stay in her "unpossessed" (var3a) or "possessed" (var3b)
;             palette. These are copied to var39. Her "possessed" counter gets longer while
;             the other gets shorter.
_nayruSubid00:
	ld e,Interaction.state2		; $6a6f
	ld a,(de)		; $6a71
	rst_jumpTable			; $6a72
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3
	.dw @substate4
	.dw @substate5
	.dw @substate6
	.dw @substate7
	.dw @substate8

; Waiting for Link to approach (signal in $cfd0)
@substate0:
	call interactionAnimate		; $6a85
	ld a,($cfd0)		; $6a88
	cp $09			; $6a8b
	jp nz,@createMusicNotes		; $6a8d

	call interactionIncState2		; $6a90
	ld a,$0f		; $6a93
	ld l,Interaction.var39		; $6a95
	ldi (hl),a		; $6a97
	ldi (hl),a		; $6a98
	ld (hl),$01		; $6a99
	ld hl,nayruScript00_part1		; $6a9b
	jp interactionSetScript		; $6a9e

; This is also called from outside subid 0
@createMusicNotes:
	ld h,d			; $6aa1
	ld l,Interaction.animParameter		; $6aa2
	ld a,(hl)		; $6aa4
	or a			; $6aa5
	ret z			; $6aa6
	ld (hl),$00		; $6aa7
	dec a			; $6aa9
	ld c,-6		; $6aaa
	jr z,+			; $6aac
	ld c,8		; $6aae
+
	ld b,$fc		; $6ab0
	jp objectCreateFloatingMusicNote		; $6ab2


; Palette is flickering while being possessed
@substate1:
	call interactionAnimate		; $6ab5
	call interactionRunScript		; $6ab8
	ld a,($cfd0)		; $6abb
	cp $16			; $6abe
	ret nz			; $6ac0

	; Sway horizontally while moving
	ld e,Interaction.counter2		; $6ac1
	ld a,(de)		; $6ac3
	or a			; $6ac4
	call nz,@swayHorizontally		; $6ac5

	; Flip the OAM flags when var39 reaches 0
	ld h,d			; $6ac8
	ld l,Interaction.var39		; $6ac9
	dec (hl)		; $6acb
	ret nz			; $6acc
	ld l,Interaction.oamFlags		; $6acd
	ld a,(hl)		; $6acf
	dec a			; $6ad0
	xor $05			; $6ad1
	inc a			; $6ad3
	ld (hl),a		; $6ad4

	call _nayruUpdatePossessionPaletteDurations		; $6ad5
	jr nz,++		; $6ad8

	; Done flickering with possession
	call interactionIncState2		; $6ada
	ld l,Interaction.oamFlags		; $6add
	ld (hl),$06		; $6adf
	ret			; $6ae1
++
	ld l,Interaction.var3a		; $6ae2
	ld b,(hl)		; $6ae4
	inc l			; $6ae5
	ld c,(hl)		; $6ae6
	ld l,Interaction.oamFlags		; $6ae7
	ld a,(hl)		; $6ae9
	cp $06			; $6aea
	ld a,b			; $6aec
	jr nz,+			; $6aed
	ld a,c			; $6aef
+
	ld l,Interaction.var39		; $6af0
	ld (hl),a		; $6af2
	ret			; $6af3

;;
; Nayru sways horizontally (3 pixels left, 3 pixels right, repeat)
; @addr{6af4}
@swayHorizontally:
	ld a,(wFrameCounter)		; $6af4
	and $07			; $6af7
	ret nz			; $6af9
	ld a,(wFrameCounter)		; $6afa
	and $38			; $6afd
	swap a			; $6aff
	rlca			; $6b01
	ld hl,@@xOffsets		; $6b02
	rst_addAToHl			; $6b05
	ld e,Interaction.xh		; $6b06
	ld a,(hl)		; $6b08
	ld b,a			; $6b09
	ld a,(de)		; $6b0a
	add b			; $6b0b
	ld (de),a		; $6b0c
	ret			; $6b0d

@@xOffsets:
	.db $ff $ff $ff $00 $01 $01 $01 $00


; Waiting for script to end
@substate2:
	call interactionRunScript		; $6b16
	ret nc			; $6b19
	jp interactionIncState2		; $6b1a


; Waiting for some kind of signal?
@substate3:
	ld a,($cfd0)		; $6b1d
	cp $1a			; $6b20
	ret nz			; $6b22
	call interactionIncState2		; $6b23
	ld l,Interaction.counter1		; $6b26
	ld (hl),60		; $6b28
	ret			; $6b2a


; Waiting 60 frames before jumping
@substate4:
	call interactionAnimate		; $6b2b
	call interactionDecCounter1		; $6b2e
	ret nz			; $6b31

	call interactionIncState2		; $6b32
	ld bc,-$400		; $6b35
	call objectSetSpeedZ		; $6b38
	ld a,SND_SWORDSPIN		; $6b3b
	call playSound		; $6b3d
	ld a,$05		; $6b40
	jp interactionSetAnimation		; $6b42


; Jumping until off-screen
@substate5:
	xor a			; $6b45
	call objectUpdateSpeedZ		; $6b46
	ld e,Interaction.zh		; $6b49
	ld a,(de)		; $6b4b
	cp $80			; $6b4c
	ret nc			; $6b4e

	; Set position to land at
	ld bc,$3828		; $6b4f
	call interactionSetPosition		; $6b52
	ld l,Interaction.zh		; $6b55
	ld (hl),$80		; $6b57

	ld l,Interaction.counter1		; $6b59
	ld (hl),$1e		; $6b5b

	jp interactionIncState2		; $6b5d


; Brief delay before falling back down
@substate6:
	call interactionDecCounter1		; $6b60
	ret nz			; $6b63
	call interactionIncState2		; $6b64
	ld bc,$0040		; $6b67
	jp objectSetSpeedZ		; $6b6a


; Falling back down
@substate7:
	ld c,$20		; $6b6d
	call objectUpdateSpeedZ_paramC		; $6b6f
	ret nz			; $6b72

	ld a,$1b		; $6b73
	ld ($cfd0),a		; $6b75

	; Start next script
	ld hl,nayruScript00_part2		; $6b78
	call interactionSetScript		; $6b7b
	ld a,SND_SLASH		; $6b7e
	call playSound		; $6b80
	jp interactionIncState2		; $6b83


; Next script running; make Nayru transparent when signal is given. Delete self when the
; script finishes.
@substate8:
	call interactionAnimate		; $6b86
	call interactionRunScript		; $6b89
	jr nc,++		; $6b8c
	jp interactionDelete		; $6b8e
++
	; Wait for signal from script to make her transparent
	ld e,Interaction.var3d		; $6b91
	ld a,(de)		; $6b93
	or a			; $6b94
	ret z			; $6b95
	ld b,$01		; $6b96
	jp objectFlickerVisibility		; $6b98


; Subid $01: Cutscene in Ambi's palace after getting bombs
_nayruSubid01:
	call _nayruAnimateAndRunScript		; $6b9b
	ret nc			; $6b9e

; Script finished; load the next room.

	push de			; $6b9f
	ld bc,$0146		; $6ba0
	call disableLcdAndLoadRoom		; $6ba3
	call resetCamera		; $6ba6

	; Need to load the guards since the "disableLcdAndLoadRoom" function call doesn't
	; load the room's objects
	ld hl,objectData.ambisPalaceEntranceGuards		; $6ba9
	call parseGivenObjectData		; $6bac

	; Need to re-initialize the link object
	ld hl,w1Link.enabled		; $6baf
	ld (hl),$03		; $6bb2
	ld l,<w1Link.yh		; $6bb4
	ld (hl),$38		; $6bb6
	ld l,<w1Link.xh		; $6bb8
	ld (hl),$50		; $6bba

	; Need to re-enable the LCD
	ld a,$02		; $6bbc
	call loadGfxRegisterStateIndex		; $6bbe

	pop de			; $6bc1
	ld a,(wActiveMusic2)		; $6bc2
	ld (wActiveMusic),a		; $6bc5
	call playSound		; $6bc8
	jp clearPaletteFadeVariablesAndRefreshPalettes		; $6bcb


; Subid $02: Cutscene on maku tree screen after being saved
_nayruSubid02:
	ld e,Interaction.state2		; $6bce
	ld a,(de)		; $6bd0
	rst_jumpTable			; $6bd1
	.dw _nayruSubid02Substate0
	.dw _nayruSubid02Substate1
	.dw _nayruSubid02Substate2

;;
; @addr{6bd8}
_nayruSubid02Substate0: ; This is also called by Ralph in the same cutscene
	ld a,($cfd0)		; $6bd8
	cp $07			; $6bdb
	jr nz,@createNotes	; $6bdd

	; When signal is received from $cfd0, choose direction randomly (left/right) and
	; go to substate 1
	call getRandomNumber		; $6bdf
	and $02			; $6be2
	or $01			; $6be4
	ld e,Interaction.direction		; $6be6
	ld (de),a		; $6be8

	call _nayruSetCounter1Randomly		; $6be9
	jp interactionIncState2		; $6bec

@createNotes:
	call _nayruSubid00@createMusicNotes		; $6bef

;;
; @addr{6bf2}
_nayruAnimateAndRunScript:
	call interactionAnimateBasedOnSpeed		; $6bf2
	jp interactionRunScript		; $6bf5

;;
; @addr{6bf8}
_nayruSubid02Substate1:
	ld a,($cfd0)		; $6bf8
	cp $08			; $6bfb
	jr nz,_nayruFlipDirectionAtRandomIntervals		; $6bfd

	call interactionIncState2		; $6bff

	ld hl,nayruScript02_part3		; $6c02
	call interactionSetScript		; $6c05

	ld a,$01		; $6c08
	jp interactionSetAnimation		; $6c0a

;;
; This is also called by Ralph in the same cutscene
; @addr{6c0d}
_nayruFlipDirectionAtRandomIntervals:
	call interactionDecCounter1		; $6c0d
	ret nz			; $6c10
	ld l,Interaction.direction		; $6c11
	ld a,(hl)		; $6c13
	xor $02			; $6c14
	ld (hl),a		; $6c16
	call interactionSetAnimation		; $6c17

;;
; @addr{6c1a}
_nayruSetCounter1Randomly:
	call getRandomNumber_noPreserveVars		; $6c1a
	and $03			; $6c1d
	add a			; $6c1f
	add a			; $6c20
	add $10			; $6c21
	ld e,Interaction.counter1		; $6c23
	ld (de),a		; $6c25
	ret			; $6c26

_nayruSubid02Substate2:
	call _nayruAnimateAndRunScript		; $6c27
	ret nc			; $6c2a
	jp interactionDelete		; $6c2b


; Subid $03: Cutscene with Nayru and Ralph when Link exits the black tower
_nayruSubid03:
	call interactionAnimateBasedOnSpeed		; $6c2e
	ld e,Interaction.state2		; $6c31
	ld a,(de)		; $6c33
	rst_jumpTable			; $6c34
	.dw @substate0
	.dw @substate1
	.dw @substate2

@substate0:
	ld a,($cfd0)		; $6c3b
	cp $01			; $6c3e
	ret nz			; $6c40
	call startJump		; $6c41
	jp interactionIncState2		; $6c44

@substate1:
	ld c,$24		; $6c47
	call objectUpdateSpeedZ_paramC		; $6c49
	ret nz			; $6c4c
	ld hl,nayruScript03		; $6c4d
	call interactionSetScript		; $6c50
	jp interactionIncState2		; $6c53

@substate2:
	jp interactionRunScript		; $6c56


;;
; Subid $04: Cutscene at end of game with Ambi and her guards
; @addr{6c59}
_nayruSubid04:
	call checkIsLinkedGame		; $6c59
	jp z,_nayruAnimateAndRunScript		; $6c5c

	ld a,($cfd0)		; $6c5f
	cp $0b			; $6c62
	jr c,_nayruAnimateAndRunScript	; $6c64
	call interactionAnimate		; $6c66
	jpab scriptHlp.turnToFaceSomething		; $6c69

;;
; Subid $05: ?
; @addr{6c71}
_nayruSubid05:
	call _nayruAnimateAndRunScript		; $6c71

	ld a,($cfc0)		; $6c74
	cp $03			; $6c77
	ret c			; $6c79
	cp $05			; $6c7a
	ret nc			; $6c7c

	jpab scriptHlp.turnToFaceSomething		; $6c7d

;;
; For Nayru subid 0 (getting possessed cutscene), this updates var3a, var3b representing
; how long Nayru's palette should be "normal" or "possessed".
;
; @param[out]	zflag	Set when Nayru is fully possessed
; @addr{6c85}
_nayruUpdatePossessionPaletteDurations:
	ld a,(wFrameCounter)		; $6c85
	and $01			; $6c88
	ret nz			; $6c8a
	ld e,Interaction.var38		; $6c8b
	ld a,(de)		; $6c8d
	rst_jumpTable			; $6c8e
	.dw @var38_0
	.dw @var38_1
	.dw @var38_2
	.dw @var38_3
	.dw @var38_4

@var38_0:
	; Decrement var3a (unpossessed palette duration), increment var3b (possessed
	; palette duration) until the two are equal, then increment var38.
	ld h,d			; $6c99
	ld l,Interaction.var3a		; $6c9a
	dec (hl)		; $6c9c
	inc l			; $6c9d
	inc (hl)		; $6c9e
	ldd a,(hl)		; $6c9f
	cp (hl)			; $6ca0
	ret nz			; $6ca1

@incVar38:
	ld l,Interaction.var38		; $6ca2
	inc (hl)		; $6ca4
	ret			; $6ca5

@var38_1:
	; Decrement both var3a and var3b until they're both 2
	ld h,d			; $6ca6
	ld l,Interaction.var3a		; $6ca7
	dec (hl)		; $6ca9
	inc l			; $6caa
	dec (hl)		; $6cab
	ld a,(hl)		; $6cac
	cp $02			; $6cad
	ret nz			; $6caf

	ld l,Interaction.var3c		; $6cb0
	ld (hl),$10		; $6cb2
	jr @incVar38		; $6cb4

@var38_2:
	; Wait 32 frames
	ld h,d			; $6cb6
	ld l,Interaction.var3c		; $6cb7
	dec (hl)		; $6cb9
	ret nz			; $6cba
	jr @incVar38		; $6cbb

@var38_3:
	; Increment both var3a and var3b until they're both 8
	ld h,d			; $6cbd
	ld l,Interaction.var3a		; $6cbe
	inc (hl)		; $6cc0
	inc l			; $6cc1
	inc (hl)		; $6cc2
	ld a,(hl)		; $6cc3
	cp $08			; $6cc4
	ret nz			; $6cc6
	jr @incVar38		; $6cc7

@var38_4:
	; Decrement var3a, increment var3b until it's 16
	ld h,d			; $6cc9
	ld l,Interaction.var3a		; $6cca
	dec (hl)		; $6ccc
	inc l			; $6ccd
	inc (hl)		; $6cce
	ld a,(hl)		; $6ccf
	cp $10			; $6cd0
	ret nz			; $6cd2
	ret			; $6cd3

;;
; Subid $07: Cutscene with the vision of Nayru teaching you Tune of Echoes
; @addr{6cd4}
_nayruSubid07:
	call checkInteractionState2		; $6cd4
	jr nz,@substate1	; $6cd7

@substate0:
	call interactionDecCounter1		; $6cd9
	jr z,++		; $6cdc

	ld l,Interaction.visible		; $6cde
	ld a,(hl)		; $6ce0
	xor $80			; $6ce1
	ld (hl),a		; $6ce3
	ret			; $6ce4
++
	xor a			; $6ce5
	ld ($cfc0),a		; $6ce6
	call interactionIncState2		; $6ce9
	call objectSetVisible82		; $6cec

	ld a,MUS_NAYRU		; $6cef
	ld (wActiveMusic),a		; $6cf1
	call playSound		; $6cf4

	ld hl,nayruScript07		; $6cf7
	jp interactionSetScript		; $6cfa

@substate1:
	call interactionRunScript		; $6cfd
	jr c,@scriptDone	; $6d00

	ld a,($cfc0)		; $6d02
	rrca			; $6d05
	ret c			; $6d06
	ld e,Interaction.direction		; $6d07
	ld a,(de)		; $6d09
	cp $07			; $6d0a
	call z,_nayruSubid00@createMusicNotes		; $6d0c
	jp interactionAnimate		; $6d0f

@scriptDone:
	ld a,(wTextIsActive)		; $6d12
	or a			; $6d15
	ret nz			; $6d16

	; Re-enable objects, menus
	ld (wDisabledObjects),a		; $6d17
	ld (wMenuDisabled),a		; $6d1a

	ld a,(wActiveMusic2)		; $6d1d
	ld (wActiveMusic),a		; $6d20
	call playSound		; $6d23

	ld a,$04		; $6d26
	call fadeinFromWhiteWithDelay		; $6d28
	call showStatusBar		; $6d2b
	ldh a,(<hActiveObject)	; $6d2e
	ld d,a			; $6d30
	jp interactionDelete		; $6d31

;;
; @addr{6d34}
_nayruAsNpc:
	call interactionRunScript		; $6d34
	jp npcFaceLinkAndAnimate		; $6d37

;;
; Subid $09: Cutscene where Ralph's heritage is revealed (unlinked?)
; @addr{6d3a}
_nayruSubid09:
	call _nayruAnimateAndRunScript		; $6d3a
	ret nc			; $6d3d

	xor a			; $6d3e
	ld (wDisabledObjects),a		; $6d3f
	ld (wMenuDisabled),a		; $6d42
	ld a,GLOBALFLAG_PRE_BLACK_TOWER_CUTSCENE_DONE		; $6d45
	call setGlobalFlag		; $6d47
	jp interactionDelete		; $6d4a

;;
; Subid $10: Cutscene in black tower where Nayru/Ralph meet you to try to escape
; @addr{6d4d}
_nayruSubid10:
	ld a,(wScreenShakeCounterY)		; $6d4d
	cp $5a			; $6d50
	jr nc,_nayruSubid0a	; $6d52
	or a			; $6d54
	jr z,_nayruSubid0a	; $6d55
	ld a,(w1Link.direction)		; $6d57
	dec a			; $6d5a
	and $03			; $6d5b
	ld h,d			; $6d5d
	ld l,$7f		; $6d5e
	cp (hl)			; $6d60
	jr z,_nayruSubid0a	; $6d61
	ld (hl),a		; $6d63
	call interactionSetAnimation		; $6d64

;;
; Subid $0a: Cutscene where Ralph's heritage is revealed (linked?)
; @addr{6d67}
_nayruSubid0a:
	call _nayruAnimateAndRunScript		; $6d67
	ret nc			; $6d6a
	jp interactionDelete		; $6d6b

;;
; Subid $13: NPC after completing game (singing to animals)
; @addr{6d6e}
_nayruSubid13:
	call _nayruSubid00@createMusicNotes		; $6d6e

;;
; This is called by Ralph as well
; @addr{6d71}
_nayruRunScriptWithConditionalAnimation:
	call interactionRunScript		; $6d71
	ld e,Interaction.var39		; $6d74
	ld a,(de)		; $6d76
	or a			; $6d77
	call z,interactionAnimate		; $6d78
	call objectPreventLinkFromPassing		; $6d7b
	jp objectSetPriorityRelativeToLink_withTerrainEffects		; $6d7e


; ==============================================================================
; INTERACID_RALPH
;
; Variables:
;   var3f: for some subids, ralph's animations only updates when this is 0.
; ==============================================================================
interactionCode37:
	ld e,Interaction.state		; $6d81
	ld a,(de)		; $6d83
	rst_jumpTable			; $6d84
	.dw _ralphState0
	.dw _ralphRunSubid

_ralphState0:
	ld a,$01		; $6d89
	ld (de),a		; $6d8b
	call interactionInitGraphics		; $6d8c
	call @initSubid		; $6d8f
	ld e,Interaction.enabled		; $6d92
	ld a,(de)		; $6d94
	or a			; $6d95
	jp nz,objectMarkSolidPosition		; $6d96
	ret			; $6d99

@initSubid:
	ld e,Interaction.subid		; $6d9a
	ld a,(de)		; $6d9c
	rst_jumpTable			; $6d9d
	.dw @initSubid00
	.dw @initSubid01
	.dw @initSubid02
	.dw @initSubid03
	.dw @initSubid04
	.dw @initSubid05
	.dw @initSubid06
	.dw @initSubid07
	.dw @initSubid08
	.dw @initSubid09
	.dw @initSubid0a
	.dw @initSubid0b
	.dw @initSubid0c
	.dw @initSubid0d
	.dw @initSubid0e
	.dw @initSubid0f
	.dw @initSubid10
	.dw @initSubid11
	.dw @initSubid12


@initSubid06:
	ld hl,ralphSubid06Script_part1		; $6dc4
	ld a,($cfd0)		; $6dc7
	cp $0b			; $6dca
	jr nz,++		; $6dcc
	ld bc,$4850		; $6dce
	call interactionSetPosition		; $6dd1
	ld hl,ralphSubid06Script_part2		; $6dd4
++
	call interactionSetScript		; $6dd7

@initSubid00:
@initSubid05:
	xor a			; $6dda

@setAnimation:
	call interactionSetAnimation		; $6ddb
	jp objectSetVisiblec2		; $6dde

@initSubid02:
	ld a,$09		; $6de1
	call interactionSetAnimation		; $6de3

	ld hl,ralphSubid02Script		; $6de6
	call interactionSetScript		; $6de9

	call interactionLoadExtraGraphics		; $6dec
	jp objectSetVisiblec2		; $6def

@initSubid03:
	ld a,GLOBALFLAG_GAVE_ROPE_TO_RAFTON		; $6df2
	call checkGlobalFlag		; $6df4
	jp z,interactionDelete		; $6df7

	call getThisRoomFlags		; $6dfa
	bit 6,a			; $6dfd
	jp nz,interactionDelete		; $6dff

	ld a,$01		; $6e02
	ld (wDisabledObjects),a		; $6e04
	ld (wMenuDisabled),a		; $6e07
	ld a,$03		; $6e0a
	call interactionSetAnimation		; $6e0c

	ld h,d			; $6e0f
	ld l,Interaction.counter1		; $6e10
	ld (hl),$78		; $6e12
	ld l,Interaction.direction		; $6e14
	ld (hl),$01		; $6e16
	jp objectSetVisiblec2		; $6e18

@initSubid04:
	ld a,$01		; $6e1b
	call interactionSetAnimation		; $6e1d
	ld a,($cfd0)		; $6e20
	cp $03			; $6e23
	jr z,++			; $6e25
	ld hl,ralphSubid04Script_part1		; $6e27
	call interactionSetScript		; $6e2a
	jp objectSetInvisible		; $6e2d
++
	ld hl,ralphSubid04Script_part2		; $6e30
	call interactionSetScript		; $6e33
	jp objectSetVisiblec2		; $6e36

@initSubid07:
	ld hl,ralphSubid07Script		; $6e39
	call interactionSetScript		; $6e3c
	jp objectSetInvisible		; $6e3f

@initSubid08:
	callab scriptHlp.ralph_createLinkedSwordAnimation		; $6e42

	ld hl,ralphSubid08Script		; $6e4a
	call interactionSetScript		; $6e4d
	jp objectSetVisiblec2		; $6e50

@initSubid09:
	ld a,GLOBALFLAG_RALPH_ENTERED_AMBIS_PALACE		; $6e53
	call checkGlobalFlag		; $6e55
	jr nz,@deleteSelf	; $6e58

	; Check that we have the 5th essence
	ld a,TREASURE_ESSENCE		; $6e5a
	call checkTreasureObtained		; $6e5c
	jr nc,@deleteSelf	; $6e5f
	bit 5,a			; $6e61
	jr nz,++		; $6e63

@deleteSelf:
	jp interactionDelete		; $6e65

++
	ld e,Interaction.speed		; $6e68
	ld a,SPEED_200		; $6e6a
	ld (de),a		; $6e6c

	ld a,MUS_RALPH		; $6e6d
	ld (wActiveMusic),a		; $6e6f
	call playSound		; $6e72

	call setLinkForceStateToState08		; $6e75
	inc a			; $6e78
	ld (wDisabledObjects),a		; $6e79
	ld (wMenuDisabled),a		; $6e7c

	ld a,(wScreenTransitionDirection)		; $6e7f
	ld (w1Link.direction),a		; $6e82

	ld hl,ralphSubid09Script		; $6e85
	call interactionSetScript		; $6e88
	xor a			; $6e8b
	call interactionSetAnimation		; $6e8c
	jp objectSetVisiblec2		; $6e8f

@initSubid0a:
	ld a,TREASURE_MAKU_SEED		; $6e92
	call checkTreasureObtained		; $6e94
	jp nc,interactionDelete		; $6e97

	ld a,GLOBALFLAG_PRE_BLACK_TOWER_CUTSCENE_DONE		; $6e9a
	call checkGlobalFlag		; $6e9c
	jp nz,interactionDelete		; $6e9f

	ld a,GLOBALFLAG_RALPH_ENTERED_BLACK_TOWER		; $6ea2
	call checkGlobalFlag		; $6ea4
	jp nz,interactionDelete		; $6ea7

	call checkIsLinkedGame		; $6eaa
	ld hl,ralphSubid0aScript_unlinked		; $6ead
	jr z,@@setScript		; $6eb0

	; Linked game: adjust position, load a different script
	ld h,d			; $6eb2
	ld l,Interaction.xh		; $6eb3
	ld (hl),$50		; $6eb5
	ld l,Interaction.var38		; $6eb7
	ld (hl),$1e		; $6eb9

	ld hl,ralphSubid0aScript_linked		; $6ebb

@@setScript:
	call interactionSetScript		; $6ebe
	call setLinkForceStateToState08		; $6ec1
	ld ($cfd0),a		; $6ec4
	inc a			; $6ec7
	ld (wDisabledObjects),a		; $6ec8
	ld (wMenuDisabled),a		; $6ecb
	jp objectSetVisiblec2		; $6ece

@initSubid0e:
	ld e,Interaction.var3f		; $6ed1
	ld a,$ff		; $6ed3
	ld (de),a		; $6ed5
	ld hl,ralphSubid0eScript		; $6ed6
	jr @setScriptAndRunState1		; $6ed9

@initSubid0f:
	ld a,$01		; $6edb
	jp @setAnimation		; $6edd

@initSubid01:
	ld hl,ralphSubid01Script		; $6ee0

@setScriptAndRunState1:
	call interactionSetScript		; $6ee3
	jp _ralphRunSubid		; $6ee6

@delete:
	jp interactionDelete		; $6ee9

@initSubid0b:
	ld a,TREASURE_TUNE_OF_CURRENTS		; $6eec
	call checkTreasureObtained		; $6eee
	jr c,@delete	; $6ef1

	call getThisRoomFlags		; $6ef3
	and $40			; $6ef6
	jr nz,@delete	; $6ef8

	; Check that Link has timewarped in from a specific spot
	ld a,(wScreenTransitionDirection)		; $6efa
	or a			; $6efd
	jr nz,@delete	; $6efe
	ld a,(wWarpDestPos)		; $6f00
	cp $24			; $6f03
	jr nz,@delete	; $6f05

	ld hl,ralphSubid0bScript		; $6f07

@setScriptAndDisableObjects:
	call interactionSetScript		; $6f0a

	ld a,$81		; $6f0d
	ld (wDisabledObjects),a		; $6f0f
	ld (wMenuDisabled),a		; $6f12

	call objectSetVisiblec1		; $6f15
	jp _ralphRunSubid		; $6f18

@initSubid10:
	call getThisRoomFlags		; $6f1b
	and $40			; $6f1e
	jp nz,interactionDelete		; $6f20

	ld a,GLOBALFLAG_TALKED_TO_CHEVAL		; $6f23
	call checkGlobalFlag		; $6f25
	jp z,interactionDelete		; $6f28

	ld a,(wWarpDestPos)		; $6f2b
	cp $17			; $6f2e
	jp nz,interactionDelete		; $6f30

	ld hl,ralphSubid10Script		; $6f33
	jr @setScriptAndDisableObjects		; $6f36

@initSubid11:
	ld a,GLOBALFLAG_FINISHEDGAME		; $6f38
	call checkGlobalFlag		; $6f3a
	jp z,interactionDelete		; $6f3d

	ld a,$03		; $6f40
	call interactionSetAnimation		; $6f42
	ld hl,ralphSubid11Script		; $6f45
	call interactionSetScript		; $6f48
	jr _ralphRunSubid		; $6f4b

@initSubid0c:
	ld hl,wGroup4Flags+$fc		; $6f4d
	bit 7,(hl)		; $6f50
	jp nz,interactionDelete		; $6f52

	call interactionLoadExtraGraphics		; $6f55
	callab scriptHlp.ralph_createLinkedSwordAnimation		; $6f58
	ld hl,ralphSubid0cScript		; $6f60
	call interactionSetScript		; $6f63
	xor a			; $6f66
	ld ($cfde),a		; $6f67
	ld ($cfdf),a		; $6f6a
	call interactionSetAnimation		; $6f6d
	call interactionRunScript		; $6f70
	jr _ralphRunSubid		; $6f73

@initSubid12:
	call checkIsLinkedGame		; $6f75
	jp z,interactionDelete		; $6f78
	ld hl,wGroup4Flags + (<ROOM_AGES_4fc)
	bit 7,(hl)		; $6f7e
	jp z,interactionDelete		; $6f80
	call objectSetVisiblec2		; $6f83
	ld hl,ralphSubid12Script		; $6f86
	jp interactionSetScript		; $6f89

@initSubid0d:
	ld a,(wScreenTransitionDirection)		; $6f8c
	cp $01			; $6f8f
	jp nz,interactionDelete		; $6f91

	ld hl,ralphSubid0dScript		; $6f94
	call interactionSetScript		; $6f97
	call objectSetVisiblec0		; $6f9a

;;
; @addr{6f9d}
_ralphRunSubid:
	ld e,Interaction.subid		; $6f9d
	ld a,(de)		; $6f9f
	rst_jumpTable			; $6fa0
	.dw _ralphSubid00
	.dw _ralphSubid01
	.dw _ralphSubid02
	.dw _ralphSubid03
	.dw _ralphSubid04
	.dw _ralphSubid05
	.dw _ralphSubid06
	.dw _ralphSubid07
	.dw _ralphSubid08
	.dw _ralphSubid09
	.dw _ralphSubid0a
	.dw _ralphSubid0b
	.dw _ralphRunScriptAndDeleteWhenOver
	.dw _ralphRunScriptWithConditionalAnimation
	.dw _ralphSubid0e
	.dw interactionAnimate
	.dw _ralphSubid10
	.dw _nayruRunScriptWithConditionalAnimation
	.dw _ralphSubid12

;;
; Cutscene where Nayru gets possessed
; @addr{6fc7}
_ralphSubid00:
	ld e,Interaction.state2		; $6fc7
	ld a,(de)		; $6fc9
	rst_jumpTable		; $6fca
	.dw @substate0
	.dw @substate1

@substate0:
	call interactionAnimate		; $6fcf
	ld a,($cfd0)		; $6fd2
	cp $09			; $6fd5
	ret nz			; $6fd7

	call interactionIncState2		; $6fd8
	ld l,Interaction.counter1		; $6fdb
	ld (hl),$3c		; $6fdd

	ld bc,$3088		; $6fdf
	call interactionSetPosition		; $6fe2
	ld a,$03		; $6fe5
	call interactionSetAnimation		; $6fe7

	ld hl,ralphSubid00Script		; $6fea
	jp interactionSetScript		; $6fed

@substate1:
	call interactionAnimate		; $6ff0
	call interactionRunScript		; $6ff3
	ld e,Interaction.counter2		; $6ff6
	ld a,(de)		; $6ff8
	or a			; $6ff9
	ret z			; $6ffa

	; Animate more quickly if moving fast
	ld e,Interaction.speed		; $6ffb
	ld a,(de)		; $6ffd
	cp SPEED_100			; $6ffe
	jp nc,interactionAnimate		; $7000
	ret			; $7003

;;
; Cutscene after Nayru is possessed
; @addr{7004}
_ralphSubid02:
	; They probably meant to call "checkInteractionState2" instead? It looks like
	; @state0 will never be run...
	call checkInteractionState		; $7004
	jr nz,@state1		; $7007

@state0:
	call interactionRunScript		; $7009
	call interactionAnimate		; $700c
	ld a,($cfd0)		; $700f
	cp $1f			; $7012
	ret nz			; $7014
	jp interactionIncState2		; $7015

@state1:
	callab scriptHlp.objectWritePositionTocfd5		; $7018
	ld e,Interaction.counter2		; $7020
	ld a,(de)		; $7022
	or a			; $7023
	call nz,interactionAnimate		; $7024
	call    interactionAnimate		; $7027

	call interactionRunScript		; $702a
	ret nc			; $702d

	; Script done
	ld a,SNDCTRL_MEDIUM_FADEOUT		; $702e
	call playSound		; $7030
	jp interactionDelete		; $7033

;;
; Cutscene outside Ambi's palace before getting mystery seeds
; @addr{7036}
_ralphSubid01:
	call interactionRunScript		; $7036
	jp c,interactionDelete		; $7039

	call _ralphTurnLinkTowardSelf		; $703c
	ld e,Interaction.var3f		; $703f
	ld a,(de)		; $7041
	or a			; $7042
	call z,interactionAnimate2Times		; $7043
	jp interactionPushLinkAwayAndUpdateDrawPriority		; $7046

;;
; Cutscene after talking to Rafton
; @addr{7049}
_ralphSubid03:
	ld e,Interaction.state2		; $7049
	ld a,(de)		; $704b
	rst_jumpTable			; $704c
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3
	.dw @substate4
	.dw @substate5
	.dw @substate6
	.dw @substate7
	.dw @substate8

@substate0:
	call interactionDecCounter1		; $705f
	jr nz,++		; $7062

	ld (hl),$1e		; $7064
	ld a,$02		; $7066
	call interactionSetAnimation		; $7068
	jp interactionIncState2		; $706b
++
	ld a,(wFrameCounter)		; $706e
	and $0f			; $7071
	ret nz			; $7073
	ld e,Interaction.direction		; $7074
	ld a,(de)		; $7076
	xor $02			; $7077
	ld (de),a		; $7079
	jp interactionSetAnimation		; $707a

@substate1:
	call interactionDecCounter1		; $707d
	ret nz			; $7080
	call interactionIncState2		; $7081
	jp startJump		; $7084

@substate2:
	call interactionAnimate		; $7087
	ld c,$20		; $708a
	call objectUpdateSpeedZ_paramC		; $708c
	ret nz			; $708f
	call interactionIncState2		; $7090
	ld l,Interaction.counter1		; $7093
	ld (hl),$0a		; $7095
	ret			; $7097

@substate3:
	call interactionDecCounter1		; $7098
	ret nz			; $709b
	ld (hl),$1e		; $709c
	call interactionIncState2		; $709e
	ld bc,TX_2a0a		; $70a1
	jp showText		; $70a4

@substate4:
	call interactionDecCounter1IfTextNotActive		; $70a7
	ret nz			; $70aa
	ld (hl),$30		; $70ab

	call interactionIncState2		; $70ad

	ld l,Interaction.angle		; $70b0
	ld (hl),$10		; $70b2
	ld l,Interaction.speed		; $70b4
	ld (hl),SPEED_100		; $70b6

	ld a,$02		; $70b8
	jp interactionSetAnimation		; $70ba

@substate5:
	call interactionAnimate2Times		; $70bd
	call interactionDecCounter1		; $70c0
	jp nz,objectApplySpeed		; $70c3

	ld (hl),$06		; $70c6
	jp interactionIncState2		; $70c8

@substate6:
	call interactionDecCounter1		; $70cb
	ret nz			; $70ce
	ld (hl),$0a		; $70cf

	; Align with Link's x-position
	call interactionIncState2		; $70d1
	ld a,(w1Link.xh)		; $70d4
	ld l,Interaction.xh		; $70d7
	sub (hl)		; $70d9
	jr z,@startScript	; $70da
	jr c,@@moveLeft		; $70dc

@@moveRight:
	ld b,$08		; $70de
	ld c,DIR_RIGHT		; $70e0
	jr ++			; $70e2

@@moveLeft:
	cpl			; $70e4
	inc a			; $70e5
	ld b,$18		; $70e6
	ld c,DIR_LEFT		; $70e8
++
	ld l,Interaction.counter1		; $70ea
	ld (hl),a		; $70ec
	ld l,Interaction.angle		; $70ed
	ld (hl),b		; $70ef
	ld a,c			; $70f0
	jp interactionSetAnimation		; $70f1

@substate7:
	call interactionAnimate2Times		; $70f4
	call interactionDecCounter1		; $70f7
	jp nz,objectApplySpeed		; $70fa

@startScript:
	call interactionIncState2		; $70fd
	ld hl,ralphSubid03Script		; $7100
	jp interactionSetScript		; $7103

@substate8:
	call _ralphAnimateBasedOnSpeedAndRunScript		; $7106
	ret nc			; $7109

	ld a,MUS_OVERWORLD_PAST		; $710a
	ld (wActiveMusic2),a		; $710c
	ld (wActiveMusic),a		; $710f
	call playSound		; $7112
	jp interactionDelete		; $7115

;;
; Cutscene on maku tree screen after saving Nayru
; @addr{7118}
_ralphSubid04:
	ld e,Interaction.state2		; $7118
	ld a,(de)		; $711a
	rst_jumpTable			; $711b
	.dw _nayruSubid02Substate0 ; Borrow some of Nayru's code from the same cutscene
	.dw @substate1
	.dw @substate2

@substate1:
	ld a,($cfd0)		; $7122
	cp $08			; $7125
	jp nz,_nayruFlipDirectionAtRandomIntervals		; $7127

	call interactionIncState2		; $712a
	ld hl,ralphSubid04Script_part3		; $712d
	call interactionSetScript		; $7130
	jp @substate2		; $7133

@substate2:
	call _ralphAnimateBasedOnSpeedAndRunScript		; $7136
	ret nc			; $7139
	jp interactionDelete		; $713a

;;
; Cutscene in black tower where Nayru/Ralph meet you to try to escape
; @addr{713d}
_ralphSubid05:
	call interactionAnimateBasedOnSpeed		; $713d
	ld e,Interaction.state2		; $7140
	ld a,(de)		; $7142
	rst_jumpTable			; $7143
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3
	.dw _ralphRunScript

@substate0:
	ld a,($cfd0)		; $714e
	cp $01			; $7151
	ret nz			; $7153
	call startJump		; $7154
	jp interactionIncState2		; $7157

@substate1:
	ld c,$20		; $715a
	call objectUpdateSpeedZ_paramC		; $715c
	ret nz			; $715f
	ld hl,ralphSubid05Script		; $7160
	call interactionSetScript		; $7163
	jp interactionIncState2		; $7166

@substate2:
	ld a,($cfd0)		; $7169
	cp $02			; $716c
	jp nz,interactionRunScript		; $716e
	call startJump		; $7171
	jp interactionIncState2		; $7174

@substate3:
	ld c,$20		; $7177
	call objectUpdateSpeedZ_paramC		; $7179
	ret nz			; $717c
	call interactionIncState2		; $717d
	ld l,Interaction.var3e		; $7180
	inc (hl)		; $7182

_ralphRunScript:
	jp interactionRunScript		; $7183

;;
; @addr{7186}
_ralphSubid06:
	call interactionAnimateBasedOnSpeed		; $7186
	ld e,Interaction.state2		; $7189
	ld a,(de)		; $718b
	rst_jumpTable			; $718c
	.dw @substate0
	.dw @substate1
	.dw _ralphRunScript

@substate0:
	callab scriptHlp.objectWritePositionTocfd5		; $7193
	ld a,($cfd0)		; $719b
	cp $08			; $719e
	jp nz,interactionRunScript		; $71a0
	call startJump		; $71a3
	jp interactionIncState2		; $71a6

@substate1:
	ld c,$20		; $71a9
	call objectUpdateSpeedZ_paramC		; $71ab
	ret nz			; $71ae
	call interactionIncState2		; $71af
	ld l,Interaction.var3e		; $71b2
	inc (hl)		; $71b4
	jr _ralphRunScript		; $71b5

;;
; Cutscene postgame where they warp to the maku tree, Ralph notices the statue
; @addr{71b7}
_ralphSubid07:
	callab scriptHlp.objectWritePositionTocfd5		; $71b7
	ld e,Interaction.state2		; $71bf
	ld a,(de)		; $71c1
	rst_jumpTable			; $71c2
	.dw _ralphAnimateBasedOnSpeedAndRunScript
	.dw _ralphSubid07Substate1
	.dw _ralphSubid07Substate2
	.dw _ralphAnimateBasedOnSpeedAndRunScript

_ralphAnimateBasedOnSpeedAndRunScript:
	call interactionAnimateBasedOnSpeed		; $71cb
	jp interactionRunScript		; $71ce

_ralphSubid07Substate1:
	call interactionIncState2		; $71d1
	call objectSetVisiblec2		; $71d4
	ld bc,-$1c0		; $71d7
	call objectSetSpeedZ		; $71da

_ralphSubid07Substate2:
	ld c,$20		; $71dd
	call objectUpdateSpeedZ_paramC		; $71df
	ret nz			; $71e2

	call interactionIncState2		; $71e3
	ld l,Interaction.var3e		; $71e6
	inc (hl)		; $71e8
	jp objectSetVisible82		; $71e9

;;
; Cutscene in credits where Ralph is training with his sword
; @addr{71ec}
_ralphSubid08:
	ld e,Interaction.state2		; $71ec
	ld a,(de)		; $71ee
	rst_jumpTable			; $71ef
	.dw @substate0
	.dw @substate1
	.dw @substate2

@substate0:
	call interactionAnimate		; $71f6
	call interactionRunScript		; $71f9
	ret nc			; $71fc

	; Script done

	call interactionIncState2		; $71fd
	ld l,Interaction.speed		; $7200
	ld (hl),SPEED_c0		; $7202

@getNextAngle:
	ld b,$02		; $7204
	callab interactionBank0a.loadAngleAndCounterPreset		; $7206
	ld a,b			; $720e
	or a			; $720f
	ret			; $7210

@substate1:
	call interactionAnimate		; $7211
	call objectApplySpeed		; $7214
	call interactionDecCounter1		; $7217
	call z,@getNextAngle		; $721a
	ret nz			; $721d

	call interactionIncState2		; $721e
	ld l,Interaction.counter1		; $7221
	ld (hl),$5a		; $7223
	ld a,$08		; $7225
	jp interactionSetAnimation		; $7227

@substate2:
	call interactionAnimate		; $722a
	call interactionDecCounter1		; $722d
	ret nz			; $7230
	ld a,$ff		; $7231
	ld ($cfdf),a		; $7233
	ret			; $7236

;;
; Cutscene where Ralph charges in to Ambi's palace
; @addr{7237}
_ralphSubid09:
	call interactionRunScript		; $7237
	jp nc,interactionAnimateBasedOnSpeed		; $723a

	; Script done
	xor a			; $723d
	ld (wDisabledObjects),a		; $723e
	ld (wMenuDisabled),a		; $7241
	jp interactionDelete		; $7244

;;
; Cutscene where Ralph's about to charge into the black tower
; @addr{7247}
_ralphSubid0a:
	call checkIsLinkedGame		; $7247
	jp nz,_ralphSubid0a_linked		; $724a

; Unlinked game

	ld e,Interaction.state2		; $724d
	ld a,(de)		; $724f
	rst_jumpTable			; $7250
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3
	.dw @substate4

@substate0:
	; Create an exclamation mark above Link
	call getFreeInteractionSlot		; $725b
	ret nz			; $725e
	ld (hl),INTERACID_EXCLAMATION_MARK		; $725f
	ld l,Interaction.counter1		; $7261
	ld (hl),$1e		; $7263
	ld l,Interaction.yh		; $7265
	ld a,(w1Link.yh)		; $7267
	add $0e			; $726a
	ldi (hl),a		; $726c
	inc l			; $726d
	ld a,(w1Link.xh)		; $726e
	sub $0a			; $7271
	ld (hl),a		; $7273

	ld a,SND_CLINK		; $7274
	call playSound		; $7276

	call interactionIncState2		; $7279

	ld l,Interaction.counter1		; $727c
	ld (hl),$1e		; $727e
	ld l,Interaction.speed		; $7280
	ld (hl),SPEED_180		; $7282
	ret			; $7284

@substate1:
	call interactionDecCounter1		; $7285
	ret nz			; $7288

	xor a			; $7289
	call interactionSetAnimation		; $728a

@moveHorizontallyTowardRalph:
	ld a,(w1Link.xh)		; $728d
	sub $50			; $7290
	ld b,a			; $7292
	add $02			; $7293
	cp $05			; $7295
	jr c,@incState2		; $7297

	ld a,b			; $7299
	bit 7,a			; $729a
	ld b,$18		; $729c
	jr z,+			; $729e
	ld b,$08		; $72a0
	cpl			; $72a2
	inc a			; $72a3
+
	ld (wLinkStateParameter),a		; $72a4
	ld a,LINK_STATE_FORCE_MOVEMENT		; $72a7
	ld (wLinkForceState),a		; $72a9
	ld a,b			; $72ac
	ld hl,w1Link.angle		; $72ad
	ldd (hl),a		; $72b0
	swap a			; $72b1
	rlca			; $72b3
	ld (hl),a ; [w1Link.direction]

@incState2:
	jp interactionIncState2		; $72b5

@substate2:
	ld b,$50		; $72b8

@moveVerticallyTowardRalph:
	ld a,(w1Link.state)		; $72ba
	cp LINK_STATE_FORCE_MOVEMENT			; $72bd
	ret z			; $72bf

	; Make Link move vertically toward Ralph
	ld hl,w1Link.angle		; $72c0
	ld (hl),$10		; $72c3
	dec l			; $72c5
	ld (hl),DIR_DOWN		; $72c6
	ld a,b			; $72c8
	ld (wLinkStateParameter),a		; $72c9
	ld a,LINK_STATE_FORCE_MOVEMENT		; $72cc
	ld (wLinkForceState),a		; $72ce
	jp interactionIncState2		; $72d1

@substate3:
	ldbc DIR_RIGHT,$03		; $72d4

@setDirectionAndAnimationWhenLinkFinishedMoving:
	ld a,(w1Link.state)		; $72d7
	cp LINK_STATE_FORCE_MOVEMENT			; $72da
	ret z			; $72dc

	call setLinkForceStateToState08		; $72dd
	ld a,b			; $72e0
	ld (w1Link.direction),a		; $72e1
	ld a,c			; $72e4
	call interactionSetAnimation		; $72e5
	jp interactionIncState2		; $72e8

@substate4:
	call interactionRunScript		; $72eb
	jp nc,interactionAnimateBasedOnSpeed		; $72ee
	xor a			; $72f1
	ld (wDisabledObjects),a		; $72f2
	ld (wMenuDisabled),a		; $72f5
	jp interactionDelete		; $72f8

;;
; @addr{72fb}
_ralphSubid0a_linked:
	call interactionRunScript		; $72fb
	jp c,interactionDelete		; $72fe

	call interactionAnimateBasedOnSpeed		; $7301
	ld e,Interaction.state2		; $7304
	ld a,(de)		; $7306
	rst_jumpTable			; $7307
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3

@substate0:
	ld h,d			; $7310
	ld l,Interaction.var38		; $7311
	dec (hl)		; $7313
	ret nz			; $7314
	jp _ralphSubid0a@moveHorizontallyTowardRalph		; $7315

@substate1:
	ld b,$18		; $7318
	jp _ralphSubid0a@moveVerticallyTowardRalph		; $731a

@substate2:
	ldbc DIR_DOWN, $00		; $731d
	jp _ralphSubid0a@setDirectionAndAnimationWhenLinkFinishedMoving		; $7320

@substate3:
	ret			; $7323


;;
; $0b: Cutscene where Ralph tells you about getting Tune of Currents
; $10: Cutscene after talking to Cheval
; @addr{7324}
_ralphSubid0b:
_ralphSubid10:
	ld a,($cfc0)		; $7324
	or a			; $7327
	call nz,_ralphTurnLinkTowardSelf		; $7328

	ld e,Interaction.state2		; $732b
	ld a,(de)		; $732d
	rst_jumpTable			; $732e
	.dw @substate0
	.dw @substate1
	.dw _ralphRunScriptWithConditionalAnimation

@substate0:
	call interactionAnimate		; $7335
	jr _ralphRunScriptWithConditionalAnimation		; $7338

@substate1:
	; Create dust at Ralph's feet every 8 frames
	ld a,(wFrameCounter)		; $733a
	and $07			; $733d
	jr nz,_ralphRunScriptWithConditionalAnimation	; $733f

	call getFreeInteractionSlot		; $7341
	jr nz,_ralphRunScriptWithConditionalAnimation	; $7344

	ld (hl),INTERACID_PUFF		; $7346
	inc l			; $7348
	ld (hl),$81		; $7349
	ld bc,$0804		; $734b
	call objectCopyPositionWithOffset		; $734e
	jr _ralphRunScriptWithConditionalAnimation		; $7351

;;
; Runs script, deletes self when finished, and updates animations only if var3f is 0.
; @addr{7353}
_ralphRunScriptWithConditionalAnimation:
	call interactionRunScript		; $7353
	jp c,interactionDelete		; $7356

	ld e,Interaction.var3f		; $7359
	ld a,(de)		; $735b
	or a			; $735c
	jp z,interactionAnimate		; $735d
	ret			; $7360


;;
; Cutscene with Nayru and Ralph when Link exits the black tower
; @addr{7361}
_ralphSubid0e:
	ld a,(wScreenShakeCounterY)		; $7361
	cp $5a			; $7364
	jr nc,_ralphRunScriptAndDeleteWhenOver	; $7366
	or a			; $7368
	jr z,_ralphRunScriptAndDeleteWhenOver		; $7369

	ld a,(w1Link.direction)		; $736b
	sub $02			; $736e
	and $03			; $7370
	ld h,d			; $7372
	ld l,Interaction.var3f		; $7373
	cp (hl)			; $7375
	jr z,_ralphRunScriptAndDeleteWhenOver		; $7376

	ld (hl),a		; $7378
	call interactionSetAnimation		; $7379

;;
; @addr{737c}
_ralphRunScriptAndDeleteWhenOver:
	call interactionRunScript		; $737c
	jp c,interactionDelete		; $737f
	jp interactionAnimateAsNpc		; $7382


;;
; NPC after beating Veran, before beating Twinrova in a linked game
; @addr{7385}
_ralphSubid12:
	call npcFaceLinkAndAnimate		; $7385
	jp interactionRunScript		; $7388

;;
; Unused?
; @addr{738b}
_ralphFunc_738b:
	ld h,d			; $738b
	ld l,Interaction.var38		; $738c
	ld a,(hl)		; $738e
	or a			; $738f
	jr nz,++		; $7390

	ld bc,$2068		; $7392
	ld a,(wFrameCounter)		; $7395
	rrca			; $7398
	ret nc			; $7399

	ld l,Interaction.angle		; $739a
	ld a,(hl)		; $739c
	inc a			; $739d
	and $1f			; $739e
	ld (hl),a		; $73a0
	cp $0e			; $73a1
	ret nz			; $73a3
	ld l,Interaction.var38		; $73a4
	inc (hl)		; $73a6
	ld l,Interaction.angle		; $73a7
	ld (hl),$1f		; $73a9
++
	ld bc,$6890		; $73ab
	ld a,(wFrameCounter)		; $73ae
	rrca			; $73b1
	ret nc			; $73b2

	ld l,Interaction.angle		; $73b3
	ld a,(hl)		; $73b5
	dec a			; $73b6
	and $1f			; $73b7
	ld (hl),a		; $73b9
	ret			; $73ba

;;
; @addr{73bb}
_ralphTurnLinkTowardSelf:
	ld a,(w1Link.xh)		; $73bb
	add $10			; $73be
	ld b,a			; $73c0
	ld e,Interaction.xh		; $73c1
	ld a,(de)		; $73c3
	add $10			; $73c4
	sub b			; $73c6
	ld b,DIR_RIGHT		; $73c7
	jr nc,+			; $73c9
	ld b,DIR_LEFT		; $73cb
	cpl			; $73cd
+
	cp $0c			; $73ce
	jr nc,+			; $73d0
	ld b,DIR_DOWN		; $73d2
+
	ld hl,w1Link.direction		; $73d4
	ld (hl),b		; $73d7
	jp setLinkForceStateToState08		; $73d8

;;
; @addr{73db}
startJump:
	ld bc,-$1c0		; $73db
	call objectSetSpeedZ		; $73de
	ld a,SND_JUMP		; $73e1
	jp playSound		; $73e3


; ==============================================================================
; INTERACID_PAST_GIRL
; ==============================================================================
interactionCode38:
	ld e,Interaction.state		; $73e6
	ld a,(de)		; $73e8
	rst_jumpTable			; $73e9
	.dw @state0
	.dw @state1

@state0:
	ld a,$01		; $73ee
	ld (de),a		; $73f0
	call interactionInitGraphics		; $73f1
	call objectSetVisiblec2		; $73f4

	ld a,>TX_1a00		; $73f7
	call interactionSetHighTextIndex		; $73f9

	ld e,Interaction.subid		; $73fc
	ld a,(de)		; $73fe
	rst_jumpTable			; $73ff
	.dw @subid0Init

@subid0Init:
	callab interactionBank09.getGameProgress_2		; $7402

	; NPC doesn't exist between beating d2 and saving Nayru
	ld a,b			; $740a
	cp $01			; $740b
	jp z,interactionDelete		; $740d
	cp $02			; $7410
	jp z,interactionDelete		; $7412

	ld a,b			; $7415
	ld hl,@scriptTable		; $7416
	rst_addDoubleIndex			; $7419
	ldi a,(hl)		; $741a
	ld h,(hl)		; $741b
	ld l,a			; $741c
	call interactionSetScript		; $741d
	call objectMarkSolidPosition		; $7420
	jr @state1		; $7423

@state1:
	ld e,Interaction.subid		; $7425
	ld a,(de)		; $7427
	rst_jumpTable			; $7428
	.dw @subid0

@subid0:
	call interactionRunScript		; $742b
	jp interactionAnimateAsNpc		; $742e


@scriptTable:
	.dw pastGirlScript_earlyGame
	.dw pastGirlScript_afterNayruSaved
	.dw pastGirlScript_afterNayruSaved
	.dw pastGirlScript_afterNayruSaved
	.dw pastGirlScript_afterd7
	.dw pastGirlScript_afterGotMakuSeed
	.dw pastGirlScript_twinrovaKidnappedZelda
	.dw pastGirlScript_gameFinished


; ==============================================================================
; INTERACID_MONKEY
; ==============================================================================
interactionCode39:
	jpab bank3f.interactionCode39_body		; $7441


; ==============================================================================
; INTERACID_VILLAGER
;
; Variables:
;   var03: Nonzero if he's turned to stone
;   var39: For some subids, animations only update when var39 is zero
;   var3d: Saved X position?
; ==============================================================================
interactionCode3a:
	ld e,Interaction.state		; $7449
	ld a,(de)		; $744b
	rst_jumpTable			; $744c
	.dw @state0
	.dw @state1

@state0:
	ld a,$01		; $7451
	ld (de),a		; $7453

	call interactionInitGraphics		; $7454
	call objectSetVisiblec2		; $7457
	call @initSubid		; $745a

	ld e,Interaction.enabled		; $745d
	ld a,(de)		; $745f
	or a			; $7460
	jp nz,objectMarkSolidPosition		; $7461
	ret			; $7464

@initSubid:
	ld e,Interaction.subid		; $7465
	ld a,(de)		; $7467
	rst_jumpTable			; $7468
	.dw @initSubid00
	.dw @initSubid01
	.dw @initSubid02
	.dw @initSubid03
	.dw @initSubid04
	.dw @initSubid05
	.dw @initSubid06
	.dw @initSubid07
	.dw @initSubid08
	.dw @initAnimationAndLoadScript
	.dw @initSubid0a
	.dw @initSubid0b
	.dw @initSubid0c
	.dw @initSubid0d
	.dw @initSubid0e

@initSubid00:
	ld a,$03		; $7487
	jp interactionSetAnimation		; $7489

@initSubid02:
	ld e,Interaction.pressedAButton		; $748c
	call objectAddToAButtonSensitiveObjectList		; $748e

	ld e,Interaction.speed		; $7491
	ld a,SPEED_100		; $7493
	ld (de),a		; $7495

@saveXAndLoadScript:
	ld e,Interaction.xh		; $7496
	ld a,(de)		; $7498
	ld e,Interaction.var3d		; $7499
	ld (de),a		; $749b

@initSubid01:
	jp @loadScript		; $749c

@initSubid03:
	callab interactionBank09.getGameProgress_1		; $749f
	ld a,b			; $74a7
	ld hl,@subid03ScriptTable		; $74a8
	rst_addDoubleIndex			; $74ab
	ldi a,(hl)		; $74ac
	ld h,(hl)		; $74ad
	ld l,a			; $74ae
	jp interactionSetScript		; $74af

@initSubid04:
@initSubid05:
	ld a,$02		; $74b2
	ld e,Interaction.oamFlags		; $74b4
	ld (de),a		; $74b6

	callab interactionBank09.getGameProgress_1		; $74b7
	ld c,$04		; $74bf
	ld a,$03		; $74c1
	call checkNpcShouldExistAtGameStage		; $74c3
	jp nz,interactionDelete		; $74c6

	ld a,b			; $74c9
	ld hl,@subid4And5ScriptTable		; $74ca
	rst_addDoubleIndex			; $74cd
	ldi a,(hl)		; $74ce
	ld h,(hl)		; $74cf
	ld l,a			; $74d0
	jp interactionSetScript		; $74d1

@initSubid06:
@initSubid07:
	callab interactionBank09.getGameProgress_2		; $74d4
	ld c,$06		; $74dc
	ld a,$04		; $74de
	call checkNpcShouldExistAtGameStage		; $74e0
	jp nz,interactionDelete		; $74e3

	ld a,b			; $74e6
	ld hl,@subid6And7ScriptTable		; $74e7
	rst_addDoubleIndex			; $74ea
	ldi a,(hl)		; $74eb
	ld h,(hl)		; $74ec
	ld l,a			; $74ed
	jp interactionSetScript		; $74ee

@initSubid08:
	ld a,$03		; $74f1
	ld e,Interaction.oamFlags		; $74f3
	ld (de),a		; $74f5

	; Delete if you haven't beaten d7 yet?
	callab interactionBank09.getGameProgress_2		; $74f6
	ld a,b			; $74fe
	cp $04			; $74ff
	jp c,interactionDelete		; $7501

	sub $04			; $7504
	ld hl,@subid08ScriptTable		; $7506
	rst_addDoubleIndex			; $7509
	ldi a,(hl)		; $750a
	ld h,(hl)		; $750b
	ld l,a			; $750c
	jp interactionSetScript		; $750d

@initSubid0a:
	ld h,d			; $7510
	jr @loadStoneAnimation		; $7511

@initAnimationAndLoadScript:
	ld a,$01		; $7513
	call interactionSetAnimation		; $7515
	jp @loadScript		; $7518

@initSubid0c:
	; Check whether the villager should be stone right now

	; Have we beaten Veran?
	ld hl,wGroup4Flags+$fc		; $751b
	bit 7,(hl)		; $751e
	jr nz,@initAnimationAndLoadScript	; $7520

	ld a,(wEssencesObtained)		; $7522
	bit 6,a			; $7525
	jr z,@initAnimationAndLoadScript	; $7527

	ld h,d			; $7529
	ld l,Interaction.var03		; $752a
	inc (hl)		; $752c

@loadStoneAnimation:
	ld l,Interaction.oamFlags		; $752d
	ld (hl),$06		; $752f
	ld a,$06		; $7531
	call objectSetCollideRadius		; $7533
	ld a,$0d		; $7536
	jp interactionSetAnimation		; $7538

@initSubid0b:
	ld h,d			; $753b
	call @loadStoneAnimation		; $753c
	ld e,Interaction.counter1		; $753f
	ld a,$3c		; $7541
	ld (de),a		; $7543
	jr @state1		; $7544

@initSubid0d:
	call @loadScript		; $7546
	jr @state1		; $7549

@initSubid0e:
	call loadStoneNpcPalette		; $754b
	ld h,d			; $754e
	ld l,Interaction.oamFlags		; $754f
	ld (hl),$06		; $7551
	ld a,$0d		; $7553
	call interactionSetAnimation		; $7555

@state1:
	ld e,Interaction.subid		; $7558
	ld a,(de)		; $755a
	rst_jumpTable			; $755b
	.dw @runSubid00
	.dw @runSubid01
	.dw @runSubid02
	.dw @runScriptAndFaceLink
	.dw @runScriptAndFaceLink
	.dw @runScriptAndFaceLink
	.dw @runScriptAndFaceLink
	.dw @runScriptAndFaceLink
	.dw @runScriptAndFaceLink
	.dw @runSubid09
	.dw @ret
	.dw @runSubid0b
	.dw @runSubid0c
	.dw @runSubid0d
	.dw @runSubid0e


; Cutscene where guy is struck by lightning in intro
@runSubid00:
	ld e,Interaction.state2		; $757a
	ld a,(de)		; $757c
	rst_jumpTable			; $757d
	.dw @@substate0
	.dw @@substate1
	.dw @@substate2

@@substate0:
	ld a,($cfd1)		; $7584
	cp $02			; $7587
	jp nz,interactionAnimate		; $7589

	call interactionIncState2		; $758c
	ld l,Interaction.counter1		; $758f
	ld (hl),$3c		; $7591
	ld l,Interaction.xh		; $7593
	ld a,(hl)		; $7595
	ld l,Interaction.var3d		; $7596
	ld (hl),a		; $7598
	ret			; $7599

@@substate1:
	callab interactionOscillateXRandomly		; $759a
	ld a,($cfd1)		; $75a2
	cp $03			; $75a5
	ret nz			; $75a7

	call interactionIncState2		; $75a8
	ld l,Interaction.counter1		; $75ab
	ld (hl),$10		; $75ad

	call getFreePartSlot		; $75af
	ret nz			; $75b2
	ld (hl),PARTID_LIGHTNING		; $75b3

	; Write something to subid? This shouldn't matter, this lightning object doesn't
	; seem to use subid anyway.
	inc l			; $75b5
	ld (hl),e		; $75b6

	; [var03] = 1
	inc l			; $75b7
	inc (hl)		; $75b8

	jp objectCopyPosition		; $75b9

@@substate2:
	call interactionDecCounter1		; $75bc
	ret nz			; $75bf
	ld a,$04		; $75c0
	ld ($cfd1),a		; $75c2
	jp interactionDelete		; $75c5


; Past villager?
@runSubid01:
	call interactionRunScript		; $75c8
	jp interactionAnimateAsNpc		; $75cb


; Construction worker blocking path to upper part of black tower.
@runSubid02:
	ld e,Interaction.state2		; $75ce
	ld a,(de)		; $75d0
	rst_jumpTable			; $75d1
	.dw @@substate0
	.dw @@substate1

@@substate0:
	call npcFaceLinkAndAnimate		; $75d6
	call interactionRunScript		; $75d9
	ld bc,$0503		; $75dc
	call objectSetCollideRadii		; $75df

	; Temporarily overwrite the worker's X position to check for "collision" at the
	; position he's left open. His position will be reverted before returning.
	ld b,$11		; $75e2
	ld e,Interaction.direction		; $75e4
	ld a,(de)		; $75e6
	or a			; $75e7
	jr z,+			; $75e8
	ld b,$ef		; $75ea
+
	ld e,Interaction.xh		; $75ec
	ld a,(de)		; $75ee
	add b			; $75ef
	ld (de),a		; $75f0
	push bc			; $75f1
	call objectCheckCollidedWithLink_ignoreZ		; $75f2
	pop bc			; $75f5
	jr nc,++		; $75f6

	; Link tried to approach; move over to block his path
	call interactionIncState2		; $75f8
	ld hl,villagerSubid02Script_part2		; $75fb
	call interactionSetScript		; $75fe
++
	ld hl,w1Link.yh		; $7601
	ld e,Interaction.var39		; $7604
	ld a,(hl)		; $7606
	ld (de),a		; $7607
	ld bc,$0606		; $7608
	call objectSetCollideRadii		; $760b

	ld e,Interaction.var3d		; $760e
	ld a,(de)		; $7610
	ld e,Interaction.xh		; $7611
	ld (de),a		; $7613
	ret			; $7614

@@substate1:
	call interactionAnimateAsNpc		; $7615
	call interactionRunScript		; $7618
	jp nc,interactionAnimateBasedOnSpeed		; $761b

	call @saveXAndLoadScript		; $761e
	ld h,d			; $7621
	ld l,Interaction.direction		; $7622
	ld a,(hl)		; $7624
	xor $01			; $7625
	ld (hl),a		; $7627
	ld l,Interaction.state2		; $7628
	ld (hl),$00		; $762a
	jp @loadScript		; $762c


@runScriptAndFaceLink:
	call interactionRunScript		; $762f
	jp npcFaceLinkAndAnimate		; $7632


@runSubid09:
	ld e,Interaction.state2		; $7635
	ld a,(de)		; $7637
	rst_jumpTable			; $7638
	.dw @@substate0
	.dw @@substate1
	.dw @ret

@@substate0:
	call interactionRunScript		; $763f
	ld a,($cfd1)		; $7642
	cp $01			; $7645
	ret nz			; $7647
	jp interactionIncState2		; $7648

@@substate1:
	ld a,($cfd1)		; $764b
	cp $02			; $764e
	ret nz			; $7650
	call interactionIncState2		; $7651
	ld l,Interaction.oamFlags		; $7654
	ld (hl),$06		; $7656

@ret:
	ret			; $7658


; Villager being restored from stone, resumes playing catch
@runSubid0b:
	ld e,Interaction.state2		; $7659
	ld a,(de)		; $765b
	rst_jumpTable			; $765c
	.dw @@substate0
	.dw @@substate1
	.dw @@substate2

@@substate0:
	call interactionDecCounter1IfPaletteNotFading		; $7663
	ret nz			; $7666

	ld a,$01		; $7667
	ld ($cfd1),a		; $7669
	ld a,SND_RESTORE		; $766c
	call playSound		; $766e
	jpab setCounter1To120AndPlaySoundEffectAndIncState2		; $7671

@@substate1:
	call interactionDecCounter1		; $7679
	jr nz,++		; $767c

	call interactionIncState2		; $767e
	ld l,Interaction.oamFlags		; $7681
	ld (hl),$01		; $7683
	jp @loadScript		; $7685
++
	; Flicker palette every 8 frames
	ld a,(wFrameCounter)		; $7688
	and $07			; $768b
	ret nz			; $768d
	ld e,Interaction.oamFlags		; $768e
	ld a,(de)		; $7690
	dec a			; $7691
	xor $05			; $7692
	inc a			; $7694
	ld (de),a		; $7695
	ret			; $7696

@@substate2:
	ld e,Interaction.var39		; $7697
	ld a,(de)		; $7699
	or a			; $769a
	call z,interactionAnimateBasedOnSpeed		; $769b
	jp interactionRunScript		; $769e


; Villager playing catch with son
@runSubid0c:
	call interactionPushLinkAwayAndUpdateDrawPriority		; $76a1
	ld e,Interaction.var03		; $76a4
	ld a,(de)		; $76a6
	or a			; $76a7
	ret nz			; $76a8

	call interactionRunScript		; $76a9

	; If you press the A button, show text
	ld e,Interaction.pressedAButton		; $76ac
	ld a,(de)		; $76ae
	or a			; $76af
	ret z			; $76b0

	xor a			; $76b1
	ld (de),a		; $76b2
	ld bc,TX_1442		; $76b3
	ld hl,wGroup4Flags+$fc		; $76b6
	bit 7,(hl) ; Has Veran been beaten?
	jr z,+			; $76bb
	ld c,<TX_1443		; $76bd
+
	jp showText		; $76bf


; Cutscene when you first enter the past
@runSubid0d:
	call interactionRunScript		; $76c2
	jp c,interactionDelete		; $76c5
	call interactionAnimateBasedOnSpeed		; $76c8
	jp interactionPushLinkAwayAndUpdateDrawPriority		; $76cb


; Stone villager? Not much to do.
@runSubid0e:
	ret			; $76ce


@loadScript:
	ld e,Interaction.subid		; $76cf
	ld a,(de)		; $76d1
	ld hl,@scriptTable		; $76d2
	rst_addDoubleIndex			; $76d5
	ldi a,(hl)		; $76d6
	ld h,(hl)		; $76d7
	ld l,a			; $76d8
	jp interactionSetScript		; $76d9


@scriptTable:
	.dw stubScript
	.dw villagerSubid01Script
	.dw villagerSubid02Script_part1
	.dw stubScript
	.dw stubScript
	.dw stubScript
	.dw stubScript
	.dw stubScript
	.dw stubScript
	.dw villagerSubid09Script
	.dw stubScript
	.dw villagerSubid0bScript
	.dw villagerSubid0cScript
	.dw villagerSubid0dScript


@subid03ScriptTable:
	.dw villagerSubid03Script_befored3
	.dw villagerSubid03Script_afterd3
	.dw villagerSubid03Script_afterNayruSaved
	.dw villagerSubid03Script_afterd7
	.dw villagerSubid03Script_afterGotMakuSeed
	.dw villagerSubid03Script_postGame


@subid4And5ScriptTable:
	.dw villagerSubid4And5Script_befored3
	.dw villagerSubid4And5Script_afterd3
	.dw villagerSubid4And5Script_afterGotMakuSeed
	.dw villagerSubid4And5Script_afterGotMakuSeed
	.dw villagerSubid4And5Script_afterGotMakuSeed
	.dw villagerSubid4And5Script_postGame

@subid6And7ScriptTable:
	.dw villagerSubid6And7Script_befored2
	.dw villagerSubid6And7Script_afterd2
	.dw villagerSubid6And7Script_afterd4
	.dw villagerSubid6And7Script_afterNayruSaved
	.dw villagerSubid6And7Script_afterd7
	.dw villagerSubid6And7Script_afterGotMakuSeed
	.dw villagerSubid6And7Script_twinrovaKidnappedZelda
	.dw villagerSubid6And7Script_postGame

@subid08ScriptTable:
	.dw villagerSubid08Script_afterd7
	.dw villagerSubid08Script_afterGotMakuSeed
	.dw villagerSubid08Script_twinrovaKidnappedZelda
	.dw villagerSubid08Script_postGame


; ==============================================================================
; INTERACID_FEMALE_VILLAGER
; ==============================================================================
interactionCode3b:
	ld e,Interaction.state		; $7728
	ld a,(de)		; $772a
	rst_jumpTable			; $772b
	.dw @state0
	.dw @state1

@state0:
	ld a,$01		; $7730
	ld (de),a		; $7732

	call interactionInitGraphics		; $7733
	call objectSetVisiblec2		; $7736
	call @initSubid		; $7739

	ld e,Interaction.enabled		; $773c
	ld a,(de)		; $773e
	or a			; $773f
	jp nz,objectMarkSolidPosition		; $7740
	ret			; $7743

@initSubid:
	ld e,Interaction.subid		; $7744
	ld a,(de)		; $7746
	rst_jumpTable			; $7747
	.dw @initSubid00
	.dw @initSubid01
	.dw @initSubid02
	.dw @initSubid03
	.dw @initSubid04
	.dw @initSubid05
	.dw @initSubid06
	.dw @initSubid07
	.dw @initSubid08

@initSubid00:
	ld a,$01		; $775a
	jp interactionSetAnimation		; $775c

@initSubid01:
@initSubid02:
	callab interactionBank09.getGameProgress_1		; $775f
	ld c,$01		; $7767
	xor a			; $7769
	call checkNpcShouldExistAtGameStage		; $776a
	jp nz,interactionDelete		; $776d

	ld a,b			; $7770
	ld hl,@subid1And2ScriptTable		; $7771
	rst_addDoubleIndex			; $7774
	ldi a,(hl)		; $7775
	ld h,(hl)		; $7776
	ld l,a			; $7777
	call interactionSetScript		; $7778
	jp objectSetVisible82		; $777b

@initSubid03:
@initSubid04:
	callab interactionBank09.getGameProgress_2		; $777e
	ld c,$03		; $7786
	ld a,$01		; $7788
	call checkNpcShouldExistAtGameStage		; $778a
	jp nz,interactionDelete		; $778d

	ld a,b			; $7790
	ld hl,@subid3And4ScriptTable		; $7791
	rst_addDoubleIndex			; $7794
	ldi a,(hl)		; $7795
	ld h,(hl)		; $7796
	ld l,a			; $7797
	call interactionSetScript		; $7798
	jp objectSetVisible82		; $779b

@initSubid05:
	ld a,$01		; $779e
	ld e,Interaction.oamFlags		; $77a0
	ld (de),a		; $77a2
	callab interactionBank09.getGameProgress_2		; $77a3
	ld c,$05		; $77ab
	ld a,$02		; $77ad
	call checkNpcShouldExistAtGameStage		; $77af
	jp nz,interactionDelete		; $77b2

	ld a,b			; $77b5
	ld hl,@subid5ScriptTable		; $77b6
	rst_addDoubleIndex			; $77b9
	ldi a,(hl)		; $77ba
	ld h,(hl)		; $77bb
	ld l,a			; $77bc
	call interactionSetScript		; $77bd
	jp objectSetVisible82		; $77c0

@initSubid07:
	ld a,GLOBALFLAG_WATER_POLLUTION_FIXED		; $77c3
	call checkGlobalFlag		; $77c5
	ld a,<TX_1526		; $77c8
	jr z,+			; $77ca
	ld a,<TX_1527		; $77cc
+
	ld e,Interaction.textID		; $77ce
	ld (de),a		; $77d0

	inc e			; $77d1
	ld a,>TX_1500		; $77d2
	ld (de),a		; $77d4

	xor a			; $77d5
	call interactionSetAnimation		; $77d6

	ld hl,villagerGalSubid07Script		; $77d9
	jp interactionSetScript		; $77dc

@initSubid08:
	ld e,Interaction.textID		; $77df
	ld a,<TX_0f03		; $77e1
	ld (de),a		; $77e3
	inc e			; $77e4
	ld a,>TX_0f03		; $77e5
	ld (de),a		; $77e7

	ld hl,genericNpcScript		; $77e8
	jp interactionSetScript		; $77eb

@initSubid06:
	ld a,$05		; $77ee
	ld e,Interaction.var3f		; $77f0
	ld (de),a		; $77f2
	ld hl,linkedGameNpcScript		; $77f3
	call interactionSetScript		; $77f6
	call interactionRunScript		; $77f9

@state1:
	ld e,Interaction.subid		; $77fc
	ld a,(de)		; $77fe
	rst_jumpTable			; $77ff
	.dw @runSubid00
	.dw @runScriptAndAnimateFacingLink
	.dw @runScriptAndAnimateFacingLink
	.dw @runScriptAndAnimateFacingLink
	.dw @runScriptAndAnimateFacingLink
	.dw @runScriptAndAnimateFacingLink
	.dw @runSubid06
	.dw @runSubid07
	.dw @runScriptAndAnimateFacingLink


; Cutscene where guy is struck by lightning in intro
@runSubid00:
	ld e,Interaction.state2		; $7812
	ld a,(de)		; $7814
	rst_jumpTable			; $7815
	.dw @@substate0
	.dw @@substate1
	.dw @@substate2
	.dw @@substate3
	.dw @@substate4

@@substate0:
	ld a,($cfd1)		; $7820
	cp $02			; $7823
	jp nz,interactionAnimate		; $7825

	call interactionIncState2		; $7828
	ld l,Interaction.xh		; $782b
	ld a,(hl)		; $782d
	ld l,Interaction.var3d		; $782e
	ld (hl),a		; $7830
	ret			; $7831

@@substate1:
	callab interactionOscillateXRandomly		; $7832
	ld a,($cfd1)		; $783a
	cp $04			; $783d
	ret nz			; $783f

	call interactionIncState2		; $7840
	ld l,Interaction.counter1		; $7843
	ld (hl),$1e		; $7845
	ret			; $7847

@@substate2:
	call interactionDecCounter1		; $7848
	ret nz			; $784b

	ld bc,-$1c0		; $784c
	call objectSetSpeedZ		; $784f
	ld a,SND_JUMP		; $7852
	call playSound		; $7854
	jp interactionIncState2		; $7857

@@substate3:
	ld c,$20		; $785a
	call objectUpdateSpeedZ_paramC		; $785c
	ret nz			; $785f

	call interactionIncState2		; $7860
	jp @loadScript		; $7863

@@substate4:
	call interactionAnimate2Times		; $7866
	call interactionRunScript		; $7869
	ret nc			; $786c
	jp interactionDelete		; $786d


; Generic NPCs
@runScriptAndAnimateFacingLink:
	call interactionRunScript		; $7870
	jp npcFaceLinkAndAnimate		; $7873

; Linked game NPC
@runSubid06:
	call interactionRunScript		; $7876
	jp c,interactionDelete		; $7879
	jp npcFaceLinkAndAnimate		; $787c

; NPC in eyeglasses library (present)
@runSubid07:
	call interactionRunScript		; $787f
	jp interactionAnimateAsNpc		; $7882


@loadScript:
	ld e,Interaction.subid		; $7885
	ld a,(de)		; $7887
	ld hl,@scriptTable		; $7888
	rst_addDoubleIndex			; $788b
	ldi a,(hl)		; $788c
	ld h,(hl)		; $788d
	ld l,a			; $788e
	jp interactionSetScript		; $788f


@scriptTable:
	.dw villagerGalSubid00Script
	.dw stubScript
	.dw stubScript
	.dw stubScript
	.dw stubScript
	.dw stubScript
	.dw stubScript

@subid1And2ScriptTable:
	.dw villagerGalSubid1And2Script_befored3
	.dw villagerGalSubid1And2Script_afterd3
	.dw villagerGalSubid1And2Script_afterNayruSaved
	.dw villagerGalSubid1And2Script_afterd7
	.dw villagerGalSubid1And2Script_afterGotMakuSeed
	.dw villagerGalSubid1And2Script_postGame

@subid3And4ScriptTable:
	.dw villagerGalSubid3And4Script_befored2
	.dw villagerGalSubid3And4Script_afterd2
	.dw villagerGalSubid3And4Script_afterd4
	.dw villagerGalSubid3And4Script_afterNayruSaved
	.dw villagerGalSubid3And4Script_afterd7
	.dw villagerGalSubid3And4Script_afterGotMakuSeed
	.dw villagerGalSubid3And4Script_twinrovaKidnappedZelda
	.dw villagerGalSubid3And4Script_postGame

@subid5ScriptTable:
	.dw villagerGalSubid05Script_befored2
	.dw villagerGalSubid05Script_afterd2
	.dw villagerGalSubid05Script_afterd4
	.dw villagerGalSubid05Script_afterNayruSaved
	.dw villagerGalSubid05Script_afterd7
	.dw villagerGalSubid05Script_afterd7
	.dw villagerGalSubid05Script_twinrovaKidnappedZelda
	.dw villagerGalSubid05Script_twinrovaKidnappedZelda ; Not used


; ==============================================================================
; INTERACID_BOY
; ==============================================================================
interactionCode3c:
	ld e,Interaction.state		; $78cc
	ld a,(de)		; $78ce
	rst_jumpTable			; $78cf
	.dw @state0
	.dw _boyState1

@state0:
	ld a,$01		; $78d4
	ld (de),a		; $78d6

	call interactionInitGraphics		; $78d7
	call objectSetVisiblec2		; $78da
	call @initSubid		; $78dd

	ld e,Interaction.enabled		; $78e0
	ld a,(de)		; $78e2
	or a			; $78e3
	jp nz,objectMarkSolidPosition		; $78e4
	ret			; $78e7

@initSubid:
	ld e,Interaction.subid		; $78e8
	ld a,(de)		; $78ea
	rst_jumpTable			; $78eb
	.dw @initSubid00
	.dw @initSubid01
	.dw @initSubid02
	.dw @initSubid03
	.dw @initSubid04
	.dw @initSubid05
	.dw @setStoneAnimationAndLoadScript
	.dw @initSubid07
	.dw @initSubid08
	.dw @initSubid09
	.dw @setStoneAnimationAndLoadScript
	.dw @initSubid0b
	.dw @setStoneAnimationAndLoadScript
	.dw @initSubid0d
	.dw @initSubid0e
	.dw @initSubid0f
	.dw @initSubid10


@initSubid03:
	call getThisRoomFlags		; $790e
	bit 6,a			; $7911
	jp nz,interactionDelete		; $7913

	call @saveXToVar3d		; $7916
	ld a,$01		; $7919
	ld (wDisabledObjects),a		; $791b
	ld (wMenuDisabled),a		; $791e

	jr @setRedPaletteAndLoadScript		; $7921

@initSubid01:
	ld a,$01		; $7923
	call interactionSetAnimation		; $7925

@setRedPaletteAndLoadScript:
	ld a,$02		; $7928
	ld e,Interaction.oamFlags		; $792a
	ld (de),a		; $792c
	jp _boyLoadScript		; $792d

@initSubid04:
	call getThisRoomFlags		; $7930
	bit 6,a			; $7933
	jp nz,interactionDelete		; $7935

	ld e,Interaction.counter1		; $7938
	ld a,$3c		; $793a
	ld (de),a		; $793c
	xor a			; $793d
	call interactionSetAnimation		; $793e

@saveXToVar3d:
	ld e,Interaction.xh		; $7941
	ld a,(de)		; $7943
	ld e,Interaction.var3d		; $7944
	ld (de),a		; $7946
	ret			; $7947

@initSubid05:
	call loadStoneNpcPalette		; $7948
	ld e,Interaction.oamFlags		; $794b
	ld a,$06		; $794d
	ld (de),a		; $794f
	ld e,Interaction.counter1		; $7950
	ld a,$3c		; $7952
	ld (de),a		; $7954
	ld a,$03		; $7955
	jp interactionSetAnimation		; $7957

@setStoneAnimationAndLoadScript:
	ld a,$03		; $795a
	call interactionSetAnimation		; $795c
	ld a,$02		; $795f
	ld e,Interaction.var38		; $7961
	ld (de),a		; $7963
	call loadStoneNpcPalette		; $7964
	jp _boyLoadScript		; $7967

@initSubid0e:
	; Was Veran defeated?
	ld hl,wGroup4Flags+$fc		; $796a
	bit 7,(hl)		; $796d
	ld a,<TX_251e		; $796f
	jr nz,@@notStone	; $7971

	ld a,(wEssencesObtained)		; $7973
	bit 6,a			; $7976
	ld a,<TX_251d		; $7978
	jr z,@@notStone	; $797a

	; If Veran's not defeated and d7 is beaten, change position to be in front of his
	; stone dad
	call objectUnmarkSolidPosition		; $797c
	ld bc,$4848		; $797f
	call interactionSetPosition		; $7982
	call objectMarkSolidPosition		; $7985

	ld h,d			; $7988
	ld l,Interaction.var03		; $7989
	inc (hl)		; $798b

	ld a,$06		; $798c
	call objectSetCollideRadius		; $798e
	ld e,Interaction.pressedAButton		; $7991
	call objectAddToAButtonSensitiveObjectList		; $7993

	ld a,<TX_251b		; $7996
	jr @setTextIDAndLoadScript		; $7998

@@notStone:
	push af			; $799a
	xor a			; $799b
	ld ($cfd3),a		; $799c

	ldbc INTERACID_BALL,$00		; $799f
	call objectCreateInteraction		; $79a2
	ld bc,$4a75		; $79a5
	call interactionHSetPosition		; $79a8

	pop af			; $79ab

@setTextIDAndLoadScript:
	ld e,Interaction.textID		; $79ac
	ld (de),a		; $79ae
	jr @setStoneAnimationAndLoadScript		; $79af

@initSubid00:
	xor a			; $79b1
	call interactionSetAnimation		; $79b2
	jp _boyLoadScript		; $79b5

@initSubid02:
	callab interactionBank09.getGameProgress_1		; $79b8
	ld a,b			; $79c0
	or a			; $79c1
	jr nz,++		; $79c2

	; In the early game, the boy only exists once you've gotten the satchel
	ld a,TREASURE_SEED_SATCHEL		; $79c4
	call checkTreasureObtained		; $79c6
	jp nc,interactionDelete		; $79c9
	xor a			; $79cc
++
	ld hl,_boySubid02ScriptTable		; $79cd
	rst_addDoubleIndex			; $79d0
	ldi a,(hl)		; $79d1
	ld h,(hl)		; $79d2
	ld l,a			; $79d3
	call interactionSetScript		; $79d4
	jr _boyState1		; $79d7

@initSubid07:
	ld h,d			; $79d9
	ld l,Interaction.var3f		; $79da
	inc (hl)		; $79dc
	call _boyLoadScript		; $79dd
	jr _boyState1		; $79e0

@initSubid08:
@initSubid09:
	ld h,d			; $79e2
	ld l,Interaction.counter1		; $79e3
	ld (hl),$78		; $79e5
	jp objectSetVisiblec1		; $79e7

@initSubid0b:
	xor a			; $79ea
	call interactionSetAnimation		; $79eb
	ld a,GLOBALFLAG_WATER_POLLUTION_FIXED		; $79ee
	call checkGlobalFlag		; $79f0
	ld a,<TX_2519		; $79f3
	jr z,+			; $79f5
	ld a,<TX_251a		; $79f7
+
	ld e,Interaction.textID		; $79f9
	ld (de),a		; $79fb
	inc e			; $79fc
	ld a,>TX_2500		; $79fd
	ld (de),a		; $79ff
	jp _boyLoadScript		; $7a00

@initSubid0d:
	ld a,GLOBALFLAG_SAVED_NAYRU		; $7a03
	call checkGlobalFlag		; $7a05
	jr nz,@@notStone		; $7a08

	call loadStoneNpcPalette		; $7a0a
	ld h,d			; $7a0d
	ld l,Interaction.oamFlags		; $7a0e
	ld (hl),$06		; $7a10
	ld a,$06		; $7a12
	call objectSetCollideRadius		; $7a14
	ld l,Interaction.var03		; $7a17
	inc (hl)		; $7a19
	ld a,$0c		; $7a1a
	jp interactionSetAnimation		; $7a1c

@@notStone:
	ld bc,$4868		; $7a1f
	call interactionSetPosition		; $7a22

	; Load red palette
	ld l,Interaction.oamFlags		; $7a25
	ld (hl),$02		; $7a27

	jp _boyLoadScript		; $7a29

@initSubid10:
	ld a,GLOBALFLAG_FINISHEDGAME		; $7a2c
	call checkGlobalFlag		; $7a2e
	jp z,interactionDelete		; $7a31

@initSubid0f:
	jp _boyLoadScript		; $7a34

;;
; @addr{7a37}
_boyState1:
	ld e,Interaction.subid		; $7a37
	ld a,(de)		; $7a39
	rst_jumpTable			; $7a3a
	.dw _boyRunSubid00
	.dw _boyRunSubid01
	.dw _boyRunSubid02
	.dw  boyRunSubid03
	.dw _boyRunSubid04
	.dw _boyRunSubid05
	.dw _boyRunSubid06
	.dw _boyRunSubid07
	.dw  boyRunSubid08
	.dw  boyRunSubid09
	.dw _boyRunSubid0a
	.dw _boyRunSubid0b
	.dw _boyRunSubid0c
	.dw _boyRunSubid0d
	.dw _boyRunSubid0e
	.dw _boyRunSubid0f
	.dw _boyRunSubid10


; Watching Nayru sing in intro
_boyRunSubid00:
	call interactionAnimate		; $7a5d
	call objectSetPriorityRelativeToLink_withTerrainEffects		; $7a60

	ld e,Interaction.state2		; $7a63
	ld a,(de)		; $7a65
	or a			; $7a66
	call z,objectPreventLinkFromPassing		; $7a67

	ld e,Interaction.state2		; $7a6a
	ld a,(de)		; $7a6c
	rst_jumpTable			; $7a6d
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3

@substate0:
	ld a,($cfd0)		; $7a76
	cp $0e			; $7a79
	jp nz,interactionRunScript		; $7a7b

	call interactionIncState2		; $7a7e
	ld a,$02		; $7a81
	jp interactionSetAnimation		; $7a83

@substate1:
	call interactionAnimate		; $7a86
	ld a,($cfd0)		; $7a89
	cp $10			; $7a8c
	ret nz			; $7a8e

	call interactionIncState2		; $7a8f
	ld bc,-$180		; $7a92
	call objectSetSpeedZ		; $7a95
	ld a,$02		; $7a98
	jp interactionSetAnimation		; $7a9a

@substate2:
	ld c,$20		; $7a9d
	call objectUpdateSpeedZ_paramC		; $7a9f
	ret nz			; $7aa2

	; Run away
	call interactionIncState2		; $7aa3
	ld l,Interaction.angle		; $7aa6
	ld (hl),$02		; $7aa8
	ld l,Interaction.speed		; $7aaa
	ld (hl),SPEED_180		; $7aac
	xor a			; $7aae
	jp interactionSetAnimation		; $7aaf

@substate3:
	call objectCheckWithinScreenBoundary		; $7ab2
	jp nc,interactionDelete		; $7ab5
	jp objectApplySpeed		; $7ab8


; Kid turning to stone cutscene
_boyRunSubid01:
	ld e,Interaction.state2		; $7abb
	ld a,(de)		; $7abd
	rst_jumpTable			; $7abe
	.dw @substate0
	.dw @substate1
	.dw @substate2

@substate0:
	call interactionRunScript		; $7ac5
	ld a,($cfd1)		; $7ac8
	cp $01			; $7acb
	jr nz,+			; $7acd
	jp interactionIncState2		; $7acf
+
	ld e,Interaction.counter2		; $7ad2
	ld a,(de)		; $7ad4
	or a			; $7ad5
	ret z			; $7ad6
	jp interactionAnimate2Times		; $7ad7

@substate1:
	call interactionRunScript		; $7ada
	ld a,($cfd1)		; $7add
	cp $02			; $7ae0
	jr nz,++		; $7ae2

	call interactionIncState2		; $7ae4
	ld l,Interaction.oamFlags		; $7ae7
	ld (hl),$06		; $7ae9
	ret			; $7aeb
++
	; Flicker palette from red to stone every 8 frames
	ld a,(wFrameCounter)		; $7aec
	and $07			; $7aef
	ret nz			; $7af1
	ld e,Interaction.oamFlags		; $7af2
	ld a,(de)		; $7af4
	xor $04			; $7af5
	ld (de),a		; $7af7
	ret			; $7af8

@substate2:
	call interactionRunScript		; $7af9
	jp nc,interactionAnimate		; $7afc
	ret			; $7aff


; Kid outside shop
_boyRunSubid02:
	call interactionRunScript		; $7b00
	jp npcFaceLinkAndAnimate		; $7b03


; Cutscene where kids talk about how they're scared of a ghost (red kid)
; Also called the "other" child interaction?
boyRunSubid03:
	call interactionRunScript		; $7b06

	ld e,Interaction.var39		; $7b09
	ld a,(de)		; $7b0b
	or a			; $7b0c
	call z,interactionAnimateBasedOnSpeed		; $7b0d

	call objectCheckWithinScreenBoundary		; $7b10
	ret c			; $7b13

	xor a			; $7b14
	ld (wDisabledObjects),a		; $7b15
	ld (wMenuDisabled),a		; $7b18
	call getThisRoomFlags		; $7b1b
	set 6,(hl)		; $7b1e
	jp interactionDelete		; $7b20


; Cutscene where kids talk about how they're scared of a ghost (green kid)
_boyRunSubid04:
	ld e,Interaction.state2		; $7b23
	ld a,(de)		; $7b25
	rst_jumpTable			; $7b26
	.dw @substate0
	.dw @substate1
	.dw boyRunSubid03

@substate0:
	call interactionAnimate		; $7b2d
	call interactionDecCounter1		; $7b30
	ret nz			; $7b33
	call interactionIncState2		; $7b34
	jp startJump		; $7b37

@substate1:
	ld c,$20		; $7b3a
	call objectUpdateSpeedZ_paramC		; $7b3c
	ret nz			; $7b3f
	call interactionIncState2		; $7b40
	jp _boyLoadScript		; $7b43


; Cutscene where kid is restored from stone
_boyRunSubid05:
	ld e,Interaction.state2		; $7b46
	ld a,(de)		; $7b48
	rst_jumpTable			; $7b49
	.dw @substate0
	.dw _childSubid05Substate1
	.dw _childAnimateIfVar39IsZeroAndRunScript

@substate0:
	call interactionDecCounter1		; $7b50
	ret nz			; $7b53

;;
; Used in cutscenes where people get restored from stone?
; @addr{7b54}
setCounter1To120AndPlaySoundEffectAndIncState2:
	ld a,120		; $7b54
	ld e,Interaction.counter1		; $7b56
	ld (de),a		; $7b58
	ld a,SND_ENERGYTHING		; $7b59
	call playSound		; $7b5b
	jp interactionIncState2		; $7b5e


_childSubid05Substate1:
	call interactionDecCounter1		; $7b61
	jr nz,childFlickerBetweenStone		; $7b64

	call interactionIncState2		; $7b66
	ld l,Interaction.oamFlags		; $7b69
	ld (hl),$02		; $7b6b
	jp _boyLoadScript		; $7b6d

;;
; Called from other interactions as well?
childFlickerBetweenStone:
	ld a,(wFrameCounter)		; $7b70
	and $07			; $7b73
	ret nz			; $7b75
	ld e,Interaction.oamFlags		; $7b76
	ld a,(de)		; $7b78
	xor $04			; $7b79
	ld (de),a		; $7b7b
	ret			; $7b7c

_childAnimateIfVar39IsZeroAndRunScript:
	ld e,Interaction.var39		; $7b7d
	ld a,(de)		; $7b7f
	or a			; $7b80
	call z,interactionAnimateBasedOnSpeed		; $7b81
	jp interactionRunScript		; $7b84


; Cutscene where kid sees his dad turn to stone
_boyRunSubid06:
	call checkInteractionState2		; $7b87
	call nz,interactionAnimateBasedOnSpeed		; $7b8a
	jp interactionRunScript		; $7b8d


; Depressed kid in trade sequence
_boyRunSubid07:
	call interactionRunScript		; $7b90
	ld e,Interaction.var3d		; $7b93
	ld a,(de)		; $7b95
	or a			; $7b96
	jp z,npcFaceLinkAndAnimate		; $7b97
	call interactionAnimate		; $7b9a
	jp objectSetPriorityRelativeToLink_withTerrainEffects		; $7b9d


; Kid who runs around in a pattern? Used in a credits cutscene maybe?
; Also called by another interaction?
boyRunSubid08:
boyRunSubid09:
	ld e,Interaction.state2		; $7ba0
	ld a,(de)		; $7ba2
	rst_jumpTable			; $7ba3
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3
	.dw @substate4
	.dw @substate5
	.dw @substate6
	.dw @substate7
	.dw @substate8
	.dw @substate9
	.dw @substateA
	.dw @substateB

@substate0:
	call interactionDecCounter1		; $7bbc
	ret nz			; $7bbf
	ld (hl),$66		; $7bc0

	ld l,Interaction.speed		; $7bc2
	ld (hl),SPEED_140		; $7bc4
	ld l,Interaction.angle		; $7bc6
	ld (hl),$18		; $7bc8

	call interactionIncState2		; $7bca

@setAnimationFromAngle:
	ld e,Interaction.angle		; $7bcd
	ld a,(de)		; $7bcf
	call convertAngleDeToDirection		; $7bd0
	jp interactionSetAnimation		; $7bd3


@substate1:
	call @updateAnimationTwiceAndApplySpeed		; $7bd6
	call interactionDecCounter1		; $7bd9
	ret nz			; $7bdc

	call getRandomNumber		; $7bdd
	and $0f			; $7be0
	add $1e			; $7be2
	ld (hl),a		; $7be4

	ld l,Interaction.angle		; $7be5
	ld (hl),$08		; $7be7
	call @setAnimationFromAngle		; $7be9
	jp interactionIncState2		; $7bec

@updateAnimationTwiceAndApplySpeed:
	call interactionAnimate2Times		; $7bef
	jp objectApplySpeed		; $7bf2


@substate2:
	call interactionDecCounter1		; $7bf5
	ret nz			; $7bf8
	call _boyStartHop		; $7bf9
	jp interactionIncState2		; $7bfc

@substate3:
	call _boyUpdateGravityAndHopWhenLanded		; $7bff
	ld a,($cfd0)		; $7c02
	cp $01			; $7c05
	ret nz			; $7c07

	ld e,Interaction.zh		; $7c08
	ld a,(de)		; $7c0a
	or a			; $7c0b
	ret nz			; $7c0c

	call interactionIncState2		; $7c0d
	ld l,Interaction.counter1		; $7c10
	ld (hl),$1e		; $7c12
	ret			; $7c14

@substate4:
	call interactionDecCounter1		; $7c15
	ret nz			; $7c18

	ld l,Interaction.speed		; $7c19
	ld (hl),SPEED_200		; $7c1b
	call @updateAngleAndCounter		; $7c1d
	jp interactionIncState2		; $7c20

@substate5:
	ld a,($cfd0)		; $7c23
	cp $02			; $7c26
	jr nz,++		; $7c28
	ld e,Interaction.zh		; $7c2a
	ld a,(de)		; $7c2c
	or a			; $7c2d
	jr nz,++		; $7c2e

	call interactionIncState2		; $7c30

	ld l,Interaction.counter1		; $7c33
	ld (hl),$0a		; $7c35
	ld l,Interaction.angle		; $7c37
	ld (hl),$18		; $7c39
	jp @setAnimationFromAngle		; $7c3b
++
	ld e,Interaction.var37		; $7c3e
	ld a,(de)		; $7c40
	rst_jumpTable			; $7c41
	.dw @@val0
	.dw @@val1
	.dw @@val2

@@val0:
	call @updateAnimationTwiceAndApplySpeed		; $7c48
	call interactionDecCounter1		; $7c4b
	ret nz			; $7c4e
	ld (hl),$0a		; $7c4f

	ld l,Interaction.var37		; $7c51
	inc (hl)		; $7c53
	cp $68			; $7c54
	ld a,$01		; $7c56
	jr c,+			; $7c58
	ld a,$03		; $7c5a
+
	jp interactionSetAnimation		; $7c5c

@@val1:
	call interactionDecCounter1		; $7c5f
	ret nz			; $7c62
	ld (hl),$1e		; $7c63
	ld l,Interaction.var37		; $7c65
	inc (hl)		; $7c67
	jp _boyStartHop		; $7c68

@@val2:
	call _boyUpdateGravityAndHopWhenLanded		; $7c6b
	call interactionDecCounter1		; $7c6e
	ret nz			; $7c71

	xor a			; $7c72
	ld l,Interaction.z		; $7c73
	ldi (hl),a		; $7c75
	ld (hl),a		; $7c76

	ld l,Interaction.var37		; $7c77
	ld (hl),$00		; $7c79

;;
; @addr{7c7b}
@updateAngleAndCounter:
	ld e,Interaction.id		; $7c7b
	ld a,(de)		; $7c7d
	cp INTERACID_BOY			; $7c7e
	jr z,@boy		; $7c80

	; Which interaction is this for?
	ld a,$02		; $7c82
	jr ++			; $7c84

@boy:
	ld e,Interaction.subid		; $7c86
	ld a,(de)		; $7c88
	sub $08			; $7c89
++
	; a *= 9
	ld b,a			; $7c8b
	swap a			; $7c8c
	sra a			; $7c8e
	add b			; $7c90

	ld hl,@movementData		; $7c91
	rst_addAToHl			; $7c94
	ld e,Interaction.counter2		; $7c95
	ld a,(de)		; $7c97
	rst_addDoubleIndex			; $7c98

	ldi a,(hl)		; $7c99
	ld b,(hl)		; $7c9a
	inc l			; $7c9b
	ld e,Interaction.counter1		; $7c9c
	ld (de),a		; $7c9e
	ld e,Interaction.angle		; $7c9f
	ld a,b			; $7ca1
	ld (de),a		; $7ca2

	ld e,Interaction.counter2		; $7ca3
	ld a,(de)		; $7ca5
	ld b,a			; $7ca6
	inc b			; $7ca7
	ld a,(hl)		; $7ca8
	or a			; $7ca9
	jr nz,+			; $7caa
	ld b,$00		; $7cac
+
	ld a,b			; $7cae
	ld (de),a		; $7caf
	jp @setAnimationFromAngle		; $7cb0


; Data format:
;   b0: Number of frames to move
;   b1: Angle to move in
@movementData:
	.db $1a $09 ; Subid $08
	.db $16 $1f
	.db $17 $17
	.db $0c $0f
	.db $00

	.db $0c $09 ; Subid $09
	.db $18 $0a
	.db $16 $18
	.db $12 $1f
	.db $00

	.db $1d $08 ; Subid $0a
	.db $19 $16
	.db $18 $0a
	.db $06 $01
	.db $00

@substate6:
	call interactionDecCounter1		; $7cce
	ret nz			; $7cd1

	ld e,Interaction.id		; $7cd2
	ld a,(de)		; $7cd4
	ld b,$34		; $7cd5
	cp INTERACID_BOY_2			; $7cd7
	jr z,+			; $7cd9
	ld b,$20		; $7cdb
+
	ld (hl),b		; $7cdd
	ld l,Interaction.speed		; $7cde
	ld (hl),SPEED_180		; $7ce0
	jp interactionIncState2		; $7ce2


@substate7:
	call @updateAnimationTwiceAndApplySpeed		; $7ce5
	call interactionDecCounter1		; $7ce8
	ret nz			; $7ceb

	call getRandomNumber		; $7cec
	and $07			; $7cef
	inc a			; $7cf1
	ld (hl),a		; $7cf2

	ld a,$01		; $7cf3
	call interactionSetAnimation		; $7cf5
	jp interactionIncState2		; $7cf8


; Waiting for signal to start hopping again
@substate8:
	ld a,($cfd0)		; $7cfb
	cp $03			; $7cfe
	ret nz			; $7d00
	call interactionDecCounter1		; $7d01
	ret nz			; $7d04
	call interactionIncState2		; $7d05
	jp _boyStartHop		; $7d08


; Waiting for signal to move off the left side of the screen
@substate9:
	call _boyUpdateGravityAndHopWhenLanded		; $7d0b

	ld a,($cfd0)		; $7d0e
	cp $04			; $7d11
	ret nz			; $7d13
	ld e,Interaction.zh		; $7d14
	ld a,(de)		; $7d16
	or a			; $7d17
	ret nz			; $7d18

	call interactionIncState2		; $7d19
	ld l,Interaction.counter1		; $7d1c
	ld (hl),$0c		; $7d1e
	ret			; $7d20

@substateA:
	call interactionDecCounter1		; $7d21
	ret nz			; $7d24

	call interactionIncState2		; $7d25
	ld l,Interaction.counter1		; $7d28
	ld (hl),$50		; $7d2a
	ld l,Interaction.speed		; $7d2c
	ld (hl),SPEED_180		; $7d2e
	ld a,$03		; $7d30
	jp interactionSetAnimation		; $7d32

@substateB:
	call @updateAnimationTwiceAndApplySpeed		; $7d35
	call interactionDecCounter1		; $7d38
	jp z,interactionDelete		; $7d3b
	ret			; $7d3e


; Cutscene?
_boyRunSubid0a:
	call interactionAnimate		; $7d3f
	jp _childAnimateIfVar39IsZeroAndRunScript		; $7d42


; NPC in eyeglasses library present
_boyRunSubid0b:
	call interactionRunScript		; $7d45
	jp interactionAnimateAsNpc		; $7d48


; Cutscene where kid's dad gets restored from stone
_boyRunSubid0c:
	ld e,Interaction.state2		; $7d4b
	ld a,(de)		; $7d4d
	rst_jumpTable			; $7d4e
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3
	.dw @substate4
	.dw _childAnimateIfVar39IsZeroAndRunScript

@substate0:
	call interactionAnimate2Times		; $7d5b
	ld a,($cfd1)		; $7d5e
	cp $01			; $7d61
	ret nz			; $7d63

	call interactionIncState2		; $7d64
	ld l,Interaction.counter1		; $7d67
	ld (hl),$78		; $7d69

	ld a,$03		; $7d6b
	call interactionSetAnimation		; $7d6d

	ld a,$3c		; $7d70
	ld bc,$f408		; $7d72
	jp objectCreateExclamationMark		; $7d75

@substate1:
	call interactionDecCounter1		; $7d78
	ret nz			; $7d7b
	call interactionIncState2		; $7d7c
	ld bc,-$1c0		; $7d7f
	jp objectSetSpeedZ		; $7d82

@substate2:
	ld c,$20		; $7d85
	call objectUpdateSpeedZ_paramC		; $7d87
	ret nz			; $7d8a

	ld a,$02		; $7d8b
	ld ($cfd1),a		; $7d8d
	call interactionIncState2		; $7d90
	ld l,Interaction.counter1		; $7d93
	ld (hl),120		; $7d95
	ret			; $7d97

@substate3:
	call interactionDecCounter1		; $7d98
	ret nz			; $7d9b
	ld (hl),$3c		; $7d9c
	jp interactionIncState2		; $7d9e

@substate4:
	call interactionAnimate2Times		; $7da1
	call interactionDecCounter1		; $7da4
	ret nz			; $7da7
	jp interactionIncState2		; $7da8


; Kid with grandma who's either stone or was restored from stone
_boyRunSubid0d:
	ld e,Interaction.var03		; $7dab
	ld a,(de)		; $7dad
	or a			; $7dae
	jp nz,interactionPushLinkAwayAndUpdateDrawPriority		; $7daf
	call interactionRunScript		; $7db2
	jp npcFaceLinkAndAnimate		; $7db5


; NPC playing catch with dad, or standing next to his stone dad
_boyRunSubid0e:
	; Check if his dad is stone
	ld e,Interaction.var03		; $7db8
	ld a,(de)		; $7dba
	or a			; $7dbb
	jr z,+			; $7dbc

	call interactionAnimate2Times		; $7dbe
	jr ++			; $7dc1
+
	call interactionRunScript		; $7dc3
++
	call interactionPushLinkAwayAndUpdateDrawPriority		; $7dc6
	ld h,d			; $7dc9
	ld l,Interaction.pressedAButton		; $7dca
	ld a,(hl)		; $7dcc
	or a			; $7dcd
	ret z			; $7dce

	ld (hl),$00		; $7dcf
	ld b,>TX_2500		; $7dd1
	ld l,Interaction.textID		; $7dd3
	ld c,(hl)		; $7dd5
	jp showText		; $7dd6

; Subid $0f: Cutscene where kid runs away?
; Subid $10: Kid listening to Nayru postgame
_boyRunSubid0f:
_boyRunSubid10:
	call interactionRunScript		; $7dd9
	jp c,interactionDelete		; $7ddc
	call interactionAnimateBasedOnSpeed		; $7ddf
	jp interactionPushLinkAwayAndUpdateDrawPriority		; $7de2

;;
; Load palette used for turning npcs to stone?
; @addr{7de5}
loadStoneNpcPalette:
	ld a,PALH_a2		; $7de5
	jp loadPaletteHeader		; $7de7

;;
; @addr{7dea}
_boyUpdateGravityAndHopWhenLanded:
	ld c,$20		; $7dea
	call objectUpdateSpeedZ_paramC		; $7dec
	ret nz			; $7def

;;
; @addr{7df0}
_boyStartHop:
	ld bc,-$e0		; $7df0
	jp objectSetSpeedZ		; $7df3

;;
; Load a script for INTERACID_BOY.
; @addr{7df6}
_boyLoadScript:
	ld e,Interaction.subid		; $7df6
	ld a,(de)		; $7df8
	ld hl,@scriptTable		; $7df9
	rst_addDoubleIndex			; $7dfc
	ldi a,(hl)		; $7dfd
	ld h,(hl)		; $7dfe
	ld l,a			; $7dff
	jp interactionSetScript		; $7e00

; @addr{7e03}
@scriptTable:
	.dw boySubid00Script
	.dw boySubid01Script
	.dw boyStubScript
	.dw boySubid03Script
	.dw boySubid04Script
	.dw boySubid05Script
	.dw boySubid06Script
	.dw boySubid07Script
	.dw boyStubScript
	.dw boyStubScript
	.dw boySubid0aScript
	.dw boySubid0bScript
	.dw boySubid0cScript
	.dw boySubid0dScript
	.dw boySubid0eScript
	.dw boySubid0fScript
	.dw boySubid00Script

_boySubid02ScriptTable:
	.dw boySubid02Script_afterGotSeedSatchel
	.dw boySubid02Script_afterd3
	.dw boySubid02Script_afterNayruSaved
	.dw boySubid02Script_afterd7
	.dw boySubid02Script_afterGotMakuSeed
	.dw boySubid02Script_postGame


; ==============================================================================
; INTERACID_OLD_LADY
; ==============================================================================
interactionCode3d:
	ld e,Interaction.state		; $7e31
	ld a,(de)		; $7e33
	rst_jumpTable			; $7e34
	.dw @state0
	.dw @state1

@state0:
	ld a,$01		; $7e39
	ld (de),a		; $7e3b

	call interactionInitGraphics		; $7e3c
	call objectSetVisiblec2		; $7e3f
	call @initSubid		; $7e42

	ld e,Interaction.enabled		; $7e45
	ld a,(de)		; $7e47
	or a			; $7e48
	jp nz,objectMarkSolidPosition		; $7e49
	ret			; $7e4c

@initSubid:
	ld e,Interaction.subid		; $7e4d
	ld a,(de)		; $7e4f
	rst_jumpTable			; $7e50
	.dw @initSubid0
	.dw @loadScript
	.dw @initSubid2
	.dw @initSubid3
	.dw @initSubid4
	.dw @initSubid5

@initSubid0:
	ld a,$03		; $7e5d
	call interactionSetAnimation		; $7e5f

	; Check whether her grandson is stone
	ld a,GLOBALFLAG_SAVED_NAYRU		; $7e62
	call checkGlobalFlag		; $7e64
	jr z,@loadScript	; $7e67

	; Set var03 to nonzero if her grandson is stone, also change her position
	ld a,$01		; $7e69
	ld e,Interaction.var03		; $7e6b
	ld (de),a		; $7e6d
	ld bc,$4878		; $7e6e
	call interactionSetPosition		; $7e71

@loadScript:
	ld e,Interaction.subid		; $7e74
	ld a,(de)		; $7e76
	ld hl,_oldLadyScriptTable		; $7e77
	rst_addDoubleIndex			; $7e7a
	ldi a,(hl)		; $7e7b
	ld h,(hl)		; $7e7c
	ld l,a			; $7e7d
	jp interactionSetScript		; $7e7e

@initSubid2:
	; This NPC only exists between saving Nayru and beating d7?
	callab interactionBank09.getGameProgress_1		; $7e81
	ld e,Interaction.subid		; $7e89
	ld a,(de)		; $7e8b
	cp b			; $7e8c
	jp nz,interactionDelete		; $7e8d
	jr @loadScript		; $7e90

@initSubid3:
	ld e,Interaction.counter1		; $7e92
	ld a,220		; $7e94
	ld (de),a		; $7e96

	ld a,$03		; $7e97
	jp interactionSetAnimation		; $7e99

@initSubid4:
	ld a,$00		; $7e9c
	jr ++			; $7e9e

@initSubid5:
	ld a,$09		; $7ea0
++
	ld e,Interaction.var3f		; $7ea2
	ld (de),a		; $7ea4
	ld hl,linkedGameNpcScript		; $7ea5
	call interactionSetScript		; $7ea8
	call interactionRunScript		; $7eab
	jr @state1		; $7eae

@state1:
	ld e,Interaction.subid		; $7eb0
	ld a,(de)		; $7eb2
	rst_jumpTable			; $7eb3
	.dw @runSubid0
	.dw @runSubid1
	.dw @runSubid2
	.dw @runSubid3
	.dw @runSubid4
	.dw @runSubid5


; NPC with a grandson that is stone for part of the game
@runSubid0:
	call interactionRunScript		; $7ec0

	ld e,Interaction.var03		; $7ec3
	ld a,(de)		; $7ec5
	or a			; $7ec6
	jp z,interactionAnimateAsNpc		; $7ec7
	jp npcFaceLinkAndAnimate		; $7eca


; Cutscene where her grandson gets turned to stone
@runSubid1:
	ld e,Interaction.state2		; $7ecd
	ld a,(de)		; $7ecf
	rst_jumpTable			; $7ed0
	.dw @@substate0
	.dw @@substate1
	.dw @@substate2
	.dw @@substate3

@@substate0:
	call interactionAnimate		; $7ed9
	call interactionRunScript		; $7edc
	jr nc,++		; $7edf

	; Script ended
	call interactionIncState2		; $7ee1
	ld l,Interaction.counter1		; $7ee4
	ld (hl),60		; $7ee6
	ret			; $7ee8
++
	ld e,Interaction.counter2		; $7ee9
	ld a,(de)		; $7eeb
	or a			; $7eec
	jp nz,interactionAnimate2Times		; $7eed
	ret			; $7ef0

@@substate1:
	call interactionDecCounter1		; $7ef1
	ret nz			; $7ef4
	ld (hl),20		; $7ef5
	jp interactionIncState2		; $7ef7

@@substate2:
	call interactionDecCounter1		; $7efa
	jp nz,interactionAnimate3Times		; $7efd
	ld (hl),60		; $7f00
	jp interactionIncState2		; $7f02

@@substate3:
	call interactionDecCounter1		; $7f05
	ret nz			; $7f08
	ld a,$ff		; $7f09
	ld ($cfdf),a		; $7f0b
	ret			; $7f0e


; NPC in present, screen left from bipin&blossom's house
@runSubid2:
	call interactionRunScript		; $7f0f
	jp npcFaceLinkAndAnimate		; $7f12


; Cutscene where her grandson is restored from stone
@runSubid3:
	ld e,Interaction.state2		; $7f15
	ld a,(de)		; $7f17
	rst_jumpTable			; $7f18
	.dw @@substate0
	.dw @@substate1
	.dw @@substate2

@@substate0:
	call interactionDecCounter1		; $7f1f
	ret nz			; $7f22
	call startJump		; $7f23
	jp interactionIncState2		; $7f26

@@substate1:
	ld c,$20		; $7f29
	call objectUpdateSpeedZ_paramC		; $7f2b
	ret nz			; $7f2e

	call interactionIncState2		; $7f2f
	ld l,Interaction.var38		; $7f32
	ld (hl),$b4		; $7f34
	jp @loadScript		; $7f36

@@substate2:
	ld h,d			; $7f39
	ld l,Interaction.var38		; $7f3a
	dec (hl)		; $7f3c
	jr nz,++		; $7f3d
	ld a,$ff		; $7f3f
	ld ($cfdf),a		; $7f41
++
	call interactionRunScript		; $7f44
	jp interactionAnimateBasedOnSpeed		; $7f47


; Linked game NPC
@runSubid4:
@runSubid5:
	call interactionRunScript		; $7f4a
	jp c,interactionDelete		; $7f4d
	jp npcFaceLinkAndAnimate		; $7f50


_oldLadyScriptTable:
	.dw oldLadySubid0Script
	.dw oldLadySubid1Script
	.dw oldLadySubid2Script
	.dw oldLadySubid3Script
