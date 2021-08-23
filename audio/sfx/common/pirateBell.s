sndPirateBellStart:

sndPirateBellChannel2:
	duty $00
	vol $c
	cmdf8 $20
	note a4  $01
	cmdf8 $00
	vol $7
	note c5  $01
	note ds5 $01
	vol $6
	note cs5 $01
	note e5  $01
	vol $5
	note cs5 $01
	note e5  $01
	vol $4
	note cs5 $01
	note e5  $01
	vol $3
	note d5  $01
	note f5  $01
	vol $2
	note d5  $01
	note f5  $01
	vol $1
	note ds5 $01
	note fs5 $01
	cmdff

sndPirateBellChannel7:
	cmdf0 $f0
	note $34 $01
	cmdf0 $e0
	note $34 $01
	cmdf0 $b5
	note $24 $01
	note $24 $02
	note $24 $02
	note $17 $02
	note $17 $03
	note $16 $28
	cmdff
