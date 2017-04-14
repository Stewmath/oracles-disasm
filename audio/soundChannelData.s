sounddeStart:
; @addr{e59ff}
sounddeChannel0:
sounddeChannel1:
sounddeChannel4:
sounddeChannel6:
	cmdff
; $e5a00
sound1eStart:
sound06Start:
sounda1Start:
; @addr{e5a00}
sound1eChannel6:
sound06Channel6:
sounda1Channel7:
	cmdff
; $e5a01
; GAP
	cmdff
sound99Start:
; @addr{e5a02}
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
; $e5a4b
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
; @addr{e5a56}
sounda1Channel2:
	duty $00
	vol $a
	cmdf8 $0a
	note $3c $05
	cmdf8 $00
	cmdff
; $e5a60
sounda4Start:
; @addr{e5a60}
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
; $e5a97
; @addr{e5a97}
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
; $e5aae
soundaaStart:
; @addr{e5aae}
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
; $e5ad3
soundabStart:
; @addr{e5ad3}
soundabChannel2:
	cmdf0 $00
	vol $0
	.db $00 $00 $09
	vol $6
	env $0 $07
	.db $07 $c0 $55
	cmdff
; $e5ae0
; @addr{e5ae0}
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
; $e5af5
sound8aStart:
; @addr{e5af5}
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
; $e5ba3
sound88Start:
; @addr{e5ba3}
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
; $e5bbf
sound97Start:
; @addr{e5bbf}
sound97Channel2:
	cmdff
; $e5bc0
sound98Start:
; @addr{e5bc0}
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
; $e5bf5
soundb1Start:
; @addr{e5bf5}
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
; $e5c46
soundb3Start:
; @addr{e5c46}
soundb3Channel2:
	cmdf0 $df
	.db $00 $45 $03
	vol $8
	env $0 $05
	.db $00 $45 $32
	cmdff
; $e5c52
; @addr{e5c52}
soundb3Channel7:
	cmdf0 $f5
	note $75 $3c
	cmdff
; $e5c57
soundbeStart:
; @addr{e5c57}
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
; $e5ce8
soundacStart:
; @addr{e5ce8}
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
; $e5d1e
; @addr{e5d1e}
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
; $e5d53
soundbaStart:
; @addr{e5d53}
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
; $e5d94
soundb4Start:
; @addr{e5d94}
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
; $e5dcd
sound9cStart:
; @addr{e5dcd}
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
; $e5df0
sounda0Start:
; @addr{e5df0}
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
; $e5e33
soundb2Start:
; @addr{e5e33}
soundb2Channel2:
	duty $02
	vol $3
	note $0c $1c
	note $0c $1c
	note $0c $1c
	note $0c $1c
	note $0c $1c
	cmdff
; $e5e41
; @addr{e5e41}
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
; $e5ece
soundbbStart:
; @addr{e5ece}
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
; $e5f17
soundb7Start:
; @addr{e5f17}
soundb7Channel2:
	cmdff
; $e5f18
; @addr{e5f18}
soundb7Channel7:
	cmdff
; $e5f19
sounda8Start:
; @addr{e5f19}
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
; $e5f40
; @addr{e5f40}
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
; $e5fa5
soundb8Start:
; @addr{e5fa5}
soundb8Channel2:
	vol $3
	note $0c $14
	note $0c $14
	note $0c $14
	note $0c $14
	note $0c $14
	note $0c $0a
	cmdff
; $e5fb3
; @addr{e5fb3}
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
; $e5fcc
sound95Start:
; @addr{e5fcc}
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
; $e6161
soundb9Start:
; @addr{e6161}
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
; $e61c1
soundbcStart:
; @addr{e61c1}
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
; $e628c
soundbdStart:
; @addr{e628c}
soundbdChannel2:
	cmdff
; $e628d
sound2cStart:
; @addr{e628d}
sound2cChannel1:
	duty $01
musice628f:
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
	goto musice628f
	cmdff
; $e64a9
; @addr{e64a9}
sound2cChannel0:
	duty $01
musice64ab:
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
	goto musice64ab
	cmdff
; $e66c0
; @addr{e66c0}
sound2cChannel4:
musice66c0:
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
	goto musice66c0
	cmdff
; $e6a48
; @addr{e6a48}
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
; $e6c3c
sound32Start:
; @addr{e6c3c}
sound32Channel1:
	vibrato $e1
	env $0 $00
	duty $02
musice6c42:
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
	goto musice6c42
	cmdff
; $e6da3
; @addr{e6da3}
sound32Channel0:
	vibrato $e1
	env $0 $00
	duty $02
musice6da9:
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
	goto musice6da9
	cmdff
; $e6f81
; @addr{e6f81}
sound32Channel4:
musice6f81:
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
	goto musice6f81
	cmdff
; $e7305
; @addr{e7305}
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
; $e7522
; @addr{e7522}
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
; $e7601
; @addr{e7601}
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
; $e76d0
; @addr{e76d0}
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
; $e76fb
soundadStart:
; @addr{e76fb}
soundadChannel2:
	duty $02
	env $0 $03
	vol $9
	note $30 $0c
	note $34 $0c
	note $37 $0c
	note $32 $0c
	note $35 $0c
	note $39 $0c
	note $34 $0c
	note $37 $0c
	note $3b $0c
	note $35 $0c
	note $39 $0c
	note $3c $0c
	note $37 $0c
	wait1 $0c
	note $37 $03
	note $3b $03
	note $3e $03
	env $0 $07
	note $43 $3f
	wait1 $14
	cmdff
; $e7729
; @addr{e7729}
soundadChannel3:
	duty $02
	env $0 $03
	vol $0
	note $20 $12
	vol $5
	note $30 $0c
	note $34 $0c
	note $37 $0c
	note $32 $0c
	note $35 $0c
	note $39 $0c
	note $34 $0c
	note $37 $0c
	note $3b $0c
	note $35 $0c
	note $39 $0c
	note $3c $0c
	note $37 $0c
	wait1 $0c
	note $37 $03
	note $3b $03
	note $3e $03
	env $0 $07
	note $43 $3f
	cmdff
; $e7758
; @addr{e7758}
soundadChannel5:
	duty $0e
	wait1 $fa
	wait1 $08
	cmdff
; $e775f
; @addr{e775f}
soundadChannel7:
	cmdf0 $00
	note $00 $fa
	note $00 $08
	cmdff
; $e7766
sound22Start:
; @addr{e7766}
sound22Channel1:
	vibrato $e1
	env $0 $00
	duty $02
musice776c:
	vol $0
	note $20 $18
	vol $6
	note $37 $0c
	note $39 $0c
	note $3a $0c
	note $3c $0c
	note $39 $06
	wait1 $03
	vol $4
	note $39 $06
	wait1 $03
	vol $2
	note $39 $06
	vol $6
	note $36 $18
	vibrato $01
	vol $4
	note $36 $0c
	wait1 $06
	vibrato $e1
	vol $6
	note $30 $06
	note $32 $06
	wait1 $04
	vol $4
	note $32 $06
	wait1 $02
	vol $6
	note $39 $03
	wait1 $03
	note $39 $48
	note $3e $04
	vol $6
	note $4a $04
	wait1 $02
	vol $5
	note $4a $04
	wait1 $02
	vol $4
	note $4a $04
	wait1 $34
	vol $6
	note $37 $0c
	note $39 $0c
	note $3a $0c
	note $3c $0c
	note $39 $06
	wait1 $03
	vol $4
	note $39 $06
	wait1 $03
	vol $2
	note $39 $06
	vol $6
	note $36 $18
	vibrato $01
	vol $4
	note $36 $0c
	wait1 $06
	vibrato $e1
	vol $6
	note $30 $06
	vol $6
	note $32 $06
	wait1 $0c
	note $3e $03
	wait1 $03
	vol $6
	note $3e $30
	wait1 $18
	vol $7
	note $48 $04
	wait1 $02
	vol $6
	note $4a $04
	wait1 $02
	vol $5
	note $4a $04
	wait1 $02
	vol $4
	note $4a $04
	wait1 $02
	vol $6
	note $3c $04
	wait1 $02
	vol $4
	note $3c $04
	wait1 $02
	vol $2
	note $3c $04
	vol $6
	note $3c $08
	note $3e $20
	vibrato $01
	vol $4
	note $3e $0c
	wait1 $04
	vibrato $e1
	vol $6
	note $3c $04
	wait1 $02
	vol $4
	note $3c $04
	wait1 $02
	vol $2
	note $3c $04
	vol $6
	note $3c $08
	note $3e $20
	vibrato $01
	vol $4
	note $3e $0c
	wait1 $04
	vibrato $e1
	vol $6
	note $3c $04
	wait1 $02
	vol $4
	note $3c $04
	wait1 $02
	vol $2
	note $3c $04
	vol $6
	note $3c $08
	note $40 $08
	note $3e $08
	note $3c $08
	note $3e $54
	vibrato $01
	vol $4
	note $3e $0c
	vibrato $e1
	vol $6
	note $3c $04
	wait1 $02
	vol $4
	note $3c $04
	wait1 $02
	vol $2
	note $3c $04
	vol $6
	note $3c $08
	note $3e $28
	vibrato $01
	vol $4
	note $3e $08
	vibrato $e1
	vol $6
	note $3c $10
	note $39 $08
	note $3e $28
	vibrato $01
	vol $4
	note $3e $08
	vibrato $e1
	vol $6
	note $3c $08
	note $39 $08
	note $3c $08
	note $40 $08
	note $3e $08
	note $3c $08
	note $3e $3c
	vibrato $01
	vol $4
	note $3e $0c
	vibrato $e1
	vol $6
	note $45 $18
	note $43 $18
	goto musice776c
	cmdff
; $e7895
; @addr{e7895}
sound22Channel0:
	vibrato $00
	env $0 $00
	duty $02
musice789b:
	vol $9
	note $1e $18
	note $21 $06
	wait1 $03
	vol $5
	note $21 $06
	wait1 $03
	vol $3
	note $21 $06
	vol $9
	note $21 $06
	wait1 $03
	vol $5
	note $21 $06
	wait1 $03
	vol $3
	note $21 $06
	vol $9
	note $1e $18
	note $21 $06
	wait1 $03
	vol $5
	note $21 $06
	wait1 $03
	vol $3
	note $21 $06
	vol $9
	note $21 $06
	wait1 $03
	vol $5
	note $21 $06
	wait1 $03
	vol $3
	note $21 $06
	vol $9
	note $1e $18
	note $21 $06
	wait1 $03
	vol $5
	note $21 $06
	wait1 $03
	vol $3
	note $21 $06
	vol $9
	note $21 $06
	wait1 $03
	vol $5
	note $21 $06
	wait1 $03
	vol $3
	note $21 $06
	vol $9
	note $1e $18
	note $21 $06
	wait1 $03
	vol $5
	note $21 $06
	wait1 $03
	vol $3
	note $21 $06
	vol $9
	note $21 $06
	wait1 $03
	vol $5
	note $21 $06
	wait1 $03
	vol $3
	note $21 $06
	vol $9
	note $1e $18
	note $21 $06
	wait1 $03
	vol $5
	note $21 $06
	wait1 $03
	vol $3
	note $21 $06
	vol $9
	note $21 $06
	wait1 $03
	vol $5
	note $21 $06
	wait1 $03
	vol $3
	note $21 $06
	vol $9
	note $1e $18
	note $21 $06
	wait1 $03
	vol $5
	note $21 $06
	wait1 $03
	vol $3
	note $21 $06
	vol $9
	note $21 $06
	wait1 $03
	vol $5
	note $21 $06
	wait1 $03
	vol $3
	note $21 $06
	vol $9
	note $1e $18
	note $21 $06
	wait1 $03
	vol $5
	note $21 $06
	wait1 $03
	vol $3
	note $21 $06
	vol $9
	note $21 $06
	wait1 $03
	vol $5
	note $21 $06
	wait1 $03
	vol $3
	note $21 $06
	vol $9
	note $1e $18
	note $21 $06
	wait1 $03
	vol $5
	note $21 $06
	wait1 $03
	vol $3
	note $21 $06
	vol $6
	note $37 $04
	wait1 $02
	vol $4
	note $37 $04
	wait1 $02
	vol $2
	note $37 $04
	vol $6
	note $37 $08
	note $39 $12
	vol $4
	note $39 $06
	vol $6
	note $39 $04
	wait1 $02
	vol $4
	note $39 $02
	vol $6
	note $34 $04
	wait1 $02
	vol $4
	note $34 $02
	vol $6
	note $39 $04
	wait1 $02
	vol $4
	note $39 $02
	vol $6
	note $37 $04
	wait1 $02
	vol $4
	note $37 $04
	wait1 $02
	vol $2
	note $37 $04
	vol $6
	note $37 $08
	note $39 $12
	vol $4
	note $39 $06
	vol $6
	note $34 $04
	wait1 $02
	vol $4
	note $34 $02
	vol $6
	note $37 $04
	wait1 $02
	vol $4
	note $37 $02
	vol $6
	note $39 $04
	wait1 $02
	vol $4
	note $39 $02
	vol $6
	note $37 $04
	wait1 $02
	vol $4
	note $37 $04
	wait1 $02
	vol $2
	note $37 $04
	vol $6
	note $37 $08
	note $3b $08
	note $39 $08
	note $37 $08
	note $39 $18
	note $1e $0c
	note $1f $0c
	note $20 $0c
	note $21 $0c
	note $22 $0c
	note $23 $0c
	note $37 $04
	wait1 $02
	vol $4
	note $37 $04
	wait1 $02
	vol $2
	note $37 $04
	vol $6
	note $37 $08
	note $39 $18
	note $34 $06
	wait1 $03
	vol $4
	note $34 $06
	wait1 $01
	vol $6
	note $34 $08
	vol $6
	note $37 $10
	note $34 $08
	note $39 $18
	vol $6
	note $34 $08
	note $32 $08
	note $34 $08
	vol $6
	note $37 $08
	note $34 $08
	note $37 $08
	note $3b $08
	note $39 $08
	note $37 $08
	note $39 $18
	note $32 $08
	note $2d $08
	note $32 $08
	note $39 $08
	note $34 $08
	note $39 $08
	note $40 $08
	note $39 $08
	note $40 $08
	note $3e $08
	note $39 $08
	note $3e $08
	goto musice789b
	cmdff
; $e7a42
; @addr{e7a42}
sound22Channel4:
musice7a42:
	duty $0e
	note $0e $18
	duty $0f
	note $0e $06
	wait1 $2a
	duty $0e
	note $0c $18
	duty $0f
	note $0c $06
	wait1 $2a
	duty $0e
	note $0e $18
	duty $0f
	note $0e $06
	wait1 $2a
	duty $0e
	note $0c $18
	duty $0f
	note $0c $06
	wait1 $2a
	duty $0e
	note $0e $18
	duty $0f
	note $0e $06
	wait1 $2a
	duty $0e
	note $0c $18
	duty $0f
	note $0c $06
	wait1 $2a
	duty $0e
	note $0e $18
	duty $0f
	note $0e $06
	wait1 $2a
	duty $0e
	note $0c $18
	duty $0f
	note $0c $06
	wait1 $2a
	duty $0e
	note $09 $0c
	duty $0f
	note $09 $0c
	duty $0e
	note $15 $18
	duty $0f
	note $15 $18
	duty $0e
	note $09 $0c
	duty $0f
	note $09 $0c
	duty $0e
	note $15 $18
	duty $0f
	note $15 $18
	duty $0e
	note $09 $0c
	duty $0f
	note $09 $0c
	duty $0e
	note $15 $18
	duty $0f
	note $15 $18
	duty $0e
	note $09 $0c
	duty $0f
	note $09 $0c
	duty $0e
	note $15 $18
	duty $0f
	note $15 $18
	duty $0e
	note $09 $0c
	wait1 $04
	note $09 $08
	note $15 $18
	note $13 $08
	note $10 $08
	note $13 $08
	note $09 $0c
	wait1 $04
	note $09 $08
	note $15 $0c
	wait1 $04
	note $15 $08
	note $10 $08
	note $13 $08
	note $10 $08
	note $09 $0c
	wait1 $04
	note $09 $08
	note $15 $0c
	wait1 $04
	note $15 $08
	note $13 $08
	note $10 $08
	note $13 $08
	note $09 $08
	note $0a $08
	note $09 $08
	note $10 $08
	note $15 $08
	note $10 $08
	note $15 $08
	note $1c $08
	note $15 $08
	goto musice7a42
	cmdff
; $e7b1c
; @addr{e7b1c}
sound22Channel6:
musice7b1c:
	vol $6
	note $24 $03
	wait1 $15
	note $26 $03
	wait1 $15
	note $26 $03
	wait1 $15
	note $24 $03
	wait1 $15
	note $26 $03
	wait1 $15
	note $26 $03
	wait1 $15
	note $24 $03
	wait1 $15
	note $26 $03
	wait1 $15
	note $26 $03
	wait1 $15
	note $24 $03
	wait1 $15
	note $26 $03
	wait1 $09
	note $26 $03
	wait1 $09
	note $26 $03
	wait1 $15
	note $24 $03
	wait1 $15
	note $26 $03
	wait1 $15
	note $26 $03
	wait1 $15
	note $24 $03
	wait1 $15
	note $26 $03
	wait1 $15
	note $26 $03
	wait1 $15
	note $24 $03
	wait1 $15
	note $26 $03
	wait1 $15
	note $26 $03
	wait1 $15
	note $24 $03
	wait1 $15
	note $26 $03
	wait1 $09
	note $26 $03
	wait1 $09
	note $26 $03
	wait1 $15
	note $24 $03
	wait1 $0d
	note $24 $03
	wait1 $05
	note $26 $03
	wait1 $15
	note $26 $03
	wait1 $05
	note $26 $03
	wait1 $05
	note $26 $03
	wait1 $05
	note $24 $03
	wait1 $0d
	note $24 $03
	wait1 $05
	note $26 $03
	wait1 $15
	note $26 $03
	wait1 $05
	note $26 $03
	wait1 $05
	note $26 $03
	wait1 $05
	note $24 $03
	wait1 $0d
	note $24 $03
	wait1 $05
	note $26 $03
	wait1 $15
	note $26 $03
	wait1 $05
	note $26 $03
	wait1 $05
	note $26 $03
	wait1 $05
	note $26 $03
	wait1 $0d
	note $26 $03
	wait1 $05
	note $26 $03
	wait1 $0d
	note $26 $03
	wait1 $05
	note $26 $03
	wait1 $05
	note $26 $03
	wait1 $05
	note $26 $03
	wait1 $05
	note $26 $03
	wait1 $0d
	note $26 $03
	wait1 $05
	note $26 $03
	wait1 $0d
	note $26 $03
	wait1 $05
	note $26 $03
	wait1 $05
	note $26 $03
	wait1 $05
	note $26 $03
	wait1 $05
	note $26 $03
	wait1 $0d
	note $26 $03
	wait1 $05
	note $26 $03
	wait1 $0d
	note $26 $03
	wait1 $05
	note $26 $03
	wait1 $05
	note $26 $03
	wait1 $05
	note $26 $03
	wait1 $05
	note $26 $03
	wait1 $0d
	note $26 $03
	wait1 $05
	note $26 $03
	wait1 $0d
	note $26 $03
	wait1 $05
	note $26 $03
	wait1 $05
	note $26 $03
	wait1 $05
	note $26 $03
	wait1 $05
	note $26 $03
	wait1 $05
	note $26 $03
	wait1 $05
	note $26 $03
	wait1 $05
	note $26 $03
	wait1 $05
	note $26 $03
	wait1 $05
	note $26 $03
	wait1 $05
	note $26 $03
	wait1 $05
	note $26 $03
	wait1 $05
	note $26 $03
	wait1 $05
	goto musice7b1c
	cmdff
; $e7c65
; @addr{e7c65}
sound1eChannel1:
	vol $0
	note $20 $14
musice7c68:
	vibrato $e1
	env $0 $00
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
	goto musice7c68
	cmdff
; $e7dbc
; @addr{e7dbc}
sound1eChannel0:
	vol $0
	note $20 $14
musice7dbf:
	vibrato $e1
	env $0 $00
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
	goto musice7dbf
	cmdff
; $e7f14
; @addr{e7f14}
sound1eChannel4:
	wait1 $14
musice7f16:
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
	goto musice7f16
	cmdff
; $e7f5e
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
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
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
; @addr{e8000}
sound00Channel6:
sound01Channel6:
sound09Channel6:
sound0eChannel6:
sound36Channel4:
sound36Channel6:
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
; @addr{e8435}
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
musice8526:
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
	goto musice8526
	cmdff
; $e8671
; @addr{e8671}
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
musice8762:
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
	goto musice8762
	cmdff
; $e8866
; @addr{e8866}
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
musice88ca:
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
	goto musice88ca
	cmdff
; $e8946
sound2dStart:
; @addr{e8946}
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
musice89a1:
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
	goto musice89a1
	cmdff
; $e8aa7
; @addr{e8aa7}
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
musice8b04:
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
	goto musice8b04
	cmdff
; $e8c0d
; @addr{e8c0d}
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
musice8c51:
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
	goto musice8c51
	cmdff
; $e8d69
; @addr{e8d69}
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
musice8e06:
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
	goto musice8e06
	cmdff
; $e9120
; @addr{e9120}
sound09Channel1:
	duty $02
	env $0 $03
musice9124:
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
	goto musice9124
	cmdff
; $e9258
; @addr{e9258}
sound09Channel0:
	duty $02
	env $0 $03
musice925c:
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
	goto musice925c
	cmdff
; $e92cc
; @addr{e92cc}
sound09Channel4:
musice92cc:
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
	goto musice92cc
	cmdff
; $e9328
; @addr{e9328}
sound36Channel1:
	duty $02
musice932a:
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
	goto musice932a
	cmdff
; $e93c2
; @addr{e93c2}
sound36Channel0:
	duty $02
musice93c4:
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
	goto musice93c4
	cmdff
; $e9470
sound10Start:
; @addr{e9470}
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
; $e9498
; @addr{e9498}
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
; $e94c0
; @addr{e94c0}
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
; $e94d9
; @addr{e94d9}
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
; $e94ec
sound74Start:
; @addr{e94ec}
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
; $e9511
sound73Start:
; @addr{e9511}
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
; $e953a
sound54Start:
; @addr{e953a}
sound54Channel2:
	duty $01
	vol $f
	env $3 $00
	cmdf8 $23
	note $18 $16
	cmdff
; $e9544
; @addr{e9544}
sound54Channel3:
	duty $02
	vol $f
	env $3 $00
	cmdf8 $2c
	note $0c $16
	cmdff
; $e954e
sound55Start:
; @addr{e954e}
sound55Channel2:
	duty $02
	vol $d
	env $1 $00
	cmdf8 $d3
	note $2b $09
	cmdff
; $e9558
; @addr{e9558}
sound55Channel3:
	duty $01
	vol $d
	env $1 $00
	cmdf8 $e0
	note $2b $09
	cmdff
; $e9562
sound5cStart:
; @addr{e9562}
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
; $e96c8
sound5dStart:
; @addr{e96c8}
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
; $e974d
sound64Start:
; @addr{e974d}
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
; $e978d
sound65Start:
; @addr{e978d}
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
; $e97d6
sound63Start:
; @addr{e97d6}
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
; $e98a9
sound6fStart:
; @addr{e98a9}
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
; $e98d2
sound70Start:
; @addr{e98d2}
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
; $e98e1
; @addr{e98e1}
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
; $e9908
sound71Start:
; @addr{e9908}
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
; $e992f
sound72Start:
; @addr{e992f}
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
; $e9968
sound68Start:
; @addr{e9968}
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
; $e9991
sound80Start:
; @addr{e9991}
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
; $e99c2
sound81Start:
; @addr{e99c2}
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
; $e99d9
; @addr{e99d9}
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
; $e99fa
sound82Start:
; @addr{e99fa}
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
; $e9a2a
; @addr{e9a2a}
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
; $e9a43
sound7bStart:
; @addr{e9a43}
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
; $e9a6c
sound7eStart:
; @addr{e9a6c}
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
; $e9a8a
sound7cStart:
; @addr{e9a8a}
sound7cChannel2:
	duty $01
musice9a8c:
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
	goto musice9a8c
	cmdff
; $e9ad6
sound69Start:
; @addr{e9ad6}
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
; $e9b27
sound67Start:
; @addr{e9b27}
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
; $e9cbc
soundd2Start:
; @addr{e9cbc}
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
; $e9d09
soundd3Start:
; @addr{e9d09}
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
; $e9da0
; GAP
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
; @addr{e9dcc}
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
; $e9df9
; @addr{e9df9}
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
; $e9e10
sound83Start:
; @addr{e9e10}
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
; $e9e4e
sound84Start:
; @addr{e9e4e}
sound84Channel2:
	duty $02
	cmdf0 $d9
	.db $07 $a0 $03
	vol $1
	.db $07 $a0 $05
	cmdff
; $e9e5a
sound85Start:
; @addr{e9e5a}
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
; $e9e9e
sound86Start:
; @addr{e9e9e}
sound86Channel2:
	cmdff
; $e9e9f
sound8dStart:
; @addr{e9e9f}
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
; $e9f98
; GAP
	cmdff
soundd5Start:
; @addr{e9f99}
soundd5Channel2:
	cmdff
; $e9f9a
; GAP
	cmdff
soundc0Start:
; @addr{e9f9b}
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
; $e9fc5
soundbfStart:
; @addr{e9fc5}
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
; $ea132
sound92Start:
; @addr{ea132}
sound92Channel2:
	cmdff
; $ea133
sound9dStart:
; @addr{ea133}
sound9dChannel3:
	vol $0
	wait1 $f1
	cmdff
; $ea137
; @addr{ea137}
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
; $ea15c
; @addr{ea15c}
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
; $ea17b
; @addr{ea17b}
sound9dChannel7:
	cmdf0 $00
	note $00 $f1
	cmdff
; $ea180
sound9eStart:
; @addr{ea180}
sound9eChannel3:
	vol $0
	wait1 $f1
	cmdff
; $ea184
; @addr{ea184}
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
; $ea19f
; @addr{ea19f}
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
; $ea1b8
; @addr{ea1b8}
sound9eChannel7:
	cmdf0 $00
	note $00 $f1
	cmdff
; $ea1bd
sound9fStart:
; @addr{ea1bd}
sound9fChannel3:
	vol $0
	wait1 $e5
	cmdff
; $ea1c1
; @addr{ea1c1}
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
; $ea1da
; @addr{ea1da}
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
; $ea1f1
; @addr{ea1f1}
sound9fChannel7:
	cmdf0 $00
	note $00 $e5
	cmdff
; $ea1f6
sound4aStart:
; @addr{ea1f6}
sound4aChannel1:
	vol $0
	note $20 $07
	vibrato $e1
	env $0 $00
	cmdf2
	duty $02
musicea200:
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
	goto musicea200
	cmdff
; $ea425
; @addr{ea425}
sound4aChannel0:
	vol $0
	note $20 $07
	vibrato $e1
	env $0 $00
	cmdf2
	duty $02
musicea42f:
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
	goto musicea42f
	cmdff
; $ea675
; @addr{ea675}
sound4aChannel4:
	wait1 $07
	cmdf2
musicea678:
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
	goto musicea678
	cmdff
; $ea896
; @addr{ea896}
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
; $eacd1
sound33Start:
; @addr{eacd1}
sound33Channel1:
	vibrato $e1
	env $0 $00
	cmdf2
	duty $02
musiceacd8:
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
	goto musiceacd8
	cmdff
; $eae8c
; @addr{eae8c}
sound33Channel0:
	vibrato $e1
	env $0 $00
	cmdf2
	duty $02
musiceae93:
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
	goto musiceae93
	cmdff
; $eb046
; @addr{eb046}
sound33Channel4:
	cmdf2
musiceb047:
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
	goto musiceb047
	cmdff
; $eb3b1
; @addr{eb3b1}
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
; $eb755
soundceStart:
; @addr{eb755}
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
; $eb76a
; @addr{eb76a}
soundceChannel5:
	duty $08
	vibrato $00
	cmdf8 $04
	note $43 $05
	vibrato $00
	cmdf8 $ff
	note $48 $28
	cmdff
; $eb779
; @addr{eb779}
soundceChannel7:
	cmdf0 $20
	note $16 $12
	note $17 $01
	cmdf0 $20
	note $16 $14
	cmdf0 $24
	note $16 $1e
	cmdff
; $eb788
soundc1Start:
; @addr{eb788}
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
; $eb848
soundcfStart:
; @addr{eb848}
soundcfChannel2:
	cmdff
; $eb849
soundc5Start:
; @addr{eb849}
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
; $eb862
soundc8Start:
; @addr{eb862}
soundc8Channel2:
	duty $01
	vol $f
	note $3f $03
	vol $b
	env $0 $06
	note $3f $3c
	cmdff
; $eb86d
; @addr{eb86d}
soundc8Channel7:
	cmdf0 $41
	note $15 $01
	cmdff
; $eb872
soundc6Start:
; @addr{eb872}
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
; $eb889
soundc2Start:
; @addr{eb889}
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
; $eb8b5
soundc3Start:
; @addr{eb8b5}
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
; $eb8d2
soundc9Start:
; @addr{eb8d2}
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
; $ebabb
sounda9Start:
; @addr{ebabb}
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
; $ebad8
sound7aStart:
; @addr{ebad8}
sound7aChannel2:
	cmdff
; $ebad9
; GAP
	cmdff
sound8eStart:
; @addr{ebada}
sound8eChannel2:
	duty $02
	vol $d
	env $1 $00
	cmdf8 $00
	note $30 $04
	vol $c
	note $34 $04
	vol $d
	note $38 $04
	vibrato $51
	env $1 $01
	vol $b
	note $3c $14
	cmdff
; $ebaf1
sound7dStart:
; @addr{ebaf1}
sound7dChannel2:
	duty $01
	vol $a
	cmdf8 $ce
	note $19 $05
	cmdff
; $ebaf9
; @addr{ebaf9}
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
; $ebb1e
sound7fStart:
; @addr{ebb1e}
sound7fChannel2:
	duty $02
	vol $b
	note $3e $01
	vol $0
	wait1 $02
	vol $d
	note $36 $01
	vol $0
	wait1 $02
	vol $8
	note $3c $01
	vol $0
	wait1 $02
	vol $9
	note $35 $01
	cmdff
; $ebb36
soundb6Start:
; @addr{ebb36}
soundb6Channel2:
	duty $00
	cmdf8 $ba
	vol $7
	note $22 $02
	vol $8
	note $23 $02
	vol $a
	note $24 $02
	vol $c
	note $25 $02
	vol $e
	note $26 $02
	note $26 $02
	note $26 $02
	note $26 $02
	note $26 $02
	note $26 $02
	note $26 $02
	note $26 $02
	vol $c
	note $25 $02
	vol $a
	note $24 $02
	vol $8
	note $23 $02
	vol $7
	note $22 $02
	vol $6
	note $21 $02
	vol $5
	note $20 $02
	vol $4
	note $1f $02
	vol $3
	note $1e $02
	vol $2
	note $1d $02
	vol $1
	note $1c $02
	cmdff
; $ebb76
soundb5Start:
; @addr{ebb76}
soundb5Channel2:
	duty $01
	cmdf8 $fc
	vol $b
	note $27 $05
	wait1 $01
	vol $0
	note $27 $01
	cmdf8 $02
	env $0 $07
	vol $a
	note $27 $46
	env $0 $00
	vol $9
	note $34 $01
	vol $a
	note $35 $01
	vol $b
	note $36 $05
	cmdf8 $fc
	env $0 $02
	vol $b
	note $36 $17
	cmdff
; $ebb9c
soundc4Start:
; @addr{ebb9c}
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
; $ebbad
soundccStart:
; @addr{ebbad}
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
; $ebc11
soundcdStart:
; @addr{ebc11}
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
; $ebc25
; @addr{ebc25}
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
; $ebc33
; @addr{ebc33}
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
; $ebc48
sound5eStart:
; @addr{ebc48}
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
; $ebc6c
sound6aStart:
; @addr{ebc6c}
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
; $ebc7d
sound76Start:
; @addr{ebc7d}
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
; $ebc98
; @addr{ebc98}
sound76Channel7:
	cmdf0 $10
	note $26 $01
	cmdf0 $70
	note $24 $01
	cmdf0 $00
	note $36 $01
	cmdff
; $ebca5
sound75Start:
; @addr{ebca5}
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
; $ebcba
soundd1Start:
; @addr{ebcba}
soundd1Channel2:
	duty $01
	vol $2
	note $31 $02
	note $33 $02
	vol $4
	note $31 $02
	note $33 $02
	vol $6
	note $31 $02
	note $33 $02
	vol $8
	note $31 $02
	note $33 $02
	vol $a
	note $31 $02
	note $33 $02
	vol $8
	note $31 $02
	note $33 $02
	vol $6
	note $31 $02
	note $33 $02
	vol $4
	note $31 $02
	note $33 $02
	vol $2
	note $31 $02
	note $33 $02
	vol $1
	note $31 $02
	note $33 $02
	wait1 $0a
	duty $02
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
	vol $7
	note $27 $01
	vol $5
	note $1a $01
	vol $5
	note $25 $01
	vol $8
	note $28 $01
	vol $6
	note $1b $01
	vol $6
	note $26 $01
	vol $9
	note $29 $01
	vol $7
	note $1c $01
	vol $7
	note $27 $01
	vol $a
	note $2a $01
	vol $8
	note $1d $01
	vol $8
	note $28 $01
	vol $a
	note $2b $01
	vol $8
	note $1e $01
	vol $8
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
	vol $a
	note $22 $01
	vol $8
	note $15 $01
	vol $8
	note $20 $01
	vol $a
	note $23 $01
	vol $8
	note $16 $01
	vol $8
	note $21 $01
	vol $a
	note $24 $01
	vol $8
	note $17 $01
	vol $8
	note $22 $01
	vol $a
	note $25 $01
	vol $8
	note $18 $01
	vol $8
	note $23 $01
	vol $a
	note $26 $01
	vol $8
	note $19 $01
	vol $8
	note $24 $01
	vol $a
	note $27 $01
	vol $8
	note $1a $01
	vol $8
	note $25 $01
	vol $a
	note $28 $01
	vol $8
	note $1b $01
	vol $8
	note $26 $01
	vol $a
	note $29 $01
	vol $8
	note $1c $01
	vol $8
	note $27 $01
	vol $a
	note $2a $01
	vol $8
	note $1d $01
	vol $8
	note $28 $01
	vol $a
	note $2b $01
	vol $8
	note $1e $01
	vol $8
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
	vol $e
	note $31 $01
	vol $c
	note $24 $01
	vol $9
	note $2e $01
	vol $d
	note $32 $01
	vol $b
	note $25 $01
	vol $8
	note $2f $01
	vol $d
	note $33 $01
	vol $b
	note $26 $01
	vol $8
	note $30 $01
	vol $c
	note $34 $01
	vol $a
	note $27 $01
	vol $7
	note $31 $01
	vol $b
	note $35 $01
	vol $9
	note $28 $01
	vol $6
	note $32 $01
	vol $a
	note $36 $01
	vol $8
	note $29 $01
	vol $5
	note $33 $01
	vol $9
	note $37 $01
	vol $7
	note $2a $01
	vol $4
	note $34 $01
	vol $8
	note $38 $01
	vol $6
	note $2b $01
	vol $3
	note $35 $01
	vol $7
	note $39 $01
	vol $5
	note $2c $01
	vol $2
	note $36 $01
	vol $6
	note $3a $01
	vol $4
	note $2d $01
	vol $1
	note $37 $01
	vol $5
	note $3b $01
	vol $3
	note $2e $01
	vol $1
	note $38 $01
	vol $4
	note $3c $01
	vol $2
	note $2f $01
	vol $1
	note $39 $01
	vol $3
	note $3d $01
	vol $1
	note $30 $01
	vol $2
	note $3e $01
	vol $1
	note $31 $01
	vol $1
	note $3f $01
	vol $1
	note $32 $01
	vol $1
	note $40 $01
	cmdff
; $ebec1
; @addr{ebec1}
soundd1Channel3:
	duty $01
	cmdfd $ff
	vol $0
	note $20 $0d
	vol $1
	note $31 $02
	note $33 $02
	vol $2
	note $31 $02
	note $33 $02
	vol $3
	note $31 $02
	note $33 $02
	vol $5
	note $31 $02
	note $33 $02
	vol $7
	note $31 $02
	note $33 $02
	vol $5
	note $31 $02
	note $33 $02
	vol $3
	note $31 $02
	note $33 $02
	vol $2
	note $31 $02
	note $33 $02
	vol $1
	note $31 $02
	note $33 $02
	wait1 $0a
	duty $00
	env $2 $00
	cmdfd $00
	vol $5
	note $48 $0d
	vol $2
	note $48 $17
	vol $3
	note $48 $08
	vol $6
	note $48 $0c
	vol $2
	note $48 $11
	vol $4
	note $48 $16
	vol $2
	note $48 $0a
	vol $1
	note $48 $10
	wait1 $18
	cmdff
; $ebf18
; @addr{ebf18}
soundd1Channel5:
	wait1 $cc
	cmdff
; $ebf1b
; @addr{ebf1b}
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
; $ebf3a
soundd4Start:
; @addr{ebf3a}
soundd4Channel2:
	duty $02
	vol $4
	note $3f $02
	vol $2
	note $3a $01
	vol $5
	note $35 $02
	vol $5
	note $3f $02
	vol $3
	note $3a $01
	vol $6
	note $35 $02
	vol $6
	note $3f $02
	vol $4
	note $3a $01
	vol $7
	note $35 $02
	vol $7
	note $3f $02
	vol $5
	note $3a $01
	vol $8
	note $35 $02
	vol $8
	note $3f $02
	vol $6
	note $3a $01
	vol $9
	note $35 $02
	vol $9
	note $3f $02
	vol $7
	note $3a $01
	vol $a
	note $35 $02
	vol $7
	note $3f $02
	vol $5
	note $3a $01
	vol $8
	note $35 $02
	vol $5
	note $3f $02
	vol $3
	note $3a $01
	vol $6
	note $35 $02
	vol $3
	note $3f $02
	vol $1
	note $3a $01
	vol $2
	note $35 $02
	vol $1
	note $3f $02
	cmdff
; $ebf91
soundc7Start:
; @addr{ebf91}
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
; $ebfa2
sound96Start:
; @addr{ebfa2}
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
; $ebfcb
sound9aStart:
; @addr{ebfcb}
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
; $ebfdd
sound9bStart:
; @addr{ebfdd}
sound9bChannel2:
	vol $8
	env $0 $02
	note $3b $0a
	note $3d $0a
	note $3e $0a
	note $45 $0f
	cmdff
; $ebfe9
sounda6Start:
; @addr{ebfe9}
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
; $ebffe
; GAP
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
; @addr{ec000}
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
; $ec001
; @addr{ec001}
sound02Channel1:
musicec001:
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
	goto musicec001
	cmdff
; $ec174
; @addr{ec174}
sound02Channel0:
musicec174:
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
	goto musicec174
	cmdff
; $ec29a
; @addr{ec29a}
sound02Channel4:
musicec29a:
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
	goto musicec29a
	cmdff
; $ec316
sound11Start:
; @addr{ec316}
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
musicec37c:
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
	goto musicec37c
	cmdff
; $ec3e2
; @addr{ec3e2}
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
musicec44d:
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
	goto musicec44d
	cmdff
; $ec4bc
; @addr{ec4bc}
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
musicec5ac:
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
	goto musicec5ac
	cmdff
; $ec6a0
; @addr{ec6a0}
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
; $ec765
; @addr{ec765}
sound0fChannel1:
	vibrato $00
	env $0 $02
	duty $02
musicec76b:
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
	goto musicec76b
	cmdff
; $ec7b0
; @addr{ec7b0}
sound0fChannel0:
	vol $1
	note $23 $06
	vibrato $00
	env $0 $02
	duty $02
musicec7b9:
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
	goto musicec7b9
	cmdff
; $ec7fe
; @addr{ec7fe}
sound0fChannel4:
	duty $0f
	wait1 $09
musicec802:
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
	goto musicec802
	cmdff
; $ec846
; @addr{ec846}
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
musicec8a5:
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
	goto musicec8a5
	cmdff
; $ecaf8
; @addr{ecaf8}
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
musicecb5a:
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
	goto musicecb5a
	cmdff
; $ecd8d
; @addr{ecd8d}
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
musicecee1:
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
	goto musicecee1
	cmdff
; $ed513
; @addr{ed513}
sound0dChannel1:
	vibrato $00
	env $0 $03
	duty $02
musiced519:
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
	goto musiced519
	cmdff
; $ed59f
; @addr{ed59f}
sound0dChannel0:
	vibrato $00
	env $0 $03
	duty $02
	vol $1
	note $15 $09
	note $1c $04
musiced5aa:
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
	goto musiced5aa
	cmdff
; $ed630
; @addr{ed630}
sound0dChannel4:
	duty $08
	note $15 $09
	note $1c $09
	note $1f $09
musiced638:
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
	goto musiced638
	cmdff
; $ed6bc
sound34Start:
; @addr{ed6bc}
sound34Channel1:
	vibrato $00
	env $0 $00
	cmdf2
	duty $01
musiced6c3:
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
	goto musiced6c3
	cmdff
; $ed7f3
; @addr{ed7f3}
sound34Channel0:
	vibrato $00
	env $0 $00
	cmdf2
	duty $02
musiced7fa:
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
	goto musiced7fa
	cmdff
; $ed956
; @addr{ed956}
sound34Channel4:
	cmdf2
musiced957:
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
	goto musiced957
	cmdff
; $ee08b
; BACKWARD GAP
; @addr{ee08b}
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
; $ee3c1
; @addr{ee3c1}
sound04Channel1:
	vibrato $e1
	env $0 $00
	cmdf2
	duty $01
musicee3c8:
	vol $5
	note $2d $0e
	vol $3
	note $2d $0e
	vol $5
	note $28 $0e
	vol $3
	note $28 $0e
	wait1 $15
	vol $5
	note $2d $03
	wait1 $04
	note $2d $05
	wait1 $02
	note $2f $05
	wait1 $02
	note $31 $05
	wait1 $02
	note $32 $05
	wait1 $02
	note $34 $38
	vibrato $01
	vol $3
	note $34 $0e
	wait1 $04
	vibrato $e1
	vol $5
	note $34 $06
	wait1 $04
	note $34 $05
	wait1 $04
	note $35 $06
	wait1 $03
	note $37 $06
	wait1 $04
	note $39 $38
	vibrato $01
	vol $3
	note $39 $0e
	wait1 $04
	vibrato $e1
	vol $5
	note $39 $06
	wait1 $04
	note $39 $05
	wait1 $04
	note $37 $06
	wait1 $03
	note $35 $06
	wait1 $04
	note $37 $09
	wait1 $05
	vol $3
	note $37 $03
	wait1 $01
	vol $5
	note $35 $0a
	note $34 $1c
	vibrato $01
	vol $3
	note $34 $1c
	vibrato $e1
	vol $5
	note $34 $09
	note $35 $09
	note $34 $0a
	note $32 $07
	vol $3
	note $32 $07
	vol $5
	note $32 $07
	note $34 $07
	note $35 $1c
	vibrato $01
	vol $3
	note $35 $1c
	vibrato $e1
	vol $5
	note $34 $0e
	note $32 $0e
	note $30 $07
	vol $3
	note $30 $07
	vol $5
	note $30 $07
	note $32 $07
	note $34 $1c
	vibrato $01
	vol $3
	note $34 $1c
	vibrato $e1
	vol $5
	note $32 $0e
	note $30 $0e
	note $2f $07
	vol $3
	note $2f $07
	vol $5
	note $2f $07
	note $31 $07
	note $33 $1c
	vibrato $01
	vol $3
	note $33 $1c
	vibrato $e1
	vol $5
	note $36 $1c
	note $34 $0e
	note $28 $01
	wait1 $02
	note $28 $01
	wait1 $05
	note $28 $01
	wait1 $04
	note $2a $05
	wait1 $04
	note $2a $06
	wait1 $03
	note $2a $06
	wait1 $04
	note $2c $1c
	vibrato $01
	vol $3
	note $2c $1c
	vibrato $e1
	vol $5
	note $2d $0e
	vol $3
	note $2d $0e
	vol $5
	note $28 $0e
	vol $3
	note $28 $0e
	wait1 $15
	vol $5
	note $2d $03
	wait1 $04
	note $2d $05
	wait1 $02
	note $2f $05
	wait1 $02
	note $31 $05
	wait1 $02
	note $32 $05
	wait1 $02
	note $34 $38
	vibrato $01
	vol $3
	note $34 $0e
	wait1 $04
	vibrato $e1
	vol $5
	note $34 $06
	wait1 $04
	note $34 $05
	wait1 $04
	note $35 $06
	wait1 $03
	note $37 $06
	wait1 $04
	note $39 $38
	vibrato $01
	vol $3
	note $39 $0e
	wait1 $04
	vibrato $e1
	vol $5
	note $39 $06
	wait1 $04
	note $39 $05
	wait1 $04
	note $37 $06
	wait1 $03
	note $35 $06
	wait1 $04
	note $37 $07
	wait1 $03
	vol $3
	note $37 $07
	wait1 $01
	vol $5
	note $35 $0a
	note $34 $1c
	vol $3
	note $34 $0e
	wait1 $0e
	vol $5
	note $34 $09
	note $35 $09
	note $34 $0a
	note $32 $07
	vol $3
	note $32 $07
	vol $5
	note $32 $07
	note $34 $07
	note $35 $1c
	vibrato $01
	vol $3
	note $35 $1c
	vibrato $e1
	vol $5
	note $34 $0e
	note $32 $0e
	note $30 $09
	note $2f $09
	note $30 $0a
	note $32 $09
	note $30 $09
	note $32 $0a
	note $34 $07
	vol $3
	note $34 $07
	wait1 $04
	vol $5
	note $34 $04
	wait1 $06
	note $34 $09
	note $32 $09
	note $30 $0a
	note $34 $38
	note $40 $38
	note $39 $46
	wait1 $0e
	note $34 $03
	vol $3
	note $34 $04
	wait1 $02
	vol $5
	note $30 $03
	vol $3
	note $30 $04
	wait1 $02
	vol $5
	note $2d $04
	vol $3
	note $2d $03
	wait1 $03
	goto musicee3c8
	cmdff
; $ee576
; @addr{ee576}
sound04Channel0:
	vibrato $e1
	env $0 $00
	cmdf2
	duty $01
musicee57d:
	vol $5
	note $25 $0e
	vol $3
	note $25 $0e
	vol $5
	note $26 $09
	note $25 $09
	note $23 $0a
	note $25 $0e
	vol $3
	note $25 $07
	vol $5
	note $25 $07
	note $25 $05
	wait1 $02
	note $26 $05
	wait1 $02
	note $28 $05
	wait1 $02
	note $2a $05
	wait1 $02
	note $2b $15
	note $2d $05
	wait1 $02
	note $2d $05
	wait1 $02
	note $2f $05
	wait1 $02
	note $31 $05
	wait1 $02
	note $32 $05
	wait1 $02
	note $34 $07
	wait1 $03
	vol $3
	note $34 $07
	wait1 $04
	vol $2
	note $34 $07
	vol $5
	note $2b $09
	note $2d $09
	note $2f $0a
	note $30 $12
	note $29 $06
	wait1 $04
	note $29 $05
	wait1 $02
	note $2b $05
	wait1 $02
	note $2d $05
	wait1 $02
	note $2f $05
	wait1 $02
	note $30 $07
	wait1 $07
	vol $3
	note $30 $03
	wait1 $01
	vol $5
	note $30 $06
	wait1 $04
	note $30 $05
	wait1 $04
	note $2f $06
	wait1 $03
	note $2d $06
	wait1 $04
	note $30 $07
	wait1 $03
	vol $3
	note $30 $07
	wait1 $01
	vol $5
	note $2b $06
	wait1 $04
	note $2b $05
	wait1 $04
	note $2b $06
	wait1 $03
	note $29 $06
	wait1 $04
	note $2b $05
	wait1 $05
	vol $3
	note $2b $06
	wait1 $02
	vol $5
	note $2b $06
	wait1 $04
	note $2b $05
	wait1 $04
	note $29 $06
	wait1 $03
	note $2b $06
	wait1 $04
	note $29 $0b
	wait1 $03
	note $29 $07
	note $28 $07
	note $29 $0b
	wait1 $03
	note $29 $07
	note $2b $07
	note $2d $1c
	note $2b $0e
	note $29 $0e
	note $28 $0b
	wait1 $03
	note $28 $07
	note $26 $07
	note $28 $0b
	wait1 $03
	note $28 $07
	note $29 $07
	note $2b $1c
	note $29 $0e
	note $28 $0e
	note $27 $15
	wait1 $07
	note $27 $07
	wait1 $03
	vol $3
	note $27 $04
	vol $5
	note $27 $07
	note $28 $07
	note $2a $07
	wait1 $03
	vol $3
	note $2a $04
	vol $5
	note $2a $07
	note $2b $07
	note $2d $07
	note $2f $07
	note $31 $07
	note $32 $07
	note $2f $1c
	note $26 $05
	wait1 $04
	note $26 $06
	wait1 $03
	note $26 $06
	wait1 $04
	note $28 $1c
	vibrato $01
	vol $3
	note $28 $1c
	vibrato $e1
	vol $5
	note $25 $0e
	vol $3
	note $25 $0e
	vol $5
	note $26 $09
	note $25 $09
	note $23 $0a
	note $25 $0e
	vol $3
	note $25 $07
	vol $5
	note $25 $07
	note $25 $05
	wait1 $02
	note $26 $05
	wait1 $02
	note $28 $05
	wait1 $02
	note $2a $05
	wait1 $02
	note $2b $15
	note $2d $05
	wait1 $02
	note $2d $05
	wait1 $02
	note $2f $05
	wait1 $02
	note $31 $05
	wait1 $02
	note $32 $05
	wait1 $02
	note $34 $1c
	note $2b $09
	note $2d $09
	note $2f $0a
	note $30 $12
	note $29 $06
	wait1 $04
	note $29 $05
	wait1 $02
	note $2b $05
	wait1 $02
	note $2d $05
	wait1 $02
	note $2f $05
	wait1 $02
	note $30 $07
	wait1 $03
	vol $3
	note $30 $07
	wait1 $01
	vol $5
	note $30 $06
	wait1 $04
	note $30 $05
	wait1 $04
	note $2f $06
	wait1 $03
	note $2d $06
	wait1 $04
	note $30 $07
	wait1 $03
	vol $3
	note $30 $07
	wait1 $01
	vol $5
	note $2b $06
	wait1 $04
	note $2b $05
	wait1 $04
	note $2b $06
	wait1 $03
	note $29 $06
	wait1 $04
	note $2b $05
	wait1 $05
	vol $3
	note $2b $06
	wait1 $02
	vol $5
	note $2b $06
	wait1 $04
	note $2b $05
	wait1 $04
	note $29 $06
	wait1 $03
	note $2b $06
	wait1 $04
	note $29 $0b
	wait1 $03
	note $29 $07
	note $28 $07
	note $29 $0b
	wait1 $03
	note $29 $07
	note $2b $07
	note $2d $1c
	note $2b $0e
	note $29 $0e
	note $21 $1c
	note $20 $1c
	note $1f $38
	note $1e $1c
	note $1a $1c
	note $1c $15
	wait1 $07
	vol $8
	note $1c $04
	wait1 $05
	note $28 $05
	wait1 $04
	note $26 $05
	wait1 $05
	note $24 $04
	wait1 $05
	note $23 $05
	wait1 $04
	note $21 $05
	wait1 $05
	note $23 $04
	wait1 $06
	vol $5
	note $23 $05
	wait1 $06
	vol $3
	note $23 $04
	wait1 $03
	vol $8
	note $21 $04
	wait1 $06
	vol $5
	note $21 $05
	wait1 $06
	vol $3
	note $21 $04
	wait1 $1f
	goto musicee57d
	cmdff
; $ee79b
; @addr{ee79b}
sound04Channel4:
musicee79b:
	duty $0e
	note $15 $04
	duty $0f
	note $15 $04
	wait1 $14
	duty $0e
	note $15 $04
	duty $0f
	note $15 $04
	wait1 $14
	duty $0e
	note $15 $04
	duty $0f
	note $15 $04
	wait1 $14
	duty $0e
	note $15 $04
	duty $0f
	note $15 $04
	wait1 $14
	duty $0e
	note $13 $04
	duty $0f
	note $13 $04
	wait1 $14
	duty $0e
	note $13 $04
	duty $0f
	note $13 $04
	wait1 $14
	duty $0e
	note $13 $04
	duty $0f
	note $13 $04
	wait1 $14
	duty $0e
	note $13 $04
	duty $0f
	note $13 $04
	wait1 $14
	duty $0e
	note $11 $04
	duty $0f
	note $11 $04
	wait1 $14
	duty $0e
	note $11 $04
	duty $0f
	note $11 $04
	wait1 $14
	duty $0e
	note $11 $04
	duty $0f
	note $11 $04
	wait1 $14
	duty $0e
	note $11 $04
	duty $0f
	note $11 $04
	wait1 $14
	duty $0e
	note $18 $04
	duty $0f
	note $18 $04
	wait1 $14
	duty $0e
	note $18 $04
	duty $0f
	note $18 $04
	wait1 $14
	duty $0e
	note $18 $04
	duty $0f
	note $18 $04
	wait1 $14
	duty $0e
	note $18 $04
	duty $0f
	note $18 $04
	wait1 $14
	duty $0e
	note $16 $04
	duty $0f
	note $16 $04
	wait1 $14
	duty $0e
	note $16 $04
	duty $0f
	note $16 $04
	wait1 $14
	duty $0e
	note $16 $04
	duty $0f
	note $16 $04
	wait1 $14
	duty $0e
	note $16 $04
	duty $0f
	note $16 $04
	wait1 $14
	duty $0e
	note $15 $04
	duty $0f
	note $15 $04
	wait1 $14
	duty $0e
	note $15 $04
	duty $0f
	note $15 $04
	wait1 $14
	duty $0e
	note $15 $04
	duty $0f
	note $15 $04
	wait1 $14
	duty $0e
	note $15 $04
	duty $0f
	note $15 $04
	wait1 $14
	duty $0e
	note $17 $04
	duty $0f
	note $17 $04
	wait1 $14
	duty $0e
	note $17 $04
	duty $0f
	note $17 $04
	wait1 $14
	duty $0e
	note $17 $04
	duty $0f
	note $17 $04
	wait1 $14
	duty $0e
	note $17 $04
	duty $0f
	note $17 $04
	wait1 $14
	duty $0e
	note $1c $04
	duty $0f
	note $1c $04
	wait1 $14
	duty $0e
	note $21 $04
	duty $0f
	note $21 $04
	wait1 $14
	duty $0e
	note $23 $1c
	note $1e $04
	duty $0f
	note $1e $04
	wait1 $06
	duty $0e
	note $20 $04
	duty $0f
	note $20 $04
	wait1 $06
	duty $0e
	note $15 $04
	duty $0f
	note $15 $04
	wait1 $14
	duty $0e
	note $15 $04
	duty $0f
	note $15 $04
	wait1 $14
	duty $0e
	note $15 $04
	duty $0f
	note $15 $04
	wait1 $14
	duty $0e
	note $15 $04
	duty $0f
	note $15 $04
	wait1 $14
	duty $0e
	note $13 $04
	duty $0f
	note $13 $04
	wait1 $14
	duty $0e
	note $13 $04
	duty $0f
	note $13 $04
	wait1 $14
	duty $0e
	note $13 $04
	duty $0f
	note $13 $04
	wait1 $14
	duty $0e
	note $13 $04
	duty $0f
	note $13 $04
	wait1 $14
	duty $0e
	note $11 $04
	duty $0f
	note $11 $04
	wait1 $14
	duty $0e
	note $11 $04
	duty $0f
	note $11 $04
	wait1 $14
	duty $0e
	note $11 $04
	duty $0f
	note $11 $04
	wait1 $14
	duty $0e
	note $11 $04
	duty $0f
	note $11 $04
	wait1 $14
	duty $0e
	note $18 $04
	duty $0f
	note $18 $04
	wait1 $14
	duty $0e
	note $18 $04
	duty $0f
	note $18 $04
	wait1 $14
	duty $0e
	note $18 $04
	duty $0f
	note $18 $04
	wait1 $14
	duty $0e
	note $18 $04
	duty $0f
	note $18 $04
	wait1 $14
	duty $0e
	note $16 $04
	duty $0f
	note $16 $04
	wait1 $14
	duty $0e
	note $16 $04
	duty $0f
	note $16 $04
	wait1 $14
	duty $0e
	note $16 $04
	duty $0f
	note $16 $04
	wait1 $14
	duty $0e
	note $16 $04
	duty $0f
	note $16 $04
	wait1 $14
	duty $17
	note $28 $09
	note $27 $09
	note $28 $0a
	note $2c $09
	note $2d $09
	note $2f $0a
	note $30 $09
	wait1 $09
	note $30 $0a
	note $30 $09
	note $2f $09
	note $2d $0a
	note $34 $0e
	wait1 $04
	note $30 $0e
	wait1 $05
	note $2d $13
	note $2c $12
	wait1 $0a
	note $2c $09
	note $2a $09
	note $2c $0a
	note $2d $09
	note $2f $09
	note $30 $0a
	note $32 $09
	note $30 $09
	note $2f $0a
	note $30 $1c
	wait1 $1c
	goto musicee79b
	cmdff
; $ee9e7
; @addr{ee9e7}
sound08Channel1:
	vibrato $e1
	env $0 $00
	cmdf2
musicee9ec:
	vol $6
	note $3e $24
	note $39 $24
	vibrato $01
	vol $4
	note $39 $12
	vibrato $e1
	vol $6
	note $37 $12
	note $39 $51
	vibrato $01
	vol $4
	note $39 $12
	wait1 $09
	vibrato $e1
	vol $6
	note $3e $24
	note $39 $24
	vibrato $01
	vol $4
	note $39 $12
	vibrato $e1
	vol $6
	note $37 $12
	note $39 $36
	vibrato $01
	vol $4
	note $39 $12
	vibrato $e1
	vol $6
	note $32 $24
	note $33 $24
	note $37 $24
	note $3a $24
	note $39 $3f
	vibrato $01
	vol $4
	note $39 $24
	wait1 $09
	vibrato $e1
	vol $6
	note $39 $24
	note $37 $24
	note $35 $24
	note $37 $3f
	vibrato $01
	vol $4
	note $37 $1e
	wait1 $0f
	vibrato $e1
	goto musicee9ec
	cmdff
; $eea48
; @addr{eea48}
sound08Channel0:
musiceea48:
	vibrato $00
	env $0 $05
	vol $0
	note $20 $12
	vol $6
	note $2b $06
	wait1 $0c
	note $2e $06
	wait1 $03
	vol $4
	note $2b $06
	wait1 $03
	vol $6
	note $32 $06
	wait1 $03
	vol $4
	note $2e $06
	wait1 $03
	vol $6
	note $37 $06
	wait1 $03
	vol $4
	note $32 $06
	wait1 $0c
	vol $4
	note $37 $06
	wait1 $15
	vol $6
	note $26 $06
	wait1 $0c
	note $29 $06
	wait1 $03
	vol $4
	note $26 $06
	wait1 $03
	vol $6
	note $2d $06
	wait1 $03
	vol $4
	note $29 $06
	wait1 $03
	vol $6
	note $32 $06
	wait1 $03
	vol $4
	note $2d $06
	wait1 $0c
	vol $4
	note $32 $06
	wait1 $15
	vol $6
	note $2b $06
	wait1 $0c
	note $2e $06
	wait1 $03
	vol $4
	note $2b $06
	wait1 $03
	vol $6
	note $32 $06
	wait1 $03
	vol $4
	note $2e $06
	wait1 $03
	vol $6
	note $37 $06
	wait1 $03
	vol $4
	note $32 $06
	wait1 $0c
	vol $4
	note $37 $06
	wait1 $15
	vol $6
	note $26 $06
	wait1 $0c
	note $29 $06
	wait1 $03
	vol $4
	note $26 $06
	wait1 $03
	vol $6
	note $2d $06
	wait1 $03
	vol $4
	note $29 $06
	wait1 $03
	vol $6
	note $32 $06
	wait1 $03
	vol $4
	note $2d $06
	wait1 $0c
	vol $4
	note $32 $06
	wait1 $03
	vol $6
	note $24 $06
	wait1 $0c
	note $27 $06
	wait1 $03
	vol $4
	note $24 $06
	wait1 $03
	vol $6
	note $2b $06
	wait1 $03
	vol $4
	note $27 $06
	wait1 $03
	vol $6
	note $30 $06
	wait1 $03
	vol $4
	note $2b $06
	wait1 $0c
	vol $4
	note $30 $06
	wait1 $15
	vol $6
	note $26 $06
	wait1 $0c
	note $29 $06
	wait1 $03
	vol $4
	note $26 $06
	wait1 $03
	vol $6
	note $2d $06
	wait1 $03
	vol $4
	note $29 $06
	wait1 $03
	vol $6
	note $32 $06
	wait1 $03
	vol $4
	note $2d $06
	wait1 $0c
	vol $4
	note $32 $06
	wait1 $15
	env $0 $00
	vol $6
	note $32 $24
	note $30 $24
	note $30 $24
	note $32 $3f
	vol $3
	note $32 $1e
	wait1 $0f
	goto musiceea48
	cmdff
; $eeb4d
; @addr{eeb4d}
sound08Channel4:
musiceeb4d:
	duty $0f
	wait1 $16
	note $3e $24
	note $39 $36
	note $37 $12
	note $39 $51
	wait1 $1b
	note $3e $24
	note $39 $36
	note $37 $12
	note $39 $48
	note $32 $24
	note $33 $24
	note $37 $24
	note $3a $24
	note $39 $56
	wait1 $48
	duty $2c
	note $2d $24
	duty $0f
	note $2e $6c
	goto musiceeb4d
	cmdff
; $eeb7b
sound05Start:
; @addr{eeb7b}
sound05Channel1:
	vibrato $e1
	env $0 $00
	cmdf2
	duty $02
musiceeb82:
	vol $6
	note $27 $1b
	vol $6
	note $28 $09
	note $24 $09
	wait1 $04
	vol $4
	note $24 $05
	vol $6
	note $1f $09
	wait1 $04
	vol $4
	note $1f $05
	vol $6
	note $22 $09
	wait1 $04
	vol $4
	note $22 $05
	vol $6
	note $22 $09
	wait1 $04
	vol $4
	note $22 $05
	vol $6
	note $21 $09
	wait1 $04
	vol $4
	note $21 $05
	vol $6
	note $1f $09
	wait1 $04
	vol $4
	note $1f $05
	vol $6
	note $1e $12
	note $1f $09
	wait1 $04
	vol $4
	note $1f $09
	wait1 $05
	vol $2
	note $1f $09
	vol $6
	note $1e $12
	note $1f $09
	wait1 $04
	vol $4
	note $1f $09
	wait1 $05
	vol $2
	note $1f $09
	wait1 $12
	vol $6
	note $27 $2d
	note $28 $09
	note $24 $09
	wait1 $04
	vol $4
	note $24 $05
	vol $6
	note $1f $09
	wait1 $04
	vol $4
	note $1f $05
	vol $6
	note $22 $09
	wait1 $04
	vol $4
	note $22 $05
	vol $6
	note $22 $09
	wait1 $04
	vol $4
	note $22 $05
	vol $6
	note $24 $09
	wait1 $04
	vol $4
	note $24 $05
	vol $6
	note $26 $09
	wait1 $04
	vol $4
	note $26 $05
	vol $6
	note $29 $12
	note $28 $09
	wait1 $04
	vol $4
	note $28 $05
	vol $6
	note $27 $09
	wait1 $04
	vol $4
	note $27 $05
	vol $6
	note $26 $09
	wait1 $04
	vol $4
	note $26 $09
	wait1 $05
	vol $2
	note $26 $09
	wait1 $24
	vol $6
	note $29 $1b
	vol $4
	note $29 $09
	vol $6
	note $29 $09
	wait1 $04
	vol $4
	note $29 $05
	vol $6
	note $28 $09
	wait1 $04
	vol $4
	note $28 $05
	vol $6
	note $26 $09
	wait1 $04
	vol $4
	note $26 $05
	wait1 $36
	vol $6
	note $27 $1b
	vol $4
	note $27 $09
	vol $6
	note $27 $09
	wait1 $04
	vol $4
	note $27 $05
	vol $6
	note $26 $09
	wait1 $04
	vol $4
	note $26 $05
	vol $6
	note $24 $09
	wait1 $04
	vol $4
	note $24 $09
	wait1 $05
	vol $2
	note $24 $09
	wait1 $24
	vol $6
	note $2e $1b
	vol $4
	note $2e $09
	vol $6
	note $2e $12
	note $2d $09
	wait1 $04
	vol $4
	note $2d $09
	wait1 $05
	vol $2
	note $2d $09
	vol $6
	note $2c $12
	note $2b $09
	wait1 $04
	vol $4
	note $2b $09
	wait1 $05
	vol $2
	note $2b $09
	vol $6
	note $2a $09
	wait1 $04
	vol $4
	note $2a $05
	vol $6
	note $2a $04
	wait1 $0e
	note $2b $09
	wait1 $04
	vol $4
	note $2b $05
	vol $6
	note $2a $12
	note $2b $09
	wait1 $04
	vol $4
	note $2b $05
	vol $6
	note $27 $12
	note $24 $12
	note $22 $12
	note $1f $12
	vol $6
	note $1e $12
	note $1f $09
	wait1 $04
	vol $4
	note $1f $09
	wait1 $05
	vol $2
	note $1f $09
	vol $6
	note $1e $12
	note $1f $09
	wait1 $04
	vol $4
	note $1f $09
	wait1 $05
	vol $2
	note $1f $09
	wait1 $b4
	goto musiceeb82
	cmdff
; $eece0
; @addr{eece0}
sound05Channel0:
	vibrato $e1
	env $0 $00
	cmdf2
	duty $02
musiceece7:
	vol $6
	note $1f $24
	vol $6
	note $21 $24
	note $1e $24
	note $1f $24
	note $27 $12
	note $28 $09
	wait1 $04
	vol $4
	note $28 $05
	vol $6
	note $37 $03
	wait1 $01
	vol $4
	note $37 $03
	wait1 $02
	vol $2
	note $37 $03
	wait1 $06
	vol $6
	note $27 $12
	note $28 $09
	wait1 $04
	vol $4
	note $28 $05
	vol $6
	note $37 $03
	wait1 $01
	vol $4
	note $37 $03
	wait1 $02
	vol $2
	note $37 $03
	wait1 $06
	vol $6
	note $22 $09
	note $21 $09
	note $20 $09
	note $1f $09
	note $1c $24
	note $1f $24
	note $1b $24
	note $1c $24
	note $1a $24
	note $21 $12
	note $22 $12
	vol $6
	note $3e $03
	wait1 $03
	vol $5
	note $3e $03
	wait1 $03
	vol $4
	note $3e $03
	wait1 $03
	vol $6
	note $37 $03
	wait1 $03
	vol $5
	note $37 $03
	wait1 $03
	vol $4
	note $37 $03
	wait1 $03
	vol $6
	note $2f $09
	note $2e $09
	note $2d $09
	note $2b $09
	wait1 $36
	note $35 $1b
	vol $4
	note $35 $09
	vol $6
	note $35 $09
	wait1 $04
	vol $4
	note $35 $05
	vol $6
	note $34 $09
	wait1 $04
	vol $4
	note $34 $05
	vol $6
	note $32 $09
	wait1 $04
	vol $4
	note $32 $09
	wait1 $05
	vol $2
	note $32 $09
	wait1 $33
	vol $6
	note $33 $03
	note $34 $12
	note $37 $09
	wait1 $04
	vol $4
	note $37 $05
	vol $6
	note $39 $09
	note $37 $09
	note $33 $09
	note $30 $09
	wait1 $12
	note $37 $12
	note $36 $09
	wait1 $04
	vol $4
	note $36 $09
	wait1 $05
	vol $2
	note $36 $09
	vol $6
	note $35 $12
	note $34 $09
	wait1 $04
	vol $4
	note $34 $09
	wait1 $05
	vol $2
	note $34 $09
	vol $6
	note $33 $09
	wait1 $04
	vol $4
	note $33 $05
	vol $6
	note $31 $12
	note $32 $09
	wait1 $04
	vol $4
	note $32 $05
	vol $6
	note $31 $12
	note $32 $09
	wait1 $04
	vol $4
	note $32 $05
	vol $6
	note $24 $12
	note $1f $12
	note $1d $12
	note $1a $12
	note $17 $12
	note $18 $09
	wait1 $04
	vol $4
	note $18 $09
	wait1 $05
	vol $2
	note $18 $09
	vol $6
	note $17 $12
	vol $7
	note $18 $09
	wait1 $04
	vol $4
	note $18 $09
	wait1 $05
	vol $2
	note $18 $09
	wait1 $b4
	goto musiceece7
	cmdff
; $eee03
; @addr{eee03}
sound05Channel4:
musiceee03:
	duty $0e
	note $18 $09
	duty $0f
	note $18 $09
	wait1 $12
	duty $0e
	note $1b $09
	duty $0f
	note $1b $09
	duty $0e
	note $1c $09
	duty $0f
	note $1c $09
	duty $0e
	note $13 $09
	duty $0f
	note $13 $09
	wait1 $12
	duty $0e
	note $16 $09
	duty $0f
	note $16 $09
	duty $0e
	note $16 $09
	duty $0f
	note $16 $09
	duty $0e
	note $18 $09
	duty $0f
	note $18 $09
	wait1 $12
	duty $0e
	note $1b $12
	note $1c $09
	duty $0f
	note $1c $09
	duty $0e
	note $13 $09
	duty $0f
	note $13 $09
	wait1 $12
	duty $0e
	note $13 $09
	duty $0f
	note $13 $09
	duty $0e
	note $16 $09
	duty $0f
	note $16 $09
	duty $0e
	note $18 $12
	duty $0f
	note $18 $12
	duty $0e
	note $1b $09
	duty $0f
	note $1b $09
	duty $0e
	note $1c $09
	duty $0f
	note $1c $09
	duty $0e
	note $18 $09
	duty $0f
	note $18 $09
	wait1 $12
	duty $0e
	note $18 $09
	duty $0f
	note $18 $09
	duty $0e
	note $18 $09
	duty $0f
	note $18 $09
	duty $0e
	note $13 $1b
	duty $0f
	note $13 $09
	duty $0e
	note $19 $09
	duty $0f
	note $19 $09
	duty $0e
	note $1a $09
	duty $0f
	note $1a $09
	duty $0e
	note $17 $09
	note $16 $09
	note $15 $09
	note $14 $09
	note $13 $09
	duty $0f
	note $13 $09
	duty $0e
	note $13 $09
	duty $0f
	note $13 $09
	duty $0e
	note $11 $1b
	duty $0f
	note $11 $09
	duty $0e
	note $15 $09
	duty $0f
	note $15 $09
	duty $0e
	note $18 $09
	duty $0f
	note $18 $09
	duty $0e
	note $11 $1b
	duty $0f
	note $11 $09
	duty $0e
	note $11 $09
	duty $0f
	note $11 $09
	duty $0e
	note $11 $09
	duty $0f
	note $11 $09
	duty $0e
	note $18 $1b
	duty $0f
	note $18 $09
	duty $0e
	note $1b $09
	duty $0f
	note $1b $09
	duty $0e
	note $1c $09
	duty $0f
	note $1c $09
	duty $0e
	note $18 $1b
	duty $0f
	note $18 $09
	duty $0e
	note $18 $09
	duty $0f
	note $18 $09
	duty $0e
	note $18 $09
	duty $0f
	note $18 $09
	duty $0e
	note $13 $12
	duty $0f
	note $13 $12
	duty $0e
	note $13 $09
	duty $0f
	note $13 $09
	duty $0e
	note $13 $09
	duty $0f
	note $13 $09
	duty $0e
	note $1a $1b
	duty $0f
	note $1a $09
	duty $0e
	note $13 $09
	duty $0f
	note $13 $09
	duty $0e
	note $13 $09
	duty $0f
	note $13 $09
	wait1 $12
	duty $0e
	note $1f $09
	duty $0f
	note $1f $09
	duty $0e
	note $1e $09
	duty $0f
	note $1e $09
	duty $0e
	note $1d $09
	duty $0f
	note $1d $09
	duty $0e
	note $1c $09
	duty $0f
	note $1c $09
	duty $0e
	note $1b $09
	duty $0f
	note $1b $09
	duty $0e
	note $1a $09
	duty $0f
	note $1a $09
	duty $0e
	note $19 $09
	duty $0f
	note $19 $09
	duty $0e
	note $0c $09
	duty $0f
	note $0c $09
	wait1 $12
	duty $0e
	note $1b $09
	duty $0f
	note $1b $09
	duty $0e
	note $1c $09
	duty $0f
	note $1c $09
	duty $0e
	note $13 $09
	duty $0f
	note $13 $09
	wait1 $12
	duty $0e
	note $16 $09
	duty $0f
	note $16 $09
	duty $0e
	note $16 $09
	duty $0f
	note $16 $09
	duty $0e
	note $0c $09
	duty $0f
	note $0c $09
	wait1 $12
	duty $0e
	note $1b $12
	note $1c $09
	duty $0f
	note $1c $09
	duty $0e
	note $18 $09
	duty $0f
	note $18 $09
	duty $0e
	note $13 $09
	duty $0f
	note $13 $09
	duty $0e
	note $13 $09
	duty $0f
	note $13 $09
	duty $0e
	note $16 $09
	duty $0f
	note $16 $09
	goto musiceee03
	cmdff
; $eeffd
; @addr{eeffd}
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
; $ef072
; @addr{ef072}
sound0aChannel1:
	vibrato $e1
	env $0 $00
	cmdf2
	duty $02
musicef079:
	vol $6
	note $37 $24
	vol $6
	note $3c $24
	note $39 $24
	wait1 $12
	note $3b $09
	note $3c $09
	note $3b $12
	note $39 $09
	wait1 $03
	vol $3
	note $39 $03
	wait1 $03
	vol $6
	note $37 $09
	wait1 $03
	vol $3
	note $37 $03
	wait1 $03
	vol $6
	note $35 $09
	wait1 $03
	vol $3
	note $35 $03
	wait1 $03
	vol $6
	note $34 $12
	note $35 $09
	wait1 $03
	vol $3
	note $35 $03
	wait1 $03
	vol $6
	note $37 $09
	vol $3
	note $37 $09
	wait1 $12
	vol $6
	note $39 $12
	note $40 $09
	wait1 $09
	note $40 $09
	wait1 $03
	vol $5
	note $40 $03
	wait1 $06
	vol $3
	note $40 $03
	wait1 $06
	vol $2
	note $40 $03
	wait1 $27
	vol $6
	note $3e $09
	note $3c $09
	note $3b $09
	note $39 $09
	note $37 $12
	note $39 $09
	wait1 $03
	vol $3
	note $39 $03
	wait1 $03
	vol $6
	note $37 $09
	wait1 $09
	note $39 $09
	wait1 $03
	vol $3
	note $39 $03
	wait1 $03
	vol $6
	note $37 $12
	vol $3
	note $37 $09
	wait1 $09
	vol $6
	note $35 $12
	note $37 $12
	note $39 $24
	note $35 $24
	note $3b $24
	vibrato $01
	vol $3
	note $3b $09
	wait1 $09
	vibrato $e1
	vol $6
	note $39 $12
	note $37 $24
	note $34 $12
	note $37 $12
	note $3c $24
	wait1 $12
	note $39 $09
	note $37 $09
	note $36 $12
	note $37 $12
	note $39 $12
	note $3b $12
	vol $6
	note $3c $12
	vol $6
	note $3b $12
	note $3c $12
	note $39 $12
	note $3e $09
	wait1 $03
	vol $5
	note $3e $03
	wait1 $03
	vol $3
	note $3e $03
	wait1 $03
	vol $2
	note $3e $03
	wait1 $09
	vol $6
	note $37 $09
	wait1 $03
	vol $3
	note $37 $03
	wait1 $03
	vol $6
	note $3b $09
	vol $6
	note $39 $09
	note $37 $24
	vibrato $01
	vol $3
	note $37 $0f
	wait1 $03
	vibrato $e1
	vol $6
	note $37 $09
	wait1 $09
	goto musicef079
	cmdff
; $ef16c
; @addr{ef16c}
sound0aChannel0:
	vibrato $00
	env $0 $00
	cmdf2
	duty $02
musicef173:
	vol $6
	note $28 $15
	vol $3
	note $28 $09
	wait1 $06
	vol $6
	note $24 $15
	vol $3
	note $24 $09
	wait1 $06
	vol $6
	note $29 $15
	vol $3
	note $29 $09
	wait1 $06
	vol $6
	note $26 $18
	vol $3
	note $26 $09
	wait1 $03
	vol $6
	note $2b $12
	note $29 $09
	wait1 $03
	vol $3
	note $29 $03
	wait1 $03
	vol $6
	note $28 $09
	wait1 $03
	vol $3
	note $28 $03
	wait1 $03
	vol $6
	note $26 $09
	wait1 $03
	vol $3
	note $26 $03
	wait1 $03
	vol $6
	note $24 $12
	note $26 $09
	wait1 $03
	vol $3
	note $26 $03
	wait1 $03
	vol $6
	note $28 $09
	wait1 $03
	vol $3
	note $28 $03
	wait1 $03
	vol $2
	note $28 $03
	wait1 $0f
	vol $6
	note $29 $15
	vol $3
	note $29 $09
	wait1 $06
	vol $6
	note $26 $15
	vol $3
	note $26 $09
	wait1 $06
	vol $6
	note $2a $15
	vol $3
	note $2a $09
	wait1 $06
	vol $6
	note $26 $15
	vol $3
	note $26 $09
	wait1 $06
	vol $6
	note $23 $12
	note $24 $09
	wait1 $03
	vol $3
	note $24 $03
	wait1 $03
	vol $6
	note $23 $09
	wait1 $03
	vol $3
	note $23 $03
	wait1 $03
	vol $6
	note $26 $09
	wait1 $03
	vol $3
	note $26 $03
	wait1 $03
	vol $6
	note $2b $09
	wait1 $03
	vol $3
	note $2b $03
	wait1 $03
	vol $6
	note $26 $09
	wait1 $03
	vol $3
	note $26 $03
	wait1 $03
	vol $6
	note $23 $09
	wait1 $03
	vol $3
	note $23 $03
	wait1 $15
	vol $6
	note $29 $15
	vol $3
	note $29 $09
	wait1 $06
	vol $6
	note $26 $15
	vol $3
	note $26 $09
	wait1 $06
	vol $6
	note $2b $15
	vol $3
	note $2b $09
	wait1 $06
	vol $6
	note $29 $15
	vol $3
	note $29 $09
	wait1 $06
	vol $6
	note $28 $15
	vol $3
	note $28 $09
	wait1 $06
	vol $6
	note $26 $15
	vol $3
	note $26 $09
	wait1 $06
	vol $6
	note $24 $15
	vol $3
	note $24 $09
	wait1 $06
	vol $6
	note $23 $15
	vol $3
	note $23 $09
	wait1 $06
	vol $6
	note $21 $12
	note $26 $09
	wait1 $09
	note $26 $09
	wait1 $03
	vol $4
	note $26 $03
	wait1 $03
	vol $3
	note $26 $03
	wait1 $0f
	vol $6
	note $24 $12
	note $26 $09
	wait1 $09
	note $26 $09
	wait1 $03
	vol $4
	note $26 $03
	wait1 $03
	vol $3
	note $26 $03
	wait1 $0f
	vol $6
	note $23 $12
	vol $3
	note $23 $12
	vol $6
	note $2b $12
	vol $3
	note $2b $12
	vol $6
	note $2b $12
	note $29 $12
	note $28 $12
	note $26 $12
	goto musicef173
	cmdff
; $ef2af
; @addr{ef2af}
sound0aChannel4:
	cmdf2
musicef2b0:
	wait1 $0d
	duty $2b
	note $37 $24
	duty $2b
	note $3c $24
	note $39 $24
	wait1 $12
	note $3b $09
	note $3c $09
	note $3b $12
	note $39 $09
	wait1 $03
	duty $2c
	note $39 $03
	wait1 $03
	duty $2b
	note $37 $09
	wait1 $03
	duty $2c
	note $37 $03
	wait1 $03
	duty $2b
	note $35 $09
	wait1 $03
	duty $2c
	note $35 $03
	wait1 $03
	duty $2b
	note $34 $12
	note $35 $09
	wait1 $03
	duty $2c
	note $35 $03
	wait1 $03
	duty $2b
	note $37 $09
	duty $2c
	note $37 $09
	wait1 $12
	duty $2b
	note $39 $12
	note $40 $09
	wait1 $09
	note $40 $09
	wait1 $03
	vol $3
	note $40 $03
	wait1 $06
	duty $2c
	note $40 $03
	wait1 $06
	duty $2c
	note $40 $03
	wait1 $27
	duty $2b
	note $3e $09
	note $3c $09
	note $3b $09
	note $39 $09
	note $37 $12
	note $39 $09
	wait1 $03
	duty $2c
	note $39 $03
	wait1 $03
	duty $2b
	note $37 $09
	wait1 $09
	note $39 $09
	wait1 $03
	duty $2c
	note $39 $03
	wait1 $03
	duty $2b
	note $37 $12
	duty $2c
	note $37 $09
	wait1 $09
	duty $2b
	note $35 $12
	note $37 $12
	note $39 $24
	note $35 $24
	note $3b $24
	duty $2c
	note $3b $09
	wait1 $09
	duty $2b
	note $39 $12
	note $37 $24
	note $34 $12
	note $37 $12
	note $3c $24
	wait1 $12
	note $39 $09
	note $37 $09
	note $36 $12
	note $37 $12
	note $39 $12
	note $3b $12
	duty $2b
	note $3c $12
	duty $2b
	note $3b $12
	note $3c $12
	note $39 $12
	note $3e $09
	wait1 $03
	vol $3
	note $3e $03
	wait1 $03
	duty $2c
	note $3e $03
	wait1 $03
	duty $2c
	note $3e $03
	wait1 $09
	duty $2b
	note $37 $09
	wait1 $03
	duty $2c
	note $37 $03
	wait1 $03
	duty $2b
	note $3b $09
	duty $2b
	note $39 $09
	note $37 $24
	duty $2c
	note $37 $0f
	wait1 $03
	duty $2b
	note $37 $05
	goto musicef2b0
	cmdff
; $ef3bc
; @addr{ef3bc}
sound0bChannel1:
	cmdf2
	vibrato $e1
	env $0 $00
	duty $01
musicef3c3:
	vol $6
	note $37 $2c
	vol $6
	note $3c $2c
	note $39 $2c
	vibrato $01
	vol $3
	note $39 $16
	vibrato $e1
	vol $6
	note $3b $0b
	note $3c $0b
	note $3b $16
	note $39 $0b
	wait1 $05
	vol $3
	note $39 $06
	vol $6
	note $37 $0b
	wait1 $05
	vol $3
	note $37 $06
	vol $6
	note $35 $0b
	wait1 $05
	vol $3
	note $35 $06
	vol $6
	note $34 $16
	note $35 $0b
	wait1 $05
	vol $3
	note $35 $06
	vol $6
	note $37 $0b
	wait1 $05
	vol $3
	note $37 $0b
	wait1 $06
	vol $1
	note $37 $0b
	vol $6
	note $39 $16
	note $40 $0b
	wait1 $05
	vol $3
	note $40 $06
	vol $6
	note $40 $0b
	wait1 $05
	vol $3
	note $40 $0b
	wait1 $06
	vol $1
	note $40 $0b
	wait1 $2c
	vol $6
	note $3e $0b
	note $3c $0b
	note $3b $0b
	note $39 $0b
	note $37 $16
	note $39 $0b
	wait1 $05
	vol $3
	note $39 $06
	vol $6
	note $37 $0b
	wait1 $0b
	note $39 $0b
	wait1 $05
	vol $3
	note $39 $06
	vol $6
	note $37 $16
	vol $3
	note $37 $0b
	wait1 $0b
	vol $6
	note $35 $16
	note $37 $16
	note $39 $2c
	note $35 $16
	note $34 $16
	note $32 $2c
	vol $6
	note $3b $16
	vol $6
	note $39 $16
	note $37 $2c
	note $34 $16
	note $37 $16
	note $3c $2c
	vibrato $01
	vol $3
	note $3c $16
	vibrato $e1
	vol $6
	note $39 $0b
	note $37 $0b
	note $35 $16
	note $37 $16
	note $39 $16
	note $3b $16
	vol $6
	note $3c $16
	vol $6
	note $3b $16
	note $3c $16
	note $39 $16
	note $3e $0b
	wait1 $05
	vol $3
	note $3e $0b
	wait1 $06
	vol $1
	note $3e $0b
	vol $6
	note $37 $0b
	wait1 $05
	vol $3
	note $37 $06
	vol $6
	note $3b $0b
	vol $6
	note $39 $0b
	note $37 $2c
	vibrato $01
	vol $3
	note $37 $12
	wait1 $04
	vibrato $e1
	vol $6
	note $37 $0b
	wait1 $05
	vol $3
	note $37 $06
	goto musicef3c3
	cmdff
; $ef4b0
; @addr{ef4b0}
sound0bChannel0:
	cmdf2
	vibrato $00
	env $0 $00
	duty $01
musicef4b7:
	vol $6
	note $28 $1d
	vol $3
	note $28 $0b
	wait1 $04
	vol $6
	note $24 $1d
	vol $3
	note $24 $0b
	wait1 $04
	vol $6
	note $29 $1d
	vol $3
	note $29 $0b
	wait1 $04
	vol $6
	note $26 $1d
	vol $3
	note $26 $0b
	wait1 $04
	vol $6
	note $2b $16
	note $29 $0b
	wait1 $05
	vol $3
	note $29 $06
	vol $6
	note $28 $0b
	wait1 $05
	vol $3
	note $28 $06
	vol $6
	note $26 $0b
	wait1 $05
	vol $3
	note $26 $06
	vol $6
	note $24 $16
	note $26 $0b
	wait1 $05
	vol $3
	note $26 $06
	vol $6
	note $28 $0b
	wait1 $05
	vol $3
	note $28 $0b
	wait1 $06
	vol $1
	note $28 $0b
	vol $6
	note $29 $19
	vol $3
	note $29 $0b
	wait1 $34
	vol $6
	note $2a $19
	vol $3
	note $2a $0b
	wait1 $08
	vol $6
	note $26 $19
	vol $3
	note $26 $0b
	wait1 $08
	vol $6
	note $23 $16
	note $24 $0b
	wait1 $05
	vol $3
	note $24 $06
	vol $6
	note $23 $0b
	wait1 $05
	vol $3
	note $23 $06
	vol $6
	note $26 $0b
	wait1 $05
	vol $3
	note $26 $06
	vol $6
	note $2b $0b
	wait1 $05
	vol $3
	note $2b $06
	vol $6
	note $26 $0b
	wait1 $05
	vol $3
	note $26 $06
	vol $6
	note $23 $0b
	wait1 $05
	vol $3
	note $23 $0b
	wait1 $06
	vol $1
	note $23 $0b
	vol $6
	note $29 $2c
	vol $3
	note $29 $2c
	vol $6
	note $2b $19
	vol $3
	note $2b $0b
	wait1 $08
	vol $6
	note $29 $19
	vol $3
	note $29 $0b
	wait1 $08
	vol $6
	note $28 $19
	vol $3
	note $28 $0b
	wait1 $08
	vol $6
	note $26 $19
	vol $3
	note $26 $0b
	wait1 $08
	vol $6
	note $24 $2c
	note $23 $2c
	note $21 $16
	note $29 $0b
	wait1 $05
	vol $3
	note $29 $06
	vol $6
	note $24 $0b
	wait1 $05
	vol $3
	note $24 $0b
	wait1 $06
	vol $1
	note $24 $0b
	vol $6
	note $28 $16
	note $29 $0b
	wait1 $05
	vol $3
	note $29 $06
	vol $6
	note $29 $0b
	wait1 $05
	vol $3
	note $29 $0b
	wait1 $06
	vol $1
	note $29 $0b
	vol $6
	note $23 $16
	vol $3
	note $23 $16
	vol $6
	note $2b $16
	vol $3
	note $2b $16
	vol $6
	note $2b $16
	note $29 $16
	note $28 $16
	note $26 $16
	goto musicef4b7
	cmdff
; $ef5c8
; @addr{ef5c8}
sound0bChannel4:
	cmdf2
musicef5c9:
	duty $0e
	note $24 $21
	duty $0f
	note $24 $21
	wait1 $16
	duty $0e
	note $26 $21
	duty $0f
	note $26 $21
	wait1 $16
	duty $0e
	note $1f $2c
	duty $0f
	note $1f $2c
	duty $0e
	note $18 $16
	note $1a $16
	note $1c $0b
	duty $0f
	note $1c $0b
	wait1 $16
	duty $0e
	note $1d $2c
	note $1c $2c
	note $1a $2c
	note $21 $2c
	note $1f $42
	note $23 $16
	note $26 $21
	wait1 $37
	note $26 $42
	note $24 $16
	note $23 $2c
	note $1f $2c
	note $24 $2c
	duty $0f
	note $24 $16
	duty $0e
	note $23 $16
	note $28 $2c
	note $26 $2c
	note $24 $2c
	note $29 $16
	duty $0f
	note $29 $16
	duty $0e
	note $1d $2c
	note $21 $16
	duty $0f
	note $21 $16
	duty $0e
	note $1f $16
	note $21 $16
	note $23 $16
	note $21 $16
	note $1f $2c
	wait1 $2c
	goto musicef5c9
	cmdff
; $ef63f
; @addr{ef63f}
sound12Channel1:
	vibrato $00
	env $0 $00
	cmdf2
	duty $02
musicef646:
	vol $6
	note $37 $0a
	note $34 $0b
	note $30 $0b
	note $2b $08
	wait1 $04
	vol $3
	note $2b $08
	wait1 $04
	vol $2
	note $2b $08
	vol $6
	note $2e $15
	note $2d $0b
	note $2b $08
	wait1 $04
	vol $3
	note $2b $08
	wait1 $04
	vol $2
	note $2b $08
	vol $6
	note $37 $0a
	note $34 $0b
	note $30 $0b
	note $2b $08
	wait1 $04
	vol $3
	note $2b $08
	wait1 $01
	vol $6
	note $2b $0b
	note $2e $15
	note $2d $0b
	note $2b $08
	wait1 $04
	vol $3
	note $2b $08
	wait1 $04
	vol $2
	note $2b $08
	vol $6
	note $37 $0a
	note $34 $0b
	note $30 $0b
	note $2b $08
	wait1 $04
	vol $3
	note $2b $08
	wait1 $04
	vol $2
	note $2b $08
	vol $6
	note $2e $15
	note $2d $0b
	note $2b $05
	wait1 $07
	vol $3
	note $2b $04
	vol $6
	note $28 $05
	wait1 $07
	vol $3
	note $28 $04
	vol $6
	note $29 $05
	wait1 $07
	vol $3
	note $29 $04
	vol $6
	note $2a $05
	wait1 $07
	vol $3
	note $2a $04
	vol $6
	note $2b $05
	wait1 $07
	vol $3
	note $2b $04
	vol $6
	note $2d $05
	wait1 $07
	vol $3
	note $2d $04
	vol $6
	note $2e $08
	wait1 $04
	vol $3
	note $2e $08
	wait1 $04
	vol $2
	note $2e $08
	wait1 $20
	vol $6
	note $37 $0a
	note $34 $0b
	note $30 $0b
	note $2b $08
	wait1 $04
	vol $3
	note $2b $08
	wait1 $04
	vol $2
	note $2b $08
	vol $6
	note $2e $15
	note $2d $0b
	note $2b $08
	wait1 $04
	vol $3
	note $2b $08
	wait1 $04
	vol $2
	note $2b $08
	vol $6
	note $37 $0a
	note $34 $0b
	note $30 $0b
	note $2b $08
	wait1 $04
	vol $3
	note $2b $08
	wait1 $04
	vol $2
	note $2b $08
	vol $6
	note $2e $08
	note $30 $08
	note $2e $08
	note $2d $08
	note $2b $08
	wait1 $04
	vol $3
	note $2b $08
	wait1 $04
	vol $2
	note $2b $08
	vol $6
	note $37 $0a
	note $34 $0b
	note $30 $0b
	note $2b $08
	wait1 $04
	vol $3
	note $2b $08
	wait1 $04
	vol $2
	note $2b $08
	vol $6
	note $2e $15
	note $2d $0b
	note $2b $08
	wait1 $04
	vol $3
	note $2b $04
	vol $6
	note $2d $08
	wait1 $04
	vol $3
	note $2d $04
	vol $6
	note $2f $08
	wait1 $04
	vol $3
	note $2f $04
	vol $6
	note $30 $08
	wait1 $04
	vol $3
	note $30 $04
	vol $6
	note $32 $08
	wait1 $04
	vol $3
	note $32 $04
	vol $6
	note $34 $08
	wait1 $04
	vol $3
	note $34 $04
	vol $6
	note $35 $08
	wait1 $04
	vol $3
	note $35 $08
	wait1 $04
	vol $2
	note $35 $08
	vol $6
	note $36 $08
	wait1 $04
	vol $3
	note $36 $08
	wait1 $04
	vol $2
	note $36 $08
	goto musicef646
	cmdff
; $ef794
; @addr{ef794}
sound12Channel0:
	vibrato $00
	env $0 $00
	cmdf2
	duty $02
musicef79b:
	vol $0
	note $20 $40
	vol $6
	note $2b $15
	note $29 $0b
	note $28 $08
	wait1 $04
	vol $3
	note $28 $08
	wait1 $04
	vol $2
	note $28 $08
	wait1 $40
	vol $6
	note $2b $15
	note $29 $0b
	note $28 $08
	wait1 $04
	vol $3
	note $28 $08
	wait1 $04
	vol $2
	note $28 $08
	wait1 $40
	vol $6
	note $2b $15
	note $29 $0b
	note $28 $05
	wait1 $07
	vol $3
	note $28 $04
	vol $6
	note $24 $05
	wait1 $07
	vol $3
	note $24 $04
	vol $6
	note $26 $05
	wait1 $07
	vol $3
	note $26 $04
	vol $6
	note $27 $05
	wait1 $07
	vol $3
	note $27 $04
	vol $6
	note $28 $05
	wait1 $07
	vol $3
	note $28 $04
	vol $6
	note $29 $05
	wait1 $07
	vol $3
	note $29 $04
	vol $6
	note $2a $08
	wait1 $04
	vol $3
	note $2a $08
	wait1 $04
	vol $2
	note $2a $08
	wait1 $60
	vol $6
	note $2b $15
	note $29 $0b
	note $28 $08
	wait1 $04
	vol $3
	note $28 $08
	wait1 $04
	vol $2
	note $28 $08
	wait1 $20
	vol $6
	note $28 $08
	wait1 $04
	vol $3
	note $28 $08
	wait1 $04
	vol $2
	note $28 $08
	vol $6
	note $2b $08
	note $2c $08
	note $2b $08
	note $29 $08
	note $28 $08
	wait1 $04
	vol $3
	note $28 $08
	wait1 $04
	vol $2
	note $28 $08
	wait1 $20
	vol $6
	note $28 $08
	wait1 $04
	vol $3
	note $28 $08
	wait1 $04
	vol $2
	note $28 $08
	vol $6
	note $2b $15
	note $29 $0b
	note $28 $08
	wait1 $04
	vol $3
	note $28 $04
	vol $6
	note $29 $08
	wait1 $04
	vol $3
	note $29 $04
	vol $6
	note $2b $08
	wait1 $04
	vol $3
	note $2b $04
	vol $6
	note $2d $08
	wait1 $04
	vol $3
	note $2d $04
	vol $6
	note $2f $08
	wait1 $04
	vol $3
	note $2f $04
	vol $6
	note $30 $08
	wait1 $04
	vol $3
	note $30 $04
	vol $6
	note $31 $08
	wait1 $04
	vol $3
	note $31 $08
	wait1 $04
	vol $2
	note $31 $08
	vol $6
	note $32 $08
	wait1 $04
	vol $3
	note $32 $08
	wait1 $04
	vol $2
	note $32 $08
	goto musicef79b
	cmdff
; $ef89d
; @addr{ef89d}
sound12Channel4:
	cmdf2
musicef89e:
	wait1 $20
	duty $0e
	note $18 $08
	duty $0f
	note $18 $08
	wait1 $10
	duty $0e
	note $1f $08
	duty $0f
	note $1f $08
	wait1 $10
	duty $0e
	note $13 $08
	duty $0f
	note $13 $08
	wait1 $10
	duty $0e
	note $16 $08
	duty $0f
	note $16 $08
	wait1 $10
	duty $0e
	note $18 $08
	duty $0f
	note $18 $08
	wait1 $10
	duty $0e
	note $1f $08
	duty $0f
	note $1f $08
	wait1 $10
	duty $0e
	note $13 $08
	duty $0f
	note $13 $08
	wait1 $10
	duty $0e
	note $16 $08
	duty $0f
	note $16 $08
	wait1 $10
	duty $0e
	note $18 $08
	duty $0f
	note $18 $08
	wait1 $10
	duty $0e
	note $1f $08
	duty $0f
	note $1f $08
	wait1 $10
	duty $0e
	note $13 $08
	duty $0f
	note $13 $08
	duty $0e
	note $15 $08
	duty $0f
	note $15 $08
	duty $0e
	note $16 $08
	duty $0f
	note $16 $08
	duty $0e
	note $17 $08
	duty $0f
	note $17 $08
	duty $0e
	note $18 $08
	duty $0f
	note $18 $08
	duty $0e
	note $1a $08
	duty $0f
	note $1a $08
	duty $0e
	note $1b $08
	duty $0f
	note $1b $08
	wait1 $50
	duty $0e
	note $18 $08
	duty $0f
	note $18 $08
	wait1 $10
	duty $0e
	note $1f $08
	duty $0f
	note $1f $08
	wait1 $10
	duty $0e
	note $13 $08
	duty $0f
	note $13 $08
	wait1 $10
	duty $0e
	note $13 $0a
	note $16 $0b
	note $17 $0b
	note $18 $08
	duty $0f
	note $18 $08
	wait1 $10
	duty $0e
	note $1f $08
	duty $0f
	note $1f $08
	wait1 $10
	duty $0e
	note $13 $08
	duty $0f
	note $13 $08
	wait1 $10
	duty $0e
	note $13 $0a
	note $16 $0b
	note $17 $0b
	note $18 $08
	duty $0f
	note $18 $08
	wait1 $10
	duty $0e
	note $1f $08
	duty $0f
	note $1f $08
	wait1 $10
	duty $0e
	note $13 $08
	duty $0f
	note $13 $08
	wait1 $10
	duty $0e
	note $15 $08
	duty $0f
	note $15 $08
	wait1 $10
	duty $0e
	note $17 $08
	duty $0f
	note $17 $08
	duty $0e
	note $19 $08
	duty $0f
	note $19 $08
	duty $0e
	note $1a $08
	duty $0f
	note $1a $08
	wait1 $10
	duty $0e
	note $1b $08
	duty $0f
	note $1b $08
	wait1 $10
	goto musicef89e
	cmdff
; $ef9d6
; @addr{ef9d6}
sound24Channel1:
	vibrato $00
	env $0 $00
	cmdf2
musicef9db:
	vol $0
	note $20 $ff
	note $20 $21
	duty $01
	vol $6
	note $34 $12
	note $36 $09
	note $38 $09
	note $39 $12
	note $38 $09
	note $36 $09
	note $34 $24
	vol $6
	note $36 $09
	wait1 $04
	vol $3
	note $36 $05
	vol $6
	note $31 $09
	wait1 $04
	vol $3
	note $31 $05
	vol $6
	note $2a $12
	vol $6
	note $23 $09
	note $26 $09
	note $28 $1b
	vol $3
	note $28 $09
	vol $6
	note $2a $06
	wait1 $03
	note $2a $09
	wait1 $04
	vol $3
	note $2a $05
	vol $6
	note $2a $09
	note $23 $09
	wait1 $04
	vol $3
	note $23 $05
	vol $6
	note $26 $09
	wait1 $04
	vol $3
	note $26 $05
	vol $6
	note $2f $24
	note $31 $09
	wait1 $04
	vol $3
	note $31 $05
	vol $5
	note $34 $09
	wait1 $04
	vol $3
	note $34 $05
	vol $6
	note $31 $1b
	vol $5
	note $34 $09
	vol $7
	note $36 $09
	wait1 $04
	vol $3
	note $36 $09
	wait1 $05
	vol $2
	note $36 $09
	wait1 $12
	duty $02
	vol $6
	note $30 $03
	wait1 $03
	vol $5
	note $30 $03
	wait1 $03
	vol $3
	note $30 $03
	wait1 $03
	vol $6
	note $3b $03
	wait1 $03
	vol $5
	note $3c $03
	wait1 $03
	vol $4
	note $3c $03
	wait1 $03
	vol $4
	note $3c $03
	wait1 $21
	vol $6
	note $30 $03
	wait1 $03
	vol $5
	note $30 $03
	wait1 $03
	vol $3
	note $30 $03
	wait1 $03
	vol $6
	note $3b $03
	wait1 $03
	vol $5
	note $3c $03
	wait1 $03
	vol $4
	note $3c $03
	wait1 $03
	vol $3
	note $3c $03
	wait1 $21
	vol $6
	note $35 $03
	wait1 $03
	vol $5
	note $35 $03
	wait1 $03
	vol $3
	note $35 $03
	wait1 $03
	vol $6
	note $40 $03
	wait1 $03
	vol $5
	note $41 $03
	wait1 $03
	vol $4
	note $41 $03
	wait1 $03
	vol $4
	note $41 $03
	wait1 $21
	vol $6
	note $35 $03
	wait1 $03
	vol $5
	note $35 $03
	wait1 $03
	vol $3
	note $35 $03
	wait1 $03
	vol $6
	note $40 $03
	wait1 $03
	vol $5
	note $41 $03
	wait1 $03
	vol $4
	note $41 $03
	wait1 $03
	vol $3
	note $41 $03
	wait1 $b1
	vol $6
	note $37 $03
	wait1 $03
	vol $5
	note $37 $03
	wait1 $03
	vol $3
	note $37 $03
	wait1 $03
	vol $6
	note $42 $03
	wait1 $03
	vol $5
	note $43 $03
	wait1 $03
	vol $4
	note $43 $03
	wait1 $03
	vol $4
	note $43 $03
	wait1 $21
	vol $6
	note $3c $03
	wait1 $03
	vol $5
	note $3c $03
	wait1 $03
	vol $3
	note $3c $03
	wait1 $03
	vol $6
	note $47 $03
	wait1 $03
	vol $5
	note $48 $03
	wait1 $03
	vol $4
	note $48 $03
	wait1 $03
	vol $3
	note $48 $03
	wait1 $0f
	duty $01
	goto musicef9db
	cmdff
; $efb2d
; @addr{efb2d}
sound24Channel0:
	vibrato $00
	env $0 $00
	cmdf2
	duty $02
musicefb34:
	vol $0
	note $20 $12
	vol $6
	note $30 $03
	wait1 $03
	vol $5
	note $30 $03
	wait1 $03
	vol $3
	note $30 $03
	wait1 $03
	vol $6
	note $3b $03
	wait1 $03
	vol $5
	note $3c $03
	wait1 $03
	vol $4
	note $3c $03
	wait1 $03
	vol $4
	note $3c $03
	wait1 $21
	vol $6
	note $30 $03
	wait1 $03
	vol $5
	note $30 $03
	wait1 $03
	vol $3
	note $30 $03
	wait1 $03
	vol $6
	note $3b $03
	wait1 $03
	vol $5
	note $3c $03
	wait1 $03
	vol $4
	note $3c $03
	wait1 $03
	vol $3
	note $3c $03
	wait1 $0f
	duty $01
	vol $4
	note $18 $12
	note $1b $09
	note $1c $09
	note $1d $12
	note $21 $12
	note $23 $09
	wait1 $04
	vol $2
	note $23 $05
	vol $4
	note $1f $09
	note $1a $09
	note $1f $11
	wait1 $01
	duty $02
	note $30 $03
	wait1 $03
	vol $3
	note $30 $03
	wait1 $03
	vol $2
	note $30 $03
	wait1 $15
	vol $6
	note $2f $03
	wait1 $03
	vol $5
	note $2f $03
	wait1 $03
	vol $3
	note $2f $03
	wait1 $03
	vol $6
	note $39 $03
	wait1 $03
	vol $5
	note $3b $03
	wait1 $03
	vol $4
	note $3b $03
	wait1 $03
	vol $4
	note $3b $03
	wait1 $21
	vol $6
	note $2f $03
	wait1 $03
	vol $5
	note $2f $03
	wait1 $03
	vol $3
	note $2f $03
	wait1 $03
	vol $6
	note $39 $03
	wait1 $03
	vol $5
	note $3b $03
	wait1 $03
	vol $4
	note $3b $03
	wait1 $03
	vol $3
	note $3b $03
	wait1 $0f
	duty $01
	vol $4
	note $17 $12
	note $1a $12
	note $1c $12
	note $1f $12
	note $21 $12
	note $1e $09
	note $19 $09
	note $1e $12
	duty $02
	note $2f $03
	wait1 $03
	vol $3
	note $2f $03
	wait1 $03
	vol $2
	note $2f $03
	wait1 $15
	vol $6
	note $31 $03
	wait1 $03
	vol $5
	note $31 $03
	wait1 $03
	vol $3
	note $31 $03
	wait1 $03
	vol $6
	note $3c $03
	wait1 $03
	vol $5
	note $3d $03
	wait1 $03
	vol $4
	note $3d $03
	wait1 $03
	vol $4
	note $3d $03
	wait1 $21
	vol $6
	note $31 $03
	wait1 $03
	vol $5
	note $31 $03
	wait1 $03
	vol $3
	note $31 $03
	wait1 $03
	vol $6
	note $3c $03
	wait1 $03
	vol $5
	note $3d $03
	wait1 $03
	vol $4
	note $3d $03
	wait1 $03
	vol $3
	note $3d $03
	wait1 $0f
	duty $01
	vol $4
	note $18 $12
	note $1b $12
	note $1d $12
	note $1f $12
	note $21 $12
	note $1c $09
	note $1d $09
	note $1c $12
	duty $02
	note $30 $03
	wait1 $03
	vol $3
	note $30 $03
	wait1 $03
	vol $2
	note $30 $03
	wait1 $03
	duty $01
	vol $7
	note $1d $09
	note $1f $09
	note $21 $09
	note $22 $09
	note $24 $09
	wait1 $04
	vol $4
	note $24 $09
	wait1 $05
	vol $2
	note $24 $09
	vol $4
	note $35 $09
	note $37 $09
	note $39 $09
	note $3a $09
	note $3c $09
	wait1 $04
	vol $2
	note $3c $09
	wait1 $05
	vol $1
	note $3c $09
	wait1 $12
	duty $02
	vol $6
	note $30 $03
	wait1 $03
	vol $5
	note $30 $03
	wait1 $03
	vol $3
	note $30 $03
	wait1 $03
	vol $6
	note $3b $03
	wait1 $03
	vol $5
	note $3c $03
	wait1 $03
	vol $4
	note $3c $03
	wait1 $03
	vol $4
	note $3c $03
	wait1 $21
	vol $6
	note $30 $03
	wait1 $03
	vol $5
	note $30 $03
	wait1 $03
	vol $3
	note $30 $03
	wait1 $03
	vol $6
	note $3b $03
	wait1 $03
	vol $5
	note $3c $03
	wait1 $03
	vol $4
	note $3c $03
	wait1 $03
	vol $3
	note $3c $03
	wait1 $0f
	duty $01
	vol $4
	note $18 $12
	note $1b $12
	note $1d $12
	note $20 $12
	note $22 $12
	note $2b $09
	note $29 $09
	note $2b $12
	duty $02
	note $30 $03
	wait1 $03
	vol $3
	note $30 $03
	wait1 $03
	vol $2
	note $30 $03
	wait1 $03
	goto musicefb34
	cmdff
; $efd19
; @addr{efd19}
sound24Channel4:
	cmdf2
musicefd1a:
	duty $0e
	note $1d $09
	duty $0f
	note $1d $09
	wait1 $12
	duty $0e
	note $22 $12
	note $24 $09
	duty $0f
	note $24 $09
	duty $0e
	note $18 $09
	duty $0f
	note $18 $09
	duty $0e
	note $27 $09
	note $26 $09
	note $24 $09
	duty $0f
	note $24 $09
	wait1 $12
	duty $0e
	note $1d $12
	note $22 $12
	note $24 $12
	note $27 $12
	note $26 $12
	note $22 $09
	note $1f $09
	note $24 $12
	duty $0f
	note $24 $12
	duty $0e
	note $1c $09
	duty $0f
	note $1c $09
	wait1 $12
	duty $0e
	note $21 $12
	note $23 $09
	duty $0f
	note $23 $09
	duty $0e
	note $17 $09
	duty $0f
	note $17 $09
	duty $0e
	note $26 $09
	note $25 $09
	note $23 $09
	duty $0f
	note $23 $09
	wait1 $12
	duty $0e
	note $1c $12
	note $21 $12
	note $23 $12
	note $26 $12
	note $25 $12
	note $21 $09
	note $1e $09
	note $23 $12
	duty $0f
	note $23 $12
	duty $0e
	note $12 $12
	duty $0f
	note $12 $12
	duty $0e
	note $17 $09
	duty $0f
	note $17 $09
	duty $0e
	note $19 $09
	duty $0f
	note $19 $09
	duty $0e
	note $0d $09
	duty $0f
	note $0d $09
	wait1 $12
	duty $0e
	note $19 $09
	duty $0f
	note $19 $09
	wait1 $12
	duty $0e
	note $39 $1b
	note $37 $09
	note $30 $09
	duty $0f
	note $30 $09
	duty $0e
	note $33 $09
	duty $0f
	note $33 $09
	duty $0e
	note $35 $12
	note $37 $09
	note $39 $09
	note $37 $09
	duty $0f
	note $37 $09
	duty $0e
	note $2d $09
	note $2b $09
	note $21 $1b
	note $1f $09
	note $1d $09
	duty $0f
	note $1d $09
	duty $0e
	note $18 $09
	duty $0f
	note $18 $09
	duty $0e
	note $1b $09
	duty $0f
	note $1b $09
	duty $0e
	note $1b $09
	duty $0f
	note $1b $09
	duty $0e
	note $1d $09
	note $18 $09
	note $24 $09
	note $21 $09
	note $1d $09
	duty $0f
	note $1d $09
	wait1 $12
	duty $0e
	note $22 $12
	note $24 $09
	duty $0f
	note $24 $09
	duty $0e
	note $18 $09
	duty $0f
	note $18 $09
	duty $0e
	note $27 $09
	note $26 $09
	note $24 $09
	duty $0f
	note $24 $09
	wait1 $12
	duty $0e
	note $1d $12
	note $22 $12
	note $24 $12
	note $27 $12
	note $26 $12
	note $22 $09
	note $1f $09
	note $24 $12
	duty $0f
	note $24 $12
	goto musicefd1a
	cmdff
; $efe5c
sound87Start:
; @addr{efe5c}
sound87Channel2:
	duty $02
	env $1 $00
	vol $3
	cmdf8 $30
	note $2a $06
	cmdff
; $efe66
sound89Start:
; @addr{efe66}
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
; $efe7a
sound8bStart:
; @addr{efe7a}
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
; $efe8c
soundcbStart:
; @addr{efe8c}
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
; $efea1
; @addr{efea1}
soundcbChannel7:
	cmdf0 $b1
	note $25 $01
	cmdf0 $41
	note $14 $0a
	cmdff
; $efeaa
sound8cStart:
; @addr{efeaa}
sound8cChannel2:
	duty $02
	vol $5
	note $3e $01
	note $4a $04
	cmdff
; $efeb2
sound8fStart:
; @addr{efeb2}
sound8fChannel2:
	duty $02
	vol $b
	env $0 $02
	cmdf8 $0f
	note $24 $13
	cmdff
; $efebc
sound90Start:
; @addr{efebc}
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
; $efef7
soundcaStart:
; @addr{efef7}
soundcaChannel2:
	cmdff
; $efef8
; @addr{efef8}
soundcaChannel7:
	cmdff
; $efef9
sound56Start:
; @addr{efef9}
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
; $eff28
sound4dStart:
; @addr{eff28}
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
; $eff40
sound4cStart:
; @addr{eff40}
sound4cChannel2:
	duty $01
	vol $b
	note $30 $0a
	note $31 $0a
	note $32 $0a
	note $33 $32
	cmdff
; $eff4c
; @addr{eff4c}
sound4cChannel3:
	duty $01
	vol $9
	note $39 $0a
	note $3a $0a
	note $3b $0a
	note $3c $32
	cmdff
; $eff58
; @addr{eff58}
sound4cChannel5:
	duty $01
	note $29 $0a
	note $2a $0a
	note $2b $0a
	note $2c $32
	cmdff
; $eff63
; @addr{eff63}
sound4cChannel7:
	cmdf0 $00
	note $00 $50
	cmdff
; $eff68
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
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
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
; @addr{f0000}
sound1cChannel6:
sound1fChannel6:
sound07Channel6:
sound26Channel6:
sound19Channel6:
	cmdff
; $f0001
sound15Start:
; @addr{f0001}
sound15Channel1:
	cmdf2
	vibrato $e1
	env $0 $00
	duty $01
musicf0008:
	vol $6
	note $1d $23
	wait1 $01
	vibrato $01
	vol $3
	note $1d $09
	wait1 $09
	vibrato $e1
	vol $6
	note $18 $09
	vol $3
	note $18 $09
	vol $6
	note $1b $09
	vol $3
	note $1b $09
	vol $6
	note $18 $09
	vol $3
	note $18 $09
	wait1 $12
	vol $6
	note $18 $09
	vol $3
	note $18 $09
	vol $6
	note $1b $09
	vol $3
	note $1b $09
	vol $6
	note $1e $09
	vol $3
	note $1e $09
	vol $6
	note $1d $51
	vibrato $01
	vol $3
	note $1d $09
	wait1 $09
	vibrato $e1
	vol $6
	note $1b $09
	note $1d $09
	note $1b $09
	note $18 $09
	vol $3
	note $18 $09
	wait1 $63
	vol $6
	note $2a $09
	note $29 $09
	note $27 $09
	note $29 $09
	note $27 $09
	note $24 $09
	vol $3
	note $24 $09
	wait1 $6c
	vol $6
	note $30 $09
	vol $3
	note $30 $09
	vol $6
	note $2f $09
	vol $3
	note $2f $09
	wait1 $09
	vol $6
	note $2f $09
	vol $6
	note $30 $09
	vol $3
	note $30 $09
	vol $6
	note $2f $09
	vol $3
	note $2f $09
	wait1 $12
	vol $6
	note $2f $09
	vol $3
	note $2f $09
	vol $6
	note $30 $09
	vol $3
	note $30 $09
	vol $6
	note $33 $09
	vol $3
	note $33 $09
	vol $6
	note $32 $1b
	note $33 $09
	note $32 $09
	note $33 $09
	note $32 $09
	note $33 $09
	note $32 $09
	note $33 $09
	note $32 $09
	note $33 $09
	note $35 $09
	vol $3
	note $35 $09
	vol $6
	note $3c $09
	vol $3
	note $3c $09
	vol $6
	note $3b $09
	vol $3
	note $3b $09
	wait1 $12
	vol $6
	note $3b $09
	vol $3
	note $3b $09
	vol $6
	note $3a $09
	vol $3
	note $3a $09
	wait1 $12
	vol $6
	note $38 $09
	vol $3
	note $38 $09
	vol $6
	note $3a $09
	vol $3
	note $3a $09
	wait1 $12
	vol $6
	note $3a $09
	vol $3
	note $3a $09
	vol $6
	note $38 $09
	vol $3
	note $38 $09
	wait1 $12
	vol $6
	note $38 $09
	vol $3
	note $38 $09
	vol $6
	note $37 $09
	vol $3
	note $37 $09
	vol $6
	note $38 $09
	vol $3
	note $38 $09
	vol $6
	note $37 $09
	vol $3
	note $37 $09
	wait1 $12
	vol $6
	note $30 $09
	vol $3
	note $30 $09
	wait1 $12
	vol $6
	note $33 $09
	vol $3
	note $33 $09
	vol $6
	note $32 $09
	vol $3
	note $32 $09
	vol $6
	note $31 $09
	vol $3
	note $31 $09
	vol $6
	note $30 $51
	vibrato $01
	vol $3
	note $30 $09
	vibrato $e1
	vol $7
	note $23 $12
	note $24 $09
	vol $3
	note $24 $09
	vol $7
	note $23 $12
	note $24 $09
	vol $3
	note $24 $09
	goto musicf0008
	cmdff
; $f013d
; @addr{f013d}
sound15Channel0:
	cmdf2
	vibrato $e1
	env $0 $00
	duty $01
musicf0144:
	vol $6
	note $18 $24
	vibrato $01
	vol $2
	note $18 $09
	wait1 $09
	vibrato $e1
	vol $6
	note $13 $09
	vol $2
	note $13 $09
	vol $6
	note $16 $09
	vol $2
	note $16 $09
	vol $6
	note $13 $09
	vol $2
	note $13 $09
	wait1 $12
	vol $6
	note $13 $09
	vol $2
	note $13 $09
	vol $6
	note $16 $09
	vol $2
	note $16 $09
	vol $6
	note $19 $09
	vol $2
	note $19 $09
	vol $6
	note $18 $48
	vibrato $01
	vol $2
	note $18 $09
	wait1 $12
	vibrato $e1
	vol $6
	note $16 $09
	note $18 $09
	note $16 $09
	note $13 $09
	vol $2
	note $13 $09
	wait1 $63
	vol $7
	note $25 $09
	note $24 $09
	note $22 $09
	note $24 $09
	note $22 $09
	note $1f $09
	wait1 $75
	note $2c $09
	vol $3
	note $2c $09
	vol $7
	note $2b $09
	vol $3
	note $2b $09
	wait1 $09
	vol $7
	note $2b $09
	note $2c $09
	vol $3
	note $2c $09
	vol $7
	note $2b $09
	vol $3
	note $2b $09
	wait1 $12
	vol $7
	note $2b $09
	vol $3
	note $2b $09
	vol $7
	note $2c $09
	vol $3
	note $2c $09
	vol $7
	note $30 $09
	vol $3
	note $30 $09
	vol $7
	note $2f $1b
	note $30 $09
	note $2f $09
	note $30 $09
	note $2f $09
	note $30 $09
	note $2f $09
	note $30 $09
	note $2f $09
	note $30 $09
	note $30 $09
	vol $3
	note $30 $09
	vol $7
	note $38 $09
	vol $3
	note $38 $09
	vol $7
	note $37 $09
	vol $3
	note $37 $09
	vol $6
	note $30 $09
	vol $3
	note $30 $09
	vol $7
	note $37 $09
	vol $3
	note $37 $09
	vol $7
	note $36 $09
	vol $3
	note $36 $09
	vol $6
	note $30 $09
	vol $3
	note $30 $09
	vol $7
	note $35 $09
	vol $3
	note $35 $09
	vol $7
	note $37 $09
	vol $3
	note $37 $09
	vol $7
	note $30 $09
	vol $3
	note $30 $09
	vol $7
	note $37 $09
	vol $3
	note $37 $09
	vol $7
	note $35 $09
	vol $3
	note $35 $09
	vol $6
	note $30 $09
	vol $3
	note $30 $09
	vol $7
	note $30 $09
	vol $3
	note $30 $09
	vol $7
	note $33 $09
	note $32 $09
	note $31 $09
	note $30 $09
	note $2b $09
	vol $3
	note $2b $09
	wait1 $12
	vol $7
	note $24 $09
	vol $3
	note $24 $09
	wait1 $09
	vol $7
	note $24 $09
	note $2e $09
	vol $3
	note $2e $09
	vol $7
	note $2d $09
	vol $3
	note $2d $09
	vol $7
	note $2c $09
	vol $3
	note $2c $09
	vol $7
	note $2b $09
	vol $3
	note $2b $09
	wait1 $12
	vol $7
	note $30 $04
	wait1 $05
	note $30 $04
	wait1 $05
	note $3c $04
	wait1 $05
	vol $6
	note $3c $04
	wait1 $05
	vol $3
	note $3c $04
	wait1 $05
	vol $2
	note $3c $04
	wait1 $05
	vol $7
	note $30 $04
	wait1 $05
	note $30 $04
	wait1 $05
	note $3c $04
	wait1 $05
	vol $6
	note $3c $04
	wait1 $05
	vol $7
	note $3c $04
	wait1 $05
	vol $5
	note $3c $04
	wait1 $05
	vol $7
	note $48 $04
	wait1 $05
	vol $4
	note $48 $04
	wait1 $05
	goto musicf0144
	cmdff
; $f02b0
; @addr{f02b0}
sound15Channel4:
	cmdf2
musicf02b1:
	duty $0e
	note $05 $12
	wait1 $12
	note $11 $12
	wait1 $09
	note $0c $09
	note $0f $09
	wait1 $09
	note $0f $09
	wait1 $09
	note $0f $09
	wait1 $09
	note $0c $09
	wait1 $09
	note $11 $09
	wait1 $09
	note $11 $09
	wait1 $09
	note $11 $12
	wait1 $09
	note $0c $09
	note $0f $09
	wait1 $09
	note $0f $09
	wait1 $09
	note $0e $09
	wait1 $09
	note $0c $09
	wait1 $09
	note $05 $12
	wait1 $12
	note $11 $12
	wait1 $09
	note $0c $09
	note $0f $09
	wait1 $09
	note $0f $09
	wait1 $09
	note $0f $09
	wait1 $09
	note $0c $09
	wait1 $09
	note $11 $09
	wait1 $1b
	note $11 $12
	wait1 $09
	note $0c $09
	note $0f $09
	wait1 $09
	note $0f $09
	wait1 $09
	note $0f $09
	note $0e $09
	note $0d $09
	note $0c $09
	note $05 $12
	wait1 $12
	note $11 $12
	wait1 $09
	note $0c $09
	note $0f $09
	wait1 $09
	note $0f $09
	wait1 $09
	note $0f $09
	wait1 $09
	note $0c $09
	wait1 $09
	note $11 $09
	wait1 $1b
	note $11 $12
	duty $0f
	note $11 $09
	duty $0e
	note $0c $09
	note $0f $09
	wait1 $09
	note $0f $09
	wait1 $09
	note $0f $09
	wait1 $09
	note $0c $09
	wait1 $09
	note $0a $0d
	wait1 $17
	note $16 $09
	wait1 $09
	note $11 $09
	wait1 $09
	note $14 $09
	wait1 $09
	note $14 $09
	wait1 $09
	note $14 $09
	wait1 $09
	note $11 $09
	wait1 $09
	note $16 $0d
	wait1 $17
	note $16 $12
	duty $0f
	note $16 $09
	duty $0e
	note $11 $09
	note $14 $09
	wait1 $09
	note $14 $09
	wait1 $09
	note $14 $09
	note $13 $09
	note $11 $09
	note $10 $09
	note $0c $0d
	wait1 $71
	note $0c $04
	wait1 $05
	note $0c $04
	wait1 $05
	note $0c $0d
	wait1 $05
	note $0c $0d
	wait1 $05
	note $0c $0d
	wait1 $05
	note $0c $0d
	wait1 $05
	note $0c $09
	note $0d $09
	note $0e $09
	note $0f $09
	note $10 $09
	note $11 $09
	note $12 $09
	note $13 $09
	goto musicf02b1
	cmdff
; $f03c1
; @addr{f03c1}
sound15Channel6:
	cmdf2
musicf03c2:
	vol $6
	note $24 $04
	wait1 $7a
	note $24 $04
	wait1 $05
	note $24 $04
	wait1 $05
	note $24 $04
	wait1 $7a
	note $24 $04
	wait1 $0e
	note $24 $04
	wait1 $7a
	note $24 $04
	wait1 $0e
	note $24 $04
	wait1 $7a
	note $24 $04
	wait1 $05
	note $24 $04
	wait1 $05
	note $24 $04
	wait1 $7a
	note $24 $04
	wait1 $0e
	note $24 $04
	wait1 $7a
	note $24 $04
	wait1 $0e
	note $24 $04
	wait1 $7a
	note $24 $04
	wait1 $0e
	note $24 $04
	wait1 $7a
	note $24 $04
	wait1 $05
	note $24 $04
	wait1 $05
	vol $4
	note $2e $04
	wait1 $20
	note $2e $04
	wait1 $20
	note $2e $04
	wait1 $20
	note $2e $04
	wait1 $0e
	vol $6
	note $24 $04
	wait1 $05
	note $24 $04
	wait1 $05
	note $24 $04
	wait1 $0e
	vol $4
	note $2a $04
	wait1 $0e
	vol $4
	note $2e $04
	wait1 $20
	vol $4
	note $2a $04
	wait1 $0e
	note $2e $04
	wait1 $0e
	note $2a $04
	wait1 $0e
	note $2e $04
	wait1 $0e
	goto musicf03c2
	cmdff
; $f044c
; @addr{f044c}
sound1cChannel1:
	vibrato $c1
	env $0 $00
	cmdf2
	duty $01
musicf0453:
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
	goto musicf0453
	cmdff
; $f0597
; @addr{f0597}
sound1cChannel0:
	vibrato $c1
	env $0 $00
	cmdf2
	duty $01
musicf059e:
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
	goto musicf059e
	cmdff
; $f0816
; @addr{f0816}
sound1cChannel4:
	duty $0e
musicf0818:
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
	goto musicf0818
	cmdff
; $f08e0
; @addr{f08e0}
sound1fChannel1:
	vibrato $e1
	env $0 $00
	cmdf2
	duty $01
musicf08e7:
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
	goto musicf08e7
	cmdff
; $f09e7
; @addr{f09e7}
sound1fChannel0:
	vibrato $e1
	env $0 $00
	cmdf2
	duty $01
musicf09ee:
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
	goto musicf09ee
	cmdff
; $f0a92
; @addr{f0a92}
sound1fChannel4:
	cmdf2
	duty $08
musicf0a95:
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
	goto musicf0a95
	cmdff
; $f0b16
sound40Start:
; @addr{f0b16}
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
; $f0bea
; @addr{f0bea}
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
; $f0ca2
; @addr{f0ca2}
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
; $f0d60
; @addr{f0d60}
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
; $f0f26
; @addr{f0f26}
sound07Channel1:
	cmdf2
	vibrato $e1
	env $0 $00
	duty $01
	vol $8
	note $28 $06
	note $2a $06
	note $2c $06
	note $2d $06
musicf0f36:
	note $2f $18
	vol $5
	note $2f $0c
	vol $8
	note $34 $06
	vol $5
	note $34 $06
	vol $8
	note $34 $18
	vol $5
	note $34 $0c
	vol $8
	note $34 $0c
	note $32 $08
	note $34 $08
	note $32 $08
	vol $8
	note $31 $0c
	note $2f $0c
	note $31 $10
	wait1 $02
	vol $5
	note $31 $06
	vol $8
	note $2d $10
	wait1 $02
	vol $5
	note $2d $06
	vol $8
	note $2a $10
	wait1 $02
	vol $5
	note $2a $06
	vol $8
	note $31 $10
	wait1 $02
	vol $5
	note $31 $06
	vol $8
	note $2f $24
	note $28 $06
	wait1 $06
	note $28 $18
	vol $5
	note $28 $0c
	vol $8
	note $28 $0c
	note $2b $0c
	note $2a $0c
	note $28 $0c
	note $26 $0c
	note $23 $0c
	wait1 $06
	vol $5
	note $23 $06
	vol $8
	note $26 $0c
	wait1 $06
	vol $5
	note $26 $06
	vol $8
	note $28 $60
	vibrato $01
	vol $5
	note $28 $30
	vibrato $e1
	vol $8
	note $28 $0c
	wait1 $06
	vol $5
	note $28 $06
	vol $8
	note $2f $0c
	wait1 $06
	vol $5
	note $2f $06
	vol $8
	note $2f $18
	wait1 $06
	vol $5
	note $2f $06
	vol $8
	note $32 $0c
	note $34 $18
	note $31 $0c
	note $2d $0c
	note $2f $0c
	wait1 $06
	vol $5
	note $2f $06
	vol $8
	note $2f $0c
	note $32 $0c
	note $34 $0c
	wait1 $06
	vol $5
	note $34 $06
	vol $8
	note $32 $0c
	note $34 $0c
	note $37 $0c
	note $36 $0c
	note $34 $0c
	note $32 $0c
	note $36 $0c
	note $34 $0c
	note $32 $0c
	note $2d $0c
	note $2f $0c
	wait1 $06
	vol $5
	note $2f $06
	vol $8
	note $2d $0c
	note $2f $0c
	note $2b $18
	note $2a $18
	note $28 $18
	note $26 $18
	note $2a $0c
	wait1 $06
	vol $5
	note $2a $06
	vol $8
	note $28 $0c
	note $2a $0c
	note $26 $08
	note $28 $08
	note $26 $08
	note $25 $0c
	note $22 $0c
	note $23 $90
	vibrato $01
	vol $5
	note $23 $18
	vibrato $e1
	vol $8
	note $28 $06
	note $2a $06
	note $2c $06
	note $2d $06
	goto musicf0f36
	cmdff
; $f102d
; @addr{f102d}
sound07Channel0:
	vol $0
	note $20 $18
	cmdf2
	vibrato $e1
	env $0 $00
	duty $02
musicf1037:
	vol $8
	note $2c $18
	vol $5
	note $2c $0c
	vol $8
	note $2c $06
	vol $5
	note $2c $06
	vol $8
	note $2c $1e
	vol $5
	note $2c $06
	vol $8
	note $2c $0c
	note $2d $0c
	wait1 $06
	vol $5
	note $2d $06
	vol $8
	note $2d $0c
	wait1 $06
	vol $5
	note $2d $06
	vol $8
	note $2d $0c
	wait1 $06
	vol $5
	note $2d $06
	vol $8
	note $2a $0c
	note $25 $0c
	note $28 $0c
	note $27 $0c
	note $28 $0c
	note $25 $0c
	note $2c $12
	vol $5
	note $2c $06
	vol $8
	note $2c $0c
	note $23 $0c
	note $20 $0c
	wait1 $06
	vol $5
	note $20 $06
	vol $8
	note $20 $0c
	note $21 $0c
	note $26 $0c
	note $25 $0c
	note $23 $0c
	note $21 $0c
	note $1e $0c
	wait1 $06
	vol $5
	note $1e $06
	vol $8
	note $1e $0c
	note $21 $0c
	vol $5
	note $21 $0c
	wait1 $0c
	vol $8
	note $21 $0c
	note $23 $0c
	note $21 $0c
	wait1 $06
	vol $5
	note $21 $06
	vol $8
	note $1e $0c
	wait1 $06
	vol $5
	note $1e $06
	vol $8
	note $21 $0c
	note $1f $0c
	note $1e $0c
	note $1a $0c
	note $1f $0c
	wait1 $06
	vol $5
	note $1f $06
	vol $8
	note $1f $0c
	note $21 $0c
	note $23 $0c
	wait1 $06
	vol $5
	note $23 $06
	vol $8
	note $23 $0c
	note $25 $0c
	note $26 $0c
	note $25 $0c
	note $23 $0c
	note $1e $0c
	note $21 $0c
	wait1 $06
	vol $5
	note $21 $06
	vol $8
	note $23 $0c
	wait1 $06
	vol $5
	note $23 $06
	vol $8
	note $1e $24
	note $21 $0c
	note $28 $0c
	note $26 $0c
	note $25 $0c
	note $23 $0c
	note $26 $0c
	wait1 $06
	vol $5
	note $26 $06
	vol $8
	note $21 $0c
	wait1 $06
	vol $5
	note $21 $06
	vol $8
	note $1f $18
	note $1e $18
	note $1c $0c
	vol $5
	note $1c $0c
	vol $8
	note $28 $0c
	note $26 $0c
	note $25 $0c
	wait1 $06
	vol $5
	note $25 $06
	vol $8
	note $23 $0c
	wait1 $06
	vol $5
	note $23 $06
	vol $8
	note $26 $0c
	wait1 $06
	vol $5
	note $26 $06
	vol $8
	note $25 $0c
	note $26 $0c
	note $23 $18
	note $22 $12
	wait1 $06
	note $17 $24
	note $18 $0c
	note $1b $0c
	note $1c $0c
	note $1e $0c
	note $1f $0c
	note $21 $18
	note $1f $0c
	note $1e $0c
	note $24 $0c
	wait1 $06
	vol $5
	note $24 $06
	vol $8
	note $23 $0c
	wait1 $06
	vol $5
	note $23 $06
	goto musicf1037
	cmdff
; $f115d
; @addr{f115d}
sound07Channel4:
	wait1 $18
musicf115f:
	duty $0e
	note $1c $1e
	wait1 $06
	note $1c $06
	wait1 $06
	note $1c $18
	wait1 $0c
	note $1c $06
	wait1 $06
	duty $0e
	note $1c $12
	wait1 $06
	note $1c $12
	wait1 $06
	note $1c $12
	wait1 $06
	note $15 $12
	wait1 $06
	note $17 $12
	wait1 $06
	note $17 $12
	wait1 $06
	note $1c $0c
	note $1b $0c
	note $1c $0c
	note $17 $0c
	note $14 $0c
	note $15 $0c
	note $14 $0c
	note $12 $0c
	note $15 $0c
	duty $0f
	note $15 $0c
	duty $0e
	note $13 $0c
	note $12 $0c
	note $17 $0c
	duty $0f
	note $17 $0c
	duty $0e
	note $17 $0c
	duty $0f
	note $17 $0c
	duty $0e
	note $10 $30
	note $1a $30
	note $17 $30
	note $10 $12
	wait1 $06
	note $10 $12
	wait1 $06
	note $10 $1e
	wait1 $06
	note $14 $0c
	note $15 $18
	note $1c $0c
	duty $0e
	note $19 $0c
	note $1c $0c
	duty $0f
	note $1c $0c
	duty $0e
	note $1c $0c
	note $17 $0c
	note $19 $0c
	duty $0f
	note $19 $0c
	duty $0e
	note $17 $0c
	note $1c $0c
	note $1a $0c
	duty $0f
	note $1a $0c
	duty $0e
	note $1e $0c
	duty $0f
	note $1e $0c
	duty $0e
	note $15 $24
	note $12 $0c
	note $17 $12
	wait1 $06
	note $17 $12
	wait1 $06
	note $1c $30
	note $1a $30
	note $19 $30
	note $16 $30
	note $17 $0c
	duty $0f
	note $17 $0c
	duty $0e
	note $17 $0c
	note $15 $0c
	note $13 $18
	note $12 $0c
	note $13 $0c
	note $10 $18
	note $12 $0c
	note $10 $0c
	note $0f $0c
	note $12 $0c
	note $15 $0c
	note $18 $0c
	goto musicf115f
	cmdff
; $f1233
; @addr{f1233}
sound26Channel1:
	vibrato $00
	env $0 $00
	duty $02
musicf1239:
	vol $6
	note $2d $1c
	wait1 $08
	note $32 $07
	wait1 $06
	vol $3
	note $32 $03
	wait1 $02
	vol $6
	note $36 $07
	wait1 $06
	vol $3
	note $36 $03
	wait1 $02
	vol $6
	note $39 $1c
	wait1 $08
	note $38 $07
	wait1 $0b
	note $35 $07
	wait1 $06
	vol $3
	note $35 $03
	wait1 $02
	vol $6
	note $38 $1c
	wait1 $08
	note $36 $07
	wait1 $06
	vol $3
	note $36 $03
	wait1 $02
	vol $6
	note $32 $07
	wait1 $06
	vol $3
	note $32 $03
	wait1 $02
	vol $6
	note $35 $1c
	wait1 $08
	note $36 $07
	wait1 $06
	vol $3
	note $36 $07
	wait1 $07
	vol $2
	note $36 $07
	wait1 $02
	vol $6
	note $3a $1c
	wait1 $08
	note $39 $07
	wait1 $06
	vol $3
	note $39 $07
	wait1 $07
	vol $2
	note $39 $07
	wait1 $02
	vol $6
	note $3a $07
	wait1 $06
	vol $3
	note $3a $03
	wait1 $02
	vol $6
	note $3a $07
	wait1 $06
	vol $3
	note $3a $03
	wait1 $02
	vol $6
	note $39 $07
	wait1 $06
	vol $3
	note $39 $07
	wait1 $07
	vol $2
	note $39 $07
	wait1 $02
	vol $6
	note $2d $1c
	wait1 $08
	note $32 $07
	wait1 $06
	vol $3
	note $32 $03
	wait1 $02
	vol $6
	note $36 $07
	wait1 $06
	vol $3
	note $36 $03
	wait1 $02
	vol $6
	note $39 $1c
	wait1 $08
	note $38 $07
	wait1 $06
	vol $3
	note $38 $03
	wait1 $02
	vol $6
	note $35 $07
	wait1 $06
	vol $3
	note $35 $03
	wait1 $02
	vol $6
	note $38 $1c
	wait1 $08
	note $3e $07
	wait1 $06
	vol $3
	note $3e $03
	wait1 $02
	vol $6
	note $38 $07
	wait1 $06
	vol $3
	note $38 $03
	wait1 $02
	vol $6
	note $3a $07
	wait1 $06
	vol $3
	note $3a $03
	wait1 $02
	vol $6
	note $3a $07
	wait1 $06
	vol $3
	note $3a $03
	wait1 $02
	vol $6
	note $39 $07
	wait1 $06
	vol $3
	note $39 $07
	wait1 $07
	vol $2
	note $39 $07
	wait1 $02
	vol $6
	note $3e $1c
	wait1 $08
	note $36 $07
	wait1 $06
	vol $3
	note $36 $07
	wait1 $07
	vol $2
	note $36 $07
	wait1 $02
	vol $6
	note $3e $07
	wait1 $06
	vol $3
	note $3e $03
	wait1 $02
	vol $6
	note $3e $07
	wait1 $06
	vol $3
	note $3e $03
	wait1 $02
	vol $6
	note $36 $07
	wait1 $06
	vol $3
	note $36 $07
	wait1 $07
	vol $2
	note $36 $07
	wait1 $02
	vol $6
	note $3e $1c
	wait1 $08
	note $36 $15
	wait1 $06
	note $37 $07
	wait1 $02
	note $39 $24
	vol $3
	note $39 $12
	wait1 $12
	goto musicf1239
	cmdff
; $f137d
; @addr{f137d}
sound26Channel0:
	vibrato $00
	env $0 $00
	duty $02
musicf1383:
	vol $0
	note $20 $12
	vol $6
	note $26 $07
	wait1 $02
	note $25 $07
	wait1 $02
	note $26 $07
	wait1 $0b
	vol $6
	note $32 $07
	wait1 $06
	vol $3
	note $32 $07
	wait1 $07
	vol $2
	note $32 $07
	wait1 $02
	vol $6
	note $26 $07
	wait1 $02
	note $25 $07
	wait1 $02
	note $26 $07
	wait1 $0b
	vol $6
	note $32 $07
	wait1 $06
	vol $3
	note $32 $07
	wait1 $07
	vol $2
	note $32 $07
	wait1 $02
	vol $6
	note $26 $07
	wait1 $02
	note $25 $07
	wait1 $02
	note $26 $07
	wait1 $02
	note $25 $07
	wait1 $02
	note $26 $07
	wait1 $02
	note $25 $07
	wait1 $06
	vol $4
	note $25 $07
	wait1 $07
	vol $6
	note $20 $0e
	wait1 $04
	note $21 $07
	wait1 $06
	vol $3
	note $21 $03
	wait1 $02
	vol $6
	note $32 $07
	wait1 $06
	vol $3
	note $32 $07
	wait1 $07
	vol $2
	note $32 $07
	wait1 $92
	vol $6
	note $21 $07
	wait1 $02
	note $25 $07
	wait1 $02
	note $26 $07
	wait1 $06
	vol $3
	note $26 $07
	wait1 $07
	vol $6
	note $20 $07
	wait1 $06
	vol $3
	note $20 $07
	wait1 $07
	vol $6
	note $20 $07
	wait1 $02
	note $25 $07
	wait1 $02
	note $26 $07
	wait1 $06
	vol $3
	note $26 $03
	wait1 $02
	vol $6
	note $20 $07
	wait1 $06
	vol $3
	note $20 $07
	wait1 $07
	vol $2
	note $20 $07
	wait1 $02
	vol $6
	note $21 $07
	wait1 $02
	note $25 $07
	wait1 $02
	note $26 $07
	wait1 $06
	vol $3
	note $26 $07
	wait1 $07
	vol $6
	note $20 $07
	wait1 $02
	note $21 $07
	wait1 $02
	note $22 $07
	wait1 $02
	note $23 $07
	wait1 $02
	note $25 $07
	wait1 $02
	note $26 $07
	wait1 $06
	vol $3
	note $26 $07
	wait1 $07
	vol $2
	note $26 $07
	wait1 $02
	vol $6
	note $3a $1c
	wait1 $08
	note $32 $07
	wait1 $06
	vol $3
	note $32 $07
	wait1 $07
	vol $2
	note $32 $07
	wait1 $02
	vol $6
	note $3a $07
	wait1 $06
	vol $3
	note $3a $03
	wait1 $02
	vol $6
	note $3a $07
	wait1 $06
	vol $3
	note $3a $03
	wait1 $02
	vol $6
	note $32 $07
	wait1 $06
	vol $3
	note $32 $07
	wait1 $07
	vol $2
	note $32 $07
	wait1 $02
	vol $6
	note $3a $1c
	wait1 $08
	note $32 $15
	wait1 $06
	note $34 $07
	wait1 $02
	note $36 $24
	vol $3
	note $36 $12
	wait1 $12
	goto musicf1383
	cmdff
; $f14b9
; @addr{f14b9}
sound26Channel4:
	cmdf2
musicf14ba:
	duty $0e
	note $1a $09
	wait1 $1b
	note $21 $09
	wait1 $1b
	note $15 $09
	wait1 $1b
	note $21 $09
	wait1 $1b
	note $1a $09
	wait1 $1b
	note $21 $09
	wait1 $1b
	note $15 $09
	wait1 $1b
	note $21 $09
	wait1 $1b
	duty $0e
	note $2b $24
	note $2a $09
	wait1 $1b
	duty $0e
	note $2b $09
	wait1 $09
	note $2b $09
	wait1 $09
	note $2a $09
	wait1 $09
	note $21 $04
	note $1f $05
	note $1e $04
	note $1c $05
	note $1a $24
	note $21 $09
	wait1 $09
	note $21 $09
	wait1 $09
	note $15 $09
	wait1 $1b
	note $21 $09
	wait1 $1b
	note $1a $24
	note $21 $09
	wait1 $09
	note $21 $09
	wait1 $09
	note $15 $09
	wait1 $09
	note $15 $09
	wait1 $09
	note $1a $09
	wait1 $ff
	wait1 $2a
	duty $0e
	note $15 $04
	note $16 $05
	note $17 $04
	note $19 $05
	goto musicf14ba
	cmdff
; $f1532
sound18Start:
; @addr{f1532}
sound18Channel1:
	cmdf2
	vibrato $00
	env $0 $00
	duty $01
musicf1539:
	vol $6
	note $27 $21
	vol $4
	note $27 $0b
	vol $6
	note $29 $21
	vol $4
	note $29 $0b
	vol $6
	note $2e $42
	vol $4
	note $2e $16
	vol $6
	note $27 $21
	vol $4
	note $27 $0b
	vol $6
	note $29 $21
	vol $4
	note $29 $0b
	vol $6
	note $2f $42
	vol $4
	note $2f $16
	vol $6
	note $27 $21
	vol $4
	note $27 $0b
	vol $6
	note $29 $21
	vol $4
	note $29 $0b
	vol $6
	note $31 $21
	vol $4
	note $31 $0b
	vol $6
	note $2f $21
	vol $4
	note $2f $0b
	vol $6
	note $2c $21
	vol $4
	note $2c $0b
	vol $6
	note $2e $21
	vol $4
	note $2e $0b
	wait1 $0e
	vol $4
	note $22 $0b
	note $23 $0b
	vol $4
	note $22 $0b
	note $23 $0b
	note $27 $0b
	note $28 $0b
	note $27 $0b
	vol $4
	note $28 $0b
	note $2e $0b
	note $2f $0b
	note $33 $0b
	note $34 $0b
	note $3a $0b
	note $3b $0b
	note $3f $08
	vol $6
	note $28 $21
	vol $2
	note $28 $0b
	vol $6
	note $2a $21
	vol $4
	note $2a $0b
	vol $6
	note $2f $42
	vol $3
	note $2f $16
	vol $6
	note $28 $21
	vol $4
	note $28 $0b
	vol $6
	note $2a $21
	vol $4
	note $2a $0b
	vol $6
	note $31 $42
	vol $3
	note $31 $16
	vol $6
	note $2f $21
	vol $4
	note $2f $0b
	vol $6
	note $31 $21
	vol $4
	note $31 $0b
	vol $6
	note $33 $21
	vol $4
	note $33 $0b
	vol $6
	note $36 $21
	vol $4
	note $36 $0b
	vol $6
	note $34 $21
	vol $4
	note $34 $0b
	vol $6
	note $39 $2c
	wait1 $0b
	vol $4
	note $1d $0b
	note $1e $0b
	note $1d $0b
	note $1e $0b
	note $22 $0b
	note $23 $0b
	note $22 $0b
	note $23 $0b
	note $29 $0b
	note $2a $0b
	note $2e $0b
	note $2f $0b
	note $35 $0b
	note $36 $0b
	note $3c $0b
	note $3d $0b
	wait1 $05
	vol $2
	note $3d $0b
	wait1 $06
	vol $1
	note $3d $0b
	wait1 $2c
	goto musicf1539
	cmdff
; $f161c
; @addr{f161c}
sound18Channel0:
	cmdf2
	vibrato $00
	env $0 $00
	duty $02
musicf1623:
	vol $6
	note $3a $05
	wait1 $06
	note $35 $05
	vol $2
	note $3a $06
	vol $6
	note $33 $05
	vol $2
	note $35 $06
	vol $6
	note $35 $05
	vol $2
	note $33 $06
	vol $6
	note $2e $05
	vol $2
	note $35 $06
	vol $6
	note $33 $05
	vol $2
	note $2e $06
	vol $6
	note $35 $05
	vol $2
	note $33 $06
	vol $6
	note $33 $05
	vol $2
	note $35 $06
	vol $6
	note $3a $05
	vol $2
	note $33 $06
	vol $6
	note $35 $05
	vol $2
	note $3a $06
	vol $6
	note $33 $05
	vol $2
	note $35 $06
	vol $6
	note $35 $05
	vol $2
	note $33 $06
	vol $6
	note $2e $05
	vol $2
	note $35 $06
	vol $6
	note $33 $05
	vol $2
	note $2e $06
	vol $6
	note $35 $05
	vol $2
	note $33 $06
	vol $6
	note $33 $05
	vol $2
	note $35 $06
	vol $6
	note $3a $05
	vol $2
	note $33 $06
	vol $6
	note $35 $05
	vol $2
	note $3a $06
	vol $6
	note $33 $05
	vol $2
	note $35 $06
	vol $6
	note $35 $05
	vol $2
	note $33 $06
	vol $6
	note $2e $05
	vol $2
	note $35 $06
	vol $6
	note $33 $05
	vol $2
	note $2e $06
	vol $6
	note $35 $05
	vol $2
	note $33 $06
	vol $6
	note $33 $05
	vol $2
	note $35 $06
	vol $6
	note $3b $05
	vol $2
	note $33 $06
	vol $6
	note $35 $05
	vol $2
	note $3b $06
	vol $6
	note $33 $05
	vol $2
	note $35 $06
	vol $6
	note $35 $05
	vol $2
	note $33 $06
	vol $6
	note $2f $05
	vol $2
	note $35 $06
	vol $6
	note $33 $05
	vol $2
	note $2f $06
	vol $6
	note $35 $05
	vol $2
	note $33 $06
	vol $6
	note $33 $05
	vol $2
	note $35 $06
	vol $6
	note $3a $05
	vol $2
	note $33 $06
	vol $6
	note $35 $05
	vol $2
	note $3a $06
	vol $6
	note $33 $05
	vol $2
	note $35 $06
	vol $6
	note $35 $05
	vol $2
	note $33 $06
	vol $6
	note $2e $05
	vol $2
	note $35 $06
	vol $6
	note $33 $05
	vol $2
	note $2e $06
	vol $6
	note $35 $05
	vol $2
	note $33 $06
	vol $6
	note $33 $05
	vol $2
	note $35 $06
	vol $6
	note $3a $05
	vol $2
	note $33 $06
	vol $6
	note $35 $05
	vol $2
	note $3a $06
	vol $6
	note $33 $05
	vol $2
	note $35 $06
	vol $6
	note $35 $05
	vol $2
	note $33 $06
	vol $6
	note $2e $05
	vol $2
	note $35 $06
	vol $6
	note $33 $05
	vol $2
	note $2e $06
	vol $6
	note $35 $05
	vol $2
	note $33 $06
	vol $6
	note $33 $05
	vol $2
	note $35 $06
	vol $6
	note $3a $05
	wait1 $06
	note $35 $05
	vol $2
	note $3a $06
	vol $6
	note $33 $05
	vol $2
	note $35 $06
	vol $6
	note $35 $05
	vol $2
	note $33 $06
	vol $6
	note $2e $05
	vol $2
	note $35 $06
	vol $6
	note $33 $05
	vol $2
	note $2e $06
	vol $6
	note $34 $05
	vol $2
	note $33 $06
	vol $6
	note $33 $05
	vol $2
	note $34 $06
	vol $5
	note $22 $0b
	note $23 $0b
	note $22 $0b
	note $23 $0b
	note $27 $0b
	note $28 $0b
	note $27 $0b
	note $28 $0b
	note $2e $0b
	note $2f $0b
	note $33 $0b
	note $34 $0b
	note $3a $0b
	note $3b $0b
	note $3f $0b
	note $40 $0b
	vol $6
	note $3b $05
	wait1 $06
	note $36 $05
	vol $2
	note $3b $06
	vol $6
	note $34 $05
	vol $2
	note $36 $06
	vol $6
	note $36 $05
	vol $2
	note $34 $06
	vol $6
	note $2f $05
	vol $2
	note $36 $06
	vol $6
	note $34 $05
	vol $2
	note $2f $06
	vol $6
	note $36 $05
	vol $2
	note $34 $06
	vol $6
	note $34 $05
	vol $2
	note $36 $06
	vol $6
	note $3b $05
	vol $2
	note $34 $06
	vol $6
	note $36 $05
	vol $2
	note $3b $06
	vol $6
	note $34 $05
	vol $2
	note $36 $06
	vol $6
	note $36 $05
	vol $2
	note $34 $06
	vol $6
	note $2f $05
	vol $2
	note $36 $06
	vol $6
	note $34 $05
	vol $2
	note $2f $06
	vol $6
	note $36 $05
	vol $2
	note $34 $06
	vol $6
	note $34 $05
	vol $2
	note $36 $06
	vol $6
	note $3b $05
	vol $2
	note $34 $06
	vol $6
	note $36 $05
	vol $2
	note $3b $06
	vol $6
	note $34 $05
	vol $2
	note $36 $06
	vol $6
	note $36 $05
	vol $2
	note $34 $06
	vol $6
	note $2f $05
	vol $2
	note $36 $06
	vol $6
	note $34 $05
	vol $2
	note $2f $06
	vol $6
	note $36 $05
	vol $2
	note $34 $06
	vol $6
	note $34 $05
	vol $2
	note $36 $06
	vol $6
	note $3b $05
	vol $2
	note $34 $06
	vol $6
	note $36 $05
	vol $2
	note $3b $06
	vol $6
	note $34 $05
	vol $2
	note $36 $06
	vol $6
	note $36 $05
	vol $2
	note $34 $06
	vol $6
	note $2f $05
	vol $2
	note $36 $06
	vol $6
	note $34 $05
	vol $2
	note $2f $06
	vol $6
	note $36 $05
	vol $2
	note $34 $06
	vol $6
	note $34 $05
	vol $2
	note $36 $06
	vol $6
	note $3d $05
	vol $2
	note $34 $06
	vol $6
	note $38 $05
	vol $2
	note $3d $06
	vol $6
	note $36 $05
	vol $2
	note $38 $06
	vol $6
	note $38 $05
	vol $2
	note $36 $06
	vol $6
	note $31 $05
	vol $2
	note $38 $06
	vol $6
	note $36 $05
	vol $2
	note $31 $06
	vol $6
	note $38 $05
	vol $2
	note $36 $06
	vol $6
	note $36 $05
	vol $2
	note $38 $06
	vol $6
	note $3f $05
	vol $2
	note $36 $06
	vol $6
	note $39 $05
	vol $2
	note $3f $06
	vol $6
	note $38 $05
	vol $2
	note $39 $06
	vol $6
	note $39 $05
	vol $2
	note $38 $06
	vol $6
	note $32 $05
	vol $2
	note $39 $06
	vol $6
	note $38 $05
	vol $2
	note $32 $06
	vol $6
	note $39 $05
	vol $2
	note $38 $06
	vol $6
	note $38 $05
	vol $2
	note $39 $06
	vol $6
	note $40 $05
	vol $2
	note $38 $06
	vol $6
	note $3b $05
	vol $2
	note $40 $06
	vol $6
	note $39 $05
	vol $2
	note $3b $06
	vol $6
	note $3b $05
	vol $2
	note $39 $06
	vol $6
	note $34 $05
	vol $2
	note $3b $06
	vol $6
	note $39 $05
	vol $2
	note $34 $06
	vol $6
	note $3b $05
	vol $2
	note $39 $06
	vol $6
	note $39 $05
	vol $2
	note $3b $06
	vol $5
	note $1d $0b
	note $1e $0b
	note $1d $0b
	note $1e $0b
	note $22 $0b
	note $23 $0b
	note $22 $0b
	note $23 $0b
	note $29 $0b
	note $2a $0b
	note $2e $0b
	note $2f $0b
	note $35 $0b
	note $36 $0b
	note $3c $0b
	note $3d $0b
	wait1 $58
	goto musicf1623
	cmdff
; $f1905
; @addr{f1905}
sound18Channel4:
musicf1905:
	duty $0e
	note $22 $2c
	note $23 $2c
	note $29 $42
	wait1 $16
	note $22 $2c
	note $23 $2c
	note $2a $42
	wait1 $16
	note $22 $2c
	note $23 $2c
	note $2c $2c
	note $2a $2c
	note $27 $2c
	note $28 $58
	wait1 $84
	note $23 $2c
	note $25 $2c
	note $28 $42
	wait1 $16
	note $23 $2c
	note $25 $2c
	note $2b $42
	wait1 $16
	note $2a $2c
	note $2c $2c
	note $2d $2c
	note $32 $2c
	note $30 $2c
	note $34 $2c
	note $36 $58
	wait1 $b0
	goto musicf1905
	cmdff
; $f1949
; @addr{f1949}
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
	wait1 $58
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
	wait1 $58
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
	wait1 $58
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
	wait1 $b0
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
	wait1 $58
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
	wait1 $58
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
	wait1 $58
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
	wait1 $b0
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
; $f1a2c
sound16Start:
; @addr{f1a2c}
sound16Channel1:
	vibrato $e1
	env $0 $00
	duty $02
musicf1a32:
	vol $0
	note $20 $16
	vol $6
	note $27 $16
	note $2a $16
	note $2c $16
	note $2e $16
	note $2c $16
	note $2a $16
	note $29 $16
	note $2e $16
	note $2c $16
	note $2a $16
	note $29 $16
	note $2a $16
	note $27 $16
	note $2c $16
	note $2e $16
	note $2f $2c
	vibrato $01
	vol $3
	note $2f $16
	vibrato $e1
	vol $6
	note $2e $16
	note $2c $2c
	vibrato $01
	vol $3
	note $2c $16
	vibrato $e1
	vol $6
	note $2a $16
	note $2c $2c
	note $2a $16
	note $2c $16
	note $2e $2c
	vibrato $01
	vol $3
	note $2e $2c
	vibrato $e1
	vol $6
	note $2f $2c
	note $31 $16
	note $33 $0b
	note $2f $0b
	note $2e $2c
	vibrato $01
	vol $3
	note $2e $16
	vibrato $e1
	vol $6
	note $2e $16
	note $2c $2c
	note $29 $16
	note $2c $16
	note $2e $16
	vol $3
	note $2e $16
	wait1 $16
	vol $6
	note $2e $16
	note $2f $16
	note $2e $16
	note $2f $16
	note $2e $16
	note $2f $16
	note $2e $16
	note $2f $16
	note $2e $16
	note $22 $0b
	note $24 $0b
	note $26 $0b
	note $27 $0b
	note $29 $0b
	note $27 $0b
	note $26 $0b
	note $24 $0b
	note $22 $0b
	wait1 $05
	vol $3
	note $22 $0b
	wait1 $06
	vol $1
	note $22 $0b
	wait1 $2c
	vol $6
	note $2e $16
	note $2c $16
	note $2a $16
	note $29 $16
	note $2a $16
	note $27 $16
	note $2c $16
	note $2e $16
	note $2f $16
	note $2e $16
	note $2c $16
	note $2a $16
	note $2c $16
	note $29 $16
	note $2c $16
	note $2e $16
	note $31 $0b
	note $2f $0b
	note $2e $0b
	note $2c $0b
	note $2e $0b
	note $2c $0b
	note $2a $0b
	note $2c $0b
	note $2a $0b
	note $29 $0b
	note $27 $0b
	note $29 $0b
	note $26 $0b
	note $27 $0b
	note $29 $0b
	note $2a $0b
	note $2c $2c
	note $2e $16
	note $2f $16
	note $2e $2c
	vibrato $01
	vol $3
	note $2e $2b
	wait1 $01
	vibrato $e1
	goto musicf1a32
	cmdff
; $f1b24
; @addr{f1b24}
sound16Channel0:
	vibrato $e1
	env $0 $00
	duty $02
musicf1b2a:
	vol $0
	note $20 $16
	vol $6
	note $22 $16
	note $27 $16
	note $29 $16
	note $2a $16
	note $29 $16
	note $27 $16
	note $26 $16
	note $2a $16
	note $29 $16
	note $27 $16
	note $26 $16
	note $27 $16
	note $22 $16
	note $27 $16
	note $2a $16
	note $2c $2c
	vibrato $01
	vol $3
	note $2c $16
	vibrato $e1
	vol $6
	note $2a $16
	note $29 $2c
	vibrato $01
	vol $3
	note $29 $16
	vibrato $e1
	vol $6
	note $27 $16
	note $29 $0b
	wait1 $05
	vol $3
	note $29 $0b
	wait1 $06
	vol $1
	note $29 $0b
	vol $6
	note $27 $0b
	wait1 $05
	vol $3
	note $27 $0b
	wait1 $06
	vol $1
	note $27 $0b
	vol $6
	note $26 $0b
	note $24 $0b
	note $22 $0b
	note $21 $0b
	note $22 $0b
	note $24 $0b
	note $26 $0b
	note $29 $0b
	note $20 $0b
	wait1 $05
	vol $3
	note $20 $06
	vol $6
	note $23 $0b
	wait1 $05
	vol $3
	note $23 $06
	vol $6
	note $20 $0b
	wait1 $05
	vol $3
	note $20 $06
	vol $6
	note $23 $0b
	wait1 $05
	vol $3
	note $23 $06
	vol $6
	note $22 $0b
	note $23 $0b
	note $22 $0b
	note $21 $0b
	note $22 $0b
	note $26 $0b
	note $29 $0b
	note $2e $0b
	note $29 $0b
	wait1 $05
	vol $3
	note $29 $06
	vol $6
	note $27 $0b
	wait1 $05
	vol $3
	note $27 $06
	vol $6
	note $26 $0b
	wait1 $05
	vol $3
	note $26 $06
	vol $6
	note $24 $0b
	wait1 $05
	vol $3
	note $24 $06
	vol $6
	note $22 $0b
	note $23 $0b
	note $22 $0b
	note $23 $0b
	note $22 $0b
	note $26 $0b
	note $29 $0b
	note $2e $0b
	note $2c $0b
	note $2b $0b
	note $2a $0b
	note $2b $0b
	note $2c $0b
	note $2b $0b
	note $2a $0b
	note $2b $0b
	note $2c $0b
	note $2b $0b
	note $2a $0b
	note $29 $0b
	note $28 $0b
	note $27 $0b
	note $26 $0b
	note $25 $0b
	note $26 $0b
	note $27 $0b
	note $29 $0b
	note $2a $0b
	note $2c $0b
	note $2a $0b
	note $29 $0b
	note $27 $0b
	note $26 $0b
	note $29 $0b
	note $2c $0b
	note $2f $0b
	note $2e $0b
	wait1 $05
	vol $3
	note $2e $0b
	wait1 $06
	vol $1
	note $2e $0b
	vol $6
	note $2a $16
	note $29 $16
	note $27 $16
	note $26 $16
	note $27 $0b
	wait1 $05
	vol $3
	note $27 $06
	vol $6
	note $22 $0b
	wait1 $05
	vol $3
	note $22 $06
	vol $6
	note $27 $0b
	wait1 $05
	vol $3
	note $27 $06
	vol $6
	note $22 $0b
	wait1 $05
	vol $3
	note $22 $06
	vol $6
	note $2c $16
	note $2a $16
	note $29 $16
	note $27 $16
	note $29 $0b
	wait1 $05
	vol $3
	note $29 $06
	vol $6
	note $26 $0b
	wait1 $05
	vol $3
	note $26 $06
	vol $6
	note $29 $0b
	wait1 $05
	vol $3
	note $29 $06
	vol $6
	note $26 $0b
	wait1 $05
	vol $3
	note $26 $06
	vol $6
	note $1d $42
	note $1e $16
	note $20 $16
	note $22 $16
	note $23 $16
	note $24 $16
	note $25 $16
	note $26 $16
	note $27 $2c
	note $26 $16
	note $24 $16
	note $22 $2c
	goto musicf1b2a
	cmdff
; $f1c9f
; @addr{f1c9f}
sound16Channel4:
musicf1c9f:
	duty $0e
	note $0f $2c
	note $10 $2c
	note $0f $2c
	note $10 $2c
	note $0f $2c
	note $10 $2c
	note $0f $2c
	note $10 $2c
	note $11 $42
	note $0f $16
	note $0e $42
	note $0c $16
	note $0a $16
	wait1 $16
	note $11 $16
	wait1 $16
	note $16 $16
	note $15 $03
	note $14 $03
	note $13 $05
	note $12 $03
	note $11 $03
	note $10 $05
	note $0a $0e
	wait1 $1e
	note $14 $2c
	note $15 $2c
	note $16 $16
	note $0a $0b
	note $0b $0b
	note $0a $0b
	note $0b $0b
	note $0a $0b
	wait1 $0b
	note $11 $37
	note $0f $0b
	note $0e $0b
	note $0b $0b
	note $0a $0e
	wait1 $08
	note $11 $0b
	note $15 $0b
	note $16 $0e
	wait1 $1e
	note $10 $16
	note $0f $16
	note $0e $16
	note $0f $16
	note $10 $16
	note $0f $16
	note $10 $16
	note $0f $16
	note $16 $2c
	note $15 $03
	note $14 $03
	note $13 $05
	note $12 $03
	note $11 $03
	note $10 $05
	note $0f $03
	note $0e $03
	note $0d $05
	note $0c $03
	note $0b $08
	note $0a $16
	wait1 $16
	note $0a $16
	wait1 $16
	note $0f $0b
	wait1 $0b
	note $0f $21
	wait1 $0b
	note $0f $1b
	wait1 $06
	note $0f $0b
	note $12 $0b
	note $14 $0b
	note $16 $0b
	note $14 $0b
	note $12 $0b
	note $0f $0b
	note $11 $0b
	wait1 $0b
	note $11 $21
	wait1 $0b
	note $11 $1b
	wait1 $06
	note $11 $0b
	note $12 $0b
	note $14 $0b
	note $16 $0b
	note $14 $0b
	note $12 $0b
	note $11 $0b
	note $0a $0b
	note $0f $0b
	note $11 $0b
	note $14 $0b
	note $16 $0b
	note $14 $0b
	note $11 $0b
	note $0f $0b
	note $0a $0b
	note $0e $0b
	note $11 $0b
	note $14 $0b
	note $16 $0b
	note $14 $0b
	note $11 $0b
	note $0e $0b
	note $0a $0b
	note $0e $0b
	note $11 $0b
	note $14 $0b
	note $16 $0b
	note $17 $0b
	note $16 $0b
	note $17 $0b
	note $16 $0b
	note $17 $0b
	note $16 $0b
	note $17 $0b
	note $16 $0b
	note $11 $0b
	note $0e $0b
	note $0a $0b
	goto musicf1c9f
	cmdff
; $f1da1
; @addr{f1da1}
sound16Channel6:
musicf1da1:
	vol $6
	note $24 $16
	vol $4
	note $2e $16
	wait1 $16
	note $2a $16
	vol $6
	note $24 $16
	vol $4
	note $2e $16
	wait1 $16
	vol $4
	note $2a $16
	vol $6
	note $24 $16
	vol $4
	note $2e $16
	wait1 $16
	note $2a $16
	vol $6
	note $24 $16
	vol $4
	note $2e $16
	wait1 $16
	vol $4
	note $2a $16
	vol $4
	note $2e $0b
	wait1 $0b
	note $2a $0b
	note $2a $0b
	note $2a $0b
	wait1 $21
	note $2e $0b
	wait1 $0b
	vol $4
	note $2a $0b
	vol $4
	note $2a $0b
	note $2a $0b
	wait1 $21
	vol $6
	note $24 $16
	vol $4
	note $2e $16
	wait1 $16
	note $2a $16
	vol $6
	note $24 $16
	vol $4
	note $2e $16
	wait1 $16
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
	wait1 $42
	vol $6
	note $24 $16
	vol $4
	note $2a $16
	vol $4
	note $2e $16
	wait1 $16
	vol $6
	note $24 $0b
	vol $4
	note $2a $0b
	note $2e $16
	wait1 $0b
	note $2a $0b
	note $2e $16
	vol $6
	note $24 $0b
	vol $4
	note $2a $0b
	note $2e $16
	wait1 $0b
	note $2a $0b
	vol $4
	note $2e $16
	vol $6
	note $24 $0b
	vol $4
	note $2a $0b
	note $2e $16
	wait1 $0b
	note $2a $0b
	note $2e $16
	vol $6
	note $24 $0b
	vol $4
	note $2a $0b
	note $2e $16
	wait1 $0b
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
	wait1 $0b
	note $2a $0b
	note $2a $0b
	vol $4
	note $2e $0b
	wait1 $0b
	goto musicf1da1
	cmdff
; $f1ec7
sound28Start:
; @addr{f1ec7}
sound28Channel1:
	cmdf2
	vibrato $e1
	env $0 $00
	duty $02
musicf1ece:
	vol $6
	note $20 $24
	note $1f $24
	note $23 $36
	note $22 $12
	note $20 $12
	note $1f $12
	note $23 $12
	note $22 $12
	note $20 $12
	note $1f $12
	note $23 $12
	note $22 $12
	note $27 $24
	note $26 $24
	note $2a $36
	note $29 $12
	note $27 $12
	note $26 $12
	note $2a $12
	note $29 $12
	note $27 $12
	note $26 $12
	note $2e $12
	note $2c $12
	note $2e $24
	note $2d $24
	note $31 $36
	note $30 $12
	note $2e $12
	note $2d $12
	note $31 $12
	note $30 $12
	note $2e $12
	note $2d $12
	note $35 $12
	note $34 $12
	note $35 $36
	note $36 $12
	note $34 $12
	note $36 $12
	note $35 $12
	note $34 $12
	note $35 $28
	wait1 $0e
	note $35 $04
	wait1 $01
	note $39 $05
	wait1 $03
	note $3c $05
	vol $5
	note $41 $04
	wait1 $05
	vol $4
	note $41 $04
	wait1 $05
	vol $3
	note $41 $04
	wait1 $05
	vol $2
	note $41 $04
	wait1 $29
	vol $6
	note $22 $1b
	note $29 $09
	note $28 $1b
	wait1 $09
	note $22 $1b
	note $27 $09
	note $25 $1b
	wait1 $09
	note $22 $1b
	note $29 $09
	note $28 $1b
	note $22 $04
	wait1 $05
	note $22 $1b
	note $27 $09
	note $25 $1b
	wait1 $09
	note $29 $12
	note $28 $12
	note $29 $12
	note $2c $24
	note $2b $12
	note $29 $12
	note $28 $12
	note $29 $6c
	wait1 $24
	goto musicf1ece
	cmdff
; $f1f7e
; @addr{f1f7e}
sound28Channel0:
	cmdf2
	vibrato $e1
	env $0 $00
	duty $02
musicf1f85:
	vol $6
	note $1c $24
	vol $6
	note $1b $24
	note $1f $36
	note $1e $12
	note $1c $12
	note $1b $12
	note $1f $12
	note $1e $12
	note $1c $12
	note $1b $12
	note $1f $12
	note $1e $12
	note $23 $24
	note $22 $24
	note $27 $36
	note $26 $12
	note $24 $12
	note $23 $12
	note $27 $12
	note $26 $12
	note $20 $12
	note $1f $12
	note $26 $12
	note $25 $12
	note $26 $24
	note $25 $24
	note $2b $36
	note $2a $12
	note $28 $12
	note $27 $12
	note $2b $12
	note $2a $12
	note $28 $12
	note $27 $12
	note $31 $12
	note $30 $12
	vol $6
	note $24 $09
	note $25 $09
	note $23 $09
	note $24 $09
	note $25 $09
	note $23 $09
	note $25 $09
	note $24 $09
	note $24 $12
	note $25 $12
	note $24 $12
	note $23 $12
	note $1c $09
	note $1d $09
	note $23 $09
	note $24 $09
	note $28 $09
	note $29 $09
	note $2f $09
	note $30 $09
	note $34 $09
	note $35 $09
	note $2f $09
	note $30 $09
	note $33 $04
	note $31 $05
	note $2f $04
	note $2d $05
	note $2c $04
	note $2a $05
	note $27 $04
	note $26 $05
	vol $6
	note $1d $09
	vol $6
	note $22 $09
	vol $6
	note $1d $09
	note $25 $09
	note $24 $12
	note $1d $09
	vol $6
	note $23 $09
	vol $6
	note $1d $09
	vol $6
	note $22 $09
	vol $6
	note $1d $09
	note $24 $09
	note $22 $12
	note $1d $09
	vol $6
	note $1c $09
	vol $6
	note $1d $09
	vol $6
	note $22 $09
	vol $6
	note $1d $09
	note $25 $09
	note $24 $12
	note $1d $09
	note $1c $09
	note $1d $12
	note $1c $09
	note $23 $09
	note $22 $1b
	wait1 $09
	note $25 $12
	note $24 $12
	note $25 $12
	note $31 $04
	note $32 $05
	note $33 $04
	note $34 $05
	note $35 $12
	note $34 $12
	note $32 $12
	note $34 $15
	wait1 $01
	note $34 $05
	note $35 $04
	note $30 $05
	note $31 $04
	note $2d $05
	note $2e $04
	note $28 $05
	note $29 $04
	note $24 $05
	note $25 $04
	note $21 $05
	note $22 $04
	note $1c $05
	note $1d $04
	note $1c $05
	note $1d $09
	note $1c $03
	wait1 $03
	vol $5
	note $1c $03
	vol $6
	note $22 $09
	note $21 $03
	wait1 $03
	vol $4
	note $21 $03
	vol $6
	note $25 $09
	note $24 $03
	wait1 $03
	vol $4
	note $24 $03
	vol $6
	note $2a $09
	note $29 $03
	wait1 $03
	vol $4
	note $29 $03
	goto musicf1f85
	cmdff
; $f20b0
; @addr{f20b0}
sound28Channel4:
musicf20b0:
	duty $18
	note $0d $09
	duty $0f
	note $0d $09
	duty $18
	note $0d $09
	duty $0f
	note $0d $09
	wait1 $5a
	duty $18
	note $0d $04
	wait1 $05
	note $0d $04
	wait1 $05
	note $0d $09
	duty $0f
	note $0d $09
	duty $18
	note $0d $09
	duty $0f
	note $0d $09
	wait1 $5a
	duty $18
	note $0d $04
	wait1 $05
	note $0d $04
	wait1 $05
	note $0d $09
	duty $0f
	note $0d $09
	duty $18
	note $0d $09
	duty $0f
	note $0d $09
	wait1 $5a
	duty $18
	note $0d $04
	wait1 $05
	note $0d $04
	wait1 $05
	note $0d $09
	duty $0f
	note $0d $09
	duty $18
	note $0d $09
	duty $0f
	note $0d $09
	wait1 $5a
	duty $18
	note $0d $04
	wait1 $05
	note $0d $04
	wait1 $05
	note $0d $09
	duty $0f
	note $0d $09
	duty $18
	note $0d $09
	duty $0f
	note $0d $09
	wait1 $5a
	duty $18
	note $0d $04
	wait1 $05
	note $0d $04
	wait1 $05
	note $0d $09
	duty $0f
	note $0d $09
	duty $18
	note $0d $09
	duty $0f
	note $0d $09
	wait1 $5a
	duty $18
	note $0d $04
	wait1 $05
	note $0d $04
	wait1 $05
	vol $8
	note $05 $04
	wait1 $05
	note $05 $04
	wait1 $05
	note $05 $04
	wait1 $05
	note $05 $04
	wait1 $05
	duty $18
	note $08 $09
	vol $8
	note $05 $04
	wait1 $05
	note $05 $04
	wait1 $05
	note $05 $04
	wait1 $05
	duty $18
	note $09 $09
	vol $8
	note $05 $04
	wait1 $05
	note $05 $04
	wait1 $05
	note $05 $04
	wait1 $05
	duty $18
	note $0b $09
	vol $8
	note $05 $04
	wait1 $05
	note $05 $04
	wait1 $05
	note $05 $04
	wait1 $05
	note $05 $04
	wait1 $05
	note $05 $04
	wait1 $05
	note $05 $04
	wait1 $05
	note $05 $04
	wait1 $05
	duty $18
	note $08 $09
	vol $8
	note $05 $04
	wait1 $05
	note $05 $04
	wait1 $05
	note $05 $04
	wait1 $05
	duty $18
	note $09 $09
	vol $8
	note $05 $04
	wait1 $05
	note $05 $04
	wait1 $05
	note $05 $04
	wait1 $05
	duty $18
	note $0b $09
	vol $8
	note $05 $04
	wait1 $05
	duty $18
	note $0c $09
	vol $8
	note $05 $04
	wait1 $05
	duty $18
	note $0a $09
	duty $0f
	note $0a $09
	duty $18
	note $0a $09
	duty $0f
	note $0a $09
	wait1 $24
	duty $18
	note $0a $09
	duty $0f
	note $0a $09
	duty $18
	note $0a $09
	duty $0f
	note $0a $09
	wait1 $12
	duty $18
	note $0a $04
	wait1 $05
	note $0a $04
	wait1 $05
	note $0a $09
	duty $0f
	note $0a $09
	duty $18
	note $0a $09
	duty $0f
	note $0a $09
	wait1 $24
	duty $18
	note $0a $09
	duty $0f
	note $0a $09
	duty $18
	note $0a $09
	duty $0f
	note $0a $09
	wait1 $12
	duty $18
	note $0a $04
	wait1 $05
	note $0a $04
	wait1 $05
	note $00 $09
	duty $0f
	note $00 $09
	duty $18
	note $00 $09
	duty $0f
	note $00 $09
	wait1 $24
	duty $18
	note $0c $09
	duty $0f
	note $0c $09
	duty $18
	note $0c $09
	duty $0f
	note $0c $09
	wait1 $24
	duty $18
	note $11 $12
	duty $0f
	note $11 $12
	duty $18
	note $11 $12
	duty $0f
	note $11 $12
	duty $18
	note $11 $09
	duty $0f
	note $11 $09
	duty $18
	note $11 $09
	duty $0f
	note $11 $09
	duty $18
	note $11 $09
	duty $0f
	note $11 $09
	duty $18
	note $11 $09
	duty $0f
	note $11 $09
	goto musicf20b0
	cmdff
; $f2286
; @addr{f2286}
sound28Channel6:
musicf2286:
	vol $6
	note $24 $12
	note $24 $12
	wait1 $5a
	note $24 $09
	note $24 $09
	note $24 $12
	note $24 $12
	wait1 $5a
	note $24 $09
	note $24 $09
	note $24 $12
	note $24 $12
	wait1 $5a
	note $24 $09
	note $24 $09
	note $24 $12
	note $24 $12
	wait1 $5a
	note $24 $09
	note $24 $09
	note $24 $12
	note $24 $12
	wait1 $5a
	note $24 $09
	note $24 $09
	note $24 $12
	note $24 $12
	wait1 $5a
	note $24 $09
	note $24 $09
	note $24 $24
	note $24 $24
	note $24 $24
	note $24 $24
	note $24 $09
	vol $2
	note $2e $09
	wait1 $09
	vol $2
	note $2e $09
	vol $6
	note $24 $09
	vol $2
	note $2e $09
	wait1 $09
	vol $2
	note $2e $09
	vol $6
	note $24 $09
	vol $3
	note $2e $09
	wait1 $09
	vol $3
	note $2e $09
	vol $6
	note $24 $09
	vol $3
	note $2e $09
	wait1 $09
	vol $3
	note $2e $09
	vol $6
	note $24 $09
	wait1 $09
	vol $3
	note $2e $09
	wait1 $09
	vol $6
	note $24 $09
	wait1 $09
	vol $3
	note $2e $09
	wait1 $09
	vol $6
	note $24 $09
	wait1 $09
	vol $3
	note $2e $09
	wait1 $09
	vol $6
	note $24 $09
	wait1 $09
	vol $3
	note $2e $09
	vol $6
	note $24 $09
	note $24 $09
	wait1 $09
	vol $3
	note $2e $09
	wait1 $09
	vol $6
	note $24 $09
	wait1 $09
	vol $3
	note $2e $09
	wait1 $09
	vol $6
	note $24 $09
	wait1 $09
	vol $3
	note $2e $09
	wait1 $09
	vol $6
	note $24 $09
	wait1 $09
	vol $3
	note $2e $09
	vol $6
	note $24 $09
	note $24 $09
	wait1 $09
	vol $3
	note $2e $09
	wait1 $09
	vol $6
	note $24 $09
	wait1 $09
	vol $3
	note $2e $09
	wait1 $09
	vol $6
	note $24 $09
	wait1 $09
	vol $3
	note $2e $09
	wait1 $09
	vol $6
	note $24 $09
	wait1 $09
	vol $3
	note $2e $09
	vol $6
	note $24 $09
	note $24 $09
	wait1 $09
	vol $3
	note $2e $09
	wait1 $09
	vol $6
	note $24 $09
	wait1 $09
	vol $3
	note $2e $09
	wait1 $09
	vol $6
	note $24 $09
	vol $3
	note $2e $09
	wait1 $09
	note $2e $09
	vol $6
	note $24 $09
	vol $3
	note $2e $09
	wait1 $09
	note $2e $09
	goto musicf2286
	cmdff
; $f239a
sound30Start:
; @addr{f239a}
sound30Channel1:
	cmdf2
	vibrato $e1
	env $0 $00
	duty $02
musicf23a1:
	vol $6
	note $3b $1c
	vol $6
	note $3a $12
	note $3b $0a
	note $34 $1c
	note $33 $12
	note $34 $0a
	note $3a $1c
	note $39 $12
	note $3a $0a
	note $36 $1c
	note $35 $12
	note $36 $0a
	note $3b $1c
	note $3a $12
	note $3b $0a
	note $40 $12
	note $3b $0a
	note $39 $12
	note $38 $0a
	note $35 $2e
	note $2f $05
	wait1 $02
	vol $5
	note $2f $05
	wait1 $02
	vol $3
	note $2f $05
	vol $6
	note $2f $09
	note $35 $0a
	note $3b $04
	wait1 $03
	vol $5
	note $3b $04
	wait1 $03
	vol $3
	note $3b $04
	wait1 $03
	vol $3
	note $3b $04
	wait1 $03
	vol $6
	note $3b $1c
	note $3a $12
	note $3b $0a
	note $34 $0e
	wait1 $04
	note $34 $0a
	note $33 $12
	note $34 $0a
	note $3d $1c
	note $3c $12
	note $3d $0a
	note $36 $0e
	wait1 $04
	note $36 $0a
	note $35 $12
	note $36 $0a
	note $3f $1c
	vol $6
	note $3d $09
	note $3f $09
	note $3d $0a
	note $3b $04
	wait1 $03
	vol $5
	note $3b $04
	wait1 $03
	vol $3
	note $3b $04
	wait1 $0a
	vol $7
	note $35 $04
	wait1 $03
	vol $5
	note $35 $04
	wait1 $03
	vol $3
	note $35 $04
	wait1 $0a
	vol $7
	note $2f $25
	note $33 $09
	note $37 $0a
	vol $6
	note $3b $04
	wait1 $03
	vol $5
	note $3b $04
	wait1 $03
	vol $4
	note $3b $04
	wait1 $03
	vol $3
	note $3b $04
	wait1 $03
	vol $2
	note $3b $04
	wait1 $18
	goto musicf23a1
	cmdff
; $f245a
; @addr{f245a}
sound30Channel0:
	cmdf2
	vibrato $e1
	env $0 $00
	duty $02
musicf2461:
	vol $6
	note $38 $09
	note $37 $09
	note $38 $0a
	note $37 $12
	note $38 $0a
	note $40 $04
	wait1 $05
	vol $5
	note $40 $05
	wait1 $04
	vol $3
	note $40 $05
	wait1 $21
	vol $6
	note $36 $09
	note $35 $09
	note $36 $0a
	note $35 $12
	note $36 $0a
	note $33 $04
	wait1 $05
	vol $4
	note $33 $05
	wait1 $04
	vol $3
	note $33 $05
	wait1 $21
	vol $6
	note $38 $09
	vol $6
	note $37 $09
	note $38 $0a
	note $37 $12
	vol $6
	note $38 $0a
	note $3b $04
	wait1 $05
	vol $5
	note $3b $05
	wait1 $04
	vol $4
	note $3b $05
	wait1 $2a
	vol $6
	note $2f $09
	note $33 $0a
	vol $6
	note $37 $09
	note $3b $09
	note $3f $0a
	note $43 $04
	wait1 $03
	vol $5
	note $43 $04
	wait1 $03
	vol $4
	note $43 $04
	wait1 $26
	vol $8
	note $38 $09
	vol $6
	note $37 $09
	note $38 $0a
	vol $7
	note $37 $12
	vol $6
	note $38 $0a
	vol $6
	note $34 $02
	wait1 $02
	vol $5
	note $34 $03
	wait1 $02
	vol $4
	note $34 $02
	wait1 $03
	vol $3
	note $34 $02
	wait1 $02
	vol $6
	note $3a $0a
	note $3b $04
	wait1 $03
	vol $5
	note $3b $04
	wait1 $03
	vol $3
	note $3b $04
	wait1 $0a
	vol $6
	note $3a $09
	note $39 $09
	note $3a $0a
	note $39 $12
	note $3a $0a
	vol $6
	note $36 $02
	wait1 $02
	vol $5
	note $36 $03
	wait1 $02
	vol $4
	note $36 $02
	wait1 $03
	vol $3
	note $36 $02
	wait1 $02
	vol $6
	note $3c $0a
	note $3d $04
	wait1 $03
	vol $5
	note $3d $04
	wait1 $03
	vol $4
	note $3d $04
	wait1 $03
	vol $3
	note $3d $04
	wait1 $03
	vol $6
	note $3b $04
	wait1 $03
	vol $5
	note $3b $04
	wait1 $03
	vol $4
	note $3b $04
	wait1 $03
	vol $3
	note $3b $02
	wait1 $05
	vol $6
	note $3a $09
	note $3b $09
	note $3a $0a
	vol $6
	note $37 $04
	wait1 $03
	vol $5
	note $37 $04
	wait1 $03
	vol $4
	note $37 $04
	wait1 $0a
	vol $7
	note $36 $04
	wait1 $03
	vol $5
	note $36 $04
	wait1 $03
	vol $3
	note $36 $04
	wait1 $0a
	vol $7
	note $2e $04
	wait1 $03
	vol $5
	note $2e $04
	wait1 $03
	vol $3
	note $2e $04
	wait1 $03
	vol $2
	note $2e $04
	wait1 $03
	vol $6
	note $2a $04
	wait1 $05
	note $2f $05
	wait1 $04
	note $33 $05
	wait1 $0e
	note $3f $05
	wait1 $04
	note $43 $05
	wait1 $05
	note $47 $04
	wait1 $03
	vol $5
	note $47 $04
	wait1 $03
	vol $4
	note $47 $04
	wait1 $03
	vol $3
	note $47 $04
	wait1 $03
	goto musicf2461
	cmdff
; $f25a9
; @addr{f25a9}
sound30Channel4:
musicf25a9:
	duty $18
	note $1c $07
	duty $2b
	note $1c $07
	wait1 $2a
	duty $18
	note $17 $07
	duty $2b
	note $17 $07
	wait1 $2a
	duty $18
	note $1e $07
	duty $2b
	note $1e $07
	wait1 $2a
	duty $18
	note $23 $07
	duty $2b
	note $23 $07
	wait1 $2a
	duty $18
	note $1c $07
	duty $2b
	note $1c $07
	wait1 $2a
	duty $18
	note $17 $07
	duty $2b
	note $17 $07
	wait1 $2a
	duty $18
	note $18 $2e
	note $17 $0a
	duty $2b
	note $17 $09
	wait1 $2f
	duty $18
	note $1c $07
	duty $2b
	note $1c $07
	wait1 $2a
	duty $18
	note $17 $07
	duty $2b
	note $17 $07
	wait1 $2a
	duty $18
	note $1e $07
	duty $2b
	note $1e $07
	wait1 $2a
	duty $18
	note $19 $07
	duty $2b
	note $19 $07
	wait1 $2a
	duty $18
	note $23 $07
	duty $2b
	note $23 $07
	wait1 $0e
	duty $18
	note $1e $07
	duty $2b
	note $1e $07
	wait1 $0e
	duty $18
	note $17 $07
	duty $2b
	note $17 $07
	wait1 $0e
	duty $18
	note $11 $07
	duty $2b
	note $11 $07
	wait1 $0e
	duty $18
	note $17 $07
	duty $2b
	note $17 $07
	wait1 $46
	duty $18
	note $17 $07
	duty $2b
	note $17 $07
	wait1 $0e
	goto musicf25a9
	cmdff
; $f2659
; @addr{f2659}
sound30Channel6:
musicf2659:
	vol $6
	note $24 $09
	wait1 $09
	vol $3
	note $2a $0a
	note $2e $09
	wait1 $09
	vol $3
	note $2a $0a
	vol $6
	note $24 $09
	wait1 $09
	vol $3
	note $2a $0a
	note $2e $09
	wait1 $13
	vol $6
	note $24 $09
	wait1 $09
	vol $3
	note $2a $0a
	note $2e $09
	wait1 $09
	vol $3
	note $2a $0a
	vol $6
	note $24 $09
	wait1 $09
	vol $3
	note $2a $0a
	note $2e $09
	wait1 $13
	vol $6
	note $24 $09
	wait1 $09
	vol $3
	note $2a $0a
	note $2e $09
	wait1 $09
	vol $3
	note $2a $0a
	vol $6
	note $24 $09
	wait1 $09
	vol $3
	note $2a $0a
	note $2e $09
	wait1 $13
	vol $6
	note $24 $09
	wait1 $09
	vol $3
	note $2a $0a
	note $2e $09
	wait1 $09
	vol $3
	note $2a $0a
	vol $6
	note $24 $09
	wait1 $09
	vol $3
	note $2a $0a
	note $2e $09
	wait1 $13
	vol $6
	note $24 $09
	wait1 $09
	vol $3
	note $2a $0a
	note $2e $09
	wait1 $09
	vol $3
	note $2a $0a
	vol $6
	note $24 $09
	wait1 $09
	vol $3
	note $2a $0a
	note $2e $09
	wait1 $13
	vol $6
	note $24 $09
	wait1 $09
	vol $3
	note $2a $0a
	note $2e $09
	wait1 $09
	vol $3
	note $2a $0a
	vol $6
	note $24 $09
	wait1 $09
	vol $3
	note $2a $0a
	note $2e $09
	wait1 $13
	vol $6
	note $24 $09
	wait1 $09
	vol $3
	note $2a $0a
	note $2e $09
	wait1 $09
	vol $3
	note $2a $0a
	vol $6
	note $24 $09
	wait1 $09
	vol $3
	note $2a $0a
	note $2e $09
	wait1 $13
	vol $6
	note $24 $09
	wait1 $09
	vol $3
	note $2a $0a
	note $2e $09
	wait1 $09
	vol $3
	note $2a $0a
	vol $6
	note $24 $09
	wait1 $09
	vol $3
	note $2a $0a
	note $2e $09
	wait1 $13
	goto musicf2659
	cmdff
; $f2735
sound35Start:
; @addr{f2735}
sound35Channel1:
	vibrato $e1
	env $0 $00
	duty $01
	vol $6
	note $27 $04
	note $22 $05
	note $27 $05
	note $2c $04
	note $25 $05
	note $2c $05
	note $31 $04
	note $2a $05
	note $31 $05
	note $36 $04
	note $2f $05
	note $36 $05
	note $35 $1c
	vibrato $01
	vol $3
	note $35 $07
	wait1 $15
	vibrato $e1
musicf275f:
	vol $6
	note $27 $07
	wait1 $03
	vol $3
	note $27 $04
	vol $6
	note $27 $03
	vol $3
	note $27 $04
	vol $6
	note $27 $03
	vol $3
	note $27 $04
	vol $6
	note $2e $11
	vol $3
	note $2e $07
	wait1 $04
	vol $6
	note $2d $07
	wait1 $03
	vol $3
	note $2d $04
	vol $6
	note $2d $07
	note $2a $07
	note $26 $07
	wait1 $03
	vol $3
	note $26 $04
	vol $6
	note $2d $07
	wait1 $03
	vol $3
	note $2d $04
	vol $6
	note $27 $07
	wait1 $03
	vol $3
	note $27 $04
	vol $6
	note $27 $03
	vol $3
	note $27 $04
	vol $6
	note $27 $03
	vol $3
	note $27 $04
	vol $6
	note $2e $11
	vol $3
	note $2e $07
	wait1 $04
	vol $6
	note $2d $07
	wait1 $03
	vol $3
	note $2d $04
	vol $6
	note $2d $03
	vol $3
	note $2d $04
	vol $6
	note $2d $03
	vol $3
	note $2d $04
	vol $6
	note $32 $07
	wait1 $03
	vol $3
	note $32 $04
	vol $6
	note $2d $07
	wait1 $03
	vol $3
	note $2d $04
	vol $6
	note $2c $07
	wait1 $03
	vol $3
	note $2c $04
	vol $6
	note $2c $03
	vol $3
	note $2c $04
	vol $6
	note $2c $03
	vol $3
	note $2c $04
	vol $6
	note $31 $07
	wait1 $03
	vol $3
	note $31 $04
	vol $6
	note $2c $07
	wait1 $03
	vol $3
	note $2c $04
	vol $6
	note $2b $07
	wait1 $03
	vol $3
	note $2b $04
	vol $6
	note $2b $03
	vol $3
	note $2b $04
	vol $6
	note $2b $07
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
	note $2a $07
	wait1 $03
	vol $3
	note $2a $04
	vol $6
	note $2f $07
	wait1 $03
	vol $3
	note $2f $04
	vol $6
	note $29 $07
	wait1 $03
	vol $3
	note $29 $04
	vol $6
	note $2e $07
	wait1 $03
	vol $3
	note $2e $04
	vol $6
	note $28 $07
	note $27 $07
	note $26 $07
	note $25 $07
	note $24 $11
	vol $3
	note $24 $07
	wait1 $04
	vol $6
	note $27 $07
	wait1 $03
	vol $3
	note $27 $04
	vol $6
	note $27 $03
	vol $3
	note $27 $04
	vol $6
	note $27 $07
	note $2e $0e
	vol $3
	note $2e $07
	wait1 $07
	vol $6
	note $2d $03
	vol $3
	note $2d $04
	vol $6
	note $2d $03
	vol $3
	note $2d $04
	vol $6
	note $2d $07
	wait1 $03
	vol $3
	note $2d $04
	vol $6
	note $26 $0e
	note $25 $07
	wait1 $03
	vol $3
	note $25 $04
	vol $6
	note $27 $07
	wait1 $03
	vol $3
	note $27 $04
	vol $6
	note $27 $03
	vol $3
	note $27 $04
	vol $6
	note $27 $07
	note $2e $0e
	vol $3
	note $2e $07
	wait1 $07
	vol $6
	note $2d $03
	vol $3
	note $2d $04
	vol $6
	note $2d $03
	vol $3
	note $2d $04
	vol $6
	note $2d $07
	wait1 $03
	vol $3
	note $2d $04
	vol $6
	note $34 $07
	note $33 $07
	note $32 $07
	vol $3
	note $32 $07
	vol $6
	note $30 $07
	wait1 $03
	vol $3
	note $30 $04
	vol $6
	note $30 $03
	wait1 $04
	note $30 $07
	note $2b $07
	wait1 $03
	vol $3
	note $2b $04
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
	note $2f $03
	vol $3
	note $2f $04
	vol $6
	note $2f $03
	vol $3
	note $2f $04
	vol $6
	note $34 $07
	wait1 $03
	vol $3
	note $34 $04
	vol $6
	note $2f $07
	wait1 $03
	vol $3
	note $2f $04
	vol $6
	note $2e $0e
	vol $3
	note $2e $07
	wait1 $07
	vol $6
	note $2e $07
	note $2d $07
	note $2c $07
	note $2b $07
	note $2a $07
	wait1 $03
	vol $3
	note $2a $07
	wait1 $04
	vol $1
	note $2a $07
	vol $6
	note $2e $11
	vol $3
	note $2e $07
	wait1 $04
	goto musicf275f
	cmdff
; $f2922
; @addr{f2922}
sound35Channel0:
	vol $0
	note $20 $07
	vibrato $e1
	env $0 $00
	duty $01
	vol $5
	note $27 $04
	note $22 $05
	note $27 $05
	note $2c $04
	note $25 $05
	note $2c $05
	note $31 $04
	note $2a $05
	note $31 $05
	note $36 $04
	note $2f $05
	note $36 $05
	note $35 $1c
	vibrato $01
	vol $2
	note $35 $07
	wait1 $0e
	vibrato $e1
musicf294f:
	vol $6
	note $1f $07
	wait1 $03
	vol $3
	note $1f $04
	vol $6
	note $1f $03
	vol $3
	note $1f $04
	vol $6
	note $1f $03
	vol $3
	note $1f $04
	vol $6
	note $27 $11
	vol $3
	note $27 $07
	wait1 $04
	vol $6
	note $2a $07
	wait1 $03
	vol $3
	note $2a $04
	vol $6
	note $2a $07
	note $26 $07
	note $21 $07
	wait1 $03
	vol $3
	note $21 $04
	vol $6
	note $26 $07
	wait1 $03
	vol $3
	note $26 $04
	vol $6
	note $1f $07
	wait1 $03
	vol $3
	note $1f $04
	vol $6
	note $1f $03
	wait1 $04
	note $1f $03
	wait1 $04
	note $27 $11
	vol $3
	note $27 $07
	wait1 $04
	vol $6
	note $28 $07
	wait1 $03
	vol $3
	note $28 $04
	vol $6
	note $28 $03
	vol $3
	note $28 $04
	vol $6
	note $28 $03
	vol $3
	note $28 $04
	vol $6
	note $2d $07
	wait1 $03
	vol $3
	note $2d $04
	vol $6
	note $28 $07
	wait1 $03
	vol $3
	note $28 $04
	vol $6
	note $25 $07
	wait1 $03
	vol $3
	note $25 $04
	vol $6
	note $25 $03
	vol $3
	note $25 $04
	vol $6
	note $25 $03
	vol $3
	note $25 $04
	vol $6
	note $2c $07
	note $29 $07
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
	note $24 $03
	vol $3
	note $24 $04
	vol $6
	note $24 $03
	vol $3
	note $24 $04
	vol $6
	note $2d $07
	note $29 $07
	note $23 $07
	wait1 $03
	vol $3
	note $23 $04
	vol $6
	note $27 $07
	wait1 $03
	vol $3
	note $27 $04
	vol $6
	note $2b $07
	wait1 $03
	vol $3
	note $2b $04
	vol $6
	note $26 $07
	wait1 $03
	vol $3
	note $26 $04
	vol $6
	note $2a $07
	wait1 $03
	vol $3
	note $2a $04
	vol $6
	note $25 $07
	note $24 $07
	note $23 $07
	note $22 $07
	note $21 $11
	vol $3
	note $21 $07
	wait1 $04
	vol $6
	note $22 $07
	wait1 $03
	vol $3
	note $22 $04
	vol $6
	note $22 $03
	vol $3
	note $22 $04
	vol $6
	note $22 $03
	vol $3
	note $22 $04
	wait1 $07
	vol $6
	note $22 $07
	note $27 $07
	note $2b $07
	vol $6
	note $2a $03
	vol $3
	note $2a $04
	vol $6
	note $2a $03
	vol $3
	note $2a $04
	vol $6
	note $2a $03
	vol $3
	note $2a $04
	vol $6
	note $28 $07
	note $21 $07
	note $22 $07
	note $23 $07
	note $21 $07
	note $1f $07
	wait1 $03
	vol $3
	note $1f $04
	vol $6
	note $1f $03
	vol $3
	note $1f $04
	vol $6
	note $1f $03
	vol $3
	note $1f $04
	vol $6
	note $1f $07
	note $22 $07
	note $1f $07
	note $22 $07
	note $2a $03
	vol $3
	note $2a $04
	vol $6
	note $2a $03
	vol $3
	note $2a $04
	vol $6
	note $2a $07
	wait1 $03
	vol $3
	note $2a $04
	vol $6
	note $26 $07
	wait1 $03
	vol $3
	note $26 $04
	vol $6
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
	note $2b $03
	vol $3
	note $2b $04
	vol $6
	note $2b $03
	vol $3
	note $2b $04
	vol $6
	note $24 $07
	note $28 $07
	note $2b $07
	vol $3
	note $2b $07
	vol $6
	note $27 $07
	wait1 $03
	vol $3
	note $27 $04
	vol $6
	note $27 $03
	vol $3
	note $27 $04
	vol $6
	note $27 $03
	vol $3
	note $27 $04
	vol $6
	note $2b $07
	note $28 $07
	note $23 $07
	vol $3
	note $23 $07
	vol $6
	note $2a $0e
	vol $3
	note $2a $07
	wait1 $07
	vol $6
	note $2a $07
	note $29 $07
	note $28 $07
	note $27 $07
	note $26 $07
	vol $3
	note $26 $07
	wait1 $0e
	vol $6
	note $26 $11
	vol $3
	note $26 $07
	wait1 $04
	goto musicf294f
	cmdff
; $f2b0c
; @addr{f2b0c}
sound35Channel4:
	wait1 $70
musicf2b0e:
	duty $0e
	note $0f $07
	wait1 $0e
	note $0f $07
	note $16 $07
	wait1 $07
	note $0f $07
	wait1 $07
	note $0e $07
	wait1 $0e
	note $12 $07
	note $15 $07
	wait1 $07
	note $0e $07
	wait1 $07
	note $0f $07
	wait1 $0e
	note $0f $07
	note $16 $07
	wait1 $07
	note $0f $07
	wait1 $07
	note $0e $07
	wait1 $0e
	note $12 $07
	note $15 $07
	wait1 $07
	note $0e $07
	wait1 $07
	note $0d $0e
	wait1 $07
	note $0d $07
	note $14 $07
	wait1 $07
	note $0d $07
	wait1 $07
	note $0c $0e
	wait1 $07
	note $0c $07
	note $13 $07
	wait1 $07
	note $0c $07
	wait1 $07
	note $14 $07
	wait1 $07
	note $13 $07
	wait1 $07
	note $12 $07
	wait1 $07
	note $11 $07
	wait1 $23
	note $0a $15
	note $0c $03
	note $0e $04
	note $0f $0e
	wait1 $07
	note $0f $07
	note $16 $0e
	wait1 $07
	note $16 $07
	note $0e $0e
	wait1 $07
	note $12 $07
	note $15 $0e
	wait1 $07
	note $15 $07
	note $0f $0e
	wait1 $07
	note $0f $07
	note $16 $0e
	wait1 $07
	note $0f $07
	note $17 $0e
	wait1 $07
	note $14 $07
	note $10 $0e
	wait1 $07
	note $14 $07
	note $18 $0e
	wait1 $07
	note $18 $07
	note $12 $07
	wait1 $07
	note $17 $07
	note $12 $07
	note $17 $0e
	wait1 $07
	note $17 $07
	note $11 $07
	wait1 $07
	note $16 $07
	note $11 $07
	note $0b $0e
	wait1 $0e
	note $0b $07
	note $0c $07
	note $0d $07
	note $0e $07
	note $0f $07
	wait1 $15
	note $0a $15
	note $0c $03
	note $0e $04
	goto musicf2b0e
	cmdff
; $f2be0
; @addr{f2be0}
sound35Channel6:
	wait1 $69
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
	wait1 $07
	vol $6
	note $26 $07
	vol $2
	note $2a $07
	note $2e $07
	wait1 $07
	vol $6
	note $24 $07
	vol $2
	note $2a $07
	note $2e $07
	wait1 $07
	vol $6
	note $26 $07
	vol $2
	note $2a $07
	note $2e $07
	wait1 $07
	vol $6
	note $24 $07
	vol $2
	note $2a $07
	note $2e $07
	wait1 $07
	vol $6
	note $26 $07
	vol $2
	note $2a $07
	note $2e $07
	wait1 $07
	vol $6
	note $24 $07
	vol $2
	note $2a $07
	note $2e $07
	wait1 $07
	vol $6
	note $26 $07
	vol $2
	note $2a $07
	note $2e $07
	wait1 $07
	vol $6
	note $24 $07
	vol $2
	note $2a $07
	note $2e $07
	wait1 $07
	vol $6
	note $26 $07
	vol $2
	note $2a $07
	note $2e $07
	wait1 $07
	vol $6
	note $24 $07
	vol $2
	note $2a $07
	note $2e $07
	wait1 $07
	vol $6
	note $26 $07
	vol $2
	note $2a $07
	note $2e $07
	wait1 $07
	note $2a $07
	wait1 $07
	note $2a $07
	wait1 $07
	note $2a $07
	wait1 $07
	note $2a $07
	wait1 $07
	note $2e $07
	wait1 $15
	vol $6
	note $24 $07
	wait1 $0e
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
	wait1 $07
	note $2a $07
	note $2a $07
	note $2a $07
	note $2a $07
	note $2a $07
	note $2a $07
	note $2a $07
	wait1 $07
	vol $6
	note $26 $04
	vol $5
	note $26 $05
	vol $4
	note $26 $05
	vol $6
	note $26 $07
	wait1 $07
	vol $2
	note $2a $07
	note $2a $07
	goto musicf2be8
	cmdff
; $f2d21
sound13Start:
; @addr{f2d21}
sound13Channel1:
	vibrato $00
	env $0 $00
	duty $02
musicf2d27:
	vol $5
	note $2e $07
	wait1 $03
	vol $3
	note $2e $07
	wait1 $04
	vol $1
	note $2e $07
	vol $5
	note $35 $07
	wait1 $03
	vol $2
	note $35 $07
	wait1 $04
	vol $1
	note $35 $07
	wait1 $1c
	vol $5
	note $34 $07
	wait1 $03
	vol $2
	note $34 $07
	wait1 $04
	vol $1
	note $34 $07
	vol $5
	note $35 $07
	wait1 $03
	vol $2
	note $35 $07
	wait1 $04
	vol $1
	note $35 $07
	wait1 $1c
	vol $5
	note $38 $07
	wait1 $03
	vol $2
	note $38 $07
	wait1 $04
	vol $1
	note $38 $07
	vol $5
	note $47 $02
	wait1 $01
	vol $2
	note $47 $02
	wait1 $02
	vol $1
	note $47 $02
	wait1 $01
	vol $0
	note $47 $02
	wait1 $2c
	vol $5
	note $37 $07
	wait1 $03
	vol $2
	note $37 $07
	wait1 $04
	vol $1
	note $37 $07
	vol $5
	note $46 $02
	wait1 $01
	vol $2
	note $46 $02
	wait1 $02
	vol $1
	note $46 $02
	wait1 $01
	vol $0
	note $46 $02
	wait1 $2c
	vol $5
	note $34 $38
	note $35 $07
	wait1 $03
	vol $3
	note $35 $07
	wait1 $04
	vol $1
	note $35 $07
	vol $5
	note $53 $02
	wait1 $01
	vol $2
	note $53 $02
	wait1 $02
	vol $1
	note $53 $02
	wait1 $01
	vol $0
	note $53 $02
	wait1 $48
	vol $5
	note $35 $07
	wait1 $03
	vol $3
	note $35 $07
	wait1 $04
	vol $1
	note $35 $07
	vol $5
	note $34 $07
	wait1 $03
	vol $3
	note $34 $07
	wait1 $04
	vol $2
	note $34 $07
	wait1 $03
	vol $2
	note $34 $07
	wait1 $12
	vol $5
	note $33 $07
	wait1 $03
	vol $3
	note $33 $07
	wait1 $04
	vol $1
	note $33 $07
	vol $5
	note $32 $07
	wait1 $03
	vol $3
	note $32 $07
	wait1 $04
	vol $2
	note $32 $07
	wait1 $03
	vol $2
	note $32 $07
	wait1 $12
	vol $5
	note $31 $07
	wait1 $03
	vol $2
	note $31 $07
	wait1 $04
	vol $1
	note $31 $07
	vol $4
	note $41 $02
	wait1 $02
	vol $4
	note $47 $03
	wait1 $02
	vol $3
	note $47 $02
	wait1 $03
	vol $3
	note $47 $02
	wait1 $28
	vol $5
	note $30 $07
	wait1 $03
	vol $3
	note $30 $07
	wait1 $04
	vol $2
	note $30 $07
	wait1 $03
	vol $2
	note $30 $07
	wait1 $12
	vol $5
	note $46 $02
	wait1 $02
	vol $5
	note $40 $03
	wait1 $02
	vol $3
	note $40 $02
	wait1 $03
	vol $3
	note $40 $02
	wait1 $02
	vol $2
	note $40 $03
	wait1 $07
	vol $5
	note $1c $07
	note $1d $07
	note $28 $07
	note $29 $07
	note $34 $07
	note $35 $07
	note $40 $07
	note $41 $07
	note $4c $07
	note $4d $07
	note $47 $07
	note $48 $07
	note $45 $03
	note $44 $04
	note $43 $03
	note $42 $04
	note $41 $03
	wait1 $01
	vol $3
	note $41 $04
	wait1 $01
	vol $2
	note $41 $03
	wait1 $72
	goto musicf2d27
	cmdff
; $f2e87
; @addr{f2e87}
sound13Channel0:
	vibrato $00
	env $0 $00
	duty $02
musicf2e8d:
	vol $0
	note $20 $1c
	vol $5
	note $31 $07
	wait1 $03
	vol $2
	note $31 $07
	wait1 $04
	vol $1
	note $31 $07
	wait1 $1c
	vol $5
	note $30 $07
	wait1 $03
	vol $2
	note $30 $07
	wait1 $04
	vol $1
	note $30 $07
	vol $5
	note $31 $07
	wait1 $03
	vol $2
	note $31 $07
	wait1 $04
	vol $1
	note $31 $07
	wait1 $1c
	vol $5
	note $32 $07
	wait1 $03
	vol $2
	note $32 $07
	wait1 $04
	vol $1
	note $32 $07
	vol $5
	note $4d $02
	wait1 $02
	vol $3
	note $4d $03
	wait1 $02
	vol $2
	note $4d $02
	wait1 $03
	vol $1
	note $4d $02
	wait1 $28
	vol $5
	note $31 $07
	wait1 $03
	vol $2
	note $31 $07
	wait1 $04
	vol $1
	note $31 $07
	vol $5
	note $4c $02
	wait1 $02
	vol $3
	note $4c $03
	wait1 $02
	vol $2
	note $4c $02
	wait1 $03
	vol $1
	note $4c $02
	wait1 $28
	vol $5
	note $31 $38
	note $32 $07
	wait1 $03
	vol $2
	note $32 $07
	wait1 $04
	vol $1
	note $32 $07
	vol $5
	note $41 $02
	wait1 $02
	vol $3
	note $41 $03
	wait1 $02
	vol $2
	note $41 $02
	wait1 $03
	vol $1
	note $41 $02
	wait1 $44
	vol $5
	note $32 $07
	wait1 $03
	vol $2
	note $32 $07
	wait1 $04
	vol $1
	note $32 $07
	vol $5
	note $31 $07
	wait1 $03
	vol $3
	note $31 $07
	wait1 $04
	vol $3
	note $31 $07
	wait1 $03
	vol $2
	note $31 $07
	wait1 $12
	vol $5
	note $30 $07
	wait1 $03
	vol $2
	note $30 $07
	wait1 $04
	vol $1
	note $30 $07
	vol $5
	note $2f $07
	wait1 $03
	vol $3
	note $2f $07
	wait1 $04
	vol $3
	note $2f $07
	wait1 $03
	vol $2
	note $2f $07
	wait1 $12
	vol $5
	note $2e $07
	wait1 $03
	vol $3
	note $2e $07
	wait1 $04
	vol $3
	note $2e $07
	wait1 $03
	vol $2
	note $2e $04
	vol $4
	note $4d $03
	wait1 $01
	vol $4
	note $53 $03
	wait1 $02
	vol $2
	note $53 $02
	wait1 $03
	vol $2
	note $53 $02
	wait1 $21
	vol $5
	note $2d $07
	wait1 $03
	vol $3
	note $2d $07
	wait1 $04
	vol $3
	note $2d $07
	wait1 $03
	vol $2
	note $2d $07
	wait1 $19
	vol $5
	note $3a $02
	wait1 $02
	vol $5
	note $34 $03
	wait1 $02
	vol $3
	note $34 $02
	wait1 $03
	vol $2
	note $34 $02
	wait1 $02
	vol $2
	note $34 $03
	wait1 $0b
	vol $4
	note $1c $07
	note $1d $07
	note $28 $07
	note $29 $07
	note $34 $07
	note $35 $07
	note $40 $07
	note $41 $07
	note $4c $07
	note $4d $07
	note $47 $07
	note $48 $07
	note $45 $04
	note $44 $03
	note $43 $04
	vol $2
	note $42 $03
	vol $2
	note $41 $03
	wait1 $70
	goto musicf2e8d
	cmdff
; $f2fe0
; @addr{f2fe0}
sound13Channel4:
musicf2fe0:
	wait1 $c4
	duty $0e
	note $0e $54
	note $0d $2a
	note $0c $07
	note $0b $07
	note $0a $3f
	note $09 $07
	note $08 $07
	note $07 $07
	note $06 $46
	duty $0f
	note $06 $07
	wait1 $07
	duty $0e
	note $0d $38
	note $15 $38
	note $14 $38
	note $09 $38
	note $19 $38
	note $18 $38
	note $06 $38
	note $05 $38
	wait1 $70
	goto musicf2fe0
	cmdff
; $f3014
; @addr{f3014}
sound13Channel6:
musicf3014:
	wait1 $38
	vol $2
	note $2a $0e
	note $2a $0e
	wait1 $38
	note $2e $0e
	wait1 $0e
	note $2a $0e
	wait1 $46
	note $2a $0e
	wait1 $62
	note $2a $0e
	note $2a $0e
	note $2e $0e
	wait1 $0e
	note $2a $0e
	wait1 $62
	note $2a $0e
	wait1 $0e
	note $2e $0e
	wait1 $0e
	note $2a $0e
	wait1 $46
	note $2a $0e
	note $2a $0e
	note $2e $0e
	wait1 $2a
	note $2a $0e
	wait1 $46
	note $2a $0e
	note $2a $0e
	wait1 $38
	note $2a $07
	note $2a $0e
	wait1 $23
	note $2a $0e
	note $2a $0e
	wait1 $1c
	note $2e $0e
	wait1 $0e
	goto musicf3014
	cmdff
; $f3067
sound14Start:
; @addr{f3067}
sound14Channel1:
	cmdf2
	vibrato $00
	env $0 $00
	duty $02
musicf306e:
	vol $6
	note $27 $07
	wait1 $03
	vol $3
	note $27 $07
	wait1 $04
	vol $2
	note $27 $07
	vol $6
	note $27 $07
	wait1 $03
	vol $3
	note $27 $07
	wait1 $04
	vol $2
	note $27 $07
	vol $6
	note $2a $07
	wait1 $03
	vol $3
	note $2a $07
	wait1 $04
	vol $2
	note $2a $07
	wait1 $1c
	vol $6
	note $27 $07
	wait1 $03
	vol $3
	note $27 $07
	wait1 $04
	vol $2
	note $27 $07
	vol $6
	note $27 $07
	wait1 $03
	vol $3
	note $27 $07
	wait1 $04
	vol $2
	note $27 $07
	vol $6
	note $2a $07
	wait1 $03
	vol $3
	note $2a $07
	wait1 $04
	vol $2
	note $2a $07
	wait1 $1c
	vol $8
	note $27 $07
	wait1 $03
	vol $4
	note $27 $07
	wait1 $04
	vol $2
	note $27 $07
	vol $7
	note $2a $07
	wait1 $03
	vol $4
	note $2a $07
	wait1 $04
	vol $2
	note $2a $07
	vol $7
	note $2b $07
	wait1 $03
	vol $3
	note $2b $07
	wait1 $04
	vol $2
	note $2b $07
	vol $7
	note $2a $07
	wait1 $03
	vol $3
	note $2a $07
	wait1 $04
	vol $2
	note $2a $07
	vol $7
	note $2b $07
	wait1 $03
	vol $3
	note $2b $07
	wait1 $04
	vol $2
	note $2b $07
	vol $7
	note $2a $07
	wait1 $03
	vol $3
	note $2a $07
	wait1 $04
	vol $2
	note $2a $07
	wait1 $38
	vol $6
	note $27 $07
	wait1 $03
	vol $3
	note $27 $07
	wait1 $04
	vol $1
	note $27 $07
	vol $6
	note $27 $07
	wait1 $03
	vol $3
	note $27 $07
	wait1 $04
	vol $2
	note $27 $07
	vol $6
	note $2a $07
	wait1 $03
	vol $3
	note $2a $07
	wait1 $04
	vol $2
	note $2a $07
	wait1 $1c
	vol $6
	note $27 $07
	wait1 $03
	vol $3
	note $27 $04
	vol $6
	note $27 $07
	wait1 $03
	vol $3
	note $27 $04
	vol $6
	note $27 $07
	wait1 $03
	vol $3
	note $27 $04
	vol $6
	note $27 $07
	wait1 $03
	vol $3
	note $27 $04
	vol $6
	note $2a $07
	wait1 $03
	vol $3
	note $2a $07
	wait1 $04
	vol $1
	note $2a $07
	wait1 $1c
	vol $6
	note $27 $07
	wait1 $03
	vol $3
	note $27 $07
	wait1 $04
	vol $1
	note $27 $07
	vol $6
	note $2a $07
	wait1 $03
	vol $3
	note $2a $07
	wait1 $04
	vol $2
	note $2a $07
	vol $6
	note $2b $07
	wait1 $03
	vol $3
	note $2b $07
	wait1 $04
	vol $1
	note $2b $07
	vol $6
	note $2e $07
	wait1 $03
	vol $3
	note $2e $07
	wait1 $04
	vol $1
	note $2e $07
	vol $6
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
	note $2b $07
	wait1 $03
	vol $3
	note $2b $04
	vol $6
	note $2a $07
	wait1 $03
	vol $3
	note $2a $07
	wait1 $04
	vol $2
	note $2a $07
	wait1 $ff
	vol $0
	note $00 $0b
	goto musicf306e
	cmdff
; $f31ca
; @addr{f31ca}
sound14Channel0:
	cmdf2
	vibrato $00
	env $0 $00
	duty $02
musicf31d1:
	vol $6
	note $24 $07
	wait1 $03
	vol $3
	note $24 $07
	wait1 $04
	vol $2
	note $24 $07
	vol $6
	note $24 $07
	wait1 $03
	vol $3
	note $24 $07
	wait1 $04
	vol $2
	note $24 $07
	vol $6
	note $26 $07
	wait1 $03
	vol $3
	note $26 $07
	wait1 $04
	vol $2
	note $26 $07
	wait1 $1c
	vol $6
	note $24 $07
	wait1 $03
	vol $3
	note $24 $07
	wait1 $04
	vol $2
	note $24 $07
	vol $6
	note $24 $07
	wait1 $03
	vol $3
	note $24 $07
	wait1 $04
	vol $2
	note $24 $07
	vol $6
	note $26 $07
	wait1 $03
	vol $3
	note $26 $07
	wait1 $04
	vol $2
	note $26 $07
	wait1 $1c
	vol $6
	note $24 $07
	wait1 $03
	vol $3
	note $24 $07
	wait1 $04
	vol $2
	note $24 $07
	vol $6
	note $26 $07
	wait1 $03
	vol $3
	note $26 $07
	wait1 $04
	vol $2
	note $26 $07
	vol $6
	note $27 $07
	wait1 $03
	vol $3
	note $27 $07
	wait1 $04
	vol $2
	note $27 $07
	vol $6
	note $26 $07
	wait1 $03
	vol $3
	note $26 $07
	wait1 $04
	vol $2
	note $26 $07
	vol $6
	note $27 $07
	wait1 $03
	vol $3
	note $27 $07
	wait1 $04
	vol $2
	note $27 $07
	vol $6
	note $26 $07
	wait1 $03
	vol $3
	note $26 $07
	wait1 $04
	vol $2
	note $26 $07
	wait1 $38
	vol $6
	note $24 $07
	wait1 $03
	vol $3
	note $24 $07
	wait1 $04
	vol $2
	note $24 $07
	vol $6
	note $24 $07
	wait1 $03
	vol $3
	note $24 $07
	wait1 $04
	vol $2
	note $24 $07
	vol $6
	note $26 $07
	wait1 $03
	vol $3
	note $26 $07
	wait1 $04
	vol $2
	note $26 $07
	wait1 $1c
	vol $6
	note $24 $07
	wait1 $03
	vol $3
	note $24 $04
	vol $6
	note $24 $07
	wait1 $03
	vol $3
	note $24 $04
	vol $6
	note $24 $07
	wait1 $03
	vol $3
	note $24 $04
	vol $6
	note $24 $07
	wait1 $03
	vol $3
	note $24 $04
	vol $6
	note $26 $07
	wait1 $03
	vol $3
	note $26 $07
	wait1 $04
	vol $2
	note $26 $04
	wait1 $1f
	vol $6
	note $24 $07
	wait1 $03
	vol $3
	note $24 $07
	wait1 $04
	vol $2
	note $24 $07
	vol $6
	note $26 $07
	wait1 $03
	vol $3
	note $26 $07
	wait1 $04
	vol $2
	note $26 $07
	vol $6
	note $27 $07
	wait1 $03
	vol $3
	note $27 $07
	wait1 $04
	vol $2
	note $27 $07
	vol $6
	note $2a $07
	wait1 $03
	vol $3
	note $2a $07
	wait1 $04
	vol $2
	note $2a $07
	vol $6
	note $2e $07
	wait1 $03
	vol $3
	note $2e $04
	vol $6
	note $2d $07
	wait1 $03
	vol $3
	note $2d $04
	vol $6
	note $27 $07
	wait1 $03
	vol $3
	note $27 $04
	vol $6
	note $26 $07
	wait1 $03
	vol $3
	note $26 $07
	wait1 $04
	vol $2
	note $26 $07
	wait1 $ff
	vol $0
	note $20 $0b
	goto musicf31d1
	cmdff
; $f332d
; @addr{f332d}
sound14Channel4:
musicf332d:
	wait1 $ff
	wait1 $c1
	duty $0e
	note $18 $07
	wait1 $15
	note $18 $07
	wait1 $15
	note $1a $07
	wait1 $31
	note $18 $07
	wait1 $07
	note $18 $07
	wait1 $07
	note $18 $07
	wait1 $07
	note $18 $07
	wait1 $07
	note $1a $07
	wait1 $31
	note $18 $07
	wait1 $15
	note $1a $07
	wait1 $15
	note $1b $07
	wait1 $15
	note $1e $07
	wait1 $15
	note $22 $07
	wait1 $07
	note $21 $07
	wait1 $07
	note $1b $07
	wait1 $07
	note $1a $07
	wait1 $ff
	wait1 $20
	goto musicf332d
	cmdff
; $f3379
; @addr{f3379}
sound14Channel6:
musicf3379:
	wait1 $ff
	wait1 $89
	vol $3
	note $2a $0e
	note $2e $0e
	wait1 $62
	note $2a $0e
	note $2e $0e
	wait1 $54
	note $2a $0e
	note $2e $0e
	wait1 $d2
	note $2a $0e
	note $2a $0e
	note $2e $0e
	wait1 $46
	note $2a $0e
	note $2a $0e
	note $2e $0e
	wait1 $62
	goto musicf3379
	cmdff
; $f33a4
sound17Start:
; @addr{f33a4}
sound17Channel1:
	vibrato $e1
	env $0 $00
	duty $01
musicf33aa:
	vol $6
	note $2d $1a
	note $2c $1a
	note $2b $1a
	note $31 $1a
	note $30 $1a
	note $2a $1a
	note $2f $1a
	note $29 $1a
	note $2e $1a
	note $28 $1a
	note $2d $1a
	note $26 $1a
	vol $3
	note $26 $1a
	vol $6
	note $2d $0d
	note $2c $0d
	note $2b $1a
	note $31 $1a
	note $32 $1a
	note $2d $1a
	note $30 $1a
	note $2c $1a
	note $2f $1a
	note $2b $1a
	note $2e $1a
	note $2a $1a
	note $2d $0d
	note $28 $0d
	note $2c $0d
	note $26 $06
	wait1 $07
	vol $3
	note $26 $06
	wait1 $07
	vol $1
	note $26 $06
	wait1 $07
	vol $6
	note $2d $0d
	note $28 $0d
	note $2c $0d
	note $26 $06
	wait1 $07
	vol $3
	note $26 $06
	wait1 $07
	vol $1
	note $26 $06
	wait1 $07
	vol $6
	note $26 $0d
	note $2c $0d
	note $2d $0d
	note $2e $0d
	note $2f $4e
	note $2e $08
	note $2d $09
	note $2c $09
	note $26 $0d
	wait1 $06
	vol $3
	note $26 $0d
	wait1 $07
	vol $1
	note $26 $0d
	wait1 $06
	vol $0
	note $26 $0d
	wait1 $55
	vol $6
	note $32 $1a
	note $2d $1a
	note $31 $1a
	note $2c $1a
	vol $3
	note $2c $1a
	vol $6
	note $2b $1a
	note $2a $1a
	note $33 $1a
	note $34 $1a
	note $30 $1a
	note $31 $1a
	note $2c $1a
	note $2f $82
	note $2e $08
	note $2d $09
	note $2c $09
	note $26 $08
	wait1 $05
	vol $3
	note $26 $08
	wait1 $05
	vol $1
	note $26 $08
	wait1 $05
	vol $0
	note $26 $08
	wait1 $6d
	vol $6
	note $24 $08
	wait1 $05
	note $24 $08
	wait1 $05
	note $2a $06
	wait1 $07
	vol $3
	note $2a $06
	wait1 $07
	vol $1
	note $2a $06
	wait1 $14
	vol $6
	note $24 $06
	wait1 $07
	note $24 $06
	wait1 $07
	note $2a $06
	wait1 $07
	vol $3
	note $2a $06
	wait1 $07
	vol $1
	note $2a $06
	wait1 $14
	vol $6
	note $24 $06
	wait1 $07
	note $24 $06
	wait1 $07
	note $2a $06
	wait1 $07
	note $2a $06
	wait1 $07
	note $2e $0d
	note $2d $0d
	note $29 $0d
	note $2c $0d
	note $2b $0d
	note $27 $0d
	note $2a $0d
	note $26 $06
	wait1 $07
	vol $5
	note $26 $06
	wait1 $07
	vol $3
	note $26 $06
	wait1 $07
	vol $3
	note $26 $06
	wait1 $07
	vol $2
	note $26 $06
	wait1 $3b
	goto musicf33aa
	cmdff
; $f34cb
; @addr{f34cb}
sound17Channel0:
	vibrato $e1
	env $0 $00
	duty $01
musicf34d1:
	vol $6
	note $29 $1a
	note $28 $1a
	note $27 $1a
	vol $6
	note $2d $1a
	note $2c $1a
	note $26 $1a
	note $2c $1a
	note $25 $1a
	note $2a $1a
	note $24 $1a
	note $29 $1a
	note $23 $1a
	vol $3
	note $23 $1a
	vol $6
	note $29 $0d
	note $28 $0d
	note $27 $1a
	note $2d $1a
	note $2e $1a
	note $29 $1a
	note $2c $1a
	note $28 $1a
	note $2b $1a
	note $27 $1a
	note $2a $1a
	note $26 $1a
	note $29 $0d
	note $30 $0d
	note $28 $0d
	note $2f $06
	wait1 $07
	vol $3
	note $2f $06
	wait1 $07
	vol $1
	note $2f $06
	wait1 $07
	vol $6
	note $29 $0d
	note $24 $0d
	note $28 $0d
	note $22 $06
	wait1 $07
	vol $3
	note $22 $06
	wait1 $07
	vol $1
	note $22 $06
	wait1 $3b
	vol $6
	note $32 $0d
	note $38 $0d
	note $39 $0d
	note $3a $0d
	note $3b $34
	note $3a $08
	note $39 $09
	note $38 $09
	note $32 $08
	wait1 $05
	vol $3
	note $32 $08
	wait1 $05
	vol $1
	note $32 $08
	wait1 $05
	vol $0
	note $32 $08
	wait1 $53
	vol $6
	note $2e $1a
	note $29 $1a
	note $2d $1a
	note $28 $1a
	vol $3
	note $28 $1a
	vol $6
	note $27 $1a
	note $26 $1a
	note $2f $1a
	note $30 $1a
	note $2c $1a
	note $2d $1a
	note $28 $1a
	note $2b $0d
	note $27 $0d
	note $2a $0d
	note $26 $06
	wait1 $07
	vol $3
	note $26 $06
	wait1 $07
	vol $1
	note $26 $06
	wait1 $07
	vol $6
	note $2b $0d
	note $27 $0d
	note $2a $0d
	note $26 $06
	wait1 $07
	vol $3
	note $26 $06
	wait1 $07
	vol $1
	note $26 $06
	wait1 $07
	vol $6
	note $22 $06
	wait1 $07
	vol $3
	note $22 $06
	wait1 $07
	vol $1
	note $22 $06
	wait1 $07
	vol $0
	note $22 $06
	wait1 $6f
	vol $6
	note $20 $06
	wait1 $07
	note $20 $06
	wait1 $07
	note $26 $06
	wait1 $07
	vol $3
	note $26 $06
	wait1 $07
	vol $1
	note $26 $06
	wait1 $07
	vol $0
	note $26 $06
	wait1 $07
	vol $6
	note $20 $06
	wait1 $07
	note $20 $06
	wait1 $07
	note $26 $06
	wait1 $07
	vol $3
	note $26 $06
	wait1 $07
	vol $1
	note $26 $06
	wait1 $07
	vol $0
	note $26 $06
	wait1 $07
	vol $6
	note $20 $06
	wait1 $07
	note $20 $06
	wait1 $07
	note $26 $06
	wait1 $07
	note $26 $06
	wait1 $07
	note $2a $0d
	note $29 $0d
	note $25 $0d
	note $28 $0d
	note $27 $0d
	note $23 $0d
	note $26 $0d
	note $22 $06
	wait1 $07
	vol $3
	note $22 $06
	wait1 $07
	vol $1
	note $22 $06
	wait1 $07
	vol $0
	note $22 $06
	wait1 $48
	goto musicf34d1
	cmdff
; $f361a
; @addr{f361a}
sound17Channel4:
musicf361a:
	duty $0e
	note $18 $0d
	duty $0f
	note $18 $0d
	duty $0e
	note $18 $0d
	duty $0f
	note $18 $0d
	duty $0e
	note $1d $1a
	note $1e $1a
	wait1 $1a
	note $18 $0d
	duty $0f
	note $18 $0d
	duty $0e
	note $1d $1a
	note $1e $1a
	note $18 $0d
	duty $0f
	note $18 $0d
	duty $0e
	note $18 $0d
	duty $0f
	note $18 $0d
	wait1 $1a
	duty $0e
	note $18 $0d
	duty $0f
	note $18 $0d
	duty $0e
	note $1e $1a
	note $1d $1a
	note $18 $0d
	duty $0f
	note $18 $0d
	duty $0e
	note $18 $0d
	duty $0f
	note $18 $0d
	wait1 $1a
	duty $0e
	note $18 $0d
	duty $0f
	note $18 $0d
	duty $0e
	note $1d $1a
	note $1e $1a
	note $18 $0d
	duty $0f
	note $18 $0d
	duty $0e
	note $18 $0d
	duty $0f
	note $18 $0d
	wait1 $1a
	duty $0e
	note $18 $0d
	duty $0f
	note $18 $0d
	wait1 $34
	duty $0e
	note $24 $0d
	duty $0f
	note $24 $0d
	wait1 $34
	duty $0e
	note $18 $0d
	duty $0f
	note $18 $0d
	wait1 $ff
	wait1 $39
	duty $0e
	note $1a $0d
	duty $0f
	note $1a $0d
	duty $0e
	note $1a $0d
	duty $0f
	note $1a $0d
	duty $0e
	note $21 $1a
	note $22 $1a
	wait1 $1a
	note $1a $0d
	duty $0f
	note $1a $0d
	duty $0e
	note $21 $1a
	note $22 $1a
	note $1a $0d
	duty $0f
	note $1a $0d
	duty $0e
	note $1a $0d
	duty $0f
	note $1a $0d
	duty $0e
	note $22 $0d
	duty $0f
	note $22 $0d
	duty $0e
	note $22 $0d
	duty $0f
	note $22 $0d
	wait1 $34
	duty $0e
	note $1a $0d
	duty $0f
	note $1a $0d
	wait1 $34
	duty $0e
	note $1a $0d
	duty $0f
	note $1a $0d
	wait1 $d0
	duty $0e
	note $18 $0d
	duty $0f
	note $18 $0d
	wait1 $34
	duty $0e
	note $18 $0d
	duty $0f
	note $18 $0d
	wait1 $34
	duty $0e
	note $26 $0d
	note $25 $0d
	note $21 $0d
	note $24 $0d
	note $23 $0d
	note $1f $0d
	note $22 $0d
	note $1e $0d
	duty $0f
	note $1e $0d
	wait1 $5b
	goto musicf361a
	cmdff
; $f3732
; @addr{f3732}
sound17Channel6:
musicf3732:
	wait1 $ff
	wait1 $ff
	wait1 $a6
	vol $4
	note $2e $34
	wait1 $1a
	note $2e $34
	wait1 $ea
	note $2a $0d
	note $2a $0d
	note $2e $34
	wait1 $ff
	wait1 $ff
	wait1 $24
	note $2a $0d
	note $2a $0d
	note $2e $1a
	wait1 $9c
	note $2a $0d
	note $2a $0d
	note $2e $1a
	wait1 $9c
	note $2a $0d
	note $2a $0d
	note $2a $0d
	note $2e $0d
	goto musicf3732
	cmdff
; $f3769
; @addr{f3769}
sound19Channel1:
	vibrato $e1
	env $0 $00
	cmdf2
	duty $01
musicf3770:
	vol $7
	note $28 $2c
	vol $7
	note $27 $2c
	note $29 $2c
	note $28 $2c
	note $26 $42
	note $25 $0b
	note $24 $0b
	note $22 $21
	vibrato $01
	vol $3
	note $22 $0b
	vibrato $e1
	vol $7
	note $1f $2c
	vibrato $01
	vol $3
	note $1f $2c
	vibrato $e1
	vol $7
	note $21 $2c
	note $28 $2c
	note $2d $2c
	note $2e $58
	note $27 $2c
	note $28 $16
	vibrato $01
	vol $3
	note $28 $16
	vibrato $e1
	vol $7
	note $21 $16
	note $1c $16
	note $1d $16
	note $19 $16
	note $21 $16
	note $1c $16
	note $1d $16
	note $19 $16
	note $25 $58
	note $1c $42
	vibrato $01
	vol $3
	note $1c $16
	vibrato $e1
	vol $7
	note $23 $16
	note $1e $16
	note $1f $16
	note $1b $16
	note $23 $16
	note $1e $16
	note $1f $16
	note $1b $16
	note $26 $58
	note $1d $42
	vibrato $01
	vol $3
	note $1d $15
	wait1 $01
	vibrato $e1
	goto musicf3770
	cmdff
; $f37e5
; @addr{f37e5}
sound19Channel0:
	vibrato $00
	env $0 $00
	cmdf2
	duty $02
musicf37ec:
	vol $5
	note $2d $0b
	wait1 $0b
	note $2e $0b
	vol $2
	note $2d $0b
	vol $5
	note $34 $0b
	vol $2
	note $2e $0b
	vol $5
	note $2d $0b
	vol $2
	note $34 $0b
	vol $5
	note $2e $0b
	vol $2
	note $2d $0b
	vol $5
	note $34 $0b
	vol $2
	note $2e $0b
	vol $5
	note $2d $0b
	vol $2
	note $34 $0b
	vol $5
	note $2e $0b
	vol $2
	note $2d $0b
	vol $5
	note $2b $0b
	vol $2
	note $2e $0b
	vol $5
	note $2c $0b
	vol $2
	note $2b $0b
	vol $5
	note $32 $0b
	vol $2
	note $2c $0b
	vol $5
	note $2b $0b
	vol $2
	note $32 $0b
	vol $5
	note $2c $0b
	vol $2
	note $2b $0b
	vol $5
	note $32 $0b
	vol $2
	note $2c $0b
	vol $5
	note $2b $0b
	vol $2
	note $32 $0b
	vol $5
	note $2c $0b
	vol $2
	note $2b $0b
	vol $5
	note $2d $0b
	vol $2
	note $2c $0b
	vol $5
	note $2e $0b
	vol $2
	note $2d $0b
	vol $5
	note $34 $0b
	vol $2
	note $2e $0b
	vol $5
	note $2d $0b
	vol $2
	note $34 $0b
	vol $5
	note $2e $0b
	vol $2
	note $2d $0b
	vol $5
	note $34 $0b
	vol $2
	note $2e $0b
	vol $5
	note $2d $0b
	vol $2
	note $34 $0b
	vol $5
	note $2e $0b
	vol $2
	note $2d $0b
	vol $5
	note $2b $0b
	vol $2
	note $2e $0b
	vol $5
	note $2c $0b
	vol $2
	note $2b $0b
	vol $5
	note $32 $0b
	vol $2
	note $2c $0b
	vol $5
	note $2b $0b
	vol $2
	note $32 $0b
	vol $5
	note $2c $0b
	vol $2
	note $2b $0b
	vol $5
	note $32 $0b
	vol $2
	note $2c $0b
	vol $5
	note $2b $0b
	vol $2
	note $32 $0b
	vol $5
	note $2c $0b
	vol $2
	note $2b $0b
	vol $5
	note $2d $0b
	vol $2
	note $2c $0b
	vol $5
	note $2e $0b
	vol $2
	note $2d $0b
	vol $5
	note $34 $0b
	vol $2
	note $2e $0b
	vol $5
	note $2d $0b
	vol $2
	note $34 $0b
	vol $5
	note $2e $0b
	vol $2
	note $2d $0b
	vol $5
	note $34 $0b
	vol $2
	note $2e $0b
	vol $5
	note $2d $0b
	vol $2
	note $34 $0b
	vol $5
	note $2e $0b
	vol $2
	note $2d $0b
	vol $5
	note $2b $0b
	vol $2
	note $2e $0b
	vol $5
	note $2c $0b
	vol $2
	note $2b $0b
	vol $5
	note $32 $0b
	vol $2
	note $2c $0b
	vol $5
	note $2b $0b
	vol $2
	note $32 $0b
	vol $5
	note $2c $0b
	vol $2
	note $2b $0b
	vol $5
	note $32 $0b
	vol $2
	note $2c $0b
	vol $5
	note $2b $0b
	vol $2
	note $32 $0b
	vol $5
	note $2c $0b
	vol $2
	note $2b $0b
	vol $5
	note $2f $0b
	wait1 $0b
	note $30 $0b
	vol $2
	note $2f $0b
	vol $5
	note $36 $0b
	vol $2
	note $30 $0b
	vol $5
	note $2f $0b
	vol $2
	note $36 $0b
	vol $5
	note $30 $0b
	vol $2
	note $2f $0b
	vol $5
	note $36 $0b
	vol $2
	note $30 $0b
	vol $5
	note $2f $0b
	vol $2
	note $36 $0b
	vol $5
	note $30 $0b
	vol $2
	note $2f $0b
	vol $5
	note $31 $0b
	vol $2
	note $30 $0b
	vol $5
	note $32 $0b
	vol $2
	note $31 $0b
	vol $5
	note $38 $0b
	vol $2
	note $32 $0b
	vol $5
	note $31 $0b
	vol $2
	note $38 $0b
	vol $5
	note $32 $0b
	vol $2
	note $31 $0b
	vol $5
	note $38 $0b
	vol $2
	note $32 $0b
	vol $5
	note $31 $0b
	vol $2
	note $38 $0b
	vol $5
	note $32 $0b
	vol $2
	note $31 $0b
	goto musicf37ec
	cmdff
; $f396c
; @addr{f396c}
sound19Channel4:
	cmdf2
musicf396d:
	duty $0e
	note $15 $0b
	duty $0f
	note $15 $0b
	duty $0e
	note $15 $0b
	duty $0f
	note $15 $0b
	wait1 $2c
	duty $0e
	note $15 $0b
	duty $0f
	note $15 $0b
	duty $0e
	note $15 $0b
	duty $0f
	note $15 $0b
	wait1 $2c
	duty $0e
	note $13 $0b
	duty $0f
	note $13 $0b
	duty $0e
	note $13 $0b
	duty $0f
	note $13 $0b
	wait1 $2c
	duty $0e
	note $13 $0b
	duty $0f
	note $13 $0b
	duty $0e
	note $13 $0b
	duty $0f
	note $13 $0b
	wait1 $2c
	duty $0e
	note $15 $0b
	duty $0f
	note $15 $0b
	duty $0e
	note $15 $0b
	duty $0f
	note $15 $0b
	wait1 $2c
	duty $0e
	note $15 $0b
	duty $0f
	note $15 $0b
	duty $0e
	note $15 $0b
	duty $0f
	note $15 $0b
	wait1 $2c
	duty $0e
	note $13 $0b
	duty $0f
	note $13 $0b
	duty $0e
	note $13 $0b
	duty $0f
	note $13 $0b
	wait1 $2c
	duty $0e
	note $13 $0b
	duty $0f
	note $13 $0b
	duty $0e
	note $13 $0b
	duty $0f
	note $13 $0b
	wait1 $2c
	duty $0e
	note $15 $0b
	duty $0f
	note $15 $0b
	duty $0e
	note $15 $0b
	duty $0f
	note $15 $0b
	wait1 $2c
	duty $0e
	note $15 $0b
	duty $0f
	note $15 $0b
	duty $0e
	note $15 $0b
	duty $0f
	note $15 $0b
	wait1 $2c
	duty $0e
	note $14 $0b
	duty $0f
	note $14 $0b
	duty $0e
	note $14 $0b
	duty $0f
	note $14 $0b
	wait1 $2c
	duty $0e
	note $14 $0b
	duty $0f
	note $14 $0b
	duty $0e
	note $14 $0b
	duty $0f
	note $14 $0b
	wait1 $2c
	duty $0e
	note $16 $0b
	duty $0f
	note $16 $0b
	duty $0e
	note $16 $0b
	duty $0f
	note $16 $0b
	wait1 $2c
	duty $0e
	note $16 $0b
	duty $0f
	note $16 $0b
	duty $0e
	note $16 $0b
	duty $0f
	note $16 $0b
	wait1 $2c
	duty $0e
	note $17 $0b
	duty $0f
	note $17 $0b
	duty $0e
	note $17 $0b
	duty $0f
	note $17 $0b
	wait1 $2c
	duty $0e
	note $17 $0b
	duty $0f
	note $17 $0b
	duty $0e
	note $17 $0b
	duty $0f
	note $17 $0b
	wait1 $2c
	goto musicf396d
	cmdff
; $f3a91
sound4eStart:
; @addr{f3a91}
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
; $f3aa3
sound4fStart:
; @addr{f3aa3}
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
; $f3ae5
sound50Start:
; @addr{f3ae5}
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
; $f3af3
sound51Start:
; @addr{f3af3}
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
; $f3b06
sound52Start:
; @addr{f3b06}
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
; $f3b16
sound53Start:
; @addr{f3b16}
sound53Channel2:
	duty $02
	vol $c
	env $0 $02
	cmdf8 $10
	note $26 $14
	cmdff
; $f3b20
sound57Start:
; @addr{f3b20}
sound57Channel2:
	duty $02
	vol $9
	note $32 $01
	note $37 $01
	note $3e $01
	cmdff
; $f3b2a
sounda5Start:
; @addr{f3b2a}
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
; $f3b57
sound91Start:
; @addr{f3b57}
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
; $f3bf6
soundaeStart:
; @addr{f3bf6}
soundaeChannel2:
	duty $02
	env $0 $02
	vol $9
	note $27 $06
	note $2e $06
	note $32 $06
	note $3a $06
	note $3f $06
	note $3a $06
	note $33 $06
	note $2e $06
	note $27 $06
	note $29 $06
	note $2e $06
	note $32 $06
	note $38 $06
	note $41 $06
	note $38 $06
	note $32 $06
	note $2e $06
	note $29 $06
	note $3a $06
	note $3f $06
	note $2e $06
	note $37 $06
	note $43 $06
	note $3f $06
	note $3a $06
	note $37 $06
	note $3e $06
	note $3a $06
	note $37 $06
	note $33 $06
	note $27 $06
	note $2e $06
	note $32 $06
	note $3a $06
	note $3f $06
	note $43 $06
	env $0 $05
	note $46 $2a
	cmdff
; $f3c48
; @addr{f3c48}
soundaeChannel3:
	duty $02
	env $0 $02
	vol $0
	note $20 $0a
	vol $5
	note $27 $06
	note $2e $06
	note $32 $06
	note $3a $06
	note $3f $06
	note $3a $06
	note $33 $06
	note $2e $06
	note $27 $06
	note $29 $06
	note $2e $06
	note $32 $06
	note $38 $06
	note $41 $06
	note $38 $06
	note $32 $06
	note $2e $06
	note $29 $06
	note $3a $06
	note $3f $06
	note $2e $06
	note $37 $06
	note $43 $06
	note $3f $06
	note $3a $06
	note $37 $06
	note $3e $06
	note $3a $06
	note $37 $06
	note $33 $06
	note $27 $06
	note $2e $06
	note $32 $06
	note $3a $06
	note $3f $06
	note $43 $06
	env $0 $05
	note $46 $20
	cmdff
; $f3c9d
; @addr{f3c9d}
soundaeChannel5:
	duty $0e
	wait1 $c8
	wait1 $3a
	cmdff
; $f3ca4
; @addr{f3ca4}
soundaeChannel7:
	cmdf0 $00
	note $00 $c8
	note $00 $3a
	cmdff
; $f3cab
soundafStart:
; @addr{f3cab}
soundafChannel2:
	duty $02
	env $0 $02
	vol $9
	note $30 $03
	note $34 $04
	note $37 $03
	note $3c $07
	note $3b $07
	note $39 $07
	note $3b $07
	note $37 $07
	note $3e $07
	note $3c $07
	note $3b $07
	note $39 $07
	note $3b $07
	note $3c $07
	note $3e $07
	note $37 $07
	note $39 $07
	note $37 $07
	note $34 $07
	note $35 $07
	wait1 $07
	note $39 $07
	wait1 $07
	note $3c $07
	wait1 $07
	note $3e $07
	wait1 $07
	note $28 $04
	note $2b $03
	note $2f $04
	note $30 $03
	note $34 $04
	note $37 $03
	note $3b $04
	env $0 $06
	note $40 $2d
	wait1 $0a
	cmdff
; $f3cfb
; @addr{f3cfb}
soundafChannel3:
	duty $02
	env $0 $02
	vol $0
	note $20 $0a
	vol $5
	note $30 $04
	note $34 $03
	note $37 $04
	note $3c $07
	note $3b $07
	note $39 $07
	note $3b $07
	note $37 $07
	note $3e $07
	note $3c $07
	note $3b $07
	note $39 $07
	note $3b $07
	note $3c $07
	note $3e $07
	note $37 $07
	note $39 $07
	note $37 $07
	note $34 $07
	note $35 $07
	wait1 $07
	note $39 $07
	wait1 $07
	note $3c $07
	wait1 $07
	note $3e $07
	wait1 $07
	note $28 $03
	note $2b $04
	note $2f $03
	note $30 $04
	note $34 $03
	note $37 $04
	note $3b $03
	env $0 $06
	note $40 $2d
	cmdff
; $f3d4c
; @addr{f3d4c}
soundafChannel5:
	duty $0e
	wait1 $c8
	wait1 $3a
	cmdff
; $f3d53
; @addr{f3d53}
soundafChannel7:
	cmdf0 $00
	note $00 $c8
	note $00 $3a
	cmdff
; $f3d5a
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
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
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
; @addr{f4000}
sound1bChannel6:
sound27Channel6:
sound31Channel4:
sound31Channel6:
sound38Channel6:
sound46Channel6:
sound1aChannel6:
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
; $f4e97
sound23Start:
; @addr{f4e97}
sound23Channel1:
	vibrato $e1
	env $0 $00
	duty $02
musicf4e9d:
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
	goto musicf4e9d
	cmdff
; $f5092
; @addr{f5092}
sound23Channel0:
	vibrato $e1
	env $0 $00
	duty $02
musicf5098:
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
	goto musicf5098
	cmdff
; $f5280
; @addr{f5280}
sound23Channel4:
musicf5280:
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
	goto musicf5280
	cmdff
; $f5400
; @addr{f5400}
sound23Channel6:
musicf5400:
	wait1 $ff
	wait1 $ff
	wait1 $28
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
	wait1 $16
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
	wait1 $16
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
	wait1 $16
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
	wait1 $16
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
; $f54c8
; @addr{f54c8}
sound1bChannel1:
musicf54c8:
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
	goto musicf54c8
	cmdff
; $f567e
; @addr{f567e}
sound1bChannel0:
musicf567e:
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
	goto musicf567e
	cmdff
; $f5837
; @addr{f5837}
sound1bChannel4:
musicf5837:
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
	goto musicf5837
	cmdff
; $f598f
; @addr{f598f}
sound27Channel1:
	vibrato $e1
	env $0 $00
	duty $01
musicf5995:
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
	goto musicf5995
	cmdff
; $f5b4e
; @addr{f5b4e}
sound27Channel0:
	vibrato $e1
	env $0 $00
	duty $02
musicf5b54:
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
	goto musicf5b54
	cmdff
; $f5c55
; @addr{f5c55}
sound27Channel4:
musicf5c55:
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
	goto musicf5c55
	cmdff
; $f5d41
sound1dStart:
; @addr{f5d41}
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
musicf5d7e:
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
	goto musicf5d7e
	cmdff
; $f5f02
; @addr{f5f02}
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
musicf5f2e:
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
	goto musicf5f2e
	cmdff
; $f6068
; @addr{f6068}
sound1dChannel4:
	duty $0e
	note $0b $70
musicf606c:
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
	goto musicf606c
	cmdff
; $f6256
; @addr{f6256}
sound1dChannel6:
	wait1 $70
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
; $f640c
; @addr{f640c}
sound46Channel1:
	vibrato $00
	env $0 $00
	duty $01
musicf6412:
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
	goto musicf6412
	cmdff
; $f654a
; @addr{f654a}
sound46Channel0:
	vibrato $00
	env $0 $00
	duty $01
musicf6550:
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
	goto musicf6550
	cmdff
; $f65b0
; @addr{f65b0}
sound46Channel4:
musicf65b0:
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
	goto musicf65b0
	cmdff
; $f65f2
; @addr{f65f2}
sound38Channel1:
musicf65f2:
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
	goto musicf65f2
	cmdff
; $f67c7
; @addr{f67c7}
sound38Channel0:
musicf67c7:
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
	goto musicf67c7
	cmdff
; $f688a
; @addr{f688a}
sound38Channel4:
musicf688a:
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
	goto musicf688a
	cmdff
; $f6956
sound2bStart:
; @addr{f6956}
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
musicf69b1:
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
	goto musicf69b1
	cmdff
; $f6ad8
; @addr{f6ad8}
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
musicf6b33:
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
	goto musicf6b33
	cmdff
; $f6bc6
; @addr{f6bc6}
sound2bChannel4:
	wait1 $ee
	duty $0e
	note $13 $03
	note $11 $04
	note $0f $03
	note $0d $04
musicf6bd2:
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
	goto musicf6bd2
	cmdff
; $f6cda
; @addr{f6cda}
sound2bChannel6:
	wait1 $fc
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
	goto musicf6cdc
	cmdff
; $f6d46
sound3fStart:
; @addr{f6d46}
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
musicf6ed3:
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
	goto musicf6ed3
	cmdff
; $f72c6
; @addr{f72c6}
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
musicf74a6:
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
	goto musicf74a6
	cmdff
; $f7517
; @addr{f7517}
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
musicf77c0:
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
	goto musicf77c0
	cmdff
; $f784a
; @addr{f784a}
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
; $f798e
; @addr{f798e}
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
musicf79ae:
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
	goto musicf79ae
	cmdff
; $f7a88
; @addr{f7a88}
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
musicf7a98:
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
	goto musicf7a98
	cmdff
; $f7b51
; @addr{f7b51}
sound1aChannel1:
	vibrato $00
	env $0 $00
	cmdf2
	duty $02
musicf7b58:
	vol $0
	note $20 $ff
	note $20 $21
	vol $6
	note $32 $03
	wait1 $03
	vol $5
	note $32 $03
	wait1 $03
	vol $4
	note $32 $03
	wait1 $03
	vol $4
	note $32 $03
	wait1 $03
	vol $4
	note $32 $03
	wait1 $2d
	vol $6
	note $38 $03
	wait1 $03
	vol $5
	note $38 $03
	wait1 $03
	vol $4
	note $38 $03
	wait1 $03
	vol $4
	note $38 $03
	wait1 $03
	vol $4
	note $38 $03
	wait1 $3f
	vol $6
	note $32 $03
	wait1 $03
	vol $5
	note $32 $03
	wait1 $03
	vol $4
	note $32 $03
	wait1 $03
	vol $6
	note $38 $03
	wait1 $03
	vol $5
	note $38 $03
	wait1 $03
	vol $4
	note $38 $03
	wait1 $03
	vol $4
	note $38 $03
	wait1 $03
	vol $4
	note $38 $03
	wait1 $ff
	vol $0
	note $20 $72
	vol $6
	note $34 $03
	wait1 $03
	vol $5
	note $34 $03
	wait1 $03
	vol $4
	note $34 $03
	wait1 $03
	vol $4
	note $34 $03
	wait1 $03
	vol $4
	note $34 $03
	wait1 $2d
	vol $6
	note $3a $03
	wait1 $03
	vol $5
	note $3a $03
	wait1 $03
	vol $4
	note $3a $03
	wait1 $03
	vol $4
	note $3a $03
	wait1 $03
	vol $4
	note $3a $03
	wait1 $3f
	vol $6
	note $34 $03
	wait1 $03
	vol $5
	note $34 $03
	wait1 $03
	vol $4
	note $34 $03
	wait1 $03
	vol $6
	note $3a $03
	wait1 $03
	vol $5
	note $3a $03
	wait1 $03
	vol $4
	note $3a $03
	wait1 $03
	vol $4
	note $3a $03
	wait1 $03
	vol $4
	note $3a $03
	wait1 $51
	vol $4
	note $3c $09
	vol $7
	note $3c $09
	vol $5
	note $3c $04
	wait1 $05
	vol $4
	note $3c $04
	wait1 $05
	note $36 $09
	vol $6
	note $36 $09
	vol $4
	note $36 $04
	wait1 $05
	vol $3
	note $36 $04
	wait1 $05
	note $3a $09
	vol $6
	note $3a $09
	vol $5
	note $3a $04
	wait1 $05
	vol $4
	note $3a $04
	wait1 $05
	vol $3
	note $34 $09
	vol $6
	note $34 $09
	vol $4
	note $34 $04
	wait1 $05
	vol $3
	note $34 $04
	wait1 $05
	vol $3
	note $34 $04
	wait1 $05
	vol $2
	note $34 $04
	wait1 $29
	vol $3
	note $40 $03
	wait1 $06
	vol $6
	note $40 $06
	wait1 $03
	vol $6
	note $3a $03
	wait1 $06
	vol $5
	note $3a $09
	wait1 $04
	vol $3
	note $3a $09
	wait1 $05
	vol $1
	note $3a $09
	wait1 $1b
	goto musicf7b58
	cmdff
; $f7c7e
; @addr{f7c7e}
sound1aChannel0:
	vibrato $00
	env $0 $00
	cmdf2
	duty $01
musicf7c85:
	vol $6
	note $14 $24
	vol $6
	note $15 $24
	note $14 $24
	note $10 $24
	note $14 $24
	note $15 $24
	note $14 $24
	note $10 $24
	duty $02
	vol $7
	note $2d $03
	wait1 $03
	vol $6
	note $2d $03
	wait1 $03
	vol $4
	note $2d $03
	wait1 $03
	vol $4
	note $2d $03
	wait1 $03
	vol $3
	note $2d $03
	wait1 $2d
	vol $7
	note $32 $03
	wait1 $03
	vol $6
	note $32 $03
	wait1 $03
	vol $4
	note $32 $03
	wait1 $03
	vol $4
	note $32 $03
	wait1 $03
	vol $3
	note $32 $03
	wait1 $3f
	vol $7
	note $2d $03
	wait1 $03
	vol $6
	note $2d $03
	wait1 $03
	vol $4
	note $2d $03
	wait1 $03
	vol $7
	note $32 $03
	wait1 $03
	vol $6
	note $32 $03
	wait1 $03
	vol $4
	note $32 $03
	wait1 $03
	vol $7
	note $21 $03
	wait1 $03
	vol $6
	note $21 $03
	wait1 $03
	vol $4
	note $21 $03
	wait1 $03
	vol $7
	note $26 $03
	wait1 $03
	vol $6
	note $26 $03
	wait1 $03
	vol $4
	note $26 $03
	wait1 $03
	vol $7
	note $20 $03
	wait1 $03
	vol $6
	note $20 $03
	wait1 $03
	vol $4
	note $20 $03
	wait1 $03
	vol $4
	note $20 $03
	wait1 $03
	vol $3
	note $20 $03
	wait1 $1b
	duty $01
	vol $6
	note $14 $24
	note $15 $24
	note $14 $24
	note $15 $24
	note $16 $24
	note $17 $24
	note $16 $24
	note $11 $24
	duty $02
	vol $7
	note $2d $03
	wait1 $03
	vol $6
	note $2d $03
	wait1 $03
	vol $4
	note $2d $03
	wait1 $03
	vol $4
	note $2d $03
	wait1 $03
	vol $3
	note $2d $03
	wait1 $2d
	vol $7
	note $33 $03
	wait1 $03
	vol $6
	note $33 $03
	wait1 $03
	vol $4
	note $33 $03
	wait1 $03
	vol $4
	note $33 $03
	wait1 $03
	vol $3
	note $33 $03
	wait1 $3f
	vol $7
	note $2d $03
	wait1 $03
	vol $6
	note $2d $03
	wait1 $03
	vol $4
	note $2d $03
	wait1 $03
	vol $7
	note $33 $03
	wait1 $03
	vol $6
	note $33 $03
	wait1 $03
	vol $4
	note $33 $03
	wait1 $03
	vol $7
	note $21 $03
	wait1 $03
	vol $6
	note $21 $03
	wait1 $03
	vol $4
	note $21 $03
	wait1 $03
	vol $7
	note $26 $03
	wait1 $03
	vol $6
	note $26 $03
	wait1 $03
	vol $4
	note $26 $03
	wait1 $03
	vol $7
	note $20 $03
	wait1 $03
	vol $6
	note $20 $03
	wait1 $03
	vol $4
	note $20 $03
	wait1 $03
	vol $4
	note $20 $03
	wait1 $03
	vol $3
	note $20 $03
	wait1 $1b
	vol $3
	note $36 $09
	vol $6
	note $36 $09
	vol $4
	note $36 $06
	wait1 $03
	vol $2
	note $36 $06
	wait1 $03
	vol $3
	note $30 $09
	vol $6
	note $30 $09
	vol $4
	note $30 $06
	wait1 $03
	vol $2
	note $30 $06
	wait1 $03
	vol $3
	note $34 $09
	vol $6
	note $34 $09
	vol $4
	note $34 $06
	wait1 $03
	vol $2
	note $34 $06
	wait1 $03
	vol $3
	note $2e $09
	vol $6
	note $2e $09
	vol $4
	note $2e $06
	wait1 $03
	vol $3
	note $2e $06
	wait1 $03
	vol $2
	note $2e $06
	wait1 $03
	vol $2
	note $2e $06
	wait1 $27
	vol $3
	note $3a $06
	wait1 $03
	vol $6
	note $3a $06
	wait1 $03
	note $34 $06
	wait1 $03
	vol $5
	note $34 $09
	wait1 $04
	vol $2
	note $34 $09
	wait1 $05
	vol $1
	note $34 $09
	wait1 $1b
	duty $01
	goto musicf7c85
	cmdff
; $f7e29
; @addr{f7e29}
sound1aChannel4:
	cmdf2
musicf7e2a:
	duty $0e
	note $0e $24
	note $0f $24
	note $0e $24
	note $0a $24
	note $0e $24
	note $0f $24
	note $0e $24
	note $0a $24
	note $0e $24
	note $0f $24
	note $0e $24
	note $0a $24
	note $0e $24
	note $0f $24
	note $0e $24
	note $0a $24
	note $0e $24
	note $0f $24
	note $0e $24
	note $0f $24
	note $10 $24
	note $11 $24
	note $10 $24
	note $0b $24
	note $10 $24
	note $11 $24
	note $10 $24
	note $0b $24
	note $10 $24
	note $11 $24
	note $10 $24
	note $11 $24
	wait1 $ff
	wait1 $21
	goto musicf7e2a
	cmdff
; $f7e74
sound93Start:
; @addr{f7e74}
sound93Channel2:
	cmdff
; $f7e75
sound94Start:
; @addr{f7e75}
sound94Channel2:
	cmdff
; $f7e76
sounda2Start:
; @addr{f7e76}
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
; $f7e91
sounda3Start:
; @addr{f7e91}
sounda3Channel7:
	cmdf0 $90
	note $14 $01
	cmdf0 $00
	note $00 $01
	cmdf0 $22
	note $14 $02
	cmdff
; $f7e9e
sounda7Start:
; @addr{f7e9e}
sounda7Channel2:
	vol $d
	note $48 $01
	vol $0
	wait1 $01
	vol $3
	note $48 $01
	cmdff
; $f7ea8
soundb0Start:
; @addr{f7ea8}
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
; $f7ec8
; @addr{f7ec8}
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
; $f7f1d
sound58Start:
; @addr{f7f1d}
sound58Channel2:
	duty $00
	vol $9
	env $0 $01
	note $46 $0a
	cmdff
; $f7f25
sound59Start:
; @addr{f7f25}
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
; $f7f34
sound5aStart:
; @addr{f7f34}
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
; $f7f5e
sound5bStart:
; @addr{f7f5e}
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
; $f7f6e
; @addr{f7f6e}
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
; $f7f84
; GAP
	cmdff
sound5fStart:
; @addr{f7f85}
sound5fChannel5:
	cmdfd $fd
	duty $2d
	note $11 $01
	cmdf8 $e7
	note $30 $03
	cmdf8 $00
	cmdfd $00
	cmdff
; $f7f94
sound62Start:
; @addr{f7f94}
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
; $f7fa3
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
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
	cmdff
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
; @addr{f8000}
sound0cChannel4:
sound0cChannel6:
sound2fChannel0:
sound2fChannel4:
sound2fChannel6:
sound39Channel6:
sound3cChannel6:
sound25Channel6:
	cmdff
; $f8001
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
; @addr{f8001}
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
; $f8002
; @addr{f8002}
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
; $f8003
; @addr{f8003}
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
; $f8004
; @addr{f8004}
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
; $f8005
; GAP
	cmdff
	cmdff
	cmdff
	cmdff
; @addr{f8009}
sound39Channel1:
	vibrato $00
	env $0 $00
	duty $00
musicf800f:
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
	goto musicf800f
	cmdff
; $f80d3
; @addr{f80d3}
sound39Channel0:
	env $0 $02
	vol $9
musicf80d6:
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
	goto musicf80d6
	cmdff
; $f8182
; @addr{f8182}
sound39Channel4:
musicf8182:
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
	goto musicf8182
	cmdff
; $f81fe
; @addr{f81fe}
sound2fChannel1:
	vibrato $00
	env $0 $00
	duty $02
musicf8204:
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
	goto musicf8204
	cmdff
; $f8251
; @addr{f8251}
sound3cChannel1:
musicf8251:
	vibrato $00
	env $0 $05
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
	goto musicf8251
	cmdff
; $f82e1
; @addr{f82e1}
sound3cChannel0:
musicf82e1:
	vibrato $00
	env $0 $02
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
	goto musicf82e1
	cmdff
; $f8380
; @addr{f8380}
sound3cChannel4:
musicf8380:
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
	goto musicf8380
	cmdff
; $f83e2
sound3eStart:
; @addr{f83e2}
sound3eChannel1:
	vibrato $00
	env $0 $00
	duty $02
musicf83e8:
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
	goto musicf83e8
	cmdff
; $f87ad
; @addr{f87ad}
sound3eChannel0:
	vibrato $00
	env $0 $00
	duty $02
musicf87b3:
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
	goto musicf87b3
	cmdff
; $f8b3e
; @addr{f8b3e}
sound3eChannel4:
musicf8b3e:
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
	goto musicf8b3e
	cmdff
; $f8c98
; @addr{f8c98}
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
; $f8d83
sound2aStart:
; @addr{f8d83}
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
musicf8e5b:
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
	goto musicf8e5b
	cmdff
; $f917f
; @addr{f917f}
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
musicf923f:
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
	goto musicf923f
	cmdff
; $f95d5
; @addr{f95d5}
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
musicf969f:
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
	goto musicf969f
	cmdff
; $f9beb
; @addr{f9beb}
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
; $f9f65
sound2eStart:
; @addr{f9f65}
sound2eChannel1:
	vibrato $00
	env $0 $00
	duty $02
musicf9f6b:
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
	goto musicf9f6b
	cmdff
; $fa081
; @addr{fa081}
sound2eChannel0:
	vibrato $00
	env $0 $00
	duty $02
musicfa087:
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
	goto musicfa087
	cmdff
; $fa18c
; @addr{fa18c}
sound2eChannel4:
musicfa18c:
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
	goto musicfa18c
	cmdff
; $fa756
; @addr{fa756}
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
; $fab44
sound29Start:
; @addr{fab44}
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
musicfaba1:
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
	goto musicfaba1
	cmdff
; $fae40
; @addr{fae40}
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
musicfae87:
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
	goto musicfae87
	cmdff
; $fb0d6
; @addr{fb0d6}
sound29Channel4:
	duty $0e
	wait1 $ff
	wait1 $ff
	wait1 $02
musicfb0de:
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
	goto musicfb0de
	cmdff
; $fb32e
; @addr{fb32e}
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
; $fb69d
; @addr{fb69d}
sound25Channel1:
	vibrato $e1
	env $0 $00
	duty $01
musicfb6a3:
	vol $6
	note $29 $16
	note $2e $16
	note $30 $16
	note $33 $16
	note $32 $2c
	note $37 $2c
	duty $02
	note $35 $07
	wait1 $04
	vol $5
	note $35 $03
	wait1 $03
	vol $4
	note $35 $05
	wait1 $03
	vol $3
	note $35 $03
	wait1 $05
	vol $2
	note $35 $03
	wait1 $08
	vol $5
	note $3c $03
	wait1 $03
	vol $4
	note $3c $05
	wait1 $03
	vol $3
	note $3c $03
	wait1 $05
	vol $2
	note $3c $03
	wait1 $13
	vol $5
	note $3f $03
	wait1 $03
	vol $4
	note $3f $05
	wait1 $03
	vol $3
	note $3f $03
	wait1 $05
	vol $2
	note $3f $03
	wait1 $13
	vol $5
	note $43 $03
	wait1 $03
	vol $4
	note $43 $05
	wait1 $03
	vol $3
	note $43 $03
	wait1 $05
	vol $2
	note $43 $03
	wait1 $13
	duty $01
	vol $6
	note $3f $16
	note $41 $0b
	note $43 $0b
	note $44 $16
	note $43 $0b
	note $41 $0b
	note $3f $2c
	note $41 $0b
	wait1 $05
	vol $3
	note $41 $06
	vol $6
	note $3c $0b
	wait1 $05
	vol $3
	note $3c $06
	vol $6
	note $29 $16
	note $22 $0b
	note $25 $0b
	note $27 $21
	vol $3
	note $27 $0b
	vol $6
	note $2e $21
	note $2c $0b
	note $29 $0b
	wait1 $05
	vol $3
	note $29 $06
	vol $6
	note $2c $0b
	wait1 $05
	vol $3
	note $2c $06
	vol $6
	note $2e $2c
	note $30 $0b
	wait1 $05
	vol $3
	note $30 $06
	vol $6
	note $33 $0b
	wait1 $05
	vol $3
	note $33 $06
	vol $6
	note $30 $21
	note $33 $0b
	note $35 $0b
	wait1 $05
	vol $3
	note $35 $0b
	wait1 $06
	vol $2
	note $35 $0b
	wait1 $16
	duty $02
	vol $6
	note $34 $03
	wait1 $03
	vol $5
	note $34 $05
	wait1 $03
	vol $3
	note $34 $03
	wait1 $05
	vol $6
	note $3f $03
	wait1 $03
	vol $5
	note $40 $05
	wait1 $03
	vol $4
	note $40 $03
	wait1 $05
	vol $4
	note $40 $03
	wait1 $29
	vol $6
	note $34 $03
	wait1 $03
	vol $5
	note $34 $05
	wait1 $03
	vol $3
	note $34 $03
	wait1 $05
	vol $6
	note $3f $03
	wait1 $03
	vol $5
	note $40 $05
	wait1 $03
	vol $4
	note $40 $03
	wait1 $05
	vol $3
	note $40 $03
	wait1 $29
	vol $6
	note $35 $03
	wait1 $03
	vol $5
	note $35 $05
	wait1 $03
	vol $3
	note $35 $03
	wait1 $05
	vol $6
	note $40 $03
	wait1 $03
	vol $5
	note $41 $05
	wait1 $03
	vol $4
	note $41 $03
	wait1 $05
	vol $4
	note $41 $03
	wait1 $29
	vol $6
	note $35 $03
	wait1 $03
	vol $5
	note $35 $05
	wait1 $03
	vol $3
	note $35 $03
	wait1 $05
	vol $6
	note $40 $03
	wait1 $03
	vol $5
	note $41 $05
	wait1 $03
	vol $4
	note $41 $03
	wait1 $05
	vol $3
	note $41 $03
	wait1 $13
	duty $01
	vol $6
	note $18 $2c
	note $1a $16
	note $1c $16
	note $1f $2c
	note $1d $16
	note $1b $16
	wait1 $16
	duty $02
	note $39 $03
	wait1 $03
	vol $5
	note $39 $05
	wait1 $03
	vol $3
	note $39 $03
	wait1 $05
	vol $6
	note $44 $03
	wait1 $03
	vol $5
	note $45 $05
	wait1 $03
	vol $4
	note $45 $03
	wait1 $05
	vol $4
	note $45 $03
	wait1 $29
	vol $6
	note $3c $03
	wait1 $03
	vol $5
	note $3c $05
	wait1 $03
	vol $3
	note $3c $03
	wait1 $05
	vol $6
	note $47 $03
	wait1 $03
	vol $5
	note $48 $05
	wait1 $03
	vol $4
	note $48 $03
	wait1 $05
	vol $3
	note $48 $03
	wait1 $13
	duty $01
	goto musicfb6a3
	cmdff
; $fb857
; @addr{fb857}
sound25Channel0:
	vibrato $e1
	env $0 $00
	duty $02
musicfb85d:
	vol $0
	note $20 $16
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
	note $3b $03
	wait1 $03
	vol $5
	note $3c $05
	wait1 $03
	vol $4
	note $3c $03
	wait1 $05
	vol $4
	note $3c $03
	wait1 $29
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
	note $3b $03
	wait1 $03
	vol $5
	note $3c $05
	wait1 $03
	vol $4
	note $3c $03
	wait1 $05
	vol $3
	note $3c $03
	wait1 $13
	duty $01
	vol $4
	note $18 $16
	note $1b $16
	note $1d $16
	note $20 $16
	note $22 $2c
	note $1f $16
	duty $02
	note $30 $03
	wait1 $03
	vol $3
	note $30 $05
	wait1 $03
	vol $2
	note $30 $03
	wait1 $1b
	vol $6
	note $2e $03
	wait1 $03
	vol $5
	note $2e $05
	wait1 $03
	vol $3
	note $2e $03
	wait1 $05
	vol $6
	note $38 $03
	wait1 $03
	vol $5
	note $3a $05
	wait1 $03
	vol $4
	note $3a $03
	wait1 $05
	vol $4
	note $3a $03
	wait1 $29
	vol $6
	note $2e $03
	wait1 $03
	vol $5
	note $2e $05
	wait1 $03
	vol $3
	note $2e $03
	wait1 $05
	vol $6
	note $38 $03
	wait1 $03
	vol $5
	note $3a $05
	wait1 $03
	vol $4
	note $3a $03
	wait1 $05
	vol $3
	note $3a $03
	wait1 $29
	vol $6
	note $2e $03
	wait1 $03
	vol $5
	note $2e $05
	wait1 $03
	vol $3
	note $2e $03
	wait1 $05
	vol $6
	note $39 $03
	wait1 $03
	vol $5
	note $3a $05
	wait1 $03
	vol $4
	note $3a $03
	wait1 $05
	vol $4
	note $3a $03
	wait1 $29
	vol $6
	note $2e $03
	wait1 $03
	vol $5
	note $2e $05
	wait1 $03
	vol $3
	note $2e $03
	wait1 $05
	vol $6
	note $39 $03
	wait1 $03
	vol $5
	note $3a $05
	wait1 $03
	vol $4
	note $3a $03
	wait1 $05
	vol $3
	note $3a $03
	wait1 $29
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
	note $3b $03
	wait1 $03
	vol $5
	note $3c $05
	wait1 $03
	vol $4
	note $3c $03
	wait1 $05
	vol $4
	note $3c $03
	wait1 $29
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
	note $3b $03
	wait1 $03
	vol $5
	note $3c $05
	wait1 $03
	vol $4
	note $3c $03
	wait1 $05
	vol $3
	note $3c $03
	wait1 $13
	duty $01
	vol $6
	note $24 $2c
	note $27 $2c
	note $29 $16
	note $2b $0b
	note $2c $0b
	note $2d $16
	duty $02
	vol $4
	note $30 $03
	wait1 $03
	vol $3
	note $30 $05
	wait1 $03
	vol $2
	note $30 $03
	wait1 $05
	duty $01
	vol $6
	note $1d $21
	note $1f $0b
	vol $6
	note $21 $16
	note $22 $16
	note $24 $16
	vol $6
	note $26 $0b
	vol $6
	note $28 $0b
	note $29 $0b
	wait1 $03
	vol $3
	note $29 $03
	wait1 $08
	vol $2
	note $29 $03
	wait1 $26
	duty $02
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
	note $3b $03
	wait1 $03
	vol $5
	note $3c $05
	wait1 $03
	vol $4
	note $3c $03
	wait1 $05
	vol $4
	note $3c $03
	wait1 $29
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
	note $3b $03
	wait1 $03
	vol $5
	note $3c $05
	wait1 $03
	vol $4
	note $3c $03
	wait1 $05
	vol $3
	note $3c $03
	wait1 $29
	vol $6
	note $35 $03
	wait1 $03
	vol $5
	note $35 $05
	wait1 $03
	vol $3
	note $35 $03
	wait1 $05
	vol $6
	note $40 $03
	wait1 $03
	vol $5
	note $41 $05
	wait1 $03
	vol $4
	note $41 $03
	wait1 $05
	vol $4
	note $41 $03
	wait1 $29
	vol $6
	note $35 $03
	wait1 $03
	vol $5
	note $35 $05
	wait1 $03
	vol $3
	note $35 $03
	wait1 $05
	vol $6
	note $40 $03
	wait1 $03
	vol $5
	note $41 $05
	wait1 $03
	vol $4
	note $41 $03
	wait1 $05
	vol $3
	note $41 $03
	wait1 $13
	goto musicfb85d
	cmdff
; $fba6b
; @addr{fba6b}
sound25Channel4:
musicfba6b:
	duty $0e
	note $1d $2c
	note $22 $16
	note $24 $16
	note $27 $2c
	note $26 $16
	note $24 $16
	note $1d $16
	note $22 $16
	note $24 $16
	note $27 $16
	note $26 $2c
	note $22 $16
	note $1f $16
	note $1b $2c
	note $20 $16
	note $22 $16
	note $25 $2c
	note $24 $16
	note $22 $16
	note $1b $2c
	note $22 $2c
	note $25 $2c
	note $24 $16
	note $22 $16
	note $1d $2c
	note $22 $2c
	note $24 $19
	note $22 $03
	note $21 $05
	note $20 $03
	note $1f $03
	note $1e $05
	note $1d $0b
	wait1 $21
	note $39 $21
	note $37 $0b
	note $30 $16
	note $33 $16
	note $35 $16
	note $39 $16
	note $37 $0b
	duty $0f
	note $37 $07
	wait1 $1a
	duty $0e
	note $21 $21
	note $1f $0b
	note $1d $0b
	duty $0f
	note $1d $0b
	duty $0e
	note $18 $0b
	duty $0f
	note $18 $0b
	duty $0e
	note $1b $2c
	note $1d $0b
	duty $0f
	note $1d $07
	duty $0e
	note $17 $04
	note $18 $07
	wait1 $0f
	note $1d $2c
	note $22 $16
	note $24 $16
	note $27 $2c
	note $26 $16
	note $24 $10
	wait1 $06
	note $1d $16
	duty $0f
	note $1d $16
	duty $0e
	note $24 $16
	duty $0f
	note $24 $16
	duty $0e
	note $18 $16
	duty $0f
	note $18 $16
	duty $0e
	note $24 $16
	duty $0f
	note $24 $16
	goto musicfba6b
	cmdff
; $fbb1b
; @addr{fbb1b}
sound0cChannel1:
	vibrato $00
	env $0 $00
	duty $02
musicfbb21:
	vol $6
	note $39 $0b
	vol $3
	note $39 $0b
	vol $6
	note $36 $0b
	vol $3
	note $36 $0b
	vol $6
	note $39 $0b
	vol $3
	note $39 $0b
	vol $6
	note $36 $0b
	vol $3
	note $36 $0b
	vol $6
	note $3b $0b
	wait1 $0b
	note $38 $0b
	wait1 $03
	vol $3
	note $38 $05
	wait1 $06
	vol $2
	note $38 $05
	wait1 $06
	vol $1
	note $38 $05
	wait1 $19
	vol $6
	note $37 $0b
	vol $3
	note $34 $0b
	vol $6
	note $34 $0b
	vol $3
	note $34 $0b
	vol $6
	note $39 $0b
	vol $3
	note $39 $0b
	vol $6
	note $36 $0b
	vol $4
	note $36 $05
	wait1 $06
	vol $3
	note $36 $05
	wait1 $06
	vol $3
	note $36 $05
	wait1 $48
	vol $6
	note $35 $0b
	vol $3
	note $35 $0b
	vol $6
	note $32 $0b
	vol $3
	note $32 $0b
	vol $6
	note $35 $0b
	vol $3
	note $35 $0b
	vol $6
	note $32 $0b
	vol $3
	note $32 $0b
	wait1 $0b
	vol $6
	note $34 $0b
	note $35 $0b
	note $37 $0b
	wait1 $07
	vol $3
	note $37 $05
	wait1 $05
	vol $3
	note $37 $06
	wait1 $05
	vol $1
	note $37 $06
	wait1 $0a
	vol $6
	note $3b $07
	wait1 $04
	vol $3
	note $3b $07
	wait1 $04
	vol $6
	note $39 $07
	wait1 $04
	vol $3
	note $39 $07
	wait1 $04
	vol $6
	note $3b $07
	wait1 $04
	vol $3
	note $3b $07
	wait1 $04
	vol $6
	note $39 $07
	wait1 $04
	vol $3
	note $39 $07
	wait1 $04
	vol $6
	note $38 $05
	wait1 $09
	vol $4
	note $38 $03
	wait1 $08
	vol $3
	note $38 $03
	wait1 $08
	vol $2
	note $38 $03
	wait1 $05
	vol $6
	note $37 $05
	wait1 $09
	vol $3
	note $37 $03
	wait1 $08
	vol $2
	note $37 $03
	wait1 $08
	vol $1
	note $37 $03
	wait1 $05
	vol $7
	note $3b $0b
	wait1 $05
	vol $3
	note $3b $06
	vol $6
	note $3e $0b
	wait1 $05
	vol $3
	note $3e $06
	vol $6
	note $40 $0b
	wait1 $05
	vol $3
	note $40 $06
	vol $6
	note $3d $0b
	wait1 $05
	vol $3
	note $3d $06
	vol $6
	note $34 $07
	wait1 $07
	vol $3
	note $34 $01
	wait1 $0a
	vol $2
	note $34 $05
	wait1 $0e
	vol $6
	note $31 $07
	wait1 $07
	vol $3
	note $31 $01
	wait1 $1d
	vol $6
	note $39 $0b
	wait1 $05
	vol $3
	note $39 $06
	vol $6
	note $3b $0b
	wait1 $05
	vol $3
	note $3b $06
	vol $6
	note $3e $0b
	wait1 $05
	vol $3
	note $3e $06
	vol $6
	note $3d $0b
	wait1 $05
	vol $3
	note $3d $06
	vol $6
	note $3b $0b
	wait1 $03
	vol $2
	note $3b $05
	wait1 $06
	vol $1
	note $3b $05
	wait1 $3a
	vol $6
	note $37 $0b
	wait1 $05
	vol $3
	note $37 $06
	vol $6
	note $39 $0b
	wait1 $05
	vol $3
	note $39 $06
	vol $6
	note $3b $0b
	wait1 $05
	vol $3
	note $3b $06
	wait1 $05
	vol $2
	note $3b $06
	wait1 $0b
	vol $6
	note $39 $0b
	wait1 $05
	vol $3
	note $39 $06
	vol $6
	note $34 $0b
	wait1 $05
	vol $3
	note $34 $06
	vol $6
	note $3e $0b
	wait1 $05
	vol $3
	note $3e $06
	wait1 $0b
	vol $6
	note $3d $05
	note $3c $06
	vol $6
	note $3b $6e
	wait1 $42
	goto musicfbb21
	cmdff
; $fbca6
; @addr{fbca6}
sound0cChannel0:
	vibrato $00
	env $0 $00
	duty $02
musicfbcac:
	wait1 $0b
	vol $6
	note $32 $0b
	wait1 $05
	vol $3
	note $32 $06
	vol $6
	note $32 $0b
	wait1 $0b
	note $32 $0b
	wait1 $05
	vol $3
	note $32 $06
	vol $6
	note $32 $0b
	wait1 $0b
	note $32 $0b
	wait1 $05
	vol $4
	note $32 $06
	wait1 $03
	vol $3
	note $32 $05
	wait1 $06
	vol $2
	note $32 $05
	wait1 $2f
	vol $6
	note $30 $0b
	wait1 $07
	vol $3
	note $30 $06
	vol $6
	note $30 $0b
	wait1 $05
	vol $3
	note $30 $04
	vol $6
	note $32 $0b
	wait1 $05
	vol $3
	note $32 $06
	vol $6
	note $32 $0b
	wait1 $05
	vol $3
	note $32 $06
	wait1 $05
	vol $3
	note $32 $06
	wait1 $05
	vol $2
	note $32 $06
	wait1 $42
	vol $6
	note $30 $0b
	wait1 $07
	vol $3
	note $30 $06
	vol $6
	note $30 $0b
	wait1 $03
	vol $3
	note $30 $06
	vol $6
	note $30 $0b
	wait1 $05
	vol $3
	note $30 $06
	vol $6
	note $30 $0b
	wait1 $05
	vol $4
	note $30 $06
	wait1 $05
	vol $3
	note $30 $06
	wait1 $05
	vol $2
	note $30 $06
	wait1 $0b
	vol $6
	note $3e $0b
	note $40 $0b
	note $41 $0b
	note $43 $0b
	wait1 $03
	vol $4
	note $43 $05
	wait1 $06
	vol $2
	note $43 $05
	wait1 $19
	vol $6
	note $37 $0b
	wait1 $03
	vol $4
	note $37 $05
	wait1 $19
	vol $6
	note $3c $05
	wait1 $06
	note $3c $05
	wait1 $06
	vol $4
	note $3c $05
	wait1 $06
	vol $2
	note $3c $05
	wait1 $06
	vol $6
	note $3b $05
	wait1 $06
	note $3b $05
	wait1 $06
	vol $4
	note $3b $05
	wait1 $06
	vol $2
	note $3b $05
	wait1 $11
	vol $6
	note $2f $0b
	wait1 $03
	vol $3
	note $2f $05
	wait1 $03
	vol $6
	note $32 $0b
	wait1 $03
	vol $3
	note $32 $05
	wait1 $03
	vol $6
	note $34 $0b
	wait1 $03
	vol $3
	note $34 $05
	wait1 $03
	vol $6
	note $31 $0b
	wait1 $03
	vol $3
	note $31 $05
	wait1 $03
	vol $6
	note $47 $03
	wait1 $03
	vol $2
	note $47 $05
	vol $6
	note $43 $07
	wait1 $04
	vol $3
	note $43 $05
	wait1 $11
	vol $6
	note $47 $03
	wait1 $03
	vol $3
	note $47 $05
	vol $6
	note $43 $07
	wait1 $04
	vol $3
	note $43 $05
	wait1 $11
	vol $6
	note $36 $0b
	wait1 $03
	vol $3
	note $36 $05
	wait1 $03
	vol $6
	note $34 $0b
	wait1 $05
	vol $3
	note $34 $06
	vol $6
	note $37 $0b
	wait1 $05
	vol $3
	note $37 $06
	vol $6
	note $39 $0b
	wait1 $03
	vol $3
	note $39 $05
	wait1 $03
	vol $6
	note $36 $03
	wait1 $03
	vol $6
	note $36 $05
	vol $6
	note $32 $03
	wait1 $03
	vol $6
	note $32 $05
	vol $5
	note $36 $05
	wait1 $01
	vol $3
	note $36 $05
	vol $6
	note $31 $03
	wait1 $03
	vol $3
	note $31 $05
	vol $7
	note $36 $05
	wait1 $01
	vol $3
	note $36 $05
	vol $6
	note $2f $03
	wait1 $03
	vol $3
	note $2f $05
	vol $6
	note $36 $05
	wait1 $01
	vol $3
	note $36 $05
	wait1 $0b
	vol $6
	note $34 $0b
	note $36 $03
	wait1 $03
	vol $3
	note $36 $05
	vol $6
	note $34 $03
	wait1 $03
	vol $3
	note $34 $05
	vol $4
	note $34 $0b
	vol $6
	note $36 $0b
	note $34 $0b
	note $2f $0b
	wait1 $05
	vol $3
	note $2f $06
	vol $6
	note $32 $0b
	wait1 $05
	vol $3
	note $32 $06
	vol $6
	note $2d $0b
	wait1 $05
	vol $3
	note $2d $06
	vol $6
	note $34 $07
	vol $4
	note $34 $04
	vol $5
	note $2d $07
	note $2d $04
	wait1 $07
	vol $2
	note $31 $03
	wait1 $01
	vol $7
	note $2c $05
	wait1 $06
	vol $3
	note $2c $05
	wait1 $06
	vol $6
	note $31 $05
	wait1 $06
	vol $3
	note $31 $05
	wait1 $06
	vol $7
	note $38 $05
	wait1 $06
	vol $3
	note $38 $05
	wait1 $06
	vol $7
	note $31 $05
	wait1 $06
	vol $3
	note $31 $05
	wait1 $06
	vol $7
	note $38 $05
	wait1 $06
	vol $3
	note $38 $05
	wait1 $06
	vol $6
	note $3d $05
	wait1 $06
	vol $3
	note $3d $05
	wait1 $06
	vol $6
	note $44 $05
	wait1 $06
	vol $3
	note $44 $05
	wait1 $06
	vol $7
	note $3d $05
	wait1 $06
	vol $3
	note $3d $05
	wait1 $06
	goto musicfbcac
	cmdff
; $fbeb8
sound60Start:
; @addr{fbeb8}
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
; $fbecd
sound61Start:
; @addr{fbecd}
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
; $fbee7
sound6bStart:
; @addr{fbee7}
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
; $fbf2c
sound6cStart:
; @addr{fbf2c}
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
; $fbf41
sound6dStart:
; @addr{fbf41}
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
; $fbf66
sound6eStart:
; @addr{fbf66}
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
; $fbf83
sound79Start:
; @addr{fbf83}
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
; $fbfce
sound78Start:
; @addr{fbfce}
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
; $fbfe3
sound77Start:
; @addr{fbfe3}
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
; $fbff2
sound66Start:
; @addr{fbff2}
sound66Channel2:
	duty $02
	vol $2
	note $41 $02
	duty $02
	vol $b
	note $41 $01
	cmdff
; $fbffd
