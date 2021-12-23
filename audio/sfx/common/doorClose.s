sndDoorCloseStart:

sndDoorCloseChannel2:
	duty $01
	vol $0
	rest $02
	vol $6
	note c4  $01
	cmdf8 $0f
	note c4  $05
	cmdf8 $00
	cmdff

sndDoorCloseChannel7:
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
