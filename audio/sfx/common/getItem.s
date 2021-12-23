sndGetItemStart:

sndGetItemChannel2:
	duty $01
	vol $b
	note c5  $0a
	note cs5 $0a
	note d5  $0a
	note ds5 $32
	cmdff

sndGetItemChannel3:
	duty $01
	vol $9
	note a5  $0a
	note as5 $0a
	note b5  $0a
	note c6  $32
	cmdff

sndGetItemChannel5:
	duty $01
	note f4  $0a
	note fs4 $0a
	note g4  $0a
	note gs4 $32
	cmdff

sndGetItemChannel7:
	cmdf0 $00
	note $00 $50
	cmdff
