; This file is included by "object_code/common/interactionCode/treasure.s" which puts it in the
; "treasureInteraction" namespace.

;;
; This is called just by the "giveTreasure" function just after giving the treasure.
;
; @param	b	Treasure
; @param	c	Parameter
randoGiveTreasureHook:
	call satchelRefillSeeds
	ret

;;
; Have seed satchel inherently refill all seeds.
satchelRefillSeeds:
	ld a,b
	cp TREASURE_SEED_SATCHEL
	ret nz

	push bc
	call refillSeedSatchel
	pop bc
	ret

;;
; This is like above, but it is ONLY called when a treasure object is obtained. This is used to
; handle specific rooms with non-standard ways of marking the item as "obtained".
;
; Can't use the "randoGiveTreasureHook" function for this because it would also trigger on things
; like dug up rupees.
randoGiveTreasureFromObjectHook:

.ifdef ROM_SEASONS
	ld a,(wActiveGroup)
	cp $01
	jr z,@subrosia
	cp $02
	jr z,@indoors
	ret

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
	ret
.endif



