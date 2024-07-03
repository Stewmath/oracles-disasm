; Tile substitutions which occur when the corresponding bits of wRoomFlags is set. This is a way to
; remember when keydoors have been opened, walls have been bombed, etc.
;
; NOTE: In Ages these tables are indexed with wActiveCollisions, but in Seasons, they're indexed
; with wActiveGroup.

standardTileSubstitutions:

@bit0:
	.dw @bit0Overworld
	.dw @bit0Subrosia
	.dw @bit0Makutree
	.dw @bit0Indoors
	.dw @bit0Dungeons
	.dw @bit0Dungeons
	.dw @bit0Sidescrolling
	.dw @bit0Sidescrolling

@bit1:
	.dw @bit1Overworld
	.dw @bit1Subrosia
	.dw @bit1Makutree
	.dw @bit1Indoors
	.dw @bit1Dungeons
	.dw @bit1Dungeons
	.dw @bit1Sidescrolling
	.dw @bit1Sidescrolling

@bit2:
	.dw @bit2Overworld
	.dw @bit2Subrosia
	.dw @bit2Makutree
	.dw @bit2Indoors
	.dw @bit2Dungeons
	.dw @bit2Dungeons
	.dw @bit2Sidescrolling
	.dw @bit2Sidescrolling

@bit3:
	.dw @bit3Overworld
	.dw @bit3Subrosia
	.dw @bit3Makutree
	.dw @bit3Indoors
	.dw @bit3Dungeons
	.dw @bit3Dungeons
	.dw @bit3Sidescrolling
	.dw @bit3Sidescrolling

@bit7:
	.dw @bit7Overworld
	.dw @bit7Subrosia
	.dw @bit7Makutree
	.dw @bit7Indoors
	.dw @bit7Dungeons
	.dw @bit7Dungeons
	.dw @bit7Sidescrolling
	.dw @bit7Sidescrolling

@bit0Overworld:
@bit0Subrosia:
@bit0Makutree:
	.db $00

@bit0Indoors:
@bit0Dungeons:
	.db $34 $30 ; Bombable walls, key doors (up)
	.db $34 $38
	.db $a0 $70
	.db $a0 $74
	.db $00

@bit0Sidescrolling:
	.db $00

@bit1Overworld:
@bit1Subrosia:
@bit1Makutree:
	.db $00

@bit1Indoors:
@bit1Dungeons:
	.db $35 $31 ; Bombable walls, key doors (right)
	.db $35 $39
	.db $a0 $71
	.db $a0 $75

@bit1Sidescrolling:
	.db $00

@bit2Overworld:
@bit2Subrosia:
@bit2Makutree:
	.db $00

@bit2Indoors:
@bit2Dungeons:
	.db $36 $32 ; Bombable walls, key doors (down)
	.db $36 $3a
	.db $a0 $72
	.db $a0 $76

@bit2Sidescrolling:
	.db $00

@bit3Overworld:
@bit3Subrosia:
@bit3Makutree:
	.db $00

@bit3Indoors:
@bit3Dungeons:
	.db $37 $33 ; Bombable walls, key doors (left)
	.db $37 $3b
	.db $a0 $73
	.db $a0 $77

@bit3Sidescrolling:
	.db $00

@bit7Overworld:
	.db $e7 $c1 ; TODO
	.db $e0 $c6
	.db $e0 $c2
	.db $e0 $e3
	.db $e6 $c5
	.db $e7 $cb
	.db $e8 $e2

@bit7Subrosia:
	.db $00

@bit7Makutree:
	.db $00

@bit7Indoors:
	.db $00

@bit7Dungeons:
	.db $a0 $1e
	.db $44 $42
	.db $45 $43
	.db $46 $40
	.db $47 $41
	.db $45 $8d

@bit7Sidescrolling:
	.db $00
