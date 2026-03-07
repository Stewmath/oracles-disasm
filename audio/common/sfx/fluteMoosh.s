sndFluteMooshStart:

sndFluteMooshChannel3:
	vol $0
	rest $e5
	cmdff

sndFluteMooshChannel2:
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

sndFluteMooshChannel5:
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

sndFluteMooshChannel7:
	cmdf0 $00
	note $00 $e5
	cmdff
