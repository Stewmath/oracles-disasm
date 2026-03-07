sndSeedShooterStart:

sndSeedShooterChannel2:
	duty $02
	vol $c
	cmdf8 $28
	note ds5 $02
	cmdf8 $00
	note ds5 $01
	duty $02
	vol $6
	vibrato $01
	env $0 $02
	note ds5 $0c
	cmdff

sndSeedShooterChannel7:
	cmdf0 $b1
	note $25 $01
	cmdf0 $41
	note $14 $0a
	cmdff
