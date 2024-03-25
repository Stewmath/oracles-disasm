musSanctuaryStart:
    tempo 65
 ; BPM = 64.29; B = 56; M = 224
musSanctuaryChannel1:
.redefine HI_VOL $6
.redefine LO_VOL $4

; Measure 1-2
; 3/4
	octave 4
	duty $03
    env $0 $00
    vibrato $01
.rept 2
	vol HI_VOL
    vibrato $01
    beat ds E1 f E2
;   beat d HF
	vibrato $e2
	beat d Q+T1
	vol LO_VOL
	vibrato $02
	beat d T2+S2+S3
	vol LO_VOL-2
	beat d S4
.endr
; Measure 3
; 4/4
    octaveu
 	vol HI_VOL
	vibrato $01
    beat c E1 d E2
    octaved
;   beat b HF+Q
	beat b Q+E1+S3
	vol LO_VOL
	vibrato $02
	beat b S4+S1
	vol LO_VOL-2
	beat b S2 r E2	

.rept 2 INDEX REPTCTR

.ifeq REPTCTR 0
musSanctuaryChannel1Measure4:
.else
musSanctuaryChannel1Measure5:
.endif
; Measure 4,5
    octave 5
    vol HI_VOL
    duty $03
    env $0 $00
    vibrato $01
    beat g E1 ds E2 c E1 ou c E2
    octaved
    beat b E1 g E2 d E1 od b E2
.endr
; Measure 6
    octave 5
    beat g E1 ds E2 c E1 ou c E2
    octaved
    beat b E1 ou c E2 d E1 od b E2

.rept 2
; Measure 7,8
    octave 6
    beat c E1 od g E2 ou c E1 g E1+E2
    beat d E2 od b E1 g E2
.endr

; Measure 9
    octave 6
    beat c E1 od a E2 ds E1 c E2+E1
    beat ds E2 fs E1 ou c E2
; Measure 10
    octaved
;   beat b HF+Q+E1 r E2
	vibrato $e2
	beat b HF+E1+S3
	vibrato $02
	vol LO_VOL
	beat b S4+S1
	vol LO_VOL-2
	beat b S2 r E2

    goto musSanctuaryChannel1Measure5
    cmdff

musSanctuaryChannel0:
.redefine HI_VOL $6
.redefine LO_VOL $3
.redefine ECHO_OFFSET S4
; Measure 1-2
; 3/4
	octave 4
	duty $03
    env $1 $00
    vibrato $01
    vol $0
	beat gs3 ECHO_OFFSET

    vol LO_VOL
.rept 2
    beat ds E1 f E2
    beat d Q+S1 r S2+E2
.endr
; Measure 3
; 4/4
    octaveu
    beat c E1 d E2
    octaved
    beat b Q+E1 r E2+Q
    
.rept 2 INDEX REPTCTR

.ifeq REPTCTR 0
musSanctuaryChannel0Measure4:
.else
musSanctuaryChannel0Measure5:
.endif
; Measure 4,5
    octave 5
    duty $02
    env $3 $00
    vibrato $01
    beat g E1 ds E2 c E1 ou c E2
    octaved
    beat b E1 g E2 d E1 od b E2
.endr
; Measure 6
    octave 5
    beat g E1 ds E2 c E1 ou c E2
    octaved
    beat b E1 ou c E2 d E1 od b E2

.rept 2 INDEX REPTCTR
; Measure 7,8
.ifeq REPTCTR 1
    duty $02
    env $3 $00
    vibrato $01
.endif
    octave 6
	beat c E1 od g E2-ECHO_OFFSET

    octave 5
	duty $03
	env $0 $00
	beat ds E1 c E2
	beat od b E1 ou c E2 d E1 od b E2
.ifeq REPTCTR 0
    rest ECHO_OFFSET
.endif
.endr

; Measure 9
    octave 5
    beat c E1 od b E2 ou c E1 od a E2
    beat fs E1 a E2 ou ds E1 d S3+T7 r T8
; Measure 10
    beat d E1 f E2 gs E1 g E2+E1
	beat f E2 d E1 od b E2 r ECHO_OFFSET

    goto musSanctuaryChannel0Measure5
    cmdff


musSanctuaryChannel4:
.redefine HI_VOL $15	;$0f
.redefine LO_VOL $0f	;$08

; Measure 1-2
; 3/4
	octave 2
	duty HI_VOL
.redefine NOTE_END_WAIT T8
.rept 2
	beat gs Q g HF
.endr
; Measure 3
; 4/4
	beat gs Q g Q+HF 
; Measure 4
    rest W

musSanctuaryChannel4Measure5:
; Measure 5
	octave 3
	beat c HF od b HF
; Measure 6
	beat as HF a HF
; Measure 7-8
.rept 2
	beat gs HF g HF
.endr
; Measure 9
	beat fs HF fs HF
; Measure 10
	beat g HF g HF
	goto musSanctuaryChannel4Measure5
    cmdff

.undefine LO_VOL
.undefine HI_VOL
.undefine ECHO_OFFSET
.undefine NOTE_END_WAIT

.define musSanctuaryChannel6 MUSIC_CHANNEL_FALLBACK EXPORT