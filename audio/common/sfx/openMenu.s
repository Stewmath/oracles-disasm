sndOpenMenuStart:

sndOpenMenuChannel2:
	duty $01
	vol $f
	env $3 $00
	cmdf8 $23
	note c3  $16
	cmdff

sndOpenMenuChannel3:
	duty $02
	vol $f
	env $3 $00
	cmdf8 $2c
	note c2  $16
	cmdff
