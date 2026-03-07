sndMagicPowderStart:

sndMagicPowderChannel2:
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
