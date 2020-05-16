multiIntroCutsceneHandler:
	ld a,e			; $72ff
	rst_jumpTable			; $7300
	.dw cutsceneDinDancing
	.dw cutsceneDinImprisoned
	.dw cutsceneTempleSinking
	.dw cutscenePregameIntro
	.dw cutsceneOnoxTaunting

cutsceneDinDancing:
	call cutsceneDinDancingHandler		; $730b
	ld hl,wCutsceneState		; $730e
	ld a,(hl)		; $7311
	cp $02			; $7312
	ret z			; $7314
	cp $03			; $7315
	ret z			; $7317
	jp updateAllObjects		; $7318

cutsceneDinDancingHandler:
	ld de,wCutsceneState		; $731b
	ld a,(de)		; $731e
	rst_jumpTable			; $731f
	.dw cutscene06Func0
	.dw cutscene06Func1
	.dw cutscene06Func2 ; don't updateAllObjects
	.dw cutscene06Func3 ; don't updateAllObjects
	.dw cutscene06Func4
	.dw cutscene06Func5
	.dw cutscene06Func6
	.dw cutscene06Func7
	.dw cutscene06Func8
	.dw cutscene06Func9
	.dw cutscene06Funca
	.dw cutscene06Funcb
	.dw cutscene06Funcc
	.dw cutscene06Funcd
	.dw cutscene06Funce
	.dw cutscene06Funcf
cutscene06Func0:
	ld a,$01		; $7340
	ld (de),a		; $7342
	ld a,SND_CLOSEMENU		; $7343
	call playSound		; $7345
cutscene06Func1:
	ld a,$ff		; $7348
	ld (wTilesetAnimation),a		; $734a
	ld a,$01		; $734d
	ld ($cfd0),a		; $734f
	ld hl,$cc02		; $7352
	ld (hl),$01		; $7355
	ld hl,$d01a		; $7357
	res 7,(hl)		; $735a
	call saveGraphicsOnEnterMenu		; $735c
	ld a,GFXH_0c		; $735f
	call loadGfxHeader		; $7361
	ld a,SEASONS_PALH_95		; $7364
	call loadPaletteHeader		; $7366
	ld a,$04		; $7369
	call loadGfxRegisterStateIndex		; $736b
	ld hl,$cbb3		; $736e
	ld (hl),$58		; $7371
	inc hl			; $7373
	ld (hl),$02		; $7374
	ld hl,$cbb6		; $7376
	ld (hl),$28		; $7379
	call fastFadeinFromWhite		; $737b
	call incCutsceneState		; $737e
	ld hl,$cbb5		; $7381
	ld (hl),$02		; $7384
	
seasonsFunc_03_7386:
	call clearOam		; $7386
	ld b,$00		; $7389
	ld a,(wGfxRegs1.SCX)		; $738b
	cpl			; $738e
	inc a			; $738f
	ld c,a			; $7390
	ld hl,seasonsOamData_03_7397		; $7391
	jp addSpritesToOam_withOffset		; $7394

seasonsOamData_03_7397:
	.db $24
	.db $51 $3f $1e $06
	.db $40 $0c $08 $01
	.db $4f $0c $28 $01
	.db $5c $30 $20 $02
	.db $5c $38 $22 $01
	.db $4c $3f $04 $01
	.db $50 $4a $06 $02
	.db $40 $14 $0a $01
	.db $4f $14 $2a $01
	.db $61 $64 $0c $01
	.db $61 $6c $0e $01
	.db $71 $64 $2c $01
	.db $71 $6c $2e $01
	.db $88 $38 $10 $00
	.db $69 $50 $26 $04
	.db $69 $48 $24 $04
	.db $4c $2f $00 $01
	.db $4c $37 $02 $01
	.db $53 $30 $12 $05
	.db $53 $38 $14 $05
	.db $11 $86 $42 $03
	.db $17 $88 $16 $04
	.db $37 $a2 $30 $04
	.db $37 $aa $32 $04
	.db $21 $9f $18 $05
	.db $21 $a7 $1a $05
	.db $22 $9e $1c $03
	.db $73 $b0 $34 $04
	.db $73 $b8 $36 $04
	.db $3a $9c $38 $03
	.db $3b $2b $3a $03
	.db $3b $33 $3c $03
	.db $40 $42 $3e $03
	.db $70 $80 $40 $03
	.db $90 $34 $44 $06
	.db $90 $3c $46 $06

cutscene06Func2:
	ld a,(wPaletteThread_mode)		; $7428
	or a			; $742b
	jp nz,seasonsFunc_03_7386		; $742c
	call seasonsFunc_03_7458		; $742f
	call seasonsFunc_03_7386		; $7432
	ld hl,$cbb3		; $7435
	call decHlRef16WithCap		; $7438
	jr z,+	; $743b
	ldi a,(hl)		; $743d
	ld h,(hl)		; $743e
	ld l,a			; $743f
	ld bc,$00f0		; $7440
	call compareHlToBc		; $7443
	ret nc			; $7446
	ld a,($c482)		; $7447
	and $01			; $744a
	ret z			; $744c
+
	ld a,SND_CLOSEMENU		; $744d
	call playSound		; $744f
	call incCutsceneState		; $7452
	jp fastFadeoutToWhite		; $7455
	
seasonsFunc_03_7458:
	ld a,(wFrameCounter)		; $7458
	and $07			; $745b
	ret nz			; $745d
	ld hl,$cbb6		; $745e
	ld a,(hl)		; $7461
	or a			; $7462
	ret z			; $7463
	dec (hl)		; $7464
	ld hl,$c487		; $7465
	inc (hl)		; $7468
	ret			; $7469
cutscene06Func3:
	ld a,(wPaletteThread_mode)		; $746a
	or a			; $746d
	jp nz,seasonsFunc_03_7386		; $746e
	xor a			; $7471
	ld (wTilesetAnimation),a		; $7472
	ld hl,$d01a		; $7475
	set 7,(hl)		; $7478
	xor a			; $747a
	ld ($cfd0),a		; $747b
	call incCutsceneState		; $747e
	jp reloadGraphicsOnExitMenu		; $7481

cutscene06Func4:
	ld a,($cfd0)		; $7484
	cp $02			; $7487
	ret nz			; $7489
	ld hl,$cbb4		; $748a
	xor a			; $748d
	ld (hl),a		; $748e
	call seasonsFunc_03_74aa		; $748f
	ld hl,$de90		; $7492
	ld bc,$44e8		; $7495
	call func_13c6		; $7498
	ld a,SNDCTRL_STOPMUSIC		; $749b
	call playSound		; $749d
	jp incCutsceneState		; $74a0

seasonsFunc_03_74a3:
	call decCbb3		; $74a3
	ret nz			; $74a6
	inc l			; $74a7
	inc (hl)		; $74a8
	ld a,(hl)		; $74a9
	
seasonsFunc_03_74aa:
	ld d,h			; $74aa
	ld e,l			; $74ab
	add a			; $74ac
	ld hl,seasonsTable_03_74d1		; $74ad
	rst_addDoubleIndex			; $74b0
	dec e			; $74b1
	ldi a,(hl)		; $74b2
	ld (de),a		; $74b3
	inc a			; $74b4
	ret z			; $74b5

seasonsFunc_03_74b6:
	ld d,h			; $74b6
	ld e,l			; $74b7
	call getFreePartSlot	; $74b8
	jr nz,+			; $74bb
	ld (hl),PARTID_LIGHTNING		; $74bd
	ld l,$c2		; $74bf
	inc (hl)		; $74c1
	inc l			; $74c2
	ld a,(de)		; $74c3
	ld (hl),a		; $74c4
	inc de			; $74c5
	ld l,$cb		; $74c6
	ld a,(de)		; $74c8
	ldi (hl),a		; $74c9
	inc de			; $74ca
	inc hl			; $74cb
	ld a,(de)		; $74cc
	ld (hl),a		; $74cd
+
	or $01			; $74ce
	ret			; $74d0

seasonsTable_03_74d1:
	.db $3c $00 $50 $20
	.db $3c $01 $70 $58
	.db $28 $00 $40 $80
	.db $28 $00 $18 $30
	.db $1e $02 $10 $80
	.db $1e $00 $40 $48
	.db $14 $00 $20 $70
	.db $14 $04 $78 $88
	.db $14 $08 $70 $70
	.db $14 $00 $40 $40
	.db $ff

seasonsTable_03_74fa:
	.db $10 $70 $18
	
cutscene06Func5:
	ld a,(wPaletteThread_mode)		; $74fd
	or a			; $7500
	ret nz			; $7501
	ld hl,$cfd0		; $7502
	ld (hl),$03		; $7505
	call seasonsFunc_03_7516		; $7507
	call seasonsFunc_03_74a3		; $750a
	ret nz			; $750d
	ld hl,$cbb3		; $750e
	ld (hl),$3c		; $7511
	jp incCutsceneState		; $7513

seasonsFunc_03_7516:
	ld de,$cfd2		; $7516
	ld b,$03		; $7519
-
	ld a,(de)		; $751b
	ld c,a			; $751c
	ld a,b			; $751d
	ld hl,bitTable		; $751e
	add l			; $7521
	ld l,a			; $7522
	ld a,(hl)		; $7523
	and c			; $7524
	call nz,cutsceneDinDancing_loadListOfTiles		; $7525
	dec b			; $7528
	bit 7,b			; $7529
	jr z,-	; $752b
	ret			; $752d

;;
; @param	b	index of tile list in table below
; @addr{752e}
cutsceneDinDancing_loadListOfTiles:
	xor c			; $752e
	ld (de),a		; $752f
	push bc			; $7530
	push de			; $7531
	ld a,b			; $7532
	ld hl,@tileListTable		; $7533
	rst_addDoubleIndex			; $7536
	ldi a,(hl)		; $7537
	ld h,(hl)		; $7538
	ld l,a			; $7539
	ld b,(hl)		; $753a
	inc hl			; $753b
-
	ld c,(hl)		; $753c
	inc hl			; $753d
	ld e,c			; $753e
	ld d,$cf		; $753f
	ld a,(de)		; $7541
	push bc			; $7542
	push hl			; $7543
	call setTile		; $7544
	pop hl			; $7547
	pop bc			; $7548
	dec b			; $7549
	jr nz,-			; $754a
	pop de			; $754c
	pop bc			; $754d
	ret			; $754e
@tileListTable:
	.dw @tileList1
	.dw @tileList2
	.dw @tileList3
	.dw @tileList4
	; numTiles -> list of tile indices
@tileList1:
	.db $02 $65 $75
@tileList2:
	.db $03 $07 $08 $18
@tileList3:
	.db $01	$78
@tileList4:
	.db $04 $66 $67 $76 $77
	
cutscene06Func6:
	call decCbb3		; $7565
	ret nz			; $7568
	call incCutsceneState		; $7569
	ld bc,$0c08		; $756c
	call checkIsLinkedGame		; $756f
	jr z,+	; $7572
	ld bc,$0c12		; $7574
+
	jp showText		; $7577
	
cutscene06Func7:
	call retIfTextIsActive		; $757a
	call incCutsceneState		; $757d
	ld hl,seasonsTable_03_74fa		; $7580
	jp seasonsFunc_03_74b6		; $7583
	
cutscene06Func8:
	ld hl,$cfd2		; $7586
	ld a,(hl)		; $7589
	bit 4,a			; $758a
	ret z			; $758c
	call getFreeInteractionSlot		; $758d
	jr nz,+	; $7590
	ld (hl),INTERACID_DIN_DANCING_EVENT		; $7592
	inc l			; $7594
	ld (hl),$07		; $7595
+
	jp incCutsceneState		; $7597
	
cutscene06Func9:
	ld c,$09		; $759a
	call checkIsLinkedGame		; $759c
	jr z,+	; $759f
	ld c,$13		; $75a1
+
	ld a,$05		; $75a3

seasonsFunc_03_75a5:
	ld b,a			; $75a5
	ld hl,$cfd0		; $75a6
	ld a,(hl)		; $75a9
	cp b			; $75aa
	ret nz			; $75ab
	call incCutsceneState		; $75ac
	ld b,$0c		; $75af
	jp showText		; $75b1
	
cutscene06Funca:
	call retIfTextIsActive		; $75b4
	ld hl,$cfd0		; $75b7
	ld (hl),$06		; $75ba
	jp incCutsceneState		; $75bc
	
cutscene06Funcb:
	ld a,$08		; $75bf
	ld c,$14		; $75c1
	jp seasonsFunc_03_75a5		; $75c3
	
cutscene06Funcc:
	call retIfTextIsActive		; $75c6
	ld hl,$cbb3		; $75c9
	ld (hl),$1e		; $75cc
	jp incCutsceneState		; $75ce
	
cutscene06Funcd:
	call decCbb3		; $75d1
	ret nz			; $75d4
	ld hl,$cfd0		; $75d5
	ld (hl),$09		; $75d8
	jp incCutsceneState		; $75da
	
cutscene06Funce:
	ld hl,$cfd0		; $75dd
	ld a,(hl)		; $75e0
	cp $0b			; $75e1
	ret nz			; $75e3
	ld hl,$cbb3		; $75e4
	ld (hl),$3c		; $75e7
	jp incCutsceneState		; $75e9
	
cutscene06Funcf:
	call decCbb3		; $75ec
	ret nz			; $75ef
	call clearOam		; $75f0
	call _cutscene_clearObjects		; $75f3
	ld a,$07		; $75f6
	ld (wCutsceneIndex),a		; $75f8
	xor a			; $75fb
	ld ($cc02),a		; $75fc
	ld (wCutsceneState),a		; $75ff
	ld a,$30		; $7602
	call unsetGlobalFlag		; $7604
	jp fadeoutToWhite		; $7607


cutsceneDinImprisoned:
	ld de,wCutsceneState		; $760a
	ld a,(de)		; $760d
	rst_jumpTable			; $760e
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

@state0:
	ld a,(wPaletteThread_mode)		; $7623
	or a			; $7626
	ret nz			; $7627
	ld a,$01		; $7628
	ld (de),a		; $762a
	ld a,$09		; $762b
	ld ($cfd0),a		; $762d
	ld hl,$cbb3		; $7630
	ld (hl),$58		; $7633
	inc l			; $7635
	ld (hl),$01		; $7636
	ld a,$09		; $7638
	ld b,$00		; $763a
	call seasonsFunc_03_7aa9		; $763c
	ld a,MUS_ONOX_CASTLE		; $763f
	call playSound		; $7641
	jp fadeinFromWhite		; $7644

@state1:
	ld a,(wPaletteThread_mode)		; $7647
	or a			; $764a
	ret nz			; $764b
	ld hl,$cbb3		; $764c
	call decHlRef16WithCap		; $764f
	jr nz,+	; $7652
	xor a			; $7654
	ld (wGfxRegs1.SCY),a		; $7655
	call incCutsceneState		; $7658
	jp fadeoutToWhite		; $765b
+
	ld hl,$cbb3		; $765e
	ld a,(hl)		; $7661
	and $01			; $7662
	ret nz			; $7664
	ld hl,wGfxRegs1.SCY		; $7665
	ld a,(hl)		; $7668
	or a			; $7669
	ret z			; $766a
	dec a			; $766b
	ld (hl),a		; $766c
	ldh (<hCameraY),a	; $766d
	ret			; $766f

@state2:
	ld a,(wPaletteThread_mode)		; $7670
	or a			; $7673
	ret nz			; $7674
	call incCutsceneState		; $7675
	ld a,$0a		; $7678
	ld ($cfd0),a		; $767a
	call disableLcd		; $767d
	xor a			; $7680
	ld (wScreenOffsetY),a		; $7681
	ld (wScreenOffsetX),a		; $7684
	ld a,GFXH_2e		; $7687
	call loadGfxHeader		; $7689
	ld a,SEASONS_PALH_97		; $768c
	call loadPaletteHeader		; $768e
	ld a,$01		; $7691
	ld (wScrollMode),a		; $7693
	ld a,$18		; $7696
	ld (wTilesetAnimation),a		; $7698
	call loadAnimationData		; $769b
	call getFreeInteractionSlot		; $769e
	jr nz,+	; $76a1
	ld a,INTERACID_DIN_IMPRISONED_EVENT		; $76a3
	ldi (hl),a		; $76a5
	ld (hl),$00		; $76a6
	ld ($cc1d),a		; $76a8
	call getFreeInteractionSlot		; $76ab
	jr nz,+	; $76ae
	ld (hl),INTERACID_DIN_IMPRISONED_EVENT		; $76b0
	inc l			; $76b2
	ld (hl),$01		; $76b3
+
	call refreshObjectGfx		; $76b5
	ld a,$0d		; $76b8
	call loadGfxRegisterStateIndex		; $76ba
	ld hl,wGfxRegs1.SCY		; $76bd
	ldi a,(hl)		; $76c0
	ldh (<hCameraY),a	; $76c1
	ld a,(hl)		; $76c3
	ldh (<hCameraX),a	; $76c4
	jp fadeinFromWhite		; $76c6
@state3:
	ld hl,$cfd0		; $76c9
	ld a,(hl)		; $76cc
	cp $0b			; $76cd
	ret nz			; $76cf
	ld b,$04		; $76d0
-
	call getFreeInteractionSlot		; $76d2
	jr nz,+	; $76d5
	ld (hl),INTERACID_DIN_IMPRISONED_EVENT		; $76d7
	inc l			; $76d9
	ld (hl),$02		; $76da
	inc l			; $76dc
	dec b			; $76dd
	ld a,b			; $76de
	ld (hl),a		; $76df
	jr nz,-	; $76e0
+
	jp incCutsceneState		; $76e2

@state4:
	ld a,($cfd0)		; $76e5
	sub $0c			; $76e8
	ret nz			; $76ea
	ld ($cbb3),a		; $76eb
	dec a			; $76ee
	ld ($cbba),a		; $76ef
	jp incCutsceneState		; $76f2

@state5:
	ld hl,$cbb3		; $76f5
	ld b,$01		; $76f8
	call flashScreen		; $76fa
	ret z			; $76fd
	call disableLcd		; $76fe
	ld a,$01		; $7701
	ldh (<hDirtyBgPalettes),a	; $7703
	ld a,$fe		; $7705
	ldh (<hBgPaletteSources),a	; $7707
	ld a,$81		; $7709
	call seasonsFunc_03_7a6b		; $770b
	ld a,$81		; $770e
	ld ($cbcb),a		; $7710
	call seasonsFunc_03_7a88		; $7713
	ld bc,TX_1e05		; $7716
	call showText		; $7719
	ld a,$0d		; $771c
	call loadGfxRegisterStateIndex		; $771e
	ld hl,wGfxRegs1.SCY		; $7721
	ldi a,(hl)		; $7724
	ldh (<hCameraY),a	; $7725
	ld a,(hl)		; $7727
	ldh (<hCameraX),a	; $7728
	ld hl,$cfd0		; $772a
	ld (hl),$0d		; $772d
	jp incCutsceneState		; $772f

@state6:
	call retIfTextIsActive		; $7732
	call disableLcd		; $7735
	ld a,UNCMP_GFXH_0e		; $7738
	call loadUncompressedGfxHeader		; $773a
	ld a,SND_CLINK		; $773d
	call playSound		; $773f
	ld a,$0d		; $7742
	call loadGfxRegisterStateIndex		; $7744
	call fadeinFromWhite		; $7747
	ld hl,$cbb3		; $774a
	ld (hl),$f0		; $774d
	xor a			; $774f
	ld ($cbcb),a		; $7750
	jp incCutsceneState		; $7753

@state7:
	ld a,(wPaletteThread_mode)		; $7756
	or a			; $7759
	ret nz			; $775a
	call decCbb3		; $775b
	ret nz			; $775e
	call incCutsceneState		; $775f
	jp fadeoutToWhite		; $7762

@state8:
	ld a,(wPaletteThread_mode)		; $7765
	or a			; $7768
	ret nz			; $7769
	call incCutsceneState		; $776a
	ld a,$ff		; $776d
	ld (wTilesetAnimation),a		; $776f
	ld a,$0e		; $7772
	ld ($cfd0),a		; $7774
	ld a,$07		; $7777
	ld b,$01		; $7779
	call seasonsFunc_03_7aa9		; $777b
	jp fadeinFromWhite		; $777e

@state9:
	ld a,(wPaletteThread_mode)		; $7781
	or a			; $7784
	ret nz			; $7785
	ld hl,$cfd0		; $7786
	ld a,(hl)		; $7789
	cp $0f			; $778a
	ret nz			; $778c

	call clearDynamicInteractions		; $778d
	ld a,$08		; $7790
	ld (wCutsceneIndex),a		; $7792
	xor a			; $7795
	ld (wCutsceneState),a		; $7796
	jp fadeoutToWhite		; $7799


cutsceneTempleSinking:
	ld de,wCutsceneState		; $779c
	ld a,(de)		; $779f
	rst_jumpTable			; $77a0
	.dw cutscene08Func0
	.dw cutscene08Func1
	.dw cutscene08Func2
	.dw cutscene08Func3
	.dw cutscene08Func4
	.dw cutscene08Func5
	.dw cutscene08Func6
	.dw cutscene08Func7
	.dw cutscene08Func8
cutscene08Func0:
	ld a,(wPaletteThread_mode)		; $77b3
	or a			; $77b6
	ret nz			; $77b7
	ld a,$01		; $77b8
	ld (de),a		; $77ba
	ld b,$02		; $77bb
-
	call getFreeInteractionSlot		; $77bd
	jr nz,+	; $77c0
	ld (hl),INTERACID_77		; $77c2
	inc l			; $77c4
	dec b			; $77c5
	ld (hl),b		; $77c6
	jr nz,-	; $77c7
+
	call disableLcd		; $77c9
	ld a,GFXH_24		; $77cc
	call loadGfxHeader		; $77ce
	ld a,SEASONS_PALH_98		; $77d1
	call loadPaletteHeader		; $77d3
	ld a,$0e		; $77d6
	call loadGfxRegisterStateIndex		; $77d8
	ld hl,wGfxRegs1.SCY		; $77db
	ldi a,(hl)		; $77de
	ldh (<hCameraY),a	; $77df
	ldi a,(hl)		; $77e1
	ldh (<hCameraX),a	; $77e2
	ld de,$cbb6		; $77e4
	ldi a,(hl)		; $77e7
	ld (de),a		; $77e8
	inc de			; $77e9
	ld a,(hl)		; $77ea
	ld (de),a		; $77eb
	ld hl,$cbb3		; $77ec
	ld (hl),$3c		; $77ef
	xor a			; $77f1
	ld hl,$cfd3		; $77f2
	ld (hl),a		; $77f5
	call seasonsFunc_03_79db		; $77f6
	ld a,MUS_DISASTER		; $77f9
	call playSound		; $77fb
	jp fadeinFromWhite		; $77fe
cutscene08Func1:
	ld a,(wPaletteThread_mode)		; $7801
	or a			; $7804
	jp nz,seasonsFunc_03_7827		; $7805
	call decCbb3		; $7808
	jr nz,seasonsFunc_03_7827	; $780b
	ld b,$05		; $780d
-
	call getFreeInteractionSlot		; $780f
	jr nz,+	; $7812
	ld (hl),INTERACID_TEMPLE_SINKING_EXPLOSION		; $7814
	inc l			; $7816
	dec b			; $7817
	ld a,b			; $7818
	ld (hl),a		; $7819
	jr nz,-	; $781a
+
	ld hl,$cbb3		; $781c
	ld (hl),$b4		; $781f
	inc hl			; $7821
	ld (hl),$00		; $7822
	call incCutsceneState		; $7824

seasonsFunc_03_7827:
	jp seasonsFunc_03_7981		; $7827
cutscene08Func2:
	call decCbb3		; $782a
	jr nz,+	; $782d
	call seasonsFunc_03_7a01		; $782f
	xor a			; $7832
	ld hl,$cbb4		; $7833
	ld (hl),a		; $7836
	call seasonsFunc_03_7917		; $7837
	ld hl,$cfd3		; $783a
	inc (hl)		; $783d
	set 7,(hl)		; $783e
	jp incCutsceneState		; $7840
+
	call seasonsFunc_03_7909		; $7843
	jp seasonsFunc_03_7981		; $7846
cutscene08Func3:
	call seasonsFunc_03_7981		; $7849
	call decCbb3		; $784c
	ret nz			; $784f
	inc l			; $7850
	inc (hl)		; $7851
	ld a,(hl)		; $7852
	cp $03			; $7853
	jr z,+	; $7855
	ld hl,$cfd3		; $7857
	inc (hl)		; $785a
	jp seasonsFunc_03_7917		; $785b
+
	call disableLcd		; $785e
	ld a,GFXH_24		; $7861
	call loadGfxHeader		; $7863
	ld a,SEASONS_PALH_98		; $7866
	call loadPaletteHeader		; $7868
	call seasonsFunc_03_7a17		; $786b
	ld hl,$cbb3		; $786e
	ld (hl),$78		; $7871
	inc l			; $7873
	ld (hl),$00		; $7874
	ld hl,$cfd3		; $7876
	inc (hl)		; $7879
	res 7,(hl)		; $787a
	jp incCutsceneState		; $787c
cutscene08Func4:
	call decCbb3		; $787f
	jr nz,+	; $7882
	call disableLcd		; $7884
	ld a,$03		; $7887
	inc l			; $7889
	ld (hl),a		; $788a
	call seasonsFunc_03_7917		; $788b
	ld hl,$cfd3		; $788e
	ld (hl),$ff		; $7891
	call incCutsceneState		; $7893
	ld hl,$cbba		; $7896
	ld (hl),$02		; $7899
	ld hl,$cbb8		; $789b
	jp seasonsFunc_03_7a3b		; $789e
+
	call seasonsFunc_03_7909		; $78a1
	jp seasonsFunc_03_7981		; $78a4
cutscene08Func5:
	call seasonsFunc_03_7981		; $78a7
	call seasonsFunc_03_7a2e		; $78aa
	call decCbb3		; $78ad
	ret nz			; $78b0
	inc l			; $78b1
	inc (hl)		; $78b2
	ld a,(hl)		; $78b3
	cp $06			; $78b4
	jr z,+	; $78b6
	jp seasonsFunc_03_7917		; $78b8
+
	ld hl,$cbb3		; $78bb
	ld (hl),$3c		; $78be
	call reloadObjectGfx		; $78c0
	ld a,$07		; $78c3
	ld b,$01		; $78c5
	call seasonsFunc_03_7aa9		; $78c7
	call clearPaletteFadeVariablesAndRefreshPalettes		; $78ca
	jp incCutsceneState		; $78cd
cutscene08Func6:
	call decCbb3		; $78d0
	ret nz			; $78d3
	ld a,$01		; $78d4
	ld ($cc02),a		; $78d6
	ld bc,$1e04		; $78d9
	call showText		; $78dc
	jp incCutsceneState		; $78df
cutscene08Func7:
	call retIfTextIsActive		; $78e2
	call incCutsceneState		; $78e5
	ld hl,$cbb3		; $78e8
	ld (hl),$5a		; $78eb
	jp fadeoutToBlack		; $78ed
cutscene08Func8:
	ld a,(wPaletteThread_mode)		; $78f0
	or a			; $78f3
	ret nz			; $78f4
	call decCbb3		; $78f5
	ret nz			; $78f8
	xor a			; $78f9
	ld ($c2ee),a		; $78fa
	ld (wCutsceneIndex),a		; $78fd
	ld c,a			; $7900
	jpab bank1.loadDeathRespawnBufferPreset

seasonsFunc_03_7909:
	ld hl,$cbb4		; $7909
	inc (hl)		; $790c
	ld a,(hl)		; $790d
	sub $07			; $790e
	ret nz			; $7910
	ld (hl),a		; $7911
	ld hl,$cbb6		; $7912
	inc (hl)		; $7915
	ret			; $7916

seasonsFunc_03_7917:
	ld ($cbbb),a		; $7917
	ld hl,$cbb3		; $791a
	ld (hl),$5a		; $791d
	call disableLcd		; $791f
	ld a,($cbbb)		; $7922
	cp $03			; $7925
	jr c,++	; $7927
	sub $03			; $7929
	ld hl,seasonsTable_03_797b		; $792b
	rst_addDoubleIndex			; $792e
	ld b,$00		; $792f
	ldi a,(hl)		; $7931
	ld c,(hl)		; $7932
	call func_36f6		; $7933
	ld b,$31		; $7936
	ld a,($cbbb)		; $7938
	cp $05			; $793b
	jr nz,+	; $793d
	ld b,UNCMP_GFXH_0f		; $793f
+
	ld a,b			; $7941
	call loadUncompressedGfxHeader		; $7942
	ld a,($cbbb)		; $7945
++
	add $25			; $7948
	call loadGfxHeader		; $794a
	ld a,($cbbb)		; $794d
	ld hl,seasonsTable_03_7972		; $7950
	rst_addAToHl			; $7953
	ld a,(hl)		; $7954
	call loadPaletteHeader		; $7955
	ld a,PALH_0f		; $7958
	call loadPaletteHeader		; $795a
	ld a,$04		; $795d
	call loadGfxRegisterStateIndex		; $795f
	ld a,($cbbb)		; $7962
	sub $03			; $7965
	ret c			; $7967
	ld hl,seasonsTable_03_7978		; $7968
	rst_addAToHl			; $796b
	ld a,(hl)		; $796c
	ld de,$cbb9		; $796d
	ld (de),a		; $7970
	ret			; $7971

seasonsTable_03_7972:
	.db $5f $5f $5f $11 $13 $12

seasonsTable_03_7978:
	.db $02 $03 $01

seasonsTable_03_797b:
	.db $01 $b8 $02 $c6 $02 $c8

seasonsFunc_03_7981:
	call seasonsFunc_03_79bb		; $7981
	ld hl,wFrameCounter		; $7984
	ld a,(hl)		; $7987
	and $0f			; $7988
	ld a,SND_RUMBLE2		; $798a
	call z,playSound		; $798c
	ld de,$cbb5		; $798f
	ld a,(de)		; $7992
	cp $02			; $7993
	jr z,+	; $7995
	ld hl,$cbb4		; $7997
	dec (hl)		; $799a
	jr nz,+	; $799b
	inc a			; $799d
	ld (de),a		; $799e
	call seasonsFunc_03_79db		; $799f
+
	add a			; $79a2
	add a			; $79a3
	ld hl,seasonsTable_03_79e9		; $79a4
	rst_addDoubleIndex			; $79a7
	ld b,$00		; $79a8
	call seasonsFunc_03_79af		; $79aa
	ld b,$01		; $79ad

seasonsFunc_03_79af:
	ld de,wGfxRegs1.SCY		; $79af
	dec b			; $79b2
	jr nz,+	; $79b3
	ld de,$c488		; $79b5
+
	jp seasonsFunc_03_79cd		; $79b8

seasonsFunc_03_79bb:
	ld hl,wGfxRegs1.SCY		; $79bb
	ldh a,(<hCameraY)	; $79be
	ldi (hl),a		; $79c0
	ldh a,(<hCameraX)	; $79c1
	ldi (hl),a		; $79c3
	ld de,$cbb6		; $79c4
	ld a,(de)		; $79c7
	ldi (hl),a		; $79c8
	inc de			; $79c9
	ld a,(de)		; $79ca
	ldi (hl),a		; $79cb
	ret			; $79cc

seasonsFunc_03_79cd:
	push hl			; $79cd
	call getRandomNumber		; $79ce
	and $07			; $79d1
	rst_addAToHl			; $79d3
	ld a,(hl)		; $79d4
	ld b,a			; $79d5
	ld a,(de)		; $79d6
	add b			; $79d7
	ld (de),a		; $79d8
	pop hl			; $79d9
	ret			; $79da

seasonsFunc_03_79db:
	ld b,a			; $79db
	ld hl,seasonsTable_03_79e7		; $79dc
	rst_addAToHl			; $79df
	ld a,(hl)		; $79e0
	ld hl,$cbb4		; $79e1
	ld (hl),a		; $79e4
	ld a,b			; $79e5
	ret			; $79e6

seasonsTable_03_79e7:
	.db $1e $14

seasonsTable_03_79e9:
	.db $00 $00 $00 $00 $00 $01 $00 $00
	.db $00 $00 $01 $00 $00 $00 $ff $00
	.db $ff $01 $00 $01 $00 $00 $ff $00

seasonsFunc_03_7a01:
	ld hl,$cbd5		; $7a01
	ld de,$c485		; $7a04
	ld b,$0c		; $7a07
-
	ld a,(de)		; $7a09
	ldi (hl),a		; $7a0a
	inc e			; $7a0b
	dec b			; $7a0c
	jr nz,-	; $7a0d
	call clearOam		; $7a0f
	ld a,$10		; $7a12
	ldh (<hOamTail),a	; $7a14
	ret			; $7a16

seasonsFunc_03_7a17:
	ld hl,$cbd5		; $7a17
	ld de,$c485		; $7a1a
	ld b,$0c		; $7a1d
-
	ldi a,(hl)		; $7a1f
	ld (de),a		; $7a20
	inc e			; $7a21
	dec b			; $7a22
	jr nz,-	; $7a23
	ld a,($c485)		; $7a25
	ld ($c497),a		; $7a28
	ld ($ff00+R_LCDC),a	; $7a2b
	ret			; $7a2d

seasonsFunc_03_7a2e:
	ld hl,$cbba		; $7a2e
	dec (hl)		; $7a31
	ret nz			; $7a32
	ld (hl),$02		; $7a33
	ld hl,$cbb8		; $7a35
	dec (hl)		; $7a38
	jr nz,+	; $7a39

seasonsFunc_03_7a3b:
	ld (hl),$1f		; $7a3b
	ld hl,$cbb9		; $7a3d
	inc (hl)		; $7a40
	ld a,(hl)		; $7a41
	and $03			; $7a42
	ld (hl),a		; $7a44
	ld hl,seasonsTable_03_7a5e		; $7a45
	rst_addDoubleIndex			; $7a48
	ldi a,(hl)		; $7a49
	ld h,(hl)		; $7a4a
	ld l,a			; $7a4b
	ld b,h			; $7a4c
	ld c,l			; $7a4d
	ld hl,$de90		; $7a4e
	call func_13c6		; $7a51
	xor a			; $7a54
	ld (wPaletteThread_mode),a		; $7a55
	ld hl,$cbb8		; $7a58
+
	jp func_35ec		; $7a5b

seasonsTable_03_7a5e:
	.db $b0 $49
	.db $10 $4a
	.db $e0 $49
	.db $40 $4a
	
incCutsceneState:
	ld hl,wCutsceneState		; $7a66
	inc (hl)		; $7a69
	ret			; $7a6a

seasonsFunc_03_7a6b:
	ldh (<hFF8B),a	; $7a6b
	ld a,$01		; $7a6d
	ld ($ff00+R_VBK),a	; $7a6f
	ld hl,$9800		; $7a71
	ld bc,$0400		; $7a74
	ldh a,(<hFF8B)	; $7a77
	call fillMemoryBc		; $7a79
	xor a			; $7a7c
	ld ($ff00+R_VBK),a	; $7a7d
	ld hl,$9800		; $7a7f
	ld bc,$0400		; $7a82
	jp clearMemoryBc		; $7a85

seasonsFunc_03_7a88:
	ldh (<hFF8B),a	; $7a88
	ld a,($ff00+R_SVBK)	; $7a8a
	push af			; $7a8c
	ld a,$04		; $7a8d
	ld ($ff00+R_SVBK),a	; $7a8f
	ld hl,$d000		; $7a91
	ld bc,$0240		; $7a94
	call clearMemoryBc		; $7a97
	ld hl,$d400		; $7a9a
	ld bc,$0240		; $7a9d
	ldh a,(<hFF8B)	; $7aa0
	call fillMemoryBc		; $7aa2
	pop af			; $7aa5
	ld ($ff00+R_SVBK),a	; $7aa6
	ret			; $7aa8

seasonsFunc_03_7aa9:
	ld d,a			; $7aa9
	ld a,b			; $7aaa
	ld e,a			; $7aab
	call disableLcd		; $7aac
	push de			; $7aaf
	ld a,GFXH_2f		; $7ab0
	call loadGfxHeader		; $7ab2
	ld a,PALH_0f		; $7ab5
	call loadPaletteHeader		; $7ab7
	ld a,SEASONS_PALH_3b		; $7aba
	call loadPaletteHeader		; $7abc
	pop de			; $7abf
	call getFreeInteractionSlot		; $7ac0
	jr nz,+			; $7ac3
	ld (hl),INTERACID_88		; $7ac5
	inc l			; $7ac7
	ld (hl),e		; $7ac8
+
	ld a,d			; $7ac9
	call loadGfxRegisterStateIndex		; $7aca
	ld hl,wGfxRegs1.SCY		; $7acd
	ldi a,(hl)		; $7ad0
	ldh (<hCameraY),a	; $7ad1
	ld a,(hl)		; $7ad3
	ldh (<hCameraX),a	; $7ad4
	ret			; $7ad6

cutscenePregameIntro:
	call cutscenePregameIntroHandler		; $7ad7
	jp updateAllObjects		; $7ada

cutscenePregameIntroHandler:
	ld de,wCutsceneState		; $7add
	ld a,(de)		; $7ae0
	rst_jumpTable			; $7ae1
	.dw cutscene0dFunc0
	.dw cutscene0dFunc1
	.dw cutscene0dFunc2
	.dw cutscene0dFunc3
	.dw cutscene0dFunc4
	.dw cutscene0dFunc5
	.dw cutscene0dFunc6
	.dw cutscene0dFunc7
	.dw cutscene0dFunc8
	.dw cutscene0dFunc9

	.dw cutscene0dFunca
	.dw cutscene0dFuncb
	.dw cutscene0dFuncc

cutscene0dFunc0:
	ld a,(wPaletteThread_mode)		; $7afc
	or a			; $7aff
	ret nz			; $7b00
	call checkIsLinkedGame		; $7b01
	jr nz,+	; $7b04
	ld a,$0a		; $7b06
	ld (de),a		; $7b08
	jp cutscene0dFunca		; $7b09
+
	ld a,$01		; $7b0c
	ld (de),a		; $7b0e
	; Room of Rites
	ld bc,ROOM_SEASONS_59a		; $7b0f
	call disableLcdAndLoadRoom_body		; $7b12
	ld a,SEASONS_PALH_ac		; $7b15
	call loadPaletteHeader		; $7b17
	ld b,$03		; $7b1a
-
	call getFreeInteractionSlot		; $7b1c
	jr nz,+	; $7b1f
	ld (hl),INTERACID_TWINROVA_FLAME		; $7b21
	inc l			; $7b23
	ld (hl),b		; $7b24
	dec b			; $7b25
	jr nz,-	; $7b26
+
	ld a,MUS_FINAL_DUNGEON		; $7b28
	call playSound		; $7b2a
	ld hl,$cbb3		; $7b2d
	ld (hl),$3c		; $7b30
	ld a,$13		; $7b32
	call loadGfxRegisterStateIndex		; $7b34
	ld a,($c48d)		; $7b37
	ldh (<hCameraX),a	; $7b3a
	xor a			; $7b3c
	ldh (<hCameraY),a	; $7b3d
	ld a,$00		; $7b3f
	ld (wScrollMode),a		; $7b41
	jp _clearFadingPalettes		; $7b44
cutscene0dFunc1:
	ld e,$96		; $7b47
-
	call decCbb3		; $7b49
	ret nz			; $7b4c
	call incCutsceneState		; $7b4d
	ld hl,$cbb3		; $7b50
	ld (hl),e		; $7b53
	ld a,SND_CREEPY_LAUGH		; $7b54
	jp playSound		; $7b56
cutscene0dFunc2:
	ld e,$3c		; $7b59
	jr -		; $7b5b
cutscene0dFunc3:
	call decCbb3		; $7b5d
	ret nz			; $7b60
	call incCutsceneState		; $7b61
	call fastFadeinFromBlack		; $7b64
	ld a,$10		; $7b67
	ld ($c4b2),a		; $7b69
	ld ($c4b4),a		; $7b6c
	ld a,$03		; $7b6f
	ld ($c4b1),a		; $7b71
	ld ($c4b3),a		; $7b74
	ld a,SND_LIGHTTORCH		; $7b77
	jp playSound		; $7b79
cutscene0dFunc4:
	ld a,(wPaletteThread_mode)		; $7b7c
	or a			; $7b7f
	ret nz			; $7b80
	call incCutsceneState		; $7b81
	ld a,$0e		; $7b84
	ld ($cbb3),a		; $7b86
	call fadeinFromBlack		; $7b89
	ld a,$ef		; $7b8c
	ld ($c4b2),a		; $7b8e
	ld ($c4b4),a		; $7b91
	ld a,$fc		; $7b94
	ld ($c4b1),a		; $7b96
	ld ($c4b3),a		; $7b99
	ret			; $7b9c
cutscene0dFunc5:
	call decCbb3		; $7b9d
	ret nz			; $7ba0
	xor a			; $7ba1
	ld (wPaletteThread_mode),a		; $7ba2
	ld a,$78		; $7ba5
	ld ($cbb3),a		; $7ba7
	jp incCutsceneState		; $7baa
cutscene0dFunc6:
	call decCbb3		; $7bad
	ret nz			; $7bb0
	call incCutsceneState		; $7bb1
	ld a,$08		; $7bb4
	ld ($cbae),a		; $7bb6
	ld a,$03		; $7bb9
	ld ($cbac),a		; $7bbb
	ld bc,$0c15		; $7bbe
	jp showText		; $7bc1
cutscene0dFunc7:
	call retIfTextIsActive		; $7bc4
	call incCutsceneState		; $7bc7
	ld ($cbb3),a		; $7bca
	dec a			; $7bcd
	ld ($cbba),a		; $7bce
	call restartSound		; $7bd1
	ld a,SND_BIG_EXPLOSION_2		; $7bd4
	jp playSound		; $7bd6
cutscene0dFunc8:
	ld hl,$cbb3		; $7bd9
	ld b,$03		; $7bdc
	call flashScreen		; $7bde
	ret z			; $7be1
	call incCutsceneState		; $7be2
	ld a,$3c		; $7be5
	ld ($cbb3),a		; $7be7
	ld a,$02		; $7bea
	jp fadeoutToWhiteWithDelay		; $7bec
cutscene0dFunc9:
	ld a,(wPaletteThread_mode)		; $7bef
	or a			; $7bf2
	ret nz			; $7bf3
	call decCbb3		; $7bf4
	ret nz			; $7bf7
	jp incCutsceneState		; $7bf8

cutsceneOnoxTaunting:
	call cutsceneOnoxTauntingHandler		; $7bfb
	jp updateInteractionsAndDrawAllSprites		; $7bfe

cutsceneOnoxTauntingHandler:
	ld de,wCutsceneState		; $7c01
	ld a,(de)		; $7c04
	rst_jumpTable			; $7c05
	.dw cutscene0eFunc0
	.dw cutscene0eFunc1
	.dw cutscene0eFunc2
	.dw cutscene0eFunc3
	.dw cutscene0eFunc4
	.dw cutscene0eFunc5
	.dw cutscene0eFunc6
	.dw cutscene0eFunc7
cutscene0eFunc0:
	ld a,(wPaletteThread_mode)		; $7c16
	or a			; $7c19
	ret nz			; $7c1a
	call hideStatusBar		; $7c1b
	call clearDynamicInteractions		; $7c1e
	ld a,SNDCTRL_FAST_FADEOUT		; $7c21
	call playSound		; $7c23
	ld hl,$cbb3		; $7c26
	ld (hl),$3c		; $7c29
	ld hl,$d01a		; $7c2b
	res 7,(hl)		; $7c2e
	xor a			; $7c30
	ld ($cfc0),a		; $7c31
	jp incCutsceneState		; $7c34
cutscene0eFunc1:
	call decCbb3		; $7c37
	ret nz			; $7c3a
	ld (hl),$14		; $7c3b
	call incCutsceneState		; $7c3d
	ld hl,$cbae		; $7c40
	ld (hl),$04		; $7c43
	ld bc,$1719		; $7c45
	jp showText		; $7c48
cutscene0eFunc2:
	call retIfTextIsActive		; $7c4b
	call decCbb3		; $7c4e
	ret nz			; $7c51
	call disableLcd		; $7c52
	call getFreeInteractionSlot		; $7c55
	jr nz,+	; $7c58
	ld a,INTERACID_S_DIN		; $7c5a
	ld ($cc1d),a		; $7c5c
	ldi (hl),a		; $7c5f
	ld (hl),$06		; $7c60
	call refreshObjectGfx		; $7c62
+
	xor a			; $7c65
	ld (wScreenOffsetY),a		; $7c66
	ld (wScreenOffsetX),a		; $7c69
	ld a,GFXH_2e		; $7c6c
	call loadGfxHeader		; $7c6e
	ld a,SEASONS_PALH_97		; $7c71
	call loadPaletteHeader		; $7c73
	ld a,$01		; $7c76
	ld (wScrollMode),a		; $7c78
	ld a,$18		; $7c7b
	ld (wTilesetAnimation),a		; $7c7d
	call loadAnimationData		; $7c80
	ld a,$0d		; $7c83
	call loadGfxRegisterStateIndex		; $7c85
	ld hl,wGfxRegs1.SCY		; $7c88
	ldi a,(hl)		; $7c8b
	ldh (<hCameraY),a	; $7c8c
	ld a,(hl)		; $7c8e
	ldh (<hCameraX),a	; $7c8f
	ld a,$18		; $7c91
	ld (wTilesetAnimation),a		; $7c93
	call loadAnimationData		; $7c96
	xor a			; $7c99
	ld ($cbb3),a		; $7c9a
	dec a			; $7c9d
	ld ($cbba),a		; $7c9e
	ld a,SND_LIGHTNING		; $7ca1
	call playSound		; $7ca3
	jp incCutsceneState		; $7ca6
cutscene0eFunc3:
	ld hl,$cbb3		; $7ca9
	ld b,$01		; $7cac
	call flashScreen		; $7cae
	ret z			; $7cb1
	xor a			; $7cb2
	ldh (<hFF8B),a	; $7cb3
	ld a,$f0		; $7cb5
	ld c,a			; $7cb7
	ld ($c4ae),a		; $7cb8
	call seasonsFunc_35cc		; $7cbb
	ld a,$ff		; $7cbe
	ldh (<hDirtyBgPalettes),a	; $7cc0
	ldh (<hDirtySprPalettes),a	; $7cc2
	ldh (<hBgPaletteSources),a	; $7cc4
	ldh (<hSprPaletteSources),a	; $7cc6
	ld hl,$cbb3		; $7cc8
	ld (hl),$3c		; $7ccb
	ld a,MUS_DISASTER		; $7ccd
	call playSound		; $7ccf
	jp incCutsceneState		; $7cd2
cutscene0eFunc4:
	call decCbb3		; $7cd5
	ret nz			; $7cd8
	ld (hl),$3c		; $7cd9
	call brightenRoom		; $7cdb
	ld a,$ff		; $7cde
	ld ($c4b2),a		; $7ce0
	ld ($c4b4),a		; $7ce3
	xor a			; $7ce6
	ld ($c4b1),a		; $7ce7
	ld ($c4b3),a		; $7cea
	jp incCutsceneState		; $7ced
cutscene0eFunc5:
	ld a,(wPaletteThread_mode)		; $7cf0
	or a			; $7cf3
	ret nz			; $7cf4
	call decCbb3		; $7cf5
	ret nz			; $7cf8
	ld (hl),$5a		; $7cf9
	ld a,$f0		; $7cfb
	ld ($c4ae),a		; $7cfd
	call brightenRoom		; $7d00
	ld a,$ff		; $7d03
	ld ($c4b1),a		; $7d05
	ld ($c4b3),a		; $7d08
	jp incCutsceneState		; $7d0b
cutscene0eFunc6:
	call decCbb3		; $7d0e
	ret nz			; $7d11
	call getFreeInteractionSlot		; $7d12
	jr nz,+	; $7d15
	ld (hl),INTERACID_DIN_IMPRISONED_EVENT		; $7d17
	inc l			; $7d19
	ld (hl),$05		; $7d1a
+
	jp incCutsceneState		; $7d1c
cutscene0eFunc7:
	ld a,($cfc0)		; $7d1f
	or a			; $7d22
	ret z			; $7d23
	call showStatusBar		; $7d24
	ld a,SNDCTRL_FAST_FADEOUT		; $7d27
	call playSound		; $7d29
	xor a			; $7d2c
	ld ($cc66),a		; $7d2d
	ld a,$82		; $7d30
	ld ($cc63),a		; $7d32
	ld a,$5d		; $7d35
	ld ($cc64),a		; $7d37
	xor a			; $7d3a
	ld ($cc65),a		; $7d3b
	ld a,$03		; $7d3e
	ld ($cc67),a		; $7d40
	ret			; $7d43

cutscene0dFunca:
	call disableLcd		; $7d44
	ld a,($ff00+R_SVBK)	; $7d47
	push af			; $7d49
	ld a,$02		; $7d4a
	ld ($ff00+R_SVBK),a	; $7d4c
	ld hl,$de80		; $7d4e
	ld b,$40		; $7d51
	call clearMemory		; $7d53
	pop af			; $7d56
	ld ($ff00+R_SVBK),a	; $7d57
	call clearScreenVariablesAndWramBank1		; $7d59
	call clearOam		; $7d5c
	ld a,PALH_0f		; $7d5f
	call loadPaletteHeader		; $7d61
	ld a,$02		; $7d64
	call seasonsFunc_03_7a6b		; $7d66
	call seasonsFunc_03_7db8		; $7d69
	ld a,MUS_ESSENCE_ROOM		; $7d6c
	call playSound		; $7d6e
	ld a,$08		; $7d71
	call setLinkID		; $7d73
	ld l,$00		; $7d76
	ld (hl),$01		; $7d78
	ld l,$02		; $7d7a
	ld (hl),$0a		; $7d7c
	ld a,$00		; $7d7e
	ld (wScrollMode),a		; $7d80
	call incCutsceneState		; $7d83
	call clearPaletteFadeVariablesAndRefreshPalettes		; $7d86
	xor a			; $7d89
	ldh (<hCameraY),a	; $7d8a
	ldh (<hCameraX),a	; $7d8c
	ld a,$15		; $7d8e
	jp loadGfxRegisterStateIndex		; $7d90
cutscene0dFuncb:
	ld a,($cbb9)		; $7d93
	cp $07			; $7d96
	ret nz			; $7d98
	call clearLinkObject		; $7d99
	ld hl,$cbb3		; $7d9c
	ld (hl),$3c		; $7d9f
	jp incCutsceneState		; $7da1
cutscene0dFuncc:
	call decCbb3		; $7da4
	ret nz			; $7da7
	ld hl,$c2ee		; $7da8
	xor a			; $7dab
	ldi (hl),a		; $7dac
	ld (hl),a		; $7dad
	ld a,SNDCTRL_STOPMUSIC		; $7dae
	call playSound		; $7db0
	ld a,GLOBALFLAG_3d		; $7db3
	jp setGlobalFlag		; $7db5

seasonsFunc_03_7db8:
	ld a,($ff00+R_SVBK)	; $7db8
	push af			; $7dba
	ld a,$03		; $7dbb
	ld ($ff00+R_SVBK),a	; $7dbd
	ld hl,$d800		; $7dbf
	ld bc,$0240		; $7dc2
	call clearMemoryBc		; $7dc5
	ld hl,$dc00		; $7dc8
	ld bc,$0240		; $7dcb
	ld a,$02		; $7dce
	call fillMemoryBc		; $7dd0
	pop af			; $7dd3
	ld ($ff00+R_SVBK),a	; $7dd4
	ret			; $7dd6