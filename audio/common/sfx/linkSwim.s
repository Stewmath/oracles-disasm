sndLinkSwimStart:

sndLinkSwimChannel2:
	duty $02
	env $2 $00
	vol $9
	pitchSlide $16
	note fs3 $0f
	pitchSlide $00
	rest $02
	env $1 $00
	vol $1
	pitchSlide $0f
	note gs3 $0a
	env $0 $00
	vol $4
	pitchSlide $16
	note b3  $05
	cmdff

.ifdef ROM_SEASONS
.ifdef BUILD_VANILLA
	.db $ff
.endif
.endif
