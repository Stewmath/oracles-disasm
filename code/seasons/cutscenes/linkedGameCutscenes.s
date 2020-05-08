;;
; CUTSCENE_S_FLAME_OF_DESTRUCTION
; @addr{6dfd}
flameOfDestructionCutsceneBody:
	ld a,(wCutsceneState)		; $6dfd
	rst_jumpTable			; $6e00
	.dw bank3Cutscene_state0
	.dw flameOfDestructionCutscene_state1

;;
; CUTSCENE_S_ZELDA_VILLAGERS
; @addr{6e05}
zeldaAndVillagersCutsceneBody:
	ld a,(wCutsceneState)		; $6e05
	rst_jumpTable			; $6e08
	.dw bank3Cutscene_state0
	.dw zeldaAndVillagersCutscene_state1

;;
; CUTSCENE_S_ZELDA_KIDNAPPED
; @addr{6e0d}
zeldaKidnappedCutsceneBody:
	ld a,(wCutsceneState)		; $6e0d
	rst_jumpTable			; $6e10
	.dw bank3Cutscene_state0
	.dw zeldaKidnappedCutscene_state1

bank3Cutscene_state0:
	ld b,$10		; $6e15
	ld hl,wGenericCutscene.cbb3		; $6e17
	call clearMemory		; $6e1a
	call clearWramBank1		; $6e1d
	xor a			; $6e20
	ld (wDisabledObjects),a		; $6e21
	ld a,$80		; $6e24
	ld (wMenuDisabled),a		; $6e26
	ld a,$01		; $6e29
	ld (wCutsceneState),a		; $6e2b
	ret			; $6e2e

flameOfDestructionCutscene_state1:
	ld a,(wGenericCutscene.cbb3)		; $6e2f
	rst_jumpTable			; $6e32
	.dw @fadeToBlack
	.dw @roomOfRitesStart
	.dw @flashScreen
	.dw @changePalettes
	.dw @startCutsceneText08
	.dw @startFadeInAndLightTorch
	.dw @createSomeObjects
	.dw @startCutsceneText09
	.dw @startCutsceneText0a
	.dw @startCutsceneText0b
	.dw @startCutsceneText0c
	.dw @finish

@fadeToBlack:
	ld a,$28		; $6e4b
	ld (wGenericCutscene.cbb5),a		; $6e4d
	call fastFadeoutToBlack		; $6e50
	jp _incTmpcbb3		; $6e53

@roomOfRitesStart:
	call _waitUntilFadeIsDone		; $6e56
	ret nz			; $6e59
	call bank3CutsceneLoadRoomOfRites		; $6e5a
	call getFreeInteractionSlot		; $6e5d
	jr nz,+	; $6e60
	ld (hl),INTERACID_TWINROVA_FLAME		; $6e62
	inc l			; $6e64
	ld (hl),$03		; $6e65
+
	ld a,$13		; $6e67
	call loadGfxRegisterStateIndex		; $6e69
	ld a,SND_LIGHTNING		; $6e6c
	call playSound		; $6e6e
	xor a			; $6e71
	ld (wGenericCutscene.cbb5),a		; $6e72
	ld (wGenericCutscene.cbb6),a		; $6e75
	dec a			; $6e78
	ld (wGenericCutscene.cbba),a		; $6e79
	call _incTmpcbb3		; $6e7c

@flashScreen:
	ld hl,wGenericCutscene.cbb5		; $6e7f
	ld b,$04		; $6e82
	call flashScreen		; $6e84
	ret z			; $6e87
	call clearPaletteFadeVariablesAndRefreshPalettes		; $6e88
	jp _incTmpcbb3		; $6e8b

@changePalettes:
	call getFreeInteractionSlot		; $6e8e
	jr nz,+	; $6e91
	ld (hl),INTERACID_TWINROVA_FLAME		; $6e93
	inc l			; $6e95
	ld (hl),$04		; $6e96
+
	ld a,SNDCTRL_STOPMUSIC		; $6e98
	call playSound		; $6e9a
	ld a,$04		; $6e9d
	ld (wGenericCutscene.cbb5),a		; $6e9f
	call _clearFadingPalettes		; $6ea2
	ld a,$ef		; $6ea5
	ldh (<hSprPaletteSources),a	; $6ea7
	ldh (<hDirtySprPalettes),a	; $6ea9
	jp _incTmpcbb3		; $6eab

@startCutsceneText08:
	ld hl,wGenericCutscene.cbb5		; $6eae
	dec (hl)		; $6eb1
	ret nz			; $6eb2
	ld a,$04		; $6eb3
	ld (wTextboxFlags),a		; $6eb5
	ld c,<TX_5008		; $6eb8
	jp showCutscene50xxText		; $6eba

@fadeInAndLightTorch:
	call fastFadeinFromBlack		; $6ebd
	ld a,b			; $6ec0
	ld (wDirtyFadeSprPalettes),a		; $6ec1
	ld (wFadeSprPaletteSources),a		; $6ec4
	xor a			; $6ec7
	ld (wDirtyFadeBgPalettes),a		; $6ec8
	ld (wFadeBgPaletteSources),a		; $6ecb
	ld a,SND_LIGHTTORCH		; $6ece
	jp playSound		; $6ed0

@startFadeInAndLightTorch:
	call _waitUntilTextInactive		; $6ed3
	ret nz			; $6ed6
	ld b,$40		; $6ed7
	call @fadeInAndLightTorch		; $6ed9
	ld a,$1e		; $6edc
	ld (wGenericCutscene.cbb5),a		; $6ede
	jp _incTmpcbb3		; $6ee1

@createSomeObjects:
	call _waitUntilFadeIsDone		; $6ee4
	ret nz			; $6ee7
	call fadeinFromBlack		; $6ee8
	ld a,$af		; $6eeb
	ld (wDirtyFadeSprPalettes),a		; $6eed
	ld (wFadeSprPaletteSources),a		; $6ef0
	xor a			; $6ef3
	ld ($cfc6),a		; $6ef4
	call cutscene_func_03_72af		; $6ef7
	call loadInteracIdb4_subid6And7		; $6efa
	ld a,MUS_DISASTER		; $6efd
	ld (wActiveMusic),a		; $6eff
	call playSound		; $6f02
	ld a,$1e		; $6f05
	ld (wGenericCutscene.cbb5),a		; $6f07
	jp _incTmpcbb3		; $6f0a

@startCutsceneText09:
	call _waitUntilFadeIsDone		; $6f0d
	ret nz			; $6f10
	ld c,<TX_5009		; $6f11
	jp showCutscene50xxText		; $6f13

@startCutsceneText0a:
	call _waitUntilTextInactive		; $6f16
	ret nz			; $6f19
	ld c,<TX_500a		; $6f1a
	jp showCutscene50xxText		; $6f1c

@startCutsceneText0b:
	call _waitUntilTextInactive		; $6f1f
	ret nz			; $6f22
	ld c,<TX_500b		; $6f23
	jp showCutscene50xxText		; $6f25

@startCutsceneText0c:
	call _waitUntilTextInactive		; $6f28
	ret nz			; $6f2b
	ld c,<TX_500c		; $6f2c
	call showCutscene50xxText		; $6f2e
	ld a,$3c		; $6f31
	ld (wGenericCutscene.cbb5),a		; $6f33
	ret			; $6f36

@finish:
	call _waitUntilTextInactive		; $6f37
	ret nz			; $6f3a
	xor a			; $6f3b
	ld (wMenuDisabled),a		; $6f3c
	ld a,GLOBALFLAG_FLAMES_OF_DESTRUCTION_SEEN		; $6f3f
	call setGlobalFlag		; $6f41
	ld a,$03		; $6f44
	ld (wRoomStateModifier),a		; $6f46
	ld hl,@warpDest		; $6f49
	call setWarpDestVariables		; $6f4c
	ld a,PALH_0f		; $6f4f
	jp loadPaletteHeader		; $6f51

@warpDest:
	; d5 overworld entrance
	m_HardcodedWarpA ROOM_SEASONS_08a, $00, $25, $83


zeldaAndVillagersCutscene_state1:
	ld a,(wGenericCutscene.cbb3)		; $6f59
	rst_jumpTable			; $6f5c
	.dw @start
	.dw @loadImpaRoomAndMusic
	.dw @waitUntilFadeInDone
	.dw @waitToFadeOut
	.dw @loadSokraRoomAndMusic
	.dw @waitUntilFadeInDone2
	.dw @finish

@start:
	call fadeoutToWhite		; $6f6b
	jp _incTmpcbb3		; $6f6e

@loadImpaRoomAndMusic:
	ld a,(wPaletteThread_mode)		; $6f71
	or a			; $6f74
	ret nz			; $6f75
	ld a,$03		; $6f76
	; outside impa's house
	ld bc,ROOM_SEASONS_0b6		; $6f78
	call disableLcdAndLoadRoom_body		; $6f7b
	ld a,SNDCTRL_STOPSFX		; $6f7e
	call playSound		; $6f80
	ld a,MUS_TRIUMPHANT		; $6f83
	ld (wActiveMusic),a		; $6f85
	call playSound		; $6f88
	ld a,$02		; $6f8b
	call loadGfxRegisterStateIndex		; $6f8d
	xor a			; $6f90
	call loadGroupOfInteractions		; $6f91
	call fadeinFromWhite		; $6f94
	jp _incTmpcbb3		; $6f97

@waitUntilFadeInDone:
	ld a,(wPaletteThread_mode)		; $6f9a
	or a			; $6f9d
	ret nz			; $6f9e
	jp _incTmpcbb3		; $6f9f

@waitToFadeOut:
	ld a,($cfc0)		; $6fa2
	bit 1,a			; $6fa5
	ret z			; $6fa7
	call fadeoutToWhite		; $6fa8
	jp _incTmpcbb3		; $6fab

@loadSokraRoomAndMusic:
	ld a,(wPaletteThread_mode)		; $6fae
	or a			; $6fb1
	ret nz			; $6fb2
	; horon village Sokra screen
	ld bc,ROOM_SEASONS_0e9		; $6fb3
	call disableLcdAndLoadRoom_body		; $6fb6
	ld a,SNDCTRL_STOPSFX		; $6fb9
	call playSound		; $6fbb
	ld a,$02		; $6fbe
	call loadGfxRegisterStateIndex		; $6fc0
	call clearWramBank1		; $6fc3
	ld a,$01		; $6fc6
	call loadGroupOfInteractions		; $6fc8
	call fadeinFromWhite		; $6fcb
	jp _incTmpcbb3		; $6fce

@waitUntilFadeInDone2:
	ld a,(wPaletteThread_mode)		; $6fd1
	or a			; $6fd4
	ret nz			; $6fd5
	ld c,<TX_5010		; $6fd6
	jp showCutscene50xxText		; $6fd8

@finish:
	call _waitUntilTextInactive		; $6fdb
	ret nz			; $6fde
	xor a			; $6fdf
	ld (wMenuDisabled),a		; $6fe0
	ld a,GLOBALFLAG_ZELDA_VILLAGERS_SEEN		; $6fe3
	call setGlobalFlag		; $6fe5
	ld hl,@warpDest		; $6fe8
	jp setWarpDestVariables		; $6feb

@warpDest:
	; first room of d8
	m_HardcodedWarpA ROOM_SEASONS_587, $93 $ff $01


zeldaKidnappedCutscene_state1:
	call zeldaKidnappedCutscene_state1Handler ; $6ff3
	ld hl,wGenericCutscene.cbb3		; $6ff6
	ld a,(hl)		; $6ff9
	cp $10			; $6ffa
	jp c,updateStatusBar		; $6ffc
	ret			; $6fff

zeldaKidnappedCutscene_state1Handler:
	ld a,(wGenericCutscene.cbb3)		; $7000
	rst_jumpTable			; $7003
	.dw @startByFadingOut
	.dw @loadSokraRoomAndInteractions
	.dw @waitUntilRoomLoaded
	.dw @startCutsceneText11
	.dw @func4
	.dw @func5
	.dw @startCutsceneText12
	.dw @startCutsceneText13
	.dw @startCutsceneText14
	.dw @func9
	.dw @funca
	.dw @funcb
	.dw @startCutsceneText16
	.dw @startCutsceneText17
	.dw @funce
	.dw @funcf

	; stop calling updateStatusBar above
	.dw @loadRoomOfRitesAndInteractions
	.dw @startCutsceneText18
	.dw @startCutsceneText19
	.dw @startCutsceneText1a
	.dw @finish

@startByFadingOut:
	call fadeoutToWhite		; $702e
	jp _incTmpcbb3		; $7031

@loadSokraRoomAndInteractions:
	ld a,(wPaletteThread_mode)		; $7034
	or a			; $7037
	ret nz			; $7038
	; horon village Sokra screen
	ld bc,ROOM_SEASONS_0e9		; $7039
	call disableLcdAndLoadRoom_body		; $703c
	ld a,$02		; $703f
	call loadGfxRegisterStateIndex		; $7041
	call restartSound		; $7044
	ld a,$02		; $7047
	call loadGroupOfInteractions		; $7049
	call fadeinFromWhite		; $704c
	ld a,$3c		; $704f
	ld (wGenericCutscene.cbb5),a		; $7051
	jp _incTmpcbb3		; $7054

@waitUntilRoomLoaded:
	call _waitUntilFadeIsDone		; $7057
	ret nz			; $705a
	ld hl,$cfc0		; $705b
	set 7,(hl)		; $705e
	ld a,$ff		; $7060
	ld (wGenericCutscene.cbb5),a		; $7062
	jp _incTmpcbb3		; $7065

@startCutsceneText11:
	ld hl,wGenericCutscene.cbb5		; $7068
	dec (hl)		; $706b
	ret nz			; $706c
	ld c,<TX_5011		; $706d
	call showCutscene50xxText		; $706f
	ld a,$5a		; $7072
	ld (wGenericCutscene.cbb5),a		; $7074
	ret			; $7077

@func4:
	call _waitUntilTextInactive		; $7078
	jr z,+	; $707b
	ld a,$3c		; $707d
	cp (hl)			; $707f
	ret nz			; $7080
	ld hl,$cfc0		; $7081
	set 6,(hl)		; $7084
	ret			; $7086
+
	ld hl,$cfc0		; $7087
	set 5,(hl)		; $708a
	ld a,$3c		; $708c
	ld (wGenericCutscene.cbb5),a		; $708e
	jp _incTmpcbb3		; $7091

@func5:
	ld hl,wGenericCutscene.cbb5		; $7094
	dec (hl)		; $7097
	ret nz			; $7098
	ld a,$1e		; $7099
	ld (wGenericCutscene.cbb5),a		; $709b
	xor a			; $709e
	ld ($cfc6),a		; $709f
	call cutscene_func_03_72af		; $70a2
	call loadInteracIdb4_subid2And3		; $70a5
	ld a,$21		; $70a8
	ld (wActiveMusic),a		; $70aa
	call playSound		; $70ad
	jp _incTmpcbb3		; $70b0

@startCutsceneText12:
	ld a,($cfc0)		; $70b3
	bit 0,a			; $70b6
	ret z			; $70b8
	ld hl,wGenericCutscene.cbb5		; $70b9
	dec (hl)		; $70bc
	ret nz			; $70bd
	ld c,<TX_5012		; $70be
	jp showCutscene50xxText		; $70c0

@startCutsceneText13:
	call _waitUntilTextInactive		; $70c3
	ret nz			; $70c6
	ld c,<TX_5013		; $70c7
	jp showCutscene50xxText		; $70c9

@startCutsceneText14:
	call _waitUntilTextInactive		; $70cc
	ret nz			; $70cf
	ld c,<TX_5014		; $70d0
	jp showCutscene50xxText		; $70d2

@func9:
	call _waitUntilTextInactive		; $70d5
	ret nz			; $70d8
	ld hl,$cfc0		; $70d9
	res 0,(hl)		; $70dc
	jp _incTmpcbb3		; $70de

@funca:
	ld a,($cfc0)		; $70e1
	bit 0,a			; $70e4
	ret z			; $70e6
	xor a			; $70e7
	ld (wGenericCutscene.cbb4),a		; $70e8
	ld a,SND_LIGHTNING		; $70eb
	call playSound		; $70ed
	call _incTmpcbb3		; $70f0

@funcb:
	call zeldaKidnappedFlashFadeoutToWhite		; $70f3
	ret nz			; $70f6
	call clearWramBank1		; $70f7
	ld hl,$cfc0		; $70fa
	res 0,(hl)		; $70fd
	xor a			; $70ff
	ld ($cfc6),a		; $7100
	call loadInteracIdb4_subid4And5		; $7103
	ld a,$04		; $7106
	call fadeinFromWhiteWithDelay		; $7108
	ld a,$1e		; $710b
	ld (wGenericCutscene.cbb5),a		; $710d
	jp _incTmpcbb3		; $7110

@startCutsceneText16:
	call _waitUntilFadeIsDone		; $7113
	ret nz			; $7116
	ld c,<TX_5016		; $7117
	jp showCutscene50xxText		; $7119

@startCutsceneText17:
	call _waitUntilTextInactive		; $711c
	ret nz			; $711f
	ld c,<TX_5017		; $7120
	jp showCutscene50xxText		; $7122

@funce:
	call _waitUntilTextInactive		; $7125
	ret nz			; $7128
	ld hl,$cfc0		; $7129
	set 0,(hl)		; $712c
	ld a,$3c		; $712e
	ld (wGenericCutscene.cbb5),a		; $7130
	ld a,$bb		; $7133
	call playSound		; $7135
	jp _incTmpcbb3		; $7138

@funcf:
	ld hl,wGenericCutscene.cbb5		; $713b
	dec (hl)		; $713e
	ret nz			; $713f
	call fadeoutToWhite		; $7140
	jp _incTmpcbb3		; $7143

@loadRoomOfRitesAndInteractions:
	ld a,(wPaletteThread_mode)		; $7146
	or a			; $7149
	ret nz			; $714a
	call bank3CutsceneLoadRoomOfRites		; $714b
	call loadInteracIdb0		; $714e
	ld a,$f1		; $7151
	call playSound		; $7153
	xor a			; $7156
	ld ($cfc6),a		; $7157
	call loadInteracIdb4_subid6And7		; $715a
	call getFreeInteractionSlot		; $715d
	jr nz,+	; $7160
	ld (hl),INTERACID_TWINROVA_FLAME		; $7162
+
	ld a,$13		; $7164
	call loadGfxRegisterStateIndex		; $7166
	call fadeinFromBlack		; $7169
	ld a,$1e		; $716c
	ld (wGenericCutscene.cbb5),a		; $716e
	jp _incTmpcbb3		; $7171

@startCutsceneText18:
	call _waitUntilFadeIsDone		; $7174
	ret nz			; $7177
	ld c,<TX_5018		; $7178
	jp showCutscene50xxText		; $717a

@startCutsceneText19:
	call _waitUntilTextInactive		; $717d
	ret nz			; $7180
	ld c,<TX_5019		; $7181
	jp showCutscene50xxText		; $7183

@startCutsceneText1a:
	call _waitUntilTextInactive		; $7186
	ret nz			; $7189
	ld c,<TX_501a		; $718a
	jp showCutscene50xxText		; $718c

@finish:
	call _waitUntilTextInactive		; $718f
	ret nz			; $7192
	xor a			; $7193
	ld (wMenuDisabled),a		; $7194
	ld a,GLOBALFLAG_ZELDA_KIDNAPPED_SEEN		; $7197
	call setGlobalFlag		; $7199
	ld a,$03		; $719c
	ld (wRoomStateModifier),a		; $719e
	ld hl,@warpDest		; $71a1
	jp setWarpDestVariables		; $71a4

@warpDest:
    ; 1st screen on path to Onox?
	.db $c0 $23 $00 $45 $83


zeldaKidnappedFlashFadeoutToWhite:
	ld a,(wGenericCutscene.cbb4)		; $71ac
	rst_jumpTable			; $71af
	.dw @func0
	.dw @func1
	.dw @func1
	.dw @func3
	.dw @func4
	.dw @func5
@func0:
	ld a,$0a		; $71bc
--
	ld (wGenericCutscene.cbb5),a		; $71be
	call clearFadingPalettes		; $71c1
	jp _incTmpcbb4		; $71c4
@func1:
	ld hl,wGenericCutscene.cbb5		; $71c7
	dec (hl)		; $71ca
	ret nz			; $71cb
	ld a,$0a		; $71cc
-
	ld (wGenericCutscene.cbb5),a		; $71ce
	call fastFadeoutToWhite		; $71d1
	jp _incTmpcbb4		; $71d4
@func3:
	ld a,$14		; $71d7
	jr --		; $71d9
@func4:
	ld hl,wGenericCutscene.cbb5		; $71db
	dec (hl)		; $71de
	ret nz			; $71df
	ld a,$1e		; $71e0
	jr -		; $71e2
@func5:
	jp _waitUntilFadeIsDone		; $71e4

showCutscene50xxText:
	ld b,$50		; $71e7
	call showText		; $71e9
	ld a,$1e		; $71ec
	ld (wGenericCutscene.cbb5),a		; $71ee

_incTmpcbb3:
	ld hl,wGenericCutscene.cbb3		; $71f1
	inc (hl)		; $71f4
	ret			; $71f5

_incTmpcbb4:
	ld hl,wGenericCutscene.cbb4		; $71f6
	inc (hl)		; $71f9
	ret			; $71fa

_waitUntilTextInactive:
	ld a,(wTextIsActive)		; $71fb
	or a			; $71fe
	ret nz			; $71ff
	ld hl,wGenericCutscene.cbb5		; $7200
	dec (hl)		; $7203
	ret			; $7204

_waitUntilFadeIsDone:
	ld a,(wPaletteThread_mode)		; $7205
	or a			; $7208
	ret nz			; $7209
	ld hl,wGenericCutscene.cbb5		; $720a
	dec (hl)		; $720d
	ret			; $720e

bank3CutsceneLoadRoomOfRites:
	xor a			; $720f
	; Room of Rites
	ld bc,ROOM_SEASONS_59a		; $7210
	call disableLcdAndLoadRoom_body		; $7213
	ld a,SEASONS_PALH_ac		; $7216
	call loadPaletteHeader		; $7218
	ld a,$28		; $721b
	ld (wGfxRegs1.SCX),a		; $721d
	ld (wGfxRegs2.SCX),a		; $7220
	ldh (<hCameraX),a	; $7223
	ld a,$00		; $7225
	ld (wScrollMode),a		; $7227
	ld a,$10		; $722a
	ldh (<hOamTail),a	; $722c
	jp clearWramBank1		; $722e

loadInteracIdb0:
	ld b,$02		; $7231
-
	call getFreeInteractionSlot		; $7233
	ret nz			; $7236
	ld (hl),INTERACID_TWINROVA_FLAME		; $7237
	inc l			; $7239
	ld a,$02		; $723a
	add b			; $723c
	dec b			; $723d
	ld (hl),a		; $723e
	jr nz,-	; $723f
	ret			; $7241

loadGroupOfInteractions:
	ld hl,@interacGroupTable		; $7242
	rst_addDoubleIndex			; $7245
	ldi a,(hl)		; $7246
	ld b,(hl)		; $7247
	ld c,a			; $7248
-
	ld a,(bc)		; $7249
	or a			; $724a
	ret z			; $724b
	call getFreeInteractionSlot		; $724c
	ret nz			; $724f

	; load Interaction's id
	ld a,(bc)		; $7250
	ldi (hl),a		; $7251

	; load Interaction's subid
	inc bc			; $7252
	ld a,(bc)		; $7253
	ldi (hl),a		; $7254

	; load Interaction's var03 in
	inc bc			; $7255
	ld a,(bc)		; $7256
	ldi (hl),a		; $7257

	inc bc			; $7258
	ld l,Interaction.yh		; $7259
	ld a,(bc)		; $725b
	ld (hl),a		; $725c

	inc bc			; $725d
	ld l,Interaction.xh		; $725e
	ld a,(bc)		; $7260
	ld (hl),a		; $7261

	inc bc			; $7262
	jr -		; $7263

@interacGroupTable:
	.dw @interacGroup1
	.dw @interacGroup2
	.dw @interacGroup3

	; id - subid - var03 - yh - xh
@interacGroup1:
	.db INTERACID_ZELDA $02 $00 $18 $18
	.db $00
@interacGroup2:
	.db INTERACID_bd $00 $01 $28 $38
	.db INTERACID_be $00 $01 $40 $38
	.db INTERACID_ZELDA $03 $00 $20 $50
	.db INTERACID_bc $00 $00 $48 $50
	.db INTERACID_ba $00 $03 $28 $68
	.db INTERACID_bb $00 $00 $40 $68
	.db $00
@interacGroup3:
	.db INTERACID_bd $00 $01 $2c $38
	.db INTERACID_be $00 $00 $44 $40
	.db INTERACID_ZELDA $03 $00 $20 $50
	.db INTERACID_bc $00 $00 $50 $58
	.db INTERACID_ba $00 $02 $20 $64
	.db INTERACID_bb $00 $03 $38 $68
	.db $00

cutscene_func_03_72af:
	ld a,$01		; $72af
	ld (wLoadedTreeGfxIndex),a		; $72b1
	ld a,$b4		; $72b4
	ld (wInteractionIDToLoadExtraGfx),a		; $72b6
	ret			; $72b9

loadInteracIdb4_subid2And3:
	ld bc,loadInteracIdb4@subid2		; $72ba
	call loadInteracIdb4		; $72bd
	ld bc,loadInteracIdb4@subid3		; $72c0
	jr loadInteracIdb4		; $72c3

loadInteracIdb4_subid4And5:
	ld bc,loadInteracIdb4@subid4		; $72c5
	call loadInteracIdb4		; $72c8
	ld bc,loadInteracIdb4@subid5		; $72cb
	jr loadInteracIdb4		; $72ce

loadInteracIdb4_subid6And7:
	ld bc,loadInteracIdb4@subid6		; $72d0
	call loadInteracIdb4		; $72d3
	ld bc,loadInteracIdb4@subid7		; $72d6

loadInteracIdb4:
	call getFreeInteractionSlot		; $72d9
	ret nz			; $72dc
	ld (hl),INTERACID_b4		; $72dd
	inc l			; $72df
	ld a,(bc)		; $72e0
	inc bc			; $72e1
	ld (hl),a		; $72e2
	ld l,Interaction.yh		; $72e3
	ld a,(bc)		; $72e5
	inc bc			; $72e6
	ld (hl),a		; $72e7
	ld l,Interaction.xh		; $72e8
	ld a,(bc)		; $72ea
	ld (hl),a		; $72eb
	ret			; $72ec

	; subid - yh - xh
	@subid2:
	.db $02 $00 $40
	@subid3:
	.db $03 $00 $60
	@subid4:
	.db $04 $50 $68
	@subid5:
	.db $05 $50 $38
	@subid6:
	.db $06 $4c $8e
	@subid7:
	.db $07 $4c $62