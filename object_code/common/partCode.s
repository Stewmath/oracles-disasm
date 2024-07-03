; ==============================================================================
; PARTID_ITEM_DROP
;
; Variables:
;   relatedObj1: ?
;   var30: ID of relatedObj1
;   var31/var32: Position to move towards?
;   var33: Counter until collisions are enabled (fairy only)
;   var34: Set to $01 when it hits water in a sidescrolling area
; ==============================================================================
partCode01:
	jr z,@normalStatus
	cp PARTSTATUS_DEAD
	jp z,@linkCollectedItem

	; PARTSTATUS_JUST_HIT
	ld e,Part.state
	ld a,$03
	ld (de),a

@normalStatus:
	call @checkCollidedWithLink
	ld e,Part.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3

@state0:
	ld a,(wIsMaplePresent)
	or a
	jp nz,partDelete

	ld e,Part.subid
	ld a,(de)
	cp ITEM_DROP_100_RUPEES_OR_ENEMY
	jr nz,@normalItem

	call getRandomNumber_noPreserveVars
	cp $e0
	jp c,itemDrop_spawnEnemy
.ifdef ROM_SEASONS
	ld a,(wTilesetFlags)
	cp (TILESETFLAG_SUBROSIA|TILESETFLAG_OUTDOORS)
	jp z,partDelete
.endif

@normalItem:
	call itemDrop_initGfx

	ld h,d
	ld l,Part.speedZ
	ld a,<(-$160)
	ldi (hl),a
	ld (hl),>(-$160)

	ld l,Part.state
	inc (hl) ; [state] = 1

	ld a,(wTilesetFlags)
	and TILESETFLAG_SIDESCROLL
	jr z,@label_11_008

	; Sidescrolling only
	inc (hl) ; [state] = 2
	ld l,Part.collisionType
	set 7,(hl)
	ld l,Part.counter1
	ld (hl),240
	call objectCheckIsOnHazard
	jr nc,@label_11_008
	rrca
	jr nc,@label_11_008

	; On water
	ld e,Part.var34
	ld a,$01
	ld (de),a

	; Back to common code for either sidescrolling or normal rooms
@label_11_008:
	ld e,Part.subid
	ld a,(de)
	call itemDrop_initSpeed
	ld e,Part.subid
	ld a,(de)
	jp partSetAnimation

@state1:
	call partCommon_getTileCollisionInFront_allowHoles
	call nc,itemDrop_updateSpeed
	ld c,$20
	call objectUpdateSpeedZAndBounce
	jr c,@doneBouncing
	call itemDrop_checkHitGround
	jr nc,@label_11_010

@doneBouncing:
	ld h,d
	ld l,Part.state
	inc (hl) ; [state] = 2
	ld l,Part.counter1
	ld (hl),240
	call objectSetVisiblec3

@label_11_010:
.ifdef ROM_SEASONS
	call itemDrop_pullOreChunksWithMagnetGloves
	jr c,+
.endif
	call itemDrop_checkOnHazard
	ret c
+
	ld e,Part.zh
	ld a,(de)
	rlca
	ret c

	; On solid ground; check for conveyor tiles
	ld bc,$0500
	call objectGetRelativeTile
	ld hl,itemDropConveyorTilesTable
	call lookupCollisionTable
	ret nc
	ld c,a
	ld b,SPEED_80
	jp itemDrop_applySpeed

; Item has stopped bouncing; waiting to be picked up
@state2:
	call itemDrop_checkSidescrollingConditions
	call itemDrop_moveTowardPoint
	jp c,@reachedPoint
	call itemDrop_countdownToDisappear
	jp c,partDelete
	ld e,Part.subid
	ld a,(de)
	or a ; ITEM_DROP_FAIRY
	jr nz,@label_11_010
	jp itemDrop_updateFairyMovement

@reachedPoint:
	ld h,d
	ld l,Part.var31
	ldi a,(hl)
	ld c,(hl)
	ld l,Part.yh
	ldi (hl),a
	inc l
	ld (hl),c ; [xh]
	jp partDelete


; Triggered by PARTSTATUS_JUST_HIT (ie. from a weapon or Link?)
@state3:
	ld e,Part.substate
	ld a,(de)
	or a
	call z,@getRelatedObj1ID
	call objectCheckCollidedWithLink_ignoreZ
	jp c,@linkCollectedItem

	ld a,Object.enabled
	call objectGetRelatedObject1Var
	ldi a,(hl)
	or a
	jr z,++
	ld e,Part.var30
	ld a,(de)
	cp (hl)
	jp z,objectTakePosition
++
	jp partDelete

@getRelatedObj1ID:
	ld h,d
	ld l,e
	inc (hl) ; [substate]
	ld l,Part.zh
	ld (hl),$00
	ld a,Object.id
	call objectGetRelatedObject1Var
	ld a,(hl)
	ld e,Part.var30
	ld (de),a
	jp objectSetVisible80


@checkCollidedWithLink:
	ld e,Part.collisionType
	ld a,(de)
	rlca
	ret nc
	call objectCheckCollidedWithLink
	ret nc

	pop hl ; Return from caller (about to delete self)

@linkCollectedItem:
	ld a,(wLinkDeathTrigger)
	or a
	jr nz,@deleteSelf

	ld e,Part.subid
	ld a,(de)
	add a
	ld hl,@itemDropTreasureTable
	rst_addDoubleIndex

	ldi a,(hl)
	or a
	jr z,@deleteSelf

	ld b,a
	ld a,GOLD_JOY_RING
	call cpActiveRing
	ldi a,(hl)
	jr z,@doubleDrop

	or a
	jr z,@giveDrop
	call cpActiveRing
	jr nz,@giveDrop

@doubleDrop:
	inc hl
@giveDrop:
	ld c,(hl)
	ld a,b
	call giveTreasure
	ld e,Part.subid
	ld a,(de)
	cp ITEM_DROP_50_ORE_CHUNKS
	jr nz,@deleteSelf
	call getThisRoomFlags
	set 5,(hl)
@deleteSelf:
	jp partDelete


; Data format:
;   b0: Treasure to give
;   b1: Ring to check for (in addition to gold joy ring)
;   b2: Amount to give without ring
;   b3: Amount to give with ring
@itemDropTreasureTable:
	.db TREASURE_HEART_REFILL,  BLUE_JOY_RING,  $18, $30 ; ITEM_DROP_FAIRY
	.db TREASURE_HEART_REFILL,  BLUE_JOY_RING,  $04, $08 ; ITEM_DROP_HEART
	.db TREASURE_RUPEES,        RED_JOY_RING,   RUPEEVAL_1, RUPEEVAL_2  ; ITEM_DROP_1_RUPEE
	.db TREASURE_RUPEES,        RED_JOY_RING,   RUPEEVAL_5, RUPEEVAL_10 ; ITEM_DROP_5_RUPEES
	.db TREASURE_BOMBS,         $00,            $04, $08 ; ITEM_DROP_BOMBS
	.db TREASURE_EMBER_SEEDS,   $00,            $05, $0a ; ITEM_DROP_EMBER_SEEDS
	.db TREASURE_SCENT_SEEDS,   $00,            $05, $0a ; ITEM_DROP_SCENT_SEEDS
	.db TREASURE_PEGASUS_SEEDS, $00,            $05, $0a ; ITEM_DROP_PEGASUS_SEEDS
	.db TREASURE_GALE_SEEDS,    $00,            $05, $0a ; ITEM_DROP_GALE_SEEDS
	.db TREASURE_MYSTERY_SEEDS, $00,            $05, $0a ; ITEM_DROP_MYSTERY_SEEDS
	.db $00,                    $00,            $00, $00 ; ITEM_DROP_0a
	.db $00,                    $00,            $00, $00 ; ITEM_DROP_0b
	.db TREASURE_ORE_CHUNKS,    GREEN_JOY_RING, RUPEEVAL_1,   RUPEEVAL_2   ; ITEM_DROP_1_ORE_CHUNK
	.db TREASURE_ORE_CHUNKS,    GREEN_JOY_RING, RUPEEVAL_10,  RUPEEVAL_20  ; ITEM_DROP_10_ORE_CHUNKS
	.db TREASURE_ORE_CHUNKS,    GREEN_JOY_RING, RUPEEVAL_50,  RUPEEVAL_100 ; ITEM_DROP_50_ORE_CHUNKS
	.db TREASURE_RUPEES,        RED_JOY_RING,   RUPEEVAL_100, RUPEEVAL_200 ; ITEM_DROP_100_RUPEES_OR_ENEMY


;;
itemDrop_initGfx:
	ld e,Part.subid
	ld a,(de)
	ld hl,@spriteData
	rst_addDoubleIndex
	ld e,Part.oamTileIndexBase
	ld a,(de)
	add (hl)
	ld (de),a
	inc hl
	dec e
	ld a,(hl)
	ld (de),a ; [Part.oamFlags]
	dec e
	ld (de),a ; [Part.oamFlagsBackup]
	jp objectSetVisiblec1


; Data format:
;   b0: Offset relative to oamTileIndexBase
;   b1: OAM flags
@spriteData:
	.db $00 $02 ; ITEM_DROP_FAIRY
	.db $02 $05 ; ITEM_DROP_HEART
	.db $04 $00 ; ITEM_DROP_1_RUPEE
	.db $06 $05 ; ITEM_DROP_5_RUPEES
	.db $10 $04 ; ITEM_DROP_BOMBS
	.db $12 $02 ; ITEM_DROP_EMBER_SEEDS
	.db $14 $03 ; ITEM_DROP_SCENT_SEEDS
	.db $16 $01 ; ITEM_DROP_PEGASUS_SEEDS
	.db $18 $01 ; ITEM_DROP_GALE_SEEDS
	.db $1a $00 ; ITEM_DROP_MYSTERY_SEEDS
	.db $1c $00 ; ITEM_DROP_0a
	.db $1e $00 ; ITEM_DROP_0b
	.db $0c $01 ; ITEM_DROP_1_ORE_CHUNK
	.db $0c $02 ; ITEM_DROP_10_ORE_CHUNKS
	.db $0c $03 ; ITEM_DROP_50_ORE_CHUNKS
	.db $08 $04 ; ITEM_DROP_100_RUPEES_OR_ENEMY


;;
; @param[out]	cflag	c if time to disappear
itemDrop_countdownToDisappear:
	ld a,(wFrameCounter)
	xor d
	rrca
	ret nc

	ld h,d
	ld l,Part.var33
	ld a,(hl)
	or a
	jr z,++

	; Fairy only: countdown until collisions are enabled
	dec (hl)
	ret nz
	ld l,Part.collisionType
	set 7,(hl)
++
	call partCommon_decCounter1IfNonzero
	jr z,@disappear

	; Flickering
	ld a,(hl)
	cp 60
	ret nc
	ld l,Part.visible
	ld a,(hl)
	xor $80
	ld (hl),a
	ret

@disappear:
	scf
	ret

;;
; @param	a	Subid
itemDrop_initSpeed:
	ld h,d
	or a
	jr z,@fairy
	ld e,Part.var03
	ld a,(de) ; Check if dug up from shovel?
	rrca
	ret nc
	ld l,Part.speed
	ld (hl),SPEED_a0
	ret

@fairy:
	ld l,Part.zh
	ld a,(hl)
	ld (hl),$00
	ld l,Part.yh
	add (hl)
	ld (hl),a
	jp itemDrop_chooseRandomFairyMovement

;;
itemDrop_updateSpeed:
	call objectCheckTileCollision_allowHoles
	ret c
	jp objectApplySpeed

;;
itemDrop_spawnEnemy:
	ld c,a
	ld a,(wDiggingUpEnemiesForbidden)
	or a
	jr nz,@delete

.ifdef ROM_SEASONS
	ld b,ENEMYID_PODOBOO_TOWER
	ld a,(wTilesetFlags)
	cp (TILESETFLAG_SUBROSIA|TILESETFLAG_OUTDOORS)
	jr z,+
.endif

	ld a,c
	and $07
	ld hl,@enemiesToSpawn
	rst_addAToHl
	ld b,(hl)
+
	call getFreeEnemySlot
	jr nz,@delete

	ld (hl),b
	call objectCopyPosition
	ld e,Part.var03
	ld a,(de)
	ld l,Enemy.subid
	ld (hl),a
@delete:
	jp partDelete

@enemiesToSpawn:
	.db ENEMYID_ROPE,   ENEMYID_ROPE,   ENEMYID_ROPE,   ENEMYID_BEETLE
	.db ENEMYID_BEETLE, ENEMYID_BEETLE, ENEMYID_BEETLE, ENEMYID_BEETLE

;;
; Delete and return from caller if it goes out of bounds in a sidescrolling room
itemDrop_checkSidescrollingConditions:
	ld a,(wTilesetFlags)
	and TILESETFLAG_SIDESCROLL
	ret z
	ld e,Part.subid
	ld a,(de)
	or a
	ret z ; Return if it's ITEM_DROP_FAIRY

	ld a,$20
	call objectUpdateSpeedZ_sidescroll
	jr c,@checkY

	ld e,Part.var34
	ld a,(de)
	rrca
	jr nc,@checkY

	; Hit water; fix speedZ to a specific value?
	ld b,$01
	ld a,(hl) ; [speedZ+1]
	bit 7,a
	jr z,+
	ld b,$ff
	inc a
+
	cp $01
	ret c
	ld (hl),b ; [speedZ+1]
	dec l
	ld (hl),$00 ; [speedZ]

@checkY:
	ld e,Part.yh
	ld a,(de)
	cp $b0
	ret c
	pop hl
	jp partDelete

;;
; Enables collisions once the item comes to rest
;
; @param[out]	cflag	c if it's a fairy and some condition is met?
itemDrop_checkHitGround:
	ld e,Part.subid
	ld a,(de)
	or a
	jr z,@fairy

	ld e,Part.speedZ+1
	ld a,(de)
	and $80
	ret nz
	ld h,d
	ld l,Part.collisionType
	set 7,(hl)
	ret

@fairy:
	ld e,Part.zh
	ld a,(de)
	cp $fa
	ret nc
	ld h,d
	ld l,e
	ld (hl),$fa ; [Part.zh]
	ld l,Part.var33
	ld (hl),$05
	ret

;;
; @param[out]	cflag	c if it's over a hazard (and deleted itself)
itemDrop_checkOnHazard:
	call objectCheckIsOnHazard
	jr c,@onHazard

	ld e,Part.var34
	ld a,(de)
	rrca
	ret nc

	ld b,INTERACID_SPLASH
	xor a
	jr @onWaterSidescrolling

@onHazard:
	rrca
	jr c,@onWater
	rrca
	ld b,INTERACID_LAVASPLASH
	jr nc,@replaceWithAnimation

	call objectCreateFallingDownHoleInteraction
	jr @delete

@replaceWithAnimation:
	call objectCreateInteractionWithSubid00
@delete:
	call partDelete
	scf
	ret

@onWater:
	ld b,INTERACID_SPLASH
	ld a,(wTilesetFlags)
	and TILESETFLAG_SIDESCROLL
	jr z,@replaceWithAnimation

	ld e,Part.var34
	ld a,(de)
	rrca
	ccf
	ret nc

	ld a,$01

@onWaterSidescrolling:
	ld (de),a ; [var34]
	jp objectCreateInteractionWithSubid00

;;
itemDrop_updateFairyMovement:
	ld h,d
	ld l,Part.counter2
	dec (hl)
	jr z,itemDrop_chooseRandomFairyMovement
	call partCommon_getTileCollisionInFront
	inc a
	jp nz,objectApplySpeed

;;
; Initializes speed, counter2, and angle randomly.
itemDrop_chooseRandomFairyMovement:
	call getRandomNumber_noPreserveVars
	and $3e
	add $08
	ld e,Part.counter2
	ld (de),a

	call getRandomNumber_noPreserveVars
	and $03
	ld hl,@speedTable
	rst_addAToHl
	ld e,Part.speed
	ld a,(hl)
	ld (de),a

	call getRandomNumber_noPreserveVars
	and $1e
	ld h,d
	ld l,Part.angle
	ld (hl),a
	and $0f
	ret z

	bit 4,(hl)
	ld l,Part.oamFlagsBackup
	ld a,(hl)
	res 5,a
	jr nz,+
	set 5,a
+
	ldi (hl),a
	ld (hl),a
	ret

@speedTable:
	.db SPEED_40, SPEED_80, SPEED_c0, SPEED_100

;;
; Moves toward position stored in var31/var32 if it's not there already?
;
; @param[out]	cflag	c if reached target position
itemDrop_moveTowardPoint:
	ld l,Part.var31
	ld h,d
	xor a
	ld b,(hl) ; [var31]
	ldi (hl),a
	ld c,(hl) ; [var32]
	ldi (hl),a
	or b
	ret z

	push bc
	call objectCheckContainsPoint
	pop bc
	ret c

	call objectGetRelativeAngle
	ld c,a
	ld b,SPEED_40
	ld e,Part.angle
	call objectApplyGivenSpeed
	xor a
	ret

.ifdef ROM_SEASONS
itemDrop_pullOreChunksWithMagnetGloves:
	ld e,Part.subid
	ld a,(de)
	sub $0c
	cp $03
	ret nc
	; ore chunks
	ld a,(wMagnetGloveState)
	or a
	ret z
	call objectGetAngleTowardLink
	ld c,a
	ld h,d
	ld l,Part.yh
	ld a,(w1Link.yh)
	sub (hl)
	jr nc,+
	cpl
	inc a
+
	ld b,a
	ld l,Part.xh
	ld a,(w1Link.xh)
	sub (hl)
	jr nc,+
	cpl
	inc a
+
	cp b
	jr nc,+
	ld a,b
+
	and $f0
	swap a
	bit 3,a
	jr z,+
	ld a,$07
+
	ld hl,itemDrop_magnetGlovePullSpeed
	rst_addAToHl
	ld b,(hl)
.endif

;;
; @param	b	Speed
; @param	c	Angle
itemDrop_applySpeed:
	push bc
	ld a,c
	call partCommon_getTileCollisionAtAngle_allowHoles
	pop bc
	ret c
	ld e,Part.angle
	call objectApplyGivenSpeed
	scf
	ret

.ifdef ROM_SEASONS
itemDrop_magnetGlovePullSpeed:
	.db SPEED_280 SPEED_280 SPEED_200 SPEED_180
	.db SPEED_100 SPEED_0c0 SPEED_080 SPEED_040
.endif

.include {"{GAME_DATA_DIR}/tileProperties/conveyorItemDropTiles.s"}


; ==============================================================================
; PARTID_ENEMY_DESTROYED
; ==============================================================================
partCode02:
	ld e,Part.state
	ld a,(de)
	or a
	call z,@initialize
	call partAnimate
	ld a,(wFrameCounter)
	rrca
	jr c,++
	ld e,Part.oamFlags
	ld a,(de)
	xor $01
	ld (de),a
++
	ld e,Part.animParameter
	ld a,(de)
	or a
	ret z

	call @decCounter2
	ld a,(de) ; [counter2]
	rlca
	jp c,partDelete

	xor a
	call decideItemDrop
	jp z,partDelete
	ld b,PARTID_ITEM_DROP
	jp objectReplaceWithID

@initialize:
	inc a
	ld (de),a ; [state] = 1
	ld e,Part.knockbackCounter
	ld a,(de)
	rlca
	ld a,$01
	call c,partSetAnimation
	jp objectSetVisible82

@decCounter2:
	ld e,Part.counter2
	ld a,(de)
	rrca
	ret nc
	jp decNumEnemies


; ==============================================================================
; PARTID_ORB
;
; Variables:
;   var03: Bitset to use with wToggleBlocksState (derived from subid)
; ==============================================================================
partCode03:
	cp PARTSTATUS_JUST_HIT
	jr nz,@notJustHit

	; Just hit
	ld a,(wToggleBlocksState)
	ld h,d
	ld l,Part.var03
	xor (hl)
	ld (wToggleBlocksState),a
	ld l,Part.oamFlagsBackup
	ld a,(hl)
	and $01
	inc a
	ldi (hl),a
	ld (hl),a
	ld a,SND_SWITCH
	jp playSound

@notJustHit:
	ld e,Part.state
	ld a,(de)
	or a
	ret nz

@state0:
	inc a
	ld (de),a
	call objectMakeTileSolid
	ld h,Part.zh
	ld (hl),$0a

	ld h,d
	ld l,Part.subid
	ldi a,(hl)
	and $07
	ld bc,bitTable
	add c
	ld c,a
	ld a,(bc)
	ld (hl),a ; [var03]

	ld a,(wToggleBlocksState)
	and (hl)
	ld a,$01
	jr z,+
	inc a
+
	ld l,Part.oamFlagsBackup
	ldi (hl),a
	ld (hl),a
	jp objectSetVisible82


; ==============================================================================
; PARTID_BOSS_DEATH_EXPLOSION
; ==============================================================================
partCode04:
	ld e,Part.state
	ld a,(de)
	or a
	jr z,@state0

@state1:
	ld e,Part.animParameter
	ld a,(de)
	inc a
	jp nz,partAnimate

	call decNumEnemies
	jr nz,@delete

	ld e,Part.subid
	ld a,(de)
	or a
	jr z,@delete

	xor a
	call decideItemDrop
	jr z,@delete
	ld b,PARTID_ITEM_DROP
	jp objectReplaceWithID

@delete:
	jp partDelete

@state0:
	inc a
	ld (de),a ; [state] = 1
	ld e,Part.subid
	ld a,(de)
	or a
	ld a,SND_BIG_EXPLOSION
	call nz,playSound
	jp objectSetVisible80


; ==============================================================================
; PARTID_SWITCH
;
; Variables:
;   var30: Position of tile it's on
; ==============================================================================
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


; ==============================================================================
; PARTID_LIGHTABLE_TORCH
; ==============================================================================
partCode06:
	jr z,@normalStatus

	; Just hit
	ld h,d
	ld l,Part.subid
	ld a,(hl)
	cp $02
	jr z,@normalStatus

	ld l,Part.counter2
	ldd a,(hl)
	ld (hl),a ; [counter1] = [counter2]
	ld l,Part.state
	ld (hl),$02

@normalStatus:
	ld e,Part.subid
	ld a,(de)
	rst_jumpTable
	.dw @subid0
	.dw @subid1
	.dw @subid2


; Subid 0: Once the torch is lit, it stays lit.
@subid0:
	ld e,Part.state
	ld a,(de)
	rst_jumpTable
	.dw @gotoState1
	.dw @ret
	.dw @subid0State2

@gotoState1:
	ld a,$01
	ld (de),a

@ret:
	ret

@subid0State2:
	ld hl,wNumTorchesLit
	inc (hl)
	ld a,SND_LIGHTTORCH
	call playSound
	call objectGetShortPosition
	ld c,a

	ld a,(wActiveGroup)
	or a
	ld a,TILEINDEX_OVERWORLD_LIT_TORCH
	jr z,+
	ld a,TILEINDEX_LIT_TORCH
+
	call setTile
	jp partDelete


; Subid 1: Once lit, the torch stays lit for [counter2] frames.
@subid1:
	ld e,Part.state
	ld a,(de)
	rst_jumpTable
	.dw @gotoState1
	.dw @ret
	.dw @subid1State2
	.dw @subid1State3

@subid1State2:
	ld h,d
	ld l,e
	inc (hl) ; [state] = 3

	ld l,Part.collisionType
	res 7,(hl)

	; [counter1] = [counter2]
	ld l,Part.counter2
	ldd a,(hl)
	ld (hl),a

	ld hl,wNumTorchesLit
	inc (hl)
	ld a,SND_LIGHTTORCH
	call playSound

	call objectGetShortPosition
	ld c,a
	ld a,TILEINDEX_LIT_TORCH
	jr @setTile

@subid1State3:
	ld a,(wFrameCounter)
	and $03
	ret nz
	call partCommon_decCounter1IfNonzero
	ret nz

	ld l,Part.collisionType
	set 7,(hl)
	ld l,Part.state
	ld (hl),$01

	ld hl,wNumTorchesLit
	dec (hl)

	call objectGetShortPosition
	ld c,a
	ld a,TILEINDEX_UNLIT_TORCH
	jr @setTile


; Subid 2: ?
@subid2:
	ld e,Part.state
	ld a,(de)
	rst_jumpTable
	.dw @gotoState1
	.dw @subid2State1
	.dw @subid2State2
	.dw @subid2State3
	.dw @subid2State4

@subid2State1:
	call @getTileAtRelatedObjPosition
	cp TILEINDEX_LIT_TORCH
	ret z

	ld h,d
	ld l,Part.state
	inc (hl)
	ld l,Part.counter1
	ld (hl),$f0
	ret

@subid2State2:
	call partCommon_decCounter1IfNonzero
	jp nz,@gotoState1IfTileAtRelatedObjPositionIsNotLit

	; [state] = 3
	ld l,e
	inc (hl)

	ld hl,wNumTorchesLit
	dec (hl)
	call objectGetShortPosition
	ld c,a
	ld a,TILEINDEX_UNLIT_TORCH
@setTile:
	jp setTile

@subid2State3:
	call @getTileAtRelatedObjPosition
	cp TILEINDEX_UNLIT_TORCH
	ret z
	ld e,Part.state
	ld a,$04
	ld (de),a
	ret

@subid2State4:
	ld a,$01
	ld (de),a ; [state]
	ld hl,wNumTorchesLit
	inc (hl)
	call objectGetShortPosition
	ld c,a
	ld a,TILEINDEX_LIT_TORCH
	jr @setTile

;;
@getTileAtRelatedObjPosition:
	ld a,Object.yh
	call objectGetRelatedObject2Var
	ld b,(hl)
	ld l,Part.xh
	ld c,(hl)
	jp getTileAtPosition

@gotoState1IfTileAtRelatedObjPositionIsNotLit:
	call @getTileAtRelatedObjPosition
	cp TILEINDEX_LIT_TORCH
	ret nz
	ld e,Part.state
	ld a,$01
	ld (de),a
	ret


; ==============================================================================
; PARTID_SHADOW
;
; Variables:
;   relatedObj1: Object that this shadow is for
;   var30: ID of relatedObj1 (deletes self if it changes)
; ==============================================================================
partCode07:
	ld e,Part.state
	ld a,(de)
	or a
	call z,@initialize

	; If parent's ID changed, delete self
	ld a,Object.id
	call objectGetRelatedObject1Var
	ld e,Part.var30
	ld a,(de)
	cp (hl)
	jp nz,partDelete

	; Take parent's position, with offset
	ld a,Object.yh
	call objectGetRelatedObject1Var
	ld e,Part.var03
	ld a,(de)
	ld b,a
	ld c,$00
	call objectTakePositionWithOffset

	xor a
	ld (de),a ; [this.zh] = 0

	ld a,(hl) ; [parent.zh]
	or a
	jp z,objectSetInvisible

	; Flicker visibility
	ld e,Part.visible
	ld a,(de)
	xor $80
	ld (de),a

	ld e,Part.subid
	ld a,(de)
	add a
	ld bc,@animationIndices
	call addDoubleIndexToBc

	; Set shadow size based on how close the parent is to the ground
	ld a,(hl) ; [parent.zh]
	cp $e0
	jr nc,@setAnim
	inc bc
	cp $c0
	jr nc,@setAnim
	inc bc
	cp $a0
	jr nc,@setAnim
	inc bc

@setAnim:
	ld a,(bc)
	jp partSetAnimation

@animationIndices:
	.db $01 $01 $00 $00 ; Subid 0
	.db $02 $01 $01 $00 ; Subid 1
	.db $03 $02 $01 $00 ; Subid 2

@initialize:
	inc a
	ld (de),a ; [state] = 1

	ld a,Object.id
	call objectGetRelatedObject1Var
	ld e,Part.var30
	ld a,(hl)
	ld (de),a

	jp objectSetVisible83


; ==============================================================================
; PARTID_DARK_ROOM_HANDLER
;
; Variables:
;   counter1: Number of lightable torches in the room
;   counter2: Number of torches currently lit (last time it checked)
; ==============================================================================
partCode08:
	ld a,(wPaletteThread_mode)
	or a
	ret nz

	ld a,(wScrollMode)
	and $01
	ret z

	ld e,Part.state
	ld a,(de)
	or a
	call z,@state0

@state1:
	ld h,d
	ld l,Part.counter2
	ld b,(hl)
	ld a,(wNumTorchesLit)
	cp (hl)
	ret z

	; No torches lit?
	ldd (hl),a ; [counter2]
	or a
	jp z,darkenRoom

	; All torches lit?
	cp (hl) ; [counter1]
	jp z,brightenRoom

	ld a,(wPaletteThread_parameter)
	cp $f7
	ret z

	; Check if # of lit torches increased or decreased
	ld a,(wNumTorchesLit)
	cp b
	jp nc,brightenRoomLightly
	jp darkenRoomLightly

;;
; @param	l	Position of an unlit torch
; @param[out]	c	Incremented
@spawnLightableTorch:
	push hl
	push bc
	ld c,l
	call getFreePartSlot
	jr nz,+++
	ld (hl),PARTID_LIGHTABLE_TORCH
	inc l
	ld e,l
	ld a,(de)
	ld (hl),a ; [child.subid] = [this.subid]

	; Set length of time the torch can remain lit
	ld e,Part.yh
	ld a,(de)
	and $f0
	ld l,a
	ld e,Part.xh
	ld a,(de)
	and $f0
	swap a
	or l
	ld l,Part.counter2
	ld (hl),a

	ld l,Part.yh
	call setShortPosition_paramC
+++
	pop bc
	pop hl
	inc c
	ret

@state0:
	inc a
	ld (de),a ; [state] = 1

	ld e,Part.counter1
	ld a,(de)
	ld c,a

	; Search for lightable torches
	ld hl,wRoomLayout
	ld b,LARGE_ROOM_HEIGHT << 4
--
	ld a,(hl)
	cp TILEINDEX_UNLIT_TORCH
	call z,@spawnLightableTorch
	inc l
	dec b
	jr nz,--

	ld e,Part.counter1
	ld a,c
	ld (de),a
	call objectGetShortPosition
	ld e,Part.yh
	ld (de),a
	ret


; ==============================================================================
; PARTID_BUTTON
;
; Variables:
;   var03: Bit index (copied from subid ignoring bit 7)
;   counter1: ?
;   var30: 1 if button is pressed
; ==============================================================================
partCode09:
	ld e,Part.state
	ld a,(de)
	or a
	call z,@state0

@state1:
	ld a,(wccb1)
	or a
	ret nz

	ld hl,w1Link
	call checkObjectsCollided
	jr c,@linkTouchedButton

.ifdef ROM_SEASONS
	ld hl,$dd00
	call checkObjectsCollided
	jr c,@dd00TouchedButton
.endif

	call objectGetTileAtPosition
	sub TILEINDEX_BUTTON
	cp $02 ; TILEINDEX_BUTTON or TILEINDEX_PRESSED_BUTTON
	jr nc,@somethingOnButton

	call partCommon_decCounter1IfNonzero
	ret nz

	ld l,Part.var30
	bit 0,(hl)
	ret z
	ld e,Part.var30
	ld a,(de)
	or a
	ret z

	call objectGetShortPosition
	ld c,a
	ld a,TILEINDEX_BUTTON
	call setTile

	ld e,Part.var03
	ld a,(de)
	ld hl,wActiveTriggers
	call unsetFlag
	ld e,$f0
	xor a
	ld (de),a

	ld a,SND_SPLASH
	jp playSound

; Tile is being held down by something (somaria block, pot, etc)
@somethingOnButton:
	ld h,d
	ld l,Part.subid
	bit 7,(hl)
	jr z,@delete

	ld l,Part.var30
	bit 0,(hl)
	ret nz

	ld l,Part.counter1
	ld (hl),$1c
	call objectGetShortPosition
	ld c,a
	ld b,TILEINDEX_PRESSED_BUTTON
	call setTileInRoomLayoutBuffer
	jr @setTriggerAndPlaySound

@delete:
	call @updateTileBeforeDeletion
	jp partDelete

@linkTouchedButton:
	ld a,(w1Link.zh)
	or a
	ret nz
@dd00TouchedButton:
	ld e,Part.subid
	ld a,(de)
	rlca
	jr nc,@delete

@checkButtonPushed:
	ld e,Part.var30
	ld a,(de)
	or a
	ret nz

	call objectGetShortPosition
	ld c,a
	ld a,TILEINDEX_PRESSED_BUTTON
	call setTile

@setTriggerAndPlaySound:
	ld e,Part.var03
	ld a,(de)
	ld hl,wActiveTriggers
	call setFlag
	ld e,Part.var30
	ld a,$01
	ld (de),a
	ld a,SND_SPLASH
	jp playSound

@updateTileBeforeDeletion:
	call objectGetShortPosition
	ld c,a
	ld b,TILEINDEX_PRESSED_BUTTON
	call setTileInRoomLayoutBuffer
	call objectGetTileAtPosition
	cp TILEINDEX_BUTTON
	jr z,@checkButtonPushed
	jr @setTriggerAndPlaySound

@state0:
	ld h,d
	ld l,e
	inc (hl) ; [state] = 1
	ld l,Part.subid
	ldi a,(hl)
	and $07
	ldd (hl),a ; [var03]
	ret


; =======================================================================================
; PARTID_MOVING_ORB
;
; Variables:
;   var32: Dest Y position (from movement script)
;   var33: Dest X position (from movement script)
; =======================================================================================
partCode0b:
	cp PARTSTATUS_JUST_HIT
	jr nz,@normalStatus

	; Just hit

	ld h,d
	ld l,Part.oamFlagsBackup
	ldi a,(hl)
	ld (hl),a ; [oamFlags]

	ld l,Part.var03
	ld a,(wToggleBlocksState)
	xor (hl)
	ld (wToggleBlocksState),a
	ld l,Part.oamFlagsBackup
	ld a,(hl)
	dec a
	jr nz,+
	ld a,$02
+
	ldi (hl),a ; [oamFlagsBackup]
	ld (hl),a  ; [oamFlags]
	ld a,SND_SWITCH
	call playSound

@normalStatus:
	ld e,Part.state
	ld a,(de)
	sub $08
	jr c,@state0To7
	rst_jumpTable
	.dw @state8_up
	.dw @state9_right
	.dw @stateA_down
	.dw @stateB_left
	.dw @stateC_waiting

@state0To7:
.ifdef ROM_AGES
	ld hl,bank0e.orbMovementScript
.else
	ld hl,bank0d.orbMovementScript
.endif
	call objectLoadMovementScript

	ld h,d
	ld l,Part.var03
	ld b,$01
	ld a,(wToggleBlocksState)
	and (hl)
	jr z,+
	inc b
+
	ld a,b
	ld l,Part.oamFlagsBackup
	ldi (hl),a
	ld (hl),a  ; [oamFlags]
	jp objectSetVisible82

@state8_up:
	ld h,d
	ld e,Part.var32
	ld a,(de)
	ld l,Part.yh
	cp (hl)
	jp c,objectApplySpeed
	jr @runMovementScript

@state9_right:
	ld h,d
	ld e,Part.xh
	ld a,(de)
	ld l,Part.var33
	cp (hl)
	jp c,objectApplySpeed
	jr @runMovementScript

@stateA_down:
	ld h,d
	ld e,Part.yh
	ld a,(de)
	ld l,Part.var32
	cp (hl)
	jp c,objectApplySpeed
	jr @runMovementScript

@stateB_left:
	ld h,d
	ld e,Part.var33
	ld a,(de)
	ld l,Part.xh
	cp (hl)
	jp c,objectApplySpeed

@runMovementScript:
	ld a,(de)
	ld (hl),a
	jp objectRunMovementScript

@stateC_waiting:
	ld h,d
	ld l,Part.counter1
	dec (hl)
	ret nz
	jp objectRunMovementScript


; ==============================================================================
; PARTID_BRIDGE_SPAWNER
; ==============================================================================
partCode0c:
	ld e,Part.state
	ld a,(de)
	or a
	call z,@state0

	call partCommon_decCounter1IfNonzero
	ret nz

	; Time to create the next bridge tile
	ld l,Part.angle
	ld a,(hl)
	ld hl,@tileValues
	rst_addDoubleIndex
	ld e,Part.counter2
	ld a,(de)
	rrca
	ldi a,(hl)
	jr nc,+
	ld a,(hl)
+
	ld b,a
	ld e,Part.yh
	ld a,(de)
	ld c,a
	push bc
	call setTileInRoomLayoutBuffer
	pop bc
	ld a,b
	call setTile
	ld a,SND_DOORCLOSE
	call playSound

	ld h,d
	ld l,Part.counter1
	ld (hl),$08
	inc l
	dec (hl) ; [counter2]
	jp z,partDelete

	; Move to next tile every other time (since bridges are updated in halves)
	ld a,(hl) ; [counter1]
	rrca
	ret c

	ld l,Part.angle
	ld a,(hl)
	ld bc,@directionVals
	call addAToBc
	ld a,(bc)
	ld l,Part.yh
	add (hl)
	ld (hl),a
	ret

@tileValues:
	.db TILEINDEX_VERTICAL_BRIDGE_DOWN,    TILEINDEX_VERTICAL_BRIDGE
	.db TILEINDEX_HORIZONTAL_BRIDGE_LEFT,  TILEINDEX_HORIZONTAL_BRIDGE
	.db TILEINDEX_VERTICAL_BRIDGE_UP,      TILEINDEX_VERTICAL_BRIDGE
	.db TILEINDEX_HORIZONTAL_BRIDGE_RIGHT, TILEINDEX_HORIZONTAL_BRIDGE

@directionVals:
	.db $f0 $01 $10 $ff

@state0:
	ld h,d
	ld l,e
	inc (hl) ; [state] = 1
	ld l,Part.counter1
	ld (hl),$08
	ret


; ==============================================================================
; PARTID_DETECTION_HELPER
;
; Variables (for subid 0, the "controller"):
;   counter1: Countdown until firing another detection projectile forward
;   counter2: Countdown until firing another detection projectile in an arbitrary
;             direction (for close-range detection)
; ==============================================================================
partCode0e:
	jp nz,partDelete
	ld e,Part.subid
	ld a,(de)
	ld e,Part.state
	rst_jumpTable
	.dw @subid0
	.dw @subid1
	.dw @subid2
	.dw @subid3


; The "controller" (spawns other subids)
@subid0:
	ld a,(de)
	or a
	jr z,@subid0_state0

@subid0_state1:
	ld a,Object.enabled
	call objectGetRelatedObject1Var
	ld a,(hl)
	or a
	jp z,partDelete

	; Copy parent's angle and position
	ld e,Part.angle
	ld a,l
	or Object.angle
	ld l,a
	ld a,(hl)
	ld (de),a
	call objectTakePosition

	; Countdown to spawn a "detection projectile" forward
	call partCommon_decCounter1IfNonzero
	jr nz,++

	ld (hl),$0f ; [counter1]
	ld e,Part.angle
	ld a,(de)
	ld b,a
	ld e,$01
	call @spawnCollisionHelper
++
	; Countdown to spawn "detection projectiles" to the sides, for nearby detection
	ld h,d
	ld l,Part.counter2
	dec (hl)
	ret nz

	ld (hl),$06 ; [counter2]

	ld l,Part.var03
	ld a,(hl)
	inc a
	and $03
	ld (hl),a

	ld c,a
	ld l,Part.angle
	ld b,(hl)
	ld e,$02
	call @spawnCollisionHelper
	ld e,$03


;;
; @param	b	Angle
; @param	c	var03
; @param	e	Subid
@spawnCollisionHelper:
	call getFreePartSlot
	ret nz
	ld (hl),PARTID_DETECTION_HELPER
	inc l
	ld (hl),e
	inc l
	ld (hl),c

	call objectCopyPosition
	ld l,Part.angle
	ld (hl),b

	ld l,Part.relatedObj1
	ld e,l
	ld a,(de)
	ldi (hl),a
	inc e
	ld a,(de)
	ld (hl),a
	ret

@subid0_state0:
	ld h,d
	ld l,e
	inc (hl) ; [subid]

	ld l,Part.counter1
	inc (hl)
	inc l
	inc (hl) ; [counter2]
	ret


; This "moves" in a prescribed direction. If it hits Link, it triggers the guard; if it
; hits a wall, it deletes itself.
@subid1:
	ld a,(de)
	or a
	jr z,@subid1_state0


@subid1_state1:
	call objectCheckCollidedWithLink_ignoreZ
	jr c,@sawLink

	; Move forward, delete self if hit a wall
	call objectApplyComponentSpeed
	call objectCheckSimpleCollision
	ret z
	jr @delete

@sawLink:
	ld a,Object.var3b
	call objectGetRelatedObject1Var
	ld (hl),$ff
@delete:
	jp partDelete


@subid1_state0:
	inc a
	ld (de),a ; [state]

	; Determine collision radii depending on angle
	ld e,Part.angle
	ld a,(de)
	add $04
	and $08
	rrca
	rrca
	ld hl,@collisionRadii
	rst_addAToHl
	ld e,Part.collisionRadiusY
	ldi a,(hl)
	ld (de),a
	inc e
	ld a,(hl)
	ld (de),a

	jp @initSpeed

@collisionRadii:
	.db $02 $01 ; Up/down
	.db $01 $02 ; Left/right


; Like subid 1, but this only lasts for 4 frames, and it detects Link at various angles
; relative to the guard (determined by var03). Used for close-range detection in any
; direction.
@subid2:
@subid3:
	ld a,(de)
	or a
	jr z,@subid2_state0


@subid2_state1:
	call partCommon_decCounter1IfNonzero
	jr nz,@subid1_state1
	jr @delete


@subid2_state0:
	ld h,d
	ld l,e
	inc (hl) ; [state]

	ld l,Part.counter1
	ld (hl),$04

	ld l,Part.var03
	ld a,(hl)
	inc a
	add a
	dec l
	bit 0,(hl) ; [subid]
	jr nz,++
	cpl
	inc a
++
	ld l,Part.angle
	add (hl)
	and $1f
	ld (hl),a

;;
@initSpeed:
	ld h,d
	ld l,Part.angle
	ld c,(hl)
	ld b,SPEED_280
	ld a,$04
	jp objectSetComponentSpeedByScaledVelocity


; ==============================================================================
; PARTID_RESPAWNABLE_BUSH
; ==============================================================================
partCode0f:
	jr z,@normalStatus

	; Just hit
	ld h,d
	ld l,Part.state
	inc (hl) ; [state] = 2

	ld l,Part.counter1
	ld (hl),$f0
	ld l,Part.collisionType
	res 7,(hl)

	ld a,TILEINDEX_RESPAWNING_BUSH_CUT
	call @setTileHere

	; 50/50 drop chance
	call getRandomNumber_noPreserveVars
	rrca
	jr nc,@doneItemDropSpawn

	call getFreePartSlot
	jr nz,@doneItemDropSpawn
	ld (hl),PARTID_ITEM_DROP
	inc l
	ld e,l
	ld a,(de)
	ld (hl),a ; [itemDrop.subid] = [this.subid]
	call objectCopyPosition

@doneItemDropSpawn:
	ld b,INTERACID_GRASSDEBRIS
	call objectCreateInteractionWithSubid00

@normalStatus:
	ld e,Part.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3
	.dw @state4

@state0:
	ld a,$01
	ld (de),a
	ret

@state1:
	ret

; Delay before respawning
@state2:
	ld a,(wFrameCounter)
	rrca
	ret nc
	call partCommon_decCounter1IfNonzero
	ret nz

	; Time to respawn
	ld (hl),$0c ; [counter1]
	ld l,e
	inc (hl) ; [state] = 3
	ld a,TILEINDEX_RESPAWNING_BUSH_REGEN
	jr @setTileHere

@state3:
	call partCommon_decCounter1IfNonzero
	ret nz
	ld (hl),$08 ; [counter1]
	ld l,e
	inc (hl) ; [state] = 4
	ld a,TILEINDEX_RESPAWNING_BUSH_READY

;;
; @param	a	Tile index to set
@setTileHere:
	push af
	call objectGetShortPosition
	ld c,a
	pop af
	jp setTile


@state4:
	call partCommon_decCounter1IfNonzero
	ret nz
	ld l,e
	ld (hl),$01 ; [state] = 1

	ld l,Part.collisionType
	set 7,(hl)
	ret


; ==============================================================================
; PARTID_SEED_ON_TREE
; ==============================================================================
partCode10:
	jr z,@normalStatus
	cp PARTSTATUS_DEAD
	jp z,@dead

	; PARTSTATUS_JUST_HIT
	ld e,Part.state
	ld a,$02
	ld (de),a

@normalStatus:
	ld e,Part.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3
	.dw @state4

@state0:
	ld a,$01
	ld (de),a ; [state]

	ld e,Part.subid
	ld a,(de)
	ld hl,@oamData
	rst_addDoubleIndex
	ld e,Part.oamTileIndexBase
	ld a,(de)
	add (hl)
	ld (de),a ; [oamTileIndexBase]
	inc hl
	dec e
	ld a,(hl)
	ld (de),a ; [oamFlags]
	dec e
	ld (de),a ; [oamFlagsBackup]

	ld a,$01
	call partSetAnimation
	jp objectSetVisiblec3

@oamData:
	.db $12 $02
	.db $14 $03
	.db $16 $01
	.db $18 $01
	.db $1a $00

@state1:
	ret

@state2:
	ret

@state3:
	call objectCheckCollidedWithLink_notDeadAndNotGrabbing
	jr c,@giveToLink

	call objectApplySpeed
	ld c,$20
	call objectUpdateSpeedZAndBounce
	ret nc

@giveToLink:
	ld h,d
	ld l,Part.state
	ld (hl),$04
	inc l
	ld (hl),$00
	ret

@state4:
	ld e,Part.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1

@substate0:
	ld e,Part.subid
	ld a,(de)
	ld l,a
	add TREASURE_EMBER_SEEDS
	call checkTreasureObtained
	jr c,@giveSeedAndSomething

	; First time getting this seed type
	ld e,Part.substate
	ld a,$01
	ld (de),a

	ld a,l ; [subid]
	ld hl,@textIndices
	rst_addAToHl
	ld c,(hl)
	ld b,>TX_0000
	call showText
	ld c,$06
	jr @giveSeed

@textIndices:
	.db <TX_0029
	.db <TX_0029
	.db <TX_002b
	.db <TX_002c
	.db <TX_002a

@giveSeed:
	ld e,Part.subid
	ld a,(de)
	add TREASURE_EMBER_SEEDS
	jp giveTreasure

@giveSeedAndSomething:
	ld c,$06
	call @giveSeed

@relatedObj2Something:
	ld a,Object.enabled
	call objectGetRelatedObject2Var
	ld a,(hl)
	or a
	jr z,@delete
	ld a,l
	add Object.var03 - Object.enabled
	ld l,a
	ld (hl),$01
@delete:
	jp partDelete

@substate1:
	call retIfTextIsActive
	jr @relatedObj2Something

@dead:
	ld h,d
	ld l,Part.collisionType
	res 7,(hl)
	ld a,($cfc0)
	or a
	ret nz

	ld a,TREASURE_SEED_SATCHEL
	call checkTreasureObtained
	jr c,@knockOffTree

	; Don't have satchel
	ld a,d
	ld ($cfc0),a
	ld bc,TX_0035
	jp showText

@knockOffTree:
	ld bc,-$140
	call objectSetSpeedZ
	ld l,Part.health
	ld a,$03
	ld (hl),a
	ld l,Part.state
	ldi (hl),a
	ld (hl),$00 ; [substate]
	inc l
	ld (hl),$02 ; [counter1]
	ld l,Part.speed
	ld (hl),SPEED_100
	call objectGetAngleTowardLink
	ld e,Part.angle
	ld (de),a
	ret


; ==============================================================================
; PARTID_VOLCANO_ROCK
; ==============================================================================
partCode11:
	ld e,Part.subid
	ld a,(de)
	ld e,Part.state
	rst_jumpTable
	.dw volcanoRock_subid0
	.dw volcanoRock_subid1
	.dw volcanoRock_subid2

volcanoRock_subid0:
	ld a,(de)
	or a
	jr z,@state0

@state1:
	ld c,$16
	call objectUpdateSpeedZAndBounce
	jp c,partDelete
	jp nz,objectApplySpeed

	call getRandomNumber_noPreserveVars
	and $03
	dec a
	ret z
	ld b,a
	ld e,Part.angle
	ld a,(de)
	add b
	and $1f

@setAngleAndSpeed:
	ld (de),a
	jp volcanoRock_subid0_setSpeedFromAngle

@state0:
	ld bc,-$280
	call objectSetSpeedZ
	ld l,e
	inc (hl) ; [state]
	ld l,Part.collisionType
	set 7,(hl)
	call objectSetVisible80
	call getRandomNumber_noPreserveVars
	and $0f
	add $08
	ld e,Part.angle
	jr @setAngleAndSpeed


volcanoRock_subid1:
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw volcanoRock_common_substate2
	.dw volcanoRock_common_substate3
	.dw volcanoRock_common_substate4
	.dw volcanoRock_common_substate5

@substate0:
	ld h,d
	ld l,e
	inc (hl)
	ld l,Part.collisionType
	set 7,(hl)

	; Double hitbox size
	ld l,Part.collisionRadiusY
	ld a,(hl)
	add a
	ldi (hl),a
	ldi (hl),a

	; [damage] *= 2
	sla (hl)

	ld l,Part.speed
	ld (hl),SPEED_20

	ld l,Part.speedZ
	ld a,<(-$400)
	ldi (hl),a
	ld (hl),>(-$400)

	; Random angle
	call getRandomNumber_noPreserveVars
	and $1f
	ld e,Part.angle
	ld (de),a

	ld a,$01
	call partSetAnimation
	jp objectSetVisible80

@substate1:
	ld h,d
	ld l,Part.yh
	ld e,Part.zh
	ld a,(de)
	add (hl)
	add $08
	cp $f8
	ld c,$10
	jp c,objectUpdateSpeedZ_paramC

	ld l,Part.state
	inc (hl)
	ld l,Part.counter1
	ld (hl),30
	call objectSetInvisible
	jr volcanoRock_setRandomPosition

volcanoRock_common_substate2:
	call partCommon_decCounter1IfNonzero
	ret nz
	ld (hl),$10 ; [counter1]
	ld l,e
	inc (hl) ; [substate]++
	jp objectSetVisiblec0

volcanoRock_common_substate3:
	call partAnimate
	ld h,d
	ld l,Part.zh
	inc (hl)
	inc (hl)
	ret nz

	call objectReplaceWithAnimationIfOnHazard
	jp c,partDelete

	ld h,d
	ld l,Part.state
	inc (hl)
	ld l,Part.speedZ
	xor a
	ldi (hl),a
	ld (hl),a
	jp objectSetVisible82

volcanoRock_common_substate4:
	call partAnimate
	ld c,$16
	call objectUpdateSpeedZ_paramC
	jp nz,objectApplySpeed

	ld l,Part.state
	inc (hl)

	ld l,Part.oamTileIndexBase
	ld (hl),$26

	ld a,$03
	call partSetAnimation
	ld a,SND_STRONG_POUND
	jp playSound

volcanoRock_common_substate5:
	ld e,Part.animParameter
	ld a,(de)
	inc a
	jp z,partDelete
	call volcanoRock_setCollisionSize
	jp partAnimate


volcanoRock_subid2:
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw volcanoRock_common_substate2
	.dw volcanoRock_common_substate3
	.dw volcanoRock_common_substate4
	.dw volcanoRock_common_substate5

@substate0:
	ld a,$01
	ld (de),a ; [substate]

volcanoRock_setRandomPosition:
	call getRandomNumber_noPreserveVars
	ld b,a
	ld hl,hCameraY
	ld e,Part.yh
	and $70
	add $08
	add (hl)
	ld (de),a
	cpl
	inc a
	and $fe
	ld e,Part.zh
	ld (de),a

	ld l,<hCameraX
	ld e,Part.xh
	ld a,b
	and $07
	inc a
	swap a
	add $08
	add (hl)
	ld (de),a
	ld a,$02
	jp partSetAnimation

;;
; @param	a	Angle
volcanoRock_subid0_setSpeedFromAngle:
	ld b,SPEED_80
	cp $0d
	jr c,@setSpeed
	ld b,SPEED_40
	cp $14
	jr c,@setSpeed
	ld b,SPEED_80
@setSpeed:
	ld a,b
	ld e,Part.speed
	ld (de),a
	ret

;;
; @param	a	Value from [animParameter] (should be multiple of 2)
volcanoRock_setCollisionSize:
	dec a
	ld hl,@data
	rst_addAToHl
	ld e,Part.collisionRadiusY
	ldi a,(hl)
	ld (de),a
	inc e
	ld a,(hl)
	ld (de),a
	ret

@data:
	.db $04 $09
	.db $06 $0b
	.db $09 $0c
	.db $0a $0d
	.db $0b $0e


; ==============================================================================
; PARTID_FLAME
;
; Variables:
;   var30: ID of enemy hit (relatedObj1)
;   var31: Old health value of enemy
; ==============================================================================
partCode12:
	ld e,Part.state
	ld a,(de)
	or a
	call z,@state0

@state1:
	ld a,Object.id
	call objectGetRelatedObject1Var
	ld e,Part.var30
	ld a,(de)
	cp (hl)
	jr nz,@delete

	ld c,$10
	call objectUpdateSpeedZAndBounce

	ld a,Object.zh
	call objectGetRelatedObject1Var
	ld e,Part.zh
	ld a,(de)
	ld (hl),a

	call objectTakePosition
	ld c,h
	call partCommon_decCounter1IfNonzero
	jp nz,partAnimate

	; Done burning.

	; Restore enemy's health
	ld h,c
	ld l,Enemy.health
	ld e,Part.var31
	ld a,(de)
	ld (hl),a

	; Disable enemy collision if he's dead
	or a
	jr nz,+
	ld l,Enemy.collisionType
	res 7,(hl)
+
	ld l,Enemy.invincibilityCounter
	ld (hl),$00
	ld l,Enemy.stunCounter
	ld (hl),$01
@delete:
	jp partDelete

@state0:
	ld h,d
	ld l,e
	inc (hl) ; [state]

	ld l,Part.counter1
	ld (hl),59
	ld a,Object.id
	call objectGetRelatedObject1Var
	ld e,Part.var30
	ld a,(hl)
	ld (de),a

	ld e,Part.var31
	ld l,Enemy.health
	ld a,(hl)
	ld (de),a
	ld (hl),$01
	call objectTakePosition
	jp objectSetVisible80


; ==============================================================================
; PARTID_OWL_STATUE
; ==============================================================================
partCode13:
	jr z,@normalStatus
	ld e,Part.var2a
	ld a,(de)
	cp $9a
	jr nz,@normalStatus
	ld h,d
	ld l,Part.state
	ld a,(hl)
	cp $02
	jr nc,@normalStatus
	inc (hl)
	ld l,Part.counter1
	ld (hl),$32
@normalStatus:
	ld e,Part.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @stateStub
	.dw @state2
	.dw @state3

@state0:
	ld h,d
	ld l,e
	inc (hl)
	ld l,Part.var3f
	set 5,(hl)
	call objectMakeTileSolid
	ld h,>wRoomLayout
	ld (hl),$00
	jp objectSetVisible83

@stateStub:
	ret

@state2:
	call partCommon_decCounter1IfNonzero
	jr nz,+
	ld (hl),$1e
	ld l,e
	inc (hl)
	ld a,$01
	jp partSetAnimation
+
	ld a,(hl)
	and $07
	ret nz
	ld a,(hl)
	rrca
	rrca
	sub $02
	ld hl,@owlStatueSparkleOffset
	rst_addAToHl
	ldi a,(hl)
	ld b,a
	ld c,(hl)
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERACID_SPARKLE
.ifdef ROM_SEASONS
	; substate
	inc l
	ld (hl),$05
.endif
	jp objectCopyPositionWithOffset
@owlStatueSparkleOffset:
	.db $f9 $05
	.db $06 $ff
	.db $fc $fa
	.db $02 $07
	.db $00 $fa
	.db $ff $02

@state3:
	call partCommon_decCounter1IfNonzero
	jr nz,+
	ld l,e
	ld (hl),$01
	xor a
	jp partSetAnimation
+
	ld a,(hl)
	cp $16
	ret nz
	ld l,Part.subid
	ld c,(hl)
	ld b,$39
	jp showText


; ==============================================================================
; PARTID_ITEM_FROM_MAPLE
; PARTID_ITEM_FROM_MAPLE_2
; ==============================================================================
partCode14:
partCode15:
	ld e,Part.subid
	jr z,@normalStatus
	cp PARTSTATUS_DEAD
	jp z,@linkCollectedItem

	; PARTSTATUS_JUST_HIT
	ld h,d
	ld l,Part.subid
	set 7,(hl)
	ld l,Part.state
	ld (hl),$03
	inc l
	ld (hl),$00

@normalStatus:
	ld e,Part.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw objectReplaceWithAnimationIfOnHazard
	.dw @state3 ; just hit
	.dw @state4

@state0:
	ld h,d
	ld l,e
	inc (hl)

	ld l,Part.collisionRadiusY
	ld a,$06
	ldi (hl),a
	; collisionRadiusX
	ld (hl),a

	call getRandomNumber
	ld b,a
	and $70
	swap a
	ld hl,@speedValues
	rst_addAToHl
	ld e,Part.speed
	ld a,(hl)
	ld (de),a

	ld a,b
	and $0e
	ld hl,@speedZValues
	rst_addAToHl
	ld e,Part.speedZ
	ldi a,(hl)
	ld (de),a
	inc e
	ldi a,(hl)
	ld (de),a

	call getRandomNumber
	ld e,Part.angle
	and $1f
	ld (de),a
	call @setOamData
	jp objectSetVisiblec3

@speedValues:
	.db SPEED_080
	.db SPEED_0c0
	.db SPEED_100
	.db SPEED_140
	.db SPEED_180
	.db SPEED_1c0
	.db SPEED_200
	.db SPEED_240

@speedZValues:
	.dw -$180
	.dw -$1c0
	.dw -$200
	.dw -$240
	.dw -$280
	.dw -$2c0
	.dw -$300
	.dw -$340

@state1:
	call objectApplySpeed
	call @setDroppedItemPosition
	ld c,$20
	call objectUpdateSpeedZAndBounce
	jr nc,+
	ld h,d
	ld l,Part.collisionType
	set 7,(hl)
	ld l,Part.state
	inc (hl)
+
	jp objectReplaceWithAnimationIfOnHazard

@state3:
	inc e
	ld a,(de)
	or a
	jr nz,+
	ld h,d
	ld l,e
	inc (hl)
	ld l,Part.zh
	ld (hl),$00
	ld a,$01
	call objectGetRelatedObject1Var
	ld a,(hl)
	ld e,Part.var30
	ld (de),a
	call objectSetVisible80
+
	call objectCheckCollidedWithLink
	jp c,@linkCollectedItem
	ld a,$00
	call objectGetRelatedObject1Var
	ldi a,(hl)
	or a
	jr z,+
	ld e,Part.var30
	ld a,(de)
	cp (hl)
	jp z,objectTakePosition
+
	jp partDelete

@state4:
	inc e
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3

@substate0:
	ld h,d
	ld l,e
	inc (hl)
	ld a,(w1Companion.damage)
	dec a
	ld l,Part.speed
	ld (hl),SPEED_80
	jr z,@substate1
	ld (hl),SPEED_100

@substate1:
	ld hl,w1Companion.damage
	ld a,(hl)
	or a
	jr z,+
	call @moveToMaple
	ret nz
	ld l,Part.substate
	inc (hl)
	ld l,Part.collisionType
	res 7,(hl)
	ld bc,-$40
	jp objectSetSpeedZ

@substate2:
	ld c,$00
	call objectUpdateSpeedZ_paramC
	ld e,Part.zh
	ld a,(de)
	cp $f7
	ret nc
+
	ld a,$01
	ld (w1Companion.damageToApply),a
	ld h,d
	ld l,Part.substate
	ld (hl),$03
	ld l,Part.var03
	ld (hl),$00
	ret

@substate3:
	ld e,Part.var03
	ld a,(de)
	rlca
	ret nc
	jp partDelete

@linkCollectedItem:
	ld a,(wDisabledObjects)
	bit 0,a
	ret nz
	ld e,Part.subid
	ld a,(de)
	and $7f
	ld hl,@obtainedValue
	rst_addAToHl
	ld a,(w1Companion.var2a)
	add (hl)
	ld (w1Companion.var2a),a
	ld a,(de)
	and $7f
	jr z,@func_4e6e
	add a
	ld hl,@itemDropTreasureTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld b,a
	ld a,GOLD_JOY_RING
	call cpActiveRing
	ldi a,(hl)
	jr z,+
	cp $ff
	jr z,++
	call cpActiveRing
	jr nz,++
+
	inc hl
++
	ld c,(hl)
	ld a,b
	cp TREASURE_RING
	jr nz,+
	call getRandomRingOfGivenTier
+
	cp TREASURE_POTION
	jr nz,+
	ld a,SND_GETSEED
	call playSound
	ld a,TREASURE_POTION
+
	call giveTreasure
	jp partDelete

@func_4e6e:
	ldbc TREASURE_HEART_PIECE $02
	call createTreasure
	ret nz
	ld l,Interaction.yh
	ld a,(w1Link.yh)
	ldi (hl),a
	inc l
	ld a,(w1Link.xh)
	ld (hl),a
	ld hl,wMapleState
	set 7,(hl)
	jp partDelete

; Data format:
;   b0: Treasure to give
;   b1: Ring to check for (in addition to gold joy ring)
;   b2: Amount to give without ring
;   b3: Amount to give with ring
@itemDropTreasureTable:
	.db TREASURE_HEART_PIECE,   $ff            $01 $01
	.db TREASURE_GASHA_SEED,    $ff            $01 $01
	.db TREASURE_RING,          $ff            $01 $01
	.db TREASURE_RING,          $ff            $02 $02
	.db TREASURE_POTION,        $ff            $01 $01
	.db TREASURE_EMBER_SEEDS,   $ff            $05 $0a
	.db TREASURE_SCENT_SEEDS,   $ff            $05 $0a
	.db TREASURE_PEGASUS_SEEDS, $ff            $05 $0a
	.db TREASURE_GALE_SEEDS,    $ff            $05 $0a
	.db TREASURE_MYSTERY_SEEDS, $ff            $05 $0a
	.db TREASURE_BOMBS,         $ff            $04 $08
	.db TREASURE_HEART_REFILL,  BLUE_JOY_RING, $04 $08
	.db TREASURE_RUPEES,        RED_JOY_RING,  RUPEEVAL_005 RUPEEVAL_010
	.db TREASURE_RUPEES,        RED_JOY_RING,  RUPEEVAL_001 RUPEEVAL_002

@setOamData:
	ld e,Part.subid
	ld a,(de)
	ld c,a
	add a
	add c
	ld hl,@oamData
	rst_addAToHl
	ld e,Part.oamTileIndexBase
	ld a,(de)
	add (hl)
	ld (de),a
	inc hl
	; oamFlags
	dec e
	ldi a,(hl)
	ld (de),a
	; oamFlagsBackup
	dec e
	ld (de),a
	ld a,(hl)
	jp partSetAnimation

@oamData:
	.db $10 $02 $10
	.db $0a $01 $00
	.db $08 $00 $00
	.db $08 $00 $00
	.db $00 $02 $0f
	.db $12 $02 $05
	.db $14 $03 $06
	.db $16 $01 $07
	.db $18 $01 $08
	.db $1a $00 $08
	.db $10 $04 $04
	.db $02 $05 $01
	.db $06 $05 $03
	.db $04 $00 $02

@setDroppedItemPosition:
	ld h,d
	ld l,Part.yh
	ld a,(hl)
	cp $f0
	jr c,+
	xor a
+
	cp $20
	jr nc,+
	ld (hl),$20
	jr ++
+
	cp $78
	jr c,++
	ld (hl),$78
++
	ld l,Part.xh
	ld a,(hl)
	cp $f0
	jr c,+
	xor a
+
	cp $08
	jr nc,+
	ld (hl),$08
	ret
+
	cp $98
	ret c
	ld (hl),$98
	ret

@moveToMaple:
	ld l,<w1Companion.yh
	ld b,(hl)
	ld l,<w1Companion.xh
	ld c,(hl)
	push bc
	call objectGetRelativeAngle
	ld e,Part.angle
	ld (de),a
	call objectApplySpeed
	pop bc
	ld h,d
	ld l,Part.yh
	ldi a,(hl)
	cp b
	ret nz
	inc l
	ld a,(hl)
	cp c
	ret

@obtainedValue:
	.db $3c $0f $0a $08 $06 $05 $05 $05
	.db $05 $05 $04 $03 $02 $01 $00


; ==============================================================================
; PARTID_GASHA_TREE
; ==============================================================================
partCode17:
	jr z,@normalStatus
	ld e,Part.subid
	ld a,(de)
	add a
	ld hl,table_501e
	rst_addDoubleIndex
	ld e,Part.var2a
	ld a,(de)
	and $1f
	call checkFlag
	jr z,@normalStatus
	call checkLinkVulnerable
	jr nc,@normalStatus
	ld h,d
	ld l,Part.state
	ld (hl),$02
	ld l,Part.collisionType
	res 7,(hl)
	ld l,Part.subid
	ld a,(hl)
	or a
	jr z,@normalStatus
	ld a,$2a
	call objectGetRelatedObject1Var
	ld (hl),$ff

@normalStatus:
	ld e,Part.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2

@state0:
	ld a,$01
	ld (de),a
	ld a,$26
	call objectGetRelatedObject1Var
	ld e,Part.collisionRadiusY
	ldi a,(hl)
	ld (de),a
	; collisionRadiusX
	inc e
	ld a,(hl)
	ld (de),a
	call objectTakePosition
	ld e,Part.var30
	ld l,$41
	ld a,(hl)
	ld (de),a
	ret

@state1:
	call @func_4fb2
	ret z
	jp partDelete

@func_4fb2:
	ld a,$01
	call objectGetRelatedObject1Var
	ld e,Part.var30
	ld a,(de)
	cp (hl)
	ret

@state2:
	call @func_4fb2
	jp nz,partDelete
	ld e,Part.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2

@substate0:
	ld h,d
	ld l,e
	inc (hl)
	ld l,Part.speed
	ld (hl),SPEED_100
	ld a,$1a
	call objectGetRelatedObject1Var
	set 6,(hl)
	ld e,Part.subid
	ld a,(de)
	or a
	ld a,$10
	call nz,objectGetAngleTowardLink
	ld e,Part.angle
	ld (de),a
	ld bc,-$140
	jp objectSetSpeedZ

@substate1:
	ld c,$18
	call objectUpdateSpeedZAndBounce
	jr z,+
	call objectApplySpeed
	ld a,$00
	call objectGetRelatedObject1Var
	jp objectCopyPosition
+
	ld e,Part.substate
	ld a,$02
	ld (de),a

@substate2:
	ld c,$18
	call objectUpdateSpeedZAndBounce
	jr nc,func_5010
	call func_5010
	jp partDelete

func_5010:
	call objectCheckTileCollision_allowHoles
	call nc,objectApplySpeed
	ld a,$00
	call objectGetRelatedObject1Var
	jp objectCopyPosition

table_501e:
	.db $f0 $03 $00 $00
	.db $f0 $03 $00 $00


; ==============================================================================
; PARTID_OCTOROK_PROJECTILE
; ==============================================================================
partCode18:
	jr z,@normalStatus
	ld e,$ea
	ld a,(de)
	cp $80
	jp z,partDelete
	ld h,d
	ld l,$c4
	ld a,(hl)
	cp $02
	jr nc,@normalStatus
	ld (hl),$02

@normalStatus:
	ld e,$c4
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
	.dw partCommon_updateSpeedAndDeleteWhenCounter1Is0

@state0:
	ld h,d
	ld l,e
	inc (hl)
	ld l,$d0
	ld (hl),$50
	jp objectSetVisible81

@state1:
	call objectCheckWithinScreenBoundary
	jp nc,partDelete
	call partCommon_checkTileCollisionOrOutOfBounds
	jr nc,+
	jp z,partDelete
	ld e,$c4
	ld a,$02
	ld (de),a
+
	jp objectApplySpeed

@state2:
	ld a,$03
	ld (de),a
	xor a
	jp partCommon_bounceWhenCollisionsEnabled


; ==============================================================================
; PARTID_ZORA_FIRE
; PARTID_GOPONGA_PROJECTILE
; ==============================================================================
partCode19:
partCode31:
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
	ld (hl),$08
	ld l,$d0
	ld (hl),$3c
	jp objectSetVisible81

@state1:
	call partCommon_decCounter1IfNonzero
	ret nz
	ld l,e
	inc (hl)
	ld l,$c2
	bit 0,(hl)
	jr z,+
	ldh a,(<hFFB2)
	ld b,a
	ldh a,(<hFFB3)
	ld c,a
	call objectGetRelativeAngle
	ld e,$c9
	ld (de),a
	ret
+
	call objectGetAngleTowardEnemyTarget
	ld e,$c9
	ld (de),a
	ret

@state2:
	ld a,(wFrameCounter)
	and $03
	jr nz,+
	ld e,$dc
	ld a,(de)
	xor $07
	ld (de),a
+
	call objectApplySpeed
	call objectCheckWithinScreenBoundary
	jp nc,partDelete
	jp partAnimate


; ==============================================================================
; PARTID_ENEMY_ARROW
; ==============================================================================
partCode1a:
	jr z,@normalStatus
	ld e,$ea
	ld a,(de)
	cp $80
	jr z,@partDelete
	jr @func_11_513a
@normalStatus:
	ld e,$c2
	ld a,(de)
	rst_jumpTable
	.dw @subid0
	.dw @subid1

@subid0:
	ld e,$c4
	ld a,(de)
	rst_jumpTable
	.dw @@state0
	.dw @@state1
	.dw partCommon_updateSpeedAndDeleteWhenCounter1Is0

@@state0:
	ld h,d
	ld l,e
	inc (hl)
	ld l,$d0
	ld (hl),$50
	ld l,$cb
	ld b,(hl)
	ld l,$cd
	ld c,(hl)
	call partCommon_setPositionOffsetAndRadiusFromAngle
	ld e,$c9
	ld a,(de)
	swap a
	rlca
	call partSetAnimation
	jp objectSetVisible81

@@state1:
	call partCommon_checkTileCollisionOrOutOfBounds
	jr nc,@objectApplySpeed
	jr z,@partDelete
	jr @func_11_513a

@subid1:
	ld e,$c4
	ld a,(de)
	rst_jumpTable
	.dw @@state0
	.dw @@state1
	.dw @subid0@state1
	.dw partCommon_updateSpeedAndDeleteWhenCounter1Is0

@@state0:
	ld h,d
	ld l,e
	inc (hl)
	ld l,$c6
	ld (hl),$08
	ld l,$d0
	ld (hl),$50
	ld e,$c9
	ld a,(de)
	swap a
	rlca
	call partSetAnimation
	jp objectSetVisible81

@@state1:
	call partCommon_decCounter1IfNonzero
	jr nz,+
	ld l,e
	inc (hl)
	jr @subid0@state1
+
	call partCommon_checkOutOfBounds
	jr z,@partDelete
@objectApplySpeed:
	jp objectApplySpeed
@partDelete:
	jp partDelete
@func_11_513a:
	ld e,$c2
	ld a,(de)
	or a
	ld a,$02
	jr z,+
	ld a,$03
+
	ld e,$c4
	ld (de),a
	ld a,$04
	jp partCommon_bounceWhenCollisionsEnabled


; ==============================================================================
; PARTID_LYNEL_BEAM
; ==============================================================================
partCode1b:
	jr z,@normalStatus
	ld e,$ea
	ld a,(de)
	res 7,a
	cp $04
	jp c,partDelete
@normalStatus:
	ld e,$c4
	ld a,(de)
	or a
	jr z,+
	call objectCheckWithinScreenBoundary
	jp nc,partDelete
	call objectApplySpeed
	ld a,(wFrameCounter)
	and $03
	ret nz
	ld e,$dc
	ld a,(de)
	xor $07
	ld (de),a
	ret
+
	ld h,d
	ld l,e
	inc (hl)
	ld l,$d0
	ld (hl),$78
	ld l,$cb
	ld b,(hl)
	ld l,$cd
	ld c,(hl)
	call partCommon_setPositionOffsetAndRadiusFromAngle
	ld e,$c9
	ld a,(de)
	swap a
	rlca
	call partSetAnimation
	jp objectSetVisible81


; ==============================================================================
; PARTID_STALFOS_BONE
; ==============================================================================
partCode1c:
	jr z,@normalStatus
	ld e,$ea
	ld a,(de)
	cp $80
	jr z,@partDelete
	jr @func_11_51dd

@normalStatus:
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
	ld (hl),$3c
	call objectGetAngleTowardEnemyTarget
	ld e,$c9
	ld (de),a
	jp objectSetVisible81

@state1:
	call partCommon_checkTileCollisionOrOutOfBounds
	jr c,+
	call objectApplySpeed
	call objectCheckWithinScreenBoundary
	jp c,partAnimate

@partDelete:
	jp partDelete

@state2:
	call partCommon_decCounter1IfNonzero
	jr z,@partDelete
	ld c,$0e
	call objectUpdateSpeedZ_paramC
	call objectApplySpeed
	ld a,(wFrameCounter)
	rrca
	ret c
	jp partAnimate
+
	jr z,@partDelete
@func_11_51dd:
	ld e,$c4
	ld a,$02
	ld (de),a
	xor a
	jp partCommon_bounceWhenCollisionsEnabled


; ==============================================================================
; PARTID_ENEMY_SWORD
; ==============================================================================
partCode1d:
	jr z,@normalStatus
	ld e,$ea
	ld a,(de)
	cp $80
	jr z,@normalStatus
	cp $8a
	jr z,@normalStatus
	ld a,$2b
	call objectGetRelatedObject1Var
	ld a,(hl)
	or a
	jr nz,+
	ld e,$eb
	ld a,(de)
	ld (hl),a
+
	ld e,$ec
	ld a,(de)
	inc l
	ldi (hl),a
	ld e,$ed
	ld a,(de)
	ld (hl),a
@normalStatus:
	ld e,$c4
	ld a,(de)
	or a
	jr z,@func_5261
	ld h,d
	ld l,$e4
	set 7,(hl)
	call @func_5273
	jp nz,partDelete

@func_521a:
	ld l,$8b
	ld b,(hl)
	ld l,$8d
	ld c,(hl)
	ld l,$89
	ld a,(hl)
	add $04
	and $18
	rrca
	ldh (<hFF8B),a
	ld l,$a1
	add (hl)
	add (hl)
	ld hl,@table_524d
	rst_addAToHl
	ld e,$cb
	ldi a,(hl)
	add b
	ld (de),a
	ld e,$cd
	ld a,(hl)
	add c
	ld (de),a
	ldh a,(<hFF8B)
	rrca
	and $02
	ld hl,@table_525d
	rst_addAToHl
	ld e,$e6
	ldi a,(hl)
	ld (de),a
	inc e
	ld a,(hl)
	ld (de),a
	ret

@table_524d:
	.db $f8 $04
	.db $f6 $04
	.db $04 $07
	.db $04 $09
	.db $07 $fc
	.db $09 $fc
	.db $04 $f9
	.db $04 $f7

@table_525d:
	.db $05 $02
	.db $02 $05

@func_5261:
	ld h,d
	ld l,e
	inc (hl)
	ld l,$fe
	ld (hl),$04
	ld a,$01
	call objectGetRelatedObject1Var
	ld e,$f0
	ld a,(hl)
	ld (de),a
	jr @func_521a

@func_5273:
	ld a,$01
	call objectGetRelatedObject1Var
	ld e,$f0
	ld a,(de)
	cp (hl)
	ret nz
	ld l,$b0
	bit 0,(hl)
	jr nz,+
	ld l,$a9
	ld a,(hl)
	or a
	jr z,+
	ld l,$ae
	ld a,(hl)
	or a
	jr nz,+
	ld l,$bf
	bit 1,(hl)
	ret z
+
	ld e,$e4
	ld a,(de)
	res 7,a
	ld (de),a
	xor a
	ret


; ==============================================================================
; PARTID_DEKU_SCRUB_PROJECTILE
; ==============================================================================
partCode1e:
	jr z,@normalStatus
	ld e,$ea
	ld a,(de)
	cp $80
	jr z,@normalStatus
	call func_52fd
	ld h,d
	ld l,$c4
	ld (hl),$03
	ld l,$e4
	res 7,(hl)
@normalStatus:
	ld e,$c4
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3
	.dw partCommon_updateSpeedAndDeleteWhenCounter1Is0
	.dw @state5

@state0:
	ld h,d
	ld l,e
	inc (hl)
	ld l,$d0
	ld (hl),$50
	ld l,$c6
	ld (hl),$08
	ld a,SND_STRIKE
	call playSound
	jp objectSetVisible81

@state1:
	call partCommon_decCounter1IfNonzero
	jr nz,+
	ld l,e
	inc (hl)

@state2:
	call partCommon_checkTileCollisionOrOutOfBounds
	jr nc,+
	jr nz,func_52f4
	jr @state5
+
	call objectCheckWithinScreenBoundary
	jp c,objectApplySpeed
	jr @state5

@state3:
	call func_5336
	jr @state2

@state5:
	jp partDelete

func_52f4:
	ld e,$c4
	ld a,$04
	ld (de),a
	xor a
	jp partCommon_bounceWhenCollisionsEnabled

func_52fd:
	ld e,$c9
	ld a,(de)
	bit 2,a
	jr nz,func_5313
	sub $08
	rrca
	ld b,a
	ld a,(w1Link.direction)
	add b
	ld hl,table_532a
	rst_addAToHl
	ld a,(hl)
	ld (de),a
	ret

func_5313:
	sub $0c
	rrca
	ld b,a
	ld a,(w1Link.direction)
	add b
	ld hl,table_5322
	rst_addAToHl
	ld a,(hl)
	ld (de),a
	ret

table_5322:
	.db $04 $08 $10 $14
	.db $1c $0c $10 $18

table_532a:
	.db $04 $08 $0c $18
	.db $00 $0c $10 $14
	.db $1c $08 $14 $18

func_5336:
	ld a,$24
	call objectGetRelatedObject1Var
	bit 7,(hl)
	ret z
	call checkObjectsCollided
	ret nc
	ld l,$aa
	ld (hl),$82
	ld l,$b0
	dec (hl)
	ld l,$ab
	ld (hl),$0c
	ld e,$c4
	ld a,$04
	ld (de),a
	ret


; ==============================================================================
; PARTID_WIZZROBE_PROJECTILE
; ==============================================================================
partCode1f:
	jr nz,@normalStatus
	ld e,$c4
	ld a,(de)
	or a
	jr z,func_5369
	call objectCheckWithinScreenBoundary
	jr nc,@normalStatus
	call partCommon_checkTileCollisionOrOutOfBounds
	jp nc,objectApplySpeed
@normalStatus:
	jp partDelete

func_5369:
	ld h,d
	ld l,e
	inc (hl)
	ld l,$d0
	ld (hl),$50
	ld e,$c9
	ld a,(de)
	swap a
	rlca
	call partSetAnimation
	jp objectSetVisible81


; ==============================================================================
; PARTID_FIRE
; Created by fire keese
; ==============================================================================
partCode20:
	ld e,$c4
	ld a,(de)
	or a
	jr z,@state0
	call partCommon_decCounter1IfNonzero
	jp z,partDelete
	jp partAnimate

@state0:
	ld h,d
	ld l,e
	inc (hl)
	ld l,$c6
	ld (hl),$b4
	jp objectSetVisible82


; ==============================================================================
; PARTID_MOBLIN_BOOMERANG
; ==============================================================================
partCode21:
	jr z,@normalStatus
	ld e,$ea
	ld a,(de)
	res 7,a
	sub $01
	cp $03
	jr nc,@normalStatus
	ld e,$c4
	ld a,$02
	ld (de),a

@normalStatus:
	ld e,$d7
	ld a,(de)
	inc a
	jr z,@partDelete
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
	ld (hl),$2d
	inc l
	ld (hl),$06
	ld l,$d0
	ld (hl),$50
	jp objectSetVisible81

@state1:
	call objectCheckSimpleCollision
	jr nz,@func_53ee
	call partCommon_decCounter1IfNonzero
	jr z,@func_53ee
	call func_542a
@objectApplySpeed:
	call objectApplySpeed
@animate:
	jp partAnimate

@state2:
	call func_541a
	call func_53f5
	jr nc,@objectApplySpeed
	ld a,$18
	call objectGetRelatedObject1Var
	xor a
	ldi (hl),a
	ld (hl),a
@partDelete:
	jp partDelete

@func_53ee:
	ld e,$c4
	ld a,$02
	ld (de),a
	jr @animate

func_53f5:
	ld a,$0b
	call objectGetRelatedObject1Var
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
	ret nc
	ld l,$8d
	ld e,$cd
	ld a,(de)
	sub (hl)
	add $04
	cp $09
	ret

func_541a:
	ld a,(wFrameCounter)
	and $03
	ret nz
	ld e,$d0
	ld a,(de)
	add $05
	cp $50
	ret nc
	ld (de),a
	ret

func_542a:
	ld h,d
	ld l,$c7
	dec (hl)
	ret nz
	ld (hl),$06
	ld e,$d0
	ld a,(de)
	sub $05
	ret c
	ld (de),a
	ret


; ==============================================================================
; PARTID_CUCCO_ATTACKER
; ==============================================================================
partCode22:
	ld e,Part.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2

@state0:
	ld h,d
	ld l,e
	inc (hl) ; [state]

	ld l,Part.counter1
	ld (hl),$18
	ld l,Part.zh
	ld (hl),$fa

	ld a,Object.var30
	call objectGetRelatedObject1Var
	ld a,(hl)
	sub $10
	and $1e
	rrca
	ld hl,@speedVals
	rst_addAToHl
	ld e,Part.speed
	ld a,(hl)
	ld (de),a

	call objectSetVisiblec1

	call getRandomNumber_noPreserveVars
	ld c,a
	and $30
	ld b,a
	swap b
	and $10
	ld hl,@xOrYVals
	rst_addAToHl
	ld a,c
	and $0f
	rst_addAToHl
	bit 0,b
	ld e,Part.yh
	ld c,Part.xh
	jr nz,+
	ld e,c
	ld c,Part.yh
+
	ld a,(hl)
	ld (de),a

	ld a,b
	ld hl,@screenEdgePositions
	rst_addAToHl
	ld e,c
	ld a,(hl)
	ld (de),a
	call objectGetAngleTowardEnemyTarget
	ld e,Part.angle
	ld (de),a

	; Decide animation based on angle
	cp $11
	ld a,$00
	jr nc,+
	inc a
+
	jp partSetAnimation


@state1:
	call partCommon_decCounter1IfNonzero
	jr nz,@applySpeedAndAnimate
	ld l,e
	inc (hl)
	jr @applySpeedAndAnimate


@state2:
	call objectCheckWithinScreenBoundary
	jp nc,partDelete
@applySpeedAndAnimate:
	call objectApplySpeed
	jp partAnimate

@screenEdgePositions:
	.db $08 $98 $88 $08

@xOrYVals:
	.db $05 $0e $17 $20 $29 $32 $3b $44
	.db $4d $56 $5f $68 $71 $7a $83 $8c
	.db $05 $0f $19 $23 $2d $37 $41 $4b
	.db $55 $5f $69 $73 $7d $87 $91 $9b

@speedVals:
	.db SPEED_140 SPEED_180 SPEED_1c0 SPEED_200
	.db SPEED_240 SPEED_240 SPEED_280 SPEED_2c0
	.db SPEED_300


; ==============================================================================
; PARTID_FALLING_FIRE
; ==============================================================================
partCode23:
	ld e,$c2
	ld a,(de)
	ld e,$c4
	rst_jumpTable
	.dw @subid0
	.dw @subid1
	.dw @subid2

@subid0:
	ld a,(de)
	or a
	jr z,@func_54f6
	call partCommon_decCounter1IfNonzero
	ret nz
.ifdef ROM_AGES
	ld (hl),$78
.else
	ld (hl),$3c
.endif
	jr ++
@func_54f6:
	inc a
	ld (de),a
	ret

@subid1:
	ld a,(de)
	or a
	jr z,@func_54f6
	call partCommon_decCounter1IfNonzero
	ret nz
	call func_553f
++
	call getFreePartSlot
	ret nz
	ld (hl),PARTID_FALLING_FIRE
	inc l
	ld (hl),$02
	ld l,$f0
	ld e,l
	ld a,(de)
	ld (hl),a
	jp objectCopyPosition

@subid2:
	ld a,(de)
	or a
	jr z,func_5535
	ld h,d
	ld l,$cb
	ld a,(hl)
	cp $b0
	jp nc,partDelete
	ld l,$d0
	ld e,$ca
	call add16BitRefs
	dec l
	ld a,(hl)
	add $10
	ldi (hl),a
	ld a,(hl)
	adc $00
	ld (hl),a
	jp partAnimate

func_5535:
	ld h,d
	ld l,e
	inc (hl)
	ld l,$e4
	set 7,(hl)
	jp objectSetVisible81

func_553f:
	ld e,$87
	ld a,(de)
	inc a
	and $03
	ld (de),a
	ld hl,table_554f
	rst_addAToHl
	ld e,$c6
	ld a,(hl)
	ld (de),a
	ret

table_554f:
.ifdef ROM_AGES
	.db $78 $78
.else
	.db $3c $3c
.endif
	.db $1e $1e


; ==============================================================================
; PARTID_LIGHTNING
; ==============================================================================
partCode27:
	ld e,Part.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2

@state0:
	ld a,$01
	ld (de),a
	call getRandomNumber_noPreserveVars
	ld e,Part.var30
	and $06
	ld (de),a

	ld h,d
	ld l,Part.zh
	ld (hl),$c0

	ld l,Part.relatedObj1+1
	ld a,(hl)
	or a
	ret z

	ld l,Part.counter1
	ld (hl),$1e
	ld l,Part.yh
	ldh a,(<hEnemyTargetY)
	ldi (hl),a
	inc l
	ldh a,(<hEnemyTargetX)
	ld (hl),a
	ret

@state1:
	call partCommon_decCounter1IfNonzero
	ret nz
	ld l,e
	inc (hl)
	ld a,SND_LIGHTNING
	call playSound
	jp objectSetVisible81

@state2:
	call partAnimate
	ld e,Part.animParameter
	ld a,(de)
	inc a
	jp z,partDelete

	call @func_55a6
	ld e,Part.var03
	ld a,(de)
	or a
	ret z
.ifdef ROM_AGES
	ld a,$ff
.else
	ld b,a
	ld a,($cfd2)
	or b
.endif
	ld ($cfd2),a
	ret

@func_55a6:
	ld e,Part.animParameter
	ld a,(de)
	bit 7,a
	call nz,@func_55e7
	ld e,Part.animParameter
	ld a,(de)
	and $0e

	ld hl,@table_55da
	rst_addAToHl
	ld e,$e6
	ldi a,(hl)
	ld (de),a
	inc e
	ld a,(hl)
	ld (de),a
	ld e,Part.animParameter
	ld a,(de)
	and $70
	swap a
	ld hl,@table_55e2
	rst_addAToHl
	ld e,$cf
	ld a,(hl)
	ld (de),a
	ld e,$e1
	ld a,(de)
	bit 0,a
	ret z
	dec a
	ld (de),a
	ld a,$06
	jp setScreenShakeCounter

@table_55da:
	.db $02 $02
	.db $04 $06
	.db $05 $09
	.db $04 $05

@table_55e2:
	.db $c0 $d0
	.db $e0 $f0
	.db $00

@func_55e7:
	res 7,a
	ld (de),a
	and $0e
	sub $02
	ld b,a
	ld e,Part.var30
	ld a,(de)
	add b
	ld hl,@table_5603
	rst_addAToHl
	ldi a,(hl)
	ld c,(hl)
	ld b,a
	call getFreeInteractionSlot
	ret nz
	ld (hl),$08
	jp objectCopyPositionWithOffset

@table_5603:
	.db $02 $06
	.db $00 $fb
	.db $ff $07
	.db $fd $fc
	.db $00 $05


; ==============================================================================
; PARTID_SMALL_FAIRY
; ==============================================================================
partCode28:
	jr z,@normalStatus
	cp $02
	jp z,@collected
	ld e,$c4
	ld a,$02
	ld (de),a
@normalStatus:
	ld e,$c4
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2

@state0:
	ld h,d
	ld l,$c4
	inc (hl)
	ld l,$cf
	ld (hl),$fa
	ld l,$f1
	ld e,$cb
	ld a,(de)
	ldi (hl),a
	ld e,$cd
	ld a,(de)
	ld (hl),a
	jp objectSetVisiblec2

@state1:
	call partCommon_decCounter1IfNonzero
	jr z,+
	call func_56cd
	jp c,objectApplySpeed
+
	call getRandomNumber_noPreserveVars
	and $3e
	add $08
	ld e,$c6
	ld (de),a
	call getRandomNumber_noPreserveVars
	and $03
	ld hl,@table_5666
	rst_addAToHl
	ld e,$d0
	ld a,(hl)
	ld (de),a
	call getRandomNumber_noPreserveVars
	and $1e
	ld h,d
	ld l,$c9
	ld (hl),a
	jp func_56b6

@table_5666:
	.db $0a
	.db $14
	.db $1e
	.db $28

@state2:
	ld e,$c5
	ld a,(de)
	or a
	jr nz,+
	ld h,d
	ld l,e
	inc (hl)
	ld l,$cf
	ld (hl),$00
	ld a,$01
	call objectGetRelatedObject1Var
	ld a,(hl)
	ld e,$f0
	ld (de),a
	call objectSetVisible80
+
	call objectCheckCollidedWithLink
	jp c,@collected
	ld a,$00
	call objectGetRelatedObject1Var
	ldi a,(hl)
	or a
	jr z,+
	ld e,$f0
	ld a,(de)
	cp (hl)
	jp z,objectTakePosition
+
	jp partDelete

@collected:
	ld a,$26
	call cpActiveRing
	ld c,$18
	jr z,+
	ld a,$25
	call cpActiveRing
	jr nz,++
+
	ld c,$30
++
	ld a,$29
	call giveTreasure
	jp partDelete

func_56b6:
	ld e,$c9
	ld a,(de)
	and $0f
	ret z
	ld a,(de)
	cp $10
	ld a,$00
	jr nc,+
	inc a
+
	ld h,d
	ld l,$c8
	cp (hl)
	ret z
	ld (hl),a
	jp partSetAnimation

func_56cd:
	ld e,$c9
	ld a,(de)
	and $07
	ld a,(de)
	jr z,+
	and $18
	add $04
+
	and $1c
	rrca
	ld hl,table_56f5
	rst_addAToHl
	ld e,$cb
	ld a,(de)
	add (hl)
	ld b,a
	ld e,$cd
	inc hl
	ld a,(de)
	add (hl)
	sub $38
	cp $80
	ret nc
	ld a,b
	sub $18
	cp $50
	ret

table_56f5:
	.db $fc $00 $fc $04
	.db $00 $04 $04 $04
	.db $04 $00 $04 $fc
	.db $00 $fc $fc $fc


; ==============================================================================
; PARTID_BEAM
; ==============================================================================
partCode29:
	jr z,@normalStatus
	ld e,$ea
	ld a,(de)
	cp $83
	jp z,partDelete
@normalStatus:
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
	ld (hl),$02
	ld l,$c9
	ld c,(hl)
	ld b,$50
	ld a,$04
	call objectSetComponentSpeedByScaledVelocity
	ld e,$c9
	ld a,(de)
	and $0f
	ld hl,@table_5737
	rst_addAToHl
	ld a,(hl)
	jp partSetAnimation

@table_5737:
	.db $00 $00 $01 $02
	.db $02 $02 $03 $04
	.db $04 $04 $05 $06
	.db $06 $06 $07 $00

@state1:
	call partCommon_decCounter1IfNonzero
	jr nz,func_5758
	ld l,e
	inc (hl)

@state2:
	call func_5758
	call partCommon_checkTileCollisionOrOutOfBounds
	jp c,partDelete
	ret

func_5758:
	call objectApplyComponentSpeed
	ld e,$c2
	ld a,(de)
	ld b,a
	ld a,(wFrameCounter)
	and b
	jp z,objectSetVisible81
	jp objectSetInvisible


; ==============================================================================
; PARTID_SPIKED_BALL
;
; Variables:
;   speed: Nonstandard usage; it's a 16-bit variable which gets added to var30 (distance
;          away from origin).
;   relatedObj1: ENEMYID_BALL_AND_CHAIN_SOLDIER (for the head / subid 0),
;                or PARTID_SPIKED_BALL (the head; for subids 1-3).
;   var30: Distance away from origin point
; ==============================================================================
partCode2a:
	jr z,@normalStatus

	; Check for sword or shield collision
	ld e,Part.var2a
	ld a,(de)
	res 7,a
	sub ITEMCOLLISION_L1_SHIELD
	cp ITEMCOLLISION_SWORD_HELD-ITEMCOLLISION_L1_SHIELD + 1
	jr nc,@normalStatus

	; Make "parent" immune since the ball blocked the attack
	ld a,Object.invincibilityCounter
	call objectGetRelatedObject1Var
	ld a,(hl)
	or a
	jr nz,+
	ld (hl),$f4
+
	; If speedZ is positive, make it 0?
	ld h,d
	ld l,Part.speedZ+1
	ld a,(hl)
	rlca
	jr c,@normalStatus
	xor a
	ldd (hl),a
	ld (hl),a

@normalStatus:
	ld e,Part.subid
	ld a,(de)
	ld b,a
	ld e,Part.state
	ld a,b
	rst_jumpTable
	.dw spikedBall_head
	.dw spikedBall_chain
	.dw spikedBall_chain
	.dw spikedBall_chain


; The main part of the spiked ball (actually has collisions, etc)
spikedBall_head:
	; Check if parent was deleted
	ld a,Object.id
	call objectGetRelatedObject1Var
	ld a,(hl)
	cp ENEMYID_BALL_AND_CHAIN_SOLDIER
	jp nz,partDelete

	ld b,h
	call spikedBall_updateStateFromParent
	ld e,Part.state
	ld a,(de)
	rst_jumpTable
	.dw spikedBall_head_state0
	.dw spikedBall_head_state1
	.dw spikedBall_head_state2
	.dw spikedBall_head_state3
	.dw spikedBall_head_state4
	.dw spikedBall_head_state5


; Initialization
spikedBall_head_state0:
	ld h,d
	ld l,e
	inc (hl) ; [state]

	ld l,Part.collisionType
	set 7,(hl)
	call objectSetVisible81


; Rotating slowly
spikedBall_head_state1:
	ld e,Part.angle
	ld a,(de)
	inc a
	and $1f
	ld (de),a
	jr spikedBall_head_setDefaultDistanceAway


; Rotating faster
spikedBall_head_state2:
	ld e,Part.angle
	ld a,(de)
	add $02
	and $1f
	ld (de),a

spikedBall_head_setDefaultDistanceAway:
	ld e,Part.var30
	ld a,$0a
	ld (de),a

;;
; @param	b	Enemy object
spikedBall_updatePosition:
	call spikedBall_copyParentPosition
	ld e,Part.var30
	ld a,(de)
	ld e,Part.angle
	jp objectSetPositionInCircleArc


; About to throw the ball; waiting for it to rotate into a good position for throwing.
spikedBall_head_state3:
	call spikedBall_copyParentPosition

	; Compare the ball's angle with Link; must keep rotating it until it's aligned
	; perfectly.
	ldh a,(<hEnemyTargetY)
	ldh (<hFF8F),a
	ldh a,(<hEnemyTargetX)
	ldh (<hFF8E),a
	push hl
	call objectGetRelativeAngleWithTempVars
	pop bc
	xor $10
	ld e,a
	sub $06
	and $1f
	ld h,d
	ld l,Part.angle
	sub (hl)
	inc a
	and $1f
	cp $03
	jr nc,spikedBall_head_state2 ; keep rotating

	; It's aligned perfectly; begin throwing it.
	ld a,e
	sub $03
	and $1f
	ld (hl),a ; [angle]

	ld l,Part.state
	inc (hl)

	ld l,Part.var30
	ld (hl),$0d
	jp spikedBall_updatePosition


; Ball has just been released
spikedBall_head_state4:
	ld h,d
	ld l,e
	inc (hl) ; [state]

	ld l,Part.counter1
	ld (hl),$00

	ld l,Part.angle
	ld a,(hl)
	add $03
	and $1f
	ld (hl),a

	; Distance from origin
	ld l,Part.var30
	ld (hl),$12

	; speed variable is used in a nonstandard way (added to var30, aka distance from
	; origin)
	ld l,Part.speed
	ld a,<($0340)
	ldi (hl),a
	ld (hl),>($0340)

	jp spikedBall_updatePosition


spikedBall_head_state5:
	call spikedBall_checkCollisionWithItem
	call spikedBall_head_updateDistanceFromOrigin
	jp spikedBall_updatePosition


; The chain part of the ball (just decorative)
spikedBall_chain:
	ld a,(de)
	or a
	jr nz,@state1

@state0:
	inc a
	ld (de),a ; [state]
	call partSetAnimation
	call objectSetVisible81

@state1:
	ld a,Object.id
	call objectGetRelatedObject1Var
	ld a,(hl)
	cp PARTID_SPIKED_BALL
	jp nz,partDelete

	; Copy parent's angle
	ld l,Part.angle
	ld e,l
	ld a,(hl)
	ld (de),a

	call spikedBall_chain_updateDistanceFromOrigin
	ld l,Part.relatedObj1+1
	ld b,(hl)
	jp spikedBall_updatePosition


;;
; @param	b	Enemy object
spikedBall_copyParentPosition:
	ld h,b
	ld l,Enemy.yh
	ldi a,(hl)
	sub $05
	ld b,a
	inc l
	ldi a,(hl)
	sub $05
	ld c,a
	inc l
	ld a,(hl)
	ld e,Part.zh
	ld (de),a
	ret


;;
; If the ball collides with any item other than Link, this sets its speed to 0 (begins
; retracting earlier).
spikedBall_checkCollisionWithItem:
	; Check for collision with any item other than Link himself
	ld h,d
	ld l,Part.var2a
	bit 7,(hl)
	ret z
	ld a,(hl)
	cp $80|ITEMCOLLISION_LINK
	ret z

	ld l,Part.speed+1
	bit 7,(hl)
	ret nz
	xor a
	ldd (hl),a
	ld (hl),a
	ret


;;
spikedBall_head_updateDistanceFromOrigin:
	ld h,d
	ld e,Part.var30
	ld l,Part.speed+1
	ld a,(de)
	add (hl)
	cp $0a
	jr c,@fullyRetracted

	ld (de),a

	; Deceleration
	dec l
	ld a,(hl)
	sub <($0020)
	ldi (hl),a
	ld a,(hl)
	sbc >($0020)
	ld (hl),a
	ret

@fullyRetracted:
	; Tell parent (ENEMYID_BALL_AND_CHAIN_SOLDIER) we're fully retracted
	ld a,Object.counter1
	call objectGetRelatedObject1Var
	ld (hl),$00
	ret


;;
; Reads parent's var30 to decide whether to update state>
spikedBall_updateStateFromParent:
	ld l,Enemy.var30

	; Check state between 1-3
	ld e,Part.state
	ld a,(de)
	dec a
	cp $03
	jr c,++

	; If uninitialized (state 0), return
	inc a
	ret z

	; State is 4 or above (ball is being thrown).
	; Continue if [parent.var30] != 2 (signal to throw ball)
	ld a,(hl)
	cp $02
	ret z
++
	; Set state to:
	; * 1 if [parent.var30] == 0 (ball rotates slowly)
	; * 2 if [parent.var30] == 1 (ball rotates quickly)
	; * 3 if [parent.var30] >= 2 (ball should be thrown)
	ld a,(hl)
	or a
	ld c,$01
	jr z,++
	inc c
	dec a
	jr z,++
	inc c
++
	ld e,Part.state
	ld a,c
	ld (de),a
	ret

;;
; @param	h	Parent object (the actual ball)
spikedBall_chain_updateDistanceFromOrigin:
	ld l,Part.var30
	push hl
	ld e,Part.subid
	ld a,(de)
	dec a
	rst_jumpTable
	.dw @subid1
	.dw @subid2
	.dw @subid3

@subid1:
	; [var30] = [parent.var30] * 3/4
	pop hl
	ld e,l
	ld a,(hl)
	srl a
	srl a
	ld b,a
	add a
	add b
	inc a
	ld (de),a
	ret

@subid2:
	; [var30] = [parent.var30] * 2/4
	pop hl
	ld e,l
	ld a,(hl)
	srl a
	srl a
	add a
	ld (de),a
	ret

@subid3:
	; [var30] = [parent.var30] * 1/4
	pop hl
	ld e,l
	ld a,(hl)
	srl a
	srl a
	ld (de),a
	ret


; ==============================================================================
; PARTID_GREAT_FAIRY_HEART
; ==============================================================================
partCode30:
	ld e,$c4
	ld a,(de)
	or a
	jr nz,+
	ld h,d
	ld l,e
	inc (hl)
	ld l,$c6
	ld (hl),$03
	call objectSetVisible81
+
	ldh a,(<hEnemyTargetY)
	ld b,a
	ldh a,(<hEnemyTargetX)
	ld c,a
	ld a,$20
	ld e,$c9
	call objectSetPositionInCircleArc
	call partCommon_decCounter1IfNonzero
	ret nz
	ld (hl),$03
	ld l,$c9
	ld a,(hl)
	dec a
	and $1f
	ld (hl),a
	ret nz
	ld hl,wLinkMaxHealth
	ld a,(wDisplayedHearts)
	cp (hl)
	ret nz
	ld a,$31
	call objectGetRelatedObject1Var
	dec (hl)
	jp partDelete


; ==============================================================================
; PARTID_RED_TWINROVA_PROJECTILE
; PARTID_BLUE_TWINROVA_PROJECTILE
;
; Variables:
;   relatedObj1: Instance of ENEMYID_TWINROVA that fired the projectile
;   relatedObj2: Instance of ENEMYID_TWINROVA that could be hit by the projectile
; ==============================================================================
partCode4b:
partCode4d:
	jr z,@normalStatus

	ld e,Part.var2a
	ld a,(de)
	cp $80|ITEMCOLLISION_L3_SHIELD
	jp z,partDelete

	cp $80|ITEMCOLLISION_LINK
	jr z,@normalStatus

	; Gets reflected
	call objectGetAngleTowardEnemyTarget
	xor $10
	ld h,d
	ld l,Part.angle
	ld (hl),a
	ld l,Part.state
	ld (hl),$03
	ld l,Part.speed
	ld (hl),SPEED_280

@normalStatus:
	; Check if twinrova is dead
	ld a,Object.state
	call objectGetRelatedObject1Var
	ld a,(hl)
	cp $0d
	jp nc,@deleteWithPoof

	ld e,Part.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3

@state0:
	ld h,d
	ld l,e
	inc (hl) ; [state] = 1

	ld l,Part.counter1
	ld (hl),30
	ld l,Part.speed
	ld (hl),SPEED_200

	; Transfer z-position to y-position
	ld l,Part.zh
	ld a,(hl)
	ld (hl),$00
	ld l,Part.yh
	add (hl)
	ld (hl),a

	; Get the other twinrova object, put it in relatedObj2
	ld a,Object.relatedObj1
	call objectGetRelatedObject1Var
	ld e,Part.relatedObj2
	ldi a,(hl)
	ld (de),a
	inc e
	ld a,(hl)
	ld (de),a

	; Play sound depending which one it is
	ld e,Part.id
	ld a,(de)
	cp PARTID_RED_TWINROVA_PROJECTILE
	ld a,SND_BEAM1
	jr z,+
	ld a,SND_BEAM2
+
	call playSound
	call objectSetVisible81

; Being charged up
@state1:
	call partCommon_decCounter1IfNonzero
	jr z,@fire

	; Copy parent's position
	ld a,Object.yh
	call objectGetRelatedObject1Var
	ld bc,$ea00
	call objectTakePositionWithOffset
	xor a
	ld (de),a ; [zh] = 0
	jr @animate

@fire:
	call objectGetAngleTowardEnemyTarget
	ld e,Part.angle
	ld (de),a

	ld h,d
	ld l,Part.state
	inc (hl) ; [state] = 2

	ld l,Part.collisionType
	set 7,(hl)

; Moving
@state2:
	call objectApplySpeed
	call partCommon_checkOutOfBounds
	jr z,@delete
@animate:
	jp partAnimate

@state3:
	ld a,$00
	call objectGetRelatedObject2Var
	call checkObjectsCollided
	jr nc,@state2

	; Collided with opposite-color twinrova
	ld l,Enemy.invincibilityCounter
	ld (hl),20
	ld l,Enemy.health
	dec (hl)
	jr nz,++

	; Other twinrova's health is 0; set a signal.
	ld l,Enemy.var32
	set 6,(hl)
++
	; Decrement health of same-color twinrova as well
	ld a,Object.health
	call objectGetRelatedObject1Var
	dec (hl)

	ld a,SND_BOSS_DAMAGE
	call playSound
@delete:
	jp partDelete

@deleteWithPoof:
	call objectCreatePuff
	jp partDelete


; ==============================================================================
; PARTID_TWINROVA_FLAME
; ==============================================================================
partCode4c:
	jr z,@normalStatus
	ld e,$ea
	ld a,(de)
	cp $80
	jp nz,partDelete
@normalStatus:
	ld e,$c2
	ld a,(de)
	or a
	ld e,$c4
	ld a,(de)
	jr z,@subid0
	or a
	jr z,+
	call partAnimate
	call objectApplySpeed
	call partCommon_checkTileCollisionOrOutOfBounds
	ret nz
	jp partDelete
+
	ld h,d
	ld l,e
	inc (hl)
	ld l,$d0
	ld (hl),$50
	ld l,$db
	ld a,$05
	ldi (hl),a
	ld (hl),a
	ld l,$e6
	ld a,$02
	ldi (hl),a
	ld (hl),a
	ld a,SND_BEAM2
	call playSound
	ld a,$01
	call partSetAnimation
	jp objectSetVisible82

@subid0:
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
	ld (hl),$1e
	jp objectSetVisible82

@state1:
	call partCommon_decCounter1IfNonzero
	jp nz,partAnimate
	ld l,e
	inc (hl)
	call objectGetAngleTowardEnemyTarget
	ld e,$c9
	ld (de),a

@state2:
	call partAnimate
	call objectApplySpeed
	call partCommon_checkTileCollisionOrOutOfBounds
	ret nc
	call objectGetAngleTowardEnemyTarget
	sub $02
	and $1f
	ld c,a
	ld b,$03
-
	call getFreePartSlot
	jr nz,+
	ld (hl),PARTID_TWINROVA_FLAME
	inc l
	inc (hl)
	ld l,$c9
	ld (hl),c
	call objectCopyPosition
+
	ld a,c
	add $02
	and $1f
	ld c,a
	dec b
	jr nz,-
	call objectCreatePuff
	jp partDelete


; ==============================================================================
; PARTID_TWINROVA_SNOWBALL
; ==============================================================================
partCode4e:
	jr z,@normalStatus

	; Hit something
	ld e,Part.var2a
	ld a,(de)
	cp $80|ITEMCOLLISION_L3_SHIELD
	jr z,@destroy

	res 7,a
	sub ITEMCOLLISION_L2_SWORD
	cp ITEMCOLLISION_SWORDSPIN - ITEMCOLLISION_L2_SWORD + 1
	jp c,@destroy

@normalStatus:
	ld e,Part.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2

@state0:
	ld h,d
	ld l,e
	inc (hl) ; [state] = 1

	ld l,Part.counter1
	ld (hl),30

	ld l,Part.speed
	ld (hl),SPEED_240

	ld a,SND_TELEPORT
	call playSound
	jp objectSetVisible82


; Spawning in, not moving yet
@state1:
	call partCommon_decCounter1IfNonzero
	jr z,@beginMoving

	ld l,Part.animParameter
	bit 0,(hl)
	jr z,@animate

	ld (hl),$00
	ld l,Part.collisionType
	set 7,(hl)
@animate:
	jp partAnimate

@beginMoving:
	ld l,e
	inc (hl) ; [state] = 2

	call objectGetAngleTowardEnemyTarget
	ld e,Part.angle
	ld (de),a


; Moving toward Link
@state2:
	call objectApplySpeed
	call partCommon_checkTileCollisionOrOutOfBounds
	ret nc

@destroy:
	ld b,INTERACID_SNOWDEBRIS
	call objectCreateInteractionWithSubid00
	jp partDelete


; ==============================================================================
; PARTID_GANON_TRIDENT
; ==============================================================================
partCode50:
	ld a,$04
	call objectGetRelatedObject1Var
	ld a,(hl)
	cp $0e
	jp z,partDelete
	push hl
	ld e,$c4
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2

@state0:
	ld a,$01
	ld (de),a
	pop hl
	call objectTakePosition
	ld l,$b2
	ld a,(hl)
	or a
	jr z,+
	ld a,$01
+
	jp partSetAnimation

@state1:
	call partAnimate
	ld e,$e1
	ld a,(de)
	inc a
	jr nz,func_5b2b
	ld h,d
	ld l,$c4
	inc (hl)
	ld l,$e6
	ld a,$07
	ldi (hl),a
	ld (hl),a
	call objectSetInvisible

@state2:
	pop hl
	inc l
	ld a,(hl)
	or a
	jp z,partDelete
	ld bc,$2000
	jp objectTakePositionWithOffset

func_5b2b:
	ld h,d
	ld l,e
	bit 7,(hl)
	jr z, +
	res 7,(hl)
	call objectSetVisible82
	ld a,SND_BIGSWORD
	call playSound
	ld h,d
	ld l,$e1
+
	ld a,(hl)
	ld hl,table_5b5b
	rst_addAToHl
	ld e,$e6
	ldi a,(hl)
	ld (de),a
	inc e
	ldi a,(hl)
	ld (de),a
	ldi a,(hl)
	ld b,a
	ld c,(hl)
	pop hl
	ld l,$b2
	ld a,(hl)
	or a
	jr z,+
	ld a,c
	cpl
	inc a
	ld c,a
+
	jp objectTakePositionWithOffset

table_5b5b:
	.db $07 $07 $d8 $f1
	.db $0b $07 $e7 $1a
	.db $20 $0c $f7 $19


; ==============================================================================
; PARTID_51
; Used by Ganon
; ==============================================================================
partCode51:
	ld a,$04
	call objectGetRelatedObject1Var
	ld a,(hl)
	cp $0e
	jp z,partDelete
	ld e,$c2
	ld a,(de)
	ld e,$c4
	rst_jumpTable
	.dw @subid0
	.dw @subid1
	.dw @subid2

@subid0:
	ld a,(de)
	or a
	jr nz,+
	ld h,d
	ld l,e
	inc (hl)
	ld l,$c6
	ld (hl),$40
	ld l,$e8
	ld (hl),$f0
	ld l,$da
	ld (hl),$02
	ld a,SND_ENERGYTHING
	call playSound
+
	call partCommon_decCounter1IfNonzero
	jp z,partDelete
	jr +

@subid2:
	ld a,(de)
	or a
	jr z,++
	ld e,$e1
	ld a,(de)
	rlca
	jp c,partDelete
+
	ld e,$da
	ld a,(de)
	xor $80
	ld (de),a
	jp partAnimate
++
	ld h,d
	ld l,e
	inc (hl)
	ld l,$e4
	set 7,(hl)
	ld l,$c9
	ld a,(hl)
	ld b,$01
	cp $0c
	jr c,+
	inc b
	cp $19
	jr c,+
	inc b
+
	ld a,b
	dec a
	and $01
	ld hl,@table_5bde
	rst_addDoubleIndex
	ld e,$e6
	ldi a,(hl)
	ld (de),a
	inc e
	ld a,(hl)
	ld (de),a
	ld a,b
	call partSetAnimation
	jp objectSetVisible83

@table_5bde:
	.db $08 $0a
	.db $0a $0a

@subid1:
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2

@state0:
	ld h,d
	ld l,e
	inc (hl)
	ld l,$dd
	ld a,(hl)
	add $0e
	ld (hl),a
	ld l,$c6
	ld (hl),$18
	ld a,$04
	call partSetAnimation
	jp objectSetVisible82

@state1:
	call partCommon_decCounter1IfNonzero
	jr nz,@animate
	dec (hl)
	ld l,e
	inc (hl)
	ld l,$e4
	set 7,(hl)
	ld l,$db
	ld a,$05
	ldi (hl),a
	ld (hl),a
	ld l,$cb
	ld a,(hl)
	add $08
	ldi (hl),a
	inc l
	ld a,(hl)
	sub $10
	ld (hl),a
	call objectGetAngleTowardLink
	ld e,$c9
	ld (de),a
	ld c,a
	ld b,$50
	ld a,$02
	jp objectSetComponentSpeedByScaledVelocity

@state2:
	call partCommon_checkTileCollisionOrOutOfBounds
	jr nc,+
	ld b,INTERACID_EXPLOSION
	call objectCreateInteractionWithSubid00
	ld a,$3c
	call z,setScreenShakeCounter
	jp partDelete
+
	call partCommon_decCounter1IfNonzero
	ld a,(hl)
	and $07
	jr nz,+
	call getFreePartSlot
	jr nz,+
	ld (hl),PARTID_51
	inc l
	ld (hl),$02
	ld l,$c9
	ld e,l
	ld a,(de)
	ld (hl),a
	call objectCopyPosition
+
	call objectApplyComponentSpeed
@animate:
	jp partAnimate


; ==============================================================================
; PARTID_52
; Used by Ganon
; ==============================================================================
partCode52:
	ld a,$04
	call objectGetRelatedObject1Var
	ld a,(hl)
	cp $0e
	jp z,partDelete
	ld e,$c2
	ld a,(de)
	ld e,$c4
	rst_jumpTable
	.dw @subid0
	.dw @subid1
	.dw @subid2

@subid0:
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
	ld (hl),$0a
	jp objectSetVisible82

@@state1:
	call partCommon_decCounter1IfNonzero
	jr nz,+
	ld l,e
	inc (hl)
	ld a,SND_BEAM
	call playSound
	ld a,$02
	call partSetAnimation

@@state2:
	call partCommon_checkOutOfBounds
	jp z,partDelete
	call objectApplySpeed
+
	jp partAnimate

@subid1:
	ld a,(de)
	rst_jumpTable
	.dw @@state0
	.dw @@state1
	.dw @@state2
	.dw @subid0@state2

@@state0:
	ld h,d
	ld l,$d0
	ld (hl),$50
	ld l,e
	call objectSetVisible82
	ld e,$c3
	ld a,(de)
	or a
	jr z,+
	ld (hl),$03
	ld l,$e6
	ld a,$02
	ldi (hl),a
	ld (hl),a
	ret
+
	inc (hl)
	ld l,$c6
	ld (hl),$28
	ld l,$e6
	ld a,$04
	ldi (hl),a
	ld (hl),a
	ld e,$cb
	ld l,$f0
	ld a,(de)
	add $20
	ldi (hl),a
	ld e,$cd
	ld a,(de)
	ld (hl),a
	ld a,$01
	call partSetAnimation

@@state1:
	call partCommon_decCounter1IfNonzero
	jr z,++
	ld a,(hl)
	rrca
	ld e,$c9
	jr c,+
	ld a,(de)
	inc a
	and $1f
	ld (de),a
+
	ld l,$da
	ld a,(hl)
	xor $80
	ld (hl),a
	ld l,$f0
	ld b,(hl)
	inc l
	ld c,(hl)
	ld a,$08
	call objectSetPositionInCircleArc
	jr @@animate
++
	ld (hl),$0a
	ld l,e
	inc (hl)
	ld a,SND_VERAN_PROJECTILE
	call playSound
	call objectSetVisible82
@@animate:
	jp partAnimate

@@state2:
	call partCommon_decCounter1IfNonzero
	jr z,+
	call objectApplySpeed
	jr @@animate
+
	ld l,e
	inc (hl)
	ld l,$e6
	ld a,$02
	ldi (hl),a
	ld (hl),a
	xor a
	call partSetAnimation
	call objectCreatePuff
	ld b,$fd
	call @func_5d31
	ld b,$03

@func_5d31:
	call getFreePartSlot
	ret nz
	ld (hl),PARTID_52
	inc l
	inc (hl)
	inc l
	inc (hl)
	ld l,$c9
	ld e,l
	ld a,(de)
	add b
	and $1f
	ld (hl),a
	jp objectCopyPosition

@subid2:
	ld a,(de)
	rst_jumpTable
	.dw @@state0
	.dw @@state1
	.dw @@state2
	.dw @subid0@state2

@@state0:
	ld h,d
	ld l,e
	inc (hl)
	ld l,$c6
	ld (hl),$0f
	jp objectSetVisible82

@@state1:
	call partCommon_decCounter1IfNonzero
	jp nz,partAnimate
	ld (hl),$0f
	ld l,e
	inc (hl)
	ld a,SND_VERAN_FAIRY_ATTACK
	call playSound
	ld a,$01
	jp partSetAnimation

@@state2:
	call partCommon_decCounter1IfNonzero
	jp nz,partAnimate
	ld l,e
	inc (hl)
	ld l,$d0
	ld (hl),$5a
	call objectGetAngleTowardLink
	ld e,$c9
	ld (de),a
	ld a,$02
	jp partSetAnimation


; ==============================================================================
; PARTID_BLUE_ENERGY_BEAD
; Used by "createEnergySwirl" functions
; ==============================================================================
partCode53:
	ld e,$c4
	ld a,(de)
	or a
	jr z,@state0
	ld a,(wDeleteEnergyBeads)
	or a
	jp nz,partDelete
	ld h,d
	ld l,$c6
	ld a,(hl)
	inc a
	jr z,+
	dec (hl)
	jp z,partDelete
+
	inc e
	ld a,(de)
	or a
	jr nz,+
	inc l
	dec (hl)
	ret nz
	ld l,e
	inc (hl)
	ld l,$f2
	ld a,(hl)
	swap a
	rrca
	ld l,$c3
	add (hl)
	call partSetAnimation
	call func_5e1a
	jp objectSetVisible
+
	call objectApplySpeed
	call partAnimate
	ld e,$e1
	ld a,(de)
	inc a
	ret nz
	ld h,d
	ld l,$c5
	dec (hl)
	call objectSetInvisible
	jr +
@state0:
	ld h,d
	ld l,e
	inc (hl)
	ld l,$c0
	set 7,(hl)
	ld l,$d0
	ld (hl),$78
	ld l,$c3
	ld a,(hl)
	add a
	add a
	xor $10
	ld l,$c9
	ld (hl),a
	xor a
	ld (wDeleteEnergyBeads),a
+
	call getRandomNumber_noPreserveVars
	and $07
	inc a
	ld e,$c7
	ld (de),a
	ret

;;
createEnergySwirlGoingOut_body:
	ld a,$01
	jr ++

;;
; @param	bc	Center of the swirl
; @param	l	Duration of swirl ($ff and $00 are infinite)?
createEnergySwirlGoingIn_body:
	xor a
++
	ldh (<hFF8B),a
	push de
	ld e,l
	ld d,$08
--
	call getFreePartSlot
	jr nz,@end

	; Part.id
	ld (hl),PARTID_BLUE_ENERGY_BEAD

	; Set duration
	ld l,Part.counter1
	ld (hl),e

	; Set center of swirl
	ld l,Part.var30
	ld (hl),b
	inc l
	ld (hl),c
	inc l

	; [Part.var32] = whether it's going in or out
	ldh a,(<hFF8B)
	ld (hl),a

	; Give each Part a unique index
	ld l,Part.var03
	dec d
	ld (hl),d
	jr nz,--

@end:
	pop de
	ld a,SND_ENERGYTHING
	jp playSound

func_5e1a:
	ld h,d
	ld l,Part.var32
	ldd a,(hl)
	or a
	jr nz,+
	ld e,Part.var03
	ld a,(de)
	add a
	add a
	ld e,Part.direction
	ld (de),a
	ld c,(hl)
	dec l
	ld b,(hl)
	ld a,$38
	jp objectSetPositionInCircleArc
+
	ld e,Part.xh
	ldd a,(hl)
	ld (de),a
	ld e,Part.yh
	ld a,(hl)
	ld (de),a
	ret

.ifdef ROM_SEASONS
.ends

.include "code/roomInitialization.s"

 m_section_free Part_Code_2 NAMESPACE partCode
.endif


label_11_212:
	ld d,$d0
	ld a,d
-
	ldh (<hActiveObject),a
	ld e,$c0
	ld a,(de)
	or a
	jr z,++
	rlca
	jr c,+
	ld e,$c4
	ld a,(de)
	or a
	jr nz,++
+
	call func_11_5e8a
++
	inc d
	ld a,d
	cp $e0
	jr c,-
	ret

;;
updateParts:
	ld a,$c0
	ldh (<hActiveObjectType),a
	ld a,(wScrollMode)
	cp $08
	jr z,label_11_212
	ld a,(wTextIsActive)
	or a
	jr nz,label_11_212

	ld a,(wDisabledObjects)
	and $88
	jr nz,label_11_212

	ld d,FIRST_PART_INDEX
	ld a,d
-
	ldh (<hActiveObject),a
	ld e,Part.enabled
	ld a,(de)
	or a
	jr z,+

	call func_11_5e8a
	ld h,d
	ld l,Part.var2a
	res 7,(hl)
+
	inc d
	ld a,d
	cp LAST_PART_INDEX+1
	jr c,-
	ret

;;
func_11_5e8a:
	call partCommon_standardUpdate

	; hl = partCodeTable + [Part.id] * 2
	ld e,Part.id
	ld a,(de)
	add a
	add <partCodeTable
	ld l,a
	ld a,$00
	adc >partCodeTable
	ld h,a

	ldi a,(hl)
	ld h,(hl)
	ld l,a

	ld a,c
	or a
	jp hl
