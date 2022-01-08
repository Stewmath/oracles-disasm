; ==============================================================================
; PARTID_HOLES_FLOORTRAP
; Variables:
;   var30 - pointer to tile at part's position
;   $ccbf - set to 1 when button in hallway to D3 miniboss is pressed
; ==============================================================================
partCode0a:
	ld e,Part.subid
	ld a,(de)
	rst_jumpTable
	.dw @subid0
	.dw @subidStub
	.dw @subid2
	.dw @subid3
	.dw @subid4

@subid0:
	ld e,Part.state
	ld a,(de)
	rst_jumpTable
	.dw @@state0
	.dw @@state1
@@state0:
	call @init_StoreTileAtPartInVar30
	ld l,Part.counter1
	ld (hl),$08
	ret
@@state1:
	; Proceed once button in D3 hallway to miniboss stepped on
	ld a,($ccbf)
	or a
	ret z

	call @breakFloorsAtInterval
	ret nz

	call @spreadVertical
	ret z

	call @spreadHorizontal
	ret z
	jp partDelete

@subidStub:
	jp partDelete

@subid2:
@subid3:
	ld e,Part.state
	ld a,(de)
	rst_jumpTable
	.dw @@state0
	.dw @@state1
@@state0:
	call @init_StoreTileAtPartInVar30
	ld l,Part.counter1
	ld (hl),$20
	ret
@@state1:
	ld a,($ccbf)
	or a
	ret z
	call @breakFloorsAtInterval
	ret nz
	call seasonsFunc_10_63ed
	ret nz
	jp partDelete

@subid4:
	ld h,d
	ld l,Part.state
	ld a,(hl)
	or a
	jr nz,+
	; state 0
	ld (hl),$01
	ld l,Part.counter1
	ld (hl),$08
	inc l
	ld (hl),$00
	call @@setPositionToCrackTile
+
	; state 1
	ld a,$3c
	call setScreenShakeCounter
	call partCommon_decCounter1IfNonzero
	ret nz
	ld l,Part.yh
	ld c,(hl)
	ld a,TILEINDEX_BLANK_HOLE
	call breakCrackedFloor
@@setPositionToCrackTile:
	ld e,Part.counter2
	ld a,(de)
	ld hl,@@crackedTileTable
	rst_addDoubleIndex
	ld a,(hl)
	or a
	jp z,partDelete

	ldi a,(hl)
	ld e,Part.counter1
	ld (de),a

	ld a,(hl)
	ld e,Part.yh
	ld (de),a

	ld h,d
	ld l,Part.counter2
	inc (hl)
	ret
@@crackedTileTable:
	; counter1 - position of tile to break
	.db $1e $91
	.db $1e $81
	.db $01 $82
	.db $1d $71
	.db $01 $61
	.db $1d $83
	.db $01 $51
	.db $1d $84
	.db $01 $52
	.db $1d $85
	.db $01 $53
	.db $1d $86
	.db $01 $63
	.db $1d $87
	.db $01 $64
	.db $1d $88
	.db $01 $65
	.db $1d $89
	.db $01 $55
	.db $1d $79
	.db $01 $45
	.db $1d $69
	.db $01 $35
	.db $01 $68
	.db $1c $6a
	.db $01 $25
	.db $01 $58
	.db $1c $6b
	.db $01 $48
	.db $1d $5b
	.db $1e $38
	.db $1e $37
	.db $1e $36
	.db $00

@init_StoreTileAtPartInVar30:
	ld a,$01
	ld (de),a

	ld h,d
	ld l,Part.yh
	ld a,(hl)
	ld c,a

	ld b,>wRoomLayout
	ld a,(bc)

	ld l,Part.var30
	ld (hl),a
	ret

@breakFloorsAtInterval:
	call partCommon_decCounter1IfNonzero
	ret nz

	; counter back to $08
	ld (hl),$08
	ld l,Part.var30
	ld a,TILEINDEX_CRACKED_FLOOR
	cp (hl)
	ld a,TILEINDEX_HOLE
	jr z,+
	ld a,TILEINDEX_BLANK_HOLE
+
	ld l,Part.yh
	ld c,(hl)
	call breakCrackedFloor

	; proceed to below function
	xor a
	ret

@spreadVertical:
	ld h,$10
	jr @spread
@spreadHorizontal:
	ld h,$01
@spread:
	ld b,>wRoomLayout
	ld e,Part.var30
	ld a,(de)
	ld l,a

	ld e,Part.yh
	ld a,(de)
	ld e,a

	sub h
	ld c,a
	ld a,(bc)
	cp l
	jr z,+

	ld a,e
	add h
	ld c,a
	ld a,(bc)
	cp l
	ret nz
+
	ld a,c
	ld e,Part.yh
	ld (de),a
	ret

seasonsFunc_10_63ed:
	ld e,Part.var30
	ld a,(de)
	ld b,a
	ld c,$10
	ld hl,wRoomLayout
--
	ld a,b
	cp (hl)
	jr z,++
	ld a,l
	cp $ae
	ret z
	add c
	cp $f0
	jr nc,+
	cp $b0
	jr nc,+
	ld l,a
	jr --
+
	ld a,c
	cpl
	inc a
	ld c,a
	ld a,l
	add c
	inc a
	ld l,a
	jr --
++
	ld a,l
	ld e,Part.yh
	ld (de),a
	or d
	ret


; ==============================================================================
; PARTID_SLINGSHOT_EYE_STATUE
; ==============================================================================
partCode0d:
	jr z,@normalStatus
	call objectSetVisible83
	ld h,d
	ld l,$c6
	ld (hl),$2d
	ld l,Part.subid
	ld a,(hl)
	ld b,a
	and $07
	ld hl,$ccba
	call setFlag
	bit 7,b
	jr z,@normalStatus
	ld e,Part.state
	ld a,$02
	ld (de),a
@normalStatus:
	ld e,Part.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw objectSetVisible83
@state0:
	ld a,$01
	ld (de),a
	ret
@state1:
	call partCommon_decCounter1IfNonzero
	ret nz
	ld e,Part.subid
	ld a,(de)
	ld hl,$ccba
	call unsetFlag
	jp objectSetInvisible


partCode16:
	jr z,@normalStatus
	ld h,d
	ld l,$c4
	ld (hl),$02
	ld l,$c6
	ld (hl),$14
	ld l,$e4
	ld (hl),$00
	call getThisRoomFlags
	and $c0
	cp $80
	jr nz,+
	ld a,(wScrollMode)
	and $01
	jr z,+
	ld a,(wLinkDeathTrigger)
	or a
	jp nz,@normalStatus
	call func_6515
	inc a
	ld (wDisableScreenTransitions),a
	ld ($cca4),a
	ld ($cbca),a
	inc a
	ld ($cfd0),a
	ld a,$08
	ld ($cfc0),a
+
	ld a,$01
	ld ($cc36),a
@normalStatus:
	ld hl,$cfd0
	ld a,(hl)
	inc a
	jp z,partDelete
	ld e,$c4
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
@state0:
	ld a,$01
	ld (de),a
@state1:
	ld a,(wLinkObjectIndex)
	ld h,a
	ld l,$00
	call preventObjectHFromPassingObjectD
	jp objectSetPriorityRelativeToLink_withTerrainEffects
@state2:
	call @state1
	ld hl,$cfd0
	ld a,(hl)
	cp $02
	ret z
	ld e,$c5
	ld a,(de)
	or a
	jr nz,+
	call partCommon_decCounter1IfNonzero
	ret nz
	ld (hl),$b4
	inc l
	ld (hl),$08
	ld l,$f0
	ld (hl),$08
	ld l,e
	inc (hl)
	ret
+
	call partCommon_decCounter1IfNonzero
	jr nz,+
	ld a,($cd00)
	and $01
	jr z,+
	ld a,($cc34)
	or a
	jp nz,+
	call func_6515
	inc a
	ld (wDisableScreenTransitions),a
	ld ($cfd0),a
	ld (wDisabledObjects),a
	ld ($cbca),a
+
	ldi a,(hl)
	cp $5a
	jr nz,+
	ld e,$f0
	ld a,$04
	ld (de),a
+
	dec (hl)
	ret nz
	ld e,$f0
	ld a,(de)
	ld (hl),a
	ld l,$dc
	ld a,(hl)
	dec a
	xor $01
	inc a
	ld (hl),a
	ret

func_6515:
	ld a,(wLinkObjectIndex)
	ld b,a
	ld c,$2b
	ld a,$80
	ld (bc),a
	ld c,$2d
	xor a
	ld (bc),a
	ret


; ==============================================================================
; PARTID_SHOOTING_DRAGON_HEAD
; ==============================================================================
partCode24:
	jr z,@normalStatus
	ld e,$ea
	ld a,(de)
	cp $80
	jp nz,partDelete
@normalStatus:
	ld e,$c2
	ld a,(de)
	ld e,$c4
	rst_jumpTable
	.dw @subid0
	.dw @subid1
	.dw @subid2
@subid0:
@subid1:
	ld a,(de)
	or a
	jr z,@func_656b
	call partCommon_decCounter1IfNonzero
	ret nz
	ld l,$c2
	bit 0,(hl)
	ld l,$cd
	ldh a,(<hEnemyTargetX)
	jr nz,@func_654f
	cp (hl)
	ret c
	jr +

@func_654f:
	cp (hl)
	ret nc
+
	call func_65b8
	ret nc
	call getRandomNumber_noPreserveVars
	cp $50
	ret nc
	call func_65a6
	ret nz
	ld l,$c9
	ld (hl),$08
	ld e,$c2
	ld a,(de)
	or a
	ret z
	ld (hl),$18
	ret
@func_656b:
	ld h,d
	ld l,e
	inc (hl)
	ld l,$c6
	inc (hl)
	ret
@subid2:
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
@state0:
	ld h,d
	ld l,e
	inc (hl)
	ld l,$c6
	ld (hl),$10
	ld l,$e4
	set 7,(hl)
	jp objectSetVisible81
@state1:
	call partCommon_decCounter1IfNonzero
	jr nz,+
	ld l,e
	inc (hl)
@state2:
	call partCode.partCommon_checkTileCollisionOrOutOfBounds
	jp c,partDelete
+
	call objectApplySpeed
	ld a,(wFrameCounter)
	and $03
	ret nz
	ld e,$dc
	ld a,(de)
	inc a
	and $07
	ld (de),a
	ret

func_65a6:
	call getFreePartSlot
	ret nz
	ld (hl),PARTID_SHOOTING_DRAGON_HEAD
	inc l
	ld (hl),$02
	call objectCopyPosition
	ld l,$d0
	ld (hl),$3c
	xor a
	ret

func_65b8:
	ld l,$cb
	ldh a,(<hEnemyTargetY)
	sub (hl)
	add $10
	cp $21
	ret nc
	ld e,$c6
	ld a,$1e
	ld (de),a
	ret


; ==============================================================================
; PARTID_WALL_ARROW_SHOOTER
; ==============================================================================
partCode25:
	ld e,$c4
	ld a,(de)
	or a
	jr nz,+
	ld h,d
	ld l,e
	inc (hl)
	ld l,$c2
	ld a,(hl)
	swap a
	rrca
	ld l,$c9
	ld (hl),a
+
	call partCommon_decCounter1IfNonzero
	ret nz
	ld e,$c2
	ld a,(de)
	bit 0,a
	ld e,$cd
	ldh a,(<hEnemyTargetX)
	jr z,+
	ld e,$cb
	ldh a,(<hEnemyTargetY)
+
	ld b,a
	ld a,(de)
	sub b
	add $10
	cp $21
	ret nc
	ld e,$c6
	ld a,$21
	ld (de),a
	ld hl,table_6661
	jr func_6649


; ==============================================================================
; PARTID_CANNON_ARROW_SHOOTER
; ==============================================================================
partCode2c:
	ld e,$c4
	ld a,(de)
	or a
	jr nz,label_10_270
	ld h,d
	ld l,e
	inc (hl)
	ld l,$c2
	ld a,(hl)
	ld b,a
	swap a
	rrca
	ld l,$c9
	ld (hl),a
	ld a,b
	call partSetAnimation
	call getRandomNumber_noPreserveVars
	and $30
	ld e,$c6
	ld (de),a
	call objectMakeTileSolid
	jp objectSetVisible82
label_10_270:
	ldh a,(<hCameraY)
	add $80
	ld b,a
	ld e,$cb
	ld a,(de)
	cp b
	ret nc
	ldh a,(<hCameraX)
	add $a0
	ld b,a
	ld e,$cd
	ld a,(de)
	cp b
	ret nc
	call partCommon_decCounter1IfNonzero
	ret nz
	call getRandomNumber_noPreserveVars
	and $60
	add $20
	ld e,$c6
	ld (de),a
	ld hl,table_6669

func_6649:
	ld e,$c2
	ld a,(de)
	rst_addDoubleIndex
	ldi a,(hl)
	ld b,a
	ld c,(hl)
	call getFreePartSlot
	ret nz
	ld (hl),PARTID_ENEMY_ARROW
	inc l
	inc (hl)
	call objectCopyPositionWithOffset
	ld l,$c9
	ld e,l
	ld a,(de)
	ld (hl),a
	ret

table_6661:
	.db $fc $00 ; shooting up
	.db $00 $04 ; shooting right
	.db $04 $00 ; shooting down
	.db $00 $fc ; shooting left

table_6669:
	.db $f8 $00
	.db $00 $08
	.db $08 $00
	.db $00 $f8


; ==============================================================================
; PARTID_WALL_FLAME_SHOOTERS_FLAMES
; ==============================================================================
partCode26:
	jr z,@normalStatus
	ld e,$ea
	ld a,(de)
	res 7,a
	cp $03
	jp nc,seasonsFunc_10_670c
@normalStatus:
	call func_66e7
	jp c,seasonsFunc_10_670c
	ld e,$c4
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
@state0:
	ld h,d
	ld l,e
	inc (hl)
	ld l,$d0
	ld (hl),$46
	ld l,$c6
	ld (hl),$16
	ld l,$c9
	ld (hl),$10
	ld a,$73
	call playSound
	jp objectSetVisible82
@state1:
	call partCommon_decCounter1IfNonzero
	jr nz,+
	ld (hl),$10
	ld l,e
	inc (hl)
	jr $26
+
	ld a,(hl)
	rrca
	jr nc,@func_66bd
	ld l,$d0
	ld a,(hl)
	cp $78
	jr z,@func_66bd
	add $05
	ld (hl),a
@func_66bd:
	call objectApplySpeed
	call partAnimate
	ld e,$e1
	ld a,(de)
	ld hl,@table_66d2
	rst_addAToHl
	ld e,$e6
	ld a,(hl)
	ld (de),a
	inc e
	ld a,(hl)
	ld (de),a
	ret
@table_66d2:
	.db $02 $04 $06
@state2:
	call partCode.partCommon_decCounter1IfNonzero
	jp z,partDelete
	ld a,(hl)
	rrca
	jr nc,@func_66bd
	ld l,$d0
	ld a,(hl)
	sub $0a
	ld (hl),a
	jr @func_66bd

func_66e7:
	ld e,$e6
	ld a,(de)
	add $09
	ld b,a
	ld e,$e7
	ld a,(de)
	add $09
	ld c,a
	ld hl,$dd0b
	ld e,$cb
	ld a,(de)
	sub (hl)
	add b
	sla b
	inc b
	cp b
	ret nc
	ld l,$0d
	ld e,$cd
	ld a,(de)
	sub (hl)
	add c
	sla c
	inc c
	cp c
	ret

seasonsFunc_10_670c:
	call objectCreatePuff
	jp partDelete


; ==============================================================================
; PARTID_BURIED_MOLDORM
; ==============================================================================
partCode2b:
	jr z,@normalStatus
	ld e,$ea
	ld a,(de)
	cp $9a
	ret nz
	ld hl,$cfc0
	set 0,(hl)
	jp partDelete
@normalStatus:
	ld e,$c4
	ld a,(de)
	or a
	ret nz
	inc a
	ld (de),a
	ld h,d
	ld l,$e7
	ld (hl),$12
	ld l,$ff
	set 5,(hl)
	ret


; ==============================================================================
; PARTID_KING_MOBLINS_CANNONS
; ==============================================================================
partCode2d:
	jr z,@normalStatus
	ld h,d
	ld l,$f0
	bit 0,(hl)
	jp nz,seasonsFunc_10_67cc
	inc (hl)
	ld l,$e9
	ld (hl),$00
	ld l,$c6
	ld (hl),$41
	jp objectSetInvisible
@normalStatus:
	ld e,$c2
	ld a,(de)
	srl a
	ld e,$c4
	rst_jumpTable
	.dw @subid0
	.dw @subid1
@subid0:
	ld a,(de)
	or a
	jr nz,@func_6775

@func_6759:
	ld h,d
	ld l,e
	inc (hl)
	ld l,$cb
	res 3,(hl)
	ld l,$cd
	res 3,(hl)
	ld a,GLOBALFLAG_MOBLINS_KEEP_DESTROYED
	call checkGlobalFlag
	jp nz,partDelete
	ld e,$c2
	ld a,(de)
	call partSetAnimation
	jp objectSetVisible82
@func_6775:
	call partAnimate
	ld e,$e1
	ld a,(de)
	or a
	ret z
	ld bc,$fa13
	dec a
	jr z,func_67a4
	jr func_6797
@subid1:
	ld a,(de)
	or a
	jr z,@func_6759
	call partAnimate
	ld e,$e1
	ld a,(de)
	or a
	ret z
	ld bc,$faed
	dec a
	jr z,func_67a4
func_6797:
	call getFreePartSlot
	ret nz
	ld (hl),PARTID_KING_MOBLIN_BOMB
	inc l
	inc (hl)
	call objectCopyPositionWithOffset
	jr func_67b7
func_67a4:
	ld (de),a
	ld a,$81
	call playSound
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERACID_PUFF
	ld l,$42
	ld (hl),$80
	jp objectCopyPositionWithOffset
func_67b7:
	ld e,$c2
	ld a,(de)
	bit 1,a
	ld b,$04
	jr z,+
	ld b,$12
+
	call getRandomNumber
	and $06
	add b
	ld l,$c9
	ld (hl),a
	ret

seasonsFunc_10_67cc:
	call partCommon_decCounter1IfNonzero
	jp z,partDelete
	ld a,(hl)
	cp $35
	jr z,func_67f8
	and $0f
	ret nz
	ld a,(hl)
	and $f0
	swap a
	dec a
	ld hl,table_67f0
	rst_addDoubleIndex
	ldi a,(hl)
	ld c,(hl)
	ld b,a
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERACID_EXPLOSION
	jp objectCopyPositionWithOffset
table_67f0:
	.db $f8 $04 $08 $fe
	.db $fa $f8 $02 $0c
func_67f8:
	ld e,$cb
	ld a,(de)
	sub $08
	and $f0
	ld b,a
	ld e,$cd
	ld a,(de)
	sub $08
	and $f0
	swap a
	or b
	ld c,a
	ld b,$a2
	ld e,$c2
	ld a,(de)
	bit 1,a
	jr z,+
	ld b,$a6
+
	push bc
	ld a,b
	call setTile
	pop bc
	ld a,b
	inc a
	inc c
	jp setTile


partCode2e:
	ld e,$c4
	ld a,(de)
	or a
	jr z,++
	ld e,$e1
	ld a,(de)
	or a
	jr z,+
	bit 7,a
	jp nz,partDelete
	call func_6853
+
	jp partAnimate
++
	ld a,$01
	ld (de),a
	call objectGetTileAtPosition
	cp $f3
	jp z,partDelete
	ld h,$ce
	ld a,(hl)
	or a
	jp nz,partDelete
	ld a,SND_POOF
	call playSound
	jp objectSetVisible83
	
func_6853:
	push af
	xor a
	ld (de),a
	call objectGetTileAtPosition
	pop af
	ld e,$f0
	dec a
	jr z,+
	ld a,(de)
	ld (hl),a
	ret
+
	ld a,(hl)
	ld (de),a
	ld (hl),$f3
	ret


partCode2f:
	ld e,$c4
	ld a,(de)
	or a
	ret nz
	inc a
	ld (de),a
	ld e,$cb
	ld a,(de)
	sub $02
	ld (de),a
	ld e,$cd
	ld a,(de)
	add $03
	ld (de),a
	ret

; ==============================================================================
; PARTID_POPPABLE_BUBBLE
; ==============================================================================
partCode32:
	jr z,@normalStatus
	ld e,$c5
	ld a,(de)
	or a
	jr nz,func_68d5
	call func_68cc
	ld a,$af
	jp playSound
@normalStatus:
	ld e,$c4
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
@state0:
	ld a,$01
	ld (de),a
	ld e,$c2
	ld a,(de)
	call partSetAnimation
	call getRandomNumber_noPreserveVars
	and $03
	ld hl,@table_68b9
	rst_addAToHl
	ld a,(hl)
	ld e,$d0
	ld (de),a
	call getRandomNumber_noPreserveVars
	and $3f
	add $78
	ld h,d
	ld l,$c6
	ldi (hl),a
	ld (hl),$10
	jp objectSetVisible81
@table_68b9:
	.db $0a $0f $0f $14
@state1:
	ld e,$c5
	ld a,(de)
	or a
	jr nz,func_68d5
	call objectApplySpeed
	call partCommon_decCounter1IfNonzero
	jp nz,seasonsFunc_10_68e0

func_68cc:
	ld h,d
	ld l,$c5
	inc (hl)
	ld a,$02
	jp partSetAnimation

func_68d5:
	call partAnimate
	ld e,$e1
	ld a,(de)
	inc a
	jp z,partDelete
	ret

seasonsFunc_10_68e0:
	ld h,d
	ld l,$c7
	dec (hl)
	ret nz
	ld (hl),$10
	call getRandomNumber
	and $03
	ret nz
	and $01
	jr nz,+
	ld a,$ff
+
	ld l,$c9
	add (hl)
	ld (hl),a
	ret


partCode33:
	ld e,$c4
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
@state0:
	ld h,d
	ld l,e
	inc (hl)
	ld l,$d0
	ld (hl),$50
	ld b,$00
	ld a,($cc45)
	and $30
	jr z,+
	ld b,$20
	and $20
	jr z,+
	ld b,$e0
+
	ld a,($d00d)
	add b
	ld c,a
	sub $08
	cp $90
	jr c,+
	ld c,$08
	cp $d0
	jr nc,+
	ld c,$98
+
	ld b,$a0
	call objectGetRelativeAngle
	ld e,$c9
	ld (de),a
	jp objectSetVisible81
@state1:
	call objectApplySpeed
	ld e,$cb
	ld a,(de)
	cp $98
	jr c,@animate
	ld h,d
	ld l,$c4
	inc (hl)
	ld l,$c6
	ld (hl),$78
@animate:
	jp partAnimate
@state2:
	call partCommon_decCounter1IfNonzero
	jp z,partDelete
	jr @animate


partCode38:
	ld e,$d7
	ld a,(de)
	or a
	jp z,partDelete
	ld e,$c4
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3
@state0:
	ld h,d
	ld l,e
	inc (hl)
	ld l,$d0
	ld (hl),$50
	ld l,$c6
	ld (hl),$14
	ld a,$08
	call objectGetRelatedObject1Var
	ld a,(hl)
	or a
	jp z,objectSetVisible82
	jp objectSetVisible81
@state1:
	call partCommon_decCounter1IfNonzero
	ret nz
	ld l,e
	inc (hl)
	call objectSetVisible81
@state2:
	ld h,d
	ld l,$f0
	ld b,(hl)
	inc l
	ld c,(hl)
	call objectGetRelativeAngle
	ld e,$c9
	ld (de),a
	ld h,d
	ld l,$f0
	ld e,$cb
	ld a,(de)
	sub (hl)
	add $08
	cp $11
	jr nc,@applySpeedAndAnimate
	ld l,$f1
	ld e,$cd
	ld a,(de)
	sub (hl)
	add $08
	cp $11
	jr nc,@applySpeedAndAnimate
	ld l,$c4
	inc (hl)
@applySpeedAndAnimate:
	call objectApplySpeed
	jp partAnimate
@state3:
	ld a,$0b
	call objectGetRelatedObject2Var
	push hl
	ld b,(hl)
	ld l,$8d
	ld c,(hl)
	call objectGetRelativeAngle
	ld e,$c9
	ld (de),a
	pop hl
	ld e,$cb
	ld a,(de)
	sub (hl)
	add $04
	cp $09
	jr nc,@applySpeedAndAnimate
	ld l,$8d
	ld e,$cd
	ld a,(de)
	sub (hl)
	add $04
	cp $09
	jr nc,@applySpeedAndAnimate
	ld a,$18
	call objectGetRelatedObject1Var
	xor a
	ldi (hl),a
	ld (hl),a
	jp partDelete


partCode39:
	ld e,$c4
	ld a,(de)
	or a
	jr nz,+
	ld h,d
	ld l,e
	inc (hl)
	ld l,$cb
	ld a,(hl)
	sub $1a
	ld (hl),a
	ld l,$c6
	ld (hl),$20
	ld l,$d0
	ld (hl),$3c
	call objectSetVisible80
	ld a,$bf
	jp playSound
+
	ld e,$d7
	ld a,(de)
	inc a
	jp z,partDelete
	call func_6a28
	ret nz
	call partCode.partCommon_checkOutOfBounds
	jp z,partDelete
	ld a,(wFrameCounter)
	rrca
	jr c,+
	ld e,$dc
	ld a,(de)
	xor $07
	ld (de),a
+
	jp objectApplySpeed

func_6a28:
	ld e,$c6
	ld a,(de)
	or a
	ret z
	ld a,$1a
	call objectGetRelatedObject1Var
	bit 7,(hl)
	jp z,partDelete
	call partCommon_decCounter1IfNonzero
	dec a
	ld b,$01
	cp $17
	jr z,+
	or a
	jp nz,partAnimate
	ld h,d
	ld l,$e4
	set 7,(hl)
	call objectGetAngleTowardEnemyTarget
	ld e,$c9
	ld (de),a
	ld a,$be
	call playSound
	ld b,$02
+
	ld a,b
	call partSetAnimation
	or d
	ret


partCode3a:
	jr z,@normalStatus
	ld e,$ea
	ld a,(de)
	res 7,a
	cp $04
	jp c,partDelete
	jp func_6bdd
@normalStatus:
	ld e,$c2
	ld a,(de)
	ld e,$c4
	rst_jumpTable
	.dw @subid0
	.dw @subid1
	.dw @subid2
	.dw @subid3
@subid0:
	ld a,(de)
	or a
	jr z,+
@func_6a7e:
	call partCode.partCommon_checkOutOfBounds
	jp z,partDelete
	call objectApplySpeed
	jp partAnimate
+
	call func_6be3
	call objectGetAngleTowardEnemyTarget
	ld e,$c9
	ld (de),a
	call func_6bf0
	jp objectSetVisible80
@subid1:
	ld a,(de)
	or a
	jr nz,@func_6a7e
	call func_6be3
	call func_6bc2
	ld e,$c3
	ld a,(de)
	or a
	ret nz
	call objectGetAngleTowardEnemyTarget
	ld e,$c9
	ld (de),a
	sub $02
	and $1f
	ld b,a
	ld e,$01
@func_6ab5:
	call getFreePartSlot
	ld (hl),PARTID_3a
	inc l
	ld (hl),e
	inc l
	inc (hl)
	ld l,$c9
	ld (hl),b
	ld l,$d6
	ld e,l
	ld a,(de)
	ldi (hl),a
	inc e
	ld a,(de)
	ld (hl),a
	jp objectCopyPosition
@subid2:
	ld a,(de)
	rst_jumpTable
	.dw @@state0
	.dw @@state1
	.dw @@state2
	.dw @func_6a7e
@@state0:
	ld h,d
	ld l,$db
	ld a,$03
	ldi (hl),a
	ld (hl),a
	ld l,$c3
	ld a,(hl)
	or a
	jr z,+
	ld l,e
	ld (hl),$03
	call func_6bf0
	ld a,$01
	call partSetAnimation
	jp objectSetVisible82
+
	call func_6be3
	ld l,$f0
	ldh a,(<hEnemyTargetY)
	ldi (hl),a
	ldh a,(<hEnemyTargetX)
	ld (hl),a
	ld a,$29
	call objectGetRelatedObject1Var
	ld a,(hl)
	ld b,$19
	cp $10
	jr nc,+
	ld b,$2d
	cp $0a
	jr nc,+
	ld b,$41
+
	ld e,$d0
	ld a,b
	ld (de),a
	jp objectSetVisible80
@@state1:
	ld h,d
	ld l,$f0
	ld b,(hl)
	inc l
	ld c,(hl)
	ld l,$cb
	ldi a,(hl)
	ldh (<hFF8F),a
	inc l
	ld a,(hl)
	ldh (<hFF8E),a
	sub c
	add $02
	cp $05
	jr nc,@@func_6b4d
	ldh a,(<hFF8F)
	sub b
	add $02
	cp $05
	jr nc,@@func_6b4d
	ldbc INTERACID_PUFF $02
	call objectCreateInteraction
	ret nz
	ld e,$d8
	ld a,$40
	ld (de),a
	inc e
	ld a,h
	ld (de),a
	ld e,$c4
	ld a,$02
	ld (de),a
	jp objectSetInvisible
@@func_6b4d:
	call objectGetRelativeAngleWithTempVars
	ld e,$c9
	ld (de),a
	call objectApplySpeed
	jp partAnimate
@@state2:
	ld a,$21
	call objectGetRelatedObject2Var
	bit 7,(hl)
	ret z
	ld b,$05
	call checkBPartSlotsAvailable
	ret nz
	ld c,$05
-
	ld a,c
	dec a
	ld hl,@@table_6b8b
	rst_addAToHl
	ld b,(hl)
	ld e,$02
	call @func_6ab5
	dec c
	jr nz,-
	ld h,d
	ld l,$c4
	inc (hl)
	ld l,$c9
	ld (hl),$1d
	call func_6bf0
	ld a,$01
	call partSetAnimation
	jp objectSetVisible82
@@table_6b8b:
	.db $03 $08 $0d $13 $18

@subid3:
	ld a,(de)
	or a
	jr z,++
	call partCommon_decCounter1IfNonzero
	jp z,func_6bdd
	inc l
	dec (hl)
	jr nz,+
	ld (hl),$07
	call objectGetAngleTowardEnemyTarget
	call objectNudgeAngleTowards
+
	call objectApplySpeed
	jp partAnimate
++
	call func_6be3
	ld l,$c6
	ld (hl),$f0
	inc l
	ld (hl),$07
	ld l,$db
	ld a,$02
	ldi (hl),a
	ld (hl),a
	call objectGetAngleTowardEnemyTarget
	ld e,$c9
	ld (de),a
func_6bc2:
	ld a,$29
	call objectGetRelatedObject1Var
	ld a,(hl)
	ld b,$1e
	cp $10
	jr nc,+
	ld b,$2d
	cp $0a
	jr nc,+
	ld b,$3c
+
	ld e,$d0
	ld a,b
	ld (de),a
	jp objectSetVisible80
func_6bdd:
	call objectCreatePuff
	jp partDelete
func_6be3:
	ld h,d
	ld l,e
	inc (hl)
	ld l,$cf
	ld a,(hl)
	ld (hl),$00
	ld l,$cb
	add (hl)
	ld (hl),a
	ret
func_6bf0:
	ld a,$29
	call objectGetRelatedObject1Var
	ld a,(hl)
	ld b,$3c
	cp $10
	jr nc,+
	ld b,$5a
	cp $0a
	jr nc,+
	ld b,$78
+
	ld e,$d0
	ld a,b
	ld (de),a
	ret


partCode3b:
	ld e,$c4
	ld a,(de)
	or a
	jr nz,+
	inc a
	ld (de),a
+
	ld a,$01
	call objectGetRelatedObject1Var
	ld a,(hl)
	cp $7e
	jp nz,partDelete
	ld l,$a4
	ld a,(hl)
	and $80
	ld b,a
	ld e,$e4
	ld a,(de)
	and $7f
	or b
	ld (de),a
	ld l,$b7
	bit 2,(hl)
	jr z,+
	res 7,a
	ld (de),a
+
	ld l,$8b
	ld b,(hl)
	ld l,$8d
	ld c,(hl)
	ld l,$88
	ld a,(hl)
	cp $04
	jr c,+
	sub $04
	add a
	inc a
+
	add a
	ld hl,seasonsTable_10_6c5b
	rst_addDoubleIndex
	ld e,$cb
	ldi a,(hl)
	add b
	ld (de),a
	ld e,$cd
	ldi a,(hl)
	add c
	ld (de),a
	ld e,$e6
	ldi a,(hl)
	ld (de),a
	inc e
	ld a,(hl)
	ld (de),a
	xor a
	ret
seasonsTable_10_6c5b:
	.db $f8 $06
	.db $06 $02
	.db $02 $0c
	.db $02 $06
	.db $09 $fa
	.db $06 $02
	.db $02 $f4
	.db $02 $06


partCode3c:
	ld e,$c4
	ld a,(de)
	or a
	jr z,@state0
	ld bc,$0104
	call partCommon_decCounter1IfNonzero
	jr z,@delete
	ld a,(hl)
	cp $46
	jr z,+
	ld bc,$0206
	cp $28
	jp nz,partAnimate
+
	ld l,$e6
	ld (hl),c
	inc l
	ld (hl),c
	ld a,b
	jp partSetAnimation
@delete:
	pop hl
	jp partDelete
@state0:
	ld h,d
	ld l,e
	inc (hl)
	ld l,$c6
	ld (hl),$64
	jp objectSetVisible83


partCode3d:
	ld e,$c4
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3
@state0:
	ld h,d
	ld l,e
	inc (hl)
	ld e,$c2
	ld a,(de)
	or a
	jr nz,+
	ld l,$d4
	ld a,$40
	ldi (hl),a
	ld (hl),$ff
	ld l,$d0
	ld (hl),$3c
+
	inc e
	ld a,(de)
	or a
	jr z,+
	ld l,$c4
	inc (hl)
	ld l,$e4
	res 7,(hl)
	ld l,$c6
	ld (hl),$1e
	call @func_6cf4
+
	jp objectSetVisiblec1
@state1:
	call partCode.partCommon_checkOutOfBounds
	jp z,partDelete
	call objectApplySpeed
	ld c,$0e
	call objectUpdateSpeedZ_paramC
	jr nz,@animate
	ld l,$c4
	inc (hl)
	ld l,$c6
	ld (hl),$a0
	ld l,$e6
	ld (hl),$05
	inc l
	ld (hl),$04
	call func_6e13
@func_6cf4:
	ld a,$6f
	call playSound
	ld a,$01
	jp partSetAnimation
@state2:
	call partCommon_decCounter1IfNonzero
	jr nz,@animate
	ld (hl),$14
	ld l,e
	inc (hl)
	ld a,$02
	jp partSetAnimation
@state3:
	call partCommon_decCounter1IfNonzero
	jp z,partDelete
@animate:
	jp partAnimate


partCode3e:
	jr z,@normalStatus
	ld e,$ea
	ld a,(de)
	cp $9a
	jr nz,@normalStatus
	ld h,d
	ld l,$c2
	ld (hl),$01
	ld l,$e4
	res 7,(hl)
	ld l,$c6
	ld (hl),$96
	ld l,$c4
	ld a,$03
	ld (hl),a
	call partSetAnimation
@normalStatus:
	ld e,$c4
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3
	.dw @state4
@state0:
	ld h,d
	ld l,e
	inc (hl)
	ld l,$c3
	ld a,(hl)
	or a
	ld a,$1e
	jr nz,@func_6d87
	ld l,$f0
	ldh a,(<hEnemyTargetY)
	ldi (hl),a
	ldh a,(<hEnemyTargetX)
	ld (hl),a
	ld l,$d0
	ld (hl),$50
	ld l,$ff
	set 5,(hl)
	jp objectSetVisible83
@state1:
	ld h,d
	ld l,$f0
	ld b,(hl)
	inc l
	ld c,(hl)
	ld l,$cb
	ldi a,(hl)
	ldh (<hFF8F),a
	inc l
	ld a,(hl)
	ldh (<hFF8E),a
	sub c
	inc a
	cp $03
	jr nc,+
	ldh a,(<hFF8F)
	sub b
	inc a
	cp $03
	jr c,++
+
	call objectGetRelativeAngleWithTempVars
	ld e,$c9
	ld (de),a
	jp objectApplySpeed
++
	ld a,$a0
@func_6d87:
	ld l,$c6
	ld (hl),a
	ld l,e
	ld (hl),$03
	ld l,$e4
	set 7,(hl)
	ld a,$ab
	call playSound
	ld a,$01
	call partSetAnimation
	jp objectSetVisible81
@state2:
	inc e
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3
@substate0:
	xor a
	ld (wLinkGrabState2),a
	inc a
	ld (de),a
	jp objectSetVisible81
@substate1:
	call func_6e70
	ret z
	call dropLinkHeldItem
	jp partDelete
@substate2:
	call func_6e37
	jp c,partDelete
	ld e,$cf
	ld a,(de)
	or a
	ret nz
	ld e,$c5
	ld a,$03
	ld (de),a
	ret
@substate3:
	ld b,INTERACID_SNOWDEBRIS
	call objectCreateInteractionWithSubid00
	ret nz
	jp partDelete
@state3:
	call func_6e70
	jp nz,partDelete
	call partCommon_decCounter1IfNonzero
	jr z,+
	ld e,$c2
	ld a,(de)
	or a
	jp nz,seasonsFunc_10_6e6a
	call partAnimate
	jr ++
+
	ld l,$c4
	inc (hl)
	ld a,$02
	jp partSetAnimation
@state4:
	ld e,$e1
	ld a,(de)
	inc a
	jp z,partDelete
	call partAnimate
++
	ld e,$e1
	ld a,(de)
	cp $ff
	ret z
	ld hl,table_6e10
	rst_addAToHl
	ld e,$e6
	ld a,(hl)
	ld (de),a
	inc e
	ld (de),a
	ret
table_6e10:
	.db $02 $04 $06

func_6e13:
	ld e,$c2
	ld a,(de)
	cp $03
	ret nc
	call getFreePartSlot
	ret nz
	ld (hl),PARTID_3d
	inc l
	ld e,l
	ld a,(de)
	inc a
	ld (hl),a
	ld l,$c9
	ld e,l
	ld a,(de)
	ld (hl),a
	ld l,$d0
	ld (hl),$3c
	ld l,$d4
	ld a,$c0
	ldi (hl),a
	ld (hl),$ff
	jp objectCopyPosition
func_6e37:
	ld a,$00
	call objectGetRelatedObject1Var
	call checkObjectsCollided
	ret nc
	ld l,$82
	ld a,(hl)
	or a
	ret nz
	ld l,$ab
	ld a,(hl)
	or a
	ret nz
	ld (hl),$3c
	ld l,$b2
	ld (hl),$1e
	ld l,$a9
	ld a,(hl)
	sub $06
	ld (hl),a
	jr nc,+
	ld (hl),$00
	ld l,$a4
	res 7,(hl)
+
	ld a,$63
	call playSound
	ld a,$83
	call playSound
	scf
	ret

seasonsFunc_10_6e6a:
	call objectAddToGrabbableObjectBuffer
	jp objectPushLinkAwayOnCollision
func_6e70:
	ld a,$01
	call objectGetRelatedObject1Var
	ld a,(hl)
	cp $77
	ret z
	call objectCreatePuff
	or d
	ret


; ==============================================================================
; PARTID_KING_MOBLIN_BOMB
; ==============================================================================
partCode3f:
	jr z,@normalStatus
	ld e,$c2
	ld a,(de)
	or a
	jr nz,@normalStatus
	ld e,$ea
	ld a,(de)
	cp $95
	jr nz,@normalStatus
	ld h,d
	call kingMoblinBomb_explode
@normalStatus:
	ld e,$c2
	ld a,(de)
	ld e,$c4
	rst_jumpTable
	.dw kingMoblinBomb_subid0
	.dw kingMoblinBomb_subid1


kingMoblinBomb_subid0:
	ld a,(de)
	rst_jumpTable
	.dw kingMoblinBomb_state0
	.dw seasons_kingMoblinBomb_state1
	.dw kingMoblinBomb_state2
	.dw kingMoblinBomb_state3
	.dw kingMoblinBomb_state4
	.dw kingMoblinBomb_state5
	.dw kingMoblinBomb_state6
	.dw kingMoblinBomb_state7
	.dw kingMoblinBomb_state8


kingMoblinBomb_state0:
	ld h,d
	ld l,e
	inc (hl)
	
	ld l,Part.angle
	ld (hl),ANGLE_DOWN
	
	ld l,Part.speed
	ld (hl),SPEED_140
	
	ld l,Part.speedZ
	ld (hl),$00
	inc l
	ld (hl),$fe
	jp objectSetVisiblec2


seasons_kingMoblinBomb_state1:
	ret


; Being held by Link
kingMoblinBomb_state2:
	inc e
	ld a,(de)
	rst_jumpTable
	.dw @justGrabbed
	.dw @beingHeld
	.dw @released
	.dw @atRest

@justGrabbed:
	ld a,$01
	ld (de),a ; [substate] = 1
	xor a
	ld (wLinkGrabState2),a
.ifdef ROM_AGES
	call objectSetVisiblec1
.else
	jp objectSetVisiblec1
.endif

@beingHeld:
	call common_kingMoblinBomb_state1
	ret nz
	jp dropLinkHeldItem

@released:
	; Drastically reduce speed when Y < $30 (on moblin's platform), Z = 0,
	; and subid = 0.
	ld e,Part.yh
	ld a,(de)
	cp $30
	jr nc,@beingHeld

	ld h,d
	ld l,Part.zh
	ld e,Part.subid
	ld a,(de)
	or (hl)
	jr nz,@beingHeld

	; Reduce speed
	ld hl,w1ReservedItemC.speedZ+1
	sra (hl)
	dec l
	rr (hl)
	ld l,Item.speed
	ld (hl),SPEED_40

	jp common_kingMoblinBomb_state1

@atRest:
	ld e,Part.state
	ld a,$04
	ld (de),a

	call objectSetVisiblec2
	jr kingMoblinBomb_state4


; Being thrown. (King moblin sets the state to this.)
kingMoblinBomb_state3:
	ld c,$20
	call objectUpdateSpeedZAndBounce
	jr c,@doneBouncing

	call z,kingMoblinBomb_playSound
	jp objectApplySpeed

@doneBouncing:
	ld h,d
	ld l,Part.state
	inc (hl)
	call kingMoblinBomb_playSound


; Waiting to be picked up (by link or king moblin)
kingMoblinBomb_state4:
	call common_kingMoblinBomb_state1
	ret z
	jp objectAddToGrabbableObjectBuffer


; Exploding
kingMoblinBomb_state5:
	ld h,d
	ld l,Part.animParameter
	ld a,(hl)
	inc a
	jp z,partDelete

	dec a
	jr z,@animate

	ld l,Part.collisionRadiusY
	ldi (hl),a
	ld (hl),a
	call kingMoblinBomb_checkCollisionWithLink
	call kingMoblinBomb_checkCollisionWithKingMoblin
@animate:
	jp partAnimate


kingMoblinBomb_state6:
	ld bc,-$240
	call objectSetSpeedZ

	ld l,e
	inc (hl) ; [state] = 7

	ld l,Part.speed
	ld (hl),SPEED_c0

	ld l,Part.counter1
	ld (hl),$07

	; Decide angle to throw at based on king moblin's position
	ld a,Object.xh
	call objectGetRelatedObject1Var
	ld a,(hl)
	cp $50
	ld a,$07
	jr c,+
	ld a,$19
+
	ld e,Part.angle
	ld (de),a
	ret


kingMoblinBomb_state7:
	call partCommon_decCounter1IfNonzero
	ret nz

	ld l,e
	inc (hl) ; [state] = 8


kingMoblinBomb_state8:
	ld c,$20
	call objectUpdateSpeedZAndBounce
	jp nc,objectApplySpeed

	ld h,d
	jp kingMoblinBomb_explode


kingMoblinBomb_subid1:
	ld a,(de)
	rst_jumpTable
	.dw kingMoblinBomb_subid1_state0
	.dw kingMoblinBomb_subid1_state1
	.dw kingMoblinBomb_subid1_state2

kingMoblinBomb_subid1_state0:
	ld h,d
	ld l,e
	inc (hl)
	ld l,$d0
	ld (hl),$28
	ld l,$d4
	ld (hl),$20
	inc l
	ld (hl),$fe
	jp objectSetVisiblec2


kingMoblinBomb_subid1_state1:
	ld c,$20
	call objectUpdateSpeedZAndBounce
	jr c,@doneBouncing
	call z,kingMoblinBomb_playSound
	jp objectApplySpeed
@doneBouncing:
	ld h,d
	ld l,Part.state
	inc (hl)


kingMoblinBomb_playSound:
	ld a,SND_BOMB_LAND
	jp playSound


kingMoblinBomb_subid1_state2:
	ld h,d
	ld l,Part.animParameter
	bit 0,(hl)
	jp z,partAnimate
	ld (hl),$00
	ld l,Part.counter2
	inc (hl)
	ld a,(hl)
	cp $04
	jp c,partAnimate
	ld l,Part.subid
	dec (hl)
	jr kingMoblinBomb_explode


common_kingMoblinBomb_state1:
	ld h,d

	ld l,Part.animParameter
	bit 0,(hl)
	jr z,@animate

	ld (hl),$00
	ld l,Part.counter2
	inc (hl)

	ld a,(hl)
	cp $08
	jr nc,kingMoblinBomb_explode

@animate:
	jp partAnimate

	; Unused code snippet?
	or d
	ret

kingMoblinBomb_explode:
	ld l,Part.state
	ld (hl),$05

.ifdef ROM_SEASONS
	ld l,Part.collisionType
	res 7,(hl)
.endif

	ld l,Part.oamFlagsBackup
	ld a,$0a
	ldi (hl),a
	ldi (hl),a
	ld (hl),$0c ; [oamTileIndexBase]

	ld a,$01
	call partSetAnimation
	call objectSetVisible82
	ld a,SND_EXPLOSION
	call playSound
	xor a
	ret


;;
kingMoblinBomb_checkCollisionWithLink:
	ld e,Part.var30
	ld a,(de)
	or a
	ret nz

	call checkLinkVulnerable
	ret nc

	call objectCheckCollidedWithLink_ignoreZ
	ret nc

	call objectGetAngleTowardEnemyTarget

	ld hl,w1Link.knockbackCounter
	ld (hl),$10
	dec l
	ldd (hl),a ; [w1Link.knockbackAngle]
	ld (hl),20 ; [w1Link.invincibilityCounter]
	dec l
	ld (hl),$01 ; [w1Link.var2a] (TODO: what does this mean?)

	ld e,Part.damage
	ld l,<w1Link.damageToApply
	ld a,(de)
	ld (hl),a

	ld e,Part.var30
	ld a,$01
	ld (de),a
	ret


;;
kingMoblinBomb_checkCollisionWithKingMoblin:
	ld e,Part.relatedObj1+1
	ld a,(de)
	or a
	ret z

	; Check king moblin's collisions are enabled
	ld a,Object.collisionType
	call objectGetRelatedObject1Var
	bit 7,(hl)
	ret z

	ld l,Enemy.invincibilityCounter
	ld a,(hl)
	or a
	ret nz

	call checkObjectsCollided
	ret nc

	ld l,Enemy.var2a
	ld (hl),$80|ITEMCOLLISION_BOMB
	ld l,Enemy.invincibilityCounter
	ld (hl),30

	ld l,Enemy.health
	dec (hl)
	ret


; ==============================================================================
; PARTID_AQUAMENTUS_PROJECTILE
; ==============================================================================
partCode40:
	jp nz,partDelete
	ld e,$c4
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
@state0:
	ld h,d
	ld l,e
	inc (hl)
	ld l,$c6
	ld (hl),$28
	ld l,$d0
	ld (hl),$50
	ld e,$c2
	ld a,(de)
	or a
	jr z,func_7081
	ret
@state1:
	call partCommon_decCounter1IfNonzero
	ret nz
	ld l,e
	inc (hl)
	ld a,$00
	call objectGetRelatedObject1Var
	ld bc,$f0f0
	call objectTakePositionWithOffset
	jp objectSetVisible80
@state2:
	call objectApplySpeed
	call partCommon_checkOutOfBounds
	jp z,partDelete
	ld a,(wFrameCounter)
	xor d
	rrca
	ret nc
	ld e,$dc
	ld a,(de)
	inc a
	and $03
	ld (de),a
	ret
func_7081:
	call objectGetAngleTowardEnemyTarget
	ld e,$c9
	ld (de),a
	ld c,$03
	call func_708e
	ld c,$fd
func_708e:
	call getFreePartSlot
	ret nz
	ld (hl),PARTID_AQUAMENTUS_PROJECTILE
	inc l
	inc (hl)
	call objectCopyPosition
	ld l,$c9
	ld e,l
	ld a,(de)
	add c
	and $1f
	ld (hl),a
	ld l,$d6
	ld e,l
	ld a,(de)
	ldi (hl),a
	ld e,l
	ld a,(de)
	ld (hl),a
	ret


; ==============================================================================
; PARTID_DODONGO_FIREBALL
; ==============================================================================
partCode41:
	ld e,$c4
	ld a,(de)
	or a
	jr z,@state0
	call objectApplySpeed
	call objectCheckWithinScreenBoundary
	jp nc,partDelete
	jp partAnimate
@state0:
	ld h,d
	ld l,$c4
	inc (hl)
	ld l,$d0
	ld (hl),$78
	ld l,$cb
	ld a,$04
	add (hl)
	ld (hl),a
	ld l,$c9
	ld a,(hl)
	bit 3,a
	ld e,$cb
	jr z,+
	ld e,$cd
+
	swap a
	rlca
	ld b,a
	ld hl,table_70f3
	rst_addAToHl
	ld a,(de)
	add (hl)
	ld (de),a
	ld a,b
	call partSetAnimation
	ld a,$72
	call playSound
	ld e,$c9
	ld a,(de)
	or a
	jp z,objectSetVisible82
	jp objectSetVisible81
table_70f3:
	.db $ee $12 $10 $ee


; ==============================================================================
; PARTID_MOTHULA_PROJECTILE_2
; ==============================================================================
partCode42:
	jr z,@normalStatus
	ld e,$ea
	ld a,(de)
	res 7,a
	cp $04
	jr c,@delete
@normalStatus:
	ld e,$c4
	ld a,(de)
	or a
	jr z,@state0
	call partCode.partCommon_checkTileCollisionOrOutOfBounds
	jr z,@delete
	ld e,$c2
	ld a,(de)
	cp $02
	jr z,+
	call partCommon_decCounter1IfNonzero
	jr nz,+
	inc l
	ld e,$f0
	ld a,(de)
	inc a
	and $01
	ld (de),a
	add (hl)
	ldd (hl),a
	ld (hl),a
	ld l,$c9
	ld a,(hl)
	add $02
	and $1f
	ld (hl),a
+
	call objectApplySpeed
	call partAnimate
	ld e,$e1
	ld a,(de)
	inc a
	ret nz
@delete:
	jp partDelete
@state0:
	call func_7174
	ret nz
	call objectSetVisible82
	ld h,d
	ld l,$c4
	inc (hl)
	ld e,$c2
	ld a,(de)
	cp $02
	jr nz,+
	ld l,$cf
	ld a,(hl)
	ld (hl),$00
	ld l,$cb
	add (hl)
	ld (hl),a
	ld l,$d0
	ld (hl),$32
	ret
+
	ld l,$cf
	ld a,(hl)
	ld (hl),$fa
	add $06
	ld l,$cb
	add (hl)
	ld (hl),a
	ld l,$d0
	ld (hl),$78
	ld l,$c6
	ld a,$02
	ldi (hl),a
	ld (hl),a
	ld a,$01
	jp partSetAnimation
func_7174:
	ld e,$c2
	ld a,(de)
	bit 7,a
	jr z,func_71b5
	rrca
	ld a,$04
	ld bc,$0300
	jr nc,+
	ld a,$03
	ld bc,$0503
+
	ld e,$c9
	ld (de),a
	ld e,$c2
	xor a
	ld (de),a
	push bc
	call checkBPartSlotsAvailable
	pop bc
	ret nz
	ld a,b
	ldh (<hFF8B),a
	ld a,c
	ld bc,table_71fc
	call addAToBc
-
	push bc
	call getFreePartSlot
	ld (hl),PARTID_MOTHULA_PROJECTILE_2
	call objectCopyPosition
	pop bc
	ld l,$c9
	ld a,(bc)
	ld (hl),a
	inc bc
	ld hl,$ff8b
	dec (hl)
	jr nz,-
	ret
func_71b5:
	dec a
	jr z,+
	xor a
	ret
+
	ld b,$05
	call checkBPartSlotsAvailable
	ret nz
	ld a,$09
	call objectGetRelatedObject1Var
	ld a,(hl)
	add $08
	and $1f
	ld b,a
	ld c,$02
	ld h,d
	ld l,$c9
	sub c
	and $1f
	ld (hl),a
	ld l,$c2
	ld (hl),c
	call func_71e2
	ld a,b
	add $0c
	and $1f
	ld b,a
	ld c,$03

func_71e2:
	push bc
	call getFreePartSlot
	ld (hl),PARTID_MOTHULA_PROJECTILE_2
	inc l
	ld (hl),$02
	call objectCopyPosition
	pop bc
	ld l,$c9
	ld (hl),b
	ld a,b
	add $02
	and $1f
	ld b,a
	dec c
	jr nz,func_71e2
	ret
table_71fc:
	.db $0c $14 $1c $08
	.db $0d $13 $18 $1d


partCode43:
	ld e,$c2
	ld a,(de)
	ld e,$c4
	rst_jumpTable
	.dw @subid0
	.dw @subid1
	.dw @subid2
	.dw @subid3
	.dw @subid4
@subid0:
	ld a,(de)
	or a
	jr z,@func_724b
	call partAnimate
	call partCommon_decCounter1IfNonzero
	jp nz,objectApplyComponentSpeed
	ld b,$06
-
	ld a,b
	dec a
	ld hl,@table_7245
	rst_addAToHl
	ld c,(hl)
	call @func_7236
	dec b
	jr nz,-
	call objectCreatePuff
	jp partDelete
@func_7236:
	call getFreePartSlot
	ret nz
	ld (hl),PARTID_43
	inc l
	ld (hl),$03
	ld l,$c9
	ld (hl),c
	jp objectCopyPosition
@table_7245:
	.db $03 $08 $0d
	.db $13 $18 $1d

@func_724b:
	ld h,d
	ld l,e
	inc (hl)
	ld l,$dd
	ld (hl),$06
	dec l
	ld a,$0a
	ldd (hl),a
	ld (hl),a
	ld l,$cb
	ld a,(hl)
	add $06
	ld (hl),a
	ld l,$e6
	ld a,$05
	ldi (hl),a
	ld (hl),a
	ld l,$c6
	ld (hl),$0c
	ld l,$c9
	ld (hl),$10
	ld b,$50
	jr @subid1@func_729a
@subid1:
	ld a,(de)
	rst_jumpTable
	.dw @@state0
	.dw @@state1
	.dw @@state2
@@state0:
	ld h,d
	ld l,e
	inc (hl)
	ld l,$c6
	ld (hl),$04
	ld l,$e4
	res 7,(hl)
	ld l,$dd
	ld (hl),$06
	dec l
	ld a,$0a
	ldd (hl),a
	ld (hl),a
	ret
@@state1:
	call partCommon_decCounter1IfNonzero
	ret nz
	ld (hl),$b4
	ld l,e
	inc (hl)
	ld l,$e4
	set 7,(hl)
	ld b,$3c
@@func_729a:
	call func_733d
	call objectSetVisible81
	ld a,$72
	jp playSound
@@state2:
	call partCommon_decCounter1IfNonzero
	jp z,partDelete
	jp partAnimate
@subid2:
	ld a,(de)
	or a
	jr z,@func_72be

@seasonsFunc_10_72b2:
	call partCommon_checkOutOfBounds
	jp z,partDelete
	call objectApplyComponentSpeed
	jp partAnimate
@func_72be:
	ld b,$02
	call checkBPartSlotsAvailable
	ret nz
	ld h,d
	ld l,$c4
	inc (hl)
	ld l,$dd
	ld (hl),$06
	dec l
	ld a,$0a
	ldd (hl),a
	ld (hl),a
	ld l,$c9
	ld (hl),$10
	ld l,$cb
	ld a,(hl)
	add $06
	ld (hl),a
	ld b,$3c
	call @subid1@func_729a
	ld bc,$0213
	call @func_72e9
	ld bc,$030d
@func_72e9:
	call getFreePartSlot
	ld (hl),PARTID_43
	inc l
	ld (hl),$04
	inc l
	ld (hl),b
	ld l,$c9
	ld (hl),c
	jp objectCopyPosition
@subid3:
	ld a,(de)
	or a
	jr z,+
	call objectApplyComponentSpeed
	ld c,$12
	call objectUpdateSpeedZ_paramC
	jp nz,partAnimate
	jp partDelete
+
	ld bc,$ff20
	call objectSetSpeedZ
	ld l,e
	inc (hl)
	ld l,$e6
	ld (hl),$05
	inc l
	ld (hl),$02
	ld b,$3c
	call func_733d
	call objectSetVisible82
	ld a,$01
	jp partSetAnimation
@subid4:
	ld a,(de)
	or a
	jp nz,@seasonsFunc_10_72b2
	ld h,d
	ld l,e
	inc (hl)
	ld b,$3c
	call func_733d
	call objectSetVisible82
	ld e,$c3
	ld a,(de)
	jp partSetAnimation
func_733d:
	ld e,$c9
	ld a,(de)
	ld c,a
	call getPositionOffsetForVelocity
	ld e,$d0
	ldi a,(hl)
	ld (de),a
	inc e
	ldi a,(hl)
	ld (de),a
	inc e
	ldi a,(hl)
	ld (de),a
	inc e
	ldi a,(hl)
	ld (de),a
	ret


partCode44:
	jr z,@normalStatus
	ld e,$ea
	ld a,(de)
	cp $83
	jr z,++
	ld a,$01
	call objectGetRelatedObject1Var
	ld a,(hl)
	cp $7f
	jr nz,+
	ld l,$b6
	ld (hl),$01
+
	ld a,$13
	ld ($cc6a),a
	jr func_73db
++
	ld e,$c4
	ld a,$02
	ld (de),a
	ld e,$c9
	ld a,(de)
	xor $10
	ld (de),a
	call @func_73ae
	call objectGetAngleTowardEnemyTarget
	ld ($d02c),a
	ld a,$18
	ld ($d02d),a
	ld a,$52
	call playSound
@normalStatus:
	call partCommon_checkOutOfBounds
	jr z,func_73db
	ld e,$c4
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
@state0:
	ld a,$01
	ld (de),a
	call objectSetVisible82
	ld e,$c2
	ld a,(de)
	ld hl,table_73de
	rst_addAToHl
	ld e,$c9
	ld a,(hl)
	ld (de),a
@func_73ae:
	ld c,a
	ld b,$46
	ld a,$02
	jp objectSetComponentSpeedByScaledVelocity
@state1:
	call objectApplyComponentSpeed
	jp partAnimate
@state2:
	ld a,$00
	call objectGetRelatedObject1Var
	call checkObjectsCollided
	jr nc,@state1
	ld l,$ae
	ld (hl),$78
	dec l
	ld (hl),$18
	push hl
	call objectGetAngleTowardEnemyTarget
	pop hl
	dec l
	xor $10
	ld (hl),a
	ld a,$4e
	call playSound
func_73db:
	jp partDelete
table_73de:
	.db $02 $04 $06 $08
	.db $0a $0c $0e $10
	.db $12 $14 $16 $18
	.db $1a $1c $1e $00


partCode45:
	jr z,@normalStatus
	dec a
	jr nz,@delete
	ld e,$ea
	ld a,(de)
	cp $80
	jr nz,@delete
@normalStatus:
	ld e,$c2
	ld a,(de)
	or a
	ld e,$c4
	ld a,(de)
	jr z,@func_742e
	or a
	jr z,+
	call objectCheckSimpleCollision
	jp z,objectApplyComponentSpeed
@delete:
	jp partDelete
+
	ld h,d
	ld l,e
	inc (hl)
	ld l,$e4
	set 7,(hl)
	ld a,$0b
	call objectGetRelatedObject1Var
	ld bc,$0f00
	call objectTakePositionWithOffset
	xor a
	ld (de),a
	ld bc,$5010
	ld a,$08
	call objectSetComponentSpeedByScaledVelocity
	jp objectSetVisible82
@func_742e:
	or a
	jr nz,+
	inc a
	ld (de),a
+
	ld a,$29
	call objectGetRelatedObject1Var
	ld a,(hl)
	or a
	jr z,@delete
	ld l,$ae
	ld a,(hl)
	or a
	ret nz
	call getFreePartSlot
	ret nz
	ld (hl),PARTID_S_45
	inc l
	inc (hl)
	ld l,$d6
	ld e,l
	ld a,(de)
	ldi (hl),a
	ld e,l
	ld a,(de)
	ld (hl),a
	ret


partCode46:
	jr nz,@delete
	ld e,$c2
	ld a,(de)
	or a
	jr z,@subid0
	ld e,$c4
	ld a,(de)
	rst_jumpTable
	.dw @subid1@state0
	.dw @subid1@state1
	.dw @subid1@state2
@subid0:
	ld a,$29
	call objectGetRelatedObject1Var
	ld a,(hl)
	or a
	jr z,@delete
	ld l,$84
	ld a,(hl)
	cp $0a
	jr nz,@delete
	ld l,$ae
	ld a,(hl)
	or a
	ret nz
	ld e,$c4
	ld a,(de)
	rst_jumpTable
	.dw @@state0
	.dw @@state1
	.dw @@state2
	.dw @@state3
	.dw @@state4
@@state0:
	ld h,d
	ld l,e
	inc (hl)
	ld l,$c6
	ld (hl),$1e
@@state1:
	call partCommon_decCounter1IfNonzero
	ret nz
	ld l,e
	inc (hl)
@@state2:
	ld b,$03
	call func_7517
	ret nz
	ld a,b
	sub $08
	and $1f
	ld b,a
	call func_74fd
	call func_74fd
	call func_74fd
	ld a,$ba
	call playSound
	ld h,d
	ld l,$c4
	inc (hl)
	ld l,$c6
	ld (hl),$1e
@@state3:
@@state4:
	call partCommon_decCounter1IfNonzero
	ret nz
	ld l,e
	inc (hl)
	ld b,$02
	call func_7517
	ret nz
	ld a,b
	sub $06
	and $1f
	ld b,a
	call func_74fd
	call func_74fd
	ld a,$ba
	call playSound
@delete:
	jp partDelete

@subid1:
@@state0:
	ld h,d
	ld l,e
	inc (hl)
	ld l,$e4
	set 7,(hl)
	ld l,$d0
	ld (hl),$64
	ld l,$c6
	ld (hl),$08
	call func_7524
	call objectSetVisible82
@@state1:
	call partCommon_decCounter1IfNonzero
	jr nz,+
	ld l,e
	inc (hl)
@@state2:
	call objectCheckSimpleCollision
	jr nz,@delete
+
	call objectApplySpeed
	jp partAnimate
func_74fd:
	call getFreePartSlot
	ret nz
	ld (hl),PARTID_S_46
	inc l
	inc (hl)
	ld l,$c9
	ld a,b
	add $04
	and $1f
	ld (hl),a
	ld b,a
	ld l,$d6
	ld e,l
	ld a,(de)
	ldi (hl),a
	ld e,l
	ld a,(de)
	ld (hl),a
	ret
func_7517:
	call checkBPartSlotsAvailable
	ret nz
	call func_7524
	call objectGetAngleTowardEnemyTarget
	ld b,a
	xor a
	ret
func_7524:
	ld a,$0b
	call objectGetRelatedObject1Var
	ld bc,$0a00
	call objectTakePositionWithOffset
	xor a
	ld (de),a
	ret


; PARTID_47
partCode47:
	ld e,$c2
	ld a,(de)
	ld e,$c4
	rst_jumpTable
	.dw @subid0
	.dw @subid1
	.dw @subid2
	.dw @subid3
	.dw @subid4

@subid0:
	ld b,$04
	call checkBPartSlotsAvailable
	ret nz
	ld b,$04
	ld e,$d7
	ld a,(de)
	ld c,a
	call @func_7566
	ld (hl),$80
	ld c,h
	dec b
-
	call @func_7566
	ld (hl),$c0
	dec b
	jr nz,-
	ld a,$19
	call objectGetRelatedObject1Var
	ld (hl),c
	jp partDelete

@func_7566:
	call getFreePartSlot
	ld (hl),PARTID_47
	inc l
	ld a,$05
	sub b
	ld (hl),a
	call objectCopyPosition
	ld l,$d7
	ld (hl),c
	dec l
	ret

@subid1:
	ld b,$02
	call @func_777f
	ld l,$a9
	ld a,(hl)
	or a
	ld e,$c4
	jr z,+
	ld a,(de)
	rst_jumpTable
	.dw @@state0
	.dw @@state1
	.dw @@state2
	.dw @@state3
	.dw @@state4
	.dw @@state5
	.dw @@state6
	.dw @@state7
	.dw @@state8
+
	ld a,(de)
	cp $08
	ret z
	ld h,d
	ld l,$e4
	res 7,(hl)
	ld l,$da
	ld a,(hl)
	xor $80
	ld (hl),a
	ret

@@state0:
	inc e
	ld a,(de)
	rst_jumpTable
	.dw @@@substate0
	.dw @@@substate1
	.dw @@@substate2
	.dw @@@substate3
	.dw @@@substate4

@@@substate0:
	ld h,d
	ld l,e
	inc (hl)
	ld l,$d4
	ld a,$20
	ldi (hl),a
	ld (hl),$ff
	ld l,$c9
	ld (hl),$10
	ld l,$d0
	ld (hl),$78
	ld l,$cb
	ld a,$18
	ldi (hl),a
	inc l
	ld (hl),$78
	ld l,$f0
	ldi (hl),a
	ld (hl),$78
	jp objectSetVisible82

@@@substate1:
	ld c,$0e
	call objectUpdateSpeedZ_paramC
	jr z,+
	call objectApplySpeed
	ld e,$cb
	ld a,(de)
	sub $18
	ld e,$f3
	ld (de),a
	ret
+
	ld l,$c5
	inc (hl)
	inc l
	ld a,$3c
	ld (hl),a
	call setScreenShakeCounter
	ld a,$6f
	call playSound
	jp @func_776f

@@@substate2:
	call partCommon_decCounter1IfNonzero
	ret nz
	ld l,e
	inc (hl)
	ld l,$d0
	ld a,$80
	ldi (hl),a
	ld (hl),$ff
	ret

@@@substate3:
	call objectApplyComponentSpeed
	ld e,$cb
	ld a,(de)
	cp $18
	ret nc
	ld e,$c5
	ld a,$04
	ld (de),a
	jp objectSetInvisible

@@@substate4:
	ret

@@state1:
	ld h,d
	ld l,e
	inc (hl)
	ld l,$e4
	set 7,(hl)
	ld l,$c9
	ld (hl),$12
	ld l,$d4
	ld a,$00
	ldi (hl),a
	ld (hl),$fe
	call objectSetVisible82

@@state2:
	ld h,d
	ld l,$c9
	ld a,(hl)
	cp $1e
	jr nz,@@state3
	ld l,e
	inc (hl)
	call objectSetVisible81

@@state3:
	ld a,(wFrameCounter)
	and $0f
	ld a,$a4
	call z,playSound
	ld e,$c9
	ld a,(de)
	inc a
	and $1f
	ld (de),a
	and $0f
	ld hl,@table_775f
	rst_addAToHl
	ld e,$f3
	ld a,(hl)
	ld (de),a
	ld bc,$e605
-
	ld a,$0b
	call objectGetRelatedObject1Var
	ldi a,(hl)
	add b
	ld b,a
	ld e,$f0
	ld (de),a
	inc l
	ld a,(hl)
	add c
	ld c,a
	inc e
	ld (de),a
	ld e,$f3
	ld a,(de)
	ld e,$c9
	jp objectSetPositionInCircleArc

@@state4:
	ld a,(wFrameCounter)
	and $07
	ld a,$a4
	call z,playSound
	ld e,$c9
	ld a,(de)
	inc a
	and $1f
	ld (de),a
	ld bc,$e009
	jr -

@@state5:
	call partCommon_decCounter1IfNonzero
	jr nz,+
	ld (hl),$02
	ld l,$c9
	inc (hl)
	ld a,(hl)
	cp $15
	jr z,++
	ld c,a
	ld b,$5a
	ld a,$03
	call objectSetComponentSpeedByScaledVelocity
+
	jp objectApplyComponentSpeed
++
	ld l,e
	inc (hl)
	ld l,$c6
	ld a,$3c
	ld (hl),a
	ld l,$e8
	ld (hl),$fc
	call setScreenShakeCounter
	call @func_776f
	ld a,$6f
	jp playSound

@@state6:
	call partCommon_decCounter1IfNonzero
	ret nz
	ld l,e
	inc (hl)
	ld l,$d0
	ld (hl),$1e
	ret

@@state7:
	ld h,d
	ld l,$f0
	ld b,(hl)
	inc l
	ld c,(hl)
	ld l,$cb
	ldi a,(hl)
	ldh (<hFF8F),a
	inc l
	ld a,(hl)
	ldh (<hFF8E),a
	cp c
	jr nz,+
	ldh a,(<hFF8F)
	cp b
	jr nz,+
	ld l,e
	inc (hl)
	ld l,$e4
	res 7,(hl)
	jp objectSetInvisible
+
	call objectGetRelativeAngleWithTempVars
	ld e,$c9
	ld (de),a
	jp objectApplySpeed

@@state8:
	ld a,$04
	call objectGetRelatedObject1Var
	ld a,(hl)
	cp $0a
	ret nz
	ld e,$c4
	ld a,$01
	ld (de),a
	ret

@subid2:
	ld a,(de)
	or a
	jr z,@func_7726
	ld b,$47
	call @func_777f
	call @func_778b
	ld a,e
	add a
	add e
	add b
	ld e,$cb
	ld (de),a
	ld a,l
	add a
	add l
	add c
	ld e,$cd
	ld (de),a

@func_7719:
	ld a,$1a
	call objectGetRelatedObject1Var
	bit 7,(hl)
	jp nz,objectSetVisible82
	jp objectSetInvisible

@func_7726:
	inc a
	ld (de),a
	call partSetAnimation
	jr @func_7719

@subid3:
	ld a,(de)
	or a
	jr z,@func_7726
	ld b,$47
	call @func_777f
	call @func_778b
	ld a,e
	add a
	add b
	ld e,$cb
	ld (de),a
	ld a,l
	add a
	add c
	ld e,$cd
	ld (de),a
	jr @func_7719

@subid4:
	ld a,(de)
	or a
	jr z,@func_7726
	ld b,$47
	call @func_777f
	call @func_778b
	ld a,e
	add b
	ld e,$cb
	ld (de),a
	ld a,l
	add c
	ld e,$cd
	ld (de),a
	jr @func_7719

@table_775f:
	.db $10 $11 $12 $14 $16 $1a $1e $22
	.db $28 $22 $1e $1a $16 $14 $12 $11

@func_776f:
	call getFreePartSlot
	ret nz
	ld (hl),PARTID_48
	inc l
	ld (hl),$02
	ld l,$d6
	ld a,$c0
	ldi (hl),a
	ld (hl),d
	ret

@func_777f:
	ld a,$01
	call objectGetRelatedObject1Var
	ld a,(hl)
	cp b
	ret z
	pop hl
	jp partDelete

@func_778b:
	ld a,$30
	call objectGetRelatedObject1Var
	ld b,(hl)
	inc l
	ld c,(hl)
	ld l,$cb
	ldi a,(hl)
	sub b
	sra a
	sra a
	ld e,a
	inc l
	ld a,(hl)
	sub c
	sra a
	sra a
	ld l,a
	ret


; PARTID_48
partCode48:
	ld e,$c2
	ld a,(de)
	ld e,$c4
	rst_jumpTable
	.dw @subid0
	.dw @subid1
	.dw @subid2
	.dw @subid3
	.dw @subid4
	.dw @subid5

@subid0:
	ld a,(de)
	or a
	jr z,+
	call partCommon_decCounter1IfNonzero
	jp z,partDelete
	ld a,(hl)
	and $0f
	ret nz
	call getFreePartSlot
	ret nz
	ld (hl),PARTID_48
	inc l
	inc (hl)
	ret
+
	ld h,d
	ld l,e
	inc (hl)
	ld l,$c6
	ld (hl),$96
	ret

@subid1:
	ld a,(de)
	rst_jumpTable
	.dw @@state0
	.dw @@state1
	.dw @@state2

@@state0:
	ld h,d
	ld l,e
	inc (hl)
	ld l,$e4
	set 7,(hl)
	ldh a,(<hCameraY)
	ld b,a
	ldh a,(<hCameraX)
	ld c,a
	call getRandomNumber
	ld e,a
	and $07
	swap a
	add $28
	add c
	ld l,$cd
	ld (hl),a
	ld a,e
	and $70
	add $08
	ld e,a
	add b
	ld l,$cb
	ld (hl),a
	ld a,e
	cpl
	inc a
	sub $07
	ld l,$cf
	ld (hl),a
	jp objectSetVisiblec1

@@state1:
	ld c,$20
	call objectUpdateSpeedZ_paramC
	jr nz,+
	call objectReplaceWithAnimationIfOnHazard
	jp c,partDelete
	ld h,d
	ld l,$c4
	inc (hl)
	ld l,$db
	ld a,$0b
	ldi (hl),a
	ldi (hl),a
	ld (hl),$02
	ld a,$a5
	call playSound
	ld a,$01
	call partSetAnimation

@@state2:
	ld e,$e1
	ld a,(de)
	bit 7,a
	jp nz,partDelete
	ld hl,@table_7847
	rst_addAToHl
	ld e,$e6
	ldi a,(hl)
	ld (de),a
	inc e
	ld a,(hl)
	ld (de),a
+
	jp partAnimate

@table_7847:
	.db $04 $09 $06 $0b $09
	.db $0c $0a $0d $0b $0e

@subid2:
	ld b,$06
	call checkBPartSlotsAvailable
	ret nz
	ld a,$00
	call objectGetRelatedObject1Var
	call objectTakePosition
	ld b,$06
-
	call getFreePartSlot
	ld (hl),PARTID_48
	inc l
	ld (hl),$03
	ld l,$c9
	ld (hl),b
	call objectCopyPosition
	dec b
	jr nz,-
	jp partDelete

@subid3:
	ld a,(de)
	or a
	jr z,+
	ld c,$18
	call objectUpdateSpeedZ_paramC
	jp z,partDelete
	jp objectApplySpeed
+
	ld h,d
	ld l,e
	inc (hl)
	ld l,$e4
	set 7,(hl)
	ld l,$db
	ld a,$0b
	ldi (hl),a
	ldi (hl),a
	ld a,$02
	ld (hl),a
	ld l,$e6
	ldi (hl),a
	ld (hl),a
	ld l,$e8
	ld (hl),$fc
	ld l,$d0
	ld (hl),$50
	ld l,$d4
	ld a,$20
	ldi (hl),a
	ld (hl),$ff
	ld l,$c9
	ld a,(hl)
	dec a
	ld bc,@table_78bb
	call addAToBc
	ld a,(bc)
	ld (hl),a
	ld a,$02
	call partSetAnimation
	jp objectSetVisible82

@table_78bb:
	.db $04 $08 $0d
	.db $16 $1a $1e

@subid4:
	ld a,(de)
	or a
	jr z,+
	call partCommon_decCounter1IfNonzero
	jp z,partDelete
	ld a,(hl)
	and $0f
	ret nz
	call getFreePartSlot
	ret nz
	ld (hl),PARTID_48
	inc l
	ld (hl),$05
	ret
+
	ld h,d
	ld l,e
	inc (hl)
	ld l,$c6
	ld (hl),$61
	ret

@subid5:
	ld a,(de)
	rst_jumpTable
	.dw @@state0
	.dw @@state1
	.dw @@state2

@@state0:
	ld h,d
	ld l,e
	inc (hl)
	ld l,$cb
	ld (hl),$28
	call getRandomNumber_noPreserveVars
	and $7f
	cp $40
	jr c,+
	add $20
+
	ld e,$cd
	ld (de),a
	jp objectSetVisible82

@@state1:
	ld h,d
	ld l,$d4
	ld e,$ca
	call add16BitRefs
	cp $a0
	jr nc,+
	dec l
	ld a,(hl)
	add $10
	ldi (hl),a
	ld a,(hl)
	adc $00
	ld (hl),a
	ret
+
	ld h,d
	ld l,$c4
	inc (hl)
	ld l,$db
	ld a,$0b
	ldi (hl),a
	ldi (hl),a
	ld (hl),$02
	ld a,$a5
	call playSound
	ld a,$01
	call partSetAnimation

@@state2:
	ld e,$e1
	ld a,(de)
	bit 7,a
	jp nz,partDelete
	jp partAnimate


; PARTID_49
partCode49:
	ld e,Part.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2

@state0:
	ld h,d
	ld l,Part.state
	inc (hl)
	ld l,Part.speed
	ld (hl),SPEED_2c0
	ld l,Part.counter1
	ld (hl),$3c
	jp objectSetVisible81

@state1:
	call partCommon_decCounter1IfNonzero
	jr nz,@animate
	ld l,e
	inc (hl)
	ld a,SND_WIND
	call playSound
	call objectGetAngleTowardEnemyTarget
	ld e,Part.angle
	ld (de),a

@state2:
	call partCode.partCommon_checkOutOfBounds
	jp z,partDelete
	call objectApplySpeed
@animate:
	jp partAnimate


partCode4a:
	jp nz,partDelete
	ld e,Part.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
	
@state0:
	ld h,d
	ld l,e
	inc (hl)
	ld l,$d0
	ld (hl),$5a
	ld l,$e6
	ld a,$04
	ldi (hl),a
	ld (hl),a
	jp objectSetVisible81
	
@state1:
	call seasonsFunc_10_79ab
	ld e,$cb
	ld a,(de)
	cp $88
	jr c,@animate
	ld e,$c4
	ld a,$02
	ld (de),a
@animate:
	jp partAnimate
	
@state2:
	call objectApplySpeed
	ld e,$cb
	ld a,(de)
	cp $b8
	jr c,@animate
	jp partDelete
	
seasonsFunc_10_79ab:
	ld e,$f1
	ld a,(de)
	ld c,a
	ld b,$9a
	call objectGetRelativeAngle
	ld e,$c9
	ld (de),a
	jp objectApplySpeed


; ==============================================================================
; PARTID_DIN_CRYSTAL
; ==============================================================================
partCode4f:
	jr z,@normalStatus
	ld e,Part.state
	ld a,(de)
	cp $06
	jr nc,@normalStatus
	ld e,Part.var2a
	ld a,(de)
	res 7,a
	cp $04
	jr c,@normalStatus
	cp $0c
	jp z,seasonsFunc_10_7bc2
	cp $20
	jr nz,+
	ld a,Object.collisionType
	call objectGetRelatedObject2Var
	res 7,(hl)
	ld e,Part.var33
	ld a,$01
	ld (de),a
+
	ld h,d
	ld l,Part.health
	ld (hl),$40
	ld l,Part.var32
	ld (hl),$3c

@normalStatus:
	ld e,Part.subid
	ld a,(de)
	ld e,Part.state
	rst_jumpTable
	.dw @subid0
	.dw @subid1
	
@subid0:
	ld h,d
	ld l,Part.var32
	ld a,(hl)
	or a
	jr z,+
	dec (hl)
	jr nz,+
	ld l,Part.collisionType
	set 7,(hl)
+
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @stateStub
	.dw @state3
	.dw @state4
	.dw @state5
	.dw @state6
	.dw @state7

@state0:
	call getFreePartSlot
	ret nz
	ld (hl),PARTID_SHADOW
	inc l
	ld (hl),$00
	inc l
	ld (hl),$08
	ld l,Part.relatedObj1
	ld a,$c0
	ldi (hl),a
	ld (hl),d
	ld a,$0f
	ld (wLinkForceState),a
	ld h,d
	ld l,Part.state
	inc (hl)
	ld l,Part.yh
	ld (hl),$50
	ld l,Part.xh
	ld (hl),$78
	ld l,Part.zh
	ld (hl),$fc
	jp objectSetVisible82

@state1:
	inc e
	ld a,(de)
	rst_jumpTable
	.dw @@substate0
	.dw @@substate1
	.dw @@substate2

@@substate0:
	ld a,(w1Link.yh)
	cp $78
	jp nc,partAnimate
	ld a,$01
	ld (de),a
	ld a,SND_TELEPORT
	call playSound

@@substate1:
	ld b,$04
	call checkBPartSlotsAvailable
	ret nz
	ld bc,$0404
-
	call getFreePartSlot
	ld (hl),PARTID_DIN_CRYSTAL
	inc l
	inc (hl)
	ld l,Part.angle
	ld (hl),c
	call objectCopyPosition
	ld a,c
	add $08
	ld c,a
	dec b
	jr nz,-
	ld h,d
	ld l,Part.substate
	inc (hl)
	; counter1
	inc l
	ld (hl),$5a
	ld l,Part.zh
	ld (hl),$00
	jp objectSetInvisible

@@substate2:
	call partCommon_decCounter1IfNonzero
	ret nz
	call getFreeEnemySlot
	ret nz
	ld (hl),ENEMYID_GENERAL_ONOX
	ld e,Part.relatedObj2
	ld a,$80
	ld (de),a
	inc e
	ld a,h
	ld (de),a

	ld l,Enemy.relatedObj1
	ld a,$c0
	ldi (hl),a
	ld (hl),d

	ld h,d
	ld l,Part.state
	inc (hl)
	; substate
	inc l
	ld (hl),$00
	ret

@stateStub:
	ret

@state3:
	ld h,d
	ld l,Part.zh
	inc (hl)
	ld a,(hl)
	cp $fc
	jr c,@animate
	ld l,e
	inc (hl)
	ld l,Part.collisionType
	set 7,(hl)
	ld l,Part.speed
	ld (hl),SPEED_80
@animate:
	jp partAnimate

@state4:
	ld a,$01
	call objectGetRelatedObject2Var
	ld a,(hl)
	cp $02
	jr nz,+++
	call seasonsFunc_10_7bd6
	ld l,$8b
	ldi a,(hl)
	srl a
	ld b,a
	ld a,(w1Link.yh)
	srl a
	add b
	ld b,a
	inc l
	ld a,(hl)
	srl a
	ld c,a
	ld a,(w1Link.xh)
	srl a
	add c
	ld c,a
	ld e,$cd
	ld a,(de)
	ldh (<hFF8E),a
	ld e,$cb
	ld a,(de)
	ldh (<hFF8F),a
	sub b
	add $04
	cp $09
	jr nc,+
	ldh a,(<hFF8E)
	sub c
	add $04
	cp $09
	jr c,@animate
	ld a,(wFrameCounter)
	and $1f
	jr nz,++
+
	call objectGetRelativeAngleWithTempVars
	ld e,$c9
	ld (de),a
++
	call objectApplySpeed
	jr @animate
+++
	ld h,d
	ld l,$c4
	ld e,l
	ld (hl),$06
	inc l
	ld (hl),$00
	ld l,$f2
	ld (hl),$00
	ld l,$e4
	res 7,(hl)
	ret

@state5:
	call seasonsFunc_10_7bd6
	call partCommon_decCounter1IfNonzero
	jr z,+
	call objectCheckTileCollision_allowHoles
	call nc,objectApplySpeed
	jr @animate
+
	ld l,$c4
	dec (hl)
	ld l,$d0
	ld (hl),$14
	jr @animate

@state6:
	inc e
	ld a,(de)
	rst_jumpTable
	.dw @@substate0
	.dw @@substate1
	.dw @state1@substate1
	.dw @@substate3

@@substate0:
	ld h,d
	ld l,e
	inc (hl)
	ld l,$e6
	ld a,$10
	ldi (hl),a
	ld (hl),a
	ret

@@substate1:
	call objectCheckCollidedWithLink
	jr nc,+
	ld e,$c5
	ld a,$02
	ld (de),a
	ld a,$8d
	call playSound
+
	jp partAnimate

@@substate3:
	ld h,d
	ld l,$c4
	inc (hl)
	ld l,$c6
	ld a,$3c
	ld (hl),a
	call setScreenShakeCounter

@state7:
	call partCommon_decCounter1IfNonzero
	ret nz
	ld a,$0f
	ld (hl),a
	call setScreenShakeCounter
--
	call getRandomNumber_noPreserveVars
	and $0f
	cp $0d
	jr nc,--
	inc a
	ld c,a
	push bc
-
	call getRandomNumber_noPreserveVars
	and $0f
	cp $09
	jr nc,-
	pop bc
	inc a
	swap a
	or c
	ld c,a
	ld b,$ce
	ld a,(bc)
	or a
	jr nz,--
	ld a,$48
	call breakCrackedFloor
	ld e,$c7
	ld a,(de)
	inc a
	cp $75
	jp z,partDelete
	ld (de),a
	ret
	
@subid1:
	ld a,(de)
	or a
	jr nz,+
	ld h,d
	ld l,e
	inc (hl)
	ld l,Part.counter1
	ld (hl),$5a
	ld l,Part.speed
	ld (hl),SPEED_60
+
	call partCommon_decCounter1IfNonzero
	jp z,partDelete
	ld l,Part.visible
	ld a,(hl)
	xor $80
	ld (hl),a
	jp objectApplySpeed

seasonsFunc_10_7bc2:
	ld h,d
	ld l,Part.counter1
	ld (hl),$78
	ld l,Part.knockbackAngle
	ld a,(hl)
	ld l,Part.angle
	ld (hl),a
	ld l,Part.state
	ld (hl),$05
	ld l,Part.speed
	ld (hl),SPEED_200
	ret

seasonsFunc_10_7bd6:
	ld e,Part.var33
	ld a,(de)
	or a
	ret z
	ld a,(wIsLinkBeingShocked)
	or a
	ret nz
	ld (de),a
	ld a,Object.health
	call objectGetRelatedObject2Var
	ld a,(hl)
	or a
	ret z
	ld l,Enemy.collisionType
	set 7,(hl)
	ret
