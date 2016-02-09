; 0c-56: set frequency

; 60:

; 61:

; d0-df: set volume
.macro vol
	.if \1 > $f
		.fail
	.endif
	.db $d0 | \1
.endm

; f0: might mute the channel?
.macro cmdf0
	.db $f0
.endm

; f1: jump to the given address
.macro jump
	.db $f1
	.dw \1
.endm

; f2: sets wC033
.macro cmdf2
	.db $f2 \1
.endm

; f3-f5: duplicates of f0?

; f6: sets wC04b
.macro cmdf6
	.db $f6 \1
.endm

; f7: sets wC03f
.macro cmdf7
	.db $f7 \1
.endm

; f8: duplicate of f0?

; f9: sets wC057
.macro cmdf9
	.db $f9 \1
.endm

; fa-fb: duplicates of f0?

; fc-fe: does nothing

; ff: unknown
.macro cmdff
	.db $ff \1
.endm
