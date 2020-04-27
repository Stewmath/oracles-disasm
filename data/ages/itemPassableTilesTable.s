; This lists the tiles that can be passed through by items (such as the switch hook or
; seeds) even if their collisions prevent link from passing them.
; @addr{4cc9}
_itemPassableTilesTable:
	.dw @collisions0
	.dw @collisions1
	.dw @collisions2
	.dw @collisions3
	.dw @collisions4
	.dw @collisions5

@collisions0:
@collisions4:
	.db $fd $eb
	.db $00
@collisions1:
	.db $94 $95 $0a
	.db $00
@collisions2:
@collisions5:
	.db $90 $91 $92 $93 $94 $95 $96 $97
	.db $98 $99 $9a $9b $0a $0b $0e $0f
@collisions3:
	.db $00
