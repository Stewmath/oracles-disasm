;;
; Functionality relating to Onox fight from armored phases to dragon phase
; TODO: finish

seasonsFunc_0f_6f75:
	ld a,($cfc8)
	rst_jumpTable
	.dw @state0
	.dw @return
	.dw @state2
	.dw seasonsFunc_0f_70b4_swapGraphics@state3
	.dw seasonsFunc_0f_704d@state4
	.dw seasons_func_0f_712a@state5
	.dw seasons_func_0f_712a@state6
@state0:
	ld a,(wPaletteThread_mode)
	or a
	ret nz
	call clearWramBank1
	xor a
	call setScreenShakeCounter

	call getFreeEnemySlot_uncounted
	ld (hl),ENEMYID_GENERAL_ONOX
	inc l
	ld (hl),$02

	call getFreePartSlot
	ld (hl),PARTID_48
	inc l
	ld (hl),$04

	ld hl,w1Link
	ld (hl),$03
	ld l,<w1Link.yh
	ld (hl),$28
	ld l,<w1Link.xh
	ld (hl),$50

	ld a,$30
	ldh (<hCameraY),a
	xor a
	ldh (<hCameraX),a
	ld hl,wRoomCollisions
	ld bc,wRoomCollisionsEnd-wRoomCollisions
	call clearMemoryBc

	; clear part of wRoomCollisions
	ld hl,$cea0
	ld b,$10
	ld a,$0f
	call fillMemory

	; load data back into wRoomCollisions
	ld hl,$ce0a
	ld bc,$0b02
-
	ld (hl),$0f
	ld a,l
	add $10
	ld l,a
	dec b
	jr nz,-
	ld hl,$ce0f
	ld b,$0b
	dec c
	jr nz,-

	; clear all of wRoomLayout
	ld hl,wRoomLayout
	ld bc,wRoomLayoutEnd-wRoomLayout
	call clearMemoryBc
	xor a
	ld ($cfca),a
	ld ($cfcb),a
	ld a,$80
	ld ($cfce),a
	ld (wLinkInAir),a
	ld hl,$cfc8
	inc (hl)
	call disableLcd
	call seasonsFunc_0f_70b4_swapGraphics
	xor a
	ld ($ff00+R_SVBK),a
	call loadCommonGraphics
	call fadeinFromWhite
	ld a,$02
	call loadGfxRegisterStateIndex
	ld a,($cfce)
	ld (wGfxRegs2.LYC),a
	ld a,$06
	ldh (<hNextLcdInterruptBehaviour),a

	ld hl,wGfxRegs6.LCDC
	ld (hl),$8f
	; SCY
	inc l
	ld (hl),$58
	; SCX
	inc l
	ld (hl),$00
	; WINY & WINX
	inc l
	ld a,$c7
	ldi (hl),a
	ldi (hl),a
	; LYC
	ld (hl),$80

@return:
	ret

@state2:
	call clearEnemies
	call getFreeEnemySlot
	ld (hl),ENEMYID_DRAGON_ONOX
	ld hl,$cfca
	call seasons_func_0f_712a
	ld hl,$cfcb
	res 7,(hl)
	call seasons_func_0f_722f
	xor a
	ld ($ff00+R_SVBK),a
	ld a,$03
	ld ($cfc8),a
	ret

seasonsFunc_0f_704d:
	call seasonsFunc_0f_70b4_swapGraphics
	ld hl,$cfca
	call seasons_func_0f_712a
--
	ld hl,$cfcb
	res 7,(hl)
	call seasons_func_0f_722f
	xor a
	ld ($ff00+$70),a
	ld a,$02
	call loadGfxRegisterStateIndex
	ld a,($cfce)
	ld ($c490),a
	ld a,$06
	ldh (<hNextLcdInterruptBehaviour),a
	ret

@state4:
	ld a,(wTextIsActive)
	cp $80
	ret nz

	ld a,(wKeysJustPressed)
	and BTN_A
	ret z

	call stopTextThread
	ld a,$05
	ld ($cfc8),a
	call disableLcd

	xor a
	ld ($ff00+R_VBK),a
	ld hl,$9800
	ld bc,$0400
	call clearMemoryBc

	ld a,$01
	ld ($ff00+R_VBK),a
	ld hl,$9800
	ld bc,$0400
	ld a,$0d
	call fillMemoryBc

	ld hl,$9f60
	ld b,$40
-
	ld a,(hl)
	or $80
	ldi (hl),a
	dec b
	jr nz,-
	call seasons_func_0f_71fb
	jr --

seasonsFunc_0f_70b4_swapGraphics:
	ld a,SEASONS_PALH_8d
	call loadPaletteHeader
	xor a
	ld ($ff00+R_VBK),a
	ld hl,$9800
	ld bc,$0400
	call clearMemoryBc

	ld hl,$9f20
	ld b,$a0
	call clearMemory

	ld a,$01
	ld ($ff00+R_VBK),a
	ld hl,$9800
	ld bc,$0400
	ld a,$0d
	call fillMemoryBc

	ld hl,$9f20
	ld b,$a0
	ld a,$0d
	call fillMemory

	ld a,$03
	ld ($ff00+R_SVBK),a
	ld hl,w3VramTiles
	ld bc,$02c0
	call clearMemoryBc

	ld hl,w3TileMappingIndices
	ld bc,$02c0
	ld a,$0d
	call fillMemoryBc

	ld a,GFXH_96
	call loadGfxHeader
	ld a,UNCMP_GFXH_30
	jp loadUncompressedGfxHeader

@state3:
	ld hl,$cfc9
	bit 7,(hl)
	jr nz,+
	ld l,$cb
	bit 7,(hl)
	ret z
	res 7,(hl)
	call seasons_func_0f_722f
	xor a
	ld ($ff00+R_SVBK),a
	ret
+
	ld b,(hl)
	xor a
	ldi (hl),a
	res 7,b
	ld (hl),b
	call seasons_func_0f_712a
	xor a
	ld ($ff00+R_SVBK),a
	ret

;;
; @param	hl	$cfca/$cfc9 in @state3
seasons_func_0f_712a:
	ld a,(hl)
	cp $06
	jp c,seasonsFunc_0f_71cf_copyw6Filler1IntoWramBank3
	jp seasons_func_0f_71fb

@state5:
	ld a,($cfcc)
	cp $78
	ret nz
	ld a,$06
	ld ($cfc8),a
	; Onox phase 1 room flags
	ld hl,$ca91
	set 7,(hl)
	; game beaten / season always spring?
	ld a,GLOBALFLAG_SEASON_ALWAYS_SPRING
	call setGlobalFlag
	jp fadeoutToWhite

@state6:
	ld a,(wPaletteThread_mode)
	or a
	ret nz
	call clearScreenVariablesAndWramBank1
	ld a,CUTSCENE_S_DIN_CRYSTAL_DESCENDING
	ld (wCutsceneTrigger),a
	ret

seasonsFunc_0f_7159:
	ld a,($cfcf)
	or a
	ret nz
	ld hl,wScreenShakeCounterY
	ld a,(hl)
	or a
	jr z,+
	dec (hl)
+
	inc l
	ld a,(hl)
	or a
	jr z,+
	dec (hl)
+
	ld hl,hCameraY
	ld a,($d00b)
	sub (hl)
	cp $40
	ret z

	ld a,(hl)
	jr c,+
	cp $30
	ret nc
	inc (hl)
	ret
+
	or a
	ret z
	dec (hl)
	ret

seasonsFunc_0f_7182:
	ld hl,$cfcc
	ldh a,(<hCameraY)
	ld b,a
	sub (hl)
	ld ($c48c),a
	inc l
	xor a
	sub (hl)
	ld ($c48d),a
	ld a,b
	add $28
	ld ($c4a0),a
	xor a
	ld ($c4a1),a
	sub b
	sub $50
	cp $90
	jr c,+
	ld a,$c7
+
	ld ($c490),a
	ld ($cfce),a
	ld a,($cd18)
	or a
	ret z
	call getRandomNumber_noPreserveVars
	and $03
	ld hl,table_71cb
	rst_addAToHl
	ld a,($c490)
	add (hl)
	cp $90
	ret nc
	ld ($c490),a
	ld a,($c4a0)
	sub (hl)
	ld ($c4a0),a
	ret
table_71cb:
	.db $ff $fe $01 $02

;;
; @param	a	$cfca value 0 to 5
seasonsFunc_0f_71cf_copyw6Filler1IntoWramBank3:
	call load5aIntoBc
	push bc
	ld hl,$d000
	add hl,bc
	ld b,$50
	call seasonsFunc_0f_7297_copyw6Filler1IntowTmpVramBuffer
	ld hl,$d802
	ld c,$00
	call seasonsFunc_0f_72a5_copyFromwTmpVramBufferIntoBank3
	pop bc

	ld hl,$d400
	add hl,bc
	ld b,$50
	call seasonsFunc_0f_7297_copyw6Filler1IntowTmpVramBuffer
	ld hl,$dc02
	ld c,$20
	call seasonsFunc_0f_72a5_copyFromwTmpVramBufferIntoBank3
	ld a,UNCMP_GFXH_2e
	jp loadUncompressedGfxHeader

seasons_func_0f_71fb:
	ld a,($cfca)
	sub $06
	cp $03
	jr c,+
	ld a,$02
+
	add a
	call load5aIntoBc
	push bc
	ld hl,$d1e0
	add hl,bc
	ld b,$a0
	call seasonsFunc_0f_7297_copyw6Filler1IntowTmpVramBuffer
	ld hl,$d802
	call seasons_func_0f_72d1
	pop bc
	ld hl,$d5e0
	add hl,bc
	ld b,$a0
	call seasonsFunc_0f_7297_copyw6Filler1IntowTmpVramBuffer
	ld hl,$dc02
	call seasons_func_0f_72dc
	ld a,UNCMP_GFXH_2e
	jp loadUncompressedGfxHeader

seasons_func_0f_722f:
	ld a,$03
	ld ($ff00+$70),a
	ld hl,$d940
	ld b,$e0
	call clearMemory
	ld hl,$dd40
	ld b,$e0
	ld a,$0d
	call fillMemory
	ld a,($cfcb)
	cp $03
	jr c,+
	sub $03
+
	add a
	add a
	swap a
	ld b,a
	and $f0
	ld c,a
	ld a,b
	and $0f
	ld b,a
	push bc
	ld a,($cfcb)
	ld hl,table_7291
	rst_addAToHl
	ld a,(hl)
	ldh (<hFF8B),a
	ld hl,$d800
	add hl,bc
	ld b,$40
	call seasonsFunc_0f_7297_copyw6Filler1IntowTmpVramBuffer
	ldh a,(<hFF8B)
	add $40
	ld l,a
	ld h,$d9
	call seasons_func_0f_731a
	pop bc
	ld hl,$db00
	add hl,bc
	ld b,$40
	call seasonsFunc_0f_7297_copyw6Filler1IntowTmpVramBuffer
	ldh a,(<hFF8B)
	add $40
	ld l,a
	ld h,$dd
	call seasons_func_0f_7325
	ld a,UNCMP_GFXH_2f
	jp loadUncompressedGfxHeader
table_7291:
	.db $07 $05 $04 $05 $07 $08
	
;;
; @param	b	number of bytes to copy
; @param	hl	a few values between $d000-$db00 in bank 6 (w6Filler1, etc)
seasonsFunc_0f_7297_copyw6Filler1IntowTmpVramBuffer:
	ld a,$06
	ld ($ff00+R_SVBK),a
	ld de,wTmpVramBuffer
-
	ldi a,(hl)
	ld (de),a
	inc e
	dec b
	jr nz,-
	ret

;;
; @param	c	$00 for w3VramTiles/$20 for w3TileMappingIndices
; @param	hl	$d802(w3VramTiles)/$dc02(w3TileMappingIndices) in bank 3
seasonsFunc_0f_72a5_copyFromwTmpVramBufferIntoBank3:
	ld a,$03
	ld ($ff00+R_SVBK),a
	ld de,wTmpVramBuffer
---
	ld b,$04
-
	ld a,(de)
	ldi (hl),a
	inc e
	ld a,(de)
	ldi (hl),a
	inc e
	dec b
	jr nz,-

	ld b,$04
-
	dec e
	ld a,(de)
	xor c
	ldi (hl),a
	dec e
	ld a,(de)
	xor c
	ldi (hl),a
	dec b
	jr nz,-

	; e is $40
	ld a,e
	add $08
	ld e,a
	ld a,$10
	rst_addAToHl
	ld a,e
	cp $90
	jr nz,---
	ret

seasons_func_0f_72d1:
	ld a,($cfca)
	cp $09
	jr c,++
	ld c,$00
	jr +

seasons_func_0f_72dc:
	ld a,($cfca)
	cp $09
	jr c,++
	ld c,$20
+
	ld a,$03
	ld ($ff00+$70),a
	ld de,$cd4f
--
	ld b,$10
-
	ld a,(de)
	xor c
	ldi (hl),a
	dec e
	dec b
	jr nz,-
	ld a,e
	add $20
	ld e,a
	ld a,$10
	rst_addAToHl
	ld a,e
	cp $ef
	jr nz,--
	ret
++
	ld a,$03
	ld ($ff00+R_SVBK),a
	ld de,wTmpVramBuffer
	ld c,$0a
--
	ld b,$10
-
	ld a,(de)
	ldi (hl),a
	inc e
	dec b
	jr nz,-
	ld a,$10
	rst_addAToHl
	dec c
	jr nz,--
	ret

seasons_func_0f_731a:
	ld a,($cfcb)
	cp $03
	jr c,++
	ld c,$00
	jr +

seasons_func_0f_7325:
	ld a,($cfcb)
	cp $03
	jr c,++
	ld c,$20
+
	ld a,$03
	ld ($ff00+R_SVBK),a
	ld de,$cd47
--
	ld b,$04
-
	ld a,(de)
	xor c
	ldi (hl),a
	dec e
	ld a,(de)
	xor c
	ldi (hl),a
	dec e
	dec b
	jr nz,-
	ld a,e
	add $10
	ld e,a
	ld a,$18
	rst_addAToHl
	ld a,e
	cp $7f
	jr nz,--
	ret
++
	ld a,$03
	ld ($ff00+R_SVBK),a
	ld de,wTmpVramBuffer
--
	ld b,$04
-
	ld a,(de)
	ldi (hl),a
	inc e
	ld a,(de)
	ldi (hl),a
	inc e
	dec b
	jr nz,-
	ld a,$18
	rst_addAToHl
	ld a,e
	cp $78
	jr nz,--
	ret

;;
; @param	a	a value
; @param[out]	bc	5 * a
load5aIntoBc:
	ld b,a
	add a
	add a
	add b
	swap a
	ld b,a
	and $f0
	ld c,a
	ld a,b
	and $0f
	ld b,a
	ret
