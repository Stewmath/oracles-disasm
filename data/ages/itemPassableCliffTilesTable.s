; If you want to change which tiles are cliff tiles, see also "cliffTilesTable.s".

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
@collisions4:
	.db @@up-CADDR
	.db @@right-CADDR
	.db @@down-CADDR
	.db @@left-CADDR
	.db @@up-CADDR
@@up:
	.db $64 $ff
	.db $05 $ff
	.db $06 $ff
	.db $07 $ff
	.db $8e $ff
	.db $00
@@down:
	.db $64 $01
	.db $05 $01
	.db $06 $01
	.db $07 $01
	.db $8e $01
	.db $00
@@right:
	.db $0b $01
	.db $0a $ff
	.db $00
@@left:
	.db $0b $ff
	.db $0a $01
	.db $00

@collisions1:
	.db @@up-CADDR
	.db @@right-CADDR
	.db @@down-CADDR
	.db @@left-CADDR
	.db @@up-CADDR
@@up:
	.db $b2 $01
	.db $b0 $ff
	.db $00
@@down:
	.db $b0 $01
	.db $b2 $ff
	.db $00
@@right:
	.db $b3 $01
	.db $b1 $ff
	.db $00
@@left:
	.db $b1 $01
	.db $b3 $ff
	.db $00

@collisions2:
@collisions5:
	.db @@up-CADDR
	.db @@right-CADDR
	.db @@down-CADDR
	.db @@left-CADDR
	.db @@up-CADDR

@@up:
	.db $b0 $ff
	.db $b2 $01
	.db $c1 $ff
	.db $c3 $01
	.db $00
@@down:
	.db $b0 $01
	.db $b2 $ff
	.db $c1 $01
	.db $c3 $ff
	.db $00
@@right:
	.db $c4 $01
	.db $c2 $ff
	.db $b3 $01
	.db $b1 $ff
	.db $00
@@left:
	.db $c4 $ff
	.db $c2 $01
	.db $b3 $ff
	.db $b1 $01
	.db $00

@collisions3:
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
