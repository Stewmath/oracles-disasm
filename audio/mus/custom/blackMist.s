musBlackMistStart:
	tempo 137
musBlackMistChannel1:
.redefine HI_VOL $6
.redefine LO_VOL $4

	duty $01
	octave 4
	vol LO_VOL
	env $0 $04
; Measure 1
	beat g Q g Q g Q
musBlackMistChannel1Measure1dLoop:
	duty $01
	octave 4
	vol LO_VOL
	env $0 $04
	vibrato $00

	beat as E1 as S3 as S4
; Measure 2
	beat g Q g Q g Q
	beat as R1 as R2 as R3
; Measure 3
	beat g Q g Q g Q
	beat as E1 as S3 as S4
; Measure 4
	beat g Q g Q g Q
	beat as R1 as R2 as R3

	octave 5
	duty $02
	env $0 $00
.rept 2
	vol HI_VOL
; Measure 5
.rept 2
	beat c Q r R1 od g R2 ou ds R3
.endr
; Measure 6
	beat c E1 r E2
	vibrato $81
	beat od g Q+R1+R2 r R3
	vibrato $00
	beat ou c R1 ds R2 g R3
; Measure 7
	vibrato $81
	beat as Q+R1+R2 r R3
	vibrato $00
	beat gs Q r R1 f R2 gs R3
; Measure 8
	vibrato $e1
	beat g HF+E1
	vol LO_VOL
	vibrato $01
	beat g E2+E1
	vol LO_VOL-2
	beat g E2
	vibrato $00
; Measure 9
	octave 5
	vol HI_VOL
.rept 2
	beat c Q r R1 od g R2 ou ds R3
.endr 
; Measure 10
	beat c E1 r E2
	vibrato $81
	beat od g Q+R1+R2 r R3
	vibrato $00
	beat g R1 ou c R2 ds R3
; Measure 11
	vibrato $81
	beat g Q+R1
	vibrato $00
	beat f R2 gs R3
	beat g S1 r S2 ds S3 r S4
	beat c R1 od g R2 ou ds R3
; Measure 12,13
	vibrato $82
	beat c HF+E1
	vol LO_VOL
	vibrato $02
	beat c E2+E1
	vol LO_VOL-2
	beat c E2
	vibrato $00
.endr

; Measure 14
	octave 6
	vol HI_VOL
	env $0 $06
	vibrato $81
	beat c Q+R1
	vibrato $00
	beat c R2 c R3
	env $0 $00
	beat c Q od g E1 ou c E2
; Measure 15
	vibrato $81
	beat od as Q+R1
	beat gs R2 g R3
	vibrato $e1
	beat gs HF
; Measure 16
	env $0 $06
	vibrato $81
	beat as Q+R1 
	vibrato $00
	beat as R2 as R3
	env $0 $00
	beat as Q f E1 as E2
; Measure 17
	vibrato $81
	beat gs Q+R1
	beat g R2 fs R3
	vibrato $e1
	beat g HF
; Measure 18
	env $0 $06
	vibrato $81
	beat f Q+R1
	vibrato $00
	beat f R2 f R3
	env $0 $00
	beat f Q g E1 gs E2
; Measure 19
	vibrato $81
	beat g Q+R1
	beat f R2 e R3
	vibrato $e1
	beat f HF
; Measure 20
	vibrato $81
	env $0 $06
	beat g Q+R1
	vibrato $00
	beat fs R2 gs R3
	beat g E1 ds E2
	env $0 $00
	beat od b R1 g R2 ou ds R3
; Measure 21
	vibrato $e2
	beat c HF+Q

	goto musBlackMistChannel1Measure1dLoop
	cmdff

musBlackMistChannel0:
.redefine HI_VOL $5
.redefine LO_VOL $3

	duty $00
	octave 4
	vol HI_VOL
	env $0 $04

; Measure 1
	beat ds Q ds Q ds Q
musBlackMistChannel0Measure1dLoop:
	vibrato $00
	duty $00
	vol HI_VOL
	env $0 $04
	beat fs E1 fs S3 fs S4
; Measure 2
	beat ds Q ds Q ds Q
	beat fs R1 fs R2 fs R3
; Measure 3
	beat ds Q ds Q ds Q
	beat fs E1 fs S3 fs S4
; Measure 4
	beat ds Q ds Q ds Q
	beat fs R1 fs R2 fs R3

; Measure 5
	env $0 $00
	octave 4
	duty $03
	vol HI_VOL
	beat c Q r R1 c R2 g R3
	beat ds Q r R1 c R2 g R3
; Measure 6
	beat ds E1 r E2
	vibrato $81
	beat c Q+R1 r R2
	vibrato $00
	beat c R3 ds R1 g R2 ou c R3
; Measure 7
	vibrato $81
	beat ds Q+R1+R2 r R2
	vibrato $00
	beat cs Q r R1 od b R2 ou cs R3
; Measure 8
	vibrato $e1
	beat c HF+E1
	vol LO_VOL
	vibrato $01
	beat c E2+E1
	vol LO_VOL-2
	beat c E2
	vibrato $00
; Measure 9
	octave 4
	vol HI_VOL
	beat c Q r R1 c R2 g R3
	beat ds Q r R1 c R2 g R3
; Measure 10
	beat ds E1 r E2
	vibrato $81
	beat c Q+R1+R2
	vibrato $00
	beat ds R3 c R1 ds R2 g R3
; Measure 11
	octave 5
	vibrato $81
	beat c Q+R1
	vibrato $00
	beat od b R2 ou cs R3
	beat c S1 r S2 od g S3 r S4
	beat d R1 od b R2 ou f R3

; Measure 12
	vibrato $82
	beat ds HF+E1
	vol LO_VOL
	vibrato $02
	beat ds E2+E1
	vol LO_VOL-2
	beat ds E2
	vibrato $00
; Measure 5
	env $0 $00
	octave 4
	duty $02
	vol HI_VOL
	beat c Q r R1 c R2 g R3
	beat ds Q r R1 c R2 g R3
; Measure 6
	beat ds E1 r E2
	vibrato $81
	beat c Q+R1 r R2
	vibrato $00
	beat c R3 ds R1 g R2 ou c R3
; Measure 7
	vibrato $81
	beat ds Q+R1+R2 r R2
	vibrato $00
	beat cs Q r R1 od b R2 ou cs R3
; Measure 8
	vibrato $e1
	beat c HF+E1
	vol LO_VOL
	vibrato $01
	beat c E2+E1
	vol LO_VOL-2
	beat c E2
	vibrato $00
; Measure 9
	octave 4
	vol HI_VOL
	beat c Q r R1 c R2 g R3
	beat ds Q r R1 c R2 g R3
; Measure 10
	beat ds E1 r E2
	vibrato $81
	beat c Q+R1+R2
	vibrato $00
	beat ds R3 c R1 ds R2 g R3
; Measure 11
	octave 5
	vibrato $81
	beat c Q+R1
	vibrato $00
	beat od b R2 ou cs R3
	beat c S1 r S2 od g S3 r S4
	beat d R1 od b R2 ou f R3


; Measire 13
	vibrato $82
	beat ds HF
	vibrato $00	
	beat d Y1 ds Y2 f Y3 g Y4 gs Y5 b Y6
	beat ou d Y1 ds Y2 f Y3 g Y4 gs Y5 b Y6

; Measure 14
	octave 4
	vibrato $e1
	beat e HF
	vibrato $00
	beat c Q e Q
; Measure 15
	vibrato $e1
	beat f HF+Q+R1
	vibrato $00
	beat e R2 ds R3
; Measure 16
	beat d HF c HF
; Measure 17
	vibrato $e1
	beat od as HF+Q
	vibrato $00
	beat b Q
; Measure 18
	vibrato $e1
	beat ou c HF+Q+E1
	vibrato $00
	beat cs E2
; Measure 19
	vibrato $e1
	beat d HF+Q+R1
	vibrato $00
	beat cs R2 c R3
; Measure 20
	beat od b HF+Q ou g Q
; Measure 21
	vibrato $e1
	beat od g HF+Q

	goto musBlackMistChannel0Measure1dLoop
	cmdff




musBlackMistChannel4:
musBlackMistChannel4Measure1Loop:
;musBlackMistChannel4Motif1:
	duty $0e
	octave 3
.rept 2
; Measures 1,3,5,9
	beat c E1 r E2 c E1 r E2 c E1 r E2
	beat ds S1 r S2
	beat ds T5 r T6 ds T7 r T8
;musBlackMistChannel4Motif2:
; Measures 2,4,6,8,10,12,20
	beat c E1 r E2 c E1 r E2 c E1 r E2
	beat ds Y1 r Y2 ds Y3 r Y4 ds Y5 r Y6
.endr

.rept 2
; Measures 5
	beat c E1 r E2 c E1 r E2 c E1 r E2
	beat ds S1 r S2
	beat ds T5 r T6 ds T7 r T8
; Measures 6
	beat c E1 r E2 c E1 r E2 c E1 r E2
	beat ds Y1 r Y2 ds Y3 r Y4 ds Y5 r Y6
; Measure 7
	octave 3
	beat cs E1 r E2 cs E1 r E2 cs E1 r E2
	beat cs S1 r S2
	beat cs T5 r T6 cs T7 r T8
; Measure 8
	beat c E1 r E2 c E1 r E2 c E1 r E2
	beat ds Y1 r Y2 ds Y3 r Y4 ds Y5 r Y6
; Measures 9
	beat c E1 r E2 c E1 r E2 c E1 r E2
	beat ds S1 r S2
	beat ds T5 r T6 ds T7 r T8
; Measures 10
	beat c E1 r E2 c E1 r E2 c E1 r E2
	beat ds Y1 r Y2 ds Y3 r Y4 ds Y5 r Y6

; Measure 11
	beat gs E1 r E2 gs E1 r E2 gs E1 r E2
	beat b S1 r S2
	beat b T5 r T6 b T7 r T8
; Measures 12,13
	beat c E1 r E2 c E1 r E2 c E1 r E2
	beat ds Y1 r Y2 ds Y3 r Y4 ds Y5 r Y6
.endr

; Measure 14
	octave 3
	beat e E1 r E2 e E1 r E2 e E1 r E2
	beat e S1 r S2
	beat e T5 r T6 e T7 r T8
; Measure 15
	beat f E1 r E2 f E1 r E2 f E1 r E2
	beat f Y1 r Y2 f Y3 r Y4 f Y5 r Y6

; Measure 16
	octave 2
	beat as E1 r E2 as E1 r E2 as E1 r E2
	beat as S1 r S2
	beat as T5 r T6 as T7 r T8
; Measure 17
	octave 3
	beat ds E1 r E2 ds E1 r E2 ds E1 r E2
	beat ds Y1 r Y2 ds Y3 r Y4 ds Y5 r Y6

; Measure 18
	octave 2
	beat gs E1 r E2 gs E1 r E2 gs E1 r E2
	beat gs S1 r S2
	beat gs T5 r T6 gs T7 r T8
; Measure 19
	octave 3
	beat d E1 r E2 d E1 r E2 d E1 r E2
	beat d Y1 r Y2 d Y3 r Y4 d Y5 r Y6
	
; Measure 20
	beat g E1 r E2 g E1 r E2 g E1 r E2
	beat g S1 r S2
	beat g T5 r T6 g T7 r T8

	goto musBlackMistChannel4Measure1Loop
	cmdff

musBlackMistChannel6:
.redefine HIT $2a
	vol $5
musBlackMistChannel6MeasureOdd:
; Measure Odd
	beat HIT Q HIT Q HIT Q
	beat HIT E1 HIT S3 HIT S4

; Measure Even
	beat HIT Q HIT Q HIT Q
	beat HIT R1 HIT R2 HIT R3

	goto musBlackMistChannel6MeasureOdd
	cmdff