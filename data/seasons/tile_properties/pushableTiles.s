; Table defining properties of pushable tiles, used by INTERAC_PUSHBLOCK.
;
; Does not make tiles pushable by itself. See data/{game}/tile_properties/interactableTiles.s for where
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
	dbrel @overworld
	dbrel @subrosia
	dbrel @makutree
	dbrel @indoors
	dbrel @dungeons
	dbrel @dungeons
	dbrel @sidescrolling
	dbrel @sidescrolling

@overworld:
@subrosia:
	.db $d6 $04 $9c $01
@makutree:
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
	.db $10 $a0 $10 $01
	.db $11 $a0 $10 $01
	.db $12 $a0 $10 $01
	.db $13 $0d $10 $01
	.db $25 $a0 $25 $01
	.db $2f $8c $2f $02
@sidescrolling:
	.db $00
