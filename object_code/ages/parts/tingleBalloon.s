; ==================================================================================================
; PART_TINGLE_BALLOON
; ==================================================================================================
partCode44:
	jr nz,@beenHit

	ld e,Part.state
	ld a,(de)
	or a
	jr nz,@state1

@state0:
	ld h,d
	ld l,e
	inc (hl) ; [state] = 1

	ld l,Part.counter1
	ld (hl),$38
	inc l
	ld (hl),$ff ; [counter2]

	ld l,Part.zh
	ld (hl),$f1
	ld bc,-$10
	call objectSetSpeedZ

	xor a
	call partSetAnimation
	call objectSetVisible81

@state1:
	call partCommon_decCounter1IfNonzero
	jr nz,++

	; Reverse floating direction
	ld (hl),$38 ; [counter1]
	ld l,Part.speedZ
	ld a,(hl)
	cpl
	inc a
	ldi (hl),a
	ld a,(hl)
	cpl
	ld (hl),a
++
	ld c,$00
	call objectUpdateSpeedZ_paramC

	; Update Tingle's z position
	ld a,Object.zh
	call objectGetRelatedObject1Var
	ld e,Part.zh
	ld a,(de)
	ld (hl),a
	ret

@beenHit:
	ld a,Object.state
	call objectGetRelatedObject1Var
	inc (hl) ; [tingle.state] = 2

	; Spawn explosion
	call getFreeInteractionSlot
	ld (hl),INTERAC_EXPLOSION
	ld l,Interaction.var03
	ld (hl),$01 ; Give it a higher draw priority?
	ld bc,$f000
	call objectCopyPositionWithOffset

	jp partDelete
