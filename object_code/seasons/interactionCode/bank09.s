; ==============================================================================
; INTERACID_QUICKSAND
; ==============================================================================
interactionCode5e:
	call returnIfScrollMode01Unset		; $4bce
	ld e,Interaction.state		; $4bd1
	ld a,(de)		; $4bd3
	rst_jumpTable			; $4bd4
	.dw @state0
	.dw @state1
	.dw @state2
@state0:
	ld a,$01		; $4bdb
	ld (de),a		; $4bdd
@state1:
	ld a,$21		; $4bde
	call objectSetCollideRadius		; $4be0
	call _func_5cbd		; $4be3
	call _func_4cb1		; $4be6
	call _func_4ce8		; $4be9
	ld a,($d004)		; $4bec
	cp $01			; $4bef
	ret nz			; $4bf1
	ld a,($d00f)		; $4bf2
	or a			; $4bf5
	ret nz			; $4bf6
	ld bc,$2105		; $4bf7
	call @checkLinkWithinAPartOfQuicksand		; $4bfa
	ret nc			; $4bfd
	ld a,QUICKSAND_RING		; $4bfe
	call cpActiveRing		; $4c00
	jr z,+			; $4c03
	call objectGetAngleTowardLink		; $4c05
	xor $10			; $4c08
	ld c,a			; $4c0a
	ld b,$14		; $4c0b
	call updateLinkPositionGivenVelocity		; $4c0d
+
	call _func_4ca3		; $4c10
	ld bc,$0300		; $4c13
	call @checkLinkWithinAPartOfQuicksand		; $4c16
	ret nc			; $4c19
	ld e,Interaction.subid		; $4c1a
	ld a,(de)		; $4c1c
	or a			; $4c1d
	ld a,$01		; $4c1e
	jr z,@respawnLink	; $4c20
	call dropLinkHeldItem		; $4c22
	call clearAllParentItems		; $4c25
	ld h,d			; $4c28
	ld l,$44		; $4c29
	ld (hl),$02		; $4c2b
	ld a,($ccc1)		; $4c2d
	and $7f			; $4c30
	ld l,$47		; $4c32
	ldd (hl),a		; $4c34
	ld (hl),$3c		; $4c35
	ld a,$03		; $4c37
@respawnLink:
	ld ($cc6c),a		; $4c39
	ld a,$02		; $4c3c
	ld ($cc6a),a		; $4c3e
	ld hl,$d00b		; $4c41
	jp objectCopyPosition		; $4c44
@state2:
	xor a			; $4c47
	ld ($ccc1),a		; $4c48
	call interactionDecCounter1		; $4c4b
	ret nz			; $4c4e
	ld c,$03		; $4c4f
	ld l,$42		; $4c51
	ld a,(hl)		; $4c53
	cp $05			; $4c54
	jr z,+			; $4c56
	dec c			; $4c58
	ld e,$47		; $4c59
	ld a,(de)		; $4c5b
	cp (hl)			; $4c5c
	jr z,+			; $4c5d
	ld a,(wFrameCounter)		; $4c5f
	and $01			; $4c62
	ld c,a			; $4c64
+
	ld a,c			; $4c65
	add a			; $4c66
	add c			; $4c67
	ld hl,@warpDestLocations		; $4c68
	rst_addAToHl			; $4c6b
	ldi a,(hl)		; $4c6c
	ld (wWarpDestGroup),a		; $4c6d
	ldi a,(hl)		; $4c70
	ld (wWarpDestRoom),a		; $4c71
	ldi a,(hl)		; $4c74
	ld (wWarpDestPos),a		; $4c75
	ld a,$05		; $4c78
	ld (wWarpTransition),a		; $4c7a
	ld a,$03		; $4c7d
	ld (wWarpTransition2),a		; $4c7f
	jp interactionDelete		; $4c82
@warpDestLocations:
	.db $85 $d0 $57 ; has like likes
	.db $85 $d1 $57 ; business scrub selling shield
	.db $85 $d2 $57 ; pirate skull
	.db $84 $f4 $27 ; leads to chest
@checkLinkWithinAPartOfQuicksand:
	ld h,d			; $4c91
	ld l,$66		; $4c92
	ld (hl),b		; $4c94
	inc l			; $4c95
	ld (hl),b		; $4c96
	ld a,($d00b)		; $4c97
	add c			; $4c9a
	ld b,a			; $4c9b
	ld a,($d00d)		; $4c9c
	ld c,a			; $4c9f
	jp interactionCheckContainsPoint		; $4ca0
_func_4ca3:
	ld hl,$ccc1		; $4ca3
	ld a,(hl)		; $4ca6
	or a			; $4ca7
	ret z			; $4ca8
	ld e,Interaction.subid		; $4ca9
	ld a,(de)		; $4cab
	cp (hl)			; $4cac
	ret nz			; $4cad
	set 7,(hl)		; $4cae
	ret			; $4cb0
_func_4cb1:
	ld c,$4d		; $4cb1
	call objectFindSameTypeObjectWithID		; $4cb3
	ret nz			; $4cb6
	ld l,$4f		; $4cb7
	ld e,$7a		; $4cb9
	jr _func_4cd2		; $4cbb
_func_5cbd:
	ld h,$d0		; $4cbd
-
	ld l,$c1		; $4cbf
	ld a,(hl)		; $4cc1
	cp $01			; $4cc2
	call z,_func_4cce		; $4cc4
	inc h			; $4cc7
	ld a,h			; $4cc8
	cp $e0			; $4cc9
	jr c,-			; $4ccb
	ret			; $4ccd
_func_4cce:
	ld l,$cf		; $4cce
	ld e,$f1		; $4cd0
_func_4cd2:
	ldd a,(hl)		; $4cd2
	rlca			; $4cd3
	ret c			; $4cd4
	dec l			; $4cd5
	ld c,(hl)		; $4cd6
	dec l			; $4cd7
	dec l			; $4cd8
	ld b,(hl)		; $4cd9
	ld l,e			; $4cda
	push hl			; $4cdb
	call interactionCheckContainsPoint		; $4cdc
	pop hl			; $4cdf
	ret nc			; $4ce0
	call objectGetPosition		; $4ce1
	ld (hl),b		; $4ce4
	inc l			; $4ce5
	ld (hl),c		; $4ce6
	ret			; $4ce7
_func_4ce8:
	ld c,$03		; $4ce8
	call findItemWithID		; $4cea
	call z,_func_4cfe		; $4ced
	ld c,$03		; $4cf0
	call findItemWithID_startingAfterH		; $4cf2
	call z,_func_4cfe		; $4cf5
	ld c,$21		; $4cf8
	call findItemWithID		; $4cfa
	ret nz			; $4cfd
_func_4cfe:
	ld l,$0f		; $4cfe
	ld e,$31		; $4d00
	jr _func_4cd2		; $4d02


; ==============================================================================
; INTERACID_COMPANION_SPAWNER
; ==============================================================================
.ifdef ROM_AGES
interactionCode67:
.else
interactionCode5f:
.endif
	ld e,Interaction.subid		; $4a5d
	ld a,(de)		; $4a5f
	cp $06			; $4a60
	jr z,@label_0a_045	; $4a62
	ld a,(de)		; $4a64
	rlca			; $4a65
	jr c,@fluteCall	; $4a66
	ld a,(w1Companion.enabled)		; $4a68
	or a			; $4a6b
	jp nz,@deleteSelf		; $4a6c

@label_0a_045:
	ld a,(de)		; $4a6f
	rst_jumpTable			; $4a70
	.dw @subid00
	.dw @subid01
	.dw @subid02
	.dw @subid03
	.dw @subid04
	.dw @subid05
.ifdef ROM_SEASONS
	.dw @subid06
.endif

@fluteCall:
	ld a,(w1Companion.enabled)		; $4a7d
	or a			; $4a80
	jr z,@label_0a_047	; $4a81

	; If there's already something in the companion slot, continue if it's the
	; minecart or anything past moosh (maple, raft).
	; But there's a check later that will prevent the companion from spawning if this
	; slot is in use...
	ld a,(w1Companion.id)		; $4a83
	cp SPECIALOBJECTID_MOOSH+1			; $4a86
	jr nc,@label_0a_047	; $4a88
	cp SPECIALOBJECTID_MINECART			; $4a8a
	jp nz,@deleteSelf		; $4a8c

@label_0a_047:
	ld a,(wTilesetFlags)		; $4a8f
.ifdef ROM_AGES
	and (TILESETFLAG_PAST | TILESETFLAG_OUTDOORS)			; $4a92
.else
	and (TILESETFLAG_SUBROSIA | TILESETFLAG_OUTDOORS)			; $4a92
.endif
	cp TILESETFLAG_OUTDOORS			; $4a94
	jp nz,@deleteSelf		; $4a96

	; In the past or indoors; "Your song just echoes..."
	ld bc,TX_510f		; $4a99
	ld a,(wFluteIcon)		; $4a9c
	or a			; $4a9f
	jp z,@showTextAndDelete		; $4aa0

	; If in the present, check if companion is callable in this room
	ld a,(wActiveRoom)		; $4aa3
	ld hl,companionCallableRooms		; $4aa6
	call checkFlag		; $4aa9
	jp z,@fluteSongFellFlat		; $4aac

	; Don't call companion if the slot is in use already
	ld a,(w1Companion.enabled)		; $4aaf
	or a			; $4ab2
	jp nz,@deleteSelf		; $4ab3

	; [var3e/var3f] = Link's position
	ld e,Interaction.var3e		; $4ab6
	ld hl,w1Link.yh		; $4ab8
	ldi a,(hl)		; $4abb
	and $f0			; $4abc
	ld (de),a		; $4abe
	inc l			; $4abf
	inc e			; $4ac0
	ld a,(hl)		; $4ac1
	swap a			; $4ac2
	and $0f			; $4ac4
	ld (de),a		; $4ac6

	; Try various things to determine where companion should enter from?

	; Try from top at Link's x position
	ld hl,wRoomCollisions		; $4ac7
	rst_addAToHl			; $4aca
	call @checkVerticalCompanionSpawnPosition		; $4acb
	ld b,-$08		; $4ace
	ld l,c			; $4ad0
	ld h,$10		; $4ad1
	ld a,DIR_DOWN		; $4ad3
	jr z,@setCompanionDestination	; $4ad5

	; Try from bottom at Link's x
	ld e,Interaction.var3f		; $4ad7
	ld a,(de)		; $4ad9
	ld hl,wRoomCollisions+$60		; $4ada
	rst_addAToHl			; $4add
	call @checkVerticalCompanionSpawnPosition		; $4ade
	ld b,SMALL_ROOM_HEIGHT*$10+8		; $4ae1
	ld l,c			; $4ae3
	ld h,SMALL_ROOM_HEIGHT*$10-$10		; $4ae4
	ld a,DIR_UP		; $4ae6
	jr z,@setCompanionDestination	; $4ae8

	; Try from right at Link's y
	ld e,Interaction.var3e		; $4aea
	ld a,(de)		; $4aec
	ld hl,wRoomCollisions+$08		; $4aed
	rst_addAToHl			; $4af0
	call @checkHorizontalCompanionSpawnPosition		; $4af1
	ld c,SMALL_ROOM_WIDTH*$10+8		; $4af4
	ld h,b			; $4af6
	ld l,SMALL_ROOM_WIDTH*$10-$10		; $4af7
	ld a,DIR_LEFT		; $4af9
	jr z,@setCompanionDestination	; $4afb

	; Try from left at Link's y
	ld e,Interaction.var3e		; $4afd
	ld a,(de)		; $4aff
	ld hl,wRoomCollisions		; $4b00
	rst_addAToHl			; $4b03
	call @checkHorizontalCompanionSpawnPosition		; $4b04
	ld c,-$08		; $4b07
	ld h,b			; $4b09
	ld l,$10		; $4b0a
	ld a,DIR_RIGHT		; $4b0c
	jr z,@setCompanionDestination	; $4b0e

	; Try from top at range of x positions
	ld hl,wRoomCollisions+$03		; $4b10
	call @checkCompanionSpawnColumnRange		; $4b13
	ld b,-$08		; $4b16
	ld l,c			; $4b18
	ld h,$10		; $4b19
	ld a,DIR_DOWN		; $4b1b
	jr nz,@setCompanionDestination	; $4b1d

	; Try from bottom at range of x positions
	ld hl,wRoomCollisions+$63		; $4b1f
	call @checkCompanionSpawnColumnRange		; $4b22
	ld b,SMALL_ROOM_HEIGHT*$10+8		; $4b25
	ld l,c			; $4b27
	ld h,SMALL_ROOM_HEIGHT*$10-$10		; $4b28
	ld a,DIR_UP		; $4b2a
	jr nz,@setCompanionDestination	; $4b2c

	; Try from right at range of y positions
	ld hl,wRoomCollisions+$28		; $4b2e
	call @checkCompanionSpawnRowRange		; $4b31
	ld c,SMALL_ROOM_WIDTH*$10+8		; $4b34
	ld h,b			; $4b36
	ld l,SMALL_ROOM_WIDTH*$10-$10		; $4b37
	ld a,DIR_LEFT		; $4b39
	jr nz,@setCompanionDestination	; $4b3b

	; Try from left at range of y positions
	ld hl,wRoomCollisions+$20		; $4b3d
	call @checkCompanionSpawnRowRange		; $4b40
	ld c,$f8		; $4b43
	ld h,b			; $4b45
	ld l,$10		; $4b46
	ld a,DIR_RIGHT		; $4b48
	jr z,@fluteSongFellFlat	; $4b4a


; @param	a	Direction companion should move in
; @param	bc	Initial Y/X position
; @param	hl	Y/X destination
@setCompanionDestination:
	push de			; $4b4c
	push hl			; $4b4d
	pop de			; $4b4e
	ld hl,wLastAnimalMountPointY		; $4b4f
.ifdef ROM_AGES
	ld (hl),d		; $4b52
	inc l			; $4b53
	ld (hl),e		; $4b54
.else
	ldh (<hFF8B),a	; $4dfb
	ld a,d			; $4dfd
	ldi (hl),a		; $4dfe
	ld a,e			; $4dff
	ld (hl),a		; $4e00
	ldh a,(<hFF8B)	; $4e01
.endif
	pop de			; $4b55

	ld hl,w1Companion.direction		; $4b56
	ldi (hl),a		; $4b59
	swap a			; $4b5a
.ifdef ROM_AGES
	rrca			; $4b5c
.else
	srl a
.endif
	ldi (hl),a		; $4b5d

	inc l			; $4b5e
	ld (hl),b		; $4b5f
	ld l,SpecialObject.xh		; $4b60
	ld (hl),c		; $4b62

	ld l,SpecialObject.enabled		; $4b63
	inc (hl)		; $4b65
	inc l			; $4b66
	ld a,(wAnimalCompanion)		; $4b67
	ldi (hl),a ; [SpecialObject.id]

	; State $0c = entering screen from flute call
	ld l,SpecialObject.state		; $4b6b
	ld a,$0c		; $4b6d
	ld (hl),a		; $4b6f
	jr @deleteSelf		; $4b70


@fluteSongFellFlat:
	ld bc,TX_510c		; $4b72

@showTextAndDelete:
	ld a,(wTextIsActive)		; $4b75
	or a			; $4b78
	call z,showText		; $4b79

@deleteSelf:
	jp interactionDelete		; $4b7c

.ifdef ROM_AGES
; Moosh being attacked by ghosts
@subid00:
	ld hl,wMooshState		; $4b7f
	ld a,(wEssencesObtained)		; $4b82
	bit 1,a			; $4b85
	jr z,@deleteSelf	; $4b87
	ld a,(wPastRoomFlags+$79)		; $4b89
	bit 6,a			; $4b8c
	jr z,@deleteSelf	; $4b8e
	ld a,TREASURE_CHEVAL_ROPE		; $4b90
	call checkTreasureObtained		; $4b92
	jr nc,@loadCompanionPresetIfHasntLeft	; $4b95
	jr @deleteSelf		; $4b97


; Moosh saying goodbye after getting cheval rope
@subid01:
	ld hl,wMooshState		; $4b99
	ld a,$40		; $4b9c
	and (hl)		; $4b9e
	jr nz,@deleteSelf	; $4b9f
	ld a,TREASURE_CHEVAL_ROPE		; $4ba1
	call checkTreasureObtained		; $4ba3
	jr c,@loadCompanionPresetIfHasntLeft	; $4ba6

@deleteSelf2:
	jr @deleteSelf		; $4ba8


; Dimitri being attacked by hungry tokays
@subid03:
	ld hl,wDimitriState		; $4baa
	ld a,(wEssencesObtained)		; $4bad
	bit 2,a			; $4bb0
	jr z,@deleteSelf	; $4bb2
	jr @loadCompanionPresetIfHasntLeft		; $4bb4


; Ricky looking for gloves
@subid02:
	ld a,GLOBALFLAG_GAVE_ROPE_TO_RAFTON		; $4bb6
	call checkGlobalFlag		; $4bb8
	jr z,@deleteSelf	; $4bbb
	ld hl,wRickyState		; $4bbd
	jr @loadCompanionPresetIfHasntLeft		; $4bc0


; Companion lost in forest
@subid04:
	ld a,GLOBALFLAG_COMPANION_LOST_IN_FOREST		; $4bc2
	call checkGlobalFlag		; $4bc4
	jr z,@deleteSelf	; $4bc7
	jr @label_0a_052		; $4bc9


; Cutscene outside forest where you get the flute
@subid05:
	ld a,GLOBALFLAG_SAVED_COMPANION_FROM_FOREST		; $4bcb
	call checkGlobalFlag		; $4bcd
	jr z,@deleteSelf	; $4bd0
@label_0a_052:
	ld a,GLOBALFLAG_GOT_FLUTE		; $4bd2
	call checkGlobalFlag		; $4bd4
	jr nz,@deleteSelf	; $4bd7
	jr @loadCompanionPreset		; $4bd9
.else
@subid05:
	ld hl,wMooshState		; $4e2e
	ld a,(wEssencesObtained)		; $4e31
	bit 3,a			; $4e34
	jp z,@loadCompanionPresetIfHasntLeft		; $4e36
	set 6,(hl)		; $4e39
	jr @deleteSelf		; $4e3b

; dimitri after being saved
@subid04:
	ld a,(wEssencesObtained)		; $4e3d
	bit 2,a			; $4e40
	jr z,@deleteSelf	; $4e42
	ld a,(wDimitriState)		; $4e44
	and $20			; $4e47
	jr z,@deleteSelf	; $4e49
	ld a,(wAnimalCompanion)		; $4e4b
	cp SPECIALOBJECTID_DIMITRI			; $4e4e
	jr z,@deleteSelf	; $4e50
	ld hl,wDimitriState		; $4e52
	ld a,TREASURE_FLIPPERS		; $4e55
	call checkTreasureObtained		; $4e57
	jr nc,@loadCompanionPresetIfHasntLeft	; $4e5a
	set 6,(hl)		; $4e5c
	jr @deleteSelf		; $4e5e

@subid02:
	ld a,(wAnimalCompanion)		; $4e60
	cp SPECIALOBJECTID_DIMITRI			; $4e63
	jr nz,@deleteSelf	; $4e65
	ld hl,wDimitriState		; $4e67
	jr @deleteSelfIfBit7OfAnimalStateSet		; $4e6a

@subid01:
	ld hl,wRickyState		; $4e6c
	ld a,(wEssencesObtained)		; $4e6f
	bit 1,a			; $4e72
	jr z,@deleteSelf	; $4e74
	ld a,(wAnimalCompanion)		; $4e76
	cp SPECIALOBJECTID_RICKY			; $4e79
	jr z,@deleteSelfIfBit7OfAnimalStateSet	; $4e7b
	ld a,(hl)		; $4e7d
	bit 6,a			; $4e7e
	jr z,@loadCompanionPresetIfHasntLeft	; $4e80
	jr @deleteSelf		; $4e82

@subid06:
	ld hl,wRickyState		; $4e84
	ld a,(wAnimalCompanion)		; $4e87
	cp SPECIALOBJECTID_RICKY			; $4e8a
	jr z,@deleteSelf2	; $4e8c
	ld a,(wFluteIcon)		; $4e8e
	or a			; $4e91
	jr z,@deleteSelf	; $4e92
	set 6,(hl)		; $4e94

@deleteSelf2:
	jr @deleteSelf		; $4e96

@subid03:
	ld a,(wAnimalCompanion)		; $4e98
	cp SPECIALOBJECTID_MOOSH			; $4e9b
	jr nz,@deleteSelf	; $4e9d
	ld hl,wMooshState		; $4e9f
	ld a,(hl)		; $4ea2
	and $a0			; $4ea3
	jr nz,@deleteSelf	; $4ea5

@deleteSelfIfBit7OfAnimalStateSet:
	bit 7,(hl)		; $4ea7
	jr nz,@deleteSelf2	; $4ea9
.endif


@loadCompanionPresetIfHasntLeft:
	; This bit of the companion's state is set if he's left after his sidequest
	ld a,(hl)		; $4bdb
	and $40			; $4bdc
	jr nz,@deleteSelf2	; $4bde

; Load a companion's ID and position from a table of presets based on subid.
.ifdef ROM_SEASONS
@subid00:
.endif
@loadCompanionPreset:
	ld e,Interaction.subid		; $4be0
	ld a,(de)		; $4be2
	add a			; $4be3
	ld hl,@presetCompanionData		; $4be4
	rst_addDoubleIndex			; $4be7

	ld bc,w1Companion.enabled		; $4be8
	ld a,$01		; $4beb
	ld (bc),a		; $4bed

	; Get companion, either from the table, or from wAnimalCompanion
	inc c			; $4bee
	ldi a,(hl)		; $4bef
.ifdef ROM_AGES
	or a			; $4bf0
	jr nz,+			; $4bf1
	ld a,(wAnimalCompanion)		; $4bf3
+
.endif
	ld (bc),a		; $4bf6

	; Set Y/X
	ld c,SpecialObject.yh		; $4bf7
	ldi a,(hl)		; $4bf9
	ld (bc),a		; $4bfa
	ld (wLastAnimalMountPointY),a		; $4bfb
	ld c,SpecialObject.xh		; $4bfe
	ldi a,(hl)		; $4c00
	ld (bc),a		; $4c01
	ld (wLastAnimalMountPointX),a		; $4c02

	xor a			; $4c05
	ld (wRememberedCompanionId),a		; $4c06
	jr @deleteSelf2		; $4c09

;;
; Check if the first 2 tiles near the edge of the screen are walkable for a companion.
;
; @param	hl	Address in wRoomCollisions to start at
; @param[out]	bc	Position to spawn at
; @param[out]	zflag	z if the companion can spawn from there
; @addr{4c0b}
@checkVerticalCompanionSpawnPosition:
	ld b,$10		; $4c0b
	jr ++			; $4c0d

;;
; @param	hl	Address in wRoomCollisions to start at
; @param[out]	bc	Position to spawn at
; @param[out]	zflag	z if the companion can spawn from there
; @addr{4c0b}
@checkHorizontalCompanionSpawnPosition:
	ld b,$01		; $4c0f
++
	ld a,(hl)		; $4c11
	or a			; $4c12
	ret nz			; $4c13
	ld a,l			; $4c14
	add b			; $4c15
	ld l,a			; $4c16
	ld a,(hl)		; $4c17
	or a			; $4c18
	ld a,l			; $4c19
	ret nz			; $4c1a
	call convertShortToLongPosition		; $4c1b
	xor a			; $4c1e
	ret			; $4c1f

;;
; Checks the given column and up to the following 3 after for if the companion can spawn
; there.
;
; @param	hl	Starting position to check (also checks 3 rows/columns after)
; @param[out]	bc	Position to spawn at
; @param[out]	zflag	nz if valid position to spawn from found
; @addr{4c20}
@checkCompanionSpawnColumnRange:
	push de			; $4c20
	ld b,$01		; $4c21
	ld e,$10		; $4c23
	jr ++			; $4c25

;;
; @param	hl	Starting position to check (also checks 3 rows/columns after)
; @param[out]	bc	Position to spawn at
; @param[out]	zflag	nz if valid position to spawn from found
; @addr{4c27}
@checkCompanionSpawnRowRange:
	push de			; $4c27
	ld b,$10		; $4c28
	ld e,$01		; $4c2a
++
	ld c,$04		; $4c2c

@@nextRowOrColumn:
	ld a,(hl)		; $4c2e
	or a			; $4c2f
	jr z,@@tryThisRowOrColumn	; $4c30

@@resumeSearch:
	ld a,l			; $4c32
	add b			; $4c33
	ld l,a			; $4c34
	dec c			; $4c35
	jr nz,@@nextRowOrColumn	; $4c36

	pop de			; $4c38
	ret			; $4c39

@@tryThisRowOrColumn:
	ld a,l			; $4c3a
	add e			; $4c3b
	ld l,a			; $4c3c
	ld a,(hl)		; $4c3d
	or a			; $4c3e
	ld a,l			; $4c3f
	jr z,@@foundRowOrColumn	; $4c40
	sub e			; $4c42
	ld l,a			; $4c43
	jr @@resumeSearch		; $4c44

@@foundRowOrColumn:
	call convertShortToLongPosition		; $4c46
	or d			; $4c49
	pop de			; $4c4a
	ret			; $4c4b


; Data format:
;   b0: Companion ID (or $00 to use wAnimalCompanion)
;   b1: Y-position to spawn at
;   b2: X-position to spawn at
;   b3: Unused
@presetCompanionData:
.ifdef ROM_AGES
	.db SPECIALOBJECTID_MOOSH,   $28, $58, $00 ; $00 == [subid]
	.db SPECIALOBJECTID_MOOSH,   $48, $38, $00 ; $01
	.db SPECIALOBJECTID_RICKY,   $40, $50, $00 ; $02
	.db SPECIALOBJECTID_DIMITRI, $48, $30, $00 ; $03
	.db $00,                     $58, $50, $00 ; $04
	.db $00,                     $48, $68, $00 ; $05
.else
	.db SPECIALOBJECTID_MAPLE,   $18, $b8, $00
	.db SPECIALOBJECTID_RICKY,   $38, $50, $00
	.db SPECIALOBJECTID_DIMITRI, $18, $5f, $00
	.db SPECIALOBJECTID_MOOSH,   $18, $30, $00
	.db SPECIALOBJECTID_DIMITRI, $28, $60, $00
	.db SPECIALOBJECTID_MOOSH,   $58, $40, $00
.endif


.include "build/data/companionCallableRooms.s"


; ==============================================================================
; INTERACID_D5_4_CHEST_PUZZLE
; ==============================================================================
interactionCode62:
	ld e,Interaction.subid		; $4f4e
	ld a,(de)		; $4f50
	rst_jumpTable			; $4f51
	.dw @subid0
	.dw @subid1
@subid0:
	ld e,Interaction.state		; $4f56
	ld a,(de)		; $4f58
	rst_jumpTable			; $4f59
	.dw @@state0
	.dw @@state1
	.dw @subid1
	.dw @subid1
@@state0:
	call getThisRoomFlags		; $4f62
	bit 5,(hl)		; $4f65
	jp nz,interactionDelete		; $4f67
	ld e,Interaction.state		; $4f6a
	ld a,$01		; $4f6c
	ld (de),a		; $4f6e
	ld ($ccbb),a		; $4f6f
	xor a			; $4f72
	ld ($cfd8),a		; $4f73
	ld ($cfd9),a		; $4f76
@@state1:
	ld a,(wNumEnemies)		; $4f79
	or a			; $4f7c
	ret nz			; $4f7d
	ld a,($cfd0)		; $4f7e
	ld b,a			; $4f81
	ld c,$00		; $4f82
	call @@func_4fa5		; $4f84
	ld a,($cfd1)		; $4f87
	ld b,a			; $4f8a
	ld c,$01		; $4f8b
	call @@func_4fa5		; $4f8d
	ld a,($cfd2)		; $4f90
	ld b,a			; $4f93
	ld c,$02		; $4f94
	call @@func_4fa5		; $4f96
	ld a,($cfd3)		; $4f99
	ld b,a			; $4f9c
	ld c,$03		; $4f9d
	call @@func_4fa5		; $4f9f
	jp interactionDelete		; $4fa2
@@func_4fa5:
	call getFreeInteractionSlot		; $4fa5
	ret nz			; $4fa8
	ld (hl),INTERACID_D5_4_CHEST_PUZZLE		; $4fa9
	inc l			; $4fab
	ld (hl),$01		; $4fac
	ld l,$70		; $4fae
	ld (hl),b		; $4fb0
	ld l,$43		; $4fb1
	ld (hl),c		; $4fb3
	ret			; $4fb4
@subid1:
	ld e,Interaction.state		; $4fb5
	ld a,(de)		; $4fb7
	rst_jumpTable			; $4fb8
	.dw @@state0
	.dw @@state1
	.dw @@state2
	.dw @@state3
	.dw @@state4
@@state0:
	ld a,$01		; $4fc3
	ld (de),a		; $4fc5
	ld e,$70		; $4fc6
	ld a,(de)		; $4fc8
	ld h,d			; $4fc9
	ld l,$4b		; $4fca
	call setShortPosition		; $4fcc
	ld l,$66		; $4fcf
	ld (hl),$04		; $4fd1
	inc l			; $4fd3
	ld (hl),$06		; $4fd4
	ld l,$46		; $4fd6
	ld (hl),$1e		; $4fd8
	call objectCreatePuff		; $4fda
@@state1:
	call interactionDecCounter1		; $4fdd
	ret nz			; $4fe0
	ld l,$44		; $4fe1
	inc (hl)		; $4fe3
	ld l,$70		; $4fe4
	ld c,(hl)		; $4fe6
	ld a,TILEINDEX_CHEST		; $4fe7
	call setTile		; $4fe9
@@state2:
	ld a,($cfd9)		; $4fec
	or a			; $4fef
	jp nz,_func_5076		; $4ff0
	call objectPreventLinkFromPassing		; $4ff3
	ld a,(wcca2)		; $4ff6
	or a			; $4ff9
	ret z			; $4ffa
	ld b,a			; $4ffb
	ld e,$70		; $4ffc
	ld a,(de)		; $4ffe
	cp b			; $4fff
	ret nz			; $5000
	ld a,($cfd8)		; $5001
	ld b,a			; $5004
	ld e,$43		; $5005
	ld a,(de)		; $5007
	cp b			; $5008
	jr nz,@@func_5040	; $5009
	inc a			; $500b
	ld ($cfd8),a		; $500c
	ld hl,$d040		; $500f
	ld b,$40		; $5012
	call clearMemory		; $5014
	ld hl,$d040		; $5017
	inc (hl)		; $501a
	inc l			; $501b
	ld (hl),$60		; $501c
	inc l			; $501e
	ld a,($cfd8)		; $501f
	dec a			; $5022
	ld bc,@@table_504b		; $5023
	call addDoubleIndexToBc		; $5026
	ld a,(bc)		; $5029
	ld (hl),a		; $502a
	inc l			; $502b
	inc bc			; $502c
	ld a,(bc)		; $502d
	ld (hl),a		; $502e
	ld bc,$f800		; $502f
	call objectCopyPositionWithOffset		; $5032
	ld e,Interaction.state		; $5035
	ld a,$03		; $5037
	ld (de),a		; $5039
	ld a,$81		; $503a
	ld ($cca4),a		; $503c
	ret			; $503f
@@func_5040:
	ld a,$5a		; $5040
	call playSound		; $5042
	ld a,$01		; $5045
	ld ($cfd9),a		; $5047
	ret			; $504a
@@table_504b:
	; $d042 - $d043
	.db TREASURE_RUPEES      RUPEEVAL_070
	.db TREASURE_BOMBS       $01
	.db TREASURE_EMBER_SEEDS $00
	.db TREASURE_SMALL_KEY   $03
@@state3:
	ld a,($cfd9)		; $5053
	or a			; $5056
	jr nz,_func_5076	; $5057
	ret			; $5059
@@state4:
	call interactionDecCounter1		; $505a
	ret nz			; $505d
	call objectCreatePuff		; $505e
	call getFreeEnemySlot		; $5061
	ret nz			; $5064
	ld (hl),ENEMYID_WHISP		; $5065
	call objectCopyPosition		; $5067
	ld e,$70		; $506a
	ld a,(de)		; $506c
	ld c,a			; $506d
	ld a,TILEINDEX_STANDARD_FLOOR		; $506e
	call setTile		; $5070
	jp interactionDelete		; $5073
_func_5076:
	ld e,Interaction.state		; $5076
	ld a,$04		; $5078
	ld (de),a		; $507a
	ld e,$46		; $507b
	ld a,$3c		; $507d
	ld (de),a		; $507f
	ret			; $5080


; ==============================================================================
; INTERACID_D5_REVERSE_MOVING_ARMOS
; ==============================================================================
interactionCode63:
	ld e,Interaction.state		; $5081
	ld a,(de)		; $5083
	rst_jumpTable			; $5084
	.dw @state0
	.dw @state1
@state0:
	ld a,(wBlockPushAngle)		; $5089
	or a			; $508c
	ret z			; $508d
	add $10			; $508e
	and $1f			; $5090
	add $04			; $5092
	add a			; $5094
	swap a			; $5095
	and $03			; $5097
	ld hl,@table_50da		; $5099
	rst_addAToHl			; $509c
	ld c,(hl)		; $509d
	call objectGetShortPosition		; $509e
	add c			; $50a1
	ld b,$ce		; $50a2
	ld c,a			; $50a4
	ldh (<hFF8C),a	; $50a5
	ld a,(bc)		; $50a7
	or a			; $50a8
	jr nz,@func_50e3	; $50a9
	call getFreeInteractionSlot		; $50ab
	ret nz			; $50ae
	ld (hl),INTERACID_PUSHBLOCK		; $50af
	ld l,$49		; $50b1
	ld a,(wBlockPushAngle)		; $50b3
	add $10			; $50b6
	and $1f			; $50b8
	ld (hl),a		; $50ba
	ldh (<hFF8B),a	; $50bb
	ld bc,$fe00		; $50bd
	call objectCopyPositionWithOffset		; $50c0
	call objectGetShortPosition		; $50c3
	ld l,$70		; $50c6
	ld (hl),a		; $50c8
	ld h,d			; $50c9
	ld l,$4b		; $50ca
	ldh a,(<hFF8C)	; $50cc
	call setShortPosition		; $50ce
	ld l,$44		; $50d1
	ld (hl),$01		; $50d3
	xor a			; $50d5
	ld (wBlockPushAngle),a		; $50d6
	ret			; $50d9
@table_50da:
	.db $f0 $01 $10 $ff
@state1:
	ld a,(wBlockPushAngle)		; $50de
	or a			; $50e1
	ret z			; $50e2
@func_50e3:
	ld e,Interaction.state		; $50e3
	xor a			; $50e5
	ld (de),a		; $50e6
	ld (wBlockPushAngle),a		; $50e7
	ret			; $50ea


; ==============================================================================
; INTERACID_D5_FALLING_MAGNET_BALL
; ==============================================================================
interactionCode64:
	ld e,Interaction.state		; $50eb
	ld a,(de)		; $50ed
	rst_jumpTable			; $50ee
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3
	.dw @state4
	.dw interactionDelete
@state0:
	call interactionInitGraphics		; $50fb
	call getThisRoomFlags		; $50fe
	bit 7,(hl)		; $5101
	jr nz,@func_5111	; $5103
	call objectGetZAboveScreen		; $5105
	ld h,d			; $5108
	ld l,$44		; $5109
	ld (hl),$01		; $510b
	ld l,$4f		; $510d
	ld (hl),a		; $510f
	ret			; $5110
@func_5111:
	ld e,Interaction.state		; $5111
	ld a,$04		; $5113
	ld (de),a		; $5115
	jp objectSetVisiblec2		; $5116
@state1:
	call getThisRoomFlags		; $5119
	bit 7,(hl)		; $511c
	ret z			; $511e
	ld e,Interaction.state		; $511f
	ld a,$02		; $5121
	ld (de),a		; $5123
	ld e,$46		; $5124
	ld a,$1e		; $5126
	ld (de),a		; $5128
	ld a,$4d		; $5129
	call playSound		; $512b
	jp objectSetVisiblec1		; $512e
@state2:
	call interactionDecCounter1		; $5131
	ret nz			; $5134
	ld l,$44		; $5135
	inc (hl)		; $5137
@state3:
	ld c,$10		; $5138
	call objectUpdateSpeedZAndBounce		; $513a
	ret nc			; $513d
	ld e,Interaction.state		; $513e
	ld a,$04		; $5140
	ld (de),a		; $5142
@state4:
	ld hl,$dd00		; $5143
	ld a,(hl)		; $5146
	or a			; $5147
	ret nz			; $5148
	ld (hl),$01		; $5149
	inc l			; $514b
	ld (hl),$29		; $514c
	call objectCopyPosition		; $514e
	ld e,$56		; $5151
	ld l,$16		; $5153
	ld a,(de)		; $5155
	ldi (hl),a		; $5156
	inc e			; $5157
	ld a,(de)		; $5158
	ld (hl),a		; $5159
	ld e,Interaction.state		; $515a
	ld a,$05		; $515c
	ld (de),a		; $515e
	ret			; $515f


; ==============================================================================
; INTERACID_LOST_WOODS_DEKU_SCRUB
; ==============================================================================
interactionCode65:
	call returnIfScrollMode01Unset		; $5160
	call _func_5258		; $5163
	jp nz,interactionDelete		; $5166
	ld e,Interaction.state		; $5169
	ld a,(de)		; $516b
	rst_jumpTable			; $516c
	.dw @state0
	.dw @state1
	.dw @state2
@state0:
	ld a,$01		; $5173
	ld (de),a		; $5175
	call objectSetReservedBit1		; $5176
	ld e,Interaction.subid		; $5179
	ld a,(de)		; $517b
	or a			; $517c
	jr nz,@notSubId0	; $517d
	ld e,$46		; $517f
	ld a,$78		; $5181
	ld (de),a		; $5183

	ld a,$02		; $5184
	ld ($ff00+R_SVBK),a	; $5186

	ld a,$80		; $5188
	ld hl,$d000		; $518a
	call @func_51c0		; $518d

	ld hl,$d0a0		; $5190
	call @func_51c0		; $5193

	ld a,$0b		; $5196
	ld hl,$d400		; $5198
	call @func_51c0		; $519b

	ld hl,$d4a0		; $519e
	call @func_51c0		; $51a1

	xor a			; $51a4
	ld ($ff00+R_SVBK),a	; $51a5

	call getFreeInteractionSlot		; $51a7
	ret nz			; $51aa
	ld (hl),INTERACID_D6_CRYSTAL_TRAP_ROOM		; $51ab
	inc l			; $51ad
	ld (hl),$01		; $51ae
	call getFreeInteractionSlot		; $51b0
	ret nz			; $51b3
	ld (hl),INTERACID_D6_CRYSTAL_TRAP_ROOM		; $51b4
	inc l			; $51b6
	ld (hl),$02		; $51b7
	ret			; $51b9
@notSubId0:
	ld e,Interaction.state		; $51ba
	ld a,$02		; $51bc
	ld (de),a		; $51be
	ret			; $51bf
@func_51c0:
	ld b,$20		; $51c0
-
	ldi (hl),a		; $51c2
	dec b			; $51c3
	jr nz,-			; $51c4
	ret			; $51c6
@state1:
	xor a			; $51c7
	ld ($ccab),a		; $51c8
	ld a,$3c		; $51cb
	ld ($cd19),a		; $51cd
	call interactionDecCounter1		; $51d0
	ret nz			; $51d3
	ld (hl),$78		; $51d4
	ld a,$01		; $51d6
	ld ($ccab),a		; $51d8
	ld hl,$cfd0		; $51db
	inc (hl)		; $51de
	call _func_5261		; $51df
	call _func_545a		; $51e2
	call _func_52d9		; $51e5
	call _func_537e		; $51e8
	xor a			; $51eb
	ld ($ff00+R_SVBK),a	; $51ec
	ldh a,(<hActiveObject)	; $51ee
	ld d,a			; $51f0
	ld a,$70		; $51f1
	call playSound		; $51f3
	ld a,$0f		; $51f6
	ld ($cd18),a		; $51f8
	ld a,($cfd0)		; $51fb
	cp $09			; $51fe
	ret c			; $5200
	call _func_5258		; $5201
	jp nz,interactionDelete		; $5204
	ld a,$11		; $5207
	ld ($cc6a),a		; $5209
	ld a,$81		; $520c
	ld ($cc6b),a		; $520e
	jp interactionDelete		; $5211
@state2:
	call _func_5258		; $5214
	jp nz,interactionDelete		; $5217
	ld a,($cfd0)		; $521a
	cp $09			; $521d
	jr z,_func_524d	; $521f
	ld a,($cfd0)		; $5221
	ld c,$08		; $5224
	call multiplyAByC		; $5226
	ld a,l			; $5229
	add $10			; $522a
	ld b,a			; $522c
	ld hl,$d00b		; $522d
	ld a,(hl)		; $5230
	cp b			; $5231
	jr nc,+			; $5232
	ld (hl),b		; $5234
+
	ld a,($cfd0)		; $5235
	ld b,a			; $5238
	ld a,$15		; $5239
	sub b			; $523b
	ld c,$08		; $523c
	call multiplyAByC		; $523e
	ld a,l			; $5241
	sub $0e			; $5242
	ld b,a			; $5244
	ld hl,$d00b		; $5245
	ld a,(hl)		; $5248
	cp b			; $5249
	ret c			; $524a
	ld (hl),b		; $524b
	ret			; $524c
_func_524d:
	ld a,$08		; $524d
	call setScreenShakeCounter		; $524f
	ld a,$58		; $5252
	ld ($d00b),a		; $5254
	ret			; $5257
_func_5258:
	ld a,(wActiveRoom)		; $5258
	cp $c5			; $525b
	ret z			; $525d
	cp $c6			; $525e
	ret			; $5260
_func_5261:
	ld a,$02		; $5261
	ld ($ff00+R_SVBK),a	; $5263
	ld a,($cd09)		; $5265
	cpl			; $5268
	inc a			; $5269
	swap a			; $526a
	rlca			; $526c
	ldh (<hFF8B),a	; $526d
	xor a			; $526f
	call _func_5293		; $5270
	ld a,$04		; $5273
	call _func_5293		; $5275
	ld a,$08		; $5278
	call _func_5293		; $527a
	ld a,$0c		; $527d
	call _func_5293		; $527f
	ld a,$10		; $5282
	call _func_5293		; $5284
	ld a,$14		; $5287
	call _func_5293		; $5289
	ld a,$18		; $528c
	call _func_5293		; $528e
	ld a,$1c		; $5291
_func_5293:
	ld hl,_table_52a6		; $5293
	rst_addAToHl			; $5296
	ldi a,(hl)		; $5297
	ld d,(hl)		; $5298
	ld e,a			; $5299
	inc hl			; $529a
	ldi a,(hl)		; $529b
	ld h,(hl)		; $529c
	ld l,a			; $529d
	ldh a,(<hFF8B)	; $529e
	ld c,a			; $52a0
	ld b,$00		; $52a1
	add hl,bc		; $52a3
	jr _func_52c6		; $52a4
_table_52a6:
	.dw $d020 $d0c0
	.dw $d040 $d0e0
	.dw $d060 $d100
	.dw $d080 $d120
	.dw $d420 $d4c0
	.dw $d440 $d4e0
	.dw $d460 $d500
	.dw $d480 $d520
_func_52c6:
	ld b,$20		; $52c6
--
	ld a,(hl)		; $52c8
	ld (de),a		; $52c9
	inc de			; $52ca
	inc l			; $52cb
	ld a,l			; $52cc
	and $1f			; $52cd
	jr nz,+			; $52cf
	ld a,l			; $52d1
	sub $20			; $52d2
	ld l,a			; $52d4
+
	dec b			; $52d5
	jr nz,--		; $52d6
	ret			; $52d8
_func_52d9:
	push de			; $52d9
	ld a,($cfd0)		; $52da
	add a			; $52dd
	ld hl,_table_5326		; $52de
	rst_addDoubleIndex			; $52e1
	ldi a,(hl)		; $52e2
	ld d,(hl)		; $52e3
	ld e,a			; $52e4
	inc hl			; $52e5
	push hl			; $52e6
	ld hl,$d400		; $52e7
	ld b,$05		; $52ea
	ld c,$02		; $52ec
	call queueDmaTransfer		; $52ee
	pop hl			; $52f1
	ldi a,(hl)		; $52f2
	ld d,(hl)		; $52f3
	ld e,a			; $52f4
	ld hl,$d000		; $52f5
	ld b,$05		; $52f8
	ld c,$02		; $52fa
	call queueDmaTransfer		; $52fc
	ld a,($cfd0)		; $52ff
	add a			; $5302
	ld hl,_table_5352		; $5303
	rst_addDoubleIndex			; $5306
	ldi a,(hl)		; $5307
	ld d,(hl)		; $5308
	ld e,a			; $5309
	inc hl			; $530a
	push hl			; $530b
	ld hl,$d460		; $530c
	ld b,$05		; $530f
	ld c,$02		; $5311
	call queueDmaTransfer		; $5313
	pop hl			; $5316
	ldi a,(hl)		; $5317
	ld d,(hl)		; $5318
	ld e,a			; $5319
	ld hl,$d060		; $531a
	ld b,$05		; $531d
	ld c,$02		; $531f
	call queueDmaTransfer		; $5321
	pop de			; $5324
	ret			; $5325
_table_5326:
	.db $01 $98 $00 $98
	.db $01 $98 $00 $98
	.db $21 $98 $20 $98
	.db $41 $98 $40 $98
	.db $61 $98 $60 $98
	.db $81 $98 $80 $98
	.db $a1 $98 $a0 $98
	.db $c1 $98 $c0 $98
	.db $e1 $98 $e0 $98
	.db $01 $99 $00 $99
	.db $21 $99 $20 $99
_table_5352:
	.db $61 $9a $60 $9a
	.db $61 $9a $60 $9a
	.db $41 $9a $40 $9a
	.db $21 $9a $20 $9a
	.db $01 $9a $00 $9a
	.db $e1 $99 $e0 $99
	.db $c1 $99 $c0 $99
	.db $a1 $99 $a0 $99
	.db $81 $99 $80 $99
	.db $61 $99 $60 $99
	.db $41 $99 $40 $99
_func_537e:
	ld a,($cfd0)		; $537e
	or a			; $5381
	ret z			; $5382
	bit 0,a			; $5383
	jr nz,_func_53a1	; $5385
	srl a			; $5387
	swap a			; $5389
	ld l,a			; $538b
	ld a,$0f		; $538c
	call _func_53bb		; $538e
	ld a,($cfd0)		; $5391
	srl a			; $5394
	ld b,a			; $5396
	ld a,$0a		; $5397
	sub b			; $5399
	swap a			; $539a
	ld l,a			; $539c
	ld a,$0f		; $539d
	jr _func_53bb		; $539f
_func_53a1:
	inc a			; $53a1
	srl a			; $53a2
	swap a			; $53a4
	ld l,a			; $53a6
	ld a,$0c		; $53a7
	call _func_53bb		; $53a9
	ld a,($cfd0)		; $53ac
	inc a			; $53af
	srl a			; $53b0
	ld b,a			; $53b2
	ld a,$0a		; $53b3
	sub b			; $53b5
	swap a			; $53b6
	ld l,a			; $53b8
	ld a,$03		; $53b9
_func_53bb:
	ld e,a			; $53bb
	ld b,$10		; $53bc
	ld h,$ce		; $53be
-
	ld a,(hl)		; $53c0
	or e			; $53c1
	ldi (hl),a		; $53c2
	dec b			; $53c3
	jr nz,-			; $53c4
	ret			; $53c6
_func_53c7:
	ld a,($cfd0)		; $53c7
	or a			; $53ca
	ret z			; $53cb
	bit 0,a			; $53cc
	ret nz			; $53ce
	srl a			; $53cf
	swap a			; $53d1
	ld l,a			; $53d3
	ld a,$b0		; $53d4
	call _func_53e7		; $53d6
	ld a,($cfd0)		; $53d9
	srl a			; $53dc
	ld b,a			; $53de
	ld a,$0a		; $53df
	sub b			; $53e1
	swap a			; $53e2
	ld l,a			; $53e4
	ld a,$b2		; $53e5
_func_53e7:
	ld b,$10		; $53e7
	ld h,$cf		; $53e9
-
	ldi (hl),a		; $53eb
	dec b			; $53ec
	jr nz,-			; $53ed
	ret			; $53ef

;;
; $02: D6 wall-closing room
; @addr{53f0}
roomTileChangesAfterLoad02_body:
	call _func_537e		; $53f0
	call _func_53c7		; $53f3
	ld hl,$d800		; $53f6
	ld de,$d0c0		; $53f9
	call _func_5440		; $53fc
	ld hl,$d820		; $53ff
	ld de,$d0e0		; $5402
	call _func_5440		; $5405
	ld hl,$dc00		; $5408
	ld de,$d4c0		; $540b
	call _func_5440		; $540e
	ld hl,$dc20		; $5411
	ld de,$d4e0		; $5414
	call _func_5440		; $5417
	ld hl,$da80		; $541a
	ld de,$d100		; $541d
	call _func_5440		; $5420
	ld hl,$daa0		; $5423
	ld de,$d120		; $5426
	call _func_5440		; $5429
	ld hl,$de80		; $542c
	ld de,$d500		; $542f
	call _func_5440		; $5432
	ld hl,$dea0		; $5435
	ld de,$d520		; $5438
	call _func_5440		; $543b
	jr _func_545a		; $543e
_func_5440:
	ld a,$03		; $5440
	ld ($ff00+R_SVBK),a	; $5442
	push de			; $5444
	ld de,$cd40		; $5445
	ld b,$20		; $5448
	call copyMemory		; $544a
	pop de			; $544d
	ld a,$02		; $544e
	ld ($ff00+R_SVBK),a	; $5450
	ld hl,$cd40		; $5452
	ld b,$20		; $5455
	jp copyMemory		; $5457

_func_545a:
	ld a,($cfd0)		; $545a
	or a			; $545d
	ret z			; $545e
	push de			; $545f
	push hl			; $5460
	ld hl,$d0c0		; $5461
	ld de,$cd40		; $5464
	ld b,$40		; $5467
	ld c,$02		; $5469
	call _func_553a		; $546b
	ld a,($cfd0)		; $546e
	ld hl,_table_5544		; $5471
	rst_addDoubleIndex			; $5474
	ldi a,(hl)		; $5475
	ld d,(hl)		; $5476
	ld e,a			; $5477
	ld hl,$cd40		; $5478
	ld b,$40		; $547b
	ld c,$03		; $547d
	call _func_553a		; $547f
	ld hl,$d100		; $5482
	ld de,$cd40		; $5485
	ld b,$40		; $5488
	ld c,$02		; $548a
	call _func_553a		; $548c
	ld a,($cfd0)		; $548f
	ld hl,_table_5558		; $5492
	rst_addDoubleIndex			; $5495
	ldi a,(hl)		; $5496
	ld d,(hl)		; $5497
	ld e,a			; $5498
	ld hl,$cd40		; $5499
	ld b,$40		; $549c
	ld c,$03		; $549e
	call _func_553a		; $54a0
	ld hl,$d4c0		; $54a3
	ld de,$cd40		; $54a6
	ld b,$40		; $54a9
	ld c,$02		; $54ab
	call _func_553a		; $54ad
	ld a,($cfd0)		; $54b0
	ld hl,_table_5544		; $54b3
	rst_addDoubleIndex			; $54b6
	ldi a,(hl)		; $54b7
	ld e,a			; $54b8
	ld a,(hl)		; $54b9
	add $04			; $54ba
	ld d,a			; $54bc
	ld hl,$cd40		; $54bd
	ld b,$40		; $54c0
	ld c,$03		; $54c2
	call _func_553a		; $54c4
	ld hl,$d500		; $54c7
	ld de,$cd40		; $54ca
	ld b,$40		; $54cd
	ld c,$02		; $54cf
	call _func_553a		; $54d1
	ld a,($cfd0)		; $54d4
	ld hl,_table_5558		; $54d7
	rst_addDoubleIndex			; $54da
	ldi a,(hl)		; $54db
	ld e,a			; $54dc
	ld a,(hl)		; $54dd
	add $04			; $54de
	ld d,a			; $54e0
	ld hl,$cd40		; $54e1
	ld b,$40		; $54e4
	ld c,$03		; $54e6
	call _func_553a		; $54e8
	ld a,$03		; $54eb
	ld ($ff00+R_SVBK),a	; $54ed
	ld hl,$d800		; $54ef
	ld a,$80		; $54f2
	call _func_552a		; $54f4
	ld hl,$dc00		; $54f7
	ld a,$0b		; $54fa
	call _func_552a		; $54fc
	ld a,($cfd0)		; $54ff
	ld c,a			; $5502
	ld b,$00		; $5503
	ld a,$16		; $5505
	sub c			; $5507
	ld c,a			; $5508
	ld a,$20		; $5509
	call multiplyAByC		; $550b
	ld c,l			; $550e
	ld b,h			; $550f
	ld hl,$d800		; $5510
	add hl,bc		; $5513
	ld a,$80		; $5514
	push hl			; $5516
	call _func_552a		; $5517
	pop hl			; $551a
	ld bc,$0400		; $551b
	add hl,bc		; $551e
	ld a,$0b		; $551f
	call _func_552a		; $5521
	xor a			; $5524
	ld ($ff00+R_SVBK),a	; $5525
	pop hl			; $5527
	pop de			; $5528
	ret			; $5529
_func_552a:
	ld e,a			; $552a
	ld a,($cfd0)		; $552b
	ld c,a			; $552e
	ld a,e			; $552f
--
	ld b,$20		; $5530
-
	ldi (hl),a		; $5532
	dec b			; $5533
	jr nz,-			; $5534
	dec c			; $5536
	jr nz,--		; $5537
	ret			; $5539
_func_553a:
	ld a,c			; $553a
	ld ($ff00+R_SVBK),a	; $553b
	call copyMemory		; $553d
	xor a			; $5540
	ld ($ff00+R_SVBK),a	; $5541
	ret			; $5543
_table_5544:
	.db $00 $d8
	.db $20 $d8
	.db $40 $d8
	.db $60 $d8
	.db $80 $d8
	.db $a0 $d8
	.db $c0 $d8
	.db $e0 $d8
	.db $00 $d9
	.db $20 $d9
_table_5558:
	.db $80 $da
	.db $60 $da
	.db $40 $da
	.db $20 $da
	.db $00 $da
	.db $e0 $d9
	.db $c0 $d9
	.db $a0 $d9
	.db $80 $d9
	.db $60 $d9


; ==============================================================================
; INTERACID_D7_4_ARMOS_BUTTON_PUZZLE
; ==============================================================================
interactionCode66:
	ld e,Interaction.subid		; $556c
	ld a,(de)		; $556e
	rst_jumpTable			; $556f
	.dw @subid0
	.dw @subid1
@subid1:
	ld e,Interaction.state		; $5574
	ld a,(de)		; $5576
	rst_jumpTable			; $5577
	.dw @@state0
	.dw @@state1
@@state0:
	ld a,$01		; $557c
	ld (de),a		; $557e
	call interactionInitGraphics		; $557f
	ld a,$27		; $5582
	call objectMimicBgTile		; $5584
	ld a,$06		; $5587
	call objectSetCollideRadius		; $5589
	ld l,$50		; $558c
	ld (hl),$28		; $558e
	ld l,$46		; $5590
	ld (hl),$10		; $5592
	inc l			; $5594
	ld (hl),$02		; $5595
	ld l,$4b		; $5597
	dec (hl)		; $5599
	dec (hl)		; $559a
	push de			; $559b
	call @@func_55c8		; $559c
	pop de			; $559f
	ld a,$71		; $55a0
	call playSound		; $55a2
	jp objectSetVisible82		; $55a5
@@state1:
	call objectApplySpeed		; $55a8
	call objectPreventLinkFromPassing		; $55ab
	call interactionDecCounter1		; $55ae
	ret nz			; $55b1
	ld (hl),$10		; $55b2
	inc l			; $55b4
	dec (hl)		; $55b5
	jr z,+			; $55b6
	call interactionCheckAdjacentTileIsSolid		; $55b8
	ret z			; $55bb
+
	call objectGetShortPosition		; $55bc
	ld c,a			; $55bf
	ld a,$27		; $55c0
	call setTile		; $55c2
	jp interactionDelete		; $55c5
@@func_55c8:
	call objectGetShortPosition		; $55c8
	ld c,a			; $55cb
	ld a,$03		; $55cc
	ld ($ff00+R_SVBK),a	; $55ce
	ld b,$df		; $55d0
	ld a,(bc)		; $55d2
	ld b,a			; $55d3
	xor a			; $55d4
	ld ($ff00+R_SVBK),a	; $55d5
	ld a,b			; $55d7
	jp setTile		; $55d8
@subid0:
	ld e,Interaction.state		; $55db
	ld a,(de)		; $55dd
	rst_jumpTable			; $55de
	.dw @@state0
	.dw @@state1
	.dw @@state2
@@state0:
	ld e,Interaction.state		; $55e5
	ld a,$01		; $55e7
	ld (de),a		; $55e9
	ld a,$03		; $55ea
	ld ($ff00+R_SVBK),a	; $55ec
	ld b,$df		; $55ee
	ld hl,@@table_5610		; $55f0
	ld a,$a3		; $55f3
-
	ld c,(hl)		; $55f5
	inc hl			; $55f6
	ld (bc),a		; $55f7
	dec e			; $55f8
	jr nz,-			; $55f9
	ld h,b			; $55fb
	ld l,$17		; $55fc
	ld (hl),$a0		; $55fe
	ld l,$3b		; $5600
	ld (hl),$a0		; $5602
	ld l,$5b		; $5604
	ld (hl),$a0		; $5606
	ld l,$57		; $5608
	ld (hl),$a2		; $560a
	xor a			; $560c
	ld ($ff00+R_SVBK),a	; $560d
	ret			; $560f
@@table_5610:
	.db $35 $37 $39 $55
	.db $59 $75 $77 $79
@@state1:
	ld hl,wActiveTriggers		; $5618
	bit 4,(hl)		; $561b
	jr nz,+			; $561d
	bit 0,(hl)		; $561f
	jr z,+			; $5621
	set 4,(hl)		; $5623
	ld c,$32		; $5625
	call nz,_func_5694		; $5627
+
	ld hl,wActiveTriggers		; $562a
	bit 5,(hl)		; $562d
	jr nz,+			; $562f
	bit 1,(hl)		; $5631
	jr z,+			; $5633
	set 5,(hl)		; $5635
	ld c,$52		; $5637
	call nz,_func_5694		; $5639
+
	ld hl,wActiveTriggers		; $563c
	bit 6,(hl)		; $563f
	jr nz,+			; $5641
	bit 2,(hl)		; $5643
	jr z,+			; $5645
	set 6,(hl)		; $5647
	ld c,$95		; $5649
	call nz,_func_56a5		; $564b
+
	ld hl,wActiveTriggers		; $564e
	bit 7,(hl)		; $5651
	jr nz,+			; $5653
	bit 3,(hl)		; $5655
	jr z,+			; $5657
	set 7,(hl)		; $5659
	ld c,$97		; $565b
	call nz,_func_56a5		; $565d
+
	ld a,(wActiveTriggers)		; $5660
	inc a			; $5663
	ret nz			; $5664
	call getThisRoomFlags		; $5665
	bit 5,(hl)		; $5668
	jp nz,interactionDelete		; $566a
	ld e,$46		; $566d
	ld a,$3c		; $566f
	ld (de),a		; $5671
	jp interactionIncState		; $5672
@@state2:
	call interactionDecCounter1		; $5675
	ret nz			; $5678
	ld a,$a3		; $5679
	call findTileInRoom		; $567b
	jr nz,+			; $567e
	ld a,$5a		; $5680
	call playSound		; $5682
	jp interactionDelete		; $5685
+
	ldbc TREASURE_SMALL_KEY $01		; $5688
	call createTreasure		; $568b
	call objectCopyPosition		; $568e
	jp interactionDelete		; $5691
_func_5694:
	ld b,$cf		; $5694
-
	ld a,(bc)		; $5696
	cp $27			; $5697
	ld e,$18		; $5699
	call z,_func_56b8		; $569b
	inc c			; $569e
	ld a,c			; $569f
	and $0f			; $56a0
	ret z			; $56a2
	jr -			; $56a3
_func_56a5:
	ld b,$cf		; $56a5
-
	ld a,(bc)		; $56a7
	cp $27			; $56a8
	ld e,$10		; $56aa
	call z,_func_56b8		; $56ac
	ld a,c			; $56af
	sub $10			; $56b0
	ld c,a			; $56b2
	and $f0			; $56b3
	ret z			; $56b5
	jr -			; $56b6
_func_56b8:
	call getFreeInteractionSlot		; $56b8
	ret nz			; $56bb
	ld (hl),INTERACID_D7_4_ARMOS_BUTTON_PUZZLE		; $56bc
	inc l			; $56be
	ld (hl),$01		; $56bf
	push bc			; $56c1
	ld l,$4b		; $56c2
	call setShortPosition_paramC		; $56c4
	pop bc			; $56c7
	ld l,$49		; $56c8
	ld (hl),e		; $56ca
	ret			; $56cb


; ==============================================================================
; INTERACID_D8_ARMOS_PATTERN_PUZZLE
; ==============================================================================
interactionCode67:
	ld e,Interaction.state		; $56cc
	ld a,(de)		; $56ce
	rst_jumpTable			; $56cf
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3
	.dw @state4
@state0:
	call getThisRoomFlags		; $56da
	bit 5,(hl)		; $56dd
	jp nz,interactionDelete		; $56df
	ld a,$0a		; $56e2
	call objectSetCollideRadius		; $56e4
	ld l,$44		; $56e7
	inc (hl)		; $56e9
	jp interactionInitGraphics		; $56ea
@state1:
	call objectCheckCollidedWithLink_notDead		; $56ed
	ret nc			; $56f0
	call getRandomNumber		; $56f1
	and $0f			; $56f4
	ld hl,@table_5727		; $56f6
	rst_addAToHl			; $56f9
	ld a,(hl)		; $56fa
	ld e,$43		; $56fb
	ld (de),a		; $56fd
	ld hl,@table_571f		; $56fe
	rst_addDoubleIndex			; $5701
	ldi a,(hl)		; $5702
	ld h,(hl)		; $5703
	ld l,a			; $5704
	call interactionSetScript		; $5705
	call interactionIncState		; $5708
	ld a,$81		; $570b
	ld ($cca4),a		; $570d
	call objectSetVisible82		; $5710
	call setCameraFocusedObject		; $5713
	call _func_57f3		; $5716
	ld e,$79		; $5719
	ld (de),a		; $571b
	jp objectCreatePuff		; $571c
@table_571f:
	.dw d8ArmosScript_pattern1
	.dw d8ArmosScript_pattern2
	.dw d8ArmosScript_pattern3
	.dw d8ArmosScript_pattern4
@table_5727:
	.db $00 $01 $02 $03
	.db $00 $01 $02 $03
	.db $00 $01 $02 $03
	.db $00 $01 $02 $03
@state2:
	ld a,(wFrameCounter)		; $5737
	rrca			; $573a
	jr nc,+			; $573b
	ld a,$80		; $573d
	ld h,d			; $573f
	ld l,$5a		; $5740
	xor (hl)		; $5742
	ld (hl),a		; $5743
+
	call interactionAnimate		; $5744
	jp interactionRunScript		; $5747
@state3:
	ld e,$5a		; $574a
	xor a			; $574c
	ld (de),a		; $574d
	call _func_57f3		; $574e
	ld b,a			; $5751
	ld e,$79		; $5752
	ld a,(de)		; $5754
	cp b			; $5755
	ret z			; $5756
	ld e,$43		; $5757
	ld a,(de)		; $5759
	ld hl,@table_579a		; $575a
	rst_addDoubleIndex			; $575d
	ldi a,(hl)		; $575e
	ld h,(hl)		; $575f
	ld l,a			; $5760
	ld e,$78		; $5761
	ld a,(de)		; $5763
	rst_addAToHl			; $5764
	ld a,(hl)		; $5765
	cp b			; $5766
	jr nz,@func_5792	; $5767
	cp $1c			; $5769
	jr z,@func_577f		; $576b
	ld c,a			; $576d
	ld a,(de)		; $576e
	inc a			; $576f
	ld (de),a		; $5770
	ld a,b			; $5771
	ld e,$79		; $5772
	ld (de),a		; $5774
@func_5775:
	ld a,$a2		; $5775
	call setTile		; $5777
	ld a,$62		; $577a
	jp playSound		; $577c
@func_577f:
	ld c,$1c		; $577f
	call @func_5775		; $5781
	call interactionIncState		; $5784
	ld a,$4d		; $5787
	call playSound		; $5789
	ld hl,d8ArmosScript_giveKey		; $578c
	jp interactionSetScript		; $578f
@func_5792:
	ld a,$5a		; $5792
	call playSound		; $5794
	jp interactionDelete		; $5797
@table_579a:
	.dw @@table_57a2
	.dw @@table_57b3
	.dw @@table_57c2
	.dw @@table_57d7
@@table_57a2:
	.db $9c $8c $7c $7d
	.db $6d $6c $6b $6a
	.db $5a $4a $3a $2a
	.db $1a $1b $2b $2c
	.db $1c
@@table_57b3:
	.db $9c $8c $7c $7d
	.db $6d $5d $4d $4c
	.db $4b $4a $3a $2a
	.db $1a $1b $1c
@@table_57c2:
	.db $9c $9b $9a $8a
	.db $8b $8c $8d $7d
	.db $7c $7b $7a $6a
	.db $5a $4a $3a $2a
	.db $2b $2c $2d $1d
	.db $1c
@@table_57d7:
	.db $9c $8c $7c $6c
	.db $5c $5b $6b $7b
	.db $7c $7d $6d $6c
	.db $6b $6a $5a $4a
	.db $3a $2a $1a $1b
	.db $1c
@state4:
	call interactionRunScript		; $57ec
	jp c,interactionDelete		; $57ef
	ret			; $57f2
_func_57f3:
	ld hl,$d00b		; $57f3
	ldi a,(hl)		; $57f6
	add $04			; $57f7
	and $f0			; $57f9
	ld b,a			; $57fb
	inc l			; $57fc
	ld a,(hl)		; $57fd
	swap a			; $57fe
	and $0f			; $5800
	or b			; $5802
	ret			; $5803


; ==============================================================================
; INTERACID_D8_GRABBABLE_ICE
; ==============================================================================
interactionCode68:
	ld e,Interaction.state		; $5804
	ld a,(de)		; $5806
	rst_jumpTable			; $5807
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3
@state0:
	ld a,$01		; $5810
	ld (de),a		; $5812
	call interactionInitGraphics		; $5813
	ld a,$06		; $5816
	call objectSetCollideRadius		; $5818
	jp objectSetVisiblec2		; $581b
@state1:
	ld c,$20		; $581e
	call objectUpdateSpeedZ_paramC		; $5820
	ld a,($cc77)		; $5823
	or a			; $5826
	jr nz,+			; $5827
	ld a,($cc48)		; $5829
	rrca			; $582c
	call nc,objectPushLinkAwayOnCollision		; $582d
+
	call objectAddToGrabbableObjectBuffer		; $5830
@func_5833:
	call objectCheckIsOnHazard		; $5833
	ret nc			; $5836
	bit 6,a			; $5837
	jr nz,+			; $5839
	dec a			; $583b
	jp z,objectReplaceWithSplash		; $583c
	jp objectReplaceWithFallingDownHoleInteraction		; $583f
+
	call getThisRoomFlags		; $5842
	bit 6,(hl)		; $5845
	jp nz,objectReplaceWithFallingDownHoleInteraction		; $5847
	call objectSetInvisible		; $584a
	ld l,$44		; $584d
	ld (hl),$03		; $584f
	ld l,$46		; $5851
	ld (hl),$1e		; $5853
	ld b,INTERACID_FALLDOWNHOLE		; $5855
	jp objectCreateInteractionWithSubid00		; $5857
@state2:
	ld e,Interaction.state2		; $585a
	ld a,(de)		; $585c
	rst_jumpTable			; $585d
	.dw @@substate0
	.dw @@substate1
	.dw @@substate2
	.dw @@substate3
@@substate0:
	ld h,d			; $5866
	ld l,e			; $5867
	inc (hl)		; $5868
	xor a			; $5869
	ld (wLinkGrabState2),a		; $586a
	jp objectSetVisible81		; $586d
@@substate1:
	ret			; $5870
@@substate2:
	call objectCheckWithinRoomBoundary		; $5871
	jp nc,interactionDelete		; $5874
	call objectSetVisiblec1		; $5877
	ld h,d			; $587a
	ld l,$40		; $587b
	res 1,(hl)		; $587d
	ld e,$4f		; $587f
	ld a,(de)		; $5881
	or a			; $5882
	jr z,@func_5833		; $5883
	ret			; $5885
@@substate3:
	ld h,d			; $5886
	ld l,$40		; $5887
	res 1,(hl)		; $5889
	ld l,$45		; $588b
	xor a			; $588d
	ldd (hl),a		; $588e
	inc a			; $588f
	ld (hl),a		; $5890
	jp objectSetVisible82		; $5891
@state3:
	call interactionDecCounter1		; $5894
	ret nz			; $5897
	ld a,($d004)		; $5898
	cp $01			; $589b
	jr nz,_delete	; $589d
	ld a,($cc34)		; $589f
	or a			; $58a2
	jr nz,_delete	; $58a3
	ld a,($cc48)		; $58a5
	cp $d0			; $58a8
	jr nz,_delete	; $58aa
	call resetLinkInvincibility		; $58ac
	ld a,$80		; $58af
	ld ($cc02),a		; $58b1
	ld ($ccaa),a		; $58b4
	ld ($ccab),a		; $58b7
	call getThisRoomFlags		; $58ba
	set 6,(hl)		; $58bd
	call _func_58e4		; $58bf
	ldh a,(<hActiveObject)	; $58c2
	ld d,a			; $58c4
	ld a,(wDungeonFloor)		; $58c5
	dec a			; $58c8
	ld (wDungeonFloor),a		; $58c9
	call getActiveRoomFromDungeonMapPosition		; $58cc
	ld (wWarpDestRoom),a		; $58cf
	ld a,$85		; $58d2
	ld (wWarpDestGroup),a		; $58d4
	ld a,$0f		; $58d7
	ld (wWarpTransition),a		; $58d9
	ld a,$03		; $58dc
	ld (wWarpTransition2),a		; $58de
_delete:
	jp interactionDelete		; $58e1
_func_58e4:
	call objectGetTileAtPosition		; $58e4
	dec h			; $58e7
	ld b,l			; $58e8
	ld a,(wActiveTileIndex)		; $58e9
	cp $d0			; $58ec
	ld a,(wActiveTilePos)		; $58ee
	jr nz,_func_590c	; $58f1
	ld a,b			; $58f3
	sub $10			; $58f4
	call _func_5907		; $58f6
	jr z,_func_590b	; $58f9
	ld a,b			; $58fb
	inc a			; $58fc
	call _func_5907		; $58fd
	jr z,_func_590b	; $5900
	ld a,b			; $5902
	add $10			; $5903
	jr _func_590c		; $5905
_func_5907:
	ld l,a			; $5907
	ld a,(hl)		; $5908
	or a			; $5909
	ret			; $590a
_func_590b:
	ld a,l			; $590b
_func_590c:
	ld ($cfd0),a		; $590c
	ld a,(wActiveRoom)		; $590f
	cp $7f			; $5912
	jr nz,+			; $5914
	ld b,$27		; $5916
+
	ld a,b			; $5918
	ld (wWarpDestPos),a		; $5919
	ret			; $591c


; ==============================================================================
; INTERACID_D8_FREEZING_LAVA_EVENT
; ==============================================================================
interactionCode69:
	ld e,Interaction.subid		; $591d
	ld a,(de)		; $591f
	rst_jumpTable			; $5920
	.dw @subid0
	.dw @subid1
	.dw @subid2
	.dw @subid3
	.dw @subid4
@subid0:
	ld e,$44			; $592b
	ld a,(de)		; $592d
	rst_jumpTable			; $592e
	.dw @@state0
	.dw @@state1
	.dw @@state2
	.dw @@state3
@@state0:
	ld e,Interaction.state2		; $5937
	ld a,(de)		; $5939
	rst_jumpTable			; $593a
	.dw @@@substate0
	.dw @@@substate1
@@@substate0:
	call getThisRoomFlags		; $593f
	bit 6,(hl)		; $5942
	jp nz,interactionDelete		; $5944
	ld e,$4d		; $5947
	ld a,(de)		; $5949
	ld e,$43		; $594a
	ld (de),a		; $594c
	ld hl,@@@table_5976		; $594d
	rst_addAToHl			; $5950
	ld b,(hl)		; $5951
	call getThisRoomFlags		; $5952
	ld l,b			; $5955
	bit 6,(hl)		; $5956
	jp z,interactionDelete		; $5958
	call getThisRoomFlags		; $595b
	set 6,(hl)		; $595e
	ld e,Interaction.state2		; $5960
	ld a,$01		; $5962
	ld (de),a		; $5964
	ld a,$f0		; $5965
	call playSound		; $5967
	ld a,$ff		; $596a
	ld (wActiveMusic),a		; $596c
	ld a,$80		; $596f
	ld ($cca4),a		; $5971
	jr @@@substate1		; $5974
@@@table_5976:
	.db $7e $7f $88 $89
@@@substate1:
	call _func_5ae0		; $597a
	ld a,($c4ab)		; $597d
	or a			; $5980
	ret nz			; $5981
	ld e,Interaction.state		; $5982
	ld a,$01		; $5984
	ld (de),a		; $5986
	xor a			; $5987
	inc e			; $5988
	ld (de),a		; $5989
	call getFreeInteractionSlot		; $598a
	jp nz,interactionDelete		; $598d
	ld (hl),INTERACID_D8_FREEZING_LAVA_EVENT		; $5990
	inc l			; $5992
	ld (hl),$01		; $5993
	ld e,$4b		; $5995
	ld a,(de)		; $5997
	ld l,$4b		; $5998
	jp setShortPosition		; $599a
@@state1:
	ld a,($cfc0)		; $599d
	inc a			; $59a0
	ret nz			; $59a1
	ld e,Interaction.state		; $59a2
	ld a,$02		; $59a4
	ld (de),a		; $59a6
	ld e,$43		; $59a7
	ld a,(de)		; $59a9
	ld hl,_table_5b0d		; $59aa
	rst_addDoubleIndex			; $59ad
	ld e,$58		; $59ae
	ldi a,(hl)		; $59b0
	ld (de),a		; $59b1
	inc e			; $59b2
	ld a,(hl)		; $59b3
	ld (de),a		; $59b4
	ld h,d			; $59b5
	ld l,$46		; $59b6
	ld (hl),$14		; $59b8
	inc l			; $59ba
	ld (hl),$03		; $59bb
	call fastFadeoutToWhite		; $59bd
@@state2:
	ld a,$3c		; $59c0
	call setScreenShakeCounter		; $59c2
	call interactionDecCounter1		; $59c5
	ret nz			; $59c8
	ld (hl),$14		; $59c9
	inc l			; $59cb
	dec (hl)		; $59cc
	jp nz,fastFadeoutToWhite		; $59cd
	ld l,$44		; $59d0
	inc (hl)		; $59d2
	call clearPaletteFadeVariablesAndRefreshPalettes		; $59d3
	call getFreeInteractionSlot		; $59d6
	jr nz,@@state3		; $59d9
	ld (hl),INTERACID_D8_FREEZING_LAVA_EVENT		; $59db
	inc l			; $59dd
	ld (hl),$04		; $59de
	ld e,$58		; $59e0
	ld l,e			; $59e2
	ld a,(de)		; $59e3
	ldi (hl),a		; $59e4
	inc e			; $59e5
	ld a,(de)		; $59e6
	ld (hl),a		; $59e7
	ld l,$46		; $59e8
	ld (hl),$84		; $59ea
@@state3:
	ld a,$3c		; $59ec
	call setScreenShakeCounter		; $59ee
	ld a,($c4ab)		; $59f1
	or a			; $59f4
	ret nz			; $59f5
	call interactionDecCounter1		; $59f6
	ret nz			; $59f9
	ld (hl),$08		; $59fa
	ld a,$7a		; $59fc
	call playSound		; $59fe
	ld b,$d6		; $5a01
	call _func_5af7		; $5a03
	ret nz			; $5a06
	jp interactionDelete		; $5a07
@func_5a0a:
	ld a,($cc57)		; $5a0a
	inc a			; $5a0d
	ld ($cc57),a		; $5a0e
	call getActiveRoomFromDungeonMapPosition		; $5a11
	ld ($cc64),a		; $5a14
	ld a,($cfd0)		; $5a17
	ld ($cc66),a		; $5a1a
	ld a,($cc49)		; $5a1d
	or $80			; $5a20
	ld ($cc63),a		; $5a22
	xor a			; $5a25
	ld ($cc65),a		; $5a26
	ld a,$03		; $5a29
	ld ($cc67),a		; $5a2b
	call getThisRoomFlags		; $5a2e
	res 4,(hl)		; $5a31
	xor a			; $5a33
	ld ($cca4),a		; $5a34
	ld ($cc02),a		; $5a37
	jp interactionDelete		; $5a3a
@subid1:
	ld e,Interaction.state		; $5a3d
	ld a,(de)		; $5a3f
	rst_jumpTable			; $5a40
	.dw @@state0
	.dw @@state1
@@state0:
	ld a,$01		; $5a45
	ld (de),a		; $5a47
	call interactionInitGraphics		; $5a48
	call objectGetZAboveScreen		; $5a4b
	ld e,$4f		; $5a4e
	ld (de),a		; $5a50
	call objectSetVisiblec0		; $5a51
	call getFreeInteractionSlot		; $5a54
	ret nz			; $5a57
	ld (hl),INTERACID_D8_FREEZING_LAVA_EVENT		; $5a58
	inc l			; $5a5a
	ld (hl),$02		; $5a5b
	ld e,$59		; $5a5d
	ld a,h			; $5a5f
	ld (de),a		; $5a60
	jp objectCopyPosition		; $5a61
@@state1:
	ld e,$59		; $5a64
	ld a,(de)		; $5a66
	ld h,a			; $5a67
	ld l,$4a		; $5a68
	ld e,l			; $5a6a
	ld b,$06		; $5a6b
	call copyMemoryReverse		; $5a6d
	ld c,$08		; $5a70
	call objectUpdateSpeedZ_paramC		; $5a72
	ret nz			; $5a75
	ldbc INTERACID_D8_FREEZING_LAVA_EVENT $03		; $5a76
	call objectCreateInteraction		; $5a79
	jr nz,+			; $5a7c
	ld a,$01		; $5a7e
	ld ($cfc0),a		; $5a80
+
	jp interactionDelete		; $5a83
@subid2:
	ld e,Interaction.state		; $5a86
	ld a,(de)		; $5a88
	or a			; $5a89
	jr nz,+			; $5a8a
	ld a,$01		; $5a8c
	ld (de),a		; $5a8e
	call interactionInitGraphics		; $5a8f
	call objectSetVisible83		; $5a92
+
	ld a,($cfc0)		; $5a95
	or a			; $5a98
	jp nz,interactionDelete		; $5a99
	jp interactionAnimate		; $5a9c
@subid3:
	ld e,Interaction.state		; $5a9f
	ld a,(de)		; $5aa1
	or a			; $5aa2
	jr nz,+			; $5aa3
	ld a,$01		; $5aa5
	ld (de),a		; $5aa7
	call interactionInitGraphics		; $5aa8
	call objectSetVisible83		; $5aab
	ld a,$5c		; $5aae
	call playSound		; $5ab0
+
	call interactionAnimate		; $5ab3
	ld e,$61		; $5ab6
	ld a,(de)		; $5ab8
	inc a			; $5ab9
	ret nz			; $5aba
	ld a,$ff		; $5abb
	ld ($cfc0),a		; $5abd
	call objectGetShortPosition		; $5ac0
	ld c,a			; $5ac3
	ld a,$d5		; $5ac4
	call setTile		; $5ac6
	jp interactionDelete		; $5ac9
@subid4:
	ld a,($c4ab)		; $5acc
	or a			; $5acf
	ret nz			; $5ad0
	call interactionDecCounter1		; $5ad1
	ret nz			; $5ad4
	ld (hl),$08		; $5ad5
	ld b,$d7		; $5ad7
	call _func_5af7		; $5ad9
	ret nz			; $5adc
	jp @func_5a0a		; $5add
_func_5ae0:
	ld hl,$d080		; $5ae0
-
	ld a,(hl)		; $5ae3
	or a			; $5ae4
	call nz,_func_5aef		; $5ae5
	inc h			; $5ae8
	ld a,h			; $5ae9
	cp $e0			; $5aea
	jr c,-			; $5aec
	ret			; $5aee
_func_5aef:
	xor a			; $5aef
	ld l,$9a		; $5af0
	ld (hl),a		; $5af2
	ld l,$80		; $5af3
	ld (hl),a		; $5af5
	ret			; $5af6
_func_5af7:
	ld h,d			; $5af7
	ld l,$58		; $5af8
	ld e,l			; $5afa
	ldi a,(hl)		; $5afb
	ld h,(hl)		; $5afc
	ld l,a			; $5afd
	ldi a,(hl)		; $5afe
	or a			; $5aff
	ret z			; $5b00
	ld c,a			; $5b01
	ld a,l			; $5b02
	ld (de),a		; $5b03
	inc e			; $5b04
	ld a,h			; $5b05
	ld (de),a		; $5b06
	ld a,b			; $5b07
	call setTile		; $5b08
	or d			; $5b0b
	ret			; $5b0c
_table_5b0d:
	.dw _table_5b15
	.dw _table_5b3f
	.dw _table_5b73
	.dw _table_5bbb
_table_5b15:
	.db $34 $44 $43 $45 $42 $46 $41 $47
	.db $53 $55 $52 $31 $37 $21 $27 $28
	.db $11 $17 $18 $51 $62 $61 $64 $66
	.db $67 $68 $74 $73 $75 $72 $76 $71
	.db $77 $81 $82 $83 $84 $85 $86 $87
	.db $88 $00
_table_5b3f:
	.db $27 $37 $36 $47 $38 $46 $48 $35
	.db $39 $3a $4a $49 $59 $58 $57 $56
	.db $45 $44 $55 $54 $2a $1a $1b $53
	.db $63 $64 $4b $5b $5a $1c $2c $3c
	.db $6a $69 $68 $67 $66 $62 $76 $77
	.db $6b $5c $6c $7c $7b $7a $79 $78
	.db $72 $73 $74 $00
_table_5b73:
	.db $37 $47 $57 $46 $56 $66 $67 $48
	.db $58 $68 $45 $55 $65 $49 $59 $69
	.db $64 $54 $44 $34 $5a $6a $6b $5b
	.db $4b $7b $7a $79 $5c $6c $7c $74
	.db $73 $63 $53 $43 $77 $78 $3a $2a
	.db $1a $33 $23 $22 $32 $42 $52 $62
	.db $72 $24 $14 $13 $03 $02 $12 $04
	.db $05 $3b $2b $1b $0b $2c $3c $4c
	.db $0a $09 $08 $0c $1c $06 $07 $00
_table_5bbb:
	.db $79 $89 $88 $99 $8a $87 $97 $98
	.db $9a $9b $8b $76 $86 $9c $9d $8d
	.db $7d $6d $5d $2d $2c $2a $29 $4d
	.db $3d $4c $4a $3c $3b $49 $38 $3a
	.db $39 $75 $85 $65 $95 $84 $94 $27
	.db $26 $24 $00


; ==============================================================================
; INTERACID_DANCE_HALL_MINIGAME
; ==============================================================================
interactionCode6a:
	ld e,Interaction.subid		; $5be6
	ld a,(de)		; $5be8
	rst_jumpTable			; $5be9
	.dw @subid0
	.dw @subid1
	.dw @subid2
	.dw @subid3
@subid0:
	ld a,$01		; $5bf2
	ld ($ccea),a		; $5bf4
	ld b,$20		; $5bf7
	ld hl,$cfc0		; $5bf9
	call clearMemory		; $5bfc
	ld hl,objectData.objectData7e6c		; $5bff
	call parseGivenObjectData		; $5c02
	jp interactionDelete		; $5c05
@subid1:
	ld e,Interaction.state		; $5c08
	ld a,(de)		; $5c0a
	rst_jumpTable			; $5c0b
	.dw @@state0
	.dw @@state1
	.dw @@state2
	.dw @@state3
	.dw @@state4
	.dw @@state5
@@state0:
	call @@func_5c21		; $5c18
	ld hl,dancecLeaderScript_promptToStartDancing		; $5c1b
	jp interactionSetScript		; $5c1e
@@func_5c21:
	ld a,$01		; $5c21
	ld (de),a		; $5c23
	call interactionSetAlwaysUpdateBit		; $5c24
	ld l,$48		; $5c27
	ld (hl),$02		; $5c29
	inc l			; $5c2b
	ld (hl),$10		; $5c2c
	call interactionInitGraphics		; $5c2e
	jp objectSetVisiblec2		; $5c31
@@state2:
	ld c,$28		; $5c34
	call objectUpdateSpeedZ_paramC		; $5c36
	call interactionRunScript		; $5c39
	jp interactionAnimate		; $5c3c
@@state3:
	call interactionAnimate		; $5c3f
	ld e,Interaction.state2		; $5c42
	ld a,(de)		; $5c44
	rst_jumpTable			; $5c45
	.dw @@@substate0
	.dw interactionRunScript
	.dw @@@substate2
@@@substate0:
	ld a,$01		; $5c4c
	ld (de),a		; $5c4e
	ld ($cfda),a		; $5c4f
	ld a,$50		; $5c52
	ld ($cfd3),a		; $5c54
	ld hl,danceLeaderScript_promptForTutorial		; $5c57
	jp interactionSetScript		; $5c5a
@@@substate2:
	ld a,($c4ab)		; $5c5d
	or a			; $5c60
	ret nz			; $5c61
	xor a			; $5c62
	ld h,d			; $5c63
	ld l,e			; $5c64
	ldd (hl),a		; $5c65
	inc (hl)		; $5c66
	ld a,$01		; $5c67
	call setLinkIDOverride		; $5c69
	jp fastFadeinFromWhite		; $5c6c

@@func_5c6f:
	ld a,$01		; $5c6f
	ld ($cfd2),a		; $5c71
	ld a,$04		; $5c74
	jr +++		; $5c76

@@func_5c78:
	ld a,$ff		; $5c78
	ld ($cfd2),a		; $5c7a
	ld a,$04		; $5c7d
	jr +++		; $5c7f

@@func_5c81:
	ld a,$05		; $5c81
	jr +++		; $5c83
	
	ld a,$03		; $5c85
+++
	ld ($cfd4),a		; $5c87
	ld a,$09		; $5c8a
	ld ($cfd1),a		; $5c8c
	ld hl,$cfda		; $5c8f
	inc (hl)		; $5c92
	ret			; $5c93

@@state4:
	ld e,Interaction.state2		; $5c94
	ld a,(de)		; $5c96
	rst_jumpTable			; $5c97
	.dw @@@substate0
	.dw @@@substate1
	.dw @@@substate2
	.dw @@@substate3
	.dw @@@substate4
@@@substate0:
	ld a,$01		; $5ca2
	ld (de),a		; $5ca4
	ld a,($c6e2)		; $5ca5
	cp $08			; $5ca8
	jr c,+			; $5caa
	ld a,$08		; $5cac
+
	ld ($cfd7),a		; $5cae
	ld ($cfdc),a		; $5cb1
	call @@@func_5cdd		; $5cb4
	ld a,($cfd7)		; $5cb7
	ld hl,@@@table_5d0b		; $5cba
	rst_addAToHl			; $5cbd
	call getRandomNumber		; $5cbe
	and $03			; $5cc1
	add (hl)		; $5cc3
	ld ($cfd5),a		; $5cc4
	xor a			; $5cc7
	ld ($cfd4),a		; $5cc8
	ld ($cfdb),a		; $5ccb
	ld a,$cc		; $5cce
	call playSound		; $5cd0
	ld e,$47		; $5cd3
	ld a,$3c		; $5cd5
	ld (de),a		; $5cd7
	ld a,$22		; $5cd8
	jp playSound		; $5cda
@@@func_5cdd:
	ld a,($cfd7)		; $5cdd
	ld hl,@@@table_5ced		; $5ce0
	rst_addDoubleIndex			; $5ce3
	ldi a,(hl)		; $5ce4
	ld ($cfd3),a		; $5ce5
	ldi a,(hl)		; $5ce8
	ld ($cfd6),a		; $5ce9
	ret			; $5cec
@@@table_5ced:
	.db $28 $20
	.db $32 $1e
	.db $32 $1c
	.db $3c $1a
	.db $3c $18
	.db $46 $16
	.db $46 $14
	.db $50 $14
	.db $50 $12
	.db $5a $12
	.db $64 $10
	.db $64 $10
	.db $64 $0e
	.db $78 $0d
	.db $78 $0c
@@@table_5d0b:
	.db $09 $09 $0a
	.db $0c $0e $10
	.db $12 $14 $18
@@@substate1:
	call interactionDecCounter2			; $5d14
	ret nz			; $5d17
	ld (hl),$01		; $5d18
	ld a,$02		; $5d1a
	ld (de),a		; $5d1c
	ld hl,$cfc8		; $5d1d
	call @func_5ec4		; $5d20
	ldi (hl),a		; $5d23
	call @func_5ec4		; $5d24
	ldi (hl),a		; $5d27
	call @func_5ec4		; $5d28
	ldi (hl),a		; $5d2b
	xor a			; $5d2c
	ld (hl),a		; $5d2d
	ld e,$46		; $5d2e
	ld a,($cfd6)		; $5d30
	ld (de),a		; $5d33
	call @func_5eb9		; $5d34
@@@substate2:
	call @func_5f1d		; $5d37
	ret nz			; $5d3a
	ld a,($cfcb)		; $5d3b
	cp $03			; $5d3e
	jr z,+			; $5d40
	jp @func_5ee1		; $5d42
+
	call interactionIncState2		; $5d45
	ld a,($cfd6)		; $5d48
	ld l,$46		; $5d4b
	ld (hl),a		; $5d4d
	xor a			; $5d4e
	ld ($cfcb),a		; $5d4f
	ld ($cfd9),a		; $5d52
	ld a,$ff		; $5d55
	ld ($cfd8),a		; $5d57
	ld a,$02		; $5d5a
	call interactionSetAnimation		; $5d5c
@@@substate3:
	call @func_5e97		; $5d5f
	jr nz,@@@func_5d91	; $5d62
	call @func_5f1d		; $5d64
	ret nz			; $5d67
	ld a,($cfd1)		; $5d68
	or a			; $5d6b
	ret nz			; $5d6c
	ld a,($cfcb)		; $5d6d
	cp $03			; $5d70
	jr z,+			; $5d72
	jp @func_5eea		; $5d74
+
	ld a,($cfd9)		; $5d77
	cp $03			; $5d7a
	jr nz,@@@func_5d91	; $5d7c
	ld hl,$cfd5		; $5d7e
	dec (hl)		; $5d81
	jr z,@@@func_5dab	; $5d82
	call @@func_5e77		; $5d84
	ld e,Interaction.state2		; $5d87
	ld a,$01		; $5d89
	ld (de),a		; $5d8b
	xor a			; $5d8c
	ld ($cfcb),a		; $5d8d
	ret			; $5d90
@@@func_5d91:
	ld bc,TX_0104		; $5d91
	call showText		; $5d94
	ld a,$04		; $5d97
	ld e,Interaction.state2		; $5d99
	ld (de),a		; $5d9b
	ld a,$ff		; $5d9c
	ld ($cfd0),a		; $5d9e
	ld a,$cc		; $5da1
	call playSound		; $5da3
	ld a,$fb		; $5da6
	jp playSound		; $5da8
@@@func_5dab:
	call interactionIncState		; $5dab
	inc l			; $5dae
	ld (hl),$00		; $5daf
	ld a,$01		; $5db1
	ld ($cfd0),a		; $5db3
	ld a,$fb		; $5db6
	call playSound		; $5db8
	ld bc,TX_010a		; $5dbb
	jp showText		; $5dbe
@@@substate4:
	call retIfTextIsActive		; $5dc1
	ld hl,@@@warpDestVariables		; $5dc4
	jp setWarpDestVariables		; $5dc7
@@@warpDestVariables:
	m_HardcodedWarpA ROOM_SEASONS_124 $00 $14 $03
@@state5:
	ld e,Interaction.state2		; $5dcf
	ld a,(de)		; $5dd1
	rst_jumpTable			; $5dd2
	.dw @@@substate0
	.dw @@@substate1
	.dw @@@substate2
	.dw interactionRunScript
	.dw @@state4@substate4
@@@substate0:
	call retIfTextIsActive		; $5ddd
	ld e,Interaction.state2		; $5de0
	ld a,$01		; $5de2
	ld (de),a		; $5de4
	jp fastFadeoutToWhite		; $5de5
@@@substate1:
	ld a,($c4ab)		; $5de8
	or a			; $5deb
	ret nz			; $5dec
	xor a			; $5ded
	call setLinkIDOverride		; $5dee
	ld l,$0b		; $5df1
	ld (hl),$30		; $5df3
	ld l,$0d		; $5df5
	ld (hl),$48		; $5df7
	ld l,$08		; $5df9
	ld (hl),$02		; $5dfb
	call interactionIncState2		; $5dfd
	ld a,$81		; $5e00
	ld ($cca4),a		; $5e02
	ld ($cbca),a		; $5e05
	ld a,$1e		; $5e08
	call addToGashaMaturity		; $5e0a
	jp fastFadeinFromWhite		; $5e0d
@@@substate2:
	ld a,($c4ab)		; $5e10
	or a			; $5e13
	ret nz			; $5e14
	ld a,$81		; $5e15
	ld ($cca4),a		; $5e17
	ld ($cc02),a		; $5e1a
	ld hl,$c6e2		; $5e1d
	call incHlRefWithCap		; $5e20
	ld a,(hl)		; $5e23
	dec a			; $5e24
	jr z,@@@func_5e25	; $5e25
	cp $08			; $5e27
	jr z,@@@func_5e40	; $5e29
	cp $05			; $5e2b
	jr nz,@@@func_5e56	; $5e2d
	call checkIsLinkedGame		; $5e2f
	jr nz,@@@func_5e56	; $5e32
	ld a,($c643)		; $5e34
	and $20			; $5e37
	jr nz,@@@func_5e56	; $5e39
	ld hl,danceLeaderScript_giveFlute		; $5e3b
	jr @@@func_5e68		; $5e3e
@@@func_5e40:
	callab scriptHlp.seasonsFunc_15_5e20
	bit 7,b			; $5e48
	jr nz,+			; $5e4a
	ld c,$00		; $5e4c
	call giveRingToLink		; $5e4e
	ld hl,_danceLeaderScript_itemGiven		; $5e51
	jr @@@func_5e68		; $5e54
@@@func_5e56:
	call getRandomNumber		; $5e56
	cp $60			; $5e59
	ld hl,danceLeaderScript_giveOreChunks		; $5e5b
	jr nc,@@@func_5e68	; $5e5e
+
	ld hl,danceLeaderScript_gashaSeed		; $5e60
	jr @@@func_5e68		; $5e63
@@@func_5e25:
	ld hl,danceLeaderScript_boomerang		; $5e65
@@@func_5e68:
	call interactionSetScript		; $5e68
	ld e,Interaction.state2		; $5e6b
	ld a,$03		; $5e6d
	ld (de),a		; $5e6f
	ret			; $5e70
@@state1:
	call interactionRunScript		; $5e71
	jp npcFaceLinkAndAnimate		; $5e74
@@func_5e77:
	ld hl,$cfdb		; $5e77
	ld a,(hl)		; $5e7a
	cp $08			; $5e7b
	jr c,+			; $5e7d
	ld a,$08		; $5e7f
+
	inc a			; $5e81
	ld (hl),a		; $5e82
	ld b,a			; $5e83
	and $03			; $5e84
	ret nz			; $5e86
	ld a,b			; $5e87
	rrca			; $5e88
	rrca			; $5e89
	and $03			; $5e8a
	ld b,a			; $5e8c
	ld a,($cfd7)		; $5e8d
	add b			; $5e90
	ld ($cfd7),a		; $5e91
	jp @@state4@func_5cdd		; $5e94
@func_5e97:
	ld a,($cfdd)		; $5e97
	or a			; $5e9a
	ret nz			; $5e9b
	ld a,($cfd8)		; $5e9c
	ld b,a			; $5e9f
	inc a			; $5ea0
	ret z			; $5ea1
	ld a,($cfd9)		; $5ea2
	cp $03			; $5ea5
	ret z			; $5ea7
	ld hl,$cfd9		; $5ea8
	inc (hl)		; $5eab
	ld hl,$cfc8		; $5eac
	rst_addAToHl			; $5eaf
	ld a,(hl)		; $5eb0
	cp b			; $5eb1
	ret nz			; $5eb2
	ld a,$ff		; $5eb3
	ld ($cfd8),a		; $5eb5
	ret			; $5eb8
@func_5eb9:
	ld a,$02		; $5eb9
	call interactionSetAnimation		; $5ebb
	ld bc,$fe80		; $5ebe
	jp objectSetSpeedZ		; $5ec1
@func_5ec4:
	call getRandomNumber		; $5ec4
	and $0f			; $5ec7
	ld bc,@table_5ed1		; $5ec9
	call addAToBc		; $5ecc
	ld a,(bc)		; $5ecf
	ret			; $5ed0
@table_5ed1:
	.db $00 $00 $00 $00
	.db $00 $00 $00 $00
	.db $01 $01 $01 $01
	.db $02 $02 $02 $02
@func_5ee1:
	call @func_5efd		; $5ee1
	ld a,e			; $5ee4
	call interactionSetAnimation		; $5ee5
	jr +			; $5ee8
@func_5eea:
	call @func_5efd		; $5eea
	ldh a,(<hFF8B)	; $5eed
	call @func_5f10		; $5eef
+
	ld hl,$cfcb		; $5ef2
	inc (hl)		; $5ef5
	ld e,$46		; $5ef6
	ld a,($cfd6)		; $5ef8
	ld (de),a		; $5efb
	ret			; $5efc
@func_5efd:
	ld a,($cfcb)		; $5efd
	ld hl,$cfc8		; $5f00
	rst_addAToHl			; $5f03
	ld a,(hl)		; $5f04
	ldh (<hFF8B),a	; $5f05
	ld hl,@table_5f17		; $5f07
	rst_addDoubleIndex			; $5f0a
	ldi a,(hl)		; $5f0b
	ld e,(hl)		; $5f0c
	jp playSound		; $5f0d
@func_5f10:
	rst_jumpTable			; $5f10
	.dw @subid1@func_5c6f
	.dw @subid1@func_5c78
	.dw @subid1@func_5c81
@table_5f17:
	; sound - stored in e (unused?)
	.db SND_DANCE_MOVE,    $05
	.db SND_SEEDSHOOTER,   $06
	.db SND_GORON_DANCE_B, $04
@func_5f1d:
	ld c,$28		; $5f1d
	call objectUpdateSpeedZ_paramC		; $5f1f
	call interactionAnimate		; $5f22
	ld h,d			; $5f25
	ld l,$61		; $5f26
	ld a,(hl)		; $5f28
	or a			; $5f29
	jr z,+			; $5f2a
	inc a			; $5f2c
	jr z,+			; $5f2d
	dec a			; $5f2f
	ld (hl),$00		; $5f30
	ld l,$4d		; $5f32
	add (hl)		; $5f34
	ld (hl),a		; $5f35
+
	ld l,$46		; $5f36
	ld a,(hl)		; $5f38
	or a			; $5f39
	ret z			; $5f3a
	dec (hl)		; $5f3b
	ret			; $5f3c
@subid2:
	ld e,Interaction.state		; $5f3d
	ld a,(de)		; $5f3f
	rst_jumpTable			; $5f40
	.dw @@state0
	.dw @@state1
	.dw @@state2
	.dw @@state3
	.dw @@state4
	.dw @@state5
	.dw interactionAnimate
@@state0:
	call @subid1@func_5c21		; $5f4f
	ld e,$4d		; $5f52
	ld a,(de)		; $5f54
	ld hl,@@table_5f72		; $5f55
	rst_addAToHl			; $5f58
	ld e,$72		; $5f59
	ld a,(hl)		; $5f5b
	ld (de),a		; $5f5c
	ld a,>TX_0100		; $5f5d
	inc e			; $5f5f
	ld (de),a		; $5f60
	ld h,d			; $5f61
	ld l,$7b		; $5f62
	ld (hl),$01		; $5f64
	ld l,$4b		; $5f66
	ld a,(hl)		; $5f68
	call setShortPosition		; $5f69
	ld hl,danceLeaderScript_showLoadedText		; $5f6c
	jp interactionSetScript		; $5f6f
@@table_5f72:
	.db <TX_010b <TX_010c <TX_010d
	.db <TX_010e <TX_010f <TX_0110
	.db <TX_0111 <TX_0112 <TX_0113
@@state1:
	ld a,($cfda)		; $5f7b
	or a			; $5f7e
	jr nz,+			; $5f7f
	call interactionRunScript		; $5f81
	jp npcFaceLinkAndAnimate		; $5f84
+
	ld e,Interaction.state		; $5f87
	ld a,$02		; $5f89
	ld (de),a		; $5f8b
	ld a,$02		; $5f8c
	jp interactionSetAnimation		; $5f8e
@@state2:
	call @func_60a4		; $5f91
	jr c,@@func_5fb8	; $5f94
	call interactionAnimate		; $5f96
	ld a,($cfd0)		; $5f99
	or a			; $5f9c
	jr nz,@@func_5fb8	; $5f9d
	ld h,d			; $5f9f
	ld l,$7b		; $5fa0
	ld a,($cfda)		; $5fa2
	cp (hl)			; $5fa5
	ret z			; $5fa6
	ld (hl),a		; $5fa7
	ld a,($cfd4)		; $5fa8
	ld l,$44		; $5fab
	ld (hl),a		; $5fad
	cp $04			; $5fae
	call z,@@func_5fc3		; $5fb0
	xor a			; $5fb3
	ld e,$78		; $5fb4
	ld (de),a		; $5fb6
	ret			; $5fb7
@@func_5fb8:
	ld a,$02		; $5fb8
	call interactionSetAnimation		; $5fba
	ld e,Interaction.state		; $5fbd
	ld a,$06		; $5fbf
	ld (de),a		; $5fc1
	ret			; $5fc2
@@func_5fc3:
	call objectGetShortPosition		; $5fc3
	ld c,a			; $5fc6
	ld hl,@@table_5ff1		; $5fc7
-
	ldi a,(hl)		; $5fca
	cp c			; $5fcb
	jr z,+			; $5fcc
	inc hl			; $5fce
	jr -			; $5fcf
+
	ld a,($cfd2)		; $5fd1
	bit 7,a			; $5fd4
	jr nz,+			; $5fd6
	ld a,(hl)		; $5fd8
	jr ++			; $5fd9
+
	ld a,(hl)		; $5fdb
	swap a			; $5fdc
++
	and $0f			; $5fde
	ld e,$48		; $5fe0
	ld (de),a		; $5fe2
	ldh (<hFF8B),a	; $5fe3
	call interactionSetAnimation		; $5fe5
	ldh a,(<hFF8B)	; $5fe8
	swap a			; $5fea
	rrca			; $5fec
	ld e,$49		; $5fed
	ld (de),a		; $5fef
	ret			; $5ff0
@@table_5ff1:
	.db $11 $21
	.db $21 $20
	.db $31 $20
	.db $41 $20
	.db $51 $20
	.db $61 $10
	.db $62 $13
	.db $63 $13
	.db $64 $13
	.db $65 $13
	.db $66 $03
	.db $56 $02
	.db $46 $02
	.db $36 $02
	.db $26 $02
	.db $16 $32
	.db $15 $31
	.db $14 $31
	.db $13 $31
	.db $12 $31
@@state3:
	ld a,$02		; $6019
	ld (de),a		; $601b
	ld a,$02		; $601c
	call interactionSetAnimation		; $601e
	jr @func_6037		; $6021
@@state4:
	call @func_603f		; $6023
	ret c			; $6026
	ld l,$44		; $6027
	ld (hl),$02		; $6029
	jr @func_6037		; $602b
@@state5:
	ld a,$02		; $602d
	ld (de),a		; $602f
	ld a,$04		; $6030
	call interactionSetAnimation		; $6032
	jr @func_6037		; $6035
@func_6037:
	ld hl,$cfd1		; $6037
	ld a,(hl)		; $603a
	or a			; $603b
	ret z			; $603c
	dec (hl)		; $603d
	ret			; $603e
@func_603f:
	ld h,d			; $603f
	ld e,$4b		; $6040
	ld l,$79		; $6042
	ld a,(de)		; $6044
	ldi (hl),a		; $6045
	ld e,$4d		; $6046
	ld a,(de)		; $6048
	ld (hl),a		; $6049
	ld a,($cfd3)		; $604a
	ld e,$50		; $604d
	ld (de),a		; $604f
	call objectApplySpeed		; $6050
	call @func_6058		; $6053
	jr @func_607e		; $6056
@func_6058:
	ld h,d			; $6058
	ld l,$4b		; $6059
	call @func_6061		; $605b
	ld h,d			; $605e
	ld l,$4d		; $605f
@func_6061:
	ld a,$17		; $6061
	cp (hl)			; $6063
	inc a			; $6064
	jr nc,+			; $6065
	ld a,$68		; $6067
	cp (hl)			; $6069
	ret nc			; $606a
+
	ld (hl),a		; $606b
	ld a,($cfd2)		; $606c
	ld l,$48		; $606f
	add (hl)		; $6071
	and $03			; $6072
	ldi (hl),a		; $6074
	ld b,a			; $6075
	swap a			; $6076
	rrca			; $6078
	ld (hl),a		; $6079
	ld a,b			; $607a
	jp interactionSetAnimation		; $607b
@func_607e:
	ld e,$4b		; $607e
	ld a,(de)		; $6080
	ld b,a			; $6081
	ld e,$79		; $6082
	ld a,(de)		; $6084
	sub b			; $6085
	jr nc,+			; $6086
	cpl			; $6088
	inc a			; $6089
+
	ld c,a			; $608a
	ld e,$4d		; $608b
	ld a,(de)		; $608d
	ld b,a			; $608e
	ld e,$7a		; $608f
	ld a,(de)		; $6091
	sub b			; $6092
	jr nc,+			; $6093
	cpl			; $6095
	inc a			; $6096
+
	add c			; $6097
	ld b,a			; $6098
	ld e,$78		; $6099
	ld a,(de)		; $609b
	add b			; $609c
	ld (de),a		; $609d
	cp $10			; $609e
	ret c			; $60a0
	jp objectCenterOnTile		; $60a1
@func_60a4:
	call objectCheckCollidedWithLink		; $60a4
	ret nc			; $60a7
	ld a,$01		; $60a8
	ld ($cfdd),a		; $60aa
	ret			; $60ad
@subid3:
	ld e,Interaction.state		; $60ae
	ld a,(de)		; $60b0
	or a			; $60b1
	jr nz,+			; $60b2
	ld a,$01		; $60b4
	ld (de),a		; $60b6
	ld e,$40		; $60b7
	ld a,$81		; $60b9
	ld (de),a		; $60bb
	call interactionInitGraphics		; $60bc
+
	ld a,($cfdf)		; $60bf
	ld b,a			; $60c2
	or a			; $60c3
	jp z,objectSetInvisible		; $60c4
	call objectSetVisible80		; $60c7
	ld a,b			; $60ca
	cp $ff			; $60cb
	jp z,interactionDelete		; $60cd
	add a			; $60d0
	add b			; $60d1
	ld hl,@table_60e2		; $60d2
	rst_addAToHl			; $60d5
	ldi a,(hl)		; $60d6
	ld e,$4b		; $60d7
	ld (de),a		; $60d9
	ld e,$4d		; $60da
	ldi a,(hl)		; $60dc
	ld (de),a		; $60dd
	ld a,(hl)		; $60de
	jp interactionSetAnimation		; $60df
@table_60e2:
	.db $30 $58 $07
	.db $30 $58 $07
	.db $30 $38 $08
	.db $30 $58 $09


; ==============================================================================
; INTERACID_S_MISCELLANEOUS_1
; ==============================================================================
interactionCode6b:
	ld e,Interaction.subid		; $60ee
	ld a,(de)		; $60f0
	rst_jumpTable			; $60f1
	/* $00 */ .dw _floodgateKeeper
	/* $01 */ .dw _floodgateKeeperSwitchScript
	/* $02 */ .dw _floodgateKeyhole
	/* $03 */ .dw _d4KeyHole
	/* $04 */ .dw _floodgateKey
	/* $05 */ .dw _dragonKey
	/* $06 */ .dw _tarmArmosUnlockingStairs
	/* $07 */ .dw _tarmArmosWallByStump
	/* $08 */ .dw _tarmEscapedLostWoods
	/* $09 */ .dw _oreChunkDigSpot
	/* $0a */ .dw _staticHeartPiece
	/* $0b */ .dw _permanentlyRemovableObjects
	/* $0c */ .dw _piratesBellRoomWhenFallingIn
	/* $0d */ .dw _greenJoyRing
	/* $0e */ .dw _masterDiverPuzzle
	/* $0f */ .dw _piratesBell
	/* $10 */ .dw _armosBlockingFlowerPathToD6
	/* $11 */ .dw _natzuSwitch
	/* $12 */ .dw _onoxCastleCutscene
	/* $13 */ .dw _savingZeldaNoEnemiesHandler
	/* $14 */ .dw _unblockingD3Dam
	/* $15 */ .dw _replacePirateShipWithQuicksand
	/* $16 */ .dw _stolenFeatherGottenHandler
	/* $17 */ .dw _horonVillagePortalBridgeSpawner
	/* $18 */ .dw _randomRingDigSpot
	/* $19 */ .dw _staticGashaSeed
	/* $1a */ .dw _underwaterGashaSeed
	/* $1b */ .dw _tickTockSecretEntrance
	/* $1c */ .dw _graveSecretEntrance
	/* $1d */ .dw _d4MinibossRoom
	/* $1e */ .dw _sentBackFromOnoxCastleBarrier
	/* $1f */ .dw _sidescrollingStaticGashaSeed
	/* $20 */ .dw _sidescrollingStaticSeedSatchel
	/* $21 */ .dw _mtCuccoBananaTree
	/* $22 */ .dw _hardOre
	.dw interactionCode6bSubid23
	.dw interactionCode6bSubid24
	.dw interactionCode6bSubid25
	.dw interactionCode6bSubid26

_floodgateKeeper:
	call checkInteractionState		; $6140
	jr nz,@state1	; $6143
	ld a,$01		; $6145
	ld (de),a		; $6147
	call interactionInitGraphics		; $6148
	ld hl,floodgateKeeperScript		; $614b
	call interactionSetScript		; $614e
	call objectSetVisible82		; $6151
	xor a			; $6154
	ld ($cfc1),a		; $6155
@state1:
	call interactionAnimate		; $6158
	call objectPreventLinkFromPassing		; $615b
	jp interactionRunScript		; $615e

_floodgateKeeperSwitchScript:
	call checkInteractionState		; $6161
	jr nz,@state1	; $6164
	ld a,$01		; $6166
	ld (de),a		; $6168
	call getThisRoomFlags		; $6169
	bit 6,(hl)		; $616c
	jr z,+			; $616e
	ld bc,wRoomLayout|$68		; $6170
	ld a,TILEINDEX_DUNGEON_SWITCH_ON		; $6173
	ld (bc),a		; $6175
	jp interactionDelete		; $6176
+
	call interactionInitGraphics		; $6179
	call objectSetVisible83		; $617c
	call objectSetInvisible		; $617f
	xor a			; $6182
	ld (wSwitchState),a		; $6183
	ld hl,floodgateSwitchScript		; $6186
	jp interactionSetScript		; $6189
@state1:
	call interactionAnimate		; $618c
_runScriptDeleteWhenDone:
	call interactionRunScript		; $618f
	ret nc			; $6192
	jp interactionDelete		; $6193

_floodgateKeyhole:
	ld e,Interaction.state		; $6196
	ld a,(de)		; $6198
	rst_jumpTable			; $6199
	.dw @state0
	.dw interactionRunScript
	.dw @state2
@state0:
	ld a,$01		; $61a0
	ld (de),a		; $61a2
	call getThisRoomFlags		; $61a3
	bit 7,(hl)		; $61a6
	jp nz,interactionDelete		; $61a8
	ld hl,floodgateKeyholeScript_keyEntered		; $61ab
	jp interactionSetScript		; $61ae
@state2:
	ld a,$04		; $61b1
	call setScreenShakeCounter		; $61b3
	ld a,($cfc0)		; $61b6
	bit 7,a			; $61b9
	ret z			; $61bb
	ld a,($cc62)		; $61bc
	ld (wActiveMusic),a		; $61bf
	call playSound		; $61c2
	jr ++		; $61c5

_resetMusicThenSolvePuzzleSound:
	ld a,$ff		; $61c7
	ld (wActiveMusic),a		; $61c9
++
	xor a			; $61cc
	ld ($cc02),a		; $61cd
	ld ($cca4),a		; $61d0
	ld a,$f1		; $61d3
	call playSound		; $61d5
	ld a,SND_SOLVEPUZZLE		; $61d8
	call playSound		; $61da
	jp interactionDelete		; $61dd


_d4KeyHole:
	ld e,Interaction.state		; $61e0
	ld a,(de)		; $61e2
	rst_jumpTable			; $61e3
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3
	.dw @state4
@state0:
	ld a,$01		; $61ee
	ld (de),a		; $61f0
	call getThisRoomFlags		; $61f1
	bit 7,(hl)		; $61f4
	jp nz,interactionDelete		; $61f6
	call objectSetReservedBit1		; $61f9
	ld a,$01		; $61fc
	ld (wScreenShakeMagnitude),a		; $61fe
	ld hl,d4Keyhole_disableThingsAndScreenShake		; $6201
	jp interactionSetScript		; $6204
@state1:
	ld a,(wActiveRoom)		; $6207
	cp <ROOM_SEASONS_00d			; $620a
	jp nz,interactionDelete		; $620c
	call interactionRunScript		; $620f
	ret nc			; $6212
	call interactionIncState		; $6213
	ld hl,simpleScript_waterfallEmptyingAboveD4		; $6216
	jp interactionSetSimpleScript		; $6219
@func_621c:
	ld h,d			; $621c
	ld l,$46		; $621d
	ld a,(hl)		; $621f
	or a			; $6220
	ret z			; $6221
	dec (hl)		; $6222
	ret			; $6223
@state2:
	call @func_621c		; $6224
	ret nz			; $6227
	call interactionRunSimpleScript		; $6228
	ret nc			; $622b
	call interactionIncState		; $622c
	ld a,$1d		; $622f
	ld b,$02		; $6231
	call func_1383		; $6233
	callab scriptHlp.d4KeyHolw_disableAllSorts
	ret			; $623e
@state3:
	ld a,($cd00)		; $623f
	and $01			; $6242
	ret z			; $6244
	call getThisRoomFlags		; $6245
	set 7,(hl)		; $6248
	call interactionIncState		; $624a
	ld hl,simpleScript_waterfallEmptyingAtD4		; $624d
	jp interactionSetSimpleScript		; $6250
@state4:
	ld a,$3c		; $6253
	call setScreenShakeCounter		; $6255
	call @func_621c		; $6258
	ret nz			; $625b
	call interactionRunSimpleScript		; $625c
	ret nc			; $625f
	ld hl,@warpDestVariables		; $6260
	call setWarpDestVariables		; $6263
	jp _resetMusicThenSolvePuzzleSound		; $6266
@warpDestVariables:
	.db $c0 $0d $01 $23 $03

_floodgateKey:
	ld e,Interaction.state		; $626e
	ld a,(de)		; $6270
	rst_jumpTable			; $6271
	.dw @state0
	.dw @state1
	.dw interactionRunScript
@state0:
	call getThisRoomFlags		; $6278
	and $60			; $627b
	cp $40			; $627d
	ret nz			; $627f
	ldbc TREASURE_FLOODGATE_KEY $00		; $6280
	call _misc1_spawnTreasureBC		; $6283
	jp interactionIncState		; $6286
@state1:
	ld a,TREASURE_FLOODGATE_KEY		; $6289
	call checkTreasureObtained		; $628b
	ret nc			; $628e
	call interactionIncState		; $628f
	ld hl,$cca4		; $6292
	set 7,(hl)		; $6295
	ld a,$01		; $6297
	ld ($cc02),a		; $6299
	ld hl,floodgateKeyScript_keeperNoticesKey		; $629c
	jp interactionSetScript		; $629f

_dragonKey:
	ldbc TREASURE_DRAGON_KEY $00		; $62a2
	jp _misc1_spawnTreasureBCifRoomFlagBit5NotSet		; $62a5
	
_tarmArmosUnlockingStairs:
	ld e,Interaction.state		; $62a8
	ld a,(de)		; $62aa
	rst_jumpTable			; $62ab
	.dw @state0
	.dw @state1
	.dw _runScriptDeleteWhenDone
@state0:
	call getThisRoomFlags		; $62b2
	and $40			; $62b5
	jp nz,interactionDelete		; $62b7
	call interactionIncState		; $62ba
	ld hl,tarmArmosUnlockingStairsScript		; $62bd
	jp interactionSetScript		; $62c0
@state1:
	call objectGetTileAtPosition		; $62c3
	cp $04			; $62c6
	ret nz			; $62c8
	call interactionIncState		; $62c9
	jp _runScriptDeleteWhenDone		; $62cc

_tarmArmosWallByStump:
	ld a,($cc4c)		; $62cf
	cp $42			; $62d2
	jp nz,interactionDelete		; $62d4
	ld e,Interaction.state		; $62d7
	ld a,(de)		; $62d9
	rst_jumpTable			; $62da
	.dw @state0
	.dw @state1
	.dw @state2
@state0:
	ld a,$01		; $62e1
	ld (de),a		; $62e3
	ld a,(wRoomStateModifier)		; $62e4
	cp SEASON_WINTER			; $62e7
	jp nz,interactionDelete		; $62e9
	call getThisRoomFlags		; $62ec
	ld e,$4b		; $62ef
	ld a,(de)		; $62f1
	and (hl)		; $62f2
	jp nz,interactionDelete		; $62f3
	jp objectSetReservedBit1		; $62f6
@state1:
	ld a,(wRoomStateModifier)		; $62f9
	cp SEASON_WINTER			; $62fc
	jp nz,interactionDelete		; $62fe
	ld e,$4d		; $6301
	ld a,(de)		; $6303
	ld l,a			; $6304
	ld h,$cf		; $6305
	ld a,$9c		; $6307
	cp (hl)			; $6309
	ret nz			; $630a
	jp interactionIncState		; $630b
@state2:
	ld a,(wRoomStateModifier)		; $630e
	cp SEASON_WINTER			; $6311
	ret z			; $6313
	ld a,($c4ab)		; $6314
	or a			; $6317
	ret z			; $6318
	call getThisRoomFlags		; $6319
	ld e,$4b		; $631c
	ld a,(de)		; $631e
	or (hl)			; $631f
	ld (hl),a		; $6320
	ld e,$4d		; $6321
	ld a,(de)		; $6323
	dec a			; $6324
	ld c,a			; $6325
	ld a,$09		; $6326
	call setTile		; $6328
	inc c			; $632b
	ld a,$bc		; $632c
	call setTile		; $632e
	jr ++			; $6331

_tarmEscapedLostWoods:
	call returnIfScrollMode01Unset		; $6333
	ld a,($cd02)		; $6336
	or a			; $6339
	jp nz,interactionDelete		; $633a
++
	ld a,$4d		; $633d
	call playSound		; $633f
	jp interactionDelete		; $6342

_oreChunkDigSpot:
	call checkInteractionState		; $6345
	jr nz,@state1	; $6348
	ld a,$01		; $634a
	ld (de),a		; $634c
	ld e,$43		; $634d
	ld a,(de)		; $634f
	or a			; $6350
	jr nz,+			; $6351
	call getThisRoomFlags		; $6353
	and $20			; $6356
	jp nz,interactionDelete		; $6358
+
	call objectGetShortPosition		; $635b
	ld ($ccc5),a		; $635e
@state1:
	ld a,($ccc5)		; $6361
	inc a			; $6364
	ret nz			; $6365
	call getFreePartSlot		; $6366
	ret nz			; $6369
	ld (hl),PARTID_ITEM_DROP		; $636a
	inc l			; $636c
	ld (hl),$0e		; $636d
	inc l			; $636f
	ld (hl),$01		; $6370
	ld a,($d008)		; $6372
	swap a			; $6375
	rrca			; $6377
	ld l,$c9		; $6378
	ld (hl),a		; $637a
	call objectCopyPosition		; $637b
	jp interactionDelete		; $637e
	
_staticHeartPiece:
	ldbc TREASURE_HEART_PIECE $00		; $6381
_misc1_spawnTreasureBCifRoomFlagBit5NotSet:
	call getThisRoomFlags		; $6384
	and $20			; $6387
	jr nz,+			; $6389
	call _misc1_spawnTreasureBC		; $638b
+
	jp interactionDelete		; $638e

_misc1_spawnTreasureBC:
	call getFreeInteractionSlot		; $6391
	ret nz			; $6394
	ld (hl),INTERACID_TREASURE		; $6395
	inc l			; $6397
	ld (hl),b		; $6398
	inc l			; $6399
	ld (hl),c		; $639a
	jp objectCopyPosition		; $639b

; eg rocks, ember trees that should stay removed
_permanentlyRemovableObjects:
	call checkInteractionState		; $639e
	jr nz,@state1	; $63a1
	call returnIfScrollMode01Unset		; $63a3
	call getThisRoomFlags		; $63a6
	ld e,Interaction.xh		; $63a9
	ld a,(de)		; $63ab
	and (hl)		; $63ac
	jp nz,interactionDelete		; $63ad
	ld b,>wRoomLayout		; $63b0
	ld e,Interaction.yh		; $63b2
	ld a,(de)		; $63b4
	ld c,a			; $63b5
	ld a,(bc)		; $63b6
	ld e,Interaction.var03		; $63b7
	ld (de),a		; $63b9
	ld e,Interaction.state		; $63ba
	ld a,$01		; $63bc
	ld (de),a		; $63be
@state1:
	ld a,(wScrollMode)		; $63bf
	and $01			; $63c2
	jp z,interactionDelete		; $63c4
	ld e,Interaction.var03		; $63c7
	ld a,(de)		; $63c9
	ld b,a			; $63ca
	ld e,Interaction.yh		; $63cb
	ld a,(de)		; $63cd
	ld l,a			; $63ce
	ld h,>wRoomLayout		; $63cf
	ld a,b			; $63d1
	cp (hl)			; $63d2
	ret z			; $63d3
	call getThisRoomFlags		; $63d4
	ld e,Interaction.xh		; $63d7
	ld a,(de)		; $63d9
	or (hl)			; $63da
	ld (hl),a		; $63db
	jp interactionDelete		; $63dc

_piratesBellRoomWhenFallingIn:
	ld e,Interaction.state		; $63df
	ld a,(de)		; $63e1
	rst_jumpTable			; $63e2
	.dw @state0
	.dw @state1
	.dw _runScriptDeleteWhenDone
@state0:
	call getThisRoomFlags		; $63e9
	and $20			; $63ec
	jp nz,interactionDelete		; $63ee
	call interactionIncState		; $63f1
@state1:
	call getThisRoomFlags		; $63f4
	and $20			; $63f7
	ret z			; $63f9
	ld hl,$cca4		; $63fa
	set 0,(hl)		; $63fd
	ld a,$01		; $63ff
	ld ($cc02),a		; $6401
	call interactionIncState		; $6404
	ld hl,piratesBellRoomDroppingInScript		; $6407
	jp interactionSetScript		; $640a

_greenJoyRing:
	call getThisRoomFlags		; $640d
	and $20			; $6410
	jp nz,interactionDelete		; $6412
	ld a,(wActiveTriggers)		; $6415
	or a			; $6418
	ret z			; $6419
	ldbc GREEN_JOY_RING $01		; $641a
_createRingTreasureAtPosition:
	call createRingTreasure		; $641d
	ret nz			; $6420
	call objectCopyPosition		; $6421
	jp interactionDelete		; $6424

_masterDiverPuzzle:
	ld e,Interaction.state		; $6427
	ld a,(de)		; $6429
	rst_jumpTable			; $642a
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3
@state0:
	call getThisRoomFlags		; $6433
	bit 5,(hl)		; $6436
	jp nz,interactionDelete		; $6438
	ld h,d			; $643b
	ld l,$44		; $643c
	ld (hl),$01		; $643e
	ld l,$70		; $6440
	ld b,$06		; $6442
	jp clearMemory		; $6444
@state1:
	call @checkLinkSwordSpin		; $6447
	ret nz			; $644a
	ld a,$02		; $644b
	ld (de),a		; $644d
@state2:
	call @checkLinkSwordSpin		; $644e
	jr nz,@state0		; $6451
	ld a,(wccaf)		; $6453
	cp $2b			; $6456
	jr z,+			; $6458
	cp TILEINDEX_PUSHABLE_STATUE			; $645a
	ret nz			; $645c
+
	ld h,d			; $645d
	ld l,$70		; $645e
	ld a,(wccb0)		; $6460
	ld c,a			; $6463
-
	ldi a,(hl)		; $6464
	cp c			; $6465
	ret z			; $6466
	or a			; $6467
	jr nz,-			; $6468
	dec l			; $646a
	ld (hl),c		; $646b
	ld a,l			; $646c
	cp $73			; $646d
	jr nc,+			; $646f
	ret			; $6471
+
	ld l,$44		; $6472
	ld (hl),$03		; $6474
	ld hl,masterDiverPuzzleScript_solved		; $6476
	call interactionSetScript		; $6479
@state3:
	call interactionRunScript		; $647c
	jp c,interactionDelete		; $647f
	ret			; $6482
@checkLinkSwordSpin:
	ld a,(wcc63)		; $6483
	and $0f			; $6486
	cp $02			; $6488
	ret			; $648a

_piratesBell:
	ldbc TREASURE_PIRATES_BELL $00		; $648b
	jp _misc1_spawnTreasureBCifRoomFlagBit5NotSet		; $648e

_armosBlockingFlowerPathToD6:
	call returnIfScrollMode01Unset		; $6491
	call getThisRoomFlags		; $6494
	bit 7,(hl)		; $6497
	jp nz,interactionDelete		; $6499
	bit 6,(hl)		; $649c
	jp nz,interactionDelete		; $649e
	call objectGetTileAtPosition		; $64a1
	cp $d6			; $64a4
	ret z			; $64a6
	ld a,(wBlockPushAngle)		; $64a7
	and $7f			; $64aa
	cp ANGLE_LEFT			; $64ac
	ld b,$80		; $64ae
	jr z,+			; $64b0
	ld b,$40		; $64b2
+
	call getThisRoomFlags		; $64b4
	or b			; $64b7
	ld (hl),a		; $64b8
	jp interactionDelete		; $64b9

_natzuSwitch:
	ld e,Interaction.state		; $64bc
	ld a,(de)		; $64be
	rst_jumpTable			; $64bf
	.dw @state0
	.dw @state1
	.dw @state2
@state0:
	ld a,$01		; $64c6
	ld (de),a		; $64c8
	ld a,(wAnimalCompanion)		; $64c9
	cp SPECIALOBJECTID_DIMITRI			; $64cc
	jp z,interactionDelete		; $64ce
	call getThisRoomFlags		; $64d1
	and $40			; $64d4
	jp nz,interactionDelete		; $64d6
	call getFreePartSlot		; $64d9
	ret nz			; $64dc
	ld (hl),PARTID_SWITCH		; $64dd
	inc l			; $64df
	ld (hl),$01		; $64e0
	jp objectCopyPosition		; $64e2
@state1:
	ld a,(wSwitchState)		; $64e5
	or a			; $64e8
	ret z			; $64e9
	ld a,$81		; $64ea
	ld ($cc02),a		; $64ec
	ld ($cca4),a		; $64ef
	ld ($ccab),a		; $64f2
	call getThisRoomFlags		; $64f5
	set 6,(hl)		; $64f8
	call interactionIncState		; $64fa
	ld hl,simpleScript_creatingBridgeToNatzu		; $64fd
	jp interactionSetSimpleScript		; $6500
@state2:
	call _d4KeyHole@func_621c		; $6503
	ret nz			; $6506
	call interactionRunSimpleScript		; $6507
	ret nc			; $650a
	xor a			; $650b
	ld ($cc02),a		; $650c
	ld ($cca4),a		; $650f
	ld ($ccab),a		; $6512
	jp interactionDelete		; $6515

_onoxCastleCutscene:
	ld a,GLOBALFLAG_WITCHES_2_SEEN		; $6518
	call checkGlobalFlag		; $651a
	jp nz,interactionDelete		; $651d
	ld a,GLOBALFLAG_ZELDA_KIDNAPPED_SEEN		; $6520
	call checkGlobalFlag		; $6522
	jp nz,interactionDelete		; $6525
	ld a,$01		; $6528
	ld ($cca4),a		; $652a
	ld ($cc02),a		; $652d
	call returnIfScrollMode01Unset		; $6530
	ld a,CUTSCENE_S_ONOX_CASTLE_FORCE		; $6533
	ld (wCutsceneTrigger),a		; $6535
	xor a			; $6538
	ld ($d008),a		; $6539
	call dropLinkHeldItem		; $653c
	call clearAllParentItems		; $653f
	jp interactionDelete		; $6542

_savingZeldaNoEnemiesHandler:
	ld a,GLOBALFLAG_IMPA_ASKED_TO_SAVE_ZELDA		; $6545
	call checkGlobalFlag		; $6547
	ret z			; $654a
	ld a,GLOBALFLAG_ZELDA_SAVED_FROM_VIRE		; $654b
	call checkGlobalFlag		; $654d
	ret nz			; $6550
	ld a,$80		; $6551
	ld (wcc85),a		; $6553
	jp interactionDelete		; $6556

_unblockingD3Dam:
	ld h,d			; $6559
	ld l,$46		; $655a
	ld a,(hl)		; $655c
	or a			; $655d
	jr z,+			; $655e
	dec (hl)		; $6560
	ret nz			; $6561
+
	call checkInteractionState		; $6562
	jr nz,@state1		; $6565
	call interactionIncState		; $6567
	ld hl,simpleScript_unblockingD3Dam		; $656a
	jp interactionSetSimpleScript		; $656d
@state1:
	call interactionRunSimpleScript		; $6570
	ret nc			; $6573
	ld hl,$cfc0		; $6574
	set 7,(hl)		; $6577
	jp interactionDelete		; $6579
	
_replacePirateShipWithQuicksand:
	ld a,GLOBALFLAG_PIRATE_SHIP_DOCKED		; $657c
	call checkGlobalFlag		; $657e
	jp z,interactionDelete		; $6581
	ld b,INTERACID_QUICKSAND		; $6584
	call objectCreateInteractionWithSubid00		; $6586
	jp interactionDelete		; $6589
	
_stolenFeatherGottenHandler:
	call checkInteractionState		; $658c
	jr nz,@state1	; $658f
	call objectGetTileAtPosition		; $6591
	ld h,d			; $6594
	ld l,$49		; $6595
	ld (hl),a		; $6597
	ld l,$44		; $6598
	inc (hl)		; $659a
@state1:
	ld a,$01		; $659b
	ld ($ccab),a		; $659d
	call objectGetTileAtPosition		; $65a0
	ld e,$49		; $65a3
	ld a,(de)		; $65a5
	cp (hl)			; $65a6
	ret z			; $65a7
	xor a			; $65a8
	ld ($ccab),a		; $65a9
	jp interactionDelete		; $65ac
	
_horonVillagePortalBridgeSpawner:
	call checkInteractionState		; $65af
	jr nz,@state1	; $65b2
	xor a			; $65b4
	ld (wSwitchState),a		; $65b5
	call getThisRoomFlags		; $65b8
	and $40			; $65bb
	jp nz,interactionDelete		; $65bd
	call interactionIncState		; $65c0
@state1:
	ld a,(wSwitchState)		; $65c3
	or a			; $65c6
	ret z			; $65c7
	call getThisRoomFlags		; $65c8
	set 6,(hl)		; $65cb
	ld a,$4d		; $65cd
	call playSound		; $65cf
	ld bc,$0047		; $65d2
	ld e,$08		; $65d5
	call @spawnBridge		; $65d7
	ld bc,$0114		; $65da
	ld e,$06		; $65dd
	call @spawnBridge		; $65df
	jp interactionDelete		; $65e2
@spawnBridge:
	call getFreePartSlot		; $65e5
	ret nz			; $65e8
	ld (hl),PARTID_BRIDGE_SPAWNER		; $65e9
	ld l,$c7		; $65eb
	ld (hl),e		; $65ed
	ld l,$c9		; $65ee
	ld (hl),b		; $65f0
	ld l,$cb		; $65f1
	ld (hl),c		; $65f3
	ret			; $65f4

; Under Vasu's sign, and by wilds ore
_randomRingDigSpot:
	call getThisRoomFlags		; $65f5
	and $20			; $65f8
	jp nz,interactionDelete		; $65fa
	ld c,$02		; $65fd
	call getRandomRingOfGivenTier		; $65ff
	ld b,c			; $6602
	ld c,$03		; $6603
	jp _createRingTreasureAtPosition		; $6605

_staticGashaSeed:
	ldbc TREASURE_GASHA_SEED $04		; $6608
	jp _misc1_spawnTreasureBCifRoomFlagBit5NotSet		; $660b

_underwaterGashaSeed:
	ldbc TREASURE_GASHA_SEED $05		; $660e
	jp _misc1_spawnTreasureBCifRoomFlagBit5NotSet		; $6611

_tickTockSecretEntrance:
	call checkInteractionState		; $6614
	jr nz,@state1	; $6617
	call objectGetTileAtPosition		; $6619
	cp $04			; $661c
	ret nz			; $661e
	ld a,l			; $661f
	ld ($ccc5),a		; $6620
	ld e,Interaction.state		; $6623
	ld a,$01		; $6625
	ld (de),a		; $6627
	ret			; $6628
@state1:
	call returnIfScrollMode01Unset		; $6629
	call objectGetTileAtPosition		; $662c
	cp $04			; $662f
	ret z			; $6631
_setEnteredWarpSetStairsPlaySolvedSound:
	ld c,l			; $6632
	ld a,c			; $6633
	ld (wEnteredWarpPosition),a		; $6634
	ld a,$e7		; $6637
	call setTile		; $6639
	ld a,$4d		; $663c
	call playSound		; $663e
	jp interactionDelete		; $6641

_graveSecretEntrance:
	call returnIfScrollMode01Unset		; $6644
	call objectGetTileAtPosition		; $6647
	cp $01			; $664a
	ret z			; $664c
	ld a,l			; $664d
	ld ($ccc5),a		; $664e
	jr _setEnteredWarpSetStairsPlaySolvedSound		; $6651

_d4MinibossRoom:
	call checkInteractionState		; $6653
	jr nz,+			; $6656
	ld a,$01		; $6658
	ld (de),a		; $665a
	call getThisRoomFlags		; $665b
	bit 7,(hl)		; $665e
	jp nz,interactionDelete		; $6660
	ld hl,objectData.objectData7e96		; $6663
	jp parseGivenObjectData		; $6666
+
	ld a,(wNumTorchesLit)		; $6669
	cp $02			; $666c
	ret nz			; $666e
	call getThisRoomFlags		; $666f
	set 7,(hl)		; $6672
	jp interactionDelete		; $6674
	
_sentBackFromOnoxCastleBarrier:
	call checkInteractionState		; $6677
	jr nz,@state1	; $667a
	ld a,GLOBALFLAG_ONOX_CASTLE_BARRIER_GONE		; $667c
	call checkGlobalFlag		; $667e
	jp z,interactionDelete		; $6681
	ld a,GLOBALFLAG_ONOX_CASTLE_BARRIER_GONE		; $6684
	call unsetGlobalFlag		; $6686
	ld h,d			; $6689
	ld l,$44		; $668a
	inc (hl)		; $668c
	ld l,$46		; $668d
	ld (hl),$3c		; $668f
@state1:
	ld a,$01		; $6691
	ld ($cca4),a		; $6693
	call interactionDecCounter1		; $6696
	ret nz			; $6699
	xor a			; $669a
	ld ($cc02),a		; $669b
	ld ($cca4),a		; $669e
	ld bc,TX_501b		; $66a1
	call showText		; $66a4
	jp interactionDelete		; $66a7
	
_sidescrollingStaticGashaSeed:
	ldbc TREASURE_GASHA_SEED $04		; $66aa
	jp _misc1_spawnTreasureBCifRoomFlagBit5NotSet		; $66ad

_sidescrollingStaticSeedSatchel:
	ldbc TREASURE_SEED_SATCHEL $00		; $66b0
	jp _misc1_spawnTreasureBCifRoomFlagBit5NotSet		; $66b3

_mtCuccoBananaTree:
	ld a,($cc4e)		; $66b6
	or a			; $66b9
	jp nz,interactionDelete		; $66ba
	call getThisRoomFlags		; $66bd
	and $20			; $66c0
	jp nz,interactionDelete		; $66c2
	ldbc TREASURE_SPRING_BANANA $00		; $66c5
	call _misc1_spawnTreasureBC		; $66c8
	ld b,h			; $66cb
	ld a,$06		; $66cc
	ldi (hl),a		; $66ce
	ld (hl),a		; $66cf
	call getFreePartSlot		; $66d0
	jp nz,interactionDelete		; $66d3
	ld (hl),PARTID_GASHA_TREE		; $66d6
	ld l,$d6		; $66d8
	ld (hl),$40		; $66da
	inc l			; $66dc
	ld (hl),b		; $66dd
	jp interactionDelete		; $66de

_hardOre:
	call getThisRoomFlags		; $66e1
	and $40			; $66e4
	jp z,interactionDelete		; $66e6
	ldbc TREASURE_HARD_ORE $00		; $66e9
	jp _misc1_spawnTreasureBCifRoomFlagBit5NotSet		; $66ec

; TODO: has 3 buttons, 2 keese (linked hero's cave?)
interactionCode6bSubid23:
	call checkInteractionState		; $66ef
	jr nz,@state1	; $66f2
	call getThisRoomFlags		; $66f4
	and $80			; $66f7
	jp nz,interactionDelete		; $66f9
	ld hl,wActiveTriggers		; $66fc
	ld a,(hl)		; $66ff
	cp $04			; $6700
	jr nz,+			; $6702
	set 7,(hl)		; $6704
+
	cp $85			; $6706
	jr nz,+			; $6708
	set 6,(hl)		; $670a
+
	and $07			; $670c
	cp $07			; $670e
	ret nz			; $6710
	ld a,$1e		; $6711
	ld e,$46		; $6713
	ld (de),a		; $6715
	jp interactionIncState		; $6716
@state1:
	call interactionDecCounter1		; $6719
	ret nz			; $671c
	ld a,(wActiveTriggers)		; $671d
	bit 6,a			; $6720
	ld b,$5a		; $6722
	jr z,+			; $6724
	ld c,$5c		; $6726
	ld a,$05		; $6728
	call setTile		; $672a
	call objectCreatePuff		; $672d
	call getThisRoomFlags		; $6730
	set 7,(hl)		; $6733
	ld b,$4d		; $6735
+
	ld a,b			; $6737
	call playSound		; $6738
	jp interactionDelete		; $673b
	
; TODO: 4 orbs (linked hero's cave?)
interactionCode6bSubid24:
	ld a,(wToggleBlocksState)		; $673e
	and $0f			; $6741
	cp $0e			; $6743
	ld a,$01		; $6745
	jr z,+			; $6747
	dec a			; $6749
+
	ld (wActiveTriggers),a		; $674a
	ret			; $674d

; TODO: spawns up stair case when all enemies defeated
interactionCode6bSubid25:
	call checkInteractionState		; $674e
	jr nz,@state1	; $6751
	ld a,(wNumEnemies)		; $6753
	or a			; $6756
	ret nz			; $6757
	call interactionIncState		; $6758
	ld l,$46		; $675b
	ld (hl),$3c		; $675d
@state1:
	call interactionDecCounter1		; $675f
	ret nz			; $6762
	call objectCreatePuff		; $6763
	call objectGetShortPosition		; $6766
	ld c,a			; $6769
	ld a,TILEINDEX_INDOOR_UPSTAIRCASE		; $676a
	call setTile		; $676c
	xor a			; $676f
	ld ($cbca),a		; $6770
	jp interactionDelete		; $6773

; TODO: there is a subrosian where this one should be?
interactionCode6bSubid26:
	call checkInteractionState		; $6776
	jp nz,interactionRunScript		; $6779
	ld hl,subrosianScript_templeFallenText		; $677c
	call interactionSetScript		; $677f
	jp interactionIncState		; $6782


; ==============================================================================
; INTERACID_ROSA_HIDING
; ==============================================================================
interactionCode6c:
	ld e,Interaction.subid		; $6785
	ld a,(de)		; $6787
	rst_jumpTable			; $6788
	.dw _rosaSubId0
	.dw _rosaSubId1


; ==============================================================================
; INTERACID_STRANGE_BROTHERS_HIDING
; ==============================================================================
interactionCode6d:
	ld e,Interaction.subid		; $678d
	ld a,(de)		; $678f
	rst_jumpTable			; $6790
	.dw _strangeBrothersSubId0
	.dw _strangeBrothersSubId1
	.dw _strangeBrothersSubId2

_rosaSubId0:
	ld e,Interaction.state2		; $6797
	ld a,(de)		; $6799
	rst_jumpTable			; $679a
	.dw @substate0
	.dw @substate1
@substate0:
	ld a,$01		; $679f
	ld (de),a		; $67a1
	ld a,TREASURE_ESSENCE		; $67a2
	call checkTreasureObtained		; $67a4
	and $01			; $67a7
	jp z,interactionDelete		; $67a9
	call getThisRoomFlags		; $67ac
	bit 7,a			; $67af
	jp nz,interactionDelete		; $67b1
	call interactionSetAlwaysUpdateBit		; $67b4
	call objectSetReservedBit1		; $67b7
	ld a,$01		; $67ba
	ld ($cca4),a		; $67bc
	ld ($cc02),a		; $67bf
	ld e,$79		; $67c2
	ld a,($cc4c)		; $67c4
	ld (de),a		; $67c7
	xor a			; $67c8
	ld (wActiveMusic),a		; $67c9
	ld a,$0b		; $67cc
	call playSound		; $67ce
@func_67d1:
	ld a,$80		; $67d1
	ld ($cc9f),a		; $67d3
	ld a,$01		; $67d6
	ld ($ccab),a		; $67d8
	ldbc $01 INTERACID_ROSA_HIDING		; $67db
	call _spawnHider		; $67de
	ld e,a			; $67e1
	ld bc,@table_67f1		; $67e2
	call addDoubleIndexToBc		; $67e5
	call _func_69ac		; $67e8
	ld a,e			; $67eb
	cp $04			; $67ec
	jr z,@func_680c		; $67ee
	ret			; $67f0
@table_67f1:
	; yh - xh
	.db $28 $50
	.db $58 $68
	.db $58 $58
	.db $58 $58
	.db $58 $58
@func_67fb:
	ld a,($cc4c)		; $67fb
	cp $cb			; $67fe
	jp z,interactionDelete		; $6800
	ld a,($cc62)		; $6803
	ld (wActiveMusic),a		; $6806
	call playSound		; $6809
@func_680c:
	xor a			; $680c
	ld ($cc9f),a		; $680d
	ld ($ccab),a		; $6810
	jp interactionDelete		; $6813
@substate1:
	ld e,$78		; $6816
	ld a,(de)		; $6818
	rst_jumpTable			; $6819
	.dw @var38_00
	.dw @var38_01
@var38_00:
	ld a,($cc4c)		; $681e
	cp $cb			; $6821
	jr nz,@func_67fb	; $6823
	ld a,($cc9e)		; $6825
	cp $02			; $6828
	ret nz			; $682a
	ld e,$78		; $682b
	ld a,$01		; $682d
	ld (de),a		; $682f
	ret			; $6830
@var38_01:
	ld a,($cfc0)		; $6831
	or a			; $6834
	jr z,+			; $6835
	ld e,$7a		; $6837
	ld a,$01		; $6839
	ld (de),a		; $683b
	xor a			; $683c
	ld ($ccab),a		; $683d
+
	ld e,$79		; $6840
	ld a,(de)		; $6842
	ld b,a			; $6843
	ld a,($cc4c)		; $6844
	cp b			; $6847
	ret z			; $6848
	ld (de),a		; $6849
	cp $cb			; $684a
	jr z,@func_67fb	; $684c
	ld e,$7a		; $684e
	ld a,(de)		; $6850
	or a			; $6851
	jr z,@func_67fb	; $6852
	xor a			; $6854
	ld (de),a		; $6855
	ld h,d			; $6856
	ld l,$46		; $6857
	inc (hl)		; $6859
	ld a,(hl)		; $685a
	ld bc,@table_686c		; $685b
	call addAToBc		; $685e
	ld a,(bc)		; $6861
	ld b,a			; $6862
	ld a,($cc4c)		; $6863
	cp b			; $6866
	jr nz,@func_67fb	; $6867
	jp @func_67d1		; $6869
@table_686c:
	.db $cb $bb $ab $9b $9a

_rosaSubId1:
	ld e,Interaction.state2		; $6871
	ld a,(de)		; $6873
	rst_jumpTable			; $6874
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3
	.dw @substate4
	.dw @substate5
@substate0:
	ld a,$01		; $6881
	ld (de),a		; $6883
	call interactionInitGraphics		; $6884
	ld e,$43		; $6887
	ld a,(de)		; $6889
	ld hl,_table_6931		; $688a
	rst_addDoubleIndex			; $688d
	ldi a,(hl)		; $688e
	ld h,(hl)		; $688f
	ld l,a			; $6890
	call interactionSetScript		; $6891
	ld e,$6d		; $6894
	ld a,$08		; $6896
	ld (de),a		; $6898
	call objectSetVisiblec2		; $6899
@substate1:
	call interactionRunScript		; $689c
	jp c,interactionDelete		; $689f
@func_68a2:
	ld c,$20		; $68a2
	jp objectUpdateSpeedZ_paramC		; $68a4
@substate2:
	call interactionRunScript		; $68a7
	jp c,interactionDelete		; $68aa
	ld c,$20		; $68ad
	call objectUpdateSpeedZ_paramC		; $68af
	ret nz			; $68b2
	ld bc,$fe40		; $68b3
	jp objectSetSpeedZ		; $68b6
@substate3:
	call interactionAnimate		; $68b9
	call @func_68a2		; $68bc
	ret nz			; $68bf
	call interactionRunScript		; $68c0
	jp c,interactionDelete		; $68c3
	ret			; $68c6
@substate4:
	ld e,$7b		; $68c7
	ld a,(de)		; $68c9
	inc a			; $68ca
	jr z,+			; $68cb
	jr @substate3		; $68cd
+
	ld hl,rosaHidingScript_caught		; $68cf
	call interactionSetScript		; $68d2
	jp interactionRunScript		; $68d5
@substate5:
	call interactionAnimate		; $68d8
	call @func_68a2		; $68db
	ret nz			; $68de
	ld a,$09		; $68df
	call objectGetShortPosition_withYOffset		; $68e1
	ld c,a			; $68e4
	ld b,$ce		; $68e5
	ld a,(bc)		; $68e7
	cp $ff			; $68e8
	jr z,+			; $68ea
	or a			; $68ec
	jr nz,++		; $68ed
+
	ld a,$10		; $68ef
	jr _func_6919		; $68f1
++
	ld e,$6d		; $68f3
	ld a,(de)		; $68f5
	ldh (<hFF8B),a	; $68f6
	ld e,$49		; $68f8
	ld (de),a		; $68fa
	call convertAngleDeToDirection		; $68fb
	xor $02			; $68fe
	sub $02			; $6900
	add c			; $6902
	ld c,a			; $6903
	ld a,(bc)		; $6904
	or a			; $6905
	ldh a,(<hFF8B)	; $6906
	jr z,_func_6919	; $6908
	ld e,$6d		; $690a
	ld a,(de)		; $690c
	cp $08			; $690d
	jr z,+			; $690f
	ld a,$08		; $6911
	ld (de),a		; $6913
	jr _func_6919		; $6914
+
	ld a,$18		; $6916
	ld (de),a		; $6918
_func_6919:
	ld e,$49		; $6919
	ld (de),a		; $691b
	call objectApplySpeed		; $691c
	ld e,$4b		; $691f
	ld a,(de)		; $6921
	cp $90			; $6922
	jr nc,+			; $6924
	ret			; $6926
+
	xor a			; $6927
	ld ($cca4),a		; $6928
	ld ($ccab),a		; $692b
	jp interactionDelete		; $692e
_table_6931:
	.dw rosaHidingScript_1stScreen
	.dw rosaHidingScript_2ndScreen
	.dw rosaHidingScript_3rdScreen
	.dw rosaHidingScript_4thScreen
	.dw rosaHidingScript_portalScreen
	.dw rosaHidingScript_caught

_strangeBrothersSubId0:
	ld e,Interaction.state		; $693d
	ld a,(de)		; $693f
	rst_jumpTable			; $6940
	.dw @state0
	.dw _strangeBrothersSubId0State1
	.dw _strangeBrothersSubId0State2
	.dw _strangeBrothersSubId0State3
@state0:
	ld a,$01		; $6949
	ld (de),a		; $694b
	ld a,GLOBALFLAG_STRANGE_BROTHERS_HIDING_IN_PROGRESS		; $694c
	call checkGlobalFlag		; $694e
	jp nz,interactionDelete		; $6951
	ld e,$40		; $6954
	ld a,$83		; $6956
	ld (de),a		; $6958
	ld a,($cc4c)		; $6959
	ld ($cfd1),a		; $695c
	ld a,GLOBALFLAG_STRANGE_BROTHERS_HIDING_IN_PROGRESS		; $695f
	call setGlobalFlag		; $6961
_func_6964:
	ld a,$01		; $6964
	ld ($ccab),a		; $6966
	ldbc $01 INTERACID_STRANGE_BROTHERS_HIDING		; $6969
	call _spawnHider		; $696c
	ldbc $02 INTERACID_STRANGE_BROTHERS_HIDING		; $696f
	call _spawnHider		; $6972
	ld a,TREASURE_FEATHER		; $6975
	call checkTreasureObtained		; $6977
	ld a,$01		; $697a
	jr nc,+			; $697c
	call getRandomNumber		; $697e
	and $01			; $6981
+
	ld ($cfd0),a		; $6983
	ld e,$46		; $6986
	ld a,(de)		; $6988
	cp $06			; $6989
	jp z,_func_6995		; $698b
	ret			; $698e
_func_698f:
	ld a,(wActiveMusic)		; $698f
	call playSound		; $6992
_func_6995:
	xor a			; $6995
	ld ($cc9e),a		; $6996
	jp interactionDelete		; $6999
	
;;
; @param[out]	b	subid
; @param[out]	c	id
_spawnHider:
	call getFreeInteractionSlot		; $699c
	dec l			; $699f
	set 7,(hl)		; $69a0
	inc l			; $69a2
	ld (hl),c		; $69a3
	inc l			; $69a4
	ld (hl),b		; $69a5
	inc l			; $69a6
	ld e,$46		; $69a7
	ld a,(de)		; $69a9
	ld (hl),a		; $69aa
	ret			; $69ab

_func_69ac:
	ld l,$4b		; $69ac
	ld a,(bc)		; $69ae
	ldi (hl),a		; $69af
	inc l			; $69b0
	inc bc			; $69b1
	ld a,(bc)		; $69b2
	ld (hl),a		; $69b3
	ret			; $69b4

_strangeBrothersSubId0State1:
	ld a,($cd00)		; $69b5
	and $01			; $69b8
	ret z			; $69ba
	ld a,($cc9e)		; $69bb
	cp $02			; $69be
	ret nz			; $69c0
	xor a			; $69c1
	ld ($cfc0),a		; $69c2
	ld e,Interaction.state		; $69c5
	ld a,$02		; $69c7
	ld (de),a		; $69c9
	ld a,GLOBALFLAG_JUST_CAUGHT_BY_STRANGE_BROTHERS		; $69ca
	call unsetGlobalFlag		; $69cc
	ld a,$0b		; $69cf
	jp playSound		; $69d1
	
_strangeBrothersSubId0State2:
	ld a,($cfc0)		; $69d4
	cp $ff			; $69d7
	jr z,_func_6a23	; $69d9
	and $03			; $69db
	cp $03			; $69dd
	jr nz,+			; $69df
	ld e,$7a		; $69e1
	ld (de),a		; $69e3
	xor a			; $69e4
	ld ($ccab),a		; $69e5
	ld ($cfc0),a		; $69e8
+
	ld a,($cc4c)		; $69eb
	ld b,a			; $69ee
	ld a,($cfd1)		; $69ef
	cp b			; $69f2
	ret z			; $69f3
	ld a,b			; $69f4
	ld ($cfd1),a		; $69f5
	cp $51			; $69f8
	jr z,_func_698f	; $69fa
	ld e,$7a		; $69fc
	ld a,(de)		; $69fe
	cp $03			; $69ff
	jr nz,_func_698f	; $6a01
	xor a			; $6a03
	ld (de),a		; $6a04
	ld h,d			; $6a05
	ld l,$46		; $6a06
	inc (hl)		; $6a08
	ld a,(hl)		; $6a09
	ld bc,@table_6a1c		; $6a0a
	call addAToBc		; $6a0d
	ld a,(bc)		; $6a10
	ld b,a			; $6a11
	ld a,($cc4c)		; $6a12
	cp b			; $6a15
	jp nz,_func_698f		; $6a16
	jp _func_6964		; $6a19
@table_6a1c:
	.db $51 $61 $71 $70
	.db $60 $50 $60
_func_6a23:
	ld e,Interaction.state		; $6a23
	ld a,$03		; $6a25
	ld (de),a		; $6a27
	ld a,$01		; $6a28
	ld ($cc02),a		; $6a2a
	ld bc,TX_2804		; $6a2d
	jp showText		; $6a30

_strangeBrothersSubId0State3:
	ld a,($cfc0)		; $6a33
	or a			; $6a36
	ret nz			; $6a37
	ld a,GLOBALFLAG_JUST_CAUGHT_BY_STRANGE_BROTHERS		; $6a38
	call setGlobalFlag		; $6a3a
	ld a,GLOBALFLAG_STRANGE_BROTHERS_HIDING_IN_PROGRESS		; $6a3d
	call unsetGlobalFlag		; $6a3f
	xor a			; $6a42
	ld ($ccab),a		; $6a43
	ld hl,@warpDestVariables		; $6a46
	call setWarpDestVariables		; $6a49
	jp interactionDelete		; $6a4c
@warpDestVariables:
	m_HardcodedWarpA ROOM_SEASONS_151 $00 $28 $03

_strangeBrothersSubId1:
_strangeBrothersSubId2:
	ld e,Interaction.state		; $6a54
	ld a,(de)		; $6a56
	rst_jumpTable			; $6a57
	.dw @state0
	.dw @state1
	.dw @state2
@state0:
	ld a,$01		; $6a5e
	ld (de),a		; $6a60
	call interactionInitGraphics		; $6a61
	ld e,$50		; $6a64
	ld a,$28		; $6a66
	ld (de),a		; $6a68
	ld e,Interaction.subid		; $6a69
	ld a,(de)		; $6a6b
	ld b,a			; $6a6c
	dec a			; $6a6d
	ld a,$02		; $6a6e
	jr z,+			; $6a70
	dec a			; $6a72
+
	ld e,$5c		; $6a73
	ld (de),a		; $6a75
	ld a,b			; $6a76
	dec a			; $6a77
	ld hl,@table_6a92		; $6a78
	rst_addDoubleIndex			; $6a7b
	ldi a,(hl)		; $6a7c
	ld h,(hl)		; $6a7d
	ld l,a			; $6a7e
	ld e,$43		; $6a7f
	ld a,(de)		; $6a81
	rst_addDoubleIndex			; $6a82
	ldi a,(hl)		; $6a83
	ld h,(hl)		; $6a84
	ld l,a			; $6a85
	call interactionSetScript		; $6a86
	call interactionRunScript		; $6a89
	call interactionRunScript		; $6a8c
	jp objectSetVisiblec2		; $6a8f
@table_6a92:
	.dw @table_6a96
	.dw @table_6aa4
@table_6a96:
	.dw strangeBrother1Script_1stScreen
	.dw strangeBrother1Script_2ndScreen
	.dw strangeBrother1Script_3rdScreen
	.dw strangeBrother1Script_4thScreen
	.dw strangeBrother1Script_5thScreen
	.dw strangeBrother1Script_6thScreen
	.dw strangeBrother1Script_finishedScreen
@table_6aa4:
	.dw strangeBrother2Script_1stScreen
	.dw strangeBrother2Script_2ndScreen
	.dw strangeBrother2Script_3rdScreen
	.dw strangeBrother2Script_4thScreen
	.dw strangeBrother2Script_5thScreen
	.dw strangeBrother2Script_6thScreen
	.dw strangeBrother2Script_finishedScreen
@state1:
	ld a,($cca7)		; $6ab2
	or a			; $6ab5
	jr nz,@func_6add			; $6ab6
	ld e,$7b		; $6ab8
	ld a,(de)		; $6aba
	or a			; $6abb
	jr nz,@func_6add	; $6abc
	ld a,($cfc0)		; $6abe
	cp $ff			; $6ac1
	jr z,@func_6add	; $6ac3
	call interactionAnimate		; $6ac5
	call interactionAnimate		; $6ac8
	call interactionRunScript		; $6acb
	jp c,interactionDelete		; $6ace
@func_6ad1:
	ld c,$60		; $6ad1
	call objectUpdateSpeedZ_paramC		; $6ad3
	ret nz			; $6ad6
	ld bc,$fe00		; $6ad7
	jp objectSetSpeedZ		; $6ada
@func_6add:
	ld a,$ff		; $6add
	ld ($cfc0),a		; $6adf
	ld a,$01		; $6ae2
	ld ($cca4),a		; $6ae4
	ld h,d			; $6ae7
	ld l,$44		; $6ae8
	inc (hl)		; $6aea
	ld l,$50		; $6aeb
	ld (hl),$64		; $6aed
	call objectGetAngleTowardLink		; $6aef
	add $10			; $6af2
	and $1f			; $6af4
	ld e,$49		; $6af6
	ld (de),a		; $6af8
	call convertAngleDeToDirection		; $6af9
	jp interactionSetAnimation		; $6afc
@state2:
	call interactionAnimate		; $6aff
	call interactionAnimate		; $6b02
	call @func_6ad1		; $6b05
	call retIfTextIsActive		; $6b08
	call objectApplySpeed		; $6b0b
	call objectCheckWithinScreenBoundary		; $6b0e
	ret c			; $6b11
	call objectSetInvisible		; $6b12
	ld h,d			; $6b15
	ld l,$44		; $6b16
	inc (hl)		; $6b18
	jr +			; $6b19
+
	xor a			; $6b1b
	ld ($cfc0),a		; $6b1c
	jp interactionDelete		; $6b1f


; ==============================================================================
; INTERACID_STEALING_FEATHER
; ==============================================================================
interactionCode6e:
	ld e,Interaction.subid		; $6b22
	ld a,(de)		; $6b24
	rst_jumpTable			; $6b25
	.dw @subid0
	.dw @subid1
	.dw @subid2
@subid0:
	ld e,Interaction.state		; $6b2c
	ld a,(de)		; $6b2e
	rst_jumpTable			; $6b2f
	.dw @@state0
	.dw @@state1
	.dw @@state2
@@state0:
	ld a,$01		; $6b36
	ld (de),a		; $6b38
	call interactionInitGraphics		; $6b39
	ld a,TREASURE_FEATHER		; $6b3c
	call loseTreasure		; $6b3e
	ld bc,$fd80		; $6b41
	call objectSetSpeedZ		; $6b44
	ld l,$50		; $6b47
	ld (hl),$0f		; $6b49
	ld l,$49		; $6b4b
	ld (hl),$18		; $6b4d
	ld l,$46		; $6b4f
	ld (hl),$3c		; $6b51
	call interactionSetAlwaysUpdateBit		; $6b53
	jp objectSetVisiblec0		; $6b56
@@state1:
	call objectApplySpeed		; $6b59
	ld h,d			; $6b5c
	ld l,$4d		; $6b5d
	ld a,$18		; $6b5f
	cp (hl)			; $6b61
	jr c,+			; $6b62
	ld (hl),a		; $6b64
+
	call interactionAnimate		; $6b65
	ld c,$14		; $6b68
	call objectUpdateSpeedZ_paramC		; $6b6a
	call interactionDecCounter1		; $6b6d
	ret nz			; $6b70
	ld l,$4f		; $6b71
	ld a,(hl)		; $6b73
	ld l,$52		; $6b74
	ld (hl),a		; $6b76
	ld l,$44		; $6b77
	inc (hl)		; $6b79
	ld l,$4d		; $6b7a
	ld a,(hl)		; $6b7c
	ld ($cfc1),a		; $6b7d
	ld hl,$cfc0		; $6b80
	set 2,(hl)		; $6b83
	xor a			; $6b85
	call interactionSetAnimation		; $6b86
@@state2:
	ld hl,$cfc0		; $6b89
	bit 7,(hl)		; $6b8c
	jp nz,interactionDelete		; $6b8e
	ld a,(wFrameCounter)		; $6b91
	and $03			; $6b94
	ret nz			; $6b96
	ld h,d			; $6b97
	ld l,$46		; $6b98
	inc (hl)		; $6b9a
	ld a,(hl)		; $6b9b
	and $0f			; $6b9c
	ld hl,@@table_6baa		; $6b9e
	rst_addAToHl			; $6ba1
	ld e,$52		; $6ba2
	ld a,(de)		; $6ba4
	add (hl)		; $6ba5
	ld e,$4f		; $6ba6
	ld (de),a		; $6ba8
	ret			; $6ba9
@@table_6baa:
	.db $00 $00 $ff $ff $ff $fe $fe $fe
	.db $fe $fe $fe $ff $ff $ff $ff $00
@subid1:
	ld e,Interaction.state		; $6bba
	ld a,(de)		; $6bbc
	rst_jumpTable			; $6bbd
	.dw @@state0
	.dw interactionRunScript
	.dw @@state2
@@state0:
	ld a,$01		; $6bc4
	ld (de),a		; $6bc6
	call getThisRoomFlags		; $6bc7
	bit 6,(hl)		; $6bca
	jp nz,interactionDelete		; $6bcc
	ld hl,stealingFeatherScript		; $6bcf
	jp interactionSetScript		; $6bd2
@@state2:
	ld e,Interaction.state2		; $6bd5
	ld a,(de)		; $6bd7
	rst_jumpTable			; $6bd8
	.dw @@substate0
	.dw @@substate1
@@substate0:
	ld a,$01		; $6bdd
	ld (de),a		; $6bdf
	ld bc,$fe00		; $6be0
	call objectSetSpeedZ		; $6be3
	ld l,$4b		; $6be6
	ld a,($d00b)		; $6be8
	ldi (hl),a		; $6beb
	inc l			; $6bec
	ld a,($d00d)		; $6bed
	ld (hl),a		; $6bf0
@@substate1:
	ld a,(wFrameCounter)		; $6bf1
	rrca			; $6bf4
	call c,@@func_6c19		; $6bf5
	call objectApplySpeed		; $6bf8
	ld e,$4b		; $6bfb
	ld a,(de)		; $6bfd
	cp $08			; $6bfe
	jr nc,+			; $6c00
	ld e,$49		; $6c02
	ld a,$0c		; $6c04
	ld (de),a		; $6c06
+
	ld c,$40		; $6c07
	call objectUpdateSpeedZAndBounce		; $6c09
	jr nc,@@func_6c22	; $6c0c
	call @@func_6c22		; $6c0e
	ld a,$02		; $6c11
	ld ($cc6b),a		; $6c13
	jp interactionDelete		; $6c16
@@func_6c19:
	ld hl,$d008		; $6c19
	ld a,(hl)		; $6c1c
	inc a			; $6c1d
	and $03			; $6c1e
	ld (hl),a		; $6c20
	ret			; $6c21
@@func_6c22:
	ld hl,$d000		; $6c22
	jp objectCopyPosition		; $6c25
@subid2:
	ld a,GLOBALFLAG_SAW_STRANGE_BROTHERS_IN_HOUSE		; $6c28
	call unsetGlobalFlag		; $6c2a
	ld a,GLOBALFLAG_STRANGE_BROTHERS_HIDING_IN_PROGRESS		; $6c2d
	call unsetGlobalFlag		; $6c2f
	ld a,GLOBALFLAG_JUST_CAUGHT_BY_STRANGE_BROTHERS		; $6c32
	call unsetGlobalFlag		; $6c34
	jp interactionDelete		; $6c37


; ==============================================================================
; INTERACID_HOLLY
; ==============================================================================
interactionCode70:
	ld e,Interaction.subid		; $6c3a
	ld a,(de)		; $6c3c
	or a			; $6c3d
	jr nz,@subid1	; $6c3e
	call checkInteractionState		; $6c40
	jr nz,@state1	; $6c43
	ld a,$01		; $6c45
	ld (de),a		; $6c47
	ld a,(wWarpDestPos)		; $6c48
	cp $04			; $6c4b
	ld hl,hollyScript_enteredFromChimney		; $6c4d
	jr z,@setScript	; $6c50
	ld hl,hollyScript_enteredNormally		; $6c52
@setScript:
	call interactionSetScript		; $6c55
	call interactionInitGraphics		; $6c58
	jp objectSetVisiblec2		; $6c5b
@state1:
	call interactionRunScript		; $6c5e
	ld c,$0e		; $6c61
	call objectUpdateSpeedZ_paramC		; $6c63
	jp npcFaceLinkAndAnimate		; $6c66
@subid1:
	call returnIfScrollMode01Unset		; $6c69
	call interactionDeleteAndRetIfEnabled02		; $6c6c
	ld a,$d9		; $6c6f
	call findTileInRoom		; $6c71
	jr nz,+			; $6c74
	ld b,$00		; $6c76
-
	inc b			; $6c78
	dec l			; $6c79
	call backwardsSearch		; $6c7a
	jr z,-			; $6c7d
	ld a,b			; $6c7f
	cp $04			; $6c80
	jr z,++			; $6c82
+
	ld a,GLOBALFLAG_ALL_HOLLYS_SNOW_SHOVELLED		; $6c84
	jp setGlobalFlag		; $6c86
++
	ld a,GLOBALFLAG_ALL_HOLLYS_SNOW_SHOVELLED		; $6c89
	jp unsetGlobalFlag		; $6c8b


; ==============================================================================
; INTERACID_S_COMPANION_SCRIPTS
; ==============================================================================
interactionCode71:
	ld a,(wLinkDeathTrigger)		; $6c8e
	or a			; $6c91
	jr z,+			; $6c92
	xor a			; $6c94
	ld (wDisabledObjects),a		; $6c95
	jp interactionDelete		; $6c98
+
	ld e,Interaction.subid		; $6c9b
	ld a,(de)		; $6c9d
	rst_jumpTable			; $6c9e
	.dw _companionScript_subid00
	.dw _companionScript_subid01
	.dw _companionScript_subid02
	.dw _companionScript_subid03
	.dw _companionScript_subid04
	.dw _companionScript_subid05
	.dw _companionScript_subid06
	.dw _companionScript_subid07
	.dw _companionScript_subid08
	.dw _companionScript_subid09

; Ricky running off after jumping up cliff in North Horon
_companionScript_subid00:
	ld e,Interaction.state		; $6cb3
	ld a,(de)		; $6cb5
	rst_jumpTable			; $6cb6
	.dw @state0
	.dw _companionScript_runScriptDeleteWhenDone
@state0:
	ld a,$01		; $6cbb
	ld (de),a		; $6cbd
	ld a,($cc48)		; $6cbe
	and $01			; $6cc1
	jr z,_companionScript_delete	; $6cc3
	ld a,($d101)		; $6cc5
	cp $0b			; $6cc8
	jr nz,_companionScript_delete	; $6cca
	ld a,($c610)		; $6ccc
	cp $0b			; $6ccf
	jp z,interactionDelete		; $6cd1
	ld a,$0a		; $6cd4
	ld hl,$d104		; $6cd6
	ldi (hl),a		; $6cd9
	ld l,$03		; $6cda
	ld a,$02		; $6cdc
	ld (hl),a		; $6cde
	ld l,$30		; $6cdf
	ld a,(hl)		; $6ce1
	ld l,$3f		; $6ce2
	ld (hl),a		; $6ce4
	ld hl,companionScript_RickyLeavingYouInSpoolSwamp		; $6ce5
	jp interactionSetScript		; $6ce8

; Moosh being bullied in Spool
_companionScript_subid01:
	ld e,Interaction.state		; $6ceb
	ld a,(de)		; $6ced
	rst_jumpTable			; $6cee
	.dw @state0
	.dw _companionScript_runScriptDeleteWhenDone
	.dw _companionScript_giveFlute
	.dw _companionScriptFunc_6eaf
@state0:
	ld a,($d101)		; $6cf7
	cp $0d			; $6cfa
	jr nz,_companionScript_delete	; $6cfc
	ld a,($c610)		; $6cfe
	cp $0d			; $6d01
	jr nz,_companionScript_delete	; $6d03
	ld a,$01		; $6d05
	ld (de),a		; $6d07
	ld e,$79		; $6d08
	ld a,$0d		; $6d0a
	ld (de),a		; $6d0c
	call _companionScript_setSubId0AndInitGraphics		; $6d0d
	ld e,$42		; $6d10
	ld a,$01		; $6d12
	ld (de),a		; $6d14
	ld a,$1c		; $6d15
	ld e,$4b		; $6d17
	ld (de),a		; $6d19
	ld a,$2c		; $6d1a
	ld e,$4d		; $6d1c
	ld (de),a		; $6d1e
	ld hl,companionScript_mooshInSpoolSwamp		; $6d1f
	call interactionSetScript		; $6d22
	ld a,(wMooshState)		; $6d25
	bit 5,a			; $6d28
	jr nz,_companionScript_delete	; $6d2a
	or a			; $6d2c
	ld a,$01		; $6d2d
	ld ($ccf4),a		; $6d2f
	ret nz			; $6d32
	jp interactionAnimateAsNpc		; $6d33

_companionScript_runScriptDeleteWhenDone:
	call interactionRunScript		; $6d36
	ret nc			; $6d39
	call setStatusBarNeedsRefreshBit1		; $6d3a
_companionScript_delete:
	jp interactionDelete		; $6d3d

; Sunken city entrance
_companionScript_subid02:
	ld e,Interaction.state		; $6d40
	ld a,(de)		; $6d42
	rst_jumpTable			; $6d43
	.dw @state0
	.dw @state1
@state0:
	ld a,$01		; $6d48
	ld (de),a		; $6d4a
	ld a,(wLinkObjectIndex)		; $6d4b
	and $01			; $6d4e
	jr z,_companionScript_delete	; $6d50
	ld a,($d101)		; $6d52
	cp SPECIALOBJECTID_RICKY			; $6d55
	jr z,@func_6d72	; $6d57
	cp SPECIALOBJECTID_MOOSH			; $6d59
	jr nz,_companionScript_delete	; $6d5b
	ld a,$0a		; $6d5d
	ld hl,$d104		; $6d5f
	ldi (hl),a		; $6d62
	ld l,$03		; $6d63
	ld a,$08		; $6d65
	ld (hl),a		; $6d67
	ld l,$3f		; $6d68
	ld (hl),$14		; $6d6a
	ld hl,companionScript_mooshEnteringSunkenCity		; $6d6c
	jp interactionSetScript		; $6d6f
@func_6d72:
	ld hl,$d104		; $6d72
	ld a,$0a		; $6d75
	ldi (hl),a		; $6d77
	ld l,$03		; $6d78
	ld a,$09		; $6d7a
	ld (hl),a		; $6d7c
	jr _companionScript_delete		; $6d7d
@state1:
	call interactionRunScript		; $6d7f
	jr c,_companionScript_delete	; $6d82
	ret			; $6d84

; Moosh in Mt Cucco
_companionScript_subid06:
	ld e,Interaction.state		; $6d85
	ld a,(de)		; $6d87
	rst_jumpTable			; $6d88
	.dw @state0
	.dw @state1
	.dw @state2
@state0:
	ld a,(wMooshState)		; $6d8f
	and $80			; $6d92
	jr nz,_companionScript_delete	; $6d94
	ld a,$01		; $6d96
	ld (de),a		; $6d98
	ld a,$1c		; $6d99
	ld e,$4b		; $6d9b
	ld (de),a		; $6d9d
	ld a,$2c		; $6d9e
	ld e,$4d		; $6da0
	ld (de),a		; $6da2
	ld a,TREASURE_SPRING_BANANA		; $6da3
	call checkTreasureObtained		; $6da5
	ld a,$00		; $6da8
	rla			; $6daa
	ld e,$78		; $6dab
	ld (de),a		; $6dad
	ld hl,companionScript_mooshInMtCucco		; $6dae
	jp interactionSetScript		; $6db1
@state1:
	ld a,($d13d)		; $6db4
	or a			; $6db7
	jr z,@goToRunScriptThenDelete	; $6db8
	ld e,$78		; $6dba
	ld a,(de)		; $6dbc
	or a			; $6dbd
	jr z,@goToRunScriptThenDelete	; $6dbe
	ld e,$7a		; $6dc0
	ld a,(de)		; $6dc2
	or a			; $6dc3
	jr nz,@goToRunScriptThenDelete	; $6dc4
	inc a			; $6dc6
	ld (de),a		; $6dc7
	ld ($cc02),a		; $6dc8
	ld hl,$d000		; $6dcb
	call objectTakePosition		; $6dce
	ld a,($d10b)		; $6dd1
	ld b,a			; $6dd4
	ld a,($d10d)		; $6dd5
	ld c,a			; $6dd8
	call objectGetRelativeAngle		; $6dd9
	ld e,$49		; $6ddc
	ld (de),a		; $6dde
	ld a,$02		; $6ddf
	ld ($d108),a		; $6de1
	add $01			; $6de4
	ld ($d13f),a		; $6de6
@goToRunScriptThenDelete:
	jp _companionScript_runScriptDeleteWhenDone		; $6de9
@state2:
	ld h,d			; $6dec
	ld l,$5a		; $6ded
	bit 7,(hl)		; $6def
	jr nz,++		; $6df1
	ld l,$50		; $6df3
	ld (hl),$32		; $6df5
	ld bc,$fec0		; $6df7
	call objectSetSpeedZ		; $6dfa
	call objectSetVisible80		; $6dfd
	call _companionScript_setSubId0AndInitGraphics		; $6e00
	ld a,$06		; $6e03
	ld e,Interaction.subid		; $6e05
	ld (de),a		; $6e07
	ld e,$46		; $6e08
	ld a,$10		; $6e0a
	ld (de),a		; $6e0c
++
	call retIfTextIsActive		; $6e0d
	ld c,$40		; $6e10
	call objectUpdateSpeedZ_paramC		; $6e12
	jp nz,objectApplySpeed		; $6e15
	call interactionDecCounter1		; $6e18
	ret nz			; $6e1b
	ld l,$44		; $6e1c
	dec (hl)		; $6e1e
	ld a,TREASURE_SPRING_BANANA		; $6e1f
	call loseTreasure		; $6e21
	jp objectSetInvisible		; $6e24

; Ricky in North Horon
_companionScript_subid03:
	ld e,Interaction.state		; $6e27
	ld a,(de)		; $6e29
	rst_jumpTable			; $6e2a
	.dw @state0
	.dw _companionScript_runScriptDeleteWhenDone
	.dw @state2
	.dw _companionScriptFunc_6eaf
@state0:
	ld a,($c643)		; $6e33
	and $80			; $6e36
	jp nz,_companionScript_delete2		; $6e38
	ld a,$01		; $6e3b
	ld (de),a		; $6e3d
	ld e,$79		; $6e3e
	ld a,$0b		; $6e40
	ld (de),a		; $6e42
	call interactionSetAlwaysUpdateBit		; $6e43
	ld hl,companionScript_RickyInNorthHoron		; $6e46
	jp interactionSetScript		; $6e49
@state2:
	ld a,TREASURE_RICKY_GLOVES		; $6e4c
	call loseTreasure		; $6e4e
_companionScript_giveFlute:
	ld a,$01		; $6e51
	ld ($cc02),a		; $6e53
	call interactionIncState		; $6e56
	ld e,$79		; $6e59
	ld a,(de)		; $6e5b
	ld c,a			; $6e5c
	cp $0d			; $6e5d
	jr z,+			; $6e5f
	ld hl,$c638		; $6e61
	rst_addAToHl			; $6e64
	set 7,(hl)		; $6e65
+
	ld a,c			; $6e67
	ld hl,$c610		; $6e68
	cp (hl)			; $6e6b
	ret nz			; $6e6c
	sub $0a			; $6e6d
	ld l,$af		; $6e6f
	ld (hl),a		; $6e71
	ld a,(de)		; $6e72
	ld c,a			; $6e73
	ld a,TREASURE_FLUTE		; $6e74
	call giveTreasure		; $6e76
	ld hl,$cbea		; $6e79
	set 0,(hl)		; $6e7c
	ld e,Interaction.subid		; $6e7e
	ld a,$01		; $6e80
	ld (de),a		; $6e82
	call interactionInitGraphics		; $6e83
	ld e,Interaction.subid		; $6e86
	ld a,$03		; $6e88
	ld (de),a		; $6e8a
	ld e,$79		; $6e8b
	ld a,(de)		; $6e8d
	sub $0a			; $6e8e
	ld c,a			; $6e90
	and $01			; $6e91
	add a			; $6e93
	xor c			; $6e94
	ld e,$5c		; $6e95
	ld (de),a		; $6e97
	ld hl,$cc6a		; $6e98
	ld a,$04		; $6e9b
	ldi (hl),a		; $6e9d
	ld (hl),$01		; $6e9e
	ld hl,$d000		; $6ea0
	ld bc,$f200		; $6ea3
	call objectTakePositionWithOffset		; $6ea6
	call objectSetVisible80		; $6ea9
	jp interactionRunScript		; $6eac

_companionScriptFunc_6eaf:
	call retIfTextIsActive		; $6eaf
	ld ($cca4),a		; $6eb2
	call objectSetInvisible		; $6eb5
	ld a,($cc48)		; $6eb8
	and $0f			; $6ebb
	add a			; $6ebd
	swap a			; $6ebe
	ld ($cca4),a		; $6ec0
	call interactionRunScript		; $6ec3
	ret nc			; $6ec6
	xor a			; $6ec7
	ld ($cca4),a		; $6ec8
	ld ($cc02),a		; $6ecb
	jr _companionScript_delete2		; $6ece

; Dimitri in Spool Swamp
_companionScript_subid04:
	ld e,Interaction.state		; $6ed0
	ld a,(de)		; $6ed2
	rst_jumpTable			; $6ed3
	.dw @state0
	.dw _companionScript_runScriptDeleteWhenDone
	.dw _companionScript_giveFlute
	.dw _companionScriptFunc_6eaf
@state0:
	ld a,(wDimitriState)		; $6edc
	and $80			; $6edf
	jr nz,_companionScript_delete2	; $6ee1
	ld a,($c610)		; $6ee3
	cp $0c			; $6ee6
	jr nz,_companionScript_delete2	; $6ee8
	ld a,$01		; $6eea
	ld (de),a		; $6eec
	ld e,$79		; $6eed
	ld a,$0c		; $6eef
	ld (de),a		; $6ef1
	ld hl,companionScript_dimitriInSpoolSwamp		; $6ef2
	jp interactionSetScript		; $6ef5

; Dimitri being bullied
_companionScript_subid05:
	ld e,Interaction.state		; $6ef8
	ld a,(de)		; $6efa
	rst_jumpTable			; $6efb
	.dw @state0
	.dw _companionScript_runScriptDeleteWhenDone
@state0:
	ld a,(wDimitriState)		; $6f00
	and $80			; $6f03
	jr nz,_companionScript_delete2	; $6f05
	ld a,($c610)		; $6f07
	cp $0c			; $6f0a
	jr z,_companionScript_delete2	; $6f0c
	ld a,$01		; $6f0e
	ld (de),a		; $6f10
	ld hl,companionScript_dimitriBeingBullied		; $6f11
	jp interactionSetScript		; $6f14

; Moblin rest house
_companionScript_subid07:
	ld a,(wDimitriState)		; $6f17
	or $20			; $6f1a
	ld (wDimitriState),a		; $6f1c
_companionScript_delete2:
	jp interactionDelete		; $6f1f

; Sunken city entrance
_companionScript_subid08:
	ld e,Interaction.state		; $6f22
	ld a,(de)		; $6f24
	rst_jumpTable			; $6f25
	.dw @state0
	.dw @state1
@state0:
	ld a,$01		; $6f2a
	ld (de),a		; $6f2c
	ld a,($d101)		; $6f2d
	cp SPECIALOBJECTID_DIMITRI			; $6f30
	jr nz,_companionScript_delete2	; $6f32
	ld a,(wAnimalCompanion)		; $6f34
	cp SPECIALOBJECTID_DIMITRI			; $6f37
	jr z,_companionScript_delete2	; $6f39
@state1:
	ld a,($cd00)		; $6f3b
	and $0e			; $6f3e
	ret nz			; $6f40
	ld hl,$d10b		; $6f41
	ldi a,(hl)		; $6f44
	cp $50			; $6f45
	ret nc			; $6f47
	cp $30			; $6f48
	ret c			; $6f4a
	inc l			; $6f4b
	ld a,(hl)		; $6f4c
	cp $10			; $6f4d
	ret nc			; $6f4f
	ld a,$10		; $6f50
	ld (hl),a		; $6f52
	ld l,$04		; $6f53
	ld a,(hl)		; $6f55
	cp $08			; $6f56
	jr z,+			; $6f58
	cp $02			; $6f5a
	jr nz,+			; $6f5c
	ld (hl),$01		; $6f5e
	call dropLinkHeldItem		; $6f60
+
	ld l,$04		; $6f63
	ld (hl),$0d		; $6f65
	ld bc,TX_211e		; $6f67
	jp showText		; $6f6a

; 1st screen of North Horon from Eyeglass lake area
_companionScript_subid09:
	ld h,$c6		; $6f6d
	call checkIsLinkedGame		; $6f6f
	jr nz,+			; $6f72
	ld a,TREASURE_FLUTE		; $6f74
	call checkTreasureObtained		; $6f76
	jr c,+			; $6f79
	ld l,<wAnimalCompanion		; $6f7b
	ld (hl),SPECIALOBJECTID_RICKY		; $6f7d
+
	ld l,<wRickyState		; $6f7f
	set 5,(hl)		; $6f81
	jr _companionScript_delete2		; $6f83

_companionScript_setSubId0AndInitGraphics:
	ld e,Interaction.subid		; $6f85
	xor a			; $6f87
	ld (de),a		; $6f88
	jp interactionInitGraphics		; $6f89


; ==============================================================================
; INTERACID_BLAINO
; var37 - 0 if enough rupees, else 1
; var38 - RUPEEVAL_10 if cheated, otherwise RUPEEVAL_20
; var39 - pointer to Blaino / script ???
; $cca7 - ???
; $ccec - result of fight - $01 if won, $02 if lost, $03 if cheated
; $cced - $00 on init, $01 when starting fight, $03 when fight done
; ==============================================================================
interactionCode72:
	ld e,Interaction.subid		; $6f8c
	ld a,(de)		; $6f8e
	or a			; $6f8f
	jr nz,_blainoSubid01	; $6f90
	; subid00
	ld e,Interaction.state		; $6f92
	ld a,(de)		; $6f94
	rst_jumpTable			; $6f95
	.dw @state0
	.dw @state1
	.dw interactionDelete

@state0:
	call interactionIncState		; $6f9c
	ld a,($cced)		; $6f9f
	cp $00			; $6fa2
	jr z,+			; $6fa4
	cp $01			; $6fa6
	jr z,++			; $6fa8
	cp $03			; $6faa
	jr z,+			; $6fac
+
	ld l,Interaction.var38		; $6fae
	ld (hl),$01		; $6fb0
	ld l,Interaction.var37		; $6fb2
	ld (hl),$02		; $6fb4
	ld a,$06		; $6fb6
	call objectSetCollideRadius		; $6fb8
	call _seasonsFunc_09_7055		; $6fbb
	call interactionInitGraphics		; $6fbe
	jr @animate		; $6fc1
++
	ld l,Interaction.var38		; $6fc3
	ld (hl),$00		; $6fc5
	call interactionInitGraphics		; $6fc7
	ld a,$01		; $6fca
	jp interactionSetAnimation		; $6fcc
	jr +			; $6fcf

@state1:
	ld e,Interaction.var38		; $6fd1
	ld a,(de)		; $6fd3
	or a			; $6fd4
	jr z,+			; $6fd5
	call _seasonsFunc_09_7036		; $6fd7
	call _seasonsFunc_09_704f		; $6fda
@animate:
	call interactionAnimate		; $6fdd
+
	call objectPreventLinkFromPassing		; $6fe0
	jp objectSetPriorityRelativeToLink_withTerrainEffects		; $6fe3

_blainoSubid01:
	ld e,Interaction.state		; $6fe6
	ld a,(de)		; $6fe8
	rst_jumpTable			; $6fe9
	.dw @state0
	.dw @state1

@state0:
	ld a,$01		; $6fee
	ld (de),a		; $6ff0
	call interactionInitGraphics		; $6ff1
	ld a,$04		; $6ff4
	call interactionSetAnimation		; $6ff6
	jp objectSetVisiblec1		; $6ff9

@state1:
	ld e,Interaction.state2		; $6ffc
	ld a,(de)		; $6ffe
	rst_jumpTable			; $6fff
	.dw @substate0
	.dw @substate1
	.dw @substate2

@substate0:
	ld a,($cbb5)		; $7006
	or a			; $7009
	jr z,@substate2	; $700a
	ld h,d			; $700c
	ld l,Interaction.state2		; $700d
	inc (hl)		; $700f
	ld l,Interaction.animCounter		; $7010
	ld (hl),$01		; $7012
	xor a			; $7014
	ld l,Interaction.z		; $7015
	ldi (hl),a		; $7017
	; zh
	ld (hl),a		; $7018
	jp interactionAnimate		; $7019

@substate1:
	ld h,d			; $701c
	ld l,Interaction.animParameter		; $701d
	ld a,(hl)		; $701f
	or a			; $7020
	jr z,+			; $7021
	ld l,Interaction.state2		; $7023
	inc (hl)		; $7025
+
	jp interactionAnimate		; $7026

@substate2:
	ld c,$20		; $7029
	call objectUpdateSpeedZ_paramC		; $702b
	ret nz			; $702e
	ld h,d			; $702f
	ld bc,$ff40		; $7030
	jp objectSetSpeedZ		; $7033

_seasonsFunc_09_7036:
	ld a,(wFrameCounter)		; $7036
	and $07			; $7039
	ret nz			; $703b
	call objectGetAngleTowardLink		; $703c
	add $04			; $703f
	and $18			; $7041
	swap a			; $7043
	rlca			; $7045
	ld h,d			; $7046
	ld l,Interaction.var37		; fickleOldManScript_text2
	cp (hl)			; $7049
	ret z			; fickleOldManScript_text3
	ld (hl),a		; $704b
	jp interactionSetAnimation		; $704c

_seasonsFunc_09_704f:
	ld c,$0e		; $704f
	call objectUpdateSpeedZ_paramC		; $7051
	ret nz			; $7054

_seasonsFunc_09_7055:
	ld e,Interaction.speedZ		; $7055
	ld a,$80		; $7057
	ld (de),a		; $7059
	inc e			; $705a
	ld a,$ff		; $705b
	ld (de),a		; $705d
	ret			; $705e


; ==============================================================================
; INTERACID_ANIMAL_MOBLIN_BULLIES
; ==============================================================================
interactionCode73:
	ld h,d			; $705f
	ld l,$42		; $7060
	ldi a,(hl)		; $7062
	or a			; $7063
	jr nz,@func_7078	; $7064
	inc l			; $7066
	ld a,(hl)		; $7067
	or a			; $7068
	jr z,@func_7078	; $7069
	ld a,($cd00)		; $706b
	and $0e			; $706e
	jr z,@func_7078	; $7070
	ld a,$3c		; $7072
	ld (wInstrumentsDisabledCounter),a		; $7074
	ret			; $7077
@func_7078:
	ld e,$44		; $7078
	ld a,($c610)		; $707a
	cp SPECIALOBJECTID_RICKY			; $707d
	or a			; $707f
	jr z,@func_70fd_delete	; $7080
	cp SPECIALOBJECTID_MOOSH			; $7082
	jr z,@moosh	; $7084
	ld a,(de)		; $7086
	rst_jumpTable			; $7087
	; Dimitri
	.dw @state0
	.dw @dimitriState1
	.dw @dimitriState2
@moosh:
	ld a,(de)		; $708e
	rst_jumpTable			; $708f
	.dw @state0
	.dw @mooshState1
@state0:
	ld a,$01		; $7094
	ld (de),a		; $7096
	call interactionInitGraphics		; $7097
	ld hl,$d101		; $709a
	ld a,(wAnimalCompanion)		; $709d
	cp SPECIALOBJECTID_MOOSH			; $70a0
	jr z,@func_70c1	; $70a2
	cp SPECIALOBJECTID_DIMITRI			; $70a4
	jr nz,@func_70fd_delete	; $70a6
	; companion is dimitri
	cp (hl)			; $70a8
	jr nz,@func_70fd_delete	; $70a9
	ld a,(wDimitriState)		; $70ab
	and $88			; $70ae
	jr nz,@func_70fd_delete	; $70b0
	call @func_71ac		; $70b2
	ld hl,@table_71cd		; $70b5
	rst_addDoubleIndex			; $70b8
	ldi a,(hl)		; $70b9
	ld h,(hl)		; $70ba
	ld l,a			; $70bb
	call interactionSetScript		; $70bc
	jr @func_70f3		; $70bf
@func_70c1:
	cp (hl)			; $70c1
	jr nz,@func_70fd_delete	; $70c2
	ld a,(wMooshState)		; $70c4
	bit 5,a			; $70c7
	jr nz,@func_70fd_delete	; $70c9
	bit 7,a			; $70cb
	jr nz,@func_70fd_delete	; $70cd
	bit 2,a			; $70cf
	jr nz,@func_70fd_delete	; $70d1
	and $03			; $70d3
	jr z,+			; $70d5
	ld h,d			; $70d7
	ld l,$42		; $70d8
	ld a,(hl)		; $70da
	or a			; $70db
	jr nz,+			; $70dc
	ld l,$4b		; $70de
	ld (hl),$28		; $70e0
	ld l,$4d		; $70e2
	ld (hl),$a8		; $70e4
+
	call @func_71ac		; $70e6
	ld hl,@table_71d9		; $70e9
	rst_addDoubleIndex			; $70ec
	ldi a,(hl)		; $70ed
	ld h,(hl)		; $70ee
	ld l,a			; $70ef
	call interactionSetScript		; $70f0
@func_70f3:
	call interactionAnimateAsNpc		; $70f3
	call objectCheckWithinScreenBoundary		; $70f6
	ret c			; $70f9
	jp objectSetInvisible		; $70fa
@func_70fd_delete:
	jp interactionDelete		; $70fd
@dimitriState1:
	call interactionAnimateAsNpc		; $7100
	ld e,Interaction.subid		; $7103
	ld a,(de)		; $7105
	and $1f			; $7106
	call z,@func_7183		; $7108
	ld a,(wDimitriState)		; $710b
	and $08			; $710e
	jr nz,@func_7131	; $7110
	ld a,($c4ab)		; $7112
	or a			; $7115
	ret nz			; $7116
	call @func_71c0		; $7117
	ld e,$71		; $711a
	ld a,(de)		; $711c
	or a			; $711d
	jr z,+			; $711e
	call objectGetAngleTowardLink		; $7120
	ld e,$49		; $7123
	ld (de),a		; $7125
	call convertAngleDeToDirection		; $7126
	dec e			; $7129
	ld (de),a		; $712a
	call interactionSetAnimation		; $712b
+
	jp interactionRunScript		; $712e
@func_7131:
	ld a,$01		; $7131
	ld ($cca4),a		; $7133
	ld e,Interaction.state		; $7136
	ld a,$02		; $7138
	ld (de),a		; $713a
	ld e,Interaction.subid		; $713b
	ld a,(de)		; $713d
	ld hl,@table_71d3		; $713e
	rst_addDoubleIndex			; $7141
	ldi a,(hl)		; $7142
	ld h,(hl)		; $7143
	ld l,a			; $7144
	jp interactionSetScript		; $7145
@dimitriState2:
	call @func_71c0		; $7148
	call interactionAnimate		; $714b
	call objectSetPriorityRelativeToLink_withTerrainEffects		; $714e
	call interactionRunScript		; $7151
	ret nc			; $7154
@func_7155:
	jr @func_70fd_delete		; $7155
@mooshState1:
	call interactionAnimate		; $7157
	call objectSetPriorityRelativeToLink_withTerrainEffects		; $715a
	ld a,($c4ab)		; $715d
	or a			; $7160
	ret nz			; $7161
	ld a,(wNumEnemies)		; $7162
	or a			; $7165
	jr z,+			; $7166
	ld a,$01		; $7168
+
	ld e,$7b		; $716a
	ld (de),a		; $716c
	call @func_71c0		; $716d
	call objectCheckWithinScreenBoundary		; $7170
	jr nc,+			; $7173
	call objectSetVisible		; $7175
	jr ++			; $7178
+
	call objectSetInvisible		; $717a
++
	call interactionRunScript		; $717d
	jr c,@func_7155	; $7180
	ret			; $7182
@func_7183:
	xor a			; $7183
	ld e,$78		; $7184
	ld (de),a		; $7186
	inc e			; $7187
	ld (de),a		; $7188
	ld a,RUPEEVAL_030		; $7189
	call cpRupeeValue		; $718b
	jr nz,+			; $718e
	ld e,$78		; $7190
	ld a,$01		; $7192
	ld (de),a		; $7194
	ld a,RUPEEVAL_050		; $7195
	call cpRupeeValue		; $7197
	jr nz,+			; $719a
	ld e,$79		; $719c
	ld a,$01		; $719e
	ld (de),a		; $71a0
+
	ld h,d			; $71a1
	ld l,$7a		; $71a2
	ld a,(hl)		; $71a4
	or a			; $71a5
	ret z			; $71a6
	ld (hl),$00		; $71a7
	jp removeRupeeValue		; $71a9
@func_71ac:
	call interactionSetAlwaysUpdateBit		; $71ac
	ld l,$66		; $71af
	ld a,$06		; $71b1
	ldi (hl),a		; $71b3
	ld a,$06		; $71b4
	ld (hl),a		; $71b6
	ld l,$50		; $71b7
	ld a,$32		; $71b9
	ld (hl),a		; $71bb
	ld e,Interaction.subid		; $71bc
	ld a,(de)		; $71be
	ret			; $71bf
@func_71c0:
	ld c,$40		; $71c0
	call objectUpdateSpeedZ_paramC		; $71c2
	jr z,+			; $71c5
	ld a,$01		; $71c7
+
	ld e,$77		; $71c9
	ld (de),a		; $71cb
	ret			; $71cc
@table_71cd:
	; Dimitri
	.dw moblinBulliesScript_dimitriBully1BeforeSaving
	.dw moblinBulliesScript_dimitriBully2BeforeSaving
	.dw moblinBulliesScript_dimitriBully3BeforeSaving
@table_71d3:
	; Dimitri
	.dw moblinBulliesScript_dimitriBully1AfterSaving
	.dw moblinBulliesScript_dimitriBully2AfterSaving
	.dw moblinBulliesScript_dimitriBully3AfterSaving
@table_71d9:
	.dw moblinBulliesScript_mooshBully1
	.dw moblinBulliesScript_mooshBully2
	.dw moblinBulliesScript_mooshBully3
	.dw moblinBulliesScript_maskedMoblin1MovingUp
	.dw moblinBulliesScript_maskedMoblin2MovingUp
	.dw moblinBulliesScript_maskedMoblinMovingLeft


; pirate ship parts?
interactionCode74:
	ld e,Interaction.subid		; $71e5
	ld a,(de)		; $71e7
	rst_jumpTable			; $71e8
	.dw @subid0
	.dw @subid1
	.dw @subid2
	.dw @subid3
	.dw @subid4
	.dw @subid5
	.dw @subid6
	.dw @subid7
	.dw @subid8
	.dw @subid9
	.dw @subidA
	.dw @subidB
	.dw @subidC
@subid0:
@subid1:
@subid3:
@subid5:
@subid8:
@subid9:
	call @func_7283		; $7203
	jr nz,@func_7218	; $7206
@func_7208:
	ld e,Interaction.state		; $7208
	ld a,$01		; $720a
	ld (de),a		; $720c
	ld a,$57		; $720d
	call loadPaletteHeader		; $720f
	call interactionInitGraphics		; $7212
	jp objectSetVisible80		; $7215
@func_7218:
	ld e,Interaction.subid		; $7218
	ld a,(de)		; $721a
	ld hl,@table_7229		; $721b
	rst_addAToHl			; $721e
	ld a,($cbbf)		; $721f
	add (hl)		; $7222
	ld e,$4b		; $7223
	ld (de),a		; $7225
	jp interactionAnimate		; $7226
@table_7229:
	.db $e8 $58 $00 $e0
	.db $00 $10 $00 $00
	.db $10 $10
@subid2:
	call @func_7283		; $7233
	ret nz			; $7236
	ld a,GLOBALFLAG_PIRATE_SHIP_DOCKED		; $7237
	call checkGlobalFlag		; $7239
	jp nz,interactionDelete		; $723c
	call @func_725b		; $723f
	jr @func_7208		; $7242
@subid4:
@subid7:
	call @func_7283		; $7244
	jp nz,interactionAnimate		; $7247
	ld a,GLOBALFLAG_PIRATE_SHIP_DOCKED		; $724a
	call checkGlobalFlag		; $724c
	jp z,interactionDelete		; $724f
	call @func_7208		; $7252
	ld e,Interaction.subid		; $7255
	ld a,(de)		; $7257
	cp $04			; $7258
	ret nz			; $725a
@func_725b:
	ld bc,$30e8		; $725b
	ld e,$0a		; $725e
	call @func_7268		; $7260
	ld bc,$3018		; $7263
	ld e,$0b		; $7266
@func_7268:
	call getFreeInteractionSlot		; $7268
	ret nz			; $726b
	ld (hl),INTERACID_74		; $726c
	inc l			; $726e
	ld (hl),e		; $726f
	ld e,$4b		; $7270
	ld a,(de)		; $7272
	add b			; $7273
	ld l,e			; $7274
	ld (hl),a		; $7275
	ld e,$4d		; $7276
	ld a,(de)		; $7278
	add c			; $7279
	ld l,e			; $727a
	ld (hl),a		; $727b
	ret			; $727c
@subid6:
@subidA:
@subidB:
	call @func_7283		; $727d
	ret nz			; $7280
	jr @func_7208		; $7281
@func_7283:
	ld e,Interaction.state		; $7283
	ld a,(de)		; $7285
	or a			; $7286
	ret			; $7287
@subidC:
	call @func_7283		; $7288
	jp nz,interactionAnimate		; $728b
	ld a,GLOBALFLAG_MOBLINS_KEEP_DESTROYED		; $728e
	call checkGlobalFlag		; $7290
	jp nz,interactionDelete		; $7293
	jp @func_7208		; $7296


; INTERACID_INTRO_SPRITE?
interactionCode75:
	ld e,Interaction.state		; $7299
	ld a,(de)		; $729b
	rst_jumpTable			; $729c
	.dw @state0
	.dw @state1
@state0:
	call interactionIncState		; $72a1
	call interactionInitGraphics		; $72a4
	ld e,Interaction.subid		; $72a7
	ld a,(de)		; $72a9
	or a			; $72aa
	jr nz,@notSubdId0	; $72ab
	ld hl,script6f48		; $72ad
	call interactionSetScript		; $72b0
	jp objectSetVisible82		; $72b3
@notSubdId0:
	ld h,d			; $72b6
	ld l,$4b		; $72b7
	ld (hl),$70		; $72b9
	inc l			; $72bb
	inc l			; $72bc
	ld (hl),$80		; $72bd
	ld l,$49		; $72bf
	ld (hl),$18		; $72c1
	ld l,$50		; $72c3
	ld (hl),$05		; $72c5
	ld l,$42		; $72c7
	ld a,(hl)		; $72c9
	cp $02			; $72ca
	jp z,objectSetVisible83		; $72cc
	ld l,$46		; $72cf
	ld (hl),$05		; $72d1
	jp objectSetVisible82		; $72d3
@state1:
	ld e,Interaction.subid		; $72d6
	ld a,(de)		; $72d8
	rst_jumpTable			; $72d9
	.dw @subid0
	.dw @subid1
	.dw @subid2
@subid0:
	call interactionRunScript		; $72e0
	jp c,interactionDelete		; $72e3
	call interactionAnimate		; $72e6
	ld h,d			; $72e9
	ld l,$61		; $72ea
	ld a,(hl)		; $72ec
	or a			; $72ed
	ret z			; $72ee
	ld (hl),$00		; $72ef
	dec a			; $72f1
	add $30			; $72f2
	push de			; $72f4
	call loadGfxHeader		; $72f5
	ld a,UNCMP_GFXH_0c		; $72f8
	call loadUncompressedGfxHeader		; $72fa
	pop de			; $72fd
	ret			; $72fe
@subid1:
	call checkInteractionState2		; $72ff
	jr nz,@subid2		; $7302
	call interactionAnimate		; $7304
	ld h,d			; $7307
	ld l,$61		; $7308
	ld a,(hl)		; $730a
	or a			; $730b
	jr z,@subid2			; $730c
	ld (hl),$00		; $730e
	ld l,$46		; $7310
	dec (hl)		; $7312
	jr nz,@subid2		; $7313
	ld l,$45		; $7315
	inc (hl)		; $7317
	ld a,$04		; $7318
	call interactionSetAnimation		; $731a
@subid2:
	ld hl,$cbb6		; $731d
	ld a,(hl)		; $7320
	or a			; $7321
	ret z			; $7322
	jp objectApplySpeed		; $7323


; ==============================================================================
; INTERACID_SUNKEN_CITY_BULLIES
; ==============================================================================
interactionCode76:
	ld e,Interaction.state		; $7326
	ld a,(de)		; $7328
	rst_jumpTable			; $7329
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3
@state0:
	ld a,$01		; $7332
	ld (de),a		; $7334
	ld a,GLOBALFLAG_FINISHEDGAME		; $7335
	call checkGlobalFlag		; $7337
	jp nz,@delete		; $733a
	ld a,(wDimitriState)		; $733d
	and $40			; $7340
	jr z,@func_7375	; $7342
	ld a,$03		; $7344
	ld (de),a		; $7346
	call _func_745b		; $7347
	ld e,Interaction.subid		; $734a
	ld a,(de)		; $734c
	and $1f			; $734d
	ld e,Interaction.subid		; $734f
	ld a,(de)		; $7351
	and $1f			; $7352
	ld c,a			; $7354
	ld hl,_table_748f		; $7355
	rst_addDoubleIndex			; $7358
	ld e,$4b		; $7359
	ldi a,(hl)		; $735b
	ld (de),a		; $735c
	ld e,$4d		; $735d
	ldi a,(hl)		; $735f
	ld (de),a		; $7360
	ld a,c			; $7361
	ld hl,_table_7483		; $7362
	rst_addDoubleIndex			; $7365
	ldi a,(hl)		; $7366
	ld h,(hl)		; $7367
	ld l,a			; $7368
	call interactionSetScript		; $7369
	ld a,c			; $736c
	ld hl,_table_7495		; $736d
	rst_addAToHl			; $7370
	ld a,(hl)		; $7371
	jp interactionSetAnimation		; $7372
@func_7375:
	ld hl,$d101		; $7375
	ld a,(hl)		; $7378
	cp SPECIALOBJECTID_DIMITRI			; $7379
	jr nz,@delete	; $737b
	ld a,($c610)		; $737d
	cp SPECIALOBJECTID_DIMITRI			; $7380
	jr z,@delete	; $7382
	ld a,(wDimitriState)		; $7384
	bit 5,a			; $7387
	jr z,@delete	; $7389
	bit 4,a			; $738b
	jr nz,@delete	; $738d
	call _func_745b		; $738f
	ld e,Interaction.subid		; $7392
	ld a,(de)		; $7394
	and $1f			; $7395
	ld c,a			; $7397
	ld hl,_table_7489		; $7398
	rst_addDoubleIndex			; $739b
	ld e,$4b		; $739c
	ldi a,(hl)		; $739e
	ld (de),a		; $739f
	ld e,$4d		; $73a0
	ldi a,(hl)		; $73a2
	ld (de),a		; $73a3
	ld a,c			; $73a4
	ld hl,_table_7477		; $73a5
	rst_addDoubleIndex			; $73a8
	ldi a,(hl)		; $73a9
	ld h,(hl)		; $73aa
	ld l,a			; $73ab
	call interactionSetScript		; $73ac
	ld e,Interaction.subid		; $73af
	ld a,(de)		; $73b1
	and $1f			; $73b2
	call z,_func_743e		; $73b4
	ld a,$78		; $73b7
	ld ($cc85),a		; $73b9
	ret			; $73bc
@state2:
	ld c,$40		; $73bd
	call objectUpdateSpeedZ_paramC		; $73bf
	jr z,+			; $73c2
	ld a,$01		; $73c4
+
	ld e,$77		; $73c6
	ld (de),a		; $73c8
	call interactionAnimate		; $73c9
	call objectSetPriorityRelativeToLink_withTerrainEffects		; $73cc
	call interactionRunScript		; $73cf
	ld e,$4b		; $73d2
	ld a,(de)		; $73d4
	bit 7,a			; $73d5
	ret z			; $73d7
	ld e,Interaction.subid		; $73d8
	ld a,(de)		; $73da
	and $1f			; $73db
	cp $01			; $73dd
	jr nz,@delete	; $73df
	xor a			; $73e1
	ld ($cba0),a		; $73e2
	ld ($cca4),a		; $73e5
	ld ($cc02),a		; $73e8
@delete:
	jp interactionDelete		; $73eb
@state3:
	ld a,($cd00)		; $73ee
	and $0e			; $73f1
	ret nz			; $73f3
	call interactionAnimateAsNpc		; $73f4
	jr ++			; $73f7
@state1:
	ld a,($cd00)		; $73f9
	and $0e			; $73fc
	ret nz			; $73fe
	call interactionAnimateAsNpc		; $73ff
	ld e,Interaction.subid		; $7402
	ld a,(de)		; $7404
	and $1f			; $7405
	call z,_func_743e		; $7407
	ld a,(wDimitriState)		; $740a
	and $08			; $740d
	jr nz,_func_742a	; $740f
++
	ld a,($c4ab)		; $7411
	or a			; $7414
	ret nz			; $7415
	ld c,$40		; $7416
	call objectUpdateSpeedZ_paramC		; $7418
	jr z,++			; $741b
	ld a,$c0		; $741d
	ld e,$5a		; $741f
	ld (de),a		; $7421
	ld a,$01		; $7422
++
	ld e,$77		; $7424
	ld (de),a		; $7426
	jp interactionRunScript		; $7427
_func_742a:
	ld e,Interaction.state		; $742a
	ld a,$02		; $742c
	ld (de),a		; $742e
	ld e,Interaction.subid		; $742f
	ld a,(de)		; $7431
	and $1f			; $7432
	ld hl,_table_747d		; $7434
	rst_addDoubleIndex			; $7437
	ldi a,(hl)		; $7438
	ld h,(hl)		; $7439
	ld l,a			; $743a
	jp interactionSetScript		; $743b
_func_743e:
	xor a			; $743e
	ld e,$78		; $743f
	ld (de),a		; $7441
	ld hl,wNumBombs		; $7442
	ld a,(hl)		; $7445
	or a			; $7446
	jr z,+			; $7447
	ld a,$01		; $7449
	ld e,$78		; $744b
	ld (de),a		; $744d
+
	ld e,$79		; $744e
	ld a,(de)		; $7450
	or a			; $7451
	ret z			; $7452
	xor a			; $7453
	ld (de),a		; $7454
	xor a			; $7455
	ld (hl),a		; $7456
	call setStatusBarNeedsRefreshBit1		; $7457
	ret			; $745a
_func_745b:
	call interactionInitGraphics		; $745b
	call interactionSetAlwaysUpdateBit		; $745e
	call interactionAnimateAsNpc		; $7461
	ld h,d			; $7464
	ld l,$66		; $7465
	ld a,$06		; $7467
	ldi (hl),a		; $7469
	ld a,$06		; $746a
	ld (hl),a		; $746c
	ld l,$50		; $746d
	ld a,$32		; $746f
	ld (hl),a		; $7471
	ld a,>TX_2100		; $7472
	jp interactionSetHighTextIndex		; $7474
_table_7477:
	.dw sunkenCityBulliesScript1_bully1
	.dw sunkenCityBulliesScript1_bully2
	.dw sunkenCityBulliesScript1_bully3
_table_747d:
	.dw sunkenCityBulliesScript2_bully1
	.dw sunkenCityBulliesScript2_bully2
	.dw sunkenCityBulliesScript2_bully3
_table_7483:
	.dw sunkenCityBulliesScript3_bully1
	.dw sunkenCityBulliesScript3_bully2
	.dw sunkenCityBulliesScript3_bully3
_table_7489:
	.db $38 $58
	.db $38 $68
	.db $28 $48
_table_748f:
	.db $38 $48
	.db $38 $58
	.db $58 $48
_table_7495:
	; animation
	.db $02 $02 $00


; Called by temple sinking cutscene
interactionCode77:
	ld e,Interaction.state		; $7498
	ld a,(de)		; $749a
	rst_jumpTable			; $749b
	.dw @state0
	.dw @state1
@state0:
	ld a,$01		; $74a0
	ld (de),a		; $74a2
	call interactionInitGraphics		; $74a3
	ld e,Interaction.subid		; $74a6
	ld a,(de)		; $74a8
	call interactionSetAnimation		; $74a9
	ld e,Interaction.subid		; $74ac
	ld a,(de)		; $74ae
	or a			; $74af
	jp z,objectSetVisible82		; $74b0
	jp objectSetVisible83		; $74b3
@state1:
	ld hl,$cfd3		; $74b6
	ld a,(hl)		; $74b9
	and $80			; $74ba
	jp nz,objectSetInvisible		; $74bc
	call objectSetVisible		; $74bf
	ld e,Interaction.subid		; $74c2
	ld a,(de)		; $74c4
	or a			; $74c5
	jr nz,@func_74dd	; $74c6
	ld a,($c486)		; $74c8
	ld b,a			; $74cb
	ld a,$7d		; $74cc
	sub b			; $74ce
	ld e,$4b		; $74cf
	ld (de),a		; $74d1
	ld a,($c487)		; $74d2
	ld b,a			; $74d5
	ld a,$54		; $74d6
	sub b			; $74d8
	ld e,$4d		; $74d9
	ld (de),a		; $74db
	ret			; $74dc
@func_74dd:
	ld a,($c488)		; $74dd
	ld b,a			; $74e0
	ld a,$e9		; $74e1
	add b			; $74e3
	ld e,$4b		; $74e4
	ld (de),a		; $74e6
	ld a,($c489)		; $74e7
	ld b,a			; $74ea
	ld a,$19		; $74eb
	add b			; $74ed
	ld e,$4d		; $74ee
	ld (de),a		; $74f0
	ret			; $74f1


; ==============================================================================
; INTERACID_MAGNET_SPINNER
; ==============================================================================
interactionCode7b:
	ld h,d			; $74f2
	ld l,$46		; $74f3
	ld a,(hl)		; $74f5
	or a			; $74f6
	jr z,+			; $74f7
	dec (hl)		; $74f9
	jr z,+			; $74fa
	ld a,d			; $74fc
	ld ($ccb0),a		; $74fd
+
	ld e,Interaction.state		; $7500
	ld a,(de)		; $7502
	rst_jumpTable			; $7503
	.dw @state0
	.dw @state1
	.dw @state2
@state0:
	ld a,$01		; $750a
	ld (de),a		; $750c
	call interactionInitGraphics		; $750d
	ld a,$07		; $7510
	call objectSetCollideRadius		; $7512
	jp objectSetVisible82		; $7515
@state1:
	call objectGetTileAtPosition		; $7518
	ld (hl),$3f		; $751b
	call _func_75e7		; $751d
	call nc,interactionAnimate		; $7520
	call objectPreventLinkFromPassing		; $7523
	ret nc			; $7526
	ld a,(wMagnetGloveState)		; $7527
	or a			; $752a
	jr z,@func_754e	; $752b
	ld e,$61		; $752d
	ld a,(de)		; $752f
	or a			; $7530
	ret nz			; $7531
	ld c,$18		; $7532
	call objectCheckLinkWithinDistance		; $7534
	srl a			; $7537
	ld e,$48		; $7539
	ld (de),a		; $753b
	ld b,a			; $753c
	ld a,($d008)		; $753d
	xor $02			; $7540
	cp b			; $7542
	ret nz			; $7543
	call _func_75e7		; $7544
	ret c			; $7547
	call interactionIncState		; $7548
	jp _func_75e1		; $754b
@func_754e:
	ld a,($ccb0)		; $754e
	or a			; $7551
	ret nz			; $7552
	ld c,$18		; $7553
	call objectCheckLinkWithinDistance		; $7555
	srl a			; $7558
	ret nz			; $755a
	ld a,($ccb4)		; $755b
	cp $3f			; $755e
	ret nz			; $7560
	ld a,($d004)		; $7561
	cp $01			; $7564
	ret nz			; $7566
	ld a,$02		; $7567
	ld ($cc6a),a		; $7569
	xor a			; $756c
	ld ($cc6c),a		; $756d
	ret			; $7570
@state2:
	call _func_75e1		; $7571
	call interactionAnimate		; $7574
	ld a,($cc79)		; $7577
	or a			; $757a
	jr z,@func_75bb	; $757b
	bit 1,a			; $757d
	jr z,@func_75bb	; $757f
	ld e,$61		; $7581
	ld a,(de)		; $7583
	cp $ff			; $7584
	jr z,@func_75a7	; $7586
	add a			; $7588
	ld c,a			; $7589
	ld e,$48		; $758a
	ld a,(de)		; $758c
@func_758d:
	swap a			; $758d
	rrca			; $758f
	ld hl,@table_75c1		; $7590
	rst_addAToHl			; $7593
	ld b,$00		; $7594
	add hl,bc		; $7596
	ld e,$4b		; $7597
	ld a,(de)		; $7599
	add (hl)		; $759a
	ld ($d00b),a		; $759b
	inc hl			; $759e
	ld e,$4d		; $759f
	ld a,(de)		; $75a1
	add (hl)		; $75a2
	ld ($d00d),a		; $75a3
	ret			; $75a6
@func_75a7:
	ld e,$48		; $75a7
	ld a,(de)		; $75a9
	inc a			; $75aa
	and $03			; $75ab
	ldh (<hFF8B),a	; $75ad
	ld c,$00		; $75af
	call @func_758d		; $75b1
	ldh a,(<hFF8B)	; $75b4
	xor $02			; $75b6
	ld ($d008),a		; $75b8
@func_75bb:
	ld e,Interaction.state		; $75bb
	ld a,$01		; $75bd
	ld (de),a		; $75bf
	ret			; $75c0
@table_75c1:
	.db $f0 $00 $f4 $04 $f8 $08 $fc $0c
	.db $00 $10 $04 $0c $08 $08 $0c $04
	.db $10 $00 $0c $fc $08 $f8 $04 $f4
	.db $00 $f0 $fc $f4 $f8 $f8 $f4 $fc
_func_75e1:
	ld e,$46		; $75e1
	ld a,$14		; $75e3
	ld (de),a		; $75e5
	ret			; $75e6
_func_75e7:
	ld e,Interaction.subid		; $75e7
	ld a,(de)		; $75e9
	ld b,a			; $75ea
	and $80			; $75eb
	ret z			; $75ed
	ld a,b			; $75ee
	and $07			; $75ef
	ld hl,wToggleBlocksState		; $75f1
	call checkFlag		; $75f4
	ret nz			; $75f7
	scf			; $75f8
	ret			; $75f9


; ==============================================================================
; INTERACID_TRAMPOLINE
; ==============================================================================
interactionCode7c:
	call objectSetPriorityRelativeToLink		; $75fa
	ld e,Interaction.state		; $75fd
	ld a,(de)		; $75ff
	rst_jumpTable			; $7600
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3
	.dw @state4
@state0:
	ld a,$01		; $760b
	ld (de),a		; $760d
	call interactionInitGraphics		; $760e
	ld a,$07		; $7611
	call objectSetCollideRadius		; $7613
	ld a,$14		; $7616
	ld l,$50		; $7618
	ld (hl),a		; $761a
	jp objectSetVisible82		; $761b
@state1:
	call returnIfScrollMode01Unset		; $761e
	ld e,Interaction.state		; $7621
	ld a,$02		; $7623
	ld (de),a		; $7625
	jp _func_76d4		; $7626
@state2:
	ld a,($d00f)		; $7629
	or a			; $762c
	jr nz,@func_7677	; $762d
	xor a			; $762f
	ld e,$70		; $7630
	ld (de),a		; $7632
	ld a,$07		; $7633
	call objectSetCollideRadius		; $7635
	call objectPreventLinkFromPassing		; $7638
	jr nc,@func_7671	; $763b
	call objectCheckLinkPushingAgainstCenter		; $763d
	jr nc,@func_7671	; $7640
	ld a,$01		; $7642
	ld (wForceLinkPushAnimation),a		; $7644
	call interactionDecCounter1		; $7647
	ret nz			; $764a
	ld c,$28		; $764b
	call objectCheckLinkWithinDistance		; $764d
	ld e,$48		; $7650
	xor $04			; $7652
	ld (de),a		; $7654
	call interactionCheckAdjacentTileIsSolid_viaDirection		; $7655
	ret nz			; $7658
	ld h,d			; $7659
	ld l,$48		; $765a
	ld a,(hl)		; $765c
	add a			; $765d
	add a			; $765e
	ld l,$49		; $765f
	ld (hl),a		; $7661
	ld l,$46		; $7662
	ld (hl),$20		; $7664
	ld l,$44		; $7666
	inc (hl)		; $7668
	call _func_76e0		; $7669
	ld a,$71		; $766c
	jp playSound		; $766e
@func_7671:
	ld e,$46		; $7671
	ld a,$1e		; $7673
	ld (de),a		; $7675
	ret			; $7676
@func_7677:
	ld a,$0a		; $7677
	call objectSetCollideRadius		; $7679
	ld a,($d00b)		; $767c
	ld b,a			; $767f
	ld a,($d00d)		; $7680
	ld c,a			; $7683
	call interactionCheckContainsPoint		; $7684
	ret nc			; $7687
	ld a,($d00f)		; $7688
	ld b,a			; $768b
	cp $e8			; $768c
	jr nc,+			; $768e
	ld e,$70		; $7690
	ld (de),a		; $7692
+
	ld a,b			; $7693
	cp $fc			; $7694
	ret c			; $7696
	ld e,$70		; $7697
	ld a,(de)		; $7699
	or a			; $769a
	jr nz,+			; $769b
	callab scriptHlp.trampoline_bounce
+
	ld e,Interaction.state		; $76a5
	ld a,$04		; $76a7
	ld (de),a		; $76a9
	xor a			; $76aa
	call interactionSetAnimation		; $76ab
	ld a,$53		; $76ae
	jp playSound		; $76b0
@state3:
	call objectApplySpeed		; $76b3
	call objectPreventLinkFromPassing		; $76b6
	call interactionDecCounter1		; $76b9
	ret nz			; $76bc
	ld l,$44		; $76bd
	dec (hl)		; $76bf
	ld l,$46		; $76c0
	ld (hl),$1e		; $76c2
	jr _func_76d4		; $76c4
@state4:
	call interactionAnimate		; $76c6
	ld e,$61		; $76c9
	ld a,(de)		; $76cb
	inc a			; $76cc
	ret nz			; $76cd
	ld e,Interaction.state		; $76ce
	ld a,$02		; $76d0
	ld (de),a		; $76d2
	ret			; $76d3
_func_76d4:
	call objectGetTileAtPosition		; $76d4
	ld e,$71		; $76d7
	ld (de),a		; $76d9
	ld (hl),$07		; $76da
	dec h			; $76dc
	ld (hl),$14		; $76dd
	ret			; $76df
_func_76e0:
	call objectGetTileAtPosition		; $76e0
	ld e,$71		; $76e3
	ld a,(de)		; $76e5
	ld (hl),a		; $76e6
	dec h			; $76e7
	ld (hl),$00		; $76e8
	ret			; $76ea


; ==============================================================================
; INTERACID_FICKLE_OLD_MAN
; ==============================================================================
interactionCode80:
	call checkInteractionState		; $76eb
	jr nz,@state1	; $76ee
	ld a,$01		; $76f0
	ld (de),a		; $76f2
	call interactionInitGraphics		; $76f3
	ld b,$07		; $76f6
	call checkIfHoronVillageNPCShouldBeSeen		; $76f8
	ld a,c			; $76fb
	or a			; $76fc
	jp z,interactionDelete		; $76fd
	ld e,Interaction.subid		; $7700
	ld a,b			; $7702
	ld (de),a		; $7703
	ld hl,@table_7717		; $7704
	rst_addDoubleIndex			; $7707
	ldi a,(hl)		; $7708
	ld h,(hl)		; $7709
	ld l,a			; $770a
	call interactionSetScript		; $770b
	jp objectSetVisible82		; $770e
@state1:
	call interactionRunScript		; $7711
	jp interactionAnimateAsNpc		; $7714
@table_7717:
	.dw fickleOldManScript_text1
	.dw fickleOldManScript_text1
	.dw fickleOldManScript_text2
	.dw fickleOldManScript_text2
	.dw fickleOldManScript_text3
	.dw fickleOldManScript_text4
	.dw fickleOldManScript_text4
	.dw fickleOldManScript_text4
	.dw fickleOldManScript_text5
	.dw fickleOldManScript_text2
	.dw fickleOldManScript_text6


; ==============================================================================
; INTERACID_SUBROSIAN_SHOP
; Variables:
;   var37 - wram variable to check for number of 2nd currency
;   var38 - number of 2nd currency required
;   var39 - ore chunk cost
; ==============================================================================
interactionCode81:
	ld e,Interaction.state		; $772d
	ld a,(de)		; $772f
	rst_jumpTable			; $7730
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3
@state0:
	ld a,$01		; $7739
	ld (de),a		; $773b
	ld e,$40		; $773c
	ld a,(de)		; $773e
	or $80			; $773f
	ld (de),a		; $7741
@func_7742:
	ld e,Interaction.subid		; $7742
	ld a,(de)		; $7744
	cp $0a			; $7745
	jr z,@shield	; $7747
	cp $0d			; $7749
	jr nz,@func_7770	; $774b
	; member's card
	ld a,(wEssencesObtained)		; $774d
	bit 2,a			; $7750
	jr z,@func_776b	; $7752
	ld a,TREASURE_MEMBERS_CARD		; $7754
	call checkTreasureObtained		; $7756
	jr c,@func_776b	; $7759
	jr @func_7770		; $775b
@shield:
	ld a,(wShieldLevel)		; $775d
	cp $02			; $7760
	jr nc,@func_776b	; $7762
	ld a,TREASURE_SHIELD		; $7764
	call checkTreasureObtained		; $7766
	jr nc,@func_7770	; $7769
@func_776b:
	ld a,(de)		; $776b
	inc a			; $776c
	ld (de),a		; $776d
	jr @func_7770		; $776e
@func_7770:
	ld a,(de)		; $7770
	add a			; $7771
	ld hl,@table_779e		; $7772
	rst_addDoubleIndex			; $7775
	ld a,(wBoughtSubrosianShopItems)		; $7776
	and (hl)		; $7779
	jr nz,@func_7799	; $777a
	inc hl			; $777c
	ld e,$77		; $777d
	ld b,$03		; $777f
-
	ldi a,(hl)		; $7781
	ld (de),a		; $7782
	inc e			; $7783
	dec b			; $7784
	jr nz,-			; $7785
	call interactionInitGraphics		; $7787
	ld e,$66		; $778a
	ld a,$06		; $778c
	ld (de),a		; $778e
	inc e			; $778f
	ld (de),a		; $7790
	ld e,$71		; $7791
	call objectAddToAButtonSensitiveObjectList		; $7793
	jp objectSetVisible82		; $7796
@func_7799:
	; already bought item
	ld a,(de)		; $7799
	inc a			; $779a
	ld (de),a		; $779b
	jr @func_7742		; $779c
@table_779e:
	; Byte 0: wBoughtSubrosianShopItems flag it sets
	; Byte 1: variable to check for other currency
	; Byte 2: number of other currency required
	; Byte 3: ore chunk cost
	.db $01, $00,             $00, $00
	.db $04, <wNumBombs,      $10, RUPEEVAL_050
	.db $08, <wNumScentSeeds, $20, RUPEEVAL_040
	.db $00, <wNumScentSeeds, $20, RUPEEVAL_100
	.db $02, <wNumEmberSeeds, $10, RUPEEVAL_020
	.db $10, $00,             $00, RUPEEVAL_030
	.db $20, $00,             $00, RUPEEVAL_040
	.db $40, $00,             $00, RUPEEVAL_050
	.db $80, $00,             $00, RUPEEVAL_070
	.db $00, $00,             $00, RUPEEVAL_005
	.db $00, <wNumEmberSeeds, $05, $00
	.db $00, $00,             $00, RUPEEVAL_025
	.db $00, $00,             $00, RUPEEVAL_010
	.db $00, $00,             $00, RUPEEVAL_005
	.db $00, <wNumGaleSeeds,  $20, $00
@table_77da:
	.db TREASURE_RIBBON,        $00
	.db TREASURE_BOMBS,         $10
	.db TREASURE_GASHA_SEED,    $01
	.db TREASURE_GASHA_SEED,    $01
	.db TREASURE_HEART_PIECE,   $01
	.db TREASURE_RING,          $03
	.db TREASURE_RING,          $03
	.db TREASURE_RING,          $03
	.db TREASURE_RING,          $02
	.db TREASURE_EMBER_SEEDS,   $04
	.db TREASURE_SHIELD,        $01
	.db TREASURE_PEGASUS_SEEDS, $10
	.db TREASURE_HEART_REFILL,  $0c
	.db TREASURE_MEMBERS_CARD,  $10
	.db TREASURE_ORE_CHUNKS,    $04
@state1:
	call interactionAnimateAsNpc		; $77f8
	ld e,$71		; $77fb
	ld a,(de)		; $77fd
	or a			; $77fe
	ret z			; $77ff
	xor a			; $7800
	ld (de),a		; $7801
	ld e,$7d		; $7802
	ld (de),a		; $7804
	call _func_7931		; $7805
	ld e,Interaction.state		; $7808
	ld a,$02		; $780a
	ld (de),a		; $780c
	ld e,Interaction.subid		; $780d
	ld a,(de)		; $780f
	ld hl,_table_7994		; $7810
	rst_addDoubleIndex			; $7813
	ldi a,(hl)		; $7814
	ld h,(hl)		; $7815
	ld l,a			; $7816
	jp interactionSetScript		; $7817
@state2:
	call interactionAnimateAsNpc		; $781a
	call interactionRunScript		; $781d
	ret nc			; $7820
	ld e,$7d		; $7821
	ld a,(de)		; $7823
	bit 7,a			; $7824
	ld e,Interaction.state		; $7826
	ld a,$01		; $7828
	ld (de),a		; $782a
	ret nz			; $782b
	ld a,$03		; $782c
	ld (de),a		; $782e
	inc e			; $782f
	xor a			; $7830
	ld (de),a		; $7831
	ld a,$80		; $7832
	ld ($cc02),a		; $7834
	ret			; $7837
@state3:
	ld e,Interaction.state2		; $7838
	ld a,(de)		; $783a
	rst_jumpTable			; $783b
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3
	.dw @substate4
@substate0:
	call objectSetVisible80		; $7846
	ld a,($ccea)		; $7849
	dec a			; $784c
	ld ($ccea),a		; $784d
	call _func_7973		; $7850
	ld a,$04		; $7853
	ld ($cc6a),a		; $7855
	ld a,$01		; $7858
	ld ($cc6b),a		; $785a
	ld h,d			; $785d
	ld l,$4b		; $785e
	ld a,($d00b)		; $7860
	sub $0e			; $7863
	ld (hl),a		; $7865
	ld l,$4d		; $7866
	ld a,($d00d)		; $7868
	ld (hl),a		; $786b
	ld l,$46		; $786c
	ld a,$80		; $786e
	ldi (hl),a		; $7870
	ld (hl),$04		; $7871
	ld l,$45		; $7873
	ld a,$01		; $7875
	ld (hl),a		; $7877
	ld hl,$cbea		; $7878
	set 2,(hl)		; $787b
	ld e,Interaction.subid		; $787d
	ld a,(de)		; $787f
	cp $01			; $7880
	jr z,@func_78ac	; $7882
	ld hl,@table_77da		; $7884
	rst_addDoubleIndex			; $7887
	ldi a,(hl)		; $7888
	ld c,(hl)		; $7889
	cp $2d			; $788a
	jr nz,+			; $788c
	call getRandomRingOfGivenTier		; $788e
+
	call giveTreasure		; $7891
	ld e,Interaction.subid		; $7894
	ld a,(de)		; $7896
	ld hl,@table_78b1		; $7897
	rst_addAToHl			; $789a
	ld c,(hl)		; $789b
	ld b,$00		; $789c
	call showText		; $789e
	ld e,Interaction.subid		; $78a1
	ld a,(de)		; $78a3
	cp $04			; $78a4
	ret z			; $78a6
	ld a,$4c		; $78a7
	jp playSound		; $78a9
@func_78ac:
	ld h,d			; $78ac
	ld l,$45		; $78ad
	inc (hl)		; $78af
	ret			; $78b0
@table_78b1:
	.db <TX_0041 ; Ribbon
	.db <TX_0000 ; this table not used for bomb upgrade
	.db <TX_004b ; Gasha seed
	.db <TX_004b ; Gasha seed
	.db <TX_0017 ; Piece of heart
	.db <TX_0054 ; Ring
	.db <TX_0054 ; Ring
	.db <TX_0054 ; Ring
	.db <TX_0054 ; Ring
	.db <TX_004f ; 4 ember seeds
	.db <TX_001f ; Shield
	.db <TX_0050 ; 10 pegasus seeds
	.db <TX_004c ; 3 hearts
	.db <TX_0045 ; Member's card
	.db <TX_004e ; 10 ore chunks
@substate1:
	call retIfTextIsActive		; $78c0
	xor a			; $78c3
	ld ($cca4),a		; $78c4
	ld ($cc02),a		; $78c7
	jp interactionDelete		; $78ca
@substate2:
	call interactionDecCounter1		; $78cd
	jr z,+			; $78d0
	inc l			; $78d2
	dec (hl)		; $78d3
	ret nz			; $78d4
	ld (hl),$04		; $78d5
	ld a,$01		; $78d7
	ld l,$5c		; $78d9
	xor (hl)		; $78db
	ld (hl),a		; $78dc
	ret			; $78dd
+
	ld l,$5b		; $78de
	ld a,$0a		; $78e0
	ldi (hl),a		; $78e2
	ldi (hl),a		; $78e3
	ld (hl),$0c		; $78e4
	ld l,$45		; $78e6
	ld (hl),$03		; $78e8
	ld l,$47		; $78ea
	ld (hl),$1e		; $78ec
	ld a,$08		; $78ee
	call interactionSetAnimation		; $78f0
	ld a,$bc		; $78f3
	call playSound		; $78f5
	jp fadeoutToWhite		; $78f8
@substate3:
	call interactionAnimate		; $78fb
	ld a,($c4ab)		; $78fe
	or a			; $7901
	ret nz			; $7902
	call interactionDecCounter2		; $7903
	ret nz			; $7906
	ld l,$5a		; $7907
	ld (hl),a		; $7909
	ld l,$45		; $790a
	ld (hl),$04		; $790c
	ld hl,$c6ab		; $790e
	ld a,(hl)		; $7911
	add $20			; $7912
	ldd (hl),a		; $7914
	ld (hl),a		; $7915
	call setStatusBarNeedsRefreshBit1		; $7916
	jp fadeinFromWhite		; $7919
@substate4:
	ld a,($c4ab)		; $791c
	or a			; $791f
	ret nz			; $7920
	xor a			; $7921
	ld ($cca4),a		; $7922
	ld ($cc02),a		; $7925
	ld bc,TX_2b0e		; $7928
	call showText		; $792b
	jp interactionDelete		; $792e
	
_func_7931:
	ld e,$7b		; $7931
	xor a			; $7933
	ld (de),a		; $7934
	ld e,Interaction.subid		; $7935
	ld a,(de)		; $7937
	or a			; $7938
	jr z,_buyingRibbon	; $7939
	ld e,$77		; $793b
	ld a,(de)		; $793d
	or a			; $793e
	jr z,+			; $793f
	ld l,a			; $7941
	ld h,$c6		; $7942
	inc e			; $7944
	ld a,(de)		; $7945
	ld b,a			; $7946
	ld a,(hl)		; $7947
	cp b			; $7948
	jr c,++			; $7949
+
	ld e,$7b		; $794b
	ld a,$01		; $794d
	ld (de),a		; $794f
++
	ld e,$79		; $7950
	ld a,(de)		; $7952
	call cpOreChunkValue		; $7953
	ld hl,$cba8		; $7956
	ld (hl),c		; $7959
	inc l			; $795a
	ld (hl),b		; $795b
	ld e,$7b		; $795c
	xor $01			; $795e
	jr z,+			; $7960
	ld c,a			; $7962
	ld a,(de)		; $7963
	and c			; $7964
+
	ld (de),a		; $7965
	ret			; $7966

_buyingRibbon:
	ld a,TREASURE_STAR_ORE		; $7967
	call checkTreasureObtained		; $7969
	ret nc			; $796c
	ld e,$7b		; $796d
	ld a,$01		; $796f
	ld (de),a		; $7971
	ret			; $7972

_func_7973:
	ld e,Interaction.subid		; $7973
	ld a,(de)		; $7975
	or a			; $7976
	ret z			; $7977
	ld a,$ff		; $7978
	ld ($cbea),a		; $797a
	ld e,$77		; $797d
	ld a,(de)		; $797f
	or a			; $7980
	jr z,+			; $7981
	ld l,a			; $7983
	ld h,$c6		; $7984
	inc e			; $7986
	ld a,(de)		; $7987
	ld c,a			; $7988
	ld a,(hl)		; $7989
	sub c			; $798a
	daa			; $798b
	ld (hl),a		; $798c
+
	ld e,$79		; $798d
	ld a,(de)		; $798f
	ld c,a			; $7990
	jp removeOreChunkValue		; $7991
	
_table_7994:
	.dw subrosianShopScript_ribbon
	.dw subrosianShopScript_bombUpgrade
	.dw subrosianShopScript_gashaSeed
	.dw subrosianShopScript_gashaSeed
	.dw subrosianShopScript_pieceOfHeart
	.dw subrosianShopScript_ring1
	.dw subrosianShopScript_ring2
	.dw subrosianShopScript_ring3
	.dw subrosianShopScript_ring4
	.dw subrosianShopScript_emberSeeds
	.dw subrosianShopScript_shield
	.dw subrosianShopScript_pegasusSeeds
	.dw subrosianShopScript_heartRefill
	.dw subrosianShopScript_membersCard
	.dw subrosianShopScript_oreChunks


; ==============================================================================
; INTERACID_DOG_PLAYING_WITH_BOY
; ==============================================================================
interactionCode82:
	call checkInteractionState		; $79b2
	jr nz,@state1	; $79b5
	ld a,$01		; $79b7
	ld (de),a		; $79b9
	ld h,d			; $79ba
	ld l,$4e		; $79bb
	xor a			; $79bd
	ldi (hl),a		; $79be
	ld (hl),a		; $79bf
	call _func_7a99		; $79c0
	ld l,$46		; $79c3
	ld (hl),$5a		; $79c5
	call interactionInitGraphics		; $79c7
	jp objectSetVisible82		; $79ca
@state1:
	ld e,Interaction.state2		; $79cd
	ld a,(de)		; $79cf
	rst_jumpTable			; $79d0
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3
	.dw @substate4
	.dw @substate5
@substate0:
	call @func_7a09		; $79dd
	call objectGetRelatedObject1Var		; $79e0
	ld l,$4d		; $79e3
	ld a,(hl)		; $79e5
	add $08			; $79e6
	ld b,a			; $79e8
	ld e,l			; $79e9
	ld a,(de)		; $79ea
	cp b			; $79eb
	jr c,@func_79fc	; $79ec
	call interactionIncState2		; $79ee
	ld l,$46		; $79f1
	ld (hl),$14		; $79f3
	ld a,$06		; $79f5
	call interactionSetAnimation		; $79f7
	jr @func_7a06		; $79fa
@func_79fc:
	ld e,$46		; $79fc
	ld a,(de)		; $79fe
	or a			; $79ff
	jp z,_func_7a93		; $7a00
	jp interactionDecCounter1		; $7a03
@func_7a06:
	call _func_7a93		; $7a06
@func_7a09:
	call interactionAnimate		; $7a09
	jp objectSetPriorityRelativeToLink_withTerrainEffects		; $7a0c
@substate1:
	call @func_7a06		; $7a0f
	call interactionDecCounter1		; $7a12
	ret nz			; $7a15
	ld l,$49		; $7a16
	ld (hl),$18		; $7a18
	ld l,$50		; $7a1a
	ld (hl),$28		; $7a1c
	jp interactionIncState2		; $7a1e
@substate2:
	call @func_7a06		; $7a21
	call objectGetRelatedObject1Var		; $7a24
	ld l,$4d		; $7a27
	ld a,(hl)		; $7a29
	add $04			; $7a2a
	call _func_7a9f		; $7a2c
	jp nz,objectApplySpeed		; $7a2f
	call interactionIncState2		; $7a32
	ld l,$46		; $7a35
	ld (hl),$0c		; $7a37
	ld l,$4e		; $7a39
	xor a			; $7a3b
	ldi (hl),a		; $7a3c
	ld (hl),a		; $7a3d
	jp _func_7aa5		; $7a3e
@substate3:
	call @func_7a09		; $7a41
	call interactionDecCounter1		; $7a44
	jp z,@func_7a4f		; $7a47
	call objectApplySpeed		; $7a4a
	jr ++		; $7a4d
@func_7a4f:
	call interactionIncState2		; $7a4f
	ld l,$46		; $7a52
	ld (hl),$1e		; $7a54
	ld l,$49		; $7a56
	ld (hl),$08		; $7a58
	ld a,$05		; $7a5a
	call interactionSetAnimation		; $7a5c
++
	jp _func_7aa5		; $7a5f
@substate4:
	call @func_7a09		; $7a62
	call _func_7aa5		; $7a65
	call interactionDecCounter1		; $7a68
	ret nz			; $7a6b
	jp interactionIncState2		; $7a6c
@substate5:
	call @func_7a06		; $7a6f
	call _func_7aa5		; $7a72
	call objectApplySpeed		; $7a75
	ld e,$76		; $7a78
	ld a,(de)		; $7a7a
	call _func_7a9f		; $7a7b
	ret nz			; $7a7e
	ld hl,$cceb		; $7a7f
	ld (hl),$02		; $7a82
	ld h,d			; $7a84
	ld l,$45		; $7a85
	ld (hl),$00		; $7a87
	ld l,$4e		; $7a89
	xor a			; $7a8b
	ldi (hl),a		; $7a8c
	ld (hl),a		; $7a8d
	ld l,$46		; $7a8e
	ld (hl),$3c		; $7a90
	ret			; $7a92
_func_7a93:
	ld c,$20		; $7a93
	call objectUpdateSpeedZ_paramC		; $7a95
	ret nz			; $7a98
_func_7a99:
	ld bc,$ff40		; $7a99
	jp objectSetSpeedZ		; $7a9c
_func_7a9f:
	ld b,a			; $7a9f
	ld e,$4d		; $7aa0
	ld a,(de)		; $7aa2
	cp b			; $7aa3
	ret			; $7aa4
_func_7aa5:
	ld a,$40		; $7aa5
	call objectGetRelatedObject1Var		; $7aa7
	ld e,$49		; $7aaa
	ld a,(de)		; $7aac
	cp $18			; $7aad
	ld c,$07		; $7aaf
	jr nz,+			; $7ab1
	ld c,$fb		; $7ab3
+
	ld b,$fe		; $7ab5
	jp objectCopyPositionWithOffset		; $7ab7


; ==============================================================================
; INTERACID_BALL_THROWN_TO_DOG
; ==============================================================================
interactionCode83:
	call checkInteractionState		; $7aba
	jr nz,@state1	; $7abd
	ld a,$01		; $7abf
	ld (de),a		; $7ac1
	ld h,d			; $7ac2
	call @func_7aea		; $7ac3
	ld l,$50		; $7ac6
	ld (hl),$3c		; $7ac8
	ld l,$49		; $7aca
	ld (hl),$18		; $7acc
	call getFreeInteractionSlot		; $7ace
	jr nz,+			; $7ad1
	ld (hl),INTERACID_DOG_PLAYING_WITH_BOY		; $7ad3
	ld l,$57		; $7ad5
	ld (hl),d		; $7ad7
	ld bc,$00f4		; $7ad8
	call objectCopyPositionWithOffset		; $7adb
	ld l,$4d		; $7ade
	ld a,(hl)		; $7ae0
	ld l,$76		; $7ae1
	ld (hl),a		; $7ae3
+
	call interactionInitGraphics		; $7ae4
	jp objectSetVisible82		; $7ae7
@func_7aea:
	ld l,$4e		; $7aea
	ld (hl),$ff		; $7aec
	inc l			; $7aee
	ld (hl),$fc		; $7aef
	ret			; $7af1
@state1:
	call objectSetPriorityRelativeToLink_withTerrainEffects		; $7af2
	ld h,d			; $7af5
	ld l,$5a		; $7af6
	res 6,(hl)		; $7af8
	ld e,Interaction.state2		; $7afa
	ld a,(de)		; $7afc
	rst_jumpTable			; $7afd
	.dw @@susbtate0
	.dw @@susbtate1
	.dw @@susbtate2
@@susbtate0:
	ld a,($cceb)		; $7b04
	cp $01			; $7b07
	ret nz			; $7b09
	call getRandomNumber_noPreserveVars		; $7b0a
	and $03			; $7b0d
	ld hl,_table_7b59		; $7b0f
	rst_addDoubleIndex			; $7b12
	ldi a,(hl)		; $7b13
	ld e,$54		; $7b14
	ld (de),a		; $7b16
	ld a,(hl)		; $7b17
	inc e			; $7b18
	ld (de),a		; $7b19
	jp interactionIncState2		; $7b1a
@@susbtate1:
	ld c,$20		; $7b1d
	call objectUpdateSpeedZ_paramC		; $7b1f
	jp nz,objectApplySpeed		; $7b22
	ld l,$55		; $7b25
	ldd a,(hl)		; $7b27
	srl a			; $7b28
	ld b,a			; $7b2a
	ld a,(hl)		; $7b2b
	rra			; $7b2c
	cpl			; $7b2d
	add $01			; $7b2e
	ldi (hl),a		; $7b30
	ld a,b			; $7b31
	cpl			; $7b32
	adc $00			; $7b33
	ldd (hl),a		; $7b35
	ld bc,$ffa0		; $7b36
	ldi a,(hl)		; $7b39
	ld h,(hl)		; $7b3a
	ld l,a			; $7b3b
	call compareHlToBc		; $7b3c
	ret c			; $7b3f
	jp interactionIncState2		; $7b40
@@susbtate2:
	ld a,($cceb)		; $7b43
	cp $02			; $7b46
	ret nz			; $7b48
	xor a			; $7b49
	ld (de),a		; $7b4a
	ld h,d			; $7b4b
	ld l,$76		; $7b4c
	ld e,$4b		; $7b4e
	ldi a,(hl)		; $7b50
	ld (de),a		; $7b51
	inc e			; $7b52
	inc e			; $7b53
	ld a,(hl)		; $7b54
	ld (de),a		; $7b55
	jp @func_7aea		; $7b56
_table_7b59:
	; speedZ
	.dw $fee0
	.dw $fe80
	.dw $fe20
	.dw $fdc0


; ==============================================================================
; INTERACID_SPARKLE
; ==============================================================================
interactionCode84:
	call checkInteractionState		; $7b61
	jr nz,@state1	; $7b64

	call interactionInitGraphics		; $7b66
	call interactionSetAlwaysUpdateBit		; $7b69
	ld l,$44		; $7b6c
	inc (hl)		; $7b6e
	ld e,Interaction.subid		; $7b6f
	ld a,(de)		; $7b71
	rst_jumpTable			; $7b72
	.dw @initSubid00
	.dw @mediumDrawPriority
	.dw @initSubid02
	.dw @initSubid03
	.dw @lowDrawPriority
	.dw @mediumDrawPriority
	.dw @mediumDrawPriority
	.dw @highDrawPriority
	.dw @initSubid08
	.dw @mediumDrawPriority

@initSubid00:
	ld h,d			; $7b87
	ld l,$46		; $7b88
	ld (hl),$78		; $7b8a
@highDrawPriority:
	jp objectSetVisible82		; $7b8c

@initSubid02:
	ld h,d			; $7b8f
	ld l,$50		; $7b90
	ld (hl),$80		; $7b92
	inc l			; $7b94
	ld (hl),$ff		; $7b95
@mediumDrawPriority:
	jp objectSetVisible81		; $7b97

@initSubid03:
	ld h,d			; $7b9a
	ld l,$50		; $7b9b
	ld (hl),$c0		; $7b9d
	inc l			; $7b9f
	ld (hl),$ff		; $7ba0
	jp objectSetVisible81		; $7ba2

@lowDrawPriority:
	jp objectSetVisible80		; $7ba5

@initSubid08:
	ld h,d			; $7ba8
	ld l,$46		; $7ba9
	ld (hl),$c2		; $7bab
	jp objectSetVisible80		; $7bad

@state1:
	ld e,Interaction.subid		; $7bb0
	ld a,(de)		; $7bb2
	rst_jumpTable			; $7bb3
	.dw @runSubid00
	.dw @runSubid01
	.dw @runSubid02
	.dw @runSubid03
	.dw @runSubid04
	.dw @runSubid05
	.dw @runSubid06
	.dw @runSubid07
	.dw @runSubid08
	.dw @runSubid09

@runSubid00:
@runSubid07:
@animateAndFlickerAndDeleteWhenCounter1Zero:
	call interactionDecCounter1		; $7bc8
	jp z,interactionDelete		; $7bcb
@animateAndFlicker:
	call interactionAnimate		; $7bce
	ld a,(wFrameCounter)		; $7bd1
@flicker4:
	rrca			; $7bd4
	jp c,objectSetInvisible		; $7bd5
	jp objectSetVisible		; $7bd8
	
@runSubid02:
@runSubid03:
	call objectApplyComponentSpeed		; $7bdb

@runSubid01:
@runSubid05:
	ld e,$61		; $7bde
	ld a,(de)		; $7be0
	cp $ff			; $7be1
	jp z,interactionDelete		; $7be3
	jp interactionAnimate		; $7be6

@runSubid04:
	ld a,($cfc0)		; $7be9
	bit 0,a			; $7bec
	jp nz,interactionDelete		; $7bee
	jr @animateAndFlicker		; $7bf1

@runSubid09:
	ld a,($cbb9)		; $7bf3
	cp $06			; $7bf6
	jp z,interactionDelete		; $7bf8
	jr @animateFlickerAndTakeRelatedObj1Position		; $7bfb

@runSubid06:
	ld a,($cbb9)		; $7bfd
	cp $07			; $7c00
	jp z,interactionDelete		; $7c02

@animateFlickerAndTakeRelatedObj1Position:
	call interactionAnimate		; $7c05
	ld a,$0b		; $7c08
	call objectGetRelatedObject1Var		; $7c0a
	call objectTakePosition		; $7c0d
	ld a,($cbb7)		; $7c10
	jr @flicker4		; $7c13

@runSubid08:
	ld a,$0b		; $7c15
	call objectGetRelatedObject1Var		; $7c17
	call objectTakePosition		; $7c1a
	jr @animateAndFlickerAndDeleteWhenCounter1Zero		; $7c1d


; ==============================================================================
; INTERACID_INTRO_SCENE_MUSIC
; ==============================================================================
interactionCode85:
	ld e,Interaction.state		; $7c1f
	ld a,(de)		; $7c21
	rst_jumpTable			; $7c22
	.dw @state0
	.dw @state1
@state0:
	ld a,$01		; $7c27
	ld (de),a		; $7c29
	; room where Din dances
	ld a,<ROOM_SEASONS_098		; $7c2a
	call getARoomFlags		; $7c2c
	and $40			; $7c2f
	jp nz,interactionDelete		; $7c31
	ld hl,$cfd7		; $7c34
	ld a,(hl)		; $7c37
	or a			; $7c38
	ret nz			; $7c39
	inc a			; $7c3a
	ld (hl),a		; $7c3b
	ld ($cc02),a		; $7c3c
	ld a,MUS_CARNIVAL		; $7c3f
	call playSound		; $7c41
@state1:
	ld a,($d00d)		; $7c44
	cp $70			; $7c47
	ld a,$01		; $7c49
	jr c,+			; $7c4b
	inc a			; $7c4d
+
	ld h,d			; $7c4e
	ld l,$77		; $7c4f
	cp (hl)			; $7c51
	ret z			; $7c52
	ld (hl),a		; $7c53
	jp setMusicVolume		; $7c54


; ==============================================================================
; INTERACID_TEMPLE_SINKING_EXPLOSION
; ==============================================================================
interactionCode86:
	call checkInteractionState		; $7c57
	jr nz,@state1	; $7c5a
	ld a,$01		; $7c5c
	ld (de),a		; $7c5e
	call interactionInitGraphics		; $7c5f
	ld e,Interaction.subid		; $7c62
	ld a,(de)		; $7c64
	ld b,a			; $7c65
	add a			; $7c66
	add b			; $7c67
	ld b,a			; $7c68
	ld h,d			; $7c69
	ld l,$62		; $7c6a
	ldi a,(hl)		; $7c6c
	ld h,(hl)		; $7c6d
	ld l,a			; $7c6e
	ld a,b			; $7c6f
	rst_addAToHl			; $7c70
	ld e,$62		; $7c71
	ld a,l			; $7c73
	ld (de),a		; $7c74
	inc e			; $7c75
	ld a,h			; $7c76
	ld (de),a		; $7c77
	call _func_7cb3		; $7c78
	jp objectSetVisible81		; $7c7b
@state1:
	ld hl,$cfd3		; $7c7e
	ld a,(hl)		; $7c81
	inc a			; $7c82
	jp z,interactionDelete		; $7c83
	dec a			; $7c86
	and $7f			; $7c87
	ld b,a			; $7c89
	ld h,d			; $7c8a
	ld l,$43		; $7c8b
	ld a,(hl)		; $7c8d
	cp b			; $7c8e
	jr z,+			; $7c8f
	ld (hl),b		; $7c91
	call _func_7cb3		; $7c92
	jr ++			; $7c95
+
	ld e,$61		; $7c97
	ld a,(de)		; $7c99
	inc a			; $7c9a
	call z,_func_7cb3		; $7c9b
++
	call interactionAnimate		; $7c9e
	ld e,Interaction.subid		; $7ca1
	ld a,(de)		; $7ca3
	and $01			; $7ca4
	ld b,a			; $7ca6
	ld a,(wFrameCounter)		; $7ca7
	and $01			; $7caa
	xor b			; $7cac
	jp z,objectSetInvisible		; $7cad
	jp objectSetVisible		; $7cb0
_func_7cb3:
	ld hl,$cfd3		; $7cb3
	ld a,(hl)		; $7cb6
	and $7f			; $7cb7
	ld hl,_table_7cd8		; $7cb9
	rst_addDoubleIndex			; $7cbc
	ldi a,(hl)		; $7cbd
	ld h,(hl)		; $7cbe
	ld l,a			; $7cbf
	ld e,Interaction.subid		; $7cc0
	ld a,(de)		; $7cc2
	rst_addDoubleIndex			; $7cc3
	ldi a,(hl)		; $7cc4
	ld e,$4b		; $7cc5
	call _func_7ccd		; $7cc7
	ld a,(hl)		; $7cca
	ld e,$4d		; $7ccb
_func_7ccd:
	ld b,a			; $7ccd
	call getRandomNumber		; $7cce
	and $03			; $7cd1
	sub $02			; $7cd3
	add b			; $7cd5
	ld (de),a		; $7cd6
	ret			; $7cd7
_table_7cd8:
	.dw _table_7ce2
	.dw _table_7cec
	.dw _table_7cf6
	.dw _table_7d00
	.dw _table_7d0a
_table_7ce2:
	.db $79 $42
	.db $7b $4e
	.db $7e $5b
	.db $80 $70
	.db $81 $8a
_table_7cec:
	.db $00 $38
	.db $6c $20
	.db $48 $40
	.db $3c $91
	.db $34 $64
_table_7cf6:
	.db $2c $7e
	.db $1e $9e
	.db $50 $6e
	.db $28 $24
	.db $60 $20
_table_7d00:
	.db $1c $18
	.db $44 $64
	.db $00 $5c
	.db $68 $70
	.db $74 $34
_table_7d0a:
	.db $e0 $e0
	.db $7b $4e
	.db $7e $58
	.db $80 $68
	.db $81 $80


; ==============================================================================
; INTERACID_MAKU_TREE
; TODO: finish
; Variables:
;   $cc39: Maku tree stage
;   $c6df/wc6e5: ???
;   $c6eo/ws_c6e0: ???
; ==============================================================================
interactionCode87:
	ld e,Interaction.state		; $7d14
	ld a,(de)		; $7d16
	rst_jumpTable			; $7d17
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3

@state0:
	ld e,Interaction.subid		; $7d20
	ld a,(de)		; $7d22
	rst_jumpTable			; $7d23
	.dw @subid0
	.dw @subid1
	.dw @subid2

@subid0:
	call interactionInitGraphics		; $7d2a
	call objectSetVisible83		; $7d2d
	call interactionSetAlwaysUpdateBit		; $7d30
	call @setAppropriateStage		; $7d33
	call @spawnGnarledKey		; $7d36
	ld hl,script710b		; $7d39
	call interactionSetScript		; $7d3c
	ld a,($cc39)		; $7d3f
	or a			; $7d42
	jr nz,+			; $7d43
	ld a,$01		; $7d45
	jr ++		; $7d47
+
	ld a,$02		; $7d49
++
	ld e,Interaction.state		; $7d4b
	ld (de),a		; $7d4d
	call interactionRunScript		; $7d4e
	call interactionRunScript		; $7d51
	jp interactionRunScript		; $7d54

@subid1:
	ld e,Interaction.state		; $7d57
	ld a,$02		; $7d59
	ld (de),a		; $7d5b
	call interactionInitGraphics		; $7d5c
	call objectSetVisible83		; $7d5f
	ld hl,script7255		; $7d62
	call interactionSetScript		; $7d65
	jp interactionRunScript		; $7d68

@subid2:
	ld e,Interaction.state		; $7d6b
	ld a,$02		; $7d6d
	ld (de),a		; $7d6f
	call interactionInitGraphics		; $7d70
	call objectSetVisible83		; $7d73
	call interactionSetAlwaysUpdateBit		; $7d76
	ld hl,script7261		; $7d79
	call interactionSetScript		; $7d7c
	jp interactionRunScript		; $7d7f

@state1:
	call @setRoomFlag40OnGnarledKeyGet		; $7d82

@state2:
	call interactionRunScript		; $7d85

@state3:
	jp interactionAnimate		; $7d88

@setAppropriateStage:
	ld a,GLOBALFLAG_FINISHEDGAME		; $7d8b
	call checkGlobalFlag		; $7d8d
	jp nz,@setStageToLast		; $7d90
	ld a,TREASURE_ESSENCE		; $7d93
	call checkTreasureObtained		; $7d95
	jr c,+			; $7d98
	xor a			; $7d9a
+
	; dungeon 1,2,3,5?
	cp $17			; $7d9b
	jr z,@highestEssenceIs5Except4	; $7d9d
	; dungeon 1 to 5?
	cp $1f			; $7d9f
	jr z,@highestEssenceIs5	; $7da1
	call getHighestSetBit		; $7da3
	jr nc,+			; $7da6
	inc a			; $7da8
+
	; 0 if no essences, 1-8 based on highest essence, otherwise
	call @setStage		; $7da9
	cp $01			; $7dac
	jr z,@highestEssenceIs1	; $7dae
	cp $08			; $7db0
	jr z,@highestEssenceIs8	; $7db2
	ret			; $7db4
	
@highestEssenceIs1:
	; highest essence is 1st essence
	ld a,>ROOM_SEASONS_12a		; $7db5
	ld b,<ROOM_SEASONS_12a		; $7db7
	call getRoomFlags		; $7db9
	and $40			; $7dbc
	ret z			; $7dbe
	ld a,$09		; $7dbf
	jr @setStage		; $7dc1
	
@highestEssenceIs5Except4:
	ld a,GLOBALFLAG_MET_MAKU_WITH_FIRST_5_ESSENCES_EXCEPT_4TH		; $7dc3
	call setGlobalFlag		; $7dc5
	ld a,$0a		; $7dc8
	jr @setStage		; $7dca
	
@highestEssenceIs5:
	ld a,GLOBALFLAG_MET_MAKU_WITH_FIRST_5_ESSENCES_EXCEPT_4TH		; $7dcc
	call checkGlobalFlag		; $7dce
	jr nz,+			; $7dd1
	ld a,$05		; $7dd3
	jr @setStage		; $7dd5
+
	ld a,$0b		; $7dd7
	jr @setStage		; $7dd9
	
@highestEssenceIs8:
	ld a,(wc6e5)		; $7ddb
	cp $09			; $7dde
	jr z,@all8Essences	; $7de0
	ld a,GLOBALFLAG_GOT_MAKU_SEED		; $7de2
	call checkGlobalFlag		; $7de4
	ret z			; $7de7
	ld a,$0c		; $7de8
	jr @setStage		; $7dea

@all8Essences:
	ld a,$0d		; $7dec
	jr @setStage		; $7dee

@setStageToLast:
	ld a,$0e		; $7df0
@setStage:
	ld ($cc39),a		; $7df2
	ret			; $7df5

@setRoomFlag40OnGnarledKeyGet:
	call getThisRoomFlags		; $7df6
	and $40			; $7df9
	ret nz			; $7dfb
	ld a,TREASURE_GNARLED_KEY		; $7dfc
	call checkTreasureObtained		; $7dfe
	ret nc			; $7e01
	set 6,(hl)		; $7e02
	ret			; $7e04

@spawnGnarledKey:
	call getThisRoomFlags		; $7e05
	bit 6,a			; $7e08
	ret nz			; $7e0a
	; not yet gotten gnarled key
	bit 7,a			; $7e0b
	ret z			; $7e0d
	call getFreeInteractionSlot		; $7e0e
	ret nz			; $7e11
	ld (hl),INTERACID_TREASURE		; $7e12
	inc l			; $7e14
	ld (hl),TREASURE_GNARLED_KEY		; $7e15
	inc l			; $7e17
	ld (hl),$01		; $7e18
	ld l,Interaction.yh		; $7e1a
	ld a,$58		; $7e1c
	ldi (hl),a		; $7e1e
	ld a,(ws_c6e0)		; $7e1f
	ld l,$4d		; $7e22
	ld (hl),a		; $7e24
	ret			; $7e25


; INTERACID_88
; clouds above Onox castle?
interactionCode88:
	call checkInteractionState		; $7e26
	jr nz,@nonZeroState	; $7e29
	ld a,(wPaletteThread_mode)		; $7e2b
	or a			; $7e2e
	ret nz			; $7e2f
	ld a,$01		; $7e30
	ld (de),a		; $7e32
	ld e,$40		; $7e33
	ld a,(de)		; $7e35
	or $80			; $7e36
	ld (de),a		; $7e38
	call interactionInitGraphics		; $7e39
	call objectSetVisible82		; $7e3c
	call objectSetInvisible		; $7e3f
	ld e,Interaction.subid		; $7e42
	ld a,(de)		; $7e44
	or a			; $7e45
	jr z,+			; $7e46
	ld a,(wGfxRegs1.SCY)		; $7e48
	cpl			; $7e4b
	inc a			; $7e4c
+
	add $28			; $7e4d
	ld l,$4b		; $7e4f
	ld (hl),a		; $7e51
	ld e,Interaction.subid		; $7e52
	ld a,(de)		; $7e54
	or a			; $7e55
	jr nz,+			; $7e56
	call interactionIncState2		; $7e58
	ld hl,_seasonsTable_09_7f33		; $7e5b
	jp _seasonsFunc_09_7f01		; $7e5e
+
	ld a,GLOBALFLAG_DRAGON_ONOX_BEATEN		; $7e61
	call checkGlobalFlag		; $7e63
	jp nz,interactionDelete		; $7e66
	ld e,$46		; $7e69
	ld a,$3c		; $7e6b
	ld (de),a		; $7e6d
	ret			; $7e6e
@nonZeroState:
	ld a,GLOBALFLAG_INTRO_DONE		; $7e6f
	call checkGlobalFlag		; $7e71
	jr nz,+			; $7e74
	ld a,(wPaletteThread_mode)		; $7e76
	or a			; $7e79
	jp nz,interactionDelete		; $7e7a
+
	call checkInteractionState2		; $7e7d
	jr nz,+			; $7e80
	call interactionDecCounter1		; $7e82
	ret nz			; $7e85
	ld l,$46		; $7e86
	ld (hl),$3c		; $7e88
	call getRandomNumber_noPreserveVars		; $7e8a
	and $01			; $7e8d
	ret z			; $7e8f
	call interactionIncState2		; $7e90
	call getRandomNumber_noPreserveVars		; $7e93
	and $03			; $7e96
	ld hl,_seasonsTable_09_7f2b		; $7e98
	rst_addDoubleIndex			; $7e9b
	ldi a,(hl)		; $7e9c
	ld h,(hl)		; $7e9d
	ld l,a			; $7e9e
	jp _seasonsFunc_09_7f01		; $7e9f
+
	ld e,$70		; $7ea2
	ld a,(de)		; $7ea4
	or a			; $7ea5
	jr nz,_seasonsFunc_09_7ee2	; $7ea6
	ld a,$01		; $7ea8
	ld (de),a		; $7eaa
	ld e,$47		; $7eab
	ld a,(de)		; $7ead
	ld hl,_seasonsTable_09_7f28		; $7eae
	rst_addAToHl			; $7eb1
	ld a,(hl)		; $7eb2
	call loadPaletteHeader		; $7eb3
	ld a,$ff		; $7eb6
	ld ($cd29),a		; $7eb8
	ld a,(de)		; $7ebb
	or a			; $7ebc
	ld a,$d2		; $7ebd
	call nz,playSound		; $7ebf
	ld a,(de)		; $7ec2
	cp $02			; $7ec3
	jr z,+			; $7ec5
	call objectSetInvisible		; $7ec7
	jr _seasonsFunc_09_7ee2		; $7eca
+
	call getRandomNumber		; $7ecc
	and $01			; $7ecf
	ld b,a			; $7ed1
	ld a,$13		; $7ed2
	jr z,+			; $7ed4
	ld a,$8d		; $7ed6
+
	ld e,$4d		; $7ed8
	ld (de),a		; $7eda
	ld a,b			; $7edb
	call interactionSetAnimation		; $7edc
	call objectSetVisible		; $7edf

_seasonsFunc_09_7ee2:
	ld e,$47		; $7ee2
	ld a,(de)		; $7ee4
	cp $02			; $7ee5
	jr nz,+			; $7ee7
	call interactionAnimate		; $7ee9
	ld e,$61		; $7eec
	ld a,(de)		; $7eee
	inc a			; $7eef
	jr nz,+			; $7ef0
	call objectSetInvisible		; $7ef2
+
	call interactionDecCounter1		; $7ef5
	ret nz			; $7ef8
	ld h,d			; $7ef9
	ld l,$58		; $7efa
	ldi a,(hl)		; $7efc
	ld l,(hl)		; $7efd
	ld h,a			; $7efe
	inc hl			; $7eff
	inc hl			; $7f00

_seasonsFunc_09_7f01:
	ld e,Interaction.relatedObj2		; $7f01
	ld a,h			; $7f03
	ld (de),a		; $7f04
	inc e			; $7f05
	ld a,l			; $7f06
	ld (de),a		; $7f07
	ldi a,(hl)		; $7f08
	inc a			; $7f09
	jr z,_seasonsFunc_09_7f17	; $7f0a
	ld e,$46		; $7f0c
	ld (de),a		; $7f0e
	inc e			; $7f0f
	ld a,(hl)		; $7f10
	ld (de),a		; $7f11
	ld e,$70		; $7f12
	xor a			; $7f14
	ld (de),a		; $7f15
	ret			; $7f16

_seasonsFunc_09_7f17:
	ld h,d			; $7f17
	ld l,$42		; $7f18
	ld a,(hl)		; $7f1a
	or a			; $7f1b
	jp z,interactionDelete		; $7f1c
	ld l,$45		; $7f1f
	ld (hl),$00		; $7f21
	ld l,$46		; $7f23
	ld (hl),$3c		; $7f25
	ret			; $7f27

_seasonsTable_09_7f28:
	.db SEASONS_PALH_3b
	.db SEASONS_PALH_99
	.db SEASONS_PALH_9a

_seasonsTable_09_7f2b:
	.dw _seasonsTable_09_7f33
	.dw _seasonsTable_09_7f33
	.dw _seasonsTable_09_7f33
	.dw _seasonsTable_09_7f33

_seasonsTable_09_7f33:
	.db $3c $00
	.db $02 $01
	.db $04 $00
	.db $02 $02
	.db $78 $00
	.db $02 $01
	.db $02 $00
	.db $02 $01
	.db $02 $00
	.db $03 $01
	.db $01 $00
	.db $0c $02
	.db $3c $00
	.db $ff
