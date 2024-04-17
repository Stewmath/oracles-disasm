musTheGreatPalaceStart:
	tempo 156

.macro m_musTheGreatPalaceChannel1Measure1
	beat \1 Q \2 E1
	beat \1 E2+E1 \3 E2+E1
	beat \2 E2
.endm

musTheGreatPalaceChannel1:
	.redefine HI_VOL $6
	.redefine LO_VOL $3

; Measure 1
	duty $02
	env $0 $05
	vibrato $02
	vol HI_VOL
	m_musTheGreatPalaceChannel1Measure1 a4 g4 e4
; Measure 2
	octave 4
	beat f E1 g E2 a E1 b E2+E1
	beat a E2 g Q r Q

musTheGreatPalaceChannel1Loop:
	env $0 $05
.rept 2
; Measure 3b,7b
	octave 4
	beat a E1 a E2
	beat b E1 ou c E2 d E1 e E2
; Measure 4,8
	beat b Q+E1 a E2+Q e Q
; Measure 5,9
	beat g Q+E1 fs E2+Q d Q
; Measure 6,10
	beat f Q+E1 e E2+Q c Q+E1 r E2
.endr

; Measure 11b-14
.macro m_musTheGreatPalaceChannel1Measure11b
; Measure 11b
	octave 4
	vol HI_VOL
	beat gs Q ou c E1 d E2+E1
; Measure 11d	
	beat f E2+Q+E1 ds E2+E1 f E2+Q
; Measure 13
	beat g E1 f E2 ds E1 f E2+E1 ds E2 d Q
; Measure 14
	beat ds E1 d E2 c E1 d E2+E1 c E2
	octaved
	beat as Q
.endm
	m_musTheGreatPalaceChannel1Measure11b
; Measure 15-18
	rest Q
	m_musTheGreatPalaceChannel1Measure11b
; Measure 19
	octave 5
	beat c E1 od a E2+E1 ou e E2+HF
; Measure 20
	beat c E1 od a E2+E1 ou g E2+E1 fs E2+Q
; Measure 21
	beat c E1 od a E2+E1 ou e E2+HF
; Measure 22
	octaved
	env $0 $07
	beat e E1 f E2+E1 gs E2+E1 b E2+Q
; Measure 3a
	beat r Q

	goto musTheGreatPalaceChannel1Loop
	cmdff


.macro m_musTheGreatPalaceChannel0Measure3
; Measure 3
	octave 3
	beat a E1 ou c E2 e E1 a E2
	octaved
	beat a E1 ou c E2 e E1 gs E2
.endm

.macro m_musTheGreatPalaceChannel0Measure4
; Measure 4
	octaved
	beat a E1 ou c E2 e E1 g E2	
	octaved
	beat a E1 ou c E2 e E1 fs E2
.endm

musTheGreatPalaceChannel0:
	.redefine HI_VOL $4
	.redefine LO_VOL $2

; Measure 1
	duty $02
	env $0 $06
	vibrato $01
	vol HI_VOL
	m_musTheGreatPalaceChannel1Measure1 e4 d4 b3
; Measure 2
	rest E1
	vol HI_VOL
	octave 4
	beat c E2 c E1 d E2+S1 r S2
	beat d E2 d Q

musTheGreatPalaceChannel0Loop:
; Measure 3-10
	env $0 $06
.rept 4
	m_musTheGreatPalaceChannel0Measure3
	m_musTheGreatPalaceChannel0Measure4
.endr
; Measure 11-18
.rept 16
	octave 3
	beat gs E1 ou c E2 d E1 f E2
.endr
; Measure 19
	m_musTheGreatPalaceChannel0Measure3
; Measure 20
	m_musTheGreatPalaceChannel0Measure4
; Measure 21
	m_musTheGreatPalaceChannel0Measure3
; Measure 22
	env $0 $07
	octave 3
	beat b E1 ou c E2+E1 d E2+E1 e E2+Q

	goto musTheGreatPalaceChannel0Loop
	cmdff
	

.macro m_musTheGreatPalaceChannel4Measure3
	beat \1 E1 r E2
	beat \2 E1 \1 E2
	beat r Q+E1 \2 E2
.endm

musTheGreatPalaceChannel4:
	.redefine HI_VOL $28
	.redefine LO_VOL $08

; Measure 1
	octave 2
	duty HI_VOL
	beat a E1 r E2 g E1 a E2
	beat r E1 e E2 r E1 g E2
; Measure 2
	beat f E1 f E2 f E1 g E2
	beat r E1 g E2 g E1 r E2

musTheGreatPalaceChannel4Loop:
; Measure 3-10
.rept 8
	m_musTheGreatPalaceChannel4Measure3 a2 e2
.endr
; Measure 11-18
.rept 8
	m_musTheGreatPalaceChannel4Measure3 f2 c2
.endr
; Measure 19-21
.rept 3
	m_musTheGreatPalaceChannel4Measure3 a2 e2
.endr
; Measure 22
	octave 2
	beat e E1 f E2 r E1 gs E2
	beat r E1 b E2 r Q

	goto musTheGreatPalaceChannel4Loop
	cmdff



musTheGreatPalaceChannel6:
	.redefine HI_VOL $4
	.redefine LO_VOL $3
	.redefine HIT $2a

; Measure 1
	vol $0
	rest W
musTheGreatPalaceChannel6Loop:
; Measure 2,22
	rest W
; Measure 3-21
	vol HI_VOL
.rept 19
	beat HIT Q+E1 HIT E2+Q HIT Q
.endr
	vol $0

	goto musTheGreatPalaceChannel6Loop
	cmdff
