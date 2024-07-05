; Tile substitutions which occur when the corresponding bits of wRoomFlags are set. This is a way to
; remember when keydoors have been opened, walls have been bombed, etc.
;
; NOTE: In Ages these tables are indexed with wActiveCollisions, but in Seasons, they're indexed
; with wActiveGroup.
;
; For room-specific tile substitutions, see data/{game}/singleTileChanges.s, or
; code/{game}/roomSpecificTileChanges.s.
;
; Data format:
;   b0: New tile index to use ($00 for end of list)
;   b1: Tile index to replace with value "b0" when corresponding room flag bit is set

standardTileSubstitutions:

@bit0:
	.dw @bit0Overworld
	.dw @bit0Indoors
	.dw @bit0Dungeons
	.dw @bit0Sidescrolling
	.dw @bit0Underwater
	.dw @bit0Five
@bit1:
	.dw @bit1Overworld
	.dw @bit1Indoors
	.dw @bit1Dungeons
	.dw @bit1Sidescrolling
	.dw @bit1Underwater
	.dw @bit1Five
@bit2:
	.dw @bit2Overworld
	.dw @bit2Indoors
	.dw @bit2Dungeons
	.dw @bit2Sidescrolling
	.dw @bit2Underwater
	.dw @bit2Five
@bit3:
	.dw @bit3Overworld
	.dw @bit3Indoors
	.dw @bit3Dungeons
	.dw @bit3Sidescrolling
	.dw @bit3Underwater
	.dw @bit3Five
@bit7:
	.dw @bit7Overworld
	.dw @bit7Indoors
	.dw @bit7Dungeons
	.dw @bit7Sidescrolling
	.dw @bit7Underwater
	.dw @bit7Five


@bit0Overworld:
@bit0Underwater:
@bit0Five:
	.db $00

@bit0Indoors:
@bit0Dungeons:
	.db $34 $30 ; Bombable walls (up)
	.db $34 $38
	.db $a0 $70 ; Key doors (up)
	.db $a0 $74
	.db $00

@bit0Sidescrolling:
	.db $00


@bit1Overworld:
@bit1Underwater:
@bit1Five:
	.db $00

@bit1Indoors:
@bit1Dungeons:
	.db $35 $31 ; Bombable walls (right)
	.db $35 $39
	.db $35 $68 ; Spirit's Grave burnable wall (right)
	.db $a0 $71 ; Key doors (right)
	.db $a0 $75
@bit1Sidescrolling:
	.db $00


@bit2Overworld:
@bit2Five:
@bit2Underwater:
	.db $00
@bit2Indoors:
@bit2Dungeons:
	.db $36 $32 ; Bombable walls (down)
	.db $36 $3a
	.db $a0 $72 ; Key doors (down)
	.db $a0 $76
@bit2Sidescrolling:
	.db $00


@bit3Overworld:
@bit3Underwater:
@bit3Five:
	.db $00

@bit3Indoors:
@bit3Dungeons:
	.db $37 $33 ; Bombable walls (left)
	.db $37 $3b
	.db $37 $69 ; Spirit's Grave burnable wall (left)
	.db $a0 $73 ; Key doors (left)
	.db $a0 $77
@bit3Sidescrolling:
	.db $00


@bit7Overworld:
	.db $dd $c1 ; Cave door under rock? (Is this a bug?)
	.db $d2 $c2 ; Soil under rock
	.db $d7 $c4 ; Portal under rock
	.db $dc $c6 ; Grave pushed onto land
	.db $d2 $c7 ; Soil under bush
	.db $d7 $c9 ; Soil under bush
	.db $d2 $cb ; Soil under earth
	.db $dc $cf ; Stairs under burnable tree
	.db $dd $d1 ; Bombable cave door
@bit7Indoors:
	.db $00

@bit7Dungeons:
	.db $a0 $1e ; Keyblock
	.db $44 $42 ; Appearing upward stairs
	.db $45 $43 ; Appearing downward stairs
	.db $46 $40 ; Appearing upward stairs in wall
	.db $47 $41 ; Appearing downward stairs in wall
@bit7Sidescrolling:
@bit7Underwater:
@bit7Five:
	.db $00
