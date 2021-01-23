
sounddeStart:

sounddeChannel0:
sounddeChannel1:
sounddeChannel4:
sounddeChannel6:
	cmdff

sound1eStart:

sound06Start:

sounda1Start:

sound1eChannel6:
sound06Channel6:
sounda1Channel7:
	cmdff
	cmdff

sound99Start:

sound99Channel2:
	cmdf0 $80
	cmdf8 $1e
	vol $d
	.db $07 $4f $01
	vol $0
	.db $00 $00 $01
	vol $d
	.db $07 $4a $01
	vol $0
	.db $00 $00 $01
	vol $d
	.db $07 $4c $01
	vol $0
	.db $00 $00 $01
	vol $d
	.db $07 $4e $01
	vol $0
	.db $00 $00 $01
	vol $d
	.db $07 $49 $01
	vol $0
	.db $00 $00 $01
	vol $d
	.db $07 $51 $01
	vol $0
	.db $00 $00 $01
	vol $d
	.db $07 $4b $01
	vol $0
	.db $00 $00 $01
	vol $d
	.db $07 $4f $01
	vol $0
	.db $00 $00 $01
	vol $d
	.db $07 $4f $01
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff

sounda1Channel2:
	duty $00
	vol $a
	cmdf8 $0a
	note c6  $05
	cmdf8 $00
	cmdff

sounda4Start:

sounda4Channel2:
	cmdf0 $3c
	vol $9
	.db $06 $0b $02
	vol $9
	.db $06 $0b $02
	vol $8
	.db $06 $0b $02
	vol $8
	.db $06 $0b $02
	vol $7
	.db $06 $0b $02
	vol $7
	.db $06 $0b $02
	vol $6
	.db $06 $0b $02
	vol $5
	.db $06 $0b $02
	vol $5
	.db $06 $0b $02
	vol $4
	.db $06 $0b $02
	vol $3
	.db $06 $0b $02
	vol $2
	.db $06 $0b $02
	vol $2
	.db $06 $0b $02
	cmdff

sounda4Channel7:
	cmdf0 $b0
	note $37 $02
	cmdf0 $83
	note $35 $03
	note $36 $03
	note $37 $03
	note $35 $03
	note $36 $03
	note $37 $03
	note $35 $03
	note $36 $05
	cmdff

soundaaStart:

soundaaChannel7:
	cmdf0 $20
	note $15 $03
	cmdf0 $30
	note $15 $03
	cmdf0 $40
	note $15 $03
	cmdf0 $50
	note $15 $03
	cmdf0 $60
	note $15 $03
	cmdf0 $70
	note $15 $06
	cmdf0 $70
	note $15 $19
	cmdf0 $70
	note $15 $19
	cmdf0 $77
	note $15 $4b
	cmdff

soundabStart:

soundabChannel2:
	cmdf0 $00
	vol $0
	.db $00 $00 $09
	vol $6
	env $0 $07
	.db $07 $c0 $55
	cmdff

soundabChannel7:
	cmdf0 $80
	note $27 $01
	note $37 $01
	note $46 $01
	note $56 $01
	note $66 $01
	note $56 $01
	note $46 $01
	note $37 $01
	note $27 $01
	cmdff

sound8aStart:

sound8aChannel2:
	duty $02
	vol $d
	note a5  $01
	note cs6 $01
	vol $b
	note as5 $01
	note d6  $01
	vol $9
	note b5  $01
	note c6  $01
	note e6  $01
	note cs6 $01
	note f6  $01
	note d6  $01
	note ds6 $01
	note g6  $01
	note e6  $01
	note gs6 $01
	note f6  $01
	note fs6 $01
	note as6 $01
	note g6  $01
	note b6  $01
	note gs6 $01
	note a6  $01
	note cs7 $01
	note as6 $01
	note d7  $01
	note b6  $01
	vol $b
	note e7  $02
	vol $8
	note a5  $01
	note cs6 $01
	note as5 $01
	note d6  $01
	note b5  $01
	note c6  $01
	note e6  $01
	vol $7
	note cs6 $01
	note f6  $01
	note d6  $01
	note ds6 $01
	note g6  $01
	note e6  $01
	note gs6 $01
	vol $6
	note f6  $01
	note fs6 $01
	note as6 $01
	note g6  $01
	note b6  $01
	note gs6 $01
	vol $5
	note a6  $01
	note cs7 $01
	note as6 $01
	note d7  $01
	note b6  $01
	vol $9
	note e7  $02
	vol $5
	note a5  $01
	note cs6 $01
	vol $4
	note as5 $01
	note d6  $01
	note b5  $01
	note c6  $01
	note e6  $01
	note cs6 $01
	note f6  $01
	vol $3
	note d6  $01
	note ds6 $01
	note g6  $01
	note e6  $01
	note gs6 $01
	note f6  $01
	vol $2
	note fs6 $01
	note as6 $01
	note g6  $01
	note b6  $01
	note gs6 $01
	vol $1
	note a6  $01
	note cs7 $01
	note as6 $01
	note d7  $01
	note b6  $02
	vol $2
	note e7  $01
	cmdff

sound88Start:

sound88Channel2:
	duty $02
	env $2 $00
	vol $9
	cmdf8 $16
	note fs3 $0f
	cmdf8 $00
	rest $02
	env $1 $00
	vol $1
	cmdf8 $0f
	note gs3 $0a
	env $0 $00
	vol $4
	cmdf8 $16
	note b3  $05
	cmdff

sound97Start:

sound97Channel2:
	cmdff

sound98Start:

sound98Channel2:
	vol $d
	cmdf0 $80
	cmdf8 $61
	.db $05 $39 $03
	cmdf8 $9f
	.db $06 $3f $03
	cmdf8 $61
	.db $05 $39 $03
	cmdf8 $9f
	.db $06 $3f $03
	cmdf8 $61
	.db $05 $39 $03
	vol $8
	cmdf8 $9f
	.db $06 $3f $03
	vol $6
	cmdf8 $61
	.db $05 $39 $03
	vol $4
	cmdf8 $9f
	.db $06 $3f $03
	vol $2
	cmdf8 $66
	.db $05 $39 $03
	cmdff

soundb1Start:

soundb1Channel7:
	cmdf0 $90
	note $54 $01
	note $47 $01
	note $34 $01
	note $36 $01
	note $35 $01
	note $44 $01
	note $46 $01
	note $54 $01
	note $56 $01
	cmdf0 $70
	note $54 $01
	note $47 $01
	note $34 $01
	note $36 $01
	note $35 $01
	note $44 $01
	note $46 $01
	note $54 $01
	note $56 $01
	cmdf0 $40
	note $54 $01
	note $47 $01
	note $34 $01
	note $36 $01
	note $35 $01
	note $44 $01
	note $46 $01
	note $54 $01
	note $56 $01
	cmdf0 $34
	note $54 $01
	note $47 $01
	note $34 $01
	note $36 $01
	note $35 $01
	note $44 $01
	note $46 $01
	note $54 $01
	note $56 $01
	cmdff

soundb3Start:

soundb3Channel2:
	cmdf0 $df
	.db $00 $45 $03
	vol $8
	env $0 $05
	.db $00 $45 $32
	cmdff

soundb3Channel7:
	cmdf0 $f5
	note $75 $3c
	cmdff

soundbeStart:

soundbeChannel2:
	cmdf0 $00
	vol $0
	.db $00 $00 $01
	vol $d
	.db $07 $80 $01
	vol $9
	cmdf8 $fc
	.db $07 $80 $05
	cmdf8 $00
	.db $07 $68 $01
	.db $07 $58 $01
	.db $07 $46 $01
	vol $b
	.db $07 $80 $01
	vol $9
	cmdf8 $fc
	.db $07 $80 $05
	cmdf8 $00
	.db $07 $68 $01
	.db $07 $58 $01
	.db $07 $46 $01
	vol $a
	.db $07 $80 $01
	vol $8
	cmdf8 $fc
	.db $07 $80 $05
	cmdf8 $00
	.db $07 $68 $01
	.db $07 $58 $01
	.db $07 $46 $01
	vol $9
	.db $07 $80 $01
	vol $7
	cmdf8 $fc
	.db $07 $80 $05
	cmdf8 $00
	.db $07 $68 $01
	.db $07 $58 $01
	.db $07 $46 $01
	vol $8
	.db $07 $80 $01
	vol $6
	cmdf8 $fc
	.db $07 $80 $05
	cmdf8 $00
	.db $07 $68 $01
	.db $07 $58 $01
	.db $07 $46 $01
	vol $5
	.db $07 $80 $01
	vol $3
	cmdf8 $fc
	.db $07 $80 $05
	cmdf8 $00
	.db $07 $68 $01
	.db $07 $58 $01
	.db $07 $46 $01
	vol $3
	.db $07 $80 $01
	env $0 $03
	vol $1
	cmdf8 $fc
	.db $07 $80 $05
	cmdff

soundacStart:

soundacChannel2:
	cmdf0 $db
	.db $06 $0b $02
	vol $b
	.db $06 $0b $02
	vol $b
	.db $06 $0b $02
	vol $b
	.db $06 $0b $02
	vol $b
	.db $06 $0b $02
	vol $b
	.db $06 $0b $02
	vol $b
	.db $06 $0b $02
	vol $b
	.db $06 $0b $02
	vol $b
	.db $06 $0b $02
	vol $b
	.db $06 $0b $02
	vol $b
	.db $06 $0b $02
	vol $b
	.db $06 $0b $02
	vol $b
	.db $06 $0b $02
	cmdff

soundacChannel7:
	cmdf0 $d0
	note $24 $02
	cmdf0 $d0
	note $34 $02
	cmdf0 $d0
	note $24 $02
	cmdf0 $d0
	note $34 $02
	cmdf0 $d0
	note $24 $02
	cmdf0 $d0
	note $34 $02
	cmdf0 $d0
	note $24 $02
	cmdf0 $d0
	note $34 $02
	cmdf0 $d0
	note $24 $02
	cmdf0 $d0
	note $34 $02
	cmdf0 $d0
	note $24 $02
	cmdf0 $d0
	note $34 $02
	cmdf0 $d0
	note $34 $02
	cmdff

soundbaStart:

soundbaChannel7:
	cmdf0 $20
	note $36 $02
	cmdf0 $50
	note $44 $02
	cmdf0 $70
	note $36 $02
	cmdf0 $80
	note $44 $02
	cmdf0 $90
	note $36 $02
	cmdf0 $c0
	note $44 $02
	cmdf0 $90
	note $36 $02
	cmdf0 $80
	note $44 $02
	cmdf0 $70
	note $36 $03
	cmdf0 $50
	note $44 $03
	cmdf0 $40
	note $36 $03
	cmdf0 $30
	note $44 $03
	cmdf0 $20
	note $36 $03
	cmdf0 $10
	note $44 $03
	cmdf0 $10
	note $36 $03
	cmdf0 $11
	note $44 $03
	cmdff

soundb4Start:

soundb4Channel7:
	cmdf0 $60
	note $37 $06
	cmdf0 $60
	note $36 $06
	cmdf0 $60
	note $35 $06
	cmdf0 $60
	note $34 $06
	cmdf0 $60
	note $27 $06
	cmdf0 $60
	note $26 $06
	cmdf0 $60
	note $25 $06
	cmdf0 $60
	note $24 $06
	cmdf0 $60
	note $17 $06
	cmdf0 $60
	note $16 $06
	cmdf0 $60
	note $15 $06
	cmdf0 $60
	note $14 $06
	cmdf0 $40
	note $07 $14
	cmdf0 $47
	note $07 $46
	cmdff

sound9cStart:

sound9cChannel2:
	cmdf0 $80
	vol $9
	cmdf8 $1e
	.db $03 $2c $0d
	cmdf8 $00
	.db $05 $12 $01
	.db $05 $8c $01
	.db $05 $ef $01
	.db $06 $50 $01
	.db $06 $85 $01
	.db $06 $9e $01
	.db $06 $85 $01
	.db $06 $50 $01
	cmdff

sounda0Start:

sounda0Channel2:
	cmdf0 $80
	vol $9
	.db $07 $2b $01
	.db $07 $10 $01
	.db $07 $2b $01
	.db $07 $10 $03
	vol $0
	.db $00 $00 $01
	vol $9
	.db $07 $4d $01
	.db $07 $2b $01
	.db $07 $4d $01
	.db $07 $2b $01
	vol $0
	.db $00 $00 $08
	vol $9
	.db $07 $10 $01
	.db $06 $f4 $01
	.db $07 $10 $01
	.db $06 $f4 $01
	vol $0
	.db $00 $00 $08
	vol $9
	.db $07 $10 $01
	.db $06 $f4 $01
	.db $07 $10 $01
	.db $06 $f4 $01
	cmdff

soundb2Start:

soundb2Channel2:
	duty $02
	vol $3
	note c2  $1c
	note c2  $1c
	note c2  $1c
	note c2  $1c
	note c2  $1c
	cmdff

soundb2Channel7:
	cmdf0 $f0
	note $75 $1c
	cmdf0 $f0
	note $75 $1c
	cmdf0 $f0
	note $75 $1c
	cmdf0 $f0
	note $75 $1c
	cmdf0 $f0
	note $75 $1c
	cmdf0 $f0
	note $67 $01
	note $66 $01
	note $65 $01
	note $64 $01
	note $57 $01
	note $56 $01
	note $55 $01
	note $54 $01
	note $47 $01
	cmdf0 $b0
	note $67 $01
	note $66 $01
	note $65 $01
	note $64 $01
	note $57 $01
	note $56 $01
	note $55 $01
	note $54 $01
	note $47 $01
	cmdf0 $90
	note $67 $01
	note $66 $01
	note $65 $01
	note $64 $01
	note $57 $01
	note $56 $01
	note $55 $01
	note $54 $01
	note $47 $01
	cmdf0 $70
	note $67 $01
	note $66 $01
	note $65 $01
	note $64 $01
	note $57 $01
	note $56 $01
	note $55 $01
	note $54 $01
	note $47 $01
	cmdf0 $50
	note $67 $01
	note $66 $01
	note $65 $01
	note $64 $01
	note $57 $01
	note $56 $01
	note $55 $01
	note $54 $01
	note $47 $01
	cmdf0 $36
	note $67 $01
	note $66 $01
	note $65 $01
	note $64 $01
	note $57 $01
	note $56 $01
	note $55 $01
	note $54 $01
	note $47 $01
	cmdff

soundbbStart:

soundbbChannel7:
	cmdf0 $10
	note $24 $01
	cmdf0 $20
	note $24 $01
	cmdf0 $40
	note $24 $01
	cmdf0 $60
	note $24 $01
	cmdf0 $80
	note $24 $01
	cmdf0 $90
	note $25 $02
	cmdf0 $90
	note $25 $02
	cmdf0 $80
	note $26 $02
	cmdf0 $70
	note $26 $02
	cmdf0 $60
	note $27 $02
	cmdf0 $60
	note $27 $02
	cmdf0 $50
	note $34 $02
	cmdf0 $40
	note $34 $02
	cmdf0 $40
	note $35 $02
	cmdf0 $30
	note $35 $02
	cmdf0 $20
	note $36 $02
	cmdf0 $10
	note $36 $02
	cmdf0 $10
	note $36 $02
	cmdff

soundb7Start:

soundb7Channel2:
	cmdff

soundb7Channel7:
	cmdff

sounda8Start:

sounda8Channel2:
	cmdf0 $34
	vol $9
	.db $06 $46 $04
	vol $8
	.db $06 $46 $04
	vol $7
	.db $06 $46 $04
	vol $6
	.db $06 $46 $04
	vol $5
	.db $06 $46 $04
	vol $4
	.db $06 $46 $04
	vol $3
	.db $06 $46 $04
	vol $2
	.db $06 $46 $04
	vol $1
	.db $06 $46 $04
	cmdff

sounda8Channel7:
	cmdf0 $90
	note $36 $01
	note $34 $01
	note $27 $01
	note $26 $01
	cmdf0 $80
	note $36 $01
	note $34 $01
	note $27 $01
	note $26 $01
	cmdf0 $70
	note $36 $01
	note $34 $01
	note $27 $01
	note $26 $01
	cmdf0 $60
	note $36 $01
	note $34 $01
	note $27 $01
	note $26 $01
	cmdf0 $50
	note $36 $01
	note $34 $01
	note $27 $01
	note $26 $01
	cmdf0 $40
	note $36 $01
	note $34 $01
	note $27 $01
	note $26 $01
	cmdf0 $30
	note $36 $01
	note $34 $01
	note $27 $01
	note $26 $01
	cmdf0 $20
	note $36 $01
	note $34 $01
	note $27 $01
	note $26 $01
	cmdf0 $10
	note $36 $01
	note $34 $01
	note $27 $01
	note $26 $01
	cmdf0 $11
	note $36 $01
	note $34 $01
	note $27 $01
	note $26 $01
	cmdff

soundb8Start:

soundb8Channel2:
	vol $3
	note c2  $14
	note c2  $14
	note c2  $14
	note c2  $14
	note c2  $14
	note c2  $0a
	cmdff

soundb8Channel7:
	cmdf0 $f0
	note $75 $14
	cmdf0 $f0
	note $75 $14
	cmdf0 $f0
	note $75 $14
	cmdf0 $f0
	note $75 $14
	cmdf0 $f0
	note $75 $14
	cmdf0 $f0
	note $74 $0a
	cmdff

sound95Start:

sound95Channel2:
	cmdf0 $d2
	.db $07 $07 $03
	.db $06 $e7 $01
	.db $06 $80 $01
	.db $06 $9e $01
	vol $4
	.db $07 $09 $03
	.db $06 $e9 $01
	.db $06 $82 $01
	.db $06 $a0 $01
	vol $6
	.db $07 $0b $03
	.db $06 $eb $01
	.db $06 $85 $01
	.db $06 $a3 $01
	vol $8
	.db $07 $0f $03
	.db $06 $ef $01
	.db $06 $89 $01
	.db $06 $a7 $01
	vol $9
	.db $07 $14 $03
	.db $06 $f4 $01
	.db $06 $8f $01
	.db $06 $ab $01
	vol $a
	.db $07 $19 $03
	.db $06 $f9 $01
	.db $06 $94 $01
	.db $06 $b2 $01
	vol $a
	.db $07 $1c $03
	.db $06 $ff $01
	.db $06 $99 $01
	.db $06 $b7 $01
	vol $a
	.db $07 $22 $03
	.db $07 $05 $01
	.db $06 $9d $01
	.db $06 $bb $01
	vol $a
	.db $07 $26 $03
	.db $07 $09 $01
	.db $06 $a2 $01
	.db $06 $c0 $01
	vol $a
	.db $07 $2a $03
	.db $07 $0f $01
	.db $06 $a6 $01
	.db $06 $c5 $01
	vol $a
	.db $07 $30 $03
	.db $07 $14 $01
	.db $06 $aa $01
	.db $06 $c9 $01
	vol $a
	.db $07 $35 $03
	.db $07 $18 $01
	.db $06 $af $01
	.db $06 $cf $01
	vol $a
	.db $07 $3b $03
	.db $07 $1e $01
	.db $06 $b3 $01
	.db $06 $d4 $01
	vol $a
	.db $07 $41 $03
	.db $07 $23 $01
	.db $06 $b7 $01
	.db $06 $d9 $01
	vol $a
	.db $07 $44 $03
	.db $07 $23 $01
	.db $06 $b7 $01
	.db $06 $d9 $01
	vol $a
	.db $07 $47 $03
	.db $07 $27 $01
	.db $06 $bb $01
	.db $06 $df $01
	vol $a
	.db $07 $4a $03
	.db $07 $2b $01
	.db $06 $c1 $01
	.db $06 $e4 $01
	vol $a
	.db $07 $4d $03
	.db $07 $32 $01
	.db $06 $c7 $01
	.db $06 $e9 $01
	vol $a
	.db $07 $50 $03
	.db $07 $37 $01
	.db $06 $cb $01
	.db $06 $f0 $01
	vol $a
	.db $07 $53 $03
	.db $07 $3c $01
	.db $06 $d1 $01
	.db $06 $f6 $01
	vol $a
	.db $07 $56 $03
	.db $07 $43 $01
	.db $06 $d7 $01
	.db $06 $fb $01
	vol $a
	.db $07 $59 $03
	.db $07 $48 $01
	.db $06 $dc $01
	.db $07 $03 $01
	vol $a
	.db $07 $5b $03
	.db $07 $4d $01
	.db $06 $e3 $01
	.db $07 $09 $01
	vol $a
	.db $07 $60 $03
	.db $07 $52 $01
	.db $06 $e5 $01
	.db $07 $0a $01
	vol $a
	.db $07 $66 $03
	.db $07 $58 $01
	.db $06 $ea $01
	.db $07 $16 $01
	vol $9
	.db $07 $6b $03
	.db $07 $5e $01
	.db $06 $f5 $01
	.db $07 $1a $01
	vol $8
	.db $07 $73 $03
	.db $07 $62 $01
	.db $06 $fa $01
	.db $07 $26 $01
	vol $7
	.db $07 $79 $03
	.db $07 $6e $01
	.db $07 $05 $01
	.db $07 $2a $01
	vol $5
	.db $07 $7d $03
	.db $07 $72 $01
	.db $07 $0a $01
	.db $07 $36 $01
	vol $3
	.db $07 $85 $03
	.db $07 $7e $01
	.db $07 $15 $01
	.db $07 $3a $01
	vol $1
	.db $07 $8b $03
	.db $07 $82 $01
	.db $07 $1a $01
	.db $07 $46 $01
	cmdff

soundb9Start:

soundb9Channel7:
	cmdf0 $30
	note $67 $07
	cmdf0 $40
	note $66 $05
	cmdf0 $50
	note $65 $05
	cmdf0 $60
	note $64 $05
	cmdf0 $70
	note $57 $05
	cmdf0 $80
	note $56 $05
	cmdf0 $80
	note $55 $05
	cmdf0 $80
	note $47 $05
	cmdf0 $80
	note $45 $05
	cmdf0 $80
	note $44 $05
	cmdf0 $80
	note $37 $05
	cmdf0 $80
	note $36 $05
	cmdf0 $80
	note $35 $05
	cmdf0 $80
	note $34 $08
	cmdf0 $80
	note $27 $08
	cmdf0 $80
	note $26 $09
	cmdf0 $80
	note $25 $09
	cmdf0 $80
	note $24 $0d
	cmdf0 $80
	note $17 $0d
	cmdf0 $80
	note $16 $0f
	cmdf0 $80
	note $15 $0f
	cmdf0 $80
	note $14 $0f
musice61b9:
	cmdf0 $80
	note $07 $0f
	goto musice61b9
	cmdff

soundbcStart:

soundbcChannel7:
	cmdf0 $90
	note $24 $02
	cmdf0 $90
	note $25 $02
	cmdf0 $90
	note $26 $02
	cmdf0 $90
	note $27 $02
	cmdf0 $90
	note $34 $02
	cmdf0 $90
	note $35 $02
	cmdf0 $90
	note $36 $02
	cmdf0 $90
	note $35 $02
	cmdf0 $90
	note $34 $02
	cmdf0 $90
	note $27 $02
	cmdf0 $90
	note $34 $02
	cmdf0 $90
	note $35 $02
	cmdf0 $90
	note $36 $02
	cmdf0 $90
	note $37 $02
	cmdf0 $90
	note $44 $02
	cmdf0 $90
	note $45 $02
	cmdf0 $90
	note $44 $02
	cmdf0 $90
	note $37 $02
	cmdf0 $90
	note $36 $02
	cmdf0 $90
	note $37 $02
	cmdf0 $90
	note $44 $02
	cmdf0 $90
	note $45 $02
	cmdf0 $90
	note $46 $02
	cmdf0 $90
	note $47 $02
	cmdf0 $b0
	note $36 $03
	cmdf0 $90
	note $47 $02
	cmdf0 $90
	note $47 $02
	cmdf0 $90
	note $47 $02
	cmdf0 $90
	note $47 $02
	cmdf0 $90
	note $34 $03
	cmdf0 $90
	note $35 $02
	cmdf0 $90
	note $35 $04
	cmdf0 $90
	note $36 $03
	cmdf0 $90
	note $37 $0a
	cmdf0 $90
	note $44 $0a
	cmdf0 $90
	note $46 $03
	note $47 $03
	note $46 $03
	note $45 $03
	note $46 $03
	note $47 $03
	note $54 $03
	cmdf0 $90
	note $55 $05
	note $47 $05
	note $46 $05
	note $47 $05
	cmdf0 $90
	note $55 $06
	cmdf0 $90
	note $56 $05
	note $55 $05
	note $54 $05
	note $55 $05
	note $56 $05
	cmdf0 $90
	note $57 $05
	cmdf0 $90
	note $64 $05
	note $57 $05
	note $56 $05
	note $57 $05
	note $64 $05
	note $65 $05
	note $66 $14
	cmdff

soundbdStart:

soundbdChannel2:
	cmdff

sound2cStart:

sound2cChannel1:
	duty $01
musice628f:
	vol $6
	note g5  $0f
	note e5  $05
	note c5  $05
	rest $02
	vol $3
	note c5  $03
	vol $6
	note c5  $0f
	vol $3
	note c5  $05
	vol $6
	note g5  $0a
	note e5  $0a
	note c5  $0a
	note fs5 $0f
	note ds5 $05
	note b4  $05
	rest $02
	vol $3
	note b4  $03
	vol $6
	note b4  $0f
	vol $3
	note b4  $05
	vol $6
	note fs5 $0a
	note ds5 $0a
	note b4  $05
	rest $02
	vol $3
	note b4  $03
	vol $6
	note g5  $0f
	note e5  $05
	note c5  $05
	rest $02
	vol $3
	note c5  $03
	vol $6
	note c5  $0a
	vol $3
	note c5  $0a
	vol $6
	note g5  $0a
	note e5  $0a
	note c5  $05
	rest $02
	vol $3
	note c5  $03
	vol $6
	note b4  $05
	note c5  $05
	note cs5 $05
	rest $02
	vol $3
	note cs5 $03
	vol $6
	note cs5 $05
	note ds5 $05
	note e5  $05
	rest $02
	vol $3
	note e5  $03
	vol $6
	note ds5 $05
	note e5  $05
	note f5  $05
	rest $02
	vol $3
	note f5  $03
	vol $6
	note e5  $05
	note f5  $05
	note fs5 $05
	rest $02
	vol $3
	note fs5 $03
	vol $6
	note g5  $0f
	note e5  $05
	note c5  $05
	rest $02
	vol $3
	note c5  $03
	vol $6
	note c5  $0a
	vol $3
	note c5  $0a
	vol $6
	note g5  $0a
	note e5  $0a
	note c5  $05
	rest $02
	vol $3
	note c5  $03
	vol $6
	note fs5 $0f
	note ds5 $05
	note b4  $05
	rest $02
	vol $3
	note b4  $03
	vol $6
	note b4  $0f
	vol $3
	note b4  $05
	vol $6
	note fs5 $0a
	note ds5 $0a
	note b4  $05
	rest $02
	vol $3
	note b4  $03
	vol $6
	note g5  $0a
	note e5  $05
	rest $02
	vol $3
	note e5  $05
	rest $12
	vol $6
	note a5  $0a
	note fs5 $05
	rest $02
	vol $3
	note fs5 $05
	rest $12
	vol $6
	note as5 $05
	note g5  $05
	note b5  $05
	note gs5 $05
	note c6  $05
	note a5  $05
	note cs6 $05
	note as5 $05
	note d6  $05
	note b5  $05
	note ds6 $05
	note c6  $05
	note e6  $05
	note cs6 $05
	note f6  $05
	note d6  $05
	note a5  $0f
	note fs5 $05
	note d5  $05
	rest $02
	vol $3
	note d5  $03
	vol $6
	note d5  $0f
	vol $3
	note d5  $05
	vol $6
	note d5  $0a
	note fs5 $0a
	note a5  $0a
	note gs5 $0f
	note f5  $05
	note cs5 $05
	rest $02
	vol $3
	note cs5 $03
	vol $6
	note cs5 $0a
	vol $3
	note cs5 $0a
	vol $6
	note cs5 $0a
	note f5  $0a
	note gs5 $0a
	note a5  $0f
	note fs5 $05
	note d5  $05
	rest $02
	vol $3
	note d5  $03
	vol $6
	note d5  $14
	note fs5 $0a
	note a5  $0a
	note fs5 $05
	rest $02
	vol $3
	note fs5 $03
	vol $6
	note gs5 $05
	note f5  $05
	note cs5 $05
	rest $02
	vol $3
	note cs5 $03
	vol $6
	note a5  $05
	note fs5 $05
	note d5  $05
	rest $02
	vol $3
	note d5  $03
	vol $6
	note as5 $05
	note g5  $05
	note ds5 $05
	rest $02
	vol $3
	note ds5 $03
	vol $6
	note b5  $05
	note gs5 $05
	note e5  $05
	rest $02
	vol $3
	note e5  $03
	vol $6
	note a5  $0f
	note fs5 $05
	note d5  $05
	rest $02
	vol $3
	note d5  $03
	vol $6
	note d6  $14
	note cs6 $05
	note d6  $05
	note e6  $05
	rest $02
	vol $3
	note e6  $03
	vol $6
	note d6  $05
	rest $02
	vol $3
	note d6  $03
	vol $6
	note cs6 $0f
	note gs5 $05
	note f5  $05
	rest $02
	vol $3
	note f5  $03
	vol $6
	note cs5 $16
	rest $03
	note cs6 $02
	vol $3
	note cs6 $03
	vol $6
	note cs6 $05
	note c6  $05
	note cs6 $05
	note d6  $05
	note ds6 $05
	rest $02
	vol $3
	note ds6 $03
	vol $6
	note ds6 $05
	rest $02
	vol $3
	note ds6 $05
	rest $12
	vol $6
	note e6  $05
	rest $02
	vol $3
	note e6  $03
	vol $6
	note e6  $05
	rest $02
	vol $3
	note e6  $05
	rest $12
	vol $6
	note gs6 $05
	rest $02
	vol $3
	note gs6 $03
	vol $6
	note g6  $05
	rest $02
	vol $3
	note g6  $03
	vol $6
	note fs6 $05
	rest $02
	vol $3
	note fs6 $03
	vol $6
	note f6  $05
	rest $02
	vol $3
	note f6  $03
	vol $6
	note e6  $05
	rest $02
	vol $3
	note e6  $03
	vol $6
	note ds6 $05
	rest $02
	vol $3
	note ds6 $03
	vol $6
	note d6  $05
	rest $02
	vol $3
	note d6  $03
	vol $6
	note cs6 $05
	rest $02
	vol $3
	note cs6 $03
	goto musice628f
	cmdff

sound2cChannel0:
	duty $01
musice64ab:
	vol $6
	note e4  $05
	rest $05
	note e4  $05
	rest $05
	note e4  $05
	rest $05
	note e4  $0f
	rest $05
	note e4  $05
	rest $05
	note e4  $05
	rest $05
	note e4  $05
	rest $05
	note ds4 $05
	rest $05
	note ds4 $05
	rest $05
	note ds4 $05
	rest $05
	note ds4 $0f
	rest $05
	note ds4 $05
	rest $05
	note ds4 $05
	rest $05
	note ds4 $05
	rest $05
	note e4  $05
	rest $05
	note e4  $05
	rest $05
	note e4  $05
	rest $05
	note e4  $0f
	rest $05
	note e4  $05
	rest $05
	note e4  $05
	rest $05
	note e4  $05
	rest $05
	note ds4 $05
	rest $05
	note g4  $05
	vol $3
	note ds4 $05
	vol $6
	note fs4 $05
	vol $3
	note g4  $05
	vol $6
	note f4  $05
	vol $3
	note fs4 $05
	vol $6
	note e4  $05
	vol $3
	note f4  $05
	vol $6
	note ds4 $05
	vol $3
	note e4  $05
	vol $6
	note d4  $05
	vol $3
	note ds4 $05
	vol $6
	note cs4 $05
	vol $3
	note d4  $05
	vol $6
	note e4  $05
	rest $05
	note e4  $05
	rest $05
	note e4  $05
	rest $05
	note e4  $0f
	rest $05
	note e4  $05
	rest $05
	note e4  $05
	rest $05
	note e4  $05
	rest $05
	note ds4 $05
	rest $05
	note ds4 $05
	rest $05
	note ds4 $05
	rest $05
	note ds4 $0f
	rest $05
	note ds4 $05
	rest $05
	note ds4 $05
	rest $05
	note ds4 $05
	rest $05
	note e4  $05
	rest $05
	note e4  $05
	rest $05
	vol $3
	note e4  $05
	rest $05
	vol $1
	note e4  $05
	rest $05
	vol $6
	note ds4 $05
	rest $05
	note ds4 $05
	rest $05
	vol $3
	note ds4 $05
	rest $05
	vol $1
	note ds4 $05
	rest $05
	vol $6
	note e4  $05
	rest $05
	note e4  $05
	vol $3
	note e4  $05
	vol $6
	note f4  $05
	vol $3
	note e4  $05
	vol $6
	note f4  $05
	vol $3
	note f4  $05
	vol $6
	note fs4 $05
	vol $3
	note f4  $05
	vol $6
	note fs4 $05
	vol $3
	note fs4 $05
	vol $6
	note g4  $05
	vol $3
	note fs4 $05
	vol $6
	note g4  $05
	vol $3
	note g4  $05
	vol $6
	note fs4 $05
	rest $05
	note fs4 $05
	rest $05
	note fs4 $05
	rest $05
	note fs4 $0f
	rest $05
	note fs4 $05
	rest $05
	note fs4 $05
	rest $05
	note fs4 $05
	rest $05
	note f4  $05
	rest $05
	note f4  $05
	rest $05
	note f4  $05
	rest $05
	note f4  $0f
	rest $05
	note f4  $05
	rest $05
	note f4  $05
	rest $05
	note f4  $05
	rest $05
	note fs4 $05
	rest $05
	note fs4 $05
	rest $05
	note fs4 $05
	rest $05
	note fs4 $0f
	rest $05
	note fs4 $05
	rest $05
	note fs4 $05
	rest $05
	note fs4 $05
	rest $05
	note f4  $05
	rest $05
	note a4  $05
	vol $3
	note f4  $05
	vol $6
	note gs4 $05
	vol $3
	note a4  $05
	vol $6
	note g4  $05
	vol $3
	note gs4 $05
	vol $6
	note fs4 $05
	vol $3
	note g4  $05
	vol $6
	note f4  $05
	vol $3
	note fs4 $05
	vol $6
	note e4  $05
	vol $3
	note f4  $05
	vol $6
	note ds4 $05
	vol $3
	note e4  $05
	vol $6
	note fs4 $05
	rest $05
	note fs4 $05
	rest $05
	note fs4 $05
	rest $05
	note fs4 $0f
	rest $05
	note fs4 $05
	rest $05
	note fs4 $05
	rest $05
	note fs4 $05
	rest $05
	note f4  $05
	rest $05
	note f4  $05
	rest $05
	note f4  $05
	rest $05
	note f4  $0f
	rest $05
	note f4  $05
	rest $05
	note f4  $05
	rest $05
	note f4  $05
	rest $05
	note fs4 $05
	rest $05
	note fs4 $05
	rest $05
	vol $3
	note fs4 $05
	rest $05
	vol $6
	note fs4 $05
	rest $05
	note g4  $05
	rest $05
	note g4  $05
	rest $05
	vol $3
	note g4  $05
	rest $05
	vol $6
	note g4  $05
	note e4  $05
	note f4  $05
	vol $3
	note f4  $05
	vol $6
	note f4  $05
	vol $3
	note f4  $05
	vol $6
	note a3  $05
	note gs3 $05
	note g3  $05
	note fs3 $05
	note f3  $05
	note e3  $05
	note ds3 $05
	note d3  $05
	note cs3 $05
	note c3  $05
	note b2  $05
	note as2 $05
	goto musice64ab
	cmdff

sound2cChannel4:
musice66c0:
	duty $0e
	note cs3 $05
	duty $0f
	note cs3 $05
	duty $0e
	note g2  $05
	duty $0f
	note g2  $05
	duty $0e
	note cs3 $05
	duty $0f
	note cs3 $05
	duty $0e
	note g2  $05
	duty $0f
	note g2  $05
	duty $0e
	note cs3 $05
	duty $0f
	note cs3 $05
	duty $0e
	note g2  $05
	duty $0f
	note g2  $05
	duty $0e
	note cs3 $05
	duty $0f
	note cs3 $05
	duty $0e
	note g2  $05
	duty $0f
	note g2  $05
	duty $0e
	note c3  $05
	duty $0f
	note c3  $05
	duty $0e
	note fs2 $05
	duty $0f
	note fs2 $05
	duty $0e
	note c3  $05
	duty $0f
	note c3  $05
	duty $0e
	note fs2 $05
	duty $0f
	note fs2 $05
	duty $0e
	note c3  $05
	duty $0f
	note c3  $05
	duty $0e
	note fs2 $05
	duty $0f
	note fs2 $05
	duty $0e
	note c3  $05
	duty $0f
	note c3  $05
	duty $0e
	note fs2 $05
	duty $0f
	note fs2 $05
	duty $0e
	note cs3 $05
	duty $0f
	note cs3 $05
	duty $0e
	note g2  $05
	duty $0f
	note g2  $05
	duty $0e
	note cs3 $05
	duty $0f
	note cs3 $05
	duty $0e
	note g2  $05
	duty $0f
	note g2  $05
	duty $0e
	note cs3 $05
	duty $0f
	note cs3 $05
	duty $0e
	note g2  $05
	duty $0f
	note g2  $05
	duty $0e
	note cs3 $05
	duty $0f
	note cs3 $05
	duty $0e
	note g2  $05
	duty $0f
	note g2  $05
	duty $0e
	note c3  $05
	duty $0f
	note c3  $05
	duty $0e
	note ds3 $05
	duty $0f
	note ds3 $05
	duty $0e
	note d3  $05
	duty $0f
	note d3  $05
	duty $0e
	note cs3 $05
	duty $0f
	note cs3 $05
	duty $0e
	note c3  $05
	duty $0f
	note c3  $05
	duty $0e
	note b2  $05
	duty $0f
	note b2  $05
	duty $0e
	note a2  $05
	note gs2 $05
	note g2  $05
	note fs2 $05
	duty $0e
	note c3  $05
	duty $0f
	note c3  $05
	duty $0e
	note g2  $05
	duty $0f
	note g2  $05
	duty $0e
	note c3  $05
	duty $0f
	note c3  $05
	duty $0e
	note g2  $05
	duty $0f
	note g2  $05
	duty $0e
	note cs3 $05
	duty $0f
	note cs3 $05
	duty $0e
	note g2  $05
	duty $0f
	note g2  $05
	duty $0e
	note cs3 $05
	duty $0f
	note cs3 $05
	duty $0e
	note g2  $05
	duty $0f
	note g2  $05
	duty $0e
	note c3  $05
	duty $0f
	note c3  $05
	duty $0e
	note fs2 $05
	duty $0f
	note fs2 $05
	duty $0e
	note c3  $05
	duty $0f
	note c3  $05
	duty $0e
	note fs2 $05
	duty $0f
	note fs2 $05
	duty $0e
	note c3  $05
	duty $0f
	note c3  $05
	duty $0e
	note fs2 $05
	duty $0f
	note fs2 $05
	duty $0e
	note c3  $05
	duty $0f
	note c3  $05
	duty $0e
	note fs2 $05
	duty $0f
	note fs2 $05
	duty $0e
	note cs3 $05
	duty $0f
	note cs3 $05
	duty $0e
	note cs3 $05
	duty $0f
	note cs3 $05
	rest $14
	duty $0e
	note c3  $05
	duty $0f
	note c3  $05
	duty $0e
	note c3  $05
	duty $0f
	note c3  $05
	rest $14
	duty $0e
	note ds3 $05
	duty $0f
	note ds3 $05
	duty $0e
	note ds3 $05
	duty $0f
	note ds3 $05
	rest $14
	duty $0e
	note e3  $05
	duty $0f
	note e3  $05
	duty $0e
	note e3  $05
	duty $0f
	note e3  $05
	rest $14
	duty $0e
	note ds3 $05
	note d3  $05
	note a2  $05
	duty $0f
	note a2  $05
	duty $0e
	note ds3 $05
	duty $0f
	note ds3 $05
	duty $0e
	note a2  $05
	duty $0f
	note a2  $05
	duty $0e
	note ds3 $05
	duty $0f
	note ds3 $05
	duty $0e
	note a2  $05
	duty $0f
	note a2  $05
	duty $0e
	note ds3 $05
	duty $0f
	note ds3 $05
	duty $0e
	note a2  $05
	duty $0f
	note a2  $05
	duty $0e
	note d3  $05
	note cs3 $05
	note gs2 $05
	duty $0f
	note gs2 $05
	duty $0e
	note d3  $05
	duty $0f
	note d3  $05
	duty $0e
	note gs2 $05
	duty $0f
	note gs2 $05
	duty $0e
	note d3  $05
	duty $0f
	note d3  $05
	duty $0e
	note gs2 $05
	duty $0f
	note gs2 $05
	duty $0e
	note d3  $05
	duty $0f
	note d3  $05
	duty $0e
	note gs2 $05
	duty $0f
	note gs2 $05
	duty $0e
	note ds3 $05
	note d3  $05
	note a2  $05
	duty $0f
	note a2  $05
	duty $0e
	note ds3 $05
	duty $0f
	note ds3 $05
	duty $0e
	note a2  $05
	duty $0f
	note a2  $05
	duty $0e
	note ds3 $05
	duty $0f
	note ds3 $05
	duty $0e
	note a2  $05
	duty $0f
	note a2  $05
	duty $0e
	note ds3 $05
	duty $0f
	note ds3 $05
	duty $0e
	note a2  $05
	duty $0f
	note a2  $05
	duty $0e
	note d3  $05
	duty $0f
	note d3  $05
	duty $0e
	note f3  $05
	duty $0f
	note f3  $05
	duty $0e
	note e3  $05
	duty $0f
	note e3  $05
	duty $0e
	note ds3 $05
	duty $0f
	note ds3 $05
	duty $0e
	note d3  $05
	duty $0f
	note d3  $05
	duty $0e
	note cs3 $05
	duty $0f
	note cs3 $05
	duty $0e
	note c3  $05
	duty $0f
	note c3  $05
	duty $0e
	note b2  $05
	duty $0f
	note b2  $05
	duty $0e
	note ds3 $05
	note d3  $05
	note a2  $05
	duty $0f
	note a2  $05
	duty $0e
	note ds3 $05
	duty $0f
	note ds3 $05
	duty $0e
	note a2  $05
	duty $0f
	note a2  $05
	duty $0e
	note ds3 $05
	duty $0f
	note ds3 $05
	duty $0e
	note a2  $05
	duty $0f
	note a2  $05
	duty $0e
	note ds3 $05
	duty $0f
	note ds3 $05
	duty $0e
	note a2  $05
	duty $0f
	note a2  $05
	duty $0e
	note d3  $05
	note cs3 $05
	note gs2 $05
	duty $0f
	note gs2 $05
	duty $0e
	note d3  $05
	duty $0f
	note d3  $05
	duty $0e
	note gs2 $05
	duty $0f
	note gs2 $05
	duty $0e
	note d3  $05
	duty $0f
	note d3  $05
	duty $0e
	note gs2 $05
	duty $0f
	note gs2 $05
	duty $0e
	note d3  $05
	duty $0f
	note d3  $05
	duty $0e
	note gs2 $05
	duty $0f
	note gs2 $05
	duty $0e
	note ds3 $05
	duty $0f
	note ds3 $05
	duty $0e
	note ds3 $05
	duty $0f
	note ds3 $05
	rest $14
	duty $0e
	note e3  $05
	duty $0f
	note e3  $05
	duty $0e
	note e3  $05
	duty $0f
	note e3  $05
	rest $0a
	duty $0e
	note e3  $05
	duty $0f
	note e3  $05
	duty $0e
	note f3  $05
	duty $0f
	note f3  $05
	duty $0e
	note f3  $05
	duty $0f
	note f3  $05
	duty $0e
	note f3  $05
	note e3  $05
	note ds3 $05
	note d3  $05
	note cs3 $05
	note c3  $05
	note b2  $05
	note as2 $05
	note a2  $05
	note gs2 $05
	note g2  $05
	note fs2 $05
	goto musice66c0
	cmdff

sound2cChannel6:
musice6a48:
	vol $3
	note $2a $0a
	vol $2
	note $2e $0a
	vol $3
	note $2a $0a
	vol $2
	note $2e $0a
	vol $3
	note $2a $0a
	vol $2
	note $2e $0a
	vol $3
	note $2a $0a
	vol $2
	note $2e $0a
	vol $3
	note $2a $0a
	vol $2
	note $2e $0a
	vol $3
	note $2a $0a
	vol $2
	note $2e $0a
	vol $3
	note $2a $0a
	vol $2
	note $2e $0a
	vol $3
	note $2a $0a
	vol $2
	note $2e $0a
	vol $3
	note $2a $0a
	vol $2
	note $2e $0a
	vol $3
	note $2a $0a
	vol $2
	note $2e $0a
	vol $3
	note $2a $0a
	vol $2
	note $2e $0a
	vol $3
	note $2a $0a
	vol $2
	note $2e $0a
	vol $3
	note $2a $05
	vol $3
	note $2a $05
	vol $2
	note $2e $05
	vol $3
	note $2a $05
	vol $3
	note $2a $05
	vol $3
	note $2a $05
	vol $2
	note $2e $05
	vol $3
	note $2a $05
	vol $3
	note $2a $05
	vol $3
	note $2a $05
	vol $2
	note $2e $05
	vol $3
	note $2a $05
	vol $4
	note $26 $05
	note $26 $05
	note $26 $05
	note $26 $05
	vol $3
	note $2a $0a
	vol $2
	note $2e $0a
	vol $3
	note $2a $0a
	vol $2
	note $2e $0a
	vol $3
	note $2a $0a
	vol $2
	note $2e $0a
	vol $3
	note $2a $0a
	vol $2
	note $2e $0a
	vol $3
	note $2a $0a
	vol $2
	note $2e $0a
	vol $3
	note $2a $0a
	vol $2
	note $2e $0a
	vol $3
	note $2a $0a
	vol $2
	note $2e $0a
	vol $3
	note $2a $0a
	vol $2
	note $2e $0a
	vol $3
	note $2a $0a
	vol $2
	note $2e $0a
	vol $3
	note $2a $0a
	vol $2
	note $2e $0a
	vol $3
	note $2a $0a
	vol $2
	note $2e $0a
	vol $3
	note $2a $0a
	vol $2
	note $2e $0a
	vol $3
	note $2a $05
	vol $3
	note $2a $05
	vol $2
	note $2e $05
	vol $3
	note $2a $05
	vol $3
	note $2a $05
	vol $3
	note $2a $05
	vol $2
	note $2e $05
	vol $3
	note $2a $05
	vol $3
	note $2a $05
	vol $3
	note $2a $05
	vol $2
	note $2e $05
	vol $3
	note $2a $05
	vol $4
	note $26 $05
	note $26 $05
	note $26 $05
	note $26 $05
	vol $3
	note $2a $0a
	vol $2
	note $2e $0a
	vol $3
	note $2a $0a
	vol $2
	note $2e $0a
	vol $3
	note $2a $0a
	vol $2
	note $2e $0a
	vol $3
	note $2a $0a
	vol $2
	note $2e $0a
	vol $3
	note $2a $0a
	vol $2
	note $2e $0a
	vol $3
	note $2a $0a
	vol $2
	note $2e $0a
	vol $3
	note $2a $0a
	vol $2
	note $2e $0a
	vol $3
	note $2a $0a
	vol $2
	note $2e $0a
	vol $3
	note $2a $0a
	vol $2
	note $2e $0a
	vol $3
	note $2a $0a
	vol $2
	note $2e $0a
	vol $3
	note $2a $0a
	vol $2
	note $2e $0a
	vol $3
	note $2a $0a
	vol $2
	note $2e $0a
	vol $3
	note $2a $05
	vol $3
	note $2a $05
	vol $2
	note $2e $05
	vol $3
	note $2a $05
	vol $3
	note $2a $05
	vol $3
	note $2a $05
	vol $2
	note $2e $05
	vol $3
	note $2a $05
	vol $3
	note $2a $05
	vol $3
	note $2a $05
	vol $2
	note $2e $05
	vol $3
	note $2a $05
	vol $4
	note $26 $05
	note $26 $05
	note $26 $05
	note $26 $05
	vol $4
	vol $3
	note $2a $0a
	vol $2
	note $2e $0a
	vol $3
	note $2a $0a
	vol $2
	note $2e $0a
	vol $3
	note $2a $0a
	vol $2
	note $2e $0a
	vol $3
	note $2a $0a
	vol $2
	note $2e $0a
	vol $3
	note $2a $0a
	vol $2
	note $2e $0a
	vol $3
	note $2a $0a
	vol $2
	note $2e $0a
	vol $3
	note $2a $0a
	vol $2
	note $2e $0a
	vol $3
	note $2a $0a
	vol $2
	note $2e $0a
	vol $3
	note $2a $05
	vol $3
	note $2a $05
	vol $2
	note $2e $05
	vol $3
	note $2a $05
	vol $3
	note $2a $05
	vol $3
	note $2a $05
	vol $2
	note $2e $05
	vol $3
	note $2a $05
	vol $3
	note $2a $05
	vol $3
	note $2a $05
	vol $2
	note $2e $05
	vol $3
	note $2a $05
	vol $3
	note $2a $05
	vol $3
	note $2a $05
	vol $2
	note $2e $05
	vol $3
	note $2a $05
	vol $3
	note $2a $05
	vol $3
	note $2a $05
	vol $2
	note $2e $05
	vol $3
	note $2a $05
	vol $3
	note $2a $05
	vol $3
	note $2a $05
	vol $3
	note $2a $05
	vol $3
	note $2a $05
	vol $3
	note $2a $05
	vol $3
	note $2a $05
	vol $3
	note $2a $05
	vol $3
	note $2a $05
	vol $3
	note $2a $05
	vol $3
	note $2a $05
	vol $3
	note $2a $05
	vol $3
	note $2a $05
	goto musice6a48
	cmdff

sound32Start:

sound32Channel1:
	vibrato $e1
	env $0 $00
	duty $02
musice6c42:
	vol $6
	note gs3 $3c
	vibrato $01
	env $0 $00
	vol $3
	note gs3 $0c
	vibrato $e1
	env $0 $00
	vol $6
	note gs3 $08
	note a3  $08
	note as3 $08
	note b3  $48
	vibrato $01
	env $0 $00
	vol $3
	note b3  $18
	vibrato $e1
	env $0 $00
	vol $6
	note gs4 $3c
	vibrato $01
	env $0 $00
	vol $3
	note gs4 $0c
	vibrato $e1
	env $0 $00
	vol $6
	note gs4 $08
	note a4  $08
	note as4 $08
	note b4  $48
	vibrato $01
	env $0 $00
	vol $3
	note b4  $18
	vibrato $e1
	env $0 $00
	vol $6
	note as3 $3c
	vibrato $01
	env $0 $00
	vol $3
	note as3 $0c
	vibrato $e1
	env $0 $00
	vol $6
	note as3 $08
	note b3  $08
	note c4  $08
	note cs4 $48
	vibrato $01
	env $0 $00
	vol $3
	note cs4 $18
	vibrato $e1
	env $0 $00
	vol $6
	note as4 $3c
	vibrato $01
	env $0 $00
	vol $3
	note as4 $0c
	vibrato $e1
	env $0 $00
	vol $6
	note as4 $08
	note b4  $08
	note c5  $08
	note cs5 $48
	vibrato $01
	env $0 $00
	vol $3
	note cs5 $18
	vibrato $e1
	env $0 $00
	vol $6
	note ds5 $12
	note d5  $06
	rest $03
	vol $3
	note d5  $06
	rest $03
	vol $1
	note d5  $06
	rest $06
	vol $6
	note cs5 $12
	note c5  $06
	rest $03
	vol $3
	note c5  $06
	rest $03
	vol $1
	note c5  $06
	rest $06
	vol $6
	note ds5 $06
	rest $03
	vol $3
	note ds5 $03
	vol $6
	note ds5 $06
	note d5  $06
	rest $03
	vol $3
	note d5  $06
	rest $03
	vol $1
	note d5  $06
	rest $06
	vol $6
	note cs5 $03
	rest $03
	vol $6
	note cs5 $03
	rest $03
	vol $6
	note cs5 $06
	note c5  $06
	rest $03
	vol $3
	note c5  $06
	rest $03
	vol $1
	note c5  $06
	rest $06
	vol $6
	note e5  $12
	note ds5 $06
	vol $4
	note c5  $06
	note b4  $06
	note as4 $06
	note a4  $06
	vol $6
	note d5  $12
	note cs5 $06
	vol $4
	note fs4 $06
	note f4  $06
	note e4  $06
	note ds4 $06
	vol $6
	note e5  $06
	rest $03
	vol $3
	note e5  $03
	vol $6
	note e5  $06
	note ds5 $06
	vol $4
	note cs5 $06
	note c5  $06
	note b4  $06
	note as4 $06
	vol $6
	note d5  $03
	rest $03
	vol $6
	note d5  $03
	rest $03
	vol $6
	note d5  $06
	note cs5 $06
	vol $4
	note fs4 $04
	note g4  $04
	note gs4 $04
	note a4  $04
	note as4 $04
	note b4  $04
	vol $6
	note d5  $06
	rest $03
	vol $3
	note d5  $06
	rest $03
	vol $6
	note as5 $06
	note a5  $30
	note f5  $18
	note cs5 $06
	note c5  $06
	note b4  $06
	note as4 $06
	note a4  $06
	note gs4 $06
	note g4  $06
	note fs4 $06
	note f4  $06
	note e4  $06
	note ds4 $06
	note d4  $06
	note cs4 $06
	note c4  $06
	note b3  $06
	note as3 $06
	goto musice6c42
	cmdff

sound32Channel0:
	vibrato $e1
	env $0 $00
	duty $02
musice6da9:
	vol $6
	note d3  $3c
	vibrato $01
	env $0 $00
	vol $3
	note d3  $0c
	vibrato $e1
	env $0 $00
	vol $6
	note d3  $08
	note ds3 $08
	note e3  $08
	note f3  $06
	note b2  $06
	vol $0
	note b2  $03
	vol $3
	note b2  $03
	vol $6
	note f3  $06
	note b2  $06
	vol $0
	note b2  $03
	vol $3
	note b2  $03
	vol $6
	note f3  $06
	note b2  $06
	vol $0
	note b2  $03
	vol $3
	note b2  $03
	vol $6
	note f3  $06
	note b2  $06
	note f2  $06
	note b2  $06
	note f3  $06
	note b2  $06
	note f2  $06
	note d3  $3c
	vibrato $01
	env $0 $00
	vol $3
	note d3  $0c
	vibrato $e1
	env $0 $00
	vol $6
	note d3  $08
	note ds3 $08
	note e3  $08
	note f3  $06
	note b2  $06
	vol $0
	note b2  $03
	vol $3
	note b2  $03
	vol $6
	note f3  $06
	note b2  $06
	vol $0
	note b2  $03
	vol $3
	note b2  $03
	vol $6
	note f3  $06
	note b2  $06
	vol $0
	note b2  $03
	vol $3
	note b2  $03
	vol $6
	note f3  $06
	note b2  $06
	note f2  $06
	note b2  $06
	note f3  $06
	note b2  $06
	note f2  $06
	note e3  $3c
	vibrato $01
	env $0 $00
	vol $3
	note e3  $0c
	vibrato $e1
	env $0 $00
	vol $6
	note e3  $08
	note f3  $08
	note fs3 $08
	note g3  $06
	note cs3 $06
	vol $0
	note cs3 $03
	vol $3
	note cs3 $03
	vol $6
	note g3  $06
	note cs3 $06
	vol $0
	note cs3 $03
	vol $3
	note cs3 $03
	vol $6
	note g3  $06
	note cs3 $06
	vol $0
	note cs3 $03
	vol $3
	note cs3 $03
	vol $6
	note g3  $06
	note cs3 $06
	note g2  $06
	note cs3 $06
	note g3  $06
	note cs3 $06
	note g2  $06
	note e3  $3c
	vibrato $01
	env $0 $00
	vol $3
	note e3  $0c
	vibrato $e1
	env $0 $00
	vol $6
	note e3  $08
	note f3  $08
	note fs3 $08
	note g3  $06
	note cs3 $06
	vol $0
	note cs3 $03
	vol $3
	note cs3 $03
	vol $6
	note g3  $06
	note cs3 $06
	vol $0
	note cs3 $03
	vol $3
	note cs3 $03
	vol $6
	note g3  $06
	note cs3 $06
	vol $0
	note cs3 $03
	vol $3
	note cs3 $03
	vol $6
	note g3  $06
	note cs3 $06
	note g2  $06
	note cs3 $06
	note g3  $06
	note cs4 $06
	note g4  $06
	note as4 $12
	note a4  $06
	note as3 $06
	note a3  $06
	note gs3 $06
	note g3  $06
	note gs4 $12
	note g4  $06
	note gs3 $06
	note g3  $06
	note fs3 $06
	note f3  $06
	note as4 $06
	vol $0
	note as4 $03
	vol $3
	note as4 $03
	vol $6
	note as4 $06
	note a4  $06
	note as3 $06
	note a3  $06
	note gs3 $06
	note g3  $06
	note gs4 $03
	vol $0
	note gs4 $03
	vol $6
	note gs4 $03
	vol $0
	note gs4 $03
	vol $6
	note gs4 $06
	note g4  $06
	note gs3 $06
	note g3  $06
	note fs3 $06
	note f3  $06
	note b4  $12
	note as4 $06
	note b3  $06
	note as3 $06
	note a3  $06
	note gs3 $06
	note a4  $12
	note gs4 $06
	note a3  $06
	note gs3 $06
	note g3  $06
	note fs3 $06
	note b4  $06
	vol $0
	note b4  $03
	vol $3
	note b4  $03
	vol $6
	note b4  $06
	note as4 $06
	note b3  $06
	note as3 $06
	note a3  $06
	note gs3 $06
	note a4  $03
	vol $0
	note a4  $03
	vol $6
	note a4  $03
	vol $0
	note a4  $03
	vol $6
	note a4  $06
	note gs4 $06
	note a3  $04
	note as3 $04
	note b3  $04
	note c4  $04
	note cs4 $04
	note d4  $04
	note ds4 $04
	note e4  $04
	note f4  $04
	note fs4 $04
	note g4  $04
	note gs4 $04
	note a4  $04
	note as4 $04
	note b4  $04
	note c5  $04
	note cs5 $04
	note d5  $04
	note ds5 $04
	note e5  $04
	note f5  $04
	note fs5 $04
	note g5  $04
	note gs5 $04
	vol $6
	note a5  $60
	vol $6
	note as5 $04
	vol $6
	note b5  $04
	vol $5
	note c6  $04
	vol $5
	note cs6 $04
	vol $4
	note d6  $04
	vol $4
	note e6  $04
	goto musice6da9
	cmdff

sound32Channel4:
musice6f81:
	duty $12
	note gs2 $04
	duty $0f
	note gs2 $02
	duty $12
	note gs2 $04
	duty $0f
	note gs2 $08
	duty $12
	note gs2 $04
	duty $0f
	note gs2 $02
	duty $12
	note gs2 $04
	duty $0f
	note gs2 $08
	duty $12
	note gs2 $04
	duty $0f
	note gs2 $02
	duty $12
	note gs2 $04
	duty $0f
	note gs2 $08
	duty $12
	note gs2 $04
	duty $0f
	note gs2 $02
	duty $12
	note gs2 $04
	duty $0f
	note gs2 $08
	duty $12
	note gs2 $04
	duty $0f
	note gs2 $08
	duty $12
	note d2  $04
	duty $0f
	note d2  $08
	duty $12
	note gs2 $04
	duty $0f
	note gs2 $02
	duty $12
	note gs2 $04
	duty $0f
	note gs2 $08
	duty $12
	note gs2 $04
	duty $0f
	note gs2 $02
	duty $12
	note gs2 $04
	duty $0f
	note gs2 $08
	duty $12
	note gs2 $04
	duty $0f
	note gs2 $02
	duty $12
	note gs2 $04
	duty $0f
	note gs2 $08
	duty $12
	note gs2 $04
	duty $0f
	note gs2 $02
	duty $12
	note gs2 $04
	duty $0f
	note gs2 $08
	duty $12
	note gs2 $04
	duty $0f
	note gs2 $02
	duty $12
	note d2  $04
	duty $0f
	note d2  $02
	duty $12
	note gs2 $04
	duty $0f
	note gs2 $02
	duty $12
	note d2  $04
	duty $0f
	note d2  $02
	duty $12
	note gs2 $04
	duty $0f
	note gs2 $02
	duty $12
	note gs2 $04
	duty $0f
	note gs2 $08
	duty $12
	note gs2 $04
	duty $0f
	note gs2 $02
	duty $12
	note gs2 $04
	duty $0f
	note gs2 $08
	duty $12
	note gs2 $04
	duty $0f
	note gs2 $02
	duty $12
	note gs2 $04
	duty $0f
	note gs2 $08
	duty $12
	note gs2 $04
	duty $0f
	note gs2 $02
	duty $12
	note gs2 $04
	duty $0f
	note gs2 $08
	duty $12
	note gs2 $04
	duty $0f
	note gs2 $08
	duty $12
	note d2  $04
	duty $0f
	note d2  $08
	duty $12
	note gs2 $04
	duty $0f
	note gs2 $02
	duty $12
	note gs2 $04
	duty $0f
	note gs2 $08
	duty $12
	note gs2 $04
	duty $0f
	note gs2 $02
	duty $12
	note gs2 $04
	duty $0f
	note gs2 $08
	duty $12
	note gs2 $04
	duty $0f
	note gs2 $02
	duty $12
	note gs2 $04
	duty $0f
	note gs2 $08
	duty $12
	note gs2 $04
	duty $0f
	note gs2 $02
	duty $12
	note gs2 $04
	duty $0f
	note gs2 $08
	duty $12
	note gs2 $04
	duty $0f
	note gs2 $02
	duty $12
	note d2  $04
	duty $0f
	note d2  $02
	duty $12
	note gs2 $04
	duty $0f
	note gs2 $02
	duty $12
	note d2  $04
	duty $0f
	note d2  $02
	duty $12
	note as2 $04
	duty $0f
	note as2 $02
	duty $12
	note as2 $04
	duty $0f
	note as2 $08
	duty $12
	note as2 $04
	duty $0f
	note as2 $02
	duty $12
	note as2 $04
	duty $0f
	note as2 $08
	duty $12
	note as2 $04
	duty $0f
	note as2 $02
	duty $12
	note as2 $04
	duty $0f
	note as2 $08
	duty $12
	note as2 $04
	duty $0f
	note as2 $02
	duty $12
	note as2 $04
	duty $0f
	note as2 $08
	duty $12
	note as2 $04
	duty $0f
	note as2 $08
	duty $12
	note e2  $04
	duty $0f
	note e2  $08
	duty $12
	note as2 $04
	duty $0f
	note as2 $02
	duty $12
	note as2 $04
	duty $0f
	note as2 $08
	duty $12
	note as2 $04
	duty $0f
	note as2 $02
	duty $12
	note as2 $04
	duty $0f
	note as2 $08
	duty $12
	note as2 $04
	duty $0f
	note as2 $02
	duty $12
	note as2 $04
	duty $0f
	note as2 $08
	duty $12
	note as2 $04
	duty $0f
	note as2 $02
	duty $12
	note as2 $04
	duty $0f
	note as2 $08
	duty $12
	note as2 $04
	duty $0f
	note as2 $02
	duty $12
	note e2  $04
	duty $0f
	note e2  $02
	duty $12
	note as2 $04
	duty $0f
	note as2 $02
	duty $12
	note e2  $04
	duty $0f
	note e2  $02
	duty $12
	note as2 $04
	duty $0f
	note as2 $02
	duty $12
	note as2 $04
	duty $0f
	note as2 $08
	duty $12
	note as2 $04
	duty $0f
	note as2 $02
	duty $12
	note as2 $04
	duty $0f
	note as2 $08
	duty $12
	note as2 $04
	duty $0f
	note as2 $02
	duty $12
	note as2 $04
	duty $0f
	note as2 $08
	duty $12
	note as2 $04
	duty $0f
	note as2 $02
	duty $12
	note as2 $04
	duty $0f
	note as2 $08
	duty $12
	note as2 $04
	duty $0f
	note as2 $08
	duty $12
	note e2  $04
	duty $0f
	note e2  $08
	duty $12
	note as2 $04
	duty $0f
	note as2 $02
	duty $12
	note as2 $04
	duty $0f
	note as2 $08
	duty $12
	note as2 $04
	duty $0f
	note as2 $02
	duty $12
	note as2 $04
	duty $0f
	note as2 $08
	duty $12
	note as2 $04
	duty $0f
	note as2 $02
	duty $12
	note as2 $04
	duty $0f
	note as2 $08
	duty $12
	note as2 $04
	duty $0f
	note as2 $02
	duty $12
	note as2 $04
	duty $0f
	note as2 $08
	duty $12
	note as2 $04
	duty $0f
	note as2 $02
	duty $12
	note e2  $04
	duty $0f
	note e2  $02
	duty $12
	note as2 $04
	duty $0f
	note as2 $02
	duty $12
	note e2  $04
	duty $0f
	note e2  $02
	duty $12
	note e3  $12
	note ds3 $06
	duty $0f
	note ds3 $18
	duty $12
	note d3  $12
	note cs3 $06
	duty $0f
	note cs3 $18
	duty $12
	note e3  $06
	duty $0f
	note e3  $06
	duty $12
	note e3  $06
	note ds3 $06
	duty $0f
	note ds3 $18
	duty $12
	note d3  $03
	duty $0f
	note d3  $03
	duty $12
	note d3  $03
	duty $0f
	note d3  $03
	duty $12
	note d3  $06
	note cs3 $06
	note f2  $06
	note e2  $06
	note ds2 $06
	note d2  $06
	note cs2 $06
	note d2  $06
	note ds2 $06
	note e2  $06
	note f2  $06
	note e2  $06
	note ds2 $06
	note cs2 $06
	note d2  $06
	note ds2 $06
	note e2  $06
	note fs2 $06
	note g2  $06
	note gs2 $06
	note a2  $06
	note as2 $06
	note b2  $06
	note c3  $06
	note cs3 $06
	note b2  $06
	note as2 $06
	note a2  $06
	note gs2 $06
	note g2  $06
	note gs2 $06
	note a2  $06
	note gs2 $06
	note g2  $06
	note fs2 $04
	note g2  $04
	note gs2 $04
	note a2  $04
	note as2 $04
	note b2  $04
	note ds2 $06
	duty $0f
	note ds2 $0c
	duty $12
	note cs3 $06
	note c3  $30
	note d4  $06
	note cs4 $06
	note c4  $06
	note b3  $06
	note as3 $06
	note a3  $06
	note gs3 $06
	note g3  $06
	note fs3 $06
	note f3  $06
	note e3  $06
	note ds3 $06
	note d3  $06
	note cs3 $06
	note c3  $06
	note b2  $06
	note as2 $04
	note a2  $04
	note gs2 $04
	note ds2 $04
	note d2  $04
	note b1  $04
	goto musice6f81
	cmdff

sound32Channel6:
musice7305:
	vol $5
	note $24 $18
	vol $b
	note $28 $01
	vol $3
	note $27 $17
	vol $5
	note $24 $18
	vol $b
	note $28 $01
	vol $3
	note $27 $17
	vol $5
	note $24 $18
	vol $b
	note $28 $01
	vol $3
	note $27 $17
	vol $5
	note $24 $18
	vol $b
	note $28 $01
	vol $3
	note $27 $0b
	vol $6
	note $28 $01
	vol $3
	note $27 $03
	vol $6
	note $28 $01
	vol $3
	note $27 $03
	vol $6
	note $28 $01
	vol $3
	note $27 $03
	vol $5
	note $24 $18
	vol $b
	note $28 $01
	vol $3
	note $27 $17
	vol $5
	note $24 $18
	vol $b
	note $28 $01
	vol $3
	note $27 $17
	vol $5
	note $24 $18
	vol $b
	note $28 $01
	vol $3
	note $27 $17
	vol $5
	note $24 $18
	vol $b
	note $28 $01
	vol $3
	note $27 $0b
	vol $6
	note $28 $01
	vol $3
	note $27 $03
	vol $6
	note $28 $01
	vol $3
	note $27 $03
	vol $6
	note $28 $01
	vol $3
	note $27 $03
	vol $5
	note $24 $18
	vol $b
	note $28 $01
	vol $3
	note $27 $17
	vol $5
	note $24 $18
	vol $b
	note $28 $01
	vol $3
	note $27 $17
	vol $5
	note $24 $18
	vol $b
	note $28 $01
	vol $3
	note $27 $17
	vol $5
	note $24 $18
	vol $b
	note $28 $01
	vol $3
	note $27 $0b
	vol $6
	note $28 $01
	vol $3
	note $27 $03
	vol $6
	note $28 $01
	vol $3
	note $27 $03
	vol $6
	note $28 $01
	vol $3
	note $27 $03
	vol $5
	note $24 $18
	vol $b
	note $28 $01
	vol $3
	note $27 $17
	vol $5
	note $24 $18
	vol $b
	note $28 $01
	vol $3
	note $27 $17
	vol $5
	note $24 $18
	vol $b
	note $28 $01
	vol $3
	note $27 $17
	vol $5
	note $24 $18
	vol $b
	note $28 $01
	vol $3
	note $27 $0b
	vol $6
	note $28 $01
	vol $3
	note $27 $03
	vol $6
	note $28 $01
	vol $3
	note $27 $03
	vol $6
	note $28 $01
	vol $3
	note $27 $03
	vol $5
	note $24 $18
	vol $b
	note $28 $01
	vol $3
	note $27 $17
	vol $5
	note $24 $18
	vol $b
	note $28 $01
	vol $3
	note $27 $0b
	vol $6
	note $28 $01
	vol $3
	note $27 $03
	vol $6
	note $28 $01
	vol $3
	note $27 $03
	vol $6
	note $28 $01
	vol $3
	note $27 $03
	vol $5
	note $24 $18
	vol $b
	note $28 $01
	vol $3
	note $27 $17
	vol $5
	note $24 $18
	vol $b
	note $28 $01
	vol $3
	note $27 $0b
	vol $6
	note $28 $01
	vol $3
	note $27 $03
	vol $6
	note $28 $01
	vol $3
	note $27 $03
	vol $6
	note $28 $01
	vol $3
	note $27 $03
	vol $5
	note $24 $18
	vol $b
	note $28 $01
	vol $3
	note $27 $17
	vol $5
	note $24 $18
	vol $b
	note $28 $01
	vol $3
	note $27 $0b
	vol $6
	note $28 $01
	vol $3
	note $27 $03
	vol $6
	note $28 $01
	vol $3
	note $27 $03
	vol $6
	note $28 $01
	vol $3
	note $27 $03
	vol $5
	note $24 $18
	vol $b
	note $28 $01
	vol $3
	note $27 $17
	vol $5
	note $24 $18
	vol $b
	note $28 $01
	vol $3
	note $27 $05
	vol $8
	note $28 $01
	vol $3
	note $27 $05
	vol $8
	note $28 $01
	vol $3
	note $27 $05
	vol $8
	note $28 $01
	vol $3
	note $27 $05
	vol $5
	note $24 $12
	vol $8
	note $28 $01
	vol $3
	note $27 $05
	vol $6
	note $26 $0c
	vol $6
	note $28 $01
	vol $3
	note $27 $03
	vol $6
	note $28 $01
	vol $3
	note $27 $03
	vol $6
	note $28 $01
	vol $3
	note $27 $03
	vol $8
	note $28 $01
	vol $3
	note $27 $05
	vol $6
	note $26 $0c
	vol $8
	note $28 $01
	vol $3
	note $27 $05
	vol $6
	note $26 $0c
	vol $6
	note $28 $01
	vol $3
	note $27 $03
	vol $6
	note $28 $01
	vol $3
	note $27 $03
	vol $6
	note $28 $01
	vol $3
	note $27 $03
	vol $8
	note $28 $01
	vol $3
	note $27 $05
	vol $8
	note $28 $01
	vol $3
	note $27 $05
	vol $8
	note $28 $01
	vol $3
	note $27 $05
	vol $8
	note $28 $01
	vol $3
	note $27 $05
	vol $6
	note $26 $0c
	vol $6
	note $28 $01
	vol $3
	note $27 $05
	vol $6
	note $28 $01
	vol $3
	note $27 $05
	vol $6
	note $28 $01
	vol $3
	note $27 $05
	vol $6
	note $28 $01
	vol $3
	note $27 $05
	vol $6
	note $28 $01
	vol $3
	note $27 $05
	vol $6
	note $28 $01
	vol $3
	note $27 $05
	vol $6
	note $28 $01
	vol $3
	note $27 $05
	vol $6
	note $28 $01
	vol $3
	note $27 $05
	vol $6
	note $28 $01
	vol $3
	note $27 $01
	vol $6
	note $28 $01
	vol $3
	note $27 $01
	vol $7
	note $28 $01
	vol $3
	note $27 $01
	vol $8
	note $28 $01
	vol $3
	note $27 $01
	vol $9
	note $28 $01
	vol $3
	note $27 $01
	vol $a
	note $28 $01
	vol $3
	note $27 $01
	goto musice7305
	cmdff

sound06Channel1:
	vibrato $d1
	env $0 $00
	duty $02
	vol $5
	note d7  $02
	vol $4
	note b6  $02
	vol $4
	note g6  $02
	note f6  $02
	vol $4
	note d6  $02
	note b5  $02
	vol $4
	note a5  $02
	vol $4
	note f5  $02
	vol $4
	note d5  $02
	vol $3
	note b4  $02
	vol $3
	note g4  $02
	vol $3
	note f4  $01
	rest $01
	duty $01
	vol $6
	note b4  $04
	rest $01
	vol $3
	note b4  $03
	vol $6
	note b4  $04
	rest $01
	vol $3
	note b4  $03
	vol $6
	note c5  $04
	rest $01
	vol $3
	note c5  $03
	vol $6
	note d5  $10
	vol $3
	note b4  $04
	note d5  $04
	vol $6
	note g5  $10
	note gs5 $04
	note a5  $04
	note as5 $0c
	vol $3
	note fs5 $04
	vol $6
	note gs5 $04
	vol $3
	note as5 $04
	vol $6
	note fs5 $08
	note cs5 $04
	vol $3
	note fs5 $04
	vol $6
	note f5  $04
	vol $3
	note cs5 $04
	vol $6
	note ds5 $14
	note f5  $02
	note fs5 $02
	note gs5 $0c
	vol $3
	note ds5 $04
	vol $6
	note gs5 $04
	note as5 $04
	note b5  $08
	note a5  $04
	vol $3
	note b5  $04
	vol $6
	note g5  $04
	vol $3
	note a5  $04
	vol $6
	note d6  $08
	note cs6 $04
	vol $3
	note g5  $04
	vol $6
	note b5  $04
	vol $3
	note d6  $04
	vol $6
	note cs6 $08
	note b5  $04
	vol $3
	note cs6 $04
	vol $6
	note a5  $04
	vol $3
	note b5  $04
	vol $6
	note e6  $08
	note cs6 $04
	note a5  $04
	note gs5 $04
	note e5  $04
	note b4  $04
	note cs5 $04
	note ds5 $04
	note fs5 $04
	note b5  $04
	note cs6 $04
	note ds6 $04
	note e6  $04
	note ds6 $04
	note e6  $04
	note ds6 $04
	note e6  $04
	note fs6 $27
	rest $01
	vibrato $01
	env $0 $00
	vol $3
	note fs6 $04
	rest $01
	vol $2
	note fs6 $04
	rest $01
	vol $1
	note fs6 $04
	cmdff

sound06Channel0:
	vol $0
	note gs3 $03
	vibrato $d1
	env $0 $00
	duty $02
	vol $3
	note d7  $02
	vol $2
	note b6  $02
	note g6  $02
	note f6  $02
	vol $2
	note d6  $02
	note b5  $02
	vol $2
	note a5  $02
	note f5  $02
	vol $2
	note d5  $02
	vol $2
	note b4  $02
	vol $2
	note g4  $01
	vol $3
	note d5  $02
	vol $3
	note b4  $02
	vol $3
	note a4  $02
	vol $3
	note f4  $02
	vol $3
	note d4  $02
	vol $2
	note b3  $01
	rest $01
	duty $01
	vol $4
	note d3  $0c
	vol $5
	note f3  $0c
	vol $5
	note a3  $0c
	vol $6
	note b3  $0c
	vol $6
	note d4  $0c
	vol $5
	note fs4 $18
	vol $6
	note cs4 $18
	vol $5
	note c4  $20
	vol $3
	note c4  $08
	vol $3
	note ds4 $02
	vol $3
	note gs4 $02
	vol $3
	note c5  $02
	vol $4
	note ds5 $02
	vol $6
	note d6  $04
	vol $6
	note g5  $04
	vol $5
	note e5  $04
	vol $5
	note d5  $04
	vol $4
	note b4  $04
	vol $3
	note g4  $04
	note b5  $04
	vol $3
	note g5  $04
	vol $3
	note e5  $04
	vol $3
	note d5  $04
	vol $2
	note b4  $04
	vol $2
	note g4  $04
	vol $6
	note e6  $04
	vol $6
	note a5  $04
	vol $5
	note e5  $04
	vol $5
	note cs5 $04
	vol $4
	note a4  $04
	vol $3
	note e4  $04
	vol $3
	note cs6 $04
	vol $3
	note a5  $04
	vol $3
	note e5  $04
	vol $3
	note cs5 $04
	vol $2
	note a4  $04
	vol $2
	note e4  $04
	vol $6
	note fs3 $10
	vol $3
	note fs3 $08
	vol $6
	note b3  $04
	note cs4 $04
	note ds4 $04
	note fs4 $04
	note b4  $04
	note cs5 $04
	note ds5 $28
	rest $01
	vol $3
	note ds5 $03
	rest $01
	vol $2
	note ds5 $03
	rest $01
	vol $1
	note ds5 $03
	cmdff

sound06Channel4:
	duty $0e
	note g2  $60
	note ds2 $20
	note f2  $08
	note fs2 $08
	note gs2 $30
	note e2  $20
	note fs2 $08
	note g2  $08
	note a2  $30
	note b2  $10
	duty $0f
	note b2  $08
	duty $0e
	note fs2 $10
	duty $0f
	note fs2 $08
	duty $0e
	note b2  $26
	duty $0f
	note b2  $07
	cmdff

soundadStart:

soundadChannel2:
	duty $02
	env $0 $03
	vol $9
	note c5  $0c
	note e5  $0c
	note g5  $0c
	note d5  $0c
	note f5  $0c
	note a5  $0c
	note e5  $0c
	note g5  $0c
	note b5  $0c
	note f5  $0c
	note a5  $0c
	note c6  $0c
	note g5  $0c
	rest $0c
	note g5  $03
	note b5  $03
	note d6  $03
	env $0 $07
	note g6  $3f
	rest $14
	cmdff

soundadChannel3:
	duty $02
	env $0 $03
	vol $0
	note gs3 $12
	vol $5
	note c5  $0c
	note e5  $0c
	note g5  $0c
	note d5  $0c
	note f5  $0c
	note a5  $0c
	note e5  $0c
	note g5  $0c
	note b5  $0c
	note f5  $0c
	note a5  $0c
	note c6  $0c
	note g5  $0c
	rest $0c
	note g5  $03
	note b5  $03
	note d6  $03
	env $0 $07
	note g6  $3f
	cmdff

soundadChannel5:
	duty $0e
	rest $fa
	rest $08
	cmdff

soundadChannel7:
	cmdf0 $00
	note $00 $fa
	note $00 $08
	cmdff

sound22Start:

sound22Channel1:
	vibrato $e1
	env $0 $00
	duty $02
musice776c:
	vol $0
	note gs3 $18
	vol $6
	note g5  $0c
	note a5  $0c
	note as5 $0c
	note c6  $0c
	note a5  $06
	rest $03
	vol $4
	note a5  $06
	rest $03
	vol $2
	note a5  $06
	vol $6
	note fs5 $18
	vibrato $01
	vol $4
	note fs5 $0c
	rest $06
	vibrato $e1
	vol $6
	note c5  $06
	note d5  $06
	rest $04
	vol $4
	note d5  $06
	rest $02
	vol $6
	note a5  $03
	rest $03
	note a5  $48
	note d6  $04
	vol $6
	note d7  $04
	rest $02
	vol $5
	note d7  $04
	rest $02
	vol $4
	note d7  $04
	rest $34
	vol $6
	note g5  $0c
	note a5  $0c
	note as5 $0c
	note c6  $0c
	note a5  $06
	rest $03
	vol $4
	note a5  $06
	rest $03
	vol $2
	note a5  $06
	vol $6
	note fs5 $18
	vibrato $01
	vol $4
	note fs5 $0c
	rest $06
	vibrato $e1
	vol $6
	note c5  $06
	vol $6
	note d5  $06
	rest $0c
	note d6  $03
	rest $03
	vol $6
	note d6  $30
	rest $18
	vol $7
	note c7  $04
	rest $02
	vol $6
	note d7  $04
	rest $02
	vol $5
	note d7  $04
	rest $02
	vol $4
	note d7  $04
	rest $02
	vol $6
	note c6  $04
	rest $02
	vol $4
	note c6  $04
	rest $02
	vol $2
	note c6  $04
	vol $6
	note c6  $08
	note d6  $20
	vibrato $01
	vol $4
	note d6  $0c
	rest $04
	vibrato $e1
	vol $6
	note c6  $04
	rest $02
	vol $4
	note c6  $04
	rest $02
	vol $2
	note c6  $04
	vol $6
	note c6  $08
	note d6  $20
	vibrato $01
	vol $4
	note d6  $0c
	rest $04
	vibrato $e1
	vol $6
	note c6  $04
	rest $02
	vol $4
	note c6  $04
	rest $02
	vol $2
	note c6  $04
	vol $6
	note c6  $08
	note e6  $08
	note d6  $08
	note c6  $08
	note d6  $54
	vibrato $01
	vol $4
	note d6  $0c
	vibrato $e1
	vol $6
	note c6  $04
	rest $02
	vol $4
	note c6  $04
	rest $02
	vol $2
	note c6  $04
	vol $6
	note c6  $08
	note d6  $28
	vibrato $01
	vol $4
	note d6  $08
	vibrato $e1
	vol $6
	note c6  $10
	note a5  $08
	note d6  $28
	vibrato $01
	vol $4
	note d6  $08
	vibrato $e1
	vol $6
	note c6  $08
	note a5  $08
	note c6  $08
	note e6  $08
	note d6  $08
	note c6  $08
	note d6  $3c
	vibrato $01
	vol $4
	note d6  $0c
	vibrato $e1
	vol $6
	note a6  $18
	note g6  $18
	goto musice776c
	cmdff

sound22Channel0:
	vibrato $00
	env $0 $00
	duty $02
musice789b:
	vol $9
	note fs3 $18
	note a3  $06
	rest $03
	vol $5
	note a3  $06
	rest $03
	vol $3
	note a3  $06
	vol $9
	note a3  $06
	rest $03
	vol $5
	note a3  $06
	rest $03
	vol $3
	note a3  $06
	vol $9
	note fs3 $18
	note a3  $06
	rest $03
	vol $5
	note a3  $06
	rest $03
	vol $3
	note a3  $06
	vol $9
	note a3  $06
	rest $03
	vol $5
	note a3  $06
	rest $03
	vol $3
	note a3  $06
	vol $9
	note fs3 $18
	note a3  $06
	rest $03
	vol $5
	note a3  $06
	rest $03
	vol $3
	note a3  $06
	vol $9
	note a3  $06
	rest $03
	vol $5
	note a3  $06
	rest $03
	vol $3
	note a3  $06
	vol $9
	note fs3 $18
	note a3  $06
	rest $03
	vol $5
	note a3  $06
	rest $03
	vol $3
	note a3  $06
	vol $9
	note a3  $06
	rest $03
	vol $5
	note a3  $06
	rest $03
	vol $3
	note a3  $06
	vol $9
	note fs3 $18
	note a3  $06
	rest $03
	vol $5
	note a3  $06
	rest $03
	vol $3
	note a3  $06
	vol $9
	note a3  $06
	rest $03
	vol $5
	note a3  $06
	rest $03
	vol $3
	note a3  $06
	vol $9
	note fs3 $18
	note a3  $06
	rest $03
	vol $5
	note a3  $06
	rest $03
	vol $3
	note a3  $06
	vol $9
	note a3  $06
	rest $03
	vol $5
	note a3  $06
	rest $03
	vol $3
	note a3  $06
	vol $9
	note fs3 $18
	note a3  $06
	rest $03
	vol $5
	note a3  $06
	rest $03
	vol $3
	note a3  $06
	vol $9
	note a3  $06
	rest $03
	vol $5
	note a3  $06
	rest $03
	vol $3
	note a3  $06
	vol $9
	note fs3 $18
	note a3  $06
	rest $03
	vol $5
	note a3  $06
	rest $03
	vol $3
	note a3  $06
	vol $6
	note g5  $04
	rest $02
	vol $4
	note g5  $04
	rest $02
	vol $2
	note g5  $04
	vol $6
	note g5  $08
	note a5  $12
	vol $4
	note a5  $06
	vol $6
	note a5  $04
	rest $02
	vol $4
	note a5  $02
	vol $6
	note e5  $04
	rest $02
	vol $4
	note e5  $02
	vol $6
	note a5  $04
	rest $02
	vol $4
	note a5  $02
	vol $6
	note g5  $04
	rest $02
	vol $4
	note g5  $04
	rest $02
	vol $2
	note g5  $04
	vol $6
	note g5  $08
	note a5  $12
	vol $4
	note a5  $06
	vol $6
	note e5  $04
	rest $02
	vol $4
	note e5  $02
	vol $6
	note g5  $04
	rest $02
	vol $4
	note g5  $02
	vol $6
	note a5  $04
	rest $02
	vol $4
	note a5  $02
	vol $6
	note g5  $04
	rest $02
	vol $4
	note g5  $04
	rest $02
	vol $2
	note g5  $04
	vol $6
	note g5  $08
	note b5  $08
	note a5  $08
	note g5  $08
	note a5  $18
	note fs3 $0c
	note g3  $0c
	note gs3 $0c
	note a3  $0c
	note as3 $0c
	note b3  $0c
	note g5  $04
	rest $02
	vol $4
	note g5  $04
	rest $02
	vol $2
	note g5  $04
	vol $6
	note g5  $08
	note a5  $18
	note e5  $06
	rest $03
	vol $4
	note e5  $06
	rest $01
	vol $6
	note e5  $08
	vol $6
	note g5  $10
	note e5  $08
	note a5  $18
	vol $6
	note e5  $08
	note d5  $08
	note e5  $08
	vol $6
	note g5  $08
	note e5  $08
	note g5  $08
	note b5  $08
	note a5  $08
	note g5  $08
	note a5  $18
	note d5  $08
	note a4  $08
	note d5  $08
	note a5  $08
	note e5  $08
	note a5  $08
	note e6  $08
	note a5  $08
	note e6  $08
	note d6  $08
	note a5  $08
	note d6  $08
	goto musice789b
	cmdff

sound22Channel4:
musice7a42:
	duty $0e
	note d2  $18
	duty $0f
	note d2  $06
	rest $2a
	duty $0e
	note c2  $18
	duty $0f
	note c2  $06
	rest $2a
	duty $0e
	note d2  $18
	duty $0f
	note d2  $06
	rest $2a
	duty $0e
	note c2  $18
	duty $0f
	note c2  $06
	rest $2a
	duty $0e
	note d2  $18
	duty $0f
	note d2  $06
	rest $2a
	duty $0e
	note c2  $18
	duty $0f
	note c2  $06
	rest $2a
	duty $0e
	note d2  $18
	duty $0f
	note d2  $06
	rest $2a
	duty $0e
	note c2  $18
	duty $0f
	note c2  $06
	rest $2a
	duty $0e
	note a1  $0c
	duty $0f
	note a1  $0c
	duty $0e
	note a2  $18
	duty $0f
	note a2  $18
	duty $0e
	note a1  $0c
	duty $0f
	note a1  $0c
	duty $0e
	note a2  $18
	duty $0f
	note a2  $18
	duty $0e
	note a1  $0c
	duty $0f
	note a1  $0c
	duty $0e
	note a2  $18
	duty $0f
	note a2  $18
	duty $0e
	note a1  $0c
	duty $0f
	note a1  $0c
	duty $0e
	note a2  $18
	duty $0f
	note a2  $18
	duty $0e
	note a1  $0c
	rest $04
	note a1  $08
	note a2  $18
	note g2  $08
	note e2  $08
	note g2  $08
	note a1  $0c
	rest $04
	note a1  $08
	note a2  $0c
	rest $04
	note a2  $08
	note e2  $08
	note g2  $08
	note e2  $08
	note a1  $0c
	rest $04
	note a1  $08
	note a2  $0c
	rest $04
	note a2  $08
	note g2  $08
	note e2  $08
	note g2  $08
	note a1  $08
	note as1 $08
	note a1  $08
	note e2  $08
	note a2  $08
	note e2  $08
	note a2  $08
	note e3  $08
	note a2  $08
	goto musice7a42
	cmdff

sound22Channel6:
musice7b1c:
	vol $6
	note $24 $03
	rest $15
	note $26 $03
	rest $15
	note $26 $03
	rest $15
	note $24 $03
	rest $15
	note $26 $03
	rest $15
	note $26 $03
	rest $15
	note $24 $03
	rest $15
	note $26 $03
	rest $15
	note $26 $03
	rest $15
	note $24 $03
	rest $15
	note $26 $03
	rest $09
	note $26 $03
	rest $09
	note $26 $03
	rest $15
	note $24 $03
	rest $15
	note $26 $03
	rest $15
	note $26 $03
	rest $15
	note $24 $03
	rest $15
	note $26 $03
	rest $15
	note $26 $03
	rest $15
	note $24 $03
	rest $15
	note $26 $03
	rest $15
	note $26 $03
	rest $15
	note $24 $03
	rest $15
	note $26 $03
	rest $09
	note $26 $03
	rest $09
	note $26 $03
	rest $15
	note $24 $03
	rest $0d
	note $24 $03
	rest $05
	note $26 $03
	rest $15
	note $26 $03
	rest $05
	note $26 $03
	rest $05
	note $26 $03
	rest $05
	note $24 $03
	rest $0d
	note $24 $03
	rest $05
	note $26 $03
	rest $15
	note $26 $03
	rest $05
	note $26 $03
	rest $05
	note $26 $03
	rest $05
	note $24 $03
	rest $0d
	note $24 $03
	rest $05
	note $26 $03
	rest $15
	note $26 $03
	rest $05
	note $26 $03
	rest $05
	note $26 $03
	rest $05
	note $26 $03
	rest $0d
	note $26 $03
	rest $05
	note $26 $03
	rest $0d
	note $26 $03
	rest $05
	note $26 $03
	rest $05
	note $26 $03
	rest $05
	note $26 $03
	rest $05
	note $26 $03
	rest $0d
	note $26 $03
	rest $05
	note $26 $03
	rest $0d
	note $26 $03
	rest $05
	note $26 $03
	rest $05
	note $26 $03
	rest $05
	note $26 $03
	rest $05
	note $26 $03
	rest $0d
	note $26 $03
	rest $05
	note $26 $03
	rest $0d
	note $26 $03
	rest $05
	note $26 $03
	rest $05
	note $26 $03
	rest $05
	note $26 $03
	rest $05
	note $26 $03
	rest $0d
	note $26 $03
	rest $05
	note $26 $03
	rest $0d
	note $26 $03
	rest $05
	note $26 $03
	rest $05
	note $26 $03
	rest $05
	note $26 $03
	rest $05
	note $26 $03
	rest $05
	note $26 $03
	rest $05
	note $26 $03
	rest $05
	note $26 $03
	rest $05
	note $26 $03
	rest $05
	note $26 $03
	rest $05
	note $26 $03
	rest $05
	note $26 $03
	rest $05
	note $26 $03
	rest $05
	goto musice7b1c
	cmdff

sound1eChannel1:
	vol $0
	note gs3 $14
musice7c68:
	vibrato $e1
	env $0 $00
	duty $02
	vol $6
	note e3  $1c
	note g3  $1c
	note d4  $1c
	note b3  $1c
	note g4  $1c
	note e4  $1c
	note d4  $1c
	note e4  $1c
	env $0 $00
	note a3  $09
	note d4  $09
	note e4  $0a
	note g4  $09
	note a4  $09
	note e4  $0a
	note fs4 $09
	note a4  $09
	note d5  $0a
	note b4  $09
	note fs5 $09
	note e5  $0a
	note b4  $09
	note d5  $09
	note g5  $0a
	note fs5 $09
	note a5  $09
	note e5  $0a
	note fs5 $09
	note a5  $09
	note d6  $0a
	note b5  $09
	note cs6 $09
	note a5  $0a
	env $0 $00
	vol $1
	note b6  $04
	note a6  $04
	note b6  $04
	note a6  $04
	vol $2
	note b6  $04
	note a6  $04
	note b6  $04
	note a6  $04
	vol $3
	note b6  $04
	note a6  $04
	note b6  $04
	note a6  $04
	vol $3
	note b6  $04
	note a6  $04
	vol $4
	note b6  $04
	note a6  $04
	env $0 $05
	note b6  $0e
	vol $3
	note b6  $0e
	vol $2
	note b6  $0e
	vol $1
	note b6  $5a
	env $0 $00
	vol $6
	note a3  $1c
	note gs3 $1c
	note fs3 $1c
	note e3  $1c
	note d3  $1c
	note fs3 $1c
	note e3  $1c
	note a2  $1c
	note d3  $1c
	note b2  $1c
	note e3  $1c
	env $0 $06
	note fs3 $70
	env $0 $00
	env $0 $00
	note d4  $09
	note e4  $09
	note g4  $0a
	note fs4 $09
	note e4  $09
	note d4  $0a
	note e4  $09
	note b4  $09
	note d5  $0a
	note cs5 $09
	note b4  $09
	note a4  $0a
	note b4  $09
	note e5  $09
	note a5  $0a
	note g5  $09
	note fs5 $09
	note e5  $0a
	note fs5 $09
	note a5  $09
	note d6  $0a
	note cs6 $09
	note b5  $09
	note a5  $0a
	env $0 $00
	vol $6
	note e5  $04
	note fs5 $04
	note a5  $06
	note b5  $04
	env $0 $06
	vol $4
	note d6  $0a
	vol $4
	note d6  $09
	vol $2
	note d6  $09
	vol $1
	note d6  $0a
	env $0 $00
	vol $6
	note e5  $04
	vol $6
	note fs5 $04
	note a5  $06
	note b5  $04
	env $0 $06
	vol $5
	note d6  $0a
	vol $4
	note d6  $09
	vol $2
	note d6  $09
	vol $1
	note d6  $0a
	env $0 $00
	vol $6
	note e5  $04
	vol $6
	note fs5 $04
	note a5  $06
	note b5  $04
	env $0 $06
	vol $4
	note d6  $0a
	vol $3
	note d6  $09
	vol $2
	note d6  $09
	vol $1
	note d6  $0a
	env $0 $00
	vol $1
	note g6  $04
	note a6  $04
	vol $1
	note g6  $04
	note a6  $04
	vol $2
	note g6  $04
	note a6  $04
	vol $2
	note g6  $04
	note a6  $04
	vol $3
	note g6  $04
	note a6  $04
	vol $3
	note g6  $04
	note a6  $04
	vol $4
	note g6  $04
	note a6  $04
	env $0 $07
	vol $2
	note g6  $0e
	vol $2
	note g6  $0e
	vol $1
	note g6  $0e
	vol $1
	note g6  $46
	env $0 $00
	goto musice7c68
	cmdff

sound1eChannel0:
	vol $0
	note gs3 $14
musice7dbf:
	vibrato $e1
	env $0 $00
	duty $02
	vol $6
	note a2  $1c
	note d3  $1c
	note g3  $1c
	note e3  $1c
	vol $6
	note c4  $1c
	note b3  $1c
	note g3  $1c
	env $0 $04
	note a3  $2e
	env $0 $00
	env $0 $00
	vol $6
	note a3  $0a
	note d4  $09
	note e4  $09
	note g4  $0a
	note a4  $09
	vol $4
	note e4  $09
	note fs4 $0a
	note a4  $09
	note d5  $09
	note b4  $0a
	note fs5 $09
	note e5  $09
	note b4  $0a
	note d5  $09
	note g5  $09
	vol $4
	note fs5 $0a
	note a5  $09
	note e5  $09
	vol $4
	note fs5 $0a
	note a5  $09
	note d6  $09
	note b5  $0a
	env $0 $00
	vol $1
	note g6  $04
	note f6  $04
	note g6  $04
	note f6  $04
	vol $2
	note g6  $04
	note f6  $04
	note g6  $04
	note f6  $04
	vol $3
	note g6  $04
	note f6  $04
	note g6  $04
	note f6  $04
	vol $3
	note g6  $04
	note f6  $04
	vol $4
	note g6  $04
	note f6  $04
	env $0 $06
	vol $2
	note g6  $0e
	vol $2
	note g6  $0e
	vol $2
	note g6  $0e
	vol $1
	note g6  $5a
	env $0 $00
	vol $6
	note d3  $1c
	note cs3 $1c
	note b2  $1c
	note a2  $1c
	note g2  $1c
	note b2  $1c
	note a2  $1c
	note e2  $1c
	note g2  $1c
	note e2  $1c
	note a2  $1c
	note b2  $1c
	note d3  $1c
	note e3  $1c
	env $0 $06
	note g3  $31
	env $0 $00
	env $0 $00
	vol $6
	note b3  $09
	note d4  $09
	vol $4
	note g4  $0a
	note fs4 $09
	note e4  $09
	note d4  $0a
	note e4  $09
	note b4  $09
	note d5  $0a
	note cs5 $09
	note b4  $09
	note a4  $0a
	note b4  $09
	note e5  $09
	vol $4
	note a5  $0a
	note g5  $09
	note fs5 $09
	note e5  $0a
	note fs5 $09
	note a5  $09
	note d6  $0a
	note cs6 $09
	note b5  $09
	note a5  $0a
	env $0 $00
	vol $4
	note e5  $04
	note fs5 $05
	note a5  $04
	note b5  $04
	env $0 $06
	vol $3
	note d6  $0d
	vol $2
	note d6  $0e
	vol $1
	note d6  $0c
	env $0 $00
	vol $3
	note e5  $04
	note fs5 $05
	note a5  $04
	note b5  $04
	env $0 $06
	vol $2
	note d6  $0d
	vol $1
	note d6  $0e
	vol $1
	note d6  $0c
	env $0 $00
	vol $3
	note e5  $04
	note fs5 $05
	note a5  $04
	note b5  $04
	env $0 $06
	vol $2
	note d6  $0c
	vol $1
	note d6  $05
	env $0 $00
	vol $1
	note b6  $04
	note cs7 $04
	vol $1
	note b6  $04
	note cs7 $04
	vol $2
	note b6  $04
	note cs7 $04
	vol $2
	note b6  $04
	note cs7 $04
	vol $3
	note b6  $04
	note cs7 $04
	vol $3
	note b6  $04
	note cs7 $04
	vol $4
	note b6  $04
	note cs7 $04
	env $0 $06
	vol $2
	note b6  $0e
	vol $2
	note b6  $0e
	vol $2
	note b6  $0e
	vol $1
	note b6  $47
	env $0 $00
	goto musice7dbf
	cmdff

sound1eChannel4:
	rest $14
musice7f16:
	duty $17
	note a3  $1c
	note d4  $1c
	note g4  $1c
	note e4  $1c
	note c5  $1c
	note b4  $1c
	note g4  $1c
	note a4  $1c
	note e4  $70
	duty $0f
	note e4  $38
	duty $0c
	note e4  $38
	rest $c4
	duty $17
	note d4  $1c
	note cs4 $1c
	note b3  $1c
	note a3  $1c
	note g3  $1c
	note b3  $1c
	note a3  $1c
	note e3  $1c
	note g3  $1c
	note e3  $1c
	note a3  $1c
	note b3  $70
	duty $0f
	note b3  $38
	duty $0c
	note b3  $38
	rest $ff
	rest $c1
	goto musice7f16
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
.bank $3a slot 1
.org 0

sound00Start:

sound01Start:

sound09Start:

sound0eStart:

sound36Start:

sound00Channel6:
sound01Channel6:
sound09Channel6:
sound0eChannel6:
sound36Channel4:
sound36Channel6:
	cmdff

sound0eChannel1:
	vibrato $e1
	env $0 $00
	duty $02
musice8007:
	vol $7
	note b5  $0b
	note c6  $0b
	note b5  $0b
	note c6  $0b
	note b5  $0b
	rest $05
	vol $3
	note b5  $06
	vol $7
	note g5  $0b
	rest $05
	vol $3
	note g5  $06
	vol $7
	note e5  $0b
	rest $05
	vol $3
	note e5  $06
	vol $7
	note g5  $0b
	rest $05
	vol $3
	note g5  $06
	vol $7
	note a5  $0b
	note as5 $0b
	note a5  $0b
	note as5 $0b
	note a5  $0b
	rest $05
	vol $3
	note a5  $06
	vol $6
	note f5  $0b
	rest $05
	vol $3
	note f5  $06
	vol $6
	note d5  $0b
	rest $05
	vol $3
	note d5  $06
	vol $6
	note f5  $0b
	rest $05
	vol $3
	note f5  $06
	vol $7
	note b5  $0b
	note c6  $0b
	note b5  $0b
	note c6  $0b
	note b5  $0b
	rest $05
	vol $3
	note b5  $06
	vol $7
	note g5  $0b
	rest $05
	vol $3
	note g5  $06
	vol $7
	note e5  $0b
	rest $05
	vol $3
	note e5  $06
	vol $7
	note g5  $0b
	rest $05
	vol $3
	note g5  $06
	vol $7
	note a5  $0b
	note as5 $0b
	note a5  $0b
	note as5 $0b
	note a5  $0b
	rest $05
	vol $3
	note a5  $06
	vol $6
	note f5  $0b
	rest $05
	vol $3
	note f5  $06
	vol $6
	note d5  $0b
	rest $05
	vol $3
	note d5  $06
	vol $6
	note f5  $0b
	rest $05
	vol $3
	note f5  $06
	vol $6
	note g5  $0b
	note gs5 $0b
	vol $6
	note g5  $0b
	vol $6
	note gs5 $0b
	vol $6
	note g5  $0b
	rest $05
	vol $3
	note g5  $06
	vol $6
	note ds5 $0b
	rest $05
	vol $3
	note ds5 $06
	vol $6
	note c5  $0b
	rest $05
	vol $3
	note c5  $06
	vol $6
	note g5  $0b
	rest $05
	vol $3
	note g5  $06
	vol $6
	note f5  $0b
	note g5  $0b
	note f5  $0b
	note g5  $0b
	vol $5
	note f5  $0b
	rest $05
	vol $2
	note f5  $06
	vol $6
	note d5  $0b
	rest $05
	vol $3
	note d5  $06
	vol $6
	note as4 $0b
	rest $05
	vol $3
	note as4 $06
	vol $6
	note d5  $0b
	rest $05
	vol $3
	note d5  $06
	vol $6
	note c5  $42
	vol $6
	note a4  $0b
	rest $05
	vol $3
	note a4  $06
	vol $6
	note c5  $0b
	rest $05
	vol $3
	note c5  $06
	vol $6
	note f5  $0b
	rest $05
	vol $3
	note f5  $06
	vol $8
	note g5  $58
	vol $5
	note g6  $03
	rest $03
	vol $4
	note g6  $05
	rest $03
	vol $4
	note g6  $03
	rest $1b
	goto musice8007
	cmdff

sound0eChannel4:
	duty $08
musice812e:
	note g5  $0b
	note a5  $0b
	note g5  $0b
	note a5  $0b
	note g5  $03
	rest $03
	note g5  $05
	rest $03
	vol $4
	note g5  $03
	rest $05
	vol $6
	note e5  $03
	rest $03
	vol $4
	note e5  $05
	rest $03
	vol $4
	note e5  $03
	rest $05
	vol $6
	note b4  $03
	rest $03
	vol $4
	note b4  $05
	rest $03
	vol $4
	note b4  $03
	rest $05
	vol $6
	note g4  $03
	rest $03
	vol $4
	note g4  $05
	rest $03
	vol $4
	note g4  $03
	rest $05
	vol $6
	note f5  $0b
	note g5  $0b
	note f5  $0b
	note g5  $0b
	note f5  $03
	rest $03
	vol $4
	note f5  $05
	rest $03
	vol $4
	note f5  $03
	rest $05
	vol $6
	note d5  $03
	rest $03
	vol $5
	note d5  $05
	rest $03
	vol $4
	note d5  $03
	rest $05
	vol $6
	note as4 $03
	rest $03
	vol $4
	note as4 $05
	rest $03
	vol $3
	note as4 $03
	rest $05
	vol $6
	note f4  $03
	rest $03
	vol $4
	note f4  $05
	rest $03
	vol $3
	note f4  $03
	rest $05
	vol $6
	note g5  $0b
	note a5  $0b
	note g5  $0b
	note a5  $0b
	note g5  $03
	rest $03
	vol $5
	note g5  $05
	rest $03
	vol $4
	note g5  $03
	rest $05
	vol $6
	note e5  $03
	rest $03
	vol $4
	note e5  $05
	rest $03
	vol $4
	note e5  $03
	rest $05
	vol $6
	note b4  $03
	rest $03
	vol $4
	note b4  $05
	rest $03
	vol $4
	note b4  $03
	rest $05
	vol $6
	note g4  $03
	rest $03
	vol $4
	note g4  $05
	rest $03
	vol $4
	note g4  $03
	rest $05
	vol $6
	note f5  $0b
	note g5  $0b
	note f5  $0b
	note g5  $0b
	note f5  $03
	rest $03
	vol $4
	note f5  $05
	rest $03
	vol $4
	note f5  $03
	rest $05
	vol $6
	note d5  $03
	rest $03
	vol $5
	note d5  $05
	rest $03
	vol $4
	note d5  $03
	rest $05
	vol $6
	note as4 $03
	rest $03
	vol $5
	note as4 $05
	rest $03
	vol $4
	note as4 $03
	rest $05
	vol $6
	note f4  $03
	rest $03
	vol $5
	note f4  $05
	rest $03
	vol $3
	note f4  $03
	rest $05
	vol $7
	note ds5 $0b
	vol $6
	note f5  $0b
	note ds5 $0b
	note f5  $0b
	note ds5 $03
	rest $03
	vol $5
	note ds5 $05
	rest $03
	vol $3
	note ds5 $03
	rest $05
	vol $6
	note c5  $03
	rest $03
	vol $5
	note c5  $05
	rest $03
	vol $3
	note c5  $03
	rest $05
	vol $6
	note gs4 $03
	rest $03
	vol $5
	note gs4 $05
	rest $03
	vol $4
	note gs4 $03
	rest $05
	vol $6
	note ds4 $03
	rest $03
	vol $5
	note ds4 $05
	rest $03
	vol $4
	note ds4 $03
	rest $05
	vol $6
	note d5  $0b
	note ds5 $0b
	note d5  $0b
	note ds5 $0b
	note d5  $03
	rest $03
	vol $5
	note d5  $05
	rest $03
	vol $4
	note d5  $03
	rest $05
	vol $6
	note as4 $03
	rest $03
	vol $5
	note as4 $05
	rest $03
	vol $4
	note as4 $03
	rest $05
	vol $6
	note f4  $03
	rest $03
	vol $5
	note f4  $05
	rest $03
	vol $4
	note f4  $03
	rest $05
	vol $6
	note d4  $03
	rest $03
	vol $4
	note d4  $05
	rest $03
	vol $3
	note d4  $03
	rest $05
	vol $6
	note ds4 $0b
	note d4  $0b
	vol $6
	note c4  $03
	rest $03
	vol $5
	note c4  $05
	rest $03
	vol $3
	note c4  $03
	rest $05
	vol $6
	note ds4 $03
	rest $03
	vol $5
	note ds4 $05
	rest $03
	vol $3
	note ds4 $03
	rest $05
	vol $6
	note f4  $03
	rest $03
	vol $5
	note f4  $05
	rest $03
	vol $5
	note f4  $03
	rest $05
	vol $6
	note a4  $03
	rest $03
	vol $6
	note a4  $05
	rest $03
	vol $5
	note a4  $03
	rest $05
	vol $6
	note c5  $03
	rest $03
	vol $5
	note c5  $05
	rest $03
	vol $4
	note c5  $03
	rest $05
	vol $7
	note b4  $0b
	rest $03
	vol $6
	note b4  $03
	rest $05
	vol $5
	note b4  $03
	rest $03
	vol $4
	note b4  $05
	rest $0b
	vol $6
	note c5  $0b
	rest $03
	vol $5
	note c5  $03
	rest $05
	vol $4
	note c5  $03
	rest $03
	vol $4
	note c5  $05
	rest $0b
	vol $6
	note d5  $07
	rest $04
	vol $4
	note d5  $03
	rest $03
	vol $4
	note d5  $05
	rest $03
	vol $3
	note d5  $03
	rest $10
	goto musice812e
	cmdff

sound0eChannel0:
	duty $02
musice8357:
	vol $6
	note c4  $0b
	vol $3
	note c4  $0b
	vol $6
	note g4  $0b
	vol $3
	note g4  $0b
	vol $6
	note b4  $0b
	vol $3
	note b4  $0b
	vol $6
	note e5  $0b
	vol $3
	note e5  $16
	rest $21
	vol $6
	note as3 $0b
	vol $3
	note as3 $0b
	vol $6
	note f4  $0b
	vol $3
	note f4  $0b
	vol $6
	note a4  $0b
	vol $3
	note a4  $0b
	vol $6
	note d5  $0b
	vol $3
	note d5  $16
	rest $21
	vol $6
	note c4  $0b
	vol $3
	note c4  $0b
	vol $6
	note g4  $0b
	vol $3
	note g4  $0b
	vol $6
	note b4  $0b
	vol $3
	note b4  $0b
	vol $6
	note e5  $0b
	vol $3
	note e5  $16
	rest $21
	vol $6
	note as3 $0b
	vol $3
	note as3 $0b
	vol $6
	note f4  $0b
	vol $3
	note f4  $0b
	vol $6
	note a4  $0b
	vol $3
	note a4  $0b
	vol $6
	note d5  $0b
	vol $3
	note d5  $16
	rest $21
	vol $6
	note gs3 $0b
	vol $3
	note gs3 $0b
	vol $6
	note ds4 $0b
	vol $3
	note ds4 $0b
	vol $6
	note g4  $0b
	vol $3
	note g4  $0b
	vol $6
	note c5  $0b
	vol $3
	note c5  $16
	rest $21
	vol $6
	note g3  $0b
	vol $3
	note g3  $0b
	vol $6
	note d4  $0b
	vol $3
	note d4  $0b
	vol $6
	note g4  $0b
	vol $3
	note g4  $0b
	vol $6
	note as4 $0b
	vol $3
	note as4 $16
	rest $21
	vol $6
	note f3  $0b
	vol $3
	note f3  $0b
	vol $6
	note c4  $0b
	vol $3
	note c4  $0b
	vol $6
	note f4  $0b
	vol $3
	note f4  $0b
	vol $6
	note a4  $0b
	vol $3
	note a4  $16
	rest $21
	vol $6
	note g3  $0b
	vol $3
	note g3  $0b
	vol $6
	note b3  $0b
	vol $3
	note b3  $0b
	vol $6
	note d4  $0b
	vol $3
	note d4  $0b
	vol $6
	note g4  $0b
	vol $3
	note g4  $0b
	vol $6
	note d4  $0b
	vol $3
	note d4  $0b
	vol $6
	note b3  $0b
	vol $3
	note b3  $0b
	goto musice8357
	cmdff

sound00Channel1:
sound01Channel1:
	duty $02
	vol $8
	note as4 $18
	vol $2
	note as4 $14
	rest $10
	env $0 $02
	vol $8
	note as4 $09
	env $0 $03
	vol $4
	note as4 $03
	env $0 $02
	vol $8
	note as4 $09
	env $0 $03
	vol $4
	note as4 $03
	env $0 $00
	vol $8
	note as4 $03
	vol $2
	note as4 $03
	vol $8
	note as4 $02
	vol $2
	note as4 $04
	vol $8
	env $0 $02
	note as4 $09
	env $0 $03
	vol $4
	note as4 $09
	env $0 $00
	vol $8
	env $0 $01
	note gs4 $06
	env $0 $00
	note as4 $12
	vol $2
	note as4 $09
	vol $1
	note as4 $09
	vol $8
	env $0 $02
	note as4 $09
	env $0 $03
	vol $4
	note as4 $03
	env $0 $00
	vol $8
	env $0 $02
	note as4 $09
	env $0 $03
	vol $4
	note as4 $03
	env $0 $00
	vol $8
	note as4 $03
	vol $2
	note as4 $03
	vol $8
	note as4 $03
	vol $2
	note as4 $03
	vol $8
	env $0 $02
	note as4 $09
	vol $4
	env $0 $03
	note as4 $09
	env $0 $00
	vol $8
	env $0 $01
	note gs4 $06
	env $0 $00
	note as4 $12
	vol $2
	note as4 $09
	vol $1
	note as4 $09
	vol $8
	env $0 $02
	note as4 $09
	env $0 $03
	vol $4
	note as4 $03
	env $0 $00
	vol $8
	env $0 $02
	note as4 $09
	env $0 $03
	vol $4
	note as4 $03
	env $0 $00
	vol $8
	note as4 $03
	vol $2
	note as4 $03
	vol $8
	note as4 $03
	vol $2
	note as4 $03
	vol $a
	env $0 $01
	note as4 $09
	env $0 $03
	vol $3
	note as4 $03
	vol $8
	env $0 $01
	note f4  $06
	note f4  $06
	vol $a
	env $0 $01
	note f4  $08
	env $0 $03
	vol $3
	note f4  $04
	vol $8
	env $0 $01
	note f4  $06
	note f4  $06
	vol $a
	env $0 $01
	note f4  $08
	env $0 $03
	vol $3
	note f4  $04
	vol $8
	env $0 $01
	note f4  $06
	note f4  $06
	vol $8
	env $0 $02
	note f4  $08
	env $0 $03
	vol $3
	note f4  $04
	vol $8
	env $0 $01
	note f4  $09
	env $0 $00
	vol $4
	note f4  $03
musice8526:
	vol $a
	env $0 $01
	note as2 $0c
	note as3 $18
	note as3 $0c
	env $0 $02
	note as2 $0c
	env $0 $01
	note as3 $18
	note as3 $0c
	note gs2 $0c
	env $0 $01
	note gs3 $18
	note gs3 $0c
	note gs2 $0c
	env $0 $01
	note gs3 $18
	note gs3 $0c
	note fs2 $0c
	env $0 $01
	note fs3 $18
	note fs3 $0c
	note fs2 $0c
	env $0 $01
	note fs3 $18
	note fs3 $0c
	note cs3 $0c
	env $0 $01
	note cs4 $18
	note cs4 $0c
	note cs3 $0c
	env $0 $01
	note cs4 $18
	note cs4 $0c
	note b2  $0c
	env $0 $01
	note b3  $18
	note b3  $0c
	note b2  $0c
	env $0 $01
	note b3  $18
	note b3  $0c
	note as2 $0c
	env $0 $01
	note as3 $18
	note as3 $0c
	note as2 $0c
	env $0 $01
	note as3 $18
	note as3 $0c
	note c3  $0c
	note c4  $18
	note c4  $0c
	note c3  $0c
	note c4  $0c
	note as4 $0c
	note c4  $0c
	vibrato $00
	env $0 $03
	note f3  $0c
	vol $8
	env $0 $00
	note as4 $03
	env $0 $01
	vol $4
	note as4 $03
	vol $8
	env $0 $00
	note as4 $03
	env $0 $01
	vol $4
	note as4 $03
	vol $a
	env $0 $00
	note as4 $03
	env $0 $01
	vol $4
	note as4 $03
	env $0 $00
	vol $2
	note as4 $06
	vol $8
	note as4 $03
	env $0 $01
	vol $4
	note as4 $03
	vol $a
	env $0 $00
	note as4 $03
	env $0 $01
	vol $4
	note as4 $03
	env $0 $00
	vol $8
	note as4 $08
	vol $4
	note as4 $04
	vol $8
	note c3  $03
	env $0 $01
	vol $4
	note c3  $03
	vol $8
	env $0 $00
	note c3  $03
	env $0 $01
	vol $4
	note c3  $03
	vol $a
	env $0 $00
	note c3  $03
	env $0 $01
	vol $4
	note c3  $03
	env $0 $00
	vol $2
	note c3  $06
	vol $8
	note c3  $03
	env $0 $01
	vol $4
	note c3  $03
	vol $a
	env $0 $00
	note c3  $03
	env $0 $01
	vol $4
	note c3  $03
	env $0 $00
	vol $8
	note f3  $08
	vol $4
	note f3  $04
	vol $8
	note a4  $03
	env $0 $01
	vol $4
	note a4  $03
	vol $8
	env $0 $00
	note a4  $03
	env $0 $01
	vol $4
	note a4  $03
	vol $a
	env $0 $00
	note a4  $03
	env $0 $01
	vol $4
	note a4  $03
	env $0 $00
	vol $2
	note a4  $06
	vol $8
	note a4  $03
	env $0 $01
	vol $4
	note a4  $03
	vol $a
	env $0 $00
	note a4  $03
	env $0 $01
	vol $4
	note a4  $03
	env $0 $00
	vol $8
	note a4  $08
	vol $4
	note a4  $04
	vol $a
	env $0 $01
	note f2  $06
	vol $a
	note f2  $06
	vol $a
	note f2  $06
	vol $a
	note fs2 $05
	vol $1
	note fs2 $01
	vol $a
	note g2  $05
	vol $1
	note g2  $01
	vol $a
	note a2  $05
	vol $1
	note a2  $01
	goto musice8526
	cmdff

sound00Channel0:
sound01Channel0:
	duty $02
	vol $8
	note d4  $18
	vol $2
	note d4  $14
	rest $10
	vol $8
	env $0 $02
	note d4  $09
	env $0 $04
	vol $3
	note d4  $03
	vol $8
	env $0 $02
	note d4  $09
	env $0 $04
	vol $3
	note d4  $03
	vol $8
	note d4  $03
	vol $2
	note d4  $03
	vol $8
	note d4  $03
	vol $2
	note d4  $03
	vol $8
	env $0 $02
	note c4  $09
	env $0 $04
	vol $3
	note c4  $09
	env $0 $00
	vol $8
	note c4  $04
	vol $2
	note c4  $02
	vol $7
	note c4  $12
	vol $3
	note c4  $09
	vol $1
	note c4  $09
	vol $8
	vol $8
	env $0 $02
	note c4  $09
	env $0 $04
	vol $3
	note c4  $03
	vol $8
	env $0 $02
	note c4  $09
	env $0 $04
	vol $3
	note c4  $03
	vol $8
	env $0 $01
	note c4  $06
	env $0 $01
	note c4  $06
	vol $8
	env $0 $02
	note cs4 $09
	env $0 $03
	vol $4
	note cs4 $09
	vol $8
	env $0 $00
	note cs4 $03
	vol $2
	note cs4 $03
	vol $7
	note cs4 $12
	vol $3
	note cs4 $09
	vol $1
	note cs4 $09
	vol $8
	env $0 $02
	note cs4 $09
	env $0 $04
	vol $3
	note cs4 $03
	vol $8
	env $0 $02
	note cs4 $09
	env $0 $04
	vol $3
	note cs4 $03
	env $0 $00
	vol $8
	note cs4 $03
	vol $2
	note cs4 $03
	vol $8
	note cs4 $03
	vol $2
	note cs4 $03
	vol $a
	env $0 $01
	note cs4 $09
	env $0 $03
	vol $3
	note cs4 $03
	env $0 $00
	vol $8
	env $0 $01
	note a3  $06
	env $0 $01
	note a3  $06
	vol $a
	env $0 $01
	note a3  $08
	env $0 $03
	vol $3
	note a3  $04
	vol $8
	env $0 $01
	note a3  $06
	env $0 $01
	note a3  $06
	vol $a
	env $0 $01
	note a3  $08
	env $0 $03
	vol $3
	note a3  $04
	vol $8
	env $0 $01
	note a3  $06
	env $0 $01
	note a3  $06
	vibrato $00
	vol $8
	env $0 $02
	note a3  $09
	env $0 $03
	vol $3
	note a3  $03
	vol $8
	env $0 $02
	note a3  $09
	env $0 $03
	vol $3
	note a3  $03
musice8762:
	vol $0
	note gs3 $6c
	env $0 $00
	vol $6
	note as5 $06
	rest $06
	note as5 $03
	rest $03
	note c6  $03
	rest $03
	note d6  $03
	rest $03
	note ds6 $03
	rest $03
	env $0 $07
	note f6  $48
	env $0 $00
	note cs6 $03
	rest $03
	note fs6 $03
	rest $03
	note gs6 $03
	rest $03
	note as6 $03
	rest $03
	env $0 $07
	note cs7 $54
	env $0 $00
	note cs6 $03
	rest $03
	note ds6 $03
	rest $03
	note f6  $06
	rest $06
	note cs6 $06
	rest $06
	env $0 $07
	note gs5 $3c
	env $0 $00
	note ds6 $02
	rest $04
	note f6  $02
	rest $04
	note fs6 $02
	rest $0a
	note ds6 $02
	rest $04
	note f6  $02
	rest $04
	env $0 $04
	note fs6 $3c
	env $0 $00
	note cs6 $02
	rest $04
	note ds6 $02
	rest $04
	note f6  $02
	rest $0a
	note cs6 $02
	rest $04
	note ds6 $02
	rest $04
	env $0 $04
	note f6  $3c
	env $0 $00
	note c6  $02
	rest $04
	note d6  $02
	rest $04
	note e6  $02
	rest $0a
	note e6  $02
	rest $04
	note f6  $02
	rest $04
	note g6  $02
	rest $04
	note a6  $02
	rest $04
	note as6 $02
	rest $04
	note c7  $02
	rest $04
	note a6  $06
	rest $06
	vol $8
	note ds4 $03
	vol $2
	note ds4 $03
	vol $8
	note ds4 $03
	vol $2
	note ds4 $03
	vol $a
	note ds4 $03
	vol $2
	note ds4 $03
	vol $1
	note ds4 $06
	vol $8
	note ds4 $03
	vol $2
	note ds4 $03
	vol $8
	note ds4 $03
	vol $2
	note ds4 $03
	vol $a
	note ds4 $08
	vol $3
	note ds4 $0a
	vol $1
	note ds4 $0a
	rest $20
	vol $8
	note ds4 $03
	vol $2
	note ds4 $03
	vol $8
	note ds4 $03
	vol $2
	note ds4 $03
	vol $a
	note ds4 $03
	vol $2
	note ds4 $03
	vol $1
	note ds4 $06
	vol $8
	note ds4 $03
	vol $2
	note ds4 $03
	vol $8
	note ds4 $03
	vol $2
	note ds4 $03
	vol $a
	note ds4 $08
	vol $3
	note ds4 $0a
	vol $1
	note ds4 $0a
	rest $14
	goto musice8762
	cmdff

sound00Channel4:
sound01Channel4:
	rest $24
	duty $0e
	note as2 $05
	duty $0f
	note as2 $01
	duty $0e
	note as2 $05
	duty $0f
	note as2 $01
	duty $0e
	note as2 $0c
	duty $0f
	note as2 $12
	rest $36
	duty $0e
	note gs2 $05
	duty $0f
	note gs2 $01
	duty $0e
	note gs2 $05
	duty $0f
	note gs2 $01
	duty $0e
	note gs2 $0c
	duty $0f
	note gs2 $12
	rest $36
	duty $0e
	note fs2 $05
	duty $0f
	note fs2 $01
	duty $0e
	note fs2 $05
	duty $0f
	note fs2 $01
	duty $0e
	note fs2 $0c
	duty $0f
	note fs2 $12
	rest $5a
	duty $0e
	note f2  $0c
	duty $0e
	note g2  $05
	duty $0f
	note g2  $01
	duty $0e
	note a2  $05
	duty $0f
	note a2  $01
musice88ca:
	duty $01
	note as4 $06
	rest $12
	note f4  $1e
	rest $0c
	note as4 $04
	rest $02
	note as4 $06
	note c5  $03
	rest $03
	note d5  $03
	rest $03
	note ds5 $03
	rest $03
	note f5  $2a
	rest $12
	note f5  $09
	rest $03
	note f5  $0c
	note fs5 $03
	rest $03
	note gs5 $03
	rest $03
	note as5 $2a
	rest $12
	note as5 $09
	rest $03
	note as5 $0c
	note gs5 $03
	rest $03
	note fs5 $03
	rest $03
	note gs5 $06
	rest $0c
	note fs5 $06
	note f5  $24
	rest $0c
	note f5  $18
	note ds5 $0c
	rest $06
	note f5  $06
	note fs5 $24
	rest $0c
	note f5  $0c
	note ds5 $0c
	note cs5 $0c
	rest $06
	note ds5 $06
	note f5  $24
	rest $0c
	note ds5 $0c
	note cs5 $0c
	note c5  $0c
	rest $06
	note d5  $06
	note e5  $24
	rest $0c
	note g5  $18
	note f5  $08
	rest $b8
	goto musice88ca
	cmdff

sound2dStart:

sound2dChannel1:
	duty $02
	vol $7
	note g6  $03
	vol $6
	note fs6 $03
	vol $5
	note f6  $03
	note e6  $03
	note ds6 $03
	note d6  $03
	vol $6
	note cs6 $03
	note c6  $03
	note b5  $03
	note as5 $03
	vol $7
	note a5  $03
	note gs5 $03
	note g5  $03
	vol $8
	note fs5 $03
	note f5  $03
	vol $7
	note e5  $03
	env $0 $02
	vol $c
	duty $00
	note b3  $06
	note b3  $06
	note b3  $06
	vol $b
	env $0 $01
	note as3 $06
	rest $18
	env $0 $04
	note a3  $12
	env $0 $02
	note gs3 $12
	rest $0c
	note b3  $06
	note b3  $06
	note b3  $06
	env $0 $01
	note as3 $06
	rest $18
	env $0 $04
	note a3  $12
	env $0 $02
	note gs3 $12
	rest $0c
musice89a1:
	note cs4 $06
	note cs4 $06
	note cs4 $06
	env $0 $01
	vol $a
	note c4  $06
	rest $18
	env $0 $04
	note b3  $12
	env $0 $02
	note as3 $12
	rest $0c
	note cs4 $06
	note cs4 $06
	note cs4 $06
	vol $b
	env $0 $01
	vol $a
	note c4  $06
	rest $18
	env $0 $04
	note b3  $12
	env $0 $02
	note as3 $12
	rest $0c
	env $0 $00
	duty $01
	vol $5
	note e5  $12
	note ds5 $12
	note e5  $06
	note f5  $06
	note fs5 $06
	note g5  $06
	env $0 $02
	duty $00
	vol $a
	note ds4 $06
	note ds4 $06
	note ds4 $06
	vol $b
	env $0 $01
	vol $a
	note d4  $06
	rest $18
	env $0 $04
	note cs4 $12
	env $0 $02
	note c4  $12
	rest $0c
	note ds4 $06
	note ds4 $06
	note ds4 $06
	vol $b
	env $0 $01
	vol $a
	note d4  $06
	rest $18
	env $0 $04
	note cs4 $12
	env $0 $02
	note c4  $12
	rest $0c
	note f4  $06
	note f4  $06
	note f4  $06
	vol $b
	env $0 $01
	vol $a
	note e4  $06
	rest $18
	env $0 $04
	note ds4 $12
	env $0 $02
	note d4  $12
	rest $0c
	note f4  $06
	note f4  $06
	note f4  $06
	vol $b
	env $0 $01
	vol $a
	note e4  $06
	rest $18
	env $0 $04
	note ds4 $12
	env $0 $02
	note d4  $12
	rest $6c
	env $0 $00
	duty $02
	note g6  $03
	vol $6
	note fs6 $03
	vol $5
	note f6  $03
	note e6  $03
	note ds6 $03
	note d6  $03
	note cs6 $03
	vol $6
	note c6  $03
	note b5  $03
	note as5 $03
	vol $7
	note a5  $03
	note gs5 $03
	note g5  $03
	vol $8
	note fs5 $03
	note f5  $03
	vol $7
	note e5  $03
	env $0 $02
	duty $00
	vol $b
	note b3  $06
	note b3  $06
	note b3  $06
	env $0 $01
	note as3 $06
	rest $18
	env $0 $04
	note a3  $12
	env $0 $02
	note gs3 $12
	rest $0c
	note b3  $06
	note b3  $06
	note b3  $06
	vol $b
	env $0 $01
	vol $a
	note as3 $06
	rest $18
	env $0 $04
	note a3  $12
	env $0 $02
	note gs3 $12
	rest $0c
	goto musice89a1
	cmdff

sound2dChannel0:
	duty $02
	vol $7
	note d6  $03
	vol $6
	note cs6 $03
	vol $5
	note c6  $03
	note b5  $03
	note as5 $03
	note a5  $03
	vol $6
	note gs5 $03
	note g5  $03
	note fs5 $03
	note f5  $03
	vol $7
	note e5  $03
	note ds5 $03
	note d5  $03
	vol $8
	note cs5 $03
	note c5  $03
	note b4  $03
	env $0 $02
	duty $00
	note e3  $06
	note e3  $06
	note e3  $06
	vol $9
	env $0 $01
	vol $8
	note ds3 $06
	rest $18
	env $0 $04
	note d3  $12
	env $0 $02
	note cs3 $12
	rest $0c
	env $0 $02
	note e3  $06
	note e3  $06
	note e3  $06
	vol $9
	env $0 $01
	note ds3 $06
	rest $18
	env $0 $04
	note d3  $12
	env $0 $02
	note cs3 $12
	rest $0c
musice8b04:
	note fs3 $06
	note fs3 $06
	note fs3 $06
	vol $9
	env $0 $01
	note f3  $06
	rest $18
	env $0 $04
	note e3  $12
	env $0 $02
	note ds3 $12
	rest $0c
	note fs3 $06
	note fs3 $06
	note fs3 $06
	vol $9
	env $0 $01
	vol $8
	note f3  $06
	rest $18
	env $0 $04
	note e3  $12
	env $0 $02
	note ds3 $12
	rest $0c
	env $0 $00
	duty $02
	vol $9
	note c3  $12
	note b2  $12
	note c3  $06
	note cs3 $06
	note d3  $06
	note ds3 $06
	env $0 $02
	duty $00
	vol $8
	note gs3 $06
	note gs3 $06
	note gs3 $06
	vol $a
	env $0 $01
	vol $9
	note g3  $06
	rest $18
	env $0 $04
	note fs3 $12
	env $0 $02
	note f3  $12
	rest $0c
	note gs3 $06
	note gs3 $06
	note gs3 $06
	vol $9
	env $0 $01
	vol $8
	note g3  $06
	rest $18
	env $0 $04
	note fs3 $12
	env $0 $02
	note f3  $12
	rest $0c
	note as3 $06
	note as3 $06
	note as3 $06
	vol $9
	env $0 $01
	vol $8
	note a3  $06
	rest $18
	env $0 $04
	note gs3 $12
	env $0 $02
	note g3  $12
	rest $0c
	note as3 $06
	note as3 $06
	note as3 $06
	vol $9
	env $0 $01
	vol $8
	note a3  $06
	rest $18
	env $0 $04
	note gs3 $12
	env $0 $02
	note g3  $12
	rest $6c
	env $0 $00
	duty $02
	note d6  $03
	vol $6
	note cs6 $03
	vol $5
	note c6  $03
	note b5  $03
	note as5 $03
	note a5  $03
	vol $6
	note gs5 $03
	note g5  $03
	note fs5 $03
	note f5  $03
	vol $7
	note e5  $03
	note ds5 $03
	note d5  $03
	vol $8
	note cs5 $03
	note c5  $03
	vol $7
	note b4  $03
	env $0 $02
	vol $9
	duty $00
	note e3  $06
	note e3  $06
	note e3  $06
	env $0 $01
	vol $8
	note ds3 $06
	rest $18
	env $0 $04
	note d3  $12
	env $0 $02
	note cs3 $12
	rest $0c
	note e3  $06
	note e3  $06
	note e3  $06
	vol $9
	env $0 $01
	vol $8
	note ds3 $06
	rest $18
	env $0 $04
	note d3  $12
	env $0 $02
	note cs3 $12
	rest $0c
	env $0 $04
	goto musice8b04
	cmdff

sound2dChannel4:
	duty $12
	rest $30
	note b2  $06
	note fs2 $06
	note b2  $06
	note fs2 $06
	note b2  $06
	note fs2 $06
	note b2  $06
	note fs2 $06
	note b2  $06
	note fs2 $06
	note b2  $06
	note fs2 $06
	note b2  $06
	note fs2 $06
	note b2  $06
	note fs2 $06
	note b2  $06
	note fs2 $06
	note b2  $06
	note fs2 $06
	note b2  $06
	note fs2 $06
	note b2  $06
	note fs2 $06
	note b2  $06
	note fs2 $06
	note b2  $06
	note fs2 $06
	note b2  $06
	note fs2 $06
	note b2  $06
	note fs2 $06
musice8c51:
	duty $12
	note cs2 $06
	note cs3 $06
	note cs2 $06
	note cs3 $06
	note cs2 $06
	note cs3 $06
	note cs2 $06
	note cs3 $06
	note cs2 $06
	note cs3 $06
	note cs2 $06
	note cs3 $06
	note cs2 $06
	note cs3 $06
	note cs2 $06
	note cs3 $06
	note cs2 $06
	note cs3 $06
	note cs2 $06
	note cs3 $06
	note cs2 $06
	note cs3 $06
	note cs2 $06
	note cs3 $06
	note cs2 $06
	note cs3 $06
	note cs2 $06
	note cs3 $06
	note cs2 $06
	note cs3 $06
	note cs2 $06
	note cs3 $06
	duty $01
	note b4  $12
	note as4 $12
	note b4  $06
	note c5  $06
	note cs5 $06
	note d5  $06
	duty $12
	note ds2 $06
	note a1  $06
	note ds2 $06
	note a1  $06
	note ds2 $06
	note a1  $06
	note ds2 $06
	note a1  $06
	note ds2 $06
	note a1  $06
	note ds2 $06
	note a1  $06
	note ds2 $06
	note a1  $06
	note ds2 $06
	note a1  $06
	note ds2 $06
	note a1  $06
	note ds2 $06
	note a1  $06
	note ds2 $06
	note a1  $06
	note ds2 $06
	note a1  $06
	note ds2 $06
	note a1  $06
	note ds2 $06
	note a1  $06
	note ds2 $06
	note a1  $06
	note ds2 $06
	note a1  $06
	note f1  $06
	note f2  $06
	note f1  $06
	note f2  $06
	note f1  $06
	note f2  $06
	note f1  $06
	note f2  $06
	note f1  $06
	note f2  $06
	note f1  $06
	note f2  $06
	note f1  $06
	note f2  $06
	note f1  $06
	note f2  $06
	note f1  $06
	note f2  $06
	note f1  $06
	note f2  $06
	note f1  $06
	note f2  $06
	note f1  $06
	note f2  $06
	note f1  $06
	note f2  $06
	note f1  $06
	note f2  $06
	note f1  $06
	note f2  $06
	note f1  $06
	note f2  $06
	rest $90
	note b2  $06
	note fs2 $06
	note b2  $06
	note fs2 $06
	note b2  $06
	note fs2 $06
	note b2  $06
	note fs2 $06
	note b2  $06
	note fs2 $06
	note b2  $06
	note fs2 $06
	note b2  $06
	note fs2 $06
	note b2  $06
	note fs2 $06
	note b2  $06
	note fs2 $06
	note b2  $06
	note fs2 $06
	note b2  $06
	note fs2 $06
	note b2  $06
	note fs2 $06
	note b2  $06
	note fs2 $06
	note b2  $06
	note fs2 $06
	note b2  $06
	note fs2 $06
	note b2  $06
	note fs2 $06
	goto musice8c51
	cmdff

sound2dChannel6:
	rest $30
	vol $3
	note $52 $04
	rest $02
	note $52 $04
	rest $02
	vol $8
	note $28 $01
	vol $2
	note $27 $08
	rest $03
	vol $3
	note $52 $04
	rest $02
	note $52 $04
	rest $02
	vol $8
	note $28 $01
	vol $2
	note $27 $08
	rest $03
	vol $3
	note $52 $04
	rest $02
	note $52 $04
	rest $02
	vol $8
	note $28 $01
	vol $2
	note $27 $08
	rest $03
	vol $3
	note $52 $04
	rest $02
	note $52 $04
	rest $02
	vol $8
	note $28 $01
	vol $2
	note $27 $08
	rest $03
	vol $3
	note $52 $04
	rest $02
	note $52 $04
	rest $02
	vol $8
	note $28 $01
	vol $2
	note $27 $08
	rest $03
	vol $3
	note $52 $04
	rest $02
	note $52 $04
	rest $02
	vol $8
	note $28 $01
	vol $2
	note $27 $08
	rest $03
	vol $3
	note $52 $04
	rest $02
	vol $8
	note $28 $01
	vol $2
	note $27 $08
	rest $03
	vol $8
	note $28 $01
	vol $2
	note $27 $03
	rest $02
	vol $8
	note $28 $01
	vol $2
	note $27 $03
	rest $02
	vol $8
	note $1c $01
	vol $2
	note $27 $03
	rest $02
	vol $9
	note $28 $01
	vol $1
	note $27 $03
	rest $02
	vol $8
	note $28 $01
	vol $2
	note $27 $03
	rest $02
musice8e06:
	vol $3
	note $52 $04
	rest $02
	note $52 $04
	rest $02
	vol $8
	note $28 $01
	vol $2
	note $27 $08
	rest $03
	vol $3
	note $52 $04
	rest $02
	note $52 $04
	rest $02
	vol $8
	note $28 $01
	vol $2
	note $27 $08
	rest $03
	vol $3
	note $52 $04
	rest $02
	note $52 $04
	rest $02
	vol $8
	note $28 $01
	vol $2
	note $27 $08
	rest $03
	vol $3
	note $52 $04
	rest $02
	note $52 $04
	rest $02
	vol $8
	note $28 $01
	vol $2
	note $27 $08
	rest $03
	vol $3
	note $52 $04
	rest $02
	note $52 $04
	rest $02
	vol $8
	note $28 $01
	vol $2
	note $27 $08
	rest $03
	vol $3
	note $52 $04
	rest $02
	note $52 $04
	rest $02
	vol $8
	note $28 $01
	vol $2
	note $27 $08
	rest $03
	vol $3
	note $52 $04
	rest $02
	vol $8
	note $28 $01
	vol $2
	note $27 $08
	rest $03
	vol $8
	note $28 $01
	vol $2
	note $27 $03
	rest $02
	vol $8
	note $28 $01
	vol $2
	note $27 $03
	rest $02
	vol $8
	note $28 $01
	vol $2
	note $27 $03
	rest $02
	vol $6
	note $28 $01
	vol $1
	note $27 $03
	rest $02
	vol $8
	note $28 $01
	vol $2
	note $27 $03
	rest $02
	vol $8
	note $28 $01
	vol $2
	note $27 $03
	rest $02
	vol $6
	note $28 $01
	vol $1
	note $27 $03
	rest $02
	vol $6
	note $28 $01
	vol $1
	note $27 $03
	rest $02
	vol $8
	note $28 $01
	vol $2
	note $27 $03
	rest $02
	vol $6
	note $28 $01
	vol $1
	note $27 $03
	rest $02
	vol $6
	note $28 $01
	vol $2
	note $27 $03
	rest $02
	vol $8
	note $28 $01
	vol $2
	note $27 $03
	rest $02
	vol $8
	note $28 $01
	vol $2
	note $27 $03
	rest $02
	vol $c
	note $28 $01
	vol $2
	note $27 $03
	rest $02
	vol $d
	note $28 $01
	vol $2
	note $27 $03
	rest $02
	vol $3
	note $52 $04
	rest $02
	note $52 $04
	rest $02
	vol $8
	note $28 $01
	vol $2
	note $27 $08
	rest $03
	vol $3
	note $52 $04
	rest $02
	note $52 $04
	rest $02
	vol $8
	note $28 $01
	vol $2
	note $27 $08
	rest $03
	vol $3
	note $52 $04
	rest $02
	note $52 $04
	rest $02
	vol $8
	note $28 $01
	vol $2
	note $27 $08
	rest $03
	vol $3
	note $52 $04
	rest $02
	note $52 $04
	rest $02
	vol $8
	note $28 $01
	vol $2
	note $27 $08
	rest $03
	vol $3
	note $52 $04
	rest $02
	note $52 $04
	rest $02
	vol $8
	note $28 $01
	vol $2
	note $27 $08
	rest $03
	vol $3
	note $52 $04
	rest $02
	note $52 $04
	rest $02
	vol $8
	note $28 $01
	vol $2
	note $27 $08
	rest $03
	vol $3
	note $52 $04
	rest $02
	vol $8
	note $28 $01
	vol $2
	note $27 $08
	rest $03
	vol $8
	note $28 $01
	vol $2
	note $27 $03
	rest $02
	vol $8
	note $28 $01
	vol $2
	note $27 $03
	rest $02
	vol $8
	note $28 $01
	vol $2
	note $27 $03
	rest $02
	vol $9
	note $28 $01
	vol $2
	note $27 $03
	rest $02
	vol $8
	note $28 $01
	vol $2
	note $27 $03
	rest $02
	vol $3
	note $52 $04
	rest $02
	note $52 $04
	rest $02
	vol $8
	note $28 $01
	vol $2
	note $27 $08
	rest $03
	vol $3
	note $52 $04
	rest $02
	note $52 $04
	rest $02
	vol $8
	note $28 $01
	vol $2
	note $27 $08
	rest $03
	vol $3
	note $52 $04
	rest $02
	note $52 $04
	rest $02
	vol $8
	note $28 $01
	vol $2
	note $27 $08
	rest $03
	vol $3
	note $52 $04
	rest $02
	note $52 $04
	rest $02
	vol $8
	note $28 $01
	vol $2
	note $27 $08
	rest $03
	vol $3
	note $52 $04
	rest $02
	note $52 $04
	rest $02
	vol $8
	note $28 $01
	vol $2
	note $27 $08
	rest $03
	vol $3
	note $52 $04
	rest $02
	note $52 $04
	rest $02
	vol $8
	note $28 $01
	vol $2
	note $27 $08
	rest $03
	vol $3
	note $52 $04
	rest $02
	vol $8
	note $28 $01
	vol $2
	note $27 $08
	rest $03
	vol $8
	note $28 $01
	vol $2
	note $27 $03
	rest $02
	vol $8
	note $28 $01
	vol $2
	note $27 $03
	rest $02
	vol $8
	note $28 $01
	vol $2
	note $27 $03
	rest $02
	vol $9
	note $28 $01
	vol $2
	note $27 $03
	rest $02
	vol $8
	note $28 $01
	vol $2
	note $27 $03
	rest $02
	vol $8
	note $28 $01
	vol $2
	note $27 $03
	rest $02
	vol $8
	note $28 $01
	vol $2
	note $27 $08
	rest $03
	vol $4
	note $26 $04
	rest $02
	note $26 $09
	rest $03
	vol $8
	note $28 $01
	vol $2
	note $27 $03
	rest $02
	vol $8
	note $28 $01
	vol $2
	note $27 $03
	rest $02
	vol $4
	note $26 $04
	rest $02
	note $26 $04
	rest $02
	note $26 $04
	rest $02
	note $26 $04
	rest $02
	vol $7
	note $28 $01
	vol $5
	note $27 $03
	rest $02
	vol $9
	note $28 $01
	vol $5
	note $27 $03
	rest $02
	vol $8
	note $28 $01
	vol $5
	note $27 $03
	rest $02
	vol $d
	note $28 $01
	vol $5
	note $27 $03
	rest $32
	vol $3
	note $52 $04
	rest $02
	note $52 $04
	rest $02
	vol $8
	note $28 $01
	vol $2
	note $27 $08
	rest $03
	vol $3
	note $52 $04
	rest $02
	note $52 $04
	rest $02
	vol $8
	note $28 $01
	vol $2
	note $27 $08
	rest $03
	vol $3
	note $52 $04
	rest $02
	note $52 $04
	rest $02
	vol $8
	note $28 $01
	vol $2
	note $27 $08
	rest $03
	vol $3
	note $52 $04
	rest $02
	note $52 $04
	rest $02
	vol $8
	note $28 $01
	vol $2
	note $27 $08
	rest $03
	vol $3
	note $52 $04
	rest $02
	note $52 $04
	rest $02
	vol $8
	note $28 $01
	vol $2
	note $27 $08
	rest $03
	vol $3
	note $52 $04
	rest $02
	note $52 $04
	rest $02
	vol $8
	note $28 $01
	vol $2
	note $27 $08
	rest $03
	vol $3
	note $52 $04
	rest $02
	vol $8
	note $28 $01
	vol $2
	note $27 $08
	rest $03
	vol $8
	note $28 $01
	vol $2
	note $27 $03
	rest $02
	vol $8
	note $28 $01
	vol $2
	note $27 $03
	rest $02
	vol $8
	note $28 $01
	vol $2
	note $27 $03
	rest $02
	vol $7
	note $28 $01
	vol $2
	note $27 $03
	rest $02
	vol $8
	note $28 $01
	vol $2
	note $27 $03
	rest $02
	goto musice8e06
	cmdff

sound09Channel1:
	duty $02
	env $0 $03
musice9124:
	vol $8
	note e6  $09
	rest $04
	vol $5
	note e6  $09
	rest $05
	vol $2
	note e6  $09
	vol $8
	note b5  $09
	rest $04
	vol $5
	note b5  $09
	rest $05
	vol $2
	note b5  $09
	rest $24
	vol $8
	note e6  $04
	rest $05
	note fs6 $04
	rest $05
	note gs6 $04
	rest $05
	note a6  $04
	rest $05
	note b6  $09
	rest $04
	vol $5
	note b6  $09
	rest $05
	vol $2
	note b6  $09
	rest $04
	vol $1
	note b6  $09
	rest $3b
	vol $8
	note b6  $09
	rest $04
	vol $5
	note b6  $05
	vol $8
	note c7  $09
	note d7  $09
	note e7  $09
	rest $04
	vol $5
	note e7  $09
	rest $05
	vol $2
	note e7  $09
	rest $04
	vol $1
	note e7  $09
	rest $3b
	vol $8
	note e7  $09
	rest $04
	vol $5
	note e7  $05
	vol $8
	note d7  $09
	note c7  $09
	note b6  $09
	rest $04
	vol $5
	note b6  $09
	rest $05
	vol $2
	note b6  $09
	rest $04
	vol $1
	note b6  $09
	rest $3b
	vol $8
	note b6  $09
	rest $04
	vol $5
	note b6  $09
	rest $05
	vol $2
	note b6  $09
	vol $8
	note a6  $09
	rest $04
	vol $5
	note a6  $05
	vol $8
	note b6  $09
	rest $04
	vol $5
	note b6  $05
	vol $8
	note c7  $09
	rest $04
	vol $5
	note c7  $09
	rest $05
	vol $2
	note c7  $09
	rest $04
	vol $1
	note c7  $09
	rest $17
	vol $8
	note b6  $09
	rest $04
	vol $5
	note b6  $05
	vol $8
	note a6  $09
	rest $04
	vol $5
	note a6  $05
	vol $8
	note g6  $09
	rest $04
	vol $5
	note g6  $05
	vol $8
	note a6  $09
	rest $04
	vol $5
	note a6  $05
	vol $8
	note b6  $09
	rest $04
	vol $5
	note b6  $09
	rest $05
	vol $2
	note b6  $09
	rest $24
	vol $8
	note a6  $09
	rest $04
	vol $5
	note a6  $05
	vol $8
	note g6  $09
	rest $04
	vol $5
	note g6  $05
	vol $8
	note fs6 $09
	rest $04
	vol $5
	note fs6 $05
	vol $8
	note gs6 $09
	rest $04
	vol $5
	note gs6 $05
	vol $8
	note as6 $09
	rest $04
	vol $5
	note as6 $09
	rest $05
	vol $2
	note as6 $09
	rest $24
	vol $8
	note cs7 $09
	rest $04
	vol $5
	note cs7 $09
	rest $05
	vol $2
	note cs7 $09
	vol $8
	note b6  $09
	rest $04
	vol $5
	note b6  $09
	rest $05
	vol $2
	note b6  $09
	rest $04
	vol $1
	note b6  $09
	rest $5f
	goto musice9124
	cmdff

sound09Channel0:
	duty $02
	env $0 $03
musice925c:
	vol $0
	note gs3 $12
	vol $6
	note gs4 $12
	note b4  $12
	note e5  $12
	note gs5 $12
	rest $48
	note fs4 $12
	note b4  $12
	note ds5 $12
	note fs5 $12
	note b5  $12
	rest $36
	note e5  $12
	note g5  $12
	note c6  $12
	note e6  $12
	note c6  $12
	note g5  $12
	note e5  $12
	rest $12
	note b4  $12
	note e5  $12
	note fs5 $12
	note ds5 $12
	rest $36
	note f5  $12
	note c5  $12
	note f5  $12
	note a5  $12
	note c6  $12
	rest $36
	note e6  $12
	note b5  $12
	note g5  $12
	note e5  $12
	note b4  $12
	rest $12
	note e5  $12
	rest $12
	note fs5 $12
	note cs5 $12
	note b4  $12
	note cs5 $12
	note as4 $12
	note cs5 $12
	note fs4 $12
	note cs5 $12
	note b5  $12
	note b4  $12
	note e5  $12
	note fs5 $12
	note ds5 $12
	rest $36
	goto musice925c
	cmdff

sound09Channel4:
musice92cc:
	rest $09
	duty $08
	note e6  $12
	rest $12
	note b5  $12
	rest $36
	note e6  $09
	note fs6 $09
	note gs6 $09
	note a6  $09
	note b6  $12
	rest $5a
	note b6  $12
	note cs7 $09
	rest $09
	note e7  $12
	rest $5a
	note e7  $12
	note d7  $09
	note c7  $09
	note b6  $12
	rest $5a
	note b6  $12
	rest $12
	note a6  $12
	note b6  $12
	note c7  $12
	rest $36
	note b6  $12
	note a6  $12
	note g6  $12
	note a6  $12
	note b6  $12
	rest $36
	note a6  $12
	note g6  $12
	note fs6 $12
	note gs6 $12
	note as6 $12
	rest $36
	note cs7 $12
	rest $12
	note b6  $12
	rest $75
	goto musice92cc
	cmdff

sound36Channel1:
	duty $02
musice932a:
	env $0 $06
	vol $6
	note b2  $0c
	note cs3 $0c
	note d3  $0c
	env $0 $04
	note a3  $0c
	rest $24
	env $0 $05
	note b4  $0c
	note b4  $18
	rest $18
	env $0 $06
	note b2  $0c
	note cs3 $0c
	note d3  $0c
	env $0 $04
	note gs3 $0c
	rest $24
	env $0 $05
	note as4 $0c
	note as4 $18
	rest $18
	env $0 $06
	note cs3 $0c
	note ds3 $0c
	note e3  $0c
	env $0 $04
	note b3  $0c
	rest $24
	env $0 $05
	note cs5 $0c
	note cs5 $18
	rest $18
	env $0 $06
	note cs3 $0c
	note ds3 $0c
	note e3  $0c
	env $0 $04
	note as3 $0c
	rest $24
	env $0 $05
	note c5  $0c
	note c5  $18
	rest $18
	env $0 $06
	note fs3 $0c
	note gs3 $0c
	note a3  $0c
	env $0 $04
	note e4  $0c
	rest $24
	env $0 $05
	note e5  $0c
	env $0 $06
	note g3  $0c
	note a3  $0c
	note as3 $0c
	env $0 $04
	note f4  $0c
	rest $24
	env $0 $05
	note f5  $0c
	note b3  $0c
	note cs4 $0c
	note d4  $0c
	note a5  $0c
	env $0 $04
	note gs5 $0c
	note g5  $0c
	note fs5 $0c
	env $0 $00
	vol $5
	note f5  $08
	rest $94
	goto musice932a
	cmdff

sound36Channel0:
	duty $02
musice93c4:
	vol $0
	note gs3 $16
	env $0 $05
	vol $3
	note b2  $0c
	note cs3 $0c
	note d3  $0c
	env $0 $04
	note a3  $0c
	rest $0e
	vol $6
	env $0 $03
	note f4  $0c
	note f4  $18
	rest $2e
	vol $3
	env $0 $05
	note b2  $0c
	note cs3 $0c
	note d3  $0c
	env $0 $04
	note gs3 $0c
	rest $0e
	vol $6
	env $0 $03
	note e4  $0c
	note e4  $18
	rest $2e
	vol $3
	env $0 $05
	note cs3 $0c
	note ds3 $0c
	note e3  $0c
	env $0 $04
	note b3  $0c
	rest $0e
	vol $6
	env $0 $03
	note g4  $0c
	note g4  $18
	rest $2e
	vol $3
	env $0 $05
	note cs3 $0c
	note ds3 $0c
	note e3  $0c
	env $0 $04
	note as3 $0c
	rest $0e
	vol $6
	env $0 $03
	note fs4 $0c
	note fs4 $18
	rest $2e
	vol $3
	env $0 $05
	note fs3 $0c
	note gs3 $0c
	note a3  $0c
	env $0 $04
	note e4  $0c
	rest $0e
	vol $6
	env $0 $03
	note as4 $0c
	rest $16
	vol $3
	env $0 $05
	note g3  $0c
	note a3  $0c
	note as3 $0c
	env $0 $04
	note f4  $0c
	rest $0e
	vol $6
	env $0 $03
	note b4  $0c
	rest $16
	vol $3
	env $0 $04
	note b3  $0c
	note cs4 $0c
	note d4  $02
	vol $6
	env $0 $04
	note f5  $0c
	note e5  $0c
	note ds5 $0c
	env $0 $00
	vol $5
	note d5  $08
	rest $94
	goto musice93c4
	cmdff

sound10Start:

sound10Channel1:
	duty $00
	vol $b
	note a5  $06
	vol $1
	note a5  $04
	vol $b
	note as5 $06
	vol $1
	note as5 $03
	vol $b
	note b5  $06
	vol $1
	note b5  $02
	vol $b
	note c6  $06
	vol $1
	note c6  $02
	vol $b
	note cs6 $06
	vol $1
	note cs6 $02
	vol $b
	env $0 $00
	vibrato $e1
	note d6  $52
	cmdff

sound10Channel0:
	duty $00
	vol $c
	note c5  $06
	vol $1
	note c5  $04
	vol $c
	note cs5 $06
	vol $1
	note cs5 $03
	vol $c
	note d5  $06
	vol $1
	note d5  $02
	vol $c
	note ds5 $06
	vol $1
	note ds5 $02
	vol $c
	note e5  $06
	vol $1
	note e5  $02
	vol $c
	env $0 $00
	vibrato $e1
	note f5  $52
	cmdff

sound10Channel4:
	duty $0a
	note f3  $06
	rest $04
	note fs3 $06
	rest $03
	note g3  $06
	rest $02
	note gs3 $06
	rest $02
	note a3  $06
	rest $02
	note as3 $4b
	cmdff

sound10Channel6:
	vol $0
	note $30 $1b
	vol $5
	note $30 $04
	vol $0
	note $30 $04
	vol $3
	note $30 $04
	vol $0
	note $30 $04
	vol $2
	note $30 $52
	cmdff

sound74Start:

sound74Channel7:
	cmdf0 $20
	note $47 $01
	cmdf0 $20
	note $46 $01
	cmdf0 $30
	note $45 $01
	cmdf0 $40
	note $44 $01
	cmdf0 $50
	note $37 $01
	cmdf0 $70
	note $35 $01
	cmdf0 $90
	note $27 $01
	cmdf0 $b0
	note $26 $01
	cmdf0 $c0
	note $25 $01
	cmdff

sound73Start:

sound73Channel7:
	cmdf0 $d3
	note $37 $01
	note $44 $01
	note $45 $01
	note $46 $01
	note $47 $01
	note $54 $01
	note $55 $01
	note $56 $01
	note $57 $02
	note $56 $01
	note $55 $01
	note $54 $01
	note $47 $04
	note $46 $03
	cmdf0 $20
	note $55 $04
	note $54 $04
	note $47 $04
	note $46 $04
	cmdff

sound54Start:

sound54Channel2:
	duty $01
	vol $f
	env $3 $00
	cmdf8 $23
	note c3  $16
	cmdff

sound54Channel3:
	duty $02
	vol $f
	env $3 $00
	cmdf8 $2c
	note c2  $16
	cmdff

sound55Start:

sound55Channel2:
	duty $02
	vol $d
	env $1 $00
	cmdf8 $d3
	note g4  $09
	cmdff

sound55Channel3:
	duty $01
	vol $d
	env $1 $00
	cmdf8 $e0
	note g4  $09
	cmdff

sound5cStart:

sound5cChannel2:
	duty $00
	vol $1
	note e7  $01
	note g7  $01
	note as7 $01
	vol $1
	note e7  $01
	note g7  $01
	note as7 $01
	vol $1
	note e7  $01
	note g7  $01
	note as7 $01
	vol $1
	note e7  $01
	note g7  $01
	note as7 $01
	vol $2
	cmdf8 $01
	note e7  $01
	note g7  $01
	note as7 $01
	vol $2
	note e7  $01
	note g7  $01
	note as7 $01
	vol $2
	note e7  $01
	note g7  $01
	note as7 $01
	vol $2
	note e7  $01
	note g7  $01
	note as7 $01
	cmdf8 $00
	vol $3
	cmdf8 $03
	note e7  $01
	note g7  $01
	note as7 $01
	vol $3
	note f7  $01
	note g7  $01
	note as7 $01
	vol $3
	note f7  $01
	note g7  $01
	note as7 $01
	vol $3
	note f7  $01
	note g7  $01
	note as7 $01
	cmdf8 $00
	vol $4
	cmdf8 $05
	note f7  $01
	note gs7 $01
	note as7 $01
	vol $4
	note f7  $01
	note gs7 $01
	note as7 $01
	vol $4
	note f7  $01
	note gs7 $01
	note as7 $01
	vol $4
	note f7  $01
	note gs7 $01
	note as7 $01
	cmdf8 $00
	vol $6
	cmdf8 $07
	note f7  $01
	note gs7 $01
	note b7  $01
	vol $5
	note f7  $01
	note gs7 $01
	note b7  $01
	vol $5
	note f7  $01
	note gs7 $01
	note b7  $01
	vol $5
	note f7  $01
	note gs7 $01
	note b7  $01
	cmdf8 $00
	vol $8
	cmdf8 $09
	note fs7 $01
	note gs7 $01
	note b7  $01
	vol $6
	note fs7 $01
	note gs7 $01
	note b7  $01
	vol $6
	note fs7 $01
	note gs7 $01
	note b7  $01
	vol $6
	note fs7 $01
	note gs7 $01
	note b7  $01
	cmdf8 $00
	vol $9
	cmdf8 $0b
	note fs7 $01
	note a7  $01
	note b7  $01
	vol $7
	note fs7 $01
	note a7  $01
	note b7  $01
	vol $7
	note fs7 $01
	note a7  $01
	note b7  $01
	vol $7
	note fs7 $01
	note a7  $01
	note b7  $01
	cmdf8 $00
	vol $a
	cmdf8 $0d
	note fs7 $01
	note a7  $01
	note c8  $01
	vol $8
	note fs7 $01
	note a7  $01
	note c8  $01
	vol $8
	note fs7 $01
	note a7  $01
	note c8  $01
	vol $8
	note fs7 $01
	note a7  $01
	note c8  $01
	cmdf8 $00
	vol $b
	cmdf8 $0e
	note g7  $01
	note a7  $01
	note c8  $01
	vol $9
	note g7  $01
	note a7  $01
	note c8  $01
	vol $9
	note g7  $01
	note a7  $01
	note c8  $01
	vol $9
	note g7  $01
	note a7  $01
	note c8  $01
	cmdf8 $00
	vol $c
	cmdf8 $0f
	note g7  $01
	note as7 $01
	note c8  $01
	vol $a
	note g7  $01
	note as7 $01
	note c8  $01
	vol $a
	note g7  $01
	note as7 $01
	note c8  $01
	vol $a
	note g7  $01
	note as7 $01
	note c8  $01
	cmdf8 $00
	vol $d
	cmdf8 $10
	note g7  $01
	note as7 $01
	note cs8 $01
	vol $b
	note g7  $01
	note b7  $01
	note cs8 $01
	vol $b
	note g7  $01
	note b7  $01
	note cs8 $01
	vol $b
	note g7  $01
	note b7  $01
	note cs8 $01
	cmdf8 $00
	vol $b
	note g7  $01
	note b7  $01
	note cs8 $01
	cmdff

sound5dStart:

sound5dChannel2:
	duty $00
	vol $d
	note b5  $01
	vol $8
	note cs5 $01
	note as4 $01
	note gs5 $01
	note as4 $01
	note gs4 $01
	note f5  $01
	note gs4 $01
	note g4  $01
	note ds5 $01
	note g4  $01
	note f4  $01
	vol $9
	note b5  $01
	vol $5
	note cs5 $01
	note as4 $01
	note gs5 $01
	note as4 $01
	note gs4 $01
	note f5  $01
	note gs4 $01
	note g4  $01
	note ds5 $01
	note g4  $01
	note f4  $01
	vol $6
	note b5  $01
	vol $3
	note cs5 $01
	note as4 $01
	note gs5 $01
	note as4 $01
	note gs4 $01
	note f5  $01
	note gs4 $01
	note g4  $01
	note ds5 $01
	note g4  $01
	note f4  $01
	vol $3
	note b5  $01
	vol $2
	note cs5 $01
	note as4 $01
	note gs5 $01
	note as4 $01
	note gs4 $01
	note f5  $01
	note gs4 $01
	note g4  $01
	note ds5 $01
	note g4  $01
	note f4  $01
	vol $1
	note b5  $01
	vol $1
	note cs5 $01
	note as4 $01
	note gs5 $01
	note as4 $01
	note gs4 $01
	note f5  $01
	note gs4 $01
	note g4  $01
	note ds5 $01
	note g4  $01
	note f4  $01
	cmdff

sound64Start:

sound64Channel5:
	duty $03
	vibrato $08
	vol $9
	note fs5 $05
	note a5  $05
	note c6  $05
	vol $9
	note f5  $05
	note gs5 $05
	note b5  $05
	vol $9
	note e5  $05
	note g5  $05
	note as5 $05
	vol $9
	note ds5 $05
	note fs5 $05
	note a5  $05
	vol $9
	note d5  $05
	note f5  $05
	note gs5 $05
	vol $9
	note cs5 $05
	note e5  $05
	note g5  $05
	vol $9
	note c5  $05
	note ds5 $05
	note fs5 $05
	vol $9
	note b4  $05
	note d5  $05
	note f5  $05
	vol $3
	note fs4 $02
	cmdff

sound65Start:

sound65Channel5:
	duty $03
	note c6  $02
	note b5  $02
	note as5 $02
	note a5  $02
	note as5 $02
	note b5  $02
	note as5 $02
	note gs5 $02
	note a5  $02
	note as5 $02
	note a5  $02
	note g5  $02
	note gs5 $02
	note a5  $02
	note gs5 $02
	note fs5 $02
	note g5  $02
	note gs5 $02
	note g5  $02
	note f5  $02
	note fs5 $02
	note g5  $02
	note fs5 $02
	note e5  $02
	note f5  $02
	note fs5 $02
	note f5  $02
	note ds5 $02
	note e5  $02
	note f5  $02
	note e5  $02
	note d5  $02
	note ds5 $02
	note e5  $02
	note ds5 $02
	cmdff

sound63Start:

sound63Channel2:
	cmdf0 $3c
	vol $f
	.db $04 $16 $01
	vol $f
	.db $06 $0b $01
	vol $f
	.db $04 $84 $01
	vol $f
	.db $06 $42 $01
	vol $f
	.db $04 $e5 $01
	vol $f
	.db $06 $73 $01
	vol $f
	.db $05 $3c $01
	vol $f
	.db $06 $9e $01
	vol $f
	.db $05 $8a $01
	vol $f
	.db $06 $c5 $01
	vol $f
	.db $05 $ce $01
	vol $f
	.db $06 $e7 $01
	vol $f
	.db $05 $ac $01
	vol $f
	.db $06 $d6 $01
	vol $f
	.db $05 $8a $01
	vol $f
	.db $06 $c5 $01
	vol $f
	.db $05 $64 $01
	vol $f
	.db $06 $b2 $01
	vol $f
	.db $05 $3c $01
	vol $f
	.db $06 $9e $01
	vol $f
	.db $05 $12 $01
	vol $f
	.db $06 $89 $01
	vol $f
	.db $04 $e5 $01
	vol $f
	.db $06 $73 $01
	vol $f
	.db $04 $b6 $01
	vol $f
	.db $06 $5b $01
	vol $f
	.db $04 $84 $01
	vol $f
	.db $06 $42 $01
	vol $f
	.db $04 $4f $01
	vol $f
	.db $06 $27 $01
	vol $f
	.db $03 $9b $01
	vol $f
	.db $05 $ce $01
	vol $6
	.db $05 $ac $01
	vol $6
	.db $06 $d6 $01
	vol $6
	.db $05 $8a $01
	vol $6
	.db $06 $c5 $01
	vol $6
	.db $05 $64 $01
	vol $6
	.db $06 $b2 $01
	vol $6
	.db $05 $3c $01
	vol $6
	.db $06 $9e $01
	vol $6
	.db $05 $12 $01
	vol $6
	.db $06 $89 $01
	vol $6
	.db $04 $e5 $01
	vol $6
	.db $06 $73 $01
	vol $6
	.db $04 $b6 $01
	vol $6
	.db $06 $5b $01
	vol $6
	.db $04 $84 $01
	vol $6
	.db $06 $42 $01
	vol $6
	.db $04 $4f $01
	vol $6
	.db $06 $27 $01
	vol $6
	.db $03 $9b $01
	vol $6
	.db $05 $ce $01
	cmdff

sound6fStart:

sound6fChannel7:
	cmdf0 $f1
	note $64 $01
	cmdf0 $f1
	note $56 $01
	cmdf0 $f1
	note $47 $02
	cmdf0 $f1
	note $54 $03
	cmdf0 $f1
	note $55 $04
	cmdf0 $c0
	note $56 $04
	cmdf0 $85
	note $56 $0a
	cmdf0 $65
	note $56 $0a
	cmdf0 $45
	note $56 $0a
	cmdf0 $25
	note $56 $0a
	cmdff

sound70Start:

sound70Channel2:
	duty $01
	vol $0
	rest $02
	vol $6
	note c4  $01
	cmdf8 $0f
	note c4  $05
	cmdf8 $00
	cmdff

sound70Channel7:
	cmdf0 $d0
	note $24 $02
	cmdf0 $b0
	note $46 $01
	note $47 $01
	note $54 $01
	note $55 $01
	note $56 $01
	note $57 $01
	cmdf0 $00
	note $00 $01
	cmdf0 $60
	note $24 $02
	note $56 $02
	note $57 $05
	cmdf0 $20
	note $24 $02
	note $56 $02
	note $57 $05
	cmdff

sound71Start:

sound71Channel7:
	cmdf0 $60
	note $65 $02
	cmdf0 $80
	note $65 $02
	cmdf0 $a0
	note $65 $02
	cmdf0 $b0
	note $65 $02
	cmdf0 $d0
	note $65 $02
	cmdf0 $50
	note $55 $05
	cmdf0 $d0
	note $65 $03
	note $57 $02
	cmdf0 $d0
	note $55 $05
	cmdf0 $d0
	note $65 $04
	cmdff

sound72Start:

sound72Channel7:
	cmdf0 $30
	note $67 $01
	cmdf0 $40
	note $66 $01
	cmdf0 $50
	note $65 $01
	cmdf0 $60
	note $64 $01
	cmdf0 $70
	note $57 $01
	cmdf0 $80
	note $55 $01
	cmdf0 $90
	note $54 $01
	cmdf0 $a1
	note $47 $01
	cmdf0 $a0
	note $46 $01
	note $45 $01
	note $46 $01
	note $47 $01
	note $55 $01
	cmdf0 $80
	note $57 $01
	note $64 $01
	cmdf0 $50
	note $65 $02
	note $66 $02
	cmdff

sound68Start:

sound68Channel2:
	duty $01
	vibrato $0b
	vol $c
	cmdf8 $36
	note c3  $08
	cmdf8 $00
	vol $9
	note gs5 $01
	note b4  $01
	vol $9
	cmdf8 $18
	note g3  $06
	cmdf8 $00
	vol $7
	note gs5 $01
	note b4  $01
	vol $7
	cmdf8 $18
	note g3  $06
	cmdf8 $00
	vol $7
	note gs5 $01
	note b4  $01
	cmdff

sound80Start:

sound80Channel7:
	cmdf0 $91
	note $44 $01
	cmdf0 $70
	note $36 $01
	cmdf0 $00
	note $00 $01
	cmdf0 $91
	note $27 $01
	cmdf0 $61
	note $35 $02
	cmdf0 $20
	note $44 $03
	cmdf0 $91
	note $44 $01
	cmdf0 $70
	note $36 $01
	cmdf0 $00
	note $00 $01
	cmdf0 $91
	note $27 $01
	cmdf0 $61
	note $35 $02
	cmdf0 $26
	note $44 $0c
	cmdff

sound81Start:

sound81Channel2:
	duty $00
	vol $f
	note ds2 $03
	vol $0
	rest $01
	vol $f
	note ds2 $01
	vol $f
	note ds2 $02
	vol $0
	rest $01
	vol $f
	env $0 $01
	note c2  $0a
	cmdff

sound81Channel7:
	cmdf0 $f1
	note $55 $03
	cmdf0 $01
	note $55 $01
	cmdf0 $f1
	note $35 $01
	cmdf0 $f1
	note $46 $02
	cmdf0 $01
	note $55 $01
	cmdf0 $f1
	note $36 $01
	cmdf0 $f6
	note $55 $0a
	cmdf0 $96
	note $57 $46
	cmdff

sound82Start:

sound82Channel2:
	duty $00
	vol $0
	rest $05
	vol $f
	note c2  $01
	vol $e
	note cs2 $01
	vol $d
	note c2  $01
	vol $c
	note d2  $01
	vol $b
	note cs2 $01
	vol $a
	note e2  $01
	vol $9
	note c2  $01
	vol $8
	note d2  $01
	vol $7
	note cs2 $01
	vol $6
	note ds2 $01
	vol $5
	note c2  $01
	vol $4
	note ds2 $01
	vol $3
	note cs2 $01
	vol $2
	note ds2 $01
	cmdff

sound82Channel7:
	cmdf0 $f1
	note $52 $01
	note $56 $03
	cmdf0 $01
	note $00 $01
	cmdf0 $f1
	note $52 $01
	note $56 $03
	note $64 $04
	note $57 $06
	cmdf0 $43
	note $57 $1e
	cmdff

sound7bStart:

sound7bChannel2:
	duty $00
	vol $6
	note b4  $04
	note d5  $04
	vol $7
	note fs5 $04
	note as5 $04
	vol $8
	note b5  $04
	note d6  $04
	vol $9
	note fs6 $04
	note as6 $04
	vol $5
	note b5  $04
	note d6  $04
	note fs6 $04
	note as6 $04
	vol $1
	note b5  $04
	note d6  $04
	note fs6 $04
	note as6 $04
	cmdff

sound7eStart:

sound7eChannel2:
	duty $02
	vol $d
	note e5  $01
	vol $0
	rest $03
	vol $a
	note a5  $01
	vol $0
	rest $03
	vol $8
	note b5  $01
	vol $0
	rest $03
	vol $a
	note a5  $01
	vol $0
	rest $03
	vol $d
	note e5  $01
	cmdff

sound7cStart:

sound7cChannel2:
	duty $01
musice9a8c:
	vol $9
	cmdf8 $64
	note b2  $04
	cmdf8 $00
	vol $b
	cmdf8 $64
	note b2  $04
	cmdf8 $00
	vol $e
	cmdf8 $64
	note b2  $04
	cmdf8 $00
	vol $9
	cmdf8 $64
	note b2  $04
	cmdf8 $00
	vol $8
	cmdf8 $64
	note b2  $04
	cmdf8 $00
	vol $7
	cmdf8 $64
	note b2  $04
	cmdf8 $00
	vol $6
	cmdf8 $64
	note b2  $04
	cmdf8 $00
	vol $5
	cmdf8 $64
	note b2  $04
	cmdf8 $00
	vol $4
	cmdf8 $64
	note b2  $04
	cmdf8 $00
	vol $3
	cmdf8 $64
	note b2  $04
	cmdf8 $00
	goto musice9a8c
	cmdff

sound69Start:

sound69Channel2:
	duty $02
	vol $d
	note c4  $01
	note c5  $01
	note g3  $01
	note g4  $01
	note c5  $01
	note c4  $01
	note as4 $01
	note as3 $01
	note a4  $01
	note a3  $01
	note g4  $01
	note g3  $01
	note f4  $01
	note f3  $01
	note ds4 $01
	note ds3 $01
	vol $b
	note cs4 $01
	vol $a
	note cs3 $01
	vol $9
	note b3  $01
	vol $8
	note b2  $01
	vol $5
	note c2  $01
	note c3  $01
	note c2  $01
	note c3  $01
	note c2  $01
	note c3  $01
	note c2  $01
	note c3  $01
	note c2  $01
	note c3  $01
	note c2  $01
	note c3  $01
	note c2  $01
	note c3  $01
	note c2  $01
	note c3  $01
	cmdff

sound67Start:

sound67Channel2:
	duty $00
	vol $f
	note c3  $01
	vol $0
	rest $01
	vol $f
	note c3  $01
	vol $0
	rest $01
	vol $f
	note cs3 $01
	vol $0
	rest $01
	vol $f
	note cs3 $01
	vol $0
	rest $01
	vol $f
	note d3  $01
	vol $0
	rest $01
	vol $f
	note d3  $01
	vol $0
	rest $01
	vol $f
	note ds3 $01
	vol $0
	rest $01
	vol $f
	note ds3 $01
	vol $0
	rest $01
	vol $f
	note e3  $01
	vol $0
	rest $01
	vol $f
	note e3  $01
	vol $0
	rest $01
	vol $f
	note f3  $01
	vol $0
	rest $01
	vol $f
	note f3  $01
	vol $0
	rest $01
	vol $f
	note fs3 $01
	vol $0
	rest $01
	vol $f
	note fs3 $01
	vol $0
	rest $01
	vol $f
	note fs3 $01
	vol $0
	rest $01
	vol $f
	note fs3 $01
	vol $0
	rest $01
	vol $f
	note g3  $01
	vol $0
	rest $01
	vol $f
	note g3  $01
	vol $0
	rest $01
	vol $f
	note g3  $01
	vol $0
	rest $01
	vol $f
	note c3  $01
	vol $0
	rest $01
	vol $f
	note c3  $01
	vol $0
	rest $01
	vol $f
	note c3  $01
	vol $0
	rest $01
	vol $f
	note c3  $01
	vol $0
	rest $01
	vol $f
	note c3  $01
	vol $0
	rest $01
	vol $f
	note c3  $01
	vol $0
	rest $01
	vol $f
	note c3  $01
	vol $0
	rest $01
	vol $f
	note a3  $01
	vol $0
	rest $01
	vol $f
	note a3  $01
	vol $0
	rest $01
	vol $f
	note gs3 $01
	vol $0
	rest $01
	vol $f
	note gs3 $01
	vol $0
	rest $01
	vol $f
	note g3  $01
	vol $0
	rest $01
	vol $f
	note g3  $01
	vol $0
	rest $01
	vol $f
	note g3  $01
	vol $0
	rest $01
	vol $f
	note fs3 $01
	vol $0
	rest $01
	vol $f
	note fs3 $01
	vol $0
	rest $01
	vol $f
	note fs3 $01
	vol $0
	rest $01
	vol $f
	note fs3 $01
	vol $0
	rest $01
	vol $f
	note fs3 $01
	vol $0
	rest $01
	vol $f
	note fs3 $01
	vol $0
	rest $01
	vol $f
	note fs3 $01
	vol $0
	rest $01
	vol $f
	note fs3 $01
	vol $0
	rest $01
	vol $f
	note f3  $01
	vol $0
	rest $01
	vol $f
	note f3  $01
	vol $0
	rest $01
	vol $f
	note e3  $01
	vol $0
	rest $01
	vol $f
	note e3  $01
	vol $0
	rest $01
	vol $f
	note ds3 $01
	vol $0
	rest $01
	vol $f
	note ds3 $01
	vol $0
	rest $01
	vol $f
	note d3  $01
	vol $0
	rest $01
	vol $f
	note d3  $01
	vol $0
	rest $01
	vol $f
	note cs3 $01
	vol $0
	rest $01
	vol $f
	note cs3 $01
	vol $0
	rest $01
	vol $f
	note c3  $01
	vol $0
	rest $01
	vol $f
	note c3  $01
	vol $0
	rest $01
	vol $f
	note b2  $01
	vol $0
	rest $01
	vol $f
	note b2  $01
	vol $0
	rest $01
	vol $f
	note as2 $01
	vol $0
	rest $01
	vol $f
	note as2 $01
	vol $0
	rest $01
	vol $3
	note g3  $01
	vol $0
	rest $01
	vol $3
	note fs3 $01
	vol $0
	rest $01
	vol $3
	note f3  $01
	vol $0
	rest $01
	vol $3
	note e3  $01
	vol $0
	rest $01
	vol $3
	note ds3 $01
	vol $0
	rest $01
	vol $3
	note d3  $01
	vol $0
	rest $01
	vol $3
	note cs3 $01
	vol $0
	rest $01
	vol $3
	note c3  $01
	vol $0
	rest $01
	vol $3
	note b2  $01
	vol $0
	rest $01
	vol $3
	note as2 $01
	vol $0
	rest $01
	cmdff

soundd2Start:

soundd2Channel7:
	cmdf0 $f0
	note $00 $01
	cmdf0 $80
	note $24 $02
	cmdf0 $f0
	note $00 $02
	cmdf0 $80
	note $15 $01
	note $17 $02
	cmdf0 $f0
	note $02 $02
	cmdf0 $a0
	note $26 $02
	note $14 $01
	note $17 $02
	cmdf0 $f0
	note $26 $01
	note $27 $01
	note $35 $04
	note $24 $03
	note $26 $03
	note $25 $04
	note $35 $02
	cmdf0 $f2
	note $36 $02
	note $37 $05
	note $36 $01
	note $44 $02
	note $34 $01
	note $55 $01
	note $36 $03
	note $44 $01
	note $37 $03
	note $46 $02
	note $44 $01
	note $37 $02
	note $47 $02
	note $54 $01
	cmdff

soundd3Start:

soundd3Channel7:
	cmdf0 $40
	note $37 $01
	note $36 $01
	note $35 $01
	note $34 $01
	note $27 $01
	note $34 $01
	note $35 $01
	note $36 $01
	note $37 $01
	cmdf0 $60
	note $37 $01
	note $36 $01
	note $35 $01
	note $34 $01
	note $27 $01
	note $34 $01
	note $35 $01
	note $36 $01
	note $37 $01
	cmdf0 $80
	note $37 $01
	note $36 $01
	note $35 $01
	note $34 $01
	note $27 $01
	note $34 $01
	note $35 $01
	note $36 $01
	note $37 $01
	cmdf0 $90
	note $37 $01
	note $36 $01
	note $35 $01
	note $34 $01
	note $27 $01
	note $34 $01
	note $35 $01
	note $36 $01
	note $37 $01
	cmdf0 $b0
	note $37 $01
	note $36 $01
	note $35 $01
	note $34 $01
	note $27 $01
	note $34 $01
	note $35 $01
	note $36 $01
	note $37 $01
	cmdf0 $90
	note $37 $01
	note $36 $01
	note $35 $01
	note $34 $01
	note $27 $01
	note $34 $01
	note $35 $01
	note $36 $01
	note $37 $01
	cmdf0 $70
	note $37 $01
	note $36 $01
	note $35 $01
	note $34 $01
	note $27 $01
	note $34 $01
	note $35 $01
	note $36 $01
	note $37 $01
	cmdf0 $56
	note $36 $03
	note $35 $03
	note $34 $03
	note $27 $19
	cmdff
	duty $00
	vol $9
	cmdf8 $7f
	note d3  $03
	cmdf8 $00
	cmdf8 $81
	note a3  $03
	cmdf8 $00
	vol $f
	cmdf8 $ef
	note a2  $32
	cmdff
	cmdf0 $40
	.db $44 $02 $45
	.db $02 $46 $02
	cmdf0 $40
	.db $46 $28 $47
	.db $02 $54 $02
	.db $55 $02 $56
	.db $02 $57 $02
	cmdff

soundd0Start:

soundd0Channel2:
	duty $00
	vol $c
	cmdf8 $20
	note a4  $01
	cmdf8 $00
	vol $7
	note c5  $01
	note ds5 $01
	vol $6
	note cs5 $01
	note e5  $01
	vol $5
	note cs5 $01
	note e5  $01
	vol $4
	note cs5 $01
	note e5  $01
	vol $3
	note d5  $01
	note f5  $01
	vol $2
	note d5  $01
	note f5  $01
	vol $1
	note ds5 $01
	note fs5 $01
	cmdff

soundd0Channel7:
	cmdf0 $f0
	note $34 $01
	cmdf0 $e0
	note $34 $01
	cmdf0 $b5
	note $24 $01
	note $24 $02
	note $24 $02
	note $17 $02
	note $17 $03
	note $16 $28
	cmdff

sound83Start:

sound83Channel2:
	duty $00
	cmdf0 $df
	.db $07 $d8 $05
	vol $d
	.db $07 $de $03
	vol $7
	.db $07 $e1 $03
	vol $5
	.db $07 $e3 $05
	vol $b
	.db $07 $d8 $05
	vol $9
	.db $07 $de $03
	vol $6
	.db $07 $e1 $03
	vol $4
	.db $07 $e3 $05
	vol $9
	.db $07 $d8 $05
	vol $8
	.db $07 $de $03
	vol $5
	.db $07 $e1 $03
	vol $3
	.db $07 $e3 $05
	vol $2
	.db $07 $d8 $05
	vol $1
	env $0 $03
	.db $07 $de $04
	cmdff

sound84Start:

sound84Channel2:
	duty $02
	cmdf0 $d9
	.db $07 $a0 $03
	vol $1
	.db $07 $a0 $05
	cmdff

sound85Start:

sound85Channel2:
	duty $02
	vol $f
	cmdf8 $ce
	note a2  $06
	cmdf8 $00
	vol $e
	cmdf8 $50
	note f2  $06
	cmdf8 $00
	vol $a
	cmdf8 $ce
	note a2  $06
	cmdf8 $00
	vol $8
	cmdf8 $50
	note f2  $06
	cmdf8 $00
	vol $7
	cmdf8 $ce
	note a2  $06
	cmdf8 $00
	vol $6
	cmdf8 $50
	note f2  $06
	cmdf8 $00
	vol $5
	cmdf8 $ce
	note a2  $06
	cmdf8 $00
	vol $4
	cmdf8 $50
	note f2  $06
	cmdf8 $00
	vol $3
	env $0 $03
	cmdf8 $ce
	note a2  $06
	cmdf8 $00
	cmdff

sound86Start:

sound86Channel2:
	cmdff

sound8dStart:

sound8dChannel2:
	duty $01
	vol $1
	note as3 $01
	vol $1
	note a2  $01
	vol $1
	note gs3 $01
	vol $1
	note b3  $01
	vol $1
	note as2 $01
	vol $1
	note a3  $01
	vol $2
	note c4  $01
	vol $1
	note b2  $01
	vol $1
	note as3 $01
	vol $3
	note cs4 $01
	vol $1
	note c3  $01
	vol $1
	note b3  $01
	vol $4
	note d4  $01
	vol $2
	note cs3 $01
	vol $2
	note c4  $01
	vol $5
	note ds4 $01
	vol $3
	note d3  $01
	vol $3
	note cs4 $01
	vol $6
	note e4  $01
	vol $4
	note ds3 $01
	vol $4
	note d4  $01
	vol $7
	note f4  $01
	vol $5
	note e3  $01
	vol $5
	note ds4 $01
	vol $8
	note fs4 $01
	vol $6
	note f3  $01
	vol $6
	note e4  $01
	vol $9
	note g4  $01
	vol $7
	note fs3 $01
	vol $7
	note f4  $01
	vol $a
	note gs4 $01
	vol $8
	note g3  $01
	vol $8
	note fs4 $01
	vol $b
	note a4  $01
	vol $9
	note gs3 $01
	vol $9
	note g4  $01
	vol $c
	note as4 $01
	vol $a
	note a3  $01
	vol $a
	note gs4 $01
	vol $d
	note b4  $01
	vol $b
	note as3 $01
	vol $a
	note gs4 $01
	vol $e
	note c5  $01
	vol $c
	note b3  $01
	vol $9
	note a4  $01
	vol $d
	note cs5 $01
	vol $b
	note c4  $01
	vol $8
	note as4 $01
	vol $c
	note d5  $01
	vol $a
	note cs4 $01
	vol $7
	note b4  $01
	vol $b
	note ds5 $01
	vol $9
	note d4  $01
	vol $6
	note c5  $01
	vol $a
	note e5  $01
	vol $8
	note ds4 $01
	vol $5
	note cs5 $01
	vol $9
	note f5  $01
	vol $7
	note e4  $01
	vol $4
	note d5  $01
	vol $8
	note fs5 $01
	vol $6
	note f4  $01
	vol $3
	note ds5 $01
	vol $7
	note g5  $01
	vol $5
	note fs4 $01
	vol $2
	note e5  $01
	vol $6
	note gs5 $01
	vol $4
	note g4  $01
	vol $1
	note f5  $01
	vol $5
	note a5  $01
	vol $3
	note gs4 $01
	vol $1
	note fs5 $01
	vol $4
	note as5 $01
	vol $2
	note a4  $01
	vol $1
	note g5  $01
	vol $3
	note b5  $01
	vol $1
	note as4 $01
	vol $2
	note c6  $01
	vol $1
	note b4  $01
	vol $1
	note cs6 $01
	vol $1
	note c5  $01
	vol $1
	note d6  $01
	cmdff
	cmdff

soundd5Start:

soundd5Channel2:
	cmdff
	cmdff

soundc0Start:

soundc0Channel2:
	duty $00
	vol $3
	note b6  $02
	vol $8
	note b6  $02
	vol $a
	note b6  $02
	vol $a
	note b5  $03
	vol $9
	note f5  $03
	vol $8
	note c5  $03
	vol $7
	note fs5 $03
	vol $4
	note f5  $03
	vol $4
	note c5  $03
	vol $4
	note fs5 $03
	vol $2
	note f5  $03
	vol $2
	note c5  $03
	vol $2
	note fs5 $03
	cmdff

soundbfStart:

soundbfChannel2:
	duty $00
	cmdf0 $d9
	.db $06 $0b $01
	.db $06 $0d $01
	.db $06 $0f $01
	.db $06 $11 $01
	.db $06 $13 $01
	.db $06 $15 $01
	.db $06 $17 $01
	.db $06 $19 $01
	.db $06 $1b $01
	.db $06 $1d $01
	.db $06 $1f $01
	.db $06 $21 $01
	.db $06 $23 $01
	.db $06 $25 $01
	.db $06 $27 $01
	.db $06 $28 $01
	.db $06 $2a $01
	.db $06 $2c $01
	.db $06 $2e $01
	.db $06 $30 $01
	.db $06 $32 $01
	.db $06 $34 $01
	.db $06 $36 $01
	.db $06 $38 $01
	.db $06 $3a $01
	.db $06 $3c $01
	.db $06 $3e $01
	.db $06 $40 $01
	.db $06 $42 $01
	.db $06 $44 $01
	.db $06 $46 $01
	.db $06 $48 $01
	.db $06 $4a $01
	.db $06 $4c $01
	.db $06 $4e $01
	.db $06 $50 $01
	.db $06 $52 $01
	.db $06 $54 $01
	.db $06 $56 $01
	.db $06 $58 $01
	.db $06 $5a $01
	.db $06 $5c $01
	.db $06 $5e $01
	.db $06 $60 $01
	.db $06 $62 $01
	.db $06 $64 $01
	.db $06 $66 $01
	.db $06 $68 $01
	.db $06 $6a $01
	.db $06 $6c $01
	.db $06 $6e $01
	.db $06 $70 $01
	.db $06 $72 $01
	.db $06 $74 $01
	.db $06 $76 $01
	.db $06 $78 $01
	.db $06 $7a $01
	.db $06 $7c $01
	.db $06 $7e $01
	.db $06 $80 $01
	.db $06 $82 $01
	.db $06 $84 $01
	.db $06 $86 $01
	.db $06 $88 $01
	.db $06 $8a $01
	.db $06 $8c $01
	.db $06 $8e $01
	.db $06 $90 $01
	.db $06 $92 $01
	.db $06 $94 $01
	.db $06 $96 $01
	.db $06 $98 $01
	.db $06 $9a $01
	.db $06 $9c $01
	.db $06 $9e $01
	.db $06 $a0 $01
	.db $06 $a2 $01
	.db $06 $a4 $01
	.db $06 $a6 $01
	.db $06 $a8 $01
	.db $06 $aa $01
	.db $06 $ac $01
	.db $06 $ae $01
	.db $06 $b0 $01
	.db $06 $b2 $01
	.db $06 $b4 $01
	.db $06 $b6 $01
	.db $06 $b8 $01
	.db $06 $ba $01
	.db $06 $bc $01
	.db $06 $be $01
	.db $06 $c0 $01
	.db $06 $c2 $01
	.db $06 $c4 $01
	.db $06 $c6 $01
	.db $06 $c8 $01
	.db $06 $ca $01
	.db $06 $cc $01
	.db $06 $ce $01
	.db $06 $d0 $01
	.db $06 $d2 $01
	.db $06 $d4 $01
	.db $06 $d6 $01
	.db $06 $d8 $01
	.db $06 $da $01
	.db $06 $dc $01
	.db $06 $de $01
	.db $06 $e0 $01
	.db $06 $e2 $01
	.db $06 $e4 $01
	.db $06 $e6 $01
	.db $06 $e8 $01
	.db $06 $ea $01
	.db $06 $ec $01
	.db $06 $ee $01
	.db $06 $f0 $01
	.db $06 $f2 $01
	.db $06 $f4 $01
	.db $06 $f6 $01
	.db $06 $f8 $01
	cmdff

sound92Start:

sound92Channel2:
	cmdff

sound9dStart:

sound9dChannel3:
	vol $0
	rest $f1
	cmdff

sound9dChannel2:
	vol $0
	duty $02
	rest $1f
	vol $2
	note c6  $05
	note f6  $04
	note g6  $05
	note c7  $46
	vol $0
	note c7  $0e
	vol $2
	note as6 $05
	note c7  $04
	note as6 $05
	note a6  $0e
	note f6  $0e
	note g6  $04
	vol $0
	note g6  $0a
	vol $2
	note c6  $38
	cmdff

sound9dChannel5:
	duty $16
	note c6  $04
	note f6  $05
	note g6  $05
	note c7  $46
	rest $0e
	note as6 $04
	note c7  $05
	note as6 $05
	note a6  $0e
	note f6  $0e
	note g6  $03
	rest $0b
	note c6  $38
	rest $1f
	cmdff

sound9dChannel7:
	cmdf0 $00
	note $00 $f1
	cmdff

sound9eStart:

sound9eChannel3:
	vol $0
	rest $f1
	cmdff

sound9eChannel2:
	vol $0
	rest $1f
	duty $02
	vol $2
	note d5  $05
	note g5  $04
	note a5  $05
	note c6  $46
	rest $0e
	note b5  $05
	note c6  $04
	note b5  $05
	note g5  $0e
	note a5  $54
	cmdff

sound9eChannel5:
	duty $16
	note d5  $04
	note g5  $05
	note a5  $05
	note c6  $46
	rest $0e
	note b5  $04
	note c6  $05
	note b5  $05
	note g5  $0e
	note a5  $54
	rest $1f
	cmdff

sound9eChannel7:
	cmdf0 $00
	note $00 $f1
	cmdff

sound9fStart:

sound9fChannel3:
	vol $0
	rest $e5
	cmdff

sound9fChannel2:
	vol $0
	rest $0d
	duty $02
	vol $2
	note ds6 $12
	note as5 $12
	note as6 $1b
	rest $09
	note g6  $12
	note ds6 $12
	note c7  $1b
	rest $09
	note as6 $48
	cmdff

sound9fChannel5:
	duty $16
	note ds6 $12
	note as5 $12
	note as6 $1b
	rest $09
	note g6  $12
	note ds6 $12
	note c7  $1b
	rest $09
	note as6 $48
	rest $0d
	cmdff

sound9fChannel7:
	cmdf0 $00
	note $00 $e5
	cmdff

sound4aStart:

sound4aChannel1:
	vol $0
	note gs3 $07
	vibrato $e1
	env $0 $00
	cmdf2
	duty $02
musicea200:
	vol $6
	note g4  $0e
	rest $03
	vol $3
	note g4  $0b
	vol $6
	note d4  $15
	note g4  $07
	note c5  $0e
	note b4  $0e
	note a4  $0e
	note g4  $0e
	note a4  $1c
	note d4  $0e
	rest $03
	vol $3
	note d4  $04
	vol $6
	note c4  $07
	note d4  $2a
	vibrato $01
	env $0 $00
	vol $3
	note d4  $0e
	vibrato $e1
	env $0 $00
	vol $6
	note e4  $0e
	rest $03
	vol $3
	note e4  $0b
	vol $6
	note e4  $09
	note c4  $09
	note e4  $0a
	note fs4 $0e
	rest $03
	vol $3
	note fs4 $0b
	vol $6
	note fs4 $09
	vol $6
	note e4  $09
	note fs4 $0a
	note g4  $0e
	rest $03
	vol $3
	note g4  $0b
	vol $6
	note g4  $09
	note fs4 $09
	note g4  $0a
	note b4  $0e
	rest $07
	vol $3
	note b4  $07
	vol $6
	note a4  $0e
	rest $07
	vol $3
	note a4  $07
	vol $6
	note d5  $0e
	rest $03
	vol $3
	note d5  $0b
	vol $6
	note d5  $0e
	rest $03
	vol $3
	note d5  $04
	vol $6
	note d5  $07
	note c5  $0e
	note b4  $0e
	note a4  $0e
	note g4  $0e
	note b4  $1c
	note a4  $15
	note g4  $07
	note a4  $2a
	vibrato $01
	env $0 $00
	vol $3
	note a4  $0e
	vibrato $e1
	env $0 $00
	vol $6
	note g4  $0e
	rest $07
	vol $3
	note g4  $07
	vol $6
	note g4  $09
	note ds4 $09
	note g4  $0a
	note a4  $0e
	rest $07
	vol $3
	note a4  $07
	vol $6
	note a4  $09
	note f4  $09
	note a4  $0a
	note as4 $0e
	rest $07
	vol $3
	note as4 $07
	vol $6
	note as4 $09
	note g4  $09
	note as4 $0a
	note a4  $0e
	note as4 $0e
	note c5  $0e
	note cs5 $0e
	duty $01
	note d5  $0e
	rest $07
	vol $3
	note d5  $07
	vol $6
	note d5  $0e
	rest $03
	vol $3
	note d5  $04
	vol $6
	note d5  $07
	note ds5 $0e
	note d5  $0e
	note c5  $0e
	note as4 $07
	rest $03
	vol $3
	note as4 $04
	vol $6
	note as4 $1c
	note a4  $0e
	rest $03
	vol $3
	note a4  $04
	vol $6
	note g4  $07
	note f4  $1c
	vol $3
	note f4  $1c
	vol $6
	note as4 $0e
	rest $07
	vol $3
	note as4 $07
	vol $6
	note as4 $0e
	rest $03
	vol $3
	note as4 $04
	vol $6
	note as4 $07
	note c5  $0e
	note as4 $0e
	note c5  $0e
	note as4 $0e
	note c5  $07
	rest $03
	vol $3
	note c5  $07
	rest $04
	vol $6
	note d5  $03
	rest $04
	note d5  $38
	vibrato $01
	env $0 $00
	vol $3
	note d5  $1c
	vibrato $e1
	env $0 $00
	vol $6
	note e5  $07
	rest $03
	vol $3
	note e5  $07
	rest $04
	vol $1
	note e5  $07
	vol $6
	note e5  $07
	rest $03
	vol $3
	note e5  $07
	rest $04
	vol $6
	note e5  $04
	rest $03
	note e5  $07
	rest $03
	vol $3
	note e5  $07
	rest $04
	vol $1
	note e5  $07
	vol $6
	note a4  $04
	note b4  $05
	note cs5 $05
	note d5  $04
	note ds5 $05
	note e5  $05
	note fs5 $07
	rest $03
	vol $3
	note fs5 $07
	rest $04
	vol $1
	note fs5 $07
	vol $6
	note fs5 $07
	rest $03
	vol $3
	note fs5 $07
	rest $04
	vol $6
	note fs5 $04
	rest $03
	note fs5 $07
	rest $03
	vol $3
	note fs5 $07
	rest $04
	vol $1
	note fs5 $07
	rest $1c
	vol $6
	note g5  $0e
	rest $03
	vol $3
	note g5  $0b
	vol $6
	note g5  $09
	note ds5 $09
	note g5  $0a
	note a5  $0e
	rest $03
	vol $3
	note a5  $0b
	vol $6
	note a5  $09
	note f5  $09
	note a5  $0a
	note as5 $0e
	rest $03
	vol $3
	note as5 $0b
	vol $6
	note as5 $09
	note g5  $09
	note as5 $0a
	note c6  $0e
	rest $03
	vol $3
	note c6  $0b
	vol $6
	note c6  $09
	note a5  $09
	note c6  $0a
	note d6  $07
	rest $03
	vol $3
	note d6  $07
	rest $04
	vol $1
	note d6  $07
	vol $6
	note d6  $07
	rest $03
	vol $3
	note d6  $07
	rest $04
	vol $6
	note d6  $03
	rest $04
	note d6  $38
	vibrato $01
	env $0 $00
	vol $3
	note d6  $1c
	rest $54
	vibrato $e1
	env $0 $00
	vol $6
	note d6  $07
	rest $03
	vol $3
	note d6  $07
	rest $04
	vol $1
	note d6  $07
	vol $6
	note d6  $07
	rest $03
	vol $3
	note d6  $07
	rest $04
	vol $6
	note d6  $03
	rest $04
	note d6  $38
	vibrato $01
	env $0 $00
	vol $3
	note d6  $1c
	rest $54
	vibrato $e1
	env $0 $00
	duty $02
	goto musicea200
	cmdff

sound4aChannel0:
	vol $0
	note gs3 $07
	vibrato $e1
	env $0 $00
	cmdf2
	duty $02
musicea42f:
	rest $1c
	vol $6
	note b2  $1c
	note d3  $1c
	note g3  $1c
	note f3  $31
	note e3  $07
	note d3  $1c
	vol $3
	note d3  $0e
	vol $6
	note a3  $07
	note gs3 $07
	note g3  $0e
	vol $3
	note g3  $0e
	vol $6
	note g3  $09
	note e3  $09
	note g3  $0a
	note a3  $0e
	vol $3
	note a3  $0e
	vol $6
	note a3  $09
	note fs3 $09
	note a3  $0a
	note b3  $0e
	vol $3
	note b3  $0e
	vol $6
	note b3  $09
	note a3  $09
	note b3  $0a
	note d4  $0e
	vol $3
	note d4  $0e
	vol $6
	note d4  $07
	note c4  $07
	note b3  $07
	note a3  $07
	note b3  $0e
	rest $03
	vol $3
	note b3  $0b
	vol $6
	note b3  $0e
	rest $03
	vol $3
	note b3  $04
	vol $6
	note b3  $07
	note a3  $0e
	note g3  $04
	note a3  $05
	note g3  $05
	note fs3 $0e
	note e3  $0e
	note d3  $07
	rest $03
	vol $3
	note d3  $07
	rest $04
	vol $1
	note d3  $07
	vol $6
	note fs3 $15
	note e3  $07
	note fs3 $07
	rest $03
	vol $3
	note fs3 $04
	vol $6
	note a3  $0e
	note b3  $0e
	note c4  $0e
	note d4  $38
	note ds4 $38
	note f4  $38
	note ds4 $0e
	note d4  $0e
	note ds4 $0e
	note e4  $0e
	note f4  $07
	rest $03
	vol $3
	note f4  $04
	vol $6
	note as3 $07
	note f3  $07
	note as3 $07
	rest $03
	vol $3
	note as3 $04
	vol $6
	note as3 $07
	note a3  $07
	vol $6
	note as3 $07
	rest $03
	vol $3
	note as3 $04
	vol $6
	note as3 $07
	note a3  $07
	note as3 $07
	note c4  $07
	note d4  $07
	note as3 $07
	note f3  $07
	rest $03
	vol $3
	note f3  $04
	vol $6
	note f3  $07
	note e3  $07
	note f3  $07
	rest $03
	vol $3
	note f3  $04
	vol $6
	note f3  $07
	note g3  $07
	note a3  $07
	rest $03
	vol $3
	note a3  $04
	vol $6
	note a3  $07
	note as3 $07
	note c4  $07
	note a3  $07
	note as3 $07
	note c4  $07
	note d4  $0e
	rest $03
	vol $3
	note d4  $0b
	vol $6
	note g3  $0e
	rest $03
	vol $3
	note g3  $04
	vol $6
	note g3  $07
	note a3  $0e
	rest $03
	vol $3
	note a3  $0b
	vol $6
	note a3  $07
	note g3  $07
	note f3  $07
	note c4  $07
	note d4  $07
	rest $03
	vol $3
	note d4  $04
	vol $6
	note as3 $07
	note a3  $07
	note as3 $07
	rest $03
	vol $3
	note as3 $04
	vol $6
	note as3 $07
	note a3  $07
	note as3 $07
	rest $03
	vol $3
	note as3 $04
	vol $6
	note as3 $07
	note a3  $07
	note as3 $07
	note c4  $07
	note d4  $07
	note as3 $07
	note cs4 $07
	rest $03
	vol $3
	note cs4 $07
	rest $04
	vol $1
	note cs4 $07
	vol $6
	note cs4 $07
	rest $03
	vol $3
	note cs4 $07
	rest $04
	vol $6
	note cs4 $04
	rest $03
	note cs4 $07
	rest $03
	vol $3
	note cs4 $07
	rest $04
	vol $1
	note cs4 $07
	vol $6
	note a4  $04
	note gs4 $05
	note g4  $05
	note fs4 $04
	note f4  $05
	note e4  $05
	note d4  $07
	rest $03
	vol $3
	note d4  $07
	rest $04
	vol $1
	note d4  $07
	vol $6
	note d4  $07
	rest $03
	vol $3
	note d4  $07
	rest $04
	vol $6
	note d4  $04
	rest $03
	note d4  $07
	rest $03
	vol $3
	note d4  $04
	vol $6
	note d4  $07
	note e4  $07
	note fs4 $07
	note d4  $07
	note e4  $07
	note fs4 $07
	note ds4 $0e
	rest $03
	vol $3
	note ds4 $0b
	vol $6
	note ds4 $09
	note as3 $09
	note ds4 $0a
	note f4  $0e
	rest $03
	vol $3
	note f4  $0b
	vol $6
	note f4  $09
	note c4  $09
	note f4  $0a
	note g4  $0e
	rest $03
	vol $3
	note g4  $0b
	vol $6
	note g4  $09
	note ds4 $09
	note g4  $0a
	note a4  $0e
	note as4 $0e
	note c5  $0e
	note cs5 $0e
	note d5  $07
	rest $03
	vol $3
	note d5  $07
	rest $04
	vol $1
	note d5  $07
	vol $6
	note fs4 $07
	rest $03
	vol $3
	note fs4 $07
	rest $04
	vol $6
	note fs4 $03
	rest $04
	note fs4 $31
	rest $07
	vol $6
	note d4  $0e
	note a3  $07
	note g3  $07
	note d3  $07
	note g3  $07
	note a3  $07
	note c4  $07
	note d4  $0e
	note a3  $07
	note g3  $07
	note d3  $07
	note g3  $07
	note a3  $07
	note c4  $07
	note fs4 $07
	rest $03
	vol $3
	note fs4 $07
	rest $04
	vol $1
	note fs4 $07
	vol $6
	note g4  $09
	note fs4 $09
	note g4  $0a
	note a4  $31
	rest $07
	vol $6
	note d4  $0e
	note a3  $07
	note g3  $07
	note d3  $07
	note g3  $07
	note a3  $07
	note c4  $07
	note d4  $07
	note c4  $07
	note b3  $07
	note a3  $07
	note g3  $07
	note fs3 $07
	note e3  $07
	note d3  $07
	goto musicea42f
	cmdff

sound4aChannel4:
	rest $07
	cmdf2
musicea678:
	duty $0e
	note g2  $07
	duty $0f
	note g2  $07
	duty $0e
	note g2  $07
	duty $0f
	note g2  $0e
	rest $4d
	duty $0e
	note d2  $07
	duty $0f
	note d2  $07
	duty $0e
	note d2  $07
	duty $0f
	note d2  $0e
	rest $4d
	duty $0e
	note c2  $1c
	duty $0f
	note c2  $0e
	duty $0e
	note c2  $07
	duty $0f
	note c2  $07
	duty $0e
	note d2  $1c
	duty $0f
	note d2  $0e
	duty $0e
	note d2  $07
	duty $0f
	note d2  $07
	duty $0e
	note c2  $23
	duty $0f
	note c2  $07
	duty $0e
	note c2  $07
	duty $0f
	note c2  $07
	duty $0e
	note d2  $07
	duty $0f
	note d2  $0e
	rest $07
	duty $0e
	note d2  $07
	note e2  $07
	note fs2 $07
	note d2  $07
	duty $0e
	note g2  $07
	duty $0f
	note g2  $07
	duty $0e
	note g2  $07
	duty $0f
	note g2  $0e
	rest $3f
	duty $0e
	note g2  $0e
	duty $0e
	note d2  $07
	duty $0f
	note d2  $07
	duty $0e
	note d2  $07
	duty $0f
	note d2  $0e
	rest $31
	duty $0e
	note d2  $07
	duty $0f
	note d2  $07
	duty $0e
	note d2  $07
	note cs2 $07
	duty $0e
	note ds2 $23
	duty $0f
	note ds2 $07
	duty $0e
	note ds2 $0e
	duty $0e
	note f2  $23
	duty $0f
	note f2  $07
	duty $0e
	note f2  $07
	duty $0f
	note f2  $07
	duty $0e
	note ds2 $23
	duty $0f
	note ds2 $07
	duty $0e
	note ds2 $0e
	duty $0e
	note f2  $15
	duty $0f
	note f2  $07
	duty $0e
	note f2  $1c
	duty $0e
	note as2 $12
	duty $0f
	note as2 $0a
	duty $0e
	note f2  $12
	duty $0f
	note f2  $0a
	duty $0e
	note as2 $0e
	duty $0f
	note as2 $0e
	duty $0e
	note f2  $0e
	duty $0f
	note f2  $0e
	duty $0e
	note f2  $0e
	duty $0f
	note f2  $0e
	duty $0e
	note g2  $0e
	duty $0f
	note g2  $0e
	duty $0e
	note a2  $0e
	duty $0f
	note a2  $0e
	duty $0e
	note f2  $1c
	duty $0e
	note g2  $07
	duty $0f
	note g2  $07
	duty $0e
	note g2  $07
	duty $0f
	note g2  $0e
	rest $15
	duty $0e
	note f2  $07
	duty $0f
	note f2  $07
	duty $0e
	note f2  $07
	duty $0f
	note f2  $0e
	rest $15
	duty $0e
	note as2 $0e
	duty $0f
	note as2 $0e
	duty $0e
	note f2  $0e
	duty $0f
	note f2  $0e
	duty $0e
	note d2  $0e
	duty $0f
	note d2  $0e
	duty $0e
	note as1 $0e
	duty $0f
	note as1 $0e
	duty $0e
	note a2  $15
	duty $0f
	note a2  $07
	duty $0e
	note a2  $0e
	duty $0f
	note a2  $07
	duty $0e
	note a2  $03
	duty $0f
	note a2  $04
	duty $0e
	note a2  $1c
	duty $0f
	note a2  $0e
	rest $0e
	duty $0e
	note d2  $0e
	duty $0f
	note d2  $0e
	duty $0e
	note d2  $0e
	duty $0f
	note d2  $07
	duty $0e
	note d2  $03
	duty $0f
	note d2  $04
	duty $0e
	note d2  $1c
	duty $0f
	note d2  $0e
	rest $0e
	duty $0e
	note ds2 $0e
	duty $0f
	note ds2 $0e
	duty $0e
	note ds2 $0e
	duty $0f
	note ds2 $0e
	duty $0e
	note f2  $0e
	duty $0f
	note f2  $0e
	duty $0e
	note f2  $0e
	duty $0f
	note f2  $0e
	duty $0e
	note g2  $0e
	duty $0f
	note g2  $0e
	duty $0e
	note g2  $0e
	duty $0f
	note g2  $0e
	duty $0e
	note a2  $0e
	duty $0f
	note a2  $0e
	duty $0e
	note a2  $0e
	duty $0f
	note a2  $0e
	duty $0e
	note d2  $0e
	duty $0f
	note d2  $0e
	duty $0e
	note d2  $0a
	duty $0f
	note d2  $0b
	duty $0e
	note d2  $03
	duty $0f
	note d2  $04
	duty $0e
	note d2  $38
	duty $0f
	note d2  $24
	rest $4c
	duty $0e
	note d2  $0e
	duty $0f
	note d2  $0e
	duty $0e
	note d2  $0a
	duty $0f
	note d2  $0b
	duty $0e
	note d2  $03
	duty $0f
	note d2  $04
	duty $0e
	note d2  $38
	duty $0f
	note d2  $24
	rest $4c
	goto musicea678
	cmdff

sound4aChannel6:
	cmdf2
	vol $3
	note $26 $02
	vol $2
	note $26 $02
	vol $2
	note $26 $03
musicea8a0:
	vol $4
	note $26 $0e
	note $26 $2a
	note $26 $1c
	vol $5
	note $26 $03
	vol $4
	note $26 $04
	vol $3
	note $26 $03
	vol $2
	note $26 $04
	vol $3
	note $26 $03
	vol $3
	note $26 $04
	vol $2
	note $26 $03
	vol $3
	note $26 $04
	vol $4
	note $26 $0e
	note $26 $23
	vol $3
	note $26 $02
	vol $3
	note $26 $02
	vol $4
	note $26 $03
	vol $4
	note $26 $0e
	vol $5
	note $26 $1c
	vol $3
	note $26 $07
	vol $4
	note $26 $07
	vol $5
	note $26 $0e
	vol $3
	note $26 $07
	vol $3
	note $26 $07
	vol $5
	note $26 $0e
	vol $3
	note $26 $0e
	vol $5
	note $26 $0e
	vol $3
	note $26 $07
	vol $3
	note $26 $07
	vol $5
	note $26 $03
	vol $4
	note $26 $04
	vol $3
	note $26 $03
	vol $2
	note $26 $04
	vol $3
	note $26 $03
	vol $3
	note $26 $04
	vol $2
	note $26 $03
	vol $3
	note $26 $04
	vol $4
	note $26 $0e
	note $26 $23
	vol $3
	note $26 $02
	vol $3
	note $26 $02
	vol $4
	note $26 $03
	vol $4
	note $26 $0e
	note $26 $0e
	note $26 $03
	vol $4
	note $26 $04
	vol $3
	note $26 $03
	vol $2
	note $26 $04
	vol $3
	note $26 $03
	vol $3
	note $26 $04
	vol $2
	note $26 $03
	vol $4
	note $26 $04
	vol $4
	note $26 $0e
	note $26 $23
	vol $4
	note $26 $02
	vol $4
	note $26 $02
	vol $4
	note $26 $03
	vol $5
	note $26 $0e
	note $26 $1c
	vol $4
	note $26 $03
	vol $3
	note $26 $04
	vol $2
	note $26 $03
	vol $4
	note $26 $04
	vol $4
	note $26 $0e
	note $26 $23
	vol $3
	note $26 $02
	vol $3
	note $26 $02
	vol $4
	note $26 $03
	vol $4
	note $26 $0e
	vol $4
	note $26 $1c
	vol $3
	note $26 $03
	vol $3
	note $26 $04
	vol $2
	note $26 $03
	vol $4
	note $26 $04
	vol $4
	note $26 $0e
	note $26 $23
	vol $3
	note $26 $02
	vol $3
	note $26 $02
	vol $4
	note $26 $03
	vol $4
	note $26 $1c
	vol $4
	note $26 $03
	vol $4
	note $26 $04
	vol $3
	note $26 $03
	vol $2
	note $26 $04
	vol $3
	note $26 $03
	vol $3
	note $26 $04
	vol $2
	note $26 $03
	vol $3
	note $26 $04
	vol $4
	note $26 $0e
	vol $3
	note $26 $04
	vol $4
	note $26 $05
	vol $4
	note $26 $05
	vol $4
	note $26 $0e
	vol $4
	note $26 $04
	vol $4
	note $26 $05
	vol $4
	note $26 $05
	vol $5
	note $26 $0e
	note $26 $07
	note $26 $07
	vol $4
	note $26 $03
	vol $4
	note $26 $04
	vol $3
	note $26 $03
	vol $2
	note $26 $04
	vol $3
	note $26 $03
	vol $3
	note $26 $04
	vol $2
	note $26 $03
	vol $3
	note $26 $04
	vol $5
	note $26 $0e
	vol $3
	note $26 $03
	vol $3
	note $26 $04
	vol $2
	note $26 $03
	vol $3
	note $26 $04
	vol $5
	note $26 $0e
	vol $3
	note $26 $03
	vol $3
	note $26 $04
	vol $2
	note $26 $03
	vol $3
	note $26 $04
	vol $5
	note $26 $0e
	vol $3
	note $26 $03
	vol $3
	note $26 $04
	vol $2
	note $26 $03
	vol $3
	note $26 $04
	vol $5
	note $26 $0e
	vol $3
	note $26 $03
	vol $3
	note $26 $04
	vol $2
	note $26 $03
	vol $3
	note $26 $04
	vol $5
	note $26 $0e
	vol $3
	note $26 $03
	vol $3
	note $26 $04
	vol $2
	note $26 $03
	vol $3
	note $26 $04
	vol $5
	note $26 $0e
	vol $3
	note $26 $03
	vol $3
	note $26 $04
	vol $2
	note $26 $03
	vol $3
	note $26 $04
	vol $5
	note $26 $0e
	vol $3
	note $26 $03
	vol $3
	note $26 $04
	vol $2
	note $26 $03
	vol $3
	note $26 $04
	vol $5
	note $26 $0e
	vol $3
	note $26 $03
	vol $3
	note $26 $04
	vol $2
	note $26 $03
	vol $3
	note $26 $04
	vol $5
	note $26 $0e
	vol $3
	note $26 $03
	vol $3
	note $26 $04
	vol $2
	note $26 $03
	vol $3
	note $26 $04
	vol $5
	note $26 $0e
	vol $3
	note $26 $03
	vol $3
	note $26 $04
	vol $2
	note $26 $03
	vol $3
	note $26 $04
	vol $5
	note $26 $0e
	vol $3
	note $26 $03
	vol $3
	note $26 $04
	vol $2
	note $26 $03
	vol $3
	note $26 $04
	vol $5
	note $26 $0e
	vol $3
	note $26 $03
	vol $3
	note $26 $04
	vol $2
	note $26 $03
	vol $3
	note $26 $04
	vol $5
	note $26 $0e
	vol $3
	note $26 $03
	vol $3
	note $26 $04
	vol $2
	note $26 $03
	vol $3
	note $26 $04
	vol $5
	note $26 $0e
	vol $3
	note $26 $03
	vol $3
	note $26 $04
	vol $2
	note $26 $03
	vol $3
	note $26 $04
	vol $5
	note $26 $0e
	vol $3
	note $26 $03
	vol $3
	note $26 $04
	vol $2
	note $26 $03
	vol $3
	note $26 $04
	vol $5
	note $26 $0e
	vol $3
	note $26 $03
	vol $3
	note $26 $04
	vol $2
	note $26 $03
	vol $3
	note $26 $04
	vol $5
	note $26 $0e
	vol $3
	note $26 $03
	vol $3
	note $26 $04
	vol $2
	note $26 $03
	vol $3
	note $26 $04
	vol $5
	note $26 $0e
	vol $3
	note $26 $03
	vol $3
	note $26 $04
	vol $2
	note $26 $03
	vol $3
	note $26 $04
	vol $5
	note $26 $0e
	vol $3
	note $26 $03
	vol $3
	note $26 $04
	vol $2
	note $26 $03
	vol $3
	note $26 $04
	vol $5
	note $26 $0e
	vol $3
	note $26 $03
	vol $3
	note $26 $04
	vol $2
	note $26 $03
	vol $3
	note $26 $04
	vol $5
	note $26 $0e
	vol $3
	note $26 $03
	vol $3
	note $26 $04
	vol $2
	note $26 $03
	vol $3
	note $26 $04
	vol $5
	note $26 $0e
	vol $3
	note $26 $03
	vol $3
	note $26 $04
	vol $2
	note $26 $03
	vol $3
	note $26 $04
	vol $5
	note $26 $0e
	vol $3
	note $26 $03
	vol $3
	note $26 $04
	vol $2
	note $26 $03
	vol $3
	note $26 $04
	vol $5
	note $26 $0e
	vol $3
	note $26 $03
	vol $3
	note $26 $04
	vol $2
	note $26 $03
	vol $3
	note $26 $04
	vol $5
	note $26 $0e
	vol $3
	note $26 $03
	vol $3
	note $26 $04
	vol $2
	note $26 $03
	vol $3
	note $26 $04
	vol $5
	note $26 $0e
	vol $3
	note $26 $03
	vol $3
	note $26 $04
	vol $2
	note $26 $03
	vol $3
	note $26 $04
	vol $5
	note $26 $0e
	vol $3
	note $26 $03
	vol $3
	note $26 $04
	vol $2
	note $26 $03
	vol $3
	note $26 $04
	vol $5
	note $26 $0e
	vol $3
	note $26 $03
	vol $3
	note $26 $04
	vol $2
	note $26 $03
	vol $3
	note $26 $04
	vol $4
	note $26 $0e
	vol $3
	note $26 $03
	vol $3
	note $26 $04
	vol $2
	note $26 $03
	vol $2
	note $26 $04
	vol $5
	note $26 $0e
	vol $3
	note $26 $03
	vol $3
	note $26 $04
	vol $2
	note $26 $03
	vol $3
	note $26 $04
	vol $5
	note $26 $0e
	vol $3
	note $26 $03
	vol $3
	note $26 $04
	vol $2
	note $26 $03
	vol $3
	note $26 $04
	vol $4
	note $26 $03
	vol $4
	note $26 $04
	vol $3
	note $26 $03
	vol $2
	note $26 $04
	vol $3
	note $26 $03
	vol $3
	note $26 $04
	vol $2
	note $26 $03
	vol $3
	note $26 $04
	vol $4
	note $26 $0e
	vol $3
	note $26 $07
	vol $2
	note $26 $07
	vol $3
	note $26 $07
	vol $2
	note $26 $07
	vol $3
	note $26 $07
	vol $2
	note $26 $07
	vol $5
	note $26 $0e
	vol $3
	note $26 $03
	vol $3
	note $26 $04
	vol $2
	note $26 $03
	vol $3
	note $26 $04
	vol $4
	note $26 $03
	vol $4
	note $26 $04
	vol $3
	note $26 $03
	vol $2
	note $26 $04
	vol $3
	note $26 $03
	vol $3
	note $26 $04
	vol $2
	note $26 $03
	vol $3
	note $26 $04
	vol $4
	note $26 $0e
	vol $3
	note $26 $03
	vol $2
	note $26 $04
	vol $2
	note $26 $03
	note $26 $04
	vol $3
	note $26 $03
	vol $3
	note $26 $04
	vol $2
	note $26 $03
	vol $3
	note $26 $04
	vol $3
	note $26 $03
	vol $3
	note $26 $04
	vol $2
	note $26 $03
	vol $3
	note $26 $04
	vol $5
	note $26 $0e
	vol $3
	note $26 $03
	vol $3
	note $26 $04
	vol $2
	note $26 $03
	vol $3
	note $26 $04
	vol $4
	note $26 $03
	vol $4
	note $26 $04
	vol $3
	note $26 $03
	vol $2
	note $26 $04
	vol $3
	note $26 $03
	vol $3
	note $26 $04
	vol $2
	note $26 $03
	vol $3
	note $26 $04
	vol $4
	note $26 $0e
	vol $3
	note $26 $07
	vol $2
	note $26 $07
	vol $3
	note $26 $07
	vol $2
	note $26 $07
	vol $3
	note $26 $07
	vol $3
	note $26 $07
	vol $5
	note $26 $0e
	vol $3
	note $26 $03
	vol $3
	note $26 $04
	vol $2
	note $26 $03
	vol $3
	note $26 $04
	vol $4
	note $26 $03
	vol $4
	note $26 $04
	vol $3
	note $26 $03
	vol $2
	note $26 $04
	vol $3
	note $26 $03
	vol $3
	note $26 $04
	vol $2
	note $26 $03
	vol $3
	note $26 $04
	vol $4
	note $26 $0e
	vol $3
	note $26 $03
	vol $2
	note $26 $04
	vol $2
	note $26 $03
	note $26 $04
	vol $3
	note $26 $03
	vol $3
	note $26 $04
	vol $2
	note $26 $03
	vol $3
	note $26 $04
	vol $3
	note $26 $03
	vol $3
	note $26 $04
	vol $2
	note $26 $03
	vol $3
	note $26 $04
	vol $5
	note $26 $0e
	vol $3
	note $26 $03
	vol $3
	note $26 $04
	vol $2
	note $26 $03
	vol $3
	note $26 $04
	vol $4
	note $26 $03
	vol $4
	note $26 $04
	vol $3
	note $26 $03
	vol $2
	note $26 $04
	vol $3
	note $26 $03
	vol $3
	note $26 $04
	vol $2
	note $26 $03
	vol $3
	note $26 $04
	goto musicea8a0
	cmdff

sound33Start:

sound33Channel1:
	vibrato $e1
	env $0 $00
	cmdf2
	duty $02
musiceacd8:
	vol $6
	note b3  $12
	note as3 $06
	rest $03
	vol $3
	note as3 $06
	rest $03
	vol $1
	note as3 $06
	rest $06
	vol $6
	note d4  $12
	note cs4 $06
	rest $03
	vol $3
	note cs4 $06
	rest $03
	vol $1
	note cs4 $06
	rest $06
	vol $6
	note b3  $12
	note as3 $06
	rest $03
	vol $3
	note as3 $06
	rest $03
	vol $1
	note as3 $06
	rest $06
	vol $6
	note d4  $06
	rest $03
	vol $3
	note d4  $03
	vol $6
	note d4  $06
	note cs4 $06
	rest $03
	vol $3
	note cs4 $06
	rest $03
	vol $1
	note cs4 $06
	rest $06
	vol $6
	note b3  $12
	note as3 $06
	rest $03
	vol $3
	note as3 $06
	rest $03
	vol $1
	note as3 $06
	rest $06
	vol $6
	note d4  $12
	note cs4 $06
	rest $03
	vol $3
	note cs4 $06
	rest $03
	vol $1
	note cs4 $06
	rest $06
	vol $6
	note b3  $12
	note as3 $06
	rest $03
	vol $3
	note as3 $06
	rest $03
	vol $1
	note as3 $06
	rest $06
	vol $6
	note d4  $06
	rest $03
	vol $3
	note d4  $03
	vol $6
	note d4  $06
	note cs4 $06
	rest $03
	vol $3
	note cs4 $06
	vol $6
	note cs4 $03
	note d4  $03
	note ds4 $03
	note e4  $03
	note f4  $03
	note fs4 $12
	note e4  $06
	rest $03
	vol $3
	note e4  $06
	rest $03
	vol $1
	note e4  $06
	rest $06
	vol $6
	note g4  $12
	note fs4 $06
	rest $03
	vol $3
	note fs4 $06
	rest $03
	vol $1
	note fs4 $06
	rest $06
	vol $6
	note fs4 $12
	note e4  $06
	rest $03
	vol $3
	note e4  $06
	rest $03
	vol $1
	note e4  $06
	rest $06
	vol $6
	note g4  $0c
	note a4  $06
	note fs4 $06
	rest $03
	vol $3
	note fs4 $06
	rest $03
	vol $1
	note fs4 $06
	rest $06
	vol $6
	note fs4 $12
	vol $6
	note e4  $06
	rest $03
	vol $3
	note e4  $06
	rest $03
	vol $1
	note e4  $06
	rest $06
	vol $6
	note g4  $12
	note fs4 $06
	rest $03
	vol $3
	note fs4 $06
	rest $03
	vol $1
	note fs4 $06
	rest $06
	vol $6
	note fs4 $12
	note e4  $06
	rest $03
	vol $3
	note e4  $06
	rest $03
	vol $1
	note e4  $06
	rest $06
	vol $6
	note g4  $06
	note a4  $06
	note fs4 $06
	note g4  $06
	note e4  $06
	note fs4 $06
	note ds4 $06
	note e4  $06
	note fs4 $06
	note g4  $06
	note gs4 $06
	note a4  $06
	rest $03
	vol $3
	note a4  $06
	rest $03
	vol $1
	note a4  $06
	rest $06
	vol $6
	note a4  $06
	note as4 $06
	note b4  $06
	note c5  $06
	rest $03
	vol $3
	note c5  $06
	rest $03
	vol $1
	note c5  $06
	rest $06
	vol $6
	note c5  $06
	note cs5 $06
	note d5  $06
	note ds5 $06
	rest $03
	vol $3
	note ds5 $06
	rest $03
	vol $1
	note ds5 $06
	rest $06
	vol $6
	note ds5 $06
	note e5  $06
	note f5  $06
	note fs5 $06
	rest $03
	vol $3
	note fs5 $06
	rest $03
	vol $1
	note fs5 $06
	rest $06
	vol $6
	note fs5 $06
	rest $03
	vol $3
	note fs5 $03
	vol $6
	note gs5 $03
	note a5  $03
	note as5 $03
	note b5  $03
	note c6  $3c
	rest $06
	note a5  $06
	note c6  $06
	note fs5 $06
	note a5  $06
	note ds5 $06
	note fs5 $06
	note c5  $06
	note ds5 $06
	note a4  $06
	note c5  $06
	note fs4 $06
	note a4  $06
	note ds4 $06
	note fs4 $06
	note c4  $06
	note ds4 $06
	note a3  $06
	goto musiceacd8
	cmdff

sound33Channel0:
	vibrato $e1
	env $0 $00
	cmdf2
	duty $02
musiceae93:
	vol $6
	note g3  $12
	note fs3 $06
	rest $03
	vol $3
	note fs3 $06
	rest $03
	vol $1
	note fs3 $06
	rest $06
	vol $6
	note b3  $12
	note as3 $06
	rest $03
	vol $3
	note as3 $06
	rest $03
	vol $1
	note as3 $06
	rest $06
	vol $6
	note g3  $12
	note fs3 $06
	rest $03
	vol $3
	note fs3 $06
	rest $03
	vol $1
	note fs3 $06
	rest $06
	vol $6
	note b3  $06
	rest $03
	vol $3
	note b3  $03
	vol $6
	note b3  $06
	note as3 $06
	rest $03
	vol $3
	note as3 $06
	rest $03
	vol $1
	note as3 $06
	rest $06
	vol $6
	note g3  $12
	note fs3 $06
	rest $03
	vol $3
	note fs3 $06
	rest $03
	vol $1
	note fs3 $06
	rest $06
	vol $6
	note b3  $12
	note as3 $06
	rest $03
	vol $3
	note as3 $06
	rest $03
	vol $1
	note as3 $06
	rest $06
	vol $6
	note g3  $12
	note fs3 $06
	rest $03
	vol $3
	note fs3 $06
	rest $03
	vol $1
	note fs3 $06
	rest $06
	vol $6
	note b3  $06
	rest $03
	vol $3
	note b3  $03
	vol $6
	note b3  $06
	note as3 $06
	rest $03
	vol $3
	note as3 $06
	vol $6
	note as3 $03
	note b3  $03
	note c4  $03
	note cs4 $03
	note d4  $03
	note ds4 $12
	note cs4 $06
	rest $03
	vol $3
	note cs4 $06
	rest $03
	vol $1
	note cs4 $06
	rest $06
	vol $6
	note e4  $12
	note ds4 $06
	rest $03
	vol $3
	note ds4 $06
	rest $03
	vol $1
	note ds4 $06
	rest $06
	vol $6
	note ds4 $12
	note cs4 $06
	rest $03
	vol $3
	note cs4 $06
	rest $03
	vol $1
	note cs4 $06
	rest $06
	vol $6
	note e4  $0c
	note e4  $06
	note ds4 $06
	rest $03
	vol $3
	note ds4 $06
	rest $03
	vol $1
	note ds4 $06
	rest $06
	vol $6
	note ds4 $12
	note cs4 $06
	rest $03
	vol $3
	note cs4 $06
	rest $03
	vol $1
	note cs4 $06
	rest $06
	vol $6
	note e4  $12
	note ds4 $06
	rest $03
	vol $3
	note ds4 $06
	rest $03
	vol $1
	note ds4 $06
	rest $06
	vol $6
	note ds4 $12
	note cs4 $06
	rest $03
	vol $3
	note cs4 $06
	rest $03
	vol $1
	note cs4 $06
	rest $06
	vol $6
	note e4  $06
	note fs4 $06
	note ds4 $06
	note e4  $06
	note cs4 $06
	note ds4 $06
	note b3  $06
	note cs4 $06
	note ds4 $06
	note e4  $06
	note f4  $06
	note fs4 $06
	rest $03
	vol $3
	note fs4 $06
	rest $03
	vol $1
	note fs4 $06
	rest $06
	vol $6
	note fs4 $06
	note g4  $06
	note gs4 $06
	note a4  $06
	rest $03
	vol $3
	note a4  $06
	rest $03
	vol $1
	note a4  $06
	rest $06
	vol $6
	note a4  $06
	note as4 $06
	note b4  $06
	note c5  $06
	rest $03
	vol $3
	note c5  $06
	rest $03
	vol $1
	note c5  $06
	rest $06
	vol $6
	note c5  $06
	note cs5 $06
	note d5  $06
	note ds5 $06
	rest $03
	vol $3
	note ds5 $06
	rest $03
	vol $1
	note ds5 $06
	rest $06
	vol $6
	note ds5 $06
	rest $03
	vol $3
	note ds5 $03
	vol $6
	note e5  $03
	note fs5 $03
	note g5  $03
	note gs5 $03
	note a5  $3c
	vol $3
	note a5  $0c
	vol $9
	note a3  $06
	note gs3 $06
	note g3  $06
	note fs3 $06
	note f3  $06
	note e3  $06
	note ds3 $06
	note d3  $06
	note cs3 $06
	note c3  $06
	note b2  $06
	note as2 $06
	note a2  $06
	note gs2 $06
	note g2  $06
	note fs2 $06
	goto musiceae93
	cmdff

sound33Channel4:
	cmdf2
musiceb047:
	duty $12
	note fs2 $04
	duty $0f
	note fs2 $02
	duty $12
	note g2  $0a
	duty $0f
	note g2  $02
	duty $12
	note fs2 $04
	duty $0f
	note fs2 $02
	duty $12
	note g2  $0a
	duty $0f
	note g2  $02
	duty $12
	note fs2 $04
	duty $0f
	note fs2 $02
	duty $12
	note g2  $0a
	duty $0f
	note g2  $02
	duty $12
	note fs2 $04
	duty $0f
	note fs2 $02
	duty $12
	note g2  $0a
	duty $0f
	note g2  $02
	duty $12
	note fs2 $05
	duty $0f
	note fs2 $01
	duty $12
	note g2  $05
	duty $0f
	note g2  $01
	duty $12
	note fs2 $05
	duty $0f
	note fs2 $01
	duty $12
	note g2  $05
	duty $0f
	note g2  $01
	duty $12
	note fs2 $04
	duty $0f
	note fs2 $02
	duty $12
	note g2  $0a
	duty $0f
	note g2  $02
	duty $12
	note fs2 $04
	duty $0f
	note fs2 $02
	duty $12
	note g2  $0a
	duty $0f
	note g2  $02
	duty $12
	note fs2 $04
	duty $0f
	note fs2 $02
	duty $12
	note g2  $0a
	duty $0f
	note g2  $02
	duty $12
	note fs2 $04
	duty $0f
	note fs2 $02
	duty $12
	note g2  $0a
	duty $0f
	note g2  $02
	duty $12
	note fs2 $05
	duty $0f
	note fs2 $01
	duty $12
	note g2  $05
	duty $0f
	note g2  $01
	duty $12
	note fs2 $05
	duty $0f
	note fs2 $01
	duty $12
	note g2  $05
	duty $0f
	note g2  $01
	duty $12
	note fs2 $04
	duty $0f
	note fs2 $02
	duty $12
	note g2  $0a
	duty $0f
	note g2  $02
	duty $12
	note fs2 $04
	duty $0f
	note fs2 $02
	duty $12
	note g2  $0a
	duty $0f
	note g2  $02
	duty $12
	note fs2 $04
	duty $0f
	note fs2 $02
	duty $12
	note g2  $0a
	duty $0f
	note g2  $02
	duty $12
	note fs2 $04
	duty $0f
	note fs2 $02
	duty $12
	note g2  $0a
	duty $0f
	note g2  $02
	duty $12
	note fs2 $05
	duty $0f
	note fs2 $01
	duty $12
	note g2  $05
	duty $0f
	note g2  $01
	duty $12
	note fs2 $05
	duty $0f
	note fs2 $01
	duty $12
	note g2  $05
	duty $0f
	note g2  $01
	duty $12
	note fs2 $04
	duty $0f
	note fs2 $02
	duty $12
	note g2  $0a
	duty $0f
	note g2  $02
	duty $12
	note fs2 $04
	duty $0f
	note fs2 $02
	duty $12
	note g2  $0a
	duty $0f
	note g2  $02
	duty $12
	note fs2 $04
	duty $0f
	note fs2 $02
	duty $12
	note g2  $0a
	duty $0f
	note g2  $02
	duty $12
	note fs2 $04
	duty $0f
	note fs2 $02
	duty $12
	note g2  $0a
	duty $0f
	note g2  $02
	duty $12
	note fs2 $05
	duty $0f
	note fs2 $01
	duty $12
	note g2  $05
	duty $0f
	note g2  $01
	duty $12
	note gs2 $05
	duty $0f
	note gs2 $01
	duty $12
	note a2  $05
	duty $0f
	note a2  $01
	duty $12
	note as2 $04
	duty $0f
	note as2 $02
	duty $12
	note b2  $0a
	duty $0f
	note b2  $02
	duty $12
	note as2 $04
	duty $0f
	note as2 $02
	duty $12
	note b2  $0a
	duty $0f
	note b2  $02
	duty $12
	note as2 $04
	duty $0f
	note as2 $02
	duty $12
	note b2  $0a
	duty $0f
	note b2  $02
	duty $12
	note as2 $04
	duty $0f
	note as2 $02
	duty $12
	note b2  $0a
	duty $0f
	note b2  $02
	duty $12
	note as2 $05
	duty $0f
	note as2 $01
	duty $12
	note b2  $05
	duty $0f
	note b2  $01
	duty $12
	note as2 $05
	duty $0f
	note as2 $01
	duty $12
	note b2  $05
	duty $0f
	note b2  $01
	duty $12
	note as2 $04
	duty $0f
	note as2 $02
	duty $12
	note b2  $0a
	duty $0f
	note b2  $02
	duty $12
	note as2 $04
	duty $0f
	note as2 $02
	duty $12
	note b2  $0a
	duty $0f
	note b2  $02
	duty $12
	note as2 $04
	duty $0f
	note as2 $02
	duty $12
	note b2  $0a
	duty $0f
	note b2  $02
	duty $12
	note as2 $04
	duty $0f
	note as2 $02
	duty $12
	note b2  $0a
	duty $0f
	note b2  $02
	duty $12
	note as2 $05
	duty $0f
	note as2 $01
	duty $12
	note b2  $05
	duty $0f
	note b2  $01
	duty $12
	note as2 $05
	duty $0f
	note as2 $01
	duty $12
	note b2  $05
	duty $0f
	note b2  $01
	duty $12
	note as2 $04
	duty $0f
	note as2 $02
	duty $12
	note b2  $0a
	duty $0f
	note b2  $02
	duty $12
	note as2 $04
	duty $0f
	note as2 $02
	duty $12
	note b2  $0a
	duty $0f
	note b2  $02
	duty $12
	note as2 $04
	duty $0f
	note as2 $02
	duty $12
	note b2  $0a
	duty $0f
	note b2  $02
	duty $12
	note as2 $04
	duty $0f
	note as2 $02
	duty $12
	note b2  $0a
	duty $0f
	note b2  $02
	duty $12
	note as2 $05
	duty $0f
	note as2 $01
	duty $12
	note b2  $05
	duty $0f
	note b2  $01
	duty $12
	note as2 $05
	duty $0f
	note as2 $01
	duty $12
	note b2  $05
	duty $0f
	note b2  $01
	duty $12
	note as2 $04
	duty $0f
	note as2 $02
	duty $12
	note b2  $0a
	duty $0f
	note b2  $02
	duty $12
	note as2 $04
	duty $0f
	note as2 $02
	duty $12
	note b2  $0a
	duty $0f
	note b2  $02
	duty $12
	note as2 $04
	duty $0f
	note as2 $02
	duty $12
	note b2  $0a
	duty $0f
	note b2  $02
	duty $12
	note as2 $04
	duty $0f
	note as2 $02
	duty $12
	note b2  $0a
	duty $0f
	note b2  $02
	duty $12
	note as2 $05
	duty $0f
	note as2 $01
	duty $12
	note b2  $05
	duty $0f
	note b2  $01
	duty $12
	note as2 $05
	duty $0f
	note as2 $01
	duty $12
	note b2  $05
	duty $0f
	note b2  $01
	duty $12
	note b2  $06
	note cs3 $06
	note d3  $06
	note ds3 $06
	duty $0f
	note ds3 $0c
	duty $0c
	note ds3 $0c
	duty $12
	note ds3 $06
	note e3  $06
	note f3  $06
	note fs3 $06
	duty $0f
	note fs3 $0c
	duty $0c
	note fs3 $0c
	duty $12
	note fs3 $06
	note g3  $06
	note gs3 $06
	note a3  $06
	duty $0f
	note a3  $0c
	duty $0c
	note a3  $0c
	duty $12
	note a3  $06
	note as3 $06
	note b3  $06
	note c4  $06
	duty $0f
	note c4  $0c
	duty $0c
	note c4  $0c
	duty $12
	note b3  $02
	note as3 $02
	note a3  $02
	note gs3 $02
	note g3  $02
	note fs3 $02
	note f3  $02
	note e3  $02
	note ds3 $02
	note d3  $02
	note cs3 $02
	note c3  $02
	note b2  $3c
	rest $6c
	goto musiceb047
	cmdff

sound33Channel6:
	cmdf2
musiceb3b2:
	vol $5
	vol $7
	note $28 $01
	vol $3
	note $27 $05
	vol $7
	note $28 $01
	vol $3
	note $27 $0b
	vol $5
	vol $7
	note $28 $01
	vol $3
	note $27 $05
	vol $5
	vol $7
	note $28 $01
	vol $3
	note $27 $05
	vol $5
	vol $7
	note $28 $01
	vol $3
	note $27 $0b
	vol $5
	vol $7
	note $28 $01
	vol $3
	note $27 $05
	vol $5
	vol $7
	note $28 $01
	vol $3
	note $27 $05
	vol $7
	note $28 $01
	vol $3
	note $27 $0b
	vol $5
	vol $7
	note $28 $01
	vol $3
	note $27 $05
	vol $5
	vol $7
	note $28 $01
	vol $3
	note $27 $05
	vol $7
	note $28 $01
	vol $3
	note $27 $0b
	vol $5
	vol $7
	note $28 $01
	vol $3
	note $27 $05
	vol $5
	vol $7
	note $28 $01
	vol $3
	note $27 $05
	vol $7
	note $28 $01
	vol $3
	note $27 $0b
	vol $5
	vol $7
	note $28 $01
	vol $3
	note $27 $05
	vol $5
	vol $7
	note $28 $01
	vol $3
	note $27 $05
	vol $5
	vol $7
	note $28 $01
	vol $3
	note $27 $0b
	vol $5
	vol $7
	note $28 $01
	vol $3
	note $27 $05
	vol $5
	vol $7
	note $28 $01
	vol $3
	note $27 $05
	vol $7
	note $28 $01
	vol $3
	note $27 $0b
	vol $5
	vol $7
	note $28 $01
	vol $3
	note $27 $05
	vol $5
	vol $7
	note $28 $01
	vol $3
	note $27 $05
	vol $5
	vol $7
	note $28 $01
	vol $3
	note $27 $05
	vol $5
	vol $7
	note $28 $01
	vol $3
	note $27 $05
	vol $5
	vol $7
	note $28 $01
	vol $3
	note $27 $05
	vol $5
	vol $7
	note $28 $01
	vol $3
	note $27 $05
	vol $7
	note $28 $01
	vol $3
	note $27 $0b
	vol $5
	vol $7
	note $28 $01
	vol $3
	note $27 $05
	vol $5
	vol $7
	note $28 $01
	vol $3
	note $27 $05
	vol $5
	vol $7
	note $28 $01
	vol $3
	note $27 $0b
	vol $5
	vol $7
	note $28 $01
	vol $3
	note $27 $05
	vol $5
	vol $7
	note $28 $01
	vol $3
	note $27 $05
	vol $7
	note $28 $01
	vol $3
	note $27 $0b
	vol $5
	vol $7
	note $28 $01
	vol $3
	note $27 $05
	vol $5
	vol $7
	note $28 $01
	vol $3
	note $27 $05
	vol $7
	note $28 $01
	vol $3
	note $27 $0b
	vol $5
	vol $7
	note $28 $01
	vol $3
	note $27 $05
	vol $5
	vol $7
	note $28 $01
	vol $3
	note $27 $05
	vol $7
	note $28 $01
	vol $3
	note $27 $0b
	vol $5
	vol $7
	note $28 $01
	vol $3
	note $27 $05
	vol $5
	vol $7
	note $28 $01
	vol $3
	note $27 $05
	vol $5
	vol $7
	note $28 $01
	vol $3
	note $27 $0b
	vol $5
	vol $7
	note $28 $01
	vol $3
	note $27 $05
	vol $5
	vol $7
	note $28 $01
	vol $3
	note $27 $05
	vol $7
	note $28 $01
	vol $3
	note $27 $0b
	vol $5
	vol $7
	note $28 $01
	vol $3
	note $27 $05
	vol $5
	vol $7
	note $28 $01
	vol $3
	note $27 $05
	vol $7
	note $28 $01
	vol $3
	note $27 $05
	vol $5
	vol $7
	note $28 $01
	vol $3
	note $27 $05
	vol $5
	vol $7
	note $28 $01
	vol $3
	note $27 $05
	vol $5
	vol $7
	note $28 $01
	vol $3
	note $27 $05
	vol $7
	note $28 $01
	vol $3
	note $27 $0b
	vol $5
	vol $7
	note $28 $01
	vol $3
	note $27 $05
	vol $5
	vol $7
	note $28 $01
	vol $3
	note $27 $05
	vol $5
	vol $7
	note $28 $01
	vol $3
	note $27 $0b
	vol $5
	vol $7
	note $28 $01
	vol $3
	note $27 $05
	vol $5
	vol $7
	note $28 $01
	vol $3
	note $27 $05
	vol $7
	note $28 $01
	vol $3
	note $27 $0b
	vol $5
	vol $7
	note $28 $01
	vol $3
	note $27 $05
	vol $5
	vol $7
	note $28 $01
	vol $3
	note $27 $05
	vol $7
	note $28 $01
	vol $3
	note $27 $0b
	vol $5
	vol $7
	note $28 $01
	vol $3
	note $27 $05
	vol $5
	vol $7
	note $28 $01
	vol $3
	note $27 $05
	vol $5
	vol $7
	note $28 $01
	vol $3
	note $27 $0b
	vol $5
	vol $7
	note $28 $01
	vol $3
	note $27 $05
	vol $5
	vol $7
	note $28 $01
	vol $3
	note $27 $05
	vol $5
	vol $7
	note $28 $01
	vol $3
	note $27 $0b
	vol $5
	vol $7
	note $28 $01
	vol $3
	note $27 $05
	vol $5
	vol $7
	note $28 $01
	vol $3
	note $27 $05
	vol $7
	note $28 $01
	vol $3
	note $27 $0b
	vol $5
	vol $7
	note $28 $01
	vol $3
	note $27 $05
	vol $5
	vol $7
	note $28 $01
	vol $3
	note $27 $05
	vol $7
	note $28 $01
	vol $3
	note $27 $05
	vol $5
	vol $7
	note $28 $01
	vol $3
	note $27 $05
	vol $5
	vol $7
	note $28 $01
	vol $3
	note $27 $05
	vol $5
	vol $7
	note $28 $01
	vol $3
	note $27 $05
	vol $7
	note $28 $01
	vol $3
	note $27 $0b
	vol $5
	vol $7
	note $28 $01
	vol $3
	note $27 $05
	vol $5
	vol $7
	note $28 $01
	vol $3
	note $27 $05
	vol $5
	vol $7
	note $28 $01
	vol $3
	note $27 $0b
	vol $5
	vol $7
	note $28 $01
	vol $3
	note $27 $05
	vol $5
	vol $7
	note $28 $01
	vol $3
	note $27 $05
	vol $7
	note $28 $01
	vol $3
	note $27 $0b
	vol $5
	vol $7
	note $28 $01
	vol $3
	note $27 $05
	vol $5
	vol $7
	note $28 $01
	vol $3
	note $27 $05
	vol $7
	note $28 $01
	vol $3
	note $27 $0b
	vol $5
	vol $7
	note $28 $01
	vol $3
	note $27 $05
	vol $5
	vol $7
	note $28 $01
	vol $3
	note $27 $05
	vol $7
	note $28 $01
	vol $3
	note $27 $0b
	vol $5
	vol $7
	note $28 $01
	vol $3
	note $27 $05
	vol $5
	vol $7
	note $28 $01
	vol $3
	note $27 $05
	vol $5
	vol $7
	note $28 $01
	vol $3
	note $27 $0b
	vol $5
	vol $7
	note $28 $01
	vol $3
	note $27 $05
	vol $5
	vol $7
	note $28 $01
	vol $3
	note $27 $05
	vol $7
	note $28 $01
	vol $3
	note $27 $0b
	vol $5
	vol $7
	note $28 $01
	vol $3
	note $27 $05
	vol $5
	vol $7
	note $28 $01
	vol $3
	note $27 $05
	vol $7
	note $28 $01
	vol $3
	note $27 $05
	vol $5
	vol $7
	note $28 $01
	vol $3
	note $27 $05
	vol $5
	vol $7
	note $28 $01
	vol $3
	note $27 $05
	vol $5
	vol $7
	note $28 $01
	vol $3
	note $27 $05
	vol $7
	note $28 $01
	vol $3
	note $27 $0b
	vol $5
	vol $7
	note $28 $01
	vol $3
	note $27 $05
	vol $5
	note $24 $06
	note $24 $06
	note $24 $06
	vol $5
	note $24 $06
	vol $7
	note $28 $01
	vol $3
	note $27 $05
	vol $5
	vol $7
	note $28 $01
	vol $3
	note $27 $0b
	vol $5
	vol $7
	note $28 $01
	vol $3
	note $27 $05
	vol $5
	note $26 $06
	note $26 $06
	note $26 $06
	note $26 $06
	vol $5
	vol $7
	note $28 $01
	vol $3
	note $27 $05
	vol $5
	vol $7
	note $28 $01
	vol $3
	note $27 $05
	vol $5
	vol $7
	note $28 $01
	vol $3
	note $27 $05
	vol $5
	vol $5
	vol $7
	note $28 $01
	vol $3
	note $27 $05
	vol $5
	note $2a $06
	note $2a $06
	vol $5
	note $2a $06
	vol $5
	note $2a $06
	vol $7
	note $28 $01
	vol $3
	note $27 $05
	vol $5
	vol $7
	note $28 $01
	vol $3
	note $27 $05
	vol $7
	note $28 $01
	vol $3
	note $27 $05
	vol $5
	vol $7
	note $28 $01
	vol $3
	note $27 $05
	vol $5
	note $24 $06
	note $24 $06
	note $24 $06
	note $24 $06
	vol $7
	note $28 $01
	vol $3
	note $27 $0b
	vol $5
	vol $7
	note $28 $01
	vol $3
	note $27 $03
	vol $7
	note $28 $01
	vol $3
	note $27 $03
	vol $7
	note $28 $01
	vol $3
	note $27 $03
	note $2e $18
	note $2a $06
	note $2a $06
	note $2e $06
	note $2a $06
	note $2a $06
	note $2a $06
	note $2e $06
	note $2a $06
	vol $7
	note $28 $01
	vol $3
	note $27 $05
	vol $7
	note $28 $01
	vol $3
	note $27 $05
	vol $8
	note $28 $01
	vol $3
	note $27 $05
	vol $8
	note $28 $01
	vol $3
	note $27 $11
	vol $9
	note $28 $01
	vol $3
	note $27 $05
	vol $9
	note $28 $01
	vol $3
	note $27 $05
	vol $a
	note $28 $01
	vol $3
	note $27 $05
	vol $a
	note $28 $01
	vol $3
	note $27 $11
	vol $a
	note $28 $01
	vol $3
	note $27 $05
	vol $b
	note $28 $01
	vol $3
	note $27 $05
	vol $b
	note $28 $01
	vol $3
	note $27 $05
	vol $b
	note $28 $01
	vol $3
	note $27 $05
	goto musiceb3b2
	cmdff

soundceStart:

soundceChannel2:
	duty $02
	vol $5
	env $1 $00
	vibrato $00
	cmdf8 $04
	note g6  $05
	vol $3
	env $0 $07
	vibrato $00
	cmdf8 $ff
	note c7  $37
	cmdff

soundceChannel5:
	duty $08
	vibrato $00
	cmdf8 $04
	note g6  $05
	vibrato $00
	cmdf8 $ff
	note c7  $28
	cmdff

soundceChannel7:
	cmdf0 $20
	note $16 $12
	note $17 $01
	cmdf0 $20
	note $16 $14
	cmdf0 $24
	note $16 $1e
	cmdff

soundc1Start:

soundc1Channel2:
	duty $02
	vol $1
	note f7  $01
	note as7 $01
	note d8  $01
	note f7  $01
	note as6 $01
	note d8  $01
	vol $2
	note f7  $01
	note as7 $01
	note d8  $01
	note f7  $01
	note as6 $01
	note d8  $01
	vol $3
	note f7  $01
	note a7  $01
	note d8  $01
	note f7  $01
	note a6  $01
	note d8  $01
	vol $4
	note f7  $01
	note a7  $01
	note d8  $01
	note f7  $01
	note a6  $01
	note d8  $01
	vol $5
	note f7  $01
	note gs7 $01
	note d8  $01
	note f7  $01
	note gs6 $01
	note d8  $01
	vol $6
	note fs7 $01
	note gs7 $01
	note d8  $01
	note fs7 $01
	note gs6 $01
	note d8  $01
	vol $7
	note fs7 $01
	note g7  $01
	note d8  $01
	note fs7 $01
	note g6  $01
	note d8  $01
	vol $6
	note fs7 $01
	note g7  $01
	note d8  $01
	note fs7 $01
	note g6  $01
	note d8  $01
	vol $5
	note fs7 $01
	note fs7 $01
	note d8  $01
	note fs7 $01
	note fs6 $01
	note d8  $01
	vol $4
	note fs7 $01
	note fs7 $01
	note d8  $01
	note fs7 $01
	note fs6 $01
	note d8  $01
	vol $3
	note g7  $01
	note f7  $01
	note d8  $01
	note g7  $01
	note f6  $01
	note d8  $01
	note g7  $01
	note f7  $01
	note d8  $01
	vol $2
	note g7  $01
	note f6  $01
	note d8  $01
	note g7  $01
	note e7  $01
	note d8  $01
	note g7  $01
	note e6  $01
	note d8  $01
	vol $1
	note g7  $01
	note e7  $01
	note d8  $01
	note g7  $01
	note e6  $01
	note d8  $01
	note g7  $01
	note ds7 $01
	env $0 $01
	note d8  $01
	cmdff

soundcfStart:

soundcfChannel2:
	cmdff

soundc5Start:

soundc5Channel5:
	duty $0a
	cmdf8 $1e
	note c3  $05
	rest $02
	cmdf8 $2e
	note c3  $08
	rest $08
	cmdf8 $e2
	note gs3 $08
	rest $06
	cmdf8 $d8
	note gs3 $08
	cmdff

soundc8Start:

soundc8Channel2:
	duty $01
	vol $f
	note ds6 $03
	vol $b
	env $0 $06
	note ds6 $3c
	cmdff

soundc8Channel7:
	cmdf0 $41
	note $15 $01
	cmdff

soundc6Start:

soundc6Channel2:
	duty $00
	vol $d
	env $1 $00
	cmdf8 $f1
	note f6  $05
	cmdf8 $00
	rest $02
	vol $e
	env $1 $00
	cmdf8 $f1
	note f6  $05
	cmdf8 $00
	cmdff

soundc2Start:

soundc2Channel7:
	cmdf0 $10
	note $25 $02
	cmdf0 $20
	note $25 $01
	cmdf0 $30
	note $25 $02
	cmdf0 $40
	note $25 $01
	cmdf0 $50
	note $25 $02
	cmdf0 $60
	note $25 $01
	cmdf0 $70
	note $25 $02
	cmdf0 $90
	note $25 $01
	cmdf0 $a0
	note $25 $02
musiceb8ad:
	cmdf0 $b0
	note $25 $ff
	goto musiceb8ad
	cmdff

soundc3Start:

soundc3Channel5:
	duty $03
	cmdf8 $0c
	note g5  $05
	vol $0
	rest $08
	cmdf8 $fe
	note d6  $05
	cmdf8 $00
	note g5  $01
	cmdf8 $0c
	note g5  $05
	vol $0
	rest $0a
	cmdf8 $fe
	note d6  $0f
	cmdff

soundc9Start:

soundc9Channel2:
	duty $00
	vol $1
	cmdf8 $02
	note ds7 $01
	cmdf8 $00
	vol $1
	env $0 $01
	cmdf8 $02
	note ds7 $02
	cmdf8 $00
	env $0 $00
	vol $2
	cmdf8 $02
	note ds7 $02
	cmdf8 $00
	vol $1
	env $0 $01
	cmdf8 $02
	note ds7 $01
	cmdf8 $00
	env $0 $00
	vol $3
	cmdf8 $02
	note ds7 $02
	cmdf8 $00
	vol $1
	env $0 $01
	cmdf8 $02
	note ds7 $01
	cmdf8 $00
	env $0 $00
	vol $4
	cmdf8 $03
	note ds7 $02
	cmdf8 $00
	vol $1
	env $0 $01
	cmdf8 $02
	note ds7 $01
	cmdf8 $00
	env $0 $00
	vol $5
	cmdf8 $03
	note ds7 $02
	cmdf8 $00
	vol $1
	env $0 $01
	cmdf8 $02
	note ds7 $01
	cmdf8 $00
	env $0 $00
	vol $6
	cmdf8 $03
	note ds7 $02
	cmdf8 $00
	vol $1
	env $0 $01
	cmdf8 $02
	note ds7 $01
	cmdf8 $00
	env $0 $00
	vol $7
	cmdf8 $04
	note ds7 $02
	cmdf8 $00
	vol $1
	env $0 $01
	cmdf8 $02
	note ds7 $01
	cmdf8 $00
	env $0 $00
	vol $7
	cmdf8 $04
	note ds7 $02
	cmdf8 $00
	vol $1
	env $0 $01
	cmdf8 $02
	note ds7 $01
	cmdf8 $00
	env $0 $00
	vol $7
	cmdf8 $04
	note ds7 $02
	cmdf8 $00
	vol $1
	env $0 $01
	cmdf8 $02
	note ds7 $01
	cmdf8 $00
	env $0 $00
	vol $6
	cmdf8 $05
	note ds7 $02
	cmdf8 $00
	vol $1
	env $0 $01
	cmdf8 $02
	note ds7 $01
	cmdf8 $00
	env $0 $00
	vol $6
	cmdf8 $05
	note ds7 $02
	cmdf8 $00
	vol $1
	env $0 $01
	cmdf8 $02
	note ds7 $01
	cmdf8 $00
	env $0 $00
	vol $6
	cmdf8 $05
	note ds7 $02
	cmdf8 $00
	vol $1
	env $0 $01
	cmdf8 $02
	note ds7 $01
	cmdf8 $00
	env $0 $00
	vol $5
	cmdf8 $05
	note ds7 $02
	cmdf8 $00
	vol $1
	env $0 $01
	cmdf8 $02
	note ds7 $01
	cmdf8 $00
	env $0 $00
	vol $5
	cmdf8 $05
	note ds7 $02
	cmdf8 $00
	vol $1
	env $0 $01
	cmdf8 $02
	note ds7 $01
	cmdf8 $00
	env $0 $00
	vol $5
	cmdf8 $05
	note ds7 $02
	cmdf8 $00
	vol $1
	env $0 $01
	cmdf8 $02
	note ds7 $01
	cmdf8 $00
	env $0 $00
	vol $4
	cmdf8 $05
	note ds7 $02
	cmdf8 $00
	vol $1
	env $0 $01
	cmdf8 $02
	note ds7 $01
	cmdf8 $00
	env $0 $00
	vol $4
	cmdf8 $05
	note ds7 $02
	cmdf8 $00
	vol $1
	env $0 $01
	cmdf8 $02
	note ds7 $01
	cmdf8 $00
	env $0 $00
	vol $4
	cmdf8 $05
	note ds7 $02
	cmdf8 $00
	vol $1
	env $0 $01
	cmdf8 $02
	note ds7 $01
	cmdf8 $00
	env $0 $00
	vol $3
	cmdf8 $05
	note ds7 $02
	cmdf8 $00
	vol $1
	env $0 $01
	cmdf8 $02
	note ds7 $01
	cmdf8 $00
	env $0 $00
	vol $3
	cmdf8 $05
	note ds7 $02
	cmdf8 $00
	vol $1
	env $0 $01
	cmdf8 $02
	note ds7 $01
	cmdf8 $00
	env $0 $00
	vol $3
	cmdf8 $05
	note ds7 $02
	cmdf8 $00
	vol $1
	env $0 $01
	cmdf8 $02
	note ds7 $01
	cmdf8 $00
	env $0 $00
	vol $2
	cmdf8 $05
	note ds7 $02
	cmdf8 $00
	vol $1
	env $0 $01
	cmdf8 $02
	note ds7 $01
	cmdf8 $00
	env $0 $00
	vol $2
	cmdf8 $05
	note ds7 $02
	cmdf8 $00
	vol $1
	env $0 $01
	cmdf8 $02
	note ds7 $01
	cmdf8 $00
	env $0 $00
	vol $2
	cmdf8 $05
	note ds7 $02
	cmdf8 $00
	vol $1
	env $0 $01
	cmdf8 $02
	note ds7 $01
	cmdf8 $00
	env $0 $00
	vol $1
	cmdf8 $05
	note ds7 $02
	cmdf8 $00
	vol $1
	env $0 $01
	cmdf8 $02
	note ds7 $01
	cmdf8 $00
	env $0 $00
	vol $1
	cmdf8 $05
	note ds7 $02
	cmdf8 $00
	vol $1
	env $0 $01
	cmdf8 $02
	note ds7 $01
	cmdf8 $00
	env $0 $00
	vol $1
	cmdf8 $05
	note ds7 $02
	cmdf8 $00
	vol $1
	env $0 $01
	cmdf8 $02
	note ds7 $01
	cmdf8 $00
	env $0 $00
	cmdff

sounda9Start:

sounda9Channel7:
	cmdf0 $20
	note $46 $01
	cmdf0 $40
	note $46 $01
	cmdf0 $60
	note $46 $02
	cmdf0 $b0
	note $46 $04
	cmdf0 $00
	note $00 $08
	cmdf0 $70
	note $56 $03
	cmdf0 $f1
	note $64 $0a
	cmdff

sound8eStart:

sound8eChannel2:
	duty $02
	vol $d
	env $1 $00
	cmdf8 $00
	note c5  $04
	vol $c
	note e5  $04
	vol $d
	note gs5 $04
	vibrato $51
	env $1 $01
	vol $b
	note c6  $14
	cmdff

sound7dStart:

sound7dChannel2:
	duty $01
	vol $a
	cmdf8 $ce
	note cs3 $05
	cmdff

sound7dChannel7:
	cmdf0 $f0
	note $37 $02
	cmdf0 $f0
	note $44 $01
	cmdf0 $e0
	note $45 $02
	cmdf0 $30
	note $56 $02
	cmdf0 $20
	note $56 $02
	cmdf0 $00
	note $56 $05
	cmdf0 $b1
	note $36 $04
	cmdf0 $90
	note $46 $01
	cmdf0 $80
	note $47 $02
	cmdff

sound7fStart:

sound7fChannel2:
	duty $02
	vol $b
	note d6  $01
	vol $0
	rest $02
	vol $d
	note fs5 $01
	vol $0
	rest $02
	vol $8
	note c6  $01
	vol $0
	rest $02
	vol $9
	note f5  $01
	cmdff

soundb6Start:

soundb6Channel2:
	duty $00
	cmdf8 $ba
	vol $7
	note as3 $02
	vol $8
	note b3  $02
	vol $a
	note c4  $02
	vol $c
	note cs4 $02
	vol $e
	note d4  $02
	note d4  $02
	note d4  $02
	note d4  $02
	note d4  $02
	note d4  $02
	note d4  $02
	note d4  $02
	vol $c
	note cs4 $02
	vol $a
	note c4  $02
	vol $8
	note b3  $02
	vol $7
	note as3 $02
	vol $6
	note a3  $02
	vol $5
	note gs3 $02
	vol $4
	note g3  $02
	vol $3
	note fs3 $02
	vol $2
	note f3  $02
	vol $1
	note e3  $02
	cmdff

soundb5Start:

soundb5Channel2:
	duty $01
	cmdf8 $fc
	vol $b
	note ds4 $05
	rest $01
	vol $0
	note ds4 $01
	cmdf8 $02
	env $0 $07
	vol $a
	note ds4 $46
	env $0 $00
	vol $9
	note e5  $01
	vol $a
	note f5  $01
	vol $b
	note fs5 $05
	cmdf8 $fc
	env $0 $02
	vol $b
	note fs5 $17
	cmdff

soundc4Start:

soundc4Channel5:
	duty $0b
	note c3  $02
	cmdf8 $1e
	note c3  $05
	rest $05
	note c3  $02
	cmdf8 $1e
	note c3  $08
	cmdff

soundccStart:

soundccChannel2:
	duty $00
	vol $c
	note g7  $02
	note gs7 $01
	note g7  $01
	note gs7 $01
	note g7  $01
	note gs7 $01
	note g7  $01
	note gs7 $01
	note g7  $01
	note gs7 $01
	note g7  $01
	note gs7 $01
	note g7  $01
	note gs7 $01
	note g7  $01
	note gs7 $01
	note g7  $01
	note gs7 $01
	note g7  $01
	note gs7 $01
	note g7  $01
	note gs7 $01
	note g7  $01
	note gs7 $01
	note g7  $01
	note gs7 $01
	note g7  $01
	note gs7 $01
	note g7  $01
	note gs7 $01
	note g7  $01
	note gs7 $01
	note g7  $01
	note gs7 $01
	note g7  $01
	note gs7 $01
	note g7  $01
	note gs7 $01
	note g7  $01
	note gs7 $01
	note g7  $01
	note gs7 $01
	note g7  $01
	note gs7 $01
	note g7  $01
	note gs7 $01
	note g7  $01
	note gs7 $01
	cmdff

soundcdStart:

soundcdChannel2:
	duty $01
	vol $0
	rest $03
	vol $c
	note a5  $01
	vol $d
	note g4  $01
	vol $e
	note c6  $01
	vol $a
	env $0 $01
	note c6  $08
	cmdff

soundcdChannel3:
	duty $00
	vol $0
	rest $03
	vol $d
	note g5  $03
	vol $a
	env $0 $01
	note g5  $08
	cmdff

soundcdChannel7:
	cmdf0 $a1
	note $07 $01
	cmdf0 $91
	note $14 $01
	cmdf0 $81
	note $15 $01
	cmdf0 $71
	note $16 $01
	cmdf0 $61
	note $17 $02
	cmdff

sound5eStart:

sound5eChannel2:
	duty $01
	vol $d
	note ds7 $04
	vol $0
	rest $01
	vol $d
	note f7  $04
	vol $0
	rest $01
	vol $d
	note g7  $04
	vol $0
	rest $01
	vol $d
	note as7 $04
	vol $0
	rest $02
	vol $6
	note as7 $04
	vol $0
	rest $02
	vol $2
	note as7 $04
	cmdff

sound6aStart:

sound6aChannel7:
	cmdf0 $b0
	note $17 $01
	note $25 $01
	note $27 $01
	note $35 $01
	note $37 $01
	note $45 $01
	note $47 $01
	cmdff

sound76Start:

sound76Channel2:
	duty $00
	vol $0
	cmdf8 $00
	env $0 $00
	note c7  $01
	vol $f
	cmdf8 $00
	env $0 $01
	note c2  $01
	vol $e
	cmdf8 $00
	env $0 $01
	note c7  $01
	vol $0
	note c7  $02
	cmdff

sound76Channel7:
	cmdf0 $10
	note $26 $01
	cmdf0 $70
	note $24 $01
	cmdf0 $00
	note $36 $01
	cmdff

sound75Start:

sound75Channel7:
	cmdf0 $30
	note $27 $01
	cmdf0 $60
	note $27 $01
	cmdf0 $90
	note $17 $01
	cmdf0 $c0
	note $17 $01
	cmdf0 $f0
	note $07 $01
	cmdff

soundd1Start:

soundd1Channel2:
	duty $01
	vol $2
	note cs5 $02
	note ds5 $02
	vol $4
	note cs5 $02
	note ds5 $02
	vol $6
	note cs5 $02
	note ds5 $02
	vol $8
	note cs5 $02
	note ds5 $02
	vol $a
	note cs5 $02
	note ds5 $02
	vol $8
	note cs5 $02
	note ds5 $02
	vol $6
	note cs5 $02
	note ds5 $02
	vol $4
	note cs5 $02
	note ds5 $02
	vol $2
	note cs5 $02
	note ds5 $02
	vol $1
	note cs5 $02
	note ds5 $02
	rest $0a
	duty $02
	vol $1
	note as3 $01
	vol $1
	note a2  $01
	vol $1
	note gs3 $01
	vol $1
	note b3  $01
	vol $1
	note as2 $01
	vol $1
	note a3  $01
	vol $2
	note c4  $01
	vol $1
	note b2  $01
	vol $1
	note as3 $01
	vol $3
	note cs4 $01
	vol $1
	note c3  $01
	vol $1
	note b3  $01
	vol $4
	note d4  $01
	vol $2
	note cs3 $01
	vol $2
	note c4  $01
	vol $5
	note ds4 $01
	vol $3
	note d3  $01
	vol $3
	note cs4 $01
	vol $6
	note e4  $01
	vol $4
	note ds3 $01
	vol $4
	note d4  $01
	vol $7
	note f4  $01
	vol $5
	note e3  $01
	vol $5
	note ds4 $01
	vol $8
	note fs4 $01
	vol $6
	note f3  $01
	vol $6
	note e4  $01
	vol $9
	note g4  $01
	vol $7
	note fs3 $01
	vol $7
	note f4  $01
	vol $a
	note gs4 $01
	vol $8
	note g3  $01
	vol $8
	note fs4 $01
	vol $7
	note ds4 $01
	vol $5
	note d3  $01
	vol $5
	note cs4 $01
	vol $8
	note e4  $01
	vol $6
	note ds3 $01
	vol $6
	note d4  $01
	vol $9
	note f4  $01
	vol $7
	note e3  $01
	vol $7
	note ds4 $01
	vol $a
	note fs4 $01
	vol $8
	note f3  $01
	vol $8
	note e4  $01
	vol $a
	note g4  $01
	vol $8
	note fs3 $01
	vol $8
	note f4  $01
	vol $a
	note gs4 $01
	vol $8
	note g3  $01
	vol $8
	note fs4 $01
	vol $b
	note a4  $01
	vol $9
	note gs3 $01
	vol $9
	note g4  $01
	vol $c
	note as4 $01
	vol $a
	note a3  $01
	vol $a
	note gs4 $01
	vol $d
	note b4  $01
	vol $b
	note as3 $01
	vol $a
	note gs4 $01
	vol $e
	note c5  $01
	vol $c
	note b3  $01
	vol $9
	note a4  $01
	vol $d
	note cs5 $01
	vol $b
	note c4  $01
	vol $8
	note as4 $01
	vol $a
	note as3 $01
	vol $8
	note a2  $01
	vol $8
	note gs3 $01
	vol $a
	note b3  $01
	vol $8
	note as2 $01
	vol $8
	note a3  $01
	vol $a
	note c4  $01
	vol $8
	note b2  $01
	vol $8
	note as3 $01
	vol $a
	note cs4 $01
	vol $8
	note c3  $01
	vol $8
	note b3  $01
	vol $a
	note d4  $01
	vol $8
	note cs3 $01
	vol $8
	note c4  $01
	vol $a
	note ds4 $01
	vol $8
	note d3  $01
	vol $8
	note cs4 $01
	vol $a
	note e4  $01
	vol $8
	note ds3 $01
	vol $8
	note d4  $01
	vol $a
	note f4  $01
	vol $8
	note e3  $01
	vol $8
	note ds4 $01
	vol $a
	note fs4 $01
	vol $8
	note f3  $01
	vol $8
	note e4  $01
	vol $a
	note g4  $01
	vol $8
	note fs3 $01
	vol $8
	note f4  $01
	vol $a
	note gs4 $01
	vol $8
	note g3  $01
	vol $8
	note fs4 $01
	vol $b
	note a4  $01
	vol $9
	note gs3 $01
	vol $9
	note g4  $01
	vol $c
	note as4 $01
	vol $a
	note a3  $01
	vol $a
	note gs4 $01
	vol $d
	note b4  $01
	vol $b
	note as3 $01
	vol $a
	note gs4 $01
	vol $e
	note c5  $01
	vol $c
	note b3  $01
	vol $9
	note a4  $01
	vol $e
	note cs5 $01
	vol $c
	note c4  $01
	vol $9
	note as4 $01
	vol $d
	note d5  $01
	vol $b
	note cs4 $01
	vol $8
	note b4  $01
	vol $d
	note ds5 $01
	vol $b
	note d4  $01
	vol $8
	note c5  $01
	vol $c
	note e5  $01
	vol $a
	note ds4 $01
	vol $7
	note cs5 $01
	vol $b
	note f5  $01
	vol $9
	note e4  $01
	vol $6
	note d5  $01
	vol $a
	note fs5 $01
	vol $8
	note f4  $01
	vol $5
	note ds5 $01
	vol $9
	note g5  $01
	vol $7
	note fs4 $01
	vol $4
	note e5  $01
	vol $8
	note gs5 $01
	vol $6
	note g4  $01
	vol $3
	note f5  $01
	vol $7
	note a5  $01
	vol $5
	note gs4 $01
	vol $2
	note fs5 $01
	vol $6
	note as5 $01
	vol $4
	note a4  $01
	vol $1
	note g5  $01
	vol $5
	note b5  $01
	vol $3
	note as4 $01
	vol $1
	note gs5 $01
	vol $4
	note c6  $01
	vol $2
	note b4  $01
	vol $1
	note a5  $01
	vol $3
	note cs6 $01
	vol $1
	note c5  $01
	vol $2
	note d6  $01
	vol $1
	note cs5 $01
	vol $1
	note ds6 $01
	vol $1
	note d5  $01
	vol $1
	note e6  $01
	cmdff

soundd1Channel3:
	duty $01
	cmdfd $ff
	vol $0
	note gs3 $0d
	vol $1
	note cs5 $02
	note ds5 $02
	vol $2
	note cs5 $02
	note ds5 $02
	vol $3
	note cs5 $02
	note ds5 $02
	vol $5
	note cs5 $02
	note ds5 $02
	vol $7
	note cs5 $02
	note ds5 $02
	vol $5
	note cs5 $02
	note ds5 $02
	vol $3
	note cs5 $02
	note ds5 $02
	vol $2
	note cs5 $02
	note ds5 $02
	vol $1
	note cs5 $02
	note ds5 $02
	rest $0a
	duty $00
	env $2 $00
	cmdfd $00
	vol $5
	note c7  $0d
	vol $2
	note c7  $17
	vol $3
	note c7  $08
	vol $6
	note c7  $0c
	vol $2
	note c7  $11
	vol $4
	note c7  $16
	vol $2
	note c7  $0a
	vol $1
	note c7  $10
	rest $18
	cmdff

soundd1Channel5:
	rest $cc
	cmdff

soundd1Channel7:
	cmdf0 $00
	note $15 $30
	cmdf0 $10
	note $36 $03
	cmdf0 $10
	note $35 $03
	cmdf0 $20
	note $34 $03
	cmdf0 $30
	note $27 $03
	note $26 $03
	note $25 $03
	note $24 $6e
	cmdf0 $37
	note $24 $1c
	cmdff

soundd4Start:

soundd4Channel2:
	duty $02
	vol $4
	note ds6 $02
	vol $2
	note as5 $01
	vol $5
	note f5  $02
	vol $5
	note ds6 $02
	vol $3
	note as5 $01
	vol $6
	note f5  $02
	vol $6
	note ds6 $02
	vol $4
	note as5 $01
	vol $7
	note f5  $02
	vol $7
	note ds6 $02
	vol $5
	note as5 $01
	vol $8
	note f5  $02
	vol $8
	note ds6 $02
	vol $6
	note as5 $01
	vol $9
	note f5  $02
	vol $9
	note ds6 $02
	vol $7
	note as5 $01
	vol $a
	note f5  $02
	vol $7
	note ds6 $02
	vol $5
	note as5 $01
	vol $8
	note f5  $02
	vol $5
	note ds6 $02
	vol $3
	note as5 $01
	vol $6
	note f5  $02
	vol $3
	note ds6 $02
	vol $1
	note as5 $01
	vol $2
	note f5  $02
	vol $1
	note ds6 $02
	cmdff

soundc7Start:

soundc7Channel2:
	duty $00
	vol $d
	cmdf8 $c4
	note a2  $0a
	cmdf8 $00
	vol $e
	cmdf8 $37
	note f2  $0f
	cmdf8 $00
	cmdff

sound96Start:

sound96Channel2:
	duty $02
	vol $1
	note a6  $08
	vol $2
	note as6 $08
	vol $3
	note ds6 $08
	vol $4
	note e6  $08
	vol $6
	note a6  $08
	vol $8
	note as6 $08
	vol $9
	note ds6 $08
	vol $a
	note e6  $08
	vol $b
	note a6  $08
	vol $3
	note as6 $08
	vol $2
	note ds6 $08
	vol $1
	env $0 $07
	note e6  $08
	cmdff

sound9aStart:

sound9aChannel2:
	vol $9
	note f7  $08
	note gs7 $08
	note g7  $08
	note gs7 $08
	note f7  $08
	note gs7 $08
	note g7  $08
	note gs7 $08
	cmdff

sound9bStart:

sound9bChannel2:
	vol $8
	env $0 $02
	note b5  $0a
	note cs6 $0a
	note d6  $0a
	note a6  $0f
	cmdff

sounda6Start:

sounda6Channel7:
	cmdf0 $80
	note $54 $01
	cmdf0 $80
	note $27 $02
	cmdf0 $b0
	note $15 $02
	cmdf0 $60
	note $27 $02
	cmdf0 $60
	note $47 $02
	cmdff
	cmdff
	cmdff
.bank $3b slot 1
.org 0

sound02Start:

sound03Start:

sound0dStart:

sound0fStart:

sound04Start:

sound08Start:

sound0aStart:

sound0bStart:

sound12Start:

sound24Start:

sound02Channel6:
sound03Channel6:
sound0dChannel6:
sound0fChannel6:
sound04Channel6:
sound08Channel6:
sound0aChannel6:
sound0bChannel6:
sound12Channel6:
sound24Channel6:
	cmdff

sound02Channel1:
musicec001:
	duty $02
	vol $a
	vibrato $00
	env $0 $01
	note as2 $0c
	note as3 $0c
	rest $0c
	note as3 $0c
	env $0 $02
	note as2 $0c
	env $0 $01
	note as3 $0c
	rest $0c
	note as3 $0c
	note gs2 $0c
	env $0 $01
	note gs3 $0c
	rest $0c
	note gs3 $0c
	note gs2 $0c
	env $0 $01
	note gs3 $0c
	rest $0c
	note gs3 $0c
	note fs2 $0c
	env $0 $01
	note fs3 $0c
	rest $0c
	note fs3 $0c
	note fs2 $0c
	env $0 $01
	note fs3 $0c
	rest $0c
	note fs3 $0c
	note cs3 $0c
	env $0 $01
	note cs4 $0c
	rest $0c
	note cs4 $0c
	note cs3 $0c
	env $0 $01
	note cs4 $0c
	rest $0c
	note cs4 $0c
	note b2  $0c
	env $0 $01
	note b3  $0c
	rest $0c
	note b3  $0c
	note b2  $0c
	env $0 $01
	note b3  $0c
	rest $0c
	note b3  $0c
	note as2 $0c
	env $0 $01
	note as3 $0c
	rest $0c
	note as3 $0c
	note as2 $0c
	env $0 $01
	note as3 $0c
	rest $0c
	note as3 $0c
	note c3  $0c
	note c4  $0c
	rest $0c
	note c4  $0c
	note c3  $0c
	note c4  $0c
	note as4 $0c
	note c4  $0c
	vibrato $00
	env $0 $03
	note f3  $0c
	vol $8
	env $0 $00
	note as4 $03
	env $0 $01
	vol $4
	note as4 $03
	vol $8
	env $0 $00
	note as4 $03
	env $0 $01
	vol $4
	note as4 $03
	vol $a
	env $0 $00
	note as4 $03
	env $0 $01
	vol $4
	note as4 $03
	env $0 $00
	vol $2
	note as4 $06
	vol $8
	env $0 $00
	note as4 $03
	env $0 $01
	vol $4
	note as4 $03
	vol $a
	env $0 $00
	note as4 $03
	env $0 $01
	vol $4
	note as4 $03
	env $0 $00
	vol $8
	note as4 $08
	vol $4
	note as4 $04
	vol $8
	env $0 $00
	note c3  $03
	env $0 $01
	vol $4
	note c3  $03
	vol $8
	env $0 $00
	note c3  $03
	env $0 $01
	vol $4
	note c3  $03
	vol $a
	env $0 $00
	note c3  $03
	env $0 $01
	vol $4
	note c3  $03
	env $0 $00
	vol $2
	note c3  $06
	vol $8
	env $0 $00
	note c3  $03
	env $0 $01
	vol $4
	note c3  $03
	vol $a
	env $0 $00
	note c3  $03
	env $0 $01
	vol $4
	note c3  $03
	env $0 $00
	vol $8
	note f3  $08
	vol $4
	note f3  $04
	vol $8
	env $0 $00
	note a4  $03
	env $0 $01
	vol $4
	note a4  $03
	vol $8
	env $0 $00
	note a4  $03
	env $0 $01
	vol $4
	note a4  $03
	vol $a
	env $0 $00
	note a4  $03
	env $0 $01
	vol $4
	note a4  $03
	env $0 $00
	vol $2
	note a4  $06
	vol $8
	env $0 $00
	note a4  $03
	env $0 $01
	vol $4
	note a4  $03
	vol $a
	env $0 $00
	note a4  $03
	env $0 $01
	vol $4
	note a4  $03
	env $0 $00
	vol $8
	note a4  $08
	vol $4
	note a4  $04
	vol $a
	env $0 $01
	note f2  $06
	vol $a
	note f2  $06
	vol $a
	note f2  $06
	vol $a
	note fs2 $05
	vol $1
	note fs2 $01
	vol $a
	note g2  $05
	vol $1
	note g2  $01
	vol $a
	note a2  $05
	vol $1
	note a2  $01
	goto musicec001
	cmdff

sound02Channel0:
musicec174:
	duty $02
	vol $0
	note gs3 $6c
	vibrato $00
	env $0 $00
	vol $6
	note as5 $06
	rest $06
	note as5 $03
	rest $03
	note c6  $03
	rest $03
	note d6  $03
	rest $03
	note ds6 $03
	rest $03
	vibrato $00
	env $0 $07
	note f6  $30
	rest $18
	vibrato $00
	env $0 $00
	note cs6 $03
	rest $03
	note fs6 $03
	rest $03
	note gs6 $03
	rest $03
	note as6 $03
	rest $03
	vibrato $00
	env $0 $07
	note cs7 $30
	rest $24
	vibrato $00
	env $0 $00
	note cs6 $03
	rest $03
	note ds6 $03
	rest $03
	note f6  $06
	rest $06
	note cs6 $06
	rest $06
	vibrato $00
	env $0 $07
	note gs5 $18
	rest $24
	vibrato $00
	env $0 $00
	note ds6 $02
	rest $04
	note f6  $02
	rest $04
	note fs6 $02
	rest $0a
	note ds6 $02
	rest $04
	note f6  $02
	rest $04
	vibrato $00
	env $0 $04
	note fs6 $18
	rest $24
	vibrato $00
	env $0 $00
	note cs6 $02
	rest $04
	note ds6 $02
	rest $04
	note f6  $02
	rest $0a
	note cs6 $02
	rest $04
	note ds6 $02
	rest $04
	vibrato $00
	env $0 $04
	note f6  $18
	rest $24
	vibrato $00
	env $0 $00
	note c6  $02
	rest $04
	note d6  $02
	rest $04
	note e6  $02
	rest $0a
	note e6  $02
	rest $04
	note f6  $02
	rest $04
	note g6  $02
	rest $04
	note a6  $02
	rest $04
	note as6 $02
	rest $04
	note c7  $02
	rest $04
	note a6  $06
	rest $06
	vol $8
	note ds4 $03
	vol $2
	note ds4 $03
	vol $8
	note ds4 $03
	vol $2
	note ds4 $03
	vol $a
	note ds4 $03
	vol $2
	note ds4 $03
	vol $1
	note ds4 $06
	vol $8
	note ds4 $03
	vol $2
	note ds4 $03
	vol $8
	note ds4 $03
	vol $2
	note ds4 $03
	vol $a
	note ds4 $08
	vol $3
	note ds4 $0a
	vol $1
	note ds4 $0a
	rest $20
	vol $8
	note ds4 $03
	vol $2
	note ds4 $03
	vol $8
	note ds4 $03
	vol $2
	note ds4 $03
	vol $a
	note ds4 $03
	vol $2
	note ds4 $03
	vol $1
	note ds4 $06
	vol $8
	note ds4 $03
	vol $2
	note ds4 $03
	vol $8
	note ds4 $03
	vol $2
	note ds4 $03
	vol $a
	note ds4 $08
	vol $3
	note ds4 $0a
	vol $1
	note ds4 $0a
	rest $14
	goto musicec174
	cmdff

sound02Channel4:
musicec29a:
	duty $01
	note as4 $06
	rest $12
	note f4  $1e
	rest $0c
	note as4 $04
	rest $02
	note as4 $06
	note c5  $03
	rest $03
	note d5  $03
	rest $03
	note ds5 $03
	rest $03
	note f5  $2a
	rest $12
	note f5  $09
	rest $03
	note f5  $0c
	note fs5 $03
	rest $03
	note gs5 $03
	rest $03
	note as5 $2a
	rest $12
	note as5 $09
	rest $03
	note as5 $0c
	note gs5 $03
	rest $03
	note fs5 $03
	rest $03
	note gs5 $06
	rest $0c
	note fs5 $06
	note f5  $24
	rest $0c
	note f5  $18
	note ds5 $0c
	rest $06
	note f5  $06
	note fs5 $24
	rest $0c
	note f5  $0c
	note ds5 $0c
	note cs5 $0c
	rest $06
	note ds5 $06
	note f5  $24
	rest $0c
	note ds5 $0c
	note cs5 $0c
	note c5  $0c
	rest $06
	note d5  $06
	note e5  $24
	rest $0c
	note g5  $18
	note f5  $08
	rest $b8
	goto musicec29a
	cmdff

sound11Start:

sound11Channel1:
	vibrato $00
	duty $02
	env $0 $00
	vol $5
	note as4 $07
	vol $3
	note as4 $07
	rest $0e
	env $0 $00
	vol $5
	note f4  $15
	vol $3
	note f4  $15
	env $0 $02
	vol $5
	note as4 $07
	rest $07
	vibrato $00
	env $0 $02
	note as4 $07
	note c5  $07
	note d5  $07
	note ds5 $07
	vibrato $00
	env $0 $00
	note f5  $1c
	vol $3
	note f5  $0e
	vol $2
	note f5  $0e
	rest $38
	env $0 $00
	vol $5
	note as5 $07
	vol $3
	note as5 $07
	rest $0e
	env $0 $00
	vol $5
	note f5  $15
	vol $3
	note f5  $15
	env $0 $02
	vol $5
	note as5 $07
	rest $07
	env $0 $02
	note as5 $07
	note c6  $07
	note d6  $07
	note ds6 $07
	env $0 $00
	note f6  $1c
	vol $3
	note f6  $0e
	vol $2
	note f6  $0e
	rest $38
musicec37c:
	env $0 $00
	vol $5
	note as4 $07
	vol $3
	note as4 $07
	rest $0e
	env $0 $00
	vol $5
	note f4  $15
	vol $3
	note f4  $15
	env $0 $02
	vol $5
	note as4 $07
	rest $07
	env $0 $02
	note as4 $07
	note c5  $07
	note d5  $07
	note ds5 $07
	vibrato $00
	env $0 $00
	note f5  $1c
	vol $3
	note f5  $0e
	vol $2
	note f5  $0e
	rest $38
	env $0 $00
	vol $5
	note as5 $07
	vol $3
	note as5 $07
	rest $0e
	env $0 $00
	vol $5
	note f5  $15
	vol $3
	note f5  $15
	env $0 $02
	vol $5
	note as5 $07
	rest $07
	env $0 $02
	note as5 $07
	note c6  $07
	note d6  $07
	note ds6 $07
	vibrato $00
	env $0 $08
	note f6  $1c
	vol $3
	note f6  $0e
	vol $2
	note f6  $0e
	rest $38
	goto musicec37c
	cmdff

sound11Channel0:
	vol $0
	note gs3 $70
	vibrato $00
	env $0 $00
	duty $02
	vol $8
	note gs3 $07
	vol $4
	note gs3 $07
	rest $0e
	vol $8
	note ds3 $15
	vol $3
	note ds3 $15
	vol $8
	env $0 $01
	note gs3 $07
	rest $07
	env $0 $00
	vol $8
	note gs3 $04
	vol $2
	note gs3 $03
	vol $8
	note as3 $04
	vol $2
	note as3 $03
	vol $8
	note c4  $04
	vol $2
	note c4  $03
	vol $8
	note ds4 $04
	vol $2
	note ds4 $03
	vol $8
	vol $8
	note fs4 $04
	vol $2
	note fs4 $03
	rest $85
	env $0 $00
	vol $8
	note gs4 $07
	vol $4
	note gs4 $07
	rest $0e
	vol $8
	note ds4 $0e
	vol $3
	note ds4 $0e
	env $0 $00
	vol $8
	note gs4 $04
	vol $2
	note gs4 $03
	vol $8
	note ds4 $04
	vol $2
	note ds4 $03
	vol $8
	note c4  $04
	vol $2
	note c4  $03
	vol $8
	note gs3 $04
	vol $2
	note gs3 $03
musicec44d:
	vol $8
	note as3 $04
	vol $2
	note as3 $03
	rest $69
	env $0 $00
	vol $8
	note gs3 $07
	vol $4
	note gs3 $07
	rest $0e
	vol $8
	note ds3 $15
	vol $3
	note ds3 $15
	vol $8
	env $0 $01
	note gs3 $07
	rest $07
	env $0 $00
	vol $8
	note gs3 $04
	vol $2
	note gs3 $03
	vol $8
	note as3 $04
	vol $2
	note as3 $03
	vol $8
	note c4  $04
	vol $2
	note c4  $03
	vol $8
	note ds4 $04
	vol $2
	note ds4 $03
	vol $8
	note fs4 $04
	vol $2
	note fs4 $03
	rest $85
	env $0 $00
	vol $8
	note gs4 $07
	vol $4
	note gs4 $07
	rest $0e
	vol $8
	note ds4 $0e
	vol $3
	note ds4 $0e
	env $0 $00
	vol $8
	note gs4 $04
	vol $2
	note gs4 $03
	vol $8
	note ds4 $04
	vol $2
	note ds4 $03
	vol $8
	note c4  $04
	vol $2
	note c4  $03
	vol $8
	note gs3 $04
	vol $2
	note gs3 $03
	goto musicec44d
	cmdff

sound11Channel4:
	duty $0a
	note as2 $03
	duty $0d
	note as2 $05
	rest $06
	duty $0a
	note as2 $03
	duty $0d
	note as2 $05
	rest $14
	duty $0a
	note as2 $03
	duty $0d
	note as2 $05
	rest $06
	duty $0a
	note as2 $03
	duty $0d
	note as2 $05
	rest $06
	duty $0a
	note as2 $03
	duty $0d
	note as2 $05
	rest $14
	duty $0a
	note as2 $03
	duty $0d
	note as2 $05
	rest $06
	duty $0a
	note gs2 $03
	duty $0d
	note gs2 $05
	rest $06
	duty $0a
	note gs2 $03
	duty $0d
	note gs2 $05
	rest $14
	duty $0a
	note gs2 $03
	duty $0d
	note gs2 $05
	rest $06
	duty $0a
	note gs2 $03
	duty $0d
	note gs2 $05
	rest $06
	duty $0a
	note gs2 $03
	duty $0d
	note gs2 $05
	rest $14
	duty $0a
	note gs2 $03
	duty $0d
	note gs2 $05
	rest $06
	duty $0a
	note fs2 $03
	duty $0d
	note fs2 $05
	rest $06
	duty $0a
	note fs2 $03
	duty $0d
	note fs2 $05
	rest $14
	duty $0a
	note fs2 $03
	duty $0d
	note fs2 $05
	rest $06
	duty $0a
	note fs2 $03
	duty $0d
	note fs2 $05
	rest $06
	duty $0a
	note fs2 $03
	duty $0d
	note fs2 $05
	rest $14
	duty $0a
	note fs2 $03
	duty $0d
	note fs2 $05
	rest $06
	duty $0a
	note gs2 $03
	duty $0d
	note gs2 $05
	rest $06
	duty $0a
	note gs2 $03
	duty $0d
	note gs2 $05
	rest $14
	duty $0a
	note gs2 $03
	duty $0d
	note gs2 $05
	rest $06
	duty $0a
	note gs2 $03
	duty $0d
	note gs2 $05
	rest $06
	duty $0a
	note gs2 $03
	duty $0d
	note gs2 $05
	rest $14
	duty $0a
	note gs2 $03
	duty $0d
	note gs2 $05
	rest $06
musicec5ac:
	duty $0a
	note as2 $03
	duty $0d
	note as2 $05
	rest $06
	duty $0a
	note as2 $03
	duty $0d
	note as2 $05
	rest $14
	duty $0a
	note as2 $03
	duty $0d
	note as2 $05
	rest $06
	duty $0a
	note as2 $03
	duty $0d
	note as2 $05
	rest $06
	duty $0a
	note as2 $03
	duty $0d
	note as2 $05
	rest $14
	duty $0a
	note as2 $03
	duty $0d
	note as2 $05
	rest $06
	duty $0a
	note gs2 $03
	duty $0d
	note gs2 $05
	rest $06
	duty $0a
	note gs2 $03
	duty $0d
	note gs2 $05
	rest $14
	duty $0a
	note gs2 $03
	duty $0d
	note gs2 $05
	rest $06
	duty $0a
	note gs2 $03
	duty $0d
	note gs2 $05
	rest $06
	duty $0a
	note gs2 $03
	duty $0d
	note gs2 $05
	rest $14
	duty $0a
	note gs2 $03
	duty $0d
	note gs2 $05
	rest $06
	duty $0a
	note fs2 $03
	duty $0d
	note fs2 $05
	rest $06
	duty $0a
	note fs2 $03
	duty $0d
	note fs2 $05
	rest $14
	duty $0a
	note fs2 $03
	duty $0d
	note fs2 $05
	rest $06
	duty $0a
	note fs2 $03
	duty $0d
	note fs2 $05
	rest $06
	duty $0a
	note fs2 $03
	duty $0d
	note fs2 $05
	rest $14
	duty $0a
	note fs2 $03
	duty $0d
	note fs2 $05
	rest $06
	duty $0a
	note gs2 $03
	duty $0d
	note gs2 $05
	rest $06
	duty $0a
	note gs2 $03
	duty $0d
	note gs2 $05
	rest $14
	duty $0a
	note gs2 $03
	duty $0d
	note gs2 $05
	rest $06
	duty $0a
	note gs2 $03
	duty $0d
	note gs2 $05
	rest $06
	duty $0a
	note gs2 $03
	duty $0d
	note gs2 $05
	rest $14
	duty $0a
	note gs2 $03
	duty $0d
	note gs2 $05
	rest $06
	goto musicec5ac
	cmdff

sound11Channel6:
	vol $5
	note $2a $0e
	note $2a $07
	note $2a $07
	note $2a $0e
	note $2a $07
	note $2a $07
	note $2a $0e
	note $2a $07
	note $2a $07
	note $2a $0e
	note $2a $07
	note $2a $07
	note $2a $0e
	note $2a $07
	note $2a $07
	note $2a $0e
	note $2a $07
	note $2a $07
	note $2a $0e
	note $2a $07
	note $2a $07
	note $2a $0e
	note $2a $07
	note $2a $07
	note $2a $0e
	note $2a $07
	note $2a $07
	note $2a $0e
	note $2a $07
	note $2a $07
	note $2a $0e
	note $2a $07
	note $2a $07
	note $2a $0e
	note $2a $07
	note $2a $07
	note $2a $0e
	note $2a $07
	note $2a $07
	note $2a $0e
	note $2a $07
	note $2a $07
	note $2a $0e
	note $2a $07
	note $2a $07
	note $2a $0e
	note $2a $07
	note $2a $07
musicec701:
	note $2a $0e
	note $2a $07
	note $2a $07
	note $2a $0e
	note $2a $07
	note $2a $07
	note $2a $0e
	note $2a $07
	note $2a $07
	note $2a $0e
	note $2a $07
	note $2a $07
	note $2a $0e
	note $2a $07
	note $2a $07
	note $2a $0e
	note $2a $07
	note $2a $07
	note $2a $0e
	note $2a $07
	note $2a $07
	note $2a $0e
	note $2a $07
	note $2a $07
	note $2a $0e
	note $2a $07
	note $2a $07
	note $2a $0e
	note $2a $07
	note $2a $07
	note $2a $0e
	note $2a $07
	note $2a $07
	note $2a $0e
	note $2a $07
	note $2a $07
	note $2a $0e
	note $2a $07
	note $2a $07
	note $2a $0e
	note $2a $07
	note $2a $07
	note $2a $0e
	note $2a $07
	note $2a $07
	note $2a $0e
	note $2a $07
	note $2a $07
	goto musicec701
	cmdff

sound0fChannel1:
	vibrato $00
	env $0 $02
	duty $02
musicec76b:
	vol $6
	note b3  $0c
	note cs4 $0c
	note e4  $0c
	note g4  $0c
	note b4  $0c
	note cs5 $0c
	note e5  $0c
	note g5  $0c
	note b5  $0c
	note cs6 $0c
	note e6  $0c
	note g6  $0c
	note b6  $0c
	note cs7 $0c
	note e7  $0c
	note g7  $0c
	note as3 $0c
	note c4  $0c
	note ds4 $0c
	note fs4 $0c
	note as4 $0c
	note c5  $0c
	note ds5 $0c
	note fs5 $0c
	note as5 $0c
	note c6  $0c
	note ds6 $0c
	note fs6 $0c
	note as6 $0c
	note c7  $0c
	note ds7 $0c
	note fs7 $0c
	goto musicec76b
	cmdff

sound0fChannel0:
	vol $1
	note b3  $06
	vibrato $00
	env $0 $02
	duty $02
musicec7b9:
	vol $6
	note b3  $0c
	note cs4 $0c
	note e4  $0c
	note g4  $0c
	note b4  $0c
	note cs5 $0c
	note e5  $0c
	note g5  $0c
	note b5  $0c
	note cs6 $0c
	note e6  $0c
	note g6  $0c
	note b6  $0c
	note cs7 $0c
	note e7  $0c
	note g7  $0c
	note as3 $0c
	note c4  $0c
	note ds4 $0c
	note fs4 $0c
	note as4 $0c
	note c5  $0c
	note ds5 $0c
	note fs5 $0c
	note as5 $0c
	note c6  $0c
	note ds6 $0c
	note fs6 $0c
	note as6 $0c
	note c7  $0c
	note ds7 $0c
	note fs7 $0c
	goto musicec7b9
	cmdff

sound0fChannel4:
	duty $0f
	rest $09
musicec802:
	note b3  $0c
	note cs4 $0c
	note e4  $0c
	note g4  $0c
	note b4  $0c
	note cs5 $0c
	note e5  $0c
	note g5  $0c
	note b5  $0c
	note cs6 $0c
	note e6  $0c
	note g6  $0c
	note b6  $0c
	note cs7 $0c
	note e7  $0c
	note g7  $0c
	note as3 $0c
	note c4  $0c
	note ds4 $0c
	note fs4 $0c
	note as4 $0c
	note c5  $0c
	note ds5 $0c
	note fs5 $0c
	note as5 $0c
	note c6  $0c
	note ds6 $0c
	note fs6 $0c
	note as6 $0c
	note c7  $0c
	note ds7 $0c
	note fs7 $0c
	goto musicec802
	cmdff

sound03Channel1:
	vibrato $00
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
	vibrato $e1
	env $0 $00
	note d5  $3c
	rest $0c
	vibrato $00
	env $0 $02
	note c5  $08
	note c5  $08
	note c5  $08
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
musicec8a5:
	vibrato $00
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
	env $0 $05
	note d5  $30
	env $0 $04
	rest $10
	note d5  $08
	note d5  $08
	note ds5 $08
	note f5  $08
	env $0 $05
	note g5  $30
	env $0 $04
	rest $10
	note g5  $08
	note g5  $08
	note f5  $08
	note ds5 $08
	vibrato $00
	env $0 $00
	note f5  $08
	rest $08
	note ds5 $08
	vibrato $00
	env $0 $05
	note d5  $18
	env $0 $04
	rest $18
	note d5  $08
	note ds5 $08
	note d5  $08
	note c5  $0c
	note c5  $06
	note d5  $06
	env $0 $05
	note ds5 $18
	env $0 $04
	rest $18
	note d5  $0c
	note c5  $0c
	note as4 $0c
	note as4 $06
	note c5  $06
	env $0 $05
	note d5  $18
	env $0 $04
	rest $18
	note c5  $0c
	note as4 $0c
	note a4  $0c
	note a4  $06
	note b4  $06
	env $0 $05
	note cs5 $18
	env $0 $04
	rest $18
	note e5  $18
	note d5  $0c
	vibrato $00
	env $0 $01
	duty $00
	vol $8
	note d4  $04
	note d4  $04
	note d4  $04
	vibrato $00
	vol $6
	env $0 $02
	note e4  $08
	note e4  $08
	note e4  $08
	vibrato $00
	env $0 $00
	vol $7
	note fs4 $18
	vol $6
	rest $18
	vibrato $00
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
	env $0 $05
	note d5  $30
	env $0 $04
	rest $10
	note d5  $08
	note d5  $08
	note ds5 $08
	note f5  $08
	env $0 $05
	note g5  $30
	env $0 $04
	rest $10
	note g5  $08
	note g5  $08
	note f5  $08
	note ds5 $08
	vibrato $00
	env $0 $00
	note f5  $08
	rest $08
	note ds5 $08
	vibrato $00
	env $0 $04
	note d5  $18
	env $0 $03
	rest $18
	note d5  $08
	note ds5 $08
	note d5  $08
	note c5  $0c
	note c5  $06
	note d5  $06
	env $0 $05
	note ds5 $18
	env $0 $04
	rest $18
	note d5  $0c
	note c5  $0c
	vol $6
	note as4 $08
	note a4  $08
	note as4 $08
	note c5  $08
	note as4 $08
	note c5  $08
	vibrato $00
	env $0 $00
	note d5  $08
	rest $08
	note d5  $08
	note d5  $08
	note c5  $08
	note as4 $08
	vibrato $e1
	env $0 $00
	vol $6
	note d5  $30
	note d6  $30
	vol $5
	note g5  $3c
	rest $0c
	vibrato $00
	env $0 $00
	vol $6
	duty $01
	note d5  $04
	rest $04
	note ds5 $04
	rest $04
	note f5  $04
	rest $04
	vibrato $e1
	env $0 $00
	note g5  $12
	rest $06
	note d5  $18
	rest $12
	vibrato $00
	env $0 $00
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
	note a5  $05
	rest $0b
	note f5  $05
	rest $03
	vibrato $f1
	note c5  $18
	rest $0c
	vibrato $00
	env $0 $00
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
	note d5  $05
	rest $0b
	note g4  $04
	rest $04
	vibrato $e1
	env $0 $00
	note g4  $18
	rest $0c
	vibrato $00
	env $0 $00
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
	vibrato $e1
	env $0 $00
	note d5  $24
	rest $24
	vibrato $00
	env $0 $00
	note d5  $04
	rest $04
	note c5  $04
	rest $04
	note d5  $04
	rest $04
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
	vibrato $e1
	env $0 $00
	note d6  $3c
	vibrato $01
	env $0 $00
	vol $3
	note d6  $0c
	vol $2
	note d6  $0c
	rest $18
	vibrato $00
	env $0 $01
	duty $02
	vol $6
	note d5  $04
	note d5  $04
	note d5  $04
	vibrato $00
	env $0 $02
	note e5  $08
	note e5  $08
	note e5  $08
	env $0 $04
	note fs5 $18
	rest $18
	vibrato $00
	env $0 $02
	goto musicec8a5
	cmdff

sound03Channel0:
	vibrato $00
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
	env $0 $04
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
	vibrato $e1
	env $0 $00
	note g4  $2a
	vibrato $01
	env $0 $00
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
	vibrato $e1
	env $0 $00
	note g4  $2a
	vibrato $01
	env $0 $00
	vol $2
	note g4  $0c
	vol $1
	note g4  $0c
	rest $1e
musicecb5a:
	vibrato $00
	env $0 $03
	vol $6
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
	vibrato $00
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
	vibrato $e0
	env $2 $00
	vol $4
	note g3  $18
	note fs3 $18
	note f3  $30
	vol $5
	note e3  $18
	vol $5
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
	note c5  $05
	rest $0b
	note as4 $05
	rest $03
	note a4  $18
	rest $18
	note f4  $14
	rest $04
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
	goto musicecb5a
	cmdff

sound03Channel4:
	duty $0e
	note g3  $04
	duty $0f
	note g3  $03
	rest $11
	duty $0e
	note g3  $04
	duty $0f
	note g3  $03
	rest $01
	duty $0e
	note g3  $04
	duty $0f
	note g3  $03
	rest $01
	duty $0e
	note g3  $04
	duty $0f
	note g3  $03
	rest $01
	duty $0e
	note f3  $04
	duty $0f
	note f3  $03
	rest $11
	duty $0e
	note f3  $04
	duty $0f
	note f3  $03
	rest $01
	duty $0e
	note f3  $04
	duty $0f
	note f3  $03
	rest $01
	duty $0e
	note f3  $04
	duty $0f
	note f3  $03
	rest $01
	duty $0e
	note ds3 $04
	duty $0f
	note ds3 $03
	rest $11
	duty $0e
	note ds3 $04
	duty $0f
	note ds3 $03
	rest $01
	duty $0e
	note ds3 $04
	duty $0f
	note ds3 $03
	rest $01
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
	duty $0e
	note f3  $04
	duty $0f
	note f3  $03
	rest $01
	duty $0e
	note f3  $04
	duty $0f
	note f3  $03
	rest $01
	duty $0e
	note f3  $04
	duty $0f
	note f3  $03
	rest $01
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
	duty $0e
	note g3  $04
	duty $0f
	note g3  $03
	rest $11
	duty $0e
	note g3  $04
	duty $0f
	note g3  $03
	rest $01
	duty $0e
	note g3  $04
	duty $0f
	note g3  $03
	rest $01
	duty $0e
	note g3  $04
	duty $0f
	note g3  $03
	rest $01
	duty $0e
	note g3  $04
	duty $0f
	note g3  $03
	rest $11
	duty $0e
	note d3  $04
	duty $0f
	note d3  $03
	rest $01
	duty $0e
	note d3  $04
	duty $0f
	note d3  $03
	rest $01
	duty $0e
	note d3  $04
	duty $0f
	note d3  $03
	rest $01
	duty $0e
	note g3  $04
	duty $0f
	note g3  $03
	rest $11
	duty $0e
	note g3  $04
	duty $0f
	note g3  $03
	rest $01
	duty $0e
	note g3  $04
	duty $0f
	note g3  $03
	rest $01
	duty $0e
	note g3  $04
	duty $0f
	note g3  $03
	rest $01
	duty $0e
	note g3  $04
	duty $0f
	note g3  $03
	rest $11
	duty $0e
	note d3  $04
	duty $0f
	note d3  $03
	rest $01
	duty $0e
	note d3  $04
	duty $0f
	note d3  $03
	rest $01
	duty $0e
	note d3  $04
	duty $0f
	note d3  $03
	rest $01
musicecee1:
	duty $0e
	note g2  $04
	duty $0f
	note g2  $03
	rest $11
	duty $0e
	note g2  $04
	duty $0f
	note g2  $03
	rest $01
	duty $0e
	note g2  $04
	duty $0f
	note g2  $03
	rest $01
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
	duty $0e
	note g2  $04
	duty $0f
	note g2  $03
	rest $11
	duty $0e
	note f2  $04
	duty $0f
	note f2  $03
	rest $11
	duty $0e
	note f2  $04
	duty $0f
	note f2  $03
	rest $01
	duty $0e
	note f2  $04
	duty $0f
	note f2  $03
	rest $01
	duty $0e
	note ds2 $04
	duty $0f
	note ds2 $03
	rest $01
	duty $0e
	note f2  $04
	duty $0f
	note f2  $03
	rest $11
	duty $0e
	note f2  $04
	duty $0f
	note f2  $03
	rest $11
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
	note ds2 $04
	duty $0f
	note ds2 $03
	rest $01
	duty $0e
	note d2  $04
	duty $0f
	note d2  $03
	rest $01
	duty $0e
	note ds2 $04
	duty $0f
	note ds2 $03
	rest $11
	duty $0e
	note ds2 $04
	duty $0f
	note ds2 $03
	rest $11
	duty $0e
	note as2 $04
	duty $0f
	note as2 $03
	rest $11
	duty $0e
	note as2 $04
	duty $0f
	note as2 $03
	rest $01
	duty $0e
	note as2 $04
	duty $0f
	note as2 $03
	rest $01
	duty $0e
	note gs2 $04
	duty $0f
	note gs2 $03
	rest $01
	duty $0e
	note as2 $04
	duty $0f
	note as2 $03
	rest $11
	duty $0e
	note as2 $04
	duty $0f
	note as2 $03
	rest $11
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
	note gs2 $04
	duty $0f
	note gs2 $03
	rest $01
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
	duty $0e
	note gs2 $04
	duty $0f
	note gs2 $03
	rest $01
	duty $0e
	note gs2 $04
	duty $0f
	note gs2 $03
	rest $01
	duty $0e
	note gs2 $04
	duty $0f
	note gs2 $03
	rest $01
	duty $0e
	note g2  $04
	duty $0f
	note g2  $03
	rest $11
	duty $0e
	note g2  $04
	duty $0f
	note g2  $03
	rest $01
	duty $0e
	note g2  $04
	duty $0f
	note g2  $03
	rest $01
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
	duty $0e
	note g2  $04
	duty $0f
	note g2  $03
	rest $01
	duty $0e
	note g2  $04
	duty $0f
	note g2  $03
	rest $01
	duty $0e
	note g2  $04
	duty $0f
	note g2  $03
	rest $01
	duty $0e
	note a2  $04
	duty $0f
	note a2  $03
	rest $11
	duty $0e
	note a2  $04
	duty $0f
	note a2  $03
	rest $01
	duty $0e
	note a2  $04
	duty $0f
	note a2  $03
	rest $01
	duty $0e
	note a2  $04
	duty $0f
	note a2  $03
	rest $01
	duty $0e
	note a2  $04
	duty $0f
	note a2  $03
	rest $11
	duty $0e
	note a2  $04
	duty $0f
	note a2  $03
	rest $01
	duty $0e
	note a2  $04
	duty $0f
	note a2  $03
	rest $01
	duty $0e
	note a2  $04
	duty $0f
	note a2  $03
	rest $01
	duty $0e
	note d3  $04
	duty $0f
	note d3  $03
	rest $11
	duty $0e
	note g3  $04
	duty $0f
	note g3  $03
	rest $01
	duty $0e
	note g3  $04
	duty $0f
	note g3  $03
	rest $01
	duty $0e
	note g3  $04
	duty $0f
	note g3  $03
	rest $01
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
	duty $0e
	note g2  $04
	duty $0f
	note g2  $03
	rest $11
	duty $0e
	note g2  $04
	duty $0f
	note g2  $03
	rest $01
	duty $0e
	note g2  $04
	duty $0f
	note g2  $03
	rest $01
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
	duty $0e
	note g2  $04
	duty $0f
	note g2  $03
	rest $11
	duty $0e
	note f2  $04
	duty $0f
	note f2  $03
	rest $11
	duty $0e
	note f2  $04
	duty $0f
	note f2  $03
	rest $01
	duty $0e
	note f2  $04
	duty $0f
	note f2  $03
	rest $01
	duty $0e
	note ds2 $04
	duty $0f
	note ds2 $03
	rest $01
	duty $0e
	note f2  $04
	duty $0f
	note f2  $03
	rest $11
	duty $0e
	note f2  $04
	duty $0f
	note f2  $03
	rest $11
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
	note ds2 $04
	duty $0f
	note ds2 $03
	rest $01
	duty $0e
	note d2  $04
	duty $0f
	note d2  $03
	rest $01
	duty $0e
	note ds2 $04
	duty $0f
	note ds2 $03
	rest $11
	duty $0e
	note ds2 $04
	duty $0f
	note ds2 $03
	rest $11
	duty $0e
	note as2 $04
	duty $0f
	note as2 $03
	rest $11
	duty $0e
	note as2 $04
	duty $0f
	note as2 $03
	rest $01
	duty $0e
	note as2 $04
	duty $0f
	note as2 $03
	rest $01
	duty $0e
	note gs2 $04
	duty $0f
	note gs2 $03
	rest $01
	duty $0e
	note as2 $04
	duty $0f
	note as2 $03
	rest $11
	duty $0e
	note as2 $04
	duty $0f
	note as2 $03
	rest $11
	duty $0e
	note gs2 $04
	duty $0f
	note gs2 $03
	rest $11
	duty $0e
	note gs3 $04
	duty $0f
	note gs3 $03
	rest $01
	duty $0e
	note gs3 $04
	duty $0f
	note gs3 $03
	rest $01
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
	duty $0e
	note gs3 $04
	duty $0f
	note gs3 $03
	rest $01
	duty $0e
	note gs3 $04
	duty $0f
	note gs3 $03
	rest $01
	duty $0e
	note gs3 $04
	duty $0f
	note gs3 $03
	rest $01
	duty $14
	vol $8
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
	vol $9
	note fs4 $08
	note g4  $08
	note a4  $08
	note as4 $08
	note c5  $08
	note as4 $08
	note a4  $08
	note as4 $18
	rest $18
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
	duty $0e
	note ds2 $04
	duty $0f
	note ds2 $03
	rest $01
	duty $0e
	note ds2 $04
	duty $0f
	note ds2 $03
	rest $01
	duty $0e
	note ds2 $04
	duty $0f
	note ds2 $03
	rest $01
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
	duty $0e
	note d3  $04
	duty $0f
	note d3  $03
	rest $01
	duty $0e
	note d3  $04
	duty $0f
	note d3  $03
	rest $01
	duty $0e
	note d3  $04
	duty $0f
	note d3  $03
	rest $01
	duty $0e
	note g2  $04
	duty $0f
	note g2  $03
	rest $11
	duty $0e
	note g2  $04
	duty $0f
	note g2  $03
	rest $01
	duty $0e
	note g2  $04
	duty $0f
	note g2  $03
	rest $01
	duty $0e
	note g2  $04
	duty $0f
	note g2  $03
	rest $01
	duty $0e
	note g2  $04
	duty $0f
	note g2  $03
	rest $11
	duty $0e
	note g2  $04
	duty $0f
	note g2  $03
	rest $01
	duty $0e
	note g2  $04
	duty $0f
	note g2  $03
	rest $01
	duty $0e
	note g2  $04
	duty $0f
	note g2  $03
	rest $01
	duty $0e
	note g2  $04
	duty $0f
	note g2  $03
	rest $11
	duty $0e
	note g2  $04
	duty $0f
	note g2  $03
	rest $01
	duty $0e
	note g2  $04
	duty $0f
	note g2  $03
	rest $01
	duty $0e
	note g2  $04
	duty $0f
	note g2  $03
	rest $01
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
	duty $0e
	note ds2 $04
	duty $0f
	note ds2 $03
	rest $01
	duty $0e
	note ds2 $04
	duty $0f
	note ds2 $03
	rest $01
	duty $0e
	note ds2 $04
	duty $0f
	note ds2 $03
	rest $01
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
	duty $0e
	note gs2 $04
	duty $0f
	note gs2 $03
	rest $01
	duty $0e
	note gs2 $04
	duty $0f
	note gs2 $03
	rest $01
	duty $0e
	note gs2 $04
	duty $0f
	note gs2 $03
	rest $01
	duty $0e
	note d2  $04
	duty $0f
	note d2  $03
	rest $11
	duty $0e
	note c4  $04
	duty $0f
	note c4  $03
	rest $01
	duty $0e
	note c4  $04
	duty $0f
	note c4  $03
	rest $01
	duty $0e
	note c4  $04
	duty $0f
	note c4  $03
	rest $01
	duty $0e
	note c4  $04
	duty $0f
	note c4  $03
	rest $11
	duty $0e
	note d2  $04
	duty $0f
	note d2  $03
	rest $01
	duty $0e
	note d2  $04
	duty $0f
	note d2  $03
	rest $01
	duty $0e
	note d2  $04
	duty $0f
	note d2  $03
	rest $01
	duty $0e
	note d2  $04
	duty $0f
	note d2  $03
	rest $11
	duty $0e
	note g4  $04
	duty $0f
	note g4  $03
	rest $01
	duty $0e
	note g4  $04
	duty $0f
	note g4  $03
	rest $01
	duty $0e
	note g4  $04
	duty $0f
	note g4  $03
	rest $01
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
	goto musicecee1
	cmdff

sound0dChannel1:
	vibrato $00
	env $0 $03
	duty $02
musiced519:
	vol $6
	note a2  $09
	vol $6
	note e3  $09
	note g3  $09
	note c4  $09
	note b3  $09
	note d4  $09
	note g4  $09
	note c5  $09
	note b4  $09
	note g4  $09
	note d4  $09
	note c4  $09
	note b3  $09
	note g3  $09
	note d3  $09
	note c3  $09
	note b2  $09
	note fs3 $09
	note g3  $09
	note d4  $09
	note b3  $09
	note fs4 $09
	note g4  $09
	note d5  $09
	note cs5 $09
	note g4  $09
	note fs4 $09
	note d4  $09
	note cs4 $09
	note g3  $09
	note fs3 $09
	note cs3 $09
	note c3  $09
	note g3  $09
	note as3 $09
	note ds4 $09
	note c4  $09
	note g4  $09
	note as4 $09
	note ds5 $09
	note d5  $09
	note as4 $09
	note f4  $09
	note ds4 $09
	note d4  $09
	note as3 $09
	note f3  $09
	note ds3 $09
	note d3  $09
	note g3  $09
	note a3  $09
	note c4  $09
	note d4  $09
	note g4  $09
	note c5  $09
	note f5  $09
	note e5  $09
	note c5  $09
	note g4  $09
	note f4  $09
	note e4  $09
	note c4  $09
	note g3  $09
	note e3  $09
	goto musiced519
	cmdff

sound0dChannel0:
	vibrato $00
	env $0 $03
	duty $02
	vol $1
	note a2  $09
	note e3  $04
musiced5aa:
	vol $4
	note a2  $09
	vol $4
	note e3  $09
	note g3  $09
	note c4  $09
	note b3  $09
	note d4  $09
	note g4  $09
	note c5  $09
	note b4  $09
	note g4  $09
	note d4  $09
	note c4  $09
	note b3  $09
	note g3  $09
	note d3  $09
	note c3  $09
	note b2  $09
	note fs3 $09
	note g3  $09
	note d4  $09
	note b3  $09
	note fs4 $09
	note g4  $09
	note d5  $09
	note cs5 $09
	note g4  $09
	note fs4 $09
	note d4  $09
	note cs4 $09
	note g3  $09
	note fs3 $09
	note cs3 $09
	note c3  $09
	note g3  $09
	note as3 $09
	note ds4 $09
	note c4  $09
	note g4  $09
	note as4 $09
	note ds5 $09
	note d5  $09
	note as4 $09
	note f4  $09
	note ds4 $09
	note d4  $09
	note as3 $09
	note f3  $09
	note ds3 $09
	note d3  $09
	note g3  $09
	note a3  $09
	note c4  $09
	note d4  $09
	note g4  $09
	note c5  $09
	note f5  $09
	note e5  $09
	note c5  $09
	note g4  $09
	note f4  $09
	note e4  $09
	note c4  $09
	note g3  $09
	note e3  $09
	goto musiced5aa
	cmdff

sound0dChannel4:
	duty $08
	note a2  $09
	note e3  $09
	note g3  $09
musiced638:
	note a2  $09
	note e3  $09
	note g3  $09
	note c4  $09
	note b3  $09
	note d4  $09
	note g4  $09
	note c5  $09
	note b4  $09
	note g4  $09
	note d4  $09
	note c4  $09
	note b3  $09
	note g3  $09
	note d3  $09
	note c3  $09
	note b2  $09
	note fs3 $09
	note g3  $09
	note d4  $09
	note b3  $09
	note fs4 $09
	note g4  $09
	note d5  $09
	note cs5 $09
	note g4  $09
	note fs4 $09
	note d4  $09
	note cs4 $09
	note g3  $09
	note fs3 $09
	note cs3 $09
	note c3  $09
	note g3  $09
	note as3 $09
	note ds4 $09
	note c4  $09
	note g4  $09
	note as4 $09
	note ds5 $09
	note d5  $09
	note as4 $09
	note f4  $09
	note ds4 $09
	note d4  $09
	note as3 $09
	note f3  $09
	note ds3 $09
	note d3  $09
	note g3  $09
	note a3  $09
	note c4  $09
	note d4  $09
	note g4  $09
	note c5  $09
	note f5  $09
	note e5  $09
	note c5  $09
	note g4  $09
	note f4  $09
	note e4  $09
	note c4  $09
	note g3  $09
	note e3  $09
	goto musiced638
	cmdff

sound34Start:

sound34Channel1:
	vibrato $00
	env $0 $00
	cmdf2
	duty $01
musiced6c3:
	vol $6
	note c4  $06
	rest $03
	vol $3
	note c4  $06
	rest $03
	vol $6
	note g4  $06
	note fs4 $48
	note f4  $48
	note ds4 $0c
	note f4  $06
	note ds4 $06
	note c4  $06
	rest $03
	vol $3
	note c4  $06
	rest $03
	vol $1
	note c4  $06
	vol $6
	note fs3 $30
	vol $3
	note fs3 $30
	rest $30
	vol $6
	note fs3 $06
	note g3  $06
	note c4  $06
	note ds4 $06
	note g4  $06
	rest $03
	vol $3
	note g4  $06
	rest $03
	vol $6
	note c5  $06
	note b4  $30
	note g4  $06
	rest $03
	vol $3
	note g4  $06
	rest $03
	vol $6
	note b4  $06
	note as4 $18
	note g4  $06
	rest $03
	vol $3
	note g4  $06
	rest $03
	vol $6
	note as4 $06
	note a4  $18
	note f4  $06
	rest $03
	vol $3
	note f4  $06
	rest $03
	vol $6
	note gs4 $06
	note g4  $0c
	note ds4 $06
	note c4  $06
	note g3  $06
	rest $03
	vol $3
	note g3  $06
	rest $03
	vol $1
	note g3  $06
	rest $30
	vol $6
	note g4  $0c
	note ds4 $06
	note c4  $06
	note g3  $06
	rest $03
	vol $3
	note g3  $06
	rest $03
	vol $1
	note g3  $06
	rest $18
	vol $6
	note d4  $06
	note ds4 $06
	note g4  $06
	note b4  $06
	note d5  $06
	rest $03
	vol $3
	note d5  $06
	rest $03
	vol $6
	note f5  $06
	note ds5 $30
	note b4  $06
	rest $03
	vol $3
	note b4  $06
	rest $03
	vol $7
	note d5  $06
	note c5  $18
	note g4  $06
	rest $03
	vol $3
	note g4  $06
	rest $03
	vol $7
	note as4 $06
	note a4  $18
	note f4  $06
	rest $03
	vol $3
	note f4  $06
	rest $03
	vol $7
	note gs4 $06
	note g4  $06
	rest $03
	vol $3
	note g4  $06
	rest $03
	vol $1
	note g4  $06
	vol $7
	note c4  $48
	vol $3
	note c4  $18
	rest $48
	vol $6
	note f4  $06
	rest $03
	vol $3
	note f4  $06
	rest $03
	vol $6
	note gs4 $06
	note cs5 $18
	note c5  $18
	note b4  $06
	rest $03
	vol $3
	note b4  $06
	rest $03
	vol $6
	note d5  $06
	note g5  $24
	vol $3
	note g5  $0c
	vol $6
	note gs5 $06
	rest $03
	vol $3
	note gs5 $06
	rest $03
	vol $6
	note f5  $06
	note cs6 $0c
	note c6  $0c
	note b5  $0c
	note as5 $0c
	note a5  $06
	rest $03
	vol $3
	note a5  $06
	rest $03
	vol $1
	note a5  $06
	vol $6
	note b4  $48
	goto musiced6c3
	cmdff

sound34Channel0:
	vibrato $00
	env $0 $00
	cmdf2
	duty $02
musiced7fa:
	vol $6
	note g3  $06
	rest $03
	vol $3
	note g3  $06
	rest $03
	vol $6
	note ds4 $06
	note d4  $48
	note cs4 $48
	note c4  $0c
	note cs4 $06
	note c4  $06
	note g3  $06
	rest $03
	vol $3
	note g3  $06
	rest $03
	vol $1
	note g3  $06
	rest $18
	vol $6
	note c5  $06
	rest $03
	vol $3
	note c5  $06
	rest $03
	vol $1
	note c5  $06
	vol $6
	note fs4 $06
	rest $03
	vol $3
	note fs4 $06
	rest $03
	vol $1
	note fs4 $06
	vol $6
	note c6  $06
	rest $03
	vol $3
	note c6  $06
	rest $03
	vol $1
	note c6  $06
	vol $6
	note fs5 $06
	rest $03
	vol $3
	note fs5 $06
	rest $03
	vol $1
	note fs5 $06
	vol $6
	note ds6 $06
	rest $03
	vol $3
	note ds6 $06
	rest $03
	vol $1
	note ds6 $06
	vol $6
	note c6  $06
	rest $03
	vol $3
	note c6  $03
	vol $4
	note fs3 $06
	note g3  $06
	note c4  $06
	note ds4 $06
	note g4  $08
	rest $04
	vol $6
	note ds4 $48
	note d4  $30
	note cs4 $30
	vol $6
	note ds4 $0c
	note c4  $06
	note g3  $06
	note ds3 $06
	rest $03
	vol $3
	note ds3 $06
	rest $03
	vol $1
	note ds3 $06
	rest $40
	vol $3
	note g4  $0c
	note ds4 $06
	note c4  $06
	note g3  $06
	rest $02
	vol $6
	note g6  $0c
	note ds6 $06
	note c6  $06
	note g5  $06
	note c4  $06
	note ds4 $06
	note g4  $06
	note b4  $06
	rest $03
	vol $3
	note b4  $06
	rest $03
	vol $1
	note b4  $06
	vol $6
	note c5  $30
	note f4  $18
	note ds4 $30
	note d4  $18
	note cs4 $18
	note c4  $06
	rest $03
	vol $3
	note c4  $06
	rest $03
	vol $1
	note c4  $06
	vol $6
	note g3  $48
	note g5  $06
	rest $03
	vol $3
	note g5  $06
	rest $03
	vol $1
	note g5  $06
	vol $6
	note c5  $06
	rest $03
	vol $3
	note c5  $06
	rest $03
	vol $1
	note c5  $06
	vol $6
	note g6  $06
	rest $03
	vol $3
	note g6  $06
	rest $03
	vol $1
	note g6  $06
	vol $6
	note c6  $06
	rest $03
	vol $3
	note c6  $06
	rest $03
	vol $1
	note c6  $06
	vol $3
	note cs4 $06
	rest $03
	vol $1
	note cs4 $06
	rest $03
	vol $6
	note f4  $06
	note gs4 $12
	vol $3
	note gs4 $06
	vol $6
	note f4  $12
	vol $3
	note f4  $06
	vol $6
	note d4  $06
	rest $03
	vol $3
	note d4  $06
	rest $03
	vol $6
	note g4  $06
	note b4  $18
	vol $3
	note b4  $18
	vol $6
	note f5  $06
	rest $03
	vol $3
	note f5  $06
	rest $03
	vol $6
	note cs5 $06
	note as5 $0c
	note a5  $0c
	note gs5 $0c
	note g5  $0c
	note f5  $06
	rest $03
	vol $3
	note f5  $06
	rest $03
	vol $1
	note f5  $06
	vol $6
	note gs4 $48
	goto musiced7fa
	cmdff

sound34Channel4:
	cmdf2
musiced957:
	duty $12
	note c3  $04
	duty $17
	note c3  $02
	duty $12
	note ds3 $04
	duty $17
	note c3  $02
	duty $12
	note g3  $04
	duty $17
	note ds3 $02
	duty $12
	note fs3 $04
	duty $17
	note g3  $02
	duty $12
	note c3  $04
	duty $17
	note fs3 $02
	duty $12
	note ds3 $04
	duty $17
	note c3  $02
	duty $12
	note g3  $04
	duty $17
	note ds3 $02
	duty $12
	note fs3 $04
	duty $17
	note g3  $02
	duty $12
	note c3  $04
	duty $17
	note fs3 $02
	duty $12
	note ds3 $04
	duty $17
	note c3  $02
	duty $12
	note g3  $04
	duty $17
	note ds3 $02
	duty $12
	note fs3 $04
	duty $17
	note g3  $02
	duty $12
	note c3  $04
	duty $17
	note fs3 $02
	duty $12
	note ds3 $04
	duty $17
	note c3  $02
	duty $12
	note g3  $04
	duty $17
	note ds3 $02
	duty $12
	note fs3 $04
	duty $17
	note g3  $02
	duty $12
	note c3  $04
	duty $17
	note c3  $02
	duty $12
	note ds3 $04
	duty $17
	note c3  $02
	duty $12
	note g3  $04
	duty $17
	note ds3 $02
	duty $12
	note fs3 $04
	duty $17
	note g3  $02
	duty $12
	note c3  $04
	duty $17
	note fs3 $02
	duty $12
	note ds3 $04
	duty $17
	note c3  $02
	duty $12
	note g3  $04
	duty $17
	note ds3 $02
	duty $12
	note fs3 $04
	duty $17
	note g3  $02
	duty $12
	note c3  $04
	duty $17
	note fs3 $02
	duty $12
	note ds3 $04
	duty $17
	note c3  $02
	duty $12
	note g3  $04
	duty $17
	note ds3 $02
	duty $12
	note fs3 $04
	duty $17
	note g3  $02
	duty $12
	note c3  $04
	duty $17
	note fs3 $02
	duty $12
	note ds3 $04
	duty $17
	note c3  $02
	duty $12
	note g3  $04
	duty $17
	note ds3 $02
	duty $12
	note fs3 $04
	duty $17
	note g3  $02
	duty $12
	note c3  $04
	duty $17
	note c3  $02
	duty $12
	note ds3 $04
	duty $17
	note c3  $02
	duty $12
	note g3  $04
	duty $17
	note ds3 $02
	duty $12
	note fs3 $04
	duty $17
	note g3  $02
	duty $12
	note c3  $04
	duty $17
	note fs3 $02
	duty $12
	note ds3 $04
	duty $17
	note c3  $02
	duty $12
	note g3  $04
	duty $17
	note ds3 $02
	duty $12
	note fs3 $04
	duty $17
	note g3  $02
	duty $12
	note c3  $04
	duty $17
	note fs3 $02
	duty $12
	note ds3 $04
	duty $17
	note c3  $02
	duty $12
	note g3  $04
	duty $17
	note ds3 $02
	duty $12
	note fs3 $04
	duty $17
	note g3  $02
	duty $12
	note c3  $04
	duty $17
	note fs3 $02
	duty $12
	note ds3 $04
	duty $17
	note c3  $02
	duty $12
	note g3  $04
	duty $17
	note ds3 $02
	duty $12
	note fs3 $04
	duty $17
	note g3  $02
	duty $12
	note c3  $04
	duty $17
	note c3  $02
	duty $12
	note ds3 $04
	duty $17
	note c3  $02
	duty $12
	note g3  $04
	duty $17
	note ds3 $02
	duty $12
	note fs3 $04
	duty $17
	note g3  $02
	duty $12
	note c3  $04
	duty $17
	note fs3 $02
	duty $12
	note ds3 $04
	duty $17
	note c3  $02
	duty $12
	note g3  $04
	duty $17
	note ds3 $02
	duty $12
	note fs3 $04
	duty $17
	note g3  $02
	duty $12
	note c3  $04
	duty $17
	note fs3 $02
	duty $12
	note ds3 $04
	duty $17
	note c3  $02
	duty $12
	note g3  $04
	duty $17
	note ds3 $02
	duty $12
	note fs3 $04
	duty $17
	note g3  $02
	duty $12
	note c3  $04
	duty $17
	note fs3 $02
	duty $12
	note ds3 $04
	duty $17
	note c3  $02
	duty $12
	note g3  $04
	duty $17
	note ds3 $02
	duty $12
	note fs3 $04
	duty $17
	note g3  $02
	duty $12
	note c3  $04
	duty $17
	note c3  $02
	duty $12
	note ds3 $04
	duty $17
	note c3  $02
	duty $12
	note g3  $04
	duty $17
	note ds3 $02
	duty $12
	note fs3 $04
	duty $17
	note g3  $02
	duty $12
	note c3  $04
	duty $17
	note fs3 $02
	duty $12
	note ds3 $04
	duty $17
	note c3  $02
	duty $12
	note g3  $04
	duty $17
	note ds3 $02
	duty $12
	note fs3 $04
	duty $17
	note g3  $02
	duty $12
	note c3  $04
	duty $17
	note fs3 $02
	duty $12
	note ds3 $04
	duty $17
	note c3  $02
	duty $12
	note g3  $04
	duty $17
	note ds3 $02
	duty $12
	note fs3 $04
	duty $17
	note g3  $02
	duty $12
	note c3  $04
	duty $17
	note fs3 $02
	duty $12
	note ds3 $04
	duty $17
	note c3  $02
	duty $12
	note g3  $04
	duty $17
	note ds3 $02
	duty $12
	note fs3 $04
	duty $17
	note g3  $02
	duty $12
	note c3  $04
	duty $17
	note c3  $02
	duty $12
	note ds3 $04
	duty $17
	note c3  $02
	duty $12
	note g3  $04
	duty $17
	note ds3 $02
	duty $12
	note fs3 $04
	duty $17
	note g3  $02
	duty $12
	note c3  $04
	duty $17
	note fs3 $02
	duty $12
	note ds3 $04
	duty $17
	note c3  $02
	duty $12
	note g3  $04
	duty $17
	note ds3 $02
	duty $12
	note fs3 $04
	duty $17
	note g3  $02
	duty $12
	note c3  $04
	duty $17
	note fs3 $02
	duty $12
	note ds3 $04
	duty $17
	note c3  $02
	duty $12
	note g3  $04
	duty $17
	note ds3 $02
	duty $12
	note fs3 $04
	duty $17
	note g3  $02
	duty $12
	note c3  $04
	duty $17
	note fs3 $02
	duty $12
	note ds3 $04
	duty $17
	note c3  $02
	duty $12
	note g3  $04
	duty $17
	note ds3 $02
	duty $12
	note fs3 $04
	duty $17
	note g3  $02
	duty $12
	note c3  $04
	duty $17
	note c3  $02
	duty $12
	note ds3 $04
	duty $17
	note c3  $02
	duty $12
	note g3  $04
	duty $17
	note ds3 $02
	duty $12
	note fs3 $04
	duty $17
	note g3  $02
	duty $12
	note c3  $04
	duty $17
	note fs3 $02
	duty $12
	note ds3 $04
	duty $17
	note c3  $02
	duty $12
	note g3  $04
	duty $17
	note ds3 $02
	duty $12
	note fs3 $04
	duty $17
	note g3  $02
	duty $12
	note c3  $04
	duty $17
	note fs3 $02
	duty $12
	note ds3 $04
	duty $17
	note c3  $02
	duty $12
	note g3  $04
	duty $17
	note ds3 $02
	duty $12
	note fs3 $04
	duty $17
	note g3  $02
	duty $12
	note c3  $04
	duty $17
	note fs3 $02
	duty $12
	note ds3 $04
	duty $17
	note c3  $02
	duty $12
	note g3  $04
	duty $17
	note ds3 $02
	duty $12
	note fs3 $04
	duty $17
	note g3  $02
	duty $12
	note c3  $04
	duty $17
	note c3  $02
	duty $12
	note ds3 $04
	duty $17
	note c3  $02
	duty $12
	note g3  $04
	duty $17
	note ds3 $02
	duty $12
	note fs3 $04
	duty $17
	note g3  $02
	duty $12
	note c3  $04
	duty $17
	note fs3 $02
	duty $12
	note ds3 $04
	duty $17
	note c3  $02
	duty $12
	note g3  $04
	duty $17
	note ds3 $02
	duty $12
	note fs3 $04
	duty $17
	note g3  $02
	duty $12
	note c3  $04
	duty $17
	note fs3 $02
	duty $12
	note ds3 $04
	duty $17
	note c3  $02
	duty $12
	note g3  $04
	duty $17
	note ds3 $02
	duty $12
	note fs3 $04
	duty $17
	note g3  $02
	duty $12
	note c3  $04
	duty $17
	note fs3 $02
	duty $12
	note ds3 $04
	duty $17
	note c3  $02
	duty $12
	note g3  $04
	duty $17
	note ds3 $02
	duty $12
	note fs3 $04
	duty $17
	note g3  $02
	duty $12
	note c3  $04
	duty $17
	note c3  $02
	duty $12
	note ds3 $04
	duty $17
	note c3  $02
	duty $12
	note g3  $04
	duty $17
	note ds3 $02
	duty $12
	note fs3 $04
	duty $17
	note g3  $02
	duty $12
	note c3  $04
	duty $17
	note fs3 $02
	duty $12
	note ds3 $04
	duty $17
	note c3  $02
	duty $12
	note g3  $04
	duty $17
	note ds3 $02
	duty $12
	note fs3 $04
	duty $17
	note g3  $02
	duty $12
	note c3  $04
	duty $17
	note fs3 $02
	duty $12
	note ds3 $04
	duty $17
	note c3  $02
	duty $12
	note g3  $04
	duty $17
	note ds3 $02
	duty $12
	note fs3 $04
	duty $17
	note g3  $02
	duty $12
	note c3  $04
	duty $17
	note fs3 $02
	duty $12
	note ds3 $04
	duty $17
	note c3  $02
	duty $12
	note g3  $04
	duty $17
	note ds3 $02
	duty $12
	note fs3 $04
	duty $17
	note g3  $02
	duty $12
	note c3  $04
	duty $17
	note c3  $02
	duty $12
	note ds3 $04
	duty $17
	note c3  $02
	duty $12
	note g3  $04
	duty $17
	note ds3 $02
	duty $12
	note fs3 $04
	duty $17
	note g3  $02
	duty $12
	note c3  $04
	duty $17
	note fs3 $02
	duty $12
	note ds3 $04
	duty $17
	note c3  $02
	duty $12
	note g3  $04
	duty $17
	note ds3 $02
	duty $12
	note fs3 $04
	duty $17
	note g3  $02
	duty $12
	note c3  $04
	duty $17
	note fs3 $02
	duty $12
	note ds3 $04
	duty $17
	note c3  $02
	duty $12
	note g3  $04
	duty $17
	note ds3 $02
	duty $12
	note fs3 $04
	duty $17
	note g3  $02
	duty $12
	note c3  $04
	duty $17
	note fs3 $02
	duty $12
	note ds3 $04
	duty $17
	note c3  $02
	duty $12
	note g3  $04
	duty $17
	note ds3 $02
	duty $12
	note fs3 $04
	duty $17
	note g3  $02
	duty $12
	note c3  $04
	duty $17
	note c3  $02
	duty $12
	note ds3 $04
	duty $17
	note c3  $02
	duty $12
	note g3  $04
	duty $17
	note ds3 $02
	duty $12
	note fs3 $04
	duty $17
	note g3  $02
	duty $12
	note c3  $04
	duty $17
	note fs3 $02
	duty $12
	note ds3 $04
	duty $17
	note c3  $02
	duty $12
	note g3  $04
	duty $17
	note ds3 $02
	duty $12
	note fs3 $04
	duty $17
	note g3  $02
	duty $12
	note c3  $04
	duty $17
	note fs3 $02
	duty $12
	note ds3 $04
	duty $17
	note c3  $02
	duty $12
	note g3  $04
	duty $17
	note ds3 $02
	duty $12
	note fs3 $04
	duty $17
	note g3  $02
	duty $12
	note c3  $04
	duty $17
	note fs3 $02
	duty $12
	note ds3 $04
	duty $17
	note c3  $02
	duty $12
	note g3  $04
	duty $17
	note ds3 $02
	duty $12
	note fs3 $04
	duty $17
	note g3  $02
	duty $12
	note c3  $04
	duty $17
	note c3  $02
	duty $12
	note ds3 $04
	duty $17
	note c3  $02
	duty $12
	note g3  $04
	duty $17
	note ds3 $02
	duty $12
	note fs3 $04
	duty $17
	note g3  $02
	duty $12
	note c3  $04
	duty $17
	note fs3 $02
	duty $12
	note ds3 $04
	duty $17
	note c3  $02
	duty $12
	note g3  $04
	duty $17
	note ds3 $02
	duty $12
	note fs3 $04
	duty $17
	note g3  $02
	duty $12
	note c3  $04
	duty $17
	note fs3 $02
	duty $12
	note ds3 $04
	duty $17
	note c3  $02
	duty $12
	note g3  $04
	duty $17
	note ds3 $02
	duty $12
	note fs3 $04
	duty $17
	note g3  $02
	duty $12
	note c3  $04
	duty $17
	note fs3 $02
	duty $12
	note ds3 $04
	duty $17
	note c3  $02
	duty $12
	note g3  $04
	duty $17
	note ds3 $02
	duty $12
	note fs3 $04
	duty $17
	note g3  $02
	duty $12
	note cs3 $04
	duty $17
	note fs3 $02
	duty $12
	note f3  $04
	duty $17
	note cs3 $02
	duty $12
	note g3  $04
	duty $17
	note f3  $02
	duty $12
	note gs3 $04
	duty $17
	note g3  $02
	duty $12
	note cs3 $04
	duty $17
	note gs3 $02
	duty $12
	note f3  $04
	duty $17
	note cs3 $02
	duty $12
	note g3  $04
	duty $17
	note f3  $02
	duty $12
	note gs3 $04
	duty $17
	note g3  $02
	duty $12
	note cs3 $04
	duty $17
	note gs3 $02
	duty $12
	note f3  $04
	duty $17
	note cs3 $02
	duty $12
	note g3  $04
	duty $17
	note f3  $02
	duty $12
	note gs3 $04
	duty $17
	note g3  $02
	duty $12
	note g2  $04
	duty $17
	note gs3 $02
	duty $12
	note b2  $04
	duty $17
	note g2  $02
	duty $12
	note c3  $04
	duty $17
	note b2  $02
	duty $12
	note d3  $04
	duty $17
	note c3  $02
	duty $12
	note ds3 $04
	duty $17
	note b2  $02
	duty $12
	note e3  $04
	duty $17
	note ds3 $02
	duty $12
	note f3  $04
	duty $17
	note e3  $02
	duty $12
	note fs3 $04
	duty $17
	note f3  $02
	duty $12
	note g3  $04
	duty $17
	note fs3 $02
	duty $12
	note gs3 $04
	duty $17
	note g3  $02
	duty $12
	note a3  $04
	duty $17
	note gs3 $02
	duty $12
	note as3 $04
	duty $17
	note a3  $02
	duty $12
	note cs3 $04
	duty $17
	note as3 $02
	duty $12
	note f3  $04
	duty $17
	note cs3 $02
	duty $12
	note g3  $04
	duty $17
	note f3  $02
	duty $12
	note gs3 $04
	duty $17
	note g3  $02
	duty $12
	note cs3 $04
	duty $17
	note gs3 $02
	duty $12
	note f3  $04
	duty $17
	note cs3 $02
	duty $12
	note g3  $04
	duty $17
	note f3  $02
	duty $12
	note gs3 $04
	duty $17
	note g3  $02
	duty $12
	note cs3 $04
	duty $17
	note f3  $02
	duty $12
	note f3  $04
	duty $17
	note cs3 $02
	duty $12
	note g3  $04
	duty $17
	note f3  $02
	duty $12
	note gs3 $04
	duty $17
	note g3  $02
	duty $12
	note as3 $04
	duty $17
	note gs3 $02
	duty $17
	note as3 $12
	duty $12
	note g2  $48
	goto musiced957
	cmdff
; BACKWARD GAP

sound34Channel6:
	cmdf2
musicee08c:
	vol $6
	note $24 $12
	note $24 $06
	vol $b
	note $28 $01
	vol $3
	note $27 $11
	vol $b
	note $28 $01
	vol $3
	note $27 $05
	vol $6
	note $24 $06
	vol $b
	note $28 $01
	vol $3
	note $27 $0b
	note $24 $06
	vol $b
	note $28 $01
	vol $3
	note $27 $0b
	vol $b
	note $28 $01
	vol $3
	note $27 $05
	vol $b
	note $28 $01
	vol $3
	note $27 $05
	vol $6
	note $24 $12
	note $24 $06
	vol $b
	note $28 $01
	vol $3
	note $27 $11
	vol $b
	note $28 $01
	vol $3
	note $27 $05
	vol $6
	note $24 $06
	vol $b
	note $28 $01
	vol $3
	note $27 $0b
	note $24 $06
	vol $b
	note $28 $01
	vol $3
	note $27 $0b
	vol $b
	note $28 $01
	vol $3
	note $27 $05
	vol $b
	note $28 $01
	vol $3
	note $27 $05
	vol $6
	note $24 $12
	note $24 $06
	vol $b
	note $28 $01
	vol $3
	note $27 $11
	vol $b
	note $28 $01
	vol $3
	note $27 $05
	vol $6
	note $24 $06
	vol $b
	note $28 $01
	vol $3
	note $27 $0b
	note $24 $06
	vol $b
	note $28 $01
	vol $3
	note $27 $0b
	vol $b
	note $28 $01
	vol $3
	note $27 $05
	vol $b
	note $28 $01
	vol $3
	note $27 $05
	vol $6
	note $24 $12
	note $24 $06
	vol $b
	note $28 $01
	vol $3
	note $27 $11
	vol $b
	note $28 $01
	vol $3
	note $27 $05
	vol $6
	note $24 $06
	vol $b
	note $28 $01
	vol $3
	note $27 $0b
	note $24 $06
	vol $b
	note $28 $01
	vol $3
	note $27 $0b
	vol $b
	note $28 $01
	vol $3
	note $27 $05
	vol $b
	note $28 $01
	vol $3
	note $27 $05
	vol $6
	note $24 $12
	note $24 $06
	vol $b
	note $28 $01
	vol $3
	note $27 $11
	vol $b
	note $28 $01
	vol $3
	note $27 $05
	vol $6
	note $24 $06
	vol $b
	note $28 $01
	vol $3
	note $27 $0b
	note $24 $06
	vol $b
	note $28 $01
	vol $3
	note $27 $0b
	vol $b
	note $28 $01
	vol $3
	note $27 $05
	vol $b
	note $28 $01
	vol $3
	note $27 $05
	vol $6
	note $24 $12
	note $24 $06
	vol $b
	note $28 $01
	vol $3
	note $27 $11
	vol $b
	note $28 $01
	vol $3
	note $27 $05
	vol $6
	note $24 $06
	vol $b
	note $28 $01
	vol $3
	note $27 $0b
	note $24 $06
	vol $b
	note $28 $01
	vol $3
	note $27 $0b
	vol $b
	note $28 $01
	vol $3
	note $27 $05
	vol $b
	note $28 $01
	vol $3
	note $27 $05
	vol $6
	note $24 $12
	note $24 $06
	vol $b
	note $28 $01
	vol $3
	note $27 $11
	vol $b
	note $28 $01
	vol $3
	note $27 $05
	vol $6
	note $24 $06
	vol $b
	note $28 $01
	vol $3
	note $27 $0b
	note $24 $06
	vol $b
	note $28 $01
	vol $3
	note $27 $0b
	vol $b
	note $28 $01
	vol $3
	note $27 $05
	vol $b
	note $28 $01
	vol $3
	note $27 $05
	vol $6
	note $24 $12
	note $24 $06
	vol $b
	note $28 $01
	vol $3
	note $27 $11
	vol $b
	note $28 $01
	vol $3
	note $27 $05
	vol $6
	note $24 $06
	vol $b
	note $28 $01
	vol $3
	note $27 $0b
	note $24 $06
	vol $b
	note $28 $01
	vol $3
	note $27 $0b
	vol $b
	note $28 $01
	vol $3
	note $27 $05
	vol $b
	note $28 $01
	vol $3
	note $27 $05
	vol $6
	note $24 $12
	note $24 $06
	vol $b
	note $28 $01
	vol $3
	note $27 $11
	vol $b
	note $28 $01
	vol $3
	note $27 $05
	vol $6
	note $24 $06
	vol $b
	note $28 $01
	vol $3
	note $27 $0b
	note $24 $06
	vol $b
	note $28 $01
	vol $3
	note $27 $0b
	vol $b
	note $28 $01
	vol $3
	note $27 $05
	vol $b
	note $28 $01
	vol $3
	note $27 $05
	vol $6
	note $24 $12
	note $24 $06
	vol $b
	note $28 $01
	vol $3
	note $27 $11
	vol $b
	note $28 $01
	vol $3
	note $27 $05
	vol $6
	note $24 $06
	vol $b
	note $28 $01
	vol $3
	note $27 $0b
	note $24 $06
	vol $b
	note $28 $01
	vol $3
	note $27 $0b
	vol $b
	note $28 $01
	vol $3
	note $27 $05
	vol $b
	note $28 $01
	vol $3
	note $27 $05
	vol $6
	note $24 $12
	note $24 $06
	vol $b
	note $28 $01
	vol $3
	note $27 $11
	vol $b
	note $28 $01
	vol $3
	note $27 $05
	vol $6
	note $24 $06
	vol $b
	note $28 $01
	vol $3
	note $27 $0b
	note $24 $06
	vol $b
	note $28 $01
	vol $3
	note $27 $0b
	vol $b
	note $28 $01
	vol $3
	note $27 $05
	vol $b
	note $28 $01
	vol $3
	note $27 $05
	vol $6
	note $24 $12
	note $24 $06
	vol $b
	note $28 $01
	vol $3
	note $27 $11
	vol $b
	note $28 $01
	vol $3
	note $27 $05
	vol $6
	note $24 $06
	vol $b
	note $28 $01
	vol $3
	note $27 $0b
	note $24 $06
	vol $b
	note $28 $01
	vol $3
	note $27 $0b
	vol $b
	note $28 $01
	vol $3
	note $27 $05
	vol $b
	note $28 $01
	vol $3
	note $27 $05
	vol $6
	note $24 $06
	vol $b
	note $28 $01
	vol $3
	note $27 $0b
	vol $b
	note $28 $01
	vol $3
	note $27 $05
	vol $b
	note $28 $01
	vol $3
	note $27 $05
	note $24 $0c
	vol $b
	note $28 $01
	vol $3
	note $27 $05
	vol $b
	note $28 $01
	vol $3
	note $27 $05
	note $24 $06
	vol $b
	note $28 $01
	vol $3
	note $27 $05
	vol $b
	note $28 $01
	vol $3
	note $27 $05
	vol $b
	note $28 $01
	vol $3
	note $27 $05
	vol $b
	note $28 $01
	vol $3
	note $27 $05
	vol $b
	note $28 $01
	vol $3
	note $27 $05
	vol $b
	note $28 $01
	vol $3
	note $27 $05
	vol $b
	note $28 $01
	vol $3
	note $27 $05
	vol $b
	note $28 $01
	vol $3
	note $27 $05
	vol $b
	note $28 $01
	vol $3
	note $27 $05
	vol $b
	note $28 $01
	vol $3
	note $27 $05
	vol $b
	note $28 $01
	vol $3
	note $27 $05
	vol $b
	note $28 $01
	vol $3
	note $27 $05
	vol $b
	note $28 $01
	vol $3
	note $27 $05
	vol $b
	note $28 $01
	vol $3
	note $27 $05
	note $24 $06
	vol $b
	note $28 $01
	vol $3
	note $27 $0b
	vol $b
	note $28 $01
	vol $3
	note $27 $05
	vol $b
	note $28 $01
	vol $3
	note $27 $05
	note $24 $06
	vol $b
	note $28 $01
	vol $3
	note $27 $05
	vol $b
	note $28 $01
	vol $3
	note $27 $05
	vol $b
	note $28 $01
	vol $3
	note $27 $05
	vol $b
	note $28 $01
	vol $3
	note $27 $05
	note $24 $06
	vol $b
	note $28 $01
	vol $3
	note $27 $05
	vol $b
	note $28 $01
	vol $3
	note $27 $0b
	vol $b
	note $28 $01
	vol $3
	note $27 $05
	vol $b
	note $28 $01
	vol $3
	note $27 $05
	vol $b
	note $28 $01
	vol $3
	note $27 $05
	vol $b
	note $28 $01
	vol $3
	note $27 $05
	vol $b
	note $28 $01
	vol $3
	note $27 $05
	vol $b
	note $28 $01
	vol $3
	note $27 $05
	vol $b
	note $28 $01
	vol $3
	note $27 $05
	vol $b
	note $28 $01
	vol $3
	note $27 $05
	vol $b
	note $28 $01
	vol $3
	note $27 $05
	vol $b
	note $28 $01
	vol $3
	note $27 $05
	vol $b
	note $28 $01
	vol $3
	note $27 $05
	vol $b
	note $28 $01
	vol $3
	note $27 $05
	vol $b
	note $28 $01
	vol $3
	note $27 $05
	vol $b
	note $28 $01
	vol $3
	note $27 $05
	goto musicee08c
	cmdff

sound04Channel1:
	vibrato $e1
	env $0 $00
	cmdf2
	duty $01
musicee3c8:
	vol $5
	note a4  $0e
	vol $3
	note a4  $0e
	vol $5
	note e4  $0e
	vol $3
	note e4  $0e
	rest $15
	vol $5
	note a4  $03
	rest $04
	note a4  $05
	rest $02
	note b4  $05
	rest $02
	note cs5 $05
	rest $02
	note d5  $05
	rest $02
	note e5  $38
	vibrato $01
	vol $3
	note e5  $0e
	rest $04
	vibrato $e1
	vol $5
	note e5  $06
	rest $04
	note e5  $05
	rest $04
	note f5  $06
	rest $03
	note g5  $06
	rest $04
	note a5  $38
	vibrato $01
	vol $3
	note a5  $0e
	rest $04
	vibrato $e1
	vol $5
	note a5  $06
	rest $04
	note a5  $05
	rest $04
	note g5  $06
	rest $03
	note f5  $06
	rest $04
	note g5  $09
	rest $05
	vol $3
	note g5  $03
	rest $01
	vol $5
	note f5  $0a
	note e5  $1c
	vibrato $01
	vol $3
	note e5  $1c
	vibrato $e1
	vol $5
	note e5  $09
	note f5  $09
	note e5  $0a
	note d5  $07
	vol $3
	note d5  $07
	vol $5
	note d5  $07
	note e5  $07
	note f5  $1c
	vibrato $01
	vol $3
	note f5  $1c
	vibrato $e1
	vol $5
	note e5  $0e
	note d5  $0e
	note c5  $07
	vol $3
	note c5  $07
	vol $5
	note c5  $07
	note d5  $07
	note e5  $1c
	vibrato $01
	vol $3
	note e5  $1c
	vibrato $e1
	vol $5
	note d5  $0e
	note c5  $0e
	note b4  $07
	vol $3
	note b4  $07
	vol $5
	note b4  $07
	note cs5 $07
	note ds5 $1c
	vibrato $01
	vol $3
	note ds5 $1c
	vibrato $e1
	vol $5
	note fs5 $1c
	note e5  $0e
	note e4  $01
	rest $02
	note e4  $01
	rest $05
	note e4  $01
	rest $04
	note fs4 $05
	rest $04
	note fs4 $06
	rest $03
	note fs4 $06
	rest $04
	note gs4 $1c
	vibrato $01
	vol $3
	note gs4 $1c
	vibrato $e1
	vol $5
	note a4  $0e
	vol $3
	note a4  $0e
	vol $5
	note e4  $0e
	vol $3
	note e4  $0e
	rest $15
	vol $5
	note a4  $03
	rest $04
	note a4  $05
	rest $02
	note b4  $05
	rest $02
	note cs5 $05
	rest $02
	note d5  $05
	rest $02
	note e5  $38
	vibrato $01
	vol $3
	note e5  $0e
	rest $04
	vibrato $e1
	vol $5
	note e5  $06
	rest $04
	note e5  $05
	rest $04
	note f5  $06
	rest $03
	note g5  $06
	rest $04
	note a5  $38
	vibrato $01
	vol $3
	note a5  $0e
	rest $04
	vibrato $e1
	vol $5
	note a5  $06
	rest $04
	note a5  $05
	rest $04
	note g5  $06
	rest $03
	note f5  $06
	rest $04
	note g5  $07
	rest $03
	vol $3
	note g5  $07
	rest $01
	vol $5
	note f5  $0a
	note e5  $1c
	vol $3
	note e5  $0e
	rest $0e
	vol $5
	note e5  $09
	note f5  $09
	note e5  $0a
	note d5  $07
	vol $3
	note d5  $07
	vol $5
	note d5  $07
	note e5  $07
	note f5  $1c
	vibrato $01
	vol $3
	note f5  $1c
	vibrato $e1
	vol $5
	note e5  $0e
	note d5  $0e
	note c5  $09
	note b4  $09
	note c5  $0a
	note d5  $09
	note c5  $09
	note d5  $0a
	note e5  $07
	vol $3
	note e5  $07
	rest $04
	vol $5
	note e5  $04
	rest $06
	note e5  $09
	note d5  $09
	note c5  $0a
	note e5  $38
	note e6  $38
	note a5  $46
	rest $0e
	note e5  $03
	vol $3
	note e5  $04
	rest $02
	vol $5
	note c5  $03
	vol $3
	note c5  $04
	rest $02
	vol $5
	note a4  $04
	vol $3
	note a4  $03
	rest $03
	goto musicee3c8
	cmdff

sound04Channel0:
	vibrato $e1
	env $0 $00
	cmdf2
	duty $01
musicee57d:
	vol $5
	note cs4 $0e
	vol $3
	note cs4 $0e
	vol $5
	note d4  $09
	note cs4 $09
	note b3  $0a
	note cs4 $0e
	vol $3
	note cs4 $07
	vol $5
	note cs4 $07
	note cs4 $05
	rest $02
	note d4  $05
	rest $02
	note e4  $05
	rest $02
	note fs4 $05
	rest $02
	note g4  $15
	note a4  $05
	rest $02
	note a4  $05
	rest $02
	note b4  $05
	rest $02
	note cs5 $05
	rest $02
	note d5  $05
	rest $02
	note e5  $07
	rest $03
	vol $3
	note e5  $07
	rest $04
	vol $2
	note e5  $07
	vol $5
	note g4  $09
	note a4  $09
	note b4  $0a
	note c5  $12
	note f4  $06
	rest $04
	note f4  $05
	rest $02
	note g4  $05
	rest $02
	note a4  $05
	rest $02
	note b4  $05
	rest $02
	note c5  $07
	rest $07
	vol $3
	note c5  $03
	rest $01
	vol $5
	note c5  $06
	rest $04
	note c5  $05
	rest $04
	note b4  $06
	rest $03
	note a4  $06
	rest $04
	note c5  $07
	rest $03
	vol $3
	note c5  $07
	rest $01
	vol $5
	note g4  $06
	rest $04
	note g4  $05
	rest $04
	note g4  $06
	rest $03
	note f4  $06
	rest $04
	note g4  $05
	rest $05
	vol $3
	note g4  $06
	rest $02
	vol $5
	note g4  $06
	rest $04
	note g4  $05
	rest $04
	note f4  $06
	rest $03
	note g4  $06
	rest $04
	note f4  $0b
	rest $03
	note f4  $07
	note e4  $07
	note f4  $0b
	rest $03
	note f4  $07
	note g4  $07
	note a4  $1c
	note g4  $0e
	note f4  $0e
	note e4  $0b
	rest $03
	note e4  $07
	note d4  $07
	note e4  $0b
	rest $03
	note e4  $07
	note f4  $07
	note g4  $1c
	note f4  $0e
	note e4  $0e
	note ds4 $15
	rest $07
	note ds4 $07
	rest $03
	vol $3
	note ds4 $04
	vol $5
	note ds4 $07
	note e4  $07
	note fs4 $07
	rest $03
	vol $3
	note fs4 $04
	vol $5
	note fs4 $07
	note g4  $07
	note a4  $07
	note b4  $07
	note cs5 $07
	note d5  $07
	note b4  $1c
	note d4  $05
	rest $04
	note d4  $06
	rest $03
	note d4  $06
	rest $04
	note e4  $1c
	vibrato $01
	vol $3
	note e4  $1c
	vibrato $e1
	vol $5
	note cs4 $0e
	vol $3
	note cs4 $0e
	vol $5
	note d4  $09
	note cs4 $09
	note b3  $0a
	note cs4 $0e
	vol $3
	note cs4 $07
	vol $5
	note cs4 $07
	note cs4 $05
	rest $02
	note d4  $05
	rest $02
	note e4  $05
	rest $02
	note fs4 $05
	rest $02
	note g4  $15
	note a4  $05
	rest $02
	note a4  $05
	rest $02
	note b4  $05
	rest $02
	note cs5 $05
	rest $02
	note d5  $05
	rest $02
	note e5  $1c
	note g4  $09
	note a4  $09
	note b4  $0a
	note c5  $12
	note f4  $06
	rest $04
	note f4  $05
	rest $02
	note g4  $05
	rest $02
	note a4  $05
	rest $02
	note b4  $05
	rest $02
	note c5  $07
	rest $03
	vol $3
	note c5  $07
	rest $01
	vol $5
	note c5  $06
	rest $04
	note c5  $05
	rest $04
	note b4  $06
	rest $03
	note a4  $06
	rest $04
	note c5  $07
	rest $03
	vol $3
	note c5  $07
	rest $01
	vol $5
	note g4  $06
	rest $04
	note g4  $05
	rest $04
	note g4  $06
	rest $03
	note f4  $06
	rest $04
	note g4  $05
	rest $05
	vol $3
	note g4  $06
	rest $02
	vol $5
	note g4  $06
	rest $04
	note g4  $05
	rest $04
	note f4  $06
	rest $03
	note g4  $06
	rest $04
	note f4  $0b
	rest $03
	note f4  $07
	note e4  $07
	note f4  $0b
	rest $03
	note f4  $07
	note g4  $07
	note a4  $1c
	note g4  $0e
	note f4  $0e
	note a3  $1c
	note gs3 $1c
	note g3  $38
	note fs3 $1c
	note d3  $1c
	note e3  $15
	rest $07
	vol $8
	note e3  $04
	rest $05
	note e4  $05
	rest $04
	note d4  $05
	rest $05
	note c4  $04
	rest $05
	note b3  $05
	rest $04
	note a3  $05
	rest $05
	note b3  $04
	rest $06
	vol $5
	note b3  $05
	rest $06
	vol $3
	note b3  $04
	rest $03
	vol $8
	note a3  $04
	rest $06
	vol $5
	note a3  $05
	rest $06
	vol $3
	note a3  $04
	rest $1f
	goto musicee57d
	cmdff

sound04Channel4:
musicee79b:
	duty $0e
	note a2  $04
	duty $0f
	note a2  $04
	rest $14
	duty $0e
	note a2  $04
	duty $0f
	note a2  $04
	rest $14
	duty $0e
	note a2  $04
	duty $0f
	note a2  $04
	rest $14
	duty $0e
	note a2  $04
	duty $0f
	note a2  $04
	rest $14
	duty $0e
	note g2  $04
	duty $0f
	note g2  $04
	rest $14
	duty $0e
	note g2  $04
	duty $0f
	note g2  $04
	rest $14
	duty $0e
	note g2  $04
	duty $0f
	note g2  $04
	rest $14
	duty $0e
	note g2  $04
	duty $0f
	note g2  $04
	rest $14
	duty $0e
	note f2  $04
	duty $0f
	note f2  $04
	rest $14
	duty $0e
	note f2  $04
	duty $0f
	note f2  $04
	rest $14
	duty $0e
	note f2  $04
	duty $0f
	note f2  $04
	rest $14
	duty $0e
	note f2  $04
	duty $0f
	note f2  $04
	rest $14
	duty $0e
	note c3  $04
	duty $0f
	note c3  $04
	rest $14
	duty $0e
	note c3  $04
	duty $0f
	note c3  $04
	rest $14
	duty $0e
	note c3  $04
	duty $0f
	note c3  $04
	rest $14
	duty $0e
	note c3  $04
	duty $0f
	note c3  $04
	rest $14
	duty $0e
	note as2 $04
	duty $0f
	note as2 $04
	rest $14
	duty $0e
	note as2 $04
	duty $0f
	note as2 $04
	rest $14
	duty $0e
	note as2 $04
	duty $0f
	note as2 $04
	rest $14
	duty $0e
	note as2 $04
	duty $0f
	note as2 $04
	rest $14
	duty $0e
	note a2  $04
	duty $0f
	note a2  $04
	rest $14
	duty $0e
	note a2  $04
	duty $0f
	note a2  $04
	rest $14
	duty $0e
	note a2  $04
	duty $0f
	note a2  $04
	rest $14
	duty $0e
	note a2  $04
	duty $0f
	note a2  $04
	rest $14
	duty $0e
	note b2  $04
	duty $0f
	note b2  $04
	rest $14
	duty $0e
	note b2  $04
	duty $0f
	note b2  $04
	rest $14
	duty $0e
	note b2  $04
	duty $0f
	note b2  $04
	rest $14
	duty $0e
	note b2  $04
	duty $0f
	note b2  $04
	rest $14
	duty $0e
	note e3  $04
	duty $0f
	note e3  $04
	rest $14
	duty $0e
	note a3  $04
	duty $0f
	note a3  $04
	rest $14
	duty $0e
	note b3  $1c
	note fs3 $04
	duty $0f
	note fs3 $04
	rest $06
	duty $0e
	note gs3 $04
	duty $0f
	note gs3 $04
	rest $06
	duty $0e
	note a2  $04
	duty $0f
	note a2  $04
	rest $14
	duty $0e
	note a2  $04
	duty $0f
	note a2  $04
	rest $14
	duty $0e
	note a2  $04
	duty $0f
	note a2  $04
	rest $14
	duty $0e
	note a2  $04
	duty $0f
	note a2  $04
	rest $14
	duty $0e
	note g2  $04
	duty $0f
	note g2  $04
	rest $14
	duty $0e
	note g2  $04
	duty $0f
	note g2  $04
	rest $14
	duty $0e
	note g2  $04
	duty $0f
	note g2  $04
	rest $14
	duty $0e
	note g2  $04
	duty $0f
	note g2  $04
	rest $14
	duty $0e
	note f2  $04
	duty $0f
	note f2  $04
	rest $14
	duty $0e
	note f2  $04
	duty $0f
	note f2  $04
	rest $14
	duty $0e
	note f2  $04
	duty $0f
	note f2  $04
	rest $14
	duty $0e
	note f2  $04
	duty $0f
	note f2  $04
	rest $14
	duty $0e
	note c3  $04
	duty $0f
	note c3  $04
	rest $14
	duty $0e
	note c3  $04
	duty $0f
	note c3  $04
	rest $14
	duty $0e
	note c3  $04
	duty $0f
	note c3  $04
	rest $14
	duty $0e
	note c3  $04
	duty $0f
	note c3  $04
	rest $14
	duty $0e
	note as2 $04
	duty $0f
	note as2 $04
	rest $14
	duty $0e
	note as2 $04
	duty $0f
	note as2 $04
	rest $14
	duty $0e
	note as2 $04
	duty $0f
	note as2 $04
	rest $14
	duty $0e
	note as2 $04
	duty $0f
	note as2 $04
	rest $14
	duty $17
	note e4  $09
	note ds4 $09
	note e4  $0a
	note gs4 $09
	note a4  $09
	note b4  $0a
	note c5  $09
	rest $09
	note c5  $0a
	note c5  $09
	note b4  $09
	note a4  $0a
	note e5  $0e
	rest $04
	note c5  $0e
	rest $05
	note a4  $13
	note gs4 $12
	rest $0a
	note gs4 $09
	note fs4 $09
	note gs4 $0a
	note a4  $09
	note b4  $09
	note c5  $0a
	note d5  $09
	note c5  $09
	note b4  $0a
	note c5  $1c
	rest $1c
	goto musicee79b
	cmdff

sound08Channel1:
	vibrato $e1
	env $0 $00
	cmdf2
musicee9ec:
	vol $6
	note d6  $24
	note a5  $24
	vibrato $01
	vol $4
	note a5  $12
	vibrato $e1
	vol $6
	note g5  $12
	note a5  $51
	vibrato $01
	vol $4
	note a5  $12
	rest $09
	vibrato $e1
	vol $6
	note d6  $24
	note a5  $24
	vibrato $01
	vol $4
	note a5  $12
	vibrato $e1
	vol $6
	note g5  $12
	note a5  $36
	vibrato $01
	vol $4
	note a5  $12
	vibrato $e1
	vol $6
	note d5  $24
	note ds5 $24
	note g5  $24
	note as5 $24
	note a5  $3f
	vibrato $01
	vol $4
	note a5  $24
	rest $09
	vibrato $e1
	vol $6
	note a5  $24
	note g5  $24
	note f5  $24
	note g5  $3f
	vibrato $01
	vol $4
	note g5  $1e
	rest $0f
	vibrato $e1
	goto musicee9ec
	cmdff

sound08Channel0:
musiceea48:
	vibrato $00
	env $0 $05
	vol $0
	note gs3 $12
	vol $6
	note g4  $06
	rest $0c
	note as4 $06
	rest $03
	vol $4
	note g4  $06
	rest $03
	vol $6
	note d5  $06
	rest $03
	vol $4
	note as4 $06
	rest $03
	vol $6
	note g5  $06
	rest $03
	vol $4
	note d5  $06
	rest $0c
	vol $4
	note g5  $06
	rest $15
	vol $6
	note d4  $06
	rest $0c
	note f4  $06
	rest $03
	vol $4
	note d4  $06
	rest $03
	vol $6
	note a4  $06
	rest $03
	vol $4
	note f4  $06
	rest $03
	vol $6
	note d5  $06
	rest $03
	vol $4
	note a4  $06
	rest $0c
	vol $4
	note d5  $06
	rest $15
	vol $6
	note g4  $06
	rest $0c
	note as4 $06
	rest $03
	vol $4
	note g4  $06
	rest $03
	vol $6
	note d5  $06
	rest $03
	vol $4
	note as4 $06
	rest $03
	vol $6
	note g5  $06
	rest $03
	vol $4
	note d5  $06
	rest $0c
	vol $4
	note g5  $06
	rest $15
	vol $6
	note d4  $06
	rest $0c
	note f4  $06
	rest $03
	vol $4
	note d4  $06
	rest $03
	vol $6
	note a4  $06
	rest $03
	vol $4
	note f4  $06
	rest $03
	vol $6
	note d5  $06
	rest $03
	vol $4
	note a4  $06
	rest $0c
	vol $4
	note d5  $06
	rest $03
	vol $6
	note c4  $06
	rest $0c
	note ds4 $06
	rest $03
	vol $4
	note c4  $06
	rest $03
	vol $6
	note g4  $06
	rest $03
	vol $4
	note ds4 $06
	rest $03
	vol $6
	note c5  $06
	rest $03
	vol $4
	note g4  $06
	rest $0c
	vol $4
	note c5  $06
	rest $15
	vol $6
	note d4  $06
	rest $0c
	note f4  $06
	rest $03
	vol $4
	note d4  $06
	rest $03
	vol $6
	note a4  $06
	rest $03
	vol $4
	note f4  $06
	rest $03
	vol $6
	note d5  $06
	rest $03
	vol $4
	note a4  $06
	rest $0c
	vol $4
	note d5  $06
	rest $15
	env $0 $00
	vol $6
	note d5  $24
	note c5  $24
	note c5  $24
	note d5  $3f
	vol $3
	note d5  $1e
	rest $0f
	goto musiceea48
	cmdff

sound08Channel4:
musiceeb4d:
	duty $0f
	rest $16
	note d6  $24
	note a5  $36
	note g5  $12
	note a5  $51
	rest $1b
	note d6  $24
	note a5  $36
	note g5  $12
	note a5  $48
	note d5  $24
	note ds5 $24
	note g5  $24
	note as5 $24
	note a5  $56
	rest $48
	duty $2c
	note a4  $24
	duty $0f
	note as4 $6c
	goto musiceeb4d
	cmdff

sound05Start:

sound05Channel1:
	vibrato $e1
	env $0 $00
	cmdf2
	duty $02
musiceeb82:
	vol $6
	note ds4 $1b
	vol $6
	note e4  $09
	note c4  $09
	rest $04
	vol $4
	note c4  $05
	vol $6
	note g3  $09
	rest $04
	vol $4
	note g3  $05
	vol $6
	note as3 $09
	rest $04
	vol $4
	note as3 $05
	vol $6
	note as3 $09
	rest $04
	vol $4
	note as3 $05
	vol $6
	note a3  $09
	rest $04
	vol $4
	note a3  $05
	vol $6
	note g3  $09
	rest $04
	vol $4
	note g3  $05
	vol $6
	note fs3 $12
	note g3  $09
	rest $04
	vol $4
	note g3  $09
	rest $05
	vol $2
	note g3  $09
	vol $6
	note fs3 $12
	note g3  $09
	rest $04
	vol $4
	note g3  $09
	rest $05
	vol $2
	note g3  $09
	rest $12
	vol $6
	note ds4 $2d
	note e4  $09
	note c4  $09
	rest $04
	vol $4
	note c4  $05
	vol $6
	note g3  $09
	rest $04
	vol $4
	note g3  $05
	vol $6
	note as3 $09
	rest $04
	vol $4
	note as3 $05
	vol $6
	note as3 $09
	rest $04
	vol $4
	note as3 $05
	vol $6
	note c4  $09
	rest $04
	vol $4
	note c4  $05
	vol $6
	note d4  $09
	rest $04
	vol $4
	note d4  $05
	vol $6
	note f4  $12
	note e4  $09
	rest $04
	vol $4
	note e4  $05
	vol $6
	note ds4 $09
	rest $04
	vol $4
	note ds4 $05
	vol $6
	note d4  $09
	rest $04
	vol $4
	note d4  $09
	rest $05
	vol $2
	note d4  $09
	rest $24
	vol $6
	note f4  $1b
	vol $4
	note f4  $09
	vol $6
	note f4  $09
	rest $04
	vol $4
	note f4  $05
	vol $6
	note e4  $09
	rest $04
	vol $4
	note e4  $05
	vol $6
	note d4  $09
	rest $04
	vol $4
	note d4  $05
	rest $36
	vol $6
	note ds4 $1b
	vol $4
	note ds4 $09
	vol $6
	note ds4 $09
	rest $04
	vol $4
	note ds4 $05
	vol $6
	note d4  $09
	rest $04
	vol $4
	note d4  $05
	vol $6
	note c4  $09
	rest $04
	vol $4
	note c4  $09
	rest $05
	vol $2
	note c4  $09
	rest $24
	vol $6
	note as4 $1b
	vol $4
	note as4 $09
	vol $6
	note as4 $12
	note a4  $09
	rest $04
	vol $4
	note a4  $09
	rest $05
	vol $2
	note a4  $09
	vol $6
	note gs4 $12
	note g4  $09
	rest $04
	vol $4
	note g4  $09
	rest $05
	vol $2
	note g4  $09
	vol $6
	note fs4 $09
	rest $04
	vol $4
	note fs4 $05
	vol $6
	note fs4 $04
	rest $0e
	note g4  $09
	rest $04
	vol $4
	note g4  $05
	vol $6
	note fs4 $12
	note g4  $09
	rest $04
	vol $4
	note g4  $05
	vol $6
	note ds4 $12
	note c4  $12
	note as3 $12
	note g3  $12
	vol $6
	note fs3 $12
	note g3  $09
	rest $04
	vol $4
	note g3  $09
	rest $05
	vol $2
	note g3  $09
	vol $6
	note fs3 $12
	note g3  $09
	rest $04
	vol $4
	note g3  $09
	rest $05
	vol $2
	note g3  $09
	rest $b4
	goto musiceeb82
	cmdff

sound05Channel0:
	vibrato $e1
	env $0 $00
	cmdf2
	duty $02
musiceece7:
	vol $6
	note g3  $24
	vol $6
	note a3  $24
	note fs3 $24
	note g3  $24
	note ds4 $12
	note e4  $09
	rest $04
	vol $4
	note e4  $05
	vol $6
	note g5  $03
	rest $01
	vol $4
	note g5  $03
	rest $02
	vol $2
	note g5  $03
	rest $06
	vol $6
	note ds4 $12
	note e4  $09
	rest $04
	vol $4
	note e4  $05
	vol $6
	note g5  $03
	rest $01
	vol $4
	note g5  $03
	rest $02
	vol $2
	note g5  $03
	rest $06
	vol $6
	note as3 $09
	note a3  $09
	note gs3 $09
	note g3  $09
	note e3  $24
	note g3  $24
	note ds3 $24
	note e3  $24
	note d3  $24
	note a3  $12
	note as3 $12
	vol $6
	note d6  $03
	rest $03
	vol $5
	note d6  $03
	rest $03
	vol $4
	note d6  $03
	rest $03
	vol $6
	note g5  $03
	rest $03
	vol $5
	note g5  $03
	rest $03
	vol $4
	note g5  $03
	rest $03
	vol $6
	note b4  $09
	note as4 $09
	note a4  $09
	note g4  $09
	rest $36
	note f5  $1b
	vol $4
	note f5  $09
	vol $6
	note f5  $09
	rest $04
	vol $4
	note f5  $05
	vol $6
	note e5  $09
	rest $04
	vol $4
	note e5  $05
	vol $6
	note d5  $09
	rest $04
	vol $4
	note d5  $09
	rest $05
	vol $2
	note d5  $09
	rest $33
	vol $6
	note ds5 $03
	note e5  $12
	note g5  $09
	rest $04
	vol $4
	note g5  $05
	vol $6
	note a5  $09
	note g5  $09
	note ds5 $09
	note c5  $09
	rest $12
	note g5  $12
	note fs5 $09
	rest $04
	vol $4
	note fs5 $09
	rest $05
	vol $2
	note fs5 $09
	vol $6
	note f5  $12
	note e5  $09
	rest $04
	vol $4
	note e5  $09
	rest $05
	vol $2
	note e5  $09
	vol $6
	note ds5 $09
	rest $04
	vol $4
	note ds5 $05
	vol $6
	note cs5 $12
	note d5  $09
	rest $04
	vol $4
	note d5  $05
	vol $6
	note cs5 $12
	note d5  $09
	rest $04
	vol $4
	note d5  $05
	vol $6
	note c4  $12
	note g3  $12
	note f3  $12
	note d3  $12
	note b2  $12
	note c3  $09
	rest $04
	vol $4
	note c3  $09
	rest $05
	vol $2
	note c3  $09
	vol $6
	note b2  $12
	vol $7
	note c3  $09
	rest $04
	vol $4
	note c3  $09
	rest $05
	vol $2
	note c3  $09
	rest $b4
	goto musiceece7
	cmdff

sound05Channel4:
musiceee03:
	duty $0e
	note c3  $09
	duty $0f
	note c3  $09
	rest $12
	duty $0e
	note ds3 $09
	duty $0f
	note ds3 $09
	duty $0e
	note e3  $09
	duty $0f
	note e3  $09
	duty $0e
	note g2  $09
	duty $0f
	note g2  $09
	rest $12
	duty $0e
	note as2 $09
	duty $0f
	note as2 $09
	duty $0e
	note as2 $09
	duty $0f
	note as2 $09
	duty $0e
	note c3  $09
	duty $0f
	note c3  $09
	rest $12
	duty $0e
	note ds3 $12
	note e3  $09
	duty $0f
	note e3  $09
	duty $0e
	note g2  $09
	duty $0f
	note g2  $09
	rest $12
	duty $0e
	note g2  $09
	duty $0f
	note g2  $09
	duty $0e
	note as2 $09
	duty $0f
	note as2 $09
	duty $0e
	note c3  $12
	duty $0f
	note c3  $12
	duty $0e
	note ds3 $09
	duty $0f
	note ds3 $09
	duty $0e
	note e3  $09
	duty $0f
	note e3  $09
	duty $0e
	note c3  $09
	duty $0f
	note c3  $09
	rest $12
	duty $0e
	note c3  $09
	duty $0f
	note c3  $09
	duty $0e
	note c3  $09
	duty $0f
	note c3  $09
	duty $0e
	note g2  $1b
	duty $0f
	note g2  $09
	duty $0e
	note cs3 $09
	duty $0f
	note cs3 $09
	duty $0e
	note d3  $09
	duty $0f
	note d3  $09
	duty $0e
	note b2  $09
	note as2 $09
	note a2  $09
	note gs2 $09
	note g2  $09
	duty $0f
	note g2  $09
	duty $0e
	note g2  $09
	duty $0f
	note g2  $09
	duty $0e
	note f2  $1b
	duty $0f
	note f2  $09
	duty $0e
	note a2  $09
	duty $0f
	note a2  $09
	duty $0e
	note c3  $09
	duty $0f
	note c3  $09
	duty $0e
	note f2  $1b
	duty $0f
	note f2  $09
	duty $0e
	note f2  $09
	duty $0f
	note f2  $09
	duty $0e
	note f2  $09
	duty $0f
	note f2  $09
	duty $0e
	note c3  $1b
	duty $0f
	note c3  $09
	duty $0e
	note ds3 $09
	duty $0f
	note ds3 $09
	duty $0e
	note e3  $09
	duty $0f
	note e3  $09
	duty $0e
	note c3  $1b
	duty $0f
	note c3  $09
	duty $0e
	note c3  $09
	duty $0f
	note c3  $09
	duty $0e
	note c3  $09
	duty $0f
	note c3  $09
	duty $0e
	note g2  $12
	duty $0f
	note g2  $12
	duty $0e
	note g2  $09
	duty $0f
	note g2  $09
	duty $0e
	note g2  $09
	duty $0f
	note g2  $09
	duty $0e
	note d3  $1b
	duty $0f
	note d3  $09
	duty $0e
	note g2  $09
	duty $0f
	note g2  $09
	duty $0e
	note g2  $09
	duty $0f
	note g2  $09
	rest $12
	duty $0e
	note g3  $09
	duty $0f
	note g3  $09
	duty $0e
	note fs3 $09
	duty $0f
	note fs3 $09
	duty $0e
	note f3  $09
	duty $0f
	note f3  $09
	duty $0e
	note e3  $09
	duty $0f
	note e3  $09
	duty $0e
	note ds3 $09
	duty $0f
	note ds3 $09
	duty $0e
	note d3  $09
	duty $0f
	note d3  $09
	duty $0e
	note cs3 $09
	duty $0f
	note cs3 $09
	duty $0e
	note c2  $09
	duty $0f
	note c2  $09
	rest $12
	duty $0e
	note ds3 $09
	duty $0f
	note ds3 $09
	duty $0e
	note e3  $09
	duty $0f
	note e3  $09
	duty $0e
	note g2  $09
	duty $0f
	note g2  $09
	rest $12
	duty $0e
	note as2 $09
	duty $0f
	note as2 $09
	duty $0e
	note as2 $09
	duty $0f
	note as2 $09
	duty $0e
	note c2  $09
	duty $0f
	note c2  $09
	rest $12
	duty $0e
	note ds3 $12
	note e3  $09
	duty $0f
	note e3  $09
	duty $0e
	note c3  $09
	duty $0f
	note c3  $09
	duty $0e
	note g2  $09
	duty $0f
	note g2  $09
	duty $0e
	note g2  $09
	duty $0f
	note g2  $09
	duty $0e
	note as2 $09
	duty $0f
	note as2 $09
	goto musiceee03
	cmdff

sound05Channel6:
musiceeffd:
	vol $6
	note $24 $24
	note $24 $12
	note $24 $12
	note $24 $24
	note $26 $24
	note $24 $24
	note $24 $12
	note $24 $12
	note $24 $24
	note $26 $24
	note $24 $24
	note $24 $12
	note $24 $12
	note $24 $24
	note $26 $24
	note $24 $24
	note $24 $12
	note $24 $12
	note $24 $24
	note $26 $24
	note $24 $24
	note $24 $12
	note $24 $12
	note $24 $24
	note $26 $24
	note $24 $24
	note $24 $12
	note $24 $12
	note $24 $24
	note $26 $12
	note $26 $09
	note $26 $09
	note $24 $24
	note $24 $12
	note $24 $12
	note $24 $24
	note $24 $24
	note $24 $24
	note $24 $12
	note $24 $12
	note $24 $12
	note $24 $12
	note $24 $12
	note $24 $12
	note $24 $24
	note $24 $12
	note $24 $12
	note $24 $24
	note $26 $24
	note $24 $24
	note $24 $12
	note $24 $12
	note $24 $12
	note $24 $12
	note $26 $12
	note $24 $12
	goto musiceeffd
	cmdff

sound0aChannel1:
	vibrato $e1
	env $0 $00
	cmdf2
	duty $02
musicef079:
	vol $6
	note g5  $24
	vol $6
	note c6  $24
	note a5  $24
	rest $12
	note b5  $09
	note c6  $09
	note b5  $12
	note a5  $09
	rest $03
	vol $3
	note a5  $03
	rest $03
	vol $6
	note g5  $09
	rest $03
	vol $3
	note g5  $03
	rest $03
	vol $6
	note f5  $09
	rest $03
	vol $3
	note f5  $03
	rest $03
	vol $6
	note e5  $12
	note f5  $09
	rest $03
	vol $3
	note f5  $03
	rest $03
	vol $6
	note g5  $09
	vol $3
	note g5  $09
	rest $12
	vol $6
	note a5  $12
	note e6  $09
	rest $09
	note e6  $09
	rest $03
	vol $5
	note e6  $03
	rest $06
	vol $3
	note e6  $03
	rest $06
	vol $2
	note e6  $03
	rest $27
	vol $6
	note d6  $09
	note c6  $09
	note b5  $09
	note a5  $09
	note g5  $12
	note a5  $09
	rest $03
	vol $3
	note a5  $03
	rest $03
	vol $6
	note g5  $09
	rest $09
	note a5  $09
	rest $03
	vol $3
	note a5  $03
	rest $03
	vol $6
	note g5  $12
	vol $3
	note g5  $09
	rest $09
	vol $6
	note f5  $12
	note g5  $12
	note a5  $24
	note f5  $24
	note b5  $24
	vibrato $01
	vol $3
	note b5  $09
	rest $09
	vibrato $e1
	vol $6
	note a5  $12
	note g5  $24
	note e5  $12
	note g5  $12
	note c6  $24
	rest $12
	note a5  $09
	note g5  $09
	note fs5 $12
	note g5  $12
	note a5  $12
	note b5  $12
	vol $6
	note c6  $12
	vol $6
	note b5  $12
	note c6  $12
	note a5  $12
	note d6  $09
	rest $03
	vol $5
	note d6  $03
	rest $03
	vol $3
	note d6  $03
	rest $03
	vol $2
	note d6  $03
	rest $09
	vol $6
	note g5  $09
	rest $03
	vol $3
	note g5  $03
	rest $03
	vol $6
	note b5  $09
	vol $6
	note a5  $09
	note g5  $24
	vibrato $01
	vol $3
	note g5  $0f
	rest $03
	vibrato $e1
	vol $6
	note g5  $09
	rest $09
	goto musicef079
	cmdff

sound0aChannel0:
	vibrato $00
	env $0 $00
	cmdf2
	duty $02
musicef173:
	vol $6
	note e4  $15
	vol $3
	note e4  $09
	rest $06
	vol $6
	note c4  $15
	vol $3
	note c4  $09
	rest $06
	vol $6
	note f4  $15
	vol $3
	note f4  $09
	rest $06
	vol $6
	note d4  $18
	vol $3
	note d4  $09
	rest $03
	vol $6
	note g4  $12
	note f4  $09
	rest $03
	vol $3
	note f4  $03
	rest $03
	vol $6
	note e4  $09
	rest $03
	vol $3
	note e4  $03
	rest $03
	vol $6
	note d4  $09
	rest $03
	vol $3
	note d4  $03
	rest $03
	vol $6
	note c4  $12
	note d4  $09
	rest $03
	vol $3
	note d4  $03
	rest $03
	vol $6
	note e4  $09
	rest $03
	vol $3
	note e4  $03
	rest $03
	vol $2
	note e4  $03
	rest $0f
	vol $6
	note f4  $15
	vol $3
	note f4  $09
	rest $06
	vol $6
	note d4  $15
	vol $3
	note d4  $09
	rest $06
	vol $6
	note fs4 $15
	vol $3
	note fs4 $09
	rest $06
	vol $6
	note d4  $15
	vol $3
	note d4  $09
	rest $06
	vol $6
	note b3  $12
	note c4  $09
	rest $03
	vol $3
	note c4  $03
	rest $03
	vol $6
	note b3  $09
	rest $03
	vol $3
	note b3  $03
	rest $03
	vol $6
	note d4  $09
	rest $03
	vol $3
	note d4  $03
	rest $03
	vol $6
	note g4  $09
	rest $03
	vol $3
	note g4  $03
	rest $03
	vol $6
	note d4  $09
	rest $03
	vol $3
	note d4  $03
	rest $03
	vol $6
	note b3  $09
	rest $03
	vol $3
	note b3  $03
	rest $15
	vol $6
	note f4  $15
	vol $3
	note f4  $09
	rest $06
	vol $6
	note d4  $15
	vol $3
	note d4  $09
	rest $06
	vol $6
	note g4  $15
	vol $3
	note g4  $09
	rest $06
	vol $6
	note f4  $15
	vol $3
	note f4  $09
	rest $06
	vol $6
	note e4  $15
	vol $3
	note e4  $09
	rest $06
	vol $6
	note d4  $15
	vol $3
	note d4  $09
	rest $06
	vol $6
	note c4  $15
	vol $3
	note c4  $09
	rest $06
	vol $6
	note b3  $15
	vol $3
	note b3  $09
	rest $06
	vol $6
	note a3  $12
	note d4  $09
	rest $09
	note d4  $09
	rest $03
	vol $4
	note d4  $03
	rest $03
	vol $3
	note d4  $03
	rest $0f
	vol $6
	note c4  $12
	note d4  $09
	rest $09
	note d4  $09
	rest $03
	vol $4
	note d4  $03
	rest $03
	vol $3
	note d4  $03
	rest $0f
	vol $6
	note b3  $12
	vol $3
	note b3  $12
	vol $6
	note g4  $12
	vol $3
	note g4  $12
	vol $6
	note g4  $12
	note f4  $12
	note e4  $12
	note d4  $12
	goto musicef173
	cmdff

sound0aChannel4:
	cmdf2
musicef2b0:
	rest $0d
	duty $2b
	note g5  $24
	duty $2b
	note c6  $24
	note a5  $24
	rest $12
	note b5  $09
	note c6  $09
	note b5  $12
	note a5  $09
	rest $03
	duty $2c
	note a5  $03
	rest $03
	duty $2b
	note g5  $09
	rest $03
	duty $2c
	note g5  $03
	rest $03
	duty $2b
	note f5  $09
	rest $03
	duty $2c
	note f5  $03
	rest $03
	duty $2b
	note e5  $12
	note f5  $09
	rest $03
	duty $2c
	note f5  $03
	rest $03
	duty $2b
	note g5  $09
	duty $2c
	note g5  $09
	rest $12
	duty $2b
	note a5  $12
	note e6  $09
	rest $09
	note e6  $09
	rest $03
	vol $3
	note e6  $03
	rest $06
	duty $2c
	note e6  $03
	rest $06
	duty $2c
	note e6  $03
	rest $27
	duty $2b
	note d6  $09
	note c6  $09
	note b5  $09
	note a5  $09
	note g5  $12
	note a5  $09
	rest $03
	duty $2c
	note a5  $03
	rest $03
	duty $2b
	note g5  $09
	rest $09
	note a5  $09
	rest $03
	duty $2c
	note a5  $03
	rest $03
	duty $2b
	note g5  $12
	duty $2c
	note g5  $09
	rest $09
	duty $2b
	note f5  $12
	note g5  $12
	note a5  $24
	note f5  $24
	note b5  $24
	duty $2c
	note b5  $09
	rest $09
	duty $2b
	note a5  $12
	note g5  $24
	note e5  $12
	note g5  $12
	note c6  $24
	rest $12
	note a5  $09
	note g5  $09
	note fs5 $12
	note g5  $12
	note a5  $12
	note b5  $12
	duty $2b
	note c6  $12
	duty $2b
	note b5  $12
	note c6  $12
	note a5  $12
	note d6  $09
	rest $03
	vol $3
	note d6  $03
	rest $03
	duty $2c
	note d6  $03
	rest $03
	duty $2c
	note d6  $03
	rest $09
	duty $2b
	note g5  $09
	rest $03
	duty $2c
	note g5  $03
	rest $03
	duty $2b
	note b5  $09
	duty $2b
	note a5  $09
	note g5  $24
	duty $2c
	note g5  $0f
	rest $03
	duty $2b
	note g5  $05
	goto musicef2b0
	cmdff

sound0bChannel1:
	cmdf2
	vibrato $e1
	env $0 $00
	duty $01
musicef3c3:
	vol $6
	note g5  $2c
	vol $6
	note c6  $2c
	note a5  $2c
	vibrato $01
	vol $3
	note a5  $16
	vibrato $e1
	vol $6
	note b5  $0b
	note c6  $0b
	note b5  $16
	note a5  $0b
	rest $05
	vol $3
	note a5  $06
	vol $6
	note g5  $0b
	rest $05
	vol $3
	note g5  $06
	vol $6
	note f5  $0b
	rest $05
	vol $3
	note f5  $06
	vol $6
	note e5  $16
	note f5  $0b
	rest $05
	vol $3
	note f5  $06
	vol $6
	note g5  $0b
	rest $05
	vol $3
	note g5  $0b
	rest $06
	vol $1
	note g5  $0b
	vol $6
	note a5  $16
	note e6  $0b
	rest $05
	vol $3
	note e6  $06
	vol $6
	note e6  $0b
	rest $05
	vol $3
	note e6  $0b
	rest $06
	vol $1
	note e6  $0b
	rest $2c
	vol $6
	note d6  $0b
	note c6  $0b
	note b5  $0b
	note a5  $0b
	note g5  $16
	note a5  $0b
	rest $05
	vol $3
	note a5  $06
	vol $6
	note g5  $0b
	rest $0b
	note a5  $0b
	rest $05
	vol $3
	note a5  $06
	vol $6
	note g5  $16
	vol $3
	note g5  $0b
	rest $0b
	vol $6
	note f5  $16
	note g5  $16
	note a5  $2c
	note f5  $16
	note e5  $16
	note d5  $2c
	vol $6
	note b5  $16
	vol $6
	note a5  $16
	note g5  $2c
	note e5  $16
	note g5  $16
	note c6  $2c
	vibrato $01
	vol $3
	note c6  $16
	vibrato $e1
	vol $6
	note a5  $0b
	note g5  $0b
	note f5  $16
	note g5  $16
	note a5  $16
	note b5  $16
	vol $6
	note c6  $16
	vol $6
	note b5  $16
	note c6  $16
	note a5  $16
	note d6  $0b
	rest $05
	vol $3
	note d6  $0b
	rest $06
	vol $1
	note d6  $0b
	vol $6
	note g5  $0b
	rest $05
	vol $3
	note g5  $06
	vol $6
	note b5  $0b
	vol $6
	note a5  $0b
	note g5  $2c
	vibrato $01
	vol $3
	note g5  $12
	rest $04
	vibrato $e1
	vol $6
	note g5  $0b
	rest $05
	vol $3
	note g5  $06
	goto musicef3c3
	cmdff

sound0bChannel0:
	cmdf2
	vibrato $00
	env $0 $00
	duty $01
musicef4b7:
	vol $6
	note e4  $1d
	vol $3
	note e4  $0b
	rest $04
	vol $6
	note c4  $1d
	vol $3
	note c4  $0b
	rest $04
	vol $6
	note f4  $1d
	vol $3
	note f4  $0b
	rest $04
	vol $6
	note d4  $1d
	vol $3
	note d4  $0b
	rest $04
	vol $6
	note g4  $16
	note f4  $0b
	rest $05
	vol $3
	note f4  $06
	vol $6
	note e4  $0b
	rest $05
	vol $3
	note e4  $06
	vol $6
	note d4  $0b
	rest $05
	vol $3
	note d4  $06
	vol $6
	note c4  $16
	note d4  $0b
	rest $05
	vol $3
	note d4  $06
	vol $6
	note e4  $0b
	rest $05
	vol $3
	note e4  $0b
	rest $06
	vol $1
	note e4  $0b
	vol $6
	note f4  $19
	vol $3
	note f4  $0b
	rest $34
	vol $6
	note fs4 $19
	vol $3
	note fs4 $0b
	rest $08
	vol $6
	note d4  $19
	vol $3
	note d4  $0b
	rest $08
	vol $6
	note b3  $16
	note c4  $0b
	rest $05
	vol $3
	note c4  $06
	vol $6
	note b3  $0b
	rest $05
	vol $3
	note b3  $06
	vol $6
	note d4  $0b
	rest $05
	vol $3
	note d4  $06
	vol $6
	note g4  $0b
	rest $05
	vol $3
	note g4  $06
	vol $6
	note d4  $0b
	rest $05
	vol $3
	note d4  $06
	vol $6
	note b3  $0b
	rest $05
	vol $3
	note b3  $0b
	rest $06
	vol $1
	note b3  $0b
	vol $6
	note f4  $2c
	vol $3
	note f4  $2c
	vol $6
	note g4  $19
	vol $3
	note g4  $0b
	rest $08
	vol $6
	note f4  $19
	vol $3
	note f4  $0b
	rest $08
	vol $6
	note e4  $19
	vol $3
	note e4  $0b
	rest $08
	vol $6
	note d4  $19
	vol $3
	note d4  $0b
	rest $08
	vol $6
	note c4  $2c
	note b3  $2c
	note a3  $16
	note f4  $0b
	rest $05
	vol $3
	note f4  $06
	vol $6
	note c4  $0b
	rest $05
	vol $3
	note c4  $0b
	rest $06
	vol $1
	note c4  $0b
	vol $6
	note e4  $16
	note f4  $0b
	rest $05
	vol $3
	note f4  $06
	vol $6
	note f4  $0b
	rest $05
	vol $3
	note f4  $0b
	rest $06
	vol $1
	note f4  $0b
	vol $6
	note b3  $16
	vol $3
	note b3  $16
	vol $6
	note g4  $16
	vol $3
	note g4  $16
	vol $6
	note g4  $16
	note f4  $16
	note e4  $16
	note d4  $16
	goto musicef4b7
	cmdff

sound0bChannel4:
	cmdf2
musicef5c9:
	duty $0e
	note c4  $21
	duty $0f
	note c4  $21
	rest $16
	duty $0e
	note d4  $21
	duty $0f
	note d4  $21
	rest $16
	duty $0e
	note g3  $2c
	duty $0f
	note g3  $2c
	duty $0e
	note c3  $16
	note d3  $16
	note e3  $0b
	duty $0f
	note e3  $0b
	rest $16
	duty $0e
	note f3  $2c
	note e3  $2c
	note d3  $2c
	note a3  $2c
	note g3  $42
	note b3  $16
	note d4  $21
	rest $37
	note d4  $42
	note c4  $16
	note b3  $2c
	note g3  $2c
	note c4  $2c
	duty $0f
	note c4  $16
	duty $0e
	note b3  $16
	note e4  $2c
	note d4  $2c
	note c4  $2c
	note f4  $16
	duty $0f
	note f4  $16
	duty $0e
	note f3  $2c
	note a3  $16
	duty $0f
	note a3  $16
	duty $0e
	note g3  $16
	note a3  $16
	note b3  $16
	note a3  $16
	note g3  $2c
	rest $2c
	goto musicef5c9
	cmdff

sound12Channel1:
	vibrato $00
	env $0 $00
	cmdf2
	duty $02
musicef646:
	vol $6
	note g5  $0a
	note e5  $0b
	note c5  $0b
	note g4  $08
	rest $04
	vol $3
	note g4  $08
	rest $04
	vol $2
	note g4  $08
	vol $6
	note as4 $15
	note a4  $0b
	note g4  $08
	rest $04
	vol $3
	note g4  $08
	rest $04
	vol $2
	note g4  $08
	vol $6
	note g5  $0a
	note e5  $0b
	note c5  $0b
	note g4  $08
	rest $04
	vol $3
	note g4  $08
	rest $01
	vol $6
	note g4  $0b
	note as4 $15
	note a4  $0b
	note g4  $08
	rest $04
	vol $3
	note g4  $08
	rest $04
	vol $2
	note g4  $08
	vol $6
	note g5  $0a
	note e5  $0b
	note c5  $0b
	note g4  $08
	rest $04
	vol $3
	note g4  $08
	rest $04
	vol $2
	note g4  $08
	vol $6
	note as4 $15
	note a4  $0b
	note g4  $05
	rest $07
	vol $3
	note g4  $04
	vol $6
	note e4  $05
	rest $07
	vol $3
	note e4  $04
	vol $6
	note f4  $05
	rest $07
	vol $3
	note f4  $04
	vol $6
	note fs4 $05
	rest $07
	vol $3
	note fs4 $04
	vol $6
	note g4  $05
	rest $07
	vol $3
	note g4  $04
	vol $6
	note a4  $05
	rest $07
	vol $3
	note a4  $04
	vol $6
	note as4 $08
	rest $04
	vol $3
	note as4 $08
	rest $04
	vol $2
	note as4 $08
	rest $20
	vol $6
	note g5  $0a
	note e5  $0b
	note c5  $0b
	note g4  $08
	rest $04
	vol $3
	note g4  $08
	rest $04
	vol $2
	note g4  $08
	vol $6
	note as4 $15
	note a4  $0b
	note g4  $08
	rest $04
	vol $3
	note g4  $08
	rest $04
	vol $2
	note g4  $08
	vol $6
	note g5  $0a
	note e5  $0b
	note c5  $0b
	note g4  $08
	rest $04
	vol $3
	note g4  $08
	rest $04
	vol $2
	note g4  $08
	vol $6
	note as4 $08
	note c5  $08
	note as4 $08
	note a4  $08
	note g4  $08
	rest $04
	vol $3
	note g4  $08
	rest $04
	vol $2
	note g4  $08
	vol $6
	note g5  $0a
	note e5  $0b
	note c5  $0b
	note g4  $08
	rest $04
	vol $3
	note g4  $08
	rest $04
	vol $2
	note g4  $08
	vol $6
	note as4 $15
	note a4  $0b
	note g4  $08
	rest $04
	vol $3
	note g4  $04
	vol $6
	note a4  $08
	rest $04
	vol $3
	note a4  $04
	vol $6
	note b4  $08
	rest $04
	vol $3
	note b4  $04
	vol $6
	note c5  $08
	rest $04
	vol $3
	note c5  $04
	vol $6
	note d5  $08
	rest $04
	vol $3
	note d5  $04
	vol $6
	note e5  $08
	rest $04
	vol $3
	note e5  $04
	vol $6
	note f5  $08
	rest $04
	vol $3
	note f5  $08
	rest $04
	vol $2
	note f5  $08
	vol $6
	note fs5 $08
	rest $04
	vol $3
	note fs5 $08
	rest $04
	vol $2
	note fs5 $08
	goto musicef646
	cmdff

sound12Channel0:
	vibrato $00
	env $0 $00
	cmdf2
	duty $02
musicef79b:
	vol $0
	note gs3 $40
	vol $6
	note g4  $15
	note f4  $0b
	note e4  $08
	rest $04
	vol $3
	note e4  $08
	rest $04
	vol $2
	note e4  $08
	rest $40
	vol $6
	note g4  $15
	note f4  $0b
	note e4  $08
	rest $04
	vol $3
	note e4  $08
	rest $04
	vol $2
	note e4  $08
	rest $40
	vol $6
	note g4  $15
	note f4  $0b
	note e4  $05
	rest $07
	vol $3
	note e4  $04
	vol $6
	note c4  $05
	rest $07
	vol $3
	note c4  $04
	vol $6
	note d4  $05
	rest $07
	vol $3
	note d4  $04
	vol $6
	note ds4 $05
	rest $07
	vol $3
	note ds4 $04
	vol $6
	note e4  $05
	rest $07
	vol $3
	note e4  $04
	vol $6
	note f4  $05
	rest $07
	vol $3
	note f4  $04
	vol $6
	note fs4 $08
	rest $04
	vol $3
	note fs4 $08
	rest $04
	vol $2
	note fs4 $08
	rest $60
	vol $6
	note g4  $15
	note f4  $0b
	note e4  $08
	rest $04
	vol $3
	note e4  $08
	rest $04
	vol $2
	note e4  $08
	rest $20
	vol $6
	note e4  $08
	rest $04
	vol $3
	note e4  $08
	rest $04
	vol $2
	note e4  $08
	vol $6
	note g4  $08
	note gs4 $08
	note g4  $08
	note f4  $08
	note e4  $08
	rest $04
	vol $3
	note e4  $08
	rest $04
	vol $2
	note e4  $08
	rest $20
	vol $6
	note e4  $08
	rest $04
	vol $3
	note e4  $08
	rest $04
	vol $2
	note e4  $08
	vol $6
	note g4  $15
	note f4  $0b
	note e4  $08
	rest $04
	vol $3
	note e4  $04
	vol $6
	note f4  $08
	rest $04
	vol $3
	note f4  $04
	vol $6
	note g4  $08
	rest $04
	vol $3
	note g4  $04
	vol $6
	note a4  $08
	rest $04
	vol $3
	note a4  $04
	vol $6
	note b4  $08
	rest $04
	vol $3
	note b4  $04
	vol $6
	note c5  $08
	rest $04
	vol $3
	note c5  $04
	vol $6
	note cs5 $08
	rest $04
	vol $3
	note cs5 $08
	rest $04
	vol $2
	note cs5 $08
	vol $6
	note d5  $08
	rest $04
	vol $3
	note d5  $08
	rest $04
	vol $2
	note d5  $08
	goto musicef79b
	cmdff

sound12Channel4:
	cmdf2
musicef89e:
	rest $20
	duty $0e
	note c3  $08
	duty $0f
	note c3  $08
	rest $10
	duty $0e
	note g3  $08
	duty $0f
	note g3  $08
	rest $10
	duty $0e
	note g2  $08
	duty $0f
	note g2  $08
	rest $10
	duty $0e
	note as2 $08
	duty $0f
	note as2 $08
	rest $10
	duty $0e
	note c3  $08
	duty $0f
	note c3  $08
	rest $10
	duty $0e
	note g3  $08
	duty $0f
	note g3  $08
	rest $10
	duty $0e
	note g2  $08
	duty $0f
	note g2  $08
	rest $10
	duty $0e
	note as2 $08
	duty $0f
	note as2 $08
	rest $10
	duty $0e
	note c3  $08
	duty $0f
	note c3  $08
	rest $10
	duty $0e
	note g3  $08
	duty $0f
	note g3  $08
	rest $10
	duty $0e
	note g2  $08
	duty $0f
	note g2  $08
	duty $0e
	note a2  $08
	duty $0f
	note a2  $08
	duty $0e
	note as2 $08
	duty $0f
	note as2 $08
	duty $0e
	note b2  $08
	duty $0f
	note b2  $08
	duty $0e
	note c3  $08
	duty $0f
	note c3  $08
	duty $0e
	note d3  $08
	duty $0f
	note d3  $08
	duty $0e
	note ds3 $08
	duty $0f
	note ds3 $08
	rest $50
	duty $0e
	note c3  $08
	duty $0f
	note c3  $08
	rest $10
	duty $0e
	note g3  $08
	duty $0f
	note g3  $08
	rest $10
	duty $0e
	note g2  $08
	duty $0f
	note g2  $08
	rest $10
	duty $0e
	note g2  $0a
	note as2 $0b
	note b2  $0b
	note c3  $08
	duty $0f
	note c3  $08
	rest $10
	duty $0e
	note g3  $08
	duty $0f
	note g3  $08
	rest $10
	duty $0e
	note g2  $08
	duty $0f
	note g2  $08
	rest $10
	duty $0e
	note g2  $0a
	note as2 $0b
	note b2  $0b
	note c3  $08
	duty $0f
	note c3  $08
	rest $10
	duty $0e
	note g3  $08
	duty $0f
	note g3  $08
	rest $10
	duty $0e
	note g2  $08
	duty $0f
	note g2  $08
	rest $10
	duty $0e
	note a2  $08
	duty $0f
	note a2  $08
	rest $10
	duty $0e
	note b2  $08
	duty $0f
	note b2  $08
	duty $0e
	note cs3 $08
	duty $0f
	note cs3 $08
	duty $0e
	note d3  $08
	duty $0f
	note d3  $08
	rest $10
	duty $0e
	note ds3 $08
	duty $0f
	note ds3 $08
	rest $10
	goto musicef89e
	cmdff

sound24Channel1:
	vibrato $00
	env $0 $00
	cmdf2
musicef9db:
	vol $0
	note gs3 $ff
	note gs3 $21
	duty $01
	vol $6
	note e5  $12
	note fs5 $09
	note gs5 $09
	note a5  $12
	note gs5 $09
	note fs5 $09
	note e5  $24
	vol $6
	note fs5 $09
	rest $04
	vol $3
	note fs5 $05
	vol $6
	note cs5 $09
	rest $04
	vol $3
	note cs5 $05
	vol $6
	note fs4 $12
	vol $6
	note b3  $09
	note d4  $09
	note e4  $1b
	vol $3
	note e4  $09
	vol $6
	note fs4 $06
	rest $03
	note fs4 $09
	rest $04
	vol $3
	note fs4 $05
	vol $6
	note fs4 $09
	note b3  $09
	rest $04
	vol $3
	note b3  $05
	vol $6
	note d4  $09
	rest $04
	vol $3
	note d4  $05
	vol $6
	note b4  $24
	note cs5 $09
	rest $04
	vol $3
	note cs5 $05
	vol $5
	note e5  $09
	rest $04
	vol $3
	note e5  $05
	vol $6
	note cs5 $1b
	vol $5
	note e5  $09
	vol $7
	note fs5 $09
	rest $04
	vol $3
	note fs5 $09
	rest $05
	vol $2
	note fs5 $09
	rest $12
	duty $02
	vol $6
	note c5  $03
	rest $03
	vol $5
	note c5  $03
	rest $03
	vol $3
	note c5  $03
	rest $03
	vol $6
	note b5  $03
	rest $03
	vol $5
	note c6  $03
	rest $03
	vol $4
	note c6  $03
	rest $03
	vol $4
	note c6  $03
	rest $21
	vol $6
	note c5  $03
	rest $03
	vol $5
	note c5  $03
	rest $03
	vol $3
	note c5  $03
	rest $03
	vol $6
	note b5  $03
	rest $03
	vol $5
	note c6  $03
	rest $03
	vol $4
	note c6  $03
	rest $03
	vol $3
	note c6  $03
	rest $21
	vol $6
	note f5  $03
	rest $03
	vol $5
	note f5  $03
	rest $03
	vol $3
	note f5  $03
	rest $03
	vol $6
	note e6  $03
	rest $03
	vol $5
	note f6  $03
	rest $03
	vol $4
	note f6  $03
	rest $03
	vol $4
	note f6  $03
	rest $21
	vol $6
	note f5  $03
	rest $03
	vol $5
	note f5  $03
	rest $03
	vol $3
	note f5  $03
	rest $03
	vol $6
	note e6  $03
	rest $03
	vol $5
	note f6  $03
	rest $03
	vol $4
	note f6  $03
	rest $03
	vol $3
	note f6  $03
	rest $b1
	vol $6
	note g5  $03
	rest $03
	vol $5
	note g5  $03
	rest $03
	vol $3
	note g5  $03
	rest $03
	vol $6
	note fs6 $03
	rest $03
	vol $5
	note g6  $03
	rest $03
	vol $4
	note g6  $03
	rest $03
	vol $4
	note g6  $03
	rest $21
	vol $6
	note c6  $03
	rest $03
	vol $5
	note c6  $03
	rest $03
	vol $3
	note c6  $03
	rest $03
	vol $6
	note b6  $03
	rest $03
	vol $5
	note c7  $03
	rest $03
	vol $4
	note c7  $03
	rest $03
	vol $3
	note c7  $03
	rest $0f
	duty $01
	goto musicef9db
	cmdff

sound24Channel0:
	vibrato $00
	env $0 $00
	cmdf2
	duty $02
musicefb34:
	vol $0
	note gs3 $12
	vol $6
	note c5  $03
	rest $03
	vol $5
	note c5  $03
	rest $03
	vol $3
	note c5  $03
	rest $03
	vol $6
	note b5  $03
	rest $03
	vol $5
	note c6  $03
	rest $03
	vol $4
	note c6  $03
	rest $03
	vol $4
	note c6  $03
	rest $21
	vol $6
	note c5  $03
	rest $03
	vol $5
	note c5  $03
	rest $03
	vol $3
	note c5  $03
	rest $03
	vol $6
	note b5  $03
	rest $03
	vol $5
	note c6  $03
	rest $03
	vol $4
	note c6  $03
	rest $03
	vol $3
	note c6  $03
	rest $0f
	duty $01
	vol $4
	note c3  $12
	note ds3 $09
	note e3  $09
	note f3  $12
	note a3  $12
	note b3  $09
	rest $04
	vol $2
	note b3  $05
	vol $4
	note g3  $09
	note d3  $09
	note g3  $11
	rest $01
	duty $02
	note c5  $03
	rest $03
	vol $3
	note c5  $03
	rest $03
	vol $2
	note c5  $03
	rest $15
	vol $6
	note b4  $03
	rest $03
	vol $5
	note b4  $03
	rest $03
	vol $3
	note b4  $03
	rest $03
	vol $6
	note a5  $03
	rest $03
	vol $5
	note b5  $03
	rest $03
	vol $4
	note b5  $03
	rest $03
	vol $4
	note b5  $03
	rest $21
	vol $6
	note b4  $03
	rest $03
	vol $5
	note b4  $03
	rest $03
	vol $3
	note b4  $03
	rest $03
	vol $6
	note a5  $03
	rest $03
	vol $5
	note b5  $03
	rest $03
	vol $4
	note b5  $03
	rest $03
	vol $3
	note b5  $03
	rest $0f
	duty $01
	vol $4
	note b2  $12
	note d3  $12
	note e3  $12
	note g3  $12
	note a3  $12
	note fs3 $09
	note cs3 $09
	note fs3 $12
	duty $02
	note b4  $03
	rest $03
	vol $3
	note b4  $03
	rest $03
	vol $2
	note b4  $03
	rest $15
	vol $6
	note cs5 $03
	rest $03
	vol $5
	note cs5 $03
	rest $03
	vol $3
	note cs5 $03
	rest $03
	vol $6
	note c6  $03
	rest $03
	vol $5
	note cs6 $03
	rest $03
	vol $4
	note cs6 $03
	rest $03
	vol $4
	note cs6 $03
	rest $21
	vol $6
	note cs5 $03
	rest $03
	vol $5
	note cs5 $03
	rest $03
	vol $3
	note cs5 $03
	rest $03
	vol $6
	note c6  $03
	rest $03
	vol $5
	note cs6 $03
	rest $03
	vol $4
	note cs6 $03
	rest $03
	vol $3
	note cs6 $03
	rest $0f
	duty $01
	vol $4
	note c3  $12
	note ds3 $12
	note f3  $12
	note g3  $12
	note a3  $12
	note e3  $09
	note f3  $09
	note e3  $12
	duty $02
	note c5  $03
	rest $03
	vol $3
	note c5  $03
	rest $03
	vol $2
	note c5  $03
	rest $03
	duty $01
	vol $7
	note f3  $09
	note g3  $09
	note a3  $09
	note as3 $09
	note c4  $09
	rest $04
	vol $4
	note c4  $09
	rest $05
	vol $2
	note c4  $09
	vol $4
	note f5  $09
	note g5  $09
	note a5  $09
	note as5 $09
	note c6  $09
	rest $04
	vol $2
	note c6  $09
	rest $05
	vol $1
	note c6  $09
	rest $12
	duty $02
	vol $6
	note c5  $03
	rest $03
	vol $5
	note c5  $03
	rest $03
	vol $3
	note c5  $03
	rest $03
	vol $6
	note b5  $03
	rest $03
	vol $5
	note c6  $03
	rest $03
	vol $4
	note c6  $03
	rest $03
	vol $4
	note c6  $03
	rest $21
	vol $6
	note c5  $03
	rest $03
	vol $5
	note c5  $03
	rest $03
	vol $3
	note c5  $03
	rest $03
	vol $6
	note b5  $03
	rest $03
	vol $5
	note c6  $03
	rest $03
	vol $4
	note c6  $03
	rest $03
	vol $3
	note c6  $03
	rest $0f
	duty $01
	vol $4
	note c3  $12
	note ds3 $12
	note f3  $12
	note gs3 $12
	note as3 $12
	note g4  $09
	note f4  $09
	note g4  $12
	duty $02
	note c5  $03
	rest $03
	vol $3
	note c5  $03
	rest $03
	vol $2
	note c5  $03
	rest $03
	goto musicefb34
	cmdff

sound24Channel4:
	cmdf2
musicefd1a:
	duty $0e
	note f3  $09
	duty $0f
	note f3  $09
	rest $12
	duty $0e
	note as3 $12
	note c4  $09
	duty $0f
	note c4  $09
	duty $0e
	note c3  $09
	duty $0f
	note c3  $09
	duty $0e
	note ds4 $09
	note d4  $09
	note c4  $09
	duty $0f
	note c4  $09
	rest $12
	duty $0e
	note f3  $12
	note as3 $12
	note c4  $12
	note ds4 $12
	note d4  $12
	note as3 $09
	note g3  $09
	note c4  $12
	duty $0f
	note c4  $12
	duty $0e
	note e3  $09
	duty $0f
	note e3  $09
	rest $12
	duty $0e
	note a3  $12
	note b3  $09
	duty $0f
	note b3  $09
	duty $0e
	note b2  $09
	duty $0f
	note b2  $09
	duty $0e
	note d4  $09
	note cs4 $09
	note b3  $09
	duty $0f
	note b3  $09
	rest $12
	duty $0e
	note e3  $12
	note a3  $12
	note b3  $12
	note d4  $12
	note cs4 $12
	note a3  $09
	note fs3 $09
	note b3  $12
	duty $0f
	note b3  $12
	duty $0e
	note fs2 $12
	duty $0f
	note fs2 $12
	duty $0e
	note b2  $09
	duty $0f
	note b2  $09
	duty $0e
	note cs3 $09
	duty $0f
	note cs3 $09
	duty $0e
	note cs2 $09
	duty $0f
	note cs2 $09
	rest $12
	duty $0e
	note cs3 $09
	duty $0f
	note cs3 $09
	rest $12
	duty $0e
	note a5  $1b
	note g5  $09
	note c5  $09
	duty $0f
	note c5  $09
	duty $0e
	note ds5 $09
	duty $0f
	note ds5 $09
	duty $0e
	note f5  $12
	note g5  $09
	note a5  $09
	note g5  $09
	duty $0f
	note g5  $09
	duty $0e
	note a4  $09
	note g4  $09
	note a3  $1b
	note g3  $09
	note f3  $09
	duty $0f
	note f3  $09
	duty $0e
	note c3  $09
	duty $0f
	note c3  $09
	duty $0e
	note ds3 $09
	duty $0f
	note ds3 $09
	duty $0e
	note ds3 $09
	duty $0f
	note ds3 $09
	duty $0e
	note f3  $09
	note c3  $09
	note c4  $09
	note a3  $09
	note f3  $09
	duty $0f
	note f3  $09
	rest $12
	duty $0e
	note as3 $12
	note c4  $09
	duty $0f
	note c4  $09
	duty $0e
	note c3  $09
	duty $0f
	note c3  $09
	duty $0e
	note ds4 $09
	note d4  $09
	note c4  $09
	duty $0f
	note c4  $09
	rest $12
	duty $0e
	note f3  $12
	note as3 $12
	note c4  $12
	note ds4 $12
	note d4  $12
	note as3 $09
	note g3  $09
	note c4  $12
	duty $0f
	note c4  $12
	goto musicefd1a
	cmdff

sound87Start:

sound87Channel2:
	duty $02
	env $1 $00
	vol $3
	cmdf8 $30
	note fs4 $06
	cmdff

sound89Start:

sound89Channel2:
	duty $02
	env $1 $00
	vol $d
	note fs5 $05
	vol $0
	rest $01
	vol $d
	note b5  $05
	vol $0
	rest $01
	vol $d
	note e6  $05
	cmdff

sound8bStart:

sound8bChannel2:
	duty $02
	vol $a
	env $0 $02
	note fs6 $06
	note gs6 $06
	note as6 $06
	note b6  $06
	env $0 $04
	note cs7 $1e
	cmdff

soundcbStart:

soundcbChannel2:
	duty $02
	vol $c
	cmdf8 $28
	note ds5 $02
	cmdf8 $00
	note ds5 $01
	duty $02
	vol $6
	vibrato $01
	env $0 $02
	note ds5 $0c
	cmdff

soundcbChannel7:
	cmdf0 $b1
	note $25 $01
	cmdf0 $41
	note $14 $0a
	cmdff

sound8cStart:

sound8cChannel2:
	duty $02
	vol $5
	note d6  $01
	note d7  $04
	cmdff

sound8fStart:

sound8fChannel2:
	duty $02
	vol $b
	env $0 $02
	cmdf8 $0f
	note c4  $13
	cmdff

sound90Start:

sound90Channel2:
	duty $02
	vol $b
	note c5  $02
	vol $a
	note d5  $02
	vol $9
	note e5  $02
	vol $8
	note fs5 $02
	note g5  $02
	vol $7
	note as5 $02
	vol $7
	note c5  $02
	vol $6
	note fs5 $02
	note gs5 $02
	note as5 $02
	vol $5
	note c5  $02
	note fs5 $02
	note gs5 $02
	vol $4
	note as5 $02
	note c5  $02
	vol $3
	note fs5 $02
	note gs5 $02
	vol $2
	note as5 $02
	note c5  $02
	vol $1
	note fs5 $02
	note gs5 $02
	note as5 $02
	cmdff

soundcaStart:

soundcaChannel2:
	cmdff

soundcaChannel7:
	cmdff

sound56Start:

sound56Channel2:
	duty $02
	vol $8
	note b5  $04
	vol $6
	note e6  $01
	vol $b
	note a6  $04
	vol $5
	note b5  $04
	vol $4
	note e6  $01
	vol $6
	note a6  $04
	vol $3
	note b5  $04
	vol $2
	note e6  $01
	vol $4
	note a6  $04
	vol $1
	note b5  $04
	vol $1
	note e6  $01
	vol $2
	note a6  $04
	vol $1
	note b5  $04
	note e6  $01
	vol $1
	note a6  $04
	cmdff

sound4dStart:

sound4dChannel2:
	duty $02
	vol $f
	env $0 $01
	note fs6 $08
	note f6  $08
	note d6  $08
	note b5  $08
	note g5  $08
	note ds6 $08
	note g6  $08
	env $0 $01
	note b6  $0f
	cmdff

sound4cStart:

sound4cChannel2:
	duty $01
	vol $b
	note c5  $0a
	note cs5 $0a
	note d5  $0a
	note ds5 $32
	cmdff

sound4cChannel3:
	duty $01
	vol $9
	note a5  $0a
	note as5 $0a
	note b5  $0a
	note c6  $32
	cmdff

sound4cChannel5:
	duty $01
	note f4  $0a
	note fs4 $0a
	note g4  $0a
	note gs4 $32
	cmdff

sound4cChannel7:
	cmdf0 $00
	note $00 $50
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
.bank $3c slot 1
.org 0

sound1cStart:

sound1fStart:

sound07Start:

sound26Start:

sound19Start:

sound1cChannel6:
sound1fChannel6:
sound07Channel6:
sound26Channel6:
sound19Channel6:
	cmdff

sound15Start:

sound15Channel1:
	cmdf2
	vibrato $e1
	env $0 $00
	duty $01
musicf0008:
	vol $6
	note f3  $23
	rest $01
	vibrato $01
	vol $3
	note f3  $09
	rest $09
	vibrato $e1
	vol $6
	note c3  $09
	vol $3
	note c3  $09
	vol $6
	note ds3 $09
	vol $3
	note ds3 $09
	vol $6
	note c3  $09
	vol $3
	note c3  $09
	rest $12
	vol $6
	note c3  $09
	vol $3
	note c3  $09
	vol $6
	note ds3 $09
	vol $3
	note ds3 $09
	vol $6
	note fs3 $09
	vol $3
	note fs3 $09
	vol $6
	note f3  $51
	vibrato $01
	vol $3
	note f3  $09
	rest $09
	vibrato $e1
	vol $6
	note ds3 $09
	note f3  $09
	note ds3 $09
	note c3  $09
	vol $3
	note c3  $09
	rest $63
	vol $6
	note fs4 $09
	note f4  $09
	note ds4 $09
	note f4  $09
	note ds4 $09
	note c4  $09
	vol $3
	note c4  $09
	rest $6c
	vol $6
	note c5  $09
	vol $3
	note c5  $09
	vol $6
	note b4  $09
	vol $3
	note b4  $09
	rest $09
	vol $6
	note b4  $09
	vol $6
	note c5  $09
	vol $3
	note c5  $09
	vol $6
	note b4  $09
	vol $3
	note b4  $09
	rest $12
	vol $6
	note b4  $09
	vol $3
	note b4  $09
	vol $6
	note c5  $09
	vol $3
	note c5  $09
	vol $6
	note ds5 $09
	vol $3
	note ds5 $09
	vol $6
	note d5  $1b
	note ds5 $09
	note d5  $09
	note ds5 $09
	note d5  $09
	note ds5 $09
	note d5  $09
	note ds5 $09
	note d5  $09
	note ds5 $09
	note f5  $09
	vol $3
	note f5  $09
	vol $6
	note c6  $09
	vol $3
	note c6  $09
	vol $6
	note b5  $09
	vol $3
	note b5  $09
	rest $12
	vol $6
	note b5  $09
	vol $3
	note b5  $09
	vol $6
	note as5 $09
	vol $3
	note as5 $09
	rest $12
	vol $6
	note gs5 $09
	vol $3
	note gs5 $09
	vol $6
	note as5 $09
	vol $3
	note as5 $09
	rest $12
	vol $6
	note as5 $09
	vol $3
	note as5 $09
	vol $6
	note gs5 $09
	vol $3
	note gs5 $09
	rest $12
	vol $6
	note gs5 $09
	vol $3
	note gs5 $09
	vol $6
	note g5  $09
	vol $3
	note g5  $09
	vol $6
	note gs5 $09
	vol $3
	note gs5 $09
	vol $6
	note g5  $09
	vol $3
	note g5  $09
	rest $12
	vol $6
	note c5  $09
	vol $3
	note c5  $09
	rest $12
	vol $6
	note ds5 $09
	vol $3
	note ds5 $09
	vol $6
	note d5  $09
	vol $3
	note d5  $09
	vol $6
	note cs5 $09
	vol $3
	note cs5 $09
	vol $6
	note c5  $51
	vibrato $01
	vol $3
	note c5  $09
	vibrato $e1
	vol $7
	note b3  $12
	note c4  $09
	vol $3
	note c4  $09
	vol $7
	note b3  $12
	note c4  $09
	vol $3
	note c4  $09
	goto musicf0008
	cmdff

sound15Channel0:
	cmdf2
	vibrato $e1
	env $0 $00
	duty $01
musicf0144:
	vol $6
	note c3  $24
	vibrato $01
	vol $2
	note c3  $09
	rest $09
	vibrato $e1
	vol $6
	note g2  $09
	vol $2
	note g2  $09
	vol $6
	note as2 $09
	vol $2
	note as2 $09
	vol $6
	note g2  $09
	vol $2
	note g2  $09
	rest $12
	vol $6
	note g2  $09
	vol $2
	note g2  $09
	vol $6
	note as2 $09
	vol $2
	note as2 $09
	vol $6
	note cs3 $09
	vol $2
	note cs3 $09
	vol $6
	note c3  $48
	vibrato $01
	vol $2
	note c3  $09
	rest $12
	vibrato $e1
	vol $6
	note as2 $09
	note c3  $09
	note as2 $09
	note g2  $09
	vol $2
	note g2  $09
	rest $63
	vol $7
	note cs4 $09
	note c4  $09
	note as3 $09
	note c4  $09
	note as3 $09
	note g3  $09
	rest $75
	note gs4 $09
	vol $3
	note gs4 $09
	vol $7
	note g4  $09
	vol $3
	note g4  $09
	rest $09
	vol $7
	note g4  $09
	note gs4 $09
	vol $3
	note gs4 $09
	vol $7
	note g4  $09
	vol $3
	note g4  $09
	rest $12
	vol $7
	note g4  $09
	vol $3
	note g4  $09
	vol $7
	note gs4 $09
	vol $3
	note gs4 $09
	vol $7
	note c5  $09
	vol $3
	note c5  $09
	vol $7
	note b4  $1b
	note c5  $09
	note b4  $09
	note c5  $09
	note b4  $09
	note c5  $09
	note b4  $09
	note c5  $09
	note b4  $09
	note c5  $09
	note c5  $09
	vol $3
	note c5  $09
	vol $7
	note gs5 $09
	vol $3
	note gs5 $09
	vol $7
	note g5  $09
	vol $3
	note g5  $09
	vol $6
	note c5  $09
	vol $3
	note c5  $09
	vol $7
	note g5  $09
	vol $3
	note g5  $09
	vol $7
	note fs5 $09
	vol $3
	note fs5 $09
	vol $6
	note c5  $09
	vol $3
	note c5  $09
	vol $7
	note f5  $09
	vol $3
	note f5  $09
	vol $7
	note g5  $09
	vol $3
	note g5  $09
	vol $7
	note c5  $09
	vol $3
	note c5  $09
	vol $7
	note g5  $09
	vol $3
	note g5  $09
	vol $7
	note f5  $09
	vol $3
	note f5  $09
	vol $6
	note c5  $09
	vol $3
	note c5  $09
	vol $7
	note c5  $09
	vol $3
	note c5  $09
	vol $7
	note ds5 $09
	note d5  $09
	note cs5 $09
	note c5  $09
	note g4  $09
	vol $3
	note g4  $09
	rest $12
	vol $7
	note c4  $09
	vol $3
	note c4  $09
	rest $09
	vol $7
	note c4  $09
	note as4 $09
	vol $3
	note as4 $09
	vol $7
	note a4  $09
	vol $3
	note a4  $09
	vol $7
	note gs4 $09
	vol $3
	note gs4 $09
	vol $7
	note g4  $09
	vol $3
	note g4  $09
	rest $12
	vol $7
	note c5  $04
	rest $05
	note c5  $04
	rest $05
	note c6  $04
	rest $05
	vol $6
	note c6  $04
	rest $05
	vol $3
	note c6  $04
	rest $05
	vol $2
	note c6  $04
	rest $05
	vol $7
	note c5  $04
	rest $05
	note c5  $04
	rest $05
	note c6  $04
	rest $05
	vol $6
	note c6  $04
	rest $05
	vol $7
	note c6  $04
	rest $05
	vol $5
	note c6  $04
	rest $05
	vol $7
	note c7  $04
	rest $05
	vol $4
	note c7  $04
	rest $05
	goto musicf0144
	cmdff

sound15Channel4:
	cmdf2
musicf02b1:
	duty $0e
	note f1  $12
	rest $12
	note f2  $12
	rest $09
	note c2  $09
	note ds2 $09
	rest $09
	note ds2 $09
	rest $09
	note ds2 $09
	rest $09
	note c2  $09
	rest $09
	note f2  $09
	rest $09
	note f2  $09
	rest $09
	note f2  $12
	rest $09
	note c2  $09
	note ds2 $09
	rest $09
	note ds2 $09
	rest $09
	note d2  $09
	rest $09
	note c2  $09
	rest $09
	note f1  $12
	rest $12
	note f2  $12
	rest $09
	note c2  $09
	note ds2 $09
	rest $09
	note ds2 $09
	rest $09
	note ds2 $09
	rest $09
	note c2  $09
	rest $09
	note f2  $09
	rest $1b
	note f2  $12
	rest $09
	note c2  $09
	note ds2 $09
	rest $09
	note ds2 $09
	rest $09
	note ds2 $09
	note d2  $09
	note cs2 $09
	note c2  $09
	note f1  $12
	rest $12
	note f2  $12
	rest $09
	note c2  $09
	note ds2 $09
	rest $09
	note ds2 $09
	rest $09
	note ds2 $09
	rest $09
	note c2  $09
	rest $09
	note f2  $09
	rest $1b
	note f2  $12
	duty $0f
	note f2  $09
	duty $0e
	note c2  $09
	note ds2 $09
	rest $09
	note ds2 $09
	rest $09
	note ds2 $09
	rest $09
	note c2  $09
	rest $09
	note as1 $0d
	rest $17
	note as2 $09
	rest $09
	note f2  $09
	rest $09
	note gs2 $09
	rest $09
	note gs2 $09
	rest $09
	note gs2 $09
	rest $09
	note f2  $09
	rest $09
	note as2 $0d
	rest $17
	note as2 $12
	duty $0f
	note as2 $09
	duty $0e
	note f2  $09
	note gs2 $09
	rest $09
	note gs2 $09
	rest $09
	note gs2 $09
	note g2  $09
	note f2  $09
	note e2  $09
	note c2  $0d
	rest $71
	note c2  $04
	rest $05
	note c2  $04
	rest $05
	note c2  $0d
	rest $05
	note c2  $0d
	rest $05
	note c2  $0d
	rest $05
	note c2  $0d
	rest $05
	note c2  $09
	note cs2 $09
	note d2  $09
	note ds2 $09
	note e2  $09
	note f2  $09
	note fs2 $09
	note g2  $09
	goto musicf02b1
	cmdff

sound15Channel6:
	cmdf2
musicf03c2:
	vol $6
	note $24 $04
	rest $7a
	note $24 $04
	rest $05
	note $24 $04
	rest $05
	note $24 $04
	rest $7a
	note $24 $04
	rest $0e
	note $24 $04
	rest $7a
	note $24 $04
	rest $0e
	note $24 $04
	rest $7a
	note $24 $04
	rest $05
	note $24 $04
	rest $05
	note $24 $04
	rest $7a
	note $24 $04
	rest $0e
	note $24 $04
	rest $7a
	note $24 $04
	rest $0e
	note $24 $04
	rest $7a
	note $24 $04
	rest $0e
	note $24 $04
	rest $7a
	note $24 $04
	rest $05
	note $24 $04
	rest $05
	vol $4
	note $2e $04
	rest $20
	note $2e $04
	rest $20
	note $2e $04
	rest $20
	note $2e $04
	rest $0e
	vol $6
	note $24 $04
	rest $05
	note $24 $04
	rest $05
	note $24 $04
	rest $0e
	vol $4
	note $2a $04
	rest $0e
	vol $4
	note $2e $04
	rest $20
	vol $4
	note $2a $04
	rest $0e
	note $2e $04
	rest $0e
	note $2a $04
	rest $0e
	note $2e $04
	rest $0e
	goto musicf03c2
	cmdff

sound1cChannel1:
	vibrato $c1
	env $0 $00
	cmdf2
	duty $01
musicf0453:
	vol $0
	note gs3 $24
	vol $6
	note a3  $24
	note d4  $24
	note a4  $24
	note gs4 $48
	note f4  $24
	note d4  $24
	duty $02
	note c5  $09
	note b4  $09
	note c5  $09
	note b4  $09
	rest $6c
	vol $4
	note c5  $09
	note b4  $09
	note c5  $09
	note b4  $09
	rest $90
	duty $01
	vol $6
	note d4  $24
	note f4  $24
	note a4  $24
	note cs5 $48
	note d5  $24
	note e5  $24
	vol $7
	note f5  $09
	note e5  $09
	vol $6
	note f5  $09
	note e5  $09
	note gs4 $48
	rest $24
	vol $4
	note f5  $09
	note e5  $09
	note f5  $09
	note e5  $09
	note gs4 $48
	rest $24
	vol $6
	note e5  $09
	note ds5 $09
	note e5  $09
	note ds5 $09
	note g4  $6c
	note ds5 $09
	note d5  $09
	note ds5 $09
	note d5  $09
	note fs4 $5a
	rest $12
	vol $6
	note c5  $12
	note b4  $09
	rest $04
	vol $3
	note b4  $05
	vol $6
	note e5  $12
	vol $6
	note ds5 $09
	rest $04
	vol $3
	note ds5 $05
	vol $6
	note g5  $12
	vol $6
	note fs5 $09
	rest $04
	vol $3
	note fs5 $05
	vol $6
	note c6  $12
	note b5  $09
	rest $04
	vol $3
	note b5  $05
	vol $6
	note a6  $09
	note gs6 $09
	note g6  $09
	note fs6 $09
	note f6  $09
	rest $04
	vol $3
	note f6  $05
	vol $6
	note f6  $09
	note e6  $09
	note ds6 $09
	note d6  $09
	note cs6 $09
	rest $04
	vol $3
	note cs6 $05
	vol $6
	note cs6 $09
	note c6  $09
	note b5  $09
	note as5 $09
	note d5  $12
	vol $6
	note e5  $12
	note f5  $24
	vibrato $01
	env $0 $00
	vol $3
	note f5  $12
	vibrato $d1
	env $0 $00
	vol $6
	note d5  $12
	note e5  $12
	note f5  $12
	note a5  $48
	note gs5 $36
	vibrato $01
	env $0 $00
	vol $3
	note gs5 $12
	vibrato $d1
	env $0 $00
	vol $6
	note c5  $12
	note d5  $12
	note ds5 $24
	vibrato $01
	env $0 $00
	vol $3
	note ds5 $12
	vibrato $d1
	env $0 $00
	vol $6
	note c5  $12
	note d5  $12
	note ds5 $12
	note g5  $48
	note fs5 $36
	vibrato $01
	env $0 $00
	vol $3
	note fs5 $12
	vibrato $d1
	env $0 $00
	vol $6
	note as4 $12
	note c5  $12
	note cs5 $24
	vibrato $01
	env $0 $00
	vol $3
	note cs5 $12
	vibrato $d1
	env $0 $00
	vol $6
	note as4 $12
	note c5  $12
	note cs5 $12
	rest $04
	vol $3
	note cs5 $09
	rest $09
	vol $1
	note cs5 $09
	rest $05
	vol $6
	note e4  $51
	vibrato $01
	env $0 $00
	vol $3
	note e4  $1b
	rest $48
	vibrato $c1
	env $0 $00
	goto musicf0453
	cmdff

sound1cChannel0:
	vibrato $c1
	env $0 $00
	cmdf2
	duty $01
musicf059e:
	vol $0
	note gs3 $24
	vol $1
	note a3  $12
	vol $3
	note a3  $24
	note d4  $24
	note a4  $24
	note gs4 $48
	note f4  $24
	note d4  $24
	duty $02
	vol $3
	note c5  $09
	note b4  $09
	note c5  $09
	note b4  $09
	rest $6c
	vol $2
	note c5  $09
	note b4  $09
	note c5  $09
	note b4  $09
	rest $99
	duty $01
	vol $3
	note d4  $24
	note f4  $24
	note a4  $24
	note cs5 $48
	note d5  $24
	note e5  $24
	rest $03
	vol $3
	note f5  $09
	note e5  $09
	vol $3
	note f5  $09
	note e5  $09
	vol $3
	note gs4 $48
	rest $24
	vol $2
	note f5  $09
	note e5  $09
	note f5  $09
	vol $2
	note e5  $09
	note gs4 $63
	vol $3
	note e5  $09
	note ds5 $09
	note e5  $09
	note ds5 $09
	note g4  $6c
	vol $1
	note ds5 $09
	note d5  $09
	note ds5 $09
	note d5  $09
	note fs4 $57
	vol $6
	note a4  $12
	note gs4 $09
	rest $04
	vol $3
	note gs4 $05
	vol $6
	note c5  $12
	note b4  $09
	rest $04
	vol $3
	note b4  $05
	vol $6
	note e5  $12
	note ds5 $09
	rest $04
	vol $3
	note ds5 $05
	vol $6
	note a5  $12
	note gs5 $09
	rest $04
	vol $3
	note gs5 $05
	vol $6
	note fs6 $09
	note f6  $09
	note e6  $09
	note ds6 $09
	note d6  $09
	rest $04
	vol $3
	note d6  $05
	vol $6
	note d6  $09
	note cs6 $09
	note c6  $09
	note b5  $09
	note as5 $09
	rest $04
	vol $3
	note as5 $05
	vol $6
	note as5 $09
	note a5  $09
	note gs5 $09
	note g5  $09
	duty $02
	note d4  $04
	rest $05
	note f4  $04
	vol $3
	note d4  $05
	vol $6
	note e4  $04
	vol $3
	note f4  $05
	vol $6
	note f4  $04
	vol $3
	note e4  $05
	vol $6
	note d4  $04
	vol $3
	note f4  $05
	vol $6
	note f4  $04
	vol $3
	note d4  $05
	vol $6
	note e4  $04
	vol $3
	note f4  $05
	vol $6
	note f4  $04
	vol $3
	note e4  $05
	vol $6
	note d4  $04
	vol $3
	note f4  $05
	vol $6
	note f4  $04
	vol $3
	note d4  $05
	vol $6
	note e4  $04
	vol $3
	note f4  $05
	vol $6
	note f4  $04
	vol $3
	note e4  $05
	vol $6
	note d4  $04
	vol $3
	note f4  $05
	vol $6
	note f4  $04
	vol $3
	note d4  $05
	vol $6
	note e4  $04
	vol $3
	note f4  $05
	vol $6
	note f4  $04
	vol $3
	note e4  $05
	vol $6
	note b3  $04
	vol $3
	note f4  $05
	vol $6
	note d4  $04
	vol $3
	note b3  $05
	vol $6
	note cs4 $04
	vol $3
	note d4  $05
	vol $6
	note d4  $04
	vol $3
	note cs4 $05
	vol $6
	note b3  $04
	vol $3
	note d4  $05
	vol $6
	note d4  $04
	vol $3
	note b3  $05
	vol $6
	note cs4 $04
	vol $3
	note d4  $05
	vol $6
	note d4  $04
	vol $3
	note cs4 $05
	vol $6
	note b3  $04
	vol $3
	note d4  $05
	vol $6
	note d4  $04
	vol $3
	note b3  $05
	vol $6
	note cs4 $04
	vol $3
	note d4  $05
	vol $6
	note d4  $04
	vol $3
	note cs4 $05
	vol $6
	note b3  $04
	vol $3
	note d4  $05
	vol $6
	note d4  $04
	vol $3
	note b3  $05
	vol $6
	note cs4 $04
	vol $3
	note d4  $05
	vol $6
	note d4  $04
	vol $3
	note cs4 $05
	vol $6
	note c4  $04
	vol $3
	note d4  $05
	vol $6
	note ds4 $04
	vol $3
	note c4  $05
	vol $6
	note d4  $04
	vol $3
	note ds4 $05
	vol $6
	note ds4 $04
	vol $3
	note d4  $05
	vol $6
	note c4  $04
	vol $3
	note ds4 $05
	vol $6
	note ds4 $04
	vol $3
	note c4  $05
	vol $6
	note d4  $04
	vol $3
	note ds4 $05
	vol $6
	note ds4 $04
	vol $3
	note d4  $05
	vol $6
	note c4  $04
	vol $3
	note ds4 $05
	vol $6
	note ds4 $04
	vol $3
	note c4  $05
	vol $6
	note d4  $04
	vol $3
	note ds4 $05
	vol $6
	note ds4 $04
	vol $3
	note d4  $05
	vol $6
	note c4  $04
	vol $3
	note ds4 $05
	vol $6
	note ds4 $04
	vol $3
	note c4  $05
	vol $6
	note d4  $04
	vol $3
	note ds4 $05
	vol $6
	note ds4 $04
	vol $3
	note d4  $05
	vol $6
	note a3  $04
	vol $3
	note ds4 $05
	vol $6
	note c4  $04
	vol $3
	note a3  $05
	vol $6
	note b3  $04
	vol $3
	note c4  $05
	vol $6
	note c4  $04
	vol $3
	note b3  $05
	vol $6
	note a3  $04
	vol $3
	note c4  $05
	vol $6
	note c4  $04
	vol $3
	note a3  $05
	vol $6
	note b3  $04
	vol $3
	note c4  $05
	vol $6
	note c4  $04
	vol $3
	note b3  $05
	vol $6
	note a3  $04
	vol $3
	note c4  $05
	vol $6
	note c4  $04
	vol $3
	note a3  $05
	vol $6
	note b3  $04
	vol $3
	note c4  $05
	vol $6
	note c4  $04
	vol $3
	note b3  $05
	vol $6
	note a3  $04
	vol $3
	note c4  $05
	vol $6
	note c4  $04
	vol $3
	note a3  $05
	vol $6
	note b3  $04
	vol $3
	note c4  $05
	vol $6
	note c4  $04
	vol $3
	note b3  $05
	duty $01
	vol $6
	note as3 $12
	note c4  $12
	note cs4 $24
	vibrato $01
	env $0 $00
	vol $3
	note cs4 $12
	vibrato $d1
	env $0 $00
	vol $6
	note as3 $12
	note c4  $12
	note cs4 $12
	rest $04
	vol $3
	note cs4 $09
	rest $05
	vol $1
	note cs4 $09
	rest $09
	vol $6
	note e3  $48
	vibrato $01
	env $0 $00
	vol $3
	note e3  $24
	rest $48
	vibrato $d1
	env $0 $00
	goto musicf059e
	cmdff

sound1cChannel4:
	duty $0e
musicf0818:
	note d2  $09
	rest $09
	note d2  $09
	rest $75
	note d2  $09
	rest $09
	note d2  $09
	rest $75
	note d2  $09
	rest $09
	note d2  $09
	rest $75
	note d2  $09
	rest $09
	note d2  $09
	rest $75
	note d2  $09
	rest $09
	note d2  $09
	rest $63
	note d2  $09
	rest $09
	note d2  $09
	rest $09
	note d2  $09
	rest $75
	note d2  $09
	rest $09
	note d2  $09
	rest $75
	note d2  $09
	rest $09
	note d2  $09
	rest $75
	note cs2 $09
	rest $09
	note cs2 $09
	rest $75
	note c2  $09
	rest $09
	note c2  $09
	rest $75
	note b1  $90
	rest $90
	note d2  $09
	rest $09
	note d2  $09
	rest $2d
	note d2  $09
	rest $09
	note d2  $09
	rest $2d
	note gs2 $09
	rest $09
	note gs2 $09
	rest $2d
	note gs2 $09
	rest $09
	note gs2 $09
	rest $2d
	note c2  $09
	rest $09
	note c2  $09
	rest $2d
	note c2  $09
	rest $09
	note c2  $09
	rest $2d
	note fs2 $09
	rest $09
	note fs2 $09
	rest $2d
	note fs2 $09
	rest $09
	note fs2 $09
	rest $1b
	note ds2 $04
	note d2  $05
	note c2  $04
	note b1  $05
	note as1 $12
	note c2  $12
	note cs2 $2d
	rest $09
	note as1 $12
	note c2  $12
	note cs2 $12
	rest $24
	note e1  $09
	note f1  $09
	note e1  $09
	note f1  $09
	note e1  $09
	note f1  $09
	note e1  $09
	note f1  $09
	note e1  $09
	rest $63
	goto musicf0818
	cmdff

sound1fChannel1:
	vibrato $e1
	env $0 $00
	cmdf2
	duty $01
musicf08e7:
	vol $0
	note gs3 $24
	vol $6
	note f4  $24
	note c5  $24
	note f4  $24
	note ds4 $24
	note as4 $12
	vol $3
	note as4 $12
	vol $6
	note as4 $36
	vol $3
	note as4 $12
	vol $1
	note as4 $12
	rest $12
	vol $6
	note f4  $24
	note c5  $24
	note f5  $24
	note ds5 $24
	note g4  $24
	note gs4 $0d
	rest $05
	vol $4
	note gs4 $04
	rest $05
	vol $2
	note gs4 $04
	rest $05
	vol $6
	note ds5 $12
	vol $3
	note ds5 $12
	vol $6
	note ds5 $48
	note cs5 $24
	note ds5 $12
	note cs5 $12
	note c5  $24
	note as4 $24
	note gs4 $12
	vol $3
	note gs4 $12
	vol $6
	note c5  $12
	vol $3
	note c5  $12
	vol $6
	note c5  $24
	note as4 $1b
	vol $3
	note as4 $09
	vol $6
	note g5  $24
	note f5  $24
	note e5  $5a
	vibrato $01
	env $0 $00
	vol $3
	note e5  $24
	vol $1
	note e5  $24
	vol $0
	note e5  $12
	vibrato $e1
	env $0 $00
	vol $6
	note f5  $24
	note c5  $24
	note gs4 $24
	note as4 $24
	note ds5 $09
	rest $04
	vol $3
	note ds5 $09
	rest $05
	vol $1
	note ds5 $09
	vol $6
	note ds5 $48
	vibrato $01
	env $0 $00
	vol $3
	note ds5 $24
	vibrato $e1
	env $0 $00
	vol $6
	note as5 $12
	note gs5 $12
	note g5  $12
	vol $6
	note f5  $12
	note ds5 $12
	note cs5 $12
	note c5  $24
	vol $6
	note f5  $09
	rest $04
	vol $4
	note f5  $05
	rest $04
	vol $2
	note f5  $05
	rest $09
	vol $6
	note f5  $09
	rest $04
	vol $4
	note f5  $05
	rest $04
	vol $2
	note f5  $05
	rest $09
	vol $6
	note f4  $12
	vol $3
	note f4  $12
	vol $6
	note ds5 $48
	vol $7
	note cs5 $48
	vibrato $01
	env $0 $00
	vol $3
	note cs5 $24
	vol $1
	note cs5 $24
	rest $12
	vibrato $e1
	env $0 $00
	vol $6
	note cs5 $12
	note ds5 $12
	vol $6
	note cs5 $12
	note c5  $48
	note as4 $48
	vibrato $01
	env $0 $00
	vol $3
	note as4 $24
	vol $1
	note as4 $24
	rest $48
	vibrato $e1
	env $0 $00
	goto musicf08e7
	cmdff

sound1fChannel0:
	vibrato $e1
	env $0 $00
	cmdf2
	duty $01
musicf09ee:
	vol $6
	note as2 $24
	note cs3 $24
	note gs3 $24
	note cs3 $24
	note c3  $24
	note g3  $24
	note as3 $24
	note c3  $24
	vol $3
	note c3  $12
	rest $12
	vol $6
	note cs3 $24
	note gs3 $24
	note cs3 $24
	note c3  $24
	note g3  $24
	note f3  $24
	vol $3
	note f3  $12
	rest $12
	vol $6
	note as2 $12
	note c3  $12
	note cs3 $12
	note gs3 $12
	note g3  $24
	note ds3 $24
	note gs3 $24
	note g3  $24
	note f3  $24
	note ds3 $24
	note cs3 $7e
	vol $3
	note cs3 $12
	vol $6
	note c3  $12
	note cs3 $12
	note c3  $12
	note cs3 $12
	note c3  $24
	vol $6
	note c4  $09
	rest $04
	vol $3
	note c4  $09
	rest $05
	vol $1
	note c4  $09
	vol $6
	note cs3 $24
	vol $6
	note gs3 $24
	note c4  $24
	note cs3 $24
	note c3  $24
	note g3  $24
	note as3 $24
	note c3  $24
	note cs3 $24
	note gs3 $24
	note c4  $24
	note cs3 $24
	note c3  $24
	note as3 $24
	note gs3 $24
	vol $3
	note gs3 $12
	rest $12
	vol $6
	note as2 $24
	note c3  $24
	note cs3 $24
	note ds3 $24
	note f3  $24
	note g3  $24
	note gs3 $24
	note as3 $24
	note ds3 $24
	note f3  $24
	note g3  $24
	note gs3 $24
	note as3 $24
	note c4  $24
	note cs4 $24
	note ds4 $24
	goto musicf09ee
	cmdff

sound1fChannel4:
	cmdf2
	duty $08
musicf0a95:
	rest $31
	note f4  $24
	note c5  $24
	note f4  $24
	note ds4 $24
	note as4 $12
	rest $12
	note as4 $36
	rest $36
	note f4  $24
	note c5  $24
	note f5  $24
	note ds5 $24
	note g4  $24
	note gs4 $0e
	rest $16
	note ds5 $12
	rest $12
	note ds5 $48
	note cs5 $24
	note ds5 $12
	note cs5 $12
	note c5  $24
	note as4 $24
	note gs4 $24
	note c5  $12
	rest $12
	note c5  $24
	note as4 $24
	note g5  $24
	note f5  $24
	note e5  $5a
	rest $5a
	note f5  $24
	note c5  $24
	note gs4 $24
	note as4 $24
	note ds5 $09
	rest $1b
	note ds5 $48
	note ds5 $24
	note as5 $12
	note gs5 $12
	note g5  $12
	note f5  $12
	note ds5 $12
	note cs5 $12
	note c5  $24
	note f5  $09
	rest $1b
	note f5  $09
	rest $1b
	note f4  $24
	note ds5 $48
	note cs5 $48
	rest $5a
	note cs5 $12
	note ds5 $12
	vol $3
	note cs5 $12
	note c5  $48
	note as4 $48
	rest $83
	goto musicf0a95
	cmdff

sound40Start:

sound40Channel1:
	vol $0
	note gs3 $10
	vibrato $e1
	env $0 $00
	duty $01
	vol $6
	note as4 $04
	rest $04
	vol $4
	note as4 $04
	rest $04
	vol $6
	note f4  $05
	note as4 $05
	note f5  $06
	note as5 $30
	vibrato $01
	env $0 $00
	vol $4
	note as5 $10
	vibrato $e1
	env $0 $00
	duty $02
	vol $6
	note d5  $0a
	note as4 $0b
	note f4  $0b
	note cs4 $04
	rest $04
	vol $4
	note cs4 $04
	rest $04
	vol $6
	note as3 $05
	note cs4 $05
	note fs4 $06
	note as4 $18
	vibrato $01
	env $0 $00
	vol $4
	note as4 $08
	vibrato $e1
	env $0 $00
	vol $6
	note ds4 $04
	rest $04
	vol $4
	note ds4 $04
	rest $04
	vol $6
	note c4  $05
	note ds4 $05
	note gs4 $06
	note c5  $18
	vibrato $01
	env $0 $00
	vol $4
	note c5  $08
	vibrato $e1
	env $0 $00
	vol $6
	note as4 $08
	rest $04
	vol $4
	note as4 $08
	rest $04
	vol $6
	note f4  $08
	note d4  $30
	vibrato $01
	env $0 $00
	vol $4
	note d4  $10
	vibrato $e1
	env $0 $00
	vol $6
	note as4 $08
	note a4  $08
	note as4 $08
	note c5  $08
	vol $6
	note cs5 $08
	note as4 $08
	note c5  $08
	note cs5 $08
	note ds5 $20
	vibrato $01
	env $0 $00
	vol $4
	note ds5 $08
	vibrato $e1
	env $0 $00
	vol $6
	note c5  $08
	note cs5 $08
	note ds5 $08
	note f5  $08
	note cs5 $08
	note ds5 $08
	note f5  $08
	note g5  $24
	vibrato $01
	env $0 $00
	vol $4
	note g5  $09
	vibrato $e1
	env $0 $00
	vol $6
	note ds5 $09
	note f5  $09
	note g5  $09
	note a5  $42
	vibrato $01
	env $0 $00
	vol $4
	note a5  $16
	vol $2
	note a5  $16
	cmdff

sound40Channel0:
	vol $0
	note gs3 $10
	vibrato $e1
	env $0 $00
	duty $01
	vol $6
	note d4  $04
	rest $04
	vol $4
	note d4  $04
	rest $04
	vol $6
	note f3  $05
	note as3 $05
	note d4  $06
	note f4  $10
	note gs3 $05
	note as3 $05
	note ds4 $06
	note f4  $18
	note e4  $04
	note ds4 $04
	note d4  $20
	duty $02
	note fs3 $18
	vol $4
	note fs3 $08
	vol $6
	note fs3 $05
	note cs3 $05
	note fs3 $06
	note as3 $05
	note fs3 $05
	note as3 $06
	note gs3 $18
	vol $4
	note gs3 $08
	vol $6
	note gs3 $05
	note ds3 $05
	note gs3 $06
	note c4  $05
	note gs3 $05
	note c4  $06
	note f3  $08
	rest $04
	vol $4
	note f3  $04
	vol $6
	note as2 $08
	note f3  $08
	note as3 $18
	vol $4
	note as3 $08
	vol $5
	note f5  $04
	rest $04
	note as4 $04
	vol $3
	note f5  $04
	vol $5
	note d5  $04
	vol $3
	note as4 $04
	vol $5
	note f4  $04
	vol $3
	note d5  $04
	vol $6
	note f4  $08
	note as3 $08
	note cs4 $08
	note f4  $08
	vol $6
	note fs4 $20
	vol $4
	note fs4 $08
	vol $6
	note ds4 $08
	note f4  $08
	note fs4 $08
	note gs4 $08
	note ds4 $08
	note f4  $08
	note fs4 $08
	note gs4 $08
	note f4  $08
	note fs4 $08
	note gs4 $08
	note as4 $1b
	vol $4
	note as4 $09
	vol $6
	note as4 $09
	note g4  $09
	note a4  $09
	note as4 $09
	note c5  $42
	vibrato $01
	env $0 $00
	vol $4
	note c5  $16
	vol $2
	note c5  $16
	cmdff

sound40Channel4:
	rest $10
	duty $0e
	note as2 $20
	vol $4
	note as2 $08
	rest $08
	duty $0e
	note f2  $04
	duty $0f
	note f2  $04
	duty $0e
	note f2  $04
	duty $0f
	note f2  $04
	duty $0e
	note as2 $08
	vol $4
	note as2 $08
	duty $0e
	note f2  $08
	vol $4
	note f2  $08
	duty $0e
	note as2 $08
	vol $4
	note as2 $08
	duty $0e
	note gs2 $10
	note fs2 $10
	note cs3 $10
	note fs3 $08
	note cs3 $08
	note fs2 $04
	duty $0f
	note fs2 $04
	duty $0e
	note fs2 $04
	duty $0f
	note fs2 $04
	duty $0e
	note gs2 $10
	note ds3 $10
	note gs3 $08
	note ds3 $08
	note gs2 $04
	duty $0f
	note gs2 $04
	duty $0e
	note gs2 $04
	duty $0f
	note gs2 $04
	duty $0e
	note as2 $20
	vol $4
	note as2 $08
	rest $08
	duty $0e
	note f3  $05
	note d3  $05
	note as2 $06
	note f2  $10
	note d2  $05
	note as1 $05
	note d2  $06
	note d3  $10
	note f2  $04
	duty $0f
	note f2  $04
	duty $0e
	note f2  $08
	note ds3 $20
	note ds2 $10
	note ds3 $04
	duty $0f
	note ds3 $04
	duty $0e
	note ds3 $04
	duty $0f
	note ds3 $04
	duty $0e
	note ds3 $20
	note ds2 $10
	note ds3 $08
	duty $0f
	note ds3 $08
	duty $0e
	note f3  $12
	note f2  $04
	duty $0f
	note f2  $05
	rest $09
	duty $0e
	note f3  $24
	note g3  $2c
	note a3  $2c
	duty $0f
	note a3  $16
	cmdff

sound40Channel6:
	vol $5
	note $26 $05
	vol $4
	note $26 $05
	note $26 $06
	vol $6
	note $26 $30
	vol $5
	note $26 $05
	vol $4
	note $26 $05
	note $26 $06
	vol $5
	note $26 $02
	vol $3
	note $26 $02
	vol $2
	note $26 $04
	vol $2
	note $26 $02
	vol $2
	note $26 $02
	vol $2
	note $26 $04
	vol $2
	note $26 $02
	vol $3
	note $26 $02
	vol $3
	note $26 $04
	vol $3
	note $26 $02
	vol $3
	note $26 $02
	vol $3
	note $26 $04
	vol $4
	note $26 $02
	vol $4
	note $26 $02
	vol $4
	note $26 $04
	vol $4
	note $26 $02
	vol $4
	note $26 $02
	vol $4
	note $26 $04
	vol $5
	note $26 $02
	vol $5
	note $26 $02
	vol $5
	note $26 $04
	vol $5
	note $26 $02
	vol $5
	note $26 $02
	vol $6
	note $26 $04
	vol $6
	note $26 $30
	vol $5
	note $26 $05
	vol $4
	note $26 $05
	note $26 $06
	vol $5
	note $26 $02
	vol $3
	note $26 $02
	vol $2
	note $26 $04
	vol $2
	note $26 $02
	vol $2
	note $26 $02
	vol $2
	note $26 $04
	vol $2
	note $26 $02
	vol $3
	note $26 $02
	vol $3
	note $26 $04
	vol $3
	note $26 $02
	vol $3
	note $26 $02
	vol $3
	note $26 $04
	vol $4
	note $26 $02
	vol $4
	note $26 $02
	vol $4
	note $26 $04
	vol $4
	note $26 $02
	vol $4
	note $26 $02
	vol $4
	note $26 $04
	vol $5
	note $26 $02
	vol $5
	note $26 $02
	vol $5
	note $26 $04
	vol $5
	note $26 $02
	vol $5
	note $26 $02
	vol $6
	note $26 $04
	vol $6
	note $26 $30
	vol $5
	note $26 $05
	vol $4
	note $26 $05
	note $26 $06
	vol $5
	note $26 $02
	vol $3
	note $26 $02
	vol $2
	note $26 $04
	vol $2
	note $26 $02
	vol $2
	note $26 $02
	vol $2
	note $26 $04
	vol $2
	note $26 $02
	vol $3
	note $26 $02
	vol $3
	note $26 $04
	vol $3
	note $26 $02
	vol $3
	note $26 $02
	vol $3
	note $26 $04
	vol $4
	note $26 $02
	vol $4
	note $26 $02
	vol $4
	note $26 $04
	vol $4
	note $26 $02
	vol $4
	note $26 $02
	vol $4
	note $26 $04
	vol $5
	note $26 $02
	vol $5
	note $26 $02
	vol $5
	note $26 $04
	vol $5
	note $26 $02
	vol $5
	note $26 $02
	vol $6
	note $26 $04
	vol $5
	note $26 $02
	vol $3
	note $26 $02
	vol $2
	note $26 $04
	vol $1
	note $26 $02
	vol $0
	note $26 $02
	vol $1
	note $26 $04
	vol $1
	note $26 $02
	vol $1
	note $26 $02
	vol $1
	note $26 $04
	vol $1
	note $26 $02
	vol $2
	note $26 $02
	vol $2
	note $26 $04
	vol $2
	note $26 $02
	vol $2
	note $26 $02
	vol $2
	note $26 $04
	vol $3
	note $26 $02
	vol $3
	note $26 $02
	vol $3
	note $26 $04
	vol $5
	note $26 $08
	note $26 $08
	note $26 $02
	vol $3
	note $26 $02
	vol $2
	note $26 $04
	vol $1
	note $26 $02
	vol $1
	note $26 $02
	vol $1
	note $26 $04
	vol $1
	note $26 $02
	vol $1
	note $26 $02
	vol $1
	note $26 $04
	vol $2
	note $26 $02
	vol $2
	note $26 $02
	vol $2
	note $26 $04
	vol $2
	note $26 $02
	vol $3
	note $26 $02
	vol $3
	note $26 $04
	vol $3
	note $26 $02
	vol $3
	note $26 $02
	vol $3
	note $26 $04
	vol $5
	note $26 $08
	note $26 $08
	note $26 $24
	note $26 $12
	note $26 $09
	note $26 $09
	note $26 $03
	vol $3
	note $26 $03
	vol $2
	note $26 $05
	vol $2
	note $26 $03
	vol $2
	note $26 $03
	vol $2
	note $26 $05
	vol $2
	note $26 $03
	vol $3
	note $26 $03
	vol $3
	note $26 $05
	vol $3
	note $26 $03
	vol $3
	note $26 $03
	vol $3
	note $26 $05
	vol $5
	note $26 $03
	vol $3
	note $26 $03
	vol $2
	note $26 $05
	vol $2
	note $26 $03
	vol $2
	note $26 $03
	vol $3
	note $26 $05
	vol $3
	note $26 $03
	vol $3
	note $26 $03
	vol $3
	note $26 $05
	vol $3
	note $26 $03
	vol $4
	note $26 $03
	vol $4
	note $26 $1b
	cmdff

sound07Channel1:
	cmdf2
	vibrato $e1
	env $0 $00
	duty $01
	vol $8
	note e4  $06
	note fs4 $06
	note gs4 $06
	note a4  $06
musicf0f36:
	note b4  $18
	vol $5
	note b4  $0c
	vol $8
	note e5  $06
	vol $5
	note e5  $06
	vol $8
	note e5  $18
	vol $5
	note e5  $0c
	vol $8
	note e5  $0c
	note d5  $08
	note e5  $08
	note d5  $08
	vol $8
	note cs5 $0c
	note b4  $0c
	note cs5 $10
	rest $02
	vol $5
	note cs5 $06
	vol $8
	note a4  $10
	rest $02
	vol $5
	note a4  $06
	vol $8
	note fs4 $10
	rest $02
	vol $5
	note fs4 $06
	vol $8
	note cs5 $10
	rest $02
	vol $5
	note cs5 $06
	vol $8
	note b4  $24
	note e4  $06
	rest $06
	note e4  $18
	vol $5
	note e4  $0c
	vol $8
	note e4  $0c
	note g4  $0c
	note fs4 $0c
	note e4  $0c
	note d4  $0c
	note b3  $0c
	rest $06
	vol $5
	note b3  $06
	vol $8
	note d4  $0c
	rest $06
	vol $5
	note d4  $06
	vol $8
	note e4  $60
	vibrato $01
	vol $5
	note e4  $30
	vibrato $e1
	vol $8
	note e4  $0c
	rest $06
	vol $5
	note e4  $06
	vol $8
	note b4  $0c
	rest $06
	vol $5
	note b4  $06
	vol $8
	note b4  $18
	rest $06
	vol $5
	note b4  $06
	vol $8
	note d5  $0c
	note e5  $18
	note cs5 $0c
	note a4  $0c
	note b4  $0c
	rest $06
	vol $5
	note b4  $06
	vol $8
	note b4  $0c
	note d5  $0c
	note e5  $0c
	rest $06
	vol $5
	note e5  $06
	vol $8
	note d5  $0c
	note e5  $0c
	note g5  $0c
	note fs5 $0c
	note e5  $0c
	note d5  $0c
	note fs5 $0c
	note e5  $0c
	note d5  $0c
	note a4  $0c
	note b4  $0c
	rest $06
	vol $5
	note b4  $06
	vol $8
	note a4  $0c
	note b4  $0c
	note g4  $18
	note fs4 $18
	note e4  $18
	note d4  $18
	note fs4 $0c
	rest $06
	vol $5
	note fs4 $06
	vol $8
	note e4  $0c
	note fs4 $0c
	note d4  $08
	note e4  $08
	note d4  $08
	note cs4 $0c
	note as3 $0c
	note b3  $90
	vibrato $01
	vol $5
	note b3  $18
	vibrato $e1
	vol $8
	note e4  $06
	note fs4 $06
	note gs4 $06
	note a4  $06
	goto musicf0f36
	cmdff

sound07Channel0:
	vol $0
	note gs3 $18
	cmdf2
	vibrato $e1
	env $0 $00
	duty $02
musicf1037:
	vol $8
	note gs4 $18
	vol $5
	note gs4 $0c
	vol $8
	note gs4 $06
	vol $5
	note gs4 $06
	vol $8
	note gs4 $1e
	vol $5
	note gs4 $06
	vol $8
	note gs4 $0c
	note a4  $0c
	rest $06
	vol $5
	note a4  $06
	vol $8
	note a4  $0c
	rest $06
	vol $5
	note a4  $06
	vol $8
	note a4  $0c
	rest $06
	vol $5
	note a4  $06
	vol $8
	note fs4 $0c
	note cs4 $0c
	note e4  $0c
	note ds4 $0c
	note e4  $0c
	note cs4 $0c
	note gs4 $12
	vol $5
	note gs4 $06
	vol $8
	note gs4 $0c
	note b3  $0c
	note gs3 $0c
	rest $06
	vol $5
	note gs3 $06
	vol $8
	note gs3 $0c
	note a3  $0c
	note d4  $0c
	note cs4 $0c
	note b3  $0c
	note a3  $0c
	note fs3 $0c
	rest $06
	vol $5
	note fs3 $06
	vol $8
	note fs3 $0c
	note a3  $0c
	vol $5
	note a3  $0c
	rest $0c
	vol $8
	note a3  $0c
	note b3  $0c
	note a3  $0c
	rest $06
	vol $5
	note a3  $06
	vol $8
	note fs3 $0c
	rest $06
	vol $5
	note fs3 $06
	vol $8
	note a3  $0c
	note g3  $0c
	note fs3 $0c
	note d3  $0c
	note g3  $0c
	rest $06
	vol $5
	note g3  $06
	vol $8
	note g3  $0c
	note a3  $0c
	note b3  $0c
	rest $06
	vol $5
	note b3  $06
	vol $8
	note b3  $0c
	note cs4 $0c
	note d4  $0c
	note cs4 $0c
	note b3  $0c
	note fs3 $0c
	note a3  $0c
	rest $06
	vol $5
	note a3  $06
	vol $8
	note b3  $0c
	rest $06
	vol $5
	note b3  $06
	vol $8
	note fs3 $24
	note a3  $0c
	note e4  $0c
	note d4  $0c
	note cs4 $0c
	note b3  $0c
	note d4  $0c
	rest $06
	vol $5
	note d4  $06
	vol $8
	note a3  $0c
	rest $06
	vol $5
	note a3  $06
	vol $8
	note g3  $18
	note fs3 $18
	note e3  $0c
	vol $5
	note e3  $0c
	vol $8
	note e4  $0c
	note d4  $0c
	note cs4 $0c
	rest $06
	vol $5
	note cs4 $06
	vol $8
	note b3  $0c
	rest $06
	vol $5
	note b3  $06
	vol $8
	note d4  $0c
	rest $06
	vol $5
	note d4  $06
	vol $8
	note cs4 $0c
	note d4  $0c
	note b3  $18
	note as3 $12
	rest $06
	note b2  $24
	note c3  $0c
	note ds3 $0c
	note e3  $0c
	note fs3 $0c
	note g3  $0c
	note a3  $18
	note g3  $0c
	note fs3 $0c
	note c4  $0c
	rest $06
	vol $5
	note c4  $06
	vol $8
	note b3  $0c
	rest $06
	vol $5
	note b3  $06
	goto musicf1037
	cmdff

sound07Channel4:
	rest $18
musicf115f:
	duty $0e
	note e3  $1e
	rest $06
	note e3  $06
	rest $06
	note e3  $18
	rest $0c
	note e3  $06
	rest $06
	duty $0e
	note e3  $12
	rest $06
	note e3  $12
	rest $06
	note e3  $12
	rest $06
	note a2  $12
	rest $06
	note b2  $12
	rest $06
	note b2  $12
	rest $06
	note e3  $0c
	note ds3 $0c
	note e3  $0c
	note b2  $0c
	note gs2 $0c
	note a2  $0c
	note gs2 $0c
	note fs2 $0c
	note a2  $0c
	duty $0f
	note a2  $0c
	duty $0e
	note g2  $0c
	note fs2 $0c
	note b2  $0c
	duty $0f
	note b2  $0c
	duty $0e
	note b2  $0c
	duty $0f
	note b2  $0c
	duty $0e
	note e2  $30
	note d3  $30
	note b2  $30
	note e2  $12
	rest $06
	note e2  $12
	rest $06
	note e2  $1e
	rest $06
	note gs2 $0c
	note a2  $18
	note e3  $0c
	duty $0e
	note cs3 $0c
	note e3  $0c
	duty $0f
	note e3  $0c
	duty $0e
	note e3  $0c
	note b2  $0c
	note cs3 $0c
	duty $0f
	note cs3 $0c
	duty $0e
	note b2  $0c
	note e3  $0c
	note d3  $0c
	duty $0f
	note d3  $0c
	duty $0e
	note fs3 $0c
	duty $0f
	note fs3 $0c
	duty $0e
	note a2  $24
	note fs2 $0c
	note b2  $12
	rest $06
	note b2  $12
	rest $06
	note e3  $30
	note d3  $30
	note cs3 $30
	note as2 $30
	note b2  $0c
	duty $0f
	note b2  $0c
	duty $0e
	note b2  $0c
	note a2  $0c
	note g2  $18
	note fs2 $0c
	note g2  $0c
	note e2  $18
	note fs2 $0c
	note e2  $0c
	note ds2 $0c
	note fs2 $0c
	note a2  $0c
	note c3  $0c
	goto musicf115f
	cmdff

sound26Channel1:
	vibrato $00
	env $0 $00
	duty $02
musicf1239:
	vol $6
	note a4  $1c
	rest $08
	note d5  $07
	rest $06
	vol $3
	note d5  $03
	rest $02
	vol $6
	note fs5 $07
	rest $06
	vol $3
	note fs5 $03
	rest $02
	vol $6
	note a5  $1c
	rest $08
	note gs5 $07
	rest $0b
	note f5  $07
	rest $06
	vol $3
	note f5  $03
	rest $02
	vol $6
	note gs5 $1c
	rest $08
	note fs5 $07
	rest $06
	vol $3
	note fs5 $03
	rest $02
	vol $6
	note d5  $07
	rest $06
	vol $3
	note d5  $03
	rest $02
	vol $6
	note f5  $1c
	rest $08
	note fs5 $07
	rest $06
	vol $3
	note fs5 $07
	rest $07
	vol $2
	note fs5 $07
	rest $02
	vol $6
	note as5 $1c
	rest $08
	note a5  $07
	rest $06
	vol $3
	note a5  $07
	rest $07
	vol $2
	note a5  $07
	rest $02
	vol $6
	note as5 $07
	rest $06
	vol $3
	note as5 $03
	rest $02
	vol $6
	note as5 $07
	rest $06
	vol $3
	note as5 $03
	rest $02
	vol $6
	note a5  $07
	rest $06
	vol $3
	note a5  $07
	rest $07
	vol $2
	note a5  $07
	rest $02
	vol $6
	note a4  $1c
	rest $08
	note d5  $07
	rest $06
	vol $3
	note d5  $03
	rest $02
	vol $6
	note fs5 $07
	rest $06
	vol $3
	note fs5 $03
	rest $02
	vol $6
	note a5  $1c
	rest $08
	note gs5 $07
	rest $06
	vol $3
	note gs5 $03
	rest $02
	vol $6
	note f5  $07
	rest $06
	vol $3
	note f5  $03
	rest $02
	vol $6
	note gs5 $1c
	rest $08
	note d6  $07
	rest $06
	vol $3
	note d6  $03
	rest $02
	vol $6
	note gs5 $07
	rest $06
	vol $3
	note gs5 $03
	rest $02
	vol $6
	note as5 $07
	rest $06
	vol $3
	note as5 $03
	rest $02
	vol $6
	note as5 $07
	rest $06
	vol $3
	note as5 $03
	rest $02
	vol $6
	note a5  $07
	rest $06
	vol $3
	note a5  $07
	rest $07
	vol $2
	note a5  $07
	rest $02
	vol $6
	note d6  $1c
	rest $08
	note fs5 $07
	rest $06
	vol $3
	note fs5 $07
	rest $07
	vol $2
	note fs5 $07
	rest $02
	vol $6
	note d6  $07
	rest $06
	vol $3
	note d6  $03
	rest $02
	vol $6
	note d6  $07
	rest $06
	vol $3
	note d6  $03
	rest $02
	vol $6
	note fs5 $07
	rest $06
	vol $3
	note fs5 $07
	rest $07
	vol $2
	note fs5 $07
	rest $02
	vol $6
	note d6  $1c
	rest $08
	note fs5 $15
	rest $06
	note g5  $07
	rest $02
	note a5  $24
	vol $3
	note a5  $12
	rest $12
	goto musicf1239
	cmdff

sound26Channel0:
	vibrato $00
	env $0 $00
	duty $02
musicf1383:
	vol $0
	note gs3 $12
	vol $6
	note d4  $07
	rest $02
	note cs4 $07
	rest $02
	note d4  $07
	rest $0b
	vol $6
	note d5  $07
	rest $06
	vol $3
	note d5  $07
	rest $07
	vol $2
	note d5  $07
	rest $02
	vol $6
	note d4  $07
	rest $02
	note cs4 $07
	rest $02
	note d4  $07
	rest $0b
	vol $6
	note d5  $07
	rest $06
	vol $3
	note d5  $07
	rest $07
	vol $2
	note d5  $07
	rest $02
	vol $6
	note d4  $07
	rest $02
	note cs4 $07
	rest $02
	note d4  $07
	rest $02
	note cs4 $07
	rest $02
	note d4  $07
	rest $02
	note cs4 $07
	rest $06
	vol $4
	note cs4 $07
	rest $07
	vol $6
	note gs3 $0e
	rest $04
	note a3  $07
	rest $06
	vol $3
	note a3  $03
	rest $02
	vol $6
	note d5  $07
	rest $06
	vol $3
	note d5  $07
	rest $07
	vol $2
	note d5  $07
	rest $92
	vol $6
	note a3  $07
	rest $02
	note cs4 $07
	rest $02
	note d4  $07
	rest $06
	vol $3
	note d4  $07
	rest $07
	vol $6
	note gs3 $07
	rest $06
	vol $3
	note gs3 $07
	rest $07
	vol $6
	note gs3 $07
	rest $02
	note cs4 $07
	rest $02
	note d4  $07
	rest $06
	vol $3
	note d4  $03
	rest $02
	vol $6
	note gs3 $07
	rest $06
	vol $3
	note gs3 $07
	rest $07
	vol $2
	note gs3 $07
	rest $02
	vol $6
	note a3  $07
	rest $02
	note cs4 $07
	rest $02
	note d4  $07
	rest $06
	vol $3
	note d4  $07
	rest $07
	vol $6
	note gs3 $07
	rest $02
	note a3  $07
	rest $02
	note as3 $07
	rest $02
	note b3  $07
	rest $02
	note cs4 $07
	rest $02
	note d4  $07
	rest $06
	vol $3
	note d4  $07
	rest $07
	vol $2
	note d4  $07
	rest $02
	vol $6
	note as5 $1c
	rest $08
	note d5  $07
	rest $06
	vol $3
	note d5  $07
	rest $07
	vol $2
	note d5  $07
	rest $02
	vol $6
	note as5 $07
	rest $06
	vol $3
	note as5 $03
	rest $02
	vol $6
	note as5 $07
	rest $06
	vol $3
	note as5 $03
	rest $02
	vol $6
	note d5  $07
	rest $06
	vol $3
	note d5  $07
	rest $07
	vol $2
	note d5  $07
	rest $02
	vol $6
	note as5 $1c
	rest $08
	note d5  $15
	rest $06
	note e5  $07
	rest $02
	note fs5 $24
	vol $3
	note fs5 $12
	rest $12
	goto musicf1383
	cmdff

sound26Channel4:
	cmdf2
musicf14ba:
	duty $0e
	note d3  $09
	rest $1b
	note a3  $09
	rest $1b
	note a2  $09
	rest $1b
	note a3  $09
	rest $1b
	note d3  $09
	rest $1b
	note a3  $09
	rest $1b
	note a2  $09
	rest $1b
	note a3  $09
	rest $1b
	duty $0e
	note g4  $24
	note fs4 $09
	rest $1b
	duty $0e
	note g4  $09
	rest $09
	note g4  $09
	rest $09
	note fs4 $09
	rest $09
	note a3  $04
	note g3  $05
	note fs3 $04
	note e3  $05
	note d3  $24
	note a3  $09
	rest $09
	note a3  $09
	rest $09
	note a2  $09
	rest $1b
	note a3  $09
	rest $1b
	note d3  $24
	note a3  $09
	rest $09
	note a3  $09
	rest $09
	note a2  $09
	rest $09
	note a2  $09
	rest $09
	note d3  $09
	rest $ff
	rest $2a
	duty $0e
	note a2  $04
	note as2 $05
	note b2  $04
	note cs3 $05
	goto musicf14ba
	cmdff

sound18Start:

sound18Channel1:
	cmdf2
	vibrato $00
	env $0 $00
	duty $01
musicf1539:
	vol $6
	note ds4 $21
	vol $4
	note ds4 $0b
	vol $6
	note f4  $21
	vol $4
	note f4  $0b
	vol $6
	note as4 $42
	vol $4
	note as4 $16
	vol $6
	note ds4 $21
	vol $4
	note ds4 $0b
	vol $6
	note f4  $21
	vol $4
	note f4  $0b
	vol $6
	note b4  $42
	vol $4
	note b4  $16
	vol $6
	note ds4 $21
	vol $4
	note ds4 $0b
	vol $6
	note f4  $21
	vol $4
	note f4  $0b
	vol $6
	note cs5 $21
	vol $4
	note cs5 $0b
	vol $6
	note b4  $21
	vol $4
	note b4  $0b
	vol $6
	note gs4 $21
	vol $4
	note gs4 $0b
	vol $6
	note as4 $21
	vol $4
	note as4 $0b
	rest $0e
	vol $4
	note as3 $0b
	note b3  $0b
	vol $4
	note as3 $0b
	note b3  $0b
	note ds4 $0b
	note e4  $0b
	note ds4 $0b
	vol $4
	note e4  $0b
	note as4 $0b
	note b4  $0b
	note ds5 $0b
	note e5  $0b
	note as5 $0b
	note b5  $0b
	note ds6 $08
	vol $6
	note e4  $21
	vol $2
	note e4  $0b
	vol $6
	note fs4 $21
	vol $4
	note fs4 $0b
	vol $6
	note b4  $42
	vol $3
	note b4  $16
	vol $6
	note e4  $21
	vol $4
	note e4  $0b
	vol $6
	note fs4 $21
	vol $4
	note fs4 $0b
	vol $6
	note cs5 $42
	vol $3
	note cs5 $16
	vol $6
	note b4  $21
	vol $4
	note b4  $0b
	vol $6
	note cs5 $21
	vol $4
	note cs5 $0b
	vol $6
	note ds5 $21
	vol $4
	note ds5 $0b
	vol $6
	note fs5 $21
	vol $4
	note fs5 $0b
	vol $6
	note e5  $21
	vol $4
	note e5  $0b
	vol $6
	note a5  $2c
	rest $0b
	vol $4
	note f3  $0b
	note fs3 $0b
	note f3  $0b
	note fs3 $0b
	note as3 $0b
	note b3  $0b
	note as3 $0b
	note b3  $0b
	note f4  $0b
	note fs4 $0b
	note as4 $0b
	note b4  $0b
	note f5  $0b
	note fs5 $0b
	note c6  $0b
	note cs6 $0b
	rest $05
	vol $2
	note cs6 $0b
	rest $06
	vol $1
	note cs6 $0b
	rest $2c
	goto musicf1539
	cmdff

sound18Channel0:
	cmdf2
	vibrato $00
	env $0 $00
	duty $02
musicf1623:
	vol $6
	note as5 $05
	rest $06
	note f5  $05
	vol $2
	note as5 $06
	vol $6
	note ds5 $05
	vol $2
	note f5  $06
	vol $6
	note f5  $05
	vol $2
	note ds5 $06
	vol $6
	note as4 $05
	vol $2
	note f5  $06
	vol $6
	note ds5 $05
	vol $2
	note as4 $06
	vol $6
	note f5  $05
	vol $2
	note ds5 $06
	vol $6
	note ds5 $05
	vol $2
	note f5  $06
	vol $6
	note as5 $05
	vol $2
	note ds5 $06
	vol $6
	note f5  $05
	vol $2
	note as5 $06
	vol $6
	note ds5 $05
	vol $2
	note f5  $06
	vol $6
	note f5  $05
	vol $2
	note ds5 $06
	vol $6
	note as4 $05
	vol $2
	note f5  $06
	vol $6
	note ds5 $05
	vol $2
	note as4 $06
	vol $6
	note f5  $05
	vol $2
	note ds5 $06
	vol $6
	note ds5 $05
	vol $2
	note f5  $06
	vol $6
	note as5 $05
	vol $2
	note ds5 $06
	vol $6
	note f5  $05
	vol $2
	note as5 $06
	vol $6
	note ds5 $05
	vol $2
	note f5  $06
	vol $6
	note f5  $05
	vol $2
	note ds5 $06
	vol $6
	note as4 $05
	vol $2
	note f5  $06
	vol $6
	note ds5 $05
	vol $2
	note as4 $06
	vol $6
	note f5  $05
	vol $2
	note ds5 $06
	vol $6
	note ds5 $05
	vol $2
	note f5  $06
	vol $6
	note b5  $05
	vol $2
	note ds5 $06
	vol $6
	note f5  $05
	vol $2
	note b5  $06
	vol $6
	note ds5 $05
	vol $2
	note f5  $06
	vol $6
	note f5  $05
	vol $2
	note ds5 $06
	vol $6
	note b4  $05
	vol $2
	note f5  $06
	vol $6
	note ds5 $05
	vol $2
	note b4  $06
	vol $6
	note f5  $05
	vol $2
	note ds5 $06
	vol $6
	note ds5 $05
	vol $2
	note f5  $06
	vol $6
	note as5 $05
	vol $2
	note ds5 $06
	vol $6
	note f5  $05
	vol $2
	note as5 $06
	vol $6
	note ds5 $05
	vol $2
	note f5  $06
	vol $6
	note f5  $05
	vol $2
	note ds5 $06
	vol $6
	note as4 $05
	vol $2
	note f5  $06
	vol $6
	note ds5 $05
	vol $2
	note as4 $06
	vol $6
	note f5  $05
	vol $2
	note ds5 $06
	vol $6
	note ds5 $05
	vol $2
	note f5  $06
	vol $6
	note as5 $05
	vol $2
	note ds5 $06
	vol $6
	note f5  $05
	vol $2
	note as5 $06
	vol $6
	note ds5 $05
	vol $2
	note f5  $06
	vol $6
	note f5  $05
	vol $2
	note ds5 $06
	vol $6
	note as4 $05
	vol $2
	note f5  $06
	vol $6
	note ds5 $05
	vol $2
	note as4 $06
	vol $6
	note f5  $05
	vol $2
	note ds5 $06
	vol $6
	note ds5 $05
	vol $2
	note f5  $06
	vol $6
	note as5 $05
	rest $06
	note f5  $05
	vol $2
	note as5 $06
	vol $6
	note ds5 $05
	vol $2
	note f5  $06
	vol $6
	note f5  $05
	vol $2
	note ds5 $06
	vol $6
	note as4 $05
	vol $2
	note f5  $06
	vol $6
	note ds5 $05
	vol $2
	note as4 $06
	vol $6
	note e5  $05
	vol $2
	note ds5 $06
	vol $6
	note ds5 $05
	vol $2
	note e5  $06
	vol $5
	note as3 $0b
	note b3  $0b
	note as3 $0b
	note b3  $0b
	note ds4 $0b
	note e4  $0b
	note ds4 $0b
	note e4  $0b
	note as4 $0b
	note b4  $0b
	note ds5 $0b
	note e5  $0b
	note as5 $0b
	note b5  $0b
	note ds6 $0b
	note e6  $0b
	vol $6
	note b5  $05
	rest $06
	note fs5 $05
	vol $2
	note b5  $06
	vol $6
	note e5  $05
	vol $2
	note fs5 $06
	vol $6
	note fs5 $05
	vol $2
	note e5  $06
	vol $6
	note b4  $05
	vol $2
	note fs5 $06
	vol $6
	note e5  $05
	vol $2
	note b4  $06
	vol $6
	note fs5 $05
	vol $2
	note e5  $06
	vol $6
	note e5  $05
	vol $2
	note fs5 $06
	vol $6
	note b5  $05
	vol $2
	note e5  $06
	vol $6
	note fs5 $05
	vol $2
	note b5  $06
	vol $6
	note e5  $05
	vol $2
	note fs5 $06
	vol $6
	note fs5 $05
	vol $2
	note e5  $06
	vol $6
	note b4  $05
	vol $2
	note fs5 $06
	vol $6
	note e5  $05
	vol $2
	note b4  $06
	vol $6
	note fs5 $05
	vol $2
	note e5  $06
	vol $6
	note e5  $05
	vol $2
	note fs5 $06
	vol $6
	note b5  $05
	vol $2
	note e5  $06
	vol $6
	note fs5 $05
	vol $2
	note b5  $06
	vol $6
	note e5  $05
	vol $2
	note fs5 $06
	vol $6
	note fs5 $05
	vol $2
	note e5  $06
	vol $6
	note b4  $05
	vol $2
	note fs5 $06
	vol $6
	note e5  $05
	vol $2
	note b4  $06
	vol $6
	note fs5 $05
	vol $2
	note e5  $06
	vol $6
	note e5  $05
	vol $2
	note fs5 $06
	vol $6
	note b5  $05
	vol $2
	note e5  $06
	vol $6
	note fs5 $05
	vol $2
	note b5  $06
	vol $6
	note e5  $05
	vol $2
	note fs5 $06
	vol $6
	note fs5 $05
	vol $2
	note e5  $06
	vol $6
	note b4  $05
	vol $2
	note fs5 $06
	vol $6
	note e5  $05
	vol $2
	note b4  $06
	vol $6
	note fs5 $05
	vol $2
	note e5  $06
	vol $6
	note e5  $05
	vol $2
	note fs5 $06
	vol $6
	note cs6 $05
	vol $2
	note e5  $06
	vol $6
	note gs5 $05
	vol $2
	note cs6 $06
	vol $6
	note fs5 $05
	vol $2
	note gs5 $06
	vol $6
	note gs5 $05
	vol $2
	note fs5 $06
	vol $6
	note cs5 $05
	vol $2
	note gs5 $06
	vol $6
	note fs5 $05
	vol $2
	note cs5 $06
	vol $6
	note gs5 $05
	vol $2
	note fs5 $06
	vol $6
	note fs5 $05
	vol $2
	note gs5 $06
	vol $6
	note ds6 $05
	vol $2
	note fs5 $06
	vol $6
	note a5  $05
	vol $2
	note ds6 $06
	vol $6
	note gs5 $05
	vol $2
	note a5  $06
	vol $6
	note a5  $05
	vol $2
	note gs5 $06
	vol $6
	note d5  $05
	vol $2
	note a5  $06
	vol $6
	note gs5 $05
	vol $2
	note d5  $06
	vol $6
	note a5  $05
	vol $2
	note gs5 $06
	vol $6
	note gs5 $05
	vol $2
	note a5  $06
	vol $6
	note e6  $05
	vol $2
	note gs5 $06
	vol $6
	note b5  $05
	vol $2
	note e6  $06
	vol $6
	note a5  $05
	vol $2
	note b5  $06
	vol $6
	note b5  $05
	vol $2
	note a5  $06
	vol $6
	note e5  $05
	vol $2
	note b5  $06
	vol $6
	note a5  $05
	vol $2
	note e5  $06
	vol $6
	note b5  $05
	vol $2
	note a5  $06
	vol $6
	note a5  $05
	vol $2
	note b5  $06
	vol $5
	note f3  $0b
	note fs3 $0b
	note f3  $0b
	note fs3 $0b
	note as3 $0b
	note b3  $0b
	note as3 $0b
	note b3  $0b
	note f4  $0b
	note fs4 $0b
	note as4 $0b
	note b4  $0b
	note f5  $0b
	note fs5 $0b
	note c6  $0b
	note cs6 $0b
	rest $58
	goto musicf1623
	cmdff

sound18Channel4:
musicf1905:
	duty $0e
	note as3 $2c
	note b3  $2c
	note f4  $42
	rest $16
	note as3 $2c
	note b3  $2c
	note fs4 $42
	rest $16
	note as3 $2c
	note b3  $2c
	note gs4 $2c
	note fs4 $2c
	note ds4 $2c
	note e4  $58
	rest $84
	note b3  $2c
	note cs4 $2c
	note e4  $42
	rest $16
	note b3  $2c
	note cs4 $2c
	note g4  $42
	rest $16
	note fs4 $2c
	note gs4 $2c
	note a4  $2c
	note d5  $2c
	note c5  $2c
	note e5  $2c
	note fs5 $58
	rest $b0
	goto musicf1905
	cmdff

sound18Channel6:
musicf1949:
	vol $3
	note $2a $0b
	vol $1
	note $2a $0b
	note $2a $0b
	vol $1
	note $2a $0b
	vol $2
	note $2a $0b
	vol $2
	note $2a $0b
	vol $3
	note $2a $0b
	vol $4
	note $2a $0b
	rest $58
	vol $3
	note $2a $0b
	vol $1
	note $2a $0b
	note $2a $0b
	vol $1
	note $2a $0b
	vol $2
	note $2a $0b
	vol $2
	note $2a $0b
	vol $3
	note $2a $0b
	vol $4
	note $2a $0b
	rest $58
	vol $3
	note $2a $0b
	vol $1
	note $2a $0b
	note $2a $0b
	vol $1
	note $2a $0b
	vol $2
	note $2a $0b
	vol $2
	note $2a $0b
	vol $3
	note $2a $0b
	vol $4
	note $2a $0b
	rest $58
	vol $3
	note $2a $0b
	vol $1
	note $2a $0b
	note $2a $0b
	vol $1
	note $2a $0b
	vol $2
	note $2a $0b
	vol $2
	note $2a $0b
	vol $3
	note $2a $0b
	vol $4
	note $2a $0b
	rest $b0
	vol $3
	note $2a $0b
	vol $1
	note $2a $0b
	note $2a $0b
	vol $1
	note $2a $0b
	vol $2
	note $2a $0b
	vol $2
	note $2a $0b
	vol $3
	note $2a $0b
	vol $4
	note $2a $0b
	rest $58
	vol $3
	note $2a $0b
	vol $1
	note $2a $0b
	note $2a $0b
	vol $1
	note $2a $0b
	vol $2
	note $2a $0b
	vol $2
	note $2a $0b
	vol $3
	note $2a $0b
	vol $4
	note $2a $0b
	rest $58
	vol $3
	note $2a $0b
	vol $1
	note $2a $0b
	note $2a $0b
	vol $1
	note $2a $0b
	vol $2
	note $2a $0b
	vol $2
	note $2a $0b
	vol $3
	note $2a $0b
	vol $4
	note $2a $0b
	rest $58
	vol $3
	note $2a $0b
	vol $1
	note $2a $0b
	note $2a $0b
	vol $1
	note $2a $0b
	vol $2
	note $2a $0b
	vol $2
	note $2a $0b
	vol $3
	note $2a $0b
	vol $4
	note $2a $0b
	rest $b0
	vol $3
	note $2a $0b
	vol $1
	note $2a $0b
	note $2a $0b
	vol $1
	note $2a $0b
	vol $2
	note $2a $0b
	vol $2
	note $2a $0b
	vol $3
	note $2a $0b
	vol $4
	note $2a $0b
	goto musicf1949
	cmdff

sound16Start:

sound16Channel1:
	vibrato $e1
	env $0 $00
	duty $02
musicf1a32:
	vol $0
	note gs3 $16
	vol $6
	note ds4 $16
	note fs4 $16
	note gs4 $16
	note as4 $16
	note gs4 $16
	note fs4 $16
	note f4  $16
	note as4 $16
	note gs4 $16
	note fs4 $16
	note f4  $16
	note fs4 $16
	note ds4 $16
	note gs4 $16
	note as4 $16
	note b4  $2c
	vibrato $01
	vol $3
	note b4  $16
	vibrato $e1
	vol $6
	note as4 $16
	note gs4 $2c
	vibrato $01
	vol $3
	note gs4 $16
	vibrato $e1
	vol $6
	note fs4 $16
	note gs4 $2c
	note fs4 $16
	note gs4 $16
	note as4 $2c
	vibrato $01
	vol $3
	note as4 $2c
	vibrato $e1
	vol $6
	note b4  $2c
	note cs5 $16
	note ds5 $0b
	note b4  $0b
	note as4 $2c
	vibrato $01
	vol $3
	note as4 $16
	vibrato $e1
	vol $6
	note as4 $16
	note gs4 $2c
	note f4  $16
	note gs4 $16
	note as4 $16
	vol $3
	note as4 $16
	rest $16
	vol $6
	note as4 $16
	note b4  $16
	note as4 $16
	note b4  $16
	note as4 $16
	note b4  $16
	note as4 $16
	note b4  $16
	note as4 $16
	note as3 $0b
	note c4  $0b
	note d4  $0b
	note ds4 $0b
	note f4  $0b
	note ds4 $0b
	note d4  $0b
	note c4  $0b
	note as3 $0b
	rest $05
	vol $3
	note as3 $0b
	rest $06
	vol $1
	note as3 $0b
	rest $2c
	vol $6
	note as4 $16
	note gs4 $16
	note fs4 $16
	note f4  $16
	note fs4 $16
	note ds4 $16
	note gs4 $16
	note as4 $16
	note b4  $16
	note as4 $16
	note gs4 $16
	note fs4 $16
	note gs4 $16
	note f4  $16
	note gs4 $16
	note as4 $16
	note cs5 $0b
	note b4  $0b
	note as4 $0b
	note gs4 $0b
	note as4 $0b
	note gs4 $0b
	note fs4 $0b
	note gs4 $0b
	note fs4 $0b
	note f4  $0b
	note ds4 $0b
	note f4  $0b
	note d4  $0b
	note ds4 $0b
	note f4  $0b
	note fs4 $0b
	note gs4 $2c
	note as4 $16
	note b4  $16
	note as4 $2c
	vibrato $01
	vol $3
	note as4 $2b
	rest $01
	vibrato $e1
	goto musicf1a32
	cmdff

sound16Channel0:
	vibrato $e1
	env $0 $00
	duty $02
musicf1b2a:
	vol $0
	note gs3 $16
	vol $6
	note as3 $16
	note ds4 $16
	note f4  $16
	note fs4 $16
	note f4  $16
	note ds4 $16
	note d4  $16
	note fs4 $16
	note f4  $16
	note ds4 $16
	note d4  $16
	note ds4 $16
	note as3 $16
	note ds4 $16
	note fs4 $16
	note gs4 $2c
	vibrato $01
	vol $3
	note gs4 $16
	vibrato $e1
	vol $6
	note fs4 $16
	note f4  $2c
	vibrato $01
	vol $3
	note f4  $16
	vibrato $e1
	vol $6
	note ds4 $16
	note f4  $0b
	rest $05
	vol $3
	note f4  $0b
	rest $06
	vol $1
	note f4  $0b
	vol $6
	note ds4 $0b
	rest $05
	vol $3
	note ds4 $0b
	rest $06
	vol $1
	note ds4 $0b
	vol $6
	note d4  $0b
	note c4  $0b
	note as3 $0b
	note a3  $0b
	note as3 $0b
	note c4  $0b
	note d4  $0b
	note f4  $0b
	note gs3 $0b
	rest $05
	vol $3
	note gs3 $06
	vol $6
	note b3  $0b
	rest $05
	vol $3
	note b3  $06
	vol $6
	note gs3 $0b
	rest $05
	vol $3
	note gs3 $06
	vol $6
	note b3  $0b
	rest $05
	vol $3
	note b3  $06
	vol $6
	note as3 $0b
	note b3  $0b
	note as3 $0b
	note a3  $0b
	note as3 $0b
	note d4  $0b
	note f4  $0b
	note as4 $0b
	note f4  $0b
	rest $05
	vol $3
	note f4  $06
	vol $6
	note ds4 $0b
	rest $05
	vol $3
	note ds4 $06
	vol $6
	note d4  $0b
	rest $05
	vol $3
	note d4  $06
	vol $6
	note c4  $0b
	rest $05
	vol $3
	note c4  $06
	vol $6
	note as3 $0b
	note b3  $0b
	note as3 $0b
	note b3  $0b
	note as3 $0b
	note d4  $0b
	note f4  $0b
	note as4 $0b
	note gs4 $0b
	note g4  $0b
	note fs4 $0b
	note g4  $0b
	note gs4 $0b
	note g4  $0b
	note fs4 $0b
	note g4  $0b
	note gs4 $0b
	note g4  $0b
	note fs4 $0b
	note f4  $0b
	note e4  $0b
	note ds4 $0b
	note d4  $0b
	note cs4 $0b
	note d4  $0b
	note ds4 $0b
	note f4  $0b
	note fs4 $0b
	note gs4 $0b
	note fs4 $0b
	note f4  $0b
	note ds4 $0b
	note d4  $0b
	note f4  $0b
	note gs4 $0b
	note b4  $0b
	note as4 $0b
	rest $05
	vol $3
	note as4 $0b
	rest $06
	vol $1
	note as4 $0b
	vol $6
	note fs4 $16
	note f4  $16
	note ds4 $16
	note d4  $16
	note ds4 $0b
	rest $05
	vol $3
	note ds4 $06
	vol $6
	note as3 $0b
	rest $05
	vol $3
	note as3 $06
	vol $6
	note ds4 $0b
	rest $05
	vol $3
	note ds4 $06
	vol $6
	note as3 $0b
	rest $05
	vol $3
	note as3 $06
	vol $6
	note gs4 $16
	note fs4 $16
	note f4  $16
	note ds4 $16
	note f4  $0b
	rest $05
	vol $3
	note f4  $06
	vol $6
	note d4  $0b
	rest $05
	vol $3
	note d4  $06
	vol $6
	note f4  $0b
	rest $05
	vol $3
	note f4  $06
	vol $6
	note d4  $0b
	rest $05
	vol $3
	note d4  $06
	vol $6
	note f3  $42
	note fs3 $16
	note gs3 $16
	note as3 $16
	note b3  $16
	note c4  $16
	note cs4 $16
	note d4  $16
	note ds4 $2c
	note d4  $16
	note c4  $16
	note as3 $2c
	goto musicf1b2a
	cmdff

sound16Channel4:
musicf1c9f:
	duty $0e
	note ds2 $2c
	note e2  $2c
	note ds2 $2c
	note e2  $2c
	note ds2 $2c
	note e2  $2c
	note ds2 $2c
	note e2  $2c
	note f2  $42
	note ds2 $16
	note d2  $42
	note c2  $16
	note as1 $16
	rest $16
	note f2  $16
	rest $16
	note as2 $16
	note a2  $03
	note gs2 $03
	note g2  $05
	note fs2 $03
	note f2  $03
	note e2  $05
	note as1 $0e
	rest $1e
	note gs2 $2c
	note a2  $2c
	note as2 $16
	note as1 $0b
	note b1  $0b
	note as1 $0b
	note b1  $0b
	note as1 $0b
	rest $0b
	note f2  $37
	note ds2 $0b
	note d2  $0b
	note b1  $0b
	note as1 $0e
	rest $08
	note f2  $0b
	note a2  $0b
	note as2 $0e
	rest $1e
	note e2  $16
	note ds2 $16
	note d2  $16
	note ds2 $16
	note e2  $16
	note ds2 $16
	note e2  $16
	note ds2 $16
	note as2 $2c
	note a2  $03
	note gs2 $03
	note g2  $05
	note fs2 $03
	note f2  $03
	note e2  $05
	note ds2 $03
	note d2  $03
	note cs2 $05
	note c2  $03
	note b1  $08
	note as1 $16
	rest $16
	note as1 $16
	rest $16
	note ds2 $0b
	rest $0b
	note ds2 $21
	rest $0b
	note ds2 $1b
	rest $06
	note ds2 $0b
	note fs2 $0b
	note gs2 $0b
	note as2 $0b
	note gs2 $0b
	note fs2 $0b
	note ds2 $0b
	note f2  $0b
	rest $0b
	note f2  $21
	rest $0b
	note f2  $1b
	rest $06
	note f2  $0b
	note fs2 $0b
	note gs2 $0b
	note as2 $0b
	note gs2 $0b
	note fs2 $0b
	note f2  $0b
	note as1 $0b
	note ds2 $0b
	note f2  $0b
	note gs2 $0b
	note as2 $0b
	note gs2 $0b
	note f2  $0b
	note ds2 $0b
	note as1 $0b
	note d2  $0b
	note f2  $0b
	note gs2 $0b
	note as2 $0b
	note gs2 $0b
	note f2  $0b
	note d2  $0b
	note as1 $0b
	note d2  $0b
	note f2  $0b
	note gs2 $0b
	note as2 $0b
	note b2  $0b
	note as2 $0b
	note b2  $0b
	note as2 $0b
	note b2  $0b
	note as2 $0b
	note b2  $0b
	note as2 $0b
	note f2  $0b
	note d2  $0b
	note as1 $0b
	goto musicf1c9f
	cmdff

sound16Channel6:
musicf1da1:
	vol $6
	note $24 $16
	vol $4
	note $2e $16
	rest $16
	note $2a $16
	vol $6
	note $24 $16
	vol $4
	note $2e $16
	rest $16
	vol $4
	note $2a $16
	vol $6
	note $24 $16
	vol $4
	note $2e $16
	rest $16
	note $2a $16
	vol $6
	note $24 $16
	vol $4
	note $2e $16
	rest $16
	vol $4
	note $2a $16
	vol $4
	note $2e $0b
	rest $0b
	note $2a $0b
	note $2a $0b
	note $2a $0b
	rest $21
	note $2e $0b
	rest $0b
	vol $4
	note $2a $0b
	vol $4
	note $2a $0b
	note $2a $0b
	rest $21
	vol $6
	note $24 $16
	vol $4
	note $2e $16
	rest $16
	note $2a $16
	vol $6
	note $24 $16
	vol $4
	note $2e $16
	rest $16
	vol $4
	note $2a $16
	vol $6
	note $24 $16
	vol $4
	note $2e $16
	note $2a $16
	note $2e $16
	vol $6
	note $24 $16
	vol $4
	note $2e $16
	note $2a $16
	vol $4
	note $2e $16
	vol $6
	note $24 $16
	vol $4
	note $2e $16
	note $2a $16
	note $2e $16
	vol $6
	note $24 $16
	vol $4
	note $2e $16
	note $2a $16
	vol $4
	note $2e $16
	vol $4
	note $2e $16
	note $2a $16
	note $2e $16
	note $2a $16
	note $2e $16
	note $2a $16
	note $2e $16
	vol $4
	note $2a $16
	vol $4
	note $2e $16
	rest $42
	vol $6
	note $24 $16
	vol $4
	note $2a $16
	vol $4
	note $2e $16
	rest $16
	vol $6
	note $24 $0b
	vol $4
	note $2a $0b
	note $2e $16
	rest $0b
	note $2a $0b
	note $2e $16
	vol $6
	note $24 $0b
	vol $4
	note $2a $0b
	note $2e $16
	rest $0b
	note $2a $0b
	vol $4
	note $2e $16
	vol $6
	note $24 $0b
	vol $4
	note $2a $0b
	note $2e $16
	rest $0b
	note $2a $0b
	note $2e $16
	vol $6
	note $24 $0b
	vol $4
	note $2a $0b
	note $2e $16
	rest $0b
	note $2a $0b
	vol $4
	note $2e $16
	vol $6
	note $24 $0b
	vol $4
	note $2a $0b
	note $2e $16
	vol $6
	note $24 $0b
	vol $4
	note $2a $0b
	note $2e $16
	vol $6
	note $24 $0b
	vol $4
	note $2a $0b
	note $2e $16
	vol $6
	note $24 $0b
	vol $4
	note $2a $0b
	vol $4
	note $2e $16
	vol $6
	note $24 $0b
	vol $4
	note $2a $0b
	note $2e $16
	vol $6
	note $24 $0b
	vol $4
	note $2a $0b
	note $2e $16
	note $2a $0b
	note $2a $0b
	note $2e $0b
	rest $0b
	note $2a $0b
	note $2a $0b
	vol $4
	note $2e $0b
	rest $0b
	goto musicf1da1
	cmdff

sound28Start:

sound28Channel1:
	cmdf2
	vibrato $e1
	env $0 $00
	duty $02
musicf1ece:
	vol $6
	note gs3 $24
	note g3  $24
	note b3  $36
	note as3 $12
	note gs3 $12
	note g3  $12
	note b3  $12
	note as3 $12
	note gs3 $12
	note g3  $12
	note b3  $12
	note as3 $12
	note ds4 $24
	note d4  $24
	note fs4 $36
	note f4  $12
	note ds4 $12
	note d4  $12
	note fs4 $12
	note f4  $12
	note ds4 $12
	note d4  $12
	note as4 $12
	note gs4 $12
	note as4 $24
	note a4  $24
	note cs5 $36
	note c5  $12
	note as4 $12
	note a4  $12
	note cs5 $12
	note c5  $12
	note as4 $12
	note a4  $12
	note f5  $12
	note e5  $12
	note f5  $36
	note fs5 $12
	note e5  $12
	note fs5 $12
	note f5  $12
	note e5  $12
	note f5  $28
	rest $0e
	note f5  $04
	rest $01
	note a5  $05
	rest $03
	note c6  $05
	vol $5
	note f6  $04
	rest $05
	vol $4
	note f6  $04
	rest $05
	vol $3
	note f6  $04
	rest $05
	vol $2
	note f6  $04
	rest $29
	vol $6
	note as3 $1b
	note f4  $09
	note e4  $1b
	rest $09
	note as3 $1b
	note ds4 $09
	note cs4 $1b
	rest $09
	note as3 $1b
	note f4  $09
	note e4  $1b
	note as3 $04
	rest $05
	note as3 $1b
	note ds4 $09
	note cs4 $1b
	rest $09
	note f4  $12
	note e4  $12
	note f4  $12
	note gs4 $24
	note g4  $12
	note f4  $12
	note e4  $12
	note f4  $6c
	rest $24
	goto musicf1ece
	cmdff

sound28Channel0:
	cmdf2
	vibrato $e1
	env $0 $00
	duty $02
musicf1f85:
	vol $6
	note e3  $24
	vol $6
	note ds3 $24
	note g3  $36
	note fs3 $12
	note e3  $12
	note ds3 $12
	note g3  $12
	note fs3 $12
	note e3  $12
	note ds3 $12
	note g3  $12
	note fs3 $12
	note b3  $24
	note as3 $24
	note ds4 $36
	note d4  $12
	note c4  $12
	note b3  $12
	note ds4 $12
	note d4  $12
	note gs3 $12
	note g3  $12
	note d4  $12
	note cs4 $12
	note d4  $24
	note cs4 $24
	note g4  $36
	note fs4 $12
	note e4  $12
	note ds4 $12
	note g4  $12
	note fs4 $12
	note e4  $12
	note ds4 $12
	note cs5 $12
	note c5  $12
	vol $6
	note c4  $09
	note cs4 $09
	note b3  $09
	note c4  $09
	note cs4 $09
	note b3  $09
	note cs4 $09
	note c4  $09
	note c4  $12
	note cs4 $12
	note c4  $12
	note b3  $12
	note e3  $09
	note f3  $09
	note b3  $09
	note c4  $09
	note e4  $09
	note f4  $09
	note b4  $09
	note c5  $09
	note e5  $09
	note f5  $09
	note b4  $09
	note c5  $09
	note ds5 $04
	note cs5 $05
	note b4  $04
	note a4  $05
	note gs4 $04
	note fs4 $05
	note ds4 $04
	note d4  $05
	vol $6
	note f3  $09
	vol $6
	note as3 $09
	vol $6
	note f3  $09
	note cs4 $09
	note c4  $12
	note f3  $09
	vol $6
	note b3  $09
	vol $6
	note f3  $09
	vol $6
	note as3 $09
	vol $6
	note f3  $09
	note c4  $09
	note as3 $12
	note f3  $09
	vol $6
	note e3  $09
	vol $6
	note f3  $09
	vol $6
	note as3 $09
	vol $6
	note f3  $09
	note cs4 $09
	note c4  $12
	note f3  $09
	note e3  $09
	note f3  $12
	note e3  $09
	note b3  $09
	note as3 $1b
	rest $09
	note cs4 $12
	note c4  $12
	note cs4 $12
	note cs5 $04
	note d5  $05
	note ds5 $04
	note e5  $05
	note f5  $12
	note e5  $12
	note d5  $12
	note e5  $15
	rest $01
	note e5  $05
	note f5  $04
	note c5  $05
	note cs5 $04
	note a4  $05
	note as4 $04
	note e4  $05
	note f4  $04
	note c4  $05
	note cs4 $04
	note a3  $05
	note as3 $04
	note e3  $05
	note f3  $04
	note e3  $05
	note f3  $09
	note e3  $03
	rest $03
	vol $5
	note e3  $03
	vol $6
	note as3 $09
	note a3  $03
	rest $03
	vol $4
	note a3  $03
	vol $6
	note cs4 $09
	note c4  $03
	rest $03
	vol $4
	note c4  $03
	vol $6
	note fs4 $09
	note f4  $03
	rest $03
	vol $4
	note f4  $03
	goto musicf1f85
	cmdff

sound28Channel4:
musicf20b0:
	duty $18
	note cs2 $09
	duty $0f
	note cs2 $09
	duty $18
	note cs2 $09
	duty $0f
	note cs2 $09
	rest $5a
	duty $18
	note cs2 $04
	rest $05
	note cs2 $04
	rest $05
	note cs2 $09
	duty $0f
	note cs2 $09
	duty $18
	note cs2 $09
	duty $0f
	note cs2 $09
	rest $5a
	duty $18
	note cs2 $04
	rest $05
	note cs2 $04
	rest $05
	note cs2 $09
	duty $0f
	note cs2 $09
	duty $18
	note cs2 $09
	duty $0f
	note cs2 $09
	rest $5a
	duty $18
	note cs2 $04
	rest $05
	note cs2 $04
	rest $05
	note cs2 $09
	duty $0f
	note cs2 $09
	duty $18
	note cs2 $09
	duty $0f
	note cs2 $09
	rest $5a
	duty $18
	note cs2 $04
	rest $05
	note cs2 $04
	rest $05
	note cs2 $09
	duty $0f
	note cs2 $09
	duty $18
	note cs2 $09
	duty $0f
	note cs2 $09
	rest $5a
	duty $18
	note cs2 $04
	rest $05
	note cs2 $04
	rest $05
	note cs2 $09
	duty $0f
	note cs2 $09
	duty $18
	note cs2 $09
	duty $0f
	note cs2 $09
	rest $5a
	duty $18
	note cs2 $04
	rest $05
	note cs2 $04
	rest $05
	vol $8
	note f1  $04
	rest $05
	note f1  $04
	rest $05
	note f1  $04
	rest $05
	note f1  $04
	rest $05
	duty $18
	note gs1 $09
	vol $8
	note f1  $04
	rest $05
	note f1  $04
	rest $05
	note f1  $04
	rest $05
	duty $18
	note a1  $09
	vol $8
	note f1  $04
	rest $05
	note f1  $04
	rest $05
	note f1  $04
	rest $05
	duty $18
	note b1  $09
	vol $8
	note f1  $04
	rest $05
	note f1  $04
	rest $05
	note f1  $04
	rest $05
	note f1  $04
	rest $05
	note f1  $04
	rest $05
	note f1  $04
	rest $05
	note f1  $04
	rest $05
	duty $18
	note gs1 $09
	vol $8
	note f1  $04
	rest $05
	note f1  $04
	rest $05
	note f1  $04
	rest $05
	duty $18
	note a1  $09
	vol $8
	note f1  $04
	rest $05
	note f1  $04
	rest $05
	note f1  $04
	rest $05
	duty $18
	note b1  $09
	vol $8
	note f1  $04
	rest $05
	duty $18
	note c2  $09
	vol $8
	note f1  $04
	rest $05
	duty $18
	note as1 $09
	duty $0f
	note as1 $09
	duty $18
	note as1 $09
	duty $0f
	note as1 $09
	rest $24
	duty $18
	note as1 $09
	duty $0f
	note as1 $09
	duty $18
	note as1 $09
	duty $0f
	note as1 $09
	rest $12
	duty $18
	note as1 $04
	rest $05
	note as1 $04
	rest $05
	note as1 $09
	duty $0f
	note as1 $09
	duty $18
	note as1 $09
	duty $0f
	note as1 $09
	rest $24
	duty $18
	note as1 $09
	duty $0f
	note as1 $09
	duty $18
	note as1 $09
	duty $0f
	note as1 $09
	rest $12
	duty $18
	note as1 $04
	rest $05
	note as1 $04
	rest $05
	note c1  $09
	duty $0f
	note c1  $09
	duty $18
	note c1  $09
	duty $0f
	note c1  $09
	rest $24
	duty $18
	note c2  $09
	duty $0f
	note c2  $09
	duty $18
	note c2  $09
	duty $0f
	note c2  $09
	rest $24
	duty $18
	note f2  $12
	duty $0f
	note f2  $12
	duty $18
	note f2  $12
	duty $0f
	note f2  $12
	duty $18
	note f2  $09
	duty $0f
	note f2  $09
	duty $18
	note f2  $09
	duty $0f
	note f2  $09
	duty $18
	note f2  $09
	duty $0f
	note f2  $09
	duty $18
	note f2  $09
	duty $0f
	note f2  $09
	goto musicf20b0
	cmdff

sound28Channel6:
musicf2286:
	vol $6
	note $24 $12
	note $24 $12
	rest $5a
	note $24 $09
	note $24 $09
	note $24 $12
	note $24 $12
	rest $5a
	note $24 $09
	note $24 $09
	note $24 $12
	note $24 $12
	rest $5a
	note $24 $09
	note $24 $09
	note $24 $12
	note $24 $12
	rest $5a
	note $24 $09
	note $24 $09
	note $24 $12
	note $24 $12
	rest $5a
	note $24 $09
	note $24 $09
	note $24 $12
	note $24 $12
	rest $5a
	note $24 $09
	note $24 $09
	note $24 $24
	note $24 $24
	note $24 $24
	note $24 $24
	note $24 $09
	vol $2
	note $2e $09
	rest $09
	vol $2
	note $2e $09
	vol $6
	note $24 $09
	vol $2
	note $2e $09
	rest $09
	vol $2
	note $2e $09
	vol $6
	note $24 $09
	vol $3
	note $2e $09
	rest $09
	vol $3
	note $2e $09
	vol $6
	note $24 $09
	vol $3
	note $2e $09
	rest $09
	vol $3
	note $2e $09
	vol $6
	note $24 $09
	rest $09
	vol $3
	note $2e $09
	rest $09
	vol $6
	note $24 $09
	rest $09
	vol $3
	note $2e $09
	rest $09
	vol $6
	note $24 $09
	rest $09
	vol $3
	note $2e $09
	rest $09
	vol $6
	note $24 $09
	rest $09
	vol $3
	note $2e $09
	vol $6
	note $24 $09
	note $24 $09
	rest $09
	vol $3
	note $2e $09
	rest $09
	vol $6
	note $24 $09
	rest $09
	vol $3
	note $2e $09
	rest $09
	vol $6
	note $24 $09
	rest $09
	vol $3
	note $2e $09
	rest $09
	vol $6
	note $24 $09
	rest $09
	vol $3
	note $2e $09
	vol $6
	note $24 $09
	note $24 $09
	rest $09
	vol $3
	note $2e $09
	rest $09
	vol $6
	note $24 $09
	rest $09
	vol $3
	note $2e $09
	rest $09
	vol $6
	note $24 $09
	rest $09
	vol $3
	note $2e $09
	rest $09
	vol $6
	note $24 $09
	rest $09
	vol $3
	note $2e $09
	vol $6
	note $24 $09
	note $24 $09
	rest $09
	vol $3
	note $2e $09
	rest $09
	vol $6
	note $24 $09
	rest $09
	vol $3
	note $2e $09
	rest $09
	vol $6
	note $24 $09
	vol $3
	note $2e $09
	rest $09
	note $2e $09
	vol $6
	note $24 $09
	vol $3
	note $2e $09
	rest $09
	note $2e $09
	goto musicf2286
	cmdff

sound30Start:

sound30Channel1:
	cmdf2
	vibrato $e1
	env $0 $00
	duty $02
musicf23a1:
	vol $6
	note b5  $1c
	vol $6
	note as5 $12
	note b5  $0a
	note e5  $1c
	note ds5 $12
	note e5  $0a
	note as5 $1c
	note a5  $12
	note as5 $0a
	note fs5 $1c
	note f5  $12
	note fs5 $0a
	note b5  $1c
	note as5 $12
	note b5  $0a
	note e6  $12
	note b5  $0a
	note a5  $12
	note gs5 $0a
	note f5  $2e
	note b4  $05
	rest $02
	vol $5
	note b4  $05
	rest $02
	vol $3
	note b4  $05
	vol $6
	note b4  $09
	note f5  $0a
	note b5  $04
	rest $03
	vol $5
	note b5  $04
	rest $03
	vol $3
	note b5  $04
	rest $03
	vol $3
	note b5  $04
	rest $03
	vol $6
	note b5  $1c
	note as5 $12
	note b5  $0a
	note e5  $0e
	rest $04
	note e5  $0a
	note ds5 $12
	note e5  $0a
	note cs6 $1c
	note c6  $12
	note cs6 $0a
	note fs5 $0e
	rest $04
	note fs5 $0a
	note f5  $12
	note fs5 $0a
	note ds6 $1c
	vol $6
	note cs6 $09
	note ds6 $09
	note cs6 $0a
	note b5  $04
	rest $03
	vol $5
	note b5  $04
	rest $03
	vol $3
	note b5  $04
	rest $0a
	vol $7
	note f5  $04
	rest $03
	vol $5
	note f5  $04
	rest $03
	vol $3
	note f5  $04
	rest $0a
	vol $7
	note b4  $25
	note ds5 $09
	note g5  $0a
	vol $6
	note b5  $04
	rest $03
	vol $5
	note b5  $04
	rest $03
	vol $4
	note b5  $04
	rest $03
	vol $3
	note b5  $04
	rest $03
	vol $2
	note b5  $04
	rest $18
	goto musicf23a1
	cmdff

sound30Channel0:
	cmdf2
	vibrato $e1
	env $0 $00
	duty $02
musicf2461:
	vol $6
	note gs5 $09
	note g5  $09
	note gs5 $0a
	note g5  $12
	note gs5 $0a
	note e6  $04
	rest $05
	vol $5
	note e6  $05
	rest $04
	vol $3
	note e6  $05
	rest $21
	vol $6
	note fs5 $09
	note f5  $09
	note fs5 $0a
	note f5  $12
	note fs5 $0a
	note ds5 $04
	rest $05
	vol $4
	note ds5 $05
	rest $04
	vol $3
	note ds5 $05
	rest $21
	vol $6
	note gs5 $09
	vol $6
	note g5  $09
	note gs5 $0a
	note g5  $12
	vol $6
	note gs5 $0a
	note b5  $04
	rest $05
	vol $5
	note b5  $05
	rest $04
	vol $4
	note b5  $05
	rest $2a
	vol $6
	note b4  $09
	note ds5 $0a
	vol $6
	note g5  $09
	note b5  $09
	note ds6 $0a
	note g6  $04
	rest $03
	vol $5
	note g6  $04
	rest $03
	vol $4
	note g6  $04
	rest $26
	vol $8
	note gs5 $09
	vol $6
	note g5  $09
	note gs5 $0a
	vol $7
	note g5  $12
	vol $6
	note gs5 $0a
	vol $6
	note e5  $02
	rest $02
	vol $5
	note e5  $03
	rest $02
	vol $4
	note e5  $02
	rest $03
	vol $3
	note e5  $02
	rest $02
	vol $6
	note as5 $0a
	note b5  $04
	rest $03
	vol $5
	note b5  $04
	rest $03
	vol $3
	note b5  $04
	rest $0a
	vol $6
	note as5 $09
	note a5  $09
	note as5 $0a
	note a5  $12
	note as5 $0a
	vol $6
	note fs5 $02
	rest $02
	vol $5
	note fs5 $03
	rest $02
	vol $4
	note fs5 $02
	rest $03
	vol $3
	note fs5 $02
	rest $02
	vol $6
	note c6  $0a
	note cs6 $04
	rest $03
	vol $5
	note cs6 $04
	rest $03
	vol $4
	note cs6 $04
	rest $03
	vol $3
	note cs6 $04
	rest $03
	vol $6
	note b5  $04
	rest $03
	vol $5
	note b5  $04
	rest $03
	vol $4
	note b5  $04
	rest $03
	vol $3
	note b5  $02
	rest $05
	vol $6
	note as5 $09
	note b5  $09
	note as5 $0a
	vol $6
	note g5  $04
	rest $03
	vol $5
	note g5  $04
	rest $03
	vol $4
	note g5  $04
	rest $0a
	vol $7
	note fs5 $04
	rest $03
	vol $5
	note fs5 $04
	rest $03
	vol $3
	note fs5 $04
	rest $0a
	vol $7
	note as4 $04
	rest $03
	vol $5
	note as4 $04
	rest $03
	vol $3
	note as4 $04
	rest $03
	vol $2
	note as4 $04
	rest $03
	vol $6
	note fs4 $04
	rest $05
	note b4  $05
	rest $04
	note ds5 $05
	rest $0e
	note ds6 $05
	rest $04
	note g6  $05
	rest $05
	note b6  $04
	rest $03
	vol $5
	note b6  $04
	rest $03
	vol $4
	note b6  $04
	rest $03
	vol $3
	note b6  $04
	rest $03
	goto musicf2461
	cmdff

sound30Channel4:
musicf25a9:
	duty $18
	note e3  $07
	duty $2b
	note e3  $07
	rest $2a
	duty $18
	note b2  $07
	duty $2b
	note b2  $07
	rest $2a
	duty $18
	note fs3 $07
	duty $2b
	note fs3 $07
	rest $2a
	duty $18
	note b3  $07
	duty $2b
	note b3  $07
	rest $2a
	duty $18
	note e3  $07
	duty $2b
	note e3  $07
	rest $2a
	duty $18
	note b2  $07
	duty $2b
	note b2  $07
	rest $2a
	duty $18
	note c3  $2e
	note b2  $0a
	duty $2b
	note b2  $09
	rest $2f
	duty $18
	note e3  $07
	duty $2b
	note e3  $07
	rest $2a
	duty $18
	note b2  $07
	duty $2b
	note b2  $07
	rest $2a
	duty $18
	note fs3 $07
	duty $2b
	note fs3 $07
	rest $2a
	duty $18
	note cs3 $07
	duty $2b
	note cs3 $07
	rest $2a
	duty $18
	note b3  $07
	duty $2b
	note b3  $07
	rest $0e
	duty $18
	note fs3 $07
	duty $2b
	note fs3 $07
	rest $0e
	duty $18
	note b2  $07
	duty $2b
	note b2  $07
	rest $0e
	duty $18
	note f2  $07
	duty $2b
	note f2  $07
	rest $0e
	duty $18
	note b2  $07
	duty $2b
	note b2  $07
	rest $46
	duty $18
	note b2  $07
	duty $2b
	note b2  $07
	rest $0e
	goto musicf25a9
	cmdff

sound30Channel6:
musicf2659:
	vol $6
	note $24 $09
	rest $09
	vol $3
	note $2a $0a
	note $2e $09
	rest $09
	vol $3
	note $2a $0a
	vol $6
	note $24 $09
	rest $09
	vol $3
	note $2a $0a
	note $2e $09
	rest $13
	vol $6
	note $24 $09
	rest $09
	vol $3
	note $2a $0a
	note $2e $09
	rest $09
	vol $3
	note $2a $0a
	vol $6
	note $24 $09
	rest $09
	vol $3
	note $2a $0a
	note $2e $09
	rest $13
	vol $6
	note $24 $09
	rest $09
	vol $3
	note $2a $0a
	note $2e $09
	rest $09
	vol $3
	note $2a $0a
	vol $6
	note $24 $09
	rest $09
	vol $3
	note $2a $0a
	note $2e $09
	rest $13
	vol $6
	note $24 $09
	rest $09
	vol $3
	note $2a $0a
	note $2e $09
	rest $09
	vol $3
	note $2a $0a
	vol $6
	note $24 $09
	rest $09
	vol $3
	note $2a $0a
	note $2e $09
	rest $13
	vol $6
	note $24 $09
	rest $09
	vol $3
	note $2a $0a
	note $2e $09
	rest $09
	vol $3
	note $2a $0a
	vol $6
	note $24 $09
	rest $09
	vol $3
	note $2a $0a
	note $2e $09
	rest $13
	vol $6
	note $24 $09
	rest $09
	vol $3
	note $2a $0a
	note $2e $09
	rest $09
	vol $3
	note $2a $0a
	vol $6
	note $24 $09
	rest $09
	vol $3
	note $2a $0a
	note $2e $09
	rest $13
	vol $6
	note $24 $09
	rest $09
	vol $3
	note $2a $0a
	note $2e $09
	rest $09
	vol $3
	note $2a $0a
	vol $6
	note $24 $09
	rest $09
	vol $3
	note $2a $0a
	note $2e $09
	rest $13
	vol $6
	note $24 $09
	rest $09
	vol $3
	note $2a $0a
	note $2e $09
	rest $09
	vol $3
	note $2a $0a
	vol $6
	note $24 $09
	rest $09
	vol $3
	note $2a $0a
	note $2e $09
	rest $13
	goto musicf2659
	cmdff

sound35Start:

sound35Channel1:
	vibrato $e1
	env $0 $00
	duty $01
	vol $6
	note ds4 $04
	note as3 $05
	note ds4 $05
	note gs4 $04
	note cs4 $05
	note gs4 $05
	note cs5 $04
	note fs4 $05
	note cs5 $05
	note fs5 $04
	note b4  $05
	note fs5 $05
	note f5  $1c
	vibrato $01
	vol $3
	note f5  $07
	rest $15
	vibrato $e1
musicf275f:
	vol $6
	note ds4 $07
	rest $03
	vol $3
	note ds4 $04
	vol $6
	note ds4 $03
	vol $3
	note ds4 $04
	vol $6
	note ds4 $03
	vol $3
	note ds4 $04
	vol $6
	note as4 $11
	vol $3
	note as4 $07
	rest $04
	vol $6
	note a4  $07
	rest $03
	vol $3
	note a4  $04
	vol $6
	note a4  $07
	note fs4 $07
	note d4  $07
	rest $03
	vol $3
	note d4  $04
	vol $6
	note a4  $07
	rest $03
	vol $3
	note a4  $04
	vol $6
	note ds4 $07
	rest $03
	vol $3
	note ds4 $04
	vol $6
	note ds4 $03
	vol $3
	note ds4 $04
	vol $6
	note ds4 $03
	vol $3
	note ds4 $04
	vol $6
	note as4 $11
	vol $3
	note as4 $07
	rest $04
	vol $6
	note a4  $07
	rest $03
	vol $3
	note a4  $04
	vol $6
	note a4  $03
	vol $3
	note a4  $04
	vol $6
	note a4  $03
	vol $3
	note a4  $04
	vol $6
	note d5  $07
	rest $03
	vol $3
	note d5  $04
	vol $6
	note a4  $07
	rest $03
	vol $3
	note a4  $04
	vol $6
	note gs4 $07
	rest $03
	vol $3
	note gs4 $04
	vol $6
	note gs4 $03
	vol $3
	note gs4 $04
	vol $6
	note gs4 $03
	vol $3
	note gs4 $04
	vol $6
	note cs5 $07
	rest $03
	vol $3
	note cs5 $04
	vol $6
	note gs4 $07
	rest $03
	vol $3
	note gs4 $04
	vol $6
	note g4  $07
	rest $03
	vol $3
	note g4  $04
	vol $6
	note g4  $03
	vol $3
	note g4  $04
	vol $6
	note g4  $07
	note c5  $07
	rest $03
	vol $3
	note c5  $04
	vol $6
	note g4  $07
	rest $03
	vol $3
	note g4  $04
	vol $6
	note fs4 $07
	rest $03
	vol $3
	note fs4 $04
	vol $6
	note b4  $07
	rest $03
	vol $3
	note b4  $04
	vol $6
	note f4  $07
	rest $03
	vol $3
	note f4  $04
	vol $6
	note as4 $07
	rest $03
	vol $3
	note as4 $04
	vol $6
	note e4  $07
	note ds4 $07
	note d4  $07
	note cs4 $07
	note c4  $11
	vol $3
	note c4  $07
	rest $04
	vol $6
	note ds4 $07
	rest $03
	vol $3
	note ds4 $04
	vol $6
	note ds4 $03
	vol $3
	note ds4 $04
	vol $6
	note ds4 $07
	note as4 $0e
	vol $3
	note as4 $07
	rest $07
	vol $6
	note a4  $03
	vol $3
	note a4  $04
	vol $6
	note a4  $03
	vol $3
	note a4  $04
	vol $6
	note a4  $07
	rest $03
	vol $3
	note a4  $04
	vol $6
	note d4  $0e
	note cs4 $07
	rest $03
	vol $3
	note cs4 $04
	vol $6
	note ds4 $07
	rest $03
	vol $3
	note ds4 $04
	vol $6
	note ds4 $03
	vol $3
	note ds4 $04
	vol $6
	note ds4 $07
	note as4 $0e
	vol $3
	note as4 $07
	rest $07
	vol $6
	note a4  $03
	vol $3
	note a4  $04
	vol $6
	note a4  $03
	vol $3
	note a4  $04
	vol $6
	note a4  $07
	rest $03
	vol $3
	note a4  $04
	vol $6
	note e5  $07
	note ds5 $07
	note d5  $07
	vol $3
	note d5  $07
	vol $6
	note c5  $07
	rest $03
	vol $3
	note c5  $04
	vol $6
	note c5  $03
	rest $04
	note c5  $07
	note g4  $07
	rest $03
	vol $3
	note g4  $04
	vol $6
	note c5  $07
	rest $03
	vol $3
	note c5  $04
	vol $6
	note b4  $07
	rest $03
	vol $3
	note b4  $04
	vol $6
	note b4  $03
	vol $3
	note b4  $04
	vol $6
	note b4  $03
	vol $3
	note b4  $04
	vol $6
	note e5  $07
	rest $03
	vol $3
	note e5  $04
	vol $6
	note b4  $07
	rest $03
	vol $3
	note b4  $04
	vol $6
	note as4 $0e
	vol $3
	note as4 $07
	rest $07
	vol $6
	note as4 $07
	note a4  $07
	note gs4 $07
	note g4  $07
	note fs4 $07
	rest $03
	vol $3
	note fs4 $07
	rest $04
	vol $1
	note fs4 $07
	vol $6
	note as4 $11
	vol $3
	note as4 $07
	rest $04
	goto musicf275f
	cmdff

sound35Channel0:
	vol $0
	note gs3 $07
	vibrato $e1
	env $0 $00
	duty $01
	vol $5
	note ds4 $04
	note as3 $05
	note ds4 $05
	note gs4 $04
	note cs4 $05
	note gs4 $05
	note cs5 $04
	note fs4 $05
	note cs5 $05
	note fs5 $04
	note b4  $05
	note fs5 $05
	note f5  $1c
	vibrato $01
	vol $2
	note f5  $07
	rest $0e
	vibrato $e1
musicf294f:
	vol $6
	note g3  $07
	rest $03
	vol $3
	note g3  $04
	vol $6
	note g3  $03
	vol $3
	note g3  $04
	vol $6
	note g3  $03
	vol $3
	note g3  $04
	vol $6
	note ds4 $11
	vol $3
	note ds4 $07
	rest $04
	vol $6
	note fs4 $07
	rest $03
	vol $3
	note fs4 $04
	vol $6
	note fs4 $07
	note d4  $07
	note a3  $07
	rest $03
	vol $3
	note a3  $04
	vol $6
	note d4  $07
	rest $03
	vol $3
	note d4  $04
	vol $6
	note g3  $07
	rest $03
	vol $3
	note g3  $04
	vol $6
	note g3  $03
	rest $04
	note g3  $03
	rest $04
	note ds4 $11
	vol $3
	note ds4 $07
	rest $04
	vol $6
	note e4  $07
	rest $03
	vol $3
	note e4  $04
	vol $6
	note e4  $03
	vol $3
	note e4  $04
	vol $6
	note e4  $03
	vol $3
	note e4  $04
	vol $6
	note a4  $07
	rest $03
	vol $3
	note a4  $04
	vol $6
	note e4  $07
	rest $03
	vol $3
	note e4  $04
	vol $6
	note cs4 $07
	rest $03
	vol $3
	note cs4 $04
	vol $6
	note cs4 $03
	vol $3
	note cs4 $04
	vol $6
	note cs4 $03
	vol $3
	note cs4 $04
	vol $6
	note gs4 $07
	note f4  $07
	note cs4 $07
	rest $03
	vol $3
	note cs4 $04
	vol $6
	note c4  $07
	rest $03
	vol $3
	note c4  $04
	vol $6
	note c4  $03
	vol $3
	note c4  $04
	vol $6
	note c4  $03
	vol $3
	note c4  $04
	vol $6
	note a4  $07
	note f4  $07
	note b3  $07
	rest $03
	vol $3
	note b3  $04
	vol $6
	note ds4 $07
	rest $03
	vol $3
	note ds4 $04
	vol $6
	note g4  $07
	rest $03
	vol $3
	note g4  $04
	vol $6
	note d4  $07
	rest $03
	vol $3
	note d4  $04
	vol $6
	note fs4 $07
	rest $03
	vol $3
	note fs4 $04
	vol $6
	note cs4 $07
	note c4  $07
	note b3  $07
	note as3 $07
	note a3  $11
	vol $3
	note a3  $07
	rest $04
	vol $6
	note as3 $07
	rest $03
	vol $3
	note as3 $04
	vol $6
	note as3 $03
	vol $3
	note as3 $04
	vol $6
	note as3 $03
	vol $3
	note as3 $04
	rest $07
	vol $6
	note as3 $07
	note ds4 $07
	note g4  $07
	vol $6
	note fs4 $03
	vol $3
	note fs4 $04
	vol $6
	note fs4 $03
	vol $3
	note fs4 $04
	vol $6
	note fs4 $03
	vol $3
	note fs4 $04
	vol $6
	note e4  $07
	note a3  $07
	note as3 $07
	note b3  $07
	note a3  $07
	note g3  $07
	rest $03
	vol $3
	note g3  $04
	vol $6
	note g3  $03
	vol $3
	note g3  $04
	vol $6
	note g3  $03
	vol $3
	note g3  $04
	vol $6
	note g3  $07
	note as3 $07
	note g3  $07
	note as3 $07
	note fs4 $03
	vol $3
	note fs4 $04
	vol $6
	note fs4 $03
	vol $3
	note fs4 $04
	vol $6
	note fs4 $07
	rest $03
	vol $3
	note fs4 $04
	vol $6
	note d4  $07
	rest $03
	vol $3
	note d4  $04
	vol $6
	note a4  $07
	rest $03
	vol $3
	note a4  $04
	vol $6
	note g4  $07
	rest $03
	vol $3
	note g4  $04
	vol $6
	note g4  $03
	vol $3
	note g4  $04
	vol $6
	note g4  $03
	vol $3
	note g4  $04
	vol $6
	note c4  $07
	note e4  $07
	note g4  $07
	vol $3
	note g4  $07
	vol $6
	note ds4 $07
	rest $03
	vol $3
	note ds4 $04
	vol $6
	note ds4 $03
	vol $3
	note ds4 $04
	vol $6
	note ds4 $03
	vol $3
	note ds4 $04
	vol $6
	note g4  $07
	note e4  $07
	note b3  $07
	vol $3
	note b3  $07
	vol $6
	note fs4 $0e
	vol $3
	note fs4 $07
	rest $07
	vol $6
	note fs4 $07
	note f4  $07
	note e4  $07
	note ds4 $07
	note d4  $07
	vol $3
	note d4  $07
	rest $0e
	vol $6
	note d4  $11
	vol $3
	note d4  $07
	rest $04
	goto musicf294f
	cmdff

sound35Channel4:
	rest $70
musicf2b0e:
	duty $0e
	note ds2 $07
	rest $0e
	note ds2 $07
	note as2 $07
	rest $07
	note ds2 $07
	rest $07
	note d2  $07
	rest $0e
	note fs2 $07
	note a2  $07
	rest $07
	note d2  $07
	rest $07
	note ds2 $07
	rest $0e
	note ds2 $07
	note as2 $07
	rest $07
	note ds2 $07
	rest $07
	note d2  $07
	rest $0e
	note fs2 $07
	note a2  $07
	rest $07
	note d2  $07
	rest $07
	note cs2 $0e
	rest $07
	note cs2 $07
	note gs2 $07
	rest $07
	note cs2 $07
	rest $07
	note c2  $0e
	rest $07
	note c2  $07
	note g2  $07
	rest $07
	note c2  $07
	rest $07
	note gs2 $07
	rest $07
	note g2  $07
	rest $07
	note fs2 $07
	rest $07
	note f2  $07
	rest $23
	note as1 $15
	note c2  $03
	note d2  $04
	note ds2 $0e
	rest $07
	note ds2 $07
	note as2 $0e
	rest $07
	note as2 $07
	note d2  $0e
	rest $07
	note fs2 $07
	note a2  $0e
	rest $07
	note a2  $07
	note ds2 $0e
	rest $07
	note ds2 $07
	note as2 $0e
	rest $07
	note ds2 $07
	note b2  $0e
	rest $07
	note gs2 $07
	note e2  $0e
	rest $07
	note gs2 $07
	note c3  $0e
	rest $07
	note c3  $07
	note fs2 $07
	rest $07
	note b2  $07
	note fs2 $07
	note b2  $0e
	rest $07
	note b2  $07
	note f2  $07
	rest $07
	note as2 $07
	note f2  $07
	note b1  $0e
	rest $0e
	note b1  $07
	note c2  $07
	note cs2 $07
	note d2  $07
	note ds2 $07
	rest $15
	note as1 $15
	note c2  $03
	note d2  $04
	goto musicf2b0e
	cmdff

sound35Channel6:
	rest $69
	vol $6
	note $26 $03
	vol $5
	note $26 $04
musicf2be8:
	vol $6
	note $24 $07
	vol $2
	note $2a $07
	note $2e $07
	rest $07
	vol $6
	note $26 $07
	vol $2
	note $2a $07
	note $2e $07
	rest $07
	vol $6
	note $24 $07
	vol $2
	note $2a $07
	note $2e $07
	rest $07
	vol $6
	note $26 $07
	vol $2
	note $2a $07
	note $2e $07
	rest $07
	vol $6
	note $24 $07
	vol $2
	note $2a $07
	note $2e $07
	rest $07
	vol $6
	note $26 $07
	vol $2
	note $2a $07
	note $2e $07
	rest $07
	vol $6
	note $24 $07
	vol $2
	note $2a $07
	note $2e $07
	rest $07
	vol $6
	note $26 $07
	vol $2
	note $2a $07
	note $2e $07
	rest $07
	vol $6
	note $24 $07
	vol $2
	note $2a $07
	note $2e $07
	rest $07
	vol $6
	note $26 $07
	vol $2
	note $2a $07
	note $2e $07
	rest $07
	vol $6
	note $24 $07
	vol $2
	note $2a $07
	note $2e $07
	rest $07
	vol $6
	note $26 $07
	vol $2
	note $2a $07
	note $2e $07
	rest $07
	note $2a $07
	rest $07
	note $2a $07
	rest $07
	note $2a $07
	rest $07
	note $2a $07
	rest $07
	note $2e $07
	rest $15
	vol $6
	note $24 $07
	rest $0e
	note $26 $03
	vol $5
	note $26 $04
	vol $6
	note $24 $07
	vol $2
	note $2a $07
	note $2a $07
	note $2e $07
	vol $6
	note $26 $07
	vol $2
	note $2a $07
	note $2a $07
	note $2e $07
	vol $6
	note $24 $07
	vol $2
	note $2a $07
	note $2a $07
	note $2e $07
	vol $6
	note $26 $07
	vol $2
	note $2a $07
	note $2a $07
	note $2e $07
	vol $6
	note $24 $07
	vol $2
	note $2a $07
	note $2a $07
	note $2e $07
	vol $6
	note $26 $07
	vol $2
	note $2a $07
	note $2a $07
	note $2e $07
	vol $6
	note $24 $07
	vol $2
	note $2a $07
	note $2a $07
	note $2e $07
	vol $6
	note $26 $07
	vol $2
	note $2a $07
	note $2a $07
	note $2e $07
	vol $6
	note $24 $07
	vol $2
	note $2a $07
	note $2a $07
	note $2e $07
	vol $6
	note $26 $07
	vol $2
	note $2a $07
	note $2a $07
	note $2e $07
	vol $6
	note $24 $07
	vol $2
	note $2a $07
	note $2a $07
	note $2e $07
	vol $6
	note $26 $07
	vol $2
	note $2a $07
	note $2a $07
	note $2e $07
	note $2e $07
	rest $07
	note $2a $07
	note $2a $07
	note $2a $07
	note $2a $07
	note $2a $07
	note $2a $07
	note $2a $07
	rest $07
	vol $6
	note $26 $04
	vol $5
	note $26 $05
	vol $4
	note $26 $05
	vol $6
	note $26 $07
	rest $07
	vol $2
	note $2a $07
	note $2a $07
	goto musicf2be8
	cmdff

sound13Start:

sound13Channel1:
	vibrato $00
	env $0 $00
	duty $02
musicf2d27:
	vol $5
	note as4 $07
	rest $03
	vol $3
	note as4 $07
	rest $04
	vol $1
	note as4 $07
	vol $5
	note f5  $07
	rest $03
	vol $2
	note f5  $07
	rest $04
	vol $1
	note f5  $07
	rest $1c
	vol $5
	note e5  $07
	rest $03
	vol $2
	note e5  $07
	rest $04
	vol $1
	note e5  $07
	vol $5
	note f5  $07
	rest $03
	vol $2
	note f5  $07
	rest $04
	vol $1
	note f5  $07
	rest $1c
	vol $5
	note gs5 $07
	rest $03
	vol $2
	note gs5 $07
	rest $04
	vol $1
	note gs5 $07
	vol $5
	note b6  $02
	rest $01
	vol $2
	note b6  $02
	rest $02
	vol $1
	note b6  $02
	rest $01
	vol $0
	note b6  $02
	rest $2c
	vol $5
	note g5  $07
	rest $03
	vol $2
	note g5  $07
	rest $04
	vol $1
	note g5  $07
	vol $5
	note as6 $02
	rest $01
	vol $2
	note as6 $02
	rest $02
	vol $1
	note as6 $02
	rest $01
	vol $0
	note as6 $02
	rest $2c
	vol $5
	note e5  $38
	note f5  $07
	rest $03
	vol $3
	note f5  $07
	rest $04
	vol $1
	note f5  $07
	vol $5
	note b7  $02
	rest $01
	vol $2
	note b7  $02
	rest $02
	vol $1
	note b7  $02
	rest $01
	vol $0
	note b7  $02
	rest $48
	vol $5
	note f5  $07
	rest $03
	vol $3
	note f5  $07
	rest $04
	vol $1
	note f5  $07
	vol $5
	note e5  $07
	rest $03
	vol $3
	note e5  $07
	rest $04
	vol $2
	note e5  $07
	rest $03
	vol $2
	note e5  $07
	rest $12
	vol $5
	note ds5 $07
	rest $03
	vol $3
	note ds5 $07
	rest $04
	vol $1
	note ds5 $07
	vol $5
	note d5  $07
	rest $03
	vol $3
	note d5  $07
	rest $04
	vol $2
	note d5  $07
	rest $03
	vol $2
	note d5  $07
	rest $12
	vol $5
	note cs5 $07
	rest $03
	vol $2
	note cs5 $07
	rest $04
	vol $1
	note cs5 $07
	vol $4
	note f6  $02
	rest $02
	vol $4
	note b6  $03
	rest $02
	vol $3
	note b6  $02
	rest $03
	vol $3
	note b6  $02
	rest $28
	vol $5
	note c5  $07
	rest $03
	vol $3
	note c5  $07
	rest $04
	vol $2
	note c5  $07
	rest $03
	vol $2
	note c5  $07
	rest $12
	vol $5
	note as6 $02
	rest $02
	vol $5
	note e6  $03
	rest $02
	vol $3
	note e6  $02
	rest $03
	vol $3
	note e6  $02
	rest $02
	vol $2
	note e6  $03
	rest $07
	vol $5
	note e3  $07
	note f3  $07
	note e4  $07
	note f4  $07
	note e5  $07
	note f5  $07
	note e6  $07
	note f6  $07
	note e7  $07
	note f7  $07
	note b6  $07
	note c7  $07
	note a6  $03
	note gs6 $04
	note g6  $03
	note fs6 $04
	note f6  $03
	rest $01
	vol $3
	note f6  $04
	rest $01
	vol $2
	note f6  $03
	rest $72
	goto musicf2d27
	cmdff

sound13Channel0:
	vibrato $00
	env $0 $00
	duty $02
musicf2e8d:
	vol $0
	note gs3 $1c
	vol $5
	note cs5 $07
	rest $03
	vol $2
	note cs5 $07
	rest $04
	vol $1
	note cs5 $07
	rest $1c
	vol $5
	note c5  $07
	rest $03
	vol $2
	note c5  $07
	rest $04
	vol $1
	note c5  $07
	vol $5
	note cs5 $07
	rest $03
	vol $2
	note cs5 $07
	rest $04
	vol $1
	note cs5 $07
	rest $1c
	vol $5
	note d5  $07
	rest $03
	vol $2
	note d5  $07
	rest $04
	vol $1
	note d5  $07
	vol $5
	note f7  $02
	rest $02
	vol $3
	note f7  $03
	rest $02
	vol $2
	note f7  $02
	rest $03
	vol $1
	note f7  $02
	rest $28
	vol $5
	note cs5 $07
	rest $03
	vol $2
	note cs5 $07
	rest $04
	vol $1
	note cs5 $07
	vol $5
	note e7  $02
	rest $02
	vol $3
	note e7  $03
	rest $02
	vol $2
	note e7  $02
	rest $03
	vol $1
	note e7  $02
	rest $28
	vol $5
	note cs5 $38
	note d5  $07
	rest $03
	vol $2
	note d5  $07
	rest $04
	vol $1
	note d5  $07
	vol $5
	note f6  $02
	rest $02
	vol $3
	note f6  $03
	rest $02
	vol $2
	note f6  $02
	rest $03
	vol $1
	note f6  $02
	rest $44
	vol $5
	note d5  $07
	rest $03
	vol $2
	note d5  $07
	rest $04
	vol $1
	note d5  $07
	vol $5
	note cs5 $07
	rest $03
	vol $3
	note cs5 $07
	rest $04
	vol $3
	note cs5 $07
	rest $03
	vol $2
	note cs5 $07
	rest $12
	vol $5
	note c5  $07
	rest $03
	vol $2
	note c5  $07
	rest $04
	vol $1
	note c5  $07
	vol $5
	note b4  $07
	rest $03
	vol $3
	note b4  $07
	rest $04
	vol $3
	note b4  $07
	rest $03
	vol $2
	note b4  $07
	rest $12
	vol $5
	note as4 $07
	rest $03
	vol $3
	note as4 $07
	rest $04
	vol $3
	note as4 $07
	rest $03
	vol $2
	note as4 $04
	vol $4
	note f7  $03
	rest $01
	vol $4
	note b7  $03
	rest $02
	vol $2
	note b7  $02
	rest $03
	vol $2
	note b7  $02
	rest $21
	vol $5
	note a4  $07
	rest $03
	vol $3
	note a4  $07
	rest $04
	vol $3
	note a4  $07
	rest $03
	vol $2
	note a4  $07
	rest $19
	vol $5
	note as5 $02
	rest $02
	vol $5
	note e5  $03
	rest $02
	vol $3
	note e5  $02
	rest $03
	vol $2
	note e5  $02
	rest $02
	vol $2
	note e5  $03
	rest $0b
	vol $4
	note e3  $07
	note f3  $07
	note e4  $07
	note f4  $07
	note e5  $07
	note f5  $07
	note e6  $07
	note f6  $07
	note e7  $07
	note f7  $07
	note b6  $07
	note c7  $07
	note a6  $04
	note gs6 $03
	note g6  $04
	vol $2
	note fs6 $03
	vol $2
	note f6  $03
	rest $70
	goto musicf2e8d
	cmdff

sound13Channel4:
musicf2fe0:
	rest $c4
	duty $0e
	note d2  $54
	note cs2 $2a
	note c2  $07
	note b1  $07
	note as1 $3f
	note a1  $07
	note gs1 $07
	note g1  $07
	note fs1 $46
	duty $0f
	note fs1 $07
	rest $07
	duty $0e
	note cs2 $38
	note a2  $38
	note gs2 $38
	note a1  $38
	note cs3 $38
	note c3  $38
	note fs1 $38
	note f1  $38
	rest $70
	goto musicf2fe0
	cmdff

sound13Channel6:
musicf3014:
	rest $38
	vol $2
	note $2a $0e
	note $2a $0e
	rest $38
	note $2e $0e
	rest $0e
	note $2a $0e
	rest $46
	note $2a $0e
	rest $62
	note $2a $0e
	note $2a $0e
	note $2e $0e
	rest $0e
	note $2a $0e
	rest $62
	note $2a $0e
	rest $0e
	note $2e $0e
	rest $0e
	note $2a $0e
	rest $46
	note $2a $0e
	note $2a $0e
	note $2e $0e
	rest $2a
	note $2a $0e
	rest $46
	note $2a $0e
	note $2a $0e
	rest $38
	note $2a $07
	note $2a $0e
	rest $23
	note $2a $0e
	note $2a $0e
	rest $1c
	note $2e $0e
	rest $0e
	goto musicf3014
	cmdff

sound14Start:

sound14Channel1:
	cmdf2
	vibrato $00
	env $0 $00
	duty $02
musicf306e:
	vol $6
	note ds4 $07
	rest $03
	vol $3
	note ds4 $07
	rest $04
	vol $2
	note ds4 $07
	vol $6
	note ds4 $07
	rest $03
	vol $3
	note ds4 $07
	rest $04
	vol $2
	note ds4 $07
	vol $6
	note fs4 $07
	rest $03
	vol $3
	note fs4 $07
	rest $04
	vol $2
	note fs4 $07
	rest $1c
	vol $6
	note ds4 $07
	rest $03
	vol $3
	note ds4 $07
	rest $04
	vol $2
	note ds4 $07
	vol $6
	note ds4 $07
	rest $03
	vol $3
	note ds4 $07
	rest $04
	vol $2
	note ds4 $07
	vol $6
	note fs4 $07
	rest $03
	vol $3
	note fs4 $07
	rest $04
	vol $2
	note fs4 $07
	rest $1c
	vol $8
	note ds4 $07
	rest $03
	vol $4
	note ds4 $07
	rest $04
	vol $2
	note ds4 $07
	vol $7
	note fs4 $07
	rest $03
	vol $4
	note fs4 $07
	rest $04
	vol $2
	note fs4 $07
	vol $7
	note g4  $07
	rest $03
	vol $3
	note g4  $07
	rest $04
	vol $2
	note g4  $07
	vol $7
	note fs4 $07
	rest $03
	vol $3
	note fs4 $07
	rest $04
	vol $2
	note fs4 $07
	vol $7
	note g4  $07
	rest $03
	vol $3
	note g4  $07
	rest $04
	vol $2
	note g4  $07
	vol $7
	note fs4 $07
	rest $03
	vol $3
	note fs4 $07
	rest $04
	vol $2
	note fs4 $07
	rest $38
	vol $6
	note ds4 $07
	rest $03
	vol $3
	note ds4 $07
	rest $04
	vol $1
	note ds4 $07
	vol $6
	note ds4 $07
	rest $03
	vol $3
	note ds4 $07
	rest $04
	vol $2
	note ds4 $07
	vol $6
	note fs4 $07
	rest $03
	vol $3
	note fs4 $07
	rest $04
	vol $2
	note fs4 $07
	rest $1c
	vol $6
	note ds4 $07
	rest $03
	vol $3
	note ds4 $04
	vol $6
	note ds4 $07
	rest $03
	vol $3
	note ds4 $04
	vol $6
	note ds4 $07
	rest $03
	vol $3
	note ds4 $04
	vol $6
	note ds4 $07
	rest $03
	vol $3
	note ds4 $04
	vol $6
	note fs4 $07
	rest $03
	vol $3
	note fs4 $07
	rest $04
	vol $1
	note fs4 $07
	rest $1c
	vol $6
	note ds4 $07
	rest $03
	vol $3
	note ds4 $07
	rest $04
	vol $1
	note ds4 $07
	vol $6
	note fs4 $07
	rest $03
	vol $3
	note fs4 $07
	rest $04
	vol $2
	note fs4 $07
	vol $6
	note g4  $07
	rest $03
	vol $3
	note g4  $07
	rest $04
	vol $1
	note g4  $07
	vol $6
	note as4 $07
	rest $03
	vol $3
	note as4 $07
	rest $04
	vol $1
	note as4 $07
	vol $6
	note d5  $07
	rest $03
	vol $3
	note d5  $04
	vol $6
	note cs5 $07
	rest $03
	vol $3
	note cs5 $04
	vol $6
	note g4  $07
	rest $03
	vol $3
	note g4  $04
	vol $6
	note fs4 $07
	rest $03
	vol $3
	note fs4 $07
	rest $04
	vol $2
	note fs4 $07
	rest $ff
	vol $0
	note c1  $0b
	goto musicf306e
	cmdff

sound14Channel0:
	cmdf2
	vibrato $00
	env $0 $00
	duty $02
musicf31d1:
	vol $6
	note c4  $07
	rest $03
	vol $3
	note c4  $07
	rest $04
	vol $2
	note c4  $07
	vol $6
	note c4  $07
	rest $03
	vol $3
	note c4  $07
	rest $04
	vol $2
	note c4  $07
	vol $6
	note d4  $07
	rest $03
	vol $3
	note d4  $07
	rest $04
	vol $2
	note d4  $07
	rest $1c
	vol $6
	note c4  $07
	rest $03
	vol $3
	note c4  $07
	rest $04
	vol $2
	note c4  $07
	vol $6
	note c4  $07
	rest $03
	vol $3
	note c4  $07
	rest $04
	vol $2
	note c4  $07
	vol $6
	note d4  $07
	rest $03
	vol $3
	note d4  $07
	rest $04
	vol $2
	note d4  $07
	rest $1c
	vol $6
	note c4  $07
	rest $03
	vol $3
	note c4  $07
	rest $04
	vol $2
	note c4  $07
	vol $6
	note d4  $07
	rest $03
	vol $3
	note d4  $07
	rest $04
	vol $2
	note d4  $07
	vol $6
	note ds4 $07
	rest $03
	vol $3
	note ds4 $07
	rest $04
	vol $2
	note ds4 $07
	vol $6
	note d4  $07
	rest $03
	vol $3
	note d4  $07
	rest $04
	vol $2
	note d4  $07
	vol $6
	note ds4 $07
	rest $03
	vol $3
	note ds4 $07
	rest $04
	vol $2
	note ds4 $07
	vol $6
	note d4  $07
	rest $03
	vol $3
	note d4  $07
	rest $04
	vol $2
	note d4  $07
	rest $38
	vol $6
	note c4  $07
	rest $03
	vol $3
	note c4  $07
	rest $04
	vol $2
	note c4  $07
	vol $6
	note c4  $07
	rest $03
	vol $3
	note c4  $07
	rest $04
	vol $2
	note c4  $07
	vol $6
	note d4  $07
	rest $03
	vol $3
	note d4  $07
	rest $04
	vol $2
	note d4  $07
	rest $1c
	vol $6
	note c4  $07
	rest $03
	vol $3
	note c4  $04
	vol $6
	note c4  $07
	rest $03
	vol $3
	note c4  $04
	vol $6
	note c4  $07
	rest $03
	vol $3
	note c4  $04
	vol $6
	note c4  $07
	rest $03
	vol $3
	note c4  $04
	vol $6
	note d4  $07
	rest $03
	vol $3
	note d4  $07
	rest $04
	vol $2
	note d4  $04
	rest $1f
	vol $6
	note c4  $07
	rest $03
	vol $3
	note c4  $07
	rest $04
	vol $2
	note c4  $07
	vol $6
	note d4  $07
	rest $03
	vol $3
	note d4  $07
	rest $04
	vol $2
	note d4  $07
	vol $6
	note ds4 $07
	rest $03
	vol $3
	note ds4 $07
	rest $04
	vol $2
	note ds4 $07
	vol $6
	note fs4 $07
	rest $03
	vol $3
	note fs4 $07
	rest $04
	vol $2
	note fs4 $07
	vol $6
	note as4 $07
	rest $03
	vol $3
	note as4 $04
	vol $6
	note a4  $07
	rest $03
	vol $3
	note a4  $04
	vol $6
	note ds4 $07
	rest $03
	vol $3
	note ds4 $04
	vol $6
	note d4  $07
	rest $03
	vol $3
	note d4  $07
	rest $04
	vol $2
	note d4  $07
	rest $ff
	vol $0
	note gs3 $0b
	goto musicf31d1
	cmdff

sound14Channel4:
musicf332d:
	rest $ff
	rest $c1
	duty $0e
	note c3  $07
	rest $15
	note c3  $07
	rest $15
	note d3  $07
	rest $31
	note c3  $07
	rest $07
	note c3  $07
	rest $07
	note c3  $07
	rest $07
	note c3  $07
	rest $07
	note d3  $07
	rest $31
	note c3  $07
	rest $15
	note d3  $07
	rest $15
	note ds3 $07
	rest $15
	note fs3 $07
	rest $15
	note as3 $07
	rest $07
	note a3  $07
	rest $07
	note ds3 $07
	rest $07
	note d3  $07
	rest $ff
	rest $20
	goto musicf332d
	cmdff

sound14Channel6:
musicf3379:
	rest $ff
	rest $89
	vol $3
	note $2a $0e
	note $2e $0e
	rest $62
	note $2a $0e
	note $2e $0e
	rest $54
	note $2a $0e
	note $2e $0e
	rest $d2
	note $2a $0e
	note $2a $0e
	note $2e $0e
	rest $46
	note $2a $0e
	note $2a $0e
	note $2e $0e
	rest $62
	goto musicf3379
	cmdff

sound17Start:

sound17Channel1:
	vibrato $e1
	env $0 $00
	duty $01
musicf33aa:
	vol $6
	note a4  $1a
	note gs4 $1a
	note g4  $1a
	note cs5 $1a
	note c5  $1a
	note fs4 $1a
	note b4  $1a
	note f4  $1a
	note as4 $1a
	note e4  $1a
	note a4  $1a
	note d4  $1a
	vol $3
	note d4  $1a
	vol $6
	note a4  $0d
	note gs4 $0d
	note g4  $1a
	note cs5 $1a
	note d5  $1a
	note a4  $1a
	note c5  $1a
	note gs4 $1a
	note b4  $1a
	note g4  $1a
	note as4 $1a
	note fs4 $1a
	note a4  $0d
	note e4  $0d
	note gs4 $0d
	note d4  $06
	rest $07
	vol $3
	note d4  $06
	rest $07
	vol $1
	note d4  $06
	rest $07
	vol $6
	note a4  $0d
	note e4  $0d
	note gs4 $0d
	note d4  $06
	rest $07
	vol $3
	note d4  $06
	rest $07
	vol $1
	note d4  $06
	rest $07
	vol $6
	note d4  $0d
	note gs4 $0d
	note a4  $0d
	note as4 $0d
	note b4  $4e
	note as4 $08
	note a4  $09
	note gs4 $09
	note d4  $0d
	rest $06
	vol $3
	note d4  $0d
	rest $07
	vol $1
	note d4  $0d
	rest $06
	vol $0
	note d4  $0d
	rest $55
	vol $6
	note d5  $1a
	note a4  $1a
	note cs5 $1a
	note gs4 $1a
	vol $3
	note gs4 $1a
	vol $6
	note g4  $1a
	note fs4 $1a
	note ds5 $1a
	note e5  $1a
	note c5  $1a
	note cs5 $1a
	note gs4 $1a
	note b4  $82
	note as4 $08
	note a4  $09
	note gs4 $09
	note d4  $08
	rest $05
	vol $3
	note d4  $08
	rest $05
	vol $1
	note d4  $08
	rest $05
	vol $0
	note d4  $08
	rest $6d
	vol $6
	note c4  $08
	rest $05
	note c4  $08
	rest $05
	note fs4 $06
	rest $07
	vol $3
	note fs4 $06
	rest $07
	vol $1
	note fs4 $06
	rest $14
	vol $6
	note c4  $06
	rest $07
	note c4  $06
	rest $07
	note fs4 $06
	rest $07
	vol $3
	note fs4 $06
	rest $07
	vol $1
	note fs4 $06
	rest $14
	vol $6
	note c4  $06
	rest $07
	note c4  $06
	rest $07
	note fs4 $06
	rest $07
	note fs4 $06
	rest $07
	note as4 $0d
	note a4  $0d
	note f4  $0d
	note gs4 $0d
	note g4  $0d
	note ds4 $0d
	note fs4 $0d
	note d4  $06
	rest $07
	vol $5
	note d4  $06
	rest $07
	vol $3
	note d4  $06
	rest $07
	vol $3
	note d4  $06
	rest $07
	vol $2
	note d4  $06
	rest $3b
	goto musicf33aa
	cmdff

sound17Channel0:
	vibrato $e1
	env $0 $00
	duty $01
musicf34d1:
	vol $6
	note f4  $1a
	note e4  $1a
	note ds4 $1a
	vol $6
	note a4  $1a
	note gs4 $1a
	note d4  $1a
	note gs4 $1a
	note cs4 $1a
	note fs4 $1a
	note c4  $1a
	note f4  $1a
	note b3  $1a
	vol $3
	note b3  $1a
	vol $6
	note f4  $0d
	note e4  $0d
	note ds4 $1a
	note a4  $1a
	note as4 $1a
	note f4  $1a
	note gs4 $1a
	note e4  $1a
	note g4  $1a
	note ds4 $1a
	note fs4 $1a
	note d4  $1a
	note f4  $0d
	note c5  $0d
	note e4  $0d
	note b4  $06
	rest $07
	vol $3
	note b4  $06
	rest $07
	vol $1
	note b4  $06
	rest $07
	vol $6
	note f4  $0d
	note c4  $0d
	note e4  $0d
	note as3 $06
	rest $07
	vol $3
	note as3 $06
	rest $07
	vol $1
	note as3 $06
	rest $3b
	vol $6
	note d5  $0d
	note gs5 $0d
	note a5  $0d
	note as5 $0d
	note b5  $34
	note as5 $08
	note a5  $09
	note gs5 $09
	note d5  $08
	rest $05
	vol $3
	note d5  $08
	rest $05
	vol $1
	note d5  $08
	rest $05
	vol $0
	note d5  $08
	rest $53
	vol $6
	note as4 $1a
	note f4  $1a
	note a4  $1a
	note e4  $1a
	vol $3
	note e4  $1a
	vol $6
	note ds4 $1a
	note d4  $1a
	note b4  $1a
	note c5  $1a
	note gs4 $1a
	note a4  $1a
	note e4  $1a
	note g4  $0d
	note ds4 $0d
	note fs4 $0d
	note d4  $06
	rest $07
	vol $3
	note d4  $06
	rest $07
	vol $1
	note d4  $06
	rest $07
	vol $6
	note g4  $0d
	note ds4 $0d
	note fs4 $0d
	note d4  $06
	rest $07
	vol $3
	note d4  $06
	rest $07
	vol $1
	note d4  $06
	rest $07
	vol $6
	note as3 $06
	rest $07
	vol $3
	note as3 $06
	rest $07
	vol $1
	note as3 $06
	rest $07
	vol $0
	note as3 $06
	rest $6f
	vol $6
	note gs3 $06
	rest $07
	note gs3 $06
	rest $07
	note d4  $06
	rest $07
	vol $3
	note d4  $06
	rest $07
	vol $1
	note d4  $06
	rest $07
	vol $0
	note d4  $06
	rest $07
	vol $6
	note gs3 $06
	rest $07
	note gs3 $06
	rest $07
	note d4  $06
	rest $07
	vol $3
	note d4  $06
	rest $07
	vol $1
	note d4  $06
	rest $07
	vol $0
	note d4  $06
	rest $07
	vol $6
	note gs3 $06
	rest $07
	note gs3 $06
	rest $07
	note d4  $06
	rest $07
	note d4  $06
	rest $07
	note fs4 $0d
	note f4  $0d
	note cs4 $0d
	note e4  $0d
	note ds4 $0d
	note b3  $0d
	note d4  $0d
	note as3 $06
	rest $07
	vol $3
	note as3 $06
	rest $07
	vol $1
	note as3 $06
	rest $07
	vol $0
	note as3 $06
	rest $48
	goto musicf34d1
	cmdff

sound17Channel4:
musicf361a:
	duty $0e
	note c3  $0d
	duty $0f
	note c3  $0d
	duty $0e
	note c3  $0d
	duty $0f
	note c3  $0d
	duty $0e
	note f3  $1a
	note fs3 $1a
	rest $1a
	note c3  $0d
	duty $0f
	note c3  $0d
	duty $0e
	note f3  $1a
	note fs3 $1a
	note c3  $0d
	duty $0f
	note c3  $0d
	duty $0e
	note c3  $0d
	duty $0f
	note c3  $0d
	rest $1a
	duty $0e
	note c3  $0d
	duty $0f
	note c3  $0d
	duty $0e
	note fs3 $1a
	note f3  $1a
	note c3  $0d
	duty $0f
	note c3  $0d
	duty $0e
	note c3  $0d
	duty $0f
	note c3  $0d
	rest $1a
	duty $0e
	note c3  $0d
	duty $0f
	note c3  $0d
	duty $0e
	note f3  $1a
	note fs3 $1a
	note c3  $0d
	duty $0f
	note c3  $0d
	duty $0e
	note c3  $0d
	duty $0f
	note c3  $0d
	rest $1a
	duty $0e
	note c3  $0d
	duty $0f
	note c3  $0d
	rest $34
	duty $0e
	note c4  $0d
	duty $0f
	note c4  $0d
	rest $34
	duty $0e
	note c3  $0d
	duty $0f
	note c3  $0d
	rest $ff
	rest $39
	duty $0e
	note d3  $0d
	duty $0f
	note d3  $0d
	duty $0e
	note d3  $0d
	duty $0f
	note d3  $0d
	duty $0e
	note a3  $1a
	note as3 $1a
	rest $1a
	note d3  $0d
	duty $0f
	note d3  $0d
	duty $0e
	note a3  $1a
	note as3 $1a
	note d3  $0d
	duty $0f
	note d3  $0d
	duty $0e
	note d3  $0d
	duty $0f
	note d3  $0d
	duty $0e
	note as3 $0d
	duty $0f
	note as3 $0d
	duty $0e
	note as3 $0d
	duty $0f
	note as3 $0d
	rest $34
	duty $0e
	note d3  $0d
	duty $0f
	note d3  $0d
	rest $34
	duty $0e
	note d3  $0d
	duty $0f
	note d3  $0d
	rest $d0
	duty $0e
	note c3  $0d
	duty $0f
	note c3  $0d
	rest $34
	duty $0e
	note c3  $0d
	duty $0f
	note c3  $0d
	rest $34
	duty $0e
	note d4  $0d
	note cs4 $0d
	note a3  $0d
	note c4  $0d
	note b3  $0d
	note g3  $0d
	note as3 $0d
	note fs3 $0d
	duty $0f
	note fs3 $0d
	rest $5b
	goto musicf361a
	cmdff

sound17Channel6:
musicf3732:
	rest $ff
	rest $ff
	rest $a6
	vol $4
	note $2e $34
	rest $1a
	note $2e $34
	rest $ea
	note $2a $0d
	note $2a $0d
	note $2e $34
	rest $ff
	rest $ff
	rest $24
	note $2a $0d
	note $2a $0d
	note $2e $1a
	rest $9c
	note $2a $0d
	note $2a $0d
	note $2e $1a
	rest $9c
	note $2a $0d
	note $2a $0d
	note $2a $0d
	note $2e $0d
	goto musicf3732
	cmdff

sound19Channel1:
	vibrato $e1
	env $0 $00
	cmdf2
	duty $01
musicf3770:
	vol $7
	note e4  $2c
	vol $7
	note ds4 $2c
	note f4  $2c
	note e4  $2c
	note d4  $42
	note cs4 $0b
	note c4  $0b
	note as3 $21
	vibrato $01
	vol $3
	note as3 $0b
	vibrato $e1
	vol $7
	note g3  $2c
	vibrato $01
	vol $3
	note g3  $2c
	vibrato $e1
	vol $7
	note a3  $2c
	note e4  $2c
	note a4  $2c
	note as4 $58
	note ds4 $2c
	note e4  $16
	vibrato $01
	vol $3
	note e4  $16
	vibrato $e1
	vol $7
	note a3  $16
	note e3  $16
	note f3  $16
	note cs3 $16
	note a3  $16
	note e3  $16
	note f3  $16
	note cs3 $16
	note cs4 $58
	note e3  $42
	vibrato $01
	vol $3
	note e3  $16
	vibrato $e1
	vol $7
	note b3  $16
	note fs3 $16
	note g3  $16
	note ds3 $16
	note b3  $16
	note fs3 $16
	note g3  $16
	note ds3 $16
	note d4  $58
	note f3  $42
	vibrato $01
	vol $3
	note f3  $15
	rest $01
	vibrato $e1
	goto musicf3770
	cmdff

sound19Channel0:
	vibrato $00
	env $0 $00
	cmdf2
	duty $02
musicf37ec:
	vol $5
	note a4  $0b
	rest $0b
	note as4 $0b
	vol $2
	note a4  $0b
	vol $5
	note e5  $0b
	vol $2
	note as4 $0b
	vol $5
	note a4  $0b
	vol $2
	note e5  $0b
	vol $5
	note as4 $0b
	vol $2
	note a4  $0b
	vol $5
	note e5  $0b
	vol $2
	note as4 $0b
	vol $5
	note a4  $0b
	vol $2
	note e5  $0b
	vol $5
	note as4 $0b
	vol $2
	note a4  $0b
	vol $5
	note g4  $0b
	vol $2
	note as4 $0b
	vol $5
	note gs4 $0b
	vol $2
	note g4  $0b
	vol $5
	note d5  $0b
	vol $2
	note gs4 $0b
	vol $5
	note g4  $0b
	vol $2
	note d5  $0b
	vol $5
	note gs4 $0b
	vol $2
	note g4  $0b
	vol $5
	note d5  $0b
	vol $2
	note gs4 $0b
	vol $5
	note g4  $0b
	vol $2
	note d5  $0b
	vol $5
	note gs4 $0b
	vol $2
	note g4  $0b
	vol $5
	note a4  $0b
	vol $2
	note gs4 $0b
	vol $5
	note as4 $0b
	vol $2
	note a4  $0b
	vol $5
	note e5  $0b
	vol $2
	note as4 $0b
	vol $5
	note a4  $0b
	vol $2
	note e5  $0b
	vol $5
	note as4 $0b
	vol $2
	note a4  $0b
	vol $5
	note e5  $0b
	vol $2
	note as4 $0b
	vol $5
	note a4  $0b
	vol $2
	note e5  $0b
	vol $5
	note as4 $0b
	vol $2
	note a4  $0b
	vol $5
	note g4  $0b
	vol $2
	note as4 $0b
	vol $5
	note gs4 $0b
	vol $2
	note g4  $0b
	vol $5
	note d5  $0b
	vol $2
	note gs4 $0b
	vol $5
	note g4  $0b
	vol $2
	note d5  $0b
	vol $5
	note gs4 $0b
	vol $2
	note g4  $0b
	vol $5
	note d5  $0b
	vol $2
	note gs4 $0b
	vol $5
	note g4  $0b
	vol $2
	note d5  $0b
	vol $5
	note gs4 $0b
	vol $2
	note g4  $0b
	vol $5
	note a4  $0b
	vol $2
	note gs4 $0b
	vol $5
	note as4 $0b
	vol $2
	note a4  $0b
	vol $5
	note e5  $0b
	vol $2
	note as4 $0b
	vol $5
	note a4  $0b
	vol $2
	note e5  $0b
	vol $5
	note as4 $0b
	vol $2
	note a4  $0b
	vol $5
	note e5  $0b
	vol $2
	note as4 $0b
	vol $5
	note a4  $0b
	vol $2
	note e5  $0b
	vol $5
	note as4 $0b
	vol $2
	note a4  $0b
	vol $5
	note g4  $0b
	vol $2
	note as4 $0b
	vol $5
	note gs4 $0b
	vol $2
	note g4  $0b
	vol $5
	note d5  $0b
	vol $2
	note gs4 $0b
	vol $5
	note g4  $0b
	vol $2
	note d5  $0b
	vol $5
	note gs4 $0b
	vol $2
	note g4  $0b
	vol $5
	note d5  $0b
	vol $2
	note gs4 $0b
	vol $5
	note g4  $0b
	vol $2
	note d5  $0b
	vol $5
	note gs4 $0b
	vol $2
	note g4  $0b
	vol $5
	note b4  $0b
	rest $0b
	note c5  $0b
	vol $2
	note b4  $0b
	vol $5
	note fs5 $0b
	vol $2
	note c5  $0b
	vol $5
	note b4  $0b
	vol $2
	note fs5 $0b
	vol $5
	note c5  $0b
	vol $2
	note b4  $0b
	vol $5
	note fs5 $0b
	vol $2
	note c5  $0b
	vol $5
	note b4  $0b
	vol $2
	note fs5 $0b
	vol $5
	note c5  $0b
	vol $2
	note b4  $0b
	vol $5
	note cs5 $0b
	vol $2
	note c5  $0b
	vol $5
	note d5  $0b
	vol $2
	note cs5 $0b
	vol $5
	note gs5 $0b
	vol $2
	note d5  $0b
	vol $5
	note cs5 $0b
	vol $2
	note gs5 $0b
	vol $5
	note d5  $0b
	vol $2
	note cs5 $0b
	vol $5
	note gs5 $0b
	vol $2
	note d5  $0b
	vol $5
	note cs5 $0b
	vol $2
	note gs5 $0b
	vol $5
	note d5  $0b
	vol $2
	note cs5 $0b
	goto musicf37ec
	cmdff

sound19Channel4:
	cmdf2
musicf396d:
	duty $0e
	note a2  $0b
	duty $0f
	note a2  $0b
	duty $0e
	note a2  $0b
	duty $0f
	note a2  $0b
	rest $2c
	duty $0e
	note a2  $0b
	duty $0f
	note a2  $0b
	duty $0e
	note a2  $0b
	duty $0f
	note a2  $0b
	rest $2c
	duty $0e
	note g2  $0b
	duty $0f
	note g2  $0b
	duty $0e
	note g2  $0b
	duty $0f
	note g2  $0b
	rest $2c
	duty $0e
	note g2  $0b
	duty $0f
	note g2  $0b
	duty $0e
	note g2  $0b
	duty $0f
	note g2  $0b
	rest $2c
	duty $0e
	note a2  $0b
	duty $0f
	note a2  $0b
	duty $0e
	note a2  $0b
	duty $0f
	note a2  $0b
	rest $2c
	duty $0e
	note a2  $0b
	duty $0f
	note a2  $0b
	duty $0e
	note a2  $0b
	duty $0f
	note a2  $0b
	rest $2c
	duty $0e
	note g2  $0b
	duty $0f
	note g2  $0b
	duty $0e
	note g2  $0b
	duty $0f
	note g2  $0b
	rest $2c
	duty $0e
	note g2  $0b
	duty $0f
	note g2  $0b
	duty $0e
	note g2  $0b
	duty $0f
	note g2  $0b
	rest $2c
	duty $0e
	note a2  $0b
	duty $0f
	note a2  $0b
	duty $0e
	note a2  $0b
	duty $0f
	note a2  $0b
	rest $2c
	duty $0e
	note a2  $0b
	duty $0f
	note a2  $0b
	duty $0e
	note a2  $0b
	duty $0f
	note a2  $0b
	rest $2c
	duty $0e
	note gs2 $0b
	duty $0f
	note gs2 $0b
	duty $0e
	note gs2 $0b
	duty $0f
	note gs2 $0b
	rest $2c
	duty $0e
	note gs2 $0b
	duty $0f
	note gs2 $0b
	duty $0e
	note gs2 $0b
	duty $0f
	note gs2 $0b
	rest $2c
	duty $0e
	note as2 $0b
	duty $0f
	note as2 $0b
	duty $0e
	note as2 $0b
	duty $0f
	note as2 $0b
	rest $2c
	duty $0e
	note as2 $0b
	duty $0f
	note as2 $0b
	duty $0e
	note as2 $0b
	duty $0f
	note as2 $0b
	rest $2c
	duty $0e
	note b2  $0b
	duty $0f
	note b2  $0b
	duty $0e
	note b2  $0b
	duty $0f
	note b2  $0b
	rest $2c
	duty $0e
	note b2  $0b
	duty $0f
	note b2  $0b
	duty $0e
	note b2  $0b
	duty $0f
	note b2  $0b
	rest $2c
	goto musicf396d
	cmdff

sound4eStart:

sound4eChannel2:
	duty $00
	vol $d
	cmdf8 $81
	note f4  $04
	cmdf8 $00
	vol $c
	note g2  $02
	vol $e
	cmdf8 $7f
	note g2  $07
	cmdff

sound4fStart:

sound4fChannel2:
	duty $02
	vol $b
	note g4  $02
	note b4  $02
	note as4 $02
	note c5  $02
	vol $a
	note b4  $02
	note cs5 $02
	note c5  $02
	note d5  $02
	vol $9
	note cs5 $02
	note ds5 $02
	note d5  $02
	note e5  $02
	vol $8
	note ds5 $02
	note f5  $02
	note e5  $02
	note fs5 $02
	vol $7
	note f5  $02
	note g5  $02
	vol $6
	note fs5 $02
	note gs5 $02
	vol $5
	note g5  $02
	note a5  $02
	vol $4
	note gs5 $02
	vol $3
	note as5 $02
	vol $2
	note c6  $02
	vol $1
	note f6  $02
	cmdff

sound50Start:

sound50Channel2:
	duty $00
	vol $d
	note gs7 $01
	vol $0
	rest $03
	vol $b
	env $0 $01
	note c8  $0a
	cmdff

sound51Start:

sound51Channel2:
	duty $02
	vol $d
	env $1 $00
	cmdf8 $f4
	note d6  $0a
	cmdf8 $00
	vol $8
	env $0 $01
	cmdf8 $e0
	note c5  $08
	cmdff

sound52Start:

sound52Channel2:
	duty $02
	vol $d
	cmdf8 $7f
	note e2  $05
	cmdf8 $00
	env $0 $00
	cmdf8 $81
	note cs3 $05
	cmdff

sound53Start:

sound53Channel2:
	duty $02
	vol $c
	env $0 $02
	cmdf8 $10
	note d4  $14
	cmdff

sound57Start:

sound57Channel2:
	duty $02
	vol $9
	note d5  $01
	note g5  $01
	note d6  $01
	cmdff

sounda5Start:

sounda5Channel7:
	cmdf0 $a0
	note $64 $03
	cmdf0 $00
	note $00 $01
	cmdf0 $90
	note $44 $03
	cmdf0 $00
	note $00 $01
	cmdf0 $90
	note $34 $03
	cmdf0 $00
	note $00 $01
	cmdf0 $80
	note $14 $03
	cmdf0 $00
	note $00 $01
	cmdf0 $30
	note $14 $03
	cmdf0 $00
	note $00 $01
	cmdf0 $30
	note $14 $03
	cmdff

sound91Start:

sound91Channel2:
	cmdf0 $d1
	.db $07 $d1 $04
	vol $1
	.db $07 $e1 $02
	vol $1
	.db $07 $d9 $02
	vol $3
	.db $07 $ce $04
	vol $1
	.db $07 $de $02
	vol $1
	.db $07 $d7 $02
	vol $5
	.db $07 $cc $04
	vol $2
	.db $07 $dc $02
	vol $1
	.db $07 $d5 $02
	vol $7
	.db $07 $ca $04
	vol $2
	.db $07 $da $02
	vol $2
	.db $07 $d3 $02
	vol $9
	.db $07 $c8 $04
	vol $3
	.db $07 $d8 $02
	vol $2
	.db $07 $d1 $02
	.db $07 $c6 $03
	vol $a
	.db $07 $c2 $04
	vol $3
	.db $07 $d2 $02
	vol $3
	.db $07 $cd $02
	vol $9
	.db $07 $c0 $04
	vol $4
	.db $07 $d0 $02
	vol $3
	.db $07 $cb $02
	vol $7
	.db $07 $be $04
	vol $3
	.db $07 $de $02
	vol $3
	.db $07 $c9 $02
	vol $5
	.db $07 $bc $04
	vol $3
	.db $07 $cc $02
	vol $2
	.db $07 $c7 $02
	vol $3
	.db $07 $b9 $04
	vol $2
	.db $07 $c9 $02
	vol $1
	.db $07 $c4 $02
	vol $2
	.db $07 $b6 $04
	vol $1
	.db $07 $c6 $02
	vol $1
	.db $07 $c1 $02
	vol $2
	.db $07 $af $04
	vol $1
	.db $07 $c1 $02
	vol $1
	.db $07 $bc $02
	vol $1
	.db $07 $ab $04
	env $0 $01
	vol $1
	.db $07 $bf $02
	cmdff

soundaeStart:

soundaeChannel2:
	duty $02
	env $0 $02
	vol $9
	note ds4 $06
	note as4 $06
	note d5  $06
	note as5 $06
	note ds6 $06
	note as5 $06
	note ds5 $06
	note as4 $06
	note ds4 $06
	note f4  $06
	note as4 $06
	note d5  $06
	note gs5 $06
	note f6  $06
	note gs5 $06
	note d5  $06
	note as4 $06
	note f4  $06
	note as5 $06
	note ds6 $06
	note as4 $06
	note g5  $06
	note g6  $06
	note ds6 $06
	note as5 $06
	note g5  $06
	note d6  $06
	note as5 $06
	note g5  $06
	note ds5 $06
	note ds4 $06
	note as4 $06
	note d5  $06
	note as5 $06
	note ds6 $06
	note g6  $06
	env $0 $05
	note as6 $2a
	cmdff

soundaeChannel3:
	duty $02
	env $0 $02
	vol $0
	note gs3 $0a
	vol $5
	note ds4 $06
	note as4 $06
	note d5  $06
	note as5 $06
	note ds6 $06
	note as5 $06
	note ds5 $06
	note as4 $06
	note ds4 $06
	note f4  $06
	note as4 $06
	note d5  $06
	note gs5 $06
	note f6  $06
	note gs5 $06
	note d5  $06
	note as4 $06
	note f4  $06
	note as5 $06
	note ds6 $06
	note as4 $06
	note g5  $06
	note g6  $06
	note ds6 $06
	note as5 $06
	note g5  $06
	note d6  $06
	note as5 $06
	note g5  $06
	note ds5 $06
	note ds4 $06
	note as4 $06
	note d5  $06
	note as5 $06
	note ds6 $06
	note g6  $06
	env $0 $05
	note as6 $20
	cmdff

soundaeChannel5:
	duty $0e
	rest $c8
	rest $3a
	cmdff

soundaeChannel7:
	cmdf0 $00
	note $00 $c8
	note $00 $3a
	cmdff

soundafStart:

soundafChannel2:
	duty $02
	env $0 $02
	vol $9
	note c5  $03
	note e5  $04
	note g5  $03
	note c6  $07
	note b5  $07
	note a5  $07
	note b5  $07
	note g5  $07
	note d6  $07
	note c6  $07
	note b5  $07
	note a5  $07
	note b5  $07
	note c6  $07
	note d6  $07
	note g5  $07
	note a5  $07
	note g5  $07
	note e5  $07
	note f5  $07
	rest $07
	note a5  $07
	rest $07
	note c6  $07
	rest $07
	note d6  $07
	rest $07
	note e4  $04
	note g4  $03
	note b4  $04
	note c5  $03
	note e5  $04
	note g5  $03
	note b5  $04
	env $0 $06
	note e6  $2d
	rest $0a
	cmdff

soundafChannel3:
	duty $02
	env $0 $02
	vol $0
	note gs3 $0a
	vol $5
	note c5  $04
	note e5  $03
	note g5  $04
	note c6  $07
	note b5  $07
	note a5  $07
	note b5  $07
	note g5  $07
	note d6  $07
	note c6  $07
	note b5  $07
	note a5  $07
	note b5  $07
	note c6  $07
	note d6  $07
	note g5  $07
	note a5  $07
	note g5  $07
	note e5  $07
	note f5  $07
	rest $07
	note a5  $07
	rest $07
	note c6  $07
	rest $07
	note d6  $07
	rest $07
	note e4  $03
	note g4  $04
	note b4  $03
	note c5  $04
	note e5  $03
	note g5  $04
	note b5  $03
	env $0 $06
	note e6  $2d
	cmdff

soundafChannel5:
	duty $0e
	rest $c8
	rest $3a
	cmdff

soundafChannel7:
	cmdf0 $00
	note $00 $c8
	note $00 $3a
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
.bank $3d slot 1
.org 0

sound1bStart:

sound27Start:

sound31Start:

sound38Start:

sound46Start:

sound1aStart:

sound1bChannel6:
sound27Channel6:
sound31Channel4:
sound31Channel6:
sound38Channel6:
sound46Channel6:
sound1aChannel6:
	cmdff

sound20Start:

sound20Channel1:
	vibrato $00
	env $0 $00
	duty $02
musicf4007:
	vol $0
	note gs3 $20
	vol $6
	note e4  $04
	rest $02
	vol $3
	note e4  $02
	vol $6
	note e4  $04
	rest $02
	vol $3
	note e4  $02
	vol $6
	note e4  $04
	rest $02
	vol $3
	note e4  $02
	vol $6
	note e4  $04
	rest $02
	vol $3
	note e4  $02
	vol $6
	note e4  $04
	rest $02
	vol $3
	note e4  $04
	rest $02
	vol $1
	note e4  $04
	vol $6
	note d4  $04
	rest $04
	vol $3
	note d4  $04
	rest $04
	vol $6
	note d4  $04
	rest $04
	vol $3
	note d4  $04
	rest $04
	vol $6
	note g4  $04
	rest $04
	vol $3
	note g4  $04
	rest $04
	vol $6
	note g4  $04
	rest $04
	vol $3
	note g4  $04
	rest $04
	vol $6
	note fs4 $04
	rest $04
	vol $3
	note fs4 $04
	rest $04
	vol $1
	note fs4 $04
	rest $1c
	vol $6
	note g4  $04
	rest $02
	vol $3
	note g4  $02
	vol $6
	note g4  $04
	rest $02
	vol $3
	note g4  $02
	vol $6
	note g4  $04
	rest $02
	vol $3
	note g4  $02
	vol $6
	note g4  $04
	rest $02
	vol $3
	note g4  $02
	vol $6
	note g4  $04
	rest $02
	vol $3
	note g4  $04
	rest $06
	vol $6
	note fs4 $04
	rest $04
	vol $3
	note fs4 $04
	rest $04
	vol $6
	note fs4 $04
	rest $04
	vol $3
	note fs4 $04
	rest $04
	vol $6
	note e4  $04
	rest $04
	vol $3
	note e4  $04
	rest $04
	vol $6
	note e4  $04
	rest $04
	vol $3
	note e4  $04
	rest $04
	vol $6
	note fs4 $04
	rest $04
	vol $3
	note fs4 $04
	rest $04
	vol $1
	note fs4 $04
	rest $1c
	vol $6
	note e4  $04
	rest $02
	vol $3
	note e4  $02
	vol $6
	note e4  $04
	rest $02
	vol $3
	note e4  $02
	vol $6
	note e4  $04
	rest $02
	vol $3
	note e4  $02
	vol $6
	note e4  $04
	rest $02
	vol $3
	note e4  $02
	vol $6
	note e4  $04
	rest $02
	vol $3
	note e4  $04
	rest $06
	vol $6
	note d4  $04
	rest $04
	vol $3
	note d4  $04
	rest $04
	vol $6
	note e4  $04
	rest $04
	vol $3
	note e4  $04
	rest $04
	vol $6
	note fs4 $04
	rest $04
	vol $3
	note fs4 $04
	rest $04
	vol $6
	note g4  $04
	rest $04
	vol $3
	note g4  $04
	rest $04
	vol $6
	note fs4 $04
	rest $04
	vol $3
	note fs4 $04
	rest $04
	vol $6
	note e4  $04
	rest $04
	vol $3
	note e4  $04
	rest $04
	vol $6
	note d4  $04
	rest $04
	vol $3
	note d4  $04
	rest $04
	vol $6
	note e4  $18
	vol $3
	note e4  $08
	vol $6
	note e4  $04
	rest $04
	vol $3
	note e4  $04
	rest $04
	vol $6
	note g4  $18
	vol $3
	note g4  $08
	vol $6
	note d4  $04
	rest $04
	vol $3
	note d4  $04
	rest $04
	vol $6
	note e4  $14
	vol $3
	note e4  $0c
	rest $20
	vol $6
	note e4  $04
	rest $02
	vol $3
	note e4  $02
	vol $6
	note e4  $04
	rest $02
	vol $3
	note e4  $02
	vol $6
	note e4  $04
	rest $02
	vol $3
	note e4  $02
	vol $6
	note e4  $04
	rest $02
	vol $3
	note e4  $02
	vol $6
	note e4  $04
	rest $04
	vol $3
	note e4  $04
	rest $04
	vol $6
	note d4  $04
	rest $04
	vol $3
	note d4  $04
	rest $04
	vol $6
	note d4  $04
	rest $04
	vol $3
	note d4  $04
	rest $04
	vol $6
	note g4  $04
	rest $04
	vol $3
	note g4  $04
	rest $04
	vol $6
	note g4  $04
	rest $04
	vol $3
	note g4  $04
	rest $04
	vol $6
	note fs4 $04
	rest $04
	vol $3
	note fs4 $04
	rest $24
	vol $6
	note b4  $04
	rest $02
	vol $3
	note b4  $02
	vol $6
	note b4  $04
	rest $02
	vol $3
	note b4  $02
	vol $6
	note b4  $04
	rest $02
	vol $3
	note b4  $02
	vol $6
	note b4  $04
	rest $02
	vol $3
	note b4  $02
	vol $6
	note b4  $04
	rest $02
	vol $3
	note b4  $04
	rest $06
	vol $6
	note a4  $05
	rest $03
	vol $3
	note a4  $05
	rest $03
	vol $6
	note b4  $05
	rest $03
	vol $3
	note b4  $05
	rest $03
	vol $6
	note c5  $05
	rest $03
	vol $3
	note c5  $05
	rest $03
	vol $6
	note d5  $05
	rest $03
	vol $3
	note d5  $05
	rest $03
	vol $6
	note c5  $05
	rest $03
	vol $3
	note c5  $05
	rest $23
	vol $6
	note b4  $04
	rest $02
	vol $3
	note b4  $02
	vol $6
	note b4  $04
	rest $02
	vol $3
	note b4  $02
	vol $6
	note b4  $04
	rest $02
	vol $3
	note b4  $02
	vol $6
	note b4  $04
	rest $02
	vol $3
	note b4  $02
	vol $6
	note b4  $04
	rest $02
	vol $3
	note b4  $04
	rest $06
	vol $6
	note c5  $04
	rest $04
	vol $3
	note c5  $04
	rest $04
	vol $6
	note b4  $04
	rest $04
	vol $3
	note b4  $04
	rest $04
	vol $6
	note a4  $04
	rest $04
	vol $3
	note a4  $04
	rest $04
	vol $6
	note e4  $04
	rest $04
	vol $3
	note e4  $04
	rest $04
	vol $6
	note c4  $04
	rest $04
	vol $3
	note c4  $04
	rest $04
	vol $6
	note g4  $08
	note fs4 $08
	note e4  $08
	note d4  $08
	note e4  $30
	vol $3
	note e4  $10
	vol $1
	note e4  $08
	rest $18
	goto musicf4007
	cmdff

sound20Channel0:
	vibrato $00
	env $0 $00
	duty $02
musicf4298:
	vol $0
	note gs3 $20
	vol $6
	note c4  $04
	rest $02
	vol $3
	note c4  $02
	vol $6
	note c4  $04
	rest $02
	vol $3
	note c4  $02
	vol $6
	note c4  $04
	rest $02
	vol $3
	note c4  $02
	vol $6
	note c4  $04
	rest $02
	vol $3
	note c4  $02
	vol $6
	note c4  $04
	rest $02
	vol $3
	note c4  $04
	rest $06
	vol $6
	note b3  $04
	rest $04
	vol $3
	note b3  $04
	rest $04
	vol $6
	note b3  $04
	rest $04
	vol $3
	note b3  $04
	rest $04
	vol $6
	note e4  $04
	rest $04
	vol $3
	note e4  $04
	rest $04
	vol $6
	note e4  $04
	rest $04
	vol $3
	note e4  $04
	rest $04
	vol $6
	note d4  $04
	rest $04
	vol $3
	note d4  $04
	rest $24
	vol $6
	note e4  $04
	rest $02
	vol $3
	note e4  $02
	vol $6
	note e4  $04
	rest $02
	vol $3
	note e4  $02
	vol $6
	note e4  $04
	rest $02
	vol $3
	note e4  $02
	vol $6
	note e4  $04
	rest $02
	vol $3
	note e4  $02
	vol $6
	note e4  $04
	rest $02
	vol $3
	note e4  $04
	rest $06
	vol $6
	note d4  $04
	rest $04
	vol $3
	note d4  $04
	rest $04
	vol $6
	note d4  $04
	rest $04
	vol $3
	note d4  $04
	rest $04
	vol $6
	note c4  $04
	rest $04
	vol $3
	note c4  $04
	rest $04
	vol $6
	note c4  $04
	rest $04
	vol $3
	note c4  $04
	rest $04
	vol $6
	note d4  $04
	rest $04
	vol $3
	note d4  $04
	rest $24
	vol $6
	note c4  $04
	rest $02
	vol $3
	note c4  $02
	vol $6
	note c4  $04
	rest $02
	vol $3
	note c4  $02
	vol $6
	note c4  $04
	rest $02
	vol $3
	note c4  $02
	vol $6
	note c4  $04
	rest $02
	vol $3
	note c4  $02
	vol $6
	note c4  $04
	rest $02
	vol $3
	note c4  $04
	rest $06
	vol $6
	note b3  $04
	rest $04
	vol $3
	note b3  $04
	rest $04
	vol $6
	note c4  $04
	rest $04
	vol $3
	note c4  $04
	rest $04
	vol $6
	note d4  $04
	rest $04
	vol $3
	note d4  $04
	rest $04
	vol $6
	note e4  $04
	rest $04
	vol $3
	note e4  $04
	rest $04
	vol $6
	note d4  $04
	rest $04
	vol $3
	note d4  $04
	rest $04
	vol $6
	note c4  $04
	rest $04
	vol $3
	note c4  $04
	rest $04
	vol $6
	note b3  $04
	rest $04
	vol $3
	note b3  $04
	rest $04
	vol $6
	note c4  $14
	vol $3
	note c4  $0c
	vol $6
	note c4  $04
	rest $04
	vol $3
	note c4  $04
	rest $04
	vol $6
	note d4  $18
	vol $3
	note d4  $08
	vol $6
	note b3  $04
	rest $04
	vol $3
	note b3  $04
	rest $04
	vol $6
	note c4  $14
	vol $3
	note c4  $0c
	rest $20
	vol $6
	note c4  $04
	rest $02
	vol $3
	note c4  $02
	vol $6
	note c4  $04
	rest $02
	vol $3
	note c4  $02
	vol $6
	note c4  $04
	rest $02
	vol $3
	note c4  $02
	vol $6
	note c4  $04
	rest $02
	vol $3
	note c4  $02
	vol $6
	note c4  $04
	rest $02
	vol $3
	note c4  $04
	rest $06
	vol $6
	note b3  $04
	rest $04
	vol $3
	note b3  $04
	rest $04
	vol $6
	note b3  $04
	rest $04
	vol $3
	note b3  $04
	rest $04
	vol $6
	note c4  $04
	rest $04
	vol $3
	note c4  $04
	rest $04
	vol $6
	note e4  $04
	rest $04
	vol $3
	note e4  $04
	rest $04
	vol $6
	note d4  $04
	rest $04
	vol $3
	note d4  $04
	rest $24
	vol $6
	note e4  $04
	rest $02
	vol $3
	note e4  $02
	vol $6
	note e4  $04
	rest $02
	vol $3
	note e4  $02
	vol $6
	note e4  $04
	rest $02
	vol $3
	note e4  $02
	vol $6
	note e4  $04
	rest $02
	vol $3
	note e4  $02
	vol $6
	note e4  $04
	rest $02
	vol $3
	note e4  $04
	rest $06
	vol $6
	note d4  $04
	rest $04
	vol $3
	note d4  $04
	rest $04
	vol $6
	note d4  $04
	rest $04
	vol $3
	note d4  $04
	rest $04
	vol $6
	note f4  $04
	rest $04
	vol $3
	note f4  $04
	rest $04
	vol $6
	note e4  $04
	rest $04
	vol $3
	note e4  $04
	rest $04
	vol $6
	note c4  $04
	rest $04
	vol $3
	note c4  $04
	rest $24
	vol $6
	note g4  $04
	rest $02
	vol $3
	note g4  $02
	vol $6
	note g4  $04
	rest $02
	vol $3
	note g4  $02
	vol $6
	note g4  $04
	rest $02
	vol $3
	note g4  $02
	vol $6
	note g4  $04
	rest $02
	vol $3
	note g4  $02
	vol $6
	note g4  $04
	rest $02
	vol $3
	note g4  $04
	rest $06
	vol $6
	note a4  $04
	rest $04
	vol $3
	note a4  $04
	rest $04
	vol $6
	note g4  $04
	rest $04
	vol $3
	note g4  $04
	rest $04
	vol $6
	note e4  $04
	rest $04
	vol $3
	note e4  $04
	rest $04
	vol $6
	note c4  $04
	rest $04
	vol $3
	note c4  $04
	rest $04
	vol $6
	note a3  $04
	rest $04
	vol $3
	note a3  $04
	rest $84
	goto musicf4298
	cmdff

sound20Channel4:
musicf4503:
	duty $0e
	note a2  $20
	note a3  $04
	rest $04
	note a3  $04
	rest $04
	note a3  $04
	rest $04
	note a3  $04
	rest $04
	note a3  $04
	rest $3c
	note b2  $20
	note c3  $20
	note c4  $04
	rest $04
	note c4  $04
	rest $04
	note c4  $04
	rest $04
	note c4  $04
	rest $04
	note c4  $04
	rest $0c
	note b3  $04
	rest $0c
	note b3  $04
	rest $0c
	note a3  $04
	rest $0c
	note a3  $04
	rest $0c
	note b3  $04
	rest $0c
	note a2  $20
	note a3  $04
	rest $04
	note a3  $04
	rest $04
	note a3  $04
	rest $04
	note a3  $04
	rest $04
	note a3  $04
	rest $1c
	note b2  $3c
	rest $04
	note b2  $20
	note a2  $12
	rest $0e
	note a2  $08
	rest $08
	note b2  $1c
	rest $04
	note g2  $04
	rest $0c
	note a2  $14
	rest $0c
	note a2  $20
	note a3  $04
	rest $04
	note a3  $04
	rest $04
	note a3  $04
	rest $04
	note a3  $04
	rest $04
	note a3  $04
	rest $1c
	note b2  $14
	rest $0c
	note e3  $05
	rest $0b
	note d3  $05
	rest $0b
	note c3  $20
	note c4  $04
	rest $04
	note c4  $04
	rest $04
	note c4  $04
	rest $04
	note c4  $04
	rest $04
	note c4  $04
	rest $1c
	note b2  $20
	note e2  $0d
	rest $03
	note g2  $0d
	rest $03
	note a2  $20
	note c4  $04
	rest $04
	note c4  $04
	rest $04
	note c4  $04
	rest $04
	note c4  $04
	rest $04
	duty $0e
	note c4  $04
	duty $0f
	note c4  $0c
	duty $0e
	note e3  $04
	duty $0f
	note e3  $0c
	duty $0e
	note e3  $04
	duty $0f
	note e3  $0c
	duty $0e
	note c3  $04
	duty $0f
	note c3  $0c
	duty $0e
	note c3  $04
	duty $0f
	note c3  $0c
	duty $0e
	note a2  $04
	duty $0f
	note a2  $0c
	duty $0e
	note d3  $20
	note a2  $08
	rest $08
	note fs2 $20
	note a2  $08
	rest $08
	note d2  $20
	goto musicf4503
	cmdff

sound20Channel6:
musicf460f:
	vol $5
	note $26 $10
	note $26 $08
	note $26 $08
	note $26 $10
	note $26 $10
	note $26 $08
	note $26 $08
	note $26 $08
	note $26 $08
	note $26 $10
	note $26 $08
	note $26 $04
	note $26 $04
	note $26 $02
	vol $4
	note $26 $02
	vol $4
	note $26 $04
	vol $4
	note $26 $02
	note $26 $02
	vol $3
	note $26 $04
	note $26 $02
	vol $4
	note $26 $02
	vol $4
	note $26 $04
	vol $4
	note $26 $02
	vol $5
	note $26 $02
	note $26 $04
	note $26 $10
	note $26 $08
	note $26 $08
	note $26 $10
	note $26 $10
	note $26 $08
	note $26 $08
	note $26 $08
	note $26 $08
	note $26 $10
	note $26 $08
	note $26 $04
	note $26 $04
	note $26 $02
	vol $4
	note $26 $02
	vol $4
	note $26 $04
	vol $4
	note $26 $02
	note $26 $02
	vol $3
	note $26 $04
	note $26 $02
	vol $4
	note $26 $02
	vol $4
	note $26 $04
	vol $4
	note $26 $02
	vol $5
	note $26 $02
	note $26 $04
	note $26 $10
	note $26 $08
	note $26 $08
	note $26 $10
	note $26 $10
	note $26 $08
	note $26 $08
	note $26 $08
	note $26 $08
	note $26 $10
	note $26 $08
	note $26 $04
	note $26 $04
	note $26 $02
	vol $4
	note $26 $02
	vol $4
	note $26 $04
	vol $4
	note $26 $02
	note $26 $02
	vol $3
	note $26 $04
	note $26 $02
	vol $4
	note $26 $02
	vol $4
	note $26 $04
	vol $4
	note $26 $02
	vol $5
	note $26 $02
	note $26 $04
	note $26 $10
	note $26 $08
	note $26 $08
	note $26 $10
	note $26 $10
	note $26 $08
	note $26 $08
	note $26 $08
	note $26 $08
	note $26 $10
	note $26 $08
	note $26 $04
	note $26 $04
	note $26 $02
	vol $4
	note $26 $02
	vol $4
	note $26 $04
	vol $4
	note $26 $02
	note $26 $02
	vol $3
	note $26 $04
	note $26 $02
	vol $4
	note $26 $02
	vol $4
	note $26 $04
	vol $4
	note $26 $02
	vol $5
	note $26 $02
	note $26 $04
	note $26 $10
	note $26 $08
	note $26 $08
	note $26 $10
	note $26 $10
	note $26 $08
	note $26 $08
	note $26 $08
	note $26 $08
	note $26 $10
	note $26 $08
	note $26 $04
	note $26 $04
	note $26 $02
	vol $4
	note $26 $02
	vol $4
	note $26 $04
	vol $4
	note $26 $02
	note $26 $02
	vol $3
	note $26 $04
	note $26 $02
	vol $4
	note $26 $02
	vol $4
	note $26 $04
	vol $4
	note $26 $02
	vol $5
	note $26 $02
	note $26 $04
	note $26 $10
	note $26 $08
	note $26 $08
	note $26 $10
	note $26 $10
	note $26 $08
	note $26 $08
	note $26 $08
	note $26 $08
	note $26 $10
	note $26 $08
	note $26 $04
	note $26 $04
	note $26 $02
	vol $4
	note $26 $02
	vol $4
	note $26 $04
	vol $4
	note $26 $02
	note $26 $02
	vol $3
	note $26 $04
	note $26 $02
	vol $4
	note $26 $02
	vol $4
	note $26 $04
	vol $4
	note $26 $02
	vol $5
	note $26 $02
	note $26 $04
	note $26 $10
	note $26 $08
	note $26 $08
	note $26 $10
	note $26 $10
	note $26 $08
	note $26 $08
	note $26 $08
	note $26 $08
	note $26 $10
	note $26 $08
	note $26 $04
	note $26 $04
	note $26 $02
	vol $4
	note $26 $02
	vol $4
	note $26 $04
	vol $4
	note $26 $02
	note $26 $02
	vol $3
	note $26 $04
	note $26 $02
	vol $4
	note $26 $02
	vol $4
	note $26 $04
	vol $4
	note $26 $02
	vol $5
	note $26 $02
	note $26 $04
	note $26 $10
	note $26 $10
	note $26 $08
	note $26 $08
	note $26 $08
	note $26 $08
	note $26 $10
	note $26 $08
	note $26 $04
	note $26 $04
	note $26 $02
	vol $4
	note $26 $02
	vol $4
	note $26 $04
	vol $4
	note $26 $02
	note $26 $02
	vol $3
	note $26 $04
	note $26 $02
	vol $4
	note $26 $02
	vol $4
	note $26 $04
	vol $4
	note $26 $02
	vol $5
	note $26 $02
	note $26 $04
	goto musicf460f
	cmdff

sound21Start:

sound21Channel1:
	vibrato $e1
	env $0 $00
	duty $02
musicf47e4:
	vol $6
	note d4  $07
	rest $03
	vol $3
	note d4  $04
	vol $6
	note d4  $03
	vol $3
	note d4  $04
	vol $6
	note d4  $03
	vol $3
	note d4  $04
	vol $6
	note f4  $54
	vibrato $01
	env $0 $00
	vol $5
	note f4  $1c
	vol $1
	note f4  $1c
	vibrato $e1
	env $0 $00
	vol $6
	note e4  $2a
	vol $3
	note e4  $0e
	vol $6
	note ds4 $0e
	note a3  $07
	rest $03
	vol $3
	note a3  $04
	note ds4 $0e
	note a3  $07
	rest $03
	vol $1
	note a3  $04
	note ds4 $0e
	note a3  $07
	rest $03
	vol $0
	note a3  $04
	note ds4 $0e
	note a3  $07
	rest $03
	vol $0
	note a3  $04
	vol $6
	note ds4 $0e
	note a4  $07
	rest $03
	vol $3
	note a4  $04
	vol $5
	note ds5 $0e
	note a5  $07
	rest $03
	vol $2
	note a5  $04
	vol $3
	note ds4 $0e
	note a4  $07
	rest $03
	vol $1
	note a4  $04
	vol $2
	note ds5 $0e
	note a5  $07
	rest $03
	vol $1
	note a5  $04
	vol $6
	note f4  $07
	rest $03
	vol $3
	note f4  $04
	vol $6
	note f4  $03
	vol $3
	note f4  $04
	vol $6
	note f4  $03
	vol $3
	note f4  $04
	vol $6
	note gs4 $54
	vibrato $01
	env $0 $00
	vol $4
	note gs4 $38
	vol $2
	note gs4 $1c
	vibrato $e1
	env $0 $00
	vol $6
	note g4  $0e
	note gs4 $07
	note g4  $07
	note fs4 $0e
	note cs4 $07
	rest $03
	vol $3
	note cs4 $04
	note fs4 $0e
	note cs4 $07
	rest $03
	vol $1
	note cs4 $04
	note fs4 $0e
	note cs4 $07
	rest $03
	vol $0
	note cs4 $04
	note fs4 $0e
	note cs4 $07
	rest $03
	vol $0
	note cs4 $04
	vol $6
	note g4  $0e
	note cs4 $07
	rest $03
	vol $3
	note cs4 $04
	note g4  $0e
	note cs4 $07
	rest $03
	vol $1
	note cs4 $04
	vol $6
	note g4  $0e
	note cs5 $07
	rest $03
	vol $3
	note cs5 $04
	note g4  $0e
	note cs5 $07
	rest $03
	vol $1
	note cs5 $04
	vol $6
	note a4  $07
	note e5  $07
	note a5  $07
	rest $03
	vol $3
	note a5  $04
	vol $6
	note a4  $07
	note e5  $07
	note a5  $07
	rest $03
	vol $3
	note a5  $04
	vol $6
	note as4 $07
	note f5  $07
	note as5 $07
	rest $03
	vol $3
	note as5 $07
	rest $19
	vol $6
	note a4  $07
	note e5  $07
	note a5  $07
	rest $03
	vol $3
	note a5  $04
	vol $6
	note a4  $07
	note e5  $07
	note a5  $07
	rest $03
	vol $3
	note a5  $04
	vol $6
	note gs5 $07
	note gs4 $03
	rest $04
	note gs4 $07
	rest $03
	vol $3
	note gs4 $07
	rest $19
	vol $6
	note a4  $07
	note e5  $07
	vol $6
	note a5  $07
	rest $03
	vol $3
	note a5  $04
	vol $6
	note as4 $07
	note f5  $07
	note as5 $07
	rest $03
	vol $3
	note as5 $04
	vol $6
	note b4  $07
	note fs5 $07
	note b5  $07
	rest $03
	vol $3
	note b5  $04
	vol $6
	note c5  $07
	note g5  $07
	note c6  $07
	rest $03
	vol $3
	note c6  $04
	vol $6
	note d6  $07
	note cs6 $07
	note ds6 $07
	note d6  $07
	note cs6 $07
	note c6  $07
	note d6  $07
	note cs6 $07
	note c6  $07
	note b5  $07
	note cs6 $07
	note c6  $07
	note b5  $07
	note as5 $07
	note c6  $07
	note b5  $07
	goto musicf47e4
	cmdff

sound21Channel0:
	vibrato $e1
	env $0 $00
	duty $02
musicf497c:
	vol $6
	note a2  $07
	rest $07
	note b2  $07
	vol $3
	note a2  $07
	vol $6
	note c3  $07
	vol $3
	note b2  $07
	vol $6
	note d3  $07
	vol $3
	note c3  $07
	vol $6
	note ds3 $07
	vol $3
	note d3  $07
	vol $6
	note d3  $07
	vol $3
	note ds3 $07
	vol $6
	note c3  $07
	vol $3
	note d3  $07
	vol $6
	note b2  $07
	vol $3
	note c3  $07
	vol $6
	note a2  $07
	vol $3
	note b2  $07
	vol $6
	note b2  $07
	vol $3
	note a2  $07
	vol $6
	note c3  $07
	vol $3
	note b2  $07
	vol $6
	note d3  $07
	vol $3
	note c3  $07
	vol $6
	note ds3 $07
	vol $3
	note d3  $07
	vol $6
	note d3  $07
	vol $3
	note ds3 $07
	vol $6
	note c3  $07
	vol $3
	note d3  $07
	vol $6
	note b2  $07
	vol $3
	note c3  $07
	vol $6
	note a2  $07
	vol $3
	note b2  $07
	vol $6
	note b2  $07
	vol $3
	note a2  $07
	vol $6
	note c3  $07
	vol $3
	note b2  $07
	vol $6
	note d3  $07
	vol $3
	note c3  $07
	vol $6
	note ds3 $07
	vol $3
	note d3  $07
	vol $6
	note d3  $07
	vol $3
	note ds3 $07
	vol $6
	note c3  $07
	vol $3
	note d3  $07
	vol $6
	note b2  $07
	vol $3
	note c3  $07
	vol $6
	note a2  $07
	vol $3
	note b2  $07
	vol $6
	note b2  $07
	vol $3
	note a2  $07
	vol $6
	note c3  $07
	vol $3
	note b2  $07
	vol $6
	note d3  $07
	vol $3
	note c3  $07
	vol $6
	note ds3 $07
	vol $3
	note d3  $07
	vol $6
	note d3  $07
	vol $3
	note ds3 $07
	vol $6
	note c3  $07
	vol $3
	note d3  $07
	vol $6
	note b2  $07
	vol $3
	note c3  $07
	vol $6
	note a2  $07
	vol $3
	note b2  $07
	vol $6
	note b2  $07
	vol $3
	note a2  $07
	vol $6
	note c3  $07
	vol $3
	note b2  $07
	vol $6
	note d3  $07
	vol $3
	note c3  $07
	vol $6
	note ds3 $07
	vol $3
	note d3  $07
	vol $6
	note d3  $07
	vol $3
	note ds3 $07
	vol $6
	note c3  $07
	vol $3
	note d3  $07
	vol $6
	note b2  $07
	vol $3
	note c3  $07
	vol $6
	note a2  $07
	vol $3
	note b2  $07
	vol $6
	note b2  $07
	vol $3
	note a2  $07
	vol $6
	note c3  $07
	vol $3
	note b2  $07
	vol $6
	note d3  $07
	vol $3
	note c3  $07
	vol $6
	note ds3 $07
	vol $3
	note d3  $07
	vol $6
	note d3  $07
	vol $3
	note ds3 $07
	vol $6
	note c3  $07
	vol $3
	note d3  $07
	vol $6
	note b2  $07
	vol $3
	note c3  $07
	vol $6
	note a2  $07
	vol $3
	note b2  $07
	vol $6
	note b2  $07
	vol $3
	note a2  $07
	vol $6
	note c3  $07
	vol $3
	note b2  $07
	vol $6
	note d3  $07
	vol $3
	note c3  $07
	vol $6
	note ds3 $07
	vol $3
	note d3  $07
	vol $6
	note d3  $07
	vol $3
	note ds3 $07
	vol $6
	note c3  $07
	vol $3
	note d3  $07
	vol $6
	note b2  $07
	vol $3
	note c3  $07
	vol $6
	note a2  $07
	vol $3
	note b2  $07
	vol $6
	note b2  $07
	vol $3
	note a2  $07
	vol $6
	note c3  $07
	vol $3
	note b2  $07
	vol $6
	note d3  $07
	vol $3
	note c3  $07
	vol $6
	note ds3 $07
	vol $3
	note d3  $07
	vol $6
	note d3  $07
	vol $3
	note ds3 $07
	vol $6
	note c3  $07
	vol $3
	note d3  $07
	vol $6
	note b2  $07
	vol $3
	note c3  $07
	vol $6
	note cs3 $07
	vol $3
	note b2  $07
	vol $6
	note ds3 $07
	note e3  $07
	note cs3 $07
	note e3  $07
	note ds3 $07
	note e3  $07
	note d3  $07
	note f3  $07
	note e3  $07
	note f3  $07
	note d3  $07
	note f3  $07
	note e3  $07
	note f3  $07
	note cs3 $07
	note e3  $07
	note ds3 $07
	note e3  $07
	note cs3 $07
	note e3  $07
	note ds3 $07
	note e3  $07
	note c3  $07
	note ds3 $07
	note d3  $07
	note ds3 $07
	note c3  $07
	note ds3 $07
	note d3  $07
	note ds3 $07
	note cs3 $07
	note e3  $07
	note ds3 $07
	note e3  $07
	note d3  $07
	note f3  $07
	note e3  $07
	note f3  $07
	note ds3 $07
	note fs3 $07
	note f3  $07
	note fs3 $07
	note e3  $07
	note g3  $07
	vol $6
	note fs3 $07
	note g3  $07
	note as5 $07
	note a5  $07
	note b5  $07
	note as5 $07
	note a5  $07
	note gs5 $07
	note as5 $07
	note a5  $07
	note gs5 $07
	note g5  $07
	note a5  $07
	note gs5 $07
	note g5  $07
	note fs5 $07
	note gs5 $07
	note g5  $07
	goto musicf497c
	cmdff

sound21Channel4:
musicf4b82:
	duty $0e
	note d2  $0e
	note e2  $0e
	note f2  $0e
	note g2  $0e
	note gs2 $0e
	note g2  $0e
	note f2  $0e
	note e2  $0e
	note d2  $0e
	note e2  $0e
	note f2  $0e
	note g2  $0e
	note gs2 $0e
	note g2  $0e
	note f2  $0e
	note e2  $0e
	note d2  $0e
	note e2  $0e
	note f2  $0e
	note g2  $0e
	note gs2 $0e
	note g2  $0e
	note f2  $0e
	note e2  $0e
	note d2  $0e
	note e2  $0e
	note f2  $0e
	note g2  $0e
	note gs2 $0e
	note g2  $0e
	note f2  $0e
	note e2  $0e
	note d2  $0e
	note e2  $0e
	note f2  $0e
	note g2  $0e
	note gs2 $0e
	note g2  $0e
	note f2  $0e
	note e2  $0e
	note d2  $0e
	note e2  $0e
	note f2  $0e
	note g2  $0e
	note gs2 $0e
	note g2  $0e
	note f2  $0e
	note e2  $0e
	note d2  $0e
	note e2  $0e
	note f2  $0e
	note g2  $0e
	note gs2 $0e
	note g2  $0e
	note f2  $0e
	note e2  $0e
	note d2  $0e
	note e2  $0e
	note f2  $0e
	note g2  $0e
	note gs2 $0e
	note g2  $0e
	note f2  $0e
	note e2  $0e
	note a1  $03
	rest $04
	note a1  $03
	rest $0b
	note a1  $03
	rest $04
	note a1  $03
	rest $04
	note a1  $07
	rest $07
	note a1  $03
	rest $04
	note as1 $03
	rest $04
	note as1 $07
	rest $07
	note as1 $03
	rest $04
	note as1 $03
	rest $04
	note as1 $02
	rest $05
	note as1 $02
	rest $05
	note as1 $03
	rest $04
	note a1  $03
	rest $04
	note a1  $03
	rest $0b
	note a1  $03
	rest $04
	note a1  $03
	rest $04
	note a1  $07
	rest $07
	note a1  $03
	rest $04
	note gs1 $03
	rest $04
	note gs1 $07
	rest $07
	note gs1 $03
	rest $04
	note gs1 $03
	rest $04
	note gs1 $02
	rest $05
	note gs1 $02
	rest $05
	note gs1 $03
	rest $04
	note a1  $03
	rest $04
	note a1  $07
	rest $07
	note a1  $03
	rest $04
	note as1 $03
	rest $04
	note as1 $07
	rest $07
	note as1 $03
	rest $04
	note b1  $03
	rest $04
	note b1  $07
	rest $07
	note b1  $03
	rest $04
	note c2  $03
	rest $04
	note c2  $07
	rest $07
	note c2  $07
	note cs2 $07
	note d2  $07
	note c2  $07
	note cs2 $07
	note b1  $07
	note c2  $07
	note as1 $07
	note b1  $07
	note a1  $07
	note as1 $07
	note gs1 $07
	note a1  $07
	note g1  $07
	note gs1 $07
	note fs1 $07
	note g1  $07
	goto musicf4b82
	cmdff

sound21Channel6:
musicf4cbe:
	vol $2
	note $2a $07
	note $2a $07
	vol $2
	note $2a $07
	note $2a $07
	vol $3
	note $2a $07
	vol $2
	note $2a $07
	note $2a $07
	note $2a $07
	vol $2
	note $2a $07
	note $2a $07
	vol $2
	note $2a $07
	note $2a $07
	vol $3
	note $2a $07
	vol $2
	note $2a $07
	note $2a $07
	note $2a $07
	vol $2
	note $2a $07
	note $2a $07
	vol $2
	note $2a $07
	note $2a $07
	vol $3
	note $2a $07
	vol $2
	note $2a $07
	note $2a $07
	note $2a $07
	vol $2
	note $2a $07
	note $2a $07
	vol $2
	note $2a $07
	note $2a $07
	vol $3
	note $2a $07
	vol $2
	note $2a $07
	note $2a $07
	note $2a $07
	vol $2
	note $2a $07
	note $2a $07
	vol $2
	note $2a $07
	note $2a $07
	vol $2
	note $2a $07
	vol $2
	note $2a $07
	note $2a $07
	note $2a $07
	vol $2
	note $2a $07
	note $2a $07
	vol $2
	note $2a $07
	note $2a $07
	vol $3
	note $2a $07
	vol $2
	note $2a $07
	note $2a $07
	note $2a $07
	vol $2
	note $2a $07
	note $2a $07
	vol $2
	note $2a $07
	note $2a $07
	vol $2
	note $2a $07
	vol $2
	note $2a $07
	note $2a $07
	note $2a $07
	vol $2
	note $2a $07
	note $2a $07
	vol $2
	note $2a $07
	note $2a $07
	vol $3
	note $2a $07
	vol $2
	note $2a $07
	note $2a $07
	note $2a $07
	vol $2
	note $2a $07
	note $2a $07
	vol $2
	note $2a $07
	note $2a $07
	vol $2
	note $2a $07
	vol $2
	note $2a $07
	note $2a $07
	note $2a $07
	vol $2
	note $2a $07
	note $2a $07
	vol $2
	note $2a $07
	note $2a $07
	vol $2
	note $2a $07
	vol $2
	note $2a $07
	note $2a $07
	note $2a $07
	vol $2
	note $2a $07
	note $2a $07
	vol $2
	note $2a $07
	note $2a $07
	vol $2
	note $2a $07
	vol $2
	note $2a $07
	note $2a $07
	note $2a $07
	vol $2
	note $2a $07
	note $2a $07
	vol $2
	note $2a $07
	note $2a $07
	vol $3
	note $2a $07
	vol $2
	note $2a $07
	note $2a $07
	note $2a $07
	vol $2
	note $2a $07
	note $2a $07
	vol $2
	note $2a $07
	note $2a $07
	vol $3
	note $2a $07
	vol $2
	note $2a $07
	note $2a $07
	note $2a $07
	vol $2
	note $2a $07
	note $2a $07
	vol $2
	note $2a $07
	note $2a $07
	vol $3
	note $2a $07
	vol $2
	note $2a $07
	note $2a $07
	note $2a $07
	vol $2
	note $2a $07
	note $2a $07
	vol $2
	note $2a $07
	note $2a $07
	vol $2
	note $2a $07
	vol $2
	note $2a $07
	note $2a $07
	note $2a $07
	vol $2
	note $2a $07
	note $2a $07
	vol $2
	note $2a $07
	note $2a $07
	vol $2
	note $2a $07
	vol $2
	note $2a $07
	note $2a $07
	note $2a $07
	vol $4
	note $26 $07
	vol $3
	note $26 $0e
	vol $3
	note $26 $07
	vol $4
	note $26 $07
	vol $3
	note $26 $0e
	note $26 $07
	vol $4
	note $26 $07
	vol $3
	note $26 $0e
	vol $3
	note $26 $07
	vol $3
	note $26 $07
	vol $3
	note $26 $07
	vol $4
	note $26 $07
	vol $4
	note $26 $07
	note $26 $07
	vol $3
	note $26 $0e
	vol $3
	note $26 $07
	vol $4
	note $26 $07
	vol $3
	note $26 $0e
	note $26 $07
	vol $4
	note $26 $07
	vol $3
	note $26 $0e
	vol $3
	note $26 $07
	vol $3
	note $26 $07
	vol $3
	note $26 $07
	vol $4
	note $26 $07
	vol $4
	note $26 $07
	note $26 $07
	vol $3
	note $26 $0e
	vol $3
	note $26 $07
	vol $4
	note $26 $07
	vol $3
	note $26 $0e
	note $26 $07
	vol $4
	note $26 $07
	vol $3
	note $26 $0e
	vol $3
	note $26 $07
	vol $3
	note $26 $07
	vol $3
	note $26 $07
	vol $4
	note $26 $07
	vol $4
	note $26 $07
	note $26 $07
	vol $3
	note $26 $0e
	vol $3
	note $26 $07
	vol $4
	note $26 $07
	vol $3
	note $26 $0e
	note $26 $07
	vol $4
	note $26 $07
	vol $3
	note $26 $0e
	vol $3
	note $26 $07
	vol $3
	note $26 $07
	vol $3
	note $26 $07
	vol $4
	note $26 $07
	vol $4
	note $26 $07
	goto musicf4cbe
	cmdff

sound23Start:

sound23Channel1:
	vibrato $e1
	env $0 $00
	duty $02
musicf4e9d:
	vol $6
	note a2  $0e
	note gs2 $08
	note a2  $0e
	note b2  $08
	note c3  $0e
	note b2  $08
	note c3  $0e
	note d3  $08
	note ds3 $0e
	note e3  $08
	note ds3 $0e
	note e3  $08
	rest $2c
	note a4  $0e
	note gs4 $08
	note a4  $0e
	note gs4 $08
	note g4  $0e
	note fs4 $08
	note g4  $0e
	note fs4 $08
	note f4  $0e
	note e4  $08
	note f4  $0e
	note e4  $08
	rest $2c
	note e5  $0e
	note ds5 $08
	note e5  $0e
	note ds5 $08
	note d5  $0e
	note cs5 $08
	note d5  $0e
	note cs5 $08
	note c5  $0e
	note b4  $08
	note c5  $0e
	note b4  $08
	note as4 $0e
	note a4  $08
	note as4 $0e
	vol $6
	note a4  $08
	note gs4 $2c
	note f4  $16
	note gs4 $0e
	note f4  $08
	note e4  $07
	rest $1d
	note d4  $08
	note c4  $07
	rest $0f
	note b3  $07
	rest $0f
	vol $6
	note e4  $0e
	note ds4 $08
	note e4  $0e
	note ds4 $08
	note e4  $07
	rest $04
	vol $3
	note e4  $07
	rest $04
	vol $6
	note a4  $07
	rest $04
	vol $3
	note a4  $07
	rest $04
	vol $6
	note ds4 $0e
	note d4  $08
	note ds4 $0e
	note d4  $08
	rest $03
	vol $3
	note d4  $08
	rest $03
	vol $1
	note d4  $08
	rest $16
	vol $6
	note e4  $0e
	note ds4 $08
	note e4  $0e
	note ds4 $08
	note e4  $07
	rest $04
	vol $3
	note e4  $07
	rest $04
	vol $6
	note a4  $07
	rest $04
	vol $3
	note a4  $07
	rest $04
	vol $6
	note c5  $0e
	note gs4 $08
	note c5  $0e
	note gs4 $08
	rest $03
	vol $3
	note gs4 $08
	rest $03
	vol $1
	note gs4 $08
	rest $16
	vol $6
	note a4  $0e
	note gs4 $08
	note a4  $0e
	note gs4 $08
	note a4  $07
	rest $04
	vol $3
	note a4  $07
	rest $04
	vol $6
	note c5  $07
	rest $04
	vol $3
	note c5  $07
	rest $04
	vol $6
	note gs4 $0e
	note g4  $08
	note gs4 $0e
	note g4  $08
	rest $03
	vol $3
	note g4  $08
	rest $03
	vol $1
	note g4  $08
	rest $16
	vol $6
	note a4  $0e
	note gs4 $08
	note a4  $0e
	note gs4 $08
	note a4  $07
	rest $04
	vol $3
	note a4  $07
	rest $04
	vol $6
	note e5  $07
	rest $04
	vol $3
	note e5  $07
	rest $04
	vol $6
	note ds5 $0e
	note e5  $08
	note f5  $0e
	note e5  $08
	rest $03
	vol $3
	note e5  $08
	rest $03
	vol $1
	note e5  $08
	rest $24
	vol $6
	note a4  $08
	note e4  $0e
	rest $03
	vol $3
	note e4  $05
	vol $6
	note e4  $0e
	note ds4 $08
	rest $03
	vol $3
	note ds4 $08
	rest $03
	vol $6
	note d4  $08
	note c4  $07
	rest $04
	vol $3
	note c4  $07
	rest $04
	vol $6
	note c4  $0e
	note b3  $08
	rest $03
	vol $3
	note b3  $08
	rest $03
	vol $6
	note e4  $08
	note ds4 $0e
	note e4  $08
	note a4  $07
	rest $04
	vol $3
	note a4  $03
	vol $6
	note e5  $08
	note ds5 $0e
	rest $03
	vol $3
	note ds5 $05
	vol $6
	note ds5 $0e
	note d5  $08
	rest $03
	vol $3
	note d5  $08
	rest $03
	vol $6
	note d5  $08
	note c5  $07
	rest $04
	vol $3
	note c5  $07
	rest $04
	vol $6
	note c5  $0e
	note b4  $08
	rest $03
	vol $3
	note b4  $08
	rest $03
	vol $6
	note e4  $03
	rest $05
	note e4  $07
	rest $04
	vol $3
	note e4  $03
	vol $6
	note e4  $08
	note f4  $16
	note e4  $07
	rest $04
	vol $3
	note e4  $07
	rest $04
	vol $6
	note g4  $16
	note e4  $07
	rest $04
	vol $3
	note e4  $07
	rest $04
	vol $6
	note f4  $16
	note e4  $07
	rest $04
	vol $3
	note e4  $07
	rest $04
	vol $6
	note g4  $16
	note e4  $07
	rest $04
	vol $3
	note e4  $07
	rest $5c
	vol $6
	note e4  $07
	note gs4 $07
	note as4 $08
	note gs4 $07
	note as4 $07
	note d5  $08
	note as4 $07
	note d5  $07
	note e5  $08
	note d5  $07
	note e5  $07
	note as5 $08
	goto musicf4e9d
	cmdff

sound23Channel0:
	vibrato $e1
	env $0 $00
	duty $02
musicf5098:
	vol $1
	note a2  $0b
	vol $3
	note a2  $0e
	note gs2 $08
	note a2  $0e
	note b2  $08
	note c3  $0e
	note b2  $08
	note c3  $0e
	note d3  $08
	note ds3 $0e
	note e3  $08
	note ds3 $0e
	note e3  $08
	rest $2c
	note a4  $0e
	note gs4 $08
	note a4  $0e
	note gs4 $08
	note g4  $0e
	note fs4 $08
	note g4  $0e
	note fs4 $08
	note f4  $0e
	note e4  $08
	note f4  $0e
	note e4  $08
	rest $21
	vol $6
	note a4  $2c
	note gs4 $2c
	note g4  $2c
	note fs4 $2c
	note f4  $2c
	note d4  $2c
	note b3  $07
	rest $07
	vol $3
	note b3  $08
	rest $07
	vol $1
	note b3  $07
	rest $08
	vol $6
	note gs3 $07
	rest $07
	vol $3
	note gs3 $08
	rest $07
	vol $1
	note gs3 $07
	rest $13
	vol $3
	note e4  $0e
	note ds4 $08
	note e4  $0e
	note ds4 $08
	note e4  $07
	rest $04
	vol $1
	note e4  $07
	rest $04
	vol $3
	note a4  $07
	rest $04
	vol $1
	note a4  $07
	rest $04
	vol $3
	note ds4 $0e
	note d4  $08
	note ds4 $0e
	note d4  $08
	rest $03
	vol $1
	note d4  $08
	rest $03
	vol $0
	note d4  $08
	rest $16
	vol $3
	note e4  $0e
	note ds4 $08
	note e4  $0e
	note ds4 $08
	note e4  $07
	rest $04
	vol $1
	note e4  $07
	rest $04
	vol $3
	note a4  $07
	rest $04
	vol $1
	note a4  $07
	rest $04
	vol $3
	note c5  $0e
	note gs4 $08
	note c5  $0e
	note gs4 $08
	rest $03
	vol $1
	note gs4 $08
	rest $03
	vol $0
	note gs4 $08
	rest $16
	vol $3
	note a4  $0e
	note gs4 $08
	note a4  $0e
	note gs4 $08
	note a4  $07
	rest $04
	vol $1
	note a4  $07
	rest $04
	vol $3
	note c5  $07
	rest $04
	vol $1
	note c5  $07
	rest $04
	vol $3
	note gs4 $0e
	note g4  $08
	note gs4 $0e
	note g4  $08
	rest $03
	vol $1
	note g4  $08
	rest $03
	vol $0
	note g4  $08
	rest $16
	vol $3
	note a4  $0e
	note gs4 $08
	note a4  $0e
	note gs4 $08
	note a4  $07
	rest $04
	vol $1
	note a4  $07
	rest $04
	vol $3
	note e5  $07
	rest $04
	vol $1
	note e5  $07
	rest $04
	vol $3
	note ds5 $0e
	note e5  $08
	note f5  $0e
	note e5  $08
	rest $03
	vol $1
	note e5  $08
	rest $03
	vol $0
	note e5  $08
	rest $24
	vol $3
	note a4  $08
	note e4  $0e
	rest $03
	vol $1
	note e4  $05
	vol $3
	note e4  $0e
	note ds4 $08
	rest $03
	vol $1
	note ds4 $08
	rest $03
	vol $3
	note d4  $08
	note c4  $07
	rest $04
	vol $1
	note c4  $07
	rest $04
	vol $3
	note c4  $0e
	note b3  $08
	rest $03
	vol $1
	note b3  $08
	rest $03
	vol $3
	note e4  $08
	note ds4 $0b
	vol $6
	note c5  $07
	rest $04
	vol $3
	note c5  $03
	vol $6
	note c5  $08
	note b4  $0e
	rest $03
	vol $3
	note b4  $05
	vol $6
	note b4  $0e
	note as4 $08
	rest $03
	vol $3
	note as4 $08
	rest $03
	vol $6
	note as4 $08
	note gs4 $07
	rest $04
	vol $3
	note gs4 $07
	rest $04
	vol $6
	note gs4 $0e
	note e4  $08
	rest $03
	vol $3
	note e4  $08
	rest $03
	vol $6
	note c4  $03
	rest $05
	note c4  $07
	rest $04
	vol $3
	note c4  $03
	vol $6
	note c4  $08
	vol $6
	note cs4 $16
	note c4  $07
	rest $04
	vol $3
	note c4  $07
	rest $04
	vol $6
	note ds4 $16
	note c4  $07
	rest $04
	vol $3
	note c4  $07
	rest $04
	vol $6
	note cs4 $16
	note c4  $07
	rest $04
	vol $3
	note c4  $07
	rest $04
	vol $6
	note ds4 $16
	note c4  $07
	rest $04
	vol $3
	note c4  $07
	rest $67
	note e4  $07
	note gs4 $07
	note as4 $08
	note gs4 $07
	note as4 $07
	note d5  $08
	note as4 $07
	note d5  $07
	note e5  $08
	note d5  $07
	note e5  $04
	goto musicf5098
	cmdff

sound23Channel4:
musicf5280:
	duty $0e
	note a1  $07
	rest $25
	note f2  $07
	rest $25
	note ds2 $24
	note e2  $08
	duty $0f
	note e2  $08
	rest $06
	duty $0e
	note e2  $08
	note fs2 $0e
	note gs2 $08
	duty $0e
	note a2  $07
	duty $0f
	note a2  $07
	rest $1e
	duty $0e
	note e2  $07
	duty $0f
	note e2  $07
	rest $1e
	duty $0e
	note b1  $24
	note e2  $08
	duty $0f
	note e2  $08
	rest $06
	duty $0e
	note e3  $08
	note ds3 $0e
	note d3  $08
	note c3  $0e
	note b2  $08
	note c3  $0e
	note b2  $08
	note as2 $0e
	note a2  $08
	note as2 $0e
	note a2  $08
	note gs2 $0e
	note g2  $08
	note gs2 $0e
	note g2  $08
	note fs2 $0e
	note f2  $08
	note fs2 $0e
	note f2  $08
	note e2  $2c
	note f2  $2c
	note fs2 $2c
	note gs2 $2c
	duty $0e
	note a2  $07
	duty $0f
	note a2  $07
	rest $1e
	duty $0e
	note e2  $07
	duty $0f
	note e2  $07
	rest $1e
	duty $0e
	note ds2 $24
	note e2  $08
	duty $0f
	note e2  $08
	rest $06
	duty $0e
	note e2  $16
	note fs2 $03
	note gs2 $05
	duty $0e
	note a2  $07
	duty $0f
	note a2  $07
	rest $1e
	duty $0e
	note e2  $07
	duty $0f
	note e2  $07
	rest $1e
	duty $0e
	note ds2 $0e
	note e2  $08
	note ds2 $0e
	note e2  $08
	duty $0f
	note e2  $08
	rest $06
	duty $0e
	note e2  $16
	note fs2 $03
	note gs2 $05
	duty $0e
	note a2  $07
	duty $0f
	note a2  $07
	rest $1e
	duty $0e
	note e2  $07
	duty $0f
	note e2  $07
	rest $1e
	duty $0e
	note d2  $24
	note ds2 $08
	duty $0f
	note ds2 $08
	rest $06
	duty $0e
	note e2  $16
	note fs2 $03
	note gs2 $05
	duty $0e
	note a2  $07
	duty $0f
	note a2  $07
	rest $1e
	duty $0e
	note e2  $07
	duty $0f
	note e2  $07
	rest $1e
	duty $0e
	note ds2 $0e
	note e2  $08
	note f2  $0e
	note e2  $08
	duty $0f
	note e2  $08
	rest $0e
	duty $0e
	note e2  $16
	duty $0e
	note a2  $07
	duty $0f
	note a2  $07
	rest $1e
	duty $0e
	note e2  $07
	duty $0f
	note e2  $07
	rest $1e
	duty $0e
	note d2  $24
	note e2  $08
	duty $0f
	note e2  $08
	rest $24
	duty $0e
	note a2  $07
	duty $0f
	note a2  $07
	rest $1e
	duty $0e
	note e2  $07
	duty $0f
	note e2  $07
	rest $1e
	duty $0e
	note d2  $07
	duty $0f
	note d2  $07
	rest $08
	duty $0e
	note d2  $0e
	note e2  $08
	duty $0f
	note e2  $08
	rest $24
	duty $0e
	note a2  $07
	duty $0f
	note a2  $07
	rest $a2
	duty $0e
	note ds2 $0e
	note e2  $08
	note ds2 $0e
	note e2  $08
	note c3  $0e
	note b2  $08
	duty $0f
	note b2  $08
	rest $06
	duty $0e
	note as2 $60
	goto musicf5280
	cmdff

sound23Channel6:
musicf5400:
	rest $ff
	rest $ff
	rest $28
	vol $3
	note $2a $2c
	note $2a $2c
	note $2a $24
	note $2a $08
	vol $2
	note $2e $16
	vol $3
	note $2a $42
	note $2a $2c
	vol $2
	note $2e $0e
	vol $3
	note $2a $16
	note $2a $08
	vol $2
	note $2e $16
	vol $3
	note $2a $16
	vol $4
	vol $3
	note $2a $2c
	note $2a $2c
	vol $2
	note $2e $0e
	vol $3
	note $2a $16
	vol $3
	note $2a $08
	vol $2
	note $2e $16
	rest $16
	vol $3
	note $2a $2c
	note $2a $2c
	vol $2
	note $2e $0e
	vol $3
	note $2a $16
	note $2a $08
	vol $2
	note $2e $16
	rest $16
	vol $3
	note $2a $2c
	vol $3
	note $2a $2c
	vol $2
	note $2e $0e
	vol $3
	note $2a $16
	note $2a $08
	vol $2
	note $2e $16
	rest $16
	vol $3
	note $2a $2c
	note $2a $2c
	vol $2
	note $2e $0e
	vol $3
	note $2a $16
	note $2a $08
	vol $2
	note $2e $16
	rest $16
	vol $3
	note $2a $2c
	vol $3
	note $2a $2c
	vol $2
	note $2e $0e
	vol $3
	note $2a $16
	note $2a $08
	vol $2
	note $2e $16
	note $2e $16
	vol $3
	note $2a $0e
	note $2a $08
	vol $2
	note $2e $16
	vol $3
	note $2a $0e
	note $2a $08
	vol $2
	note $2e $16
	vol $3
	note $2a $0e
	note $2a $08
	vol $2
	note $2e $16
	vol $3
	note $2a $0e
	note $2a $08
	vol $2
	note $2e $0e
	vol $3
	note $2a $08
	note $2a $0e
	note $2a $08
	note $2a $0e
	note $2a $16
	note $2a $16
	note $2a $08
	note $2a $07
	note $2a $07
	note $2a $08
	note $2a $07
	note $2a $07
	note $2a $08
	note $2a $07
	note $2a $07
	note $2a $08
	goto musicf5400
	cmdff

sound1bChannel1:
musicf54c8:
	vibrato $00
	env $0 $05
	duty $02
	vol $6
	note ds5 $0f
	note a4  $0f
	note gs4 $0f
	note ds4 $0f
	note gs4 $0f
	note a4  $0f
	note ds5 $0f
	note a4  $0f
	note gs4 $0f
	note ds4 $0f
	note gs4 $0f
	note a4  $0f
	note ds5 $0f
	note a4  $0f
	note gs4 $0f
	note ds4 $0f
	note gs4 $0f
	note a4  $0f
	note ds5 $0f
	note a4  $0f
	note gs4 $0f
	note ds4 $0f
	note gs4 $0f
	note a4  $0f
	note cs5 $0f
	note g4  $0f
	note fs4 $0f
	note cs4 $0f
	note fs4 $0f
	note g4  $0f
	note cs5 $0f
	note g4  $0f
	note fs4 $0f
	note cs4 $0f
	note fs4 $0f
	note g4  $0f
	note cs5 $0f
	note g4  $0f
	note fs4 $0f
	note cs4 $0f
	note fs4 $0f
	note g4  $0f
	note cs5 $0f
	note g4  $0f
	note fs4 $0f
	note cs4 $0f
	note fs4 $0f
	note g4  $0f
	note ds5 $0f
	note a4  $0f
	note gs4 $0f
	note ds4 $0f
	note gs4 $0f
	note a4  $0f
	note ds5 $0f
	note a4  $0f
	note gs4 $0f
	note ds4 $0f
	note gs4 $0f
	note a4  $0f
	note ds5 $0f
	note a4  $0f
	note gs4 $0f
	note ds4 $0f
	note gs4 $0f
	note a4  $0f
	note ds5 $0f
	note a4  $0f
	note gs4 $0f
	note ds4 $0f
	note gs4 $0f
	note a4  $0f
	note cs5 $0f
	note g4  $0f
	note fs4 $0f
	note cs4 $0f
	note fs4 $0f
	note g4  $0f
	note cs5 $0f
	note g4  $0f
	note fs4 $0f
	note cs4 $0f
	note fs4 $0f
	note g4  $0f
	note cs5 $0f
	note g4  $0f
	note fs4 $0f
	note cs4 $0f
	note fs4 $0f
	note g4  $0f
	note cs5 $0f
	note g4  $0f
	note fs4 $0f
	note cs4 $0f
	note fs4 $0f
	note g4  $0f
	vibrato $e1
	env $0 $00
	note e4  $4b
	vibrato $01
	env $0 $00
	vol $3
	note e4  $0f
	vibrato $e1
	env $0 $00
	vol $6
	note ds4 $4b
	vibrato $01
	env $0 $00
	vol $3
	note ds4 $0f
	vibrato $e1
	env $0 $00
	vol $6
	note d4  $4b
	vibrato $01
	env $0 $00
	vol $3
	note d4  $0f
	vibrato $e1
	env $0 $00
	vol $6
	note cs4 $4b
	vibrato $01
	env $0 $00
	vol $3
	note cs4 $0f
	vibrato $00
	env $0 $03
	vol $6
	note c4  $0f
	note g3  $0f
	note fs3 $0f
	note c4  $0f
	note g3  $0f
	note fs3 $0f
	vol $5
	note c5  $0f
	note g4  $0f
	note fs4 $0f
	note c5  $0f
	note g4  $0f
	note fs4 $0f
	env $0 $04
	vol $4
	note c6  $0f
	note g5  $0f
	vol $4
	note fs5 $0f
	vol $4
	note c6  $0f
	note g5  $0f
	vol $4
	note fs5 $0f
	env $0 $05
	vol $3
	note c7  $0f
	note g6  $0f
	note fs6 $0f
	vol $3
	note c7  $0f
	note g6  $0f
	note fs6 $0f
	vibrato $e1
	env $0 $00
	vol $6
	note d4  $4b
	vibrato $01
	env $0 $00
	vol $3
	note d4  $0f
	vibrato $e1
	env $0 $00
	vol $6
	note cs4 $4b
	vibrato $01
	env $0 $00
	vol $3
	note cs4 $0f
	vibrato $e1
	env $0 $00
	vol $6
	note c4  $4b
	vibrato $01
	env $0 $00
	vol $3
	note c4  $0f
	vibrato $e1
	env $0 $00
	vol $6
	note b3  $4b
	vibrato $01
	env $0 $00
	vol $3
	note b3  $0f
	vibrato $00
	env $0 $03
	vol $6
	note a3  $0f
	note e3  $0f
	note ds3 $0f
	note a3  $0f
	note e3  $0f
	note ds3 $0f
	vol $5
	note a4  $0f
	note e4  $0f
	note ds4 $0f
	note a4  $0f
	note e4  $0f
	note ds4 $0f
	env $0 $04
	vol $4
	note a5  $0f
	note e5  $0f
	note ds5 $0f
	note a5  $0f
	note e5  $0f
	note ds5 $0f
	env $0 $05
	vol $3
	note a6  $0f
	note e6  $0f
	note ds6 $0f
	note a6  $0f
	note e6  $0f
	note ds6 $0f
	goto musicf54c8
	cmdff

sound1bChannel0:
musicf567e:
	vibrato $00
	env $0 $05
	duty $02
	vol $1
	note ds5 $0f
	vol $3
	note ds5 $0f
	note a4  $0f
	note gs4 $0f
	note ds4 $0f
	note gs4 $0f
	note a4  $0f
	note ds5 $0f
	note a4  $0f
	note gs4 $0f
	note ds4 $0f
	note gs4 $0f
	note a4  $0f
	note ds5 $0f
	note a4  $0f
	note gs4 $0f
	note ds4 $0f
	note gs4 $0f
	note a4  $0f
	note ds5 $0f
	note a4  $0f
	note gs4 $0f
	note ds4 $0f
	note gs4 $0f
	note a4  $0f
	note cs5 $0f
	note g4  $0f
	note fs4 $0f
	note cs4 $0f
	note fs4 $0f
	note g4  $0f
	note cs5 $0f
	note g4  $0f
	note fs4 $0f
	note cs4 $0f
	note fs4 $0f
	vol $4
	note g4  $0f
	note cs5 $0f
	note g4  $0f
	note fs4 $0f
	note cs4 $0f
	note fs4 $0f
	note g4  $0f
	note cs5 $0f
	note g4  $0f
	note fs4 $0f
	note cs4 $0f
	note fs4 $0f
	note g4  $0f
	note ds5 $0f
	note a4  $0f
	note gs4 $0f
	note ds4 $0f
	note gs4 $0f
	note a4  $0f
	note ds5 $0f
	note a4  $0f
	note gs4 $0f
	note ds4 $0f
	note gs4 $0f
	note a4  $0f
	note ds5 $0f
	note a4  $0f
	note gs4 $0f
	note ds4 $0f
	note gs4 $0f
	note a4  $0f
	note ds5 $0f
	note a4  $0f
	note gs4 $0f
	note ds4 $0f
	note gs4 $0f
	note a4  $0f
	note cs5 $0f
	vol $4
	note g4  $0f
	note fs4 $0f
	note cs4 $0f
	note fs4 $0f
	note g4  $0f
	note cs5 $0f
	note g4  $0f
	note fs4 $0f
	note cs4 $0f
	note fs4 $0f
	note g4  $0f
	note cs5 $0f
	note g4  $0f
	note fs4 $0f
	note cs4 $0f
	note fs4 $0f
	note g4  $0f
	note cs5 $0f
	note g4  $0f
	note fs4 $0f
	note cs4 $0f
	note fs4 $0f
	vibrato $e1
	env $0 $00
	vol $6
	note b3  $3c
	vibrato $01
	env $0 $00
	vol $3
	note b3  $1e
	vibrato $e1
	env $0 $00
	vol $6
	note as3 $3c
	vibrato $01
	env $0 $00
	vol $3
	note as3 $1e
	vibrato $e1
	env $0 $00
	vol $6
	note a3  $3c
	vibrato $01
	env $0 $00
	vol $3
	note a3  $1e
	vibrato $e1
	env $0 $00
	vol $6
	note gs3 $3c
	vibrato $01
	env $0 $00
	vol $3
	note gs3 $1e
	rest $0f
	vibrato $00
	env $0 $03
	vol $4
	note c4  $0f
	note g3  $0f
	note fs3 $0f
	note c4  $0f
	note g3  $0f
	note fs3 $0f
	vol $3
	note c5  $0f
	vol $3
	note g4  $0f
	note fs4 $0f
	note c5  $0f
	note g4  $0f
	note fs4 $0f
	vol $2
	note c6  $0f
	vol $2
	note g5  $0f
	note fs5 $0f
	note c6  $0f
	note g5  $0f
	note fs5 $0f
	vol $1
	note c7  $0f
	vol $1
	note g6  $0f
	vol $1
	note fs6 $0f
	vol $1
	note c7  $0f
	vol $1
	note g6  $0f
	vibrato $e1
	env $0 $00
	vol $6
	note as2 $3c
	vibrato $01
	env $0 $00
	vol $3
	note as2 $1e
	vibrato $e1
	env $0 $00
	vol $6
	note a2  $3c
	vibrato $01
	env $0 $00
	vol $3
	note a2  $1e
	vibrato $e1
	env $0 $00
	vol $6
	note gs2 $3c
	vibrato $01
	env $0 $00
	vol $3
	note gs2 $1e
	vibrato $e1
	env $0 $00
	vol $6
	note g2  $3c
	vibrato $01
	env $0 $00
	vol $3
	note g2  $1e
	rest $0b
	vibrato $00
	env $0 $03
	vol $3
	note a3  $0f
	note e3  $0f
	note ds3 $0f
	note a3  $0f
	note e3  $0f
	vol $2
	note ds3 $0f
	note a4  $0f
	note e4  $0f
	note ds4 $0f
	note a4  $0f
	note e4  $0f
	note ds4 $0f
	vol $2
	note a5  $0f
	note e5  $0f
	note ds5 $0f
	vol $2
	note a5  $0f
	note e5  $0f
	note ds5 $0f
	vol $1
	note a6  $0f
	note e6  $0f
	vol $1
	note ds6 $0f
	note a6  $0f
	vol $1
	note e6  $0f
	note ds6 $04
	goto musicf567e
	cmdff

sound1bChannel4:
musicf5837:
	duty $0e
	note gs2 $a5
	note ds2 $0f
	duty $0e
	note gs2 $08
	duty $0f
	note gs2 $07
	duty $0e
	note gs2 $08
	duty $0f
	note gs2 $07
	duty $0e
	rest $96
	note g2  $a5
	note cs2 $0f
	duty $0e
	note g2  $08
	duty $0f
	note g2  $07
	duty $0e
	note g2  $08
	duty $0f
	note g2  $07
	duty $0e
	rest $96
	note gs2 $a5
	note ds3 $0f
	duty $0e
	note gs2 $08
	duty $0f
	note gs2 $07
	duty $0e
	note gs2 $08
	duty $0f
	note gs2 $07
	duty $0e
	rest $96
	note g2  $a5
	note cs3 $0f
	duty $0e
	note g2  $08
	duty $0f
	note g2  $07
	duty $0e
	note g2  $08
	duty $0f
	note g2  $07
	duty $0e
	rest $96
	note gs2 $2a
	rest $03
	note gs2 $0f
	rest $0f
	note gs2 $07
	rest $08
	note gs2 $07
	rest $08
	note gs2 $19
	rest $05
	note gs2 $19
	rest $05
	note gs2 $07
	rest $08
	note gs2 $07
	rest $08
	note gs2 $19
	rest $05
	note gs2 $19
	rest $05
	note gs2 $07
	rest $08
	note gs2 $07
	rest $08
	note gs2 $19
	rest $05
	note gs2 $19
	rest $05
	note gs2 $0f
	note fs2 $2a
	rest $03
	note fs2 $0f
	rest $0f
	note fs2 $07
	rest $08
	note fs2 $07
	rest $08
	note fs2 $19
	rest $05
	note fs2 $19
	rest $05
	note fs2 $07
	rest $08
	note fs2 $07
	rest $08
	note fs2 $19
	rest $05
	note fs2 $19
	rest $05
	note fs2 $07
	rest $08
	note fs2 $07
	rest $08
	note fs2 $19
	rest $05
	note fs2 $19
	rest $05
	note fs2 $0f
	note f3  $07
	rest $08
	note f3  $19
	rest $05
	note f3  $19
	rest $05
	note f3  $0f
	note e3  $07
	rest $08
	note e3  $19
	rest $05
	note e3  $19
	rest $05
	note e3  $07
	rest $08
	note ds3 $07
	rest $08
	note ds3 $19
	rest $05
	note ds3 $19
	rest $05
	note ds3 $07
	rest $08
	note d3  $07
	rest $08
	note d3  $19
	rest $05
	note d3  $19
	rest $05
	note d3  $07
	rest $08
	note fs2 $07
	rest $08
	note fs2 $19
	rest $05
	note fs2 $19
	rest $05
	note fs2 $07
	rest $08
	note fs2 $07
	rest $08
	note fs2 $19
	rest $05
	note fs2 $19
	rest $05
	note fs2 $07
	rest $08
	note fs2 $07
	rest $08
	note fs2 $19
	rest $05
	note fs2 $19
	rest $05
	note fs2 $07
	rest $08
	note fs2 $07
	rest $08
	note fs2 $19
	rest $05
	note fs2 $19
	rest $05
	note fs2 $07
	rest $08
	goto musicf5837
	cmdff

sound27Channel1:
	vibrato $e1
	env $0 $00
	duty $01
musicf5995:
	vol $6
	note b4  $2a
	note gs4 $0e
	note e4  $0e
	note b3  $0e
	note c4  $2a
	note e4  $0e
	note g4  $0e
	note c5  $0e
	note b4  $0a
	rest $04
	duty $02
	note b5  $03
	note as5 $04
	note b5  $03
	note as5 $04
	note b5  $03
	rest $04
	vol $3
	note b5  $03
	rest $04
	vol $6
	note b6  $03
	note as6 $04
	note b6  $03
	note as6 $04
	note b6  $03
	rest $04
	vol $3
	note b6  $03
	rest $04
	duty $01
	vol $6
	note b3  $0e
	note c4  $0b
	rest $03
	duty $02
	note c5  $03
	note b4  $04
	note c5  $03
	note b4  $04
	note c5  $03
	rest $04
	vol $3
	note c5  $03
	rest $04
	vol $6
	note c6  $03
	note b5  $04
	note c6  $03
	note b5  $04
	note c6  $03
	rest $04
	vol $3
	note c6  $03
	rest $12
	duty $01
	vol $6
	note b4  $2a
	note gs4 $0e
	note e4  $0e
	note gs4 $0e
	note a4  $07
	note gs4 $07
	note a4  $07
	note gs4 $07
	note a4  $0e
	note b4  $0e
	note c5  $0e
	note a4  $0e
	note b4  $07
	rest $03
	vol $3
	note b4  $04
	vol $6
	note e5  $07
	note ds5 $07
	note e5  $07
	rest $03
	vol $3
	note e5  $04
	vol $6
	note gs4 $07
	rest $03
	vol $3
	note gs4 $04
	vol $6
	note a4  $07
	rest $03
	vol $3
	note a4  $04
	vol $6
	note as4 $07
	rest $03
	vol $3
	note as4 $04
	vol $6
	note b4  $07
	note a4  $07
	note gs4 $07
	note fs4 $07
	note e4  $23
	vibrato $01
	env $0 $00
	vol $3
	note e4  $15
	vibrato $e1
	env $0 $00
	vol $6
	note g4  $38
	note e4  $1c
	note fs4 $07
	rest $03
	vol $3
	note fs4 $04
	duty $02
	vol $6
	note b5  $07
	note as5 $07
	note b5  $07
	rest $03
	vol $3
	note b5  $04
	vol $6
	note b6  $07
	note as6 $07
	note b6  $07
	rest $03
	vol $3
	note b6  $07
	rest $0b
	duty $01
	vol $6
	note g4  $2a
	note e4  $0e
	note c4  $0e
	note g4  $07
	vol $3
	note g4  $07
	vol $6
	note fs4 $07
	rest $03
	vol $3
	note fs4 $04
	duty $02
	vol $6
	note b4  $03
	note as4 $04
	note b4  $03
	note as4 $04
	note b4  $07
	rest $03
	vol $3
	note b4  $04
	vol $6
	note b5  $03
	note as5 $04
	note b5  $03
	note as5 $04
	note b5  $07
	rest $03
	vol $3
	note b5  $07
	rest $0b
	duty $01
	vol $6
	note ds5 $07
	rest $03
	vol $3
	note ds5 $07
	vol $6
	note cs5 $04
	note ds5 $03
	note cs5 $04
	note b4  $07
	rest $03
	vol $3
	note b4  $07
	rest $19
	vol $6
	note b4  $07
	rest $03
	vol $3
	note b4  $04
	vol $6
	note d5  $07
	rest $03
	vol $3
	note d5  $07
	vol $6
	note c5  $04
	note d5  $03
	note c5  $04
	note b4  $07
	rest $03
	vol $3
	note b4  $07
	rest $19
	vol $6
	note b4  $07
	rest $03
	vol $3
	note b4  $04
	duty $02
	vol $6
	note e5  $07
	rest $03
	vol $3
	note e5  $04
	vol $6
	note ds5 $03
	note e5  $04
	note ds5 $03
	note e5  $04
	note as4 $03
	note b4  $04
	note as4 $03
	note b4  $04
	rest $03
	vol $3
	note b4  $04
	rest $07
	vol $6
	note fs4 $03
	note g4  $04
	note fs4 $03
	note g4  $04
	rest $03
	vol $3
	note g4  $04
	rest $07
	vol $6
	note ds4 $03
	note e4  $04
	note ds4 $03
	note e4  $04
	rest $03
	vol $3
	note e4  $04
	rest $07
	duty $01
	vol $6
	note b3  $0e
	note cs4 $0e
	note d4  $0e
	note ds4 $0e
	goto musicf5995
	cmdff

sound27Channel0:
	vibrato $e1
	env $0 $00
	duty $02
musicf5b54:
	cmdfd $ff
	vol $0
	note gs3 $bd
	vol $3
	note b5  $03
	note as5 $04
	vol $3
	note b5  $03
	note as5 $04
	vol $3
	note b5  $03
	rest $04
	vol $1
	note b5  $03
	rest $04
	vol $3
	note b6  $03
	note as6 $04
	note b6  $03
	note as6 $04
	vol $3
	note b6  $03
	rest $04
	vol $1
	note b6  $03
	rest $20
	vol $3
	note c5  $03
	note b4  $04
	note c5  $03
	note b4  $04
	note c5  $03
	rest $04
	vol $1
	note c5  $03
	rest $04
	vol $3
	note c6  $03
	note b5  $04
	vol $3
	note c6  $03
	note b5  $04
	note c6  $03
	rest $04
	vol $1
	note c6  $03
	rest $ff
	rest $c5
	vol $3
	note b5  $07
	note as5 $07
	note b5  $07
	rest $03
	vol $1
	note b5  $04
	vol $3
	note b6  $07
	note as6 $07
	note b6  $07
	rest $03
	vol $1
	note b6  $07
	rest $58
	vol $3
	note fs4 $07
	rest $03
	vol $1
	note fs4 $07
	rest $04
	vol $3
	note b4  $03
	note as4 $04
	note b4  $03
	note as4 $04
	note b4  $07
	rest $03
	vol $1
	note b4  $04
	vol $3
	note b5  $03
	note as5 $04
	note b5  $03
	note as5 $04
	note b5  $07
	rest $03
	vol $1
	note b5  $07
	rest $2e
	cmdfd $00
	vol $6
	note cs6 $04
	note ds6 $05
	note cs6 $05
	note b5  $07
	rest $03
	vol $3
	note b5  $07
	rest $04
	vol $1
	note b5  $07
	rest $2a
	vol $6
	note c6  $04
	note d6  $05
	note c6  $05
	note b5  $07
	rest $03
	vol $3
	note b5  $07
	rest $04
	vol $1
	note b5  $07
	rest $15
	vol $3
	note ds5 $03
	note e5  $04
	note ds5 $03
	note e5  $04
	note as4 $03
	note b4  $04
	note as4 $03
	note b4  $04
	rest $03
	vol $1
	note b4  $04
	rest $07
	vol $3
	note fs4 $03
	note g4  $04
	note fs4 $03
	note g4  $04
	rest $03
	vol $1
	note g4  $04
	rest $07
	vol $3
	note ds4 $03
	note e4  $04
	note ds4 $03
	note e4  $04
	rest $03
	vol $1
	note e4  $04
	rest $38
	goto musicf5b54
	cmdff

sound27Channel4:
musicf5c55:
	duty $0e
	note e3  $1c
	duty $0e
	note b3  $07
	duty $0f
	note b3  $07
	rest $0e
	duty $0e
	note b3  $07
	duty $0f
	note b3  $07
	rest $0e
	duty $0e
	note f3  $1c
	duty $0e
	note a3  $07
	duty $0f
	note a3  $07
	rest $0e
	duty $0e
	note a3  $07
	duty $0f
	note a3  $07
	rest $0e
	duty $0e
	note e3  $1c
	duty $0f
	note e3  $0e
	rest $2a
	duty $0e
	note b2  $1c
	duty $0f
	note b2  $0e
	rest $2a
	duty $0e
	note e3  $1c
	duty $0e
	note b3  $07
	duty $0f
	note b3  $07
	rest $0e
	duty $0e
	note b3  $07
	duty $0f
	note b3  $07
	rest $0e
	duty $0e
	note f3  $1c
	note a3  $07
	duty $0f
	note a3  $07
	rest $0e
	duty $0e
	note a3  $07
	duty $0f
	note a3  $07
	rest $0e
	duty $0e
	note b2  $15
	duty $0f
	note b2  $0a
	rest $35
	duty $0e
	note b2  $0e
	note cs3 $07
	note ds3 $07
	note e3  $0e
	note b2  $0e
	note gs2 $0e
	note e2  $0e
	duty $0f
	note e2  $07
	rest $15
	duty $0e
	note c3  $07
	duty $0f
	note c3  $07
	rest $0e
	duty $0e
	note c3  $07
	duty $0f
	note c3  $07
	rest $0e
	duty $0e
	note b2  $07
	duty $0f
	note b2  $07
	rest $46
	duty $0e
	note c3  $1c
	note e3  $1c
	note g3  $1c
	note b2  $0e
	duty $0f
	note b2  $07
	rest $3f
	duty $0e
	note fs3 $38
	note b2  $07
	duty $0f
	note b2  $07
	rest $0e
	duty $0e
	note f3  $38
	duty $0e
	note b2  $07
	duty $0f
	note b2  $07
	rest $0e
	duty $0e
	note e3  $07
	duty $0f
	note e3  $07
	rest $46
	duty $0e
	note b2  $54
	goto musicf5c55
	cmdff

sound1dStart:

sound1dChannel1:
	vibrato $e1
	env $0 $00
	duty $02
	vol $8
	note b2  $03
	vol $8
	note e3  $04
	note f3  $03
	note b3  $04
	note b3  $03
	vol $7
	note e4  $04
	note f4  $03
	note b4  $04
	vol $8
	note b4  $03
	vol $8
	note e5  $04
	note f5  $03
	note b5  $04
	note b5  $03
	vol $7
	note e6  $04
	note f6  $03
	note b6  $2c
	rest $02
	vol $5
	note b6  $02
	rest $02
	vol $4
	note b6  $03
	rest $02
	vol $4
	note b6  $02
	rest $03
musicf5d7e:
	vol $7
	note f4  $0e
	note gs4 $0e
	note c5  $07
	rest $03
	vol $3
	note c5  $04
	vol $7
	note b4  $2a
	note gs4 $0e
	note f4  $0e
	note ds5 $07
	rest $03
	vol $3
	note ds5 $04
	vol $7
	note d5  $46
	vibrato $01
	env $0 $00
	vol $3
	note d5  $0e
	vibrato $e1
	env $0 $00
	vol $7
	note cs5 $0e
	note c5  $0e
	note b4  $0e
	note as4 $0e
	note gs4 $0e
	note g4  $1c
	vibrato $01
	env $0 $00
	vol $3
	note g4  $0e
	vibrato $e1
	env $0 $00
	vol $8
	note f4  $0e
	vol $8
	note g4  $04
	note gs4 $05
	note g4  $4b
	vibrato $01
	env $0 $00
	vol $4
	note g4  $0e
	vibrato $e1
	env $0 $00
	vol $8
	note f4  $0e
	note g4  $0e
	note f4  $0e
	note b3  $54
	vibrato $01
	env $0 $00
	vol $4
	note b3  $0e
	vibrato $e1
	env $0 $00
	vol $8
	note c4  $0e
	note d4  $0e
	note e4  $0e
	note f4  $0e
	note g4  $0e
	note gs4 $0e
	note as4 $0e
	vol $8
	note b4  $04
	note c5  $05
	note b4  $2f
	vibrato $01
	env $0 $00
	vol $4
	note b4  $0e
	vibrato $e1
	env $0 $00
	vol $8
	note gs4 $0e
	note g4  $0e
	note f4  $0e
	note e4  $07
	rest $03
	vol $4
	note e4  $04
	vol $8
	note g4  $46
	vibrato $01
	env $0 $00
	vol $4
	note g4  $1c
	vibrato $e1
	env $0 $00
	vol $8
	note f4  $0e
	note c4  $07
	note f4  $07
	note c4  $07
	note f4  $07
	note c4  $07
	rest $07
	vol $5
	note f4  $0e
	note c4  $07
	note f4  $07
	note c4  $07
	note f4  $07
	note c4  $07
	rest $07
	vol $8
	note e4  $0e
	note b3  $07
	note e4  $07
	note b3  $07
	note e4  $07
	note b3  $07
	rest $07
	vol $5
	note e4  $0e
	note b3  $07
	note e4  $07
	note b3  $07
	note e4  $07
	note b3  $07
	rest $07
	vol $8
	note f4  $0e
	note c4  $07
	note f4  $07
	note c4  $07
	note f4  $07
	vol $8
	note b4  $03
	vol $8
	note c5  $27
	vibrato $01
	env $0 $00
	vol $4
	note c5  $0e
	vibrato $e1
	env $0 $00
	vol $8
	note as4 $07
	note c5  $07
	note cs5 $0e
	note c5  $0e
	note as4 $0e
	note gs4 $0e
	note fs4 $0e
	vol $4
	note fs4 $0e
	vol $8
	note cs5 $0e
	vol $4
	note cs5 $0e
	vol $8
	note c5  $0e
	note f4  $07
	note c5  $07
	note f4  $07
	note c5  $07
	note f4  $07
	rest $07
	vol $5
	note c5  $0e
	note f4  $07
	note c5  $07
	note f4  $07
	note c5  $07
	note f4  $07
	rest $07
	vol $8
	note b4  $0e
	note e4  $07
	note b4  $07
	note e4  $07
	note b4  $07
	note e4  $07
	rest $07
	vol $5
	note b4  $0e
	note e4  $07
	note b4  $07
	note e4  $07
	note b4  $07
	note e4  $07
	rest $07
	vol $8
	note a4  $0e
	note d4  $07
	note f4  $07
	note d4  $07
	note f4  $07
	note d4  $0e
	vol $4
	note d4  $0e
	rest $1c
	vol $8
	note f5  $0e
	note fs5 $07
	rest $07
	vol $4
	note f5  $0e
	note fs5 $07
	rest $07
	vol $2
	note f5  $0e
	note fs5 $07
	rest $07
	vol $1
	note f5  $0e
	note fs5 $07
	rest $85
	goto musicf5d7e
	cmdff

sound1dChannel0:
	vol $0
	note gs3 $09
	vibrato $e1
	env $0 $00
	duty $02
	vol $4
	note b2  $03
	note e3  $04
	note f3  $03
	note b3  $04
	note b3  $03
	note e4  $04
	note f4  $03
	note b4  $04
	note b4  $03
	note e5  $04
	note f5  $03
	note b5  $04
	note b5  $03
	note e6  $04
	note f6  $03
	note b6  $04
	rest $2f
musicf5f2e:
	vol $8
	note c3  $0e
	note cs3 $0e
	note c3  $0e
	note cs3 $0e
	note c3  $0e
	note cs3 $0e
	note c3  $0e
	note cs3 $0e
	note c3  $0e
	note cs3 $0e
	note c3  $0e
	note cs3 $0e
	note c3  $0e
	note cs3 $0e
	note c3  $0e
	note cs3 $0e
	note c3  $0e
	note cs3 $0e
	note c3  $0e
	note cs3 $0e
	note c3  $0e
	note cs3 $0e
	note c3  $0e
	note cs3 $0e
	note c3  $0e
	note cs3 $0e
	note c3  $0e
	note cs3 $0e
	note c3  $0e
	note cs3 $0e
	note c3  $0e
	note cs3 $0e
	note c3  $0e
	note cs3 $0e
	note c3  $0e
	note cs3 $0e
	note c3  $0e
	note cs3 $0e
	note c3  $0e
	note cs3 $0e
	note c3  $0e
	note cs3 $0e
	note c3  $0e
	note cs3 $0e
	note c3  $0e
	note cs3 $0e
	note c3  $0e
	note cs3 $0e
	note d3  $0e
	note ds3 $0e
	note d3  $0e
	note ds3 $0e
	note d3  $0e
	note ds3 $0e
	note cs3 $0e
	note d3  $0e
	note g2  $0e
	note gs2 $0e
	note g2  $0e
	note gs2 $0e
	note gs2 $0e
	note a2  $0e
	note a2  $0e
	note as2 $0e
	vol $8
	note gs3 $2a
	vol $4
	note gs3 $0e
	vol $8
	note gs3 $07
	rest $03
	vol $4
	note gs3 $04
	vol $8
	note gs3 $0e
	note c4  $0e
	note gs3 $0e
	note g3  $2a
	vol $4
	note g3  $0e
	vol $8
	note g3  $07
	rest $03
	vol $4
	note g3  $04
	vol $8
	note g3  $0e
	note as3 $0e
	note g3  $0e
	note gs3 $2a
	vol $4
	note gs3 $0e
	vol $8
	note gs3 $07
	rest $03
	vol $4
	note gs3 $04
	vol $8
	note gs3 $0e
	note c4  $0e
	note gs3 $0e
	note as3 $1c
	note b3  $1c
	note c4  $1c
	note d4  $0e
	note e4  $0e
	note f4  $07
	rest $03
	vol $4
	note f4  $07
	rest $04
	vol $2
	note f4  $07
	vol $8
	note gs3 $1c
	vol $4
	note gs3 $0e
	vol $8
	note c4  $0e
	note f4  $0e
	note gs4 $0e
	note g4  $07
	rest $03
	vol $4
	note g4  $07
	rest $04
	vol $2
	note g4  $07
	vol $8
	note g3  $1c
	vol $4
	note g3  $0e
	vol $8
	note b3  $0e
	note e4  $0e
	note g4  $0e
	note f3  $2a
	vol $4
	note f3  $0e
	vol $8
	note a3  $0e
	note d4  $0e
	note f4  $0e
	note a4  $0e
	note as4 $07
	rest $03
	vol $4
	note as4 $07
	rest $04
	vol $2
	note as4 $07
	rest $03
	vol $1
	note as4 $07
	rest $20
	vol $8
	note cs4 $0e
	note c4  $0e
	note b3  $0e
	vol $4
	note b3  $0e
	vol $8
	note b3  $0e
	note as3 $0e
	note a3  $0e
	vol $4
	note a3  $0e
	vol $8
	note a3  $0e
	note gs3 $0e
	note g3  $0e
	goto musicf5f2e
	cmdff

sound1dChannel4:
	duty $0e
	note b1  $70
musicf606c:
	duty $01
	note f2  $0e
	note fs2 $0e
	note f2  $0e
	note fs2 $0e
	note f2  $0e
	note fs2 $0e
	note f2  $0e
	note fs2 $0e
	note f2  $0e
	note fs2 $0e
	note f2  $0e
	note fs2 $0e
	note f2  $0e
	note fs2 $0e
	note f2  $0e
	note fs2 $0e
	note f2  $0e
	note fs2 $0e
	note f2  $0e
	note fs2 $0e
	note f2  $0e
	note fs2 $0e
	note f2  $0e
	note fs2 $0e
	note f2  $0e
	note fs2 $0e
	note f2  $0e
	note fs2 $0e
	note f2  $0e
	note fs2 $0e
	note f2  $0e
	note fs2 $0e
	note f2  $0e
	note fs2 $0e
	note f2  $0e
	note fs2 $0e
	note f2  $0e
	note fs2 $0e
	note f2  $0e
	note fs2 $0e
	note f2  $0e
	note fs2 $0e
	note f2  $0e
	note fs2 $0e
	note f2  $0e
	note fs2 $0e
	note f2  $0e
	note fs2 $0e
	note g2  $0e
	note gs2 $0e
	note g2  $0e
	note gs2 $0e
	note g2  $0e
	note gs2 $0e
	note fs2 $0e
	note g2  $0e
	note c2  $0e
	note cs2 $0e
	note c2  $0e
	note cs2 $0e
	note d2  $0e
	note ds2 $0e
	note e2  $0e
	note f2  $0e
	duty $0e
	note f2  $07
	duty $0f
	note f2  $07
	duty $0e
	note f2  $15
	duty $0f
	note f2  $07
	duty $0e
	note f2  $07
	duty $0f
	note f2  $07
	duty $0e
	note f2  $07
	duty $0f
	note f2  $07
	duty $0e
	note f2  $15
	duty $0f
	note f2  $07
	duty $0e
	note f2  $07
	duty $0f
	note f2  $07
	duty $0e
	note e2  $07
	duty $0f
	note e2  $07
	duty $0e
	note e2  $15
	duty $0f
	note e2  $07
	duty $0e
	note e2  $07
	duty $0f
	note e2  $07
	duty $0e
	note e2  $07
	duty $0f
	note e2  $07
	duty $0e
	note e2  $15
	duty $0f
	note e2  $07
	duty $0e
	note e2  $07
	duty $0f
	note e2  $07
	duty $0e
	note f2  $07
	duty $0f
	note f2  $07
	duty $0e
	note f2  $15
	duty $0f
	note f2  $07
	duty $0e
	note f2  $07
	duty $0f
	note f2  $07
	duty $0e
	note f2  $07
	duty $0f
	note f2  $07
	duty $0e
	note f2  $15
	duty $0f
	note f2  $07
	duty $0e
	note f2  $07
	duty $0f
	note f2  $07
	duty $0e
	note g2  $07
	duty $0f
	note g2  $07
	duty $0e
	note g2  $15
	duty $0f
	note g2  $07
	duty $0e
	note g2  $07
	duty $0f
	note g2  $07
	duty $0e
	note c3  $07
	duty $0f
	note c3  $07
	duty $0e
	note c3  $15
	duty $0f
	note c3  $07
	duty $0e
	note c3  $07
	duty $0f
	note c3  $07
	duty $0e
	note f2  $07
	duty $0f
	note f2  $07
	duty $0e
	note f2  $15
	duty $0f
	note f2  $07
	duty $0e
	note f2  $07
	duty $0f
	note f2  $07
	duty $0e
	note f2  $07
	duty $0f
	note f2  $07
	duty $0e
	note f2  $15
	duty $0f
	note f2  $07
	duty $0e
	note f2  $07
	duty $0f
	note f2  $07
	duty $0e
	note e2  $07
	duty $0f
	note e2  $07
	duty $0e
	note e2  $15
	duty $0f
	note e2  $07
	duty $0e
	note e2  $07
	duty $0f
	note e2  $07
	duty $0e
	note e2  $07
	duty $0f
	note e2  $07
	duty $0e
	note e2  $15
	duty $0f
	note e2  $07
	duty $0e
	note e2  $07
	duty $0f
	note e2  $07
	duty $0e
	note d2  $07
	duty $0f
	note d2  $07
	duty $0e
	note d2  $07
	duty $0f
	note d2  $15
	duty $0e
	note d2  $07
	duty $0f
	note d2  $07
	duty $0e
	note d2  $07
	duty $0f
	note d2  $07
	duty $0e
	note d2  $15
	duty $0f
	note d2  $07
	duty $0e
	note d2  $07
	duty $0f
	note d2  $07
	duty $0e
	note c3  $07
	duty $0f
	note c3  $0e
	rest $07
	duty $0e
	note c2  $54
	duty $0f
	note c2  $0c
	rest $64
	goto musicf606c
	cmdff

sound1dChannel6:
	rest $70
musicf6258:
	vol $5
	note $26 $2a
	note $26 $07
	note $26 $07
	note $26 $1c
	note $26 $15
	note $26 $02
	note $26 $02
	note $26 $03
	note $26 $0e
	note $26 $1c
	note $26 $07
	note $26 $07
	note $26 $1c
	note $26 $15
	note $26 $02
	note $26 $02
	note $26 $03
	note $26 $2a
	note $26 $07
	note $26 $07
	note $26 $1c
	note $26 $15
	note $26 $02
	note $26 $02
	note $26 $03
	note $26 $0e
	note $26 $1c
	note $26 $07
	note $26 $07
	note $26 $1c
	note $26 $15
	note $26 $02
	note $26 $02
	note $26 $03
	note $26 $2a
	note $26 $07
	note $26 $07
	note $26 $1c
	note $26 $15
	note $26 $02
	note $26 $02
	note $26 $03
	note $26 $0e
	note $26 $1c
	note $26 $07
	note $26 $07
	note $26 $1c
	note $26 $15
	note $26 $02
	note $26 $02
	note $26 $03
	note $26 $2a
	note $26 $07
	note $26 $07
	note $26 $1c
	note $26 $15
	note $26 $02
	note $26 $02
	note $26 $03
	note $26 $0e
	note $26 $1c
	note $26 $07
	note $26 $07
	note $26 $0e
	note $26 $0e
	note $26 $07
	note $26 $07
	note $26 $07
	note $26 $07
	note $26 $0e
	note $26 $04
	vol $4
	note $26 $05
	vol $3
	note $26 $05
	vol $5
	note $26 $0e
	note $26 $04
	vol $4
	note $26 $05
	vol $3
	note $26 $05
	vol $5
	note $26 $0e
	note $26 $0e
	note $26 $0e
	note $26 $04
	vol $4
	note $26 $05
	vol $3
	note $26 $05
	vol $5
	note $26 $0e
	note $26 $04
	vol $4
	note $26 $05
	vol $3
	note $26 $05
	vol $5
	note $26 $0e
	note $26 $04
	vol $4
	note $26 $05
	vol $3
	note $26 $05
	vol $5
	note $26 $0e
	note $26 $0e
	note $26 $0e
	note $26 $04
	vol $4
	note $26 $05
	vol $3
	note $26 $05
	vol $5
	note $26 $0e
	note $26 $04
	vol $4
	note $26 $05
	vol $3
	note $26 $05
	vol $5
	note $26 $0e
	note $26 $04
	vol $4
	note $26 $05
	vol $3
	note $26 $05
	vol $5
	note $26 $0e
	note $26 $0e
	note $26 $0e
	note $26 $04
	vol $4
	note $26 $05
	vol $3
	note $26 $05
	vol $5
	note $26 $0e
	note $26 $04
	vol $4
	note $26 $05
	vol $3
	note $26 $05
	vol $5
	note $26 $0e
	note $26 $04
	vol $4
	note $26 $05
	vol $3
	note $26 $05
	vol $5
	note $26 $0e
	note $26 $0e
	note $26 $0e
	note $26 $04
	vol $4
	note $26 $05
	vol $3
	note $26 $05
	vol $5
	note $26 $0e
	note $26 $04
	vol $4
	note $26 $05
	vol $3
	note $26 $05
	vol $5
	note $26 $0e
	note $26 $04
	vol $4
	note $26 $05
	vol $3
	note $26 $05
	vol $5
	note $26 $0e
	note $26 $0e
	note $26 $0e
	note $26 $04
	vol $4
	note $26 $05
	vol $3
	note $26 $05
	vol $5
	note $26 $0e
	note $26 $04
	vol $4
	note $26 $05
	vol $3
	note $26 $05
	vol $5
	note $26 $0e
	note $26 $04
	vol $4
	note $26 $05
	vol $3
	note $26 $05
	vol $5
	note $26 $0e
	note $26 $0e
	note $26 $0e
	note $26 $04
	vol $4
	note $26 $05
	vol $3
	note $26 $05
	vol $5
	note $26 $0e
	note $26 $04
	vol $4
	note $26 $05
	vol $3
	note $26 $05
	vol $5
	note $26 $0e
	note $26 $04
	vol $4
	note $26 $05
	vol $3
	note $26 $05
	vol $5
	note $26 $0e
	note $26 $0e
	note $26 $0e
	note $26 $04
	vol $4
	note $26 $05
	vol $3
	note $26 $05
	vol $5
	note $26 $0e
	note $26 $04
	vol $4
	note $26 $05
	vol $3
	note $26 $05
	vol $3
	note $2e $46
	vol $5
	note $26 $0e
	vol $4
	note $26 $2a
	vol $5
	note $26 $0e
	vol $4
	note $26 $2a
	vol $5
	note $26 $04
	vol $4
	note $26 $05
	vol $3
	note $26 $05
	goto musicf6258
	cmdff

sound46Channel1:
	vibrato $00
	env $0 $00
	duty $01
musicf6412:
	vol $6
	note b3  $2c
	note cs4 $42
	vol $3
	note cs4 $16
	vol $6
	note cs4 $2c
	note ds4 $42
	vol $3
	note ds4 $16
	vol $6
	note ds4 $2c
	note e4  $2c
	note g4  $2c
	note as4 $2c
	note cs5 $2c
	note e5  $2c
	note g5  $2c
	vol $6
	note as5 $03
	rest $03
	note d6  $05
	vol $4
	note as5 $03
	vol $6
	note as5 $03
	vol $4
	note d6  $05
	rest $03
	note as5 $03
	vol $6
	note as5 $05
	rest $07
	vol $4
	note as5 $04
	vol $6
	note as5 $03
	rest $03
	note d6  $05
	vol $4
	note as5 $03
	vol $6
	note as5 $03
	vol $4
	note d6  $05
	rest $03
	note as5 $03
	vol $6
	note as5 $05
	rest $07
	vol $4
	note as5 $04
	vol $6
	note as5 $03
	rest $03
	note d6  $05
	vol $4
	note as5 $03
	vol $6
	note as5 $03
	vol $4
	note d6  $05
	rest $03
	note as5 $03
	vol $6
	note as5 $05
	rest $07
	vol $4
	note as5 $04
	vol $6
	note as5 $03
	rest $03
	note d6  $05
	vol $4
	note as5 $03
	vol $6
	note as5 $03
	vol $4
	note d6  $05
	rest $03
	note as5 $03
	vol $6
	note as5 $05
	rest $07
	vol $4
	note as5 $04
	vol $6
	note d6  $0b
	note f6  $0b
	note gs6 $0b
	note c7  $0b
	rest $58
	vol $6
	note cs4 $2c
	note ds4 $42
	vol $3
	note ds4 $16
	vol $6
	note ds4 $2c
	note f4  $42
	vol $3
	note f4  $16
	vol $6
	note f4  $2c
	vol $6
	note fs4 $2c
	note a4  $2c
	note c5  $2c
	note ds5 $2c
	note fs5 $2c
	note a5  $2c
	note c6  $03
	rest $03
	note e6  $05
	vol $4
	note c6  $03
	vol $6
	note c6  $03
	vol $4
	note e6  $05
	rest $03
	note c6  $03
	vol $6
	note c6  $05
	rest $07
	vol $4
	note c6  $04
	vol $6
	note c6  $03
	rest $03
	note e6  $05
	vol $4
	note c6  $03
	vol $6
	note c6  $03
	vol $4
	note e6  $05
	rest $03
	note c6  $03
	vol $6
	note c6  $05
	rest $07
	vol $4
	note c6  $04
	vol $6
	note c6  $03
	rest $03
	note e6  $05
	vol $4
	note c6  $03
	vol $6
	note c6  $03
	vol $4
	note e6  $05
	rest $03
	note c6  $03
	vol $6
	note c6  $05
	rest $07
	vol $4
	note c6  $04
	vol $6
	note c6  $03
	rest $03
	note e6  $05
	vol $3
	note c6  $03
	vol $6
	note c6  $03
	vol $3
	note e6  $05
	rest $03
	note c6  $03
	vol $6
	note c6  $05
	rest $07
	vol $3
	note c6  $04
	vol $6
	note e6  $0b
	note g6  $0b
	note as6 $0b
	note c7  $0b
	rest $58
	goto musicf6412
	cmdff

sound46Channel0:
	vibrato $00
	env $0 $00
	duty $01
musicf6550:
	vol $7
	note fs3 $2c
	note gs3 $4d
	vol $3
	note gs3 $0b
	vol $7
	note gs3 $2c
	note as3 $4d
	vol $3
	note as3 $0b
	vol $7
	note as3 $2c
	note b3  $2c
	note d4  $2c
	note f4  $2c
	note gs4 $2c
	note b4  $2c
	note d5  $2c
	note e5  $b0
	rest $10
	vol $3
	note d6  $0b
	note f6  $0b
	note gs6 $0b
	note c7  $0b
	rest $48
	vol $6
	note gs3 $2c
	note as3 $4d
	vol $3
	note as3 $0b
	vol $6
	note as3 $2c
	note c4  $4d
	vol $3
	note c4  $0b
	vol $6
	note c4  $2c
	note cs4 $2c
	note e4  $2c
	note g4  $2c
	note as4 $2c
	note cs5 $2c
	note e5  $2c
	note fs5 $b0
	rest $10
	vol $3
	note e6  $0b
	note g6  $0b
	note as6 $0b
	note c7  $0b
	rest $48
	goto musicf6550
	cmdff

sound46Channel4:
musicf65b0:
	duty $0e
	note g2  $2c
	note a2  $42
	rest $16
	note a2  $2c
	note b2  $42
	rest $16
	note b2  $2c
	note c3  $2c
	note e3  $2c
	note g3  $2c
	note as3 $2c
	note cs4 $2c
	note e4  $2c
	note g4  $b0
	rest $84
	note a2  $2c
	note b2  $42
	rest $16
	note b2  $2c
	note cs3 $42
	rest $16
	note cs3 $2c
	note d3  $2c
	note fs3 $2c
	note a3  $2c
	note c4  $2c
	note ds4 $2c
	note fs4 $2c
	note a4  $b0
	rest $84
	goto musicf65b0
	cmdff

sound38Channel1:
musicf65f2:
	vibrato $f1
	env $0 $00
	duty $02
	vol $6
	note as4 $0b
	note c5  $0b
	note cs5 $0b
	note ds5 $0b
	note f5  $2c
	note ds5 $16
	note gs5 $16
	note as5 $0b
	rest $05
	vol $3
	note as5 $06
	vol $6
	note f5  $0b
	note ds5 $0b
	note f5  $2c
	note ds5 $16
	note gs5 $16
	note c6  $03
	note cs6 $03
	note c6  $10
	note as5 $0b
	note gs5 $0b
	note f5  $0b
	rest $05
	vol $3
	note f5  $06
	vol $6
	note as5 $0b
	note gs5 $0b
	note f5  $16
	note ds5 $0b
	note cs5 $0b
	note as4 $0b
	rest $05
	vol $3
	note as4 $06
	vol $6
	note f5  $0b
	note ds5 $0b
	note f5  $2c
	vibrato $01
	env $0 $00
	vol $3
	note f5  $16
	vibrato $f1
	env $0 $00
	vol $6
	note as5 $0b
	rest $05
	vol $3
	note as5 $06
	vol $6
	note c6  $0b
	note cs6 $0b
	note ds6 $0b
	rest $05
	vol $3
	note ds6 $06
	vol $6
	note ds6 $21
	note c6  $0b
	note f6  $0b
	note ds6 $03
	note f6  $03
	note ds6 $05
	note cs6 $0b
	note c6  $0b
	note as5 $2c
	vibrato $01
	env $0 $00
	vol $3
	note as5 $0b
	vibrato $f1
	env $0 $00
	vol $6
	note c6  $0b
	note cs6 $0b
	note f6  $0b
	note g6  $0b
	note gs6 $05
	note g6  $06
	note f6  $0b
	note ds6 $0b
	note f6  $2c
	note ds6 $05
	rest $01
	vol $4
	note ds6 $07
	rest $01
	vol $3
	note ds6 $05
	rest $03
	vol $6
	note cs6 $05
	rest $01
	vol $4
	note cs6 $07
	rest $01
	vol $3
	note cs6 $05
	rest $03
	vol $6
	note c6  $05
	rest $01
	vol $4
	note c6  $07
	rest $01
	vol $3
	note c6  $05
	rest $03
	vol $6
	note as5 $05
	rest $01
	vol $3
	note as5 $07
	rest $01
	vol $3
	note as5 $05
	rest $03
	vol $6
	note as4 $16
	note f5  $16
	note ds5 $16
	note f5  $0b
	note fs5 $0b
	note gs5 $16
	vibrato $01
	env $0 $00
	vol $3
	note gs5 $16
	vol $1
	note gs5 $0b
	rest $0b
	vibrato $f1
	env $0 $00
	vol $6
	note as5 $16
	note f6  $0b
	rest $05
	vol $3
	note f6  $06
	vol $6
	note ds6 $0b
	note cs6 $0b
	note c6  $16
	note cs6 $16
	note c6  $16
	note as5 $0b
	note gs5 $0b
	note f5  $0b
	rest $05
	vol $3
	note f5  $06
	vol $6
	note as5 $0b
	note gs5 $0b
	note f5  $07
	rest $04
	note f5  $0b
	note ds5 $0b
	note cs5 $0b
	note as4 $05
	rest $01
	vol $5
	note as4 $07
	rest $01
	vol $4
	note as4 $05
	rest $03
	vol $6
	note f5  $05
	rest $01
	vol $4
	note f5  $07
	rest $01
	vol $3
	note f5  $05
	rest $03
	vol $6
	note as5 $05
	rest $06
	vol $5
	note as5 $05
	rest $06
	vol $4
	note as5 $05
	rest $27
	vol $6
	note as5 $0b
	note c6  $0b
	note cs6 $0b
	note ds6 $0b
	note f6  $0b
	rest $05
	vol $3
	note f6  $06
	vol $6
	note ds6 $0b
	note cs6 $0b
	note c6  $0b
	note as5 $0b
	note c6  $0b
	note as5 $0b
	note gs5 $0b
	note f5  $0b
	rest $05
	vol $3
	note f5  $0b
	rest $06
	vol $6
	note as5 $0b
	rest $05
	vol $3
	note as5 $06
	vol $6
	note f5  $16
	note ds6 $0b
	note cs6 $0b
	note c6  $0b
	note cs6 $05
	note c6  $06
	note as5 $0b
	note gs5 $0b
	note as5 $16
	note ds5 $0b
	note f5  $0b
	note ds5 $16
	note cs5 $07
	note ds5 $07
	note cs5 $08
	note c5  $07
	note cs5 $07
	note c5  $08
	note gs4 $07
	note as4 $07
	note gs4 $08
	note as4 $05
	rest $01
	vol $4
	note as4 $07
	rest $09
	vol $6
	note ds5 $05
	rest $01
	vol $4
	note ds5 $07
	rest $09
	vol $6
	note as5 $05
	rest $01
	vol $4
	note as5 $07
	rest $01
	vol $2
	note as5 $05
	rest $45
	goto musicf65f2
	cmdff

sound38Channel0:
musicf67c7:
	vibrato $00
	env $0 $04
	duty $02
	vol $6
	note as3 $16
	note f4  $16
	note gs4 $16
	note f4  $16
	note c4  $16
	note f4  $16
	note cs4 $16
	note f4  $16
	note as4 $16
	note f4  $16
	note c4  $16
	note g4  $16
	note as3 $16
	note f4  $16
	note gs4 $16
	note f4  $16
	note gs3 $16
	note gs4 $16
	note fs3 $16
	note f4  $16
	note as4 $16
	note f4  $16
	note fs3 $16
	note f4  $16
	note f3  $16
	note gs4 $16
	note c5  $16
	note gs4 $16
	note f3  $16
	note gs4 $16
	note as3 $16
	note f4  $16
	note gs4 $16
	note cs4 $16
	note ds4 $16
	note cs4 $0b
	note c4  $0b
	note as3 $0b
	note c4  $0b
	note cs4 $0b
	note f4  $0b
	note as4 $16
	note f4  $16
	note g4  $16
	vol $6
	note f4  $0b
	note ds4 $0b
	vibrato $f1
	env $0 $00
	note fs4 $2c
	note f3  $58
	rest $16
	note fs3 $16
	note f3  $4d
	rest $0b
	note fs3 $2c
	note gs3 $2c
	note fs3 $2c
	note g3  $16
	note gs3 $0b
	rest $0b
	note gs3 $16
	vol $6
	note as3 $0b
	rest $0b
	note as3 $16
	note c4  $0b
	rest $0b
	note cs4 $16
	note as3 $16
	note c4  $16
	note ds4 $16
	note f4  $16
	note c4  $16
	note cs4 $16
	note f4  $16
	note as4 $16
	note f4  $16
	note ds4 $16
	note gs4 $16
	note f4  $16
	note gs4 $16
	note g4  $16
	note ds4 $16
	note f4  $16
	note cs4 $16
	note ds4 $16
	note as3 $16
	note as3 $16
	note c4  $0b
	note cs4 $0b
	note c4  $16
	note gs3 $16
	goto musicf67c7
	cmdff

sound38Channel4:
musicf688a:
	duty $0f
	rest $0b
	note as4 $0b
	note c5  $0b
	note cs5 $0b
	note ds5 $0b
	note f5  $2c
	note ds5 $16
	note gs5 $16
	note as5 $0b
	rest $0b
	note f5  $0b
	note ds5 $0b
	note f5  $2c
	note ds5 $16
	note gs5 $16
	note c6  $03
	note cs6 $03
	note c6  $10
	note as5 $0b
	note gs5 $0b
	note f5  $0b
	rest $0b
	note as5 $0b
	note gs5 $0b
	note f5  $16
	note ds5 $0b
	note cs5 $0b
	note as4 $0b
	rest $0b
	note f5  $0b
	note ds5 $0b
	note f5  $2c
	rest $16
	note as5 $0b
	rest $0b
	note c6  $0b
	note cs6 $0b
	note ds6 $0b
	rest $0b
	note ds6 $21
	note c6  $0b
	note f6  $0b
	note ds6 $03
	note f6  $03
	note ds6 $05
	note cs6 $0b
	note c6  $0b
	note as5 $2c
	note as5 $0b
	note c6  $0b
	note cs6 $0b
	note f6  $0b
	note g6  $0b
	note gs6 $05
	note g6  $06
	note f6  $0b
	note ds6 $0b
	note f6  $2c
	rest $4d
	duty $0e
	note cs3 $2c
	note c3  $16
	note ds3 $16
	note f3  $16
	note c3  $16
	rest $16
	note cs3 $16
	note c3  $16
	note c3  $16
	note f3  $16
	note c3  $16
	note cs3 $2c
	note c3  $2c
	note as2 $2c
	note ds3 $2c
	note as2 $2c
	note ds3 $16
	duty $0f
	note ds3 $0b
	rest $0b
	duty $0e
	note fs3 $2c
	note gs3 $58
	duty $0f
	note gs3 $16
	duty $0e
	note fs3 $16
	note gs3 $26
	duty $0f
	note gs3 $06
	duty $0e
	note gs3 $2c
	note as3 $2c
	note gs3 $2c
	note fs3 $2c
	note ds3 $58
	duty $0f
	note ds3 $16
	rest $16
	goto musicf688a
	cmdff

sound2bStart:

sound2bChannel1:
	vibrato $e1
	env $0 $00
	duty $02
	vol $6
	note fs2 $0e
	note g2  $03
	rest $01
	vol $3
	note g2  $04
	rest $01
	vol $1
	note g2  $05
	vol $6
	note fs3 $0e
	note g3  $03
	rest $01
	vol $3
	note g3  $04
	rest $01
	vol $1
	note g3  $05
	vol $6
	note fs4 $0e
	note g4  $03
	rest $01
	vol $3
	note g4  $04
	rest $01
	vol $1
	note g4  $05
	vol $6
	note fs5 $0e
	note g5  $03
	rest $01
	vol $3
	note g5  $04
	rest $01
	vol $1
	note g5  $05
	vol $6
	note fs3 $04
	note g3  $05
	note c4  $05
	note as3 $46
	vibrato $01
	env $0 $00
	vol $3
	note as3 $1c
	vol $1
	note as3 $0e
	rest $0e
	vibrato $e1
	env $0 $00
musicf69b1:
	vol $6
	note c5  $09
	rest $07
	vol $3
	note c5  $09
	rest $03
	vol $6
	note c5  $09
	rest $05
	vol $3
	note c5  $04
	vol $6
	note c5  $0a
	note g5  $09
	rest $07
	vol $3
	note g5  $09
	rest $03
	vol $6
	note g5  $12
	rest $05
	note g5  $02
	note a5  $03
	note as5 $12
	note a5  $0a
	note g5  $12
	note f5  $0a
	note g5  $38
	vibrato $01
	env $0 $00
	vol $3
	note g5  $12
	vibrato $f1
	env $0 $00
	vol $6
	note c6  $05
	vol $3
	note c6  $05
	vol $6
	note c6  $0e
	vol $3
	note c6  $04
	vol $6
	note c6  $0a
	note g5  $09
	rest $09
	vol $3
	note g5  $0a
	vol $6
	note g5  $12
	note a5  $0a
	note as5 $12
	note a5  $0a
	note g5  $12
	note f5  $0a
	note e5  $12
	note f5  $0a
	note fs5 $12
	note g5  $0a
	note e5  $09
	rest $0e
	vol $3
	note e5  $05
	vol $6
	note c5  $09
	rest $0e
	vol $3
	note c5  $05
	vol $6
	note as4 $09
	rest $0e
	vol $3
	note as4 $05
	rest $12
	vol $6
	note e5  $13
	vol $3
	note e5  $09
	vol $6
	note e5  $0a
	note c5  $09
	rest $0e
	vol $3
	note c5  $05
	vol $6
	note as4 $09
	rest $0e
	vol $3
	note as4 $05
	rest $1c
	vol $6
	note e5  $09
	rest $0e
	vol $3
	note e5  $05
	vol $6
	note c5  $09
	rest $0e
	vol $3
	note c5  $05
	vol $6
	note as4 $09
	rest $0e
	vol $3
	note as4 $05
	vol $6
	note g4  $38
	vibrato $01
	env $0 $00
	vol $3
	note g4  $38
	rest $1c
	vibrato $f1
	env $0 $00
	vol $6
	note e5  $09
	rest $0e
	vol $3
	note e5  $05
	vol $6
	note c5  $09
	rest $0e
	vol $3
	note c5  $05
	vol $6
	note as4 $09
	rest $0e
	vol $3
	note as4 $05
	rest $12
	vol $6
	note e5  $13
	vol $3
	note e5  $09
	vol $6
	note e5  $0a
	note c5  $09
	rest $0e
	vol $3
	note c5  $05
	vol $6
	note as4 $09
	rest $0e
	vol $3
	note as4 $05
	rest $1c
	vol $6
	note e5  $09
	rest $0e
	vol $3
	note e5  $05
	vol $6
	note c5  $09
	rest $0e
	vol $3
	note c5  $05
	vol $6
	note as5 $12
	note a5  $0a
	rest $09
	vol $3
	note a5  $09
	vol $6
	note g5  $54
	vibrato $01
	env $0 $00
	vol $3
	note g5  $1c
	vol $1
	note g5  $09
	rest $01
	vibrato $f1
	env $0 $00
	goto musicf69b1
	cmdff

sound2bChannel0:
	vibrato $e1
	env $0 $00
	duty $02
	vol $6
	note cs2 $0e
	note c2  $03
	rest $01
	vol $3
	note c2  $04
	rest $01
	vol $1
	note c2  $05
	vol $6
	note cs3 $0e
	note c3  $03
	rest $01
	vol $3
	note c3  $04
	rest $01
	vol $1
	note c3  $05
	vol $6
	note cs4 $0e
	note c4  $03
	rest $01
	vol $3
	note c4  $04
	rest $01
	vol $1
	note c4  $05
	vol $6
	note cs5 $0e
	note c5  $03
	rest $01
	vol $3
	note c5  $04
	rest $01
	vol $1
	note c5  $05
	vol $6
	note fs2 $04
	note g2  $05
	note c3  $05
	note as2 $46
	vibrato $01
	env $0 $00
	vol $3
	note as2 $1c
	vol $1
	note as2 $0e
	rest $0e
	vibrato $f1
	env $0 $00
musicf6b33:
	rest $ff
	rest $47
	vol $6
	note fs3 $0a
	note g3  $12
	note fs3 $0a
	note g3  $12
	note fs3 $0a
	note g3  $0e
	rest $04
	note f3  $0a
	note e3  $12
	note d3  $0a
	note c3  $09
	rest $48
	vol $6
	note fs3 $03
	note g3  $07
	rest $04
	vol $3
	note fs3 $03
	note g3  $07
	rest $04
	vol $1
	note fs3 $03
	note g3  $07
	rest $41
	vol $6
	note fs3 $02
	note g3  $07
	note fs3 $03
	note g3  $07
	rest $04
	vol $3
	note fs3 $03
	note g3  $07
	rest $04
	vol $1
	note fs3 $03
	note g3  $07
	rest $72
	vol $6
	note b2  $09
	note ds3 $0a
	note g3  $09
	note b3  $09
	note ds4 $0a
	note g4  $2a
	note f4  $04
	note e4  $05
	note d4  $05
	note c4  $09
	rest $48
	note fs3 $03
	note g3  $07
	rest $04
	vol $3
	note fs3 $03
	note g3  $07
	rest $04
	vol $1
	note fs3 $03
	note g3  $07
	rest $41
	vol $6
	note fs4 $02
	note g4  $07
	note fs4 $03
	note g4  $07
	rest $04
	vol $3
	note fs4 $03
	note g4  $07
	rest $04
	vol $1
	note fs4 $03
	note g4  $07
	rest $d9
	goto musicf6b33
	cmdff

sound2bChannel4:
	rest $ee
	duty $0e
	note g2  $03
	note f2  $04
	note ds2 $03
	note cs2 $04
musicf6bd2:
	duty $0e
	note c2  $07
	duty $0f
	note c2  $0e
	rest $23
	duty $0e
	note g2  $07
	duty $0f
	note g2  $0e
	rest $23
	duty $0e
	note as1 $07
	duty $0f
	note as1 $0e
	rest $23
	duty $0e
	note f2  $07
	duty $0f
	note f2  $0e
	rest $23
	duty $0e
	note c2  $07
	duty $0f
	note c2  $0e
	rest $23
	duty $0e
	note g2  $07
	duty $0f
	note g2  $0e
	rest $23
	duty $0e
	note d2  $07
	duty $0f
	note d2  $0e
	rest $35
	duty $0e
	note g2  $0a
	duty $0e
	note a2  $09
	duty $0f
	note a2  $09
	duty $0e
	note b2  $0a
	duty $0e
	note c2  $1c
	duty $0f
	note c2  $0e
	rest $0e
	duty $0e
	note g2  $07
	duty $0f
	note g2  $0e
	rest $23
	duty $0e
	note as2 $07
	duty $0f
	note as2 $0e
	rest $23
	duty $0e
	note f2  $07
	duty $0f
	note f2  $0e
	rest $23
	duty $0e
	note c3  $07
	duty $0f
	note c3  $0e
	rest $23
	duty $0e
	note as2 $07
	duty $0f
	note as2 $0e
	rest $07
	duty $0e
	note g2  $0e
	note g1  $04
	note b1  $05
	note ds2 $05
	duty $0e
	note g2  $38
	note fs2 $02
	duty $0e
	note g2  $07
	duty $0f
	note g2  $0e
	rest $21
	duty $0e
	note c3  $07
	duty $0f
	note c3  $0e
	rest $23
	duty $0e
	note g2  $07
	duty $0f
	note g2  $0e
	rest $23
	duty $0e
	note as2 $07
	duty $0f
	note as2 $0e
	rest $23
	duty $0e
	note f2  $07
	duty $0f
	note f2  $0e
	rest $23
	duty $0e
	note c3  $07
	duty $0f
	note c3  $0e
	rest $07
	duty $0e
	note c3  $07
	duty $0f
	note c3  $0e
	rest $07
	duty $0e
	note as2 $07
	duty $0f
	note as2 $0e
	rest $07
	duty $0e
	note g2  $2e
	note gs2 $0a
	note as2 $12
	note b2  $0a
	note cs3 $12
	note ds3 $0a
	note f3  $12
	note g3  $0a
	goto musicf6bd2
	cmdff

sound2bChannel6:
	rest $fc
musicf6cdc:
	vol $2
	note $2e $1c
	note $2a $1c
	note $2e $1c
	note $2a $1c
	note $2e $1c
	note $2a $1c
	note $2e $12
	note $2a $0a
	note $2a $12
	note $2a $0a
	vol $2
	note $2e $1c
	note $2a $1c
	note $2e $1c
	note $2a $1c
	note $2e $1c
	note $2a $1c
	note $2e $09
	rest $09
	note $2a $0a
	note $2a $12
	note $2a $0a
	note $2e $1c
	note $2a $1c
	note $2e $1c
	note $2a $1c
	vol $2
	note $2e $1c
	note $2a $1c
	note $2e $1c
	note $2a $1c
	vol $2
	note $2e $1c
	note $2a $1c
	note $2a $1c
	vol $2
	note $2e $1c
	rest $70
	vol $2
	note $2e $1c
	note $2a $1c
	vol $3
	note $2e $1c
	note $2a $1c
	note $2e $1c
	note $2a $1c
	note $2e $1c
	vol $3
	note $2a $1c
	note $2e $1c
	note $2a $1c
	note $2a $1c
	note $2e $1c
	rest $70
	goto musicf6cdc
	cmdff

sound3fStart:

sound3fChannel1:
	vibrato $e1
	env $0 $00
	cmdf2
	duty $01
	vol $5
	note d4  $2a
	vol $3
	note d4  $0e
	vol $5
	note g4  $54
	vibrato $01
	env $0 $00
	vol $3
	note g4  $1c
	vibrato $e1
	env $0 $00
	vol $5
	note d4  $1c
	note g4  $1c
	note f4  $0e
	note e4  $0e
	note f4  $1c
	note c4  $38
	vibrato $01
	env $0 $00
	vol $3
	note c4  $1c
	vibrato $e1
	env $0 $00
	vol $6
	note c4  $1c
	note f4  $1c
	note as4 $1c
	note gs4 $0e
	note fs4 $0e
	note gs4 $1c
	note ds4 $38
	vibrato $01
	env $0 $00
	vol $3
	note ds4 $1c
	vibrato $e1
	env $0 $00
	vol $6
	note ds4 $1c
	note gs4 $1c
	note cs5 $1c
	note b4  $0e
	note as4 $0e
	note b4  $1c
	note fs4 $38
	vibrato $01
	env $0 $00
	vol $4
	note fs4 $1c
	vibrato $e1
	env $0 $00
	vol $7
	note fs4 $1c
	vol $6
	note b4  $1c
	vol $9
	note e5  $1c
	vol $4
	note e5  $07
	rest $03
	vol $3
	note e5  $07
	rest $04
	vol $2
	note e5  $07
	duty $02
	vol $6
	note ds5 $15
	vol $4
	note ds5 $07
	vol $6
	note as4 $07
	rest $03
	vol $4
	note as4 $04
	vol $6
	note as5 $07
	rest $03
	vol $4
	note as5 $04
	vol $6
	note gs5 $1c
	note g5  $07
	rest $03
	vol $4
	note g5  $04
	vol $6
	note f5  $1c
	note cs5 $07
	rest $03
	vol $4
	note cs5 $04
	vol $6
	note ds5 $07
	note f5  $07
	note g5  $07
	rest $03
	vol $4
	note g5  $04
	vol $6
	note f5  $0e
	note ds5 $0e
	note cs5 $0e
	note f5  $0e
	note ds5 $1c
	vibrato $01
	env $0 $00
	vol $4
	note ds5 $1c
	vibrato $e1
	env $0 $00
	vol $6
	note ds5 $07
	note f5  $07
	note g5  $07
	note gs5 $07
	rest $03
	vol $4
	note gs5 $07
	rest $04
	vol $2
	note gs5 $07
	rest $03
	vol $1
	note gs5 $04
	vol $6
	note as5 $1c
	note ds6 $1c
	vol $4
	note ds6 $0e
	vol $6
	note f6  $0e
	note cs6 $0e
	note as5 $07
	note cs6 $07
	note ds6 $07
	note f6  $07
	note fs6 $07
	rest $03
	vol $4
	note fs6 $04
	vol $6
	note f6  $0e
	note ds6 $0e
	note cs6 $0e
	note as5 $0e
	rest $03
	vol $4
	note as5 $07
	rest $04
	vol $6
	note f6  $07
	rest $03
	vol $4
	note f6  $04
	vol $6
	note fs6 $07
	note gs6 $07
	note a6  $07
	rest $03
	vol $4
	note a6  $04
	vol $6
	note gs6 $0e
	note fs6 $0e
	note e6  $0e
	note d6  $0e
	note c6  $1c
	note b5  $07
	rest $03
	vol $4
	note b5  $04
	vol $6
	note a5  $1c
	note g5  $07
	rest $03
	vol $4
	note g5  $04
	vol $6
	note a5  $38
	vibrato $01
	env $0 $00
	vol $4
	note a5  $1c
	vibrato $e1
	vol $6
	note gs5 $1c
	vol $6
	note fs5 $07
	rest $03
	vol $3
	note fs5 $04
	vol $6
	note e5  $1c
	note d5  $07
	rest $03
	vol $3
	note d5  $04
	vol $6
	note e5  $46
	vibrato $01
	env $0 $00
	vol $3
	note e5  $0e
	vibrato $e1
	vol $6
	note b4  $07
	rest $07
	vol $4
	note b4  $07
	rest $07
	vol $2
	note b4  $07
	rest $07
	vol $1
	note b4  $07
	rest $07
	vibrato $e1
	env $0 $00
	vol $0
	note b4  $07
	rest $15
	vibrato $00
	duty $02
musicf6ed3:
	vol $5
	note e5  $05
	rest $05
	vol $7
	note d5  $05
	vol $3
	note e5  $05
	vol $7
	note a4  $05
	vol $4
	note d5  $05
	vol $7
	note d5  $05
	vol $4
	note a4  $05
	vol $7
	note e5  $05
	vol $4
	note d5  $05
	vol $7
	note g5  $05
	vol $4
	note e5  $05
	vol $7
	note e5  $05
	vol $4
	note g5  $05
	vol $7
	note d5  $05
	vol $4
	note e5  $05
	vol $7
	note e5  $05
	vol $4
	note d5  $05
	vol $7
	note d5  $05
	vol $4
	note e5  $05
	vol $7
	note a4  $05
	vol $4
	note d5  $05
	vol $7
	note d5  $05
	vol $4
	note a4  $05
	vol $7
	note e5  $05
	vol $4
	note d5  $05
	vol $7
	note g5  $05
	vol $4
	note e5  $05
	vol $7
	note e5  $05
	vol $4
	note g5  $05
	vol $7
	note d5  $05
	vol $4
	note e5  $05
	vol $7
	note e5  $05
	vol $4
	note d5  $05
	vol $7
	note d5  $05
	vol $4
	note e5  $05
	vol $7
	note a4  $05
	vol $4
	note d5  $05
	vol $7
	note d5  $05
	vol $4
	note a4  $05
	vol $7
	note e5  $05
	vol $4
	note d5  $05
	vol $7
	note g5  $05
	vol $4
	note e5  $05
	vol $7
	note e5  $05
	vol $4
	note g5  $05
	vol $7
	note d5  $05
	vol $4
	note e5  $05
	vol $7
	note e5  $05
	vol $4
	note d5  $05
	vol $7
	note d5  $05
	vol $4
	note e5  $05
	vol $7
	note a4  $05
	vol $4
	note d5  $05
	vol $7
	note d5  $05
	vol $4
	note a4  $05
	vol $7
	note e5  $05
	vol $4
	note d5  $05
	vol $7
	note g5  $05
	vol $4
	note e5  $05
	vol $7
	note e5  $05
	vol $4
	note g5  $05
	vol $7
	note d5  $05
	vol $4
	note e5  $05
	vol $7
	note a4  $05
	vol $4
	note d5  $05
	vol $7
	note d5  $05
	vol $4
	note a4  $05
	vol $7
	note e5  $05
	vol $4
	note d5  $05
	vol $7
	note g5  $05
	vol $4
	note e5  $05
	vol $7
	note e5  $05
	vol $4
	note g5  $05
	vol $7
	note d5  $05
	vol $4
	note e5  $05
	vol $7
	note e5  $05
	vol $4
	note d5  $05
	vol $7
	note d5  $05
	vol $4
	note e5  $05
	vol $7
	note a4  $05
	vol $4
	note d5  $05
	vol $7
	note d5  $05
	vol $4
	note a4  $05
	vol $7
	note e5  $05
	vol $4
	note d5  $05
	vol $7
	note g5  $05
	vol $4
	note e5  $05
	vol $7
	note e5  $05
	vol $4
	note g5  $05
	vol $7
	note d5  $05
	vol $4
	note e5  $05
	vol $7
	note a4  $05
	vol $4
	note d5  $05
	vol $7
	note d5  $05
	vol $4
	note a4  $05
	vol $7
	note e5  $05
	vol $4
	note d5  $05
	vol $7
	note g5  $05
	vol $4
	note e5  $05
	vol $7
	note e5  $05
	vol $4
	note g5  $05
	vol $7
	note d5  $05
	vol $4
	note e5  $05
	vol $7
	note e5  $05
	vol $4
	note d5  $05
	vol $7
	note d5  $05
	vol $4
	note e5  $05
	vol $7
	note e5  $05
	vol $4
	note d5  $05
	vol $7
	note d5  $05
	vol $4
	note e5  $05
	vol $7
	note a4  $05
	vol $4
	note d5  $05
	vol $7
	note d5  $05
	vol $4
	note a4  $05
	vol $7
	note e5  $05
	vol $4
	note d5  $05
	vol $7
	note g5  $05
	vol $4
	note e5  $05
	vol $7
	note e5  $05
	vol $4
	note g5  $05
	vol $7
	note d5  $05
	vol $4
	note e5  $05
	vol $7
	note e5  $05
	vol $4
	note d5  $05
	vol $7
	note d5  $05
	vol $4
	note e5  $05
	vol $7
	note a4  $05
	vol $4
	note d5  $05
	vol $7
	note d5  $05
	vol $4
	note a4  $05
	vol $7
	note e5  $05
	vol $4
	note d5  $05
	vol $7
	note g5  $05
	vol $4
	note e5  $05
	vol $7
	note e5  $05
	vol $4
	note g5  $05
	vol $7
	note d5  $05
	vol $4
	note e5  $05
	vol $7
	note e5  $05
	vol $4
	note d5  $05
	vol $7
	note d5  $05
	vol $4
	note e5  $05
	vol $7
	note a4  $05
	vol $4
	note d5  $05
	vol $7
	note d5  $05
	vol $4
	note a4  $05
	vol $7
	note e5  $05
	vol $4
	note d5  $05
	vol $7
	note g5  $05
	vol $4
	note e5  $05
	vol $7
	note b5  $05
	vol $4
	note g5  $05
	vol $7
	note a5  $05
	vol $4
	note b5  $05
	vol $7
	note b5  $05
	vol $4
	note a5  $05
	vol $7
	note a5  $05
	vol $4
	note b5  $05
	vol $7
	note e5  $05
	vol $4
	note a5  $05
	vol $7
	note g5  $05
	vol $4
	note e5  $05
	vol $7
	note a5  $05
	vol $4
	note g5  $05
	vol $7
	note c6  $05
	vol $4
	note a5  $05
	vol $7
	note b5  $05
	vol $4
	note c6  $05
	vol $7
	note a5  $05
	vol $4
	note b5  $05
	vol $7
	note b5  $05
	vol $4
	note a5  $05
	vol $7
	note a5  $05
	vol $4
	note b5  $05
	vol $7
	note e5  $05
	vol $4
	note a5  $05
	vol $7
	note g5  $05
	vol $4
	note e5  $05
	vol $7
	note a5  $05
	vol $4
	note g5  $05
	vol $7
	note c6  $05
	vol $4
	note a5  $05
	vol $7
	note b5  $05
	vol $4
	note c6  $05
	vol $7
	note a5  $05
	vol $4
	note b5  $05
	vol $7
	note b5  $05
	vol $4
	note a5  $05
	vol $7
	note a5  $05
	vol $4
	note b5  $05
	vol $7
	note e5  $05
	vol $4
	note a5  $05
	vol $7
	note g5  $05
	vol $4
	note e5  $05
	vol $7
	note a5  $05
	vol $4
	note g5  $05
	vol $7
	note c6  $05
	vol $4
	note a5  $05
	vol $7
	note b5  $05
	vol $4
	note c6  $05
	vol $7
	note a5  $05
	vol $4
	note b5  $05
	vol $7
	note b5  $05
	vol $4
	note a5  $05
	vol $7
	note a5  $05
	vol $4
	note b5  $05
	vol $7
	note e5  $05
	vol $4
	note a5  $05
	vol $7
	note g5  $05
	vol $4
	note e5  $05
	vol $7
	note a5  $05
	vol $4
	note g5  $05
	vol $7
	note c6  $05
	vol $4
	note a5  $05
	vol $7
	note b5  $05
	vol $4
	note c6  $05
	vol $7
	note a5  $05
	vol $4
	note b5  $05
	vol $7
	note b5  $05
	vol $4
	note a5  $05
	vol $7
	note a5  $05
	vol $4
	note b5  $05
	vol $7
	note e5  $05
	vol $4
	note a5  $05
	vol $7
	note g5  $05
	vol $4
	note e5  $05
	vol $7
	note a5  $05
	vol $4
	note g5  $05
	vol $7
	note c6  $05
	vol $4
	note a5  $05
	vol $7
	note b5  $05
	vol $4
	note c6  $05
	vol $7
	note a5  $05
	vol $4
	note b5  $05
	vol $7
	note b5  $05
	vol $4
	note a5  $05
	vol $7
	note a5  $05
	vol $4
	note b5  $05
	vol $7
	note fs5 $05
	vol $4
	note a5  $05
	vol $7
	note e5  $05
	vol $4
	note fs5 $05
	vol $7
	note fs5 $05
	vol $4
	note e5  $05
	vol $7
	note e5  $05
	vol $4
	note fs5 $05
	vol $7
	note b4  $05
	vol $4
	note e5  $05
	vol $7
	note e5  $05
	vol $4
	note b4  $05
	vol $7
	note fs5 $05
	vol $4
	note e5  $05
	vol $7
	note a5  $05
	vol $4
	note fs5 $05
	vol $7
	note fs5 $05
	vol $4
	note a5  $05
	vol $7
	note e5  $05
	vol $4
	note fs5 $05
	vol $7
	note fs5 $05
	vol $4
	note e5  $05
	vol $7
	note e5  $05
	vol $4
	note fs5 $05
	vol $7
	note b4  $05
	vol $4
	note e5  $05
	vol $7
	note e5  $05
	vol $4
	note b4  $05
	vol $7
	note fs5 $05
	vol $4
	note e5  $05
	vol $7
	note a5  $05
	vol $4
	note fs5 $05
	vol $7
	note e5  $05
	vol $4
	note a5  $05
	vol $7
	note fs5 $05
	vol $4
	note e5  $05
	vol $7
	note a5  $05
	vol $4
	note fs5 $05
	vol $7
	note b5  $05
	vol $4
	note a5  $05
	vol $7
	note a5  $05
	vol $4
	note b5  $05
	vol $7
	note fs5 $05
	vol $4
	note a5  $05
	vol $7
	note a5  $05
	vol $4
	note fs5 $05
	vol $7
	note fs5 $05
	vol $4
	note a5  $05
	vol $7
	note b5  $05
	vol $4
	note fs5 $05
	vol $7
	note a5  $05
	vol $4
	note b5  $05
	vol $7
	note fs5 $05
	vol $4
	note a5  $05
	vol $7
	note e5  $05
	vol $4
	note fs5 $05
	vol $7
	note fs5 $05
	vol $4
	note e5  $05
	vol $7
	note e5  $05
	vol $4
	note fs5 $05
	vol $7
	note fs5 $05
	vol $4
	note e5  $05
	vol $7
	note e5  $05
	vol $4
	note fs5 $05
	vol $7
	note b4  $05
	vol $4
	note e5  $05
	vol $7
	note e5  $05
	vol $4
	note b4  $05
	vol $7
	note fs5 $05
	vol $4
	note e5  $05
	vol $7
	note a5  $05
	vol $4
	note fs5 $05
	vol $7
	note b5  $05
	vol $4
	note a5  $05
	vol $7
	note a5  $05
	vol $4
	note b5  $05
	vol $7
	note d6  $05
	vol $4
	note a5  $05
	vol $7
	note cs6 $05
	vol $4
	note d6  $05
	vol $7
	note b5  $05
	vol $4
	note cs6 $05
	vol $7
	note a5  $05
	vol $4
	note b5  $05
	vol $7
	note fs5 $05
	vol $4
	note a5  $05
	vol $7
	note e5  $05
	vol $4
	note fs5 $05
	vol $7
	note fs5 $05
	vol $4
	note e5  $05
	vol $7
	note e5  $05
	vol $4
	note fs5 $05
	vol $7
	note b4  $05
	vol $4
	note e5  $05
	vol $7
	note a4  $05
	vol $4
	note b4  $05
	goto musicf6ed3
	cmdff

sound3fChannel0:
	vol $0
	note gs3 $62
	vibrato $e1
	env $0 $00
	cmdf2
	duty $02
	vol $5
	note d5  $07
	note g5  $07
	note d6  $07
	rest $03
	vol $3
	note d6  $07
	rest $04
	vol $2
	note d6  $07
	rest $03
	vol $2
	note d6  $07
	rest $04
	vol $1
	note d6  $07
	rest $07
	duty $01
	vol $4
	note b3  $1c
	note d4  $1c
	note c4  $0e
	note b3  $0e
	note c4  $1c
	note g3  $1c
	vol $2
	note g3  $0e
	duty $02
	vol $5
	note c5  $07
	note f5  $07
	note c6  $07
	note f5  $07
	note c5  $07
	rest $03
	vol $4
	note c5  $07
	rest $04
	vol $3
	note c5  $07
	rest $03
	vol $2
	note c5  $07
	rest $04
	vol $1
	note c5  $07
	rest $31
	duty $01
	vol $5
	note ds4 $0e
	note cs4 $0e
	vol $5
	note ds4 $1c
	note as3 $1c
	vol $2
	note as3 $0e
	duty $02
	vol $5
	note ds5 $07
	note gs5 $07
	note cs6 $07
	rest $03
	vol $4
	note cs6 $07
	rest $04
	vol $3
	note cs6 $07
	rest $03
	vol $2
	note cs6 $07
	rest $04
	vol $1
	note cs6 $07
	rest $07
	duty $01
	vol $6
	note c4  $1c
	vol $7
	note f4  $1c
	vol $6
	note fs4 $0e
	note f4  $0e
	note fs4 $1c
	note cs4 $1c
	vol $4
	note cs4 $0e
	duty $02
	vol $6
	note fs5 $07
	note b5  $07
	vol $6
	note e6  $07
	rest $03
	vol $5
	note e6  $07
	rest $04
	vol $4
	note e6  $07
	rest $03
	vol $3
	note e6  $07
	rest $04
	vol $2
	note e6  $07
	rest $07
	vol $6
	note b3  $07
	vol $6
	note cs4 $07
	vol $7
	note ds4 $07
	vol $7
	note e4  $07
	vol $8
	note fs4 $07
	vol $8
	note gs4 $07
	vol $9
	note a4  $07
	vol $9
	note b4  $07
	vol $3
	note b4  $07
	rest $03
	vol $3
	note b4  $07
	rest $04
	vol $2
	note b4  $07
	vol $6
	note as4 $15
	vol $4
	note as4 $07
	vol $6
	note ds4 $07
	rest $03
	vol $4
	note ds4 $04
	vol $6
	note g4  $07
	rest $03
	vol $4
	note g4  $04
	vol $6
	note f4  $1c
	vol $4
	note f4  $0e
	vol $6
	note cs4 $1c
	note as3 $07
	rest $03
	vol $4
	note as3 $04
	vol $6
	note b3  $0e
	note ds4 $07
	rest $03
	vol $4
	note ds4 $04
	vol $6
	note cs4 $0e
	note b3  $0e
	note as3 $0e
	note cs4 $0e
	note as3 $0e
	vol $4
	note as3 $0e
	vol $6
	note ds3 $07
	note as3 $07
	note ds4 $03
	rest $04
	note ds4 $07
	note as4 $03
	rest $04
	note as4 $07
	note ds5 $03
	rest $04
	note ds5 $07
	rest $03
	vol $4
	note ds5 $07
	rest $04
	vol $2
	note ds5 $07
	rest $03
	vol $1
	note ds5 $04
	vol $6
	note ds5 $1c
	note fs5 $1c
	vol $4
	note fs5 $0e
	vol $6
	note cs5 $0e
	note as4 $1c
	note fs5 $07
	note gs5 $07
	note as5 $07
	rest $03
	vol $4
	note as5 $04
	vol $6
	note ds5 $0e
	note cs5 $0e
	note as4 $0e
	note ds5 $0e
	note f5  $0e
	note cs5 $0e
	note d5  $07
	note e5  $07
	note fs5 $07
	rest $03
	vol $4
	note fs5 $04
	vol $6
	note e5  $0e
	note cs5 $0e
	note b4  $0e
	note fs5 $0e
	note a5  $1c
	note g5  $07
	rest $03
	vol $4
	note g5  $04
	vol $6
	note f5  $1c
	note e5  $07
	rest $03
	vol $4
	note e5  $04
	vol $6
	note f5  $1c
	note e5  $0e
	note d5  $1c
	note c5  $0e
	note b4  $1c
	note a4  $07
	rest $03
	vol $4
	note a4  $04
	vol $6
	note gs4 $1c
	note fs4 $07
	rest $03
	vol $4
	note fs4 $04
	vol $6
	note gs4 $1c
	note a4  $07
	rest $03
	vol $4
	note a4  $04
	vol $6
	note gs4 $1c
	note fs4 $07
	rest $03
	vol $4
	note fs4 $04
	vol $6
	note gs4 $07
	rest $07
	vol $5
	note gs4 $07
	rest $07
	vol $3
	note gs4 $07
	rest $07
	vol $2
	note gs4 $07
	rest $07
	vol $1
	note gs4 $07
	rest $15
	vibrato $00
	duty $01
musicf74a6:
	rest $78
	vol $7
	note e3  $28
	note g3  $46
	vol $4
	note g3  $0a
	vol $7
	note e3  $28
	note g3  $28
	note a3  $28
	note c4  $28
	note b3  $28
	note g3  $28
	note a3  $28
	note e3  $50
	vol $4
	note e3  $14
	vol $7
	note d3  $05
	vol $4
	note d3  $05
	vol $7
	note d3  $05
	vol $4
	note d3  $05
	vol $7
	note e3  $78
	vol $4
	note e3  $1e
	vol $2
	note e3  $1e
	vol $1
	note e3  $14
	vol $7
	note a3  $28
	note c4  $46
	vol $4
	note c4  $0a
	vol $7
	note a3  $28
	note c4  $28
	note d4  $28
	note fs4 $28
	note a4  $28
	note c5  $28
	note b4  $5a
	vol $4
	note b4  $0a
	vol $7
	note a2  $05
	vol $4
	note a2  $05
	vol $7
	note a2  $05
	vol $4
	note a2  $05
	vol $7
	note b2  $78
	vol $4
	note b2  $1e
	vol $2
	note b2  $1e
	vol $1
	note b2  $1e
	vol $0
	note b2  $1e
	rest $78
	goto musicf74a6
	cmdff

sound3fChannel4:
	cmdf2
	duty $0e
	note g3  $07
	rest $07
	note f3  $07
	duty $0f
	note g3  $07
	duty $0e
	note g3  $07
	duty $0f
	note f3  $07
	duty $0e
	note d3  $07
	duty $0f
	note g3  $07
	duty $0e
	note g3  $07
	duty $0f
	note d3  $07
	duty $0e
	note f3  $07
	duty $0f
	note g3  $07
	duty $0e
	note g3  $07
	duty $0f
	note f3  $07
	duty $0e
	note d3  $07
	duty $0f
	note g3  $07
	duty $0e
	note g3  $07
	duty $0f
	note d3  $07
	duty $0e
	note f3  $07
	duty $0f
	note g3  $07
	duty $0e
	note g3  $07
	duty $0f
	note f3  $07
	duty $0e
	note d3  $07
	duty $0f
	note g3  $07
	duty $0e
	note g3  $07
	duty $0f
	note d3  $07
	duty $0e
	note f3  $07
	duty $0f
	note g3  $07
	duty $0e
	note g3  $07
	duty $0f
	note f3  $07
	duty $0e
	note d3  $07
	duty $0f
	note g3  $07
	duty $0e
	note g3  $07
	duty $0f
	note d3  $07
	duty $0e
	note f3  $07
	duty $0f
	note g3  $07
	duty $0e
	note g3  $07
	duty $0f
	note f3  $07
	duty $0e
	note d3  $07
	duty $0f
	note g3  $07
	duty $0e
	note g3  $07
	duty $0f
	note d3  $07
	duty $0e
	note f3  $07
	duty $0f
	note g3  $07
	duty $0e
	note g3  $07
	duty $0f
	note f3  $07
	duty $0e
	note d3  $07
	duty $0f
	note g3  $07
	duty $0e
	note g3  $07
	duty $0f
	note d3  $07
	duty $0e
	note f3  $07
	duty $0f
	note g3  $07
	duty $0e
	note g3  $07
	duty $0f
	note f3  $07
	duty $0e
	note d3  $07
	duty $0f
	note g3  $07
	duty $0e
	note g3  $07
	duty $0f
	note d3  $07
	duty $0e
	note f3  $07
	duty $0f
	note g3  $07
	duty $0e
	note g3  $07
	duty $0f
	note f3  $07
	duty $0e
	note d3  $07
	duty $0f
	note g3  $07
	duty $0e
	note f3  $07
	duty $0f
	note d3  $07
	duty $0e
	note ds3 $07
	duty $0f
	note f3  $07
	duty $0e
	note f3  $07
	duty $0f
	note ds3 $07
	duty $0e
	note c3  $07
	duty $0f
	note f3  $07
	duty $0e
	note f3  $07
	duty $0f
	note c3  $07
	duty $0e
	note ds3 $07
	duty $0f
	note f3  $07
	duty $0e
	note f3  $07
	duty $0f
	note ds3 $07
	duty $0e
	note c3  $07
	duty $0f
	note f3  $07
	duty $0e
	note f3  $07
	duty $0f
	note c3  $07
	duty $0e
	note ds3 $07
	duty $0f
	note f3  $07
	duty $0e
	note f3  $07
	duty $0f
	note ds3 $07
	duty $0e
	note c3  $07
	duty $0f
	note f3  $07
	duty $0e
	note gs3 $07
	duty $0f
	note c3  $07
	duty $0e
	note fs3 $07
	duty $0f
	note gs3 $07
	duty $0e
	note gs3 $07
	duty $0f
	note fs3 $07
	duty $0e
	note ds3 $07
	duty $0f
	note gs3 $07
	duty $0e
	note b3  $07
	duty $0f
	note ds3 $07
	duty $0e
	note as3 $07
	duty $0f
	note b3  $07
	duty $0e
	note b3  $07
	duty $0f
	note as3 $07
	duty $0e
	note fs3 $07
	duty $0f
	note b3  $07
	duty $0e
	note b3  $07
	duty $0f
	note fs3 $07
	duty $0e
	note as3 $07
	duty $0f
	note b3  $07
	duty $0e
	note b3  $07
	duty $0f
	note as3 $07
	duty $0e
	note fs3 $07
	duty $0f
	note b3  $07
	duty $0e
	note b3  $07
	duty $0f
	note fs3 $07
	duty $0e
	note as3 $07
	duty $0f
	note b3  $07
	duty $0e
	note b3  $07
	duty $0f
	note as3 $07
	duty $0e
	note fs3 $07
	duty $0f
	note b3  $07
	duty $0e
	note gs2 $07
	note a2  $07
	note b2  $07
	note cs3 $07
	note ds3 $07
	note e3  $07
	note fs3 $07
	note gs3 $07
	rest $1c
	note ds2 $15
	duty $0f
	note ds2 $0e
	duty $2c
	note ds2 $07
	duty $0e
	note ds2 $0e
	note cs2 $0e
	duty $0f
	note cs2 $0e
	duty $0e
	note cs2 $0e
	note f2  $0e
	note ds2 $0e
	note cs2 $0e
	note b1  $0e
	duty $0f
	note b1  $0e
	duty $0e
	note b1  $0e
	note as1 $1c
	note cs2 $0e
	note ds2 $15
	duty $0f
	note ds2 $07
	duty $0e
	note as1 $0e
	note ds2 $0e
	note as1 $0e
	note ds2 $0e
	note b1  $0e
	duty $0f
	note b1  $0e
	duty $0e
	note fs2 $1c
	note b2  $1c
	note as2 $1c
	note f2  $0e
	note as2 $0e
	duty $0f
	note as2 $0e
	duty $0e
	note f2  $0e
	note as1 $1c
	note cs2 $1c
	note f2  $1c
	note d2  $1c
	note e2  $1c
	duty $0f
	note e2  $0e
	duty $0e
	note e2  $0e
	note f2  $15
	duty $0f
	note f2  $07
	duty $0e
	note f2  $23
	duty $0f
	note f2  $07
	duty $0e
	note f2  $07
	duty $0f
	note f2  $07
	duty $0e
	note f2  $0e
	note c2  $0e
	note d2  $0e
	note e2  $0e
	note f2  $0e
	note g2  $0e
	note e2  $07
	duty $0f
	note e2  $07
	duty $0e
	note e2  $18
	duty $0f
	note e2  $04
	duty $0e
	note e2  $15
	duty $0f
	note e2  $07
	duty $0e
	note e2  $07
	duty $0f
	note e2  $07
	duty $0e
	note e2  $1c
	note b1  $0e
	note e2  $1c
	note gs2 $0e
	note e2  $1c
	rest $38
musicf77c0:
	rest $78
	duty $0e
	note a3  $28
	note d4  $46
	duty $17
	note d4  $0a
	duty $0e
	note a3  $28
	note d4  $28
	note e4  $28
	note g4  $28
	note fs4 $28
	note d4  $28
	note e4  $28
	note a3  $50
	duty $17
	note a3  $14
	duty $0e
	note a2  $05
	duty $17
	note a2  $05
	duty $0e
	note a2  $05
	duty $17
	note a2  $05
	duty $0e
	note a2  $78
	duty $17
	note a2  $1e
	duty $0f
	note a2  $1e
	duty $0c
	note a2  $14
	duty $0e
	note e4  $28
	note g4  $46
	duty $17
	note g4  $0a
	duty $0e
	note e4  $28
	note g4  $28
	note a4  $28
	note b4  $28
	note d5  $28
	note f5  $28
	note fs5 $5a
	duty $17
	note fs5 $0a
	duty $0e
	note e3  $05
	duty $17
	note e3  $05
	duty $0e
	note e3  $05
	duty $17
	note e3  $05
	duty $0e
	note fs3 $78
	duty $17
	note fs3 $1e
	duty $0f
	note fs3 $1e
	duty $0c
	note fs3 $1e
	duty $0c
	note fs3 $1e
	rest $78
	goto musicf77c0
	cmdff

sound3fChannel6:
	cmdf2
	vol $2
	note $2e $70
	note $2e $69
	vol $3
	note $2a $02
	vol $2
	note $2a $02
	vol $2
	note $2a $03
	vol $2
	note $2e $70
	note $2e $69
	vol $3
	note $2a $02
	vol $2
	note $2a $02
	vol $2
	note $2a $03
	vol $2
	note $2e $70
	vol $2
	note $2e $70
	note $2e $70
	note $2e $38
	vol $2
	note $2e $02
	vol $2
	note $2e $02
	vol $2
	note $2e $03
	vol $3
	note $2e $02
	vol $3
	note $2e $02
	vol $3
	note $2e $03
	vol $3
	note $2e $02
	vol $3
	note $2e $02
	vol $3
	note $2e $03
	vol $4
	note $2e $02
	vol $4
	note $2e $02
	vol $4
	note $2e $03
	vol $4
	note $2e $02
	vol $4
	note $2e $02
	vol $4
	note $2e $03
	vol $4
	note $2e $02
	vol $4
	note $2e $02
	vol $4
	note $2e $03
	vol $4
	note $2e $02
	vol $4
	note $2e $02
	vol $4
	note $2e $03
	vol $4
	note $2e $02
	vol $4
	note $2e $02
	vol $4
	note $2e $03
	vol $2
	note $2e $1c
	vol $4
	note $26 $1c
	note $26 $0e
	note $26 $0e
	vol $4
	note $26 $0e
	vol $4
	note $26 $07
	vol $4
	note $26 $07
	vol $4
	note $26 $2a
	note $26 $07
	vol $4
	note $26 $07
	vol $4
	note $26 $1c
	vol $4
	note $26 $0e
	note $26 $1c
	vol $4
	note $26 $0e
	vol $4
	note $26 $07
	vol $4
	note $26 $07
	vol $4
	note $26 $0e
	note $26 $0e
	note $26 $07
	vol $4
	note $26 $07
	vol $4
	note $26 $07
	vol $4
	note $26 $07
	vol $2
	note $26 $02
	vol $3
	note $26 $02
	vol $4
	note $26 $03
	vol $4
	note $26 $02
	vol $4
	note $26 $02
	vol $4
	note $26 $03
	vol $2
	note $2e $0e
	vol $4
	note $26 $07
	note $26 $07
	vol $2
	note $2e $1c
	vol $4
	note $26 $0e
	note $26 $07
	note $26 $07
	vol $2
	note $2e $0e
	vol $4
	note $26 $1c
	note $26 $1c
	note $26 $07
	vol $3
	note $2a $02
	vol $2
	note $2a $02
	vol $3
	note $2a $03
	vol $4
	note $26 $1c
	vol $2
	note $2e $0e
	vol $4
	note $26 $1c
	vol $4
	note $26 $07
	vol $4
	note $26 $07
	vol $2
	note $2e $1c
	vol $4
	note $26 $1c
	vol $4
	note $26 $07
	vol $4
	note $26 $07
	vol $4
	note $26 $02
	vol $4
	note $26 $02
	vol $3
	note $26 $03
	vol $3
	note $26 $02
	vol $2
	note $26 $02
	vol $2
	note $26 $03
	vol $2
	note $2e $1c
	note $2a $0e
	note $2e $15
	note $2a $07
	note $2a $0e
	note $2e $1c
	note $2a $07
	vol $2
	note $2a $0e
	vol $2
	note $2a $07
	note $2a $0e
	vol $2
	note $2a $0e
	vol $2
	note $2e $1c
	note $2e $2a
	rest $02
	note $2a $05
	note $2a $04
	note $2a $03
	note $2e $46
	rest $03
	note $2a $04
	note $2a $03
	note $2a $04
	vol $2
	note $2e $1c
	cmdff

sound31Channel1:
	vibrato $00
	env $0 $02
	cmdf2
	duty $02
	vol $6
	note b6  $02
	note as6 $02
	note b6  $03
	note as6 $02
	note b6  $07
	rest $28
	note c7  $02
	note b6  $02
	note c7  $03
	note b6  $02
	note c7  $07
	rest $3c
musicf79ae:
	vibrato $00
	env $0 $00
	duty $00
	note d6  $05
	note ds6 $05
	note d6  $05
	note cs6 $05
	note c6  $05
	note b5  $05
	note c6  $05
	note cs6 $05
	note d6  $05
	note ds6 $05
	note d6  $05
	note cs6 $05
	note c6  $05
	note b5  $05
	note c6  $05
	note cs6 $05
	note d6  $05
	vol $3
	note d6  $05
	vol $6
	note d7  $05
	vol $3
	note d7  $05
	vol $6
	note d6  $05
	vol $3
	note d6  $05
	vol $6
	note d6  $05
	note ds6 $05
	note e6  $05
	note f6  $05
	note e6  $05
	note ds6 $05
	note d6  $05
	vol $3
	note d6  $05
	rest $0a
	vol $6
	note d6  $05
	note ds6 $05
	note d6  $05
	note cs6 $05
	note c6  $05
	note b5  $05
	note c6  $05
	note cs6 $05
	note d6  $05
	note ds6 $05
	note d6  $05
	note cs6 $05
	note c6  $05
	note b5  $05
	note c6  $05
	note cs6 $05
	note d6  $05
	vol $3
	note d6  $05
	vol $6
	note d7  $05
	vol $3
	note d7  $05
	vol $6
	note d6  $05
	vol $3
	note d6  $05
	vol $6
	note d6  $05
	note ds6 $05
	note e6  $05
	note f6  $05
	note e6  $05
	note ds6 $05
	note d6  $05
	vol $3
	note d6  $05
	rest $0a
	vol $5
	note d6  $05
	note ds6 $05
	note d6  $05
	note cs6 $05
	note c6  $05
	note b5  $05
	note c6  $05
	note cs6 $05
	note d6  $05
	note ds6 $05
	note d6  $05
	note cs6 $05
	note c6  $05
	note b5  $05
	note c6  $05
	note cs6 $05
	vol $2
	note cs6 $05
	rest $69
	vibrato $00
	env $0 $02
	duty $02
	vol $6
	note d7  $02
	note c7  $02
	note b6  $02
	note a6  $04
	note g6  $02
	note fs6 $02
	note e6  $02
	note d6  $0b
	rest $53
	vibrato $00
	env $0 $00
	duty $00
	goto musicf79ae
	cmdff

sound31Channel0:
	vibrato $00
	env $0 $02
	cmdf2
	duty $02
	vol $6
	note f6  $07
	rest $31
	note fs6 $07
	rest $45
musicf7a98:
	vol $6
	note g4  $05
	rest $05
	note d5  $05
	rest $05
	note d4  $05
	rest $05
	note d5  $05
	rest $05
	note g4  $05
	rest $05
	note d5  $05
	rest $05
	note d4  $05
	rest $05
	note d5  $05
	rest $05
	note gs4 $05
	rest $05
	note ds5 $05
	rest $05
	note ds4 $05
	rest $05
	note ds5 $05
	rest $05
	note gs4 $05
	rest $05
	note ds5 $05
	rest $05
	note ds4 $05
	rest $05
	note ds5 $05
	rest $05
	note as4 $05
	rest $05
	note f5  $05
	rest $05
	note f4  $05
	rest $05
	note f5  $05
	rest $05
	note as4 $05
	rest $05
	note f5  $05
	rest $05
	note f4  $05
	rest $05
	note f5  $05
	rest $05
	note c5  $05
	rest $05
	note g5  $05
	rest $05
	note g4  $05
	rest $05
	note g5  $05
	rest $05
	note c5  $05
	rest $05
	note g5  $05
	rest $05
	note b4  $05
	rest $05
	note a4  $05
	rest $05
	vol $5
	note g4  $05
	rest $05
	note d5  $05
	rest $05
	note d4  $05
	rest $05
	note d5  $05
	rest $05
	note g4  $05
	rest $05
	note d5  $05
	rest $05
	note d4  $05
	rest $05
	note d5  $05
	rest $78
	vol $3
	note d7  $02
	note c7  $03
	note b6  $02
	note a6  $02
	note g6  $02
	note fs6 $04
	note e6  $02
	note d6  $0a
	rest $4e
	goto musicf7a98
	cmdff

sound1aChannel1:
	vibrato $00
	env $0 $00
	cmdf2
	duty $02
musicf7b58:
	vol $0
	note gs3 $ff
	note gs3 $21
	vol $6
	note d5  $03
	rest $03
	vol $5
	note d5  $03
	rest $03
	vol $4
	note d5  $03
	rest $03
	vol $4
	note d5  $03
	rest $03
	vol $4
	note d5  $03
	rest $2d
	vol $6
	note gs5 $03
	rest $03
	vol $5
	note gs5 $03
	rest $03
	vol $4
	note gs5 $03
	rest $03
	vol $4
	note gs5 $03
	rest $03
	vol $4
	note gs5 $03
	rest $3f
	vol $6
	note d5  $03
	rest $03
	vol $5
	note d5  $03
	rest $03
	vol $4
	note d5  $03
	rest $03
	vol $6
	note gs5 $03
	rest $03
	vol $5
	note gs5 $03
	rest $03
	vol $4
	note gs5 $03
	rest $03
	vol $4
	note gs5 $03
	rest $03
	vol $4
	note gs5 $03
	rest $ff
	vol $0
	note gs3 $72
	vol $6
	note e5  $03
	rest $03
	vol $5
	note e5  $03
	rest $03
	vol $4
	note e5  $03
	rest $03
	vol $4
	note e5  $03
	rest $03
	vol $4
	note e5  $03
	rest $2d
	vol $6
	note as5 $03
	rest $03
	vol $5
	note as5 $03
	rest $03
	vol $4
	note as5 $03
	rest $03
	vol $4
	note as5 $03
	rest $03
	vol $4
	note as5 $03
	rest $3f
	vol $6
	note e5  $03
	rest $03
	vol $5
	note e5  $03
	rest $03
	vol $4
	note e5  $03
	rest $03
	vol $6
	note as5 $03
	rest $03
	vol $5
	note as5 $03
	rest $03
	vol $4
	note as5 $03
	rest $03
	vol $4
	note as5 $03
	rest $03
	vol $4
	note as5 $03
	rest $51
	vol $4
	note c6  $09
	vol $7
	note c6  $09
	vol $5
	note c6  $04
	rest $05
	vol $4
	note c6  $04
	rest $05
	note fs5 $09
	vol $6
	note fs5 $09
	vol $4
	note fs5 $04
	rest $05
	vol $3
	note fs5 $04
	rest $05
	note as5 $09
	vol $6
	note as5 $09
	vol $5
	note as5 $04
	rest $05
	vol $4
	note as5 $04
	rest $05
	vol $3
	note e5  $09
	vol $6
	note e5  $09
	vol $4
	note e5  $04
	rest $05
	vol $3
	note e5  $04
	rest $05
	vol $3
	note e5  $04
	rest $05
	vol $2
	note e5  $04
	rest $29
	vol $3
	note e6  $03
	rest $06
	vol $6
	note e6  $06
	rest $03
	vol $6
	note as5 $03
	rest $06
	vol $5
	note as5 $09
	rest $04
	vol $3
	note as5 $09
	rest $05
	vol $1
	note as5 $09
	rest $1b
	goto musicf7b58
	cmdff

sound1aChannel0:
	vibrato $00
	env $0 $00
	cmdf2
	duty $01
musicf7c85:
	vol $6
	note gs2 $24
	vol $6
	note a2  $24
	note gs2 $24
	note e2  $24
	note gs2 $24
	note a2  $24
	note gs2 $24
	note e2  $24
	duty $02
	vol $7
	note a4  $03
	rest $03
	vol $6
	note a4  $03
	rest $03
	vol $4
	note a4  $03
	rest $03
	vol $4
	note a4  $03
	rest $03
	vol $3
	note a4  $03
	rest $2d
	vol $7
	note d5  $03
	rest $03
	vol $6
	note d5  $03
	rest $03
	vol $4
	note d5  $03
	rest $03
	vol $4
	note d5  $03
	rest $03
	vol $3
	note d5  $03
	rest $3f
	vol $7
	note a4  $03
	rest $03
	vol $6
	note a4  $03
	rest $03
	vol $4
	note a4  $03
	rest $03
	vol $7
	note d5  $03
	rest $03
	vol $6
	note d5  $03
	rest $03
	vol $4
	note d5  $03
	rest $03
	vol $7
	note a3  $03
	rest $03
	vol $6
	note a3  $03
	rest $03
	vol $4
	note a3  $03
	rest $03
	vol $7
	note d4  $03
	rest $03
	vol $6
	note d4  $03
	rest $03
	vol $4
	note d4  $03
	rest $03
	vol $7
	note gs3 $03
	rest $03
	vol $6
	note gs3 $03
	rest $03
	vol $4
	note gs3 $03
	rest $03
	vol $4
	note gs3 $03
	rest $03
	vol $3
	note gs3 $03
	rest $1b
	duty $01
	vol $6
	note gs2 $24
	note a2  $24
	note gs2 $24
	note a2  $24
	note as2 $24
	note b2  $24
	note as2 $24
	note f2  $24
	duty $02
	vol $7
	note a4  $03
	rest $03
	vol $6
	note a4  $03
	rest $03
	vol $4
	note a4  $03
	rest $03
	vol $4
	note a4  $03
	rest $03
	vol $3
	note a4  $03
	rest $2d
	vol $7
	note ds5 $03
	rest $03
	vol $6
	note ds5 $03
	rest $03
	vol $4
	note ds5 $03
	rest $03
	vol $4
	note ds5 $03
	rest $03
	vol $3
	note ds5 $03
	rest $3f
	vol $7
	note a4  $03
	rest $03
	vol $6
	note a4  $03
	rest $03
	vol $4
	note a4  $03
	rest $03
	vol $7
	note ds5 $03
	rest $03
	vol $6
	note ds5 $03
	rest $03
	vol $4
	note ds5 $03
	rest $03
	vol $7
	note a3  $03
	rest $03
	vol $6
	note a3  $03
	rest $03
	vol $4
	note a3  $03
	rest $03
	vol $7
	note d4  $03
	rest $03
	vol $6
	note d4  $03
	rest $03
	vol $4
	note d4  $03
	rest $03
	vol $7
	note gs3 $03
	rest $03
	vol $6
	note gs3 $03
	rest $03
	vol $4
	note gs3 $03
	rest $03
	vol $4
	note gs3 $03
	rest $03
	vol $3
	note gs3 $03
	rest $1b
	vol $3
	note fs5 $09
	vol $6
	note fs5 $09
	vol $4
	note fs5 $06
	rest $03
	vol $2
	note fs5 $06
	rest $03
	vol $3
	note c5  $09
	vol $6
	note c5  $09
	vol $4
	note c5  $06
	rest $03
	vol $2
	note c5  $06
	rest $03
	vol $3
	note e5  $09
	vol $6
	note e5  $09
	vol $4
	note e5  $06
	rest $03
	vol $2
	note e5  $06
	rest $03
	vol $3
	note as4 $09
	vol $6
	note as4 $09
	vol $4
	note as4 $06
	rest $03
	vol $3
	note as4 $06
	rest $03
	vol $2
	note as4 $06
	rest $03
	vol $2
	note as4 $06
	rest $27
	vol $3
	note as5 $06
	rest $03
	vol $6
	note as5 $06
	rest $03
	note e5  $06
	rest $03
	vol $5
	note e5  $09
	rest $04
	vol $2
	note e5  $09
	rest $05
	vol $1
	note e5  $09
	rest $1b
	duty $01
	goto musicf7c85
	cmdff

sound1aChannel4:
	cmdf2
musicf7e2a:
	duty $0e
	note d2  $24
	note ds2 $24
	note d2  $24
	note as1 $24
	note d2  $24
	note ds2 $24
	note d2  $24
	note as1 $24
	note d2  $24
	note ds2 $24
	note d2  $24
	note as1 $24
	note d2  $24
	note ds2 $24
	note d2  $24
	note as1 $24
	note d2  $24
	note ds2 $24
	note d2  $24
	note ds2 $24
	note e2  $24
	note f2  $24
	note e2  $24
	note b1  $24
	note e2  $24
	note f2  $24
	note e2  $24
	note b1  $24
	note e2  $24
	note f2  $24
	note e2  $24
	note f2  $24
	rest $ff
	rest $21
	goto musicf7e2a
	cmdff

sound93Start:

sound93Channel2:
	cmdff

sound94Start:

sound94Channel2:
	cmdff

sounda2Start:

sounda2Channel2:
	duty $02
	vol $9
	note gs5 $06
	vol $3
	note gs5 $06
	vol $9
	note as5 $06
	vol $3
	note as5 $06
	vol $9
	note b5  $06
	vol $3
	note b5  $06
	vol $9
	note fs6 $06
	vol $3
	note fs6 $06
	cmdff

sounda3Start:

sounda3Channel7:
	cmdf0 $90
	note $14 $01
	cmdf0 $00
	note $00 $01
	cmdf0 $22
	note $14 $02
	cmdff

sounda7Start:

sounda7Channel2:
	vol $d
	note c7  $01
	vol $0
	rest $01
	vol $3
	note c7  $01
	cmdff

soundb0Start:

soundb0Channel2:
	duty $02
	vol $3
	note c2  $1f
	note c2  $1f
	note c2  $1f
	note c2  $1f
	note c2  $1c
	note c2  $20
	note c2  $26
	note c2  $14
	note c2  $0a
	note c2  $13
	note c2  $12
	note c2  $1c
	env $0 $07
	note c2  $32
	cmdff

soundb0Channel7:
	cmdf0 $f0
	note $76 $1f
	cmdf0 $f0
	note $76 $1f
	cmdf0 $f0
	note $76 $1f
	cmdf0 $f0
	note $76 $09
	note $67 $09
	note $76 $09
	cmdf0 $f0
	note $76 $07
	note $74 $07
	note $67 $07
	note $76 $07
	cmdf0 $f0
	note $76 $0f
	note $66 $09
	note $76 $08
	cmdf0 $f0
	note $76 $12
	note $66 $07
	note $74 $07
	note $75 $06
	cmdf0 $f0
	note $76 $0e
	note $66 $06
	cmdf0 $f0
	note $67 $05
	note $65 $05
	cmdf0 $f0
	note $57 $10
	note $64 $03
	cmdf0 $c0
	note $64 $06
	note $65 $03
	note $65 $09
	cmdf0 $a0
	note $66 $0d
	note $74 $0f
	cmdf0 $85
	note $76 $32
	cmdff

sound58Start:

sound58Channel2:
	duty $00
	vol $9
	env $0 $01
	note as6 $0a
	cmdff

sound59Start:

sound59Channel2:
	duty $02
	vol $9
	cmdf8 $f6
	note a4  $14
	cmdf8 $00
	vol $2
	cmdf8 $f4
	note a4  $14
	cmdff

sound5aStart:

sound5aChannel2:
	duty $01
	vol $e
	note ds3 $02
	vol $0
	rest $01
	vol $e
	note ds3 $02
	vol $0
	rest $0a
	vol $e
	note ds3 $02
	vol $0
	rest $01
	vol $e
	note ds3 $02
	vol $0
	rest $01
	vol $e
	note ds3 $02
	vol $0
	rest $01
	vol $e
	note ds3 $02
	vol $0
	rest $01
	vol $e
	note ds3 $02
	cmdff

sound5bStart:

sound5bChannel2:
	duty $02
	env $0 $02
	vol $d
	note fs6 $10
	vol $b
	note d6  $12
	note g5  $14
	vol $d
	note g6  $18
	cmdff

sound5bChannel3:
	duty $02
	env $0 $02
	vol $0
	rest $08
	vol $c
	note f6  $10
	vol $b
	note b5  $13
	vol $c
	note ds6 $16
	env $0 $02
	vol $e
	note b6  $23
	cmdff
	cmdff

sound5fStart:

sound5fChannel5:
	cmdfd $fd
	duty $2d
	note f2  $01
	cmdf8 $e7
	note c5  $03
	cmdf8 $00
	cmdfd $00
	cmdff

sound62Start:

sound62Channel2:
	duty $00
	vol $b
	cmdf8 $05
	note b6  $06
	cmdf8 $00
	vol $4
	cmdf8 $05
	note b6  $0a
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
.bank $3e slot 1
.org 0

sound0cStart:

sound2fStart:

sound39Start:

sound3cStart:

sound25Start:

sound0cChannel4:
sound0cChannel6:
sound2fChannel0:
sound2fChannel4:
sound2fChannel6:
sound39Channel6:
sound3cChannel6:
sound25Channel6:
	cmdff

sound37Start:

sound3aStart:

sound3bStart:

sound3dStart:

sound41Start:

sound42Start:

sound43Start:

sound44Start:

sound45Start:

sound47Start:

sound48Start:

sound49Start:

sound4bStart:

soundd6Start:

soundd7Start:

soundd8Start:

soundd9Start:

sounddaStart:

sounddbStart:

sounddcStart:

soundddStart:

sound37Channel1:
sound3aChannel1:
sound3bChannel1:
sound3dChannel1:
sound41Channel1:
sound42Channel1:
sound43Channel1:
sound44Channel1:
sound45Channel1:
sound47Channel1:
sound48Channel1:
sound49Channel1:
sound4bChannel1:
soundd6Channel1:
soundd7Channel1:
soundd8Channel1:
soundd9Channel1:
sounddaChannel1:
sounddbChannel1:
sounddcChannel1:
soundddChannel1:
	cmdff

sound37Channel0:
sound3aChannel0:
sound3bChannel0:
sound3dChannel0:
sound41Channel0:
sound42Channel0:
sound43Channel0:
sound44Channel0:
sound45Channel0:
sound47Channel0:
sound48Channel0:
sound49Channel0:
sound4bChannel0:
soundd6Channel0:
soundd7Channel0:
soundd8Channel0:
soundd9Channel0:
sounddaChannel0:
sounddbChannel0:
sounddcChannel0:
soundddChannel0:
	cmdff

sound37Channel4:
sound3aChannel4:
sound3bChannel4:
sound3dChannel4:
sound41Channel4:
sound42Channel4:
sound43Channel4:
sound44Channel4:
sound45Channel4:
sound47Channel4:
sound48Channel4:
sound49Channel4:
sound4bChannel4:
soundd6Channel4:
soundd7Channel4:
soundd8Channel4:
soundd9Channel4:
sounddaChannel4:
sounddbChannel4:
sounddcChannel4:
soundddChannel4:
	cmdff

sound37Channel6:
sound3aChannel6:
sound3bChannel6:
sound3dChannel6:
sound41Channel6:
sound42Channel6:
sound43Channel6:
sound44Channel6:
sound45Channel6:
sound47Channel6:
sound48Channel6:
sound49Channel6:
sound4bChannel6:
soundd6Channel6:
soundd7Channel6:
soundd8Channel6:
soundd9Channel6:
sounddaChannel6:
sounddbChannel6:
sounddcChannel6:
soundddChannel6:
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff

sound39Channel1:
	vibrato $00
	env $0 $00
	duty $00
musicf800f:
	vol $6
	note cs4 $48
	note c4  $09
	rest $04
	vol $3
	note c4  $09
	rest $05
	vol $1
	note c4  $09
	vol $6
	note fs4 $12
	note g4  $09
	rest $04
	vol $3
	note g4  $05
	vol $6
	note gs4 $12
	note g4  $09
	rest $04
	vol $3
	note g4  $09
	rest $05
	vol $1
	note g4  $09
	rest $5a
	vol $6
	note cs4 $48
	note c4  $09
	rest $04
	vol $3
	note c4  $09
	rest $05
	vol $1
	note c4  $09
	vol $6
	note fs4 $12
	note g4  $09
	rest $04
	vol $3
	note g4  $05
	vol $6
	note as4 $0c
	note a4  $0c
	note gs4 $0c
	note g4  $09
	rest $04
	vol $3
	note g4  $09
	rest $05
	vol $1
	note g4  $09
	rest $48
	vol $6
	note c5  $48
	note fs4 $09
	rest $04
	vol $3
	note fs4 $09
	rest $05
	vol $1
	note fs4 $09
	vol $6
	note f4  $12
	note ds4 $09
	rest $04
	vol $3
	note ds4 $05
	vol $6
	note f4  $09
	note ds4 $09
	note c4  $09
	rest $04
	vol $3
	note c4  $09
	rest $05
	vol $1
	note c4  $09
	rest $36
	vol $6
	note f4  $12
	note ds4 $12
	note fs4 $0c
	note f4  $0c
	note ds4 $0c
	note f4  $12
	note ds4 $12
	note c4  $09
	rest $04
	vol $3
	note c4  $09
	rest $05
	vol $1
	note c4  $09
	vol $6
	note as3 $12
	note ds4 $12
	note c4  $09
	rest $04
	vol $3
	note c4  $09
	rest $05
	vol $1
	note c4  $09
	vol $6
	note as3 $09
	rest $04
	vol $3
	note as3 $09
	rest $05
	vol $1
	note as3 $09
	vol $6
	note e3  $48
	goto musicf800f
	cmdff

sound39Channel0:
	env $0 $02
	vol $9
musicf80d6:
	note c2  $24
	note fs2 $09
	rest $09
	note fs2 $09
	rest $09
	note fs2 $09
	rest $3f
	note c2  $09
	rest $1b
	note fs2 $09
	rest $09
	note fs2 $04
	rest $05
	note fs2 $04
	rest $05
	note fs2 $04
	rest $20
	note c2  $04
	rest $05
	note c2  $04
	rest $05
	note c2  $04
	rest $0e
	note c2  $24
	note fs2 $09
	rest $09
	note fs2 $09
	rest $09
	note fs2 $09
	rest $1b
	note fs2 $09
	rest $1b
	note c2  $09
	rest $1b
	note fs2 $09
	rest $09
	note fs2 $04
	rest $05
	note fs2 $04
	rest $05
	note as2 $12
	note a2  $12
	note gs2 $12
	note g2  $12
	note c2  $51
	rest $09
	note fs2 $09
	note f2  $09
	note e2  $09
	note ds2 $09
	note d2  $09
	note cs2 $09
	note c2  $09
	rest $1b
	note fs2 $09
	rest $09
	note fs2 $04
	rest $05
	note fs2 $04
	rest $05
	note fs2 $09
	rest $1b
	note c2  $04
	rest $05
	note c2  $04
	rest $05
	note c2  $04
	rest $0e
	note c2  $24
	note fs2 $09
	rest $09
	note fs2 $09
	rest $09
	note fs2 $09
	rest $3f
	note c2  $09
	rest $1b
	note fs2 $09
	rest $09
	note fs2 $04
	rest $05
	note fs2 $04
	rest $05
	note as2 $48
	goto musicf80d6
	cmdff

sound39Channel4:
musicf8182:
	duty $17
	note g3  $48
	note fs3 $09
	duty $0c
	note fs3 $12
	rest $09
	duty $17
	note c4  $12
	note cs4 $09
	duty $0c
	note cs4 $09
	duty $17
	note d4  $12
	note cs4 $09
	duty $0c
	note cs4 $12
	rest $87
	duty $17
	note g3  $24
	note fs3 $09
	duty $0c
	note fs3 $12
	rest $09
	duty $17
	note c4  $12
	note cs4 $09
	duty $0c
	note d4  $09
	duty $17
	note e4  $0c
	note ds4 $0c
	note d4  $0c
	note cs4 $09
	duty $0c
	note cs4 $12
	rest $63
	duty $17
	note g4  $09
	note fs4 $09
	note f4  $09
	note e4  $09
	note ds4 $09
	note d4  $09
	note cs4 $09
	duty $0c
	note cs4 $12
	rest $09
	duty $17
	note b3  $12
	note a3  $09
	duty $0c
	note a3  $09
	duty $17
	note b3  $09
	note a3  $09
	note fs3 $09
	duty $17
	note fs3 $12
	rest $ff
	rest $84
	goto musicf8182
	cmdff

sound2fChannel1:
	vibrato $00
	env $0 $00
	duty $02
musicf8204:
	vol $c
	note c2  $04
	vol $5
	note c2  $08
	vol $2
	note c2  $04
	vol $c
	note fs2 $04
	vol $5
	note fs2 $08
	vol $2
	note fs2 $04
	vol $c
	note f2  $04
	vol $5
	note f2  $08
	vol $2
	note f2  $04
	rest $48
	vol $c
	note c2  $02
	vol $5
	note c2  $04
	vol $2
	note c2  $02
	vol $c
	note c2  $04
	vol $5
	note c2  $08
	vol $2
	note c2  $04
	vol $c
	note fs2 $04
	vol $5
	note fs2 $08
	vol $2
	note fs2 $04
	vol $c
	note f2  $04
	vol $5
	note f2  $04
	vol $c
	note b2  $04
	vol $5
	note b2  $08
	vol $2
	note b2  $04
	rest $f8
	goto musicf8204
	cmdff

sound3cChannel1:
musicf8251:
	vibrato $00
	env $0 $05
	duty $00
	vol $8
	note g6  $1e
	note d6  $0a
	note b5  $14
	note g5  $14
	note gs5 $28
	note ds6 $0a
	note c6  $0a
	note gs5 $0a
	note ds5 $0a
	note d5  $14
	note d6  $0a
	note b5  $0a
	note g5  $14
	note d5  $14
	note f5  $14
	note ds5 $0a
	note f5  $0a
	note d5  $28
	vol $3
	vibrato $00
	env $0 $03
	note cs5 $05
	rest $0f
	note d5  $05
	rest $0f
	note ds6 $05
	rest $0f
	note d6  $05
	rest $0f
	note cs6 $05
	rest $0f
	note d6  $05
	rest $0f
	note c6  $05
	rest $0f
	note cs6 $05
	rest $0f
	note b5  $05
	rest $0f
	note c6  $05
	rest $0f
	note as5 $05
	rest $0f
	note b5  $05
	rest $0f
	note a5  $05
	rest $05
	note as5 $05
	rest $05
	note gs5 $05
	rest $05
	note a5  $05
	rest $55
	vol $3
	note as7 $01
	note as5 $01
	cmdf8 $81
	note cs5 $03
	cmdf8 $00
	vol $0
	rest $05
	vol $3
	note as7 $01
	note as5 $01
	cmdf8 $81
	note cs5 $03
	cmdf8 $00
	vol $0
	rest $05
	goto musicf8251
	cmdff

sound3cChannel0:
musicf82e1:
	vibrato $00
	env $0 $02
	duty $02
	vol $6
	note g3  $0a
	vol $3
	note g3  $0a
	vol $6
	note cs4 $0a
	vol $3
	note cs4 $0a
	vol $6
	note as4 $0a
	vol $3
	note as4 $0a
	vol $6
	note cs4 $0a
	vol $3
	note cs4 $0a
	vol $6
	note d3  $0a
	vol $3
	note d3  $0a
	vol $6
	note c4  $0a
	vol $3
	note c4  $0a
	vol $6
	note a4  $0a
	vol $3
	note a4  $0a
	vol $6
	note c4  $0a
	vol $3
	note c4  $0a
	vol $6
	note g3  $0a
	vol $3
	note g3  $0a
	vol $6
	note cs4 $0a
	vol $3
	note cs4 $0a
	vol $6
	note as4 $0a
	vol $3
	note as4 $0a
	vol $6
	note cs4 $0a
	vol $3
	note cs4 $0a
	vol $6
	note d3  $0a
	vol $3
	note d3  $0a
	vol $6
	note c4  $0a
	vol $3
	note c4  $0a
	vol $6
	note a4  $0a
	vol $3
	note a4  $0a
	vol $6
	note c4  $0a
	vol $3
	note c4  $0a
	vol $3
	rest $28
	note d6  $05
	rest $0f
	note cs6 $05
	rest $0f
	env $0 $03
	note c6  $05
	rest $0f
	note cs6 $05
	rest $0f
	note b5  $05
	rest $0f
	note c6  $05
	rest $0f
	note as5 $05
	rest $0f
	note b5  $05
	rest $0f
	note a5  $05
	rest $0f
	note as5 $05
	rest $0f
	note gs5 $05
	rest $0f
	note g5  $05
	rest $73
	goto musicf82e1
	cmdff

sound3cChannel4:
musicf8380:
	duty $17
	rest $28
	note fs4 $05
	rest $05
	duty $0c
	note fs4 $03
	rest $07
	duty $17
	duty $0f
	note g7  $09
	rest $01
	note g7  $0a
	duty $17
	rest $28
	note f4  $05
	rest $05
	duty $0c
	note f4  $03
	rest $07
	duty $0f
	note g7  $09
	rest $01
	note g7  $0a
	duty $17
	rest $28
	note fs4 $05
	rest $05
	duty $0c
	note fs4 $03
	rest $07
	duty $0f
	note g7  $09
	rest $01
	note g7  $0a
	duty $17
	rest $28
	note f4  $05
	rest $05
	duty $0c
	note f4  $03
	rest $07
	duty $0f
	note g7  $09
	rest $01
	note g7  $0a
	rest $fa
	rest $82
	goto musicf8380
	cmdff

sound3eStart:

sound3eChannel1:
	vibrato $00
	env $0 $00
	duty $02
musicf83e8:
	vol $0
	note gs3 $30
	vol $6
	note e4  $0d
	rest $03
	vol $3
	note e4  $02
	rest $02
	vol $6
	note e4  $04
	rest $04
	vol $3
	note e4  $04
	rest $10
	vol $6
	note d4  $08
	rest $02
	vol $3
	note d4  $04
	rest $02
	vol $6
	note c4  $08
	rest $02
	vol $3
	note c4  $04
	rest $02
	vol $3
	note c4  $02
	rest $ae
	vol $6
	note e4  $05
	rest $03
	vol $6
	note e4  $05
	rest $03
	vol $6
	note e4  $05
	rest $05
	vol $3
	note e4  $04
	rest $02
	vol $6
	note e4  $05
	rest $05
	vol $3
	note e4  $04
	rest $02
	vol $6
	note d4  $05
	rest $03
	vol $3
	note d4  $04
	rest $04
	vol $6
	note c4  $05
	rest $03
	vol $3
	note c4  $04
	rest $04
	vol $2
	note c4  $02
	rest $5e
	vol $6
	note as3 $08
	rest $02
	vol $3
	note as3 $04
	rest $02
	vol $6
	note c4  $04
	rest $04
	vol $3
	note c4  $04
	rest $04
	vol $2
	note c4  $02
	rest $2e
	vol $6
	note e4  $0d
	rest $03
	note e4  $02
	rest $02
	vol $3
	note e4  $04
	rest $04
	vol $3
	note e4  $04
	rest $10
	vol $6
	note d4  $08
	rest $02
	vol $3
	note d4  $04
	rest $02
	vol $6
	note c4  $08
	rest $02
	vol $3
	note c4  $04
	rest $04
	vol $1
	note c4  $02
	rest $ac
	vol $6
	note e4  $05
	rest $03
	vol $6
	note e4  $05
	rest $03
	vol $6
	note e4  $05
	rest $05
	vol $3
	note e4  $04
	rest $02
	vol $6
	note e4  $05
	rest $05
	vol $3
	note e4  $04
	rest $02
	vol $6
	note d4  $05
	rest $03
	vol $3
	note d4  $04
	rest $04
	vol $6
	note c4  $05
	rest $03
	vol $3
	note c4  $04
	rest $04
	vol $2
	note c4  $02
	rest $5e
	vol $6
	note as3 $08
	rest $02
	vol $3
	note as3 $04
	rest $02
	vol $6
	note c4  $04
	rest $04
	vol $3
	note c4  $04
	rest $04
	vol $1
	note c4  $02
	rest $5e
	vol $6
	note as3 $08
	rest $02
	vol $3
	note as3 $02
	rest $04
	vol $6
	note c4  $04
	rest $04
	vol $3
	note c4  $02
	rest $06
	vol $6
	note as3 $08
	rest $02
	vol $3
	note as3 $02
	rest $04
	vol $6
	note c4  $04
	rest $04
	vol $3
	note c4  $02
	rest $46
	vol $6
	note as3 $08
	rest $02
	vol $3
	note as3 $02
	rest $04
	vol $6
	note c4  $04
	rest $04
	vol $3
	note c4  $02
	rest $06
	vol $1
	note c4  $02
	rest $5e
	vol $6
	note as3 $08
	rest $02
	vol $3
	note as3 $02
	rest $04
	vol $6
	note c4  $04
	rest $04
	vol $3
	note c4  $02
	rest $06
	vol $6
	note d4  $08
	rest $02
	vol $3
	note d4  $02
	rest $04
	vol $6
	note c4  $04
	rest $04
	vol $3
	note c4  $02
	rest $06
	vol $6
	note as3 $08
	rest $02
	vol $3
	note as3 $02
	rest $04
	vol $6
	note c4  $04
	rest $04
	vol $3
	note c4  $02
	rest $06
	vol $1
	note c4  $02
	rest $ff
	rest $ff
	rest $10
	vol $6
	note g4  $08
	rest $02
	vol $3
	note g4  $02
	rest $04
	vol $6
	note a4  $08
	rest $02
	vol $3
	note a4  $02
	rest $04
	vol $6
	note g4  $08
	rest $02
	vol $3
	note g4  $02
	rest $04
	vol $6
	note a4  $08
	rest $02
	vol $3
	note a4  $02
	rest $04
	vol $6
	note g4  $08
	rest $02
	vol $3
	note g4  $02
	rest $04
	vol $6
	note as4 $0c
	rest $01
	vol $3
	note as4 $03
	rest $02
	note as4 $02
	rest $0c
	vol $6
	note as4 $0a
	rest $02
	vol $1
	note as4 $04
	rest $02
	vol $3
	note as4 $02
	rest $06
	vol $2
	note as4 $02
	rest $04
	vol $6
	note a4  $08
	rest $02
	vol $3
	note a4  $02
	rest $04
	vol $6
	note g4  $08
	rest $02
	vol $3
	note g4  $02
	rest $34
	vol $6
	note g4  $08
	rest $02
	vol $3
	note g4  $02
	rest $04
	vol $6
	note a4  $08
	rest $02
	vol $3
	note a4  $02
	rest $04
	vol $6
	note g4  $08
	rest $02
	vol $3
	note g4  $02
	rest $04
	vol $6
	note a4  $08
	rest $02
	vol $3
	note a4  $02
	rest $04
	vol $6
	note g4  $08
	rest $02
	vol $3
	note g4  $02
	rest $04
	vol $6
	note a4  $08
	rest $02
	vol $3
	note a4  $02
	rest $04
	vol $6
	note g4  $08
	rest $02
	vol $3
	note g4  $02
	rest $04
	vol $6
	note as4 $0c
	rest $01
	vol $3
	note as4 $03
	rest $05
	vol $3
	note as4 $03
	rest $02
	vol $3
	note as4 $02
	rest $04
	vol $6
	note as4 $10
	rest $02
	vol $3
	note as4 $02
	rest $06
	note as4 $02
	rest $04
	vol $6
	note a4  $08
	rest $02
	vol $3
	note a4  $02
	rest $04
	vol $6
	note g4  $08
	rest $02
	vol $3
	note g4  $02
	vol $0
	rest $ff
	vol $0
	rest $ff
	rest $36
	vol $6
	note e4  $0d
	rest $03
	note e4  $02
	rest $02
	vol $4
	note e4  $04
	rest $04
	vol $3
	note e4  $04
	rest $10
	vol $6
	note d4  $08
	rest $02
	vol $3
	note d4  $04
	rest $02
	vol $6
	note c4  $08
	rest $02
	vol $3
	note c4  $04
	rest $04
	vol $2
	note c4  $02
	rest $ac
	vol $6
	note e4  $05
	rest $03
	vol $6
	note e4  $05
	rest $03
	vol $6
	note e4  $05
	rest $05
	vol $3
	note e4  $04
	rest $02
	vol $6
	note e4  $05
	rest $05
	vol $3
	note e4  $04
	rest $02
	vol $6
	note d4  $05
	rest $03
	vol $3
	note d4  $04
	rest $04
	vol $6
	note c4  $05
	rest $03
	vol $3
	note c4  $04
	rest $04
	vol $2
	note c4  $02
	rest $4e
	vol $6
	note g4  $08
	rest $02
	vol $3
	note g4  $02
	rest $04
	vol $6
	note a4  $08
	rest $02
	vol $3
	note a4  $02
	rest $04
	vol $6
	note g4  $08
	rest $02
	vol $3
	note g4  $02
	rest $04
	vol $6
	note a4  $08
	rest $02
	vol $3
	note a4  $02
	rest $04
	vol $6
	note g4  $08
	rest $02
	vol $3
	note g4  $02
	rest $04
	vol $6
	note as4 $08
	rest $02
	vol $3
	note as4 $02
	rest $06
	note as4 $02
	rest $06
	note as4 $02
	rest $04
	vol $6
	note as4 $08
	rest $02
	vol $3
	note as4 $02
	rest $06
	vol $3
	note as4 $02
	rest $06
	vol $2
	note as4 $02
	rest $04
	vol $6
	note a4  $08
	rest $02
	vol $3
	note a4  $02
	rest $04
	vol $6
	note g4  $08
	rest $02
	vol $3
	note g4  $02
	rest $34
	vol $6
	note g4  $08
	rest $02
	vol $3
	note g4  $02
	rest $04
	vol $6
	note a4  $08
	rest $02
	vol $3
	note a4  $02
	rest $04
	vol $6
	note g4  $08
	rest $02
	vol $3
	note g4  $02
	rest $04
	vol $6
	note a4  $08
	rest $02
	vol $3
	note a4  $02
	rest $04
	vol $6
	note g4  $08
	rest $02
	vol $3
	note g4  $02
	rest $04
	vol $6
	note a4  $08
	rest $02
	vol $3
	note a4  $02
	rest $04
	vol $6
	note g4  $08
	rest $02
	vol $3
	note g4  $02
	rest $04
	vol $6
	note as4 $08
	rest $02
	vol $3
	note as4 $02
	rest $06
	vol $3
	note as4 $02
	rest $06
	vol $3
	note as4 $02
	rest $04
	vol $6
	note as4 $08
	rest $02
	vol $5
	note as4 $02
	rest $06
	vol $4
	note as4 $02
	rest $06
	vol $3
	note as4 $02
	rest $04
	vol $6
	note a4  $08
	rest $02
	vol $3
	note a4  $02
	rest $04
	vol $6
	note g4  $08
	rest $02
	vol $3
	note g4  $02
	vol $0
	rest $ff
	vol $0
	rest $85
	goto musicf83e8
	cmdff

sound3eChannel0:
	vibrato $00
	env $0 $00
	duty $02
musicf87b3:
	vol $6
	note c2  $08
	rest $08
	note c2  $08
	rest $08
	note e3  $10
	note c3  $08
	note g2  $08
	rest $10
	note g2  $08
	rest $08
	note c3  $08
	rest $08
	note g2  $08
	rest $08
	note c2  $08
	rest $08
	note c2  $08
	rest $08
	note e3  $10
	note c3  $08
	note g2  $04
	rest $04
	note g2  $08
	rest $08
	note as2 $08
	rest $08
	note c3  $08
	rest $08
	note g2  $08
	rest $08
	note c2  $08
	rest $08
	note c2  $08
	rest $08
	note e3  $10
	note c3  $08
	note g2  $04
	rest $04
	note g2  $08
	rest $08
	note as2 $08
	rest $08
	note c3  $08
	rest $08
	note g2  $08
	rest $08
	note c2  $08
	rest $08
	note c2  $08
	rest $08
	note e3  $10
	note c3  $08
	note g2  $04
	rest $04
	note g2  $18
	rest $08
	note as2 $08
	rest $08
	note c3  $08
	rest $08
	note c2  $08
	rest $08
	note c2  $08
	rest $08
	note e3  $10
	note c3  $08
	note g2  $08
	rest $10
	note g2  $08
	rest $08
	note c3  $08
	rest $08
	note g2  $08
	rest $08
	note c2  $08
	rest $08
	note c2  $08
	rest $08
	note e3  $10
	note c3  $08
	note g2  $08
	rest $10
	note g2  $08
	note as2 $08
	note c3  $08
	rest $08
	note g2  $08
	rest $08
	note c2  $08
	rest $08
	note c2  $08
	rest $08
	note e3  $10
	note c3  $08
	note g2  $04
	rest $04
	note g2  $10
	rest $10
	note as2 $08
	rest $08
	note c3  $08
	rest $08
	note c2  $20
	note e3  $08
	rest $08
	note g2  $08
	rest $18
	note g2  $08
	rest $08
	note as2 $08
	rest $08
	note c3  $08
	rest $08
	note c2  $08
	rest $08
	note c2  $08
	rest $08
	note e3  $10
	note g2  $08
	rest $08
	note as2 $10
	note c3  $08
	rest $08
	note as2 $10
	note c3  $08
	rest $08
	note c2  $08
	rest $08
	note c2  $08
	rest $08
	note e3  $10
	note g2  $08
	rest $18
	note g2  $08
	rest $08
	note as2 $10
	note c3  $08
	rest $08
	note c2  $08
	rest $08
	note c2  $08
	rest $08
	note e3  $10
	note g2  $08
	rest $18
	note g2  $08
	rest $08
	note as2 $10
	note c3  $08
	rest $08
	note as2 $10
	note c3  $08
	rest $08
	note e3  $10
	note c3  $08
	rest $18
	note g2  $10
	note as2 $10
	note c3  $08
	rest $08
	note c2  $08
	rest $08
	note c2  $08
	rest $08
	note e3  $10
	note g2  $08
	rest $18
	note g2  $08
	rest $08
	note c3  $08
	rest $08
	note g2  $08
	rest $08
	note c2  $08
	rest $10
	note c2  $08
	note e3  $18
	note g2  $04
	rest $04
	note g2  $08
	rest $08
	note g2  $08
	note as2 $08
	note c3  $08
	rest $08
	note g2  $08
	rest $08
	note c2  $08
	rest $08
	note c2  $08
	rest $08
	note e3  $10
	note g2  $08
	rest $18
	note g2  $08
	rest $08
	note c3  $08
	rest $08
	note g2  $08
	rest $08
	note c2  $08
	rest $08
	note c2  $08
	rest $08
	note e3  $10
	note c3  $08
	note g2  $08
	rest $10
	note g2  $08
	rest $08
	note as2 $08
	rest $08
	note c3  $08
	rest $08
	note c2  $08
	rest $08
	note c2  $08
	rest $08
	note e3  $10
	note c3  $08
	note g2  $08
	rest $10
	note c3  $08
	rest $08
	note as2 $08
	rest $08
	note c3  $08
	rest $08
	note c2  $10
	rest $08
	note ds3 $08
	note e3  $10
	note c3  $08
	note g2  $08
	note c3  $08
	rest $08
	note g2  $08
	rest $08
	note as2 $08
	rest $08
	note c3  $08
	rest $08
	note c2  $08
	rest $08
	note c2  $08
	rest $08
	note e3  $10
	note c3  $08
	note g2  $08
	note c3  $08
	rest $08
	note g2  $08
	rest $08
	note as2 $08
	rest $08
	note c3  $08
	rest $08
	note c2  $08
	rest $08
	note c2  $08
	rest $08
	note e3  $10
	note c3  $08
	note g2  $08
	note c3  $08
	rest $08
	note g2  $08
	rest $08
	note as2 $08
	rest $08
	note c3  $08
	rest $08
	note c2  $10
	rest $10
	note e3  $10
	note c3  $08
	note g2  $08
	rest $10
	note c3  $08
	rest $08
	note as2 $08
	rest $08
	note c3  $08
	rest $08
	note c2  $10
	rest $08
	note ds3 $08
	note e3  $10
	note c3  $08
	note g2  $08
	note c3  $08
	rest $08
	note g2  $08
	rest $08
	note as2 $08
	rest $08
	note c3  $08
	rest $08
	note c2  $08
	rest $18
	note e3  $10
	note c3  $08
	note g2  $08
	note c3  $08
	rest $08
	note g2  $08
	rest $08
	note as2 $08
	rest $08
	note c3  $08
	rest $08
	note c2  $08
	rest $08
	note c2  $08
	rest $08
	note e3  $10
	note c3  $08
	note g2  $08
	rest $10
	note g2  $08
	rest $08
	note c3  $08
	rest $08
	note g2  $08
	rest $08
	note c2  $08
	rest $08
	note c2  $08
	rest $08
	note e3  $10
	note c3  $08
	note g2  $04
	rest $04
	note g2  $08
	rest $08
	note as2 $08
	rest $08
	note c3  $08
	rest $08
	note g2  $08
	rest $08
	note c2  $08
	rest $08
	note c2  $08
	rest $08
	note e3  $10
	note c3  $08
	note g2  $04
	rest $04
	note g2  $08
	rest $08
	note as2 $08
	rest $08
	note c3  $08
	rest $08
	note g2  $08
	rest $08
	note c2  $20
	note e3  $08
	rest $08
	note g2  $08
	rest $18
	note g2  $08
	rest $08
	note as2 $08
	rest $08
	note c3  $08
	rest $08
	note c2  $08
	rest $08
	note c2  $08
	rest $08
	note e3  $08
	rest $08
	note g2  $08
	rest $18
	note g2  $08
	rest $08
	note c3  $08
	rest $08
	note g2  $08
	rest $08
	note c2  $08
	rest $10
	note c2  $08
	note e3  $18
	note g2  $08
	rest $10
	note g2  $08
	note as2 $08
	note c3  $08
	rest $08
	note g2  $08
	rest $08
	note c2  $08
	rest $08
	note c2  $08
	rest $08
	note e3  $08
	rest $08
	note g2  $08
	rest $18
	note g2  $08
	rest $08
	note c3  $08
	rest $08
	note g2  $08
	rest $08
	note c2  $08
	rest $08
	note c2  $08
	rest $08
	note e3  $10
	note c3  $08
	note g2  $08
	note c3  $08
	rest $08
	note g2  $08
	rest $08
	note as2 $08
	rest $08
	note c3  $08
	rest $08
	note c2  $08
	rest $08
	note c2  $08
	rest $08
	note e3  $10
	note c3  $08
	note g2  $08
	rest $10
	note c3  $08
	rest $08
	note as2 $08
	rest $08
	note c3  $08
	rest $08
	note c2  $0a
	rest $0e
	note ds3 $08
	note e3  $10
	note c3  $08
	note g2  $08
	note c3  $08
	rest $08
	note g2  $08
	rest $08
	note as2 $08
	rest $08
	note c3  $08
	rest $08
	goto musicf87b3
	cmdff

sound3eChannel4:
musicf8b3e:
	duty $17
	rest $30
	note g3  $0d
	rest $23
	note f3  $08
	rest $08
	note e3  $08
	rest $b8
	note g3  $02
	rest $06
	note g3  $02
	rest $06
	note g3  $04
	rest $0c
	note g3  $04
	rest $0c
	note f3  $04
	rest $0c
	note e3  $04
	rest $6c
	note d3  $08
	rest $08
	note e3  $04
	rest $3c
	note g3  $0d
	rest $23
	note f3  $08
	rest $08
	note e3  $08
	rest $b8
	note g3  $02
	rest $06
	note g3  $02
	rest $06
	note g3  $04
	rest $0c
	note g3  $04
	rest $0c
	note f3  $04
	rest $0c
	note e3  $04
	rest $6c
	note d3  $08
	rest $08
	note e3  $04
	rest $6c
	note d3  $08
	rest $08
	note e3  $04
	rest $0c
	note d3  $08
	rest $08
	note e3  $04
	rest $4c
	note d3  $08
	rest $08
	note e3  $04
	rest $6c
	note f3  $06
	rest $0a
	note f3  $04
	rest $0c
	note f3  $06
	rest $0a
	note f3  $04
	rest $ff
	rest $ff
	rest $3e
	duty $17
	note e4  $08
	rest $08
	note f4  $08
	rest $08
	note e4  $08
	rest $08
	note f4  $08
	rest $08
	note e4  $08
	rest $08
	note g4  $0c
	rest $14
	note g4  $0a
	rest $16
	note f4  $08
	rest $08
	note e4  $08
	rest $38
	note e4  $08
	rest $08
	note f4  $08
	rest $08
	note e4  $08
	rest $08
	note f4  $08
	rest $08
	note e4  $08
	rest $08
	note f4  $08
	rest $08
	note e4  $08
	rest $08
	note g4  $0c
	rest $14
	note g4  $10
	rest $10
	note f4  $08
	rest $08
	note e4  $08
	rest $ff
	rest $ff
	rest $3a
	duty $17
	note g3  $0d
	rest $23
	note f3  $08
	rest $08
	note e3  $08
	rest $b8
	note g3  $04
	rest $04
	note g3  $04
	rest $04
	note g3  $08
	rest $08
	note g3  $08
	rest $08
	note f3  $08
	rest $08
	note e3  $08
	rest $58
	note e4  $08
	rest $08
	note f4  $08
	rest $08
	note e4  $08
	rest $08
	note f4  $08
	rest $08
	note e4  $08
	rest $08
	note g4  $08
	rest $18
	note g4  $08
	rest $18
	note f4  $08
	rest $08
	note e4  $08
	rest $38
	note e4  $08
	rest $08
	note f4  $08
	rest $08
	note e4  $08
	rest $08
	note f4  $08
	rest $08
	note e4  $08
	rest $08
	note f4  $08
	rest $08
	note e4  $08
	rest $08
	note g4  $08
	rest $18
	note g4  $08
	rest $18
	note f4  $08
	rest $08
	note e4  $08
	rest $ff
	rest $89
	goto musicf8b3e
	cmdff

sound3eChannel6:
musicf8c98:
	vol $6
	note $24 $10
	note $24 $60
	note $24 $10
	note $24 $10
	note $24 $30
	note $24 $30
	note $24 $10
	note $24 $10
	note $24 $60
	note $24 $10
	note $24 $10
	note $24 $30
	note $24 $30
	note $24 $10
	note $24 $10
	note $24 $60
	note $24 $10
	note $24 $10
	note $24 $30
	note $24 $30
	note $24 $10
	note $24 $10
	note $24 $60
	note $24 $10
	note $24 $10
	note $24 $30
	note $24 $30
	note $24 $10
	note $24 $10
	note $24 $60
	note $24 $10
	note $24 $10
	note $24 $30
	note $24 $30
	note $24 $10
	note $24 $10
	note $24 $60
	note $24 $10
	note $24 $10
	note $24 $30
	note $24 $30
	note $24 $10
	note $24 $10
	note $24 $60
	note $24 $10
	note $24 $10
	note $24 $30
	note $24 $30
	note $24 $10
	note $24 $10
	note $24 $60
	note $24 $10
	note $24 $10
	note $24 $30
	note $24 $30
	note $24 $10
	note $24 $10
	note $24 $60
	note $24 $10
	note $24 $10
	note $24 $30
	note $24 $30
	note $24 $10
	note $24 $10
	note $24 $60
	note $24 $10
	note $24 $10
	note $24 $30
	note $24 $30
	note $24 $10
	note $24 $10
	note $24 $60
	note $24 $10
	note $24 $10
	note $24 $30
	note $24 $30
	note $24 $10
	note $24 $10
	note $24 $60
	note $24 $10
	note $24 $10
	note $24 $30
	note $24 $30
	note $24 $10
	note $24 $10
	note $24 $60
	note $24 $10
	note $24 $10
	note $24 $30
	note $24 $30
	note $24 $10
	note $24 $10
	note $24 $60
	note $24 $10
	note $24 $10
	note $24 $30
	note $24 $30
	note $24 $10
	note $24 $10
	note $24 $60
	note $24 $10
	note $24 $10
	note $24 $30
	note $24 $30
	note $24 $10
	note $24 $10
	note $24 $60
	note $24 $10
	note $24 $10
	note $24 $30
	note $24 $30
	note $24 $10
	note $24 $10
	note $24 $60
	note $24 $10
	goto musicf8c98
	cmdff

sound2aStart:

sound2aChannel1:
	vibrato $e1
	env $0 $00
	duty $01
	vol $6
	note c4  $09
	rest $04
	vol $3
	note c4  $09
	rest $05
	vol $6
	note as3 $09
	note c4  $90
	vibrato $01
	env $0 $00
	vol $4
	note c4  $24
	vol $2
	note c4  $12
	vibrato $e1
	env $0 $00
	vol $6
	note c4  $06
	rest $03
	vol $3
	note c4  $06
	rest $03
	vol $6
	note c4  $06
	rest $03
	vol $3
	note c4  $06
	rest $03
	vol $6
	note c4  $06
	rest $03
	vol $3
	note c4  $06
	rest $03
	vol $6
	note c4  $09
	rest $04
	vol $3
	note c4  $09
	rest $05
	vol $6
	note as3 $09
	note c4  $90
	vibrato $01
	env $0 $00
	vol $4
	note c4  $24
	vol $2
	note c4  $24
	vibrato $e1
	env $0 $00
	vol $6
	note f4  $06
	note g4  $06
	note gs4 $06
	note as4 $06
	note c5  $06
	note d5  $06
	vol $6
	note ds5 $09
	rest $04
	vol $3
	note ds5 $09
	rest $05
	vol $6
	note d5  $09
	note c5  $48
	vibrato $01
	env $0 $00
	vol $3
	note c5  $24
	vibrato $e1
	env $0 $00
	vol $6
	note g4  $12
	note gs4 $12
	note as4 $12
	note c5  $12
	note d5  $12
	note ds5 $12
	note f5  $12
	note fs5 $12
	note g5  $20
	vol $3
	note g5  $10
	vol $6
	note g5  $04
	rest $04
	note g5  $04
	rest $04
	note g5  $1c
	vol $3
	note g5  $0e
	vol $6
	note g5  $03
	rest $04
	note g5  $03
	rest $04
	note g5  $0e
	note g4  $02
	rest $02
	note g4  $03
	rest $02
	note g4  $02
	rest $03
	note a4  $04
	rest $05
	note a4  $05
	rest $04
	note a4  $05
	rest $05
	note b4  $0e
	vol $3
	note b4  $0e
	vol $6
	note g5  $1c
	vibrato $e1
	env $0 $00
musicf8e5b:
	duty $02
	vol $6
	note c5  $07
	rest $03
	vol $3
	note c5  $07
	rest $04
	vol $1
	note c5  $07
	vol $6
	note g4  $2a
	note c5  $07
	rest $03
	vol $3
	note c5  $04
	vol $6
	note c5  $07
	note d5  $07
	note e5  $07
	note f5  $07
	note g5  $38
	vibrato $01
	env $0 $00
	vol $3
	note g5  $0e
	vol $1
	note g5  $0e
	vibrato $e1
	env $0 $00
	vol $6
	note g5  $09
	note gs5 $09
	note as5 $0a
	note c6  $38
	vibrato $01
	env $0 $00
	vol $3
	note c6  $0e
	vibrato $e1
	env $0 $00
	vol $6
	note c6  $0e
	note as5 $0e
	note gs5 $0e
	note as5 $07
	rest $07
	vol $3
	note as5 $07
	vol $6
	note gs5 $07
	note g5  $2a
	vibrato $01
	env $0 $00
	vol $3
	note g5  $0e
	vibrato $e1
	env $0 $00
	vol $6
	note g5  $1c
	note f5  $07
	rest $07
	vol $3
	note f5  $07
	vol $6
	note g5  $07
	note gs5 $31
	vol $3
	note gs5 $07
	vol $6
	note g5  $0e
	note f5  $0e
	note ds5 $07
	rest $07
	vol $3
	note ds5 $07
	vol $6
	note f5  $07
	note g5  $38
	note f5  $0e
	note ds5 $0e
	note d5  $07
	rest $07
	vol $3
	note d5  $07
	vol $6
	note e5  $07
	note fs5 $2a
	note g5  $0e
	note a5  $0e
	note b5  $0e
	note c6  $62
	note d6  $07
	note c6  $07
	note b5  $54
	vibrato $01
	env $0 $00
	vol $3
	note b5  $1c
	vibrato $e1
	env $0 $00
	vol $6
	note c5  $07
	rest $07
	vol $3
	note c5  $07
	vol $6
	note g4  $03
	rest $04
	note g4  $2a
	vol $3
	note g4  $07
	vol $6
	note c5  $03
	rest $04
	note c5  $07
	note d5  $07
	note e5  $07
	note f5  $07
	note g5  $31
	vibrato $01
	env $0 $00
	vol $3
	note g5  $0e
	vol $1
	note g5  $07
	vibrato $e1
	env $0 $00
	vol $6
	note g5  $07
	rest $03
	vol $3
	note g5  $04
	vol $6
	note g5  $0e
	note gs5 $07
	note as5 $07
	note c6  $38
	vibrato $01
	env $0 $00
	vol $3
	note c6  $0e
	vibrato $e1
	env $0 $00
	vol $6
	note c6  $04
	note d6  $05
	note c6  $05
	note as5 $03
	rest $07
	vol $3
	note as5 $04
	vol $6
	note gs5 $03
	rest $07
	vol $3
	note gs5 $04
	vol $6
	note as5 $0e
	rest $03
	vol $3
	note as5 $04
	vol $6
	note gs5 $07
	note g5  $2a
	vibrato $01
	env $0 $00
	vol $3
	note g5  $0e
	vibrato $e1
	env $0 $00
	vol $6
	note g5  $1c
	note f5  $07
	rest $07
	vol $3
	note f5  $07
	vol $6
	note g5  $07
	note gs5 $1c
	vol $3
	note gs5 $0e
	vol $6
	note gs5 $04
	note as5 $05
	note gs5 $05
	note g5  $07
	rest $03
	vol $3
	note g5  $04
	vol $6
	note f5  $07
	rest $03
	vol $3
	note f5  $04
	vol $6
	note ds5 $07
	rest $03
	vol $3
	note ds5 $04
	vol $6
	note ds5 $07
	note f5  $07
	note g5  $1c
	vol $3
	note g5  $0e
	vol $6
	note g5  $04
	note gs5 $05
	note g5  $05
	note f5  $07
	rest $03
	vol $3
	note f5  $04
	vol $6
	note ds5 $07
	rest $03
	vol $3
	note ds5 $04
	vol $6
	note d5  $07
	rest $03
	vol $3
	note d5  $04
	vol $6
	note d5  $07
	note e5  $07
	note fs5 $07
	rest $03
	vol $3
	note fs5 $04
	vol $6
	note fs5 $07
	note g5  $07
	note a5  $07
	rest $03
	vol $3
	note a5  $04
	vol $6
	note a5  $07
	note b5  $07
	note c6  $07
	note b5  $07
	note c6  $07
	note d6  $07
	note ds6 $54
	vibrato $01
	env $0 $00
	vol $3
	note ds6 $0e
	vibrato $e1
	env $0 $00
	vol $6
	note f6  $07
	note ds6 $07
	note d6  $46
	vibrato $01
	env $0 $00
	vol $3
	note d6  $1c
	vol $1
	note d6  $0e
	vibrato $e1
	env $0 $00
	vol $6
	note c6  $07
	rest $07
	vol $3
	note c6  $07
	vol $6
	note d6  $07
	note ds6 $23
	vol $3
	note ds6 $07
	vol $6
	note c6  $0e
	note d6  $0e
	note ds6 $0e
	note d6  $07
	rest $07
	vol $3
	note d6  $07
	vol $6
	note as5 $07
	note g5  $2a
	vol $3
	note g5  $0e
	vol $6
	note g5  $1c
	note gs5 $07
	rest $07
	vol $3
	note gs5 $07
	vol $6
	note as5 $07
	note c6  $23
	vol $3
	note c6  $07
	vol $6
	note gs5 $0e
	note as5 $0e
	note c6  $0e
	note as5 $07
	rest $07
	vol $3
	note as5 $07
	vol $6
	note gs5 $07
	note g5  $2a
	vol $3
	note g5  $0e
	vol $6
	note g5  $07
	rest $03
	vol $3
	note g5  $04
	vol $6
	note gs5 $07
	note g5  $07
	note f5  $07
	rest $07
	vol $3
	note f5  $07
	vol $6
	note g5  $07
	note gs5 $23
	vol $3
	note gs5 $07
	vol $6
	note f5  $0e
	note g5  $0e
	note gs5 $0e
	note g5  $15
	vol $3
	note g5  $07
	vol $6
	note ds5 $15
	vol $3
	note ds5 $07
	vol $6
	note c6  $1c
	vol $3
	note c6  $07
	vol $6
	note c6  $07
	note d6  $07
	note ds6 $07
	note d6  $07
	rest $07
	vol $3
	note d6  $07
	vol $6
	note a5  $03
	rest $04
	note a5  $2a
	vol $3
	note a5  $0e
	vol $6
	note d6  $0e
	note c6  $0e
	note b5  $07
	rest $07
	vol $3
	note b5  $07
	vol $6
	note g5  $07
	note g6  $2a
	note f6  $0e
	note ds6 $0e
	note d6  $0e
	note ds6 $07
	rest $07
	vol $3
	note ds6 $07
	vol $6
	note f6  $07
	note g6  $23
	vol $3
	note g6  $07
	vol $6
	note ds6 $0e
	note f6  $0e
	note g6  $0e
	note f6  $07
	rest $07
	vol $3
	note f6  $07
	vol $6
	note ds6 $07
	note d6  $2a
	vol $3
	note d6  $0e
	vol $6
	note d6  $1c
	note c6  $07
	rest $07
	vol $3
	note c6  $07
	vol $6
	note d6  $07
	note ds6 $23
	vol $3
	note ds6 $07
	vol $6
	note c6  $07
	note d6  $07
	note ds6 $07
	note f6  $07
	note g6  $07
	note gs6 $07
	note as6 $38
	vibrato $01
	env $0 $00
	vol $3
	note as6 $0e
	vol $1
	note as6 $0e
	vibrato $e1
	env $0 $00
	vol $6
	note as5 $1c
	vol $6
	note gs5 $07
	rest $07
	vol $3
	note gs5 $07
	vol $6
	note as5 $07
	note c6  $23
	vol $3
	note c6  $07
	vol $6
	note gs5 $0e
	note as5 $0e
	note c6  $0e
	note g5  $0e
	note fs5 $07
	note g5  $07
	note a5  $0e
	note g5  $07
	note a5  $07
	note b5  $0e
	note a5  $07
	note b5  $07
	note c6  $0e
	vol $6
	note b5  $07
	note c6  $07
	note d6  $2a
	vol $3
	note d6  $0e
	vol $6
	note g6  $23
	note f6  $07
	note ds6 $07
	note d6  $07
	note c6  $38
	vibrato $01
	env $0 $00
	vol $3
	note c6  $1c
	vol $1
	note c6  $0e
	rest $0e
	vibrato $e1
	env $0 $00
	goto musicf8e5b
	cmdff

sound2aChannel0:
	vol $0
	note gs3 $5a
	vibrato $e1
	env $0 $00
	duty $01
	vol $6
	note e3  $09
	note f3  $09
	note g3  $09
	rest $04
	vol $3
	note g3  $05
	vol $6
	note g3  $09
	note a3  $09
	note as3 $12
	note a3  $06
	note as3 $06
	note a3  $06
	note g3  $12
	note f3  $12
	note e3  $12
	note d3  $12
	note c3  $12
	note d3  $12
	note e3  $09
	rest $04
	vol $3
	note e3  $09
	rest $05
	vol $6
	note d3  $09
	note e3  $90
	vol $4
	note e3  $24
	vol $2
	note e3  $24
	vol $6
	note gs3 $06
	note as3 $06
	note c4  $06
	note d4  $06
	note ds4 $06
	note f4  $06
	note g4  $09
	rest $04
	vol $3
	note g4  $09
	rest $05
	vol $6
	note f4  $09
	note ds4 $48
	vol $3
	note ds4 $12
	vol $6
	note ds4 $09
	note f4  $09
	note ds4 $12
	note f4  $12
	note g4  $12
	note gs4 $12
	note as4 $12
	note gs4 $12
	note as4 $12
	note c5  $12
	duty $02
	note b4  $08
	rest $04
	vol $3
	note b4  $08
	rest $04
	vol $1
	note b4  $08
	vol $6
	note g4  $20
	vol $3
	note g4  $0e
	vol $6
	note d4  $03
	rest $04
	note d4  $03
	rest $04
	note g4  $0e
	note d4  $03
	rest $04
	note d4  $03
	rest $04
	note g4  $07
	rest $03
	vol $3
	note g4  $04
	vol $6
	note d3  $07
	note e3  $07
	note f3  $07
	note g3  $07
	note a3  $07
	note as3 $07
	note b3  $07
	note a3  $07
	note b3  $07
	note c4  $07
	note d4  $07
	note e4  $07
	note f4  $07
	note g4  $07
musicf923f:
	rest $38
	vibrato $e1
	env $0 $00
	note c4  $07
	rest $03
	vol $3
	note c4  $07
	rest $04
	vol $1
	note c4  $07
	vol $6
	note g3  $2a
	vibrato $01
	env $0 $00
	vol $3
	note g3  $0e
	vibrato $e1
	env $0 $00
	vol $6
	note c4  $07
	note d4  $07
	note e4  $07
	note f4  $07
	note g4  $2a
	vibrato $01
	env $0 $00
	vol $3
	note g4  $0e
	vibrato $e1
	env $0 $00
	vol $6
	note g4  $25
	note gs4 $09
	note g4  $0a
	note f4  $09
	note g4  $09
	note f4  $0a
	note ds4 $09
	note f4  $09
	note ds4 $0a
	note d4  $07
	rest $07
	vol $3
	note d4  $07
	vol $6
	note c4  $07
	note as3 $0e
	note ds4 $07
	note f4  $07
	note g4  $0e
	note ds4 $0e
	note as3 $0e
	note g3  $0e
	rest $2a
	note gs3 $07
	note as3 $07
	note c4  $38
	rest $2a
	note ds4 $07
	note d4  $07
	note ds4 $38
	note a3  $38
	note b3  $1c
	note c4  $1c
	note d4  $0a
	rest $04
	vibrato $00
	env $0 $02
	note g4  $03
	rest $01
	vol $5
	note g4  $04
	rest $01
	vol $4
	note g4  $03
	rest $02
	vibrato $00
	env $0 $00
	vol $6
	note g4  $0e
	vibrato $00
	env $0 $02
	note c5  $03
	rest $01
	vol $5
	note c5  $04
	rest $01
	vol $4
	note c5  $03
	rest $02
	vibrato $00
	env $0 $00
	vol $6
	note c5  $0e
	vibrato $00
	env $0 $02
	note d5  $03
	rest $01
	vol $5
	note d5  $04
	rest $01
	vol $4
	note d5  $03
	rest $02
	vibrato $00
	env $0 $00
	vol $6
	note d5  $0e
	vibrato $00
	env $0 $02
	note g5  $03
	rest $01
	vol $5
	note g5  $04
	rest $01
	vol $4
	note g5  $03
	rest $02
	vibrato $00
	env $0 $00
	vol $6
	note g5  $0e
	vibrato $00
	env $0 $02
	note d5  $03
	rest $01
	vol $5
	note d5  $04
	rest $01
	vol $4
	note d5  $03
	rest $02
	vibrato $00
	env $0 $00
	vol $6
	note d5  $0e
	vibrato $00
	env $0 $02
	note c5  $03
	rest $01
	vol $5
	note c5  $04
	rest $01
	vol $4
	note c5  $03
	rest $02
	vibrato $00
	env $0 $00
	vol $6
	note c5  $0e
	vibrato $00
	env $0 $02
	note g4  $03
	rest $01
	vol $5
	note g4  $04
	rest $01
	vol $4
	note g4  $03
	rest $02
	vibrato $00
	env $0 $00
	vol $6
	note g4  $0e
	vibrato $00
	env $0 $02
	note d4  $03
	rest $01
	vol $5
	note d4  $04
	rest $01
	vol $4
	note d4  $03
	rest $3a
	vibrato $e1
	env $0 $00
	vol $6
	note e4  $1c
	note c4  $1c
	note g3  $15
	note c4  $03
	rest $04
	note c4  $07
	note d4  $07
	note e4  $07
	note f4  $07
	note g4  $2a
	vibrato $01
	env $0 $00
	vol $3
	note g4  $0e
	vibrato $e1
	env $0 $00
	vol $6
	note g4  $2a
	note gs4 $07
	note g4  $07
	note f4  $0e
	note g4  $07
	note f4  $07
	note ds4 $0e
	note f4  $07
	note ds4 $07
	note d4  $07
	rest $07
	vol $3
	note d4  $07
	vol $6
	note c4  $07
	note as3 $07
	rest $03
	vol $3
	note as3 $04
	vol $6
	note ds4 $07
	note f4  $07
	note g4  $0e
	note ds4 $0e
	note as3 $0e
	note g3  $0e
	rest $2a
	note gs3 $07
	note as3 $07
	note c4  $1c
	vol $3
	note c4  $1c
	rest $2a
	vol $6
	note c4  $07
	note d4  $07
	note ds4 $1c
	vol $3
	note ds4 $1c
	rest $1c
	vol $6
	note d4  $07
	rest $03
	vol $3
	note d4  $04
	vol $6
	note d4  $07
	note e4  $07
	note fs4 $07
	rest $03
	vol $3
	note fs4 $04
	vol $6
	note fs4 $07
	note gs4 $07
	note a4  $07
	note gs4 $07
	note a4  $07
	note b4  $07
	note g3  $07
	note fs3 $07
	note g3  $07
	note a3  $07
	note b3  $07
	note a3  $07
	note b3  $07
	note c4  $07
	note d4  $07
	note cs4 $07
	note d4  $07
	note ds4 $07
	note f4  $07
	note e4  $07
	note f4  $07
	note g4  $07
	vol $6
	note gs4 $07
	note g4  $07
	note gs4 $07
	note as4 $07
	note c5  $07
	note b4  $07
	note c5  $07
	note d5  $07
	note ds5 $07
	note d5  $07
	note ds5 $07
	note f5  $07
	note g5  $03
	rest $04
	note g5  $07
	note a5  $07
	note b5  $07
	note ds5 $07
	rest $07
	vol $3
	note ds5 $07
	vol $6
	note f5  $07
	note g5  $1c
	vol $3
	note g5  $0e
	vol $6
	note ds5 $0e
	note f5  $0e
	note g5  $0e
	note f5  $07
	rest $07
	vol $3
	note f5  $07
	vol $6
	note d5  $07
	note as4 $0e
	note d5  $07
	note ds5 $07
	note f5  $0e
	note d5  $0e
	vol $6
	note as4 $0e
	note d5  $0e
	note c5  $38
	note d5  $1c
	note c5  $1c
	note d5  $07
	rest $07
	vol $3
	note d5  $07
	vol $6
	note c5  $07
	note as4 $0e
	note d5  $07
	note c5  $07
	note d5  $0e
	note as4 $0e
	note g4  $0e
	note d4  $0e
	note f4  $1c
	vol $3
	note f4  $0e
	vol $6
	note gs4 $07
	note g4  $07
	note gs4 $0e
	note g4  $0e
	note f4  $0e
	note g4  $07
	note gs4 $07
	note g4  $07
	note f4  $07
	note ds4 $1c
	note e4  $07
	note ds4 $07
	note d4  $07
	note cs4 $07
	note c4  $07
	rest $03
	vol $3
	note c4  $04
	vol $6
	note c4  $07
	note b3  $07
	note as3 $0e
	note a3  $1c
	vol $3
	note a3  $0e
	vibrato $00
	env $0 $02
	vol $6
	note d4  $03
	rest $01
	note d4  $04
	rest $01
	note d4  $03
	rest $02
	vibrato $e1
	env $0 $00
	note fs4 $0e
	note a4  $0e
	note fs5 $0e
	note ds5 $0e
	note g3  $07
	note gs3 $07
	note g3  $07
	note fs3 $07
	note g3  $07
	note a3  $07
	note b3  $07
	note c4  $07
	note d4  $07
	note ds4 $07
	note d4  $07
	note cs4 $07
	note d4  $07
	note ds4 $07
	note f4  $07
	note fs4 $07
	note g4  $23
	rest $07
	note g4  $03
	rest $04
	note g4  $03
	rest $04
	note g4  $2a
	vibrato $01
	env $0 $00
	vol $3
	note g4  $0e
	vibrato $e1
	env $0 $00
	vol $6
	note g4  $1c
	vol $3
	note g4  $0e
	vol $6
	note g4  $07
	note c5  $07
	note g4  $07
	rest $03
	vol $3
	note g4  $04
	vol $6
	note g4  $0e
	note gs4 $0e
	note g4  $07
	rest $03
	vol $3
	note g4  $04
	vol $6
	note g4  $38
	note f4  $1c
	note c5  $1c
	note as4 $1c
	vol $3
	note as4 $0e
	vol $6
	note as4 $07
	note c5  $07
	note cs5 $07
	note c5  $07
	note as4 $07
	note gs4 $07
	note g4  $07
	note f4  $07
	note e4  $07
	note g4  $07
	note f4  $07
	rest $07
	vol $3
	note f4  $07
	vol $6
	note g4  $07
	note gs4 $0e
	note f4  $07
	note g4  $07
	note gs4 $07
	rest $03
	vol $3
	note gs4 $04
	vol $6
	note f4  $0e
	note g4  $0e
	note gs4 $0e
	note g4  $0e
	note fs4 $07
	note f4  $07
	note e4  $0e
	note ds4 $07
	note d4  $07
	note cs4 $0e
	note c4  $07
	note b3  $07
	note as3 $0e
	note a3  $07
	note gs3 $07
	note f3  $18
	rest $04
	note f3  $09
	note g3  $09
	note gs3 $0a
	note g3  $0e
	vol $3
	note g3  $0e
	vol $6
	note g3  $09
	note a3  $09
	note b3  $0a
	note c4  $0e
	vol $3
	note c4  $0e
	vol $6
	note g3  $0a
	rest $04
	note g3  $03
	rest $04
	note g3  $03
	rest $04
	note c4  $1c
	vibrato $01
	env $0 $00
	vol $3
	note c4  $0e
	rest $0e
	vibrato $e1
	env $0 $00
	goto musicf923f
	cmdff

sound2aChannel4:
	rest $09
	duty $0f
	note c4  $04
	rest $17
	note as3 $09
	note c4  $b4
	rest $12
	note c4  $04
	rest $0e
	note c4  $04
	rest $0e
	note c4  $04
	rest $05
	duty $06
	note as2 $51
	rest $09
	note as2 $09
	note a2  $09
	note as2 $12
	note a2  $09
	note g2  $09
	note a2  $12
	note g2  $09
	note f2  $09
	note g2  $12
	note f2  $09
	note e2  $09
	note d2  $09
	note e2  $09
	note f2  $09
	note g2  $09
	note f2  $09
	note g2  $09
	note gs2 $09
	note as2 $09
	note gs2 $2d
	note c3  $09
	note ds3 $09
	note g3  $09
	note gs3 $09
	note g3  $09
	note gs3 $09
	note as3 $09
	note c4  $09
	note as3 $09
	note c4  $09
	note d4  $09
	note ds4 $09
	note d4  $09
	note c4  $09
	note as3 $09
	note gs3 $09
	note g3  $09
	note f3  $09
	note ds3 $09
	note d3  $09
	note c3  $09
	note as2 $09
	note gs2 $09
	note g2  $09
	note f2  $09
	note ds2 $09
	note d2  $09
	note g2  $10
	duty $0f
	note g2  $08
	rest $08
	duty $06
	note g2  $10
	duty $0f
	note g2  $08
	rest $08
	duty $06
	note a2  $0e
	duty $0f
	note a2  $07
	rest $07
	duty $06
	note a2  $0e
	duty $0f
	note a2  $07
	rest $07
	duty $06
	note as2 $0e
	duty $0f
	note as2 $07
	rest $07
	duty $06
	note as2 $0e
	duty $0f
	note as2 $07
	rest $07
	duty $06
	note b2  $0e
	duty $0f
	note b2  $07
	rest $07
	duty $06
	note g2  $15
	duty $0f
	note g2  $07
musicf969f:
	duty $04
	note c3  $07
	duty $0f
	note c3  $07
	rest $0e
	duty $04
	note c3  $07
	duty $0f
	note c3  $07
	rest $0e
	duty $04
	note c3  $07
	duty $0f
	note c3  $07
	rest $0e
	duty $04
	note c3  $07
	duty $0f
	note c3  $07
	rest $0e
	duty $04
	note as2 $07
	duty $0f
	note as2 $07
	rest $0e
	duty $04
	note as2 $07
	duty $0f
	note as2 $07
	rest $0e
	duty $04
	note as2 $07
	duty $0f
	note as2 $07
	rest $0e
	duty $04
	note as2 $07
	duty $0f
	note as2 $07
	rest $0e
	duty $04
	note gs2 $07
	duty $0f
	note gs2 $07
	rest $0e
	duty $04
	note gs2 $07
	duty $0f
	note gs2 $07
	rest $0e
	duty $04
	note as2 $07
	duty $0f
	note as2 $07
	rest $0e
	duty $04
	note as2 $07
	duty $0f
	note as2 $07
	rest $0e
	duty $04
	note ds2 $07
	duty $0f
	note ds2 $07
	rest $0e
	duty $04
	note ds2 $07
	duty $0f
	note ds2 $07
	rest $0e
	duty $04
	note ds2 $07
	duty $0f
	note ds2 $07
	rest $0e
	duty $04
	note ds2 $07
	duty $0f
	note ds2 $07
	rest $0e
	duty $04
	note cs3 $07
	duty $0f
	note cs3 $07
	rest $0e
	duty $04
	note cs3 $07
	duty $0f
	note cs3 $07
	rest $0e
	duty $04
	note cs3 $07
	duty $0f
	note cs3 $07
	rest $0e
	duty $04
	note cs3 $07
	duty $0f
	note cs3 $07
	rest $0e
	duty $04
	note c3  $07
	duty $0f
	note c3  $07
	rest $0e
	duty $04
	note c3  $07
	duty $0f
	note c3  $07
	rest $0e
	duty $04
	note c3  $07
	duty $0f
	note c3  $07
	rest $0e
	duty $04
	note c3  $07
	duty $0f
	note c3  $07
	rest $0e
	duty $04
	note d3  $07
	duty $0f
	note d3  $07
	rest $0e
	duty $04
	note d3  $07
	duty $0f
	note d3  $07
	rest $0e
	duty $04
	note d3  $07
	duty $0f
	note d3  $07
	rest $0e
	duty $04
	note d3  $07
	duty $0f
	note d3  $07
	rest $0e
	duty $04
	note g2  $1c
	duty $0f
	note g2  $07
	rest $07
	duty $04
	note g2  $03
	duty $0f
	note g2  $04
	duty $04
	note g2  $03
	duty $0f
	note g2  $04
	duty $04
	note g2  $03
	duty $0f
	note g2  $04
	rest $07
	duty $04
	note g2  $0e
	duty $0f
	note g2  $07
	rest $07
	duty $04
	note g2  $03
	duty $0f
	note g2  $04
	rest $07
	duty $04
	note g2  $11
	duty $0f
	note g2  $07
	rest $04
	duty $04
	note g2  $11
	duty $0f
	note g2  $07
	rest $04
	duty $04
	note a2  $11
	duty $0f
	note a2  $07
	rest $04
	duty $04
	note b2  $11
	duty $0f
	note b2  $07
	rest $04
	duty $04
	note c3  $07
	duty $0f
	note c3  $07
	rest $0e
	duty $04
	note g2  $07
	duty $0f
	note g2  $07
	rest $0e
	duty $04
	note c3  $07
	duty $0f
	note c3  $07
	rest $0e
	duty $04
	note g2  $07
	duty $0f
	note g2  $07
	rest $0e
	duty $04
	note as2 $07
	duty $0f
	note as2 $07
	rest $0e
	duty $04
	note f2  $07
	duty $0f
	note f2  $07
	rest $0e
	duty $04
	note as2 $07
	duty $0f
	note as2 $07
	rest $0e
	duty $04
	note f2  $07
	duty $0f
	note f2  $07
	rest $0e
	duty $04
	note gs2 $07
	duty $0f
	note gs2 $07
	rest $0e
	duty $04
	note gs2 $18
	duty $0f
	note gs2 $04
	duty $04
	note as2 $07
	rest $15
	note as2 $18
	duty $0f
	note as2 $04
	duty $04
	note ds3 $07
	duty $0f
	note ds3 $07
	rest $0e
	duty $04
	note as2 $07
	duty $0f
	note as2 $07
	rest $0e
	duty $04
	note ds3 $07
	duty $0f
	note ds3 $07
	rest $0e
	duty $04
	note ds3 $1c
	note cs3 $07
	duty $0f
	note cs3 $07
	rest $0e
	duty $04
	note gs2 $07
	duty $0f
	note gs2 $07
	rest $0e
	duty $04
	note cs3 $07
	duty $0f
	note cs3 $07
	rest $0e
	duty $04
	note cs3 $1c
	note c3  $07
	duty $0f
	note c3  $07
	rest $0e
	duty $04
	note c3  $07
	duty $0f
	note c3  $07
	rest $0e
	duty $04
	note c3  $07
	duty $0f
	note c3  $07
	rest $0e
	duty $04
	note c3  $18
	duty $0f
	note c3  $04
	duty $04
	note d3  $07
	duty $0f
	note d3  $07
	rest $0e
	duty $04
	note a2  $07
	duty $0f
	note a2  $07
	rest $0e
	duty $04
	note d3  $07
	duty $0f
	note d3  $07
	rest $0e
	duty $04
	note a2  $03
	duty $0f
	note a2  $04
	rest $07
	duty $04
	note a2  $07
	note gs2 $07
	note g2  $1c
	duty $0f
	note g2  $07
	rest $07
	duty $04
	note g2  $03
	duty $0f
	note g2  $04
	duty $04
	note g2  $03
	duty $0f
	note g2  $04
	duty $04
	note g2  $03
	duty $0f
	note g2  $04
	rest $07
	duty $04
	note g2  $11
	duty $0f
	note g2  $04
	rest $07
	duty $04
	note g2  $03
	duty $0f
	note g2  $04
	rest $07
	duty $04
	note g2  $1c
	note a2  $1c
	note as2 $1c
	note b2  $1c
	note c3  $1c
	duty $0f
	note c3  $07
	rest $07
	duty $04
	note c3  $03
	duty $0f
	note c3  $04
	duty $04
	note c3  $03
	duty $0f
	note c3  $04
	duty $04
	note c3  $03
	duty $0f
	note c3  $04
	rest $07
	duty $04
	note c3  $11
	duty $0f
	note c3  $07
	rest $04
	duty $04
	note c3  $07
	duty $0f
	note c3  $07
	duty $04
	note g2  $1c
	duty $0f
	note g2  $07
	rest $07
	duty $04
	note g2  $03
	duty $0f
	note g2  $04
	duty $04
	note g2  $03
	duty $0f
	note g2  $04
	duty $04
	note g2  $03
	duty $0f
	note g2  $04
	rest $07
	duty $04
	note g2  $11
	duty $0f
	note g2  $07
	rest $04
	duty $04
	note g2  $07
	duty $0f
	note g2  $07
	duty $04
	note gs2 $1c
	duty $0f
	note gs2 $07
	rest $07
	duty $04
	note gs2 $03
	duty $0f
	note gs2 $04
	duty $04
	note gs2 $03
	duty $0f
	note gs2 $04
	duty $04
	note as2 $03
	duty $0f
	note as2 $04
	rest $07
	duty $04
	note as2 $11
	duty $0f
	note as2 $07
	rest $04
	duty $04
	note as2 $07
	duty $0f
	note as2 $07
	duty $04
	note ds2 $07
	duty $0f
	note ds2 $07
	rest $0e
	duty $04
	note ds2 $07
	duty $0f
	note ds2 $07
	rest $0e
	duty $04
	note ds2 $07
	duty $0f
	note ds2 $07
	rest $0e
	duty $04
	note ds2 $1c
	note cs3 $07
	duty $0f
	note cs3 $07
	rest $0e
	duty $04
	note cs3 $07
	duty $0f
	note cs3 $07
	rest $0e
	duty $04
	note cs3 $07
	duty $0f
	note cs3 $07
	rest $0e
	duty $04
	note cs3 $07
	duty $0f
	note cs3 $07
	rest $0e
	duty $04
	note c3  $07
	duty $0f
	note c3  $07
	rest $0e
	duty $04
	note c3  $07
	duty $0f
	note c3  $07
	rest $0e
	duty $04
	note c3  $07
	duty $0f
	note c3  $07
	rest $0e
	duty $04
	note c3  $1c
	note d3  $07
	duty $0f
	note d3  $07
	rest $0e
	duty $04
	note d3  $07
	duty $0f
	note d3  $07
	rest $0e
	duty $04
	note d3  $07
	duty $0f
	note d3  $07
	rest $0e
	duty $04
	note d3  $07
	duty $0f
	note d3  $07
	rest $0e
	duty $04
	note g2  $18
	duty $0f
	note g2  $04
	duty $04
	note a2  $18
	duty $0f
	note a2  $04
	duty $04
	note as2 $18
	duty $0f
	note as2 $04
	duty $04
	note b2  $18
	duty $0f
	note b2  $04
	duty $04
	note c3  $1f
	duty $0f
	note c3  $07
	rest $04
	duty $04
	note c3  $03
	duty $0f
	note c3  $04
	duty $04
	note c3  $03
	duty $0f
	note c3  $04
	duty $04
	note c3  $03
	duty $0f
	note c3  $04
	rest $07
	duty $04
	note c3  $15
	duty $0f
	note c3  $07
	duty $04
	note c3  $07
	duty $0f
	note c3  $07
	duty $04
	note as2 $1f
	duty $0f
	note as2 $07
	rest $04
	duty $04
	note as2 $03
	duty $0f
	note as2 $04
	duty $04
	note as2 $03
	duty $0f
	note as2 $04
	duty $04
	note as2 $03
	duty $0f
	note as2 $04
	rest $07
	duty $04
	note as2 $15
	duty $0f
	note as2 $07
	duty $04
	note as2 $07
	duty $0f
	note as2 $07
	duty $04
	note gs2 $1f
	duty $0f
	note gs2 $07
	rest $04
	duty $04
	note gs2 $03
	duty $0f
	note gs2 $04
	duty $04
	note gs2 $03
	duty $0f
	note gs2 $04
	duty $04
	note as2 $07
	duty $0f
	note as2 $07
	duty $04
	note as2 $11
	duty $0f
	note as2 $07
	rest $04
	duty $04
	note as2 $07
	duty $0f
	note as2 $07
	duty $04
	note g2  $1f
	duty $0f
	note g2  $07
	rest $04
	duty $04
	note g2  $03
	duty $0f
	note g2  $04
	duty $04
	note g2  $03
	duty $0f
	note g2  $04
	duty $04
	note cs3 $03
	duty $0f
	note cs3 $04
	rest $07
	duty $04
	note cs3 $11
	duty $0f
	note cs3 $07
	rest $04
	duty $04
	note cs3 $07
	duty $0f
	note cs3 $07
	duty $04
	note f2  $07
	duty $0f
	note f2  $07
	rest $0e
	duty $04
	note f2  $07
	duty $0f
	note f2  $07
	rest $0e
	duty $04
	note f2  $07
	duty $0f
	note f2  $07
	rest $0e
	duty $04
	note f2  $15
	duty $0f
	note f2  $07
	duty $04
	note c3  $1c
	note b2  $1c
	note as2 $1c
	note a2  $1c
	note gs2 $15
	duty $0f
	note gs2 $07
	duty $04
	note gs2 $15
	duty $0f
	note gs2 $07
	duty $04
	note g2  $18
	duty $0f
	note g2  $04
	duty $04
	note g2  $18
	duty $0f
	note g2  $04
	duty $04
	note c3  $0a
	duty $0f
	note c3  $07
	rest $0b
	duty $04
	note g2  $0a
	duty $0f
	note g2  $07
	rest $0b
	duty $04
	note c3  $1c
	duty $0f
	note c3  $07
	rest $15
	goto musicf969f
	cmdff

sound2aChannel6:
	rest $ff
	rest $ff
	rest $ff
	rest $db
	vol $4
	note $26 $0e
	vol $3
	note $26 $04
	vol $4
	note $26 $05
	vol $4
	note $26 $05
	vol $4
	note $26 $0e
	vol $3
	note $26 $04
	vol $3
	note $26 $05
	vol $4
	note $26 $05
	vol $4
	note $26 $0e
	vol $3
	note $26 $04
	vol $4
	note $26 $05
	vol $4
	note $26 $05
	vol $4
	note $26 $03
	vol $3
	note $26 $04
	vol $3
	note $26 $03
	vol $3
	note $26 $04
	note $26 $03
	vol $3
	note $26 $04
	vol $3
	note $26 $03
	vol $4
	note $26 $04
musicf9c2e:
	vol $3
	note $26 $1c
	vol $4
	note $26 $1c
	note $26 $1c
	note $26 $0e
	vol $3
	note $26 $04
	vol $4
	note $26 $05
	vol $4
	note $26 $05
	vol $4
	note $26 $1c
	note $26 $1c
	note $26 $1c
	note $26 $0e
	vol $3
	note $26 $04
	vol $4
	note $26 $05
	vol $4
	note $26 $05
	vol $4
	note $26 $1c
	note $26 $1c
	note $26 $1c
	note $26 $0e
	vol $3
	note $26 $04
	vol $4
	note $26 $05
	vol $4
	note $26 $05
	vol $4
	note $26 $1c
	note $26 $1c
	note $26 $1c
	note $26 $0e
	vol $3
	note $26 $04
	vol $4
	note $26 $05
	vol $4
	note $26 $05
	vol $4
	note $26 $1c
	note $26 $1c
	note $26 $1c
	note $26 $0e
	vol $3
	note $26 $04
	vol $4
	note $26 $05
	vol $4
	note $26 $05
	vol $4
	note $26 $1c
	note $26 $1c
	note $26 $1c
	note $26 $0e
	vol $3
	note $26 $04
	vol $4
	note $26 $05
	vol $4
	note $26 $05
	vol $4
	note $26 $1c
	note $26 $1c
	note $26 $1c
	note $26 $0e
	vol $3
	note $26 $04
	vol $4
	note $26 $05
	vol $4
	note $26 $05
	vol $4
	note $26 $2a
	vol $3
	note $26 $04
	vol $3
	note $26 $05
	vol $4
	note $26 $05
	vol $4
	note $26 $0e
	note $26 $1c
	vol $3
	note $26 $04
	vol $4
	note $26 $05
	vol $4
	note $26 $05
	vol $4
	note $26 $1c
	note $26 $1c
	note $26 $1c
	note $26 $0e
	vol $4
	note $26 $03
	vol $3
	note $26 $04
	vol $4
	note $26 $03
	vol $4
	note $26 $04
	vol $4
	note $26 $1c
	note $26 $1c
	note $26 $1c
	note $26 $0e
	vol $3
	note $26 $04
	vol $4
	note $26 $05
	vol $4
	note $26 $05
	vol $4
	note $26 $1c
	note $26 $1c
	note $26 $1c
	note $26 $0e
	vol $3
	note $26 $04
	vol $4
	note $26 $05
	vol $4
	note $26 $05
	vol $4
	note $26 $1c
	note $26 $1c
	note $26 $1c
	note $26 $0e
	vol $3
	note $26 $04
	vol $4
	note $26 $05
	vol $4
	note $26 $05
	vol $4
	note $26 $1c
	note $26 $1c
	note $26 $1c
	note $26 $04
	vol $2
	note $26 $05
	vol $3
	note $26 $05
	vol $3
	note $26 $04
	vol $3
	note $26 $05
	vol $4
	note $26 $05
	vol $4
	note $26 $1c
	note $26 $1c
	note $26 $1c
	note $26 $0e
	vol $3
	note $26 $04
	vol $4
	note $26 $05
	vol $4
	note $26 $05
	vol $4
	note $26 $1c
	note $26 $1c
	note $26 $1c
	note $26 $0e
	vol $3
	note $26 $04
	vol $4
	note $26 $05
	vol $4
	note $26 $05
	vol $4
	note $26 $1c
	note $26 $1c
	note $26 $1c
	note $26 $0e
	vol $3
	note $26 $04
	vol $4
	note $26 $05
	vol $4
	note $26 $05
	vol $4
	note $26 $1c
	note $26 $0e
	note $26 $04
	vol $3
	note $26 $05
	vol $4
	note $26 $05
	vol $4
	note $26 $0e
	note $26 $1c
	note $26 $03
	vol $3
	note $26 $04
	vol $4
	note $26 $03
	vol $4
	note $26 $04
	note $26 $1c
	note $26 $1c
	note $26 $1c
	note $26 $04
	vol $3
	note $26 $05
	note $26 $05
	note $26 $04
	vol $3
	note $26 $05
	vol $4
	note $26 $05
	vol $4
	note $26 $2a
	vol $3
	note $26 $03
	vol $4
	note $26 $04
	vol $4
	note $26 $03
	note $26 $04
	vol $4
	note $26 $0e
	note $26 $1c
	note $26 $0e
	note $26 $2a
	vol $3
	note $26 $03
	vol $4
	note $26 $04
	vol $4
	note $26 $03
	note $26 $04
	vol $4
	note $26 $0e
	note $26 $0e
	note $26 $0e
	note $26 $03
	vol $3
	note $26 $04
	vol $4
	note $26 $03
	vol $4
	note $26 $04
	vol $4
	note $26 $2a
	vol $3
	note $26 $03
	vol $4
	note $26 $04
	vol $4
	note $26 $03
	note $26 $04
	vol $4
	note $26 $0e
	note $26 $1c
	note $26 $0e
	note $26 $2a
	vol $3
	note $26 $03
	vol $4
	note $26 $04
	vol $4
	note $26 $03
	note $26 $04
	vol $4
	note $26 $0e
	note $26 $0e
	note $26 $0e
	note $26 $03
	vol $3
	note $26 $04
	vol $4
	note $26 $03
	vol $4
	note $26 $04
	vol $4
	note $26 $1c
	note $26 $0e
	vol $3
	note $26 $03
	vol $4
	note $26 $04
	vol $4
	note $26 $03
	note $26 $04
	vol $4
	note $26 $0e
	note $26 $1c
	note $26 $0e
	note $26 $1c
	note $26 $0e
	vol $3
	note $26 $03
	vol $4
	note $26 $04
	vol $4
	note $26 $03
	note $26 $04
	vol $4
	note $26 $0e
	note $26 $1c
	note $26 $0e
	note $26 $1c
	note $26 $0e
	vol $3
	note $26 $03
	vol $4
	note $26 $04
	vol $4
	note $26 $03
	note $26 $04
	vol $4
	note $26 $0e
	note $26 $1c
	note $26 $0e
	note $26 $0e
	vol $3
	note $26 $03
	note $26 $04
	vol $4
	note $26 $03
	vol $4
	note $26 $04
	vol $4
	note $26 $0e
	vol $3
	note $26 $03
	vol $4
	note $26 $04
	vol $4
	note $26 $03
	note $26 $04
	vol $4
	note $26 $0e
	vol $3
	note $26 $03
	vol $4
	note $26 $04
	vol $4
	note $26 $03
	vol $4
	note $26 $04
	note $26 $03
	vol $3
	note $26 $04
	vol $3
	note $26 $03
	vol $3
	note $26 $04
	vol $4
	note $26 $03
	vol $4
	note $26 $04
	vol $4
	note $26 $03
	note $26 $04
	vol $4
	note $26 $1c
	note $26 $0e
	vol $4
	note $26 $03
	vol $4
	note $26 $04
	vol $4
	note $26 $03
	vol $4
	note $26 $04
	vol $4
	note $26 $0e
	note $26 $1c
	note $26 $0e
	note $26 $1c
	note $26 $0e
	vol $4
	note $26 $03
	vol $4
	note $26 $04
	vol $4
	note $26 $03
	vol $4
	note $26 $04
	vol $4
	note $26 $0e
	note $26 $1c
	note $26 $0e
	note $26 $1c
	note $26 $0e
	vol $4
	note $26 $03
	vol $4
	note $26 $04
	vol $4
	note $26 $03
	vol $4
	note $26 $04
	vol $4
	note $26 $0e
	note $26 $1c
	note $26 $0e
	note $26 $1c
	note $26 $0e
	vol $4
	note $26 $03
	vol $4
	note $26 $04
	vol $4
	note $26 $03
	vol $4
	note $26 $04
	vol $4
	note $26 $0e
	note $26 $1c
	note $26 $0e
	note $26 $1c
	note $26 $0e
	vol $4
	note $26 $03
	vol $4
	note $26 $04
	vol $4
	note $26 $03
	vol $4
	note $26 $04
	vol $4
	note $26 $0e
	note $26 $1c
	note $26 $0e
	note $26 $0e
	vol $3
	note $26 $04
	vol $3
	note $26 $05
	vol $4
	note $26 $05
	vol $4
	note $26 $0e
	vol $4
	note $26 $03
	vol $4
	note $26 $04
	vol $4
	note $26 $03
	vol $4
	note $26 $04
	vol $4
	note $26 $0e
	vol $4
	note $26 $03
	vol $3
	note $26 $04
	vol $3
	note $26 $03
	vol $4
	note $26 $04
	vol $4
	note $26 $03
	vol $4
	note $26 $04
	vol $3
	note $26 $03
	vol $3
	note $26 $04
	vol $3
	note $26 $03
	vol $3
	note $26 $04
	vol $4
	note $26 $03
	vol $4
	note $26 $04
	vol $4
	note $26 $1c
	note $26 $0e
	vol $4
	note $26 $03
	vol $4
	note $26 $04
	vol $4
	note $26 $03
	vol $4
	note $26 $04
	vol $4
	note $26 $0e
	note $26 $1c
	note $26 $0e
	note $26 $1c
	note $26 $0e
	vol $4
	note $26 $03
	vol $4
	note $26 $04
	vol $4
	note $26 $03
	vol $4
	note $26 $04
	vol $4
	note $26 $0e
	note $26 $0e
	note $26 $1c
	goto musicf9c2e
	cmdff

sound2eStart:

sound2eChannel1:
	vibrato $00
	env $0 $00
	duty $02
musicf9f6b:
	vol $6
	note b4  $0c
	note e4  $06
	note b4  $0c
	note e4  $06
	note b4  $24
	vol $3
	note b4  $18
	vol $6
	note as4 $0c
	note fs4 $06
	note as4 $0c
	note fs4 $06
	note as4 $24
	vol $3
	note as4 $18
	vol $6
	note b4  $0c
	note e4  $06
	note b4  $0c
	note e4  $06
	note b4  $24
	vol $3
	note b4  $18
	vol $6
	note as4 $06
	note b4  $06
	rest $03
	vol $3
	note b4  $03
	vol $6
	note c5  $06
	note cs5 $06
	rest $03
	vol $3
	note cs5 $03
	vol $6
	note d5  $06
	note ds5 $06
	rest $03
	vol $3
	note ds5 $03
	vol $6
	note e5  $06
	note f5  $06
	rest $03
	vol $3
	note f5  $03
	vol $6
	note fs5 $06
	note g5  $06
	note gs5 $06
	note a5  $06
	note b4  $0c
	note e4  $06
	note b4  $0c
	note e4  $06
	note b4  $24
	vol $3
	note b4  $18
	vol $6
	note as4 $0c
	note fs4 $06
	note as4 $0c
	note fs4 $06
	note as4 $24
	vol $3
	note as4 $18
	vol $6
	note b4  $0c
	note e4  $06
	note b4  $0c
	note e4  $06
	note b4  $24
	vol $3
	note b4  $18
	vol $6
	note a4  $06
	note as4 $06
	rest $03
	vol $3
	note as4 $03
	vol $6
	note b4  $06
	note c5  $06
	vol $6
	note cs5 $06
	note d5  $06
	note ds5 $06
	note e5  $1e
	vol $3
	note e5  $0c
	rest $06
	vol $6
	note c5  $12
	note g4  $12
	note c5  $0c
	note b4  $12
	note fs4 $06
	rest $03
	vol $3
	note fs4 $06
	rest $03
	vol $1
	note fs4 $06
	rest $06
	vol $6
	note c5  $12
	vol $6
	note g4  $12
	note c5  $0c
	note cs5 $12
	note gs5 $06
	rest $03
	vol $3
	note gs5 $06
	rest $03
	vol $1
	note gs5 $06
	rest $06
	vol $6
	note c5  $12
	note g4  $12
	note c5  $0c
	note b4  $18
	note ds5 $18
	note d5  $06
	note cs5 $06
	rest $03
	vol $3
	note cs5 $03
	vol $6
	note c5  $06
	note b4  $06
	rest $03
	vol $3
	note b4  $03
	vol $6
	note as4 $06
	note a4  $06
	rest $03
	vol $3
	note a4  $03
	vol $6
	note gs4 $06
	note g4  $06
	rest $03
	vol $3
	note g4  $03
	vol $6
	note g4  $06
	note fs4 $06
	note f4  $06
	note e4  $06
	note ds4 $48
	vol $3
	note ds4 $18
	rest $60
	goto musicf9f6b
	cmdff

sound2eChannel0:
	vibrato $00
	env $0 $00
	duty $02
musicfa087:
	vol $6
	note g4  $0c
	note b3  $06
	note g4  $0c
	note b3  $06
	note g4  $18
	note b3  $0c
	note e4  $0c
	note g4  $0c
	note fs4 $0c
	note as3 $06
	note fs4 $0c
	note as3 $06
	note fs4 $18
	note as4 $0c
	note a4  $0c
	note gs4 $0c
	note g4  $0c
	note b3  $06
	note g4  $0c
	note b3  $06
	note g4  $24
	vol $3
	note g4  $18
	vol $6
	note d4  $06
	note cs4 $06
	rest $03
	vol $3
	note cs4 $03
	vol $6
	note c4  $06
	note b3  $06
	rest $03
	vol $3
	note b3  $03
	vol $6
	note as3 $06
	note a3  $06
	rest $03
	vol $3
	note a3  $03
	vol $6
	note gs3 $06
	note g3  $06
	rest $03
	vol $3
	note g3  $03
	vol $6
	note fs3 $06
	note f3  $06
	note e3  $06
	note d3  $06
	note g4  $0c
	note b3  $06
	note g4  $0c
	note b3  $06
	note g4  $18
	note b3  $0c
	note e4  $0c
	note g4  $0c
	note fs4 $0c
	note as3 $06
	note fs4 $0c
	note as3 $06
	note fs4 $18
	note as4 $0c
	note a4  $0c
	note gs4 $0c
	note g4  $0c
	note b3  $06
	note g4  $0c
	note b3  $06
	note g4  $18
	note b3  $0c
	note e4  $0c
	note g4  $0c
	rest $60
	note g4  $12
	note e4  $12
	note g4  $0c
	note fs4 $12
	note ds4 $06
	rest $03
	vol $3
	note ds4 $06
	rest $03
	vol $1
	note ds4 $06
	rest $06
	vol $6
	note g4  $12
	note e4  $12
	note g4  $0c
	note fs4 $12
	note b4  $06
	rest $03
	vol $3
	note b4  $06
	rest $03
	vol $1
	note b4  $06
	rest $06
	vol $6
	note g4  $12
	note e4  $12
	note c4  $0c
	note b3  $0c
	note ds4 $0c
	note fs4 $0c
	note b4  $0c
	rest $60
	note ds4 $06
	note d4  $06
	rest $03
	vol $3
	note d4  $03
	vol $6
	note cs4 $06
	note c4  $06
	rest $03
	vol $3
	note c4  $03
	vol $6
	note b3  $06
	note as3 $06
	rest $03
	vol $3
	note as3 $03
	vol $6
	note a3  $06
	note gs3 $06
	rest $03
	vol $3
	note gs3 $03
	vol $6
	note g3  $06
	note fs3 $06
	note f3  $06
	note e3  $06
	rest $60
	goto musicfa087
	cmdff

sound2eChannel4:
musicfa18c:
	duty $12
	note e2  $04
	duty $17
	note e2  $02
	duty $12
	note b2  $04
	duty $17
	note b2  $02
	duty $12
	note e3  $04
	duty $17
	note e3  $02
	duty $12
	note b2  $04
	duty $17
	note b2  $02
	duty $12
	note e2  $04
	duty $17
	note e2  $02
	duty $12
	note b2  $04
	duty $17
	note b2  $02
	duty $12
	note e3  $04
	duty $17
	note e3  $02
	duty $12
	note b2  $04
	duty $17
	note b2  $02
	duty $12
	note e2  $04
	duty $17
	note e2  $02
	duty $12
	note b2  $04
	duty $17
	note b2  $02
	duty $12
	note e3  $04
	duty $17
	note e3  $02
	duty $12
	note b2  $04
	duty $17
	note b2  $02
	duty $12
	note e2  $04
	duty $17
	note e2  $02
	duty $12
	note b2  $04
	duty $17
	note b2  $02
	duty $12
	note e3  $04
	duty $17
	note e3  $02
	duty $12
	note b2  $04
	duty $17
	note b2  $02
	duty $12
	note ds2 $04
	duty $17
	note ds2 $02
	duty $12
	note as2 $04
	duty $17
	note as2 $02
	duty $12
	note ds3 $04
	duty $17
	note ds3 $02
	duty $12
	note as2 $04
	duty $17
	note as2 $02
	duty $12
	note ds2 $04
	duty $17
	note ds2 $02
	duty $12
	note as2 $04
	duty $17
	note as2 $02
	duty $12
	note ds3 $04
	duty $17
	note ds3 $02
	duty $12
	note as2 $04
	duty $17
	note as2 $02
	duty $12
	note ds2 $04
	duty $17
	note ds2 $02
	duty $12
	note as2 $04
	duty $17
	note as2 $02
	duty $12
	note ds3 $04
	duty $17
	note ds3 $02
	duty $12
	note as2 $04
	duty $17
	note as2 $02
	duty $12
	note ds2 $04
	duty $17
	note ds2 $02
	duty $12
	note as2 $04
	duty $17
	note as2 $02
	duty $12
	note ds3 $04
	duty $17
	note ds3 $02
	duty $12
	note as2 $04
	duty $17
	note as2 $02
	duty $12
	note e2  $04
	duty $17
	note e2  $02
	duty $12
	note b2  $04
	duty $17
	note b2  $02
	duty $12
	note e3  $04
	duty $17
	note e3  $02
	duty $12
	note b2  $04
	duty $17
	note b2  $02
	duty $12
	note e2  $04
	duty $17
	note e2  $02
	duty $12
	note b2  $04
	duty $17
	note b2  $02
	duty $12
	note e3  $04
	duty $17
	note e3  $02
	duty $12
	note b2  $04
	duty $17
	note b2  $02
	duty $12
	note e2  $04
	duty $17
	note e2  $02
	duty $12
	note b2  $04
	duty $17
	note b2  $02
	duty $12
	note e3  $04
	duty $17
	note e3  $02
	duty $12
	note b2  $04
	duty $17
	note b2  $02
	duty $12
	note e2  $04
	duty $17
	note e2  $02
	duty $12
	note b2  $04
	duty $17
	note b2  $02
	duty $12
	note e3  $04
	duty $17
	note e3  $02
	duty $12
	note b2  $04
	duty $17
	note b2  $02
	duty $12
	note b3  $04
	duty $17
	note b3  $02
	duty $12
	note as3 $04
	duty $17
	note as3 $08
	duty $12
	note a3  $04
	duty $17
	note a3  $02
	duty $12
	note gs3 $04
	duty $17
	note gs3 $08
	duty $12
	note g3  $04
	duty $17
	note g3  $02
	duty $12
	note fs3 $04
	duty $17
	note fs3 $08
	duty $12
	note f3  $04
	duty $17
	note f3  $02
	duty $12
	note e3  $04
	duty $17
	note e3  $08
	duty $12
	note ds3 $04
	duty $17
	note ds3 $02
	duty $12
	note d3  $04
	duty $17
	note d3  $02
	duty $12
	note cs3 $04
	duty $17
	note cs3 $02
	duty $12
	note c3  $04
	duty $17
	note c3  $02
	duty $12
	note e2  $04
	duty $17
	note e2  $02
	duty $12
	note b2  $04
	duty $17
	note b2  $02
	duty $12
	note e3  $04
	duty $17
	note e3  $02
	duty $12
	note b2  $04
	duty $17
	note b2  $02
	duty $12
	note e2  $04
	duty $17
	note e2  $02
	duty $12
	note b2  $04
	duty $17
	note b2  $02
	duty $12
	note e3  $04
	duty $17
	note e3  $02
	duty $12
	note b2  $04
	duty $17
	note b2  $02
	duty $12
	note e2  $04
	duty $17
	note e2  $02
	duty $12
	note b2  $04
	duty $17
	note b2  $02
	duty $12
	note e3  $04
	duty $17
	note e3  $02
	duty $12
	note b2  $04
	duty $17
	note b2  $02
	duty $12
	note e2  $04
	duty $17
	note e2  $02
	duty $12
	note b2  $04
	duty $17
	note b2  $02
	duty $12
	note e3  $04
	duty $17
	note e3  $02
	duty $12
	note b2  $04
	duty $17
	note b2  $02
	duty $12
	note ds2 $04
	duty $17
	note ds2 $02
	duty $12
	note as2 $04
	duty $17
	note as2 $02
	duty $12
	note ds3 $04
	duty $17
	note ds3 $02
	duty $12
	note as2 $04
	duty $17
	note as2 $02
	duty $12
	note ds2 $04
	duty $17
	note ds2 $02
	duty $12
	note as2 $04
	duty $17
	note as2 $02
	duty $12
	note ds3 $04
	duty $17
	note ds3 $02
	duty $12
	note as2 $04
	duty $17
	note as2 $02
	duty $12
	note ds2 $04
	duty $17
	note ds2 $02
	duty $12
	note as2 $04
	duty $17
	note as2 $02
	duty $12
	note ds3 $04
	duty $17
	note ds3 $02
	duty $12
	note as2 $04
	duty $17
	note as2 $02
	duty $12
	note ds2 $04
	duty $17
	note ds2 $02
	duty $12
	note as2 $04
	duty $17
	note as2 $02
	duty $12
	note ds3 $04
	duty $17
	note ds3 $02
	duty $12
	note as2 $04
	duty $17
	note as2 $02
	duty $12
	note e2  $04
	duty $17
	note e2  $02
	duty $12
	note b2  $04
	duty $17
	note b2  $02
	duty $12
	note e3  $04
	duty $17
	note e3  $02
	duty $12
	note b2  $04
	duty $17
	note b2  $02
	duty $12
	note e2  $04
	duty $17
	note e2  $02
	duty $12
	note b2  $04
	duty $17
	note b2  $02
	duty $12
	note e3  $04
	duty $17
	note e3  $02
	duty $12
	note b2  $04
	duty $17
	note b2  $02
	duty $12
	note e2  $04
	duty $17
	note e2  $02
	duty $12
	note b2  $04
	duty $17
	note b2  $02
	duty $12
	note e3  $04
	duty $17
	note e3  $02
	duty $12
	note b2  $04
	duty $17
	note b2  $02
	duty $12
	note e2  $04
	duty $17
	note e2  $02
	duty $12
	note b2  $04
	duty $17
	note b2  $02
	duty $12
	note e3  $04
	duty $17
	note e3  $02
	duty $12
	note b2  $04
	duty $17
	note b2  $02
	duty $12
	note b2  $04
	duty $17
	note b2  $02
	duty $12
	note as2 $04
	duty $17
	note as2 $08
	duty $12
	note a2  $04
	duty $17
	note a2  $02
	duty $12
	note gs2 $04
	duty $17
	note gs2 $02
	duty $12
	note g2  $04
	duty $17
	note g2  $02
	duty $12
	note fs2 $04
	duty $17
	note fs2 $02
	duty $12
	note f2  $04
	duty $17
	note f2  $02
	duty $12
	note e2  $04
	duty $17
	note e2  $02
	duty $12
	note b2  $04
	duty $17
	note b2  $02
	duty $12
	note e3  $04
	duty $17
	note e3  $02
	duty $12
	note b2  $04
	duty $17
	note b2  $02
	duty $12
	note e2  $04
	duty $17
	note e2  $02
	duty $12
	note b2  $04
	duty $17
	note b2  $02
	duty $12
	note e3  $04
	duty $17
	note e3  $02
	duty $12
	note b2  $04
	duty $17
	note b2  $02
	duty $12
	note c2  $04
	duty $17
	note c2  $02
	duty $12
	note g2  $04
	duty $17
	note g2  $02
	duty $12
	note c3  $04
	duty $17
	note c3  $02
	duty $12
	note g2  $04
	duty $17
	note g2  $02
	duty $12
	note c2  $04
	duty $17
	note c2  $02
	duty $12
	note g2  $04
	duty $17
	note g2  $02
	duty $12
	note c3  $04
	duty $17
	note c3  $02
	duty $12
	note g2  $04
	duty $17
	note g2  $02
	duty $12
	note b1  $04
	duty $17
	note b1  $02
	duty $12
	note fs2 $04
	duty $17
	note fs2 $02
	duty $12
	note b2  $04
	duty $17
	note b2  $02
	duty $12
	note fs2 $04
	duty $17
	note fs2 $02
	duty $12
	note b1  $04
	duty $17
	note b1  $02
	duty $12
	note fs2 $04
	duty $17
	note fs2 $02
	duty $12
	note b2  $04
	duty $17
	note b2  $02
	duty $12
	note fs2 $04
	duty $17
	note fs2 $02
	duty $12
	note c2  $04
	duty $17
	note c2  $02
	duty $12
	note g2  $04
	duty $17
	note g2  $02
	duty $12
	note c3  $04
	duty $17
	note c3  $02
	duty $12
	note g2  $04
	duty $17
	note g2  $02
	duty $12
	note c2  $04
	duty $17
	note c2  $02
	duty $12
	note g2  $04
	duty $17
	note g2  $02
	duty $12
	note c3  $04
	duty $17
	note c3  $02
	duty $12
	note g2  $04
	duty $17
	note g2  $02
	duty $12
	note b1  $04
	duty $17
	note b1  $02
	duty $12
	note fs2 $04
	duty $17
	note fs2 $02
	duty $12
	note b2  $04
	duty $17
	note b2  $02
	duty $12
	note fs2 $04
	duty $17
	note fs2 $02
	duty $12
	note b1  $04
	duty $17
	note b1  $02
	duty $12
	note fs2 $04
	duty $17
	note fs2 $02
	duty $12
	note b2  $04
	duty $17
	note b2  $02
	duty $12
	note fs2 $04
	duty $17
	note fs2 $02
	duty $12
	note c2  $04
	duty $17
	note c2  $02
	duty $12
	note g2  $04
	duty $17
	note g2  $02
	duty $12
	note c3  $04
	duty $17
	note c3  $02
	duty $12
	note g2  $04
	duty $17
	note g2  $02
	duty $12
	note c2  $04
	duty $17
	note c2  $02
	duty $12
	note g2  $04
	duty $17
	note g2  $02
	duty $12
	note c3  $04
	duty $17
	note c3  $02
	duty $12
	note g2  $04
	duty $17
	note g2  $02
	duty $12
	note b1  $04
	duty $17
	note b1  $02
	duty $12
	note fs2 $04
	duty $17
	note fs2 $02
	duty $12
	note b2  $04
	duty $17
	note b2  $02
	duty $12
	note fs2 $04
	duty $17
	note fs2 $02
	duty $12
	note b1  $04
	duty $17
	note b1  $02
	duty $12
	note fs2 $04
	duty $17
	note fs2 $02
	duty $12
	note b2  $04
	duty $17
	note b2  $02
	duty $12
	note fs2 $04
	duty $17
	note fs2 $02
	duty $12
	note g2  $04
	duty $17
	note g2  $02
	duty $12
	note fs2 $04
	duty $17
	note fs2 $08
	duty $12
	note f2  $04
	duty $17
	note f2  $02
	duty $12
	note e2  $04
	duty $17
	note e2  $08
	duty $12
	note ds2 $04
	duty $17
	note ds2 $02
	duty $12
	note d2  $04
	duty $17
	note d2  $08
	duty $12
	note cs2 $04
	duty $17
	note cs2 $02
	duty $12
	note c2  $04
	duty $17
	note c2  $08
	duty $12
	note b1  $04
	duty $17
	note b1  $02
	duty $12
	note c2  $04
	duty $17
	note c2  $02
	duty $12
	note as2 $04
	duty $17
	note as2 $02
	duty $12
	note b2  $04
	duty $17
	note b2  $02
	duty $12
	note ds3 $05
	duty $17
	note ds3 $13
	duty $12
	note b1  $48
	rest $60
	goto musicfa18c
	cmdff

sound2eChannel6:
musicfa756:
	vol $5
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $0b
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $0b
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $0b
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $0b
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $0b
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $0b
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $0b
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $0b
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $0b
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $0b
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $0b
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $0b
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $0b
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $0b
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $0b
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $0b
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $0b
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $0b
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $0b
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $0b
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $0b
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $0b
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $0b
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $0b
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $0b
	vol $8
	note $28 $01
	vol $2
	note $27 $0b
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $0b
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $0b
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $0b
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $0b
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $0b
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $0b
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $0b
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $0b
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $0b
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $0b
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $0b
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $0b
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $0b
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $0b
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $0b
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $0b
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $0b
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $0b
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $0b
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $0b
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $5
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $4
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $4
	vol $8
	note $28 $01
	vol $2
	note $27 $05
	vol $2
	note $2a $06
	note $2a $0c
	note $2a $06
	note $2a $0c
	note $2a $06
	note $2a $0c
	vol $2
	note $2a $06
	note $2a $0c
	note $2a $06
	note $2a $06
	note $2a $06
	note $2a $06
	goto musicfa756
	cmdff

sound29Start:

sound29Channel1:
	vibrato $e1
	env $0 $00
	duty $02
	vol $6
	note g4  $18
	vol $3
	note g4  $08
	vol $6
	note g4  $0a
	note d4  $0b
	note g4  $0b
	note f4  $18
	vol $3
	note f4  $08
	vol $6
	note f4  $0a
	note g4  $0b
	note a4  $0b
	note as4 $18
	vol $3
	note as4 $08
	vol $6
	note as4 $0a
	note g4  $0b
	note as4 $0b
	note a4  $18
	vol $3
	note a4  $08
	vol $6
	note a4  $0a
	note as4 $0b
	note c5  $0b
	note d5  $40
	vibrato $01
	vol $3
	note d5  $20
	vibrato $e1
	vol $6
	note c5  $08
	rest $02
	note c5  $08
	rest $02
	note c5  $09
	rest $03
	note d5  $50
	vibrato $01
	vol $3
	note d5  $10
	vibrato $e1
	vol $6
	note c5  $0a
	note b4  $0b
	note a4  $0b
musicfaba1:
	note g4  $08
	rest $04
	vol $3
	note g4  $08
	rest $04
	vol $1
	note g4  $08
	vol $6
	note d4  $20
	vol $3
	note d4  $10
	vol $6
	note g4  $08
	rest $04
	vol $3
	note g4  $04
	vol $6
	note g4  $08
	note a4  $08
	note b4  $08
	note c5  $08
	note d5  $40
	vibrato $01
	vol $3
	note d5  $10
	vibrato $e1
	vol $6
	note d5  $08
	rest $04
	vol $3
	note d5  $04
	vol $6
	note d5  $0a
	note ds5 $0b
	note f5  $0b
	note g5  $40
	vibrato $01
	vol $3
	note g5  $10
	vibrato $e1
	vol $6
	note g5  $10
	note f5  $10
	note ds5 $10
	note f5  $08
	rest $04
	vol $3
	note f5  $08
	rest $04
	vol $6
	note ds5 $08
	note d5  $28
	vibrato $01
	vol $3
	note d5  $18
	vibrato $e1
	vol $6
	note d5  $0a
	note ds5 $0b
	note d5  $0b
	note c5  $08
	rest $04
	vol $3
	note c5  $04
	vol $6
	note c5  $08
	note d5  $08
	vol $6
	note ds5 $28
	vol $3
	note ds5 $08
	vol $6
	note ds5 $10
	note d5  $10
	note c5  $10
	note as4 $08
	rest $04
	vol $3
	note as4 $04
	vol $6
	note as4 $08
	note c5  $08
	note d5  $20
	vol $3
	note d5  $10
	vol $6
	note d5  $10
	note c5  $10
	note as4 $10
	note a4  $08
	rest $04
	vol $3
	note a4  $04
	vol $6
	note a4  $08
	note b4  $08
	note cs5 $20
	vibrato $01
	vol $3
	note cs5 $10
	vibrato $e1
	vol $6
	note cs5 $08
	note d5  $08
	note e5  $08
	note fs5 $08
	note g5  $08
	note a5  $08
	note fs5 $08
	rest $04
	vol $3
	note fs5 $04
	vol $6
	note d5  $02
	rest $02
	note d5  $04
	rest $02
	note d5  $02
	rest $04
	note e5  $08
	rest $02
	note e5  $08
	rest $02
	note e5  $09
	rest $03
	note fs5 $28
	vibrato $01
	vol $3
	note fs5 $18
	vibrato $e1
	vol $6
	note g4  $08
	rest $04
	vol $3
	note g4  $08
	rest $04
	vol $1
	note g4  $08
	vol $6
	note d4  $28
	vol $3
	note d4  $08
	vol $6
	note g4  $08
	rest $04
	vol $3
	note g4  $04
	vol $6
	note g4  $08
	note a4  $08
	note b4  $08
	note c5  $08
	note d5  $40
	vibrato $01
	vol $3
	note d5  $10
	vibrato $e1
	vol $6
	note d5  $08
	rest $04
	vol $3
	note d5  $04
	vol $6
	note d5  $0a
	note ds5 $0b
	note f5  $0b
	note g5  $48
	vibrato $01
	vol $3
	note g5  $08
	vibrato $e1
	vol $6
	note a5  $08
	note as5 $08
	note c6  $08
	note as5 $08
	note a5  $08
	note g5  $08
	note g5  $08
	rest $04
	vol $3
	note g5  $08
	rest $04
	vol $6
	note a5  $08
	note f5  $28
	vibrato $01
	env $0 $00
	vol $3
	note f5  $18
	vibrato $e1
	vol $6
	note d5  $0a
	note ds5 $0b
	note d5  $0b
	note c5  $08
	rest $04
	vol $3
	note c5  $04
	vol $6
	note c5  $08
	note d5  $08
	note ds5 $28
	vol $3
	note ds5 $08
	vol $6
	note ds5 $10
	note d5  $10
	note c5  $10
	note as4 $0a
	note a4  $0b
	note as4 $0b
	note c5  $0a
	note as4 $0b
	note c5  $0b
	note d5  $08
	rest $04
	vol $3
	note d5  $08
	rest $01
	vol $6
	note cs5 $08
	rest $03
	note d5  $0a
	note g5  $0b
	note as5 $0b
	rest $20
	note d5  $20
	note d6  $28
	note c6  $08
	note as5 $08
	note a5  $08
	note g5  $40
	vibrato $01
	vol $3
	note g5  $20
	vibrato $e1
	duty $00
	vol $8
	note d5  $0a
	note ds5 $0b
	note f5  $0b
	note g5  $08
	rest $04
	vol $3
	note g5  $08
	rest $04
	vol $1
	note g5  $08
	vol $8
	note d5  $20
	vibrato $01
	vol $3
	note d5  $18
	vibrato $e1
	vol $8
	note g5  $04
	rest $04
	note g5  $08
	note a5  $08
	note as5 $08
	note c6  $08
	note a5  $08
	rest $04
	vol $3
	note a5  $08
	rest $04
	vol $8
	note f5  $08
	note c5  $20
	vol $3
	note c5  $10
	vol $8
	note c5  $08
	note d5  $08
	note f5  $08
	note ds5 $08
	note d5  $08
	note c5  $08
	note d5  $08
	rest $04
	vol $3
	note d5  $08
	rest $04
	vol $1
	note d5  $08
	vol $8
	note g4  $20
	vol $3
	note g4  $10
	vol $8
	note g4  $08
	note fs4 $08
	note g4  $08
	note a4  $08
	note as4 $08
	note c5  $08
	note d5  $40
	vibrato $01
	vol $3
	note d5  $10
	vibrato $e1
	vol $8
	note d5  $10
	note cs5 $10
	note d5  $08
	rest $04
	vol $3
	note d5  $04
	vol $8
	note as5 $08
	rest $04
	vol $3
	note as5 $08
	rest $04
	vol $8
	note a5  $08
	note g5  $20
	vol $1
	note g5  $0a
	vol $8
	note d5  $06
	rest $05
	note d5  $05
	rest $06
	note d5  $0a
	note as4 $0b
	note g5  $0b
	note gs5 $08
	rest $04
	vol $3
	note gs5 $08
	rest $04
	vol $8
	note as5 $08
	note c6  $20
	vol $3
	note c6  $0a
	vol $8
	note c6  $08
	rest $02
	note d6  $09
	rest $03
	note ds6 $0a
	note f6  $0b
	note ds6 $0b
	note d6  $2a
	rest $06
	note d6  $05
	rest $03
	note d6  $05
	rest $03
	note d6  $2a
	rest $06
	note d6  $05
	rest $03
	note d6  $05
	rest $03
	note d6  $10
	vol $3
	note d6  $10
	duty $02
	vol $8
	note e5  $05
	rest $05
	note e5  $06
	rest $05
	note e5  $05
	rest $06
	note f5  $1a
	rest $06
	note fs5 $05
	rest $05
	note fs5 $06
	rest $05
	note fs5 $05
	rest $06
	goto musicfaba1
	cmdff

sound29Channel0:
	vibrato $00
	env $0 $00
	duty $02
	vol $6
	note as3 $40
	note a3  $40
	note g3  $40
	note f3  $40
	note ds3 $20
	note g3  $08
	rest $02
	note g3  $08
	rest $02
	note g3  $09
	rest $03
	note d4  $20
	note ds3 $08
	rest $02
	note ds3 $08
	rest $02
	note ds3 $09
	rest $03
	note d3  $10
	note g3  $08
	note a3  $08
	note d4  $10
	note g3  $08
	note a3  $08
	note d3  $1d
	rest $03
	note d3  $08
	rest $02
	note d3  $08
	rest $02
	note d3  $09
	rest $03
musicfae87:
	vol $0
	note gs3 $15
	note b3  $05
	rest $02
	vol $3
	note b3  $04
	vol $6
	note b3  $08
	note c4  $08
	note b3  $08
	note a3  $08
	note b3  $40
	vol $6
	note f4  $10
	note g4  $10
	note a4  $10
	note b4  $10
	note c5  $10
	note b4  $08
	rest $04
	vol $3
	note b4  $04
	vol $6
	note b4  $0a
	note c5  $0b
	note d5  $0b
	note ds5 $10
	vol $3
	note ds5 $05
	vol $6
	note as4 $05
	rest $02
	vol $3
	note as4 $04
	vol $6
	note as4 $08
	note c5  $08
	note as4 $08
	note a4  $08
	note as4 $0a
	rest $02
	vol $3
	note as4 $04
	vol $6
	note as4 $10
	note a4  $10
	note g4  $10
	note a4  $08
	rest $04
	vol $3
	note a4  $08
	rest $04
	vol $6
	note g4  $08
	note f4  $08
	rest $02
	note f4  $0b
	note g4  $0b
	note gs4 $10
	note g4  $10
	note f4  $0a
	note ds4 $0b
	note d4  $0b
	note ds4 $20
	vol $3
	note ds4 $10
	vol $6
	note ds4 $08
	note f4  $08
	note g4  $08
	rest $04
	vol $3
	note g4  $04
	vol $6
	note g4  $10
	note f4  $10
	note ds4 $10
	note d4  $20
	vol $3
	note d4  $10
	vol $6
	note d4  $08
	note ds4 $08
	note f4  $0a
	rest $06
	note f4  $10
	note ds4 $10
	note d4  $10
	note cs4 $20
	vol $3
	note cs4 $10
	vol $6
	note cs4 $08
	note d4  $08
	note e4  $10
	note fs4 $10
	vol $6
	note g4  $10
	vol $6
	note a4  $10
	note as4 $20
	note a4  $08
	rest $04
	vol $3
	note a4  $08
	rest $04
	vol $1
	note a4  $08
	vol $6
	note as4 $20
	note a4  $08
	rest $04
	vol $3
	note a4  $08
	rest $04
	vol $1
	note a4  $08
	vol $6
	note g5  $40
	note d5  $20
	note c5  $20
	note b4  $10
	note g4  $08
	rest $04
	vol $3
	note g4  $04
	vol $6
	note g4  $08
	note a4  $08
	note b4  $08
	note c5  $08
	note d5  $10
	note b4  $08
	rest $04
	vol $3
	note b4  $04
	vol $6
	note b4  $0a
	note c5  $0b
	note d5  $0b
	note ds5 $20
	note as4 $10
	note g4  $10
	note ds4 $10
	note as4 $10
	note a4  $10
	note g4  $10
	note a4  $08
	rest $04
	vol $3
	note a4  $08
	rest $04
	vol $6
	note g4  $08
	note f4  $05
	rest $03
	note f4  $10
	note g4  $08
	note f4  $30
	vol $3
	note f4  $10
	vol $6
	note ds4 $20
	vol $3
	note ds4 $10
	vol $6
	note f4  $10
	note g4  $08
	rest $04
	vol $3
	note g4  $04
	vol $6
	note g4  $10
	note f4  $10
	note ds4 $10
	note d4  $20
	note e4  $20
	note fs4 $20
	note g4  $20
	note a4  $10
	note as4 $10
	note a4  $10
	note g4  $10
	note fs4 $10
	note ds5 $10
	note d5  $10
	note fs4 $10
	note as4 $10
	note c5  $10
	note as4 $10
	note a4  $10
	note g4  $08
	rest $04
	vol $3
	note g4  $04
	vol $6
	note g3  $08
	note a3  $08
	note as3 $08
	note c4  $08
	note d4  $05
	note ds4 $05
	note f4  $06
	note as4 $08
	rest $04
	vol $3
	note as4 $08
	rest $04
	vol $6
	note a4  $08
	note g4  $20
	vol $3
	note g4  $18
	vol $6
	note d4  $08
	note g4  $08
	note f4  $08
	note g4  $08
	note a4  $08
	note c5  $08
	rest $04
	vol $3
	note c5  $08
	rest $04
	vol $6
	note as4 $08
	note a4  $08
	note as4 $08
	note a4  $08
	note g4  $08
	note f4  $30
	vol $3
	note f4  $10
	vol $6
	note g4  $18
	vol $3
	note g4  $08
	vol $6
	note d4  $20
	note c4  $20
	note f4  $10
	note g4  $10
	note d4  $18
	vol $3
	note d4  $08
	vol $6
	note g4  $08
	note a4  $08
	note as4 $08
	note c5  $08
	note d5  $10
	note as4 $10
	note a4  $10
	note as4 $10
	note d5  $08
	rest $04
	vol $3
	note d5  $08
	rest $04
	vol $6
	note c5  $08
	note as4 $18
	vol $3
	note as4 $10
	rest $02
	vol $6
	note as4 $06
	rest $05
	note as4 $05
	rest $06
	note as4 $0a
	note g4  $0b
	note d4  $0b
	note c4  $08
	rest $04
	vol $3
	note c4  $08
	rest $01
	vol $6
	note gs3 $08
	rest $03
	note gs3 $0a
	note ds3 $0b
	note gs3 $0b
	note c4  $0a
	note gs3 $0b
	note c4  $0b
	note ds4 $0a
	note c4  $0b
	note ds4 $0b
	note d4  $10
	note g4  $08
	note a4  $08
	note d5  $10
	note g4  $08
	note a4  $08
	note d4  $10
	note g3  $08
	note a3  $08
	note d3  $10
	note g2  $08
	note a2  $08
	note d3  $04
	note e3  $04
	vol $6
	note fs3 $04
	note g3  $04
	note a3  $04
	note as3 $04
	note c4  $04
	note d4  $04
	note g4  $05
	rest $05
	note g4  $06
	rest $05
	note g4  $05
	rest $06
	note a4  $1a
	rest $06
	note as4 $05
	rest $05
	note as4 $06
	rest $05
	note as4 $05
	rest $06
	goto musicfae87
	cmdff

sound29Channel4:
	duty $0e
	rest $ff
	rest $ff
	rest $02
musicfb0de:
	duty $0e
	note g3  $80
	note f3  $80
	note ds3 $40
	note f3  $20
	note ds3 $20
	note d3  $40
	note g3  $40
	note c3  $30
	note g3  $10
	note c4  $30
	duty $17
	note c4  $10
	duty $0e
	note as2 $30
	note g3  $10
	note as3 $28
	duty $17
	note as3 $18
	duty $0e
	note a2  $20
	note b2  $20
	note c3  $20
	note cs3 $20
	note d3  $20
	rest $40
	note d2  $08
	rest $02
	note d2  $08
	rest $02
	note d2  $09
	rest $03
	note g2  $08
	duty $17
	note g2  $08
	duty $0e
	note g2  $18
	duty $17
	note g2  $08
	duty $0e
	note g2  $18
	duty $17
	note g2  $08
	duty $0e
	note g2  $18
	duty $17
	note g2  $08
	duty $0e
	note g2  $10
	duty $0e
	note f2  $08
	duty $17
	note f2  $08
	duty $0e
	note f2  $18
	duty $17
	note f2  $08
	duty $0e
	note f2  $18
	duty $17
	note f2  $08
	duty $0e
	note f2  $18
	duty $17
	note f2  $08
	duty $0e
	note f2  $10
	duty $0e
	note ds2 $08
	duty $17
	note ds2 $08
	duty $0e
	note ds2 $18
	duty $17
	note ds2 $08
	duty $0e
	note ds2 $10
	duty $0e
	note f2  $08
	duty $17
	note f2  $08
	duty $0e
	note f2  $1c
	duty $17
	note f2  $04
	duty $0e
	note ds2 $10
	duty $0e
	note d2  $08
	duty $17
	note d2  $08
	duty $0e
	note a2  $20
	note d3  $20
	note a2  $10
	note f2  $10
	note d2  $10
	note c2  $08
	note d2  $08
	note ds2 $18
	note d2  $08
	note ds2 $08
	note f2  $08
	note g2  $08
	note fs2 $08
	note g2  $08
	note a2  $08
	note as2 $08
	note c3  $08
	note as2 $08
	note a2  $08
	note g2  $10
	note gs2 $08
	note g2  $08
	note fs2 $10
	note g2  $08
	note fs2 $08
	note f2  $10
	note fs2 $08
	note f2  $08
	note e2  $10
	note f2  $08
	note e2  $08
	note ds2 $08
	duty $17
	note ds2 $08
	duty $0e
	note ds2 $1c
	duty $17
	note ds2 $04
	duty $0e
	note ds2 $05
	note f2  $05
	note ds2 $06
	duty $0e
	note d2  $14
	duty $17
	note d2  $0c
	duty $0e
	note d2  $08
	note a2  $08
	note d3  $08
	note d2  $08
	duty $0e
	note g2  $10
	duty $17
	note g2  $10
	duty $0e
	note g2  $08
	note a2  $08
	note g2  $08
	note fs2 $08
	note g2  $08
	note a2  $08
	note as2 $08
	note c3  $08
	note d3  $08
	note ds3 $08
	note f3  $08
	note g3  $08
	duty $0e
	note ds3 $20
	duty $17
	note ds3 $08
	duty $0e
	note as2 $08
	note ds3 $08
	note d3  $08
	note ds3 $10
	note as2 $10
	note a2  $10
	note g2  $10
	duty $0e
	note d2  $20
	duty $17
	note d2  $08
	duty $0e
	note f3  $04
	duty $17
	note f3  $04
	duty $0e
	note f3  $08
	note ds3 $08
	note d3  $20
	note d2  $20
	duty $0e
	note g2  $08
	duty $17
	note g2  $08
	duty $0e
	note g2  $1c
	duty $17
	note g2  $04
	duty $0e
	note g2  $10
	duty $0e
	note f2  $0c
	duty $17
	note f2  $04
	duty $0e
	note f2  $1c
	duty $17
	note f2  $04
	duty $0e
	note f2  $10
	duty $0e
	note e2  $08
	duty $17
	note e2  $08
	duty $0e
	note e2  $10
	duty $17
	note e2  $08
	duty $0e
	note e2  $08
	note f2  $08
	note e2  $08
	duty $0e
	note ds2 $1d
	duty $17
	note ds2 $03
	duty $0e
	note d2  $1d
	duty $17
	note d2  $03
	duty $0e
	note c2  $28
	note g2  $08
	note c3  $08
	note b2  $08
	note as2 $20
	note a2  $20
	note gs2 $0a
	note ds2 $0b
	note gs2 $0b
	note c3  $0a
	note gs2 $0b
	note c3  $0b
	note ds3 $0a
	note c3  $0b
	note ds3 $0b
	note gs3 $0a
	note ds3 $0b
	note gs3 $0b
	duty $0e
	note d3  $08
	duty $17
	note d3  $08
	duty $0e
	note d2  $18
	duty $17
	note d2  $08
	duty $0e
	note d2  $18
	duty $17
	note d2  $08
	duty $0e
	note d2  $18
	duty $17
	note d2  $08
	duty $0e
	note d2  $08
	duty $17
	note d2  $08
	duty $0e
	note d2  $20
	duty $0e
	note e2  $05
	duty $17
	note e2  $05
	duty $0e
	note e2  $06
	duty $17
	note e2  $05
	duty $0e
	note e2  $05
	duty $17
	note e2  $06
	duty $0e
	note f2  $1a
	duty $17
	note f2  $06
	duty $0e
	note fs2 $05
	duty $17
	note fs2 $05
	duty $0e
	note fs2 $06
	duty $17
	note fs2 $05
	duty $0e
	note fs2 $05
	duty $17
	note fs2 $06
	goto musicfb0de
	cmdff

sound29Channel6:
	vol $6
	note $26 $38
	vol $4
	note $26 $02
	vol $5
	note $26 $02
	vol $5
	note $26 $04
	vol $7
	note $26 $10
	vol $6
	note $26 $20
	note $26 $10
	note $26 $38
	vol $4
	note $26 $02
	vol $5
	note $26 $02
	vol $5
	note $26 $04
	vol $7
	note $26 $10
	vol $6
	note $26 $20
	note $26 $10
	vol $7
	note $26 $30
	vol $4
	note $26 $05
	vol $5
	note $26 $05
	vol $5
	note $26 $06
	vol $6
	note $26 $10
	vol $6
	note $26 $20
	note $26 $10
	note $26 $10
	vol $4
	note $26 $05
	vol $5
	note $26 $05
	vol $6
	note $26 $06
	vol $6
	note $26 $10
	vol $4
	note $26 $05
	vol $5
	note $26 $05
	vol $6
	note $26 $06
	vol $6
	note $26 $10
	vol $5
	note $26 $05
	vol $5
	note $26 $05
	vol $6
	note $26 $06
	vol $6
	note $26 $04
	vol $5
	note $26 $04
	vol $4
	note $26 $04
	vol $4
	note $26 $04
	note $26 $04
	vol $4
	note $26 $04
	vol $5
	note $26 $04
	vol $7
	note $26 $04
musicfb3a3:
	vol $6
	note $26 $18
	vol $5
	note $26 $08
	vol $6
	note $26 $10
	vol $5
	note $26 $08
	note $26 $08
	vol $6
	note $26 $10
	vol $5
	note $26 $10
	note $26 $10
	vol $5
	note $26 $05
	vol $5
	note $26 $05
	vol $6
	note $26 $06
	vol $6
	note $26 $20
	note $26 $20
	note $26 $10
	vol $5
	note $26 $20
	vol $5
	note $26 $05
	vol $5
	note $26 $05
	vol $6
	note $26 $06
	vol $6
	note $26 $18
	vol $5
	note $26 $08
	vol $6
	note $26 $10
	vol $5
	note $26 $08
	note $26 $08
	vol $6
	note $26 $10
	vol $5
	note $26 $10
	note $26 $10
	vol $5
	note $26 $05
	vol $5
	note $26 $05
	vol $6
	note $26 $06
	vol $6
	note $26 $10
	vol $4
	note $26 $05
	vol $4
	note $26 $05
	vol $5
	note $26 $06
	vol $6
	note $26 $10
	vol $5
	note $26 $05
	vol $6
	note $26 $05
	vol $6
	note $26 $06
	vol $6
	note $26 $10
	vol $5
	note $26 $10
	note $26 $10
	vol $5
	note $26 $05
	vol $5
	note $26 $05
	vol $6
	note $26 $06
	vol $6
	note $26 $18
	vol $5
	note $26 $08
	vol $6
	note $26 $10
	vol $5
	note $26 $08
	note $26 $08
	vol $6
	note $26 $10
	vol $5
	note $26 $10
	note $26 $10
	vol $5
	note $26 $05
	vol $5
	note $26 $05
	vol $6
	note $26 $06
	vol $6
	note $26 $20
	note $26 $20
	note $26 $10
	vol $5
	note $26 $20
	vol $5
	note $26 $05
	vol $5
	note $26 $05
	vol $6
	note $26 $06
	vol $6
	note $26 $18
	vol $5
	note $26 $08
	vol $6
	note $26 $10
	vol $5
	note $26 $08
	note $26 $08
	vol $6
	note $26 $10
	vol $5
	note $26 $10
	note $26 $10
	vol $5
	note $26 $05
	vol $5
	note $26 $05
	vol $6
	note $26 $06
	vol $6
	note $26 $10
	vol $4
	note $26 $05
	vol $4
	note $26 $05
	vol $5
	note $26 $06
	vol $6
	note $26 $10
	vol $5
	note $26 $05
	vol $6
	note $26 $05
	vol $6
	note $26 $06
	vol $6
	note $26 $10
	vol $5
	note $26 $10
	note $26 $10
	vol $5
	note $26 $05
	vol $5
	note $26 $05
	vol $6
	note $26 $06
	vol $6
	note $26 $10
	vol $5
	note $26 $08
	note $26 $08
	vol $6
	note $26 $10
	vol $5
	note $26 $08
	note $26 $08
	vol $6
	note $26 $10
	vol $5
	note $26 $10
	note $26 $10
	vol $5
	note $26 $05
	vol $5
	note $26 $05
	vol $6
	note $26 $06
	vol $6
	note $26 $10
	vol $5
	note $26 $08
	note $26 $08
	vol $6
	note $26 $10
	vol $5
	note $26 $08
	note $26 $08
	vol $6
	note $26 $10
	vol $5
	note $26 $10
	note $26 $10
	vol $5
	note $26 $05
	vol $5
	note $26 $05
	vol $6
	note $26 $06
	vol $6
	note $26 $10
	vol $5
	note $26 $08
	note $26 $08
	vol $6
	note $26 $10
	vol $5
	note $26 $08
	note $26 $08
	vol $6
	note $26 $10
	vol $5
	note $26 $10
	note $26 $10
	vol $5
	note $26 $05
	vol $5
	note $26 $05
	vol $6
	note $26 $06
	vol $6
	note $26 $10
	vol $5
	note $26 $08
	note $26 $08
	vol $6
	note $26 $10
	vol $5
	note $26 $08
	note $26 $08
	vol $6
	note $26 $10
	vol $5
	note $26 $10
	note $26 $10
	vol $5
	note $26 $05
	vol $5
	note $26 $05
	vol $6
	note $26 $06
	vol $6
	note $26 $10
	vol $5
	note $26 $08
	note $26 $08
	vol $6
	note $26 $10
	vol $5
	note $26 $08
	note $26 $08
	vol $6
	note $26 $10
	vol $5
	note $26 $10
	note $26 $10
	vol $5
	note $26 $05
	vol $5
	note $26 $05
	vol $6
	note $26 $06
	vol $6
	note $26 $10
	vol $5
	note $26 $08
	note $26 $08
	vol $6
	note $26 $10
	vol $5
	note $26 $08
	note $26 $08
	vol $6
	note $26 $10
	vol $5
	note $26 $10
	note $26 $10
	vol $5
	note $26 $05
	vol $5
	note $26 $05
	vol $6
	note $26 $06
	vol $6
	note $26 $10
	vol $5
	note $26 $08
	note $26 $08
	vol $6
	note $26 $10
	vol $5
	note $26 $08
	note $26 $08
	vol $6
	note $26 $10
	vol $5
	note $26 $10
	note $26 $10
	vol $5
	note $26 $05
	vol $5
	note $26 $05
	vol $6
	note $26 $06
	vol $6
	note $26 $10
	note $26 $08
	note $26 $08
	note $26 $10
	note $26 $08
	note $26 $08
	note $26 $20
	note $26 $05
	vol $5
	note $26 $05
	vol $4
	note $26 $06
	vol $4
	note $26 $05
	vol $4
	note $26 $05
	vol $6
	note $26 $06
	vol $6
	note $26 $10
	vol $5
	note $26 $08
	note $26 $08
	vol $6
	note $26 $10
	vol $5
	note $26 $08
	note $26 $08
	vol $6
	note $26 $10
	vol $5
	note $26 $20
	vol $6
	note $26 $05
	note $26 $05
	note $26 $06
	note $26 $10
	vol $5
	note $26 $08
	note $26 $08
	vol $6
	note $26 $10
	vol $5
	note $26 $08
	note $26 $08
	vol $6
	note $26 $10
	vol $5
	note $26 $20
	vol $6
	note $26 $05
	note $26 $05
	note $26 $06
	note $26 $10
	vol $5
	note $26 $08
	note $26 $08
	vol $6
	note $26 $10
	vol $5
	note $26 $08
	note $26 $08
	vol $6
	note $26 $10
	vol $5
	note $26 $20
	vol $6
	note $26 $05
	note $26 $05
	note $26 $06
	note $26 $10
	vol $5
	note $26 $08
	note $26 $08
	vol $6
	note $26 $10
	vol $5
	note $26 $08
	note $26 $08
	vol $6
	note $26 $10
	vol $5
	note $26 $20
	vol $6
	note $26 $05
	note $26 $05
	note $26 $06
	note $26 $10
	vol $5
	note $26 $08
	note $26 $08
	vol $6
	note $26 $10
	vol $5
	note $26 $08
	note $26 $08
	vol $6
	note $26 $10
	vol $5
	note $26 $20
	vol $6
	note $26 $05
	note $26 $05
	note $26 $06
	note $26 $10
	vol $5
	note $26 $08
	note $26 $08
	vol $6
	note $26 $10
	vol $5
	note $26 $08
	note $26 $08
	vol $6
	note $26 $10
	vol $5
	note $26 $20
	vol $6
	note $26 $05
	note $26 $05
	note $26 $06
	note $26 $10
	vol $4
	note $26 $04
	vol $5
	note $26 $04
	vol $5
	note $26 $04
	vol $6
	note $26 $04
	vol $6
	note $26 $10
	vol $5
	note $26 $04
	vol $5
	note $26 $04
	vol $6
	note $26 $04
	vol $6
	note $26 $04
	vol $6
	note $26 $10
	vol $5
	note $26 $04
	vol $5
	note $26 $04
	vol $6
	note $26 $04
	vol $6
	note $26 $04
	vol $6
	note $26 $10
	note $26 $10
	note $26 $20
	note $26 $04
	vol $6
	note $26 $04
	vol $5
	note $26 $04
	vol $5
	note $26 $04
	note $26 $04
	vol $5
	note $26 $04
	vol $6
	note $26 $04
	vol $6
	note $26 $04
	vol $6
	note $26 $20
	note $26 $0a
	note $26 $0b
	note $26 $0b
	goto musicfb3a3
	cmdff

sound25Channel1:
	vibrato $e1
	env $0 $00
	duty $01
musicfb6a3:
	vol $6
	note f4  $16
	note as4 $16
	note c5  $16
	note ds5 $16
	note d5  $2c
	note g5  $2c
	duty $02
	note f5  $07
	rest $04
	vol $5
	note f5  $03
	rest $03
	vol $4
	note f5  $05
	rest $03
	vol $3
	note f5  $03
	rest $05
	vol $2
	note f5  $03
	rest $08
	vol $5
	note c6  $03
	rest $03
	vol $4
	note c6  $05
	rest $03
	vol $3
	note c6  $03
	rest $05
	vol $2
	note c6  $03
	rest $13
	vol $5
	note ds6 $03
	rest $03
	vol $4
	note ds6 $05
	rest $03
	vol $3
	note ds6 $03
	rest $05
	vol $2
	note ds6 $03
	rest $13
	vol $5
	note g6  $03
	rest $03
	vol $4
	note g6  $05
	rest $03
	vol $3
	note g6  $03
	rest $05
	vol $2
	note g6  $03
	rest $13
	duty $01
	vol $6
	note ds6 $16
	note f6  $0b
	note g6  $0b
	note gs6 $16
	note g6  $0b
	note f6  $0b
	note ds6 $2c
	note f6  $0b
	rest $05
	vol $3
	note f6  $06
	vol $6
	note c6  $0b
	rest $05
	vol $3
	note c6  $06
	vol $6
	note f4  $16
	note as3 $0b
	note cs4 $0b
	note ds4 $21
	vol $3
	note ds4 $0b
	vol $6
	note as4 $21
	note gs4 $0b
	note f4  $0b
	rest $05
	vol $3
	note f4  $06
	vol $6
	note gs4 $0b
	rest $05
	vol $3
	note gs4 $06
	vol $6
	note as4 $2c
	note c5  $0b
	rest $05
	vol $3
	note c5  $06
	vol $6
	note ds5 $0b
	rest $05
	vol $3
	note ds5 $06
	vol $6
	note c5  $21
	note ds5 $0b
	note f5  $0b
	rest $05
	vol $3
	note f5  $0b
	rest $06
	vol $2
	note f5  $0b
	rest $16
	duty $02
	vol $6
	note e5  $03
	rest $03
	vol $5
	note e5  $05
	rest $03
	vol $3
	note e5  $03
	rest $05
	vol $6
	note ds6 $03
	rest $03
	vol $5
	note e6  $05
	rest $03
	vol $4
	note e6  $03
	rest $05
	vol $4
	note e6  $03
	rest $29
	vol $6
	note e5  $03
	rest $03
	vol $5
	note e5  $05
	rest $03
	vol $3
	note e5  $03
	rest $05
	vol $6
	note ds6 $03
	rest $03
	vol $5
	note e6  $05
	rest $03
	vol $4
	note e6  $03
	rest $05
	vol $3
	note e6  $03
	rest $29
	vol $6
	note f5  $03
	rest $03
	vol $5
	note f5  $05
	rest $03
	vol $3
	note f5  $03
	rest $05
	vol $6
	note e6  $03
	rest $03
	vol $5
	note f6  $05
	rest $03
	vol $4
	note f6  $03
	rest $05
	vol $4
	note f6  $03
	rest $29
	vol $6
	note f5  $03
	rest $03
	vol $5
	note f5  $05
	rest $03
	vol $3
	note f5  $03
	rest $05
	vol $6
	note e6  $03
	rest $03
	vol $5
	note f6  $05
	rest $03
	vol $4
	note f6  $03
	rest $05
	vol $3
	note f6  $03
	rest $13
	duty $01
	vol $6
	note c3  $2c
	note d3  $16
	note e3  $16
	note g3  $2c
	note f3  $16
	note ds3 $16
	rest $16
	duty $02
	note a5  $03
	rest $03
	vol $5
	note a5  $05
	rest $03
	vol $3
	note a5  $03
	rest $05
	vol $6
	note gs6 $03
	rest $03
	vol $5
	note a6  $05
	rest $03
	vol $4
	note a6  $03
	rest $05
	vol $4
	note a6  $03
	rest $29
	vol $6
	note c6  $03
	rest $03
	vol $5
	note c6  $05
	rest $03
	vol $3
	note c6  $03
	rest $05
	vol $6
	note b6  $03
	rest $03
	vol $5
	note c7  $05
	rest $03
	vol $4
	note c7  $03
	rest $05
	vol $3
	note c7  $03
	rest $13
	duty $01
	goto musicfb6a3
	cmdff

sound25Channel0:
	vibrato $e1
	env $0 $00
	duty $02
musicfb85d:
	vol $0
	note gs3 $16
	vol $6
	note c5  $03
	rest $03
	vol $5
	note c5  $05
	rest $03
	vol $3
	note c5  $03
	rest $05
	vol $6
	note b5  $03
	rest $03
	vol $5
	note c6  $05
	rest $03
	vol $4
	note c6  $03
	rest $05
	vol $4
	note c6  $03
	rest $29
	vol $6
	note c5  $03
	rest $03
	vol $5
	note c5  $05
	rest $03
	vol $3
	note c5  $03
	rest $05
	vol $6
	note b5  $03
	rest $03
	vol $5
	note c6  $05
	rest $03
	vol $4
	note c6  $03
	rest $05
	vol $3
	note c6  $03
	rest $13
	duty $01
	vol $4
	note c3  $16
	note ds3 $16
	note f3  $16
	note gs3 $16
	note as3 $2c
	note g3  $16
	duty $02
	note c5  $03
	rest $03
	vol $3
	note c5  $05
	rest $03
	vol $2
	note c5  $03
	rest $1b
	vol $6
	note as4 $03
	rest $03
	vol $5
	note as4 $05
	rest $03
	vol $3
	note as4 $03
	rest $05
	vol $6
	note gs5 $03
	rest $03
	vol $5
	note as5 $05
	rest $03
	vol $4
	note as5 $03
	rest $05
	vol $4
	note as5 $03
	rest $29
	vol $6
	note as4 $03
	rest $03
	vol $5
	note as4 $05
	rest $03
	vol $3
	note as4 $03
	rest $05
	vol $6
	note gs5 $03
	rest $03
	vol $5
	note as5 $05
	rest $03
	vol $4
	note as5 $03
	rest $05
	vol $3
	note as5 $03
	rest $29
	vol $6
	note as4 $03
	rest $03
	vol $5
	note as4 $05
	rest $03
	vol $3
	note as4 $03
	rest $05
	vol $6
	note a5  $03
	rest $03
	vol $5
	note as5 $05
	rest $03
	vol $4
	note as5 $03
	rest $05
	vol $4
	note as5 $03
	rest $29
	vol $6
	note as4 $03
	rest $03
	vol $5
	note as4 $05
	rest $03
	vol $3
	note as4 $03
	rest $05
	vol $6
	note a5  $03
	rest $03
	vol $5
	note as5 $05
	rest $03
	vol $4
	note as5 $03
	rest $05
	vol $3
	note as5 $03
	rest $29
	vol $6
	note c5  $03
	rest $03
	vol $5
	note c5  $05
	rest $03
	vol $3
	note c5  $03
	rest $05
	vol $6
	note b5  $03
	rest $03
	vol $5
	note c6  $05
	rest $03
	vol $4
	note c6  $03
	rest $05
	vol $4
	note c6  $03
	rest $29
	vol $6
	note c5  $03
	rest $03
	vol $5
	note c5  $05
	rest $03
	vol $3
	note c5  $03
	rest $05
	vol $6
	note b5  $03
	rest $03
	vol $5
	note c6  $05
	rest $03
	vol $4
	note c6  $03
	rest $05
	vol $3
	note c6  $03
	rest $13
	duty $01
	vol $6
	note c4  $2c
	note ds4 $2c
	note f4  $16
	note g4  $0b
	note gs4 $0b
	note a4  $16
	duty $02
	vol $4
	note c5  $03
	rest $03
	vol $3
	note c5  $05
	rest $03
	vol $2
	note c5  $03
	rest $05
	duty $01
	vol $6
	note f3  $21
	note g3  $0b
	vol $6
	note a3  $16
	note as3 $16
	note c4  $16
	vol $6
	note d4  $0b
	vol $6
	note e4  $0b
	note f4  $0b
	rest $03
	vol $3
	note f4  $03
	rest $08
	vol $2
	note f4  $03
	rest $26
	duty $02
	vol $6
	note c5  $03
	rest $03
	vol $5
	note c5  $05
	rest $03
	vol $3
	note c5  $03
	rest $05
	vol $6
	note b5  $03
	rest $03
	vol $5
	note c6  $05
	rest $03
	vol $4
	note c6  $03
	rest $05
	vol $4
	note c6  $03
	rest $29
	vol $6
	note c5  $03
	rest $03
	vol $5
	note c5  $05
	rest $03
	vol $3
	note c5  $03
	rest $05
	vol $6
	note b5  $03
	rest $03
	vol $5
	note c6  $05
	rest $03
	vol $4
	note c6  $03
	rest $05
	vol $3
	note c6  $03
	rest $29
	vol $6
	note f5  $03
	rest $03
	vol $5
	note f5  $05
	rest $03
	vol $3
	note f5  $03
	rest $05
	vol $6
	note e6  $03
	rest $03
	vol $5
	note f6  $05
	rest $03
	vol $4
	note f6  $03
	rest $05
	vol $4
	note f6  $03
	rest $29
	vol $6
	note f5  $03
	rest $03
	vol $5
	note f5  $05
	rest $03
	vol $3
	note f5  $03
	rest $05
	vol $6
	note e6  $03
	rest $03
	vol $5
	note f6  $05
	rest $03
	vol $4
	note f6  $03
	rest $05
	vol $3
	note f6  $03
	rest $13
	goto musicfb85d
	cmdff

sound25Channel4:
musicfba6b:
	duty $0e
	note f3  $2c
	note as3 $16
	note c4  $16
	note ds4 $2c
	note d4  $16
	note c4  $16
	note f3  $16
	note as3 $16
	note c4  $16
	note ds4 $16
	note d4  $2c
	note as3 $16
	note g3  $16
	note ds3 $2c
	note gs3 $16
	note as3 $16
	note cs4 $2c
	note c4  $16
	note as3 $16
	note ds3 $2c
	note as3 $2c
	note cs4 $2c
	note c4  $16
	note as3 $16
	note f3  $2c
	note as3 $2c
	note c4  $19
	note as3 $03
	note a3  $05
	note gs3 $03
	note g3  $03
	note fs3 $05
	note f3  $0b
	rest $21
	note a5  $21
	note g5  $0b
	note c5  $16
	note ds5 $16
	note f5  $16
	note a5  $16
	note g5  $0b
	duty $0f
	note g5  $07
	rest $1a
	duty $0e
	note a3  $21
	note g3  $0b
	note f3  $0b
	duty $0f
	note f3  $0b
	duty $0e
	note c3  $0b
	duty $0f
	note c3  $0b
	duty $0e
	note ds3 $2c
	note f3  $0b
	duty $0f
	note f3  $07
	duty $0e
	note b2  $04
	note c3  $07
	rest $0f
	note f3  $2c
	note as3 $16
	note c4  $16
	note ds4 $2c
	note d4  $16
	note c4  $10
	rest $06
	note f3  $16
	duty $0f
	note f3  $16
	duty $0e
	note c4  $16
	duty $0f
	note c4  $16
	duty $0e
	note c3  $16
	duty $0f
	note c3  $16
	duty $0e
	note c4  $16
	duty $0f
	note c4  $16
	goto musicfba6b
	cmdff

sound0cChannel1:
	vibrato $00
	env $0 $00
	duty $02
musicfbb21:
	vol $6
	note a5  $0b
	vol $3
	note a5  $0b
	vol $6
	note fs5 $0b
	vol $3
	note fs5 $0b
	vol $6
	note a5  $0b
	vol $3
	note a5  $0b
	vol $6
	note fs5 $0b
	vol $3
	note fs5 $0b
	vol $6
	note b5  $0b
	rest $0b
	note gs5 $0b
	rest $03
	vol $3
	note gs5 $05
	rest $06
	vol $2
	note gs5 $05
	rest $06
	vol $1
	note gs5 $05
	rest $19
	vol $6
	note g5  $0b
	vol $3
	note e5  $0b
	vol $6
	note e5  $0b
	vol $3
	note e5  $0b
	vol $6
	note a5  $0b
	vol $3
	note a5  $0b
	vol $6
	note fs5 $0b
	vol $4
	note fs5 $05
	rest $06
	vol $3
	note fs5 $05
	rest $06
	vol $3
	note fs5 $05
	rest $48
	vol $6
	note f5  $0b
	vol $3
	note f5  $0b
	vol $6
	note d5  $0b
	vol $3
	note d5  $0b
	vol $6
	note f5  $0b
	vol $3
	note f5  $0b
	vol $6
	note d5  $0b
	vol $3
	note d5  $0b
	rest $0b
	vol $6
	note e5  $0b
	note f5  $0b
	note g5  $0b
	rest $07
	vol $3
	note g5  $05
	rest $05
	vol $3
	note g5  $06
	rest $05
	vol $1
	note g5  $06
	rest $0a
	vol $6
	note b5  $07
	rest $04
	vol $3
	note b5  $07
	rest $04
	vol $6
	note a5  $07
	rest $04
	vol $3
	note a5  $07
	rest $04
	vol $6
	note b5  $07
	rest $04
	vol $3
	note b5  $07
	rest $04
	vol $6
	note a5  $07
	rest $04
	vol $3
	note a5  $07
	rest $04
	vol $6
	note gs5 $05
	rest $09
	vol $4
	note gs5 $03
	rest $08
	vol $3
	note gs5 $03
	rest $08
	vol $2
	note gs5 $03
	rest $05
	vol $6
	note g5  $05
	rest $09
	vol $3
	note g5  $03
	rest $08
	vol $2
	note g5  $03
	rest $08
	vol $1
	note g5  $03
	rest $05
	vol $7
	note b5  $0b
	rest $05
	vol $3
	note b5  $06
	vol $6
	note d6  $0b
	rest $05
	vol $3
	note d6  $06
	vol $6
	note e6  $0b
	rest $05
	vol $3
	note e6  $06
	vol $6
	note cs6 $0b
	rest $05
	vol $3
	note cs6 $06
	vol $6
	note e5  $07
	rest $07
	vol $3
	note e5  $01
	rest $0a
	vol $2
	note e5  $05
	rest $0e
	vol $6
	note cs5 $07
	rest $07
	vol $3
	note cs5 $01
	rest $1d
	vol $6
	note a5  $0b
	rest $05
	vol $3
	note a5  $06
	vol $6
	note b5  $0b
	rest $05
	vol $3
	note b5  $06
	vol $6
	note d6  $0b
	rest $05
	vol $3
	note d6  $06
	vol $6
	note cs6 $0b
	rest $05
	vol $3
	note cs6 $06
	vol $6
	note b5  $0b
	rest $03
	vol $2
	note b5  $05
	rest $06
	vol $1
	note b5  $05
	rest $3a
	vol $6
	note g5  $0b
	rest $05
	vol $3
	note g5  $06
	vol $6
	note a5  $0b
	rest $05
	vol $3
	note a5  $06
	vol $6
	note b5  $0b
	rest $05
	vol $3
	note b5  $06
	rest $05
	vol $2
	note b5  $06
	rest $0b
	vol $6
	note a5  $0b
	rest $05
	vol $3
	note a5  $06
	vol $6
	note e5  $0b
	rest $05
	vol $3
	note e5  $06
	vol $6
	note d6  $0b
	rest $05
	vol $3
	note d6  $06
	rest $0b
	vol $6
	note cs6 $05
	note c6  $06
	vol $6
	note b5  $6e
	rest $42
	goto musicfbb21
	cmdff

sound0cChannel0:
	vibrato $00
	env $0 $00
	duty $02
musicfbcac:
	rest $0b
	vol $6
	note d5  $0b
	rest $05
	vol $3
	note d5  $06
	vol $6
	note d5  $0b
	rest $0b
	note d5  $0b
	rest $05
	vol $3
	note d5  $06
	vol $6
	note d5  $0b
	rest $0b
	note d5  $0b
	rest $05
	vol $4
	note d5  $06
	rest $03
	vol $3
	note d5  $05
	rest $06
	vol $2
	note d5  $05
	rest $2f
	vol $6
	note c5  $0b
	rest $07
	vol $3
	note c5  $06
	vol $6
	note c5  $0b
	rest $05
	vol $3
	note c5  $04
	vol $6
	note d5  $0b
	rest $05
	vol $3
	note d5  $06
	vol $6
	note d5  $0b
	rest $05
	vol $3
	note d5  $06
	rest $05
	vol $3
	note d5  $06
	rest $05
	vol $2
	note d5  $06
	rest $42
	vol $6
	note c5  $0b
	rest $07
	vol $3
	note c5  $06
	vol $6
	note c5  $0b
	rest $03
	vol $3
	note c5  $06
	vol $6
	note c5  $0b
	rest $05
	vol $3
	note c5  $06
	vol $6
	note c5  $0b
	rest $05
	vol $4
	note c5  $06
	rest $05
	vol $3
	note c5  $06
	rest $05
	vol $2
	note c5  $06
	rest $0b
	vol $6
	note d6  $0b
	note e6  $0b
	note f6  $0b
	note g6  $0b
	rest $03
	vol $4
	note g6  $05
	rest $06
	vol $2
	note g6  $05
	rest $19
	vol $6
	note g5  $0b
	rest $03
	vol $4
	note g5  $05
	rest $19
	vol $6
	note c6  $05
	rest $06
	note c6  $05
	rest $06
	vol $4
	note c6  $05
	rest $06
	vol $2
	note c6  $05
	rest $06
	vol $6
	note b5  $05
	rest $06
	note b5  $05
	rest $06
	vol $4
	note b5  $05
	rest $06
	vol $2
	note b5  $05
	rest $11
	vol $6
	note b4  $0b
	rest $03
	vol $3
	note b4  $05
	rest $03
	vol $6
	note d5  $0b
	rest $03
	vol $3
	note d5  $05
	rest $03
	vol $6
	note e5  $0b
	rest $03
	vol $3
	note e5  $05
	rest $03
	vol $6
	note cs5 $0b
	rest $03
	vol $3
	note cs5 $05
	rest $03
	vol $6
	note b6  $03
	rest $03
	vol $2
	note b6  $05
	vol $6
	note g6  $07
	rest $04
	vol $3
	note g6  $05
	rest $11
	vol $6
	note b6  $03
	rest $03
	vol $3
	note b6  $05
	vol $6
	note g6  $07
	rest $04
	vol $3
	note g6  $05
	rest $11
	vol $6
	note fs5 $0b
	rest $03
	vol $3
	note fs5 $05
	rest $03
	vol $6
	note e5  $0b
	rest $05
	vol $3
	note e5  $06
	vol $6
	note g5  $0b
	rest $05
	vol $3
	note g5  $06
	vol $6
	note a5  $0b
	rest $03
	vol $3
	note a5  $05
	rest $03
	vol $6
	note fs5 $03
	rest $03
	vol $6
	note fs5 $05
	vol $6
	note d5  $03
	rest $03
	vol $6
	note d5  $05
	vol $5
	note fs5 $05
	rest $01
	vol $3
	note fs5 $05
	vol $6
	note cs5 $03
	rest $03
	vol $3
	note cs5 $05
	vol $7
	note fs5 $05
	rest $01
	vol $3
	note fs5 $05
	vol $6
	note b4  $03
	rest $03
	vol $3
	note b4  $05
	vol $6
	note fs5 $05
	rest $01
	vol $3
	note fs5 $05
	rest $0b
	vol $6
	note e5  $0b
	note fs5 $03
	rest $03
	vol $3
	note fs5 $05
	vol $6
	note e5  $03
	rest $03
	vol $3
	note e5  $05
	vol $4
	note e5  $0b
	vol $6
	note fs5 $0b
	note e5  $0b
	note b4  $0b
	rest $05
	vol $3
	note b4  $06
	vol $6
	note d5  $0b
	rest $05
	vol $3
	note d5  $06
	vol $6
	note a4  $0b
	rest $05
	vol $3
	note a4  $06
	vol $6
	note e5  $07
	vol $4
	note e5  $04
	vol $5
	note a4  $07
	note a4  $04
	rest $07
	vol $2
	note cs5 $03
	rest $01
	vol $7
	note gs4 $05
	rest $06
	vol $3
	note gs4 $05
	rest $06
	vol $6
	note cs5 $05
	rest $06
	vol $3
	note cs5 $05
	rest $06
	vol $7
	note gs5 $05
	rest $06
	vol $3
	note gs5 $05
	rest $06
	vol $7
	note cs5 $05
	rest $06
	vol $3
	note cs5 $05
	rest $06
	vol $7
	note gs5 $05
	rest $06
	vol $3
	note gs5 $05
	rest $06
	vol $6
	note cs6 $05
	rest $06
	vol $3
	note cs6 $05
	rest $06
	vol $6
	note gs6 $05
	rest $06
	vol $3
	note gs6 $05
	rest $06
	vol $7
	note cs6 $05
	rest $06
	vol $3
	note cs6 $05
	rest $06
	goto musicfbcac
	cmdff

sound60Start:

sound60Channel2:
	duty $02
	vol $b
	note b5  $02
	vol $0
	rest $02
	vol $d
	note b6  $04
	vol $9
	note b5  $02
	vol $0
	rest $02
	vol $6
	note b6  $03
	cmdff

sound61Start:

sound61Channel2:
	duty $00
	env $0 $03
	vol $d
	note gs7 $02
	vol $0
	rest $01
	vol $f
	note e8  $02
	vol $9
	note gs7 $02
	vol $7
	note e8  $03
	vol $4
	note gs7 $02
	vol $2
	note e8  $03
	cmdff

sound6bStart:

sound6bChannel7:
	cmdf0 $40
	note $07 $01
	cmdf0 $50
	note $14 $02
	cmdf0 $60
	note $16 $02
	cmdf0 $70
	note $24 $02
	cmdf0 $80
	note $26 $02
	cmdf0 $90
	note $34 $02
	cmdf0 $a0
	note $35 $02
	cmdf0 $b0
	note $36 $02
	cmdf0 $b0
	note $37 $02
	cmdf0 $a0
	note $36 $02
	cmdf0 $90
	note $35 $02
	cmdf0 $80
	note $34 $02
	cmdf0 $70
	note $26 $02
	cmdf0 $60
	note $24 $02
	cmdf0 $50
	note $16 $02
	cmdf0 $40
	note $14 $02
	cmdf0 $30
	note $07 $01
	cmdff

sound6cStart:

sound6cChannel7:
	cmdf0 $f0
	note $37 $01
	cmdf0 $f0
	note $64 $02
	cmdf0 $00
	note $00 $04
	cmdf0 $f0
	note $44 $01
	cmdf0 $b0
	note $44 $02
	cmdff

sound6dStart:

sound6dChannel7:
	cmdf0 $60
	note $34 $04
	cmdf0 $00
	note $00 $02
	cmdf0 $50
	note $06 $04
	cmdf0 $00
	note $00 $02
	cmdf0 $40
	note $06 $04
	cmdf0 $00
	note $00 $02
	cmdf0 $30
	note $06 $04
	cmdf0 $00
	note $00 $02
	cmdf0 $20
	note $06 $04
	cmdff

sound6eStart:

sound6eChannel7:
	cmdf0 $71
	note $24 $04
	cmdf0 $00
	note $00 $08
	cmdf0 $61
	note $25 $04
	cmdf0 $00
	note $00 $08
	cmdf0 $42
	note $27 $04
	cmdf0 $00
	note $00 $08
	cmdf0 $24
	note $34 $04
	cmdff

sound79Start:

sound79Channel7:
	cmdf0 $c0
	note $24 $03
	note $25 $01
	note $26 $01
	note $34 $01
	note $36 $01
	note $37 $01
	note $44 $02
	note $45 $02
	note $46 $02
	note $47 $02
	note $54 $02
	note $55 $02
	note $56 $02
	note $57 $02
	note $56 $02
	note $54 $02
	note $46 $02
	note $44 $02
	note $45 $02
	note $46 $02
	note $47 $02
	note $54 $02
	note $55 $02
	note $56 $02
	note $57 $02
	note $64 $02
	note $65 $02
	note $66 $02
	note $67 $02
	note $74 $02
	note $67 $01
	cmdf0 $c7
	note $66 $04
	note $64 $06
	note $66 $06
	note $74 $46
	cmdff

sound78Start:

sound78Channel7:
	cmdf0 $20
	note $16 $02
	cmdf0 $50
	note $25 $01
	cmdf0 $80
	note $34 $01
	cmdf0 $c0
	note $37 $01
	cmdf0 $f0
	note $44 $01
	cmdff

sound77Start:

sound77Channel2:
	duty $00
	vol $d
	cmdf8 $00
	env $0 $01
	note c7  $0f
	vol $6
	env $0 $02
	note c7  $0f
	cmdff

sound66Start:

sound66Channel2:
	duty $02
	vol $2
	note f6  $02
	duty $02
	vol $b
	note f6  $01
	cmdff
