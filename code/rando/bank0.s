; This is a replacement for giveTreasure that accounts for item progression. Call through
; giveTreasureCustom or giveTreasureCustomSilent, since this function doesn't xor the a that it
; returns. Importantly, this replacement treats c as a subID, not a param, so this should *not* be
; called by non-randomized whatevers.
giveTreasureCustom_body:
	ld b,a
	push hl
	callab treasureData.getTreasureDataBCE
	pop hl
	ld a,b
	jp giveTreasure


giveTreasureCustomSilent:
	call giveTreasureCustom_body
	xor a
	ret


giveTreasureCustom:
	call giveTreasureCustom_body
	jr z,@noSound
	push hl
	call playSound
	pop hl

@noSound:
	ld a,e
	cp a,$ff
	ret z
	ld b,>TX_0000
	ld c,e
	call showText
	xor a
	ret
