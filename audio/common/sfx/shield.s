sndShieldStart:

sndShieldChannel2:
	duty $00
	vol $0
	pitchSlide $00
	env $0 $00
	note c7  $01
	vol $f
	pitchSlide $00
	env $0 $01
	note c2  $01
	vol $e
	pitchSlide $00
	env $0 $01
	note c7  $01
	vol $0
	note c7  $02
	cmdff

sndShieldChannel7:
	cmdf0 $10
	note $26 $01
	cmdf0 $70
	note $24 $01
	cmdf0 $00
	note $36 $01
	cmdff
