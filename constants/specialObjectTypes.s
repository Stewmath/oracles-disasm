.enum 0

	; $00-$09 occupy vram at $8600
	SPECIALOBJECT_LINK			db ; $00
	SPECIALOBJECT_01			db ; $01
	SPECIALOBJECT_LINK_AS_BABY		db ; $02
	SPECIALOBJECT_LINK_AS_SUBROSIAN	db ; $03
	SPECIALOBJECT_LINK_AS_RETRO		db ; $04
	SPECIALOBJECT_LINK_AS_OCTOROK		db ; $05
	SPECIALOBJECT_LINK_AS_MOBLIN		db ; $06
	SPECIALOBJECT_LINK_AS_LIKELIKE	db ; $07

	; Subid is a "cutscene index":
	;  Ages:
	;   $03: ?
	;   $05: Link simply moves in a set path? Depends on var03:
	;        $00: Just saved the maku sapling, moving toward her
	;        $01: Just freed the goron elder, moving toward him
	;        $02: Moving to start the funny joke cutscene
	;   $06: Pushing triforce stone
	;   $07: Link getting robbed by Tokays
	;  Seasons:
	;   $02: Link unconscious at very start of game
	SPECIALOBJECT_LINK_CUTSCENE		db ; $08

	SPECIALOBJECT_LINK_RIDING_ANIMAL	db ; $09

	; $0a-$13 occupy vram at $8700
	SPECIALOBJECT_MINECART		db ; $0a
	SPECIALOBJECT_RICKY			db ; $0b
	SPECIALOBJECT_DIMITRI			db ; $0c
	SPECIALOBJECT_MOOSH			db ; $0d
	SPECIALOBJECT_MAPLE			db ; $0e

	; "Cutscene" objects for the animal companions + maple in the credits
	SPECIALOBJECT_RICKY_CUTSCENE		db ; $0f
	SPECIALOBJECT_DIMITRI_CUTSCENE	db ; $10
	SPECIALOBJECT_MOOSH_CUTSCENE		db ; $11
	SPECIALOBJECT_MAPLE_CUTSCENE		db ; $12

	SPECIALOBJECT_RAFT			db ; $13

.ende

; These are used when checking for the "range" of special objects that are animal
; companions.
.define SPECIALOBJECT_FIRST_COMPANION SPECIALOBJECT_RICKY
.define SPECIALOBJECT_LAST_COMPANION  SPECIALOBJECT_MOOSH
