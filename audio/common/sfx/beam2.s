sndBeam2Start:

sndBeam2Channel7:
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

.ifdef ROM_SEASONS
.ifdef BUILD_VANILLA
	.db $ff $ff
.endif
.endif
