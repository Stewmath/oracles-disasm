;;
; CUTSCENE_S_ONOX_CASTLE_FORCE
cutscene14:
	call @handleCutscene
	jp updateAllObjects

;;
@handleCutscene:
	ld a,(wCutsceneState)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2

@state0:
	call reloadTileMap
	ld a,TREASURE_MAKU_SEED
	call checkTreasureObtained
	ld a,$01
	jr nc,+
	inc a
+
	ld (wCutsceneState),a
	xor a
	ld (wTmpcbb3),a
	ld (wScrollMode),a
	ld a,$28
	ld (wTmpcbb4),a
	ret

;;
@decCounter:
	ld hl,wTmpcbb4
	dec (hl)
	ret nz
	ld (hl),$1e
	ret

;;
@incSubstate:
	ld hl,wTmpcbb3
	inc (hl)
	ret

;;
@seasonsFunc_6174:
	ld a,(wLinkObjectIndex)
	ld h,a
	ld l,SpecialObject.yh
	ld b,(hl)
	ld l,SpecialObject.xh
	ld c,(hl)
	ret

@state1:
	ld a,(wTmpcbb3)
	rst_jumpTable
	.dw @@substate0
	.dw @@substate1
	.dw @@substate2
	.dw @@substate3

@@substate0:
	call @incSubstate
	ld a,$10
	ld (wGfxRegs2.LYC),a
	ld a,$02
	ldh (<hNextLcdInterruptBehaviour),a
	xor a
	ld (wTmpcbb7),a
	call @initWaveScrollValues_everyOtherLine
	ld a,LINK_STATE_10
	ld (wLinkForceState),a
	ld a,SND_ENDLESS
	jp playSound

@@substate1:
	ld a,$02
	call loadBigBufferScrollValues
	ld hl,wTmpcbb7
	inc (hl)
	ld a,(hl)
	jp nz,@initWaveScrollValues_everyOtherLine
	jr @incSubstate

@@substate2:
	ld a,$02
	jp loadBigBufferScrollValues

@@substate3:
	ld a,$02
	call loadBigBufferScrollValues
	ld a,(wPaletteThread_mode)
	or a
	ret nz

	ld a,(w1Link.xh)
	and $f0
	swap a
	or $10
	ld (wWarpDestPos),a
	ld a,$80
	ld (wWarpDestGroup),a
	ld a,$33
	ld (wWarpDestRoom),a
	ld a,$0c
	ld (wWarpTransition),a
	xor a
	ld (wcc50),a

	ld a,CUTSCENE_S_03
	ld (wCutsceneIndex),a
	ld a,$03
	ldh (<hNextLcdInterruptBehaviour),a
	ld a,GLOBALFLAG_ONOX_CASTLE_BARRIER_GONE
	call setGlobalFlag

	ld a,SNDCTRL_STOPSFX
	jp playSound

@state2:
	ld a,(wTmpcbb3)
	rst_jumpTable
	.dw @@substate0
	.dw @@substate1
	.dw @state1@substate2
	.dw @@substate3

@@substate0:
	call @state1@substate0
	ld a,$ab
	call loadPaletteHeader
	call resetLinkInvincibility
	ld a,LINK_STATE_FORCE_MOVEMENT
	ld (wLinkForceState),a
	ld a,$20
	ld (wLinkStateParameter),a
	xor a
	ld hl,w1Link.direction
	ldi (hl),a
	ld (hl),a
	ret

@@substate1:
	ld a,$02
	call loadBigBufferScrollValues
	ld hl,wTmpcbb7
	inc (hl)
	inc (hl)
	ld a,(hl)
	jp nz,@initWaveScrollValues_everyOtherLine

	call @incSubstate
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERAC_MAKU_SEED_AND_ESSENCES
	ret

; Unused?
@@seasonsFunc_6238:
	ld a,$02
	call loadBigBufferScrollValues
	call @decCounter
	ret nz

	ld a,$00
	ld (wTmpcbb7),a
	call fastFadeinFromWhite
	jp @incSubstate

@@substate3:
	ld a,$02
	call loadBigBufferScrollValues
	ld hl,wTmpcbb7
	dec (hl)
	ld a,(hl)
	jp nz,@initWaveScrollValues_everyOtherLine

	call refreshObjectGfx
	ld a,LINK_STATE_NORMAL
	ld (wLinkForceState),a

	ld hl,objectData.objectData7e40
	call parseGivenObjectData

	ld a,CUTSCENE_S_INGAME
	ld (wCutsceneIndex),a
	ld a,$03
	ldh (<hNextLcdInterruptBehaviour),a
	ld a,$01
	ld (wScrollMode),a

	ld a,SNDCTRL_STOPSFX
	jp playSound

;;
; Calls initWaveScrollValues, then overwrites every other line with 0.
@initWaveScrollValues_everyOtherLine:
	call initWaveScrollValues

	ld a,:w2WaveScrollValues
	ld ($ff00+R_SVBK),a

	ld hl,w2WaveScrollValues
	ld b,$80
--
	xor a
	ldi (hl),a
	inc hl
	dec b
	jr nz,--

	xor a
	ld ($ff00+R_SVBK),a
	ret
