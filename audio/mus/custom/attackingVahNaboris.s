musAttackingVahNaborisStart:
	tempo 155

musAttackingVahNaborisChannel1:
	.redefine HI_VOL $6
	.redefine LO_VOL $4

; Measure 1-2
	vol $0
	beat g3 W+W+E1
; Measure 3a-4
	octave 4
	vol $5
	duty $03
	env $0 $04
	vibrato $00
.rept 2
	beat a E2 e E1 r E2
	beat a E1 e E2 r E1
.endr
	beat a E2

.redefine MEL_OCT 6
.macro m_musAttackingVahNaborisChannel1Measure4d
; Measure 4d
	env $0 $00
	duty $02
	vibrato $02
	octave MEL_OCT-1
	
	vol $2
	beat d Y1
	vol $3
	beat ds Y2
	vol $4
	beat f Y3
	vol $5
	beat g Y4
	vol $6
	beat a Y5
	vol $7
	beat ou c Y6
.endm
	m_musAttackingVahNaborisChannel1Measure4d

musAttackingVahNaborisChannel1Loop:
; Measure 5
.macro m_musAttackingVahNaborisChannel1Measure5
; Measure 5
	env $0 $00
	duty $02
	vibrato $82
	octave MEL_OCT
	vol HI_VOL
	beat d HF c Q ds Q
; Measure 6
	beat od a W
; Measure 7
	octaveu
	beat r Q d Q c Q ds Q
; Measure 8
	octaved
	beat a HF+Q
.endm
	m_musAttackingVahNaborisChannel1Measure5
	octave MEL_OCT
	beat r S1 c S2 od a S3 g S4
; Measure 9
	beat fs HF+Q g Q
; Measure 10
	beat fs HF+Q+S1
	beat g S2 fs S3 ds S4
; Measure 11-12
.macro m_musAttackingVahNaborisChannel1Measure21
; Measure 21
	;octave MEL_OCT-1
	env $0 $00
	vibrato $82
	beat \1 W+Q
	vol LO_VOL
	vibrato $02
	beat \1 Q+E1
; Measure 22b
	vol LO_VOL-2
	beat \1 E2+S1 r S2+E2

	vibrato $00
	vol $0
.endm
	m_musAttackingVahNaborisChannel1Measure21 d5
; Measure 13
	beat g3 E1
	octave MEL_OCT-1
	env $0 $06
	vol HI_VOL
	vibrato $62
	beat d S3 ds S4 fs Q+E1
	beat fs S3 g S4 a Q
; Measure 14
	beat r E1 a S3 as S4 ou c S1 r S2
	beat c S3 d S4 ds S1 r S2
	beat ds S3 f S4
	beat ds S1 d S2 c S3 od as S4
; Measure 15
	beat a E1 ou g S3 r S4
	beat fs HF
	octaved
	beat a E1 ou g S3 r S4 
; Measure 16
	beat fs Q+E1
	beat fs S3 g S4 a S1 r S2
	beat a S3 as S4 a E1 g E2
; Measure 17
	beat fs S1 r S2 fs S3 g S4
	beat fs S1 r S2 ds S3 r S4
	beat d E1+S3 c T7 d T8
	beat c S1 r S2 ds S3 f S4
; Measure 18
	beat d Q+E1 c S3 d S4
	beat ds S1 d S2 c S3 od as S4
	beat a S1 r S2 fs S3 g S4
; Measure 19
	env $0 $04
	beat fs E1 g E2 a E1 g E2
	beat fs S1 g S2 fs E2
	beat d E1 c S3 ds S4
; Measure 20
	vol HI_VOL+2
	beat d Q 
	env $0 $05
	octaved
	beat a Q ou c Q ds Q
; Measure 21-22
	m_musAttackingVahNaborisChannel1Measure21 d5

; Measure 23
.macro m_musAttackingVahNaborisChannel0Measure23a
	duty $01
	env $0 $04
	vibrato $00
	vol HI_VOL+1
	beat \1 E1
	vol LO_VOL+1
	beat \1 S3
	;octaved
	beat \1 T7 r T8 \1 T1 r T2 \1 T3 r T4

	vol HI_VOL+1
	;octaveu
	beat \1 E2
	vol LO_VOL+1
	beat \1 S1
	;octaved
	beat \1 T3 r T4 \1 T5 r T6 \1 T7 r T8

	vol HI_VOL+1
.endm
	m_musAttackingVahNaborisChannel0Measure23a a3
	octave 3
	beat a Q
; Measure 24
	m_musAttackingVahNaborisChannel0Measure23a a3
	beat as Q

; Measure 25-28
	m_musAttackingVahNaborisChannel1Measure5
	octave MEL_OCT
	vol HI_VOL
	vibrato $a2
	beat g Q
; Measure 29
	beat fs HF+Q g Q
; Measure 30
	beat fs HF+Q+S1
	beat g S2 fs S3 ds S4
; Measure 31-32
	m_musAttackingVahNaborisChannel1Measure21 d6

; Measure 33
	m_musAttackingVahNaborisChannel0Measure23a a3
	octave 3
	beat a Q
; Measure 34
	m_musAttackingVahNaborisChannel0Measure23a a3
	beat as Q
	
; Measure 35-42b
.macro m_musAttackingVahNaborisChannel1Measure35
; Measure 35
	octave MEL_OCT
	env $0 $00
	duty $02
	vibrato $62
	vol HI_VOL

	beat d T1 ds T2 d S2+E2+E1 c S3 d S4
	octaved
	beat a Q+E1 g S3 a S4
; Measure 36
	beat d HF a HF r Q
; Measure 37b
	octaveu
	beat d T1 ds T2 d S2+E2
	beat c Q d Q
; Measure 38
	octaved
	beat a Q+E1 g S3 a S4
	beat d HF

; Measure 39
	octaveu
	beat d T1 ds T2 d S2+E2+HF+E1 c S3 d S4
; Measure 40
	beat f Q e T1 f T2 e S2+E2
	beat c Q od g Q
; Measure 41-42b
	beat a HF ou d T1 ds T2 d S2+E2+Q+Q+E1 r E2
.endm
	m_musAttackingVahNaborisChannel1Measure35
; Measure 42c
	vol $0
	beat g3 Q
	m_musAttackingVahNaborisChannel1Measure4d
; Measure 43-50b
	m_musAttackingVahNaborisChannel1Measure35
; Measure 50c
	octave MEL_OCT
	env $0 $04
	beat c Q c Q r Q+E1

; Measure 51b-52
	octave 5
	vol $2
	duty $03
	vibrato $00
	;env $0 $04
	beat e S3 a S4
	vol $3
	octaveu
	beat d S1 od e S2
	vol $4
	beat a S3 ou d S4
	vol $5
	octaved
	beat e S1 a S2
	vol $6
	octaveu
	beat d S3
	vol $4
	octaved
	beat e S4
	vol $2
	beat a S1
	vol $0
	beat g3 S2+E2+Q+HF

	goto musAttackingVahNaborisChannel1Loop
	cmdff

musAttackingVahNaborisChannel0:
	.redefine HI_VOL $5
	.redefine LO_VOL $3

; Measure 1-4
	octave 3
	duty $01
	env $0 $04
	vibrato $00
	vol HI_VOL
.rept 8
	beat d E1 d E2 d E1+S3
	octaveu 
	beat d S4
	octaved
.endr

musAttackingVahNaborisChannel0Loop:
	;.redefine HI_VOL $4
	;.redefine LO_VOL $2
; Measure 5-14
	octave 3
	duty $02
	env $0 $00
	vol LO_VOL
	vibrato $e2
.rept 5
	beat a W+HF+E1 r E2
	beat as Q
.endr
; Measure 15
	beat a HF+Q as Q
; Measure 16
	beat a HF+Q g Q
; Measure 17
	beat fs HF+Q g Q
; Measure 18
	beat fs HF+Q c Q
; Measure 19
	beat d W

; Measure 20
	vol HI_VOL
	beat d Q 
	env $0 $05
	beat fs Q g Q as Q
; Measure 21-22
	m_musAttackingVahNaborisChannel1Measure21 a3

; Measure 23
	m_musAttackingVahNaborisChannel0Measure23a fs3
	beat fs Q
; Measure 24
	m_musAttackingVahNaborisChannel0Measure23a fs3
	beat g Q

; Measure 25-30
	octave 3
	duty $02
	env $0 $00
	vol LO_VOL
	vibrato $e2
.rept 3
	beat a W+HF+E1 r E2
	beat as Q
.endr
; Measure 31-32
	beat a W+HF+E1 r E2+Q

; Measure 33
	octave 3
	m_musAttackingVahNaborisChannel0Measure23a fs3
	beat fs Q
; Measure 34
	m_musAttackingVahNaborisChannel0Measure23a fs3
	beat g Q

; Measure 35-38
.macro m_musAttackingVahNaborisChannel0Measure35
; Measure 35-38
	env $0 $00
	vibrato $82
.rept 2
	vol LO_VOL+1
	octave 3
; Measure 35
	beat a W
; Measure 36	
	beat b W
.endr
.endm
	m_musAttackingVahNaborisChannel0Measure35
; Measure 39
	octaveu
	beat d W
; Measure 40
	beat c W
; Measure 41	
	beat d W
; Measure 42
	beat f HF e HF

; Measure 43
	m_musAttackingVahNaborisChannel0Measure35
; Measure 47
	octave 3
	beat as W
; Measure 48
	octaveu
	beat c W
; Measure 49
	beat d HF+Q r E1

; Measure 49d
	;duty $02
	vibrato $62
	env $0 $04
	vol HI_VOL+2
	octave 4
	beat g S3 a S4
; Measure 50-51
	octaveu
	beat c Q+E1 od g S3 ou c S4
	beat f Q e Q r W
; Measure 52
	octave 3
	env $0 $05
	;vibrato $62
	beat d Q od a Q ou c Q ds Q

	goto musAttackingVahNaborisChannel0Loop
	cmdff

musAttackingVahNaborisChannel4:
	.redefine HI_VOL $0e
	.redefine LO_VOL $0f

; Measure 1-4
	octave 2
.rept 8
	duty HI_VOL	
	beat d S1
	duty LO_VOL
	beat d S2 r E2

	duty HI_VOL
	beat d E1+S3
	duty LO_VOL
	beat d S4
.endr

.macro m_musAttackingVahNaborisChannel4Measure5
	duty HI_VOL
	beat \1 E1
	duty LO_VOL
	beat \1 S3
	beat (\1-12) T7 r T8 (\1-12) T1 r T2 (\1-12) T3 r T4

	duty HI_VOL
	beat \1 E2
	duty LO_VOL
	beat \1 S1
	octaved
	beat (\1-12) T3 r T4 (\1-12) T5 r T6 (\1-12) T7 r T8
.endm
.macro m_musAttackingVahNaborisChannel4Measure5d
	duty HI_VOL
	beat \1 E1+S3
	duty LO_VOL
	beat \1 S4	
.endm

musAttackingVahNaborisChannel4Loop:
; Measure 5-34
.rept 15
; Measure 5
	octave 3
	m_musAttackingVahNaborisChannel4Measure5 d3
	m_musAttackingVahNaborisChannel4Measure5d d3
; Measure 6
	m_musAttackingVahNaborisChannel4Measure5 d3
	m_musAttackingVahNaborisChannel4Measure5d ds3
.endr

.rept 2 INDEX REPTCTR
; Measure 35-38,43-46
.rept 2	
; Measure 35	
	m_musAttackingVahNaborisChannel4Measure5 f3	
	m_musAttackingVahNaborisChannel4Measure5d f3
; Measure 36	
	m_musAttackingVahNaborisChannel4Measure5 e3	
	m_musAttackingVahNaborisChannel4Measure5d e3
.endr	

; Measure 39-42,47-48
.rept (2-REPTCTR)
; Measure 39
	m_musAttackingVahNaborisChannel4Measure5 as3
	m_musAttackingVahNaborisChannel4Measure5d as3
; Measure 40
	m_musAttackingVahNaborisChannel4Measure5 a3
	m_musAttackingVahNaborisChannel4Measure5d a3
.endr
.endr

; Measure 49-50
.rept 2
	m_musAttackingVahNaborisChannel4Measure5 ds3
	m_musAttackingVahNaborisChannel4Measure5d ds3
.endr
; Measure 51
	m_musAttackingVahNaborisChannel4Measure5 d3	
	m_musAttackingVahNaborisChannel4Measure5d d3
; Measure 52
	m_musAttackingVahNaborisChannel4Measure5d d2
	m_musAttackingVahNaborisChannel4Measure5d a1
	m_musAttackingVahNaborisChannel4Measure5d c2
	m_musAttackingVahNaborisChannel4Measure5d ds2

	goto musAttackingVahNaborisChannel4Loop

	cmdff

musAttackingVahNaborisChannel6:
	.redefine HI_VOL $6
	.redefine LO_VOL $4
	.redefine HIT $2a
	.redefine CRASH $2e

; Measure 1-2
	vol $0
	beat r W+W
; Measure 3
	vol LO_VOL
.rept 4
	beat HIT Q
.endr
.macro m_musAttackingVahNaborisChannel6Measure4
; Measure 4
	beat HIT E1 HIT S3 HIT S4
	beat HIT S1 HIT S2 HIT E2
	beat HIT E1 HIT S3 HIT S4
	beat HIT S1 HIT S2 HIT S3 HIT S4
.endm
	m_musAttackingVahNaborisChannel6Measure4


musAttackingVahNaborisChannel6Measure5Loop:
; Measure 5-11
.macro m_musAttackingVahNaborisChannel6Measure5
; Measure 5
	vol LO_VOL
	beat HIT S1 HIT S2
	vol HI_VOL
	beat HIT E2 HIT E1+S3
	vol LO_VOL
	beat HIT S4
	beat HIT S1 HIT S2 HIT E2
	beat HIT S1 HIT S2 HIT S3 HIT S4
.endm
.rept 7
	m_musAttackingVahNaborisChannel6Measure5
.endr
.macro m_musAttackingVahNaborisChannel6Measure12
; Measure 12
	beat HIT E1 HIT E2
	vol HI_VOL
	beat HIT E1
	vol LO_VOL
	beat HIT S3 HIT S4
	beat HIT S1 HIT S2 HIT E2
	beat HIT S1 HIT S2 HIT S3 HIT S4
.endm
	m_musAttackingVahNaborisChannel6Measure12

; Measure 13-23
.rept 8+2+1
	m_musAttackingVahNaborisChannel6Measure5
.endr
; Measure 24
	m_musAttackingVahNaborisChannel6Measure4

; Measure 25-31
.rept 7
	m_musAttackingVahNaborisChannel6Measure5
.endr
; Measure 32
	m_musAttackingVahNaborisChannel6Measure12
; Measure 33
	m_musAttackingVahNaborisChannel6Measure5
; Measure 34
	m_musAttackingVahNaborisChannel6Measure12

; Measure 35
	beat HIT E1 HIT S3 HIT S4
	beat HIT E1+S3 HIT S4
	beat HIT E1 HIT E2 
	beat HIT S1 HIT S2 HIT S3 HIT S4

; Measure 36-51
.rept 7+9
	m_musAttackingVahNaborisChannel6Measure5
.endr 

; Measure 52
	beat HIT E1 HIT S3 HIT S4
	beat HIT S1 HIT S2 HIT S3 HIT S4
.rept 2
	beat HIT S1 HIT S2 HIT S3
	vol HI_VOL
	beat HIT S4
	vol LO_VOL
.endr

	goto musAttackingVahNaborisChannel6Measure5Loop
	cmdff

.undefine HI_VOL
.undefine LO_VOL
.undefine HIT
.undefine CRASH
.undefine MEL_OCT