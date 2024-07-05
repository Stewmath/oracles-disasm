; This file deals with "smooth palette transitions" between rooms, ie. at the entrance to
; Yoll Graveyard.
;
; Note: although this data has entries for groups 4-7, it only gets checked when
; TILESETFLAG_OUTDOORS is set.
;
; Data format: (differs in seasons)
; b0: direction (or $ff to end)
; b1: room index
; w2: source palette
; w3: destination palette
;
; Note: Byte 0 is the direction Link MOVES INTO the room, not where he ENTERS FROM.


paletteTransitionData:
	dbrel paletteTransitionGroup0
	dbrel paletteTransitionGroup1
	dbrel paletteTransitionGroup2
	dbrel paletteTransitionGroup3
	dbrel paletteTransitionGroup4
	dbrel paletteTransitionGroup5
	dbrel paletteTransitionGroup6
	dbrel paletteTransitionGroup7


paletteTransitionGroup3:
paletteTransitionGroup4:
paletteTransitionGroup5:
paletteTransitionGroup6:
paletteTransitionGroup7:
	.db $ff

paletteTransitionGroup0:
	dbbww DIR_LEFT  $6a  paletteData4a90 paletteData4a30
	dbbww DIR_RIGHT $6b  paletteData4a30 paletteData4a90
	dbbww DIR_LEFT  $7a  paletteData4a90 paletteData4a30
	dbbww DIR_RIGHT $7b  paletteData4a30 paletteData4a90
	dbbww DIR_UP    $8b  paletteData4c10 paletteData4a90
	dbbww DIR_DOWN  $9b  paletteData4a90 paletteData4c10
	dbbww DIR_UP    $12  paletteData4cd0 paletteData4c70
	dbbww DIR_DOWN  $22  paletteData4c70 paletteData4cd0
	dbbww DIR_UP    $14  paletteData4cd0 paletteData4c70
	dbbww DIR_DOWN  $24  paletteData4c70 paletteData4cd0
	dbbww DIR_DOWN  $29  paletteData4d90 paletteData4a30
	dbbww DIR_DOWN  $2a  paletteData4d90 paletteData4a30
	dbbww DIR_DOWN  $3d  paletteData4d90 paletteData4bb0
	.db $ff

paletteTransitionGroup1:
	dbbww DIR_UP    $12  paletteData4d00 paletteData4ca0
	dbbww DIR_DOWN  $22  paletteData4ca0 paletteData4d00
	dbbww DIR_UP    $14  paletteData4d00 paletteData4ca0
	dbbww DIR_DOWN  $24  paletteData4ca0 paletteData4d00
	dbbww DIR_UP    $36  paletteData4a60 paletteData4f40
	dbbww DIR_DOWN  $46  paletteData4f40 paletteData4a60
	.db $ff

paletteTransitionGroup2:
	dbbww DIR_UP    $90  paletteData4eb0 paletteData4e80
	dbbww DIR_DOWN  $a0  paletteData4e80 paletteData4eb0
	.db $ff

