; Most tiles that can be "broken" (turned into another tile) are defined in this file.
;
; Data format:
;   b0: Tile index that can be broken
;   b1: Method of breakage (an index for "breakableTileModes" table, see below)

breakableTileCollisionTable:
	.dw @overworld
	.dw @subrosia
	.dw @makutree
	.dw @indoors
	.dw @dungeons
	.dw @sidescrolling

@overworld:
@makutree:
	.db $f8 $00
	.db $f2 $0d
	.db $c4 $01
	.db $c5 $02
	.db $c6 $03
	.db $c7 $04
	.db $e5 $05
	.db $d8 $06
	.db $c3 $06
	.db $c8 $07
	.db $c9 $08
	.db $c0 $09
	.db $c1 $0a
	.db $c2 $0b
	.db $e2 $0c
	.db $d9 $0e
	.db $da $0f
	.db $db $10
	.db $ca $11
	.db $cb $12
	.db $d7 $13
	.db $e3 $15
	.db $01 $14
	.db $04 $14
	.db $05 $14
	.db $06 $14
	.db $07 $14
	.db $08 $14
	.db $09 $14
	.db $0a $14
	.db $0b $14
	.db $0c $14
	.db $0d $14
	.db $0e $14
	.db $0f $14
	.db $11 $14
	.db $12 $14
	.db $13 $14
	.db $14 $14
	.db $15 $14
	.db $16 $14
	.db $17 $14
	.db $18 $14
	.db $19 $14
	.db $1a $14
	.db $1b $14
	.db $1c $14
	.db $1d $14
	.db $1e $14
	.db $4d $14
	.db $4e $14
	.db $5d $14
	.db $5e $14
	.db $5f $14
	.db $6d $14
	.db $6e $14
	.db $6f $14
	.db $af $14
	.db $bf $14
	.db $00

@subrosia:
	.db $f8 $00
	.db $f9 $00
	.db $f2 $0d
	.db $e9 $09
	.db $01 $17
	.db $04 $17
	.db $05 $17
	.db $06 $17
	.db $07 $17
	.db $08 $17
	.db $09 $17
	.db $0a $17
	.db $0b $17
	.db $0c $17
	.db $0d $17
	.db $0e $17
	.db $0f $17
	.db $11 $17
	.db $12 $17
	.db $13 $17
	.db $14 $17
	.db $15 $17
	.db $16 $17
	.db $17 $17
	.db $18 $17
	.db $19 $17
	.db $1a $17
	.db $1b $17
	.db $1c $17
	.db $1d $17
	.db $1e $17
	.db $1f $17
	.db $20 $17
	.db $21 $17
	.db $22 $17
	.db $23 $17
	.db $24 $17
	.db $25 $17
	.db $26 $17
	.db $27 $17
	.db $28 $17
	.db $29 $17
	.db $2a $17
	.db $2b $17
	.db $2c $17
	.db $2d $17
	.db $2e $17
	.db $b8 $18
	.db $b9 $18
	.db $bb $17
	.db $bc $17
	.db $bd $17
	.db $be $17
	.db $bf $17
	.db $2f $16
	.db $00

@indoors:
@dungeons:
	.db $f8 $2d
	.db $20 $19
	.db $21 $1a
	.db $22 $1b
	.db $23 $1c
	.db $ef $2e
	.db $11 $1d
	.db $12 $1e
	.db $10 $1f
	.db $13 $20
	.db $1f $21
	.db $30 $22
	.db $31 $23
	.db $32 $24
	.db $33 $25
	.db $38 $26
	.db $39 $27
	.db $3a $28
	.db $3b $29
	.db $16 $2a
	.db $15 $2b
	.db $2b $2c
	.db $2a $2c
	.db $00

@sidescrolling:
	.db $12 $2f
	.db $00


; Each tile index in the above table is paired with an index for the table below, which contains the
; following data for each entry.
;
; Data format:
;
;  Parameters 1-3:
;    The ways the tile can be broken. Each bit corresponds to a different method (see
;    "constants/breakableTileSources.s"). Bit order can be read left-to-right, so that the first bit
;    corresponds to breakable tile source "$00" and the last corresponds to source "$13".
;
;  4th parameter:
;    If nonzero, determines types of items that can drop & probabilities of them dropping
;
;  5th parameter:
;    Bits 0-3: The id of the interaction that should be created when the object is destroyed (ie.
;              bush destroying animation).
;    Bit 4:    If set, animation should flicker. (This sets the subid on the spawned interaction to 1.)
;    Bit 6:    Whether to play the discovery sound.
;    Bit 7:    Set if the game should call updateRoomFlagsForBrokenTile on breakage.
;              Consult the "breakableTileRoomFlags.s" file for details.
;
;  6th parameter:
;    The tile it should turn into when broken, or $00 for no change.

breakableTileModes:
	m_BreakableTileData %01101001 %00001100 %0100 $1 $10 $04 ; $00
	m_BreakableTileData %11101101 %10001101 %0110 $1 $00 $04 ; $01
	m_BreakableTileData %11101101 %10001101 %0110 $0 $c0 $e6 ; $02
	m_BreakableTileData %11101101 %10001101 %0110 $0 $c0 $e0 ; $03
	m_BreakableTileData %11101101 %10001101 %0110 $0 $00 $f3 ; $04
	m_BreakableTileData %11101101 %10001101 %0110 $0 $00 $04 ; $05
	m_BreakableTileData %01101101 %10001101 %0110 $4 $01 $04 ; $06
	m_BreakableTileData %01101111 %00001100 %0100 $3 $00 $04 ; $07
	m_BreakableTileData %01101111 %00001100 %1101 $0 $00 $f3 ; $08
	m_BreakableTileData %10000100 %00000000 %0000 $4 $06 $04 ; $09
	m_BreakableTileData %10000100 %00000000 %0000 $0 $c6 $e7 ; $0a
	m_BreakableTileData %10000100 %00000000 %0000 $0 $c6 $e0 ; $0b
	m_BreakableTileData %00001100 %00000001 %0000 $0 $c6 $e8 ; $0c
	m_BreakableTileData %10110101 %10001000 %0000 $7 $0c $04 ; $0d
	m_BreakableTileData %00000010 %00000001 %1110 $4 $19 $04 ; $0e
	m_BreakableTileData %00000010 %00000001 %1110 $0 $19 $f3 ; $0f
	m_BreakableTileData %00001110 %00000000 %1101 $0 $1f $fd ; $10
	m_BreakableTileData %00000000 %00001000 %0000 $7 $1f $04 ; $11
	m_BreakableTileData %00000000 %00001000 %0000 $0 $df $e7 ; $12
	m_BreakableTileData %10000001 %00000000 %0010 $8 $1f $04 ; $13
	m_BreakableTileData %00000010 %00000000 %0000 $9 $0a $e1 ; $14
	m_BreakableTileData %00000010 %00000000 %0000 $0 $ca $e0 ; $15
	m_BreakableTileData %00000010 %00000000 %0000 $0 $0a $e1 ; $16
	m_BreakableTileData %00000010 %00000000 %0000 $a $0a $e1 ; $17
	m_BreakableTileData %00000010 %00000000 %0000 $b $0a $e1 ; $18
	m_BreakableTileData %11101101 %10001100 %0010 $1 $00 $a0 ; $19
	m_BreakableTileData %11101101 %10001100 %0010 $0 $00 $a0 ; $1a
	m_BreakableTileData %11101101 %10001100 %0010 $0 $40 $45 ; $1b
	m_BreakableTileData %11101101 %10001100 %0010 $0 $00 $f3 ; $1c
	m_BreakableTileData %10100100 %10000000 %0000 $0 $06 $a0 ; $1d
	m_BreakableTileData %10100100 %10000000 %0000 $0 $46 $45 ; $1e
	m_BreakableTileData %10100100 %10000000 %0000 $2 $06 $a0 ; $1f
	m_BreakableTileData %10100100 %10000000 %0000 $0 $46 $0d ; $20
	m_BreakableTileData %00001100 %00000000 %0000 $0 $06 $a0 ; $21
	m_BreakableTileData %00001100 %00000000 %0000 $0 $c6 $34 ; $22
	m_BreakableTileData %00001100 %00000000 %0000 $0 $c6 $35 ; $23
	m_BreakableTileData %00001100 %00000000 %0000 $0 $c6 $36 ; $24
	m_BreakableTileData %00001100 %00000000 %0000 $0 $c6 $37 ; $25
	m_BreakableTileData %00001100 %00000000 %0000 $0 $c6 $34 ; $26
	m_BreakableTileData %00001100 %00000000 %0000 $0 $c6 $35 ; $27
	m_BreakableTileData %00001100 %00000000 %0000 $0 $c6 $36 ; $28
	m_BreakableTileData %00001100 %00000000 %0000 $0 $c6 $37 ; $29
	m_BreakableTileData %11111100 %00000000 %0000 $0 $06 $a0 ; $2a
	m_BreakableTileData %10000100 %00000000 %0000 $4 $06 $4c ; $2b
	m_BreakableTileData %01100000 %00000000 %0000 $0 $07 $00 ; $2c
	m_BreakableTileData %01101001 %00001100 %0100 $0 $10 $ef ; $2d
	m_BreakableTileData %00000010 %00000000 %0000 $c $0a $4c ; $2e
	m_BreakableTileData %00001100 %00000000 %0000 $0 $06 $01 ; $2f
