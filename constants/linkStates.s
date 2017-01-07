.ENUM 0
	LINK_STATE_00				db
	LINK_STATE_NORMAL			db
	LINK_STATE_RESPAWNING			db ; Does falling, drowning animations
	LINK_STATE_DYING			db
	LINK_STATE_04				db

	; Link jumps into a bed at a set position, regains health, and jumps out.
	; Used only in Nayru's house.
	LINK_STATE_SLEEPING			db

	LINK_STATE_06				db
	LINK_STATE_SPINNING_FROM_GALE		db
	LINK_STATE_08				db

	; State for the cutscene where Ambi is unposessed, Link moves back, then jumps to
	; avoid Veran.
	LINK_STATE_AMBI_UNPOSSESSED_CUTSCENE	db

	; Link is in this state while doing a screen transition.
	LINK_STATE_WARPING			db

	; Forces Link to move in a certain direction for a certain number of frames.
	; Set wLinkForceMovementLength to specify the number of frames he remains in this
	; state.
	LINK_STATE_FORCE_MOVEMENT		db

	; Plays the boss death sound effect?
	LINK_STATE_GRABBED_BY_WALLMASTER	db

	; Grabbed by Gohma (seasons), Veran spider form (ages)?
	LINK_STATE_GRABBED			db

	; This state might be used in Seasons when opening d4?
	LINK_STATE_0e				db

	; Link is being tossed out of the palace by Ambi's guards?
	LINK_STATE_TOSSED_BY_GUARDS		db ; $0f

	LINK_STATE_10				db ; $10

	LINK_STATE_SQUISHED			db ; $11
	LINK_STATE_JUMPING_DOWN_LEDGE		db ; $12

	; Link is a stone until counter1 reaches 0
	LINK_STATE_STONE			db ; $13

	; Link is in his "defeated" pose until counter1 reaches 0
	LINK_STATE_COLLAPSED			db ; $14
.ENDE
