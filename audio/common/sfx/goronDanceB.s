sndGoronDanceBStart:

sndGoronDanceBChannel2:
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

sndGoronDanceBChannel3:
	duty $00
	vol $0
	rest $03
	vol $d
	note g5  $03
	vol $a
	env $0 $01
	note g5  $08
	cmdff

sndGoronDanceBChannel7:
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
