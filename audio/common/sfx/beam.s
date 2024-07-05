sndBeamStart:

sndBeamChannel2:
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

sndBeamChannel7:
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
