musLightWorldDungeonStart:
	tempo 280/2

.macro m_musLightWorldDungeonChannel1Measure1
; Measure 1
	; 9/8
	octave 4
	beat cs Q+S1 od g S2+E2+E1 fs E2+E1 ou fs E2+E1
; Measure 2-4
	;4/4 x2 + 7/8
	beat c Q
.endm

.macro m_musLightWorldDungeonChannel1Measure2a
; Measure 2a
	env $0 $00
	beat \1 E2+HF
	vol LO_VOL
	beat \1 HF+Q+E1
	vol LO_VOL-1
	beat \1 E2+HF+S1
	vol LO_VOL-2
	beat \1 S2+E2+Q
.endm

.macro m_musLightWorldDungeonChannel1Measure9
; Measure 9
	octave 4
	beat ds Q+S1 e S2+E2+E1 f E2+E1 a E2+E1
; Measure 10-12
;	4/4 x2 + 7/8
	beat gs E2+E1 c E2+E1
.endm

.macro m_musLightWorldDungeonChannel1Measure20a
; Measure 20a-21
.rept 2
	beat \1 E2 \2 E1 \3 E2+E1
.endr
	beat \1 E2 \2 E1 \3 E2+Q+E1 r E2+E1
.endm	

musLightWorldDungeonChannel1:
	.redefine HI_VOL $6
	.redefine LO_VOL $4

; Measure 1
	; 9/8
	duty $03
	env $0 $00
	vol HI_VOL
	m_musLightWorldDungeonChannel1Measure1
; Measure 2a
	m_musLightWorldDungeonChannel1Measure2a c4

; Measure 5
	env $0 $00
	vol HI_VOL
	m_musLightWorldDungeonChannel1Measure1
; Measure 6a-8
	;4/4 x2 + 7/8
	m_musLightWorldDungeonChannel1Measure2a d4
; Measure 9
;	9/8
	vol HI_VOL
	m_musLightWorldDungeonChannel1Measure9
	octave 3
;	beat b E2+Q+W+W	
	beat b E2+HF
	vol LO_VOL
	beat b HF+Q+E1
	vol LO_VOL-1
	beat b E2+Q+Q+S1
	vol LO_VOL-2
	beat b S2+E2

; Measure 13
;	3/4
	vol HI_VOL
	octave 4
	env $0 $00
	beat g Q fs Q od as Q
; Measure 14
	beat a HF+Q
; Measure 15
	octaveu
	beat f Q e Q od gs Q
; Measure 16
	beat g HF+Q-S4 r S4
; Measure 17
;	4/4
	beat g E1 fs E2 ou c E1 od b E2
	beat ou f E1 e E2 as E1 a E2
; Measure 18-19
	beat ds W r W+E1

musLightWorldDungeonChannel1Measure20aLoop:
; Measure 20a-21
	vol HI_VOL
	duty $02
	env $0 $00
	vibrato $00
	octave 4
	m_musLightWorldDungeonChannel1Measure20a cs4 d4 a4
; Measure 22a-23
	m_musLightWorldDungeonChannel1Measure20a c4 cs4 gs4
; Measure 24a-25
	m_musLightWorldDungeonChannel1Measure20a b3 c4 g4
; Measure 26a-27
	vol HI_VOL-1
.rept 2
	beat c E2 cs E1 gs E2+E1
.endr
	beat c E2 cs E1 gs E2+HF
; Measure 28
	octave 4
	duty $01
	vibrato $01
	beat a HF+Q gs E1 a E2
; Measure 29
	beat b HF+Q a E1 gs E2
; Measure 30-31
	beat cs W+HF+E1 r E2
	beat cs R1 c R2 cs R3
; Measure 32
	beat g HF+Q fs E1 g E2
; Measure 33
	beat a HF+Q g E1 fs E2
; Measure 34-35
	octaved
	beat b W+HF+E1 r E2
	beat b R1 as R2 b R3
; Measure 36
	beat as HF+R1+R2 ou c R3
	beat f R1 fs R2 ou cs R3
; Measure 37
	beat c HF+Q od gs Q
; Measure 38-39
	octaveu
	beat c E1 od b E2+Q+HF+HF e HF
; Measure 40
	beat ds HF+E1 c E2
	beat d R1 e R2 ou ds R3
; Measure 41
	beat d HF+Q od as Q
; Measure 42-43
	beat a W+W r E1

	goto musLightWorldDungeonChannel1Measure20aLoop
	cmdff

.macro m_musLightWorldDungeonChannel0Measure6b
; Measure 6b
	;W+W+Q+E2; 38 16ths
	beat \1 E2 ;skipping E1 for 7/8
	vol LO_VOL-2
	octaved
	beat \2 HF+Q+E1
	rest E2+W+Q
.endm

.macro m_musLightWorldDungeonChannel0Measure20a
; Measure 20a-21
.rept 2
	beat \1 E2 \2 E1 \3 E2+E1
.endr
	beat \1 E2 \2 E1 r E2+Q+E1-ECHO_WAIT \3 ECHO_WAIT r E2+E1
.endm

musLightWorldDungeonChannel0:
	.redefine HI_VOL $4
	.redefine LO_VOL $3
	.redefine ECHO_WAIT E2+S1

; Measure 1
	vol $0
	beat gs3 ECHO_WAIT
	vol LO_VOL
	env $2 $00
	vibrato $00
	duty $03
	m_musLightWorldDungeonChannel1Measure1

	octave 3
	vol LO_VOL-2
	env $0 $00
	;W+W+HF+E1+S2 ; 42 16ths
	beat gs W+HF r W+E2 ;skipping S1 in ECHO_WAIT for 7/8
; Measure 5-6
	vol LO_VOL
	env $2 $00
	m_musLightWorldDungeonChannel1Measure1
; Measure 6b
	m_musLightWorldDungeonChannel0Measure6b d4 a3
	rest Q
; Measure 9-10
	vol LO_VOL
	m_musLightWorldDungeonChannel1Measure9
; Measure 10c
	m_musLightWorldDungeonChannel0Measure6b b3 fs3
; Measure 13
	octave 4
	vol LO_VOL
	beat g Q fs Q od as Q
; Measure 14
	beat a S1 e S2+E2+Q+S1 r S2+E2
; Measure 15
	octaveu
	beat f Q e Q od gs Q
; Measure 16
	beat g S1 d S2+E2+Q+S1 r S2+E2
; Measure 17
	beat g E1 fs E2 ou c E1 od b E2
	octaveu
	beat f E1 e E2 as E1 a E2
; Measure 18-19
	octaved
	beat ds HF+Q r Q+W+E1

musLightWorldDungeonChannel0Measure20aLoop:
; Measure 20a-21
	vol HI_VOL
	duty $02
	env $1 $00
	vibrato $00
	m_musLightWorldDungeonChannel0Measure20a cs4 d4 a4
; Measure 22a-23
	m_musLightWorldDungeonChannel0Measure20a c4 cs4 gs4
; Measure 24a-25
	m_musLightWorldDungeonChannel0Measure20a b3 c4 g4
; Measure 26a-27
	octave 4
.rept 2
	beat c E2 cs E1 gs E2+E1
.endr
	beat c E2 cs E1 r E2+Q+E1-ECHO_WAIT gs S3 r S4+E1

; Measure 28a-29
	vol HI_VOL
	duty $02
	env $1 $00
	vibrato $00
	m_musLightWorldDungeonChannel1Measure20a cs4 d4 a4
; Measure 30a-31
	m_musLightWorldDungeonChannel1Measure20a c4 cs4 gs4
; Measure 32a-33
	m_musLightWorldDungeonChannel1Measure20a b3 c4 g4
; Measure 34a-35
	m_musLightWorldDungeonChannel1Measure20a as3 b3 fs4
; Measure 36a-37
	m_musLightWorldDungeonChannel1Measure20a f4 fs4 c5
; Measure 38a-39
	m_musLightWorldDungeonChannel1Measure20a e4 f4 b4
; Measure 40a-41
	m_musLightWorldDungeonChannel1Measure20a g4 gs4 d5
; Measure 42a-43
	m_musLightWorldDungeonChannel1Measure20a gs4 a4 ds5

	rest ECHO_WAIT

	goto musLightWorldDungeonChannel0Measure20aLoop
	cmdff

.macro m_musLightWorldDungeonChannel4Measure18
; Measure 18-19
	octave 2
.rept 8 ; 2 beats for measures 
	duty HI_VOL
	beat \1 S1
	duty LO_VOL
	beat \1 T3 r T4
	duty HI_VOL
	beat \1 S3
	duty LO_VOL
	beat \1 T7 r T8
.endr
.endm

musLightWorldDungeonChannel4:
	.redefine HI_VOL $0e
	.redefine LO_VOL $0f
	.redefine ECHO $08

; Measure 1
	duty ECHO
; Measure 1
	; 9/8
	octave 3
	beat gs Q+S1 d S2+E2+E1 cs E2+E1 ou cs E2+E1
; Measure 2-4
	;4/4 x2 + 7/8
	octaved
	beat g E2+Q+E1 r E2+Q+W+W

; Measure 5
	; 9/8
	octave 3
	beat gs Q+S1 d S2+E2+E1 cs E2+E1 ou cs E2+E1
; Measure 6-8
	;4/4 x2 + 7/8
	octaved
	beat g E2+E1 a E2+E1 r E2+Q+W+W

; Measure 9
;	9/8
	octave 4
	beat as Q+S1 b S2+E2+E1 ou c E2+E1 e E2+E1
; Measure 10-12
;	4/4 x2 + 7/8
	beat ds E2+E1 od g E2+E1 fs E2+E1 r E2+W+W

; Measure 13
;	3/4
	octave 4
	beat d Q cs Q od fs Q
; Measure 14
	beat e Q r HF
; Measure 15
	octaveu
	beat cs Q od b Q ds Q
; Measure 16
	beat d Q r HF
; Measure 17
	beat d E1 cs E2 g E1 fs E2
	beat ou c E1 od b E2 ou f E1 e E2
; Measure 18-19
	m_musLightWorldDungeonChannel4Measure18 b2

musLightWorldDungeonChannel4Measure20Loop:
; Measure 20-21
	m_musLightWorldDungeonChannel4Measure18 b2
; Measure 22-23
	m_musLightWorldDungeonChannel4Measure18 as2
; Measure 24-25
	m_musLightWorldDungeonChannel4Measure18 a2
; Measure 26-27
	m_musLightWorldDungeonChannel4Measure18 as2
; Measure 28-29
	m_musLightWorldDungeonChannel4Measure18 b2
; Measure 30-31
	m_musLightWorldDungeonChannel4Measure18 as2
; Measure 32-33
	m_musLightWorldDungeonChannel4Measure18 a2
; Measure 34-35
	m_musLightWorldDungeonChannel4Measure18 gs2
; Measure 36-37
	m_musLightWorldDungeonChannel4Measure18 ds3
; Measure 38-39
	m_musLightWorldDungeonChannel4Measure18 d3
; Measure 40-41
	m_musLightWorldDungeonChannel4Measure18 f3
; Measure 42-43
	m_musLightWorldDungeonChannel4Measure18 fs3

	goto musLightWorldDungeonChannel4Measure20Loop
	cmdff

.define musLightWorldDungeonChannel6 MUSIC_CHANNEL_FALLBACK EXPORT
