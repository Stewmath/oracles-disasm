sound2fStart:

sound2fChannel1:
	vibrato $00
	env $0 $00
.ifdef ROM_SEASONS
	cmdf2
.endif
	duty $02
musicf8204:
	vol $c
	note c2  $04
	vol $5
	note c2  $08
	vol $2
	note c2  $04
	vol $c
	note fs2 $04
	vol $5
	note fs2 $08
	vol $2
	note fs2 $04
	vol $c
	note f2  $04
	vol $5
	note f2  $08
	vol $2
	note f2  $04
	rest $48
	vol $c
	note c2  $02
	vol $5
	note c2  $04
	vol $2
	note c2  $02
	vol $c
	note c2  $04
	vol $5
	note c2  $08
	vol $2
	note c2  $04
	vol $c
	note fs2 $04
	vol $5
	note fs2 $08
	vol $2
	note fs2 $04
	vol $c
	note f2  $04
	vol $5
	note f2  $04
	vol $c
	note b2  $04
	vol $5
	note b2  $08
	vol $2
	note b2  $04
	rest $f8
	goto musicf8204
	cmdff

.ifdef ROM_SEASONS
.ifdef BUILD_VANILLA
	.db $ff $ff $ff
.endif
.endif

.define sound2fChannel0 MUSIC_CHANNEL_FALLBACK EXPORT
.define sound2fChannel4 MUSIC_CHANNEL_FALLBACK EXPORT
.define sound2fChannel6 MUSIC_CHANNEL_FALLBACK EXPORT
