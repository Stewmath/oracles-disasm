sndDanceMoveStart:
sndDanceMoveChannel2:
	duty $02
	vol $f
	cmdf8 $ee
	note e3  $02
	cmdf8 $00
	vol $f
	note a2  $01
	vol $f
	note a2  $04
	env $0 $01
	note as2 $0c
	cmdf8 $f6
	cmdff
sndDanceMoveChannel7:
	cmdf0 $f1
	note $54 $02
	cmdf0 $51
	note $25 $0a
	cmdff