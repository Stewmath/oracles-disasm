.enum 0

	MUS_NONE                  db ; $00
	MUS_TITLESCREEN           db ; $01
	MUS_MINIGAME              db ; $02
	MUS_OVERWORLD_PRES        db ; $03

.ifdef ROM_AGES
	MUS_OVERWORLD_PAST        db ; $04
	MUS_CRESCENT              db ; $05
.else
	MUS_TEMPLE_REMAINS        db ; $04
	MUS_TARM_RUINS            db ; $05
.endif

	MUS_ESSENCE               db ; $06

.ifdef ROM_AGES
	MUS_AMBI_PALACE           db ; $07
	MUS_NAYRU                 db ; $08
.else
	MUS_UNUSED_1              db ; $07
	MUS_CARNIVAL              db ; $08
.endif

	MUS_GAMEOVER              db ; $09

.ifdef ROM_AGES
	MUS_LYNNA_CITY            db ; $0a
	MUS_LYNNA_VILLAGE         db ; $0b
	MUS_ZORA_VILLAGE          db ; $0c
.else
	MUS_HORON_VILLAGE         db ; $0a
	MUS_HIDE_AND_SEEK         db ; $0b
	MUS_SUNKEN_CITY           db ; $0b
.endif

	MUS_ESSENCE_ROOM          db ; $0d
	MUS_INDOORS               db ; $0e
	MUS_FAIRY                 db ; $0f
	MUS_GET_ESSENCE           db ; $10
	MUS_FILE_SELECT           db ; $11

.ifdef ROM_AGES
	MUS_MAKU_PATH             db ; $12
.else
	MUS_HEROS_CAVE            db ; $12
.endif

	MUS_LEVEL1                db ; $13
	MUS_LEVEL2                db ; $14
	MUS_LEVEL3                db ; $15
	MUS_LEVEL4                db ; $16
	MUS_LEVEL5                db ; $17
	MUS_LEVEL6                db ; $18
	MUS_LEVEL7                db ; $19
	MUS_LEVEL8                db ; $1a
	MUS_FINAL_DUNGEON         db ; $1b
	MUS_ONOX_CASTLE           db ; $1c
	MUS_ROOM_OF_RITES         db ; $1d
	MUS_MAKU_TREE             db ; $1e
	MUS_SADNESS               db ; $1f
	MUS_TRIUMPHANT            db ; $20
	MUS_DISASTER              db ; $21

.ifdef ROM_AGES
	MUS_UNDERWATER            db ; $22
.else
	MUS_SUBROSIAN_DANCE       db ; $22
.endif

	MUS_PIRATES               db ; $23

.ifdef ROM_AGES
	MUS_SYMMETRY_PRESENT      db ; $24
	MUS_SYMMETRY_PAST         db ; $25
	MUS_TOKAY_HOUSE           db ; $26
.else
	MUS_24                    db ; $24 (blank)
	MUS_UNUSED_2              db ; $25
	MUS_SUBROSIAN_SHOP        db ; $26
.endif

	MUS_ROSA_DATE             db ; $27

.ifdef ROM_AGES
	MUS_BLACK_TOWER           db ; $28
.else
	MUS_SUBROSIA              db ; $28
.endif

	MUS_CREDITS_1             db ; $29
	MUS_CREDITS_2             db ; $2a
	MUS_MAPLE_THEME           db ; $2b
	MUS_MAPLE_GAME            db ; $2c
	MUS_MINIBOSS              db ; $2d
	MUS_BOSS                  db ; $2e
	MUS_LADX_SIDEVIEW         db ; $2f

.ifdef ROM_AGES
	MUS_FAIRY_FOREST          db ; $30
.else
	MUS_30                    db ; $30 (blank)
.endif

	MUS_CRAZY_DANCE           db ; $31
	MUS_FINAL_BOSS            db ; $32
	MUS_TWINROVA              db ; $33
	MUS_GANON                 db ; $34

.ifdef ROM_AGES
	MUS_RALPH                 db ; $35
.else
	MUS_SAMASA_DESERT         db ; $35
.endif

	MUS_CAVE                  db ; $36
	MUS_37                    db ; $37 (blank)
	MUS_ZELDA_SAVED           db ; $38
	MUS_GREAT_MOBLIN          db ; $39
	MUS_3a                    db ; $3a (blank)
	MUS_3b                    db ; $3b (blank)
	MUS_SYRUP                 db ; $3c

.ifdef ROM_AGES
	MUS_3d                    db ; $3d (blank)
.else
	MUS_SONG_OF_STORMS        db ; $3d
.endif

	MUS_GORON_CAVE            db ; $3e
	MUS_INTRO_1               db ; $3f
	MUS_INTRO_2               db ; $40
	MUS_41                    db ; $41 (blank)
	MUS_42                    db ; $42 (blank)
	MUS_43                    db ; $43 (blank)
	MUS_44                    db ; $44 (blank)
	MUS_45                    db ; $45 (blank)
	MUS_BLACK_TOWER_ENTRANCE  db ; $46
	MUS_47                    db ; $47 (blank)
	MUS_48                    db ; $48 (blank)
	MUS_49                    db ; $49 (blank)
	MUS_PRECREDITS            db ; $4a
	MUS_4b                    db ; $4b (blank)

.ende

; =============================================================================
; Sound effects
; =============================================================================

.define SND_NONE  $00

.enum $4c
	SND_GETITEM             db ; $4c
	SND_SOLVEPUZZLE         db ; $4d
	SND_DAMAGE_ENEMY        db ; $4e
	SND_CHARGE_SWORD        db ; $4f
	SND_CLINK               db ; $50
	SND_THROW               db ; $51
	SND_BOMB_LAND           db ; $52
	SND_JUMP                db ; $53
	SND_OPENMENU            db ; $54
	SND_CLOSEMENU           db ; $55
	SND_SELECTITEM          db ; $56
	SND_GAINHEART           db ; $57
	SND_CLINK2              db ; $58 ; When you clink and a wall is bombable
	SND_FALLINHOLE          db ; $59
	SND_ERROR               db ; $5a
	SND_SOLVEPUZZLE_2       db ; $5b
	SND_ENERGYTHING         db ; $5c ; Like when nayru brings you to the present
	SND_SWORDBEAM           db ; $5d
	SND_GETSEED             db ; $5e
	SND_DAMAGE_LINK         db ; $5f
	SND_HEARTBEEP           db ; $60
	SND_RUPEE               db ; $61
	SND_HEART_LADX          db ; $62 ; Definitely sounds like the LADX sound effect
	SND_BOSS_DAMAGE         db ; $63 ; When a boss takes damage
	SND_LINK_DEAD           db ; $64
	SND_LINK_FALL           db ; $65
	SND_TEXT                db ; $66
	SND_BOSS_DEAD           db ; $67
	SND_UNKNOWN3            db ; $68 ; I can't remember what this is but it sounds familiar
	SND_UNKNOWN4            db ; $69
	SND_SLASH               db ; $6a ; Not a sword slash, idk really
	SND_SWORDSPIN           db ; $6b
	SND_OPENCHEST           db ; $6c
	SND_CUTGRASS            db ; $6d
	SND_ENTERCAVE           db ; $6e
	SND_EXPLOSION           db ; $6f
	SND_DOORCLOSE           db ; $70
	SND_MOVEBLOCK           db ; $71
	SND_LIGHTTORCH          db ; $72
	SND_KILLENEMY           db ; $73
	SND_SWORDSLASH          db ; $74
	SND_UNKNOWN5            db ; $75 ; A type of sword slash
	SND_SWITCHHOOK          db ; $76 ; Also played when using shield
	SND_DROPESSENCE         db ; $77
	SND_BOOMERANG           db ; $78
	SND_BIG_EXPLOSION       db ; $79

.ifdef ROM_AGES
	SND_7a                  db ; $7a (blank)
.else
	SND_FREEZE_LAVA         db ; $7a (used in Sword & Shield dungeon)
.endif

	SND_MYSTERY_SEED        db ; $7b
	SND_AQUAMENTUS_HOVER    db ; $7c

.ifdef ROM_AGES
	SND_OPEN_GATE           db ; $7d ; When a colored cube opens a gate
.else
	SND_7d                  db ; $7d ; Not blank, but unknown
.endif

	SND_SWITCH              db ; $7e

.ifdef ROM_AGES
	SND_MOVE_BLOCK_2        db ; $7f ; Used for colored cubes?
.else
	SND_DODONGO_OPEN_MOUTH  db ; $7f
.endif

	SND_MINECART            db ; $80
	SND_STRONG_POUND        db ; $81 ; Not really sure how to describe this, similar to explosions
	SND_ROLLER              db ; $82 ; The rolling thing in seasons
	SND_MAGIC_POWDER        db ; $83 ; Like from LADX
	SND_MENU_MOVE           db ; $84
	SND_SCENT_SEED          db ; $85

.ifdef ROM_AGES
	SND_86                  db ; $86 (blank)
.else
	SND_86                  db ; $86 (not blank in Seasons...)
.endif

	SND_SPLASH              db ; $87
	SND_LINK_SWIM           db ; $88
	SND_TEXT_2              db ; $89
	SND_POP                 db ; $8a ; Again no PoP in this game, but a similar sound
	SND_CRANEGAME           db ; $8b ; From LADX, obtained something in crane game
	SND_UNKNOWN7            db ; $8c
	SND_TELEPORT            db ; $8d

.ifdef ROM_AGES
	SND_SWITCH2             db ; $8e
.else
	SND_8e                  db ; $8e ; Not blank, but unknown
.endif

	SND_ENEMY_JUMP          db ; $8f
	SND_GALE_SEED           db ; $90
	SND_FAIRYCUTSCENE       db ; $91 ; When the diseased waters go away in the fairy cutscene

.ifdef ROM_AGES
	SND_92                  db ; $92 (blank)
	SND_93                  db ; $93 (blank)
	SND_94                  db ; $94 (blank)
.else
	SND_MAKU_TREE_SNORE     db ; $92
	SND_93                  db ; $93 ; Stalfos boss from ladx D5?
	SND_DODONGO_EAT         db ; $94 ; Snake's Remains boss uses this?
.endif

	SND_WARP_START          db ; $95
	SND_GHOST               db ; $96
	SND_97                  db ; $97 (blank)
	SND_POOF                db ; $98
	SND_BASEBALL            db ; $99
	SND_BECOME_BABY         db ; $9a
	SND_JINGLE              db ; $9b ; I'm 99% sure this is unused
	SND_PICKUP              db ; $9c
	SND_FLUTE_RICKY         db ; $9d
	SND_FLUTE_DIMITRI       db ; $9e
	SND_FLUTE_MOOSH         db ; $9f
	SND_CHICKEN             db ; $a0

.ifdef ROM_AGES
	SND_MONKEY              db ; $a1 ; Monkey from LADX?
.else
	SND_a1                  db ; $a1 ; Blank
.endif

	SND_COMPASS             db ; $a2
	SND_LAND                db ; $a3 ; Probably used for PEGASUS SEEDS
	SND_BEAM                db ; $a4
	SND_BREAK_ROCK          db ; $a5
	SND_STRIKE              db ; $a6 ; Might be wrong here
	SND_SWITCH_HOOK         db ; $a7
	SND_VERAN_FAIRY_ATTACK  db ; $a8
	SND_DIG                 db ; $a9
	SND_WAVE                db ; $aa
	SND_SWORD_OBTAINED      db ; $ab ; Used when you get your sword in Seasons
	SND_SHOCK               db ; $ac

.ifdef ROM_AGES
	SND_ECHO                db ; $ad ; Tune of echos
	SND_CURRENT             db ; $ae
	SND_AGES                db ; $af
.else
	SND_ad                  db ; $ad (blank)
	SND_FRYPOLAR_MOVEMENT   db ; $ae
	SND_MAGNET_GLOVES       db ; $af
.endif

	SND_OPENING             db ; $b0 ; Used in d8 when opening those thingies
	SND_BIGSWORD            db ; $b1 ; Biggoron's sword
	SND_MAKUDISAPPEAR       db ; $b2
	SND_RUMBLE              db ; $b3 ; Like a short version of MAKUDISAPPEAR; used for cracked floors
	SND_FADEOUT             db ; $b4 ; Subrosia transition

.ifdef ROM_AGES
	SND_TINGLE              db ; $b5
	SND_TOKAY               db ; $b6
	SND_b7                  db ; $b7 (blank)
.else
	SND_b5                  db ; $b5 ; Not blank, but unknown
	SND_b6                  db ; $b6 (blank)
	SND_b7                  db ; $b7 ; Not blank, but unknown
.endif

	SND_RUMBLE2             db ; $b8 ; Screen shaking; Shorter than B2, Longer than B3
	SND_ENDLESS             db ; $b9 ; B4 but endless
	SND_BEAM1               db ; $ba ; Sounds like the Beamos shooting but isn't
	SND_BEAM2               db ; $bb ; Not sure. Kinda sounds like another beam
	SND_BIG_EXPLOSION_2     db ; $bc ;Something massive getting destroyed

.ifdef ROM_AGES
	SND_bd                  db ; $bd (blank)
.else
	SND_bd                  db ; $bd ; A single sound slowly lowering in pitch
.endif

	SND_VERAN_PROJECTILE    db ; $be ; Used for Veran's projectile attack in her posessed forms
	SND_CHARGE              db ; $bf ; Might be unused; sounds similar to SND_TINGLE
	SND_TRANSFORM           db ; $c0 ; LADX sound where nightmare transforms into Dethyl
	SND_RESTORE             db ; $c1 ; Used in ie. the ending Seasons cutscene when seasons are restored
	SND_FLOODGATES          db ; $c2 ; Floodgates outside d3 in Seasons
	SND_RICKY               db ; $c3
	SND_DIMITRI             db ; $c4
	SND_MOOSH               db ; $c5
	SND_DEKU_SCRUB          db ; $c6
	SND_GORON               db ; $c7
	SND_DING                db ; $c8 ; Used as the bell in matches with Blaino
	SND_CIRCLING            db ; $c9 ; Used in the cutscene where Veran posesses Ambi (veran is circling around)

.ifdef ROM_AGES
	SND_CA                  db ; $ca (blank)
.else
	SND_DANCE_MOVE          db ; $ca ; Moved left or right in subrosian dance
.endif

	SND_SEEDSHOOTER         db ; $cb
	SND_WHISTLE             db ; $cc ; Used in Subrosian, Goron minigames
	SND_GORON_DANCE_B       db ; $cd ; Goron dance, B button pressed
	SND_MAKU_TREE_PAST      db ; $ce ; Used when Maku Tree communicates with Link in the past

.ifdef ROM_AGES
	SND_CF                  db ; $cf (blank)
.else
	SND_CREEPY_LAUGH        db ; $cf ; Used in Explorer's Crypt
.endif

	SND_PIRATE_BELL         db ; $d0 ; Also used by scent seeds

.ifdef ROM_AGES
	SND_TIMEWARP_INITIATED  db ; $d1
.else
	SND_d1                  db ; $d1 ; Not blank, but unknown
.endif

	SND_LIGHTNING           db ; $d2
	SND_WIND                db ; $d3 ; Used in the raft cutscene before d3

.ifdef ROM_AGES
	SND_TIMEWARP_COMPLETED  db ; $d4
.else
	SND_d4                  db ; $d4 (blank)
.endif

.ende

; $d5-$ef are undefined?

; The following are "pseudo-sound effects" with special behaviour.

.define SNDCTRL_STOPMUSIC      $f0
.define SNDCTRL_STOPSFX        $f1
.define SNDCTRL_DISABLE        $f5
.define SNDCTRL_ENABLE         $f6

.define SNDCTRL_FAST_FADEIN    $f7
.define SNDCTRL_MEDIUM_FADEIN  $f8
.define SNDCTRL_SLOW_FADEIN    $f9

.define SNDCTRL_FAST_FADEOUT   $fa
.define SNDCTRL_MEDIUM_FADEOUT $fb
.define SNDCTRL_SLOW_FADEOUT   $fc
