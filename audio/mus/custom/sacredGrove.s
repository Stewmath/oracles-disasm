musSacredGroveStart:
    tempo 120
musSacredGroveChannel1:
    .redefine OCT 4
    .redefine HI_VOL $6
    .redefine LO_VOL $4

; Measure 1-8
    vol $0
.rept 4
    beat gs3 W+W
.endr

musSacredGroveChannel1Measure9Loop:
; Measure 9-10
    vibrato $00
    env $0 $06
    duty $02
; Measure 9
    octave OCT+1
.rept 2
    vol HI_VOL
    beat f E1 a E2
    beat b E1 r S3
    vol LO_VOL 
    beat b S4
.endr
; Measure 10
    vol HI_VOL
    beat f E1 a E2 b E1 ou e E2
    beat d Q od b E1 ou c E2
; Measure 11
    octave OCT+1
    beat b E1 g E2
    env $0 $00
    vibrato $e1
    beat e Q+E1+T5
    vol LO_VOL
    vibrato $01
    beat e T6+S4+E1
    vol HI_VOL
    env $0 $06
    vibrato $00
    beat d E2
; Measure 12
    beat e E1 g E2
    octave OCT+1
    env $0 $00
    vibrato $e1
    beat e Q+E1+S3
    vol LO_VOL
    vibrato $01
    beat e S4+Q
    env $0 $06
; Measure 13
    octave OCT+1
    vibrato $00
.rept 2
    vol HI_VOL
    beat f E1 a E2
    beat b E1 r S3
    vol LO_VOL 
    beat b S4
.endr
; Measure 14
    vol HI_VOL
    beat f E1 a E2 b E1 ou e E2
    beat d Q od b E1 ou c E2
; Measure 15
    octave OCT+2
    beat e E1 od b E2
    env $0 $00
    vibrato $e1
    beat g Q+E1+T5
    vol LO_VOL
    vibrato $01
    beat g T6+S4+E1
    vol HI_VOL
    vibrato $00
    env $0 $06
    beat b E2
; Measure 16
    beat g E1 d E2
    octave OCT+1
    env $0 $00
    vibrato $e1
    beat e Q+E1+S3
    vol LO_VOL
    vibrato $01
    beat e S4+Q
    env $0 $06

; Measure 17
    octave OCT+1
    vibrato $00
    duty $03
    vol HI_VOL
    beat d E1 e E2 f E1 r S3
    vol LO_VOL
    beat f S4

    vol HI_VOL
    beat g E1 a E2 b E1 r S3
    vol LO_VOL
    beat b S4
; Measure 18
    vol HI_VOL
    octaveu
    beat c E1 od b E2

    octave OCT+1
    env $0 $00
    vibrato $e1
    beat e Q+E1+S3
    vol LO_VOL
    vibrato $01
    beat e S4+Q
    env $0 $06

; Measure 19
    octave OCT+1
    vibrato $00
    vol HI_VOL
    beat f E1 g E2 a E1 r S3
    vol LO_VOL
    beat a S4

    vol HI_VOL
    beat b E1 ou c E2 d E1 r S3
    vol LO_VOL
    beat d S4
; Measure 20
    vol HI_VOL
    beat e E1 f E2
    octave OCT+2
    vibrato $e1
    env $0 $00
    beat g Q+E1+S3
    vol LO_VOL
    vibrato $01
    beat g S4+Q
    env $0 $06
; Measure 21-22
    octave OCT+1
    vibrato $00
    duty $03
    vol HI_VOL
    beat d E1 e E2 f E1 r S3
    vol LO_VOL
    beat f S4

    vol HI_VOL
    beat g E1 a E2 b E1 r S3
    vol LO_VOL
    beat b S4
; Measure 22
    vol HI_VOL
    octaveu
    beat c E1 od b E2

    octave OCT+1
    vibrato $e1
    env $0 $00
    beat e Q+E1+S3
    vol LO_VOL
    vibrato $01
    beat e S4+Q
    env $0 $06
; Measure 23
    octave OCT+1
    vibrato $00
    vol HI_VOL-1
    beat f E1 e E2 a E1 g E2
    beat b E1 a E2 ou c E1 od b E2
; Measure 24
    octaveu
    vol HI_VOL
    beat d E1 c E2 e E1 d E2
    beat f E1 e E2
    octaved
    vol HI_VOL+1
    beat b S1 ou c S2+S3 od a S4
; Measure 25-26
    env $0 $00
    vibrato $e1
    beat b HF+Q
    vibrato $01
    vol LO_VOL
    beat b Q r W

    goto musSacredGroveChannel1Measure9Loop
    cmdff

musSacredGroveChannel0:
.redefine HI_VOL $6
.redefine LO_VOL $3
.ifdef ECHO_NOTE
    .undefine ECHO_NOTE
.endif

    vibrato $00
    env $0 $05
    duty $02
.rept 2
; Measure 1-2,5-6
.rept 4
    octave OCT
    echobeat e E1 f E2 a E1 ou c E2
.endr
.rept 4
; Measure 3-4,7-8
    octave OCT-1
    echobeat b E1 ou c E2
    echobeat e E1 g E2 
.endr
.endr   

musSacredGroveChannel0Measure9Loop:
.rept 2
    octave OCT
.rept 4
; Measure 9-10,13-14
    echobeat e E1 f E2 a E1 ou c E2
    octaved
.endr
.rept 4
; Measure 11-12,15-16 (same as 3-4,7-8)
    octaved
    echobeat b E1 ou c E2
    echobeat e E1 g E2 
.endr
.endr

    octave OCT
.rept 3
; Measure 17,19,21
    echobeat c E1 d E2 f E1 a E2
    octaved
    echobeat b E1 ou d E2
    echobeat f E1 a E2 
; Measure 18,20,22
.rept 2
    octaved
    echobeat b E1 ou c E2
    echobeat e E1 g E2
.endr
.endr
; Measure 23
    octave OCT
.rept 2
    echobeat c E1 d E2 f E1 a E2
.endr
; Measure 24
.rept 2
    echobeat c E1 e E2 g E1 b E2
.endr

; Measure 25
    octave OCT-1
    echobeat b E1 ou e E2
    echobeat a E1 b E2
    echobeat e E1 a E2 b E1 ou e E2
; Measure 26
    octaved
    echobeat e E1 gs E2 b E1 ou e E1
    octaved
    echobeat b E1 gs E2 e E1 od b E1

    goto musSacredGroveChannel0Measure9Loop
    cmdff


musSacredGroveChannel4:
.redefine HI_VOL $0e
.redefine LO_VOL $0f
.redefine ECHO $08
.redefine ECHO_OFFSET Q-S4 ; Q-T8

; Measure 1-8
    octave OCT-1
    duty LO_VOL
.rept 2
    beat a Q r Q+HF+W
    beat e Q r Q+HF+W
.endr

; Measure 9-10
    beat r ECHO_OFFSET
musSacredGroveChannel4Measure9Loop:
    duty ECHO
    octave OCT+1
.rept 2
    beat f E1 a E2
    beat b E1 r E2
.endr
; Measure 10
    beat f E1 a E2 b E1 ou e E2
    beat d Q od b E1 ou c E2
; Measure 11b
    octave OCT+1
    beat b E1 g E2
    beat e Q+E1+T5 r T6+S4+E1
    beat d E2
; Measure 12b
    beat e E1 g E2
    beat e Q+E1+S3 r S4+Q
; Measure 13b
    octave OCT+1
.rept 2
    beat f E1 a E2
    beat b E1 r E2
.endr
; Measure 14
    beat f E1 a E2 b E1 ou e E2
    beat d Q od b E1 ou c E2
; Measure 15b
    octave OCT+2
    beat e E1 od b E2
    beat g Q+E1+T5 r T6+S4+E1
    beat b E2
; Measure 16b
    beat g E1 d E2
    beat e Q+E1+S3 r S4+Q-ECHO_OFFSET 

; Measure 17b-18
    octave OCT-1
    duty LO_VOL
    beat a Q r Q+HF+W

; Measure 19
    octave OCT+1
    duty ECHO
    beat d E1 e E2 f E1 r E2
    beat g E1 a E2 b E1 r E2
; Measure 20
    octaveu
    beat c E1 d E2
    beat e Q+E1+S3 r S4+Q
; Measure 21-22
    octave OCT-1
    duty LO_VOL
    beat a Q r Q+HF+W
; Measure 23
    octave OCT+1
    duty ECHO
    beat d E1 c E2 f E1 e E2
    beat g E1 f E2 a E1 g E2
; Measure 24
    beat b E1 a E2 ou c E1 od b E2
    octaveu
    beat d E1 c E2
    octaved
    beat e S1 f S2+S3 d S4
; Measure 25-26
    beat e HF+Q r Q+W+ECHO_OFFSET

    goto musSacredGroveChannel4Measure9Loop
    cmdff

.define musSacredGroveChannel6 MUSIC_CHANNEL_FALLBACK EXPORT

.undefine HI_VOL
.undefine LO_VOL
.undefine ECHO
.undefine ECHO_OFFSET
