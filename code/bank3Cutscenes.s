;;
; Used for CUTSCENE_FLAMES_FLICKERING and CUTSCENE_TWINROVA_SACRIFICE.
twinrovaCutsceneCaller:
	ld a,c
	rst_jumpTable
	.dw cutscene18_body
	.dw cutscene19_body

;;
incCutsceneState:
	ld hl,wCutsceneState
	inc (hl)
	ret

;;
; Unused
unused_incTmpcbb3:
	ld hl,wTmpcbb3
	inc (hl)
	ret

;;
decTmpcbb4:
	ld hl,wTmpcbb4
	dec (hl)
	ret

;;
setScreenShakeCounterTo255:
	ld a,$ff
	jp setScreenShakeCounter

;;
; State 0: screen fadeout
twinrovaCutscene_state0:
	ld a,$04
	call fadeoutToWhiteWithDelay
	ld hl,wTmpcbb3
	ld b,$10
	call clearMemory
	jr incCutsceneState

;;
; State 1: fading out, then initialize fadein to zelda sacrifice room
twinrovaCutscene_state1:
	ld a,(wPaletteThread_mode)
	or a
	ret nz

	call incCutsceneState

	ld a,<ROOM_ZELDA_IN_FINAL_DUNGEON ; Room with zelda and torches
	ld (wActiveRoom),a
	call twinrovaCutscene_fadeinToRoom

	call refreshObjectGfx

	ld hl,w1Link.yh
	ld (hl),$38
	inc l
	inc l
	ld (hl),$78

	call resetCamera

	ld hl,objectData.objectData4022
	call parseGivenObjectData

	ld a,PALH_ac
	call loadPaletteHeader

	ld a,$01
	ld (wScrollMode),a

	call loadCommonGraphics

	ld a,$04
	call fadeinFromWhiteWithDelay
	ld a,$02
	jp loadGfxRegisterStateIndex

;;
twinrovaCutscene_fadeinToRoom:
	call disableLcd
	call clearScreenVariablesAndWramBank1
	call loadScreenMusicAndSetRoomPack
	call loadTilesetData
	call loadTilesetGraphics
	jp func_131f

;;
; CUTSCENE_FLAMES_FLICKERING
cutscene18_body:
	ld a,(wCutsceneState)
	rst_jumpTable
	.dw twinrovaCutscene_state0
	.dw twinrovaCutscene_state1
	.dw twinrovaCutscene_state2
	.dw twinrovaCutscene_state3
	.dw cutscene18_state4
	.dw cutscene18_state5

;;
; State 2: waiting for fadein to finish
twinrovaCutscene_state2:
	ld a,(wPaletteThread_mode)
	or a
	ret nz
	ld a,$01
	ld (wTmpcbb4),a
	jp incCutsceneState

;;
; State 3: initializes stuff for state 4
twinrovaCutscene_state3:
	call decTmpcbb4
	ret nz

	ld (hl),180 ; Wait in state 4 for 180 frames

	call twinrovaCutscene_deleteAllInteractionsExceptFlames
	call twinrovaCutscene_loadAngryFlames
	ld a,SND_OPENING
	call playSound
	jp incCutsceneState

;;
; State 4: screen shaking, flames flickering with zelda on pedestal
cutscene18_state4:
	call setScreenShakeCounterTo255
	ld a,(wFrameCounter)
	and $3f
	jr nz,+
	ld a,SND_OPENING
	call playSound
+
	call decTmpcbb4
	ret nz

	; Fadeout
	ld a,$04
	call fadeoutToWhiteWithDelay

	jp incCutsceneState

;;
; State 5: fading out again. When done, it fades in to the next room, and the cutscene's
; over.
cutscene18_state5:
	call setScreenShakeCounterTo255
	ld a,(wPaletteThread_mode)
	or a
	ret nz

	; Load twinrova fight room, start a fadein, then exit cutscene
.ifdef ROM_AGES
	ld a,$f5
.else
	ld a,$9e
.endif
	ld (wActiveRoom),a
	call twinrovaCutscene_fadeinToRoom

	call getFreeEnemySlot
	ld (hl),ENEMY_TWINROVA
	ld l,Enemy.var03
	set 7,(hl)

	ld hl,w1Link.enabled
	ld (hl),$03
	ld l,<w1Link.yh
	ld (hl),$78
	inc l
	inc l
	ld (hl),$78

	call resetCamera
	ld a,CUTSCENE_INGAME
	ld (wCutsceneIndex),a
	ld a,$01
	ld (wScrollMode),a
	call loadCommonGraphics

	ld a,$02
	call fadeinFromWhiteWithDelay
	ld a,$02
	jp loadGfxRegisterStateIndex

;;
twinrovaCutscene_deleteAllInteractionsExceptFlames:
	ldhl FIRST_DYNAMIC_INTERACTION_INDEX, Interaction.start
@next:
	ld l,Interaction.start
	ldi a,(hl)
	or a
	jr z,+
	ldi a,(hl)
	cp INTERAC_TWINROVA_FLAME
	call z,@delete
+
	inc h
	ld a,h
	cp $e0
	jr c,@next
	ret

@delete:
	dec l
	ld b,$40
	jp clearMemory

;;
; Loads the "angry-looking" version of the flames.
twinrovaCutscene_loadAngryFlames:
.ifdef ROM_AGES
	ld a,PALH_af
.else
	ld a,PALH_SEASONS_af
.endif
	call loadPaletteHeader
	ld hl,objectData.objectData402f
	jp parseGivenObjectData

;;
; CUTSCENE_TWINROVA_SACRIFICE
cutscene19_body:
	ld a,(wCutsceneState)
	rst_jumpTable
	.dw twinrovaCutscene_state0
	.dw twinrovaCutscene_state1
	.dw twinrovaCutscene_state2
	.dw twinrovaCutscene_state3
	.dw cutscene19_state4
	.dw cutscene19_state5
	.dw cutscene19_state6
	.dw cutscene19_state7
	.dw cutscene19_state8
	.dw cutscene19_state9

;;
; After fading in to zelda on the pedestal, this shows the "angry flames" and waits for
; 3 seconds before striking the first flame with lightning.
cutscene19_state4:
	call decTmpcbb4
	ret nz

	ld (hl),20
	ld bc,$1878
cutscene19_strikeFlameWithLightning:
	call twinrovaCutscene_createLightningStrike
	jp incCutsceneState

;;
; State 5: wait before striking the 2nd flame with lightning.
cutscene19_state5:
	call decTmpcbb4
	ret nz

	ld (hl),20
	ld bc,$48a8
	jr cutscene19_strikeFlameWithLightning

;;
; State 6: wait before striking the 3rd flame with lightning.
cutscene19_state6:
	call decTmpcbb4
	ret nz

	ld (hl),40
	ld bc,$4848
	jr cutscene19_strikeFlameWithLightning

;;
; State 7: wait before shaking screen around
cutscene19_state7:
	call decTmpcbb4
	ret nz

	ld (hl),120
	ld a,SND_BOSS_DEAD
	call playSound
	jp incCutsceneState

;;
; State 8: shake the screen and repeatedly flash the screen white
cutscene19_state8:
	call setScreenShakeCounterTo255
	ld a,(wFrameCounter)
	and $07
	call z,fastFadeinFromWhite
	call decTmpcbb4
	ret nz

	ld a,$04
	call fadeoutToWhiteWithDelay
	ld a,SND_FADEOUT
	call playSound
	jp incCutsceneState

;;
; State 9: wait before fading back to twinrova. Cutscene ends here.
cutscene19_state9:
	call setScreenShakeCounterTo255
	ld a,(wPaletteThread_mode)
	or a
	ret nz

	call clearScreenVariablesAndWramBank1
	ld a,CUTSCENE_INGAME
	ld (wCutsceneIndex),a
	ld a,$01
	ld (wScrollMode),a

	call getFreeEnemySlot
	ld (hl),ENEMY_GANON

	ld a,SNDCTRL_STOPMUSIC
	jp playSound

;;
; @param	bc	Position to strike
twinrovaCutscene_createLightningStrike:
	call getFreePartSlot
	ret nz
	ld (hl),PART_LIGHTNING
	inc l
	inc (hl)
	ld l,Part.yh
	ld (hl),b
	inc l
	inc l
	ld (hl),c
	ret

;;
; This function is part of the main loop until the player reaches the file select screen.
runIntro:
	ldh a,(<hSerialInterruptBehaviour)
	or a
	jr z,+

	call serialFunc_0c8d
	ld a,$09
	ld (wTmpcbb4),a
	jr @nextStage
+
	call serialFunc_0c85
	ld a,$03
	ldh (<hFFBE),a
	xor a
	ldh (<hSerialLinkState),a
	ld a,(wKeysJustPressed)
	and BTN_START
	jr z,intro_runStage

@nextStage:
	ldh a,(<hIntroInputsEnabled)
	add a
	jr z,intro_runStage

	ld a,(wIntroStage)
	cp $03
	jr nz,intro_gotoTitlescreen

;;
intro_runStage:
	ld a,(wIntroStage)
	rst_jumpTable
	.dw intro_japaneseOnlyScreen
	.dw intro_capcomScreen
	.dw intro_cinematic
	.dw intro_titlescreen
	.dw intro_restart

;;
; Advance the intro to the next stage (eg. cinematic -> titlescreen)
intro_gotoTitlescreen:
	call clearPaletteFadeVariables
	call cutscene_clearObjects
	ld hl,wIntroVar
	xor a
	ldd (hl),a
	ldh (<hCameraY),a
	ld (wTmpcbb6),a
	ld (hl),$03 ; hl = wIntroStage
	dec a
	ld (wTilesetAnimation),a
	jr intro_runStage

;;
intro_restart:
	xor a
	ld (wIntroStage),a
	ld (wIntroVar),a
	ret

;;
intro_gotoNextStage:
	call enableIntroInputs
	call clearDynamicInteractions
	ld hl,wIntroStage
	inc (hl)
	inc l
	ld (hl),$00 ; [wIntroVar] = 0
	jp clearPaletteFadeVariables

;;
intro_incState:
	ld hl,wIntroVar
	inc (hl)
	ret

;;
intro_japaneseOnlyScreen:
.ifndef REGION_JP
	ld hl,wIntroStage
	inc (hl)
.else
	ld a,(wIntroVar)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2

;;
@state0:
	call clearVram
	call restartSound

	ld a,GFXH_JAPANESE_INTRO_SCREEN
	call loadGfxHeader
	ld a,PALH_00
	call loadPaletteHeader

	ld a,60
	ld (wTmpcbb3),a

	call intro_incState
	xor a
	jp loadGfxRegisterStateIndex

;;
; Fading in, waiting
@state1:
	ld hl,wTmpcbb3
	dec (hl)
	ret nz

	call intro_incState
	jp fadeoutToWhite

;;
; Fading out
@state2:
	ld a,(wPaletteThread_mode)
	or a
	ret nz

	jr intro_gotoNextStage

.endif ; REGION_JP

;;
intro_capcomScreen:
	ld a,(wIntroVar)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2

;;
@state0:
	call restartSound

	call clearVram
	ld a,GFXH_NINTENDO_CAPCOM_SCREEN
	call loadGfxHeader
	ld a,PALH_01
	call loadPaletteHeader

	ld hl,wTmpcbb3
	ld (hl),208
	inc hl
	ld (hl),$00 ; [wTmpcbb4] = 0

	call intro_incState
	call fadeinFromWhite
	xor a
	jp loadGfxRegisterStateIndex

;;
; Fading in, waiting
@state1:
	ld hl,wTmpcbb3
	call decHlRef16WithCap
	ret nz

	call intro_incState
	jp fadeoutToWhite

;;
; Fading out
@state2:
	ld a,(wPaletteThread_mode)
	or a
	ret nz

	xor a
	ld hl,wIntroStage
	ld (hl),$02
	inc l
	ld (hl),a ; [wIntroVar] = 0
	ld (wIntro.cinematicState),a

.ifdef REGION_JP
	ret
.else
	jp enableIntroInputs
.endif

;;
intro_titlescreen:
	call getRandomNumber_noPreserveVars
	call @runState
	call clearOam

.ifdef ROM_AGES
	ld hl,bank3f.titlescreenMakuSeedSprite
	ld e,:bank3f.titlescreenMakuSeedSprite
	call addSpritesFromBankToOam

	ld a,(wTmpcbb3)
	and $20
	ret nz
	ld hl,bank3f.titlescreenPressStartSprites
	ld e,:bank3f.titlescreenPressStartSprites
	jp addSpritesFromBankToOam

.else; ROM_SEASONS

	ld hl,titlescreenMakuSeedSprite
	call addSpritesToOam

	ld a,(wTmpcbb3)
	and $20
	ret nz
	ld hl,titlescreenPressStartSprites
	jp addSpritesToOam
.endif

;;
@runState:
	ld a,(wIntroVar)
	rst_jumpTable
	.dw intro_titlescreen_state0
	.dw intro_titlescreen_state1
	.dw intro_titlescreen_state2
	.dw intro_titlescreen_state3

;;
intro_titlescreen_state0:
	call restartSound

	; Stop any irrelevant threads.
	ld a,THREAD_1
	call threadStop
	call stopTextThread

	call disableLcd
	ld a,GFXH_TITLESCREEN
	call loadGfxHeader
	ld a,PALH_03
	call loadPaletteHeader

	; cbb3-cbb4 used as a 2-byte counter until automatically exiting
	ld hl,wTmpcbb3
	ld a,$60
	ldi (hl),a
	ld a,$09
	ldi (hl),a ; [wTmpcbb4] = $09

	call intro_incState

	ld a,MUS_TITLESCREEN
	call playSound

	ld a,$04
	jp loadGfxRegisterStateIndex

;;
; State 1: waiting for player to press start
intro_titlescreen_state1:
	ld a,(wKeysJustPressed)
	and BTN_START
	jr nz,@pressedStart

	; Check to automatically exit the titlescreen
	ld hl,wTmpcbb3
	call decHlRef16WithCap
	ret nz
	ld a,$02
	jr @gotoState

@pressedStart:
	ld a,SND_SELECTITEM
	call playSound
	call disableSerialPort
	ld a,$03
@gotoState:
	ld (wIntroVar),a
	ld a,SNDCTRL_FAST_FADEOUT
	call playSound
	jp fadeoutToWhite

;;
; State 2: fading out to replay intro cinematic
intro_titlescreen_state2:
	ld a,(wPaletteThread_mode)
	or a
	ret nz
	jp intro_gotoNextStage

;;
; State 3: fading out to go to file select
intro_titlescreen_state3:
	ld a,(wPaletteThread_mode)
	or a
	ret nz

	; Initialize file select thread, stop this thread
	ld a,THREAD_1
	ld bc,fileSelectThreadStart
	call threadRestart
	jp stubThreadStart

.ifdef ROM_SEASONS

; In Ages these sprites are located elsewhere

titlescreenMakuSeedSprite:
	.db $12
	.db $51 $7a $56 $04
	.db $50 $82 $74 $04
	.db $58 $7a $6a $07
	.db $58 $82 $6c $07
	.db $58 $8a $6e $07
	.db $48 $90 $62 $06
	.db $44 $8d $68 $06
	.db $54 $8a $54 $03
	.db $54 $82 $52 $03
	.db $54 $7a $50 $03
	.db $40 $85 $66 $06
	.db $40 $7f $64 $06
	.db $41 $70 $60 $06
	.db $54 $76 $5a $06
	.db $44 $68 $5e $26
	.db $64 $7a $70 $03
	.db $64 $82 $72 $03
	.db $64 $8a $70 $23

titlescreenPressStartSprites:
	.db $0a
	.db $80 $2c $38 $00
	.db $80 $34 $3a $00
	.db $80 $3c $3c $00
	.db $80 $44 $3e $00
	.db $80 $4c $3e $00
	.db $80 $5c $3e $00
	.db $80 $64 $40 $00
	.db $80 $6c $42 $00
	.db $80 $74 $3a $00
	.db $80 $7c $40 $00

.endif

;;
runIntroCinematic:
	ld a,(wIntro.cinematicState)
	rst_jumpTable
	.dw introCinematic_ridingHorse
	.dw introCinematic_inTemple
	.dw introCinematic_preTitlescreen

.ifdef ROM_AGES

;;
; Covers intro sections after the capcom screen and before the temple scene.
introCinematic_ridingHorse:
	ld a,(wIntroVar)
	rst_jumpTable
	.dw introCinematic_ridingHorse_state0
	.dw introCinematic_ridingHorse_state1
	.dw introCinematic_ridingHorse_state2
	.dw introCinematic_ridingHorse_state3
	.dw introCinematic_ridingHorse_state4
	.dw introCinematic_ridingHorse_state5
	.dw introCinematic_ridingHorse_state6
	.dw introCinematic_ridingHorse_state7
	.dw introCinematic_ridingHorse_state8
	.dw introCinematic_ridingHorse_state9
	.dw introCinematic_ridingHorse_state10

;;
; State 0: initialization
introCinematic_ridingHorse_state0:
	call disableLcd
	ld hl,wOamEnd
	ld bc,$d000-wOamEnd
	call clearMemoryBc

	ld a,:w4TileMap
	ld ($ff00+R_SVBK),a
	ld hl,w4TileMap
	ld bc,$0120
	call clearMemoryBc

	ld hl,w4AttributeMap
	ld bc,$0120
	call clearMemoryBc
	ld a,$01
	ld ($ff00+R_SVBK),a

	call clearOam
	ld a,<wOam+$10
	ldh (<hOamTail),a

	ld a,GFXH_INTRO_LINK_RIDING_HORSE
	call loadGfxHeader
	ld a,PALH_90
	call loadPaletteHeader

	; Use cbb3-cbb4 as a 2-byte counter; wait for 0x15e=350 frames
	ld hl,wTmpcbb3
	ld (hl),$5e
	inc hl
	ld (hl),$01

	ld a,$20
	ld ($cbb8),a
	ld a,$10
	ld (wTmpcbb9),a
	ld a,$22
	ld (wTmpcbb6),a
	xor a
	ld (wTmpcbba),a

	ld a,MUS_INTRO_1
	call playSound

	ld a,$0b
	call fadeinFromWhiteWithDelay

	; The "bars" at the top and bottom need to be black
	ld hl,wLockBG7Color3ToBlack
	ld (hl),$01

	; Load Link and Bird objects
	ld hl,objectData.objectData4037
	call parseGivenObjectData

	ld a,$17
	call loadGfxRegisterStateIndex

	ld a,(wGfxRegs2.LCDC)
	ld (wGfxRegs6.LCDC),a
	xor a
	ldh (<hCameraX),a
	jp intro_incState

;;
; State 1: fading into the sunset
introCinematic_ridingHorse_state1:
	call introCinematic_moveBlackBarsIn
	ld hl,wTmpcbb3
	call decHlRef16WithCap
	ret nz

	ld (hl),$06
	call clearPaletteFadeVariablesAndRefreshPalettes
	ld a,$06
	ldh (<hNextLcdInterruptBehaviour),a
	jp intro_incState

;;
; State 2: scrolling down to reveal Link on horse
introCinematic_ridingHorse_state2:
	call introCinematic_ridingHorse_updateScrollingGround
	call decCbb3
	ret nz

	; Set counter to 6 frames (so screen scrolls down once every 6 frames)
	ld (hl),$06

	ld hl,wGfxRegs2.SCY
	inc (hl)
	ld a,(hl)
	ldh (<hCameraY),a ; Must set CameraY for sprites to scroll correctly

	; Go to next state once we scroll this far down
	cp $48
	ret nz
	ld a,126
	ld (wTmpcbb3),a
	jp intro_incState

;;
; Decrements the SCX value for the scrolling ground, and recalculates the value of LYC to
; use for producing the scrolling effect for the ground.
introCinematic_ridingHorse_updateScrollingGround:
	ld a,$a8
	ld hl,wGfxRegs2.SCY
	sub (hl)
	cp $78
	jr c,+
	ld a,$c7
+
	ld (wGfxRegs2.LYC),a
	ld a,(hl)
	ld hl,wGfxRegs6.SCY
	ldi (hl),a ; SCY should not change at hblank, so copy the value

	ld a,(wIntro.frameCounter) ; Only decrement SCX every other frame
	and $01
	ret nz
	dec (hl) ; hl = wGfxRegs6.SCX
	ret

;;
; State 3: camera has scrolled all the way down; not doing anything for a bit
introCinematic_ridingHorse_state3:
	call introCinematic_ridingHorse_updateScrollingGround
	call decCbb3
	ret nz

	; Initialize stuff for state 4

	ld (hl),$20
	inc hl
	ld (hl),$01

	ld a,PALH_96
	call loadPaletteHeader
	ld a,UNCMP_GFXH_AGES_38
	call loadUncompressedGfxHeader

	ld a,$18
	ld (wTmpcbba),a
	call loadGfxRegisterStateIndex

	xor a
	ldh (<hCameraY),a
	ld (wTmpcbbc),a

	ldbc INTERAC_INTRO_SPRITE, $03
	call createInteraction

	ld a,$0d
	ld (wTmpcbb6),a
	ld a,$3c
	ld (wTmpcbbb),a
	ld a,$03
	ldh (<hNextLcdInterruptBehaviour),a
	jp intro_incState

;;
; State 4: Link riding horse toward camera
introCinematic_ridingHorse_state4:
	call @drawLinkOnHorseAndScrollScreen
	ld hl,wTmpcbb3
	call decHlRef16WithCap
	ret nz

	ld a,UNCMP_GFXH_AGES_36
	call loadUncompressedGfxHeader

	; After calling "loadUncompressedGfxHeader", hl points to rom. They almost
	; certainly didn't intend to write there. They probably intended for hl to point
	; to wTmpcbb3, and set the counter for the next state?
	; It makes no difference, though, since the next state doesn't use wTmpcbb3.
	ld (hl),90

	ld a,PALH_9b
	call loadPaletteHeader
	call clearDynamicInteractions
	call clearOam
	ld a,$19
	call loadGfxRegisterStateIndex

	ld a,$48
	ld (wGfxRegs1.LYC),a
	ld (wGfxRegs2.WINY),a
	jp intro_incState

;;
@drawLinkOnHorseAndScrollScreen:
	ld hl,bank3f.linkOnHorseFacingCameraSprite
	ld e,:bank3f.linkOnHorseFacingCameraSprite
	call addSpritesFromBankToOam

	; Scroll the top, cloudy layer right every 32 frames
	ld a,(wIntro.frameCounter)
	and $1f
	jr nz,+
	ld hl,wGfxRegs1.SCX
	dec (hl)
+
	; Scroll the mountain layer right every 6 frames
	ld hl,wTmpcbb6
	dec (hl)
	jr nz,+
	ld (hl),$0d
	ld hl,wGfxRegs2.SCX
	dec (hl)
+
	; Change link's palette every 60 frames to gradually get lighter
	ld hl,wTmpcbbb
	dec (hl)
	ret nz
	ld (hl),60
	inc hl
	ld a,(hl)
	cp $03
	ret z

	inc (hl)
	ld hl,@linkPalettes
	rst_addAToHl
	ld a,(hl)
	jp loadPaletteHeader

@linkPalettes:
	.db PALH_a4
	.db PALH_a5
	.db PALH_a6

;;
; State 5: closeup of Link's face; face is moving left
introCinematic_ridingHorse_state5:
	call introCinematic_moveBlackBarsOut
	ld hl,wGfxRegs2.SCX
	ld a,(hl)
	add $08
	ld (hl),a
	cp $60
	ret c

	ld (hl),$60
	call intro_incState

	ld hl,wTmpcbb3
	ld (hl),24 ; Linger for another 24 frames

	ldbc INTERAC_INTRO_SPRITE, $04
	jp createInteraction

;;
; State 6: closeup of Link's face; screen staying still for a moment
introCinematic_ridingHorse_state6:
	ld hl,wTmpcbb3
	call decHlRef16WithCap
	ret nz

	call disableLcd
	ld a,PALH_92
	call loadPaletteHeader
	ld a,GFXH_INTRO_LINK_ON_HORSE_CLOSEUP
	call loadGfxHeader
	call clearDynamicInteractions
	ld a,$0a
	call loadGfxRegisterStateIndex
	jp intro_incState


.else; ROM_SEASONS

;;
; Covers intro sections after the capcom screen and before the temple scene.
introCinematic_ridingHorse:
	ld a,(wIntroVar)
	rst_jumpTable

	.dw introCinematic_ridingHorse_state0 ; First 3 states in Seasons are unique
	.dw introCinematic_ridingHorse_state1
	.dw introCinematic_ridingHorse_state2

	.dw introCinematic_ridingHorse_state7 ; Last 4 are the same as in Ages
	.dw introCinematic_ridingHorse_state8
	.dw introCinematic_ridingHorse_state9
	.dw introCinematic_ridingHorse_state10

;;
; State 0: initialization
introCinematic_ridingHorse_state0:
	call disableLcd
	ld hl,wOamEnd
	ld bc,$d000-wOamEnd
	call clearMemoryBc

	ld a,$10
	ldh (<hOamTail),a
	ld a,GFXH_INTRO_LINK_RIDING_HORSE
	call loadGfxHeader
	ld a,PALH_SEASONS_90
	call loadPaletteHeader

	; Use cbb3-cbb4 as a 2-byte counter; wait for 0x37e=894 frames
	ld hl,$cbb3
	ld (hl),$7e
	inc hl
	ld (hl),$03

	ld a,$20
	ld ($cbb8),a
	ld a,$10
	ld (wTmpcbb9),a
	ld a,$22
	ld (wTmpcbb6),a
	ld a,$01
	ld (wTmpcbba),a

	ld a,$08
	call loadGfxRegisterStateIndex

	ld a,MUS_INTRO_1
	call playSound

	call getFreeInteractionSlot
	jr nz,++
	ld (hl),INTERAC_INTRO_SPRITE
	inc l
	ld (hl),$00
++
	ld a,$14
	call fadeinFromWhiteWithDelay
	ld hl,wLockBG7Color3ToBlack
	ld (hl),$01
	jp intro_incState

;;
; State 1: screen fading in as Link rides closer
introCinematic_ridingHorse_state1:
	call introCinematic_moveBlackBarsIn
	ld hl,wTmpcbb3
	call decHlRef16WithCap
	ret nz

	call clearPaletteFadeVariablesAndRefreshPalettes
	ld a,PALH_SEASONS_96
	call loadPaletteHeader
	ld a,$0c
	call loadGfxRegisterStateIndex
	ld a,(wGfxRegs2.SCY)
	ld (wTmpcbbb),a
	ld a,(wGfxRegs2.SCX)
	ld (wTmpcbbc),a
	call introCinematic_ridingHorse_drawLinkOnHorseCloseupSprites_1
	ld hl,wTmpcbb3
	ld (hl),$58
	inc hl
	ld (hl),$01
	jp intro_incState

;;
; State 2: Image of Link bobbing up and down on horse
introCinematic_ridingHorse_state2:
	ld hl,wTmpcbb3
	call decHlRef16WithCap
	jr nz,++

	call disableLcd
	ld a,PALH_SEASONS_92
	call loadPaletteHeader
	ld a,GFXH_INTRO_LINK_ON_HORSE_CLOSEUP
	call loadGfxHeader
	ld a,$0a
	call loadGfxRegisterStateIndex
	call intro_incState
	jr introCinematic_ridingHorse_drawLinkOnHorseCloseupSprites_2
++
	call seasonsFunc_03_5367

	; Fall through

;;
; Draw the sprites that complement the image of Link on the horse (the 1st image)
introCinematic_ridingHorse_drawLinkOnHorseCloseupSprites_1:
	ld hl,wGfxRegs2.SCY
	ldi a,(hl)
	cpl
	inc a
	ld b,a
	ld a,(hl)
	cpl
	inc a
	ld c,a
	xor a
	ldh (<hOamTail),a
	ld hl,linkOnHorseCloseupSprites_1
	jp addSpritesToOam_withOffset

.endif; ROM_SEASONS

;;
; State 7 (3 in seasons): scrolling up on the link+horse shot
introCinematic_ridingHorse_state7:
	ld hl,wGfxRegs1.SCY
	dec (hl)
	jr nz,introCinematic_ridingHorse_drawLinkOnHorseCloseupSprites_2

	ld a,204 ; Linger on this shot for another 204 frames
	ld (wTmpcbb6),a
	call intro_incState

;;
; Draw the sprites that complement the image of Link on the horse (the 2nd image in
; seasons; the only such image in ages)
introCinematic_ridingHorse_drawLinkOnHorseCloseupSprites_2:
	; Calculate offset for sprites
	ld a,(wGfxRegs1.SCY)
	cpl
	inc a
	ld b,a
	xor a
	ldh (<hOamTail),a
	ld c,a

.ifdef ROM_AGES
	ld hl,bank3f.linkOnHorseCloseupSprites_2
	ld e,:bank3f.linkOnHorseCloseupSprites_2
	jp addSpritesFromBankToOam_withOffset

.else; ROM_SEASONS

	ld hl,linkOnHorseCloseupSprites_2
	jp addSpritesToOam_withOffset
.endif

;;
; State 8 (4 in seasons): lingering on the link+horse shot
introCinematic_ridingHorse_state8:
	ld hl,wTmpcbb6
	dec (hl)
	jr nz,introCinematic_ridingHorse_drawLinkOnHorseCloseupSprites_2

.ifdef ROM_AGES
	ld a,PALH_93
.else
	ld a,PALH_SEASONS_93
.endif
	call loadPaletteHeader
	call disableLcd
	call clearOam
	ld a,$10
	ldh (<hOamTail),a
	ld a,GFXH_INTRO_OUTSIDE_CASTLE
	call loadGfxHeader

	; Screen should be shifted a pixel every 5 frames next state
	ld a,$05
	ld (wTmpcbbb),a

	; Wait for $0190=400 frames in the next state
	ld hl,wTmpcbb3
	ld (hl),$90
	inc hl
	ld (hl),$01

	; How long to scroll the screen in the next state
	ld a,$b4
	ld (wTmpcbb6),a

	call clearPaletteFadeVariablesAndRefreshPalettes
	ld a,$0b
	call loadGfxRegisterStateIndex
	call introCinematic_ridingHorse_drawTempleSprites

	; Create 2 interactions of type INTERAC_INTRO_SPRITE with subid's 2 and 1.
	; (These are the horse and cliff sprites.)
	ld b,$02
--
	call getFreeInteractionSlot
	jr nz,++
	ld (hl),INTERAC_INTRO_SPRITE
	inc l
	ld (hl),b
	dec b
	jr nz,--
++
	jp intro_incState

;;
; State 9 (5 in seasons): showing Link on a cliff overlooking the temple
introCinematic_ridingHorse_state9:
	ld hl,wTmpcbb3
	call decHlRef16WithCap
	jr nz,+
	call fadeoutToWhite
	call intro_incState
	jr introCinematic_ridingHorse_drawTempleSprites
+
	ld hl,wTmpcbb6
	ld a,(hl)
	or a
	jr z,introCinematic_ridingHorse_drawTempleSprites

	; Check if the screen is done moving
	dec (hl)
	ld a,(wGfxRegs1.SCX)
	or a
	jr z,introCinematic_ridingHorse_drawTempleSprites

	; Shift screen once every 5 frames
	ld hl,wTmpcbbb
	dec (hl)
	jr nz,introCinematic_ridingHorse_drawTempleSprites
	ld (hl),$05
	ld hl,wGfxRegs1.SCX
	dec (hl)

;;
; In the scene overlooking the temple, a few sprites are used to touch up the appearance
; of the temple, even though it's mostly drawn on the background.
introCinematic_ridingHorse_drawTempleSprites:
	xor a
	ldh (<hOamTail),a
	ld b,a
	ld a,(wGfxRegs1.SCX)
	cpl
	inc a
	ld c,a

.ifdef ROM_AGES
	ld hl,bank3f.introTempleSprites
	ld e,:bank3f.introTempleSprites
	jp addSpritesFromBankToOam_withOffset

.else; ROM_SEASONS

	ld hl,introTempleSprites
	jp addSpritesToOam_withOffset
.endif

;;
; State 10 (6 in seasons): fading out, then proceed to next cinematic state (temple)
introCinematic_ridingHorse_state10:
	ld a,(wPaletteThread_mode)
	or a
	jr nz,introCinematic_ridingHorse_drawTempleSprites

	call clearDynamicInteractions
	jr incIntroCinematicState

;;
; @param[out]	zflag	nz if there's no more scrolling to be done
introCinematic_preTitlescreen_updateScrollingTree:
	ld hl,wTmpcbb6
	dec (hl)
	ret nz

	ld a,(wTmpcbba)
	ld (wTmpcbb6),a
	ld hl,wGfxRegs1.SCY
	dec (hl)
	ld a,(hl)
	cp $88
	ret z

	cp $10
	jr nz,@label_03_063

	ld a,UNCMP_GFXH_0d
	call loadUncompressedGfxHeader
	ld b,$04
--
	call getFreeInteractionSlot
	jr nz,@ret
	ld (hl),INTERAC_TITLESCREEN_CLOUDS
	inc l
	dec b
	ld (hl),b
	jr nz,--
	jr @ret

@label_03_063:
	cp $b0
	jr nz,@ret
	ld a,UNCMP_GFXH_2a
	call loadUncompressedGfxHeader
@ret:
	or $01
	ret

;;
incIntroCinematicState:
	ld hl,wIntro.cinematicState
	inc (hl)
	xor a
	ld (wIntroVar),a
	ret

;;
introCinematic_inTemple:
	ld a,(wIntroVar)
	rst_jumpTable
	.dw introCinematic_inTemple_state0
	.dw introCinematic_inTemple_state1
.ifdef ROM_SEASONS
	.dw introCinematic_inTemple_state1.5 ; Seasons has a pointless extra state
.endif
	.dw introCinematic_inTemple_state2
	.dw introCinematic_inTemple_state3
	.dw introCinematic_inTemple_state4
	.dw introCinematic_inTemple_state5
	.dw introCinematic_inTemple_state6
	.dw introCinematic_inTemple_state7
	.dw introCinematic_inTemple_state8
	.dw introCinematic_inTemple_state9
	.dw introCinematic_inTemple_state10

;;
; State 0: Load the room
introCinematic_inTemple_state0:
	call disableLcd
	call clearOam
	ld a,$10
	ldh (<hOamTail),a

	ld a,GFXH_INTRO_TEMPLE_SCENE
	call loadGfxHeader
.ifdef ROM_AGES
	ld a,PALH_91
.else
	ld a,PALH_SEASONS_91
.endif
	call loadPaletteHeader

	ld a,$09
	call loadGfxRegisterStateIndex

	ld a,(wGfxRegs1.SCY)
	ldh (<hCameraY),a

.ifdef ROM_AGES
	ld a,$10
.else
	ld a,$18
.endif
	ld (wTilesetAnimation),a
	call loadAnimationData

	ld a,$01
	ld (wScrollMode),a

	ld a,SPECIALOBJECT_LINK_CUTSCENE
	call setLinkID
	ld l,<w1Link.enabled
	ld (hl),$01

	ld l,<w1Link.yh
	ld a,(wGfxRegs1.SCY)
	add $60
	ld (hl),a
	ld l,<w1Link.xh
	ld (hl),$50

	; Intro input data was moved to another bank in Ages
.ifdef ROM_AGES
	ld hl,cutscenesBank10.templeIntro_simulatedInput
	ld a,:cutscenesBank10.templeIntro_simulatedInput
.else
	ld hl,templeIntro_simulatedInput
	ld a,:templeIntro_simulatedInput
.endif
	call setSimulatedInputAddress

	; Spawn the 3 pieces of triforce
	ld b,$03
	ld c,$30
@nextTriforce:
	call getFreeInteractionSlot
	jr nz,@doneSpawningTriforce
	ld (hl),INTERAC_INTRO_SPRITES_1
	inc l
	ld a,b
	dec a
	ld (hl),a

	ld l,Interaction.yh
	ld (hl),$19
	ld a,c
	ld l,Interaction.xh
	ld (hl),a
	add $20
	ld c,a
	ld a,c
	dec b
	jr nz,@nextTriforce

@doneSpawningTriforce:
	ld hl,wMenuDisabled
	ld (hl),$01
	call fadeinFromWhite
	xor a
	ld (wTmpcbb9),a
	jp intro_incState

;;
; State 1: walking up to triforce
introCinematic_inTemple_state1:
	ld a,(wPaletteThread_mode)
	or a
	ret nz

.ifdef ROM_SEASONS

	; Seasons has a pointless extra state; the devs removed this in Ages.
	jp intro_incState

introCinematic_inTemple_state1.5:

.endif

	; Check if simulated input is done (bit 7 set)
	ld a,(wUseSimulatedInput)
	rlca
	jp nc,introCinematic_inTemple_updateCamera
	xor a
	ld (wUseSimulatedInput),a
	call introCinematic_inTemple_updateCamera
	jp intro_incState

;;
; State 2: waiting for cutscene objects to do their thing (nothing to be done here)
introCinematic_inTemple_state2:
	; The "link cutscene object" will write to wIntro.triforceState eventually
	ld a,(wIntro.triforceState)
	cp $03
	ret nz

	call fadeoutToWhite
	jp intro_incState

;;
; State 3: screen fading out temporarily
introCinematic_inTemple_state3:
	ld a,(wPaletteThread_mode)
	or a
	ret nz

	; Initialize variables needed to make the screen "wavy"
	ld a,$01
	ld (wGfxRegs1.LYC),a
	inc a
	ld (wGfxRegs2.LYC),a
	ld a,$00
	ldh (<hNextLcdInterruptBehaviour),a
	ld a,$20
	call initWaveScrollValues
	call fadeinFromWhite
	call intro_incState

	; Fall through

;;
introCinematic_inTemple_updateWave:
	ld hl,wFrameCounter
	inc (hl)
	ld a,$02
	jp loadBigBufferScrollValues

;;
; State 4: screen fading back in
introCinematic_inTemple_state4:
	call introCinematic_inTemple_updateWave
	ld a,(wPaletteThread_mode)
	or a
	ret nz
	ld hl,wTmpcbb6
	ld (hl),120
	jp intro_incState

;;
; State 5: waving the screen around
introCinematic_inTemple_state5:
	call introCinematic_inTemple_updateWave
	ld hl,wTmpcbb6
	dec (hl)
	ret nz

	; a=0 here
	ld (wTmpcbb6),a
	dec a
	ld (wTmpcbba),a

	call intro_incState

	; Fall through

;;
; State 6: this is the instant where Link "falls"?
introCinematic_inTemple_state6:
	call introCinematic_inTemple_updateWave
	ld hl,wTmpcbb6
	ld b,$00
	call flashScreen_body
	ret z

	call clearPaletteFadeVariablesAndRefreshPalettes
	ld a,$06
	ld (wTmpcbb9),a
	ld a,SND_FAIRYCUTSCENE
	call playSound
	jp intro_incState

;;
; State 7: link is in the process of falling
introCinematic_inTemple_state7:
	call introCinematic_inTemple_updateWave
	ld a,(wTmpcbb9)
	cp $07
	ret nz

	; Finished falling; delete Link
	call clearLinkObject
	ld b,$08
	call func_2d48
	ld a,b
	ld (wTmpcbb6),a
	jp intro_incState

;;
; State 8: waiting?
introCinematic_inTemple_state8:
	call introCinematic_inTemple_updateWave
	ld hl,wTmpcbb6
	dec (hl)
	ret nz
	ld (hl),$3c
	jp intro_incState

;;
; State 9: waiting?
introCinematic_inTemple_state9:
	call introCinematic_inTemple_updateWave
	ld hl,wTmpcbb6
	dec (hl)
	ret nz
	ld a,SND_FADEOUT
	call playSound
	call fadeoutToWhite
	jp intro_incState

;;
; State 10: screen fading out, then moves on to the next cinematic state
introCinematic_inTemple_state10:
	call introCinematic_inTemple_updateWave
	ld a,(wPaletteThread_mode)
	or a
	ret nz
	call clearDynamicInteractions
	jp incIntroCinematicState

;;
; This function causes the screen to flash white. Based on parameter 'b', which acts as
; the "index" if the data to use, this will read through the predefined data to see on
; what frames it should turn the screen white, and on what frames it should restore the
; screen to normal.
;
; @param	b	Index of "screen flashing" data
; @param	hl	Counter to use (should start at 0?)
; @param[out]	zflag	nz if the flashing is complete (all data has been read).
flashScreen_body:
	ld a,b
	inc (hl)
	ld b,(hl)
	ld hl,screenFlashingData
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	ld c,$00
--
	ld a,(hl)
	bit 7,a
	ret nz
	cp b
	jr nc,+

	inc hl
	inc c
	jr --
+
	; Check if the index has changed from last time?
	ld a,c
	and $01
	ld c,a
	ld a,(wTmpcbba)
	cp c
	ret z
	ld a,c
	ld (wTmpcbba),a

	or a
	jr z,clearFadingPalettes_body
	call clearPaletteFadeVariablesAndRefreshPalettes
	xor a
	ret

;;
; Clears w2FadingBgPalettes, w2FadingSprPalettes (fills contents with $ff), and marks all
; palettes as needing refresh?
clearFadingPalettes_body:
	ld a,:w2FadingBgPalettes
	ld ($ff00+R_SVBK),a
	ld b,$80
	ld hl,w2FadingBgPalettes
	ld a,$ff
	call fillMemory

	ld a,$ff
	ldh (<hSprPaletteSources),a
	ldh (<hBgPaletteSources),a
	ldh (<hDirtySprPalettes),a
	ldh (<hDirtyBgPalettes),a
	xor a
	ld ($ff00+R_SVBK),a
	ret

.ifdef ROM_AGES

	screenFlashingData:
		.dw @data0
		.dw @data1
		.dw @data2
		.dw @data3
		.dw @data4
		.dw @data5

	; Data format:
	;  Even bytes are the frame numbers on which to turn the screen white; odd bytes
	;  are when to restore it to normal? $ff signals end of data.

	; Used by "raftwreck" cutscene before tokay island (INTERAC_RAFTWRECK_CUTSCENE)
	@data1:
		.db $02 $04 $06 $08 $0a $0c $ff

	@data0:
		.db $02 $04 $06 $0c $0e $ff

	; Used by ambi subid $03 (cutscene atop black tower after d7)
	@data2:
		.db $02 $04 $06 $08 $0a $0c $0e $ff

	@data3:
		.db $01 $05 $06 $0a $0b $0f $11 $15
		.db $16 $1a $1c $20 $22 $26 $28 $ff
	@data4:
		.db $03 $05 $07 $0a $0c $10 $12 $17
		.db $19 $ff
	@data5:
		.db $01 $02 $04 $06 $08 $0a $0c $ff

.else; ROM_SEASONS

	screenFlashingData:
		.dw @data0
		.dw @data1
		.dw @data2
		.dw @data3
		.dw @data4

		.db $03 ; ???

	@data1:
		.db $02 $04 $06 $08 $0c $0e $10 $ff
	@data0:
		.db $02 $04 $06 $0c $0e $ff
	@data2:
		.db $02 $04 $06 $08 $0a $0c $0e $ff
	@data3:
		.db $01 $05 $06 $0a $0b $0f $11 $15
		.db $16 $1a $1c $20 $22 $26 $28 $ff
	@data4:
		.db $01 $02 $04 $06 $08 $0a $0c $ff

.endif


;;
introCinematic_preTitlescreen:
	ld a,(wIntroVar)
	rst_jumpTable
	.dw introCinematic_preTitlescreen_state0
	.dw introCinematic_preTitlescreen_state1
	.dw introCinematic_preTitlescreen_state2
	.dw introCinematic_preTitlescreen_state3

;;
; State 0: load tree graphics
introCinematic_preTitlescreen_state0:
	call disableLcd

	ld a,$ff
	ld (wTilesetAnimation),a
	ld a,GFXH_TITLESCREEN_TREE_SCROLL
	call loadGfxHeader
.ifdef ROM_AGES
	ld a,PALH_94
.else
	ld a,PALH_SEASONS_94
.endif
	call loadPaletteHeader
	call refreshObjectGfx
	ld a,$0a
	call loadGfxRegisterStateIndex

	; Create the "tree branches" object
	call getFreeInteractionSlot
	jr nz,++
	ld (hl),INTERAC_INTRO_SPRITES_1
	inc l
	ld (hl),$08
	ld l,Interaction.y
	ld a,$60
	ldi (hl),a
	ldi (hl),a
	ld a,$3d
	inc l
	ldi (hl),a
++

	; Spawn birds
	ld b,$08
--
	call getFreeInteractionSlot
	jr nz,++
	ld (hl),INTERAC_INTRO_BIRD
	inc l
	dec b
	ld (hl),b
	jr nz,--
++
	ld a,$03
	ld (wTmpcbba),a
	ld (wTmpcbb6),a
	call fadeinFromWhite
	xor a
	ldh (<hCameraY),a

	ld a,MUS_INTRO_2
	call playSound

	jp intro_incState

;;
; State 1: scrolling up the tree
introCinematic_preTitlescreen_state1:
	call introCinematic_preTitlescreen_updateScrollingTree
	ret nz

	; Initialize stuff for state 2.

	call intro_incState
	ld hl,wTmpcbb3
	ld (hl),$02
	inc hl
	xor a
	ld (hl),a

	; wTmpcbb6 = counter until the sound effect should be played
	ld hl,wTmpcbb6
	ld (hl),$10

	inc a
	ld (wGfxRegs1.LYC),a
	inc a
	ld (wGfxRegs2.LYC),a
	ld a,$01
	ldh (<hNextLcdInterruptBehaviour),a

	; wBigBuffer will contain separate scrollY values for each line on the screen, in
	; order to produce the effect introducing the title.
	; Initialize it with normal values for scrollY for now.
	ld a,(wGfxRegs1.SCY)
	ld b,$90
	ld hl,wBigBuffer
--
	ldi (hl),a
	dec b
	jr nz,--

	ld a,$01

	; Fall through

;;
; Updates the effect where the title comes into view.
;
; @param	a	Number of pixels of the title to show (divided by two)
introCinematic_preTitlescreen_updateScrollForTitle:
	ld b,a

	; Calculate c=$18/b (the amount that the title needs to be shrunk)
	xor a
	ld c,a
--
	inc c
	add b
	cp $18
	jr z,+
	ret nc ; Should never return if given a valid parameter
	jr --
+
	; Calculate SCY values for the top half of the title
	push bc
	ld a,$38 ; vertical center of title
	sub b
	ld h,>wBigBuffer
	ld l,a
	xor a
--
	push af
	sub l
	add $58 ; SCY value that would be needed to draw the title at top of screen
	ldi (hl),a
	pop af
	add c
	dec b
	jr nz,--

	; Calculate SCY values for the bottom half of the title
	pop bc
	ld a,$37
	add b
	ld l,a
	ld a,$2f
--
	push af
	sub l
	add $58 ; SCY value that would be needed to draw the title at top of screen
	ldd (hl),a
	pop af
	sub c
	dec b
	jr nz,--
	ret

;;
; State 2: game title coming into view
introCinematic_preTitlescreen_state2:
	; Check whether to play the sound effect
	ld hl,wTmpcbb6
	ld a,(hl)
	or a
	jr z,+
	dec a
	ld (hl),a
	ld a,SND_SWORD_OBTAINED
	call z,playSound
+
	; Only update every other frame?
	ld a,(wIntro.frameCounter)
	and $01
	ld hl,wTmpcbb4
	ret nz

	ld a,(hl)
	cp $08
	jr nc,@titleDone
	inc a
	ld (hl),a
	ld hl,introCinematic_preTitlescreen_titleSizeData
	rst_addAToHl
	ld a,(hl)
	jp introCinematic_preTitlescreen_updateScrollForTitle

@titleDone:
	xor a
	ld (wTmpcbb6),a
	dec a
	ld (wTmpcbba),a
	jp intro_incState

;;
; State 3: title fully in view; wait a bit, then go to the titlescreen.
introCinematic_preTitlescreen_state3:
	ld hl,wTmpcbb6
	ld b,$01
	call flashScreen_body
	ret z
	jp intro_gotoTitlescreen

; Each byte is the number of pixels of the title to show on a particular frame, divided by
; two.
introCinematic_preTitlescreen_titleSizeData:
	.db $01 $02 $03 $04 $06 $08 $0c $18

;;
; Updates camera position based on link's Y position.
introCinematic_inTemple_updateCamera:
	ld a,(wGfxRegs1.SCY)
	ld b,a
	ld de,w1Link.yh
	ld a,(de)
	sub b
	sub $40
	ld b,a
	ld a,(wGfxRegs1.SCY)
	add b
	cp $70
	ret nc
	ld (wGfxRegs1.SCY),a
	ldh (<hCameraY),a
	ret

;;
; Moves the black bars in the intro cinematic in by 2 pixels, until it covers 24 pixels on
; each end.
introCinematic_moveBlackBarsIn:
	ld hl,wGfxRegs1.LYC
	inc (hl)
	inc (hl)
	ld a,(hl)
	cp $17
	jr c,+
	ld (hl),$17
+
	ld hl,wGfxRegs2.WINY
	dec (hl)
	dec (hl)
	ld a,(hl)
	cp $90-$18
	ret nc
	ld (hl),$90-$18
	ret


.ifdef ROM_AGES

;;
; Moves the black bars out until a certain area in the center of the screen is visible.
; Used for the closeup of Link's face.
introCinematic_moveBlackBarsOut:
	ld hl,wGfxRegs1.LYC
	dec (hl)
	dec (hl)
	ld a,(hl)
	cp $2f
	jr nc,+
	ld (hl),$2f
+
	ld hl,wGfxRegs2.WINY
	inc (hl)
	inc (hl)
	ld a,(hl)
	cp $90-$30
	ret c
	ld (hl),$90-$30
	ret

.else; ROM_SEASONS

;;
seasonsFunc_03_5367:
	call @func
	ld bc,$0506
	jr nz,+
	ld bc,$0000
+
	ld hl,wTmpcbbb
	ldi a,(hl)
	add b
	ld (wGfxRegs2.SCY),a
	ld a,(hl)
	add c
	ld (wGfxRegs2.SCX),a
	ret

;;
; @param[out]	zflag
@func:
	ld a,($cbb6)
	dec a
	jr nz,++
	ld a,($cbba)
	xor $01
	ld ($cbba),a
	ld a,$05
	jr z,++
	ld a,$22
++
	ld ($cbb6),a
	ld a,($cbba)
	or a
	ret

.endif ; ROM_SEASONS


;;
cutscene_clearObjects:
	call clearDynamicInteractions
	call clearLinkObject
	jp refreshObjectGfx


.ifdef ROM_AGES

;;
; @param	bc	ID of interaction to create
createInteraction:
	call getFreeInteractionSlot
	ret nz
	ld (hl),b
	inc l
	ld (hl),c
	ret

.ifdef REGION_JP

; TODO: Properly update the label to be here instead of elsewhere
;data_5951:
	.db $3c $b4 $3c $50 $78 $b4 $3c $3c
	.db $3c $70 $78 $78
.endif


.else ; ROM_SEASONS


; In Ages these sprites are located elsewhere

; Sprites used on the closeup shot of Link on the horse in the intro
linkOnHorseCloseupSprites_2:
	.db $26
	.db $80 $80 $40 $06
	.db $80 $50 $42 $00
	.db $80 $58 $44 $00
	.db $68 $40 $46 $06
	.db $b8 $3d $20 $02
	.db $b8 $45 $22 $02
	.db $b8 $4d $24 $02
	.db $b8 $55 $26 $02
	.db $b8 $5d $28 $02
	.db $90 $28 $2c $02
	.db $90 $30 $2e $02
	.db $80 $30 $2a $02
	.db $20 $78 $48 $05
	.db $58 $68 $00 $02
	.db $58 $70 $02 $02
	.db $68 $68 $04 $02
	.db $48 $70 $06 $02
	.db $5a $40 $08 $01
	.db $5a $48 $0a $01
	.db $5a $50 $0c $01
	.db $38 $88 $0e $04
	.db $30 $78 $10 $04
	.db $30 $80 $12 $04
	.db $40 $80 $14 $04
	.db $50 $76 $16 $04
	.db $50 $7e $18 $04
	.db $41 $62 $1a $03
	.db $80 $28 $1c $02
	.db $a8 $59 $1e $02
	.db $98 $20 $30 $02
	.db $98 $28 $32 $02
	.db $8c $38 $34 $07
	.db $a8 $41 $36 $02
	.db $a8 $49 $38 $02
	.db $a8 $51 $3a $02
	.db $90 $40 $3e $07
	.db $8a $5c $4a $00
	.db $8a $64 $4c $00

linkOnHorseCloseupSprites_1:
	.db $15
	.db $28 $78 $9c $08
	.db $20 $58 $80 $08
	.db $20 $60 $82 $08
	.db $20 $68 $84 $0a
	.db $20 $70 $d0 $09
	.db $20 $70 $86 $0d
	.db $20 $78 $88 $09
	.db $20 $80 $8a $09
	.db $30 $58 $90 $0c
	.db $30 $80 $9e $09
	.db $4e $60 $94 $0c
	.db $58 $68 $96 $0c
	.db $68 $78 $98 $09
	.db $60 $80 $9a $0a
	.db $20 $88 $8c $09
	.db $20 $90 $8e $09
	.db $40 $72 $92 $0e
	.db $42 $62 $a0 $0e
	.db $70 $30 $b4 $0f
	.db $70 $38 $b6 $0f
	.db $78 $68 $b8 $0c

; Sprites used to touch up the appearance of the temple in the intro (the scene where
; Link's on a cliff with his horse)
introTempleSprites:
	.db $05
	.db $30 $28 $48 $02
	.db $30 $30 $4a $02
	.db $18 $38 $4c $03
	.db $10 $40 $4e $03
	.db $18 $48 $50 $03

templeIntro_simulatedInput:
	dwb   45  $00
	dwb   16  BTN_UP
	dwb   48  $00
	dwb   32  BTN_UP
	dwb   24  $00
	dwb   32  BTN_UP
	dwb   48  $00
	dwb   34  BTN_UP
	dwb  112  $00
	dwb    5  BTN_UP
	dwb   32  $00
	dwb    5  BTN_UP
	dwb   36  $00
	dwb    5  BTN_UP
	dwb   36  $00
	dwb    5  BTN_UP
	dwb   36  $00
	dwb   12  BTN_UP
	.dw $ffff

data_5951:
	.db $3c $b4 $3c $50 $78 $b4 $3c $3c
	.db $3c $70 $78 $78

.endif; ROM_SEASONS

;;
; Called from endgameCutsceneHandler in bank 0.
;
; @param	e
endgameCutsceneHandler_body:
	ld hl,wCutsceneState
	bit 0,(hl)
	jr nz,+
	inc (hl)
	ld hl,wTmpcbb3
	ld b,$10
	call clearMemory
+
	ld a,e
	rst_jumpTable
	.dw endgameCutsceneHandler_09
	.dw endgameCutsceneHandler_0a
	.dw endgameCutsceneHandler_0f
.ifdef ROM_AGES
	.dw endgameCutsceneHandler_20
.endif

;;
clearFadingPalettes2:
	; Clear w2FadingBgPalettes and w2FadingSprPalettes
	ld a,:w2FadingBgPalettes
	ld ($ff00+R_SVBK),a
	ld hl,w2FadingBgPalettes
	ld b,$80
	call clearMemory

	xor a
	ld ($ff00+R_SVBK),a
	dec a
	ldh (<hSprPaletteSources),a
	ldh (<hDirtySprPalettes),a
	ld a,$fd
	ldh (<hBgPaletteSources),a
	ldh (<hDirtyBgPalettes),a
	ret
