; Tile substitutions which occur when the corresponding bits of wRoomFlags is set. This is a way to
; remember when keydoors have been opened, walls have been bombed, etc.
;
; NOTE: In Ages these tables are indexed with wActiveCollisions, but in Seasons, they're indexed
; with wActiveGroup.

standardTileSubstitutions:

@bit0:
	.dw @bit0Collisions0
	.dw @bit0Collisions1
	.dw @bit0Collisions2
	.dw @bit0Collisions3
	.dw @bit0Collisions4
	.dw @bit0Collisions5
@bit1:
	.dw @bit1Collisions0
	.dw @bit1Collisions1
	.dw @bit1Collisions2
	.dw @bit1Collisions3
	.dw @bit1Collisions4
	.dw @bit1Collisions5
@bit2:
	.dw @bit2Collisions0
	.dw @bit2Collisions1
	.dw @bit2Collisions2
	.dw @bit2Collisions3
	.dw @bit2Collisions4
	.dw @bit2Collisions5
@bit3:
	.dw @bit3Collisions0
	.dw @bit3Collisions1
	.dw @bit3Collisions2
	.dw @bit3Collisions3
	.dw @bit3Collisions4
	.dw @bit3Collisions5
@bit7:
	.dw @bit7Collisions0
	.dw @bit7Collisions1
	.dw @bit7Collisions2
	.dw @bit7Collisions3
	.dw @bit7Collisions4
	.dw @bit7Collisions5

@bit0Collisions0:
@bit0Collisions4:
@bit0Collisions5:
	.db $00
@bit0Collisions1:
@bit0Collisions2:
	.db $34 $30 ; Bombable walls, key doors (up)
	.db $34 $38
	.db $a0 $70
	.db $a0 $74
	.db $00
@bit0Collisions3:
	.db $00

@bit1Collisions0:
@bit1Collisions4:
@bit1Collisions5:
	.db $00
@bit1Collisions1:
@bit1Collisions2:
	.db $35 $31 ; Bombable walls, key doors (right)
	.db $35 $39
	.db $35 $68
	.db $a0 $71
	.db $a0 $75
@bit1Collisions3:
	.db $00

@bit2Collisions0:
@bit2Collisions5:
@bit2Collisions4:
	.db $00
@bit2Collisions1:
@bit2Collisions2:
	.db $36 $32 ; Bombable walls, key doors (down)
	.db $36 $3a
	.db $a0 $72
	.db $a0 $76
@bit2Collisions3:
	.db $00

@bit3Collisions0:
@bit3Collisions4:
@bit3Collisions5:
	.db $00
@bit3Collisions1:
@bit3Collisions2:
	.db $37 $33 ; Bombable walls, key doors (left)
	.db $37 $3b
	.db $37 $69
	.db $a0 $73
	.db $a0 $77
@bit3Collisions3:
	.db $00

@bit7Collisions0:
	.db $dd $c1 ; Cave door under rock? (Is this a bug?)
	.db $d2 $c2 ; Soil under rock
	.db $d7 $c4 ; Portal under rock
	.db $dc $c6 ; Grave pushed onto land
	.db $d2 $c7 ; Soil under bush
	.db $d7 $c9 ; Soil under bush
	.db $d2 $cb ; Soil under earth
	.db $dc $cf ; Stairs under burnable tree
	.db $dd $d1 ; Bombable cave door
@bit7Collisions1:
	.db $00
@bit7Collisions2:
	.db $a0 $1e ; Keyblock
	.db $44 $42 ; Appearing upward stairs
	.db $45 $43 ; Appearing downward stairs
	.db $46 $40 ; Appearing upward stairs in wall
	.db $47 $41 ; Appearing downward stairs in wall
@bit7Collisions3:
@bit7Collisions4:
@bit7Collisions5:
	.db $00
