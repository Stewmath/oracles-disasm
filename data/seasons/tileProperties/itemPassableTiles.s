; This lists the tiles that are passible from a single direction - usually cliffs.
;
; Data format:
;   b0: Tile index
;   b1: Specifies whether the item has to go up ($01) or down ($ff) a level of elevation in order to pass it.

itemPassableCliffTilesTable:
	.dw @overworld
	.dw @subrosia
	.dw @makutree
	.dw @indoors
	.dw @dungeons
	.dw @sidescrolling


@overworld:
	dbrel @overworldUp
	dbrel @overworldRight
	dbrel @overworldDown
	dbrel @overworldLeft
	dbrel @overworldUp

@overworldUp:
	.db $54 $ff
	.db $cf $ff
	.db $ce $ff
	.db $58 $ff
	.db $cd $ff
	.db $94 $ff
	.db $95 $ff
	.db $2a $01
	.db $00

@overworldDown:
	.db $54 $01
	.db $cf $01
	.db $ce $01
	.db $58 $01
	.db $cd $01
	.db $94 $01
	.db $95 $01
	.db $2a $ff
	.db $00

@overworldRight:
	.db $27 $01
	.db $26 $01
	.db $25 $ff
	.db $28 $ff
	.db $00

@overworldLeft:
	.db $27 $ff
	.db $26 $ff
	.db $25 $01
	.db $28 $01
	.db $00


@subrosia:
@makutree:
@indoors:
@sidescrolling:
	dbrel @stubUp
	dbrel @stubRight
	dbrel @stubDown
	dbrel @stubLeft
	dbrel @stubUp

@stubUp:
@stubRight:
@stubDown:
@stubLeft:
	.db $00


@dungeons:
	dbrel @dungeonsUp
	dbrel @dungeonsRight
	dbrel @dungeonsDown
	dbrel @dungeonsLeft
	dbrel @dungeonsUp

@dungeonsUp:
	.db $b2 $01
	.db $b0 $ff
	.db $05 $01
	.db $06 $ff
	.db $00

@dungeonsDown:
	.db $b0 $01
	.db $b2 $ff
	.db $05 $ff
	.db $06 $01
	.db $00

@dungeonsRight:
	.db $b3 $01
	.db $b1 $ff
	.db $00

@dungeonsLeft:
	.db $b1 $01
	.db $b3 $ff
	.db $00


; This lists the tiles that can be passed through by items (such as the switch hook or
; seeds) even if their collisions prevent link from passing them.
itemPassableTilesTable:
	.dw @overworld
	.dw @subrosia
	.dw @makutree
	.dw @indoors
	.dw @dungeons
	.dw @sidescrolling

@overworld:
@subrosia:
	.db $fd
@makutree:
	.db $00

@indoors:
	.db $cf $00

@dungeons:
	.db $90 $91 $92 $93 $94 $95 $96 $97
	.db $98 $99 $9a $9b $0a $0b
@sidescrolling:
	.db $00
