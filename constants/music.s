.define  MUS_NONE	       $00
.define  MUS_TITLESCREEN       $01
.define  MUS_MINIGAME	       $02
.define  MUS_OVERWORLD_PRES    $03
.define  MUS_OVERWORLD_PAST    $04
.define  MUS_CRESCENT	       $05
.define  MUS_ESSENCE	       $06
.define  MUS_AMBI_PALACE       $07
.define  MUS_NAYRU	       $08
.define  MUS_GAMEOVER	       $09
.define  MUS_LYNNA_CITY        $0a
.define  MUS_LYNNA_VILLAGE     $0b
.define  MUS_ZORA_VILLGAE      $0c
.define  MUS_ESSENCE_ROOM      $0d
.define  MUS_INDOORS	       $0e
.define  MUS_FAIRY	       $0f
.define  MUS_GET_ESSENCE       $10
.define  MUS_FILE_SELECT       $11
.define  MUS_MAKU_PATH	       $12
.define  MUS_LEVEL1	       $13
.define  MUS_LEVEL2	       $14
.define  MUS_LEVEL3	       $15
.define  MUS_LEVEL4	       $16
.define  MUS_LEVEL5	       $17
.define  MUS_LEVEL6	       $18
.define  MUS_LEVEL7	       $19
.define  MUS_LEVEL8	       $1a
.define  MUS_FINAL_DUNGEON     $1b
.define  MUS_ONOX_CASTLE       $1c
.define  MUS_ROOM_OF_RITES     $1d
.define  MUS_MAKU_TREE	       $1e
.define  MUS_SADNESS	       $1f
.define  MUS_SEA_OF_STORMS     $20
.define  MUS_DISASTER	       $21
.define  MUS_UNDERWATER        $22
.define  MUS_PIRATES	       $23
.define  MUS_SYMMETRY_PRESENT  $24
.define  MUS_SYMMETRY_PAST     $25
.define  MUS_TOKAY_HOUSE       $26
.define  MUS_ROSA_DATE	       $27
.define  MUS_BLACK_TOWER       $28
.define  MUS_CREDITS	       $29
.define  MUS_CREDITS_2	       $2a
.define  MUS_MAPLE_THEME       $2b
.define  MUS_MAPLE_GAME        $2c
.define  MUS_MINIBOSS	       $2d
.define  MUS_BOSS	       $2e
.define  MUS_LADX_SIDEVIEW     $2f
.define  MUS_FAIRY_FOREST      $30
.define  MUS_DANCE	       $31
.define  MUS_FINAL_BOSS        $32
.define  MUS_TWINROVA	       $33
.define  MUS_GANON	       $34
.define  MUS_RALPH	       $35
.define  MUS_CAVE	       $36
.define  MUS_ZELDA_SAVED       $38
.define  MUS_GREAT_MOBLIN      $39
.define  MUS_SYRUP	       $3c
.define  MUS_GORON_CAVE        $3e
.define  MUS_INTRO_1	       $3f
.define  MUS_INTRO_2	       $40
; TODO: investigate these
.define MUS_BLACK_TOWER_ENTRANCE    $46
; Sound effects

.define MUS_PRECREDITS	$4a

.define SND_NONE	$00

.define SND_GETITEM	$4c
.define SND_SOLVEPUZZLE $4d
.define SND_DAMAGE_ENEMY $4e
.define SND_CHARGE_SWORD $4f
.define SND_CLINK	$50
.define SND_THROW	$51
.define SND_BOMB_LAND	$52
.define SND_JUMP	$53
.define SND_OPENMENU	$54
.define SND_CLOSEMENU	$55
.define SND_SELECTITEM	$56
.define SND_UNKNOWN1	$57
.define SND_CLINK2	$58 ; When you clink and a wall is bombable
.define SND_FALLINHOLE	$59
.define SND_ERROR	$5a
.define SND_SOLVEPUZZLE_2   $5b
.define SND_ENERGYTHING $5c ; Like when nayru brings you to the present
.define SND_SWORDBEAM	$5d
.define SND_GETSEED	$5e
.define SND_UNKNOWN2	$5f
.define SND_HEARTBEEP	$60
.define SND_RUPEE	$61
.define SND_HEART_LADX	$62 ; Definitely sounds like the LADX sound effect
.define SND_BOSS_DAMAGE $63 ; When a boss takes damage
.define SND_LINK_DEAD	$64
.define SND_LINK_FALL	$65
.define SND_TEXT	$66
.define SND_BOSS_DEAD	$67
.define SND_UNKNOWN3	$68 ; I can't remember what this is but it sounds familiar
.define SND_UNKNOWN4	$69
.define SND_SLASH	$6a ; Not a sword slash, idk really
.define SND_SWORDSPIN	$6b
.define SND_OPENCHEST	$6c
.define SND_CUTGRASS	$6d
.define SND_ENTERCAVE	$6e
.define SND_EXPLOSION	$6f
.define SND_DOORCLOSE	$70
.define SND_MOVEBLOCK	$71
.define SND_LIGHTTORCH	$72
.define SND_KILLENEMY	$73
.define SND_SWORDSLASH	$74
.define SND_UNKNOWN5	$75
.define SND_SWITCHHOOK	$76
.define SND_DROPESSENCE $77
.define SND_UNKNOWN6	$78
.define SND_BIG_EXPLOSION $79

.define SND_MYSTERY_SEED    $7b
.define SND_AQUAMENTUS_HOVER $7c
.define SND_OPEN_SOMETHING $7d
.define SND_SWITCH	$7e
.define SND_MOVE_BLOCK_2 $7f
.define SND_MINECART	$80
.define SND_STRONG_POUND $81 ; Not really sure how to describe this, similar to explosions
; 82 - Part of the moving roller thing from seasons?
.define SND_MAGIC_POWDER $83 ; Like from LADX
.define SND_MENU_MOVE	$84
.define SND_SCENT_SEED	$85

.define SND_SPLASH	$87
.define SND_LINK_SWIM	$88
.define SND_TEXT_2	$89
.define SND_POP		$8a ; Again no PoP in this game, but a similar sound
.define SND_CRANEGAME	$8b ; SAME SOUND AS IN CRANE GAME
.define SND_UNKNOWN7	$8c
.define SND_TELEPORT	$8d
.define SND_SWITCH2	$8e
.define SND_ENEMY_JUMP	$8f
.define SND_GALE_SEED	$90
.define SND_FAIRYCUTSCENE $91 ; When the diseased waters go away in the fairy cutscene

.define SND_WARP_START	$95
.define SND_GHOST	$96 ; LADX HYPE

.define SND_POOF	$98
.define SND_BASEBALL	$99
.define SND_BECOME_BABY $9a
.define SND_JINGLE	$9b ; I'm 99% sure this is unused
.define SND_PICKUP	$9c
.define SND_FLUTE_RICKY $9d
.define SND_FLUTE_DIMITRI $9e
.define SND_FLUTE_MOOSH $9f
.define SND_CHICKEN	$a0
.define SND_MONKEY	$a1 ; LADX HYPE
.define SND_COMPASS	$a2
.define SND_LAND	$a3 ; Probably used for PEGASUS SEEDS
.define SND_BEAM	$a4
.define SND_BREAK_ROCK	$a5
.define SND_STRIKE	$a6 ; Might be wrong here
.define SND_SWITCH_HOOK_2 $a7 ; IDK
.define SND_VERAN_FAIRY_ATTACK $a8
.define SND_DIG		$a9
.define SND_WAVE	$aa
.define SND_DING	$ab ; Like when you get your sword
.define SND_SHOCK	$ac
.define SND_ECHO	$ad ; Tune of echos
.define SND_CURRENT	$ae
.define SND_AGES	$af
.define SND_OPENING	$b0 ; Used in d8 when opening those thingies
.define SND_BIGSWORD	$b1 ; Biggoron's sword
.define SND_MAKUDISAPPEAR $b2
.define SND_RUMBLE	$b3 ; Like a short version of MAKUDISAPPEAR
.define SND_FADEOUT	$b4
.define SND_TINGLE	$B5
.define SND_TOKAY	$B6
.define SND_RUMBLE2	$B8 ; Screen shaking; Shorter than B2, Longer than B3
.define SND_ENDLESS	$b9 ; B4 but endless
.define SND_BEAM1	$BA ; Sounds like the Beamos shooting but isn't
.define SND_BEAM2	$BB ; Not sure. Kinda sounds like another beam
.define SND_BIG_EXPLOSION_2 $BC ;Something massive getting destroyed
; More to be documented probably
.define SND_C9		$c9

; f0,f1,f5,f6,f7,f8,f9,fa,fb,fc have special behaviors.
.define SND_F1		$f1
.define SND_F6		$f6
.define SND_FC		$fc
