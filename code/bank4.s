; At the start of this bank, there are 32 variations of the same function.

.macro m_VBlankFunction

b4VBlankFunction\1:
	ld h,b			; $4000
	ld l,e			; $4001
	ld b,$04		; $4002
---
	ld e,$00+\1		; $4004
	ldi a,(hl)		; $4006
	ld (de),a		; $4007
	ld e,$20+\1		; $4008
	ldi a,(hl)		; $400a
	ld (de),a		; $400b
	ld e,$40+\1		; $400c
	ldi a,(hl)		; $400e
	ld (de),a		; $400f
	ld e,$60+\1		; $4010
	ldi a,(hl)		; $4012
	ld (de),a		; $4013
	ld e,$80+\1		; $4014
	ldi a,(hl)		; $4016
	ld (de),a		; $4017
	ld e,$a0+\1		; $4018
	ldi a,(hl)		; $401a
	ld (de),a		; $401b
	ld e,$c0+\1		; $401c
	ldi a,(hl)		; $401e
	ld (de),a		; $401f
	ld e,$e0+\1		; $4020
	ldi a,(hl)		; $4022
	ld (de),a		; $4023
	inc d			; $4024
	dec b			; $4025
	jr nz,---		; $4026

	ld l,c			; $4028
	ld h,>wVBlankFunctionQueue		; $4029
	jp vblankFunctionRet		; $402b
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
; @addr{45c0}
vblankRunBank4Function_b04:
	pop hl			; $45c0
	ldi a,(hl)		; $45c1
	ld ($ff00+R_VBK),a	; $45c2
	ldi a,(hl)		; $45c4
	ld e,a			; $45c5
	ld b,$cd		; $45c6
	ld d,$98		; $45c8
	ldi a,(hl)		; $45ca
	ld h,(hl)		; $45cb
	inc l			; $45cc
	ld c,l			; $45cd
	ld l,a			; $45ce
	jp hl			; $45cf

;;
; Does most of the gruntwork involved in figuring out which room to warp to
; @addr{45d0}
applyWarpDest_b04:
	ld a,(wWarpDestGroup)		; $45d0
	bit 7,a			; $45d3
	jr nz,+++		; $45d5

.ifdef ROM_SEASONS
	and $0f			; $45d7
	cp $02			; $45d9
	jr nz,_label_04_032	; $45db

	ld hl,warpDestTable		; $45dd
	rst_addDoubleIndex			; $45e0
	ldi a,(hl)		; $45e1
	ld h,(hl)		; $45e2
	ld l,a			; $45e3
	ld a,(wWarpDestIndex)		; $45e4
	ld b,a			; $45e7
	ld a,(wc6e5)		; $45e8
	add b			; $45eb
	jr _label_04_033		; $45ec
.endif

_label_04_032:
	ld hl,warpDestTable		; $45d7
	rst_addDoubleIndex			; $45da
	ldi a,(hl)		; $45db
	ld h,(hl)		; $45dc
	ld l,a			; $45dd
	ld a,(wWarpDestIndex)		; $45de
_label_04_033:
	ld c,a			; $45e1
	ld b,$00		; $45e2
	add hl,bc		; $45e4
	add hl,bc		; $45e5
	add hl,bc		; $45e6
	ldi a,(hl)		; $45e7
	ld (wWarpDestIndex),a		; $45e8
	ldi a,(hl)		; $45eb
	ld (wWarpDestPos),a		; $45ec
	ldi a,(hl)		; $45ef
	or $80			; $45f0
	ld (wWarpTransition),a		; $45f2
+++
	ld a,LINK_STATE_WARPING		; $45f5
	ld (wLinkForceState),a		; $45f7
	ld a,(wActiveGroup)		; $45fa
	ldh (<hFF8B),a	; $45fd
	ld a,(wWarpDestGroup)		; $45ff
	and $07			; $4602
	ld (wActiveGroup),a		; $4604
	ld a,(wWarpDestIndex)		; $4607
	ld (wActiveRoom),a		; $460a
	ld hl,w1Link.enabled	; $460d
	ld (hl),$03		; $4610
	ld a,(wWarpDestPos)		; $4612
	ld b,a			; $4615
	and $f0			; $4616
	or $08			; $4618
	ld l,<w1Link.yh		; $461a
	ldi (hl),a		; $461c
	inc l			; $461d
	ld a,b			; $461e
	and $0f			; $461f
	swap a			; $4621
	or $08			; $4623
	ldi (hl),a		; $4625

.ifdef ROM_AGES
	jp loadScreenMusicAndSetRoomPack		; $4626
.else; ROM_SEASONS
	ld a,(wWarpDestGroup)		; $463d
	bit 6,a			; $4640
	jr nz,_label_04_036	; $4642
	ld a,(wActiveGroup)		; $4644
	or a			; $4647
	jr nz,_label_04_036	; $4648
	ldh a,(<hFF8B)	; $464a
	cp $03			; $464c
	jr c,_label_04_035	; $464e
	jr z,_label_04_036	; $4650
	ld a,(wDungeonIndex)		; $4652
	cp $ff			; $4655
	jr z,_label_04_036	; $4657
_label_04_035:
	call loadScreenMusicAndSetRoomPack		; $4659
	jp checkRoomPackAfterWarp		; $465c
_label_04_036:
	jp loadScreenMusicAndSetRoomPack		; $465f
.endif

;;
; Sets wWarpDestIndex, wWarpDestGroup, wWarpDestTransition with suitable warp data. If no
; good warp data is found, it defaults to warping to itself (the current position).
;
; This only handles tile-based warps, not screen-edge warps.
;
; @param	hFF8C	The tile index that initiated the warp
; @param	hFF8D	The position of the tile that initiated the warp
; @addr{4629}
findWarpSourceAndDest:
.ifdef ROM_AGES
	ld a,(wDisableWarps)		; $4629
	or a			; $462c
	jp nz,setWarpDestDefault		; $462d
.endif

	ld a,(wActiveGroup)		; $4630
	ld hl,warpSourcesTable		; $4633
	rst_addDoubleIndex			; $4636
	ldi a,(hl)		; $4637
	ld h,(hl)		; $4638
	ld l,a			; $4639
	ld a,(wActiveRoom)		; $463a
	ld b,a			; $463d

@nextWarpSource:
	ldi a,(hl)		; $463e

.ifdef ROM_AGES
	cp $ff			; $463f
	jr z,@warpSourceNotFound	; $4641
.endif

	; Bit 7 indicates the last, "default" one in pointed warps.
	bit 7,a			; $4643
	jr nz,@foundWarpSource	; $4645

	; Bit 6 indicates a "Pointer warp" which points to a series of data
	; with particular X/Y positions. Main way to have more than 1 warp in
	; a room.
	bit 6,a			; $4647
	jr nz,@pointerWarp	; $4649

	; Standard warp
	; Lower bits are for screen edge warps
	and $0f			; $464b
	jr nz,@skipRemainingBytes	; $464d

	ld a,(hl)		; $464f
	cp b			; $4650
	jr z,@foundWarpSource	; $4651

@skipRemainingBytes:
	inc hl			; $4653
	inc hl			; $4654
	inc hl			; $4655
	jr @nextWarpSource			; $4656

@pointerWarp:
	ld a,(hl)		; $4658
	cp b			; $4659
	jr nz,@skipRemainingBytes	; $465a

	; Retrieve YX in b, search "PointedWarps" for the correct YX position.
	inc hl			; $465c
	ldi a,(hl)		; $465d
	ld h,(hl)		; $465e
	ld l,a			; $465f
	ldh a,(<hFF8D)	; $4660
	ld b,a			; $4662
	jr @nextWarpSource			; $4663

@foundWarpSource:
	inc hl			; $4665
	ldi a,(hl)		; $4666
	ld (wWarpDestIndex),a		; $4667
	ldi a,(hl)		; $466a
	ld b,a			; $466b
	swap a			; $466c
	and $0f			; $466e
	ld (wWarpDestGroup),a		; $4670
	ld a,b			; $4673
	and $0f			; $4674
	ld (wWarpTransition),a		; $4676
	ret			; $4679

.ifdef ROM_AGES

@warpSourceNotFound:
	ld a,(wAreaFlags)		; $467a
	and AREAFLAG_DUNGEON	; $467d
	jr z,setWarpDestDefault	; $467f

	; In dungeons, check if you're on a staircase. They don't need explicit
	; warp data.
	; ff8c = staircase type?

	ldh a,(<hFF8C)	; $4681
	rrca			; $4683
	ld b,$01		; $4684
	jr nc,+			; $4686
	ld b,$ff		; $4688
+
	ld a,(wDungeonFloor)		; $468a
	add b			; $468d
	ld (wDungeonFloor),a		; $468e
	call getActiveRoomFromDungeonMapPosition		; $4691
	ld (wWarpDestIndex),a		; $4694
	ldh a,(<hFF8D)	; $4697
	ld (wWarpDestPos),a		; $4699
	ld a,(wActiveGroup)		; $469c
	or $80			; $469f
	ld (wWarpDestGroup),a		; $46a1
	xor a			; $46a4
	ld (wWarpTransition),a		; $46a5
	ld a,$03		; $46a8
	ld (wWarpTransition2),a		; $46aa
	ld a,SND_ENTERCAVE		; $46ad
	jp playSound		; $46af

;;
; When you give up, make the warp warp to itself.
; @addr{46b2}
setWarpDestDefault:
	ld hl,wWarpDestGroup		; $46b2
	ld a,(wActiveGroup)		; $46b5
	or $80			; $46b8
	ldi (hl),a		; $46ba
	ld a,(wActiveRoom)		; $46bb
	ldi (hl),a		; $46be
	ld (hl),$00		; $46bf
	inc l			; $46c1
	ldh a,(<hFF8D)	; $46c2
	ldi (hl),a		; $46c4
	ld (hl),$03		; $46c5
	ret			; $46c7

.endif ; ROM_AGES

;;
; @addr{46c8}
findScreenEdgeWarpSource:
	; Don't do anything if the warp is already in progress
	ld a,(wScrollMode)		; $46c8
	and $04			; $46cb
	ret z			; $46cd

	; Don't do anything if moving horizontally
	ld a,(wScreenTransitionDirection)		; $46ce
	rrca			; $46d1
	ret c			; $46d2

	call getLinkWarpQuadrant		; $46d3
	ld hl,bitTable		; $46d6
	add l			; $46d9
	ld l,a			; $46da
	ld b,(hl)		; $46db
	ld a,(wActiveGroup)		; $46dc
	ld hl,warpSourcesTable		; $46df
	rst_addDoubleIndex			; $46e2
	ldi a,(hl)		; $46e3
	ld h,(hl)		; $46e4
	ld l,a			; $46e5
	ld a,(wActiveRoom)		; $46e6
	ld c,a			; $46e9

@nextWarpSource:
	ldi a,(hl)		; $46ea
	bit 7,a			; $46eb
	ret nz			; $46ed
	bit 6,a			; $46ee
	jr nz,@pointerWarp	; $46f0

	ld e,a			; $46f2
	ldi a,(hl)		; $46f3
	cp c			; $46f4
	jr nz,@skipRemainingBytes	; $46f5

	ld a,e			; $46f7
	and b			; $46f8
	jr nz,@foundWarpSource	; $46f9
@skipRemainingBytes:
	inc hl			; $46fb
	inc hl			; $46fc
	jr @nextWarpSource		; $46fd

@pointerWarp:
	ldi a,(hl)		; $46ff
	cp c			; $4700
	jr nz,@skipRemainingBytes	; $4701

	ldi a,(hl)		; $4703
	ld h,(hl)		; $4704
	ld l,a			; $4705
	jr @nextWarpSource		; $4706

@foundWarpSource:
	ldi a,(hl)		; $4708
	ld (wWarpDestIndex),a		; $4709
	ldi a,(hl)		; $470c
	ld b,a			; $470d
	swap a			; $470e
	and $0f			; $4710
	ld (wWarpDestGroup),a		; $4712
	ld a,b			; $4715
	and $0f			; $4716
	ld b,a			; $4718
	ld a,(wScreenTransitionDirection)		; $4719
	rlca			; $471c
	swap a			; $471d
	and $40			; $471f
	or b			; $4721
	ld (wWarpTransition),a		; $4722
	ld a,(wLinkObjectIndex)		; $4725
	cp LINK_OBJECT_INDEX		; $4728
	call nz,func_04_4732		; $472a
	xor a			; $472d
	ld (wTmpcec0),a		; $472e
	ret			; $4731

;;
; @addr{4732}
func_04_4732:
	push hl			; $4732
	call dismountCompanionAndSetRememberedPositionToScreenCenter		; $4733
	ld a,$01		; $4736
	ld (wWarpTransition),a		; $4738
	ld a,$01		; $473b
	ld (wWarpTransition2),a		; $473d
	pop hl			; $4740
	ret			; $4741

;;
; @addr{4742}
getLinkWarpQuadrant:
	ld a,(wScreenTransitionDirection)		; $4742
	ld b,a			; $4745
	ld a,(wActiveGroup)		; $4746
	cp NUM_SMALL_GROUPS			; $4749
	ld a,(w1Link.xh)		; $474b
	jr nc,@largeRoom			; $474e

@smallRoom:
.ifdef ROM_AGES
	cp $58			; $4750
.else
	cp $60
.endif
	ld a,b			; $4752
	ret c			; $4753
	inc a			; $4754
	ret			; $4755
@largeRoom:
	cp $80			; $4756
	ld a,b			; $4758
	ret c			; $4759
	inc a			; $475a
	ret			; $475b
