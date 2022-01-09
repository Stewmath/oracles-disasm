; This lists the tiles that are passible from a single direction - usually cliffs.
; The second byte in the .db's specifies whether the item has to go up or down a level of
; elevation in order to pass it.
itemPassableCliffTilesTable:
	.dw @collisions0
	.dw @collisions1
	.dw @collisions2
	.dw @collisions3
	.dw @collisions4
	.dw @collisions5

@collisions0:
	.db @@up-CADDR
	.db @@right-CADDR
	.db @@down-CADDR
	.db @@left-CADDR
	.db @@up-CADDR
@@up:
        .db $54 $ff
        .db $cf $ff
        .db $ce $ff
        .db $58 $ff
        .db $cd $ff
        .db $94 $ff
        .db $95 $ff
        .db $2a $01
        .db $00
@@down:
        .db $54 $01
        .db $cf $01
        .db $ce $01
        .db $58 $01
        .db $cd $01
        .db $94 $01
        .db $95 $01
        .db $2a $ff
        .db $00
@@right:
        .db $27 $01
        .db $26 $01
        .db $25 $ff
        .db $28 $ff
        .db $00
@@left:
	.db $27 $ff
        .db $26 $ff
        .db $25 $01
        .db $28 $01
        .db $00

@collisions1:
@collisions2:
@collisions3:
@collisions5:
	.db @@up-CADDR
	.db @@right-CADDR
	.db @@down-CADDR
	.db @@left-CADDR
	.db @@up-CADDR
@@up:
@@right:
@@down:
@@left:
	.db $00

@collisions4:
	.db @@up-CADDR
	.db @@right-CADDR
	.db @@down-CADDR
	.db @@left-CADDR
	.db @@up-CADDR
@@up:
        .db $b2 $01
        .db $b0 $ff
        .db $05 $01
        .db $06 $ff
        .db $00
@@down:
        .db $b0 $01
        .db $b2 $ff
        .db $05 $ff
        .db $06 $01
        .db $00
@@right:
        .db $b3 $01
        .db $b1 $ff
        .db $00
@@left:
        .db $b1 $01
        .db $b3 $ff
        .db $00
