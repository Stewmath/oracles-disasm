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
@collisions4:
	.db @collisions0Up-CADDR
	.db @collisions0Right-CADDR
	.db @collisions0Down-CADDR
	.db @collisions0Left-CADDR
	.db @collisions0Up-CADDR
@collisions0Up:
	.db $64 $ff
	.db $05 $ff
	.db $06 $ff
	.db $07 $ff
	.db $8e $ff
	.db $00
@collisions0Down:
	.db $64 $01
	.db $05 $01
	.db $06 $01
	.db $07 $01
	.db $8e $01
	.db $00
@collisions0Right:
	.db $0b $01
	.db $0a $ff
	.db $00
@collisions0Left:
	.db $0b $ff
	.db $0a $01
	.db $00


@collisions1:
	.db @collisions1Up-CADDR
	.db @collisions1Right-CADDR
	.db @collisions1Down-CADDR
	.db @collisions1Left-CADDR
	.db @collisions1Up-CADDR
@collisions1Up:
	.db $b2 $01
	.db $b0 $ff
	.db $00
@collisions1Down:
	.db $b0 $01
	.db $b2 $ff
	.db $00
@collisions1Right:
	.db $b3 $01
	.db $b1 $ff
	.db $00
@collisions1Left:
	.db $b1 $01
	.db $b3 $ff
	.db $00


@collisions2:
@collisions5:
	.db @collisions25Up-CADDR
	.db @collisions25Right-CADDR
	.db @collisions25Down-CADDR
	.db @collisions25Left-CADDR
	.db @collisions25Up-CADDR

@collisions25Up:
	.db $b0 $ff
	.db $b2 $01
	.db $c1 $ff
	.db $c3 $01
	.db $00
@collisions25Down:
	.db $b0 $01
	.db $b2 $ff
	.db $c1 $01
	.db $c3 $ff
	.db $00
@collisions25Right:
	.db $c4 $01
	.db $c2 $ff
	.db $b3 $01
	.db $b1 $ff
	.db $00
@collisions25Left:
	.db $c4 $ff
	.db $c2 $01
	.db $b3 $ff
	.db $b1 $01
	.db $00


@collisions3:
	.db @collisions3up-CADDR
	.db @collisions3right-CADDR
	.db @collisions3down-CADDR
	.db @collisions3left-CADDR
	.db @collisions3up-CADDR

@collisions3up:
@collisions3right:
@collisions3down:
@collisions3left:
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
