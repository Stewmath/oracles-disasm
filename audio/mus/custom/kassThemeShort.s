musKassThemeShortStart:
	tempo 176
musKassThemeShortChannel1:
	.redefine HI_VOL $8
	.redefine LO_VOL $6

; Measure 1
	duty $01
	vol $0
	beat gs3 E1
musKassThemeShortChannel1Measure1aLoop:
; Measure 1a,17a
	vol LO_VOL
	vibrato $a2
	env $1 $00
	octave 4
	beat e E2+S1 f S2 e S3 ds S4
	beat e E1 ou c E2
; Measure 2
	octaved
	beat b HF+Q r E1
; Measure 3a
	beat e E2+S1 f S2 e S3 ds S4
	beat e E1 b E2
; Measure 4
	beat a HF+Q r E1
; Measure 5a
	beat a E2+S1 b S2 a S3 gs S4
	beat a E1 ou g E2
; Measure 6
	beat f S1 r S2+E2+E1 f S3 r S4
	.redefine NOTE_END_WAIT S2+E2	
	beat f Q
; Measure 7
	beat f Q g Q f Q
	.redefine NOTE_END_WAIT 0
; Measure 8
	beat f Q e HF+E1 r E2+E1
; Measure 9c
	vol HI_VOL
	beat c E2 d E1 e S3 r S4
; Measure 10
	beat e Q+E1 d S3 r S4 d Q+E1 r E2+E1
; Measure 11
	beat d E2
	beat e E1 d E2
; Measure 12
	beat e T1 d T2+S2+E2+E1 c S1 r S2 c Q+E1+S3 r S4+Q 
; Measure 13c
	octaved
	beat a E1 b E2
; Measure 14
	vol HI_VOL+1
	octaveu
	beat c Q+E1 d E2 c Q
; Measure 15
	vol HI_VOL
	vibrato $82
	.redefine NOTE_END_WAIT S2+E2
	octaved
	beat b Q ou e Q c Q
; Measure 16
	vibrato $a2
	.redefine NOTE_END_WAIT 0
	octaved
	beat a HF+Q r E1

	goto musKassThemeShortChannel1Measure1aLoop
	cmdff

musKassThemeShortChannel0:
.redefine HI_VOL $6
.redefine LO_VOL $4

; Measure 1
	vol $0
	beat gs3 HF+Q+Q
musKassThemeShortChannel0Measure2bLoop:
; Measure 2b
	vol LO_VOL-1
	octave 4
	env $1 $00
	vibrato $00
	duty $00
	beat f S1 r S2+E2 a Q r Q
; Measure 3b
	beat gs S1 r S2+E2 gs E1 r E2+Q
; Measure 4b
	beat c S1 r S2+E2 e Q r Q
; Measure 5b
	beat g S1 r S2+E2 g Q
; Measure 6
	vol LO_VOL
	env $0 $00
	vibrato $a1
	octave 5
	beat d S1 r S2+E2+E1 d S1 r S2
	.redefine NOTE_END_WAIT S2+E2	
	beat d Q
; Measure 7
	beat d Q e Q d Q
	.redefine NOTE_END_WAIT 0
; Measure 8
	beat d Q c HF+E1 r E2
; Measure 9a
	.redefine NOTE_END_WAIT S2+E2
	vol LO_VOL-1
	env $1 $00
	vibrato $00
	octaved
	beat g Q e Q
	.redefine NOTE_END_WAIT 0
; Measure 10
	vol LO_VOL
	vibrato $a1
	env $0 $00
	octaveu
	beat c Q+E1 od as S3 r S4
	beat as Q+E1+S3 r S4
; Measure 11b
	vol LO_VOL-1
	env $1 $00
	vibrato $00
	beat f S1 r S2+E2 f E1 r E2
; Measure 12
	vol HI_VOL
	vibrato $a1
	env $0 $00
	octave 5
	beat c T1 od b T2+S2+E2+E1 a S3 r S4
	beat a Q+E1 r E2
; Measure 13b
	.redefine NOTE_END_WAIT S2+E2
	vol LO_VOL-1
	vibrato $00
	env $1 $00
	beat g Q g Q
	.redefine NOTE_END_WAIT 2
; Measure 14
	vibrato $a1
	vol HI_VOL
	beat a Q+E1 a E2 a Q
; Measures 15-16
	beat gs S1 r (S2+E2+HF)+(HF+Q)+(HF+Q)+Q
	goto musKassThemeShortChannel0Measure2bLoop
	cmdff

.macro m_musKassThemeShortChannel4Measure2
	duty HI_VOL
	beat \1 Q

	duty LO_VOL
	beat \2 S1 r S2+E2 \3 Q
.endm

musKassThemeShortChannel4:
.redefine HI_VOL $0e
.redefine LO_VOL $14;$0f

; Measure 1
	beat r HF+Q
musKassThemeShortChannel4Measure2Loop:
; Measure 2
	m_musKassThemeShortChannel4Measure2 b2 d4 f4
; Measure 3
	m_musKassThemeShortChannel4Measure2 e2 d4 c4
; Measure 4
	m_musKassThemeShortChannel4Measure2 a2 a3 c4
; Measure 5
	m_musKassThemeShortChannel4Measure2 a2 cs4 e4
; Measure 6
	m_musKassThemeShortChannel4Measure2 d3 d4 f4
; Measure 7
.redefine HI_VOL $0a
.redefine LO_VOL $0e
	m_musKassThemeShortChannel4Measure2 g2 f4 d4
; Measure 8
	m_musKassThemeShortChannel4Measure2 c3 g4 e4
; Measure 9
	m_musKassThemeShortChannel4Measure2 c3 e4 c4
; Measure 10
	m_musKassThemeShortChannel4Measure2 as2 f4 d4
; Measure 11
	m_musKassThemeShortChannel4Measure2 as2 d4 as3
; Measure 12
	m_musKassThemeShortChannel4Measure2 a2 c4 e4
; Measure 13
	m_musKassThemeShortChannel4Measure2 g2 c4 e4
; Measure 14
	m_musKassThemeShortChannel4Measure2 f3 c4 f4
; Measure 15
	octave 3
	duty HI_VOL
	beat e S1 r S2+E2+HF
; Measure 16
	duty LO_VOL
	octaved
	beat a Q
	octaveu
	beat e Q c Q
; Measure 17
	octaved
	beat a E1 r E2+HF

	goto musKassThemeShortChannel4Measure2Loop
	cmdff

.define musKassThemeShortChannel6 MUSIC_CHANNEL_FALLBACK EXPORT