.define TEXTBOXFLAG_NOCOLORS		$01
.define TEXTBOXFLAG_NONEXITABLE		$02

; This changes the palette the textbox uses. It is meant to be used when all
; the other palettes are black. Eg: when link get's the harp.
; It also prevents "special objects" from being drawn - objects from
; $d100-$d13f, to $d500-$d53f.
.define TEXTBOXFLAG_ALTPALETTE1		$04

; When set, wTextboxPosition isn't calculated based on link's position. If this is set,
; then wTextboxPosition should be set to the desired value by the caller.
; Used on the map screen.
.define TEXTBOXFLAG_DONTCHECKPOSITION		$08

; This changes the palette the textbox uses.
.define TEXTBOXFLAG_ALTPALETTE2			$10


.define TEXTBOXFLAG_BIT_NOCOLORS		0
.define TEXTBOXFLAG_BIT_NONEXITABLE		1
.define TEXTBOXFLAG_BIT_ALTPALETTE1		2
.define TEXTBOXFLAG_BIT_DONTCHECKPOSITION	3
.define TEXTBOXFLAG_BIT_ALTPALETTE2		4
