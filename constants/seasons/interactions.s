; Seasons-specific interaction objects.
;
; See constants/common/interactions.s for documentation.


;;
; Called by Rod of Seasons item code, and sets the next available season
.define INTERAC_USED_ROD_OF_SEASONS $15

.define INTERAC_STUB_19 $19
.define INTERAC_STUB_1a $1a
.define INTERAC_STUB_1b $1b

;;
; Handles interaction with rupee tiles, giving random rupees
; @subid_00{D2 rupee room}
; @subid_01{D6 rupee room}
.define INTERAC_RUPEE_ROOM_RUPEES $1d

;;
; @subid_00{Holly's chimney}
; @subid_01{???}
; @subid_02{Into Sunken City left waterfall}
; @subid_03{Into Sunken City right waterfall}
; @subid_04{Into Natzu River waterfall}
; @subid_05{From Sunken City left waterfall}
; @subid_06{From Sunken City right waterfall}
; @subid_07{From Natzu River waterfall}
; @subid_08{Mt. Cucco dive spot to Sunken City}
; @subid_09{Sunken City north dive spot}
; @subid_0a{Dive spot outside D4}
; @subid_0b{ROOM_SEASONS_4f4, desert?}
; @subid_0c{ROOM_SEASONS_4f5, desert?}
; @subid_0d{Sunken City south dive spot}
.define INTERAC_SPECIAL_WARP $1f

;;
.define INTERAC_GNARLED_KEYHOLE $21

;;
; TODO: subids
.define INTERAC_MAKU_CUTSCENES $22

;;
; @subid_01{In Spring season room}
; @subid_11{In Summer season room}
; @subid_21{In Autumn season room}
; @subid_31{In Winter season room}
; @subid_30{Winter temple orb puzzle}
; @subid_40{Cutscene entering Temple area}
.define INTERAC_SEASON_SPIRITS_SCRIPTS $23

;;
; @subid_00{Mayor}
; @subid_01{Linked woman}
.define INTERAC_MAYORS_HOUSE_NPC $24

;;
; @subid_00{Not saved Mittens}
; @subid_01{Saved Mittens}
.define INTERAC_MITTENS $25

;;
; @subid_00{Not saved Mittens}
; @subid_01{Saved Mittens}
.define INTERAC_MITTENS_OWNER $26

;;
; @subid_00{South of Maku tree}
; @subid_01{By Eastern Suburbs portal}
; @subid_02{Near Floodgate keyhole}
.define INTERAC_SOKRA $27

;;
.define INTERAC_MRS_RUUL $29

;;
; @subid_00-09{Know-it-all birds}
; @subid_0a{Bird with Impa when Zelda gets kidnapped}
; @subid_0b{Panicking bird in Horon village entrance screen}
.define INTERAC_BIRD $2a

;;
.define INTERAC_MR_WRITE $2c

;;
; Moves around horon village a lot based on game stage
;
; @subid_80-86{}
.define INTERAC_FICKLE_LADY $2d

;;
; Girl in Sunken City
;
; @subid_00-04{}
.define INTERAC_FICKLE_GIRL $2e

;;
.define INTERAC_MALON $2f

;;
; @subid_00{Standing by head smelter in front of Autumn temple}
; @subid_01{unused???}
; @subid_02{1st room of furnace - bottom right}
; @subid_03{1st room of furnace - top left}
; @subid_04{2nd room of furnace - bottom right}
; @subid_05{2nd room of furnace - leftmost}
; @subid_06{Bottom-center screen of subrosian beach}
; @subid_07{Top-left screen of subrosian beach}
; @subid_08{Top-center screen of subrosian beach}
; @subid_09{Bottom-left screen of subrosian beach}
; @subid_0a{Screen above beach - bottom right}
; @subid_0b{Screen above beach - top left}
; @subid_0c{Shopkeeper}
; @subid_0d{Has gasha seed in house across a tile-wide river of lava}
; @subid_0e{Screen above portal near strange brothers}
; @subid_0f{Screen right of portal near strange brothers}
; @subid_10{Strange brother when stealing your feather - top-left}
; @subid_11{Strange brother when stealing your feather - bottom-right}
; @subid_12{Strange brothers house 1st screen - left}
; @subid_13{Strange brothers house 1st screen - right}
; @subid_14{TODO: Says "I still haven't been that way, what's there?"}
; @subid_15{Screen with entrance to cave you can start the erupting cutscene - left}
; @subid_16{Screen with entrance to cave you can start the erupting cutscene - right}
; @subid_17{From suburbs portal - left}
; @subid_18{From suburbs portal - right}
; @subid_19{Screen south of suburbs portal entry}
; @subid_1a{Same screen as portal 2 screens south of D8}
; @subid_1b{Screen south of NW locked door}
; @subid_1c{Just above boomerang subrosian}
; @subid_1d{Screen right of boomerang subrosian}
; @subid_1e{Across a pit leading to area with W ore}
; @subid_1f{Same screen as chest right of W ore}
; @subid_20{Screen above strange brother's house}
; @subid_21{Same screen as strange brother's house}
; @subid_22{Screen south of shop}
; @subid_23{In house with lava pool to the top-left}
; @subid_24{Top-right screen of subrosian beach}
; @subid_25{Golden subrosian giving secret}
; @subid_26{Signs guy}
.define INTERAC_SUBROSIAN $30

;;
; @subid_00{Rosa}
; @subid_01{Rosa following you}
; @subid_02{Spawns star ore}
; @subid_03{same code as subid_00???}
.define INTERAC_ROSA $31

;;
; @subid_00{South of autumn temple}
; @subid_01{Outside cave SE of D8}
; @subid_02{Path west of Temple of seasons near small erupting volcanoes}
; @subid_03{Near boomerang subrosian}
; @subid_04{Path southwest of Temple of seasons - gap to village}
; @subid_05{In village, screen north of portal}
; @subid_06-07{Unused?}
.define INTERAC_SUBROSIAN_WITH_BUCKETS $32

;;
; Bathing subrosians
;
; @subid_80-82{By 50 ore chunk spot}
; @subid_83-85{Above dancing minigame entrance}
.define INTERAC_BATHING_SUBROSIANS $33

;;
.define INTERAC_SUBROSIAN_SMITHS $34

;;
; Moves around sunken city a lot based on game stage
;
; @subid_80-84{}
.define INTERAC_MASTER_DIVERS_SON $36

;;
; Moves around horon village a lot based on game stage
;
; @subid_80-86{}
.define INTERAC_FICKLE_MAN $37

;;
; D1, D4 and linked Hero's cave
.define INTERAC_DUNGEON_WISE_OLD_MAN $38

;;
; Moves around his house in sunken city a lot based on game stage
; @subid_80-84{}
.define INTERAC_TREASURE_HUNTER $39

;;
; Seems to be unused
.define INTERAC_3a $3a

;;
; upper nybble of subid goes into var03
;
; @var03_00{Initially looks forward}
; @var03_01{Initially resting until you're near}
; @var03_02{Pushes Link away while walking}
;
; @subid_20{Pacing goron}
; @subid_11{Regular goron - 1F}
; @subid_02{Regular goron - 1F}
; @subid_13{Regular goron - 1F}
; @subid_14{Regular goron - 2F}
; @subid_15{Regular goron - 2F}
; @subid_16{Red goron who upgrades ringbox}
; @subid_07{Red goron giving secret}
.define INTERAC_GORON $3b

;;
.define INTERAC_OLD_LADY_FARMER $3c

;;
.define INTERAC_FOUNTAIN_OLD_MAN $3d

;;
; upper nybble of subid goes into var03, and determines type of NPC.
;
; subids are replaced with the current game stage (different for Horon Village and Sunken
; City).
;
; @subid_00-04{Throws dog a ball}
; @subid_10-13{Simple Horon Village boy}
; @subid_20{Disappears in winter. In Spring, plays with Horon village flower}
; @subid_30,32-34{Sunken City boy}
; @subid_31{In Sunken City, ROOM_SEASONS_06e when Moblins keep destroyed, else ROOM_SEASONS_05e}
.define INTERAC_MISC_BOY_NPCS $3e

;;
.define INTERAC_TICK_TOCK $3f

;;
; subid_00 and subid_0b belongs to captain
; code just determines looks, subids determine the script
;
; @subid_01-06{In the house, 1F}
; @subid_07{In the house, 2F - NPC Unlucky Sailor awaiting secret}
; @subid_08{In the house, 2F}
; @subid_09{Roof of house by portal}
; @subid_0a{By samasa desert gates}
; @subid_0c{Spawned by captain subid_0b from ship when leaving Subrosia}
; @subid_0d-0e{By captain subid_0b, by ship in Subrosia}
.define INTERAC_PIRATIAN $40

;;
; @subid_00{In the house}
; @subid_0b{By the ship in Subrosia}
.define INTERAC_PIRATIAN_CAPTAIN $41

;;
; 1 subrosian that moves downstairs when pirates leave
;
; @subid_00{2F}
; @subid_01{1F}
.define INTERAC_PIRATE_HOUSE_SUBROSIAN $42

;;
.define INTERAC_SYRUP $43

;;
; @subid_00{In Room of Rites}
; @subid_01{By Maku tree after escaping Room of Rites}
; @subid_02{Being kidnapped}
; @subid_03{TODO: With animals/people in cutscenes}
; @subid_04{Same script as above - unused?}
; @subid_05{TODO: With a triforce interaction}
; @subid_06{Pacing around in North Horon about to be kidnapped}
; @subid_07{After Zelda Villagers cutscene, she's there with animals}
; @subid_08{By Maku tree, before fighting Onox}
; @subid_09{In Impa's house after saving her from vire}
.define INTERAC_ZELDA $44

;;
; @subid_00{In cave, sleeping}
; @subid_01{Returned to Malong}
.define INTERAC_TALON $45

;;
; TODO: subids
.define INTERAC_MAKU_LEAF $48

;;
; Cucco in Syrup's hut that prevents you from stealing. (Not to be confused with ENEMY_CUCCO,
; which is a more normal cucco.)
.define INTERAC_SYRUP_CUCCO $49

;;
; @subid_00{}
; @subid_01{}
; @subid_02{TODO: spawned by interactionCodebb}
.define INTERAC_D1_RISING_STONES $4b

;;
; @subid_00{Windmill blades}
; @subid_01{Gasha sprouts in mayor's house}
; @subid_02{Left half of cloud}
; @subid_03{Right half of cloud}
; @subid_04{Red ore thrown into furnace}
; @subid_05{Blue ore thrown into furnace}
; @subid_06{TODO: level 2 sword in podium?}
; @subid_07{Water ring around fountain}
; @subid_08{Water spurting up from fountain}
; @subid_09{Goron vase in Ingo's house after trading it}
; @subid_0a{Spring emblem in Temple of Seasons}
; @subid_0b{Summer emblem in Temple of Seasons}
; @subid_0c{Winter emblem in Temple of Seasons}
; @subid_0d{Autumn emblem in Temple of Seasons}
.define INTERAC_MISC_STATIC_OBJECTS $4c

;;
; @subid_00{Talkable skull in the desert}
; @subid_01{Drops from quicksand}
.define INTERAC_PIRATE_SKULL $4d

;;
; @subid_00{Troupe 1 - green beer guy}
; @subid_01{Troupe 2 - blue hair}
; @subid_02{Troupe 3 - guitar guy}
; @subid_03{Troupe 4 - red beer guy}
; @subid_04{Impa}
; @subid_05{Campfire}
; @subid_06{Din}
; @subid_07{Tornado}
; @subid_08-09{Din during ending cutscenes}
; @subid_0a{Troupe in Horon Village}
; @subid_0b{Spawns subids $00 to $06}
.define INTERAC_DIN_DANCING_EVENT $4e

;;
; @subid_00{Din}
; @subid_01{Onox?}
; @subid_02{Crystals?}
; @subid_03{Circling thing?}
; @subid_04{Crystals?}
; @subid_05{Onox?}
.define INTERAC_DIN_IMPRISONED_EVENT $4f

;;
.define INTERAC_SEASONS_FAIRY $50

;;
; TODO: subids determine how active the volcano is and subid of INTERAC_VOLCANO_ROCK
;
; @subid_00{}
; @subid_01{}
.define INTERAC_SMALL_VOLCANO $51

;;
.define INTERAC_BIGGORON $52

;;
; @subid_00{By temple of autumn}
; @subid_01{By furnace}
.define INTERAC_HEAD_SMELTER $53

;;
.define INTERAC_SUBROSIAN_AT_VOLCANO_ITEMS $54

;;
; The subrosian trying to blow up the volcano leading to d8
.define INTERAC_SUBROSIAN_AT_VOLCANO $55

;;
.define INTERAC_INGO $57

;;
.define INTERAC_GURU_GURU $58

;;
; Overrides subid depending on sword gotten
.define INTERAC_LOST_WOODS_SWORD $59

;;
.define INTERAC_BLAINO_SCRIPT $5a

;;
.define INTERAC_LOST_WOODS_DEKU_SCRUB $5b

;;
.define INTERAC_LAVA_SOUP_SUBROSIAN $5c

;;
; subids indexed same as trade item subid, the ones used are
;
; @subid_06{Fish}
; @subid_07{Megaphone}
; @subid_08{Mushroom}
.define INTERAC_TRADE_ITEM $5d

;;
; subid_00{Regular quicksand that deals damage}
; subid_01-04{The four that could lead to pirate's bell}
; subid_05{Leads to SE samasa treasure chest}
.define INTERAC_QUICKSAND $5e

.define INTERAC_COMPANION_SPAWNER $5f

.define INTERAC_STUB_61 $61

;;
; subid_00{Spawns subid01 4 times with var03 of 0-3}
; subid_01{Handles chests and contents, and opening order}
.define INTERAC_D5_4_CHEST_PUZZLE $62

;;
.define INTERAC_D5_REVERSE_MOVING_ARMOS $63

;;
.define INTERAC_D5_FALLING_MAGNET_BALL $64

;;
; @subid_00{Created when trap rupee touched, inits stuff and spawns subid $01 and $02}
; @subid_01{TODO}
; @subid_02{TODO}
.define INTERAC_D6_CRYSTAL_TRAP_ROOM $65

;;
; TODO:
; @subid_00{}
; @subid_01{created by subid_00}
.define INTERAC_D7_4_ARMOS_BUTTON_PUZZLE $66

;;
.define INTERAC_D8_ARMOS_PATTERN_PUZZLE $67

;;
.define INTERAC_D8_GRABBABLE_ICE $68

;;
; @subid_00{Located in the 4 rooms where lava is spewed}
; @subid_01{spawned from subid_00 (TODO: what is it)}
; @subid_02{spawned from subid_01}
; @subid_03{spawned from subid_01}
; @subid_04{spawned from subid_00}
.define INTERAC_D8_FREEZING_LAVA_EVENT $69

;;
; @subid_00{Spawns subid_01 and subid_02}
; @subid_01{Dance leader}
; @subid_02{Dancer}
; @subid_03{TODO: spawned during tutorial}
.define INTERAC_DANCE_HALL_MINIGAME $6a

;;
; @subid_00{Floodgate Keeper}
; @subid_01{Floodgate Keeper Switch}
; @subid_02{Floodgate keyhole}
; @subid_03{D4 keyhole}
; @subid_04{Floodgate key}
; @subid_05{Dragon key}
; @subid_06{Tarm Ruins Armos unlocking stairs when pushed}
; @subid_07{Tarm Ruins Armos' next to stump}
; @subid_08{Tarm event when exited Lost Woods to the north}
; @subid_09{50 ore chunk dig spots, also spawned by Strange Brothers}
; @subid_0a{Static heart pieces}
; @subid_0b{Permanently removable objects, eg boulders, ember trees}
; @subid_0c{Object handler when falling with skull into pirate's bell room}
; @subid_0d{Green joy ring puzzle in Mt Cucco}
; @subid_0e{Master Diver 4 statue puzzle}
; @subid_0f{Pirate's bell}
; @subid_10{Armos blocking way to D6 - handler}
; @subid_11{Switch to Natzu}
; @subid_12{Onox Castle Cutscene}
; @subid_13{Prevents no enemies south of 1st North Horon seed tree when saving Zelda}
; @subid_14{Unblocking D3 dam - spawned by subid_02}
; @subid_15{Replace pirate ship with quicksand}
; @subid_16{Handle stolen feather - spawned by strange brothers}
; @subid_17{Horon village portal bridge spawner}
; @subid_18{Dig spots with random rings}
; @subid_19{Static gasha seed}
; @subid_1a{Underwater gasha seed}
; @subid_1b{Tick Tock secret entrance}
; @subid_1c{West Coast grave secret entrance}
; @subid_1d{D4 miniboss room - torch/darkness/N door interactions}
; @subid_1e{Sent back by Onox Castle barrier}
; @subid_1f{Sidescrolling static gasha seed}
; @subid_20{Sidescrolling static seed satchel}
; @subid_21{Mt Cucco banana tree}
; @subid_22{Hard ore}
; @subid_23{TODO:}
; @subid_24{TODO:}
; @subid_25{TODO:}
; @subid_26{TODO:}
.define INTERAC_MISCELLANEOUS_1 $6b

;;
; @subid_00{Event starter}
; @subid_01{Rosa herself}
.define INTERAC_ROSA_HIDING $6c

;;
; @subid_00{Event starter}
; @subid_01{Brother 1}
; @subid_02{Brother 2}
.define INTERAC_STRANGE_BROTHERS_HIDING $6d

;;
; @subid_00{spawned by subid_01 (TODO: what is it)}
; @subid_01{located in screen where feather is lost}
; @subid_02{located at strange brothers house entrance}
.define INTERAC_STEALING_FEATHER $6e

;;
; @subid_00{grabbable treasure}
; @subid_01{unblocking the Temple of Autumn}
.define INTERAC_BOMB_FLOWER $6f

;;
; @subid_00{Holly}
; @subid_01{Room outside for detecting snow shovelled}
.define INTERAC_HOLLY $70

;;
; @subid_00{Ricky running off after jumping up cliff in North Horon}
; @subid_01{Moosh being bullied in Spool}
; @subid_02{Taking animal to Sunken City}
; @subid_03{Ricky in North Horon}
; @subid_04{Dimitri in Spool Swamp}
; @subid_05{Dimitri being bullied}
; @subid_06{Moosh in Mt Cucco}
; @subid_07{Moblin rest house - point where bullies will appear}
; @subid_08{Leaving Sunken City with Dimitri}
; @subid_09{1st screen of North Horon from eyeglass lake - determining animal companion}
.define INTERAC_COMPANION_SCRIPTS $71

;;
.define INTERAC_BLAINO $72

;;
; @subid_00-02{Moosh's/Dimitri's 3 bullies}
; @subid_03-05{Spawned moblin bullies for Moosh event}
.define INTERAC_ANIMAL_MOBLIN_BULLIES $73

;;
; @subid_00{}
; @subid_01{}
; @subid_02{}
; @subid_03{}
; @subid_04{}
; @subid_05{}
; @subid_06{}
; @subid_07{}
; @subid_08{}
; @subid_09{}
; @subid_0a{spawned by subid_02 and subid_04}
; @subid_0b{spawned by subid_02 and subid_04}
; @subid_0c{Moblin Keep flag?}
.define INTERAC_74 $74

;;
; @subid_00{}
; @subid_01{}
; @subid_02{}
.define INTERAC_INTRO_SPRITE $75

;;
; @subid_00-02{The 3 bullies}
.define INTERAC_SUNKEN_CITY_BULLIES $76

;;
; Used by temple sinking cutscene
.define INTERAC_77 $77

;;
.define INTERAC_MAGNET_SPINNER $7b

;;
; @subid_00{}
; @subid_01{}
.define INTERAC_TRAMPOLINE $7c

;;
; @subid_00-03{}
.define INTERAC_FICKLE_OLD_MAN $80

;;
; @subid_00{Ribbon}
; @subid_01{Bomb upgrade}
; @subid_02-03{Gasha seed}
; @subid_04{Piece of heart}
; @subid_05-08{Ring}
; @subid_09{4 ember seeds}
; @subid_0a{Shield}
; @subid_0b{10 pegasus seeds}
; @subid_0c{3 hearts}
; @subid_0d{Member's card}
; @subid_0e{10 ore chunks}
.define INTERAC_SUBROSIAN_SHOP $81

;;
.define INTERAC_HORON_DOG $82

;;
.define INTERAC_BALL_THROWN_TO_DOG $83

;;
; Plays carnival music in the screen before Din dancing
.define INTERAC_INTRO_SCENE_MUSIC $85

;;
; TODO: each subid is 1 of the 5 explosions in each screen?
;
; @subid_00{}
; @subid_01{}
; @subid_02{}
; @subid_03{}
; @subid_04{}
.define INTERAC_TEMPLE_SINKING_EXPLOSION $86

;;
; Maku tree. TODO: subids
.define INTERAC_MAKU_TREE $87

;;
; clouds above Onox castle?
.define INTERAC_88 $88

;;
; @subid_00-04{}
.define INTERAC_FLOODED_HOUSE_GIRL $8a

;;
; @subid_00-04{}
.define INTERAC_MASTER_DIVERS_WIFE $8b

;;
; @subid_00{Rooster on top of d4}
; @subid_01{Rooster that leads to spring banana}
.define INTERAC_FLYING_ROOSTER $8c

;;
; @subid_00-04{}
.define INTERAC_MASTER_DIVER $8d

;;
; Bubbles?
.define INTERAC_8e $8e

;;
.define INTERAC_OLD_MAN_WITH_JEWEL $8f

;;
; @subid_00{Tarm ruins entrance script (spawn jewels)}
; @subid_01{Underwater pyramid jewel}
; @subid_02{Handles bridge creation to X jewel island}
; @subid_03{Handles event with X jewel moldorm}
; @subid_04{Determines chest contents in Spool Swamp's jewel cave}
; @subid_05{Determines chest contents in Eyeglass Lake's jewel cave}
; @subid_06{???}
; @subid_07{Created by linked Vire interaction}
.define INTERAC_JEWEL_HELPER $90

;;
; Jewels in place in tarm ruins (visual only)
.define INTERAC_JEWEL $92

;;
; @subid_00{Hanging on Maku tree}
; @subid_01{Given by Maku tree}
.define INTERAC_MAKU_SEED $93

;;
; Given to Maple
.define INTERAC_LON_LON_EGG $94

;;
; In rest house
;
; TODO: interactions $95, $96, maybe $97, $9a, $9b all interact with each other
;   for moblin rest house-related events
;
; @subid_00{}
; @subid_01{}
; @subid_02{}
; @subid_03{Spawned from INTERAC_MOBLIN_KEEP_SCENES - when coming down from Natzu}
; @subid_04{Spawned from seasonsFunc_3e52 (after moblin keep destroyed?) Rushes south}
; @subid_05{Spawned from interactionCodec3 as part of the spawned minions, Moves up, down, up?}
.define INTERAC_KING_MOBLIN $95

;;
; @subid_00-03{}
; @subid04{Spawned by INTERAC_MOBLIN_KEEP_SCENES}
; @subid05-06{Spawned by interactionCodec3 as part of the spawned minions}
.define INTERAC_MOBLIN $96

;;
; moblin house-related?
.define INTERAC_97 $97

;;
; @subid_00-07{}
.define INTERAC_OLD_MAN_WITH_RUPEES $99

;;
; Same room as moblin rest house - event when moblin house explodes?
;
; @subid_00{spawned in func _func_5a82}
; @subid_01{spawned by subid_02 4 times}
; @subid_02{same room as moblin rest house}
; @subid_03{spawned by subid_02}
.define INTERAC_9a $9a

;;
.define INTERAC_9b $9b

;;
.define INTERAC_SPRINGBLOOM_FLOWER $9c

;;
; @subid_00-05{}
.define INTERAC_IMPA $9d

;;
.define INTERAC_SAMASA_DESERT_GATE $9e

;;
.define INTERAC_DISAPPEARING_SIDESCROLL_PLATFORM $a3

;;
.define INTERAC_SUBROSIAN_SMITHY $a4

;;
; @subid_00{TODO: 1st Din after Dragon Onox beat - the one descending?}
; @subid_01{TODO: Other Din after Dragon Onox beat - outside crystal}
; @subid_02-07{TODO: all part of objectData, so ending cutscenes?}
; @subid_06{TODO: part of intro cutscenes (after being captured by Onox?)
; @subid_08{Horon village field, after game beat}
; @subid_09{1st Din (sees you collapsed)}
.define INTERAC_DIN $a5

;;
; @subid_00-04{subid determines angle that each of the 4 fade towards}
.define INTERAC_DINS_CRYSTAL_FADING $a6

;;
.define INTERAC_a9 $a9

;;
; Post-linked game?
;
; @subid_00{Impa}
; @subid_01{Zelda}
; @subid_02{Nayru - this and Impa subid_03 in same objectData}
; @subid_03{Impa}
.define INTERAC_aa $aa

;;
; @subid_00{Right of moblin keep - handles when shooting the cannons at you}
; @subid_01{Inside King Moblin boss room - pre-spawning the enemy king moblin}
; @subid_02{Moblin keep itself - after it's destroyed}
.define INTERAC_MOBLIN_KEEP_SCENES $ab

;;
; NPCs in one credits cutscene with Din and Maple?
;
; @subid_00-04{}
.define INTERAC_ad $ad

;;
; A flame used for the twinrova cutscenes (changes color based on parameters?)
;
; @subid_00-02{?}
; @subid_03-05{?}
; @subid_06-09{?}
.define INTERAC_TWINROVA_FLAME $b0

;;
; Regular piratian in cutscene?
;
; @subid_00{Unused??}
; @subid_01{1st scene in pirate ship, text handler for pirate coming down stairs}
; @subid_02{The actual piratian spawned from subid_01}
; @subid_03{1st scene in pirate ship, standing around}
; @subid_04-06{Unused?? possibly due to 4 in ship all using subid_03}
; @subid_07{Text handler when leaving Samasa desert}
; @subid_08{Text for the 1st dizzy pirate from above (spawns the actual pirate - subid_0a)}
; @subid_09{Focused invisible object moving left and right, to sway ship}
; @subid_0a{1st piratian coming inside ship when it's swaying}
; @subid_0b{2nd piratian coming inside ship when it's swaying}
; @subid_0c{3rd piratian coming inside ship when it's swaying}
; @subid_0d{Sick piratian already inside ship}
; @subid_0e{Sick piratian already inside ship}
; @subid_0f{Unused??}
; @subid_10{Actual NPC at West Coast ship - top half}
; @subid_11{Actual NPC at West Coast ship - bottom half}
; @subid_12-16{Inside pirate ship once docked in West Coast}
; @subid_17{Unused??}
; @subid_18{Ghost piratian}
; @subid_19{Handles text when above and left of boxes above ghost piratian}
; @subid_1a{Handles text when above and right of boxes above ghost piratian}
.define INTERAC_SHIP_PIRATIAN $b1

;;
; Piratian captain in cutscene?
;
; @subid_00{1st scene in pirate ship, leaving Subrosia}
; @subid_01{2nd scene in pirate ship, dizzy and sick}
; @subid_02{Text handler at west coast ship}
; @subid_03{Actual NPC at West Coast ship - top half}
.define INTERAC_SHIP_PIRATIAN_CAPTAIN $b2

;;
.define INTERAC_LINKED_CUTSCENE $b3

;;
; Twinrova witches
;
; @subid_00-07{}
.define INTERAC_b4 $b4

;;
; Linked game only
;
; @subid_00{Mrs Ruul's house}
; @subid_01{Outside Syrup Hut}
; @subid_02{On the way to Samasa desert gate}
; @subid_03{When pirates are leaving for West Coast}
; @subid_04{Pirate house 1F}
.define INTERAC_AMBI $b8

; TODO: the following people are 5 that hang around Zelda

;;
; Impa hanging around Zelda
;
; @subid_00{}
; @subid_01{}
; @subid_02{}
; @subid_03{Spawned by INTERAC_ZELDA_KIDNAPPED_ROOM ($c3)?}
.define INTERAC_ba $ba

;;
; Boy 1 hanging around Zelda
;
; @subid_00-02{}
.define INTERAC_bb $bb

;;
; Boy 2 hanging around Zelda
;
; @subid_00-04{}
.define INTERAC_bc $bc

;;
; Old man 1 hanging around Zelda
;
; @subid_00-02{}
.define INTERAC_bd $bd

;;
; Old man 2 hanging around Zelda
; @subid_00-02{}
.define INTERAC_be $be

;;
; @subid_00{}
; @subid_01{}
.define INTERAC_bf $bf

;;
.define INTERAC_MAYORS_HOUSE_UNLINKED_GIRL $c2

;;
.define INTERAC_ZELDA_KIDNAPPED_ROOM $c3

;;
.define INTERAC_ZELDA_VILLAGERS_ROOM $c4

;;
.define INTERAC_D4_HOLES_FLOORTRAP_ROOM $c5

;;
.define INTERAC_HEROS_CAVE_SWORD_CHEST $c6

;;
.define INTERAC_BOOMERANG_SUBROSIAN $c8

;;
.define INTERAC_BOOMERANG $c9

;;
.define INTERAC_TROY $ca

;;
; @subid_00{Beneath grave, awaiting secret}
; @subid_01{Red/Blue(?) ghini during minigame}
; @subid_02{Red/Blue(?) ghini during minigame}
; @subid_03{In Western Coast house, giving secret}
.define INTERAC_LINKED_GAME_GHINI $cb

;;
.define INTERAC_GOLDEN_CAVE_SUBROSIAN $cc

;;
; @subid_00{Inside house, awaiting a secret}
; @subid_01{Shows text swimming challenge cave}
; @subid_02{Shows treasure inside swimming challenge cave}
.define INTERAC_LINKED_MASTER_DIVER $cd

;;
; @subid_00{In Temple of Seasons, awaiting a secret}
; @subid_01{Linked game NPC near d2 (gives a secret)}
.define INTERAC_GREAT_FAIRY $d5

;;
.define INTERAC_DEKU_SCRUB $d6

.define INTERAC_STUB_d7 $d7

;;
; Gives Fairy secret
.define INTERAC_LINKED_FOUNTAIN_LADY $d8

;;
; @subid_00{Friendly Moblin (Tokay secret)}
; @subid_01{Mamayu Yan's mother (Mamamu secret)}
; @subid_02{Holly's friend (Symmetry secret)}
.define INTERAC_LINKED_SECRET_GIVERS $db

;;
; Mostly Hero's cave stuff, also reuses code for a peg-button-bridge room, and has code
; for volcano erupting cutscene, etc
;
; @subid_00{In cave with button opening bridge, requiring peg seeds to cross - creates bridge}
; @subid_01{Sets Hero's cave main entrance to linked entrance}
; @subid_02{Sets Hero's cave side entrance to linked entrance}
; @subid_03{Linked hero's cave, some multi-buttons rooms - sets bit 7 of wActiveTriggers if all set}
; @subid_04{In some linked hero's cave rooms with portals - spawns the portals}
; @subid_05{In linked heros's cave room with 5 buttons, a chest, and a portal - spawns bridge}
; @subid_06{In hero's cave magic boomerang puzzle room - drops small key}
; @subid_07{Hero's cave puzzle with 8 buttons and spawned enemies}
; @subid_08{Hero's cave puzzle with old man and dungeon chests}
; @subid_09{Same room as above - spawns portal}
; @subid_0a{Linked hero cave entrance - sets bit 4 of normal hero cave's entrance}
; @subid_0b{In Horon village screen with stump/Subrosia pirate house screen}
; @subid_0c{2 stairs leading out from D2 - shows Snake Remains text on entry}
; @subid_0d{Linked hero's cave, room above entrance - initializes dungeon on side entrance entry}
; @subid_0e{In most screens of Temple Remains, replaces some lava tiles with animated lava?}
; @subid_0f{Creates a chest on a purple tile in a linked hero's cave room}
.define INTERAC_MISCELLANEOUS_2 $dc

;;
.define INTERAC_GOLDEN_BEAST_OLD_MAN $dd

;;
; Handles the cutscene where the maku seed and the 3 essences despawn the barrier in the black
; tower.
;
; @subid_00{Maku seed (spawns the other subids)}
; @subid_01-08{Essences}
.define INTERAC_MAKU_SEED_AND_ESSENCES $de

;;
; @subid_00{To and from Subrosia}
; @subid_01{Others, eg in Linked hero's cave and to Twinrova's dungeon}
.define INTERAC_PORTAL_SPAWNER $e1

;;
; In linked game, places pyramid jewel
.define INTERAC_VIRE $e3

;;
.define INTERAC_LINKED_HEROS_CAVE_OLD_MAN $e4

;;
; Interaction to start cutscene of getting Rod of Seasons
;
; @subid_00{Spawns other subid's, and runs script}
; @subid_01{Colored sparkles coming from the seasons}
; @subid_02{Rod of seasons}
; @subid_03{Aura around Rod of seasons}
.define INTERAC_GET_ROD_OF_SEASONS $e6

;;
.define INTERAC_LONE_ZORA $e7
