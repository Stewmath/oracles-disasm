;;
; Functionality relating to Onox fight from armored phases to dragon phase
; TODO: finish

seasonsFunc_0f_6f75:
	ld a,($cfc8)		; $6f75
	rst_jumpTable			; $6f78
	.dw @state1
	.dw @return
	.dw @state2
	.dw seasonsFunc_0f_70b4_swapGraphics@state3
	.dw seasonsFunc_0f_704d@state4
	.dw seasons_func_0f_712a@state5
	.dw seasons_func_0f_712a@state6
@state1:
	ld a,(wPaletteThread_mode)		; $6f87
	or a			; $6f8a
	ret nz			; $6f8b
	call clearWramBank1		; $6f8c
	xor a			; $6f8f
	call setScreenShakeCounter		; $6f90

	call getFreeEnemySlot_uncounted		; $6f93
	ld (hl),$02		; $6f96
	inc l			; $6f98
	ld (hl),$02		; $6f99

	call getFreePartSlot		; $6f9b
	ld (hl),$48		; $6f9e
	inc l			; $6fa0
	ld (hl),$04		; $6fa1

	ld hl,w1Link		; $6fa3
	ld (hl),$03		; $6fa6
	ld l,<w1Link.yh		; $6fa8
	ld (hl),$28		; $6faa
	ld l,<w1Link.xh		; $6fac
	ld (hl),$50		; $6fae

	ld a,$30		; $6fb0
	ldh (<hCameraY),a	; $6fb2
	xor a			; $6fb4
	ldh (<hCameraX),a	; $6fb5
	ld hl,wRoomCollisions		; $6fb7
	ld bc,wRoomCollisionsEnd-wRoomCollisions		; $6fba
	call clearMemoryBc		; $6fbd

	; clear part of wRoomCollisions
	ld hl,$cea0		; $6fc0
	ld b,$10		; $6fc3
	ld a,$0f		; $6fc5
	call fillMemory		; $6fc7

	; load data back into wRoomCollisions
	ld hl,$ce0a		; $6fca
	ld bc,$0b02		; $6fcd
-
	ld (hl),$0f		; $6fd0
	ld a,l			; $6fd2
	add $10			; $6fd3
	ld l,a			; $6fd5
	dec b			; $6fd6
	jr nz,-	; $6fd7
	ld hl,$ce0f		; $6fd9
	ld b,$0b		; $6fdc
	dec c			; $6fde
	jr nz,-	; $6fdf

	; clear all of wRoomLayout
	ld hl,wRoomLayout		; $6fe1
	ld bc,wRoomLayoutEnd-wRoomLayout		; $6fe4
	call clearMemoryBc		; $6fe7
	xor a			; $6fea
	ld ($cfca),a		; $6feb
	ld ($cfcb),a		; $6fee
	ld a,$80		; $6ff1
	ld ($cfce),a		; $6ff3
	ld (wLinkInAir),a		; $6ff6
	ld hl,$cfc8		; $6ff9
	inc (hl)		; $6ffc
	call disableLcd		; $6ffd
	call seasonsFunc_0f_70b4_swapGraphics		; $7000
	xor a			; $7003
	ld ($ff00+R_SVBK),a	; $7004
	call loadCommonGraphics		; $7006
	call fadeinFromWhite		; $7009
	ld a,$02		; $700c
	call loadGfxRegisterStateIndex		; $700e
	ld a,($cfce)		; $7011
	ld (wGfxRegs2.LYC),a		; $7014
	ld a,$06		; $7017
	ldh (<hNextLcdInterruptBehaviour),a	; $7019

	ld hl,wGfxRegs6.LCDC		; $701b
	ld (hl),$8f		; $701e
	; SCY
	inc l			; $7020
	ld (hl),$58		; $7021
	; SCX
	inc l			; $7023
	ld (hl),$00		; $7024
	; WINY & WINX
	inc l			; $7026
	ld a,$c7		; $7027
	ldi (hl),a		; $7029
	ldi (hl),a		; $702a
	; LYC
	ld (hl),$80		; $702b

@return:
	ret			; $702d

@state2:
	call clearEnemies		; $702e
	call getFreeEnemySlot		; $7031
	ld (hl),$05		; $7034
	ld hl,$cfca		; $7036
	call seasons_func_0f_712a		; $7039
	ld hl,$cfcb		; $703c
	res 7,(hl)		; $703f
	call seasons_func_0f_722f		; $7041
	xor a			; $7044
	ld ($ff00+R_SVBK),a	; $7045
	ld a,$03		; $7047
	ld ($cfc8),a		; $7049
	ret			; $704c

seasonsFunc_0f_704d:
	call seasonsFunc_0f_70b4_swapGraphics		; $704d
	ld hl,$cfca		; $7050
	call seasons_func_0f_712a		; $7053
--
	ld hl,$cfcb		; $7056
	res 7,(hl)		; $7059
	call seasons_func_0f_722f		; $705b
	xor a			; $705e
	ld ($ff00+$70),a	; $705f
	ld a,$02		; $7061
	call loadGfxRegisterStateIndex		; $7063
	ld a,($cfce)		; $7066
	ld ($c490),a		; $7069
	ld a,$06		; $706c
	ldh (<hNextLcdInterruptBehaviour),a	; $706e
	ret			; $7070

@state4:
	ld a,(wTextIsActive)		; $7071
	cp $80			; $7074
	ret nz			; $7076

	ld a,(wKeysJustPressed)		; $7077
	and BTN_A			; $707a
	ret z			; $707c

	call stopTextThread		; $707d
	ld a,$05		; $7080
	ld ($cfc8),a		; $7082
	call disableLcd		; $7085

	xor a			; $7088
	ld ($ff00+R_VBK),a	; $7089
	ld hl,$9800		; $708b
	ld bc,$0400		; $708e
	call clearMemoryBc		; $7091

	ld a,$01		; $7094
	ld ($ff00+R_VBK),a	; $7096
	ld hl,$9800		; $7098
	ld bc,$0400		; $709b
	ld a,$0d		; $709e
	call fillMemoryBc		; $70a0

	ld hl,$9f60		; $70a3
	ld b,$40		; $70a6
-
	ld a,(hl)		; $70a8
	or $80			; $70a9
	ldi (hl),a		; $70ab
	dec b			; $70ac
	jr nz,-	; $70ad
	call seasons_func_0f_71fb		; $70af
	jr --		; $70b2

seasonsFunc_0f_70b4_swapGraphics:
	ld a,SEASONS_PALH_8d		; $70b4
	call loadPaletteHeader		; $70b6
	xor a			; $70b9
	ld ($ff00+R_VBK),a	; $70ba
	ld hl,$9800		; $70bc
	ld bc,$0400		; $70bf
	call clearMemoryBc		; $70c2

	ld hl,$9f20		; $70c5
	ld b,$a0		; $70c8
	call clearMemory		; $70ca

	ld a,$01		; $70cd
	ld ($ff00+R_VBK),a	; $70cf
	ld hl,$9800		; $70d1
	ld bc,$0400		; $70d4
	ld a,$0d		; $70d7
	call fillMemoryBc		; $70d9

	ld hl,$9f20		; $70dc
	ld b,$a0		; $70df
	ld a,$0d		; $70e1
	call fillMemory		; $70e3

	ld a,$03		; $70e6
	ld ($ff00+R_SVBK),a	; $70e8
	ld hl,w3VramTiles		; $70ea
	ld bc,$02c0		; $70ed
	call clearMemoryBc		; $70f0

	ld hl,w3TileMappingIndices		; $70f3
	ld bc,$02c0		; $70f6
	ld a,$0d		; $70f9
	call fillMemoryBc		; $70fb

	ld a,GFXH_96		; $70fe
	call loadGfxHeader		; $7100
	ld a,UNCMP_GFXH_30		; $7103
	jp loadUncompressedGfxHeader		; $7105

@state3:
	ld hl,$cfc9		; $7108
	bit 7,(hl)		; $710b
	jr nz,+			; $710d
	ld l,$cb		; $710f
	bit 7,(hl)		; $7111
	ret z			; $7113
	res 7,(hl)		; $7114
	call seasons_func_0f_722f		; $7116
	xor a			; $7119
	ld ($ff00+R_SVBK),a	; $711a
	ret			; $711c
+
	ld b,(hl)		; $711d
	xor a			; $711e
	ldi (hl),a		; $711f
	res 7,b			; $7120
	ld (hl),b		; $7122
	call seasons_func_0f_712a		; $7123
	xor a			; $7126
	ld ($ff00+R_SVBK),a	; $7127
	ret			; $7129

;;
; @param	hl	$cfca/$cfc9 in @state3
; @addr{736a}
seasons_func_0f_712a:
	ld a,(hl)		; $712a
	cp $06			; $712b
	jp c,seasonsFunc_0f_71cf_copyw6Filler1IntoWramBank3		; $712d
	jp seasons_func_0f_71fb		; $7130

@state5:
	ld a,($cfcc)		; $7133
	cp $78			; $7136
	ret nz			; $7138
	ld a,$06		; $7139
	ld ($cfc8),a		; $713b
	; Onox phase 1 room flags
	ld hl,$ca91		; $713e
	set 7,(hl)		; $7141
	; game beaten / season always spring?
	ld a,GLOBALFLAG_S_30		; $7143
	call setGlobalFlag		; $7145
	jp fadeoutToWhite		; $7148

@state6:
	ld a,(wPaletteThread_mode)		; $714b
	or a			; $714e
	ret nz			; $714f
	call clearScreenVariablesAndWramBank1		; $7150
	ld a,CUTSCENE_S_DIN_CRYSTAL_DESCENDING		; $7153
	ld (wCutsceneTrigger),a		; $7155
	ret			; $7158

seasonsFunc_0f_7159:
	ld a,($cfcf)		; $7159
	or a			; $715c
	ret nz			; $715d
	ld hl,wScreenShakeCounterY		; $715e
	ld a,(hl)		; $7161
	or a			; $7162
	jr z,+	; $7163
	dec (hl)		; $7165
+
	inc l			; $7166
	ld a,(hl)		; $7167
	or a			; $7168
	jr z,+	; $7169
	dec (hl)		; $716b
+
	ld hl,hCameraY		; $716c
	ld a,($d00b)		; $716f
	sub (hl)		; $7172
	cp $40			; $7173
	ret z			; $7175

	ld a,(hl)		; $7176
	jr c,+	; $7177
	cp $30			; $7179
	ret nc			; $717b
	inc (hl)		; $717c
	ret			; $717d
+
	or a			; $717e
	ret z			; $717f
	dec (hl)		; $7180
	ret			; $7181

seasonsFunc_0f_7182:
	ld hl,$cfcc		; $7182
	ldh a,(<hCameraY)	; $7185
	ld b,a			; $7187
	sub (hl)		; $7188
	ld ($c48c),a		; $7189
	inc l			; $718c
	xor a			; $718d
	sub (hl)		; $718e
	ld ($c48d),a		; $718f
	ld a,b			; $7192
	add $28			; $7193
	ld ($c4a0),a		; $7195
	xor a			; $7198
	ld ($c4a1),a		; $7199
	sub b			; $719c
	sub $50			; $719d
	cp $90			; $719f
	jr c,+	; $71a1
	ld a,$c7		; $71a3
+
	ld ($c490),a		; $71a5
	ld ($cfce),a		; $71a8
	ld a,($cd18)		; $71ab
	or a			; $71ae
	ret z			; $71af
	call getRandomNumber_noPreserveVars		; $71b0
	and $03			; $71b3
	ld hl,$71cb		; $71b5
	rst_addAToHl			; $71b8
	ld a,($c490)		; $71b9
	add (hl)		; $71bc
	cp $90			; $71bd
	ret nc			; $71bf
	ld ($c490),a		; $71c0
	ld a,($c4a0)		; $71c3
	sub (hl)		; $71c6
	ld ($c4a0),a		; $71c7
	ret			; $71ca
	rst $38			; $71cb
	cp $01			; $71cc
	ld (bc),a		; $71ce

;;
; @param	a	$cfca value 0 to 5
; @addr{$71cf}
seasonsFunc_0f_71cf_copyw6Filler1IntoWramBank3:
	call load5aIntoBc		; $71cf
	push bc			; $71d2
	ld hl,$d000		; $71d3
	add hl,bc		; $71d6
	ld b,$50		; $71d7
	call seasonsFunc_0f_7297_copyw6Filler1IntowTmpVramBuffer		; $71d9
	ld hl,$d802		; $71dc
	ld c,$00		; $71df
	call seasonsFunc_0f_72a5_copyFromwTmpVramBufferIntoBank3		; $71e1
	pop bc			; $71e4

	ld hl,$d400		; $71e5
	add hl,bc		; $71e8
	ld b,$50		; $71e9
	call seasonsFunc_0f_7297_copyw6Filler1IntowTmpVramBuffer		; $71eb
	ld hl,$dc02		; $71ee
	ld c,$20		; $71f1
	call seasonsFunc_0f_72a5_copyFromwTmpVramBufferIntoBank3		; $71f3
	ld a,UNCMP_GFXH_2e		; $71f6
	jp loadUncompressedGfxHeader		; $71f8

seasons_func_0f_71fb:
	ld a,($cfca)		; $71fb
	sub $06			; $71fe
	cp $03			; $7200
	jr c,+	; $7202
	ld a,$02		; $7204
+
	add a			; $7206
	call load5aIntoBc		; $7207
	push bc			; $720a
	ld hl,$d1e0		; $720b
	add hl,bc		; $720e
	ld b,$a0		; $720f
	call seasonsFunc_0f_7297_copyw6Filler1IntowTmpVramBuffer		; $7211
	ld hl,$d802		; $7214
	call seasons_func_0f_72d1		; $7217
	pop bc			; $721a
	ld hl,$d5e0		; $721b
	add hl,bc		; $721e
	ld b,$a0		; $721f
	call seasonsFunc_0f_7297_copyw6Filler1IntowTmpVramBuffer		; $7221
	ld hl,$dc02		; $7224
	call seasons_func_0f_72dc		; $7227
	ld a,UNCMP_GFXH_2e		; $722a
	jp loadUncompressedGfxHeader		; $722c

seasons_func_0f_722f:
	ld a,$03		; $722f
	ld ($ff00+$70),a	; $7231
	ld hl,$d940		; $7233
	ld b,$e0		; $7236
	call clearMemory		; $7238
	ld hl,$dd40		; $723b
	ld b,$e0		; $723e
	ld a,$0d		; $7240
	call fillMemory		; $7242
	ld a,($cfcb)		; $7245
	cp $03			; $7248
	jr c,+	; $724a
	sub $03			; $724c
+
	add a			; $724e
	add a			; $724f
	swap a			; $7250
	ld b,a			; $7252
	and $f0			; $7253
	ld c,a			; $7255
	ld a,b			; $7256
	and $0f			; $7257
	ld b,a			; $7259
	push bc			; $725a
	ld a,($cfcb)		; $725b
	ld hl,$7291		; $725e
	rst_addAToHl			; $7261
	ld a,(hl)		; $7262
	ldh (<hFF8B),a	; $7263
	ld hl,$d800		; $7265
	add hl,bc		; $7268
	ld b,$40		; $7269
	call seasonsFunc_0f_7297_copyw6Filler1IntowTmpVramBuffer		; $726b
	ldh a,(<hFF8B)	; $726e
	add $40			; $7270
	ld l,a			; $7272
	ld h,$d9		; $7273
	call seasons_func_0f_731a		; $7275
	pop bc			; $7278
	ld hl,$db00		; $7279
	add hl,bc		; $727c
	ld b,$40		; $727d
	call seasonsFunc_0f_7297_copyw6Filler1IntowTmpVramBuffer		; $727f
	ldh a,(<hFF8B)	; $7282
	add $40			; $7284
	ld l,a			; $7286
	ld h,$dd		; $7287
	call seasons_func_0f_7325		; $7289
	ld a,UNCMP_GFXH_2f		; $728c
	jp loadUncompressedGfxHeader		; $728e
	.db $07 $05 $04 $05 $07 $08
	
;;
; @param	b	number of bytes to copy
; @param	hl	a few values between $d000-$db00 in bank 6 (w6Filler1, etc)
; @addr{7297}
seasonsFunc_0f_7297_copyw6Filler1IntowTmpVramBuffer:
        ld a,$06		; $7297
	ld ($ff00+R_SVBK),a	; $7299
	ld de,wTmpVramBuffer		; $729b
-
	ldi a,(hl)		; $729e
	ld (de),a		; $729f
	inc e			; $72a0
	dec b			; $72a1
	jr nz,-	; $72a2
	ret			; $72a4

;;
; @param	c	$00 for w3VramTiles/$20 for w3TileMappingIndices
; @param	hl	$d802(w3VramTiles)/$dc02(w3TileMappingIndices) in bank 3
; @addr{72a5}
seasonsFunc_0f_72a5_copyFromwTmpVramBufferIntoBank3:
	ld a,$03		; $72a5
	ld ($ff00+R_SVBK),a	; $72a7
	ld de,wTmpVramBuffer		; $72a9
---
	ld b,$04		; $72ac
-
	ld a,(de)		; $72ae
	ldi (hl),a		; $72af
	inc e			; $72b0
	ld a,(de)		; $72b1
	ldi (hl),a		; $72b2
	inc e			; $72b3
	dec b			; $72b4
	jr nz,-	; $72b5

	ld b,$04		; $72b7
-
	dec e			; $72b9
	ld a,(de)		; $72ba
	xor c			; $72bb
	ldi (hl),a		; $72bc
	dec e			; $72bd
	ld a,(de)		; $72be
	xor c			; $72bf
	ldi (hl),a		; $72c0
	dec b			; $72c1
	jr nz,-	; $72c2

	; e is $40
	ld a,e			; $72c4
	add $08			; $72c5
	ld e,a			; $72c7
	ld a,$10		; $72c8
	rst_addAToHl		; $72ca
	ld a,e			; $72cb
	cp $90			; $72cc
	jr nz,---		; $72ce
	ret			; $72d0

seasons_func_0f_72d1:
	ld a,($cfca)		; $72d1
	cp $09			; $72d4
	jr c,++			; $72d6
	ld c,$00		; $72d8
	jr +			; $72da

seasons_func_0f_72dc:
	ld a,($cfca)		; $72dc
	cp $09			; $72df
	jr c,++	; $72e1
	ld c,$20		; $72e3
+
	ld a,$03		; $72e5
	ld ($ff00+$70),a	; $72e7
	ld de,$cd4f		; $72e9
--
	ld b,$10		; $72ec
-
	ld a,(de)		; $72ee
	xor c			; $72ef
	ldi (hl),a		; $72f0
	dec e			; $72f1
	dec b			; $72f2
	jr nz,-	; $72f3
	ld a,e			; $72f5
	add $20			; $72f6
	ld e,a			; $72f8
	ld a,$10		; $72f9
	rst_addAToHl			; $72fb
	ld a,e			; $72fc
	cp $ef			; $72fd
	jr nz,--	; $72ff
	ret			; $7301
++
	ld a,$03		; $7302
	ld ($ff00+R_SVBK),a	; $7304
	ld de,wTmpVramBuffer		; $7306
	ld c,$0a		; $7309
--
	ld b,$10		; $730b
-
	ld a,(de)		; $730d
	ldi (hl),a		; $730e
	inc e			; $730f
	dec b			; $7310
	jr nz,-	; $7311
	ld a,$10		; $7313
	rst_addAToHl			; $7315
	dec c			; $7316
	jr nz,--	; $7317
	ret			; $7319

seasons_func_0f_731a:
	ld a,($cfcb)		; $731a
	cp $03			; $731d
	jr c,++	; $731f
	ld c,$00		; $7321
	jr +		; $7323

seasons_func_0f_7325:
	ld a,($cfcb)		; $7325
	cp $03			; $7328
	jr c,++	; $732a
	ld c,$20		; $732c
+
	ld a,$03		; $732e
	ld ($ff00+R_SVBK),a	; $7330
	ld de,$cd47		; $7332
--
	ld b,$04		; $7335
-
	ld a,(de)		; $7337
	xor c			; $7338
	ldi (hl),a		; $7339
	dec e			; $733a
	ld a,(de)		; $733b
	xor c			; $733c
	ldi (hl),a		; $733d
	dec e			; $733e
	dec b			; $733f
	jr nz,-	; $7340
	ld a,e			; $7342
	add $10			; $7343
	ld e,a			; $7345
	ld a,$18		; $7346
	rst_addAToHl			; $7348
	ld a,e			; $7349
	cp $7f			; $734a
	jr nz,--	; $734c
	ret			; $734e
++
	ld a,$03		; $734f
	ld ($ff00+R_SVBK),a	; $7351
	ld de,wTmpVramBuffer		; $7353
--
	ld b,$04		; $7356
-
	ld a,(de)		; $7358
	ldi (hl),a		; $7359
	inc e			; $735a
	ld a,(de)		; $735b
	ldi (hl),a		; $735c
	inc e			; $735d
	dec b			; $735e
	jr nz,-	; $735f
	ld a,$18		; $7361
	rst_addAToHl			; $7363
	ld a,e			; $7364
	cp $78			; $7365
	jr nz,--	; $7367
	ret			; $7369

;;
; @param	a	a value
; @param[out]	bc	5 * a
; @addr{736a}
load5aIntoBc:
	ld b,a			; $736a
	add a			; $736b
	add a			; $736c
	add b			; $736d
	swap a			; $736e
	ld b,a			; $7370
	and $f0			; $7371
	ld c,a			; $7373
	ld a,b			; $7374
	and $0f			; $7375
	ld b,a			; $7377
	ret			; $7378