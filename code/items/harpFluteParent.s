;;
; ITEMID_FLUTE ($0e)
; ITEMID_HARP ($11)
parentItemCode_flute:
parentItemCode_harp:
	ld e,Item.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1

@state0:
	call checkLinkOnGround
	jp nz,clearParentItem
	ld a,(wInstrumentsDisabledCounter)
	or a
	jp nz,clearParentItem
	call isLinkInHole
	jp c,clearParentItem
	call checkNoOtherParentItemsInUse
	jp nz,clearParentItem

	ld a,$80
	ld (wcc95),a
	ld a,$ff ~ DISABLE_LINK ~ DISABLE_ALL_BUT_INTERACTIONS
	ld (wDisabledObjects),a

	call parentItemLoadAnimationAndIncState

	; Determine what sound to play
	ld b,$00
	call @getSelectedSongAddr
	jr z,+
	ld b,$03
+
	ld a,(hl)
	add b
	ld hl,@sfxList
	rst_addAToHl
	ld a,(hl)
	call playSound

@state1:
	ld hl,w1Link.collisionType
	res 7,(hl)

	; Create floating music note every $20 frames
	call itemDecCounter1
	ld a,(hl)
	and $1f
	jr nz,++

	ld l,Item.animParameter
	bit 0,(hl)
	ld bc,$fcf8
	jr z,+
	ld c,$08
+
	call getRandomNumber
	and $01
	push de
	ld d,>w1Link
	call objectCreateFloatingMusicNote
	pop de
++
	call specialObjectAnimate_optimized
	call @getSelectedSongAddr

.ifdef ROM_AGES
	ld a,$ff
	jr z,+
	ld a,(hl)
+
	ld (wLinkPlayingInstrument),a
	ld (wLinkRidingObject),a
	ld c,$80
	jr nz,++

.else; ROM_SEASONS
	ld a,$ff
	ld (wLinkPlayingInstrument),a
	ld (wLinkRidingObject),a
	ld c,$80
.endif

	ld a,(hl)
	or a
	jr nz,++
	ld c,$40
++
	ld e,Item.animParameter
	ld a,(de)
	and c
	ret z

; Done playing song

	ld hl,w1Link.collisionType
	set 7,(hl)

.ifdef ROM_AGES
	call @getSelectedSongAddr
	jr nz,@harp
.endif

	; Flute: try to spawn companion
	ldbc INTERACID_COMPANION_SPAWNER, $80
	call objectCreateInteraction

@clearSelf:
	xor a
	ld (wDisabledObjects),a
	ld (wcc95),a
	jp clearParentItem


.ifdef ROM_AGES ; Harp code

@tuneEchoesInVain:
	ld bc,TX_5110
	call showText
	jr @clearSelf

@harp:
	; Only allow harp playing on overworld, non-maku tree screens
	ld a,(wTilesetFlags)
	and (TILESETFLAG_UNDERWATER|TILESETFLAG_SIDESCROLL|TILESETFLAG_LARGE_INDOORS|TILESETFLAG_DUNGEON|TILESETFLAG_INDOORS|TILESETFLAG_MAKU)
	jr nz,@clearSelf

	ld a,(hl)
	rst_jumpTable
	.dw @clearSelf
	.dw @tuneOfEchoes
	.dw @tuneOfCurrents
	.dw @tuneOfAges

@tuneOfEchoes:
	call getThisRoomFlags
	bit ROOMFLAG_BIT_PORTALSPOT_DISCOVERED,(hl)
	jr nz,@clearSelf
	jr @tuneEchoesInVain

@tuneOfCurrents:
	; Test TILESETFLAG_BIT_PAST
	ld a,(wTilesetFlags)
	rlca
	jr nc,@tuneEchoesInVain

@tuneOfAges:
	call restartSound

	ld a,CUTSCENE_TIMEWARP
	ld (wCutsceneTrigger),a

	ld a,DISABLE_LINK|DISABLE_ENEMIES|DISABLE_8|DISABLE_COMPANION|DISABLE_40
	ld (wDisabledObjects),a
	ld (wDisableLinkCollisionsAndMenu),a
	ld (wcde0),a
	call clearAllItemsAndPutLinkOnGround
	jp specialObjectAnimate_optimized

.endif ; ROM_AGES


@sfxList:
	.db SND_FILLED_HEART_CONTAINER
	.db SND_FLUTE_RICKY
	.db SND_FLUTE_DIMITRI
	.db SND_FLUTE_MOOSH
.ifdef ROM_AGES
	.db SND_TUNE_OF_ECHOES
	.db SND_TUNE_OF_CURRENTS
	.db SND_TUNE_OF_AGES
.endif

;;
; @param[out]	hl	wFluteIcon or wSelectedHarpSong
; @param[out]	zflag	Set if using flute, unset for harp
@getSelectedSongAddr:
	ld hl,wFluteIcon
	ld e,Item.id
	ld a,(de)
	cp ITEMID_FLUTE

.ifdef ROM_AGES
	ret z
	ld l,<wSelectedHarpSong
.endif
	ret
