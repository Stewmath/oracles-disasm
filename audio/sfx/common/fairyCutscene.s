sndFairyCutsceneStart:

sndFairyCutsceneChannel2:
	cmdf0 $d1
	.db $07 $d1 $04
	vol $1
	.db $07 $e1 $02
	vol $1
	.db $07 $d9 $02
	vol $3
	.db $07 $ce $04
	vol $1
	.db $07 $de $02
	vol $1
	.db $07 $d7 $02
	vol $5
	.db $07 $cc $04
	vol $2
	.db $07 $dc $02
	vol $1
	.db $07 $d5 $02
	vol $7
	.db $07 $ca $04
	vol $2
	.db $07 $da $02
	vol $2
	.db $07 $d3 $02
	vol $9
	.db $07 $c8 $04
	vol $3
	.db $07 $d8 $02
	vol $2
	.db $07 $d1 $02
	.db $07 $c6 $03
	vol $a
	.db $07 $c2 $04
	vol $3
	.db $07 $d2 $02
	vol $3
	.db $07 $cd $02
	vol $9
	.db $07 $c0 $04
	vol $4
	.db $07 $d0 $02
	vol $3
	.db $07 $cb $02
	vol $7
	.db $07 $be $04
	vol $3
	.db $07 $de $02
	vol $3
	.db $07 $c9 $02
	vol $5
	.db $07 $bc $04
	vol $3
	.db $07 $cc $02
	vol $2
	.db $07 $c7 $02
	vol $3
	.db $07 $b9 $04
	vol $2
	.db $07 $c9 $02
	vol $1
	.db $07 $c4 $02
	vol $2
	.db $07 $b6 $04
	vol $1
	.db $07 $c6 $02
	vol $1
	.db $07 $c1 $02
	vol $2
	.db $07 $af $04
	vol $1
	.db $07 $c1 $02
	vol $1
	.db $07 $bc $02
	vol $1
	.db $07 $ab $04
	env $0 $01
	vol $1
	.db $07 $bf $02
	cmdff

.ifdef ROM_SEASONS
.ifdef BUILD_VANILLA
	.db $ff
.endif
.endif
