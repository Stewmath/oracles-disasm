; Table defining properties of pushable tiles, used by INTERACID_PUSHBLOCK.
;
; Does not make tiles pushable by itself. See data/{game}/tileProperties/interactableTiles.s for where
; that happens.
;
; NOTE: In Ages this table is indexed by wActiveCollisions, but in Seasons it's indexed by
; wActiveGroup instead.
;
; Data format:
;   b0 (var31): tile index
;   b1 (var32): the tile underneath it after being pushed
;   b2 (var33): the tile it becomes after being pushed (ie. a pushable block may become
;               unpushable)
;   b3 (var34): bit 2: if set, the tile is symmetrical, and flips the left half of the
;                      tile to get the right half.
;               bit 5: if set, it's "heavy" and doesn't get pushed more quickly with L2
;                      bracelet?
;               bit 7: play secret discovery sound after moving, and set
;                      "wDisabledObjects" to 0 (it would have been set to 1 previously
;                      from the "interactableTilesTable".

pushableTilePropertiesTable:
	.db @overworld-CADDR
	.db @indoors-CADDR
	.db @dungeons-CADDR
	.db @sidescrolling-CADDR
	.db @underwater-CADDR
	.db @five-CADDR

@overworld:
	.db $d3 $3a $02 $01
	.db $d8 $3a $02 $05
	.db $d9 $dc $02 $85
	.db $02 $3a $02 $05
@underwater:
@five:
	.db $00

@indoors:
@dungeons:
	.db $18 $a0 $1d $01
	.db $19 $a0 $1d $01
	.db $1a $a0 $1d $01
	.db $1b $a0 $1d $01
	.db $1c $a0 $1d $01
	.db $2a $a0 $2a $01
	.db $2c $a0 $2c $01
	.db $2d $a0 $2d $01
	.db $2e $a0 $2e $01
	.db $10 $a0 $10 $01
	.db $11 $a0 $10 $01
	.db $12 $a0 $10 $01
	.db $13 $0d $10 $01
	.db $25 $a0 $25 $01
	.db $07 $a0 $06 $01
@sidescrolling:
	.db $00
