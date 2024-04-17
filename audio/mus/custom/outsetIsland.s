musOutsetIslandStart:
	tempo 120

musOutsetIslandChannel1:
	.redefine HI_VOL $6
	.redefine LO_VOL $4

musOutsetIslandChannel1Measure4Loop:
; Measure 4-8
	vol $0
	beat gs3 W+HF+Q+E1
.macro m_musOutsetIslandChannel1Measure5d
; Measure 5d
	vol HI_VOL
	octave 5
	duty $02
	env $1 $05
	vibrato $00
	beat gs E2
; Measure 6-7
.rept 2
	beat f E1 r E2+E1 ds E2
	beat f E1 r E2+E1 gs E1
.endr
; Measure 8
	env $1 $00
	vibrato $e1
	octaveu
	beat c Q+E1 od as E2
.endm
	m_musOutsetIslandChannel1Measure5d
; Measure 8c
	octave 5
	beat gs Q+E1 fs E2
; Measure 9
	beat f Q+E1 cs E2 ds Q+E1
	m_musOutsetIslandChannel1Measure5d
; Measure 12c
	octave 6
	beat cs Q+E1 cs E2
; Measure 13
	octaved
	beat gs Q+E1 as E2 gs Q fs Q
; Measure 14
	beat cs HF
	octaved
	beat as Q+E1 ou ds E2
; Measure 15
	beat cs HF
	octaved
	beat gs Q+E1
	beat gs S3 as S4
; Measure 16-17
	beat gs W
	vol LO_VOL
	vibrato $01
	beat gs W
; Measure 18
	octave 5
	vol HI_VOL
	vibrato $e1
	beat f HF
	beat ds Q+E1 fs E2
; Measure 19
	beat f HF
	beat cs Q+E1
	beat ds S3 f S4
; Measure 20
	beat ds HF
.macro m_musOutsetIslandChannel1Measure20c
; Measure 20c
	vol LO_VOL
	env $0 $00
	vibrato $01
	duty $03
	octave 4
	beat cs E1 c E2 cs E1 f E2
; Measure 21
	beat ds Q+E1 od gs E2+HF r E1
; Measure 22a
	vol HI_VOL
	env $1 $05
	vibrato $00
	duty $02
	octave 6
	beat ds E2 ds E1 r E2+E1
	beat c E2 c E1 r E2+E1
; Measure 23a
	octave 6
	beat cs E2 cs E1 r E2+E1
	octaved
	beat as E2 as E1 r E2+E1
; Measure 24a
	octaveu
	beat c E2 c E1 r E2+E1
	octaved
	beat gs E2 gs E1 r E2+E1
; Measure 25a
	beat as E2 as E1
.endm
	m_musOutsetIslandChannel1Measure20c
; Measure 25
	rest E2+Q
	duty $02
	env $1 $00
	vol LO_VOL-1
	vibrato $e1
	beat gs Q
; Measure 26
	beat f HF+Q ds Q
; Measure 27
	beat f HF+Q gs Q
; Measure 28
	beat f HF+Q ds Q
; Measure 29-31
	beat f W 
	beat r W+W

.macro m_musOutsetIslandChannel1Measure32
; Measure 32
	vol HI_VOL
	env $1 $05
	vibrato $00
	octave 5
	beat gs E1 ou cs E2 od gs E1 f E2
	beat cs E1 r E2+E1
	beat cs S3 ds S4
; Measure 33
	beat f E1 cs E2 cs E1 ds E2
.endm
	m_musOutsetIslandChannel1Measure32
	octave 5
	beat f Q ds E1 r E2
; Measure 34
	beat gs E1 gs E2 gs E1 as E2
	beat cs E1 r E2+E1
	beat cs S3 ds S4
; Measure 35
	beat f E1 f E2 f E1 fs E2
	beat f Q ds E1 r E2
; Measure 36
	m_musOutsetIslandChannel1Measure32
	beat f T1 fs T2 f S2+E2
	beat ds E1 r E2
; Measure 38
	beat gs E1 as E2 gs E1 f E2
	beat cs E1 r E2+E1
	beat f S3 fs S4
; Measure 39
	beat gs E1 gs E2 gs E1 as E2
	beat gs Q fs E1 r E2
; Measure 40-43
	vol LO_VOL
	octave 4
	duty $03
.rept 2
	beat gs E1 gs E2 gs E1 gs E2
	beat r HF+W
.endr
; Measure 44
	octave 5
	vol HI_VOL
	duty $02
	beat gs E1 ou cs E2 od gs E1 f E2
	beat ds E1+S3 f S4+E1 fs E2
; Measure 45
	beat gs T1 as T2 gs S2+E2+E1
	beat fs T4 gs T5 fs S4+Q
	beat f E1 ds E2
; Measure 46
	beat f E1 cs E2+Q
	m_musOutsetIslandChannel1Measure20c
; Measure 51b
	rest E2+E1
	vol HI_VOL
	octave 5
	beat fs E2 fs E1 r E2
; Measure 52-55
	vol LO_VOL
	env $1 $00
	vibrato $e1
	octave 4
	beat cs W c W od as W ou c W

	goto musOutsetIslandChannel1Measure4Loop
	cmdff


musOutsetIslandChannel0:
	.redefine HI_VOL $5
	.redefine LO_VOL $3

musOutsetIslandChannel0Measure4Loop:
; Measure 4-8
	vol $0
	beat gs3 W+W+E1
.macro m_musOutsetIslandChannel0Measure6a
; Measure 6a
	vol HI_VOL
	octave 4
	duty $03
	env $1 $05
	vibrato $00
	beat f E2 f E1 r E2+E1
	beat gs E2 gs E1 r E2+E1
; Measure 7a
	beat as E2 as E1 r E2+E1
	octaveu
	beat c E2 c E1 c E2
; Measure 8
	beat ds E1 od gs E2 gs E1 ou cs E2
.endm
	m_musOutsetIslandChannel0Measure6a
; Measure 8c
	octave 5
	beat c E1 od f E2 f E1 as E2
; Measure 9
	beat gs E1 fs E2 fs E1 fs E2
	beat f Q ds Q r E1
	m_musOutsetIslandChannel0Measure6a
; Measure 12c
	octave 5
	beat f E1 od f E2 f E1 ou f E2
; Measure 13
	octaved
	beat gs E1 fs E2 fs E1 r E2
	octaveu
	beat c Q od as Q r HF
.macro m_musOutsetIslandChannel0Measure14c
; Measure 14c
	env $0 $00
	octave 5
	vol HI_VOL
	beat gs T1 r T2+S2

	beat gs T5
	vol LO_VOL
	octave 4
	beat cs T6+S4

	vol HI_VOL
	octave 5
	beat gs T1
	vol LO_VOL
	octave 4
	beat gs T2+S2

	vol HI_VOL
	octave 5
	beat gs T5
	vol LO_VOL
	octave 5
	beat cs T6+S4
; Measure 15
	vol HI_VOL
	octave 5
	beat gs T1
	vol LO_VOL
	octave 5
	beat f T2+S2+T5 cs T6+S4+T1
	beat od gs T2+S2+T5 f T6+S4 r HF
	vol HI_VOL
	env $1 $05
.endm
	m_musOutsetIslandChannel0Measure14c
; Measure 16
	rest HF
	m_musOutsetIslandChannel0Measure14c
; Measure 18
	octave 4
	beat cs E1 fs E2 fs E1 r E2
	octaved
	beat as E1 ou as E2 as E1 ds E2
; Measure 19
	beat cs E1 as E2 as E1 r E2
	octaved
	beat gs E1 ou ou c E2 c E1
	octaved 
	octaved
	beat gs S3 as S4
; Measure 20
	beat gs E1 ou ou cs E2 cs E1 r E2
	octaved
	octaved
	beat as E1 ou as E2 as E1 cs E2
; Measure 21
	beat c E1 ou c E2 c E1 r E2
	beat f Q ds E1 r E2+E1
; Measure 22a
	octaved
	beat gs E2 gs E1 r E2+E1
	beat f E2 f E1 r E2+E1
; Measure 23a
	beat fs E2 fs E1 r E2+E1
	beat ds E2 ds E1 r E2+E1
; Measure 24a
	beat f E2 f E1 r E2+E1
	beat cs E2 cs E1 r E2+E1
; Measure 25a
	beat ds E2 ds E1 r E2+E1
	beat c E2 c E1
	env $1 $00
	vibrato $e1
	beat gs S3 fs S4
; Measure 26
	beat f Q
	beat gs T1 as T2 gs S2+E2+E1
	beat fs T5 gs T6 fs S4+Q
; Measure 27
	beat f T1 gs T2 f S2+E2+E1
	beat ds E2
	beat cs E1 c E2 cs E1 ds E2
; Measure 28
	beat cs Q+E1 od gs E2+HF
; Measure 29
	beat gs W

	goto musOutsetIslandChannel0Measure4Loop
	cmdff

.macro m_musOutsetIslandChannel4Measure4
; Measure 4
	duty HI_VOL
	beat \1 E1 \2 E2 r E1 \3 E2
.endm

musOutsetIslandChannel4:
	.redefine HI_VOL $0e
	.redefine LO_VOL $0f

musOutsetIslandChannel4Measure4Loop:
; Measure 4-5
.rept 4
	m_musOutsetIslandChannel4Measure4 cs2 cs3 gs2
.endr
; Measure 6
	m_musOutsetIslandChannel4Measure4 cs2 cs3 gs2
	m_musOutsetIslandChannel4Measure4 f2 f3 cs3
; Measure 7
	m_musOutsetIslandChannel4Measure4 fs2 fs3 cs3
	m_musOutsetIslandChannel4Measure4 gs2 gs3 fs2
; Measure 8
	m_musOutsetIslandChannel4Measure4 f2 f3 cs3
	m_musOutsetIslandChannel4Measure4 as2 as3 as2
; Measure 9
	m_musOutsetIslandChannel4Measure4 ds2 ds3 ds2
	m_musOutsetIslandChannel4Measure4 gs2 gs3 gs2
; Measure 10
	m_musOutsetIslandChannel4Measure4 cs2 cs3 gs2
	m_musOutsetIslandChannel4Measure4 f2 f3 cs3
; Measure 11
	m_musOutsetIslandChannel4Measure4 fs2 fs3 cs3
	m_musOutsetIslandChannel4Measure4 gs2 gs3 f2
; Measure 12
	m_musOutsetIslandChannel4Measure4 f2 f3 f2
	m_musOutsetIslandChannel4Measure4 as2 as3 f3
; Measure 13
	m_musOutsetIslandChannel4Measure4 ds2 ds3 as2
	m_musOutsetIslandChannel4Measure4 gs2 gs3 gs2
; Measure 14
.rept 2
	m_musOutsetIslandChannel4Measure4 fs2 fs3 cs3
.endr
; Measure 15
.rept 2
	m_musOutsetIslandChannel4Measure4 b1 b2 fs2
.endr
; Measure 16
.rept 2
	m_musOutsetIslandChannel4Measure4 f2 f3 cs3
.endr
; Measure 17
.rept 2
	m_musOutsetIslandChannel4Measure4 as1 as2 f2
.endr
; Measure 18-19
.rept 4
	m_musOutsetIslandChannel4Measure4 ds2 ds3 as2
.endr
; Measure 20
.rept 2
	m_musOutsetIslandChannel4Measure4 gs2 gs3 ds3
.endr
; Measure 21
	m_musOutsetIslandChannel4Measure4 gs1 gs2 ds2
	m_musOutsetIslandChannel4Measure4 gs1 gs2 gs1
; Measure 22-29
.rept 16
	m_musOutsetIslandChannel4Measure4 cs2 cs3 gs2
.endr

	goto musOutsetIslandChannel4Measure4Loop
	cmdff

.define musOutsetIslandChannel6 MUSIC_CHANNEL_FALLBACK EXPORT