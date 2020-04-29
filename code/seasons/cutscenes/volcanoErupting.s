;;
; CUTSCENE_S_VOLCANO_ERUPTING
_cutsceneHandler_0b:
	ld a,(wCutsceneState)		; $6b89
	rst_jumpTable			; $6b8c
	.dw _cutsceneHandler_0b_stage0
	.dw _cutsceneHandler_0b_stage1
	.dw _cutsceneHandler_0b_stage2
	.dw _cutsceneHandler_0b_stage3
	.dw _cutsceneHandler_0b_stage4
	.dw _cutsceneHandler_0b_stage5

_cutsceneHandler_0b_stage0:
	ld a,(wPaletteThread_mode)		; $6b99
	or a			; $6b9c
	ret nz			; $6b9d
	call disableLcd		; $6b9e
	call clearScreenVariablesAndWramBank1		; $6ba1
	ld a,$03		; $6ba4
	ld (wRoomStateModifier),a		; $6ba6
	ld bc,$0103		; $6ba9
	call seasonsFunc_03_6de4		; $6bac
	ld a,$78		; $6baf
	ld ($cbb4),a		; $6bb1
	ld a,$01		; $6bb4
	ld (wCutsceneState),a		; $6bb6
	xor a			; $6bb9
	ld ($cbb3),a		; $6bba
	ld a,MUS_DISASTER		; $6bbd
	ld (wActiveMusic),a		; $6bbf
	call playSound		; $6bc2
	ld a,SND_OPENING		; $6bc5
	call playSound		; $6bc7
	ld a,$01		; $6bca
	ld (wScrollMode),a		; $6bcc
	call fadeinFromWhite		; $6bcf
	call loadCommonGraphics		; $6bd2
	ld a,$02		; $6bd5
	jp loadGfxRegisterStateIndex		; $6bd7

_cutsceneHandler_0b_stage1:
	call seasonsFunc_03_6df8		; $6bda
	ld a,($cbb3)		; $6bdd
	rst_jumpTable			; $6be0
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3

@state0:
	ld a,(wPaletteThread_mode)		; $6be9
	or a			; $6bec
	ret nz			; $6bed
	call seasonsFunc_03_6ddf		; $6bee
	ret nz			; $6bf1
	ld a,$b0		; $6bf2
	call playSound		; $6bf4
	ld hl,$cbb4		; $6bf7
	ld (hl),$96		; $6bfa
	inc hl			; $6bfc
	ld (hl),$01		; $6bfd
	ld hl,$cbb3		; $6bff
	inc (hl)		; $6c02

@state1:
	ld bc,$1478		; $6c03
	ld hl,$cbb5		; $6c06
	call seasonsFunc_03_6db1		; $6c09
	call seasonsFunc_03_6ddf		; $6c0c
	ret nz			; $6c0f
	ld a,$81		; $6c10
	ld (wScreenTransitionDirection),a		; $6c12
	ld hl,$cbb3		; $6c15
	inc (hl)		; $6c18

@state2:
	ld a,(wScrollMode)		; $6c19
	and $04			; $6c1c
	ret z			; $6c1e
	ld a,$04		; $6c1f
	ld (wActiveRoom),a		; $6c21
	callab bank1.setObjectsEnabledTo2	; $6c24
	call loadScreenMusicAndSetRoomPack		; $6c2c
	call loadTilesetData		; $6c2f
	call loadTilesetAndRoomLayout		; $6c32
	call generateVramTilesWithRoomChanges		; $6c35
	ld a,$08		; $6c38
	ld (wScrollMode),a		; $6c3a
	ld hl,$cbb3		; $6c3d
	inc (hl)		; $6c40

@state3:
	ld a,(wScrollMode)		; $6c41
	and $01			; $6c44
	ret z			; $6c46
	callab bank1.clearObjectsWithEnabled2		; $6c47
	ld hl,$cbb4		; $6c4f
	ld (hl),$96		; $6c52
	inc hl			; $6c54
	ld (hl),$01		; $6c55
	inc hl			; $6c57
	ld (hl),$01		; $6c58
	ld a,SND_OPENING		; $6c5a
	call playSound		; $6c5c

seasonsFunc_03_6c5f:
	ld hl,wCutsceneState		; $6c5f
	inc (hl)		; $6c62
	ld hl,$cbb3		; $6c63
	ld (hl),$00		; $6c66
	ret			; $6c68

_cutsceneHandler_0b_stage2:
	call seasonsFunc_03_6df8		; $6c69
	ld bc,$1430		; $6c6c
	ld hl,$cbb5		; $6c6f
	call seasonsFunc_03_6db1		; $6c72
	ld bc,$1488		; $6c75
	ld hl,$cbb6		; $6c78
	call seasonsFunc_03_6db1		; $6c7b
	ld hl,$cbb4		; $6c7e
	dec (hl)		; $6c81
	ret nz			; $6c82
	call seasonsFunc_03_6c5f		; $6c83
	jp fastFadeoutToWhite		; $6c86

_cutsceneHandler_0b_stage3:
	ld a,($cbb3)		; $6c89
	rst_jumpTable			; $6c8c
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3
	.dw @state4

@state0:
	ld a,(wPaletteThread_mode)		; $6c97
	or a			; $6c9a
	ret nz			; $6c9b
	call setScreenShakeCounter		; $6c9c
	call disableLcd		; $6c9f
	call clearScreenVariablesAndWramBank1		; $6ca2
	ld bc,$0015		; $6ca5
	call seasonsFunc_03_6de4		; $6ca8
	ld a,$1e		; $6cab
	ld ($cbb4),a		; $6cad
	ld hl,$cbb3		; $6cb0
	inc (hl)		; $6cb3
	jp seasonsFunc_03_6d9f		; $6cb4

@state1:
	call seasonsFunc_03_6ddf		; $6cb7
	ret nz			; $6cba
	call seasonsFunc_03_6df8		; $6cbb
	ld hl,$cbb4		; $6cbe
	ld (hl),$78		; $6cc1
	inc hl			; $6cc3
	ld (hl),$01		; $6cc4
	ld hl,$cbb3		; $6cc6
	inc (hl)		; $6cc9

@state2:
	ld hl,$cbb5		; $6cca
	call seasonsFunc_03_6dcb		; $6ccd
	call seasonsFunc_03_6ddf		; $6cd0
	ret nz			; $6cd3
	call seasonsFunc_03_6df8		; $6cd4
	ld hl,$cbb3		; $6cd7
	inc (hl)		; $6cda
	ld a,$02		; $6cdb
	call fadeoutToWhiteWithDelay		; $6cdd

@state3:
	ld a,(wPaletteThread_mode)		; $6ce0
	or a			; $6ce3
	ret nz			; $6ce4
	call seasonsFunc_03_6d8b		; $6ce5
	call getFreeInteractionSlot		; $6ce8
	jr nz,+			; $6ceb
	ld (hl),$dc		; $6ced
	inc l			; $6cef
	ld (hl),$0e		; $6cf0
+
	ld hl,$cbb3		; $6cf2
	inc (hl)		; $6cf5
	ld hl,$cbb4		; $6cf6
	ld (hl),$78		; $6cf9
	call seasonsFunc_03_6df8		; $6cfb

@state4:
	ld hl,$cbb5		; $6cfe
	call seasonsFunc_03_6dcb		; $6d01
	call seasonsFunc_03_6ddf		; $6d04
	ret nz			; $6d07
	call seasonsFunc_03_6c5f		; $6d08
	ld a,$02		; $6d0b
	jp fadeoutToWhiteWithDelay		; $6d0d

_cutsceneHandler_0b_stage4:
	ld a,($cbb3)		; $6d10
	rst_jumpTable			; $6d13
	.dw @state0
	.dw _cutsceneHandler_0b_stage3@state1
	.dw _cutsceneHandler_0b_stage3@state2
	.dw _cutsceneHandler_0b_stage3@state3
	.dw _cutsceneHandler_0b_stage3@state4

@state0:
	ld a,(wPaletteThread_mode)		; $6d1e
	or a			; $6d21
	ret nz			; $6d22
	call setScreenShakeCounter		; $6d23
	call disableLcd		; $6d26
	call clearScreenVariablesAndWramBank1		; $6d29
	ld a,GLOBALFLAG_S_15		; $6d2c
	call unsetGlobalFlag		; $6d2e
	ld bc,$0027		; $6d31
	call seasonsFunc_03_6de4		; $6d34
	ld a,$1e		; $6d37
	ld ($cbb4),a		; $6d39
	ld hl,$cbb3		; $6d3c
	inc (hl)		; $6d3f
	jp seasonsFunc_03_6d9f		; $6d40

_cutsceneHandler_0b_stage5:
	ld a,($cbb3)		; $6d43
	rst_jumpTable			; $6d46
	.dw @state0
	.dw _cutsceneHandler_0b_stage3@state1
	.dw _cutsceneHandler_0b_stage3@state2
	.dw _cutsceneHandler_0b_stage3@state3
	.dw @state4

@state0:
	ld a,(wPaletteThread_mode)		; $6d51
	or a			; $6d54
	ret nz			; $6d55
	call setScreenShakeCounter		; $6d56
	call disableLcd		; $6d59
	call clearScreenVariablesAndWramBank1		; $6d5c
	ld a,GLOBALFLAG_S_15		; $6d5f
	call unsetGlobalFlag		; $6d61
	ld bc,$0017		; $6d64
	call seasonsFunc_03_6de4		; $6d67
	ld a,$1e		; $6d6a
	ld ($cbb4),a		; $6d6c
	ld hl,$cbb3		; $6d6f
	inc (hl)		; $6d72
	jp seasonsFunc_03_6d9f		; $6d73

@state4:
	ld hl,$cbb5		; $6d76
	call seasonsFunc_03_6dcb		; $6d79
	call seasonsFunc_03_6ddf		; $6d7c
	ret nz			; $6d7f
	ld hl,@warpDestVariables		; $6d80
	jp setWarpDestVariables		; $6d83
@warpDestVariables:
	m_HardcodedWarpA ROOM_SEASONS_4ef $00 $69 $03

seasonsFunc_03_6d8b:
	call disableLcd		; $6d8b
	call clearScreenVariablesAndWramBank1		; $6d8e
	ld a,GLOBALFLAG_S_15		; $6d91
	call setGlobalFlag		; $6d93
	call loadTilesetData		; $6d96
	call loadTilesetGraphics		; $6d99
	call func_131f		; $6d9c

seasonsFunc_03_6d9f:
	ld a,$01		; $6d9f
	ld (wScrollMode),a		; $6da1
	ld a,$02		; $6da4
	call fadeinFromWhiteWithDelay		; $6da6
	call loadCommonGraphics		; $6da9
	ld a,$02		; $6dac
	jp loadGfxRegisterStateIndex		; $6dae

seasonsFunc_03_6db1:
	dec (hl)		; $6db1
	ret nz			; $6db2
	call getRandomNumber		; $6db3
	and $0f			; $6db6
	add $08			; $6db8
	ld (hl),a		; $6dba
	call getFreePartSlot		; $6dbb
	ret nz			; $6dbe
	ld (hl),$11		; $6dbf
	inc l			; $6dc1
	ld (hl),$01		; $6dc2
	ld l,$cb		; $6dc4
	ld (hl),b		; $6dc6
	ld l,$cd		; $6dc7
	ld (hl),c		; $6dc9
	ret			; $6dca

seasonsFunc_03_6dcb:
	dec (hl)		; $6dcb
	ret nz			; $6dcc
	call getRandomNumber		; $6dcd
	and $0f			; $6dd0
	add $08			; $6dd2
	ld (hl),a		; $6dd4
	call getFreePartSlot		; $6dd5
	ret nz			; $6dd8
	ld (hl),$11		; $6dd9
	inc l			; $6ddb
	ld (hl),$02		; $6ddc
	ret			; $6dde

seasonsFunc_03_6ddf:
	ld hl,$cbb4		; $6ddf
	dec (hl)		; $6de2
	ret			; $6de3

seasonsFunc_03_6de4:
	ld a,b			; $6de4
	ld (wActiveGroup),a		; $6de5
	ld a,c			; $6de8
	ld (wActiveRoom),a		; $6de9
	call loadScreenMusicAndSetRoomPack		; $6dec
	call loadTilesetData		; $6def
	call loadTilesetGraphics		; $6df2
	jp func_131f		; $6df5

seasonsFunc_03_6df8:
	ld a,$ff		; $6df8
	jp setScreenShakeCounter		; $6dfa
