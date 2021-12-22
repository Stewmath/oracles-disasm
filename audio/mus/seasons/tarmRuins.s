musTarmRuinsStart:

musTarmRuinsChannel1:
; Measure 1-2
	vol $0
	note gs3 $ff
	vol $0
	note gs3 $01
	vibrato $00
	env $0 $00
	duty $02
musicee549:
; Measure 3
	vol $6
	note g5  $30
	vol $3
	note g5  $10

	vol $6
	note fs5 $20
	note g5  $10
	note fs5 $10
; Measure 4
	note e5  $10
	rest $08
	vol $3
	note e5  $08

	vol $6
	note a4  $10
	rest $08
	vol $3
	note a4  $08

	vol $6
	note a4  $10
	rest $08
	vol $3
	note a4  $08

	vol $6
	note a4  $0c
	rest $04
	note a4  $08
	note b4  $08
; Measure 5
	note c5  $38
	vol $3
	note c5  $08

	vol $6
	note b4  $20
	note d5  $20
; Measure 6
	note c5  $20
	note b4  $10
	note a4  $10

	note b4  $10
	rest $08
	vol $3
	note b4  $08

	vol $6
	note g4  $10
	rest $08
	vol $3
	note g4  $08
; Measure 7
	vol $6
	note a4  $30
	vol $3
	note a4  $20
	vol $1
	note a4  $10

	vol $6
	note a4  $10
	note e5  $08
	rest $04
	vol $3
	note e5  $04
; Measure 8
	vol $6
	note e5  $30
	vol $3
	note e5  $20	
	vol $1
	note e5  $10
	rest $10

	vol $6
	note e5  $08
	note a5  $08
; Measure 9
.rept 2
	note e5  $20
	vol $3
	note e5  $10

	vol $6
	note e5  $08
	note a5  $08
.endr
; Measure 10
	note e5  $40
	vol $3
	note e5  $20
	vol $1
	note e5  $20
; Measure 11
	vol $6
	note c6  $08
	rest $04
	vol $3
	note c6  $08
	rest $04
	vol $1
	note c6  $08

	vol $6
	note b5  $08
	rest $04
	vol $3
	note b5  $08
	rest $04
	vol $1
	note b5  $08

	vol $6
	note a5  $08
	rest $04
	vol $3
	note a5  $08
	rest $04
	vol $1
	note a5  $08

	vol $6
	note g5  $08
	rest $04
	vol $3
	note g5  $08
	rest $04
	vol $1
	note g5  $08
; Measure 12
	vol $6
	note fs5 $48
	rest $08
	note g5  $10
	note a5  $10
	note b5  $10
; Measure 13
	note c6  $08
	rest $04
	vol $3
	note c6  $08
	rest $04
	vol $1
	note c6  $08

	vol $6
	note b5  $08
	rest $04
	vol $3
	note b5  $08
	rest $04
	vol $1
	note b5  $08

	vol $6
	note a5  $08
	rest $04
	vol $3
	note a5  $08
	rest $04
	vol $1
	note a5  $08

	vol $6
	note g5  $08
	rest $04
	vol $3
	note g5  $08
	rest $04
	vol $1
	note g5  $08
; Measure 14
	vol $6
	note fs5 $40
	vol $3
	note fs5 $10

	vol $6
	note fs5 $10
	note g5  $10
	note a5  $10
; Measure 15
	note b5  $30
	vol $3
	note b5  $10

	vol $6
	note e6  $30
	vol $3
	note e6  $10
; Measure 16
	vol $6
	note d6  $18
	vol $3
	note d6  $08

	vol $6
	note a5  $18
	vol $3
	note a5  $08

	vol $6
	note f5  $18
	vol $3
	note f5  $08

	vol $6
	note d5  $18
	vol $3
	note d5  $08
; Measure 17
	rest $30

	vol $6
	note b4  $05
	note e5  $05
	note a4  $06
	note b4  $2a
	rest $06

	note b4  $04
	note e5  $04
	note fs5 $04
	note a5  $04
; Measure 18	
	note b5  $30

	note a5  $05
	note b5  $05
	note a5  $06

	note f5  $20
	note e5  $10
	note d5  $10
	goto musicee549
	cmdff

musTarmRuinsChannel0:
	vibrato $00		;pointless?
	env $0 $00		;pointless?
	duty $02
; Measure 1
	vol $6
	note a3  $08
	rest $08
	note b3  $08
	vol $3
	note a3  $08
	vol $6
	note d4  $08
	vol $3
	note b3  $08
	vol $6
	note e4  $08
	vol $3
	note d4  $08
; Measure 1c-2
.rept 3
	vol $6
	note a3  $08
	vol $3
	note e4  $08
	vol $6
	note b3  $08
	vol $3
	note a3  $08
	vol $6
	note d4  $08
	vol $3
	note b3  $08
	vol $6
	note e4  $08
	vol $3
	note d4  $08
.endr
musicee701:
; Measure 3-6
.rept 8
	vol $6
	note a3  $08
	vol $3
	note e4  $08
	vol $6
	note b3  $08
	vol $3
	note a3  $08
	vol $6
	note d4  $08
	vol $3
	note b3  $08
	vol $6
	note e4  $08
	vol $3
	note d4  $08
.endr
; Measure 7
	vol $6
	note f3  $08
	vol $3
	note e4  $08
	vol $6
	note a3  $08
	vol $3
	note f3  $08
	vol $6
	note b3  $08
	vol $3
	note a3  $08
	vol $6
	note d4  $08
	vol $3
	note b3  $08

	vol $6
	note f4  $08
	vol $3
	note d4  $08
	vol $6
	note a4  $08
	vol $3
	note f4  $08
	vol $6
	note b4  $08
	vol $3
	note a4  $08
	vol $6
	note d5  $08
	vol $3
	note b4  $08
; Measure 8	
	vol $6
	note f3  $08
	vol $3
	note d5  $08
	vol $6
	note a3  $08
	vol $3
	note f3  $08
	vol $6
	note b3  $08
	vol $3
	note a3  $08
	vol $6
	note d4  $08
	vol $3
	note b3  $08

	vol $6
	note f4  $08
	vol $3
	note d4  $08
	vol $6
	note a4  $08
	vol $3
	note f4  $08
	vol $6
	note b4  $08
	vol $3
	note a4  $08
	vol $6
	note d5  $08
	vol $3
	note b4  $08
; Measure 9
	vol $6
	note e3  $08
	vol $3
	note d5  $08
	vol $6
	note a3  $08
	vol $3
	note e3  $08
	vol $6
	note b3  $08
	vol $3
	note a3  $08
	vol $6
	note d4  $08
	vol $3
	note b3  $08

	vol $6
	note e4  $08
	vol $3
	note d4  $08
	vol $6
	note a4  $08
	vol $3
	note e4  $08
	vol $6
	note b4  $08
	vol $3
	note a4  $08
	vol $6
	note d5  $08
	vol $3
	note b4  $08
; Measure 10
	vol $6
	note e3  $08
	vol $3
	note d5  $08
	vol $6
	note g3  $08
	vol $3
	note e3  $08
	vol $6
	note b3  $08
	vol $3
	note g3  $08
	vol $6
	note d4  $08
	vol $3
	note b3  $08

	vol $6
	note e4  $08
	vol $3
	note d4  $08
	vol $6
	note a4  $08
	vol $3
	note e4  $08
	vol $6
	note b4  $08
	vol $3
	note a4  $08
	vol $6
	note d5  $08
	vol $3
	note b4  $08
; Measure 11
	vol $6
	note ds3 $04
	rest $04
	note fs3 $04
	vol $3
	note ds3 $04
	vol $6
	note a3  $04
	vol $3
	note fs3 $04
	vol $6
	note c4  $04
	vol $3
	note a3  $04
.rept 4
	vol $6
	note ds3 $04
	vol $3
	note c4  $04
	vol $6
	note fs3 $04
	vol $3
	note ds3 $04
	vol $6
	note a3  $04
	vol $3
	note fs3 $04
	vol $6
	note c4  $04
	vol $3
	note a3  $04
.endr
; Measure 12b
	vol $6
	note fs3 $04
	vol $3
	note c4  $04
	vol $6
	note a3  $04
	vol $3
	note fs3 $04
	vol $6
	note c4  $04
	vol $3
	note a3  $04
	vol $6
	note ds4 $04
	vol $3
	note c4  $04

	vol $6
	note a3  $04
	vol $3
	note ds4 $04
	vol $6
	note c4  $04
	vol $3
	note a3  $04
	vol $6
	note ds4 $04
	vol $3
	note c4  $04
	vol $6
	note fs4 $04
	vol $3
	note ds4 $04

	vol $6
	note ds4 $04
	vol $3
	note fs4 $04
	vol $6
	note fs4 $04
	vol $3
	note ds4 $04
	vol $6
	note a4  $04
	vol $3
	note fs4 $04
	vol $6
	note c5  $04
	vol $3
	note a4  $04
; Measure 13
	vol $6
	note ds3 $04
	vol $3
	note c5  $04		;only difference between M11-12 and M13-14
	vol $6
	note fs3 $04
	vol $3
	note ds3 $04
	vol $6
	note a3  $04
	vol $3
	note fs3 $04
	vol $6
	note c4  $04
	vol $3
	note a3  $04
.rept 4
	vol $6
	note ds3 $04
	vol $3
	note c4  $04
	vol $6
	note fs3 $04
	vol $3
	note ds3 $04
	vol $6
	note a3  $04
	vol $3
	note fs3 $04
	vol $6
	note c4  $04
	vol $3
	note a3  $04
.endr
; Measure 14b
	vol $6
	note fs3 $04
	vol $3
	note c4  $04
	vol $6
	note a3  $04
	vol $3
	note fs3 $04
	vol $6
	note c4  $04
	vol $3
	note a3  $04
	vol $6
	note ds4 $04
	vol $3
	note c4  $04

	vol $6
	note a3  $04
	vol $3
	note ds4 $04
	vol $6
	note c4  $04
	vol $3
	note a3  $04
	vol $6
	note ds4 $04
	vol $3
	note c4  $04
	vol $6
	note fs4 $04
	vol $3
	note ds4 $04

	vol $6
	note ds4 $04
	vol $3
	note fs4 $04
	vol $6
	note fs4 $04
	vol $3
	note ds4 $04
	vol $6
	note a4  $04
	vol $3
	note fs4 $04
	vol $6
	note c5  $04
	vol $3
	note a4  $04
; Measure 15
	vol $6
	note g3  $08
	rest $08
	note b3  $08
	vol $3
	note g3  $08
	vol $6
	note e4  $08
	vol $3
	note b3  $08
	vol $6
	note g4  $08
	vol $3
	note e4  $08

	vol $6
	note g3  $08
	vol $3
	note g4  $08
	vol $6
	note b3  $08
	vol $3
	note g3  $08
	vol $6
	note e4  $08
	vol $3
	note b3  $08
	vol $6
	note g4  $08
	vol $3
	note e4  $08
; Measure 16
	vol $6
	note f3  $08
	vol $3
	note g4  $08
	vol $6
	note a3  $08
	vol $3
	note f3  $08
	vol $6
	note c4  $08
	vol $3
	note a3  $08
	vol $6
	note f4  $08
	vol $3
	note c4  $08

	vol $6
	note f3  $08
	vol $3
	note f4  $08
	vol $6
	note a3  $08
	vol $3
	note f3  $08
	vol $6
	note c4  $08
	vol $3
	note a3  $08
	vol $6
	note f4  $08
	vol $3
	note c4  $08
; Measure 17
	vol $6
	note c3  $08
	vol $3
	note f4  $08
	vol $6
	note e3  $08
	vol $3
	note c3  $08
	vol $6
	note g3  $08
	vol $3
	note e3  $08
	vol $6
	note b3  $08
	vol $3
	note g3  $08

	vol $6
	note c3  $08
	vol $3
	note b3  $08
	vol $6
	note e3  $08
	vol $3
	note c3  $08
	vol $6
	note g3  $08
	vol $3
	note e3  $08
	vol $6
	note b3  $08
	vol $3
	note g3  $08
; Measure 18
	vol $6
	note b2  $08
	vol $3
	note b3  $08
	vol $6
	note d3  $08
	vol $3
	note b2  $08
	vol $6
	note fs3 $08
	vol $3
	note d3  $08
	vol $6
	note a3  $08
	vol $3
	note fs3 $08

	vol $6
	note as2 $08
	vol $3
	note a3  $08
	vol $6
	note d3  $08
	vol $3
	note as2 $08
	vol $6
	note e3  $08
	vol $3
	note d3  $08
	vol $6
	note g3  $08
	vol $3
	note e3  $08
	goto musicee701
	cmdff
	
musTarmRuinsChannel4:
	duty $08
; Measure 1-3a 		2 measures + 1.125 beats
	rest $ff
	rest $25
musiceeac7:
; Measure 3b
	note g5  $30
	rest $10

	note fs5 $20
; Measure 4a
	note g5  $10
	note fs5 $10
	note e5  $10
	rest $10
	note a4  $10
	rest $10
	note a4  $10
	rest $10
; Measure 5a
	note a4  $0c
	rest $04
	note a4  $08
	note b4  $08
	note c5  $38
	rest $08
	note b4  $20
; Measure 6a
	note d5  $20
	note c5  $20
	note b4  $10
	note a4  $10
	note b4  $10
	rest $10
; Measure 7a
	note g4  $10
	rest $10
	note a4  $60
; Measure 8a
	rest $10
	note e5  $08
	rest $08
	note e5  $60
; Measure 9a-10a
	rest $10
.rept 3
	note e5  $08
	note a5  $08
	note e5  $30
.endr
; Measure 11a-14a		4 measures + 1.5 beats
	rest $ff
	rest $ff
	duty $08		;pointless?
	rest $32
; Measure 15b
	note g5  $10
	note a5  $10
	note b5  $30
	rest $10
	note e6  $30
; Measure 16a
	note e6  $10
	note d6  $18
	rest $08
	note a5  $18
	rest $08
	note f5  $18
	rest $08
; Measure 17a
	note d5  $18
	rest $38
	note b4  $05
	note e5  $05
	note a4  $06
	note b4  $2a
; Measure 18a
	rest $06
	note b4  $04
	note e5  $04
	note fs5 $04
	note a5  $04

	note b5  $30
	note a5  $05
	note b5  $05
	note a5  $06
	note f5  $20
; Measure 1a
	note e5  $10
	note d5  $10
	goto musiceeac7
	cmdff

.define musTarmRuinsChannel6 MUSIC_CHANNEL_FALLBACK EXPORT
