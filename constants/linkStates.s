.ENUM 0
	LINK_STATE_00				db ; $00
	LINK_STATE_NORMAL			db ; $01
	LINK_STATE_RESPAWNING			db ; $02: Does falling, drowning animations
	LINK_STATE_DYING			db ; $03

	; Link getting an item?
	; $cc50 is set to 0 for 1-handed animation, 1 for 2-handed animation?
	LINK_STATE_04				db ; $04

	; Link jumps into a bed at a set position, regains health, and jumps out.
	; Used only in Nayru's house.
	LINK_STATE_SLEEPING			db; $05

	LINK_STATE_06				db ; $06
	LINK_STATE_SPINNING_FROM_GALE		db ; $07

	; This is a state where Link's animation is easily manipulated; it can be set by
	; writing to [$cc50].
	; Link stays in this state as long as [wDisabledObjects] is nonzero.
	LINK_STATE_08				db ; $08

	; State for the cutscene where Ambi is unposessed, Link moves back, then jumps to
	; avoid Veran.
	LINK_STATE_AMBI_UNPOSSESSED_CUTSCENE	db ; $09

	; Link is in this state while doing a screen transition.
	LINK_STATE_WARPING			db ; $0a

	; Forces Link to move in a certain direction for a certain number of frames.
	; Set wLinkForceMovementLength to specify the number of frames he remains in this
	; state.
	LINK_STATE_FORCE_MOVEMENT		db ; $0b

	; Plays the boss death sound effect?
	LINK_STATE_GRABBED_BY_WALLMASTER	db ; $0c

	; Grabbed by Gohma (seasons), Veran spider form (ages)?
	LINK_STATE_GRABBED			db ; $0d

	; This state might be used in Seasons when opening d4?
	LINK_STATE_0e				db ; $0e

	; Link is being tossed out of the palace by Ambi's guards?
	LINK_STATE_TOSSED_BY_GUARDS		db ; $0f

	; Used when attempting to approach Onox's castle in Seasons?
	LINK_STATE_10				db ; $10

	LINK_STATE_SQUISHED			db ; $11
	LINK_STATE_JUMPING_DOWN_LEDGE		db ; $12

	; Link is a stone until counter1 reaches 0
	LINK_STATE_STONE			db ; $13

	; Link is in his "defeated" pose until counter1 reaches 0
	LINK_STATE_COLLAPSED			db ; $14
.ENDE
