sndPoofStart:

sndPoofChannel2:
	vol $d
	cmdf0 $80
	pitchSlide $61
	.db $05 $39 $03
	pitchSlide $9f
	.db $06 $3f $03
	pitchSlide $61
	.db $05 $39 $03
	pitchSlide $9f
	.db $06 $3f $03
	pitchSlide $61
	.db $05 $39 $03
	vol $8
	pitchSlide $9f
	.db $06 $3f $03
	vol $6
	pitchSlide $61
	.db $05 $39 $03
	vol $4
	pitchSlide $9f
	.db $06 $3f $03
	vol $2
	pitchSlide $66
	.db $05 $39 $03
	cmdff
