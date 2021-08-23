sndGetSeedStart:

sndGetSeedChannel2:
	duty $01
	vol $d
	note ds7 $04
	vol $0
	rest $01
	vol $d
	note f7  $04
	vol $0
	rest $01
	vol $d
	note g7  $04
	vol $0
	rest $01
	vol $d
	note as7 $04
	vol $0
	rest $02
	vol $6
	note as7 $04
	vol $0
	rest $02
	vol $2
	note as7 $04
	cmdff

.ifdef ROM_SEASONS
.ifdef BUILD_VANILLA
	.db $ff
.endif
.endif
