musTalTalHeightsStart:
	tempo 150

musTalTalHeightsChannel1:
	.redefine HI_VOL $6
	.redefine LO_VOL $4

; Measure 1-4
	vol $0
.rept 2
	beat g3 W+W
.endr
; $40, $26, 1, 1
; Measure 5,7
	duty $01
	env $1 $00
	octave 4
.rept 2
	vol HI_VOL+1
	vibrato $00
	beat g Q d Q+E1 g S3 r S4
	beat g S1 a S2 as S3 ou c S4
; Measure 6,8
	vibrato $e2
	beat d HF+E1
	vibrato $02
	vol LO_VOL+2
	beat d E2+E1
	vol LO_VOL
	beat d E2
.endr	

musTalTalHeightsChannel1Measure9Loop:
; Measure 9
	octave 4
	duty $00
	vol HI_VOL
	env $1 $00
	vibrato $82
	beat g E1 r S3 d S4
	beat d Q r E1 g S3 r S4
	beat g S1 a S2 as S3 ou c S4
; Measure 10
	beat d Q r E1 e S3 f S4
	beat e E1+S3 d S4+E1 c E2
; Measure 11
	beat d E1+S3 od g S4
	octaveu
	;vibrato $82
	beat g HF+E1
	vibrato $02
	vol LO_VOL
	beat g E2+Q r E1
; Measure 12b
	vol HI_VOL
	vibrato $82
	beat d E1
	beat as E1 a E2 as E1 ou c E2
; Measure 13
	beat d E1 od g S3 ou d S4
	beat g Q r E1
	beat d E2 c E1 od as E2
; Measure 14
	octaveu
	beat c E1 od f S3 ou c S4
	beat f Q r E1
	beat c E2 od as E1 a E2
; Measure 15
	beat as E1 r S3 d S4
	beat d Q r E1
	beat c Y4 d Y5 c Y6
	octaved
	beat as E1 ou c E2
; Measure 16
	;vibrato $82
	beat d HF+E1
	vibrato $02
	vol LO_VOL
	beat d E2+Q
; Measure 17
	octave 4
	vol HI_VOL
	vibrato $82
	beat g E1 r S3 d S4
	beat d Q r E1 g S3 r S4
	beat g S1 a S2 as S3 ou c S4
; Measure 18
	beat d Q r E1 ds S3 f S4
	beat ds E1+S3 d S4+E1 c E2
; Measure 19
	octaved
	beat as E1+S3 g S4
	octaveu
	beat d Q r E1
	octaved
	beat as E2 ou g E1 d E2
; Measure 20
	beat as Q r E1 a E2
	beat g E1 a E2 as E1 ou c E2
; Measure 21
	beat d E1 c S3 d S4
	beat ds Q r E1
	beat f E2+S1 ds S2+E2
; Measure 22
	beat d E1+S3 od a S4+E1 as E2
	beat ou c E1+S3 od as S4+E1 a E2
; Measure 23
	;vibrato $82
	beat g HF+E1
	vibrato $02
	vol LO_VOL
	beat g E2+Q
; Measure 24
	octaveu
	vol HI_VOL
	vibrato $82
	beat g HF+E1
	vibrato $02
	vol LO_VOL
	beat g E2+E1
	vol LO_VOL-2
	beat g E2
; Measure 25-32
	vol $0
	vibrato $00
.rept 4
	beat g3 W+W
.endr
; Measure 33 (M9)
	octave 4
	duty $02
	vol HI_VOL
	 ;env $1 $00
	vibrato $62
	beat gs E1 r S3 ds S4
	beat ds Q r E1 gs S3 r S4
	beat gs S1 as S2 b S3 ou cs S4
; Measure 34 (M10)
	beat ds Q r E1 f S3 fs S4
	beat f E1+S3 ds S4+E1 cs E2
; Measure 35 (M11)
	beat ds E1+S3 od gs S4
	octaveu
	;vibrato $82
	beat gs HF+E1
	vibrato $02
	vol LO_VOL
	beat gs E2+Q r E1
; Measure 36b (M12b)
	vol HI_VOL
	vibrato $62
	beat ds E1
	beat b E1 as E2 b E1 ou cs E2
; Measure 37 (M13)
	beat ds E1 od gs S3 ou ds S4
	beat gs Q r E1
	beat ds E2 cs E1 od b E2
; Measure 38 (M14)
	octaveu
	beat cs E1 od fs S3 ou cs S4
	beat fs Q r E1
	beat cs E2 od b E1 as E2
; Measure 39 (M15)
	beat b E1 r S3 ds S4
	beat ds Q r E1
	beat cs Y4 ds Y5 cs Y6
	octaved
	beat b E1 ou cs E2
; Measure 40 (M16)
	;vibrato $82
	beat ds HF+E1
	vibrato $02
	vol LO_VOL
	beat ds E2+Q
; Measure 41 (M17)
	octave 4
	vol HI_VOL
	vibrato $62
	beat gs E1 r S3 ds S4
	beat ds Q r E1 gs S3 r S4
	beat gs S1 as S2 b S3 ou cs S4
; Measure 42 (M18)
	beat ds Q r E1 e S3 fs S4
	beat e E1+S3 ds S4+E1 cs E2
; Measure 43 (M19)
	octaved
	beat b E1+S3 gs S4
	octaveu
	beat ds Q r E1
	octaved
	beat b E2 ou gs E1 ds E2
; Measure 44 (M20)
	beat b Q r E1 as E2
	beat gs E1 as E2 b E1 ou cs E2
; Measure 45 (M21)
	beat ds E1 cs S3 ds S4
	beat e Q r E1
	beat fs E2+S1 e S2+E2
; Measure 46 (M22)
	beat ds E1+S3 od as S4+E1 b E2
	beat ou cs E1+S3 od b S4+E1 as E2
; Measure 47 (M23)
	;vibrato $82
	beat gs HF+E1
	vibrato $02
	vol LO_VOL
	beat gs E2+Q
; Measure 48 (M24)
	octaveu
	vol HI_VOL
	vibrato $62
	beat gs HF+E1
	vibrato $02
	vol LO_VOL
	beat gs E2+E1
	vol LO_VOL-2
	beat gs E2
; Measure 49-54
	vol $0
.rept 3
	beat g3 W+W
.endr
; Measure 55-58
	beat g3 HF
	;duty $02
	vol HI_VOL-1
	env $0 $04
	vibrato $00
	octave 6
.rept 3
	beat a HF r HF
.endr
	beat a HF

	goto musTalTalHeightsChannel1Measure9Loop
	cmdff
	
musTalTalHeightsChannel0:
	.redefine HI_VOL $5
	.redefine LO_VOL $3

; $33, $00, 2, 0
; Measure 1
	duty $02
	vol HI_VOL
	env $0 $02
	octave 5
.rept 2
	.rept 4
		beat d E1 d S3 d S4
	.endr
; Measure 2
	.rept 4
		beat e E1 e S3 e S4
	.endr
; Measure 3
	.rept 4
		beat f E1 f S3 f S4
	.endr
; Measure 4
	.rept 4
		beat e E1 e S3 e S4
	.endr
.endr

musTalTalHeightsChannel0Measure9Loop:
; Measure 9
	octave 3
	duty $01
	;env $0 $2
	;vol LO_VOL
.rept 4
	beat g S1 ou d S2 od as S3 ou d S4
	octaved
.endr
; Measure 10
.rept 4
	beat g S1 ou e S2 c S3 e S4
	octaved
.endr
; Measure 11
.rept 4
	beat g S1 ou f S2 d S3 f S4
	octaved
.endr
; Measure 12
.rept 4
	beat g S1 ou e S2 c S3 e S4
	octaved
.endr
; Measure 13
.rept 4
	beat ds S1 ou d S2 od as S3 ou d S4
	octaved
.endr
; Measure 14
.rept 4
	beat f S1 ou c S2 od a S3 ou c S4
	octaved
.endr
; Measure 15
.rept 2
	beat f S1 ou d S2 od as S3 ou d S4
	octaved
.endr
.rept 2
	beat g S1 ou e S2 c S3 e S4
	octaved
.endr
; Measure 16
.rept 4
	beat a S1 ou fs S2 d S3 fs S4
	octaved
.endr
; Measure 17
.rept 4
	beat g S1 ou d S2 od as S3 ou d S4
	octaved
.endr
; Measure 18
.rept 4
	beat gs S1 ou ds S2 c S3 ds S4
	octaved
.endr
; Measure 19
.rept 4
	beat g S1 ou d S2 od as S3 ou d S4
	octaved
.endr
; Measure 20
.rept 4
	beat e S1 ou d S2 od as S3 ou d S4
	octaved
.endr
; Measure 21
.rept 4
	beat gs S1 ou ds S2 c S3 ds S4
	octaved
.endr
; Measure 22
	octave 5
	beat d S1 g S2 a S3 ou c S4
	beat d Q r HF

; $50, $26, 0, 1
; Measure 23-24
	octave 6
	duty $00
	env $1 $00
	vol LO_VOL
	beat d HF c HF od as HF ou c HF

; $33, $00, 2, 0
; Measure 25
	octave 3
	duty $01
	env $0 $02
	vol LO_VOL
.rept 4
	beat g S1 ou d S2 od as S3 ou d S4
	octaved
.endr
; Measure 26
.rept 4
	beat g S1 ou e S2 c S3 e S4
	octaved
.endr
; Measure 27
.rept 4
	beat g S1 ou f S2 d S3 f S4
	octaved
.endr
; Measure 28
.rept 4
	beat g S1 ou e S2 c S3 e S4
	octaved
.endr

; $41, $00, 2, 0
; Measure 29,33
	duty $02
.rept 2
.rept 4
	beat gs S1 ou ds S2 od b S3 ou ds S4
	octaved
.endr
; Measure 30,34
.rept 4
	beat gs S1 ou f S2 cs S3 f S4
	octaved
.endr
; Measure 31,35
.rept 4
	beat gs S1 ou fs S2 ds S3 fs S4
	octaved
.endr
; Measure 32,36
.rept 4
	beat gs S1 ou f S2 cs S3 f S4
	octaved
.endr
.endr

; $62, $00, 2, 0
; Measure 37
.rept 4
	beat e S1 ou ds S2 od b S3 ou ds S4
	octaved
.endr
; Measure 38
.rept 4
	beat fs S1 ou cs S2 od as S3 ou cs S4
	octaved
.endr
; Measure 39
.rept 2
	beat fs S1 ou ds S2 od b S3 ou ds S4
	octaved
.endr
.rept 2
	beat gs S1 ou f S2 cs S3 f S4
	octaved
.endr
; Measure 40
.rept 4
	beat as S1 ou g S2 ds S3 g S4
	octaved
.endr
; Measure 41
.rept 4
	beat gs S1 ou ds S2 od b S3 ou ds S4
	octaved
.endr
; Measure 42
.rept 4
	beat a S1 ou e S2 cs S3 e S4
	octaved
.endr
; Measure 43
.rept 4
	beat gs S1 ou ds S2 od b S3 ou ds S4
	octaved
.endr
; Measure 44
.rept 4
	beat f S1 ou ds S2 od b S3 ou ds S4
	octaved
.endr
; Measure 45
.rept 4
	beat a S1 ou e S2 cs S3 e S4
	octaved
.endr
; Measure 46
	octave 5
	beat ds S1 gs S2 as S3 ou cs S4
	beat ds Q r HF

; $50, $26, 0, 1
; Measure 47-48
	octave 6
	duty $00
	env $1 $00
	vol LO_VOL
	beat ds HF cs HF od b HF ou cs HF

; Measure 49-50
	beat r W+W

; $33, $00, 2, 0
; Measure 51,55
	duty $02
	env $0 $02
	vol LO_VOL
	octave 3
.rept 2
.rept 4
	beat g S1 ou d S2 od as S3 ou d S4
	octaved
.endr
; Measure 52,56
.rept 4
	beat g S1 ou e S2 c S3 e S4
	octaved
.endr
; Measure 53,57
.rept 4
	beat g S1 ou f S2 d S3 f S4
	octaved
.endr
; Measure 54,58
.rept 4
	beat g S1 ou e S2 c S3 e S4
	octaved
.endr
.endr
	goto musTalTalHeightsChannel0Measure9Loop
	cmdff

musTalTalHeightsChannel4:
	.redefine HI_VOL $0e
	.redefine LO_VOL $0f

; Measure 1-8
; 1b_6ed1, $40, Enabled
	octave 4
.rept 31
	duty HI_VOL
	beat g S1
	duty LO_VOL
	beat g S2

	duty HI_VOL
	beat g T5 r T6

	beat g T7 r T8
.endr
; Measure 8d
	octave 3
	beat r S1 
	duty HI_VOL
	beat c S2 od as S3 a S4
	
musTalTalHeightsChannel4Measure9Loop:
	.redefine HI_VOL $0e
	.redefine LO_VOL $0f
; Measure 9-10
; 1b_6eb1, $21, Enabled
	octave 2
.rept 2
	duty HI_VOL
	beat g E1
	duty LO_VOL
	beat g S3 r S4

	duty HI_VOL
	beat g E1
	duty LO_VOL
	beat g E2 r Q

	duty HI_VOL
	beat g E1
	duty LO_VOL
	beat g S3 r S4
.endr
; Measure 11
	duty HI_VOL
	beat g E1
	duty LO_VOL
	beat g S3 r S4

	duty HI_VOL
	beat g E1
	duty LO_VOL
	beat g E2 r Q

	octaveu
	duty HI_VOL
	beat d E1
	duty LO_VOL
	beat d S3 r S4
; Measure 12
	duty HI_VOL
	beat c E1
	duty LO_VOL
	beat c S3 r S4

	duty HI_VOL
	beat c E1
	duty LO_VOL
	beat c E2 r Q	

	duty HI_VOL
	beat c E1 d E2
; Measure 13
	;duty HI_VOL
	beat ds E1
	duty LO_VOL
	beat ds S3 r S4

	duty HI_VOL
	beat ds E1
	duty LO_VOL
	beat ds E2 r Q

	duty HI_VOL
	beat ds E1
	duty LO_VOL
	beat ds S3 r S4	
; Measure 14
	duty HI_VOL
	beat f E1
	duty LO_VOL
	beat f S3 r S4

	duty HI_VOL
	beat f E1
	duty LO_VOL
	beat f E2 r Q

	duty HI_VOL
	beat f E1
	duty LO_VOL
	beat f S3 r S4
; Measure 15
	octaved
.rept 2
	duty HI_VOL
	beat as E1
	duty LO_VOL
	beat as S3 r S4
.endr
	octaveu
.rept 2
	duty HI_VOL
	beat c E1
	duty LO_VOL
	beat c S3 r S4
.endr
; Measure 16
	duty HI_VOL
	beat d E1
	duty LO_VOL
	beat d S3 r S4

	duty HI_VOL
	beat d E1
	duty LO_VOL
	beat d E2 r Q	

	duty HI_VOL
	beat d S1 c S2 od as S3 a S4
; Measure 17
	;duty HI_VOL
	beat g E1
	duty LO_VOL
	beat g S3 r S4

	duty HI_VOL
	beat g E1
	duty LO_VOL
	beat g E2 r Q

	duty HI_VOL
	beat g E1
	duty LO_VOL
	beat g S3 r S4
; Measure 18
	duty HI_VOL
	beat gs E1
	duty LO_VOL
	beat gs S3 r S4

	duty HI_VOL
	beat gs E1
	duty LO_VOL
	beat gs E2 r Q

	duty HI_VOL
	beat gs E1
	duty LO_VOL
	beat gs S3 r S4
; Measure 19
	duty HI_VOL
	beat g E1
	duty LO_VOL
	beat g S3 r S4

	duty HI_VOL
	beat g E1
	duty LO_VOL
	beat g E2 r Q

	duty HI_VOL
	beat f E1
	duty LO_VOL
	beat f S3 r S4
; Measure 20
	duty HI_VOL
	beat e E1
	duty LO_VOL
	beat e S3 r S4

	duty HI_VOL
	beat e E1
	duty LO_VOL
	beat e E2 r Q

	duty HI_VOL
	beat e E1
	duty LO_VOL
	beat e S3 r S4
; Measure 21
	duty HI_VOL
	beat gs E1
	duty LO_VOL
	beat gs S3 r S4

	duty HI_VOL
	beat gs E1
	duty LO_VOL
	beat gs E2 r Q

	duty HI_VOL
	beat gs E1
	duty LO_VOL
	beat gs S3 r S4
; Measure 22
	octaveu
	duty HI_VOL
	beat d E1
	duty LO_VOL
	beat d S3 r S4+HF

; Disabled
	.redefine HI_VOL $0e
	.redefine LO_VOL $0f

	octave 3
	duty HI_VOL
	beat d E1+S3
	duty LO_VOL
	beat d S4 
; Measure 23
	octaved
	duty HI_VOL
	beat g E1+S3 ou d S4+E1 od g E2

	beat f E1+S3 ou c S4+E1 od f E2
; Measure 24
	beat ds E1+S3 as S4+E1 ds E2
	
	beat f E1+S3 ou c S4+E1 od f E2
; Measure 25-46
	duty $00
.rept 11
	beat r W+W
.endr
; Measure 47
	octave 2
	duty HI_VOL
	beat gs E1+S3 ou ds S4+E1 od gs E2

	beat fs E1+S3 ou cs S4+E1 od fs E2
; Measure 48
	beat e E1+S3 b S4+E1 e E2

	beat fs E1+S3 ou cs S4+E1 od fs E2
; Measure 49-54
.rept 5
	beat r W+W
.endr

	goto musTalTalHeightsChannel4Measure9Loop

musTalTalHeightsChannel6:
	.redefine NOISE_3 $2a
	.redefine NOISE_5 $2a
	.redefine HI_VOL $4
	.redefine LO_VOL $3

; Measure 1-7
	vol HI_VOL
.rept 7
.rept 4
	beat NOISE_3 E1 NOISE_3 S3 NOISE_3 S4
.endr
.endr 
; Measure 8
.rept 3
	beat NOISE_3 E1 NOISE_3 S3 NOISE_3 S4
.endr
	vol LO_VOL
	beat NOISE_5 S1 NOISE_5 S2 NOISE_5 S3 NOISE_5 S4

musTalTalHeightsChannel6Measure9Loop:
; Measure 9-21
.rept 13
.rept 3
	beat NOISE_5 E1 NOISE_5 S3 NOISE_5 S4
.endr
	beat NOISE_5 S1 NOISE_5 S2 NOISE_5 S3 NOISE_5 S4
.endr
; Measure 22
	beat NOISE_5 S1 NOISE_5 S2 NOISE_5 S3 NOISE_5 S4
	beat NOISE_5 Q r HF
; Measure 23-45
.rept 23
	.rept 3
		beat NOISE_5 E1 NOISE_5 S3 NOISE_5 S4
	.endr
		beat NOISE_5 S1 NOISE_5 S2 NOISE_5 S3 NOISE_5 S4
.endr
; Measure 46
	beat NOISE_5 S1 NOISE_5 S2 NOISE_5 S3 NOISE_5 S4
	beat NOISE_5 Q r HF
; Measure 47-58
.rept 12
.rept 3
	beat NOISE_5 E1 NOISE_5 S3 NOISE_5 S4
.endr
	beat NOISE_5 S1 NOISE_5 S2 NOISE_5 S3 NOISE_5 S4
.endr
	goto musTalTalHeightsChannel6Measure9Loop
	cmdff
