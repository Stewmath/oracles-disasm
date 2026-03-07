; Ages-specific part objects.
;
; See constants/common/parts.s for documentation.


.define PART_STUB_0a $0a
.define PART_STUB_0d $0d

;;
.define PART_JABU_JABUS_BUBBLES $16

;;
.define PART_GROTTO_CRYSTAL $24

;;
.define PART_SPARKLE $26

;;
; Used by INTERAC_TIMEWARP
.define PART_TIMEWARP_ANIMATION $2b

;;
; Used by INTERAC_VIRE (flame used in "donkey kong" minigame)
;
; subid determines movement pattern
; @subid_00{2nd screen with Zelda}
; @subid_01{1st screen}
.define PART_DONKEY_KONG_FLAME $2c

;;
; Used by ENEMY_VERAN_FAIRY - the blue projectile often used
.define PART_VERAN_FAIRY_PROJECTILE $2d

;;
; When this object exists, it applies the effects of whirlpool and pollution tiles.
; It's a bit weird to put this functionality in an object...
.define PART_SEA_EFFECTS $2e

;;
; Turns Link into a baby
.define PART_BABY_BALL $2f

;;
; @palette(PALH_be}
.define PART_SUBTERROR_DIRT $32

;;
; Rotating things that you can shoot seeds off of
.define PART_ROTATABLE_SEED_THING $33

;;
; Used by Ramrock (seed form)
.define PART_RAMROCK_SEED_FORM_LASER $34

;;
; Used by Ramrock (glove form)
;
; @subid_00{Right hand/shoulder}
; @subid_01{Left hand/shoulder}
; @subid_80{Right hand/shoulder}
; @subid_81{Left hand/shoulder}
.define PART_RAMROCK_GLOVE_FORM_ARM $35

;;
; Flame animation used exclusively by ENEMY_CANDLE. Expects relatedObj1 to point to its
; parent.
.define PART_CANDLE_FLAME $36

;;
; Used by ENEMY_VERAN_POSSESSION_BOSS, ENEMY_VERAN_FAIRY.
;
; @subid_00{The "core" which fires the actual projectiles}
; @subid_01{An actual projectile}
.define PART_VERAN_PROJECTILE $37

;;
; Ball for the shooting gallery
.define PART_BALL $38

;;
; Projectile used by head thwomp?
.define PART_HEAD_THWOMP_FIREBALL $39


;;
; Used by head thwomp (purple face); a boulder.
.define PART_3b $3b

;;
; Used by head thwomp
.define PART_HEAD_THWOMP_CIRCULAR_PROJECTILE $3c

;;
; Subid: ?
.define PART_BLUE_STALFOS_PROJECTILE $3d

;;
; Part that affects PART_DETECTION_HELPER created by Ambi Guards
.define PART_3e $3e

;;
; Used with bomb drop with head thwomp.
;
; Does not create bomb drop, but configures its speed and angle.
;
; relatedObj1 is a reference to a PART_ITEM_DROP instance.
.define PART_HEAD_THWOMP_BOMB_DROPPER $40

;;
.define PART_SHADOW_HAG_SHADOW $41

;;
.define PART_PUMPKIN_HEAD_PROJECTILE $42

;;
; @subid_00{Blue}
; @subid_01{Red}
.define PART_PLASMARINE_PROJECTILE $43

;;
; relatedObj1 must be set to the tingle object (INTERAC_TINGLE).
.define PART_TINGLE_BALLOON $44

;;
; Spawns boulders when climbing up to Patch.
;
; All subids used per screen, they determine initial time before spawning, so that they fall one
; after the other.
;
; @subid_00-03{}
.define PART_FALLING_BOULDER_SPAWNER $45

;;
; subids determine bit set/unset of wActiveTriggers when hit
; @subid_00-03{}
.define PART_SEED_SHOOTER_EYE_STATUE $46

;;
; Bomb used by PART_KING_MOBLIN_MINION.
.define PART_BOMB $47

;;
; Projectile used by Octogon when Link is below water and Octogon is above.
;
; @subid_00{The large projectile (before splitting)}
; @subid_01{Smaller, split projectile}
.define PART_OCTOGON_DEPTH_CHARGE $48

;;
; Used by big bang game.
;
; @subid_00{A single bomb?}
; @subid_ff{A spawner for bombs?}
.define PART_BIGBANG_BOMB_SPAWNER $49

;;
;
; Projectile used by smog boss.
; @subid_00{Projectile from small smog}
; @subid_01{Projectile from large smog}
.define PART_SMOG_PROJECTILE $4a

;;
; Used by Ramrock (seed form)
.define PART_RAMROCK_SEED_FORM_ORB $4f

;;
.define PART_ROOM_OF_RITES_FALLING_BOULDER $54

;;
.define PART_OCTOGON_BUBBLE $55

;;
; Used by ENEMY_VERAN_FINAL_FORM (spider)
.define PART_VERAN_SPIDERWEB $56

;;
; Used by ENEMY_VERAN_FINAL_FORM
.define PART_VERAN_ACID_POOL $57

;;
; Used by ENEMY_VERAN_FINAL_FORM (bee)
.define PART_VERAN_BEE_PROJECTILE $58

;;
; @subid_00{Left flame}
; @subid_01{Top flame}
; @subid_02{Right flame}
; @subid_03{Bottom flame}
.define PART_BLACK_TOWER_MOVING_FLAMES $59

;;
; The stone that's pushed at the start of the game. This only applies after it's moved;
; before it's moved, the stone is handled by INTERAC_TRIFORCE_STONE instead.
.define PART_TRIFORCE_STONE $5a
