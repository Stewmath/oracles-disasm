sndAgesStart:

sndAgesChannel2:
	duty $02
	env $0 $02
	vol $9
	note c5  $03
	note e5  $04
	note g5  $03
	note c6  $07
	note b5  $07
	note a5  $07
	note b5  $07
	note g5  $07
	note d6  $07
	note c6  $07
	note b5  $07
	note a5  $07
	note b5  $07
	note c6  $07
	note d6  $07
	note g5  $07
	note a5  $07
	note g5  $07
	note e5  $07
	note f5  $07
	rest $07
	note a5  $07
	rest $07
	note c6  $07
	rest $07
	note d6  $07
	rest $07
	note e4  $04
	note g4  $03
	note b4  $04
	note c5  $03
	note e5  $04
	note g5  $03
	note b5  $04
	env $0 $06
	note e6  $2d
	rest $0a
	cmdff

sndAgesChannel3:
	duty $02
	env $0 $02
	vol $0
	note gs3 $0a
	vol $5
	note c5  $04
	note e5  $03
	note g5  $04
	note c6  $07
	note b5  $07
	note a5  $07
	note b5  $07
	note g5  $07
	note d6  $07
	note c6  $07
	note b5  $07
	note a5  $07
	note b5  $07
	note c6  $07
	note d6  $07
	note g5  $07
	note a5  $07
	note g5  $07
	note e5  $07
	note f5  $07
	rest $07
	note a5  $07
	rest $07
	note c6  $07
	rest $07
	note d6  $07
	rest $07
	note e4  $03
	note g4  $04
	note b4  $03
	note c5  $04
	note e5  $03
	note g5  $04
	note b5  $03
	env $0 $06
	note e6  $2d
	cmdff

sndAgesChannel5:
	duty $0e
	rest $c8
	rest $3a
	cmdff

sndAgesChannel7:
	cmdf0 $00
	note $00 $c8
	note $00 $3a
	cmdff
