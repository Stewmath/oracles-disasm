musTempleRemainsStart:

musTempleRemainsChannel1:
	vibrato $00
	env $0 $00
musicedce8:
	vol $6
	note a3  $12
	note d4  $12
	note g4  $12
	note e4  $12
	note a4  $12
	note d4  $12
	note g4  $12
	note fs4 $12
	note e4  $12
	note b4  $12
	note a4  $12
	note d4  $12
	note g4  $12
	note e4  $12
	note fs4 $12
	note g4  $12
	vibrato $00
	env $0 $04
	note a4  $12
	note b4  $12
	note c5  $12
	note g5  $09
	rest $51
	note a4  $12
	note b4  $12
	note c5  $12
	note fs5 $09
	rest $51
	vibrato $00
	env $0 $00
	note b4  $12
	note g4  $12
	note e4  $12
	note a4  $12
	note g4  $12
	note d4  $12
	note e4  $12
	note a4  $12
	note fs4 $12
	note g4  $12
	note d5  $12
	note b4  $12
	note cs5 $12
	note a4  $12
	note g4  $12
	note b4  $12
	vibrato $00
	env $0 $04
	note fs5 $12
	note g5  $12
	note a5  $12
	note b5  $09
	rest $51
	note e5  $12
	note fs5 $12
	note g5  $12
	note a5  $09
	rest $51
	vibrato $00
	env $0 $00
	goto musicedce8
	cmdff

musTempleRemainsChannel0:
	vibrato $00
	env $0 $00
musicedd69:
	vol $1
	note a3  $0b
	vol $4
	note a3  $12
	note d4  $12
	note g4  $12
	note e4  $12
	vol $4
	note a4  $12
	note d4  $12
	note g4  $12
	note fs4 $12
	note e4  $12
	note b4  $12
	note a4  $12
	note d4  $12
	vol $4
	note g4  $12
	note e4  $12
	note fs4 $12
	note g4  $12
	rest $1f
	vibrato $00
	env $0 $04
	vol $4
	note b4  $12
	note c5  $12
	note g5  $09
	rest $51
	note a4  $12
	note b4  $12
	note c5  $12
	note fs5 $09
	rest $44
	vibrato $00
	env $0 $00
	vol $4
	note b4  $12
	note g4  $12
	note e4  $12
	note a4  $12
	note g4  $12
	note d4  $12
	note e4  $12
	note a4  $12
	note fs4 $12
	note g4  $12
	note d5  $12
	note b4  $12
	note cs5 $12
	note a4  $12
	note g4  $12
	note b4  $12
	rest $1f
	vibrato $00
	env $0 $04
	vol $4
	note g5  $12
	note a5  $12
	note b5  $09
	rest $51
	note e5  $12
	note fs5 $12
	note g5  $12
	note a5  $09
	rest $39
	vibrato $00
	env $0 $00
	goto musicedd69
	cmdff

musTempleRemainsChannel4:
musiceddee:
	duty $0e
	note a2  $24
	note e3  $24
	note d3  $36
	duty $0f
	note d3  $12
	duty $0e
	note a2  $12
	note e3  $12
	note g3  $12
	note e3  $12
	note fs3 $24
	note e3  $12
	note d3  $12
	duty $0e
	note a2  $24
	duty $0f
	note a2  $12
	duty $0c
	note a2  $12
	duty $0e
	note a2  $09
	duty $0f
	note a2  $09
	duty $0e
	note a2  $09
	duty $0f
	note a2  $09
	rest $24
	duty $0e
	note a2  $24
	duty $0f
	note a2  $12
	duty $0c
	note a2  $12
	duty $0e
	note a2  $09
	duty $0f
	note a2  $09
	duty $0e
	note a2  $09
	duty $0f
	note a2  $09
	rest $24
	duty $0e
	note a2  $24
	note e3  $24
	note d3  $2d
	duty $0f
	note d3  $1b
	duty $0e
	note a2  $12
	note e3  $12
	note b3  $12
	note a3  $12
	note e4  $12
	note cs4 $12
	note b3  $12
	note g3  $12
	duty $0e
	note a2  $24
	duty $0f
	note a2  $12
	duty $0c
	note a2  $12
	duty $0e
	note a2  $09
	duty $0f
	note a2  $09
	duty $0e
	note a2  $09
	duty $0f
	note a2  $09
	rest $24
	duty $0e
	note a2  $24
	duty $0f
	note a2  $12
	duty $0c
	note a2  $12
	duty $0e
	note a2  $09
	duty $0f
	note a2  $09
	duty $0e
	note a2  $09
	duty $0f
	note a2  $09
	rest $24
	goto musiceddee
	cmdff

.ifdef BUILD_VANILLA
	.dsb 6 $ff
.endif

.define musTempleRemainsChannel6 MUSIC_CHANNEL_FALLBACK EXPORT
