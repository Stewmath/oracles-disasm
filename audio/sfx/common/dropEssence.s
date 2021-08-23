sndDropEssenceStart:

sndDropEssenceChannel2:
	duty $00
	vol $d
	cmdf8 $00
	env $0 $01
	note c7  $0f
	vol $6
	env $0 $02
	note c7  $0f
	cmdff
