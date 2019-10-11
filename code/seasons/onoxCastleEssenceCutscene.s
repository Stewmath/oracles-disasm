;;
; CUTSCENE_S_ONOX_CASTLE_FORCE
cutscene14:
	call @handleCutscene
	jp updateAllObjects

;;
@handleCutscene:
	ld a,(wCutsceneState)		; $6140
	rst_jumpTable			; $6143
	.dw @state0
	.dw @state1
	.dw @state2

@state0:
	call reloadTileMap		; $614a
	ld a,TREASURE_MAKU_SEED		; $614d
	call checkTreasureObtained		; $614f
	ld a,$01		; $6152
	jr nc,+			; $6154
	inc a			; $6156
+
	ld (wCutsceneState),a		; $6157
	xor a			; $615a
	ld (wTmpcbb3),a		; $615b
	ld (wScrollMode),a		; $615e
	ld a,$28		; $6161
	ld (wTmpcbb4),a		; $6163
	ret			; $6166

;;
@decCounter:
	ld hl,wTmpcbb4		; $6167
	dec (hl)		; $616a
	ret nz			; $616b
	ld (hl),$1e		; $616c
	ret			; $616e

;;
@incSubstate:
	ld hl,wTmpcbb3		; $616f
	inc (hl)		; $6172
	ret			; $6173

;;
@seasonsFunc_6174:
	ld a,(wLinkObjectIndex)		; $6174
	ld h,a			; $6177
	ld l,SpecialObject.yh		; $6178
	ld b,(hl)		; $617a
	ld l,SpecialObject.xh		; $617b
	ld c,(hl)		; $617d
	ret			; $617e

@state1:
	ld a,(wTmpcbb3)		; $617f
	rst_jumpTable			; $6182
	.dw @@substate0
	.dw @@substate1
	.dw @@substate2
	.dw @@substate3

@@substate0:
	call @incSubstate		; $618b
	ld a,$10		; $618e
	ld (wGfxRegs2.LYC),a		; $6190
	ld a,$02		; $6193
	ldh (<hNextLcdInterruptBehaviour),a	; $6195
	xor a			; $6197
	ld (wTmpcbb7),a		; $6198
	call @initWaveScrollValues_everyOtherLine		; $619b
	ld a,LINK_STATE_10		; $619e
	ld (wLinkForceState),a		; $61a0
	ld a,SND_ENDLESS		; $61a3
	jp playSound		; $61a5

@@substate1:
	ld a,$02		; $61a8
	call loadBigBufferScrollValues		; $61aa
	ld hl,wTmpcbb7		; $61ad
	inc (hl)		; $61b0
	ld a,(hl)		; $61b1
	jp nz,@initWaveScrollValues_everyOtherLine		; $61b2
	jr @incSubstate		; $61b5

@@substate2:
	ld a,$02		; $61b7
	jp loadBigBufferScrollValues		; $61b9

@@substate3:
	ld a,$02		; $61bc
	call loadBigBufferScrollValues		; $61be
	ld a,(wPaletteThread_mode)		; $61c1
	or a			; $61c4
	ret nz			; $61c5

	ld a,(w1Link.xh)		; $61c6
	and $f0			; $61c9
	swap a			; $61cb
	or $10			; $61cd
	ld (wWarpDestPos),a		; $61cf
	ld a,$80		; $61d2
	ld (wWarpDestGroup),a		; $61d4
	ld a,$33		; $61d7
	ld (wWarpDestIndex),a		; $61d9
	ld a,$0c		; $61dc
	ld (wWarpTransition),a		; $61de
	xor a			; $61e1
	ld (wcc50),a		; $61e2

	ld a,CUTSCENE_S_03		; $61e5
	ld (wCutsceneIndex),a		; $61e7
	ld a,$03		; $61ea
	ldh (<hNextLcdInterruptBehaviour),a	; $61ec
	ld a,GLOBALFLAG_S_24		; $61ee
	call setGlobalFlag		; $61f0

	ld a,SNDCTRL_STOPSFX		; $61f3
	jp playSound		; $61f5

@state2:
	ld a,(wTmpcbb3)		; $61f8
	rst_jumpTable			; $61fb
	.dw @@substate0
	.dw @@substate1
	.dw @state1@substate2
	.dw @@substate3

@@substate0:
	call @state1@substate0		; $6204
	ld a,$ab		; $6207
	call loadPaletteHeader		; $6209
	call resetLinkInvincibility		; $620c
	ld a,LINK_STATE_FORCE_MOVEMENT		; $620f
	ld (wLinkForceState),a		; $6211
	ld a,$20		; $6214
	ld (wLinkStateParameter),a		; $6216
	xor a			; $6219
	ld hl,w1Link.direction		; $621a
	ldi (hl),a		; $621d
	ld (hl),a		; $621e
	ret			; $621f

@@substate1:
	ld a,$02		; $6220
	call loadBigBufferScrollValues		; $6222
	ld hl,wTmpcbb7		; $6225
	inc (hl)		; $6228
	inc (hl)		; $6229
	ld a,(hl)		; $622a
	jp nz,@initWaveScrollValues_everyOtherLine		; $622b

	call @incSubstate		; $622e
	call getFreeInteractionSlot		; $6231
	ret nz			; $6234
	ld (hl),INTERACID_DE		; $6235
	ret			; $6237

; Unused?
@@seasonsFunc_6238:
	ld a,$02		; $6238
	call loadBigBufferScrollValues		; $623a
	call @decCounter		; $623d
	ret nz			; $6240

	ld a,$00		; $6241
	ld (wTmpcbb7),a		; $6243
	call fastFadeinFromWhite		; $6246
	jp @incSubstate		; $6249

@@substate3:
	ld a,$02		; $624c
	call loadBigBufferScrollValues		; $624e
	ld hl,wTmpcbb7		; $6251
	dec (hl)		; $6254
	ld a,(hl)		; $6255
	jp nz,@initWaveScrollValues_everyOtherLine		; $6256

	call refreshObjectGfx		; $6259
	ld a,LINK_STATE_NORMAL		; $625c
	ld (wLinkForceState),a		; $625e

	ld hl,$7e40		; $6261
	call parseGivenObjectData		; $6264

	ld a,CUTSCENE_S_INGAME		; $6267
	ld (wCutsceneIndex),a		; $6269
	ld a,$03		; $626c
	ldh (<hNextLcdInterruptBehaviour),a	; $626e
	ld a,$01		; $6270
	ld (wScrollMode),a		; $6272

	ld a,SNDCTRL_STOPSFX		; $6275
	jp playSound		; $6277

;;
; Calls initWaveScrollValues, then overwrites every other line with 0.
@initWaveScrollValues_everyOtherLine:
	call initWaveScrollValues		; $627a

	ld a,:w2WaveScrollValues		; $627d
	ld ($ff00+R_SVBK),a	; $627f

	ld hl,w2WaveScrollValues		; $6281
	ld b,$80		; $6284
--
	xor a			; $6286
	ldi (hl),a		; $6287
	inc hl			; $6288
	dec b			; $6289
	jr nz,--		; $628a

	xor a			; $628c
	ld ($ff00+R_SVBK),a	; $628d
	ret			; $628f
