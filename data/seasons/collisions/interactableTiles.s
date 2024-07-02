; The following is a table indicating what should happen when Link is standing right in front of a
; tile of a particular type.
;
; This determines which blocks are pushable. See also data/{game}/collisions/pushableTiles.s for
; more properties of pushable tiles.
;
; Data format:
;
; b0: tile index
; b1:
;    Bits 0-3 (second digit): How to behave when Link is next to this kind of tile.
;        0: Pushable tile
;             bit 7: Set if it's pushable in all directions. Otherwise, bits 4-5 are the direction
;                    it can be pushed in.
;             bit 6: Set if the power bracelet is needed to push it.
;        1: Keyblock
;        2: Key door
;           First digit is 0-3 indicating direction, or 4-7 for boss key doors
;        3: Should show text when pushing against the tile.
;           First digit is an index for which text to show.
;        4: Chest (handle opening)
;        5: Sign (handle reading)
;        6: Overworld keyhole (ie. Yoll Graveyard, Crown Dungeon)
;        7: Does nothing?
;        8: Spawns a ghini when approached. Used in the graveyard in Seasons.

interactableTilesTable:
	.dw @collisions0
	.dw @collisions1
	.dw @collisions2
	.dw @collisions3
	.dw @collisions4
	.dw @collisions5

@collisions0:
	.db $d6 $80
	.db $c0 $03
	.db $c1 $03
	.db $c2 $03
	.db $96 $43
	.db $f1 $04
	.db $f2 $05
	.db $ec $06
	.db $d5 $08
	.db $00

@collisions1:
	.db $f1 $04
	.db $f2 $05
	.db $ec $07
@collisions2:
	.db $00

@collisions3:
@collisions4:
	.db $18 $00
	.db $19 $10
	.db $1a $20
	.db $1b $30
	.db $1c $80
	.db $2a $80
	.db $2c $80
	.db $2d $80
	.db $10 $c0
	.db $11 $c0
	.db $12 $c0
	.db $13 $c0
	.db $25 $80
	.db $2f $80
	.db $1e $01
	.db $70 $02
	.db $71 $12
	.db $72 $22
	.db $73 $32
	.db $74 $42
	.db $75 $52
	.db $76 $62
	.db $77 $72
	.db $1f $13
	.db $30 $23
	.db $31 $23
	.db $32 $23
	.db $33 $23
	.db $08 $33
	.db $f1 $04
	.db $f2 $05
@collisions5:
	.db $00
