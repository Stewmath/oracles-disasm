; ==================================================================================================
; INTERAC_GOLDEN_BEAST_OLD_MAN
; ==================================================================================================
interactionCodedd:
	ld e,$44
	ld a,(de)
	or a
	jr z,+
	call interactionRunScript
	jp c,interactionDelete
	jp npcFaceLinkAndAnimate
+
	call getThisRoomFlags
	and $40
	jp nz,interactionDelete
	call interactionIncState
	call interactionInitGraphics
	call objectSetVisible82
	ld a,>TX_1f00
	call interactionSetHighTextIndex
	ld hl,mainScripts.goldenBeastOldManScript
	jp interactionSetScript

checkGoldenBeastsKilled:
	xor a
	ld hl,wTextNumberSubstitution
	ldi (hl),a
	ldd (hl),a
	ld a,(wKilledGoldenEnemies)
	and $0f
	call getNumSetBits
	ld (hl),a
	cp $04
	ld a,$01
	jr z,+
	dec a
+
	ld ($cfc1),a
	ret

giveRedRing:
	ldbc RED_RING $00
	jp giveRingToLink
