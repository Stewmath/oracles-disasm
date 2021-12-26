.BANK $08 SLOT 1

.SECTION RandoAgesStartingTreasure NAMESPACE agesInteractionsBank08 FREE

interactionCodeStartingTreasure:
	call getThisRoomFlags
	and ROOMFLAG_ITEM
	jr nz,@delete

	ld bc,rando.agesSlot_startingItem
	call spawnRandomizedTreasure
	call objectCopyPosition
@delete:
	jp interactionDelete

.ENDS
