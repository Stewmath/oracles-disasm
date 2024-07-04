; Ages-specific enemy objects.
;
; See constants/common/enemies.s for documentation.


;;
; See also INTERAC_VERAN_CUTSCENE_FACE (triggers cutscene for this)
.define ENEMY_VERAN_FINAL_FORM $02

;;
; Even subids appear on the left, while odd subids are on the right.
; @subid_00-01{Fists}
; @subid_02-03{Bomb chompers}
; @subid_04-05{Grabbable balls}
.define ENEMY_RAMROCK_ARMS $05

;;
.define ENEMY_VERAN_FAIRY $06

;;
; @palette{PALH_83}
.define ENEMY_RAMROCK $07

;;
; Spider that Veran spawns when fighting possessed Ambi. Spawns in a random position within
; the screen boundary. If used in a small room, it could spawn off-screen...
;
; @palette{PALH_8a}
; @postype{none}
.define ENEMY_VERAN_SPIDER $0f

;;
; Part of D4 boss (ENEMY_EYESOAR)
;
; @subid_00{Spawns above eyesoar}
; @subid_01{Right of eyesoar}
; @subid_02{Below eyesoar}
; @subid_03{Left of eyesoar}
.define ENEMY_EYESOAR_CHILD $11

;;
; Used by ENEMY_VERAN_FINAL_FORM. Flies at you, then despawns when off-screen.
;
; @subid_00{Moves down}
; @subid_01{Moves down-left}
; @subid_02{Moves up-right}
.define ENEMY_VERAN_CHILD_BEE $1f

;;
; This object automatically deletes itself if [relatedObj1.id] != ENEMY_ANGLER_FISH.
.define ENEMY_ANGLER_FISH_BUBBLE $26

;;
; This object allows down-transitions to work in the "donkey kong" sidescrolling area with
; vire. In particular, it forces a transition to occur if Link falls onto the bottom
; boundary of the screen, and is far enough to the right side of the screen.
.define ENEMY_ENABLE_SIDESCROLL_DOWN_TRANSITION $2b

;;
; Jellyfish enemy that splits in two. The large ones always hover close to their spawn
; position, the small ones move toward Link.
;
; @subid_00{Normal version}
; @subid_01{Small version}
.define ENEMY_BARI $3c

;;
; Smaller enemies used in Giant Ghini fight
; @subid{Value from $01-$03 or $81-$83. If bit 7 is set, the fight hasn't started yet.}
.define ENEMY_GIANT_GHINI_CHILD $3f

;;
; Smaller enemies used in shadow hag fight
.define ENEMY_SHADOW_HAG_BUG $42

;;
.define ENEMY_STUB_46 $46

;;
; Enemies in floor-tile-changing puzzles in Ages only.
; @palette{PALH_bf}
.define ENEMY_COLOR_CHANGING_GEL $47

;;
; Guard in Ambi's palace. Each guard has a preset patrol path. If bit 7 of the subid is
; set, the guard attacks you; otherwise it kicks you out immediately.
;
; @subid_00-0c{Throws you out when seen}
; @subid_80-8c{Attacks you when seen}
.define ENEMY_AMBI_GUARD $54

;;
.define ENEMY_CANDLE $55

;;
; "Decorative" moblins that don't do anything? Subids 0-3 have various positions?
;
; @subid_00{Left side}
; @subid_01{Right side}
.define ENEMY_KING_MOBLIN_MINION $56

;;
.define ENEMY_STUB_5b $5b

;;
.define ENEMY_STUB_5c $5c

;;
; Hardhat beetle that just pushes Link away. Has a purple tint.
;
; @palette{PALH_8d}
.define ENEMY_HARMLESS_HARDHAT_BEETLE $5f

;;
; Fight either Nayru or Ambi possessed by Nayru.
;
; This doesn't load the needed palette; assumes it's loaded already?
;
; @subid_00{Nayru}
; @subid_01{Ambi}
; @subid_02{Veran emerged}
; @subid_03{Collapsed Ambi in cutscene after the fight}
; @palette{PALH_85}
.define ENEMY_VERAN_POSSESSION_BOSS $61

;;
; Vine sprout. Each subid has a default position (see data/ages/defaultVinePositions.s);
; when moved, its position gets stored in "wVinePositions".
;
; If the vine is on the screen boundary, it will get "pushed" onto the next tile. Be
; careful with room layouts because the sprout could end up stuck in a wall.
;
; The room the vine is used in will need special code to call the "replaceVineTiles"
; function from the "applyRoomSpecificTileChanges" function, in order for it to grow
; properly.
;
; @postype{none}
; @subid_00-05{Valid values}
.define ENEMY_VINE_SPROUT $62

;;
; Crystals for target carts. Positions and movement behaviours are preset, depending on
; the value of "wTmpcfc0.targetCarts.targetConfiguration".
;
; @postype{none}
; @subid{Index ($00-$0b). Values 5+ are for the second room.}
.define ENEMY_TARGET_CART_CRYSTAL $63

;;
; Used in final battle against Veran. Almost identical to ENEMY_ARM_MIMIC aside from
; health and appearance.
;
; @palette{PALH_82}
.define ENEMY_LINK_MIMIC $64

;;
.define ENEMY_GIANT_GHINI $70

;;
.define ENEMY_SWOOP $71

;;
.define ENEMY_SUBTERROR $72

;;
; @subid_00{Spawner (use this)}
; @subid_01{Parent (the actual boss himself)}
; @subid_02{Shield}
; @subid_03{Sword}
.define ENEMY_ARMOS_WARRIOR $73

;;
; @subid_00{Ball (spawns parent)}
; @subid_01{Parent (smasher himself)}
.define ENEMY_SMASHER $74

;;
; @subid_00{The fish}
; @subid_01{His antenna (weak point)}
.define ENEMY_ANGLER_FISH $76

;;
; @subid_00{Spawner (use this)}
; @subid_01{Main object}
; @subid_02{Sickle hitbox}
; @subid_03{"Afterimage" visible when moving}
.define ENEMY_BLUE_STALFOS $77

;;
; @subid_00{Spawner (use this)}
; @subid_01{Body}
; @subid_02{Ghost}
; @subid_03{Head}
.define ENEMY_PUMPKIN_HEAD $78

;;
; @palette{PALH_81}
.define ENEMY_HEAD_THWOMP $79

;;
.define ENEMY_SHADOW_HAG $7a

;;
; @subid_00{Spawner; spawns subid 1 and 4 children}
; @subid_01{The main part of the boss}
.define ENEMY_EYESOAR $7b

;;
; Spawned by INTERAC_SMOG.
;
; Bit 7 of subid determines if moving clockwise or counterclockwise.
;
; @subid_00{Just starting the fight, shows text}
; @subid_01{Child from cutscene before fight starts}
; @subid_02{Small smog}
; @subid_03{Medium smog}
; @subid_04{Large smog}
; @subid_05{?}
; @subid_06{Immediately dies?}
; @var03{Phase of fight (from 0-3; affects projectile fire frequency)}
.define ENEMY_SMOG $7c

;;
; @subid_00{Above water}
; @subid_01{Below water}
; @subid_02{Invisible collision box for the shell}
.define ENEMY_OCTOGON $7d

;;
.define ENEMY_PLASMARINE $7e

;;
.define ENEMY_KING_MOBLIN $7f
