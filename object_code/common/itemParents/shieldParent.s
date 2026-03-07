;;
; ITEM_SHIELD ($01)
parentItemCode_shield:
	; Verify that the shield can be used
	call @checkShieldIsUsable
	jr nc,@deleteSelf

	; Return if any other item is in use
	call checkNoOtherParentItemsInUse
	ret nz

	ld e,Item.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1

@state0:
	; Go to state 1
	ld a,$01
	ld (de),a

	ld a,SND_SHIELD
	call playSound

@state1:
	; It seems that wUsingShield will get unset from elsewhere each frame, so not
	; running this code would suffice to stop using the shield
	ld a,(wShieldLevel)
	add $00
	ld (wUsingShield),a
	ret

@deleteSelf:
	xor a
	ld (wUsingShield),a
	jp clearParentItem

;;
; @param[out]	cflag	Set if the shield is ok to use (and the button is held)
@checkShieldIsUsable:
	; Can't use while swimming
	ld a,(wLinkSwimmingState)
	or a
	jr nz,@@disallowShield

	; Check if in a spinner
	ld a,(wcc95)
	rlca
	jr c,@@disallowShield

.ifdef ROM_AGES
	; Can't use underwater
	call isLinkUnderwater
	jr nz,@@disallowShield

	; Can use on the raft, but not on any other rides
	ld a,(w1Companion.id)
	cp SPECIALOBJECT_RAFT
	jr z,+
.endif

	ld a,(wLinkObjectIndex)
	rrca
	jr c,@@disallowShield
+
	; Shield is allowed; now check that the button is still held
	call parentItemCheckButtonPressed
	jr z,@@disallowShield
	scf
	ret

@@disallowShield:
	xor a
	ret

