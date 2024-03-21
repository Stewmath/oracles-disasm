musLostWoodsStart:
    tempo 140
musLostWoodsChannel1:
.redefine HI_VOL $6
.redefine LO_VOL $4
; Measure 1
    vol $0
    beat gs3 W

musLostWoodsChannel1Measure2Loop:
.rept 2 INDEX REPTCTR
; Measure 2,6
    octave 5
    duty $02
    env $0 $05
    vol HI_VOL
.rept 2
    beat f E1 a E2 b Q
.endr
; Measure 3,7
    beat f E1 a E2 b E1 ou e E2
    beat d Q od b E1 ou c E2

.ifeq REPTCTR 0
; Measure 4
    octaved
    beat b E1 g E2

    env $0 $00
    vibrato $62
    beat e HF r E1

    env $0 $05
    vibrato $00
    beat d E2
; Measure 5
    beat e E1 g E2

    env $0 $00
    vibrato $82
    beat e HF+E1 r E2
.endif
.endr

; Measure 8
    octave 6
    beat e E1 od b E2

    env $0 $00
    vibrato $62
    beat g HF r E1  

    env $0 $02
    vibrato $00 
    beat b E2
; Measure 9
    env $0 $05
    beat g E1 d E2

    env $0 $00
    vibrato $82
    beat e HF+E1 r E2

.rept 2 INDEX REPTCTR
; Measure 10,14
    octave 4
    vibrato $00
    env $1 $04
	vol HI_VOL+2
    beat d E1 e E2 f Q
    beat g E1 a E2 b Q
; Measure 11,15
    octaveu
    beat c E1 od b E2
    
    env $1 $00
    vibrato $62
    beat e HF+E1 r E2

.ifeq REPTCTR 0
; Measure 12
    octaveu
    vibrato $00
    env $0 $05
    vol HI_VOL-1
    beat f E1 g S3 r S4
    vol HI_VOL
    beat a Q
    vol HI_VOL+1
    beat b E1 ou c S3 r S4
    vol HI_VOL+2
    beat d Q
; Measure 13
    beat e E1 f S3 r S4

    env $0 $00
    vibrato $81
    beat g HF+E1 r E2

    vol HI_VOL
.endif
.endr

; Measure 16
	octave 5
    vibrato $00
    env $0 $05
    vol HI_VOL-1
    beat f E1 e S3 r S4
    beat a E1 g S3 r S4
    vol HI_VOL
    beat b E1 a S3 r S4
    beat ou c E1 od b S3 r S4
; Measure 17
    octaveu
	vol HI_VOL+1
    beat d E1 od b S3 r S4
    beat ou e E1 d S3 r S4
	vol HI_VOL+2
    beat f E1 e S3 r S4
    beat e S1 f S2 r S3 d S4
; Measure 18-19
	env $0 $00
	vibrato $e2
    beat e HF+E1 
	vol HI_VOL
	vibrato $02
	beat e E2+E1
	vol LO_VOL
	beat e E2 r HF+Q

	octaved
	vol HI_VOL+2
	env $0 $05
	vibrato $00
	beat b S1+T3 r T4+E2

    goto musLostWoodsChannel1Measure2Loop
    cmdff



musLostWoodsChannel0:
.redefine HI_VOL $5
.redefine LO_VOL $2
; Measure 1
    vol $0
    beat f3 W+E1

musLostWoodsChannel0Measure2Loop:
    octave 3
    duty $03
    env $0 $00
.rept 2
.rept 4
; Measure 2a-3,6a-7
    ;beat a 13 a 13 a 13 r 13
    vol HI_VOL
    beat a S3
    vol LO_VOL
    beat a S4

    vol HI_VOL
    beat a S1
    vol LO_VOL
    beat a S2

    vol HI_VOL
    beat a S3
    vol LO_VOL
    beat a S4 r E1
.endr
.rept 4
; Measure 4-5,8-9
    ;beat g 13 g 13 g 13 r 13
    vol HI_VOL
    beat g S3
    vol LO_VOL
    beat g S4

    vol HI_VOL
    beat g S1
    vol LO_VOL
    beat g S2

    vol HI_VOL
    beat g S3
    vol LO_VOL
    beat g S4 r E1
.endr
.endr

.rept 2 INDEX REPTCTR
; Measure 10
    octave 3
.rept 2
    vol HI_VOL
    beat f S3
    vol LO_VOL
    beat a S4 r E1
.endr
    octaved
.rept 2
    vol HI_VOL
    beat ou d S3
    vol LO_VOL
    beat od g S4 r E1
.endr
; Measure 11
    octaveu
.rept 2
    vol HI_VOL
    beat g S3
    vol LO_VOL
    beat c S4 r E1
.endr
    octaved
    vol HI_VOL
    beat ou e S3
    vol LO_VOL
    beat od a S4 r E1
    vol HI_VOL
    beat ou e S3
    vol LO_VOL
    beat od a S4

.ifeq REPTCTR 0
; Measure 12
    octave 4
    vibrato $00
    duty $02
    env $1 $04
    vol HI_VOL
    beat d E1 e S3 r S4
    vol HI_VOL+1
    beat f Q
    vol HI_VOL+2
    beat g E1 a S3 r S4
    vol HI_VOL+3
    beat b Q

; Measure 13
    octaveu
    beat c E1 d S3 r S4

    env $1 $00
    vibrato $62
    beat e HF+E1

    octave 3
    vibrato $00
    duty $03
    env $0 $00
    vol HI_VOL
    beat e S3
    vol LO_VOL
    beat od a S4 r E1
.endif
.endr

; Measure 16
	octave 4
    duty $02
    env $1 $04
    vol HI_VOL
    beat d E1 c S3 r S4
    beat f E1 e S3 r S4
    vol HI_VOL+1
    beat g E1 f S3 r S4
    beat a E1 g S3 r S4
; Measure 17
	vol HI_VOL+2
    beat b E1 a S3 r S4
    beat ou c E1 od b S3 r S4
	vol HI_VOL+3
    beat ou d E1 c S3 r S4
    beat od b S1 ou c S2+S3 od a S4
; Measure 18
    env $1 $00
    vibrato $e2
    beat b HF+E1 
	vol HI_VOL+1
    env $0 $00
	vibrato $02
	beat b E2+E1
	vol LO_VOL+1
	beat b E2 r E1
; Measure 19a
	octave 3
	vibrato $00
	;beat gs 13 gs 13 gs 13 g 13 r 13
    vol HI_VOL
    beat gs S1
    vol LO_VOL
    beat gs S2

    vol HI_VOL
    beat gs S3
    vol LO_VOL
    beat gs S4

    vol HI_VOL
    beat gs S1
    vol LO_VOL
    beat gs S2   

    vol HI_VOL
    beat gs S3
    vol LO_VOL
    beat gs S4 r E2

    vol HI_VOL+3
    beat ou e S1+T3 r T4+E2+E1

    goto musLostWoodsChannel0Measure2Loop
    cmdff



musLostWoodsChannel4:
.redefine HI_VOL $0e
.redefine LO_VOL $0f
.redefine HI_VOL2 $15
.redefine LO_VOL2 $14

; Measure 1
    beat r W

musLostWoodsChannel4Measure2Loop:
; Measure 2-3,6-7
    octave 3
.rept 2
.rept 4
    duty HI_VOL
    beat f E1
	;beat ou c 13 c 13 c 13
    octaveu
    duty HI_VOL2
    beat c S3
    duty LO_VOL2
    beat c S4

    duty HI_VOL2
    beat c S1
    duty LO_VOL2
    beat c S2

    duty HI_VOL2
    beat c S3
    duty LO_VOL2
    beat c S4

    octaved
.endr
.rept 4 INDEX REPTCTR
; Measure 4-5,8-9
    duty HI_VOL
    beat e E1
	;beat ou c 13 c 13 c 13
    octaveu
    duty HI_VOL2
    beat c S3
    duty LO_VOL2
    beat c S4

    duty HI_VOL2
    beat c S1
    duty LO_VOL2
    beat c S2
.ifeq (REPTCTR # 2) 0
    duty HI_VOL2
    beat c S1
    duty LO_VOL2
    beat c S2
    octaved
.else 
    octaved
	duty HI_VOL
    beat c E2
.endif
.endr
.endr

.rept 3
; Measure 10,12,14
.rept 2
    duty HI_VOL
    beat d S1
    duty LO_VOL
    beat d S2

	duty HI_VOL
    beat a S3
    duty LO_VOL
    beat a S4
.endr
.rept 2
    octaved
    duty HI_VOL
    beat g S1
    duty LO_VOL
    beat g S2

    octaveu
	duty HI_VOL
    beat g S3
    duty LO_VOL
    beat g S4
.endr
; Measure 11,13,15
    octaveu
.rept 2
    octaved
    duty HI_VOL
    beat c S1
    duty LO_VOL
    beat c S2

    octaveu
	duty HI_VOL
    beat c S3
    duty LO_VOL
    beat c S4
.endr
	octaved
.rept 2
    octaved
    duty HI_VOL
    beat a S1
    duty LO_VOL
    beat a S2

    octaveu
	duty HI_VOL
    beat a S3
    duty LO_VOL
    beat a S4
.endr
.endr

; Measure 16
.rept 2
	duty HI_VOL
    beat d E1

    ;duty HI_VOL
    beat a S3+T7
    duty LO_VOL
    beat a T8

    duty HI_VOL
    beat a S1+T3
    duty LO_VOL
    beat a T4 r E2
.endr
; Measure 17
.rept 2
	duty HI_VOL
    beat c E1

    ;duty HI_VOL
    beat b S3+T7
    duty LO_VOL
    beat b T8

    duty HI_VOL
    beat b S1+T3
    duty LO_VOL
    beat b T4 r E2
.endr
; Measure 18
.rept 2
	duty HI_VOL
    beat e E1

    ;duty HI_VOL
    beat b S3+T7
    duty LO_VOL
    beat b T8 r E1

    duty HI_VOL
    beat b S1+T3
    duty LO_VOL
    beat b T4
.endr
; Measure 19
	duty HI_VOL
    beat e E1

    ;duty HI_VOL
    beat b S3+T7
    duty LO_VOL
    beat b T8

    duty HI_VOL
    beat b S1+T3
    duty LO_VOL
    beat b T4 

    duty HI_VOL
    beat b S3+T7
    duty LO_VOL
    beat b T8

    duty HI_VOL
    beat b S1+T3
    duty LO_VOL
    beat b T4 r E2

	duty HI_VOL
	beat b S1+T3 r T4+E2

    goto musLostWoodsChannel4Measure2Loop
    cmdff

musLostWoodsChannel6:
.redefine TAMB $2a
.redefine SNARE $24
.redefine HI_VOL $4
.redefine LO_VOL $2
; Measure 1
	vol HI_VOL+1
.rept 2
    beat TAMB E1 TAMB S3 TAMB S4
.endr
    beat TAMB E1 TAMB E2
    beat r E1 SNARE E2

musLostWoodsChannel6Measure2Loop:
	vol HI_VOL
.rept 8
; Measure 2-9
.rept 2
    beat TAMB E1 TAMB S3 TAMB S4
.endr
    beat TAMB E1 TAMB E2
    beat SNARE E1 TAMB E2
.endr

.rept 16 ; 4 measures
; Measure 10-13
    beat TAMB E1 TAMB S3 TAMB S4
.endr 

.rept 4
; Measure 14-15
    beat TAMB E1 TAMB S3 TAMB S4
    beat SNARE E1 TAMB S3 TAMB S4
.endr

.rept 4
; Measure 16-15
    beat TAMB E1 TAMB S3 TAMB S4
    beat SNARE Q
.endr

.rept 4
; Measure 18
    beat TAMB E1 TAMB S3 TAMB S4
.endr 

; Measure 19
    beat r E1 TAMB E2 TAMB E1 TAMB E2
    beat TAMB Q SNARE S1+T3 r T4+E2

    goto musLostWoodsChannel6Measure2Loop
    cmdff

.undefine HI_VOL
.undefine LO_VOL
.undefine TAMB
.undefine SNARE