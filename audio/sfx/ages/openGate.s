sndOpenGateStart:

sndOpenGateChannel2:
	duty $01
	vol $a
	cmdf8 $ce
	note cs3 $05
	cmdff

sndOpenGateChannel7:
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
