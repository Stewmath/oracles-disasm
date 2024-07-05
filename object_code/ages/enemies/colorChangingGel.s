; ==================================================================================================
; ENEMY_COLOR_CHANGING_GEL
;
; Variables:
;   var30/var31: Target position while hopping
;   var32: Tile index at current position (purposely outdated so there's lag in updating
;          the color)
; ==================================================================================================
enemyCode47:
	call ecom_checkHazards
	jr z,@normalStatus
	sub ENEMYSTATUS_NO_HEALTH
	ret c
	jp z,enemyDie

	; ENEMYSTATUS_JUST_HIT

	ld h,d
	ld l,Enemy.var2a
	ld a,(hl)
	cp $80|ITEMCOLLISION_MYSTERY_SEED
	jr nz,@attacked

	; Mystery seed hit the gel
	call colorChangingGel_chooseRandomColor
	jr @normalStatus

@attacked:
	; Ignore all attacks if color matches floor
	ld e,Enemy.enemyCollisionMode
	ld a,(de)
	cp ENEMYCOLLISION_COLOR_CHANGING_GEL
	jr nz,@normalStatus

	; Only allow switch hook and sword attacks to kill the gel
	ldi a,(hl)
	res 7,a
	cp ITEMCOLLISION_SWITCH_HOOK
	jr z,@wasDamagingAttack
	sub ITEMCOLLISION_L1_SWORD
	cp ITEMCOLLISION_SWORD_HELD-ITEMCOLLISION_L1_SWORD + 1
	jr nc,@normalStatus

@wasDamagingAttack
	ld (hl),$f4 ; [invincibilityCounter] = $f4
	ld a,SND_DAMAGE_ENEMY
	call playSound

@normalStatus:
	call colorChangingGel_updateColor
	ld e,Enemy.state
	ld a,(de)
	rst_jumpTable
	.dw colorChangingGel_state_uninitialized
	.dw colorChangingGel_state_stub
	.dw colorChangingGel_state_stub
	.dw colorChangingGel_state_stub
	.dw colorChangingGel_state_stub
	.dw ecom_blownByGaleSeedState
	.dw colorChangingGel_state_stub
	.dw colorChangingGel_state_stub
	.dw colorChangingGel_state8
	.dw colorChangingGel_state9
	.dw colorChangingGel_stateA


colorChangingGel_state_uninitialized:
	ld a,SPEED_140
	call ecom_setSpeedAndState8AndVisible

	ld l,Enemy.counter1
	ld (hl),150
	inc l
	ld (hl),$00 ; [counter2]

	ld l,Enemy.enemyCollisionMode
	ld (hl),ENEMYCOLLISION_COLOR_CHANGING_GEL

	ld l,Enemy.var3f
	set 5,(hl)

	call objectGetTileAtPosition
	ld e,Enemy.var32
	ld (de),a

	ld a,PALH_bf
	call loadPaletteHeader
	ld a,$03
	jp enemySetAnimation


colorChangingGel_state_stub:
	ret


; Standing still for [counter1] frames
colorChangingGel_state8:
	call ecom_decCounter1
	ret nz

	inc (hl) ; [counter1] = 1

	; Choose random direction to jump
	call getRandomNumber_noPreserveVars
	and $0e
	ld hl,@directionsToJump
	rst_addAToHl

	; Store target position in var30/var31
	ld e,Enemy.yh
	ld a,(de)
	add (hl)
	ld e,Enemy.var30
	ld (de),a
	ld b,a

	ld e,Enemy.xh
	ld a,(de)
	inc hl
	add (hl)
	ld e,Enemy.var31
	ld (de),a
	ld c,a

	; Target position must not be solid (if it is, try again next frame)
	call getTileCollisionsAtPosition
	ret nz

	call ecom_incState

	ld l,Enemy.counter1
	ld (hl),60

	ld l,Enemy.speedZ
	ld a,<(-$180)
	ldi (hl),a
	ld (hl),>(-$180)

	ld a,$02
	jp enemySetAnimation

@directionsToJump:
	.db $f0 $f0
	.db $f0 $00
	.db $f0 $10
	.db $00 $f0
	.db $00 $10
	.db $10 $f0
	.db $10 $00
	.db $10 $10


; Waiting [counter1] frames before hopping to target position
colorChangingGel_state9:
	call ecom_decCounter1
	jp nz,enemyAnimate

	ld l,e
	inc (hl) ; [state]

	; Calculate angle to jump in
	ld h,d
	ld l,Enemy.var30
	call ecom_readPositionVars
	call objectGetRelativeAngleWithTempVars
	and $10
	swap a
	jp enemySetAnimation


; Hopping to target
colorChangingGel_stateA:
	ld c,$30
	call objectUpdateSpeedZ_paramC
	jr nz,@stillInAir

	; Landed
	ld l,Enemy.state
	ld (hl),$08

	ld l,Enemy.counter1
	ld (hl),150

	call objectCenterOnTile

	ld a,$03
	jp enemySetAnimation

@stillInAir:
	; Move toward position if we're not there yet already (ignoring Z position)
	ld l,Enemy.var30
	call ecom_readPositionVars
	sub c
	inc a
	cp $03
	jr nc,++
	ldh a,(<hFF8F)
	sub b
	inc a
	cp $03
	ret c
++
	jp ecom_moveTowardPosition


;;
; Updates the gel's color with intentional lag. Every 90 frames, this uses the value of
; var32 (tile index) to set the gel's color, then it updates the value of var32. Due to
; the order this is done in, it takes 180 frames for the color to update fully.
colorChangingGel_updateColor:
	; Must be on ground
	ld e,Enemy.zh
	ld a,(de)
	rlca
	ret c

	; Wait for cooldown
	call ecom_decCounter2
	jr z,@updateStoredColor

	; If [counter2] == 1, update color
	ld a,(hl)
	dec a
	jr z,@updateColor

	pop bc
	jr @updateImmunity

@updateColor:
	; Update color based on tile index stored in var32 (which may be outdated).
	ld e,Enemy.var32
	ld a,(de)
	call @lookupFloorColor
	ldi (hl),a ; [oamFlagsBackup]
	ld (hl),a  ; [oamFlags]

@updateStoredColor:
	call @updateImmunity
	ret z

	pop bc
	ld l,Enemy.counter2
	ld (hl),90

	; Write tile index to var32?
	ld l,Enemy.var32
	ld (hl),e
	ret

;;
; Sets enemyCollisionMode depending on whether the gel's color matches the floor or not.
;
; @param[out]	zflag	z if immune
@updateImmunity:
	call objectGetTileAtPosition
	cp TILEINDEX_SOMARIA_BLOCK
	ret z

	call @lookupFloorColor
	cp (hl)
	ld b,ENEMYCOLLISION_COLOR_CHANGING_GEL
	jr z,+
	ld b,ENEMYCOLLISION_GOHMA_GEL
+
	ld l,Enemy.enemyCollisionMode
	ld (hl),b
	ret

;;
; @param	a	Tile index
; @param[out]	a	Color (defaults to red ($02) if floor tile not listed)
; @param[out]	hl	Enemy.oamFlagsBackup
@lookupFloorColor:
	ld e,a
	ld hl,@floorColors
	call lookupKey
	ld h,d
	ld l,Enemy.oamFlagsBackup
	ret c
	ld a,$02
	ret

@floorColors:
	.db TILEINDEX_RED_FLOOR,         , $02
	.db TILEINDEX_YELLOW_FLOOR       , $06
	.db TILEINDEX_BLUE_FLOOR         , $01
	.db TILEINDEX_RED_TOGGLE_FLOOR   , $02
	.db TILEINDEX_YELLOW_TOGGLE_FLOOR, $06
	.db TILEINDEX_BLUE_TOGGLE_FLOOR  , $01
	.db $00

;;
; Sets the gel's color to something random that isn't its current color.
colorChangingGel_chooseRandomColor:
	call getRandomNumber_noPreserveVars
	and $01
	ld b,a
	ld e,Enemy.oamFlagsBackup
	ld a,(de)
	res 0,a
	add b
	ld hl,@oamFlagMap
	rst_addAToHl

	ldi a,(hl)
	ld (de),a ; [oamFlagsBackup]
	inc e
	ld (de),a ; [oamFlags]
	ret

@oamFlagMap:
	.db $02 $06 $01 $06 $ff $ff $01 $02
