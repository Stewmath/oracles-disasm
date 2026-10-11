; Musical notes, usable on square & wave channels
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

; Other values that can be use within note/beat macros
.redefine od (-1) ; octave down
.redefine ou (-2) ; octave up
.redefine r (-3)  ; rest

; Define relative notes names within a given octave
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
	.db :\1Start - :b39_initSound ; Bank number
	.dw \1 ; Pointer
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
		rest \2
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

; This is NOT used by the base game; it's an attempt to provide a more sane way to define music
; (multiple notes per line). Each pair of arguments is a note followed by a length. Can define
; "NOTE_END_WAIT" to set a certain amount of a note to be "rest" instead of being actually played.
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
		rest \2*BEAT
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
			rest NOTE_END_WAIT
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

; Sets up note-length constants (T1-T8, W1-W12, and their groupings) for a given tempo, in beats
; per minute. BEAT is set to 1, so "beat"/"note" length arguments become raw frame counts scaled
; off Q (frames per beat at this tempo). Ported from a Tarm Ruins-era macro set; not tied to any
; particular song and safe to call multiple times (e.g. once per tempo change within a song).
.macro tempo
	.redefine Q (150*24 - (150*24) # \1) / \1

	.if ((150*24) # \1) >= 0.5*\1
		.redefine Q Q+1
	.endif

	.redefine T1 (Q - (Q # 8))/8
	.redefine T2 (Q * 2 - ((Q * 2) # 8))/8 - T1
	.redefine T3 (Q * 3 - ((Q * 3) # 8))/8 - (T1+T2)
	.redefine T4 (Q * 4 - ((Q * 4) # 8))/8 - (T1+T2+T3)
	.redefine T5 (Q * 5 - ((Q * 5) # 8))/8 - (T1+T2+T3+T4)
	.redefine T6 (Q * 6 - ((Q * 6) # 8))/8 - (T1+T2+T3+T4+T5)
	.redefine T7 (Q * 7 - ((Q * 7) # 8))/8 - (T1+T2+T3+T4+T5+T6)
	.redefine T8 (Q * 8 - ((Q * 8) # 8))/8 - (T1+T2+T3+T4+T5+T6+T7)

	.redefine S1 T1+T2
	.redefine S2 T3+T4
	.redefine S3 T5+T6
	.redefine S4 T7+T8
	.redefine E1 S1+S2
	.redefine E2 S3+S4
	.redefine HF Q*2
	.redefine W Q*4
	.redefine BEAT 1

	.redefine W1 (Q - (Q # 12))/12
	.redefine W2 (Q * 2 - ((Q * 2) # 12))/12 - W1
	.redefine W3 (Q * 3 - ((Q * 3) # 12))/12 - (W1+W2)
	.redefine W4 (Q * 4 - ((Q * 4) # 12))/12 - (W1+W2+W3)
	.redefine W5 (Q * 5 - ((Q * 5) # 12))/12 - (W1+W2+W3+W4)
	.redefine W6 (Q * 6 - ((Q * 6) # 12))/12 - (W1+W2+W3+W4+W5)
	.redefine W7 (Q * 7 - ((Q * 7) # 12))/12 - (W1+W2+W3+W4+W5+W6)
	.redefine W8 (Q * 8 - ((Q * 8) # 12))/12 - (W1+W2+W3+W4+W5+W6+W7)
	.redefine W9 (Q * 9 - ((Q * 9) # 12))/12 - (W1+W2+W3+W4+W5+W6+W7+W8)
	.redefine W10 (Q * 10 - ((Q * 10) # 12))/12 - (W1+W2+W3+W4+W5+W6+W7+W8+W9)
	.redefine W11 (Q * 11 - ((Q * 11) # 12))/12 - (W1+W2+W3+W4+W5+W6+W7+W8+W9+W10)
	.redefine W12 (Q * 12 - ((Q * 12) # 12))/12 - (W1+W2+W3+W4+W5+W6+W7+W8+W9+W10+W11)

	.redefine Y1 W1+W2
	.redefine Y2 W3+W4
	.redefine Y3 W5+W6
	.redefine Y4 W7+W8
	.redefine Y5 W9+W10
	.redefine Y6 W11+W12
	.redefine R1 Y1+Y2
	.redefine R2 Y3+Y4
	.redefine R3 Y5+Y6
.endm

; Picks out the pair of "tempo" length constants that split a given note-length symbol (\1: one
; of Q, E1, E2) in half, rebinding them to HF1/HF2 (halves), TR1-3/QR1-4/SX1-6 (thirds/quarters/
; sixths of \1). Lets a beat-style macro divide a note of length \1 into a shorter attack and a
; release without hardcoding which "tempo" constants apply at each note-length tier.
.macro m_splitLength
	.if \1 == Q
		.redefine HF1 E1
		.redefine HF2 E2

		.redefine TR1 R1
		.redefine TR2 R2
		.redefine TR3 R3

		.redefine QR1 S1
		.redefine QR2 S2
		.redefine QR3 S3
		.redefine QR4 S4

		.redefine SX1 Y1
		.redefine SX2 Y2
		.redefine SX3 Y3
		.redefine SX4 Y4
		.redefine SX5 Y5
		.redefine SX6 Y6
	.else
	.if \1 == E1
		.redefine HF1 S1
		.redefine HF2 S2

		.redefine TR1 Y1
		.redefine TR2 Y2
		.redefine TR3 Y3

		.redefine QR1 T1
		.redefine QR2 T2
		.redefine QR3 T3
		.redefine QR4 T4

		.redefine SX1 W1
		.redefine SX2 W2
		.redefine SX3 W3
		.redefine SX4 W4
		.redefine SX5 W5
		.redefine SX6 W6
	.else
	.if \1 == E2
		.redefine HF1 S3
		.redefine HF2 S4

		.redefine TR1 Y4
		.redefine TR2 Y5
		.redefine TR3 Y6

		.redefine QR1 T5
		.redefine QR2 T6
		.redefine QR3 T7
		.redefine QR4 T8

		.redefine SX1 W7
		.redefine SX2 W8
		.redefine SX3 W9
		.redefine SX4 W10
		.redefine SX5 W11
		.redefine SX6 W12
	.else
		.fail
	.endif
	.endif
	.endif
.endm

; 60: rest, stops playing the previous note and sets wait counter
.macro rest
	.db $60 \1
.endm

; 61: extends the currently playing note/rest without retriggering or otherwise
;     affecting it. this is a tie/sustain, not a rest.
;	  the existing rest macro (60) is bugged: it behaves like a sustain, so they are both coded to sustain the note.
;	  this true sustain command is unused in all vanilla songs, utilizing cmd60 (rest) for all of its wait durations between notes.
.macro sust
	.db $61 \1
.endm

; d0-df: set volume (for channels 0-3, 6 and 7)
.macro vol
	.if \1 > $f
		.fail
	.endif
	.db $d0 | \1
.endm

; e0-e7: set envelope (\1 $0-$7: software-simulated attack envelope speed, starting at volume 1 and
;        snapping to the note's target volume after a fixed delay)
;        and increasing to volume 15 entirely in hardware at the given speed (\1 & $7)
; \2 ($0-$7 either way): decay speed -- an exact hardware envelope match in both cases,
;        decreasing from the note's target volume to 0
.macro env
	.if \1 > $f
		.fail
	.endif
	.db $e0 | \1
	.db \2
.endm

; f0: unknown
; Sometimes sets wc039
.macro cmdf0
	.db $f0 \1
.endm

; f1-f3: does nothing
.macro cmdf1
; f1-f3: Unused as bare no-op bytes by every vanilla song: may be repurposed (patternCall / patternEnd, perhaps?)
	.db $f1
.endm
.macro cmdf2
	.db $f2
.endm
.macro cmdf3
	.db $f3
.endm

; f4-f5: duplicates of ff
.macro cmdf4
	.db $f4
.endm
.macro cmdf5
	.db $f5
.endm

; f6: sets wChannelDutyCycles (for channels 0-5)
.macro duty
	.db $f6 \1
.endm

; f7: duplicate of ff


; f8: continuous pitch slide (channels 0-5 only). \1 is a signed byte, re-added to the note's frequency every
; single frame for as long as it stays nonzero, so the pitch keeps sliding
; indefinitely rather than settling on a target (the latter behavior would be "portamento")
; Use "pitchSlide $00" to stop an ongoing slide.
.macro pitchSlide
	.db $f8 \1
.endm

; f9: sets wChannelVibratos (for channels 0-5)
; Upper nibble is time to wait until vibrato starts.
; Lower nibble is intensity of vibrato.
.macro vibrato
	.db $f9 \1
.endm

; fa-fc: duplicates of ff

; fd: flat pitch offset (channels 0-5 only, i.e. pulse/wave, both the music
; and sfx slots; a no-op on noise, 6-7). \1 is a signed byte, added once to the frequency
; every time a note triggers on this channel and held constant for that note's whole duration.
; Use pitchOffset $00 to disable again.
.macro pitchOffset
	.db $fd \1
.endm

; fe: jump to the given address
.macro goto
	.db $fe
	.dw \1
.endm

; ff: disables the channel
.macro cmdff
	.db $ff
.endm


; Parameters:
;   \1: Index
;   \2: Name
.macro m_waveform
	.DEFINE \2, \1 EXPORT
	@waveform{%.2x{\1}}:
.endm
