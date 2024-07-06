; Maple variables:
;
;  var03:  gets set to 0 (rarer item drops) or 1 (standard item drops) when spawning.
;
;  relatedObj1: pointer to a bomb object (maple can suck one up when on her vacuum).
;  relatedObj2: At first, this is a pointer to data in the rom determining Maple's path?
;               When collecting items, this is a pointer to the item she's collecting.
;
;  damage: maple's vehicle (0=broom, 1=vacuum, 2=ufo)
;  health: the value of the loot that Maple's gotten
;  var2a:  the value of the loot that Link's gotten
;
;  invincibilityCounter: nonzero if maple's dropped a heart piece
;  knockbackAngle: actually stores bitmask for item indices 1-4; a bit is set if the item
;                  has been spawned. These items can't spawn more than once.
;  stunCounter: the index of the item that Maple is picking up
;
;  var3a: When recoiling, this gets copied to speedZ?
;         During item collection, this is the delay for maple turning?
;  var3b: Counter until Maple can update her angle by a unit. (Length determined by var3a)
;  var3c: Counter until Maple's Z speed reverses (when floating up and down)
;  var3d: Angle that she's turning toward
;  var3f: Value from 0-2 which determines how much variation there is in maple's movement
;         path? (The variation in her movement increases as she's encountered more often.)
specialObjectCode_maple:
	call companionRetIfInactiveWithoutStateCheck
	ld e,SpecialObject.state
	ld a,(de)
	rst_jumpTable
	.dw mapleState0
	.dw mapleState1
	.dw mapleState2
	.dw mapleState3
	.dw mapleState4
	.dw mapleState5
	.dw mapleState6
	.dw mapleState7
	.dw mapleState8
	.dw mapleState9
	.dw mapleStateA
	.dw mapleStateB
	.dw mapleStateC

;;
; State 0: Initialization
mapleState0:
	xor a
	ld (wcc85),a
	call specialObjectSetOamVariables

	; Set 'c' to be the amount of variation in maple's path (higher the more she's
	; been encountered)
	ld c,$02
	ld a,(wMapleState)
	and $0f
	cp $0f
	jr z,+
	dec c
	cp $08
	jr nc,+
	dec c
+
	ld a,c
	ld e,SpecialObject.var3f
	ld (de),a

	; Determine maple's vehicle (written to "damage" variable); broom/vacuum in normal
	; game, or broom/ufo in linked game.
	or a
	jr z,+
	ld a,$01
+
	ld e,SpecialObject.damage
	ld (de),a
	or a
	jr z,++
	call checkIsLinkedGame
	jr z,++
	ld a,$02
	ld (de),a
++
	call itemIncState

	ld l,SpecialObject.yh
	ld a,$10
	ldi (hl),a  ; [yh] = $10
	inc l
	ld (hl),$b8 ; [xh] = $b8

	ld l,SpecialObject.zh
	ld a,$88
	ldi (hl),a

	ld (hl),SPEED_140 ; [speed] = SPEED_140

	ld l,SpecialObject.collisionRadiusY
	ld a,$08
	ldi (hl),a
	ld (hl),a

	ld l,SpecialObject.knockbackCounter
	ld (hl),$03

	; Decide on Maple's drop pattern.
	; If [var03] = 0, it's a rare item pattern (1/8 times).
	; If [var03] = 1, it's a standard pattern  (7/8 times).
	call getRandomNumber
	and $07
	jr z,+
	ld a,$01
+
	ld e,SpecialObject.var03
	ld (de),a

	ld hl,mapleShadowPathsTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a

	ld e,SpecialObject.var3a
	ldi a,(hl)
	ld (de),a
	inc e
	ld (de),a
	ld e,SpecialObject.relatedObj2
	ld a,l
	ld (de),a
	inc e
	ld a,h
	ld (de),a

	ld a,(hl)
	ld e,SpecialObject.angle
	ld (de),a
	call mapleDecideNextAngle
	call objectSetVisiblec0
	ld a,$19
	jp specialObjectSetAnimation

;;
mapleState1:
	call mapleState4
	ret nz
	ld a,(wMenuDisabled)
	or a
	jp nz,mapleDeleteSelf

	ld a,MUS_MAPLE_THEME
	ld (wActiveMusic),a
	jp playSound

;;
; State 4: lying on ground after being hit
mapleState4:
	ld hl,w1Companion.knockbackCounter
	dec (hl)
	ret nz
	call itemIncState
	xor a
	ret

;;
; State 2: flying around (above screen or otherwise) before being hit
mapleState2:
	ld a,(wTextIsActive)
	or a
	jr nz,@animate
	ld hl,w1Companion.counter2
	ld a,(hl)
	or a
	jr z,+
	dec (hl)
	ret
+
	ld l,SpecialObject.var3d
	ld a,(hl)
	ld l,SpecialObject.angle
	cp (hl)
	jr z,+
	call mapleUpdateAngle
	jr ++
+
	ld l,SpecialObject.counter1
	dec (hl)
	call z,mapleDecideNextAngle
	jr z,@label_05_262
++
	call objectApplySpeed
	ld e,SpecialObject.var3e
	ld a,(de)
	or a
	ret z

.ifdef ROM_AGES
	call checkLinkVulnerableAndIDZero
.else
	call checkLinkID0AndControlNormal
.endif
	jr nc,@animate
	call objectCheckCollidedWithLink_ignoreZ
	jr c,mapleCollideWithLink
@animate:
	call mapleUpdateOscillation
	jp specialObjectAnimate

@label_05_262:
	ld hl,w1Companion.var3e
	ld a,(hl)
	or a
	jp nz,mapleDeleteSelf

	inc (hl)
	call mapleInitZPositionAndSpeed

	ld l,SpecialObject.speed
	ld (hl),SPEED_200
	ld l,SpecialObject.counter2
	ld (hl),$3c

	ld e,SpecialObject.var3f
	ld a,(de)

	ld e,$03
	or a
	jr z,++
	set 2,e
	cp $01
	jr z,++
	set 3,e
++
	call getRandomNumber
	and e
	ld hl,mapleMovementPatternIndices
	rst_addAToHl
	ld a,(hl)
	ld hl,mapleMovementPatternTable
	rst_addDoubleIndex

	ld e,SpecialObject.yh
	ldi a,(hl)
	ld h,(hl)
	ld l,a

	ldi a,(hl)
	ld (de),a
	ld e,SpecialObject.xh
	ldi a,(hl)
	ld (de),a

	ldi a,(hl)
	ld e,SpecialObject.var3a
	ld (de),a
	inc e
	ld (de),a

	ld a,(hl)
	ld e,SpecialObject.angle
	ld (de),a

	ld e,SpecialObject.relatedObj2
	ld a,l
	ld (de),a
	inc e
	ld a,h
	ld (de),a

;;
; Updates var3d with the angle Maple should be turning toward next, and counter1 with the
; length of time she should stay in that angle.
;
; @param[out]	zflag	z if we've reached the end of the "angle data".
mapleDecideNextAngle:
	ld hl,w1Companion.relatedObj2
	ldi a,(hl)
	ld h,(hl)
	ld l,a

	ld e,SpecialObject.var3d
	ldi a,(hl)
	ld (de),a
	ld c,a
	ld e,SpecialObject.counter1
	ldi a,(hl)
	ld (de),a

	ld e,SpecialObject.relatedObj2
	ld a,l
	ld (de),a
	inc e
	ld a,h
	ld (de),a

	ld a,c
	cp $ff
	ret z
	jp mapleDecideAnimation

;;
; Handles stuff when Maple collides with Link. (Sets knockback for both, sets Maple's
; animation, drops items, and goes to state 3.)
;
mapleCollideWithLink:
	call dropLinkHeldItem
	call mapleSpawnItemDrops

	ld a,$01
	ld (wDisableScreenTransitions),a
	ld (wMenuDisabled),a
	ld a,$3c
	ld (wInstrumentsDisabledCounter),a
	ld e,SpecialObject.counter1
	xor a
	ld (de),a

	; Set knockback direction and angle for Link and Maple
	call mapleGetCardinalAngleTowardLink
	ld b,a
	ld hl,w1Link.knockbackCounter
	ld (hl),$18

	ld e,SpecialObject.angle
	ld l,<w1Link.knockbackAngle
	ld (hl),a
	xor $10
	ld (de),a

	; Determine maple's knockback speed
	ld e,SpecialObject.damage
	ld a,(de)
	ld hl,@speeds
	rst_addAToHl
	ld a,(hl)
	ld e,SpecialObject.speed
	ld (de),a

	ld e,SpecialObject.var3a
	ld a,$fc
	ld (de),a
	ld a,$0f
	ld (wScreenShakeCounterX),a

	ld e,SpecialObject.state
	ld a,$03
	ld (de),a

	; Determine animation? ('b' currently holds the angle toward link.)
	ld a,b
	add $04
	add a
	add a
	swap a
	and $01
	xor $01
	add $10
	ld b,a
	ld e,SpecialObject.damage
	ld a,(de)
	add a
	add b
	call specialObjectSetAnimation

	ld a,SND_SCENT_SEED
	jp playSound

@speeds:
	.db SPEED_100
	.db SPEED_140
	.db SPEED_180

;;
; State 3: recoiling after being hit
mapleState3:
	ld a,(w1Link.knockbackCounter)
	or a
	jr nz,+
	ld a,$01
	ld (wDisabledObjects),a
+
	ld h,d
	ld e,SpecialObject.var3a
	ld a,(de)
	or a
	jr z,@animate

	ld e,SpecialObject.zh
	ld a,(de)
	or a
	jr nz,@applyKnockback

	; Update speedZ
	ld e,SpecialObject.var3a
	ld l,SpecialObject.speedZ+1
	ld a,(de)
	inc a
	ld (de),a
	ld (hl),a

@applyKnockback:
	ld c,$40
	call objectUpdateSpeedZ_paramC
	call objectApplySpeed
	call mapleKeepInBounds
	call objectGetTileCollisions
	ret z
	jr @counteractWallSpeed

@animate:
	ld a,(wDisabledObjects)
	or a
	ret z

	; Wait until the animation gives the signal to go to state 4
	ld e,SpecialObject.animParameter
	ld a,(de)
	cp $ff
	jp nz,specialObjectAnimate
	ld e,SpecialObject.knockbackCounter
	ld a,$78
	ld (de),a
	ld e,SpecialObject.state
	ld a,$04
	ld (de),a
	ret

; If maple's hitting a wall, counteract the speed being applied.
@counteractWallSpeed:
	ld e,SpecialObject.angle
	call convertAngleDeToDirection
	ld hl,@offsets
	rst_addDoubleIndex
	ld e,SpecialObject.yh
	ld a,(de)
	add (hl)
	ld b,a
	inc hl
	ld e,SpecialObject.xh
	ld a,(de)
	add (hl)
	ld c,a

	ld h,d
	ld l,SpecialObject.yh
	ld (hl),b
	ld l,SpecialObject.xh
	ld (hl),c
	ret

@offsets:
	.db $04 $00 ; DIR_UP
	.db $00 $fc ; DIR_RIGHT
	.db $fc $00 ; DIR_DOWN
	.db $00 $04 ; DIR_LEFT

;;
; State 5: floating back up after being hit
mapleState5:
	ld hl,w1Companion.counter1
	ld a,(hl)
	or a
	jr nz,@floatUp

; counter1 has reached 0

	inc (hl)
	call mapleInitZPositionAndSpeed
	ld l,SpecialObject.zh
	ld (hl),$ff
	ld a,$01
	ld l,SpecialObject.var3a
	ldi (hl),a
	ld (hl),a  ; [var3b] = $01

	; Reverse direction (to face Link)
	ld e,SpecialObject.angle
	ld a,(de)
	xor $10
	ld (de),a
	call mapleDecideAnimation

@floatUp:
	ld e,SpecialObject.damage
	ld a,(de)
	ld c,a

	; Rise one pixel per frame
	ld e,SpecialObject.zh
	ld a,(de)
	dec a
	ld (de),a
	cp $f9
	ret nc

	; If on the ufo or vacuum cleaner, rise 16 pixels higher
	ld a,c
	or a
	jr z,@finishedFloatingUp
	ld a,(de)
	cp $e9
	ret nc

@finishedFloatingUp:
	ld a,(wMapleState)
	bit 4,a
	jr nz,@exchangeTouchingBook

	ld l,SpecialObject.state
	ld (hl),$06

	; Set collision radius variables
	ld e,SpecialObject.damage
	ld a,(de)
	ld hl,@collisionRadii
	rst_addDoubleIndex
	ld e,SpecialObject.collisionRadiusY
	ldi a,(hl)
	ld (de),a
	inc e
	ld a,(hl)
	ld (de),a

.ifdef ROM_AGES
	; Check if this is the past. She says something about coming through a "weird
	; tunnel", which is probably their justification for her being in the past? She
	; only says this the first time she's encountered in the past.
	ld a,(wActiveGroup)
	dec a
	jr nz,@normalEncounter

	ld a,(wMapleState)
	and $0f
	ld bc,TX_0712
	jr z,++

	ld a,GLOBALFLAG_44
	call checkGlobalFlag
	ld bc,TX_0713
	jr nz,@normalEncounter
++
	ld a,GLOBALFLAG_44
	call setGlobalFlag
	jr @showText
.endif

@normalEncounter:
	; If this is the first encounter, show TX_0700
	ld a,(wMapleState)
	and $0f
	ld bc,TX_0700
	jr z,@showText

	; If we've encountered maple 5 times or more, show TX_0705
	ld c,<TX_0705
	cp $05
	jr nc,@showText

	; Otherwise, pick a random text index from TX_0701-TX_0704
	call getRandomNumber
	and $03
	ld hl,@normalEncounterText
	rst_addAToHl
	ld c,(hl)
@showText:
	call showText
	xor a
	ld (wDisabledObjects),a
	ld (wMenuDisabled),a
	jp mapleDecideItemToCollectAndUpdateTargetAngle

@exchangeTouchingBook:
	ld a,$0b
	ld l,SpecialObject.state
	ld (hl),a

	ld l,SpecialObject.direction
	ldi (hl),a  ; [direction] = $0b (?)
	ld (hl),$ff ; [angle] = $ff

	ld l,SpecialObject.speed
	ld (hl),SPEED_100

.ifdef ROM_AGES
	ld bc,TX_070d
.else
	ld bc,TX_0709
.endif
	jp showText


; One of these pieces of text is chosen at random when bumping into maple between the 2nd
; and 4th encounters (inclusive).
@normalEncounterText:
	.db <TX_0701, <TX_0702, <TX_0703, <TX_0704


; Values for collisionRadiusY/X for maple's various forms.
@collisionRadii:
	.db $02 $02 ; broom
	.db $02 $02 ; vacuum cleaner
	.db $04 $04 ; ufo


;;
; Updates maple's Z position and speedZ for oscillation (but not if she's in a ufo?)
mapleUpdateOscillation:
	ld h,d
	ld e,SpecialObject.damage
	ld a,(de)
	cp $02
	ret z

	ld c,$00
	call objectUpdateSpeedZ_paramC

	; Wait a certain number of frames before inverting speedZ
	ld l,SpecialObject.var3c
	ld a,(hl)
	dec a
	ld (hl),a
	ret nz

	ld a,$16
	ld (hl),a

	; Invert speedZ
	ld l,SpecialObject.speedZ
	ld a,(hl)
	cpl
	inc a
	ldi (hl),a
	ld a,(hl)
	cpl
	ld (hl),a
	ret

;;
mapleUpdateAngle:
	ld hl,w1Companion.var3b
	dec (hl)
	ret nz

	ld e,SpecialObject.var3a
	ld a,(de)
	ld (hl),a
	ld l,SpecialObject.angle
	ld e,SpecialObject.var3d
	ld l,(hl)
	ldh (<hFF8B),a
	ld a,(de)
	call objectNudgeAngleTowards

;;
; @param[out]	zflag
mapleDecideAnimation:
	ld e,SpecialObject.var3e
	ld a,(de)
	or a
	jr z,@ret

	ld h,d
	ld l,SpecialObject.angle
	ld a,(hl)
	call convertAngleToDirection
	add $04
	ld b,a
	ld e,SpecialObject.damage
	ld a,(de)
	add a
	add a
	add b
	ld l,SpecialObject.animMode
	cp (hl)
	call nz,specialObjectSetAnimation
@ret:
	or d
	ret


;;
; State 6: talking to Link / moving toward an item
mapleState6:
	call mapleUpdateOscillation
	call specialObjectAnimate
	call retIfTextIsActive

	ld a,(wActiveMusic)
	cp MUS_MAPLE_GAME
	jr z,++
	ld a,MUS_MAPLE_GAME
	ld (wActiveMusic),a
	call playSound
++
	; Check whether to update Maple's angle toward an item
	ld l,SpecialObject.var3d
	ld a,(hl)
	ld l,SpecialObject.angle
	cp (hl)
	call nz,mapleUpdateAngle

	call mapleDecideItemToCollectAndUpdateTargetAngle
	call objectApplySpeed

	; Check if Maple's touching the target object
	ld e,SpecialObject.relatedObj2
	ld a,(de)
	ld h,a
	inc e
	ld a,(de)
	ld l,a
	call checkObjectsCollided
	jp nc,mapleKeepInBounds

	; Set the item being collected to state 4
	ld e,SpecialObject.relatedObj2
	ld a,(de)
	ld h,a
	inc e
	ld a,(de)
	or Object.state
	ld l,a
	ld (hl),$04 ; [Part.state] = $04
	inc l
	ld (hl),$00 ; [Part.substate] = $00

	; Read the item's var03 to determine how long it takes to collect.
	ld a,(de)
	or Object.var03
	ld l,a
	ld a,(hl)
	ld e,SpecialObject.stunCounter
	ld (de),a

	; Go to state 7
	ld e,SpecialObject.state
	ld a,$07
	ld (de),a

	; If maple's on her broom, she'll only do her sweeping animation if she's not in
	; a wall - otherwise, she'll just sort of sit there?
	ld e,SpecialObject.damage
	ld a,(de)
	or a
	call z,mapleFunc_6c27
	ret z

	add $16
	jp specialObjectSetAnimation


;;
; State 7: picking up an item
mapleState7:
	call specialObjectAnimate

	ld e,SpecialObject.damage
	ld a,(de)
	cp $01
	jp nz,@anyVehicle

; Maple is on the vacuum.
;
; The next bit of code deals with pulling a bomb object (an actual explosive one) toward
; maple. When it touches her, she will be momentarily stunned.

	; Adjust collisionRadiusY/X for the purpose of checking if a bomb object is close
	; enough to be sucked toward the vacuum.
	ld e,SpecialObject.collisionRadiusY
	ld a,$08
	ld (de),a
	inc e
	ld a,$0a
	ld (de),a

	; Check if there's an actual bomb (one that can explode) on-screen.
	call mapleFindUnexplodedBomb
	jr nz,+
	call checkObjectsCollided
	jr c,@explosiveBombNearMaple
+
	call mapleFindNextUnexplodedBomb
	jr nz,@updateItemBeingCollected
	call checkObjectsCollided
	jr c,@explosiveBombNearMaple

	ld e,SpecialObject.relatedObj1
	xor a
	ld (de),a
	inc e
	ld (de),a
	jr @updateItemBeingCollected

@explosiveBombNearMaple:
	; Constantly signal the bomb to reset its animation so it doesn't explode
	ld l,SpecialObject.var2f
	set 7,(hl)

	; Update the bomb's X and Y positions toward maple, and check if they've reached
	; her.
	ld b,$00
	ld l,Item.yh
	ld e,l
	ld a,(de)
	cp (hl)
	jr z,@updateBombX
	inc b
	jr c,+
	inc (hl)
	jr @updateBombX
+
	dec (hl)

@updateBombX:
	ld l,Item.xh
	ld e,l
	ld a,(de)
	cp (hl)
	jr z,++
	inc b
	jr c,+
	inc (hl)
	jr ++
+
	dec (hl)
++
	ld a,b
	or a
	jr nz,@updateItemBeingCollected

; The bomb has reached maple's Y/X position. Start pulling it up.

	; [Item.z] -= $0040
	ld l,Item.z
	ld a,(hl)
	sub $40
	ldi (hl),a
	ld a,(hl)
	sbc $00
	ld (hl),a

	cp $f8
	jr nz,@updateItemBeingCollected

; The bomb has risen high enough. Maple will now be stunned.

	; Signal the bomb to delete itself
	ld l,SpecialObject.var2f
	set 5,(hl)

	ld a,$1a
	call specialObjectSetAnimation

	; Go to state 8
	ld h,d
	ld l,SpecialObject.state
	ld (hl),$08
	inc l
	ld (hl),$00 ; [substate] = 0

	ld l,SpecialObject.counter2
	ld (hl),$20

	ld e,SpecialObject.relatedObj2
	ld a,(de)
	ld h,a
	inc e
	ld a,(de)
	ld l,a
	ld a,(hl)
	or a
	jr z,@updateItemBeingCollected

	; Release the other item Maple was pulling up
	ld a,(de)
	add Object.state
	ld l,a
	ld (hl),$01

	add Object.angle-Object.state
	ld l,a
	ld (hl),$80

	xor a
	ld e,SpecialObject.relatedObj2
	ld (de),a

; Done with bomb-pulling code. Below is standard vacuum cleaner code.

@updateItemBeingCollected:
	; Fix collision radius after the above code changed it for bomb detection
	ld e,SpecialObject.collisionRadiusY
	ld a,$02
	ld (de),a
	inc e
	ld a,$02
	ld (de),a

; Vacuum-exclusive code is done.

@anyVehicle:
	ld e,SpecialObject.relatedObj2
	ld a,(de)
	or a
	ret z
	ld h,a
	inc e
	ld a,(de)
	ld l,a

	ldi a,(hl)
	or a
	jr z,@itemCollected

	; Check bit 7 of item's subid?
	inc l
	bit 7,(hl)
	jr nz,@itemCollected

	; Check if they've collided (the part object writes to maple's "damageToApply"?)
	ld e,SpecialObject.damageToApply
	ld a,(de)
	or a
	ret z

	ld e,SpecialObject.relatedObj2
	ld a,(de)
	ld h,a
	ld l,Part.var03
	ld a,$80
	ld (hl),a

	xor a
	ld l,Part.invincibilityCounter
	ld (hl),a
	ld l,Part.collisionType
	ld (hl),a

	ld e,SpecialObject.stunCounter
	ld a,(de)
	ld hl,mapleItemValues
	rst_addAToHl
	ld a,$0e
	ld (de),a

	ld e,SpecialObject.health
	ld a,(de)
	ld b,a
	ld a,(hl)
	add b
	ld (de),a

	; If maple's on a broom, go to state $0a (dusting animation); otherwise go back to
	; state $06 (start heading toward the next item)
	ld e,SpecialObject.damage
	ld a,(de)
	or a
	jr nz,@itemCollected

	ld a,$0a
	jr @setState

@itemCollected:
	; Return if Maple's still pulling up a real bomb
	ld h,d
	ld l,SpecialObject.relatedObj1
	ldi a,(hl)
	or (hl)
	ret nz

	ld a,$06
@setState:
	ld e,SpecialObject.state
	ld (de),a

	; Update direction with target direction. (I don't think this has been updated? So
	; she'll still be moving in the direction she was headed to reach this item.)
	ld e,SpecialObject.var3d
	ld a,(de)
	ld e,SpecialObject.angle
	ld (de),a
	ret

;;
; State A: Maple doing her dusting animation after getting an item (broom only)
mapleStateA:
	call specialObjectAnimate
	call itemDecCounter2
	ret nz

	ld l,SpecialObject.state
	ld (hl),$06

	; [zh] = [direction]. ???
	ld l,SpecialObject.direction
	ld a,(hl)
	ld l,SpecialObject.zh
	ld (hl),a

	ld a,$04
	jp specialObjectSetAnimation

;;
; State 8: stunned from a bomb
mapleState8:
	call specialObjectAnimate
	ld e,SpecialObject.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3

@substate0:
	call itemDecCounter2
	ret nz

	ld l,SpecialObject.substate
	ld (hl),$01

	ld l,SpecialObject.speedZ
	xor a
	ldi (hl),a
	ld (hl),a

	ld a,$13
	jp specialObjectSetAnimation

@substate1:
	ld c,$40
	call objectUpdateSpeedZ_paramC
	ret nz

	ld l,SpecialObject.substate
	ld (hl),$02
	ld l,SpecialObject.counter2
	ld (hl),$40
	ret

@substate2:
	call itemDecCounter2
	ret nz

	ld l,SpecialObject.substate
	ld (hl),$03
	ld a,$08
	jp specialObjectSetAnimation

@substate3:
	ld h,d
	ld l,SpecialObject.zh
	dec (hl)
	ld a,(hl)
	cp $e9
	ret nc

	; Go back to state 6 (moving toward next item)
	ld l,SpecialObject.state
	ld (hl),$06

	ld l,SpecialObject.health
	inc (hl)

	ld l,SpecialObject.speedZ
	ld a,$40
	ldi (hl),a
	ld (hl),$00

	jp mapleDecideItemToCollectAndUpdateTargetAngle

;;
; State 9: flying away after item collection is over
mapleState9:
	call specialObjectAnimate
	ld e,SpecialObject.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2

; Substate 0: display text
@substate0:
	call retIfTextIsActive

	ld a,$3c
	ld (wInstrumentsDisabledCounter),a

	ld a,$01
	ld (de),a ; [substate] = $01

	; "health" is maple's obtained value, and "var2a" is Link's obtained value.

	; Check if either of them got anything
	ld h,d
	ld l,SpecialObject.health
	ldi a,(hl)
	ld b,a
	or (hl) ; hl = SpecialObject.var2a
	jr z,@showText

	; Check for draw, or maple got more, or link got more
	ld a,(hl)
	cp b
	ld a,$01
	jr z,@showText
	inc a
	jr c,@showText
	inc a

@showText:
	ld hl,@textIndices
	rst_addDoubleIndex
	ld c,(hl)
	inc hl
	ld b,(hl)
	call showText

	call mapleGetCardinalAngleTowardLink
	call convertAngleToDirection
	add $04
	ld b,a
	ld e,SpecialObject.damage
	ld a,(de)
	add a
	add a
	add b
	jp specialObjectSetAnimation

@textIndices:
	.dw TX_070c ; 0: nothing obtained by maple or link
	.dw TX_0708 ; 1: draw
	.dw TX_0706 ; 2: maple got more
	.dw TX_0707 ; 3: link got more


; Substate 1: wait until textbox is closed
@substate1:
	call mapleUpdateOscillation
	call retIfTextIsActive

	ld a,$80
	ld (wTextIsActive),a
	ld a,$1f
	ld (wDisabledObjects),a

	ld l,SpecialObject.angle
	ld (hl),$18
	ld l,SpecialObject.speed
	ld (hl),SPEED_300

	ld l,SpecialObject.substate
	ld (hl),$02

	ld e,SpecialObject.damage
	ld a,(de)
	add a
	add a
	add $07
	jp specialObjectSetAnimation


; Substate 2: moving until off screen
@substate2:
	call mapleUpdateOscillation
	call objectApplySpeed
	call objectCheckWithinScreenBoundary
	ret c

;;
; Increments meeting counter, deletes maple, etc.
mapleEndEncounter:
	xor a
	ld (wTextIsActive),a
	ld (wDisabledObjects),a
	ld (wMenuDisabled),a
	ld (wDisableScreenTransitions),a
	call mapleIncrementMeetingCounter

	; Fall through

;;
mapleDeleteSelf:
	ld a,(wActiveMusic2)
	ld (wActiveMusic),a
	call playSound
	pop af
	xor a
	ld (wIsMaplePresent),a
	jp itemDelete


;;
; State B: exchanging touching book
mapleStateB:
	inc e
	ld a,(de) ; a = [substate]
	or a
	jr nz,@substate1

@substate0:
	call mapleUpdateOscillation
.ifdef ROM_AGES
	ld e,SpecialObject.direction
	ld a,(de)
	bit 7,a
	jr z,+
	and $03
	jr @determineAnimation
+
.endif

	call objectGetAngleTowardLink
	call convertAngleToDirection
	ld h,d
	ld l,SpecialObject.direction
	cp (hl)
	ld (hl),a
	jr z,@waitForText

@determineAnimation:
	add $04
	ld b,a
	ld e,SpecialObject.damage
	ld a,(de)
	add a
	add a
	add b
	call specialObjectSetAnimation

@waitForText:
	call retIfTextIsActive

	ld hl,wMapleState
	set 5,(hl)
	ld e,SpecialObject.angle
	ld a,(de)
	rlca
	jp nc,objectApplySpeed
	ret

@substate1:
	dec a
	ld (de),a ; [substate] -= 1
	ret nz

.ifdef ROM_AGES
	ld bc,TX_0711
.else
	ld bc,TX_070b
.endif
	call showText
	ld e,SpecialObject.angle
	ld a,$18
	ld (de),a

	; Go to state $0c
	call itemIncState

	ld l,SpecialObject.speed
	ld (hl),SPEED_300

	; Fall through

;;
; State C: leaving after reading touching book
mapleStateC:
	call mapleUpdateOscillation
	call retIfTextIsActive

	call objectApplySpeed

	ld e,SpecialObject.damage
	ld a,(de)
	add a
	add a
	add $07
	ld hl,wMapleState
	bit 4,(hl)
	res 4,(hl)
	call nz,specialObjectSetAnimation

	call objectCheckWithinScreenBoundary
	ret c
	jp mapleEndEncounter


;;
; Adjusts Maple's X and Y position to keep them in-bounds.
mapleKeepInBounds:
	ld e,SpecialObject.yh
	ld a,(de)
	cp $f0
	jr c,+
	xor a
+
	cp $20
	jr nc,++
	ld a,$20
	ld (de),a
	jr @checkX
++
	cp SCREEN_HEIGHT*16 - 8
	jr c,@checkX
	ld a,SCREEN_HEIGHT*16 - 8
	ld (de),a

@checkX:
	ld e,SpecialObject.xh
	ld a,(de)
	cp $f0
	jr c,+
	xor a
+
	cp $08
	jr nc,++
	ld a,$08
	ld (de),a
	jr @ret
++
	cp SCREEN_WIDTH*16 - 8
	jr c,@ret
	ld a,SCREEN_WIDTH*16 - 8
	ld (de),a
@ret:
	ret


;;
mapleSpawnItemDrops:
	; Check if Link has the touching book
	ld a,TREASURE_TRADEITEM
	call checkTreasureObtained
	jr nc,@noTradeItem
.ifdef ROM_AGES
	cp $08
.else
	cp $01
.endif
	jr nz,@noTradeItem

.ifdef ROM_AGES
	ld b,INTERAC_TOUCHING_BOOK
.else
	ld b,INTERAC_LON_LON_EGG
.endif
	call objectCreateInteractionWithSubid00
	ret nz
	ld hl,wMapleState
	set 4,(hl)
	ret

@noTradeItem:
	; Clear health and var2a (the total value of the items Maple and Link have
	; collected, respectively)
	ld e,SpecialObject.var2a
	xor a
	ld (de),a
	ld e,SpecialObject.health
	ld (de),a

; Spawn 5 items from Maple

	ld e,SpecialObject.counter1
	ld a,$05
	ld (de),a

@nextMapleItem:
	ld e,SpecialObject.var03 ; If var03 is 0, rarer items will be dropped
	ld a,(de)
	ld hl,maple_itemDropDistributionTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	call getRandomIndexFromProbabilityDistribution

	ld a,b
	call @checkSpawnItem
	jr c,+
	jr nz,@nextMapleItem
+
	ld e,SpecialObject.counter1
	ld a,(de)
	dec a
	ld (de),a
	jr nz,@nextMapleItem

; Spawn 5 items from Link

	; hFF8C acts as a "drop attempt" counter. It's possible that Link will run out of
	; things to drop, so it'll stop trying eventually.
	ld a,$20
	ldh (<hFF8C),a

	ld e,SpecialObject.counter1
	ld a,$05
	ld (de),a

@nextLinkItem:
	ldh a,(<hFF8C)
	dec a
	ldh (<hFF8C),a
	jr z,@ret

	ld hl,maple_linkItemDropDistribution
	call getRandomIndexFromProbabilityDistribution

	call mapleCheckLinkCanDropItem
	jr z,@nextLinkItem

	ld d,>w1Link
	call mapleSpawnItemDrop

	ld d,>w1Companion
	ld e,SpecialObject.counter1
	ld a,(de)
	dec a
	ld (de),a
	jr nz,@nextLinkItem
@ret:
	ret

;;
; @param	a	Index of item to drop
; @param[out]	cflag	Set if it's ok to drop this item
; @param[out]	zflag
@checkSpawnItem:
	; Check that Link has obtained the item (if applicable)
	push af
	ld hl,mapleItemDropTreasureIndices
	rst_addAToHl
	ld a,(hl)
	call checkTreasureObtained
	pop hl
	jr c,@obtained
	or d
	ret

@obtained:
	ld a,h
	ldh (<hFF8B),a

	; Skip the below conditions for all items of index 5 or above (items that can be
	; dropped multiple times)
	cp $05
	jp nc,mapleSpawnItemDrop

	; If this is the heart piece, only drop it if it hasn't been obtained yet
	or a
	jr nz,@notHeartPiece
	ld a,(wMapleState)
	bit 7,a
	ret nz
	ld e,SpecialObject.invincibilityCounter
	ld a,(de)
	or a
	ret nz

	inc a
	ld (de),a
	jr @spawnItem

@notHeartPiece:
	dec a
	ld hl,@itemBitmasks
	rst_addAToHl
	ld b,(hl)
	ld e,SpecialObject.knockbackAngle
	ld a,(de)
	and b
	ret nz
	ld a,(de)
	or b
	ld (de),a

@spawnItem:
	jr mapleSpawnItemDrop_variant


; Bitmasks for items 1-5 for remembering if one's spawned already
@itemBitmasks:
	.db $04 $02 $02 $01


; The following are probability distributions for maple's dropped items. The sum of the
; numbers in each distribution should be exactly $100. An item with a higher number has
; a higher chance of dropping.

maple_itemDropDistributionTable: ; Probabilities that Maple will drop something
	.dw @rareItems
	.dw @standardItems

@rareItems:
	.db $14 $0e $0e $1e $20 $00 $00 $00
	.db $00 $00 $28 $2e $28 $14

@standardItems:
	.db $00 $02 $04 $08 $0a $00 $00 $00
	.db $00 $00 $32 $34 $3c $46


maple_linkItemDropDistribution: ; Probabilities that Link will drop something
	.db $00 $00 $00 $00 $00 $20 $20 $20
	.db $20 $20 $20 $20 $00 $20


; Each byte is the "value" of an item. The values of the items Link and Maple pick up are
; added up and totalled to see who "won" the encounter.
mapleItemValues:
	.db $3c $0f $0a $08 $06 $05 $05 $05
	.db $05 $05 $04 $03 $02 $01 $00


; Given an index of an item drop, the corresponding value in the table below is a treasure
; to check if Link's obtained in order to allow Maple to drop it. "TREASURE_PUNCH" is
; always considered obtained, so it's used as a value to mean "always drop this".
;
; Item indices:
;  $00: heart piece
;  $01: gasha seed
;  $02: ring
;  $03: ring (different class?)
;  $04: potion
;  $05: ember seeds
;  $06: scent seeds
;  $07: pegasus seeds
;  $08: gale seeds
;  $09: mystery seeds
;  $0a: bombs
;  $0b: heart
;  $0c: 5 rupees
;  $0d: 1 rupee

mapleItemDropTreasureIndices:
	.db TREASURE_PUNCH      TREASURE_PUNCH         TREASURE_PUNCH       TREASURE_PUNCH
	.db TREASURE_PUNCH      TREASURE_EMBER_SEEDS   TREASURE_SCENT_SEEDS TREASURE_PEGASUS_SEEDS
	.db TREASURE_GALE_SEEDS TREASURE_MYSTERY_SEEDS TREASURE_BOMBS       TREASURE_PUNCH
	.db TREASURE_PUNCH      TREASURE_PUNCH

;;
; @param	d	Object it comes from (Link or Maple)
; @param	hFF8B	Value for part's subid and var03 (item type?)
mapleSpawnItemDrop:
	call getFreePartSlot
	scf
	ret nz
	ld (hl),PART_ITEM_FROM_MAPLE
	ld e,SpecialObject.yh
	call objectCopyPosition_rawAddress
	ldh a,(<hFF8B)
	ld l,Part.var03
	ldd (hl),a ; [var03] = [hFF8B]
	ld (hl),a  ; [subid] = [hFF8B]
	xor a
	ret

;;
; @param	d	Object it comes from (Link or Maple)
; @param	hFF8B	Value for part's subid and var03 (item type?)
mapleSpawnItemDrop_variant:
	call getFreePartSlot
	scf
	ret nz
	ld (hl),PART_ITEM_FROM_MAPLE_2
	ld l,Part.subid
	ldh a,(<hFF8B)
	ldi (hl),a
	ld (hl),a
	call objectCopyPosition
	or a
	ret

;;
; Decides what Maple's next item target should be.
;
; @param[out]	hl	The part object to go for
; @param[out]	zflag	nz if there are no items left
mapleDecideItemToCollect:

; Search for item IDs 0-4 first

	ld b,$00

@idLoop1
	ldhl FIRST_PART_INDEX, Part.enabled

@partLoop1:
	ld l,Part.enabled
	ldi a,(hl)
	or a
	jr z,@nextPart1

	ldi a,(hl)
	cp PART_ITEM_FROM_MAPLE_2
	jr nz,@nextPart1

	ldd a,(hl)
	cp b
	jr nz,@nextPart1

	; Found an item to go for
	dec l
	xor a
	ret

@nextPart1:
	inc h
	ld a,h
	cp LAST_PART_INDEX+1
	jr c,@partLoop1

	inc b
	ld a,b
	cp $05
	jr c,@idLoop1

; Now search for item IDs $05-$0d

	xor a
	ld c,$00
	ld hl,@itemIDs
	rst_addAToHl
	ld a,(hl)
	ld b,a
	xor a
	ldh (<hFF91),a

@idLoop2:
	ldhl FIRST_PART_INDEX, Part.enabled

@partLoop2:
	ld l,Part.enabled
	ldi a,(hl)
	or a
	jr z,@nextPart2

	ldi a,(hl)
	cp PART_ITEM_FROM_MAPLE
	jr nz,@nextPart2

	ldd a,(hl)
	cp b
	jr nz,@nextPart2

; We've found an item to go for. However, we'll only pick this one if it's closest of its
; type. Start by calculating maple's distance from it.

	ld l,Part.yh
	ld l,(hl)
	ld e,SpecialObject.yh
	ld a,(de)
	sub l
	jr nc,+
	cpl
	inc a
+
	ldh (<hFF8C),a
	ld l,Part.xh
	ld l,(hl)
	ld e,SpecialObject.xh
	ld a,(de)
	sub l
	jr nc,+
	cpl
	inc a
+
	ld l,a
	ldh a,(<hFF8C)
	add l
	ld l,a

; l now contains the distance to the item. Check if it's less than the closest item's
; distance (stored in hFF8D), or if this is the first such item (index stored in hFF91).

	ldh a,(<hFF91)
	or a
	jr z,++
	ldh a,(<hFF8D)
	cp l
	jr c,@nextPart2
++
	ld a,l
	ldh (<hFF8D),a
	ld a,h
	ldh (<hFF91),a

@nextPart2:
	inc h
	ld a,h
	cp $e0
	jr c,@partLoop2

	; If we found an item of this type, return.
	ldh a,(<hFF91)
	or a
	jr nz,@foundItem

	; Otherwise, try the next item type.
	inc c
	ld a,c
	cp $09
	jr nc,@noItemsLeft

	ld hl,@itemIDs
	rst_addAToHl
	ld a,(hl)
	ld b,a
	jr @idLoop2

@noItemsLeft:
	; This will unset the zflag, since a=$09 and d=$d1... but they probably meant to
	; write "or d" to produce that effect. (That's what they normally do.)
	and d
	ret

@foundItem:
	ld h,a
	ld l,Part.enabled
	xor a
	ret

@itemIDs:
	.db $05 $06 $07 $08 $09 $0a $0b $0c
	.db $0d


;;
; Searches for a bomb item (an actual bomb that will explode). If one exists, and isn't
; currently exploding, it gets set as Maple's relatedObj1.
;
; @param[out]	zflag	z if the first bomb object found was suitable
mapleFindUnexplodedBomb:
	ld e,SpecialObject.relatedObj1
	xor a
	ld (de),a
	inc e
	ld (de),a
	ld c,ITEM_BOMB
	call findItemWithID
	ret nz
	jr ++

;;
; This is similar to above, except it's a "continuation" in case the first bomb that was
; found was unsuitable (in the process of exploding).
;
mapleFindNextUnexplodedBomb:
	ld c,ITEM_BOMB
	call findItemWithID_startingAfterH
	ret nz
++
	ld l,Item.var2f
	ld a,(hl)
	bit 7,a
	jr nz,++
	and $60
	ret nz
	ld l,Item.zh
	bit 7,(hl)
	ret nz
++
	ld e,SpecialObject.relatedObj1
	ld a,h
	ld (de),a
	inc e
	xor a
	ld (de),a
	ret

;;
mapleInitZPositionAndSpeed:
	ld h,d
	ld l,SpecialObject.zh
	ld a,$f8
	ldi (hl),a

	ld l,SpecialObject.speedZ
	ld (hl),$40
	inc l
	ld (hl),$00

	ld l,SpecialObject.var3c
	ld a,$16
	ldi (hl),a
	ret

;;
; @param[out]	a	Angle toward link (rounded to cardinal direction)
mapleGetCardinalAngleTowardLink:
	call objectGetAngleTowardLink
	and $18
	ret

;;
; Decides what item Maple should go for, and updates var3d appropriately (the angle she's
; turning toward).
;
; If there are no more items, this sets Maple's state to $09.
;
mapleDecideItemToCollectAndUpdateTargetAngle:
	call mapleDecideItemToCollect
	jr nz,@noMoreItems

	ld e,SpecialObject.relatedObj2
	ld a,h
	ld (de),a
	inc e
	ld a,l
	ld (de),a
	ld e,SpecialObject.damageToApply
	xor a
	ld (de),a
	jr mapleSetTargetDirectionToRelatedObj2

@noMoreItems:
	ld e,SpecialObject.state
	ld a,$09
	ld (de),a
	inc e
	xor a
	ld (de),a ; [substate] = 0
	ret

;;
mapleSetTargetDirectionToRelatedObj2:
	ld e,SpecialObject.relatedObj2
	ld a,(de)
	ld h,a
	inc e
	ld a,(de)
	or Object.yh
	ld l,a

	ldi a,(hl)
	ld b,a
	inc l
	ld a,(hl)
	ld c,a
	call objectGetRelativeAngle
	ld e,SpecialObject.var3d
	ld (de),a
	ret

;;
; Checks if Link can drop an item in Maple's minigame, and removes the item amount from
; his inventory if he can.
;
; This function is bugged. The programmers mixed up the "treasure indices" with maple's
; item indices. As a result, the incorrect treasures are checked to be obtained; for
; example, pegasus seeds check that Link has obtained the rod of seasons. This means
; pegasus seeds will never drop in Ages. Similarly, gale seeds check the magnet gloves.
;
; @param	b	The item to drop
; @param[out]	hFF8B	The "maple item index" of the item to be dropped
; @param[out]	zflag	nz if Link can drop it
mapleCheckLinkCanDropItem:
	ld a,b
	sub $05
	ld b,a
	rst_jumpTable
	.dw @seed
	.dw @seed
	.dw @seed
	.dw @seed
	.dw @seed
	.dw @bombs
	.dw @heart
	.dw @heart ; This should be 5 rupees, but Link never drops that.
	.dw @oneRupee

@oneRupee:
	ld hl,wNumRupees
	ldi a,(hl)
	or (hl)
	ret z
	ld a,$01
	call removeRupeeValue
	ld a,$0c
	jr @setMapleItemIndex

@bombs:
	; $0a corresponds to bombs in maple's treasure indices, but for the purpose of the
	; "checkTreasureObtained" call, it actually corresponds to "TREASURE_SWITCH_HOOK"!
	ld a,$0a
	ldh (<hFF8B),a
	call checkTreasureObtained
	jr nc,@cannotDrop

	ld hl,wNumBombs
	ld a,(hl)
	sub $04
	jr c,@cannotDrop
	daa
	ld (hl),a
	call setStatusBarNeedsRefreshBit1
	or d
	ret

@seed:
	; BUG: For the purpose of "checkTreasureObtained", the treasure index will be very
	; wrong.
	;   Ember seed:   TREASURE_SWORD
	;   Scent seed:   TREASURE_BOOMERANG
	;   Pegasus seed: TREASURE_ROD_OF_SEASONS
	;   Gale seed:    TREASURE_MAGNET_GLOVES
	;   Mystery seed: TREASURE_SWITCH_HOOK_HELPER
	ld a,b
	add $05
	ldh (<hFF8B),a
	call checkTreasureObtained
	jr nc,@cannotDrop

	; See if we can remove 5 of the seed type from the inventory
	ld a,b
	ld hl,wNumEmberSeeds
	rst_addAToHl
	ld a,(hl)
	sub $05
	jr c,@cannotDrop
	daa
	ld (hl),a

	call setStatusBarNeedsRefreshBit1
	or d
	ret

@cannotDrop:
	xor a
	ret

@heart:
	ld hl,wLinkHealth
	ld a,(hl)
	cp 12 ; Check for at least 3 hearts
	jr nc,+
	xor a
	ret
+
	sub $04
	ld (hl),a

	ld hl,wStatusBarNeedsRefresh
	set 2,(hl)

	ld a,$0b

@setMapleItemIndex:
	ldh (<hFF8B),a
	or d
	ret

;;
; @param[out]	a	Maple.damage variable (actually vehicle type)
; @param[out]	zflag	z if Maple's in a wall? (she won't do her sweeping animation)
mapleFunc_6c27:
	ld e,SpecialObject.counter2
	ld a,$30
	ld (de),a

	; [direction] = [zh]. ???
	ld e,SpecialObject.zh
	ld a,(de)
	ld e,SpecialObject.direction
	ld (de),a

	call objectGetTileCollisions
	jr nz,@collision
	ld e,SpecialObject.zh
	xor a
	ld (de),a
	or d
	ld e,SpecialObject.damage
	ld a,(de)
	ret
@collision:
	xor a
	ret

;;
; Increments lower 4 bits of wMapleState (the number of times Maple has been met)
mapleIncrementMeetingCounter:
	ld hl,wMapleState
	ld a,(hl)
	and $0f
	ld b,a
	cp $0f
	jr nc,+
	inc b
+
	xor (hl)
	or b
	ld (hl),a
	ret


; These are the possible paths Maple can take when you just see her shadow.
mapleShadowPathsTable:
	.dw @rareItemDrops
	.dw @standardItemDrops

; Data format:
;   First byte is the delay it takes to change angles. (Higher values make larger arcs.)
;   Each subsequent row is:
;     b0: target angle
;     b1: number of frames to move in that direction (not counting time it takes to turn)
@rareItemDrops:
	.db $02
	.db $18 $64
	.db $10 $02
	.db $08 $1e
	.db $10 $02
	.db $18 $7a
	.db $ff $ff

@standardItemDrops:
	.db $04
	.db $18 $64
	.db $10 $04
	.db $08 $64
	.db $ff $ff


; Maps a number to an index for the table below. At first, only the first 4 bytes are read
; at random from this table, but as maple is encountered more, the subsequent bytes are
; read, giving maple more variety in the way she moves.
mapleMovementPatternIndices:
	.db $00 $01 $02 $00 $03 $04 $05 $03
	.db $06 $07 $01 $02 $04 $05 $06 $07

mapleMovementPatternTable:
	.dw @pattern0
	.dw @pattern1
	.dw @pattern2
	.dw @pattern3
	.dw @pattern4
	.dw @pattern5
	.dw @pattern6
	.dw @pattern7

; Data format:
;   First row is the Y/X position for Maple to start at.
;   Second row is one byte for the delay it takes to change angles.
;   Each subsequent row is:
;     b0: target angle
;     b1: number of frames to move in that direction (not counting time it takes to turn)
@pattern0:
	.db $18 $b8
	.db $02
	.db $18 $4b
	.db $10 $01
	.db $08 $32
	.db $10 $01
	.db $18 $46
	.db $ff $ff

@pattern1:
	.db $70 $b8
	.db $02
	.db $18 $4b
	.db $00 $01
	.db $08 $32
	.db $00 $01
	.db $18 $46
	.db $ff $ff

@pattern2:
	.db $18 $f0
	.db $02
	.db $08 $46
	.db $10 $19
	.db $18 $28
	.db $00 $14
	.db $08 $19
	.db $10 $0f
	.db $18 $14
	.db $00 $0a
	.db $08 $0f
	.db $10 $32
	.db $ff $ff

@pattern3:
	.db $a0 $90
	.db $02
	.db $00 $37
	.db $18 $01
	.db $10 $19
	.db $18 $01
	.db $00 $19
	.db $18 $01
	.db $10 $3c
	.db $ff $ff

@pattern4:
	.db $a0 $10
	.db $02
	.db $00 $37
	.db $08 $01
	.db $10 $19
	.db $08 $01
	.db $00 $19
	.db $08 $01
	.db $10 $3c
	.db $ff $ff

@pattern5:
	.db $18 $f0
	.db $01
	.db $08 $28
	.db $16 $0f
	.db $08 $2d
	.db $16 $0a
	.db $08 $37
	.db $ff $ff

@pattern6:
	.db $f0 $30
	.db $02
	.db $14 $19
	.db $05 $11
	.db $14 $0a
	.db $17 $05
	.db $10 $01
	.db $05 $1e
	.db $14 $1e
	.db $ff $ff

@pattern7:
	.db $f0 $70
	.db $02
	.db $0c $19
	.db $1b $11
	.db $0c $08
	.db $0a $02
	.db $10 $01
	.db $1b $0f
	.db $0c $1e
	.db $ff $ff
