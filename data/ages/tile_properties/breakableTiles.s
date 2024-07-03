; Most tiles that can be "broken" (turned into another tile) are defined in this file.
;
; Data format:
;   b0: Tile index that can be broken
;   b1: Method of breakage (an index for "breakableTileModes" table, see below)

breakableTileCollisionTable:
	.dw @overworld
	.dw @indoors
	.dw @dungeons
	.dw @sidescrolling
	.dw @underwater
	.dw @five

@overworld:
@underwater:
	.db $da $32
	.db $f8 $00
	.db $f2 $0d
	.db $c0 $07
	.db $c1 $08
	.db $c2 $09
	.db $c3 $0b
	.db $c4 $0a
	.db $c5 $01
	.db $c6 $04
	.db $c7 $03
	.db $c8 $06
	.db $c9 $02
	.db $ca $05
	.db $cb $12
	.db $cc $13
	.db $cd $0e
	.db $ce $0f
	.db $cf $10
	.db $d1 $0c
	.db $db $14
	.db $04 $15
	.db $01 $11
	.db $10 $11
	.db $11 $11
	.db $12 $11
	.db $13 $11
	.db $14 $11
	.db $15 $11
	.db $16 $11
	.db $17 $11
	.db $18 $11
	.db $19 $11
	.db $1a $11
	.db $1b $11
	.db $20 $11
	.db $21 $11
	.db $22 $11
	.db $23 $11
	.db $24 $11
	.db $25 $11
	.db $26 $11
	.db $27 $11
	.db $28 $11
	.db $29 $11
	.db $2a $11
	.db $2b $11
	.db $30 $11
	.db $31 $11
	.db $32 $11
	.db $33 $11
	.db $34 $11
	.db $35 $11
	.db $36 $11
	.db $37 $11
	.db $38 $11
	.db $39 $11
	.db $3a $11
	.db $3b $11
	.db $af $11
	.db $bf $11
	.db $00

@indoors:
@dungeons:
@five:
	.db $da $32
	.db $f2 $16
	.db $f8 $2a
	.db $20 $17
	.db $21 $18
	.db $22 $19
	.db $23 $1a
	.db $ef $2b
	.db $11 $1b
	.db $12 $1c
	.db $10 $1d
	.db $13 $1e
	.db $1f $1f
	.db $30 $20
	.db $31 $21
	.db $32 $22
	.db $33 $23
	.db $38 $24
	.db $39 $25
	.db $3a $26
	.db $3b $27
	.db $16 $28
	.db $15 $29
	.db $db $2d
	.db $24 $2c
	.db $68 $2e
	.db $69 $2f
	.db $00

@sidescrolling:
	.db $da $32
	.db $12 $30
	.db $71 $31
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
	m_BreakableTileData %01101001 %00001100 %0100 $1 $10 $3a ; $00
	m_BreakableTileData %11101101 %10001101 %0110 $1 $00 $3a ; $01
	m_BreakableTileData %11101101 %10001101 %0110 $0 $c0 $d7 ; $02
	m_BreakableTileData %11101101 %10001101 %0110 $0 $c0 $d2 ; $03
	m_BreakableTileData %11101101 %10001101 %0110 $0 $c0 $dc ; $04
	m_BreakableTileData %11101101 %10001101 %0110 $0 $00 $f3 ; $05
	m_BreakableTileData %11101101 %10001101 %0110 $0 $00 $3a ; $06
	m_BreakableTileData %10000100 %00000000 %0000 $4 $06 $3a ; $07
	m_BreakableTileData %10000100 %00000000 %0000 $0 $c6 $dc ; $08
	m_BreakableTileData %10000100 %00000000 %0000 $0 $c6 $d2 ; $09
	m_BreakableTileData %10000100 %00000000 %0000 $0 $c6 $d7 ; $0a
	m_BreakableTileData %10000100 %00000000 %0000 $0 $06 $3a ; $0b
	m_BreakableTileData %00001100 %00000001 %0000 $0 $c6 $dd ; $0c
	m_BreakableTileData %10110101 %10001000 %0000 $7 $0c $3a ; $0d
	m_BreakableTileData %00000010 %00000001 %1110 $4 $0a $3a ; $0e
	m_BreakableTileData %00000000 %00001000 %0000 $7 $1f $3a ; $0f
	m_BreakableTileData %00000000 %00001000 %0000 $0 $df $dc ; $10
	m_BreakableTileData %00000010 %00000000 %0000 $9 $0a $1c ; $11
	m_BreakableTileData %00000010 %00000000 %0000 $0 $ca $d2 ; $12
	m_BreakableTileData %00000010 %00000000 %0000 $0 $0a $d7 ; $13
	m_BreakableTileData %00000100 %10000000 %0000 $0 $06 $3a ; $14
	m_BreakableTileData %01101000 %00001001 %1111 $0 $00 $3b ; $15
	m_BreakableTileData %10110101 %10001000 %0000 $7 $0c $a0 ; $16
	m_BreakableTileData %11101101 %10001100 %0010 $1 $00 $a0 ; $17
	m_BreakableTileData %11101101 %10001100 %0010 $0 $00 $a0 ; $18
	m_BreakableTileData %11101101 %10001100 %0010 $0 $40 $45 ; $19
	m_BreakableTileData %11101101 %10001100 %0010 $0 $00 $f3 ; $1a
	m_BreakableTileData %10100100 %10000000 %0000 $0 $06 $a0 ; $1b
	m_BreakableTileData %10100100 %10000000 %0000 $0 $46 $45 ; $1c
	m_BreakableTileData %10100100 %10000000 %0000 $2 $06 $a0 ; $1d
	m_BreakableTileData %10100100 %10000000 %0000 $0 $46 $0d ; $1e
	m_BreakableTileData %00001100 %00000000 %0000 $0 $06 $a0 ; $1f
	m_BreakableTileData %00001100 %00000000 %0000 $0 $c6 $34 ; $20
	m_BreakableTileData %00001100 %00000000 %0000 $0 $c6 $35 ; $21
	m_BreakableTileData %00001100 %00000000 %0000 $0 $c6 $36 ; $22
	m_BreakableTileData %00001100 %00000000 %0000 $0 $c6 $37 ; $23
	m_BreakableTileData %00001100 %00000000 %0000 $0 $c6 $34 ; $24
	m_BreakableTileData %00001100 %00000000 %0000 $0 $c6 $35 ; $25
	m_BreakableTileData %00001100 %00000000 %0000 $0 $c6 $36 ; $26
	m_BreakableTileData %00001100 %00000000 %0000 $0 $c6 $37 ; $27
	m_BreakableTileData %11111100 %00001000 %0000 $0 $06 $a0 ; $28
	m_BreakableTileData %10000100 %00000000 %0000 $4 $06 $4c ; $29
	m_BreakableTileData %01101001 %00001100 %0100 $0 $10 $ef ; $2a
	m_BreakableTileData %00000010 %00000000 %0000 $c $0a $4c ; $2b
	m_BreakableTileData %00000010 %00000000 %0000 $0 $0a $a1 ; $2c
	m_BreakableTileData %00000100 %10000000 %0000 $0 $06 $a0 ; $2d
	m_BreakableTileData %00000000 %00001000 %0000 $0 $df $35 ; $2e
	m_BreakableTileData %00000000 %00001000 %0000 $0 $df $37 ; $2f
	m_BreakableTileData %00001100 %00000000 %0000 $0 $06 $01 ; $30
	m_BreakableTileData %10100100 %10000000 %0000 $0 $06 $01 ; $31
	m_BreakableTileData %01111100 %00000001 %1101 $0 $1f $00 ; $32
