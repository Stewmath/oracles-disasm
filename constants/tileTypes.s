; Definitions for overworld areas

.define TILETYPE_NORMAL		$00
.define TILETYPE_HOLE		$01
.define TILETYPE_WARPHOLE	$02
.define TILETYPE_CRACKEDFLOOR	$03
.define TILETYPE_VINES		$04
.define TILETYPE_GRASS		$05
.define TILETYPE_STAIRS		$06
.define TILETYPE_WATER		$07

; Causes Link's sword to do a poke on these tiles?
; Link can't pass through these tiles when transformed?
.define TILETYPE_UNKNOWN	$08

.define TILETYPE_UPCONVEYOR	$09
.define TILETYPE_RIGHTCONVEYOR	$0a
.define TILETYPE_DOWNCONVEYOR	$0b
.define TILETYPE_LEFTCONVEYOR	$0c
.define TILETYPE_SPIKE		$0d
.define TILETYPE_NOTHING	$0e ; This is a stub? Dimitri checks for this?
.define TILETYPE_ICE		$0f
.define TILETYPE_LAVA		$10
.define TILETYPE_PUDDLE		$11
.define TILETYPE_UPCURRENT	$12
.define TILETYPE_RIGHTCURRENT	$13
.define TILETYPE_DOWNCURRENT	$14
.define TILETYPE_LEFTCURRENT	$15
.define TILETYPE_RAISABLE_FLOOR	$16
.define TILETYPE_SEAWATER	$17
.define TILETYPE_WHIRLPOOL	$18

; Sidescrolling areas follow a different set of rules; each bit represents a certain
; behaviour.

; This looks the same as other tiles, but it instantly respawns Link. A "death boundary".
.define TILETYPE_SS_HOLE	$01
.define TILETYPE_SS_LAVA	$04 ; Unused?
.define TILETYPE_SS_LADDER	$10
.define TILETYPE_SS_WATER	$20
.define TILETYPE_SS_ICE		$40
.define TILETYPE_SS_LADDER_TOP	$80

.define TILETYPE_SS_BIT_HOLE		0
.define TILETYPE_SS_BIT_LAVA		2
.define TILETYPE_SS_BIT_LADDER		4
.define TILETYPE_SS_BIT_WATER		5
.define TILETYPE_SS_BIT_ICE		6
.define TILETYPE_SS_BIT_LADDER_TOP	7
