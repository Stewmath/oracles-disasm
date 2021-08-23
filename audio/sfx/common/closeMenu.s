sndCloseMenuStart:

sndCloseMenuChannel2:
	duty $02
	vol $d
	env $1 $00
	cmdf8 $d3
	note g4  $09
	cmdff

sndCloseMenuChannel3:
	duty $01
	vol $d
	env $1 $00
	cmdf8 $e0
	note g4  $09
	cmdff
