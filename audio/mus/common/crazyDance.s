musCrazyDanceStart:

musCrazyDanceChannel1:
	vibrato $00
	env $0 $02
	cmdf2
	duty $02
	vol $6
	note b6  $02
	note as6 $02
	note b6  $03
	note as6 $02
	note b6  $07
	rest $28
	note c7  $02
	note b6  $02
	note c7  $03
	note b6  $02
	note c7  $07
	rest $3c
musicf79ae:
	vibrato $00
	env $0 $00
	duty $00
	note d6  $05
	note ds6 $05
	note d6  $05
	note cs6 $05
	note c6  $05
	note b5  $05
	note c6  $05
	note cs6 $05
	note d6  $05
	note ds6 $05
	note d6  $05
	note cs6 $05
	note c6  $05
	note b5  $05
	note c6  $05
	note cs6 $05
	note d6  $05
	vol $3
	note d6  $05
	vol $6
	note d7  $05
	vol $3
	note d7  $05
	vol $6
	note d6  $05
	vol $3
	note d6  $05
	vol $6
	note d6  $05
	note ds6 $05
	note e6  $05
	note f6  $05
	note e6  $05
	note ds6 $05
	note d6  $05
	vol $3
	note d6  $05
	rest $0a
	vol $6
	note d6  $05
	note ds6 $05
	note d6  $05
	note cs6 $05
	note c6  $05
	note b5  $05
	note c6  $05
	note cs6 $05
	note d6  $05
	note ds6 $05
	note d6  $05
	note cs6 $05
	note c6  $05
	note b5  $05
	note c6  $05
	note cs6 $05
	note d6  $05
	vol $3
	note d6  $05
	vol $6
	note d7  $05
	vol $3
	note d7  $05
	vol $6
	note d6  $05
	vol $3
	note d6  $05
	vol $6
	note d6  $05
	note ds6 $05
	note e6  $05
	note f6  $05
	note e6  $05
	note ds6 $05
	note d6  $05
	vol $3
	note d6  $05
	rest $0a
	vol $5
	note d6  $05
	note ds6 $05
	note d6  $05
	note cs6 $05
	note c6  $05
	note b5  $05
	note c6  $05
	note cs6 $05
	note d6  $05
	note ds6 $05
	note d6  $05
	note cs6 $05
	note c6  $05
	note b5  $05
	note c6  $05
	note cs6 $05
	vol $2
	note cs6 $05
	rest $69
	vibrato $00
	env $0 $02
	duty $02
	vol $6
	note d7  $02
	note c7  $02
	note b6  $02
	note a6  $04
	note g6  $02
	note fs6 $02
	note e6  $02
	note d6  $0b
	rest $53
	vibrato $00
	env $0 $00
	duty $00
	goto musicf79ae
	cmdff

musCrazyDanceChannel0:
	vibrato $00
	env $0 $02
	cmdf2
	duty $02
	vol $6
	note f6  $07
	rest $31
	note fs6 $07
	rest $45
musicf7a98:
	vol $6
	note g4  $05
	rest $05
	note d5  $05
	rest $05
	note d4  $05
	rest $05
	note d5  $05
	rest $05
	note g4  $05
	rest $05
	note d5  $05
	rest $05
	note d4  $05
	rest $05
	note d5  $05
	rest $05
	note gs4 $05
	rest $05
	note ds5 $05
	rest $05
	note ds4 $05
	rest $05
	note ds5 $05
	rest $05
	note gs4 $05
	rest $05
	note ds5 $05
	rest $05
	note ds4 $05
	rest $05
	note ds5 $05
	rest $05
	note as4 $05
	rest $05
	note f5  $05
	rest $05
	note f4  $05
	rest $05
	note f5  $05
	rest $05
	note as4 $05
	rest $05
	note f5  $05
	rest $05
	note f4  $05
	rest $05
	note f5  $05
	rest $05
	note c5  $05
	rest $05
	note g5  $05
	rest $05
	note g4  $05
	rest $05
	note g5  $05
	rest $05
	note c5  $05
	rest $05
	note g5  $05
	rest $05
	note b4  $05
	rest $05
	note a4  $05
	rest $05
	vol $5
	note g4  $05
	rest $05
	note d5  $05
	rest $05
	note d4  $05
	rest $05
	note d5  $05
	rest $05
	note g4  $05
	rest $05
	note d5  $05
	rest $05
	note d4  $05
	rest $05
	note d5  $05
	rest $78
	vol $3
	note d7  $02
	note c7  $03
	note b6  $02
	note a6  $02
	note g6  $02
	note fs6 $04
	note e6  $02
	note d6  $0a
	rest $4e
	goto musicf7a98
	cmdff

.define musCrazyDanceChannel4 MUSIC_CHANNEL_FALLBACK EXPORT
.define musCrazyDanceChannel6 MUSIC_CHANNEL_FALLBACK EXPORT
