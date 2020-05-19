;;
; Called from "func_3ed0" in bank 0.
; CUTSCENE_FLAME_OF_SORROW
; @addr{7841}
func_03_7841:
	ld a,(wCutsceneState)		; $7841
	rst_jumpTable			; $7844
	.dw _func_03_7851
	.dw _flameOfSorrowState1

;;
; Called from "func_3ee4" in bank 0.
; CUTSCENE_ZELDA_KIDNAPPED
; @addr{7849}
func_03_7849:
	ld a,(wCutsceneState)		; $7849
	rst_jumpTable			; $784c
	.dw _func_03_7851
	.dw _zeldaKidnappedState1

;;
; @addr{7851}
_func_03_7851:
	ld b,$10		; $7851
	ld hl,wTmpcbb3		; $7853
	call clearMemory		; $7856
	call clearWramBank1		; $7859
	xor a			; $785c
	ld (wDisabledObjects),a		; $785d
	ld a,$80		; $7860
	ld (wMenuDisabled),a		; $7862
	ld a,$01		; $7865
	ld (wCutsceneState),a		; $7867
	ret			; $786a

;;
; @addr{786b}
_flameOfSorrowState1:
	ld a,(wTmpcbb3)		; $786b
	rst_jumpTable			; $786e
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
	ld a,$28		; $7887
	ld (wTmpcbb5),a		; $7889
	jp _linkedCutscene_incSubstate		; $788c
@substate1:
	call _func_03_7b95		; $788f
	ret nz			; $7892
	call _func_7bab		; $7893
	call getFreeInteractionSlot		; $7896
	jr nz,+			; $7899
	ld (hl),INTERACID_TWINROVA_FLAME		; $789b
	inc l			; $789d
	ld (hl),$01		; $789e
+
	ld a,$13		; $78a0
	call loadGfxRegisterStateIndex		; $78a2
	ld a,SND_LIGHTNING		; $78a5
	call playSound		; $78a7
	xor a			; $78aa
	ld (wTmpcbb5),a		; $78ab
	ld (wTmpcbb6),a		; $78ae
	dec a			; $78b1
	ld (wTmpcbba),a		; $78b2
	call _linkedCutscene_incSubstate		; $78b5
@substate2:
	ld hl,wTmpcbb5		; $78b8
	ld b,$05		; $78bb
	call flashScreen		; $78bd
	ret z			; $78c0
	call clearPaletteFadeVariablesAndRefreshPalettes		; $78c1
	jp _linkedCutscene_incSubstate		; $78c4
@substate3:
	call getFreeInteractionSlot		; $78c7
	jr nz,+			; $78ca
	ld (hl),INTERACID_TWINROVA_FLAME		; $78cc
+
	ld a,SNDCTRL_STOPMUSIC		; $78ce
	call playSound		; $78d0
	call _clearFadingPalettes		; $78d3
	ld a,$bf		; $78d6
	ldh (<hSprPaletteSources),a	; $78d8
	ldh (<hDirtySprPalettes),a	; $78da
	ld a,$04		; $78dc
	jp _linkedCutscene_aIntoCBB5_incSubstate		; $78de
@substate4:
	call _func_03_7b95		; $78e1
	ret nz			; $78e4

	ld a,TEXTBOXFLAG_ALTPALETTE1		; $78e5
	ld (wTextboxFlags),a		; $78e7
	ld c,<TX_281b		; $78ea
	jp _func_03_7b81		; $78ec
@substate5:
	call _func_7b9a		; $78ef
	ret nz			; $78f2
	ld b,$10		; $78f3
	call @func_78fd		; $78f5
	ld a,$1e		; $78f8
	jp _linkedCutscene_aIntoCBB5_incSubstate		; $78fa
@func_78fd:
	call fastFadeinFromBlack		; $78fd
	ld a,b			; $7900
	ld (wDirtyFadeSprPalettes),a		; $7901
	ld (wFadeSprPaletteSources),a		; $7904
	xor a			; $7907
	ld (wDirtyFadeBgPalettes),a		; $7908
	ld (wFadeBgPaletteSources),a		; $790b
	ld a,SND_LIGHTTORCH		; $790e
	jp playSound		; $7910
@substate6:
	call _func_7ba1		; $7913
	ret nz			; $7916
	call fadeinFromBlack		; $7917
	ld a,$af		; $791a
	ld (wDirtyFadeSprPalettes),a		; $791c
	ld (wFadeSprPaletteSources),a		; $791f
	call _func_7bd0		; $7922
	ld a,MUS_DISASTER		; $7925
	ld (wActiveMusic),a		; $7927
	call playSound		; $792a
	xor a			; $792d
	ld ($cfc6),a		; $792e
	ld a,$1e		; $7931
	jp _linkedCutscene_aIntoCBB5_incSubstate		; $7933
@substate7:
	call _func_7ba1		; $7936
	ret nz			; $7939
	ld c,<TX_2829		; $793a
	jp _func_03_7b81		; $793c
@substate8:
	call _func_7b9a		; $793f
	ret nz			; $7942
	ld c,<TX_281c		; $7943
	jp _func_03_7b81		; $7945
@substate9:
	call _func_7b9a		; $7948
	ret nz			; $794b
	ld c,<TX_281d		; $794c
	jp _func_03_7b81		; $794e
@substateA:
	call _func_7b9a		; $7951
	ret nz			; $7954
	ld c,<TX_281e		; $7955
	call _func_03_7b81		; $7957
	ld a,$3c		; $795a
	ld (wTmpcbb5),a		; $795c
	ret			; $795f
@substateB:
	call _func_7b9a		; $7960
	ret nz			; $7963
	xor a			; $7964
	ld (wMenuDisabled),a		; $7965
	ld hl,@warpDest		; $7968
	call setWarpDestVariables		; $796b
	ld a,$00		; $796e
	ld (wcc50),a		; $7970
	ld a,PALH_0f		; $7973
	jp loadPaletteHeader		; $7975

@warpDest:
	m_HardcodedWarpA ROOM_AGES_4ea, $0c, $87, $83

_zeldaKidnappedState1:
	call @runStates		; $797d
	jp updateStatusBar		; $7980
@runStates:
	ld a,(wTmpcbb3)		; $7983
	rst_jumpTable			; $7986
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
	.dw @substate10
	.dw @substate11
	.dw @substate12
	.dw @substate13
	.dw @substate14
	.dw @substate15
	.dw @substate16
@substate0:
	ld a,(wPaletteThread_mode)		; $79b5
	or a			; $79b8
	ret nz			; $79b9
	ld a,$01		; $79ba
	ld (wLoadedTreeGfxIndex),a		; $79bc
	ld bc, ROOM_AGES_149		; $79bf
	call disableLcdAndLoadRoom		; $79c2
	ld a,$02		; $79c5
	call loadGfxRegisterStateIndex		; $79c7
	call restartSound		; $79ca
	call _func_7c2a		; $79cd
	call fadeinFromWhite		; $79d0
	ld a,$3c		; $79d3
	jp _linkedCutscene_aIntoCBB5_incSubstate		; $79d5
@substate1:
	call _func_7ba1		; $79d8
	ret nz			; $79db
	ld hl,$cfc0		; $79dc
	set 0,(hl)		; $79df
	ld a,$01		; $79e1
	jp _linkedCutscene_aIntoCBB5_incSubstate		; $79e3
@substate2:
	ld hl,$cfc0		; $79e6
	bit 1,(hl)		; $79e9
	ret z			; $79eb
	call _func_03_7b95		; $79ec
	ret nz			; $79ef
	xor a			; $79f0
	call _func_7c68		; $79f1
	ld a,$1e		; $79f4
	jp _linkedCutscene_aIntoCBB5_incSubstate		; $79f6
@substate3:
	call _func_03_7b95		; $79f9
	ret nz			; $79fc
	xor a			; $79fd
	call _func_7c83		; $79fe
	ld hl,$cfc0		; $7a01
	set 2,(hl)		; $7a04
	ld a,$1e		; $7a06
	jp _linkedCutscene_aIntoCBB5_incSubstate		; $7a08
@substate4:
	call _func_03_7b95		; $7a0b
	ret nz			; $7a0e
	ld a,$01		; $7a0f
	call _func_7c68		; $7a11
	ld a,$1e		; $7a14
	jp _linkedCutscene_aIntoCBB5_incSubstate		; $7a16
@substate5:
	call _func_03_7b95		; $7a19
	ret nz			; $7a1c
	ld a,$01		; $7a1d
	call _func_7c83		; $7a1f
	ld hl,$cfc0		; $7a22
	set 3,(hl)		; $7a25
	ld a,$1e		; $7a27
	jp _linkedCutscene_aIntoCBB5_incSubstate		; $7a29
@substate6:
	ld hl,$cfc0		; $7a2c
	bit 4,(hl)		; $7a2f
	ret z			; $7a31
	ld a,$1e		; $7a32
	jp _linkedCutscene_aIntoCBB5_incSubstate		; $7a34
@substate7:
	call _func_03_7b95		; $7a37
	ret nz			; $7a3a
	ld hl,$cfc0		; $7a3b
	set 5,(hl)		; $7a3e
	ld a,$28		; $7a40
	jp _linkedCutscene_aIntoCBB5_incSubstate		; $7a42
@substate8:
	call _func_03_7b95		; $7a45
	ret nz			; $7a48
	ld c,<TX_281f		; $7a49
	call _func_03_7b81		; $7a4b
	ld a,$5a		; $7a4e
	ld (wTmpcbb5),a		; $7a50
	ret			; $7a53
@substate9:
	call _func_7b9a		; $7a54
	jr z,@func_7a63	; $7a57
	ld a,$3c		; $7a59
	cp (hl)			; $7a5b
	ret nz			; $7a5c
	ld hl,$cfc0		; $7a5d
	set 6,(hl)		; $7a60
	ret			; $7a62
@func_7a63:
	ld hl,$cfc0		; $7a63
	set 7,(hl)		; $7a66
	ld a,$3c		; $7a68
	jp _linkedCutscene_aIntoCBB5_incSubstate		; $7a6a
@substateA:
	call _func_03_7b95		; $7a6d
	ret nz			; $7a70
	call _func_7c1f		; $7a71
	call _func_7beb		; $7a74
	ld a,MUS_DISASTER		; $7a77
	ld (wActiveMusic),a		; $7a79
	call playSound		; $7a7c
	xor a			; $7a7f
	ld ($cfc0),a		; $7a80
	ld ($cfc6),a		; $7a83
	ld a,$1e		; $7a86
	jp _linkedCutscene_aIntoCBB5_incSubstate		; $7a88
@substateB:
	ld a,($cfc0)		; $7a8b
	bit 0,a			; $7a8e
	ret z			; $7a90
	call _func_03_7b95		; $7a91
	ret nz			; $7a94
	ld c,<TX_2820		; $7a95
	jp _func_03_7b81		; $7a97
@substateC:
	call _func_7b9a		; $7a9a
	ret nz			; $7a9d
	ld c,<TX_2821		; $7a9e
	jp _func_03_7b81		; $7aa0
@substateD:
	call _func_7b9a		; $7aa3
	ret nz			; $7aa6
	ld c,<TX_2822		; $7aa7
	jp _func_03_7b81		; $7aa9
@substateE:
	call _func_7b9a		; $7aac
	ret nz			; $7aaf
	ld hl,$cfc0		; $7ab0
	res 0,(hl)		; $7ab3
	jp _linkedCutscene_incSubstate		; $7ab5
@substateF:
	ld a,($cfc0)		; $7ab8
	bit 0,a			; $7abb
	ret z			; $7abd
	ld a,SND_LIGHTNING		; $7abe
	call playSound		; $7ac0
	xor a			; $7ac3
	ld (wTmpcbb4),a		; $7ac4
	call _linkedCutscene_incSubstate		; $7ac7
@substate10:
	call _func_7b48		; $7aca
	ret nz			; $7acd
	call clearDynamicInteractions		; $7ace
	ld hl,$cfc0		; $7ad1
	res 0,(hl)		; $7ad4
	xor a			; $7ad6
	ld ($cfc6),a		; $7ad7
	ld a,$04		; $7ada
	jp _linkedCutscene_aIntoCBB5_incSubstate		; $7adc
@substate11:
	call _func_03_7b95		; $7adf
	ret nz			; $7ae2
	call _func_7c1f		; $7ae3
	call _func_7bf6		; $7ae6
	call _func_7c2f		; $7ae9
	ld a,$04		; $7aec
	call fadeinFromWhiteWithDelay		; $7aee
	ld a,$1e		; $7af1
	jp _linkedCutscene_aIntoCBB5_incSubstate		; $7af3
@substate12:
	call _func_7ba1		; $7af6
	ret nz			; $7af9
	ld c,<TX_2823		; $7afa
	jp _func_03_7b81		; $7afc
@substate13:
	call _func_7b9a		; $7aff
	ret nz			; $7b02
	ld c,<TX_2824		; $7b03
	jp _func_03_7b81		; $7b05
@substate14:
	call _func_7b9a		; $7b08
	ret nz			; $7b0b
	ld a,SND_BEAM2		; $7b0c
	call playSound		; $7b0e
	ld hl,$cfc0		; $7b11
	set 0,(hl)		; $7b14
	ld a,$5a		; $7b16
	jp _linkedCutscene_aIntoCBB5_incSubstate		; $7b18
@substate15:
	call _func_03_7b95		; $7b1b
	ret nz			; $7b1e
	dec a			; $7b1f
	ld (wTmpcbba),a		; $7b20
	ld a,SND_LIGHTNING		; $7b23
	call playSound		; $7b25
	ld a,SNDCTRL_STOPMUSIC		; $7b28
	call playSound		; $7b2a
	jp _linkedCutscene_incSubstate		; $7b2d
@substate16:
	ld hl,wTmpcbb5		; $7b30
	ld b,$02		; $7b33
	call flashScreen		; $7b35
	ret z			; $7b38
	ld a,GLOBALFLAG_FLAME_OF_DESPAIR_LIT		; $7b39
	call setGlobalFlag		; $7b3b
	xor a			; $7b3e
	ld (wMenuDisabled),a		; $7b3f
	ld a,CUTSCENE_FLAME_OF_DESPAIR		; $7b42
	ld (wCutsceneTrigger),a		; $7b44
	ret			; $7b47

_func_7b48:
	ld a,(wTmpcbb4)		; $7b48
	rst_jumpTable			; $7b4b
	.dw @cbb4_00
	.dw @cbb4_01
	.dw @cbb4_02
	.dw @cbb4_03
	.dw @cbb4_04
	.dw @cbb4_05
@cbb4_00:
	ld a,$0a		; $7b58
---
	ld (wTmpcbb5),a		; $7b5a
	call clearFadingPalettes		; $7b5d
	jp _func_03_7b90		; $7b60
@cbb4_01:
@cbb4_02:
	call _func_03_7b95		; $7b63
	ret nz			; $7b66
	ld a,$0a		; $7b67
--
	ld (wTmpcbb5),a		; $7b69
	call fastFadeoutToWhite		; $7b6c
	jp _func_03_7b90		; $7b6f
@cbb4_03:
	ld a,$14		; $7b72
	jr ---			; $7b74
@cbb4_04:
	call _func_03_7b95		; $7b76
	ret nz			; $7b79
	ld a,$1e		; $7b7a
	jr --		; $7b7c
@cbb4_05:
	jp _func_7ba1		; $7b7e


;;
; @param c Low byte of text index
; @addr{7b81}
_func_03_7b81:
	ld b,$28		; $7b81
	call showText		; $7b83
	ld a,$1e		; $7b86
_linkedCutscene_aIntoCBB5_incSubstate:
	ld (wTmpcbb5),a		; $7b88
_linkedCutscene_incSubstate:
	ld hl,wTmpcbb3		; $7b8b
	inc (hl)		; $7b8e
	ret			; $7b8f

;;
; @addr{7b90}
_func_03_7b90:
	ld hl,wTmpcbb4		; $7b90
	inc (hl)		; $7b93
	ret			; $7b94

;;
; @addr{7b95}
_func_03_7b95:
	ld hl,wTmpcbb5		; $7b95
	dec (hl)		; $7b98
	ret			; $7b99

_func_7b9a:
	ld a,(wTextIsActive)		; $7b9a
	or a			; $7b9d
	ret nz			; $7b9e
	jr ++			; $7b9f

_func_7ba1:
	ld a,(wPaletteThread_mode)		; $7ba1
	or a			; $7ba4
	ret nz			; $7ba5
++
	ld hl,wTmpcbb5		; $7ba6
	dec (hl)		; $7ba9
	ret			; $7baa


_func_7bab:
	xor a			; $7bab
	ld bc, ROOM_AGES_5f1		; $7bac
	call disableLcdAndLoadRoom		; $7baf
	ld a,PALH_ac		; $7bb2
	call loadPaletteHeader		; $7bb4
	ld a,$28		; $7bb7
	ld (wGfxRegs1.SCX),a		; $7bb9
	ld (wGfxRegs2.SCX),a		; $7bbc
	ldh (<hCameraX),a	; $7bbf
	xor a			; $7bc1
	ldh (<hCameraY),a	; $7bc2
	ld a,$00		; $7bc4
	ld (wScrollMode),a		; $7bc6
	ld a,$10		; $7bc9
	ldh (<hOamTail),a	; $7bcb
	jp clearWramBank1		; $7bcd


_func_7bd0:
	ld bc,_table_7be5		; $7bd0
	call _func_7bd9		; $7bd3
	ld bc,_table_7be8		; $7bd6
_func_7bd9:
	call getFreeInteractionSlot		; $7bd9
	ret nz			; $7bdc
	ld (hl),INTERACID_TWINROVA_IN_CUTSCENE		; $7bdd
	inc l			; $7bdf
	ld a,(bc)		; $7be0
	inc bc			; $7be1
	ld (hl),a		; $7be2
	jr _func_7c09		; $7be3
_table_7be5:
	.db $02 $4c $8e
_table_7be8:
	.db $03 $4c $62


_func_7beb:
	ld bc,_table_7c13		; $7beb
	call _func_7bff		; $7bee
	ld bc,_table_7c16		; $7bf1
	jr _func_7bff		; $7bf4


_func_7bf6:
	ld bc,_table_7c19		; $7bf6
	call _func_7bff		; $7bf9
	ld bc,_table_7c1c		; $7bfc
_func_7bff:
	call getFreeInteractionSlot		; $7bff
	ret nz			; $7c02
	ld (hl),INTERACID_TWINROVA_3		; $7c03
	inc l			; $7c05
	ld a,(bc)		; $7c06
	inc bc			; $7c07
	ld (hl),a		; $7c08
_func_7c09:
	ld l,$4b		; $7c09
	ld a,(bc)		; $7c0b
	inc bc			; $7c0c
	ld (hl),a		; $7c0d
	ld l,$4d		; $7c0e
	ld a,(bc)		; $7c10
	ld (hl),a		; $7c11
	ret			; $7c12
_table_7c13:
	nop			; $7c13
	nop			; $7c14
	ld b,b			; $7c15
_table_7c16:
	.db $01 $00 $60

_table_7c19:
	.db $02 $50 $68

_table_7c1c:
	.db $03 $50 $38


_func_7c1f:
	ld a,$01		; $7c1f
	ld (wLoadedTreeGfxIndex),a		; $7c21
	ld a,$bc		; $7c24
	ld (wInteractionIDToLoadExtraGfx),a		; $7c26
	ret			; $7c29


_func_7c2a:
	ld bc,_table_7c4e		; $7c2a
	jr _spawnZeldaKidnappedNPCs		; $7c2d

_func_7c2f:
	ld bc,_table_7c5d		; $7c2f

_spawnZeldaKidnappedNPCs:
	ld a,(bc)		; $7c32
	or a			; $7c33
	ret z			; $7c34
	call getFreeInteractionSlot		; $7c35
	ret nz			; $7c38
	ld a,(bc)		; $7c39
	ldi (hl),a		; $7c3a
	inc bc			; $7c3b
	ld a,(bc)		; $7c3c
	ldi (hl),a		; $7c3d
	inc bc			; $7c3e
	ld a,(bc)		; $7c3f
	ldi (hl),a		; $7c40
	inc bc			; $7c41
	ld l,$4b		; $7c42
	ld a,(bc)		; $7c44
	ld (hl),a		; $7c45
	inc bc			; $7c46
	ld l,$4d		; $7c47
	ld a,(bc)		; $7c49
	ld (hl),a		; $7c4a
	inc bc			; $7c4b
	jr _spawnZeldaKidnappedNPCs		; $7c4c

_table_7c4e:
	; id - subid - var03 - yh - xh
	.db INTERACID_BOY,              $0f $03 $48 $48
	.db INTERACID_IMPA_IN_CUTSCENE, $08 $03 $48 $58
	.db INTERACID_ZELDA,            $09 $02 $38 $50
_table_7c5d:
	.db INTERACID_VILLAGER,         $0e $01 $48 $38
	.db INTERACID_PAST_GUY,         $07 $00 $28 $78
	.db $00


_func_7c68:
	ld bc,_table_7c7f		; $7c68
	call addDoubleIndexToBc		; $7c6b
	call getFreePartSlot		; $7c6e
	ret nz			; $7c71
	ld (hl),PARTID_LIGHTNING		; $7c72
	inc l			; $7c74
	inc (hl)		; $7c75
	ld l,$cb		; $7c76
	ld a,(bc)		; $7c78
	ldi (hl),a		; $7c79
	inc bc			; $7c7a
	inc l			; $7c7b
	ld a,(bc)		; $7c7c
	ld (hl),a		; $7c7d
	ret			; $7c7e

_table_7c7f:
	.db $58 $38
	.db $48 $68

_func_7c83:
	ld bc,_table_7c7f		; $7c83
	call addDoubleIndexToBc		; $7c86
	call getFreeInteractionSlot		; $7c89
	ret nz			; $7c8c
	ld (hl),INTERACID_MISCELLANEOUS_1		; $7c8d
	inc l			; $7c8f
	ld (hl),$16		; $7c90
	ld l,$46		; $7c92
	ld (hl),$78		; $7c94
	jp _func_7c09		; $7c96
