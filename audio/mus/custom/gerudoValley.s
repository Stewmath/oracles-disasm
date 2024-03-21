musGerudoValleyStart
	tempo 129
musGerudoValleyChannel1:
	.redefine HI_VOL $08
	.redefine LO_VOL $06

; Measures 1-3
	vol $0
	beat r S1
	vol HI_VOL-1
	duty $01
	env $0 $04
	octave 3

	beat d S2 gs S3
	beat b S4+S1 ou d S2+S3 fs S4+S1
	beat f S2 gs S3 b S4

	octaveu
	beat cs Q+W+W
; Measures 4-5
	octave 4
.rept 4
	env $0 $05
	vol HI_VOL
	beat fs S1
	vol LO_VOL
	beat fs S2 fs S3
	beat fs S4+S1 fs S2+S3 fs S4
.endr
; Measure 6
.rept 2
	env $0 $05
	vol HI_VOL
	beat e S1
	vol LO_VOL
	beat e S2 e S3
	beat e S4+S1 e S2+S3 e S4
.endr
; Measure 7
.rept 2
	octave 4
	env $0 $05
	vol HI_VOL
	beat f S1
	vol LO_VOL
	beat f S2 f S3
	beat f S4+S1 f S2+S3 f S4
.endr

musGerudoValleyChannel1Measure8Loop:
; Measure 8
	octave 4
	vol $0
	beat r S1
	vol HI_VOL
	beat cs S2 fs S3 gs S4
	beat a E1+S3 cs S4 fs S1 gs S2
	beat a E2+Q
; Measure 9
	beat r S1 d S2 fs S3 gs S4
	beat a E1+S3 d S4 fs S1 gs S2
	beat a E2+Q	
; Measure 10
	octaved
	beat r S1 b S2 ou e S3 fs S4
	beat gs E1+S3 od b S4 ou e S1 fs S2
	beat gs E2+Q r S1
; Measure 11a
	octave 4
	beat fs S2 gs S3 fs S4 f Q+HF

; Measure 12
	vol $0
	duty $02
	env $0 $00
	vibrato $01
	octave 4
	vol $0
	beat r S1
	vol HI_VOL
	beat cs S2 fs S3 gs S4
	beat a E1+S3 cs S4 fs S1 gs S2
	beat a E2+Q
; Measure 13
	beat r S1 d S2 fs S3 gs S4
	beat a E1+S3 d S4 fs S1 gs S2
	beat a E2+Q	
; Measure 14
	octaved
	beat r S1 b S2 ou e S3 fs S4
	beat gs E1+S3 od b S4 ou e S1 fs S2
	beat gs E2+Q r S1
; Measure 15a
	beat a S2 b S3 a S4
	vibrato $82
	beat gs Q+HF r E1

; Measure 16a
	vibrato $00
	duty $01
	env $0 $04
	octave 4
	beat cs E2+S1 a S2+E2
	beat gs E1+S3 fs S4+E1 cs E2
; Measure 17
	beat e Q e S1 fs S2 e S3
	beat d S4+Q+E1 r E2+E1
; Measure 18
	octave 3
	beat b E2+S1 ou gs S2+E2
	beat fs E1+S3 e S4+E1 d E2
; Measure 19
	beat cs Q d S1 e S2
	beat d S3 cs S4+HF+E1

; Measure 20a
	vibrato $00
	duty $01
	env $0 $04
	octave 4
	beat cs E2+S1 a S2+E2
	beat gs E1+S3 fs S4+E1 cs E2
; Measure 21a
	beat e Q e S1 fs S2
	beat e S3 d S4+Q+E1

	env $0 $00
	vibrato $01
	beat d E2
; Measures 22-23
	vibrato $82
	beat e Q+E1 fs E2
	beat e Q+E1 d E2
	vibrato $e2
	beat cs W r E1
	vibrato $00
; Measure 24
	env $0 $04
	beat a E2+S1 gs S2+E2
	beat a E1+S3 gs S4+E1 cs E2
; Measure 25
	beat e Q+S1 d S2
	beat cs S3 d S4+HF+E1
; Measure 26
	beat gs E2+S1 fs S2+E2
	beat gs E1+S3 e S4+E1 d E2
; Measure 27
	octave 4
	beat cs Q d S1 e S2
	beat d S3 cs S4+HF+E1

; Measure 28a
	octave 3
	beat fs S3 gs S4
	beat a S1 ou cs S2+E2
	octaved
	beat fs S1 gs S2
	beat a S3 ou cs S4+Q+E1
; Measure 29a
	octaved
	beat fs S3 gs S4
	beat a S1 ou d S2+E2
	octaved
	beat fs S1 gs S2
	beat a S3 ou d S4+E1
	env $0 $00
	vibrato $01
	beat d E2
; Measures 30-31
	vibrato $82
	octaved
	beat b Q+E1 ou gs E2
	beat fs Q+E1 od b E2
	vibrato $e2
	octaveu
	beat cs W
	vibrato $01

; Measure 32
	octave 4
	duty $02
	beat a S1 gs S2
	vibrato $82
	beat a E2+Q+E1
	vibrato $01
	beat fs S3 gs S4
	beat a S1 b S2 a S3 gs S4
; Measure 33
	beat a S1 gs S2
	vibrato $e2
	beat a E2+Q+Q+E1 r E2
	vibrato $01

; Measure 34
	beat gs S1 fs S2
	vibrato $82
	beat gs E2+Q+E1
	vibrato $01
	beat e S3 fs S4
	beat gs S1 a S2 gs S3 fs S4
; Measure 35
	beat gs S1 fs S2
	vibrato $e2
	beat f E2+Q+Q+E1 r E2
	vibrato $01

; Measure 32
	octave 4
	duty $02
	beat a S1 gs S2
	vibrato $82
	beat a E2+Q+E1
	vibrato $01
	beat fs S3 gs S4
	beat a S1 b S2 a S3 gs S4
; Measure 33
	beat a S1 gs S2
	vibrato $e2
	beat a E2+Q+Q+E1 r E2
	vibrato $01

; Measure 38
	octave 4
	beat b S1 a S2
	vibrato $82
	beat b E2+Q+E1
	vibrato $01
	beat gs S3 a S4
	beat b S1 ou cs S2 d S3 e S4
; Measure 39
	beat cs S1 d S2
	vibrato $e2
	beat cs E2+Q+Q+E1 r E2
	vibrato $00

; Measure 40
	octave 4
	duty $01
	env $0 $04
.rept 2
	beat fs E1 a S3
	beat gs S4+E1 a E2
.endr
; Measure 41
.rept 2
	beat d E1 a S3
	beat gs S4+E1 a E2
.endr
; Measure 42
.rept 2
	beat e E1 b S3
	beat as S4+E1 b E2
.endr
; Measure 43
	octaveu
	beat d S1 e S2 d S3 cs S4+Q+HF

	goto musGerudoValleyChannel1Measure8Loop
	cmdff

musGerudoValleyChannel0:
	.redefine HI_VOL $8
	.redefine LO_VOL $6
; Measures 1-3
	duty $01
	env $0 $04
	vol HI_VOL-1
	octave 3
	beat cs HF+S1

	beat gs S2 ds S3 d S4
	beat cs Q+W+W

; Measure 4
	vibrato $00
	env $0 $04
	m_musGerudoValleyChannel0Measure4 a3
; Measure 5
	m_musGerudoValleyChannel0Measure4 d4
; Measure 6
	m_musGerudoValleyChannel0Measure4 b4
; Measure 7
	m_musGerudoValleyChannel0Measure4 cs4

musGerudoValleyChannel0Measure8Loop:
; Measure 8
	m_musGerudoValleyChannel0Measure4 a3
; Measure 9
	m_musGerudoValleyChannel0Measure4 fs3
; Measure 10
	m_musGerudoValleyChannel0Measure4 gs3
; Measure 11
	m_musGerudoValleyChannel0Measure4 f3
; Measure 12
	m_musGerudoValleyChannel0Measure4 a3
; Measure 13
	m_musGerudoValleyChannel0Measure4 fs3
; Measure 14
	m_musGerudoValleyChannel0Measure4 gs3
; Measure 15
	m_musGerudoValleyChannel0Measure4 b3
; Measure 16
	m_musGerudoValleyChannel0Measure4 a3
; Measure 17
	m_musGerudoValleyChannel0Measure4 fs3
; Measure 18
	m_musGerudoValleyChannel0Measure4 gs3
; Measure 19
	m_musGerudoValleyChannel0Measure4 f3
; Measure 20
	m_musGerudoValleyChannel0Measure4 a3
; Measure 21
	octave 3
	vol HI_VOL
	beat fs S1
	vol LO_VOL
	beat fs S2 fs S3
	beat fs S4+S1 fs S2+S3 fs S4

	vol HI_VOL
	beat fs S1
	vol LO_VOL
	beat fs S2 fs S3
	beat fs S4+S1 fs S2 

	vol HI_VOL
	env $0 $00
	octave 3
	beat a E2
	vibrato $81
; Measure 22
	octave 3
	beat b Q+S1 r S2 b S3 r S4
	beat b Q+E1 gs E2	
; Measure 23
	m_musGerudoValleyChannel0Measure4 f3
; Measure 24
	m_musGerudoValleyChannel0Measure4 a3
; Measure 25
	m_musGerudoValleyChannel0Measure4 fs3
; Measure 26
	m_musGerudoValleyChannel0Measure4 gs3
; Measure 27
	m_musGerudoValleyChannel0Measure4 f3
; Measure 28
	m_musGerudoValleyChannel0Measure4 cs3
; Measure 29
	octave 3
	vol HI_VOL
	beat d S1
	vol LO_VOL
	beat d S2 d S3
	beat d S4+S1 d S2+S3 d S4

	vol HI_VOL
	beat d S1
	vol LO_VOL
	beat d S2 d S3
	beat d S4+S1 d S2 

	vol HI_VOL
	env $0 $00
	octave 3
	beat a E2
	vibrato $81
; Measure 30
	octave 3
	beat gs Q+E1 ou e E2 d Q+E1 od gs E2	
; Measure 31
	m_musGerudoValleyChannel0Measure4 f3
; Measure 32
	m_musGerudoValleyChannel0Measure4 a3
; Measure 33
	m_musGerudoValleyChannel0Measure4 fs3
; Measure 34
	m_musGerudoValleyChannel0Measure4 gs3
; Measure 35
	m_musGerudoValleyChannel0Measure4 f3

; Measure 36	
	octave 4
	env $0 $00
	beat cs S1 od b S2
	vibrato $81
	octaveu
	beat cs E2+Q+E1
	vibrato $00
	octaved
	beat a S3 b S4
	octaveu
	beat cs S1 d S2 cs S3 od b S4
; Measure 37
	octaveu
	beat cs S1 od b S2
	vibrato $82
	octaveu
	beat cs E2+Q+E1+S3
	vibrato $00

	env $0 $04
	vol LO_VOL
	octaved
	beat fs S4+S1 fs S2+S3 fs S4
	vol HI_VOL
; Measure 38
	octave 4
	env $0 $00
	beat d S1 cs S2
	vibrato $81
	beat d E2+Q+E1
	vibrato $00
	octaved
	beat b S3 ou c S4
	beat d S1 e S2 fs S3 gs S4
; Measure 39
	beat f S1 fs S2
	vibrato $82
	beat f E2+Q
	vibrato $00
	env $0 $04

	octave 3
	vol HI_VOL
	beat b S1
	vol LO_VOL
	beat b S2 b S3
	beat b S4+S1 b S2+S3 b S4
; Measure 40
	m_musGerudoValleyChannel0Measure4 a3
; Measure 41
	m_musGerudoValleyChannel0Measure4 fs3
; Measure 42
	m_musGerudoValleyChannel0Measure4 gs3
; Measure 43
	m_musGerudoValleyChannel0Measure4 b3

	goto musGerudoValleyChannel0Measure8Loop
	cmdff

musGerudoValleyChannel4:
	.redefine HI_VOL $0e
	.redefine LO_VOL $0f
; Measures 1-3
	beat r W+W r W

musGerudoValleyChannel4Measure4Loop:
; Measure 4
	octave 2
	duty HI_VOL
.rept 2
	beat fs E1+S3 r S4
	beat fs E1 r E2
.endr
; Measure 5
.rept 2
	beat d E1+S3 r S4
	beat d E1 r E2
.endr
; Measure 6
.rept 2
	beat e E1+S3 r S4
	beat e E1 r E2
.endr
; Measure 7
.rept 2
	beat cs E1+S3 r S4
	beat cs E1 r E2
.endr

	goto musGerudoValleyChannel4Measure4Loop
	cmdff

musGerudoValleyChannel6:
	.redefine HI_VOL $7
	.redefine LO_VOL $5
	.redefine CLAP $24

; Measure 1
	beat r W
musGerudoValleyChannel6Measure2:
; Measures 2-7
	vol HI_VOL
	beat CLAP S1
	vol LO_VOL
	beat CLAP S2 CLAP S3

	vol HI_VOL
	beat CLAP S4
	vol LO_VOL
	beat CLAP S1 CLAP S2

	vol HI_VOL
	beat CLAP S3
	vol LO_VOL
	beat CLAP S4

.rept 2
	vol HI_VOL
	beat CLAP S1
	vol LO_VOL
	beat CLAP S2 CLAP S3
	vol HI_VOL
	beat CLAP S4
.endr

	goto musGerudoValleyChannel6Measure2
	cmdff

.undefine CLAP
.undefine HI_VOL
.undefine LO_VOL