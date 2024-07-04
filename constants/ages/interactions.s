; Ages-specific interaction objects.
;
; See constants/common/interactions.s for documentation.


;;
; Controls the red/yellow/blue floor tiles that toggle when jumped over.
;
; @subid_00{"Parent" interaction; constantly checks Link's position and spawns subid1 when
;           appropriate.}
; @subid_01{Toggles tile at position [var03] when Link lands, then deletes itself.}
.define INTERAC_TOGGLE_FLOOR $15

;;
; For torch puzzles.
;
; Subid: initial orientation of cube (0-5)
;
; @palette{PALH_89}
.define INTERAC_COLORED_CUBE $19

;;
; A flame that appears when the colored cube is put in the right place.
.define INTERAC_COLORED_CUBE_FLAME $1a

;;
; Subid bits 0-2:\n
;   Index of bit in wSwitchState which controls the gate.
;
; Subid bits 4-7:\n
;   0: barrier extends left.\n
;   2: barrier extends right.
.define INTERAC_MINECART_GATE $1b

.define INTERAC_STUB_1d $1d

;;
; @subid_00{Trigger a warp when Link dives here. (X should be 0 or 1, indicating where
;       to warp to, while Y is the short-form position.)}
; @subid_01{Trigger a warp at the top of a waterfall (only if riding dimitri)}
; @subid_02{Trigger a warp in a cave in a waterfall (only if riding Dimitri)}
.define INTERAC_SPECIAL_WARP $1f

;;
; Runs assembly code for specific dungeon events. Similar in purpose to INTERAC_MISC_PUZZLES?
;
; @subid_00{Nothing}
; @subid_01{d2: verify a 2x2 floor pattern, drop a key.}
; @subid_02{d2: verify that a floor tile is red to open a door.}
; @subid_03{Light torches when a colored cube rolls into this position.}
; @subid_04{d2: Set torch color based on the color of the tile at this position.}
; @subid_05{d2: Drop a small key here when a colored block puzzle has been solved.}
; @subid_06{d2: Set trigger 0 when the colored flames are lit red.}
; @subid_07{Toggle a bit in wSwitchState based on whether a toggleable floor tile at
;        position Y is blue. The bitmask to use is X.}
; @subid_08{Toggle a bit in wSwitchState based on whether blue flames are lit. The bitmask
;        to use is X.}
; @subid_09{d3: Drop a small key when 3 blocks have been pushed.}
; @subid_0a{d3: When an orb is hit, spawn an armos, as well as interaction which will spawn
;            a chest when it's killed.}
; @subid_0b{Unused? A chest appears when 4 torches in a diamond formation are lit?}
; @subid_0c{d3: 4 armos spawn when trigger 0 is activated.}
; @subid_0d{d3: Crystal breakage handler}
; @subid_0e{d3: Small key falls when a block is pushed into place}
; @subid_0f{d4: A door opens when a certain floor pattern is achieved}
; @subid_10{d4: A small key falls when a certain froor pattern is achieved}
; @subid_11{Tile-filling puzzle: when all the blue turns red, a chest will spawn here.}
; @subid_12{d4: A chest spawns here when the torches light up with the color blue.}
; @subid_13{d5: A chest spawns here when all the spaces around the owl statue are filled.}
; @subid_14{d5: A chest spawns here when two blocks are pushed to the right places}
; @subid_15{d5: Cane of Somaria chest spawns here when blocks are pushed into a pattern}
; @subid_16{d5: Sets floor tiles to show a pattern when a switch is held down.}
; @subid_17{Create a chest at position Y which appears when [wActiveTriggers] == X, but which
;        also disappears when the trigger is released.}
; @subid_18{d3: Calculate the value for [wSwitchState] based on which crystals are broken.}
; @subid_19{d1: Set trigger 0 when the colored flames are lit blue.}
.define INTERAC_DUNGEON_EVENTS $21

;;
; When a tile at this position is jumped over, all colored floor tiles in the room change
; colors.
;
; @subid_00{The "controller"}
; @subid_01{Instance that's spawned by the controller to perform the replacement.}
.define INTERAC_FLOOR_COLOR_CHANGER $22

;;
; Extends or retracts a bridge when a bit in wSwitchState changes.
;
; Subid: bits 0-2: bit in wSwitchState to watch
;
; @Y{YX position}
; @X{Index of bridge data}
; @postype{short}
.define INTERAC_EXTENDABLE_BRIDGE $23

;;
; Controls a bit in wActiveTriggers based on various things.
;
; Subid bits 0-3:\n
;   0: Control a bit in wActiveTriggers based on wToggleBlocksState.\n
;   1: Control a bit in wActiveTriggers based on wSwitchState.\n
;   2: Control a bit in wActiveTriggers based on if [wNumLitTorches] == Y.
;
; Subid bits 4-7: Index of a bit to check in wToggleBlocksState or wSwitchState (subids 0 and
;                 1 only)
;
; @Y{Number of torches to be lit (subid 2 only)}
; @X{a bitmask for wActiveTriggers (subid 2 only)}
.define INTERAC_TRIGGER_TRANSLATOR $24

;;
; Keeps track of the yellow tile in the tile-filling puzzles and updates the floor color.
; Starting position is determined by Y and X.
;
; To complete the tile-filling puzzle, an interaction with id $2111 should also exist;
; that will spawn the chest.
.define INTERAC_TILE_FILLER $25

.define INTERAC_STUB_26 $26
.define INTERAC_STUB_27 $27

;;
; subid does nothing.
.define INTERAC_ADLAR $29

;;
; Librarian at eyeglasses library.
; subid does nothing.
.define INTERAC_LIBRARIAN $2a

;;
; The wallmaster used in black tower escape cutscene?
.define INTERAC_VERAN_CUTSCENE_WALLMASTER $2c

;;
; Veran's face used in cutscene just before final battle
; @palette{PALH_87}
.define INTERAC_VERAN_CUTSCENE_FACE $2d

;;
; Old man who gives or takes money. His position is hardcoded. Uses room flag $40.
;
; Subid: 0 gives 200 rupees, 1 takes 100 rupees.
.define INTERAC_OLD_MAN_WITH_RUPEES $2e

;;
; Plays MUS_NAYRU and lowers volume if GLOBALFLAG_INTRO_DONE is not set.
.define INTERAC_PLAY_NAYRU_MUSIC $2f

;;
; @subid_00{Human npc}
; @subid_01{Goron npc}
; @subid_02{Elder npc (biggoron's sword minigame)}
; @subid_03{Controls the game itself}
.define INTERAC_SHOOTING_GALLERY $30

;;
; @subid_00{First meet at the start of the game}
; @subid_01{Talking after nayru is kidnapped}
; @subid_02{Credits cutscene}
; @subid_03{Saved Zelda cutscene?}
; @subid_04{Cutscene at black tower entrance where Impa warns about Ralph's heritage}
; @subid_05{Like subid 4, but for linked game}
; @subid_06{?}
; @subid_07{Tells you that Zelda's been kidnapped by vire}
; @subid_08{During Zelda kidnapped event}
; @subid_09{Tells you that Zelda's been kidnapped by twinrova}
; @subid_0a{? (doesn't have a script)}
.define INTERAC_IMPA_IN_CUTSCENE $31

;;
; A fake octorok.
; @subid_00{Octorok attacking impa. (var03 is a value from 0-2 for the index.)}
; @subid_02{Great fairy turned into an octorok.}
.define INTERAC_FAKE_OCTOROK $32

;;
; Not really the boss itself, but this basically "runs" the fight?
;
; Subid: this should be $ff; it's incremented each time an enemy is spawned to keep track
;        of the enemy index to spawn next.
.define INTERAC_SMOG_BOSS $33

;;
; The stone that's pushed at the start of the game. After it's moved, this stone is
; handled by PART_TRIFOCE_STONE instead.
.define INTERAC_TRIFORCE_STONE $34

;;
; @subid_00{Cutscene at the beginning of game (talking to Link, then gets possessed)}
; @subid_01{Cutscene in Ambi's palace after getting bombs}
; @subid_02{Cutscene on maku tree screen after being saved}
; @subid_03{Cutscene with Nayru and Ralph when Link exits the black tower}
; @subid_04{Cutscene at end of game with Ambi and her guards}
; @subid_05{?}
; @subid_06{?}
; @subid_07{Cutscene with the vision of Nayru teaching you Tune of Echoes}
; @subid_08{Cutscene after saving Zelda?}
; @subid_09{Cutscene where Ralph's heritage is revealed (unlinked?)}
; @subid_0a{Cutscene where Ralph's heritage is revealed (linked?)}
; @subid_0b{NPC after being saved}
; @subid_0c{NPC between being told about Ralph's heritage and beating Veran (linked?)}
; @subid_0d{NPC after Veran is beaten (linked)}
; @subid_0e{?}
; @subid_0f{NPC after getting maku seed, but before being told about Ralph's heritage}
; @subid_10{Cutscene in black tower where Nayru/Ralph meet you to try to escape}
; @subid_11{Cutscene on white background with Din just before facing Twinrova}
; @subid_12{?}
; @subid_13{NPC after completing game (singing to animals)}
.define INTERAC_NAYRU $36

;;
; @subid_00{Cutscene where Nayru gets possessed}
; @subid_01{Cutscene outside Ambi's palace before getting mystery seeds}
; @subid_02{Cutscene after Nayru is possessed}
; @subid_03{Cutscene after talking to Rafton}
; @subid_04{Cutscene on maku tree screen after saving Nayru}
; @subid_05{Cutscene in black tower where Nayru/Ralph meet you to try to escape}
; @subid_06{Cutscene at end of game with Ambi and her guards "confronting" Link}
; @subid_07{Cutscene postgame where they warp to the maku tree, Ralph notices the statue}
; @subid_08{Cutscene in credits where Ralph is training with his sword}
; @subid_09{Cutscene where Ralph charges in to Ambi's palace}
; @subid_0a{Cutscene where Ralph's about to charge into the black tower}
; @subid_0b{Cutscene where Ralph tells you about getting Tune of Currents}
; @subid_0c{Cutscene where Ralph confronts Ambi in black tower}
; @subid_0d{Cutscene where Ralph goes back in time}
; @subid_0e{Cutscene with Nayru and Ralph when Link exits the black tower}
; @subid_0f{Does nothing but stand there, facing right}
; @subid_10{Cutscene after talking to Cheval}
; @subid_11{NPC after finishing the game}
; @subid_12{NPC after beating Veran, before beating Twinrova in a linked game}
.define INTERAC_RALPH $37

;;
; Subid: only $00 is valid
.define INTERAC_PAST_GIRL $38

;;
; @subid_00{Listening to Nayru sing at beginning of game}
; @subid_01{Monkey disappearance cutscene (spawns multiple monkeys; var03 is monkey index)}
; @subid_02{Monkey that only exists before intro}
; @subid_03{Monkey that only exists before intro}
; @subid_04{?}
; @subid_05{Spawns more monkeys}
; @subid_06{?}
; @subid_07{A monkey npc depending on var03: \n
;      0: Appears between saving Nayru and beating game \n
;      1: Listening to Nayru after beating game \n
;      2: Appears between saving Maku tree and beating game}
.define INTERAC_MONKEY $39

;;
; This guy's appearance changes based on his subid. Has "present" and "past" versions, and
; can also be a "construction worker" in the black tower?
;
; @subid_00{Cutscene where guy is struck by lightning in intro}
; @subid_01{Past villager?}
; @subid_02{Guard blocking entrance to black tower}
; @subid_03{Guy in front of present maku tree screen}
; @subid_04{"Sidekick" to the comedian guy}
; @subid_05{Guy in front of shop}
; @subid_06{Villager in front of past maku tree screen}
; @subid_07{Villager in past near Ambi's palace}
; @subid_08{Villager outside house hear black tower}
; @subid_09{Villager who turns to stone in a cutscene?}
; @subid_0a{Villager turned to stone?}
; @subid_0b{Villager being restored from stone, resumes playing catch}
; @subid_0c{Villager playing catch with son}
; @subid_0d{Cutscene when you first enter the past}
; @subid_0e{Stone villager - during Zelda kidnapped event}
.define INTERAC_MALE_VILLAGER $3a

;;
; Like male villager, this person's appearance changes based on subid, with present and
; past versions.
;
; @subid_00{Cutscene where guy is struck by lightning in intro}
; @subid_01{Present NPC near black tower}
; @subid_02{Present NPC outside shop}
; @subid_03{Past NPC south of shooting gallery screen}
; @subid_04{Past NPC just outside black tower}
; @subid_05{Past villager}
; @subid_06{Linked game NPC}
; @subid_07{NPC in eyeglasses library (present)}
; @subid_08{Present NPC in the house above the ocean}
.define INTERAC_FEMALE_VILLAGER $3b

;;
; @subid_00{Listening to Nayru sing in intro}
; @subid_01{Kid turning to stone cutscene}
; @subid_02{Kid outside shop}
; @subid_03{Cutscene where kids talk about how they're scared of a ghost (red kid)}
; @subid_04{Cutscene where kids talk about how they're scared of a ghost (green kid)}
; @subid_05{Cutscene where kid is restored from stone}
; @subid_06{Cutscene where kid sees his dad turn to stone}
; @subid_07{Depressed kid in trade sequence}
; @subid_08{Kid who runs around in a pattern? Used in a credits cutscene maybe?}
; @subid_09{Same as $08, but different pattern.}
; @subid_0a{Cutscene?}
; @subid_0b{NPC in eyeglasses library present}
; @subid_0c{Cutscene where kid's dad gets restored from stone}
; @subid_0d{Kid with grandma who's either stone or was restored from stone}
; @subid_0e{NPC playing catch with dad, or standing next to his stone dad}
; @subid_0f{Cutscene where kid runs away - during Zelda kidnapped event}
; @subid_10{Listening to Nayru sing in endgame}
.define INTERAC_BOY $3c

;;
; Old lady in the present.
;
; @subid_00{NPC with a grandson that is stone for part of the game}
; @subid_01{Cutscene where her grandson gets turned to stone}
; @subid_02{NPC in present, screen left from bipin&blossom's house}
; @subid_03{Cutscene where her grandson is restored from stone}
; @subid_04{Linked game NPC (clock shop secret)}
; @subid_05{Linked game NPC (ruul secret)}
.define INTERAC_OLD_LADY $3d

;;
; @subid_00{Cutscene at start of game (unpossessing Impa)}
; @subid_01{Cutscene just before fighting possessed Ambi}
; @subid_02{Cutscene just after fighting possessed Ambi}
.define INTERAC_GHOST_VERAN $3e

;;
; Boy with sort of hostile-looking eyes?
;
; @subid_00{Boy in deku forest; appears only before getting bombs}
; @subid_01{Boy at top-left of Lynna city; only appears between beating d7 and getting maku sed}
; @subid_02{Boy in cutscene near spirit's grave}
; @subid_03{Used in linked game credits maybe?}
.define INTERAC_BOY_2 $3f

;;
; @subid_00{?}
; @subid_01{?}
; @subid_02{Left palace guard}
; @subid_03{?}
; @subid_04{?}
; @subid_05{Guard escorting Link in intermediate screens (just moves straight up)}
; @subid_06{Guard in cutscene who takes mystery seeds from Link}
; @subid_07{Guard just after Link is escorted out of the palace}
; @subid_08{Used in a cutscene? (doesn't do anything)}
; @subid_09{Right palace guard}
; @subid_0a{Red soldier that brings you to Ambi (escorts you from deku forest)}
; @subid_0b{Red soldier that brings you to Ambi (just standing there after escorting you)}
; @subid_0c{?}
; @subid_0d{Friendly soldier after finishing game. var03 is soldier index.}
.define INTERAC_SOLDIER $40

;;
; @subid_00{Guy standing outside d2 (before you get bombs)}
; @subid_01-05{Old man who hangs out around lynna city. Each subid is for a different phase
;          in the game, all mutually exclusive)}
.define INTERAC_MISC_MAN $41

;;
; @subid_00{Guy telling you about there being seeds in the woods}
; @subid_01{Guy in past telling you about how his island drifts}
.define INTERAC_MUSTACHE_MAN $42

;;
; @subid_00{Guy who wants to find something Ambi desires}
; @subid_01-02{Some NPC (same guy, but different locations for different game stages)}
; @subid_03{Guy in a cutscene (turning to stone?)}
; @subid_04{Guy in a cutscene (stuck as stone?)}
; @subid_05{Guy in a cutscene (being restored from stone?)}
; @subid_06{Guy watching family play catch (or is stone)}
; @subid_07{Guy turned to stone - during Zelda kidnapped event}
.define INTERAC_PAST_GUY $43

;;
; @subid_00{NPC giving hint about what ambi wants}
; @subid_01{NPC in start-of-game cutscene who turns into an old man}
; @subid_02-03{Bearded NPC in Lynna City}
; @subid_04{Bearded hobo in the past, outside shooting gallery}
.define INTERAC_MISC_MAN_2 $44

;;
; @subid_00{Old lady whose husband was sent to work on black tower}
; @subid_01{Old lady hanging around lynna village}
.define INTERAC_PAST_OLD_LADY $45

;;
; @subid_00-04{Tokays in cutscene who steal your stuff}
; @subid_05{NPC who trades meat for stink bag}
; @subid_06{Past NPC holding sword}
; @subid_07{Past NPC holding shovel}
; @subid_08{Past NPC holding harp}
; @subid_09{Past NPC holding flippers}
; @subid_0a{Past NPC holding seed satchel}
; @subid_0b{Linked game cutscene where tokay runs away from Rosa}
; @subid_0c{Participant in Wild Tokay game}
; @subid_0d{Past NPC in charge of wild tokay game}
; @subid_0e{Shopkeeper (trades items)}
; @subid_0f-10{Tokays who try to eat Dimitri}
; @subid_11{Past NPC looking after scent seedling}
; @subid_12{Present NPC outside museum}
; @subid_13{Present NPC below time portal}
; @subid_14{Present NPC outside cook's hut}
; @subid_15{Past NPC outside trading hut}
; @subid_16{Past NPC outside wild tokay game}
; @subid_17{Past NPC standing next to time portal}
; @subid_18{Past NPC on southeast shore}
; @subid_19{Present NPC in charge of the wild tokay museum}
; @subid_1a-1c{Tokay "statues" in the wild tokay museum}
; @subid_1d{NPC holding shield upgrade}
; @subid_1e{Present NPC who talks to you after climbing down vine}
; @subid_1f{Past NPC standing on cliff at north shore}
.define INTERAC_TOKAY $48

;;
; @subid_00{Fairy just discovered in their hiding place?}
; @subid_01{Discovered fairy who's now hanging out in "main" forest screen, until you
;   finish the game.}
; @subid_02{Unused?}
; @subid_03{Fairy that leads you to the animal companion in the forest (used on at least
;   3-4 screens, with var03 determining their exact behaviour)}
; @subid_04{Fairies surrounding the companion after being rescued from the forest}
; @subid_05-07{Generic NPC (between completing the maze and entering jabu)}
; @subid_08-0a{Generic NPC (between jabu and finishing the game)}
; @subid_0b{NPC in unlinked game who takes a secret}
; @subid_0c-0d{Generic NPC (after beating game)}
; @subid_0e-10{Generic NPC (while looking for companion trapped in woods)}
.define INTERAC_FOREST_FAIRY $49

;;
; @subid_00{Listening to Nayru at the start of the game}
; @subid_01{Rabbit hopping through screen (cutscene where they turn to stone)
;           If counter1 is nonzero, it will turn to stone once it hits 0.}
; @subid_02{"Controller" for the cutscene where rabbits turn to stone? (spawns subid $01)}
; @subid_03{Rabbit being restored from stone cutscene (gets restored and jumps away)}
; @subid_04{Rabbit being restored from stone cutscene (the one that wasn't stone)}
; @subid_05{Rabbit being restored from stone cutscene (bonks into other bunney)}
; @subid_06{Stone bunny (between jabu and beating the game)}
; @subid_07{Generic NPC waiting around in the spot Nayru used to sing}
.define INTERAC_RABBIT $4b

;;
; Not to be confused with INTERAC_KNOW_IT_ALL_BIRD.
;
; @subid_00{Listening to Nayru at the start of the game}
; @subid_01-03{Different colored birds that do nothing but hop? Used in a cutscene?}
; @subid_04{Bird with Impa when Zelda gets kidnapped}
.define INTERAC_BIRD $4c

;;
; @subid_00{Cutscene where you give mystery seeds to Ambi}
; @subid_01{Cutscene after escaping black tower}
; @subid_02{Credits cutscene where Ambi observes construction of Link statue}
; @subid_03{Cutscene where Ambi does evil stuff atop black tower (after d7)}
; @subid_04{Same cutscene as subid $03 (black tower after d7), but second part}
; @subid_05{Cutscene where Ralph confronts Ambi}
; @subid_06{Cutscene just before fighting possessed Ambi}
; @subid_07{Cutscene where Ambi regains control of herself}
; @subid_08{Cutscene after d3 where you're told Ambi's tower will soon be complete}
; @subid_09{Does nothing?}
; @subid_0a{NPC after Zelda is kidnapped}
.define INTERAC_AMBI $4d

;;
; @subid_00{Subrosian in lynna village (linked only)}
; @subid_01{Subrosian in goron dancing game (while dancing game is active?)}
; @subid_02{Subrosian in goron dancing game (var03 is 0 or 1 for green or red npcs)}
; @subid_03{Linked game NPC telling you the subrosian secret (for bombchus)}
; @subid_04{Linked game NPC telling you the smith secret (for shield upgrade)}
.define INTERAC_SUBROSIAN $4e

;;
; Impa as an npc at various stages in the game. There's also INTERAC_IMPA_IN_CUTSCENE.
;
; @subid_00{Impa in Nayru's house}
; @subid_01{Impa in past (after telling you about Ralph's heritage)}
; @subid_02{Impa after Zelda's been kidnapped}
; @subid_03{Impa after getting the maku seed}
.define INTERAC_IMPA_NPC $4f

;;
.define INTERAC_STUB_50 $50

;;
; The guy who you trade a dumbbell to for a mustache
.define INTERAC_DUMBBELL_MAN $51

;;
; An old man NPC. Note: INTERAC_OLD_MAN_WITH_RUPEES uses the same sprites.
;
; @subid_00{Old man who takes a secret to give you the shield (same spot as subid $02)}
; @subid_01{Old man who gives you book of seals}
; @subid_02{Old man guarding fairy powder in past (same spot as subid $00)}
; @subid_03-06{Generic NPCs in the past library}
.define INTERAC_OLD_MAN $52

;;
; The dog lover.
;
; @subid_00{Only valid subid value}
.define INTERAC_MAMAMU_YAN $53

;;
; Mamamu Yan's dog.
;
; @subid_00{Dog in mamamu's house}
; @subid_01{Dog outside that Link needs to find for a "sidequest". var03 is the map index (0-3).}
.define INTERAC_MAMAMU_DOG $54

;;
; Postman who trades you the stationary for a poe clock.
.define INTERAC_POSTMAN $55

;;
; Worker with a pickaxe.
;
; @subid_00{Worker below Maku Tree screen in past}
; @subid_01{Credits cutscene guy making Link statue?}
; @subid_02{Credits cutscene guy making Link statue?}
; @subid_03{Worker in black tower. Var03 is an index which determines their animation.}
.define INTERAC_PICKAXE_WORKER $57

;;
; Worker with a hardhat.
;
; @subid_00{NPC who gives you the shovel. If var03 is nonzero, he's just a generic guy.}
; @subid_01{Generic NPC. Var03 is 0 or 1; these npcs appear in the early and middle phases
;           of the black tower's construction, respectively.}
; @subid_02{NPC who guards the entrance to the black tower.}
; @subid_03{A patrolling NPC. var03 is a value from 0-4 determining his patrol route and
;           text.}
.define INTERAC_HARDHAT_WORKER $58

;;
; Ghost who starts the trade sequence. Subid does nothing.
;
; Var03: 0 when first encountered; 1 in the tomb; 2 when talking after that.
.define INTERAC_POE $59

;;
; Zora who trades you the broken sword for a guitar.
.define INTERAC_OLD_ZORA $5a

;;
; Trades you the stink bag for the stationary.
.define INTERAC_TOILET_HAND $5b

;;
; Gives you a doggie mask for tasty meat.
.define INTERAC_MASK_SALESMAN $5c

;;
; Red bear who listens to Nayru.
;
; @subid_00{Bear listening to Nayru at start of game.}
; @subid_01{Doesn't do anything, just a decoration?}
; @subid_02{Bear NPC, depending value of var03.
;           var03=0: The bear on screen where Nayru is kidnapped (after that cutscene);
;           also spawns other animals.
;           var03=1: The bear listening to Nayru after the game is complete.}
.define INTERAC_BEAR $5d

;;
; A sword, as used by Ralph. Doesn't have collisions?
;
; The animation is set by [relatedObj1.animParameter]; let this be p. Then, the sword is
; made visible when bit 7 of p is set, and the animation number is (p&0x7f). Effectively,
; this allows an interaction's animation to control both itself and the sword.
;
; var3f: When ([this.var3f]+1)&[relatedObj1.enabled] == 0, this object deletes itself?
.define INTERAC_SWORD $5e

;;
; Not maple syrup, syrup the witch
.define INTERAC_SYRUP $5f

;;
; A lever that Link can pull with the power bracelet.
;
; Bit 0 of subid is 0 to pull downward, 1 to pull upward.
;
; Bits 4-5 of subid indicate the distance to pull the lever.
;   0: 8 pixels, 1: $10 pixels, 2: $20 pixels, 3: $40 pixels.
;
; Bit 6 of subid is the "lever index" (0 or 1). This determines whether it writes to
; wLever1PullDistance or wLever2PullDistance. (Scripts will read from here to give the
; lever its functionality.)
;
; Bit 7 of the subid is set if this is the "extending" part of the lever (you normally
; don't need to worry about this).
;
; var03: ?
.define INTERAC_LEVER $61

;;
; A flower or sprout thing that falls when the maku tree communicates with you.
;
; @subid_00{Present (flowers)}
; @subid_01{Past (sprout things)}
.define INTERAC_MAKU_CONFETTI $62

;;
; An accessory is a sprite attached to another interaction. Like INTERAC_SWORD, it reads
; variables from relatedObj1 to place it relative to its "parent". Subid determines the
; graphic.
;
; @subid_3d{Monkey bow}
; @subid_3f{Ball used by villagers (only in cutscene; when actually used it's
;           INTERAC_BALL)}
; @subid_73{Meat in tokay game}
;
; var03: If zero, accessory is placed 12 pixels above relatedObj1 with draw priority 0.
;        If nonzero, it reads from a hardcoded table with index
;        [relatedObj1.animParameter] to set Y/X offsets, draw priority, and animation.
.define INTERAC_ACCESSORY $63

;;
; Components of the raftwreck cutscene (used by INTERAC_RAFTWRECK_CUTSCENE).
;
; @subid_00{A leaf being blown}
; @subid_01{A rock being blown}
; @subid_02{A monkey being blown}
; @subid_03{Gentle wind with leaves and rocks}
; @subid_04{Harsher wind including a monkey}
; @subid_05{Final 3 lightning strikes}
.define INTERAC_RAFTWRECK_CUTSCENE_HELPER $64

;;
; Gives you the funny joke for the cheesy mustache
.define INTERAC_COMEDIAN $65

;;
; @subid_00{Graceful goron?}
; @subid_01{Goron support dancer; text differs if in the past between linked/unlinked.
;           Var03 ranges from 0-6.}
; @subid_02{A "fake" goron object that manages jumping in the dancing minigame?}
; @subid_03{Cutscene where goron appears after beating d5; the guy who digs a new tunnel.}
; @subid_04{Goron pacing back and forth, worried about elder}
; @subid_05{An NPC in the past cave near the elder? var03 ranges from 0-5.}
; @subid_06{NPC trying to break the elder out of the rock.
;           var03 is $00 for the goron on the left, $01 for the one on the right.}
; @subid_07{Goron trying to break wall down to get at treasure}
; @subid_08{Goron guarding the staircase until you get brother's emblem (both eras)}
; @subid_09{Target carts gorons; var03 = 0 or 1 for gorons on left and right.}
; @subid_0a{Goron who gives you letter of introduction}
; @subid_0b{Goron running the big bang game}
; @subid_0c{Generic npc; text changes based on game state.}
; @subid_0d{Generic npc like subid $0c, but moving left and right.}
; @subid_0e{Generic npc like subid $0c, but naps when Link isn't near.}
; @subid_0f{Linked NPC telling you the biggoron secret.}
; @subid_10{Clairvoyant goron who gives you tips.}
.define INTERAC_GORON $66

;;
; Spawns companions in various situations.
; For subids other than $80, this is accompanied by an instance of INTERAC_COMPANION_SCRIPTS?
;
; @subid_00{Moosh being attacked by ghosts}
; @subid_01{Moosh saying goodbye after getting cheval rope}
; @subid_02{Ricky looking for gloves}
; @subid_03{Dimitri being attacked by hungry tokays}
; @subid_04{Companion lost in forest}
; @subid_05{Cutscene outside forest where you get the flute}
; @subid_80{Flute call for companion}
.define INTERAC_COMPANION_SPAWNER $67

;;
; @subid_00{Gives you the shovel on tokay island, linked only}
; @subid_01{Rosa at goron dance, linked only}
.define INTERAC_ROSA $68


;;
; @subid_00{Rafton in left part of house}
; @subid_01{Rafton in right part of house}
.define INTERAC_RAFTON $69

;;
; @subid_00{Cheval; only valid subid}
.define INTERAC_CHEVAL $6a

;;
; Many miscellaneous things here, categorized by subid. See also INTERAC_MISCELLANEOUS_2.
;
; @subid_00{Handles showing Impa's "Help" text when Link's about to screen transition}
; @subid_01{Spawns nayru, ralph, animals before she's possessed}
; @subid_02{Script for cutscene with Ralph outside Ambi's palace, before getting mystery seeds}
; @subid_03{Seasons troupe member with guitar?}
; @subid_04{Script for cutscene where moblins attack maku sapling}
; @subid_05{Cutscene in intro where lightning strikes a guy}
; @subid_06{Manages cutscene after beating d3}
; @subid_07{A seed satchel that slowly falls toward Link. Unused?}
; @subid_08{Part of the cutscene where tokays steal your stuff?}
; @subid_09{Shovel that Rosa gives to you in linked game}
; @subid_0a{Bomb treasure (in tokay hut)}
; @subid_0b{Cheval rope treasure}
; @subid_0c{Flippers treasure (in cheval's grave)}
; @subid_0d{Blocks that move over when pulling lever to get flippers}
; @subid_0e{Stone statue of Link that appears unconditionally}
; @subid_0f{Switch that opens path to Nuun Highlands}
; @subid_10{Unfinished stone statue of Link in credits cutscene}
; @subid_11{Triggers cutscene after beating Jabu-Jabu}
; @subid_12{Seasons troupe member with tambourine?}
; @subid_13{Goron bomb statue (left)}
; @subid_14{Goron bomb statue (right)}
; @subid_15{Stone statue of Link that appears only after finishing game}
; @subid_16{A flame that appears for [counter1] frames.}
.define INTERAC_MISCELLANEOUS_1 $6b

;;
; Spots where fairies are hiding in the hide-and-seek minigame.
;
; @subid_00{Begins fairy-hiding minigame}
; @subid_01{Hiding spot for fairy}
; @subid_02{Checks for Link leaving hide-and-seek the area}
.define INTERAC_FAIRY_HIDING_MINIGAME $6c

;;
; Possessed version of Nayru/Ambi, or veran's ghost.
;
; @subid_00{Possessed Nayru in ambi's palace, starts boss fight}
; @subid_01{Possessed Ambi? (No code defined for this?)}
; @subid_02{Ghost Veran}
; @palette{PALH_85}
.define INTERAC_POSSESSED_NAYRU $6d

;;
; NPCs for the cutscene where Nayru is freed from her possession.
;
; @subid_00{Nayru waking up after being freed from possession}
; @subid_01{Queen Ambi}
; @subid_02{Ghost Veran}
; @subid_03{Ralph}
; @subid_04{Guards that run into the room (var03 is index of guard)}
; @palette{PALH_85}
.define INTERAC_NAYRU_SAVED_CUTSCENE $6e

;;
.define INTERAC_STUB_6f $6f

;;
; Meat used in "wild tokay" game.
.define INTERAC_WILD_TOKAY_CONTROLLER $70

;;
; Animal companion-related cutscenes
;
; @subid_00{Moosh script while being attacked by ghosts}
; @subid_01{Stop companion from moving above this X-position, unless you have their flute}
; @subid_02{Stop companion from moving below this Y-position, unless you have their flute}
; @subid_03{Ricky script when he loses his gloves}
; @subid_04{Stop companion from moving above this Y-position, unless you have their flute}
; @subid_05{Stop companion from moving below this X-position, unless you have their flute}
; @subid_06{Dimitri script where he leaves Link after bringing him to the mainland}
; @subid_07{Dimitri script where he's harrassed by tokays}
; @subid_08{A fairy appears to tell you about the animal companion in the forest}
; @subid_09{Companion script where they're found in the fairy forest}
; @subid_0a{Script just outside the forest, where you get the flute}
; @subid_0b{Script in first screen of forest, where fairy leads you to the companion}
; @subid_0c{Sets bit 6 of wDimitriState so he disappears from Tokay Island}
; @subid_0d{Companion barrier to Symmetry City, until the tuni nut is restored}
.define INTERAC_COMPANION_SCRIPTS $71

;;
; @subid_00{King moblin / "parent" object for the cutscene}
; @subid_01{Normal moblin}
; @subid_02{Gorons who approach after he leaves (var03 = index)}
.define INTERAC_KING_MOBLIN_DEFEATED $72

;;
; Ghinis harassing Moosh
; @subid_00-02{The 3 ghinis in the cutscene}
.define INTERAC_GHINI_HARASSING_MOOSH $73

;;
; Conditionally creates a treasure object if Ricky's gloves should be available.
.define INTERAC_RICKYS_GLOVE_SPAWNER $74

;;
; @subid_00{link riding horse}
; @subid_01{link on horse neighing}
; @subid_02{cliff that horse stands on in temple shot}
; @subid_03{link on horse (closeup)}
; @subid_04{"sparkle" on closeup of link's face}
; @subid_05{birds}
.define INTERAC_INTRO_SPRITE $75

;;
; When spawned, this opens the gate for the maku sprout.
;
; @subid_00{?}
; @subid_01{Opening the gates}
.define INTERAC_MAKU_GATE_OPENING $76

;;
; A small key attached to an enemy. Due to a bug, this only works if the enemy to be
; attached to is in the first enemy slot. (Fixed in hack-base branch.)
;
; @subid{The enemy ID to attach the small key to}
.define INTERAC_SMALL_KEY_ON_ENEMY $77

;;
; Stone panels on the top floor of the ancient tomb. Opens when bit 7 of wActiveTriggers
; is set. Bit 6 of the room flags indicates they've been opened upon entering the room.
;
; @subid_00{Left panel}
; @subid_01{Right panel}
; @palette{PALH_7e}
.define INTERAC_STONE_PANEL $7b

;;
; This interaction is created when "sent back by a strange force". It makes the entire
; screen turn into a giant sine wave.
.define INTERAC_SCREEN_DISTORTION $7c

;;
; This appears to be just a decoration, doesn't do anything. Subid determines what it
; looks like.
;
; @subid_00{Portal from ganon's lair back to maku tree.}
; @subid_01{King Moblin's flag}
; @subid_02{Gasha sprout}
; @subid_03{Red ball?}
; @subid_04{Scent seedling (planted)}
; @subid_05{Tokay eyeball (always visible)}
; @subid_06{Tokay eyeball (deletes self if room flag bit 7 not set)}
; @subid_07{Fairy powder in a bottle}
; @subid_08{Green book}
; @subid_09{Fountain.
;           @palette{PALH_7d}}
; @subid_0a{"Stream" coming from a fountain.
;           @palette{PALH_7d}}
.define INTERAC_DECORATION $80

;;
; @subid_00{Feather (automatically adjusted to shovel if needed)}
; @subid_01{Bracelet (automatically adjusted to shovel if needed)}
; @subid_02{Shovel (replacing feather)}
; @subid_03{Shovel (replacing bracelet))}
; @subid_04{(L1) Shield (level adjusted automatically)}
; @subid_05{L2 Shield}
; @subid_06{L3 Shield}
.define INTERAC_TOKAY_SHOP_ITEM $81

;;
; Heavy sarcophagus that can be lifted with power gloves.
;
; @subid{If bit 7 is set, it automatically breaks. Otherwise, if subid is nonzero, this
;        gets tied to bit 6 of the room flags (it sets that bit when lifted, and it no
;        longer appears when reentering the room.))}
.define INTERAC_SARCOPHAGUS $82

;;
; Fairy that upgrades your bomb capacity.
;
; @subid_00{"Parent" interaction and the fairy itself}
; @subid_01{Bombs that surround Link (depending on his answer)}
; @subid_02{Gold/silver bombs (depends on var03)}
.define INTERAC_BOMB_UPGRADE_FAIRY $83

;;
.define INTERAC_STUB_85 $85

;;
; Flower for the maku tree. RelatedObj1 should be an instance of INTERAC_MAKU_TREE.
;
; @subid_00{Present flower}
; @subid_01{Something unused?}
.define INTERAC_MAKU_FLOWER $86

;;
; Maku tree in the present.
;
; @subid_00{Main object, converts itself to one of the subids when necessary}
; @subid_01{Cutscene where maku tree disappears}
; @subid_02{Maku tree just after being saved (present)}
; @subid_03{Cutscene after saving Nayru where Twinrova reveals themselves}
; @subid_04{Some cutscene?}
; @subid_05{Credits cutscene?}
; @subid_06{Cutscene where Link gets the maku seed, then Twinrova appears}
.define INTERAC_MAKU_TREE $87

;;
; Maku tree as a sprout in the past.
;
; @subid_00{Main object, converts itself to one of the subids when necessary}
; @subid_01{Script where moblins are attacking Maku Sprout}
; @subid_02{Used in credits cutscene?}
.define INTERAC_MAKU_SPROUT $88

;;
; Triggers maku tree cutscenes; condition for trigger and text depends on var03.
;
; @subid_00{Present version of cutscene}
; @subid_01{Past version of cutscene}
; @var03_00{After D1}
; @var03_01{After present D2 collapses}
; @var03_02{After getting harp}
; @var03_03{After D2}
; @var03_04{After D3. Sets some flags (black tower growth and flute available).}
; @var03_05{After D4}
; @var03_06{After Moblin's Keep destroyed}
; @var03_07{After D5. Also spawns the goron at the end of the cutscene.}
; @var03_08{After D6}
; @var03_09{After D7}
; @var03_0a{After D8}
; @var03_0b{After D8, except there's no conditions for the trigger?}
.define INTERAC_REMOTE_MAKU_CUTSCENE $8a

;;
; @subid_00{Cutscene where goron elder is saved / NPC in that room after that}
; @subid_01{NPC hanging out in rolling ridge}
; @subid_02{NPC for biggoron's sword minigame; postgame only}
.define INTERAC_GORON_ELDER $8b

;;
; Tokay meat object used in the wild tokay game. When spawned, it sets its position to be
; above screen and starts falling.
.define INTERAC_TOKAY_MEAT $8c

;;
; Twinrova in their "mysterious cloaked figure" form
;
; @subid_00{Cutscene at maku tree screen after saving Nayru}
; @subid_01{Cutscene after d7; black tower is complete}
; @subid_02{Cutscene after getting maku seed}
.define INTERAC_CLOAKED_TWINROVA $8d

;;
; A splash animation (used by ENEMY_OCTOGON)
.define INTERAC_OCTOGON_SPLASH $8e

;;
; An ember seed that goes up for a bit, then disappears after falling a bit. Only used in
; the cutscene where you give ember seeds to Tokays.
.define INTERAC_TOKAY_CUTSCENE_EMBER_SEED $8f

;;
; Miscellaneous stuff, mostly puzzle solutions. Similar in purpose to INTERAC_DUNGEON_EVENTS?
;
; @subid_00{Boss key puzzle in D6}
; @subid_01{Underwater switch hook puzzle in past d6}
; @subid_02{Spot to put a rolling colored block on in present d6}
; @subid_03{Chest from solving colored cube puzzle in d6 (related to subid $02)}
; @subid_04{Floor changer in present D6, triggered by orb}
; @subid_05{Helper for floor changer (subid $04)}
; @subid_06{Helper for floor changer (subid $04)}
; @subid_07{Wall retraction event after lighting torches in past d6}
; @subid_08{Checks to set the "bombable wall open" bit in d6 (north)}
; @subid_09{Checks to set the "bombable wall open" bit in d6 (east)}
; @subid_0a{Jabu-jabu water level controller script, in the room with the 3 buttons}
; @subid_0b{Ladder spawner in d7 miniboss room}
; @subid_0c{Switch hook puzzle early in d7 for a small key}
; @subid_0d{Staircase spawner after moving first set of stone panels in d8}
; @subid_0e{Staircase spawner after putting in slates in d8}
; @subid_0f{Octogon boss initialization (in the room just before the boss)}
; @subid_10{Something at the top of Talus Peaks?}
; @subid_11{D5 keyhole opening}
; @subid_12{D6 present/past keyhole opening}
; @subid_13{Eyeglass library keyhole opening}
; @subid_14{Spot to put a rolling colored block on in Hero's Cave}
; @subid_15{Stairs from solving colored cube puzzle in Hero's Cave (related to subid $14)}
; @subid_16{Warps Link out of Hero's Cave upon opening the chest}
; @subid_17{Enables portal in Hero's Cave first room if its other end is active}
; @subid_18{Drops a key in hero's cave block-pushing puzzle}
; @subid_19{Bridge controller in d5 room after the miniboss}
; @subid_1a{Checks solution to pushblock puzzle in Hero's Cave}
; @subid_1b{Spawn gasha seed at top of maku tree after 4th essence (left screen)}
; @subid_1c{Spawn gasha seed at top of maku tree after 7th essence (center screen)}
; @subid_1d{Spawn gasha seed at top of maku tree after 6th essence (right screen)}
; @subid_1e{Play "puzzle solved" sound after navigating eyeball puzzle in final dungeon}
; @subid_1f{Checks if Link gets stuck in the d5 boss key puzzle, resets the room if so}
; @subid_20{Money in sidescrolling room in Hero's Cave}
; @subid_21{Creates explosions while screen is fading out; used after killing veran}
.define INTERAC_MISC_PUZZLES $90

;;
; A falling rock as seen in the cutscene where Ganon's lair collapses? (Doesn't damage
; Link.)
;
; @subid_00{Spawner of falling rocks; stops when $cfdf is nonzero. Used when freeing goron
;           elder. var03 is 0 or 1, changing the positions where the rocks fall?}
; @subid_01{Instance of falling rock spawned by subid $00}
; @subid_02{Small rock "debris". var03, angle, and counter1 affect its trajectory, etc?}
; @subid_03{Debris from ENEMY_TARGET_CART_CRYSTAL; angle is a value from 0-3, indicating
;           a diagonal to move in.}
; @subid_04{Blue rock debris, moving straight on a diagonal (angle from 0-3) - shooting gallery}
; @subid_05{Red rock debris, moving straight on a diagonal (angle from 0-3) - shooting gallery}
; @subid_06{Debris from pickaxe workers? var03 determines oamFlags, counter2 determines
;           draw priority? angle should be 0 or 1 for right or left movement.}
.define INTERAC_FALLING_ROCK $92

;;
; One half of twinrova riding their broomstick. Subids are "paired" by evens and odds; one
; half is the red one, the other is the blue one, for a particular cutscene.
;
; @subid_00-01{Linked cutscene after saving Nayru?}
; @subid_02-03{Twinrova introduction? Unlinked equivalent of subids $00-$01?}
; @subid_04-05{?}
; @subid_06-07{Something in endgame just before Ganon's being revived?}
.define INTERAC_TWINROVA $93

;;
; The restoration guru.
;
; @subid_00{Patch in the upstairs room}
; @subid_01{Patch in his minigame room}
; @subid_02{The minecart in Patch's minigame}
; @subid_03{Beetle "manager"; spawns them and check when they're killed.}
; @subid_04{Broken tuni nut sprite}
; @subid_05{Broken sword sprite}
; @subid_06{Fixed tuni nut sprite}
; @subid_07{Fixed sword sprite}
.define INTERAC_PATCH $94

;;
; Ball used by villagers. Subid is controlled by $cfd3.
;
; @subid_00-01{Standard ball; subid alternates from 0 to 1 based on who's holding it}
; @subid_02{Cutscene where villager turns to stone?}
.define INTERAC_BALL $95

;;
; A moblin NPC. (Used in cutscene where past make tree is being attacked?)
.define INTERAC_MOBLIN $96

;;
; @subid_00{Create "poofs" around this object randomly when Present D2 collapses}
; @subid_01{Spawns "bubbles" (PART_JABU_JABUS_BUBBLES) that blow to the north when Jabu Jabu's mouth opens}
.define INTERAC_97 $97

;;
; @subid_00{An explosion that throws out 4 pieces of rock debris}
; @subid_01{A piece of rock debris}
; @subid_02{Like subid 1, but value of "visible" is determined by var38?}
; @var03{Angle for debris (0-3 for each diagonal)}
.define INTERAC_EXPLOSION_WITH_DEBRIS $99

;;
; For the subid, the first nibble corresponds to a bit number at
; wTmpcfc0.carpenterSearch.carpentersFound; other than that, the first nibble is ignored.
;
; @subid_00{The boss carpenter; changes to subid 5 when needed}
; @subid_01{The "gate" that the boss stands next to}
; @subid_02-04{One of the carpenters to be sought out (either in the bridge room, or in
;              the other rooms before returning)}
; @subid_05{The boss carpenter in the cutscene where they build the bridge}
; @subid_06-08{Carpenters in the cutscene where they build the bridge}
; @subid_09{Carpenter in Eyeglasses Library}
; @subid_ff{Checks if you leave the area without finding all the carpenters}
.define INTERAC_CARPENTER $9a

;;
.define INTERAC_RAFTWRECK_CUTSCENE $9b

;;
; @subid_00{Present King Zora}
; @subid_01{Past King Zora}
; @subid_02{Potion sprite}
.define INTERAC_KING_ZORA $9c

;;
; Guy who teaches you the tune of currents.
.define INTERAC_TOKKEY $9d

;;
; Pushblock that influences the flow of water in talus peaks.
;
; @subid_00{On right side}
; @subid_01{On left side}
.define INTERAC_WATER_PUSHBLOCK $9e

;;
; Platform in sidescrolling areas which disappears.
;
; @subid_00{?}
; @subid_01{?}
; @subid_02{?}
.define INTERAC_DISAPPEARING_SIDESCROLL_PLATFORM $a3

;;
; Platform in sidescrolling areas which moves in a circular motion. The "center" of the
; circle it follows is always position $78x$56 at a fixed distance away, meaning X and
; Y variables don't do anything.
;
; @subid_00{Starts moving up}
; @subid_01{Starts moving right}
; @subid_02{Starts moving down}
.define INTERAC_CIRCULAR_SIDESCROLL_PLATFORM $a4

;;
; Given to Maple
.define INTERAC_TOUCHING_BOOK $a5

;;
; See also INTERAC_MAKU_SEED_AND_ESSENCES
.define INTERAC_MAKU_SEED $a6

;;
; A flame used for the twinrova cutscenes (changes color based on parameters?)
;
; @subid_00-02{?}
; @subid_03-05{?}
; @subid_06-09{?}
.define INTERAC_TWINROVA_FLAME $a9

;;
; @subid_00{?}
; @subid_01{?}
; @subid_02{?}
.define INTERAC_DIN $aa

;;
; @subid_00{?}
; @subid_01{?}
; @subid_02{?}
; @subid_03{?}
; @subid_04{?}
; @subid_05{Present zora palace, top-right}
; @subid_06{Present zora palace, middle-left}
; @subid_07{Present zora palace, bottom-right}
; @subid_08{?}
; @subid_09{?}
; @subid_0a{?}
; @subid_0b{?}
; @subid_0c{?}
; @subid_0d{?}
; @subid_0e{Zora studying in library}
; @subid_0f{?}
; @subid_10{Gives zora scale to Link after beating jabu}
; @subid_11{Guards sea of storms entrance (past/unlinked)}
; @subid_12{Guards sea of storms entrance (present/linked)}
; @subid_13{?}
; @subid_14{?}
; @subid_15{?}
; @subid_16{?}
; @subid_17{?}
; @subid_18{?}
; @subid_19{?}
; @subid_1a{?}
; @subid_1b{?}
.define INTERAC_ZORA $ab

;;
; @subid_00{Zelda in room of rites}
; @subid_01{?}
; @subid_02{?}
; @subid_03{Zelda in vire minigame}
; @subid_04{In village after getting maku seed, before entering tower}
; @subid_05{?}
; @subid_06{Zelda in cutscene after being rescued from vire}
; @subid_07{In Nayru's house after saving her from vire}
; @subid_08{Zelda standing outside black tower after reveal about ralph?}
; @subid_09{During Zelda kidnapped event}
; @subid_0a{?}
.define INTERAC_ZELDA $ad

;;
; Twinrova in a cutscene where they're watching the flames?
;
; @subid_00{Blue twinrova?}
; @subid_01{Red twinrova?}
; @subid_02{Blue twinrova?}
; @subid_03{Red twinrova?}
.define INTERAC_TWINROVA_IN_CUTSCENE $b0

;;
.define INTERAC_TUNI_NUT $b1

;;
; Shakes the screen and spawns rocks from a volcano.
.define INTERAC_VOLCANO_HANDLER $b2

;;
; Spawns the harp of ages in Nayru's house, and manages the cutscene that ensues?
.define INTERAC_HARP_OF_AGES_SPAWNER $b3

;;
; Book in eyeglasses library.
;
; @subid_00{The podium with the missing book (also spawns the other subids)}
; @subid_01-05{Other podiums}
.define INTERAC_BOOK_OF_SEALS_PODIUM $b4

;;
; Actual enemy vire is spawned later?
;
; @subid_00{Vire at black tower entrance}
; @subid_01{Vire in donkey kong minigame (lower level)}
; @subid_02{Vire in donkey kong minigame (upper level)}
.define INTERAC_VIRE $b8

;;
; Jabu as a child in the past.
.define INTERAC_CHILD_JABU $ba

;;
; Veran in the intro cutscene
.define INTERAC_HUMAN_VERAN $bb

;;
; Twinrova again? TODO: better name.
;
; @subid_00-01{?}
; @subid_02-03{?}
.define INTERAC_TWINROVA_3 $bc

;;
; While this object is on-screen, whenever a block is pushed, all other tiles with the same tile
; index will also get pushed in the same direction. Used for puzzles in Ages D5.
.define INTERAC_PUSHBLOCK_SYNCHRONIZER $bd

;;
; A button in Ambi's palace that unlocks the secret passage.
; Subid is 0-4, corresponding to which button it is.
.define INTERAC_AMBIS_PALACE_BUTTON $be

;;
; NPC in Symmetry City.
;
; @subid_00{NPC in present upper-right house}
; @subid_01{Unused?}
; @subid_02{Lady in present lower houses}
; @subid_03{Unused?}
; @subid_04{NPC in present upper-left house}
; @subid_05{Unused?}
; @subid_06-07{Brothers with the tuni nut}
; @subid_08-09{Sisters in the tuni nut building}
; @subid_0a-0b{Kids in the lower past houses}
; @subid_0c{NPC outside symmetry volcano, in the past (after tuni nut is placed)}
.define INTERAC_SYMMETRY_NPC $bf

;;
.define INTERAC_PIRATE_SHIP $c2

;;
; @subid_00{Pirate ship roaming the sea (loaded in slot $d140, "w1ReservedInteraction1")}
; @subid_01{Unlinked cutscene of ship leaving}
; @subid_02{Linked cutscene of ship leaving}
.define INTERAC_PIRATE_CAPTAIN $c3

;;
; Generic Piratian; also, tokay eyeball slot.
;
; @subid_00-03{Piratian in the ship}
; @subid_04{Tokay eyeball slot (invisible object)}
.define INTERAC_PIRATE $c4

;;
; Play a harp song, and make music notes at Link's position. Used when Link learns a song.
;
; @subid_00{Tune of Echoes}
; @subid_01{Tune of Currents}
; @subid_02{Tune of Ages}
.define INTERAC_PLAY_HARP_SONG $c5

;;
; Object placed in the 3-door room in the black tower; checks whether to start the cutscene.
.define INTERAC_BLACK_TOWER_DOOR_HANDLER $c6

;;
.define INTERAC_TINGLE $c8

;;
; Cucco in Syrup's hut that prevents you from stealing. (Not to be confused with ENEMY_CUCCO,
; which is a more normal cucco.)
.define INTERAC_SYRUP_CUCCO $c9

;;
; @subid_00{Troy at target carts (postgame)}
; @subid_01{Troy in his house (disappears in postgame)}
.define INTERAC_TROY $ca

;;
; Ghini that appears in Ages for linked game stuff.
; There's also INTERAC_GHINI.
.define INTERAC_LINKED_GAME_GHINI $cb

;;
; Mayor of Lynna City
.define INTERAC_PLEN $cc

;;
; Linked game NPC
.define INTERAC_MASTER_DIVER $cd

;;
; This is for the great fairy that cleans the sea. For great fairies that heal, see
; "ENEMY_GREAT_FAIRY".
;
; @subid_00{Linked game NPC in fairies' woods (gives a secret)}
; @subid_01{Cutscene after being healed from being an octorok}
.define INTERAC_GREAT_FAIRY $d5

;;
; Linked game NPC.
; Not to be confused with INTERAC_BUSINESS_SCRUB.
.define INTERAC_DEKU_SCRUB $d6

;;
; Handles the cutscene where the maku seed and the 3 essences despawn the barrier in the black
; tower.
;
; @subid_00{Maku seed (spawns the other subids)}
; @subid_01-08{Essences}
.define INTERAC_MAKU_SEED_AND_ESSENCES $d7

;;
; Handles events in rooms where pulling a lever fills lava with walkable terrain.
;
; @subid_00{D4, 1st lava-filler room}
; @subid_01{D4, 2 rooms before boss key}
; @subid_02{D4, 1 room before boss key}
; @subid_03{D8, lava room with keyblock}
; @subid_04{D8, other lava room}
; @subid_05{Hero's Cave lava room}
.define INTERAC_LEVER_LAVA_FILLER $d8

;;
; Slot to place a slate in for ages d8.
;
; @subid{Value from 0-3, corresponds to room flag bits 0-3}
.define INTERAC_SLATE_SLOT $db

;;
; Miscellaneous stuff. See also INTERAC_MISCELLANEOUS_1.
;
; @subid_00{Graveyard key spawner}
; @subid_01{Graveyard gate opening cutscene}
; @subid_02{Initiates cutscene where present d2 collapses}
; @subid_03{Reveals portal spot under bush in symmetry (left side)}
; @subid_04{Reveals portal spot under bush in symmetry (right side)}
; @subid_05{Makes screen shake before tuni nut is restored}
; @subid_06{Makes volcanoes erupt before tuni nut is restored (spawns INTERAC_VOLCANO_HANLDER)}
; @subid_07{Heart piece spawner}
; @subid_08{
;   Replaces a tile at a position with a given value when destroyed. The effect is permanently
;   disabled once that tile is destroyed, by writing to room flags.
;   X is bitmask for room flags, var03 is the tile index to put at "Y".
;   @postype{short}}
; @subid_09{Animates jabu-jabu}
; @subid_0a{Initiates jabu opening his mouth cutscene}
; @subid_0b{Handles floor falling in King Moblin's castle}
; @subid_0c{Bridge handler in Rolling Ridge past}
; @subid_0d{Bridge handler in Rolling Ridge present}
; @subid_0e{Puzzle at entrance to sea of no return (ancient tomb)}
; @subid_0f{Shows text upon entering a room (only used for sea of no return entrance and black tower
;           turret)}
; @subid_10{Black tower entrance handler: warps Link to different variants of black tower.}
; @subid_11{Gives D6 Past boss key when you get D6 Present boss key}
; @subid_12{Bridge handler for cave leading to Tingle}
; @subid_13{Makes lava-waterfall an d4 entrance behave like lava instead of just a wall, so that the
;           fireballs "sink" into it instead of exploding like on land.}
; @subid_14{Spawns portal to final dungeon from maku tree}
; @subid_15{Sets present sea of storms chest contents (changes if linked)}
; @subid_16{Sets past sea of storms chest contents (changes if linked)}
; @subid_17{Forces Link to be squished when he's in a wall (used in ages d5 BK room)}
.define INTERAC_MISCELLANEOUS_2 $dc

;;
; The warp animation that occurs when entering a time portal.
;
; @subid_00{Initiating a warp (entered a portal from the source screen)}
; @subid_01{Completing a warp (warping in to the destination screen)}
; @subid_02{TODO: func_03_7244@state2@cbb3_02}
; @subid_03{?}
; @subid_04{?}
.define INTERAC_TIMEWARP $dd

;;
; A time portal created with the Tune of Currents or Tune of Ages.
; (TODO: wrap in ifdef)
.define INTERAC_TIMEPORTAL $de

;;
; Creates a time portal when the Tune of Echoes is played.
;
; If Bit 7 of subid is set, the portal is always open.
;
; If Bit 6 of subid is set, bit 1 of the room flags is set upon entering the
; portal the first time. The portal will subsequently remain open.
;
; @subid_00{Ordinary portal}
; @subid_01{First portal to past, starts active until maku tree saved}
; @subid_02{First portal to present, activates upon getting satchel}
.define INTERAC_TIMEPORTAL_SPAWNER $e1

;;
; @subid{Value from 0-9}
.define INTERAC_KNOW_IT_ALL_BIRD $e3

;;
.define INTERAC_STUB_e4 $e4

;;
; @subid_00{Raft on Tokay island (only when Dimitri is gone)}
; @subid_01{Raft outside Rafton's house}
; @subid_02{Raft created when SPECIALOBJECT_RAFT is dismounted}
.define INTERAC_RAFT $e6
