; This file is included by "code/rando/rando.s" which puts it in the "rando" namespace.

;;
; This is called by the "giveTreasure" function just after giving the treasure.
;
; @param	b	Treasure
; @param	c	Parameter
randoGiveTreasureHook:
	call satchelRefillSeeds
	call activateFlute
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
; Sets flute icon and animal flags based on flute param.
activateFlute:
	ld a,b
	cp a,TREASURE_FLUTE
	ret nz

.ifdef ROM_SEASONS
	ld e,<wFluteIcon
	ld a,c
	sub $0a ; get animal index item parameter
	ld (de),a
	add <wRickyState - 1
	ld h,>wRickyState
	ld l,a ; hl = flags for relevant animal
	cp <wMooshState
	jr nz,@notMoosh

	set 5,(hl)
	jr @done

@notMoosh:
	set 7,(hl)

@done:
	ret

.else
	; RANDO-TODO: Ages
	ret
.endif


; ================================================================================
; Below here are callbacks from "data/rando/itemSlots.s", called when items in specific slots are
; received. These are called just after "giveTreasure" is called.
; ================================================================================

itemSlotCallbacksStart:

.ifdef ROM_SEASONS

seasonsSlotCallback_makuTree:
	ld a,RANDO_MAKU_TREE_FLAG
	call setRandoFlag
	ret

.endif
