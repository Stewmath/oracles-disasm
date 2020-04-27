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
@collisions1:
	.db $fd
@collisions2:
	.db $00
@collisions3:
        .db $cf $00
@collisions4:
        .db $90 $91 $92 $93 $94 $95 $96 $97
        .db $98 $99 $9a $9b $0a $0b
@collisions5:
	.db $00
