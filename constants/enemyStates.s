; Enemy states 0-7 share common meanings among all enemies. Certain actions can write to
; enemy states directly, ie. using switch hook on them.
;
; States 8+ are free to be defined per-enemy.

.enum 0
	ENEMYSTATE_UNINITIALIZED	db
	ENEMYSTATE_1			db
	ENEMYSTATE_GRABBED		db
	ENEMYSTATE_SWITCH_HOOK		db
	ENEMYSTATE_MOVING_TO_SCENT_SEED	db
	ENEMYSTATE_GALESEED		db
	ENEMYSTATE_6			db
	ENEMYSTATE_7			db
.ende

; There is also enemy "status", returned from "enemyStandardUpdate" function.

.enum 0
	ENEMYSTATUS_NORMAL		db ; $00
	ENEMYSTATUS_01			db ; $01 (unused?)
	ENEMYSTATUS_STUNNED		db ; $02
	ENEMYSTATUS_NO_HEALTH		db ; $03
	ENEMYSTATUS_JUST_HIT		db ; $04
	ENEMYSTATUS_KNOCKBACK		db ; $05
.ende
