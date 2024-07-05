; ==================================================================================================
; PART_ITEM_DROP
;
; Variables:
;   relatedObj1: ?
;   var30: ID of relatedObj1
;   var31/var32: Position to move towards?
;   var33: Counter until collisions are enabled (fairy only)
;   var34: Set to $01 when it hits water in a sidescrolling area
; ==================================================================================================
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
	ld b,ENEMY_PODOBOO_TOWER
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
	.db ENEMY_ROPE,   ENEMY_ROPE,   ENEMY_ROPE,   ENEMY_BEETLE
	.db ENEMY_BEETLE, ENEMY_BEETLE, ENEMY_BEETLE, ENEMY_BEETLE

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

	ld b,INTERAC_SPLASH
	xor a
	jr @onWaterSidescrolling

@onHazard:
	rrca
	jr c,@onWater
	rrca
	ld b,INTERAC_LAVASPLASH
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
	ld b,INTERAC_SPLASH
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

.include {"{GAME_DATA_DIR}/tile_properties/conveyorItemDropTiles.s"}
