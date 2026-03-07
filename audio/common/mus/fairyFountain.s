musFairyFountainStart:

musFairyFountainChannel1:
	vibrato $00
	env $0 $02
	duty $02
musicec76b:
	vol $6
	note b3  $0c
	note cs4 $0c
	note e4  $0c
	note g4  $0c
	note b4  $0c
	note cs5 $0c
	note e5  $0c
	note g5  $0c
	note b5  $0c
	note cs6 $0c
	note e6  $0c
	note g6  $0c
	note b6  $0c
	note cs7 $0c
	note e7  $0c
	note g7  $0c
	note as3 $0c
	note c4  $0c
	note ds4 $0c
	note fs4 $0c
	note as4 $0c
	note c5  $0c
	note ds5 $0c
	note fs5 $0c
	note as5 $0c
	note c6  $0c
	note ds6 $0c
	note fs6 $0c
	note as6 $0c
	note c7  $0c
	note ds7 $0c
	note fs7 $0c
	goto musicec76b
	cmdff

musFairyFountainChannel0:
	vol $1
	note b3  $06
	vibrato $00
	env $0 $02
	duty $02
musicec7b9:
	vol $6
	note b3  $0c
	note cs4 $0c
	note e4  $0c
	note g4  $0c
	note b4  $0c
	note cs5 $0c
	note e5  $0c
	note g5  $0c
	note b5  $0c
	note cs6 $0c
	note e6  $0c
	note g6  $0c
	note b6  $0c
	note cs7 $0c
	note e7  $0c
	note g7  $0c
	note as3 $0c
	note c4  $0c
	note ds4 $0c
	note fs4 $0c
	note as4 $0c
	note c5  $0c
	note ds5 $0c
	note fs5 $0c
	note as5 $0c
	note c6  $0c
	note ds6 $0c
	note fs6 $0c
	note as6 $0c
	note c7  $0c
	note ds7 $0c
	note fs7 $0c
	goto musicec7b9
	cmdff

musFairyFountainChannel4:
	duty $0f
	rest $09
musicec802:
	note b3  $0c
	note cs4 $0c
	note e4  $0c
	note g4  $0c
	note b4  $0c
	note cs5 $0c
	note e5  $0c
	note g5  $0c
	note b5  $0c
	note cs6 $0c
	note e6  $0c
	note g6  $0c
	note b6  $0c
	note cs7 $0c
	note e7  $0c
	note g7  $0c
	note as3 $0c
	note c4  $0c
	note ds4 $0c
	note fs4 $0c
	note as4 $0c
	note c5  $0c
	note ds5 $0c
	note fs5 $0c
	note as5 $0c
	note c6  $0c
	note ds6 $0c
	note fs6 $0c
	note as6 $0c
	note c7  $0c
	note ds7 $0c
	note fs7 $0c
	goto musicec802
	cmdff

.define musFairyFountainChannel6 MUSIC_CHANNEL_FALLBACK EXPORT
