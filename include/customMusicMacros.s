
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


; Music-specific macros
; musInTheFields
.macro m_musInTheFieldsChannel4Measure8
	duty HI_VOL
	beat \1 S1
	duty LO_VOL
	beat \1 S2
	duty HI_VOL2
	beat \2 T5 r T6 \2 T7 r T8
.endm

; musGerudoValley
.macro m_musGerudoValleyChannel0Measure4
.rept 2
	vol HI_VOL
	beat \1 S1
	vol LO_VOL
	beat \1 S2 \1 S3
	beat \1 S4+S1 \1 S2+S3 \1 S4
.endr
.endm

; musDragonRoostIsland
.macro m_musDragonRoostIslandChannel1Measure8
	octave 5
	beat f R1 f R2 f R3
	beat f Y1 f Y2 f R2

	vol HI_VOL
	env $1 $00
.endm
.macro m_musDragonRoostIslandChannel1Measure8b
; Measure 8d
; Melody
	beat d R3
; Measure 9
	beat a Y1 as Y2+R2+R3
	beat a R1 as R2 g Y1 r Y2
; Measure 10
	beat ou c Q od a Q
; Measure 11
	beat a Y1

	vibrato VIBRATO
	beat g Y2+R2+R3
	vibrato $01
	env $0 $00
	vol LO_VOL
	beat g R1+R2
	vol LO_VOL-2
	beat g R3
; Measure 12
	vol HI_VOL
	vibrato VIBRATO
	env $1 $00
	beat d Q
	vol LO_VOL
	vibrato $01
	env $0 $00
	beat d R1
	
	vol HI_VOL
	vibrato $00
	env $1 $00
	beat f R2 d Y5 r Y6
; Measure 13
	beat a Y1 as Y2+R2+R3
	beat a R1 as R2 g Y1 r Y2
; Measure 14
	beat as Y1 ou c Y2+R2+R3 f Q
; Measure 15-16
	vibrato VIBRATO
	beat d HF
	vibrato $01
	env $0 $00
	vol LO_VOL	
	beat d R1+R2
	vol LO_VOL-2	
	beat d R3+R1
	
	vol HI_VOL
	vibrato $00
	env $1 $00	
	beat od as R2 as R3
; Measure 17-18
	beat ou c R1+R2+Y5 d Y6

	vibrato VIBRATO
	beat c Q
	vibrato $01
	env $0 $00
	vol LO_VOL	
	beat c R1+R2
	vol LO_VOL-2
	beat c R3+R1
	
	vol HI_VOL
	vibrato $00
	env $1 $00	
	beat od gs R2 ou c Y5 r Y6
; Measure 19-20
	beat od as Q

	vibrato VIBRATO
	beat g Q+Y1
	vibrato $01
	env $0 $00
	vol LO_VOL
	beat g Y2+R2
	vol LO_VOL-2	
	beat g R3+Y1 r Y2

	vol HI_VOL
	vibrato $00
	env $1 $00		
	beat g R2 as Y5 r Y6
; Measure 21-22
	beat ou c R1+R2+Y5 d Y6

	vibrato VIBRATO
	beat c Q+R1+R2
	vibrato $01
	env $0 $00
	vol LO_VOL	
	beat c R3+R1
	vol LO_VOL-2
	beat c R2
	
	vol HI_VOL
	vibrato $00
	env $1 $00	
	beat od as R3
; Measure 23-24a
	vibrato VIBRATO
	beat g Q+R1
	vibrato $01
	env $0 $00
	vol LO_VOL
	beat g R2+R3
	vol LO_VOL-2	
	beat g R1+R2

	vibrato $00
	env $0 $04
	vol LO_VOL
.endm
.macro m_musDragonRoostIslandChannel1Measure58b
; Measure 58b
	tempo TEMPO_1
	octave 6
	vibrato VIBRATO
	env $1 $00
	vol HI_VOL
	beat d R3 
; Measure 59-60
	beat g Q f Q d Q od as Q
; Measure 61-62
	beat ou c Q+R1
	env $0 $00
	vibrato $01
	vol LO_VOL
	beat c R2+R3+R1
	vol LO_VOL-2
	beat c R2+R3

	vol HI_VOL
	vibrato VIBRATO
	env $1 $00
	beat d R1 od g R2 as R3
; Measure 63
	beat ou c Q+R1+R2+Y5
.endm
.macro m_musDragonRoostIslandChannel0Measure5
	tempo TEMPO_1
	beat \1 R1 \1 Y3 \1 Y4 \1 R3
	beat \1 R1+R2 \1 R3
.endm
.macro m_musDragonRoostIslandChannel0Measure6
	tempo TEMPO_1
	beat \1 R1 \1 Y3 \1 Y4 \1 R3
	beat \1 R1 \1 R2 \1 R3
.endm
.macro m_musDragonRoostIslandChannel0Measure7
	tempo TEMPO_1
	beat \1 R1 \1 R2 \1 R3
	beat \1 Y1 \1 Y2 \1 R2 \1 R3
.endm
.macro m_musDragonRoostIslandChannel0Measure9
	tempo TEMPO_1
	beat \1 R1 \1 R2 \1 R3
	beat \1 R1 \1 R2 \1 R3
.endm
.macro m_musDragonRoostIslandChannel0Measure46
	tempo TEMPO_1
	beat \1 R1 \1 Y3 \1 Y4 \1 Y5 \1 Y6
	beat \1 R1 \1 R2 \1 R3
.endm
.macro m_musDragonRoostIslandChannel0Measure47
	tempo TEMPO_1
	beat \1 R1 \1 R2+R3
	beat \1 R1 \1 R2 \1 R3
.endm
.macro m_musDragonRoostIslandChannel0Measure62
	tempo TEMPO_1
	beat \1 R1 \1 Y3 \1 Y4 \1 Y5 \1 Y6
	beat \1 R1 \1 R2 \1 Y5 \1 Y6
.endm
.macro m_musDragonRoostIslandChannel0Measure75
	tempo TEMPO_1
	beat \1 R1 \1 R2 \1 R3
	beat \1 R1+R2 \1 R3
.endm
.macro m_musDragonRoostIslandChannel4Measure5
	tempo TEMPO_1
	duty HI_VOL
	beat \1 Y1
	duty LO_VOL
	beat \1 Y2 r R2+R3

	duty HI_VOL
	beat \1+7 Y1
	duty LO_VOL
	beat \1+7 Y2 r R2

	duty HI_VOL
	beat \1+12 Y5
	duty LO_VOL
	beat \1+12 Y6
.endm
.macro m_musDragonRoostIslandChannel4Measure6
	tempo TEMPO_2
	duty HI_VOL
	beat \1 S1
	duty LO_VOL
	beat \1 S2 r E2

	duty HI_VOL
	beat \1+7 S1
	duty LO_VOL
	beat \1+7 S2 r E2

	duty HI_VOL
	beat \1+12 S1
	duty LO_VOL
	beat \1+12 S2 r E2
.endm
.macro m_musDragonRoostIslandChannel4Measure27
; Measure 27
	tempo TEMPO_1
	duty HI_VOL
	beat \1 R1 
	duty LO_VOL
	beat \1 Y3 r Y4

	duty HI_VOL
	beat \1 Y5
	beat LO_VOL
	beat \1 Y6

	duty HI_VOL
	beat \1+7 R1
	duty LO_VOL
	beat \1+12 Y3 r Y4
	duty HI_VOL
	beat \1+12 R3
.endm
.macro m_musDragonRoostIslandChannel4Measure28
	tempo TEMPO_2
	duty HI_VOL
	beat \1 E1
	duty LO_VOL
	beat \1 E2
	
	duty HI_VOL
	beat \1+7 E1
	duty LO_VOL
	beat \1+7 E2	

	duty HI_VOL
	beat \1+12 E1
	duty LO_VOL
	beat \1+12 E2
.endm
.macro m_musDragonRoostIslandChannel4Measure30
; Measure 30
	tempo TEMPO_2
	duty HI_VOL
	beat \1 E1
	duty LO_VOL
	beat \1 E2

	duty HI_VOL
	beat \1+7 E1
	duty LO_VOL
	beat \1+7 E2	

	duty HI_VOL
	beat \1 E1
	duty LO_VOL
	beat \1 E2
.endm
.macro m_musDragonRoostIslandChannel4Measure48
	tempo TEMPO_1
	octave 4
	duty HI_VOL
	beat d R1 c R2 od g Y5 r Y6
	beat c R1 ou c R2 od c R3
; Measure 49
	tempo TEMPO_2
	octaved
	beat b E1 r E2 b S1 r S2
	beat ou ds E2 r E1 gs S3 r S4	
; Measure 50
	tempo TEMPO_1
	beat as R1 gs R2 od gs Y5 r Y6
	beat gs R1 ou gs R2 od gs R3
.endm
.macro m_musDragonRoostIslandChannel4Measure59
	tempo TEMPO_1
	duty HI_VOL
	beat \1 R1 
	duty LO_VOL
	beat \1 Y3 r Y4

	duty HI_VOL
	beat \1 Y5
	beat LO_VOL
	beat \1 Y6

	duty HI_VOL
	beat \1+7 R1
	duty LO_VOL
	beat \1+7 Y3 r Y4

	duty HI_VOL
	beat \1-5 R3
.endm
.macro m_musDragonRoostIslandChannel4Measure60
	tempo TEMPO_2
	beat \1 E1
	duty LO_VOL
	beat \1 E2	

	duty HI_VOL
	beat \1+7 S1
	duty LO_VOL
	beat \1+7 S2

	duty HI_VOL
	beat \1+7 S3 r S4	

	duty HI_VOL
	beat \1-5 E1
	duty LO_VOL
	beat \1-5 E2
.endm
.macro m_musDragonRoostIslandChannel4Measure62
	tempo TEMPO_2
	duty HI_VOL
	beat \1 S1
	duty LO_VOL
	beat \1 S2

	duty HI_VOL
	beat \1 S3 r S4

	beat \1+7 E1
	duty LO_VOL
	beat \1+7 E2	

	duty HI_VOL
	beat \1 E1
	duty LO_VOL
	beat \1 E2
.endm
.macro m_musDragonRoostIslandChannel6Measure1
; Measure 1
	tempo TEMPO_1
.rept 2
   	vol HI_VOL
   	beat HIT R1
   	vol LO_VOL
   	beat HIT R2
	beat HIT R3
.endr

; Measure 2
tempo TEMPO_2
.rept 3
	vol HI_VOL
	beat HIT E1
	vol LO_VOL
	beat HIT E2
.endr
.endm
.macro m_musDragonRoostIslandChannel6Measure3
; Measure 3
tempo TEMPO_1
.rept 2
   	vol HI_VOL
   	beat HIT R1
   	vol LO_VOL
   	beat HIT R2
	beat HIT R3
.endr
; Measure 4
tempo TEMPO_2
	vol HI_VOL
	beat HIT E1
.rept 2
	vol LO_VOL
	beat HIT S3 HIT S4
	vol HI_VOL
	beat HIT E1
.endr
	vol LO_VOL
	beat HIT E2
.endm