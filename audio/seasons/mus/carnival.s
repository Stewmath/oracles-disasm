musCarnivalStart:

musCarnivalChannel1:
	vibrato $00
	env $0 $03
	duty $02
musiceeb67:
	vol $6
	note g4  $0e
	vibrato $00
	env $0 $04
	note e4  $1c
	vibrato $00
	env $0 $03
	note g4  $0e
	note ds4 $0e
	vibrato $00
	env $0 $04
	note b4  $1c
	vibrato $00
	env $0 $03
	note a4  $0e
	note g4  $0e
	vibrato $00
	env $0 $04
	note e4  $1c
	vibrato $00
	env $0 $03
	note c4  $0e
	note b3  $0e
	note ds4 $07
	note fs4 $07
	note b4  $0e
	note a4  $0e
	vibrato $00
	env $0 $04
	note g4  $1c
	vibrato $00
	env $0 $03
	note a4  $0e
	note b4  $0e
	note c5  $0e
	note d5  $0e
	note e5  $0e
	note f5  $0e
	vibrato $00
	env $0 $04
	note g5  $1c
	vibrato $00
	env $0 $03
	note f5  $0e
	note cs5 $0e
	vibrato $00
	env $0 $04
	note e5  $1c
	note d5  $1c
	vibrato $00
	env $0 $03
	note a5  $0e
	vibrato $00
	env $0 $04
	note f5  $1c
	vibrato $00
	env $0 $03
	note e5  $0e
	note ds5 $0e
	note b5  $07
	note c6  $07
	note b5  $0e
	note a5  $0e
	note g5  $0e
	vibrato $00
	env $0 $04
	note e5  $1c
	vibrato $00
	env $0 $03
	note g5  $0e
	note cs5 $0e
	note a5  $07
	note as5 $07
	note a5  $0e
	note g5  $0e
	note g5  $0e
	note f5  $0e
	note e5  $0e
	note f5  $0e
	note g5  $0e
	note f5  $0e
	note a5  $0e
	note c6  $0e
	note e6  $0e
	note d6  $0e
	note c6  $0e
	note e6  $0e
	vibrato $00
	env $0 $04
	note d6  $1c
	rest $1c
	vibrato $00
	env $0 $03
	goto musiceeb67
	cmdff

musCarnivalChannel0:
	vibrato $00
	env $0 $03
	duty $02
musiceec2a:
	vol $6
	note c3  $0e
	note e3  $0e
	note g2  $0e
	note e3  $0e
	note b2  $0e
	note ds3 $0e
	note fs2 $0e
	note ds3 $0e
	note c3  $0e
	note e3  $0e
	note g2  $0e
	note e3  $0e
	note b2  $0e
	note ds3 $0e
	note fs2 $0e
	note ds3 $0e
	note c3  $0e
	note e3  $0e
	note g2  $0e
	note e3  $0e
	note a2  $0e
	note e3  $0e
	note c3  $0e
	note e3  $0e
	note d3  $0e
	note f3  $0e
	note a2  $0e
	note f3  $0e
	note g2  $0e
	note a2  $0e
	note b2  $0e
	note g2  $0e
	note f3  $0e
	note a3  $0e
	note c3  $0e
	note a3  $0e
	note b2  $0e
	note fs3 $0e
	note ds3 $0e
	note fs3 $0e
	note e3  $0e
	note g3  $0e
	note b2  $0e
	note g3  $0e
	note a2  $0e
	note e3  $0e
	note cs3 $0e
	note e3  $0e
	note d3  $0e
	note f3  $0e
	note a2  $0e
	note f3  $0e
	note d3  $0e
	note f3  $0e
	note a2  $0e
	note gs2 $0e
	note g2  $0e
	note d3  $0e
	note d2  $0e
	note d3  $0e
	note g2  $0e
	note g2  $0e
	note a2  $0e
	note b2  $0e
	goto musiceec2a
	cmdff

musCarnivalChannel4:
	duty $0c
musiceecb1:
	vol $3
	note g4  $0e
	note e4  $1c
	note g4  $0e
	note ds4 $0e
	note b4  $1c
	note a4  $0e
	note g4  $0e
	note e4  $1c
	note c4  $0e
	note b3  $0e
	note ds4 $07
	note fs4 $07
	note b4  $0e
	note a4  $0e
	note g4  $1c
	note a4  $0e
	note b4  $0e
	note c5  $0e
	note d5  $0e
	note e5  $0e
	note f5  $0e
	note g5  $1c
	note f5  $0e
	note cs5 $0e
	note e5  $1c
	note d5  $1c
	note a5  $0e
	note f5  $1c
	note e5  $0e
	note ds5 $0e
	note b5  $07
	note c6  $07
	note b5  $0e
	note a5  $0e
	note g5  $0e
	note e5  $1c
	note g5  $0e
	note cs5 $0e
	note a5  $07
	note as5 $07
	note a5  $0e
	note g5  $0e
	note g5  $0e
	note f5  $0e
	note e5  $0e
	note f5  $0e
	note g5  $0e
	note f5  $0e
	note a5  $0e
	note c6  $0e
	note e6  $0e
	note d6  $0e
	note c6  $0e
	note e6  $0e
	note d6  $1c
	rest $1c
	goto musiceecb1
	cmdff

.define musCarnivalChannel6 MUSIC_CHANNEL_FALLBACK EXPORT

	; Unused data?

	note c1  $6a
	.db $6e ; ???
	note cs1 $33
	.db $6d ; ???
	note e1  $cd
	.db $6f ; ???
	note fs1 $02
	.db $77 ; ???
	cmdff
