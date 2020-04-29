;;
; CUTSCENE_S_PIRATES_DEPART
_cutsceneHandler_0c:
	ld a,(wCutsceneState)		; $66ff
	rst_jumpTable			; $6702
	.dw _cutsceneHandler_0c_stage0
	.dw _cutsceneHandler_0c_stage1
	.dw _cutsceneHandler_0c_stage2
	.dw _cutsceneHandler_0c_stage3
	.dw _cutsceneHandler_0c_stage4
	.dw _cutsceneHandler_0c_stage5

_cutsceneHandler_0c_stage0:
	ld b,$10		; $670f
	ld hl,$cbb3		; $6711
	call clearMemory		; $6714
	call clearWramBank1		; $6717
	xor a			; $671a
	ld (wDisabledObjects),a		; $671b
	ld (wScrollMode),a		; $671e
	ld a,(wGfxRegs2.SCY)		; $6721
	ld ($cbba),a		; $6724
	ld a,$80		; $6727
	ld (wMenuDisabled),a		; $6729
	ld a,$01		; $672c
	ld (wCutsceneState),a		; $672e
	ret			; $6731

_cutsceneHandler_0c_stage1:
	call seasonsFunc_03_6b6c		; $6732
	ld a,(wFrameCounter)		; $6735
	and $07			; $6738
	ret nz			; $673a
	ld a,($cbb3)		; $673b
	rst_jumpTable			; $673e
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3
	.dw @state4
	.dw @state5

@state0:
	call seasonsFunc_03_6815		; $674b
	ld a,$08		; $674e
	ld ($cbb8),a		; $6750
	ld a,$04		; $6753
	ld ($cbb4),a		; $6755
	ld a,$51		; $6758
	call loadGfxHeader		; $675a
	ld a,$54		; $675d
	call loadGfxHeader		; $675f
	ld a,$04		; $6762
	ldh (<hNextLcdInterruptBehaviour),a	; $6764
	call seasonsFunc_03_681a		; $6766
	jp seasonsFunc_03_67f8		; $6769
@state0Func0:
	ld hl,@state0Table0		; $676c
	ld d,$0f		; $676f
-
	ldi a,(hl)		; $6771
	ld c,a			; $6772
	ld a,$0f		; $6773
	push hl			; $6775
	call setTile		; $6776
	pop hl			; $6779
	dec d			; $677a
	jr nz,-			; $677b
	ret			; $677d
@state0Table0:
	.db $04 $05 $06 $07
	.db $08 $14 $15 $16
	.db $17 $18 $24 $25
	.db $26 $27 $28

@state1:
	ld hl,$cbb4		; $678d
	dec (hl)		; $6790
	ret nz			; $6791
	ld bc,TX_4e00		; $6792
	call showText		; $6795
	call @state0Func0		; $6798
	jp seasonsFunc_03_6815		; $679b

@state2:
	call retIfTextIsActive		; $679e
	ld hl,$7dd9		; $67a1
	call parseGivenObjectData		; $67a4
	ld a,MUS_TRIUMPHANT		; $67a7
	call playSound		; $67a9
	jp seasonsFunc_03_6815		; $67ac

@state3:
	call seasonsFunc_03_6b77		; $67af
	ld a,(hl)		; $67b2
	cp $10			; $67b3
	jr c,+			; $67b5
	call seasonsFunc_03_681a		; $67b7
	jr nz,+			; $67ba
	call seasonsFunc_03_6815		; $67bc
+
	jp seasonsFunc_03_67f8		; $67bf

@state4:
	call seasonsFunc_03_6b77		; $67c2
	ld a,(hl)		; $67c5
	cp $30			; $67c6
	jr c,seasonsFunc_03_67f8	; $67c8
	call fadeoutToWhite		; $67ca
	call seasonsFunc_03_6815		; $67cd
	jr seasonsFunc_03_67f8		; $67d0

@state5:
	call seasonsFunc_03_6b77		; $67d2
	ld a,(wPaletteThread_mode)		; $67d5
	or a			; $67d8
	jr nz,seasonsFunc_03_67f8	; $67d9
	ld a,$c7		; $67db
	ld (wGfxRegs1.WINY),a		; $67dd
	ld (wGfxRegs2.WINY),a		; $67e0
	ld a,$03		; $67e3
	ldh (<hNextLcdInterruptBehaviour),a	; $67e5
	ld a,$02		; $67e7
seasonsFunc_03_67e9:
	ld (wCutsceneState),a		; $67e9
	xor a			; $67ec
	ld ($cfc0),a		; $67ed
	ld b,$10		; $67f0
	ld hl,$cbb3		; $67f2
	jp clearMemory		; $67f5

seasonsFunc_03_67f8:
	ld a,$40		; $67f8
	ld (wGfxRegs2.LYC),a		; $67fa
	ld a,$47		; $67fd
	ld (wGfxRegs2.WINX),a		; $67ff
	ld a,$a5		; $6802
	ld (wGfxRegs1.WINX),a		; $6804
	ld a,($cbb8)		; $6807
	ld (wGfxRegs2.WINY),a		; $680a
	ld (wGfxRegs1.WINY),a		; $680d
	ld ($cbbc),a		; $6810
	jr seasonsFunc_03_684c		; $6813

seasonsFunc_03_6815:
	ld hl,$cbb3		; $6815
	inc (hl)		; $6818
	ret			; $6819

seasonsFunc_03_681a:
	ld a,($cbb7)		; $681a
	ld hl,seasonsTable_03_6844		; $681d
	rst_addAToHl			; $6820
	ld a,(hl)		; $6821
	cp $ff			; $6822
	ret z			; $6824
	ld l,a			; $6825
	ld h,$d0		; $6826
	push hl			; $6828
	ld de,$9c00		; $6829
	ld bc,$0f02		; $682c
	call queueDmaTransfer		; $682f
	pop hl			; $6832
	set 2,h			; $6833
	ld e,$01		; $6835
	call queueDmaTransfer		; $6837
	ld a,$08		; $683a
	ld ($cbb8),a		; $683c
	ld hl,$cbb7		; $683f
	inc (hl)		; $6842
	ret			; $6843

seasonsTable_03_6844:
	.db $c0 $a0 $80 $60
	.db $40 $20 $00 $ff

seasonsFunc_03_684c:
	ld a,$02		; $684c
	ld ($ff00+R_SVBK),a	; $684e
	ld a,($cbb8)		; $6850
	and $07			; $6853
	ld hl,$d800		; $6855
	rst_addDoubleIndex			; $6858
	ld de,$d9e0		; $6859
	ld b,$10		; $685c
	call copyMemory		; $685e
	ld a,($cbb8)		; $6861
	and $07			; $6864
	ld hl,$d820		; $6866
	rst_addDoubleIndex			; $6869
	ld de,$d9f0		; $686a
	ld b,$10		; $686d
	call copyMemory		; $686f
	ld a,$00		; $6872
	ld ($ff00+R_SVBK),a	; $6874
	ld hl,$d9e0		; $6876
	ld de,$94e1		; $6879
	ld bc,$0102		; $687c
	jp queueDmaTransfer		; $687f

_cutsceneHandler_0c_stage2:
	ld a,($cbb3)		; $6882
	rst_jumpTable			; $6885
	.dw @state0
	.dw @state1
	.dw @state2

@seasonsFunc_03_688c:
	call disableLcd			; $688c
	call clearScreenVariablesAndWramBank1		; $688f
	call seasonsFunc_03_6815		; $6892
	ld bc,$05d4		; $6895
	call _cutsceneHandler_0c_stage3@state0Func0		; $6898
	ld hl,$d000		; $689b
	ld (hl),$03		; $689e
	ld l,$0b		; $68a0
	ld (hl),$58		; $68a2
	ld l,$0d		; $68a4
	ld (hl),$70		; $68a6
	ld l,$08		; $68a8
	ld (hl),$02		; $68aa
	xor a			; $68ac
	ld (wLinkForceState),a		; $68ad
	ld a,$01		; $68b0
	ld (wScreenShakeMagnitude),a		; $68b2
	call resetCamera		; $68b5
	ld a,$02		; $68b8
	jp _cutsceneHandler_0c_stage3@state0Func1		; $68ba

@state0:
	ld a,(wPaletteThread_mode)		; $68bd
	or a			; $68c0
	ret nz			; $68c1
	call @seasonsFunc_03_688c		; $68c2
	ld hl,$7e14		; $68c5
	jp parseGivenObjectData		; $68c8

@state1:
	ret			; $68cb

@state2:
	ld a,$03		; $68cc
	call seasonsFunc_03_67e9		; $68ce
	jp fadeoutToWhite		; $68d1

_cutsceneHandler_0c_stage3:
	ld a,($cbb3)		; $68d4
	rst_jumpTable			; $68d7
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3
	.dw @state4

@state0:
	ld a,(wPaletteThread_mode)		; $68e2
	or a			; $68e5
	ret nz			; $68e6
	call disableLcd		; $68e7
	call clearScreenVariablesAndWramBank1		; $68ea
	call seasonsFunc_03_6815		; $68ed
	ld a,$40		; $68f0
	ld ($cbb8),a		; $68f2
	ld ($cbbf),a		; $68f5
	ld a,$1e		; $68f8
	ld ($cbb4),a		; $68fa
	ld a,$01		; $68fd
	ld (wRoomStateModifier),a		; $68ff
	ld bc,$00fe		; $6902
	call @state0Func0		; $6905
	call @state0Func2		; $6908
	ld e,$0c		; $690b
	call loadObjectGfxHeaderToSlot4		; $690d
	ld a,$52		; $6910
	call loadGfxHeader		; $6912
	ld hl,$7df0		; $6915
	call parseGivenObjectData		; $6918
	ld a,$11		; $691b
	jr @state0Func1		; $691d
@state0Func0:
	ld a,b			; $691f
	ld (wActiveGroup),a		; $6920
	ld a,c			; $6923
	ld (wActiveRoom),a		; $6924
	call loadScreenMusicAndSetRoomPack		; $6927
	call loadTilesetData		; $692a
	call loadTilesetGraphics		; $692d
	jp func_131f		; $6930
@state0Func1:
	push af			; $6933
	ld a,$01		; $6934
	ld (wScrollMode),a		; $6936
	call fadeinFromWhite		; $6939
	call loadCommonGraphics		; $693c
	pop af			; $693f
	jp loadGfxRegisterStateIndex		; $6940
@state0Func2:
	ld hl,$6953		; $6943
-
	ldi a,(hl)		; $6946
	cp $ff			; $6947
	ret z			; $6949
	ld c,a			; $694a
	ldi a,(hl)		; $694b
	push hl			; $694c
	call setTile		; $694d
	pop hl			; $6950
	jr -			; $6951
@state0Table0:
	.db $05 $ad $06 $ad
	.db $08 $ae $09 $ae
	.db $15 $ad $16 $ad
	.db $18 $ae $19 $ae
	.db $25 $ad $26 $ad
	.db $28 $ae $29 $ae
	.db $35 $ad $36 $ad
	.db $38 $ae $39 $ae
	.db $ff

@state1:
	ld hl,$cbb4		; $6974
	dec (hl)		; $6977
	ret nz			; $6978
	call seasonsFunc_03_6815		; $6979
	xor a			; $697c
	ldh (<hCameraY),a	; $697d
	ldh (<hCameraX),a	; $697f
	ld bc,TX_4e09		; $6981
	jp showText		; $6984

@state2:
	call retIfTextIsActive		; $6987
	ld a,$ff		; $698a
	ld ($cfc0),a		; $698c
	jp seasonsFunc_03_6815		; $698f

@state3:
	ld a,(wFrameCounter)		; $6992
	and $07			; $6995
	ret nz			; $6997
	call seasonsFunc_03_6b77		; $6998
	ld a,(hl)		; $699b
	cp $70			; $699c
	jr c,seasonsFunc_03_69d1			; $699e
	call fadeoutToWhite		; $69a0
	ld a,$fb		; $69a3
	call playSound		; $69a5
	call seasonsFunc_03_6815		; $69a8
	jr seasonsFunc_03_69d1			; $69ab

@state4:
	ld a,(wFrameCounter)		; $69ad
	and $07			; $69b0
	ret nz			; $69b2
	call seasonsFunc_03_6b77		; $69b3
	ld a,(wPaletteThread_mode)		; $69b6
	or a			; $69b9
	jr nz,seasonsFunc_03_69d1		; $69ba
	ld a,$c7		; $69bc
	ld (wGfxRegs1.WINY),a		; $69be
	ld (wGfxRegs2.WINY),a		; $69c1
	ld a,$04		; $69c4
	ld (wCutsceneState),a		; $69c6
	ld b,$10		; $69c9
	ld hl,$cbb3		; $69cb
	jp clearMemory		; $69ce

seasonsFunc_03_69d1:
	ld a,$a5		; $69d1
	ld (wGfxRegs1.WINX),a		; $69d3
	ld a,($cbb8)		; $69d6
	ld (wGfxRegs2.WINY),a		; $69d9
	ld (wGfxRegs1.WINY),a		; $69dc
	ld ($cbbc),a		; $69df
	ret			; $69e2

_cutsceneHandler_0c_stage4:
	ld a,($cbb3)		; $69e3
	rst_jumpTable			; $69e6
	.dw @state0
	.dw @state1
	.dw @state2

@state0:
	ld a,(wPaletteThread_mode)		; $69ed
	or a			; $69f0
	ret nz			; $69f1
	call _cutsceneHandler_0c_stage2@seasonsFunc_03_688c		; $69f2
	xor a			; $69f5
	ld ($cfc0),a		; $69f6
	ld hl,$7e2e		; $69f9
	jp parseGivenObjectData		; $69fc

@state1:
	ret			; $69ff

@state2:
	ld a,$05		; $6a00
	call seasonsFunc_03_67e9		; $6a02
	jp fadeoutToWhite		; $6a05

_cutsceneHandler_0c_stage5:
	call seasonsFunc_03_6b6c		; $6a08
	ld a,($cbb3)		; $6a0b
	rst_jumpTable			; $6a0e
	.dw @state0
	.dw @state1
	.dw @state2

@state0:
	ld a,(wPaletteThread_mode)		; $6a15
	or a			; $6a18
	ret nz			; $6a19
	call disableLcd		; $6a1a
	call clearScreenVariablesAndWramBank1		; $6a1d
	call seasonsFunc_03_6815		; $6a20
	ld a,$90		; $6a23
	ld ($cbb8),a		; $6a25
	ld ($cbbf),a		; $6a28
	ld a,$10		; $6a2b
	ld ($cbbd),a		; $6a2d
	ld a,$03		; $6a30
	ld (wRoomStateModifier),a		; $6a32
	ld bc,$00f2		; $6a35
	call _cutsceneHandler_0c_stage3@state0Func0		; $6a38
	ld a,$ff		; $6a3b
	ld ($cd25),a		; $6a3d
	ld e,$00		; $6a40
	call loadObjectGfxHeaderToSlot4		; $6a42
	ld a,$53		; $6a45
	call loadGfxHeader		; $6a47
	ld a,$54		; $6a4a
	call loadGfxHeader		; $6a4c
	ld hl,$7dfa		; $6a4f
	call parseGivenObjectData		; $6a52
	ld a,$12		; $6a55
	jp _cutsceneHandler_0c_stage3@state0Func1		; $6a57

@state1:
	ld a,(wFrameCounter)		; $6a5a
	and $03			; $6a5d
	jr nz,@state1Func0	; $6a5f
	call seasonsFunc_03_6b80		; $6a61
	ld a,(hl)		; $6a64
	cp $09			; $6a65
	jp nc,@state1Func0		; $6a67
	call seasonsFunc_03_6b30		; $6a6a
	call seasonsFunc_03_6815		; $6a6d
@state1Func0:
	call seasonsFunc_03_69d1		; $6a70
	jr seasonsFunc_03_6aca		; $6a73

@state2:
	ld a,(wFrameCounter)		; $6a75
	and $07			; $6a78
	jr nz,@state1Func0	; $6a7a
	call seasonsFunc_03_6b80		; $6a7c
	ld a,(hl)		; $6a7f
	cp $09			; $6a80
	jr nc,@state1Func0	; $6a82
	call seasonsFunc_03_6b30		; $6a84
	jr nz,@state1Func0	; $6a87
	ld a,GLOBALFLAG_PIRATE_SHIP_DOCKED		; $6a89
	call setGlobalFlag		; $6a8b
	xor a			; $6a8e
	ld (wActiveMusic),a		; $6a8f
	ld hl,@state2WarpDestVariables		; $6a92
	jp setWarpDestVariables		; $6a95
@state2WarpDestVariables:
	m_HardcodedWarpA ROOM_SEASONS_0e2 $0f $66 $03

seasonsFunc_03_6a9d:
	ld a,$02		; $6a9d
	ld ($ff00+R_SVBK),a	; $6a9f
	ld a,($cbbe)		; $6aa1
	dec a			; $6aa4
	and $03			; $6aa5
	ld hl,seasonsTable_03_6b1a		; $6aa7
	rst_addDoubleIndex			; $6aaa
	ldi a,(hl)		; $6aab
	ld h,(hl)		; $6aac
	ld l,a			; $6aad
	ld a,($cbb8)		; $6aae
	and $07			; $6ab1
	rst_addDoubleIndex			; $6ab3
	ld de,$d9e0		; $6ab4
	call seasonsFunc_03_6b22		; $6ab7
	ld a,$00		; $6aba
	ld ($ff00+R_SVBK),a	; $6abc
	ld hl,$d9e0		; $6abe
	ld de,$8ce0		; $6ac1
	ld bc,$0102		; $6ac4
	jp queueDmaTransfer		; $6ac7

seasonsFunc_03_6aca:
	ld hl,$cbbd		; $6aca
	dec (hl)		; $6acd
	jr nz,seasonsFunc_03_6a9d	; $6ace
	ld (hl),$10		; $6ad0
	ld a,$02		; $6ad2
	ld ($ff00+R_SVBK),a	; $6ad4
	ld a,($cbbe)		; $6ad6
	ld hl,seasonsTable_03_6b1a		; $6ad9
	rst_addDoubleIndex			; $6adc
	ldi a,(hl)		; $6add
	ld h,(hl)		; $6ade
	ld l,a			; $6adf
	ld de,$d9c0		; $6ae0
	push hl			; $6ae3
	call seasonsFunc_03_6b22		; $6ae4
	pop hl			; $6ae7
	ld a,($cbb8)		; $6ae8
	and $07			; $6aeb
	rst_addDoubleIndex			; $6aed
	ld de,$d9e0		; $6aee
	call seasonsFunc_03_6b22		; $6af1
	ld a,$00		; $6af4
	ld ($ff00+R_SVBK),a	; $6af6
	ld hl,$d9c0		; $6af8
	ld de,$88e1		; $6afb
	ld bc,$0102		; $6afe
	call queueDmaTransfer		; $6b01
	ld hl,$d9e0		; $6b04
	ld de,$8ce0		; $6b07
	ld bc,$0102		; $6b0a
	call queueDmaTransfer		; $6b0d
	ld a,($cbbe)		; $6b10
	inc a			; $6b13
	and $03			; $6b14
	ld ($cbbe),a		; $6b16
	ret			; $6b19

seasonsTable_03_6b1a:
	.db $40 $d8
	.db $80 $d8
	.db $c0 $d8
	.db $00 $d9

seasonsFunc_03_6b22:
	ld b,$10		; $6b22
	call copyMemory		; $6b24
	ld bc,$0010		; $6b27
	add hl,bc		; $6b2a
	ld b,$10		; $6b2b
	jp copyMemory		; $6b2d

seasonsFunc_03_6b30:
	ld a,($cbb7)		; $6b30
	ld hl,seasonsTable_03_6b59		; $6b33
	rst_addDoubleIndex			; $6b36
	ldi a,(hl)		; $6b37
	cp $ff			; $6b38
	ret z			; $6b3a
	ld h,(hl)		; $6b3b
_label_03_196:
	ld l,a			; $6b3c
	push hl			; $6b3d
	ld de,$9c00		; $6b3e
	ld bc,$2102		; $6b41
	call queueDmaTransfer		; $6b44
	pop hl			; $6b47
	set 2,h			; $6b48
	ld e,$01		; $6b4a
	call queueDmaTransfer		; $6b4c
	ld a,$10		; $6b4f
	ld ($cbb8),a		; $6b51
	ld hl,$cbb7		; $6b54
	inc (hl)		; $6b57
	ret			; $6b58

seasonsTable_03_6b59:
	.db $20 $d0
	.db $40 $d0
	.db $60 $d0
	.db $80 $d0
	.db $a0 $d0
	.db $c0 $d0
	.db $e0 $d0
	.db $00 $d1
	.db $20 $d1
	.db $ff

seasonsFunc_03_6b6c:
	ld hl,seasonsOamData_03_6b72		; $6b6c
	jp addSpritesToOam	; $6b6f

seasonsOamData_03_6b72:
	.db $01			; $6b72
	.db $10 $a6 $4c $09	; $6b73

seasonsFunc_03_6b77:
	ld hl,$cbbf		; $6b77
	inc (hl)		; $6b7a
	ld hl,$cbb8		; $6b7b
	inc (hl)		; $6b7e
	ret			; $6b7f

seasonsFunc_03_6b80:
	ld hl,$cbbf		; $6b80
	dec (hl)		; $6b83
	ld hl,$cbb8		; $6b84
	dec (hl)		; $6b87
	ret			; $6b88
