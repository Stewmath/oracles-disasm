; This lists the tiles that are passible from a single direction - usually cliffs.
;
; Data format:
;   b0: Tile index
;   b1: Specifies whether the item has to go up ($01) or down ($ff) a level of elevation in order to pass it.

itemPassableCliffTilesTable:
	.dw @overworld
	.dw @indoors
	.dw @dungeons
	.dw @sidescrolling
	.dw @underwater
	.dw @five


@overworld:
@underwater:
	.db @overworldUp-CADDR
	.db @overworldRight-CADDR
	.db @overworldDown-CADDR
	.db @overworldLeft-CADDR
	.db @overworldUp-CADDR

@overworldUp:
	.db $64 $ff
	.db $05 $ff
	.db $06 $ff
	.db $07 $ff
	.db $8e $ff
	.db $00

@overworldDown:
	.db $64 $01
	.db $05 $01
	.db $06 $01
	.db $07 $01
	.db $8e $01
	.db $00

@overworldRight:
	.db $0b $01
	.db $0a $ff
	.db $00

@overworldLeft:
	.db $0b $ff
	.db $0a $01
	.db $00


@indoors:
	.db @indoorsUp-CADDR
	.db @indoorsRight-CADDR
	.db @indoorsDown-CADDR
	.db @indoorsLeft-CADDR
	.db @indoorsUp-CADDR

@indoorsUp:
	.db $b2 $01
	.db $b0 $ff
	.db $00

@indoorsDown:
	.db $b0 $01
	.db $b2 $ff
	.db $00

@indoorsRight:
	.db $b3 $01
	.db $b1 $ff
	.db $00

@indoorsLeft:
	.db $b1 $01
	.db $b3 $ff
	.db $00


@dungeons:
@five:
	.db @dungeonsUp-CADDR
	.db @dungeonsRight-CADDR
	.db @dungeonsDown-CADDR
	.db @dungeonsLeft-CADDR
	.db @dungeonsUp-CADDR

@dungeonsUp:
	.db $b0 $ff
	.db $b2 $01
	.db $c1 $ff
	.db $c3 $01
	.db $00

@dungeonsDown:
	.db $b0 $01
	.db $b2 $ff
	.db $c1 $01
	.db $c3 $ff
	.db $00

@dungeonsRight:
	.db $c4 $01
	.db $c2 $ff
	.db $b3 $01
	.db $b1 $ff
	.db $00

@dungeonsLeft:
	.db $c4 $ff
	.db $c2 $01
	.db $b3 $ff
	.db $b1 $01
	.db $00


@sidescrolling:
	.db @sidescrollingUp-CADDR
	.db @sidescrollingRight-CADDR
	.db @sidescrollingDown-CADDR
	.db @sidescrollingLeft-CADDR
	.db @sidescrollingUp-CADDR

@sidescrollingUp:
@sidescrollingRight:
@sidescrollingDown:
@sidescrollingLeft:
	.db $00


; This lists the tiles that can be passed through by items (such as the switch hook or
; seeds) even if their collisions prevent link from passing them.
itemPassableTilesTable:
	.dw @overworld
	.dw @indoors
	.dw @dungeons
	.dw @sidescrolling
	.dw @underwater
	.dw @five

@overworld:
@underwater:
	.db $fd $eb
	.db $00

@indoors:
	.db $94 $95 $0a
	.db $00

@dungeons:
@five:
	.db $90 $91 $92 $93 $94 $95 $96 $97
	.db $98 $99 $9a $9b $0a $0b $0e $0f
@sidescrolling:
	.db $00
