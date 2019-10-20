.enum $0
	c1: db
	cs1: db
	d1: db
	ds1: db
	e1: db
	f1: db
	fs1: db
	g1: db
	gs1: db
	a1: db
	as1: db
	b1: db
	c2: db
	cs2: db
	d2: db
	ds2: db
	e2: db
	f2: db
	fs2: db
	g2: db
	gs2: db
	a2: db
	as2: db
	b2: db
	c3: db
	cs3: db
	d3: db
	ds3: db
	e3: db
	f3: db
	fs3: db
	g3: db
	gs3: db
	a3: db
	as3: db
	b3: db
	c4: db
	cs4: db
	d4: db
	ds4: db
	e4: db
	f4: db
	fs4: db
	g4: db
	gs4: db
	a4: db
	as4: db
	b4: db
	c5: db
	cs5: db
	d5: db
	ds5: db
	e5: db
	f5: db
	fs5: db
	g5: db
	gs5: db
	a5: db
	as5: db
	b5: db
	c6: db
	cs6: db
	d6: db
	ds6: db
	e6: db
	f6: db
	fs6: db
	g6: db
	gs6: db
	a6: db
	as6: db
	b6: db
	c7: db
	cs7: db
	d7: db
	ds7: db
	e7: db
	f7: db
	fs7: db
	g7: db
	gs7: db
	a7: db
	as7: db
	b7: db
	c8: db
	cs8: db
	d8: db
	ds8: db
	e8: db
	f8: db
	fs8: db
	g8: db
	gs8: db
	a8: db
	as8: db
	b8: db
.ende

.redefine od (-1)
.redefine ou (-2)
.redefine r (-3)

.macro octave
	.redefine OCTAVE \1
	.redefine OFFSET (-$c)

	.redefine c 12*\1+0 + OFFSET
	.redefine cs 12*\1+1 + OFFSET
	.redefine d 12*\1+2 + OFFSET
	.redefine ds 12*\1+3 + OFFSET
	.redefine e 12*\1+4 + OFFSET
	.redefine f 12*\1+5 + OFFSET
	.redefine fs 12*\1+6 + OFFSET
	.redefine g 12*\1+7 + OFFSET
	.redefine gs 12*\1+8 + OFFSET
	.redefine a 12*\1+9 + OFFSET
	.redefine as 12*\1+10 + OFFSET
	.redefine b 12*\1+11 + OFFSET
.endm

.macro octaved
	octave OCTAVE-1
.endm
.macro octaveu
	octave OCTAVE+1
.endm

.macro m_soundPointer
	.db :\1Start - $39
	.dw \1
.endm

; Byte 1: frequency
; Byte 2: length
;
; Frequencies for noise:
; 22,23,24,26,27,28,29,2a,2e,2f,30,32,52
.macro note
	.redefine offset 0
	.rept NARGS
	.if NARGS >= 1
		.if \1 == od
			octaved
			.redefine offset offset-12
			.shift
		.else
		.if \1 == ou
			octaveu
			.redefine offset offset+12
			.shift
		.endif
		.endif
	.endif

	.if NARGS >= 2
	.if \1 == r
		wait1 \2
		.shift
		.shift
	.else
	.if \1 >= 0
		.db \1+offset
		.db \2

		.shift
		.shift
	.endif
	.endif
	.endif
	.endr
.endm

.macro beat
	.redefine offset 0
	.rept NARGS
	.if NARGS >= 1
		.if \1 == od
			octaved
			.redefine offset offset-12
			.shift
		.else
		.if \1 == ou
			octaveu
			.redefine offset offset+12
			.shift
		.endif
		.endif
	.endif

	.if NARGS >= 2
	.if \1 == r
		wait1 \2*BEAT
		.shift
		.shift
	.else
	.if \1 >= 0
		.db \1+offset

		.ifndef NOTE_END_WAIT
			.define NOTE_END_WAIT 0
		.endif

		.if NOTE_END_WAIT != 0
			.db \2*BEAT - NOTE_END_WAIT
			wait1 NOTE_END_WAIT
		.else
			.db \2*BEAT
		.endif

		.shift
		.shift
	.endif
	.endif
	.endif
	.endr
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
; Sometimes sets wc039
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

; f8: sets wc03f (for channels 0-5)
.macro cmdf8
	.db $f8 \1
.endm

; f9: sets wChannelVibratos
.macro vibrato
	.db $f9 \1
.endm

; fa-fc: duplicates of ff?

; fd: sets wc033
; Shifts pitch
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
