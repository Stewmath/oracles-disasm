sndMakuTreeSnoreStart:
sndMakuTreeSnoreChannel2:
	duty $01
	env $2 $04
	vol $7
	cmdf8 $09
	cmdfd $fc
	note b3  $41
	vol $0
	rest $11
	env $3 $03
	vol $4
	cmdf8 $f8
	note e5  $37
	cmdff