sndTingleStart:

sndTingleChannel2:
	duty $01
	cmdf8 $fc
	vol $b
	note ds4 $05
	rest $01
	vol $0
	note ds4 $01
	cmdf8 $02
	env $0 $07
	vol $a
	note ds4 $46
	env $0 $00
	vol $9
	note e5  $01
	vol $a
	note f5  $01
	vol $b
	note fs5 $05
	cmdf8 $fc
	env $0 $02
	vol $b
	note fs5 $17
	cmdff
