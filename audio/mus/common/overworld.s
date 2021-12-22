musOverworldStart:

musOverworldChannel1:
; Measure 1
	vibrato $00         ;useless?
	duty $02
	vol $6

	env $0 $04
	note g4  $18
	env $0 $02
	note g4  $08
	note d4  $08
	note g4  $08

	env $0 $04
	note f4  $18
	env $0 $02
	note f4  $08
	note g4  $08
	note a4  $08
; Measure 2
	env $0 $04
	note as4 $18
	env $0 $02
	note as4 $08
	note g4  $08
	note as4 $08

	env $0 $04
	note a4  $18
	env $0 $02
	note a4  $08
	note as4 $08
	note c5  $08
; Measure 3
	vibrato $e1
	env $0 $00
	note d5  $3c
	rest $0c

	vibrato $00
	env $0 $02
	note c5  $08
	note c5  $08
	note c5  $08
; Measure 4
	vibrato $e1
	env $0 $00
	note d5  $3c
	rest $0c

	vibrato $00
	env $0 $00
	note c5  $04
	rest $04
	note b4  $04
	rest $04
	note a4  $04
	rest $04
musiceca67:
; Measure 5
	vibrato $00     ;useless?
	env $0 $05
	note g4  $18
	note d4  $18

	env $0 $04
	rest $12
	note g4  $06
	note g4  $06
	note a4  $06
	note b4  $06
	note c5  $06
; Measure 6
	env $0 $05
	note d5  $30

	env $0 $04
	rest $10
	note d5  $08
	note d5  $08
	note ds5 $08
	note f5  $08
; Measure 7
	env $0 $05
	note g5  $30

	env $0 $04
	rest $10
	note g5  $08
	note g5  $08
	note f5  $08
	note ds5 $08
; Measure 8
	vibrato $00         ;useless?
	env $0 $00
	note f5  $08
	rest $08
	note ds5 $08

	vibrato $00         ;useless?
	env $0 $05
	note d5  $18

	env $0 $04
	rest $18
	note d5  $08
	note ds5 $08
	note d5  $08
; Measure 9
	note c5  $0c
	note c5  $06
	note d5  $06

	env $0 $05
	note ds5 $18

	env $0 $04
	rest $18
	note d5  $0c
	note c5  $0c
; Measure 10
	note as4 $0c
	note as4 $06
	note c5  $06

	env $0 $05
	note d5  $18

	env $0 $04
	rest $18
	note c5  $0c
	note as4 $0c
; Measure 11
	note a4  $0c
	note a4  $06
	note b4  $06

	env $0 $05
	note cs5 $18

	env $0 $04
	rest $18
	note e5  $18
; Measure 12
	note d5  $0c

	vibrato $00         ;useless?
	env $0 $01
	duty $00
	vol $8
	note d4  $04
	note d4  $04
	note d4  $04

	vibrato $00         ;useless?
	vol $6
	env $0 $02
	note e4  $08
	note e4  $08
	note e4  $08

	vibrato $00         ;useless?
	env $0 $00
	vol $7
	note fs4 $18
	vol $6
	rest $18
; Measure 13            repeat of M5
	vibrato $00         ;useless?
	env $0 $05
	duty $02
	note g4  $18
	note d4  $18

	env $0 $04
	rest $12
	note g4  $06
	note g4  $06
	note a4  $06
	note b4  $06
	note c5  $06
; Measure 14            repeat of M6
	env $0 $05
	note d5  $30

	env $0 $04
	rest $10
	note d5  $08
	note d5  $08
	note ds5 $08
	note f5  $08
; Measure 15            repeat of M7
	env $0 $05
	note g5  $30
    
	env $0 $04
	rest $10
	note g5  $08
	note g5  $08
	note f5  $08
	note ds5 $08
; Measure 16            very similar to M8
	vibrato $00         ;useless?
	env $0 $00
	note f5  $08
	rest $08
	note ds5 $08

	vibrato $00         ;useless?
	env $0 $04          ;$05 in M8
	note d5  $18

	env $0 $03          ;$04 in M8
	rest $18
	note d5  $08
	note ds5 $08
	note d5  $08
; Measure 17            repeat of M9
	note c5  $0c
	note c5  $06
	note d5  $06

	env $0 $05
	note ds5 $18

	env $0 $04
	rest $18
	note d5  $0c
	note c5  $0c
; Measure 18
	vol $6
	note as4 $08
	note a4  $08
	note as4 $08
	note c5  $08
	note as4 $08
	note c5  $08

	vibrato $00         ;useless?
	env $0 $00
	note d5  $08
	rest $08
	note d5  $08
	note d5  $08
	note c5  $08
	note as4 $08
; Measure 19
	vibrato $e1
	env $0 $00          ;useless?
	vol $6              ;useless?
	note d5  $30
	note d6  $30
; Measure 20
	vol $5
	note g5  $3c
	rest $0c

	vibrato $00
	env $0 $00          ;useless?         
	vol $6
	duty $01
	note d5  $04
	rest $04
	note ds5 $04
	rest $04
	note f5  $04
	rest $04
; Measure 21
	vibrato $e1
	env $0 $00          ;useless? 
	note g5  $12
	rest $06
	note d5  $18
	rest $12

	vibrato $00
	env $0 $00          ;useless? 
	note g5  $03
	rest $03
	note g5  $03
	rest $03
	note a5  $03
	rest $03
	note as5 $03
	rest $03
	note c6  $03
	rest $03
; Measure 22
	note a5  $05
	rest $0b
	note f5  $05
	rest $03
    
	vibrato $f1
	note c5  $18
	rest $0c

	vibrato $00
	env $0 $00          ;useless? 
	note c5  $03
	rest $03
	note d5  $03
	rest $03
	note f5  $03
	rest $03
	note ds5 $03
	rest $03
	note d5  $03
	rest $03
	note c5  $03
	rest $03
; Measure 23
	note d5  $05
	rest $0b
	note g4  $04
	rest $04

	vibrato $e1
	env $0 $00          ;useless? 
	note g4  $18
	rest $0c

	vibrato $00
	env $0 $00          ;useless? 
	note g4  $03
	rest $03
	note fs4 $03
	rest $03
	note g4  $03
	rest $03
	note a4  $03
	rest $03
	note as4 $03
	rest $03
	note c5  $03
	rest $03
; Measure 24
	vibrato $e1
	env $0 $00          ;useless? 
	note d5  $24
	rest $24
	vibrato $00
	env $0 $00          ;useless? 
	note d5  $04
	rest $04
	note c5  $04
	rest $04
	note d5  $04
	rest $04
; Measure 25
	note as5 $05
	rest $0b
	note a5  $05
	rest $03

	note g5  $18
	rest $08

	note d5  $04
	rest $04
	note d5  $04
	rest $04
	note d5  $04
	rest $04
	note as4 $04
	rest $04
	note g5  $04
	rest $04
; Measure 26
	note gs5 $05
	rest $0b
	note as5 $05
	rest $03

	note c6  $18
	rest $08

	note c6  $04
	rest $04
	note d6  $04
	rest $04
	note ds6 $04
	rest $04
	note f6  $04
	rest $04
	note ds6 $04
	rest $04
; Measure 27
	vibrato $e1
	env $0 $00          ;useless? 
	note d6  $3c

	vibrato $01
	env $0 $00          ;useless? 
	vol $3
	note d6  $0c
	vol $2
	note d6  $0c
	rest $18
; Measure 28a
	vibrato $00
	env $0 $01
	duty $02            ;useless?
	vol $6
	note d5  $04
	note d5  $04
	note d5  $04
	vibrato $00         ;useless?
	env $0 $02
	note e5  $08
	note e5  $08
	note e5  $08
	env $0 $04
	note fs5 $18
	rest $18
	vibrato $00         ;useless?
	env $0 $02          ;useless? (overwritten to $0 $05 before another note)
	goto musiceca67
	cmdff

musOverworldChannel0:
; Measure 1
	vibrato $00         ;useless?
	duty $02
	vol $6
	env $0 $04
	note b3  $18

	env $0 $02
	note b3  $08
	note b3  $08
	note b3  $08

	env $0 $04
	note a3  $18
	note a3  $08
	note b3  $08
	note c4  $08
; Measure 2
	env $0 $04          ;useless? 
	note ds4 $18

	env $0 $02
	note ds4 $08
	note ds4 $08
	note ds4 $08

	env $0 $04
	note f4  $18

	env $0 $02
	note f4  $08
	note f4  $08
	note f4  $08
; Measure 3
	vibrato $e1
	env $0 $00
	note g4  $2a

	vibrato $01
	env $0 $00          ;useless? 
	vol $4
	note g4  $0c
	vol $2
	note g4  $0c
	rest $06

	vibrato $00
	env $0 $02
	vol $6
	note f4  $08
	note f4  $08
	note f4  $08
; Measure 4     similar to M3
	vibrato $e1
	env $0 $00
	note g4  $2a

	vibrato $01
	env $0 $00          ;useless? 
	vol $2
	note g4  $0c
	vol $1
	note g4  $0c

	rest $1e       ;difference from M3, takes out beat 4
musicecd1c:
	vibrato $00
	env $0 $03
	vol $6
; Measure 5
	note b3  $18

	note c4  $08
	note b3  $08
	note a3  $08

	note b3  $12
	note b3  $06

	note b3  $06
	note c4  $06
	note d4  $06
	note e4  $06
; Measure 6
	note f4  $12
	note g4  $06

	note g4  $06
	note a4  $06
	note b4  $06
	note c5  $06

	note d5  $18

	note f4  $08
	note g4  $08
	note a4  $08
; Measure 7
	note as4 $10
	note ds4 $08

	note ds4 $06
	note f4  $06
	note g4  $06
	note a4  $06

	note as4 $06
	rest $0a
	note as4 $08

	note as4 $08
	note a4  $08
	note g4  $08
; Measure 8
	note as4 $06
	rest $0a
	note f4  $08

	note f4  $08
	note f4  $08
	note ds4 $08

	note f4  $08
	rest $08
	note f4  $08

	note f4  $08
	note ds4 $08
	note f4  $08
; Measure 9
	note ds4 $0c
	note ds4 $06
	note d4  $06

	note ds4 $0c
	note ds4 $06
	note f4  $06

	env $0 $05
	note g4  $18

	env $0 $03
	note f4  $0c
	note ds4 $0c
; Measure 10        ;same structure as M9
	note d4  $0c
	note d4  $06
	note c4  $06

	note d4  $0c
	note d4  $06
	note ds4 $06

	env $0 $05
	note f4  $18

	env $0 $03
	note ds4 $0c
	note d4  $0c
; Measure 11
	note cs4 $18

	note cs4 $0c
	note cs4 $06
	note d4  $06

	note e4  $0c
	note e4  $06
	note f4  $06

	note g4  $06
	note a4  $06
	note b4  $06
	note c5  $06
; Measure 12
	vibrato $00     ;useless?
	env $0 $05
	duty $01
	note a4  $18

	vibrato $00
	env $0 $03
	note c4  $08
	note c4  $08
	note c4  $08

	vol $7
	note d4  $18
	vol $6
	rest $18
; Measure 13        repeat of M5
	duty $02
	note b3  $18

	note c4  $08
	note b3  $08
	note a3  $08

	note b3  $12
	note b3  $06

	note b3  $06
	note c4  $06
	note d4  $06
	note e4  $06
; Measure 14        repeat of M6
	note f4  $12
	note g4  $06

	note g4  $06
	note a4  $06
	note b4  $06
	note c5  $06

	note d5  $18

	note f4  $08
	note g4  $08
	note a4  $08
; Measure 15        repeat of M7
	note as4 $10
	note ds4 $08

	note ds4 $06
	note f4  $06
	note g4  $06
	note a4  $06

	note as4 $06
	rest $0a
	note as4 $08

	note as4 $08
	note a4  $08
	note g4  $08
; Measure 16        repeat of M8
	note as4 $06
	rest $0a
	note f4  $08

	note f4  $08
	note f4  $08
	note ds4 $08

	note f4  $08
	rest $08
	note f4  $08

	note f4  $08
	note ds4 $08
	note f4  $08
; Measure 17        ;repeat of M9
	note ds4 $0c
	note ds4 $06
	note d4  $06

	note ds4 $0c
	note ds4 $06
	note f4  $06

	env $0 $05
	note g4  $18

	env $0 $03
	note f4  $0c
	note ds4 $0c
; Measure 18
	vibrato $e0
	env $2 $00
	vol $4
	note g3  $18
	note fs3 $18
	note f3  $30
; Measure 19
	vol $5
	note e3  $18

	vol $5      ;useless
	note c3  $18
	note d3  $12
	rest $06

	vibrato $00
	env $0 $00
	vol $6
	note d3  $04
	vol $1
	note d3  $04

	vol $6
	note d4  $04
	vol $1
	note d4  $04

	vol $6
	note c4  $04
	vol $1
	note c4  $04
; Measure 20
	vol $6
	note as3 $04
	vol $1
	note as3 $04

	vol $6
	note a3  $04
	vol $1
	note a3  $04

	vol $6
	note g3  $04
	vol $1
	note g3  $04

	vol $6
	note a3  $04
	vol $1
	note a3  $04
	rest $10

	vol $6
	note g3  $04
	vol $1
	note g3  $04
	rest $28
; Measure 21
	duty $01
	vol $6
	note as4 $10
	rest $08

	note g4  $18

	rest $12
	note as4 $03
	rest $03

	note as4 $03
	rest $03
	note c5  $03
	rest $03
	note d5  $03
	rest $03
	note ds5 $03
	rest $03
; Measure 22
	note c5  $05
	rest $0b
	note as4 $05
	rest $03

	note a4  $18
	rest $18
	note f4  $14
	rest $04
; Measure 23
	note g4  $05
	rest $0b
	note d4  $05
	rest $03

	note d4  $14
	rest $04
	note c4  $14
	rest $04
	note e4  $14
	rest $04
; Measure 24
	note g4  $03
	rest $09
	note g4  $03
	rest $03
	note fs4 $03
	rest $03

	note g4  $03
	rest $03
	note a4  $03
	rest $03
	note as4 $03
	rest $03
	note c5  $03
	rest $03

	note d5  $18
	vol $3
	note d5  $0c
	rest $0c
; Measure 25
	vol $6
	note d5  $05
	rest $0b
	note c5  $05
	rest $03

	note as4 $18
	vol $3
	note as4 $0c
	vol $1
	note as4 $0c

	rest $18
; Measure 26
	vol $6
	note c5  $05
	rest $0b
	note ds5 $05
	rest $03

	note gs5 $18
	vol $3
	note gs5 $0c
	vol $1
	note gs5 $0c
	rest $30
; Measure 27b
	vibrato $00
	env $0 $02
	duty $02
	vol $6

	note g4  $04
	rest $04
	note g4  $04
	rest $04
	note g4  $04
	rest $04

	env $0 $04
	note g4  $0c

	env $0 $02
	rest $3c
; Measure 28b
	note c5  $04
	rest $04
	note c5  $04
	rest $04
	note c5  $04
	rest $04
    
	env $0 $04
	note d5  $0c
	env $0 $02
	rest $24
	goto musicecd1c
	cmdff

musOverworldChannel4:
; Measure 1
	duty $0e
	note g3  $04
	duty $0f
	note g3  $03
	rest $11
.rept 3
	duty $0e
	note g3  $04
	duty $0f
	note g3  $03
	rest $01
.endr
	duty $0e
	note f3  $04
	duty $0f
	note f3  $03
	rest $11
.rept 3
	duty $0e
	note f3  $04
	duty $0f
	note f3  $03
	rest $01
.endr
; Measure 2
	duty $0e
	note ds3 $04
	duty $0f
	note ds3 $03
	rest $11
.rept 3
	duty $0e
	note ds3 $04
	duty $0f
	note ds3 $03
	rest $01
.endr
.rept 4
	duty $0e
	note f3  $04
	duty $0f
	note f3  $03
	rest $01
.endr
	duty $0e
	note ds3 $04
	duty $0f
	note ds3 $03
	rest $01

	duty $0e
	note f3  $04
	duty $0f
	note f3  $03
	rest $01
; Measure 3-4
.rept 2
	duty $0e
	note g3  $04
	duty $0f
	note g3  $03
	rest $11
 .rept 3
	duty $0e
	note g3  $04
	duty $0f
	note g3  $03
	rest $01
 .endr
	duty $0e
	note g3  $04
	duty $0f
	note g3  $03
	rest $11
 .rept 3
	duty $0e
	note d3  $04
	duty $0f
	note d3  $03
	rest $01
 .endr
.endr
musiced0a3:
; Measure 5
	duty $0e
	note g2  $04
	duty $0f
	note g2  $03
	rest $11
.rept 2
	duty $0e
	note g2  $04
	duty $0f
	note g2  $03
	rest $01
.endr
	duty $0e
	note f2  $04
	duty $0f
	note f2  $03
	rest $01
.rept 2
	duty $0e
	note g2  $04
	duty $0f
	note g2  $03
	rest $11
.endr
; Measure 6
	duty $0e
	note f2  $04
	duty $0f
	note f2  $03
	rest $11
.rept 2
	duty $0e
	note f2  $04
	duty $0f
	note f2  $03
	rest $01
.endr
	duty $0e
	note ds2 $04
	duty $0f
	note ds2 $03
	rest $01
.rept 2 
	duty $0e
	note f2  $04
	duty $0f
	note f2  $03
	rest $11
.endr
; Measure 7
	duty $0e
	note ds2 $04
	duty $0f
	note ds2 $03
	rest $11
.rept 2   
	duty $0e
	note ds2 $04
	duty $0f
	note ds2 $03
	rest $01
.endr
	duty $0e
	note d2  $04
	duty $0f
	note d2  $03
	rest $01
.rept 2    
	duty $0e
	note ds2 $04
	duty $0f
	note ds2 $03
	rest $11
.endr
; Measure 8
	duty $0e
	note as2 $04
	duty $0f
	note as2 $03
	rest $11
.rept 2    
	duty $0e
	note as2 $04
	duty $0f
	note as2 $03
	rest $01
.endr
	duty $0e
	note gs2 $04
	duty $0f
	note gs2 $03
	rest $01
.rept 2    
	duty $0e
	note as2 $04
	duty $0f
	note as2 $03
	rest $11
.endr
; Measure 9
	duty $0e
	note gs2 $04
	duty $0f
	note gs2 $03
	rest $11
.rept 2
	duty $0e
	note gs2 $04
	duty $0f
	note gs2 $03
	rest $01
.endr
	duty $0e
	note g2  $04
	duty $0f
	note g2  $03
	rest $01

	duty $0e
	note gs2 $04
	duty $0f
	note gs2 $03
	rest $11
.rept 3
	duty $0e
	note gs2 $04
	duty $0f
	note gs2 $03
	rest $01
.endr
; Measure 10
	duty $0e
	note g2  $04
	duty $0f
	note g2  $03
	rest $11
.rept 2
	duty $0e
	note g2  $04
	duty $0f
	note g2  $03
	rest $01
.endr
	duty $0e
	note f2  $04
	duty $0f
	note f2  $03
	rest $01

	duty $0e
	note g2  $04
	duty $0f
	note g2  $03
	rest $11
.rept 3
	duty $0e
	note g2  $04
	duty $0f
	note g2  $03
	rest $01
.endr
; Measure 11
.rept 2
	duty $0e
	note a2  $04
	duty $0f
	note a2  $03
	rest $11
 .rept 3   
	duty $0e
	note a2  $04
	duty $0f
	note a2  $03
	rest $01
 .endr
.endr
; Measure 12
	duty $0e
	note d3  $04
	duty $0f
	note d3  $03
	rest $11
.rept 3
	duty $0e
	note g3  $04
	duty $0f
	note g3  $03
	rest $01
.endr
	duty $0e
	note a3  $18

	duty $0e
	note e3  $04
	duty $0f
	note e3  $04
	rest $04

	duty $0e
	note fs3 $04
	duty $0f
	note fs3 $04
	rest $04
; Measure 13    
	duty $0e
	note g2  $04
	duty $0f
	note g2  $03
	rest $11
.rept 2
	duty $0e
	note g2  $04
	duty $0f
	note g2  $03
	rest $01
.endr
	duty $0e
	note f2  $04
	duty $0f
	note f2  $03
	rest $01
.rept 2    
	duty $0e
	note g2  $04
	duty $0f
	note g2  $03
	rest $11
.endr
; Measure 14
	duty $0e
	note f2  $04
	duty $0f
	note f2  $03
	rest $11
.rept 2
	duty $0e
	note f2  $04
	duty $0f
	note f2  $03
	rest $01
.endr
	duty $0e
	note ds2 $04
	duty $0f
	note ds2 $03
	rest $01
.rept 2 
	duty $0e
	note f2  $04
	duty $0f
	note f2  $03
	rest $11
.endr
; Measure 15
	duty $0e
	note ds2 $04
	duty $0f
	note ds2 $03
	rest $11
.rept 2   
	duty $0e
	note ds2 $04
	duty $0f
	note ds2 $03
	rest $01
.endr
	duty $0e
	note d2  $04
	duty $0f
	note d2  $03
	rest $01
.rept 2    
	duty $0e
	note ds2 $04
	duty $0f
	note ds2 $03
	rest $11
.endr
; Measure 16
	duty $0e
	note as2 $04
	duty $0f
	note as2 $03
	rest $11
.rept 2    
	duty $0e
	note as2 $04
	duty $0f
	note as2 $03
	rest $01
.endr
	duty $0e
	note gs2 $04
	duty $0f
	note gs2 $03
	rest $01
.rept 2    
	duty $0e
	note as2 $04
	duty $0f
	note as2 $03
	rest $11
.endr
; Measure 17
	duty $0e
	note gs2 $04
	duty $0f
	note gs2 $03
	rest $11
.rept 2    
	duty $0e
	note gs3 $04
	duty $0f
	note gs3 $03
	rest $01
.endr
	duty $0e
	note g3  $04
	duty $0f
	note g3  $03
	rest $01

	duty $0e
	note gs3 $04
	duty $0f
	note gs3 $03
	rest $11
.rept 3    
	duty $0e
	note gs3 $04
	duty $0f
	note gs3 $03
	rest $01
.endr
; Measure 18
	duty $14
	vol $8          ;useless
	note d4  $08
	note cs4 $08
	note d4  $08
	note fs4 $08
	note g4  $08
	note a4  $08
	note as4 $08
	rest $08
	note as4 $08
	note as4 $08
	note a4  $08
	note g4  $08
; Measure 19
	duty $15
	note d5  $0c
	rest $04
	note as4 $0c
	rest $04
	note g4  $10
	note fs4 $10
	duty $14
	rest $08
	note fs4 $08
	note e4  $08
	vol $9              ;useless
	note fs4 $08
; Measure 20
	note g4  $08
	note a4  $08
	note as4 $08
	note c5  $08
	note as4 $08
	note a4  $08
	note as4 $18
	rest $18
; Measure 21
	duty $0e
	note ds2 $04
	duty $0f
	note ds2 $03
	rest $11

	duty $0e
	note ds3 $04
	duty $0f
	note ds3 $03
	rest $01

	duty $0e
	note g3  $04
	duty $0f
	note g3  $03
	rest $01

	duty $0e
	note as3 $04
	duty $0f
	note as3 $03
	rest $01

	duty $0e
	note ds4 $04
	duty $0f
	note ds4 $03
	rest $11
.rept 3 
	duty $0e
	note ds2 $04
	duty $0f
	note ds2 $03
	rest $01
.endr
; Measure 22
	duty $0e
	note d2  $04
	duty $0f
	note d2  $03
	rest $11

	duty $0e
	note d3  $04
	duty $0f
	note d3  $03
	rest $01

	duty $0e
	note f3  $04
	duty $0f
	note f3  $03
	rest $01

	duty $0e
	note a3  $04
	duty $0f
	note a3  $03
	rest $01

	duty $0e
	note d4  $04
	duty $0f
	note d4  $03
	rest $11
.rept 3
	duty $0e
	note d3  $04
	duty $0f
	note d3  $03
	rest $01
.endr
; Measure 23-24b
.rept 3
	duty $0e
	note g2  $04
	duty $0f
	note g2  $03
	rest $11
 .rept 3
	duty $0e
	note g2  $04
	duty $0f
	note g2  $03
	rest $01
 .endr
.endr
; Measure 24c
	duty $0e
	note g2  $04
	duty $0f
	note g2  $03
	rest $09

	duty $0e
	note g2  $04
	duty $0f
	note g2  $03
	rest $09

	duty $0e
	note f2  $04
	duty $0f
	note f2  $03
	rest $09
; Measure 25
	duty $0e
	note ds2 $04
	duty $0f
	note ds2 $03
	rest $11

	duty $0e
	note ds2 $04
	duty $0f
	note ds2 $03
	rest $01

	duty $0e
	note g2  $04
	duty $0f
	note g2  $03
	rest $01

	duty $0e
	note as2 $04
	duty $0f
	note as2 $03
	rest $01

	duty $0e
	note ds3 $04
	duty $0f
	note ds3 $03
	rest $11
.rept 3
	duty $0e
	note ds2 $04
	duty $0f
	note ds2 $03
	rest $01
.endr
; Measure 26
	duty $0e
	note gs2 $04
	duty $0f
	note gs2 $03
	rest $11

	duty $0e
	note gs2 $04
	duty $0f
	note gs2 $03
	rest $01

	duty $0e
	note c3  $04
	duty $0f
	note c3  $03
	rest $01

	duty $0e
	note ds3 $04
	duty $0f
	note ds3 $03
	rest $01

	duty $0e
	note gs3 $04
	duty $0f
	note gs3 $03
	rest $11
.rept 3
	duty $0e
	note gs2 $04
	duty $0f
	note gs2 $03
	rest $01
.endr
; Measure 27
	duty $0e
	note d2  $04
	duty $0f
	note d2  $03
	rest $11
.rept 3    
	duty $0e
	note c4  $04
	duty $0f
	note c4  $03
	rest $01
.endr
	duty $0e
	note c4  $04
	duty $0f
	note c4  $03
	rest $11
.rept 3
	duty $0e
	note d2  $04
	duty $0f
	note d2  $03
	rest $01
.endr
; Measure 28
	duty $0e
	note d2  $04
	duty $0f
	note d2  $03
	rest $11
.rept 3
	duty $0e
	note g4  $04
	duty $0f
	note g4  $03
	rest $01
.endr
	duty $0e
	note a4  $04
	duty $0f
	note a4  $03
	rest $01

	duty $0e
	note ds3 $04
	duty $0f
	note ds3 $03
	rest $01

	duty $0e
	note d3  $04
	duty $0f
	note d3  $03
	rest $01

	duty $0e
	note c3  $04
	duty $0f
	note c3  $03
	rest $01

	duty $0e
	note as2 $04
	duty $0f
	note as2 $03
	rest $01

	duty $0e
	note a2  $04
	duty $0f
	note a2  $03
	rest $01

	goto musiced0a3
	cmdff

.ifdef ROM_SEASONS
.ifdef BUILD_VANILLA
	.db $ff $ff $ff
.endif
.endif

.define musOverworldChannel6 MUSIC_CHANNEL_FALLBACK EXPORT
