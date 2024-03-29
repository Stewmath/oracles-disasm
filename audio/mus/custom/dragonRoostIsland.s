musDragonRoostIslandStart:
.redefine TEMPO_1 120
.redefine TEMPO_2 TEMPO_1*3/2
	tempo TEMPO_1

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

musDragonRoostIslandChannel1:
	.redefine HI_VOL $6
	.redefine LO_VOL $4
	.redefine VIBRATO $e1
	; Measure 1-4
		tempo TEMPO_1
		octave 4
		vol LO_VOL
		duty $02
		env $0 $04
	
		beat d R1 d Y3 d Y4 d R3
		beat d Q+HF r W

; Measure 5
	m_musDragonRoostIslandChannel0Measure5 g5
; Measure 6
	m_musDragonRoostIslandChannel0Measure6 f5
; Measure 7
	m_musDragonRoostIslandChannel0Measure7 g5
; Measure 8-24a
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
	m_musDragonRoostIslandChannel1Measure8
	m_musDragonRoostIslandChannel1Measure8b
; Measure 24a
	tempo TEMPO_1
	octave 5
	beat ds R3 ds R1 ds R2 ds R3
; Measure 26
	m_musDragonRoostIslandChannel0Measure7 g5
; Measure 26
	m_musDragonRoostIslandChannel0Measure6 ds5

musDragonRoostIslandChannel1Loop:
; Measure 27
	m_musDragonRoostIslandChannel0Measure5 g5
; Measure 28
	m_musDragonRoostIslandChannel0Measure5 f5
; Measure 29
	m_musDragonRoostIslandChannel0Measure7 g5
; Measure 30-46a
	m_musDragonRoostIslandChannel1Measure8
	m_musDragonRoostIslandChannel1Measure8b
; Measure 46a
	tempo TEMPO_1
	octave 5
	beat ds Y5 ds Y6
	beat ds R1 d R2 d R3
; Measure 47
	m_musDragonRoostIslandChannel0Measure47 c5
; Measure 48
	octave 5
	beat c R1 c Y3 c Y4 c Y5 c Y6
	beat c R1 c R2
; Melody 
	env $1 $00
	vol HI_VOL
	beat f R3
; Measure 49
	beat as Y1
	vibrato VIBRATO
	beat g Y2+R2+R3+R1
	vibrato $01
	env $0 $00
	vol LO_VOL
	beat g R2+R3
	vol LO_VOL-2
	beat g R1+R2

	vibrato $00
	env $0 $04
	vol LO_VOL
	beat g R3 g R1+R2 g R3
; Measure 51
	m_musDragonRoostIslandChannel0Measure5 g5
; Measure 52
	m_musDragonRoostIslandChannel0Measure6 f5
; Measure 53
	m_musDragonRoostIslandChannel0Measure7 g5
; Measure 54
	m_musDragonRoostIslandChannel0Measure7 f5
; Measure 55
	m_musDragonRoostIslandChannel0Measure6 g5
; Measure 56
	m_musDragonRoostIslandChannel0Measure6 f5
; Measure 57
	m_musDragonRoostIslandChannel0Measure7 g5
; Measure 58
	m_musDragonRoostIslandChannel1Measure8
; Measure 58b-63b
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
	m_musDragonRoostIslandChannel1Measure58b
; Measure 63b-64
	octave 6
	env $0 $00
	beat c Y6
	vol LO_VOL
	vibrato $01
	beat c Q
	vol LO_VOL-2
	beat c R1+R2

	vol HI_VOL
	vibrato VIBRATO
	env $1 $00
	beat od as R3
; Measure 65-66b
	beat ou c HF
	vibrato $01
	env $0 $00
	vol LO_VOL	
	beat c R1+R2
	vol LO_VOL-2	
	beat c R3+R1 r R2
; Measure 66b-71b
	m_musDragonRoostIslandChannel1Measure58b
	octave 6
	beat d Y6
; Measure 72
	beat c Q
	vibrato $01
	vol LO_VOL	
	beat c R1+R2
	
	vol HI_VOL
	env $1 $00
	vibrato VIBRATO
	beat od as R3 
; Measure 73-74
	beat ou c Q
	vibrato $01
	env $0 $00
	vol LO_VOL
	beat c Q
	vol LO_VOL-2	
	beat c R1+R2

	vibrato $00
	env $0 $04
	vol LO_VOL
	octaved
	beat g R3 g R1+R2 g R3
; Measire 75-76
	m_musDragonRoostIslandChannel0Measure75 g5
; Measure 76
	m_musDragonRoostIslandChannel0Measure46 g5
	
	goto musDragonRoostIslandChannel1Loop
	cmdff

musDragonRoostIslandChannel0:
.redefine HI_VOL $4
.redefine LO_VOL $2
; Measure 1-4
	tempo TEMPO_1
	octave 3
	vol HI_VOL
	duty $02
	env $0 $04

	beat a R1 a Y3 a Y4 a R3
	beat a Q+HF r W
; Measure 5
	m_musDragonRoostIslandChannel0Measure5 d4
; Measure 6
	m_musDragonRoostIslandChannel0Measure6 c4
; Measure 7
	m_musDragonRoostIslandChannel0Measure7 d4
; Measure 8
	m_musDragonRoostIslandChannel0Measure7 c4
; Measure 9-14
	m_musDragonRoostIslandChannel0Measure9 as4
; Measure 10
	m_musDragonRoostIslandChannel0Measure6 a4
; Measure 11
	m_musDragonRoostIslandChannel0Measure6 g4
; Measure 12
	m_musDragonRoostIslandChannel0Measure6 a4
; Measure 13
	m_musDragonRoostIslandChannel0Measure9 as4
; Measure 14
	m_musDragonRoostIslandChannel0Measure9 a4
; Measure 15
	m_musDragonRoostIslandChannel0Measure7 d5 
; Measure 16
	m_musDragonRoostIslandChannel0Measure6 as4
; Measure 17
	m_musDragonRoostIslandChannel0Measure9 c5
; Measure 18
	m_musDragonRoostIslandChannel0Measure6 c5
; Measure 19
	m_musDragonRoostIslandChannel0Measure6 as4
; Measure 20
	m_musDragonRoostIslandChannel0Measure7 d5
; Measure 21
	m_musDragonRoostIslandChannel0Measure6 c5
; Measure 23
	m_musDragonRoostIslandChannel0Measure6 a4
; Measure 23
	m_musDragonRoostIslandChannel0Measure7 g4
; Measure 24-26
	m_musDragonRoostIslandChannel0Measure6 as4
; Measure 25
	m_musDragonRoostIslandChannel0Measure7 as4
; Measure 26
	m_musDragonRoostIslandChannel0Measure6 as4

musDragonRoostIslandChannel0Measure27Loop:
; Measure 27
	m_musDragonRoostIslandChannel0Measure5 as4
; Measure 28
	m_musDragonRoostIslandChannel0Measure6 a4
; Measure 29
	m_musDragonRoostIslandChannel0Measure7 as4
; Measure 30
	m_musDragonRoostIslandChannel0Measure7 a4
; Measure 31
	m_musDragonRoostIslandChannel0Measure9 as4

; Measure 32
	m_musDragonRoostIslandChannel0Measure6 a4
; Measure 33
	m_musDragonRoostIslandChannel0Measure6 g4
; Measure 34
	m_musDragonRoostIslandChannel0Measure6 a4
; Measure 35
	m_musDragonRoostIslandChannel0Measure9 as4
; Measure 36
	m_musDragonRoostIslandChannel0Measure9 a4
; Measure 37
	m_musDragonRoostIslandChannel0Measure7 d5
; Measure 38
	m_musDragonRoostIslandChannel0Measure6 as4
; Measure 39
	m_musDragonRoostIslandChannel0Measure9 c5
; Measure 40
	m_musDragonRoostIslandChannel0Measure6 c5
; Measure 41
	m_musDragonRoostIslandChannel0Measure6 as4
; Measure 42
	m_musDragonRoostIslandChannel0Measure7 as4
; Measure 43-44
.rept 2
	m_musDragonRoostIslandChannel0Measure9 a4
.endr
; Measure 45
	m_musDragonRoostIslandChannel0Measure6 g4
; Measure 46
	m_musDragonRoostIslandChannel0Measure46 as4
; Measure 47
	m_musDragonRoostIslandChannel0Measure47 e4
; Measure 48
	m_musDragonRoostIslandChannel0Measure46 e4
; Measure 49-50
.rept 2
	m_musDragonRoostIslandChannel0Measure5 c5
.endr
; Measure 51
	m_musDragonRoostIslandChannel0Measure5 as4
; Measure 52
	m_musDragonRoostIslandChannel0Measure6 a4
; Measure 53
	m_musDragonRoostIslandChannel0Measure7 as4
; Measure 54
	m_musDragonRoostIslandChannel0Measure7 a4
; Measure 55
	m_musDragonRoostIslandChannel0Measure6 as4
; Measure 56
	m_musDragonRoostIslandChannel0Measure6 a4
; Measure 57
	m_musDragonRoostIslandChannel0Measure7 as4
; Measure 58
	m_musDragonRoostIslandChannel0Measure7 a4

; Measure 59
	m_musDragonRoostIslandChannel0Measure6 ds5
; Measure 60
	m_musDragonRoostIslandChannel0Measure46 ds5
; Measure 61
	m_musDragonRoostIslandChannel0Measure9 d5
; Measure 62
	m_musDragonRoostIslandChannel0Measure62 d5
; Measure 63
	m_musDragonRoostIslandChannel0Measure5 g5
; Measure 64
	m_musDragonRoostIslandChannel0Measure5 ds5
; Measure 65
	m_musDragonRoostIslandChannel0Measure6 f5
; Measure 66
	m_musDragonRoostIslandChannel0Measure6 a4
; Measure 67
	m_musDragonRoostIslandChannel0Measure6 g5
; Measure 68
	m_musDragonRoostIslandChannel0Measure46 ds5
; Measure 69
	m_musDragonRoostIslandChannel0Measure5 d5
; Measure 70
	m_musDragonRoostIslandChannel0Measure62 d5
; Measure 71
	m_musDragonRoostIslandChannel0Measure5 e5
; Measure 72
	m_musDragonRoostIslandChannel0Measure62 e5
; Measure 73
	m_musDragonRoostIslandChannel0Measure5 g5
; Measure 74
	m_musDragonRoostIslandChannel0Measure5 ds5
; Measure 75
	m_musDragonRoostIslandChannel0Measure75 gs4
; Measure 76
	m_musDragonRoostIslandChannel0Measure46 gs4

	goto musDragonRoostIslandChannel0Measure27Loop
	cmdff


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

musDragonRoostIslandChannel4:
.redefine HI_VOL $0e
.redefine LO_VOL $0f

	tempo TEMPO_2
; Measure 1
	octave 3
	duty HI_VOL
	beat d E1+S3
	duty LO_VOL
	beat d S4

	duty HI_VOL
	beat d Q+E1
	duty LO_VOL
	beat d E2
; Measure 2-4
	beat r 3*(HF+Q)
; Measure 5-14
.rept 5	
	m_musDragonRoostIslandChannel4Measure5 g3
	m_musDragonRoostIslandChannel4Measure6 f3
.endr
; Measure 15-16
	m_musDragonRoostIslandChannel4Measure5 as3
	m_musDragonRoostIslandChannel4Measure6 as3
; Measure 17-18
	m_musDragonRoostIslandChannel4Measure5 gs3
	m_musDragonRoostIslandChannel4Measure6 gs3
; Measure 19-20
	m_musDragonRoostIslandChannel4Measure5 g3
	m_musDragonRoostIslandChannel4Measure6 g3
; Measure 21-22
	m_musDragonRoostIslandChannel4Measure5 f3
	m_musDragonRoostIslandChannel4Measure6 f3
; Measure 23-24
	m_musDragonRoostIslandChannel4Measure5 ds3
	m_musDragonRoostIslandChannel4Measure6 ds3
; Measure 25
	m_musDragonRoostIslandChannel4Measure5 ds3
; Measure 26
	tempo TEMPO_2
	octave 3
	duty HI_VOL
	beat f S1 g S2+E2 ds Q

	octaved
	beat as S1 r S2 f S3 r S4

musDragonRoostIslandChannel4Measure27Loop:
; Measure 27-34
.rept 2
	m_musDragonRoostIslandChannel4Measure27 g2
	m_musDragonRoostIslandChannel4Measure28 f2
	m_musDragonRoostIslandChannel4Measure27 g2
	m_musDragonRoostIslandChannel4Measure30 d3
.endr	
; Measure 35-36
	m_musDragonRoostIslandChannel4Measure27 g2
	m_musDragonRoostIslandChannel4Measure28 f2
; Measure 37
	m_musDragonRoostIslandChannel4Measure27 f2
; Measure 38
	tempo TEMPO_2
	octave 2
	duty HI_VOL
	beat as S1
	duty LO_VOL
	beat as S2

	duty HI_VOL
	beat as S3 r S4

	beat as E1
	duty LO_VOL
	beat as E2	

	octaveu
	duty HI_VOL
	beat f E1
	duty LO_VOL
	beat f E2
; Measure 39-40
	m_musDragonRoostIslandChannel4Measure27 gs2
	m_musDragonRoostIslandChannel4Measure28 gs2
; Measure 41-42
	m_musDragonRoostIslandChannel4Measure27 g2
	m_musDragonRoostIslandChannel4Measure30 g2
; Measure 43-44
	m_musDragonRoostIslandChannel4Measure27 f2
	m_musDragonRoostIslandChannel4Measure28 f2
; Measure 45
	m_musDragonRoostIslandChannel4Measure27 ds2
; Measure 46
	tempo TEMPO_1
	octave 3
	duty HI_VOL
	beat f R1 ds R2 d Y5 r Y6
	beat ds R1 d R2+Y5 r Y6
; Measure 47
	m_musDragonRoostIslandChannel4Measure27 c3
; Measure 48
	m_musDragonRoostIslandChannel4Measure48
; Measure 51-58
.rept 2
	m_musDragonRoostIslandChannel4Measure27 g2
	m_musDragonRoostIslandChannel4Measure28 f2
	m_musDragonRoostIslandChannel4Measure27 g2
	m_musDragonRoostIslandChannel4Measure30 d3
.endr	
; Measure 59-60
	m_musDragonRoostIslandChannel4Measure59 ds3
	m_musDragonRoostIslandChannel4Measure60 ds3
; Measure 61-62
	m_musDragonRoostIslandChannel4Measure59 d3
	m_musDragonRoostIslandChannel4Measure62 d3
; Measure 63-65
	m_musDragonRoostIslandChannel4Measure59 c3
	m_musDragonRoostIslandChannel4Measure62 c3
; Measure 65-66
	m_musDragonRoostIslandChannel4Measure59 d3
	m_musDragonRoostIslandChannel4Measure30 d3
; Measure 67-68
	m_musDragonRoostIslandChannel4Measure59 ds3
	m_musDragonRoostIslandChannel4Measure60 ds3
; Measure 69-70
	m_musDragonRoostIslandChannel4Measure59 d3
	m_musDragonRoostIslandChannel4Measure62 d3
; Measure 71
	m_musDragonRoostIslandChannel4Measure27 c3
; Measure 72-74
	m_musDragonRoostIslandChannel4Measure48
; Measure 75
	tempo TEMPO_1
	octave 2
	duty HI_VOL
	beat gs R1 
	duty LO_VOL
	beat gs R2

	duty HI_VOL
	beat gs Y5
	beat LO_VOL
	beat gs Y6

	octaveu
	duty HI_VOL
	beat ds R1
	duty LO_VOL
	beat ds R2

	octaved
	duty HI_VOL
	beat gs R3

; Measure 76
	m_musDragonRoostIslandChannel4Measure30 gs2

	goto musDragonRoostIslandChannel4Measure27Loop
	cmdff

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

musDragonRoostIslandChannel6:
	.redefine HI_VOL $4
	.redefine LO_VOL $2
	.redefine HIT     $27

; Measure 1-24
.rept 6
	m_musDragonRoostIslandChannel6Measure1
	m_musDragonRoostIslandChannel6Measure3
.endr
; Measure 25-26
	m_musDragonRoostIslandChannel6Measure3
musDragonRoostIslandChannel6Measure27Loop:
; Measure 27-76
.rept 12
	m_musDragonRoostIslandChannel6Measure1
	m_musDragonRoostIslandChannel6Measure3
.endr
	m_musDragonRoostIslandChannel6Measure3

	goto musDragonRoostIslandChannel6Measure27Loop