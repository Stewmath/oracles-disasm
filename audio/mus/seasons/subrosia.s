sound28Start:

sound28Channel1:
	vibrato $00
	env $0 $00
	duty $01
musicfaffc:
	vol $0
	note gs3 $24
	vol $6
	note f4  $09
	rest $04
	vol $3
	note f4  $09
	rest $05
	vol $1
	note f4  $09
	rest $24
	vol $6
	note f4  $09
	rest $04
	vol $3
	note f4  $09
	rest $05
	vol $1
	note f4  $09
	rest $24
	vol $6
	note f4  $09
	rest $04
	vol $3
	note f4  $09
	rest $05
	vol $1
	note f4  $09
	vibrato $00
	env $0 $03
	duty $02
	vol $6
	note f5  $12
	note f5  $12
	note fs5 $12
	rest $36
	duty $01
	vibrato $00
	env $0 $00
	note f4  $09
	rest $04
	vol $3
	note f4  $09
	rest $05
	vol $1
	note f4  $09
	rest $24
	vol $6
	note f4  $09
	rest $04
	vol $3
	note f4  $09
	rest $05
	vol $1
	note f4  $09
	rest $24
	vol $6
	note f4  $09
	rest $04
	vol $3
	note f4  $09
	rest $05
	vol $1
	note f4  $09
	vibrato $00
	env $0 $03
	duty $02
	vol $6
	note f5  $12
	note f5  $12
	note fs5 $12
	rest $12
	vibrato $e1
	env $0 $00
	duty $01
	note e4  $36
	note d4  $12
	note c4  $09
	rest $04
	vol $3
	note c4  $09
	rest $05
	vol $1
	note c4  $09
	vol $6
	note b3  $09
	rest $04
	vol $3
	note b3  $09
	rest $05
	vol $1
	note b3  $09
	vol $6
	note as3 $48
	note a3  $09
	rest $04
	vol $3
	note a3  $09
	rest $05
	vol $1
	note a3  $09
	rest $24
	vol $6
	note gs3 $48
	note g3  $09
	rest $04
	vol $3
	note g3  $09
	rest $05
	vol $1
	note g3  $09
	rest $24
	vol $6
	note f3  $09
	rest $04
	vol $3
	note f3  $09
	rest $05
	vol $1
	note f3  $09
	vol $6
	note f3  $09
	note fs3 $09
	note f3  $09
	note fs3 $09
	rest $04
	vol $3
	note fs3 $09
	rest $05
	vol $6
	note f4  $09
	note fs4 $09
	note f4  $09
	note fs4 $09
	rest $04
	vol $3
	note fs4 $09
	rest $05
	vol $6
	note g4  $12
	note a4  $09
	note g4  $09
	note f4  $24
	note fs4 $09
	rest $04
	vol $3
	note fs4 $09
	rest $05
	vol $1
	note fs4 $09
	rest $24
	goto musicfaffc
	cmdff

sound28Channel0:
	vibrato $00
	env $0 $00
	duty $01
musicfb10b:
	vol $0
	note gs3 $24
	vol $6
	note d4  $09
	rest $04
	vol $3
	note d4  $09
	rest $05
	vol $1
	note d4  $09
	rest $24
	vol $6
	note d4  $09
	rest $04
	vol $3
	note d4  $09
	rest $05
	vol $1
	note d4  $09
	rest $24
	vol $6
	note d4  $09
	rest $04
	vol $3
	note d4  $09
	rest $05
	vol $1
	note d4  $09
	env $0 $03
	duty $02
	vol $6
	note d5  $12
	note d5  $12
	note ds5 $12
	rest $36
	vibrato $00
	env $0 $00
	duty $01
	note d4  $09
	rest $04
	vol $3
	note d4  $09
	rest $05
	vol $1
	note d4  $09
	rest $24
	vol $6
	note d4  $09
	rest $04
	vol $3
	note d4  $09
	rest $05
	vol $1
	note d4  $09
	rest $24
	vol $6
	note d4  $09
	rest $04
	vol $3
	note d4  $09
	rest $05
	vol $1
	note d4  $09
	vibrato $00
	env $0 $03
	duty $02
	vol $6
	note d5  $12
	note d5  $12
	note ds5 $12
	rest $ff
	rest $ff
	rest $e4
	vibrato $00
	env $0 $00
	duty $01
	goto musicfb10b
	cmdff

sound28Channel4:
musicfb193:
	duty $0e
	note b2  $24
	note f3  $12
	note fs3 $12
	note a3  $24
	note gs3 $12
	note g3  $12
	note f3  $24
	note fs3 $09
	duty $0f
	note fs3 $09
	rest $5a
	duty $0e
	note b2  $24
	note f3  $12
	note fs3 $12
	note a3  $09
	duty $0f
	note a3  $09
	duty $0e
	note a3  $12
	note gs3 $12
	note g3  $12
	note f3  $24
	note fs3 $09
	duty $0f
	note fs3 $09
	rest $5a
	duty $0e
	note g3  $36
	note fs3 $12
	note e3  $09
	duty $0f
	note e3  $09
	rest $12
	duty $0e
	note d3  $09
	duty $0f
	note d3  $09
	rest $12
	duty $0e
	note c3  $48
	note b2  $12
	rest $36
	note as2 $48
	note a2  $12
	rest $36
	note gs2 $48
	note fs2 $36
	duty $0f
	note fs2 $12
	duty $0e
	note c3  $31
	note b2  $05
	note as2 $04
	note a2  $05
	note gs2 $04
	note g2  $05
	note fs2 $09
	duty $0f
	note fs2 $09
	rest $12
	duty $0e
	note f2  $03
	note fs2 $09
	duty $0f
	note fs2 $09
	rest $0f
	duty $0e
	goto musicfb193
	cmdff

.define sound28Channel6 MUSIC_CHANNEL_FALLBACK EXPORT
