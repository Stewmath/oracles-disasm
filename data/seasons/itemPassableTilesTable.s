; This lists the tiles that can be passed through by items (such as the switch hook or
; seeds) even if their collisions prevent link from passing them.
itemPassableTilesTable:
	.dw itemPassibleTiles_collisions0
	.dw itemPassibleTiles_collisions1
	.dw itemPassibleTiles_collisions2
	.dw itemPassibleTiles_collisions3
	.dw itemPassibleTiles_collisions4
	.dw itemPassibleTiles_collisions5

itemPassibleTiles_collisions0:
itemPassibleTiles_collisions1:
	.db $fd
itemPassibleTiles_collisions2:
	.db $00
itemPassibleTiles_collisions3:
        .db $cf $00
itemPassibleTiles_collisions4:
        .db $90 $91 $92 $93 $94 $95 $96 $97
        .db $98 $99 $9a $9b $0a $0b
itemPassibleTiles_collisions5:
	.db $00
