; ==================================================================================================
; PART_SWITCH
;
; Variables:
;   var30: Position of tile it's on
; ==================================================================================================
partCode05:
	jr z,@normalStatus

	; Just hit
	ld a,(wSwitchState)
	ld h,d
	ld l,Part.subid
	xor (hl)
	ld (wSwitchState),a
	call @updateTile
	ld a,SND_SWITCH
	jp playSound

@normalStatus:
	ld e,Part.state
	ld a,(de)
	or a
	ret nz

@state0:
	ld h,d
	ld l,e
	inc (hl) ; [state] = 1
	ld l,Part.zh
	ld (hl),$fa
	call objectGetShortPosition
	ld e,Part.var30
	ld (de),a
	ret

@updateTile:
	ld l,Part.var30
	ld c,(hl)
	ld a,(wActiveGroup)
	or a
	jr z,@flipOverworldSwitch

	; Dungeon
	ld hl,wSwitchState
	ld e,Part.subid
	ld a,(de)
	and (hl)
	ld a,TILEINDEX_DUNGEON_SWITCH_OFF
	jr z,+
	inc a ; TILEINDEX_DUNGEON_SWITCH_ON
+
	jp setTile

@flipOverworldSwitch:
	ld a,TILEINDEX_OVERWORLD_SWITCH_ON
	call setTile
	ld b,>wRoomLayout
	xor a
	ld (bc),a
	call getThisRoomFlags
	set 6,(hl)
	jp partDelete
