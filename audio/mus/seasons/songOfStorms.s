sound3dStart:

sound3dChannel1:
; Measure 1-4
	vol $0
	note gs3 $c0
	vibrato $e1
	env $0 $00
	cmdf2
	duty $02
musicf84c2:
; Measure 5-6
.rept 2
	vol $7
	note d4  $08
	note f4  $08
	note d5  $08
	rest $04

	vol $3
	note d5  $08
	rest $04

	vol $1
	note d5  $08
.endr
; Measure 7
	vol $7
	note e5  $10
	rest $04
	vol $3
	note e5  $04

	vol $7
	note f5  $08
	note e5  $08
	note f5  $08
; Measure 8
	note e5  $08
	note c5  $08

	note a4  $10
	rest $02
	vol $3
	note a4  $08
	rest $02
	vol $1
	note a4  $04
; Measure 9
	vol $7
	note a4  $10
	note d4  $10
	note f4  $08
	note g4  $08
; Measure 10
	note a4  $20
	vol $3
	note a4  $10
; Measure 11
	vol $7
	note a4  $10
	note d4  $10
	note f4  $08
	note g4  $08
; Measure 12
	note e4  $20
	vol $3
	note e4  $10
; Measure 13-14
.rept 2
	vol $7
	note d4  $08
	note f4  $08
	note d5  $08
	rest $04

	vol $3
	note d5  $08
	rest $04

	vol $1
	note d5  $08
.endr
; Measure 15
	vol $7
	note e5  $10
	rest $04
	vol $3
	note e5  $04

	vol $7
	note f5  $08
	note e5  $08
	note f5  $08
; Measure 16
	note e5  $08
	note c5  $08

	note a4  $10
	vol $3
	note a4  $10
; Measure 17
	vol $7
	note a4  $10
	note d4  $10
	note f4  $08
	note g4  $08
; Measure 18
	note a4  $10
	rest $06
	vol $3
	note a4  $08
	rest $02
	vol $7
	note a4  $10
; Measure 19
	note d4  $50
; Measure 20-21
	rest $70
	goto musicf84c2
	cmdff

sound3dChannel0:
; Measure 1
	vol $0
	note gs3 $10
	vibrato $00
	env $0 $00
	cmdf2
	duty $02
.rept 2
	vol $6
	note a3  $04
	rest $02
	vol $3
	note a3  $04
	rest $02
	vol $1
	note a3  $04
.endr
; Measure 2
	rest $08
	vol $6
	note e3  $08
	note b3  $18
	vol $3
	note b3  $08
; Measure 3
	rest $10
.rept 2
	vol $6
	note c4  $04
	rest $02
	vol $3
	note c4  $04
	rest $02
	vol $1
	note c4  $04
.endr
; Measure 4
	rest $08
	vol $6
	note e3  $08
	note b3  $18
	vol $3
	note b3  $08
musicf85ca:
; Measure 5
	rest $10
.rept 2
	vol $6
	note a3  $04
	rest $02
	vol $3
	note a3  $04
	rest $02
	vol $1
	note a3  $04
.endr
; Measure 6
	rest $10
	vol $6
	note b3  $18
	vol $3
	note b3  $08
; Measure 7
	rest $10
.rept 2
	vol $6
	note c4  $04
	rest $02
	vol $3
	note c4  $04
	rest $02
	vol $1
	note c4  $04
.endr
; Measure 8
	rest $10
	vol $6
	note b3  $18
	vol $3
	note b3  $08
; Measure 9
	rest $10
.rept 2
	vol $6
	note a3  $04
	rest $02
	vol $3
	note a3  $04
	rest $02
	vol $1
	note a3  $04
.endr
; Measure 10
	rest $10
	vol $6
	note a3  $18
	vol $3
	note a3  $08
; Measure 11
	rest $10
.rept 2
	vol $6
	note a3  $04
	rest $02
	vol $3
	note a3  $04
	rest $02
	vol $1
	note a3  $04
.endr
; Measure 12
	rest $10
	vol $6
	note a3  $18
	vol $3
	note a3  $08
; Measure 13
	rest $10
.rept 2
	vol $6
	note a3  $04
	rest $02
	vol $3
	note a3  $04
	rest $02
	vol $1
	note a3  $04
.endr
; Measure 14
	rest $10
	vol $6
	note b3  $18
	vol $3
	note b3  $08
; Measure 15
	rest $10
.rept 2
	vol $6
	note c4  $04
	rest $02
	vol $3
	note c4  $04
	rest $02
	vol $1
	note c4  $04
.endr
; Measure 16
	rest $10
	vol $6
	note b3  $18
	vol $3
	note b3  $08
; Measure 17
	rest $10
.rept 2
	vol $6
	note a3  $04
	rest $02
	vol $3
	note a3  $04
	rest $02
	vol $1
	note a3  $04
.endr
; Measure 18
	rest $10
	vol $6
	note a3  $18
	vol $3
	note a3  $08
; Measure 19
	rest $10
.rept 2
	vol $6
	note a3  $04
	rest $02
	vol $3
	note a3  $04
	rest $02
	vol $1
	note a3  $04
.endr
; Measure 20
	rest $08
	vol $6
	note e3  $08
	note b3  $18
	vol $3
	note b3  $08
; Measure 21
	rest $10
.rept 2
	vol $6
	note c4  $04
	rest $02
	vol $3
	note c4  $04
	rest $02
	vol $1
	note c4  $04
.endr
; Measure 22
	rest $08
	vol $6
	note e3  $08
	note b3  $18
	vol $3
	note b3  $08
	goto musicf85ca
	cmdff

sound3dChannel4:
	cmdf2
; Measure 1
	duty $17
	note d2  $10
.rept 2
	duty $17
	note f3  $04
	rest $0c
.endr
; Measure 2
	duty $17
	note e2  $10
	note g3  $20
; Measure 3
	note f2  $10
.rept 2
	duty $17
	note a3  $04
	rest $0c
.endr
; Measure 4
	duty $17
	note e2  $10
	note g3  $20

musicf8741:
; Measure 5
	note d2  $10
.rept 2
	note f3  $04
	rest $0c
.endr
; Measure 6
	note e2  $10
	note g3  $20
; Measure 7
	note f2  $10
.rept 2
	note a3  $04
	rest $0c
.endr
; Measure 8
	note e2  $10
	note g3  $20
; Measure 9
	note as2 $10
.rept 2
	note f3  $04
	rest $0c
.endr
; Measure 10
	note f2  $10
	note f3  $20
; Measure 11
	note as2 $10
.rept 2
	note f3  $04
	rest $0c
.endr
; Measure 12
	note a2  $10
	note e3  $20
; Measure 13
	note d2  $10
.rept 2
	note f3  $04
	rest $0c
.endr
; Measure 14
	note e2  $10
	note g3  $20
; Measure 15
	note f2  $10
.rept 2
	note a3  $04
	rest $0c
.endr
; Measure 16
	note e2  $10
	note g3  $20
; Measure 17
	note as2 $10
.rept 2
	note f3  $04
	rest $0c
.endr
; Measure 18
	note a2  $10
	note e3  $20
; Measure 19
	note d2  $10
.rept 2
	note f3  $04
	rest $0c
.endr
; Measure 20
	note e2  $10
	note g3  $20
; Measure 21
	note f2  $10
.rept 2
	note a3  $04
	rest $0c
.endr
; Measure 22
	note e2  $10
	note g3  $20
	goto musicf8741
	cmdff

sound3dChannel6:
; Measure 1
	rest $10
	cmdf2
	cmdf2
	vol $3
.rept 2
	note $2a $10
.endr
; Measure 2
	rest $08
.rept 4
	note $2a $08
.endr
	rest $18
; Measure 3b
.rept 2
	note $2a $10
.endr
	rest $08
.rept 4
	note $2a $08
.endr
	rest $07
musicf87e8:
; Measure 5
	rest $11
; Measure 5b-20b
.rept 8
	.rept 2
		note $2a $10
	.endr
		rest $08
	.rept 4
		note $2a $08
	.endr
		rest $18
.endr
; Measure 21b
.rept 2
	note $2a $10
.endr
; Measure 22
	rest $08
.rept 4
	note $2a $08
.endr
	rest $07
	goto musicf87e8
	cmdff
