; ==================================================================================================
; ENEMY_TARGET_CART_CRYSTAL
;
; Variables:
;   var03: 0 for no movement, 1 for up/down, 2 for left/right
; ==================================================================================================
enemyCode63:
	jr z,@normalStatus	 

	; ENEMYSTATUS_JUST_HIT
	ld e,Enemy.state
	ld a,$02
	ld (de),a

@normalStatus:
	ld e,Enemy.state
	ld a,(de)
	rst_jumpTable
	.dw targetCartCrystal_state0
	.dw targetCartCrystal_state1
	.dw targetCartCrystal_state2


; Initialization
targetCartCrystal_state0:
	ld a,$01
	ld (de),a ; [state]
	call targetCartCrystal_loadPosition
	call targetCartCrystal_loadBehaviour
	jr z,+
	call targetCartCrystal_initSpeed
+
	jp objectSetVisible80


; Standard update state (update movement if it's a moving type)
targetCartCrystal_state1:
	ld e,Enemy.var03
	ld a,(de)
	or a
	jr z,+
	call targetCartCrystal_updateMovement
+
	ld e,Enemy.subid
	ld a,(de)
	cp $05
	jr nc,++
	ld a,(wTmpcfc0.targetCarts.cfdf)
	or a
	jp nz,enemyDelete
++
	jp enemyAnimate


; Target destroyed
targetCartCrystal_state2:
	ld hl,wTmpcfc0.targetCarts.numTargetsHit
	inc (hl)

	; If in the first room, mark this one as destroyed
	ld e,Enemy.subid
	ld a,(de)
	cp $05
	jr nc,++
	ld hl,wTmpcfc0.targetCarts.crystalsHitInFirstRoom
	call setFlag
++
	ld a,SND_GALE_SEED
	call playSound

	; Create the "debris" from destroying it
	ld a,$04
@spawnNext:
	ldh (<hFF8B),a
	ldbc INTERAC_FALLING_ROCK,$03
	call objectCreateInteraction
	jr nz,@delete
	ld l,Interaction.angle
	ldh a,(<hFF8B)
	dec a
	ld (hl),a
	jr nz,@spawnNext

@delete:
	jp enemyDelete



;;
; Sets var03 to "behaviour" value (0-2)
;
; @param[out]	zflag	z iff [var03] == 0
targetCartCrystal_loadBehaviour:
	ld a,(wTmpcfc0.targetCarts.targetConfiguration)
	swap a
	ld hl,@behaviourTable
	rst_addAToHl
	ld e,Enemy.subid
	ld a,(de)
	rst_addAToHl
	ld a,(hl)
	inc e
	ld (de),a ; [var03]
	or a
	ret

@behaviourTable:
	.db $00 $00 $00 $00 $00 $00 $00 $00 ; Configuration 0
	.db $00 $00 $00 $00 $00 $00 $00 $00

	.db $00 $00 $00 $00 $02 $00 $00 $00 ; Configuration 1
	.db $00 $01 $00 $02 $00 $00 $00 $00

	.db $01 $00 $02 $00 $00 $00 $00 $02 ; Configuration 2
	.db $01 $01 $02 $02 $00 $00 $00 $00


;;
; Sets Y/X position based on "wTmpcfc0.targetCarts.targetConfiguration" and subid.
targetCartCrystal_loadPosition:
	ld a,(wTmpcfc0.targetCarts.targetConfiguration)
	ld hl,@configurationTable
	rst_addAToHl
	ld a,(hl)
	rst_addAToHl

	ld e,Enemy.subid
	ld a,(de)
	rst_addDoubleIndex
	ldi a,(hl)
	ld e,Enemy.yh
	ld (de),a
	ld a,(hl)
	ld e,Enemy.xh
	ld (de),a
	ret


; Lists positions of the 12 targets for each of the 3 configurations.
@configurationTable:
	dbrel @configuration0
	dbrel @configuration1
	dbrel @configuration2

@configuration0:
	.db $18 $38 ; 0 == [subid]
	.db $48 $58 ; 1 == [subid]
	.db $28 $98 ; ...
	.db $48 $c8
	.db $18 $b8
	.db $58 $38
	.db $28 $98
	.db $28 $d8
	.db $58 $d8
	.db $98 $d8
	.db $98 $90
	.db $98 $58

@configuration1:
	.db $48 $18
	.db $18 $38
	.db $48 $58
	.db $48 $68
	.db $18 $a8
	.db $18 $48
	.db $58 $68
	.db $18 $88
	.db $18 $d8
	.db $58 $d8
	.db $98 $d8
	.db $98 $78

@configuration2:
	.db $20 $18
	.db $48 $68
	.db $18 $70
	.db $48 $98
	.db $48 $c8
	.db $28 $68
	.db $58 $68
	.db $18 $b8
	.db $40 $d8
	.db $80 $d8
	.db $98 $90
	.db $98 $50

;;
targetCartCrystal_initSpeed:
	ld h,d
	ld l,Enemy.speed
	ld (hl),SPEED_80

	ld l,Enemy.counter1
	ld (hl),$20

	ld l,Enemy.var03
	ld a,(hl)
	cp $02
	jr z,++
	ld l,Enemy.angle
	ld (hl),ANGLE_UP
	ret
++
	ld l,Enemy.angle
	ld (hl),ANGLE_LEFT
	ret

;;
; Crystal moves for a bit, switches directions, moves other way.
targetCartCrystal_updateMovement:
	call ecom_decCounter1
	jr nz,++
	ld (hl),$40
	ld l,Enemy.angle
	ld a,(hl)
	xor $10
	ld (hl),a
++
	jp objectApplySpeed
