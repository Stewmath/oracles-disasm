sounddeStart:
; @addr{e5a86}
sounddeChannel0:
sounddeChannel1:
sounddeChannel4:
sounddeChannel6:
	cmdff
; $e5a87
sound06Start:
sound97Start:
soundadStart:
soundb6Start:
; @addr{e5a87}
sound06Channel6:
sound97Channel2:
sound97Channel7:
soundadChannel2:
soundadChannel7:
soundb6Channel2:
soundb6Channel7:
	cmdff
; $e5a88
sound91Start:
; @addr{e5a88}
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
; $e5b27
; GAP
	cmdff
sound99Start:
; @addr{e5b28}
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
; $e5b71
; GAP
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
sounda4Start:
; @addr{e5b7d}
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
; $e5bb4
; @addr{e5bb4}
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
; $e5bcb
sounda5Start:
; @addr{e5bcb}
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
; $e5bf8
soundaaStart:
; @addr{e5bf8}
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
; $e5c1d
soundabStart:
; @addr{e5c1d}
soundabChannel2:
	cmdf0 $00
	vol $0
	.db $00 $00 $09
	vol $6
	env $0 $07
	.db $07 $c0 $55
	cmdff
; $e5c2a
; @addr{e5c2a}
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
; $e5c3f
; GAP
	cmdff
soundafStart:
; @addr{e5c40}
soundafChannel2:
	vol $9
	note $41 $01
	note $3c $01
	cmdff
; $e5c46
sound8aStart:
; @addr{e5c46}
sound8aChannel2:
	duty $02
	vol $d
	note $39 $01
	note $3d $01
	vol $b
	note $3a $01
	note $3e $01
	vol $9
	note $3b $01
	note $3c $01
	note $40 $01
	note $3d $01
	note $41 $01
	note $3e $01
	note $3f $01
	note $43 $01
	note $40 $01
	note $44 $01
	note $41 $01
	note $42 $01
	note $46 $01
	note $43 $01
	note $47 $01
	note $44 $01
	note $45 $01
	note $49 $01
	note $46 $01
	note $4a $01
	note $47 $01
	vol $b
	note $4c $02
	vol $8
	note $39 $01
	note $3d $01
	note $3a $01
	note $3e $01
	note $3b $01
	note $3c $01
	note $40 $01
	vol $7
	note $3d $01
	note $41 $01
	note $3e $01
	note $3f $01
	note $43 $01
	note $40 $01
	note $44 $01
	vol $6
	note $41 $01
	note $42 $01
	note $46 $01
	note $43 $01
	note $47 $01
	note $44 $01
	vol $5
	note $45 $01
	note $49 $01
	note $46 $01
	note $4a $01
	note $47 $01
	vol $9
	note $4c $02
	vol $5
	note $39 $01
	note $3d $01
	vol $4
	note $3a $01
	note $3e $01
	note $3b $01
	note $3c $01
	note $40 $01
	note $3d $01
	note $41 $01
	vol $3
	note $3e $01
	note $3f $01
	note $43 $01
	note $40 $01
	note $44 $01
	note $41 $01
	vol $2
	note $42 $01
	note $46 $01
	note $43 $01
	note $47 $01
	note $44 $01
	vol $1
	note $45 $01
	note $49 $01
	note $46 $01
	note $4a $01
	note $47 $02
	vol $2
	note $4c $01
	cmdff
; $e5cf4
sound88Start:
; @addr{e5cf4}
sound88Channel2:
	duty $02
	env $2 $00
	vol $9
	cmdf8 $16
	note $1e $0f
	cmdf8 $00
	wait1 $02
	env $1 $00
	vol $1
	cmdf8 $0f
	note $20 $0a
	env $0 $00
	vol $4
	cmdf8 $16
	note $23 $05
	cmdff
; $e5d10
; GAP
	cmdff
sound98Start:
; @addr{e5d11}
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
; $e5d46
soundb1Start:
; @addr{e5d46}
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
; $e5d97
soundb5Start:
; @addr{e5d97}
soundb5Channel7:
	cmdf0 $00
	note $00 $01
	cmdf0 $50
	note $15 $05
	cmdf0 $00
	note $00 $01
	cmdf0 $40
	note $14 $06
	cmdf0 $00
	note $00 $01
	cmdf0 $60
	note $34 $06
	cmdf0 $00
	note $00 $01
	cmdf0 $30
	note $06 $06
	cmdff
; $e5db8
soundb3Start:
; @addr{e5db8}
soundb3Channel2:
	cmdf0 $df
	.db $00 $45 $03
	vol $8
	env $0 $05
	.db $00 $45 $32
	cmdff
; $e5dc4
; @addr{e5dc4}
soundb3Channel7:
	cmdf0 $f5
	note $75 $3c
	cmdff
; $e5dc9
soundaeStart:
; @addr{e5dc9}
soundaeChannel2:
	cmdf0 $d3
	.db $07 $08 $01
	vol $3
	.db $06 $0e $01
	vol $3
	.db $07 $08 $01
	vol $3
	.db $06 $0e $01
	vol $5
	.db $07 $08 $01
	vol $5
	.db $06 $0e $01
	vol $5
	.db $07 $08 $01
	vol $5
	.db $06 $0e $01
	vol $6
	.db $07 $08 $01
	vol $6
	.db $06 $0e $01
	vol $6
	.db $07 $08 $01
	vol $6
	.db $06 $0e $01
	vol $7
	.db $07 $08 $01
	vol $7
	.db $06 $0e $01
	vol $7
	.db $07 $08 $01
	vol $7
	.db $06 $0e $01
	vol $6
	.db $07 $08 $01
	vol $6
	.db $06 $0e $01
	vol $6
	.db $07 $08 $01
	vol $6
	.db $06 $0e $01
	vol $5
	.db $07 $08 $01
	vol $5
	.db $06 $0e $01
	vol $5
	.db $07 $08 $01
	vol $5
	.db $06 $0e $01
	vol $5
	.db $07 $08 $01
	vol $5
	.db $06 $0e $01
	vol $5
	.db $07 $08 $01
	vol $5
	.db $06 $0e $01
	vol $3
	.db $07 $08 $01
	vol $3
	.db $06 $0e $01
	vol $3
	.db $07 $08 $01
	vol $3
	.db $06 $0e $01
	vol $3
	.db $07 $08 $01
	vol $3
	.db $06 $0e $01
	vol $3
	.db $07 $08 $01
	vol $3
	.db $06 $0e $01
	vol $3
	.db $07 $08 $01
	vol $3
	.db $06 $0e $01
	cmdff
; $e5e63
; @addr{e5e63}
soundaeChannel7:
	cmdf0 $10
	note $15 $01
	cmdf0 $20
	note $15 $01
	cmdf0 $30
	note $15 $01
	cmdf0 $40
	note $15 $01
	cmdf0 $50
	note $15 $01
	cmdf0 $60
	note $15 $01
	cmdf0 $70
	note $15 $01
	cmdf0 $80
	note $15 $01
	cmdf0 $90
	note $15 $01
	cmdf0 $a0
	note $15 $01
	cmdf0 $90
	note $15 $01
	cmdf0 $90
	note $15 $01
	cmdf0 $80
	note $15 $01
	cmdf0 $80
	note $15 $01
	cmdf0 $70
	note $15 $01
	cmdf0 $70
	note $15 $01
	cmdf0 $70
	note $15 $01
	cmdf0 $60
	note $15 $01
	cmdf0 $60
	note $15 $01
	cmdf0 $60
	note $15 $01
	cmdf0 $60
	note $15 $01
	cmdf0 $50
	note $15 $01
	cmdf0 $50
	note $15 $01
	cmdf0 $50
	note $15 $01
	cmdf0 $50
	note $15 $01
	cmdf0 $40
	note $15 $01
	cmdf0 $40
	note $15 $01
	cmdf0 $40
	note $15 $01
	cmdf0 $40
	note $15 $01
	cmdf0 $30
	note $15 $01
	cmdf0 $30
	note $15 $01
	cmdf0 $30
	note $15 $01
	cmdf0 $20
	note $15 $01
	cmdf0 $20
	note $15 $01
	cmdf0 $20
	note $15 $01
	cmdf0 $10
	note $15 $01
	cmdf0 $10
	note $15 $01
	cmdf0 $10
	note $15 $01
	cmdff
; $e5efc
soundbeStart:
; @addr{e5efc}
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
; $e5f8d
soundacStart:
; @addr{e5f8d}
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
; $e5fc3
; @addr{e5fc3}
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
; $e5ff8
soundbaStart:
; @addr{e5ff8}
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
; $e6039
soundb4Start:
; @addr{e6039}
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
; $e6072
sound9cStart:
; @addr{e6072}
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
; $e6095
sounda0Start:
; @addr{e6095}
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
; $e60d8
soundb2Start:
; @addr{e60d8}
soundb2Channel2:
	duty $02
	vol $3
	note $0c $1c
	note $0c $1c
	note $0c $1c
	note $0c $1c
	note $0c $1c
	cmdff
; $e60e6
; @addr{e60e6}
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
; $e6173
soundbbStart:
; @addr{e6173}
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
; $e61bc
; GAP
	cmdff
	cmdff
soundb7Start:
; @addr{e61be}
soundb7Channel2:
	cmdf0 $00
	vol $6
	.db $07 $06 $01
	.db $06 $0b $01
	vol $6
	.db $07 $06 $01
	.db $06 $0b $01
	vol $6
	.db $07 $06 $01
	.db $06 $0b $01
	vol $6
	.db $07 $06 $01
	.db $06 $0b $01
	vol $6
	.db $07 $06 $01
	.db $06 $0b $01
	vol $6
	.db $07 $06 $01
	.db $06 $0b $01
	vol $2
	.db $07 $06 $01
	.db $06 $0b $01
	vol $2
	.db $07 $06 $01
	.db $06 $0b $01
	vol $2
	.db $07 $06 $01
	.db $06 $0b $01
	vol $2
	.db $07 $06 $01
	.db $06 $0b $01
	vol $2
	.db $07 $06 $01
	.db $06 $0b $01
	vol $2
	.db $07 $06 $01
	.db $06 $0b $01
	cmdff
; $e6215
; @addr{e6215}
soundb7Channel7:
	cmdf0 $90
	note $27 $03
	cmdf0 $90
	note $34 $03
	cmdf0 $90
	note $35 $03
	cmdf0 $90
	note $36 $03
	cmdf0 $20
	note $27 $03
	cmdf0 $20
	note $34 $03
	cmdf0 $20
	note $35 $03
	cmdf0 $20
	note $36 $03
	cmdff
; $e6236
sounda8Start:
; @addr{e6236}
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
; $e625d
; @addr{e625d}
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
; $e62c2
soundb8Start:
; @addr{e62c2}
soundb8Channel2:
	vol $3
	note $0c $14
	note $0c $14
	note $0c $14
	note $0c $14
	note $0c $14
	note $0c $0a
	cmdff
; $e62d0
; @addr{e62d0}
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
; $e62e9
soundb0Start:
; @addr{e62e9}
soundb0Channel2:
	duty $02
	vol $3
	note $0c $1f
	note $0c $1f
	note $0c $1f
	note $0c $1f
	note $0c $1c
	note $0c $20
	note $0c $26
	note $0c $14
	note $0c $0a
	note $0c $13
	note $0c $12
	note $0c $1c
	env $0 $07
	note $0c $32
	cmdff
; $e6309
; @addr{e6309}
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
; $e635e
sound95Start:
; @addr{e635e}
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
; $e64f3
soundb9Start:
; @addr{e64f3}
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
musice654b:
	cmdf0 $80
	note $07 $0f
	goto musice654b
	cmdff
; $e6553
soundbcStart:
; @addr{e6553}
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
; $e661e
soundbdStart:
; @addr{e661e}
soundbdChannel2:
	duty $02
	cmdf0 $d2
	.db $07 $ec $01
	vol $3
	.db $07 $eb $01
	vol $4
	.db $07 $ea $01
	vol $5
	.db $07 $e9 $01
	vol $6
	.db $07 $e8 $01
	vol $7
	.db $07 $e7 $01
	vol $8
	.db $07 $e6 $01
	vol $9
	.db $07 $e5 $01
	.db $07 $e4 $01
	.db $07 $e3 $01
	.db $07 $e2 $01
	.db $07 $e1 $01
	.db $07 $e0 $01
	.db $07 $df $01
	.db $07 $de $01
	.db $07 $dd $01
	.db $07 $dc $01
	.db $07 $db $01
	.db $07 $da $01
	.db $07 $d9 $01
	.db $07 $d8 $01
	.db $07 $d7 $01
	.db $07 $d6 $01
	.db $07 $d5 $01
	.db $07 $d4 $01
	.db $07 $d3 $01
	.db $07 $d2 $01
	.db $07 $d1 $01
	.db $07 $d0 $01
	.db $07 $cf $01
	.db $07 $ce $01
	.db $07 $cd $01
	.db $07 $cc $01
	.db $07 $cb $01
	.db $07 $ca $01
	.db $07 $c9 $01
	.db $07 $c8 $01
	.db $07 $c7 $01
	.db $07 $c6 $01
	.db $07 $c5 $01
	.db $07 $c4 $01
	.db $07 $c3 $01
	.db $07 $c2 $01
	.db $07 $c1 $01
	.db $07 $c0 $01
	.db $07 $bf $01
	.db $07 $be $01
	.db $07 $bd $01
	.db $07 $bc $01
	.db $07 $bb $01
	.db $07 $ba $01
	.db $07 $b9 $01
	.db $07 $b8 $01
	.db $07 $b7 $01
	.db $07 $b6 $01
	.db $07 $b5 $01
	.db $07 $b4 $01
	.db $07 $b3 $01
	.db $07 $b2 $01
	.db $07 $b1 $01
	.db $07 $b0 $01
	.db $07 $af $01
	.db $07 $ae $01
	.db $07 $ad $01
	.db $07 $ac $01
	.db $07 $ab $01
	.db $07 $aa $01
	.db $07 $a9 $01
	.db $07 $a8 $01
	.db $07 $a7 $01
	.db $07 $a6 $01
	.db $07 $a5 $01
	.db $07 $a4 $01
	.db $07 $a3 $01
	.db $07 $a2 $01
	.db $07 $a1 $01
	.db $07 $a0 $01
	.db $07 $9f $01
	.db $07 $9e $01
	.db $07 $9d $01
	.db $07 $9c $01
	.db $07 $9b $01
	.db $07 $9a $01
	.db $07 $99 $01
	.db $07 $98 $01
	.db $07 $97 $01
	.db $07 $96 $01
	.db $07 $95 $01
	.db $07 $94 $01
	.db $07 $93 $01
	.db $07 $92 $01
	.db $07 $91 $01
	.db $07 $90 $01
	.db $07 $8f $01
	.db $07 $8e $01
	.db $07 $8d $01
	.db $07 $8c $01
	.db $07 $8b $01
	.db $07 $8a $01
	.db $07 $89 $01
	.db $07 $88 $01
	.db $07 $87 $01
	.db $07 $86 $01
	.db $07 $85 $01
	.db $07 $84 $01
	.db $07 $83 $01
	.db $07 $82 $01
	.db $07 $81 $01
	.db $07 $80 $01
	.db $07 $7f $01
	.db $07 $7e $01
	.db $07 $7d $01
	.db $07 $7c $01
	.db $07 $7b $01
	.db $07 $7a $01
	.db $07 $79 $01
	.db $07 $78 $01
	.db $07 $77 $01
	.db $07 $76 $01
	.db $07 $75 $01
	.db $07 $74 $01
	.db $07 $73 $01
	.db $07 $72 $01
	.db $07 $71 $01
	.db $07 $70 $01
	.db $07 $6f $01
	.db $07 $6e $01
	.db $07 $6d $01
	.db $07 $6c $01
	.db $07 $6b $01
	.db $07 $6a $01
	.db $07 $69 $01
	.db $07 $68 $01
	.db $07 $67 $01
	.db $07 $66 $01
	.db $07 $65 $01
	.db $07 $64 $01
	.db $07 $63 $01
	.db $07 $62 $01
	.db $07 $61 $01
	.db $07 $60 $01
	.db $07 $5f $01
	.db $07 $5e $01
	.db $07 $5d $01
	.db $07 $5c $01
	.db $07 $5b $01
	.db $07 $5a $01
	.db $07 $59 $01
	.db $07 $58 $01
	.db $07 $57 $01
	.db $07 $56 $01
	.db $07 $55 $01
	.db $07 $54 $01
	.db $07 $53 $01
	.db $07 $52 $01
	.db $07 $51 $01
	.db $07 $50 $01
	.db $07 $4f $01
	.db $07 $4e $01
	.db $07 $4d $01
	.db $07 $4c $01
	.db $07 $4b $01
	.db $07 $4a $01
	.db $07 $49 $01
	.db $07 $48 $01
	.db $07 $47 $01
	.db $07 $46 $01
	.db $07 $45 $01
	.db $07 $44 $01
	.db $07 $43 $01
	.db $07 $42 $01
	.db $07 $41 $01
	.db $07 $40 $01
	.db $07 $3f $01
	.db $07 $3e $01
	.db $07 $3d $01
	.db $07 $3c $01
	.db $07 $3b $01
	.db $07 $3a $01
	.db $07 $39 $01
	.db $07 $38 $01
	.db $07 $37 $01
	.db $07 $36 $01
	.db $07 $35 $01
	.db $07 $34 $01
	.db $07 $33 $01
	.db $07 $32 $01
	.db $07 $31 $01
	.db $07 $30 $01
	.db $07 $2f $01
	.db $07 $2e $01
	.db $07 $2d $01
	.db $07 $2c $01
	.db $07 $2b $01
	.db $07 $2a $01
	.db $07 $29 $01
	.db $07 $28 $01
	.db $07 $27 $01
	.db $07 $26 $01
	.db $07 $25 $01
	.db $07 $24 $01
	.db $07 $23 $01
	.db $07 $22 $01
	.db $07 $21 $01
	.db $07 $20 $01
	.db $07 $1f $01
	.db $07 $1e $01
	.db $07 $1d $01
	.db $07 $1c $01
	.db $07 $1b $01
	.db $07 $1a $01
	.db $07 $19 $01
	.db $07 $18 $01
	.db $07 $17 $01
	.db $07 $16 $01
	.db $07 $15 $01
	.db $07 $14 $01
	.db $07 $13 $01
	.db $07 $12 $01
	.db $07 $11 $01
	.db $07 $10 $01
	.db $07 $0f $01
	.db $07 $0e $01
	.db $07 $0d $01
	.db $07 $0c $01
	.db $07 $0b $01
	.db $07 $0a $01
	.db $07 $09 $01
	.db $07 $08 $01
	.db $07 $07 $01
	.db $07 $06 $01
	.db $07 $05 $01
	.db $07 $04 $01
	.db $07 $03 $01
	.db $07 $02 $01
	.db $07 $01 $01
	.db $07 $00 $01
	.db $06 $ff $01
	.db $06 $fd $01
	.db $06 $fb $01
	.db $06 $fa $01
	.db $06 $f9 $01
	.db $06 $f7 $01
	.db $06 $f5 $01
	.db $06 $f3 $01
	.db $06 $f1 $01
	.db $06 $ef $01
	.db $06 $ed $01
	.db $06 $eb $01
	.db $06 $e9 $01
	.db $06 $e7 $01
	.db $06 $e5 $01
	.db $06 $e3 $01
	.db $06 $e1 $01
	.db $06 $d9 $01
	.db $06 $d7 $01
	.db $06 $d5 $01
	.db $06 $d3 $01
	.db $06 $d1 $01
	.db $06 $c9 $01
	.db $06 $c7 $01
	.db $06 $c5 $01
	.db $06 $c3 $01
	.db $06 $c1 $01
	.db $06 $bf $01
	.db $06 $bd $01
	.db $06 $bb $01
	.db $06 $b9 $01
	.db $06 $b7 $01
	.db $06 $b5 $01
	.db $06 $b3 $01
	.db $06 $b1 $01
	.db $06 $af $01
	.db $06 $ad $01
	.db $06 $ab $01
	.db $06 $a9 $01
	.db $06 $a7 $01
	.db $06 $a5 $01
	.db $06 $a3 $01
	.db $06 $a1 $01
	.db $06 $9f $01
	.db $06 $9d $01
	.db $06 $9b $01
	.db $06 $99 $01
	.db $06 $97 $01
	.db $06 $95 $01
	.db $06 $93 $01
	.db $06 $91 $01
	.db $06 $8f $01
	.db $06 $8d $01
	.db $06 $8b $01
	.db $06 $89 $01
	.db $06 $87 $01
	.db $06 $85 $01
	.db $06 $83 $01
	.db $06 $81 $01
	.db $06 $7f $01
	.db $06 $7d $01
	.db $06 $7b $01
	.db $06 $79 $01
	.db $06 $77 $01
	.db $06 $75 $01
	.db $06 $73 $01
	.db $06 $71 $01
	.db $06 $6f $01
	.db $06 $6d $01
	.db $06 $6b $01
	.db $06 $69 $01
	.db $06 $67 $01
	.db $06 $65 $01
	.db $06 $63 $01
	.db $06 $61 $01
	.db $06 $5f $01
	.db $06 $5d $01
	.db $06 $5b $01
	.db $06 $59 $01
	.db $06 $57 $01
	.db $06 $55 $01
	.db $06 $53 $01
	.db $06 $51 $01
	.db $06 $4f $01
	.db $06 $4d $01
	.db $06 $4b $01
	.db $06 $49 $01
	.db $06 $47 $01
	.db $06 $45 $01
	.db $06 $43 $01
	.db $06 $41 $01
	.db $06 $3f $01
	.db $06 $3d $01
	.db $06 $3b $01
	.db $06 $39 $01
	.db $06 $37 $01
	.db $06 $35 $01
	.db $06 $33 $01
	.db $06 $31 $01
	.db $06 $2f $01
	.db $06 $2d $01
	.db $06 $2b $01
	.db $06 $29 $01
	.db $06 $27 $01
	.db $06 $25 $01
	.db $06 $23 $01
	.db $06 $21 $01
	.db $06 $1f $01
	.db $06 $1d $01
	.db $06 $1b $01
	.db $06 $19 $01
	.db $06 $17 $01
	.db $06 $15 $01
	.db $06 $13 $01
	.db $06 $11 $01
	.db $06 $0f $01
	.db $06 $0d $01
	.db $06 $0b $01
	.db $06 $09 $01
	.db $06 $07 $01
	.db $06 $05 $01
	.db $06 $03 $01
	.db $06 $01 $01
	.db $05 $ff $01
	.db $05 $fd $01
	.db $05 $fb $01
	.db $05 $f9 $01
	.db $05 $f7 $01
	.db $05 $f5 $01
	.db $05 $f3 $01
	.db $05 $f1 $01
	.db $05 $ef $01
	.db $05 $ed $01
	.db $05 $eb $01
	.db $05 $e9 $01
	.db $05 $e7 $01
	.db $05 $e5 $01
	.db $05 $e3 $01
	.db $05 $e1 $01
	.db $05 $df $01
	.db $05 $dd $01
	.db $05 $db $01
	.db $05 $d9 $01
	.db $05 $d7 $01
	.db $05 $d5 $01
	.db $05 $d3 $01
	.db $05 $d1 $01
	.db $05 $cf $01
	.db $05 $cd $01
	.db $05 $cb $01
	.db $05 $c9 $01
	.db $05 $c7 $01
	.db $05 $c5 $01
	.db $05 $c3 $01
	.db $05 $c1 $01
	.db $05 $bf $01
	.db $05 $bd $01
	.db $05 $bb $01
	.db $05 $b9 $01
	.db $05 $b7 $01
	.db $05 $b5 $01
	.db $05 $b3 $01
	.db $05 $b1 $01
	.db $05 $af $01
	.db $05 $ad $01
	.db $05 $ab $01
	.db $05 $a9 $01
	.db $05 $a7 $01
	.db $05 $a5 $01
	.db $05 $a3 $01
	.db $05 $a1 $01
	.db $05 $9f $01
	.db $05 $9d $01
	.db $05 $9b $01
	.db $05 $99 $01
	.db $05 $97 $01
	.db $05 $95 $01
	.db $05 $93 $01
	.db $05 $91 $01
	.db $05 $8f $01
	.db $05 $8d $01
	.db $05 $8b $01
	.db $05 $89 $01
	.db $05 $87 $01
	.db $05 $85 $01
	.db $05 $83 $01
	.db $05 $81 $01
	.db $05 $7f $01
	.db $05 $7d $01
	.db $05 $7b $01
	.db $05 $79 $01
	.db $05 $77 $01
	.db $05 $75 $01
	.db $05 $73 $01
	.db $05 $71 $01
	.db $05 $6f $01
	.db $05 $6d $01
	.db $05 $6b $01
	.db $05 $69 $01
	.db $05 $67 $01
	.db $05 $65 $01
	.db $05 $63 $01
	.db $05 $61 $01
	.db $05 $5f $01
	.db $05 $5d $01
	.db $05 $5b $01
	.db $05 $5a $01
	.db $05 $59 $01
	.db $05 $57 $01
	.db $05 $55 $01
	.db $05 $53 $01
	.db $05 $51 $01
	.db $05 $4f $01
	.db $05 $4d $01
	.db $05 $4b $01
	.db $05 $49 $01
	.db $05 $47 $01
	.db $05 $45 $01
	.db $05 $43 $01
	.db $05 $41 $01
	cmdff
; $e6b85
sound2cStart:
; @addr{e6b85}
sound2cChannel1:
	duty $01
musice6b87:
	vol $6
	note $37 $0f
	note $34 $05
	note $30 $05
	wait1 $02
	vol $3
	note $30 $03
	vol $6
	note $30 $0f
	vol $3
	note $30 $05
	vol $6
	note $37 $0a
	note $34 $0a
	note $30 $0a
	note $36 $0f
	note $33 $05
	note $2f $05
	wait1 $02
	vol $3
	note $2f $03
	vol $6
	note $2f $0f
	vol $3
	note $2f $05
	vol $6
	note $36 $0a
	note $33 $0a
	note $2f $05
	wait1 $02
	vol $3
	note $2f $03
	vol $6
	note $37 $0f
	note $34 $05
	note $30 $05
	wait1 $02
	vol $3
	note $30 $03
	vol $6
	note $30 $0a
	vol $3
	note $30 $0a
	vol $6
	note $37 $0a
	note $34 $0a
	note $30 $05
	wait1 $02
	vol $3
	note $30 $03
	vol $6
	note $2f $05
	note $30 $05
	note $31 $05
	wait1 $02
	vol $3
	note $31 $03
	vol $6
	note $31 $05
	note $33 $05
	note $34 $05
	wait1 $02
	vol $3
	note $34 $03
	vol $6
	note $33 $05
	note $34 $05
	note $35 $05
	wait1 $02
	vol $3
	note $35 $03
	vol $6
	note $34 $05
	note $35 $05
	note $36 $05
	wait1 $02
	vol $3
	note $36 $03
	vol $6
	note $37 $0f
	note $34 $05
	note $30 $05
	wait1 $02
	vol $3
	note $30 $03
	vol $6
	note $30 $0a
	vol $3
	note $30 $0a
	vol $6
	note $37 $0a
	note $34 $0a
	note $30 $05
	wait1 $02
	vol $3
	note $30 $03
	vol $6
	note $36 $0f
	note $33 $05
	note $2f $05
	wait1 $02
	vol $3
	note $2f $03
	vol $6
	note $2f $0f
	vol $3
	note $2f $05
	vol $6
	note $36 $0a
	note $33 $0a
	note $2f $05
	wait1 $02
	vol $3
	note $2f $03
	vol $6
	note $37 $0a
	note $34 $05
	wait1 $02
	vol $3
	note $34 $05
	wait1 $12
	vol $6
	note $39 $0a
	note $36 $05
	wait1 $02
	vol $3
	note $36 $05
	wait1 $12
	vol $6
	note $3a $05
	note $37 $05
	note $3b $05
	note $38 $05
	note $3c $05
	note $39 $05
	note $3d $05
	note $3a $05
	note $3e $05
	note $3b $05
	note $3f $05
	note $3c $05
	note $40 $05
	note $3d $05
	note $41 $05
	note $3e $05
	note $39 $0f
	note $36 $05
	note $32 $05
	wait1 $02
	vol $3
	note $32 $03
	vol $6
	note $32 $0f
	vol $3
	note $32 $05
	vol $6
	note $32 $0a
	note $36 $0a
	note $39 $0a
	note $38 $0f
	note $35 $05
	note $31 $05
	wait1 $02
	vol $3
	note $31 $03
	vol $6
	note $31 $0a
	vol $3
	note $31 $0a
	vol $6
	note $31 $0a
	note $35 $0a
	note $38 $0a
	note $39 $0f
	note $36 $05
	note $32 $05
	wait1 $02
	vol $3
	note $32 $03
	vol $6
	note $32 $14
	note $36 $0a
	note $39 $0a
	note $36 $05
	wait1 $02
	vol $3
	note $36 $03
	vol $6
	note $38 $05
	note $35 $05
	note $31 $05
	wait1 $02
	vol $3
	note $31 $03
	vol $6
	note $39 $05
	note $36 $05
	note $32 $05
	wait1 $02
	vol $3
	note $32 $03
	vol $6
	note $3a $05
	note $37 $05
	note $33 $05
	wait1 $02
	vol $3
	note $33 $03
	vol $6
	note $3b $05
	note $38 $05
	note $34 $05
	wait1 $02
	vol $3
	note $34 $03
	vol $6
	note $39 $0f
	note $36 $05
	note $32 $05
	wait1 $02
	vol $3
	note $32 $03
	vol $6
	note $3e $14
	note $3d $05
	note $3e $05
	note $40 $05
	wait1 $02
	vol $3
	note $40 $03
	vol $6
	note $3e $05
	wait1 $02
	vol $3
	note $3e $03
	vol $6
	note $3d $0f
	note $38 $05
	note $35 $05
	wait1 $02
	vol $3
	note $35 $03
	vol $6
	note $31 $16
	wait1 $03
	note $3d $02
	vol $3
	note $3d $03
	vol $6
	note $3d $05
	note $3c $05
	note $3d $05
	note $3e $05
	note $3f $05
	wait1 $02
	vol $3
	note $3f $03
	vol $6
	note $3f $05
	wait1 $02
	vol $3
	note $3f $05
	wait1 $12
	vol $6
	note $40 $05
	wait1 $02
	vol $3
	note $40 $03
	vol $6
	note $40 $05
	wait1 $02
	vol $3
	note $40 $05
	wait1 $12
	vol $6
	note $44 $05
	wait1 $02
	vol $3
	note $44 $03
	vol $6
	note $43 $05
	wait1 $02
	vol $3
	note $43 $03
	vol $6
	note $42 $05
	wait1 $02
	vol $3
	note $42 $03
	vol $6
	note $41 $05
	wait1 $02
	vol $3
	note $41 $03
	vol $6
	note $40 $05
	wait1 $02
	vol $3
	note $40 $03
	vol $6
	note $3f $05
	wait1 $02
	vol $3
	note $3f $03
	vol $6
	note $3e $05
	wait1 $02
	vol $3
	note $3e $03
	vol $6
	note $3d $05
	wait1 $02
	vol $3
	note $3d $03
	goto musice6b87
	cmdff
; $e6da1
; @addr{e6da1}
sound2cChannel0:
	duty $01
musice6da3:
	vol $6
	note $28 $05
	wait1 $05
	note $28 $05
	wait1 $05
	note $28 $05
	wait1 $05
	note $28 $0f
	wait1 $05
	note $28 $05
	wait1 $05
	note $28 $05
	wait1 $05
	note $28 $05
	wait1 $05
	note $27 $05
	wait1 $05
	note $27 $05
	wait1 $05
	note $27 $05
	wait1 $05
	note $27 $0f
	wait1 $05
	note $27 $05
	wait1 $05
	note $27 $05
	wait1 $05
	note $27 $05
	wait1 $05
	note $28 $05
	wait1 $05
	note $28 $05
	wait1 $05
	note $28 $05
	wait1 $05
	note $28 $0f
	wait1 $05
	note $28 $05
	wait1 $05
	note $28 $05
	wait1 $05
	note $28 $05
	wait1 $05
	note $27 $05
	wait1 $05
	note $2b $05
	vol $3
	note $27 $05
	vol $6
	note $2a $05
	vol $3
	note $2b $05
	vol $6
	note $29 $05
	vol $3
	note $2a $05
	vol $6
	note $28 $05
	vol $3
	note $29 $05
	vol $6
	note $27 $05
	vol $3
	note $28 $05
	vol $6
	note $26 $05
	vol $3
	note $27 $05
	vol $6
	note $25 $05
	vol $3
	note $26 $05
	vol $6
	note $28 $05
	wait1 $05
	note $28 $05
	wait1 $05
	note $28 $05
	wait1 $05
	note $28 $0f
	wait1 $05
	note $28 $05
	wait1 $05
	note $28 $05
	wait1 $05
	note $28 $05
	wait1 $05
	note $27 $05
	wait1 $05
	note $27 $05
	wait1 $05
	note $27 $05
	wait1 $05
	note $27 $0f
	wait1 $05
	note $27 $05
	wait1 $05
	note $27 $05
	wait1 $05
	note $27 $05
	wait1 $05
	note $28 $05
	wait1 $05
	note $28 $05
	wait1 $05
	vol $3
	note $28 $05
	wait1 $05
	vol $1
	note $28 $05
	wait1 $05
	vol $6
	note $27 $05
	wait1 $05
	note $27 $05
	wait1 $05
	vol $3
	note $27 $05
	wait1 $05
	vol $1
	note $27 $05
	wait1 $05
	vol $6
	note $28 $05
	wait1 $05
	note $28 $05
	vol $3
	note $28 $05
	vol $6
	note $29 $05
	vol $3
	note $28 $05
	vol $6
	note $29 $05
	vol $3
	note $29 $05
	vol $6
	note $2a $05
	vol $3
	note $29 $05
	vol $6
	note $2a $05
	vol $3
	note $2a $05
	vol $6
	note $2b $05
	vol $3
	note $2a $05
	vol $6
	note $2b $05
	vol $3
	note $2b $05
	vol $6
	note $2a $05
	wait1 $05
	note $2a $05
	wait1 $05
	note $2a $05
	wait1 $05
	note $2a $0f
	wait1 $05
	note $2a $05
	wait1 $05
	note $2a $05
	wait1 $05
	note $2a $05
	wait1 $05
	note $29 $05
	wait1 $05
	note $29 $05
	wait1 $05
	note $29 $05
	wait1 $05
	note $29 $0f
	wait1 $05
	note $29 $05
	wait1 $05
	note $29 $05
	wait1 $05
	note $29 $05
	wait1 $05
	note $2a $05
	wait1 $05
	note $2a $05
	wait1 $05
	note $2a $05
	wait1 $05
	note $2a $0f
	wait1 $05
	note $2a $05
	wait1 $05
	note $2a $05
	wait1 $05
	note $2a $05
	wait1 $05
	note $29 $05
	wait1 $05
	note $2d $05
	vol $3
	note $29 $05
	vol $6
	note $2c $05
	vol $3
	note $2d $05
	vol $6
	note $2b $05
	vol $3
	note $2c $05
	vol $6
	note $2a $05
	vol $3
	note $2b $05
	vol $6
	note $29 $05
	vol $3
	note $2a $05
	vol $6
	note $28 $05
	vol $3
	note $29 $05
	vol $6
	note $27 $05
	vol $3
	note $28 $05
	vol $6
	note $2a $05
	wait1 $05
	note $2a $05
	wait1 $05
	note $2a $05
	wait1 $05
	note $2a $0f
	wait1 $05
	note $2a $05
	wait1 $05
	note $2a $05
	wait1 $05
	note $2a $05
	wait1 $05
	note $29 $05
	wait1 $05
	note $29 $05
	wait1 $05
	note $29 $05
	wait1 $05
	note $29 $0f
	wait1 $05
	note $29 $05
	wait1 $05
	note $29 $05
	wait1 $05
	note $29 $05
	wait1 $05
	note $2a $05
	wait1 $05
	note $2a $05
	wait1 $05
	vol $3
	note $2a $05
	wait1 $05
	vol $6
	note $2a $05
	wait1 $05
	note $2b $05
	wait1 $05
	note $2b $05
	wait1 $05
	vol $3
	note $2b $05
	wait1 $05
	vol $6
	note $2b $05
	note $28 $05
	note $29 $05
	vol $3
	note $29 $05
	vol $6
	note $29 $05
	vol $3
	note $29 $05
	vol $6
	note $21 $05
	note $20 $05
	note $1f $05
	note $1e $05
	note $1d $05
	note $1c $05
	note $1b $05
	note $1a $05
	note $19 $05
	note $18 $05
	note $17 $05
	note $16 $05
	goto musice6da3
	cmdff
; $e6fb8
; @addr{e6fb8}
sound2cChannel4:
musice6fb8:
	duty $0e
	note $19 $05
	duty $0f
	note $19 $05
	duty $0e
	note $13 $05
	duty $0f
	note $13 $05
	duty $0e
	note $19 $05
	duty $0f
	note $19 $05
	duty $0e
	note $13 $05
	duty $0f
	note $13 $05
	duty $0e
	note $19 $05
	duty $0f
	note $19 $05
	duty $0e
	note $13 $05
	duty $0f
	note $13 $05
	duty $0e
	note $19 $05
	duty $0f
	note $19 $05
	duty $0e
	note $13 $05
	duty $0f
	note $13 $05
	duty $0e
	note $18 $05
	duty $0f
	note $18 $05
	duty $0e
	note $12 $05
	duty $0f
	note $12 $05
	duty $0e
	note $18 $05
	duty $0f
	note $18 $05
	duty $0e
	note $12 $05
	duty $0f
	note $12 $05
	duty $0e
	note $18 $05
	duty $0f
	note $18 $05
	duty $0e
	note $12 $05
	duty $0f
	note $12 $05
	duty $0e
	note $18 $05
	duty $0f
	note $18 $05
	duty $0e
	note $12 $05
	duty $0f
	note $12 $05
	duty $0e
	note $19 $05
	duty $0f
	note $19 $05
	duty $0e
	note $13 $05
	duty $0f
	note $13 $05
	duty $0e
	note $19 $05
	duty $0f
	note $19 $05
	duty $0e
	note $13 $05
	duty $0f
	note $13 $05
	duty $0e
	note $19 $05
	duty $0f
	note $19 $05
	duty $0e
	note $13 $05
	duty $0f
	note $13 $05
	duty $0e
	note $19 $05
	duty $0f
	note $19 $05
	duty $0e
	note $13 $05
	duty $0f
	note $13 $05
	duty $0e
	note $18 $05
	duty $0f
	note $18 $05
	duty $0e
	note $1b $05
	duty $0f
	note $1b $05
	duty $0e
	note $1a $05
	duty $0f
	note $1a $05
	duty $0e
	note $19 $05
	duty $0f
	note $19 $05
	duty $0e
	note $18 $05
	duty $0f
	note $18 $05
	duty $0e
	note $17 $05
	duty $0f
	note $17 $05
	duty $0e
	note $15 $05
	note $14 $05
	note $13 $05
	note $12 $05
	duty $0e
	note $18 $05
	duty $0f
	note $18 $05
	duty $0e
	note $13 $05
	duty $0f
	note $13 $05
	duty $0e
	note $18 $05
	duty $0f
	note $18 $05
	duty $0e
	note $13 $05
	duty $0f
	note $13 $05
	duty $0e
	note $19 $05
	duty $0f
	note $19 $05
	duty $0e
	note $13 $05
	duty $0f
	note $13 $05
	duty $0e
	note $19 $05
	duty $0f
	note $19 $05
	duty $0e
	note $13 $05
	duty $0f
	note $13 $05
	duty $0e
	note $18 $05
	duty $0f
	note $18 $05
	duty $0e
	note $12 $05
	duty $0f
	note $12 $05
	duty $0e
	note $18 $05
	duty $0f
	note $18 $05
	duty $0e
	note $12 $05
	duty $0f
	note $12 $05
	duty $0e
	note $18 $05
	duty $0f
	note $18 $05
	duty $0e
	note $12 $05
	duty $0f
	note $12 $05
	duty $0e
	note $18 $05
	duty $0f
	note $18 $05
	duty $0e
	note $12 $05
	duty $0f
	note $12 $05
	duty $0e
	note $19 $05
	duty $0f
	note $19 $05
	duty $0e
	note $19 $05
	duty $0f
	note $19 $05
	wait1 $14
	duty $0e
	note $18 $05
	duty $0f
	note $18 $05
	duty $0e
	note $18 $05
	duty $0f
	note $18 $05
	wait1 $14
	duty $0e
	note $1b $05
	duty $0f
	note $1b $05
	duty $0e
	note $1b $05
	duty $0f
	note $1b $05
	wait1 $14
	duty $0e
	note $1c $05
	duty $0f
	note $1c $05
	duty $0e
	note $1c $05
	duty $0f
	note $1c $05
	wait1 $14
	duty $0e
	note $1b $05
	note $1a $05
	note $15 $05
	duty $0f
	note $15 $05
	duty $0e
	note $1b $05
	duty $0f
	note $1b $05
	duty $0e
	note $15 $05
	duty $0f
	note $15 $05
	duty $0e
	note $1b $05
	duty $0f
	note $1b $05
	duty $0e
	note $15 $05
	duty $0f
	note $15 $05
	duty $0e
	note $1b $05
	duty $0f
	note $1b $05
	duty $0e
	note $15 $05
	duty $0f
	note $15 $05
	duty $0e
	note $1a $05
	note $19 $05
	note $14 $05
	duty $0f
	note $14 $05
	duty $0e
	note $1a $05
	duty $0f
	note $1a $05
	duty $0e
	note $14 $05
	duty $0f
	note $14 $05
	duty $0e
	note $1a $05
	duty $0f
	note $1a $05
	duty $0e
	note $14 $05
	duty $0f
	note $14 $05
	duty $0e
	note $1a $05
	duty $0f
	note $1a $05
	duty $0e
	note $14 $05
	duty $0f
	note $14 $05
	duty $0e
	note $1b $05
	note $1a $05
	note $15 $05
	duty $0f
	note $15 $05
	duty $0e
	note $1b $05
	duty $0f
	note $1b $05
	duty $0e
	note $15 $05
	duty $0f
	note $15 $05
	duty $0e
	note $1b $05
	duty $0f
	note $1b $05
	duty $0e
	note $15 $05
	duty $0f
	note $15 $05
	duty $0e
	note $1b $05
	duty $0f
	note $1b $05
	duty $0e
	note $15 $05
	duty $0f
	note $15 $05
	duty $0e
	note $1a $05
	duty $0f
	note $1a $05
	duty $0e
	note $1d $05
	duty $0f
	note $1d $05
	duty $0e
	note $1c $05
	duty $0f
	note $1c $05
	duty $0e
	note $1b $05
	duty $0f
	note $1b $05
	duty $0e
	note $1a $05
	duty $0f
	note $1a $05
	duty $0e
	note $19 $05
	duty $0f
	note $19 $05
	duty $0e
	note $18 $05
	duty $0f
	note $18 $05
	duty $0e
	note $17 $05
	duty $0f
	note $17 $05
	duty $0e
	note $1b $05
	note $1a $05
	note $15 $05
	duty $0f
	note $15 $05
	duty $0e
	note $1b $05
	duty $0f
	note $1b $05
	duty $0e
	note $15 $05
	duty $0f
	note $15 $05
	duty $0e
	note $1b $05
	duty $0f
	note $1b $05
	duty $0e
	note $15 $05
	duty $0f
	note $15 $05
	duty $0e
	note $1b $05
	duty $0f
	note $1b $05
	duty $0e
	note $15 $05
	duty $0f
	note $15 $05
	duty $0e
	note $1a $05
	note $19 $05
	note $14 $05
	duty $0f
	note $14 $05
	duty $0e
	note $1a $05
	duty $0f
	note $1a $05
	duty $0e
	note $14 $05
	duty $0f
	note $14 $05
	duty $0e
	note $1a $05
	duty $0f
	note $1a $05
	duty $0e
	note $14 $05
	duty $0f
	note $14 $05
	duty $0e
	note $1a $05
	duty $0f
	note $1a $05
	duty $0e
	note $14 $05
	duty $0f
	note $14 $05
	duty $0e
	note $1b $05
	duty $0f
	note $1b $05
	duty $0e
	note $1b $05
	duty $0f
	note $1b $05
	wait1 $14
	duty $0e
	note $1c $05
	duty $0f
	note $1c $05
	duty $0e
	note $1c $05
	duty $0f
	note $1c $05
	wait1 $0a
	duty $0e
	note $1c $05
	duty $0f
	note $1c $05
	duty $0e
	note $1d $05
	duty $0f
	note $1d $05
	duty $0e
	note $1d $05
	duty $0f
	note $1d $05
	duty $0e
	note $1d $05
	note $1c $05
	note $1b $05
	note $1a $05
	note $19 $05
	note $18 $05
	note $17 $05
	note $16 $05
	note $15 $05
	note $14 $05
	note $13 $05
	note $12 $05
	goto musice6fb8
	cmdff
; $e7340
; @addr{e7340}
sound2cChannel6:
musice7340:
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
	goto musice7340
	cmdff
; $e7534
sound32Start:
; @addr{e7534}
sound32Channel1:
	vibrato $e1
	env $0 $00
	duty $02
musice753a:
	vol $6
	note $20 $3c
	vibrato $01
	env $0 $00
	vol $3
	note $20 $0c
	vibrato $e1
	env $0 $00
	vol $6
	note $20 $08
	note $21 $08
	note $22 $08
	note $23 $48
	vibrato $01
	env $0 $00
	vol $3
	note $23 $18
	vibrato $e1
	env $0 $00
	vol $6
	note $2c $3c
	vibrato $01
	env $0 $00
	vol $3
	note $2c $0c
	vibrato $e1
	env $0 $00
	vol $6
	note $2c $08
	note $2d $08
	note $2e $08
	note $2f $48
	vibrato $01
	env $0 $00
	vol $3
	note $2f $18
	vibrato $e1
	env $0 $00
	vol $6
	note $22 $3c
	vibrato $01
	env $0 $00
	vol $3
	note $22 $0c
	vibrato $e1
	env $0 $00
	vol $6
	note $22 $08
	note $23 $08
	note $24 $08
	note $25 $48
	vibrato $01
	env $0 $00
	vol $3
	note $25 $18
	vibrato $e1
	env $0 $00
	vol $6
	note $2e $3c
	vibrato $01
	env $0 $00
	vol $3
	note $2e $0c
	vibrato $e1
	env $0 $00
	vol $6
	note $2e $08
	note $2f $08
	note $30 $08
	note $31 $48
	vibrato $01
	env $0 $00
	vol $3
	note $31 $18
	vibrato $e1
	env $0 $00
	vol $6
	note $33 $12
	note $32 $06
	wait1 $03
	vol $3
	note $32 $06
	wait1 $03
	vol $1
	note $32 $06
	wait1 $06
	vol $6
	note $31 $12
	note $30 $06
	wait1 $03
	vol $3
	note $30 $06
	wait1 $03
	vol $1
	note $30 $06
	wait1 $06
	vol $6
	note $33 $06
	wait1 $03
	vol $3
	note $33 $03
	vol $6
	note $33 $06
	note $32 $06
	wait1 $03
	vol $3
	note $32 $06
	wait1 $03
	vol $1
	note $32 $06
	wait1 $06
	vol $6
	note $31 $03
	wait1 $03
	vol $6
	note $31 $03
	wait1 $03
	vol $6
	note $31 $06
	note $30 $06
	wait1 $03
	vol $3
	note $30 $06
	wait1 $03
	vol $1
	note $30 $06
	wait1 $06
	vol $6
	note $34 $12
	note $33 $06
	vol $4
	note $30 $06
	note $2f $06
	note $2e $06
	note $2d $06
	vol $6
	note $32 $12
	note $31 $06
	vol $4
	note $2a $06
	note $29 $06
	note $28 $06
	note $27 $06
	vol $6
	note $34 $06
	wait1 $03
	vol $3
	note $34 $03
	vol $6
	note $34 $06
	note $33 $06
	vol $4
	note $31 $06
	note $30 $06
	note $2f $06
	note $2e $06
	vol $6
	note $32 $03
	wait1 $03
	vol $6
	note $32 $03
	wait1 $03
	vol $6
	note $32 $06
	note $31 $06
	vol $4
	note $2a $04
	note $2b $04
	note $2c $04
	note $2d $04
	note $2e $04
	note $2f $04
	vol $6
	note $32 $06
	wait1 $03
	vol $3
	note $32 $06
	wait1 $03
	vol $6
	note $3a $06
	note $39 $30
	note $35 $18
	note $31 $06
	note $30 $06
	note $2f $06
	note $2e $06
	note $2d $06
	note $2c $06
	note $2b $06
	note $2a $06
	note $29 $06
	note $28 $06
	note $27 $06
	note $26 $06
	note $25 $06
	note $24 $06
	note $23 $06
	note $22 $06
	goto musice753a
	cmdff
; $e769b
; @addr{e769b}
sound32Channel0:
	vibrato $e1
	env $0 $00
	duty $02
musice76a1:
	vol $6
	note $1a $3c
	vibrato $01
	env $0 $00
	vol $3
	note $1a $0c
	vibrato $e1
	env $0 $00
	vol $6
	note $1a $08
	note $1b $08
	note $1c $08
	note $1d $06
	note $17 $06
	vol $0
	note $17 $03
	vol $3
	note $17 $03
	vol $6
	note $1d $06
	note $17 $06
	vol $0
	note $17 $03
	vol $3
	note $17 $03
	vol $6
	note $1d $06
	note $17 $06
	vol $0
	note $17 $03
	vol $3
	note $17 $03
	vol $6
	note $1d $06
	note $17 $06
	note $11 $06
	note $17 $06
	note $1d $06
	note $17 $06
	note $11 $06
	note $1a $3c
	vibrato $01
	env $0 $00
	vol $3
	note $1a $0c
	vibrato $e1
	env $0 $00
	vol $6
	note $1a $08
	note $1b $08
	note $1c $08
	note $1d $06
	note $17 $06
	vol $0
	note $17 $03
	vol $3
	note $17 $03
	vol $6
	note $1d $06
	note $17 $06
	vol $0
	note $17 $03
	vol $3
	note $17 $03
	vol $6
	note $1d $06
	note $17 $06
	vol $0
	note $17 $03
	vol $3
	note $17 $03
	vol $6
	note $1d $06
	note $17 $06
	note $11 $06
	note $17 $06
	note $1d $06
	note $17 $06
	note $11 $06
	note $1c $3c
	vibrato $01
	env $0 $00
	vol $3
	note $1c $0c
	vibrato $e1
	env $0 $00
	vol $6
	note $1c $08
	note $1d $08
	note $1e $08
	note $1f $06
	note $19 $06
	vol $0
	note $19 $03
	vol $3
	note $19 $03
	vol $6
	note $1f $06
	note $19 $06
	vol $0
	note $19 $03
	vol $3
	note $19 $03
	vol $6
	note $1f $06
	note $19 $06
	vol $0
	note $19 $03
	vol $3
	note $19 $03
	vol $6
	note $1f $06
	note $19 $06
	note $13 $06
	note $19 $06
	note $1f $06
	note $19 $06
	note $13 $06
	note $1c $3c
	vibrato $01
	env $0 $00
	vol $3
	note $1c $0c
	vibrato $e1
	env $0 $00
	vol $6
	note $1c $08
	note $1d $08
	note $1e $08
	note $1f $06
	note $19 $06
	vol $0
	note $19 $03
	vol $3
	note $19 $03
	vol $6
	note $1f $06
	note $19 $06
	vol $0
	note $19 $03
	vol $3
	note $19 $03
	vol $6
	note $1f $06
	note $19 $06
	vol $0
	note $19 $03
	vol $3
	note $19 $03
	vol $6
	note $1f $06
	note $19 $06
	note $13 $06
	note $19 $06
	note $1f $06
	note $25 $06
	note $2b $06
	note $2e $12
	note $2d $06
	note $22 $06
	note $21 $06
	note $20 $06
	note $1f $06
	note $2c $12
	note $2b $06
	note $20 $06
	note $1f $06
	note $1e $06
	note $1d $06
	note $2e $06
	vol $0
	note $2e $03
	vol $3
	note $2e $03
	vol $6
	note $2e $06
	note $2d $06
	note $22 $06
	note $21 $06
	note $20 $06
	note $1f $06
	note $2c $03
	vol $0
	note $2c $03
	vol $6
	note $2c $03
	vol $0
	note $2c $03
	vol $6
	note $2c $06
	note $2b $06
	note $20 $06
	note $1f $06
	note $1e $06
	note $1d $06
	note $2f $12
	note $2e $06
	note $23 $06
	note $22 $06
	note $21 $06
	note $20 $06
	note $2d $12
	note $2c $06
	note $21 $06
	note $20 $06
	note $1f $06
	note $1e $06
	note $2f $06
	vol $0
	note $2f $03
	vol $3
	note $2f $03
	vol $6
	note $2f $06
	note $2e $06
	note $23 $06
	note $22 $06
	note $21 $06
	note $20 $06
	note $2d $03
	vol $0
	note $2d $03
	vol $6
	note $2d $03
	vol $0
	note $2d $03
	vol $6
	note $2d $06
	note $2c $06
	note $21 $04
	note $22 $04
	note $23 $04
	note $24 $04
	note $25 $04
	note $26 $04
	note $27 $04
	note $28 $04
	note $29 $04
	note $2a $04
	note $2b $04
	note $2c $04
	note $2d $04
	note $2e $04
	note $2f $04
	note $30 $04
	note $31 $04
	note $32 $04
	note $33 $04
	note $34 $04
	note $35 $04
	note $36 $04
	note $37 $04
	note $38 $04
	vol $6
	note $39 $60
	vol $6
	note $3a $04
	vol $6
	note $3b $04
	vol $5
	note $3c $04
	vol $5
	note $3d $04
	vol $4
	note $3e $04
	vol $4
	note $40 $04
	goto musice76a1
	cmdff
; $e7879
; @addr{e7879}
sound32Channel4:
musice7879:
	duty $12
	note $14 $04
	duty $0f
	note $14 $02
	duty $12
	note $14 $04
	duty $0f
	note $14 $08
	duty $12
	note $14 $04
	duty $0f
	note $14 $02
	duty $12
	note $14 $04
	duty $0f
	note $14 $08
	duty $12
	note $14 $04
	duty $0f
	note $14 $02
	duty $12
	note $14 $04
	duty $0f
	note $14 $08
	duty $12
	note $14 $04
	duty $0f
	note $14 $02
	duty $12
	note $14 $04
	duty $0f
	note $14 $08
	duty $12
	note $14 $04
	duty $0f
	note $14 $08
	duty $12
	note $0e $04
	duty $0f
	note $0e $08
	duty $12
	note $14 $04
	duty $0f
	note $14 $02
	duty $12
	note $14 $04
	duty $0f
	note $14 $08
	duty $12
	note $14 $04
	duty $0f
	note $14 $02
	duty $12
	note $14 $04
	duty $0f
	note $14 $08
	duty $12
	note $14 $04
	duty $0f
	note $14 $02
	duty $12
	note $14 $04
	duty $0f
	note $14 $08
	duty $12
	note $14 $04
	duty $0f
	note $14 $02
	duty $12
	note $14 $04
	duty $0f
	note $14 $08
	duty $12
	note $14 $04
	duty $0f
	note $14 $02
	duty $12
	note $0e $04
	duty $0f
	note $0e $02
	duty $12
	note $14 $04
	duty $0f
	note $14 $02
	duty $12
	note $0e $04
	duty $0f
	note $0e $02
	duty $12
	note $14 $04
	duty $0f
	note $14 $02
	duty $12
	note $14 $04
	duty $0f
	note $14 $08
	duty $12
	note $14 $04
	duty $0f
	note $14 $02
	duty $12
	note $14 $04
	duty $0f
	note $14 $08
	duty $12
	note $14 $04
	duty $0f
	note $14 $02
	duty $12
	note $14 $04
	duty $0f
	note $14 $08
	duty $12
	note $14 $04
	duty $0f
	note $14 $02
	duty $12
	note $14 $04
	duty $0f
	note $14 $08
	duty $12
	note $14 $04
	duty $0f
	note $14 $08
	duty $12
	note $0e $04
	duty $0f
	note $0e $08
	duty $12
	note $14 $04
	duty $0f
	note $14 $02
	duty $12
	note $14 $04
	duty $0f
	note $14 $08
	duty $12
	note $14 $04
	duty $0f
	note $14 $02
	duty $12
	note $14 $04
	duty $0f
	note $14 $08
	duty $12
	note $14 $04
	duty $0f
	note $14 $02
	duty $12
	note $14 $04
	duty $0f
	note $14 $08
	duty $12
	note $14 $04
	duty $0f
	note $14 $02
	duty $12
	note $14 $04
	duty $0f
	note $14 $08
	duty $12
	note $14 $04
	duty $0f
	note $14 $02
	duty $12
	note $0e $04
	duty $0f
	note $0e $02
	duty $12
	note $14 $04
	duty $0f
	note $14 $02
	duty $12
	note $0e $04
	duty $0f
	note $0e $02
	duty $12
	note $16 $04
	duty $0f
	note $16 $02
	duty $12
	note $16 $04
	duty $0f
	note $16 $08
	duty $12
	note $16 $04
	duty $0f
	note $16 $02
	duty $12
	note $16 $04
	duty $0f
	note $16 $08
	duty $12
	note $16 $04
	duty $0f
	note $16 $02
	duty $12
	note $16 $04
	duty $0f
	note $16 $08
	duty $12
	note $16 $04
	duty $0f
	note $16 $02
	duty $12
	note $16 $04
	duty $0f
	note $16 $08
	duty $12
	note $16 $04
	duty $0f
	note $16 $08
	duty $12
	note $10 $04
	duty $0f
	note $10 $08
	duty $12
	note $16 $04
	duty $0f
	note $16 $02
	duty $12
	note $16 $04
	duty $0f
	note $16 $08
	duty $12
	note $16 $04
	duty $0f
	note $16 $02
	duty $12
	note $16 $04
	duty $0f
	note $16 $08
	duty $12
	note $16 $04
	duty $0f
	note $16 $02
	duty $12
	note $16 $04
	duty $0f
	note $16 $08
	duty $12
	note $16 $04
	duty $0f
	note $16 $02
	duty $12
	note $16 $04
	duty $0f
	note $16 $08
	duty $12
	note $16 $04
	duty $0f
	note $16 $02
	duty $12
	note $10 $04
	duty $0f
	note $10 $02
	duty $12
	note $16 $04
	duty $0f
	note $16 $02
	duty $12
	note $10 $04
	duty $0f
	note $10 $02
	duty $12
	note $16 $04
	duty $0f
	note $16 $02
	duty $12
	note $16 $04
	duty $0f
	note $16 $08
	duty $12
	note $16 $04
	duty $0f
	note $16 $02
	duty $12
	note $16 $04
	duty $0f
	note $16 $08
	duty $12
	note $16 $04
	duty $0f
	note $16 $02
	duty $12
	note $16 $04
	duty $0f
	note $16 $08
	duty $12
	note $16 $04
	duty $0f
	note $16 $02
	duty $12
	note $16 $04
	duty $0f
	note $16 $08
	duty $12
	note $16 $04
	duty $0f
	note $16 $08
	duty $12
	note $10 $04
	duty $0f
	note $10 $08
	duty $12
	note $16 $04
	duty $0f
	note $16 $02
	duty $12
	note $16 $04
	duty $0f
	note $16 $08
	duty $12
	note $16 $04
	duty $0f
	note $16 $02
	duty $12
	note $16 $04
	duty $0f
	note $16 $08
	duty $12
	note $16 $04
	duty $0f
	note $16 $02
	duty $12
	note $16 $04
	duty $0f
	note $16 $08
	duty $12
	note $16 $04
	duty $0f
	note $16 $02
	duty $12
	note $16 $04
	duty $0f
	note $16 $08
	duty $12
	note $16 $04
	duty $0f
	note $16 $02
	duty $12
	note $10 $04
	duty $0f
	note $10 $02
	duty $12
	note $16 $04
	duty $0f
	note $16 $02
	duty $12
	note $10 $04
	duty $0f
	note $10 $02
	duty $12
	note $1c $12
	note $1b $06
	duty $0f
	note $1b $18
	duty $12
	note $1a $12
	note $19 $06
	duty $0f
	note $19 $18
	duty $12
	note $1c $06
	duty $0f
	note $1c $06
	duty $12
	note $1c $06
	note $1b $06
	duty $0f
	note $1b $18
	duty $12
	note $1a $03
	duty $0f
	note $1a $03
	duty $12
	note $1a $03
	duty $0f
	note $1a $03
	duty $12
	note $1a $06
	note $19 $06
	note $11 $06
	note $10 $06
	note $0f $06
	note $0e $06
	note $0d $06
	note $0e $06
	note $0f $06
	note $10 $06
	note $11 $06
	note $10 $06
	note $0f $06
	note $0d $06
	note $0e $06
	note $0f $06
	note $10 $06
	note $12 $06
	note $13 $06
	note $14 $06
	note $15 $06
	note $16 $06
	note $17 $06
	note $18 $06
	note $19 $06
	note $17 $06
	note $16 $06
	note $15 $06
	note $14 $06
	note $13 $06
	note $14 $06
	note $15 $06
	note $14 $06
	note $13 $06
	note $12 $04
	note $13 $04
	note $14 $04
	note $15 $04
	note $16 $04
	note $17 $04
	note $0f $06
	duty $0f
	note $0f $0c
	duty $12
	note $19 $06
	note $18 $30
	note $26 $06
	note $25 $06
	note $24 $06
	note $23 $06
	note $22 $06
	note $21 $06
	note $20 $06
	note $1f $06
	note $1e $06
	note $1d $06
	note $1c $06
	note $1b $06
	note $1a $06
	note $19 $06
	note $18 $06
	note $17 $06
	note $16 $04
	note $15 $04
	note $14 $04
	note $0f $04
	note $0e $04
	note $0b $04
	goto musice7879
	cmdff
; $e7bfd
; @addr{e7bfd}
sound32Channel6:
musice7bfd:
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
	goto musice7bfd
	cmdff
; $e7e1a
; @addr{e7e1a}
sound06Channel1:
	vibrato $d1
	env $0 $00
	duty $02
	vol $5
	note $4a $02
	vol $4
	note $47 $02
	vol $4
	note $43 $02
	note $41 $02
	vol $4
	note $3e $02
	note $3b $02
	vol $4
	note $39 $02
	vol $4
	note $35 $02
	vol $4
	note $32 $02
	vol $3
	note $2f $02
	vol $3
	note $2b $02
	vol $3
	note $29 $01
	wait1 $01
	duty $01
	vol $6
	note $2f $04
	wait1 $01
	vol $3
	note $2f $03
	vol $6
	note $2f $04
	wait1 $01
	vol $3
	note $2f $03
	vol $6
	note $30 $04
	wait1 $01
	vol $3
	note $30 $03
	vol $6
	note $32 $10
	vol $3
	note $2f $04
	note $32 $04
	vol $6
	note $37 $10
	note $38 $04
	note $39 $04
	note $3a $0c
	vol $3
	note $36 $04
	vol $6
	note $38 $04
	vol $3
	note $3a $04
	vol $6
	note $36 $08
	note $31 $04
	vol $3
	note $36 $04
	vol $6
	note $35 $04
	vol $3
	note $31 $04
	vol $6
	note $33 $14
	note $35 $02
	note $36 $02
	note $38 $0c
	vol $3
	note $33 $04
	vol $6
	note $38 $04
	note $3a $04
	note $3b $08
	note $39 $04
	vol $3
	note $3b $04
	vol $6
	note $37 $04
	vol $3
	note $39 $04
	vol $6
	note $3e $08
	note $3d $04
	vol $3
	note $37 $04
	vol $6
	note $3b $04
	vol $3
	note $3e $04
	vol $6
	note $3d $08
	note $3b $04
	vol $3
	note $3d $04
	vol $6
	note $39 $04
	vol $3
	note $3b $04
	vol $6
	note $40 $08
	note $3d $04
	note $39 $04
	note $38 $04
	note $34 $04
	note $2f $04
	note $31 $04
	note $33 $04
	note $36 $04
	note $3b $04
	note $3d $04
	note $3f $04
	note $40 $04
	note $3f $04
	note $40 $04
	note $3f $04
	note $40 $04
	note $42 $27
	wait1 $01
	vibrato $01
	env $0 $00
	vol $3
	note $42 $04
	wait1 $01
	vol $2
	note $42 $04
	wait1 $01
	vol $1
	note $42 $04
	cmdff
; $e7ef9
; @addr{e7ef9}
sound06Channel0:
	vol $0
	note $20 $03
	vibrato $d1
	env $0 $00
	duty $02
	vol $3
	note $4a $02
	vol $2
	note $47 $02
	note $43 $02
	note $41 $02
	vol $2
	note $3e $02
	note $3b $02
	vol $2
	note $39 $02
	note $35 $02
	vol $2
	note $32 $02
	vol $2
	note $2f $02
	vol $2
	note $2b $01
	vol $3
	note $32 $02
	vol $3
	note $2f $02
	vol $3
	note $2d $02
	vol $3
	note $29 $02
	vol $3
	note $26 $02
	vol $2
	note $23 $01
	wait1 $01
	duty $01
	vol $4
	note $1a $0c
	vol $5
	note $1d $0c
	vol $5
	note $21 $0c
	vol $6
	note $23 $0c
	vol $6
	note $26 $0c
	vol $5
	note $2a $18
	vol $6
	note $25 $18
	vol $5
	note $24 $20
	vol $3
	note $24 $08
	vol $3
	note $27 $02
	vol $3
	note $2c $02
	vol $3
	note $30 $02
	vol $4
	note $33 $02
	vol $6
	note $3e $04
	vol $6
	note $37 $04
	vol $5
	note $34 $04
	vol $5
	note $32 $04
	vol $4
	note $2f $04
	vol $3
	note $2b $04
	note $3b $04
	vol $3
	note $37 $04
	vol $3
	note $34 $04
	vol $3
	note $32 $04
	vol $2
	note $2f $04
	vol $2
	note $2b $04
	vol $6
	note $40 $04
	vol $6
	note $39 $04
	vol $5
	note $34 $04
	vol $5
	note $31 $04
	vol $4
	note $2d $04
	vol $3
	note $28 $04
	vol $3
	note $3d $04
	vol $3
	note $39 $04
	vol $3
	note $34 $04
	vol $3
	note $31 $04
	vol $2
	note $2d $04
	vol $2
	note $28 $04
	vol $6
	note $1e $10
	vol $3
	note $1e $08
	vol $6
	note $23 $04
	note $25 $04
	note $27 $04
	note $2a $04
	note $2f $04
	note $31 $04
	note $33 $28
	wait1 $01
	vol $3
	note $33 $03
	wait1 $01
	vol $2
	note $33 $03
	wait1 $01
	vol $1
	note $33 $03
	cmdff
; $e7fc8
; @addr{e7fc8}
sound06Channel4:
	duty $0e
	note $13 $60
	note $0f $20
	note $11 $08
	note $12 $08
	note $14 $30
	note $10 $20
	note $12 $08
	note $13 $08
	note $15 $30
	note $17 $10
	duty $0f
	note $17 $08
	duty $0e
	note $12 $10
	duty $0f
	note $12 $08
	duty $0e
	note $17 $26
	duty $0f
	note $17 $07
	cmdff
; $e7ff3
; GAP
	cmdff
	cmdff
	cmdff
	cmdff
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
sound41Start:
sound42Start:
; @addr{e8000}
sound00Channel6:
sound01Channel6:
sound09Channel6:
sound0eChannel6:
sound36Channel4:
sound36Channel6:
sound41Channel0:
sound41Channel1:
sound41Channel4:
sound41Channel6:
sound42Channel0:
sound42Channel1:
sound42Channel4:
sound42Channel6:
	cmdff
; $e8001
; @addr{e8001}
sound0eChannel1:
	vibrato $e1
	env $0 $00
	duty $02
musice8007:
	vol $7
	note $3b $0b
	note $3c $0b
	note $3b $0b
	note $3c $0b
	note $3b $0b
	wait1 $05
	vol $3
	note $3b $06
	vol $7
	note $37 $0b
	wait1 $05
	vol $3
	note $37 $06
	vol $7
	note $34 $0b
	wait1 $05
	vol $3
	note $34 $06
	vol $7
	note $37 $0b
	wait1 $05
	vol $3
	note $37 $06
	vol $7
	note $39 $0b
	note $3a $0b
	note $39 $0b
	note $3a $0b
	note $39 $0b
	wait1 $05
	vol $3
	note $39 $06
	vol $6
	note $35 $0b
	wait1 $05
	vol $3
	note $35 $06
	vol $6
	note $32 $0b
	wait1 $05
	vol $3
	note $32 $06
	vol $6
	note $35 $0b
	wait1 $05
	vol $3
	note $35 $06
	vol $7
	note $3b $0b
	note $3c $0b
	note $3b $0b
	note $3c $0b
	note $3b $0b
	wait1 $05
	vol $3
	note $3b $06
	vol $7
	note $37 $0b
	wait1 $05
	vol $3
	note $37 $06
	vol $7
	note $34 $0b
	wait1 $05
	vol $3
	note $34 $06
	vol $7
	note $37 $0b
	wait1 $05
	vol $3
	note $37 $06
	vol $7
	note $39 $0b
	note $3a $0b
	note $39 $0b
	note $3a $0b
	note $39 $0b
	wait1 $05
	vol $3
	note $39 $06
	vol $6
	note $35 $0b
	wait1 $05
	vol $3
	note $35 $06
	vol $6
	note $32 $0b
	wait1 $05
	vol $3
	note $32 $06
	vol $6
	note $35 $0b
	wait1 $05
	vol $3
	note $35 $06
	vol $6
	note $37 $0b
	note $38 $0b
	vol $6
	note $37 $0b
	vol $6
	note $38 $0b
	vol $6
	note $37 $0b
	wait1 $05
	vol $3
	note $37 $06
	vol $6
	note $33 $0b
	wait1 $05
	vol $3
	note $33 $06
	vol $6
	note $30 $0b
	wait1 $05
	vol $3
	note $30 $06
	vol $6
	note $37 $0b
	wait1 $05
	vol $3
	note $37 $06
	vol $6
	note $35 $0b
	note $37 $0b
	note $35 $0b
	note $37 $0b
	vol $5
	note $35 $0b
	wait1 $05
	vol $2
	note $35 $06
	vol $6
	note $32 $0b
	wait1 $05
	vol $3
	note $32 $06
	vol $6
	note $2e $0b
	wait1 $05
	vol $3
	note $2e $06
	vol $6
	note $32 $0b
	wait1 $05
	vol $3
	note $32 $06
	vol $6
	note $30 $42
	vol $6
	note $2d $0b
	wait1 $05
	vol $3
	note $2d $06
	vol $6
	note $30 $0b
	wait1 $05
	vol $3
	note $30 $06
	vol $6
	note $35 $0b
	wait1 $05
	vol $3
	note $35 $06
	vol $8
	note $37 $58
	vol $5
	note $43 $03
	wait1 $03
	vol $4
	note $43 $05
	wait1 $03
	vol $4
	note $43 $03
	wait1 $1b
	goto musice8007
	cmdff
; $e812c
; @addr{e812c}
sound0eChannel4:
	duty $08
musice812e:
	note $37 $0b
	note $39 $0b
	note $37 $0b
	note $39 $0b
	note $37 $03
	wait1 $03
	note $37 $05
	wait1 $03
	vol $4
	note $37 $03
	wait1 $05
	vol $6
	note $34 $03
	wait1 $03
	vol $4
	note $34 $05
	wait1 $03
	vol $4
	note $34 $03
	wait1 $05
	vol $6
	note $2f $03
	wait1 $03
	vol $4
	note $2f $05
	wait1 $03
	vol $4
	note $2f $03
	wait1 $05
	vol $6
	note $2b $03
	wait1 $03
	vol $4
	note $2b $05
	wait1 $03
	vol $4
	note $2b $03
	wait1 $05
	vol $6
	note $35 $0b
	note $37 $0b
	note $35 $0b
	note $37 $0b
	note $35 $03
	wait1 $03
	vol $4
	note $35 $05
	wait1 $03
	vol $4
	note $35 $03
	wait1 $05
	vol $6
	note $32 $03
	wait1 $03
	vol $5
	note $32 $05
	wait1 $03
	vol $4
	note $32 $03
	wait1 $05
	vol $6
	note $2e $03
	wait1 $03
	vol $4
	note $2e $05
	wait1 $03
	vol $3
	note $2e $03
	wait1 $05
	vol $6
	note $29 $03
	wait1 $03
	vol $4
	note $29 $05
	wait1 $03
	vol $3
	note $29 $03
	wait1 $05
	vol $6
	note $37 $0b
	note $39 $0b
	note $37 $0b
	note $39 $0b
	note $37 $03
	wait1 $03
	vol $5
	note $37 $05
	wait1 $03
	vol $4
	note $37 $03
	wait1 $05
	vol $6
	note $34 $03
	wait1 $03
	vol $4
	note $34 $05
	wait1 $03
	vol $4
	note $34 $03
	wait1 $05
	vol $6
	note $2f $03
	wait1 $03
	vol $4
	note $2f $05
	wait1 $03
	vol $4
	note $2f $03
	wait1 $05
	vol $6
	note $2b $03
	wait1 $03
	vol $4
	note $2b $05
	wait1 $03
	vol $4
	note $2b $03
	wait1 $05
	vol $6
	note $35 $0b
	note $37 $0b
	note $35 $0b
	note $37 $0b
	note $35 $03
	wait1 $03
	vol $4
	note $35 $05
	wait1 $03
	vol $4
	note $35 $03
	wait1 $05
	vol $6
	note $32 $03
	wait1 $03
	vol $5
	note $32 $05
	wait1 $03
	vol $4
	note $32 $03
	wait1 $05
	vol $6
	note $2e $03
	wait1 $03
	vol $5
	note $2e $05
	wait1 $03
	vol $4
	note $2e $03
	wait1 $05
	vol $6
	note $29 $03
	wait1 $03
	vol $5
	note $29 $05
	wait1 $03
	vol $3
	note $29 $03
	wait1 $05
	vol $7
	note $33 $0b
	vol $6
	note $35 $0b
	note $33 $0b
	note $35 $0b
	note $33 $03
	wait1 $03
	vol $5
	note $33 $05
	wait1 $03
	vol $3
	note $33 $03
	wait1 $05
	vol $6
	note $30 $03
	wait1 $03
	vol $5
	note $30 $05
	wait1 $03
	vol $3
	note $30 $03
	wait1 $05
	vol $6
	note $2c $03
	wait1 $03
	vol $5
	note $2c $05
	wait1 $03
	vol $4
	note $2c $03
	wait1 $05
	vol $6
	note $27 $03
	wait1 $03
	vol $5
	note $27 $05
	wait1 $03
	vol $4
	note $27 $03
	wait1 $05
	vol $6
	note $32 $0b
	note $33 $0b
	note $32 $0b
	note $33 $0b
	note $32 $03
	wait1 $03
	vol $5
	note $32 $05
	wait1 $03
	vol $4
	note $32 $03
	wait1 $05
	vol $6
	note $2e $03
	wait1 $03
	vol $5
	note $2e $05
	wait1 $03
	vol $4
	note $2e $03
	wait1 $05
	vol $6
	note $29 $03
	wait1 $03
	vol $5
	note $29 $05
	wait1 $03
	vol $4
	note $29 $03
	wait1 $05
	vol $6
	note $26 $03
	wait1 $03
	vol $4
	note $26 $05
	wait1 $03
	vol $3
	note $26 $03
	wait1 $05
	vol $6
	note $27 $0b
	note $26 $0b
	vol $6
	note $24 $03
	wait1 $03
	vol $5
	note $24 $05
	wait1 $03
	vol $3
	note $24 $03
	wait1 $05
	vol $6
	note $27 $03
	wait1 $03
	vol $5
	note $27 $05
	wait1 $03
	vol $3
	note $27 $03
	wait1 $05
	vol $6
	note $29 $03
	wait1 $03
	vol $5
	note $29 $05
	wait1 $03
	vol $5
	note $29 $03
	wait1 $05
	vol $6
	note $2d $03
	wait1 $03
	vol $6
	note $2d $05
	wait1 $03
	vol $5
	note $2d $03
	wait1 $05
	vol $6
	note $30 $03
	wait1 $03
	vol $5
	note $30 $05
	wait1 $03
	vol $4
	note $30 $03
	wait1 $05
	vol $7
	note $2f $0b
	wait1 $03
	vol $6
	note $2f $03
	wait1 $05
	vol $5
	note $2f $03
	wait1 $03
	vol $4
	note $2f $05
	wait1 $0b
	vol $6
	note $30 $0b
	wait1 $03
	vol $5
	note $30 $03
	wait1 $05
	vol $4
	note $30 $03
	wait1 $03
	vol $4
	note $30 $05
	wait1 $0b
	vol $6
	note $32 $07
	wait1 $04
	vol $4
	note $32 $03
	wait1 $03
	vol $4
	note $32 $05
	wait1 $03
	vol $3
	note $32 $03
	wait1 $10
	goto musice812e
	cmdff
; $e8355
; @addr{e8355}
sound0eChannel0:
	duty $02
musice8357:
	vol $6
	note $24 $0b
	vol $3
	note $24 $0b
	vol $6
	note $2b $0b
	vol $3
	note $2b $0b
	vol $6
	note $2f $0b
	vol $3
	note $2f $0b
	vol $6
	note $34 $0b
	vol $3
	note $34 $16
	wait1 $21
	vol $6
	note $22 $0b
	vol $3
	note $22 $0b
	vol $6
	note $29 $0b
	vol $3
	note $29 $0b
	vol $6
	note $2d $0b
	vol $3
	note $2d $0b
	vol $6
	note $32 $0b
	vol $3
	note $32 $16
	wait1 $21
	vol $6
	note $24 $0b
	vol $3
	note $24 $0b
	vol $6
	note $2b $0b
	vol $3
	note $2b $0b
	vol $6
	note $2f $0b
	vol $3
	note $2f $0b
	vol $6
	note $34 $0b
	vol $3
	note $34 $16
	wait1 $21
	vol $6
	note $22 $0b
	vol $3
	note $22 $0b
	vol $6
	note $29 $0b
	vol $3
	note $29 $0b
	vol $6
	note $2d $0b
	vol $3
	note $2d $0b
	vol $6
	note $32 $0b
	vol $3
	note $32 $16
	wait1 $21
	vol $6
	note $20 $0b
	vol $3
	note $20 $0b
	vol $6
	note $27 $0b
	vol $3
	note $27 $0b
	vol $6
	note $2b $0b
	vol $3
	note $2b $0b
	vol $6
	note $30 $0b
	vol $3
	note $30 $16
	wait1 $21
	vol $6
	note $1f $0b
	vol $3
	note $1f $0b
	vol $6
	note $26 $0b
	vol $3
	note $26 $0b
	vol $6
	note $2b $0b
	vol $3
	note $2b $0b
	vol $6
	note $2e $0b
	vol $3
	note $2e $16
	wait1 $21
	vol $6
	note $1d $0b
	vol $3
	note $1d $0b
	vol $6
	note $24 $0b
	vol $3
	note $24 $0b
	vol $6
	note $29 $0b
	vol $3
	note $29 $0b
	vol $6
	note $2d $0b
	vol $3
	note $2d $16
	wait1 $21
	vol $6
	note $1f $0b
	vol $3
	note $1f $0b
	vol $6
	note $23 $0b
	vol $3
	note $23 $0b
	vol $6
	note $26 $0b
	vol $3
	note $26 $0b
	vol $6
	note $2b $0b
	vol $3
	note $2b $0b
	vol $6
	note $26 $0b
	vol $3
	note $26 $0b
	vol $6
	note $23 $0b
	vol $3
	note $23 $0b
	goto musice8357
	cmdff
; $e8435
; GAP
	cmdff
	cmdff
	cmdff
; @addr{e8438}
sound00Channel1:
sound01Channel1:
	duty $02
	vol $8
	note $2e $18
	vol $2
	note $2e $14
	wait1 $10
	env $0 $02
	vol $8
	note $2e $09
	env $0 $03
	vol $4
	note $2e $03
	env $0 $02
	vol $8
	note $2e $09
	env $0 $03
	vol $4
	note $2e $03
	env $0 $00
	vol $8
	note $2e $03
	vol $2
	note $2e $03
	vol $8
	note $2e $02
	vol $2
	note $2e $04
	vol $8
	env $0 $02
	note $2e $09
	env $0 $03
	vol $4
	note $2e $09
	env $0 $00
	vol $8
	env $0 $01
	note $2c $06
	env $0 $00
	note $2e $12
	vol $2
	note $2e $09
	vol $1
	note $2e $09
	vol $8
	env $0 $02
	note $2e $09
	env $0 $03
	vol $4
	note $2e $03
	env $0 $00
	vol $8
	env $0 $02
	note $2e $09
	env $0 $03
	vol $4
	note $2e $03
	env $0 $00
	vol $8
	note $2e $03
	vol $2
	note $2e $03
	vol $8
	note $2e $03
	vol $2
	note $2e $03
	vol $8
	env $0 $02
	note $2e $09
	vol $4
	env $0 $03
	note $2e $09
	env $0 $00
	vol $8
	env $0 $01
	note $2c $06
	env $0 $00
	note $2e $12
	vol $2
	note $2e $09
	vol $1
	note $2e $09
	vol $8
	env $0 $02
	note $2e $09
	env $0 $03
	vol $4
	note $2e $03
	env $0 $00
	vol $8
	env $0 $02
	note $2e $09
	env $0 $03
	vol $4
	note $2e $03
	env $0 $00
	vol $8
	note $2e $03
	vol $2
	note $2e $03
	vol $8
	note $2e $03
	vol $2
	note $2e $03
	vol $a
	env $0 $01
	note $2e $09
	env $0 $03
	vol $3
	note $2e $03
	vol $8
	env $0 $01
	note $29 $06
	note $29 $06
	vol $a
	env $0 $01
	note $29 $08
	env $0 $03
	vol $3
	note $29 $04
	vol $8
	env $0 $01
	note $29 $06
	note $29 $06
	vol $a
	env $0 $01
	note $29 $08
	env $0 $03
	vol $3
	note $29 $04
	vol $8
	env $0 $01
	note $29 $06
	note $29 $06
	vol $8
	env $0 $02
	note $29 $08
	env $0 $03
	vol $3
	note $29 $04
	vol $8
	env $0 $01
	note $29 $09
	env $0 $00
	vol $4
	note $29 $03
musice8529:
	vol $a
	env $0 $01
	note $16 $0c
	note $22 $18
	note $22 $0c
	env $0 $02
	note $16 $0c
	env $0 $01
	note $22 $18
	note $22 $0c
	note $14 $0c
	env $0 $01
	note $20 $18
	note $20 $0c
	note $14 $0c
	env $0 $01
	note $20 $18
	note $20 $0c
	note $12 $0c
	env $0 $01
	note $1e $18
	note $1e $0c
	note $12 $0c
	env $0 $01
	note $1e $18
	note $1e $0c
	note $19 $0c
	env $0 $01
	note $25 $18
	note $25 $0c
	note $19 $0c
	env $0 $01
	note $25 $18
	note $25 $0c
	note $17 $0c
	env $0 $01
	note $23 $18
	note $23 $0c
	note $17 $0c
	env $0 $01
	note $23 $18
	note $23 $0c
	note $16 $0c
	env $0 $01
	note $22 $18
	note $22 $0c
	note $16 $0c
	env $0 $01
	note $22 $18
	note $22 $0c
	note $18 $0c
	note $24 $18
	note $24 $0c
	note $18 $0c
	note $24 $0c
	note $2e $0c
	note $24 $0c
	vibrato $00
	env $0 $03
	note $1d $0c
	vol $8
	env $0 $00
	note $2e $03
	env $0 $01
	vol $4
	note $2e $03
	vol $8
	env $0 $00
	note $2e $03
	env $0 $01
	vol $4
	note $2e $03
	vol $a
	env $0 $00
	note $2e $03
	env $0 $01
	vol $4
	note $2e $03
	env $0 $00
	vol $2
	note $2e $06
	vol $8
	note $2e $03
	env $0 $01
	vol $4
	note $2e $03
	vol $a
	env $0 $00
	note $2e $03
	env $0 $01
	vol $4
	note $2e $03
	env $0 $00
	vol $8
	note $2e $08
	vol $4
	note $2e $04
	vol $8
	note $18 $03
	env $0 $01
	vol $4
	note $18 $03
	vol $8
	env $0 $00
	note $18 $03
	env $0 $01
	vol $4
	note $18 $03
	vol $a
	env $0 $00
	note $18 $03
	env $0 $01
	vol $4
	note $18 $03
	env $0 $00
	vol $2
	note $18 $06
	vol $8
	note $18 $03
	env $0 $01
	vol $4
	note $18 $03
	vol $a
	env $0 $00
	note $18 $03
	env $0 $01
	vol $4
	note $18 $03
	env $0 $00
	vol $8
	note $1d $08
	vol $4
	note $1d $04
	vol $8
	note $2d $03
	env $0 $01
	vol $4
	note $2d $03
	vol $8
	env $0 $00
	note $2d $03
	env $0 $01
	vol $4
	note $2d $03
	vol $a
	env $0 $00
	note $2d $03
	env $0 $01
	vol $4
	note $2d $03
	env $0 $00
	vol $2
	note $2d $06
	vol $8
	note $2d $03
	env $0 $01
	vol $4
	note $2d $03
	vol $a
	env $0 $00
	note $2d $03
	env $0 $01
	vol $4
	note $2d $03
	env $0 $00
	vol $8
	note $2d $08
	vol $4
	note $2d $04
	vol $a
	env $0 $01
	note $11 $06
	vol $a
	note $11 $06
	vol $a
	note $11 $06
	vol $a
	note $12 $05
	vol $1
	note $12 $01
	vol $a
	note $13 $05
	vol $1
	note $13 $01
	vol $a
	note $15 $05
	vol $1
	note $15 $01
	goto musice8529
	cmdff
; $e8674
; @addr{e8674}
sound00Channel0:
sound01Channel0:
	duty $02
	vol $8
	note $26 $18
	vol $2
	note $26 $14
	wait1 $10
	vol $8
	env $0 $02
	note $26 $09
	env $0 $04
	vol $3
	note $26 $03
	vol $8
	env $0 $02
	note $26 $09
	env $0 $04
	vol $3
	note $26 $03
	vol $8
	note $26 $03
	vol $2
	note $26 $03
	vol $8
	note $26 $03
	vol $2
	note $26 $03
	vol $8
	env $0 $02
	note $24 $09
	env $0 $04
	vol $3
	note $24 $09
	env $0 $00
	vol $8
	note $24 $04
	vol $2
	note $24 $02
	vol $7
	note $24 $12
	vol $3
	note $24 $09
	vol $1
	note $24 $09
	vol $8
	vol $8
	env $0 $02
	note $24 $09
	env $0 $04
	vol $3
	note $24 $03
	vol $8
	env $0 $02
	note $24 $09
	env $0 $04
	vol $3
	note $24 $03
	vol $8
	env $0 $01
	note $24 $06
	env $0 $01
	note $24 $06
	vol $8
	env $0 $02
	note $25 $09
	env $0 $03
	vol $4
	note $25 $09
	vol $8
	env $0 $00
	note $25 $03
	vol $2
	note $25 $03
	vol $7
	note $25 $12
	vol $3
	note $25 $09
	vol $1
	note $25 $09
	vol $8
	env $0 $02
	note $25 $09
	env $0 $04
	vol $3
	note $25 $03
	vol $8
	env $0 $02
	note $25 $09
	env $0 $04
	vol $3
	note $25 $03
	env $0 $00
	vol $8
	note $25 $03
	vol $2
	note $25 $03
	vol $8
	note $25 $03
	vol $2
	note $25 $03
	vol $a
	env $0 $01
	note $25 $09
	env $0 $03
	vol $3
	note $25 $03
	env $0 $00
	vol $8
	env $0 $01
	note $21 $06
	env $0 $01
	note $21 $06
	vol $a
	env $0 $01
	note $21 $08
	env $0 $03
	vol $3
	note $21 $04
	vol $8
	env $0 $01
	note $21 $06
	env $0 $01
	note $21 $06
	vol $a
	env $0 $01
	note $21 $08
	env $0 $03
	vol $3
	note $21 $04
	vol $8
	env $0 $01
	note $21 $06
	env $0 $01
	note $21 $06
	vibrato $00
	vol $8
	env $0 $02
	note $21 $09
	env $0 $03
	vol $3
	note $21 $03
	vol $8
	env $0 $02
	note $21 $09
	env $0 $03
	vol $3
	note $21 $03
musice8765:
	vol $0
	note $20 $6c
	env $0 $00
	vol $6
	note $3a $06
	wait1 $06
	note $3a $03
	wait1 $03
	note $3c $03
	wait1 $03
	note $3e $03
	wait1 $03
	note $3f $03
	wait1 $03
	env $0 $07
	note $41 $48
	env $0 $00
	note $3d $03
	wait1 $03
	note $42 $03
	wait1 $03
	note $44 $03
	wait1 $03
	note $46 $03
	wait1 $03
	env $0 $07
	note $49 $54
	env $0 $00
	note $3d $03
	wait1 $03
	note $3f $03
	wait1 $03
	note $41 $06
	wait1 $06
	note $3d $06
	wait1 $06
	env $0 $07
	note $38 $3c
	env $0 $00
	note $3f $02
	wait1 $04
	note $41 $02
	wait1 $04
	note $42 $02
	wait1 $0a
	note $3f $02
	wait1 $04
	note $41 $02
	wait1 $04
	env $0 $04
	note $42 $3c
	env $0 $00
	note $3d $02
	wait1 $04
	note $3f $02
	wait1 $04
	note $41 $02
	wait1 $0a
	note $3d $02
	wait1 $04
	note $3f $02
	wait1 $04
	env $0 $04
	note $41 $3c
	env $0 $00
	note $3c $02
	wait1 $04
	note $3e $02
	wait1 $04
	note $40 $02
	wait1 $0a
	note $40 $02
	wait1 $04
	note $41 $02
	wait1 $04
	note $43 $02
	wait1 $04
	note $45 $02
	wait1 $04
	note $46 $02
	wait1 $04
	note $48 $02
	wait1 $04
	note $45 $06
	wait1 $06
	vol $8
	note $27 $03
	vol $2
	note $27 $03
	vol $8
	note $27 $03
	vol $2
	note $27 $03
	vol $a
	note $27 $03
	vol $2
	note $27 $03
	vol $1
	note $27 $06
	vol $8
	note $27 $03
	vol $2
	note $27 $03
	vol $8
	note $27 $03
	vol $2
	note $27 $03
	vol $a
	note $27 $08
	vol $3
	note $27 $0a
	vol $1
	note $27 $0a
	wait1 $20
	vol $8
	note $27 $03
	vol $2
	note $27 $03
	vol $8
	note $27 $03
	vol $2
	note $27 $03
	vol $a
	note $27 $03
	vol $2
	note $27 $03
	vol $1
	note $27 $06
	vol $8
	note $27 $03
	vol $2
	note $27 $03
	vol $8
	note $27 $03
	vol $2
	note $27 $03
	vol $a
	note $27 $08
	vol $3
	note $27 $0a
	vol $1
	note $27 $0a
	wait1 $14
	goto musice8765
	cmdff
; $e8869
; @addr{e8869}
sound00Channel4:
sound01Channel4:
	wait1 $24
	duty $0e
	note $16 $05
	duty $0f
	note $16 $01
	duty $0e
	note $16 $05
	duty $0f
	note $16 $01
	duty $0e
	note $16 $0c
	duty $0f
	note $16 $12
	wait1 $36
	duty $0e
	note $14 $05
	duty $0f
	note $14 $01
	duty $0e
	note $14 $05
	duty $0f
	note $14 $01
	duty $0e
	note $14 $0c
	duty $0f
	note $14 $12
	wait1 $36
	duty $0e
	note $12 $05
	duty $0f
	note $12 $01
	duty $0e
	note $12 $05
	duty $0f
	note $12 $01
	duty $0e
	note $12 $0c
	duty $0f
	note $12 $12
	wait1 $5a
	duty $0e
	note $11 $0c
	duty $0e
	note $13 $05
	duty $0f
	note $13 $01
	duty $0e
	note $15 $05
	duty $0f
	note $15 $01
musice88cd:
	duty $01
	note $2e $06
	wait1 $12
	note $29 $1e
	wait1 $0c
	note $2e $04
	wait1 $02
	note $2e $06
	note $30 $03
	wait1 $03
	note $32 $03
	wait1 $03
	note $33 $03
	wait1 $03
	note $35 $2a
	wait1 $12
	note $35 $09
	wait1 $03
	note $35 $0c
	note $36 $03
	wait1 $03
	note $38 $03
	wait1 $03
	note $3a $2a
	wait1 $12
	note $3a $09
	wait1 $03
	note $3a $0c
	note $38 $03
	wait1 $03
	note $36 $03
	wait1 $03
	note $38 $06
	wait1 $0c
	note $36 $06
	note $35 $24
	wait1 $0c
	note $35 $18
	note $33 $0c
	wait1 $06
	note $35 $06
	note $36 $24
	wait1 $0c
	note $35 $0c
	note $33 $0c
	note $31 $0c
	wait1 $06
	note $33 $06
	note $35 $24
	wait1 $0c
	note $33 $0c
	note $31 $0c
	note $30 $0c
	wait1 $06
	note $32 $06
	note $34 $24
	wait1 $0c
	note $37 $18
	note $35 $08
	wait1 $b8
	goto musice88cd
	cmdff
; $e8949
sound2dStart:
; @addr{e8949}
sound2dChannel1:
	duty $02
	vol $7
	note $43 $03
	vol $6
	note $42 $03
	vol $5
	note $41 $03
	note $40 $03
	note $3f $03
	note $3e $03
	vol $6
	note $3d $03
	note $3c $03
	note $3b $03
	note $3a $03
	vol $7
	note $39 $03
	note $38 $03
	note $37 $03
	vol $8
	note $36 $03
	note $35 $03
	vol $7
	note $34 $03
	env $0 $02
	vol $c
	duty $00
	note $23 $06
	note $23 $06
	note $23 $06
	vol $b
	env $0 $01
	note $22 $06
	wait1 $18
	env $0 $04
	note $21 $12
	env $0 $02
	note $20 $12
	wait1 $0c
	note $23 $06
	note $23 $06
	note $23 $06
	env $0 $01
	note $22 $06
	wait1 $18
	env $0 $04
	note $21 $12
	env $0 $02
	note $20 $12
	wait1 $0c
musice89a4:
	note $25 $06
	note $25 $06
	note $25 $06
	env $0 $01
	vol $a
	note $24 $06
	wait1 $18
	env $0 $04
	note $23 $12
	env $0 $02
	note $22 $12
	wait1 $0c
	note $25 $06
	note $25 $06
	note $25 $06
	vol $b
	env $0 $01
	vol $a
	note $24 $06
	wait1 $18
	env $0 $04
	note $23 $12
	env $0 $02
	note $22 $12
	wait1 $0c
	env $0 $00
	duty $01
	vol $5
	note $34 $12
	note $33 $12
	note $34 $06
	note $35 $06
	note $36 $06
	note $37 $06
	env $0 $02
	duty $00
	vol $a
	note $27 $06
	note $27 $06
	note $27 $06
	vol $b
	env $0 $01
	vol $a
	note $26 $06
	wait1 $18
	env $0 $04
	note $25 $12
	env $0 $02
	note $24 $12
	wait1 $0c
	note $27 $06
	note $27 $06
	note $27 $06
	vol $b
	env $0 $01
	vol $a
	note $26 $06
	wait1 $18
	env $0 $04
	note $25 $12
	env $0 $02
	note $24 $12
	wait1 $0c
	note $29 $06
	note $29 $06
	note $29 $06
	vol $b
	env $0 $01
	vol $a
	note $28 $06
	wait1 $18
	env $0 $04
	note $27 $12
	env $0 $02
	note $26 $12
	wait1 $0c
	note $29 $06
	note $29 $06
	note $29 $06
	vol $b
	env $0 $01
	vol $a
	note $28 $06
	wait1 $18
	env $0 $04
	note $27 $12
	env $0 $02
	note $26 $12
	wait1 $6c
	env $0 $00
	duty $02
	note $43 $03
	vol $6
	note $42 $03
	vol $5
	note $41 $03
	note $40 $03
	note $3f $03
	note $3e $03
	note $3d $03
	vol $6
	note $3c $03
	note $3b $03
	note $3a $03
	vol $7
	note $39 $03
	note $38 $03
	note $37 $03
	vol $8
	note $36 $03
	note $35 $03
	vol $7
	note $34 $03
	env $0 $02
	duty $00
	vol $b
	note $23 $06
	note $23 $06
	note $23 $06
	env $0 $01
	note $22 $06
	wait1 $18
	env $0 $04
	note $21 $12
	env $0 $02
	note $20 $12
	wait1 $0c
	note $23 $06
	note $23 $06
	note $23 $06
	vol $b
	env $0 $01
	vol $a
	note $22 $06
	wait1 $18
	env $0 $04
	note $21 $12
	env $0 $02
	note $20 $12
	wait1 $0c
	goto musice89a4
	cmdff
; $e8aaa
; @addr{e8aaa}
sound2dChannel0:
	duty $02
	vol $7
	note $3e $03
	vol $6
	note $3d $03
	vol $5
	note $3c $03
	note $3b $03
	note $3a $03
	note $39 $03
	vol $6
	note $38 $03
	note $37 $03
	note $36 $03
	note $35 $03
	vol $7
	note $34 $03
	note $33 $03
	note $32 $03
	vol $8
	note $31 $03
	note $30 $03
	note $2f $03
	env $0 $02
	duty $00
	note $1c $06
	note $1c $06
	note $1c $06
	vol $9
	env $0 $01
	vol $8
	note $1b $06
	wait1 $18
	env $0 $04
	note $1a $12
	env $0 $02
	note $19 $12
	wait1 $0c
	env $0 $02
	note $1c $06
	note $1c $06
	note $1c $06
	vol $9
	env $0 $01
	note $1b $06
	wait1 $18
	env $0 $04
	note $1a $12
	env $0 $02
	note $19 $12
	wait1 $0c
musice8b07:
	note $1e $06
	note $1e $06
	note $1e $06
	vol $9
	env $0 $01
	note $1d $06
	wait1 $18
	env $0 $04
	note $1c $12
	env $0 $02
	note $1b $12
	wait1 $0c
	note $1e $06
	note $1e $06
	note $1e $06
	vol $9
	env $0 $01
	vol $8
	note $1d $06
	wait1 $18
	env $0 $04
	note $1c $12
	env $0 $02
	note $1b $12
	wait1 $0c
	env $0 $00
	duty $02
	vol $9
	note $18 $12
	note $17 $12
	note $18 $06
	note $19 $06
	note $1a $06
	note $1b $06
	env $0 $02
	duty $00
	vol $8
	note $20 $06
	note $20 $06
	note $20 $06
	vol $a
	env $0 $01
	vol $9
	note $1f $06
	wait1 $18
	env $0 $04
	note $1e $12
	env $0 $02
	note $1d $12
	wait1 $0c
	note $20 $06
	note $20 $06
	note $20 $06
	vol $9
	env $0 $01
	vol $8
	note $1f $06
	wait1 $18
	env $0 $04
	note $1e $12
	env $0 $02
	note $1d $12
	wait1 $0c
	note $22 $06
	note $22 $06
	note $22 $06
	vol $9
	env $0 $01
	vol $8
	note $21 $06
	wait1 $18
	env $0 $04
	note $20 $12
	env $0 $02
	note $1f $12
	wait1 $0c
	note $22 $06
	note $22 $06
	note $22 $06
	vol $9
	env $0 $01
	vol $8
	note $21 $06
	wait1 $18
	env $0 $04
	note $20 $12
	env $0 $02
	note $1f $12
	wait1 $6c
	env $0 $00
	duty $02
	note $3e $03
	vol $6
	note $3d $03
	vol $5
	note $3c $03
	note $3b $03
	note $3a $03
	note $39 $03
	vol $6
	note $38 $03
	note $37 $03
	note $36 $03
	note $35 $03
	vol $7
	note $34 $03
	note $33 $03
	note $32 $03
	vol $8
	note $31 $03
	note $30 $03
	vol $7
	note $2f $03
	env $0 $02
	vol $9
	duty $00
	note $1c $06
	note $1c $06
	note $1c $06
	env $0 $01
	vol $8
	note $1b $06
	wait1 $18
	env $0 $04
	note $1a $12
	env $0 $02
	note $19 $12
	wait1 $0c
	note $1c $06
	note $1c $06
	note $1c $06
	vol $9
	env $0 $01
	vol $8
	note $1b $06
	wait1 $18
	env $0 $04
	note $1a $12
	env $0 $02
	note $19 $12
	wait1 $0c
	env $0 $04
	goto musice8b07
	cmdff
; $e8c10
; @addr{e8c10}
sound2dChannel4:
	duty $12
	wait1 $30
	note $17 $06
	note $12 $06
	note $17 $06
	note $12 $06
	note $17 $06
	note $12 $06
	note $17 $06
	note $12 $06
	note $17 $06
	note $12 $06
	note $17 $06
	note $12 $06
	note $17 $06
	note $12 $06
	note $17 $06
	note $12 $06
	note $17 $06
	note $12 $06
	note $17 $06
	note $12 $06
	note $17 $06
	note $12 $06
	note $17 $06
	note $12 $06
	note $17 $06
	note $12 $06
	note $17 $06
	note $12 $06
	note $17 $06
	note $12 $06
	note $17 $06
	note $12 $06
musice8c54:
	duty $12
	note $0d $06
	note $19 $06
	note $0d $06
	note $19 $06
	note $0d $06
	note $19 $06
	note $0d $06
	note $19 $06
	note $0d $06
	note $19 $06
	note $0d $06
	note $19 $06
	note $0d $06
	note $19 $06
	note $0d $06
	note $19 $06
	note $0d $06
	note $19 $06
	note $0d $06
	note $19 $06
	note $0d $06
	note $19 $06
	note $0d $06
	note $19 $06
	note $0d $06
	note $19 $06
	note $0d $06
	note $19 $06
	note $0d $06
	note $19 $06
	note $0d $06
	note $19 $06
	duty $01
	note $2f $12
	note $2e $12
	note $2f $06
	note $30 $06
	note $31 $06
	note $32 $06
	duty $12
	note $0f $06
	note $09 $06
	note $0f $06
	note $09 $06
	note $0f $06
	note $09 $06
	note $0f $06
	note $09 $06
	note $0f $06
	note $09 $06
	note $0f $06
	note $09 $06
	note $0f $06
	note $09 $06
	note $0f $06
	note $09 $06
	note $0f $06
	note $09 $06
	note $0f $06
	note $09 $06
	note $0f $06
	note $09 $06
	note $0f $06
	note $09 $06
	note $0f $06
	note $09 $06
	note $0f $06
	note $09 $06
	note $0f $06
	note $09 $06
	note $0f $06
	note $09 $06
	note $05 $06
	note $11 $06
	note $05 $06
	note $11 $06
	note $05 $06
	note $11 $06
	note $05 $06
	note $11 $06
	note $05 $06
	note $11 $06
	note $05 $06
	note $11 $06
	note $05 $06
	note $11 $06
	note $05 $06
	note $11 $06
	note $05 $06
	note $11 $06
	note $05 $06
	note $11 $06
	note $05 $06
	note $11 $06
	note $05 $06
	note $11 $06
	note $05 $06
	note $11 $06
	note $05 $06
	note $11 $06
	note $05 $06
	note $11 $06
	note $05 $06
	note $11 $06
	wait1 $90
	note $17 $06
	note $12 $06
	note $17 $06
	note $12 $06
	note $17 $06
	note $12 $06
	note $17 $06
	note $12 $06
	note $17 $06
	note $12 $06
	note $17 $06
	note $12 $06
	note $17 $06
	note $12 $06
	note $17 $06
	note $12 $06
	note $17 $06
	note $12 $06
	note $17 $06
	note $12 $06
	note $17 $06
	note $12 $06
	note $17 $06
	note $12 $06
	note $17 $06
	note $12 $06
	note $17 $06
	note $12 $06
	note $17 $06
	note $12 $06
	note $17 $06
	note $12 $06
	goto musice8c54
	cmdff
; $e8d6c
; @addr{e8d6c}
sound2dChannel6:
	wait1 $30
	vol $3
	note $52 $04
	wait1 $02
	note $52 $04
	wait1 $02
	vol $8
	note $28 $01
	vol $2
	note $27 $08
	wait1 $03
	vol $3
	note $52 $04
	wait1 $02
	note $52 $04
	wait1 $02
	vol $8
	note $28 $01
	vol $2
	note $27 $08
	wait1 $03
	vol $3
	note $52 $04
	wait1 $02
	note $52 $04
	wait1 $02
	vol $8
	note $28 $01
	vol $2
	note $27 $08
	wait1 $03
	vol $3
	note $52 $04
	wait1 $02
	note $52 $04
	wait1 $02
	vol $8
	note $28 $01
	vol $2
	note $27 $08
	wait1 $03
	vol $3
	note $52 $04
	wait1 $02
	note $52 $04
	wait1 $02
	vol $8
	note $28 $01
	vol $2
	note $27 $08
	wait1 $03
	vol $3
	note $52 $04
	wait1 $02
	note $52 $04
	wait1 $02
	vol $8
	note $28 $01
	vol $2
	note $27 $08
	wait1 $03
	vol $3
	note $52 $04
	wait1 $02
	vol $8
	note $28 $01
	vol $2
	note $27 $08
	wait1 $03
	vol $8
	note $28 $01
	vol $2
	note $27 $03
	wait1 $02
	vol $8
	note $28 $01
	vol $2
	note $27 $03
	wait1 $02
	vol $8
	note $1c $01
	vol $2
	note $27 $03
	wait1 $02
	vol $9
	note $28 $01
	vol $1
	note $27 $03
	wait1 $02
	vol $8
	note $28 $01
	vol $2
	note $27 $03
	wait1 $02
musice8e09:
	vol $3
	note $52 $04
	wait1 $02
	note $52 $04
	wait1 $02
	vol $8
	note $28 $01
	vol $2
	note $27 $08
	wait1 $03
	vol $3
	note $52 $04
	wait1 $02
	note $52 $04
	wait1 $02
	vol $8
	note $28 $01
	vol $2
	note $27 $08
	wait1 $03
	vol $3
	note $52 $04
	wait1 $02
	note $52 $04
	wait1 $02
	vol $8
	note $28 $01
	vol $2
	note $27 $08
	wait1 $03
	vol $3
	note $52 $04
	wait1 $02
	note $52 $04
	wait1 $02
	vol $8
	note $28 $01
	vol $2
	note $27 $08
	wait1 $03
	vol $3
	note $52 $04
	wait1 $02
	note $52 $04
	wait1 $02
	vol $8
	note $28 $01
	vol $2
	note $27 $08
	wait1 $03
	vol $3
	note $52 $04
	wait1 $02
	note $52 $04
	wait1 $02
	vol $8
	note $28 $01
	vol $2
	note $27 $08
	wait1 $03
	vol $3
	note $52 $04
	wait1 $02
	vol $8
	note $28 $01
	vol $2
	note $27 $08
	wait1 $03
	vol $8
	note $28 $01
	vol $2
	note $27 $03
	wait1 $02
	vol $8
	note $28 $01
	vol $2
	note $27 $03
	wait1 $02
	vol $8
	note $28 $01
	vol $2
	note $27 $03
	wait1 $02
	vol $6
	note $28 $01
	vol $1
	note $27 $03
	wait1 $02
	vol $8
	note $28 $01
	vol $2
	note $27 $03
	wait1 $02
	vol $8
	note $28 $01
	vol $2
	note $27 $03
	wait1 $02
	vol $6
	note $28 $01
	vol $1
	note $27 $03
	wait1 $02
	vol $6
	note $28 $01
	vol $1
	note $27 $03
	wait1 $02
	vol $8
	note $28 $01
	vol $2
	note $27 $03
	wait1 $02
	vol $6
	note $28 $01
	vol $1
	note $27 $03
	wait1 $02
	vol $6
	note $28 $01
	vol $2
	note $27 $03
	wait1 $02
	vol $8
	note $28 $01
	vol $2
	note $27 $03
	wait1 $02
	vol $8
	note $28 $01
	vol $2
	note $27 $03
	wait1 $02
	vol $c
	note $28 $01
	vol $2
	note $27 $03
	wait1 $02
	vol $d
	note $28 $01
	vol $2
	note $27 $03
	wait1 $02
	vol $3
	note $52 $04
	wait1 $02
	note $52 $04
	wait1 $02
	vol $8
	note $28 $01
	vol $2
	note $27 $08
	wait1 $03
	vol $3
	note $52 $04
	wait1 $02
	note $52 $04
	wait1 $02
	vol $8
	note $28 $01
	vol $2
	note $27 $08
	wait1 $03
	vol $3
	note $52 $04
	wait1 $02
	note $52 $04
	wait1 $02
	vol $8
	note $28 $01
	vol $2
	note $27 $08
	wait1 $03
	vol $3
	note $52 $04
	wait1 $02
	note $52 $04
	wait1 $02
	vol $8
	note $28 $01
	vol $2
	note $27 $08
	wait1 $03
	vol $3
	note $52 $04
	wait1 $02
	note $52 $04
	wait1 $02
	vol $8
	note $28 $01
	vol $2
	note $27 $08
	wait1 $03
	vol $3
	note $52 $04
	wait1 $02
	note $52 $04
	wait1 $02
	vol $8
	note $28 $01
	vol $2
	note $27 $08
	wait1 $03
	vol $3
	note $52 $04
	wait1 $02
	vol $8
	note $28 $01
	vol $2
	note $27 $08
	wait1 $03
	vol $8
	note $28 $01
	vol $2
	note $27 $03
	wait1 $02
	vol $8
	note $28 $01
	vol $2
	note $27 $03
	wait1 $02
	vol $8
	note $28 $01
	vol $2
	note $27 $03
	wait1 $02
	vol $9
	note $28 $01
	vol $2
	note $27 $03
	wait1 $02
	vol $8
	note $28 $01
	vol $2
	note $27 $03
	wait1 $02
	vol $3
	note $52 $04
	wait1 $02
	note $52 $04
	wait1 $02
	vol $8
	note $28 $01
	vol $2
	note $27 $08
	wait1 $03
	vol $3
	note $52 $04
	wait1 $02
	note $52 $04
	wait1 $02
	vol $8
	note $28 $01
	vol $2
	note $27 $08
	wait1 $03
	vol $3
	note $52 $04
	wait1 $02
	note $52 $04
	wait1 $02
	vol $8
	note $28 $01
	vol $2
	note $27 $08
	wait1 $03
	vol $3
	note $52 $04
	wait1 $02
	note $52 $04
	wait1 $02
	vol $8
	note $28 $01
	vol $2
	note $27 $08
	wait1 $03
	vol $3
	note $52 $04
	wait1 $02
	note $52 $04
	wait1 $02
	vol $8
	note $28 $01
	vol $2
	note $27 $08
	wait1 $03
	vol $3
	note $52 $04
	wait1 $02
	note $52 $04
	wait1 $02
	vol $8
	note $28 $01
	vol $2
	note $27 $08
	wait1 $03
	vol $3
	note $52 $04
	wait1 $02
	vol $8
	note $28 $01
	vol $2
	note $27 $08
	wait1 $03
	vol $8
	note $28 $01
	vol $2
	note $27 $03
	wait1 $02
	vol $8
	note $28 $01
	vol $2
	note $27 $03
	wait1 $02
	vol $8
	note $28 $01
	vol $2
	note $27 $03
	wait1 $02
	vol $9
	note $28 $01
	vol $2
	note $27 $03
	wait1 $02
	vol $8
	note $28 $01
	vol $2
	note $27 $03
	wait1 $02
	vol $8
	note $28 $01
	vol $2
	note $27 $03
	wait1 $02
	vol $8
	note $28 $01
	vol $2
	note $27 $08
	wait1 $03
	vol $4
	note $26 $04
	wait1 $02
	note $26 $09
	wait1 $03
	vol $8
	note $28 $01
	vol $2
	note $27 $03
	wait1 $02
	vol $8
	note $28 $01
	vol $2
	note $27 $03
	wait1 $02
	vol $4
	note $26 $04
	wait1 $02
	note $26 $04
	wait1 $02
	note $26 $04
	wait1 $02
	note $26 $04
	wait1 $02
	vol $7
	note $28 $01
	vol $5
	note $27 $03
	wait1 $02
	vol $9
	note $28 $01
	vol $5
	note $27 $03
	wait1 $02
	vol $8
	note $28 $01
	vol $5
	note $27 $03
	wait1 $02
	vol $d
	note $28 $01
	vol $5
	note $27 $03
	wait1 $32
	vol $3
	note $52 $04
	wait1 $02
	note $52 $04
	wait1 $02
	vol $8
	note $28 $01
	vol $2
	note $27 $08
	wait1 $03
	vol $3
	note $52 $04
	wait1 $02
	note $52 $04
	wait1 $02
	vol $8
	note $28 $01
	vol $2
	note $27 $08
	wait1 $03
	vol $3
	note $52 $04
	wait1 $02
	note $52 $04
	wait1 $02
	vol $8
	note $28 $01
	vol $2
	note $27 $08
	wait1 $03
	vol $3
	note $52 $04
	wait1 $02
	note $52 $04
	wait1 $02
	vol $8
	note $28 $01
	vol $2
	note $27 $08
	wait1 $03
	vol $3
	note $52 $04
	wait1 $02
	note $52 $04
	wait1 $02
	vol $8
	note $28 $01
	vol $2
	note $27 $08
	wait1 $03
	vol $3
	note $52 $04
	wait1 $02
	note $52 $04
	wait1 $02
	vol $8
	note $28 $01
	vol $2
	note $27 $08
	wait1 $03
	vol $3
	note $52 $04
	wait1 $02
	vol $8
	note $28 $01
	vol $2
	note $27 $08
	wait1 $03
	vol $8
	note $28 $01
	vol $2
	note $27 $03
	wait1 $02
	vol $8
	note $28 $01
	vol $2
	note $27 $03
	wait1 $02
	vol $8
	note $28 $01
	vol $2
	note $27 $03
	wait1 $02
	vol $7
	note $28 $01
	vol $2
	note $27 $03
	wait1 $02
	vol $8
	note $28 $01
	vol $2
	note $27 $03
	wait1 $02
	goto musice8e09
	cmdff
; $e9123
; @addr{e9123}
sound09Channel1:
	duty $02
	env $0 $03
musice9127:
	vol $8
	note $40 $09
	wait1 $04
	vol $5
	note $40 $09
	wait1 $05
	vol $2
	note $40 $09
	vol $8
	note $3b $09
	wait1 $04
	vol $5
	note $3b $09
	wait1 $05
	vol $2
	note $3b $09
	wait1 $24
	vol $8
	note $40 $04
	wait1 $05
	note $42 $04
	wait1 $05
	note $44 $04
	wait1 $05
	note $45 $04
	wait1 $05
	note $47 $09
	wait1 $04
	vol $5
	note $47 $09
	wait1 $05
	vol $2
	note $47 $09
	wait1 $04
	vol $1
	note $47 $09
	wait1 $3b
	vol $8
	note $47 $09
	wait1 $04
	vol $5
	note $47 $05
	vol $8
	note $48 $09
	note $4a $09
	note $4c $09
	wait1 $04
	vol $5
	note $4c $09
	wait1 $05
	vol $2
	note $4c $09
	wait1 $04
	vol $1
	note $4c $09
	wait1 $3b
	vol $8
	note $4c $09
	wait1 $04
	vol $5
	note $4c $05
	vol $8
	note $4a $09
	note $48 $09
	note $47 $09
	wait1 $04
	vol $5
	note $47 $09
	wait1 $05
	vol $2
	note $47 $09
	wait1 $04
	vol $1
	note $47 $09
	wait1 $3b
	vol $8
	note $47 $09
	wait1 $04
	vol $5
	note $47 $09
	wait1 $05
	vol $2
	note $47 $09
	vol $8
	note $45 $09
	wait1 $04
	vol $5
	note $45 $05
	vol $8
	note $47 $09
	wait1 $04
	vol $5
	note $47 $05
	vol $8
	note $48 $09
	wait1 $04
	vol $5
	note $48 $09
	wait1 $05
	vol $2
	note $48 $09
	wait1 $04
	vol $1
	note $48 $09
	wait1 $17
	vol $8
	note $47 $09
	wait1 $04
	vol $5
	note $47 $05
	vol $8
	note $45 $09
	wait1 $04
	vol $5
	note $45 $05
	vol $8
	note $43 $09
	wait1 $04
	vol $5
	note $43 $05
	vol $8
	note $45 $09
	wait1 $04
	vol $5
	note $45 $05
	vol $8
	note $47 $09
	wait1 $04
	vol $5
	note $47 $09
	wait1 $05
	vol $2
	note $47 $09
	wait1 $24
	vol $8
	note $45 $09
	wait1 $04
	vol $5
	note $45 $05
	vol $8
	note $43 $09
	wait1 $04
	vol $5
	note $43 $05
	vol $8
	note $42 $09
	wait1 $04
	vol $5
	note $42 $05
	vol $8
	note $44 $09
	wait1 $04
	vol $5
	note $44 $05
	vol $8
	note $46 $09
	wait1 $04
	vol $5
	note $46 $09
	wait1 $05
	vol $2
	note $46 $09
	wait1 $24
	vol $8
	note $49 $09
	wait1 $04
	vol $5
	note $49 $09
	wait1 $05
	vol $2
	note $49 $09
	vol $8
	note $47 $09
	wait1 $04
	vol $5
	note $47 $09
	wait1 $05
	vol $2
	note $47 $09
	wait1 $04
	vol $1
	note $47 $09
	wait1 $5f
	goto musice9127
	cmdff
; $e925b
; @addr{e925b}
sound09Channel0:
	duty $02
	env $0 $03
musice925f:
	vol $0
	note $20 $12
	vol $6
	note $2c $12
	note $2f $12
	note $34 $12
	note $38 $12
	wait1 $48
	note $2a $12
	note $2f $12
	note $33 $12
	note $36 $12
	note $3b $12
	wait1 $36
	note $34 $12
	note $37 $12
	note $3c $12
	note $40 $12
	note $3c $12
	note $37 $12
	note $34 $12
	wait1 $12
	note $2f $12
	note $34 $12
	note $36 $12
	note $33 $12
	wait1 $36
	note $35 $12
	note $30 $12
	note $35 $12
	note $39 $12
	note $3c $12
	wait1 $36
	note $40 $12
	note $3b $12
	note $37 $12
	note $34 $12
	note $2f $12
	wait1 $12
	note $34 $12
	wait1 $12
	note $36 $12
	note $31 $12
	note $2f $12
	note $31 $12
	note $2e $12
	note $31 $12
	note $2a $12
	note $31 $12
	note $3b $12
	note $2f $12
	note $34 $12
	note $36 $12
	note $33 $12
	wait1 $36
	goto musice925f
	cmdff
; $e92cf
; @addr{e92cf}
sound09Channel4:
musice92cf:
	wait1 $09
	duty $08
	note $40 $12
	wait1 $12
	note $3b $12
	wait1 $36
	note $40 $09
	note $42 $09
	note $44 $09
	note $45 $09
	note $47 $12
	wait1 $5a
	note $47 $12
	note $49 $09
	wait1 $09
	note $4c $12
	wait1 $5a
	note $4c $12
	note $4a $09
	note $48 $09
	note $47 $12
	wait1 $5a
	note $47 $12
	wait1 $12
	note $45 $12
	note $47 $12
	note $48 $12
	wait1 $36
	note $47 $12
	note $45 $12
	note $43 $12
	note $45 $12
	note $47 $12
	wait1 $36
	note $45 $12
	note $43 $12
	note $42 $12
	note $44 $12
	note $46 $12
	wait1 $36
	note $49 $12
	wait1 $12
	note $47 $12
	wait1 $75
	goto musice92cf
	cmdff
; $e932b
; GAP
	cmdff
	cmdff
; @addr{e932d}
sound36Channel1:
	duty $02
musice932f:
	env $0 $06
	vol $6
	note $17 $0c
	note $19 $0c
	note $1a $0c
	env $0 $04
	note $21 $0c
	wait1 $24
	env $0 $05
	note $2f $0c
	note $2f $18
	wait1 $18
	env $0 $06
	note $17 $0c
	note $19 $0c
	note $1a $0c
	env $0 $04
	note $20 $0c
	wait1 $24
	env $0 $05
	note $2e $0c
	note $2e $18
	wait1 $18
	env $0 $06
	note $19 $0c
	note $1b $0c
	note $1c $0c
	env $0 $04
	note $23 $0c
	wait1 $24
	env $0 $05
	note $31 $0c
	note $31 $18
	wait1 $18
	env $0 $06
	note $19 $0c
	note $1b $0c
	note $1c $0c
	env $0 $04
	note $22 $0c
	wait1 $24
	env $0 $05
	note $30 $0c
	note $30 $18
	wait1 $18
	env $0 $06
	note $1e $0c
	note $20 $0c
	note $21 $0c
	env $0 $04
	note $28 $0c
	wait1 $24
	env $0 $05
	note $34 $0c
	env $0 $06
	note $1f $0c
	note $21 $0c
	note $22 $0c
	env $0 $04
	note $29 $0c
	wait1 $24
	env $0 $05
	note $35 $0c
	note $23 $0c
	note $25 $0c
	note $26 $0c
	note $39 $0c
	env $0 $04
	note $38 $0c
	note $37 $0c
	note $36 $0c
	env $0 $00
	vol $5
	note $35 $08
	wait1 $94
	goto musice932f
	cmdff
; $e93c7
; @addr{e93c7}
sound36Channel0:
	duty $02
musice93c9:
	vol $0
	note $20 $16
	env $0 $05
	vol $3
	note $17 $0c
	note $19 $0c
	note $1a $0c
	env $0 $04
	note $21 $0c
	wait1 $0e
	vol $6
	env $0 $03
	note $29 $0c
	note $29 $18
	wait1 $2e
	vol $3
	env $0 $05
	note $17 $0c
	note $19 $0c
	note $1a $0c
	env $0 $04
	note $20 $0c
	wait1 $0e
	vol $6
	env $0 $03
	note $28 $0c
	note $28 $18
	wait1 $2e
	vol $3
	env $0 $05
	note $19 $0c
	note $1b $0c
	note $1c $0c
	env $0 $04
	note $23 $0c
	wait1 $0e
	vol $6
	env $0 $03
	note $2b $0c
	note $2b $18
	wait1 $2e
	vol $3
	env $0 $05
	note $19 $0c
	note $1b $0c
	note $1c $0c
	env $0 $04
	note $22 $0c
	wait1 $0e
	vol $6
	env $0 $03
	note $2a $0c
	note $2a $18
	wait1 $2e
	vol $3
	env $0 $05
	note $1e $0c
	note $20 $0c
	note $21 $0c
	env $0 $04
	note $28 $0c
	wait1 $0e
	vol $6
	env $0 $03
	note $2e $0c
	wait1 $16
	vol $3
	env $0 $05
	note $1f $0c
	note $21 $0c
	note $22 $0c
	env $0 $04
	note $29 $0c
	wait1 $0e
	vol $6
	env $0 $03
	note $2f $0c
	wait1 $16
	vol $3
	env $0 $04
	note $23 $0c
	note $25 $0c
	note $26 $02
	vol $6
	env $0 $04
	note $35 $0c
	note $34 $0c
	note $33 $0c
	env $0 $00
	vol $5
	note $32 $08
	wait1 $94
	goto musice93c9
	cmdff
; $e9475
sound10Start:
; @addr{e9475}
sound10Channel1:
	duty $00
	vol $b
	note $39 $06
	vol $1
	note $39 $04
	vol $b
	note $3a $06
	vol $1
	note $3a $03
	vol $b
	note $3b $06
	vol $1
	note $3b $02
	vol $b
	note $3c $06
	vol $1
	note $3c $02
	vol $b
	note $3d $06
	vol $1
	note $3d $02
	vol $b
	env $0 $00
	vibrato $e1
	note $3e $52
	cmdff
; $e949d
; @addr{e949d}
sound10Channel0:
	duty $00
	vol $c
	note $30 $06
	vol $1
	note $30 $04
	vol $c
	note $31 $06
	vol $1
	note $31 $03
	vol $c
	note $32 $06
	vol $1
	note $32 $02
	vol $c
	note $33 $06
	vol $1
	note $33 $02
	vol $c
	note $34 $06
	vol $1
	note $34 $02
	vol $c
	env $0 $00
	vibrato $e1
	note $35 $52
	cmdff
; $e94c5
; @addr{e94c5}
sound10Channel4:
	duty $0a
	note $1d $06
	wait1 $04
	note $1e $06
	wait1 $03
	note $1f $06
	wait1 $02
	note $20 $06
	wait1 $02
	note $21 $06
	wait1 $02
	note $22 $4b
	cmdff
; $e94de
; @addr{e94de}
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
; $e94f1
sound56Start:
; @addr{e94f1}
sound56Channel2:
	duty $02
	vol $8
	note $3b $04
	vol $6
	note $40 $01
	vol $b
	note $45 $04
	vol $5
	note $3b $04
	vol $4
	note $40 $01
	vol $6
	note $45 $04
	vol $3
	note $3b $04
	vol $2
	note $40 $01
	vol $4
	note $45 $04
	vol $1
	note $3b $04
	vol $1
	note $40 $01
	vol $2
	note $45 $04
	vol $1
	note $3b $04
	note $40 $01
	vol $1
	note $45 $04
	cmdff
; $e9520
sound4dStart:
; @addr{e9520}
sound4dChannel2:
	duty $02
	vol $f
	env $0 $01
	note $42 $08
	note $41 $08
	note $3e $08
	note $3b $08
	note $37 $08
	note $3f $08
	note $43 $08
	env $0 $01
	note $47 $0f
	cmdff
; $e9538
sound4cStart:
; @addr{e9538}
sound4cChannel2:
	duty $01
	vol $b
	note $30 $0a
	note $31 $0a
	note $32 $0a
	note $33 $32
	cmdff
; $e9544
; @addr{e9544}
sound4cChannel3:
	duty $01
	vol $9
	note $39 $0a
	note $3a $0a
	note $3b $0a
	note $3c $32
	cmdff
; $e9550
; @addr{e9550}
sound4cChannel5:
	duty $01
	note $29 $0a
	note $2a $0a
	note $2b $0a
	note $2c $32
	cmdff
; $e955b
; @addr{e955b}
sound4cChannel7:
	cmdf0 $00
	note $00 $50
	cmdff
; $e9560
sound4fStart:
; @addr{e9560}
sound4fChannel2:
	duty $02
	vol $b
	note $2b $02
	note $2f $02
	note $2e $02
	note $30 $02
	vol $a
	note $2f $02
	note $31 $02
	note $30 $02
	note $32 $02
	vol $9
	note $31 $02
	note $33 $02
	note $32 $02
	note $34 $02
	vol $8
	note $33 $02
	note $35 $02
	note $34 $02
	note $36 $02
	vol $7
	note $35 $02
	note $37 $02
	vol $6
	note $36 $02
	note $38 $02
	vol $5
	note $37 $02
	note $39 $02
	vol $4
	note $38 $02
	vol $3
	note $3a $02
	vol $2
	note $3c $02
	vol $1
	note $41 $02
	cmdff
; $e95a2
sound50Start:
; @addr{e95a2}
sound50Channel2:
	duty $00
	vol $d
	note $50 $01
	vol $0
	wait1 $03
	vol $b
	env $0 $01
	note $54 $0a
	cmdff
; $e95b0
sound51Start:
; @addr{e95b0}
sound51Channel2:
	duty $02
	vol $d
	env $1 $00
	cmdf8 $f4
	note $3e $0a
	cmdf8 $00
	vol $8
	env $0 $01
	cmdf8 $e0
	note $30 $08
	cmdff
; $e95c3
sound52Start:
; @addr{e95c3}
sound52Channel2:
	duty $02
	vol $d
	cmdf8 $7f
	note $10 $05
	cmdf8 $00
	env $0 $00
	cmdf8 $81
	note $19 $05
	cmdff
; $e95d3
sound53Start:
; @addr{e95d3}
sound53Channel2:
	duty $02
	vol $c
	env $0 $02
	cmdf8 $10
	note $26 $14
	cmdff
; $e95dd
sound4eStart:
; @addr{e95dd}
sound4eChannel2:
	duty $00
	vol $d
	cmdf8 $81
	note $29 $04
	cmdf8 $00
	vol $c
	note $13 $02
	vol $e
	cmdf8 $7f
	note $13 $07
	cmdff
; $e95ef
sound57Start:
; @addr{e95ef}
sound57Channel2:
	duty $02
	vol $9
	note $32 $01
	note $37 $01
	note $3e $01
	cmdff
; $e95f9
sound58Start:
; @addr{e95f9}
sound58Channel2:
	duty $00
	vol $9
	env $0 $01
	note $46 $0a
	cmdff
; $e9601
sound59Start:
; @addr{e9601}
sound59Channel2:
	duty $02
	vol $9
	cmdf8 $f6
	note $2d $14
	cmdf8 $00
	vol $2
	cmdf8 $f4
	note $2d $14
	cmdff
; $e9610
sound5aStart:
; @addr{e9610}
sound5aChannel2:
	duty $01
	vol $e
	note $1b $02
	vol $0
	wait1 $01
	vol $e
	note $1b $02
	vol $0
	wait1 $0a
	vol $e
	note $1b $02
	vol $0
	wait1 $01
	vol $e
	note $1b $02
	vol $0
	wait1 $01
	vol $e
	note $1b $02
	vol $0
	wait1 $01
	vol $e
	note $1b $02
	vol $0
	wait1 $01
	vol $e
	note $1b $02
	cmdff
; $e963a
sound5bStart:
; @addr{e963a}
sound5bChannel2:
	duty $02
	env $0 $02
	vol $d
	note $42 $10
	vol $b
	note $3e $12
	note $37 $14
	vol $d
	note $43 $18
	cmdff
; $e964a
; @addr{e964a}
sound5bChannel3:
	duty $02
	env $0 $02
	vol $0
	wait1 $08
	vol $c
	note $41 $10
	vol $b
	note $3b $13
	vol $c
	note $3f $16
	env $0 $02
	vol $e
	note $47 $23
	cmdff
; $e9660
sound5eStart:
; @addr{e9660}
sound5eChannel2:
	duty $01
	vol $d
	note $4b $04
	vol $0
	wait1 $01
	vol $d
	note $4d $04
	vol $0
	wait1 $01
	vol $d
	note $4f $04
	vol $0
	wait1 $01
	vol $d
	note $52 $04
	vol $0
	wait1 $02
	vol $6
	note $52 $04
	vol $0
	wait1 $02
	vol $2
	note $52 $04
	cmdff
; $e9684
; GAP
	cmdff
sound5fStart:
; @addr{e9685}
sound5fChannel5:
	cmdfd $fd
	duty $2d
	note $11 $01
	cmdf8 $e7
	note $30 $03
	cmdf8 $00
	cmdfd $00
	cmdff
; $e9694
sound60Start:
; @addr{e9694}
sound60Channel2:
	duty $02
	vol $b
	note $3b $02
	vol $0
	wait1 $02
	vol $d
	note $47 $04
	vol $9
	note $3b $02
	vol $0
	wait1 $02
	vol $6
	note $47 $03
	cmdff
; $e96a9
sound61Start:
; @addr{e96a9}
sound61Channel2:
	duty $00
	env $0 $03
	vol $d
	note $50 $02
	vol $0
	wait1 $01
	vol $f
	note $58 $02
	vol $9
	note $50 $02
	vol $7
	note $58 $03
	vol $4
	note $50 $02
	vol $2
	note $58 $03
	cmdff
; $e96c3
sound62Start:
; @addr{e96c3}
sound62Channel2:
	duty $00
	vol $b
	cmdf8 $05
	note $47 $06
	cmdf8 $00
	vol $4
	cmdf8 $05
	note $47 $0a
	cmdff
; $e96d2
sound7aStart:
; @addr{e96d2}
sound7aChannel7:
	cmdf0 $f0
	note $75 $09
	note $74 $07
	note $75 $09
	note $74 $07
	note $75 $09
	note $74 $07
	note $75 $09
	note $74 $07
	note $75 $09
	note $74 $07
	note $75 $09
	note $74 $07
	note $75 $09
	note $74 $07
	note $75 $09
	note $74 $07
	note $75 $09
	note $74 $07
	note $75 $09
	note $74 $07
	note $75 $09
	note $74 $07
	note $75 $09
	note $74 $07
	note $75 $09
	note $74 $07
	note $75 $09
	note $74 $07
	note $75 $09
	note $74 $07
	note $75 $09
	note $74 $07
	note $75 $03
	cmdff
; $e9717
sound6aStart:
; @addr{e9717}
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
; $e9728
sound6bStart:
; @addr{e9728}
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
; $e976d
sound6cStart:
; @addr{e976d}
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
; $e9782
sound6dStart:
; @addr{e9782}
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
; $e97a7
sound6eStart:
; @addr{e97a7}
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
; $e97c4
sound79Start:
; @addr{e97c4}
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
; $e980f
sound78Start:
; @addr{e980f}
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
; $e9824
sound77Start:
; @addr{e9824}
sound77Channel2:
	duty $00
	vol $d
	cmdf8 $00
	env $0 $01
	note $48 $0f
	vol $6
	env $0 $02
	note $48 $0f
	cmdff
; $e9833
sound76Start:
; @addr{e9833}
sound76Channel2:
	duty $00
	vol $0
	cmdf8 $00
	env $0 $00
	note $48 $01
	vol $f
	cmdf8 $00
	env $0 $01
	note $0c $01
	vol $e
	cmdf8 $00
	env $0 $01
	note $48 $01
	vol $0
	note $48 $02
	cmdff
; $e984e
; @addr{e984e}
sound76Channel7:
	cmdf0 $10
	note $26 $01
	cmdf0 $70
	note $24 $01
	cmdf0 $00
	note $36 $01
	cmdff
; $e985b
sound75Start:
; @addr{e985b}
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
; $e9870
sound74Start:
; @addr{e9870}
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
; $e9895
sound73Start:
; @addr{e9895}
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
; $e98be
sound54Start:
; @addr{e98be}
sound54Channel2:
	duty $01
	vol $f
	env $3 $00
	cmdf8 $23
	note $18 $16
	cmdff
; $e98c8
; @addr{e98c8}
sound54Channel3:
	duty $02
	vol $f
	env $3 $00
	cmdf8 $2c
	note $0c $16
	cmdff
; $e98d2
sound55Start:
; @addr{e98d2}
sound55Channel2:
	duty $02
	vol $d
	env $1 $00
	cmdf8 $d3
	note $2b $09
	cmdff
; $e98dc
; @addr{e98dc}
sound55Channel3:
	duty $01
	vol $d
	env $1 $00
	cmdf8 $e0
	note $2b $09
	cmdff
; $e98e6
sound5cStart:
; @addr{e98e6}
sound5cChannel2:
	duty $00
	vol $1
	note $4c $01
	note $4f $01
	note $52 $01
	vol $1
	note $4c $01
	note $4f $01
	note $52 $01
	vol $1
	note $4c $01
	note $4f $01
	note $52 $01
	vol $1
	note $4c $01
	note $4f $01
	note $52 $01
	vol $2
	cmdf8 $01
	note $4c $01
	note $4f $01
	note $52 $01
	vol $2
	note $4c $01
	note $4f $01
	note $52 $01
	vol $2
	note $4c $01
	note $4f $01
	note $52 $01
	vol $2
	note $4c $01
	note $4f $01
	note $52 $01
	cmdf8 $00
	vol $3
	cmdf8 $03
	note $4c $01
	note $4f $01
	note $52 $01
	vol $3
	note $4d $01
	note $4f $01
	note $52 $01
	vol $3
	note $4d $01
	note $4f $01
	note $52 $01
	vol $3
	note $4d $01
	note $4f $01
	note $52 $01
	cmdf8 $00
	vol $4
	cmdf8 $05
	note $4d $01
	note $50 $01
	note $52 $01
	vol $4
	note $4d $01
	note $50 $01
	note $52 $01
	vol $4
	note $4d $01
	note $50 $01
	note $52 $01
	vol $4
	note $4d $01
	note $50 $01
	note $52 $01
	cmdf8 $00
	vol $6
	cmdf8 $07
	note $4d $01
	note $50 $01
	note $53 $01
	vol $5
	note $4d $01
	note $50 $01
	note $53 $01
	vol $5
	note $4d $01
	note $50 $01
	note $53 $01
	vol $5
	note $4d $01
	note $50 $01
	note $53 $01
	cmdf8 $00
	vol $8
	cmdf8 $09
	note $4e $01
	note $50 $01
	note $53 $01
	vol $6
	note $4e $01
	note $50 $01
	note $53 $01
	vol $6
	note $4e $01
	note $50 $01
	note $53 $01
	vol $6
	note $4e $01
	note $50 $01
	note $53 $01
	cmdf8 $00
	vol $9
	cmdf8 $0b
	note $4e $01
	note $51 $01
	note $53 $01
	vol $7
	note $4e $01
	note $51 $01
	note $53 $01
	vol $7
	note $4e $01
	note $51 $01
	note $53 $01
	vol $7
	note $4e $01
	note $51 $01
	note $53 $01
	cmdf8 $00
	vol $a
	cmdf8 $0d
	note $4e $01
	note $51 $01
	note $54 $01
	vol $8
	note $4e $01
	note $51 $01
	note $54 $01
	vol $8
	note $4e $01
	note $51 $01
	note $54 $01
	vol $8
	note $4e $01
	note $51 $01
	note $54 $01
	cmdf8 $00
	vol $b
	cmdf8 $0e
	note $4f $01
	note $51 $01
	note $54 $01
	vol $9
	note $4f $01
	note $51 $01
	note $54 $01
	vol $9
	note $4f $01
	note $51 $01
	note $54 $01
	vol $9
	note $4f $01
	note $51 $01
	note $54 $01
	cmdf8 $00
	vol $c
	cmdf8 $0f
	note $4f $01
	note $52 $01
	note $54 $01
	vol $a
	note $4f $01
	note $52 $01
	note $54 $01
	vol $a
	note $4f $01
	note $52 $01
	note $54 $01
	vol $a
	note $4f $01
	note $52 $01
	note $54 $01
	cmdf8 $00
	vol $d
	cmdf8 $10
	note $4f $01
	note $52 $01
	note $55 $01
	vol $b
	note $4f $01
	note $53 $01
	note $55 $01
	vol $b
	note $4f $01
	note $53 $01
	note $55 $01
	vol $b
	note $4f $01
	note $53 $01
	note $55 $01
	cmdf8 $00
	vol $b
	note $4f $01
	note $53 $01
	note $55 $01
	cmdff
; $e9a4c
sound5dStart:
; @addr{e9a4c}
sound5dChannel2:
	duty $00
	vol $d
	note $3b $01
	vol $8
	note $31 $01
	note $2e $01
	note $38 $01
	note $2e $01
	note $2c $01
	note $35 $01
	note $2c $01
	note $2b $01
	note $33 $01
	note $2b $01
	note $29 $01
	vol $9
	note $3b $01
	vol $5
	note $31 $01
	note $2e $01
	note $38 $01
	note $2e $01
	note $2c $01
	note $35 $01
	note $2c $01
	note $2b $01
	note $33 $01
	note $2b $01
	note $29 $01
	vol $6
	note $3b $01
	vol $3
	note $31 $01
	note $2e $01
	note $38 $01
	note $2e $01
	note $2c $01
	note $35 $01
	note $2c $01
	note $2b $01
	note $33 $01
	note $2b $01
	note $29 $01
	vol $3
	note $3b $01
	vol $2
	note $31 $01
	note $2e $01
	note $38 $01
	note $2e $01
	note $2c $01
	note $35 $01
	note $2c $01
	note $2b $01
	note $33 $01
	note $2b $01
	note $29 $01
	vol $1
	note $3b $01
	vol $1
	note $31 $01
	note $2e $01
	note $38 $01
	note $2e $01
	note $2c $01
	note $35 $01
	note $2c $01
	note $2b $01
	note $33 $01
	note $2b $01
	note $29 $01
	cmdff
; $e9ad1
sound64Start:
; @addr{e9ad1}
sound64Channel5:
	duty $03
	vibrato $08
	vol $9
	note $36 $05
	note $39 $05
	note $3c $05
	vol $9
	note $35 $05
	note $38 $05
	note $3b $05
	vol $9
	note $34 $05
	note $37 $05
	note $3a $05
	vol $9
	note $33 $05
	note $36 $05
	note $39 $05
	vol $9
	note $32 $05
	note $35 $05
	note $38 $05
	vol $9
	note $31 $05
	note $34 $05
	note $37 $05
	vol $9
	note $30 $05
	note $33 $05
	note $36 $05
	vol $9
	note $2f $05
	note $32 $05
	note $35 $05
	vol $3
	note $2a $02
	cmdff
; $e9b11
sound65Start:
; @addr{e9b11}
sound65Channel5:
	duty $03
	note $3c $02
	note $3b $02
	note $3a $02
	note $39 $02
	note $3a $02
	note $3b $02
	note $3a $02
	note $38 $02
	note $39 $02
	note $3a $02
	note $39 $02
	note $37 $02
	note $38 $02
	note $39 $02
	note $38 $02
	note $36 $02
	note $37 $02
	note $38 $02
	note $37 $02
	note $35 $02
	note $36 $02
	note $37 $02
	note $36 $02
	note $34 $02
	note $35 $02
	note $36 $02
	note $35 $02
	note $33 $02
	note $34 $02
	note $35 $02
	note $34 $02
	note $32 $02
	note $33 $02
	note $34 $02
	note $33 $02
	cmdff
; $e9b5a
sound66Start:
; @addr{e9b5a}
sound66Channel2:
	duty $02
	vol $2
	note $41 $02
	duty $02
	vol $b
	note $41 $01
	cmdff
; $e9b65
sound63Start:
; @addr{e9b65}
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
; $e9c38
sound6fStart:
; @addr{e9c38}
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
; $e9c61
sound70Start:
; @addr{e9c61}
sound70Channel2:
	duty $01
	vol $0
	wait1 $02
	vol $6
	note $24 $01
	cmdf8 $0f
	note $24 $05
	cmdf8 $00
	cmdff
; $e9c70
; @addr{e9c70}
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
; $e9c97
sound71Start:
; @addr{e9c97}
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
; $e9cbe
sound72Start:
; @addr{e9cbe}
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
; $e9cf7
sound68Start:
; @addr{e9cf7}
sound68Channel2:
	duty $01
	vibrato $0b
	vol $c
	cmdf8 $36
	note $18 $08
	cmdf8 $00
	vol $9
	note $38 $01
	note $2f $01
	vol $9
	cmdf8 $18
	note $1f $06
	cmdf8 $00
	vol $7
	note $38 $01
	note $2f $01
	vol $7
	cmdf8 $18
	note $1f $06
	cmdf8 $00
	vol $7
	note $38 $01
	note $2f $01
	cmdff
; $e9d20
sound80Start:
; @addr{e9d20}
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
; $e9d51
sound81Start:
; @addr{e9d51}
sound81Channel2:
	duty $00
	vol $f
	note $0f $03
	vol $0
	wait1 $01
	vol $f
	note $0f $01
	vol $f
	note $0f $02
	vol $0
	wait1 $01
	vol $f
	env $0 $01
	note $0c $0a
	cmdff
; $e9d68
; @addr{e9d68}
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
; $e9d89
sound82Start:
; @addr{e9d89}
sound82Channel2:
	duty $00
	vol $0
	wait1 $05
	vol $f
	note $0c $01
	vol $e
	note $0d $01
	vol $d
	note $0c $01
	vol $c
	note $0e $01
	vol $b
	note $0d $01
	vol $a
	note $10 $01
	vol $9
	note $0c $01
	vol $8
	note $0e $01
	vol $7
	note $0d $01
	vol $6
	note $0f $01
	vol $5
	note $0c $01
	vol $4
	note $0f $01
	vol $3
	note $0d $01
	vol $2
	note $0f $01
	cmdff
; $e9db9
; @addr{e9db9}
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
; $e9dd2
sound7bStart:
; @addr{e9dd2}
sound7bChannel2:
	duty $00
	vol $6
	note $2f $04
	note $32 $04
	vol $7
	note $36 $04
	note $3a $04
	vol $8
	note $3b $04
	note $3e $04
	vol $9
	note $42 $04
	note $46 $04
	vol $5
	note $3b $04
	note $3e $04
	note $42 $04
	note $46 $04
	vol $1
	note $3b $04
	note $3e $04
	note $42 $04
	note $46 $04
	cmdff
; $e9dfb
sound7dStart:
; @addr{e9dfb}
sound7dChannel2:
	duty $02
	vol $f
	env $2 $00
	cmdf8 $0b
	note $13 $18
	cmdf8 $00
	env $0 $05
	cmdf8 $f8
	note $17 $33
	cmdf8 $00
	cmdff
; $e9e0f
sound7eStart:
; @addr{e9e0f}
sound7eChannel2:
	duty $02
	vol $d
	note $34 $01
	vol $0
	wait1 $03
	vol $a
	note $39 $01
	vol $0
	wait1 $03
	vol $8
	note $3b $01
	vol $0
	wait1 $03
	vol $a
	note $39 $01
	vol $0
	wait1 $03
	vol $d
	note $34 $01
	cmdff
; $e9e2d
sound7cStart:
; @addr{e9e2d}
sound7cChannel2:
	duty $01
musice9e2f:
	vol $9
	cmdf8 $64
	note $17 $04
	cmdf8 $00
	vol $b
	cmdf8 $64
	note $17 $04
	cmdf8 $00
	vol $e
	cmdf8 $64
	note $17 $04
	cmdf8 $00
	vol $9
	cmdf8 $64
	note $17 $04
	cmdf8 $00
	vol $8
	cmdf8 $64
	note $17 $04
	cmdf8 $00
	vol $7
	cmdf8 $64
	note $17 $04
	cmdf8 $00
	vol $6
	cmdf8 $64
	note $17 $04
	cmdf8 $00
	vol $5
	cmdf8 $64
	note $17 $04
	cmdf8 $00
	vol $4
	cmdf8 $64
	note $17 $04
	cmdf8 $00
	vol $3
	cmdf8 $64
	note $17 $04
	cmdf8 $00
	goto musice9e2f
	cmdff
; $e9e79
sound69Start:
; @addr{e9e79}
sound69Channel2:
	duty $02
	vol $d
	note $24 $01
	note $30 $01
	note $1f $01
	note $2b $01
	note $30 $01
	note $24 $01
	note $2e $01
	note $22 $01
	note $2d $01
	note $21 $01
	note $2b $01
	note $1f $01
	note $29 $01
	note $1d $01
	note $27 $01
	note $1b $01
	vol $b
	note $25 $01
	vol $a
	note $19 $01
	vol $9
	note $23 $01
	vol $8
	note $17 $01
	vol $5
	note $0c $01
	note $18 $01
	note $0c $01
	note $18 $01
	note $0c $01
	note $18 $01
	note $0c $01
	note $18 $01
	note $0c $01
	note $18 $01
	note $0c $01
	note $18 $01
	note $0c $01
	note $18 $01
	note $0c $01
	note $18 $01
	cmdff
; $e9eca
sound67Start:
; @addr{e9eca}
sound67Channel2:
	duty $00
	vol $f
	note $18 $01
	vol $0
	wait1 $01
	vol $f
	note $18 $01
	vol $0
	wait1 $01
	vol $f
	note $19 $01
	vol $0
	wait1 $01
	vol $f
	note $19 $01
	vol $0
	wait1 $01
	vol $f
	note $1a $01
	vol $0
	wait1 $01
	vol $f
	note $1a $01
	vol $0
	wait1 $01
	vol $f
	note $1b $01
	vol $0
	wait1 $01
	vol $f
	note $1b $01
	vol $0
	wait1 $01
	vol $f
	note $1c $01
	vol $0
	wait1 $01
	vol $f
	note $1c $01
	vol $0
	wait1 $01
	vol $f
	note $1d $01
	vol $0
	wait1 $01
	vol $f
	note $1d $01
	vol $0
	wait1 $01
	vol $f
	note $1e $01
	vol $0
	wait1 $01
	vol $f
	note $1e $01
	vol $0
	wait1 $01
	vol $f
	note $1e $01
	vol $0
	wait1 $01
	vol $f
	note $1e $01
	vol $0
	wait1 $01
	vol $f
	note $1f $01
	vol $0
	wait1 $01
	vol $f
	note $1f $01
	vol $0
	wait1 $01
	vol $f
	note $1f $01
	vol $0
	wait1 $01
	vol $f
	note $18 $01
	vol $0
	wait1 $01
	vol $f
	note $18 $01
	vol $0
	wait1 $01
	vol $f
	note $18 $01
	vol $0
	wait1 $01
	vol $f
	note $18 $01
	vol $0
	wait1 $01
	vol $f
	note $18 $01
	vol $0
	wait1 $01
	vol $f
	note $18 $01
	vol $0
	wait1 $01
	vol $f
	note $18 $01
	vol $0
	wait1 $01
	vol $f
	note $21 $01
	vol $0
	wait1 $01
	vol $f
	note $21 $01
	vol $0
	wait1 $01
	vol $f
	note $20 $01
	vol $0
	wait1 $01
	vol $f
	note $20 $01
	vol $0
	wait1 $01
	vol $f
	note $1f $01
	vol $0
	wait1 $01
	vol $f
	note $1f $01
	vol $0
	wait1 $01
	vol $f
	note $1f $01
	vol $0
	wait1 $01
	vol $f
	note $1e $01
	vol $0
	wait1 $01
	vol $f
	note $1e $01
	vol $0
	wait1 $01
	vol $f
	note $1e $01
	vol $0
	wait1 $01
	vol $f
	note $1e $01
	vol $0
	wait1 $01
	vol $f
	note $1e $01
	vol $0
	wait1 $01
	vol $f
	note $1e $01
	vol $0
	wait1 $01
	vol $f
	note $1e $01
	vol $0
	wait1 $01
	vol $f
	note $1e $01
	vol $0
	wait1 $01
	vol $f
	note $1d $01
	vol $0
	wait1 $01
	vol $f
	note $1d $01
	vol $0
	wait1 $01
	vol $f
	note $1c $01
	vol $0
	wait1 $01
	vol $f
	note $1c $01
	vol $0
	wait1 $01
	vol $f
	note $1b $01
	vol $0
	wait1 $01
	vol $f
	note $1b $01
	vol $0
	wait1 $01
	vol $f
	note $1a $01
	vol $0
	wait1 $01
	vol $f
	note $1a $01
	vol $0
	wait1 $01
	vol $f
	note $19 $01
	vol $0
	wait1 $01
	vol $f
	note $19 $01
	vol $0
	wait1 $01
	vol $f
	note $18 $01
	vol $0
	wait1 $01
	vol $f
	note $18 $01
	vol $0
	wait1 $01
	vol $f
	note $17 $01
	vol $0
	wait1 $01
	vol $f
	note $17 $01
	vol $0
	wait1 $01
	vol $f
	note $16 $01
	vol $0
	wait1 $01
	vol $f
	note $16 $01
	vol $0
	wait1 $01
	vol $3
	note $1f $01
	vol $0
	wait1 $01
	vol $3
	note $1e $01
	vol $0
	wait1 $01
	vol $3
	note $1d $01
	vol $0
	wait1 $01
	vol $3
	note $1c $01
	vol $0
	wait1 $01
	vol $3
	note $1b $01
	vol $0
	wait1 $01
	vol $3
	note $1a $01
	vol $0
	wait1 $01
	vol $3
	note $19 $01
	vol $0
	wait1 $01
	vol $3
	note $18 $01
	vol $0
	wait1 $01
	vol $3
	note $17 $01
	vol $0
	wait1 $01
	vol $3
	note $16 $01
	vol $0
	wait1 $01
	cmdff
; $ea05f
soundd2Start:
; @addr{ea05f}
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
; $ea0ac
soundd3Start:
; @addr{ea0ac}
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
; $ea143
soundd1Start:
; @addr{ea143}
soundd1Channel2:
	duty $00
	vol $9
	cmdf8 $7f
	note $1a $03
	cmdf8 $00
	cmdf8 $81
	note $21 $03
	cmdf8 $00
	vol $f
	cmdf8 $ef
	note $15 $32
	cmdff
; $ea158
; @addr{ea158}
soundd1Channel7:
	cmdf0 $40
	note $44 $02
	note $45 $02
	note $46 $02
	cmdf0 $40
	note $46 $28
	note $47 $02
	note $54 $02
	note $55 $02
	note $56 $02
	note $57 $02
	cmdff
; $ea16f
soundd0Start:
; @addr{ea16f}
soundd0Channel2:
	duty $00
	vol $c
	cmdf8 $20
	note $2d $01
	cmdf8 $00
	vol $7
	note $30 $01
	note $33 $01
	vol $6
	note $31 $01
	note $34 $01
	vol $5
	note $31 $01
	note $34 $01
	vol $4
	note $31 $01
	note $34 $01
	vol $3
	note $32 $01
	note $35 $01
	vol $2
	note $32 $01
	note $35 $01
	vol $1
	note $33 $01
	note $36 $01
	cmdff
; $ea19c
; @addr{ea19c}
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
; $ea1b3
sound7fStart:
; @addr{ea1b3}
sound7fChannel2:
	duty $00
	vol $9
	note $12 $01
	vol $0
	wait1 $01
	vol $b
	note $16 $01
	vol $0
	wait1 $01
	vol $d
	note $18 $01
	vol $0
	wait1 $01
	vol $f
	note $19 $01
	vol $0
	wait1 $01
	vol $f
	note $19 $01
	vol $0
	wait1 $01
	vol $f
	note $19 $01
	vol $0
	wait1 $01
	vol $f
	note $18 $01
	vol $0
	wait1 $01
	vol $f
	note $16 $01
	vol $0
	wait1 $01
	vol $f
	note $15 $01
	vol $0
	wait1 $01
	vol $f
	note $14 $01
	vol $0
	wait1 $01
	vol $f
	note $13 $01
	vol $0
	wait1 $01
	vol $f
	note $12 $01
	vol $0
	wait1 $01
	vol $f
	note $11 $01
	vol $0
	wait1 $01
	vol $f
	note $10 $01
	vol $0
	wait1 $01
	vol $f
	note $0f $01
	vol $0
	wait1 $01
	vol $f
	note $0e $01
	vol $0
	wait1 $01
	vol $f
	note $0d $01
	vol $0
	wait1 $01
	vol $f
	note $0c $01
	vol $0
	wait1 $01
	vol $5
	note $12 $01
	vol $0
	wait1 $01
	vol $5
	note $16 $01
	vol $0
	wait1 $01
	vol $5
	note $18 $01
	vol $0
	wait1 $01
	vol $5
	note $19 $01
	vol $0
	wait1 $01
	vol $5
	note $19 $01
	vol $0
	wait1 $01
	vol $5
	note $19 $01
	vol $0
	wait1 $01
	vol $5
	note $18 $01
	vol $0
	wait1 $01
	vol $5
	note $16 $01
	vol $0
	wait1 $01
	vol $5
	note $15 $01
	vol $0
	wait1 $01
	vol $5
	note $14 $01
	vol $0
	wait1 $01
	vol $5
	note $13 $01
	vol $0
	wait1 $01
	vol $5
	note $12 $01
	vol $0
	wait1 $01
	vol $5
	note $11 $01
	vol $0
	wait1 $01
	vol $5
	note $10 $01
	vol $0
	wait1 $01
	vol $5
	note $0f $01
	vol $0
	wait1 $01
	vol $5
	note $0e $01
	vol $0
	wait1 $01
	vol $5
	note $0d $01
	vol $0
	wait1 $01
	vol $5
	note $0c $01
	vol $0
	wait1 $01
	cmdff
; $ea28e
sound83Start:
; @addr{ea28e}
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
; $ea2cc
sound84Start:
; @addr{ea2cc}
sound84Channel2:
	duty $02
	cmdf0 $d9
	.db $07 $a0 $03
	vol $1
	.db $07 $a0 $05
	cmdff
; $ea2d8
sound85Start:
; @addr{ea2d8}
sound85Channel2:
	duty $02
	vol $f
	cmdf8 $ce
	note $15 $06
	cmdf8 $00
	vol $e
	cmdf8 $50
	note $11 $06
	cmdf8 $00
	vol $a
	cmdf8 $ce
	note $15 $06
	cmdf8 $00
	vol $8
	cmdf8 $50
	note $11 $06
	cmdf8 $00
	vol $7
	cmdf8 $ce
	note $15 $06
	cmdf8 $00
	vol $6
	cmdf8 $50
	note $11 $06
	cmdf8 $00
	vol $5
	cmdf8 $ce
	note $15 $06
	cmdf8 $00
	vol $4
	cmdf8 $50
	note $11 $06
	cmdf8 $00
	vol $3
	env $0 $03
	cmdf8 $ce
	note $15 $06
	cmdf8 $00
	cmdff
; $ea31c
sound86Start:
; @addr{ea31c}
sound86Channel2:
	duty $02
	vol $7
	note $2d $01
	note $2f $02
	vol $7
	note $2e $01
	note $30 $02
	vol $7
	note $2f $01
	note $31 $02
	vol $7
	note $30 $01
	note $32 $02
	vol $6
	note $31 $01
	note $33 $02
	vol $5
	note $32 $01
	note $34 $02
	vol $4
	note $33 $01
	note $35 $02
	vol $3
	note $34 $01
	note $36 $02
	vol $2
	note $3c $01
	note $42 $01
	vol $0
	wait1 $0f
	vol $7
	note $30 $01
	note $32 $02
	vol $7
	note $31 $01
	note $33 $02
	vol $7
	note $32 $01
	note $34 $02
	vol $7
	note $33 $01
	note $35 $02
	vol $6
	note $34 $01
	note $36 $02
	vol $5
	note $35 $01
	note $37 $02
	vol $4
	note $36 $01
	note $38 $02
	vol $3
	note $37 $01
	note $39 $02
	vol $2
	note $44 $02
	note $4d $02
	note $48 $01
	cmdff
; $ea37e
sound8dStart:
; @addr{ea37e}
sound8dChannel2:
	duty $01
	vol $1
	note $22 $01
	vol $1
	note $15 $01
	vol $1
	note $20 $01
	vol $1
	note $23 $01
	vol $1
	note $16 $01
	vol $1
	note $21 $01
	vol $2
	note $24 $01
	vol $1
	note $17 $01
	vol $1
	note $22 $01
	vol $3
	note $25 $01
	vol $1
	note $18 $01
	vol $1
	note $23 $01
	vol $4
	note $26 $01
	vol $2
	note $19 $01
	vol $2
	note $24 $01
	vol $5
	note $27 $01
	vol $3
	note $1a $01
	vol $3
	note $25 $01
	vol $6
	note $28 $01
	vol $4
	note $1b $01
	vol $4
	note $26 $01
	vol $7
	note $29 $01
	vol $5
	note $1c $01
	vol $5
	note $27 $01
	vol $8
	note $2a $01
	vol $6
	note $1d $01
	vol $6
	note $28 $01
	vol $9
	note $2b $01
	vol $7
	note $1e $01
	vol $7
	note $29 $01
	vol $a
	note $2c $01
	vol $8
	note $1f $01
	vol $8
	note $2a $01
	vol $b
	note $2d $01
	vol $9
	note $20 $01
	vol $9
	note $2b $01
	vol $c
	note $2e $01
	vol $a
	note $21 $01
	vol $a
	note $2c $01
	vol $d
	note $2f $01
	vol $b
	note $22 $01
	vol $a
	note $2c $01
	vol $e
	note $30 $01
	vol $c
	note $23 $01
	vol $9
	note $2d $01
	vol $d
	note $31 $01
	vol $b
	note $24 $01
	vol $8
	note $2e $01
	vol $c
	note $32 $01
	vol $a
	note $25 $01
	vol $7
	note $2f $01
	vol $b
	note $33 $01
	vol $9
	note $26 $01
	vol $6
	note $30 $01
	vol $a
	note $34 $01
	vol $8
	note $27 $01
	vol $5
	note $31 $01
	vol $9
	note $35 $01
	vol $7
	note $28 $01
	vol $4
	note $32 $01
	vol $8
	note $36 $01
	vol $6
	note $29 $01
	vol $3
	note $33 $01
	vol $7
	note $37 $01
	vol $5
	note $2a $01
	vol $2
	note $34 $01
	vol $6
	note $38 $01
	vol $4
	note $2b $01
	vol $1
	note $35 $01
	vol $5
	note $39 $01
	vol $3
	note $2c $01
	vol $1
	note $36 $01
	vol $4
	note $3a $01
	vol $2
	note $2d $01
	vol $1
	note $37 $01
	vol $3
	note $3b $01
	vol $1
	note $2e $01
	vol $2
	note $3c $01
	vol $1
	note $2f $01
	vol $1
	note $3d $01
	vol $1
	note $30 $01
	vol $1
	note $3e $01
	cmdff
; $ea477
soundd4Start:
; @addr{ea477}
soundd4Channel2:
	cmdff
; $ea478
; @addr{ea478}
soundd4Channel7:
	cmdff
; $ea479
soundd5Start:
; @addr{ea479}
soundd5Channel2:
	cmdff
; $ea47a
soundc0Start:
; @addr{ea47a}
soundc0Channel2:
	duty $00
	vol $3
	note $47 $02
	vol $8
	note $47 $02
	vol $a
	note $47 $02
	vol $a
	note $3b $03
	vol $9
	note $35 $03
	vol $8
	note $30 $03
	vol $7
	note $36 $03
	vol $4
	note $35 $03
	vol $4
	note $30 $03
	vol $4
	note $36 $03
	vol $2
	note $35 $03
	vol $2
	note $30 $03
	vol $2
	note $36 $03
	cmdff
; $ea4a4
soundbfStart:
; @addr{ea4a4}
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
; $ea611
sound92Start:
; @addr{ea611}
sound92Channel2:
	duty $01
	env $2 $04
	vol $7
	cmdf8 $09
	cmdfd $fc
	note $23 $41
	vol $0
	wait1 $11
	env $3 $03
	vol $4
	cmdf8 $f8
	note $34 $37
	cmdff
; $ea627
sound9dStart:
; @addr{ea627}
sound9dChannel3:
	vol $0
	wait1 $f1
	cmdff
; $ea62b
; @addr{ea62b}
sound9dChannel2:
	vol $0
	duty $02
	wait1 $1f
	vol $2
	note $3c $05
	note $41 $04
	note $43 $05
	note $48 $46
	vol $0
	note $48 $0e
	vol $2
	note $46 $05
	note $48 $04
	note $46 $05
	note $45 $0e
	note $41 $0e
	note $43 $04
	vol $0
	note $43 $0a
	vol $2
	note $3c $38
	cmdff
; $ea650
; @addr{ea650}
sound9dChannel5:
	duty $16
	note $3c $04
	note $41 $05
	note $43 $05
	note $48 $46
	wait1 $0e
	note $46 $04
	note $48 $05
	note $46 $05
	note $45 $0e
	note $41 $0e
	note $43 $03
	wait1 $0b
	note $3c $38
	wait1 $1f
	cmdff
; $ea66f
; @addr{ea66f}
sound9dChannel7:
	cmdf0 $00
	note $00 $f1
	cmdff
; $ea674
sound9eStart:
; @addr{ea674}
sound9eChannel3:
	vol $0
	wait1 $f1
	cmdff
; $ea678
; @addr{ea678}
sound9eChannel2:
	vol $0
	wait1 $1f
	duty $02
	vol $2
	note $32 $05
	note $37 $04
	note $39 $05
	note $3c $46
	wait1 $0e
	note $3b $05
	note $3c $04
	note $3b $05
	note $37 $0e
	note $39 $54
	cmdff
; $ea693
; @addr{ea693}
sound9eChannel5:
	duty $16
	note $32 $04
	note $37 $05
	note $39 $05
	note $3c $46
	wait1 $0e
	note $3b $04
	note $3c $05
	note $3b $05
	note $37 $0e
	note $39 $54
	wait1 $1f
	cmdff
; $ea6ac
; @addr{ea6ac}
sound9eChannel7:
	cmdf0 $00
	note $00 $f1
	cmdff
; $ea6b1
sound9fStart:
; @addr{ea6b1}
sound9fChannel3:
	vol $0
	wait1 $e5
	cmdff
; $ea6b5
; @addr{ea6b5}
sound9fChannel2:
	vol $0
	wait1 $0d
	duty $02
	vol $2
	note $3f $12
	note $3a $12
	note $46 $1b
	wait1 $09
	note $43 $12
	note $3f $12
	note $48 $1b
	wait1 $09
	note $46 $48
	cmdff
; $ea6ce
; @addr{ea6ce}
sound9fChannel5:
	duty $16
	note $3f $12
	note $3a $12
	note $46 $1b
	wait1 $09
	note $43 $12
	note $3f $12
	note $48 $1b
	wait1 $09
	note $46 $48
	wait1 $0d
	cmdff
; $ea6e5
; @addr{ea6e5}
sound9fChannel7:
	cmdf0 $00
	note $00 $e5
	cmdff
; $ea6ea
sound4aStart:
; @addr{ea6ea}
sound4aChannel1:
	vol $0
	note $20 $07
	vibrato $e1
	env $0 $00
	cmdf2
	duty $02
musicea6f4:
	vol $6
	note $2b $0e
	wait1 $03
	vol $3
	note $2b $0b
	vol $6
	note $26 $15
	note $2b $07
	note $30 $0e
	note $2f $0e
	note $2d $0e
	note $2b $0e
	note $2d $1c
	note $26 $0e
	wait1 $03
	vol $3
	note $26 $04
	vol $6
	note $24 $07
	note $26 $2a
	vibrato $01
	env $0 $00
	vol $3
	note $26 $0e
	vibrato $e1
	env $0 $00
	vol $6
	note $28 $0e
	wait1 $03
	vol $3
	note $28 $0b
	vol $6
	note $28 $09
	note $24 $09
	note $28 $0a
	note $2a $0e
	wait1 $03
	vol $3
	note $2a $0b
	vol $6
	note $2a $09
	vol $6
	note $28 $09
	note $2a $0a
	note $2b $0e
	wait1 $03
	vol $3
	note $2b $0b
	vol $6
	note $2b $09
	note $2a $09
	note $2b $0a
	note $2f $0e
	wait1 $07
	vol $3
	note $2f $07
	vol $6
	note $2d $0e
	wait1 $07
	vol $3
	note $2d $07
	vol $6
	note $32 $0e
	wait1 $03
	vol $3
	note $32 $0b
	vol $6
	note $32 $0e
	wait1 $03
	vol $3
	note $32 $04
	vol $6
	note $32 $07
	note $30 $0e
	note $2f $0e
	note $2d $0e
	note $2b $0e
	note $2f $1c
	note $2d $15
	note $2b $07
	note $2d $2a
	vibrato $01
	env $0 $00
	vol $3
	note $2d $0e
	vibrato $e1
	env $0 $00
	vol $6
	note $2b $0e
	wait1 $07
	vol $3
	note $2b $07
	vol $6
	note $2b $09
	note $27 $09
	note $2b $0a
	note $2d $0e
	wait1 $07
	vol $3
	note $2d $07
	vol $6
	note $2d $09
	note $29 $09
	note $2d $0a
	note $2e $0e
	wait1 $07
	vol $3
	note $2e $07
	vol $6
	note $2e $09
	note $2b $09
	note $2e $0a
	note $2d $0e
	note $2e $0e
	note $30 $0e
	note $31 $0e
	duty $01
	note $32 $0e
	wait1 $07
	vol $3
	note $32 $07
	vol $6
	note $32 $0e
	wait1 $03
	vol $3
	note $32 $04
	vol $6
	note $32 $07
	note $33 $0e
	note $32 $0e
	note $30 $0e
	note $2e $07
	wait1 $03
	vol $3
	note $2e $04
	vol $6
	note $2e $1c
	note $2d $0e
	wait1 $03
	vol $3
	note $2d $04
	vol $6
	note $2b $07
	note $29 $1c
	vol $3
	note $29 $1c
	vol $6
	note $2e $0e
	wait1 $07
	vol $3
	note $2e $07
	vol $6
	note $2e $0e
	wait1 $03
	vol $3
	note $2e $04
	vol $6
	note $2e $07
	note $30 $0e
	note $2e $0e
	note $30 $0e
	note $2e $0e
	note $30 $07
	wait1 $03
	vol $3
	note $30 $07
	wait1 $04
	vol $6
	note $32 $03
	wait1 $04
	note $32 $38
	vibrato $01
	env $0 $00
	vol $3
	note $32 $1c
	vibrato $e1
	env $0 $00
	vol $6
	note $34 $07
	wait1 $03
	vol $3
	note $34 $07
	wait1 $04
	vol $1
	note $34 $07
	vol $6
	note $34 $07
	wait1 $03
	vol $3
	note $34 $07
	wait1 $04
	vol $6
	note $34 $04
	wait1 $03
	note $34 $07
	wait1 $03
	vol $3
	note $34 $07
	wait1 $04
	vol $1
	note $34 $07
	vol $6
	note $2d $04
	note $2f $05
	note $31 $05
	note $32 $04
	note $33 $05
	note $34 $05
	note $36 $07
	wait1 $03
	vol $3
	note $36 $07
	wait1 $04
	vol $1
	note $36 $07
	vol $6
	note $36 $07
	wait1 $03
	vol $3
	note $36 $07
	wait1 $04
	vol $6
	note $36 $04
	wait1 $03
	note $36 $07
	wait1 $03
	vol $3
	note $36 $07
	wait1 $04
	vol $1
	note $36 $07
	wait1 $1c
	vol $6
	note $37 $0e
	wait1 $03
	vol $3
	note $37 $0b
	vol $6
	note $37 $09
	note $33 $09
	note $37 $0a
	note $39 $0e
	wait1 $03
	vol $3
	note $39 $0b
	vol $6
	note $39 $09
	note $35 $09
	note $39 $0a
	note $3a $0e
	wait1 $03
	vol $3
	note $3a $0b
	vol $6
	note $3a $09
	note $37 $09
	note $3a $0a
	note $3c $0e
	wait1 $03
	vol $3
	note $3c $0b
	vol $6
	note $3c $09
	note $39 $09
	note $3c $0a
	note $3e $07
	wait1 $03
	vol $3
	note $3e $07
	wait1 $04
	vol $1
	note $3e $07
	vol $6
	note $3e $07
	wait1 $03
	vol $3
	note $3e $07
	wait1 $04
	vol $6
	note $3e $03
	wait1 $04
	note $3e $38
	vibrato $01
	env $0 $00
	vol $3
	note $3e $1c
	wait1 $54
	vibrato $e1
	env $0 $00
	vol $6
	note $3e $07
	wait1 $03
	vol $3
	note $3e $07
	wait1 $04
	vol $1
	note $3e $07
	vol $6
	note $3e $07
	wait1 $03
	vol $3
	note $3e $07
	wait1 $04
	vol $6
	note $3e $03
	wait1 $04
	note $3e $38
	vibrato $01
	env $0 $00
	vol $3
	note $3e $1c
	wait1 $54
	vibrato $e1
	env $0 $00
	duty $02
	goto musicea6f4
	cmdff
; $ea919
; @addr{ea919}
sound4aChannel0:
	vol $0
	note $20 $07
	vibrato $e1
	env $0 $00
	cmdf2
	duty $02
musicea923:
	wait1 $1c
	vol $6
	note $17 $1c
	note $1a $1c
	note $1f $1c
	note $1d $31
	note $1c $07
	note $1a $1c
	vol $3
	note $1a $0e
	vol $6
	note $21 $07
	note $20 $07
	note $1f $0e
	vol $3
	note $1f $0e
	vol $6
	note $1f $09
	note $1c $09
	note $1f $0a
	note $21 $0e
	vol $3
	note $21 $0e
	vol $6
	note $21 $09
	note $1e $09
	note $21 $0a
	note $23 $0e
	vol $3
	note $23 $0e
	vol $6
	note $23 $09
	note $21 $09
	note $23 $0a
	note $26 $0e
	vol $3
	note $26 $0e
	vol $6
	note $26 $07
	note $24 $07
	note $23 $07
	note $21 $07
	note $23 $0e
	wait1 $03
	vol $3
	note $23 $0b
	vol $6
	note $23 $0e
	wait1 $03
	vol $3
	note $23 $04
	vol $6
	note $23 $07
	note $21 $0e
	note $1f $04
	note $21 $05
	note $1f $05
	note $1e $0e
	note $1c $0e
	note $1a $07
	wait1 $03
	vol $3
	note $1a $07
	wait1 $04
	vol $1
	note $1a $07
	vol $6
	note $1e $15
	note $1c $07
	note $1e $07
	wait1 $03
	vol $3
	note $1e $04
	vol $6
	note $21 $0e
	note $23 $0e
	note $24 $0e
	note $26 $38
	note $27 $38
	note $29 $38
	note $27 $0e
	note $26 $0e
	note $27 $0e
	note $28 $0e
	note $29 $07
	wait1 $03
	vol $3
	note $29 $04
	vol $6
	note $22 $07
	note $1d $07
	note $22 $07
	wait1 $03
	vol $3
	note $22 $04
	vol $6
	note $22 $07
	note $21 $07
	vol $6
	note $22 $07
	wait1 $03
	vol $3
	note $22 $04
	vol $6
	note $22 $07
	note $21 $07
	note $22 $07
	note $24 $07
	note $26 $07
	note $22 $07
	note $1d $07
	wait1 $03
	vol $3
	note $1d $04
	vol $6
	note $1d $07
	note $1c $07
	note $1d $07
	wait1 $03
	vol $3
	note $1d $04
	vol $6
	note $1d $07
	note $1f $07
	note $21 $07
	wait1 $03
	vol $3
	note $21 $04
	vol $6
	note $21 $07
	note $22 $07
	note $24 $07
	note $21 $07
	note $22 $07
	note $24 $07
	note $26 $0e
	wait1 $03
	vol $3
	note $26 $0b
	vol $6
	note $1f $0e
	wait1 $03
	vol $3
	note $1f $04
	vol $6
	note $1f $07
	note $21 $0e
	wait1 $03
	vol $3
	note $21 $0b
	vol $6
	note $21 $07
	note $1f $07
	note $1d $07
	note $24 $07
	note $26 $07
	wait1 $03
	vol $3
	note $26 $04
	vol $6
	note $22 $07
	note $21 $07
	note $22 $07
	wait1 $03
	vol $3
	note $22 $04
	vol $6
	note $22 $07
	note $21 $07
	note $22 $07
	wait1 $03
	vol $3
	note $22 $04
	vol $6
	note $22 $07
	note $21 $07
	note $22 $07
	note $24 $07
	note $26 $07
	note $22 $07
	note $25 $07
	wait1 $03
	vol $3
	note $25 $07
	wait1 $04
	vol $1
	note $25 $07
	vol $6
	note $25 $07
	wait1 $03
	vol $3
	note $25 $07
	wait1 $04
	vol $6
	note $25 $04
	wait1 $03
	note $25 $07
	wait1 $03
	vol $3
	note $25 $07
	wait1 $04
	vol $1
	note $25 $07
	vol $6
	note $2d $04
	note $2c $05
	note $2b $05
	note $2a $04
	note $29 $05
	note $28 $05
	note $26 $07
	wait1 $03
	vol $3
	note $26 $07
	wait1 $04
	vol $1
	note $26 $07
	vol $6
	note $26 $07
	wait1 $03
	vol $3
	note $26 $07
	wait1 $04
	vol $6
	note $26 $04
	wait1 $03
	note $26 $07
	wait1 $03
	vol $3
	note $26 $04
	vol $6
	note $26 $07
	note $28 $07
	note $2a $07
	note $26 $07
	note $28 $07
	note $2a $07
	note $27 $0e
	wait1 $03
	vol $3
	note $27 $0b
	vol $6
	note $27 $09
	note $22 $09
	note $27 $0a
	note $29 $0e
	wait1 $03
	vol $3
	note $29 $0b
	vol $6
	note $29 $09
	note $24 $09
	note $29 $0a
	note $2b $0e
	wait1 $03
	vol $3
	note $2b $0b
	vol $6
	note $2b $09
	note $27 $09
	note $2b $0a
	note $2d $0e
	note $2e $0e
	note $30 $0e
	note $31 $0e
	note $32 $07
	wait1 $03
	vol $3
	note $32 $07
	wait1 $04
	vol $1
	note $32 $07
	vol $6
	note $2a $07
	wait1 $03
	vol $3
	note $2a $07
	wait1 $04
	vol $6
	note $2a $03
	wait1 $04
	note $2a $31
	wait1 $07
	vol $6
	note $26 $0e
	note $21 $07
	note $1f $07
	note $1a $07
	note $1f $07
	note $21 $07
	note $24 $07
	note $26 $0e
	note $21 $07
	note $1f $07
	note $1a $07
	note $1f $07
	note $21 $07
	note $24 $07
	note $2a $07
	wait1 $03
	vol $3
	note $2a $07
	wait1 $04
	vol $1
	note $2a $07
	vol $6
	note $2b $09
	note $2a $09
	note $2b $0a
	note $2d $31
	wait1 $07
	vol $6
	note $26 $0e
	note $21 $07
	note $1f $07
	note $1a $07
	note $1f $07
	note $21 $07
	note $24 $07
	note $26 $07
	note $24 $07
	note $23 $07
	note $21 $07
	note $1f $07
	note $1e $07
	note $1c $07
	note $1a $07
	goto musicea923
	cmdff
; $eab69
; @addr{eab69}
sound4aChannel4:
	wait1 $07
	cmdf2
musiceab6c:
	duty $0e
	note $13 $07
	duty $0f
	note $13 $07
	duty $0e
	note $13 $07
	duty $0f
	note $13 $0e
	wait1 $4d
	duty $0e
	note $0e $07
	duty $0f
	note $0e $07
	duty $0e
	note $0e $07
	duty $0f
	note $0e $0e
	wait1 $4d
	duty $0e
	note $0c $1c
	duty $0f
	note $0c $0e
	duty $0e
	note $0c $07
	duty $0f
	note $0c $07
	duty $0e
	note $0e $1c
	duty $0f
	note $0e $0e
	duty $0e
	note $0e $07
	duty $0f
	note $0e $07
	duty $0e
	note $0c $23
	duty $0f
	note $0c $07
	duty $0e
	note $0c $07
	duty $0f
	note $0c $07
	duty $0e
	note $0e $07
	duty $0f
	note $0e $0e
	wait1 $07
	duty $0e
	note $0e $07
	note $10 $07
	note $12 $07
	note $0e $07
	duty $0e
	note $13 $07
	duty $0f
	note $13 $07
	duty $0e
	note $13 $07
	duty $0f
	note $13 $0e
	wait1 $3f
	duty $0e
	note $13 $0e
	duty $0e
	note $0e $07
	duty $0f
	note $0e $07
	duty $0e
	note $0e $07
	duty $0f
	note $0e $0e
	wait1 $31
	duty $0e
	note $0e $07
	duty $0f
	note $0e $07
	duty $0e
	note $0e $07
	note $0d $07
	duty $0e
	note $0f $23
	duty $0f
	note $0f $07
	duty $0e
	note $0f $0e
	duty $0e
	note $11 $23
	duty $0f
	note $11 $07
	duty $0e
	note $11 $07
	duty $0f
	note $11 $07
	duty $0e
	note $0f $23
	duty $0f
	note $0f $07
	duty $0e
	note $0f $0e
	duty $0e
	note $11 $15
	duty $0f
	note $11 $07
	duty $0e
	note $11 $1c
	duty $0e
	note $16 $12
	duty $0f
	note $16 $0a
	duty $0e
	note $11 $12
	duty $0f
	note $11 $0a
	duty $0e
	note $16 $0e
	duty $0f
	note $16 $0e
	duty $0e
	note $11 $0e
	duty $0f
	note $11 $0e
	duty $0e
	note $11 $0e
	duty $0f
	note $11 $0e
	duty $0e
	note $13 $0e
	duty $0f
	note $13 $0e
	duty $0e
	note $15 $0e
	duty $0f
	note $15 $0e
	duty $0e
	note $11 $1c
	duty $0e
	note $13 $07
	duty $0f
	note $13 $07
	duty $0e
	note $13 $07
	duty $0f
	note $13 $0e
	wait1 $15
	duty $0e
	note $11 $07
	duty $0f
	note $11 $07
	duty $0e
	note $11 $07
	duty $0f
	note $11 $0e
	wait1 $15
	duty $0e
	note $16 $0e
	duty $0f
	note $16 $0e
	duty $0e
	note $11 $0e
	duty $0f
	note $11 $0e
	duty $0e
	note $0e $0e
	duty $0f
	note $0e $0e
	duty $0e
	note $0a $0e
	duty $0f
	note $0a $0e
	duty $0e
	note $15 $15
	duty $0f
	note $15 $07
	duty $0e
	note $15 $0e
	duty $0f
	note $15 $07
	duty $0e
	note $15 $03
	duty $0f
	note $15 $04
	duty $0e
	note $15 $1c
	duty $0f
	note $15 $0e
	wait1 $0e
	duty $0e
	note $0e $0e
	duty $0f
	note $0e $0e
	duty $0e
	note $0e $0e
	duty $0f
	note $0e $07
	duty $0e
	note $0e $03
	duty $0f
	note $0e $04
	duty $0e
	note $0e $1c
	duty $0f
	note $0e $0e
	wait1 $0e
	duty $0e
	note $0f $0e
	duty $0f
	note $0f $0e
	duty $0e
	note $0f $0e
	duty $0f
	note $0f $0e
	duty $0e
	note $11 $0e
	duty $0f
	note $11 $0e
	duty $0e
	note $11 $0e
	duty $0f
	note $11 $0e
	duty $0e
	note $13 $0e
	duty $0f
	note $13 $0e
	duty $0e
	note $13 $0e
	duty $0f
	note $13 $0e
	duty $0e
	note $15 $0e
	duty $0f
	note $15 $0e
	duty $0e
	note $15 $0e
	duty $0f
	note $15 $0e
	duty $0e
	note $0e $0e
	duty $0f
	note $0e $0e
	duty $0e
	note $0e $0a
	duty $0f
	note $0e $0b
	duty $0e
	note $0e $03
	duty $0f
	note $0e $04
	duty $0e
	note $0e $38
	duty $0f
	note $0e $24
	wait1 $4c
	duty $0e
	note $0e $0e
	duty $0f
	note $0e $0e
	duty $0e
	note $0e $0a
	duty $0f
	note $0e $0b
	duty $0e
	note $0e $03
	duty $0f
	note $0e $04
	duty $0e
	note $0e $38
	duty $0f
	note $0e $24
	wait1 $4c
	goto musiceab6c
	cmdff
; $ead8a
; @addr{ead8a}
sound4aChannel6:
	cmdf2
	vol $3
	note $26 $02
	vol $2
	note $26 $02
	vol $2
	note $26 $03
musicead94:
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
	goto musicead94
	cmdff
; $eb1c5
sound33Start:
; @addr{eb1c5}
sound33Channel1:
	vibrato $e1
	env $0 $00
	cmdf2
	duty $02
musiceb1cc:
	vol $6
	note $23 $12
	note $22 $06
	wait1 $03
	vol $3
	note $22 $06
	wait1 $03
	vol $1
	note $22 $06
	wait1 $06
	vol $6
	note $26 $12
	note $25 $06
	wait1 $03
	vol $3
	note $25 $06
	wait1 $03
	vol $1
	note $25 $06
	wait1 $06
	vol $6
	note $23 $12
	note $22 $06
	wait1 $03
	vol $3
	note $22 $06
	wait1 $03
	vol $1
	note $22 $06
	wait1 $06
	vol $6
	note $26 $06
	wait1 $03
	vol $3
	note $26 $03
	vol $6
	note $26 $06
	note $25 $06
	wait1 $03
	vol $3
	note $25 $06
	wait1 $03
	vol $1
	note $25 $06
	wait1 $06
	vol $6
	note $23 $12
	note $22 $06
	wait1 $03
	vol $3
	note $22 $06
	wait1 $03
	vol $1
	note $22 $06
	wait1 $06
	vol $6
	note $26 $12
	note $25 $06
	wait1 $03
	vol $3
	note $25 $06
	wait1 $03
	vol $1
	note $25 $06
	wait1 $06
	vol $6
	note $23 $12
	note $22 $06
	wait1 $03
	vol $3
	note $22 $06
	wait1 $03
	vol $1
	note $22 $06
	wait1 $06
	vol $6
	note $26 $06
	wait1 $03
	vol $3
	note $26 $03
	vol $6
	note $26 $06
	note $25 $06
	wait1 $03
	vol $3
	note $25 $06
	vol $6
	note $25 $03
	note $26 $03
	note $27 $03
	note $28 $03
	note $29 $03
	note $2a $12
	note $28 $06
	wait1 $03
	vol $3
	note $28 $06
	wait1 $03
	vol $1
	note $28 $06
	wait1 $06
	vol $6
	note $2b $12
	note $2a $06
	wait1 $03
	vol $3
	note $2a $06
	wait1 $03
	vol $1
	note $2a $06
	wait1 $06
	vol $6
	note $2a $12
	note $28 $06
	wait1 $03
	vol $3
	note $28 $06
	wait1 $03
	vol $1
	note $28 $06
	wait1 $06
	vol $6
	note $2b $0c
	note $2d $06
	note $2a $06
	wait1 $03
	vol $3
	note $2a $06
	wait1 $03
	vol $1
	note $2a $06
	wait1 $06
	vol $6
	note $2a $12
	vol $6
	note $28 $06
	wait1 $03
	vol $3
	note $28 $06
	wait1 $03
	vol $1
	note $28 $06
	wait1 $06
	vol $6
	note $2b $12
	note $2a $06
	wait1 $03
	vol $3
	note $2a $06
	wait1 $03
	vol $1
	note $2a $06
	wait1 $06
	vol $6
	note $2a $12
	note $28 $06
	wait1 $03
	vol $3
	note $28 $06
	wait1 $03
	vol $1
	note $28 $06
	wait1 $06
	vol $6
	note $2b $06
	note $2d $06
	note $2a $06
	note $2b $06
	note $28 $06
	note $2a $06
	note $27 $06
	note $28 $06
	note $2a $06
	note $2b $06
	note $2c $06
	note $2d $06
	wait1 $03
	vol $3
	note $2d $06
	wait1 $03
	vol $1
	note $2d $06
	wait1 $06
	vol $6
	note $2d $06
	note $2e $06
	note $2f $06
	note $30 $06
	wait1 $03
	vol $3
	note $30 $06
	wait1 $03
	vol $1
	note $30 $06
	wait1 $06
	vol $6
	note $30 $06
	note $31 $06
	note $32 $06
	note $33 $06
	wait1 $03
	vol $3
	note $33 $06
	wait1 $03
	vol $1
	note $33 $06
	wait1 $06
	vol $6
	note $33 $06
	note $34 $06
	note $35 $06
	note $36 $06
	wait1 $03
	vol $3
	note $36 $06
	wait1 $03
	vol $1
	note $36 $06
	wait1 $06
	vol $6
	note $36 $06
	wait1 $03
	vol $3
	note $36 $03
	vol $6
	note $38 $03
	note $39 $03
	note $3a $03
	note $3b $03
	note $3c $3c
	wait1 $06
	note $39 $06
	note $3c $06
	note $36 $06
	note $39 $06
	note $33 $06
	note $36 $06
	note $30 $06
	note $33 $06
	note $2d $06
	note $30 $06
	note $2a $06
	note $2d $06
	note $27 $06
	note $2a $06
	note $24 $06
	note $27 $06
	note $21 $06
	goto musiceb1cc
	cmdff
; $eb380
; @addr{eb380}
sound33Channel0:
	vibrato $e1
	env $0 $00
	cmdf2
	duty $02
musiceb387:
	vol $6
	note $1f $12
	note $1e $06
	wait1 $03
	vol $3
	note $1e $06
	wait1 $03
	vol $1
	note $1e $06
	wait1 $06
	vol $6
	note $23 $12
	note $22 $06
	wait1 $03
	vol $3
	note $22 $06
	wait1 $03
	vol $1
	note $22 $06
	wait1 $06
	vol $6
	note $1f $12
	note $1e $06
	wait1 $03
	vol $3
	note $1e $06
	wait1 $03
	vol $1
	note $1e $06
	wait1 $06
	vol $6
	note $23 $06
	wait1 $03
	vol $3
	note $23 $03
	vol $6
	note $23 $06
	note $22 $06
	wait1 $03
	vol $3
	note $22 $06
	wait1 $03
	vol $1
	note $22 $06
	wait1 $06
	vol $6
	note $1f $12
	note $1e $06
	wait1 $03
	vol $3
	note $1e $06
	wait1 $03
	vol $1
	note $1e $06
	wait1 $06
	vol $6
	note $23 $12
	note $22 $06
	wait1 $03
	vol $3
	note $22 $06
	wait1 $03
	vol $1
	note $22 $06
	wait1 $06
	vol $6
	note $1f $12
	note $1e $06
	wait1 $03
	vol $3
	note $1e $06
	wait1 $03
	vol $1
	note $1e $06
	wait1 $06
	vol $6
	note $23 $06
	wait1 $03
	vol $3
	note $23 $03
	vol $6
	note $23 $06
	note $22 $06
	wait1 $03
	vol $3
	note $22 $06
	vol $6
	note $22 $03
	note $23 $03
	note $24 $03
	note $25 $03
	note $26 $03
	note $27 $12
	note $25 $06
	wait1 $03
	vol $3
	note $25 $06
	wait1 $03
	vol $1
	note $25 $06
	wait1 $06
	vol $6
	note $28 $12
	note $27 $06
	wait1 $03
	vol $3
	note $27 $06
	wait1 $03
	vol $1
	note $27 $06
	wait1 $06
	vol $6
	note $27 $12
	note $25 $06
	wait1 $03
	vol $3
	note $25 $06
	wait1 $03
	vol $1
	note $25 $06
	wait1 $06
	vol $6
	note $28 $0c
	note $28 $06
	note $27 $06
	wait1 $03
	vol $3
	note $27 $06
	wait1 $03
	vol $1
	note $27 $06
	wait1 $06
	vol $6
	note $27 $12
	note $25 $06
	wait1 $03
	vol $3
	note $25 $06
	wait1 $03
	vol $1
	note $25 $06
	wait1 $06
	vol $6
	note $28 $12
	note $27 $06
	wait1 $03
	vol $3
	note $27 $06
	wait1 $03
	vol $1
	note $27 $06
	wait1 $06
	vol $6
	note $27 $12
	note $25 $06
	wait1 $03
	vol $3
	note $25 $06
	wait1 $03
	vol $1
	note $25 $06
	wait1 $06
	vol $6
	note $28 $06
	note $2a $06
	note $27 $06
	note $28 $06
	note $25 $06
	note $27 $06
	note $23 $06
	note $25 $06
	note $27 $06
	note $28 $06
	note $29 $06
	note $2a $06
	wait1 $03
	vol $3
	note $2a $06
	wait1 $03
	vol $1
	note $2a $06
	wait1 $06
	vol $6
	note $2a $06
	note $2b $06
	note $2c $06
	note $2d $06
	wait1 $03
	vol $3
	note $2d $06
	wait1 $03
	vol $1
	note $2d $06
	wait1 $06
	vol $6
	note $2d $06
	note $2e $06
	note $2f $06
	note $30 $06
	wait1 $03
	vol $3
	note $30 $06
	wait1 $03
	vol $1
	note $30 $06
	wait1 $06
	vol $6
	note $30 $06
	note $31 $06
	note $32 $06
	note $33 $06
	wait1 $03
	vol $3
	note $33 $06
	wait1 $03
	vol $1
	note $33 $06
	wait1 $06
	vol $6
	note $33 $06
	wait1 $03
	vol $3
	note $33 $03
	vol $6
	note $34 $03
	note $36 $03
	note $37 $03
	note $38 $03
	note $39 $3c
	vol $3
	note $39 $0c
	vol $9
	note $21 $06
	note $20 $06
	note $1f $06
	note $1e $06
	note $1d $06
	note $1c $06
	note $1b $06
	note $1a $06
	note $19 $06
	note $18 $06
	note $17 $06
	note $16 $06
	note $15 $06
	note $14 $06
	note $13 $06
	note $12 $06
	goto musiceb387
	cmdff
; $eb53a
; @addr{eb53a}
sound33Channel4:
	cmdf2
musiceb53b:
	duty $12
	note $12 $04
	duty $0f
	note $12 $02
	duty $12
	note $13 $0a
	duty $0f
	note $13 $02
	duty $12
	note $12 $04
	duty $0f
	note $12 $02
	duty $12
	note $13 $0a
	duty $0f
	note $13 $02
	duty $12
	note $12 $04
	duty $0f
	note $12 $02
	duty $12
	note $13 $0a
	duty $0f
	note $13 $02
	duty $12
	note $12 $04
	duty $0f
	note $12 $02
	duty $12
	note $13 $0a
	duty $0f
	note $13 $02
	duty $12
	note $12 $05
	duty $0f
	note $12 $01
	duty $12
	note $13 $05
	duty $0f
	note $13 $01
	duty $12
	note $12 $05
	duty $0f
	note $12 $01
	duty $12
	note $13 $05
	duty $0f
	note $13 $01
	duty $12
	note $12 $04
	duty $0f
	note $12 $02
	duty $12
	note $13 $0a
	duty $0f
	note $13 $02
	duty $12
	note $12 $04
	duty $0f
	note $12 $02
	duty $12
	note $13 $0a
	duty $0f
	note $13 $02
	duty $12
	note $12 $04
	duty $0f
	note $12 $02
	duty $12
	note $13 $0a
	duty $0f
	note $13 $02
	duty $12
	note $12 $04
	duty $0f
	note $12 $02
	duty $12
	note $13 $0a
	duty $0f
	note $13 $02
	duty $12
	note $12 $05
	duty $0f
	note $12 $01
	duty $12
	note $13 $05
	duty $0f
	note $13 $01
	duty $12
	note $12 $05
	duty $0f
	note $12 $01
	duty $12
	note $13 $05
	duty $0f
	note $13 $01
	duty $12
	note $12 $04
	duty $0f
	note $12 $02
	duty $12
	note $13 $0a
	duty $0f
	note $13 $02
	duty $12
	note $12 $04
	duty $0f
	note $12 $02
	duty $12
	note $13 $0a
	duty $0f
	note $13 $02
	duty $12
	note $12 $04
	duty $0f
	note $12 $02
	duty $12
	note $13 $0a
	duty $0f
	note $13 $02
	duty $12
	note $12 $04
	duty $0f
	note $12 $02
	duty $12
	note $13 $0a
	duty $0f
	note $13 $02
	duty $12
	note $12 $05
	duty $0f
	note $12 $01
	duty $12
	note $13 $05
	duty $0f
	note $13 $01
	duty $12
	note $12 $05
	duty $0f
	note $12 $01
	duty $12
	note $13 $05
	duty $0f
	note $13 $01
	duty $12
	note $12 $04
	duty $0f
	note $12 $02
	duty $12
	note $13 $0a
	duty $0f
	note $13 $02
	duty $12
	note $12 $04
	duty $0f
	note $12 $02
	duty $12
	note $13 $0a
	duty $0f
	note $13 $02
	duty $12
	note $12 $04
	duty $0f
	note $12 $02
	duty $12
	note $13 $0a
	duty $0f
	note $13 $02
	duty $12
	note $12 $04
	duty $0f
	note $12 $02
	duty $12
	note $13 $0a
	duty $0f
	note $13 $02
	duty $12
	note $12 $05
	duty $0f
	note $12 $01
	duty $12
	note $13 $05
	duty $0f
	note $13 $01
	duty $12
	note $14 $05
	duty $0f
	note $14 $01
	duty $12
	note $15 $05
	duty $0f
	note $15 $01
	duty $12
	note $16 $04
	duty $0f
	note $16 $02
	duty $12
	note $17 $0a
	duty $0f
	note $17 $02
	duty $12
	note $16 $04
	duty $0f
	note $16 $02
	duty $12
	note $17 $0a
	duty $0f
	note $17 $02
	duty $12
	note $16 $04
	duty $0f
	note $16 $02
	duty $12
	note $17 $0a
	duty $0f
	note $17 $02
	duty $12
	note $16 $04
	duty $0f
	note $16 $02
	duty $12
	note $17 $0a
	duty $0f
	note $17 $02
	duty $12
	note $16 $05
	duty $0f
	note $16 $01
	duty $12
	note $17 $05
	duty $0f
	note $17 $01
	duty $12
	note $16 $05
	duty $0f
	note $16 $01
	duty $12
	note $17 $05
	duty $0f
	note $17 $01
	duty $12
	note $16 $04
	duty $0f
	note $16 $02
	duty $12
	note $17 $0a
	duty $0f
	note $17 $02
	duty $12
	note $16 $04
	duty $0f
	note $16 $02
	duty $12
	note $17 $0a
	duty $0f
	note $17 $02
	duty $12
	note $16 $04
	duty $0f
	note $16 $02
	duty $12
	note $17 $0a
	duty $0f
	note $17 $02
	duty $12
	note $16 $04
	duty $0f
	note $16 $02
	duty $12
	note $17 $0a
	duty $0f
	note $17 $02
	duty $12
	note $16 $05
	duty $0f
	note $16 $01
	duty $12
	note $17 $05
	duty $0f
	note $17 $01
	duty $12
	note $16 $05
	duty $0f
	note $16 $01
	duty $12
	note $17 $05
	duty $0f
	note $17 $01
	duty $12
	note $16 $04
	duty $0f
	note $16 $02
	duty $12
	note $17 $0a
	duty $0f
	note $17 $02
	duty $12
	note $16 $04
	duty $0f
	note $16 $02
	duty $12
	note $17 $0a
	duty $0f
	note $17 $02
	duty $12
	note $16 $04
	duty $0f
	note $16 $02
	duty $12
	note $17 $0a
	duty $0f
	note $17 $02
	duty $12
	note $16 $04
	duty $0f
	note $16 $02
	duty $12
	note $17 $0a
	duty $0f
	note $17 $02
	duty $12
	note $16 $05
	duty $0f
	note $16 $01
	duty $12
	note $17 $05
	duty $0f
	note $17 $01
	duty $12
	note $16 $05
	duty $0f
	note $16 $01
	duty $12
	note $17 $05
	duty $0f
	note $17 $01
	duty $12
	note $16 $04
	duty $0f
	note $16 $02
	duty $12
	note $17 $0a
	duty $0f
	note $17 $02
	duty $12
	note $16 $04
	duty $0f
	note $16 $02
	duty $12
	note $17 $0a
	duty $0f
	note $17 $02
	duty $12
	note $16 $04
	duty $0f
	note $16 $02
	duty $12
	note $17 $0a
	duty $0f
	note $17 $02
	duty $12
	note $16 $04
	duty $0f
	note $16 $02
	duty $12
	note $17 $0a
	duty $0f
	note $17 $02
	duty $12
	note $16 $05
	duty $0f
	note $16 $01
	duty $12
	note $17 $05
	duty $0f
	note $17 $01
	duty $12
	note $16 $05
	duty $0f
	note $16 $01
	duty $12
	note $17 $05
	duty $0f
	note $17 $01
	duty $12
	note $17 $06
	note $19 $06
	note $1a $06
	note $1b $06
	duty $0f
	note $1b $0c
	duty $0c
	note $1b $0c
	duty $12
	note $1b $06
	note $1c $06
	note $1d $06
	note $1e $06
	duty $0f
	note $1e $0c
	duty $0c
	note $1e $0c
	duty $12
	note $1e $06
	note $1f $06
	note $20 $06
	note $21 $06
	duty $0f
	note $21 $0c
	duty $0c
	note $21 $0c
	duty $12
	note $21 $06
	note $22 $06
	note $23 $06
	note $24 $06
	duty $0f
	note $24 $0c
	duty $0c
	note $24 $0c
	duty $12
	note $23 $02
	note $22 $02
	note $21 $02
	note $20 $02
	note $1f $02
	note $1e $02
	note $1d $02
	note $1c $02
	note $1b $02
	note $1a $02
	note $19 $02
	note $18 $02
	note $17 $3c
	wait1 $6c
	goto musiceb53b
	cmdff
; $eb8a5
; @addr{eb8a5}
sound33Channel6:
	cmdf2
musiceb8a6:
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
	goto musiceb8a6
	cmdff
; $ebc49
soundceStart:
; @addr{ebc49}
soundceChannel2:
	duty $02
	vol $5
	env $1 $00
	vibrato $00
	cmdf8 $04
	note $43 $05
	vol $3
	env $0 $07
	vibrato $00
	cmdf8 $ff
	note $48 $37
	cmdff
; $ebc5e
; @addr{ebc5e}
soundceChannel5:
	duty $08
	vibrato $00
	cmdf8 $04
	note $43 $05
	vibrato $00
	cmdf8 $ff
	note $48 $28
	cmdff
; $ebc6d
; @addr{ebc6d}
soundceChannel7:
	cmdf0 $20
	note $16 $12
	note $17 $01
	cmdf0 $20
	note $16 $14
	cmdf0 $24
	note $16 $1e
	cmdff
; $ebc7c
soundc1Start:
; @addr{ebc7c}
soundc1Channel2:
	duty $02
	vol $1
	note $4d $01
	note $52 $01
	note $56 $01
	note $4d $01
	note $46 $01
	note $56 $01
	vol $2
	note $4d $01
	note $52 $01
	note $56 $01
	note $4d $01
	note $46 $01
	note $56 $01
	vol $3
	note $4d $01
	note $51 $01
	note $56 $01
	note $4d $01
	note $45 $01
	note $56 $01
	vol $4
	note $4d $01
	note $51 $01
	note $56 $01
	note $4d $01
	note $45 $01
	note $56 $01
	vol $5
	note $4d $01
	note $50 $01
	note $56 $01
	note $4d $01
	note $44 $01
	note $56 $01
	vol $6
	note $4e $01
	note $50 $01
	note $56 $01
	note $4e $01
	note $44 $01
	note $56 $01
	vol $7
	note $4e $01
	note $4f $01
	note $56 $01
	note $4e $01
	note $43 $01
	note $56 $01
	vol $6
	note $4e $01
	note $4f $01
	note $56 $01
	note $4e $01
	note $43 $01
	note $56 $01
	vol $5
	note $4e $01
	note $4e $01
	note $56 $01
	note $4e $01
	note $42 $01
	note $56 $01
	vol $4
	note $4e $01
	note $4e $01
	note $56 $01
	note $4e $01
	note $42 $01
	note $56 $01
	vol $3
	note $4f $01
	note $4d $01
	note $56 $01
	note $4f $01
	note $41 $01
	note $56 $01
	note $4f $01
	note $4d $01
	note $56 $01
	vol $2
	note $4f $01
	note $41 $01
	note $56 $01
	note $4f $01
	note $4c $01
	note $56 $01
	note $4f $01
	note $40 $01
	note $56 $01
	vol $1
	note $4f $01
	note $4c $01
	note $56 $01
	note $4f $01
	note $40 $01
	note $56 $01
	note $4f $01
	note $4b $01
	env $0 $01
	note $56 $01
	cmdff
; $ebd3c
soundcfStart:
; @addr{ebd3c}
soundcfChannel2:
	duty $00
	env $0 $01
	vol $b
	cmdf8 $09
	note $3e $07
	cmdf8 $00
	vol $0
	wait1 $04
	vol $9
	cmdf8 $08
	note $3e $08
	cmdf8 $00
	vol $0
	wait1 $03
	vol $7
	cmdf8 $08
	note $3d $08
	cmdf8 $00
	vol $0
	wait1 $02
	vol $5
	cmdf8 $09
	note $3c $0a
	cmdf8 $00
	vol $4
	cmdf8 $0a
	note $3a $0a
	cmdf8 $00
	cmdff
; $ebd6d
soundc5Start:
; @addr{ebd6d}
soundc5Channel5:
	duty $0a
	cmdf8 $1e
	note $18 $05
	wait1 $02
	cmdf8 $2e
	note $18 $08
	wait1 $08
	cmdf8 $e2
	note $20 $08
	wait1 $06
	cmdf8 $d8
	note $20 $08
	cmdff
; $ebd86
soundc8Start:
; @addr{ebd86}
soundc8Channel2:
	duty $01
	vol $f
	note $3f $03
	vol $b
	env $0 $06
	note $3f $3c
	cmdff
; $ebd91
; @addr{ebd91}
soundc8Channel7:
	cmdf0 $41
	note $15 $01
	cmdff
; $ebd96
soundc6Start:
; @addr{ebd96}
soundc6Channel2:
	duty $00
	vol $d
	env $1 $00
	cmdf8 $f1
	note $41 $05
	cmdf8 $00
	wait1 $02
	vol $e
	env $1 $00
	cmdf8 $f1
	note $41 $05
	cmdf8 $00
	cmdff
; $ebdad
soundc2Start:
; @addr{ebdad}
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
musicebdd1:
	cmdf0 $b0
	note $25 $ff
	goto musicebdd1
	cmdff
; $ebdd9
soundc3Start:
; @addr{ebdd9}
soundc3Channel5:
	duty $03
	cmdf8 $0c
	note $37 $05
	vol $0
	wait1 $08
	cmdf8 $fe
	note $3e $05
	cmdf8 $00
	note $37 $01
	cmdf8 $0c
	note $37 $05
	vol $0
	wait1 $0a
	cmdf8 $fe
	note $3e $0f
	cmdff
; $ebdf6
soundc9Start:
; @addr{ebdf6}
soundc9Channel2:
	duty $00
	vol $1
	cmdf8 $02
	note $4b $01
	cmdf8 $00
	vol $1
	env $0 $01
	cmdf8 $02
	note $4b $02
	cmdf8 $00
	env $0 $00
	vol $2
	cmdf8 $02
	note $4b $02
	cmdf8 $00
	vol $1
	env $0 $01
	cmdf8 $02
	note $4b $01
	cmdf8 $00
	env $0 $00
	vol $3
	cmdf8 $02
	note $4b $02
	cmdf8 $00
	vol $1
	env $0 $01
	cmdf8 $02
	note $4b $01
	cmdf8 $00
	env $0 $00
	vol $4
	cmdf8 $03
	note $4b $02
	cmdf8 $00
	vol $1
	env $0 $01
	cmdf8 $02
	note $4b $01
	cmdf8 $00
	env $0 $00
	vol $5
	cmdf8 $03
	note $4b $02
	cmdf8 $00
	vol $1
	env $0 $01
	cmdf8 $02
	note $4b $01
	cmdf8 $00
	env $0 $00
	vol $6
	cmdf8 $03
	note $4b $02
	cmdf8 $00
	vol $1
	env $0 $01
	cmdf8 $02
	note $4b $01
	cmdf8 $00
	env $0 $00
	vol $7
	cmdf8 $04
	note $4b $02
	cmdf8 $00
	vol $1
	env $0 $01
	cmdf8 $02
	note $4b $01
	cmdf8 $00
	env $0 $00
	vol $7
	cmdf8 $04
	note $4b $02
	cmdf8 $00
	vol $1
	env $0 $01
	cmdf8 $02
	note $4b $01
	cmdf8 $00
	env $0 $00
	vol $7
	cmdf8 $04
	note $4b $02
	cmdf8 $00
	vol $1
	env $0 $01
	cmdf8 $02
	note $4b $01
	cmdf8 $00
	env $0 $00
	vol $6
	cmdf8 $05
	note $4b $02
	cmdf8 $00
	vol $1
	env $0 $01
	cmdf8 $02
	note $4b $01
	cmdf8 $00
	env $0 $00
	vol $6
	cmdf8 $05
	note $4b $02
	cmdf8 $00
	vol $1
	env $0 $01
	cmdf8 $02
	note $4b $01
	cmdf8 $00
	env $0 $00
	vol $6
	cmdf8 $05
	note $4b $02
	cmdf8 $00
	vol $1
	env $0 $01
	cmdf8 $02
	note $4b $01
	cmdf8 $00
	env $0 $00
	vol $5
	cmdf8 $05
	note $4b $02
	cmdf8 $00
	vol $1
	env $0 $01
	cmdf8 $02
	note $4b $01
	cmdf8 $00
	env $0 $00
	vol $5
	cmdf8 $05
	note $4b $02
	cmdf8 $00
	vol $1
	env $0 $01
	cmdf8 $02
	note $4b $01
	cmdf8 $00
	env $0 $00
	vol $5
	cmdf8 $05
	note $4b $02
	cmdf8 $00
	vol $1
	env $0 $01
	cmdf8 $02
	note $4b $01
	cmdf8 $00
	env $0 $00
	vol $4
	cmdf8 $05
	note $4b $02
	cmdf8 $00
	vol $1
	env $0 $01
	cmdf8 $02
	note $4b $01
	cmdf8 $00
	env $0 $00
	vol $4
	cmdf8 $05
	note $4b $02
	cmdf8 $00
	vol $1
	env $0 $01
	cmdf8 $02
	note $4b $01
	cmdf8 $00
	env $0 $00
	vol $4
	cmdf8 $05
	note $4b $02
	cmdf8 $00
	vol $1
	env $0 $01
	cmdf8 $02
	note $4b $01
	cmdf8 $00
	env $0 $00
	vol $3
	cmdf8 $05
	note $4b $02
	cmdf8 $00
	vol $1
	env $0 $01
	cmdf8 $02
	note $4b $01
	cmdf8 $00
	env $0 $00
	vol $3
	cmdf8 $05
	note $4b $02
	cmdf8 $00
	vol $1
	env $0 $01
	cmdf8 $02
	note $4b $01
	cmdf8 $00
	env $0 $00
	vol $3
	cmdf8 $05
	note $4b $02
	cmdf8 $00
	vol $1
	env $0 $01
	cmdf8 $02
	note $4b $01
	cmdf8 $00
	env $0 $00
	vol $2
	cmdf8 $05
	note $4b $02
	cmdf8 $00
	vol $1
	env $0 $01
	cmdf8 $02
	note $4b $01
	cmdf8 $00
	env $0 $00
	vol $2
	cmdf8 $05
	note $4b $02
	cmdf8 $00
	vol $1
	env $0 $01
	cmdf8 $02
	note $4b $01
	cmdf8 $00
	env $0 $00
	vol $2
	cmdf8 $05
	note $4b $02
	cmdf8 $00
	vol $1
	env $0 $01
	cmdf8 $02
	note $4b $01
	cmdf8 $00
	env $0 $00
	vol $1
	cmdf8 $05
	note $4b $02
	cmdf8 $00
	vol $1
	env $0 $01
	cmdf8 $02
	note $4b $01
	cmdf8 $00
	env $0 $00
	vol $1
	cmdf8 $05
	note $4b $02
	cmdf8 $00
	vol $1
	env $0 $01
	cmdf8 $02
	note $4b $01
	cmdf8 $00
	env $0 $00
	vol $1
	cmdf8 $05
	note $4b $02
	cmdf8 $00
	vol $1
	env $0 $01
	cmdf8 $02
	note $4b $01
	cmdf8 $00
	env $0 $00
	cmdff
; $ebfdf
sounda9Start:
; @addr{ebfdf}
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
; $ebffc
; GAP
	cmdff
	cmdff
	cmdff
	cmdff
.bank $3b slot 1
.org 0
sound02Start:
sound03Start:
sound04Start:
sound05Start:
sound08Start:
sound0aStart:
sound0bStart:
sound0cStart:
sound0dStart:
sound0fStart:
sound35Start:
sound43Start:
sound44Start:
sound45Start:
; @addr{ec000}
sound02Channel6:
sound03Channel6:
sound04Channel6:
sound05Channel6:
sound08Channel6:
sound0aChannel6:
sound0bChannel6:
sound0cChannel6:
sound0dChannel6:
sound0fChannel6:
sound35Channel6:
sound43Channel0:
sound43Channel1:
sound43Channel4:
sound43Channel6:
sound44Channel0:
sound44Channel1:
sound44Channel4:
sound44Channel6:
sound45Channel0:
sound45Channel1:
sound45Channel4:
sound45Channel6:
	cmdff
; $ec001
; @addr{ec001}
sound0aChannel1:
	vibrato $00
	env $0 $03
	duty $02
musicec007:
	vol $6
	note $33 $20
	note $36 $20
	note $31 $20
	note $33 $10
	note $34 $10
	note $33 $20
	note $36 $20
	note $31 $20
	note $2f $10
	note $31 $10
	note $33 $20
	note $36 $20
	note $3d $10
	note $3b $10
	note $36 $10
	note $33 $10
	note $36 $20
	note $34 $10
	note $33 $10
	note $31 $20
	note $34 $10
	note $36 $10
	note $38 $20
	note $3f $20
	note $3d $20
	note $3a $10
	note $38 $10
	note $36 $20
	note $3d $20
	note $3b $18
	wait1 $08
	note $3b $10
	note $3a $10
	vibrato $00
	env $0 $00
	note $38 $04
	wait1 $04
	vol $3
	note $38 $04
	wait1 $04
	vol $6
	note $31 $04
	wait1 $04
	vol $3
	note $31 $04
	wait1 $04
	vol $6
	note $3d $04
	wait1 $04
	vol $3
	note $3d $04
	wait1 $04
	vol $6
	note $31 $04
	wait1 $04
	vol $3
	note $31 $04
	wait1 $04
	vol $6
	note $38 $04
	wait1 $04
	vol $3
	note $38 $04
	wait1 $04
	vol $6
	note $31 $04
	wait1 $04
	vol $3
	note $31 $04
	wait1 $04
	vol $6
	note $3d $04
	wait1 $04
	vol $3
	note $3d $04
	wait1 $04
	vol $6
	note $31 $04
	wait1 $04
	vol $3
	note $31 $04
	wait1 $04
	vol $6
	note $36 $08
	note $38 $08
	note $36 $08
	note $38 $08
	note $36 $08
	wait1 $04
	vol $3
	note $36 $08
	wait1 $04
	vol $6
	note $3a $04
	note $3d $04
	note $42 $04
	wait1 $04
	vol $3
	note $3a $04
	note $3d $04
	note $42 $04
	wait1 $04
	vol $1
	note $3a $04
	note $3d $04
	note $42 $04
	wait1 $1c
	vibrato $00
	env $0 $03
	goto musicec007
	cmdff
; $ec0d2
; @addr{ec0d2}
sound0aChannel0:
	vibrato $00
	env $0 $03
	duty $02
musicec0d8:
	vol $6
	note $23 $10
	note $2a $10
	note $23 $10
	note $2a $10
	note $22 $10
	note $2a $10
	note $1e $10
	note $2a $10
	note $23 $10
	note $2a $10
	note $23 $10
	note $2a $10
	note $22 $10
	note $1e $10
	note $20 $10
	note $22 $10
	note $23 $10
	note $2a $10
	note $23 $10
	note $22 $10
	note $20 $10
	note $27 $10
	note $20 $10
	note $27 $10
	note $25 $10
	note $2c $10
	note $25 $10
	note $2c $10
	note $1e $10
	note $20 $10
	note $22 $10
	note $23 $10
	note $25 $10
	note $28 $10
	note $25 $10
	note $23 $10
	note $22 $10
	note $25 $10
	note $1e $10
	note $25 $10
	note $1b $10
	note $1c $10
	note $1e $10
	note $22 $10
	note $20 $10
	note $22 $10
	note $23 $10
	note $27 $10
	note $28 $20
	note $27 $20
	note $25 $20
	note $23 $20
	note $22 $10
	note $2a $10
	note $23 $10
	note $2a $10
	note $24 $10
	note $2a $10
	note $25 $10
	note $2a $10
	goto musicec0d8
	cmdff
; $ec155
; @addr{ec155}
sound0aChannel4:
	duty $0c
musicec157:
	note $33 $0e
	note $33 $20
	note $36 $20
	note $31 $20
	note $33 $10
	note $34 $10
	note $33 $20
	note $36 $20
	note $31 $20
	note $2f $10
	note $31 $10
	note $33 $20
	note $36 $20
	note $3d $10
	note $3b $10
	note $36 $10
	note $33 $10
	note $36 $20
	note $34 $10
	note $33 $10
	note $31 $20
	note $34 $10
	note $36 $10
	note $38 $20
	note $3f $20
	note $3d $20
	note $3a $10
	note $38 $10
	note $36 $20
	note $3d $20
	note $3b $18
	wait1 $08
	note $3b $10
	note $3a $10
	note $38 $10
	note $31 $10
	note $3d $10
	note $31 $10
	note $38 $10
	note $31 $10
	note $3d $10
	note $31 $10
	note $36 $08
	note $38 $08
	note $36 $08
	note $38 $08
	note $36 $10
	wait1 $08
	note $3a $04
	note $3d $04
	note $42 $04
	wait1 $2e
	goto musicec157
	cmdff
; $ec1c3
; @addr{ec1c3}
sound02Channel1:
musicec1c3:
	duty $02
	vol $a
	vibrato $00
	env $0 $01
	note $16 $0c
	note $22 $0c
	wait1 $0c
	note $22 $0c
	env $0 $02
	note $16 $0c
	env $0 $01
	note $22 $0c
	wait1 $0c
	note $22 $0c
	note $14 $0c
	env $0 $01
	note $20 $0c
	wait1 $0c
	note $20 $0c
	note $14 $0c
	env $0 $01
	note $20 $0c
	wait1 $0c
	note $20 $0c
	note $12 $0c
	env $0 $01
	note $1e $0c
	wait1 $0c
	note $1e $0c
	note $12 $0c
	env $0 $01
	note $1e $0c
	wait1 $0c
	note $1e $0c
	note $19 $0c
	env $0 $01
	note $25 $0c
	wait1 $0c
	note $25 $0c
	note $19 $0c
	env $0 $01
	note $25 $0c
	wait1 $0c
	note $25 $0c
	note $17 $0c
	env $0 $01
	note $23 $0c
	wait1 $0c
	note $23 $0c
	note $17 $0c
	env $0 $01
	note $23 $0c
	wait1 $0c
	note $23 $0c
	note $16 $0c
	env $0 $01
	note $22 $0c
	wait1 $0c
	note $22 $0c
	note $16 $0c
	env $0 $01
	note $22 $0c
	wait1 $0c
	note $22 $0c
	note $18 $0c
	note $24 $0c
	wait1 $0c
	note $24 $0c
	note $18 $0c
	note $24 $0c
	note $2e $0c
	note $24 $0c
	vibrato $00
	env $0 $03
	note $1d $0c
	vol $8
	env $0 $00
	note $2e $03
	env $0 $01
	vol $4
	note $2e $03
	vol $8
	env $0 $00
	note $2e $03
	env $0 $01
	vol $4
	note $2e $03
	vol $a
	env $0 $00
	note $2e $03
	env $0 $01
	vol $4
	note $2e $03
	env $0 $00
	vol $2
	note $2e $06
	vol $8
	env $0 $00
	note $2e $03
	env $0 $01
	vol $4
	note $2e $03
	vol $a
	env $0 $00
	note $2e $03
	env $0 $01
	vol $4
	note $2e $03
	env $0 $00
	vol $8
	note $2e $08
	vol $4
	note $2e $04
	vol $8
	env $0 $00
	note $18 $03
	env $0 $01
	vol $4
	note $18 $03
	vol $8
	env $0 $00
	note $18 $03
	env $0 $01
	vol $4
	note $18 $03
	vol $a
	env $0 $00
	note $18 $03
	env $0 $01
	vol $4
	note $18 $03
	env $0 $00
	vol $2
	note $18 $06
	vol $8
	env $0 $00
	note $18 $03
	env $0 $01
	vol $4
	note $18 $03
	vol $a
	env $0 $00
	note $18 $03
	env $0 $01
	vol $4
	note $18 $03
	env $0 $00
	vol $8
	note $1d $08
	vol $4
	note $1d $04
	vol $8
	env $0 $00
	note $2d $03
	env $0 $01
	vol $4
	note $2d $03
	vol $8
	env $0 $00
	note $2d $03
	env $0 $01
	vol $4
	note $2d $03
	vol $a
	env $0 $00
	note $2d $03
	env $0 $01
	vol $4
	note $2d $03
	env $0 $00
	vol $2
	note $2d $06
	vol $8
	env $0 $00
	note $2d $03
	env $0 $01
	vol $4
	note $2d $03
	vol $a
	env $0 $00
	note $2d $03
	env $0 $01
	vol $4
	note $2d $03
	env $0 $00
	vol $8
	note $2d $08
	vol $4
	note $2d $04
	vol $a
	env $0 $01
	note $11 $06
	vol $a
	note $11 $06
	vol $a
	note $11 $06
	vol $a
	note $12 $05
	vol $1
	note $12 $01
	vol $a
	note $13 $05
	vol $1
	note $13 $01
	vol $a
	note $15 $05
	vol $1
	note $15 $01
	goto musicec1c3
	cmdff
; $ec336
; @addr{ec336}
sound02Channel0:
musicec336:
	duty $02
	vol $0
	note $20 $6c
	vibrato $00
	env $0 $00
	vol $6
	note $3a $06
	wait1 $06
	note $3a $03
	wait1 $03
	note $3c $03
	wait1 $03
	note $3e $03
	wait1 $03
	note $3f $03
	wait1 $03
	vibrato $00
	env $0 $07
	note $41 $30
	wait1 $18
	vibrato $00
	env $0 $00
	note $3d $03
	wait1 $03
	note $42 $03
	wait1 $03
	note $44 $03
	wait1 $03
	note $46 $03
	wait1 $03
	vibrato $00
	env $0 $07
	note $49 $30
	wait1 $24
	vibrato $00
	env $0 $00
	note $3d $03
	wait1 $03
	note $3f $03
	wait1 $03
	note $41 $06
	wait1 $06
	note $3d $06
	wait1 $06
	vibrato $00
	env $0 $07
	note $38 $18
	wait1 $24
	vibrato $00
	env $0 $00
	note $3f $02
	wait1 $04
	note $41 $02
	wait1 $04
	note $42 $02
	wait1 $0a
	note $3f $02
	wait1 $04
	note $41 $02
	wait1 $04
	vibrato $00
	env $0 $04
	note $42 $18
	wait1 $24
	vibrato $00
	env $0 $00
	note $3d $02
	wait1 $04
	note $3f $02
	wait1 $04
	note $41 $02
	wait1 $0a
	note $3d $02
	wait1 $04
	note $3f $02
	wait1 $04
	vibrato $00
	env $0 $04
	note $41 $18
	wait1 $24
	vibrato $00
	env $0 $00
	note $3c $02
	wait1 $04
	note $3e $02
	wait1 $04
	note $40 $02
	wait1 $0a
	note $40 $02
	wait1 $04
	note $41 $02
	wait1 $04
	note $43 $02
	wait1 $04
	note $45 $02
	wait1 $04
	note $46 $02
	wait1 $04
	note $48 $02
	wait1 $04
	note $45 $06
	wait1 $06
	vol $8
	note $27 $03
	vol $2
	note $27 $03
	vol $8
	note $27 $03
	vol $2
	note $27 $03
	vol $a
	note $27 $03
	vol $2
	note $27 $03
	vol $1
	note $27 $06
	vol $8
	note $27 $03
	vol $2
	note $27 $03
	vol $8
	note $27 $03
	vol $2
	note $27 $03
	vol $a
	note $27 $08
	vol $3
	note $27 $0a
	vol $1
	note $27 $0a
	wait1 $20
	vol $8
	note $27 $03
	vol $2
	note $27 $03
	vol $8
	note $27 $03
	vol $2
	note $27 $03
	vol $a
	note $27 $03
	vol $2
	note $27 $03
	vol $1
	note $27 $06
	vol $8
	note $27 $03
	vol $2
	note $27 $03
	vol $8
	note $27 $03
	vol $2
	note $27 $03
	vol $a
	note $27 $08
	vol $3
	note $27 $0a
	vol $1
	note $27 $0a
	wait1 $14
	goto musicec336
	cmdff
; $ec45c
; @addr{ec45c}
sound02Channel4:
musicec45c:
	duty $01
	note $2e $06
	wait1 $12
	note $29 $1e
	wait1 $0c
	note $2e $04
	wait1 $02
	note $2e $06
	note $30 $03
	wait1 $03
	note $32 $03
	wait1 $03
	note $33 $03
	wait1 $03
	note $35 $2a
	wait1 $12
	note $35 $09
	wait1 $03
	note $35 $0c
	note $36 $03
	wait1 $03
	note $38 $03
	wait1 $03
	note $3a $2a
	wait1 $12
	note $3a $09
	wait1 $03
	note $3a $0c
	note $38 $03
	wait1 $03
	note $36 $03
	wait1 $03
	note $38 $06
	wait1 $0c
	note $36 $06
	note $35 $24
	wait1 $0c
	note $35 $18
	note $33 $0c
	wait1 $06
	note $35 $06
	note $36 $24
	wait1 $0c
	note $35 $0c
	note $33 $0c
	note $31 $0c
	wait1 $06
	note $33 $06
	note $35 $24
	wait1 $0c
	note $33 $0c
	note $31 $0c
	note $30 $0c
	wait1 $06
	note $32 $06
	note $34 $24
	wait1 $0c
	note $37 $18
	note $35 $08
	wait1 $b8
	goto musicec45c
	cmdff
; $ec4d8
sound11Start:
; @addr{ec4d8}
sound11Channel1:
	vibrato $00
	duty $02
	env $0 $00
	vol $5
	note $2e $07
	vol $3
	note $2e $07
	wait1 $0e
	env $0 $00
	vol $5
	note $29 $15
	vol $3
	note $29 $15
	env $0 $02
	vol $5
	note $2e $07
	wait1 $07
	vibrato $00
	env $0 $02
	note $2e $07
	note $30 $07
	note $32 $07
	note $33 $07
	vibrato $00
	env $0 $00
	note $35 $1c
	vol $3
	note $35 $0e
	vol $2
	note $35 $0e
	wait1 $38
	env $0 $00
	vol $5
	note $3a $07
	vol $3
	note $3a $07
	wait1 $0e
	env $0 $00
	vol $5
	note $35 $15
	vol $3
	note $35 $15
	env $0 $02
	vol $5
	note $3a $07
	wait1 $07
	env $0 $02
	note $3a $07
	note $3c $07
	note $3e $07
	note $3f $07
	env $0 $00
	note $41 $1c
	vol $3
	note $41 $0e
	vol $2
	note $41 $0e
	wait1 $38
musicec53e:
	env $0 $00
	vol $5
	note $2e $07
	vol $3
	note $2e $07
	wait1 $0e
	env $0 $00
	vol $5
	note $29 $15
	vol $3
	note $29 $15
	env $0 $02
	vol $5
	note $2e $07
	wait1 $07
	env $0 $02
	note $2e $07
	note $30 $07
	note $32 $07
	note $33 $07
	vibrato $00
	env $0 $00
	note $35 $1c
	vol $3
	note $35 $0e
	vol $2
	note $35 $0e
	wait1 $38
	env $0 $00
	vol $5
	note $3a $07
	vol $3
	note $3a $07
	wait1 $0e
	env $0 $00
	vol $5
	note $35 $15
	vol $3
	note $35 $15
	env $0 $02
	vol $5
	note $3a $07
	wait1 $07
	env $0 $02
	note $3a $07
	note $3c $07
	note $3e $07
	note $3f $07
	vibrato $00
	env $0 $08
	note $41 $1c
	vol $3
	note $41 $0e
	vol $2
	note $41 $0e
	wait1 $38
	goto musicec53e
	cmdff
; $ec5a4
; @addr{ec5a4}
sound11Channel0:
	vol $0
	note $20 $70
	vibrato $00
	env $0 $00
	duty $02
	vol $8
	note $20 $07
	vol $4
	note $20 $07
	wait1 $0e
	vol $8
	note $1b $15
	vol $3
	note $1b $15
	vol $8
	env $0 $01
	note $20 $07
	wait1 $07
	env $0 $00
	vol $8
	note $20 $04
	vol $2
	note $20 $03
	vol $8
	note $22 $04
	vol $2
	note $22 $03
	vol $8
	note $24 $04
	vol $2
	note $24 $03
	vol $8
	note $27 $04
	vol $2
	note $27 $03
	vol $8
	vol $8
	note $2a $04
	vol $2
	note $2a $03
	wait1 $85
	env $0 $00
	vol $8
	note $2c $07
	vol $4
	note $2c $07
	wait1 $0e
	vol $8
	note $27 $0e
	vol $3
	note $27 $0e
	env $0 $00
	vol $8
	note $2c $04
	vol $2
	note $2c $03
	vol $8
	note $27 $04
	vol $2
	note $27 $03
	vol $8
	note $24 $04
	vol $2
	note $24 $03
	vol $8
	note $20 $04
	vol $2
	note $20 $03
musicec60f:
	vol $8
	note $22 $04
	vol $2
	note $22 $03
	wait1 $69
	env $0 $00
	vol $8
	note $20 $07
	vol $4
	note $20 $07
	wait1 $0e
	vol $8
	note $1b $15
	vol $3
	note $1b $15
	vol $8
	env $0 $01
	note $20 $07
	wait1 $07
	env $0 $00
	vol $8
	note $20 $04
	vol $2
	note $20 $03
	vol $8
	note $22 $04
	vol $2
	note $22 $03
	vol $8
	note $24 $04
	vol $2
	note $24 $03
	vol $8
	note $27 $04
	vol $2
	note $27 $03
	vol $8
	note $2a $04
	vol $2
	note $2a $03
	wait1 $85
	env $0 $00
	vol $8
	note $2c $07
	vol $4
	note $2c $07
	wait1 $0e
	vol $8
	note $27 $0e
	vol $3
	note $27 $0e
	env $0 $00
	vol $8
	note $2c $04
	vol $2
	note $2c $03
	vol $8
	note $27 $04
	vol $2
	note $27 $03
	vol $8
	note $24 $04
	vol $2
	note $24 $03
	vol $8
	note $20 $04
	vol $2
	note $20 $03
	goto musicec60f
	cmdff
; $ec67e
; @addr{ec67e}
sound11Channel4:
	duty $0a
	note $16 $03
	duty $0d
	note $16 $05
	wait1 $06
	duty $0a
	note $16 $03
	duty $0d
	note $16 $05
	wait1 $14
	duty $0a
	note $16 $03
	duty $0d
	note $16 $05
	wait1 $06
	duty $0a
	note $16 $03
	duty $0d
	note $16 $05
	wait1 $06
	duty $0a
	note $16 $03
	duty $0d
	note $16 $05
	wait1 $14
	duty $0a
	note $16 $03
	duty $0d
	note $16 $05
	wait1 $06
	duty $0a
	note $14 $03
	duty $0d
	note $14 $05
	wait1 $06
	duty $0a
	note $14 $03
	duty $0d
	note $14 $05
	wait1 $14
	duty $0a
	note $14 $03
	duty $0d
	note $14 $05
	wait1 $06
	duty $0a
	note $14 $03
	duty $0d
	note $14 $05
	wait1 $06
	duty $0a
	note $14 $03
	duty $0d
	note $14 $05
	wait1 $14
	duty $0a
	note $14 $03
	duty $0d
	note $14 $05
	wait1 $06
	duty $0a
	note $12 $03
	duty $0d
	note $12 $05
	wait1 $06
	duty $0a
	note $12 $03
	duty $0d
	note $12 $05
	wait1 $14
	duty $0a
	note $12 $03
	duty $0d
	note $12 $05
	wait1 $06
	duty $0a
	note $12 $03
	duty $0d
	note $12 $05
	wait1 $06
	duty $0a
	note $12 $03
	duty $0d
	note $12 $05
	wait1 $14
	duty $0a
	note $12 $03
	duty $0d
	note $12 $05
	wait1 $06
	duty $0a
	note $14 $03
	duty $0d
	note $14 $05
	wait1 $06
	duty $0a
	note $14 $03
	duty $0d
	note $14 $05
	wait1 $14
	duty $0a
	note $14 $03
	duty $0d
	note $14 $05
	wait1 $06
	duty $0a
	note $14 $03
	duty $0d
	note $14 $05
	wait1 $06
	duty $0a
	note $14 $03
	duty $0d
	note $14 $05
	wait1 $14
	duty $0a
	note $14 $03
	duty $0d
	note $14 $05
	wait1 $06
musicec76e:
	duty $0a
	note $16 $03
	duty $0d
	note $16 $05
	wait1 $06
	duty $0a
	note $16 $03
	duty $0d
	note $16 $05
	wait1 $14
	duty $0a
	note $16 $03
	duty $0d
	note $16 $05
	wait1 $06
	duty $0a
	note $16 $03
	duty $0d
	note $16 $05
	wait1 $06
	duty $0a
	note $16 $03
	duty $0d
	note $16 $05
	wait1 $14
	duty $0a
	note $16 $03
	duty $0d
	note $16 $05
	wait1 $06
	duty $0a
	note $14 $03
	duty $0d
	note $14 $05
	wait1 $06
	duty $0a
	note $14 $03
	duty $0d
	note $14 $05
	wait1 $14
	duty $0a
	note $14 $03
	duty $0d
	note $14 $05
	wait1 $06
	duty $0a
	note $14 $03
	duty $0d
	note $14 $05
	wait1 $06
	duty $0a
	note $14 $03
	duty $0d
	note $14 $05
	wait1 $14
	duty $0a
	note $14 $03
	duty $0d
	note $14 $05
	wait1 $06
	duty $0a
	note $12 $03
	duty $0d
	note $12 $05
	wait1 $06
	duty $0a
	note $12 $03
	duty $0d
	note $12 $05
	wait1 $14
	duty $0a
	note $12 $03
	duty $0d
	note $12 $05
	wait1 $06
	duty $0a
	note $12 $03
	duty $0d
	note $12 $05
	wait1 $06
	duty $0a
	note $12 $03
	duty $0d
	note $12 $05
	wait1 $14
	duty $0a
	note $12 $03
	duty $0d
	note $12 $05
	wait1 $06
	duty $0a
	note $14 $03
	duty $0d
	note $14 $05
	wait1 $06
	duty $0a
	note $14 $03
	duty $0d
	note $14 $05
	wait1 $14
	duty $0a
	note $14 $03
	duty $0d
	note $14 $05
	wait1 $06
	duty $0a
	note $14 $03
	duty $0d
	note $14 $05
	wait1 $06
	duty $0a
	note $14 $03
	duty $0d
	note $14 $05
	wait1 $14
	duty $0a
	note $14 $03
	duty $0d
	note $14 $05
	wait1 $06
	goto musicec76e
	cmdff
; $ec862
; @addr{ec862}
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
musicec8c3:
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
	goto musicec8c3
	cmdff
; $ec927
; @addr{ec927}
sound0fChannel1:
	vibrato $00
	env $0 $02
	duty $02
musicec92d:
	vol $6
	note $23 $0c
	note $25 $0c
	note $28 $0c
	note $2b $0c
	note $2f $0c
	note $31 $0c
	note $34 $0c
	note $37 $0c
	note $3b $0c
	note $3d $0c
	note $40 $0c
	note $43 $0c
	note $47 $0c
	note $49 $0c
	note $4c $0c
	note $4f $0c
	note $22 $0c
	note $24 $0c
	note $27 $0c
	note $2a $0c
	note $2e $0c
	note $30 $0c
	note $33 $0c
	note $36 $0c
	note $3a $0c
	note $3c $0c
	note $3f $0c
	note $42 $0c
	note $46 $0c
	note $48 $0c
	note $4b $0c
	note $4e $0c
	goto musicec92d
	cmdff
; $ec972
; @addr{ec972}
sound0fChannel0:
	vol $1
	note $23 $06
	vibrato $00
	env $0 $02
	duty $02
musicec97b:
	vol $6
	note $23 $0c
	note $25 $0c
	note $28 $0c
	note $2b $0c
	note $2f $0c
	note $31 $0c
	note $34 $0c
	note $37 $0c
	note $3b $0c
	note $3d $0c
	note $40 $0c
	note $43 $0c
	note $47 $0c
	note $49 $0c
	note $4c $0c
	note $4f $0c
	note $22 $0c
	note $24 $0c
	note $27 $0c
	note $2a $0c
	note $2e $0c
	note $30 $0c
	note $33 $0c
	note $36 $0c
	note $3a $0c
	note $3c $0c
	note $3f $0c
	note $42 $0c
	note $46 $0c
	note $48 $0c
	note $4b $0c
	note $4e $0c
	goto musicec97b
	cmdff
; $ec9c0
; @addr{ec9c0}
sound0fChannel4:
	duty $0f
	wait1 $09
musicec9c4:
	note $23 $0c
	note $25 $0c
	note $28 $0c
	note $2b $0c
	note $2f $0c
	note $31 $0c
	note $34 $0c
	note $37 $0c
	note $3b $0c
	note $3d $0c
	note $40 $0c
	note $43 $0c
	note $47 $0c
	note $49 $0c
	note $4c $0c
	note $4f $0c
	note $22 $0c
	note $24 $0c
	note $27 $0c
	note $2a $0c
	note $2e $0c
	note $30 $0c
	note $33 $0c
	note $36 $0c
	note $3a $0c
	note $3c $0c
	note $3f $0c
	note $42 $0c
	note $46 $0c
	note $48 $0c
	note $4b $0c
	note $4e $0c
	goto musicec9c4
	cmdff
; $eca08
; @addr{eca08}
sound03Channel1:
	vibrato $00
	duty $02
	vol $6
	env $0 $04
	note $2b $18
	env $0 $02
	note $2b $08
	note $26 $08
	note $2b $08
	env $0 $04
	note $29 $18
	env $0 $02
	note $29 $08
	note $2b $08
	note $2d $08
	env $0 $04
	note $2e $18
	env $0 $02
	note $2e $08
	note $2b $08
	note $2e $08
	env $0 $04
	note $2d $18
	env $0 $02
	note $2d $08
	note $2e $08
	note $30 $08
	vibrato $e1
	env $0 $00
	note $32 $3c
	wait1 $0c
	vibrato $00
	env $0 $02
	note $30 $08
	note $30 $08
	note $30 $08
	vibrato $e1
	env $0 $00
	note $32 $3c
	wait1 $0c
	vibrato $00
	env $0 $00
	note $30 $04
	wait1 $04
	note $2f $04
	wait1 $04
	note $2d $04
	wait1 $04
musiceca67:
	vibrato $00
	env $0 $05
	note $2b $18
	note $26 $18
	env $0 $04
	wait1 $12
	note $2b $06
	note $2b $06
	note $2d $06
	note $2f $06
	note $30 $06
	env $0 $05
	note $32 $30
	env $0 $04
	wait1 $10
	note $32 $08
	note $32 $08
	note $33 $08
	note $35 $08
	env $0 $05
	note $37 $30
	env $0 $04
	wait1 $10
	note $37 $08
	note $37 $08
	note $35 $08
	note $33 $08
	vibrato $00
	env $0 $00
	note $35 $08
	wait1 $08
	note $33 $08
	vibrato $00
	env $0 $05
	note $32 $18
	env $0 $04
	wait1 $18
	note $32 $08
	note $33 $08
	note $32 $08
	note $30 $0c
	note $30 $06
	note $32 $06
	env $0 $05
	note $33 $18
	env $0 $04
	wait1 $18
	note $32 $0c
	note $30 $0c
	note $2e $0c
	note $2e $06
	note $30 $06
	env $0 $05
	note $32 $18
	env $0 $04
	wait1 $18
	note $30 $0c
	note $2e $0c
	note $2d $0c
	note $2d $06
	note $2f $06
	env $0 $05
	note $31 $18
	env $0 $04
	wait1 $18
	note $34 $18
	note $32 $0c
	vibrato $00
	env $0 $01
	duty $00
	vol $8
	note $26 $04
	note $26 $04
	note $26 $04
	vibrato $00
	vol $6
	env $0 $02
	note $28 $08
	note $28 $08
	note $28 $08
	vibrato $00
	env $0 $00
	vol $7
	note $2a $18
	vol $6
	wait1 $18
	vibrato $00
	env $0 $05
	duty $02
	note $2b $18
	note $26 $18
	env $0 $04
	wait1 $12
	note $2b $06
	note $2b $06
	note $2d $06
	note $2f $06
	note $30 $06
	env $0 $05
	note $32 $30
	env $0 $04
	wait1 $10
	note $32 $08
	note $32 $08
	note $33 $08
	note $35 $08
	env $0 $05
	note $37 $30
	env $0 $04
	wait1 $10
	note $37 $08
	note $37 $08
	note $35 $08
	note $33 $08
	vibrato $00
	env $0 $00
	note $35 $08
	wait1 $08
	note $33 $08
	vibrato $00
	env $0 $04
	note $32 $18
	env $0 $03
	wait1 $18
	note $32 $08
	note $33 $08
	note $32 $08
	note $30 $0c
	note $30 $06
	note $32 $06
	env $0 $05
	note $33 $18
	env $0 $04
	wait1 $18
	note $32 $0c
	note $30 $0c
	vol $6
	note $2e $08
	note $2d $08
	note $2e $08
	note $30 $08
	note $2e $08
	note $30 $08
	vibrato $00
	env $0 $00
	note $32 $08
	wait1 $08
	note $32 $08
	note $32 $08
	note $30 $08
	note $2e $08
	vibrato $e1
	env $0 $00
	vol $6
	note $32 $30
	note $3e $30
	vol $5
	note $37 $3c
	wait1 $0c
	vibrato $00
	env $0 $00
	vol $6
	duty $01
	note $32 $04
	wait1 $04
	note $33 $04
	wait1 $04
	note $35 $04
	wait1 $04
	vibrato $e1
	env $0 $00
	note $37 $12
	wait1 $06
	note $32 $18
	wait1 $12
	vibrato $00
	env $0 $00
	note $37 $03
	wait1 $03
	note $37 $03
	wait1 $03
	note $39 $03
	wait1 $03
	note $3a $03
	wait1 $03
	note $3c $03
	wait1 $03
	note $39 $05
	wait1 $0b
	note $35 $05
	wait1 $03
	vibrato $f1
	note $30 $18
	wait1 $0c
	vibrato $00
	env $0 $00
	note $30 $03
	wait1 $03
	note $32 $03
	wait1 $03
	note $35 $03
	wait1 $03
	note $33 $03
	wait1 $03
	note $32 $03
	wait1 $03
	note $30 $03
	wait1 $03
	note $32 $05
	wait1 $0b
	note $2b $04
	wait1 $04
	vibrato $e1
	env $0 $00
	note $2b $18
	wait1 $0c
	vibrato $00
	env $0 $00
	note $2b $03
	wait1 $03
	note $2a $03
	wait1 $03
	note $2b $03
	wait1 $03
	note $2d $03
	wait1 $03
	note $2e $03
	wait1 $03
	note $30 $03
	wait1 $03
	vibrato $e1
	env $0 $00
	note $32 $24
	wait1 $24
	vibrato $00
	env $0 $00
	note $32 $04
	wait1 $04
	note $30 $04
	wait1 $04
	note $32 $04
	wait1 $04
	note $3a $05
	wait1 $0b
	note $39 $05
	wait1 $03
	note $37 $18
	wait1 $08
	note $32 $04
	wait1 $04
	note $32 $04
	wait1 $04
	note $32 $04
	wait1 $04
	note $2e $04
	wait1 $04
	note $37 $04
	wait1 $04
	note $38 $05
	wait1 $0b
	note $3a $05
	wait1 $03
	note $3c $18
	wait1 $08
	note $3c $04
	wait1 $04
	note $3e $04
	wait1 $04
	note $3f $04
	wait1 $04
	note $41 $04
	wait1 $04
	note $3f $04
	wait1 $04
	vibrato $e1
	env $0 $00
	note $3e $3c
	vibrato $01
	env $0 $00
	vol $3
	note $3e $0c
	vol $2
	note $3e $0c
	wait1 $18
	vibrato $00
	env $0 $01
	duty $02
	vol $6
	note $32 $04
	note $32 $04
	note $32 $04
	vibrato $00
	env $0 $02
	note $34 $08
	note $34 $08
	note $34 $08
	env $0 $04
	note $36 $18
	wait1 $18
	vibrato $00
	env $0 $02
	goto musiceca67
	cmdff
; $eccba
; @addr{eccba}
sound03Channel0:
	vibrato $00
	duty $02
	vol $6
	env $0 $04
	note $23 $18
	env $0 $02
	note $23 $08
	note $23 $08
	note $23 $08
	env $0 $04
	note $21 $18
	note $21 $08
	note $23 $08
	note $24 $08
	env $0 $04
	note $27 $18
	env $0 $02
	note $27 $08
	note $27 $08
	note $27 $08
	env $0 $04
	note $29 $18
	env $0 $02
	note $29 $08
	note $29 $08
	note $29 $08
	vibrato $e1
	env $0 $00
	note $2b $2a
	vibrato $01
	env $0 $00
	vol $4
	note $2b $0c
	vol $2
	note $2b $0c
	wait1 $06
	vibrato $00
	env $0 $02
	vol $6
	note $29 $08
	note $29 $08
	note $29 $08
	vibrato $e1
	env $0 $00
	note $2b $2a
	vibrato $01
	env $0 $00
	vol $2
	note $2b $0c
	vol $1
	note $2b $0c
	wait1 $1e
musicecd1c:
	vibrato $00
	env $0 $03
	vol $6
	note $23 $18
	note $24 $08
	note $23 $08
	note $21 $08
	note $23 $12
	note $23 $06
	note $23 $06
	note $24 $06
	note $26 $06
	note $28 $06
	note $29 $12
	note $2b $06
	note $2b $06
	note $2d $06
	note $2f $06
	note $30 $06
	note $32 $18
	note $29 $08
	note $2b $08
	note $2d $08
	note $2e $10
	note $27 $08
	note $27 $06
	note $29 $06
	note $2b $06
	note $2d $06
	note $2e $06
	wait1 $0a
	note $2e $08
	note $2e $08
	note $2d $08
	note $2b $08
	note $2e $06
	wait1 $0a
	note $29 $08
	note $29 $08
	note $29 $08
	note $27 $08
	note $29 $08
	wait1 $08
	note $29 $08
	note $29 $08
	note $27 $08
	note $29 $08
	note $27 $0c
	note $27 $06
	note $26 $06
	note $27 $0c
	note $27 $06
	note $29 $06
	env $0 $05
	note $2b $18
	env $0 $03
	note $29 $0c
	note $27 $0c
	note $26 $0c
	note $26 $06
	note $24 $06
	note $26 $0c
	note $26 $06
	note $27 $06
	env $0 $05
	note $29 $18
	env $0 $03
	note $27 $0c
	note $26 $0c
	note $25 $18
	note $25 $0c
	note $25 $06
	note $26 $06
	note $28 $0c
	note $28 $06
	note $29 $06
	note $2b $06
	note $2d $06
	note $2f $06
	note $30 $06
	vibrato $00
	env $0 $05
	duty $01
	note $2d $18
	vibrato $00
	env $0 $03
	note $24 $08
	note $24 $08
	note $24 $08
	vol $7
	note $26 $18
	vol $6
	wait1 $18
	duty $02
	note $23 $18
	note $24 $08
	note $23 $08
	note $21 $08
	note $23 $12
	note $23 $06
	note $23 $06
	note $24 $06
	note $26 $06
	note $28 $06
	note $29 $12
	note $2b $06
	note $2b $06
	note $2d $06
	note $2f $06
	note $30 $06
	note $32 $18
	note $29 $08
	note $2b $08
	note $2d $08
	note $2e $10
	note $27 $08
	note $27 $06
	note $29 $06
	note $2b $06
	note $2d $06
	note $2e $06
	wait1 $0a
	note $2e $08
	note $2e $08
	note $2d $08
	note $2b $08
	note $2e $06
	wait1 $0a
	note $29 $08
	note $29 $08
	note $29 $08
	note $27 $08
	note $29 $08
	wait1 $08
	note $29 $08
	note $29 $08
	note $27 $08
	note $29 $08
	note $27 $0c
	note $27 $06
	note $26 $06
	note $27 $0c
	note $27 $06
	note $29 $06
	env $0 $05
	note $2b $18
	env $0 $03
	note $29 $0c
	note $27 $0c
	vibrato $e0
	env $2 $00
	vol $4
	note $1f $18
	note $1e $18
	note $1d $30
	vol $5
	note $1c $18
	vol $5
	note $18 $18
	note $1a $12
	wait1 $06
	vibrato $00
	env $0 $00
	vol $6
	note $1a $04
	vol $1
	note $1a $04
	vol $6
	note $26 $04
	vol $1
	note $26 $04
	vol $6
	note $24 $04
	vol $1
	note $24 $04
	vol $6
	note $22 $04
	vol $1
	note $22 $04
	vol $6
	note $21 $04
	vol $1
	note $21 $04
	vol $6
	note $1f $04
	vol $1
	note $1f $04
	vol $6
	note $21 $04
	vol $1
	note $21 $04
	wait1 $10
	vol $6
	note $1f $04
	vol $1
	note $1f $04
	wait1 $28
	duty $01
	vol $6
	note $2e $10
	wait1 $08
	note $2b $18
	wait1 $12
	note $2e $03
	wait1 $03
	note $2e $03
	wait1 $03
	note $30 $03
	wait1 $03
	note $32 $03
	wait1 $03
	note $33 $03
	wait1 $03
	note $30 $05
	wait1 $0b
	note $2e $05
	wait1 $03
	note $2d $18
	wait1 $18
	note $29 $14
	wait1 $04
	note $2b $05
	wait1 $0b
	note $26 $05
	wait1 $03
	note $26 $14
	wait1 $04
	note $24 $14
	wait1 $04
	note $28 $14
	wait1 $04
	note $2b $03
	wait1 $09
	note $2b $03
	wait1 $03
	note $2a $03
	wait1 $03
	note $2b $03
	wait1 $03
	note $2d $03
	wait1 $03
	note $2e $03
	wait1 $03
	note $30 $03
	wait1 $03
	note $32 $18
	vol $3
	note $32 $0c
	wait1 $0c
	vol $6
	note $32 $05
	wait1 $0b
	note $30 $05
	wait1 $03
	note $2e $18
	vol $3
	note $2e $0c
	vol $1
	note $2e $0c
	wait1 $18
	vol $6
	note $30 $05
	wait1 $0b
	note $33 $05
	wait1 $03
	note $38 $18
	vol $3
	note $38 $0c
	vol $1
	note $38 $0c
	wait1 $30
	vibrato $00
	env $0 $02
	duty $02
	vol $6
	note $2b $04
	wait1 $04
	note $2b $04
	wait1 $04
	note $2b $04
	wait1 $04
	env $0 $04
	note $2b $0c
	env $0 $02
	wait1 $3c
	note $30 $04
	wait1 $04
	note $30 $04
	wait1 $04
	note $30 $04
	wait1 $04
	env $0 $04
	note $32 $0c
	env $0 $02
	wait1 $24
	goto musicecd1c
	cmdff
; $ecf4f
; @addr{ecf4f}
sound03Channel4:
	duty $0e
	note $1f $04
	duty $0f
	note $1f $03
	wait1 $11
	duty $0e
	note $1f $04
	duty $0f
	note $1f $03
	wait1 $01
	duty $0e
	note $1f $04
	duty $0f
	note $1f $03
	wait1 $01
	duty $0e
	note $1f $04
	duty $0f
	note $1f $03
	wait1 $01
	duty $0e
	note $1d $04
	duty $0f
	note $1d $03
	wait1 $11
	duty $0e
	note $1d $04
	duty $0f
	note $1d $03
	wait1 $01
	duty $0e
	note $1d $04
	duty $0f
	note $1d $03
	wait1 $01
	duty $0e
	note $1d $04
	duty $0f
	note $1d $03
	wait1 $01
	duty $0e
	note $1b $04
	duty $0f
	note $1b $03
	wait1 $11
	duty $0e
	note $1b $04
	duty $0f
	note $1b $03
	wait1 $01
	duty $0e
	note $1b $04
	duty $0f
	note $1b $03
	wait1 $01
	duty $0e
	note $1b $04
	duty $0f
	note $1b $03
	wait1 $01
	duty $0e
	note $1d $04
	duty $0f
	note $1d $03
	wait1 $01
	duty $0e
	note $1d $04
	duty $0f
	note $1d $03
	wait1 $01
	duty $0e
	note $1d $04
	duty $0f
	note $1d $03
	wait1 $01
	duty $0e
	note $1d $04
	duty $0f
	note $1d $03
	wait1 $01
	duty $0e
	note $1b $04
	duty $0f
	note $1b $03
	wait1 $01
	duty $0e
	note $1d $04
	duty $0f
	note $1d $03
	wait1 $01
	duty $0e
	note $1f $04
	duty $0f
	note $1f $03
	wait1 $11
	duty $0e
	note $1f $04
	duty $0f
	note $1f $03
	wait1 $01
	duty $0e
	note $1f $04
	duty $0f
	note $1f $03
	wait1 $01
	duty $0e
	note $1f $04
	duty $0f
	note $1f $03
	wait1 $01
	duty $0e
	note $1f $04
	duty $0f
	note $1f $03
	wait1 $11
	duty $0e
	note $1a $04
	duty $0f
	note $1a $03
	wait1 $01
	duty $0e
	note $1a $04
	duty $0f
	note $1a $03
	wait1 $01
	duty $0e
	note $1a $04
	duty $0f
	note $1a $03
	wait1 $01
	duty $0e
	note $1f $04
	duty $0f
	note $1f $03
	wait1 $11
	duty $0e
	note $1f $04
	duty $0f
	note $1f $03
	wait1 $01
	duty $0e
	note $1f $04
	duty $0f
	note $1f $03
	wait1 $01
	duty $0e
	note $1f $04
	duty $0f
	note $1f $03
	wait1 $01
	duty $0e
	note $1f $04
	duty $0f
	note $1f $03
	wait1 $11
	duty $0e
	note $1a $04
	duty $0f
	note $1a $03
	wait1 $01
	duty $0e
	note $1a $04
	duty $0f
	note $1a $03
	wait1 $01
	duty $0e
	note $1a $04
	duty $0f
	note $1a $03
	wait1 $01
musiced0a3:
	duty $0e
	note $13 $04
	duty $0f
	note $13 $03
	wait1 $11
	duty $0e
	note $13 $04
	duty $0f
	note $13 $03
	wait1 $01
	duty $0e
	note $13 $04
	duty $0f
	note $13 $03
	wait1 $01
	duty $0e
	note $11 $04
	duty $0f
	note $11 $03
	wait1 $01
	duty $0e
	note $13 $04
	duty $0f
	note $13 $03
	wait1 $11
	duty $0e
	note $13 $04
	duty $0f
	note $13 $03
	wait1 $11
	duty $0e
	note $11 $04
	duty $0f
	note $11 $03
	wait1 $11
	duty $0e
	note $11 $04
	duty $0f
	note $11 $03
	wait1 $01
	duty $0e
	note $11 $04
	duty $0f
	note $11 $03
	wait1 $01
	duty $0e
	note $0f $04
	duty $0f
	note $0f $03
	wait1 $01
	duty $0e
	note $11 $04
	duty $0f
	note $11 $03
	wait1 $11
	duty $0e
	note $11 $04
	duty $0f
	note $11 $03
	wait1 $11
	duty $0e
	note $0f $04
	duty $0f
	note $0f $03
	wait1 $11
	duty $0e
	note $0f $04
	duty $0f
	note $0f $03
	wait1 $01
	duty $0e
	note $0f $04
	duty $0f
	note $0f $03
	wait1 $01
	duty $0e
	note $0e $04
	duty $0f
	note $0e $03
	wait1 $01
	duty $0e
	note $0f $04
	duty $0f
	note $0f $03
	wait1 $11
	duty $0e
	note $0f $04
	duty $0f
	note $0f $03
	wait1 $11
	duty $0e
	note $16 $04
	duty $0f
	note $16 $03
	wait1 $11
	duty $0e
	note $16 $04
	duty $0f
	note $16 $03
	wait1 $01
	duty $0e
	note $16 $04
	duty $0f
	note $16 $03
	wait1 $01
	duty $0e
	note $14 $04
	duty $0f
	note $14 $03
	wait1 $01
	duty $0e
	note $16 $04
	duty $0f
	note $16 $03
	wait1 $11
	duty $0e
	note $16 $04
	duty $0f
	note $16 $03
	wait1 $11
	duty $0e
	note $14 $04
	duty $0f
	note $14 $03
	wait1 $11
	duty $0e
	note $14 $04
	duty $0f
	note $14 $03
	wait1 $01
	duty $0e
	note $14 $04
	duty $0f
	note $14 $03
	wait1 $01
	duty $0e
	note $13 $04
	duty $0f
	note $13 $03
	wait1 $01
	duty $0e
	note $14 $04
	duty $0f
	note $14 $03
	wait1 $11
	duty $0e
	note $14 $04
	duty $0f
	note $14 $03
	wait1 $01
	duty $0e
	note $14 $04
	duty $0f
	note $14 $03
	wait1 $01
	duty $0e
	note $14 $04
	duty $0f
	note $14 $03
	wait1 $01
	duty $0e
	note $13 $04
	duty $0f
	note $13 $03
	wait1 $11
	duty $0e
	note $13 $04
	duty $0f
	note $13 $03
	wait1 $01
	duty $0e
	note $13 $04
	duty $0f
	note $13 $03
	wait1 $01
	duty $0e
	note $11 $04
	duty $0f
	note $11 $03
	wait1 $01
	duty $0e
	note $13 $04
	duty $0f
	note $13 $03
	wait1 $11
	duty $0e
	note $13 $04
	duty $0f
	note $13 $03
	wait1 $01
	duty $0e
	note $13 $04
	duty $0f
	note $13 $03
	wait1 $01
	duty $0e
	note $13 $04
	duty $0f
	note $13 $03
	wait1 $01
	duty $0e
	note $15 $04
	duty $0f
	note $15 $03
	wait1 $11
	duty $0e
	note $15 $04
	duty $0f
	note $15 $03
	wait1 $01
	duty $0e
	note $15 $04
	duty $0f
	note $15 $03
	wait1 $01
	duty $0e
	note $15 $04
	duty $0f
	note $15 $03
	wait1 $01
	duty $0e
	note $15 $04
	duty $0f
	note $15 $03
	wait1 $11
	duty $0e
	note $15 $04
	duty $0f
	note $15 $03
	wait1 $01
	duty $0e
	note $15 $04
	duty $0f
	note $15 $03
	wait1 $01
	duty $0e
	note $15 $04
	duty $0f
	note $15 $03
	wait1 $01
	duty $0e
	note $1a $04
	duty $0f
	note $1a $03
	wait1 $11
	duty $0e
	note $1f $04
	duty $0f
	note $1f $03
	wait1 $01
	duty $0e
	note $1f $04
	duty $0f
	note $1f $03
	wait1 $01
	duty $0e
	note $1f $04
	duty $0f
	note $1f $03
	wait1 $01
	duty $0e
	note $21 $18
	duty $0e
	note $1c $04
	duty $0f
	note $1c $04
	wait1 $04
	duty $0e
	note $1e $04
	duty $0f
	note $1e $04
	wait1 $04
	duty $0e
	note $13 $04
	duty $0f
	note $13 $03
	wait1 $11
	duty $0e
	note $13 $04
	duty $0f
	note $13 $03
	wait1 $01
	duty $0e
	note $13 $04
	duty $0f
	note $13 $03
	wait1 $01
	duty $0e
	note $11 $04
	duty $0f
	note $11 $03
	wait1 $01
	duty $0e
	note $13 $04
	duty $0f
	note $13 $03
	wait1 $11
	duty $0e
	note $13 $04
	duty $0f
	note $13 $03
	wait1 $11
	duty $0e
	note $11 $04
	duty $0f
	note $11 $03
	wait1 $11
	duty $0e
	note $11 $04
	duty $0f
	note $11 $03
	wait1 $01
	duty $0e
	note $11 $04
	duty $0f
	note $11 $03
	wait1 $01
	duty $0e
	note $0f $04
	duty $0f
	note $0f $03
	wait1 $01
	duty $0e
	note $11 $04
	duty $0f
	note $11 $03
	wait1 $11
	duty $0e
	note $11 $04
	duty $0f
	note $11 $03
	wait1 $11
	duty $0e
	note $0f $04
	duty $0f
	note $0f $03
	wait1 $11
	duty $0e
	note $0f $04
	duty $0f
	note $0f $03
	wait1 $01
	duty $0e
	note $0f $04
	duty $0f
	note $0f $03
	wait1 $01
	duty $0e
	note $0e $04
	duty $0f
	note $0e $03
	wait1 $01
	duty $0e
	note $0f $04
	duty $0f
	note $0f $03
	wait1 $11
	duty $0e
	note $0f $04
	duty $0f
	note $0f $03
	wait1 $11
	duty $0e
	note $16 $04
	duty $0f
	note $16 $03
	wait1 $11
	duty $0e
	note $16 $04
	duty $0f
	note $16 $03
	wait1 $01
	duty $0e
	note $16 $04
	duty $0f
	note $16 $03
	wait1 $01
	duty $0e
	note $14 $04
	duty $0f
	note $14 $03
	wait1 $01
	duty $0e
	note $16 $04
	duty $0f
	note $16 $03
	wait1 $11
	duty $0e
	note $16 $04
	duty $0f
	note $16 $03
	wait1 $11
	duty $0e
	note $14 $04
	duty $0f
	note $14 $03
	wait1 $11
	duty $0e
	note $20 $04
	duty $0f
	note $20 $03
	wait1 $01
	duty $0e
	note $20 $04
	duty $0f
	note $20 $03
	wait1 $01
	duty $0e
	note $1f $04
	duty $0f
	note $1f $03
	wait1 $01
	duty $0e
	note $20 $04
	duty $0f
	note $20 $03
	wait1 $11
	duty $0e
	note $20 $04
	duty $0f
	note $20 $03
	wait1 $01
	duty $0e
	note $20 $04
	duty $0f
	note $20 $03
	wait1 $01
	duty $0e
	note $20 $04
	duty $0f
	note $20 $03
	wait1 $01
	duty $14
	vol $8
	note $26 $08
	note $25 $08
	note $26 $08
	note $2a $08
	note $2b $08
	note $2d $08
	note $2e $08
	wait1 $08
	note $2e $08
	note $2e $08
	note $2d $08
	note $2b $08
	duty $15
	note $32 $0c
	wait1 $04
	note $2e $0c
	wait1 $04
	note $2b $10
	note $2a $10
	duty $14
	wait1 $08
	note $2a $08
	note $28 $08
	vol $9
	note $2a $08
	note $2b $08
	note $2d $08
	note $2e $08
	note $30 $08
	note $2e $08
	note $2d $08
	note $2e $18
	wait1 $18
	duty $0e
	note $0f $04
	duty $0f
	note $0f $03
	wait1 $11
	duty $0e
	note $1b $04
	duty $0f
	note $1b $03
	wait1 $01
	duty $0e
	note $1f $04
	duty $0f
	note $1f $03
	wait1 $01
	duty $0e
	note $22 $04
	duty $0f
	note $22 $03
	wait1 $01
	duty $0e
	note $27 $04
	duty $0f
	note $27 $03
	wait1 $11
	duty $0e
	note $0f $04
	duty $0f
	note $0f $03
	wait1 $01
	duty $0e
	note $0f $04
	duty $0f
	note $0f $03
	wait1 $01
	duty $0e
	note $0f $04
	duty $0f
	note $0f $03
	wait1 $01
	duty $0e
	note $0e $04
	duty $0f
	note $0e $03
	wait1 $11
	duty $0e
	note $1a $04
	duty $0f
	note $1a $03
	wait1 $01
	duty $0e
	note $1d $04
	duty $0f
	note $1d $03
	wait1 $01
	duty $0e
	note $21 $04
	duty $0f
	note $21 $03
	wait1 $01
	duty $0e
	note $26 $04
	duty $0f
	note $26 $03
	wait1 $11
	duty $0e
	note $1a $04
	duty $0f
	note $1a $03
	wait1 $01
	duty $0e
	note $1a $04
	duty $0f
	note $1a $03
	wait1 $01
	duty $0e
	note $1a $04
	duty $0f
	note $1a $03
	wait1 $01
	duty $0e
	note $13 $04
	duty $0f
	note $13 $03
	wait1 $11
	duty $0e
	note $13 $04
	duty $0f
	note $13 $03
	wait1 $01
	duty $0e
	note $13 $04
	duty $0f
	note $13 $03
	wait1 $01
	duty $0e
	note $13 $04
	duty $0f
	note $13 $03
	wait1 $01
	duty $0e
	note $13 $04
	duty $0f
	note $13 $03
	wait1 $11
	duty $0e
	note $13 $04
	duty $0f
	note $13 $03
	wait1 $01
	duty $0e
	note $13 $04
	duty $0f
	note $13 $03
	wait1 $01
	duty $0e
	note $13 $04
	duty $0f
	note $13 $03
	wait1 $01
	duty $0e
	note $13 $04
	duty $0f
	note $13 $03
	wait1 $11
	duty $0e
	note $13 $04
	duty $0f
	note $13 $03
	wait1 $01
	duty $0e
	note $13 $04
	duty $0f
	note $13 $03
	wait1 $01
	duty $0e
	note $13 $04
	duty $0f
	note $13 $03
	wait1 $01
	duty $0e
	note $13 $04
	duty $0f
	note $13 $03
	wait1 $09
	duty $0e
	note $13 $04
	duty $0f
	note $13 $03
	wait1 $09
	duty $0e
	note $11 $04
	duty $0f
	note $11 $03
	wait1 $09
	duty $0e
	note $0f $04
	duty $0f
	note $0f $03
	wait1 $11
	duty $0e
	note $0f $04
	duty $0f
	note $0f $03
	wait1 $01
	duty $0e
	note $13 $04
	duty $0f
	note $13 $03
	wait1 $01
	duty $0e
	note $16 $04
	duty $0f
	note $16 $03
	wait1 $01
	duty $0e
	note $1b $04
	duty $0f
	note $1b $03
	wait1 $11
	duty $0e
	note $0f $04
	duty $0f
	note $0f $03
	wait1 $01
	duty $0e
	note $0f $04
	duty $0f
	note $0f $03
	wait1 $01
	duty $0e
	note $0f $04
	duty $0f
	note $0f $03
	wait1 $01
	duty $0e
	note $14 $04
	duty $0f
	note $14 $03
	wait1 $11
	duty $0e
	note $14 $04
	duty $0f
	note $14 $03
	wait1 $01
	duty $0e
	note $18 $04
	duty $0f
	note $18 $03
	wait1 $01
	duty $0e
	note $1b $04
	duty $0f
	note $1b $03
	wait1 $01
	duty $0e
	note $20 $04
	duty $0f
	note $20 $03
	wait1 $11
	duty $0e
	note $14 $04
	duty $0f
	note $14 $03
	wait1 $01
	duty $0e
	note $14 $04
	duty $0f
	note $14 $03
	wait1 $01
	duty $0e
	note $14 $04
	duty $0f
	note $14 $03
	wait1 $01
	duty $0e
	note $0e $04
	duty $0f
	note $0e $03
	wait1 $11
	duty $0e
	note $24 $04
	duty $0f
	note $24 $03
	wait1 $01
	duty $0e
	note $24 $04
	duty $0f
	note $24 $03
	wait1 $01
	duty $0e
	note $24 $04
	duty $0f
	note $24 $03
	wait1 $01
	duty $0e
	note $24 $04
	duty $0f
	note $24 $03
	wait1 $11
	duty $0e
	note $0e $04
	duty $0f
	note $0e $03
	wait1 $01
	duty $0e
	note $0e $04
	duty $0f
	note $0e $03
	wait1 $01
	duty $0e
	note $0e $04
	duty $0f
	note $0e $03
	wait1 $01
	duty $0e
	note $0e $04
	duty $0f
	note $0e $03
	wait1 $11
	duty $0e
	note $2b $04
	duty $0f
	note $2b $03
	wait1 $01
	duty $0e
	note $2b $04
	duty $0f
	note $2b $03
	wait1 $01
	duty $0e
	note $2b $04
	duty $0f
	note $2b $03
	wait1 $01
	duty $0e
	note $2d $04
	duty $0f
	note $2d $03
	wait1 $01
	duty $0e
	note $1b $04
	duty $0f
	note $1b $03
	wait1 $01
	duty $0e
	note $1a $04
	duty $0f
	note $1a $03
	wait1 $01
	duty $0e
	note $18 $04
	duty $0f
	note $18 $03
	wait1 $01
	duty $0e
	note $16 $04
	duty $0f
	note $16 $03
	wait1 $01
	duty $0e
	note $15 $04
	duty $0f
	note $15 $03
	wait1 $01
	goto musiced0a3
	cmdff
; $ed6d5
; GAP
	cmdff
	cmdff
	cmdff
; @addr{ed6d8}
sound0bChannel1:
	vibrato $32
	env $0 $00
	duty $01
musiced6de:
	vol $7
	note $2b $15
	vibrato $00
	env $0 $00
	note $30 $07
	note $34 $07
	wait1 $03
	vol $3
	note $34 $04
	vol $7
	note $37 $07
	wait1 $03
	vol $3
	note $37 $04
	vibrato $32
	env $0 $00
	vol $7
	note $36 $1c
	vibrato $00
	env $0 $00
	note $37 $07
	wait1 $03
	vol $3
	note $37 $07
	wait1 $04
	vol $1
	note $37 $07
	vibrato $32
	env $0 $00
	vol $7
	note $3a $15
	vibrato $00
	env $0 $00
	note $39 $07
	note $38 $07
	wait1 $03
	vol $3
	note $38 $04
	vol $7
	note $37 $07
	wait1 $03
	vol $3
	note $37 $04
	vibrato $32
	env $0 $00
	vol $7
	note $36 $1c
	vibrato $00
	env $0 $00
	note $37 $07
	wait1 $03
	vol $3
	note $37 $07
	wait1 $04
	vol $1
	note $37 $07
	wait1 $0e
	vibrato $00
	env $0 $02
	vol $7
	note $39 $07
	note $38 $07
	note $37 $0e
	note $36 $0e
	note $35 $0e
	note $34 $0e
	note $33 $0e
	note $32 $0e
	note $31 $0e
	note $30 $0e
	note $2f $0e
	note $2d $0e
	note $2b $1c
	wait1 $1c
	vibrato $00
	env $0 $00
	vol $6
	note $1e $07
	vol $8
	note $1f $07
	vol $7
	note $1e $07
	vol $8
	note $1f $07
	vol $7
	note $22 $07
	wait1 $03
	vol $3
	note $22 $04
	vol $7
	note $22 $07
	wait1 $03
	vol $3
	note $22 $04
	vol $8
	note $1f $23
	vol $4
	note $1f $15
	vol $8
	note $1e $07
	vol $7
	note $1f $07
	vol $5
	note $1e $07
	vol $7
	note $1f $07
	vol $7
	note $26 $07
	wait1 $03
	vol $3
	note $26 $04
	vol $9
	note $26 $07
	wait1 $03
	vol $4
	note $26 $04
	vol $8
	note $1f $1c
	wait1 $2a
	vibrato $00
	env $0 $03
	vol $7
	note $35 $07
	note $34 $07
	note $33 $0e
	note $32 $0e
	note $31 $0e
	note $30 $0e
	note $2f $0e
	note $2e $0e
	note $2d $1c
	note $2c $1c
	note $2b $1c
	wait1 $1c
	vibrato $81
	env $0 $00
	note $34 $15
	note $30 $07
	note $2b $07
	wait1 $03
	vol $3
	note $2b $04
	vol $7
	note $2b $07
	wait1 $03
	vol $3
	note $2b $04
	vol $7
	note $35 $15
	note $31 $07
	note $2c $07
	wait1 $03
	vol $3
	note $2c $04
	vol $7
	note $2c $07
	wait1 $03
	vol $3
	note $2c $04
	vol $7
	note $34 $15
	note $30 $07
	note $2b $07
	wait1 $03
	vol $3
	note $2b $04
	vol $7
	note $2b $07
	wait1 $03
	vol $3
	note $2b $04
	vol $7
	note $32 $15
	note $2e $07
	note $29 $07
	wait1 $03
	vol $3
	note $29 $04
	vol $7
	note $29 $07
	wait1 $03
	vol $3
	note $29 $04
	vibrato $00
	env $0 $02
	vol $7
	note $2b $07
	wait1 $07
	note $37 $07
	note $36 $07
	note $35 $0e
	note $34 $0e
	note $33 $0e
	note $32 $0e
	note $31 $0e
	note $30 $0e
	note $2f $1c
	note $2e $1c
	note $2d $1c
	note $2b $1b
	wait1 $01
	vibrato $32
	env $0 $00
	goto musiced6de
	cmdff
; $ed845
; @addr{ed845}
sound0bChannel0:
	vibrato $00
	env $0 $02
	duty $01
musiced84b:
	vol $0
	note $20 $ee
	vol $a
	note $36 $07
	note $35 $07
	note $34 $0e
	note $33 $0e
	note $32 $0e
	note $31 $0e
	note $30 $0e
	note $2f $0e
	note $2e $0e
	note $2d $0e
	note $2b $07
	note $2a $07
	note $29 $07
	note $28 $07
	note $26 $07
	note $24 $07
	note $23 $07
	note $21 $07
	vol $b
	note $1f $0e
	wait1 $fc
	vol $7
	note $2d $07
	note $2c $07
	note $2b $0e
	note $2a $0e
	note $29 $0e
	note $28 $0e
	note $27 $0e
	note $26 $0e
	note $25 $1c
	note $24 $1c
	note $23 $1c
	wait1 $1c
	vibrato $81
	env $0 $00
	note $2b $1c
	note $28 $0e
	note $24 $0e
	note $2c $1c
	note $29 $0e
	note $25 $0e
	note $2b $1c
	note $28 $0e
	note $24 $0e
	note $29 $1c
	note $26 $0e
	note $22 $0e
	vibrato $00
	env $0 $02
	note $23 $0e
	note $32 $07
	note $31 $07
	note $30 $0e
	note $2f $0e
	note $2e $0e
	note $2d $0e
	note $2c $0e
	note $2b $0e
	note $2a $1c
	note $29 $1c
	note $28 $1c
	note $27 $1c
	goto musiced84b
	cmdff
; $ed8cf
; @addr{ed8cf}
sound0bChannel4:
	duty $0e
musiced8d1:
	vol $b
	note $18 $1c
	note $1f $07
	wait1 $07
	note $1f $07
	wait1 $07
	note $1b $1c
	note $1c $07
	wait1 $15
	note $18 $1c
	note $1f $07
	wait1 $07
	note $1f $07
	wait1 $07
	note $20 $1c
	note $1f $07
	wait1 $15
	note $18 $0e
	wait1 $ee
	vol $c
	note $13 $07
	wait1 $07
	note $13 $07
	wait1 $07
	vol $d
	note $13 $1c
	note $19 $03
	note $1a $07
	wait1 $2e
	note $13 $07
	wait1 $07
	vol $b
	note $13 $07
	wait1 $07
	vol $b
	note $13 $1c
	vol $c
	note $1e $03
	note $1f $07
	wait1 $cf
	vol $b
	note $13 $07
	vol $b
	note $12 $07
	note $13 $07
	note $12 $07
	note $13 $07
	note $18 $1c
	note $1e $07
	note $1f $07
	note $1e $07
	note $1f $07
	note $19 $1c
	note $1f $07
	note $20 $07
	note $1f $07
	note $20 $07
	note $18 $1c
	note $1e $07
	note $1f $07
	note $1e $07
	note $1f $07
	note $16 $1c
	note $1c $07
	note $1d $07
	note $1c $07
	note $1d $07
	note $13 $07
	wait1 $07
	note $2f $07
	note $2e $07
	note $2d $07
	wait1 $07
	note $2c $07
	wait1 $07
	note $2b $07
	wait1 $07
	note $2a $07
	wait1 $07
	note $29 $07
	wait1 $07
	note $28 $07
	wait1 $07
	note $27 $07
	wait1 $15
	note $26 $07
	wait1 $15
	note $25 $07
	wait1 $11
	note $12 $04
	note $13 $07
	wait1 $15
	goto musiced8d1
	cmdff
; $ed985
; @addr{ed985}
sound0cChannel1:
	vibrato $e1
	env $0 $00
	duty $02
musiced98b:
	vol $6
	note $2b $1c
	note $30 $07
	wait1 $03
	vol $3
	note $30 $04
	vol $6
	note $2b $07
	wait1 $03
	vol $3
	note $2b $04
	vol $6
	note $2a $1c
	note $2f $07
	wait1 $03
	vol $3
	note $2f $07
	wait1 $04
	vol $1
	note $2f $07
	vol $6
	note $2b $07
	wait1 $03
	vol $3
	note $2b $04
	vol $6
	note $2b $0e
	note $30 $0e
	note $2b $0e
	note $2a $0e
	note $31 $04
	wait1 $06
	vol $3
	note $31 $04
	vol $6
	note $2e $04
	wait1 $06
	vol $3
	note $2e $04
	vol $6
	note $2a $04
	wait1 $06
	vol $3
	note $2a $04
	vol $6
	note $34 $04
	note $35 $05
	note $36 $05
	note $37 $04
	wait1 $03
	vol $4
	note $37 $02
	wait1 $02
	vol $3
	note $37 $03
	wait1 $1c
	vol $6
	note $47 $04
	note $45 $05
	note $43 $05
	note $3f $04
	wait1 $03
	vol $4
	note $3f $02
	wait1 $02
	vol $2
	note $3f $03
	wait1 $1c
	vol $6
	note $2b $1c
	note $30 $07
	wait1 $03
	vol $3
	note $30 $04
	vol $6
	note $2b $07
	wait1 $03
	vol $3
	note $2b $04
	vol $6
	note $2a $0e
	note $31 $0e
	note $2e $0e
	vol $3
	note $2e $0e
	vol $6
	note $2b $07
	wait1 $03
	vol $3
	note $2b $04
	vol $6
	note $2b $0e
	note $30 $0e
	note $34 $0e
	note $36 $0e
	note $33 $0e
	wait1 $03
	vol $3
	note $33 $07
	wait1 $04
	vol $6
	note $39 $0e
	wait1 $38
	vibrato $00
	env $0 $02
	duty $00
	vol $6
	note $35 $0e
	vol $6
	note $2f $0e
	note $2f $0e
	note $35 $0e
	wait1 $38
	vol $6
	note $34 $0e
	wait1 $2a
	vibrato $e1
	env $0 $00
	duty $02
	goto musiced98b
	cmdff
; $eda5a
; @addr{eda5a}
sound0cChannel0:
	vibrato $00
	env $0 $03
	duty $02
musiceda60:
	vol $6
	note $18 $0e
	wait1 $0e
	note $1c $0e
	wait1 $0e
	note $13 $0e
	wait1 $0e
	note $1c $0e
	wait1 $0e
	note $18 $0e
	wait1 $0e
	note $1c $0e
	wait1 $0e
	note $13 $0e
	wait1 $0e
	note $1c $0e
	wait1 $2a
	vibrato $00
	env $0 $00
	vol $6
	note $10 $04
	note $11 $05
	note $12 $05
	note $13 $04
	wait1 $03
	vol $5
	note $13 $02
	wait1 $02
	vol $3
	note $13 $03
	wait1 $1c
	vol $6
	note $17 $04
	note $15 $05
	note $13 $05
	note $0f $04
	wait1 $03
	vol $4
	note $0f $02
	wait1 $05
	vibrato $00
	env $0 $03
	vol $6
	note $18 $0e
	wait1 $0e
	vol $6
	note $1c $0e
	wait1 $0e
	note $13 $0e
	wait1 $0e
	note $1c $0e
	wait1 $0e
	note $18 $0e
	wait1 $0e
	note $1c $0e
	wait1 $0e
	note $13 $0e
	wait1 $0e
	note $1c $0e
	wait1 $46
	vibrato $00
	env $0 $02
	duty $00
	vol $6
	note $31 $0e
	note $2b $0e
	note $2b $0e
	note $31 $0e
	wait1 $38
	note $30 $0e
	wait1 $2a
	vibrato $00
	env $0 $03
	duty $02
	goto musiceda60
	cmdff
; $edaef
; BACKWARD GAP
; @addr{edaef}
sound0cChannel4:
musicedaef:
	wait1 $ff
	wait1 $5f
	duty $17
	note $2b $07
	wait1 $07
	note $37 $07
	wait1 $23
	note $2b $07
	wait1 $07
	note $37 $07
	wait1 $23
	note $2b $07
	wait1 $07
	note $37 $07
	wait1 $23
	note $2b $07
	wait1 $07
	note $37 $07
	wait1 $15
	duty $10
	note $12 $03
	note $13 $6d
	wait1 $1c
	note $13 $07
	note $14 $07
	note $15 $07
	note $17 $05
	note $17 $02
	note $18 $07
	wait1 $07
	note $13 $07
	wait1 $05
	note $16 $02
	note $14 $0e
	note $13 $07
	wait1 $07
	goto musicedaef
	cmdff
; $edb3b
; @addr{edb3b}
sound0dChannel1:
	vibrato $00
	env $0 $03
	duty $02
musicedb41:
	vol $6
	note $15 $09
	vol $6
	note $1c $09
	note $1f $09
	note $24 $09
	note $23 $09
	note $26 $09
	note $2b $09
	note $30 $09
	note $2f $09
	note $2b $09
	note $26 $09
	note $24 $09
	note $23 $09
	note $1f $09
	note $1a $09
	note $18 $09
	note $17 $09
	note $1e $09
	note $1f $09
	note $26 $09
	note $23 $09
	note $2a $09
	note $2b $09
	note $32 $09
	note $31 $09
	note $2b $09
	note $2a $09
	note $26 $09
	note $25 $09
	note $1f $09
	note $1e $09
	note $19 $09
	note $18 $09
	note $1f $09
	note $22 $09
	note $27 $09
	note $24 $09
	note $2b $09
	note $2e $09
	note $33 $09
	note $32 $09
	note $2e $09
	note $29 $09
	note $27 $09
	note $26 $09
	note $22 $09
	note $1d $09
	note $1b $09
	note $1a $09
	note $1f $09
	note $21 $09
	note $24 $09
	note $26 $09
	note $2b $09
	note $30 $09
	note $35 $09
	note $34 $09
	note $30 $09
	note $2b $09
	note $29 $09
	note $28 $09
	note $24 $09
	note $1f $09
	note $1c $09
	goto musicedb41
	cmdff
; $edbc7
; @addr{edbc7}
sound0dChannel0:
	vibrato $00
	env $0 $03
	duty $02
	vol $1
	note $15 $09
	note $1c $04
musicedbd2:
	vol $4
	note $15 $09
	vol $4
	note $1c $09
	note $1f $09
	note $24 $09
	note $23 $09
	note $26 $09
	note $2b $09
	note $30 $09
	note $2f $09
	note $2b $09
	note $26 $09
	note $24 $09
	note $23 $09
	note $1f $09
	note $1a $09
	note $18 $09
	note $17 $09
	note $1e $09
	note $1f $09
	note $26 $09
	note $23 $09
	note $2a $09
	note $2b $09
	note $32 $09
	note $31 $09
	note $2b $09
	note $2a $09
	note $26 $09
	note $25 $09
	note $1f $09
	note $1e $09
	note $19 $09
	note $18 $09
	note $1f $09
	note $22 $09
	note $27 $09
	note $24 $09
	note $2b $09
	note $2e $09
	note $33 $09
	note $32 $09
	note $2e $09
	note $29 $09
	note $27 $09
	note $26 $09
	note $22 $09
	note $1d $09
	note $1b $09
	note $1a $09
	note $1f $09
	note $21 $09
	note $24 $09
	note $26 $09
	note $2b $09
	note $30 $09
	note $35 $09
	note $34 $09
	note $30 $09
	note $2b $09
	note $29 $09
	note $28 $09
	note $24 $09
	note $1f $09
	note $1c $09
	goto musicedbd2
	cmdff
; $edc58
; @addr{edc58}
sound0dChannel4:
	duty $08
	note $15 $09
	note $1c $09
	note $1f $09
musicedc60:
	note $15 $09
	note $1c $09
	note $1f $09
	note $24 $09
	note $23 $09
	note $26 $09
	note $2b $09
	note $30 $09
	note $2f $09
	note $2b $09
	note $26 $09
	note $24 $09
	note $23 $09
	note $1f $09
	note $1a $09
	note $18 $09
	note $17 $09
	note $1e $09
	note $1f $09
	note $26 $09
	note $23 $09
	note $2a $09
	note $2b $09
	note $32 $09
	note $31 $09
	note $2b $09
	note $2a $09
	note $26 $09
	note $25 $09
	note $1f $09
	note $1e $09
	note $19 $09
	note $18 $09
	note $1f $09
	note $22 $09
	note $27 $09
	note $24 $09
	note $2b $09
	note $2e $09
	note $33 $09
	note $32 $09
	note $2e $09
	note $29 $09
	note $27 $09
	note $26 $09
	note $22 $09
	note $1d $09
	note $1b $09
	note $1a $09
	note $1f $09
	note $21 $09
	note $24 $09
	note $26 $09
	note $2b $09
	note $30 $09
	note $35 $09
	note $34 $09
	note $30 $09
	note $2b $09
	note $29 $09
	note $28 $09
	note $24 $09
	note $1f $09
	note $1c $09
	goto musicedc60
	cmdff
; $edce4
; @addr{edce4}
sound04Channel1:
	vibrato $00
	env $0 $00
musicedce8:
	vol $6
	note $21 $12
	note $26 $12
	note $2b $12
	note $28 $12
	note $2d $12
	note $26 $12
	note $2b $12
	note $2a $12
	note $28 $12
	note $2f $12
	note $2d $12
	note $26 $12
	note $2b $12
	note $28 $12
	note $2a $12
	note $2b $12
	vibrato $00
	env $0 $04
	note $2d $12
	note $2f $12
	note $30 $12
	note $37 $09
	wait1 $51
	note $2d $12
	note $2f $12
	note $30 $12
	note $36 $09
	wait1 $51
	vibrato $00
	env $0 $00
	note $2f $12
	note $2b $12
	note $28 $12
	note $2d $12
	note $2b $12
	note $26 $12
	note $28 $12
	note $2d $12
	note $2a $12
	note $2b $12
	note $32 $12
	note $2f $12
	note $31 $12
	note $2d $12
	note $2b $12
	note $2f $12
	vibrato $00
	env $0 $04
	note $36 $12
	note $37 $12
	note $39 $12
	note $3b $09
	wait1 $51
	note $34 $12
	note $36 $12
	note $37 $12
	note $39 $09
	wait1 $51
	vibrato $00
	env $0 $00
	goto musicedce8
	cmdff
; $edd65
; @addr{edd65}
sound04Channel0:
	vibrato $00
	env $0 $00
musicedd69:
	vol $1
	note $21 $0b
	vol $4
	note $21 $12
	note $26 $12
	note $2b $12
	note $28 $12
	vol $4
	note $2d $12
	note $26 $12
	note $2b $12
	note $2a $12
	note $28 $12
	note $2f $12
	note $2d $12
	note $26 $12
	vol $4
	note $2b $12
	note $28 $12
	note $2a $12
	note $2b $12
	wait1 $1f
	vibrato $00
	env $0 $04
	vol $4
	note $2f $12
	note $30 $12
	note $37 $09
	wait1 $51
	note $2d $12
	note $2f $12
	note $30 $12
	note $36 $09
	wait1 $44
	vibrato $00
	env $0 $00
	vol $4
	note $2f $12
	note $2b $12
	note $28 $12
	note $2d $12
	note $2b $12
	note $26 $12
	note $28 $12
	note $2d $12
	note $2a $12
	note $2b $12
	note $32 $12
	note $2f $12
	note $31 $12
	note $2d $12
	note $2b $12
	note $2f $12
	wait1 $1f
	vibrato $00
	env $0 $04
	vol $4
	note $37 $12
	note $39 $12
	note $3b $09
	wait1 $51
	note $34 $12
	note $36 $12
	note $37 $12
	note $39 $09
	wait1 $39
	vibrato $00
	env $0 $00
	goto musicedd69
	cmdff
; $eddee
; @addr{eddee}
sound04Channel4:
musiceddee:
	duty $0e
	note $15 $24
	note $1c $24
	note $1a $36
	duty $0f
	note $1a $12
	duty $0e
	note $15 $12
	note $1c $12
	note $1f $12
	note $1c $12
	note $1e $24
	note $1c $12
	note $1a $12
	duty $0e
	note $15 $24
	duty $0f
	note $15 $12
	duty $0c
	note $15 $12
	duty $0e
	note $15 $09
	duty $0f
	note $15 $09
	duty $0e
	note $15 $09
	duty $0f
	note $15 $09
	wait1 $24
	duty $0e
	note $15 $24
	duty $0f
	note $15 $12
	duty $0c
	note $15 $12
	duty $0e
	note $15 $09
	duty $0f
	note $15 $09
	duty $0e
	note $15 $09
	duty $0f
	note $15 $09
	wait1 $24
	duty $0e
	note $15 $24
	note $1c $24
	note $1a $2d
	duty $0f
	note $1a $1b
	duty $0e
	note $15 $12
	note $1c $12
	note $23 $12
	note $21 $12
	note $28 $12
	note $25 $12
	note $23 $12
	note $1f $12
	duty $0e
	note $15 $24
	duty $0f
	note $15 $12
	duty $0c
	note $15 $12
	duty $0e
	note $15 $09
	duty $0f
	note $15 $09
	duty $0e
	note $15 $09
	duty $0f
	note $15 $09
	wait1 $24
	duty $0e
	note $15 $24
	duty $0f
	note $15 $12
	duty $0c
	note $15 $12
	duty $0e
	note $15 $09
	duty $0f
	note $15 $09
	duty $0e
	note $15 $09
	duty $0f
	note $15 $09
	wait1 $24
	goto musiceddee
	cmdff
; $edea4
; GAP
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
sound07Start:
; @addr{edeaa}
sound07Channel1:
	vibrato $f1
	env $0 $00
	duty $01
musicedeb0:
	vol $6
	note $29 $07
	wait1 $03
	vol $3
	note $29 $07
	wait1 $04
	vol $6
	note $24 $07
	note $29 $2a
	vibrato $01
	env $0 $00
	vol $3
	note $29 $0e
	vibrato $f1
	env $0 $00
	vol $6
	note $2b $0e
	note $2c $07
	note $2e $07
	note $30 $07
	wait1 $03
	vol $3
	note $30 $07
	wait1 $04
	vol $6
	note $27 $07
	note $30 $31
	vibrato $01
	env $0 $00
	vol $3
	note $30 $07
	vibrato $f1
	env $0 $00
	vol $6
	note $31 $0e
	note $33 $07
	note $31 $07
	note $30 $07
	wait1 $03
	vol $3
	note $30 $07
	wait1 $04
	vol $6
	note $27 $07
	note $30 $31
	vibrato $01
	env $0 $00
	vol $3
	note $30 $07
	vibrato $f1
	env $0 $00
	vol $6
	note $2e $0e
	note $2c $07
	note $2e $07
	note $30 $3f
	vibrato $01
	env $0 $00
	vol $3
	note $30 $15
	vibrato $f1
	env $0 $00
	vol $6
	note $30 $1c
	note $31 $0e
	wait1 $03
	vol $3
	note $31 $04
	vol $6
	note $2e $15
	note $29 $0e
	note $28 $0e
	note $2b $0e
	note $31 $0e
	note $2e $0e
	note $30 $2a
	note $2e $0e
	note $2c $0e
	wait1 $03
	vol $3
	note $2c $07
	wait1 $0b
	vol $6
	note $30 $07
	note $35 $07
	note $37 $07
	note $38 $07
	note $37 $07
	note $35 $15
	vol $3
	note $35 $07
	vol $6
	note $38 $07
	note $37 $07
	note $35 $15
	vol $3
	note $35 $07
	vol $6
	note $38 $07
	note $39 $07
	note $3a $07
	note $3b $07
	note $3c $2a
	note $37 $0e
	note $30 $07
	wait1 $03
	vol $3
	note $30 $07
	wait1 $0b
	vol $6
	note $30 $1c
	note $31 $07
	wait1 $03
	vol $3
	note $31 $07
	wait1 $04
	vol $6
	note $29 $07
	note $31 $31
	note $2e $07
	note $33 $07
	note $31 $07
	note $30 $07
	note $2e $03
	vol $3
	note $2e $04
	vol $6
	note $2e $07
	wait1 $03
	vol $3
	note $2e $07
	wait1 $04
	vol $6
	note $30 $03
	vol $3
	note $30 $04
	vol $6
	note $30 $31
	vibrato $01
	env $0 $00
	vol $3
	note $30 $07
	vibrato $f1
	env $0 $00
	vol $6
	note $30 $15
	vibrato $01
	env $0 $00
	vol $3
	note $30 $07
	vibrato $f1
	env $0 $00
	vol $6
	note $2e $07
	wait1 $03
	vol $3
	note $2e $07
	wait1 $04
	vol $6
	note $26 $07
	note $2e $2a
	vibrato $01
	env $0 $00
	vol $3
	note $2e $07
	vibrato $f1
	env $0 $00
	vol $6
	note $28 $07
	note $30 $07
	note $2e $07
	note $2c $07
	note $2b $03
	vol $3
	note $2b $04
	vol $6
	note $2b $1c
	vibrato $01
	env $0 $00
	vol $3
	note $2b $07
	vibrato $f1
	env $0 $00
	vol $6
	note $29 $03
	vol $3
	note $29 $04
	vol $6
	note $29 $07
	note $2b $07
	note $2c $0e
	vol $3
	note $2c $0e
	vol $6
	note $2e $0e
	note $30 $0e
	note $31 $07
	wait1 $03
	vol $3
	note $31 $07
	wait1 $04
	vol $6
	note $29 $07
	note $31 $2a
	vibrato $01
	env $0 $00
	vol $3
	note $31 $07
	vibrato $f1
	env $0 $00
	vol $6
	note $2e $07
	note $33 $07
	note $35 $07
	note $33 $07
	note $31 $07
	note $30 $2a
	note $32 $0e
	note $34 $15
	vibrato $01
	env $0 $00
	vol $3
	note $34 $07
	vibrato $f1
	env $0 $00
	vol $6
	note $35 $0e
	note $37 $0e
	note $38 $07
	wait1 $03
	vol $3
	note $38 $07
	wait1 $04
	vol $6
	note $2f $07
	note $38 $2a
	vibrato $01
	env $0 $00
	vol $3
	note $38 $07
	vibrato $f1
	env $0 $00
	vol $6
	note $37 $07
	note $38 $07
	note $39 $07
	note $3a $07
	note $3b $07
	note $3c $07
	wait1 $03
	vol $3
	note $3c $07
	wait1 $04
	vol $6
	note $37 $07
	note $3c $3f
	vibrato $01
	env $0 $00
	vol $3
	note $3c $0e
	wait1 $07
	vibrato $f1
	env $0 $00
	goto musicedeb0
	cmdff
; $ee084
; @addr{ee084}
sound07Channel0:
	vibrato $f1
	env $0 $00
	duty $02
musicee08a:
	vol $6
	note $20 $07
	wait1 $03
	vol $3
	note $20 $04
	vol $6
	note $20 $07
	note $1d $07
	note $20 $07
	wait1 $03
	vol $3
	note $20 $04
	vol $6
	note $20 $07
	note $1d $07
	note $20 $07
	wait1 $03
	vol $3
	note $20 $04
	vol $6
	note $20 $07
	note $1d $07
	note $22 $07
	note $1b $07
	note $1d $07
	note $1f $07
	note $20 $07
	wait1 $03
	vol $3
	note $20 $04
	vol $6
	note $20 $03
	vol $3
	note $20 $04
	vol $6
	note $20 $03
	vol $3
	note $20 $04
	vol $6
	note $20 $07
	wait1 $03
	vol $3
	note $20 $04
	vol $6
	note $1b $07
	note $20 $07
	note $24 $07
	wait1 $03
	vol $3
	note $24 $04
	vol $6
	note $24 $07
	note $20 $07
	note $22 $07
	wait1 $03
	vol $3
	note $22 $04
	vol $6
	note $22 $07
	note $1f $07
	note $24 $07
	wait1 $03
	vol $3
	note $24 $04
	vol $6
	note $24 $07
	note $20 $07
	note $24 $07
	wait1 $03
	vol $3
	note $24 $04
	vol $6
	note $24 $07
	note $20 $07
	note $24 $07
	wait1 $03
	vol $3
	note $24 $04
	vol $6
	note $24 $07
	note $20 $07
	note $1f $0e
	note $1d $07
	note $1f $07
	note $20 $07
	wait1 $03
	vol $3
	note $20 $04
	vol $6
	note $1b $03
	vol $3
	note $1b $04
	vol $6
	note $1b $03
	vol $3
	note $1b $04
	vol $6
	note $20 $07
	wait1 $03
	vol $3
	note $20 $04
	vol $6
	note $1b $03
	vol $3
	note $1b $04
	vol $6
	note $1b $03
	vol $3
	note $1b $04
	vol $6
	note $24 $07
	wait1 $03
	vol $3
	note $24 $04
	vol $6
	note $1b $03
	vol $3
	note $1b $04
	vol $6
	note $1b $03
	vol $3
	note $1b $04
	vol $6
	note $22 $07
	note $20 $07
	note $22 $07
	note $20 $03
	wait1 $04
	note $20 $07
	wait1 $03
	vol $3
	note $20 $04
	vol $6
	note $1f $03
	vol $3
	note $1f $04
	vol $6
	note $1f $03
	vol $3
	note $1f $04
	vol $6
	note $1d $07
	wait1 $03
	vol $3
	note $1d $04
	vol $6
	note $1f $07
	note $1d $07
	note $22 $07
	wait1 $03
	vol $3
	note $22 $04
	vol $6
	note $24 $07
	note $22 $07
	note $1f $07
	wait1 $03
	vol $3
	note $1f $04
	vol $6
	note $1f $07
	note $22 $07
	note $20 $07
	wait1 $03
	vol $3
	note $20 $04
	vol $6
	note $24 $07
	note $25 $07
	note $26 $07
	wait1 $03
	vol $3
	note $26 $04
	vol $6
	note $27 $03
	wait1 $04
	note $27 $07
	note $26 $07
	wait1 $03
	vol $3
	note $26 $04
	vol $6
	note $27 $07
	note $26 $07
	note $25 $07
	wait1 $03
	vol $3
	note $25 $04
	vol $6
	note $25 $07
	note $24 $07
	note $23 $07
	wait1 $03
	vol $3
	note $23 $04
	vol $6
	note $23 $07
	note $1f $07
	note $1d $0e
	note $1f $03
	wait1 $04
	note $1f $07
	note $23 $0e
	note $1f $03
	wait1 $04
	note $1f $07
	note $26 $0e
	note $23 $03
	wait1 $04
	note $23 $07
	note $24 $07
	wait1 $03
	vol $3
	note $24 $04
	vol $6
	note $24 $03
	wait1 $04
	note $24 $07
	note $25 $09
	note $27 $09
	note $25 $0a
	note $24 $07
	wait1 $03
	vol $3
	note $24 $04
	vol $6
	note $24 $07
	note $1f $07
	note $1c $07
	note $1f $07
	note $24 $07
	note $28 $07
	wait1 $23
	vol $6
	note $1d $07
	note $22 $07
	note $20 $07
	note $1f $38
	note $20 $23
	note $1b $07
	note $20 $07
	note $22 $07
	note $24 $07
	note $20 $07
	note $24 $07
	note $27 $07
	note $2c $07
	note $27 $07
	note $24 $07
	note $20 $07
	note $1f $23
	vibrato $01
	env $0 $00
	vol $3
	note $1f $07
	vibrato $f1
	env $0 $00
	vol $6
	note $1d $04
	note $1f $05
	note $1d $05
	note $1c $0e
	note $1f $07
	note $24 $07
	note $25 $0e
	note $24 $0e
	wait1 $07
	note $18 $07
	note $1f $07
	note $1c $07
	note $1d $07
	note $1f $07
	note $20 $07
	note $22 $07
	note $23 $07
	note $24 $07
	note $25 $07
	note $26 $07
	note $2b $0e
	note $2c $0e
	note $2e $07
	wait1 $03
	vol $3
	note $2e $07
	wait1 $12
	vol $6
	note $22 $03
	wait1 $04
	note $22 $07
	note $20 $07
	note $1f $1c
	note $25 $1c
	wait1 $07
	note $20 $07
	note $25 $07
	note $23 $07
	note $24 $07
	note $25 $07
	note $23 $07
	note $24 $07
	note $25 $07
	note $26 $07
	note $24 $07
	note $25 $07
	note $26 $0e
	note $28 $0e
	note $29 $07
	wait1 $03
	vol $3
	note $29 $07
	wait1 $04
	vol $6
	note $1f $07
	note $29 $1c
	note $28 $1c
	note $27 $1c
	note $25 $07
	note $24 $07
	note $22 $07
	note $1f $07
	note $1d $07
	note $1c $07
	note $1f $07
	note $24 $07
	note $28 $07
	note $1f $07
	note $24 $07
	note $28 $07
	note $2b $07
	note $24 $07
	note $28 $07
	note $2b $07
	goto musicee08a
	cmdff
; $ee2da
; @addr{ee2da}
sound07Channel4:
musicee2da:
	duty $11
	note $11 $07
	duty $0f
	note $11 $07
	wait1 $0e
	duty $11
	note $11 $07
	duty $0f
	note $11 $07
	wait1 $2a
	duty $11
	note $0f $1c
	duty $11
	note $14 $07
	duty $0f
	note $14 $07
	wait1 $0e
	duty $11
	note $14 $07
	duty $0f
	note $14 $07
	wait1 $2a
	duty $11
	note $16 $1c
	duty $11
	note $14 $07
	duty $0f
	note $14 $07
	wait1 $0e
	duty $11
	note $14 $07
	duty $0f
	note $14 $07
	wait1 $2a
	duty $11
	note $0f $1c
	duty $11
	note $14 $07
	duty $0f
	note $14 $07
	wait1 $0e
	duty $11
	note $14 $07
	duty $0f
	note $14 $07
	wait1 $2a
	duty $11
	note $14 $1c
	duty $11
	note $13 $07
	duty $0f
	note $13 $07
	wait1 $0e
	duty $11
	note $13 $07
	duty $0f
	note $13 $07
	wait1 $2a
	duty $11
	note $0c $1c
	duty $11
	note $11 $07
	duty $0f
	note $11 $07
	wait1 $0e
	duty $11
	note $11 $07
	duty $0f
	note $11 $07
	wait1 $2a
	duty $11
	note $11 $1c
	duty $11
	note $13 $07
	duty $0f
	note $13 $07
	wait1 $0e
	duty $11
	note $13 $07
	duty $0f
	note $13 $07
	wait1 $2a
	duty $11
	note $13 $1c
	duty $11
	note $0c $07
	duty $0f
	note $0c $07
	wait1 $0e
	duty $11
	note $0c $07
	duty $0f
	note $0c $07
	wait1 $2a
	duty $11
	note $0c $1c
	duty $11
	note $16 $07
	duty $0f
	note $16 $05
	wait1 $02
	duty $11
	note $16 $07
	duty $0f
	note $16 $05
	wait1 $10
	duty $11
	note $16 $0e
	note $0f $07
	duty $0f
	note $0f $05
	wait1 $02
	duty $11
	note $0f $07
	duty $0f
	note $0f $05
	wait1 $10
	duty $11
	note $13 $0e
	duty $11
	note $14 $07
	duty $0f
	note $14 $05
	wait1 $02
	duty $11
	note $14 $07
	duty $0f
	note $14 $05
	wait1 $10
	duty $11
	note $0f $0e
	note $14 $07
	duty $0f
	note $14 $05
	wait1 $02
	duty $11
	note $14 $07
	duty $0f
	note $14 $05
	wait1 $10
	duty $11
	note $14 $0e
	duty $11
	note $13 $07
	duty $0f
	note $13 $05
	wait1 $02
	duty $11
	note $13 $07
	duty $0f
	note $13 $05
	wait1 $10
	duty $11
	note $13 $0e
	note $0c $07
	duty $0f
	note $0c $05
	wait1 $02
	duty $11
	note $0c $07
	duty $0f
	note $0c $05
	wait1 $10
	duty $11
	note $10 $0e
	duty $11
	note $11 $07
	duty $0f
	note $11 $05
	wait1 $02
	duty $11
	note $11 $0e
	duty $0f
	note $11 $05
	wait1 $09
	duty $11
	note $11 $07
	duty $0f
	note $11 $05
	wait1 $02
	duty $11
	note $11 $07
	duty $0f
	note $11 $05
	wait1 $02
	duty $11
	note $11 $0e
	note $13 $0e
	note $14 $0e
	duty $11
	note $16 $07
	duty $0f
	note $16 $05
	wait1 $02
	duty $11
	note $16 $07
	duty $0f
	note $16 $05
	wait1 $10
	duty $11
	note $16 $0e
	note $0f $07
	duty $0f
	note $0f $05
	wait1 $02
	duty $11
	note $0f $07
	duty $0f
	note $0f $05
	wait1 $10
	duty $11
	note $0f $0e
	duty $11
	note $11 $07
	duty $0f
	note $11 $05
	wait1 $02
	duty $11
	note $11 $0e
	duty $0f
	note $11 $05
	wait1 $09
	duty $11
	note $11 $0e
	note $0f $07
	duty $0f
	note $0f $05
	wait1 $02
	duty $11
	note $0f $0e
	duty $0f
	note $0f $05
	wait1 $09
	duty $11
	note $0f $0e
	duty $11
	note $0e $07
	duty $0f
	note $0e $05
	wait1 $02
	duty $11
	note $0e $07
	duty $0f
	note $0e $05
	wait1 $10
	duty $11
	note $0e $0e
	note $13 $07
	duty $0f
	note $13 $05
	wait1 $02
	duty $11
	note $13 $07
	duty $0f
	note $13 $05
	wait1 $10
	duty $11
	note $13 $0e
	duty $11
	note $0c $0e
	duty $0f
	note $0c $05
	wait1 $09
	duty $11
	note $0c $1c
	note $0e $1c
	note $10 $1c
	goto musicee2da
	cmdff
; $ee4f4
; @addr{ee4f4}
sound07Channel6:
musicee4f4:
	vol $5
	note $26 $0e
	vol $3
	note $26 $03
	vol $2
	note $26 $04
	vol $2
	note $26 $03
	vol $1
	note $26 $04
	vol $5
	note $26 $0e
	vol $3
	note $26 $03
	vol $2
	note $26 $04
	vol $2
	note $26 $03
	vol $2
	note $26 $04
	vol $5
	note $26 $0e
	vol $3
	note $26 $03
	vol $2
	note $26 $04
	vol $2
	note $26 $03
	vol $2
	note $26 $04
	vol $5
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
	vol $2
	note $26 $03
	vol $3
	note $26 $04
	goto musicee4f4
	cmdff
; $ee53d
; @addr{ee53d}
sound05Channel1:
	vol $0
	note $20 $ff
	vol $0
	note $20 $01
	vibrato $00
	env $0 $00
	duty $02
musicee549:
	vol $6
	note $37 $30
	vol $3
	note $37 $10
	vol $6
	note $36 $20
	note $37 $10
	note $36 $10
	note $34 $10
	wait1 $08
	vol $3
	note $34 $08
	vol $6
	note $2d $10
	wait1 $08
	vol $3
	note $2d $08
	vol $6
	note $2d $10
	wait1 $08
	vol $3
	note $2d $08
	vol $6
	note $2d $0c
	wait1 $04
	note $2d $08
	note $2f $08
	note $30 $38
	vol $3
	note $30 $08
	vol $6
	note $2f $20
	note $32 $20
	note $30 $20
	note $2f $10
	note $2d $10
	note $2f $10
	wait1 $08
	vol $3
	note $2f $08
	vol $6
	note $2b $10
	wait1 $08
	vol $3
	note $2b $08
	vol $6
	note $2d $30
	vol $3
	note $2d $20
	vol $1
	note $2d $10
	vol $6
	note $2d $10
	note $34 $08
	wait1 $04
	vol $3
	note $34 $04
	vol $6
	note $34 $30
	vol $3
	note $34 $20
	vol $1
	note $34 $10
	wait1 $10
	vol $6
	note $34 $08
	note $39 $08
	note $34 $20
	vol $3
	note $34 $10
	vol $6
	note $34 $08
	note $39 $08
	note $34 $20
	vol $3
	note $34 $10
	vol $6
	note $34 $08
	note $39 $08
	note $34 $40
	vol $3
	note $34 $20
	vol $1
	note $34 $20
	vol $6
	note $3c $08
	wait1 $04
	vol $3
	note $3c $08
	wait1 $04
	vol $1
	note $3c $08
	vol $6
	note $3b $08
	wait1 $04
	vol $3
	note $3b $08
	wait1 $04
	vol $1
	note $3b $08
	vol $6
	note $39 $08
	wait1 $04
	vol $3
	note $39 $08
	wait1 $04
	vol $1
	note $39 $08
	vol $6
	note $37 $08
	wait1 $04
	vol $3
	note $37 $08
	wait1 $04
	vol $1
	note $37 $08
	vol $6
	note $36 $48
	wait1 $08
	note $37 $10
	note $39 $10
	note $3b $10
	note $3c $08
	wait1 $04
	vol $3
	note $3c $08
	wait1 $04
	vol $1
	note $3c $08
	vol $6
	note $3b $08
	wait1 $04
	vol $3
	note $3b $08
	wait1 $04
	vol $1
	note $3b $08
	vol $6
	note $39 $08
	wait1 $04
	vol $3
	note $39 $08
	wait1 $04
	vol $1
	note $39 $08
	vol $6
	note $37 $08
	wait1 $04
	vol $3
	note $37 $08
	wait1 $04
	vol $1
	note $37 $08
	vol $6
	note $36 $40
	vol $3
	note $36 $10
	vol $6
	note $36 $10
	note $37 $10
	note $39 $10
	note $3b $30
	vol $3
	note $3b $10
	vol $6
	note $40 $30
	vol $3
	note $40 $10
	vol $6
	note $3e $18
	vol $3
	note $3e $08
	vol $6
	note $39 $18
	vol $3
	note $39 $08
	vol $6
	note $35 $18
	vol $3
	note $35 $08
	vol $6
	note $32 $18
	vol $3
	note $32 $08
	wait1 $30
	vol $6
	note $2f $05
	note $34 $05
	note $2d $06
	note $2f $2a
	wait1 $06
	note $2f $04
	note $34 $04
	note $36 $04
	note $39 $04
	note $3b $30
	note $39 $05
	note $3b $05
	note $39 $06
	note $35 $20
	note $34 $10
	note $32 $10
	goto musicee549
	cmdff
; $ee69d
; @addr{ee69d}
sound05Channel0:
	vibrato $00
	env $0 $00
	duty $02
	vol $6
	note $21 $08
	wait1 $08
	note $23 $08
	vol $3
	note $21 $08
	vol $6
	note $26 $08
	vol $3
	note $23 $08
	vol $6
	note $28 $08
	vol $3
	note $26 $08
	vol $6
	note $21 $08
	vol $3
	note $28 $08
	vol $6
	note $23 $08
	vol $3
	note $21 $08
	vol $6
	note $26 $08
	vol $3
	note $23 $08
	vol $6
	note $28 $08
	vol $3
	note $26 $08
	vol $6
	note $21 $08
	vol $3
	note $28 $08
	vol $6
	note $23 $08
	vol $3
	note $21 $08
	vol $6
	note $26 $08
	vol $3
	note $23 $08
	vol $6
	note $28 $08
	vol $3
	note $26 $08
	vol $6
	note $21 $08
	vol $3
	note $28 $08
	vol $6
	note $23 $08
	vol $3
	note $21 $08
	vol $6
	note $26 $08
	vol $3
	note $23 $08
	vol $6
	note $28 $08
	vol $3
	note $26 $08
musicee701:
	vol $6
	note $21 $08
	vol $3
	note $28 $08
	vol $6
	note $23 $08
	vol $3
	note $21 $08
	vol $6
	note $26 $08
	vol $3
	note $23 $08
	vol $6
	note $28 $08
	vol $3
	note $26 $08
	vol $6
	note $21 $08
	vol $3
	note $28 $08
	vol $6
	note $23 $08
	vol $3
	note $21 $08
	vol $6
	note $26 $08
	vol $3
	note $23 $08
	vol $6
	note $28 $08
	vol $3
	note $26 $08
	vol $6
	note $21 $08
	vol $3
	note $28 $08
	vol $6
	note $23 $08
	vol $3
	note $21 $08
	vol $6
	note $26 $08
	vol $3
	note $23 $08
	vol $6
	note $28 $08
	vol $3
	note $26 $08
	vol $6
	note $21 $08
	vol $3
	note $28 $08
	vol $6
	note $23 $08
	vol $3
	note $21 $08
	vol $6
	note $26 $08
	vol $3
	note $23 $08
	vol $6
	note $28 $08
	vol $3
	note $26 $08
	vol $6
	note $21 $08
	vol $3
	note $28 $08
	vol $6
	note $23 $08
	vol $3
	note $21 $08
	vol $6
	note $26 $08
	vol $3
	note $23 $08
	vol $6
	note $28 $08
	vol $3
	note $26 $08
	vol $6
	note $21 $08
	vol $3
	note $28 $08
	vol $6
	note $23 $08
	vol $3
	note $21 $08
	vol $6
	note $26 $08
	vol $3
	note $23 $08
	vol $6
	note $28 $08
	vol $3
	note $26 $08
	vol $6
	note $21 $08
	vol $3
	note $28 $08
	vol $6
	note $23 $08
	vol $3
	note $21 $08
	vol $6
	note $26 $08
	vol $3
	note $23 $08
	vol $6
	note $28 $08
	vol $3
	note $26 $08
	vol $6
	note $21 $08
	vol $3
	note $28 $08
	vol $6
	note $23 $08
	vol $3
	note $21 $08
	vol $6
	note $26 $08
	vol $3
	note $23 $08
	vol $6
	note $28 $08
	vol $3
	note $26 $08
	vol $6
	note $1d $08
	vol $3
	note $28 $08
	vol $6
	note $21 $08
	vol $3
	note $1d $08
	vol $6
	note $23 $08
	vol $3
	note $21 $08
	vol $6
	note $26 $08
	vol $3
	note $23 $08
	vol $6
	note $29 $08
	vol $3
	note $26 $08
	vol $6
	note $2d $08
	vol $3
	note $29 $08
	vol $6
	note $2f $08
	vol $3
	note $2d $08
	vol $6
	note $32 $08
	vol $3
	note $2f $08
	vol $6
	note $1d $08
	vol $3
	note $32 $08
	vol $6
	note $21 $08
	vol $3
	note $1d $08
	vol $6
	note $23 $08
	vol $3
	note $21 $08
	vol $6
	note $26 $08
	vol $3
	note $23 $08
	vol $6
	note $29 $08
	vol $3
	note $26 $08
	vol $6
	note $2d $08
	vol $3
	note $29 $08
	vol $6
	note $2f $08
	vol $3
	note $2d $08
	vol $6
	note $32 $08
	vol $3
	note $2f $08
	vol $6
	note $1c $08
	vol $3
	note $32 $08
	vol $6
	note $21 $08
	vol $3
	note $1c $08
	vol $6
	note $23 $08
	vol $3
	note $21 $08
	vol $6
	note $26 $08
	vol $3
	note $23 $08
	vol $6
	note $28 $08
	vol $3
	note $26 $08
	vol $6
	note $2d $08
	vol $3
	note $28 $08
	vol $6
	note $2f $08
	vol $3
	note $2d $08
	vol $6
	note $32 $08
	vol $3
	note $2f $08
	vol $6
	note $1c $08
	vol $3
	note $32 $08
	vol $6
	note $1f $08
	vol $3
	note $1c $08
	vol $6
	note $23 $08
	vol $3
	note $1f $08
	vol $6
	note $26 $08
	vol $3
	note $23 $08
	vol $6
	note $28 $08
	vol $3
	note $26 $08
	vol $6
	note $2d $08
	vol $3
	note $28 $08
	vol $6
	note $2f $08
	vol $3
	note $2d $08
	vol $6
	note $32 $08
	vol $3
	note $2f $08
	vol $6
	note $1b $04
	wait1 $04
	note $1e $04
	vol $3
	note $1b $04
	vol $6
	note $21 $04
	vol $3
	note $1e $04
	vol $6
	note $24 $04
	vol $3
	note $21 $04
	vol $6
	note $1b $04
	vol $3
	note $24 $04
	vol $6
	note $1e $04
	vol $3
	note $1b $04
	vol $6
	note $21 $04
	vol $3
	note $1e $04
	vol $6
	note $24 $04
	vol $3
	note $21 $04
	vol $6
	note $1b $04
	vol $3
	note $24 $04
	vol $6
	note $1e $04
	vol $3
	note $1b $04
	vol $6
	note $21 $04
	vol $3
	note $1e $04
	vol $6
	note $24 $04
	vol $3
	note $21 $04
	vol $6
	note $1b $04
	vol $3
	note $24 $04
	vol $6
	note $1e $04
	vol $3
	note $1b $04
	vol $6
	note $21 $04
	vol $3
	note $1e $04
	vol $6
	note $24 $04
	vol $3
	note $21 $04
	vol $6
	note $1b $04
	vol $3
	note $24 $04
	vol $6
	note $1e $04
	vol $3
	note $1b $04
	vol $6
	note $21 $04
	vol $3
	note $1e $04
	vol $6
	note $24 $04
	vol $3
	note $21 $04
	vol $6
	note $1e $04
	vol $3
	note $24 $04
	vol $6
	note $21 $04
	vol $3
	note $1e $04
	vol $6
	note $24 $04
	vol $3
	note $21 $04
	vol $6
	note $27 $04
	vol $3
	note $24 $04
	vol $6
	note $21 $04
	vol $3
	note $27 $04
	vol $6
	note $24 $04
	vol $3
	note $21 $04
	vol $6
	note $27 $04
	vol $3
	note $24 $04
	vol $6
	note $2a $04
	vol $3
	note $27 $04
	vol $6
	note $27 $04
	vol $3
	note $2a $04
	vol $6
	note $2a $04
	vol $3
	note $27 $04
	vol $6
	note $2d $04
	vol $3
	note $2a $04
	vol $6
	note $30 $04
	vol $3
	note $2d $04
	vol $6
	note $1b $04
	vol $3
	note $30 $04
	vol $6
	note $1e $04
	vol $3
	note $1b $04
	vol $6
	note $21 $04
	vol $3
	note $1e $04
	vol $6
	note $24 $04
	vol $3
	note $21 $04
	vol $6
	note $1b $04
	vol $3
	note $24 $04
	vol $6
	note $1e $04
	vol $3
	note $1b $04
	vol $6
	note $21 $04
	vol $3
	note $1e $04
	vol $6
	note $24 $04
	vol $3
	note $21 $04
	vol $6
	note $1b $04
	vol $3
	note $24 $04
	vol $6
	note $1e $04
	vol $3
	note $1b $04
	vol $6
	note $21 $04
	vol $3
	note $1e $04
	vol $6
	note $24 $04
	vol $3
	note $21 $04
	vol $6
	note $1b $04
	vol $3
	note $24 $04
	vol $6
	note $1e $04
	vol $3
	note $1b $04
	vol $6
	note $21 $04
	vol $3
	note $1e $04
	vol $6
	note $24 $04
	vol $3
	note $21 $04
	vol $6
	note $1b $04
	vol $3
	note $24 $04
	vol $6
	note $1e $04
	vol $3
	note $1b $04
	vol $6
	note $21 $04
	vol $3
	note $1e $04
	vol $6
	note $24 $04
	vol $3
	note $21 $04
	vol $6
	note $1e $04
	vol $3
	note $24 $04
	vol $6
	note $21 $04
	vol $3
	note $1e $04
	vol $6
	note $24 $04
	vol $3
	note $21 $04
	vol $6
	note $27 $04
	vol $3
	note $24 $04
	vol $6
	note $21 $04
	vol $3
	note $27 $04
	vol $6
	note $24 $04
	vol $3
	note $21 $04
	vol $6
	note $27 $04
	vol $3
	note $24 $04
	vol $6
	note $2a $04
	vol $3
	note $27 $04
	vol $6
	note $27 $04
	vol $3
	note $2a $04
	vol $6
	note $2a $04
	vol $3
	note $27 $04
	vol $6
	note $2d $04
	vol $3
	note $2a $04
	vol $6
	note $30 $04
	vol $3
	note $2d $04
	vol $6
	note $1f $08
	wait1 $08
	note $23 $08
	vol $3
	note $1f $08
	vol $6
	note $28 $08
	vol $3
	note $23 $08
	vol $6
	note $2b $08
	vol $3
	note $28 $08
	vol $6
	note $1f $08
	vol $3
	note $2b $08
	vol $6
	note $23 $08
	vol $3
	note $1f $08
	vol $6
	note $28 $08
	vol $3
	note $23 $08
	vol $6
	note $2b $08
	vol $3
	note $28 $08
	vol $6
	note $1d $08
	vol $3
	note $2b $08
	vol $6
	note $21 $08
	vol $3
	note $1d $08
	vol $6
	note $24 $08
	vol $3
	note $21 $08
	vol $6
	note $29 $08
	vol $3
	note $24 $08
	vol $6
	note $1d $08
	vol $3
	note $29 $08
	vol $6
	note $21 $08
	vol $3
	note $1d $08
	vol $6
	note $24 $08
	vol $3
	note $21 $08
	vol $6
	note $29 $08
	vol $3
	note $24 $08
	vol $6
	note $18 $08
	vol $3
	note $29 $08
	vol $6
	note $1c $08
	vol $3
	note $18 $08
	vol $6
	note $1f $08
	vol $3
	note $1c $08
	vol $6
	note $23 $08
	vol $3
	note $1f $08
	vol $6
	note $18 $08
	vol $3
	note $23 $08
	vol $6
	note $1c $08
	vol $3
	note $18 $08
	vol $6
	note $1f $08
	vol $3
	note $1c $08
	vol $6
	note $23 $08
	vol $3
	note $1f $08
	vol $6
	note $17 $08
	vol $3
	note $23 $08
	vol $6
	note $1a $08
	vol $3
	note $17 $08
	vol $6
	note $1e $08
	vol $3
	note $1a $08
	vol $6
	note $21 $08
	vol $3
	note $1e $08
	vol $6
	note $16 $08
	vol $3
	note $21 $08
	vol $6
	note $1a $08
	vol $3
	note $16 $08
	vol $6
	note $1c $08
	vol $3
	note $1a $08
	vol $6
	note $1f $08
	vol $3
	note $1c $08
	goto musicee701
	cmdff
; $eeac1
; @addr{eeac1}
sound05Channel4:
	duty $08
	wait1 $ff
	wait1 $25
musiceeac7:
	note $37 $30
	wait1 $10
	note $36 $20
	note $37 $10
	note $36 $10
	note $34 $10
	wait1 $10
	note $2d $10
	wait1 $10
	note $2d $10
	wait1 $10
	note $2d $0c
	wait1 $04
	note $2d $08
	note $2f $08
	note $30 $38
	wait1 $08
	note $2f $20
	note $32 $20
	note $30 $20
	note $2f $10
	note $2d $10
	note $2f $10
	wait1 $10
	note $2b $10
	wait1 $10
	note $2d $60
	wait1 $10
	note $34 $08
	wait1 $08
	note $34 $60
	wait1 $10
	note $34 $08
	note $39 $08
	note $34 $30
	note $34 $08
	note $39 $08
	note $34 $30
	note $34 $08
	note $39 $08
	note $34 $30
	wait1 $ff
	wait1 $ff
	duty $08
	wait1 $32
	note $37 $10
	note $39 $10
	note $3b $30
	wait1 $10
	note $40 $30
	note $40 $10
	note $3e $18
	wait1 $08
	note $39 $18
	wait1 $08
	note $35 $18
	wait1 $08
	note $32 $18
	wait1 $38
	note $2f $05
	note $34 $05
	note $2d $06
	note $2f $2a
	wait1 $06
	note $2f $04
	note $34 $04
	note $36 $04
	note $39 $04
	note $3b $30
	note $39 $05
	note $3b $05
	note $39 $06
	note $35 $20
	note $34 $10
	note $32 $10
	goto musiceeac7
	cmdff
; $eeb61
; @addr{eeb61}
sound08Channel1:
	vibrato $00
	env $0 $03
	duty $02
musiceeb67:
	vol $6
	note $2b $0e
	vibrato $00
	env $0 $04
	note $28 $1c
	vibrato $00
	env $0 $03
	note $2b $0e
	note $27 $0e
	vibrato $00
	env $0 $04
	note $2f $1c
	vibrato $00
	env $0 $03
	note $2d $0e
	note $2b $0e
	vibrato $00
	env $0 $04
	note $28 $1c
	vibrato $00
	env $0 $03
	note $24 $0e
	note $23 $0e
	note $27 $07
	note $2a $07
	note $2f $0e
	note $2d $0e
	vibrato $00
	env $0 $04
	note $2b $1c
	vibrato $00
	env $0 $03
	note $2d $0e
	note $2f $0e
	note $30 $0e
	note $32 $0e
	note $34 $0e
	note $35 $0e
	vibrato $00
	env $0 $04
	note $37 $1c
	vibrato $00
	env $0 $03
	note $35 $0e
	note $31 $0e
	vibrato $00
	env $0 $04
	note $34 $1c
	note $32 $1c
	vibrato $00
	env $0 $03
	note $39 $0e
	vibrato $00
	env $0 $04
	note $35 $1c
	vibrato $00
	env $0 $03
	note $34 $0e
	note $33 $0e
	note $3b $07
	note $3c $07
	note $3b $0e
	note $39 $0e
	note $37 $0e
	vibrato $00
	env $0 $04
	note $34 $1c
	vibrato $00
	env $0 $03
	note $37 $0e
	note $31 $0e
	note $39 $07
	note $3a $07
	note $39 $0e
	note $37 $0e
	note $37 $0e
	note $35 $0e
	note $34 $0e
	note $35 $0e
	note $37 $0e
	note $35 $0e
	note $39 $0e
	note $3c $0e
	note $40 $0e
	note $3e $0e
	note $3c $0e
	note $40 $0e
	vibrato $00
	env $0 $04
	note $3e $1c
	wait1 $1c
	vibrato $00
	env $0 $03
	goto musiceeb67
	cmdff
; $eec24
; @addr{eec24}
sound08Channel0:
	vibrato $00
	env $0 $03
	duty $02
musiceec2a:
	vol $6
	note $18 $0e
	note $1c $0e
	note $13 $0e
	note $1c $0e
	note $17 $0e
	note $1b $0e
	note $12 $0e
	note $1b $0e
	note $18 $0e
	note $1c $0e
	note $13 $0e
	note $1c $0e
	note $17 $0e
	note $1b $0e
	note $12 $0e
	note $1b $0e
	note $18 $0e
	note $1c $0e
	note $13 $0e
	note $1c $0e
	note $15 $0e
	note $1c $0e
	note $18 $0e
	note $1c $0e
	note $1a $0e
	note $1d $0e
	note $15 $0e
	note $1d $0e
	note $13 $0e
	note $15 $0e
	note $17 $0e
	note $13 $0e
	note $1d $0e
	note $21 $0e
	note $18 $0e
	note $21 $0e
	note $17 $0e
	note $1e $0e
	note $1b $0e
	note $1e $0e
	note $1c $0e
	note $1f $0e
	note $17 $0e
	note $1f $0e
	note $15 $0e
	note $1c $0e
	note $19 $0e
	note $1c $0e
	note $1a $0e
	note $1d $0e
	note $15 $0e
	note $1d $0e
	note $1a $0e
	note $1d $0e
	note $15 $0e
	note $14 $0e
	note $13 $0e
	note $1a $0e
	note $0e $0e
	note $1a $0e
	note $13 $0e
	note $13 $0e
	note $15 $0e
	note $17 $0e
	goto musiceec2a
	cmdff
; $eecaf
; @addr{eecaf}
sound08Channel4:
	duty $0c
musiceecb1:
	vol $3
	note $2b $0e
	note $28 $1c
	note $2b $0e
	note $27 $0e
	note $2f $1c
	note $2d $0e
	note $2b $0e
	note $28 $1c
	note $24 $0e
	note $23 $0e
	note $27 $07
	note $2a $07
	note $2f $0e
	note $2d $0e
	note $2b $1c
	note $2d $0e
	note $2f $0e
	note $30 $0e
	note $32 $0e
	note $34 $0e
	note $35 $0e
	note $37 $1c
	note $35 $0e
	note $31 $0e
	note $34 $1c
	note $32 $1c
	note $39 $0e
	note $35 $1c
	note $34 $0e
	note $33 $0e
	note $3b $07
	note $3c $07
	note $3b $0e
	note $39 $0e
	note $37 $0e
	note $34 $1c
	note $37 $0e
	note $31 $0e
	note $39 $07
	note $3a $07
	note $39 $0e
	note $37 $0e
	note $37 $0e
	note $35 $0e
	note $34 $0e
	note $35 $0e
	note $37 $0e
	note $35 $0e
	note $39 $0e
	note $3c $0e
	note $40 $0e
	note $3e $0e
	note $3c $0e
	note $40 $0e
	note $3e $1c
	wait1 $1c
	goto musiceecb1
	cmdff
; $eed26
; GAP
	note $00 $6a
	.db $6e ; ???
	note $01 $33
	.db $6d ; ???
	note $04 $cd
	.db $6f ; ???
	note $06 $02
	.db $77 ; ???
	cmdff
sound34Start:
; @addr{eed33}
sound34Channel1:
	vibrato $00
	env $0 $00
	cmdf2
	duty $01
musiceed3a:
	vol $6
	note $24 $06
	wait1 $03
	vol $3
	note $24 $06
	wait1 $03
	vol $6
	note $2b $06
	note $2a $48
	note $29 $48
	note $27 $0c
	note $29 $06
	note $27 $06
	note $24 $06
	wait1 $03
	vol $3
	note $24 $06
	wait1 $03
	vol $1
	note $24 $06
	vol $6
	note $1e $30
	vol $3
	note $1e $30
	wait1 $30
	vol $6
	note $1e $06
	note $1f $06
	note $24 $06
	note $27 $06
	note $2b $06
	wait1 $03
	vol $3
	note $2b $06
	wait1 $03
	vol $6
	note $30 $06
	note $2f $30
	note $2b $06
	wait1 $03
	vol $3
	note $2b $06
	wait1 $03
	vol $6
	note $2f $06
	note $2e $18
	note $2b $06
	wait1 $03
	vol $3
	note $2b $06
	wait1 $03
	vol $6
	note $2e $06
	note $2d $18
	note $29 $06
	wait1 $03
	vol $3
	note $29 $06
	wait1 $03
	vol $6
	note $2c $06
	note $2b $0c
	note $27 $06
	note $24 $06
	note $1f $06
	wait1 $03
	vol $3
	note $1f $06
	wait1 $03
	vol $1
	note $1f $06
	wait1 $30
	vol $6
	note $2b $0c
	note $27 $06
	note $24 $06
	note $1f $06
	wait1 $03
	vol $3
	note $1f $06
	wait1 $03
	vol $1
	note $1f $06
	wait1 $18
	vol $6
	note $26 $06
	note $27 $06
	note $2b $06
	note $2f $06
	note $32 $06
	wait1 $03
	vol $3
	note $32 $06
	wait1 $03
	vol $6
	note $35 $06
	note $33 $30
	note $2f $06
	wait1 $03
	vol $3
	note $2f $06
	wait1 $03
	vol $7
	note $32 $06
	note $30 $18
	note $2b $06
	wait1 $03
	vol $3
	note $2b $06
	wait1 $03
	vol $7
	note $2e $06
	note $2d $18
	note $29 $06
	wait1 $03
	vol $3
	note $29 $06
	wait1 $03
	vol $7
	note $2c $06
	note $2b $06
	wait1 $03
	vol $3
	note $2b $06
	wait1 $03
	vol $1
	note $2b $06
	vol $7
	note $24 $48
	vol $3
	note $24 $18
	wait1 $48
	vol $6
	note $29 $06
	wait1 $03
	vol $3
	note $29 $06
	wait1 $03
	vol $6
	note $2c $06
	note $31 $18
	note $30 $18
	note $2f $06
	wait1 $03
	vol $3
	note $2f $06
	wait1 $03
	vol $6
	note $32 $06
	note $37 $24
	vol $3
	note $37 $0c
	vol $6
	note $38 $06
	wait1 $03
	vol $3
	note $38 $06
	wait1 $03
	vol $6
	note $35 $06
	note $3d $0c
	note $3c $0c
	note $3b $0c
	note $3a $0c
	note $39 $06
	wait1 $03
	vol $3
	note $39 $06
	wait1 $03
	vol $1
	note $39 $06
	vol $6
	note $2f $48
	goto musiceed3a
	cmdff
; $eee6a
; @addr{eee6a}
sound34Channel0:
	vibrato $00
	env $0 $00
	cmdf2
	duty $02
musiceee71:
	vol $6
	note $1f $06
	wait1 $03
	vol $3
	note $1f $06
	wait1 $03
	vol $6
	note $27 $06
	note $26 $48
	note $25 $48
	note $24 $0c
	note $25 $06
	note $24 $06
	note $1f $06
	wait1 $03
	vol $3
	note $1f $06
	wait1 $03
	vol $1
	note $1f $06
	wait1 $18
	vol $6
	note $30 $06
	wait1 $03
	vol $3
	note $30 $06
	wait1 $03
	vol $1
	note $30 $06
	vol $6
	note $2a $06
	wait1 $03
	vol $3
	note $2a $06
	wait1 $03
	vol $1
	note $2a $06
	vol $6
	note $3c $06
	wait1 $03
	vol $3
	note $3c $06
	wait1 $03
	vol $1
	note $3c $06
	vol $6
	note $36 $06
	wait1 $03
	vol $3
	note $36 $06
	wait1 $03
	vol $1
	note $36 $06
	vol $6
	note $3f $06
	wait1 $03
	vol $3
	note $3f $06
	wait1 $03
	vol $1
	note $3f $06
	vol $6
	note $3c $06
	wait1 $03
	vol $3
	note $3c $03
	vol $4
	note $1e $06
	note $1f $06
	note $24 $06
	note $27 $06
	note $2b $08
	wait1 $04
	vol $6
	note $27 $48
	note $26 $30
	note $25 $30
	vol $6
	note $27 $0c
	note $24 $06
	note $1f $06
	note $1b $06
	wait1 $03
	vol $3
	note $1b $06
	wait1 $03
	vol $1
	note $1b $06
	wait1 $40
	vol $3
	note $2b $0c
	note $27 $06
	note $24 $06
	note $1f $06
	wait1 $02
	vol $6
	note $43 $0c
	note $3f $06
	note $3c $06
	note $37 $06
	note $24 $06
	note $27 $06
	note $2b $06
	note $2f $06
	wait1 $03
	vol $3
	note $2f $06
	wait1 $03
	vol $1
	note $2f $06
	vol $6
	note $30 $30
	note $29 $18
	note $27 $30
	note $26 $18
	note $25 $18
	note $24 $06
	wait1 $03
	vol $3
	note $24 $06
	wait1 $03
	vol $1
	note $24 $06
	vol $6
	note $1f $48
	note $37 $06
	wait1 $03
	vol $3
	note $37 $06
	wait1 $03
	vol $1
	note $37 $06
	vol $6
	note $30 $06
	wait1 $03
	vol $3
	note $30 $06
	wait1 $03
	vol $1
	note $30 $06
	vol $6
	note $43 $06
	wait1 $03
	vol $3
	note $43 $06
	wait1 $03
	vol $1
	note $43 $06
	vol $6
	note $3c $06
	wait1 $03
	vol $3
	note $3c $06
	wait1 $03
	vol $1
	note $3c $06
	vol $3
	note $25 $06
	wait1 $03
	vol $1
	note $25 $06
	wait1 $03
	vol $6
	note $29 $06
	note $2c $12
	vol $3
	note $2c $06
	vol $6
	note $29 $12
	vol $3
	note $29 $06
	vol $6
	note $26 $06
	wait1 $03
	vol $3
	note $26 $06
	wait1 $03
	vol $6
	note $2b $06
	note $2f $18
	vol $3
	note $2f $18
	vol $6
	note $35 $06
	wait1 $03
	vol $3
	note $35 $06
	wait1 $03
	vol $6
	note $31 $06
	note $3a $0c
	note $39 $0c
	note $38 $0c
	note $37 $0c
	note $35 $06
	wait1 $03
	vol $3
	note $35 $06
	wait1 $03
	vol $1
	note $35 $06
	vol $6
	note $2c $48
	goto musiceee71
	cmdff
; $eefcd
; @addr{eefcd}
sound34Channel4:
	cmdf2
musiceefce:
	duty $12
	note $18 $04
	duty $17
	note $18 $02
	duty $12
	note $1b $04
	duty $17
	note $18 $02
	duty $12
	note $1f $04
	duty $17
	note $1b $02
	duty $12
	note $1e $04
	duty $17
	note $1f $02
	duty $12
	note $18 $04
	duty $17
	note $1e $02
	duty $12
	note $1b $04
	duty $17
	note $18 $02
	duty $12
	note $1f $04
	duty $17
	note $1b $02
	duty $12
	note $1e $04
	duty $17
	note $1f $02
	duty $12
	note $18 $04
	duty $17
	note $1e $02
	duty $12
	note $1b $04
	duty $17
	note $18 $02
	duty $12
	note $1f $04
	duty $17
	note $1b $02
	duty $12
	note $1e $04
	duty $17
	note $1f $02
	duty $12
	note $18 $04
	duty $17
	note $1e $02
	duty $12
	note $1b $04
	duty $17
	note $18 $02
	duty $12
	note $1f $04
	duty $17
	note $1b $02
	duty $12
	note $1e $04
	duty $17
	note $1f $02
	duty $12
	note $18 $04
	duty $17
	note $18 $02
	duty $12
	note $1b $04
	duty $17
	note $18 $02
	duty $12
	note $1f $04
	duty $17
	note $1b $02
	duty $12
	note $1e $04
	duty $17
	note $1f $02
	duty $12
	note $18 $04
	duty $17
	note $1e $02
	duty $12
	note $1b $04
	duty $17
	note $18 $02
	duty $12
	note $1f $04
	duty $17
	note $1b $02
	duty $12
	note $1e $04
	duty $17
	note $1f $02
	duty $12
	note $18 $04
	duty $17
	note $1e $02
	duty $12
	note $1b $04
	duty $17
	note $18 $02
	duty $12
	note $1f $04
	duty $17
	note $1b $02
	duty $12
	note $1e $04
	duty $17
	note $1f $02
	duty $12
	note $18 $04
	duty $17
	note $1e $02
	duty $12
	note $1b $04
	duty $17
	note $18 $02
	duty $12
	note $1f $04
	duty $17
	note $1b $02
	duty $12
	note $1e $04
	duty $17
	note $1f $02
	duty $12
	note $18 $04
	duty $17
	note $18 $02
	duty $12
	note $1b $04
	duty $17
	note $18 $02
	duty $12
	note $1f $04
	duty $17
	note $1b $02
	duty $12
	note $1e $04
	duty $17
	note $1f $02
	duty $12
	note $18 $04
	duty $17
	note $1e $02
	duty $12
	note $1b $04
	duty $17
	note $18 $02
	duty $12
	note $1f $04
	duty $17
	note $1b $02
	duty $12
	note $1e $04
	duty $17
	note $1f $02
	duty $12
	note $18 $04
	duty $17
	note $1e $02
	duty $12
	note $1b $04
	duty $17
	note $18 $02
	duty $12
	note $1f $04
	duty $17
	note $1b $02
	duty $12
	note $1e $04
	duty $17
	note $1f $02
	duty $12
	note $18 $04
	duty $17
	note $1e $02
	duty $12
	note $1b $04
	duty $17
	note $18 $02
	duty $12
	note $1f $04
	duty $17
	note $1b $02
	duty $12
	note $1e $04
	duty $17
	note $1f $02
	duty $12
	note $18 $04
	duty $17
	note $18 $02
	duty $12
	note $1b $04
	duty $17
	note $18 $02
	duty $12
	note $1f $04
	duty $17
	note $1b $02
	duty $12
	note $1e $04
	duty $17
	note $1f $02
	duty $12
	note $18 $04
	duty $17
	note $1e $02
	duty $12
	note $1b $04
	duty $17
	note $18 $02
	duty $12
	note $1f $04
	duty $17
	note $1b $02
	duty $12
	note $1e $04
	duty $17
	note $1f $02
	duty $12
	note $18 $04
	duty $17
	note $1e $02
	duty $12
	note $1b $04
	duty $17
	note $18 $02
	duty $12
	note $1f $04
	duty $17
	note $1b $02
	duty $12
	note $1e $04
	duty $17
	note $1f $02
	duty $12
	note $18 $04
	duty $17
	note $1e $02
	duty $12
	note $1b $04
	duty $17
	note $18 $02
	duty $12
	note $1f $04
	duty $17
	note $1b $02
	duty $12
	note $1e $04
	duty $17
	note $1f $02
	duty $12
	note $18 $04
	duty $17
	note $18 $02
	duty $12
	note $1b $04
	duty $17
	note $18 $02
	duty $12
	note $1f $04
	duty $17
	note $1b $02
	duty $12
	note $1e $04
	duty $17
	note $1f $02
	duty $12
	note $18 $04
	duty $17
	note $1e $02
	duty $12
	note $1b $04
	duty $17
	note $18 $02
	duty $12
	note $1f $04
	duty $17
	note $1b $02
	duty $12
	note $1e $04
	duty $17
	note $1f $02
	duty $12
	note $18 $04
	duty $17
	note $1e $02
	duty $12
	note $1b $04
	duty $17
	note $18 $02
	duty $12
	note $1f $04
	duty $17
	note $1b $02
	duty $12
	note $1e $04
	duty $17
	note $1f $02
	duty $12
	note $18 $04
	duty $17
	note $1e $02
	duty $12
	note $1b $04
	duty $17
	note $18 $02
	duty $12
	note $1f $04
	duty $17
	note $1b $02
	duty $12
	note $1e $04
	duty $17
	note $1f $02
	duty $12
	note $18 $04
	duty $17
	note $18 $02
	duty $12
	note $1b $04
	duty $17
	note $18 $02
	duty $12
	note $1f $04
	duty $17
	note $1b $02
	duty $12
	note $1e $04
	duty $17
	note $1f $02
	duty $12
	note $18 $04
	duty $17
	note $1e $02
	duty $12
	note $1b $04
	duty $17
	note $18 $02
	duty $12
	note $1f $04
	duty $17
	note $1b $02
	duty $12
	note $1e $04
	duty $17
	note $1f $02
	duty $12
	note $18 $04
	duty $17
	note $1e $02
	duty $12
	note $1b $04
	duty $17
	note $18 $02
	duty $12
	note $1f $04
	duty $17
	note $1b $02
	duty $12
	note $1e $04
	duty $17
	note $1f $02
	duty $12
	note $18 $04
	duty $17
	note $1e $02
	duty $12
	note $1b $04
	duty $17
	note $18 $02
	duty $12
	note $1f $04
	duty $17
	note $1b $02
	duty $12
	note $1e $04
	duty $17
	note $1f $02
	duty $12
	note $18 $04
	duty $17
	note $18 $02
	duty $12
	note $1b $04
	duty $17
	note $18 $02
	duty $12
	note $1f $04
	duty $17
	note $1b $02
	duty $12
	note $1e $04
	duty $17
	note $1f $02
	duty $12
	note $18 $04
	duty $17
	note $1e $02
	duty $12
	note $1b $04
	duty $17
	note $18 $02
	duty $12
	note $1f $04
	duty $17
	note $1b $02
	duty $12
	note $1e $04
	duty $17
	note $1f $02
	duty $12
	note $18 $04
	duty $17
	note $1e $02
	duty $12
	note $1b $04
	duty $17
	note $18 $02
	duty $12
	note $1f $04
	duty $17
	note $1b $02
	duty $12
	note $1e $04
	duty $17
	note $1f $02
	duty $12
	note $18 $04
	duty $17
	note $1e $02
	duty $12
	note $1b $04
	duty $17
	note $18 $02
	duty $12
	note $1f $04
	duty $17
	note $1b $02
	duty $12
	note $1e $04
	duty $17
	note $1f $02
	duty $12
	note $18 $04
	duty $17
	note $18 $02
	duty $12
	note $1b $04
	duty $17
	note $18 $02
	duty $12
	note $1f $04
	duty $17
	note $1b $02
	duty $12
	note $1e $04
	duty $17
	note $1f $02
	duty $12
	note $18 $04
	duty $17
	note $1e $02
	duty $12
	note $1b $04
	duty $17
	note $18 $02
	duty $12
	note $1f $04
	duty $17
	note $1b $02
	duty $12
	note $1e $04
	duty $17
	note $1f $02
	duty $12
	note $18 $04
	duty $17
	note $1e $02
	duty $12
	note $1b $04
	duty $17
	note $18 $02
	duty $12
	note $1f $04
	duty $17
	note $1b $02
	duty $12
	note $1e $04
	duty $17
	note $1f $02
	duty $12
	note $18 $04
	duty $17
	note $1e $02
	duty $12
	note $1b $04
	duty $17
	note $18 $02
	duty $12
	note $1f $04
	duty $17
	note $1b $02
	duty $12
	note $1e $04
	duty $17
	note $1f $02
	duty $12
	note $18 $04
	duty $17
	note $18 $02
	duty $12
	note $1b $04
	duty $17
	note $18 $02
	duty $12
	note $1f $04
	duty $17
	note $1b $02
	duty $12
	note $1e $04
	duty $17
	note $1f $02
	duty $12
	note $18 $04
	duty $17
	note $1e $02
	duty $12
	note $1b $04
	duty $17
	note $18 $02
	duty $12
	note $1f $04
	duty $17
	note $1b $02
	duty $12
	note $1e $04
	duty $17
	note $1f $02
	duty $12
	note $18 $04
	duty $17
	note $1e $02
	duty $12
	note $1b $04
	duty $17
	note $18 $02
	duty $12
	note $1f $04
	duty $17
	note $1b $02
	duty $12
	note $1e $04
	duty $17
	note $1f $02
	duty $12
	note $18 $04
	duty $17
	note $1e $02
	duty $12
	note $1b $04
	duty $17
	note $18 $02
	duty $12
	note $1f $04
	duty $17
	note $1b $02
	duty $12
	note $1e $04
	duty $17
	note $1f $02
	duty $12
	note $18 $04
	duty $17
	note $18 $02
	duty $12
	note $1b $04
	duty $17
	note $18 $02
	duty $12
	note $1f $04
	duty $17
	note $1b $02
	duty $12
	note $1e $04
	duty $17
	note $1f $02
	duty $12
	note $18 $04
	duty $17
	note $1e $02
	duty $12
	note $1b $04
	duty $17
	note $18 $02
	duty $12
	note $1f $04
	duty $17
	note $1b $02
	duty $12
	note $1e $04
	duty $17
	note $1f $02
	duty $12
	note $18 $04
	duty $17
	note $1e $02
	duty $12
	note $1b $04
	duty $17
	note $18 $02
	duty $12
	note $1f $04
	duty $17
	note $1b $02
	duty $12
	note $1e $04
	duty $17
	note $1f $02
	duty $12
	note $18 $04
	duty $17
	note $1e $02
	duty $12
	note $1b $04
	duty $17
	note $18 $02
	duty $12
	note $1f $04
	duty $17
	note $1b $02
	duty $12
	note $1e $04
	duty $17
	note $1f $02
	duty $12
	note $18 $04
	duty $17
	note $18 $02
	duty $12
	note $1b $04
	duty $17
	note $18 $02
	duty $12
	note $1f $04
	duty $17
	note $1b $02
	duty $12
	note $1e $04
	duty $17
	note $1f $02
	duty $12
	note $18 $04
	duty $17
	note $1e $02
	duty $12
	note $1b $04
	duty $17
	note $18 $02
	duty $12
	note $1f $04
	duty $17
	note $1b $02
	duty $12
	note $1e $04
	duty $17
	note $1f $02
	duty $12
	note $18 $04
	duty $17
	note $1e $02
	duty $12
	note $1b $04
	duty $17
	note $18 $02
	duty $12
	note $1f $04
	duty $17
	note $1b $02
	duty $12
	note $1e $04
	duty $17
	note $1f $02
	duty $12
	note $18 $04
	duty $17
	note $1e $02
	duty $12
	note $1b $04
	duty $17
	note $18 $02
	duty $12
	note $1f $04
	duty $17
	note $1b $02
	duty $12
	note $1e $04
	duty $17
	note $1f $02
	duty $12
	note $18 $04
	duty $17
	note $18 $02
	duty $12
	note $1b $04
	duty $17
	note $18 $02
	duty $12
	note $1f $04
	duty $17
	note $1b $02
	duty $12
	note $1e $04
	duty $17
	note $1f $02
	duty $12
	note $18 $04
	duty $17
	note $1e $02
	duty $12
	note $1b $04
	duty $17
	note $18 $02
	duty $12
	note $1f $04
	duty $17
	note $1b $02
	duty $12
	note $1e $04
	duty $17
	note $1f $02
	duty $12
	note $18 $04
	duty $17
	note $1e $02
	duty $12
	note $1b $04
	duty $17
	note $18 $02
	duty $12
	note $1f $04
	duty $17
	note $1b $02
	duty $12
	note $1e $04
	duty $17
	note $1f $02
	duty $12
	note $18 $04
	duty $17
	note $1e $02
	duty $12
	note $1b $04
	duty $17
	note $18 $02
	duty $12
	note $1f $04
	duty $17
	note $1b $02
	duty $12
	note $1e $04
	duty $17
	note $1f $02
	duty $12
	note $19 $04
	duty $17
	note $1e $02
	duty $12
	note $1d $04
	duty $17
	note $19 $02
	duty $12
	note $1f $04
	duty $17
	note $1d $02
	duty $12
	note $20 $04
	duty $17
	note $1f $02
	duty $12
	note $19 $04
	duty $17
	note $20 $02
	duty $12
	note $1d $04
	duty $17
	note $19 $02
	duty $12
	note $1f $04
	duty $17
	note $1d $02
	duty $12
	note $20 $04
	duty $17
	note $1f $02
	duty $12
	note $19 $04
	duty $17
	note $20 $02
	duty $12
	note $1d $04
	duty $17
	note $19 $02
	duty $12
	note $1f $04
	duty $17
	note $1d $02
	duty $12
	note $20 $04
	duty $17
	note $1f $02
	duty $12
	note $13 $04
	duty $17
	note $20 $02
	duty $12
	note $17 $04
	duty $17
	note $13 $02
	duty $12
	note $18 $04
	duty $17
	note $17 $02
	duty $12
	note $1a $04
	duty $17
	note $18 $02
	duty $12
	note $1b $04
	duty $17
	note $17 $02
	duty $12
	note $1c $04
	duty $17
	note $1b $02
	duty $12
	note $1d $04
	duty $17
	note $1c $02
	duty $12
	note $1e $04
	duty $17
	note $1d $02
	duty $12
	note $1f $04
	duty $17
	note $1e $02
	duty $12
	note $20 $04
	duty $17
	note $1f $02
	duty $12
	note $21 $04
	duty $17
	note $20 $02
	duty $12
	note $22 $04
	duty $17
	note $21 $02
	duty $12
	note $19 $04
	duty $17
	note $22 $02
	duty $12
	note $1d $04
	duty $17
	note $19 $02
	duty $12
	note $1f $04
	duty $17
	note $1d $02
	duty $12
	note $20 $04
	duty $17
	note $1f $02
	duty $12
	note $19 $04
	duty $17
	note $20 $02
	duty $12
	note $1d $04
	duty $17
	note $19 $02
	duty $12
	note $1f $04
	duty $17
	note $1d $02
	duty $12
	note $20 $04
	duty $17
	note $1f $02
	duty $12
	note $19 $04
	duty $17
	note $1d $02
	duty $12
	note $1d $04
	duty $17
	note $19 $02
	duty $12
	note $1f $04
	duty $17
	note $1d $02
	duty $12
	note $20 $04
	duty $17
	note $1f $02
	duty $12
	note $22 $04
	duty $17
	note $20 $02
	duty $17
	note $22 $12
	duty $12
	note $13 $48
	goto musiceefce
	cmdff
; $ef702
; @addr{ef702}
sound34Channel6:
	cmdf2
musicef703:
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
	goto musicef703
	cmdff
; $efa38
; @addr{efa38}
sound35Channel1:
	vibrato $00
	env $0 $00
	duty $02
musicefa3e:
	vol $6
	note $40 $08
	note $3e $08
	note $3a $08
	note $39 $08
	env $0 $03
	note $35 $10
	env $0 $00
	vol $6
	note $34 $08
	vol $3
	note $35 $08
	vol $6
	note $35 $08
	vol $3
	note $34 $08
	vol $6
	note $39 $08
	vol $3
	note $35 $08
	vol $6
	note $3a $08
	vol $3
	note $39 $08
	vol $6
	note $3a $08
	note $3e $08
	note $40 $08
	note $3e $08
	note $3a $08
	note $39 $08
	env $0 $03
	note $35 $10
	env $0 $00
	vol $6
	note $34 $08
	vol $3
	note $35 $08
	vol $6
	note $35 $08
	vol $3
	note $34 $08
	vol $6
	note $39 $08
	vol $3
	note $35 $08
	vol $6
	note $3a $08
	vol $3
	note $39 $08
	vol $6
	note $3a $08
	note $3e $08
	note $40 $08
	note $3a $08
	note $39 $08
	note $35 $08
	env $0 $03
	note $34 $10
	env $0 $00
	vol $6
	note $32 $08
	vol $3
	note $34 $08
	vol $6
	note $34 $08
	vol $3
	note $32 $08
	vol $6
	note $39 $08
	vol $3
	note $34 $08
	vol $6
	note $3a $08
	vol $3
	note $39 $08
	vol $6
	note $3a $08
	note $3e $08
	vol $6
	note $40 $08
	note $3a $08
	note $39 $08
	note $35 $08
	env $0 $03
	note $34 $10
	env $0 $00
	vol $6
	note $32 $08
	vol $3
	note $34 $08
	vol $6
	note $34 $08
	vol $3
	note $32 $08
	vol $6
	note $39 $08
	vol $3
	note $34 $08
	vol $6
	note $3a $08
	vol $3
	note $39 $08
	vol $6
	note $3a $08
	note $3e $08
	vol $6
	note $40 $08
	note $3e $08
	note $3a $08
	note $39 $08
	env $0 $03
	note $35 $10
	env $0 $00
	vol $6
	note $34 $08
	vol $3
	note $35 $08
	vol $6
	note $35 $08
	vol $3
	note $34 $08
	vol $6
	note $39 $08
	vol $3
	note $35 $08
	vol $6
	note $3a $08
	vol $3
	note $39 $08
	vol $6
	note $3a $08
	note $3e $08
	note $40 $08
	note $3e $08
	note $3a $08
	note $39 $08
	env $0 $03
	note $35 $10
	env $0 $00
	vol $6
	note $34 $08
	vol $3
	note $35 $08
	vol $6
	note $35 $08
	vol $3
	note $34 $08
	vol $6
	note $39 $08
	vol $3
	note $35 $08
	vol $6
	note $3a $08
	note $39 $08
	note $3a $08
	note $3e $08
	note $40 $08
	note $3a $08
	note $39 $08
	note $35 $08
	env $0 $03
	note $34 $10
	env $0 $00
	vol $6
	note $32 $08
	vol $3
	note $34 $08
	vol $6
	note $34 $08
	vol $3
	note $32 $08
	vol $6
	note $39 $08
	vol $3
	note $34 $08
	vol $6
	note $3a $08
	note $39 $08
	note $3a $08
	note $3e $08
	vol $6
	note $40 $08
	note $3a $08
	note $39 $08
	note $35 $08
	env $0 $03
	note $34 $10
	env $0 $00
	vol $6
	note $32 $08
	vol $3
	note $34 $08
	vol $6
	note $34 $08
	vol $3
	note $32 $08
	vol $6
	note $39 $08
	vol $3
	note $34 $08
	vol $6
	note $3a $08
	note $39 $08
	note $3a $08
	note $3e $08
	vol $6
	note $3e $08
	note $39 $08
	note $37 $08
	note $34 $08
	env $0 $03
	note $32 $10
	env $0 $00
	vol $6
	note $30 $08
	vol $3
	note $32 $08
	vol $6
	note $32 $08
	vol $3
	note $30 $08
	vol $6
	note $37 $08
	vol $3
	note $32 $08
	vol $6
	note $39 $08
	note $37 $08
	note $39 $08
	note $3c $08
	vol $6
	note $3e $08
	note $39 $08
	note $37 $08
	note $34 $08
	env $0 $03
	note $32 $10
	env $0 $00
	vol $6
	note $30 $08
	vol $3
	note $32 $08
	vol $6
	note $32 $08
	vol $3
	note $30 $08
	vol $6
	note $37 $08
	vol $3
	note $32 $08
	vol $6
	note $39 $08
	note $37 $08
	note $39 $08
	note $3c $08
	vol $6
	note $3c $08
	note $37 $08
	note $36 $08
	note $32 $08
	env $0 $03
	note $30 $10
	env $0 $00
	vol $6
	note $2e $08
	vol $3
	note $30 $08
	vol $6
	note $30 $08
	vol $3
	note $2e $08
	vol $6
	note $36 $08
	vol $3
	note $30 $08
	vol $6
	note $37 $08
	note $35 $08
	note $37 $08
	note $3a $08
	vol $6
	note $3a $08
	note $35 $08
	note $33 $08
	note $2f $08
	env $0 $03
	note $2e $10
	env $0 $00
	vol $6
	note $2c $08
	vol $3
	note $2e $08
	vol $6
	note $2f $08
	vol $3
	note $2c $08
	vol $6
	note $33 $08
	vol $3
	note $2f $08
	vol $6
	note $35 $08
	note $33 $08
	note $35 $08
	note $38 $08
	vol $6
	note $37 $10
	note $32 $10
	note $2f $10
	note $2b $10
	note $2f $10
	note $32 $10
	note $3a $10
	note $35 $10
	note $32 $10
	note $2e $10
	note $32 $10
	note $35 $10
	note $3d $10
	note $38 $10
	note $35 $10
	note $31 $10
	note $35 $10
	note $38 $10
	note $40 $10
	note $3b $10
	note $38 $10
	note $34 $10
	note $38 $10
	note $3b $10
	vibrato $00
	env $0 $03
	vol $4
	note $3b $08
	note $38 $08
	note $3a $08
	note $37 $08
	note $39 $08
	note $36 $08
	note $38 $08
	note $35 $08
	note $37 $08
	note $34 $08
	note $36 $08
	note $33 $08
	note $35 $08
	note $32 $08
	note $34 $08
	note $31 $08
	note $33 $08
	note $30 $08
	note $32 $08
	note $2f $08
	note $31 $08
	note $2e $08
	note $30 $08
	note $2d $08
	note $2f $08
	note $2c $08
	note $2e $08
	env $0 $04
	note $2b $48
	vibrato $00
	env $0 $00
	goto musicefa3e
	cmdff
; $efcb4
; @addr{efcb4}
sound35Channel4:
musicefcb4:
	duty $0c
	wait1 $0c
	vol $2
	note $40 $08
	note $3b $08
	note $39 $08
	note $35 $08
	note $40 $08
	note $3b $08
	note $39 $08
	note $35 $08
	note $40 $08
	note $3b $08
	note $39 $08
	note $35 $08
	note $40 $08
	note $3b $08
	note $39 $08
	note $35 $08
	note $40 $08
	note $3b $08
	note $39 $08
	note $35 $08
	note $40 $08
	note $3b $08
	note $39 $08
	note $35 $08
	note $40 $08
	note $3b $08
	note $39 $08
	note $35 $08
	note $40 $08
	note $3b $08
	note $39 $08
	note $35 $08
	note $40 $08
	note $3b $08
	note $39 $08
	note $34 $08
	note $40 $08
	note $3b $08
	note $39 $08
	note $34 $08
	note $40 $08
	note $3b $08
	note $39 $08
	note $34 $08
	note $40 $08
	note $3b $08
	note $39 $08
	note $34 $08
	note $40 $08
	note $3b $08
	note $39 $08
	note $34 $08
	note $40 $08
	note $3b $08
	note $39 $08
	note $34 $08
	note $40 $08
	note $3b $08
	note $39 $08
	note $34 $08
	note $40 $08
	note $3b $08
	note $39 $08
	note $34 $08
	vol $0
	note $34 $01
	vol $2
	note $40 $08
	note $3b $08
	note $39 $08
	note $35 $08
	note $40 $08
	note $3b $08
	note $39 $08
	note $35 $08
	note $40 $08
	note $3b $08
	note $39 $08
	note $35 $08
	note $40 $08
	note $3b $08
	note $39 $08
	note $35 $08
	note $40 $08
	note $3b $08
	note $39 $08
	note $35 $08
	note $40 $08
	note $3b $08
	note $39 $08
	note $35 $08
	note $40 $08
	note $3b $08
	note $39 $08
	note $35 $08
	note $40 $08
	note $3b $08
	note $39 $07
	note $35 $01
	vol $0
	note $39 $07
	vol $2
	note $40 $08
	note $3b $08
	note $39 $08
	note $34 $08
	note $40 $08
	note $3b $08
	note $39 $08
	note $34 $08
	note $40 $08
	note $3b $08
	note $39 $08
	note $34 $08
	note $40 $08
	note $3b $08
	note $39 $08
	note $34 $08
	note $40 $08
	note $3b $08
	note $39 $08
	note $34 $08
	note $40 $08
	note $3b $08
	note $39 $08
	note $34 $08
	note $40 $08
	note $3b $08
	note $39 $08
	note $34 $08
	note $40 $08
	note $3b $08
	note $39 $08
	note $34 $08
	vol $2
	note $3e $08
	note $39 $08
	note $37 $08
	note $32 $08
	note $3e $08
	note $39 $08
	note $37 $08
	note $32 $08
	note $3e $08
	note $39 $08
	note $37 $08
	note $32 $08
	note $3e $08
	note $39 $08
	note $37 $08
	note $32 $08
	note $3e $08
	note $39 $08
	note $37 $08
	note $32 $08
	note $3e $08
	note $39 $08
	note $37 $08
	note $32 $08
	note $3e $08
	note $39 $08
	note $37 $08
	note $32 $08
	note $3e $08
	note $39 $08
	note $37 $08
	note $32 $08
	vol $2
	note $3c $08
	note $37 $08
	note $36 $08
	note $30 $08
	vol $2
	note $3c $08
	note $37 $08
	note $36 $08
	note $30 $08
	note $3c $08
	note $37 $08
	note $36 $08
	note $30 $08
	note $3c $08
	note $37 $08
	note $36 $08
	note $30 $08
	note $3a $08
	vol $2
	note $35 $08
	note $33 $08
	note $2f $08
	note $2e $08
	vol $2
	note $3a $08
	vol $2
	note $35 $08
	note $33 $08
	note $2f $08
	note $2e $08
	vol $2
	note $3a $08
	vol $2
	note $35 $08
	note $33 $08
	note $2f $08
	note $2e $08
	vol $4
	note $38 $08
	vibrato $00
	note $37 $10
	note $32 $10
	note $2f $10
	note $2b $10
	note $2f $10
	note $32 $10
	note $3a $10
	note $35 $10
	note $32 $10
	note $2e $10
	note $32 $10
	note $35 $10
	vol $4
	note $3d $10
	note $38 $10
	note $35 $10
	note $31 $10
	note $35 $10
	note $38 $10
	note $40 $10
	note $3b $10
	note $38 $10
	note $34 $10
	note $38 $10
	note $3b $04
	duty $0d
	note $1c $20
	duty $0c
	note $1c $20
	wait1 $bf
	wait1 $21
	goto musicefcb4
	cmdff
; $efe8d
; @addr{efe8d}
sound35Channel0:
musicefe8d:
	duty $02
	vol $8
	env $0 $07
	note $10 $30
	note $0e $30
	note $10 $20
	note $0e $30
	note $10 $30
	note $0e $20
	note $10 $30
	note $0e $30
	note $10 $20
	note $0e $30
	note $10 $30
	note $0e $20
	note $10 $30
	note $0e $30
	note $10 $20
	note $0e $30
	note $10 $30
	note $0e $20
	note $10 $30
	note $0e $30
	note $10 $20
	note $0e $30
	note $10 $30
	note $0e $20
	note $0e $30
	note $0c $30
	note $13 $20
	note $18 $30
	note $16 $30
	note $1d $20
	note $16 $30
	note $14 $30
	note $1b $20
	note $14 $30
	note $12 $30
	note $19 $20
	env $0 $00
	vol $6
	note $13 $60
	note $16 $60
	note $19 $60
	note $1c $60
	vol $4
	env $0 $03
	note $2b $08
	note $2e $08
	note $2a $08
	note $2d $08
	note $29 $08
	note $2c $08
	note $28 $08
	note $2b $08
	note $27 $08
	note $2a $08
	note $26 $08
	note $29 $08
	note $25 $08
	note $28 $08
	note $24 $08
	note $27 $08
	note $23 $08
	note $26 $08
	note $22 $08
	note $25 $08
	note $21 $08
	note $24 $08
	note $20 $08
	note $23 $08
	note $1f $08
	note $22 $08
	note $1e $08
	env $0 $04
	note $21 $48
	goto musicefe8d
	cmdff
; $eff26
sound87Start:
; @addr{eff26}
sound87Channel2:
	duty $02
	env $1 $00
	vol $3
	cmdf8 $30
	note $2a $06
	cmdff
; $eff30
sound89Start:
; @addr{eff30}
sound89Channel2:
	duty $02
	env $1 $00
	vol $d
	note $36 $05
	vol $0
	wait1 $01
	vol $d
	note $3b $05
	vol $0
	wait1 $01
	vol $d
	note $40 $05
	cmdff
; $eff44
sound8bStart:
; @addr{eff44}
sound8bChannel2:
	duty $02
	vol $a
	env $0 $02
	note $42 $06
	note $44 $06
	note $46 $06
	note $47 $06
	env $0 $04
	note $49 $1e
	cmdff
; $eff56
soundcbStart:
; @addr{eff56}
soundcbChannel2:
	duty $02
	vol $c
	cmdf8 $28
	note $33 $02
	cmdf8 $00
	note $33 $01
	duty $02
	vol $6
	vibrato $01
	env $0 $02
	note $33 $0c
	cmdff
; $eff6b
; @addr{eff6b}
soundcbChannel7:
	cmdf0 $b1
	note $25 $01
	cmdf0 $41
	note $14 $0a
	cmdff
; $eff74
sound8cStart:
; @addr{eff74}
sound8cChannel2:
	duty $02
	vol $5
	note $3e $01
	note $4a $04
	cmdff
; $eff7c
sound8eStart:
; @addr{eff7c}
sound8eChannel2:
	duty $02
	vol $c
	cmdf8 $e8
	note $2e $05
	cmdf8 $00
	vol $0
	wait1 $0c
	vol $c
	env $0 $01
	cmdf8 $e6
	note $2a $08
	cmdf8 $00
	vol $c
	env $0 $01
	cmdf8 $ee
	note $2a $06
	cmdf8 $00
	vol $0
	wait1 $03
	vol $d
	env $0 $01
	cmdf8 $de
	note $23 $0f
	cmdf8 $00
	vol $0
	wait1 $0b
	vol $d
	env $0 $01
	cmdf8 $de
	note $23 $0f
	cmdff
; $effb1
sound8fStart:
; @addr{effb1}
sound8fChannel2:
	duty $02
	vol $b
	env $0 $02
	cmdf8 $0f
	note $24 $13
	cmdff
; $effbb
sound90Start:
; @addr{effbb}
sound90Channel2:
	duty $02
	vol $b
	note $30 $02
	vol $a
	note $32 $02
	vol $9
	note $34 $02
	vol $8
	note $36 $02
	note $37 $02
	vol $7
	note $3a $02
	vol $7
	note $30 $02
	vol $6
	note $36 $02
	note $38 $02
	note $3a $02
	vol $5
	note $30 $02
	note $36 $02
	note $38 $02
	vol $4
	note $3a $02
	note $30 $02
	vol $3
	note $36 $02
	note $38 $02
	vol $2
	note $3a $02
	note $30 $02
	vol $1
	note $36 $02
	note $38 $02
	note $3a $02
	cmdff
; $efff6
; GAP
	cmdff
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
sound12Start:
sound13Start:
sound14Start:
sound15Start:
sound18Start:
sound1cStart:
sound1eStart:
sound1fStart:
; @addr{f0000}
sound12Channel6:
sound13Channel6:
sound14Channel6:
sound15Channel4:
sound15Channel6:
sound18Channel6:
sound1cChannel6:
sound1eChannel6:
sound1fChannel6:
	cmdff
; $f0001
; @addr{f0001}
sound1eChannel1:
musicf0001:
	vibrato $e1
	env $0 $00
	cmdf2
	duty $02
	vol $6
	note $1c $1c
	note $1f $1c
	note $26 $1c
	note $23 $1c
	note $2b $1c
	note $28 $1c
	note $26 $1c
	note $28 $1c
	env $0 $00
	note $21 $09
	note $26 $09
	note $28 $0a
	note $2b $09
	note $2d $09
	note $28 $0a
	note $2a $09
	note $2d $09
	note $32 $0a
	note $2f $09
	note $36 $09
	note $34 $0a
	note $2f $09
	note $32 $09
	note $37 $0a
	note $36 $09
	note $39 $09
	note $34 $0a
	note $36 $09
	note $39 $09
	note $3e $0a
	note $3b $09
	note $3d $09
	note $39 $0a
	env $0 $00
	vol $1
	note $47 $04
	note $45 $04
	note $47 $04
	note $45 $04
	vol $2
	note $47 $04
	note $45 $04
	note $47 $04
	note $45 $04
	vol $3
	note $47 $04
	note $45 $04
	note $47 $04
	note $45 $04
	vol $3
	note $47 $04
	note $45 $04
	vol $4
	note $47 $04
	note $45 $04
	env $0 $05
	note $47 $0e
	vol $3
	note $47 $0e
	vol $2
	note $47 $0e
	vol $1
	note $47 $5a
	env $0 $00
	vol $6
	note $21 $1c
	note $20 $1c
	note $1e $1c
	note $1c $1c
	note $1a $1c
	note $1e $1c
	note $1c $1c
	note $15 $1c
	note $1a $1c
	note $17 $1c
	note $1c $1c
	env $0 $06
	note $1e $70
	env $0 $00
	env $0 $00
	note $26 $09
	note $28 $09
	note $2b $0a
	note $2a $09
	note $28 $09
	note $26 $0a
	note $28 $09
	note $2f $09
	note $32 $0a
	note $31 $09
	note $2f $09
	note $2d $0a
	note $2f $09
	note $34 $09
	note $39 $0a
	note $37 $09
	note $36 $09
	note $34 $0a
	note $36 $09
	note $39 $09
	note $3e $0a
	note $3d $09
	note $3b $09
	note $39 $0a
	env $0 $00
	vol $6
	note $34 $04
	note $36 $04
	note $39 $06
	note $3b $04
	env $0 $06
	vol $4
	note $3e $0a
	vol $4
	note $3e $09
	vol $2
	note $3e $09
	vol $1
	note $3e $0a
	env $0 $00
	vol $6
	note $34 $04
	vol $6
	note $36 $04
	note $39 $06
	note $3b $04
	env $0 $06
	vol $5
	note $3e $0a
	vol $4
	note $3e $09
	vol $2
	note $3e $09
	vol $1
	note $3e $0a
	env $0 $00
	vol $6
	note $34 $04
	vol $6
	note $36 $04
	note $39 $06
	note $3b $04
	env $0 $06
	vol $4
	note $3e $0a
	vol $3
	note $3e $09
	vol $2
	note $3e $09
	vol $1
	note $3e $0a
	env $0 $00
	vol $1
	note $43 $04
	note $45 $04
	vol $1
	note $43 $04
	note $45 $04
	vol $2
	note $43 $04
	note $45 $04
	vol $2
	note $43 $04
	note $45 $04
	vol $3
	note $43 $04
	note $45 $04
	vol $3
	note $43 $04
	note $45 $04
	vol $4
	note $43 $04
	note $45 $04
	env $0 $07
	vol $2
	note $43 $0e
	vol $2
	note $43 $0e
	vol $1
	note $43 $0e
	vol $1
	note $43 $46
	env $0 $00
	goto musicf0001
	cmdff
; $f0156
; @addr{f0156}
sound1eChannel0:
musicf0156:
	vibrato $e1
	env $0 $00
	cmdf2
	duty $02
	vol $6
	note $15 $1c
	note $1a $1c
	note $1f $1c
	note $1c $1c
	vol $6
	note $24 $1c
	note $23 $1c
	note $1f $1c
	env $0 $04
	note $21 $2e
	env $0 $00
	env $0 $00
	vol $6
	note $21 $0a
	note $26 $09
	note $28 $09
	note $2b $0a
	note $2d $09
	vol $4
	note $28 $09
	note $2a $0a
	note $2d $09
	note $32 $09
	note $2f $0a
	note $36 $09
	note $34 $09
	note $2f $0a
	note $32 $09
	note $37 $09
	vol $4
	note $36 $0a
	note $39 $09
	note $34 $09
	vol $4
	note $36 $0a
	note $39 $09
	note $3e $09
	note $3b $0a
	env $0 $00
	vol $1
	note $43 $04
	note $41 $04
	note $43 $04
	note $41 $04
	vol $2
	note $43 $04
	note $41 $04
	note $43 $04
	note $41 $04
	vol $3
	note $43 $04
	note $41 $04
	note $43 $04
	note $41 $04
	vol $3
	note $43 $04
	note $41 $04
	vol $4
	note $43 $04
	note $41 $04
	env $0 $06
	vol $2
	note $43 $0e
	vol $2
	note $43 $0e
	vol $2
	note $43 $0e
	vol $1
	note $43 $5a
	env $0 $00
	vol $6
	note $1a $1c
	note $19 $1c
	note $17 $1c
	note $15 $1c
	note $13 $1c
	note $17 $1c
	note $15 $1c
	note $10 $1c
	note $13 $1c
	note $10 $1c
	note $15 $1c
	note $17 $1c
	note $1a $1c
	note $1c $1c
	env $0 $06
	note $1f $31
	env $0 $00
	env $0 $00
	vol $6
	note $23 $09
	note $26 $09
	vol $4
	note $2b $0a
	note $2a $09
	note $28 $09
	note $26 $0a
	note $28 $09
	note $2f $09
	note $32 $0a
	note $31 $09
	note $2f $09
	note $2d $0a
	note $2f $09
	note $34 $09
	vol $4
	note $39 $0a
	note $37 $09
	note $36 $09
	note $34 $0a
	note $36 $09
	note $39 $09
	note $3e $0a
	note $3d $09
	note $3b $09
	note $39 $0a
	env $0 $00
	vol $4
	note $34 $04
	note $36 $05
	note $39 $04
	note $3b $04
	env $0 $06
	vol $3
	note $3e $0d
	vol $2
	note $3e $0e
	vol $1
	note $3e $0c
	env $0 $00
	vol $3
	note $34 $04
	note $36 $05
	note $39 $04
	note $3b $04
	env $0 $06
	vol $2
	note $3e $0d
	vol $1
	note $3e $0e
	vol $1
	note $3e $0c
	env $0 $00
	vol $3
	note $34 $04
	note $36 $05
	note $39 $04
	note $3b $04
	env $0 $06
	vol $2
	note $3e $0c
	vol $1
	note $3e $05
	env $0 $00
	vol $1
	note $47 $04
	note $49 $04
	vol $1
	note $47 $04
	note $49 $04
	vol $2
	note $47 $04
	note $49 $04
	vol $2
	note $47 $04
	note $49 $04
	vol $3
	note $47 $04
	note $49 $04
	vol $3
	note $47 $04
	note $49 $04
	vol $4
	note $47 $04
	note $49 $04
	env $0 $06
	vol $2
	note $47 $0e
	vol $2
	note $47 $0e
	vol $2
	note $47 $0e
	vol $1
	note $47 $47
	env $0 $00
	goto musicf0156
	cmdff
; $f02ac
; @addr{f02ac}
sound1eChannel4:
musicf02ac:
	duty $17
	note $21 $1c
	note $26 $1c
	note $2b $1c
	note $28 $1c
	note $30 $1c
	note $2f $1c
	note $2b $1c
	note $2d $1c
	note $28 $70
	duty $0f
	note $28 $38
	duty $0c
	note $28 $38
	wait1 $c4
	duty $17
	note $26 $1c
	note $25 $1c
	note $23 $1c
	note $21 $1c
	note $1f $1c
	note $23 $1c
	note $21 $1c
	note $1c $1c
	note $1f $1c
	note $1c $1c
	note $21 $1c
	note $23 $70
	duty $0f
	note $23 $38
	duty $0c
	note $23 $38
	wait1 $ff
	wait1 $c1
	goto musicf02ac
	cmdff
; $f02f4
sound1aStart:
; @addr{f02f4}
sound1aChannel1:
musicf02f4:
	vibrato $e1
	env $0 $00
	cmdf2
	duty $02
	vol $6
	note $24 $24
	note $25 $24
	note $24 $24
	note $25 $24
	vol $6
	note $24 $06
	vol $1
	note $24 $03
	vol $6
	note $24 $06
	vol $1
	note $24 $03
	vol $6
	note $24 $06
	vol $1
	note $24 $0c
	vol $4
	note $24 $09
	vol $1
	note $24 $09
	vol $2
	note $24 $09
	vol $1
	note $24 $1b
	vol $6
	note $24 $12
	note $25 $12
	note $28 $12
	note $24 $90
	vol $6
	note $28 $04
	vol $1
	note $28 $05
	vol $3
	note $28 $04
	vol $1
	note $28 $05
	vol $6
	note $22 $04
	vol $1
	note $22 $05
	vol $4
	note $22 $04
	vol $1
	note $22 $05
	vol $2
	note $22 $04
	vol $1
	note $22 $05
	vol $1
	note $22 $04
	wait1 $71
	vol $6
	note $28 $12
	note $22 $12
	vol $3
	note $22 $12
	vol $6
	note $2c $6c
	note $2d $24
	note $2e $24
	note $2f $24
	note $30 $90
	vol $6
	note $34 $04
	vol $1
	note $34 $05
	vol $3
	note $34 $04
	vol $1
	note $34 $05
	vol $6
	note $2e $04
	vol $1
	note $2e $05
	vol $5
	note $2e $04
	vol $1
	note $2e $05
	vol $3
	note $2e $04
	vol $1
	note $2e $05
	vol $2
	note $2e $04
	wait1 $68
	vol $6
	note $2f $09
	note $34 $09
	note $39 $09
	note $38 $09
	note $31 $09
	note $38 $09
	note $3b $09
	note $39 $09
	note $34 $09
	note $39 $09
	note $3f $09
	note $3d $09
	note $33 $09
	note $38 $09
	note $3d $09
	note $3b $09
	note $33 $09
	note $34 $09
	note $3b $09
	note $39 $09
	note $31 $09
	note $33 $09
	note $39 $09
	note $38 $09
	note $2d $09
	note $31 $09
	note $38 $09
	note $36 $09
	note $2c $09
	note $2f $09
	note $36 $09
	note $34 $09
	note $2a $09
	note $2d $09
	note $34 $09
	note $39 $09
	note $2f $09
	note $34 $09
	note $39 $09
	note $3c $09
	note $32 $09
	note $37 $09
	note $3c $09
	note $41 $09
	note $37 $09
	note $3c $09
	note $41 $09
	note $46 $09
	note $3a $09
	note $41 $09
	note $46 $09
	note $4a $09
	note $3e $09
	note $45 $09
	note $4a $09
	note $4b $09
	note $40 $09
	note $45 $09
	note $4b $09
	note $4d $09
	note $43 $09
	note $46 $09
	note $4d $09
	note $4c $09
	wait1 $0d
	vol $3
	note $4c $09
	wait1 $0e
	vol $1
	note $4c $09
	wait1 $24
	goto musicf02f4
	cmdff
; $f0415
; @addr{f0415}
sound1aChannel0:
	vibrato $e1
	env $0 $00
	cmdf2
	duty $02
musicf041c:
	vol $6
	note $1e $24
	note $1f $24
	note $1e $24
	note $1f $24
	vol $6
	note $1e $04
	vol $1
	note $1e $05
	vol $6
	note $1e $04
	vol $1
	note $1e $05
	vol $6
	note $1e $04
	vol $1
	note $1e $0e
	vol $4
	note $1e $09
	vol $1
	note $1e $09
	vol $2
	note $1e $09
	vol $1
	note $1e $1b
	vol $6
	note $1e $12
	note $1f $12
	note $24 $12
	note $1e $90
	vol $7
	note $22 $04
	vol $1
	note $22 $05
	vol $4
	note $22 $04
	vol $1
	note $22 $05
	vol $6
	note $1c $04
	vol $1
	note $1c $05
	vol $5
	note $1c $04
	vol $1
	note $1c $05
	vol $3
	note $1c $04
	vol $1
	note $1c $05
	vol $2
	note $1c $04
	wait1 $71
	vol $6
	note $1e $12
	note $1f $24
	note $20 $24
	note $21 $24
	note $22 $24
	note $23 $24
	note $24 $24
	note $25 $24
	note $26 $24
	note $27 $24
	note $28 $24
	note $29 $24
	vol $6
	note $2e $04
	vol $1
	note $2e $05
	vol $3
	note $2e $04
	vol $1
	note $2e $05
	vol $6
	note $28 $04
	vol $1
	note $28 $05
	vol $5
	note $28 $04
	vol $1
	note $28 $05
	vol $3
	note $28 $04
	vol $1
	note $28 $05
	vol $1
	note $28 $04
	wait1 $80
	vol $2
	note $2f $09
	note $34 $09
	note $39 $09
	note $38 $09
	note $31 $09
	note $38 $09
	note $3b $09
	note $39 $09
	note $34 $09
	note $39 $09
	note $3f $09
	note $3d $09
	note $33 $09
	note $38 $09
	note $3d $09
	note $3b $09
	note $33 $09
	note $34 $09
	note $3b $09
	note $39 $09
	note $31 $09
	note $33 $09
	note $39 $09
	note $38 $09
	note $2d $07
	note $31 $01
	vol $0
	note $2d $08
	note $31 $01
	vol $2
	note $38 $0a
	note $36 $09
	note $2c $09
	note $2f $09
	note $36 $09
	note $34 $09
	note $2a $09
	note $2d $09
	note $34 $09
	note $39 $09
	note $2f $09
	note $34 $09
	note $39 $09
	note $3c $09
	note $32 $09
	note $37 $09
	note $3c $09
	note $41 $09
	note $37 $09
	note $3c $09
	note $41 $09
	note $46 $09
	note $3a $09
	note $41 $09
	note $46 $09
	note $4a $09
	note $3e $09
	note $45 $09
	note $4a $09
	note $4b $09
	note $40 $09
	note $45 $09
	note $4b $09
	note $4a $09
	wait1 $03
	vol $2
	note $4c $03
	wait1 $57
	goto musicf041c
	cmdff
; $f0535
; @addr{f0535}
sound1aChannel4:
	cmdf2
musicf0536:
	duty $07
	note $19 $12
	note $18 $12
	note $17 $12
	note $16 $12
	note $15 $12
	note $14 $12
	note $13 $12
	note $12 $12
	note $19 $12
	note $18 $12
	note $17 $12
	note $16 $12
	note $15 $12
	note $14 $12
	note $13 $12
	note $12 $12
	note $19 $12
	note $18 $12
	note $17 $12
	note $16 $12
	note $15 $12
	note $14 $12
	note $13 $12
	note $12 $12
	note $19 $12
	note $18 $12
	note $17 $12
	note $16 $12
	note $15 $12
	note $14 $12
	note $13 $12
	note $12 $12
	note $19 $12
	note $18 $12
	note $17 $12
	note $16 $12
	note $15 $12
	note $14 $12
	note $13 $12
	note $12 $12
	note $19 $12
	note $18 $12
	note $17 $12
	note $16 $12
	note $15 $12
	note $14 $12
	note $13 $12
	note $12 $12
	note $19 $12
	note $18 $12
	note $17 $12
	note $16 $12
	note $15 $12
	note $14 $12
	note $13 $12
	note $12 $12
	note $19 $12
	note $18 $12
	note $17 $12
	note $16 $12
	note $15 $12
	note $14 $12
	note $13 $12
	note $10 $24
	wait1 $ff
	wait1 $ff
	wait1 $8a
	goto musicf0536
	cmdff
; $f05c2
; @addr{f05c2}
sound1aChannel6:
	cmdf2
musicf05c3:
	vol $6
	note $22 $02
	vol $4
	note $23 $22
	vol $6
	note $22 $02
	vol $4
	note $23 $22
	vol $6
	note $22 $02
	vol $4
	note $23 $10
	vol $6
	note $22 $02
	vol $4
	note $23 $10
	vol $6
	note $22 $02
	vol $4
	note $23 $22
	vol $6
	note $22 $02
	vol $4
	note $23 $22
	vol $6
	note $22 $02
	vol $4
	note $23 $22
	vol $6
	note $22 $02
	vol $4
	note $23 $10
	vol $6
	note $22 $02
	vol $4
	note $23 $10
	vol $6
	note $22 $02
	vol $4
	note $23 $22
	vol $6
	note $22 $02
	vol $4
	note $23 $22
	vol $6
	note $22 $02
	vol $4
	note $23 $22
	vol $6
	note $22 $02
	vol $4
	note $23 $10
	vol $6
	note $22 $02
	vol $4
	note $23 $10
	vol $6
	note $22 $02
	vol $4
	note $23 $22
	vol $6
	note $22 $02
	vol $4
	note $23 $22
	vol $6
	note $22 $02
	vol $4
	note $23 $22
	vol $6
	note $22 $02
	vol $4
	note $23 $07
	vol $6
	note $22 $02
	vol $4
	note $23 $07
	vol $6
	note $22 $02
	vol $4
	note $23 $07
	vol $6
	note $22 $02
	vol $4
	note $23 $07
	vol $6
	note $22 $02
	vol $4
	note $23 $22
	vol $6
	note $22 $02
	vol $4
	note $23 $22
	vol $6
	note $22 $02
	vol $4
	note $23 $22
	vol $6
	note $22 $02
	vol $4
	note $23 $22
	vol $6
	note $22 $02
	vol $4
	note $23 $22
	vol $6
	note $22 $02
	vol $4
	note $23 $22
	vol $6
	note $22 $02
	vol $4
	note $23 $22
	vol $6
	note $22 $02
	vol $4
	note $23 $22
	vol $6
	note $22 $02
	vol $4
	note $23 $22
	vol $6
	note $22 $02
	vol $4
	note $23 $22
	vol $6
	note $22 $02
	vol $4
	note $23 $22
	vol $6
	note $22 $02
	vol $4
	note $23 $10
	vol $6
	note $22 $02
	vol $4
	note $23 $10
	vol $6
	note $22 $02
	vol $4
	note $23 $22
	vol $6
	note $22 $02
	vol $4
	note $23 $22
	vol $6
	note $22 $02
	vol $4
	note $23 $22
	vol $6
	note $22 $02
	vol $4
	note $23 $10
	vol $6
	note $22 $02
	vol $4
	note $23 $10
	wait1 $ff
	wait1 $ff
	wait1 $c0
	goto musicf05c3
	cmdff
; $f06b7
; @addr{f06b7}
sound13Channel1:
	vibrato $f1
	env $0 $00
	cmdf2
	duty $02
musicf06be:
	vol $4
	note $2f $12
	vol $5
	note $30 $12
	vol $6
	note $31 $36
	note $30 $12
	note $31 $12
	note $30 $12
	note $29 $09
	wait1 $04
	vol $3
	note $29 $02
	wait1 $03
	vol $6
	note $29 $09
	wait1 $04
	vol $3
	note $29 $02
	wait1 $6f
	vol $4
	note $2d $12
	vol $5
	note $2e $12
	vol $6
	note $2f $36
	vol $6
	note $2e $12
	note $2f $12
	note $2e $12
	note $28 $09
	wait1 $03
	vol $4
	note $28 $03
	wait1 $03
	vol $6
	note $28 $09
	wait1 $02
	vol $5
	note $28 $03
	wait1 $04
	vol $2
	note $28 $03
	wait1 $69
	vol $4
	note $2f $12
	vol $6
	note $30 $12
	vol $6
	note $31 $36
	vol $6
	note $30 $12
	note $31 $12
	note $30 $12
	note $29 $09
	wait1 $02
	vol $4
	note $29 $03
	wait1 $04
	vol $6
	note $29 $09
	wait1 $02
	vol $4
	note $29 $03
	wait1 $04
	vol $2
	note $29 $03
	wait1 $69
	vol $5
	note $2d $12
	vol $5
	note $2e $12
	vol $6
	note $2f $36
	vol $6
	note $2e $12
	note $2f $12
	note $2e $12
	note $28 $09
	wait1 $03
	vol $4
	note $28 $03
	wait1 $03
	vol $6
	note $28 $09
	wait1 $01
	vol $4
	note $28 $03
	wait1 $05
	vol $2
	note $28 $03
	wait1 $69
	duty $01
	vol $6
	note $23 $09
	note $22 $09
	note $20 $09
	note $1e $09
	note $1d $55
	wait1 $17
	note $22 $04
	note $23 $05
	note $22 $09
	note $20 $09
	note $1e $09
	note $1d $5a
	wait1 $12
	note $21 $09
	note $20 $09
	note $1e $09
	note $1d $09
	note $1b $5a
	wait1 $12
	note $21 $09
	note $20 $09
	note $1e $09
	note $1d $09
	note $1b $12
	note $1d $09
	wait1 $1b
	note $1b $12
	note $1d $09
	wait1 $1b
	note $23 $09
	note $22 $09
	note $20 $09
	note $1e $09
	note $1d $55
	wait1 $17
	note $23 $09
	note $22 $09
	note $20 $09
	note $1e $09
	note $1d $3f
	wait1 $09
	note $1d $09
	note $1f $09
	note $21 $09
	note $23 $09
	note $24 $09
	wait1 $09
	note $24 $09
	wait1 $09
	note $2a $6c
	wait1 $48
	duty $02
	goto musicf06be
	cmdff
; $f07c7
; @addr{f07c7}
sound13Channel0:
	cmdf2
	vibrato $f1
	env $0 $00
	duty $02
musicf07ce:
	vol $4
	note $29 $12
	vol $5
	note $2a $12
	vol $6
	note $2b $36
	note $2a $12
	note $2b $12
	note $2a $12
	vol $6
	note $23 $09
	wait1 $04
	vol $3
	note $23 $02
	wait1 $03
	vol $6
	note $23 $09
	wait1 $04
	vol $3
	note $23 $02
	wait1 $6f
	vol $4
	note $28 $12
	vol $5
	note $29 $12
	vol $6
	note $2a $36
	vol $6
	note $29 $12
	note $2a $12
	note $29 $12
	note $22 $09
	wait1 $03
	vol $3
	note $22 $03
	wait1 $03
	vol $6
	note $22 $09
	wait1 $03
	vol $2
	note $22 $03
	wait1 $03
	vol $2
	note $22 $03
	wait1 $69
	vol $3
	note $29 $12
	vol $5
	note $2a $12
	vol $6
	note $2b $36
	note $2a $12
	note $2b $12
	note $2a $12
	vol $6
	note $23 $09
	wait1 $03
	vol $3
	note $23 $03
	wait1 $03
	vol $6
	note $23 $09
	wait1 $03
	vol $3
	note $23 $03
	wait1 $03
	vol $2
	note $23 $03
	wait1 $0f
	vol $6
	note $1e $04
	wait1 $01
	vol $4
	note $1e $05
	wait1 $01
	vol $3
	note $1e $04
	wait1 $4b
	vol $3
	note $28 $12
	vol $5
	note $29 $12
	vol $6
	note $2a $36
	note $29 $12
	vol $6
	note $2a $12
	note $29 $12
	note $22 $09
	wait1 $03
	vol $3
	note $22 $03
	wait1 $03
	vol $6
	note $22 $09
	wait1 $03
	vol $3
	note $22 $03
	wait1 $03
	vol $2
	note $22 $03
	wait1 $0f
	vol $6
	note $1c $04
	wait1 $01
	vol $5
	note $1c $05
	wait1 $01
	vol $3
	note $1c $04
	wait1 $ff
	wait1 $ff
	wait1 $ff
	wait1 $e4
	vol $1
	note $30 $04
	wait1 $05
	vol $2
	note $31 $04
	vol $0
	note $30 $05
	vol $2
	note $30 $04
	vol $1
	note $31 $05
	vol $3
	note $31 $04
	vol $1
	note $30 $05
	vol $3
	note $30 $04
	vol $1
	note $31 $05
	vol $4
	note $31 $04
	vol $1
	note $30 $05
	vol $4
	note $30 $04
	vol $2
	note $31 $05
	vol $5
	note $31 $04
	vol $2
	note $30 $05
	vol $5
	note $30 $04
	vol $2
	note $31 $05
	vol $6
	note $31 $04
	vol $2
	note $30 $05
	wait1 $48
	goto musicf07ce
	cmdff
; $f08ce
; @addr{f08ce}
sound13Channel4:
musicf08ce:
	duty $0e
	note $17 $09
	wait1 $09
	note $17 $09
	wait1 $75
	note $17 $09
	wait1 $09
	note $17 $09
	wait1 $75
	note $16 $09
	wait1 $09
	note $16 $09
	wait1 $75
	note $16 $09
	wait1 $09
	note $16 $09
	wait1 $75
	note $17 $09
	wait1 $09
	note $17 $09
	wait1 $75
	note $17 $09
	wait1 $09
	note $17 $09
	wait1 $63
	note $17 $09
	wait1 $09
	note $16 $09
	wait1 $09
	note $16 $09
	wait1 $75
	note $16 $09
	wait1 $09
	note $16 $09
	wait1 $63
	note $16 $09
	wait1 $09
	note $17 $09
	wait1 $09
	note $17 $09
	wait1 $1b
	note $11 $09
	wait1 $09
	note $17 $09
	wait1 $09
	note $17 $09
	wait1 $1b
	note $11 $09
	wait1 $09
	note $17 $09
	wait1 $09
	note $17 $09
	wait1 $1b
	note $11 $09
	wait1 $09
	note $17 $09
	wait1 $09
	note $17 $09
	wait1 $1b
	note $11 $09
	wait1 $09
	note $15 $09
	wait1 $09
	note $15 $09
	wait1 $1b
	note $0f $09
	wait1 $09
	note $15 $09
	wait1 $09
	note $15 $09
	wait1 $1b
	note $0f $09
	wait1 $09
	note $15 $09
	wait1 $09
	note $15 $09
	wait1 $09
	note $0f $12
	note $11 $09
	wait1 $1b
	note $0f $12
	note $11 $09
	wait1 $1b
	note $17 $09
	wait1 $09
	note $17 $09
	wait1 $1b
	note $11 $09
	wait1 $09
	note $17 $09
	wait1 $09
	note $17 $09
	wait1 $1b
	note $11 $09
	wait1 $09
	note $17 $09
	wait1 $09
	note $17 $09
	wait1 $1b
	note $11 $09
	wait1 $09
	note $17 $09
	wait1 $09
	note $17 $09
	wait1 $1b
	note $11 $09
	wait1 $09
	note $12 $09
	wait1 $09
	note $12 $09
	wait1 $09
	note $0e $6c
	wait1 $48
	goto musicf08ce
	cmdff
; $f09b4
; @addr{f09b4}
sound14Channel1:
	vibrato $00
	env $0 $00
	cmdf2
	duty $02
musicf09bb:
	vol $6
	note $26 $10
	note $27 $10
	note $2d $10
	note $32 $10
	note $27 $10
	note $30 $10
	note $27 $10
	note $30 $10
	note $2d $10
	note $27 $10
	note $26 $10
	note $2d $10
	note $26 $10
	note $27 $10
	note $2d $10
	note $32 $10
	note $27 $10
	note $30 $10
	note $27 $10
	note $30 $10
	note $2d $10
	note $27 $10
	note $26 $10
	note $2d $10
	note $26 $10
	note $27 $10
	note $2d $10
	note $32 $10
	note $27 $10
	note $30 $10
	note $27 $10
	note $30 $10
	note $2d $10
	note $27 $10
	note $26 $10
	note $2d $10
	note $26 $10
	note $27 $10
	note $2d $10
	note $32 $10
	note $27 $10
	note $30 $10
	note $27 $10
	note $30 $10
	note $2d $10
	note $27 $10
	note $26 $10
	note $2d $10
	note $28 $10
	note $29 $10
	note $2f $10
	note $34 $10
	note $29 $10
	note $32 $10
	note $29 $10
	note $32 $10
	note $2f $10
	note $29 $10
	note $28 $10
	note $2f $10
	note $28 $10
	note $29 $10
	note $2f $10
	note $34 $10
	note $29 $10
	note $32 $10
	note $29 $10
	note $32 $10
	note $2f $10
	note $29 $10
	note $28 $10
	note $2f $10
	note $28 $10
	note $29 $10
	note $2f $10
	note $34 $10
	note $29 $10
	note $32 $10
	note $29 $10
	note $32 $10
	note $2f $10
	note $29 $10
	note $28 $10
	note $2f $10
	note $28 $10
	note $29 $10
	note $2f $10
	note $34 $10
	note $29 $10
	note $32 $10
	note $29 $10
	note $32 $10
	note $2f $10
	note $29 $10
	note $28 $10
	note $26 $10
	vol $6
	note $23 $10
	note $22 $10
	note $21 $10
	note $20 $10
	wait1 $04
	vol $3
	note $20 $08
	wait1 $04
	vol $1
	note $20 $08
	wait1 $08
	vol $6
	note $20 $10
	note $1f $10
	note $1e $10
	note $1d $10
	wait1 $04
	vol $3
	note $1d $08
	wait1 $04
	vol $1
	note $1d $08
	wait1 $08
	vol $6
	note $1d $10
	note $1c $10
	note $1b $10
	note $1a $10
	wait1 $04
	vol $3
	note $1a $08
	wait1 $04
	vol $1
	note $1a $08
	wait1 $08
	vol $6
	note $1a $10
	note $19 $10
	note $18 $10
	note $17 $10
	wait1 $04
	vol $3
	note $17 $08
	wait1 $04
	vol $1
	note $17 $08
	wait1 $08
	goto musicf09bb
	cmdff
; $f0ad4
; @addr{f0ad4}
sound14Channel0:
	vibrato $00
	env $0 $00
	cmdf2
	duty $02
musicf0adb:
	vol $0
	note $20 $12
	vol $3
	note $26 $10
	note $27 $10
	note $2d $10
	note $32 $10
	note $27 $10
	note $30 $10
	note $27 $10
	note $30 $10
	note $2d $10
	vol $3
	note $27 $10
	note $26 $10
	note $2d $10
	note $26 $10
	note $27 $10
	note $2d $10
	note $32 $10
	note $27 $10
	note $30 $10
	note $27 $10
	vol $3
	note $30 $10
	note $2d $10
	note $27 $10
	note $26 $10
	wait1 $10
	note $26 $10
	note $27 $10
	note $2d $10
	note $32 $10
	note $27 $10
	note $30 $10
	note $27 $10
	note $30 $10
	note $2d $10
	note $27 $10
	note $26 $10
	note $2d $10
	note $26 $10
	note $27 $10
	note $2d $10
	note $32 $10
	note $27 $10
	note $30 $10
	note $27 $10
	note $30 $10
	note $2d $10
	note $27 $10
	note $26 $10
	note $2d $10
	note $28 $10
	note $29 $10
	note $2f $10
	note $34 $10
	note $29 $10
	note $32 $10
	note $29 $10
	note $32 $10
	note $2f $10
	note $29 $10
	note $28 $10
	note $2f $10
	note $28 $10
	note $29 $10
	note $2f $10
	note $34 $10
	note $29 $10
	note $32 $10
	note $29 $10
	note $32 $10
	note $2f $10
	note $29 $10
	note $28 $10
	note $2f $10
	note $28 $10
	note $29 $10
	note $2f $10
	note $34 $10
	note $29 $10
	vol $3
	note $32 $10
	note $29 $10
	note $32 $10
	note $2f $10
	note $29 $10
	note $28 $10
	note $2f $10
	note $28 $10
	note $29 $10
	note $2f $10
	note $34 $10
	note $29 $10
	note $32 $10
	note $29 $10
	note $32 $10
	note $2f $10
	note $29 $10
	note $28 $0a
	wait1 $04
	vol $6
	note $1c $10
	vol $6
	note $1b $10
	vol $6
	note $1a $10
	note $19 $10
	wait1 $04
	vol $3
	note $19 $08
	wait1 $04
	vol $1
	note $19 $08
	wait1 $08
	vol $6
	note $19 $10
	vol $6
	note $18 $10
	note $17 $10
	note $16 $10
	wait1 $04
	vol $3
	note $16 $08
	wait1 $04
	vol $1
	note $16 $08
	wait1 $08
	vol $6
	note $16 $10
	note $15 $10
	vol $6
	note $14 $10
	note $13 $10
	wait1 $04
	vol $3
	note $13 $08
	wait1 $04
	vol $1
	note $13 $08
	wait1 $08
	vol $6
	note $13 $10
	note $12 $10
	note $11 $10
	vol $6
	note $10 $10
	wait1 $04
	vol $3
	note $10 $08
	wait1 $04
	vol $1
	note $10 $08
	wait1 $08
	goto musicf0adb
	cmdff
; $f0bff
; @addr{f0bff}
sound14Channel4:
	cmdf2
musicf0c00:
	duty $0e
	note $0e $10
	wait1 $10
	note $0e $10
	wait1 $70
	note $0c $20
	note $0e $10
	wait1 $10
	note $0e $10
	wait1 $80
	note $0c $10
	note $0e $0a
	wait1 $06
	note $0e $0a
	wait1 $06
	note $0e $10
	wait1 $70
	note $0c $20
	note $0e $10
	note $0c $10
	note $0e $10
	wait1 $70
	note $0f $20
	note $10 $10
	wait1 $10
	note $10 $10
	wait1 $80
	note $0e $10
	note $10 $10
	note $13 $10
	note $10 $10
	wait1 $80
	note $0e $10
	note $10 $10
	note $13 $10
	note $17 $10
	note $16 $75
	wait1 $0b
	note $0e $10
	note $10 $10
	note $0e $10
	note $10 $10
	note $0a $90
	wait1 $08
	duty $0f
	note $23 $10
	note $22 $10
	note $21 $10
	note $20 $10
	wait1 $20
	note $20 $10
	note $1f $10
	note $1e $10
	note $1d $10
	wait1 $20
	note $1d $10
	note $1c $10
	note $1b $10
	note $1a $10
	wait1 $20
	note $1a $10
	note $19 $10
	note $18 $10
	note $17 $10
	wait1 $08
	duty $0e
	note $0c $10
	goto musicf0c00
	cmdff
; $f0c8a
; @addr{f0c8a}
sound12Channel1:
	vibrato $00
	env $0 $03
	cmdf2
	duty $02
musicf0c91:
	vol $6
	note $1f $1c
	note $1e $1c
	note $1f $1c
	note $1e $1c
	note $1f $2a
	vibrato $00
	note $18 $04
	env $0 $00
	note $19 $05
	note $1a $05
	note $1b $07
	wait1 $0b
	vol $2
	note $1b $07
	wait1 $0c
	vol $1
	note $1b $07
	wait1 $0c
	vibrato $00
	env $0 $03
	vol $6
	note $1f $1c
	note $1e $1c
	note $1f $1c
	note $1e $1c
	note $1f $2a
	vibrato $00
	env $0 $00
	note $3f $04
	note $3e $05
	note $3c $05
	note $39 $07
	wait1 $0b
	vol $2
	note $39 $07
	wait1 $0c
	vol $1
	note $39 $07
	wait1 $0c
	vibrato $00
	env $0 $03
	vol $6
	note $1f $1c
	note $1e $1c
	note $1f $1c
	note $21 $1c
	note $1f $1c
	note $21 $1c
	note $1f $1c
	note $1e $1c
	note $1f $1c
	note $21 $1c
	note $1f $1c
	note $21 $1c
	note $1f $2a
	vibrato $00
	env $0 $00
	note $1f $04
	note $20 $05
	note $21 $05
	note $22 $07
	wait1 $0b
	vol $3
	note $22 $07
	wait1 $0c
	vol $2
	note $22 $07
	wait1 $0c
	vibrato $00
	env $0 $03
	goto musicf0c91
	cmdff
; $f0d1a
; @addr{f0d1a}
sound12Channel0:
	vibrato $00
	env $0 $03
	cmdf2
	duty $02
musicf0d21:
	vol $6
	note $16 $1c
	note $18 $1c
	note $16 $1c
	note $18 $1c
	note $16 $2a
	wait1 $46
	note $16 $1c
	note $18 $1c
	note $16 $1c
	note $18 $1c
	note $16 $2a
	wait1 $46
	note $16 $1c
	note $18 $1c
	note $16 $1c
	note $18 $1c
	note $16 $1c
	note $18 $1c
	note $16 $1c
	note $18 $1c
	note $16 $1c
	note $18 $1c
	note $16 $1c
	note $18 $1c
	note $16 $2a
	wait1 $46
	goto musicf0d21
	cmdff
; $f0d5a
; @addr{f0d5a}
sound12Channel4:
	cmdf2
musicf0d5b:
	duty $17
	note $27 $07
	wait1 $15
	note $2b $15
	note $27 $07
	note $2e $07
	wait1 $15
	note $2d $2a
	wait1 $62
	note $27 $07
	wait1 $15
	note $2b $15
	note $27 $07
	note $21 $07
	wait1 $15
	note $22 $38
	wait1 $54
	note $27 $07
	wait1 $15
	note $2b $15
	note $2e $07
	note $32 $07
	wait1 $15
	note $2a $23
	wait1 $07
	note $2e $1c
	note $2d $1c
	note $2b $0e
	note $24 $0e
	note $26 $0e
	note $2a $07
	wait1 $15
	note $2e $15
	note $2b $07
	note $2e $07
	wait1 $15
	note $28 $2a
	wait1 $62
	goto musicf0d5b
	cmdff
; $f0dab
sound19Start:
; @addr{f0dab}
sound19Channel1:
	vibrato $f1
	env $0 $00
	cmdf2
	duty $02
musicf0db2:
	vol $0
	note $20 $28
	vol $6
	note $26 $28
	note $29 $28
	note $28 $28
	note $27 $50
	note $26 $3c
	vibrato $01
	env $0 $00
	vol $3
	note $26 $14
	vibrato $00
	env $0 $03
	vol $6
	note $25 $0d
	note $20 $0d
	note $1f $0e
	vol $4
	note $25 $0d
	note $20 $0d
	note $1f $0e
	vol $2
	note $25 $0d
	note $20 $0d
	note $1f $0e
	vol $1
	note $25 $0d
	note $20 $0d
	note $1f $0e
	vol $6
	note $31 $0d
	note $2c $0d
	note $2b $0e
	vol $4
	note $31 $0d
	note $2c $0d
	note $2b $0e
	vol $2
	note $31 $0d
	note $2c $0d
	note $2b $0e
	vol $1
	note $31 $0d
	note $2c $0d
	note $2b $36
	vibrato $f1
	env $0 $00
	vol $6
	note $35 $28
	note $39 $28
	note $38 $28
	note $37 $50
	note $36 $3c
	vibrato $01
	env $0 $00
	vol $3
	note $36 $14
	vibrato $00
	env $0 $03
	vol $6
	note $36 $0d
	note $30 $0d
	note $2f $0e
	vol $4
	note $36 $0d
	note $30 $0d
	note $2f $0e
	vol $2
	note $36 $0d
	note $30 $0d
	note $2f $0e
	vol $1
	note $36 $0d
	note $30 $0d
	note $2f $0e
	vol $6
	note $42 $0d
	note $3c $0d
	note $3b $0e
	vol $4
	note $42 $0d
	note $3c $0d
	note $3b $0e
	vol $2
	note $42 $0d
	note $3c $0d
	note $3b $0e
	vol $1
	note $42 $0d
	note $3c $0d
	note $3b $0e
	vibrato $f1
	env $0 $00
	vol $6
	note $26 $0a
	note $29 $0a
	note $2b $0a
	note $29 $0a
	note $2c $a0
	vibrato $01
	env $0 $00
	vol $3
	note $2c $28
	vibrato $f1
	env $0 $00
	vol $6
	note $2c $14
	note $2b $0a
	wait1 $05
	vol $3
	note $2b $05
	vol $6
	note $29 $0a
	wait1 $05
	vol $3
	note $29 $05
	vol $6
	note $26 $0a
	wait1 $05
	vol $3
	note $26 $05
	vol $6
	note $29 $14
	note $26 $0a
	wait1 $0a
	vol $3
	note $29 $14
	note $26 $0a
	wait1 $0a
	vol $2
	note $29 $14
	note $26 $0a
	wait1 $0a
	vol $1
	note $29 $14
	note $26 $0a
	wait1 $0a
	vibrato $00
	env $0 $03
	vol $6
	note $32 $0a
	note $3e $0a
	note $32 $0a
	wait1 $0a
	vol $3
	note $32 $0a
	note $3e $0a
	note $32 $0a
	wait1 $0a
	vol $2
	note $32 $0a
	note $3e $0a
	note $32 $0a
	wait1 $0a
	vol $1
	note $32 $0a
	note $3e $0a
	note $32 $0a
	wait1 $0a
	vibrato $f1
	env $0 $00
	vol $6
	note $26 $0a
	note $29 $0a
	note $2d $0a
	note $2c $0a
	note $30 $a0
	vibrato $01
	env $0 $00
	vol $3
	note $30 $28
	vibrato $f1
	env $0 $00
	vol $6
	note $33 $14
	note $2f $0a
	wait1 $05
	vol $3
	note $2f $05
	vol $6
	note $2b $0a
	wait1 $05
	vol $3
	note $2b $05
	vol $6
	note $27 $0a
	wait1 $05
	vol $3
	note $27 $05
	vol $6
	note $26 $0a
	wait1 $0a
	vol $4
	note $26 $0a
	wait1 $0a
	vol $2
	note $26 $0a
	wait1 $0a
	vol $1
	note $26 $0a
	wait1 $5a
	vibrato $00
	env $0 $03
	vol $6
	note $32 $0a
	note $3e $0a
	note $32 $0a
	wait1 $0a
	vol $3
	note $32 $0a
	note $3e $0a
	note $32 $0a
	wait1 $0a
	vol $2
	note $32 $0a
	note $3e $0a
	note $32 $0a
	wait1 $0a
	vol $1
	note $32 $0a
	note $3e $0a
	note $32 $14
	vibrato $f1
	env $0 $00
	goto musicf0db2
	cmdff
; $f0f43
; @addr{f0f43}
sound19Channel0:
	vibrato $f1
	env $0 $00
	cmdf2
	duty $02
musicf0f4a:
	vol $0
	note $20 $28
	vol $6
	note $21 $28
	note $24 $28
	note $23 $28
	note $22 $50
	note $20 $3c
	vibrato $01
	env $0 $00
	vol $4
	note $20 $14
	wait1 $0f
	vibrato $00
	env $0 $03
	note $25 $0d
	note $20 $0d
	note $1f $06
	wait1 $08
	vol $3
	note $25 $0d
	note $20 $0d
	note $1f $06
	wait1 $08
	vol $2
	note $25 $0d
	note $20 $0d
	note $1f $06
	wait1 $08
	vol $1
	note $25 $0d
	note $20 $0d
	note $1f $06
	wait1 $08
	vol $4
	note $31 $0d
	note $2c $0d
	note $2b $06
	wait1 $08
	vol $3
	note $31 $0d
	note $2c $0d
	note $2b $06
	wait1 $08
	vol $2
	note $31 $0d
	note $2c $0d
	note $2b $06
	wait1 $08
	vol $1
	note $31 $0d
	note $2c $0d
	note $2b $06
	wait1 $21
	vibrato $f1
	env $0 $00
	vol $7
	note $30 $28
	note $34 $28
	note $33 $28
	note $32 $50
	note $31 $3c
	vibrato $01
	env $0 $00
	vol $4
	note $31 $14
	wait1 $0f
	vibrato $00
	env $0 $03
	vol $3
	note $36 $0d
	note $30 $0d
	note $2f $06
	wait1 $08
	vol $2
	note $36 $0d
	note $30 $0d
	note $2f $06
	wait1 $08
	vol $2
	note $36 $0d
	note $30 $0d
	note $2f $06
	wait1 $08
	vol $1
	note $36 $0d
	note $30 $0d
	note $2f $06
	wait1 $08
	vol $4
	note $42 $0d
	note $3c $0d
	note $3b $06
	wait1 $08
	vol $3
	note $42 $0d
	note $3c $0d
	note $3b $06
	wait1 $08
	vol $2
	note $42 $0d
	note $3c $0d
	note $3b $06
	wait1 $08
	vol $1
	note $42 $0d
	note $3c $0c
	vibrato $f1
	env $0 $00
	vol $6
	note $21 $0a
	note $24 $0a
	note $26 $0a
	note $24 $0a
	note $27 $a0
	vibrato $01
	env $0 $00
	vol $3
	note $27 $28
	vibrato $f1
	env $0 $00
	vol $6
	note $27 $14
	note $26 $0a
	wait1 $05
	vol $3
	note $26 $05
	vol $6
	note $24 $0a
	wait1 $05
	vol $3
	note $24 $05
	vol $6
	note $21 $0a
	wait1 $05
	vol $3
	note $21 $05
	wait1 $af
	vibrato $00
	env $0 $03
	vol $4
	note $32 $0a
	note $3e $0a
	note $32 $0a
	wait1 $0a
	vol $3
	note $32 $0a
	note $3e $0a
	note $32 $0a
	wait1 $0a
	vol $2
	note $32 $0a
	note $3e $0a
	note $32 $0a
	wait1 $0a
	vol $1
	note $32 $0a
	note $3e $0a
	note $32 $05
	vibrato $f1
	env $0 $00
	vol $6
	note $21 $0a
	note $24 $0a
	note $28 $0a
	note $27 $0a
	note $2c $a0
	vibrato $01
	env $0 $00
	vol $3
	note $2c $28
	vibrato $f1
	env $0 $00
	vol $6
	note $2f $14
	note $2b $0a
	wait1 $05
	vol $3
	note $2b $05
	vol $6
	note $27 $0a
	wait1 $05
	vol $3
	note $27 $05
	vol $6
	note $21 $0a
	wait1 $05
	vol $3
	note $21 $05
	wait1 $af
	vibrato $00
	env $0 $03
	note $32 $0a
	note $3e $0a
	note $32 $0a
	wait1 $0a
	vol $3
	note $32 $0a
	note $3e $0a
	note $32 $0a
	wait1 $0a
	vol $2
	note $32 $0a
	note $3e $0a
	note $32 $0a
	wait1 $0a
	vol $1
	note $32 $0a
	note $3e $0a
	note $32 $05
	vibrato $f1
	env $0 $00
	goto musicf0f4a
	cmdff
; $f10cb
; @addr{f10cb}
sound19Channel4:
	cmdf2
musicf10cc:
	duty $0e
	note $0e $0a
	wait1 $0a
	note $0e $0a
	wait1 $6e
	note $0d $05
	wait1 $05
	note $0d $05
	wait1 $05
	note $0e $0a
	wait1 $0a
	note $0e $0a
	wait1 $6e
	note $0e $0a
	wait1 $0a
	note $0d $0b
	wait1 $09
	note $0d $0d
	wait1 $6b
	vol $b
	note $0d $05
	wait1 $05
	note $0d $05
	wait1 $05
	vol $b
	note $0d $0d
	wait1 $07
	note $0d $0d
	wait1 $6b
	note $0d $0a
	wait1 $0a
	note $0e $0a
	wait1 $0a
	note $0e $0a
	wait1 $6e
	note $0d $05
	wait1 $05
	note $0d $05
	wait1 $05
	note $0e $0a
	wait1 $0a
	note $0e $0a
	wait1 $6e
	note $0e $0a
	wait1 $0a
	note $0d $0b
	wait1 $09
	note $0e $0d
	wait1 $7f
	note $0e $0d
	wait1 $07
	note $0e $0d
	wait1 $6b
	note $0c $05
	wait1 $05
	note $0c $05
	wait1 $05
	duty $0e
	note $0e $0a
	duty $0f
	note $0e $05
	wait1 $05
	duty $0e
	note $0e $0a
	duty $0f
	note $0e $05
	wait1 $2d
	duty $0e
	note $0e $0a
	duty $0f
	note $0e $05
	wait1 $05
	duty $0e
	note $0e $0a
	duty $0f
	note $0e $05
	wait1 $19
	duty $0e
	note $09 $0a
	duty $0f
	note $0e $05
	wait1 $05
	duty $0e
	note $0e $0a
	duty $0f
	note $0e $05
	wait1 $05
	duty $0e
	note $0e $0a
	duty $0f
	note $0e $05
	wait1 $2d
	duty $0e
	note $0e $0a
	duty $0f
	note $0e $05
	wait1 $05
	duty $0e
	note $0e $0a
	duty $0f
	note $0e $05
	wait1 $19
	duty $0e
	note $09 $0a
	duty $0f
	note $0e $05
	wait1 $05
	duty $0e
	note $0e $0a
	duty $0f
	note $0e $05
	wait1 $05
	duty $0e
	note $0e $0a
	duty $0f
	note $0e $05
	wait1 $2d
	duty $0e
	note $0e $0a
	duty $0f
	note $0e $05
	wait1 $05
	duty $0e
	note $0e $0a
	duty $0f
	note $0e $05
	wait1 $19
	duty $0e
	note $0c $0a
	note $0d $0a
	duty $0e
	note $0e $0a
	duty $0f
	note $0e $05
	wait1 $05
	duty $0e
	note $0e $0a
	duty $0f
	note $0e $05
	wait1 $2d
	duty $0e
	note $0e $0a
	duty $0f
	note $0e $05
	wait1 $05
	duty $0e
	note $0e $0a
	duty $0f
	note $0e $05
	wait1 $19
	duty $0e
	note $09 $0a
	duty $0f
	note $0e $05
	wait1 $05
	duty $0e
	note $0e $0a
	duty $0f
	note $0e $05
	wait1 $05
	duty $0e
	note $0e $0a
	duty $0f
	note $0e $05
	wait1 $2d
	duty $0e
	note $0e $0a
	duty $0f
	note $0e $05
	wait1 $05
	duty $0e
	note $0e $0a
	duty $0f
	note $0e $05
	wait1 $19
	duty $0e
	note $09 $05
	duty $0f
	note $09 $05
	duty $0e
	note $09 $05
	duty $0f
	note $09 $05
	duty $0e
	note $0e $0a
	duty $0f
	note $0e $05
	wait1 $05
	duty $0e
	note $0e $0a
	duty $0f
	note $0e $05
	wait1 $2d
	duty $0e
	note $0e $0a
	duty $0f
	note $0e $05
	wait1 $05
	duty $0e
	note $0e $0a
	duty $0f
	note $0e $05
	wait1 $2d
	duty $0e
	note $0e $0a
	duty $0f
	note $0e $05
	wait1 $05
	duty $0e
	note $0e $0a
	duty $0f
	note $0e $05
	wait1 $2d
	duty $0e
	note $0e $0a
	duty $0f
	note $0e $05
	wait1 $05
	duty $0e
	note $0e $0a
	duty $0f
	note $0e $05
	wait1 $19
	duty $0e
	note $09 $0a
	duty $0f
	note $09 $05
	wait1 $05
	duty $0e
	note $0e $0a
	duty $0f
	note $0e $05
	wait1 $05
	duty $0e
	note $0e $0a
	duty $0f
	note $0e $05
	wait1 $2d
	duty $0e
	note $0e $0a
	duty $0f
	note $0e $05
	wait1 $05
	duty $0e
	note $0e $0a
	duty $0f
	note $0e $05
	wait1 $19
	duty $0e
	note $0c $0a
	note $0d $0a
	goto musicf10cc
	cmdff
; $f12c4
; @addr{f12c4}
sound19Channel6:
	cmdf2
musicf12c5:
	vol $4
	note $2a $14
	note $2a $28
	wait1 $50
	note $2a $14
	note $2a $14
	note $2a $28
	wait1 $50
	note $2a $14
	note $2a $14
	note $2a $28
	wait1 $50
	note $2a $14
	note $2a $14
	note $2a $28
	wait1 $50
	note $2a $14
	note $2a $14
	note $2a $28
	wait1 $50
	note $2a $14
	note $2a $14
	note $2a $28
	wait1 $50
	note $2a $14
	note $2a $14
	note $2a $28
	wait1 $50
	note $2a $14
	note $2a $14
	note $2a $28
	wait1 $64
	note $2a $0a
	note $2a $0a
	note $2a $0a
	note $2a $0a
	note $2a $0a
	note $2a $0a
	note $2a $0a
	note $2a $0a
	note $2a $0a
	note $2a $0a
	note $2a $0a
	note $2a $0a
	note $2a $0a
	note $2a $0a
	note $2a $0a
	note $2a $0a
	note $2a $0a
	note $2a $0a
	note $2a $0a
	note $2a $0a
	note $2a $0a
	note $2a $0a
	note $2a $0a
	note $2a $0a
	note $2a $0a
	note $2a $0a
	note $2a $0a
	note $2a $0a
	note $2a $0a
	note $2a $0a
	note $2a $0a
	note $2a $0a
	note $2a $0a
	note $2a $0a
	note $2a $0a
	note $2a $0a
	note $2a $0a
	note $2a $0a
	note $2a $0a
	note $2a $0a
	note $2a $0a
	note $2a $0a
	note $2a $0a
	note $2a $0a
	note $2a $0a
	note $2a $0a
	note $2a $0a
	note $2a $0a
	note $2a $0a
	note $2a $0a
	note $2a $0a
	note $2a $0a
	note $2a $0a
	note $2a $0a
	note $2a $0a
	note $2a $0a
	note $2a $0a
	note $2a $0a
	note $2a $0a
	note $2a $0a
	note $2a $0a
	note $2a $0a
	note $2a $0a
	note $2a $0a
	note $2a $0a
	note $2a $0a
	note $2a $0a
	note $2a $0a
	note $2a $0a
	note $2a $0a
	note $2a $0a
	note $2a $0a
	note $2a $0a
	note $2a $0a
	note $2a $0a
	note $2a $0a
	note $2a $0a
	note $2a $0a
	note $2a $0a
	note $2a $0a
	note $2a $0a
	note $2a $0a
	note $2a $0a
	note $2a $0a
	note $2a $0a
	note $2a $0a
	note $2a $0a
	note $2a $0a
	note $2a $0a
	note $2a $0a
	note $2a $0a
	note $2a $0a
	note $2a $0a
	note $2a $0a
	note $2a $0a
	note $2a $0a
	note $2a $0a
	note $2a $0a
	note $2a $0a
	note $2a $0a
	note $2a $0a
	note $2a $0a
	note $2a $0a
	note $2a $0a
	note $2a $0a
	note $2a $0a
	note $2a $0a
	note $2a $0a
	note $2a $0a
	note $2a $0a
	note $2a $0a
	note $2a $0a
	note $2a $0a
	note $2a $0a
	note $2a $0a
	note $2a $0a
	note $2a $0a
	note $2a $0a
	note $2a $0a
	note $2a $0a
	note $2a $0a
	note $2a $0a
	note $2a $0a
	note $2a $0a
	note $2a $0a
	note $2a $0a
	note $2a $0a
	note $2a $0a
	goto musicf12c5
	cmdff
; $f1408
sound17Start:
; @addr{f1408}
sound17Channel1:
	vibrato $e1
	env $0 $00
	cmdf2
	duty $02
	vol $6
	note $1e $07
	wait1 $03
	vol $3
	note $1e $04
	vol $6
	note $1e $03
	vol $3
	note $1e $04
	vol $6
	note $1e $03
	vol $3
	note $1e $04
musicf1423:
	vol $6
	note $25 $38
	note $24 $07
	wait1 $03
	vol $3
	note $24 $07
	wait1 $0b
	vol $6
	note $21 $0b
	wait1 $06
	vol $3
	note $21 $04
	vol $6
	note $1e $07
	note $28 $38
	note $27 $07
	wait1 $03
	vol $3
	note $27 $07
	wait1 $0b
	vol $6
	note $1e $07
	wait1 $03
	vol $3
	note $1e $04
	vol $6
	note $1e $03
	wait1 $01
	vol $3
	note $1e $03
	vol $6
	note $1e $03
	wait1 $01
	vol $3
	note $1e $03
	vol $6
	note $25 $38
	note $24 $07
	wait1 $07
	vol $3
	note $24 $07
	wait1 $07
	vol $6
	note $21 $0b
	wait1 $06
	vol $3
	note $21 $04
	vol $6
	note $1e $07
	note $1c $2e
	note $1e $05
	note $1c $05
	note $1b $07
	wait1 $03
	vol $3
	note $1b $07
	wait1 $0b
	vol $6
	note $25 $07
	wait1 $03
	vol $3
	note $25 $04
	vol $6
	note $25 $03
	wait1 $01
	vol $3
	note $25 $03
	vol $6
	note $25 $03
	wait1 $01
	vol $3
	note $25 $03
	vol $6
	note $2c $38
	note $2d $07
	wait1 $03
	vol $3
	note $2d $07
	wait1 $0b
	vol $6
	note $31 $07
	wait1 $03
	vol $3
	note $31 $07
	wait1 $04
	vol $6
	note $38 $07
	note $35 $1c
	note $2d $03
	wait1 $01
	vol $3
	note $2d $03
	vol $6
	note $2d $03
	wait1 $01
	vol $3
	note $2d $03
	vol $6
	note $2d $03
	wait1 $01
	vol $3
	note $2d $03
	vol $6
	note $2d $03
	wait1 $01
	vol $3
	note $2d $03
	vol $6
	note $27 $11
	vol $3
	note $27 $0b
	vol $6
	note $21 $07
	wait1 $03
	vol $3
	note $21 $04
	vol $6
	note $21 $07
	note $1e $07
	note $25 $38
	note $24 $07
	wait1 $03
	vol $3
	note $24 $07
	wait1 $0b
	vol $6
	note $21 $07
	wait1 $03
	vol $3
	note $21 $07
	wait1 $04
	vol $6
	note $2c $07
	note $27 $1c
	note $21 $03
	wait1 $01
	vol $3
	note $21 $03
	vol $6
	note $21 $03
	wait1 $01
	vol $3
	note $21 $03
	vol $6
	note $21 $03
	wait1 $01
	vol $3
	note $21 $03
	vol $6
	note $21 $03
	wait1 $01
	vol $3
	note $21 $03
	vol $6
	note $1b $0e
	vol $3
	note $1b $0e
	wait1 $1c
	vol $6
	note $24 $0e
	vol $5
	note $23 $07
	wait1 $03
	vol $2
	note $23 $04
	vol $6
	note $24 $0e
	vol $5
	note $23 $07
	wait1 $03
	vol $2
	note $23 $07
	wait1 $35
	vol $6
	note $26 $0e
	vol $5
	note $25 $07
	wait1 $03
	vol $2
	note $25 $04
	vol $6
	note $26 $0e
	vol $5
	note $25 $07
	wait1 $03
	vol $2
	note $25 $07
	wait1 $35
	vol $7
	note $28 $0e
	vol $6
	note $27 $07
	wait1 $03
	vol $2
	note $27 $04
	vol $6
	note $2b $07
	wait1 $03
	vol $3
	note $2b $04
	vol $6
	note $2a $07
	wait1 $03
	vol $3
	note $2a $04
	vol $6
	note $29 $07
	wait1 $03
	vol $3
	note $29 $04
	vol $5
	note $28 $07
	wait1 $03
	vol $2
	note $28 $04
	vol $5
	note $27 $07
	wait1 $03
	vol $2
	note $27 $04
	vol $5
	note $28 $07
	wait1 $03
	vol $2
	note $28 $04
	vol $5
	note $29 $07
	wait1 $03
	vol $2
	note $29 $04
	vol $5
	note $2a $07
	wait1 $03
	vol $2
	note $2a $04
	vol $5
	note $2b $07
	wait1 $03
	vol $2
	note $2b $04
	vol $6
	note $2c $07
	wait1 $03
	vol $2
	note $2c $04
	vol $6
	note $2d $07
	wait1 $03
	vol $3
	note $2d $04
	vol $6
	note $2e $07
	wait1 $03
	vol $3
	note $2e $04
	vol $6
	note $2f $07
	wait1 $03
	vol $3
	note $2f $04
	vol $6
	note $30 $07
	wait1 $03
	vol $3
	note $30 $04
	wait1 $1c
	vol $6
	note $2a $0e
	vol $6
	note $29 $07
	wait1 $03
	vol $3
	note $29 $04
	vol $6
	note $2d $0e
	vol $6
	note $2c $07
	wait1 $03
	vol $3
	note $2c $07
	wait1 $0b
	vol $6
	note $2a $07
	wait1 $03
	vol $3
	note $2a $04
	vol $6
	note $2a $0e
	vol $5
	note $29 $07
	wait1 $03
	vol $2
	note $29 $04
	vol $6
	note $2d $0e
	vol $5
	note $2c $07
	wait1 $03
	vol $2
	note $2c $04
	vol $6
	note $2b $0e
	vol $6
	note $2a $07
	wait1 $03
	vol $3
	note $2a $07
	wait1 $0b
	vol $6
	note $2d $07
	wait1 $03
	vol $3
	note $2d $04
	vol $6
	note $2d $0e
	vol $6
	note $2c $07
	wait1 $03
	vol $3
	note $2c $04
	vol $6
	note $32 $0e
	vol $6
	note $31 $07
	wait1 $03
	vol $3
	note $31 $04
	vol $6
	note $30 $07
	wait1 $03
	vol $3
	note $30 $04
	vol $6
	note $2f $07
	wait1 $03
	vol $3
	note $2f $04
	vol $6
	note $2e $07
	wait1 $03
	vol $3
	note $2e $04
	vol $5
	note $2d $07
	wait1 $03
	vol $2
	note $2d $04
	vol $5
	note $2c $07
	wait1 $03
	vol $2
	note $2c $04
	vol $5
	note $2b $07
	wait1 $03
	vol $2
	note $2b $04
	vol $5
	note $2a $07
	wait1 $03
	vol $2
	note $2a $04
	vol $6
	note $29 $07
	wait1 $03
	vol $2
	note $29 $04
	vol $6
	note $28 $07
	wait1 $03
	vol $3
	note $28 $04
	wait1 $0e
	vol $6
	note $1e $07
	wait1 $03
	vol $3
	note $1e $04
	vol $6
	note $1e $03
	wait1 $01
	vol $3
	note $1e $03
	vol $6
	note $1e $03
	wait1 $01
	vol $3
	note $1e $03
	goto musicf1423
	cmdff
; $f169d
; @addr{f169d}
sound17Channel0:
	vol $0
	note $20 $1c
	vibrato $00
	env $0 $00
	cmdf2
	duty $02
musicf16a7:
	wait1 $1c
	vol $6
	note $1e $11
	wait1 $04
	note $1e $03
	wait1 $04
	note $1d $07
	wait1 $03
	vol $3
	note $1d $04
	vol $6
	note $1d $07
	wait1 $03
	vol $3
	note $1d $04
	wait1 $2a
	vol $6
	note $1c $07
	wait1 $07
	note $1c $03
	wait1 $01
	vol $3
	note $1c $03
	vol $6
	note $1c $03
	wait1 $01
	vol $3
	note $1c $03
	vol $6
	note $1c $03
	wait1 $01
	vol $3
	note $1c $03
	vol $6
	note $1c $03
	wait1 $01
	vol $3
	note $1c $03
	vol $6
	note $1d $07
	wait1 $03
	vol $3
	note $1d $04
	vol $6
	note $1d $07
	wait1 $03
	vol $3
	note $1d $04
	wait1 $38
	vol $6
	note $1e $11
	wait1 $04
	note $1e $03
	wait1 $04
	note $1d $07
	wait1 $03
	vol $3
	note $1d $04
	vol $6
	note $1d $07
	wait1 $03
	vol $3
	note $1d $04
	wait1 $2a
	vol $6
	note $1c $07
	wait1 $03
	vol $3
	note $1c $04
	vol $6
	note $1c $03
	wait1 $01
	vol $3
	note $1c $03
	vol $6
	note $1c $03
	wait1 $01
	vol $3
	note $1c $03
	vol $6
	note $1c $03
	wait1 $01
	vol $3
	note $1c $03
	vol $6
	note $1c $03
	wait1 $01
	vol $3
	note $1c $03
	vol $6
	note $1d $07
	wait1 $03
	vol $3
	note $1d $04
	vol $6
	note $1d $07
	wait1 $03
	vol $3
	note $1d $04
	wait1 $38
	vol $6
	note $19 $11
	wait1 $04
	note $19 $03
	wait1 $04
	note $18 $07
	wait1 $03
	vol $3
	note $18 $04
	vol $6
	note $18 $07
	wait1 $03
	vol $3
	note $18 $04
	wait1 $2a
	vol $6
	note $17 $07
	wait1 $03
	vol $3
	note $17 $04
	vol $6
	note $17 $03
	wait1 $01
	vol $3
	note $17 $03
	vol $6
	note $17 $03
	wait1 $01
	vol $3
	note $17 $03
	vol $6
	note $17 $03
	wait1 $01
	vol $3
	note $17 $03
	vol $6
	note $17 $03
	wait1 $01
	vol $3
	note $17 $03
	vol $6
	note $18 $07
	wait1 $03
	vol $3
	note $18 $04
	vol $6
	note $18 $07
	wait1 $03
	vol $3
	note $18 $04
	wait1 $38
	vol $6
	note $19 $11
	wait1 $04
	note $19 $03
	wait1 $04
	note $18 $07
	wait1 $03
	vol $3
	note $18 $04
	vol $6
	note $18 $07
	wait1 $03
	vol $3
	note $18 $04
	wait1 $2a
	vol $6
	note $17 $07
	wait1 $03
	vol $3
	note $17 $04
	vol $6
	note $17 $03
	wait1 $01
	vol $3
	note $17 $03
	vol $6
	note $17 $03
	wait1 $01
	vol $3
	note $17 $03
	vol $6
	note $17 $03
	wait1 $01
	vol $3
	note $17 $03
	vol $6
	note $17 $03
	wait1 $01
	vol $3
	note $17 $03
	vol $6
	note $18 $07
	wait1 $03
	vol $3
	note $18 $04
	vol $6
	note $18 $07
	wait1 $03
	vol $3
	note $18 $04
	wait1 $1c
	vol $6
	note $21 $0e
	vol $6
	note $20 $07
	wait1 $03
	vol $3
	note $20 $04
	vol $6
	note $21 $0e
	vol $6
	note $20 $07
	wait1 $03
	vol $3
	note $20 $07
	wait1 $35
	vol $6
	note $23 $0e
	vol $5
	note $22 $07
	wait1 $03
	vol $2
	note $22 $04
	vol $6
	note $23 $0e
	vol $5
	note $22 $07
	wait1 $03
	vol $2
	note $22 $07
	wait1 $35
	vol $6
	note $24 $0e
	vol $6
	note $23 $07
	wait1 $03
	vol $2
	note $23 $04
	vol $6
	note $28 $07
	wait1 $03
	vol $3
	note $28 $04
	vol $6
	note $27 $07
	wait1 $03
	vol $3
	note $27 $04
	vol $5
	note $26 $07
	wait1 $03
	vol $2
	note $26 $04
	vol $5
	note $25 $07
	wait1 $03
	vol $2
	note $25 $04
	vol $5
	note $24 $07
	wait1 $03
	vol $2
	note $24 $04
	vol $5
	note $25 $07
	wait1 $03
	vol $2
	note $25 $04
	vol $5
	note $26 $07
	wait1 $03
	vol $2
	note $26 $04
	vol $5
	note $27 $07
	wait1 $03
	vol $2
	note $27 $04
	vol $6
	note $28 $07
	wait1 $03
	vol $2
	note $28 $04
	vol $6
	note $29 $07
	wait1 $03
	vol $3
	note $29 $04
	vol $6
	note $2a $07
	wait1 $03
	vol $3
	note $2a $04
	vol $6
	note $2b $07
	wait1 $03
	vol $3
	note $2b $04
	vol $6
	note $2c $07
	wait1 $03
	vol $3
	note $2c $04
	vol $7
	note $2d $07
	wait1 $03
	vol $3
	note $2d $04
	wait1 $1c
	vol $6
	note $26 $0e
	vol $5
	note $25 $07
	wait1 $03
	vol $2
	note $25 $04
	vol $6
	note $2a $0e
	vol $5
	note $29 $07
	wait1 $03
	vol $2
	note $29 $07
	wait1 $0b
	vol $6
	note $26 $07
	wait1 $03
	vol $3
	note $26 $04
	vol $6
	note $26 $0e
	vol $5
	note $25 $07
	wait1 $03
	vol $2
	note $25 $04
	vol $6
	note $2a $0e
	vol $5
	note $29 $07
	wait1 $03
	vol $2
	note $29 $04
	vol $6
	note $28 $0e
	vol $6
	note $27 $07
	wait1 $03
	vol $3
	note $27 $07
	wait1 $35
	vol $6
	note $29 $0e
	vol $6
	note $28 $07
	wait1 $03
	vol $3
	note $28 $04
	vol $6
	note $27 $07
	wait1 $03
	vol $3
	note $27 $04
	vol $6
	note $26 $07
	wait1 $03
	vol $3
	note $26 $04
	vol $6
	note $25 $07
	wait1 $03
	vol $3
	note $25 $04
	vol $6
	note $24 $07
	wait1 $03
	vol $3
	note $24 $04
	vol $6
	note $23 $07
	wait1 $03
	vol $3
	note $23 $04
	vol $6
	note $22 $07
	wait1 $03
	vol $2
	note $22 $04
	vol $5
	note $21 $07
	wait1 $03
	vol $2
	note $21 $04
	vol $6
	note $20 $07
	wait1 $03
	vol $3
	note $20 $04
	vol $6
	note $1f $07
	wait1 $03
	vol $3
	note $1f $04
	wait1 $2a
	goto musicf16a7
	cmdff
; $f193e
; @addr{f193e}
sound17Channel4:
	wait1 $1c
	cmdf2
musicf1941:
	duty $0e
	note $12 $0e
	duty $0c
	note $12 $0e
	duty $0e
	note $12 $0e
	duty $0c
	note $12 $07
	duty $0e
	note $12 $03
	duty $0c
	note $12 $04
	duty $0e
	note $12 $03
	duty $0c
	note $12 $0b
	duty $0e
	note $12 $03
	duty $0c
	note $12 $07
	wait1 $20
	duty $0e
	note $12 $07
	duty $0c
	note $12 $07
	duty $0e
	note $12 $07
	duty $0c
	note $12 $07
	duty $0e
	note $12 $03
	duty $0c
	note $12 $04
	duty $0e
	note $12 $03
	duty $0c
	note $12 $04
	duty $0e
	note $12 $03
	duty $0c
	note $12 $04
	duty $0e
	note $12 $03
	duty $0c
	note $12 $04
	duty $0e
	note $12 $07
	duty $0c
	note $12 $07
	duty $0e
	note $12 $07
	duty $0c
	note $12 $07
	wait1 $1c
	duty $0e
	note $12 $0e
	duty $0c
	note $12 $0e
	duty $0e
	note $12 $0e
	duty $0c
	note $12 $07
	duty $0e
	note $12 $03
	duty $0c
	note $12 $04
	duty $0e
	note $12 $03
	duty $0c
	note $12 $0b
	duty $0e
	note $12 $03
	duty $0c
	note $12 $07
	wait1 $20
	duty $0e
	note $12 $07
	duty $0c
	note $12 $07
	duty $0e
	note $12 $07
	duty $0c
	note $12 $07
	duty $0e
	note $12 $03
	duty $0c
	note $12 $04
	duty $0e
	note $12 $03
	duty $0c
	note $12 $04
	duty $0e
	note $12 $03
	duty $0c
	note $12 $04
	duty $0e
	note $12 $03
	duty $0c
	note $12 $04
	duty $0e
	note $12 $07
	duty $0c
	note $12 $07
	duty $0e
	note $12 $07
	duty $0c
	note $12 $07
	wait1 $1c
	duty $0e
	note $12 $0e
	duty $0c
	note $12 $0e
	duty $0e
	note $12 $0e
	duty $0c
	note $12 $07
	duty $0e
	note $12 $03
	duty $0c
	note $12 $04
	duty $0e
	note $12 $03
	duty $0c
	note $12 $0b
	duty $0e
	note $12 $03
	duty $0c
	note $12 $07
	wait1 $20
	duty $0e
	note $12 $07
	duty $0c
	note $12 $07
	duty $0e
	note $12 $07
	duty $0c
	note $12 $07
	duty $0e
	note $12 $03
	duty $0c
	note $12 $04
	duty $0e
	note $12 $03
	duty $0c
	note $12 $04
	duty $0e
	note $12 $03
	duty $0c
	note $12 $04
	duty $0e
	note $12 $03
	duty $0c
	note $12 $04
	duty $0e
	note $12 $07
	duty $0c
	note $12 $07
	duty $0e
	note $12 $07
	duty $0c
	note $12 $07
	wait1 $1c
	duty $0e
	note $12 $0e
	duty $0c
	note $12 $0e
	duty $0e
	note $12 $0e
	duty $0c
	note $12 $07
	duty $0e
	note $12 $03
	duty $0c
	note $12 $04
	duty $0e
	note $12 $03
	duty $0c
	note $12 $0b
	duty $0e
	note $12 $03
	duty $0c
	note $12 $07
	wait1 $20
	duty $0e
	note $12 $07
	duty $0c
	note $12 $07
	duty $0e
	note $12 $07
	duty $0c
	note $12 $07
	duty $0e
	note $12 $03
	duty $0c
	note $12 $04
	duty $0e
	note $12 $03
	duty $0c
	note $12 $04
	duty $0e
	note $12 $03
	duty $0c
	note $12 $04
	duty $0e
	note $12 $03
	duty $0c
	note $12 $04
	duty $0e
	note $12 $07
	duty $0c
	note $12 $07
	duty $0e
	note $12 $07
	duty $0c
	note $12 $07
	wait1 $62
	duty $0e
	note $12 $07
	duty $0c
	note $12 $07
	duty $0e
	note $12 $03
	duty $0c
	note $12 $04
	duty $0e
	note $12 $03
	duty $0c
	note $12 $04
	duty $0e
	note $12 $03
	duty $0c
	note $12 $07
	wait1 $2e
	duty $0e
	note $12 $07
	duty $0c
	note $12 $07
	wait1 $0e
	duty $0e
	note $12 $07
	duty $0c
	note $12 $07
	duty $0e
	note $12 $03
	duty $0c
	note $12 $04
	duty $0e
	note $12 $03
	duty $0c
	note $12 $04
	duty $0e
	note $12 $03
	duty $0c
	note $12 $07
	wait1 $20
	duty $0e
	note $1c $07
	duty $0c
	note $1c $07
	duty $0e
	note $1b $07
	duty $0c
	note $1b $07
	duty $0e
	note $1a $07
	duty $0c
	note $1a $07
	duty $0e
	note $19 $07
	duty $0c
	note $19 $07
	duty $0e
	note $18 $07
	duty $0c
	note $18 $07
	duty $0e
	note $19 $07
	duty $0c
	note $19 $07
	duty $0e
	note $1a $07
	duty $0c
	note $1a $07
	duty $0e
	note $1b $07
	duty $0c
	note $1b $07
	duty $0e
	note $1c $07
	duty $0c
	note $1c $07
	duty $0e
	note $1d $07
	duty $0c
	note $1d $07
	duty $0e
	note $1e $07
	duty $0c
	note $1e $07
	duty $0e
	note $1f $07
	duty $0c
	note $1f $07
	duty $0e
	note $20 $07
	duty $0c
	note $20 $07
	duty $0e
	note $21 $07
	duty $0c
	note $21 $07
	duty $0e
	note $0b $03
	duty $0c
	note $0b $04
	duty $0e
	note $0b $03
	duty $0c
	note $0b $04
	duty $0e
	note $0b $03
	duty $0c
	note $0b $07
	wait1 $3c
	duty $0e
	note $17 $03
	duty $0c
	note $17 $0b
	duty $0e
	note $0b $03
	duty $0c
	note $0b $0b
	duty $0e
	note $0b $03
	duty $0c
	note $0b $04
	duty $0e
	note $0b $03
	duty $0c
	note $0b $04
	duty $0e
	note $0b $03
	duty $0c
	note $0b $04
	wait1 $31
	duty $0e
	note $17 $03
	duty $0c
	note $17 $07
	wait1 $12
	duty $0e
	note $0b $03
	duty $0c
	note $0b $0b
	duty $0e
	note $0b $03
	duty $0c
	note $0b $04
	duty $0e
	note $0b $03
	duty $0c
	note $0b $04
	duty $0e
	note $0b $03
	duty $0c
	note $0b $0b
	wait1 $62
	duty $0e
	note $0d $07
	duty $0c
	note $0d $15
	duty $0e
	note $0d $07
	duty $0c
	note $0d $07
	duty $0e
	note $0d $03
	duty $0c
	note $0d $04
	duty $0e
	note $0d $03
	duty $0c
	note $0d $04
	duty $0e
	note $0d $03
	duty $0c
	note $0d $04
	duty $0e
	note $0d $03
	duty $0c
	note $0d $07
	wait1 $19
	goto musicf1941
	cmdff
; $f1c55
; @addr{f1c55}
sound17Channel6:
	wait1 $1c
	cmdf2
musicf1c58:
	vol $5
	note $26 $1c
	vol $4
	note $24 $0e
	vol $3
	note $26 $07
	vol $4
	note $26 $07
	vol $4
	note $26 $07
	vol $5
	note $26 $07
	vol $5
	note $26 $0e
	vol $4
	note $24 $1c
	note $24 $0e
	note $26 $0e
	vol $2
	note $26 $07
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
	vol $4
	note $26 $1c
	note $24 $0e
	vol $5
	note $26 $1c
	vol $4
	note $24 $0e
	vol $3
	note $26 $07
	vol $4
	note $26 $07
	vol $4
	note $26 $07
	vol $5
	note $26 $07
	vol $5
	note $26 $0e
	vol $4
	note $24 $1c
	note $24 $0e
	note $26 $0e
	vol $2
	note $26 $07
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
	vol $4
	note $26 $1c
	note $24 $0e
	vol $5
	note $26 $1c
	vol $4
	note $24 $0e
	vol $3
	note $26 $07
	vol $4
	note $26 $07
	vol $4
	note $26 $07
	vol $5
	note $26 $07
	vol $5
	note $26 $0e
	vol $4
	note $24 $1c
	note $24 $0e
	note $26 $0e
	vol $2
	note $26 $07
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
	vol $4
	note $26 $1c
	note $24 $0e
	note $24 $0e
	note $26 $0e
	vol $2
	note $26 $07
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
	vol $4
	note $26 $1c
	note $24 $0e
	note $24 $0e
	note $26 $0e
	vol $2
	note $26 $07
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
	vol $4
	note $26 $2a
	wait1 $46
	note $26 $0e
	vol $3
	note $26 $07
	vol $3
	note $26 $07
	vol $4
	note $26 $07
	vol $4
	note $26 $07
	wait1 $2a
	vol $4
	note $26 $1c
	note $26 $0e
	vol $3
	note $26 $07
	vol $4
	note $26 $07
	vol $4
	note $26 $07
	vol $4
	note $26 $07
	wait1 $1c
	vol $4
	note $2a $0e
	note $2a $0e
	note $2a $0e
	note $2a $0e
	note $2a $0e
	note $2a $0e
	note $2a $0e
	note $2a $0e
	note $2a $0e
	note $2a $0e
	note $2a $0e
	note $2a $0e
	note $2a $0e
	note $2a $0e
	note $26 $2a
	note $26 $1c
	note $26 $0e
	vol $4
	note $26 $07
	vol $4
	note $26 $07
	note $26 $0e
	vol $4
	note $26 $07
	vol $4
	note $26 $07
	vol $4
	note $26 $1c
	vol $4
	note $26 $1c
	note $26 $0e
	vol $3
	note $26 $07
	vol $4
	note $26 $07
	vol $4
	note $26 $0e
	vol $3
	note $26 $07
	vol $4
	note $26 $07
	vol $4
	note $26 $0e
	vol $2
	note $2a $0e
	note $2a $0e
	note $2a $0e
	vol $2
	note $2a $0e
	note $2a $0e
	note $2a $0e
	note $2a $0e
	vol $4
	note $26 $0e
	vol $2
	note $2a $0e
	vol $4
	note $26 $0e
	note $26 $07
	note $26 $07
	note $26 $07
	note $26 $23
	goto musicf1c58
	cmdff
; $f1dba
; @addr{f1dba}
sound15Channel1:
	vibrato $f1
	env $0 $00
	cmdf2
	duty $02
musicf1dc1:
	vol $7
	note $28 $24
	note $2f $24
	note $28 $24
	note $27 $24
	note $2e $0d
	wait1 $01
	vol $3
	note $2e $05
	wait1 $01
	vol $2
	note $2e $04
	wait1 $03
	vol $1
	note $2e $04
	wait1 $29
	vol $7
	note $17 $03
	note $26 $03
	note $35 $03
	wait1 $04
	vol $3
	note $17 $03
	note $26 $03
	note $35 $03
	wait1 $05
	vol $1
	note $17 $03
	note $26 $03
	note $35 $03
	vol $7
	note $14 $03
	note $23 $03
	note $32 $03
	wait1 $04
	vol $3
	note $14 $03
	note $23 $03
	note $32 $03
	wait1 $05
	vol $1
	note $14 $03
	note $23 $03
	note $32 $03
	wait1 $48
	vol $7
	note $28 $24
	note $2f $24
	note $34 $24
	note $33 $24
	note $3a $06
	wait1 $03
	vol $3
	note $3a $03
	wait1 $06
	vol $2
	note $3a $03
	wait1 $03
	vol $1
	note $3a $03
	wait1 $03
	vol $1
	note $3a $03
	wait1 $4b
	vol $7
	note $17 $03
	note $26 $03
	note $35 $03
	wait1 $04
	vol $3
	note $17 $03
	note $26 $03
	note $35 $03
	wait1 $05
	vol $1
	note $17 $03
	note $26 $03
	note $35 $03
	vol $7
	note $14 $03
	note $23 $03
	note $32 $03
	wait1 $04
	vol $3
	note $14 $03
	note $23 $03
	note $32 $03
	wait1 $05
	vol $1
	note $14 $03
	note $23 $03
	note $32 $03
	wait1 $24
	vol $7
	note $08 $03
	note $17 $03
	note $26 $03
	wait1 $04
	vol $3
	note $08 $03
	note $17 $03
	note $26 $03
	wait1 $05
	vol $1
	note $08 $03
	note $17 $03
	note $26 $03
	vol $7
	note $05 $03
	note $14 $03
	note $23 $03
	wait1 $04
	vol $3
	note $05 $03
	note $14 $03
	note $23 $03
	wait1 $05
	vol $1
	note $05 $03
	note $14 $03
	note $23 $03
	wait1 $24
	vol $7
	note $16 $03
	note $25 $03
	note $34 $03
	wait1 $04
	vol $3
	note $16 $03
	note $25 $03
	note $34 $03
	wait1 $05
	vol $1
	note $16 $03
	note $25 $03
	note $34 $03
	vol $7
	note $13 $03
	note $22 $03
	note $31 $03
	wait1 $04
	vol $3
	note $13 $03
	note $22 $03
	note $31 $03
	wait1 $05
	vol $1
	note $13 $03
	note $22 $03
	note $31 $03
	wait1 $24
	vol $7
	note $05 $03
	note $14 $03
	note $23 $03
	wait1 $04
	vol $3
	note $05 $03
	note $14 $03
	note $23 $03
	wait1 $05
	vol $1
	note $05 $03
	note $14 $03
	note $23 $03
	vol $7
	note $02 $03
	note $11 $03
	note $20 $03
	wait1 $04
	vol $3
	note $02 $03
	note $11 $03
	note $20 $03
	wait1 $05
	vol $1
	note $02 $03
	note $11 $03
	note $20 $03
	wait1 $48
	vol $4
	note $21 $0c
	note $1b $0c
	note $1a $0c
	note $1b $0c
	note $21 $0c
	vol $4
	note $1b $0c
	note $1a $0c
	note $1b $0c
	note $1a $0c
	note $1b $0c
	vol $2
	note $1b $0c
	vol $1
	note $1b $0c
	vol $5
	note $2c $0c
	vol $2
	note $2d $0c
	wait1 $03
	vol $1
	note $2d $0c
	wait1 $21
	vol $5
	note $23 $0c
	note $1d $0c
	note $1c $0c
	note $1d $0c
	note $23 $0c
	note $1d $0c
	note $1c $0c
	note $1d $0c
	note $1c $0c
	note $1d $0c
	wait1 $18
	note $2e $0c
	vol $3
	note $2f $0c
	wait1 $03
	vol $1
	note $2f $0c
	wait1 $21
	vol $4
	note $24 $0c
	vol $4
	note $1e $0c
	vol $5
	note $1d $0c
	vol $5
	note $1e $0c
	wait1 $06
	vol $2
	note $1e $0c
	wait1 $06
	vol $5
	note $25 $0c
	vol $5
	note $1f $0c
	vol $5
	note $1e $0c
	vol $5
	note $1f $0c
	wait1 $06
	vol $2
	note $1f $0c
	wait1 $06
	vol $5
	note $26 $0c
	vol $6
	note $20 $0c
	vol $6
	note $21 $0c
	vol $6
	note $27 $0c
	vol $7
	note $21 $0c
	vol $7
	note $22 $0c
	vol $7
	note $2a $04
	vol $5
	note $2d $05
	wait1 $09
	vol $6
	note $29 $04
	vol $5
	note $2c $05
	wait1 $09
	vol $6
	note $28 $04
	vol $4
	note $2b $05
	wait1 $09
	vol $6
	note $27 $04
	vol $4
	note $2a $05
	wait1 $09
	vol $6
	note $26 $04
	vol $4
	note $29 $05
	wait1 $09
	vol $6
	note $25 $04
	vol $4
	note $28 $05
	wait1 $09
	vol $6
	note $24 $04
	vol $4
	note $27 $05
	wait1 $09
	vol $5
	note $23 $04
	vol $4
	note $26 $05
	wait1 $0f
	vol $5
	note $22 $04
	vol $4
	note $25 $04
	wait1 $07
	vol $3
	note $25 $03
	wait1 $36
	vol $6
	note $21 $06
	wait1 $03
	vol $2
	note $24 $06
	wait1 $03
	vol $1
	note $24 $06
	wait1 $2e
	vol $5
	note $20 $09
	wait1 $01
	vol $2
	note $23 $07
	wait1 $03
	vol $1
	note $23 $06
	wait1 $4e
	goto musicf1dc1
	cmdff
; $f1ff5
; @addr{f1ff5}
sound15Channel0:
	vibrato $00
	env $0 $00
	cmdf2
	duty $02
musicf1ffc:
	vol $7
	note $20 $24
	note $23 $24
	note $20 $24
	note $1f $24
	note $22 $0c
	wait1 $03
	vol $2
	note $22 $03
	wait1 $03
	vol $2
	note $22 $03
	wait1 $03
	vol $1
	note $22 $03
	wait1 $2a
	vol $4
	note $2f $09
	wait1 $03
	vol $1
	note $2f $03
	wait1 $03
	vol $1
	note $2f $03
	wait1 $03
	vol $1
	note $2f $03
	wait1 $09
	vol $5
	note $2c $04
	wait1 $01
	vol $2
	note $2c $04
	wait1 $06
	vol $1
	note $2c $03
	wait1 $06
	vol $1
	note $2c $03
	wait1 $51
	vol $7
	note $20 $24
	note $23 $24
	note $20 $24
	note $1f $24
	vol $6
	note $22 $06
	wait1 $03
	vol $2
	note $22 $03
	wait1 $03
	vol $2
	note $22 $03
	wait1 $03
	vol $1
	note $22 $03
	wait1 $03
	vol $1
	note $22 $03
	wait1 $4e
	vol $4
	note $2f $09
	wait1 $03
	vol $3
	note $2f $03
	wait1 $03
	vol $1
	note $2f $03
	wait1 $0f
	vol $4
	note $2c $09
	wait1 $03
	vol $3
	note $2c $03
	wait1 $03
	vol $1
	note $2c $03
	wait1 $33
	vol $2
	note $1d $09
	wait1 $03
	vol $4
	note $1d $03
	wait1 $03
	vol $1
	note $1d $03
	wait1 $0f
	vol $3
	note $1a $09
	wait1 $03
	vol $4
	note $1a $03
	wait1 $03
	vol $1
	note $1a $03
	wait1 $33
	vol $5
	note $2e $06
	wait1 $03
	vol $3
	note $2e $03
	wait1 $06
	vol $1
	note $2e $03
	wait1 $0f
	vol $3
	note $2b $06
	wait1 $03
	vol $5
	note $2b $03
	wait1 $06
	vol $1
	note $2b $03
	wait1 $33
	vol $3
	note $1a $09
	wait1 $03
	vol $5
	note $1a $03
	wait1 $03
	vol $2
	note $1a $03
	wait1 $0f
	vol $3
	note $17 $09
	wait1 $03
	vol $4
	note $17 $03
	wait1 $03
	vol $2
	note $17 $03
	wait1 $57
	vol $5
	note $0e $75
	wait1 $63
	vol $6
	note $0f $75
	wait1 $63
	vol $5
	note $0f $48
	vol $6
	note $10 $48
	vol $6
	note $11 $24
	vol $6
	note $12 $24
	note $21 $04
	wait1 $0e
	vol $6
	note $20 $04
	wait1 $0e
	vol $6
	note $1f $04
	wait1 $0e
	vol $6
	note $1e $04
	wait1 $0e
	vol $6
	note $1d $04
	wait1 $0e
	vol $5
	note $1c $04
	wait1 $0e
	vol $5
	note $1b $04
	wait1 $0e
	vol $5
	note $1a $04
	wait1 $14
	vol $4
	note $19 $06
	wait1 $42
	vol $4
	note $18 $04
	wait1 $42
	vol $3
	note $17 $05
	wait1 $63
	goto musicf1ffc
	cmdff
; $f212a
sound16Start:
; @addr{f212a}
sound16Channel1:
	vibrato $f1
	env $0 $00
	cmdf2
	duty $02
	vol $6
	note $21 $09
	wait1 $04
	vol $3
	note $21 $05
	vol $6
	note $21 $09
	note $24 $09
	note $21 $09
	note $24 $09
	note $2b $09
musicf2144:
	note $2a $3f
	vibrato $01
	env $0 $00
	vol $3
	note $2a $12
	vibrato $f1
	env $0 $00
	vol $6
	note $21 $09
	note $24 $09
	note $2b $09
	note $2a $09
	note $2b $04
	note $2a $05
	note $28 $09
	note $26 $09
	note $28 $3f
	vibrato $01
	env $0 $00
	vol $3
	note $28 $12
	vibrato $f1
	env $0 $00
	vol $6
	note $21 $09
	wait1 $04
	vol $3
	note $21 $05
	vol $6
	note $21 $09
	note $24 $09
	note $21 $09
	note $24 $09
	note $28 $09
	note $2b $12
	vol $3
	note $2b $09
	vol $6
	note $2a $09
	note $2b $12
	vol $3
	note $2b $09
	vol $6
	note $2a $09
	note $2b $12
	vol $3
	note $2b $09
	vol $6
	note $2a $09
	note $2b $09
	note $2a $03
	note $2b $03
	note $2a $03
	note $28 $09
	note $26 $09
	note $28 $48
	vibrato $01
	env $0 $00
	vol $1
	note $28 $09
	vibrato $f1
	env $0 $00
	vol $6
	note $24 $09
	wait1 $04
	vol $3
	note $24 $05
	vol $6
	note $24 $09
	note $28 $09
	note $24 $09
	note $28 $09
	note $2f $09
	note $2c $3f
	vibrato $01
	env $0 $00
	vol $3
	note $2c $12
	vibrato $f1
	env $0 $00
	vol $6
	note $24 $09
	wait1 $04
	vol $3
	note $24 $05
	vol $6
	note $24 $09
	note $28 $09
	note $24 $09
	note $28 $09
	note $2c $09
	note $2b $3f
	vibrato $01
	env $0 $00
	vol $3
	note $2b $12
	vibrato $f1
	env $0 $00
	vol $6
	note $24 $09
	wait1 $04
	vol $3
	note $24 $05
	vol $6
	note $24 $09
	note $28 $09
	note $24 $09
	note $28 $09
	note $2d $09
	note $2a $3f
	vibrato $01
	env $0 $00
	vol $3
	note $2a $12
	wait1 $12
	vibrato $f1
	env $0 $00
	vol $6
	note $28 $09
	note $2a $09
	note $2b $04
	note $2a $05
	note $28 $09
	note $26 $09
	note $28 $3f
	vibrato $01
	env $0 $00
	vol $3
	note $28 $12
	wait1 $3f
	vibrato $00
	env $0 $04
	vol $5
	note $2d $04
	note $30 $05
	note $2d $04
	note $30 $05
	note $2d $04
	note $30 $05
	note $2d $04
	note $30 $05
	note $2d $04
	note $30 $05
	note $2d $04
	note $30 $05
	note $2d $04
	note $30 $05
	note $2d $04
	note $30 $05
	note $2d $04
	note $30 $05
	note $2d $04
	note $30 $05
	note $2d $04
	note $30 $05
	note $2d $04
	note $30 $05
	note $2d $04
	note $30 $05
	note $2d $04
	note $30 $05
	note $2d $04
	note $30 $05
	note $2d $04
	note $30 $05
	note $2c $04
	note $30 $05
	note $2c $04
	note $30 $05
	note $2c $04
	note $30 $05
	note $2c $04
	note $30 $05
	note $2c $04
	note $30 $05
	note $2c $04
	note $30 $05
	note $2c $04
	note $30 $05
	note $2c $04
	note $30 $05
	note $2c $04
	vol $5
	note $30 $05
	note $2c $04
	note $30 $05
	note $2c $04
	note $30 $05
	note $2c $04
	note $30 $05
	note $2c $04
	note $30 $05
	note $2c $04
	note $30 $05
	note $2c $04
	note $30 $05
	note $2c $04
	note $30 $05
	note $2b $04
	note $30 $05
	note $2b $04
	note $30 $05
	note $2b $04
	note $30 $05
	note $2b $04
	note $30 $05
	note $2b $04
	note $30 $05
	note $2b $04
	note $30 $05
	note $2b $04
	note $30 $05
	note $2b $04
	note $30 $05
	note $2b $04
	note $30 $05
	note $2b $04
	note $30 $05
	note $2b $04
	note $30 $05
	note $2b $04
	note $30 $05
	note $2b $04
	note $30 $05
	note $2b $04
	note $30 $05
	note $2b $04
	note $30 $05
	note $2b $04
	note $30 $05
	vol $5
	note $2c $04
	note $30 $05
	note $2c $04
	note $30 $05
	note $2c $04
	note $30 $05
	note $2c $04
	note $30 $05
	note $2c $04
	note $30 $05
	note $2c $04
	note $30 $05
	note $2c $04
	note $30 $05
	note $2c $04
	note $30 $05
	note $2c $04
	vol $5
	note $30 $05
	note $2c $04
	note $30 $05
	note $2c $04
	note $30 $05
	note $2c $04
	note $30 $05
	note $2c $04
	note $30 $05
	note $2c $04
	note $30 $05
	note $2c $04
	note $30 $05
	note $2c $04
	note $30 $05
	vol $5
	note $2d $04
	vol $4
	note $30 $05
	note $2d $04
	note $30 $05
	note $2d $04
	note $30 $05
	note $2d $04
	note $30 $05
	note $2d $04
	note $30 $05
	note $2d $04
	note $30 $05
	note $2d $04
	note $30 $05
	note $2d $04
	note $30 $05
	note $2d $04
	note $30 $05
	note $2d $04
	note $30 $05
	note $2d $04
	note $30 $05
	note $2d $04
	note $30 $05
	note $2d $04
	note $30 $05
	note $2d $04
	note $30 $05
	note $2d $04
	note $30 $05
	note $2d $04
	note $30 $05
	note $2c $04
	note $30 $05
	note $2c $04
	note $30 $05
	note $2c $04
	note $30 $05
	note $2c $04
	note $30 $05
	note $2c $04
	note $30 $05
	note $2c $04
	note $30 $05
	note $2c $04
	note $30 $05
	note $2c $04
	note $30 $05
	note $2c $04
	note $30 $05
	note $2c $04
	note $30 $05
	note $2c $04
	note $30 $05
	note $2c $04
	note $30 $05
	note $2c $04
	note $30 $05
	note $2c $04
	note $30 $05
	note $2c $04
	note $30 $05
	note $2c $04
	note $30 $05
	note $2b $04
	note $30 $05
	note $2b $04
	note $30 $05
	note $2b $04
	vol $4
	note $30 $05
	note $2b $04
	note $30 $05
	note $2b $04
	note $30 $05
	note $2b $04
	note $30 $05
	note $2b $04
	note $30 $05
	note $2b $04
	note $30 $05
	note $2b $04
	note $30 $05
	note $2b $04
	note $30 $05
	note $2b $04
	note $30 $05
	note $2b $04
	note $30 $05
	note $2b $04
	note $30 $05
	note $2b $04
	note $30 $05
	note $2b $04
	note $30 $05
	note $2b $04
	note $30 $05
	note $2a $04
	note $32 $05
	note $2a $04
	note $32 $05
	note $2a $04
	note $32 $05
	note $2a $04
	note $32 $05
	note $2a $04
	note $32 $05
	note $2a $04
	note $32 $05
	note $2a $04
	vol $5
	note $32 $05
	vol $6
	note $32 $04
	vol $6
	note $33 $05
	vol $6
	note $34 $04
	wait1 $05
	vibrato $f1
	env $0 $00
	vol $6
	note $21 $09
	wait1 $09
	note $21 $09
	note $24 $09
	note $21 $09
	note $24 $09
	note $2b $09
	goto musicf2144
	cmdff
; $f2437
; @addr{f2437}
sound16Channel0:
	vol $0
	note $20 $3f
	vibrato $00
	env $0 $00
	cmdf2
	duty $02
musicf2441:
	wait1 $12
	vol $6
	note $1c $04
	wait1 $0e
	note $1a $12
	note $1b $09
	note $1c $04
	wait1 $02
	vol $3
	note $1c $05
	wait1 $02
	vol $1
	note $1c $05
	wait1 $51
	vol $6
	note $1c $04
	wait1 $0e
	note $1a $12
	note $1b $09
	note $1c $04
	wait1 $02
	vol $3
	note $1c $05
	wait1 $02
	vol $1
	note $1c $05
	wait1 $51
	vol $6
	note $1c $04
	wait1 $0e
	note $1a $12
	note $1b $09
	note $1c $04
	wait1 $02
	vol $3
	note $1c $05
	wait1 $02
	vol $1
	note $1c $05
	wait1 $51
	vol $6
	note $1c $04
	wait1 $0e
	note $1a $12
	note $1b $09
	note $1c $04
	wait1 $02
	vol $3
	note $1c $05
	wait1 $02
	vol $1
	note $1c $05
	wait1 $51
	vol $6
	note $1c $04
	wait1 $0e
	note $1a $12
	note $1b $09
	note $1c $04
	wait1 $02
	vol $3
	note $1c $05
	wait1 $02
	vol $1
	note $1c $05
	wait1 $51
	vol $6
	note $1c $04
	wait1 $0e
	note $1a $12
	note $1b $09
	note $1c $04
	wait1 $02
	vol $3
	note $1c $05
	wait1 $02
	vol $1
	note $1c $05
	wait1 $51
	vol $6
	note $1c $04
	wait1 $0e
	note $1a $12
	note $1b $09
	note $1c $04
	wait1 $02
	vol $3
	note $1c $05
	wait1 $02
	vol $1
	note $1c $05
	wait1 $51
	vol $6
	note $1c $04
	wait1 $0e
	note $1a $12
	note $1b $09
	note $1c $04
	wait1 $02
	vol $3
	note $1c $05
	wait1 $02
	vol $1
	note $1c $05
	wait1 $51
	vol $6
	note $1c $04
	wait1 $0e
	note $1a $12
	note $1b $09
	note $1c $04
	wait1 $02
	vol $3
	note $1c $05
	wait1 $02
	vol $1
	note $1c $05
	wait1 $51
	vol $6
	note $1c $04
	wait1 $0e
	note $1a $12
	note $1b $09
	note $1c $04
	wait1 $02
	vol $3
	note $1c $05
	wait1 $02
	vol $1
	note $1c $05
	wait1 $51
	vol $6
	note $1c $04
	wait1 $0e
	note $1a $12
	note $1b $09
	note $1c $04
	wait1 $02
	vol $3
	note $1c $05
	wait1 $02
	vol $1
	note $1c $05
	wait1 $51
	vol $6
	note $1c $04
	wait1 $0e
	note $1a $12
	note $1b $09
	note $1c $04
	wait1 $02
	vol $3
	note $1c $05
	wait1 $02
	vol $1
	note $1c $05
	wait1 $51
	vol $6
	note $1c $04
	wait1 $0e
	note $1a $12
	note $1b $09
	note $1c $04
	wait1 $02
	vol $3
	note $1c $05
	wait1 $02
	vol $1
	note $1c $05
	wait1 $1b
	vol $6
	note $21 $09
	note $1c $09
	note $21 $09
	note $1c $09
	wait1 $12
	vol $6
	note $1c $04
	wait1 $0e
	note $1a $12
	note $1b $09
	note $1c $04
	wait1 $02
	vol $3
	note $1c $05
	wait1 $02
	vol $1
	note $1c $05
	wait1 $1b
	vol $6
	note $20 $09
	note $1c $09
	vol $6
	note $20 $09
	note $1c $09
	wait1 $12
	vol $6
	note $1c $04
	wait1 $0e
	note $1a $12
	note $1b $09
	note $1c $04
	wait1 $02
	vol $3
	note $1c $05
	wait1 $02
	vol $1
	note $1c $05
	wait1 $1b
	vol $6
	note $1f $09
	note $1c $09
	note $1f $09
	note $1c $09
	wait1 $12
	vol $6
	note $1c $04
	wait1 $0e
	note $1a $12
	note $1b $09
	note $1c $04
	wait1 $02
	vol $3
	note $1c $05
	wait1 $02
	vol $1
	note $1c $05
	wait1 $3f
	goto musicf2441
	cmdff
; $f25d9
; @addr{f25d9}
sound16Channel4:
	wait1 $3f
	cmdf2
musicf25dc:
	duty $0e
	note $15 $04
	duty $0f
	note $15 $04
	wait1 $0a
	duty $0e
	note $15 $04
	duty $0f
	note $15 $04
	wait1 $0a
	duty $0e
	note $13 $12
	note $14 $09
	note $15 $04
	duty $0f
	note $15 $04
	wait1 $49
	duty $0e
	note $15 $04
	duty $0f
	note $15 $04
	wait1 $0a
	duty $0e
	note $15 $04
	duty $0f
	note $15 $04
	wait1 $0a
	duty $0e
	note $13 $12
	note $14 $09
	note $15 $04
	duty $0f
	note $15 $04
	wait1 $49
	duty $0e
	note $15 $04
	duty $0f
	note $15 $04
	wait1 $0a
	duty $0e
	note $15 $04
	duty $0f
	note $15 $04
	wait1 $0a
	duty $0e
	note $13 $12
	note $14 $09
	note $15 $04
	duty $0f
	note $15 $04
	wait1 $49
	duty $0e
	note $15 $04
	duty $0f
	note $15 $04
	wait1 $0a
	duty $0e
	note $15 $04
	duty $0f
	note $15 $04
	wait1 $0a
	duty $0e
	note $13 $12
	note $14 $09
	note $15 $04
	duty $0f
	note $15 $04
	wait1 $49
	duty $0e
	note $15 $04
	duty $0f
	note $15 $04
	wait1 $0a
	duty $0e
	note $15 $04
	duty $0f
	note $15 $04
	wait1 $0a
	duty $0e
	note $13 $12
	note $14 $09
	note $15 $04
	duty $0f
	note $15 $04
	wait1 $49
	duty $0e
	note $15 $04
	duty $0f
	note $15 $04
	wait1 $0a
	duty $0e
	note $15 $04
	duty $0f
	note $15 $04
	wait1 $0a
	duty $0e
	note $13 $12
	note $14 $09
	note $15 $04
	duty $0f
	note $15 $04
	wait1 $49
	duty $0e
	note $15 $04
	duty $0f
	note $15 $04
	wait1 $0a
	duty $0e
	note $15 $04
	duty $0f
	note $15 $04
	wait1 $0a
	duty $0e
	note $13 $12
	note $14 $09
	note $15 $04
	duty $0f
	note $15 $04
	wait1 $49
	duty $0e
	note $15 $04
	duty $0f
	note $15 $04
	wait1 $0a
	duty $0e
	note $15 $04
	duty $0f
	note $15 $04
	wait1 $0a
	duty $0e
	note $13 $12
	note $14 $09
	note $15 $04
	duty $0f
	note $15 $04
	wait1 $25
	duty $0e
	note $15 $09
	note $10 $09
	note $13 $09
	note $10 $09
	duty $0e
	note $15 $04
	duty $0f
	note $15 $05
	duty $0e
	note $15 $04
	duty $0f
	note $15 $05
	duty $0e
	note $15 $04
	duty $0f
	note $15 $05
	wait1 $1b
	duty $0e
	note $15 $04
	duty $0f
	note $15 $05
	duty $0e
	note $15 $04
	duty $0f
	note $15 $05
	duty $0e
	note $15 $04
	duty $0f
	note $15 $05
	wait1 $3f
	duty $0e
	note $15 $04
	duty $0f
	note $15 $05
	duty $0e
	note $15 $04
	duty $0f
	note $15 $05
	duty $0e
	note $15 $04
	duty $0f
	note $15 $05
	wait1 $1b
	duty $0e
	note $15 $04
	duty $0f
	note $15 $05
	duty $0e
	note $15 $04
	duty $0f
	note $15 $05
	duty $0e
	note $15 $04
	duty $0f
	note $15 $05
	wait1 $3f
	duty $0e
	note $15 $04
	duty $0f
	note $15 $05
	duty $0e
	note $15 $04
	duty $0f
	note $15 $05
	duty $0e
	note $15 $04
	duty $0f
	note $15 $05
	wait1 $1b
	duty $0e
	note $15 $04
	duty $0f
	note $15 $05
	duty $0e
	note $15 $04
	duty $0f
	note $15 $05
	duty $0e
	note $15 $04
	duty $0f
	note $15 $05
	wait1 $3f
	duty $0e
	note $15 $04
	duty $0f
	note $15 $05
	duty $0e
	note $15 $04
	duty $0f
	note $15 $05
	duty $0e
	note $15 $04
	duty $0f
	note $15 $05
	wait1 $1b
	duty $0e
	note $15 $04
	duty $0f
	note $15 $05
	duty $0e
	note $15 $04
	duty $0f
	note $15 $05
	duty $0e
	note $15 $04
	duty $0f
	note $15 $05
	wait1 $12
	duty $0e
	note $10 $09
	note $13 $09
	note $10 $09
	note $13 $09
	note $14 $09
	duty $0e
	note $15 $04
	duty $0f
	note $15 $05
	duty $0e
	note $15 $04
	duty $0f
	note $15 $05
	duty $0e
	note $15 $04
	duty $0f
	note $15 $05
	wait1 $1b
	duty $0e
	note $15 $04
	duty $0f
	note $15 $05
	duty $0e
	note $15 $04
	duty $0f
	note $15 $05
	duty $0e
	note $15 $04
	duty $0f
	note $15 $05
	wait1 $3f
	duty $0e
	note $15 $04
	duty $0f
	note $15 $05
	duty $0e
	note $15 $04
	duty $0f
	note $15 $05
	duty $0e
	note $15 $04
	duty $0f
	note $15 $05
	wait1 $1b
	duty $0e
	note $15 $04
	duty $0f
	note $15 $05
	duty $0e
	note $15 $04
	duty $0f
	note $15 $05
	duty $0e
	note $15 $04
	duty $0f
	note $15 $05
	wait1 $3f
	duty $0e
	note $15 $04
	duty $0f
	note $15 $05
	duty $0e
	note $15 $04
	duty $0f
	note $15 $05
	duty $0e
	note $15 $04
	duty $0f
	note $15 $05
	wait1 $1b
	duty $0e
	note $15 $04
	duty $0f
	note $15 $05
	duty $0e
	note $15 $04
	duty $0f
	note $15 $05
	duty $0e
	note $15 $04
	duty $0f
	note $15 $05
	wait1 $3f
	duty $0e
	note $17 $04
	duty $0f
	note $17 $05
	duty $0e
	note $17 $04
	duty $0f
	note $17 $05
	duty $0e
	note $17 $04
	duty $0f
	note $17 $05
	wait1 $1b
	duty $0e
	note $17 $04
	duty $0f
	note $17 $05
	duty $0e
	note $17 $04
	duty $0f
	note $17 $05
	duty $0e
	note $10 $04
	duty $0f
	note $10 $05
	wait1 $3f
	goto musicf25dc
	cmdff
; $f28a6
; @addr{f28a6}
sound16Channel6:
	wait1 $3f
	cmdf2
musicf28a9:
	vol $3
	note $26 $09
	note $26 $09
	wait1 $09
	note $26 $09
	note $26 $09
	wait1 $2d
	note $26 $09
	wait1 $09
	note $26 $09
	wait1 $1b
	note $26 $09
	note $26 $09
	wait1 $09
	note $26 $09
	note $26 $09
	wait1 $2d
	note $26 $09
	wait1 $09
	note $26 $09
	wait1 $1b
	note $26 $09
	note $26 $09
	wait1 $09
	note $26 $09
	note $26 $09
	wait1 $2d
	note $26 $09
	wait1 $09
	note $26 $09
	wait1 $1b
	note $26 $09
	note $26 $09
	wait1 $09
	note $26 $09
	note $26 $09
	wait1 $2d
	note $26 $09
	wait1 $09
	note $26 $09
	wait1 $1b
	note $26 $09
	note $26 $09
	wait1 $09
	note $26 $09
	note $26 $09
	wait1 $2d
	note $26 $09
	wait1 $09
	note $26 $09
	wait1 $1b
	note $26 $09
	note $26 $09
	wait1 $09
	note $26 $09
	note $26 $09
	wait1 $2d
	note $26 $09
	wait1 $09
	note $26 $09
	wait1 $1b
	note $26 $09
	note $26 $09
	wait1 $09
	note $26 $09
	note $26 $09
	wait1 $2d
	note $26 $09
	wait1 $09
	note $26 $09
	wait1 $1b
	note $26 $09
	note $26 $09
	wait1 $09
	note $26 $09
	note $26 $09
	wait1 $2d
	note $26 $09
	wait1 $09
	note $26 $09
	wait1 $1b
	note $26 $09
	note $26 $09
	wait1 $09
	note $26 $09
	note $26 $09
	wait1 $2d
	note $26 $09
	wait1 $09
	note $26 $09
	wait1 $1b
	note $26 $09
	note $26 $09
	wait1 $09
	note $26 $09
	note $26 $09
	wait1 $2d
	note $26 $09
	wait1 $09
	note $26 $09
	wait1 $1b
	note $26 $09
	note $26 $09
	wait1 $09
	note $26 $09
	note $26 $09
	wait1 $2d
	note $26 $09
	wait1 $09
	note $26 $09
	wait1 $1b
	note $26 $09
	note $26 $09
	wait1 $09
	note $26 $09
	note $26 $09
	wait1 $2d
	note $26 $09
	wait1 $09
	note $26 $09
	wait1 $1b
	note $26 $09
	note $26 $09
	wait1 $09
	note $26 $09
	note $26 $09
	wait1 $2d
	note $26 $09
	wait1 $09
	note $26 $09
	wait1 $1b
	note $26 $09
	note $26 $09
	wait1 $09
	note $26 $09
	note $26 $09
	wait1 $2d
	note $26 $09
	wait1 $09
	note $26 $09
	wait1 $1b
	note $26 $09
	note $26 $09
	wait1 $09
	note $26 $09
	note $26 $09
	wait1 $2d
	note $26 $09
	wait1 $09
	note $26 $09
	wait1 $1b
	note $26 $09
	note $26 $09
	wait1 $09
	note $26 $09
	note $26 $09
	wait1 $2d
	note $26 $09
	wait1 $09
	note $26 $09
	wait1 $1b
	goto musicf28a9
	cmdff
; $f29ee
; @addr{f29ee}
sound1cChannel1:
	vibrato $c1
	env $0 $00
	cmdf2
	duty $01
musicf29f5:
	vol $0
	note $20 $24
	vol $6
	note $21 $24
	note $26 $24
	note $2d $24
	note $2c $48
	note $29 $24
	note $26 $24
	duty $02
	note $30 $09
	note $2f $09
	note $30 $09
	note $2f $09
	wait1 $6c
	vol $4
	note $30 $09
	note $2f $09
	note $30 $09
	note $2f $09
	wait1 $90
	duty $01
	vol $6
	note $26 $24
	note $29 $24
	note $2d $24
	note $31 $48
	note $32 $24
	note $34 $24
	vol $7
	note $35 $09
	note $34 $09
	vol $6
	note $35 $09
	note $34 $09
	note $2c $48
	wait1 $24
	vol $4
	note $35 $09
	note $34 $09
	note $35 $09
	note $34 $09
	note $2c $48
	wait1 $24
	vol $6
	note $34 $09
	note $33 $09
	note $34 $09
	note $33 $09
	note $2b $6c
	note $33 $09
	note $32 $09
	note $33 $09
	note $32 $09
	note $2a $5a
	wait1 $12
	vol $6
	note $30 $12
	note $2f $09
	wait1 $04
	vol $3
	note $2f $05
	vol $6
	note $34 $12
	vol $6
	note $33 $09
	wait1 $04
	vol $3
	note $33 $05
	vol $6
	note $37 $12
	vol $6
	note $36 $09
	wait1 $04
	vol $3
	note $36 $05
	vol $6
	note $3c $12
	note $3b $09
	wait1 $04
	vol $3
	note $3b $05
	vol $6
	note $45 $09
	note $44 $09
	note $43 $09
	note $42 $09
	note $41 $09
	wait1 $04
	vol $3
	note $41 $05
	vol $6
	note $41 $09
	note $40 $09
	note $3f $09
	note $3e $09
	note $3d $09
	wait1 $04
	vol $3
	note $3d $05
	vol $6
	note $3d $09
	note $3c $09
	note $3b $09
	note $3a $09
	note $32 $12
	vol $6
	note $34 $12
	note $35 $24
	vibrato $01
	env $0 $00
	vol $3
	note $35 $12
	vibrato $d1
	env $0 $00
	vol $6
	note $32 $12
	note $34 $12
	note $35 $12
	note $39 $48
	note $38 $36
	vibrato $01
	env $0 $00
	vol $3
	note $38 $12
	vibrato $d1
	env $0 $00
	vol $6
	note $30 $12
	note $32 $12
	note $33 $24
	vibrato $01
	env $0 $00
	vol $3
	note $33 $12
	vibrato $d1
	env $0 $00
	vol $6
	note $30 $12
	note $32 $12
	note $33 $12
	note $37 $48
	note $36 $36
	vibrato $01
	env $0 $00
	vol $3
	note $36 $12
	vibrato $d1
	env $0 $00
	vol $6
	note $2e $12
	note $30 $12
	note $31 $24
	vibrato $01
	env $0 $00
	vol $3
	note $31 $12
	vibrato $d1
	env $0 $00
	vol $6
	note $2e $12
	note $30 $12
	note $31 $12
	wait1 $04
	vol $3
	note $31 $09
	wait1 $09
	vol $1
	note $31 $09
	wait1 $05
	vol $6
	note $28 $51
	vibrato $01
	env $0 $00
	vol $3
	note $28 $1b
	wait1 $48
	vibrato $c1
	env $0 $00
	goto musicf29f5
	cmdff
; $f2b39
; @addr{f2b39}
sound1cChannel0:
	vibrato $c1
	env $0 $00
	cmdf2
	duty $01
musicf2b40:
	vol $0
	note $20 $24
	vol $1
	note $21 $12
	vol $3
	note $21 $24
	note $26 $24
	note $2d $24
	note $2c $48
	note $29 $24
	note $26 $24
	duty $02
	vol $3
	note $30 $09
	note $2f $09
	note $30 $09
	note $2f $09
	wait1 $6c
	vol $2
	note $30 $09
	note $2f $09
	note $30 $09
	note $2f $09
	wait1 $99
	duty $01
	vol $3
	note $26 $24
	note $29 $24
	note $2d $24
	note $31 $48
	note $32 $24
	note $34 $24
	wait1 $03
	vol $3
	note $35 $09
	note $34 $09
	vol $3
	note $35 $09
	note $34 $09
	vol $3
	note $2c $48
	wait1 $24
	vol $2
	note $35 $09
	note $34 $09
	note $35 $09
	vol $2
	note $34 $09
	note $2c $63
	vol $3
	note $34 $09
	note $33 $09
	note $34 $09
	note $33 $09
	note $2b $6c
	vol $1
	note $33 $09
	note $32 $09
	note $33 $09
	note $32 $09
	note $2a $57
	vol $6
	note $2d $12
	note $2c $09
	wait1 $04
	vol $3
	note $2c $05
	vol $6
	note $30 $12
	note $2f $09
	wait1 $04
	vol $3
	note $2f $05
	vol $6
	note $34 $12
	note $33 $09
	wait1 $04
	vol $3
	note $33 $05
	vol $6
	note $39 $12
	note $38 $09
	wait1 $04
	vol $3
	note $38 $05
	vol $6
	note $42 $09
	note $41 $09
	note $40 $09
	note $3f $09
	note $3e $09
	wait1 $04
	vol $3
	note $3e $05
	vol $6
	note $3e $09
	note $3d $09
	note $3c $09
	note $3b $09
	note $3a $09
	wait1 $04
	vol $3
	note $3a $05
	vol $6
	note $3a $09
	note $39 $09
	note $38 $09
	note $37 $09
	duty $02
	note $26 $04
	wait1 $05
	note $29 $04
	vol $3
	note $26 $05
	vol $6
	note $28 $04
	vol $3
	note $29 $05
	vol $6
	note $29 $04
	vol $3
	note $28 $05
	vol $6
	note $26 $04
	vol $3
	note $29 $05
	vol $6
	note $29 $04
	vol $3
	note $26 $05
	vol $6
	note $28 $04
	vol $3
	note $29 $05
	vol $6
	note $29 $04
	vol $3
	note $28 $05
	vol $6
	note $26 $04
	vol $3
	note $29 $05
	vol $6
	note $29 $04
	vol $3
	note $26 $05
	vol $6
	note $28 $04
	vol $3
	note $29 $05
	vol $6
	note $29 $04
	vol $3
	note $28 $05
	vol $6
	note $26 $04
	vol $3
	note $29 $05
	vol $6
	note $29 $04
	vol $3
	note $26 $05
	vol $6
	note $28 $04
	vol $3
	note $29 $05
	vol $6
	note $29 $04
	vol $3
	note $28 $05
	vol $6
	note $23 $04
	vol $3
	note $29 $05
	vol $6
	note $26 $04
	vol $3
	note $23 $05
	vol $6
	note $25 $04
	vol $3
	note $26 $05
	vol $6
	note $26 $04
	vol $3
	note $25 $05
	vol $6
	note $23 $04
	vol $3
	note $26 $05
	vol $6
	note $26 $04
	vol $3
	note $23 $05
	vol $6
	note $25 $04
	vol $3
	note $26 $05
	vol $6
	note $26 $04
	vol $3
	note $25 $05
	vol $6
	note $23 $04
	vol $3
	note $26 $05
	vol $6
	note $26 $04
	vol $3
	note $23 $05
	vol $6
	note $25 $04
	vol $3
	note $26 $05
	vol $6
	note $26 $04
	vol $3
	note $25 $05
	vol $6
	note $23 $04
	vol $3
	note $26 $05
	vol $6
	note $26 $04
	vol $3
	note $23 $05
	vol $6
	note $25 $04
	vol $3
	note $26 $05
	vol $6
	note $26 $04
	vol $3
	note $25 $05
	vol $6
	note $24 $04
	vol $3
	note $26 $05
	vol $6
	note $27 $04
	vol $3
	note $24 $05
	vol $6
	note $26 $04
	vol $3
	note $27 $05
	vol $6
	note $27 $04
	vol $3
	note $26 $05
	vol $6
	note $24 $04
	vol $3
	note $27 $05
	vol $6
	note $27 $04
	vol $3
	note $24 $05
	vol $6
	note $26 $04
	vol $3
	note $27 $05
	vol $6
	note $27 $04
	vol $3
	note $26 $05
	vol $6
	note $24 $04
	vol $3
	note $27 $05
	vol $6
	note $27 $04
	vol $3
	note $24 $05
	vol $6
	note $26 $04
	vol $3
	note $27 $05
	vol $6
	note $27 $04
	vol $3
	note $26 $05
	vol $6
	note $24 $04
	vol $3
	note $27 $05
	vol $6
	note $27 $04
	vol $3
	note $24 $05
	vol $6
	note $26 $04
	vol $3
	note $27 $05
	vol $6
	note $27 $04
	vol $3
	note $26 $05
	vol $6
	note $21 $04
	vol $3
	note $27 $05
	vol $6
	note $24 $04
	vol $3
	note $21 $05
	vol $6
	note $23 $04
	vol $3
	note $24 $05
	vol $6
	note $24 $04
	vol $3
	note $23 $05
	vol $6
	note $21 $04
	vol $3
	note $24 $05
	vol $6
	note $24 $04
	vol $3
	note $21 $05
	vol $6
	note $23 $04
	vol $3
	note $24 $05
	vol $6
	note $24 $04
	vol $3
	note $23 $05
	vol $6
	note $21 $04
	vol $3
	note $24 $05
	vol $6
	note $24 $04
	vol $3
	note $21 $05
	vol $6
	note $23 $04
	vol $3
	note $24 $05
	vol $6
	note $24 $04
	vol $3
	note $23 $05
	vol $6
	note $21 $04
	vol $3
	note $24 $05
	vol $6
	note $24 $04
	vol $3
	note $21 $05
	vol $6
	note $23 $04
	vol $3
	note $24 $05
	vol $6
	note $24 $04
	vol $3
	note $23 $05
	duty $01
	vol $6
	note $22 $12
	note $24 $12
	note $25 $24
	vibrato $01
	env $0 $00
	vol $3
	note $25 $12
	vibrato $d1
	env $0 $00
	vol $6
	note $22 $12
	note $24 $12
	note $25 $12
	wait1 $04
	vol $3
	note $25 $09
	wait1 $05
	vol $1
	note $25 $09
	wait1 $09
	vol $6
	note $1c $48
	vibrato $01
	env $0 $00
	vol $3
	note $1c $24
	wait1 $48
	vibrato $d1
	env $0 $00
	goto musicf2b40
	cmdff
; $f2db8
; @addr{f2db8}
sound1cChannel4:
	duty $0e
musicf2dba:
	note $0e $09
	wait1 $09
	note $0e $09
	wait1 $75
	note $0e $09
	wait1 $09
	note $0e $09
	wait1 $75
	note $0e $09
	wait1 $09
	note $0e $09
	wait1 $75
	note $0e $09
	wait1 $09
	note $0e $09
	wait1 $75
	note $0e $09
	wait1 $09
	note $0e $09
	wait1 $63
	note $0e $09
	wait1 $09
	note $0e $09
	wait1 $09
	note $0e $09
	wait1 $75
	note $0e $09
	wait1 $09
	note $0e $09
	wait1 $75
	note $0e $09
	wait1 $09
	note $0e $09
	wait1 $75
	note $0d $09
	wait1 $09
	note $0d $09
	wait1 $75
	note $0c $09
	wait1 $09
	note $0c $09
	wait1 $75
	note $0b $90
	wait1 $90
	note $0e $09
	wait1 $09
	note $0e $09
	wait1 $2d
	note $0e $09
	wait1 $09
	note $0e $09
	wait1 $2d
	note $14 $09
	wait1 $09
	note $14 $09
	wait1 $2d
	note $14 $09
	wait1 $09
	note $14 $09
	wait1 $2d
	note $0c $09
	wait1 $09
	note $0c $09
	wait1 $2d
	note $0c $09
	wait1 $09
	note $0c $09
	wait1 $2d
	note $12 $09
	wait1 $09
	note $12 $09
	wait1 $2d
	note $12 $09
	wait1 $09
	note $12 $09
	wait1 $1b
	note $0f $04
	note $0e $05
	note $0c $04
	note $0b $05
	note $0a $12
	note $0c $12
	note $0d $2d
	wait1 $09
	note $0a $12
	note $0c $12
	note $0d $12
	wait1 $24
	note $04 $09
	note $05 $09
	note $04 $09
	note $05 $09
	note $04 $09
	note $05 $09
	note $04 $09
	note $05 $09
	note $04 $09
	wait1 $63
	goto musicf2dba
	cmdff
; $f2e82
sound22Start:
; @addr{f2e82}
sound22Channel1:
	vibrato $00
	env $0 $04
	cmdf2
	duty $02
musicf2e89:
	vol $6
	note $28 $1c
	note $2c $1c
	note $2f $1c
	note $2e $0e
	note $2f $07
	note $31 $07
	note $32 $0e
	note $31 $07
	wait1 $03
	vol $3
	note $31 $04
	vol $6
	note $2f $0e
	note $2e $07
	wait1 $03
	vol $3
	note $2e $04
	vol $6
	note $2f $23
	vol $3
	note $2f $15
	vol $6
	note $2c $1c
	note $2d $0e
	note $2e $0e
	note $2f $0e
	note $2c $07
	wait1 $03
	vol $3
	note $2c $04
	vol $6
	note $28 $07
	wait1 $03
	vol $3
	note $28 $04
	vol $6
	note $23 $07
	wait1 $03
	vol $3
	note $23 $04
	vol $6
	note $24 $03
	note $26 $04
	note $24 $03
	note $26 $04
	note $24 $03
	note $26 $04
	note $24 $07
	note $23 $03
	wait1 $19
	note $25 $03
	note $26 $04
	note $25 $03
	note $26 $04
	note $25 $03
	note $26 $04
	note $25 $07
	note $23 $03
	wait1 $19
	note $28 $1c
	note $2c $1c
	note $2f $1c
	note $2e $0e
	note $2f $07
	note $31 $07
	note $32 $0e
	note $31 $07
	wait1 $03
	vol $3
	note $31 $04
	vol $6
	note $32 $0e
	note $33 $0e
	note $34 $1c
	vol $3
	note $34 $0e
	vol $6
	note $2f $07
	note $31 $07
	note $32 $0e
	note $31 $07
	wait1 $03
	vol $3
	note $31 $04
	vol $6
	note $32 $0e
	note $31 $07
	wait1 $03
	vol $3
	note $31 $04
	vol $6
	note $32 $0e
	note $31 $07
	note $2f $03
	note $31 $04
	note $2f $0e
	note $2e $0e
	note $2f $0e
	note $2e $07
	wait1 $03
	vol $3
	note $2e $04
	vol $6
	note $2c $0e
	note $2a $07
	wait1 $03
	vol $3
	note $2a $04
	vol $6
	note $28 $1c
	vol $3
	note $28 $0e
	vol $6
	note $23 $0e
	note $24 $1c
	note $23 $1c
	note $25 $1c
	note $23 $07
	wait1 $03
	vol $3
	note $23 $04
	vol $6
	note $23 $0e
	note $26 $1c
	note $23 $1c
	note $25 $1c
	note $23 $07
	wait1 $03
	vol $3
	note $23 $07
	wait1 $19
	vol $6
	note $2f $07
	wait1 $03
	vol $3
	note $2f $04
	vol $6
	note $2e $07
	wait1 $03
	vol $3
	note $2e $04
	vol $6
	note $2f $07
	wait1 $03
	vol $3
	note $2f $04
	vol $6
	note $30 $0e
	note $2f $07
	wait1 $03
	vol $3
	note $2f $04
	vol $6
	note $2e $07
	wait1 $03
	vol $3
	note $2e $04
	vol $6
	note $2f $07
	wait1 $03
	vol $3
	note $2f $04
	vol $6
	note $31 $0e
	note $2f $07
	wait1 $03
	vol $3
	note $2f $04
	vol $6
	note $2e $07
	wait1 $03
	vol $3
	note $2e $04
	vol $6
	note $31 $07
	wait1 $03
	vol $3
	note $31 $04
	vol $6
	note $2f $1c
	vol $3
	note $2f $0e
	vol $6
	note $23 $0e
	note $24 $1c
	note $23 $1c
	note $24 $04
	note $25 $05
	note $24 $05
	note $25 $04
	note $24 $05
	note $25 $05
	note $23 $0e
	wait1 $0e
	note $27 $1c
	note $23 $1c
	note $24 $04
	note $25 $05
	note $24 $05
	note $25 $04
	note $24 $05
	note $25 $05
	note $23 $0e
	wait1 $1c
	note $2f $07
	wait1 $03
	vol $3
	note $2f $04
	vol $6
	note $2e $07
	wait1 $03
	vol $3
	note $2e $04
	vol $6
	note $2f $07
	wait1 $03
	vol $3
	note $2f $04
	vol $6
	note $34 $0e
	note $32 $07
	wait1 $03
	vol $3
	note $32 $04
	vol $6
	note $2f $07
	wait1 $03
	vol $3
	note $2f $04
	vol $6
	note $2b $07
	wait1 $03
	vol $3
	note $2b $04
	vol $6
	note $2e $0e
	note $2d $07
	wait1 $03
	vol $3
	note $2d $04
	vol $6
	note $2b $07
	wait1 $03
	vol $3
	note $2b $04
	vol $6
	note $2a $07
	wait1 $03
	vol $3
	note $2a $04
	vol $6
	note $28 $2a
	vol $3
	note $28 $0e
	goto musicf2e89
	cmdff
; $f3045
; @addr{f3045}
sound22Channel0:
	vibrato $00
	env $0 $03
	cmdf2
	duty $02
musicf304c:
	vol $0
	note $18 $ff
	note $18 $51
	vol $6
	note $18 $03
	note $1a $04
	note $18 $03
	note $1a $04
	note $18 $03
	note $1a $04
	note $18 $07
	note $17 $03
	wait1 $19
	note $19 $03
	note $1a $04
	note $19 $03
	note $1a $04
	note $19 $03
	note $1a $04
	note $19 $07
	note $17 $03
	wait1 $ff
	wait1 $cc
	note $17 $0e
	vibrato $00
	env $0 $03
	note $18 $1c
	note $17 $1c
	vibrato $00
	env $0 $03
	note $19 $04
	note $1a $05
	note $19 $05
	note $1a $04
	note $19 $05
	note $1a $05
	note $17 $07
	wait1 $07
	note $17 $0e
	vibrato $00
	env $0 $03
	note $1a $1c
	note $17 $1c
	vibrato $00
	env $0 $03
	note $19 $04
	note $1a $05
	note $19 $05
	note $1a $04
	note $19 $05
	note $1a $05
	note $17 $0e
	wait1 $1c
	note $2b $07
	wait1 $03
	vol $3
	note $2b $04
	vol $6
	note $2a $07
	wait1 $03
	vol $3
	note $2a $04
	vol $6
	note $2b $07
	wait1 $03
	vol $3
	note $2b $04
	vol $6
	note $2d $0e
	note $2b $07
	wait1 $03
	vol $3
	note $2b $04
	vol $6
	note $2a $07
	wait1 $03
	vol $3
	note $2a $04
	vol $6
	note $2b $07
	wait1 $03
	vol $3
	note $2b $04
	vol $6
	note $2d $0e
	note $2b $07
	wait1 $03
	vol $3
	note $2b $04
	vol $6
	note $2a $07
	wait1 $03
	vol $3
	note $2a $04
	vol $6
	note $2e $07
	wait1 $03
	vol $3
	note $2e $04
	vol $6
	note $2b $1c
	vol $3
	note $2b $1c
	vibrato $00
	env $0 $03
	vol $6
	note $18 $1c
	note $17 $1c
	vibrato $00
	env $0 $03
	note $18 $04
	note $19 $05
	note $18 $05
	note $19 $04
	note $18 $05
	note $19 $05
	note $17 $0e
	wait1 $0e
	vibrato $00
	env $0 $03
	note $1b $1c
	note $17 $1c
	vibrato $00
	env $0 $03
	note $18 $04
	note $19 $05
	note $18 $05
	note $19 $04
	note $18 $05
	note $19 $05
	note $17 $0e
	wait1 $1c
	note $2b $07
	wait1 $03
	vol $3
	note $2b $04
	vol $6
	note $2a $07
	wait1 $03
	vol $3
	note $2a $04
	vol $6
	note $2b $07
	wait1 $03
	vol $3
	note $2b $04
	vol $6
	note $2e $0e
	note $2f $07
	wait1 $03
	vol $3
	note $2f $04
	vol $6
	note $2b $07
	wait1 $03
	vol $3
	note $2b $04
	vol $6
	note $28 $07
	wait1 $03
	vol $3
	note $28 $04
	vol $6
	note $2a $0e
	note $29 $07
	wait1 $03
	vol $3
	note $29 $04
	vol $6
	note $28 $07
	wait1 $03
	vol $3
	note $28 $04
	vol $6
	note $24 $07
	wait1 $03
	vol $3
	note $24 $04
	vol $6
	note $22 $2a
	vol $3
	note $22 $0e
	goto musicf304c
	cmdff
; $f3193
; @addr{f3193}
sound22Channel4:
	cmdf2
musicf3194:
	duty $0e
	note $10 $1c
	duty $0f
	note $10 $0a
	wait1 $04
	duty $0e
	note $17 $0e
	note $16 $1c
	duty $0f
	note $16 $0a
	wait1 $04
	duty $0e
	note $13 $0e
	note $10 $0e
	note $17 $07
	duty $0f
	note $17 $04
	wait1 $03
	duty $0e
	note $16 $38
	note $13 $07
	note $15 $07
	note $13 $07
	note $12 $07
	note $10 $1c
	duty $0f
	note $10 $0a
	wait1 $04
	duty $0e
	note $17 $0e
	note $16 $1c
	duty $0f
	note $16 $0a
	wait1 $04
	duty $0e
	note $13 $0e
	note $0c $03
	note $0e $04
	note $0c $03
	note $0e $04
	note $0c $03
	note $0e $04
	note $0c $07
	note $0b $03
	duty $0f
	note $0b $06
	wait1 $13
	duty $0e
	note $0d $03
	note $0e $04
	note $0d $03
	note $0e $04
	note $0d $03
	note $0e $04
	note $0d $07
	note $0b $03
	duty $0f
	note $0b $04
	duty $0e
	note $15 $07
	note $13 $07
	note $12 $07
	note $10 $1c
	duty $0f
	note $10 $0a
	wait1 $04
	duty $0e
	note $17 $0e
	note $16 $1c
	duty $0f
	note $16 $0a
	wait1 $04
	duty $0e
	note $13 $0e
	note $10 $0e
	note $17 $07
	duty $0f
	note $17 $04
	wait1 $03
	duty $0e
	note $16 $38
	note $13 $07
	note $15 $07
	note $13 $07
	note $12 $07
	note $10 $1c
	duty $0f
	note $10 $0a
	wait1 $04
	duty $0e
	note $17 $0e
	note $16 $1c
	duty $0f
	note $16 $0a
	wait1 $04
	duty $0e
	note $13 $0e
	note $10 $0e
	note $17 $07
	duty $0f
	note $17 $04
	wait1 $03
	duty $0e
	note $16 $38
	note $13 $07
	note $15 $07
	note $13 $07
	note $12 $07
	note $10 $1c
	duty $0f
	note $10 $0a
	wait1 $04
	duty $0e
	note $17 $0e
	note $16 $04
	note $17 $05
	note $16 $05
	note $17 $04
	note $16 $05
	note $17 $05
	duty $0f
	note $17 $0a
	wait1 $04
	duty $0e
	note $13 $0e
	note $10 $0e
	note $17 $07
	duty $0f
	note $17 $04
	wait1 $03
	duty $0e
	note $16 $20
	note $17 $05
	note $16 $05
	note $17 $04
	note $16 $05
	note $17 $05
	note $13 $07
	note $15 $07
	note $13 $07
	note $12 $07
	note $10 $1c
	duty $0f
	note $10 $0a
	wait1 $04
	duty $0e
	note $17 $0e
	note $16 $1c
	duty $0f
	note $16 $0a
	wait1 $04
	duty $0e
	note $13 $0e
	note $10 $0e
	note $17 $07
	duty $0f
	note $17 $04
	wait1 $03
	duty $0e
	note $16 $38
	note $13 $07
	note $15 $07
	note $13 $07
	note $12 $07
	note $10 $1c
	duty $0f
	note $10 $0a
	wait1 $04
	duty $0e
	note $17 $0e
	note $16 $1c
	duty $0f
	note $16 $0a
	wait1 $04
	duty $0e
	note $13 $0e
	note $10 $0e
	note $17 $07
	duty $0f
	note $17 $04
	wait1 $03
	duty $0e
	note $16 $38
	note $13 $07
	note $15 $07
	note $13 $07
	note $12 $07
	note $10 $1c
	duty $0f
	note $10 $0e
	wait1 $46
	duty $0e
	note $16 $0b
	duty $0f
	note $16 $03
	duty $0e
	note $15 $07
	duty $0f
	note $15 $04
	wait1 $03
	duty $0e
	note $13 $07
	duty $0f
	note $13 $04
	wait1 $03
	duty $0e
	note $11 $07
	duty $0f
	note $11 $04
	wait1 $03
	duty $0e
	note $10 $0e
	duty $0f
	note $10 $0a
	wait1 $04
	duty $0e
	note $13 $07
	note $15 $07
	note $13 $07
	note $12 $07
	goto musicf3194
	cmdff
; $f3350
; @addr{f3350}
sound22Channel6:
	cmdf2
musicf3351:
	vol $3
	note $23 $1c
	note $26 $0e
	note $23 $0e
	note $23 $1c
	note $26 $0e
	note $23 $0e
	note $23 $0e
	note $26 $0e
	note $26 $2a
	note $26 $0e
	note $26 $0e
	note $26 $0e
	note $23 $1c
	note $26 $0e
	note $23 $0e
	note $23 $1c
	note $26 $0e
	note $23 $0e
	note $23 $0e
	note $26 $0e
	note $26 $2a
	note $26 $0e
	note $26 $0e
	note $26 $0e
	note $23 $1c
	note $26 $0e
	note $23 $0e
	note $23 $1c
	note $26 $0e
	note $23 $0e
	note $23 $0e
	note $26 $0e
	note $26 $2a
	note $26 $0e
	note $26 $0e
	note $26 $0e
	note $23 $1c
	note $26 $0e
	note $23 $0e
	note $23 $1c
	note $26 $0e
	note $23 $0e
	note $23 $0e
	note $26 $0e
	note $26 $2a
	note $26 $0e
	note $26 $0e
	note $26 $0e
	note $23 $1c
	note $26 $0e
	note $23 $0e
	note $23 $1c
	note $26 $0e
	note $23 $0e
	note $23 $0e
	note $26 $0e
	note $26 $2a
	note $26 $0e
	note $26 $0e
	note $26 $0e
	note $23 $1c
	note $26 $0e
	note $23 $0e
	note $23 $1c
	note $26 $0e
	note $23 $0e
	note $23 $0e
	note $26 $0e
	note $26 $2a
	note $26 $0e
	note $26 $0e
	note $26 $0e
	note $23 $1c
	note $26 $0e
	note $23 $0e
	note $23 $1c
	note $26 $0e
	note $23 $0e
	note $23 $0e
	note $26 $0e
	note $26 $2a
	note $26 $0e
	note $26 $0e
	note $26 $0e
	note $26 $70
	note $26 $0e
	note $26 $0e
	note $26 $0e
	note $26 $0e
	note $26 $1c
	note $26 $1c
	goto musicf3351
	cmdff
; $f340c
; @addr{f340c}
sound18Channel1:
	vibrato $f1
	env $0 $00
	cmdf2
	duty $02
	vol $6
	note $1e $0e
	note $25 $0e
musicf3418:
	note $24 $02
	note $25 $02
	note $24 $34
	vibrato $01
	env $0 $00
	vol $3
	note $24 $1c
	vibrato $f1
	env $0 $00
	vol $6
	note $20 $07
	note $21 $07
	note $23 $07
	note $21 $07
	note $20 $02
	note $21 $02
	note $20 $34
	vibrato $01
	env $0 $00
	vol $3
	note $20 $1c
	vibrato $f1
	env $0 $00
	vol $6
	note $1e $0e
	note $25 $0e
	note $24 $02
	note $25 $02
	note $24 $34
	vibrato $01
	env $0 $00
	vol $3
	note $24 $1c
	vibrato $f1
	env $0 $00
	vol $6
	note $25 $07
	note $26 $07
	note $29 $07
	note $26 $07
	note $25 $38
	vibrato $01
	env $0 $00
	vol $3
	note $25 $1c
	vibrato $f1
	env $0 $00
	vol $6
	note $1e $0e
	note $25 $0e
	note $24 $02
	note $25 $02
	note $24 $34
	vibrato $01
	env $0 $00
	vol $3
	note $24 $1c
	vibrato $f1
	env $0 $00
	vol $6
	note $21 $03
	wait1 $04
	note $21 $07
	note $20 $07
	note $1e $07
	note $20 $02
	note $21 $02
	note $20 $34
	vibrato $01
	env $0 $00
	vol $1
	note $20 $1c
	vibrato $f1
	env $0 $00
	vol $6
	note $1e $0e
	note $25 $0e
	note $24 $02
	note $25 $02
	note $24 $34
	vibrato $01
	env $0 $00
	vol $3
	note $24 $1c
	vibrato $f1
	env $0 $00
	vol $6
	note $25 $07
	note $26 $07
	note $29 $07
	note $2a $07
	note $2c $02
	note $2d $02
	note $2c $50
	vibrato $01
	env $0 $00
	vol $3
	note $2c $1c
	wait1 $46
	vibrato $f1
	env $0 $00
	vol $6
	note $2c $07
	vol $3
	note $2c $07
	vol $6
	note $2b $07
	note $2c $07
	note $2b $07
	note $26 $07
	note $25 $02
	note $26 $02
	note $25 $34
	vibrato $01
	env $0 $00
	vol $3
	note $25 $0e
	vibrato $f1
	env $0 $00
	vol $6
	note $2d $07
	vol $3
	note $2d $07
	vol $6
	note $2d $07
	note $2b $07
	note $2a $07
	note $27 $07
	note $26 $02
	note $27 $02
	note $26 $34
	vibrato $01
	env $0 $00
	vol $3
	note $26 $0e
	vibrato $f1
	env $0 $00
	vol $6
	note $2e $07
	vol $3
	note $2e $07
	vol $6
	note $2d $07
	note $2b $07
	note $2a $07
	note $27 $07
	note $26 $02
	note $27 $02
	note $26 $34
	vibrato $01
	env $0 $00
	vol $3
	note $26 $1c
	vibrato $f1
	env $0 $00
	vol $6
	note $28 $07
	note $29 $07
	note $2c $07
	note $2d $07
	note $2f $02
	note $30 $02
	note $2f $34
	vibrato $01
	env $0 $00
	vol $3
	note $2f $1c
	vibrato $f1
	env $0 $00
	vol $6
	note $2f $07
	note $2d $07
	note $2c $07
	note $29 $07
	note $28 $02
	note $29 $02
	note $28 $34
	vibrato $01
	env $0 $00
	vol $3
	note $28 $1c
	wait1 $1c
	vibrato $f1
	env $0 $00
	vol $6
	note $28 $07
	note $29 $07
	note $2c $07
	note $2d $07
	note $2f $07
	note $2d $07
	note $2c $07
	note $29 $07
	note $28 $07
	note $29 $07
	note $28 $07
	note $27 $07
	note $28 $54
	wait1 $1c
	note $1e $0e
	note $25 $0e
	goto musicf3418
	cmdff
; $f358e
; @addr{f358e}
sound18Channel0:
	vol $0
	note $20 $1c
	vibrato $f1
	env $0 $00
	cmdf2
	duty $02
musicf3598:
	wait1 $1c
	vol $7
	note $2a $0e
	note $31 $0e
	vol $6
	note $30 $02
	note $31 $02
	note $30 $33
	wait1 $01
	vibrato $01
	env $0 $00
	vol $3
	note $30 $1c
	vibrato $f1
	env $0 $00
	vol $7
	note $2c $07
	note $2d $07
	note $2f $07
	note $2d $07
	vol $6
	note $2c $02
	note $2d $02
	note $2c $33
	wait1 $01
	vibrato $01
	env $0 $00
	vol $3
	note $2c $1c
	vibrato $f1
	env $0 $00
	vol $7
	note $2a $0e
	note $31 $0e
	vol $6
	note $30 $02
	note $31 $02
	note $30 $33
	wait1 $01
	vibrato $01
	env $0 $00
	vol $3
	note $30 $1c
	vibrato $f1
	env $0 $00
	vol $7
	note $31 $07
	note $32 $07
	note $35 $07
	note $36 $07
	note $38 $07
	note $36 $07
	note $35 $07
	note $32 $07
	vol $6
	note $31 $02
	note $32 $02
	note $31 $17
	wait1 $01
	vibrato $01
	env $0 $00
	vol $3
	note $31 $1c
	vibrato $f1
	env $0 $00
	vol $7
	note $2a $0e
	note $31 $07
	note $30 $03
	note $31 $04
	note $30 $38
	vibrato $01
	env $0 $00
	vol $3
	note $30 $1c
	vibrato $f1
	env $0 $00
	vol $7
	note $2d $03
	wait1 $04
	note $2d $07
	note $2c $07
	note $2a $07
	note $2c $03
	note $2d $04
	note $2c $31
	vibrato $01
	env $0 $00
	vol $3
	note $2c $1c
	vibrato $f1
	env $0 $00
	vol $7
	note $2a $0e
	note $31 $07
	note $30 $03
	note $31 $04
	note $30 $38
	vibrato $01
	env $0 $00
	vol $3
	note $30 $1c
	vibrato $f1
	env $0 $00
	vol $7
	note $31 $07
	note $32 $07
	note $35 $07
	note $36 $07
	note $38 $07
	note $36 $07
	note $35 $07
	note $32 $07
	note $31 $07
	note $2f $07
	note $2d $07
	note $2c $07
	note $13 $03
	wait1 $04
	vol $3
	note $13 $03
	wait1 $04
	vol $7
	note $13 $03
	wait1 $04
	vol $3
	note $13 $03
	wait1 $04
	vol $7
	note $14 $0e
	note $13 $03
	wait1 $04
	vol $3
	note $13 $03
	wait1 $3c
	vol $6
	note $14 $03
	wait1 $04
	vol $3
	note $14 $03
	wait1 $04
	vol $6
	note $14 $03
	wait1 $04
	vol $3
	note $14 $03
	wait1 $04
	vol $6
	note $15 $0e
	note $14 $03
	wait1 $04
	vol $3
	note $14 $03
	wait1 $3c
	vol $6
	note $15 $03
	wait1 $04
	vol $3
	note $15 $03
	wait1 $04
	vol $6
	note $15 $03
	wait1 $04
	vol $3
	note $15 $03
	wait1 $04
	vol $6
	note $16 $0e
	note $15 $03
	wait1 $04
	vol $3
	note $15 $03
	wait1 $3c
	vol $6
	note $15 $03
	wait1 $04
	vol $3
	note $15 $03
	wait1 $04
	vol $6
	note $15 $03
	wait1 $04
	vol $3
	note $15 $03
	wait1 $04
	vol $6
	note $16 $0e
	note $15 $03
	wait1 $04
	vol $3
	note $15 $03
	wait1 $3c
	vol $6
	note $17 $03
	wait1 $04
	vol $3
	note $17 $03
	wait1 $04
	vol $6
	note $17 $03
	wait1 $04
	vol $3
	note $17 $03
	wait1 $04
	vol $6
	note $18 $0e
	note $17 $03
	wait1 $04
	vol $3
	note $17 $03
	wait1 $3c
	vol $6
	note $17 $03
	wait1 $04
	vol $3
	note $17 $03
	wait1 $04
	vol $6
	note $17 $03
	wait1 $04
	vol $3
	note $17 $03
	wait1 $04
	vol $6
	note $18 $0e
	note $17 $03
	wait1 $04
	vol $3
	note $17 $03
	wait1 $46
	vol $3
	note $28 $07
	note $29 $07
	note $2c $07
	note $2d $07
	note $2f $07
	note $2d $07
	note $2c $07
	note $29 $07
	note $28 $07
	note $29 $07
	vol $3
	note $28 $07
	note $27 $07
	note $28 $77
	wait1 $0b
	goto musicf3598
	cmdff
; $f3750
; @addr{f3750}
sound18Channel4:
	wait1 $1c
	cmdf2
musicf3753:
	duty $0e
	note $12 $1c
	duty $0e
	note $19 $07
	duty $0f
	note $19 $07
	wait1 $0e
	duty $0e
	note $19 $07
	duty $0f
	note $19 $07
	wait1 $0e
	duty $0e
	note $19 $07
	duty $0f
	note $19 $07
	wait1 $0e
	duty $0e
	note $12 $1c
	duty $0e
	note $19 $07
	duty $0f
	note $19 $07
	wait1 $0e
	duty $0e
	note $19 $07
	duty $0f
	note $19 $07
	wait1 $0e
	duty $0e
	note $19 $07
	duty $0f
	note $19 $07
	wait1 $0e
	duty $0e
	note $12 $1c
	duty $0e
	note $19 $07
	duty $0f
	note $19 $07
	wait1 $0e
	duty $0e
	note $19 $07
	duty $0f
	note $19 $07
	wait1 $0e
	duty $0e
	note $19 $07
	duty $0f
	note $19 $07
	wait1 $0e
	duty $0e
	note $12 $1c
	duty $0e
	note $19 $07
	duty $0f
	note $19 $07
	wait1 $0e
	duty $0e
	note $19 $07
	duty $0f
	note $19 $07
	wait1 $2a
	duty $0e
	note $12 $1c
	duty $0e
	note $19 $07
	duty $0f
	note $19 $07
	wait1 $0e
	duty $0e
	note $19 $07
	duty $0f
	note $19 $07
	wait1 $0e
	duty $0e
	note $19 $07
	duty $0f
	note $19 $07
	wait1 $0e
	duty $0e
	note $12 $1c
	duty $0e
	note $19 $07
	duty $0f
	note $19 $07
	wait1 $0e
	duty $0e
	note $19 $07
	duty $0f
	note $19 $07
	wait1 $0e
	duty $0e
	note $19 $07
	duty $0f
	note $19 $07
	wait1 $0e
	duty $0e
	note $12 $1c
	duty $0e
	note $19 $07
	duty $0f
	note $19 $07
	wait1 $0e
	duty $0e
	note $19 $07
	duty $0f
	note $19 $07
	wait1 $0e
	duty $0e
	note $19 $07
	duty $0f
	note $19 $07
	wait1 $0e
	duty $0e
	note $12 $07
	duty $0f
	note $12 $07
	wait1 $0e
	duty $0e
	note $0d $07
	note $0e $07
	note $11 $07
	note $12 $07
	note $14 $07
	note $12 $07
	note $11 $07
	note $0e $07
	note $0d $07
	note $0e $07
	note $0d $07
	duty $0f
	note $0d $07
	duty $0e
	note $0d $03
	duty $0f
	note $0d $06
	wait1 $05
	duty $0e
	note $0d $03
	duty $0f
	note $0d $06
	wait1 $05
	duty $0e
	note $0e $0e
	duty $0e
	note $0d $03
	duty $0f
	note $0d $06
	wait1 $3d
	duty $0e
	note $0d $03
	duty $0f
	note $0d $06
	wait1 $05
	duty $0e
	note $0d $03
	duty $0f
	note $0d $06
	wait1 $05
	duty $0e
	note $0e $0e
	duty $0e
	note $0d $03
	duty $0f
	note $0d $06
	wait1 $3d
	duty $0e
	note $0e $03
	duty $0f
	note $0e $06
	wait1 $05
	duty $0e
	note $0e $03
	duty $0f
	note $0e $06
	wait1 $05
	duty $0e
	note $0f $0e
	duty $0e
	note $0e $03
	duty $0f
	note $0e $06
	wait1 $3d
	duty $0e
	note $0e $03
	duty $0f
	note $0e $06
	wait1 $05
	duty $0e
	note $0e $03
	duty $0f
	note $0e $06
	wait1 $05
	duty $0e
	note $0f $0e
	duty $0e
	note $0e $03
	duty $0f
	note $0e $06
	wait1 $3d
	duty $0e
	note $10 $03
	duty $0f
	note $10 $06
	wait1 $05
	duty $0e
	note $10 $03
	duty $0f
	note $10 $06
	wait1 $05
	duty $0e
	note $11 $0e
	duty $0e
	note $10 $03
	duty $0f
	note $10 $06
	wait1 $3d
	duty $0e
	note $10 $03
	duty $0f
	note $10 $06
	wait1 $05
	duty $0e
	note $10 $03
	duty $0f
	note $10 $06
	wait1 $05
	duty $0e
	note $11 $0e
	duty $0e
	note $10 $03
	duty $0f
	note $10 $06
	wait1 $ad
	duty $0e
	note $10 $07
	note $11 $07
	note $10 $07
	note $0f $07
	note $10 $07
	note $11 $07
	note $14 $07
	note $11 $07
	note $10 $07
	note $11 $07
	note $10 $07
	note $0f $07
	note $10 $1c
	goto musicf3753
	cmdff
; $f3949
; @addr{f3949}
sound1fChannel1:
	vibrato $e1
	env $0 $00
	cmdf2
	duty $01
musicf3950:
	vol $0
	note $20 $24
	vol $6
	note $29 $24
	note $30 $24
	note $29 $24
	note $27 $24
	note $2e $12
	vol $3
	note $2e $12
	vol $6
	note $2e $36
	vol $3
	note $2e $12
	vol $1
	note $2e $12
	wait1 $12
	vol $6
	note $29 $24
	note $30 $24
	note $35 $24
	note $33 $24
	note $2b $24
	note $2c $0d
	wait1 $05
	vol $4
	note $2c $04
	wait1 $05
	vol $2
	note $2c $04
	wait1 $05
	vol $6
	note $33 $12
	vol $3
	note $33 $12
	vol $6
	note $33 $48
	note $31 $24
	note $33 $12
	note $31 $12
	note $30 $24
	note $2e $24
	note $2c $12
	vol $3
	note $2c $12
	vol $6
	note $30 $12
	vol $3
	note $30 $12
	vol $6
	note $30 $24
	note $2e $1b
	vol $3
	note $2e $09
	vol $6
	note $37 $24
	note $35 $24
	note $34 $5a
	vibrato $01
	env $0 $00
	vol $3
	note $34 $24
	vol $1
	note $34 $24
	vol $0
	note $34 $12
	vibrato $e1
	env $0 $00
	vol $6
	note $35 $24
	note $30 $24
	note $2c $24
	note $2e $24
	note $33 $09
	wait1 $04
	vol $3
	note $33 $09
	wait1 $05
	vol $1
	note $33 $09
	vol $6
	note $33 $48
	vibrato $01
	env $0 $00
	vol $3
	note $33 $24
	vibrato $e1
	env $0 $00
	vol $6
	note $3a $12
	note $38 $12
	note $37 $12
	vol $6
	note $35 $12
	note $33 $12
	note $31 $12
	note $30 $24
	vol $6
	note $35 $09
	wait1 $04
	vol $4
	note $35 $05
	wait1 $04
	vol $2
	note $35 $05
	wait1 $09
	vol $6
	note $35 $09
	wait1 $04
	vol $4
	note $35 $05
	wait1 $04
	vol $2
	note $35 $05
	wait1 $09
	vol $6
	note $29 $12
	vol $3
	note $29 $12
	vol $6
	note $33 $48
	vol $7
	note $31 $48
	vibrato $01
	env $0 $00
	vol $3
	note $31 $24
	vol $1
	note $31 $24
	wait1 $12
	vibrato $e1
	env $0 $00
	vol $6
	note $31 $12
	note $33 $12
	vol $6
	note $31 $12
	note $30 $48
	note $2e $48
	vibrato $01
	env $0 $00
	vol $3
	note $2e $24
	vol $1
	note $2e $24
	wait1 $48
	vibrato $e1
	env $0 $00
	goto musicf3950
	cmdff
; $f3a50
; @addr{f3a50}
sound1fChannel0:
	vibrato $e1
	env $0 $00
	cmdf2
	duty $01
musicf3a57:
	vol $6
	note $16 $24
	note $19 $24
	note $20 $24
	note $19 $24
	note $18 $24
	note $1f $24
	note $22 $24
	note $18 $24
	vol $3
	note $18 $12
	wait1 $12
	vol $6
	note $19 $24
	note $20 $24
	note $19 $24
	note $18 $24
	note $1f $24
	note $1d $24
	vol $3
	note $1d $12
	wait1 $12
	vol $6
	note $16 $12
	note $18 $12
	note $19 $12
	note $20 $12
	note $1f $24
	note $1b $24
	note $20 $24
	note $1f $24
	note $1d $24
	note $1b $24
	note $19 $7e
	vol $3
	note $19 $12
	vol $6
	note $18 $12
	note $19 $12
	note $18 $12
	note $19 $12
	note $18 $24
	vol $6
	note $24 $09
	wait1 $04
	vol $3
	note $24 $09
	wait1 $05
	vol $1
	note $24 $09
	vol $6
	note $19 $24
	vol $6
	note $20 $24
	note $24 $24
	note $19 $24
	note $18 $24
	note $1f $24
	note $22 $24
	note $18 $24
	note $19 $24
	note $20 $24
	note $24 $24
	note $19 $24
	note $18 $24
	note $22 $24
	note $20 $24
	vol $3
	note $20 $12
	wait1 $12
	vol $6
	note $16 $24
	note $18 $24
	note $19 $24
	note $1b $24
	note $1d $24
	note $1f $24
	note $20 $24
	note $22 $24
	note $1b $24
	note $1d $24
	note $1f $24
	note $20 $24
	note $22 $24
	note $24 $24
	note $25 $24
	note $27 $24
	goto musicf3a57
	cmdff
; $f3afb
; @addr{f3afb}
sound1fChannel4:
	cmdf2
	duty $08
musicf3afe:
	wait1 $31
	note $29 $24
	note $30 $24
	note $29 $24
	note $27 $24
	note $2e $12
	wait1 $12
	note $2e $36
	wait1 $36
	note $29 $24
	note $30 $24
	note $35 $24
	note $33 $24
	note $2b $24
	note $2c $0e
	wait1 $16
	note $33 $12
	wait1 $12
	note $33 $48
	note $31 $24
	note $33 $12
	note $31 $12
	note $30 $24
	note $2e $24
	note $2c $24
	note $30 $12
	wait1 $12
	note $30 $24
	note $2e $24
	note $37 $24
	note $35 $24
	note $34 $5a
	wait1 $5a
	note $35 $24
	note $30 $24
	note $2c $24
	note $2e $24
	note $33 $09
	wait1 $1b
	note $33 $48
	note $33 $24
	note $3a $12
	note $38 $12
	note $37 $12
	note $35 $12
	note $33 $12
	note $31 $12
	note $30 $24
	note $35 $09
	wait1 $1b
	note $35 $09
	wait1 $1b
	note $29 $24
	note $33 $48
	note $31 $48
	wait1 $5a
	note $31 $12
	note $33 $12
	vol $3
	note $31 $12
	note $30 $48
	note $2e $48
	wait1 $83
	goto musicf3afe
	cmdff
; $f3b7f
sound40Start:
; @addr{f3b7f}
sound40Channel1:
	vol $0
	note $20 $10
	vibrato $e1
	env $0 $00
	duty $01
	vol $6
	note $2e $04
	wait1 $04
	vol $4
	note $2e $04
	wait1 $04
	vol $6
	note $29 $05
	note $2e $05
	note $35 $06
	note $3a $30
	vibrato $01
	env $0 $00
	vol $4
	note $3a $10
	vibrato $e1
	env $0 $00
	duty $02
	vol $6
	note $32 $0a
	note $2e $0b
	note $29 $0b
	note $25 $04
	wait1 $04
	vol $4
	note $25 $04
	wait1 $04
	vol $6
	note $22 $05
	note $25 $05
	note $2a $06
	note $2e $18
	vibrato $01
	env $0 $00
	vol $4
	note $2e $08
	vibrato $e1
	env $0 $00
	vol $6
	note $27 $04
	wait1 $04
	vol $4
	note $27 $04
	wait1 $04
	vol $6
	note $24 $05
	note $27 $05
	note $2c $06
	note $30 $18
	vibrato $01
	env $0 $00
	vol $4
	note $30 $08
	vibrato $e1
	env $0 $00
	vol $6
	note $2e $08
	wait1 $04
	vol $4
	note $2e $08
	wait1 $04
	vol $6
	note $29 $08
	note $26 $30
	vibrato $01
	env $0 $00
	vol $4
	note $26 $10
	vibrato $e1
	env $0 $00
	vol $6
	note $2e $08
	note $2d $08
	note $2e $08
	note $30 $08
	vol $6
	note $31 $08
	note $2e $08
	note $30 $08
	note $31 $08
	note $33 $20
	vibrato $01
	env $0 $00
	vol $4
	note $33 $08
	vibrato $e1
	env $0 $00
	vol $6
	note $30 $08
	note $31 $08
	note $33 $08
	note $35 $08
	note $31 $08
	note $33 $08
	note $35 $08
	note $37 $24
	vibrato $01
	env $0 $00
	vol $4
	note $37 $09
	vibrato $e1
	env $0 $00
	vol $6
	note $33 $09
	note $35 $09
	note $37 $09
	note $39 $42
	vibrato $01
	env $0 $00
	vol $4
	note $39 $16
	vol $2
	note $39 $16
	cmdff
; $f3c53
; @addr{f3c53}
sound40Channel0:
	vol $0
	note $20 $10
	vibrato $e1
	env $0 $00
	duty $01
	vol $6
	note $26 $04
	wait1 $04
	vol $4
	note $26 $04
	wait1 $04
	vol $6
	note $1d $05
	note $22 $05
	note $26 $06
	note $29 $10
	note $20 $05
	note $22 $05
	note $27 $06
	note $29 $18
	note $28 $04
	note $27 $04
	note $26 $20
	duty $02
	note $1e $18
	vol $4
	note $1e $08
	vol $6
	note $1e $05
	note $19 $05
	note $1e $06
	note $22 $05
	note $1e $05
	note $22 $06
	note $20 $18
	vol $4
	note $20 $08
	vol $6
	note $20 $05
	note $1b $05
	note $20 $06
	note $24 $05
	note $20 $05
	note $24 $06
	note $1d $08
	wait1 $04
	vol $4
	note $1d $04
	vol $6
	note $16 $08
	note $1d $08
	note $22 $18
	vol $4
	note $22 $08
	vol $5
	note $35 $04
	wait1 $04
	note $2e $04
	vol $3
	note $35 $04
	vol $5
	note $32 $04
	vol $3
	note $2e $04
	vol $5
	note $29 $04
	vol $3
	note $32 $04
	vol $6
	note $29 $08
	note $22 $08
	note $25 $08
	note $29 $08
	vol $6
	note $2a $20
	vol $4
	note $2a $08
	vol $6
	note $27 $08
	note $29 $08
	note $2a $08
	note $2c $08
	note $27 $08
	note $29 $08
	note $2a $08
	note $2c $08
	note $29 $08
	note $2a $08
	note $2c $08
	note $2e $1b
	vol $4
	note $2e $09
	vol $6
	note $2e $09
	note $2b $09
	note $2d $09
	note $2e $09
	note $30 $42
	vibrato $01
	env $0 $00
	vol $4
	note $30 $16
	vol $2
	note $30 $16
	cmdff
; $f3d0b
; @addr{f3d0b}
sound40Channel4:
	wait1 $10
	duty $0e
	note $16 $20
	vol $4
	note $16 $08
	wait1 $08
	duty $0e
	note $11 $04
	duty $0f
	note $11 $04
	duty $0e
	note $11 $04
	duty $0f
	note $11 $04
	duty $0e
	note $16 $08
	vol $4
	note $16 $08
	duty $0e
	note $11 $08
	vol $4
	note $11 $08
	duty $0e
	note $16 $08
	vol $4
	note $16 $08
	duty $0e
	note $14 $10
	note $12 $10
	note $19 $10
	note $1e $08
	note $19 $08
	note $12 $04
	duty $0f
	note $12 $04
	duty $0e
	note $12 $04
	duty $0f
	note $12 $04
	duty $0e
	note $14 $10
	note $1b $10
	note $20 $08
	note $1b $08
	note $14 $04
	duty $0f
	note $14 $04
	duty $0e
	note $14 $04
	duty $0f
	note $14 $04
	duty $0e
	note $16 $20
	vol $4
	note $16 $08
	wait1 $08
	duty $0e
	note $1d $05
	note $1a $05
	note $16 $06
	note $11 $10
	note $0e $05
	note $0a $05
	note $0e $06
	note $1a $10
	note $11 $04
	duty $0f
	note $11 $04
	duty $0e
	note $11 $08
	note $1b $20
	note $0f $10
	note $1b $04
	duty $0f
	note $1b $04
	duty $0e
	note $1b $04
	duty $0f
	note $1b $04
	duty $0e
	note $1b $20
	note $0f $10
	note $1b $08
	duty $0f
	note $1b $08
	duty $0e
	note $1d $12
	note $11 $04
	duty $0f
	note $11 $05
	wait1 $09
	duty $0e
	note $1d $24
	note $1f $2c
	note $21 $2c
	duty $0f
	note $21 $16
	cmdff
; $f3dc9
; @addr{f3dc9}
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
; $f3f8f
soundc7Start:
; @addr{f3f8f}
soundc7Channel2:
	duty $00
	vol $d
	cmdf8 $c4
	note $15 $0a
	cmdf8 $00
	vol $e
	cmdf8 $37
	note $11 $0f
	cmdf8 $00
	cmdff
; $f3fa0
sound96Start:
; @addr{f3fa0}
sound96Channel2:
	duty $02
	vol $1
	note $45 $08
	vol $2
	note $46 $08
	vol $3
	note $3f $08
	vol $4
	note $40 $08
	vol $6
	note $45 $08
	vol $8
	note $46 $08
	vol $9
	note $3f $08
	vol $a
	note $40 $08
	vol $b
	note $45 $08
	vol $3
	note $46 $08
	vol $2
	note $3f $08
	vol $1
	env $0 $07
	note $40 $08
	cmdff
; $f3fc9
sound9aStart:
; @addr{f3fc9}
sound9aChannel2:
	vol $9
	note $4d $08
	note $50 $08
	note $4f $08
	note $50 $08
	note $4d $08
	note $50 $08
	note $4f $08
	note $50 $08
	cmdff
; $f3fdb
sound9bStart:
; @addr{f3fdb}
sound9bChannel2:
	vol $8
	env $0 $02
	note $3b $0a
	note $3d $0a
	note $3e $0a
	note $45 $0f
	cmdff
; $f3fe7
sounda6Start:
; @addr{f3fe7}
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
; $f3ffc
; GAP
	cmdff
	cmdff
	cmdff
	cmdff
.bank $3d slot 1
.org 0
sound1bStart:
sound26Start:
sound27Start:
sound31Start:
sound38Start:
sound46Start:
; @addr{f4000}
sound1bChannel6:
sound26Channel6:
sound27Channel6:
sound31Channel4:
sound31Channel6:
sound38Channel6:
sound46Channel6:
	cmdff
; $f4001
sound20Start:
; @addr{f4001}
sound20Channel1:
	vibrato $00
	env $0 $00
	duty $02
musicf4007:
	vol $0
	note $20 $20
	vol $6
	note $28 $04
	wait1 $02
	vol $3
	note $28 $02
	vol $6
	note $28 $04
	wait1 $02
	vol $3
	note $28 $02
	vol $6
	note $28 $04
	wait1 $02
	vol $3
	note $28 $02
	vol $6
	note $28 $04
	wait1 $02
	vol $3
	note $28 $02
	vol $6
	note $28 $04
	wait1 $02
	vol $3
	note $28 $04
	wait1 $02
	vol $1
	note $28 $04
	vol $6
	note $26 $04
	wait1 $04
	vol $3
	note $26 $04
	wait1 $04
	vol $6
	note $26 $04
	wait1 $04
	vol $3
	note $26 $04
	wait1 $04
	vol $6
	note $2b $04
	wait1 $04
	vol $3
	note $2b $04
	wait1 $04
	vol $6
	note $2b $04
	wait1 $04
	vol $3
	note $2b $04
	wait1 $04
	vol $6
	note $2a $04
	wait1 $04
	vol $3
	note $2a $04
	wait1 $04
	vol $1
	note $2a $04
	wait1 $1c
	vol $6
	note $2b $04
	wait1 $02
	vol $3
	note $2b $02
	vol $6
	note $2b $04
	wait1 $02
	vol $3
	note $2b $02
	vol $6
	note $2b $04
	wait1 $02
	vol $3
	note $2b $02
	vol $6
	note $2b $04
	wait1 $02
	vol $3
	note $2b $02
	vol $6
	note $2b $04
	wait1 $02
	vol $3
	note $2b $04
	wait1 $06
	vol $6
	note $2a $04
	wait1 $04
	vol $3
	note $2a $04
	wait1 $04
	vol $6
	note $2a $04
	wait1 $04
	vol $3
	note $2a $04
	wait1 $04
	vol $6
	note $28 $04
	wait1 $04
	vol $3
	note $28 $04
	wait1 $04
	vol $6
	note $28 $04
	wait1 $04
	vol $3
	note $28 $04
	wait1 $04
	vol $6
	note $2a $04
	wait1 $04
	vol $3
	note $2a $04
	wait1 $04
	vol $1
	note $2a $04
	wait1 $1c
	vol $6
	note $28 $04
	wait1 $02
	vol $3
	note $28 $02
	vol $6
	note $28 $04
	wait1 $02
	vol $3
	note $28 $02
	vol $6
	note $28 $04
	wait1 $02
	vol $3
	note $28 $02
	vol $6
	note $28 $04
	wait1 $02
	vol $3
	note $28 $02
	vol $6
	note $28 $04
	wait1 $02
	vol $3
	note $28 $04
	wait1 $06
	vol $6
	note $26 $04
	wait1 $04
	vol $3
	note $26 $04
	wait1 $04
	vol $6
	note $28 $04
	wait1 $04
	vol $3
	note $28 $04
	wait1 $04
	vol $6
	note $2a $04
	wait1 $04
	vol $3
	note $2a $04
	wait1 $04
	vol $6
	note $2b $04
	wait1 $04
	vol $3
	note $2b $04
	wait1 $04
	vol $6
	note $2a $04
	wait1 $04
	vol $3
	note $2a $04
	wait1 $04
	vol $6
	note $28 $04
	wait1 $04
	vol $3
	note $28 $04
	wait1 $04
	vol $6
	note $26 $04
	wait1 $04
	vol $3
	note $26 $04
	wait1 $04
	vol $6
	note $28 $18
	vol $3
	note $28 $08
	vol $6
	note $28 $04
	wait1 $04
	vol $3
	note $28 $04
	wait1 $04
	vol $6
	note $2b $18
	vol $3
	note $2b $08
	vol $6
	note $26 $04
	wait1 $04
	vol $3
	note $26 $04
	wait1 $04
	vol $6
	note $28 $14
	vol $3
	note $28 $0c
	wait1 $20
	vol $6
	note $28 $04
	wait1 $02
	vol $3
	note $28 $02
	vol $6
	note $28 $04
	wait1 $02
	vol $3
	note $28 $02
	vol $6
	note $28 $04
	wait1 $02
	vol $3
	note $28 $02
	vol $6
	note $28 $04
	wait1 $02
	vol $3
	note $28 $02
	vol $6
	note $28 $04
	wait1 $04
	vol $3
	note $28 $04
	wait1 $04
	vol $6
	note $26 $04
	wait1 $04
	vol $3
	note $26 $04
	wait1 $04
	vol $6
	note $26 $04
	wait1 $04
	vol $3
	note $26 $04
	wait1 $04
	vol $6
	note $2b $04
	wait1 $04
	vol $3
	note $2b $04
	wait1 $04
	vol $6
	note $2b $04
	wait1 $04
	vol $3
	note $2b $04
	wait1 $04
	vol $6
	note $2a $04
	wait1 $04
	vol $3
	note $2a $04
	wait1 $24
	vol $6
	note $2f $04
	wait1 $02
	vol $3
	note $2f $02
	vol $6
	note $2f $04
	wait1 $02
	vol $3
	note $2f $02
	vol $6
	note $2f $04
	wait1 $02
	vol $3
	note $2f $02
	vol $6
	note $2f $04
	wait1 $02
	vol $3
	note $2f $02
	vol $6
	note $2f $04
	wait1 $02
	vol $3
	note $2f $04
	wait1 $06
	vol $6
	note $2d $05
	wait1 $03
	vol $3
	note $2d $05
	wait1 $03
	vol $6
	note $2f $05
	wait1 $03
	vol $3
	note $2f $05
	wait1 $03
	vol $6
	note $30 $05
	wait1 $03
	vol $3
	note $30 $05
	wait1 $03
	vol $6
	note $32 $05
	wait1 $03
	vol $3
	note $32 $05
	wait1 $03
	vol $6
	note $30 $05
	wait1 $03
	vol $3
	note $30 $05
	wait1 $23
	vol $6
	note $2f $04
	wait1 $02
	vol $3
	note $2f $02
	vol $6
	note $2f $04
	wait1 $02
	vol $3
	note $2f $02
	vol $6
	note $2f $04
	wait1 $02
	vol $3
	note $2f $02
	vol $6
	note $2f $04
	wait1 $02
	vol $3
	note $2f $02
	vol $6
	note $2f $04
	wait1 $02
	vol $3
	note $2f $04
	wait1 $06
	vol $6
	note $30 $04
	wait1 $04
	vol $3
	note $30 $04
	wait1 $04
	vol $6
	note $2f $04
	wait1 $04
	vol $3
	note $2f $04
	wait1 $04
	vol $6
	note $2d $04
	wait1 $04
	vol $3
	note $2d $04
	wait1 $04
	vol $6
	note $28 $04
	wait1 $04
	vol $3
	note $28 $04
	wait1 $04
	vol $6
	note $24 $04
	wait1 $04
	vol $3
	note $24 $04
	wait1 $04
	vol $6
	note $2b $08
	note $2a $08
	note $28 $08
	note $26 $08
	note $28 $30
	vol $3
	note $28 $10
	vol $1
	note $28 $08
	wait1 $18
	goto musicf4007
	cmdff
; $f4292
; @addr{f4292}
sound20Channel0:
	vibrato $00
	env $0 $00
	duty $02
musicf4298:
	vol $0
	note $20 $20
	vol $6
	note $24 $04
	wait1 $02
	vol $3
	note $24 $02
	vol $6
	note $24 $04
	wait1 $02
	vol $3
	note $24 $02
	vol $6
	note $24 $04
	wait1 $02
	vol $3
	note $24 $02
	vol $6
	note $24 $04
	wait1 $02
	vol $3
	note $24 $02
	vol $6
	note $24 $04
	wait1 $02
	vol $3
	note $24 $04
	wait1 $06
	vol $6
	note $23 $04
	wait1 $04
	vol $3
	note $23 $04
	wait1 $04
	vol $6
	note $23 $04
	wait1 $04
	vol $3
	note $23 $04
	wait1 $04
	vol $6
	note $28 $04
	wait1 $04
	vol $3
	note $28 $04
	wait1 $04
	vol $6
	note $28 $04
	wait1 $04
	vol $3
	note $28 $04
	wait1 $04
	vol $6
	note $26 $04
	wait1 $04
	vol $3
	note $26 $04
	wait1 $24
	vol $6
	note $28 $04
	wait1 $02
	vol $3
	note $28 $02
	vol $6
	note $28 $04
	wait1 $02
	vol $3
	note $28 $02
	vol $6
	note $28 $04
	wait1 $02
	vol $3
	note $28 $02
	vol $6
	note $28 $04
	wait1 $02
	vol $3
	note $28 $02
	vol $6
	note $28 $04
	wait1 $02
	vol $3
	note $28 $04
	wait1 $06
	vol $6
	note $26 $04
	wait1 $04
	vol $3
	note $26 $04
	wait1 $04
	vol $6
	note $26 $04
	wait1 $04
	vol $3
	note $26 $04
	wait1 $04
	vol $6
	note $24 $04
	wait1 $04
	vol $3
	note $24 $04
	wait1 $04
	vol $6
	note $24 $04
	wait1 $04
	vol $3
	note $24 $04
	wait1 $04
	vol $6
	note $26 $04
	wait1 $04
	vol $3
	note $26 $04
	wait1 $24
	vol $6
	note $24 $04
	wait1 $02
	vol $3
	note $24 $02
	vol $6
	note $24 $04
	wait1 $02
	vol $3
	note $24 $02
	vol $6
	note $24 $04
	wait1 $02
	vol $3
	note $24 $02
	vol $6
	note $24 $04
	wait1 $02
	vol $3
	note $24 $02
	vol $6
	note $24 $04
	wait1 $02
	vol $3
	note $24 $04
	wait1 $06
	vol $6
	note $23 $04
	wait1 $04
	vol $3
	note $23 $04
	wait1 $04
	vol $6
	note $24 $04
	wait1 $04
	vol $3
	note $24 $04
	wait1 $04
	vol $6
	note $26 $04
	wait1 $04
	vol $3
	note $26 $04
	wait1 $04
	vol $6
	note $28 $04
	wait1 $04
	vol $3
	note $28 $04
	wait1 $04
	vol $6
	note $26 $04
	wait1 $04
	vol $3
	note $26 $04
	wait1 $04
	vol $6
	note $24 $04
	wait1 $04
	vol $3
	note $24 $04
	wait1 $04
	vol $6
	note $23 $04
	wait1 $04
	vol $3
	note $23 $04
	wait1 $04
	vol $6
	note $24 $14
	vol $3
	note $24 $0c
	vol $6
	note $24 $04
	wait1 $04
	vol $3
	note $24 $04
	wait1 $04
	vol $6
	note $26 $18
	vol $3
	note $26 $08
	vol $6
	note $23 $04
	wait1 $04
	vol $3
	note $23 $04
	wait1 $04
	vol $6
	note $24 $14
	vol $3
	note $24 $0c
	wait1 $20
	vol $6
	note $24 $04
	wait1 $02
	vol $3
	note $24 $02
	vol $6
	note $24 $04
	wait1 $02
	vol $3
	note $24 $02
	vol $6
	note $24 $04
	wait1 $02
	vol $3
	note $24 $02
	vol $6
	note $24 $04
	wait1 $02
	vol $3
	note $24 $02
	vol $6
	note $24 $04
	wait1 $02
	vol $3
	note $24 $04
	wait1 $06
	vol $6
	note $23 $04
	wait1 $04
	vol $3
	note $23 $04
	wait1 $04
	vol $6
	note $23 $04
	wait1 $04
	vol $3
	note $23 $04
	wait1 $04
	vol $6
	note $24 $04
	wait1 $04
	vol $3
	note $24 $04
	wait1 $04
	vol $6
	note $28 $04
	wait1 $04
	vol $3
	note $28 $04
	wait1 $04
	vol $6
	note $26 $04
	wait1 $04
	vol $3
	note $26 $04
	wait1 $24
	vol $6
	note $28 $04
	wait1 $02
	vol $3
	note $28 $02
	vol $6
	note $28 $04
	wait1 $02
	vol $3
	note $28 $02
	vol $6
	note $28 $04
	wait1 $02
	vol $3
	note $28 $02
	vol $6
	note $28 $04
	wait1 $02
	vol $3
	note $28 $02
	vol $6
	note $28 $04
	wait1 $02
	vol $3
	note $28 $04
	wait1 $06
	vol $6
	note $26 $04
	wait1 $04
	vol $3
	note $26 $04
	wait1 $04
	vol $6
	note $26 $04
	wait1 $04
	vol $3
	note $26 $04
	wait1 $04
	vol $6
	note $29 $04
	wait1 $04
	vol $3
	note $29 $04
	wait1 $04
	vol $6
	note $28 $04
	wait1 $04
	vol $3
	note $28 $04
	wait1 $04
	vol $6
	note $24 $04
	wait1 $04
	vol $3
	note $24 $04
	wait1 $24
	vol $6
	note $2b $04
	wait1 $02
	vol $3
	note $2b $02
	vol $6
	note $2b $04
	wait1 $02
	vol $3
	note $2b $02
	vol $6
	note $2b $04
	wait1 $02
	vol $3
	note $2b $02
	vol $6
	note $2b $04
	wait1 $02
	vol $3
	note $2b $02
	vol $6
	note $2b $04
	wait1 $02
	vol $3
	note $2b $04
	wait1 $06
	vol $6
	note $2d $04
	wait1 $04
	vol $3
	note $2d $04
	wait1 $04
	vol $6
	note $2b $04
	wait1 $04
	vol $3
	note $2b $04
	wait1 $04
	vol $6
	note $28 $04
	wait1 $04
	vol $3
	note $28 $04
	wait1 $04
	vol $6
	note $24 $04
	wait1 $04
	vol $3
	note $24 $04
	wait1 $04
	vol $6
	note $21 $04
	wait1 $04
	vol $3
	note $21 $04
	wait1 $84
	goto musicf4298
	cmdff
; $f4503
; @addr{f4503}
sound20Channel4:
musicf4503:
	duty $0e
	note $15 $20
	note $21 $04
	wait1 $04
	note $21 $04
	wait1 $04
	note $21 $04
	wait1 $04
	note $21 $04
	wait1 $04
	note $21 $04
	wait1 $3c
	note $17 $20
	note $18 $20
	note $24 $04
	wait1 $04
	note $24 $04
	wait1 $04
	note $24 $04
	wait1 $04
	note $24 $04
	wait1 $04
	note $24 $04
	wait1 $0c
	note $23 $04
	wait1 $0c
	note $23 $04
	wait1 $0c
	note $21 $04
	wait1 $0c
	note $21 $04
	wait1 $0c
	note $23 $04
	wait1 $0c
	note $15 $20
	note $21 $04
	wait1 $04
	note $21 $04
	wait1 $04
	note $21 $04
	wait1 $04
	note $21 $04
	wait1 $04
	note $21 $04
	wait1 $1c
	note $17 $3c
	wait1 $04
	note $17 $20
	note $15 $12
	wait1 $0e
	note $15 $08
	wait1 $08
	note $17 $1c
	wait1 $04
	note $13 $04
	wait1 $0c
	note $15 $14
	wait1 $0c
	note $15 $20
	note $21 $04
	wait1 $04
	note $21 $04
	wait1 $04
	note $21 $04
	wait1 $04
	note $21 $04
	wait1 $04
	note $21 $04
	wait1 $1c
	note $17 $14
	wait1 $0c
	note $1c $05
	wait1 $0b
	note $1a $05
	wait1 $0b
	note $18 $20
	note $24 $04
	wait1 $04
	note $24 $04
	wait1 $04
	note $24 $04
	wait1 $04
	note $24 $04
	wait1 $04
	note $24 $04
	wait1 $1c
	note $17 $20
	note $10 $0d
	wait1 $03
	note $13 $0d
	wait1 $03
	note $15 $20
	note $24 $04
	wait1 $04
	note $24 $04
	wait1 $04
	note $24 $04
	wait1 $04
	note $24 $04
	wait1 $04
	duty $0e
	note $24 $04
	duty $0f
	note $24 $0c
	duty $0e
	note $1c $04
	duty $0f
	note $1c $0c
	duty $0e
	note $1c $04
	duty $0f
	note $1c $0c
	duty $0e
	note $18 $04
	duty $0f
	note $18 $0c
	duty $0e
	note $18 $04
	duty $0f
	note $18 $0c
	duty $0e
	note $15 $04
	duty $0f
	note $15 $0c
	duty $0e
	note $1a $20
	note $15 $08
	wait1 $08
	note $12 $20
	note $15 $08
	wait1 $08
	note $0e $20
	goto musicf4503
	cmdff
; $f460f
; @addr{f460f}
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
; $f47de
sound21Start:
; @addr{f47de}
sound21Channel1:
	vibrato $e1
	env $0 $00
	duty $02
musicf47e4:
	vol $6
	note $26 $07
	wait1 $03
	vol $3
	note $26 $04
	vol $6
	note $26 $03
	vol $3
	note $26 $04
	vol $6
	note $26 $03
	vol $3
	note $26 $04
	vol $6
	note $29 $54
	vibrato $01
	env $0 $00
	vol $5
	note $29 $1c
	vol $1
	note $29 $1c
	vibrato $e1
	env $0 $00
	vol $6
	note $28 $2a
	vol $3
	note $28 $0e
	vol $6
	note $27 $0e
	note $21 $07
	wait1 $03
	vol $3
	note $21 $04
	note $27 $0e
	note $21 $07
	wait1 $03
	vol $1
	note $21 $04
	note $27 $0e
	note $21 $07
	wait1 $03
	vol $0
	note $21 $04
	note $27 $0e
	note $21 $07
	wait1 $03
	vol $0
	note $21 $04
	vol $6
	note $27 $0e
	note $2d $07
	wait1 $03
	vol $3
	note $2d $04
	vol $5
	note $33 $0e
	note $39 $07
	wait1 $03
	vol $2
	note $39 $04
	vol $3
	note $27 $0e
	note $2d $07
	wait1 $03
	vol $1
	note $2d $04
	vol $2
	note $33 $0e
	note $39 $07
	wait1 $03
	vol $1
	note $39 $04
	vol $6
	note $29 $07
	wait1 $03
	vol $3
	note $29 $04
	vol $6
	note $29 $03
	vol $3
	note $29 $04
	vol $6
	note $29 $03
	vol $3
	note $29 $04
	vol $6
	note $2c $54
	vibrato $01
	env $0 $00
	vol $4
	note $2c $38
	vol $2
	note $2c $1c
	vibrato $e1
	env $0 $00
	vol $6
	note $2b $0e
	note $2c $07
	note $2b $07
	note $2a $0e
	note $25 $07
	wait1 $03
	vol $3
	note $25 $04
	note $2a $0e
	note $25 $07
	wait1 $03
	vol $1
	note $25 $04
	note $2a $0e
	note $25 $07
	wait1 $03
	vol $0
	note $25 $04
	note $2a $0e
	note $25 $07
	wait1 $03
	vol $0
	note $25 $04
	vol $6
	note $2b $0e
	note $25 $07
	wait1 $03
	vol $3
	note $25 $04
	note $2b $0e
	note $25 $07
	wait1 $03
	vol $1
	note $25 $04
	vol $6
	note $2b $0e
	note $31 $07
	wait1 $03
	vol $3
	note $31 $04
	note $2b $0e
	note $31 $07
	wait1 $03
	vol $1
	note $31 $04
	vol $6
	note $2d $07
	note $34 $07
	note $39 $07
	wait1 $03
	vol $3
	note $39 $04
	vol $6
	note $2d $07
	note $34 $07
	note $39 $07
	wait1 $03
	vol $3
	note $39 $04
	vol $6
	note $2e $07
	note $35 $07
	note $3a $07
	wait1 $03
	vol $3
	note $3a $07
	wait1 $19
	vol $6
	note $2d $07
	note $34 $07
	note $39 $07
	wait1 $03
	vol $3
	note $39 $04
	vol $6
	note $2d $07
	note $34 $07
	note $39 $07
	wait1 $03
	vol $3
	note $39 $04
	vol $6
	note $38 $07
	note $2c $03
	wait1 $04
	note $2c $07
	wait1 $03
	vol $3
	note $2c $07
	wait1 $19
	vol $6
	note $2d $07
	note $34 $07
	vol $6
	note $39 $07
	wait1 $03
	vol $3
	note $39 $04
	vol $6
	note $2e $07
	note $35 $07
	note $3a $07
	wait1 $03
	vol $3
	note $3a $04
	vol $6
	note $2f $07
	note $36 $07
	note $3b $07
	wait1 $03
	vol $3
	note $3b $04
	vol $6
	note $30 $07
	note $37 $07
	note $3c $07
	wait1 $03
	vol $3
	note $3c $04
	vol $6
	note $3e $07
	note $3d $07
	note $3f $07
	note $3e $07
	note $3d $07
	note $3c $07
	note $3e $07
	note $3d $07
	note $3c $07
	note $3b $07
	note $3d $07
	note $3c $07
	note $3b $07
	note $3a $07
	note $3c $07
	note $3b $07
	goto musicf47e4
	cmdff
; $f4976
; @addr{f4976}
sound21Channel0:
	vibrato $e1
	env $0 $00
	duty $02
musicf497c:
	vol $6
	note $15 $07
	wait1 $07
	note $17 $07
	vol $3
	note $15 $07
	vol $6
	note $18 $07
	vol $3
	note $17 $07
	vol $6
	note $1a $07
	vol $3
	note $18 $07
	vol $6
	note $1b $07
	vol $3
	note $1a $07
	vol $6
	note $1a $07
	vol $3
	note $1b $07
	vol $6
	note $18 $07
	vol $3
	note $1a $07
	vol $6
	note $17 $07
	vol $3
	note $18 $07
	vol $6
	note $15 $07
	vol $3
	note $17 $07
	vol $6
	note $17 $07
	vol $3
	note $15 $07
	vol $6
	note $18 $07
	vol $3
	note $17 $07
	vol $6
	note $1a $07
	vol $3
	note $18 $07
	vol $6
	note $1b $07
	vol $3
	note $1a $07
	vol $6
	note $1a $07
	vol $3
	note $1b $07
	vol $6
	note $18 $07
	vol $3
	note $1a $07
	vol $6
	note $17 $07
	vol $3
	note $18 $07
	vol $6
	note $15 $07
	vol $3
	note $17 $07
	vol $6
	note $17 $07
	vol $3
	note $15 $07
	vol $6
	note $18 $07
	vol $3
	note $17 $07
	vol $6
	note $1a $07
	vol $3
	note $18 $07
	vol $6
	note $1b $07
	vol $3
	note $1a $07
	vol $6
	note $1a $07
	vol $3
	note $1b $07
	vol $6
	note $18 $07
	vol $3
	note $1a $07
	vol $6
	note $17 $07
	vol $3
	note $18 $07
	vol $6
	note $15 $07
	vol $3
	note $17 $07
	vol $6
	note $17 $07
	vol $3
	note $15 $07
	vol $6
	note $18 $07
	vol $3
	note $17 $07
	vol $6
	note $1a $07
	vol $3
	note $18 $07
	vol $6
	note $1b $07
	vol $3
	note $1a $07
	vol $6
	note $1a $07
	vol $3
	note $1b $07
	vol $6
	note $18 $07
	vol $3
	note $1a $07
	vol $6
	note $17 $07
	vol $3
	note $18 $07
	vol $6
	note $15 $07
	vol $3
	note $17 $07
	vol $6
	note $17 $07
	vol $3
	note $15 $07
	vol $6
	note $18 $07
	vol $3
	note $17 $07
	vol $6
	note $1a $07
	vol $3
	note $18 $07
	vol $6
	note $1b $07
	vol $3
	note $1a $07
	vol $6
	note $1a $07
	vol $3
	note $1b $07
	vol $6
	note $18 $07
	vol $3
	note $1a $07
	vol $6
	note $17 $07
	vol $3
	note $18 $07
	vol $6
	note $15 $07
	vol $3
	note $17 $07
	vol $6
	note $17 $07
	vol $3
	note $15 $07
	vol $6
	note $18 $07
	vol $3
	note $17 $07
	vol $6
	note $1a $07
	vol $3
	note $18 $07
	vol $6
	note $1b $07
	vol $3
	note $1a $07
	vol $6
	note $1a $07
	vol $3
	note $1b $07
	vol $6
	note $18 $07
	vol $3
	note $1a $07
	vol $6
	note $17 $07
	vol $3
	note $18 $07
	vol $6
	note $15 $07
	vol $3
	note $17 $07
	vol $6
	note $17 $07
	vol $3
	note $15 $07
	vol $6
	note $18 $07
	vol $3
	note $17 $07
	vol $6
	note $1a $07
	vol $3
	note $18 $07
	vol $6
	note $1b $07
	vol $3
	note $1a $07
	vol $6
	note $1a $07
	vol $3
	note $1b $07
	vol $6
	note $18 $07
	vol $3
	note $1a $07
	vol $6
	note $17 $07
	vol $3
	note $18 $07
	vol $6
	note $15 $07
	vol $3
	note $17 $07
	vol $6
	note $17 $07
	vol $3
	note $15 $07
	vol $6
	note $18 $07
	vol $3
	note $17 $07
	vol $6
	note $1a $07
	vol $3
	note $18 $07
	vol $6
	note $1b $07
	vol $3
	note $1a $07
	vol $6
	note $1a $07
	vol $3
	note $1b $07
	vol $6
	note $18 $07
	vol $3
	note $1a $07
	vol $6
	note $17 $07
	vol $3
	note $18 $07
	vol $6
	note $19 $07
	vol $3
	note $17 $07
	vol $6
	note $1b $07
	note $1c $07
	note $19 $07
	note $1c $07
	note $1b $07
	note $1c $07
	note $1a $07
	note $1d $07
	note $1c $07
	note $1d $07
	note $1a $07
	note $1d $07
	note $1c $07
	note $1d $07
	note $19 $07
	note $1c $07
	note $1b $07
	note $1c $07
	note $19 $07
	note $1c $07
	note $1b $07
	note $1c $07
	note $18 $07
	note $1b $07
	note $1a $07
	note $1b $07
	note $18 $07
	note $1b $07
	note $1a $07
	note $1b $07
	note $19 $07
	note $1c $07
	note $1b $07
	note $1c $07
	note $1a $07
	note $1d $07
	note $1c $07
	note $1d $07
	note $1b $07
	note $1e $07
	note $1d $07
	note $1e $07
	note $1c $07
	note $1f $07
	vol $6
	note $1e $07
	note $1f $07
	note $3a $07
	note $39 $07
	note $3b $07
	note $3a $07
	note $39 $07
	note $38 $07
	note $3a $07
	note $39 $07
	note $38 $07
	note $37 $07
	note $39 $07
	note $38 $07
	note $37 $07
	note $36 $07
	note $38 $07
	note $37 $07
	goto musicf497c
	cmdff
; $f4b82
; @addr{f4b82}
sound21Channel4:
musicf4b82:
	duty $0e
	note $0e $0e
	note $10 $0e
	note $11 $0e
	note $13 $0e
	note $14 $0e
	note $13 $0e
	note $11 $0e
	note $10 $0e
	note $0e $0e
	note $10 $0e
	note $11 $0e
	note $13 $0e
	note $14 $0e
	note $13 $0e
	note $11 $0e
	note $10 $0e
	note $0e $0e
	note $10 $0e
	note $11 $0e
	note $13 $0e
	note $14 $0e
	note $13 $0e
	note $11 $0e
	note $10 $0e
	note $0e $0e
	note $10 $0e
	note $11 $0e
	note $13 $0e
	note $14 $0e
	note $13 $0e
	note $11 $0e
	note $10 $0e
	note $0e $0e
	note $10 $0e
	note $11 $0e
	note $13 $0e
	note $14 $0e
	note $13 $0e
	note $11 $0e
	note $10 $0e
	note $0e $0e
	note $10 $0e
	note $11 $0e
	note $13 $0e
	note $14 $0e
	note $13 $0e
	note $11 $0e
	note $10 $0e
	note $0e $0e
	note $10 $0e
	note $11 $0e
	note $13 $0e
	note $14 $0e
	note $13 $0e
	note $11 $0e
	note $10 $0e
	note $0e $0e
	note $10 $0e
	note $11 $0e
	note $13 $0e
	note $14 $0e
	note $13 $0e
	note $11 $0e
	note $10 $0e
	note $09 $03
	wait1 $04
	note $09 $03
	wait1 $0b
	note $09 $03
	wait1 $04
	note $09 $03
	wait1 $04
	note $09 $07
	wait1 $07
	note $09 $03
	wait1 $04
	note $0a $03
	wait1 $04
	note $0a $07
	wait1 $07
	note $0a $03
	wait1 $04
	note $0a $03
	wait1 $04
	note $0a $02
	wait1 $05
	note $0a $02
	wait1 $05
	note $0a $03
	wait1 $04
	note $09 $03
	wait1 $04
	note $09 $03
	wait1 $0b
	note $09 $03
	wait1 $04
	note $09 $03
	wait1 $04
	note $09 $07
	wait1 $07
	note $09 $03
	wait1 $04
	note $08 $03
	wait1 $04
	note $08 $07
	wait1 $07
	note $08 $03
	wait1 $04
	note $08 $03
	wait1 $04
	note $08 $02
	wait1 $05
	note $08 $02
	wait1 $05
	note $08 $03
	wait1 $04
	note $09 $03
	wait1 $04
	note $09 $07
	wait1 $07
	note $09 $03
	wait1 $04
	note $0a $03
	wait1 $04
	note $0a $07
	wait1 $07
	note $0a $03
	wait1 $04
	note $0b $03
	wait1 $04
	note $0b $07
	wait1 $07
	note $0b $03
	wait1 $04
	note $0c $03
	wait1 $04
	note $0c $07
	wait1 $07
	note $0c $07
	note $0d $07
	note $0e $07
	note $0c $07
	note $0d $07
	note $0b $07
	note $0c $07
	note $0a $07
	note $0b $07
	note $09 $07
	note $0a $07
	note $08 $07
	note $09 $07
	note $07 $07
	note $08 $07
	note $06 $07
	note $07 $07
	goto musicf4b82
	cmdff
; $f4cbe
; @addr{f4cbe}
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
; $f4e9a
sound23Start:
; @addr{f4e9a}
sound23Channel1:
	vibrato $e1
	env $0 $00
	duty $02
musicf4ea0:
	vol $6
	note $15 $0e
	note $14 $08
	note $15 $0e
	note $17 $08
	note $18 $0e
	note $17 $08
	note $18 $0e
	note $1a $08
	note $1b $0e
	note $1c $08
	note $1b $0e
	note $1c $08
	wait1 $2c
	note $2d $0e
	note $2c $08
	note $2d $0e
	note $2c $08
	note $2b $0e
	note $2a $08
	note $2b $0e
	note $2a $08
	note $29 $0e
	note $28 $08
	note $29 $0e
	note $28 $08
	wait1 $2c
	note $34 $0e
	note $33 $08
	note $34 $0e
	note $33 $08
	note $32 $0e
	note $31 $08
	note $32 $0e
	note $31 $08
	note $30 $0e
	note $2f $08
	note $30 $0e
	note $2f $08
	note $2e $0e
	note $2d $08
	note $2e $0e
	vol $6
	note $2d $08
	note $2c $2c
	note $29 $16
	note $2c $0e
	note $29 $08
	note $28 $07
	wait1 $1d
	note $26 $08
	note $24 $07
	wait1 $0f
	note $23 $07
	wait1 $0f
	vol $6
	note $28 $0e
	note $27 $08
	note $28 $0e
	note $27 $08
	note $28 $07
	wait1 $04
	vol $3
	note $28 $07
	wait1 $04
	vol $6
	note $2d $07
	wait1 $04
	vol $3
	note $2d $07
	wait1 $04
	vol $6
	note $27 $0e
	note $26 $08
	note $27 $0e
	note $26 $08
	wait1 $03
	vol $3
	note $26 $08
	wait1 $03
	vol $1
	note $26 $08
	wait1 $16
	vol $6
	note $28 $0e
	note $27 $08
	note $28 $0e
	note $27 $08
	note $28 $07
	wait1 $04
	vol $3
	note $28 $07
	wait1 $04
	vol $6
	note $2d $07
	wait1 $04
	vol $3
	note $2d $07
	wait1 $04
	vol $6
	note $30 $0e
	note $2c $08
	note $30 $0e
	note $2c $08
	wait1 $03
	vol $3
	note $2c $08
	wait1 $03
	vol $1
	note $2c $08
	wait1 $16
	vol $6
	note $2d $0e
	note $2c $08
	note $2d $0e
	note $2c $08
	note $2d $07
	wait1 $04
	vol $3
	note $2d $07
	wait1 $04
	vol $6
	note $30 $07
	wait1 $04
	vol $3
	note $30 $07
	wait1 $04
	vol $6
	note $2c $0e
	note $2b $08
	note $2c $0e
	note $2b $08
	wait1 $03
	vol $3
	note $2b $08
	wait1 $03
	vol $1
	note $2b $08
	wait1 $16
	vol $6
	note $2d $0e
	note $2c $08
	note $2d $0e
	note $2c $08
	note $2d $07
	wait1 $04
	vol $3
	note $2d $07
	wait1 $04
	vol $6
	note $34 $07
	wait1 $04
	vol $3
	note $34 $07
	wait1 $04
	vol $6
	note $33 $0e
	note $34 $08
	note $35 $0e
	note $34 $08
	wait1 $03
	vol $3
	note $34 $08
	wait1 $03
	vol $1
	note $34 $08
	wait1 $24
	vol $6
	note $2d $08
	note $28 $0e
	wait1 $03
	vol $3
	note $28 $05
	vol $6
	note $28 $0e
	note $27 $08
	wait1 $03
	vol $3
	note $27 $08
	wait1 $03
	vol $6
	note $26 $08
	note $24 $07
	wait1 $04
	vol $3
	note $24 $07
	wait1 $04
	vol $6
	note $24 $0e
	note $23 $08
	wait1 $03
	vol $3
	note $23 $08
	wait1 $03
	vol $6
	note $28 $08
	note $27 $0e
	note $28 $08
	note $2d $07
	wait1 $04
	vol $3
	note $2d $03
	vol $6
	note $34 $08
	note $33 $0e
	wait1 $03
	vol $3
	note $33 $05
	vol $6
	note $33 $0e
	note $32 $08
	wait1 $03
	vol $3
	note $32 $08
	wait1 $03
	vol $6
	note $32 $08
	note $30 $07
	wait1 $04
	vol $3
	note $30 $07
	wait1 $04
	vol $6
	note $30 $0e
	note $2f $08
	wait1 $03
	vol $3
	note $2f $08
	wait1 $03
	vol $6
	note $28 $03
	wait1 $05
	note $28 $07
	wait1 $04
	vol $3
	note $28 $03
	vol $6
	note $28 $08
	note $29 $16
	note $28 $07
	wait1 $04
	vol $3
	note $28 $07
	wait1 $04
	vol $6
	note $2b $16
	note $28 $07
	wait1 $04
	vol $3
	note $28 $07
	wait1 $04
	vol $6
	note $29 $16
	note $28 $07
	wait1 $04
	vol $3
	note $28 $07
	wait1 $04
	vol $6
	note $2b $16
	note $28 $07
	wait1 $04
	vol $3
	note $28 $07
	wait1 $5c
	vol $6
	note $28 $07
	note $2c $07
	note $2e $08
	note $2c $07
	note $2e $07
	note $32 $08
	note $2e $07
	note $32 $07
	note $34 $08
	note $32 $07
	note $34 $07
	note $3a $08
	goto musicf4ea0
	cmdff
; $f5095
; @addr{f5095}
sound23Channel0:
	vibrato $e1
	env $0 $00
	duty $02
musicf509b:
	vol $1
	note $15 $0b
	vol $3
	note $15 $0e
	note $14 $08
	note $15 $0e
	note $17 $08
	note $18 $0e
	note $17 $08
	note $18 $0e
	note $1a $08
	note $1b $0e
	note $1c $08
	note $1b $0e
	note $1c $08
	wait1 $2c
	note $2d $0e
	note $2c $08
	note $2d $0e
	note $2c $08
	note $2b $0e
	note $2a $08
	note $2b $0e
	note $2a $08
	note $29 $0e
	note $28 $08
	note $29 $0e
	note $28 $08
	wait1 $21
	vol $6
	note $2d $2c
	note $2c $2c
	note $2b $2c
	note $2a $2c
	note $29 $2c
	note $26 $2c
	note $23 $07
	wait1 $07
	vol $3
	note $23 $08
	wait1 $07
	vol $1
	note $23 $07
	wait1 $08
	vol $6
	note $20 $07
	wait1 $07
	vol $3
	note $20 $08
	wait1 $07
	vol $1
	note $20 $07
	wait1 $13
	vol $3
	note $28 $0e
	note $27 $08
	note $28 $0e
	note $27 $08
	note $28 $07
	wait1 $04
	vol $1
	note $28 $07
	wait1 $04
	vol $3
	note $2d $07
	wait1 $04
	vol $1
	note $2d $07
	wait1 $04
	vol $3
	note $27 $0e
	note $26 $08
	note $27 $0e
	note $26 $08
	wait1 $03
	vol $1
	note $26 $08
	wait1 $03
	vol $0
	note $26 $08
	wait1 $16
	vol $3
	note $28 $0e
	note $27 $08
	note $28 $0e
	note $27 $08
	note $28 $07
	wait1 $04
	vol $1
	note $28 $07
	wait1 $04
	vol $3
	note $2d $07
	wait1 $04
	vol $1
	note $2d $07
	wait1 $04
	vol $3
	note $30 $0e
	note $2c $08
	note $30 $0e
	note $2c $08
	wait1 $03
	vol $1
	note $2c $08
	wait1 $03
	vol $0
	note $2c $08
	wait1 $16
	vol $3
	note $2d $0e
	note $2c $08
	note $2d $0e
	note $2c $08
	note $2d $07
	wait1 $04
	vol $1
	note $2d $07
	wait1 $04
	vol $3
	note $30 $07
	wait1 $04
	vol $1
	note $30 $07
	wait1 $04
	vol $3
	note $2c $0e
	note $2b $08
	note $2c $0e
	note $2b $08
	wait1 $03
	vol $1
	note $2b $08
	wait1 $03
	vol $0
	note $2b $08
	wait1 $16
	vol $3
	note $2d $0e
	note $2c $08
	note $2d $0e
	note $2c $08
	note $2d $07
	wait1 $04
	vol $1
	note $2d $07
	wait1 $04
	vol $3
	note $34 $07
	wait1 $04
	vol $1
	note $34 $07
	wait1 $04
	vol $3
	note $33 $0e
	note $34 $08
	note $35 $0e
	note $34 $08
	wait1 $03
	vol $1
	note $34 $08
	wait1 $03
	vol $0
	note $34 $08
	wait1 $24
	vol $3
	note $2d $08
	note $28 $0e
	wait1 $03
	vol $1
	note $28 $05
	vol $3
	note $28 $0e
	note $27 $08
	wait1 $03
	vol $1
	note $27 $08
	wait1 $03
	vol $3
	note $26 $08
	note $24 $07
	wait1 $04
	vol $1
	note $24 $07
	wait1 $04
	vol $3
	note $24 $0e
	note $23 $08
	wait1 $03
	vol $1
	note $23 $08
	wait1 $03
	vol $3
	note $28 $08
	note $27 $0b
	vol $6
	note $30 $07
	wait1 $04
	vol $3
	note $30 $03
	vol $6
	note $30 $08
	note $2f $0e
	wait1 $03
	vol $3
	note $2f $05
	vol $6
	note $2f $0e
	note $2e $08
	wait1 $03
	vol $3
	note $2e $08
	wait1 $03
	vol $6
	note $2e $08
	note $2c $07
	wait1 $04
	vol $3
	note $2c $07
	wait1 $04
	vol $6
	note $2c $0e
	note $28 $08
	wait1 $03
	vol $3
	note $28 $08
	wait1 $03
	vol $6
	note $24 $03
	wait1 $05
	note $24 $07
	wait1 $04
	vol $3
	note $24 $03
	vol $6
	note $24 $08
	vol $6
	note $25 $16
	note $24 $07
	wait1 $04
	vol $3
	note $24 $07
	wait1 $04
	vol $6
	note $27 $16
	note $24 $07
	wait1 $04
	vol $3
	note $24 $07
	wait1 $04
	vol $6
	note $25 $16
	note $24 $07
	wait1 $04
	vol $3
	note $24 $07
	wait1 $04
	vol $6
	note $27 $16
	note $24 $07
	wait1 $04
	vol $3
	note $24 $07
	wait1 $67
	note $28 $07
	note $2c $07
	note $2e $08
	note $2c $07
	note $2e $07
	note $32 $08
	note $2e $07
	note $32 $07
	note $34 $08
	note $32 $07
	note $34 $04
	goto musicf509b
	cmdff
; $f5283
; @addr{f5283}
sound23Channel4:
musicf5283:
	duty $0e
	note $09 $07
	wait1 $25
	note $11 $07
	wait1 $25
	note $0f $24
	note $10 $08
	duty $0f
	note $10 $08
	wait1 $06
	duty $0e
	note $10 $08
	note $12 $0e
	note $14 $08
	duty $0e
	note $15 $07
	duty $0f
	note $15 $07
	wait1 $1e
	duty $0e
	note $10 $07
	duty $0f
	note $10 $07
	wait1 $1e
	duty $0e
	note $0b $24
	note $10 $08
	duty $0f
	note $10 $08
	wait1 $06
	duty $0e
	note $1c $08
	note $1b $0e
	note $1a $08
	note $18 $0e
	note $17 $08
	note $18 $0e
	note $17 $08
	note $16 $0e
	note $15 $08
	note $16 $0e
	note $15 $08
	note $14 $0e
	note $13 $08
	note $14 $0e
	note $13 $08
	note $12 $0e
	note $11 $08
	note $12 $0e
	note $11 $08
	note $10 $2c
	note $11 $2c
	note $12 $2c
	note $14 $2c
	duty $0e
	note $15 $07
	duty $0f
	note $15 $07
	wait1 $1e
	duty $0e
	note $10 $07
	duty $0f
	note $10 $07
	wait1 $1e
	duty $0e
	note $0f $24
	note $10 $08
	duty $0f
	note $10 $08
	wait1 $06
	duty $0e
	note $10 $16
	note $12 $03
	note $14 $05
	duty $0e
	note $15 $07
	duty $0f
	note $15 $07
	wait1 $1e
	duty $0e
	note $10 $07
	duty $0f
	note $10 $07
	wait1 $1e
	duty $0e
	note $0f $0e
	note $10 $08
	note $0f $0e
	note $10 $08
	duty $0f
	note $10 $08
	wait1 $06
	duty $0e
	note $10 $16
	note $12 $03
	note $14 $05
	duty $0e
	note $15 $07
	duty $0f
	note $15 $07
	wait1 $1e
	duty $0e
	note $10 $07
	duty $0f
	note $10 $07
	wait1 $1e
	duty $0e
	note $0e $24
	note $0f $08
	duty $0f
	note $0f $08
	wait1 $06
	duty $0e
	note $10 $16
	note $12 $03
	note $14 $05
	duty $0e
	note $15 $07
	duty $0f
	note $15 $07
	wait1 $1e
	duty $0e
	note $10 $07
	duty $0f
	note $10 $07
	wait1 $1e
	duty $0e
	note $0f $0e
	note $10 $08
	note $11 $0e
	note $10 $08
	duty $0f
	note $10 $08
	wait1 $0e
	duty $0e
	note $10 $16
	duty $0e
	note $15 $07
	duty $0f
	note $15 $07
	wait1 $1e
	duty $0e
	note $10 $07
	duty $0f
	note $10 $07
	wait1 $1e
	duty $0e
	note $0e $24
	note $10 $08
	duty $0f
	note $10 $08
	wait1 $24
	duty $0e
	note $15 $07
	duty $0f
	note $15 $07
	wait1 $1e
	duty $0e
	note $10 $07
	duty $0f
	note $10 $07
	wait1 $1e
	duty $0e
	note $0e $07
	duty $0f
	note $0e $07
	wait1 $08
	duty $0e
	note $0e $0e
	note $10 $08
	duty $0f
	note $10 $08
	wait1 $24
	duty $0e
	note $15 $07
	duty $0f
	note $15 $07
	wait1 $a2
	duty $0e
	note $0f $0e
	note $10 $08
	note $0f $0e
	note $10 $08
	note $18 $0e
	note $17 $08
	duty $0f
	note $17 $08
	wait1 $06
	duty $0e
	note $16 $60
	goto musicf5283
	cmdff
; $f5403
; @addr{f5403}
sound23Channel6:
musicf5403:
	wait1 $ff
	wait1 $ff
	wait1 $28
	vol $4
	vol $3
	note $2a $2c
	vol $3
	note $2a $2c
	vol $3
	note $2a $24
	vol $3
	note $2a $08
	vol $2
	note $2e $16
	vol $3
	note $2a $42
	vol $3
	note $2a $2c
	vol $2
	note $2e $0e
	vol $3
	note $2a $16
	vol $3
	note $2a $08
	vol $2
	note $2e $16
	vol $0
	vol $3
	note $2a $16
	vol $4
	vol $3
	note $2a $2c
	vol $3
	note $2a $2c
	vol $2
	note $2e $0e
	vol $3
	note $2a $16
	vol $3
	vol $3
	note $2a $08
	vol $4
	vol $2
	note $2e $16
	wait1 $16
	vol $4
	vol $3
	note $2a $2c
	vol $3
	note $2a $2c
	vol $2
	note $2e $0e
	vol $3
	note $2a $16
	vol $3
	vol $3
	note $2a $08
	vol $4
	vol $2
	note $2e $16
	wait1 $16
	vol $4
	vol $3
	note $2a $2c
	vol $3
	note $2a $2c
	vol $2
	note $2e $0e
	vol $3
	note $2a $16
	vol $3
	vol $3
	note $2a $08
	vol $4
	vol $2
	note $2e $16
	wait1 $16
	vol $4
	vol $3
	note $2a $2c
	vol $3
	note $2a $2c
	vol $2
	note $2e $0e
	vol $3
	note $2a $16
	vol $3
	vol $3
	note $2a $08
	vol $4
	vol $2
	note $2e $16
	wait1 $16
	vol $4
	vol $3
	note $2a $2c
	vol $3
	note $2a $2c
	vol $2
	note $2e $0e
	vol $3
	note $2a $16
	vol $3
	vol $3
	note $2a $08
	vol $4
	vol $2
	note $2e $16
	vol $2
	note $2e $16
	vol $3
	note $2a $0e
	vol $3
	note $2a $08
	vol $2
	note $2e $16
	vol $3
	note $2a $0e
	vol $3
	note $2a $08
	vol $2
	note $2e $16
	vol $3
	note $2a $0e
	vol $3
	note $2a $08
	vol $2
	note $2e $16
	vol $3
	note $2a $0e
	vol $3
	note $2a $08
	vol $2
	note $2e $0e
	vol $3
	note $2a $08
	vol $3
	note $2a $0e
	vol $3
	note $2a $08
	vol $3
	note $2a $0e
	vol $3
	note $2a $16
	vol $3
	note $2a $16
	vol $3
	note $2a $08
	vol $3
	note $2a $07
	vol $3
	note $2a $07
	vol $3
	note $2a $08
	vol $3
	note $2a $07
	vol $3
	note $2a $07
	vol $3
	note $2a $08
	vol $3
	note $2a $07
	vol $3
	note $2a $07
	vol $3
	note $2a $08
	goto musicf5403
	cmdff
; $f54fb
; @addr{f54fb}
sound1bChannel1:
musicf54fb:
	vibrato $00
	env $0 $05
	duty $02
	vol $6
	note $33 $0f
	note $2d $0f
	note $2c $0f
	note $27 $0f
	note $2c $0f
	note $2d $0f
	note $33 $0f
	note $2d $0f
	note $2c $0f
	note $27 $0f
	note $2c $0f
	note $2d $0f
	note $33 $0f
	note $2d $0f
	note $2c $0f
	note $27 $0f
	note $2c $0f
	note $2d $0f
	note $33 $0f
	note $2d $0f
	note $2c $0f
	note $27 $0f
	note $2c $0f
	note $2d $0f
	note $31 $0f
	note $2b $0f
	note $2a $0f
	note $25 $0f
	note $2a $0f
	note $2b $0f
	note $31 $0f
	note $2b $0f
	note $2a $0f
	note $25 $0f
	note $2a $0f
	note $2b $0f
	note $31 $0f
	note $2b $0f
	note $2a $0f
	note $25 $0f
	note $2a $0f
	note $2b $0f
	note $31 $0f
	note $2b $0f
	note $2a $0f
	note $25 $0f
	note $2a $0f
	note $2b $0f
	note $33 $0f
	note $2d $0f
	note $2c $0f
	note $27 $0f
	note $2c $0f
	note $2d $0f
	note $33 $0f
	note $2d $0f
	note $2c $0f
	note $27 $0f
	note $2c $0f
	note $2d $0f
	note $33 $0f
	note $2d $0f
	note $2c $0f
	note $27 $0f
	note $2c $0f
	note $2d $0f
	note $33 $0f
	note $2d $0f
	note $2c $0f
	note $27 $0f
	note $2c $0f
	note $2d $0f
	note $31 $0f
	note $2b $0f
	note $2a $0f
	note $25 $0f
	note $2a $0f
	note $2b $0f
	note $31 $0f
	note $2b $0f
	note $2a $0f
	note $25 $0f
	note $2a $0f
	note $2b $0f
	note $31 $0f
	note $2b $0f
	note $2a $0f
	note $25 $0f
	note $2a $0f
	note $2b $0f
	note $31 $0f
	note $2b $0f
	note $2a $0f
	note $25 $0f
	note $2a $0f
	note $2b $0f
	vibrato $e1
	env $0 $00
	note $28 $4b
	vibrato $01
	env $0 $00
	vol $3
	note $28 $0f
	vibrato $e1
	env $0 $00
	vol $6
	note $27 $4b
	vibrato $01
	env $0 $00
	vol $3
	note $27 $0f
	vibrato $e1
	env $0 $00
	vol $6
	note $26 $4b
	vibrato $01
	env $0 $00
	vol $3
	note $26 $0f
	vibrato $e1
	env $0 $00
	vol $6
	note $25 $4b
	vibrato $01
	env $0 $00
	vol $3
	note $25 $0f
	vibrato $00
	env $0 $03
	vol $6
	note $24 $0f
	note $1f $0f
	note $1e $0f
	note $24 $0f
	note $1f $0f
	note $1e $0f
	vol $5
	note $30 $0f
	note $2b $0f
	note $2a $0f
	note $30 $0f
	note $2b $0f
	note $2a $0f
	env $0 $04
	vol $4
	note $3c $0f
	note $37 $0f
	vol $4
	note $36 $0f
	vol $4
	note $3c $0f
	note $37 $0f
	vol $4
	note $36 $0f
	env $0 $05
	vol $3
	note $48 $0f
	note $43 $0f
	note $42 $0f
	vol $3
	note $48 $0f
	note $43 $0f
	note $42 $0f
	vibrato $e1
	env $0 $00
	vol $6
	note $26 $4b
	vibrato $01
	env $0 $00
	vol $3
	note $26 $0f
	vibrato $e1
	env $0 $00
	vol $6
	note $25 $4b
	vibrato $01
	env $0 $00
	vol $3
	note $25 $0f
	vibrato $e1
	env $0 $00
	vol $6
	note $24 $4b
	vibrato $01
	env $0 $00
	vol $3
	note $24 $0f
	vibrato $e1
	env $0 $00
	vol $6
	note $23 $4b
	vibrato $01
	env $0 $00
	vol $3
	note $23 $0f
	vibrato $00
	env $0 $03
	vol $6
	note $21 $0f
	note $1c $0f
	note $1b $0f
	note $21 $0f
	note $1c $0f
	note $1b $0f
	vol $5
	note $2d $0f
	note $28 $0f
	note $27 $0f
	note $2d $0f
	note $28 $0f
	note $27 $0f
	env $0 $04
	vol $4
	note $39 $0f
	note $34 $0f
	note $33 $0f
	note $39 $0f
	note $34 $0f
	note $33 $0f
	env $0 $05
	vol $3
	note $45 $0f
	note $40 $0f
	note $3f $0f
	note $45 $0f
	note $40 $0f
	note $3f $0f
	goto musicf54fb
	cmdff
; $f56b1
; @addr{f56b1}
sound1bChannel0:
musicf56b1:
	vibrato $00
	env $0 $05
	duty $02
	vol $1
	note $33 $0f
	vol $3
	note $33 $0f
	note $2d $0f
	note $2c $0f
	note $27 $0f
	note $2c $0f
	note $2d $0f
	note $33 $0f
	note $2d $0f
	note $2c $0f
	note $27 $0f
	note $2c $0f
	note $2d $0f
	note $33 $0f
	note $2d $0f
	note $2c $0f
	note $27 $0f
	note $2c $0f
	note $2d $0f
	note $33 $0f
	note $2d $0f
	note $2c $0f
	note $27 $0f
	note $2c $0f
	note $2d $0f
	note $31 $0f
	note $2b $0f
	note $2a $0f
	note $25 $0f
	note $2a $0f
	note $2b $0f
	note $31 $0f
	note $2b $0f
	note $2a $0f
	note $25 $0f
	note $2a $0f
	vol $4
	note $2b $0f
	note $31 $0f
	note $2b $0f
	note $2a $0f
	note $25 $0f
	note $2a $0f
	note $2b $0f
	note $31 $0f
	note $2b $0f
	note $2a $0f
	note $25 $0f
	note $2a $0f
	note $2b $0f
	note $33 $0f
	note $2d $0f
	note $2c $0f
	note $27 $0f
	note $2c $0f
	note $2d $0f
	note $33 $0f
	note $2d $0f
	note $2c $0f
	note $27 $0f
	note $2c $0f
	note $2d $0f
	note $33 $0f
	note $2d $0f
	note $2c $0f
	note $27 $0f
	note $2c $0f
	note $2d $0f
	note $33 $0f
	note $2d $0f
	note $2c $0f
	note $27 $0f
	note $2c $0f
	note $2d $0f
	note $31 $0f
	vol $4
	note $2b $0f
	note $2a $0f
	note $25 $0f
	note $2a $0f
	note $2b $0f
	note $31 $0f
	note $2b $0f
	note $2a $0f
	note $25 $0f
	note $2a $0f
	note $2b $0f
	note $31 $0f
	note $2b $0f
	note $2a $0f
	note $25 $0f
	note $2a $0f
	note $2b $0f
	note $31 $0f
	note $2b $0f
	note $2a $0f
	note $25 $0f
	note $2a $0f
	vibrato $e1
	env $0 $00
	vol $6
	note $23 $3c
	vibrato $01
	env $0 $00
	vol $3
	note $23 $1e
	vibrato $e1
	env $0 $00
	vol $6
	note $22 $3c
	vibrato $01
	env $0 $00
	vol $3
	note $22 $1e
	vibrato $e1
	env $0 $00
	vol $6
	note $21 $3c
	vibrato $01
	env $0 $00
	vol $3
	note $21 $1e
	vibrato $e1
	env $0 $00
	vol $6
	note $20 $3c
	vibrato $01
	env $0 $00
	vol $3
	note $20 $1e
	wait1 $0f
	vibrato $00
	env $0 $03
	vol $4
	note $24 $0f
	note $1f $0f
	note $1e $0f
	note $24 $0f
	note $1f $0f
	note $1e $0f
	vol $3
	note $30 $0f
	vol $3
	note $2b $0f
	note $2a $0f
	note $30 $0f
	note $2b $0f
	note $2a $0f
	vol $2
	note $3c $0f
	vol $2
	note $37 $0f
	note $36 $0f
	note $3c $0f
	note $37 $0f
	note $36 $0f
	vol $1
	note $48 $0f
	vol $1
	note $43 $0f
	vol $1
	note $42 $0f
	vol $1
	note $48 $0f
	vol $1
	note $43 $0f
	vibrato $e1
	env $0 $00
	vol $6
	note $16 $3c
	vibrato $01
	env $0 $00
	vol $3
	note $16 $1e
	vibrato $e1
	env $0 $00
	vol $6
	note $15 $3c
	vibrato $01
	env $0 $00
	vol $3
	note $15 $1e
	vibrato $e1
	env $0 $00
	vol $6
	note $14 $3c
	vibrato $01
	env $0 $00
	vol $3
	note $14 $1e
	vibrato $e1
	env $0 $00
	vol $6
	note $13 $3c
	vibrato $01
	env $0 $00
	vol $3
	note $13 $1e
	wait1 $0b
	vibrato $00
	env $0 $03
	vol $3
	note $21 $0f
	note $1c $0f
	note $1b $0f
	note $21 $0f
	note $1c $0f
	vol $2
	note $1b $0f
	note $2d $0f
	note $28 $0f
	note $27 $0f
	note $2d $0f
	note $28 $0f
	note $27 $0f
	vol $2
	note $39 $0f
	note $34 $0f
	note $33 $0f
	vol $2
	note $39 $0f
	note $34 $0f
	note $33 $0f
	vol $1
	note $45 $0f
	note $40 $0f
	vol $1
	note $3f $0f
	note $45 $0f
	vol $1
	note $40 $0f
	note $3f $04
	goto musicf56b1
	cmdff
; $f586a
; @addr{f586a}
sound1bChannel4:
musicf586a:
	duty $0e
	note $14 $a5
	note $0f $0f
	duty $0e
	note $14 $08
	duty $0f
	note $14 $07
	duty $0e
	note $14 $08
	duty $0f
	note $14 $07
	duty $0e
	wait1 $96
	note $13 $a5
	note $0d $0f
	duty $0e
	note $13 $08
	duty $0f
	note $13 $07
	duty $0e
	note $13 $08
	duty $0f
	note $13 $07
	duty $0e
	wait1 $96
	note $14 $a5
	note $1b $0f
	duty $0e
	note $14 $08
	duty $0f
	note $14 $07
	duty $0e
	note $14 $08
	duty $0f
	note $14 $07
	duty $0e
	wait1 $96
	note $13 $a5
	note $19 $0f
	duty $0e
	note $13 $08
	duty $0f
	note $13 $07
	duty $0e
	note $13 $08
	duty $0f
	note $13 $07
	duty $0e
	wait1 $96
	note $14 $2a
	wait1 $03
	note $14 $0f
	wait1 $0f
	note $14 $07
	wait1 $08
	note $14 $07
	wait1 $08
	note $14 $19
	wait1 $05
	note $14 $19
	wait1 $05
	note $14 $07
	wait1 $08
	note $14 $07
	wait1 $08
	note $14 $19
	wait1 $05
	note $14 $19
	wait1 $05
	note $14 $07
	wait1 $08
	note $14 $07
	wait1 $08
	note $14 $19
	wait1 $05
	note $14 $19
	wait1 $05
	note $14 $0f
	note $12 $2a
	wait1 $03
	note $12 $0f
	wait1 $0f
	note $12 $07
	wait1 $08
	note $12 $07
	wait1 $08
	note $12 $19
	wait1 $05
	note $12 $19
	wait1 $05
	note $12 $07
	wait1 $08
	note $12 $07
	wait1 $08
	note $12 $19
	wait1 $05
	note $12 $19
	wait1 $05
	note $12 $07
	wait1 $08
	note $12 $07
	wait1 $08
	note $12 $19
	wait1 $05
	note $12 $19
	wait1 $05
	note $12 $0f
	note $1d $07
	wait1 $08
	note $1d $19
	wait1 $05
	note $1d $19
	wait1 $05
	note $1d $0f
	note $1c $07
	wait1 $08
	note $1c $19
	wait1 $05
	note $1c $19
	wait1 $05
	note $1c $07
	wait1 $08
	note $1b $07
	wait1 $08
	note $1b $19
	wait1 $05
	note $1b $19
	wait1 $05
	note $1b $07
	wait1 $08
	note $1a $07
	wait1 $08
	note $1a $19
	wait1 $05
	note $1a $19
	wait1 $05
	note $1a $07
	wait1 $08
	note $12 $07
	wait1 $08
	note $12 $19
	wait1 $05
	note $12 $19
	wait1 $05
	note $12 $07
	wait1 $08
	note $12 $07
	wait1 $08
	note $12 $19
	wait1 $05
	note $12 $19
	wait1 $05
	note $12 $07
	wait1 $08
	note $12 $07
	wait1 $08
	note $12 $19
	wait1 $05
	note $12 $19
	wait1 $05
	note $12 $07
	wait1 $08
	note $12 $07
	wait1 $08
	note $12 $19
	wait1 $05
	note $12 $19
	wait1 $05
	note $12 $07
	wait1 $08
	goto musicf586a
	cmdff
; $f59c2
; @addr{f59c2}
sound26Channel1:
	vibrato $00
	env $0 $00
	duty $01
musicf59c8:
	vol $6
	note $33 $0e
	note $32 $07
	wait1 $03
	vol $3
	note $32 $04
	vol $6
	note $31 $07
	wait1 $03
	vol $3
	note $31 $04
	vol $6
	note $30 $07
	wait1 $03
	vol $3
	note $30 $07
	wait1 $04
	vol $1
	note $30 $07
	vol $6
	note $2f $0e
	note $30 $07
	wait1 $03
	vol $3
	note $30 $04
	vol $6
	note $31 $07
	wait1 $03
	vol $3
	note $31 $04
	vol $6
	note $33 $0e
	note $36 $07
	wait1 $03
	vol $3
	note $36 $04
	vol $6
	note $33 $07
	note $32 $07
	note $31 $07
	note $2f $07
	wait1 $07
	vol $3
	note $2f $07
	vol $6
	note $2f $0e
	note $30 $07
	wait1 $03
	vol $3
	note $30 $04
	vol $6
	note $31 $07
	wait1 $03
	vol $3
	note $31 $04
	vol $6
	note $33 $0e
	note $32 $07
	wait1 $03
	vol $3
	note $32 $04
	vol $6
	note $31 $07
	wait1 $03
	vol $3
	note $31 $04
	vol $6
	note $30 $07
	wait1 $03
	vol $3
	note $30 $07
	wait1 $04
	vol $1
	note $30 $07
	vol $6
	note $2f $0e
	note $30 $07
	wait1 $03
	vol $3
	note $30 $04
	vol $6
	note $31 $07
	wait1 $03
	vol $3
	note $31 $07
	wait1 $04
	vol $1
	note $31 $07
	duty $02
	vol $7
	note $42 $07
	wait1 $03
	vol $3
	note $42 $04
	vol $7
	note $42 $07
	vol $6
	note $41 $07
	note $42 $07
	note $41 $07
	vol $6
	note $42 $07
	wait1 $03
	vol $3
	note $42 $04
	vol $6
	note $41 $07
	wait1 $03
	vol $3
	note $41 $04
	vol $6
	note $42 $07
	wait1 $03
	vol $3
	note $42 $07
	wait1 $04
	vol $1
	note $42 $07
	duty $01
	vol $6
	note $33 $0e
	note $32 $07
	wait1 $03
	vol $3
	note $32 $04
	vol $6
	note $31 $07
	wait1 $03
	vol $3
	note $31 $04
	vol $6
	note $30 $07
	wait1 $03
	vol $3
	note $30 $07
	wait1 $04
	vol $1
	note $30 $07
	vol $6
	note $2f $0e
	note $30 $07
	wait1 $03
	vol $3
	note $30 $04
	vol $6
	note $31 $07
	wait1 $03
	vol $3
	note $31 $04
	vol $6
	note $33 $0e
	note $36 $07
	wait1 $03
	vol $3
	note $36 $04
	vol $6
	note $33 $07
	note $32 $07
	note $31 $07
	note $2f $07
	wait1 $03
	vol $3
	note $2f $07
	wait1 $04
	vol $6
	note $2f $0e
	note $30 $07
	wait1 $03
	vol $3
	note $30 $04
	vol $6
	note $31 $07
	wait1 $03
	vol $3
	note $31 $04
	vol $6
	note $33 $0e
	note $32 $07
	wait1 $03
	vol $3
	note $32 $04
	vol $6
	note $31 $07
	wait1 $03
	vol $3
	note $31 $04
	vol $6
	note $30 $07
	wait1 $03
	vol $3
	note $30 $07
	wait1 $04
	vol $1
	note $30 $07
	vol $6
	note $2f $07
	wait1 $03
	vol $3
	note $2f $04
	vol $6
	note $30 $07
	note $31 $07
	vol $6
	note $32 $07
	note $33 $07
	wait1 $0e
	duty $02
	vol $7
	note $46 $07
	wait1 $03
	vol $3
	note $46 $04
	vol $7
	note $46 $07
	vol $6
	note $45 $07
	note $46 $07
	note $45 $07
	vol $6
	note $46 $07
	wait1 $03
	vol $3
	note $46 $04
	vol $6
	note $45 $07
	wait1 $03
	vol $3
	note $45 $04
	vol $6
	note $46 $07
	wait1 $03
	vol $3
	note $46 $07
	wait1 $04
	vol $1
	note $46 $06
	wait1 $01
	duty $01
	goto musicf59c8
	cmdff
; $f5b55
; @addr{f5b55}
sound26Channel0:
	vibrato $00
	env $0 $00
	duty $01
musicf5b5b:
	vol $0
	note $20 $0e
	vol $6
	note $20 $0e
	note $23 $0e
	note $27 $07
	wait1 $03
	vol $3
	note $27 $07
	wait1 $04
	vol $1
	note $27 $07
	vol $6
	note $20 $0e
	note $23 $0e
	note $27 $07
	wait1 $03
	vol $3
	note $27 $07
	wait1 $04
	vol $1
	note $27 $07
	vol $6
	note $20 $0e
	note $23 $0e
	note $27 $07
	wait1 $03
	vol $3
	note $27 $07
	wait1 $04
	vol $1
	note $27 $07
	vol $6
	note $20 $0e
	note $23 $0e
	note $27 $07
	wait1 $03
	vol $3
	note $27 $07
	wait1 $04
	vol $1
	note $27 $07
	vol $6
	note $20 $0e
	note $23 $0e
	note $27 $07
	wait1 $03
	vol $3
	note $27 $07
	wait1 $04
	vol $1
	note $27 $07
	vol $6
	note $20 $0e
	note $23 $0e
	note $27 $07
	wait1 $03
	vol $3
	note $27 $07
	wait1 $04
	vol $1
	note $27 $07
	duty $02
	vol $6
	note $3f $07
	wait1 $03
	vol $3
	note $3f $04
	vol $6
	note $3f $07
	note $3e $07
	note $3f $07
	note $3e $07
	note $3f $07
	wait1 $03
	vol $3
	note $3f $04
	vol $6
	note $3e $07
	wait1 $03
	vol $3
	note $3e $04
	vol $6
	note $3f $07
	wait1 $03
	vol $3
	note $3f $07
	wait1 $04
	vol $1
	note $3f $07
	wait1 $0e
	duty $01
	vol $6
	note $20 $0e
	note $23 $0e
	note $27 $07
	wait1 $03
	vol $3
	note $27 $07
	wait1 $04
	vol $1
	note $27 $07
	vol $6
	note $20 $0e
	note $23 $0e
	note $27 $07
	wait1 $03
	vol $3
	note $27 $07
	wait1 $04
	vol $1
	note $27 $07
	vol $6
	note $20 $0e
	note $23 $0e
	note $27 $07
	wait1 $03
	vol $3
	note $27 $07
	wait1 $04
	vol $1
	note $27 $07
	vol $6
	note $20 $0e
	note $23 $0e
	note $27 $07
	wait1 $03
	vol $3
	note $27 $07
	wait1 $04
	vol $1
	note $27 $07
	vol $6
	note $20 $0e
	note $23 $0e
	note $27 $07
	wait1 $03
	vol $3
	note $27 $07
	wait1 $04
	vol $1
	note $27 $07
	vol $6
	note $20 $0e
	note $23 $0e
	note $27 $07
	wait1 $03
	vol $3
	note $27 $07
	wait1 $04
	vol $1
	note $27 $07
	duty $02
	vol $6
	note $42 $07
	wait1 $03
	vol $3
	note $42 $04
	vol $6
	note $42 $07
	note $41 $07
	note $42 $07
	note $41 $07
	note $42 $07
	wait1 $03
	vol $3
	note $42 $04
	vol $6
	note $41 $07
	wait1 $03
	vol $3
	note $41 $04
	vol $6
	note $42 $07
	wait1 $03
	vol $3
	note $42 $07
	wait1 $04
	vol $1
	note $42 $06
	wait1 $01
	duty $01
	goto musicf5b5b
	cmdff
; $f5c94
; @addr{f5c94}
sound26Channel4:
musicf5c94:
	duty $0e
	note $1c $05
	duty $0f
	note $1c $0f
	wait1 $08
	duty $0e
	note $23 $05
	duty $0f
	note $23 $0f
	wait1 $08
	duty $0e
	note $17 $05
	duty $0f
	note $17 $0f
	wait1 $08
	duty $0e
	note $23 $05
	duty $0f
	note $23 $0f
	wait1 $08
	duty $0e
	note $1c $05
	duty $0f
	note $1c $0f
	wait1 $08
	duty $0e
	note $23 $05
	duty $0f
	note $23 $0f
	wait1 $08
	duty $0e
	note $17 $05
	duty $0f
	note $17 $0f
	wait1 $08
	duty $0e
	note $23 $05
	duty $0f
	note $23 $0f
	wait1 $08
	duty $0e
	note $1c $05
	duty $0f
	note $1c $0f
	wait1 $08
	duty $0e
	note $23 $05
	duty $0f
	note $23 $0f
	wait1 $08
	duty $0e
	note $17 $05
	duty $0f
	note $17 $0f
	wait1 $08
	duty $0e
	note $23 $05
	duty $0f
	note $23 $0f
	wait1 $08
	duty $0e
	note $1c $15
	duty $0f
	note $1c $07
	duty $0e
	note $17 $07
	duty $0f
	note $17 $07
	duty $0e
	note $1c $15
	duty $0f
	note $1c $07
	duty $0e
	note $1b $07
	duty $0f
	note $1b $07
	duty $0e
	note $1c $07
	duty $0f
	note $1c $0e
	wait1 $07
	duty $0e
	note $1c $05
	duty $0f
	note $1c $0f
	wait1 $08
	duty $0e
	note $23 $05
	duty $0f
	note $23 $0f
	wait1 $08
	duty $0e
	note $17 $05
	duty $0f
	note $17 $0f
	wait1 $08
	duty $0e
	note $23 $05
	duty $0f
	note $23 $0f
	wait1 $08
	duty $0e
	note $1c $05
	duty $0f
	note $1c $0f
	wait1 $08
	duty $0e
	note $23 $05
	duty $0f
	note $23 $0f
	wait1 $08
	duty $0e
	note $17 $05
	duty $0f
	note $17 $0f
	wait1 $08
	duty $0e
	note $23 $05
	duty $0f
	note $23 $0f
	wait1 $08
	duty $0e
	note $1c $05
	duty $0f
	note $1c $0f
	wait1 $08
	duty $0e
	note $23 $05
	duty $0f
	note $23 $0f
	wait1 $08
	duty $0e
	note $17 $05
	duty $0f
	note $17 $0f
	wait1 $08
	duty $0e
	note $23 $05
	duty $0f
	note $23 $0f
	wait1 $08
	duty $0e
	note $1c $15
	duty $0f
	note $1c $07
	duty $0e
	note $17 $07
	duty $0f
	note $17 $07
	duty $0e
	note $1c $1c
	duty $0e
	note $17 $07
	duty $0f
	note $17 $07
	duty $0e
	note $1c $07
	duty $0f
	note $1c $0e
	wait1 $07
	goto musicf5c94
	cmdff
; $f5dd8
; @addr{f5dd8}
sound27Channel1:
	vibrato $e1
	env $0 $00
	duty $01
musicf5dde:
	vol $6
	note $2f $2a
	note $2c $0e
	note $28 $0e
	note $23 $0e
	note $24 $2a
	note $28 $0e
	note $2b $0e
	note $30 $0e
	note $2f $0a
	wait1 $04
	duty $02
	note $3b $03
	note $3a $04
	note $3b $03
	note $3a $04
	note $3b $03
	wait1 $04
	vol $3
	note $3b $03
	wait1 $04
	vol $6
	note $47 $03
	note $46 $04
	note $47 $03
	note $46 $04
	note $47 $03
	wait1 $04
	vol $3
	note $47 $03
	wait1 $04
	duty $01
	vol $6
	note $23 $0e
	note $24 $0b
	wait1 $03
	duty $02
	note $30 $03
	note $2f $04
	note $30 $03
	note $2f $04
	note $30 $03
	wait1 $04
	vol $3
	note $30 $03
	wait1 $04
	vol $6
	note $3c $03
	note $3b $04
	note $3c $03
	note $3b $04
	note $3c $03
	wait1 $04
	vol $3
	note $3c $03
	wait1 $12
	duty $01
	vol $6
	note $2f $2a
	note $2c $0e
	note $28 $0e
	note $2c $0e
	note $2d $07
	note $2c $07
	note $2d $07
	note $2c $07
	note $2d $0e
	note $2f $0e
	note $30 $0e
	note $2d $0e
	note $2f $07
	wait1 $03
	vol $3
	note $2f $04
	vol $6
	note $34 $07
	note $33 $07
	note $34 $07
	wait1 $03
	vol $3
	note $34 $04
	vol $6
	note $2c $07
	wait1 $03
	vol $3
	note $2c $04
	vol $6
	note $2d $07
	wait1 $03
	vol $3
	note $2d $04
	vol $6
	note $2e $07
	wait1 $03
	vol $3
	note $2e $04
	vol $6
	note $2f $07
	note $2d $07
	note $2c $07
	note $2a $07
	note $28 $23
	vibrato $01
	env $0 $00
	vol $3
	note $28 $15
	vibrato $e1
	env $0 $00
	vol $6
	note $2b $38
	note $28 $1c
	note $2a $07
	wait1 $03
	vol $3
	note $2a $04
	duty $02
	vol $6
	note $3b $07
	note $3a $07
	note $3b $07
	wait1 $03
	vol $3
	note $3b $04
	vol $6
	note $47 $07
	note $46 $07
	note $47 $07
	wait1 $03
	vol $3
	note $47 $07
	wait1 $0b
	duty $01
	vol $6
	note $2b $2a
	note $28 $0e
	note $24 $0e
	note $2b $07
	vol $3
	note $2b $07
	vol $6
	note $2a $07
	wait1 $03
	vol $3
	note $2a $04
	duty $02
	vol $6
	note $2f $03
	note $2e $04
	note $2f $03
	note $2e $04
	note $2f $07
	wait1 $03
	vol $3
	note $2f $04
	vol $6
	note $3b $03
	note $3a $04
	note $3b $03
	note $3a $04
	note $3b $07
	wait1 $03
	vol $3
	note $3b $07
	wait1 $0b
	duty $01
	vol $6
	note $33 $07
	wait1 $03
	vol $3
	note $33 $07
	vol $6
	note $31 $04
	note $33 $03
	note $31 $04
	note $2f $07
	wait1 $03
	vol $3
	note $2f $07
	wait1 $19
	vol $6
	note $2f $07
	wait1 $03
	vol $3
	note $2f $04
	vol $6
	note $32 $07
	wait1 $03
	vol $3
	note $32 $07
	vol $6
	note $30 $04
	note $32 $03
	note $30 $04
	note $2f $07
	wait1 $03
	vol $3
	note $2f $07
	wait1 $19
	vol $6
	note $2f $07
	wait1 $03
	vol $3
	note $2f $04
	duty $02
	vol $6
	note $34 $07
	wait1 $03
	vol $3
	note $34 $04
	vol $6
	note $33 $03
	note $34 $04
	note $33 $03
	note $34 $04
	note $2e $03
	note $2f $04
	note $2e $03
	note $2f $04
	wait1 $03
	vol $3
	note $2f $04
	wait1 $07
	vol $6
	note $2a $03
	note $2b $04
	note $2a $03
	note $2b $04
	wait1 $03
	vol $3
	note $2b $04
	wait1 $07
	vol $6
	note $27 $03
	note $28 $04
	note $27 $03
	note $28 $04
	wait1 $03
	vol $3
	note $28 $04
	wait1 $07
	duty $01
	vol $6
	note $23 $0e
	note $25 $0e
	note $26 $0e
	note $27 $0e
	goto musicf5dde
	cmdff
; $f5f97
; @addr{f5f97}
sound27Channel0:
	vibrato $e1
	env $0 $00
	duty $02
musicf5f9d:
	cmdfd $ff
	vol $0
	note $20 $bd
	vol $3
	note $3b $03
	note $3a $04
	vol $3
	note $3b $03
	note $3a $04
	vol $3
	note $3b $03
	wait1 $04
	vol $1
	note $3b $03
	wait1 $04
	vol $3
	note $47 $03
	note $46 $04
	note $47 $03
	note $46 $04
	vol $3
	note $47 $03
	wait1 $04
	vol $1
	note $47 $03
	wait1 $20
	vol $3
	note $30 $03
	note $2f $04
	note $30 $03
	note $2f $04
	note $30 $03
	wait1 $04
	vol $1
	note $30 $03
	wait1 $04
	vol $3
	note $3c $03
	note $3b $04
	vol $3
	note $3c $03
	note $3b $04
	note $3c $03
	wait1 $04
	vol $1
	note $3c $03
	wait1 $ff
	wait1 $c5
	vol $3
	note $3b $07
	note $3a $07
	note $3b $07
	wait1 $03
	vol $1
	note $3b $04
	vol $3
	note $47 $07
	note $46 $07
	note $47 $07
	wait1 $03
	vol $1
	note $47 $07
	wait1 $58
	vol $3
	note $2a $07
	wait1 $03
	vol $1
	note $2a $07
	wait1 $04
	vol $3
	note $2f $03
	note $2e $04
	note $2f $03
	note $2e $04
	note $2f $07
	wait1 $03
	vol $1
	note $2f $04
	vol $3
	note $3b $03
	note $3a $04
	note $3b $03
	note $3a $04
	note $3b $07
	wait1 $03
	vol $1
	note $3b $07
	wait1 $2e
	cmdfd $00
	vol $6
	note $3d $04
	note $3f $05
	note $3d $05
	note $3b $07
	wait1 $03
	vol $3
	note $3b $07
	wait1 $04
	vol $1
	note $3b $07
	wait1 $2a
	vol $6
	note $3c $04
	note $3e $05
	note $3c $05
	note $3b $07
	wait1 $03
	vol $3
	note $3b $07
	wait1 $04
	vol $1
	note $3b $07
	wait1 $15
	vol $3
	note $33 $03
	note $34 $04
	note $33 $03
	note $34 $04
	note $2e $03
	note $2f $04
	note $2e $03
	note $2f $04
	wait1 $03
	vol $1
	note $2f $04
	wait1 $07
	vol $3
	note $2a $03
	note $2b $04
	note $2a $03
	note $2b $04
	wait1 $03
	vol $1
	note $2b $04
	wait1 $07
	vol $3
	note $27 $03
	note $28 $04
	note $27 $03
	note $28 $04
	wait1 $03
	vol $1
	note $28 $04
	wait1 $38
	goto musicf5f9d
	cmdff
; $f609e
; @addr{f609e}
sound27Channel4:
musicf609e:
	duty $0e
	note $1c $1c
	duty $0e
	note $23 $07
	duty $0f
	note $23 $07
	wait1 $0e
	duty $0e
	note $23 $07
	duty $0f
	note $23 $07
	wait1 $0e
	duty $0e
	note $1d $1c
	duty $0e
	note $21 $07
	duty $0f
	note $21 $07
	wait1 $0e
	duty $0e
	note $21 $07
	duty $0f
	note $21 $07
	wait1 $0e
	duty $0e
	note $1c $1c
	duty $0f
	note $1c $0e
	wait1 $2a
	duty $0e
	note $17 $1c
	duty $0f
	note $17 $0e
	wait1 $2a
	duty $0e
	note $1c $1c
	duty $0e
	note $23 $07
	duty $0f
	note $23 $07
	wait1 $0e
	duty $0e
	note $23 $07
	duty $0f
	note $23 $07
	wait1 $0e
	duty $0e
	note $1d $1c
	note $21 $07
	duty $0f
	note $21 $07
	wait1 $0e
	duty $0e
	note $21 $07
	duty $0f
	note $21 $07
	wait1 $0e
	duty $0e
	note $17 $15
	duty $0f
	note $17 $0a
	wait1 $35
	duty $0e
	note $17 $0e
	note $19 $07
	note $1b $07
	note $1c $0e
	note $17 $0e
	note $14 $0e
	note $10 $0e
	duty $0f
	note $10 $07
	wait1 $15
	duty $0e
	note $18 $07
	duty $0f
	note $18 $07
	wait1 $0e
	duty $0e
	note $18 $07
	duty $0f
	note $18 $07
	wait1 $0e
	duty $0e
	note $17 $07
	duty $0f
	note $17 $07
	wait1 $46
	duty $0e
	note $18 $1c
	note $1c $1c
	note $1f $1c
	note $17 $0e
	duty $0f
	note $17 $07
	wait1 $3f
	duty $0e
	note $1e $38
	note $17 $07
	duty $0f
	note $17 $07
	wait1 $0e
	duty $0e
	note $1d $38
	duty $0e
	note $17 $07
	duty $0f
	note $17 $07
	wait1 $0e
	duty $0e
	note $1c $07
	duty $0f
	note $1c $07
	wait1 $46
	duty $0e
	note $17 $54
	goto musicf609e
	cmdff
; $f618a
sound1dStart:
; @addr{f618a}
sound1dChannel1:
	vibrato $e1
	env $0 $00
	duty $02
	vol $8
	note $17 $03
	vol $8
	note $1c $04
	note $1d $03
	note $23 $04
	note $23 $03
	vol $7
	note $28 $04
	note $29 $03
	note $2f $04
	vol $8
	note $2f $03
	vol $8
	note $34 $04
	note $35 $03
	note $3b $04
	note $3b $03
	vol $7
	note $40 $04
	note $41 $03
	note $47 $2c
	wait1 $02
	vol $5
	note $47 $02
	wait1 $02
	vol $4
	note $47 $03
	wait1 $02
	vol $4
	note $47 $02
	wait1 $03
musicf61c7:
	vol $7
	note $29 $0e
	note $2c $0e
	note $30 $07
	wait1 $03
	vol $3
	note $30 $04
	vol $7
	note $2f $2a
	note $2c $0e
	note $29 $0e
	note $33 $07
	wait1 $03
	vol $3
	note $33 $04
	vol $7
	note $32 $46
	vibrato $01
	env $0 $00
	vol $3
	note $32 $0e
	vibrato $e1
	env $0 $00
	vol $7
	note $31 $0e
	note $30 $0e
	note $2f $0e
	note $2e $0e
	note $2c $0e
	note $2b $1c
	vibrato $01
	env $0 $00
	vol $3
	note $2b $0e
	vibrato $e1
	env $0 $00
	vol $8
	note $29 $0e
	vol $8
	note $2b $04
	note $2c $05
	note $2b $4b
	vibrato $01
	env $0 $00
	vol $4
	note $2b $0e
	vibrato $e1
	env $0 $00
	vol $8
	note $29 $0e
	note $2b $0e
	note $29 $0e
	note $23 $54
	vibrato $01
	env $0 $00
	vol $4
	note $23 $0e
	vibrato $e1
	env $0 $00
	vol $8
	note $24 $0e
	note $26 $0e
	note $28 $0e
	note $29 $0e
	note $2b $0e
	note $2c $0e
	note $2e $0e
	vol $8
	note $2f $04
	note $30 $05
	note $2f $2f
	vibrato $01
	env $0 $00
	vol $4
	note $2f $0e
	vibrato $e1
	env $0 $00
	vol $8
	note $2c $0e
	note $2b $0e
	note $29 $0e
	note $28 $07
	wait1 $03
	vol $4
	note $28 $04
	vol $8
	note $2b $46
	vibrato $01
	env $0 $00
	vol $4
	note $2b $1c
	vibrato $e1
	env $0 $00
	vol $8
	note $29 $0e
	note $24 $07
	note $29 $07
	note $24 $07
	note $29 $07
	note $24 $07
	wait1 $07
	vol $5
	note $29 $0e
	note $24 $07
	note $29 $07
	note $24 $07
	note $29 $07
	note $24 $07
	wait1 $07
	vol $8
	note $28 $0e
	note $23 $07
	note $28 $07
	note $23 $07
	note $28 $07
	note $23 $07
	wait1 $07
	vol $5
	note $28 $0e
	note $23 $07
	note $28 $07
	note $23 $07
	note $28 $07
	note $23 $07
	wait1 $07
	vol $8
	note $29 $0e
	note $24 $07
	note $29 $07
	note $24 $07
	note $29 $07
	vol $8
	note $2f $03
	vol $8
	note $30 $27
	vibrato $01
	env $0 $00
	vol $4
	note $30 $0e
	vibrato $e1
	env $0 $00
	vol $8
	note $2e $07
	note $30 $07
	note $31 $0e
	note $30 $0e
	note $2e $0e
	note $2c $0e
	note $2a $0e
	vol $4
	note $2a $0e
	vol $8
	note $31 $0e
	vol $4
	note $31 $0e
	vol $8
	note $30 $0e
	note $29 $07
	note $30 $07
	note $29 $07
	note $30 $07
	note $29 $07
	wait1 $07
	vol $5
	note $30 $0e
	note $29 $07
	note $30 $07
	note $29 $07
	note $30 $07
	note $29 $07
	wait1 $07
	vol $8
	note $2f $0e
	note $28 $07
	note $2f $07
	note $28 $07
	note $2f $07
	note $28 $07
	wait1 $07
	vol $5
	note $2f $0e
	note $28 $07
	note $2f $07
	note $28 $07
	note $2f $07
	note $28 $07
	wait1 $07
	vol $8
	note $2d $0e
	note $26 $07
	note $29 $07
	note $26 $07
	note $29 $07
	note $26 $0e
	vol $4
	note $26 $0e
	wait1 $1c
	vol $8
	note $35 $0e
	note $36 $07
	wait1 $07
	vol $4
	note $35 $0e
	note $36 $07
	wait1 $07
	vol $2
	note $35 $0e
	note $36 $07
	wait1 $07
	vol $1
	note $35 $0e
	note $36 $07
	wait1 $85
	goto musicf61c7
	cmdff
; $f634b
; @addr{f634b}
sound1dChannel0:
	vol $0
	note $20 $09
	vibrato $e1
	env $0 $00
	duty $02
	vol $4
	note $17 $03
	note $1c $04
	note $1d $03
	note $23 $04
	note $23 $03
	note $28 $04
	note $29 $03
	note $2f $04
	note $2f $03
	note $34 $04
	note $35 $03
	note $3b $04
	note $3b $03
	note $40 $04
	note $41 $03
	note $47 $04
	wait1 $2f
musicf6377:
	vol $8
	note $18 $0e
	note $19 $0e
	note $18 $0e
	note $19 $0e
	note $18 $0e
	note $19 $0e
	note $18 $0e
	note $19 $0e
	note $18 $0e
	note $19 $0e
	note $18 $0e
	note $19 $0e
	note $18 $0e
	note $19 $0e
	note $18 $0e
	note $19 $0e
	note $18 $0e
	note $19 $0e
	note $18 $0e
	note $19 $0e
	note $18 $0e
	note $19 $0e
	note $18 $0e
	note $19 $0e
	note $18 $0e
	note $19 $0e
	note $18 $0e
	note $19 $0e
	note $18 $0e
	note $19 $0e
	note $18 $0e
	note $19 $0e
	note $18 $0e
	note $19 $0e
	note $18 $0e
	note $19 $0e
	note $18 $0e
	note $19 $0e
	note $18 $0e
	note $19 $0e
	note $18 $0e
	note $19 $0e
	note $18 $0e
	note $19 $0e
	note $18 $0e
	note $19 $0e
	note $18 $0e
	note $19 $0e
	note $1a $0e
	note $1b $0e
	note $1a $0e
	note $1b $0e
	note $1a $0e
	note $1b $0e
	note $19 $0e
	note $1a $0e
	note $13 $0e
	note $14 $0e
	note $13 $0e
	note $14 $0e
	note $14 $0e
	note $15 $0e
	note $15 $0e
	note $16 $0e
	vol $8
	note $20 $2a
	vol $4
	note $20 $0e
	vol $8
	note $20 $07
	wait1 $03
	vol $4
	note $20 $04
	vol $8
	note $20 $0e
	note $24 $0e
	note $20 $0e
	note $1f $2a
	vol $4
	note $1f $0e
	vol $8
	note $1f $07
	wait1 $03
	vol $4
	note $1f $04
	vol $8
	note $1f $0e
	note $22 $0e
	note $1f $0e
	note $20 $2a
	vol $4
	note $20 $0e
	vol $8
	note $20 $07
	wait1 $03
	vol $4
	note $20 $04
	vol $8
	note $20 $0e
	note $24 $0e
	note $20 $0e
	note $22 $1c
	note $23 $1c
	note $24 $1c
	note $26 $0e
	note $28 $0e
	note $29 $07
	wait1 $03
	vol $4
	note $29 $07
	wait1 $04
	vol $2
	note $29 $07
	vol $8
	note $20 $1c
	vol $4
	note $20 $0e
	vol $8
	note $24 $0e
	note $29 $0e
	note $2c $0e
	note $2b $07
	wait1 $03
	vol $4
	note $2b $07
	wait1 $04
	vol $2
	note $2b $07
	vol $8
	note $1f $1c
	vol $4
	note $1f $0e
	vol $8
	note $23 $0e
	note $28 $0e
	note $2b $0e
	note $1d $2a
	vol $4
	note $1d $0e
	vol $8
	note $21 $0e
	note $26 $0e
	note $29 $0e
	note $2d $0e
	note $2e $07
	wait1 $03
	vol $4
	note $2e $07
	wait1 $04
	vol $2
	note $2e $07
	wait1 $03
	vol $1
	note $2e $07
	wait1 $20
	vol $8
	note $25 $0e
	note $24 $0e
	note $23 $0e
	vol $4
	note $23 $0e
	vol $8
	note $23 $0e
	note $22 $0e
	note $21 $0e
	vol $4
	note $21 $0e
	vol $8
	note $21 $0e
	note $20 $0e
	note $1f $0e
	goto musicf6377
	cmdff
; $f64b1
; @addr{f64b1}
sound1dChannel4:
	duty $0e
	note $0b $70
musicf64b5:
	duty $01
	note $11 $0e
	note $12 $0e
	note $11 $0e
	note $12 $0e
	note $11 $0e
	note $12 $0e
	note $11 $0e
	note $12 $0e
	note $11 $0e
	note $12 $0e
	note $11 $0e
	note $12 $0e
	note $11 $0e
	note $12 $0e
	note $11 $0e
	note $12 $0e
	note $11 $0e
	note $12 $0e
	note $11 $0e
	note $12 $0e
	note $11 $0e
	note $12 $0e
	note $11 $0e
	note $12 $0e
	note $11 $0e
	note $12 $0e
	note $11 $0e
	note $12 $0e
	note $11 $0e
	note $12 $0e
	note $11 $0e
	note $12 $0e
	note $11 $0e
	note $12 $0e
	note $11 $0e
	note $12 $0e
	note $11 $0e
	note $12 $0e
	note $11 $0e
	note $12 $0e
	note $11 $0e
	note $12 $0e
	note $11 $0e
	note $12 $0e
	note $11 $0e
	note $12 $0e
	note $11 $0e
	note $12 $0e
	note $13 $0e
	note $14 $0e
	note $13 $0e
	note $14 $0e
	note $13 $0e
	note $14 $0e
	note $12 $0e
	note $13 $0e
	note $0c $0e
	note $0d $0e
	note $0c $0e
	note $0d $0e
	note $0e $0e
	note $0f $0e
	note $10 $0e
	note $11 $0e
	duty $0e
	note $11 $07
	duty $0f
	note $11 $07
	duty $0e
	note $11 $15
	duty $0f
	note $11 $07
	duty $0e
	note $11 $07
	duty $0f
	note $11 $07
	duty $0e
	note $11 $07
	duty $0f
	note $11 $07
	duty $0e
	note $11 $15
	duty $0f
	note $11 $07
	duty $0e
	note $11 $07
	duty $0f
	note $11 $07
	duty $0e
	note $10 $07
	duty $0f
	note $10 $07
	duty $0e
	note $10 $15
	duty $0f
	note $10 $07
	duty $0e
	note $10 $07
	duty $0f
	note $10 $07
	duty $0e
	note $10 $07
	duty $0f
	note $10 $07
	duty $0e
	note $10 $15
	duty $0f
	note $10 $07
	duty $0e
	note $10 $07
	duty $0f
	note $10 $07
	duty $0e
	note $11 $07
	duty $0f
	note $11 $07
	duty $0e
	note $11 $15
	duty $0f
	note $11 $07
	duty $0e
	note $11 $07
	duty $0f
	note $11 $07
	duty $0e
	note $11 $07
	duty $0f
	note $11 $07
	duty $0e
	note $11 $15
	duty $0f
	note $11 $07
	duty $0e
	note $11 $07
	duty $0f
	note $11 $07
	duty $0e
	note $13 $07
	duty $0f
	note $13 $07
	duty $0e
	note $13 $15
	duty $0f
	note $13 $07
	duty $0e
	note $13 $07
	duty $0f
	note $13 $07
	duty $0e
	note $18 $07
	duty $0f
	note $18 $07
	duty $0e
	note $18 $15
	duty $0f
	note $18 $07
	duty $0e
	note $18 $07
	duty $0f
	note $18 $07
	duty $0e
	note $11 $07
	duty $0f
	note $11 $07
	duty $0e
	note $11 $15
	duty $0f
	note $11 $07
	duty $0e
	note $11 $07
	duty $0f
	note $11 $07
	duty $0e
	note $11 $07
	duty $0f
	note $11 $07
	duty $0e
	note $11 $15
	duty $0f
	note $11 $07
	duty $0e
	note $11 $07
	duty $0f
	note $11 $07
	duty $0e
	note $10 $07
	duty $0f
	note $10 $07
	duty $0e
	note $10 $15
	duty $0f
	note $10 $07
	duty $0e
	note $10 $07
	duty $0f
	note $10 $07
	duty $0e
	note $10 $07
	duty $0f
	note $10 $07
	duty $0e
	note $10 $15
	duty $0f
	note $10 $07
	duty $0e
	note $10 $07
	duty $0f
	note $10 $07
	duty $0e
	note $0e $07
	duty $0f
	note $0e $07
	duty $0e
	note $0e $07
	duty $0f
	note $0e $15
	duty $0e
	note $0e $07
	duty $0f
	note $0e $07
	duty $0e
	note $0e $07
	duty $0f
	note $0e $07
	duty $0e
	note $0e $15
	duty $0f
	note $0e $07
	duty $0e
	note $0e $07
	duty $0f
	note $0e $07
	duty $0e
	note $18 $07
	duty $0f
	note $18 $0e
	wait1 $07
	duty $0e
	note $0c $54
	duty $0f
	note $0c $0c
	wait1 $64
	goto musicf64b5
	cmdff
; $f669f
; @addr{f669f}
sound1dChannel6:
	wait1 $70
musicf66a1:
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
	goto musicf66a1
	cmdff
; $f6855
; @addr{f6855}
sound46Channel1:
	vibrato $00
	env $0 $00
	duty $01
musicf685b:
	vol $6
	note $23 $2c
	note $25 $42
	vol $3
	note $25 $16
	vol $6
	note $25 $2c
	note $27 $42
	vol $3
	note $27 $16
	vol $6
	note $27 $2c
	note $28 $2c
	note $2b $2c
	note $2e $2c
	note $31 $2c
	note $34 $2c
	note $37 $2c
	vol $6
	note $3a $03
	wait1 $03
	note $3e $05
	vol $4
	note $3a $03
	vol $6
	note $3a $03
	vol $4
	note $3e $05
	wait1 $03
	note $3a $03
	vol $6
	note $3a $05
	wait1 $07
	vol $4
	note $3a $04
	vol $6
	note $3a $03
	wait1 $03
	note $3e $05
	vol $4
	note $3a $03
	vol $6
	note $3a $03
	vol $4
	note $3e $05
	wait1 $03
	note $3a $03
	vol $6
	note $3a $05
	wait1 $07
	vol $4
	note $3a $04
	vol $6
	note $3a $03
	wait1 $03
	note $3e $05
	vol $4
	note $3a $03
	vol $6
	note $3a $03
	vol $4
	note $3e $05
	wait1 $03
	note $3a $03
	vol $6
	note $3a $05
	wait1 $07
	vol $4
	note $3a $04
	vol $6
	note $3a $03
	wait1 $03
	note $3e $05
	vol $4
	note $3a $03
	vol $6
	note $3a $03
	vol $4
	note $3e $05
	wait1 $03
	note $3a $03
	vol $6
	note $3a $05
	wait1 $07
	vol $4
	note $3a $04
	vol $6
	note $3e $0b
	note $41 $0b
	note $44 $0b
	note $48 $0b
	wait1 $58
	vol $6
	note $25 $2c
	note $27 $42
	vol $3
	note $27 $16
	vol $6
	note $27 $2c
	note $29 $42
	vol $3
	note $29 $16
	vol $6
	note $29 $2c
	vol $6
	note $2a $2c
	note $2d $2c
	note $30 $2c
	note $33 $2c
	note $36 $2c
	note $39 $2c
	note $3c $03
	wait1 $03
	note $40 $05
	vol $4
	note $3c $03
	vol $6
	note $3c $03
	vol $4
	note $40 $05
	wait1 $03
	note $3c $03
	vol $6
	note $3c $05
	wait1 $07
	vol $4
	note $3c $04
	vol $6
	note $3c $03
	wait1 $03
	note $40 $05
	vol $4
	note $3c $03
	vol $6
	note $3c $03
	vol $4
	note $40 $05
	wait1 $03
	note $3c $03
	vol $6
	note $3c $05
	wait1 $07
	vol $4
	note $3c $04
	vol $6
	note $3c $03
	wait1 $03
	note $40 $05
	vol $4
	note $3c $03
	vol $6
	note $3c $03
	vol $4
	note $40 $05
	wait1 $03
	note $3c $03
	vol $6
	note $3c $05
	wait1 $07
	vol $4
	note $3c $04
	vol $6
	note $3c $03
	wait1 $03
	note $40 $05
	vol $3
	note $3c $03
	vol $6
	note $3c $03
	vol $3
	note $40 $05
	wait1 $03
	note $3c $03
	vol $6
	note $3c $05
	wait1 $07
	vol $3
	note $3c $04
	vol $6
	note $40 $0b
	note $43 $0b
	note $46 $0b
	note $48 $0b
	wait1 $58
	goto musicf685b
	cmdff
; $f6993
; @addr{f6993}
sound46Channel0:
	vibrato $00
	env $0 $00
	duty $01
musicf6999:
	vol $7
	note $1e $2c
	note $20 $4d
	vol $3
	note $20 $0b
	vol $7
	note $20 $2c
	note $22 $4d
	vol $3
	note $22 $0b
	vol $7
	note $22 $2c
	note $23 $2c
	note $26 $2c
	note $29 $2c
	note $2c $2c
	note $2f $2c
	note $32 $2c
	note $34 $b0
	wait1 $10
	vol $3
	note $3e $0b
	note $41 $0b
	note $44 $0b
	note $48 $0b
	wait1 $48
	vol $6
	note $20 $2c
	note $22 $4d
	vol $3
	note $22 $0b
	vol $6
	note $22 $2c
	note $24 $4d
	vol $3
	note $24 $0b
	vol $6
	note $24 $2c
	note $25 $2c
	note $28 $2c
	note $2b $2c
	note $2e $2c
	note $31 $2c
	note $34 $2c
	note $36 $b0
	wait1 $10
	vol $3
	note $40 $0b
	note $43 $0b
	note $46 $0b
	note $48 $0b
	wait1 $48
	goto musicf6999
	cmdff
; $f69f9
; @addr{f69f9}
sound46Channel4:
musicf69f9:
	duty $0e
	note $13 $2c
	note $15 $42
	wait1 $16
	note $15 $2c
	note $17 $42
	wait1 $16
	note $17 $2c
	note $18 $2c
	note $1c $2c
	note $1f $2c
	note $22 $2c
	note $25 $2c
	note $28 $2c
	note $2b $b0
	wait1 $84
	note $15 $2c
	note $17 $42
	wait1 $16
	note $17 $2c
	note $19 $42
	wait1 $16
	note $19 $2c
	note $1a $2c
	note $1e $2c
	note $21 $2c
	note $24 $2c
	note $27 $2c
	note $2a $2c
	note $2d $b0
	wait1 $84
	goto musicf69f9
	cmdff
; $f6a3b
; @addr{f6a3b}
sound38Channel1:
musicf6a3b:
	vibrato $f1
	env $0 $00
	duty $02
	vol $6
	note $2e $0b
	note $30 $0b
	note $31 $0b
	note $33 $0b
	note $35 $2c
	note $33 $16
	note $38 $16
	note $3a $0b
	wait1 $05
	vol $3
	note $3a $06
	vol $6
	note $35 $0b
	note $33 $0b
	note $35 $2c
	note $33 $16
	note $38 $16
	note $3c $03
	note $3d $03
	note $3c $10
	note $3a $0b
	note $38 $0b
	note $35 $0b
	wait1 $05
	vol $3
	note $35 $06
	vol $6
	note $3a $0b
	note $38 $0b
	note $35 $16
	note $33 $0b
	note $31 $0b
	note $2e $0b
	wait1 $05
	vol $3
	note $2e $06
	vol $6
	note $35 $0b
	note $33 $0b
	note $35 $2c
	vibrato $01
	env $0 $00
	vol $3
	note $35 $16
	vibrato $f1
	env $0 $00
	vol $6
	note $3a $0b
	wait1 $05
	vol $3
	note $3a $06
	vol $6
	note $3c $0b
	note $3d $0b
	note $3f $0b
	wait1 $05
	vol $3
	note $3f $06
	vol $6
	note $3f $21
	note $3c $0b
	note $41 $0b
	note $3f $03
	note $41 $03
	note $3f $05
	note $3d $0b
	note $3c $0b
	note $3a $2c
	vibrato $01
	env $0 $00
	vol $3
	note $3a $0b
	vibrato $f1
	env $0 $00
	vol $6
	note $3c $0b
	note $3d $0b
	note $41 $0b
	note $43 $0b
	note $44 $05
	note $43 $06
	note $41 $0b
	note $3f $0b
	note $41 $2c
	note $3f $05
	wait1 $01
	vol $4
	note $3f $07
	wait1 $01
	vol $3
	note $3f $05
	wait1 $03
	vol $6
	note $3d $05
	wait1 $01
	vol $4
	note $3d $07
	wait1 $01
	vol $3
	note $3d $05
	wait1 $03
	vol $6
	note $3c $05
	wait1 $01
	vol $4
	note $3c $07
	wait1 $01
	vol $3
	note $3c $05
	wait1 $03
	vol $6
	note $3a $05
	wait1 $01
	vol $3
	note $3a $07
	wait1 $01
	vol $3
	note $3a $05
	wait1 $03
	vol $6
	note $2e $16
	note $35 $16
	note $33 $16
	note $35 $0b
	note $36 $0b
	note $38 $16
	vibrato $01
	env $0 $00
	vol $3
	note $38 $16
	vol $1
	note $38 $0b
	wait1 $0b
	vibrato $f1
	env $0 $00
	vol $6
	note $3a $16
	note $41 $0b
	wait1 $05
	vol $3
	note $41 $06
	vol $6
	note $3f $0b
	note $3d $0b
	note $3c $16
	note $3d $16
	note $3c $16
	note $3a $0b
	note $38 $0b
	note $35 $0b
	wait1 $05
	vol $3
	note $35 $06
	vol $6
	note $3a $0b
	note $38 $0b
	note $35 $07
	wait1 $04
	note $35 $0b
	note $33 $0b
	note $31 $0b
	note $2e $05
	wait1 $01
	vol $5
	note $2e $07
	wait1 $01
	vol $4
	note $2e $05
	wait1 $03
	vol $6
	note $35 $05
	wait1 $01
	vol $4
	note $35 $07
	wait1 $01
	vol $3
	note $35 $05
	wait1 $03
	vol $6
	note $3a $05
	wait1 $06
	vol $5
	note $3a $05
	wait1 $06
	vol $4
	note $3a $05
	wait1 $27
	vol $6
	note $3a $0b
	note $3c $0b
	note $3d $0b
	note $3f $0b
	note $41 $0b
	wait1 $05
	vol $3
	note $41 $06
	vol $6
	note $3f $0b
	note $3d $0b
	note $3c $0b
	note $3a $0b
	note $3c $0b
	note $3a $0b
	note $38 $0b
	note $35 $0b
	wait1 $05
	vol $3
	note $35 $0b
	wait1 $06
	vol $6
	note $3a $0b
	wait1 $05
	vol $3
	note $3a $06
	vol $6
	note $35 $16
	note $3f $0b
	note $3d $0b
	note $3c $0b
	note $3d $05
	note $3c $06
	note $3a $0b
	note $38 $0b
	note $3a $16
	note $33 $0b
	note $35 $0b
	note $33 $16
	note $31 $07
	note $33 $07
	note $31 $08
	note $30 $07
	note $31 $07
	note $30 $08
	note $2c $07
	note $2e $07
	note $2c $08
	note $2e $05
	wait1 $01
	vol $4
	note $2e $07
	wait1 $09
	vol $6
	note $33 $05
	wait1 $01
	vol $4
	note $33 $07
	wait1 $09
	vol $6
	note $3a $05
	wait1 $01
	vol $4
	note $3a $07
	wait1 $01
	vol $2
	note $3a $05
	wait1 $45
	goto musicf6a3b
	cmdff
; $f6c10
; @addr{f6c10}
sound38Channel0:
musicf6c10:
	vibrato $00
	env $0 $04
	duty $02
	vol $6
	note $22 $16
	note $29 $16
	note $2c $16
	note $29 $16
	note $24 $16
	note $29 $16
	note $25 $16
	note $29 $16
	note $2e $16
	note $29 $16
	note $24 $16
	note $2b $16
	note $22 $16
	note $29 $16
	note $2c $16
	note $29 $16
	note $20 $16
	note $2c $16
	note $1e $16
	note $29 $16
	note $2e $16
	note $29 $16
	note $1e $16
	note $29 $16
	note $1d $16
	note $2c $16
	note $30 $16
	note $2c $16
	note $1d $16
	note $2c $16
	note $22 $16
	note $29 $16
	note $2c $16
	note $25 $16
	note $27 $16
	note $25 $0b
	note $24 $0b
	note $22 $0b
	note $24 $0b
	note $25 $0b
	note $29 $0b
	note $2e $16
	note $29 $16
	note $2b $16
	vol $6
	note $29 $0b
	note $27 $0b
	vibrato $f1
	env $0 $00
	note $2a $2c
	note $1d $58
	wait1 $16
	note $1e $16
	note $1d $4d
	wait1 $0b
	note $1e $2c
	note $20 $2c
	note $1e $2c
	note $1f $16
	note $20 $0b
	wait1 $0b
	note $20 $16
	vol $6
	note $22 $0b
	wait1 $0b
	note $22 $16
	note $24 $0b
	wait1 $0b
	note $25 $16
	note $22 $16
	note $24 $16
	note $27 $16
	note $29 $16
	note $24 $16
	note $25 $16
	note $29 $16
	note $2e $16
	note $29 $16
	note $27 $16
	note $2c $16
	note $29 $16
	note $2c $16
	note $2b $16
	note $27 $16
	note $29 $16
	note $25 $16
	note $27 $16
	note $22 $16
	note $22 $16
	note $24 $0b
	note $25 $0b
	note $24 $16
	note $20 $16
	goto musicf6c10
	cmdff
; $f6cd3
; @addr{f6cd3}
sound38Channel4:
musicf6cd3:
	duty $0f
	wait1 $0b
	note $2e $0b
	note $30 $0b
	note $31 $0b
	note $33 $0b
	note $35 $2c
	note $33 $16
	note $38 $16
	note $3a $0b
	wait1 $0b
	note $35 $0b
	note $33 $0b
	note $35 $2c
	note $33 $16
	note $38 $16
	note $3c $03
	note $3d $03
	note $3c $10
	note $3a $0b
	note $38 $0b
	note $35 $0b
	wait1 $0b
	note $3a $0b
	note $38 $0b
	note $35 $16
	note $33 $0b
	note $31 $0b
	note $2e $0b
	wait1 $0b
	note $35 $0b
	note $33 $0b
	note $35 $2c
	wait1 $16
	note $3a $0b
	wait1 $0b
	note $3c $0b
	note $3d $0b
	note $3f $0b
	wait1 $0b
	note $3f $21
	note $3c $0b
	note $41 $0b
	note $3f $03
	note $41 $03
	note $3f $05
	note $3d $0b
	note $3c $0b
	note $3a $2c
	note $3a $0b
	note $3c $0b
	note $3d $0b
	note $41 $0b
	note $43 $0b
	note $44 $05
	note $43 $06
	note $41 $0b
	note $3f $0b
	note $41 $2c
	wait1 $4d
	duty $0e
	note $19 $2c
	note $18 $16
	note $1b $16
	note $1d $16
	note $18 $16
	wait1 $16
	note $19 $16
	note $18 $16
	note $18 $16
	note $1d $16
	note $18 $16
	note $19 $2c
	note $18 $2c
	note $16 $2c
	note $1b $2c
	note $16 $2c
	note $1b $16
	duty $0f
	note $1b $0b
	wait1 $0b
	duty $0e
	note $1e $2c
	note $20 $58
	duty $0f
	note $20 $16
	duty $0e
	note $1e $16
	note $20 $26
	duty $0f
	note $20 $06
	duty $0e
	note $20 $2c
	note $22 $2c
	note $20 $2c
	note $1e $2c
	note $1b $58
	duty $0f
	note $1b $16
	wait1 $16
	goto musicf6cd3
	cmdff
; $f6d9f
sound2bStart:
; @addr{f6d9f}
sound2bChannel1:
	vibrato $e1
	env $0 $00
	duty $02
	vol $6
	note $12 $0e
	note $13 $03
	wait1 $01
	vol $3
	note $13 $04
	wait1 $01
	vol $1
	note $13 $05
	vol $6
	note $1e $0e
	note $1f $03
	wait1 $01
	vol $3
	note $1f $04
	wait1 $01
	vol $1
	note $1f $05
	vol $6
	note $2a $0e
	note $2b $03
	wait1 $01
	vol $3
	note $2b $04
	wait1 $01
	vol $1
	note $2b $05
	vol $6
	note $36 $0e
	note $37 $03
	wait1 $01
	vol $3
	note $37 $04
	wait1 $01
	vol $1
	note $37 $05
	vol $6
	note $1e $04
	note $1f $05
	note $24 $05
	note $22 $46
	vibrato $01
	env $0 $00
	vol $3
	note $22 $1c
	vol $1
	note $22 $0e
	wait1 $0e
	vibrato $e1
	env $0 $00
musicf6dfa:
	vol $6
	note $30 $09
	wait1 $07
	vol $3
	note $30 $09
	wait1 $03
	vol $6
	note $30 $09
	wait1 $05
	vol $3
	note $30 $04
	vol $6
	note $30 $0a
	note $37 $09
	wait1 $07
	vol $3
	note $37 $09
	wait1 $03
	vol $6
	note $37 $12
	wait1 $05
	note $37 $02
	note $39 $03
	note $3a $12
	note $39 $0a
	note $37 $12
	note $35 $0a
	note $37 $38
	vibrato $01
	env $0 $00
	vol $3
	note $37 $12
	vibrato $f1
	env $0 $00
	vol $6
	note $3c $05
	vol $3
	note $3c $05
	vol $6
	note $3c $0e
	vol $3
	note $3c $04
	vol $6
	note $3c $0a
	note $37 $09
	wait1 $09
	vol $3
	note $37 $0a
	vol $6
	note $37 $12
	note $39 $0a
	note $3a $12
	note $39 $0a
	note $37 $12
	note $35 $0a
	note $34 $12
	note $35 $0a
	note $36 $12
	note $37 $0a
	note $34 $09
	wait1 $0e
	vol $3
	note $34 $05
	vol $6
	note $30 $09
	wait1 $0e
	vol $3
	note $30 $05
	vol $6
	note $2e $09
	wait1 $0e
	vol $3
	note $2e $05
	wait1 $12
	vol $6
	note $34 $13
	vol $3
	note $34 $09
	vol $6
	note $34 $0a
	note $30 $09
	wait1 $0e
	vol $3
	note $30 $05
	vol $6
	note $2e $09
	wait1 $0e
	vol $3
	note $2e $05
	wait1 $1c
	vol $6
	note $34 $09
	wait1 $0e
	vol $3
	note $34 $05
	vol $6
	note $30 $09
	wait1 $0e
	vol $3
	note $30 $05
	vol $6
	note $2e $09
	wait1 $0e
	vol $3
	note $2e $05
	vol $6
	note $2b $38
	vibrato $01
	env $0 $00
	vol $3
	note $2b $38
	wait1 $1c
	vibrato $f1
	env $0 $00
	vol $6
	note $34 $09
	wait1 $0e
	vol $3
	note $34 $05
	vol $6
	note $30 $09
	wait1 $0e
	vol $3
	note $30 $05
	vol $6
	note $2e $09
	wait1 $0e
	vol $3
	note $2e $05
	wait1 $12
	vol $6
	note $34 $13
	vol $3
	note $34 $09
	vol $6
	note $34 $0a
	note $30 $09
	wait1 $0e
	vol $3
	note $30 $05
	vol $6
	note $2e $09
	wait1 $0e
	vol $3
	note $2e $05
	wait1 $1c
	vol $6
	note $34 $09
	wait1 $0e
	vol $3
	note $34 $05
	vol $6
	note $30 $09
	wait1 $0e
	vol $3
	note $30 $05
	vol $6
	note $3a $12
	note $39 $0a
	wait1 $09
	vol $3
	note $39 $09
	vol $6
	note $37 $54
	vibrato $01
	env $0 $00
	vol $3
	note $37 $1c
	vol $1
	note $37 $09
	wait1 $01
	vibrato $f1
	env $0 $00
	goto musicf6dfa
	cmdff
; $f6f21
; @addr{f6f21}
sound2bChannel0:
	vibrato $e1
	env $0 $00
	duty $02
	vol $6
	note $0d $0e
	note $0c $03
	wait1 $01
	vol $3
	note $0c $04
	wait1 $01
	vol $1
	note $0c $05
	vol $6
	note $19 $0e
	note $18 $03
	wait1 $01
	vol $3
	note $18 $04
	wait1 $01
	vol $1
	note $18 $05
	vol $6
	note $25 $0e
	note $24 $03
	wait1 $01
	vol $3
	note $24 $04
	wait1 $01
	vol $1
	note $24 $05
	vol $6
	note $31 $0e
	note $30 $03
	wait1 $01
	vol $3
	note $30 $04
	wait1 $01
	vol $1
	note $30 $05
	vol $6
	note $12 $04
	note $13 $05
	note $18 $05
	note $16 $46
	vibrato $01
	env $0 $00
	vol $3
	note $16 $1c
	vol $1
	note $16 $0e
	wait1 $0e
	vibrato $f1
	env $0 $00
musicf6f7c:
	wait1 $ff
	wait1 $47
	vol $6
	note $1e $0a
	note $1f $12
	note $1e $0a
	note $1f $12
	note $1e $0a
	note $1f $0e
	wait1 $04
	note $1d $0a
	note $1c $12
	note $1a $0a
	note $18 $09
	wait1 $48
	vol $6
	note $1e $03
	note $1f $07
	wait1 $04
	vol $3
	note $1e $03
	note $1f $07
	wait1 $04
	vol $1
	note $1e $03
	note $1f $07
	wait1 $41
	vol $6
	note $1e $02
	note $1f $07
	note $1e $03
	note $1f $07
	wait1 $04
	vol $3
	note $1e $03
	note $1f $07
	wait1 $04
	vol $1
	note $1e $03
	note $1f $07
	wait1 $72
	vol $6
	note $17 $09
	note $1b $0a
	note $1f $09
	note $23 $09
	note $27 $0a
	note $2b $2a
	note $29 $04
	note $28 $05
	note $26 $05
	note $24 $09
	wait1 $48
	note $1e $03
	note $1f $07
	wait1 $04
	vol $3
	note $1e $03
	note $1f $07
	wait1 $04
	vol $1
	note $1e $03
	note $1f $07
	wait1 $41
	vol $6
	note $2a $02
	note $2b $07
	note $2a $03
	note $2b $07
	wait1 $04
	vol $3
	note $2a $03
	note $2b $07
	wait1 $04
	vol $1
	note $2a $03
	note $2b $07
	wait1 $d9
	goto musicf6f7c
	cmdff
; $f700f
; @addr{f700f}
sound2bChannel4:
	wait1 $ee
	duty $0e
	note $13 $03
	note $11 $04
	note $0f $03
	note $0d $04
musicf701b:
	duty $0e
	note $0c $07
	duty $0f
	note $0c $0e
	wait1 $23
	duty $0e
	note $13 $07
	duty $0f
	note $13 $0e
	wait1 $23
	duty $0e
	note $0a $07
	duty $0f
	note $0a $0e
	wait1 $23
	duty $0e
	note $11 $07
	duty $0f
	note $11 $0e
	wait1 $23
	duty $0e
	note $0c $07
	duty $0f
	note $0c $0e
	wait1 $23
	duty $0e
	note $13 $07
	duty $0f
	note $13 $0e
	wait1 $23
	duty $0e
	note $0e $07
	duty $0f
	note $0e $0e
	wait1 $35
	duty $0e
	note $13 $0a
	duty $0e
	note $15 $09
	duty $0f
	note $15 $09
	duty $0e
	note $17 $0a
	duty $0e
	note $0c $1c
	duty $0f
	note $0c $0e
	wait1 $0e
	duty $0e
	note $13 $07
	duty $0f
	note $13 $0e
	wait1 $23
	duty $0e
	note $16 $07
	duty $0f
	note $16 $0e
	wait1 $23
	duty $0e
	note $11 $07
	duty $0f
	note $11 $0e
	wait1 $23
	duty $0e
	note $18 $07
	duty $0f
	note $18 $0e
	wait1 $23
	duty $0e
	note $16 $07
	duty $0f
	note $16 $0e
	wait1 $07
	duty $0e
	note $13 $0e
	note $07 $04
	note $0b $05
	note $0f $05
	duty $0e
	note $13 $38
	note $12 $02
	duty $0e
	note $13 $07
	duty $0f
	note $13 $0e
	wait1 $21
	duty $0e
	note $18 $07
	duty $0f
	note $18 $0e
	wait1 $23
	duty $0e
	note $13 $07
	duty $0f
	note $13 $0e
	wait1 $23
	duty $0e
	note $16 $07
	duty $0f
	note $16 $0e
	wait1 $23
	duty $0e
	note $11 $07
	duty $0f
	note $11 $0e
	wait1 $23
	duty $0e
	note $18 $07
	duty $0f
	note $18 $0e
	wait1 $07
	duty $0e
	note $18 $07
	duty $0f
	note $18 $0e
	wait1 $07
	duty $0e
	note $16 $07
	duty $0f
	note $16 $0e
	wait1 $07
	duty $0e
	note $13 $2e
	note $14 $0a
	note $16 $12
	note $17 $0a
	note $19 $12
	note $1b $0a
	note $1d $12
	note $1f $0a
	goto musicf701b
	cmdff
; $f7123
; @addr{f7123}
sound2bChannel6:
	wait1 $fc
musicf7125:
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
	wait1 $09
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
	wait1 $70
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
	wait1 $70
	goto musicf7125
	cmdff
; $f718f
sound3fStart:
; @addr{f718f}
sound3fChannel1:
	vibrato $e1
	env $0 $00
	cmdf2
	duty $01
	vol $5
	note $26 $2a
	vol $3
	note $26 $0e
	vol $5
	note $2b $54
	vibrato $01
	env $0 $00
	vol $3
	note $2b $1c
	vibrato $e1
	env $0 $00
	vol $5
	note $26 $1c
	note $2b $1c
	note $29 $0e
	note $28 $0e
	note $29 $1c
	note $24 $38
	vibrato $01
	env $0 $00
	vol $3
	note $24 $1c
	vibrato $e1
	env $0 $00
	vol $6
	note $24 $1c
	note $29 $1c
	note $2e $1c
	note $2c $0e
	note $2a $0e
	note $2c $1c
	note $27 $38
	vibrato $01
	env $0 $00
	vol $3
	note $27 $1c
	vibrato $e1
	env $0 $00
	vol $6
	note $27 $1c
	note $2c $1c
	note $31 $1c
	note $2f $0e
	note $2e $0e
	note $2f $1c
	note $2a $38
	vibrato $01
	env $0 $00
	vol $4
	note $2a $1c
	vibrato $e1
	env $0 $00
	vol $7
	note $2a $1c
	vol $6
	note $2f $1c
	vol $9
	note $34 $1c
	vol $4
	note $34 $07
	wait1 $03
	vol $3
	note $34 $07
	wait1 $04
	vol $2
	note $34 $07
	duty $02
	vol $6
	note $33 $15
	vol $4
	note $33 $07
	vol $6
	note $2e $07
	wait1 $03
	vol $4
	note $2e $04
	vol $6
	note $3a $07
	wait1 $03
	vol $4
	note $3a $04
	vol $6
	note $38 $1c
	note $37 $07
	wait1 $03
	vol $4
	note $37 $04
	vol $6
	note $35 $1c
	note $31 $07
	wait1 $03
	vol $4
	note $31 $04
	vol $6
	note $33 $07
	note $35 $07
	note $37 $07
	wait1 $03
	vol $4
	note $37 $04
	vol $6
	note $35 $0e
	note $33 $0e
	note $31 $0e
	note $35 $0e
	note $33 $1c
	vibrato $01
	env $0 $00
	vol $4
	note $33 $1c
	vibrato $e1
	env $0 $00
	vol $6
	note $33 $07
	note $35 $07
	note $37 $07
	note $38 $07
	wait1 $03
	vol $4
	note $38 $07
	wait1 $04
	vol $2
	note $38 $07
	wait1 $03
	vol $1
	note $38 $04
	vol $6
	note $3a $1c
	note $3f $1c
	vol $4
	note $3f $0e
	vol $6
	note $41 $0e
	note $3d $0e
	note $3a $07
	note $3d $07
	note $3f $07
	note $41 $07
	note $42 $07
	wait1 $03
	vol $4
	note $42 $04
	vol $6
	note $41 $0e
	note $3f $0e
	note $3d $0e
	note $3a $0e
	wait1 $03
	vol $4
	note $3a $07
	wait1 $04
	vol $6
	note $41 $07
	wait1 $03
	vol $4
	note $41 $04
	vol $6
	note $42 $07
	note $44 $07
	note $45 $07
	wait1 $03
	vol $4
	note $45 $04
	vol $6
	note $44 $0e
	note $42 $0e
	note $40 $0e
	note $3e $0e
	note $3c $1c
	note $3b $07
	wait1 $03
	vol $4
	note $3b $04
	vol $6
	note $39 $1c
	note $37 $07
	wait1 $03
	vol $4
	note $37 $04
	vol $6
	note $39 $38
	vibrato $01
	env $0 $00
	vol $4
	note $39 $1c
	vibrato $e1
	vol $6
	note $38 $1c
	vol $6
	note $36 $07
	wait1 $03
	vol $3
	note $36 $04
	vol $6
	note $34 $1c
	note $32 $07
	wait1 $03
	vol $3
	note $32 $04
	vol $6
	note $34 $46
	vibrato $01
	env $0 $00
	vol $3
	note $34 $0e
	vibrato $e1
	vol $6
	note $2f $07
	wait1 $07
	vol $4
	note $2f $07
	wait1 $07
	vol $2
	note $2f $07
	wait1 $07
	vol $1
	note $2f $07
	wait1 $07
	vibrato $e1
	env $0 $00
	vol $0
	note $2f $07
	wait1 $15
	vibrato $00
	duty $02
musicf731c:
	vol $5
	note $34 $05
	wait1 $05
	vol $7
	note $32 $05
	vol $3
	note $34 $05
	vol $7
	note $2d $05
	vol $4
	note $32 $05
	vol $7
	note $32 $05
	vol $4
	note $2d $05
	vol $7
	note $34 $05
	vol $4
	note $32 $05
	vol $7
	note $37 $05
	vol $4
	note $34 $05
	vol $7
	note $34 $05
	vol $4
	note $37 $05
	vol $7
	note $32 $05
	vol $4
	note $34 $05
	vol $7
	note $34 $05
	vol $4
	note $32 $05
	vol $7
	note $32 $05
	vol $4
	note $34 $05
	vol $7
	note $2d $05
	vol $4
	note $32 $05
	vol $7
	note $32 $05
	vol $4
	note $2d $05
	vol $7
	note $34 $05
	vol $4
	note $32 $05
	vol $7
	note $37 $05
	vol $4
	note $34 $05
	vol $7
	note $34 $05
	vol $4
	note $37 $05
	vol $7
	note $32 $05
	vol $4
	note $34 $05
	vol $7
	note $34 $05
	vol $4
	note $32 $05
	vol $7
	note $32 $05
	vol $4
	note $34 $05
	vol $7
	note $2d $05
	vol $4
	note $32 $05
	vol $7
	note $32 $05
	vol $4
	note $2d $05
	vol $7
	note $34 $05
	vol $4
	note $32 $05
	vol $7
	note $37 $05
	vol $4
	note $34 $05
	vol $7
	note $34 $05
	vol $4
	note $37 $05
	vol $7
	note $32 $05
	vol $4
	note $34 $05
	vol $7
	note $34 $05
	vol $4
	note $32 $05
	vol $7
	note $32 $05
	vol $4
	note $34 $05
	vol $7
	note $2d $05
	vol $4
	note $32 $05
	vol $7
	note $32 $05
	vol $4
	note $2d $05
	vol $7
	note $34 $05
	vol $4
	note $32 $05
	vol $7
	note $37 $05
	vol $4
	note $34 $05
	vol $7
	note $34 $05
	vol $4
	note $37 $05
	vol $7
	note $32 $05
	vol $4
	note $34 $05
	vol $7
	note $2d $05
	vol $4
	note $32 $05
	vol $7
	note $32 $05
	vol $4
	note $2d $05
	vol $7
	note $34 $05
	vol $4
	note $32 $05
	vol $7
	note $37 $05
	vol $4
	note $34 $05
	vol $7
	note $34 $05
	vol $4
	note $37 $05
	vol $7
	note $32 $05
	vol $4
	note $34 $05
	vol $7
	note $34 $05
	vol $4
	note $32 $05
	vol $7
	note $32 $05
	vol $4
	note $34 $05
	vol $7
	note $2d $05
	vol $4
	note $32 $05
	vol $7
	note $32 $05
	vol $4
	note $2d $05
	vol $7
	note $34 $05
	vol $4
	note $32 $05
	vol $7
	note $37 $05
	vol $4
	note $34 $05
	vol $7
	note $34 $05
	vol $4
	note $37 $05
	vol $7
	note $32 $05
	vol $4
	note $34 $05
	vol $7
	note $2d $05
	vol $4
	note $32 $05
	vol $7
	note $32 $05
	vol $4
	note $2d $05
	vol $7
	note $34 $05
	vol $4
	note $32 $05
	vol $7
	note $37 $05
	vol $4
	note $34 $05
	vol $7
	note $34 $05
	vol $4
	note $37 $05
	vol $7
	note $32 $05
	vol $4
	note $34 $05
	vol $7
	note $34 $05
	vol $4
	note $32 $05
	vol $7
	note $32 $05
	vol $4
	note $34 $05
	vol $7
	note $34 $05
	vol $4
	note $32 $05
	vol $7
	note $32 $05
	vol $4
	note $34 $05
	vol $7
	note $2d $05
	vol $4
	note $32 $05
	vol $7
	note $32 $05
	vol $4
	note $2d $05
	vol $7
	note $34 $05
	vol $4
	note $32 $05
	vol $7
	note $37 $05
	vol $4
	note $34 $05
	vol $7
	note $34 $05
	vol $4
	note $37 $05
	vol $7
	note $32 $05
	vol $4
	note $34 $05
	vol $7
	note $34 $05
	vol $4
	note $32 $05
	vol $7
	note $32 $05
	vol $4
	note $34 $05
	vol $7
	note $2d $05
	vol $4
	note $32 $05
	vol $7
	note $32 $05
	vol $4
	note $2d $05
	vol $7
	note $34 $05
	vol $4
	note $32 $05
	vol $7
	note $37 $05
	vol $4
	note $34 $05
	vol $7
	note $34 $05
	vol $4
	note $37 $05
	vol $7
	note $32 $05
	vol $4
	note $34 $05
	vol $7
	note $34 $05
	vol $4
	note $32 $05
	vol $7
	note $32 $05
	vol $4
	note $34 $05
	vol $7
	note $2d $05
	vol $4
	note $32 $05
	vol $7
	note $32 $05
	vol $4
	note $2d $05
	vol $7
	note $34 $05
	vol $4
	note $32 $05
	vol $7
	note $37 $05
	vol $4
	note $34 $05
	vol $7
	note $3b $05
	vol $4
	note $37 $05
	vol $7
	note $39 $05
	vol $4
	note $3b $05
	vol $7
	note $3b $05
	vol $4
	note $39 $05
	vol $7
	note $39 $05
	vol $4
	note $3b $05
	vol $7
	note $34 $05
	vol $4
	note $39 $05
	vol $7
	note $37 $05
	vol $4
	note $34 $05
	vol $7
	note $39 $05
	vol $4
	note $37 $05
	vol $7
	note $3c $05
	vol $4
	note $39 $05
	vol $7
	note $3b $05
	vol $4
	note $3c $05
	vol $7
	note $39 $05
	vol $4
	note $3b $05
	vol $7
	note $3b $05
	vol $4
	note $39 $05
	vol $7
	note $39 $05
	vol $4
	note $3b $05
	vol $7
	note $34 $05
	vol $4
	note $39 $05
	vol $7
	note $37 $05
	vol $4
	note $34 $05
	vol $7
	note $39 $05
	vol $4
	note $37 $05
	vol $7
	note $3c $05
	vol $4
	note $39 $05
	vol $7
	note $3b $05
	vol $4
	note $3c $05
	vol $7
	note $39 $05
	vol $4
	note $3b $05
	vol $7
	note $3b $05
	vol $4
	note $39 $05
	vol $7
	note $39 $05
	vol $4
	note $3b $05
	vol $7
	note $34 $05
	vol $4
	note $39 $05
	vol $7
	note $37 $05
	vol $4
	note $34 $05
	vol $7
	note $39 $05
	vol $4
	note $37 $05
	vol $7
	note $3c $05
	vol $4
	note $39 $05
	vol $7
	note $3b $05
	vol $4
	note $3c $05
	vol $7
	note $39 $05
	vol $4
	note $3b $05
	vol $7
	note $3b $05
	vol $4
	note $39 $05
	vol $7
	note $39 $05
	vol $4
	note $3b $05
	vol $7
	note $34 $05
	vol $4
	note $39 $05
	vol $7
	note $37 $05
	vol $4
	note $34 $05
	vol $7
	note $39 $05
	vol $4
	note $37 $05
	vol $7
	note $3c $05
	vol $4
	note $39 $05
	vol $7
	note $3b $05
	vol $4
	note $3c $05
	vol $7
	note $39 $05
	vol $4
	note $3b $05
	vol $7
	note $3b $05
	vol $4
	note $39 $05
	vol $7
	note $39 $05
	vol $4
	note $3b $05
	vol $7
	note $34 $05
	vol $4
	note $39 $05
	vol $7
	note $37 $05
	vol $4
	note $34 $05
	vol $7
	note $39 $05
	vol $4
	note $37 $05
	vol $7
	note $3c $05
	vol $4
	note $39 $05
	vol $7
	note $3b $05
	vol $4
	note $3c $05
	vol $7
	note $39 $05
	vol $4
	note $3b $05
	vol $7
	note $3b $05
	vol $4
	note $39 $05
	vol $7
	note $39 $05
	vol $4
	note $3b $05
	vol $7
	note $36 $05
	vol $4
	note $39 $05
	vol $7
	note $34 $05
	vol $4
	note $36 $05
	vol $7
	note $36 $05
	vol $4
	note $34 $05
	vol $7
	note $34 $05
	vol $4
	note $36 $05
	vol $7
	note $2f $05
	vol $4
	note $34 $05
	vol $7
	note $34 $05
	vol $4
	note $2f $05
	vol $7
	note $36 $05
	vol $4
	note $34 $05
	vol $7
	note $39 $05
	vol $4
	note $36 $05
	vol $7
	note $36 $05
	vol $4
	note $39 $05
	vol $7
	note $34 $05
	vol $4
	note $36 $05
	vol $7
	note $36 $05
	vol $4
	note $34 $05
	vol $7
	note $34 $05
	vol $4
	note $36 $05
	vol $7
	note $2f $05
	vol $4
	note $34 $05
	vol $7
	note $34 $05
	vol $4
	note $2f $05
	vol $7
	note $36 $05
	vol $4
	note $34 $05
	vol $7
	note $39 $05
	vol $4
	note $36 $05
	vol $7
	note $34 $05
	vol $4
	note $39 $05
	vol $7
	note $36 $05
	vol $4
	note $34 $05
	vol $7
	note $39 $05
	vol $4
	note $36 $05
	vol $7
	note $3b $05
	vol $4
	note $39 $05
	vol $7
	note $39 $05
	vol $4
	note $3b $05
	vol $7
	note $36 $05
	vol $4
	note $39 $05
	vol $7
	note $39 $05
	vol $4
	note $36 $05
	vol $7
	note $36 $05
	vol $4
	note $39 $05
	vol $7
	note $3b $05
	vol $4
	note $36 $05
	vol $7
	note $39 $05
	vol $4
	note $3b $05
	vol $7
	note $36 $05
	vol $4
	note $39 $05
	vol $7
	note $34 $05
	vol $4
	note $36 $05
	vol $7
	note $36 $05
	vol $4
	note $34 $05
	vol $7
	note $34 $05
	vol $4
	note $36 $05
	vol $7
	note $36 $05
	vol $4
	note $34 $05
	vol $7
	note $34 $05
	vol $4
	note $36 $05
	vol $7
	note $2f $05
	vol $4
	note $34 $05
	vol $7
	note $34 $05
	vol $4
	note $2f $05
	vol $7
	note $36 $05
	vol $4
	note $34 $05
	vol $7
	note $39 $05
	vol $4
	note $36 $05
	vol $7
	note $3b $05
	vol $4
	note $39 $05
	vol $7
	note $39 $05
	vol $4
	note $3b $05
	vol $7
	note $3e $05
	vol $4
	note $39 $05
	vol $7
	note $3d $05
	vol $4
	note $3e $05
	vol $7
	note $3b $05
	vol $4
	note $3d $05
	vol $7
	note $39 $05
	vol $4
	note $3b $05
	vol $7
	note $36 $05
	vol $4
	note $39 $05
	vol $7
	note $34 $05
	vol $4
	note $36 $05
	vol $7
	note $36 $05
	vol $4
	note $34 $05
	vol $7
	note $34 $05
	vol $4
	note $36 $05
	vol $7
	note $2f $05
	vol $4
	note $34 $05
	vol $7
	note $2d $05
	vol $4
	note $2f $05
	goto musicf731c
	cmdff
; $f770f
; @addr{f770f}
sound3fChannel0:
	vol $0
	note $20 $62
	vibrato $e1
	env $0 $00
	cmdf2
	duty $02
	vol $5
	note $32 $07
	note $37 $07
	note $3e $07
	wait1 $03
	vol $3
	note $3e $07
	wait1 $04
	vol $2
	note $3e $07
	wait1 $03
	vol $2
	note $3e $07
	wait1 $04
	vol $1
	note $3e $07
	wait1 $07
	duty $01
	vol $4
	note $23 $1c
	note $26 $1c
	note $24 $0e
	note $23 $0e
	note $24 $1c
	note $1f $1c
	vol $2
	note $1f $0e
	duty $02
	vol $5
	note $30 $07
	note $35 $07
	note $3c $07
	note $35 $07
	note $30 $07
	wait1 $03
	vol $4
	note $30 $07
	wait1 $04
	vol $3
	note $30 $07
	wait1 $03
	vol $2
	note $30 $07
	wait1 $04
	vol $1
	note $30 $07
	wait1 $31
	duty $01
	vol $5
	note $27 $0e
	note $25 $0e
	vol $5
	note $27 $1c
	note $22 $1c
	vol $2
	note $22 $0e
	duty $02
	vol $5
	note $33 $07
	note $38 $07
	note $3d $07
	wait1 $03
	vol $4
	note $3d $07
	wait1 $04
	vol $3
	note $3d $07
	wait1 $03
	vol $2
	note $3d $07
	wait1 $04
	vol $1
	note $3d $07
	wait1 $07
	duty $01
	vol $6
	note $24 $1c
	vol $7
	note $29 $1c
	vol $6
	note $2a $0e
	note $29 $0e
	note $2a $1c
	note $25 $1c
	vol $4
	note $25 $0e
	duty $02
	vol $6
	note $36 $07
	note $3b $07
	vol $6
	note $40 $07
	wait1 $03
	vol $5
	note $40 $07
	wait1 $04
	vol $4
	note $40 $07
	wait1 $03
	vol $3
	note $40 $07
	wait1 $04
	vol $2
	note $40 $07
	wait1 $07
	vol $6
	note $23 $07
	vol $6
	note $25 $07
	vol $7
	note $27 $07
	vol $7
	note $28 $07
	vol $8
	note $2a $07
	vol $8
	note $2c $07
	vol $9
	note $2d $07
	vol $9
	note $2f $07
	vol $3
	note $2f $07
	wait1 $03
	vol $3
	note $2f $07
	wait1 $04
	vol $2
	note $2f $07
	vol $6
	note $2e $15
	vol $4
	note $2e $07
	vol $6
	note $27 $07
	wait1 $03
	vol $4
	note $27 $04
	vol $6
	note $2b $07
	wait1 $03
	vol $4
	note $2b $04
	vol $6
	note $29 $1c
	vol $4
	note $29 $0e
	vol $6
	note $25 $1c
	note $22 $07
	wait1 $03
	vol $4
	note $22 $04
	vol $6
	note $23 $0e
	note $27 $07
	wait1 $03
	vol $4
	note $27 $04
	vol $6
	note $25 $0e
	note $23 $0e
	note $22 $0e
	note $25 $0e
	note $22 $0e
	vol $4
	note $22 $0e
	vol $6
	note $1b $07
	note $22 $07
	note $27 $03
	wait1 $04
	note $27 $07
	note $2e $03
	wait1 $04
	note $2e $07
	note $33 $03
	wait1 $04
	note $33 $07
	wait1 $03
	vol $4
	note $33 $07
	wait1 $04
	vol $2
	note $33 $07
	wait1 $03
	vol $1
	note $33 $04
	vol $6
	note $33 $1c
	note $36 $1c
	vol $4
	note $36 $0e
	vol $6
	note $31 $0e
	note $2e $1c
	note $36 $07
	note $38 $07
	note $3a $07
	wait1 $03
	vol $4
	note $3a $04
	vol $6
	note $33 $0e
	note $31 $0e
	note $2e $0e
	note $33 $0e
	note $35 $0e
	note $31 $0e
	note $32 $07
	note $34 $07
	note $36 $07
	wait1 $03
	vol $4
	note $36 $04
	vol $6
	note $34 $0e
	note $31 $0e
	note $2f $0e
	note $36 $0e
	note $39 $1c
	note $37 $07
	wait1 $03
	vol $4
	note $37 $04
	vol $6
	note $35 $1c
	note $34 $07
	wait1 $03
	vol $4
	note $34 $04
	vol $6
	note $35 $1c
	note $34 $0e
	note $32 $1c
	note $30 $0e
	note $2f $1c
	note $2d $07
	wait1 $03
	vol $4
	note $2d $04
	vol $6
	note $2c $1c
	note $2a $07
	wait1 $03
	vol $4
	note $2a $04
	vol $6
	note $2c $1c
	note $2d $07
	wait1 $03
	vol $4
	note $2d $04
	vol $6
	note $2c $1c
	note $2a $07
	wait1 $03
	vol $4
	note $2a $04
	vol $6
	note $2c $07
	wait1 $07
	vol $5
	note $2c $07
	wait1 $07
	vol $3
	note $2c $07
	wait1 $07
	vol $2
	note $2c $07
	wait1 $07
	vol $1
	note $2c $07
	wait1 $15
	vibrato $00
	duty $01
musicf78ef:
	wait1 $78
	vol $7
	note $1c $28
	note $1f $46
	vol $4
	note $1f $0a
	vol $7
	note $1c $28
	note $1f $28
	note $21 $28
	note $24 $28
	note $23 $28
	note $1f $28
	note $21 $28
	note $1c $50
	vol $4
	note $1c $14
	vol $7
	note $1a $05
	vol $4
	note $1a $05
	vol $7
	note $1a $05
	vol $4
	note $1a $05
	vol $7
	note $1c $78
	vol $4
	note $1c $1e
	vol $2
	note $1c $1e
	vol $1
	note $1c $14
	vol $7
	note $21 $28
	note $24 $46
	vol $4
	note $24 $0a
	vol $7
	note $21 $28
	note $24 $28
	note $26 $28
	note $2a $28
	note $2d $28
	note $30 $28
	note $2f $5a
	vol $4
	note $2f $0a
	vol $7
	note $15 $05
	vol $4
	note $15 $05
	vol $7
	note $15 $05
	vol $4
	note $15 $05
	vol $7
	note $17 $78
	vol $4
	note $17 $1e
	vol $2
	note $17 $1e
	vol $1
	note $17 $1e
	vol $0
	note $17 $1e
	wait1 $78
	goto musicf78ef
	cmdff
; $f7960
; @addr{f7960}
sound3fChannel4:
	cmdf2
	duty $0e
	note $1f $07
	wait1 $07
	note $1d $07
	duty $0f
	note $1f $07
	duty $0e
	note $1f $07
	duty $0f
	note $1d $07
	duty $0e
	note $1a $07
	duty $0f
	note $1f $07
	duty $0e
	note $1f $07
	duty $0f
	note $1a $07
	duty $0e
	note $1d $07
	duty $0f
	note $1f $07
	duty $0e
	note $1f $07
	duty $0f
	note $1d $07
	duty $0e
	note $1a $07
	duty $0f
	note $1f $07
	duty $0e
	note $1f $07
	duty $0f
	note $1a $07
	duty $0e
	note $1d $07
	duty $0f
	note $1f $07
	duty $0e
	note $1f $07
	duty $0f
	note $1d $07
	duty $0e
	note $1a $07
	duty $0f
	note $1f $07
	duty $0e
	note $1f $07
	duty $0f
	note $1a $07
	duty $0e
	note $1d $07
	duty $0f
	note $1f $07
	duty $0e
	note $1f $07
	duty $0f
	note $1d $07
	duty $0e
	note $1a $07
	duty $0f
	note $1f $07
	duty $0e
	note $1f $07
	duty $0f
	note $1a $07
	duty $0e
	note $1d $07
	duty $0f
	note $1f $07
	duty $0e
	note $1f $07
	duty $0f
	note $1d $07
	duty $0e
	note $1a $07
	duty $0f
	note $1f $07
	duty $0e
	note $1f $07
	duty $0f
	note $1a $07
	duty $0e
	note $1d $07
	duty $0f
	note $1f $07
	duty $0e
	note $1f $07
	duty $0f
	note $1d $07
	duty $0e
	note $1a $07
	duty $0f
	note $1f $07
	duty $0e
	note $1f $07
	duty $0f
	note $1a $07
	duty $0e
	note $1d $07
	duty $0f
	note $1f $07
	duty $0e
	note $1f $07
	duty $0f
	note $1d $07
	duty $0e
	note $1a $07
	duty $0f
	note $1f $07
	duty $0e
	note $1f $07
	duty $0f
	note $1a $07
	duty $0e
	note $1d $07
	duty $0f
	note $1f $07
	duty $0e
	note $1f $07
	duty $0f
	note $1d $07
	duty $0e
	note $1a $07
	duty $0f
	note $1f $07
	duty $0e
	note $1d $07
	duty $0f
	note $1a $07
	duty $0e
	note $1b $07
	duty $0f
	note $1d $07
	duty $0e
	note $1d $07
	duty $0f
	note $1b $07
	duty $0e
	note $18 $07
	duty $0f
	note $1d $07
	duty $0e
	note $1d $07
	duty $0f
	note $18 $07
	duty $0e
	note $1b $07
	duty $0f
	note $1d $07
	duty $0e
	note $1d $07
	duty $0f
	note $1b $07
	duty $0e
	note $18 $07
	duty $0f
	note $1d $07
	duty $0e
	note $1d $07
	duty $0f
	note $18 $07
	duty $0e
	note $1b $07
	duty $0f
	note $1d $07
	duty $0e
	note $1d $07
	duty $0f
	note $1b $07
	duty $0e
	note $18 $07
	duty $0f
	note $1d $07
	duty $0e
	note $20 $07
	duty $0f
	note $18 $07
	duty $0e
	note $1e $07
	duty $0f
	note $20 $07
	duty $0e
	note $20 $07
	duty $0f
	note $1e $07
	duty $0e
	note $1b $07
	duty $0f
	note $20 $07
	duty $0e
	note $23 $07
	duty $0f
	note $1b $07
	duty $0e
	note $22 $07
	duty $0f
	note $23 $07
	duty $0e
	note $23 $07
	duty $0f
	note $22 $07
	duty $0e
	note $1e $07
	duty $0f
	note $23 $07
	duty $0e
	note $23 $07
	duty $0f
	note $1e $07
	duty $0e
	note $22 $07
	duty $0f
	note $23 $07
	duty $0e
	note $23 $07
	duty $0f
	note $22 $07
	duty $0e
	note $1e $07
	duty $0f
	note $23 $07
	duty $0e
	note $23 $07
	duty $0f
	note $1e $07
	duty $0e
	note $22 $07
	duty $0f
	note $23 $07
	duty $0e
	note $23 $07
	duty $0f
	note $22 $07
	duty $0e
	note $1e $07
	duty $0f
	note $23 $07
	duty $0e
	note $14 $07
	note $15 $07
	note $17 $07
	note $19 $07
	note $1b $07
	note $1c $07
	note $1e $07
	note $20 $07
	wait1 $1c
	note $0f $15
	duty $0f
	note $0f $0e
	duty $2c
	note $0f $07
	duty $0e
	note $0f $0e
	note $0d $0e
	duty $0f
	note $0d $0e
	duty $0e
	note $0d $0e
	note $11 $0e
	note $0f $0e
	note $0d $0e
	note $0b $0e
	duty $0f
	note $0b $0e
	duty $0e
	note $0b $0e
	note $0a $1c
	note $0d $0e
	note $0f $15
	duty $0f
	note $0f $07
	duty $0e
	note $0a $0e
	note $0f $0e
	note $0a $0e
	note $0f $0e
	note $0b $0e
	duty $0f
	note $0b $0e
	duty $0e
	note $12 $1c
	note $17 $1c
	note $16 $1c
	note $11 $0e
	note $16 $0e
	duty $0f
	note $16 $0e
	duty $0e
	note $11 $0e
	note $0a $1c
	note $0d $1c
	note $11 $1c
	note $0e $1c
	note $10 $1c
	duty $0f
	note $10 $0e
	duty $0e
	note $10 $0e
	note $11 $15
	duty $0f
	note $11 $07
	duty $0e
	note $11 $23
	duty $0f
	note $11 $07
	duty $0e
	note $11 $07
	duty $0f
	note $11 $07
	duty $0e
	note $11 $0e
	note $0c $0e
	note $0e $0e
	note $10 $0e
	note $11 $0e
	note $13 $0e
	note $10 $07
	duty $0f
	note $10 $07
	duty $0e
	note $10 $18
	duty $0f
	note $10 $04
	duty $0e
	note $10 $15
	duty $0f
	note $10 $07
	duty $0e
	note $10 $07
	duty $0f
	note $10 $07
	duty $0e
	note $10 $1c
	note $0b $0e
	note $10 $1c
	note $14 $0e
	note $10 $1c
	wait1 $38
musicf7c09:
	wait1 $78
	duty $0e
	note $21 $28
	note $26 $46
	duty $17
	note $26 $0a
	duty $0e
	note $21 $28
	note $26 $28
	note $28 $28
	note $2b $28
	note $2a $28
	note $26 $28
	note $28 $28
	note $21 $50
	duty $17
	note $21 $14
	duty $0e
	note $15 $05
	duty $17
	note $15 $05
	duty $0e
	note $15 $05
	duty $17
	note $15 $05
	duty $0e
	note $15 $78
	duty $17
	note $15 $1e
	duty $0f
	note $15 $1e
	duty $0c
	note $15 $14
	duty $0e
	note $28 $28
	note $2b $46
	duty $17
	note $2b $0a
	duty $0e
	note $28 $28
	note $2b $28
	note $2d $28
	note $2f $28
	note $32 $28
	note $35 $28
	note $36 $5a
	duty $17
	note $36 $0a
	duty $0e
	note $1c $05
	duty $17
	note $1c $05
	duty $0e
	note $1c $05
	duty $17
	note $1c $05
	duty $0e
	note $1e $78
	duty $17
	note $1e $1e
	duty $0f
	note $1e $1e
	duty $0c
	note $1e $1e
	duty $0c
	note $1e $1e
	wait1 $78
	goto musicf7c09
	cmdff
; $f7c93
; @addr{f7c93}
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
	wait1 $02
	note $2a $05
	note $2a $04
	note $2a $03
	note $2e $46
	wait1 $03
	note $2a $04
	note $2a $03
	note $2a $04
	vol $2
	note $2e $1c
	cmdff
; $f7dd7
; @addr{f7dd7}
sound31Channel1:
	vibrato $00
	env $0 $02
	cmdf2
	duty $02
	vol $6
	note $47 $02
	note $46 $02
	note $47 $03
	note $46 $02
	note $47 $07
	wait1 $28
	note $48 $02
	note $47 $02
	note $48 $03
	note $47 $02
	note $48 $07
	wait1 $3c
musicf7df7:
	vibrato $00
	env $0 $00
	duty $00
	note $3e $05
	note $3f $05
	note $3e $05
	note $3d $05
	note $3c $05
	note $3b $05
	note $3c $05
	note $3d $05
	note $3e $05
	note $3f $05
	note $3e $05
	note $3d $05
	note $3c $05
	note $3b $05
	note $3c $05
	note $3d $05
	note $3e $05
	vol $3
	note $3e $05
	vol $6
	note $4a $05
	vol $3
	note $4a $05
	vol $6
	note $3e $05
	vol $3
	note $3e $05
	vol $6
	note $3e $05
	note $3f $05
	note $40 $05
	note $41 $05
	note $40 $05
	note $3f $05
	note $3e $05
	vol $3
	note $3e $05
	wait1 $0a
	vol $6
	note $3e $05
	note $3f $05
	note $3e $05
	note $3d $05
	note $3c $05
	note $3b $05
	note $3c $05
	note $3d $05
	note $3e $05
	note $3f $05
	note $3e $05
	note $3d $05
	note $3c $05
	note $3b $05
	note $3c $05
	note $3d $05
	note $3e $05
	vol $3
	note $3e $05
	vol $6
	note $4a $05
	vol $3
	note $4a $05
	vol $6
	note $3e $05
	vol $3
	note $3e $05
	vol $6
	note $3e $05
	note $3f $05
	note $40 $05
	note $41 $05
	note $40 $05
	note $3f $05
	note $3e $05
	vol $3
	note $3e $05
	wait1 $0a
	vol $5
	note $3e $05
	note $3f $05
	note $3e $05
	note $3d $05
	note $3c $05
	note $3b $05
	note $3c $05
	note $3d $05
	note $3e $05
	note $3f $05
	note $3e $05
	note $3d $05
	note $3c $05
	note $3b $05
	note $3c $05
	note $3d $05
	vol $2
	note $3d $05
	wait1 $69
	vibrato $00
	env $0 $02
	duty $02
	vol $6
	note $4a $02
	note $48 $02
	note $47 $02
	note $45 $04
	note $43 $02
	note $42 $02
	note $40 $02
	note $3e $0b
	wait1 $53
	vibrato $00
	env $0 $00
	duty $00
	goto musicf7df7
	cmdff
; $f7ed1
; @addr{f7ed1}
sound31Channel0:
	vibrato $00
	env $0 $02
	cmdf2
	duty $02
	vol $6
	note $41 $07
	wait1 $31
	note $42 $07
	wait1 $45
musicf7ee1:
	vol $6
	note $2b $05
	wait1 $05
	note $32 $05
	wait1 $05
	note $26 $05
	wait1 $05
	note $32 $05
	wait1 $05
	note $2b $05
	wait1 $05
	note $32 $05
	wait1 $05
	note $26 $05
	wait1 $05
	note $32 $05
	wait1 $05
	note $2c $05
	wait1 $05
	note $33 $05
	wait1 $05
	note $27 $05
	wait1 $05
	note $33 $05
	wait1 $05
	note $2c $05
	wait1 $05
	note $33 $05
	wait1 $05
	note $27 $05
	wait1 $05
	note $33 $05
	wait1 $05
	note $2e $05
	wait1 $05
	note $35 $05
	wait1 $05
	note $29 $05
	wait1 $05
	note $35 $05
	wait1 $05
	note $2e $05
	wait1 $05
	note $35 $05
	wait1 $05
	note $29 $05
	wait1 $05
	note $35 $05
	wait1 $05
	note $30 $05
	wait1 $05
	note $37 $05
	wait1 $05
	note $2b $05
	wait1 $05
	note $37 $05
	wait1 $05
	note $30 $05
	wait1 $05
	note $37 $05
	wait1 $05
	note $2f $05
	wait1 $05
	note $2d $05
	wait1 $05
	vol $5
	note $2b $05
	wait1 $05
	note $32 $05
	wait1 $05
	note $26 $05
	wait1 $05
	note $32 $05
	wait1 $05
	note $2b $05
	wait1 $05
	note $32 $05
	wait1 $05
	note $26 $05
	wait1 $05
	note $32 $05
	wait1 $78
	vol $3
	note $4a $02
	note $48 $03
	note $47 $02
	note $45 $02
	note $43 $02
	note $42 $04
	note $40 $02
	note $3e $0a
	wait1 $4e
	goto musicf7ee1
	cmdff
; $f7f9a
sound93Start:
; @addr{f7f9a}
sound93Channel2:
	duty $02
	vol $b
	note $54 $01
	vol $0
	wait1 $0b
	vol $b
	note $48 $01
	vol $0
	wait1 $03
	vol $b
	note $41 $01
	vol $0
	wait1 $03
	vol $b
	note $3c $01
	vol $0
	wait1 $04
	vol $b
	note $3a $01
	vol $0
	wait1 $04
	vol $b
	note $35 $01
	vol $0
	wait1 $05
	vol $b
	note $32 $01
	cmdff
; $f7fc4
sound94Start:
; @addr{f7fc4}
sound94Channel2:
	vol $e
	cmdf8 $10
	note $11 $11
	cmdff
; $f7fca
sounda2Start:
; @addr{f7fca}
sounda2Channel2:
	duty $02
	vol $9
	note $38 $06
	vol $3
	note $38 $06
	vol $9
	note $3a $06
	vol $3
	note $3a $06
	vol $9
	note $3b $06
	vol $3
	note $3b $06
	vol $9
	note $42 $06
	vol $3
	note $42 $06
	cmdff
; $f7fe5
sounda3Start:
; @addr{f7fe5}
sounda3Channel7:
	cmdf0 $90
	note $14 $01
	cmdf0 $00
	note $00 $01
	cmdf0 $22
	note $14 $02
	cmdff
; $f7ff2
sounda7Start:
; @addr{f7ff2}
sounda7Channel2:
	vol $d
	note $48 $01
	vol $0
	wait1 $01
	vol $3
	note $48 $01
	cmdff
; $f7ffc
; GAP
	cmdff
	cmdff
	cmdff
	cmdff
.bank $3e slot 1
.org 0
sound25Start:
sound28Start:
sound2fStart:
sound30Start:
sound37Start:
sound39Start:
sound3aStart:
sound3bStart:
sound3cStart:
sound47Start:
sound48Start:
sound49Start:
sound4bStart:
; @addr{f8000}
sound25Channel6:
sound28Channel6:
sound2fChannel0:
sound2fChannel4:
sound2fChannel6:
sound30Channel4:
sound30Channel6:
sound37Channel4:
sound39Channel6:
sound3aChannel6:
sound3bChannel0:
sound3bChannel1:
sound3bChannel4:
sound3bChannel6:
sound3cChannel6:
sound47Channel0:
sound47Channel1:
sound47Channel4:
sound47Channel6:
sound48Channel0:
sound48Channel1:
sound48Channel4:
sound48Channel6:
sound49Channel0:
sound49Channel1:
sound49Channel4:
sound49Channel6:
sound4bChannel0:
sound4bChannel1:
sound4bChannel4:
sound4bChannel6:
	cmdff
; $f8001
soundcaStart:
; @addr{f8001}
soundcaChannel2:
	duty $02
	vol $f
	cmdf8 $ee
	note $1c $02
	cmdf8 $00
	vol $f
	note $15 $01
	vol $f
	note $15 $04
	env $0 $01
	note $16 $0c
	cmdf8 $f6
	cmdff
; $f8017
; @addr{f8017}
soundcaChannel7:
	cmdf0 $f1
	note $54 $02
	cmdf0 $51
	note $25 $0a
	cmdff
; $f8020
soundc4Start:
; @addr{f8020}
soundc4Channel5:
	duty $0b
	note $18 $02
	cmdf8 $1e
	note $18 $05
	wait1 $05
	note $18 $02
	cmdf8 $1e
	note $18 $08
	cmdff
; $f8031
soundccStart:
; @addr{f8031}
soundccChannel2:
	duty $00
	vol $c
	note $4f $02
	note $50 $01
	note $4f $01
	note $50 $01
	note $4f $01
	note $50 $01
	note $4f $01
	note $50 $01
	note $4f $01
	note $50 $01
	note $4f $01
	note $50 $01
	note $4f $01
	note $50 $01
	note $4f $01
	note $50 $01
	note $4f $01
	note $50 $01
	note $4f $01
	note $50 $01
	note $4f $01
	note $50 $01
	note $4f $01
	note $50 $01
	note $4f $01
	note $50 $01
	note $4f $01
	note $50 $01
	note $4f $01
	note $50 $01
	note $4f $01
	note $50 $01
	note $4f $01
	note $50 $01
	note $4f $01
	note $50 $01
	note $4f $01
	note $50 $01
	note $4f $01
	note $50 $01
	note $4f $01
	note $50 $01
	note $4f $01
	note $50 $01
	note $4f $01
	note $50 $01
	note $4f $01
	note $50 $01
	cmdff
; $f8095
soundcdStart:
; @addr{f8095}
soundcdChannel2:
	duty $01
	vol $0
	wait1 $03
	vol $c
	note $39 $01
	vol $d
	note $2b $01
	vol $e
	note $3c $01
	vol $a
	env $0 $01
	note $3c $08
	cmdff
; $f80a9
; @addr{f80a9}
soundcdChannel3:
	duty $00
	vol $0
	wait1 $03
	vol $d
	note $37 $03
	vol $a
	env $0 $01
	note $37 $08
	cmdff
; $f80b7
; @addr{f80b7}
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
; $f80cc
soundd6Start:
soundd7Start:
soundd8Start:
soundd9Start:
sounddaStart:
sounddbStart:
sounddcStart:
soundddStart:
; @addr{f80cc}
soundd6Channel1:
soundd7Channel1:
soundd8Channel1:
soundd9Channel1:
sounddaChannel1:
sounddbChannel1:
sounddcChannel1:
soundddChannel1:
	cmdff
; $f80cd
; @addr{f80cd}
soundd6Channel0:
soundd7Channel0:
soundd8Channel0:
soundd9Channel0:
sounddaChannel0:
sounddbChannel0:
sounddcChannel0:
soundddChannel0:
	cmdff
; $f80ce
; @addr{f80ce}
soundd6Channel4:
soundd7Channel4:
soundd8Channel4:
soundd9Channel4:
sounddaChannel4:
sounddbChannel4:
sounddcChannel4:
soundddChannel4:
	cmdff
; $f80cf
; @addr{f80cf}
soundd6Channel6:
soundd7Channel6:
soundd8Channel6:
soundd9Channel6:
sounddaChannel6:
sounddbChannel6:
sounddcChannel6:
soundddChannel6:
	cmdff
; $f80d0
; @addr{f80d0}
sound39Channel1:
	vibrato $00
	env $0 $00
	cmdf2
	duty $00
musicf80d7:
	vol $6
	note $25 $48
	note $24 $09
	wait1 $04
	vol $3
	note $24 $09
	wait1 $05
	vol $1
	note $24 $09
	vol $6
	note $2a $12
	note $2b $09
	wait1 $04
	vol $3
	note $2b $05
	vol $6
	note $2c $12
	note $2b $09
	wait1 $04
	vol $3
	note $2b $09
	wait1 $05
	vol $1
	note $2b $09
	wait1 $5a
	vol $6
	note $25 $48
	note $24 $09
	wait1 $04
	vol $3
	note $24 $09
	wait1 $05
	vol $1
	note $24 $09
	vol $6
	note $2a $12
	note $2b $09
	wait1 $04
	vol $3
	note $2b $05
	vol $6
	note $2e $0c
	note $2d $0c
	note $2c $0c
	note $2b $09
	wait1 $04
	vol $3
	note $2b $09
	wait1 $05
	vol $1
	note $2b $09
	wait1 $48
	vol $6
	note $30 $48
	note $2a $09
	wait1 $04
	vol $3
	note $2a $09
	wait1 $05
	vol $1
	note $2a $09
	vol $6
	note $29 $12
	note $27 $09
	wait1 $04
	vol $3
	note $27 $05
	vol $6
	note $29 $09
	note $27 $09
	note $24 $09
	wait1 $04
	vol $3
	note $24 $09
	wait1 $05
	vol $1
	note $24 $09
	wait1 $36
	vol $6
	note $29 $12
	note $27 $12
	note $2a $0c
	note $29 $0c
	note $27 $0c
	note $29 $12
	note $27 $12
	note $24 $09
	wait1 $04
	vol $3
	note $24 $09
	wait1 $05
	vol $1
	note $24 $09
	vol $6
	note $22 $12
	note $27 $12
	note $24 $09
	wait1 $04
	vol $3
	note $24 $09
	wait1 $05
	vol $1
	note $24 $09
	vol $6
	note $22 $09
	wait1 $04
	vol $3
	note $22 $09
	wait1 $05
	vol $1
	note $22 $09
	vol $6
	note $1c $48
	goto musicf80d7
	cmdff
; $f819b
; @addr{f819b}
sound39Channel0:
	cmdf2
	env $0 $02
	vol $9
musicf819f:
	note $0c $24
	note $12 $09
	wait1 $09
	note $12 $09
	wait1 $09
	note $12 $09
	wait1 $3f
	note $0c $09
	wait1 $1b
	note $12 $09
	wait1 $09
	note $12 $04
	wait1 $05
	note $12 $04
	wait1 $05
	note $12 $04
	wait1 $20
	note $0c $04
	wait1 $05
	note $0c $04
	wait1 $05
	note $0c $04
	wait1 $0e
	note $0c $24
	note $12 $09
	wait1 $09
	note $12 $09
	wait1 $09
	note $12 $09
	wait1 $1b
	note $12 $09
	wait1 $1b
	note $0c $09
	wait1 $1b
	note $12 $09
	wait1 $09
	note $12 $04
	wait1 $05
	note $12 $04
	wait1 $05
	note $16 $12
	note $15 $12
	note $14 $12
	note $13 $12
	note $0c $51
	wait1 $09
	note $12 $09
	note $11 $09
	note $10 $09
	note $0f $09
	note $0e $09
	note $0d $09
	note $0c $09
	wait1 $1b
	note $12 $09
	wait1 $09
	note $12 $04
	wait1 $05
	note $12 $04
	wait1 $05
	note $12 $09
	wait1 $1b
	note $0c $04
	wait1 $05
	note $0c $04
	wait1 $05
	note $0c $04
	wait1 $0e
	note $0c $24
	note $12 $09
	wait1 $09
	note $12 $09
	wait1 $09
	note $12 $09
	wait1 $3f
	note $0c $09
	wait1 $1b
	note $12 $09
	wait1 $09
	note $12 $04
	wait1 $05
	note $12 $04
	wait1 $05
	note $16 $48
	goto musicf819f
	cmdff
; $f824b
; @addr{f824b}
sound39Channel4:
	cmdf2
musicf824c:
	duty $17
	note $1f $48
	note $1e $09
	duty $0c
	note $1e $12
	wait1 $09
	duty $17
	note $24 $12
	note $25 $09
	duty $0c
	note $25 $09
	duty $17
	note $26 $12
	note $25 $09
	duty $0c
	note $25 $12
	wait1 $87
	duty $17
	note $1f $24
	note $1e $09
	duty $0c
	note $1e $12
	wait1 $09
	duty $17
	note $24 $12
	note $25 $09
	duty $0c
	note $26 $09
	duty $17
	note $28 $0c
	note $27 $0c
	note $26 $0c
	note $25 $09
	duty $0c
	note $25 $12
	wait1 $63
	duty $17
	note $2b $09
	note $2a $09
	note $29 $09
	note $28 $09
	note $27 $09
	note $26 $09
	note $25 $09
	duty $0c
	note $25 $12
	wait1 $09
	duty $17
	note $23 $12
	note $21 $09
	duty $0c
	note $21 $09
	duty $17
	note $23 $09
	note $21 $09
	note $1e $09
	duty $17
	note $1e $12
	wait1 $ff
	wait1 $84
	goto musicf824c
	cmdff
; $f82c8
; @addr{f82c8}
sound37Channel1:
	cmdff
; $f82c9
; @addr{f82c9}
sound37Channel0:
	cmdff
; $f82ca
; @addr{f82ca}
sound37Channel6:
	cmdff
; $f82cb
; @addr{f82cb}
sound30Channel1:
	cmdff
; $f82cc
; @addr{f82cc}
sound30Channel0:
	cmdff
; $f82cd
; @addr{f82cd}
sound2fChannel1:
	vibrato $00
	env $0 $00
	cmdf2
	duty $02
musicf82d4:
	vol $c
	note $0c $04
	vol $5
	note $0c $08
	vol $2
	note $0c $04
	vol $c
	note $12 $04
	vol $5
	note $12 $08
	vol $2
	note $12 $04
	vol $c
	note $11 $04
	vol $5
	note $11 $08
	vol $2
	note $11 $04
	wait1 $48
	vol $c
	note $0c $02
	vol $5
	note $0c $04
	vol $2
	note $0c $02
	vol $c
	note $0c $04
	vol $5
	note $0c $08
	vol $2
	note $0c $04
	vol $c
	note $12 $04
	vol $5
	note $12 $08
	vol $2
	note $12 $04
	vol $c
	note $11 $04
	vol $5
	note $11 $04
	vol $c
	note $17 $04
	vol $5
	note $17 $08
	vol $2
	note $17 $04
	wait1 $f8
	goto musicf82d4
	cmdff
; $f8321
; GAP
	cmdff
	cmdff
	cmdff
; @addr{f8324}
sound3cChannel1:
musicf8324:
	vibrato $00
	env $0 $05
	cmdf2
	duty $00
	vol $8
	note $43 $1e
	note $3e $0a
	note $3b $14
	note $37 $14
	note $38 $28
	note $3f $0a
	note $3c $0a
	note $38 $0a
	note $33 $0a
	note $32 $14
	note $3e $0a
	note $3b $0a
	note $37 $14
	note $32 $14
	note $35 $14
	note $33 $0a
	note $35 $0a
	note $32 $28
	vol $3
	vibrato $00
	env $0 $03
	note $31 $05
	wait1 $0f
	note $32 $05
	wait1 $0f
	note $3f $05
	wait1 $0f
	note $3e $05
	wait1 $0f
	note $3d $05
	wait1 $0f
	note $3e $05
	wait1 $0f
	note $3c $05
	wait1 $0f
	note $3d $05
	wait1 $0f
	note $3b $05
	wait1 $0f
	note $3c $05
	wait1 $0f
	note $3a $05
	wait1 $0f
	note $3b $05
	wait1 $0f
	note $39 $05
	wait1 $05
	note $3a $05
	wait1 $05
	note $38 $05
	wait1 $05
	note $39 $05
	wait1 $55
	vol $3
	note $52 $01
	note $3a $01
	cmdf8 $81
	note $31 $03
	cmdf8 $00
	vol $0
	wait1 $05
	vol $3
	note $52 $01
	note $3a $01
	cmdf8 $81
	note $31 $03
	cmdf8 $00
	vol $0
	wait1 $05
	goto musicf8324
	cmdff
; $f83b5
; @addr{f83b5}
sound3cChannel0:
musicf83b5:
	vibrato $00
	env $0 $02
	cmdf2
	duty $02
	vol $6
	note $1f $0a
	vol $3
	note $1f $0a
	vol $6
	note $25 $0a
	vol $3
	note $25 $0a
	vol $6
	note $2e $0a
	vol $3
	note $2e $0a
	vol $6
	note $25 $0a
	vol $3
	note $25 $0a
	vol $6
	note $1a $0a
	vol $3
	note $1a $0a
	vol $6
	note $24 $0a
	vol $3
	note $24 $0a
	vol $6
	note $2d $0a
	vol $3
	note $2d $0a
	vol $6
	note $24 $0a
	vol $3
	note $24 $0a
	vol $6
	note $1f $0a
	vol $3
	note $1f $0a
	vol $6
	note $25 $0a
	vol $3
	note $25 $0a
	vol $6
	note $2e $0a
	vol $3
	note $2e $0a
	vol $6
	note $25 $0a
	vol $3
	note $25 $0a
	vol $6
	note $1a $0a
	vol $3
	note $1a $0a
	vol $6
	note $24 $0a
	vol $3
	note $24 $0a
	vol $6
	note $2d $0a
	vol $3
	note $2d $0a
	vol $6
	note $24 $0a
	vol $3
	note $24 $0a
	vol $3
	wait1 $28
	note $3e $05
	wait1 $0f
	note $3d $05
	wait1 $0f
	env $0 $03
	note $3c $05
	wait1 $0f
	note $3d $05
	wait1 $0f
	note $3b $05
	wait1 $0f
	note $3c $05
	wait1 $0f
	note $3a $05
	wait1 $0f
	note $3b $05
	wait1 $0f
	note $39 $05
	wait1 $0f
	note $3a $05
	wait1 $0f
	note $38 $05
	wait1 $0f
	note $37 $05
	wait1 $73
	goto musicf83b5
	cmdff
; $f8455
; @addr{f8455}
sound3cChannel4:
	cmdf2
musicf8456:
	duty $17
	wait1 $28
	note $2a $05
	wait1 $05
	duty $0c
	note $2a $03
	wait1 $07
	duty $17
	duty $0f
	note $4f $09
	wait1 $01
	note $4f $0a
	duty $17
	wait1 $28
	note $29 $05
	wait1 $05
	duty $0c
	note $29 $03
	wait1 $07
	duty $0f
	note $4f $09
	wait1 $01
	note $4f $0a
	duty $17
	wait1 $28
	note $2a $05
	wait1 $05
	duty $0c
	note $2a $03
	wait1 $07
	duty $0f
	note $4f $09
	wait1 $01
	note $4f $0a
	duty $17
	wait1 $28
	note $29 $05
	wait1 $05
	duty $0c
	note $29 $03
	wait1 $07
	duty $0f
	note $4f $09
	wait1 $01
	note $4f $0a
	wait1 $fa
	wait1 $82
	goto musicf8456
	cmdff
; $f84b8
sound3dStart:
; @addr{f84b8}
sound3dChannel1:
	vol $0
	note $20 $c0
	vibrato $e1
	env $0 $00
	cmdf2
	duty $02
musicf84c2:
	vol $7
	note $26 $08
	note $29 $08
	note $32 $08
	wait1 $04
	vol $3
	note $32 $08
	wait1 $04
	vol $1
	note $32 $08
	vol $7
	note $26 $08
	note $29 $08
	note $32 $08
	wait1 $04
	vol $3
	note $32 $08
	wait1 $04
	vol $1
	note $32 $08
	vol $7
	note $34 $10
	wait1 $04
	vol $3
	note $34 $04
	vol $7
	note $35 $08
	note $34 $08
	note $35 $08
	note $34 $08
	note $30 $08
	note $2d $10
	wait1 $02
	vol $3
	note $2d $08
	wait1 $02
	vol $1
	note $2d $04
	vol $7
	note $2d $10
	note $26 $10
	note $29 $08
	note $2b $08
	note $2d $20
	vol $3
	note $2d $10
	vol $7
	note $2d $10
	note $26 $10
	note $29 $08
	note $2b $08
	note $28 $20
	vol $3
	note $28 $10
	vol $7
	note $26 $08
	note $29 $08
	note $32 $08
	wait1 $04
	vol $3
	note $32 $08
	wait1 $04
	vol $1
	note $32 $08
	vol $7
	note $26 $08
	note $29 $08
	note $32 $08
	wait1 $04
	vol $3
	note $32 $08
	wait1 $04
	vol $1
	note $32 $08
	vol $7
	note $34 $10
	wait1 $04
	vol $3
	note $34 $04
	vol $7
	note $35 $08
	note $34 $08
	note $35 $08
	note $34 $08
	note $30 $08
	note $2d $10
	vol $3
	note $2d $10
	vol $7
	note $2d $10
	note $26 $10
	note $29 $08
	note $2b $08
	note $2d $10
	wait1 $06
	vol $3
	note $2d $08
	wait1 $02
	vol $7
	note $2d $10
	note $26 $50
	wait1 $70
	goto musicf84c2
	cmdff
; $f8576
; @addr{f8576}
sound3dChannel0:
	vol $0
	note $20 $10
	vibrato $00
	env $0 $00
	cmdf2
	duty $02
	vol $6
	note $21 $04
	wait1 $02
	vol $3
	note $21 $04
	wait1 $02
	vol $1
	note $21 $04
	vol $6
	note $21 $04
	wait1 $02
	vol $3
	note $21 $04
	wait1 $02
	vol $1
	note $21 $04
	wait1 $08
	vol $6
	note $1c $08
	note $23 $18
	vol $3
	note $23 $08
	wait1 $10
	vol $6
	note $24 $04
	wait1 $02
	vol $3
	note $24 $04
	wait1 $02
	vol $1
	note $24 $04
	vol $6
	note $24 $04
	wait1 $02
	vol $3
	note $24 $04
	wait1 $02
	vol $1
	note $24 $04
	wait1 $08
	vol $6
	note $1c $08
	note $23 $18
	vol $3
	note $23 $08
musicf85ca:
	wait1 $10
	vol $6
	note $21 $04
	wait1 $02
	vol $3
	note $21 $04
	wait1 $02
	vol $1
	note $21 $04
	vol $6
	note $21 $04
	wait1 $02
	vol $3
	note $21 $04
	wait1 $02
	vol $1
	note $21 $04
	wait1 $10
	vol $6
	note $23 $18
	vol $3
	note $23 $08
	wait1 $10
	vol $6
	note $24 $04
	wait1 $02
	vol $3
	note $24 $04
	wait1 $02
	vol $1
	note $24 $04
	vol $6
	note $24 $04
	wait1 $02
	vol $3
	note $24 $04
	wait1 $02
	vol $1
	note $24 $04
	wait1 $10
	vol $6
	note $23 $18
	vol $3
	note $23 $08
	wait1 $10
	vol $6
	note $21 $04
	wait1 $02
	vol $3
	note $21 $04
	wait1 $02
	vol $1
	note $21 $04
	vol $6
	note $21 $04
	wait1 $02
	vol $3
	note $21 $04
	wait1 $02
	vol $1
	note $21 $04
	wait1 $10
	vol $6
	note $21 $18
	vol $3
	note $21 $08
	wait1 $10
	vol $6
	note $21 $04
	wait1 $02
	vol $3
	note $21 $04
	wait1 $02
	vol $1
	note $21 $04
	vol $6
	note $21 $04
	wait1 $02
	vol $3
	note $21 $04
	wait1 $02
	vol $1
	note $21 $04
	wait1 $10
	vol $6
	note $21 $18
	vol $3
	note $21 $08
	wait1 $10
	vol $6
	note $21 $04
	wait1 $02
	vol $3
	note $21 $04
	wait1 $02
	vol $1
	note $21 $04
	vol $6
	note $21 $04
	wait1 $02
	vol $3
	note $21 $04
	wait1 $02
	vol $1
	note $21 $04
	wait1 $10
	vol $6
	note $23 $18
	vol $3
	note $23 $08
	wait1 $10
	vol $6
	note $24 $04
	wait1 $02
	vol $3
	note $24 $04
	wait1 $02
	vol $1
	note $24 $04
	vol $6
	note $24 $04
	wait1 $02
	vol $3
	note $24 $04
	wait1 $02
	vol $1
	note $24 $04
	wait1 $10
	vol $6
	note $23 $18
	vol $3
	note $23 $08
	wait1 $10
	vol $6
	note $21 $04
	wait1 $02
	vol $3
	note $21 $04
	wait1 $02
	vol $1
	note $21 $04
	vol $6
	note $21 $04
	wait1 $02
	vol $3
	note $21 $04
	wait1 $02
	vol $1
	note $21 $04
	wait1 $10
	vol $6
	note $21 $18
	vol $3
	note $21 $08
	wait1 $10
	vol $6
	note $21 $04
	wait1 $02
	vol $3
	note $21 $04
	wait1 $02
	vol $1
	note $21 $04
	vol $6
	note $21 $04
	wait1 $02
	vol $3
	note $21 $04
	wait1 $02
	vol $1
	note $21 $04
	wait1 $08
	vol $6
	note $1c $08
	note $23 $18
	vol $3
	note $23 $08
	wait1 $10
	vol $6
	note $24 $04
	wait1 $02
	vol $3
	note $24 $04
	wait1 $02
	vol $1
	note $24 $04
	vol $6
	note $24 $04
	wait1 $02
	vol $3
	note $24 $04
	wait1 $02
	vol $1
	note $24 $04
	wait1 $08
	vol $6
	note $1c $08
	note $23 $18
	vol $3
	note $23 $08
	goto musicf85ca
	cmdff
; $f8716
; @addr{f8716}
sound3dChannel4:
	cmdf2
	duty $17
	note $0e $10
	duty $17
	note $1d $04
	wait1 $0c
	duty $17
	note $1d $04
	wait1 $0c
	duty $17
	note $10 $10
	note $1f $20
	note $11 $10
	duty $17
	note $21 $04
	wait1 $0c
	duty $17
	note $21 $04
	wait1 $0c
	duty $17
	note $10 $10
	note $1f $20
musicf8741:
	note $0e $10
	note $1d $04
	wait1 $0c
	note $1d $04
	wait1 $0c
	note $10 $10
	note $1f $20
	note $11 $10
	note $21 $04
	wait1 $0c
	note $21 $04
	wait1 $0c
	note $10 $10
	note $1f $20
	note $16 $10
	note $1d $04
	wait1 $0c
	note $1d $04
	wait1 $0c
	note $11 $10
	note $1d $20
	note $16 $10
	note $1d $04
	wait1 $0c
	note $1d $04
	wait1 $0c
	note $15 $10
	note $1c $20
	note $0e $10
	note $1d $04
	wait1 $0c
	note $1d $04
	wait1 $0c
	note $10 $10
	note $1f $20
	note $11 $10
	note $21 $04
	wait1 $0c
	note $21 $04
	wait1 $0c
	note $10 $10
	note $1f $20
	note $16 $10
	note $1d $04
	wait1 $0c
	note $1d $04
	wait1 $0c
	note $15 $10
	note $1c $20
	note $0e $10
	note $1d $04
	wait1 $0c
	note $1d $04
	wait1 $0c
	note $10 $10
	note $1f $20
	note $11 $10
	note $21 $04
	wait1 $0c
	note $21 $04
	wait1 $0c
	note $10 $10
	note $1f $20
	goto musicf8741
	cmdff
; $f87c3
; @addr{f87c3}
sound3dChannel6:
	wait1 $10
	cmdf2
	cmdf2
	vol $3
	note $2a $10
	note $2a $10
	wait1 $08
	note $2a $08
	note $2a $08
	note $2a $08
	note $2a $08
	wait1 $18
	note $2a $10
	note $2a $10
	wait1 $08
	note $2a $08
	note $2a $08
	note $2a $08
	note $2a $08
	wait1 $07
musicf87e8:
	wait1 $11
	note $2a $10
	note $2a $10
	wait1 $08
	note $2a $08
	note $2a $08
	note $2a $08
	note $2a $08
	wait1 $18
	note $2a $10
	note $2a $10
	wait1 $08
	note $2a $08
	note $2a $08
	note $2a $08
	note $2a $08
	wait1 $18
	note $2a $10
	note $2a $10
	wait1 $08
	note $2a $08
	note $2a $08
	note $2a $08
	note $2a $08
	wait1 $18
	note $2a $10
	note $2a $10
	wait1 $08
	note $2a $08
	note $2a $08
	note $2a $08
	note $2a $08
	wait1 $18
	note $2a $10
	note $2a $10
	wait1 $08
	note $2a $08
	note $2a $08
	note $2a $08
	note $2a $08
	wait1 $18
	note $2a $10
	note $2a $10
	wait1 $08
	note $2a $08
	note $2a $08
	note $2a $08
	note $2a $08
	wait1 $18
	note $2a $10
	note $2a $10
	wait1 $08
	note $2a $08
	note $2a $08
	note $2a $08
	note $2a $08
	wait1 $18
	note $2a $10
	note $2a $10
	wait1 $08
	note $2a $08
	note $2a $08
	note $2a $08
	note $2a $08
	wait1 $18
	note $2a $10
	note $2a $10
	wait1 $08
	note $2a $08
	note $2a $08
	note $2a $08
	note $2a $08
	wait1 $07
	goto musicf87e8
	cmdff
; $f887e
sound3eStart:
; @addr{f887e}
sound3eChannel1:
	vibrato $00
	env $0 $00
	cmdf2
	duty $02
musicf8885:
	vol $0
	note $20 $30
	vol $6
	note $28 $0d
	wait1 $03
	vol $3
	note $28 $02
	wait1 $02
	vol $6
	note $28 $04
	wait1 $04
	vol $3
	note $28 $04
	wait1 $10
	vol $6
	note $26 $08
	wait1 $02
	vol $3
	note $26 $04
	wait1 $02
	vol $6
	note $24 $08
	wait1 $02
	vol $3
	note $24 $04
	wait1 $02
	vol $3
	note $24 $02
	wait1 $ae
	vol $6
	note $28 $05
	wait1 $03
	vol $6
	note $28 $05
	wait1 $03
	vol $6
	note $28 $05
	wait1 $05
	vol $3
	note $28 $04
	wait1 $02
	vol $6
	note $28 $05
	wait1 $05
	vol $3
	note $28 $04
	wait1 $02
	vol $6
	note $26 $05
	wait1 $03
	vol $3
	note $26 $04
	wait1 $04
	vol $6
	note $24 $05
	wait1 $03
	vol $3
	note $24 $04
	wait1 $04
	vol $2
	note $24 $02
	wait1 $5e
	vol $6
	note $22 $08
	wait1 $02
	vol $3
	note $22 $04
	wait1 $02
	vol $6
	note $24 $04
	wait1 $04
	vol $3
	note $24 $04
	wait1 $04
	vol $2
	note $24 $02
	wait1 $2e
	vol $6
	note $28 $0d
	wait1 $03
	note $28 $02
	wait1 $02
	vol $3
	note $28 $04
	wait1 $04
	vol $3
	note $28 $04
	wait1 $10
	vol $6
	note $26 $08
	wait1 $02
	vol $3
	note $26 $04
	wait1 $02
	vol $6
	note $24 $08
	wait1 $02
	vol $3
	note $24 $04
	wait1 $04
	vol $1
	note $24 $02
	wait1 $ac
	vol $6
	note $28 $05
	wait1 $03
	vol $6
	note $28 $05
	wait1 $03
	vol $6
	note $28 $05
	wait1 $05
	vol $3
	note $28 $04
	wait1 $02
	vol $6
	note $28 $05
	wait1 $05
	vol $3
	note $28 $04
	wait1 $02
	vol $6
	note $26 $05
	wait1 $03
	vol $3
	note $26 $04
	wait1 $04
	vol $6
	note $24 $05
	wait1 $03
	vol $3
	note $24 $04
	wait1 $04
	vol $2
	note $24 $02
	wait1 $5e
	vol $6
	note $22 $08
	wait1 $02
	vol $3
	note $22 $04
	wait1 $02
	vol $6
	note $24 $04
	wait1 $04
	vol $3
	note $24 $04
	wait1 $04
	vol $1
	note $24 $02
	wait1 $5e
	vol $6
	note $22 $08
	wait1 $02
	vol $3
	note $22 $02
	wait1 $04
	vol $6
	note $24 $04
	wait1 $04
	vol $3
	note $24 $02
	wait1 $06
	vol $6
	note $22 $08
	wait1 $02
	vol $3
	note $22 $02
	wait1 $04
	vol $6
	note $24 $04
	wait1 $04
	vol $3
	note $24 $02
	wait1 $46
	vol $6
	note $22 $08
	wait1 $02
	vol $3
	note $22 $02
	wait1 $04
	vol $6
	note $24 $04
	wait1 $04
	vol $3
	note $24 $02
	wait1 $06
	vol $1
	note $24 $02
	wait1 $5e
	vol $6
	note $22 $08
	wait1 $02
	vol $3
	note $22 $02
	wait1 $04
	vol $6
	note $24 $04
	wait1 $04
	vol $3
	note $24 $02
	wait1 $06
	vol $6
	note $26 $08
	wait1 $02
	vol $3
	note $26 $02
	wait1 $04
	vol $6
	note $24 $04
	wait1 $04
	vol $3
	note $24 $02
	wait1 $06
	vol $6
	note $22 $08
	wait1 $02
	vol $3
	note $22 $02
	wait1 $04
	vol $6
	note $24 $04
	wait1 $04
	vol $3
	note $24 $02
	wait1 $06
	vol $1
	note $24 $02
	wait1 $ff
	wait1 $ff
	wait1 $10
	vol $6
	note $2b $08
	wait1 $02
	vol $3
	note $2b $02
	wait1 $04
	vol $6
	note $2d $08
	wait1 $02
	vol $3
	note $2d $02
	wait1 $04
	vol $6
	note $2b $08
	wait1 $02
	vol $3
	note $2b $02
	wait1 $04
	vol $6
	note $2d $08
	wait1 $02
	vol $3
	note $2d $02
	wait1 $04
	vol $6
	note $2b $08
	wait1 $02
	vol $3
	note $2b $02
	wait1 $04
	vol $6
	note $2e $0c
	wait1 $01
	vol $3
	note $2e $03
	wait1 $02
	note $2e $02
	wait1 $0c
	vol $6
	note $2e $0a
	wait1 $02
	vol $1
	note $2e $04
	wait1 $02
	vol $3
	note $2e $02
	wait1 $06
	vol $2
	note $2e $02
	wait1 $04
	vol $6
	note $2d $08
	wait1 $02
	vol $3
	note $2d $02
	wait1 $04
	vol $6
	note $2b $08
	wait1 $02
	vol $3
	note $2b $02
	wait1 $34
	vol $6
	note $2b $08
	wait1 $02
	vol $3
	note $2b $02
	wait1 $04
	vol $6
	note $2d $08
	wait1 $02
	vol $3
	note $2d $02
	wait1 $04
	vol $6
	note $2b $08
	wait1 $02
	vol $3
	note $2b $02
	wait1 $04
	vol $6
	note $2d $08
	wait1 $02
	vol $3
	note $2d $02
	wait1 $04
	vol $6
	note $2b $08
	wait1 $02
	vol $3
	note $2b $02
	wait1 $04
	vol $6
	note $2d $08
	wait1 $02
	vol $3
	note $2d $02
	wait1 $04
	vol $6
	note $2b $08
	wait1 $02
	vol $3
	note $2b $02
	wait1 $04
	vol $6
	note $2e $0c
	wait1 $01
	vol $3
	note $2e $03
	wait1 $05
	vol $3
	note $2e $03
	wait1 $02
	vol $3
	note $2e $02
	wait1 $04
	vol $6
	note $2e $10
	wait1 $02
	vol $3
	note $2e $02
	wait1 $06
	note $2e $02
	wait1 $04
	vol $6
	note $2d $08
	wait1 $02
	vol $3
	note $2d $02
	wait1 $04
	vol $6
	note $2b $08
	wait1 $02
	vol $3
	note $2b $02
	vol $0
	wait1 $ff
	vol $0
	wait1 $ff
	wait1 $36
	vol $6
	note $28 $0d
	wait1 $03
	note $28 $02
	wait1 $02
	vol $4
	note $28 $04
	wait1 $04
	vol $3
	note $28 $04
	wait1 $10
	vol $6
	note $26 $08
	wait1 $02
	vol $3
	note $26 $04
	wait1 $02
	vol $6
	note $24 $08
	wait1 $02
	vol $3
	note $24 $04
	wait1 $04
	vol $2
	note $24 $02
	wait1 $ac
	vol $6
	note $28 $05
	wait1 $03
	vol $6
	note $28 $05
	wait1 $03
	vol $6
	note $28 $05
	wait1 $05
	vol $3
	note $28 $04
	wait1 $02
	vol $6
	note $28 $05
	wait1 $05
	vol $3
	note $28 $04
	wait1 $02
	vol $6
	note $26 $05
	wait1 $03
	vol $3
	note $26 $04
	wait1 $04
	vol $6
	note $24 $05
	wait1 $03
	vol $3
	note $24 $04
	wait1 $04
	vol $2
	note $24 $02
	wait1 $4e
	vol $6
	note $2b $08
	wait1 $02
	vol $3
	note $2b $02
	wait1 $04
	vol $6
	note $2d $08
	wait1 $02
	vol $3
	note $2d $02
	wait1 $04
	vol $6
	note $2b $08
	wait1 $02
	vol $3
	note $2b $02
	wait1 $04
	vol $6
	note $2d $08
	wait1 $02
	vol $3
	note $2d $02
	wait1 $04
	vol $6
	note $2b $08
	wait1 $02
	vol $3
	note $2b $02
	wait1 $04
	vol $6
	note $2e $08
	wait1 $02
	vol $3
	note $2e $02
	wait1 $06
	note $2e $02
	wait1 $06
	note $2e $02
	wait1 $04
	vol $6
	note $2e $08
	wait1 $02
	vol $3
	note $2e $02
	wait1 $06
	vol $3
	note $2e $02
	wait1 $06
	vol $2
	note $2e $02
	wait1 $04
	vol $6
	note $2d $08
	wait1 $02
	vol $3
	note $2d $02
	wait1 $04
	vol $6
	note $2b $08
	wait1 $02
	vol $3
	note $2b $02
	wait1 $34
	vol $6
	note $2b $08
	wait1 $02
	vol $3
	note $2b $02
	wait1 $04
	vol $6
	note $2d $08
	wait1 $02
	vol $3
	note $2d $02
	wait1 $04
	vol $6
	note $2b $08
	wait1 $02
	vol $3
	note $2b $02
	wait1 $04
	vol $6
	note $2d $08
	wait1 $02
	vol $3
	note $2d $02
	wait1 $04
	vol $6
	note $2b $08
	wait1 $02
	vol $3
	note $2b $02
	wait1 $04
	vol $6
	note $2d $08
	wait1 $02
	vol $3
	note $2d $02
	wait1 $04
	vol $6
	note $2b $08
	wait1 $02
	vol $3
	note $2b $02
	wait1 $04
	vol $6
	note $2e $08
	wait1 $02
	vol $3
	note $2e $02
	wait1 $06
	vol $3
	note $2e $02
	wait1 $06
	vol $3
	note $2e $02
	wait1 $04
	vol $6
	note $2e $08
	wait1 $02
	vol $5
	note $2e $02
	wait1 $06
	vol $4
	note $2e $02
	wait1 $06
	vol $3
	note $2e $02
	wait1 $04
	vol $6
	note $2d $08
	wait1 $02
	vol $3
	note $2d $02
	wait1 $04
	vol $6
	note $2b $08
	wait1 $02
	vol $3
	note $2b $02
	vol $0
	wait1 $ff
	vol $0
	wait1 $85
	goto musicf8885
	cmdff
; $f8c4a
; @addr{f8c4a}
sound3eChannel0:
	vibrato $00
	env $0 $00
	cmdf2
	duty $02
musicf8c51:
	vol $6
	note $0c $08
	wait1 $08
	note $0c $08
	wait1 $08
	note $1c $10
	note $18 $08
	note $13 $08
	wait1 $10
	note $13 $08
	wait1 $08
	note $18 $08
	wait1 $08
	note $13 $08
	wait1 $08
	note $0c $08
	wait1 $08
	note $0c $08
	wait1 $08
	note $1c $10
	note $18 $08
	note $13 $04
	wait1 $04
	note $13 $08
	wait1 $08
	note $16 $08
	wait1 $08
	note $18 $08
	wait1 $08
	note $13 $08
	wait1 $08
	note $0c $08
	wait1 $08
	note $0c $08
	wait1 $08
	note $1c $10
	note $18 $08
	note $13 $04
	wait1 $04
	note $13 $08
	wait1 $08
	note $16 $08
	wait1 $08
	note $18 $08
	wait1 $08
	note $13 $08
	wait1 $08
	note $0c $08
	wait1 $08
	note $0c $08
	wait1 $08
	note $1c $10
	note $18 $08
	note $13 $04
	wait1 $04
	note $13 $18
	wait1 $08
	note $16 $08
	wait1 $08
	note $18 $08
	wait1 $08
	note $0c $08
	wait1 $08
	note $0c $08
	wait1 $08
	note $1c $10
	note $18 $08
	note $13 $08
	wait1 $10
	note $13 $08
	wait1 $08
	note $18 $08
	wait1 $08
	note $13 $08
	wait1 $08
	note $0c $08
	wait1 $08
	note $0c $08
	wait1 $08
	note $1c $10
	note $18 $08
	note $13 $08
	wait1 $10
	note $13 $08
	note $16 $08
	note $18 $08
	wait1 $08
	note $13 $08
	wait1 $08
	note $0c $08
	wait1 $08
	note $0c $08
	wait1 $08
	note $1c $10
	note $18 $08
	note $13 $04
	wait1 $04
	note $13 $10
	wait1 $10
	note $16 $08
	wait1 $08
	note $18 $08
	wait1 $08
	note $0c $20
	note $1c $08
	wait1 $08
	note $13 $08
	wait1 $18
	note $13 $08
	wait1 $08
	note $16 $08
	wait1 $08
	note $18 $08
	wait1 $08
	note $0c $08
	wait1 $08
	note $0c $08
	wait1 $08
	note $1c $10
	note $13 $08
	wait1 $08
	note $16 $10
	note $18 $08
	wait1 $08
	note $16 $10
	note $18 $08
	wait1 $08
	note $0c $08
	wait1 $08
	note $0c $08
	wait1 $08
	note $1c $10
	note $13 $08
	wait1 $18
	note $13 $08
	wait1 $08
	note $16 $10
	note $18 $08
	wait1 $08
	note $0c $08
	wait1 $08
	note $0c $08
	wait1 $08
	note $1c $10
	note $13 $08
	wait1 $18
	note $13 $08
	wait1 $08
	note $16 $10
	note $18 $08
	wait1 $08
	note $16 $10
	note $18 $08
	wait1 $08
	note $1c $10
	note $18 $08
	wait1 $18
	note $13 $10
	note $16 $10
	note $18 $08
	wait1 $08
	note $0c $08
	wait1 $08
	note $0c $08
	wait1 $08
	note $1c $10
	note $13 $08
	wait1 $18
	note $13 $08
	wait1 $08
	note $18 $08
	wait1 $08
	note $13 $08
	wait1 $08
	note $0c $08
	wait1 $10
	note $0c $08
	note $1c $18
	note $13 $04
	wait1 $04
	note $13 $08
	wait1 $08
	note $13 $08
	note $16 $08
	note $18 $08
	wait1 $08
	note $13 $08
	wait1 $08
	note $0c $08
	wait1 $08
	note $0c $08
	wait1 $08
	note $1c $10
	note $13 $08
	wait1 $18
	note $13 $08
	wait1 $08
	note $18 $08
	wait1 $08
	note $13 $08
	wait1 $08
	note $0c $08
	wait1 $08
	note $0c $08
	wait1 $08
	note $1c $10
	note $18 $08
	note $13 $08
	wait1 $10
	note $13 $08
	wait1 $08
	note $16 $08
	wait1 $08
	note $18 $08
	wait1 $08
	note $0c $08
	wait1 $08
	note $0c $08
	wait1 $08
	note $1c $10
	note $18 $08
	note $13 $08
	wait1 $10
	note $18 $08
	wait1 $08
	note $16 $08
	wait1 $08
	note $18 $08
	wait1 $08
	note $0c $10
	wait1 $08
	note $1b $08
	note $1c $10
	note $18 $08
	note $13 $08
	note $18 $08
	wait1 $08
	note $13 $08
	wait1 $08
	note $16 $08
	wait1 $08
	note $18 $08
	wait1 $08
	note $0c $08
	wait1 $08
	note $0c $08
	wait1 $08
	note $1c $10
	note $18 $08
	note $13 $08
	note $18 $08
	wait1 $08
	note $13 $08
	wait1 $08
	note $16 $08
	wait1 $08
	note $18 $08
	wait1 $08
	note $0c $08
	wait1 $08
	note $0c $08
	wait1 $08
	note $1c $10
	note $18 $08
	note $13 $08
	note $18 $08
	wait1 $08
	note $13 $08
	wait1 $08
	note $16 $08
	wait1 $08
	note $18 $08
	wait1 $08
	note $0c $10
	wait1 $10
	note $1c $10
	note $18 $08
	note $13 $08
	wait1 $10
	note $18 $08
	wait1 $08
	note $16 $08
	wait1 $08
	note $18 $08
	wait1 $08
	note $0c $10
	wait1 $08
	note $1b $08
	note $1c $10
	note $18 $08
	note $13 $08
	note $18 $08
	wait1 $08
	note $13 $08
	wait1 $08
	note $16 $08
	wait1 $08
	note $18 $08
	wait1 $08
	note $0c $08
	wait1 $18
	note $1c $10
	note $18 $08
	note $13 $08
	note $18 $08
	wait1 $08
	note $13 $08
	wait1 $08
	note $16 $08
	wait1 $08
	note $18 $08
	wait1 $08
	note $0c $08
	wait1 $08
	note $0c $08
	wait1 $08
	note $1c $10
	note $18 $08
	note $13 $08
	wait1 $10
	note $13 $08
	wait1 $08
	note $18 $08
	wait1 $08
	note $13 $08
	wait1 $08
	note $0c $08
	wait1 $08
	note $0c $08
	wait1 $08
	note $1c $10
	note $18 $08
	note $13 $04
	wait1 $04
	note $13 $08
	wait1 $08
	note $16 $08
	wait1 $08
	note $18 $08
	wait1 $08
	note $13 $08
	wait1 $08
	note $0c $08
	wait1 $08
	note $0c $08
	wait1 $08
	note $1c $10
	note $18 $08
	note $13 $04
	wait1 $04
	note $13 $08
	wait1 $08
	note $16 $08
	wait1 $08
	note $18 $08
	wait1 $08
	note $13 $08
	wait1 $08
	note $0c $20
	note $1c $08
	wait1 $08
	note $13 $08
	wait1 $18
	note $13 $08
	wait1 $08
	note $16 $08
	wait1 $08
	note $18 $08
	wait1 $08
	note $0c $08
	wait1 $08
	note $0c $08
	wait1 $08
	note $1c $08
	wait1 $08
	note $13 $08
	wait1 $18
	note $13 $08
	wait1 $08
	note $18 $08
	wait1 $08
	note $13 $08
	wait1 $08
	note $0c $08
	wait1 $10
	note $0c $08
	note $1c $18
	note $13 $08
	wait1 $10
	note $13 $08
	note $16 $08
	note $18 $08
	wait1 $08
	note $13 $08
	wait1 $08
	note $0c $08
	wait1 $08
	note $0c $08
	wait1 $08
	note $1c $08
	wait1 $08
	note $13 $08
	wait1 $18
	note $13 $08
	wait1 $08
	note $18 $08
	wait1 $08
	note $13 $08
	wait1 $08
	note $0c $08
	wait1 $08
	note $0c $08
	wait1 $08
	note $1c $10
	note $18 $08
	note $13 $08
	note $18 $08
	wait1 $08
	note $13 $08
	wait1 $08
	note $16 $08
	wait1 $08
	note $18 $08
	wait1 $08
	note $0c $08
	wait1 $08
	note $0c $08
	wait1 $08
	note $1c $10
	note $18 $08
	note $13 $08
	wait1 $10
	note $18 $08
	wait1 $08
	note $16 $08
	wait1 $08
	note $18 $08
	wait1 $08
	note $0c $0a
	wait1 $0e
	note $1b $08
	note $1c $10
	note $18 $08
	note $13 $08
	note $18 $08
	wait1 $08
	note $13 $08
	wait1 $08
	note $16 $08
	wait1 $08
	note $18 $08
	wait1 $08
	goto musicf8c51
	cmdff
; $f8fdc
; @addr{f8fdc}
sound3eChannel4:
	cmdf2
musicf8fdd:
	duty $17
	wait1 $30
	note $1f $0d
	wait1 $23
	note $1d $08
	wait1 $08
	note $1c $08
	wait1 $b8
	note $1f $02
	wait1 $06
	note $1f $02
	wait1 $06
	note $1f $04
	wait1 $0c
	note $1f $04
	wait1 $0c
	note $1d $04
	wait1 $0c
	note $1c $04
	wait1 $6c
	note $1a $08
	wait1 $08
	note $1c $04
	wait1 $3c
	note $1f $0d
	wait1 $23
	note $1d $08
	wait1 $08
	note $1c $08
	wait1 $b8
	note $1f $02
	wait1 $06
	note $1f $02
	wait1 $06
	note $1f $04
	wait1 $0c
	note $1f $04
	wait1 $0c
	note $1d $04
	wait1 $0c
	note $1c $04
	wait1 $6c
	note $1a $08
	wait1 $08
	note $1c $04
	wait1 $6c
	note $1a $08
	wait1 $08
	note $1c $04
	wait1 $0c
	note $1a $08
	wait1 $08
	note $1c $04
	wait1 $4c
	note $1a $08
	wait1 $08
	note $1c $04
	wait1 $6c
	note $1d $06
	wait1 $0a
	note $1d $04
	wait1 $0c
	note $1d $06
	wait1 $0a
	note $1d $04
	wait1 $ff
	wait1 $ff
	wait1 $3e
	duty $17
	note $28 $08
	wait1 $08
	note $29 $08
	wait1 $08
	note $28 $08
	wait1 $08
	note $29 $08
	wait1 $08
	note $28 $08
	wait1 $08
	note $2b $0c
	wait1 $14
	note $2b $0a
	wait1 $16
	note $29 $08
	wait1 $08
	note $28 $08
	wait1 $38
	note $28 $08
	wait1 $08
	note $29 $08
	wait1 $08
	note $28 $08
	wait1 $08
	note $29 $08
	wait1 $08
	note $28 $08
	wait1 $08
	note $29 $08
	wait1 $08
	note $28 $08
	wait1 $08
	note $2b $0c
	wait1 $14
	note $2b $10
	wait1 $10
	note $29 $08
	wait1 $08
	note $28 $08
	wait1 $ff
	wait1 $ff
	wait1 $3a
	duty $17
	note $1f $0d
	wait1 $23
	note $1d $08
	wait1 $08
	note $1c $08
	wait1 $b8
	note $1f $04
	wait1 $04
	note $1f $04
	wait1 $04
	note $1f $08
	wait1 $08
	note $1f $08
	wait1 $08
	note $1d $08
	wait1 $08
	note $1c $08
	wait1 $58
	note $28 $08
	wait1 $08
	note $29 $08
	wait1 $08
	note $28 $08
	wait1 $08
	note $29 $08
	wait1 $08
	note $28 $08
	wait1 $08
	note $2b $08
	wait1 $18
	note $2b $08
	wait1 $18
	note $29 $08
	wait1 $08
	note $28 $08
	wait1 $38
	note $28 $08
	wait1 $08
	note $29 $08
	wait1 $08
	note $28 $08
	wait1 $08
	note $29 $08
	wait1 $08
	note $28 $08
	wait1 $08
	note $29 $08
	wait1 $08
	note $28 $08
	wait1 $08
	note $2b $08
	wait1 $18
	note $2b $08
	wait1 $18
	note $29 $08
	wait1 $08
	note $28 $08
	wait1 $ff
	wait1 $89
	goto musicf8fdd
	cmdff
; $f9137
; @addr{f9137}
sound3eChannel6:
	cmdf2
musicf9138:
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
	goto musicf9138
	cmdff
; $f9223
; GAP
	cmdff
	cmdff
	cmdff
	cmdff
sound2aStart:
; @addr{f9227}
sound2aChannel1:
	vibrato $e1
	env $0 $00
	duty $01
	vol $6
	note $24 $09
	wait1 $04
	vol $3
	note $24 $09
	wait1 $05
	vol $6
	note $22 $09
	note $24 $90
	vibrato $01
	env $0 $00
	vol $4
	note $24 $24
	vol $2
	note $24 $12
	vibrato $e1
	env $0 $00
	vol $6
	note $24 $06
	wait1 $03
	vol $3
	note $24 $06
	wait1 $03
	vol $6
	note $24 $06
	wait1 $03
	vol $3
	note $24 $06
	wait1 $03
	vol $6
	note $24 $06
	wait1 $03
	vol $3
	note $24 $06
	wait1 $03
	vol $6
	note $24 $09
	wait1 $04
	vol $3
	note $24 $09
	wait1 $05
	vol $6
	note $22 $09
	note $24 $90
	vibrato $01
	env $0 $00
	vol $4
	note $24 $24
	vol $2
	note $24 $24
	vibrato $e1
	env $0 $00
	vol $6
	note $29 $06
	note $2b $06
	note $2c $06
	note $2e $06
	note $30 $06
	note $32 $06
	vol $6
	note $33 $09
	wait1 $04
	vol $3
	note $33 $09
	wait1 $05
	vol $6
	note $32 $09
	note $30 $48
	vibrato $01
	env $0 $00
	vol $3
	note $30 $24
	vibrato $e1
	env $0 $00
	vol $6
	note $2b $12
	note $2c $12
	note $2e $12
	note $30 $12
	note $32 $12
	note $33 $12
	note $35 $12
	note $36 $12
	note $37 $20
	vol $3
	note $37 $10
	vol $6
	note $37 $04
	wait1 $04
	note $37 $04
	wait1 $04
	note $37 $1c
	vol $3
	note $37 $0e
	vol $6
	note $37 $03
	wait1 $04
	note $37 $03
	wait1 $04
	note $37 $0e
	note $2b $02
	wait1 $02
	note $2b $03
	wait1 $02
	note $2b $02
	wait1 $03
	note $2d $04
	wait1 $05
	note $2d $05
	wait1 $04
	note $2d $05
	wait1 $05
	note $2f $0e
	vol $3
	note $2f $0e
	vol $6
	note $37 $1c
	vibrato $e1
	env $0 $00
musicf92ff:
	duty $02
	vol $6
	note $30 $07
	wait1 $03
	vol $3
	note $30 $07
	wait1 $04
	vol $1
	note $30 $07
	vol $6
	note $2b $2a
	note $30 $07
	wait1 $03
	vol $3
	note $30 $04
	vol $6
	note $30 $07
	note $32 $07
	note $34 $07
	note $35 $07
	note $37 $38
	vibrato $01
	env $0 $00
	vol $3
	note $37 $0e
	vol $1
	note $37 $0e
	vibrato $e1
	env $0 $00
	vol $6
	note $37 $09
	note $38 $09
	note $3a $0a
	note $3c $38
	vibrato $01
	env $0 $00
	vol $3
	note $3c $0e
	vibrato $e1
	env $0 $00
	vol $6
	note $3c $0e
	note $3a $0e
	note $38 $0e
	note $3a $07
	wait1 $07
	vol $3
	note $3a $07
	vol $6
	note $38 $07
	note $37 $2a
	vibrato $01
	env $0 $00
	vol $3
	note $37 $0e
	vibrato $e1
	env $0 $00
	vol $6
	note $37 $1c
	note $35 $07
	wait1 $07
	vol $3
	note $35 $07
	vol $6
	note $37 $07
	note $38 $31
	vol $3
	note $38 $07
	vol $6
	note $37 $0e
	note $35 $0e
	note $33 $07
	wait1 $07
	vol $3
	note $33 $07
	vol $6
	note $35 $07
	note $37 $38
	note $35 $0e
	note $33 $0e
	note $32 $07
	wait1 $07
	vol $3
	note $32 $07
	vol $6
	note $34 $07
	note $36 $2a
	note $37 $0e
	note $39 $0e
	note $3b $0e
	note $3c $62
	note $3e $07
	note $3c $07
	note $3b $54
	vibrato $01
	env $0 $00
	vol $3
	note $3b $1c
	vibrato $e1
	env $0 $00
	vol $6
	note $30 $07
	wait1 $07
	vol $3
	note $30 $07
	vol $6
	note $2b $03
	wait1 $04
	note $2b $2a
	vol $3
	note $2b $07
	vol $6
	note $30 $03
	wait1 $04
	note $30 $07
	note $32 $07
	note $34 $07
	note $35 $07
	note $37 $31
	vibrato $01
	env $0 $00
	vol $3
	note $37 $0e
	vol $1
	note $37 $07
	vibrato $e1
	env $0 $00
	vol $6
	note $37 $07
	wait1 $03
	vol $3
	note $37 $04
	vol $6
	note $37 $0e
	note $38 $07
	note $3a $07
	note $3c $38
	vibrato $01
	env $0 $00
	vol $3
	note $3c $0e
	vibrato $e1
	env $0 $00
	vol $6
	note $3c $04
	note $3e $05
	note $3c $05
	note $3a $03
	wait1 $07
	vol $3
	note $3a $04
	vol $6
	note $38 $03
	wait1 $07
	vol $3
	note $38 $04
	vol $6
	note $3a $0e
	wait1 $03
	vol $3
	note $3a $04
	vol $6
	note $38 $07
	note $37 $2a
	vibrato $01
	env $0 $00
	vol $3
	note $37 $0e
	vibrato $e1
	env $0 $00
	vol $6
	note $37 $1c
	note $35 $07
	wait1 $07
	vol $3
	note $35 $07
	vol $6
	note $37 $07
	note $38 $1c
	vol $3
	note $38 $0e
	vol $6
	note $38 $04
	note $3a $05
	note $38 $05
	note $37 $07
	wait1 $03
	vol $3
	note $37 $04
	vol $6
	note $35 $07
	wait1 $03
	vol $3
	note $35 $04
	vol $6
	note $33 $07
	wait1 $03
	vol $3
	note $33 $04
	vol $6
	note $33 $07
	note $35 $07
	note $37 $1c
	vol $3
	note $37 $0e
	vol $6
	note $37 $04
	note $38 $05
	note $37 $05
	note $35 $07
	wait1 $03
	vol $3
	note $35 $04
	vol $6
	note $33 $07
	wait1 $03
	vol $3
	note $33 $04
	vol $6
	note $32 $07
	wait1 $03
	vol $3
	note $32 $04
	vol $6
	note $32 $07
	note $34 $07
	note $36 $07
	wait1 $03
	vol $3
	note $36 $04
	vol $6
	note $36 $07
	note $37 $07
	note $39 $07
	wait1 $03
	vol $3
	note $39 $04
	vol $6
	note $39 $07
	note $3b $07
	note $3c $07
	note $3b $07
	note $3c $07
	note $3e $07
	note $3f $54
	vibrato $01
	env $0 $00
	vol $3
	note $3f $0e
	vibrato $e1
	env $0 $00
	vol $6
	note $41 $07
	note $3f $07
	note $3e $46
	vibrato $01
	env $0 $00
	vol $3
	note $3e $1c
	vol $1
	note $3e $0e
	vibrato $e1
	env $0 $00
	vol $6
	note $3c $07
	wait1 $07
	vol $3
	note $3c $07
	vol $6
	note $3e $07
	note $3f $23
	vol $3
	note $3f $07
	vol $6
	note $3c $0e
	note $3e $0e
	note $3f $0e
	note $3e $07
	wait1 $07
	vol $3
	note $3e $07
	vol $6
	note $3a $07
	note $37 $2a
	vol $3
	note $37 $0e
	vol $6
	note $37 $1c
	note $38 $07
	wait1 $07
	vol $3
	note $38 $07
	vol $6
	note $3a $07
	note $3c $23
	vol $3
	note $3c $07
	vol $6
	note $38 $0e
	note $3a $0e
	note $3c $0e
	note $3a $07
	wait1 $07
	vol $3
	note $3a $07
	vol $6
	note $38 $07
	note $37 $2a
	vol $3
	note $37 $0e
	vol $6
	note $37 $07
	wait1 $03
	vol $3
	note $37 $04
	vol $6
	note $38 $07
	note $37 $07
	note $35 $07
	wait1 $07
	vol $3
	note $35 $07
	vol $6
	note $37 $07
	note $38 $23
	vol $3
	note $38 $07
	vol $6
	note $35 $0e
	note $37 $0e
	note $38 $0e
	note $37 $15
	vol $3
	note $37 $07
	vol $6
	note $33 $15
	vol $3
	note $33 $07
	vol $6
	note $3c $1c
	vol $3
	note $3c $07
	vol $6
	note $3c $07
	note $3e $07
	note $3f $07
	note $3e $07
	wait1 $07
	vol $3
	note $3e $07
	vol $6
	note $39 $03
	wait1 $04
	note $39 $2a
	vol $3
	note $39 $0e
	vol $6
	note $3e $0e
	note $3c $0e
	note $3b $07
	wait1 $07
	vol $3
	note $3b $07
	vol $6
	note $37 $07
	note $43 $2a
	note $41 $0e
	note $3f $0e
	note $3e $0e
	note $3f $07
	wait1 $07
	vol $3
	note $3f $07
	vol $6
	note $41 $07
	note $43 $23
	vol $3
	note $43 $07
	vol $6
	note $3f $0e
	note $41 $0e
	note $43 $0e
	note $41 $07
	wait1 $07
	vol $3
	note $41 $07
	vol $6
	note $3f $07
	note $3e $2a
	vol $3
	note $3e $0e
	vol $6
	note $3e $1c
	note $3c $07
	wait1 $07
	vol $3
	note $3c $07
	vol $6
	note $3e $07
	note $3f $23
	vol $3
	note $3f $07
	vol $6
	note $3c $07
	note $3e $07
	note $3f $07
	note $41 $07
	note $43 $07
	note $44 $07
	note $46 $38
	vibrato $01
	env $0 $00
	vol $3
	note $46 $0e
	vol $1
	note $46 $0e
	vibrato $e1
	env $0 $00
	vol $6
	note $3a $1c
	vol $6
	note $38 $07
	wait1 $07
	vol $3
	note $38 $07
	vol $6
	note $3a $07
	note $3c $23
	vol $3
	note $3c $07
	vol $6
	note $38 $0e
	note $3a $0e
	note $3c $0e
	note $37 $0e
	note $36 $07
	note $37 $07
	note $39 $0e
	note $37 $07
	note $39 $07
	note $3b $0e
	note $39 $07
	note $3b $07
	note $3c $0e
	vol $6
	note $3b $07
	note $3c $07
	note $3e $2a
	vol $3
	note $3e $0e
	vol $6
	note $43 $23
	note $41 $07
	note $3f $07
	note $3e $07
	note $3c $38
	vibrato $01
	env $0 $00
	vol $3
	note $3c $1c
	vol $1
	note $3c $0e
	wait1 $0e
	vibrato $e1
	env $0 $00
	goto musicf92ff
	cmdff
; $f9623
; @addr{f9623}
sound2aChannel0:
	vol $0
	note $20 $5a
	vibrato $e1
	env $0 $00
	duty $01
	vol $6
	note $1c $09
	note $1d $09
	note $1f $09
	wait1 $04
	vol $3
	note $1f $05
	vol $6
	note $1f $09
	note $21 $09
	note $22 $12
	note $21 $06
	note $22 $06
	note $21 $06
	note $1f $12
	note $1d $12
	note $1c $12
	note $1a $12
	note $18 $12
	note $1a $12
	note $1c $09
	wait1 $04
	vol $3
	note $1c $09
	wait1 $05
	vol $6
	note $1a $09
	note $1c $90
	vol $4
	note $1c $24
	vol $2
	note $1c $24
	vol $6
	note $20 $06
	note $22 $06
	note $24 $06
	note $26 $06
	note $27 $06
	note $29 $06
	note $2b $09
	wait1 $04
	vol $3
	note $2b $09
	wait1 $05
	vol $6
	note $29 $09
	note $27 $48
	vol $3
	note $27 $12
	vol $6
	note $27 $09
	note $29 $09
	note $27 $12
	note $29 $12
	note $2b $12
	note $2c $12
	note $2e $12
	note $2c $12
	note $2e $12
	note $30 $12
	duty $02
	note $2f $08
	wait1 $04
	vol $3
	note $2f $08
	wait1 $04
	vol $1
	note $2f $08
	vol $6
	note $2b $20
	vol $3
	note $2b $0e
	vol $6
	note $26 $03
	wait1 $04
	note $26 $03
	wait1 $04
	note $2b $0e
	note $26 $03
	wait1 $04
	note $26 $03
	wait1 $04
	note $2b $07
	wait1 $03
	vol $3
	note $2b $04
	vol $6
	note $1a $07
	note $1c $07
	note $1d $07
	note $1f $07
	note $21 $07
	note $22 $07
	note $23 $07
	note $21 $07
	note $23 $07
	note $24 $07
	note $26 $07
	note $28 $07
	note $29 $07
	note $2b $07
musicf96e3:
	wait1 $38
	vibrato $e1
	env $0 $00
	note $24 $07
	wait1 $03
	vol $3
	note $24 $07
	wait1 $04
	vol $1
	note $24 $07
	vol $6
	note $1f $2a
	vibrato $01
	env $0 $00
	vol $3
	note $1f $0e
	vibrato $e1
	env $0 $00
	vol $6
	note $24 $07
	note $26 $07
	note $28 $07
	note $29 $07
	note $2b $2a
	vibrato $01
	env $0 $00
	vol $3
	note $2b $0e
	vibrato $e1
	env $0 $00
	vol $6
	note $2b $25
	note $2c $09
	note $2b $0a
	note $29 $09
	note $2b $09
	note $29 $0a
	note $27 $09
	note $29 $09
	note $27 $0a
	note $26 $07
	wait1 $07
	vol $3
	note $26 $07
	vol $6
	note $24 $07
	note $22 $0e
	note $27 $07
	note $29 $07
	note $2b $0e
	note $27 $0e
	note $22 $0e
	note $1f $0e
	wait1 $2a
	note $20 $07
	note $22 $07
	note $24 $38
	wait1 $2a
	note $27 $07
	note $26 $07
	note $27 $38
	note $21 $38
	note $23 $1c
	note $24 $1c
	note $26 $0a
	wait1 $04
	vibrato $00
	env $0 $02
	note $2b $03
	wait1 $01
	vol $5
	note $2b $04
	wait1 $01
	vol $4
	note $2b $03
	wait1 $02
	vibrato $00
	env $0 $00
	vol $6
	note $2b $0e
	vibrato $00
	env $0 $02
	note $30 $03
	wait1 $01
	vol $5
	note $30 $04
	wait1 $01
	vol $4
	note $30 $03
	wait1 $02
	vibrato $00
	env $0 $00
	vol $6
	note $30 $0e
	vibrato $00
	env $0 $02
	note $32 $03
	wait1 $01
	vol $5
	note $32 $04
	wait1 $01
	vol $4
	note $32 $03
	wait1 $02
	vibrato $00
	env $0 $00
	vol $6
	note $32 $0e
	vibrato $00
	env $0 $02
	note $37 $03
	wait1 $01
	vol $5
	note $37 $04
	wait1 $01
	vol $4
	note $37 $03
	wait1 $02
	vibrato $00
	env $0 $00
	vol $6
	note $37 $0e
	vibrato $00
	env $0 $02
	note $32 $03
	wait1 $01
	vol $5
	note $32 $04
	wait1 $01
	vol $4
	note $32 $03
	wait1 $02
	vibrato $00
	env $0 $00
	vol $6
	note $32 $0e
	vibrato $00
	env $0 $02
	note $30 $03
	wait1 $01
	vol $5
	note $30 $04
	wait1 $01
	vol $4
	note $30 $03
	wait1 $02
	vibrato $00
	env $0 $00
	vol $6
	note $30 $0e
	vibrato $00
	env $0 $02
	note $2b $03
	wait1 $01
	vol $5
	note $2b $04
	wait1 $01
	vol $4
	note $2b $03
	wait1 $02
	vibrato $00
	env $0 $00
	vol $6
	note $2b $0e
	vibrato $00
	env $0 $02
	note $26 $03
	wait1 $01
	vol $5
	note $26 $04
	wait1 $01
	vol $4
	note $26 $03
	wait1 $3a
	vibrato $e1
	env $0 $00
	vol $6
	note $28 $1c
	note $24 $1c
	note $1f $15
	note $24 $03
	wait1 $04
	note $24 $07
	note $26 $07
	note $28 $07
	note $29 $07
	note $2b $2a
	vibrato $01
	env $0 $00
	vol $3
	note $2b $0e
	vibrato $e1
	env $0 $00
	vol $6
	note $2b $2a
	note $2c $07
	note $2b $07
	note $29 $0e
	note $2b $07
	note $29 $07
	note $27 $0e
	note $29 $07
	note $27 $07
	note $26 $07
	wait1 $07
	vol $3
	note $26 $07
	vol $6
	note $24 $07
	note $22 $07
	wait1 $03
	vol $3
	note $22 $04
	vol $6
	note $27 $07
	note $29 $07
	note $2b $0e
	note $27 $0e
	note $22 $0e
	note $1f $0e
	wait1 $2a
	note $20 $07
	note $22 $07
	note $24 $1c
	vol $3
	note $24 $1c
	wait1 $2a
	vol $6
	note $24 $07
	note $26 $07
	note $27 $1c
	vol $3
	note $27 $1c
	wait1 $1c
	vol $6
	note $26 $07
	wait1 $03
	vol $3
	note $26 $04
	vol $6
	note $26 $07
	note $28 $07
	note $2a $07
	wait1 $03
	vol $3
	note $2a $04
	vol $6
	note $2a $07
	note $2c $07
	note $2d $07
	note $2c $07
	note $2d $07
	note $2f $07
	note $1f $07
	note $1e $07
	note $1f $07
	note $21 $07
	note $23 $07
	note $21 $07
	note $23 $07
	note $24 $07
	note $26 $07
	note $25 $07
	note $26 $07
	note $27 $07
	note $29 $07
	note $28 $07
	note $29 $07
	note $2b $07
	vol $6
	note $2c $07
	note $2b $07
	note $2c $07
	note $2e $07
	note $30 $07
	note $2f $07
	note $30 $07
	note $32 $07
	note $33 $07
	note $32 $07
	note $33 $07
	note $35 $07
	note $37 $03
	wait1 $04
	note $37 $07
	note $39 $07
	note $3b $07
	note $33 $07
	wait1 $07
	vol $3
	note $33 $07
	vol $6
	note $35 $07
	note $37 $1c
	vol $3
	note $37 $0e
	vol $6
	note $33 $0e
	note $35 $0e
	note $37 $0e
	note $35 $07
	wait1 $07
	vol $3
	note $35 $07
	vol $6
	note $32 $07
	note $2e $0e
	note $32 $07
	note $33 $07
	note $35 $0e
	note $32 $0e
	vol $6
	note $2e $0e
	note $32 $0e
	note $30 $38
	note $32 $1c
	note $30 $1c
	note $32 $07
	wait1 $07
	vol $3
	note $32 $07
	vol $6
	note $30 $07
	note $2e $0e
	note $32 $07
	note $30 $07
	note $32 $0e
	note $2e $0e
	note $2b $0e
	note $26 $0e
	note $29 $1c
	vol $3
	note $29 $0e
	vol $6
	note $2c $07
	note $2b $07
	note $2c $0e
	note $2b $0e
	note $29 $0e
	note $2b $07
	note $2c $07
	note $2b $07
	note $29 $07
	note $27 $1c
	note $28 $07
	note $27 $07
	note $26 $07
	note $25 $07
	note $24 $07
	wait1 $03
	vol $3
	note $24 $04
	vol $6
	note $24 $07
	note $23 $07
	note $22 $0e
	note $21 $1c
	vol $3
	note $21 $0e
	vibrato $00
	env $0 $02
	vol $6
	note $26 $03
	wait1 $01
	note $26 $04
	wait1 $01
	note $26 $03
	wait1 $02
	vibrato $e1
	env $0 $00
	note $2a $0e
	note $2d $0e
	note $36 $0e
	note $33 $0e
	note $1f $07
	note $20 $07
	note $1f $07
	note $1e $07
	note $1f $07
	note $21 $07
	note $23 $07
	note $24 $07
	note $26 $07
	note $27 $07
	note $26 $07
	note $25 $07
	note $26 $07
	note $27 $07
	note $29 $07
	note $2a $07
	note $2b $23
	wait1 $07
	note $2b $03
	wait1 $04
	note $2b $03
	wait1 $04
	note $2b $2a
	vibrato $01
	env $0 $00
	vol $3
	note $2b $0e
	vibrato $e1
	env $0 $00
	vol $6
	note $2b $1c
	vol $3
	note $2b $0e
	vol $6
	note $2b $07
	note $30 $07
	note $2b $07
	wait1 $03
	vol $3
	note $2b $04
	vol $6
	note $2b $0e
	note $2c $0e
	note $2b $07
	wait1 $03
	vol $3
	note $2b $04
	vol $6
	note $2b $38
	note $29 $1c
	note $30 $1c
	note $2e $1c
	vol $3
	note $2e $0e
	vol $6
	note $2e $07
	note $30 $07
	note $31 $07
	note $30 $07
	note $2e $07
	note $2c $07
	note $2b $07
	note $29 $07
	note $28 $07
	note $2b $07
	note $29 $07
	wait1 $07
	vol $3
	note $29 $07
	vol $6
	note $2b $07
	note $2c $0e
	note $29 $07
	note $2b $07
	note $2c $07
	wait1 $03
	vol $3
	note $2c $04
	vol $6
	note $29 $0e
	note $2b $0e
	note $2c $0e
	note $2b $0e
	note $2a $07
	note $29 $07
	note $28 $0e
	note $27 $07
	note $26 $07
	note $25 $0e
	note $24 $07
	note $23 $07
	note $22 $0e
	note $21 $07
	note $20 $07
	note $1d $18
	wait1 $04
	note $1d $09
	note $1f $09
	note $20 $0a
	note $1f $0e
	vol $3
	note $1f $0e
	vol $6
	note $1f $09
	note $21 $09
	note $23 $0a
	note $24 $0e
	vol $3
	note $24 $0e
	vol $6
	note $1f $0a
	wait1 $04
	note $1f $03
	wait1 $04
	note $1f $03
	wait1 $04
	note $24 $1c
	vibrato $01
	env $0 $00
	vol $3
	note $24 $0e
	wait1 $0e
	vibrato $e1
	env $0 $00
	goto musicf96e3
	cmdff
; $f9a79
; @addr{f9a79}
sound2aChannel4:
	wait1 $09
	duty $0f
	note $24 $04
	wait1 $17
	note $22 $09
	note $24 $b4
	wait1 $12
	note $24 $04
	wait1 $0e
	note $24 $04
	wait1 $0e
	note $24 $04
	wait1 $05
	duty $06
	note $16 $51
	wait1 $09
	note $16 $09
	note $15 $09
	note $16 $12
	note $15 $09
	note $13 $09
	note $15 $12
	note $13 $09
	note $11 $09
	note $13 $12
	note $11 $09
	note $10 $09
	note $0e $09
	note $10 $09
	note $11 $09
	note $13 $09
	note $11 $09
	note $13 $09
	note $14 $09
	note $16 $09
	note $14 $2d
	note $18 $09
	note $1b $09
	note $1f $09
	note $20 $09
	note $1f $09
	note $20 $09
	note $22 $09
	note $24 $09
	note $22 $09
	note $24 $09
	note $26 $09
	note $27 $09
	note $26 $09
	note $24 $09
	note $22 $09
	note $20 $09
	note $1f $09
	note $1d $09
	note $1b $09
	note $1a $09
	note $18 $09
	note $16 $09
	note $14 $09
	note $13 $09
	note $11 $09
	note $0f $09
	note $0e $09
	note $13 $10
	duty $0f
	note $13 $08
	wait1 $08
	duty $06
	note $13 $10
	duty $0f
	note $13 $08
	wait1 $08
	duty $06
	note $15 $0e
	duty $0f
	note $15 $07
	wait1 $07
	duty $06
	note $15 $0e
	duty $0f
	note $15 $07
	wait1 $07
	duty $06
	note $16 $0e
	duty $0f
	note $16 $07
	wait1 $07
	duty $06
	note $16 $0e
	duty $0f
	note $16 $07
	wait1 $07
	duty $06
	note $17 $0e
	duty $0f
	note $17 $07
	wait1 $07
	duty $06
	note $13 $15
	duty $0f
	note $13 $07
musicf9b43:
	duty $04
	note $18 $07
	duty $0f
	note $18 $07
	wait1 $0e
	duty $04
	note $18 $07
	duty $0f
	note $18 $07
	wait1 $0e
	duty $04
	note $18 $07
	duty $0f
	note $18 $07
	wait1 $0e
	duty $04
	note $18 $07
	duty $0f
	note $18 $07
	wait1 $0e
	duty $04
	note $16 $07
	duty $0f
	note $16 $07
	wait1 $0e
	duty $04
	note $16 $07
	duty $0f
	note $16 $07
	wait1 $0e
	duty $04
	note $16 $07
	duty $0f
	note $16 $07
	wait1 $0e
	duty $04
	note $16 $07
	duty $0f
	note $16 $07
	wait1 $0e
	duty $04
	note $14 $07
	duty $0f
	note $14 $07
	wait1 $0e
	duty $04
	note $14 $07
	duty $0f
	note $14 $07
	wait1 $0e
	duty $04
	note $16 $07
	duty $0f
	note $16 $07
	wait1 $0e
	duty $04
	note $16 $07
	duty $0f
	note $16 $07
	wait1 $0e
	duty $04
	note $0f $07
	duty $0f
	note $0f $07
	wait1 $0e
	duty $04
	note $0f $07
	duty $0f
	note $0f $07
	wait1 $0e
	duty $04
	note $0f $07
	duty $0f
	note $0f $07
	wait1 $0e
	duty $04
	note $0f $07
	duty $0f
	note $0f $07
	wait1 $0e
	duty $04
	note $19 $07
	duty $0f
	note $19 $07
	wait1 $0e
	duty $04
	note $19 $07
	duty $0f
	note $19 $07
	wait1 $0e
	duty $04
	note $19 $07
	duty $0f
	note $19 $07
	wait1 $0e
	duty $04
	note $19 $07
	duty $0f
	note $19 $07
	wait1 $0e
	duty $04
	note $18 $07
	duty $0f
	note $18 $07
	wait1 $0e
	duty $04
	note $18 $07
	duty $0f
	note $18 $07
	wait1 $0e
	duty $04
	note $18 $07
	duty $0f
	note $18 $07
	wait1 $0e
	duty $04
	note $18 $07
	duty $0f
	note $18 $07
	wait1 $0e
	duty $04
	note $1a $07
	duty $0f
	note $1a $07
	wait1 $0e
	duty $04
	note $1a $07
	duty $0f
	note $1a $07
	wait1 $0e
	duty $04
	note $1a $07
	duty $0f
	note $1a $07
	wait1 $0e
	duty $04
	note $1a $07
	duty $0f
	note $1a $07
	wait1 $0e
	duty $04
	note $13 $1c
	duty $0f
	note $13 $07
	wait1 $07
	duty $04
	note $13 $03
	duty $0f
	note $13 $04
	duty $04
	note $13 $03
	duty $0f
	note $13 $04
	duty $04
	note $13 $03
	duty $0f
	note $13 $04
	wait1 $07
	duty $04
	note $13 $0e
	duty $0f
	note $13 $07
	wait1 $07
	duty $04
	note $13 $03
	duty $0f
	note $13 $04
	wait1 $07
	duty $04
	note $13 $11
	duty $0f
	note $13 $07
	wait1 $04
	duty $04
	note $13 $11
	duty $0f
	note $13 $07
	wait1 $04
	duty $04
	note $15 $11
	duty $0f
	note $15 $07
	wait1 $04
	duty $04
	note $17 $11
	duty $0f
	note $17 $07
	wait1 $04
	duty $04
	note $18 $07
	duty $0f
	note $18 $07
	wait1 $0e
	duty $04
	note $13 $07
	duty $0f
	note $13 $07
	wait1 $0e
	duty $04
	note $18 $07
	duty $0f
	note $18 $07
	wait1 $0e
	duty $04
	note $13 $07
	duty $0f
	note $13 $07
	wait1 $0e
	duty $04
	note $16 $07
	duty $0f
	note $16 $07
	wait1 $0e
	duty $04
	note $11 $07
	duty $0f
	note $11 $07
	wait1 $0e
	duty $04
	note $16 $07
	duty $0f
	note $16 $07
	wait1 $0e
	duty $04
	note $11 $07
	duty $0f
	note $11 $07
	wait1 $0e
	duty $04
	note $14 $07
	duty $0f
	note $14 $07
	wait1 $0e
	duty $04
	note $14 $18
	duty $0f
	note $14 $04
	duty $04
	note $16 $07
	wait1 $15
	note $16 $18
	duty $0f
	note $16 $04
	duty $04
	note $1b $07
	duty $0f
	note $1b $07
	wait1 $0e
	duty $04
	note $16 $07
	duty $0f
	note $16 $07
	wait1 $0e
	duty $04
	note $1b $07
	duty $0f
	note $1b $07
	wait1 $0e
	duty $04
	note $1b $1c
	note $19 $07
	duty $0f
	note $19 $07
	wait1 $0e
	duty $04
	note $14 $07
	duty $0f
	note $14 $07
	wait1 $0e
	duty $04
	note $19 $07
	duty $0f
	note $19 $07
	wait1 $0e
	duty $04
	note $19 $1c
	note $18 $07
	duty $0f
	note $18 $07
	wait1 $0e
	duty $04
	note $18 $07
	duty $0f
	note $18 $07
	wait1 $0e
	duty $04
	note $18 $07
	duty $0f
	note $18 $07
	wait1 $0e
	duty $04
	note $18 $18
	duty $0f
	note $18 $04
	duty $04
	note $1a $07
	duty $0f
	note $1a $07
	wait1 $0e
	duty $04
	note $15 $07
	duty $0f
	note $15 $07
	wait1 $0e
	duty $04
	note $1a $07
	duty $0f
	note $1a $07
	wait1 $0e
	duty $04
	note $15 $03
	duty $0f
	note $15 $04
	wait1 $07
	duty $04
	note $15 $07
	note $14 $07
	note $13 $1c
	duty $0f
	note $13 $07
	wait1 $07
	duty $04
	note $13 $03
	duty $0f
	note $13 $04
	duty $04
	note $13 $03
	duty $0f
	note $13 $04
	duty $04
	note $13 $03
	duty $0f
	note $13 $04
	wait1 $07
	duty $04
	note $13 $11
	duty $0f
	note $13 $04
	wait1 $07
	duty $04
	note $13 $03
	duty $0f
	note $13 $04
	wait1 $07
	duty $04
	note $13 $1c
	note $15 $1c
	note $16 $1c
	note $17 $1c
	note $18 $1c
	duty $0f
	note $18 $07
	wait1 $07
	duty $04
	note $18 $03
	duty $0f
	note $18 $04
	duty $04
	note $18 $03
	duty $0f
	note $18 $04
	duty $04
	note $18 $03
	duty $0f
	note $18 $04
	wait1 $07
	duty $04
	note $18 $11
	duty $0f
	note $18 $07
	wait1 $04
	duty $04
	note $18 $07
	duty $0f
	note $18 $07
	duty $04
	note $13 $1c
	duty $0f
	note $13 $07
	wait1 $07
	duty $04
	note $13 $03
	duty $0f
	note $13 $04
	duty $04
	note $13 $03
	duty $0f
	note $13 $04
	duty $04
	note $13 $03
	duty $0f
	note $13 $04
	wait1 $07
	duty $04
	note $13 $11
	duty $0f
	note $13 $07
	wait1 $04
	duty $04
	note $13 $07
	duty $0f
	note $13 $07
	duty $04
	note $14 $1c
	duty $0f
	note $14 $07
	wait1 $07
	duty $04
	note $14 $03
	duty $0f
	note $14 $04
	duty $04
	note $14 $03
	duty $0f
	note $14 $04
	duty $04
	note $16 $03
	duty $0f
	note $16 $04
	wait1 $07
	duty $04
	note $16 $11
	duty $0f
	note $16 $07
	wait1 $04
	duty $04
	note $16 $07
	duty $0f
	note $16 $07
	duty $04
	note $0f $07
	duty $0f
	note $0f $07
	wait1 $0e
	duty $04
	note $0f $07
	duty $0f
	note $0f $07
	wait1 $0e
	duty $04
	note $0f $07
	duty $0f
	note $0f $07
	wait1 $0e
	duty $04
	note $0f $1c
	note $19 $07
	duty $0f
	note $19 $07
	wait1 $0e
	duty $04
	note $19 $07
	duty $0f
	note $19 $07
	wait1 $0e
	duty $04
	note $19 $07
	duty $0f
	note $19 $07
	wait1 $0e
	duty $04
	note $19 $07
	duty $0f
	note $19 $07
	wait1 $0e
	duty $04
	note $18 $07
	duty $0f
	note $18 $07
	wait1 $0e
	duty $04
	note $18 $07
	duty $0f
	note $18 $07
	wait1 $0e
	duty $04
	note $18 $07
	duty $0f
	note $18 $07
	wait1 $0e
	duty $04
	note $18 $1c
	note $1a $07
	duty $0f
	note $1a $07
	wait1 $0e
	duty $04
	note $1a $07
	duty $0f
	note $1a $07
	wait1 $0e
	duty $04
	note $1a $07
	duty $0f
	note $1a $07
	wait1 $0e
	duty $04
	note $1a $07
	duty $0f
	note $1a $07
	wait1 $0e
	duty $04
	note $13 $18
	duty $0f
	note $13 $04
	duty $04
	note $15 $18
	duty $0f
	note $15 $04
	duty $04
	note $16 $18
	duty $0f
	note $16 $04
	duty $04
	note $17 $18
	duty $0f
	note $17 $04
	duty $04
	note $18 $1f
	duty $0f
	note $18 $07
	wait1 $04
	duty $04
	note $18 $03
	duty $0f
	note $18 $04
	duty $04
	note $18 $03
	duty $0f
	note $18 $04
	duty $04
	note $18 $03
	duty $0f
	note $18 $04
	wait1 $07
	duty $04
	note $18 $15
	duty $0f
	note $18 $07
	duty $04
	note $18 $07
	duty $0f
	note $18 $07
	duty $04
	note $16 $1f
	duty $0f
	note $16 $07
	wait1 $04
	duty $04
	note $16 $03
	duty $0f
	note $16 $04
	duty $04
	note $16 $03
	duty $0f
	note $16 $04
	duty $04
	note $16 $03
	duty $0f
	note $16 $04
	wait1 $07
	duty $04
	note $16 $15
	duty $0f
	note $16 $07
	duty $04
	note $16 $07
	duty $0f
	note $16 $07
	duty $04
	note $14 $1f
	duty $0f
	note $14 $07
	wait1 $04
	duty $04
	note $14 $03
	duty $0f
	note $14 $04
	duty $04
	note $14 $03
	duty $0f
	note $14 $04
	duty $04
	note $16 $07
	duty $0f
	note $16 $07
	duty $04
	note $16 $11
	duty $0f
	note $16 $07
	wait1 $04
	duty $04
	note $16 $07
	duty $0f
	note $16 $07
	duty $04
	note $13 $1f
	duty $0f
	note $13 $07
	wait1 $04
	duty $04
	note $13 $03
	duty $0f
	note $13 $04
	duty $04
	note $13 $03
	duty $0f
	note $13 $04
	duty $04
	note $19 $03
	duty $0f
	note $19 $04
	wait1 $07
	duty $04
	note $19 $11
	duty $0f
	note $19 $07
	wait1 $04
	duty $04
	note $19 $07
	duty $0f
	note $19 $07
	duty $04
	note $11 $07
	duty $0f
	note $11 $07
	wait1 $0e
	duty $04
	note $11 $07
	duty $0f
	note $11 $07
	wait1 $0e
	duty $04
	note $11 $07
	duty $0f
	note $11 $07
	wait1 $0e
	duty $04
	note $11 $15
	duty $0f
	note $11 $07
	duty $04
	note $18 $1c
	note $17 $1c
	note $16 $1c
	note $15 $1c
	note $14 $15
	duty $0f
	note $14 $07
	duty $04
	note $14 $15
	duty $0f
	note $14 $07
	duty $04
	note $13 $18
	duty $0f
	note $13 $04
	duty $04
	note $13 $18
	duty $0f
	note $13 $04
	duty $04
	note $18 $0a
	duty $0f
	note $18 $07
	wait1 $0b
	duty $04
	note $13 $0a
	duty $0f
	note $13 $07
	wait1 $0b
	duty $04
	note $18 $1c
	duty $0f
	note $18 $07
	wait1 $15
	goto musicf9b43
	cmdff
; $fa08f
; @addr{fa08f}
sound2aChannel6:
	wait1 $ff
	wait1 $ff
	wait1 $ff
	wait1 $db
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
musicfa0d2:
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
	goto musicfa0d2
	cmdff
; $fa409
sound2eStart:
; @addr{fa409}
sound2eChannel1:
	vibrato $00
	env $0 $00
	cmdf2
	duty $02
musicfa410:
	vol $6
	note $2f $0c
	note $28 $06
	note $2f $0c
	note $28 $06
	note $2f $24
	vol $3
	note $2f $18
	vol $6
	note $2e $0c
	note $2a $06
	note $2e $0c
	note $2a $06
	note $2e $24
	vol $3
	note $2e $18
	vol $6
	note $2f $0c
	note $28 $06
	note $2f $0c
	note $28 $06
	note $2f $24
	vol $3
	note $2f $18
	vol $6
	note $2e $06
	note $2f $06
	wait1 $03
	vol $3
	note $2f $03
	vol $6
	note $30 $06
	note $31 $06
	wait1 $03
	vol $3
	note $31 $03
	vol $6
	note $32 $06
	note $33 $06
	wait1 $03
	vol $3
	note $33 $03
	vol $6
	note $34 $06
	note $35 $06
	wait1 $03
	vol $3
	note $35 $03
	vol $6
	note $36 $06
	note $37 $06
	note $38 $06
	note $39 $06
	note $2f $0c
	note $28 $06
	note $2f $0c
	note $28 $06
	note $2f $24
	vol $3
	note $2f $18
	vol $6
	note $2e $0c
	note $2a $06
	note $2e $0c
	note $2a $06
	note $2e $24
	vol $3
	note $2e $18
	vol $6
	note $2f $0c
	note $28 $06
	note $2f $0c
	note $28 $06
	note $2f $24
	vol $3
	note $2f $18
	vol $6
	note $2d $06
	note $2e $06
	wait1 $03
	vol $3
	note $2e $03
	vol $6
	note $2f $06
	note $30 $06
	vol $6
	note $31 $06
	note $32 $06
	note $33 $06
	note $34 $1e
	vol $3
	note $34 $0c
	wait1 $06
	vol $6
	note $30 $12
	note $2b $12
	note $30 $0c
	note $2f $12
	note $2a $06
	wait1 $03
	vol $3
	note $2a $06
	wait1 $03
	vol $1
	note $2a $06
	wait1 $06
	vol $6
	note $30 $12
	vol $6
	note $2b $12
	note $30 $0c
	note $31 $12
	note $38 $06
	wait1 $03
	vol $3
	note $38 $06
	wait1 $03
	vol $1
	note $38 $06
	wait1 $06
	vol $6
	note $30 $12
	note $2b $12
	note $30 $0c
	note $2f $18
	note $33 $18
	note $32 $06
	note $31 $06
	wait1 $03
	vol $3
	note $31 $03
	vol $6
	note $30 $06
	note $2f $06
	wait1 $03
	vol $3
	note $2f $03
	vol $6
	note $2e $06
	note $2d $06
	wait1 $03
	vol $3
	note $2d $03
	vol $6
	note $2c $06
	note $2b $06
	wait1 $03
	vol $3
	note $2b $03
	vol $6
	note $2b $06
	note $2a $06
	note $29 $06
	note $28 $06
	note $27 $48
	vol $3
	note $27 $18
	wait1 $60
	goto musicfa410
	cmdff
; $fa526
; @addr{fa526}
sound2eChannel0:
	vibrato $00
	env $0 $00
	cmdf2
	duty $02
musicfa52d:
	vol $6
	note $2b $0c
	note $23 $06
	note $2b $0c
	note $23 $06
	note $2b $18
	note $23 $0c
	note $28 $0c
	note $2b $0c
	note $2a $0c
	note $22 $06
	note $2a $0c
	note $22 $06
	note $2a $18
	note $2e $0c
	note $2d $0c
	note $2c $0c
	note $2b $0c
	note $23 $06
	note $2b $0c
	note $23 $06
	note $2b $24
	vol $3
	note $2b $18
	vol $6
	note $26 $06
	note $25 $06
	wait1 $03
	vol $3
	note $25 $03
	vol $6
	note $24 $06
	note $23 $06
	wait1 $03
	vol $3
	note $23 $03
	vol $6
	note $22 $06
	note $21 $06
	wait1 $03
	vol $3
	note $21 $03
	vol $6
	note $20 $06
	note $1f $06
	wait1 $03
	vol $3
	note $1f $03
	vol $6
	note $1e $06
	note $1d $06
	note $1c $06
	note $1a $06
	note $2b $0c
	note $23 $06
	note $2b $0c
	note $23 $06
	note $2b $18
	note $23 $0c
	note $28 $0c
	note $2b $0c
	note $2a $0c
	note $22 $06
	note $2a $0c
	note $22 $06
	note $2a $18
	note $2e $0c
	note $2d $0c
	note $2c $0c
	note $2b $0c
	note $23 $06
	note $2b $0c
	note $23 $06
	note $2b $18
	note $23 $0c
	note $28 $0c
	note $2b $0c
	wait1 $60
	note $2b $12
	note $28 $12
	note $2b $0c
	note $2a $12
	note $27 $06
	wait1 $03
	vol $3
	note $27 $06
	wait1 $03
	vol $1
	note $27 $06
	wait1 $06
	vol $6
	note $2b $12
	note $28 $12
	note $2b $0c
	note $2a $12
	note $2f $06
	wait1 $03
	vol $3
	note $2f $06
	wait1 $03
	vol $1
	note $2f $06
	wait1 $06
	vol $6
	note $2b $12
	note $28 $12
	note $24 $0c
	note $23 $0c
	note $27 $0c
	note $2a $0c
	note $2f $0c
	wait1 $60
	note $27 $06
	note $26 $06
	wait1 $03
	vol $3
	note $26 $03
	vol $6
	note $25 $06
	note $24 $06
	wait1 $03
	vol $3
	note $24 $03
	vol $6
	note $23 $06
	note $22 $06
	wait1 $03
	vol $3
	note $22 $03
	vol $6
	note $21 $06
	note $20 $06
	wait1 $03
	vol $3
	note $20 $03
	vol $6
	note $1f $06
	note $1e $06
	note $1d $06
	note $1c $06
	wait1 $60
	goto musicfa52d
	cmdff
; $fa632
; @addr{fa632}
sound2eChannel4:
	cmdf2
musicfa633:
	duty $12
	note $10 $04
	duty $17
	note $10 $02
	duty $12
	note $17 $04
	duty $17
	note $17 $02
	duty $12
	note $1c $04
	duty $17
	note $1c $02
	duty $12
	note $17 $04
	duty $17
	note $17 $02
	duty $12
	note $10 $04
	duty $17
	note $10 $02
	duty $12
	note $17 $04
	duty $17
	note $17 $02
	duty $12
	note $1c $04
	duty $17
	note $1c $02
	duty $12
	note $17 $04
	duty $17
	note $17 $02
	duty $12
	note $10 $04
	duty $17
	note $10 $02
	duty $12
	note $17 $04
	duty $17
	note $17 $02
	duty $12
	note $1c $04
	duty $17
	note $1c $02
	duty $12
	note $17 $04
	duty $17
	note $17 $02
	duty $12
	note $10 $04
	duty $17
	note $10 $02
	duty $12
	note $17 $04
	duty $17
	note $17 $02
	duty $12
	note $1c $04
	duty $17
	note $1c $02
	duty $12
	note $17 $04
	duty $17
	note $17 $02
	duty $12
	note $0f $04
	duty $17
	note $0f $02
	duty $12
	note $16 $04
	duty $17
	note $16 $02
	duty $12
	note $1b $04
	duty $17
	note $1b $02
	duty $12
	note $16 $04
	duty $17
	note $16 $02
	duty $12
	note $0f $04
	duty $17
	note $0f $02
	duty $12
	note $16 $04
	duty $17
	note $16 $02
	duty $12
	note $1b $04
	duty $17
	note $1b $02
	duty $12
	note $16 $04
	duty $17
	note $16 $02
	duty $12
	note $0f $04
	duty $17
	note $0f $02
	duty $12
	note $16 $04
	duty $17
	note $16 $02
	duty $12
	note $1b $04
	duty $17
	note $1b $02
	duty $12
	note $16 $04
	duty $17
	note $16 $02
	duty $12
	note $0f $04
	duty $17
	note $0f $02
	duty $12
	note $16 $04
	duty $17
	note $16 $02
	duty $12
	note $1b $04
	duty $17
	note $1b $02
	duty $12
	note $16 $04
	duty $17
	note $16 $02
	duty $12
	note $10 $04
	duty $17
	note $10 $02
	duty $12
	note $17 $04
	duty $17
	note $17 $02
	duty $12
	note $1c $04
	duty $17
	note $1c $02
	duty $12
	note $17 $04
	duty $17
	note $17 $02
	duty $12
	note $10 $04
	duty $17
	note $10 $02
	duty $12
	note $17 $04
	duty $17
	note $17 $02
	duty $12
	note $1c $04
	duty $17
	note $1c $02
	duty $12
	note $17 $04
	duty $17
	note $17 $02
	duty $12
	note $10 $04
	duty $17
	note $10 $02
	duty $12
	note $17 $04
	duty $17
	note $17 $02
	duty $12
	note $1c $04
	duty $17
	note $1c $02
	duty $12
	note $17 $04
	duty $17
	note $17 $02
	duty $12
	note $10 $04
	duty $17
	note $10 $02
	duty $12
	note $17 $04
	duty $17
	note $17 $02
	duty $12
	note $1c $04
	duty $17
	note $1c $02
	duty $12
	note $17 $04
	duty $17
	note $17 $02
	duty $12
	note $23 $04
	duty $17
	note $23 $02
	duty $12
	note $22 $04
	duty $17
	note $22 $08
	duty $12
	note $21 $04
	duty $17
	note $21 $02
	duty $12
	note $20 $04
	duty $17
	note $20 $08
	duty $12
	note $1f $04
	duty $17
	note $1f $02
	duty $12
	note $1e $04
	duty $17
	note $1e $08
	duty $12
	note $1d $04
	duty $17
	note $1d $02
	duty $12
	note $1c $04
	duty $17
	note $1c $08
	duty $12
	note $1b $04
	duty $17
	note $1b $02
	duty $12
	note $1a $04
	duty $17
	note $1a $02
	duty $12
	note $19 $04
	duty $17
	note $19 $02
	duty $12
	note $18 $04
	duty $17
	note $18 $02
	duty $12
	note $10 $04
	duty $17
	note $10 $02
	duty $12
	note $17 $04
	duty $17
	note $17 $02
	duty $12
	note $1c $04
	duty $17
	note $1c $02
	duty $12
	note $17 $04
	duty $17
	note $17 $02
	duty $12
	note $10 $04
	duty $17
	note $10 $02
	duty $12
	note $17 $04
	duty $17
	note $17 $02
	duty $12
	note $1c $04
	duty $17
	note $1c $02
	duty $12
	note $17 $04
	duty $17
	note $17 $02
	duty $12
	note $10 $04
	duty $17
	note $10 $02
	duty $12
	note $17 $04
	duty $17
	note $17 $02
	duty $12
	note $1c $04
	duty $17
	note $1c $02
	duty $12
	note $17 $04
	duty $17
	note $17 $02
	duty $12
	note $10 $04
	duty $17
	note $10 $02
	duty $12
	note $17 $04
	duty $17
	note $17 $02
	duty $12
	note $1c $04
	duty $17
	note $1c $02
	duty $12
	note $17 $04
	duty $17
	note $17 $02
	duty $12
	note $0f $04
	duty $17
	note $0f $02
	duty $12
	note $16 $04
	duty $17
	note $16 $02
	duty $12
	note $1b $04
	duty $17
	note $1b $02
	duty $12
	note $16 $04
	duty $17
	note $16 $02
	duty $12
	note $0f $04
	duty $17
	note $0f $02
	duty $12
	note $16 $04
	duty $17
	note $16 $02
	duty $12
	note $1b $04
	duty $17
	note $1b $02
	duty $12
	note $16 $04
	duty $17
	note $16 $02
	duty $12
	note $0f $04
	duty $17
	note $0f $02
	duty $12
	note $16 $04
	duty $17
	note $16 $02
	duty $12
	note $1b $04
	duty $17
	note $1b $02
	duty $12
	note $16 $04
	duty $17
	note $16 $02
	duty $12
	note $0f $04
	duty $17
	note $0f $02
	duty $12
	note $16 $04
	duty $17
	note $16 $02
	duty $12
	note $1b $04
	duty $17
	note $1b $02
	duty $12
	note $16 $04
	duty $17
	note $16 $02
	duty $12
	note $10 $04
	duty $17
	note $10 $02
	duty $12
	note $17 $04
	duty $17
	note $17 $02
	duty $12
	note $1c $04
	duty $17
	note $1c $02
	duty $12
	note $17 $04
	duty $17
	note $17 $02
	duty $12
	note $10 $04
	duty $17
	note $10 $02
	duty $12
	note $17 $04
	duty $17
	note $17 $02
	duty $12
	note $1c $04
	duty $17
	note $1c $02
	duty $12
	note $17 $04
	duty $17
	note $17 $02
	duty $12
	note $10 $04
	duty $17
	note $10 $02
	duty $12
	note $17 $04
	duty $17
	note $17 $02
	duty $12
	note $1c $04
	duty $17
	note $1c $02
	duty $12
	note $17 $04
	duty $17
	note $17 $02
	duty $12
	note $10 $04
	duty $17
	note $10 $02
	duty $12
	note $17 $04
	duty $17
	note $17 $02
	duty $12
	note $1c $04
	duty $17
	note $1c $02
	duty $12
	note $17 $04
	duty $17
	note $17 $02
	duty $12
	note $17 $04
	duty $17
	note $17 $02
	duty $12
	note $16 $04
	duty $17
	note $16 $08
	duty $12
	note $15 $04
	duty $17
	note $15 $02
	duty $12
	note $14 $04
	duty $17
	note $14 $02
	duty $12
	note $13 $04
	duty $17
	note $13 $02
	duty $12
	note $12 $04
	duty $17
	note $12 $02
	duty $12
	note $11 $04
	duty $17
	note $11 $02
	duty $12
	note $10 $04
	duty $17
	note $10 $02
	duty $12
	note $17 $04
	duty $17
	note $17 $02
	duty $12
	note $1c $04
	duty $17
	note $1c $02
	duty $12
	note $17 $04
	duty $17
	note $17 $02
	duty $12
	note $10 $04
	duty $17
	note $10 $02
	duty $12
	note $17 $04
	duty $17
	note $17 $02
	duty $12
	note $1c $04
	duty $17
	note $1c $02
	duty $12
	note $17 $04
	duty $17
	note $17 $02
	duty $12
	note $0c $04
	duty $17
	note $0c $02
	duty $12
	note $13 $04
	duty $17
	note $13 $02
	duty $12
	note $18 $04
	duty $17
	note $18 $02
	duty $12
	note $13 $04
	duty $17
	note $13 $02
	duty $12
	note $0c $04
	duty $17
	note $0c $02
	duty $12
	note $13 $04
	duty $17
	note $13 $02
	duty $12
	note $18 $04
	duty $17
	note $18 $02
	duty $12
	note $13 $04
	duty $17
	note $13 $02
	duty $12
	note $0b $04
	duty $17
	note $0b $02
	duty $12
	note $12 $04
	duty $17
	note $12 $02
	duty $12
	note $17 $04
	duty $17
	note $17 $02
	duty $12
	note $12 $04
	duty $17
	note $12 $02
	duty $12
	note $0b $04
	duty $17
	note $0b $02
	duty $12
	note $12 $04
	duty $17
	note $12 $02
	duty $12
	note $17 $04
	duty $17
	note $17 $02
	duty $12
	note $12 $04
	duty $17
	note $12 $02
	duty $12
	note $0c $04
	duty $17
	note $0c $02
	duty $12
	note $13 $04
	duty $17
	note $13 $02
	duty $12
	note $18 $04
	duty $17
	note $18 $02
	duty $12
	note $13 $04
	duty $17
	note $13 $02
	duty $12
	note $0c $04
	duty $17
	note $0c $02
	duty $12
	note $13 $04
	duty $17
	note $13 $02
	duty $12
	note $18 $04
	duty $17
	note $18 $02
	duty $12
	note $13 $04
	duty $17
	note $13 $02
	duty $12
	note $0b $04
	duty $17
	note $0b $02
	duty $12
	note $12 $04
	duty $17
	note $12 $02
	duty $12
	note $17 $04
	duty $17
	note $17 $02
	duty $12
	note $12 $04
	duty $17
	note $12 $02
	duty $12
	note $0b $04
	duty $17
	note $0b $02
	duty $12
	note $12 $04
	duty $17
	note $12 $02
	duty $12
	note $17 $04
	duty $17
	note $17 $02
	duty $12
	note $12 $04
	duty $17
	note $12 $02
	duty $12
	note $0c $04
	duty $17
	note $0c $02
	duty $12
	note $13 $04
	duty $17
	note $13 $02
	duty $12
	note $18 $04
	duty $17
	note $18 $02
	duty $12
	note $13 $04
	duty $17
	note $13 $02
	duty $12
	note $0c $04
	duty $17
	note $0c $02
	duty $12
	note $13 $04
	duty $17
	note $13 $02
	duty $12
	note $18 $04
	duty $17
	note $18 $02
	duty $12
	note $13 $04
	duty $17
	note $13 $02
	duty $12
	note $0b $04
	duty $17
	note $0b $02
	duty $12
	note $12 $04
	duty $17
	note $12 $02
	duty $12
	note $17 $04
	duty $17
	note $17 $02
	duty $12
	note $12 $04
	duty $17
	note $12 $02
	duty $12
	note $0b $04
	duty $17
	note $0b $02
	duty $12
	note $12 $04
	duty $17
	note $12 $02
	duty $12
	note $17 $04
	duty $17
	note $17 $02
	duty $12
	note $12 $04
	duty $17
	note $12 $02
	duty $12
	note $13 $04
	duty $17
	note $13 $02
	duty $12
	note $12 $04
	duty $17
	note $12 $08
	duty $12
	note $11 $04
	duty $17
	note $11 $02
	duty $12
	note $10 $04
	duty $17
	note $10 $08
	duty $12
	note $0f $04
	duty $17
	note $0f $02
	duty $12
	note $0e $04
	duty $17
	note $0e $08
	duty $12
	note $0d $04
	duty $17
	note $0d $02
	duty $12
	note $0c $04
	duty $17
	note $0c $08
	duty $12
	note $0b $04
	duty $17
	note $0b $02
	duty $12
	note $0c $04
	duty $17
	note $0c $02
	duty $12
	note $16 $04
	duty $17
	note $16 $02
	duty $12
	note $17 $04
	duty $17
	note $17 $02
	duty $12
	note $1b $05
	duty $17
	note $1b $13
	duty $12
	note $0b $48
	wait1 $60
	goto musicfa633
	cmdff
; $fabfd
; @addr{fabfd}
sound2eChannel6:
	cmdf2
musicfabfe:
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
	goto musicfabfe
	cmdff
; $fafec
; @addr{fafec}
sound3aChannel1:
	cmdff
; $fafed
; @addr{fafed}
sound3aChannel0:
	cmdff
; $fafee
; @addr{fafee}
sound3aChannel4:
	cmdff
; $fafef
; GAP
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
; @addr{faff6}
sound28Channel1:
	vibrato $00
	env $0 $00
	duty $01
musicfaffc:
	vol $0
	note $20 $24
	vol $6
	note $29 $09
	wait1 $04
	vol $3
	note $29 $09
	wait1 $05
	vol $1
	note $29 $09
	wait1 $24
	vol $6
	note $29 $09
	wait1 $04
	vol $3
	note $29 $09
	wait1 $05
	vol $1
	note $29 $09
	wait1 $24
	vol $6
	note $29 $09
	wait1 $04
	vol $3
	note $29 $09
	wait1 $05
	vol $1
	note $29 $09
	vibrato $00
	env $0 $03
	duty $02
	vol $6
	note $35 $12
	note $35 $12
	note $36 $12
	wait1 $36
	duty $01
	vibrato $00
	env $0 $00
	note $29 $09
	wait1 $04
	vol $3
	note $29 $09
	wait1 $05
	vol $1
	note $29 $09
	wait1 $24
	vol $6
	note $29 $09
	wait1 $04
	vol $3
	note $29 $09
	wait1 $05
	vol $1
	note $29 $09
	wait1 $24
	vol $6
	note $29 $09
	wait1 $04
	vol $3
	note $29 $09
	wait1 $05
	vol $1
	note $29 $09
	vibrato $00
	env $0 $03
	duty $02
	vol $6
	note $35 $12
	note $35 $12
	note $36 $12
	wait1 $12
	vibrato $e1
	env $0 $00
	duty $01
	note $28 $36
	note $26 $12
	note $24 $09
	wait1 $04
	vol $3
	note $24 $09
	wait1 $05
	vol $1
	note $24 $09
	vol $6
	note $23 $09
	wait1 $04
	vol $3
	note $23 $09
	wait1 $05
	vol $1
	note $23 $09
	vol $6
	note $22 $48
	note $21 $09
	wait1 $04
	vol $3
	note $21 $09
	wait1 $05
	vol $1
	note $21 $09
	wait1 $24
	vol $6
	note $20 $48
	note $1f $09
	wait1 $04
	vol $3
	note $1f $09
	wait1 $05
	vol $1
	note $1f $09
	wait1 $24
	vol $6
	note $1d $09
	wait1 $04
	vol $3
	note $1d $09
	wait1 $05
	vol $1
	note $1d $09
	vol $6
	note $1d $09
	note $1e $09
	note $1d $09
	note $1e $09
	wait1 $04
	vol $3
	note $1e $09
	wait1 $05
	vol $6
	note $29 $09
	note $2a $09
	note $29 $09
	note $2a $09
	wait1 $04
	vol $3
	note $2a $09
	wait1 $05
	vol $6
	note $2b $12
	note $2d $09
	note $2b $09
	note $29 $24
	note $2a $09
	wait1 $04
	vol $3
	note $2a $09
	wait1 $05
	vol $1
	note $2a $09
	wait1 $24
	goto musicfaffc
	cmdff
; $fb105
; @addr{fb105}
sound28Channel0:
	vibrato $00
	env $0 $00
	duty $01
musicfb10b:
	vol $0
	note $20 $24
	vol $6
	note $26 $09
	wait1 $04
	vol $3
	note $26 $09
	wait1 $05
	vol $1
	note $26 $09
	wait1 $24
	vol $6
	note $26 $09
	wait1 $04
	vol $3
	note $26 $09
	wait1 $05
	vol $1
	note $26 $09
	wait1 $24
	vol $6
	note $26 $09
	wait1 $04
	vol $3
	note $26 $09
	wait1 $05
	vol $1
	note $26 $09
	env $0 $03
	duty $02
	vol $6
	note $32 $12
	note $32 $12
	note $33 $12
	wait1 $36
	vibrato $00
	env $0 $00
	duty $01
	note $26 $09
	wait1 $04
	vol $3
	note $26 $09
	wait1 $05
	vol $1
	note $26 $09
	wait1 $24
	vol $6
	note $26 $09
	wait1 $04
	vol $3
	note $26 $09
	wait1 $05
	vol $1
	note $26 $09
	wait1 $24
	vol $6
	note $26 $09
	wait1 $04
	vol $3
	note $26 $09
	wait1 $05
	vol $1
	note $26 $09
	vibrato $00
	env $0 $03
	duty $02
	vol $6
	note $32 $12
	note $32 $12
	note $33 $12
	wait1 $ff
	wait1 $ff
	wait1 $e4
	vibrato $00
	env $0 $00
	duty $01
	goto musicfb10b
	cmdff
; $fb193
; @addr{fb193}
sound28Channel4:
musicfb193:
	duty $0e
	note $17 $24
	note $1d $12
	note $1e $12
	note $21 $24
	note $20 $12
	note $1f $12
	note $1d $24
	note $1e $09
	duty $0f
	note $1e $09
	wait1 $5a
	duty $0e
	note $17 $24
	note $1d $12
	note $1e $12
	note $21 $09
	duty $0f
	note $21 $09
	duty $0e
	note $21 $12
	note $20 $12
	note $1f $12
	note $1d $24
	note $1e $09
	duty $0f
	note $1e $09
	wait1 $5a
	duty $0e
	note $1f $36
	note $1e $12
	note $1c $09
	duty $0f
	note $1c $09
	wait1 $12
	duty $0e
	note $1a $09
	duty $0f
	note $1a $09
	wait1 $12
	duty $0e
	note $18 $48
	note $17 $12
	wait1 $36
	note $16 $48
	note $15 $12
	wait1 $36
	note $14 $48
	note $12 $36
	duty $0f
	note $12 $12
	duty $0e
	note $18 $31
	note $17 $05
	note $16 $04
	note $15 $05
	note $14 $04
	note $13 $05
	note $12 $09
	duty $0f
	note $12 $09
	wait1 $12
	duty $0e
	note $11 $03
	note $12 $09
	duty $0f
	note $12 $09
	wait1 $0f
	duty $0e
	goto musicfb193
	cmdff
; $fb221
sound29Start:
; @addr{fb221}
sound29Channel1:
	vibrato $e1
	env $0 $00
	duty $02
	vol $6
	note $2b $18
	vol $3
	note $2b $08
	vol $6
	note $2b $0a
	note $26 $0b
	note $2b $0b
	note $29 $18
	vol $3
	note $29 $08
	vol $6
	note $29 $0a
	note $2b $0b
	note $2d $0b
	note $2e $18
	vol $3
	note $2e $08
	vol $6
	note $2e $0a
	note $2b $0b
	note $2e $0b
	note $2d $18
	vol $3
	note $2d $08
	vol $6
	note $2d $0a
	note $2e $0b
	note $30 $0b
	note $32 $40
	vibrato $01
	vol $3
	note $32 $20
	vibrato $e1
	vol $6
	note $30 $08
	wait1 $02
	note $30 $08
	wait1 $02
	note $30 $09
	wait1 $03
	note $32 $50
	vibrato $01
	vol $3
	note $32 $10
	vibrato $e1
	vol $6
	note $30 $0a
	note $2f $0b
	note $2d $0b
musicfb27e:
	note $2b $08
	wait1 $04
	vol $3
	note $2b $08
	wait1 $04
	vol $1
	note $2b $08
	vol $6
	note $26 $20
	vol $3
	note $26 $10
	vol $6
	note $2b $08
	wait1 $04
	vol $3
	note $2b $04
	vol $6
	note $2b $08
	note $2d $08
	note $2f $08
	note $30 $08
	note $32 $40
	vibrato $01
	vol $3
	note $32 $10
	vibrato $e1
	vol $6
	note $32 $08
	wait1 $04
	vol $3
	note $32 $04
	vol $6
	note $32 $0a
	note $33 $0b
	note $35 $0b
	note $37 $40
	vibrato $01
	vol $3
	note $37 $10
	vibrato $e1
	vol $6
	note $37 $10
	note $35 $10
	note $33 $10
	note $35 $08
	wait1 $04
	vol $3
	note $35 $08
	wait1 $04
	vol $6
	note $33 $08
	note $32 $28
	vibrato $01
	vol $3
	note $32 $18
	vibrato $e1
	vol $6
	note $32 $0a
	note $33 $0b
	note $32 $0b
	note $30 $08
	wait1 $04
	vol $3
	note $30 $04
	vol $6
	note $30 $08
	note $32 $08
	vol $6
	note $33 $28
	vol $3
	note $33 $08
	vol $6
	note $33 $10
	note $32 $10
	note $30 $10
	note $2e $08
	wait1 $04
	vol $3
	note $2e $04
	vol $6
	note $2e $08
	note $30 $08
	note $32 $20
	vol $3
	note $32 $10
	vol $6
	note $32 $10
	note $30 $10
	note $2e $10
	note $2d $08
	wait1 $04
	vol $3
	note $2d $04
	vol $6
	note $2d $08
	note $2f $08
	note $31 $20
	vibrato $01
	vol $3
	note $31 $10
	vibrato $e1
	vol $6
	note $31 $08
	note $32 $08
	note $34 $08
	note $36 $08
	note $37 $08
	note $39 $08
	note $36 $08
	wait1 $04
	vol $3
	note $36 $04
	vol $6
	note $32 $02
	wait1 $02
	note $32 $04
	wait1 $02
	note $32 $02
	wait1 $04
	note $34 $08
	wait1 $02
	note $34 $08
	wait1 $02
	note $34 $09
	wait1 $03
	note $36 $28
	vibrato $01
	vol $3
	note $36 $18
	vibrato $e1
	vol $6
	note $2b $08
	wait1 $04
	vol $3
	note $2b $08
	wait1 $04
	vol $1
	note $2b $08
	vol $6
	note $26 $28
	vol $3
	note $26 $08
	vol $6
	note $2b $08
	wait1 $04
	vol $3
	note $2b $04
	vol $6
	note $2b $08
	note $2d $08
	note $2f $08
	note $30 $08
	note $32 $40
	vibrato $01
	vol $3
	note $32 $10
	vibrato $e1
	vol $6
	note $32 $08
	wait1 $04
	vol $3
	note $32 $04
	vol $6
	note $32 $0a
	note $33 $0b
	note $35 $0b
	note $37 $48
	vibrato $01
	vol $3
	note $37 $08
	vibrato $e1
	vol $6
	note $39 $08
	note $3a $08
	note $3c $08
	note $3a $08
	note $39 $08
	note $37 $08
	note $37 $08
	wait1 $04
	vol $3
	note $37 $08
	wait1 $04
	vol $6
	note $39 $08
	note $35 $28
	vibrato $01
	env $0 $00
	vol $3
	note $35 $18
	vibrato $e1
	vol $6
	note $32 $0a
	note $33 $0b
	note $32 $0b
	note $30 $08
	wait1 $04
	vol $3
	note $30 $04
	vol $6
	note $30 $08
	note $32 $08
	note $33 $28
	vol $3
	note $33 $08
	vol $6
	note $33 $10
	note $32 $10
	note $30 $10
	note $2e $0a
	note $2d $0b
	note $2e $0b
	note $30 $0a
	note $2e $0b
	note $30 $0b
	note $32 $08
	wait1 $04
	vol $3
	note $32 $08
	wait1 $01
	vol $6
	note $31 $08
	wait1 $03
	note $32 $0a
	note $37 $0b
	note $3a $0b
	wait1 $20
	note $32 $20
	note $3e $28
	note $3c $08
	note $3a $08
	note $39 $08
	note $37 $40
	vibrato $01
	vol $3
	note $37 $20
	vibrato $e1
	duty $00
	vol $8
	note $32 $0a
	note $33 $0b
	note $35 $0b
	note $37 $08
	wait1 $04
	vol $3
	note $37 $08
	wait1 $04
	vol $1
	note $37 $08
	vol $8
	note $32 $20
	vibrato $01
	vol $3
	note $32 $18
	vibrato $e1
	vol $8
	note $37 $04
	wait1 $04
	note $37 $08
	note $39 $08
	note $3a $08
	note $3c $08
	note $39 $08
	wait1 $04
	vol $3
	note $39 $08
	wait1 $04
	vol $8
	note $35 $08
	note $30 $20
	vol $3
	note $30 $10
	vol $8
	note $30 $08
	note $32 $08
	note $35 $08
	note $33 $08
	note $32 $08
	note $30 $08
	note $32 $08
	wait1 $04
	vol $3
	note $32 $08
	wait1 $04
	vol $1
	note $32 $08
	vol $8
	note $2b $20
	vol $3
	note $2b $10
	vol $8
	note $2b $08
	note $2a $08
	note $2b $08
	note $2d $08
	note $2e $08
	note $30 $08
	note $32 $40
	vibrato $01
	vol $3
	note $32 $10
	vibrato $e1
	vol $8
	note $32 $10
	note $31 $10
	note $32 $08
	wait1 $04
	vol $3
	note $32 $04
	vol $8
	note $3a $08
	wait1 $04
	vol $3
	note $3a $08
	wait1 $04
	vol $8
	note $39 $08
	note $37 $20
	vol $1
	note $37 $0a
	vol $8
	note $32 $06
	wait1 $05
	note $32 $05
	wait1 $06
	note $32 $0a
	note $2e $0b
	note $37 $0b
	note $38 $08
	wait1 $04
	vol $3
	note $38 $08
	wait1 $04
	vol $8
	note $3a $08
	note $3c $20
	vol $3
	note $3c $0a
	vol $8
	note $3c $08
	wait1 $02
	note $3e $09
	wait1 $03
	note $3f $0a
	note $41 $0b
	note $3f $0b
	note $3e $2a
	wait1 $06
	note $3e $05
	wait1 $03
	note $3e $05
	wait1 $03
	note $3e $2a
	wait1 $06
	note $3e $05
	wait1 $03
	note $3e $05
	wait1 $03
	note $3e $10
	vol $3
	note $3e $10
	duty $02
	vol $8
	note $34 $05
	wait1 $05
	note $34 $06
	wait1 $05
	note $34 $05
	wait1 $06
	note $35 $1a
	wait1 $06
	note $36 $05
	wait1 $05
	note $36 $06
	wait1 $05
	note $36 $05
	wait1 $06
	goto musicfb27e
	cmdff
; $fb51d
; @addr{fb51d}
sound29Channel0:
	vibrato $00
	env $0 $00
	duty $02
	vol $6
	note $22 $40
	note $21 $40
	note $1f $40
	note $1d $40
	note $1b $20
	note $1f $08
	wait1 $02
	note $1f $08
	wait1 $02
	note $1f $09
	wait1 $03
	note $26 $20
	note $1b $08
	wait1 $02
	note $1b $08
	wait1 $02
	note $1b $09
	wait1 $03
	note $1a $10
	note $1f $08
	note $21 $08
	note $26 $10
	note $1f $08
	note $21 $08
	note $1a $1d
	wait1 $03
	note $1a $08
	wait1 $02
	note $1a $08
	wait1 $02
	note $1a $09
	wait1 $03
musicfb564:
	vol $0
	note $20 $15
	note $23 $05
	wait1 $02
	vol $3
	note $23 $04
	vol $6
	note $23 $08
	note $24 $08
	note $23 $08
	note $21 $08
	note $23 $40
	vol $6
	note $29 $10
	note $2b $10
	note $2d $10
	note $2f $10
	note $30 $10
	note $2f $08
	wait1 $04
	vol $3
	note $2f $04
	vol $6
	note $2f $0a
	note $30 $0b
	note $32 $0b
	note $33 $10
	vol $3
	note $33 $05
	vol $6
	note $2e $05
	wait1 $02
	vol $3
	note $2e $04
	vol $6
	note $2e $08
	note $30 $08
	note $2e $08
	note $2d $08
	note $2e $0a
	wait1 $02
	vol $3
	note $2e $04
	vol $6
	note $2e $10
	note $2d $10
	note $2b $10
	note $2d $08
	wait1 $04
	vol $3
	note $2d $08
	wait1 $04
	vol $6
	note $2b $08
	note $29 $08
	wait1 $02
	note $29 $0b
	note $2b $0b
	note $2c $10
	note $2b $10
	note $29 $0a
	note $27 $0b
	note $26 $0b
	note $27 $20
	vol $3
	note $27 $10
	vol $6
	note $27 $08
	note $29 $08
	note $2b $08
	wait1 $04
	vol $3
	note $2b $04
	vol $6
	note $2b $10
	note $29 $10
	note $27 $10
	note $26 $20
	vol $3
	note $26 $10
	vol $6
	note $26 $08
	note $27 $08
	note $29 $0a
	wait1 $06
	note $29 $10
	note $27 $10
	note $26 $10
	note $25 $20
	vol $3
	note $25 $10
	vol $6
	note $25 $08
	note $26 $08
	note $28 $10
	note $2a $10
	vol $6
	note $2b $10
	vol $6
	note $2d $10
	note $2e $20
	note $2d $08
	wait1 $04
	vol $3
	note $2d $08
	wait1 $04
	vol $1
	note $2d $08
	vol $6
	note $2e $20
	note $2d $08
	wait1 $04
	vol $3
	note $2d $08
	wait1 $04
	vol $1
	note $2d $08
	vol $6
	note $37 $40
	note $32 $20
	note $30 $20
	note $2f $10
	note $2b $08
	wait1 $04
	vol $3
	note $2b $04
	vol $6
	note $2b $08
	note $2d $08
	note $2f $08
	note $30 $08
	note $32 $10
	note $2f $08
	wait1 $04
	vol $3
	note $2f $04
	vol $6
	note $2f $0a
	note $30 $0b
	note $32 $0b
	note $33 $20
	note $2e $10
	note $2b $10
	note $27 $10
	note $2e $10
	note $2d $10
	note $2b $10
	note $2d $08
	wait1 $04
	vol $3
	note $2d $08
	wait1 $04
	vol $6
	note $2b $08
	note $29 $05
	wait1 $03
	note $29 $10
	note $2b $08
	note $29 $30
	vol $3
	note $29 $10
	vol $6
	note $27 $20
	vol $3
	note $27 $10
	vol $6
	note $29 $10
	note $2b $08
	wait1 $04
	vol $3
	note $2b $04
	vol $6
	note $2b $10
	note $29 $10
	note $27 $10
	note $26 $20
	note $28 $20
	note $2a $20
	note $2b $20
	note $2d $10
	note $2e $10
	note $2d $10
	note $2b $10
	note $2a $10
	note $33 $10
	note $32 $10
	note $2a $10
	note $2e $10
	note $30 $10
	note $2e $10
	note $2d $10
	note $2b $08
	wait1 $04
	vol $3
	note $2b $04
	vol $6
	note $1f $08
	note $21 $08
	note $22 $08
	note $24 $08
	note $26 $05
	note $27 $05
	note $29 $06
	note $2e $08
	wait1 $04
	vol $3
	note $2e $08
	wait1 $04
	vol $6
	note $2d $08
	note $2b $20
	vol $3
	note $2b $18
	vol $6
	note $26 $08
	note $2b $08
	note $29 $08
	note $2b $08
	note $2d $08
	note $30 $08
	wait1 $04
	vol $3
	note $30 $08
	wait1 $04
	vol $6
	note $2e $08
	note $2d $08
	note $2e $08
	note $2d $08
	note $2b $08
	note $29 $30
	vol $3
	note $29 $10
	vol $6
	note $2b $18
	vol $3
	note $2b $08
	vol $6
	note $26 $20
	note $24 $20
	note $29 $10
	note $2b $10
	note $26 $18
	vol $3
	note $26 $08
	vol $6
	note $2b $08
	note $2d $08
	note $2e $08
	note $30 $08
	note $32 $10
	note $2e $10
	note $2d $10
	note $2e $10
	note $32 $08
	wait1 $04
	vol $3
	note $32 $08
	wait1 $04
	vol $6
	note $30 $08
	note $2e $18
	vol $3
	note $2e $10
	wait1 $02
	vol $6
	note $2e $06
	wait1 $05
	note $2e $05
	wait1 $06
	note $2e $0a
	note $2b $0b
	note $26 $0b
	note $24 $08
	wait1 $04
	vol $3
	note $24 $08
	wait1 $01
	vol $6
	note $20 $08
	wait1 $03
	note $20 $0a
	note $1b $0b
	note $20 $0b
	note $24 $0a
	note $20 $0b
	note $24 $0b
	note $27 $0a
	note $24 $0b
	note $27 $0b
	note $26 $10
	note $2b $08
	note $2d $08
	note $32 $10
	note $2b $08
	note $2d $08
	note $26 $10
	note $1f $08
	note $21 $08
	note $1a $10
	note $13 $08
	note $15 $08
	note $1a $04
	note $1c $04
	vol $6
	note $1e $04
	note $1f $04
	note $21 $04
	note $22 $04
	note $24 $04
	note $26 $04
	note $2b $05
	wait1 $05
	note $2b $06
	wait1 $05
	note $2b $05
	wait1 $06
	note $2d $1a
	wait1 $06
	note $2e $05
	wait1 $05
	note $2e $06
	wait1 $05
	note $2e $05
	wait1 $06
	goto musicfb564
	cmdff
; $fb7b3
; @addr{fb7b3}
sound29Channel4:
	duty $0e
	wait1 $ff
	wait1 $ff
	wait1 $02
musicfb7bb:
	duty $0e
	note $1f $80
	note $1d $80
	note $1b $40
	note $1d $20
	note $1b $20
	note $1a $40
	note $1f $40
	note $18 $30
	note $1f $10
	note $24 $30
	duty $17
	note $24 $10
	duty $0e
	note $16 $30
	note $1f $10
	note $22 $28
	duty $17
	note $22 $18
	duty $0e
	note $15 $20
	note $17 $20
	note $18 $20
	note $19 $20
	note $1a $20
	wait1 $40
	note $0e $08
	wait1 $02
	note $0e $08
	wait1 $02
	note $0e $09
	wait1 $03
	note $13 $08
	duty $17
	note $13 $08
	duty $0e
	note $13 $18
	duty $17
	note $13 $08
	duty $0e
	note $13 $18
	duty $17
	note $13 $08
	duty $0e
	note $13 $18
	duty $17
	note $13 $08
	duty $0e
	note $13 $10
	duty $0e
	note $11 $08
	duty $17
	note $11 $08
	duty $0e
	note $11 $18
	duty $17
	note $11 $08
	duty $0e
	note $11 $18
	duty $17
	note $11 $08
	duty $0e
	note $11 $18
	duty $17
	note $11 $08
	duty $0e
	note $11 $10
	duty $0e
	note $0f $08
	duty $17
	note $0f $08
	duty $0e
	note $0f $18
	duty $17
	note $0f $08
	duty $0e
	note $0f $10
	duty $0e
	note $11 $08
	duty $17
	note $11 $08
	duty $0e
	note $11 $1c
	duty $17
	note $11 $04
	duty $0e
	note $0f $10
	duty $0e
	note $0e $08
	duty $17
	note $0e $08
	duty $0e
	note $15 $20
	note $1a $20
	note $15 $10
	note $11 $10
	note $0e $10
	note $0c $08
	note $0e $08
	note $0f $18
	note $0e $08
	note $0f $08
	note $11 $08
	note $13 $08
	note $12 $08
	note $13 $08
	note $15 $08
	note $16 $08
	note $18 $08
	note $16 $08
	note $15 $08
	note $13 $10
	note $14 $08
	note $13 $08
	note $12 $10
	note $13 $08
	note $12 $08
	note $11 $10
	note $12 $08
	note $11 $08
	note $10 $10
	note $11 $08
	note $10 $08
	note $0f $08
	duty $17
	note $0f $08
	duty $0e
	note $0f $1c
	duty $17
	note $0f $04
	duty $0e
	note $0f $05
	note $11 $05
	note $0f $06
	duty $0e
	note $0e $14
	duty $17
	note $0e $0c
	duty $0e
	note $0e $08
	note $15 $08
	note $1a $08
	note $0e $08
	duty $0e
	note $13 $10
	duty $17
	note $13 $10
	duty $0e
	note $13 $08
	note $15 $08
	note $13 $08
	note $12 $08
	note $13 $08
	note $15 $08
	note $16 $08
	note $18 $08
	note $1a $08
	note $1b $08
	note $1d $08
	note $1f $08
	duty $0e
	note $1b $20
	duty $17
	note $1b $08
	duty $0e
	note $16 $08
	note $1b $08
	note $1a $08
	note $1b $10
	note $16 $10
	note $15 $10
	note $13 $10
	duty $0e
	note $0e $20
	duty $17
	note $0e $08
	duty $0e
	note $1d $04
	duty $17
	note $1d $04
	duty $0e
	note $1d $08
	note $1b $08
	note $1a $20
	note $0e $20
	duty $0e
	note $13 $08
	duty $17
	note $13 $08
	duty $0e
	note $13 $1c
	duty $17
	note $13 $04
	duty $0e
	note $13 $10
	duty $0e
	note $11 $0c
	duty $17
	note $11 $04
	duty $0e
	note $11 $1c
	duty $17
	note $11 $04
	duty $0e
	note $11 $10
	duty $0e
	note $10 $08
	duty $17
	note $10 $08
	duty $0e
	note $10 $10
	duty $17
	note $10 $08
	duty $0e
	note $10 $08
	note $11 $08
	note $10 $08
	duty $0e
	note $0f $1d
	duty $17
	note $0f $03
	duty $0e
	note $0e $1d
	duty $17
	note $0e $03
	duty $0e
	note $0c $28
	note $13 $08
	note $18 $08
	note $17 $08
	note $16 $20
	note $15 $20
	note $14 $0a
	note $0f $0b
	note $14 $0b
	note $18 $0a
	note $14 $0b
	note $18 $0b
	note $1b $0a
	note $18 $0b
	note $1b $0b
	note $20 $0a
	note $1b $0b
	note $20 $0b
	duty $0e
	note $1a $08
	duty $17
	note $1a $08
	duty $0e
	note $0e $18
	duty $17
	note $0e $08
	duty $0e
	note $0e $18
	duty $17
	note $0e $08
	duty $0e
	note $0e $18
	duty $17
	note $0e $08
	duty $0e
	note $0e $08
	duty $17
	note $0e $08
	duty $0e
	note $0e $20
	duty $0e
	note $10 $05
	duty $17
	note $10 $05
	duty $0e
	note $10 $06
	duty $17
	note $10 $05
	duty $0e
	note $10 $05
	duty $17
	note $10 $06
	duty $0e
	note $11 $1a
	duty $17
	note $11 $06
	duty $0e
	note $12 $05
	duty $17
	note $12 $05
	duty $0e
	note $12 $06
	duty $17
	note $12 $05
	duty $0e
	note $12 $05
	duty $17
	note $12 $06
	goto musicfb7bb
	cmdff
; $fba0b
; @addr{fba0b}
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
musicfba80:
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
	goto musicfba80
	cmdff
; $fbd7a
; @addr{fbd7a}
sound25Channel1:
	vibrato $00
	env $0 $04
	duty $02
musicfbd80:
	vol $8
	note $18 $0a
	wait1 $14
	note $1b $14
	note $18 $0a
	wait1 $14
	note $13 $0a
	note $16 $14
	note $17 $0a
	note $18 $1e
	note $1b $14
	note $1f $0a
	wait1 $14
	note $13 $0a
	note $16 $14
	note $13 $0a
	note $18 $1e
	note $1b $14
	note $18 $0a
	wait1 $14
	note $13 $0a
	note $16 $14
	note $17 $0a
	note $18 $1e
	note $1b $14
	note $18 $0a
	wait1 $14
	note $18 $0a
	note $1b $14
	note $1f $0a
	note $1d $1e
	note $21 $14
	note $18 $0a
	wait1 $14
	note $18 $0a
	note $1b $14
	note $1c $0a
	note $1d $1e
	note $21 $14
	note $18 $0a
	wait1 $14
	note $18 $0a
	note $1b $14
	note $1c $0a
	note $1d $1e
	note $21 $14
	note $18 $0a
	wait1 $14
	note $18 $0a
	note $1b $14
	note $1c $0a
	note $1d $1e
	note $21 $14
	note $1d $0a
	wait1 $14
	note $1d $0a
	note $21 $14
	note $1d $0a
	wait1 $14
	vibrato $00
	env $0 $00
	vol $6
	note $37 $0a
	note $36 $0a
	wait1 $14
	note $36 $14
	note $35 $0a
	wait1 $14
	note $35 $0a
	note $34 $0a
	wait1 $14
	note $34 $14
	note $33 $0a
	wait1 $14
	note $33 $0a
	note $32 $14
	vol $3
	note $32 $0a
	wait1 $14
	vol $6
	note $3a $0a
	note $39 $0a
	wait1 $14
	note $39 $14
	note $38 $0a
	wait1 $14
	note $38 $0a
	note $37 $0a
	wait1 $14
	note $37 $14
	note $36 $0a
	wait1 $14
	note $36 $0a
	note $35 $14
	vol $3
	note $35 $0a
	wait1 $14
	vol $6
	note $3c $0a
	note $3b $0a
	wait1 $14
	note $3b $14
	note $3a $0a
	wait1 $14
	note $3a $0a
	note $39 $0a
	wait1 $14
	note $39 $14
	note $38 $0a
	wait1 $14
	note $38 $0a
	note $37 $14
	vol $3
	note $37 $0a
	vibrato $00
	env $0 $03
	vol $6
	note $36 $14
	wait1 $28
	note $35 $14
	wait1 $28
	note $33 $14
	wait1 $28
	note $32 $14
	wait1 $28
	vibrato $00
	env $0 $04
	goto musicfbd80
	cmdff
; $fbe7a
; @addr{fbe7a}
sound25Channel0:
	vibrato $00
	env $0 $00
	duty $02
musicfbe80:
	vol $0
	note $20 $ff
	wait1 $ff
	wait1 $ff
	wait1 $d7
	vol $6
	note $33 $0a
	note $32 $0a
	wait1 $14
	note $32 $14
	note $31 $0a
	wait1 $14
	note $31 $0a
	note $30 $0a
	wait1 $14
	note $30 $14
	note $2f $0a
	wait1 $14
	note $2f $0a
	note $2e $14
	vol $3
	note $2e $0a
	wait1 $14
	vol $6
	note $37 $0a
	note $36 $0a
	wait1 $14
	note $36 $14
	note $35 $0a
	wait1 $14
	note $35 $0a
	note $34 $0a
	wait1 $14
	note $34 $14
	note $33 $0a
	wait1 $14
	note $33 $0a
	note $32 $14
	vol $3
	note $32 $0a
	wait1 $14
	vol $6
	note $39 $0a
	note $38 $0a
	wait1 $14
	note $38 $14
	note $37 $0a
	wait1 $14
	note $37 $0a
	note $36 $0a
	wait1 $14
	note $36 $14
	note $35 $0a
	wait1 $14
	note $35 $0a
	note $34 $14
	vol $3
	note $34 $0a
	vibrato $00
	env $0 $03
	vol $6
	note $33 $14
	wait1 $28
	note $32 $14
	wait1 $28
	note $30 $14
	wait1 $28
	note $2f $14
	wait1 $28
	vibrato $00
	env $0 $00
	goto musicfbe80
	cmdff
; $fbf0a
; @addr{fbf0a}
sound25Channel4:
musicfbf0a:
	duty $0e
	note $26 $05
	note $27 $2d
	note $24 $0a
	wait1 $32
	note $1f $0a
	note $22 $14
	note $21 $0a
	note $22 $14
	note $21 $0a
	note $1f $0a
	wait1 $14
	note $1d $0a
	wait1 $14
	note $26 $05
	note $27 $2d
	note $24 $0a
	wait1 $32
	note $1f $0a
	note $22 $0a
	note $21 $0a
	note $22 $0a
	note $21 $0a
	note $22 $0a
	note $21 $0a
	note $1f $14
	note $22 $0a
	note $24 $0a
	wait1 $0a
	note $27 $0a
	note $28 $05
	note $29 $2d
	note $24 $0a
	wait1 $32
	note $26 $0a
	note $27 $14
	note $26 $0a
	note $27 $14
	note $26 $0a
	note $24 $0a
	wait1 $14
	note $22 $0a
	wait1 $14
	note $28 $05
	note $29 $2d
	note $2d $0a
	wait1 $32
	note $30 $0a
	note $33 $0a
	note $32 $0a
	note $30 $0a
	note $33 $0a
	note $32 $0a
	note $30 $05
	wait1 $05
	note $30 $14
	note $33 $0a
	note $32 $14
	note $33 $0a
	duty $0e
	note $13 $3c
	duty $0f
	note $13 $14
	wait1 $78
	duty $0e
	note $13 $07
	duty $0f
	note $13 $03
	duty $0e
	note $13 $0f
	duty $0f
	note $13 $05
	duty $0e
	note $13 $07
	duty $0f
	note $13 $03
	duty $0e
	note $14 $3c
	duty $0f
	note $14 $14
	wait1 $78
	duty $0e
	note $14 $07
	duty $0f
	note $14 $03
	duty $0e
	note $14 $0f
	duty $0f
	note $14 $05
	duty $0e
	note $14 $07
	duty $0f
	note $14 $03
	duty $0e
	note $13 $3c
	duty $0f
	note $13 $14
	wait1 $be
	duty $0e
	note $13 $0f
	wait1 $2d
	duty $0e
	note $13 $0f
	wait1 $2d
	duty $0e
	note $13 $0f
	duty $0f
	note $13 $0f
	duty $0e
	note $15 $0f
	duty $0f
	note $15 $0f
	duty $0e
	note $17 $0f
	duty $0f
	note $17 $0f
	goto musicfbf0a
	cmdff
; $fbff6
