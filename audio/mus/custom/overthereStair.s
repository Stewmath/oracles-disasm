musOverthereStairStart:
	tempo 180;177
; BPM = 180, B = 20, M = 60

.macro m_musOverthereStairChannel1Measure49
	m_splitLength \2
	vol HI_VOL
	beat \1 HF1
	vol LO_VOL
	beat \1 HF2
.endm

musOverthereStairChannel1:
;.redefine BEAT 10     ;eigth
;.redefine LO_VOL_RATIO 1/2

.redefine HI_VOL $6
.redefine LO_VOL $3
; Measure 1-4
    vol $0
    beat g3 3*(HF+Q)+Q
 
    octave 5
    vol HI_VOL
	duty $01
    env $1 $00
    beat d E1

musOverthereStairChannel1Measure4bLoop:
; Measure 4b
    octave 5
    beat e E2 fs E1 g E2
; Measure 5
    beat a E1 ou d E2
    octaved
    vibrato $81
    beat a Q
    vibrato $01
	env $0 $00
    vol LO_VOL
    beat a E1
    vol LO_VOL-2
    beat a E2
; Measure 6
    vibrato $00
    env $1 $00
    vol HI_VOL
    beat as E1 ou f E2
	octaved
    beat as Q+E1 ou c E2
; Measure 7
    octaved
    vibrato $e1 
    beat a Q+E1
    vibrato $01
	env $0 $00
    vol LO_VOL
    beat a E2+E1
    vol LO_VOL-2
    beat a E2 r Q

; Measure 8b
    vibrato $00
    env $1 $00
    vol HI_VOL
    beat d E1 e E2 fs E1 g E2
; Measure 9
    beat a E1 ou d E2
    octaved
    vibrato $81   
    beat a Q
    vibrato $01
	env $0 $00 
    vol LO_VOL
    beat a E1
    vol LO_VOL-2
    beat a E2
; Measure 10
    vibrato $00
    env $1 $00
    vol HI_VOL
    beat as E1 ou f E2
	octaveu
    beat c Q+E1 d E2
; Measure 11
    octaved
    vibrato $e1  
    beat a Q+E1
    vibrato $01
	env $0 $00
    vol LO_VOL
    beat a E2+E1
    vol LO_VOL-2
    beat a E2 r Q+E1
; Measure 12b
    vibrato $00

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
	beat a S4
; Measure 13
    vol HI_VOL
	env $1 $00
    beat as Q+E1 gs E2 fs E1 ds E2
; Measure 14
    vibrato $81      
    beat e Q
    vibrato $01
	env $0 $00
    vol LO_VOL
    beat e E1
    vol LO_VOL-2
    beat e E2

    vibrato $00
	vol HI_VOL
    beat f E1
	vol LO_VOL-1
	beat f E2
; Measure 15
    vol HI_VOL
    env $1 $00
    beat gs Q+E1 fs E2 e E1 cs E2   
; Measure 16
    vibrato $81     
    beat d Q
    vibrato $01
	env $0 $00
    vol LO_VOL
    beat d E1
    vol LO_VOL-2
    beat d E2

    vibrato $00
	vol HI_VOL
    beat ds E1
	vol LO_VOL-1
	beat ds E2
; Measure 17
    vol HI_VOL
    env $1 $00
    beat fs Q+E1 e E2 d E1 cs E2   
; Measure 18
    beat c Q+E1 c E2 od b E1 ou c E2
; Measure 19
    beat cs Q+E1 od a E2
	octaveu
    beat a E1
	vol LO_VOL-1
	beat a E2 r Q
; Measure 20b 
	octave 3
	duty $02
	vol HI_VOL
	env $0 $00
	beat g E1 a E2 b E1 ou c E2
; Measure 21
	beat d E1 g E2
    vibrato $82
    beat d Q
    vibrato $02
	;env $0 $00
    vol LO_VOL
    beat d E1
    vol LO_VOL-2
    beat d E2
; Measure 22
    vibrato $00
    ;env $1 $00
    vol HI_VOL
    beat ds E1 as E2
    beat ds Q+E1 f E2
; Measure 23
    vibrato $e1 
    beat d HF
    vibrato $02
	;env $0 $00
    vol LO_VOL
    beat d Q
    vol LO_VOL-2
    beat d Q

; Measure 24b
	octaved
    vibrato $00
    ;env $1 $00
	vol HI_VOL
	beat g E1 a E2 b E1 ou c E2
; Measure 25
	beat d E1 g E2
    vibrato $82
    beat d Q
    vibrato $02
	;env $0 $00
    vol LO_VOL
    beat d E1
    vol LO_VOL-2
    beat d E2	
; Measure 26
    vibrato $00
    ;env $1 $00
    vol HI_VOL
    beat ds E1 as E2
    beat ou f Q+E1 g E2
; Measure 27
    vibrato $e1  
    beat d HF
    vibrato $02
	;env $0 $00
    vol LO_VOL
    beat d Q+E1
    vol LO_VOL-2
    beat d E2+E1
; Measure 28b
    vibrato $00
	octave 6

	vol HI_VOL
    beat d S3
	vol LO_VOL
	beat d S4

	vol HI_VOL
    beat d S1
	vol LO_VOL
	beat d S2
	
	vol HI_VOL
    beat d S3
	vol LO_VOL
	beat d S4	
; Measure 29
    vol HI_VOL
	;env $1 $00
    beat ds Q+E1 cs E2 od b E1 gs E2
; Measure 30
    vibrato $82      
    beat a Q
    vibrato $02
	;env $0 $00
    vol LO_VOL
    beat a E1
    vol LO_VOL-2
    beat a E2

    vibrato $00
    vol HI_VOL
	beat as E1
	vol LO_VOL-1
	beat as E2
; Measure 31
    vol HI_VOL
    ;env $1 $00
	octaveu
    beat cs Q+E1 od b E2 a E1 fs E2   
; Measure 32
    vibrato $82     
    beat g Q
    vibrato $02
	;env $0 $00
    vol LO_VOL
    beat g E1
    vol LO_VOL-2
    beat g E2

    vibrato $00
    vol HI_VOL
	beat gs E1
	vol LO_VOL-1
	beat gs E2
; Measure 33
    vol HI_VOL
    ;env $1 $00
    beat b Q+E1 a E2 g E1 fs E2   
; Measure 34
    beat f Q+S1 r S2
	beat f E2 e E1 f E2
; Measure 35
    beat fs Q+E1 d E2
	octaveu
    beat d E1
	vol LO_VOL-1
	beat d E2 r Q
; Measure 36b
	octave 3
	duty $03
	vol HI_VOL
	;env $0 $00
    vibrato $82     
    beat g Q
    vibrato $02
    vol LO_VOL
    beat g E1
    vol LO_VOL-2
    beat g E2

; Measure 37
	octave 5
	env $0 $07
	vibrato $00
	duty $02
	vol HI_VOL
	beat g E1 e E2 c E1
	octaved
	beat a E2 e E1
	vol LO_VOL
	beat e E2
; Measure 38
	vol HI_VOL
	octaveu
	beat gs E1 ds E2 od as E1
	beat gs E2 ou gs E1 as E2
; Measure 39
	beat g E1
	vol LO_VOL
	beat g E2

	vol HI_VOL
	octave 4
	duty $03
	vibrato $42
	env $0 $00
	beat f Q e Q
; Measure 40
	beat ds Q d Q

	octave 5
	env $0 $07
	duty $02
	vibrato $00
	beat a E1
	vol LO_VOL
	beat a E2
; Measure 41
	vol HI_VOL
	beat as E1 g E2 d E1
	octaved
	beat as E2 g E1
	vol LO_VOL
	beat g E2
; Measure 42
	vol HI_VOL
	octaveu
	beat a E1 ds E2 c E1
	octaved
	beat a E2 ou a E1 ou c E2
; Measure 43
	octaved
	beat as E1
	vol LO_VOL
	beat as E2

	vol HI_VOL
	octave 4
	duty $03
	vibrato $42
	env $0 $00
	beat d Q c Q
; Measure 44
	octaved
	beat as Q

	env $0 $07
	duty $02
	vibrato $00
	octave 5
	beat d E1 e E2 f E1 g E2
; Measure 45
    vibrato $82     
    beat a Q
    vibrato $02
	env $0 $00
    vol LO_VOL
    beat a E1
    vol LO_VOL-2
    beat a E2

	vol HI_VOL
	env $0 $07
	vibrato $00
	beat a Q
; Measure 46
	beat g Q+E1 f E2 e E1 f E2
; Measure 47
	octaveu
    vibrato $82     
    beat c Q
    vibrato $02
	env $0 $00
    vol LO_VOL
    beat c E1
    vol LO_VOL-2
    beat c E2	

	octaved
	vol HI_VOL
	env $0 $07
	vibrato $00
	beat a Q
; Measure 48
	beat f E1 a E2
	octaveu
	beat ds E1
	vol LO_VOL-1
	beat ds E2
	vol HI_VOL
	beat d E1
	vol LO_VOL-1
	beat d E2

; Measure 49
	octave 4
	env $0 $04
	m_musOverthereStairChannel1Measure49 as4 E1
	m_musOverthereStairChannel1Measure49 g4 E2
	m_musOverthereStairChannel1Measure49 g4 E1
	m_musOverthereStairChannel1Measure49 ds4 E2
	m_musOverthereStairChannel1Measure49 a4 E1
	m_musOverthereStairChannel1Measure49 fs4 E2
; Measure 50
	m_musOverthereStairChannel1Measure49 gs4 E1
	m_musOverthereStairChannel1Measure49 f4 E2
	m_musOverthereStairChannel1Measure49 f4 E1
	m_musOverthereStairChannel1Measure49 cs4 E2
	m_musOverthereStairChannel1Measure49 g4 E1
	m_musOverthereStairChannel1Measure49 e4 E2
; Measure 51
	m_musOverthereStairChannel1Measure49 fs4 E1
	m_musOverthereStairChannel1Measure49 ds4 E2
	m_musOverthereStairChannel1Measure49 ds4 E1
	m_musOverthereStairChannel1Measure49 b3 E2
	m_musOverthereStairChannel1Measure49 f4 E1
	m_musOverthereStairChannel1Measure49 d4 E2
; Measure 52
	m_musOverthereStairChannel1Measure49 e4 E1
	m_musOverthereStairChannel1Measure49 cs4 E2
	m_musOverthereStairChannel1Measure49 cs4 E1
	m_musOverthereStairChannel1Measure49 a3 E2
	m_musOverthereStairChannel1Measure49 ds4 E1
	m_musOverthereStairChannel1Measure49 c4 E2

; Measure 53
	octave 5
	vol HI_VOL
	beat d E1 od a E2
	octaveu
	beat d E1 e E2 fs Q
; Measure 54
	beat g E1 a E2
	beat as E1 ou c E2
	beat d Q
; Measure 55
	beat cs E1 od a E2
	beat a E1 e E2
	beat e Q
; Measure 56
	octaveu
	beat c E1 od a E2 fs E1
	beat g E2 ou c E1 d E2
; Measure 57
	beat e E1 c E2
	octaved
	beat g E1 e E2
	beat c Q
; Measure 58
	octaveu
	beat g E1 e E2 
	beat c E1 od g E2
	beat e Q
; Measure 59
	octaveu
	beat b E1 g E2 
	beat e E1 c E2
	octaved
	beat g Q
; Measure 60
	octave 6
	vol HI_VOL+3
    beat d S3
	vol LO_VOL+3
	beat d S4

	vol HI_VOL+3
    beat d S1
	vol LO_VOL+3
	beat d S2
	
	vol HI_VOL+3
    beat d S3
	vol LO_VOL+3
	beat d S4

 ;   vol $6
	duty $01
    env $1 $00
	goto musOverthereStairChannel1Measure4bLoop
    cmdff

.macro m_musOverthereStairChannel0Measure23
	m_splitLength \2
	vol HI_VOL
	beat \1 HF1
	vol LO_VOL
	beat \1 HF2
.endm

musOverthereStairChannel0:
.redefine HI_VOL $6
.redefine LO_VOL $3

	vol $0
	beat gs3 Q

.rept 3 INDEX REPTCTR
.ifeq REPTCTR 1
musOverthereStairChannel0Measure5bLoop:
.endif
; Measure 1b,5b,9b
	octave 5
	env $0 $05
	vibrato $01
	duty $02	
	vol LO_VOL
    beat fs E1 d E2
	octaved
	beat b E1 g E2
; Measure 2,6,10
    octaveu
    beat g E1 ds E2 c E1
    octaved
    beat gs E2 ds E1 r E2+Q
; Measure 3b,7b,11b
    octaveu
    beat fs E1 d E2 od b E1 g E2
; Measure 4,8,12
    octaveu
    beat f E1 cs E2 od as E1
	beat f E2 cs E1 
.ifle REPTCTR 2	
	rest E2+Q
.else
	rest E2+E1
.endif
.endr

; Measure 13a
	octave 4
	beat gs E2 b E1
	octaveu
	beat ds E2 fs E1 gs E2
; Measure 14
	beat b E1 gs E2 f E1
	beat cs E2 od b E1 gs E2 r E1
; Measure 15a
	beat fs E2 a E1
	octaveu
	beat cs E2 e E1 fs E2
; Measure 16
	beat a E1 fs E2 ds E1
	octaved
	beat b E2 a E1 r E2+E1
; Measure 17a
	beat e E2 g E1
	beat b E2 ou d E1 e E2
; Measure 18
	beat f E1 ds E2 cs E1
	octaved
	beat as E2 f E1 ds E2
; Measure 19
	beat c E1 d E2 f E1
	beat a E2 ou c E1 e E2
; Measure 20
	beat fs E1


; Measure 20a
	octave 5
	duty $01
	env $1 $00
	vol HI_VOL
	beat g E2
	octaveu
	vibrato $83
	beat g Q
	env $0 $00
	vibrato $3
	vol LO_VOL
	beat g E1
	vol LO_VOL-2
	beat g E2
; Measure 21
	vibrato $00
	env $3 $07
	duty $02
.redefine HI_VOL $4
.redefine LO_VOL $2
.rept 2
; Measure 21,25
	vol HI_VOL
	octave 5
	beat d E1 g E2 d HF
; Measure 22,26
	beat g Q f Q+E1 ds E2
; Measure 23,27
	beat d E1
	octaved
	m_musOverthereStairChannel0Measure23 b4 E2
	m_musOverthereStairChannel0Measure23 a4 E1
	m_musOverthereStairChannel0Measure23 b4 E2
	m_musOverthereStairChannel0Measure23 g4 E1
	m_musOverthereStairChannel0Measure23 b4 E2 
; Measure 24,28
	m_musOverthereStairChannel0Measure23 f4 E1
	m_musOverthereStairChannel0Measure23 b4 E2
	m_musOverthereStairChannel0Measure23 ds4 E1
	m_musOverthereStairChannel0Measure23 b4 E2
	m_musOverthereStairChannel0Measure23 d4 E1
	m_musOverthereStairChannel0Measure23 b4 E2
.endr

; Measure 29
	rest Q
.redefine HI_VOL $6
.redefine LO_VOL $3
	duty $01
	env $0 $07
.rept 2
	m_musOverthereStairChannel0Measure23 b3 Q 
.endr
; Measure 30
	rest Q
	m_musOverthereStairChannel0Measure23 cs4 Q 
	rest Q+Q
; Measure 31b
.rept 2
	m_musOverthereStairChannel0Measure23 a3 Q 
.endr
; Measure 32
	rest Q
	m_musOverthereStairChannel0Measure23 b3 Q 
	rest Q+Q
; Measure 33b
.rept 2
	m_musOverthereStairChannel0Measure23 g3 Q 
.endr
; Measure 34
	rest Q
.rept 2
	m_musOverthereStairChannel0Measure23 as3 Q 
.endr
; Measure 35
	rest Q
.rept 2
	m_musOverthereStairChannel0Measure23 a3 Q 
.endr

; Measure 36
	rest E1
	octave 5
	duty $01
	env $1 $00
	vol HI_VOL
	beat d E2
	octaveu
	vibrato $83
	beat d Q+E1
	env $0 $00
	vibrato $03
	vol LO_VOL
	beat d E2
	vol LO_VOL-2
	beat d E1
; Measure 37a

.redefine ECHO_OFFSET 3
	rest ECHO_OFFSET
	octave 5
	vibrato $00
	env $2 $07
	duty $02
	vol LO_VOL
	beat g E2 e E1
	beat c E2 od a E1
	beat e E2+E1
; Measure 38a
	octave 5
	beat gs E2 ds E1
	octaved
	beat as E2
	note gs4 E1
	note gs5 E2-ECHO_OFFSET
; Measure 39
	duty $01
	env $0 $07
	m_musOverthereStairChannel0Measure23 f3 Q
	vol HI_VOL
	octave 4
	duty $03
	vibrato $42
	env $0 $00		
	beat c Q od b Q
; Measure 40
	beat as E1+S3+T7 r T8	
	beat as Q a Q r E1+ECHO_OFFSET
; Measure 41a
	octave 5
	vibrato $00
	env $2 $07
	duty $02
	vol LO_VOL

	beat as E2 g E1
	beat d E2 od as E1 g E2+E1
; Measure 42a
	octaveu
	beat a E2 ds E1
	beat c E2 od a E1
	octaveu
	beat a E2 ou c E1
; Measure 43a
	octaved
	beat as E2-ECHO_OFFSET
	vol HI_VOL
	octave 3
	duty $03
	vibrato $42
	env $0 $00	
	beat as Q a Q
; Measure 44
	beat d Q

	env $0 $07
	duty $02
	vibrato $00
	octave 4
	beat d E1 e E2 f E1 g E2
; Measure 45
    vibrato $82     
    beat a Q
    vibrato $00
.rept 2
	m_musOverthereStairChannel0Measure23 d4 Q
.endr
; Measure 46
	vol HI_VOL
	beat g Q
	beat d E1 f E2 e E1 f E2
; Measure 47
	octaveu
    vibrato $82     
    beat c Q
	octaved
    vibrato $00
.rept 2
	m_musOverthereStairChannel0Measure23 c4 Q
.endr
; Measure 48
	vol HI_VOL
	beat f E1 a E2
	m_musOverthereStairChannel0Measure23 ds5 Q
	m_musOverthereStairChannel0Measure23 d5 Q

; Measure 49
	octave 3
	duty $03
	vibrato $42
	env $0 $00	
	m_musOverthereStairChannel0Measure23 g3 Q
	rest Q
	m_musOverthereStairChannel0Measure23 fs3 Q
; Measure 50
	m_musOverthereStairChannel0Measure23 f3 Q
	rest Q
	m_musOverthereStairChannel0Measure23 e3 Q
; Measure 51
	m_musOverthereStairChannel0Measure23 ds3 Q
	rest Q
	m_musOverthereStairChannel0Measure23 d3 Q
; Measure 52
	m_musOverthereStairChannel0Measure23 cs3 Q
	rest Q
	m_musOverthereStairChannel0Measure23 c3 Q

; Measure 53
	octave 3
	vol HI_VOL
	vibrato $00
	duty $02
	env $0 $07	
	beat d E1 od a E2
	octaveu
	beat d E1 e E2 fs Q
; Measure 54
	beat g E1 a E2
	beat as E1 ou c E2 d Q
; Measure 55
	beat cs E1 od a E2
	beat a E1 e E2 g Q
; Measure 56
	octaveu
	beat c E1 od a E2
	octaveu
	beat c E1 d E2
	beat a E1 b E2
; Measure 57
	beat a E1 ou c E2
	octaved
	beat g E1 e E2 c Q
; Measure 58
	octaveu
	beat d E1 e E2
	beat c E1 od g E2 e Q
; Measure 59
	octaveu
	beat e E1 g E2
	beat e E1 c E2 od g Q
; Measure 60
	octave 3
.redefine HI_VOL $9
.redefine LO_VOL $6

	m_musOverthereStairChannel0Measure23 a E1
	m_musOverthereStairChannel0Measure23 a E2
	m_musOverthereStairChannel0Measure23 a E1

	rest E2+Q+Q
	goto musOverthereStairChannel0Measure5bLoop
    cmdff

.macro m_musOverthereStairChannel4Measure1a
	m_splitLength \2
	duty HI_VOL
	beat \1 TR1+TR2
	duty LO_VOL
	beat \1 TR3
.endm
.macro m_musOverthereStairChannel4Measure1b
	m_splitLength \2
	duty HI_VOL2
	beat \1 TR1+TR2
	duty LO_VOL2
	beat \1 TR3
.endm
.macro m_musOverthereStairChannel4Measure39b
	m_splitLength \2
	duty HI_VOL2
	beat \1 HF1+QR3
	duty LO_VOL2
	beat \1 QR4
.endm

musOverthereStairChannel4:
.redefine HI_VOL $0e
.redefine LO_VOL $0f
.redefine HI_VOL2 $0e
.redefine LO_VOL2 $0f

.rept 3 INDEX REPTCTR
.ifeq REPTCTR 1
musOverthereStairChannel4Measure5Loop:
.endif
; Measure 1,5,9
	m_musOverthereStairChannel4Measure1a g2 Q
	m_musOverthereStairChannel4Measure1b b3 Q
	m_musOverthereStairChannel4Measure1b b3 Q
; Measure 2,6,10
	m_musOverthereStairChannel4Measure1a gs2 Q
	m_musOverthereStairChannel4Measure1b c4 Q 
	rest Q
; Measure 3,7,11
	m_musOverthereStairChannel4Measure1a g2 Q
	m_musOverthereStairChannel4Measure1b b3 Q
	m_musOverthereStairChannel4Measure1b b3 Q
.ifle REPTCTR 2
; Measure 4,8
	m_musOverthereStairChannel4Measure1a fs2 Q
	m_musOverthereStairChannel4Measure1b f3 Q
	rest Q
.endif
.endr

; Measure 12
	octave 2
	m_musOverthereStairChannel4Measure1a g2 Q
	m_musOverthereStairChannel4Measure1b b3 Q
	rest Q
; Measure 13
	m_musOverthereStairChannel4Measure1a gs2 Q
	m_musOverthereStairChannel4Measure1b b3 Q
	m_musOverthereStairChannel4Measure1b b3 Q
; Measure 14
	m_musOverthereStairChannel4Measure1a cs3 Q
	m_musOverthereStairChannel4Measure1b b3 Q
	rest Q
; Measure 15
	m_musOverthereStairChannel4Measure1a fs2 Q
	m_musOverthereStairChannel4Measure1b a3 Q
	m_musOverthereStairChannel4Measure1b a3 Q
; Measure 16
	m_musOverthereStairChannel4Measure1a b2 Q
	m_musOverthereStairChannel4Measure1b a3 Q
	rest Q

; Measure 17
	m_musOverthereStairChannel4Measure1a e2 Q
	m_musOverthereStairChannel4Measure1b g3 Q
	m_musOverthereStairChannel4Measure1b g3 Q
; Measure 18
	m_musOverthereStairChannel4Measure1a ds2 Q
	m_musOverthereStairChannel4Measure1b as3 Q
	m_musOverthereStairChannel4Measure1b as3 Q
; Measure 19
	m_musOverthereStairChannel4Measure1a d2 Q
	m_musOverthereStairChannel4Measure1b f3 Q
	m_musOverthereStairChannel4Measure1b f3 Q
; Measure 20
	m_musOverthereStairChannel4Measure1a g2 Q
	rest HF

.rept 2
; Measure 21,25
	m_musOverthereStairChannel4Measure1a c2 Q
	m_musOverthereStairChannel4Measure1b d3 Q
	m_musOverthereStairChannel4Measure1b d3 Q
; Measure 22,26	
	m_musOverthereStairChannel4Measure1a cs2 Q
	m_musOverthereStairChannel4Measure1b ds3 Q
	rest Q
; Measure 23,27
	m_musOverthereStairChannel4Measure1a c2 Q
	m_musOverthereStairChannel4Measure1b d3 Q
	m_musOverthereStairChannel4Measure1b d3 Q	
; Measure 24,28
	m_musOverthereStairChannel4Measure1a cs2 Q
	m_musOverthereStairChannel4Measure1b d3 Q
	rest Q
.endr

; Measure 29
	m_musOverthereStairChannel4Measure1a cs2 Q
	m_musOverthereStairChannel4Measure1b e3 Q
	m_musOverthereStairChannel4Measure1b e3 Q
; Measure 30
	m_musOverthereStairChannel4Measure1a fs2 Q
	m_musOverthereStairChannel4Measure1b e3 Q
	rest Q
; Measure 31
	m_musOverthereStairChannel4Measure1a b1 Q
	m_musOverthereStairChannel4Measure1b d3 Q
	m_musOverthereStairChannel4Measure1b d3 Q
; Measure 32
	m_musOverthereStairChannel4Measure1a e2 Q 
	m_musOverthereStairChannel4Measure1b d3 Q
	rest Q

; Measure 33
	m_musOverthereStairChannel4Measure1a a1 Q 
	m_musOverthereStairChannel4Measure1b c3 Q
	m_musOverthereStairChannel4Measure1b c3 Q
; Measure 34
	m_musOverthereStairChannel4Measure1a gs1 Q
	m_musOverthereStairChannel4Measure1b ds3 Q
	m_musOverthereStairChannel4Measure1b ds3 Q
; Measure 35
	m_musOverthereStairChannel4Measure1a g1 Q
	m_musOverthereStairChannel4Measure1b as2 Q
	m_musOverthereStairChannel4Measure1b as2 Q
; Measure 36
	octave 2
	duty HI_VOL
	beat c Q
	octaveu
	beat e Q+E1
	duty LO_VOL
	beat e E2

; Measure 37-38
	octave 2
	duty HI_VOL
	beat f HF+Q fs HF+Q
; Measure 39
	m_musOverthereStairChannel4Measure1a f Q 
	m_musOverthereStairChannel4Measure39b a3 Q
	m_musOverthereStairChannel4Measure39b gs3 Q
; Measure 40
	m_musOverthereStairChannel4Measure39b g3 Q
	m_musOverthereStairChannel4Measure39b g3 Q
	m_musOverthereStairChannel4Measure39b fs3 Q

; Measure 41-42
	duty HI_VOL
	octave 2
	beat g HF+Q fs HF+Q
; Measure 43
	beat g Q
	m_musOverthereStairChannel4Measure39b g3 Q
	m_musOverthereStairChannel4Measure39b fs3 Q
; Measure 44
	duty HI_VOL
	beat g2 Q r HF

; Measure 45
	m_musOverthereStairChannel4Measure1a b2 Q
	m_musOverthereStairChannel4Measure1b a3 Q
	m_musOverthereStairChannel4Measure1b a3 Q
; Measure 46
	m_musOverthereStairChannel4Measure1a as2 Q
	m_musOverthereStairChannel4Measure1b f3 Q
	m_musOverthereStairChannel4Measure1b f3 Q
; Measure 47
	m_musOverthereStairChannel4Measure1a a2 Q
	m_musOverthereStairChannel4Measure1b a3 Q
	m_musOverthereStairChannel4Measure1b a3 Q
; Measure 48
	m_musOverthereStairChannel4Measure1a gs2 Q
	m_musOverthereStairChannel4Measure1b a3 Q
	m_musOverthereStairChannel4Measure1b a3 Q

; Measure 49
	m_musOverthereStairChannel4Measure1a g2 Q
	rest Q
	m_musOverthereStairChannel4Measure1a fs2 Q
; Measure 50
	m_musOverthereStairChannel4Measure1a f2 Q
	rest Q
	m_musOverthereStairChannel4Measure1a e2 Q
; Measure 51
	m_musOverthereStairChannel4Measure1a ds2 Q
	rest Q
	m_musOverthereStairChannel4Measure1a d2 Q
; Measure 52
	m_musOverthereStairChannel4Measure1a cs2 Q
	rest Q
	m_musOverthereStairChannel4Measure1a c2 Q

; Measure 53
    octave 2
    duty $08
    beat d S1 e S2 fs S3
    duty $0f
    beat g S4 a S1 b S2
    duty $14 
    beat ou c S3 d S4 e S1
    duty $09
    beat fs S2 g S3 a S4
; Measure 54
	octave 2
    duty $0f
    beat g S1 a S2 as S3
    beat $14
    beat ou c S4 d S1 e S2
    duty $09
    beat f S3 g S4 a S1
    duty $15
    beat as S2 ou c S3 d S4
; Measure 55
	octave 2
    duty $14
    beat a S1 b S2 ou cs S3
    beat $09
    beat d S4 e S1 fs S2
    duty $15
    beat g S3 a S4 b S1
	duty $07
    beat ou cs S2 d S3 e S4

; Measure 56
	m_musOverthereStairChannel4Measure1a d2 Q
	duty HI_VOL
	beat c3 HF
; Measure 57
	m_musOverthereStairChannel4Measure1a a4 Q
	m_musOverthereStairChannel4Measure1b d3 Q
	m_musOverthereStairChannel4Measure1b d3 Q
; Measure 58
	m_musOverthereStairChannel4Measure1a e4 Q
	m_musOverthereStairChannel4Measure1b d3 Q
	m_musOverthereStairChannel4Measure1b d3 Q
; Measure 59
	m_musOverthereStairChannel4Measure1a c4 Q
	m_musOverthereStairChannel4Measure1b d3 Q
	m_musOverthereStairChannel4Measure1b d3 Q
; Measure 60
	m_musOverthereStairChannel4Measure1a d2 E1
	m_musOverthereStairChannel4Measure1a d2 E2
	m_musOverthereStairChannel4Measure1a d2 E1
    rest E2+Q

	goto musOverthereStairChannel4Measure5Loop
	cmdff

.define musOverthereStairChannel6 MUSIC_CHANNEL_FALLBACK EXPORT