musSyrupStart:

musSyrupChannel1:
musicf8251:
	vibrato $00
	env $0 $05
.ifdef ROM_SEASONS
	cmdf2
.endif
	duty $00
	vol $8
	note g6  $1e
	note d6  $0a
	note b5  $14
	note g5  $14
	note gs5 $28
	note ds6 $0a
	note c6  $0a
	note gs5 $0a
	note ds5 $0a
	note d5  $14
	note d6  $0a
	note b5  $0a
	note g5  $14
	note d5  $14
	note f5  $14
	note ds5 $0a
	note f5  $0a
	note d5  $28
	vol $3
	vibrato $00
	env $0 $03
	note cs5 $05
	rest $0f
	note d5  $05
	rest $0f
	note ds6 $05
	rest $0f
	note d6  $05
	rest $0f
	note cs6 $05
	rest $0f
	note d6  $05
	rest $0f
	note c6  $05
	rest $0f
	note cs6 $05
	rest $0f
	note b5  $05
	rest $0f
	note c6  $05
	rest $0f
	note as5 $05
	rest $0f
	note b5  $05
	rest $0f
	note a5  $05
	rest $05
	note as5 $05
	rest $05
	note gs5 $05
	rest $05
	note a5  $05
	rest $55
	vol $3
	note as7 $01
	note as5 $01
	cmdf8 $81
	note cs5 $03
	cmdf8 $00
	vol $0
	rest $05
	vol $3
	note as7 $01
	note as5 $01
	cmdf8 $81
	note cs5 $03
	cmdf8 $00
	vol $0
	rest $05
	goto musicf8251
	cmdff

musSyrupChannel0:
musicf82e1:
	vibrato $00
	env $0 $02
.ifdef ROM_SEASONS
	cmdf2
.endif
	duty $02
	vol $6
	note g3  $0a
	vol $3
	note g3  $0a
	vol $6
	note cs4 $0a
	vol $3
	note cs4 $0a
	vol $6
	note as4 $0a
	vol $3
	note as4 $0a
	vol $6
	note cs4 $0a
	vol $3
	note cs4 $0a
	vol $6
	note d3  $0a
	vol $3
	note d3  $0a
	vol $6
	note c4  $0a
	vol $3
	note c4  $0a
	vol $6
	note a4  $0a
	vol $3
	note a4  $0a
	vol $6
	note c4  $0a
	vol $3
	note c4  $0a
	vol $6
	note g3  $0a
	vol $3
	note g3  $0a
	vol $6
	note cs4 $0a
	vol $3
	note cs4 $0a
	vol $6
	note as4 $0a
	vol $3
	note as4 $0a
	vol $6
	note cs4 $0a
	vol $3
	note cs4 $0a
	vol $6
	note d3  $0a
	vol $3
	note d3  $0a
	vol $6
	note c4  $0a
	vol $3
	note c4  $0a
	vol $6
	note a4  $0a
	vol $3
	note a4  $0a
	vol $6
	note c4  $0a
	vol $3
	note c4  $0a
	vol $3
	rest $28
	note d6  $05
	rest $0f
	note cs6 $05
	rest $0f
	env $0 $03
	note c6  $05
	rest $0f
	note cs6 $05
	rest $0f
	note b5  $05
	rest $0f
	note c6  $05
	rest $0f
	note as5 $05
	rest $0f
	note b5  $05
	rest $0f
	note a5  $05
	rest $0f
	note as5 $05
	rest $0f
	note gs5 $05
	rest $0f
	note g5  $05
	rest $73
	goto musicf82e1
	cmdff

musSyrupChannel4:
.ifdef ROM_SEASONS
	cmdf2
.endif
musicf8380:
	duty $17
	rest $28
	note fs4 $05
	rest $05
	duty $0c
	note fs4 $03
	rest $07
	duty $17
	duty $0f
	note g7  $09
	rest $01
	note g7  $0a
	duty $17
	rest $28
	note f4  $05
	rest $05
	duty $0c
	note f4  $03
	rest $07
	duty $0f
	note g7  $09
	rest $01
	note g7  $0a
	duty $17
	rest $28
	note fs4 $05
	rest $05
	duty $0c
	note fs4 $03
	rest $07
	duty $0f
	note g7  $09
	rest $01
	note g7  $0a
	duty $17
	rest $28
	note f4  $05
	rest $05
	duty $0c
	note f4  $03
	rest $07
	duty $0f
	note g7  $09
	rest $01
	note g7  $0a
	rest $fa
	rest $82
	goto musicf8380
	cmdff

.define musSyrupChannel6 MUSIC_CHANNEL_FALLBACK EXPORT
