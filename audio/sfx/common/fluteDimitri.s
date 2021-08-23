sndFluteDimitriStart:

sndFluteDimitriChannel3:
	vol $0
	rest $f1
	cmdff

sndFluteDimitriChannel2:
	vol $0
	rest $1f
	duty $02
	vol $2
	note d5  $05
	note g5  $04
	note a5  $05
	note c6  $46
	rest $0e
	note b5  $05
	note c6  $04
	note b5  $05
	note g5  $0e
	note a5  $54
	cmdff

sndFluteDimitriChannel5:
	duty $16
	note d5  $04
	note g5  $05
	note a5  $05
	note c6  $46
	rest $0e
	note b5  $04
	note c6  $05
	note b5  $05
	note g5  $0e
	note a5  $54
	rest $1f
	cmdff

sndFluteDimitriChannel7:
	cmdf0 $00
	note $00 $f1
	cmdff
