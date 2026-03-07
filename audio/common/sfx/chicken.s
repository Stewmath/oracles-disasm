sndChickenStart:

sndChickenChannel2:
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
