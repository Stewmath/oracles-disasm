sndSolvePuzzle2Start:

sndSolvePuzzle2Channel2:
	duty $02
	env $0 $02
	vol $d
	note fs6 $10
	vol $b
	note d6  $12
	note g5  $14
	vol $d
	note g6  $18
	cmdff

sndSolvePuzzle2Channel3:
	duty $02
	env $0 $02
	vol $0
	rest $08
	vol $c
	note f6  $10
	vol $b
	note b5  $13
	vol $c
	note ds6 $16
	env $0 $02
	vol $e
	note b6  $23
	cmdff

.ifdef ROM_AGES
.ifdef BUILD_VANILLA
	cmdff
.endif
.endif
