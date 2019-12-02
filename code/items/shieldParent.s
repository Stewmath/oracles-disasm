;;
; ITEMID_SHIELD ($01)
; @addr{4a57}
_parentItemCode_shield:
	; Verify that the shield can be used
	call @checkShieldIsUsable		; $4a57
	jr nc,@deleteSelf	; $4a5a

	; Return if any other item is in use
	call _checkNoOtherParentItemsInUse		; $4a5c
	ret nz			; $4a5f

	ld e,Item.state		; $4a60
	ld a,(de)		; $4a62
	rst_jumpTable			; $4a63
	.dw @state0
	.dw @state1

@state0:
	; Go to state 1
	ld a,$01		; $4a68
	ld (de),a		; $4a6a

	ld a,SND_SWITCHHOOK		; $4a6b
	call playSound		; $4a6d

@state1:
	; It seems that wUsingShield will get unset from elsewhere each frame, so not
	; running this code would suffice to stop using the shield
	ld a,(wShieldLevel)		; $4a70
	add $00			; $4a73
	ld (wUsingShield),a		; $4a75
	ret			; $4a78

@deleteSelf:
	xor a			; $4a79
	ld (wUsingShield),a		; $4a7a
	jp _clearParentItem		; $4a7d

;;
; @param[out]	cflag	Set if the shield is ok to use (and the button is held)
; @addr{4a80}
@checkShieldIsUsable:
	; Can't use while swimming
	ld a,(wLinkSwimmingState)		; $4a80
	or a			; $4a83
	jr nz,@@disallowShield	; $4a84

	; Check if in a spinner
	ld a,(wcc95)		; $4a86
	rlca			; $4a89
	jr c,@@disallowShield	; $4a8a

.ifdef ROM_AGES
	; Can't use underwater
	call _isLinkUnderwater		; $4a8c
	jr nz,@@disallowShield	; $4a8f

	; Can use on the raft, but not on any other rides
	ld a,(w1Companion.id)		; $4a91
	cp SPECIALOBJECTID_RAFT			; $4a94
	jr z,+			; $4a96
.endif

	ld a,(wLinkObjectIndex)		; $4a98
	rrca			; $4a9b
	jr c,@@disallowShield	; $4a9c
+
	; Shield is allowed; now check that the button is still held
	call _parentItemCheckButtonPressed		; $4a9e
	jr z,@@disallowShield	; $4aa1
	scf			; $4aa3
	ret			; $4aa4

@@disallowShield:
	xor a			; $4aa5
	ret			; $4aa6

