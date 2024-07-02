; This lists the tiles that are passible from a single direction - usually cliffs.
;
; Data format:
; b0: Tile index
; b1: Specifies whether the item has to go up or down a level of elevation in order to pass it.

itemPassableCliffTilesTable:
	.dw @collisions0
	.dw @collisions1
	.dw @collisions2
	.dw @collisions3
	.dw @collisions4
	.dw @collisions5


@collisions0:
	.db @collisions0Up-CADDR
	.db @collisions0Right-CADDR
	.db @collisions0Down-CADDR
	.db @collisions0Left-CADDR
	.db @collisions0Up-CADDR

@collisions0Up:
	.db $54 $ff
	.db $cf $ff
	.db $ce $ff
	.db $58 $ff
	.db $cd $ff
	.db $94 $ff
	.db $95 $ff
	.db $2a $01
	.db $00
@collisions0Down:
	.db $54 $01
	.db $cf $01
	.db $ce $01
	.db $58 $01
	.db $cd $01
	.db $94 $01
	.db $95 $01
	.db $2a $ff
	.db $00
@collisions0Right:
	.db $27 $01
	.db $26 $01
	.db $25 $ff
	.db $28 $ff
	.db $00
@collisions0Left:
	.db $27 $ff
	.db $26 $ff
	.db $25 $01
	.db $28 $01
	.db $00


@collisions1:
@collisions2:
@collisions3:
@collisions5:
	.db @collisions123Up-CADDR
	.db @collisions123Right-CADDR
	.db @collisions123Down-CADDR
	.db @collisions123Left-CADDR
	.db @collisions123Up-CADDR

@collisions123Up:
@collisions123Right:
@collisions123Down:
@collisions123Left:
	.db $00


@collisions4:
	.db @collisions4Up-CADDR
	.db @collisions4Right-CADDR
	.db @collisions4Down-CADDR
	.db @collisions4Left-CADDR
	.db @collisions4Up-CADDR
@collisions4Up:
	.db $b2 $01
	.db $b0 $ff
	.db $05 $01
	.db $06 $ff
	.db $00
@collisions4Down:
	.db $b0 $01
	.db $b2 $ff
	.db $05 $ff
	.db $06 $01
	.db $00
@collisions4Right:
	.db $b3 $01
	.db $b1 $ff
	.db $00
@collisions4Left:
	.db $b1 $01
	.db $b3 $ff
	.db $00


; This lists the tiles that can be passed through by items (such as the switch hook or
; seeds) even if their collisions prevent link from passing them.
itemPassableTilesTable:
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
