; TODO: Rename this and put it into the "cutscenes/" folder

;;
; CUTSCENE_TOGGLE_BLOCKS
cutscene02:
	call @handleRaisingFloorsCutscene
	jp updateAllObjects

;;
@func_7c86:
	ld hl,wTmpcbb4
	dec (hl)
	ret nz

	ld (hl),$1e
	ret

;;
; Unused
@func_7c8e:
	ld hl,wTmpcbb3
	inc (hl)
	ret

;;
@handleRaisingFloorsCutscene:
	ld a,(wCutsceneState)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2

@state0:
	ld hl,wTmpcbb3
	ld b,$10
	call clearMemory
	ld a,(wDisabledObjects)
	ld ($cbb7),a
	ld a,$ff
	ld (wDisabledObjects),a
	ld (wDisableLinkCollisionsAndMenu),a
	ld a,$06
	ld (wTmpcbb4),a
---
	ld hl,wCutsceneState
	inc (hl)
	ret

@state1:
	ld a,SND_DOORCLOSE
	call playSound
	ld a,UNCMP_GFXH_AGES_3e
	call loadUncompressedGfxHeader
	jr ---

@state2:
	call @func_7c86
	ret nz

	call @func_7ced
	callab roomGfxChanges.func_02_7a77
	xor a
	ld (wCutsceneState),a
	ld (wDisableLinkCollisionsAndMenu),a
	ld a,($cbb7)
	ld (wDisabledObjects),a
	ld a,CUTSCENE_INGAME
	ld (wCutsceneIndex),a
	jp updateLastToggleBlocksState

;;
@func_7ced:
	ld a,:w3RoomLayoutBuffer
	ld ($ff00+R_SVBK),a
	ld a,$10
	call findTileInRoom
	jr nz,@loopEnd
---
	; Check if the tile is a raised or raisable tile
	ld h,>w3RoomLayoutBuffer
	ld a,(hl)
	sub TILEINDEX_RAISED_FLOOR_2
	cp $02
	jr nc,+++

	ld a,(hl)
	sub TILEINDEX_RAISED_FLOOR_2
	add TILEINDEX_RAISED_FLOOR_1
	ld c,l
	push hl
	call setTile
	xor a
	ld ($ff00+R_SVBK),a
	call getFreeInteractionSlot
	jr nz,+

	ld (hl),INTERAC_ROCKDEBRIS
	ld l,Interaction.yh
	call setShortPosition_paramC
+
	pop hl
	ld a,:w3RoomLayoutBuffer
	ld ($ff00+R_SVBK),a
	ld b,>wRoomLayout
	ld a,(hl)
	ld (bc),a
+++
	ld h,>wRoomLayout
	dec l
	ld a,$10
	call backwardsSearch
	jr z,---

@loopEnd:
	ld hl,w3RoomLayoutBuffer+$af
	ld de,wRoomLayout+$af
---
	ld a,(hl)
	ld b,$00
	cp TILEINDEX_RAISED_FLOOR_1
	jr z,+++

	inc b
	cp TILEINDEX_LOWERED_FLOOR_1
	jr z,+++

	inc b
	cp TILEINDEX_RAISED_FLOOR_2
	jr z,+++

	inc b
	cp TILEINDEX_LOWERED_FLOOR_2
	jr z,+++
--
	dec e
	dec l
	jr nz,---

	xor a
	ld ($ff00+R_SVBK),a
	ret
+++
	ld a,b
	ld bc,@data_7d63
	call addDoubleIndexToBc
	ld a,(bc)
	inc bc
	ld (de),a
	ld (hl),a
	ld a,(bc)
	inc bc
	dec d
	ld (de),a
	inc d
	jr --

@data_7d63:
	.db $28 $00
	.db $29 $00
	.db $0e $1e
	.db $0f $1e


;;
; CUTSCENE_WALL_RETRACTION
cutscene0b:
	callab bank3Cutscenes.func_701d
	jp updateAllObjects

;;
; CUTSCENE_D2_COLLAPSE
cutscene1a:
	callab bank3Cutscenes.func_7168
	jp updateAllObjects

;;
; CUTSCENE_TIMEWARP
cutscene1b:
	ld a,($ff00+R_SVBK)
	push af
	callab bank3Cutscenes.func_03_7244
	pop af
	ld ($ff00+R_SVBK),a
	jp updateAllObjects

;;
warpToMoblinKeepUnderground:
	ld hl,@warpDestVars
	jp setWarpDestVariables

@warpDestVars:
	m_HardcodedWarpA ROOM_AGES_701, $00, $03, $03

;;
; CUTSCENE_AMBI_PASSAGE_OPEN
cutscene1c:
	callab bank3Cutscenes.func_03_7493
	call updateAllObjects
	jp updateStatusBar

;;
; CUTSCENE_JABU_OPEN
cutscene1d:
	callab bank3Cutscenes.func_03_7565
	callab bank1.checkUpdateUnderwaterWaves
	jp updateAllObjects

;;
; CUTSCENE_CLEAN_SEAS
cutscene1e:
	callab bank3Cutscenes.func_03_7619
	call updateStatusBar
	jp updateAllObjects
