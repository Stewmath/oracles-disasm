musSunkenCityStart:

musSunkenCityChannel1:
	vibrato $e1
	env $0 $00
	duty $02
musiced98b:
	vol $6
	note g4  $1c
	note c5  $07
	rest $03
	vol $3
	note c5  $04
	vol $6
	note g4  $07
	rest $03
	vol $3
	note g4  $04
	vol $6
	note fs4 $1c
	note b4  $07
	rest $03
	vol $3
	note b4  $07
	rest $04
	vol $1
	note b4  $07
	vol $6
	note g4  $07
	rest $03
	vol $3
	note g4  $04
	vol $6
	note g4  $0e
	note c5  $0e
	note g4  $0e
	note fs4 $0e
	note cs5 $04
	rest $06
	vol $3
	note cs5 $04
	vol $6
	note as4 $04
	rest $06
	vol $3
	note as4 $04
	vol $6
	note fs4 $04
	rest $06
	vol $3
	note fs4 $04
	vol $6
	note e5  $04
	note f5  $05
	note fs5 $05
	note g5  $04
	rest $03
	vol $4
	note g5  $02
	rest $02
	vol $3
	note g5  $03
	rest $1c
	vol $6
	note b6  $04
	note a6  $05
	note g6  $05
	note ds6 $04
	rest $03
	vol $4
	note ds6 $02
	rest $02
	vol $2
	note ds6 $03
	rest $1c
	vol $6
	note g4  $1c
	note c5  $07
	rest $03
	vol $3
	note c5  $04
	vol $6
	note g4  $07
	rest $03
	vol $3
	note g4  $04
	vol $6
	note fs4 $0e
	note cs5 $0e
	note as4 $0e
	vol $3
	note as4 $0e
	vol $6
	note g4  $07
	rest $03
	vol $3
	note g4  $04
	vol $6
	note g4  $0e
	note c5  $0e
	note e5  $0e
	note fs5 $0e
	note ds5 $0e
	rest $03
	vol $3
	note ds5 $07
	rest $04
	vol $6
	note a5  $0e
	rest $38
	vibrato $00
	env $0 $02
	duty $00
	vol $6
	note f5  $0e
	vol $6
	note b4  $0e
	note b4  $0e
	note f5  $0e
	rest $38
	vol $6
	note e5  $0e
	rest $2a
	vibrato $e1
	env $0 $00
	duty $02
	goto musiced98b
	cmdff

musSunkenCityChannel0:
	vibrato $00
	env $0 $03
	duty $02
musiceda60:
	vol $6
	note c3  $0e
	rest $0e
	note e3  $0e
	rest $0e
	note g2  $0e
	rest $0e
	note e3  $0e
	rest $0e
	note c3  $0e
	rest $0e
	note e3  $0e
	rest $0e
	note g2  $0e
	rest $0e
	note e3  $0e
	rest $2a
	vibrato $00
	env $0 $00
	vol $6
	note e2  $04
	note f2  $05
	note fs2 $05
	note g2  $04
	rest $03
	vol $5
	note g2  $02
	rest $02
	vol $3
	note g2  $03
	rest $1c
	vol $6
	note b2  $04
	note a2  $05
	note g2  $05
	note ds2 $04
	rest $03
	vol $4
	note ds2 $02
	rest $05
	vibrato $00
	env $0 $03
	vol $6
	note c3  $0e
	rest $0e
	vol $6
	note e3  $0e
	rest $0e
	note g2  $0e
	rest $0e
	note e3  $0e
	rest $0e
	note c3  $0e
	rest $0e
	note e3  $0e
	rest $0e
	note g2  $0e
	rest $0e
	note e3  $0e
	rest $46
	vibrato $00
	env $0 $02
	duty $00
	vol $6
	note cs5 $0e
	note g4  $0e
	note g4  $0e
	note cs5 $0e
	rest $38
	note c5  $0e
	rest $2a
	vibrato $00
	env $0 $03
	duty $02
	goto musiceda60
	cmdff

musSunkenCityChannel4:
musicedaef:
	rest $ff
	rest $5f
	duty $17
	note g4  $07
	rest $07
	note g5  $07
	rest $23
	note g4  $07
	rest $07
	note g5  $07
	rest $23
	note g4  $07
	rest $07
	note g5  $07
	rest $23
	note g4  $07
	rest $07
	note g5  $07
	rest $15
	duty $10
	note fs2 $03
	note g2  $6d
	rest $1c
	note g2  $07
	note gs2 $07
	note a2  $07
	note b2  $05
	note b2  $02
	note c3  $07
	rest $07
	note g2  $07
	rest $05
	note as2 $02
	note gs2 $0e
	note g2  $07
	rest $07
	goto musicedaef
	cmdff

.define musSunkenCityChannel6 MUSIC_CHANNEL_FALLBACK EXPORT
