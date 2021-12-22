sndThrowStart:

sndThrowChannel2:
	duty $02
	vol $d
	env $1 $00
	cmdf8 $f4
	note d6  $0a
	cmdf8 $00
	vol $8
	env $0 $01
	cmdf8 $e0
	note c5  $08
	cmdff
