.STRUCT GfxRegsStruct
	LCDC	db
	SCY	db
	SCX	db
	WINY	db
	WINX	db
	LYC	db
.ENDST
.define GfxRegsStruct.size 6

.STRUCT DeathRespawnStruct
	group		db
	room		db
	stateModifier	db
	facingDir	db
	y		db
	x		db
	rememberedCompanionId		db
	rememberedCompanionGroup	db
	rememberedCompanionRoom		db
	linkObjectIndex			db
	c635				db ; TODO: what is this?
	rememberedCompanionY		db
	rememberedCompanionX		db
.ENDST
.define DeathRespawnStruct.size $0c

.STRUCT FileDisplayStruct
	b0		db ; Bit 7 set if the file is blank
	b1		db
	numHearts	db
	numHeartContainers	db
	deathCountL	db
	deathCountH	db
	b6		db ; Bit 0: linked game
	b7		db ; Bit 0: completed game, 1: hero's file
.ENDST
.define FileDisplayStruct.size 8


.struct EnemyPlacementStruct ; Variables used when placing enemies on the screen

	randomBufferIndex: ; $cec0
		db
	numEnemies: ; $cec1
	; This is the number of enemies that have been placed, and corresponds to the number of
	; entries in wPlacedEnemyPositions.
	; (If this exceeds 15 it loops back to 0.)
		db
	enemyPos: ; $cec2
		db
	cec3: ; $cec3
		db
	cec4: ; $cec4
		db
	cec5: ; $cec5
		db
	cec6: ; $cec6
		db
	cec7: ; $cec7
		db
	cec8: ; $cec8
		db
	killedEnemiesBitset: ; $cec9
	; Bitset for enemies killed on this screen
		db
	numKillableEnemies: ; $ceca
	; The number of enemies on the screen that the game remembers should stay dead
		db
	cecb: ; $cecb
		db
	cecc: ; $cecc
		db
	cecd: ; $cecd
		db
	cece: ; $cece
		db
	randomPlacementAttemptCounter: ; $cecf
		db
	placedEnemyPositions: ; $ced0
	; This could take up 8 bytes or so?
		dsb 8
.endst



; ========================================================================================
; Object structures
; ========================================================================================

; Definitions which can apply to any kind of object
.STRUCT ObjectStruct
	start			.db

	; Enemies: bits 4-6 are the "index" of the enemy on the screen?
	;          (this is used to remember whether it's been killed.)
	; When bits 0-1 == 3, the object persists across screens? (for interactions at
	; least)
	enabled			db ; $00

	id			db ; $01
	subid			db ; $02
	var03			db ; $03

	; Enemy states below $08 behave differently? (See constants/enemyStates.s)
	state			db ; $04

	state2			db ; $05
	counter1		db ; $06
	counter2		db ; $07

	; A value from 0-3. See constants/directions.s.
	; This is sometimes treated as an animation index which could go beyond those
	; values? (Particularly for enemies?)
	direction		db ; $08

	; An angle is a value from $00-$1f. Determines which way the object moves.
	;  $00 = up
	;  $08 = right
	;  $10 = down
	;  $18 = left
	; And it can take any value in-between.
	angle			db ; $09

	y			db ; $0a
	yh			db ; $0b
	x			db ; $0c
	xh			db ; $0d
	z			db ; $0e
	zh			db ; $0f

	; There are two ways to handle speed: the most common is for there to be a single
	; byte value in the "speed" variable that gets combined with "angle", then call
	; the "objectApplySpeed" function.
	; The other way is for speedY and speedX to be set to specific values, and then to
	; use the "objectApplyComponentSpeed" function. This allows the two speed
	; components to be controlled separately.
	; Note that they use the same memory, so only one of these systems can be used.
	.union
		speedY		dw ; $10
		speedX		dw ; $12
	.nextu
		speed		db ; $10
		speedTmp	db ; $11
	.endu

	speedZ			dw ; $14
	relatedObj1		dw ; $16
	relatedObj2		dw ; $18

	; Bit 7 of visible tells if it's visible, bits 0-1 determine its priority, bit
	; 6 is set if the object has terrain effects (shadow, puddle/grass animation)
	; Bits 0-2 are "priority" (lower priority = drawn on top of more sprites)
	visible			db ; $1a

	; oamFlagsBackup generally never changes, so it's used to remember what flags the
	; object should have "normally" (ie. when it's not flashing from damage).
	oamFlagsBackup		db ; $1b
	oamFlags		db ; $1c

	oamTileIndexBase	db ; $1d
	oamDataAddress		dw ; $1e
	animCounter		db ; $20
	animParameter		db ; $21
	animPointer		dw ; $22
	collisionType		db ; $24: bit 7: set to enable collisions (for Enemies, Parts)
	enemyCollisionMode	db ; $25
	collisionRadiusY	db ; $26
	collisionRadiusX	db ; $27
	damage			db ; $28
	health			db ; $29

	; Enemy/part: on collision with an item, this is set to the "collisionType" value.
	; Bit 7 is set if the collision "just occurred"? All enemies have code that resets
	; bit 7 just after their main code is called, meaning it will happen at most once
	; per collision.
	var2a			db ; $2a

	; When this is $00-$7f, this counts down and the object flashes red.
	; When this is $80-$ff, this counts up and the object is just invincible.
	invincibilityCounter	db ; $2b

	knockbackAngle		db ; $2c

	; Enemies: if bit 7 is set, "dust" is created as they get knocked back?
	knockbackCounter	db ; $2d

	stunCounter		db ; $2e: if nonzero, enemies / parts don't damage link

	; This seems to frequently be used for "communication" between different objects?
	; (A bit is set as a sort of status signal.)
	var2f			db ; $2f

	var30			db ; $30

	pressedAButton		.db ; $31
	var31			db ; $31

	var32			db ; $32
	var33			db ; $33
	var34			db ; $34
	var35			db ; $35
	var36			db ; $36
	var37			db ; $37
	var38			db ; $38
	var39			db ; $39
	var3a			db ; $3a
	var3b			db ; $3b

	var3c			db ; $3c

	; Enemy: Counter used when scent seeds are active?
	var3d			db ; $3d

	; Enemy/part: on collision with Link/item, var3e is written to collidee's var2a
	var3e			db ; $3e

	; Enemies:
	;   Bit 7: if set, it disappears instantly when killed instead of dying in a puff
	;          of smoke?
	;   Bit 5: ? (Used by buzzblobs, podoboo towers, cuccos, color changing gels,
	;             veran possession boss?)
	;   Bit 4: if set, the enemy moves toward scent seeds?
	;   Bit 1: affects how an enemy behaves when it has no health?
	;   Bits 0-3: Nonzero when the enemy has touched a hazard. Corresponds to entries
	;             in hazardCollisionTable:
	;             Bit 3: Unused?
	;             Bit 2: Lava
	;             Bit 1: Hole
	;             Bit 0: Water
	var3f			db ; $3f
.ENDST

; Special objects like link, companions (and sometimes "parent items").
.STRUCT SpecialObjectStruct
	start			.db

	; Companion: bit 1 set when Link is riding it?
	enabled			db ; $00

	id			db ; $01
	subid			db ; $02
	var03			db ; $03
	state			db ; $04
	state2			db ; $05

	; Link's counter1 is used for:
	;  - Movement with flippers
	;  - Recovering from stone & collapsed states
	counter1		db ; $06

	; Link's counter2 is used for:
	; - Creating bubbles in sidescrolling underwater areas
	; - Diving underwater
	counter2		db ; $07

	direction		db ; $08
	angle			db ; $09
	y			db ; $0a
	yh			db ; $0b
	x			db ; $0c
	xh			db ; $0d
	z			db ; $0e
	zh			db ; $0f
	speed			db ; $10
	speedTmp		db ; $11

	; This might be another speed variable?
	var12			db ; $12

	var13			db ; $13
	speedZ			dw ; $14
	relatedObj1		dw ; $16

	; relatedObj2 uses for link:
	; - switch hook
	; - shop items (held items in general?)
	; Maple: instead of pointing to an object, this is a pointer to data that says
	;        what her next position in her "route" should be.
	relatedObj2		dw ; $18

	visible			db ; $1a
	oamFlagsBackup		db ; $1b
	oamFlags		db ; $1c
	oamTileIndexBase	db ; $1d
	oamDataAddress		db ; $1e
	var1f			db ; $1f
	animCounter		db ; $20
	animParameter		db ; $21
	animPointer		dw ; $22
	collisionType		db ; $24
	damageToApply		db ; $25
	collisionRadiusY	db ; $26
	collisionRadiusX	db ; $27
	damage			db ; $28

	; Link uses this "health" variable instead as a sort of "damage reduction"
	; variable; this is probably so that damage that would be 1/8th of a heart rounds
	; down instead of up.
	health			db ; $29

	var2a			db ; $2a

	invincibilityCounter	db ; $2b
	knockbackAngle		db ; $2c
	knockbackCounter	db ; $2d
	stunCounter		db ; $2e

	; Link:
	;   Bit 7 set if in an underwater map
	;   Bit 6 set if wearing the mermaid suit? (even on land)
	;   Bit 0 set if jumping down a ledge where a screen transition will occur
	var2f			db ; $2f

	animMode		db ; $30

	; "Base" for frame index, not accounting for direction. Also used by parent items.
	; This value comes directly from the animation (specialObjectAnimationData.s).
	var31			db ; $31

	; Frame index, accounting for direction.
	var32			db ; $32

	; For link/companion, this has certain bits set depending on where walls are on
	; any side of him?
	; Bit:
	;   0: right-down
	;   1: right-up
	;   2: left-down
	;   3: left-up
	;   4: down-left
	;   5: down-right
	;   6: up-right
	;   7: up-left
	adjacentWallsBitset	db ; $33

	; Bit 4 set if Link is pushing against a wall?
	var34			db ; $34

	; Link: keeps track of when you press "A" to swim faster in water (for flippers).
	;       $00 normally, $01 when speeding up, $02 when speeding down.
	; Ricky: counter for tornado punch charge (ready when it reaches $1e)
	; Dimitri: set to $01 when his "eating" attack swallows something.
	var35			db ; $35

	; Link: this is an index for a table in the updateLinkSpeed function?
	; Ricky: this stores the tile 2 spaces away, to see if Ricky can land on it?
	var36			db ; $36

	; Companion: $0d if on a hole, $0e if in water? (correspond to animation indices?)
	var37			db ; $37

	; Companion: gets added to animation index?
	; Dimitri: if nonzero, he's in water?
	var38			db ; $38

	; Ricky: acts as a counter until he can jump again
	; Dimitri: var39/var3a are Y/X positions for him to move to when he's in water
	;          without being mounted.
	; Moosh: number of frames to ignore gravity (set to 8 each time he flutters)
	var39			db ; $39

	; Dimitri: see above
	; Moosh: the number of times he has fluttered in the air (maximum is $10)
	var3a			db ; $3a

	; Dimitri: ?
	; Moosh: counter for how long A has been held
	var3b			db ; $3b

	; Companion: when nonzero, wWarpsDisabled gets set?
	var3c			db ; $3c

	; Companion: used as "pressedAButton" checker
	var3d			db ; $3d

	; Raft: angle at which Link dismounts
	var3e			db ; $3e

	; Link / parent items: "priority" value; when choosing which frame to load for
	;                      Link, the game takes the parentItem with the highest
	;                      "var3f" value, and uses its "var31" value as the frame
	;                      index (not accounting for facing direction).
	; Raft: counter for # of frames Link's pressing against the shore to dismount
	; Maple: vehicle?
	var3f			db ; $3f
.ENDST

; Note: "Parent items" should probably be classed as "SpecialObjects" and not "Items", but
; the majority of the variables are the same anyway.

.STRUCT ItemStruct
	start			.db
	; For parent items, this also represents the item's priority (versus other items).
	; Bits 4-7 are set initially, but bits 0-3 can be set for this purpose as well?
	enabled			db ; $00

	id			db ; $01
	subid			db ; $02

	; Parent items: this is the bitmask of the button pressed.
	;   Gets updated when you first use it, and when closing a menu (in case the button
	;   assignment changes)
	; Throwable items: Sets the animation that will play on breakage.
	;   bits 0-3 are the main byte of the ID ($0-$f) (ie. INTERACID_GRASSDEBRIS)
	;   bit 4 controls whether to flicker (bit 0 of the subid).
	var03			db ; $03

	state			db ; $04

	; For items, this is used as a "being held" state.
	; $00: Just picked up?
	; $01: Being held
	; $02: Just released?
	; $03: Not being held
	state2			db ; $05

	counter1		db ; $06

	; For interactions that use scripts, while counter2 is nonzero, the object moves
	; based on its angle and speed instead of running the script.
	counter2		db ; $07

	direction		db ; $08
	angle			db ; $09
	y			db ; $0a
	yh			db ; $0b
	x			db ; $0c
	xh			db ; $0d
	z			db ; $0e
	zh			db ; $0f
	speed			db ; $10
	speedTmp		db ; $11
	var12			db ; $12
	var13			db ; $13
	speedZ			dw ; $14
	relatedObj1		dw ; $16

	; Uses for relatedObj2:
	; - Bombchus: the target to attack (after being verified as valid)
	relatedObj2		dw ; $18

	visible			db ; $1a
	oamFlagsBackup		db ; $1b
	oamFlags		db ; $1c
	oamTileIndexBase	db ; $1d
	oamDataAddress		db ; $1e
	var1f			db ; $1f
	animCounter		db ; $20
	animParameter		db ; $21
	animPointer		dw ; $22
	collisionType		db ; $24
	damageToApply		db ; $25
	collisionRadiusY	db ; $26
	collisionRadiusX	db ; $27
	damage			db ; $28
	health			db ; $29
	var2a			db ; $2a
	invincibilityCounter	db ; $2b
	knockbackAngle		db ; $2c
	knockbackCounter	db ; $2d
	stunCounter		db ; $2e

	; Bombs:
	;  Bit 7: Resets animation? (used by maple)
	;  Bit 6: Set while being held, thrown, or exploding?
	;  Bit 5: Deletes the bomb? (used by maple, head thwomp)
	;  Bit 4: Triggers explosion?
	;
	; ITEMID_18:
	;  Bit 5: Delete self due to another somaria block appearing?
	;  Bit 4: If set, no "poof" is created on destruction?
	;  Bit 0: Set when Link pushes on the block
	;
	; In general bit 5 is set to request that the item be deleted?
	var2f			db ; $2f

	; Bombchus: use this to cycle through enemy target candidates
	; Swingable items: animation index?
	var30			db ; $30

	; Bombchus: this is the direction to turn if it reaches an impassable barrier
	; while trying to reach its target. Either $08 or $f8.
	; Sword: base damage (not accounting for spin slash or anything)
	; Bombs/scent seeds: var31/var32 are Y/X positions the object is pulled toward.
	var31			db ; $31

	; Bombchus: set to 1 when clinging to a wall in a sidescrolling area
	; ITEMID_18: tile index the block is on
	; Bombs/scent seeds: var31/var32 are Y/X positions the object is pulled toward.
	var32			db ; $32

	; Bombchus: the former "angle" value from before it started climbing a wall. Used
	; to check whether the bombchu is still touching the wall.
	var33			db ; $33

	; Bombchus: set to 1 when hanging upside-down on a ceiling
	; Boomerang: the angle which the boomerang is adjusting toward.
	; Seeds: bounce counter (seed effect triggers when it reaches 0)
	var34			db ; $34

	var35			db ; $35
	var36			db ; $36

	; Bombs:
	;  Bit 7: set after initialized
	;  Bit 6: set when explosion hits Link (to prevent double-hits?)
	; Throwable objects:
	;  Bit 0: set after being thrown
	; Bracelet parent: former tile ID of tile picked up (or 0 if N/A)
	var37			db ; $37

	; Throwable objects: the value of wLinkGrabState2. Affects "weight".
	var38			db ; $38

	; Throwable objects: gravity.
	var39			db ; $39

	; Sword parent item: sets var3a when double-edged ring is in use
	; Physical items have this set the same as the "Item.damage" value on loading.
	;   Sword item: actual damage (accounting for spin slash, but not ring modifiers)
	var3a			db ; $3a

	; Used by throwable items to indicate when an item lands, and what it lands on.
	; Bit 0: Landed on water
	; Bit 1: Landed on hole
	; Bit 2: Landed on lava
	; Bit 3: Unused?
	; Bit 4: Landed
	; Bit 5: Unused?
	; Bit 6: Set when the item enters or leaves water (that is, when bit 0 changes)
	; Bit 7: Flips every frame the item is on the ground?
	; See the _itemUpdateThrowing (07:4aa5) function.
	var3b			db ; $3b

	; Projectiles: current tile position
	var3c			db ; $3c

	; Projectiles: current tile index
	var3d			db ; $3d

	; Projectiles: the elevation of the item, for passing through cliff tiles
	var3e			db ; $3e

	var3f			db ; $3f
.ENDST

; Interactions (npcs, etc)
.STRUCT InteractionStruct
	start			.db

	; Certain interactions delete themselves when (enabled&3) == 2?
	; Bit 7: if set, this interaction _always_ updates, even when scrolling, when
	; textboxes are up, and when bit 1 of wActiveObjects is set.
	enabled			db ; $00

	id			db ; $01
	subid			db ; $02
	var03			db ; $03
	state			db ; $04
	state2			db ; $05
	; counter1 is used by the checkabutton command among others. checkabutton
	; doesn't activate until it reaches zero.
	counter1		db ; $06
	counter2		db ; $07
	direction		db ; $08
	angle			db ; $09
	y			db ; $0a
	yh			db ; $0b
	x			db ; $0c
	xh			db ; $0d
	z			db ; $0e
	zh			db ; $0f

	; See note in ObjectStruct about when speedY/X are used (they're normally not).
	speedY			.dw ; $10
	speed			db ; $10
	speedTmp		db ; $11

	speedX			dw ; $12

	speedZ			dw ; $14
	relatedObj1		dw ; $16

	relatedObj2		.dw ; $18: Sometimes used as "scriptPtr" instead
	scriptPtr		.dw
	var18			db
	var19			db

	visible			db ; $1a
	oamFlagsBackup		db ; $1b
	oamFlags		db ; $1c
	oamTileIndexBase	db ; $1d
	oamDataAddress		dw ; $1e
	animCounter		db ; $20
	animParameter		db ; $21
	animPointer		dw ; $22
	collisionType		db ; $24
	enemyCollisionMode	db ; $25
	collisionRadiusY	db ; $26
	collisionRadiusX	db ; $27
	damage			db ; $28
	health			db ; $29
	var2a			db ; $2a

	; For interactions, this is a counter used in "npcAnimate_followLink" to set
	; a minimum amount of time before the npc changes facing directions.
	invincibilityCounter	db ; $2b

	; This does something different for interactions?
	knockbackAngle		db ; $2c

	knockbackCounter	db ; $2d
	stunCounter		db ; $2e
	var2f			db ; $2f

	; If nonzero, Interaction.textID+1 ($33) replaces whatever upper byte you use in a showText opcode.
	useTextID		.db ; $30
	var30			db

	pressedAButton		.db ; $31
	var31			db

	textID			.dw ; $32
	var32			db
	var33			db ; $33

	var34			db ; $34

	scriptRet		.dw ; $35
	var35			db
	var36			db ; $36

	; For npcs, this is the animation index for "facing up", and the next 3 are for
	; the other facing directions.
	var37			db ; $37

	; Used by ring treasures to override which ring is given
	var38			db ; $38

	; For some npcs, when var39 is nonzero, their animations don't update.
	var39			db ; $39

	var3a			db ; $3a

	; Objects use this if they have an INTERACID_ACCESSORY; accessory deletes itself
	; when this is nonzero.
	var3b			db ; $3b

	var3c			db ; $3c
	var3d			db ; $3d
	var3e			db ; $3e
	var3f			db ; $3f
.ENDST

.define w1Link.warpVar1 $d005
.define w1Link.warpVar2 $d006


.enum $00
	Object		instanceof ObjectStruct
.ende

.enum $00
	SpecialObject	instanceof SpecialObjectStruct
.ende

.enum $00
	Item		instanceof ItemStruct
.ende

.enum $40
	Interaction	instanceof InteractionStruct
.ende

; Enemys/Parts not unique enough to need their own sets of variables (yet)
.enum $80
	Enemy		instanceof ObjectStruct
.ende

.enum $c0
	Part		instanceof ObjectStruct
.ende
