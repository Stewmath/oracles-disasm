musLinebeckStart:
	tempo 112;115
musLinebeckChannel1:
.redefine HI_VOL $6
.redefine LO_VOL $3

; Measure 1 (eighth note pickup)
	octave 4
	duty $02

	;beat g E2
	vol HI_VOL
	beat g S3
	vol LO_VOL
	beat g T7 r T8
; Measure 2-3c
	;beat ou c Q+E1 od g E2 ou d Q
	octaveu
	vol HI_VOL
	beat c E1+S3
	vol LO_VOL
	beat c S4+S1+T3 r T4

	octaved
	vol HI_VOL
	beat g S3
	vol LO_VOL
	beat g T7 r T8

	octaveu
	vol HI_VOL
	beat d E1
	vol LO_VOL
	beat d S3+T7

	vol $0
	beat r T8+Q+HF+HF r Q+E1

musLinebeckChannel1Measure3dLoop:
.rept 2
; Measure 3d,7d
	octave 4
	duty $01
	vibrato $00
	;beat d E2
	vol HI_VOL
	beat d S3
	vol LO_VOL
	beat d T7 r T8
; Measure 4,8
	;beat g Q+E1 d E2 a Q+E1 d E2
	vol HI_VOL
	beat g E1+S3
	vol LO_VOL
	beat g S4+S1+T3 r T4

	vol HI_VOL
	beat d S3
	vol LO_VOL
	beat d T7 r T8

	vol HI_VOL
	beat a E1+S3
	vol LO_VOL
	beat a S4+S1+T3 r T4

	vol HI_VOL
	beat d S3
	vol LO_VOL
	beat d T7 r T8
; Measure 5,9
	vol HI_VOL
	beat as E1
.redefine NOTE_END_WAIT 5
	beat ou c E2 d E1
.redefine NOTE_END_WAIT 0
	beat od as Y4 ou c Y5 od as Y6

	;beat g Q+E1
	beat g E1+S3
	vol LO_VOL
	beat g S4+S1+T3 r T4

	duty $00
	vibrato $01
	;beat g E2
	vol HI_VOL
	beat g S3
	vol LO_VOL
	beat g T7 r T8
; Measure 6,10
	vol HI_VOL
	beat as E1
.redefine NOTE_END_WAIT 5
	beat ou c E2 d E1 od as E2
	beat g Q f Q
; Measure 7,11
.redefine NOTE_END_WAIT 0
	;beat d E1 f E2
	beat d S1
	vol LO_VOL
	beat d T3 r T4

	vol HI_VOL
	beat f S3
	vol LO_VOL
	beat f T7 r T8

	;beat g HF r E1
	vol HI_VOL
	beat g Q
	vol LO_VOL
	beat g Q r E1
.endr

; Measure 11d
	octave 4
	duty $02
	vibrato $01
	;beat g E2
	vol HI_VOL
	beat g S3
	vol LO_VOL
	beat g T7 r T8
; Measure 12
	octaveu
	;beat ds Q+E1 ds E2
	vol HI_VOL
	beat ds E1+S3
	vol LO_VOL
	beat ds S4+S1+T3 r T4

	vol HI_VOL
	beat ds S3
	vol LO_VOL
	beat ds T7 r T8

	vol HI_VOL
	beat f E1
.redefine NOTE_END_WAIT 5
	beat ds E2 d E1 c E2
; Measure 13
.redefine NOTE_END_WAIT 0
	;beat c Q
	beat c E1
	vol LO_VOL
	beat c E2
	;beat od as E1 ou c E2
	octaved
	vol HI_VOL
	beat as S1
	vol LO_VOL
	beat as S2

	octaveu
	vol HI_VOL
	beat c S3
	vol LO_VOL
	beat c S4

	;beat d Q+E1 d E2
	vol HI_VOL
	beat d E1+S3
	vol LO_VOL
	beat d S4+E1

	vol HI_VOL
	beat d S3
	vol LO_VOL
	beat d S4
; Measure 14
	;beat c Q+E1 od as E2
	vol HI_VOL
	beat c E1+S3
	vol LO_VOL
	beat c S4+E1

	octaved
	vol HI_VOL
	beat as S3
	vol LO_VOL
	beat as S4

	vol HI_VOL
	beat gs E1
.redefine NOTE_END_WAIT 5
	beat ou ds E2 d E1 c E2
; Measure 15
.redefine NOTE_END_WAIT 0
	;beat d HF
	beat d Q
	vol LO_VOL
	beat d Q
	vol LO_VOL-2
	beat d Q r E1

; Measure 15d
	octave 4
	duty $01
	vibrato $00
	;beat g E2
	vol HI_VOL
	beat g S3
	vol LO_VOL
	beat g T7 r T8
; Measure 16
	octaveu
	;beat ds Q+E1 ds E2
	vol HI_VOL
	beat ds E1+S3
	vol LO_VOL
	beat ds S4+S1+T3 r T4

	vol HI_VOL
	beat ds S3
	vol LO_VOL
	beat ds T7 r T8

	vol HI_VOL
	beat f E1
	beat ds Y4 f Y5 ds Y6

	;beat d E1 c E2
	beat d S1
	vol LO_VOL
	beat d T3 r T4

	vol HI_VOL
	beat c S3
	vol HI_VOL
	beat c T7 r T8

; Measure 17
	vol HI_VOL
; quintuplet
	beat c Y1+Y2 d Y3 c Y4 d Y5 c Y6 

	;beat od as E1 ou c E2
	octaved
	beat as S1
	vol LO_VOL
	beat as T3 r T4

	octaveu
	vol HI_VOL
	beat c S3
	vol LO_VOL
	beat c T7 r T8

	;beat d Q cs E1 d E2
	vol HI_VOL
	beat d E1
	vol LO_VOL
	beat d S3+T7 r T8

	vol HI_VOL
	beat cs S1
	vol LO_VOL
	beat cs T3 r T4

	vol HI_VOL
	beat d S3
	vol LO_VOL
	beat d T7 r T8

; Measure 18
	;beat ds Q+E1 c E2 e Q+E1
	vol HI_VOL
	beat ds E1+S3
	vol LO_VOL
	beat ds S4+S1+T3 r T4

	vol HI_VOL
	beat c S3
	vol LO_VOL
	beat c T7 r T8

	vol HI_VOL
	beat e E1+S3
	vol LO_VOL
	beat e S4+S1+T3 r T4

	vol HI_VOL
	beat g S3 fs T7 g T8

; Measure 19
	;beat fs HF r Q+E1
	beat fs Q
	vol LO_VOL
	beat fs E1+S3+T7 r T8+Q+E1

	goto musLinebeckChannel1Measure3dLoop
	cmdff

musLinebeckChannel0:

.redefine HI_VOL $4
.redefine LO_VOL $2
.redefine NOTE_END_WAIT 0

; Measure 1 (eighth note pickup)
	octave 3
	duty $02

	;beat g E2
	vol HI_VOL
	beat g S3
	vol LO_VOL
	beat g T7 r T8

; Measure 2
	;beat ou c Q+E1 od g E2 ou d Q
	octaveu
	vol HI_VOL
	beat c E1+S3
	vol LO_VOL
	beat c S4+S1+T3 r T4

	octaved
	vol HI_VOL
	beat g S3
	vol LO_VOL
	beat g T7 r T8

	octaveu
	vol HI_VOL
	beat d E1
	vol LO_VOL
	beat d S3+T7 r T8

	beat r Q+HF

musLinebeckChannel0Measure3Loop:
; Measure 3,19
	octave 3
	env $0 $04
	vol HI_VOL

	beat d E1
	env $0 $00
	beat ou g E2
	env $0 $04
	beat fs E1 ds E2
	beat d E1 c E2 od as E1

musLinebeckChannel0Measure3d:
; Measure 3d
	octave 3
	vol HI_VOL
	beat d E2
; Measure 4
	beat g E1 as E2 ou d E1 od g E2
	beat fs E1 as E2 ou fs E1 od d E2
; Measure 5
	beat f E1 as E2 ou d E1 od f E2
	beat e E1 as E2 ou e E1 od g E2
; Measure 6
	beat ds E1 as E2 ou ds E1 od ds E1
	beat d E1 f E2 ou d E1 od f E2
; Measure 7
	vol HI_VOL+2
	beat d E1 f E2 g E1 as E2
	octaveu
	beat d E1 od g E2 as E1
; Measure 7d
	octave 3
	env $0 $06
	vol HI_VOL
	beat d E2
; Measure 8
	beat g E1 as E2 ou d E1 od g E2
	beat fs E1 as E2 ou fs E1 od d E2
; Measure 9
	beat f E1 as E2 ou d E1 od f E2
	beat e E1 as E2 ou e E1 od g E2
; Measure 10
	beat ds E1 as E2 ou ds E1 od ds E1
	beat d E1 f E2 ou d E1 od f E2
; Measure 11
	env $0 $04
	vol HI_VOL+2
	beat d E1 ou c E2 od b E1
	vol HI_VOL
	beat b E2 ou d E1 od g E2
	beat as E1 g E2
; Measure 12
	beat c E1 ou c E2 ds E1 od c E2
	beat f E1 ou c E2 ds E1 od c E2
; Measure 13
	beat as E1 ou d E2 f E1 od as E2
	beat as E1 ou d E2 f E1 d E2
; Measure 14
	beat od gs E1 ou c E2 ds E1 od gs E2
	beat gs E1 ou c E2 ds E1 c E2
; Measure 15
	octaved
	beat g E1
	vol HI_VOL+1
	beat g E2 as E1 as E2
	beat ou g E1 g E2 d E1
	vol HI_VOL
	beat od g E2
; Measure 16
	beat c E1 ou c E2 ds E1 od c E2
	beat f E1 ou c E2 ds E1 od c E2
; Measure 17
	beat as E1 ou d E2 f E1 od as E2
	beat b E1 ou d E2 f E1 d E2
; Measure 18
	beat od c E1 ou ds E2 g E1 od c E2
	beat a E1 ou cs E2 e E1 od a E2

	goto musLinebeckChannel0Measure3Loop
	cmdff


musLinebeckChannel4:
.redefine CHANNEL 4

.redefine HI_VOL $0e
.redefine LO_VOL $0f
.redefine HI_VOL2 $15
.redefine LO_VOL2 $14

; Measure 1 (eighth note pickup)
	octave 2
	beat r E1
; Measure 2
	; beat ds HF d Q r Q+HF
	duty HI_VOL
	beat ds Q
	duty LO_VOL
	beat ds Q

	duty HI_VOL
	beat d E1
	duty LO_VOL
	beat d E2 r Q+HF

musLinebeckChannel4Measure3Loop:
; Measure 3,19
	octave 2
	;beat d E1 ou ou ds E2 d E1 c E2
	duty HI_VOL
	beat d S1
	duty LO_VOL
	beat d S2

	octaveu
	octaveu
	duty HI_VOL
	beat ds S3
	duty LO_VOL
	beat ds S4

	duty HI_VOL
	beat d S1
	duty LO_VOL
	beat d S2

	duty HI_VOL
	beat c S3
	duty LO_VOL
	beat c S4

	;beat od as E1 a E2 g E1
	octaved
	duty HI_VOL
	beat as S1
	duty LO_VOL
	beat as S2

	duty HI_VOL
	beat a S3
	duty LO_VOL
	beat a S4

	duty HI_VOL
	beat g S1
	duty LO_VOL
	beat g S2

musLinebeckChannel4Measure3dLoop:
.redefine COUNTER 0
.rept 2
; Measure 3d,7d
	octave 2
	;beat d E2
	duty HI_VOL
	beat d S1
	duty LO_VOL
	beat d S2	
; Measure 4,8
	;beat g E1
	duty HI_VOL
	beat g S1
	duty LO_VOL
	beat g S2	
	
	;beat ou g E2 as E1
	octaveu
	duty HI_VOL2
	beat g S3
	duty LO_VOL2
	beat g S4

	duty HI_VOL2
	beat as S1
	duty LO_VOL2
	beat as S2	

	;beat od g E2 fs E1
	octaved
	duty HI_VOL
	beat g S3
	duty LO_VOL
	beat g S4

	duty HI_VOL
	beat fs S1
	duty LO_VOL
	beat fs S2

	;beat ou g E2 ou d E1
	octaveu
	duty HI_VOL2
	beat g S3
	duty LO_VOL2
	beat g S4

	octaveu
	duty HI_VOL2
	beat d S1
	duty LO_VOL2
	beat d S2	

	;beat od od d E2
	octaved
	octaved
	duty HI_VOL
	beat d S3
	duty LO_VOL
	beat d S4
; Measure 5,9
	;beat f E1
	duty HI_VOL
	beat f S1
	duty LO_VOL
	beat f S2

	;beat ou g E2 as E1
	octaveu
	duty HI_VOL2
	beat g S3
	duty LO_VOL2
	beat g S4

	duty HI_VOL2
	beat as S1
	duty LO_VOL2
	beat as S2

	;beat od f E2 e E1
	octaved
	duty HI_VOL
	beat f S3
	duty LO_VOL
	beat f S4

	duty HI_VOL
	beat e S1
	duty LO_VOL
	beat e S2

	;beat ou g E2 as E1
	octaveu
	duty HI_VOL2
	beat g S3
	duty LO_VOL2
	beat g S4

	duty HI_VOL2
	beat as S1
	duty LO_VOL2
	beat as S2

	;beat od g E2
	octaved
	duty HI_VOL
	beat g S3
	duty LO_VOL
	beat g S4
; Measure 6,10
	;beat ds E1
	duty HI_VOL
	beat ds S1
	duty LO_VOL
	beat ds S2

	;beat ou g E2 as E1
	octaveu
	duty HI_VOL2
	beat g S3
	duty LO_VOL2
	beat g S4

	duty HI_VOL2
	beat as S1
	duty LO_VOL2
	beat as S2	

	;beat od ds E2 d E1 
	octaved
	duty HI_VOL
	beat ds S3
	duty LO_VOL
	beat ds S4

	duty HI_VOL
	beat d S1
	duty LO_VOL
	beat d S2

	;beat ou d E2 a E1
	octaveu
	duty HI_VOL2
	beat d S3
	duty LO_VOL2
	beat d S4

	duty HI_VOL2
	beat a S1
	duty LO_VOL2
	beat a S2	

	;beat od f E2
	octaved
	duty HI_VOL
	beat f S3
	duty LO_VOL
	beat f S4
; Measure 7,11
	;beat d E1 f E2 g E1
	duty HI_VOL
	beat d S1
	duty LO_VOL
	beat d S2

	duty HI_VOL
	beat f S3
	duty LO_VOL
	beat f S4

	duty HI_VOL
	beat g S1
	duty LO_VOL
	beat g S2	
	;beat ou g E2 as E1 od g E2 ou g E1
	octaveu
	duty HI_VOL2
	beat g S3
	duty LO_VOL2
	beat g S4

.if COUNTER == 0
; Measure 7c
	duty HI_VOL2
	beat as S1
	duty LO_VOL2
	beat as S2

	octaved
	duty HI_VOL
	beat g S3
	duty LO_VOL
	beat g S4

	octaveu
	duty HI_VOL2
	beat g S1
	duty LO_VOL2
	beat g S2
.endif


.redefine COUNTER, COUNTER + 1
.endr
; Measure 11c
	;beat b E1 od g E2 ou g E1
	octave 3
	duty HI_VOL2
	beat b S1
	duty LO_VOL2
	beat b S2

	octaved
	duty HI_VOL2
	beat g S3
	duty LO_VOL2
	beat g S4

	octaveu
	duty HI_VOL2
	beat g S1
	duty LO_VOL2
	beat g S2

	;beat od g E2
	octaved
	duty HI_VOL
	beat g S3
	duty LO_VOL
	beat g S4
; Measure 12
	;beat c E1
	duty HI_VOL
	beat c S1
	duty LO_VOL
	beat c S2	
	;beat ou g E2 ou c E1
	octaveu
	duty HI_VOL2
	beat g S3
	duty LO_VOL2
	beat g S4

	octaveu
	duty HI_VOL2
	beat c S1
	duty LO_VOL2
	beat c S2
	
	;beat od od c E2 f E1
	octaved
	octaved
	duty HI_VOL
	beat c S3
	duty LO_VOL
	beat c S4

	duty HI_VOL
	beat f S1
	duty LO_VOL
	beat f S2

	;beat ou g E2 ou c E1
	octaveu
	duty HI_VOL2
	beat g S3
	duty LO_VOL2
	beat g S4

	octaveu
	duty HI_VOL2
	beat c S1
	duty LO_VOL2
	beat c S2
	
	;beat od od f E2
	octaved
	octaved
	duty HI_VOL
	beat f S3
	duty LO_VOL
	beat f S4
; Measure 13
	;beat as E1
	duty HI_VOL
	beat as S1
	duty LO_VOL
	beat as S2
	
	;beat ou as E2 ou d E1
	octaveu
	duty HI_VOL2
	beat as S3
	duty LO_VOL2
	beat as S4

	octaveu
	duty HI_VOL2
	beat d S1
	duty LO_VOL2
	beat d S2

	;beat od od as E2 as E1 
	octaved
	octaved
	duty HI_VOL
	beat as S3
	duty LO_VOL
	beat as S4

	duty HI_VOL
	beat as S1
	duty LO_VOL
	beat as S2

	;beat ou as E2 ou d E1
	octaveu
	duty HI_VOL2
	beat as S3
	duty LO_VOL2
	beat as S4

	octaveu
	duty HI_VOL2
	beat d S1
	duty LO_VOL2
	beat d S2

	;beat od d E2
	octaved
	duty HI_VOL
	beat d S3
	duty LO_VOL
	beat d S4
; Measure 14
	;beat od gs E1
	octaved
	duty HI_VOL
	beat gs S1
	duty LO_VOL
	beat gs S2

	;beat ou gs E2 ou c E1
	octaveu
	duty HI_VOL2
	beat gs S3
	duty LO_VOL2
	beat gs S4

	octaveu
	duty HI_VOL2
	beat c S1
	duty LO_VOL2
	beat c S2

	;beat od od gs E2 gs E1
	octaved
	octaved
	duty HI_VOL
	beat gs S3
	duty LO_VOL
	beat gs S4

	duty HI_VOL
	beat gs S1
	duty LO_VOL
	beat gs S2

	;beat ou fs E2 ou c E1
	octaveu
	duty HI_VOL2
	beat fs S3
	duty LO_VOL2
	beat fs S4

	octaveu
	duty HI_VOL2
	beat c S1
	duty LO_VOL2
	beat c S2

	;beat od c E2
	octaved
	duty HI_VOL
	beat c S3
	duty LO_VOL
	beat c S4
; Measure 15
	;beat od g E1
	octaved
	duty HI_VOL
	beat g S1
	duty LO_VOL
	beat g S2
	
	;beat ou d E2 g E1 g E2
	octaveu
	duty HI_VOL
	beat d S3
	duty LO_VOL
	beat d S4

	duty HI_VOL
	beat g S1
	duty LO_VOL
	beat g S2

	duty HI_VOL
	beat g S3
	duty LO_VOL
	beat g S4

	;beat ou d E1 d E2 od as E1
	octaveu
	duty HI_VOL
	beat d S1
	duty LO_VOL
	beat d S2

	duty HI_VOL
	beat d S3
	duty LO_VOL
	beat d S4

	octaved
	duty HI_VOL
	beat as S1
	duty LO_VOL
	beat as S2
	
	;beat od g E2
	octaved
	duty HI_VOL
	beat g S3
	duty LO_VOL
	beat g S4
; Measure 16
	;beat c E1
	duty HI_VOL
	beat c S1
	duty LO_VOL
	beat c S2
	
	;beat ou g E2 ou c E1
	octaveu
	duty HI_VOL2
	beat g S3
	duty LO_VOL2
	beat g S4

	octaveu
	duty HI_VOL2
	beat c S1
	duty LO_VOL2
	beat c S2

	;beat od od c E2 f E1
	octaved
	octaved
	duty HI_VOL
	beat c S3
	duty LO_VOL
	beat c S4

	duty HI_VOL
	beat f S1
	duty LO_VOL
	beat f S2

	;beat ou g E2 ou c E1
	octaveu
	duty HI_VOL2
	beat g S3
	duty LO_VOL2
	beat g S4

	octaveu
	duty HI_VOL2
	beat c S1
	duty LO_VOL2
	beat c S2

	;beat od od f E2
	octaved
	octaved
	duty HI_VOL
	beat f S3
	duty LO_VOL
	beat f S4
; Measure 17
	;beat as E1
	duty HI_VOL
	beat as S1
	duty LO_VOL
	beat as S2

	;beat ou as E2 ou d E1
	octaveu
	duty HI_VOL2
	beat as S3
	duty LO_VOL2
	beat as S4

	octaveu
	duty HI_VOL2
	beat d S1
	duty LO_VOL2
	beat d S2

	;beat od od as E2 b E1
	octaved
	octaved
	duty HI_VOL
	beat as S3
	duty LO_VOL
	beat as S4

	duty HI_VOL
	beat b S1
	duty LO_VOL
	beat b S2

	;beat ou gs E2 ou d E1
	octaveu
	duty HI_VOL2
	beat gs S3
	duty LO_VOL2
	beat gs S4

	octaveu
	duty HI_VOL2
	beat d S1
	duty LO_VOL2
	beat d S2

	;beat od d E2
	octaved
	duty HI_VOL
	beat d S3
	duty LO_VOL
	beat d S4
; Measure 18
	;beat od c E1
	octaved
	duty HI_VOL
	beat c S1
	duty LO_VOL
	beat c S2

	;beat ou ou c E2 ds E1
	octaveu
	octaveu
	duty HI_VOL2
	beat c S3
	duty LO_VOL
	beat c S4

	duty HI_VOL2
	beat ds S1
	duty LO_VOL2
	beat ds S2

	;beat od od c E2 a E1
	octaved
	octaved
	duty HI_VOL
	beat c S3
	duty LO_VOL
	beat c S4

	duty HI_VOL
	beat a S1
	duty LO_VOL
	beat a S2 

	;beat ou a E2 ou cs E1
	octaveu
	duty HI_VOL2
	beat a S3
	duty LO_VOL2
	beat a S4

	octaveu
	duty HI_VOL2
	beat cs S1
	duty LO_VOL2
	beat cs S2

	;beat od d E1
	octaved
	duty HI_VOL
	beat d S1
	duty LO_VOL
	beat d S2

	goto musLinebeckChannel4Measure3Loop
	cmdff

musLinebeckChannel6:
.redefine CRASH $30
.redefine SNARE $2a

.redefine CHANNEL 6

.redefine HI_VOL $4
.redefine LO_VOL $2

; Measure 1-2b (eighth note pickup)
	beat r E2+HF
; Measure 2c
;	beat CRASH Q r Q+HF+E1
	vol HI_VOL+2
	beat CRASH E1
	vol HI_VOL
	beat CRASH S3
	vol HI_VOL-1
	beat CRASH S4
	vol LO_VOL
	beat CRASH T1
	vol LO_VOL
	beat CRASH T2
	vol $0
	beat r S2+T5 SNARE T6 r S4+HF
; Measure 3-4a
	vol HI_VOL
	beat SNARE Q r Q+HF+E1

musLinebeckChannel6Measure4a:
; Measure 4a
	beat SNARE S3 SNARE S4 SNARE E1
	vol LO_VOL
	beat SNARE E2 SNARE E1
	vol HI_VOL
	beat SNARE E2 SNARE E1	
	vol LO_VOL
	beat SNARE E2
; Measure 5
	beat SNARE E1	
	vol HI_VOL
	beat SNARE T5 SNARE T6 SNARE T7 SNARE T8
 	beat SNARE E1
	vol LO_VOL
	beat SNARE E2 SNARE E1
	vol HI_VOL
	beat SNARE E2 SNARE E1	
	vol LO_VOL
	beat SNARE E2
; Measure 6
	beat SNARE E1
	vol HI_VOL

	goto musLinebeckChannel6Measure4a
    cmdff

.undefine HI_VOL
.undefine LO_VOL
.undefine HI_VOL2
.undefine LO_VOL2
.undefine COUNTER