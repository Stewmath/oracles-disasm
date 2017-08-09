;;
; @addr{7c80}
cutscene02:
	call @handleRaisingFloorsCutscene		; $7c80
	jp updateAllObjects		; $7c83

;;
; @addr{7c86}
@func_7c86:
	ld hl,wTmpcbb4		; $7c86
	dec (hl)		; $7c89
	ret nz			; $7c8a

	ld (hl),$1e		; $7c8b
	ret			; $7c8d

;;
; Unused
; @addr{7c8e}
@func_7c8e:
	ld hl,wTmpcbb3		; $7c8e
	inc (hl)		; $7c91
	ret			; $7c92

;;
; @addr{7c93}
@handleRaisingFloorsCutscene:
	ld a,(wCutsceneState)		; $7c93
	rst_jumpTable			; $7c96
	.dw @state0
	.dw @state1
	.dw @state2

@state0:
	ld hl,wTmpcbb3		; $7c9d
	ld b,$10		; $7ca0
	call clearMemory		; $7ca2
	ld a,(wDisabledObjects)		; $7ca5
	ld ($cbb7),a		; $7ca8
	ld a,$ff		; $7cab
	ld (wDisabledObjects),a		; $7cad
	ld (wcbca),a		; $7cb0
	ld a,$06		; $7cb3
	ld (wTmpcbb4),a		; $7cb5
---
	ld hl,wCutsceneState		; $7cb8
	inc (hl)		; $7cbb
	ret			; $7cbc

@state1:
	ld a,SND_DOORCLOSE		; $7cbd
	call playSound		; $7cbf
	ld a,UNCMP_GFXH_3e		; $7cc2
	call loadUncompressedGfxHeader		; $7cc4
	jr ---			; $7cc7

@state2:
	call @func_7c86		; $7cc9
	ret nz			; $7ccc

	call @func_7ced		; $7ccd
	callab bank2.func_02_7a77		; $7cd0
	xor a			; $7cd8
	ld (wCutsceneState),a		; $7cd9
	ld (wcbca),a		; $7cdc
	ld a,($cbb7)		; $7cdf
	ld (wDisabledObjects),a		; $7ce2
	ld a,CUTSCENE_INGAME		; $7ce5
	ld (wCutsceneIndex),a		; $7ce7
	jp updateLastToggleBlocksState		; $7cea

;;
; @addr{7ced}
@func_7ced:
	ld a,:w3RoomLayoutBuffer		; $7ced
	ld ($ff00+R_SVBK),a	; $7cef
	ld a,$10		; $7cf1
	call findTileInRoom		; $7cf3
	jr nz,@loopEnd		; $7cf6
---
	; Check if the tile is a raised or raisable tile
	ld h,>w3RoomLayoutBuffer		; $7cf8
	ld a,(hl)		; $7cfa
	sub TILEINDEX_RAISED_FLOOR_2			; $7cfb
	cp $02			; $7cfd
	jr nc,+++		; $7cff

	ld a,(hl)		; $7d01
	sub TILEINDEX_RAISED_FLOOR_2			; $7d02
	add TILEINDEX_RAISED_FLOOR_1			; $7d04
	ld c,l			; $7d06
	push hl			; $7d07
	call setTile		; $7d08
	xor a			; $7d0b
	ld ($ff00+R_SVBK),a	; $7d0c
	call getFreeInteractionSlot		; $7d0e
	jr nz,+			; $7d11

	ld (hl),INTERACID_ROCKDEBRIS		; $7d13
	ld l,Interaction.yh		; $7d15
	call setShortPosition_paramC		; $7d17
+
	pop hl			; $7d1a
	ld a,:w3RoomLayoutBuffer		; $7d1b
	ld ($ff00+R_SVBK),a	; $7d1d
	ld b,>wRoomLayout		; $7d1f
	ld a,(hl)		; $7d21
	ld (bc),a		; $7d22
+++
	ld h,>wRoomLayout		; $7d23
	dec l			; $7d25
	ld a,$10		; $7d26
	call backwardsSearch		; $7d28
	jr z,---		; $7d2b

@loopEnd:
	ld hl,w3RoomLayoutBuffer+$af		; $7d2d
	ld de,wRoomLayout+$af		; $7d30
---
	ld a,(hl)		; $7d33
	ld b,$00		; $7d34
	cp TILEINDEX_RAISED_FLOOR_1			; $7d36
	jr z,+++		; $7d38

	inc b			; $7d3a
	cp TILEINDEX_LOWERED_FLOOR_1			; $7d3b
	jr z,+++		; $7d3d

	inc b			; $7d3f
	cp TILEINDEX_RAISED_FLOOR_2			; $7d40
	jr z,+++		; $7d42

	inc b			; $7d44
	cp TILEINDEX_LOWERED_FLOOR_2			; $7d45
	jr z,+++		; $7d47
--
	dec e			; $7d49
	dec l			; $7d4a
	jr nz,---		; $7d4b

	xor a			; $7d4d
	ld ($ff00+R_SVBK),a	; $7d4e
	ret			; $7d50
+++
	ld a,b			; $7d51
	ld bc,@data_7d63		; $7d52
	call addDoubleIndexToBc		; $7d55
	ld a,(bc)		; $7d58
	inc bc			; $7d59
	ld (de),a		; $7d5a
	ld (hl),a		; $7d5b
	ld a,(bc)		; $7d5c
	inc bc			; $7d5d
	dec d			; $7d5e
	ld (de),a		; $7d5f
	inc d			; $7d60
	jr --			; $7d61

@data_7d63:
	.db $28 $00
	.db $29 $00
	.db $0e $1e
	.db $0f $1e


;;
; @addr{7d6b}
cutscene0b:
	callab func_701d		; $7d6b
	jp updateAllObjects		; $7d73

;;
; @addr{7d76}
cutscene1a:
	callab func_7168		; $7d76
	jp updateAllObjects		; $7d7e

;;
; @addr{7d81}
cutscene1b:
	ld a,($ff00+R_SVBK)	; $7d81
	push af			; $7d83
	callab func_03_7244		; $7d84
	pop af			; $7d8c
	ld ($ff00+R_SVBK),a	; $7d8d
	jp updateAllObjects		; $7d8f

;;
; @addr{7d92}
warpToMoblinKeepUnderground:
	ld hl,@warpDestVars		; $7d92
	jp setWarpDestVariables		; $7d95

@warpDestVars:
	.db $87 $01 $00 $03 $03 

;;
; @addr{7d9d}
cutscene1c:
	callab func_03_7493		; $7d9d
	call updateAllObjects		; $7da5
	jp updateStatusBar		; $7da8

;;
; @addr{7dab}
cutscene1d:
	callab func_03_7565		; $7dab
	callab checkUpdateUnderwaterWaves		; $7db3
	jp updateAllObjects		; $7dbb

;;
; @addr{7dbe}
cutscene1e:
	callab func_03_7619		; $7dbe
	call updateStatusBar		; $7dc6
	jp updateAllObjects		; $7dc9
