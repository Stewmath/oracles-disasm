;;
; ITEM_SLINGSHOT ($13)
; @snaddr{4d25}
parentItemCode_slingshot:
.ifdef ROM_SEASONS
	ld e,Item.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw parentItemGenericState1

@state0:
	ld a,(wLinkSwimmingState)
	ld b,a
	ld a,(wIsSeedShooterInUse)
	or b
	jp nz,clearParentItem

	call updateLinkDirectionFromAngle
	ld c,$01
	ld a,(wSlingshotLevel)
	cp $02
	jr nz,+
	ld c,$03
+
	call getNumFreeItemSlots
	cp c
	jp c,clearParentItem

	ld a,$01
	call clearSelfIfNoSeeds
	; b = seed ID after above call
	push bc
	call parentItemLoadAnimationAndIncState

	; Create the slingshot
	call itemCreateChild
	pop bc

	; Create the seeds
@spawnSeed:
	; This must be reset after calling "itemCreateChild" to prevent the call from overwriting
	; the last item it created
	ld e,Item.relatedObj2+1
	ld a,>w1Link
	ld (de),a

	push bc
	ld e,$01
	call itemCreateChildWithID
	pop bc
	dec c
	jr nz,@spawnSeed
	ld a,b
	jp decNumActiveSeeds

.endif ; ROM_SEASONS


;;
; ITEM_SHOOTER ($0f)
parentItemCode_shooter:
.ifdef ROM_AGES
	ld e,Item.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2

; Initialization
@state0:
	ld a,$01
	call clearSelfIfNoSeeds

	call updateLinkDirectionFromAngle
	call parentItemLoadAnimationAndIncState
	call itemCreateChild
	ld a,(wLinkAngle)
	bit 7,a
	jr z,@updateAngleFrom5Bit
	ld a,(w1Link.direction)
	add a
	jr @updateAngle


; Waiting for button to be released
@state1:
	ld a,$01
	call clearSelfIfNoSeeds
	call parentItemCheckButtonPressed
	jr nz,@checkUpdateAngle

; Button released

	ld a,(wIsSeedShooterInUse)
	or a
	jp nz,clearParentItem

	ld e,Item.relatedObj2+1
	ld a,>w1Link
	ld (de),a

	ld a,$01
	call clearSelfIfNoSeeds

	; Note: here, 'c' = the "behaviour" value from the "itemUsageParameterTable" for
	; button B, and this will become the subid for the new item? (The only important
	; thing is that it's nonzero, to indicate the seed came from the shooter.)
	push bc
	ld e,$01
	call itemCreateChildWithID

	; Calculate child item's angle?
	ld e,Item.angle
	ld a,(de)
	add a
	add a
	ld l,Item.angle
	ld (hl),a

	pop bc
	ld a,b
	call decNumActiveSeeds

	call itemIncState
	ld l,Item.counter2
	ld (hl),$0c

	ld a,SND_SEEDSHOOTER
	jp playSound


; Waiting for counter to reach 0 before putting away the seed shooter
@state2:
	call itemDecCounter2
	ret nz
	ld a,(wLinkAngle)
	push af
	ld l,Item.angle
	ld a,(hl)
	add a
	add a
	ld (wLinkAngle),a
	call updateLinkDirectionFromAngle
	pop af
	ld (wLinkAngle),a
	jp clearParentItem


; Note: seed shooter's angle is a value from 0-7, instead of $00-$1f like usual

@updateAngleFrom5Bit:
	rrca
	rrca
	jr @updateAngle

@checkUpdateAngle:
	ld a,(wGameKeysJustPressed)
	and (BTN_RIGHT|BTN_LEFT|BTN_UP|BTN_DOWN)
	jr nz,+
	call itemDecCounter2
	jr nz,@determineBaseAnimation
+
	ld a,(wLinkAngle)
	rrca
	rrca
	jr c,@determineBaseAnimation
	ld h,d
	ld l,Item.angle
	sub (hl)
	jr z,@determineBaseAnimation

	bit 2,a
	ld a,$ff
	jr nz,+
	ld a,$01
+
	add (hl)

@updateAngle:
	ld h,d
	ld l,Item.angle
	and $07
	ld (hl),a
	ld l,Item.counter2
	ld (hl),$10

@determineBaseAnimation:
	call isLinkUnderwater
	ld a,$48
	jr nz,++
	ld a,(w1Companion.id)
	cp SPECIALOBJECT_MINECART
	ld a,$40
	jr z,++
	ld a,$38
++
	ld h,d
	ld l,Item.angle
	add (hl)
	ld l,Item.var31
	ld (hl),a
	ld l,Item.var3f
	ld (hl),$04
	ret

.endif ; ROM_AGES


;;
; ITEM_SEED_SATCHEL ($19)
parentItemCode_satchel:
	ld e,Item.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw parentItemGenericState1

@state0:
.ifdef ROM_AGES
	ld a,(w1Companion.id)
	cp SPECIALOBJECT_RAFT
	jp z,clearParentItem
	call isLinkUnderwater
	jp nz,clearParentItem
.endif
	ld a,(wLinkSwimmingState)
	or a
	jp nz,clearParentItem

	call clearSelfIfNoSeeds

	ld a,b
	cp ITEM_PEGASUS_SEED
	jr z,@pegasusSeeds

	push bc
	call parentItemLoadAnimationAndIncState
	pop bc
	push bc
	ld c,$00
	ld e,$01
	call itemCreateChildWithID
	pop bc
	jp c,clearParentItem

	ld a,b
	jp decNumActiveSeeds

@pegasusSeeds:
	ld hl,wPegasusSeedCounter
	ldi a,(hl)
	or (hl)
	jr nz,@clear

	ld a,$03
	ldd (hl),a
	ld (hl),$c0

	ld a,b
	call decNumActiveSeeds

	; Create pegasus seed "puffs"?
	ld hl,w1ReservedItemF
	ld a,$03
	ldi (hl),a
	ld (hl),ITEM_DUST
@clear:
	jp clearParentItem

;;
; Gets the number of seeds available, or returns from caller if none are available.
;
; @param	a	0 for satchel, 1 for shooter/slingshot
; @param[out]	a	# of seeds of that type
; @param[out]	b	Item ID for seed type (value between $20-$24)
; @param[out]	hl	Address of "wNum*Seeds" variable
clearSelfIfNoSeeds:
	ld hl,wSatchelSelectedSeeds
	rst_addAToHl
	ld a,(hl)
	ld b,a
	set 5,b
	ld hl,wNumEmberSeeds

	rst_addAToHl
	ld a,(hl)
	or a
	ret nz
	pop hl
	jp clearParentItem

;;
; This is "state 1" for the satchel, bombchu, and bomb "parent items". It simply updates
; Link's animation, then deletes the parent.
parentItemGenericState1:
	ld e,Item.animParameter
	ld a,(de)
	rlca
	jp nc,specialObjectAnimate_optimized
	jp clearParentItem
