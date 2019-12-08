;;
; ITEMID_SLINGSHOT ($13)
; @snaddr{4d25}
_parentItemCode_slingshot:
.ifdef ROM_SEASONS
	ld e,Item.state		; $4d25
	ld a,(de)		; $4d27
	rst_jumpTable			; $4d28
	.dw @state0
	.dw _parentItemGenericState1

@state0:
	ld a,(wLinkSwimmingState)		; $4d2d
	ld b,a			; $4d30
	ld a,(wIsSeedShooterInUse)		; $4d31
	or b			; $4d34
	jp nz,_clearParentItem		; $4d35

	call updateLinkDirectionFromAngle		; $4d38
	ld c,$01		; $4d3b
	ld a,(wSlingshotLevel)		; $4d3d
	cp $02			; $4d40
	jr nz,+			; $4d42
	ld c,$03		; $4d44
+
	call _getNumFreeItemSlots		; $4d46
	cp c			; $4d49
	jp c,_clearParentItem		; $4d4a

	ld a,$01		; $4d4d
	call _clearSelfIfNoSeeds		; $4d4f
	; b = seed ID after above call
	push bc			; $4d52
	call _parentItemLoadAnimationAndIncState		; $4d53

	; Create the slingshot
	call itemCreateChild		; $4d56
	pop bc			; $4d59

	; Create the seeds
@spawnSeed:
	; This must be reset after calling "itemCreateChild" to prevent the call from overwriting
	; the last item it created
	ld e,Item.relatedObj2+1		; $4d5a
	ld a,>w1Link		; $4d5c
	ld (de),a		; $4d5e

	push bc			; $4d5f
	ld e,$01		; $4d60
	call itemCreateChildWithID		; $4d62
	pop bc			; $4d65
	dec c			; $4d66
	jr nz,@spawnSeed	; $4d67
	ld a,b			; $4d69
	jp decNumActiveSeeds		; $4d6a

.endif ; ROM_SEASONS


;;
; ITEMID_SHOOTER ($0f)
; @addr{4e66}
_parentItemCode_shooter:
.ifdef ROM_AGES
	ld e,Item.state		; $4e66
	ld a,(de)		; $4e68
	rst_jumpTable			; $4e69
	.dw @state0
	.dw @state1
	.dw @state2

; Initialization
@state0:
	ld a,$01		; $4e70
	call _clearSelfIfNoSeeds		; $4e72

	call updateLinkDirectionFromAngle		; $4e75
	call _parentItemLoadAnimationAndIncState		; $4e78
	call itemCreateChild		; $4e7b
	ld a,(wLinkAngle)		; $4e7e
	bit 7,a			; $4e81
	jr z,@updateAngleFrom5Bit	; $4e83
	ld a,(w1Link.direction)		; $4e85
	add a			; $4e88
	jr @updateAngle		; $4e89


; Waiting for button to be released
@state1:
	ld a,$01		; $4e8b
	call _clearSelfIfNoSeeds		; $4e8d
	call _parentItemCheckButtonPressed		; $4e90
	jr nz,@checkUpdateAngle	; $4e93

; Button released

	ld a,(wIsSeedShooterInUse)		; $4e95
	or a			; $4e98
	jp nz,_clearParentItem		; $4e99

	ld e,Item.relatedObj2+1		; $4e9c
	ld a,>w1Link		; $4e9e
	ld (de),a		; $4ea0

	ld a,$01		; $4ea1
	call _clearSelfIfNoSeeds		; $4ea3

	; Note: here, 'c' = the "behaviour" value from the "_itemUsageParameterTable" for
	; button B, and this will become the subid for the new item? (The only important
	; thing is that it's nonzero, to indicate the seed came from the shooter.)
	push bc			; $4ea6
	ld e,$01		; $4ea7
	call itemCreateChildWithID		; $4ea9

	; Calculate child item's angle?
	ld e,Item.angle		; $4eac
	ld a,(de)		; $4eae
	add a			; $4eaf
	add a			; $4eb0
	ld l,Item.angle		; $4eb1
	ld (hl),a		; $4eb3

	pop bc			; $4eb4
	ld a,b			; $4eb5
	call decNumActiveSeeds		; $4eb6

	call itemIncState		; $4eb9
	ld l,Item.counter2		; $4ebc
	ld (hl),$0c		; $4ebe

	ld a,SND_SEEDSHOOTER		; $4ec0
	jp playSound		; $4ec2


; Waiting for counter to reach 0 before putting away the seed shooter
@state2:
	call itemDecCounter2		; $4ec5
	ret nz			; $4ec8
	ld a,(wLinkAngle)		; $4ec9
	push af			; $4ecc
	ld l,Item.angle		; $4ecd
	ld a,(hl)		; $4ecf
	add a			; $4ed0
	add a			; $4ed1
	ld (wLinkAngle),a		; $4ed2
	call updateLinkDirectionFromAngle		; $4ed5
	pop af			; $4ed8
	ld (wLinkAngle),a		; $4ed9
	jp _clearParentItem		; $4edc


; Note: seed shooter's angle is a value from 0-7, instead of $00-$1f like usual

@updateAngleFrom5Bit:
	rrca			; $4edf
	rrca			; $4ee0
	jr @updateAngle		; $4ee1

@checkUpdateAngle:
	ld a,(wGameKeysJustPressed)		; $4ee3
	and (BTN_RIGHT|BTN_LEFT|BTN_UP|BTN_DOWN)			; $4ee6
	jr nz,+			; $4ee8
	call itemDecCounter2		; $4eea
	jr nz,@determineBaseAnimation	; $4eed
+
	ld a,(wLinkAngle)		; $4eef
	rrca			; $4ef2
	rrca			; $4ef3
	jr c,@determineBaseAnimation	; $4ef4
	ld h,d			; $4ef6
	ld l,Item.angle		; $4ef7
	sub (hl)		; $4ef9
	jr z,@determineBaseAnimation	; $4efa

	bit 2,a			; $4efc
	ld a,$ff		; $4efe
	jr nz,+			; $4f00
	ld a,$01		; $4f02
+
	add (hl)		; $4f04

@updateAngle:
	ld h,d			; $4f05
	ld l,Item.angle		; $4f06
	and $07			; $4f08
	ld (hl),a		; $4f0a
	ld l,Item.counter2		; $4f0b
	ld (hl),$10		; $4f0d

@determineBaseAnimation:
	call _isLinkUnderwater		; $4f0f
	ld a,$48		; $4f12
	jr nz,++		; $4f14
	ld a,(w1Companion.id)		; $4f16
	cp SPECIALOBJECTID_MINECART			; $4f19
	ld a,$40		; $4f1b
	jr z,++			; $4f1d
	ld a,$38		; $4f1f
++
	ld h,d			; $4f21
	ld l,Item.angle		; $4f22
	add (hl)		; $4f24
	ld l,Item.var31		; $4f25
	ld (hl),a		; $4f27
	ld l,Item.var3f		; $4f28
	ld (hl),$04		; $4f2a
	ret			; $4f2c

.endif ; ROM_AGES


;;
; ITEMID_SEED_SATCHEL ($19)
; @addr{4f2d}
_parentItemCode_satchel:
	ld e,Item.state		; $4f2d
	ld a,(de)		; $4f2f
	rst_jumpTable			; $4f30
	.dw @state0
	.dw _parentItemGenericState1

@state0:
.ifdef ROM_AGES
	ld a,(w1Companion.id)		; $4f35
	cp SPECIALOBJECTID_RAFT			; $4f38
	jp z,_clearParentItem		; $4f3a
	call _isLinkUnderwater		; $4f3d
	jp nz,_clearParentItem		; $4f40
.endif
	ld a,(wLinkSwimmingState)		; $4f43
	or a			; $4f46
	jp nz,_clearParentItem		; $4f47

	call _clearSelfIfNoSeeds		; $4f4a

	ld a,b			; $4f4d
	cp ITEMID_PEGASUS_SEED			; $4f4e
	jr z,@pegasusSeeds	; $4f50

	push bc			; $4f52
	call _parentItemLoadAnimationAndIncState		; $4f53
	pop bc			; $4f56
	push bc			; $4f57
	ld c,$00		; $4f58
	ld e,$01		; $4f5a
	call itemCreateChildWithID		; $4f5c
	pop bc			; $4f5f
	jp c,_clearParentItem		; $4f60

	ld a,b			; $4f63
	jp decNumActiveSeeds		; $4f64

@pegasusSeeds:
	ld hl,wPegasusSeedCounter		; $4f67
	ldi a,(hl)		; $4f6a
	or (hl)			; $4f6b
	jr nz,@clear		; $4f6c

	ld a,$03		; $4f6e
	ldd (hl),a		; $4f70
	ld (hl),$c0		; $4f71

	ld a,b			; $4f73
	call decNumActiveSeeds		; $4f74

	; Create pegasus seed "puffs"?
	ld hl,w1ReservedItemF		; $4f77
	ld a,$03		; $4f7a
	ldi (hl),a		; $4f7c
	ld (hl),ITEMID_DUST		; $4f7d
@clear:
	jp _clearParentItem		; $4f7f

;;
; Gets the number of seeds available, or returns from caller if none are available.
;
; @param	a	0 for satchel, 1 for shooter/slingshot
; @param[out]	a	# of seeds of that type
; @param[out]	b	Item ID for seed type (value between $20-$24)
; @param[out]	hl	Address of "wNum*Seeds" variable
; @addr{4f82}
_clearSelfIfNoSeeds:
	ld hl,wSatchelSelectedSeeds		; $4f82
	rst_addAToHl			; $4f85
	ld a,(hl)		; $4f86
	ld b,a			; $4f87
	set 5,b			; $4f88
	ld hl,wNumEmberSeeds		; $4f8a

	rst_addAToHl			; $4f8d
	ld a,(hl)		; $4f8e
	or a			; $4f8f
	ret nz			; $4f90
	pop hl			; $4f91
	jp _clearParentItem		; $4f92

;;
; This is "state 1" for the satchel, bombchu, and bomb "parent items". It simply updates
; Link's animation, then deletes the parent.
; @addr{4f95}
_parentItemGenericState1:
	ld e,Item.animParameter		; $4f95
	ld a,(de)		; $4f97
	rlca			; $4f98
	jp nc,_specialObjectAnimate		; $4f99
	jp _clearParentItem		; $4f9c
