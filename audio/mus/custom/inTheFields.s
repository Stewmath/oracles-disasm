musInTheFieldsStart:
; Note: BPM must be <= 150 (check Ch0M7)
	tempo 98
musInTheFieldsChannel1:
.redefine HI_VOL $6
.redefine LO_VOL $3
; Measure 1
	octave 5
	duty $02
	env $0 $05
	vol HI_VOL
	beat as T7 ou c T8
; Measure 2-3
	beat cs E1 r E2+Q+HF r W

musInTheFieldsChannel1Measure4:
; Measure 4
	octave 5
	duty $02
	env $0 $05
	vol HI_VOL
	beat cs S1 ds S2 e  E2
	beat ds S1 e  S2 fs E2
	beat e  S1 fs S2 gs E2
	beat fs S1 e  S2 ds E2
; Measure 5
	beat e  S1 fs S2 gs E2
	beat fs S1 gs S2 a  E2
	beat gs S1 fs S2 e  E2
	beat fs S1 e  S2 ds E2	
; Measure 6
	beat cs S1 ds S2 e  E2
	beat ds S1 e  S2 fs E2
	beat e  S1 fs S2 gs E2
	beat fs S1 e  S2 ds E2
; Measure 7
	beat e  S1 fs S2 gs E2
	beat fs S1 gs S2 a  E2
	octave 6
	env $0 $00
	duty $03
	beat cs E1 od b S3 a S4
	beat gs E1 cs S3 od b S4

musInTheFieldsChannel1Measure8:
; Measure 8-9c
	;beat ou cs W r HF+Q+E1
	octaveu
	beat cs HF+Q
	vol LO_VOL
	beat cs Q r HF+Q+E1
; Measure 9d
	octave 4
	vol HI_VOL
	beat a S3 b S4
; Measure 10
	beat ou cs Q
	vol LO_VOL
	beat cs E1

	vol HI_VOL
	beat e E2
	beat od b E1+S3
	vol LO_VOL
	beat b S4+S1 r S2

	vol HI_VOL
	beat gs S3 a S4
; Measure 11
	beat b S1 ou cs S2 od b S3 a S4
	beat gs S1 r S2 e S3 r S4
	
	beat fs E1+S3
	vol LO_VOL
	beat fs S4+S1

	vol HI_VOL
	beat gs S2 a S3 b S4
; Measure 12
	beat ou cs Q
	vol LO_VOL
	beat cs S1

	vol HI_VOL
	beat cs S2 e E2
	beat od b E1+S3
	vol LO_VOL
	beat b S4+S1 r S2

	vol HI_VOL
	beat gs S3 a S4
; Measure 13
	beat b S1 ou cs S2
	
	beat d E2
	vol LO_VOL
	beat d S1

	vol HI_VOL
	beat cs S2 od b S3 a S4
	beat gs Q ou cs Q
; Measure 14
	octaved
	beat fs S1 a S2 ou cs E2
	beat od gs S1 a S2 gs S3 e S4
	beat fs E1+S3
	vol LO_VOL
	beat fs S4+S1 r S2

	vol HI_VOL
	beat fs E2
; Measure 15
	octaveu
	beat cs Q
	beat e S1 ds S2 cs S3 od b S4
	beat ou cs Q
	vol LO_VOL+1
	beat cs E1
	vol LO_VOL
	beat cs S3 r T7

	vol HI_VOL
	beat od b T8
; Measure 16
	beat ou cs E1+S3
	vol LO_VOL
	beat cs S4

	vol HI_VOL
	beat od gs S1 a S2 gs S3 e S4
	beat fs Q r E1 ou fs E2
; Measure 17
	vibrato $81
	beat cs Q
	vol LO_VOL+1
	vibrato $01
	beat cs S1
	vol LO_VOL
	beat cs S2

	vibrato $00
	vol HI_VOL
	beat b E2
	
	
	vibrato $81
	beat cs E1
	vol LO_VOL+1
	vibrato $01
	beat cs S3
	vol LO_VOL
	beat cs S4

	octave 3
	vibrato $00
	vol HI_VOL
	beat gs S1 r S2+E2

	goto musInTheFieldsChannel1Measure4
	cmdff

musInTheFieldsChannel0:
.redefine HI_VOL $6
.redefine LO_VOL $3

; Measure 1 (pickup)
	vol $0
	beat gs1 S4
; Measure 2
	octave 3
	vol HI_VOL
	env $0 $06
	duty $00
	beat gs Q fs Q gs Q b Q
; Measure 3
	beat b Q b Q b Q a Q
; Measure 4
.redefine HI_VOL $4
.redefine LO_VOL $2
	vol HI_VOL
	beat gs Q fs Q gs Q b Q
; Measure 5
	beat b Q b Q b Q a Q
; Measure 6
	beat gs Q fs Q gs Q b Q
; Measure 7
	beat b Q ou c Q 

musInTheFieldsChannel0Measure7cLoop:
; Measure 7c
	octave 5
	env $0 $00
	duty $02
	beat gs E1 fs S3 e S4
	beat ds E1 od gs S3 fs S4-4
	beat gs 2 a 2
; Measure 8
	vibrato $81
	beat gs Q
	vol LO_VOL
	vibrato $01
	beat gs E1
	vol LO_VOL-1
	beat gs E2

	octave 3
	vol HI_VOL+2
	vibrato $00
	env $0 $04
	duty $00
	beat gs E1 gs S3 gs S4
	beat b E1 b S3 b S4
; Measure 9
	beat gs E1 gs S3 gs S4
	beat fs E1 fs S3 fs S4
	beat gs E1 gs S3 gs S4
	beat e E1

	octave 4
	env $0 $00
	duty $02
	beat e S3 gs S4
; Measure 10
	beat a Q
	vol LO_VOL
	beat a E1
	
	vol HI_VOL
	beat ou cs E2
	beat od gs E1+S3
	vol LO_VOL
	beat gs S4+S1 r S2

	vol HI_VOL	
	beat e S3 fs S4
; Measure 11
	beat gs S1 a S2 gs S3 fs S4
	beat e S1 r S2 od b S3 r S4

	beat ou cs E1+S3
	vol LO_VOL
	beat cs S4+S1

	vol HI_VOL
	beat od b S2 ou e S3 gs S4
; Measure 12
	beat a Q
	vol LO_VOL
	beat a S1

	vol HI_VOL	
	beat a S2 ou cs E2
	beat od gs E1+S3
	vol LO_VOL
	beat gs S4+S1 r S2

	vol HI_VOL	
	beat e S3 fs S4
; Measure 13
	beat gs S1 a S2
	
	beat b E2
	vol LO_VOL
	beat b S1

	vol HI_VOL
	beat a S2 gs S3 fs S4
	beat f Q gs Q
; Measure 14
	beat cs S1 fs S2 a E2
	beat e S1 fs S2 e S3 od b S4
	beat ou cs E1+S3
	vol LO_VOL
	beat cs S4+S1 r S2

	vol HI_VOL	
	beat cs E2
; Measure 15
	beat gs Q
	beat b S1 as S2 gs S3 fs S4
	beat gs Q
	vol LO_VOL+1
	beat gs E1
	vol LO_VOL
	beat gs S3 r T7

	vol HI_VOL
	beat gs T8
; Measure 16
	beat a E1+S3
	vol LO_VOL
	beat a S4

	vol HI_VOL
	beat e S1 fs S2 e S3 od b S4
	beat ou cs Q r E1 ou cs E2
; Measure 17
	vibrato $81
	beat od gs Q
	vol LO_VOL+1
	vibrato $01
	beat gs S1
	vol LO_VOL
	beat gs S2

	vibrato $00
	vol HI_VOL	
	beat ou fs E2

	vibrato $81
	beat od a E1
	vol LO_VOL+1
	vibrato $01
	beat a S3
	vol LO_VOL
	beat a S4

	octave 3
	vibrato $00
	vol HI_VOL
	beat ds S1 r S2+E2
; Measure 18
	octave 3
;	vol HI_VOL+2
	env $0 $04
	duty $00
	beat gs E1 gs S3 gs S4
	beat fs E1 fs S3 fs S4
	beat gs E1 gs S3 gs S4
	beat b E1 b S3 b S4
; Measure 19
.rept 3
	beat b E1 b S3 b S4
.endr
	beat a E1 a S3 a S4
; Measure 20 (repeat of M18)
	beat gs E1 gs S3 gs S4
	beat fs E1 fs S3 fs S4
	beat gs E1 gs S3 gs S4
	beat b E1 b S3 b S4
; Measure 21
	beat b E1 b S3 b S4
	beat ou c E1 c S3 c S4
	
	goto musInTheFieldsChannel0Measure7cLoop
	cmdff

musInTheFieldsChannel4:
.redefine CHANNEL 4
.redefine HI_VOL $0e
.redefine LO_VOL $0f
.redefine HI_VOL2 $15
.redefine LO_VOL2 $14

; Measure 1 (pickup)
	beat r S4

.rept 3 INDEX REPTCTR
; Measure 2,4,6
.if REPTCTR > 0
	octave 3
.else
	octave 4
.endif
	;beat cs Q od b Q ou cs Q ds Q
	duty HI_VOL
	beat cs E1
	duty LO_VOL
	beat cs S3 r S4

	octaved
	duty HI_VOL
	beat b E1
	duty LO_VOL
	beat b S3 r S4

	octaveu
	duty HI_VOL
	beat cs E1
	duty LO_VOL
	beat cs S3 r S4

	duty HI_VOL
	beat ds E1
	duty LO_VOL
	beat ds S3 r S4	
.ifeq REPTCTR 0
; Measure 3
	;beat e Q ds Q e Q
	duty HI_VOL
	beat e E1
	duty LO_VOL
	beat e S3 r S4

	duty HI_VOL
	beat ds E1
	duty LO_VOL
	beat ds S3 r S4

	duty HI_VOL
	beat e E1
	duty LO_VOL
	beat e S3 r S4

	duty HI_VOL
	beat cs E1
	octaved
	beat gs E2
.endif
.ifeq REPTCTR 1
; Measure 5
	;beat e Q ds Q e Q cs Q
	duty HI_VOL
	beat e E1
	duty LO_VOL
	beat e S3 r S4

	duty HI_VOL
	beat ds E1
	duty LO_VOL
	beat ds S3 r S4

	duty HI_VOL
	beat e E1
	duty LO_VOL
	beat e S3 r S4

	duty HI_VOL
	beat cs E1
	duty LO_VOL
	beat cs S3 r S4	
.endif
.ifeq REPTCTR 2
; Measure 7
	;beat e Q fs Q a Q gs Q
	duty HI_VOL
	beat e E1
	duty LO_VOL
	beat e S3 r S4

	duty HI_VOL
	beat fs E1
	duty LO_VOL
	beat fs S3 r S4

	duty HI_VOL
	beat a E1
	duty LO_VOL
	beat a S3 r S4

	duty HI_VOL
	beat gs E1
	duty LO_VOL
	beat gs S3 r S4	
.endif
.endr

musInTheFieldsChannel4Measure8Loop:
.macro m_musInTheFieldsChannel4Measure8
	duty HI_VOL
	beat \1 S1
	duty LO_VOL
	beat \1 S2
	duty HI_VOL2
	beat \2 T5 r T6 \2 T7 r T8
.endm
; Measure 8
	m_musInTheFieldsChannel4Measure8 cs3 cs4
	m_musInTheFieldsChannel4Measure8 b2 b3
	m_musInTheFieldsChannel4Measure8 cs3 cs4
	m_musInTheFieldsChannel4Measure8 e3 e4
; Measure 9
	m_musInTheFieldsChannel4Measure8 cs3 cs4
	m_musInTheFieldsChannel4Measure8 b2 b3
	m_musInTheFieldsChannel4Measure8 cs3 cs4
	m_musInTheFieldsChannel4Measure8 gs2 gs3
; Measure 10
	m_musInTheFieldsChannel4Measure8 a2 a3
	m_musInTheFieldsChannel4Measure8 a2 a3
	m_musInTheFieldsChannel4Measure8 e2 e3
	m_musInTheFieldsChannel4Measure8 e2 e3
; Measure 11
	m_musInTheFieldsChannel4Measure8 e2 e3
	m_musInTheFieldsChannel4Measure8 e2 e3
	m_musInTheFieldsChannel4Measure8 fs2 fs3
	m_musInTheFieldsChannel4Measure8 gs2 gs3
; Measure 12
	m_musInTheFieldsChannel4Measure8 a2 a3
	m_musInTheFieldsChannel4Measure8 a2 a3
	m_musInTheFieldsChannel4Measure8 cs3 gs3
	m_musInTheFieldsChannel4Measure8 gs2 gs3
; Measure 13
	m_musInTheFieldsChannel4Measure8 d3 a3
	m_musInTheFieldsChannel4Measure8 d3 a3
	m_musInTheFieldsChannel4Measure8 cs3 gs3
	m_musInTheFieldsChannel4Measure8 f2 gs3
; Measure 14
	m_musInTheFieldsChannel4Measure8 fs2 fs3
	m_musInTheFieldsChannel4Measure8 e2 e3
	m_musInTheFieldsChannel4Measure8 a2 a3
	m_musInTheFieldsChannel4Measure8 b2 b3
; Measure 15
	m_musInTheFieldsChannel4Measure8 a2 a3
	m_musInTheFieldsChannel4Measure8 b2 b3
	m_musInTheFieldsChannel4Measure8 a2 a3
	m_musInTheFieldsChannel4Measure8 gs2 gs3
; Measure 16
	m_musInTheFieldsChannel4Measure8 fs2 fs3
	m_musInTheFieldsChannel4Measure8 e2 e3
	m_musInTheFieldsChannel4Measure8 a2 a3
	m_musInTheFieldsChannel4Measure8 ds3 b3
; Measure 17
	m_musInTheFieldsChannel4Measure8 a2 a3
	m_musInTheFieldsChannel4Measure8 b2 b3
	m_musInTheFieldsChannel4Measure8 a2 a3
	octave 2
	duty HI_VOL
	beat b T1 r T2+S2 gs E2
; Measure 18
	m_musInTheFieldsChannel4Measure8 cs3 cs4
	m_musInTheFieldsChannel4Measure8 b2 b3
	m_musInTheFieldsChannel4Measure8 cs3 cs4
	m_musInTheFieldsChannel4Measure8 ds3 ds4
; Measure 19
	m_musInTheFieldsChannel4Measure8 e3 e4
	m_musInTheFieldsChannel4Measure8 ds3 ds4
	m_musInTheFieldsChannel4Measure8 e3 e4
	m_musInTheFieldsChannel4Measure8 e3 cs4
; Measure 20
	m_musInTheFieldsChannel4Measure8 cs3 cs4
	m_musInTheFieldsChannel4Measure8 b2 b3
	m_musInTheFieldsChannel4Measure8 cs3 cs4
	m_musInTheFieldsChannel4Measure8 ds3 ds4
; Measure 21
	m_musInTheFieldsChannel4Measure8 e3 e4
	m_musInTheFieldsChannel4Measure8 fs3 ds4
	m_musInTheFieldsChannel4Measure8 a3 e4
	m_musInTheFieldsChannel4Measure8 gs3 gs4
	
	goto musInTheFieldsChannel4Measure8Loop
	cmdff

musInTheFieldsChannel6:
.redefine HI_VOL $4
.redefine LO_VOL $3
.redefine HIT $27
.redefine CLICK $2a

; Measure 1-8
	vol $0
	rest S4+W
.rept 4
	rest W
.endr
	rest W+E1

musInTheFieldsChannel6Measure8aLoop:
; Measure 8a-13
	vol LO_VOL
.rept 12 INDEX REPTCTR
	beat HIT S3 HIT S4
	beat r E1 HIT E2
.ifle REPTCTR 11
	beat r E1
.endif
.endr

; Measure 14
	vol HI_VOL
	beat CLICK S1 CLICK S2 CLICK E2
	beat CLICK E1 CLICK S3 CLICK S4
	beat CLICK E1 CLICK E2
	beat CLICK S1 CLICK S2 CLICK E2
; Measure 15
	beat r E1 CLICK S3 CLICK S4		
	beat CLICK E1 CLICK E2
	beat CLICK S1 CLICK S2 CLICK E2
	beat CLICK E1 CLICK S3 CLICK S4
; Measure 16
	beat r E1 CLICK E2	
	beat CLICK S1 CLICK S2 CLICK E2
	beat CLICK E1 CLICK S3 CLICK S4
	beat CLICK E1 CLICK E2
; Measure 17 (repeat of M14)
	beat CLICK S1 CLICK S2 CLICK E2
	beat CLICK E1 CLICK S3 CLICK S4
	beat CLICK E1 CLICK E2
	beat CLICK S1 CLICK S2 CLICK E2

; Measure 18-21
.rept 4 INDEX REPTCTR

	vol LO_VOL
.rept 2
	beat r E1 HIT E2
.endr
	beat r E1
.ifle REPTCTR 3
	beat HIT S3 HIT S4
	beat r E1 HIT E2
.else
	beat HIT E2 HIT E1
	beat HIT E2 r E1
.endif
.endr

	goto musInTheFieldsChannel6Measure8aLoop
	cmdff

.undefine HI_VOL
.undefine LO_VOL
.undefine HIT
.undefine CLICK