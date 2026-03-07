m_section_free Bank_4 NAMESPACE bank4

; At the start of this bank, there are 32 variations of the same function.

.macro m_VBlankFunction

b4VBlankFunction\1:
	ld h,b
	ld l,e
	ld b,$04
---
	ld e,$00+\1
	ldi a,(hl)
	ld (de),a
	ld e,$20+\1
	ldi a,(hl)
	ld (de),a
	ld e,$40+\1
	ldi a,(hl)
	ld (de),a
	ld e,$60+\1
	ldi a,(hl)
	ld (de),a
	ld e,$80+\1
	ldi a,(hl)
	ld (de),a
	ld e,$a0+\1
	ldi a,(hl)
	ld (de),a
	ld e,$c0+\1
	ldi a,(hl)
	ld (de),a
	ld e,$e0+\1
	ldi a,(hl)
	ld (de),a
	inc d
	dec b
	jr nz,---

	ld l,c
	ld h,>wVBlankFunctionQueue
	jp vblankFunctionRet
.endm

 m_VBlankFunction 0
 m_VBlankFunction 1
 m_VBlankFunction 2
 m_VBlankFunction 3
 m_VBlankFunction 4
 m_VBlankFunction 5
 m_VBlankFunction 6
 m_VBlankFunction 7
 m_VBlankFunction 8
 m_VBlankFunction 9
 m_VBlankFunction 10
 m_VBlankFunction 11
 m_VBlankFunction 12
 m_VBlankFunction 13
 m_VBlankFunction 14
 m_VBlankFunction 15
 m_VBlankFunction 16
 m_VBlankFunction 17
 m_VBlankFunction 18
 m_VBlankFunction 19
 m_VBlankFunction 20
 m_VBlankFunction 21
 m_VBlankFunction 22
 m_VBlankFunction 23
 m_VBlankFunction 24
 m_VBlankFunction 25
 m_VBlankFunction 26
 m_VBlankFunction 27
 m_VBlankFunction 28
 m_VBlankFunction 29
 m_VBlankFunction 30
 m_VBlankFunction 31

;;
vblankRunBank4Function_b04:
	pop hl
	ldi a,(hl)
	ld ($ff00+R_VBK),a
	ldi a,(hl)
	ld e,a
	ld b,$cd
	ld d,$98
	ldi a,(hl)
	ld h,(hl)
	inc l
	ld c,l
	ld l,a
	jp hl

;;
; Does most of the gruntwork involved in figuring out which room to warp to
applyWarpDest_b04:
	ld a,(wWarpDestGroup)
	bit 7,a
	jr nz,+++

.ifdef ROM_SEASONS
	and $0f
	cp $02
	jr nz,label_04_032

	ld hl,warpDestTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	ld a,(wWarpDestRoom)
	ld b,a
	ld a,(wc6e5)
	add b
	jr label_04_033
.endif

label_04_032:
	ld hl,warpDestTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	ld a,(wWarpDestRoom)
label_04_033:
	ld c,a
	ld b,$00
	add hl,bc
	add hl,bc
	add hl,bc
	ldi a,(hl)
	ld (wWarpDestRoom),a
	ldi a,(hl)
	ld (wWarpDestPos),a
	ldi a,(hl)
	or $80
	ld (wWarpTransition),a
+++
	ld a,LINK_STATE_WARPING
	ld (wLinkForceState),a
	ld a,(wActiveGroup)
	ldh (<hFF8B),a
	ld a,(wWarpDestGroup)
	and $07
	ld (wActiveGroup),a
	ld a,(wWarpDestRoom)
	ld (wActiveRoom),a
	ld hl,w1Link.enabled
	ld (hl),$03
	ld a,(wWarpDestPos)
	ld b,a
	and $f0
	or $08
	ld l,<w1Link.yh
	ldi (hl),a
	inc l
	ld a,b
	and $0f
	swap a
	or $08
	ldi (hl),a

.ifdef ROM_AGES
	jp loadScreenMusicAndSetRoomPack
.else; ROM_SEASONS
	ld a,(wWarpDestGroup)
	bit 6,a
	jr nz,label_04_036
	ld a,(wActiveGroup)
	or a
	jr nz,label_04_036
	ldh a,(<hFF8B)
	cp $03
	jr c,label_04_035
	jr z,label_04_036
	ld a,(wDungeonIndex)
	cp $ff
	jr z,label_04_036
label_04_035:
	call loadScreenMusicAndSetRoomPack
	jp checkRoomPackAfterWarp
label_04_036:
	jp loadScreenMusicAndSetRoomPack
.endif

;;
; Sets wWarpDestRoom, wWarpDestGroup, wWarpTransition with suitable warp data. If no
; good warp data is found, it defaults to warping to itself (the current position).
;
; This only handles tile-based warps, not screen-edge warps.
;
; @param	hFF8C	The tile index that initiated the warp
; @param	hFF8D	The position of the tile that initiated the warp
findWarpSourceAndDest:
.ifdef ROM_AGES
	ld a,(wDisableWarps)
	or a
	jp nz,setWarpDestDefault
.endif

	ld a,(wActiveGroup)
	ld hl,warpSourcesTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	ld a,(wActiveRoom)
	ld b,a

@nextWarpSource:
	ldi a,(hl)

.ifdef AGES_ENGINE
	cp $ff
	jr z,@warpSourceNotFound
.endif

	; Bit 7 indicates the last, "default" one in pointed warps.
	bit 7,a
	jr nz,@foundWarpSource

	; Bit 6 indicates a "Pointer warp" which points to a series of data
	; with particular X/Y positions. Main way to have more than 1 warp in
	; a room.
	bit 6,a
	jr nz,@pointerWarp

	; Standard warp
	; Lower bits are for screen edge warps
	and $0f
	jr nz,@skipRemainingBytes

	ld a,(hl)
	cp b
	jr z,@foundWarpSource

@skipRemainingBytes:
	inc hl
	inc hl
	inc hl
	jr @nextWarpSource

@pointerWarp:
	ld a,(hl)
	cp b
	jr nz,@skipRemainingBytes

	; Retrieve YX in b, search "PointedWarps" for the correct YX position.
	inc hl
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	ldh a,(<hFF8D)
	ld b,a
	jr @nextWarpSource

@foundWarpSource:
	inc hl
	ldi a,(hl)
	ld (wWarpDestRoom),a
	ldi a,(hl)
	ld b,a
	swap a
	and $0f
	ld (wWarpDestGroup),a
	ld a,b
	and $0f
	ld (wWarpTransition),a
	ret

.ifdef AGES_ENGINE

@warpSourceNotFound:
	ld a,(wTilesetFlags)
	and TILESETFLAG_DUNGEON
	jr z,setWarpDestDefault

	; In dungeons, check if you're on a staircase. They don't need explicit
	; warp data.
	; ff8c = staircase type?

	ldh a,(<hFF8C)
	rrca
	ld b,$01
	jr nc,+
	ld b,$ff
+
	ld a,(wDungeonFloor)
	add b
	ld (wDungeonFloor),a
	call getActiveRoomFromDungeonMapPosition
	ld (wWarpDestRoom),a
	ldh a,(<hFF8D)
	ld (wWarpDestPos),a
	ld a,(wActiveGroup)
	or $80
	ld (wWarpDestGroup),a
	xor a
	ld (wWarpTransition),a
	ld a,$03
	ld (wWarpTransition2),a
	ld a,SND_ENTERCAVE
	jp playSound

;;
; When you give up, make the warp warp to itself.
setWarpDestDefault:
	ld hl,wWarpDestGroup
	ld a,(wActiveGroup)
	or $80
	ldi (hl),a
	ld a,(wActiveRoom)
	ldi (hl),a
	ld (hl),$00
	inc l
	ldh a,(<hFF8D)
	ldi (hl),a
	ld (hl),$03
	ret

.endif ; AGES_ENGINE

;;
findScreenEdgeWarpSource:
	; Don't do anything if the warp is already in progress
	ld a,(wScrollMode)
	and $04
	ret z

	; Don't do anything if moving horizontally
	ld a,(wScreenTransitionDirection)
	rrca
	ret c

	call getLinkWarpQuadrant
	ld hl,bitTable
	add l
	ld l,a
	ld b,(hl)
	ld a,(wActiveGroup)
	ld hl,warpSourcesTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	ld a,(wActiveRoom)
	ld c,a

@nextWarpSource:
	ldi a,(hl)
	bit 7,a
	ret nz
	bit 6,a
	jr nz,@pointerWarp

	ld e,a
	ldi a,(hl)
	cp c
	jr nz,@skipRemainingBytes

	ld a,e
	and b
	jr nz,@foundWarpSource
@skipRemainingBytes:
	inc hl
	inc hl
	jr @nextWarpSource

@pointerWarp:
	ldi a,(hl)
	cp c
	jr nz,@skipRemainingBytes

	ldi a,(hl)
	ld h,(hl)
	ld l,a
	jr @nextWarpSource

@foundWarpSource:
	ldi a,(hl)
	ld (wWarpDestRoom),a
	ldi a,(hl)
	ld b,a
	swap a
	and $0f
	ld (wWarpDestGroup),a
	ld a,b
	and $0f
	ld b,a
	ld a,(wScreenTransitionDirection)
	rlca
	swap a
	and $40
	or b
	ld (wWarpTransition),a
	ld a,(wLinkObjectIndex)
	cp LINK_OBJECT_INDEX
	call nz,func_04_4732
	xor a
	ld (wTmpcec0),a
	ret

;;
func_04_4732:
	push hl
	call dismountCompanionAndSetRememberedPositionToScreenCenter
	ld a,$01
	ld (wWarpTransition),a
	ld a,$01
	ld (wWarpTransition2),a
	pop hl
	ret

;;
getLinkWarpQuadrant:
	ld a,(wScreenTransitionDirection)
	ld b,a
	ld a,(wActiveGroup)
	cp NUM_SMALL_GROUPS
	ld a,(w1Link.xh)
	jr nc,@largeRoom

@smallRoom:
.ifdef ROM_AGES
	cp $58
.else
	cp $60
.endif
	ld a,b
	ret c
	inc a
	ret
@largeRoom:
	cp $80
	ld a,b
	ret c
	inc a
	ret

.ends
