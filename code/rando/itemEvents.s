; This file is included by "object_code/common/interactionCode/treasure.s" which puts it in the
; "treasureInteraction" namespace.

;;
; This is roughly based on the "handleGetItem" function from the original randomizer although it's
; morphed into a sort of wrapper over "giveTreasure".
;
; Run certain actions depending on what item was picked up and where. This has to be explicitly
; called if an item is given by an interaction other than ID 60. (This *should* be called when any
; randomized treasure is received, no matter the source.)
;
; @param	b	Treasure
; @param	c	Parameter
; @param[out]	b	Sound to play (from giveTreasure function)
giveRandomizedTreasure_body:
	call satchelRefillSeeds

.ifdef ROM_SEASONS
	jr z,@giveTreasure

	ld a,(wActiveGroup)
	cp $01
	jr z,@subrosia
	cp $02
	jr z,@indoors
	jr @giveTreasure

@subrosia:
	; RANDO-TODO
	;ld a,(wActiveRoom)
	;ld hl,starOreRooms
	;call searchValue
	;ret nz
	;ld hl,c694
	;set 2,(hl)
	ret

@indoors:
	; RANDO-TODO
	;ld a,(wActiveRoom)
	;ld hl,makuTreeRooms
	;call searchValue
	;ret nz
	;ld hl,c693
	;set 2,(hl)
	ret

.else; ROM_AGES
	push af
	; RANDO-TODO
	;call seedShooterGiveSeeds
	;call activateFlute
	pop af
	jr z,@incoming

@outgoing:
	; RANDO-TODO
	;call dirtSetFakeId
	;call tingleSetFakeId
	;call symmetryBrotherSetFakeId
	;call goronDanceSetFakeId
	;call kingZoraSetFakeId

@incoming:
	; RANDO-TODO
	;call setD6BossKey
	;call makuSeedResetTreeState
.endif

@giveTreasure:
	ld a,b
	call giveTreasure
	ld b,a
	ret



; Have seed satchel inherently refill all seeds.
satchelRefillSeeds:
	ld a,b
	cp TREASURE_SEED_SATCHEL
	ret nz

	push bc
	push de
	push hl
	ld hl,wSeedSatchelLevel
	inc (hl) ; Needed since this is run *before* the satchel is given
	call refillSeedSatchel
	dec (hl)
	pop hl
	pop de
	pop bc
	ret
