sndMonkeyStart:

sndMonkeyChannel2:
	duty $00
	vol $a
	cmdf8 $0a
	note c6  $05
	cmdf8 $00
	cmdff

.define sndMonkeyChannel7 MUSIC_CHANNEL_FALLBACK EXPORT
