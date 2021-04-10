sound9fStart:

sound9fChannel3:
	vol $0
	rest $e5
	cmdff

sound9fChannel2:
	vol $0
	rest $0d
	duty $02
	vol $2
	note ds6 $12
	note as5 $12
	note as6 $1b
	rest $09
	note g6  $12
	note ds6 $12
	note c7  $1b
	rest $09
	note as6 $48
	cmdff

sound9fChannel5:
	duty $16
	note ds6 $12
	note as5 $12
	note as6 $1b
	rest $09
	note g6  $12
	note ds6 $12
	note c7  $1b
	rest $09
	note as6 $48
	rest $0d
	cmdff

sound9fChannel7:
	cmdf0 $00
	note $00 $e5
	cmdff
