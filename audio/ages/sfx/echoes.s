sndEchoesStart:

sndEchoesChannel2:
	duty $02
	env $0 $03
	vol $9
	note c5  $0c
	note e5  $0c
	note g5  $0c
	note d5  $0c
	note f5  $0c
	note a5  $0c
	note e5  $0c
	note g5  $0c
	note b5  $0c
	note f5  $0c
	note a5  $0c
	note c6  $0c
	note g5  $0c
	rest $0c
	note g5  $03
	note b5  $03
	note d6  $03
	env $0 $07
	note g6  $3f
	rest $14
	cmdff

sndEchoesChannel3:
	duty $02
	env $0 $03
	vol $0
	note gs3 $12
	vol $5
	note c5  $0c
	note e5  $0c
	note g5  $0c
	note d5  $0c
	note f5  $0c
	note a5  $0c
	note e5  $0c
	note g5  $0c
	note b5  $0c
	note f5  $0c
	note a5  $0c
	note c6  $0c
	note g5  $0c
	rest $0c
	note g5  $03
	note b5  $03
	note d6  $03
	env $0 $07
	note g6  $3f
	cmdff

sndEchoesChannel5:
	duty $0e
	rest $fa
	rest $08
	cmdff

sndEchoesChannel7:
	cmdf0 $00
	note $00 $fa
	note $00 $08
	cmdff
