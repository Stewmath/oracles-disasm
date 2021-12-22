; ==============================================================================
; INTERACID_DUNGEON_SCRIPT
; ==============================================================================

;;
setTrigger2IfTriggers0And1Set:
	ld hl,wActiveTriggers
	ld a,(hl)
	and $03
	cp $03
	jr nz,+
	set 2,(hl)
	ret
+
	res 2,(hl)
	ret

;;
; Creates a part object (PARTID_LIGHTABLE_TORCH) at each unlit torch, allowing them to be lit.
makeTorchesLightable:
	call getFreeInteractionSlot
	ret nz

	ld (hl),INTERACID_CREATE_OBJECT_AT_EACH_TILEINDEX
	inc l
	ld (hl),TILEINDEX_UNLIT_TORCH

	ld l,Interaction.yh
	ld (hl),PARTID_LIGHTABLE_TORCH
	ld l,Interaction.xh
	ld (hl),$10
	ret

;;
; Unused?
func_4f5d:
	call getThisRoomFlags
	set 7,(hl)
	ld a,SND_SOLVEPUZZLE
	jp playSound

;;
; @param	b	Length of bridge (in 8x8 tiles)
; @param	c	Direction the bridge should extend (0-3)
; @param	e	Position to start at
_spawnBridge:
	call getFreePartSlot
	ret nz
	ld (hl),PARTID_BRIDGE_SPAWNER
	ld l,Part.counter2
	ld (hl),b
	ld l,Part.angle
	ld (hl),c
	ld l,Part.yh
	ld (hl),e
	ret

mermaidsCave_spawnBridge_room38:
	call getThisRoomFlags
	set 6,(hl)
	ld a,SND_SOLVEPUZZLE
	call playSound
	ld bc,$0800
	ld e,$69
	jp _spawnBridge

herosCave_spawnBridge_roomc9:
	call getThisRoomFlags
	set 6,(hl)
	ld a,SND_SOLVEPUZZLE
	call playSound
	ld bc,$0803
	ld e,$2a
	jp _spawnBridge

ancientTomb_startWallRetractionCutscene:
	ld a,CUTSCENE_WALL_RETRACTION
	ld (wCutsceneTrigger),a
	jp resetLinkInvincibility

;;
moonlitGrotto_enableControlAfterBreakingCrystal:
	xor a
	ld (wDisabledObjects),a
	ld (wMenuDisabled),a
_label_15_031:
	ld (wDisableScreenTransitions),a
	ld (wDisableWarpTiles),a
	ret

; ==============================================================================
; INTERACID_BIPIN
; ==============================================================================

;;
; Show some text based on bipin's subid (expected to be 1-9).
bipin_showText_subid1To9:
	ld e,Interaction.subid
	ld a,(de)
	ld hl,@textIndices-1
	rst_addAToHl
	ld b,>TX_4300
	ld c,(hl)
	jp showText

@textIndices:
	.db <TX_4302
	.db <TX_4303
	.db <TX_4303
	.db <TX_4304
	.db <TX_4305
	.db <TX_4306
	.db <TX_4307
	.db <TX_4308
	.db <TX_4308

.ifdef ROM_AGES
; Script for the "past" version of bipin
bipinScript3:
	initcollisions
@loop:
	enableinput
	checkabutton
	disableinput
	jumpifroomflagset $20, @alreadyGaveSeed
	showtext TX_4311
	giveitem TREASURE_GASHA_SEED, $08
	wait 1
	checktext
	showtext TX_4312
	scriptjump @loop
@alreadyGaveSeed:
	showtext TX_4313
	scriptjump @loop
.endif


; ==============================================================================
; INTERACID_BLOSSOM
; ==============================================================================

;;
; @param	a	Value to write
setNextChildStage:
	ld hl,wNextChildStage
	ld (hl),a
	ret

;;
; @param	a	Bit to set
setc6e2Bit:
	ld hl,wc6e2
	jp setFlag

;;
; @param	a	Bit to check
checkc6e2BitSet:
	ld hl,wc6e2
	call checkFlag
	ld a,$01
	jr nz,+
	xor a
+
	ld e,Interaction.var3b
	ld (de),a
	ret

;;
; @param	a	Rupee value (see constants/rupeeValues.s)
blossom_checkHasRupees:
	call cpRupeeValue
	ld e,Interaction.var3c
	ld (de),a
	ret

;;
blossom_addValueToChildStatus:
	ld hl,wChildStatus
	add (hl)
	ld (hl),a
	ret

;;
; After naming the child, wChildStatus gets set to a random value from $01-$03.
blossom_decideInitialChildStatus:
	ld hl,wKidName
	ld b,$00
@nextChar:
	ldi a,(hl)
	or a
	jr z,@parsedName
	and $0f
	add b
	ld b,a
	jr @nextChar
@parsedName:
	ld a,b
--
	sub $03
	jr nc,--
	add $04
	ld (wChildStatus),a
	ret

;;
blossom_openNameEntryMenu:
	ld a,$07
	jp openMenu


; ==============================================================================
; INTERACID_VERAN_CUTSCENE_FACE
; ==============================================================================
veranFaceCutsceneScript:
	disableinput
	checkpalettefadedone
	wait 60
	writememory w1Link.direction, $00
	wait 30
	playsound SND_LIGHTTORCH
	writeobjectbyte Interaction.visible, $80
	wait 30
	showtext TX_5613
	scriptend


; ==============================================================================
; INTERACID_OLD_MAN_WITH_RUPEES
; ==============================================================================

;;
; Writes 0 to var3f if Link has no rupees, 1 otherwise.
oldMan_takeRupees:
	ld hl,wNumRupees
	ldi a,(hl)
	or (hl)
	ld e,Interaction.var3f
	ld (de),a
	ret z
	ld a,$01
	ld (de),a
	ld e,Interaction.subid
	ld a,(de)
	ld hl,_oldMan_rupeeValues
	rst_addAToHl
	ld a,(hl)
	jp removeRupeeValue

;;
oldMan_giveRupees:
	ld e,Interaction.subid
	ld a,(de)
	ld hl,_oldMan_rupeeValues
	rst_addAToHl
	ld c,(hl)
	ld a,TREASURE_RUPEES
	jp giveTreasure

_oldMan_rupeeValues:
	.db RUPEEVAL_200
	.db RUPEEVAL_100


; ==============================================================================
; INTERACID_SHOOTING_GALLERY
; ==============================================================================

;;
shootingGallery_beginGame:
	; Spawn a new INTERACID_SHOOTING_GALLERY with subid 3 (runs the game)
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERACID_SHOOTING_GALLERY
	inc l
	ld (hl),$03
	inc l

	; New interaction's [var03] = this interction's [subid]
	ld e,Interaction.subid
	ld a,(de)
	ld (hl),a
	ret

;;
shootingGallery_cpScore:
	call @cpScore
	jp _writeFlagsTocddb

@cpScore:
	ld hl,@scores
	rst_addDoubleIndex
	ldi a,(hl)
	ld b,(hl)
	ld c,a
	ld hl,wTextNumberSubstitution
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	call compareHlToBc
	inc a
	jr nz,+
	inc a
	ret
+
	xor a
	ret

@scores:
	; Lynna village scores
	.dw $0350 ; 0
	.dw $0250 ; 1
	.dw $0150 ; 2
	.dw $0050 ; 3

	; Goron gallery scores
	.dw $0400 ; 4
	.dw $0300 ; 5
	.dw $0200 ; 6
	.dw $0100 ; 7

	; Biggoron's sword score
	.dw $0300 ; 8

;;
shootingGallery_equipSword:
	ld hl,hFF8A
	ld a,(wInventoryA)
	cp ITEMID_SWORD
	jr nz,@equipOnB

@equipOnA:
	xor a
	ldi (hl),a
	ld a,ITEMID_SWORD
	ld (hl),a
	jr _shootingGallery_changeEquips

@equipOnB:
	ld a,ITEMID_SWORD
	ldi (hl),a
	xor a
	ld (hl),a
	jr _shootingGallery_changeEquips

;;
shootingGallery_equipBiggoronSword:
	ld hl,hFF8A
	ld a,ITEMID_BIGGORON_SWORD
	ldi (hl),a
	ld (hl),a

;;
; Saves equipped items to $cfd7-$cfd8, then equips new items.

; @param	hFF8A	B-button item to equip
; @param	hFF8B	A-button item to equip
_shootingGallery_changeEquips:
	ld bc,wInventoryB
	ld hl,wTmpcfc0.shootingGallery.savedBItem
	ld a,(bc)
	ldi (hl),a
	ldh a,(<hFF8A)
	ld (bc),a
	inc c
	ld a,(bc)
	ldi (hl),a
	ldh a,(<hFF8B)
	ld (bc),a
	ld a,$ff
	ld (wStatusBarNeedsRefresh),a
	ret

;;
shootingGallery_restoreEquips:
	ld bc,wInventoryB
	ld hl,wTmpcfc0.shootingGallery.savedBItem
	ldi a,(hl)
	ld (bc),a
	inc c
	ldi a,(hl)
	ld (bc),a
	ld a,$ff
	ld (wStatusBarNeedsRefresh),a
	ret

;;
func_50e4:
	ld a,(w1Link.yh)
	ld b,a
	ld a,(w1Link.xh)
	ld c,a
	ld a,$6e
	jp createEnergySwirlGoingIn

;;
createSparkle:
	ld b,INTERACID_SPARKLE
	jp objectCreateInteractionWithSubid00

;;
; Writes to the tilemap to replace all "target" tiles with floor tiles.
shootingGallery_removeAllTargets:
	jpab agesInteractionsBank08.shootingGallery_removeAllTargets

;;
; @param	a	0 to create the entrance, 2 to remove it
shootingGallery_setEntranceTiles:
	ld hl,@positions
	rst_addAToHl
	ld c,$74
--
	ldi a,(hl)
	push hl
	call setTile
	pop hl
	inc c
	ld a,c
	cp $76
	jr nz,--
	ret

@positions:
	.db $e0 $e1 ; Create entrance
	.db $c6 $c6 ; Remove entrance

;;
; Sets bit 7 in wcddb if Link has the give number of rupees, clears it otherwise.
;
; @param	a	Rupee value
shootingGallery_checkLinkHasRupees:
	call cpRupeeValue

;;
_writeFlagsTocddb:
	push af
	pop bc
	ld a,c
	ld (wcddb),a
	ret

;;
; @param	a	Amount to give
giveRupees:
	ld c,a
	ld a,TREASURE_RUPEES
	jp giveTreasure

;;
; Unused?
giveHealthRefill:
	ld c,$40
	jr ++

;;
shootingGallery_giveOneHeart:
	ld c,$04
	jr ++

;;
; Unused?
;
; @param	a	Amount of health to give (in quarters of heart)
giveHealth:
	ld c,a
++
	ld a,TREASURE_HEART_REFILL
	jp giveTreasure

;;
; @param	a	Ring to give
giveRingAToLink:
	ld b,a
	ld c,$00
	jp giveRingToLink

;;
shootingGallery_giveRandomRingToLink:
	call getRandomNumber
	and $0f
	ld hl,@ringList
	rst_addAToHl
	ld a,(hl)
	jr giveRingAToLink

@ringList:
	.db LIGHT_RING_L2
	.db RED_LUCK_RING
	.db RED_LUCK_RING
	.db RED_LUCK_RING
	.db RED_LUCK_RING
	.db BLUE_HOLY_RING
	.db BLUE_HOLY_RING
	.db BLUE_HOLY_RING
	.db BLUE_HOLY_RING
	.db BLUE_HOLY_RING
	.db OCTO_RING
	.db OCTO_RING
	.db OCTO_RING
	.db OCTO_RING
	.db OCTO_RING
	.db OCTO_RING

;;
; @param	a	Link's direction
forceLinkDirection:
	ld hl,w1Link.direction
	ld (hl),a
	jp setLinkForceStateToState08

;;
shootingGallery_initLinkPosition:
	ld a,$00
	ldbc $60,$50
	jr ++

;;
shootingGallery_initLinkPositionAfterGame:
	ld a,$01
	ldbc $68,$68
	jr ++

;;
shootingGallery_initLinkPositionAfterBiggoronGame:
	ld a,$03
	ldbc $68,$38
++
	ld hl,w1Link.yh
	ld (hl),b
	ld l,<w1Link.xh
	ld (hl),c

;;
setLinkToState08AndSetDirection:
	ld hl,w1Link.direction
	ld (hl),a

setLinkToState08:
	call putLinkOnGround
	jp setLinkForceStateToState08

;;
checkIsLinkedGameForScript:
	call checkIsLinkedGame
	jp _writeFlagsTocddb

;;
shootingGallery_checkIsNotLinkedGame:
	call checkIsLinkedGame
	call _writeFlagsTocddb
	cpl
	ld (wcddb),a
	ret

;;
; Makes an npc jump (speed: -$200)
beginJump:
	ld h,d
	ld l,Interaction.speedZ
	ld (hl),$00
	inc hl
	ld (hl),$fe
	ld a,SND_JUMP
	jp playSound

;;
; Updates gravity (uses gravity value $30). Bit 7 of cddb gets set when it lands.
updateGravity:
	ld c,$30
	call objectUpdateSpeedZ_paramC
	jp _writeFlagsTocddb

;;
; @param	a	Value to add to $ccd4
addToccd4:
	ld hl,wccd4
	jr ++

;;
addTocfc0:
	ld hl,wTmpcfc0.genericCutscene.state
++
	add (hl)
	ld (hl),a
	ret

shootingGalleryScript_humanNpc_gameDone:
	disableinput
	wait 40
	asm15 fadeoutToWhite
	checkpalettefadedone
	asm15 shootingGallery_restoreEquips
	asm15 shootingGallery_setEntranceTiles, $00
	asm15 shootingGallery_removeAllTargets
	asm15 clearAllItemsAndPutLinkOnGround
	asm15 shootingGallery_initLinkPositionAfterGame

	wait 20
	asm15 fadeinFromWhite
	checkpalettefadedone
	resetmusic
	wait 40

	asm15 shootingGallery_checkIsNotLinkedGame
	jumpifmemoryset wcddb, $80, @checkScoreForNormalGame
	jumpifitemobtained TREASURE_FLUTE, @normalGame
	jumpifglobalflagset GLOBALFLAG_CAN_BUY_FLUTE, @checkScoreForFluteGame

@normalGame:
	scriptjump @checkScoreForNormalGame

@checkScoreForFluteGame:
	asm15 shootingGallery_cpScore, $03
	jumpifmemoryset wcddb, $80, @flutePrize
	scriptjump @noPrize

@flutePrize:
	showtext TX_081b
	wait 30
	giveitem TREASURE_FLUTE, $00
	scriptjump @end

@checkScoreForNormalGame:
	asm15 shootingGallery_cpScore, $00
	jumpifmemoryset wcddb, $80, @ringPrize

	asm15 shootingGallery_cpScore, $01
	jumpifmemoryset wcddb, $80, @gashaSeedPrize

	asm15 shootingGallery_cpScore, $02
	jumpifmemoryset wcddb, $80, @thirtyRupeePrize

	asm15 shootingGallery_cpScore, $03
	jumpifmemoryset wcddb, $80, @oneHeartPrize

@noPrize:
	showtext TX_0819
	scriptjump @end

@ringPrize:
	showtext TX_0815
	wait 30
	asm15 shootingGallery_giveRandomRingToLink
	scriptjump @end

@gashaSeedPrize:
	showtext TX_0816
	wait 30
	giveitem TREASURE_GASHA_SEED, $00
	scriptjump @end

@thirtyRupeePrize:
	showtext TX_0817
	wait 30
	asm15 giveRupees, RUPEEVAL_30
	showtext TX_0005
	scriptjump @end

@oneHeartPrize:
	showtext TX_0818
	wait 30
	showtext TX_0051
	asm15 shootingGallery_giveOneHeart
@end:
	wait 30
	scriptend


shootingGalleryScript_goronNpc_gameDone:
	disableinput
	wait 40
	asm15 fadeoutToWhite
	checkpalettefadedone
	asm15 shootingGallery_restoreEquips
	asm15 shootingGallery_setEntranceTiles, $00
	asm15 shootingGallery_removeAllTargets
	asm15 clearAllItemsAndPutLinkOnGround
	asm15 shootingGallery_initLinkPositionAfterGame

	wait 20
	asm15 fadeinFromWhite
	checkpalettefadedone
	resetmusic
	wait 40

	jumpifroomflagset $20, @normalGame

; Playing for lava juice

	asm15 shootingGallery_cpScore, $07
	jumpifmemoryset wcddb, $80, @lavaJuicePrize
	showtext TX_24d9
	scriptjump @end

@lavaJuicePrize:
	showtext TX_24d8
	wait 30
	giveitem TREASURE_LAVA_JUICE, $00
	scriptjump @end

; Playing for normal prizes
@normalGame:
	asm15 shootingGallery_cpScore, $04
	jumpifmemoryset wcddb, $80, @boomerangPrize

	asm15 shootingGallery_cpScore, $05
	jumpifmemoryset wcddb, $80, @gashaSeedPrize

	asm15 shootingGallery_cpScore, $06
	jumpifmemoryset wcddb, $80, @twentyBombsPrize

	asm15 shootingGallery_cpScore, $07
	jumpifmemoryset wcddb, $80, @thirtyRupeesPrize

	; No prize
	showtext TX_24de
	scriptjump @end

@boomerangPrize:
	jumpifitemobtained TREASURE_BOOMERANG, @gashaSeedPrize
	showtext TX_24da
	wait 30
	giveitem TREASURE_BOOMERANG, $02
	scriptjump @end

@gashaSeedPrize:
	showtext TX_24db
	wait 30
	giveitem TREASURE_GASHA_SEED, $00
	scriptjump @end

@twentyBombsPrize:
	showtext TX_24dc
	wait 30
	giveitem TREASURE_BOMBS, $05
	scriptjump @end

@thirtyRupeesPrize:
	showtext TX_24dd
	wait 30
	asm15 giveRupees, RUPEEVAL_30
	showtext TX_0005

@end:
	wait 30
	scriptend


; ==============================================================================
; INTERACID_IMPA_IN_CUTSCENE
; ==============================================================================

;;
impa_moveLinkUp32Frames:
	ld a,$20
	ld (wLinkStateParameter),a
	xor a
	ld (w1Link.angle),a
	ld (w1Link.direction),a
	jr ++

;;
impa_moveLinkRight8Frames:
	ld a,$08
	ld (wLinkStateParameter),a
	ld a,$08
	ld (w1Link.angle),a
++
	ld a,LINK_STATE_FORCE_MOVEMENT
	ld (wLinkForceState),a
	ret

;;
; Resets impa's "oamTileIndexBase" to normal, after referencing a different sprite sheet.
; (Only used for subid 1; her "collapsed" sprite is in another sprite sheet.)
impa_restoreNormalSpriteSheet:
	ld e,Interaction.var3b
	ld a,(de)
	ld e,Interaction.oamTileIndexBase
	ld (de),a
	ld e,Interaction.oamFlags
	ld a,$02
	ld (de),a
	ret

;;
; Shows text index TX_0131 such that it's non-exitable (cutscene continues automatically)
impa_showZeldaKidnappedTextNonExitable:
	ld bc,TX_0131
	jp showTextNonExitable

impaScript_rockJustMoved:
	wait 4
	jumpifmemoryeq w1Link.angle, $08, @pushedRight

	; Pushed left: Impa needs to move down a bit
	setangle $10
	setspeed SPEED_040
	applyspeed 65
	scriptjump ++

@pushedRight:
	wait 65
++
	wait 120
	setangle $08
	setspeed SPEED_100
	applyspeed $21
	wait 8
	jumpifmemoryeq w1Link.angle, $08 ++

	; Pushed left: Impa needs to move back up
	moveup $11
	wait 8
++
	writememory wTmpcfc0.genericCutscene.cfd0, $07
	setanimation $00
	wait 30
	showtext TX_0109
	wait 30
	setspeed SPEED_080
	moveup $20
	scriptend


; Subid 4: cutscene at black tower entrance where Impa warns about Ralph's heritage
; (unlinked)
impaScript4:
	showtext TX_0124
	writememory w1Link.direction, DIR_UP
	wait 20
	xorcfc0bit 0
	spawninteraction INTERACID_NAYRU, $09, $f8, $48

	setspeed SPEED_100
	movedown $41
	wait 30

	checkobjectbyteeq Interaction.var38, $04
	writeobjectword Interaction.speedZ, -$180
	wait 1
	showtext TX_0125
	xorcfc0bit 1
	checkcfc0bit 2
	showtext TX_0126
	xorcfc0bit 3
	checkcfc0bit 4
	moveup $41
	scriptend

; Subid 4: like above, but for linked game
impaScript5:
	checkmemoryeq wTmpcfc0.genericCutscene.cfd0, $01
	setanimation $00
	checkmemoryeq wTmpcfc0.genericCutscene.cfd0, $02
	setanimation $03
	checkmemoryeq wTmpcfc0.genericCutscene.cfd0, $03
	setanimation $02
	checkobjectbyteeq Interaction.substate, $02

	writememory wTmpcfc0.genericCutscene.cfd0, $05
	setanimation $00
	wait 8
	writeobjectword Interaction.speedZ, -$180

	wait 1
	showtext TX_0125

	writememory wTmpcfc0.genericCutscene.cfd0, $06
	checkmemoryeq wTmpcfc0.genericCutscene.cfd0, $08
	wait 90
	writememory w1Link.direction, DIR_RIGHT
	setspeed SPEED_100
	moveup $21
	writememory w1Link.direction, DIR_UP
	moveleft $11
	moveup $41
	scriptend


; Subid 7: Impa tells you that Zelda's been kidnapped by vire (also handles the cutscene
; after saving Zelda)
impaScript7:
	initcollisions
	setspeed SPEED_100
	jumpifglobalflagset GLOBALFLAG_ZELDA_SAVED_FROM_VIRE, @zeldaSaved

@npcLoop:
	enableinput
	checkabutton
	disableinput
	turntofacelink
	jumpifglobalflagset GLOBALFLAG_IMPA_MOVED_AFTER_ZELDA_KIDNAPPED, @alreadyMoved

	showtext TX_0127
	setangle $18
	applyspeed $10
	setglobalflag GLOBALFLAG_IMPA_MOVED_AFTER_ZELDA_KIDNAPPED
	scriptjump @npcLoop

@alreadyMoved:
	showtext TX_0129
	scriptjump @npcLoop

@zeldaSaved:
	checkpalettefadedone
	writememory w1Link.xh, $50
	wait 60
	asm15 impa_moveLinkUp32Frames

@waitForLinkToMove1:
	wait 16
	jumpifmemoryeq w1Link.state, LINK_STATE_FORCE_MOVEMENT, @waitForLinkToMove1

	writememory w1Link.direction, $01
	asm15 impa_moveLinkRight8Frames
@waitForLinkToMove2:
	wait 16
	jumpifmemoryeq w1Link.state, LINK_STATE_FORCE_MOVEMENT, @waitForLinkToMove2

	writememory w1Link.direction, DIR_UP
	writememory wTmpcfc0.genericCutscene.cfd0, $01
	checkmemoryeq wTmpcfc0.genericCutscene.cfd0, $02
	setzspeed -$0200
	playsound SND_JUMP
	wait 1
	checkobjectbyteeq Interaction.zh, $00

	showtext TX_0128
	wait 30

	showtext TX_0603
	writememory wTmpcfc0.genericCutscene.cfd0, $03
	checkmemoryeq wTmpcfc0.genericCutscene.cfd0, $04
	writememory w1Link.direction, DIR_LEFT
	wait 30

	showtext TX_0604
	writememory wTmpcfc0.genericCutscene.cfd0, $05
	checkmemoryeq wTmpcfc0.genericCutscene.cfd0, $06
	writememory w1Link.direction, DIR_UP
	wait 30

	showtext TX_012a
	writememory wTmpcfc0.genericCutscene.cfd0, $07
	moveup $60

	writememory wTmpcfc0.genericCutscene.cfd0, $08
	writememory wScrollMode, $01
	setglobalflag GLOBALFLAG_GOT_RING_FROM_ZELDA
	scriptend


; ==============================================================================
; INTERACID_FAKE_OCTOROK
; ==============================================================================

greatFairyOctorok_createMagicPowderAnimation:
	ld a,SND_MAGIC_POWDER
	call playSound
	ld bc,$00f8
@next:
	call getFreePartSlot
	ret nz
	ld (hl),PARTID_SPARKLE
	ld l,Part.var03
	inc (hl)
	call objectCopyPositionWithOffset
	ld a,c
	add $08
	ld c,a
	cp $18
	jr nz,@next
	ret


; ==============================================================================
; INTERACID_CHILD
; ==============================================================================

;;
; @param	a	Value to add
child_addValueToChildStatus:
	ld hl,wChildStatus
	add (hl)
	ld (hl),a
	ret

child_checkHasRupees:
	call cpRupeeValue
	ld e,Interaction.var3c
	ld (de),a
	ret

;;
; Stores the response to the "love or courage" question.
child_setStage8ResponseToSelectedTextOption:
	ld hl,wSelectedTextOption
	add (hl)

;;
child_setStage8Response:
	ld (wChildStage8Response),a
	ret

;;
child_playMusic:
	ld a,(wChildStage8Response)
	or a
	jr nz,+
	ld a,MUS_ZELDA_SAVED
	jp playSound
+
	ld a,MUS_PRECREDITS
	jp playSound

;;
child_giveHeartRefill:
	ld c,$40
	jr ++

;;
child_giveOneHeart:
	ld c,$04
++
	ld a,TREASURE_HEART_REFILL
	jp giveTreasure

;;
; @param	a	Rupee value
child_giveRupees:
	ld c,a
	ld a,TREASURE_RUPEES
	jp giveTreasure


; ==============================================================================
; INTERACID_NAYRU
; ==============================================================================

; Subid $01: Cutscene in Ambi's palace after getting bombs
nayruScript01:
	checkmemoryeq wTmpcfc0.genericCutscene.cfd1, $05
	playsound MUS_LADX_SIDEVIEW
	wait 60

	asm15 objectSetVisible
	setspeed SPEED_100
	movedown $19
	wait 100

	showtext TX_1d01
	wait 30

	movedown $10
	wait 4
	moveright $10
	wait 4
	movedown $10
	wait 4
	moveleft $0a
	wait 60

	showtext TX_1d02
	wait 30
	showtext TX_1306
	writememory wTmpcfc0.genericCutscene.cfd1, $06
	checkmemoryeq wTmpcfc0.genericCutscene.cfd1, $07
	wait 30

	setanimation $06
	wait 120
	asm15 fadeoutToBlackWithDelay, $03
	checkpalettefadedone

	writememory wTextboxFlags, TEXTBOXFLAG_ALTPALETTE1
	showtext TX_1d03
	wait 30
	scriptend


; Subid $02: Nayru on maku tree screen after being saved
nayruScript02_part2:
	checkmemoryeq wTmpcfc0.genericCutscene.cfd0, $05
	disableinput
	wait 60
	showtext TX_1d07
	wait 60
	showtext TX_1d09
	wait 30

	writememory wTmpcfc0.genericCutscene.cfd0, $06
	setanimation $04
	playsound SNDCTRL_STOPMUSIC
	playsound SND_TUNE_OF_AGES
	wait 260

	spawninteraction INTERACID_PLAY_HARP_SONG, $02, $00, $00
	checkcfc0bit 7
	wait 45

	giveitem TREASURE_TUNE_OF_AGES, $00
	setanimation $02
	wait 30
	setdisabledobjectsto11
	wait 30
	writememory wTmpcfc0.genericCutscene.cfd0, $07
	scriptend


; Subid $03: Cutscene with Nayru and Ralph when Link exits the black tower
nayruScript03:
	wait 10

	setanimation $01
	setspeed SPEED_080
	setangle $18
	applyspeed $20
	checkmemoryeq w1Link.yh, $68

	writememory wUseSimulatedInput, $00
	disableinput
	wait 20

	moveright $10
	asm15 forceLinkDirection, DIR_LEFT
	wait 10

	showtext TX_1d0b
	wait 20
	writememory   wTmpcfc0.genericCutscene.cfd0, $02
	checkmemoryeq wTmpcfc0.genericCutscene.cfd0, $03

	asm15 forceLinkDirection, DIR_LEFT
	wait 10
	showtext TX_1d0c
	wait 40
	writememory wTmpcfc0.genericCutscene.cfd0, $04
	wait 16

	setspeed SPEED_100
	moveright $10
	wait 6

	movedown $28
	scriptend


; Subid $07: Cutscene with the vision of Nayru teaching you Tune of Echoes
nayruScript07:
	wait 12
	writememory wTextboxFlags, TEXTBOXFLAG_ALTPALETTE1
	showtext TX_1d10
	wait 16

	setanimation $07
	writeobjectbyte Interaction.direction, $07
	asm15 playSound, SND_TUNE_OF_ECHOES
	wait 210

	xorcfc0bit 0
	wait 75

	xorcfc0bit 0
	setanimation $02
	writeobjectbyte Interaction.direction, $02
	wait 16

	writememory wTextboxFlags, TEXTBOXFLAG_ALTPALETTE1
	showtext TX_1d11

	spawninteraction INTERACID_PLAY_HARP_SONG, $00, $00, $00
	checkcfc0bit 7
	wait 36

	writememory wTextboxFlags, TEXTBOXFLAG_ALTPALETTE1
	giveitem TREASURE_TUNE_OF_ECHOES, $00
	wait 16
	scriptend


; Subid $10: Cutscene in black tower where Nayru/Ralph meet you to try to escape
nayruScript10:
	checkpalettefadedone
	wait 30
	setspeed SPEED_100
	moveup $50
	moveleft $10
	writememory w1Link.direction, DIR_LEFT
	moveup $22
	setanimation $01
	wait 60

	showtextlowindex <TX_1d18
	wait 30

	setanimation $02
	writememory   w1Link.direction, DIR_DOWN
	writememory   wTmpcbb5, $01
	checkmemoryeq wTmpcbb5, $02
	wait 30

	writememory w1Link.direction, DIR_LEFT
	setanimation $01
	showtextlowindex <TX_1d19
	wait 30

	setanimation $02
	writememory w1Link.direction, DIR_DOWN
	writememory wTmpcbb5, $03
	wait 30

	writememory wTmpcbb5, $04
	movedown $52

	writeobjectbyte Interaction.yh, $08
	writeobjectbyte Interaction.xh, $70
	checkmemoryeq wTmpcbb5, $05
	checkpalettefadedone

	movedown $70
	showtextlowindex <TX_1d0e
	checktext

	setmusic      MUS_DISASTER
	writememory   wScreenShakeCounterY, 180
	writememory   wScreenShakeCounterX, 180
	writememory   wScrollMode, $01
	writememory   wTmpcbb5, $06
	checkmemoryeq wTmpcbb5, $07
	wait 20

	spawninteraction INTERACID_CLINK, $80, $74, $78
	playsound SND_SCENT_SEED
	setspeed SPEED_200
	movedown $18
	scriptend

; Subid $11: Cutscene on white background with Din just before facing Twinrova
nayruScript11:
	checkpalettefadedone
	wait 60
	setanimation $01
	wait 10
	asm15 forceLinkDirection, DIR_LEFT
	wait 10
	showtextlowindex <TX_1d1e
	wait 60
	showtextlowindex <TX_1d1f
	wait 30
	writememory wTmpcfc0.genericCutscene.cfd0, $01
	scriptend

; Subid $13: NPC singing to the animals after the game is complete
nayruScript13:
	initcollisions
@npcLoop:
	checkabutton
	disableinput
	wait 10
	writeobjectbyte Interaction.var39, $01
	asm15 turnToFaceLink
	wait 8
	showtextlowindex <TX_1d21
	wait 8
	setanimation $02
	enableinput
	wait 20
	writeobjectbyte Interaction.var39, $00
	setanimation $04
	scriptjump @npcLoop

;;
; Turns to face position value at $cfd5/$cfd6?
turnToFaceSomething:
	ld a,$0f

;;
turnToFaceSomethingAtInterval:
	ld b,a
	ld a,(wFrameCounter)
	and b
	ret nz
	callab agesInteractionsBank0a.func_0a_7877
	call objectGetRelativeAngle
	call convertAngleToDirection
	ld h,d
	ld l,Interaction.direction
	cp (hl)
	ret z
	ld (hl),a
	jp interactionSetAnimation

;;
; @param	a	Link's animation
setLinkAnimation:
	push de
	ld d,>w1Link
	call specialObjectSetAnimation
	pop de
	ret


; ==============================================================================
; INTERACID_RALPH
; ==============================================================================

;;
; Creates an instance of "INTERACID_SWORD", which will read the current object's
; animParameter in order to know when to produce a sword swing animation.
ralph_createLinkedSwordAnimation:
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERACID_SWORD
	ld l,Interaction.relatedObj1+1
	ld a,d
	ld (hl),a
	jp objectCopyPosition

;;
ralph_faceLinkAndCreateExclamationMark:
	call objectGetAngleTowardEnemyTarget
	add $04
	and $18
	swap a
	rlca
	call interactionSetAnimation
	ld a,$1e

;;
ralph_createExclamationMarkShiftedRight:
	ld bc,$f30d
	jp objectCreateExclamationMark

;;
; Begins a jump (speed: -$400)
ralph_beginHighJump:
	ld h,d
	ld l,Interaction.speedZ
	ld (hl),$00
	inc hl
	ld (hl),$fc
	ld a,SND_JUMP
	jp playSound

;;
ralph_updateGravity:
	ld c,$c0
	call objectUpdateSpeedZ_paramC
	jp _writeFlagsTocddb

;;
ralph_restoreMusic:
	ld a,MUS_OVERWORLD
	ld (wActiveMusic2),a
	ld (wActiveMusic),a
	jp playSound

;;
; Flashes the screen a few times when Ralph tries to attack Ambi?
ralph_flashScreen:
	call @func
	jp _writeFlagsTocddb

@func:
	ld a,(wTmpcfc0.genericCutscene.cfde)
	rst_jumpTable
	.dw @thing0
	.dw @thing1
	.dw @thing2
	.dw @thing3
	.dw @thing4

@thing0:
	ld a,$0a
	ld (wTmpcfc0.genericCutscene.cfdf),a
	call clearFadingPalettes

@inccfde:
	ld hl,wTmpcfc0.genericCutscene.cfde
	inc (hl)
	ret

@thing1:
@thing2:
	ld hl,wTmpcfc0.genericCutscene.cfdf
	dec (hl)
	ret nz
	ld a,$0a
	ld (wTmpcfc0.genericCutscene.cfdf),a
	call fastFadeoutToWhite
	jp @inccfde

@thing3:
	ld a,$14
	ld (wTmpcfc0.genericCutscene.cfdf),a
	call clearFadingPalettes
	jp @inccfde

@thing4:
	ld hl,wTmpcfc0.genericCutscene.cfdf
	dec (hl)
	ret

;;
ralph_flickerVisibility:
	ld b,$01
	jp objectFlickerVisibility

;;
ralph_decVar3f:
	ld h,d
	ld l,Interaction.var3f
	dec (hl)
	jp _writeFlagsTocddb


; Cutscene after Nayru is possessed
ralphSubid02Script:
	asm15 setLinkAnimation, LINK_ANIM_MODE_NONE
	wait 120

	showtext TX_2a02
	wait 30

	setspeed SPEED_020
	setangle $08
	applyspeed $81
	setanimation $08 ; Collapse animation
	wait 120
	showtext TX_2a03
	wait 120

	; Get back up, move toward cliff
	setanimation $09
	wait 10
	setanimation $0a
	wait 60
	setangle   $18
	setspeed   SPEED_020
	applyspeed $41
	setspeed   SPEED_040
	applyspeed $25
	wait 30

	; But now this!
	showtext TX_2a04
	wait 120
	writememory wTmpcfc0.genericCutscene.cfd0, $1e
	wait 60

	; I'll save you!
	setanimation $02
	showtext TX_2a05
	wait 30

	; Move right
	setspeed SPEED_200
	moveright $19
	setanimation $02
	playsound SND_BOOMERANG
	wait 120

	; NAYRUUUUUU
	showtext TX_2a06
	wait 30

	; Leave screen
	setspeed SPEED_300
	movedown $28
	wait 60

	writememory wTmpcfc0.genericCutscene.cfd0, $20
	scriptend


; Cutscene after talking to Rafton
ralphSubid03Script:
	wait 6
	setanimation $02
	wait 10
	showtext TX_2a0b
	wait 20

	setanimation $00
	wait 20
	showtext TX_2a06
	wait 10

	setspeed SPEED_200
	moveup $44

	playsound SNDCTRL_FAST_FADEOUT
	wait 30

	orroomflag $40
	enableinput
	scriptend


; Cutscene where Ralph tells you about getting Tune of Currents
ralphSubid0bScript:
	wait 90
	setmusic MUS_RALPH
	xorcfc0bit 0

	setspeed SPEED_200
	moveleft $30
	setsubstate $ff

	setspeed SPEED_100
	moveleft $20
	setspeed SPEED_080
	moveleft $20

	setsubstate $ff
	wait 30

	setspeed SPEED_100
	moveright $30

	setangleandanimation $00
	showtext TX_2a1a
	wait 30

	setspeed SPEED_200
	setsubstate $00
	moveright $38
	scriptjump _ralphEndCutscene


; Cutscene after talking to Cheval
ralphSubid10Script:
	wait 90

	setmusic MUS_RALPH
	xorcfc0bit 0
	setspeed  SPEED_200
	moveup $18
	setsubstate $ff
	setspeed  SPEED_100
	moveup $20
	setspeed  SPEED_080
	moveup $20
	setsubstate $ff
	wait 30

	showtext TX_2a20
	wait 30

	setspeed SPEED_200
	setsubstate $00
	movedown $38

_ralphEndCutscene:
	orroomflag $40
	wait 30
	resetmusic
	enableinput
	scriptend


; Cutscene where Ralph confronts Ambi in black tower
ralphSubid0cScript:
	initcollisions
	jumpifroomflagset $40, @alreadySawCutscene

	disableinput
	spawninteraction INTERACID_AMBI, $05, $3c, $78
	setmusic MUS_DISASTER
	wait 60

	playsound SND_SWORD_OBTAINED
	setanimation $04
	wait 60

	setspeed SPEED_080
	setangle $10
	xorcfc0bit 0
	applyspeed $11
	wait 20
	applyspeed $11
	wait 20
	applyspeed $11
	wait 40

	showtext TX_1313
	wait 30

	setspeed SPEED_200
	asm15 ralph_beginHighJump

@jumping:
	asm15 objectApplySpeed
	asm15 ralph_updateGravity
	jumpifmemoryset wcddb, $80, @landed
	scriptjump @jumping

@landed:
	wait 20
	showtext TX_2a1b
	wait 30

	setspeed SPEED_200
	setangle $00
	playsound SND_BEAM2
	applyspeed $0d

	playsound SND_LIGHTNING
	xorcfc0bit 1

@flashScreen:
	asm15 ralph_flashScreen
	jumpifmemoryset wcddb, $80, @doneFlashingScreen
	scriptjump @flashScreen

@doneFlashingScreen:
	setcoords $58, $60
	setanimation $0c
	asm15 fadeinFromWhiteWithDelay, $04
	checkpalettefadedone
	wait 30

	showtext TX_1314
	wait 30

	xorcfc0bit 2
	orroomflag $40
	checkcfc0bit 3
	resetmusic
	enableinput

	; Ralph now acts as an npc while he's collapsed
	checkabutton
	setanimation $0c
	asm15 turnToFaceLink
	showtext TX_2a1c
	wait 30
	setanimation $0c

@npcLoop:
	checkabutton
	showtext TX_2a1d
	scriptjump @npcLoop

@alreadySawCutscene:
	setcoords $58, $60
	setanimation $0c
	scriptjump @npcLoop


; ==============================================================================
; INTERACID_MONKEY
; ==============================================================================

;;
monkey_decideTextIndex:
	ld b,<TX_5708-8
	ld a,GLOBALFLAG_FINISHEDGAME
	call checkGlobalFlag
	jr z,+
	ld b,<TX_570d-8
+
	call getRandomNumber
	and $03
	add b
	add <TX_5708
	ld e,Interaction.textID
	ld (de),a
	ret

;;
monkey_turnToFaceLink:
	ld h,d
	ld l,Interaction.yh
	ld a,(w1Link.yh)
	cp (hl)
	ld a,$06
	jr nc,+
	dec a
+
	jp interactionSetAnimation

;;
monkey_setAnimationFromVar3a:
	ld e,Interaction.var3a
	ld a,(de)
	jp interactionSetAnimation


; ==============================================================================
; INTERACID_VILLAGER
; ==============================================================================

;;
villager_setLinkYToVar39:
	ld hl,w1Link.yh
	ld e,Interaction.var39
	ld a,(de)
	ld (hl),a
	ret

;;
; Creates a ball object for the purpose of a cutscene.
villager_createBallAccessory:
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERACID_ACCESSORY
	inc l
	ld (hl),$3f
	inc l
	ld (hl),$01

	ld l,Interaction.relatedObj1
	ld (hl),Interaction.start
	inc l
	ld (hl),d
	ret

;;
; Creates an actual ball that can be thrown by the villagers.
villager_createBall:
	ldbc INTERACID_BALL, $00
	call objectCreateInteraction
	ret nz
	ld bc,$4a3c
	jp interactionHSetPosition


; ==============================================================================
; INTERACID_BOY
; ==============================================================================

;;
; @param	a	Duration
createExclamationMark:
	ld bc,$f300
	jp objectCreateExclamationMark

;;
oscillateXRandomly:
	jpab agesInteractionsBank08.interactionOscillateXRandomly

;;
; Forces the next animation frame to be loaded; does something with var38 and $cfd3?
;
; @param	a	?
loadNextAnimationFrameAndMore:
	ld h,d
	ld l,Interaction.animCounter
	ld (hl),$01
	ld l,Interaction.var38
	dec (hl)
	ld (wTmpcfc0.genericCutscene.cfd3),a
	jp interactionAnimate

;;
; Creates lightning for the cutscene where the boy's father turns to stone.
;
; @param	a	Index of lightning to make (0-1)
boy_createLightning:
	ld b,a
	call getFreePartSlot
	ret nz
	ld (hl),PARTID_LIGHTNING
	inc l
	inc (hl)
	inc l
	inc (hl)
	ld a,b
	or a
	ld bc,$4838
	jr z,+
	ld bc,$2878
+
	ld l,Part.yh
	ld (hl),b
	ld l,Part.xh
	ld (hl),c
	ret

;;
; Updates the funny joke cutscene by determining whether to update Link's animation.
;
; Uses var3f as a counter until Link proceeds to the next animation;
; Uses var3e as the index of the current animation.
boy_runFunnyJokeCutscene:
	ld h,d
	ld l,Interaction.var3f
	dec (hl)
	ret nz

	ld l,Interaction.var3e
	ld a,(hl)
	cp $14
	call _writeFlagsTocddb
	ret z

	ld a,(hl)
	inc (hl)
	ld hl,@animations
	rst_addDoubleIndex
	ldi a,(hl)
	ld (wcc50),a ; Set Link animation
	ld a,(hl)
	ld e,Interaction.var3f
	ld (de),a
	ret

; Data format:
;   b0: Link's animation
;   b1: Number of frames to remain on that animation
@animations:
	.db $08 $14
	.db $09 $14
	.db $08 $14
	.db $09 $14
	.db $07 $14
	.db $0e $14
	.db $06 $14
	.db $1c $14
	.db $08 $14
	.db $09 $14
	.db $08 $14
	.db $08 $28
	.db $09 $32
	.db $07 $14
	.db $0e $14
	.db $06 $14
	.db $1c $14
	.db $08 $14
	.db $09 $14
	.db $08 $14
	.db $09 $14


; Depressed kid in trade sequence
boySubid07Script:
	initcollisions
	checkmemoryeq wMenuDisabled, $00 ; Wait for player to enter the room fully

	asm15 darkenRoomLightly
	checkpalettefadedone

@npcLoop:
	checkabutton
	disableinput
	jumpifroomflagset $20, @alreadyToldJoke
	jumpiftradeitemeq TRADEITEM_FUNNY_JOKE, @offerTrade

@showDepressedText:
	showtext TX_2517
	enableinput
	scriptjump @npcLoop

@offerTrade:
	showtext TX_2515
	wait 30
	jumpiftextoptioneq $00, @acceptedTrade
	scriptjump @showDepressedText

@acceptedTrade:
	writeobjectbyte Interaction.var3d, $01

	; Begin funny joke cutscene, wait for Link to return to normal
	asm15 moveLinkToPosition, $02
	wait 1
	checkmemoryeq w1Link.id, SPECIALOBJECTID_LINK

	writeobjectbyte Interaction.var3d, $00
	asm15 setLinkToState08AndSetDirection, DIR_DOWN
	wait 40

	setmusic MUS_CRAZY_DANCE
	wait 120

@funnyJokeCutsceneLoop:
	asm15 boy_runFunnyJokeCutscene
	jumpifmemoryset wcddb, $80, @doneFunnyJokeCutscene
	scriptjump @funnyJokeCutsceneLoop

@doneFunnyJokeCutscene:
	asm15 restartSound
	wait 40

	playsound SND_SWORD_OBTAINED
	writememory wcc50, LINK_ANIM_MODE_GETITEM2HAND
	wait 120

	asm15 setLinkToState08AndSetDirection, DIR_UP
	wait 30

	showtext TX_2516
	wait 30

	giveitem TREASURE_TRADEITEM, $08
	wait 30

	resetmusic
	enableinput
	scriptjump @npcLoop

@alreadyToldJoke:
	showtext TX_2518
	enableinput
	scriptjump @npcLoop


; ==============================================================================
; INTERACID_VERAN_GHOST
; ==============================================================================

;;
_ghostVeranApplySpeedUntilVar38Zero:
	ld h,d
	ld l,Interaction.var38
	dec (hl)
	ret z
	call objectApplySpeed
	jp objectApplySpeed


; Cutscene at start of game where Veran flies around the screen
ghostVeranSubid0Script_part1:
	wait 60
	writememory wTmpcfc0.genericCutscene.cfd0, $11
	wait 120
	setspeed SPEED_200

@movement0:
	setangle $1c
	playsound SND_SWORDSPIN
	writeobjectbyte Interaction.var38, $11
--
	asm15 _ghostVeranApplySpeedUntilVar38Zero
	wait 1
	jumpifobjectbyteeq Interaction.var38, $00, @movement1
	scriptjump --

@movement1:
	wait 8
	setangle $0b
	playsound SND_SWORDSPIN
	writeobjectbyte Interaction.var38, $25
--
	asm15 _ghostVeranApplySpeedUntilVar38Zero
	wait 1
	jumpifobjectbyteeq Interaction.var38, $00, @movement2
	scriptjump --

@movement2:
	wait 8
	setangle $18
	playsound SND_SWORDSPIN
	writeobjectbyte Interaction.var38, $13
--
	asm15 _ghostVeranApplySpeedUntilVar38Zero
	wait 1
	jumpifobjectbyteeq Interaction.var38, $00, @movement3
	scriptjump --

@movement3:
	wait 8
	setangle $02
	playsound SND_SWORDSPIN
	writeobjectbyte Interaction.var38, $19
--
	asm15 _ghostVeranApplySpeedUntilVar38Zero
	wait 1
	jumpifobjectbyteeq Interaction.var38, $00, @movement4
	scriptjump --

@movement4:
	wait 8
	setangle $0a
	playsound SND_SWORDSPIN
	writeobjectbyte Interaction.var38, $0c
--
	asm15 _ghostVeranApplySpeedUntilVar38Zero
	wait 1
	jumpifobjectbyteeq Interaction.var38, $00, @movement5
	scriptjump --

@movement5:
	wait 8
	setangle $14
	playsound SND_SWORDSPIN
	writeobjectbyte Interaction.var38, $11
--
	asm15 _ghostVeranApplySpeedUntilVar38Zero
	wait 1
	jumpifobjectbyteeq Interaction.var38, $00, @movement6
	scriptjump --

@movement6:
	wait 30
	writememory wTmpcfc0.genericCutscene.cfd1, $01
	wait 30
	setspeed SPEED_080

	setangle $0b
	applyspeed $50
	wait 30

	showtext TX_5602
	wait 30

	writememory wTmpcfc0.genericCutscene.cfd0, $12
	wait 120

	; Back up
	setspeed SPEED_040
	setangle $10
	applyspeed $29
	wait 60

	; Begin moving toward Nayru
	writeobjectbyte Interaction.xh, $78
	playsound SND_SWORDSPIN
	setspeed SPEED_300
	setangle $00
	writememory wTmpcfc0.genericCutscene.cfd0, $13
	applyspeed $22

	; Collision with Nayru
	playsound SND_KILLENEMY
	writememory wTmpcfc0.genericCutscene.cfd0, $14
	wait 60
	scriptend


; ==============================================================================
; INTERACID_SOLDIER
; ==============================================================================

;;
soldierSetSimulatedInputToEscortLink:
	or a
	jr nz,@exitPalace

	; When entering, calculate the difference from Link's x position to desired x
	ld a,(w1Link.xh)
	ld b,$60
	sub $50
	jr nc,++
	cpl
	inc a
	ld b,$50
++
	ld c,a
	push de

	ld hl,agesInteractionsBank09.linkEnterPalaceSimulatedInput
	ld a,:agesInteractionsBank09.linkEnterPalaceSimulatedInput
	call setSimulatedInputAddress

	pop de

	; Modify simulated input based on above calculations
	ld a,c
	rra
	add c
	ld (wSimulatedInputCounter),a
	ld a,b
	ld (wSimulatedInputValue),a

	xor a
	ld (wDisabledObjects),a
	ret

@exitPalace:
	push de
	ld hl,agesInteractionsBank09.linkExitPalaceSimulatedInput
	ld a,:agesInteractionsBank09.linkExitPalaceSimulatedInput
	call setSimulatedInputAddress
	pop de
	ret

;;
soldierGiveMysterySeeds:
	ld a,TREASURE_MYSTERY_SEEDS
	ld c,$00
	jp giveTreasure

;;
soldierUpdateMinimap:
	jpab bank1.checkUpdateDungeonMinimap

;;
soldierGetRandomVar32Val:
	call getRandomNumber
	and $03
	ld hl,@data
	rst_addAToHl
	ld a,(hl)
	ld e,Interaction.var32
	ld (de),a
	ld a,$59
	inc e
	ld (de),a
	ret

@data:
	.db $0d $0e $0f $0d

;;
soldierSetTextToShow:
	ld e,Interaction.var03
	ld a,(de)
	ld hl,@soldierTextIndices
	rst_addAToHl
	ld a,(hl)
	ld e,Interaction.textID
	ld (de),a
	ld a,>TX_5900
	inc e
	ld (de),a
	ret

@soldierTextIndices:
	.db <TX_5912, <TX_5913, <TX_5911, <TX_5910, <TX_5913, <TX_5911, <TX_5914, <TX_5913
	.db <TX_5915, <TX_5913, <TX_5912, <TX_5915, <TX_5913, <TX_5913, <TX_5912, <TX_5914


; Left palace guard
soldierSubid02Script:
	jumpifglobalflagset GLOBALFLAG_0b, @gotBombs
	jumpifitemobtained TREASURE_MYSTERY_SEEDS, @escortCutscene
	rungenericnpc TX_5903

@gotBombs:
	rungenericnpc TX_5909

@escortCutscene:
	disableinput
	asm15 forceLinkDirection, $00
	checkpalettefadedone
	wait 60
	setglobalflag GLOBALFLAG_10
	showtext TX_5904
	wait 30
	setanimation $00
	setspeed SPEED_100
	jumpifobjectbyteeq Interaction.xh, $48, @leftGuard

@rightGuard:
	setangle $1c
	scriptjump ++

@leftGuard:
	setangle $04
++
	asm15 soldierSetSimulatedInputToEscortLink, $00
	applyspeed $0b
	setangle $00
	applyspeed $80
	scriptend


; Red soldier that brings you to Ambi (escorts you from deku forest)
soldierSubid0aScript:
	checkmemoryeq w1Link.yh, $2a
	asm15 objectSetVisible82
	asm15 dropLinkHeldItem
	writememory wDisabledObjects, $01
	disablemenu
	wait 30
	setspeed SPEED_0c0
	moveright $4b
	wait 6
	setanimation $00
	wait 20
	asm15 createExclamationMark, $28
	wait 60
	setspeed SPEED_180
	moveup $1e
	wait 30
	showtext TX_590b
	wait 30
	orroomflag $40
	scriptend


; ==============================================================================
; INTERACID_TOKAY
; ==============================================================================

;;
tokayGame_resetRoomFlag40:
	call getThisRoomFlags
	res 6,(hl)
	ret

;;
tokayGame_resetRoomFlag80:
	call getThisRoomFlags
	res 7,(hl)
	ret

;;
; For wild tokay game, this sets var3d to 0 if Link has enough rupees, and determines the
; prize? (writes 5 to $cfdd if the prize will be a ring (1/8 chance), 4 otherwise?)
tokayGame_determinePrizeAndCheckRupees:
	ld h,d
	ld a,(wWildTokayGameLevel)
	cp $04
	jr nz,++
	call getRandomNumber
	and $07
	ld a,$04
	jr nz,++
	inc a
++
	ld (wTmpcfc0.wildTokay.cfdd),a

;;
tokayGame_checkRupees:
	ld a,(wTmpcfc0.wildTokay.cfdd)
	ld bc,@gfx
	call addAToBc
	ld a,(bc)
	ld h,d
	ld l,Interaction.var03
	ld (hl),a
	ld a,RUPEEVAL_10
	call cpRupeeValue
	ld e,Interaction.var3d
	ld (de),a
	ret

; This is the list of graphics indices for the prizes.
; Normally it's 4 (rupees) or 5 (ring)?
@gfx:
	.db $3e $2b $2c $0d $2d $0e

;;
tokayGame_createAccessoryForPrize:
	call interactionSetAnimation
	xor a
	ld e,Interaction.var3b
	ld (de),a

	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERACID_ACCESSORY
	inc l
	ld e,Interaction.var03
	ld a,(de)
	ld (hl),a
	ld l,Interaction.relatedObj1
	ld (hl),Interaction.enabled
	inc l
	ld (hl),d
	ret

;;
; Link jumps in the cutscene where he's robbed.
tokayMakeLinkJump:
	ld a,$81
	ld (wLinkInAir),a
	ld hl,w1Link.speedZ
	ld (hl),$00
	inc l
	ld (hl),$fe
	ld a,SND_JUMP
	jp playSound

;;
tokayGiveShieldUpgradeToLink:
	ld b,$01
	ld c,$01
	ld a,(wShieldLevel)
	cp $02
	jr c,+
	inc c
+
	call createTreasure
	ret nz
	ld de,w1Link.yh
	jp objectCopyPosition_rawAddress

;;
; Creates a treasure object at Link's position which he will immediately pick up.
tokayGiveItemToLink:
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERACID_TREASURE
	inc l
	ld e,Interaction.var03
	ld a,(de)
	ldi (hl),a ; [treasure.subid] = [tokay.var03] (treasure index)

	dec e
	ld b,$06
	ld a,(de)
	cp $06 ; Check [tokay.subid] == $06 (Tokay holding the sword)
	jr z,+
	ld b,$01
+
	ld (hl),b ; [treasure.var03] = b (index in treasureObjectData.s)

	; If [tokay.subid] == $0a (tokay holding seed satchel), return seeds and fix level
	cp $0a
	jr nz,++
	ld a,TREASURE_MYSTERY_SEEDS
	call giveTreasure
	call refillSeedSatchel
	push hl
	ld hl,wSeedSatchelLevel
	dec (hl)
	pop hl
++
	ld e,Interaction.counter1
	ld a,$03
	ld (de),a

	; Set treasure position to Link's.
	ld de,w1Link.yh
	jp objectCopyPosition_rawAddress

;;
tokayGame_givePrizeToLink:
	ld a,(wTmpcfc0.wildTokay.cfdd)
	cp $05
	jr z,@randomRing

	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERACID_TREASURE
	inc l
	ld a,(wWildTokayGameLevel)
	ld bc,@prizes
	call addDoubleIndexToBc
	ld a,(bc)
	ldi (hl),a
	inc bc
	ld a,(bc)
	ld (hl),a

	ld e,Interaction.counter1
	ld a,$03
	ld (de),a
	ld de,w1Link.yh
	call objectCopyPosition_rawAddress
	jr @incGameLevel

@randomRing:
	ld c,$02
	call getRandomRingOfGivenTier
	ld b,c
	ld c,$00
	call giveRingToLink

@incGameLevel:
	ld hl,wWildTokayGameLevel
	ld a,(hl)
	cp $04
	ret z
	inc (hl)
	ret

; List of prizes for each level of the tokay game. (You'll either get this, or a ring?)
@prizes:
	.db TREASURE_SCENT_SEEDLING, $00
	.db TREASURE_RUPEES, $0e
	.db TREASURE_RUPEES, $0f
	.db TREASURE_GASHA_SEED, $00
	.db TREASURE_RUPEES, $10

;;
; Searches for an interaction of type INTERACID_TOKAY_SHOP_ITEM, and stores the high byte
; of its address in var3f (or writes 0 if none is found).
tokayFindShopItem:
	ld e,Interaction.var3f
	xor a
	ld (de),a
	ld c,INTERACID_TOKAY_SHOP_ITEM
	call objectFindSameTypeObjectWithID
	ret nz
	ld (de),a
	ret

;;
; Sets var3f to the number of ember seeds you have.
tokayCheckHaveEmberSeeds:
	xor a
	ld e,Interaction.var3f
	ld (de),a
	ld a,TREASURE_EMBER_SEEDS
	call checkTreasureObtained
	ret nc
	or a
	ret z
	ld (de),a
	ret

;;
tokayDecNumEmberSeeds:
	ld a,$ff
	ld (wStatusBarNeedsRefresh),a
	ld a,(wNumEmberSeeds)
	sub $01
	daa
	ld (wNumEmberSeeds),a
	ret

;;
tokayTurnToFaceLink:
	call objectGetAngleTowardLink
	ld e,Interaction.angle
	add $04
	and $18
	ld (de),a

;;
_tokayUpdateAnimationFromAngle:
	call convertAngleDeToDirection
	jp interactionSetAnimation

;;
; Turn to the opposite direction.
tokayFlipDirection:
	ld e,Interaction.angle
	ld a,(de)
	xor $10
	ld (de),a
	jr _tokayUpdateAnimationFromAngle

;;
; Removes the seedling from Link's inventory, and sets flag on the present and past
; versions of the room to indicate that it's been planted.
tokayPlantScentSeedling:
	call getThisRoomFlags
	set 7,(hl)
	dec h
	set 7,(hl)
	ld a,TREASURE_SCENT_SEEDLING
	jp loseTreasure

;;
tokayGiveBombUpgrade:
	ld hl,wMaxBombs
	ld a,(hl)
	add $20
	ldd (hl),a
	ld (hl),a
	jp setStatusBarNeedsRefreshBit1

;;
tokayCreateExclamationMark:
	ld bc,$f3f3
	ld a,$1e
	jp objectCreateExclamationMark


; Subid $1d: NPC holding shield upgrade
tokayWithShieldUpgradeScript:
	initcollisions
@npcLoop:
	checkabutton
	disableinput
	jumpifroomflagset $40, @alreadyGaveShield

	; Give shield upgrade
	showtextlowindex <TX_0a68
	wait 30
	setanimation $02
	writeobjectbyte Interaction.var3b, $01
	asm15 tokayGiveShieldUpgradeToLink
	orroomflag $40
	wait 30

@alreadyGaveShield:
	showtextlowindex <TX_0a69
	enableinput
	scriptjump @npcLoop


; Subid $1e: Present NPC who talks to you after climbing down vine
tokayExplainingVinesScript:
	initcollisions
@npcLoop:
	enableinput
	setanimation $02
	checkabutton
	disableinput
	turntofacelink
	jumpifroomflagset $40, @vineNotGrown

	; Vine is grown properly
	orroomflag $40
	writeobjectbyte Interaction.var31, $00
	writememory w1Link.direction, $03
	asm15 tokayCreateExclamationMark
	writeobjectbyte Interaction.speedZ, $00
	writeobjectbyte Interaction.speedZ, $ff
	wait 30
	showtextlowindex <TX_0a6a
	scriptjump @npcLoop

@vineNotGrown:
	; Vine is not grown properly
	showtextlowindex <TX_0a6b
	scriptjump @npcLoop


; NPC who trades meat for stink bag (subid $05)
tokayCookScript:
	initcollisions
@npcLoop:
	checkabutton
	disableinput
	jumpifroomflagset $20, @alreadyTraded

	showtextlowindex <TX_0a00
	wait 30
	jumpiftradeitemeq TRADEITEM_STINK_BAG, @askForTrade

	showtextlowindex <TX_0a09
	enableinput
	scriptjump @npcLoop

@askForTrade:
	showtextlowindex <TX_0a01
	wait 30
	jumpiftextoptioneq $00, @acceptedTrade

	; Rejected trade
	showtextlowindex <TX_0a08
	enableinput
	scriptjump @npcLoop

@acceptedTrade:
	showtextlowindex <TX_0a02
	wait 30
	showtextlowindex <TX_0a03
	wait 30
	showtextlowindex <TX_0a04
	wait 30

	; Set var3f to nonzero as signal to start jumping around
	writeobjectbyte Interaction.var3f, $01
	showtextlowindex <TX_0a05

	; Wait for signal that he's back in his starting position
	checkobjectbyteeq Interaction.var3e, $00

	writeobjectbyte Interaction.var3f, $00
	wait 40
	showtextlowindex <TX_0a06
	wait 30

	giveitem TREASURE_TRADEITEM, $03
	enableinput
	scriptjump @npcLoop

@alreadyTraded:
	showtextlowindex <TX_0a07
	enableinput
	scriptjump @npcLoop


; ==============================================================================

;;
; This seems mostly identical to the "turntofacelink" script command, except it uses
; Link's actual position instead of the "hEnemyTargetY/X" variables.
turnToFaceLink:
	call objectGetAngleTowardLink
	call convertAngleToDirection
	jp interactionSetAnimation


; ==============================================================================
; INTERACID_AMBI
; ==============================================================================

ambiFlickerVisibility:
	ld b,$01
	jp objectFlickerVisibility

ambiDecVar3f:
	ld h,d
	ld l,Interaction.var3f
	dec (hl)
	jp _writeFlagsTocddb

;;
; Ambi rises by 4 pixels per frame until z-position = -$40
ambiRiseUntilOffScreen:
	ld e,Interaction.zh
	ld a,(de)
	sub $04
	ld (de),a
	cp $c0
	jp _writeFlagsTocddb


; The guy who you trade a dumbbell to for a mustache
dumbbellManScript:
	jumpifroomflagset $20, @liftingAnimation
	setanimation $00 ; Swaying animation
	scriptjump ++

@liftingAnimation:
	setanimation $01 ; Lifting animation
++
	initcollisions

@npcLoop:
	checkabutton
	disableinput
	jumpifroomflagset $20, @alreadyGaveMustache

	showtextlowindex <TX_0b1d
	wait 30
	showtextlowindex <TX_0b20
	wait 30
	jumpiftradeitemeq TRADEITEM_DUMBBELL, @offerTrade
	enableinput
	scriptjump @npcLoop

@offerTrade:
	showtextlowindex <TX_0b1e
	wait 30
	showtextlowindex <TX_0b20
	wait 30
	showtextlowindex <TX_0b1f
	wait 30
	showtextlowindex <TX_0b20
	wait 30
	showtextlowindex <TX_0b20
	wait 30
	showtextlowindex <TX_0b21
	wait 30
	jumpiftextoptioneq $00, @giveMustache

	; Declined trade
	showtextlowindex <TX_0b20
	enableinput
	scriptjump @npcLoop

@giveMustache:
	showtextlowindex <TX_0b22
	wait 30
	showtextlowindex <TX_0b20
	wait 30
	showtextlowindex <TX_0b23
	wait 30
	setanimation $01
	giveitem TREASURE_TRADEITEM, $06

@alreadyGaveMustache:
	showtextlowindex <TX_0b24
	wait 30
	enableinput
	scriptjump @npcLoop


; ==============================================================================
; INTERACID_OLD_MAN
; ==============================================================================

;;
oldManGiveShieldUpgradeToLink:
	ld a,TREASURE_SHIELD
	call checkTreasureObtained
	jr c,+
	ld a,(wShieldLevel)
+
	cp $03
	jr c,+
	ld a,$02
+
	ld c,a
	call getFreeInteractionSlot
	ret nz
	ld (hl),$60
	inc l
	ld (hl),$01
	inc l
	ld (hl),c
	push de
	ld de,w1Link.yh
	call objectCopyPosition_rawAddress
	pop de
	ret

;;
oldManWarpLinkToLibrary:
	ld hl,@warpDest
	call setWarpDestVariables
	ld a,SND_TELEPORT
	jp playSound

@warpDest:
	m_HardcodedWarpA ROOM_AGES_5ec, $00, $17, $03

;;
oldManSetAnimationToVar38:
	ld e,$78
_label_15_097:
	ld a,(de)
	jp interactionSetAnimation


; Subid $00: Old man who takes a secret to give you the shield (same spot as subid $02)
oldManScript_givesShieldUpgrade:
	jumpifglobalflagset GLOBALFLAG_FINISHEDGAME, ++
	scriptend
++
	initcollisions
	checkabutton
	disableinput
	jumpifglobalflagset GLOBALFLAG_DONE_LIBRARY_SECRET, @alreadyToldSecret

	; Ask if Link has a secret to tell
	showtext TX_3310
	wait 30

	jumpiftextoptioneq $00, @promptForSecret

	; Said "no"
	showtext TX_3311
	scriptjump @warpLinkOut

@promptForSecret:
	askforsecret LIBRARY_SECRET
	wait 30
	jumpifmemoryeq wTextInputResult, $00, @validSecret

	; Invalid secret
	showtext TX_3311
	scriptjump @warpLinkOut

@validSecret:
	setglobalflag GLOBALFLAG_BEGAN_LIBRARY_SECRET
	showtext TX_3312
	wait 30
	callscript mainScripts.scriptFunc_doEnergySwirlCutscene
	wait 30
	asm15 oldManGiveShieldUpgradeToLink
	wait 30

	setglobalflag GLOBALFLAG_DONE_LIBRARY_SECRET
	generatesecret LIBRARY_RETURN_SECRET
	showtext TX_3313
	scriptjump @warpLinkOut

@alreadyToldSecret:
	generatesecret LIBRARY_RETURN_SECRET
	showtext TX_3314

@warpLinkOut:
	wait 30
	asm15 oldManWarpLinkToLibrary
	enableinput
@wait:
	wait 1
	scriptjump @wait


; Subid $01: Old man who gives you book of seals
oldManScript_givesBookOfSeals:
	initcollisions
@npcLoop:
	enableinput
	checkabutton
	disableinput
	jumpifroomflagset $20, @alreadyGaveBook
	showtext TX_3308
	jumpifglobalflagset GLOBALFLAG_TALKED_TO_OCTOROK_FAIRY, @talkedToFairy
	scriptjump @npcLoop

@talkedToFairy:
	wait 30
	showtext TX_3309
	setangleandanimation $00
	wait 30
	orroomflag $20
	setangleandanimation $10
	wait 30
	giveitem TREASURE_BOOK_OF_SEALS, $00
	wait 1
	checktext
	enableinput
	scriptjump @npcLoop

@alreadyGaveBook:
	showtext TX_330a
	scriptjump @npcLoop


; Subid $02: Old man guarding fairy powder in past (same spot as subid $00)
oldManScript_givesFairyPowder:
	initcollisions
	checkabutton
	jumpifroomflagset $20, @alreadyGaveFairyPowder

	disableinput
	showtext TX_330b

	setangleandanimation $00
	wait 30

	orroomflag $20
	setangleandanimation $10
	wait 30

	giveitem TREASURE_FAIRY_POWDER, $00
	wait 1
	checktext

	showtext TX_330c
	checktext
	enablemenu
	scriptend

@alreadyGaveFairyPowder:
	showtext TX_330d
	checktext
	scriptend


; ==============================================================================
; INTERACID_MAMAMU_YAN
; ==============================================================================

mamamuYanRandomizeDogLocation:
	ld hl,wMamamuDogLocation
@loop:
	call getRandomNumber
	and $03
	cp (hl)
	jr z,@loop
	ld (hl),a
	ret

mamamuYanScript:
	jumpifglobalflagset GLOBALFLAG_FINISHEDGAME, +
	scriptjump @tradeScript
+
	jumpifroomflagset $20, @postgameScript

; This script runs if the game is not finished (or if you haven't traded with her yet).
@tradeScript:
	initcollisions
@npcLoop:
	checkabutton
	disableinput
	jumpifroomflagset $20, @alreadyGaveDoggieMask

	showtextlowindex <TX_0b16
	wait 30
	jumpiftradeitemeq TRADEITEM_DOGGIE_MASK, @askForTrade

	showtextlowindex <TX_0b17
	enableinput
	scriptjump @npcLoop

@askForTrade:
	showtextlowindex <TX_0b18
	wait 30
	jumpiftextoptioneq $00, @acceptedTrade

	; Declined trade
	showtextlowindex <TX_0b1b
	enableinput
	scriptjump @npcLoop

@acceptedTrade:
	showtextlowindex <TX_0b19
	wait 30
	giveitem TREASURE_TRADEITEM, $05
	wait 30
	showtextlowindex <TX_0b1a
	enableinput
	scriptjump @npcLoop

@alreadyGaveDoggieMask:
	showtextlowindex <TX_0b1c
	enableinput
	scriptjump @npcLoop


; This runs after beating the game (and after trading the doggie mask); after telling her
; a secret, Mamamu asks you to look for her dog.
@postgameScript:
	setcoords $28, $48
	initcollisions
	jumpifglobalflagset GLOBALFLAG_RETURNED_DOG, @dogFound

@postgameNpcLoop:
	checkabutton
	disableinput
	jumpifroomflagset $80, @alreadyBeganSearch
	jumpifglobalflagset GLOBALFLAG_BEGAN_MAMAMU_SECRET, @alreadyToldSecret
	showtextlowindex <TX_0b3a
	wait 30

	jumpiftextoptioneq $00, @promptForSecret

	showtextlowindex <TX_0b3b
	scriptjump @enableInputAndLoop

@promptForSecret:
	askforsecret MAMAMU_SECRET
	wait 30
	jumpifmemoryeq wTextInputResult, $00, @validSecret

	; Invalid secret
	showtextlowindex <TX_0b3d
	scriptjump @enableInputAndLoop

@validSecret:
	setglobalflag GLOBALFLAG_BEGAN_MAMAMU_SECRET
	showtextlowindex <TX_0b3c
	scriptjump @askedListenToRequest

; Link has told the secret already, but hasn't accepted the sidequest.
@alreadyToldSecret:
	showtextlowindex <TX_0b43
@askedListenToRequest:
	wait 30
	jumpiftextoptioneq $00, @acceptedRequest

	; Refused her request.
	showtextlowindex <TX_0b3e
	scriptjump @enableInputAndLoop

; Accepted her request
@acceptedRequest:
	showtextlowindex <TX_0b3f
	orroomflag $80
	asm15 mamamuYanRandomizeDogLocation
	scriptjump @enableInputAndLoop

@alreadyBeganSearch:
	showtextlowindex <TX_0b40

@enableInputAndLoop:
	enableinput
	scriptjump @postgameNpcLoop

@dogFound:
	jumpifroomflagset $40, @alreadyGaveReward

	disableinput
	asm15 forceLinkDirection, DIR_LEFT
	showtextlowindex <TX_0b41
	wait 30

	asm15 giveRingAToLink, SNOWSHOE_RING
	orroomflag $40
	wait 30

	showtextlowindex <TX_0b42
	enableinput
	scriptjump @genericNpc

@alreadyGaveReward:
	setcoords $1a, $18

@genericNpc:
	rungenericnpclowindex <TX_0b44


; ==============================================================================
; INTERACID_MAMAMU_DOG
; ==============================================================================

;;
; Reverse direction if x-position gets too high or low.
mamamuDog_checkReverseDirection:
	call objectApplySpeed
	ld e,Interaction.xh
	ld a,(de)
	sub $18
	cp $70
	ret c

	ld h,d
	ld l,Interaction.angle
	ld a,(hl)
	xor $10
	ld (hl),a
	ld b,$01
	jr ++

;;
mamamuDog_reverseDirection:
	ld b,$02
++
	ld h,d
	ld l,Interaction.var3f
	ld a,(hl)
	xor b
	ld (hl),a
	jp interactionSetAnimation

;;
mamamuDog_setCounterRandomly:
	call getRandomNumber
	and $07
	ld hl,_mamamuDog_randomCounterValues
	rst_addAToHl
	ld a,(hl)
	ld e,Interaction.var3e
	ld (de),a
	call _mamamuDog_hop

;;
mamamuDog_setZPositionTo0:
	ld h,d
	ld l,Interaction.z
	xor a
	ldi (hl),a
	ld (hl),a
	ret

_mamamuDog_randomCounterValues:
	.db $78 $b4 $f0 $ff $b4 $f0 $ff $ff


mamamuDog_updateSpeedZ:
	ld c,$20
	call objectUpdateSpeedZ_paramC
	ret nz

_mamamuDog_hop:
	ld bc,-$c0
	jp objectSetSpeedZ

mamamuDog_decCounter:
	ld h,d
	ld l,Interaction.var3e
	dec (hl)
	jp _writeFlagsTocddb


; ==============================================================================
; INTERACID_POSTMAN
; ==============================================================================
postmanScript:
	jumpifroomflagset $20, mainScripts.stubScript
	initcollisions
@npcLoop:
	checkabutton
	disableinput
	showtextlowindex <TX_0b03
	wait 30
	jumpiftradeitemeq TRADEITEM_POE_CLOCK, @promptForTrade
	scriptjump @enableInput

@promptForTrade:
	showtextlowindex <TX_0b04
	wait 30
	jumpiftextoptioneq $00, @acceptedTrade
	showtextlowindex <TX_0b06

@enableInput:
	enableinput
	scriptjump @npcLoop

@acceptedTrade:
	showtextlowindex <TX_0b05
	wait 30

	writeobjectbyte Interaction.var3f, $01 ; Change animation mode (don't face link)
	setspeed SPEED_200
	moveright $1d
	movedown $39
	wait 30

	giveitem TREASURE_TRADEITEM, $01
	enableinput
	scriptend


; ==============================================================================
; INTERACID_PICKAXE_WORKER
; ==============================================================================

;;
pickaxeWorker_setRandomDelay:
	call getRandomNumber_noPreserveVars
	and $1f
	sub $10
	add $3c
	ld e,Interaction.counter1
	ld (de),a
	ret

;;
pickaxeWorker_setAnimationFromVar03:
	ld e,Interaction.var03
	ld a,(de)
	ld hl,@animations
	rst_addAToHl
	ld a,(hl)
	jp interactionSetAnimation

@animations:
	.db $00 $01 $00 $01 $00 $01 $01 $01

;;
pickaxeWorker_chooseRandomBlackTowerText:
	call getRandomNumber
	and $07
	ld hl,@blackTowerText
	rst_addAToHl
	ld a,(hl)
	ld e,Interaction.textID
	ld (de),a
	ld a,>TX_1b00
	inc e
	ld (de),a
	ret

@blackTowerText:
	.db <TX_1b01
	.db <TX_1b02
	.db <TX_1b03
	.db <TX_1b04
	.db <TX_1b05
	.db <TX_1b01
	.db <TX_1b02
	.db <TX_1b03


pickaxeWorkerSubid01Script_part2:
	setcoords $55, $3e
	setanimation $07
	asm15 objectSetVisiblec1
	wait 60
	setspeed SPEED_040
	setangle $10
	applyspeed $14
	wait 10

	setangle $08
	applyspeed $30
	writeobjectbyte Interaction.var3f, $01
	wait 20

	writememory   wTmpcfc0.genericCutscene.state, $02
	checkmemoryeq wTmpcfc0.genericCutscene.state, $04

	writeobjectbyte Interaction.var3f, $00
	setangle $10
	scriptend


; ==============================================================================
; INTERACID_HARDHAT_WORKER
; ==============================================================================

;;
; Move Link away to make way for the hardhat worker to move right, if necessary.
hardhatWorker_moveLinkAway:
	call objectGetAngleTowardLink
	call convertAngleToDirection
	cp $01
	ret nz

	ld hl,w1Link.yh
	ld b,(hl)
	ld a,$48
	sub b
	ld b,a
	ld hl,@simulatedInput
	ld a,:@simulatedInput
	push de
	call setSimulatedInputAddress
	pop de

	; Move Link as far as necessary to get him to y position $48
	ld a,b
	ld (wSimulatedInputCounter),a
	ld a,BTN_DOWN
	ld (wSimulatedInputValue),a

	xor a
	ld (wDisabledObjects),a
	ret

@simulatedInput:
	dwb    10, $00
	dwb     1, BTN_UP
	dwb $7fff, $00
	.dw $ffff

;;
hardhatWorker_storeLinkVarsSomewhere:
	ld de,w1Link.yh
	call getShortPositionFromDE
	ld (wTmpcfc0.genericCutscene.cfd3),a
	ld e,<w1Link.direction
	ld a,(de)
	ld (wTmpcfc0.genericCutscene.cfd4),a
	ret

;;
soldierSetSpeed80AndVar3fTo01:
	ld h,d
	ld l,Interaction.speed
	ld (hl),SPEED_80
	ld l,Interaction.var3f
	ld (hl),$01
	ret

;;
hardhatWorker_setPatrolDirection:
	ld h,d
	ld l,Interaction.var3e
	ld (hl),a
	ld b,a
	swap a
	rrca
	ld l,Interaction.angle
	ld (hl),a
	ld a,b
	jp interactionSetAnimation

;;
hardhatWorker_setPatrolCounter:
	ld e,Interaction.var3c
	ld (de),a
	ret

;;
hardhatWorker_updatePatrolAnimation:
	ld e,Interaction.var3e
	ld a,(de)
	jp interactionSetAnimation

;;
hardhatWorker_decPatrolCounter:
	ld h,d
	ld l,Interaction.var3c
	dec (hl)
	jp _writeFlagsTocddb

;;
hardhatWorker_chooseTextForPatroller:
	ld e,Interaction.var03
	ld a,(de)
	cp $04
	jr z,+
	call getRandomNumber
	and $03
+
	ld hl,@textIDs
	rst_addAToHl
	ld a,(hl)
	ld e,Interaction.textID
	ld (de),a
	ld a,>TX_1000
	inc e
	ld (de),a
	ret

@textIDs:
	.db <TX_100a ; First 4 are randomly chosen values
	.db <TX_100b
	.db <TX_100c
	.db <TX_100c
	.db <TX_100d ; Last one is constant value for when [var03]==$04

;;
hardhatWorker_checkBlackTowerProgressIs00:
	call getBlackTowerProgress
	jp _writeFlagsTocddb

;;
hardhatWorker_checkBlackTowerProgressIs01:
	call getBlackTowerProgress
	cp $01
	jp _writeFlagsTocddb


; NPC who guards the entrance to the black tower.
hardhatWorkerSubid02Script:
	initcollisions
	jumpifroomflagset $80, @alreadySawCutscene
	jumpifroomflagset $40, @cutsceneAftermath

	checkabutton
	disableinput
	showtextlowindex <TX_1003
	wait 30

	orroomflag $40
	asm15 hardhatWorker_storeLinkVarsSomewhere
	writememory wGenericCutscene.cbb8, $00
	writememory wCutsceneTrigger, CUTSCENE_BLACK_TOWER_EXPLANATION
	scriptend

@cutsceneAftermath:
	disableinput
	asm15 turnToFaceLink
	checkpalettefadedone
	wait 60

	showtextlowindex <TX_1006
	asm15 hardhatWorker_moveLinkAway
	writeobjectbyte Interaction.var38, $01
	wait 30

	setspeed SPEED_080
	moveright $21
	writeobjectbyte Interaction.var38, $00
	wait 30

	orroomflag $80
	writememory wUseSimulatedInput, $00
	enableinput

@alreadySawCutscene:
	checkabutton
	showtextlowindex <TX_1004
	scriptjump @alreadySawCutscene


; A patrolling NPC.
hardhatWorkerSubid03Script:
	asm15 soldierSetSpeed80AndVar3fTo01
	asm15 hardhatWorker_chooseTextForPatroller
	initcollisions
	jumptable_objectbyte Interaction.var03
	.dw @val00
	.dw @val01
	.dw @val02
	.dw @val03
	.dw @val04

@val00:
	asm15 scriptHelp.hardhatWorker_setPatrolDirection, $02
	asm15 scriptHelp.hardhatWorker_setPatrolCounter,   $40
	callscript mainScripts.hardhatWorkerFunc_patrol

	asm15 scriptHelp.hardhatWorker_setPatrolDirection, $01
	asm15 scriptHelp.hardhatWorker_setPatrolCounter,   $60
	callscript mainScripts.hardhatWorkerFunc_patrol

	asm15 scriptHelp.hardhatWorker_setPatrolDirection, $03
	asm15 scriptHelp.hardhatWorker_setPatrolCounter,   $60
	callscript mainScripts.hardhatWorkerFunc_patrol

	asm15 scriptHelp.hardhatWorker_setPatrolDirection, $00
	asm15 scriptHelp.hardhatWorker_setPatrolCounter,   $40
	callscript mainScripts.hardhatWorkerFunc_patrol

	scriptjump @val00

@val01:
	asm15 scriptHelp.hardhatWorker_setPatrolDirection, $02
	asm15 scriptHelp.hardhatWorker_setPatrolCounter,   $40
	callscript mainScripts.hardhatWorkerFunc_patrol

	asm15 scriptHelp.hardhatWorker_setPatrolDirection, $01
	asm15 scriptHelp.hardhatWorker_setPatrolCounter,   $80
	callscript mainScripts.hardhatWorkerFunc_patrol

	asm15 scriptHelp.hardhatWorker_setPatrolDirection, $00
	asm15 scriptHelp.hardhatWorker_setPatrolCounter,   $20
	callscript mainScripts.hardhatWorkerFunc_patrol

	asm15 scriptHelp.hardhatWorker_setPatrolDirection, $02
	asm15 scriptHelp.hardhatWorker_setPatrolCounter,   $20
	callscript mainScripts.hardhatWorkerFunc_patrol

	asm15 scriptHelp.hardhatWorker_setPatrolDirection, $03
	asm15 scriptHelp.hardhatWorker_setPatrolCounter,   $80
	callscript mainScripts.hardhatWorkerFunc_patrol

	asm15 scriptHelp.hardhatWorker_setPatrolDirection, $00
	asm15 scriptHelp.hardhatWorker_setPatrolCounter,   $40
	callscript mainScripts.hardhatWorkerFunc_patrol

	scriptjump @val01

@val02:
	asm15 scriptHelp.hardhatWorker_setPatrolDirection, $01
	asm15 scriptHelp.hardhatWorker_setPatrolCounter,   $a0
	callscript mainScripts.hardhatWorkerFunc_patrol

	asm15 scriptHelp.hardhatWorker_setPatrolDirection, $03
	asm15 scriptHelp.hardhatWorker_setPatrolCounter,   $a0
	callscript mainScripts.hardhatWorkerFunc_patrol

	scriptjump @val02

@val03:
	asm15 scriptHelp.hardhatWorker_setPatrolDirection, $02
	asm15 scriptHelp.hardhatWorker_setPatrolCounter,   $40
	callscript mainScripts.hardhatWorkerFunc_patrol

	asm15 scriptHelp.hardhatWorker_setPatrolDirection, $01
	asm15 scriptHelp.hardhatWorker_setPatrolCounter,   $a0
	callscript mainScripts.hardhatWorkerFunc_patrol

	asm15 scriptHelp.hardhatWorker_setPatrolDirection, $03
	asm15 scriptHelp.hardhatWorker_setPatrolCounter,   $a0
	callscript mainScripts.hardhatWorkerFunc_patrol

	asm15 scriptHelp.hardhatWorker_setPatrolDirection, $00
	asm15 scriptHelp.hardhatWorker_setPatrolCounter,   $40
	callscript mainScripts.hardhatWorkerFunc_patrol

	scriptjump @val03

@val04:
	asm15 scriptHelp.hardhatWorker_setPatrolDirection, $01
	asm15 scriptHelp.hardhatWorker_setPatrolCounter,   $60
	callscript mainScripts.hardhatWorkerFunc_patrol

	asm15 scriptHelp.hardhatWorker_setPatrolDirection, $03
	asm15 scriptHelp.hardhatWorker_setPatrolCounter,   $60
	callscript mainScripts.hardhatWorkerFunc_patrol

	scriptjump @val04


; ==============================================================================
; INTERACID_POE
; ==============================================================================

;;
poe_decCounterAndFlickerVisibility:
	ld h,d
	ld l,Interaction.var3e
	ld a,(hl)
	or a
	call _writeFlagsTocddb
	jr z,@setVisible

	dec (hl)
	ld a,(wFrameCounter)
	rrca
	rrca
	jp nc,objectSetInvisible
@setVisible:
	jp objectSetVisible


; Ghost who starts the trade sequence.
poeScript:
	initcollisions
	checkabutton
	disableinput
	jumptable_objectbyte Interaction.var03
	.dw @firstMeeting
	.dw @inTomb
	.dw @lastMeeting

@firstMeeting:
	showtext TX_0b00
	orroomflag $40

@disappear:
	wait 40
	playsound SND_POOF
	writeobjectbyte Interaction.var3e, 30
@disappearLoop:
	asm15 poe_decCounterAndFlickerVisibility
	jumpifmemoryset wcddb, $80, @end
	scriptjump @disappearLoop
@end:
	enableinput
	scriptend


@inTomb:
	showtext TX_0b01
	orroomflag $40
	wait 30

	writeobjectbyte Interaction.var3f, $01 ; Don't face Link
	setspeed SPEED_100
	setanimation $02
	setangle $10
	applyspeed $49

	setanimation $01
	setangle $08
	applyspeed $39

	scriptjump @disappear


@lastMeeting:
	showtext TX_0b02
	wait 30
	giveitem TREASURE_TRADEITEM, $00
	scriptjump @disappear


; ==============================================================================
; INTERACID_OLD_ZORA
; ==============================================================================

; Zora who trades you the broken sword for a guitar.
oldZoraScript:
	initcollisions
@npcLoop:
	checkabutton
	disableinput
	jumpifroomflagset ROOMFLAG_ITEM, @alreadyGaveSword

	showtextlowindex <TX_0b33
	wait 30

	jumpiftradeitemeq TRADEITEM_SEA_UKELELE, @offerTrade

	showtextlowindex <TX_0b34
	scriptjump @enableInput

@offerTrade:
	showtextlowindex <TX_0b35
	wait 30

	jumpiftextoptioneq $00, @acceptedTrade
	showtextlowindex <TX_0b38
	scriptjump @enableInput

@acceptedTrade:
	showtextlowindex <TX_0b36
	wait 30
	giveitem TREASURE_TRADEITEM, $0b
	wait 30

	showtextlowindex <TX_0b37
	scriptjump @enableInput

@alreadyGaveSword:
	showtextlowindex <TX_0b39
@enableInput:
	enableinput
	scriptjump @npcLoop


; ==============================================================================
; INTERACID_TOILET_HAND
; ==============================================================================

;;
toiletHand_checkLinkIsClose:
	; Get Link's position in b?
	ld hl,w1Link.yh
	ldi a,(hl)
	add $04
	and $f0
	ld b,a
	inc l
	ld a,(hl)
	sub $04
	and $f0
	swap a
	or b

	ld b,a
	ld hl,@data
@loop:
	ldi a,(hl)
	or a
	scf
	jr z,++
	cp b
	jr nz,@loop
++
	jp _writeFlagsTocddb

@data: ; List of positions that are close to the toilet?
	.db $57 $68 $67 $00

;;
toiletHand_retreatIntoToiletIfNotAlready:
	; Check if already retreated
	ld e,Interaction.direction
	ld a,(de)
	cp $02
	ret z

;;
toiletHand_retreatIntoToilet:
	ld a,$02
	jr _toiletHand_setAnimation

;;
toiletHand_comeOutOfToilet:
	ld a,$01
	jr _toiletHand_setAnimation

;;
toiletHand_disappear:
	ld a,$00

;;
_toiletHand_setAnimation:
	ld e,Interaction.direction
	ld (de),a
	jp interactionSetAnimation

;;
toiletHand_checkVisibility:
	ld e,Interaction.visible
	ld a,(de)
	ld (wcddb),a
	ret


; ==============================================================================
; INTERACID_MASK_SALESMAN
; ==============================================================================

maskSalesmanScript:
	setcollisionradii $04, $06
	makeabuttonsensitive
@npcLoop:
	checkabutton
	disableinput
	jumpifroomflagset ROOMFLAG_ITEM, @alreadyGaveDoggieMask

	setanimation $00
	showtext TX_0b0d
	wait 15
	setanimation $01
	showtext TX_0b0e
	wait 15
	setanimation $00
	showtext TX_0b0f
	wait 15
	setanimation $01
	showtext TX_0b0e
	wait 30
	jumpiftradeitemeq TRADEITEM_TASTY_MEAT, @promptForTrade
	scriptjump @enableInput

@promptForTrade:
	showtext TX_0b10
	wait 30
	jumpiftextoptioneq $00, @acceptedTrade

	; Declined trade
	showtext TX_0b14
	scriptjump @enableInput

@acceptedTrade:
	showtext TX_0b45
	wait 15
	setanimation $00
	showtext TX_0b11
	wait 15
	setanimation $01
	showtext TX_0b12
	wait 15
	setanimation $00
	showtext TX_0b13
	wait 15
	setanimation $01
	showtext TX_0b45
	wait 30

	giveitem TREASURE_TRADEITEM,$04
	setanimation $00
	scriptjump @enableInput

@alreadyGaveDoggieMask:
	showtext TX_0b15

@enableInput:
	enableinput
	scriptjump @npcLoop


; ==============================================================================
; INTERACID_COMEDIAN
; ==============================================================================

;;
; Set var3f to:
;   $00 before beating d2
;   $01 after beating d2
;   $02 after beating moonlit grotto
comedian_checkGameProgress:
	ld a,(wEssencesObtained)
	call getHighestSetBit
	cp $03
	jr c,+
	ld a,$02
+
	ld e,Interaction.var3f
	ld (de),a
	ret


;;
; @param	a	Essence to check for
; @param[out]	zflag	z if essence obtained
checkEssenceObtained:
	call checkEssenceNotObtained
	cpl
	ld (wcddb),a
	ret

;;
; @param	a	Essence to check for
; @param[out]	zflag	z if essence not obtained
checkEssenceNotObtained:
	ld hl,wEssencesObtained
	call checkFlag
	jp _writeFlagsTocddb

;;
comedian_enableMustache:
	ld a,$04
	jr ++

;;
comedian_disableMustache:
	ld a,$00
++
	ld h,d
	ld l,Interaction.var37 ; Set animation base to enable/disable mustache
	ld (hl),a
	ld l,Interaction.var3e ; Force animation refresh next time
	ld (hl),$ff
	ret

;;
; Turn to face link, accounting for fact that he only faces left and right
comedian_turnToFaceLink:
	ld h,d
	ld l,Interaction.xh
	ld a,(w1Link.xh)
	cp (hl)
	ld a,$01
	jr nc,+
	xor a
+
	ld l,Interaction.var3e
	cp (hl)
	ret z
	ld (hl),a
	ld l,Interaction.var37 ; Add with "animation base"?
	add (hl)
	jp interactionSetAnimation

comedianScript:
	asm15 comedian_checkGameProgress
	jumpifroomflagset ROOMFLAG_ITEM, @hasMustache

	asm15 comedian_disableMustache
	setanimation $01
	scriptjump @initNpc

@hasMustache:
	asm15 comedian_enableMustache
	setanimation $05

@initNpc:
	initcollisions
@npcLoop:
	checkabutton
	disableinput
	jumpifroomflagset ROOMFLAG_ITEM, @alreadyGaveMustache
	jumptable_objectbyte Interaction.var3f
	.dw @beforeBeatD2
	.dw @afterBeatD2
	.dw @afterBeatMoonlitGrotto

@beforeBeatD2:
	showtextlowindex <TX_0b2c
	scriptjump @enableInput

@afterBeatD2:
	showtextlowindex <TX_0b2d
	scriptjump @enableInput

@afterBeatMoonlitGrotto:
	showtextlowindex <TX_0b2e
	wait 30
	jumpiftradeitemeq TRADEITEM_CHEESY_MUSTACHE, @promptForTrade
	scriptjump @noTrade

@promptForTrade:
	showtextlowindex <TX_0b2f
	wait 30
	jumpiftextoptioneq $00, @acceptedTrade

@noTrade:
	showtextlowindex <TX_0b31
	scriptjump @enableInput

@acceptedTrade:
	asm15 comedian_enableMustache
	showtextlowindex <TX_0b30
	wait 30
	giveitem TREASURE_TRADEITEM,$07
	scriptjump @enableInput

@alreadyGaveMustache:
	showtextlowindex <TX_0b32

@enableInput:
	wait 30
	enableinput
	scriptjump @npcLoop


; ==============================================================================
; INTERACID_GORON
; ==============================================================================

;;
goronDance_clearVariables:
	ld b,wTmpcfc0.goronDance.dataEnd - wTmpcfc0.goronDance
	ld hl,wTmpcfc0.goronDance
	call clearMemory

	ld a,DIR_DOWN
	ld (wTmpcfc0.goronDance.danceAnimation),a

	ld hl,w1Link.direction
	ld (hl),DIR_DOWN
	ld h,d
	ld l,Interaction.state
	ld (hl),$01
	inc l
	ld (hl),$00
	ret

;;
goronDance_restartGame:
	xor a
	ld (wTmpcfc0.goronDance.roundIndex),a
	ld (wTmpcfc0.goronDance.numFailedRounds),a
	ld hl,w1Link.direction
	ld (hl),DIR_DOWN
	ld b,$0a
	jpab agesInteractionsBank08.shootingGallery_initializeGameRounds

;;
; @param[out]	zflag	Set if in present (in wcddb)
goron_checkInPresent:
	ld a,(wTilesetFlags)
	and TILESETFLAG_PAST
	jp _writeFlagsTocddb

;;
; Unused?
; @param[out]	zflag	Set if in past (in wcddb)
goron_checkInPast:
	ld a,(wTilesetFlags)
	cpl
	and TILESETFLAG_PAST
	jp _writeFlagsTocddb

;;
goronDance_initLinkPosition:
	ld a,DIR_DOWN
	ld bc,$5c50
	jr _goron_setLinkPositionAndDirection

;;
goron_targetCarts_setLinkPositionToCartPlatform:
	ld a,DIR_UP
	ld bc,$8838
	jr _goron_setLinkPositionAndDirection

;;
goron_targetCarts_setLinkPositionAfterGame:
	ld a,DIR_RIGHT
	ld bc,$78a8
	jr _goron_setLinkPositionAndDirection

;;
goron_bigBang_initLinkPosition:
	ld a,DIR_UP
	ld bc,$4850

_goron_setLinkPositionAndDirection:
	ld hl,w1Link.direction
	ld (hl),a
	ld l,<w1Link.yh
	ld (hl),b
	ld l,<w1Link.xh
	ld (hl),c

;;
goron_putLinkInState08:
	call putLinkOnGround
	jp setLinkForceStateToState08

;;
; Updates wTextNumberSubstitution with number of completed rounds.
;
; @param[out]	zflag	z if didn't fail any rounds (in wcddb)
goronDance_checkNumFailedRounds:
	ld a,(wTmpcfc0.goronDance.numFailedRounds)
	ld b,a
	ld a,$08
	sub b
	ld hl,wTextNumberSubstitution
	ld (hl),a

	inc hl
	ld (hl),$00
	ld a,(wTmpcfc0.goronDance.numFailedRounds)
	or a
	jp _writeFlagsTocddb

;;
; Give the reward for a perfect game at platinum or gold level.
goronDance_giveRandomRingPrize:
	ld a,(wTilesetFlags)
	and TILESETFLAG_PAST
	jr nz,@past
	ld b,$02
	jr @giveRingForLevel
@past:
	ld b,$00
	ld a,(wTmpcfc0.goronDance.danceLevel)
	cp $00
	jr z,@giveRingForLevel
	ld b,$02

@giveRingForLevel:
	call getRandomNumber
	and $01
	add b
	ld hl,@rings
	rst_addAToHl
	ld a,(hl)
	jp giveRingAToLink

@rings:
	.db BOMBERS_RING,   PROTECTION_RING ; Platinum level
	.db BOMBPROOF_RING, GREEN_HOLY_RING ; Gold level

;;
; Shows text, and adds $20 to the index if in the present.
goron_showText_differentForPresent:
	ld c,a
	ld a,(wTilesetFlags)
	and TILESETFLAG_PAST
	call z,@add20
	ld b,>TX_2400
	jp showText

@add20:
	ld a,c
	add $20
	ld c,a
	ret

;;
; Show a text index. Starts with index $24XX where XX is passed in, then adds to that:
; * If unlinked in the past:    $00
; * If in the present:          $10
; * If linked in the past:      $20
;
; @param	a	Base text index (TX_24XX)
goron_decideTextToShow_differentForLinkedInPast:
	ld c,a
	call checkIsLinkedGame
	jr nz,@linked
	ld a,(wTilesetFlags)
	and TILESETFLAG_PAST
	jr z,@showPresentText
	jr @showText

@showPresentText:
	ld a,c
	add $10
	ld c,a
@showText:
	ld b,>TX_2400
	jp showText

@linked:
	ld a,(wTilesetFlags)
	and TILESETFLAG_PAST
	jr z,@showPresentText

	ld a,c
	add $20
	ld c,a
	jr @showText

;;
; Shows a text index, but adds $0c to the text index if in the present.
goron_showText_differentForPast:
	ld c,a
	ld a,(wTilesetFlags)
	and TILESETFLAG_PAST
	call z,@add0c
	ld b,>TX_2400
	jp showText

@add0c:
	ld a,c
	add $0c
	ld c,a
	ret

;;
goron_showTextForGoronWorriedAboutElder:
	ld a,GLOBALFLAG_SAVED_GORON_ELDER
	call checkGlobalFlag
	jr nz,+
	ld c,<TX_2479
	jr ++
+
	ld c,<TX_247a
++
	ld b,>TX_2400
	jp showText

;;
; Show text for a goron in the same cave as the elder, but in a different screen? They
; just comment on the state of affairs after you've saved the elder or not.
goron_showTextForSubid05:
	ld e,Interaction.var03
	ld a,(de)
	cp $03
	jr nc,@3OrHigher

	ld a,GLOBALFLAG_SAVED_GORON_ELDER
	call checkGlobalFlag
	ld b,$00
	jr z,+
	ld b,$01
+
	ld e,Interaction.var03
	ld a,(de)
	rlca
	jr @showText

@3OrHigher:
	ld b,$03
@showText:
	add b
	ld hl,@text
	rst_addAToHl
	ld b,>TX_2400
	ld c,(hl)
	jp showText

@text:
	.db <TX_2482
	.db <TX_2483
	.db <TX_2484
	.db <TX_2485
	.db <TX_2486
	.db <TX_24e3
	.db <TX_24e2
	.db <TX_24e3
	.db <TX_24e5

;;
; Determines value for Interaction.textID depending on game status...
;
; If textID ends up being $ff after calling this, the goron deletes itself.
;
; If in past, there are 3 states:
;   $00: before saving elder
;   $01: after saving elder
;   $02: after beating game
;
; If in present, there are 4 states:
;   $00: before beating d4
;   $01: after beating d4
;   $02: after beating King Moblin
;   $03: after beating game
goron_determineTextForGenericNpc:
	call @getGameState
	jp @determineTextID


; Writes value from $00-$02 (past) or $00-$03 (present) representing game state to var3e.
@getGameState:
	ld a,(wTilesetFlags)
	and TILESETFLAG_PAST
	jr z,@inPresent

@inPast:
	ld a,GLOBALFLAG_FINISHEDGAME
	call checkGlobalFlag
	jr nz,@val02

	ld a,GLOBALFLAG_SAVED_GORON_ELDER
	call checkGlobalFlag
	jr nz,@val01
	jr @val00

@inPresent:
	ld a,GLOBALFLAG_FINISHEDGAME
	call checkGlobalFlag
	jr nz,@val03

	ld a,GLOBALFLAG_MOBLINS_KEEP_DESTROYED
	call checkGlobalFlag
	jr nz,@val02

	ld a,$03
	ld hl,wEssencesObtained
	call checkFlag
	jr nz,@val01

@val00:
	xor a
	jr @writeVal
@val01:
	ld a,$01
	jr @writeVal
@val02:
	ld a,$02
	jr @writeVal
@val03:
	ld a,$03
@writeVal:
	ld e,Interaction.var3b
	ld (de),a
	ret

@determineTextID:
	ld e,Interaction.subid
	ld a,(de)
	sub $0c
	ld hl,@textTable
	rst_addAToHl
	ld a,(hl)
	rst_addAToHl

	ld e,Interaction.var03
	ld a,(de)
	rlca
	rst_addDoubleIndex
	ld e,Interaction.var3b
	ld a,(de)
	rst_addAToHl
	ld a,(hl)
	ld e,Interaction.textID
	ld (de),a
	ld b,a

	inc e
	ld a,>TX_3100
	ld (de),a

	ld a,b
	cp <TX_3127
	ret nz
	call checkIsLinkedGame
	ret nz

	ld a,$ff
	dec e
	ld (de),a
	ret

@textTable:
	.db @subid0c-CADDR
	.db @subid0d-CADDR
	.db @subid0e-CADDR

; Each row has 4 bytes:
;   b0: text before saving elder (past) or before beating d4 (present)
;   b1: text after saving elder (past) or after beating d4 (present)
;   b2: text after beating game (past) or after beating King Moblin (present)
;   b3: text after beating game (present)
; Value $ff means the goron will delete itself.
@subid0e:
	.db $00 $ff $ff $ff ; 0x00 == [var03]
	.db $ff $01 $01 $01 ; 0x01
	.db $ff $02 $02 $02 ; 0x02
	.db $ff $ff $03 $04 ; 0x03
	.db $ff $ff $05 $05 ; 0x04
	.db $ff $ff $06 $06 ; 0x05
	.db $ff $ff $07 $08 ; 0x06
	.db $09 $0a $0a $00 ; 0x07
	.db $ff $0b $0b $00 ; 0x08
	.db $ff $0c $0d $00 ; 0x09
	.db $ff $0e $0f $00 ; 0x0a

@subid0d:
	.db $ff $10 $11 $12 ; 0x00
	.db $ff $13 $14 $ff ; 0x01
	.db $ff $15 $15 $16 ; 0x02
	.db $1a $1a $1b $00 ; 0x03
	.db $ff $1c $1d $00 ; 0x04

@subid0c:
	.db $ff $1e $1f $20 ; 0x00
	.db $ff $ff $21 $22 ; 0x01
	.db $ff $ff $23 $23 ; 0x02
	.db $ff $ff $24 $24 ; 0x03
	.db $ff $25 $26 $00 ; 0x04
	.db $ff $27 $ff $00 ; 0x05
	.db $ff $ff $17 $18 ; 0x06
	.db $ff $ff $19 $19 ; 0x07


;;
; Goron naps if Link is far away, gets up when he approaches.
;
; @param[out]	cflag	nc if Link is within 12 pixels (in wcddb)
goron_checkShouldBeNapping:
	ld bc,$1818
	call objectSetCollideRadii
	call objectCheckCollidedWithLink_ignoreZ
	ccf
	call _writeFlagsTocddb
	ld bc,$0606
	jp objectSetCollideRadii

;;
; Get up from a nap?
goron_faceDown:
	ld h,d
	ld l,Interaction.invincibilityCounter
	ld (hl),$00
	ld l,Interaction.angle
	ld (hl),$10
	ld l,Interaction.var3f
	ld (hl),$00
	ld a,$02
	jp interactionSetAnimation

;;
; Set animation and set var3f to $01?
goron_setAnimation:
	ld h,d
	ld l,Interaction.var3f
	ld (hl),$01
	jp interactionSetAnimation

;;
goron_beginWalkingLeft:
	ld h,d
	ld l,Interaction.speed
	ld (hl),SPEED_80
	ld l,Interaction.angle
	ld (hl),$18
	ld l,Interaction.var3c
	ld (hl),$40
	inc l
	ld (hl),$00
	ld l,Interaction.var3f
	ld (hl),$01
	ld a,$03
	ld e,Interaction.var3e
	ld (de),a
	jp interactionSetAnimation

;;
goron_reverseWalkingDirection:
	ld h,d
	ld l,Interaction.var3c
	ld (hl),$80
	inc l
	ld (hl),$00
	ld l,Interaction.angle
	ld a,(hl)
	xor $10
	ld (hl),a
	ld l,Interaction.var3e
	ld a,(hl)
	xor $02
	ld (hl),a
	jp interactionSetAnimation

;;
goron_refreshWalkingAnimation:
	ld e,Interaction.var3e
	ld a,(de)
	jp interactionSetAnimation

;;
goron_setSpeedToMoveDown:
	ld h,d
	ld l,Interaction.speed
	ld (hl),SPEED_100
	ld l,Interaction.angle
	ld (hl),$10
	ld a,$02
	jp goron_setAnimation

;;
; @param[out]	zflag	z if Link's Y is same as this (in wcddb)
goron_cpLinkY:
	xor a
	ld hl,w1Link.yh
	add (hl)
	jr ++

;;
goron_cpYTo60:
	ld a,$60
++
	ld h,d
	ld l,Interaction.yh
	cp (hl)
	jp _writeFlagsTocddb

;;
; @param[out]	zflag	z if Goron's X is Link's X minus 14 (in wcddb)
goron_checkReachedLinkHorizontally:
	ld a,$f2
	ld hl,w1Link.xh
	add (hl)
	jr ++

;;
goron_cpXTo48:
	ld a,$48
++
	ld h,d
	ld l,Interaction.xh
	cp (hl)
	jp _writeFlagsTocddb

;;
; @param[out]	cflag	c if Link approached with bomb flower (in wcddb}
goron_checkLinkApproachedWithBombFlower:
	ld a,TREASURE_BOMB_FLOWER
	call checkTreasureObtained
	call _writeFlagsTocddb
	ret nc

	; Store old Y/X position, replace with position we want to see Link cross
	ld h,d
	ld l,Interaction.yh
	ld a,(hl)
	ld (hl),$88
	push af
	ld l,Interaction.xh
	ld a,(hl)
	ld (hl),$58
	push af

	ld bc,$1808
	call objectSetCollideRadii
	call objectCheckCollidedWithLink_ignoreZ
	call _writeFlagsTocddb
	ld bc,$0606
	call objectSetCollideRadii

	; Restore old Y/X position
	pop af
	ld h,d
	ld l,Interaction.xh
	ld (hl),a
	pop af
	ld l,Interaction.yh
	ld (hl),a
	ret

;;
; Decrement var3c as a word (16 bits).
; @param[out]	zflag	z when var3c/3d hits 0
goron_decMovementCounter:
	ld h,d
	ld l,Interaction.var3c
	call decHlRef16WithCap
	jp _writeFlagsTocddb

;;
goron_initCountersForBombFlowerExplosion:
	ld h,d
	ld l,Interaction.var3c
	ld (hl),90
	inc l
	ld (hl),$00
	ld l,Interaction.var3e
	ld (hl),$01
	ret

;;
goron_countdownToPlayRockSoundAndShakeScreen:
	ld h,d
	ld l,Interaction.var3e
	dec (hl)
	ret nz
	ld (hl),$05
	ld a,SND_BREAK_ROCK
	call playSound
	ld a,$04
	jp setScreenShakeCounter

;;
goron_createFallingRockSpawner:
	ld b,INTERACID_FALLING_ROCK
	jp objectCreateInteractionWithSubid00

;;
; Replaces the rock barrier in the goron cave with clear tiles.
goron_clearRockBarrier:
	ld hl,@clearedTiles

	ld c,$31
	call @clearRow

	ld c,$41
	call @clearRow

	ld c,$51
@clearRow:
	ld a,$05
@nextTile:
	ldh (<hFF8B),a
	ldi a,(hl)
	push bc
	push hl
	call setTile
	pop hl
	pop bc
	inc c
	ldh a,(<hFF8B)
	dec a
	jr nz,@nextTile
	ret

; This is the 5x3 rectangle of tiles to write over the rock barrier.
@clearedTiles:
	.db $a2 $a1 $a2 $a1 $a2
	.db $a1 $a2 $a1 $a2 $a1
	.db $a2 $a1 $a2 $a1 $a2

;;
goron_createRockDebrisToLeft:
	ld bc,$f6fa
	jr ++

;;
; Creates 4 "rock debris" things?
goron_createRockDebrisToRight:
	ld bc,$f606
++
	call getRandomNumber
	and $01
	ldh (<hFF8D),a
	xor a
@nextRock:
	ldh (<hFF8B),a
	call getFreeInteractionSlot
	jr nz,@end
	ld (hl),INTERACID_FALLING_ROCK
	inc l
	ld (hl),$02
	inc l
	ld (hl),$01

	ld l,Interaction.counter1
	ldh a,(<hFF8D)
	ld (hl),a
	ld l,Interaction.angle
	ldh a,(<hFF8B)
	ld (hl),a

	call objectCopyPositionWithOffset

	ldh a,(<hFF8B)
	inc a
	cp $04
	jr nz,@nextRock
@end:
	ld a,SND_BREAK_ROCK
	jp playSound

;;
; Tries to take 20 ember seeds and bombs from Link.
; @param[out]	zflag	z if Link had the items (in wcddb)
goron_tryTakeEmberSeedsAndBombs:
	ld a,TREASURE_SEED_SATCHEL
	call checkTreasureObtained
	jr nc,@dontGiveItems
	ld a,TREASURE_EMBER_SEEDS
	call checkTreasureObtained
	jr nc,@dontGiveItems

	cp $20
	jr c,@dontGiveItems
	push af
	ld a,TREASURE_BOMBS
	call checkTreasureObtained
	jr nc,@popAndDontGiveItems
	cp $20
	jr c,@popAndDontGiveItems

	sub $20
	daa
	ld (wNumBombs),a
	pop af
	sub $20
	daa
	ld (wNumEmberSeeds),a
	call setStatusBarNeedsRefreshBit1
	xor a
	jp _writeFlagsTocddb

@popAndDontGiveItems:
	pop af
@dontGiveItems:
	or d
	jp _writeFlagsTocddb

;;
; @param[out]	zflag	z if enough time passed for goron to finish breaking the cave
;			(in wcddb). (Uses tree refill system.)
goron_checkEnoughTimePassed:
	ld a,(wSeedTreeRefilledBitset)
	cpl
	bit 0,a
	call _writeFlagsTocddb

;;
; Clear the bit used by the goron breaking down the cave that tracks progress (same system
; used as the one which refills trees).
goron_clearRefillBit:
	ld hl,wSeedTreeRefilledBitset
	res 0,(hl)
	ret

;;
; Spawns the prize in the "display area" just before starting the minigame.
goron_targetCarts_spawnPrize:
	call getThisRoomFlags
	bit ROOMFLAG_BIT_ITEM,(hl)
	jr nz,@alreadyGotBrisket

	xor a
	jr @spawnPrize

@alreadyGotBrisket:
	call getRandomNumber
	and $0f
	ld hl,@possiblePrizes
	rst_addAToHl
	ld a,(hl)

	; Only give boomerang if not obtained already
	cp $04
	jr nz,@spawnPrize
	ld a,TREASURE_BOOMERANG
	call checkTreasureObtained
	ld a,$04
	jr nc,@spawnPrize

	ld a,$03

@spawnPrize:
	ld (wTmpcfc0.targetCarts.prizeIndex),a
	ld hl,@prizes
	rst_addDoubleIndex
	ld b,(hl)
	inc l
	ld c,(hl)
	call getFreeInteractionSlot
	ret nz

	ld (hl),INTERACID_TREASURE
	inc l
	ld (hl),b
	inc l
	ld (hl),c
	ld l,Interaction.yh
	ld (hl),$78
	ld l,Interaction.xh
	ld (hl),$78
	ret

@possiblePrizes:
	.db $01 $01 $01 $01 $01 $01 $01 $01
	.db $02 $02 $02 $03 $03 $04 $04 $04

@prizes:
	.db TREASURE_ROCK_BRISKET, $01
	.db TREASURE_RUPEES,       $11
	.db TREASURE_RUPEES,       $12
	.db TREASURE_GASHA_SEED,   $06
	.db TREASURE_BOOMERANG,    $01

;;
; Spawns the prize shown by the goron just before starting the minigame.
goron_bigBang_spawnPrize:
	call getThisRoomFlags
	bit 5,(hl)
	jr nz,@alreadyGotMermaidKey

	xor a
	jr @checkSpawnPrize

@alreadyGotMermaidKey:
	call getRandomNumber
	and $0f
	ld hl,@possiblePrizes
	rst_addAToHl
	ld a,(hl)

@checkSpawnPrize:
	; If random number is 4, choose randomly between the 2 rings
	cp $04
	jr nz,@spawnPrize
	call getRandomNumber
	and $01
	add $04

@spawnPrize:
	ld (wTmpcfc0.bigBangGame.prizeIndex),a
	ld hl,@prizes
	rst_addDoubleIndex
	ld b,(hl)
	inc l
	ld c,(hl)
	call getFreeInteractionSlot
	ret nz

	ld (hl),INTERACID_TREASURE
	inc l
	ld (hl),b
	inc l
	ld (hl),c
	ld l,Interaction.yh
	ld (hl),$38
	ld l,Interaction.xh
	ld (hl),$50
	ld l,Interaction.zh
	ld (hl),$f0
	ret

@possiblePrizes:
	.db $01 $01 $01 $02 $02 $02 $02 $02
	.db $02 $02 $02 $02 $02 $03 $03 $04

@prizes:
	.db TREASURE_MERMAID_KEY, $01
	.db TREASURE_RUPEES,      $12
	.db TREASURE_RUPEES,      $13
	.db TREASURE_GASHA_SEED,  $06
	.db TREASURE_RING,        $12
	.db TREASURE_RING,        $13


;;
; Delete a treasure on the screen. Used during bomb flower explosion, for removing the
; displayed treasure when starting target carts, ...
goron_deleteTreasure:
	ld b,INTERACID_TREASURE
	call _goron_findInteractionWithID
	ld l,Interaction.state
	ld (hl),$04 ; State 4 causes deletion
	ret

;;
goron_targetCarts_deleteMinecartAndClearStaticObjects:
	ld b,INTERACID_MINECART
	call _goron_findInteractionWithID
	push de
	ld e,l
	ld d,h
	call objectDelete_de
	pop de
	jp clearStaticObjects

;;
; @param	b	ID to match
; @param[out]	zflag	z if match found
_goron_findInteractionWithID:
	ldhl FIRST_DYNAMIC_INTERACTION_INDEX, Interaction.enabled
@loop:
	ld a,(hl)
	or a
	jr z,@next
	inc l
	ldd a,(hl)
	cp b
	jr nz,@next
	xor a
	ret
@next:
	inc h
	ld a,h
	cp LAST_INTERACTION_INDEX+1
	jr c,@loop
	or h
	ret


;;
goron_targetCarts_deleteCrystals:
	ldhl FIRST_ENEMY_INDEX, Enemy.enabled
@loop:
	ld a,(hl)
	or a
	jr z,@nextEnemy
	inc l
	ldd a,(hl)
	cp ENEMYID_TARGET_CART_CRYSTAL
	jr nz,@nextEnemy
	push de
	push hl
	ld e,l
	ld d,h
	call objectDelete_de
	ld hl,wNumEnemies
	dec (hl)
	pop hl
	pop de
@nextEnemy:
	inc h
	ld a,h
	cp LAST_ENEMY_INDEX+1
	jr c,@loop
	ret

;;
goron_targetCarts_beginGame:
	xor a
	ld (wTmpcfc0.targetCarts.beginGameTrigger),a
	ld (wTmpcfc0.targetCarts.crystalsHitInFirstRoom),a
	ld (wTmpcfc0.targetCarts.numTargetsHit),a
	ld (wTmpcfc0.targetCarts.cfdc),a
	jp _goron_targetCarts_setPlayingFlag

;;
goron_targetCarts_endGame:
	jp _goron_targetCarts_clearPlayingFlag

;;
_goron_targetCarts_setPlayingFlag:
	call getThisRoomFlags
	set 7,(hl)
	ret

;;
_goron_targetCarts_clearPlayingFlag:
	call getThisRoomFlags
	res 7,(hl)
	ret

;;
; @param[out]	zflag	z if Link has landed on the ground (in wcddb)
goron_checkLinkNotInAir:
	ld a,(wLinkInAir)
	bit 7,a
	jp _writeFlagsTocddb

;;
goron_checkLinkInAir:
	ld a,(wLinkInAir)
	or a
	jp _writeFlagsTocddb

;;
goron_targetCarts_setupNumTargetsHitText:
	ld a,(wTmpcfc0.targetCarts.numTargetsHit)
	add $00
	daa
	ld hl,wTextNumberSubstitution
	ld (hl),a
	inc hl
	ld (hl),$00
	ret

;;
; @param[out]	zflag	z if hit exactly 12 targets (in wcddb)
goron_targetCarts_checkHitAllTargets:
	ld a,(wTmpcfc0.targetCarts.numTargetsHit)
	cp $0c
	jp _writeFlagsTocddb

;;
; @param[out]	cflag	c if hit less than 9 targets (in wcddb)
goron_targetCarts_checkHit9OrMoreTargets:
	ld a,(wTmpcfc0.targetCarts.numTargetsHit)
	cp $09
	ccf
	jp _writeFlagsTocddb

;;
; Save Link's current inventory status, and equip the seed shooter with scent seeds
; equipped.
goron_targetCarts_configureInventory:
	ld bc,wInventoryB
	ld hl,wTmpcfc0.targetCarts.savedBItem
	ld a,(bc)
	ldi (hl),a
	ld a,(wInventoryA)
	cp ITEMID_SHOOTER
	jr nz,@equipToA

@equipToB:
	xor a
	ld (bc),a
	inc c
	ld a,(bc)
	ldi (hl),a
	ld a,ITEMID_SHOOTER
	ld (bc),a
	jr @setupSeedShooter

@equipToA:
	ld a,ITEMID_SHOOTER
	ld (bc),a
	inc c
	ld a,(bc)
	ldi (hl),a
	xor a
	ld (bc),a

@setupSeedShooter:
	; Save Link's scent seed count to $cfd9, then give him 99 seeds for the game
	ld c,<wNumScentSeeds
	ld a,(bc)
	ldi (hl),a
	ld a,$99
	ld (bc),a

	; Save currently selected seeds to $cfda, then equip scent seeds
	ld c,<wShooterSelectedSeeds
	ld a,(bc)
	ldi (hl),a
	ld a,$01
	ld (bc),a

	ld a,$ff
	ld (wStatusBarNeedsRefresh),a
	ret

;;
goron_targetCarts_restoreInventory:
	ld bc,wInventoryB
	ld hl,wTmpcfc0.targetCarts.savedBItem
	ldi a,(hl)
	ld (bc),a
	inc c
	ldi a,(hl)
	ld (bc),a

	ld c,<wNumScentSeeds
	ldi a,(hl)
	ld (bc),a

	ld c,<wShooterSelectedSeeds
	ldi a,(hl)
	ld (bc),a

	ld a,$ff
	ld (wStatusBarNeedsRefresh),a
	ret

;;
goron_targetCarts_loadCrystals:
	call getThisRoomFlags
	bit 5,(hl)
	ld a,$00
	jr z,++
	call getRandomNumber
	and $01
	inc a
++
	ld (wTmpcfc0.targetCarts.targetConfiguration),a
	ld hl,objectData.targetCartCrystals
	jp parseGivenObjectData

;;
; Reload only those crystals that weren't hit in the first room.
goron_targetCarts_reloadCrystalsInFirstRoom:
	xor a
@loop:
	ldh (<hFF8B),a
	ld hl,wTmpcfc0.targetCarts.crystalsHitInFirstRoom
	call checkFlag
	jr nz,@nextCrystal

	call getFreeEnemySlot
	ldh a,(<hFF8B)
	ld (hl),ENEMYID_TARGET_CART_CRYSTAL
	inc l
	ld (hl),a
@nextCrystal:
	ldh a,(<hFF8B)
	inc a
	cp $05
	jr nz,@loop
	ret

;;
; Writes a value to Interaction.var3e:
; * $02 before getting lava juice
; * $01 after getting lava juice
; * $00 after getting mermaid key
goron_checkGracefulGoronQuestStatus:
	ld a,TREASURE_LAVA_JUICE
	call checkTreasureObtained
	jr nc,@noLavaJuice
	ld a,TREASURE_MERMAID_KEY
	call checkTreasureObtained
	jr nc,@noMermaidKey

	xor a
	jr @writeByte

@noLavaJuice:
	ld a,$02
	jr @writeByte

@noMermaidKey:
	ld a,$01
@writeByte:
	ld e,Interaction.var3e
	ld (de),a
	ret

.ifndef REGION_JP
;;
goron_showTextForClairvoyantGoron:
	ld b,$00
	ld a,(wEssencesObtained)
	bit 5,a
	jr nz,@finishedRollingRidgeSidequest

	; Loop through list of treasures that indicate what the next tip should be
	ld hl,@treasures
@nextTreasure:
	inc b
	ldi a,(hl)
	call checkTreasureObtained
	jr c,@finishedRollingRidgeSidequest
	ld a,b
	cp $08
	jr nz,@nextTreasure

@finishedRollingRidgeSidequest:
	; If tip is for goron letter, need to check for lava juice and present
	; mermaid key simultaneously, since they can be gotten in either order?
	ld a,b
	cp $03
	jr nz,++
	ld a,TREASURE_LAVA_JUICE
	call checkTreasureObtained
	jr nc,@showTipForItem
	ld b,$09
	jr @showTipForItem
++
	; Check the status of the "big bang game" room to see whether you've given the
	; goronade to the goron?
	cp $05
	jr c,@showTipForItem
	push bc
	ld a,$03
	ld b,$3e
	call getRoomFlags
	pop bc
	bit 6,(hl)
	jr z,@showTipForItem
	ld b,$0a

@showTipForItem:
	; 'b' should be an index indicating an item to give a tip for?
	ld a,(wTilesetFlags)
	and TILESETFLAG_PAST
	jr z,@present

@past:
	ld a,<TX_3143
	add b
	ld b,>TX_3100
	ld c,a
	jp showText

@present:
	ld a,<TX_314f
	add b
	ld b,>TX_3100
	ld c,a
	jp showText

@treasures:
	.db TREASURE_OLD_MERMAID_KEY
	.db TREASURE_GORON_LETTER
	.db TREASURE_MERMAID_KEY
	.db TREASURE_GORONADE
	.db TREASURE_GORON_VASE
	.db TREASURE_ROCK_BRISKET
	.db TREASURE_BROTHER_EMBLEM

.endif ; REGION_US, REGION_EU

;;
; Big bang npc: set collision radius to 0 and make him invisible.
;
; What a hack.
goron_bigBang_hideSelf:
	ld h,d
	ld l,Interaction.var3e
	ld (hl),$01
	xor a
	ld l,Interaction.collisionRadiusY
	ldi (hl),a
	ld (hl),a
	jp objectSetInvisible

;;
goron_bigBang_unhideSelf:
	ld h,d
	ld l,Interaction.var3e
	ld (hl),$00
	ld a,$06
	ld l,Interaction.collisionRadiusY
	ldi (hl),a
	ld (hl),a
	jp objectSetVisible

;;
goron_bigBang_checkLinkHitByBomb:
	ld a,(w1Link.invincibilityCounter)
	or a
	call _writeFlagsTocddb
	cpl
	ld (wcddb),a
	ret

;;
goron_bigBang_createBombSpawner:
	call getFreePartSlot
	ret nz
	ld (hl),PARTID_BIGBANG_BOMB_SPAWNER
	inc l
	ld (hl),$ff
	ret

;;
goron_createBombFlowerSprite:
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERACID_TREASURE
	inc l
	ld (hl),TREASURE_BOMB_FLOWER
	inc l
	ld (hl),$01
	ld l,Interaction.yh
	ld (hl),$60
	ld l,Interaction.xh
	ld (hl),$38
	ret

;;
; When var3a counts down to 0, this creates some explosions.
goron_countdownToNextExplosionGroup:
	ld h,d
	ld l,Interaction.var3a
	dec (hl)
	ret nz

	; var3b is the index for the "explosion group".
	ld l,Interaction.var3b
	ld a,(hl)
	inc a
	and $07
	ld (hl),a
	ldh (<hFF8B),a

	ld bc,@counters
	call addAToBc
	ld a,(bc)
	ld l,Interaction.var3a
	ld (hl),a

	ldh a,(<hFF8B)
	add a
	ld bc,@explosionIndices
	call addDoubleIndexToBc
	ld a,$04
@next:
	ldh (<hFF8D),a
	ld a,(bc)
	cp $ff
	ret z
	push bc
	call goron_createExplosionIndex
	pop bc
	inc bc
	ldh a,(<hFF8D)
	dec a
	jr nz,@next
	ret

; Values to set var3a to (counter until next group of explosions occur)
@counters:
	.db $0b $0b $0b $16 $0b $0b $0b $0b

; Each row is a group of explosion indices ($ff to stop).
@explosionIndices:
	.db $01 $02 $ff $ff
	.db $03 $06 $ff $ff
	.db $04 $05 $ff $ff
	.db $07 $ff $ff $ff
	.db $03 $06 $ff $ff
	.db $04 $05 $ff $ff
	.db $01 $02 $ff $ff
	.db $00 $ff $ff $ff

;;
; Used with bomb flower cutscene.
; @param	a	Index of the explosion (determines position to put it at)
goron_createExplosionIndex:
	ld bc,@positions
	call addDoubleIndexToBc
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERACID_EXPLOSION
	ld l,Interaction.yh
	ld a,(bc)
	ld (hl),a
	inc bc
	ld l,Interaction.xh
	ld a,(bc)
	ld (hl),a
	ret

@positions:
	.db $60 $38
	.db $48 $28
	.db $48 $48
	.db $38 $18
	.db $38 $58
	.db $58 $18
	.db $58 $58
	.db $40 $38


;;
; Load a layout for the big bang game.
goron_bigBang_loadMinigameLayout1_topHalf:
	ld hl,_goron_bigBang_minigameLayout1_topHalf
	ld c,$11
	jr _goron_bigBang_loadRoomLayout

goron_bigBang_loadMinigameLayout1_bottomHalf:
	ld hl,_goron_bigBang_minigameLayout1_bottomHalf
	ld c,$41
	jr _goron_bigBang_loadRoomLayout

goron_bigBang_loadMinigameLayout2_topHalf:
	ld hl,_goron_bigBang_minigameLayout2_topHalf
	ld c,$11
	jr _goron_bigBang_loadRoomLayout

goron_bigBang_loadMinigameLayout2_bottomHalf:
	ld hl,_goron_bigBang_minigameLayout2_bottomHalf
	ld c,$41
	jr _goron_bigBang_loadRoomLayout

goron_bigBang_loadNormalRoomLayout_topHalf:
	ld hl,_goron_bigBang_normalRoomLayout
	ld c,$11
	jr _goron_bigBang_loadRoomLayout

goron_bigBang_loadNormalRoomLayout_bottomHalf:
	ld hl,_goron_bigBang_normalRoomLayout
	ld c,$41

;;
; @param	hl	Tile data to load
; @param	c	Tile position to start loading at
_goron_bigBang_loadRoomLayout:
	ld a,$03
@nextRow:
	ldh (<hFF93),a
	ld a,$08
@nextColumn:
	ldh (<hFF92),a
	ldi a,(hl)
	push hl
	call setTile
	pop hl
	inc c
	ldh a,(<hFF92)
	dec a
	jr nz,@nextColumn
	ld a,c
	add $08
	ld c,a
	ldh a,(<hFF93)
	dec a
	jr nz,@nextRow
	ret


_goron_bigBang_minigameLayout1_topHalf:
	.db $17 $57 $57 $57 $55 $55 $55 $56
	.db $56 $57 $57 $54 $54 $17 $55 $56
	.db $55 $55 $54 $54 $54 $54 $57 $57
_goron_bigBang_minigameLayout1_bottomHalf:
	.db $55 $17 $56 $56 $56 $56 $57 $17
	.db $54 $57 $57 $56 $17 $55 $55 $54
	.db $57 $57 $57 $57 $55 $55 $55 $54

_goron_bigBang_minigameLayout2_topHalf:
	.db $56 $54 $56 $54 $56 $17 $56 $54
	.db $56 $54 $17 $54 $56 $54 $56 $54
	.db $56 $54 $56 $54 $56 $54 $17 $54
_goron_bigBang_minigameLayout2_bottomHalf:
	.db $54 $56 $54 $56 $54 $56 $54 $56
	.db $54 $56 $54 $56 $17 $56 $54 $56
	.db $54 $17 $54 $56 $54 $56 $54 $56

_goron_bigBang_normalRoomLayout:
	.db $ef $ef $ef $ef $ef $ef $ef $ef
	.db $ef $ef $ef $ef $ef $ef $ef $ef
	.db $ef $ef $ef $ef $ef $ef $ef $ef

;;
; @param	a	$00 to restore exit, $04 to block it
goron_bigBang_blockOrRestoreExit:
	ld hl,@tileData
	rst_addAToHl
	ld c,$73
@next:
	ldi a,(hl)
	push hl
	call setTile
	pop hl
	inc c
	ld a,c
	cp $77
	jr nz,@next
	ret

@tileData:
	.db $b5 $ef $ef $b4 ; $00: Restore exit
	.db $b2 $b2 $b2 $b2 ; $04: Block exit


goron_subid08_pressedAScript:
	disableinput
	writeobjectbyte Interaction.pressedAButton, $00
	jumpifroomflagset $40, @alreadyTraded
	jumpifroomflagset $80, @alreadyMovedAside

	asm15 goron_showText_differentForPast, <TX_2490
	wait 30
	jumpifitemobtained TREASURE_BROTHER_EMBLEM, @moveAside

	asm15 goron_showText_differentForPast, <TX_2491
	scriptjump mainScripts.goron_enableInputAndResumeNappingLoop

; Link has the goron emblem, move aside
@moveAside:
	asm15 goron_showText_differentForPast, <TX_2492
	wait 30

	setspeed SPEED_080
	asm15 goron_setAnimation, $03
	setangle $18
	applyspeed $21

	setanimation $02
	wait 30

	asm15 goron_showText_differentForPast, <TX_2493
	wait 30

	orroomflag $80
	asm15 goron_checkInPresent
	jumpifmemoryset wcddb, CPU_ZFLAG, @checkSirloin_1

; Check goron vase
	jumpifitemobtained TREASURE_GORON_VASE, @haveVaseOrSirloin
	scriptjump mainScripts.goron_enableInputAndResumeNappingLoop

@checkSirloin_1:
	jumpifitemobtained TREASURE_ROCK_BRISKET, @haveVaseOrSirloin
	scriptjump mainScripts.goron_enableInputAndResumeNappingLoop


@alreadyMovedAside:
	; Check if already talked to him once (this gets cleared if you leave the screen?)
	jumpifmemoryeq wTmpcfc0.goronCutscenes.goronGuardMovedAside, $01, @promptForTradeAfterRejection

	asm15 goron_showText_differentForPast, <TX_2494
	wait 30

	asm15 goron_checkInPresent
	jumpifmemoryset wcddb, CPU_ZFLAG, @checkSirloin_2

; Check goron vase
	jumpifitemobtained TREASURE_GORON_VASE, @haveVaseOrSirloin
	scriptjump @dontHaveVaseOrSirloin

@checkSirloin_2:
	jumpifitemobtained TREASURE_ROCK_BRISKET, @haveVaseOrSirloin

@dontHaveVaseOrSirloin:
	asm15 goron_showText_differentForPast, <TX_2495 ; "Yeah, a vase/sirloin would be great"
	scriptjump mainScripts.goron_enableInputAndResumeNappingLoop


@haveVaseOrSirloin:
	asm15 goron_showText_differentForPast <TX_2496
	wait 30
	jumpiftextoptioneq $00, @acceptedTrade

@rejectedTrade:
	asm15 goron_showText_differentForPast, <TX_2497
	writememory wTmpcfc0.goronCutscenes.goronGuardMovedAside, $01
	scriptjump mainScripts.goron_enableInputAndResumeNappingLoop

; This gets executed if you say no, then talk to him again.
@promptForTradeAfterRejection:
	asm15 goron_showText_differentForPast, <TX_2498
	wait 30
	jumpiftextoptioneq $00, @acceptedTrade
	scriptjump @rejectedTrade


@acceptedTrade:
	asm15 goron_showText_differentForPast, <TX_2499
	wait 30

	asm15 goron_checkInPresent
	jumpifmemoryset wcddb, CPU_ZFLAG, @giveVase

; Get goronade, lose goron vase
	asm15 loseTreasure, TREASURE_GORON_VASE
	giveitem TREASURE_GORONADE, $00
	scriptjump ++

; Get vase, lose rock sirloin
@giveVase:
	asm15 loseTreasure, TREASURE_ROCK_BRISKET
	giveitem TREASURE_GORON_VASE, $00
++
	orroomflag $40
	wait 30
	asm15 goron_showText_differentForPast, <TX_249a
	scriptjump mainScripts.goron_enableInputAndResumeNappingLoop

@alreadyTraded:
	asm15 goron_showText_differentForPast, <TX_249b
	scriptjump mainScripts.goron_enableInputAndResumeNappingLoop


; ==============================================================================
; INTERACID_RAFTON
; ==============================================================================

; Rafton in right part of house
rafton_subid01Script:
	initcollisions
	asm15 checkEssenceObtained, $02
	jumpifmemoryset wcddb, CPU_ZFLAG, @afterD3NpcLoop
	settextid TX_2708

@beforeD3NpcLoop:
	checkabutton
	asm15 turnToFaceLink
	showloadedtext
	wait 10
	setanimation DIR_DOWN
	settextid TX_270a
	scriptjump @beforeD3NpcLoop

@afterD3NpcLoop:
	checkabutton
	disableinput
	jumpifroomflagset $20, @alreadyTraded

	showtextlowindex <TX_2710
	wait 30
	jumpiftradeitemeq TRADEITEM_MAGIC_OAR, @linkHasOar
	scriptjump @enableInput

@linkHasOar:
	showtextlowindex <TX_2711
	wait 30
	jumpiftextoptioneq $00, @acceptedTrade

	; Rejected trade
	showtextlowindex <TX_2713
	scriptjump @enableInput

@acceptedTrade:
	showtextlowindex <TX_2712
	wait 30
	giveitem TREASURE_TRADEITEM, $0a
	scriptjump @enableInput

@alreadyTraded:
	showtextlowindex <TX_2714

@enableInput:
	enableinput
	scriptjump @afterD3NpcLoop


; ==============================================================================
; INTERACID_CHEVAL
; ==============================================================================

;;
cheval_setTalkedGlobalflag:
	ld a,GLOBALFLAG_TALKED_TO_CHEVAL
	jp setGlobalFlag


; ==============================================================================
; INTERACID_MISCELLANEOUS_1
; ==============================================================================

;;
_interaction6b_loadMoblinsAttackingMakuSprout:
	ld hl,objectData.moblinsAttackingMakuSprout
	jp parseGivenObjectData

;;
; Set make tree present to use unswapped room, maku tree past to use sawpped room
; (the room in the underwater version of the map).
_interaction6b_layoutSwapMakuTreeRooms:
	ld hl,wPresentRoomFlags+$38
	res 0,(hl)
	ld hl,wPastRoomFlags+$48
	set 0,(hl)
	ret

;;
; Used for checking whin the maku sprout should talk to Link before leaving the screen.
;
; @param[out]	cflag	nc if Link is near the bottom of the screen (in wcddb)
_interaction6b_isLinkAtScreenEdge:
	ld hl,w1Link.yh
	call @func
	ld a,$01
	jr nc,+
	xor a
+
	or a
	jp _writeFlagsTocddb

@func:
	ldi a,(hl)
	sub $22
	cp $54
	ret nc
	inc l
	ld a,(hl)
	sub $14
	cp $84
	ret


;;
; Sets Link's object ID in such a way that he will move to a specific position.
;
; @param	a	Value for var03
moveLinkToPosition:
	push af
	ld a,SPECIALOBJECTID_LINK_CUTSCENE
	call setLinkIDOverride

	ld l,<w1Link.subid
	ld (hl),$05

	ld l,<w1Link.var03
	pop af
	ld (hl),a
	ret

;;
interaction6b_checkGotBombsFromAmbi:
	; Bit 7 of d2's entrance screen is set after that cutscene?
	ld a,(wPresentRoomFlags+$83)
	bit 7,a
	jp _writeFlagsTocddb

;;
; Sets var38 to $01 if Link can grab the item here (he's touching it, not in the air...)
interaction6b_checkLinkCanCollect:
	ld hl,w1Link.zh
	ld a,(hl)
	or a
	ret nz
	ld a,(wLinkGrabState)
	or a
	ret nz
	ld c,$0e
	call objectCheckLinkWithinDistance
	ld a,$01
	jr c,+
	xor a
+
	ld e,Interaction.var38
	ld (de),a
	ret

;;
interaction6b_refillBombs:
	ld hl,wMaxBombs
	ldd a,(hl)
	ld (hl),a
	ret


; Script for cutscene where moblins attack maku sprout
interaction6b_subid04Script:
	disableinput
	asm15 restartSound
	writememory wDisableScreenTransitions, $01
	asm15 _interaction6b_loadMoblinsAttackingMakuSprout

	wait 60
	spawninteraction INTERACID_PUFF, $00, $58, $28
	wait 4
	settileat $52, $f9

	writememory   wTmpcfc0.genericCutscene.state, $01
	checkmemoryeq wTmpcfc0.genericCutscene.state, $02
	wait 30

	showtext TX_1202
	wait 30

	writememory   wTmpcfc0.genericCutscene.state, $03
	checkmemoryeq wTmpcfc0.genericCutscene.state, $04
	wait 30

	showtext TX_05d0
	wait 30

	setmusic MUS_DISASTER
	writememory wTmpcfc0.genericCutscene.state, $05
	enableinput
	setcollisionradii $04, $50
	checkcollidedwithlink_ignorez

	disableinput
	asm15 setLinkToState08AndSetDirection, $00
	writememory   wTmpcfc0.genericCutscene.state, $06
	checkmemoryeq wTmpcfc0.genericCutscene.state, $08
	wait 30

	showtext TX_1203
	playsound SND_DING
	wait 40

	writememory wTmpcfc0.genericCutscene.state, $09
	wait 2
	enableinput

@twoEnemies:
	jumptable_memoryaddress wNumEnemies
	.dw @noEnemies
	.dw @oneEnemy
	.dw @twoEnemies

@oneEnemy:
	wait 20
	showtext TX_05d1
	checknoenemies
	wait 20

@noEnemies:
	showtext TX_05d2
	wait 30

	disableinput
	asm15 restartSound
	wait 20
	playsound SND_DING
	wait 20
	playsound SND_DING
	wait 20
	playsound SND_DING
	wait 30

	; Load movement preset for Link, wait for it to finish
	asm15 moveLinkToPosition, $00
	wait 1
	checkmemoryeq w1Link.id, SPECIALOBJECTID_LINK

	wait 30
	showtext TX_05d3
	wait 30

	spawninteraction INTERACID_MAKU_GATE_OPENING, $01, $00, $00

@waitForGatesToOpen:
	jumpifroomflagset $80, ++
	wait 1
	scriptjump @waitForGatesToOpen
++
	wait 40
	setglobalflag GLOBALFLAG_MAKU_GIVES_ADVICE_FROM_PAST_MAP
	showtext TX_05d6

	writememory wMakuMapTextPast, <TX_05d6
	setglobalflag GLOBALFLAG_MAKU_TREE_SAVED
	asm15 incMakuTreeState
	asm15 _interaction6b_layoutSwapMakuTreeRooms
	resetmusic
	enableinput

@waitForLinkToApproachScreenEdge:
	wait 1
	asm15 _interaction6b_isLinkAtScreenEdge
	jumpifmemoryset wcddb, CPU_ZFLAG, @waitForLinkToApproachScreenEdge

	showtext TX_05d4
	writememory wDisableScreenTransitions, $00
	scriptend


; ==============================================================================
; INTERACID_FAIRY_HIDING_MINIGAME
; ==============================================================================

;;
; @param	a	Index of fairy to spawn (value for var03)
fairyHidingMinigame_spawnForestFairyIndex:
	ld b,a
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERACID_FOREST_FAIRY
	ld l,Interaction.var03
	ld (hl),b
	ret

;;
fairyHidingMinigame_showFairyFoundText:
	ld a,(wTmpcfc0.fairyHideAndSeek.foundFairiesBitset)
	ld bc,$0003
--
	rrca
	jr nc,+
	inc b
+
	dec c
	jr nz,--

	ld a,b
	ld hl,@foundFairyText
	rst_addAToHl
	ld c,(hl)
	ld b,>TX_1105
	jp showText

@foundFairyText:
	.db <TX_1105
	.db <TX_1106
	.db <TX_1107

;;
fairyHidingMinigame_moveLinkBackLeft:
	ld hl,w1Link.direction
	ld (hl),DIR_LEFT
	inc l
	ld (hl),ANGLE_LEFT
	ld a,LINK_STATE_FORCE_MOVEMENT
	ld (wLinkForceState),a
	ld a,$08
	ld (wLinkStateParameter),a
	ret


; Begins fairy-hiding minigame
fairyHidingMinigame_subid00Script:
	asm15 fairyHidingMinigame_spawnForestFairyIndex, $00
	wait 20
	asm15 fairyHidingMinigame_spawnForestFairyIndex, $01
	wait 20
	asm15 fairyHidingMinigame_spawnForestFairyIndex, $02

	checkmemoryeq wTmpcfc0.fairyHideAndSeek.cfd2, $03
	wait 20

	showtext TX_1100
	wait 8
	showtext TX_1101
	wait 8
	showtext TX_1102
	wait 8
	showtext TX_1103
	checktext

	writememory   wTmpcfc0.fairyHideAndSeek.cfd2, $00
	checkmemoryeq wTmpcfc0.fairyHideAndSeek.cfd2, $03
	scriptend


; Hiding spot for fairy revealed
fairyHidingMinigame_subid01Script:
	checkmemoryeq wTmpcfc0.fairyHideAndSeek.cfd2, $01
	wait 20
	asm15 fairyHidingMinigame_showFairyFoundText
	writememory   wTmpcfc0.fairyHideAndSeek.cfd2, $00
	checkmemoryeq wTmpcfc0.fairyHideAndSeek.cfd2, $01
	scriptend


; Checks for Link leaving the hide-and-seek area
fairyHidingMinigame_subid02Script:
	setcollisionradii $20, $01
	makeabuttonsensitive

@checkLinkLeaving:
	checkcollidedwithlink_ignorez

	showtext TX_110c
	jumpiftextoptioneq $00, @leave

	asm15 fairyHidingMinigame_moveLinkBackLeft
	wait 10
	scriptjump @checkLinkLeaving

@leave:
	scriptend


; ==============================================================================
; INTERACID_POSSESSED_NAYRU
; ==============================================================================

;;
possessedNayru_moveLinkForward:
	ld a,LINK_STATE_FORCE_MOVEMENT
	ld (wLinkForceState),a
	ld a,$08
	ld (wLinkStateParameter),a
	ld hl,w1Link.direction
	xor a
	ldi (hl),a
	ld (hl),a
	ret

;;
possessedNayru_makeExclamationMark:
	ld a,SNDCTRL_STOPMUSIC
	call playSound
	ld a,$18
	ld bc,$f408
	jp objectCreateExclamationMark


; ==============================================================================
; INTERACID_NAYRU_SAVED_CUTSCENE
; ==============================================================================

;;
nayruSavedCutscene_createEnergySwirl:
	ld h,d
	ld l,Interaction.yh
	ld b,(hl)
	ld l,Interaction.xh
	ld c,(hl)
	ld a,$ff
	jp createEnergySwirlGoingIn

;;
; @param	a	Guard index (value for var03)
nayruSavedCutscene_spawnGuardIndex:
	ld b,a
	call getFreeInteractionSlot
	ret nz
	ld (hl),$6e
	inc l
	ld (hl),$04
	inc l
	ld (hl),b
	ret

;;
; @param	a	0 or 1 (for different speedZ presets)
nayruSavedCutscene_setSpeedZIndex:
	ld hl,@speeds
	rst_addDoubleIndex
	ld e,Interaction.speedZ
	ldi a,(hl)
	ld (de),a
	inc e
	ld a,(hl)
	ld (de),a
	ret

@speeds:
	.dw -$180
	.dw -$100

;;
nayruSavedCutscene_loadAngleAndAnimationPreset:
	ld hl,_nayruSavedCutscene_angleAndAnimationPresets
	rst_addDoubleIndex

_nayruSavedCutscene_setAngleAndAnimationAtAddress:
	ld e,Interaction.angle
	ldi a,(hl)
	ld (de),a

_nayruSavedCutscene_setAnimationAtAddress:
	ld a,(hl)
	jp interactionSetAnimation


_nayruSavedCutscene_angleAndAnimationPresets:
	.db $18 $13
	.db $00 $10
	.db $00 $0c
	.db $08 $0d
	.db $18 $0f

;;
nayruSavedCutscene_loadGuardAngleToMoveTowardCenter:
	ld e,Interaction.speed
	ld a,SPEED_40
	ld (de),a
	ld e,Interaction.var03
	ld a,(de)
	ld hl,@guardAnglesAndAnimations
	rst_addDoubleIndex
	jr _nayruSavedCutscene_setAngleAndAnimationAtAddress

@guardAnglesAndAnimations:
	.db $0f $0e
	.db $12 $0e
	.db $07 $0d
	.db $1a $0f
	.db $02 $0c
	.db $1e $0c

;;
nayruSavedCutscene_loadGuardAnimation:
	ld e,Interaction.var03
	ld a,(de)
	ld hl,@guardAnimations
	rst_addAToHl
	jr _nayruSavedCutscene_setAnimationAtAddress

@guardAnimations:
	.db $0e $0e $0e $0f $0d $0f


; ==============================================================================
; INTERACID_COMPANION_SCRIPTS
; ==============================================================================

;;
; Make an exclamation mark, + change their animation to the value of Interaction.var38 (?)
companionScript_noticeLink:
	ld e,Interaction.var38
	ld a,(de)
	or a
	jr z,companionScript_makeExclamationMark
	ld (w1Companion.var3f),a

;;
companionScript_makeExclamationMark:
	ld bc,$f000
	ld a,30
	jp objectCreateExclamationMark

;;
companionScript_writeAngleTowardLinkToCompanionVar3f:
	call objectGetAngleTowardLink
	ld e,Interaction.angle
	call convertAngleToDirection
	add $01
	ld (w1Companion.var3f),a
	ret

;;
companionScript_restoreMusic:
	ld a,(wActiveMusic2)
	ld (wActiveMusic),a
	jp playSound

;;
companionScript_spawnFairyAfterFindingCompanionInForest:
	ldbc INTERACID_FOREST_FAIRY, $03
	call objectCreateInteraction
	ld l,Interaction.var03
	ld (hl),$0f
	ret

;;
companionScript_warpOutOfForest:
	ld hl,@outOfForestWarp
	jp setWarpDestVariables

@outOfForestWarp:
	m_HardcodedWarpA ROOM_AGES_063, $00, $56, $03

;;
companionScript_loseRickyGloves:
	ld a,TREASURE_RICKY_GLOVES
	jp loseTreasure


; Script in first screen of forest, where fairy leads you to the companion
companionScript_subid0bScript_body:
	checkmemoryeq wTmpcfc0.fairyHideAndSeek.cfd2, $02 ; Wait for fairy to stop
	showtext TX_1126
	writememory   wTmpcfc0.fairyHideAndSeek.cfd2, $00
	checkmemoryeq wTmpcfc0.fairyHideAndSeek.cfd2, $01 ; Wait for fairy to leave
	enableinput
	scriptend


; Dimitri script where he's harrassed by tokays
companionScript_subid07Script_body:
	jumpifmemoryset wDimitriState, $01, @alreadyHeardTokayDiscussion

@wait:
	jumpifmemoryset w1Companion.var3e, $02, ++
	scriptjump @wait
++
	showtext TX_2100
	ormemory wDimitriState, $01

@alreadyHeardTokayDiscussion:
	checkmemoryeq w1Companion.var3d, $01 ; Wait for Link to talk to Dimitri
	jumpifmemoryset wDimitriState, $02, @savedDimitri

	; Still being harrassed
	showtext TX_2100
	writememory w1Companion.var3d, $00
	enableinput
	scriptjump mainScripts.companionScript_subid07Script

@savedDimitri:
	disableinput
	jumpifmemoryeq wAnimalCompanion, SPECIALOBJECTID_DIMITRI, @notFirstMeeting

	; First meeting
	showtext TX_2101
	scriptjump ++

@notFirstMeeting:
	showtext TX_2102
++
	writememory w1Companion.var03, $01
	enableallobjects
	checkmemoryeq wLinkObjectIndex, >w1Companion ; Wait for Link to mount
	showtext TX_2106
	ormemory wDimitriState, $20
	enableinput
	scriptend


; A fairy appears to tell you about the animal companion in the forest
companionScript_subid08Script_body:
	showtext TX_1120
	checkmemoryeq wTmpcfc0.fairyHideAndSeek.cfd2, $02 ; Wait for fairy to fully appear

	showtext TX_1121
	jumpiftextoptioneq $00, @doneRepeating
@repeatSelf:
	showtext TX_1121
	jumpiftextoptioneq $01, @repeatSelf

@doneRepeating:
	showtext TX_1130
	writememory   wTmpcfc0.fairyHideAndSeek.cfd2, $00
	checkmemoryeq wTmpcfc0.fairyHideAndSeek.cfd2, $01

	orroomflag $40
	unsetglobalflag GLOBALFLAG_FOREST_UNSCRAMBLED
	setglobalflag   GLOBALFLAG_COMPANION_LOST_IN_FOREST
script15_6e71:
	enableinput
	scriptend


; Ricky script when he loses his gloves
companionScript_subid03Script_body:
	checkmemoryeq w1Companion.var3d, $01 ; Wait for Link to talk to Ricky
	disableinput
	jumpifmemoryset wRickyState, $01, @alreadyExplainedSituation

	ormemory wRickyState, $01
	jumpifmemoryeq wAnimalCompanion, SPECIALOBJECTID_RICKY, @notFirstMeeting

	; First meeting
	showtext TX_2000
	scriptjump @alreadyExplainedSituation

@notFirstMeeting:
	showtext TX_2001

@alreadyExplainedSituation:
	jumpifitemobtained TREASURE_RICKY_GLOVES, @retrievedGloves
	showtext TX_2003
	writememory w1Companion.var3d, $00
	enableinput
	scriptjump mainScripts.companionScript_subid03Script

@retrievedGloves:
	showtext TX_2004
	asm15 companionScript_loseRickyGloves
	writememory w1Companion.var03, $01
	enableallobjects
	checkmemoryeq wLinkObjectIndex, >w1Companion ; Wait for Link to mount

	showtext TX_2005
	ormemory wRickyState, $20
	enablemenu
	scriptend


; Script just outside the forest, where you get the flute
companionScript_subid0aScript_body:
	disableinput
	showtext TX_112b
	wait 30
	showtext TX_112c
	wait 30
	showtext TX_112d
	wait 30
	showtext TX_112e
	wait 30
	showtext TX_112f

	writememory    wTmpcfc0.fairyHideAndSeek.cfd2, $00
@waitForFairiesToLeave:
	jumpifmemoryeq wTmpcfc0.fairyHideAndSeek.cfd2, $03, @fairiesLeft
	wait 1
	scriptjump @waitForFairiesToLeave

@fairiesLeft:
	showtext TX_1131
	writeobjectbyte Interaction.state, $02 ; State 2 code gives Link the flute
	checktext
	showtext TX_1132
	writememory w1Companion.var03, $01
	setglobalflag GLOBALFLAG_GOT_FLUTE
	checkmemoryeq wLinkObjectIndex, >w1Companion ; Wait for Link to mount companion

	setglobalflag GLOBALFLAG_FOREST_UNSCRAMBLED
	enableinput
	scriptend


; Companion script where they're found in the fairy forest
companionScript_subid09Script_body:
	checkmemoryeq w1Companion.var3d, $01 ; Wait for Link to talk to him

	disableinput
	showtext TX_1131
	asm15 companionScript_noticeLink
	wait 60
	showtext TX_1132
	asm15 companionScript_spawnFairyAfterFindingCompanionInForest

@waitForFairy:
	jumpifmemoryeq wTmpcfc0.fairyHideAndSeek.cfd2, $02, @fairyAppeared
	wait 1
	scriptjump @waitForFairy

@fairyAppeared:
	showtext TX_112a
	setglobalflag GLOBALFLAG_SAVED_COMPANION_FROM_FOREST
	asm15 companionScript_warpOutOfForest
	scriptend


; ==============================================================================
; INTERACID_KING_MOBLIN_DEFEATED
; ==============================================================================

;;
kingMoblinDefeated_setGoronDirection:
	ld hl,@directionTable
	rst_addDoubleIndex
	ld e,Interaction.angle
	ldi a,(hl)
	ld (de),a
	ld a,(hl)
	jp interactionSetAnimation

@directionTable:
	.db $00 $04
	.db $08 $05
	.db $10 $06
	.db $18 $07

;;
kingMoblinDefeated_spawnInteraction8a:
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERACID_REMOTE_MAKU_CUTSCENE
	ld l,Interaction.var03
	ld (hl),$06
	ret


; ==============================================================================
; INTERACID_GHINI_HARASSING_MOOSH
; ==============================================================================

;;
; Set initial speed and angle for the ghini to do its circular movement.
ghiniHarassingMoosh_beginCircularMovement:
	ld e,Interaction.speed
	ld a,SPEED_140
	ld (de),a
	ld e,Interaction.angle
	ld a,ANGLE_LEFT
	ld (de),a
	ret


; ==============================================================================
; INTERACID_TOKAY_SHOP_ITEM
; ==============================================================================

;;
tokayShopItem_giveFeatherAndLoseShovel:
	ld c,$02
	ld a,TREASURE_SHOVEL
	jr _tokayShopItem_giveAndLoseTreasure

;;
tokayShopItem_giveBraceletAndLoseShovel:
	ld c,$03
	ld a,TREASURE_SHOVEL
	jr _tokayShopItem_giveAndLoseTreasure

;;
tokayShopItem_giveShovelAndLoseFeather:
	ld b,TREASURE_FEATHER
	jr ++

;;
tokayShopItem_giveShovelAndLoseBracelet:
	ld b,TREASURE_BRACELET
++
	ld e,Interaction.var3c
	ld a,TREASURE_SHOVEL
	ld (de),a
	ld c,$02
	ld a,b

;;
; @param	a	Treasure to lose
; @param	c	Subid of treasure to give
; @param	var3c	ID of treasure to give (set by main object code)
_tokayShopItem_giveAndLoseTreasure:
	ld e,Interaction.var3b
	ld (de),a
	call _tokayShopItem_createTreasureAtLink
	ld e,Interaction.var3b
	ld a,(de)
	call loseTreasure
	ret

;;
tokayShopItem_giveShieldToLink:
	ld e,Interaction.var3c
	ld a,TREASURE_SHIELD
	ld (de),a
	ld e,Interaction.subid
	ld a,(de)
	sub $04
	ld c,a
	jr _tokayShopItem_createTreasureAtLink

;;
tokayShopItem_giveBraceletToLink:
	ld c,$03
	jr _tokayShopItem_createTreasureAtLink

;;
tokayShopItem_giveFeatherToLink:
	ld c,$02

;;
_tokayShopItem_createTreasureAtLink:
	ld e,Interaction.var3c
	ld a,(de)
	ld b,a
	call createTreasure
	ld l,Interaction.yh
	ld a,(w1Link.yh)
	ldi (hl),a
	inc l
	ld a,(w1Link.xh)
	ld (hl),a
	ret

;;
tokayShopItem_lose10ScentSeeds:
	ld l,<wNumScentSeeds
	jr ++

;;
tokayShopItem_lose10MysterySeeds:
	ld l,<wNumMysterySeeds
++
	ld h,>wc600Block
	ld a,(hl)
	sub $10
	daa
	ld (hl),a
	ld a,$ff
	ld (wStatusBarNeedsRefresh),a
	ret


; ==============================================================================
; INTERACID_BOMB_UPGRADE_FAIRY
; ==============================================================================

;;
bombUpgradeFairy_spawnBombsAroundLink:
	ld b,$04
@next:
	call getFreeInteractionSlot
	ret nz
	ld (hl),$83
	inc l
	inc (hl)
	inc l
	dec b
	ld (hl),b
	jr nz,@next
	ret

bombUpgradeFairy_lightningStrikesLink:
	call getFreePartSlot
	ret nz

	dec l
	set 7,(hl)
	inc l
	ld (hl),PARTID_LIGHTNING
	inc l
	inc (hl)
	ld l,Part.yh
	ldh a,(<hEnemyTargetY)
	ldi (hl),a
	inc l
	ldh a,(<hEnemyTargetX)
	ld (hl),a
	ret

;;
bombUpgradeFairy_decreaseLinkHealth:
	ld hl,wLinkHealth
	ld a,(hl)
	cp $04
	ret c
	ld (hl),$04

_bombUpgradeFairy_linkCollapsed:
	ld a,LINK_ANIM_MODE_COLLAPSED
	ld (wcc50),a
	ret

;;
bombUpgradeFairy_loseAllBombs:
	ld a,$01
	ld (wNumBombs),a
	call decNumBombs
	jr _bombUpgradeFairy_linkCollapsed

;;
bombUpgradeFairy_giveBombUpgrade:
	ld a,(wTextNumberSubstitution)
	ld (wMaxBombs),a
	ld c,a
	ld a,TREASURE_BOMBS
	jp giveTreasure

;;
bombUpgradeFairy_fadeinFromWhite:
	ld a,$ff
	ld (wTmpcfc0.genericCutscene.cfd0),a
	ld a,$04
	jp fadeinFromWhiteWithDelay

;;
bombUpgradeFairy_setGlobalFlag:
	ld a,GLOBALFLAG_GOT_BOMB_UPGRADE_FROM_FAIRY
	jp setGlobalFlag


bombUpgradeFairyScript_body:
	wait 30
@askBombType:
	showtext TX_0c00
	jumptable_memoryaddress wSelectedTextOption
	.dw @saidGoldenBomb
	.dw @saidSilverBomb
	.dw @saidRegularBomb

@saidGoldenBomb:
	wait 60
	showtext TX_0c01
	jumpiftextoptioneq $01, @askBombType
	wait 60
	showtext TX_0c02
	jumpiftextoptioneq $01, @askBombType
	wait 60

	writememory wTmpcfc0.genericCutscene.cfd0, $01
	wait 30
	showtext TX_0c03
	asm15 bombUpgradeFairy_spawnBombsAroundLink
	wait 120

	asm15 playSound, SND_BIG_EXPLOSION
	asm15 fadeoutToWhite
	wait 1
	asm15 bombUpgradeFairy_decreaseLinkHealth
	wait 1
	asm15 bombUpgradeFairy_fadeinFromWhite
	wait 1
	showtext TX_0c04
	wait 30
	scriptend

@saidSilverBomb:
	wait 60
	showtext TX_0c05
	jumpiftextoptioneq $01, @askBombType
	wait 60

	writememory wTmpcfc0.genericCutscene.cfd0, $01
	wait 30
	showtext TX_0c06
	asm15 bombUpgradeFairy_lightningStrikesLink
	wait 20
	asm15 bombUpgradeFairy_loseAllBombs
	wait 1
	asm15 bombUpgradeFairy_fadeinFromWhite
	wait 1
	showtext TX_0c04
	wait 30
	scriptend

@saidRegularBomb:
	writememory wTmpcfc0.genericCutscene.cfd0, $01
	wait 30
	showtext TX_0c07
	wait 30
	asm15 bombUpgradeFairy_spawnBombsAroundLink
	wait 120
	asm15 playSound, SND_BIG_EXPLOSION
	asm15 fadeoutToWhite
	wait 1
	asm15 bombUpgradeFairy_giveBombUpgrade
	asm15 bombUpgradeFairy_fadeinFromWhite
	wait 1
	showtext TX_0c08
	wait 30
	asm15 bombUpgradeFairy_setGlobalFlag
	scriptend


; ==============================================================================
; INTERACID_MAKU_TREE
; ==============================================================================

;;
makuTree_setAnimation:
	ld e,Interaction.var3b
	ld (de),a
	jp interactionSetAnimation

;;
; Takes [var3f] + 'a', shows the corresponding text, and updates the map text accordingly.
; In linked games, $20 or $10 is added to the index?
makuTree_showTextWithOffsetAndUpdateMapText:
	call _makuTree_func_70a2
	jr _label_15_203

;;
; Takes [var3f] + 'a', and shows the corresponding text.
; In linked games, $20 or $10 is added to the index?
makuTree_showTextWithOffset:
	call _makuTree_func_709c
	jr _label_15_203

;;
; In linked games, $20 or $10 is added to the index?
makuTree_showTextAndUpdateMapText:
	call _makuTree_checkLinkedAndUpdateMapText
	jr _label_15_203

;;
; In linked games, $20 or $10 is added to the index?
makuTree_showText:
	call _makuTree_modifyTextIndexForLinked
	jr _label_15_203

; TODO: ?
	ld c,a

;;
_label_15_203:
	ld b,>TX_0500
	jp showText

;;
; @param	a	Text index
_makuTree_func_709c:
	ld h,d
	ld l,Interaction.var3f
	add (hl)
	jr _makuTree_modifyTextIndexForLinked

;;
; @param	a	Text index
_makuTree_func_70a2:
	ld h,d
	ld l,Interaction.var3f
	add (hl)

;;
; @param	a	Text index
_makuTree_checkLinkedAndUpdateMapText:
	call _makuTree_modifyTextIndexForLinked
	ld e,Interaction.var3d
	ld a,(de)
	ld hl,wMakuMapTextPresent
	rst_addAToHl
	ld (hl),c
	ret

;;
; @param	a	Text index (original)
; @param[out]	c	Text index (modified if linked game)
_makuTree_modifyTextIndexForLinked:
	ld c,a
	call checkIsLinkedGame
	ret z
	call @getLinkedTextOffset
	ld hl,_makuTree_textOffsetsForLinked
	rst_addAToHl
	ld a,(hl)
	add c
	ld c,a
	ret

;;
@getLinkedTextOffset:
	ld h,d
	ld l,Interaction.id
	ld a,(hl)
	cp INTERACID_REMOTE_MAKU_CUTSCENE
	jr nz,+
	dec a
+
	sub INTERACID_MAKU_TREE
	ret

_makuTree_textOffsetsForLinked:
	.db $20, $20, $10

;;
_makuTree_dropSeedSatchel:
	call getThisRoomFlags
	bit 7,a
	ret nz
	set 7,(hl)

	call getFreeInteractionSlot
	ld (hl),INTERACID_TREASURE
	inc l
	ld (hl),TREASURE_SEED_SATCHEL
	inc l
	ld (hl),$02
	ld l,Interaction.yh
	ld (hl),$60

	ld a,(w1Link.xh)
	ld b,$50
	cp $64
	jr nc,@setX
	cp $3c
	jr c,@setX
	ld b,$40
	cp $50
	jr nc,@setX
	ld b,$60
@setX:
	ld l,Interaction.xh
	ld (hl),b
	ld a,b
	ld (wMakuTreeSeedSatchelXPosition),a
	ret

;;
; Checks whether to spawn the seed satchel which was dropped previously.
makuTree_checkSpawnSeedSatchel:
	call getThisRoomFlags
	bit 5,a
	ret nz
	bit 7,a
	ret z

	call getFreeInteractionSlot
	ld (hl),INTERACID_TREASURE
	inc l
	ld (hl),TREASURE_SEED_SATCHEL
	inc l
	ld (hl),$03
	ld l,Interaction.yh
	ld a,$58
	ldi (hl),a
	ld a,(wMakuTreeSeedSatchelXPosition)
	ld l,Interaction.xh
	ld (hl),a
	ret

;;
makuTree_spawnMakuSeed:
	ldbc INTERACID_MAKU_SEED, $00
	jp objectCreateInteraction

;;
makuTree_chooseTextAfterSeeingTwinrova:
	ld c,<TX_055b
	call checkIsLinkedGame
	jr z,+
	ld c,<TX_055f
+
	ld e,Interaction.textID
	ld a,c
	ld (de),a
	ret


; The main maku tree script; her exact behaviour varies over time, mostly with what
; animation she does.
makuTree_subid00Script_body:
	jumptable_objectbyte Interaction.var3e
	.dw @mode00_justShowText
	.dw @mode01_showTextWithLaugh
	.dw @mode02_showTwoTexts_frownOnSecond
	.dw @mode03_constantFrownAndShowText
	.dw @mode04_constantFrownAndShowText
	.dw @mode05_showTwoTexts_frownOnFirst
	.dw @mode06


@mode00_justShowText:
	asm15 makuTree_setAnimation, $00
	setcollisionradii $08, $08
	makeabuttonsensitive
--
	checkabutton
	asm15 makuTree_showTextWithOffsetAndUpdateMapText, $00
	scriptjump --


@mode01_showTextWithLaugh:
	asm15 makuTree_setAnimation, $00
	setcollisionradii $08, $08
	makeabuttonsensitive
--
	checkabutton
	asm15 makuTree_setAnimation, $03
	asm15 makuTree_showTextWithOffsetAndUpdateMapText, $00
	wait 1
	asm15 makuTree_setAnimation, $00
	scriptjump --


@mode02_showTwoTexts_frownOnSecond:
	asm15 makuTree_setAnimation, $00
	setcollisionradii $08, $08
	makeabuttonsensitive
--
	checkabutton
	disableinput
	asm15 makuTree_showTextWithOffsetAndUpdateMapText, $00
	wait 30
	asm15 makuTree_setAnimation, $04
	asm15 makuTree_showTextWithOffset, $01
	wait 1
	asm15 makuTree_setAnimation, $00
	enableinput
	scriptjump --


@mode03_constantFrownAndShowText:
@mode04_constantFrownAndShowText:
	asm15 makuTree_setAnimation, $04
	setcollisionradii $08, $08
	makeabuttonsensitive
--
	checkabutton
	asm15 makuTree_showTextWithOffsetAndUpdateMapText, $00
	scriptjump --


@mode05_showTwoTexts_frownOnFirst:
	asm15 makuTree_setAnimation, $00
	setcollisionradii $08, $08
	makeabuttonsensitive
--
	checkabutton
	disableinput
	asm15 makuTree_setAnimation, $02
	asm15 makuTree_showTextWithOffsetAndUpdateMapText, $00
	wait 30
	asm15 makuTree_setAnimation, $00
	asm15 makuTree_showTextWithOffsetAndUpdateMapText, $01
	wait 1
	enableinput
	scriptjump --


@mode06:
	; Unimplemented


; Cutscene where maku tree disappears
makuTree_subid01Script_body:
	disablemenu
	asm15 makuTree_setAnimation, $00
	setcollisionradii $08, $08
	makeabuttonsensitive

	checkpalettefadedone
	wait 210

	showtextlowindex <TX_0564
	wait 60

	playsound SNDCTRL_STOPMUSIC
	asm15 makuTree_setAnimation, $04
	wait 60

	playsound SND_MAKUDISAPPEAR
	writememory wCutsceneTrigger, CUTSCENE_MAKU_TREE_DISAPPEARING
	wait 210

	showtextlowindex <TX_0540
	playsound SND_MAKUDISAPPEAR
	wait 210

	showtextlowindex <TX_0541
	playsound SND_MAKUDISAPPEAR
	wait 150

	writememory wTmpcfc0.genericCutscene.state, $01
	asm15 incMakuTreeState
	scriptend


; Maku tree just after being saved (present)
makuTree_subid02Script_body:
	asm15 makuTree_checkSpawnSeedSatchel
	setmusic MUS_MAKU_TREE
	asm15 makuTree_setAnimation, $00
	setcollisionradii $08, $08
	makeabuttonsensitive

	jumpifroomflagset $80, @npcLoop ; Check if she's already dropped the satchel

	checkabutton
	disableinput
	asm15 makuTree_setAnimation, $02
	showtextlowindex <TX_0542
	wait 30
	asm15 makuTree_setAnimation, $03
	showtextlowindex <TX_0543
	wait 30
	asm15 makuTree_setAnimation, $01
	showtextlowindex <TX_0544
	wait 30
	asm15 makuTree_setAnimation, $00
	showtextlowindex <TX_0545
	wait 30
	asm15 makuTree_setAnimation, $01
	showtextlowindex <TX_0546
	wait 30
	asm15 makuTree_setAnimation, $04
	showtextlowindex <TX_0547
	wait 30

@explainAgain:
	asm15 makuTree_setAnimation, $00
	showtextlowindex <TX_0548
	wait 30
	asm15 makuTree_setAnimation, $04
	showtextlowindex <TX_0549
	wait 30
	wait 30
	asm15 makuTree_setAnimation, $00
	showtextlowindex <TX_054a
	wait 30
	jumpiftextoptioneq $00, @explainAgain

	asm15 makuTree_setAnimation, $00
	showtextlowindex <TX_054b
	wait 30
	asm15 makuTree_setAnimation, $04
	showtextlowindex <TX_054c
	wait 30
	showtextlowindex <TX_054d
	wait 30
	asm15 makuTree_setAnimation, $03
	showtextlowindex <TX_054e
	wait 30
	asm15 makuTree_setAnimation, $00
	showtextlowindex <TX_054f
	wait 30

	setglobalflag GLOBALFLAG_MAKU_GIVES_ADVICE_FROM_PRESENT_MAP
	writememory wMakuMapTextPresent, <TX_054f

	showtextlowindex <TX_0550
	wait 30
	asm15 _makuTree_dropSeedSatchel
	wait 140
	showtextlowindex <TX_0561
	wait 30
	enableinput
@npcLoop:
	checkabutton
	disableinput
	asm15 makuTree_setAnimation, $00
	showtextlowindex <TX_054f
	wait 30
	asm15 makuTree_setAnimation, $00
	enableinput
	scriptjump @npcLoop


; Cutscene where Link gets the maku seed, then Twinrova appears
makuTree_subid06Script_part1_body:
	disableinput
	wait 60
	showtextlowindex <TX_0559
	wait 30

	asm15 makuTree_spawnMakuSeed
	checkmemoryeq wTmpcfc0.genericCutscene.state, $01

	playsound SND_GETSEED
	giveitem TREASURE_MAKU_SEED, $00
	wait 30

	writememory   wCutsceneTrigger, CUTSCENE_TWINROVA_REVEAL
	checkmemoryeq wTmpcfc0.genericCutscene.state, $02
	setanimation $02
	scriptend

makuTree_subid06Script_part2_body:
	disableinput
	asm15 makuTree_chooseTextAfterSeeingTwinrova
	checkpalettefadedone
	wait 60
	showloadedtext
	wait 20

	setanimation $00
	wait 10

	writememory wMakuMapTextPresent, <TX_0560
	addobjectbyte Interaction.textID, $01
	showloadedtext
	wait 20

	setglobalflag GLOBALFLAG_SAW_TWINROVA_BEFORE_ENDGAME
	writememory wTmpcfc0.genericCutscene.state, $04
	asm15 incMakuTreeState
	enableinput
	setcollisionradii $08, $08
	makeabuttonsensitive

@npcLoop:
	checkabutton
	showloadedtext
	scriptjump @npcLoop



; ==============================================================================
; INTERACID_MAKU_SPROUT
; ==============================================================================

;;
makuSprout_setAnimation:
	ld e,Interaction.var3b
	ld (de),a
	jp interactionSetAnimation


; The main maku sprout script; her exact behaviour varies over time, mostly with what
; animation she does.
makuSprout_subid00Script_body:
	jumptable_objectbyte Interaction.var3e
	.dw @mode00_showDifferentTextFirstTime_distressedAnim
	.dw @mode01_happyAnimationWhileTalking
	.dw @mode02_showDifferentTextFirstTime


@mode00_showDifferentTextFirstTime_distressedAnim:
	asm15 makuSprout_setAnimation, $02
	setcollisionradii $08, $08
	makeabuttonsensitive
	checkabutton
	asm15 makuTree_showTextWithOffsetAndUpdateMapText, $00
--
	checkabutton
	asm15 makuTree_showTextWithOffsetAndUpdateMapText, $01
	scriptjump --


@mode01_happyAnimationWhileTalking:
	asm15 makuSprout_setAnimation, $00
	setcollisionradii $08, $08
	makeabuttonsensitive
--
	checkabutton
	asm15 makuSprout_setAnimation, $01
	asm15 makuTree_showTextWithOffsetAndUpdateMapText, $00
	wait 1
	asm15 makuSprout_setAnimation, $00
	scriptjump --


@mode02_showDifferentTextFirstTime:
	asm15 makuSprout_setAnimation, $00
	setcollisionradii $08, $08
	makeabuttonsensitive
	checkabutton
	asm15 makuTree_showTextWithOffsetAndUpdateMapText, $00
--
	checkabutton
	asm15 makuTree_showTextWithOffsetAndUpdateMapText, $01
	scriptjump --


; ==============================================================================
; INTERACID_REMOTE_MAKU_CUTSCENE
; ==============================================================================

;;
remoteMakuCutscene_fadeoutToBlackWithDelay:
	call fadeoutToBlackWithDelay
	jr ++

;;
; Unused?
remoteMakuCutscene_fadeinFromBlackWithDelay:
	call fadeinFromBlackWithDelay
++
	ld a,$ff
	ld (wDirtyFadeBgPalettes),a
	ld (wFadeBgPaletteSources),a
	ld a,$01
	ld (wDirtyFadeSprPalettes),a
	ld a,$fe
	ld (wFadeSprPaletteSources),a
	ret

;;
remoteMakuCutscene_checkinitUnderwaterWaves:
	ld e,Interaction.var03
	ld a,(de)
	cp $09
	ret nz
	jpab bank1.checkInitUnderwaterWaves


; ==============================================================================
; INTERACID_GORON_ELDER
; ==============================================================================

;;
goronElder_lookingUpAnimation:
	ld h,d
	ld l,Interaction.var3f
	ld (hl),$01
	ld a,$04
	jp interactionSetAnimation

goronElder_normalAnimation:
	ld h,d
	ld l,Interaction.var3f
	ld (hl),$00
	ld a,$02
	jp interactionSetAnimation


; Cutscene where goron elder is saved / NPC in that room after that
goronElderScript_subid00_body:
	jumpifglobalflagset GLOBALFLAG_FINISHEDGAME, mainScripts.stubScript

	asm15 checkEssenceObtained, $04
	jumpifmemoryset wcddb, CPU_ZFLAG, mainScripts.stubScript

	initcollisions
	jumpifroomflagset $40, @npcLoop

	; Just saved the elder, run the cutscene

	asm15 goronElder_lookingUpAnimation
	checkpalettefadedone
	checkobjectbyteeq Interaction.animParameter, $ff
	wait 180

	asm15 goronElder_normalAnimation
	showtext TX_2487
	wait 30

	asm15 moveLinkToPosition, $01
	wait 1
	checkmemoryeq w1Link.id, SPECIALOBJECTID_LINK
	wait 30

	showtext TX_2488
	wait 30

	giveitem TREASURE_CROWN_KEY, $00
	disableinput
	setglobalflag GLOBALFLAG_SAVED_GORON_ELDER
	orroomflag $40
	wait 30

	enableinput
	scriptjump ++

@npcLoop:
	checkabutton
++
	showtext TX_2489
	scriptjump @npcLoop


; NPC hanging out in rolling ridge (after getting D5 essence)
goronElderScript_subid01_body:
	jumpifglobalflagset GLOBALFLAG_FINISHEDGAME, mainScripts.stubScript

	asm15 checkEssenceNotObtained, $04
	jumpifmemoryset wcddb, CPU_ZFLAG, mainScripts.stubScript

	initcollisions
@npcLoop:
	checkabutton
	showtext TX_24e4
	scriptjump @npcLoop


; ==============================================================================
; INTERACID_CLOAKED_TWINROVA
; ==============================================================================

; Cutscene at maku tree screen after saving Nayru
cloakedTwinrova_subid00Script_body:
	wait 16
	asm15 objectWritePositionTocfd5
	asm15 objectSetVisible82

	writememory wTmpcfc0.genericCutscene.cfd0, $08
	playsound MUS_DISASTER
	asm15 forceLinkDirection, DIR_RIGHT
	wait 120

	showtextlowindex <TX_2801
	wait 40
	writememory wTmpcfc0.genericCutscene.cfd0, $09
	playsound SNDCTRL_FAST_FADEOUT
	scriptend


; Cutscene after getting maku seed
cloakedTwinrova_subid02Script_body:
	wait 16
	asm15 objectSetVisible82
	playsound MUS_DISASTER
	wait 60
	showtextlowindex <TX_2811
	wait 30
	scriptend


; ==============================================================================
; INTERACID_MISC_PUZZLES
; ==============================================================================

;;
miscPuzzles_drawCrownDungeonOpeningFrame1:
	ld c,$00
	jr ++

;;
miscPuzzles_drawCrownDungeonOpeningFrame2:
	ld c,$01
	jr ++

;;
miscPuzzles_drawCrownDungeonOpeningFrame3:
	ld c,$02
++
	push de
	callab roomGfxChanges.drawCrownDungeonOpeningTiles
	call reloadTileMap
	pop de
	ld a,$0f
	call setScreenShakeCounter
	ld a,SND_DOORCLOSE
	call playSound

	ld bc,$2060
	call @spawnPuff
	ld bc,$2070
	call @spawnPuff
	ld bc,$2080
	call @spawnPuff
	ld bc,$2090
@spawnPuff:
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERACID_PUFF
	inc l
	ld (hl),$81
	ld l,Interaction.yh
	ld (hl),b
	ld l,Interaction.xh
	ld (hl),c
	ret


; ==============================================================================
; INTERACID_TWINROVA
; ==============================================================================

;;
objectWritePositionTocfd5:
	xor a

twinrova_writePositionWithXOffsetTocfd5:
	ldh (<hFF8B),a
	call objectGetPosition
	ldh a,(<hFF8B)
	ld hl,wTmpcfc0.genericCutscene.cfd5
	ld (hl),b
	inc l
	add c
	ld (hl),a
	ret


; Linked cutscene after saving Nayru?
twinrova_subid00Script_body:
	setanimation DIR_DOWN
	writeobjectbyte Interaction.direction, DIR_DOWN

	asm15 twinrova_writePositionWithXOffsetTocfd5, $18
	asm15 forceLinkDirection, DIR_UP
	wait 90

	asm15 twinrova_writePositionWithXOffsetTocfd5, $f0
	playsound MUS_DISASTER
	wait 20

	showtextlowindex <TX_2803
	wait 20
	asm15 twinrova_writePositionWithXOffsetTocfd5, $40
	wait 16
	showtextlowindex <TX_2804
	wait 20
	asm15 twinrova_writePositionWithXOffsetTocfd5, $f0
	wait 16
	showtextlowindex <TX_2805
	wait 20
	asm15 twinrova_writePositionWithXOffsetTocfd5, $40
	wait 16
	showtextlowindex <TX_2806
	wait 20
	asm15 twinrova_writePositionWithXOffsetTocfd5, $18
	wait 16
	showtextlowindex <TX_2807
	wait 60
	playsound SNDCTRL_FAST_FADEOUT
	wait 30
	scriptend


; Twinrova introduction? Unlinked equivalent of subids $00-$01?
twinrova_subid02Script_body:
	setanimation DIR_DOWN
	writeobjectbyte Interaction.direction, DIR_DOWN
	wait 90
	showtextlowindex <TX_2812
	wait 20
	showtextlowindex <TX_2813
	wait 20
	showtextlowindex <TX_2814
	wait 60
	scriptend


twinrova_subid04Script_body:
	setanimation DIR_DOWN
	writeobjectbyte Interaction.direction, DIR_DOWN
	wait 30
	playsound MUS_DISASTER
	wait 60
	showtextlowindex <TX_2816
	wait 20
	showtextlowindex <TX_2817
	wait 60
	writememory wTmpcfc0.genericCutscene.state, $03
	wait 240
	scriptend


twinrova_subid06Script_body:
	wait 60
	showtextlowindex <TX_2818
	wait 20
	showtextlowindex <TX_2819
	wait 60
	scriptend

; ==============================================================================
; INTERACID_PATCH
; ==============================================================================

;;
patch_jump:
	ld h,d
	ld l,Interaction.speedZ
	ld a,<(-$180)
	ldi (hl),a
	ld (hl),>(-$180)
	ld a,DISABLE_LINK
	ld (wDisabledObjects),a
	ld (wMenuDisabled),a
	ld (wTextIsActive),a
	ld a,SND_ENEMY_JUMP
	jp playSound

;;
patch_updateTextSubstitution:
	ld a,(wTmpcfc0.patchMinigame.itemNameText)
	ld (wTextSubstitutions),a
	ret

;;
patch_restoreControlAndStairs:
	xor a
	ld (wDisabledObjects),a
	ld (wMenuDisabled),a
	ld a,TILEINDEX_INDOOR_UPSTAIRCASE

;;
; @param	a	Tile index to put at the stair tile's position
patch_setStairTile:
	ld c,$49
	call setTile

	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERACID_PUFF
	ld l,Interaction.yh
	ld (hl),$48
	ld l,Interaction.xh
	ld (hl),$98
	ret

;;
; Moves Link to a preset position after the minigame
patch_moveLinkPositionAtMinigameEnd:
	push de
	call clearAllItemsAndPutLinkOnGround
	pop de
	call setLinkForceStateToState08
	call resetLinkInvincibility
	ld l,<w1Link.yh
	ld (hl),$48
	ld l,<w1Link.xh
	ld (hl),$78
	ld l,<w1Link.direction
	ld (hl),a
	inc a
	ld (wTmpcfc0.patchMinigame.screenFadedOut),a
	jp resetCamera

;;
patch_turnToFaceLink:
	call objectGetAngleTowardLink
	add $04
	and $18
	swap a
	rlca
	ld e,Interaction.direction
	ld (hl),a
	jp interactionSetAnimation


patch_upstairsRepairTuniNutScript:
	initcollisions
@npcLoop:
	checkabutton
	jumpifmemoryset wPastRoomFlags+(<ROOM_AGES_1be), $06, @alreadyMetPatch

	; First meeting
	ormemory wPastRoomFlags+(<ROOM_AGES_1be), $06
	showtextnonexitable TX_5800
	scriptjump ++

@alreadyMetPatch:
	showtextnonexitable TX_5801
++
	jumpiftextoptioneq $00, @saidYes1
	showtext TX_5802
	scriptjump @npcLoop
@saidYes1:
	jumptable_objectbyte Interaction.var38
	.dw @hasBrokenNut
	.dw @doesntHaveBrokenNut

@doesntHaveBrokenNut:
	showtext TX_5803
	scriptjump @npcLoop

@hasBrokenNut:
	asm15 patch_updateTextSubstitution
	showtextnonexitable TX_5804
	jumpiftextoptioneq $00, @saidYes2
	showtext TX_5805
	scriptjump @npcLoop

@saidYes2:
	asm15 patch_jump
	wait 8
	showtext TX_5806
	wait 8
	scriptend


patch_upstairsRepairSwordScript_body:
	initcollisions
@npcLoop:
	checkabutton
	showtextnonexitable TX_5810
	jumpiftextoptioneq $00, @saidYes1
	showtext TX_5802
	scriptjump @npcLoop

@saidYes1:
	asm15 patch_updateTextSubstitution
	showtextnonexitable TX_5804
	jumpiftextoptioneq $00, @saidYes2
	showtext TX_5805
	scriptjump @npcLoop

@saidYes2:
	asm15 patch_jump
	wait 8
	showtext TX_5806
	wait 8
	scriptend


patch_downstairsScript_body:
	initcollisions
@npcLoop:
	checkabutton
	showtextnonexitable TX_5807
	jumpiftextoptioneq $01, @saidNo

	showtextnonexitable TX_5808
	jumpiftextoptioneq $00, @beginGame

	asm15 patch_updateTextSubstitution
	showtextnonexitable TX_5809
	jumpiftextoptioneq $00, @beginGame

@saidNo:
	asm15 patch_updateTextSubstitution
	showtext TX_5805
	scriptjump @npcLoop

@beginGame:
	showtext TX_580a
	asm15 patch_setStairTile, TILEINDEX_STANDARD_FLOOR
	wait 8
	scriptend


; ==============================================================================
; INTERACID_MOBLIN
; ==============================================================================

;;
; Spawn the enemy that's going to replace this interaction
moblin_spawnEnemyHere:
	call getFreeEnemySlot
	ret nz
	ld (hl),ENEMYID_MASKED_MOBLIN
	jp objectCopyPosition


; ==============================================================================
; INTERACID_CARPENTER
; ==============================================================================

;;
; @param	a	Position to build bridge (top part)
carpenter_buildBridgeColumn:
	ld c,a
	ld a,TILEINDEX_HORIZONTAL_BRIDGE_TOP
	call setTile
	ld a,c
	add $10
	ld c,a
	ld a,TILEINDEX_HORIZONTAL_BRIDGE_BOTTOM
	call setTile
	ld hl,wTmpcfc0.carpenterSearch.cfd0
	inc (hl)
	ld a,SND_DOORCLOSE
	jp playSound


; Head carpenter
carpenter_subid00Script_body:
	makeabuttonsensitive
@npcLoop:
	setanimation $04
	checkabutton
	setanimation $05
	jumpifglobalflagset GLOBALFLAG_GOT_FLUTE, @haveFlute

	; Don't have flute
	showtextlowindex <TX_2301
	setglobalflag GLOBALFLAG_TALKED_TO_HEAD_CARPENTER
	scriptjump @npcLoop

@haveFlute:
	jumpifmemoryeq wTmpcfc0.carpenterSearch.cfd0, $01, @alreadyAgreedToSearch
	showtextlowindex <TX_2302
	jumpiftextoptioneq $00, @agreedToHelp

	; Refused to help
	showtextlowindex <TX_2303
	scriptjump @npcLoop

@agreedToHelp:
	showtextlowindex <TX_2304
@repeatExplanation:
	jumpiftextoptioneq $00, ++
	showtextlowindex <TX_2305
	scriptjump @repeatExplanation
++
	writememory wTmpcfc0.carpenterSearch.cfd0, $01
	scriptjump @npcLoop

@alreadyAgreedToSearch:
	showtextlowindex <TX_2306
	scriptjump @npcLoop



; ==============================================================================
; INTERACID_RAFTWRECK_CUTSCENE
; ==============================================================================
raftwreckCutsceneScript_body:
	wait 8
	playsound SNDCTRL_FAST_FADEOUT
	asm15 setLinkDirection, DIR_UP
	setangle ANGLE_UP
	applyspeed $6c
	wait 60

	playsound MUS_DISASTER
	asm15 darkenRoom
	writememory hSprPaletteSources, $00
	writememory hDirtySprPalettes,  $00
	checkpalettefadedone
	wait 90

	writememory wTmpcfc0.genericCutscene.state, $01
	playsound SND_LIGHTNING
	wait 34

	playsound SND_LIGHTNING
	checkmemoryeq wTmpcfc0.genericCutscene.state, $02

	asm15 raftwreckCutscene_spawnHelperSubid, $03
	wait 20

	writeobjectbyte Interaction.var38, $01 ; Enable "oscillation" of raft's Y pos
	setspeed SPEED_080
	asm15 setLinkDirection, DIR_RIGHT
	setangle ANGLE_LEFT
	applyspeed $61
	wait 90

	writeobjectbyte Interaction.var38, $00 ; Disable oscillation
	setspeed SPEED_0c0
	setangle ANGLE_RIGHT
	applyspeed $41
	wait 30

	playsound SND_WIND
	asm15 raftwreckCutscene_spawnHelperSubid, $04
	wait 10

	setspeed SPEED_140
	setangle ANGLE_LEFT
	applyspeed $31
	wait 90

	asm15 raftwreckCutscene_spawnHelperSubid, $05
	writeobjectbyte Interaction.var38, $01 ; Enable oscillation
	setspeed SPEED_080
	setangle ANGLE_RIGHT
	applyspeed $ff
	wait 60
	scriptend

;;
; Deals with spawning instances of INTERACID_RAFTWRECK_CUTSCENE (creates wind and
; lightning strikes)
raftwreckCutscene_spawnHelperSubid:
	ld b,a
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERACID_RAFTWRECK_CUTSCENE_HELPER
	inc l
	ld (hl),b
	ret


; ==============================================================================
; INTERACID_TOKKEY
; ==============================================================================

;;
tokkey_jump:
	ld bc,-$1a0
	jp objectSetSpeedZ

;;
tokkey_centerLinkOnTile:
	ld hl,w1Link.y
	call centerCoordinatesOnTile
	ld l,<w1Link.direction
	ld (hl),$01
	ret

tokkey_makeLinkPlayTuneOfCurrents:
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERACID_PLAY_HARP_SONG
	inc l
	inc (hl)
	ret


tokkayScript_justHeardTune_body:
	asm15 tokkey_jump
	wait 60

	showtextlowindex <TX_2c02
	setmusic SNDCTRL_STOPMUSIC
	setspeed SPEED_100
	moveright $10

	asm15 tokkey_jump
	movedown $0a

	setmusic MUS_CRAZY_DANCE
	wait 125

	setstate $02
	xorcfc0bit 1
	setspeed SPEED_180
	moveleft $10
	wait 15

	callscript mainScripts.tokkeyScriptFunc_runAcrossDesk
	callscript mainScripts.tokkeyScriptFunc_runAcrossDesk

	setstate $04 ; Stop movement animation
	wait 120

	xorcfc0bit 1
	setstate $02 ; Resume animation
	moveright $10

	setanimation $02
	xorcfc0bit 1
	wait 70

	setstate $03 ; Faster animation
	moveright $10
	setanimation $02
	wait 15

	callscript mainScripts.tokkeyScriptFunc_hopAcrossDesk
	callscript mainScripts.tokkeyScriptFunc_hopAcrossDesk

	moveleft $10

	setanimation $02
	wait 90

	playsound SNDCTRL_STOPMUSIC
	playsound SND_BIG_EXPLOSION
	xorcfc0bit 1
	setstate $02
	setspeed SPEED_100
	asm15 tokkey_jump
	movedown $18

	setanimation $03
	asm15 tokkey_centerLinkOnTile
	wait 90

	showtextlowindex <TX_2c03
	wait 60

	asm15 tokkey_makeLinkPlayTuneOfCurrents
	checkcfc0bit 7 ; Wait for Link to finish
	wait 60

	playsound SNDCTRL_STOPSFX
	giveitem TREASURE_OBJECT_TUNE_OF_CURRENTS_00
	xorcfc0bit 0
	orroomflag $40
	enableinput
	resetmusic
	setcollisionradii $06, $06
	setstate $01
	scriptjump mainScripts.tokkeyScript_alreadyTaughtTune


; ==============================================================================
; INTERACID_ZORA
; ==============================================================================
;;
zora_createExclamationMark:
	ld bc,$f200
	ld a,30
	jp objectCreateExclamationMark

;;
zora_beginJump:
	ld bc,-$100
	jp objectSetSpeedZ

;;
zora_makeLinkFaceDown:
	ld a,$02
	ld (w1Link.direction),a
	jp clearAllParentItems

;;
zora_moveToLinksXPosition:
	ld a,(w1Link.xh)
	ld b,a
	ld e,Interaction.xh
	ld a,(de)
	sub b
	ld e,Interaction.counter2
	ld (de),a
	ret

;;
; Zora subid 10 waits for Link to move down before starting cutscene
zora_waitForLinkToMoveDown:
	ld a,(w1Link.yh)
	cp $18
	ld a,$01
	jr nc,+
	dec a
+
	ld (wTmpcfc0.genericCutscene.cfc1),a
	ret

;;
zora_checkIsLinkedGame:
	call checkIsLinkedGame
	ld a,$01
	jr nz,+
	dec a
+
	ld (wTmpcfc0.genericCutscene.cfc1),a
	ret

;;
zora_createExclamationMarkToTheRight:
	ld a,SND_CLINK
	call playSound
	ld a,$2d
	ld bc,$f808
	jp objectCreateExclamationMark

;;
zora_setLinkDirectionUp:
	ld a,$00
	jr ++
;;
zora_setLinkDirectionRight:
	ld a,$01
	jr ++
;;
; Unused
zora_setLinkDirectionDown:
	ld a,$02
	jr ++
;;
; Unused
zora_setLinkDirectionLeft:
	ld a,$03
++
	ld (w1Link.direction),a
	ret


; ==============================================================================
; INTERACID_ZELDA
; ==============================================================================

;;
zelda_warpOutOfVireMinigame:
	ld a,SNDCTRL_STOPMUSIC
	call playSound
	xor a
	ld (wDisabledObjects),a
	ld (wMenuDisabled),a
	ld a,GLOBALFLAG_ZELDA_SAVED_FROM_VIRE
	call setGlobalFlag
	ld hl,@warpDest
	jp setWarpDestVariables

@warpDest:
	m_HardcodedWarpA ROOM_AGES_065, $00, $85, $03

;;
zelda_giveBlueJoyRing:
	ldbc BLUE_JOY_RING, $00
	jp giveRingToLink


zeldaSubid01Script_body:
	asm15 objectSetInvisible
	checkmemoryeq wTmpcfc0.genericCutscene.state, $01

	asm15 objectSetVisible82
	checkmemoryeq wTmpcfc0.genericCutscene.state, $06

	setanimation $03
	wait 8

	writememory wTmpcfc0.genericCutscene.state, $07
	showtext TX_3d0c
	wait 10

	setanimation $07
	setangle $18
	setspeed SPEED_020
	applyspeed $1e

	writememory wTmpcfc0.genericCutscene.state, $08
	scriptend


zeldaSubid02Script_body:
	wait 180
	setspeed SPEED_080
	moveleft $c0

	writeobjectbyte Interaction.var39, $01
	wait 120

	setanimation $00
	wait 150

	writememory wTmpcfc0.genericCutscene.cfdf, $01
	scriptend


zeldaSubid03Script_body:
	checkobjectbyteeq Interaction.substate, $01
	wait 30

	setspeed SPEED_100
	moveright $19
	wait 4

	moveup $10
	wait 4

	moveright $0d
	wait 8

	setmusic MUS_ZELDA_SAVED
	showtext TX_0601
	asm15 zelda_giveBlueJoyRing
	wait 30

	showtext TX_0602
	wait 30

	asm15 zelda_warpOutOfVireMinigame
	scriptend


zeldaSubid05Script_body:
	checkpalettefadedone
	wait 60

	setspeed SPEED_080
	movedown $61
	wait 60

	asm15 createExclamationMark, 40
	setanimation $08
	wait 60

	setspeed SPEED_100
	writememory wTmpcfc0.genericCutscene.cfd1, $01
	movedown $31
	wait 6

	writememory wTmpcfc0.genericCutscene.cfd1, $02
	setanimation $03
	checkmemoryeq wTmpcfc0.genericCutscene.cfd1, $03

	showtext TX_0600
	wait 120

	writememory wTmpcfc0.genericCutscene.cfdf, $ff
	scriptend


; ==============================================================================$08
; INTERACID_TWINROVA_IN_CUTSCENE
; ==============================================================================$08
twinrovaInCutsceneScript_body:
	wait 120
	showtextlowindex <TX_2809
	wait 30
	showtextlowindex <TX_280a
	wait 30
	scriptend


; ==============================================================================
; INTERACID_VIRE
; ==============================================================================
vire_activateMusic:
	xor a
	ld (wActiveMusic),a
	ld a,MUS_MINIBOSS
	jp playSound


; ==============================================================================
; INTERACID_SYMMETRY_NPC
; ==============================================================================
;;
; Puts a value in wTmpcfc0.genericCutscene.cfc1:
;   - 0: If haven't got tuni nut yet
;   - 1: If tuni nut isn't repaired yet
;   - 2: If tuni nut is repaired
symmetryNpc_getTuniNutState:
	ld a,TREASURE_TUNI_NUT
	call checkTreasureObtained
	ld b,$00
	jr nc,++
	inc b
	or a
	jr z,++
	inc b
++
	ld a,b
	ld (wTmpcfc0.genericCutscene.cfc1),a
	ret

;;
; Sets room flag bit 0 if we talked to the right sister, instead of the left one?
symmetryNpc_setRoomFlagIfTalkedToRightSister:
	call getThisRoomFlags
	ld e,Interaction.subid
	ld a,(de)
	sub $08
	or (hl)
	ld (hl),a
	ret

;;
symmetryNpc_getTuniNutStateForSister:
	call symmetryNpc_getTuniNutState
	ld a,(wTmpcfc0.genericCutscene.cfc1)
	or a
	ret nz

	; Tuni nut has been obtained

	ld e,Interaction.subid
	ld a,(de)
	sub $08
	ld b,a
	call getThisRoomFlags
	and $0f
	cp b
	ld c,$00
	jr z,+
	ld c,$03
+
	ld a,c
	ld (wTmpcfc0.genericCutscene.cfc1),a
	ret

;;
; Sets wTextNumberSubstitution with the capacity for the next level ring box.
symmetryNpc_getUpgradeCapacityForText:
	ld a,TREASURE_RING_BOX
	call checkTreasureObtained
	jr c,@haveRingBox
	ld c,$03
	jr ++

@haveRingBox:
	ld a,(wRingBoxLevel)
	dec a
	ld c,$03
	jr z,++
	ld c,$05
++
	ld hl,wTextNumberSubstitution
	ld (hl),c
	inc hl
	ld (hl),$00
	ret

; Sisters in the tuni nut building
symmetryNpcSubid8And9Script:
	jumpifglobalflagset GLOBALFLAG_FINISHEDGAME, @postgame
	incstate ; [state] = 2
	jumpifglobalflagset GLOBALFLAG_TUNI_NUT_PLACED, mainScripts.symmetryNpcSubid8And9Script_afterTuniNutRestored

@loop:
	initcollisions
	checkabutton
	disableinput
	jumpifglobalflagset GLOBALFLAG_TALKED_TO_SYMMETRY_SISTER, @script15_7879

	showtextlowindex <TX_2d10
	jumpiftextoptioneq $00, @saidYes

	; Said no
	showtextlowindex <TX_2d13
	enableinput
	scriptjump @loop

@saidYes:
	asm15 symmetryNpc_setRoomFlagIfTalkedToRightSister
	setglobalflag GLOBALFLAG_TALKED_TO_SYMMETRY_SISTER
	showtextlowindex <TX_2d11

@repeat:
	jumpiftextoptioneq $00, @almostDoneTalking
	showtextlowindex <TX_2d14
	scriptjump @repeat

@almostDoneTalking:
	showtextlowindex <TX_2d12
	enableinput
	scriptjump @sister1

@script15_7879:
	enableinput
	asm15 symmetryNpc_getTuniNutStateForSister
	jumptable_memoryaddress wTmpcfc0.genericCutscene.cfc1
	.dw @sister1
	.dw @sister1Unused
	.dw @sister2Unused
	.dw @sister2

@sister1:
	rungenericnpclowindex <TX_2d12
@sister2:
	rungenericnpclowindex <TX_2d15

; Alternate text, don't think it's used
@sister1Unused:
	rungenericnpclowindex <TX_2d16
@sister2Unused:
	rungenericnpclowindex <TX_2d17

@postgame:
	initcollisions
@postgameLoop:
	checkabutton
	disableinput
	jumpifglobalflagset GLOBALFLAG_DONE_SYMMETRY_SECRET, @alreadyDoneSecret
	showtextlowindex <TX_2d24
	wait 30
	jumpiftextoptioneq $00, @askForSecret
	showtextlowindex <TX_2d25
	scriptjump @resume

@askForSecret:
	askforsecret SYMMETRY_SECRET
	wait 30
	jumpifmemoryeq wTextInputResult, $00, @validSecret
	showtextlowindex <TX_2d27
	scriptjump @resume

@validSecret:
	setglobalflag GLOBALFLAG_BEGAN_SYMMETRY_SECRET
	showtextlowindex <TX_2d26
	wait 30
	jumpifitemobtained TREASURE_RING_BOX, @haveRingBox

	; Don't have ring box, show different text
	showtextlowindex <TX_2d2a
	scriptjump @determineLevelToGive

@haveRingBox:
	showtextlowindex <TX_2d28
	wait 30
	showtextlowindex <TX_2d29

@determineLevelToGive:
	wait 30
	asm15 symmetryNpc_getUpgradeCapacityForText
	jumpifmemoryeq wTextNumberSubstitution, $05, @giveLevel3RingBox

	; Level 2 box
	giveitem TREASURE_OBJECT_RING_BOX_01
	scriptjump ++

@giveLevel3RingBox:
	giveitem TREASURE_OBJECT_RING_BOX_02
++
	wait 30
	orroomflag ROOMFLAG_ITEM
	setglobalflag GLOBALFLAG_DONE_SYMMETRY_SECRET

@alreadyDoneSecret:
	generatesecret SYMMETRY_RETURN_SECRET
	showtextlowindex <TX_2d2b

@resume:
	enableinput
	scriptjump @postgameLoop


; Brothers with the tuni nut
symmetryNpcSubid6And7Script:
	jumpifglobalflagset GLOBALFLAG_TALKED_TO_SYMMETRY_SISTER, @talkedToSisters
	rungenericnpclowindex <TX_2d0b

@talkedToSisters:
	jumpifglobalflagset GLOBALFLAG_TUNI_NUT_PLACED, @tuniNutPlaced
	jumpifroomflagset ROOMFLAG_40, @brotherWithoutTuniNut
	jumpifglobalflagset GLOBALFLAG_TALKED_TO_SYMMETRY_BROTHER, @brotherWithTuniNut

@brotherWithoutTuniNut:
	; Tells you to see his brother to get the tuni nut
	orroomflag ROOMFLAG_40
	setglobalflag GLOBALFLAG_TALKED_TO_SYMMETRY_BROTHER
	jumpifitemobtained TREASURE_TUNI_NUT, ++
	rungenericnpclowindex <TX_2d00
++
	rungenericnpclowindex <TX_2d01

@brotherWithTuniNut:
	asm15 symmetryNpc_getTuniNutState
	jumptable_memoryaddress wTmpcfc0.genericCutscene.cfc1
	.dw @dontHaveNut
	.dw @nutNotRepaired
	.dw @nutRepaired

@nutNotRepaired:
	rungenericnpclowindex <TX_2d08

@nutRepaired:
	rungenericnpclowindex <TX_2d09

@dontHaveNut:
	initcollisions
	checkabutton
	setdisabledobjectsto91
	showtextlowindex <TX_2d02
	disableinput
	wait 30
	showtextlowindex <TX_2d04
	scriptjump @respondToQuestion

@questionLoop:
	checkabutton
	showtextlowindex <TX_2d04
	disableinput

@respondToQuestion:
	jumpiftextoptioneq $00, @giveTuniNut
	showtextlowindex <TX_2d07
	enableinput
	scriptjump @questionLoop

@giveTuniNut:
	showtextlowindex <TX_2d05
	wait 30
	giveitem TREASURE_OBJECT_TUNI_NUT_00
	enableinput
	scriptjump @nutNotRepaired

@tuniNutPlaced:
	rungenericnpclowindex <TX_2d0a


; ==============================================================================
; INTERACID_PIRATE_CAPTAIN
; ==============================================================================

pirateCaptain_warpOut:
	ld hl,@unlinkedWarp
	call checkIsLinkedGame
	jr z,+
	ld hl,@linkedWarp
+
	jp setWarpDestVariables

@unlinkedWarp:
	m_HardcodedWarpA ROOM_AGES_1d7, $01, $45, $03

@linkedWarp:
	m_HardcodedWarpA ROOM_AGES_0c8, $01, $52, $03


pirateCaptainScript:
	initcollisions
@loop:
	checkabutton
	disableinput
	showtextdifferentforlinked TX_3600, TX_3601
	jumpiftextoptioneq $00, @gaveZoraScale
	enableinput
	scriptjump @loop

@gaveZoraScale:
	showtextdifferentforlinked TX_3604, TX_3605
	xorcfc0bit 0
	wait 60
	showtext TX_3607
	checkcfc0bit 1
	asm15 loseTreasure, TREASURE_ZORA_SCALE
	showtext TX_3606
	wait 30
	giveitem TREASURE_OBJECT_TOKAY_EYEBALL_00
	wait 60
	asm15 pirateCaptain_warpOut
	setglobalflag GLOBALFLAG_PIRATES_GONE
	scriptend


; ==============================================================================
; INTERACID_PIRATE
; ==============================================================================
;;
pirate_openEyeballCave:
	ld c,$54
	ld a,$a2
	call setTile
	inc c
	ld a,$ef
	call setTile
	inc c
	ld a,$a4
	call setTile
	ld a,SND_DOORCLOSE
	call playSound
	ldbc INTERACID_PUFF, $00
	jp objectCreateInteraction


; ==============================================================================
; INTERACID_TINGLE
; ==============================================================================
;;
tingle_createGlowAroundLink:
	ldbc INTERACID_SPARKLE,$04
	call objectCreateInteraction
	ret nz
	ld l,Interaction.counter1
	ld (hl),120
	ld a,(w1Link.yh)
	ld l,Interaction.yh
	ldi (hl),a
	inc l
	ld a,(w1Link.xh)
	ld (hl),a
	ret


; ==============================================================================
; INTERACID_TROY
; ==============================================================================
;;
troy_chooseRandomAnimalText:
	call getRandomNumber
	and $0f
	add <TX_2c13
	ld (wTextSubstitutions),a
	ret


; Troy at target carts
troySubid0Script:
	jumpifglobalflagset GLOBALFLAG_FINISHEDGAME, @postgame
	scriptend

@postgame:
	initcollisions
@loop:
	checkabutton
	disableinput
	jumpifglobalflagset GLOBALFLAG_DONE_TROY_SECRET, @alreadyDoneSecret
	jumpifmemoryeq wTmpcfc0.targetCarts.beganGameWithTroy, $00, @haventStartedGameYet
	jumpifmemoryeq wShootingGalleryccd5, $01, @returnedToScreenAfterGame

@haventStartedGameYet:
	jumpifglobalflagset GLOBALFLAG_BEGAN_TROY_SECRET, @alreadyBeganSecret

	; Asks if you have a secret
	showtext TX_2c06
	wait 30
	jumpiftextoptioneq $00, @askForSecret
	showtext TX_2c07
	enableinput
	scriptjump @loop

@askForSecret:
	askforsecret TROY_SECRET
	wait 30
	jumpifmemoryeq wTextInputResult, $00, @validSecret

	; Invalid secret
	showtext TX_2c09
	enableinput
	scriptjump @loop

@validSecret:
	setglobalflag GLOBALFLAG_BEGAN_TROY_SECRET
	showtext TX_2c08
	scriptjump @askToBeginGame

@alreadyBeganSecret:
	showtext TX_2c0e
@askToBeginGame:
	wait 30
	jumpiftextoptioneq $00, @beganGame
	showtext TX_2c0f
	enableinput
	scriptjump @loop

@beganGame:
	showtext TX_2c0a
	wait 30
	jumpiftextoptioneq $01, @beganGame
	showtext TX_2c0b
	writememory wTmpcfc0.targetCarts.beganGameWithTroy, $01
	enableinput

@waitingToCompleteGame:
	checkabutton
	showtext TX_2c10
	scriptjump @waitingToCompleteGame


@returnedToScreenAfterGame:
	writememory wShootingGalleryccd5, $00
	asm15 goron_targetCarts_checkHitAllTargets
	jumpifmemoryset wcddb, $80, @giveReward

	; Failed game
	enableinput
	scriptjump @waitingToCompleteGame

@giveReward:
	showtext TX_2c0c
	wait 30
	giveitem TREASURE_OBJECT_BOMBCHUS_02
	wait 30
	setglobalflag GLOBALFLAG_DONE_TROY_SECRET

@alreadyDoneSecret:
	generatesecret TROY_RETURN_SECRET
	showtext TX_2c0d
	enableinput
	scriptjump @loop


; Troy in his house
troySubid1Script:
	jumpifglobalflagset GLOBALFLAG_FINISHEDGAME, mainScripts.stubScript
	initcollisions
@loop:
	checkabutton
	jumpifroomflagset $40, ++
	asm15 troy_chooseRandomAnimalText
	showtext TX_2c11
	orroomflag $40
	scriptjump @loop
++
	asm15 troy_chooseRandomAnimalText
	showtext TX_2c12
	scriptjump @loop


; ==============================================================================

;;
; Check that a secret-related NPC should spawn (correct essence obtained)?
linkedNpc_checkShouldSpawn:
	call checkIsLinkedGame
	jr nz,++
	jp _writeFlagsTocddb
++
	ld e,Interaction.var3f
	ld a,(de)
	rst_jumpTable
	.dw @checkd4
	.dw @checkd1
	.dw @always
	.dw @always
	.dw @always
	.dw @always
	.dw @checkd2
	.dw @always
	.dw @always
	.dw @checkd2_2

@checkd4:
	ld a,$03
	jp checkEssenceNotObtained
@checkd1:
	ld a,$00
	jp checkEssenceNotObtained
@checkd2:
	ld a,$01
	jp checkEssenceNotObtained
@checkd2_2:
	ld a,$01
	jp checkEssenceNotObtained
@always:
	or d
	jp _writeFlagsTocddb

;;
; Checks whether the linked NPC asks you for additional confirmation before giving you the
; secret (some of them have an extra box of text)
linkedNpc_checkHasExtraTextBox:
	ld e,Interaction.var3f
	ld a,(de)
	ld hl,@data
	rst_addAToHl
	ld a,(hl)
	or a
	jp _writeFlagsTocddb

@data:
	.db $01 $01 $01 $00 $00 $00 $01 $00 $00 $01

;;
linkedNpc_generateSecret:
	ld h,d
	ld l,Interaction.var3f
	ld b,(hl)
	ld a,GLOBALFLAG_FIRST_AGES_BEGAN_SECRET
	add b
	call setGlobalFlag
	ld a,$20
	add b
	ld (wShortSecretIndex),a
	ld bc,$0003
	jp secretFunctionCaller

;;
linkedNpc_initHighTextIndex:
	ld a,>TX_4d00
	jp interactionSetHighTextIndex

;;
; Loads a text index for linked npcs. Each linked npc has text indices that they say.
;
; @param	a	Index of text (0-4)
linkedNpc_calcLowTextIndex:
	add <TX_4d00
	ld c,a

	; a = [var3f]*5
	ld e,Interaction.var3f
	ld a,(de)
	ld b,a
	add a
	add a
	add b

	add c
	ld e,Interaction.textID
	ld (de),a
	ret


; ==============================================================================
; INTERACID_PLEN
; ==============================================================================
plenSubid0Script:
	jumpifglobalflagset GLOBALFLAG_FINISHEDGAME, @finishedGame
	jumpifglobalflagset GLOBALFLAG_SAVED_NAYRU, @savedNayru
	rungenericnpc TX_3714

@savedNayru:
	rungenericnpc TX_3715

@finishedGame:
	initcollisions
@loop:
	checkabutton
	disableinput
	jumpifglobalflagset GLOBALFLAG_DONE_PLEN_SECRET, @alreadyCompletedSecret

	; He can be given a secret
	showtext TX_3700
	wait 30
	jumpiftextoptioneq $00, @giveSecret
	showtext TX_3701
	scriptjump @resume

@giveSecret:
	askforsecret PLEN_SECRET
	wait 30
	jumpifmemoryeq wTextInputResult, $00, @validSecret
	; Bad secret
	showtext TX_3703
	scriptjump @resume

@validSecret:
	setglobalflag GLOBALFLAG_BEGAN_PLEN_SECRET
	showtext TX_3702
	wait 30
	asm15 giveRingAToLink, SPIN_RING
	setglobalflag GLOBALFLAG_DONE_PLEN_SECRET
	wait 30
	showtext TX_3704
	scriptjump @resume

@alreadyCompletedSecret:
	showtext TX_3705

@resume:
	enableinput
	scriptjump @loop


; ==============================================================================
; INTERACID_GREAT_FAIRY
; ==============================================================================
greatFairy_checkScreenIsScrolling:
	ld a,(wScrollMode)
	and $01
	call _writeFlagsTocddb
	cpl
	ld (wcddb),a
	ret


; ==============================================================================
; INTERACID_SLATE_SLOT
; ==============================================================================

;;
; Unused?
slateSlot_7b21:
	ld a,(wNumSlates)
	or a
	ld b,$01
	jr nz,+
	dec b
+
	ld a,b
	ld (wTmpcfc0.genericCutscene.cfc1),a
	ret

;;
slateSlot_placeSlate:
	ld a,SND_DOORCLOSE
	call playSound

	; Set this tile to a "filled slate"  tile
	call objectGetTileAtPosition
	ld c,l
	ld e,Interaction.subid
	ld a,(de)
	ld b,a
	ld a,TILEINDEX_FILLED_SLATE_1
	add b
	call setTile

	; Mark room flag
	call getThisRoomFlags
	ld e,Interaction.subid
	ld a,(de)
	ld bc,bitTable
	add c
	ld c,a
	ld a,(bc)
	or (hl)
	ld (hl),a

	; Decrement # slates
	ld hl,wNumSlates
	dec (hl)

	; Light torches
	ld e,Interaction.subid
	ld a,(de)
	ld hl,@torchPositions
	rst_addDoubleIndex
	ldi a,(hl)
	ld c,a
	ld a,TILEINDEX_LIT_TORCH
	push hl
	call setTile
	pop hl
	ld a,(hl)
	ld c,a
	ld a,TILEINDEX_LIT_TORCH
	jp setTile

@torchPositions:
	.db $86 $88 ; 0 == [subid]
	.db $4b $6b ; 1
	.db $26 $28 ; 2
	.db $43 $63 ; 3


; ==============================================================================
; INTERACID_MISCELLANEOUS_2
; ==============================================================================
;;
interactiondc_removeGraveyardGateTiles1:
	ld a,$0a
	call setScreenShakeCounter
	ld a,$3a
	ld c,$34
	call setTile
	ld a,$3a
	ld c,$44
	call setTile

	ld hl,@interleavedTiles
	call _interactiondc_7bde
	call _interactiondc_7bde
	call _interactiondc_7bde
	call _interactiondc_7bde

	ld bc,$4840
	call _interactiondc_spawnPuff
	ld bc,$4850
	jp _interactiondc_spawnPuff

@interleavedTiles:
	.db $33 $3a $89 $01
	.db $35 $3a $89 $03
	.db $43 $98 $ec $01
	.db $45 $9a $ec $03

;;
interactiondc_removeGraveyardGateTiles2:
	ld a,$0a
	call setScreenShakeCounter
	ld a,$3a
	ld c,$33
	call setTile
	ld a,$3a
	ld c,$35
	call setTile
	ld a,$3a
	ld c,$43
	call setTile
	ld a,$3a
	ld c,$45
	call setTile
	ld bc,$4830
	call _interactiondc_spawnPuff
	ld bc,$4860
	jp _interactiondc_spawnPuff

;;
_interactiondc_7bde:
	ldi a,(hl)
	ldh (<hFF8C),a
	ldi a,(hl)
	ldh (<hFF8F),a
	ldi a,(hl)
	ldh (<hFF8E),a
	ldi a,(hl)
	push hl
	call setInterleavedTile
	pop hl
	ret

;;
_interactiondc_spawnPuff:
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERACID_PUFF
	ld l,Interaction.yh
	ld (hl),b
	ld l,Interaction.xh
	ld (hl),c
	ret
