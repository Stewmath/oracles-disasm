
; MUSIC: Custom music macros

.macro tempo
.redefine BEAT 1
.redefine NOTE_END_WAIT 0
.redefine Q (150*24 - (150*24) # \1) / \1

.if 2*((150*24) # \1) >= \1
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

.macro m_splitLength
	.if \1 == Q
		.redefine HF1 E1
		.redefine HF2 E2

		.redefine TR1 R1
		.redefine TR2 R2
		.redefine TR3 R3
	.else
	.if \1 == E1
		.redefine HF1 S1
		.redefine HF2 S2

		.redefine TR1 Y1
		.redefine TR2 Y2
		.redefine TR3 Y3
	.else
	.if \1 == E2
		.redefine HF1 S3
		.redefine HF2 S4

		.redefine TR1 Y4
		.redefine TR2 Y5
		.redefine TR3 Y6
	.else
		.fail
	.endif
	.endif
	.endif
.endm

.redefine ch4 (-4)

.macro echobeat
	.redefine offset 0
		.if \1 == ch4
			.define CHANNEL_4 1
			.shift
		.else
			.ifdef CHANNEL_4
				.undefine CHANNEL_4
			.endif
		.endif

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
; TODO: Figure out why ou/od doesn't work after the initial note
		.if NARGS >= 2
		.if \1 == r
			rest \2*BEAT
			.shift
			.shift
		.else
		.if \1 >= 0
			.ifdef CH4
				duty HI_VOL
			.else
				vol HI_VOL
			.endif

			m_splitLength \2
			.db \1+offset
			.db HF1*BEAT

			.ifdef CH4
				duty LO_VOL
			.else
				vol LO_VOL
			.endif

			.ifdef ECHO_NOTE
				beat ECHO_NOTE HF2
			.else
				rest HF2
			.endif

			.redefine ECHO_NOTE \1+offset
			.shift
			.shift
		.endif
		.endif
		.endif
	.endr
.endm