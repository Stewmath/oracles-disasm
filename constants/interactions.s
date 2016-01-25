; The first $c interactions consist of various animations.
; SubID:
;  Bit 0 - flicker to create transparency
;  Bit 7 - disable sound effect
.define INTERACTION_GRASSDEBRIS		$00
.define INTERACTION_REDGRASSDEBRIS	$01
.define INTERACTION_GREENPOOF		$02
.define INTERACTION_SPLASH		$03
.define INTERACTION_LAVASPLASH		$04
.define INTERACTION_PUFF		$05
.define INTERACTION_ROCKDEBRIS		$06
.define INTERACTION_CLINK		$07
.define INTERACTION_KILLENEMYPUFF	$08
.define INTERACTION_SNOWDEBRIS		$09
.define INTERACTION_SHOVELDEBRIS	$0a
.define INTERACTION_0B			$0b
.define INTERACTION_ROCKDEBRIS2		$0c

; SubID: 
;  Bit 7 - disable sound effect
.define INTERACTION_FALLDOWNHOLE	$0f

.define INTERACTION_FARORE		$10
; SubID: xy
;  y=0: "Parent" interaction
;  y=1: "Children" sparkles
;  x: for y=1, this sets the sparkle's initial moving direction
.define INTERACTION_FARORE_MAKEITEM	$11

; SubID:
;  00: Show text on entering dungeon
;  01: Small key falls when wNumEnemies == 0
;  02:
;  03:
;  04:
.define INTERACTION_DUNGEON_STUFF	$12

.define INTERACTION_84			$84
.define INTERACTION_90			$90
