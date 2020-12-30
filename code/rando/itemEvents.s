; This file is included by "code/rando/rando.s" which puts it in the "rando" namespace.

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
