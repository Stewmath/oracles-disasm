;;
; ITEMID_FLUTE ($0e)
; ITEMID_HARP ($11)
; @addr{4d73}
_parentItemCode_flute:
_parentItemCode_harp:
	ld e,Item.state		; $4d73
	ld a,(de)		; $4d75
	rst_jumpTable			; $4d76
	.dw @state0
	.dw @state1

@state0:
	call _checkLinkOnGround		; $4d7b
	jp nz,_clearParentItem		; $4d7e
	ld a,(wInstrumentsDisabledCounter)		; $4d81
	or a			; $4d84
	jp nz,_clearParentItem		; $4d85
	call _isLinkInHole		; $4d88
	jp c,_clearParentItem		; $4d8b
	call _checkNoOtherParentItemsInUse		; $4d8e
	jp nz,_clearParentItem		; $4d91

	ld a,$80		; $4d94
	ld (wcc95),a		; $4d96
	ld a,$ff ~ DISABLE_LINK ~ DISABLE_ALL_BUT_INTERACTIONS		; $4d99
	ld (wDisabledObjects),a		; $4d9b

	call _parentItemLoadAnimationAndIncState		; $4d9e

	; Determine what sound to play
	ld b,$00		; $4da1
	call @getSelectedSongAddr		; $4da3
	jr z,+			; $4da6
	ld b,$03		; $4da8
+
	ld a,(hl)		; $4daa
	add b			; $4dab
	ld hl,@sfxList		; $4dac
	rst_addAToHl			; $4daf
	ld a,(hl)		; $4db0
	call playSound		; $4db1

@state1:
	ld hl,w1Link.collisionType		; $4db4
	res 7,(hl)		; $4db7

	; Create floating music note every $20 frames
	call itemDecCounter1		; $4db9
	ld a,(hl)		; $4dbc
	and $1f			; $4dbd
	jr nz,++		; $4dbf

	ld l,Item.animParameter		; $4dc1
	bit 0,(hl)		; $4dc3
	ld bc,$fcf8		; $4dc5
	jr z,+			; $4dc8
	ld c,$08		; $4dca
+
	call getRandomNumber		; $4dcc
	and $01			; $4dcf
	push de			; $4dd1
	ld d,>w1Link		; $4dd2
	call objectCreateFloatingMusicNote		; $4dd4
	pop de			; $4dd7
++
	call _specialObjectAnimate		; $4dd8
	call @getSelectedSongAddr		; $4ddb

.ifdef ROM_AGES
	ld a,$ff		; $4dde
	jr z,+			; $4de0
	ld a,(hl)		; $4de2
+
	ld (wLinkPlayingInstrument),a		; $4de3
	ld (wLinkRidingObject),a		; $4de6
	ld c,$80		; $4de9
	jr nz,++			; $4deb

.else; ROM_SEASONS
	ld a,$ff		; $4dde
	ld (wLinkPlayingInstrument),a
	ld (wLinkRidingObject),a
	ld c,$80
.endif

	ld a,(hl)		; $4ded
	or a			; $4dee
	jr nz,++			; $4def
	ld c,$40		; $4df1
++
	ld e,Item.animParameter		; $4df3
	ld a,(de)		; $4df5
	and c			; $4df6
	ret z			; $4df7

; Done playing song

	ld hl,w1Link.collisionType		; $4df8
	set 7,(hl)		; $4dfb

.ifdef ROM_AGES
	call @getSelectedSongAddr		; $4dfd
	jr nz,@harp		; $4e00
.endif

	; Flute: try to spawn companion
	ldbc INTERACID_COMPANION_SPAWNER, $80		; $4e02
	call objectCreateInteraction		; $4e05

@clearSelf:
	xor a			; $4e08
	ld (wDisabledObjects),a		; $4e09
	ld (wcc95),a		; $4e0c
	jp _clearParentItem		; $4e0f


.ifdef ROM_AGES ; Harp code

@tuneEchoesInVain:
	ld bc,TX_5110		; $4e12
	call showText		; $4e15
	jr @clearSelf		; $4e18

@harp:
	; Only allow harp playing on overworld, non-maku tree screens
	ld a,(wAreaFlags)		; $4e1a
	and (AREAFLAG_UNDERWATER|AREAFLAG_SIDESCROLL|AREAFLAG_10|AREAFLAG_DUNGEON|AREAFLAG_INDOORS|AREAFLAG_MAKU)
	jr nz,@clearSelf	; $4e1f

	ld a,(hl)		; $4e21
	rst_jumpTable			; $4e22
	.dw @clearSelf
	.dw @tuneOfEchoes
	.dw @tuneOfCurrents
	.dw @tuneOfAges

@tuneOfEchoes:
	call getThisRoomFlags		; $4e2b
	bit ROOMFLAG_BIT_PORTALSPOT_DISCOVERED,(hl)		; $4e2e
	jr nz,@clearSelf	; $4e30
	jr @tuneEchoesInVain		; $4e32

@tuneOfCurrents:
	; Test AREAFLAG_BIT_PAST
	ld a,(wAreaFlags)		; $4e34
	rlca			; $4e37
	jr nc,@tuneEchoesInVain	; $4e38

@tuneOfAges:
	call restartSound		; $4e3a

	ld a,CUTSCENE_TIMEWARP		; $4e3d
	ld (wCutsceneTrigger),a		; $4e3f

	ld a,DISABLE_LINK|DISABLE_ENEMIES|DISABLE_8|DISABLE_COMPANION|DISABLE_40
	ld (wDisabledObjects),a		; $4e44
	ld (wDisableLinkCollisionsAndMenu),a		; $4e47
	ld (wcde0),a		; $4e4a
	call clearAllItemsAndPutLinkOnGround		; $4e4d
	jp _specialObjectAnimate		; $4e50

.endif ; ROM_AGES


@sfxList:
	.db SND_CRANEGAME
	.db SND_FLUTE_RICKY
	.db SND_FLUTE_DIMITRI
	.db SND_FLUTE_MOOSH
.ifdef ROM_AGES
	.db SND_ECHO
	.db SND_CURRENT
	.db SND_AGES
.endif

;;
; @param[out]	hl	wFluteIcon or wSelectedHarpSong
; @param[out]	zflag	Set if using flute, unset for harp
; @addr{4e5a}
@getSelectedSongAddr:
	ld hl,wFluteIcon		; $4e5a
	ld e,Item.id		; $4e5d
	ld a,(de)		; $4e5f
	cp ITEMID_FLUTE			; $4e60

.ifdef ROM_AGES
	ret z			; $4e62
	ld l,<wSelectedHarpSong		; $4e63
.endif
	ret			; $4e65
