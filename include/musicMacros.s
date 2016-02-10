.macro m_soundPointer
	.db :\1Start - $39
	.dw \1
.endm

; 0c-56: set frequency
; Byte that follows is how long to wait?
.macro note
	.db \1
	.db \2
.endm
; 60/61: set wait counters.

.macro wait1
	.db $60 \1
.endm

.macro wait2
	.db $61 \1
.endm

; d0-df: set volume
.macro vol
	.if \1 > $f
		.fail
	.endif
	.db $d0 | \1
.endm

; e0-e7: set envelopes
.macro env
	.if \1 > $7
		.fail
	.endif
	.db $e0 | \1
	.db \2
.endm

; e8-ef: same as e0-e7

; f0: unknown
; Sometimes sets wC039
.macro cmdf0
	.db $f0 \1
.endm

; f1-f3: does nothing
.macro cmdf1
	.db $f1
.endm
.macro cmdf2
	.db $f2
.endm
.macro cmdf3
	.db $f3
.endm

; f4-f5: duplicates of ff?
.macro cmdf4
	.db $f4
.endm
.macro cmdf5
	.db $f5
.endm

; f6: sets wChannelDutyCycles
.macro duty
	.db $f6 \1
.endm

; f7: duplicate of ff?

; f8: sets wC03f (for channels 0-5)
.macro cmdf8
	.db $f8 \1
.endm

; f9: sets wChannelVibratos
.macro vibrato
	.db $f9 \1
.endm

; fa-fc: duplicates of ff?

; fd: sets wC033
.macro cmdfd
	.db $fd \1
.endm

; fe: jump to the given address
.macro goto
	.db $fe
	.dw \1
.endm

; ff: might mute the channel?
.macro cmdff
	.db $ff
.endm
