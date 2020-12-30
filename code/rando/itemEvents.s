; This file is included by "object_code/common/interactionCode/treasure.s" which puts it in the
; "treasureInteraction" namespace.

;;
; This is called by the "giveTreasure" function just after giving the treasure.
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
	push bc
	push de
	push hl

.ifdef ROM_SEASONS
	ld a,(wActiveGroup)
	cp $01
	jr z,@subrosia
	cp $02
	jr z,@indoors
	jr @ret

@subrosia:
	; RANDO-TODO
	;ld a,(wActiveRoom)
	;ld hl,starOreRooms
	;call searchValue
	;ret nz
	;ld hl,c694
	;set 2,(hl)
	jr @ret

@indoors:
	ld a,(wActiveRoom)
	ld hl,@makuTreeRooms
	call searchValue
	ret nz
	ld a,RANDO_MAKU_TREE_FLAG
	call setRandoFlag
	jr @ret

@makuTreeRooms:
	.db $0b, $0c, $7b, $2b, $2c, $2d, $5b, $5c, $5d, $ff

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


@ret:
	pop hl
	pop de
	pop bc
	ret
