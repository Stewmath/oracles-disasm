musNayruStart:
musNayruChannel1:
	vibrato $e1
	env $0 $00
	cmdf2
musicee9ec:
	vol $6
	note d6  $24
	note a5  $24
	vibrato $01
	vol $4
	note a5  $12
	vibrato $e1
	vol $6
	note g5  $12
	note a5  $51
	vibrato $01
	vol $4
	note a5  $12
	rest $09
	vibrato $e1
	vol $6
	note d6  $24
	note a5  $24
	vibrato $01
	vol $4
	note a5  $12
	vibrato $e1
	vol $6
	note g5  $12
	note a5  $36
	vibrato $01
	vol $4
	note a5  $12
	vibrato $e1
	vol $6
	note d5  $24
	note ds5 $24
	note g5  $24
	note as5 $24
	note a5  $3f
	vibrato $01
	vol $4
	note a5  $24
	rest $09
	vibrato $e1
	vol $6
	note a5  $24
	note g5  $24
	note f5  $24
	note g5  $3f
	vibrato $01
	vol $4
	note g5  $1e
	rest $0f
	vibrato $e1
	goto musicee9ec
	cmdff

musNayruChannel0:
musiceea48:
	vibrato $00
	env $0 $05
	vol $0
	note gs3 $12
	vol $6
	note g4  $06
	rest $0c
	note as4 $06
	rest $03
	vol $4
	note g4  $06
	rest $03
	vol $6
	note d5  $06
	rest $03
	vol $4
	note as4 $06
	rest $03
	vol $6
	note g5  $06
	rest $03
	vol $4
	note d5  $06
	rest $0c
	vol $4
	note g5  $06
	rest $15
	vol $6
	note d4  $06
	rest $0c
	note f4  $06
	rest $03
	vol $4
	note d4  $06
	rest $03
	vol $6
	note a4  $06
	rest $03
	vol $4
	note f4  $06
	rest $03
	vol $6
	note d5  $06
	rest $03
	vol $4
	note a4  $06
	rest $0c
	vol $4
	note d5  $06
	rest $15
	vol $6
	note g4  $06
	rest $0c
	note as4 $06
	rest $03
	vol $4
	note g4  $06
	rest $03
	vol $6
	note d5  $06
	rest $03
	vol $4
	note as4 $06
	rest $03
	vol $6
	note g5  $06
	rest $03
	vol $4
	note d5  $06
	rest $0c
	vol $4
	note g5  $06
	rest $15
	vol $6
	note d4  $06
	rest $0c
	note f4  $06
	rest $03
	vol $4
	note d4  $06
	rest $03
	vol $6
	note a4  $06
	rest $03
	vol $4
	note f4  $06
	rest $03
	vol $6
	note d5  $06
	rest $03
	vol $4
	note a4  $06
	rest $0c
	vol $4
	note d5  $06
	rest $03
	vol $6
	note c4  $06
	rest $0c
	note ds4 $06
	rest $03
	vol $4
	note c4  $06
	rest $03
	vol $6
	note g4  $06
	rest $03
	vol $4
	note ds4 $06
	rest $03
	vol $6
	note c5  $06
	rest $03
	vol $4
	note g4  $06
	rest $0c
	vol $4
	note c5  $06
	rest $15
	vol $6
	note d4  $06
	rest $0c
	note f4  $06
	rest $03
	vol $4
	note d4  $06
	rest $03
	vol $6
	note a4  $06
	rest $03
	vol $4
	note f4  $06
	rest $03
	vol $6
	note d5  $06
	rest $03
	vol $4
	note a4  $06
	rest $0c
	vol $4
	note d5  $06
	rest $15
	env $0 $00
	vol $6
	note d5  $24
	note c5  $24
	note c5  $24
	note d5  $3f
	vol $3
	note d5  $1e
	rest $0f
	goto musiceea48
	cmdff

musNayruChannel4:
musiceeb4d:
	duty $0f
	rest $16
	note d6  $24
	note a5  $36
	note g5  $12
	note a5  $51
	rest $1b
	note d6  $24
	note a5  $36
	note g5  $12
	note a5  $48
	note d5  $24
	note ds5 $24
	note g5  $24
	note as5 $24
	note a5  $56
	rest $48
	duty $2c
	note a4  $24
	duty $0f
	note as4 $6c
	goto musiceeb4d
	cmdff

.define musNayruChannel6 MUSIC_CHANNEL_FALLBACK EXPORT
