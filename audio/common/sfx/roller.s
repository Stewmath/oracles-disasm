sndRollerStart:

sndRollerChannel2:
	duty $00
	vol $0
	rest $05
	vol $f
	note c2  $01
	vol $e
	note cs2 $01
	vol $d
	note c2  $01
	vol $c
	note d2  $01
	vol $b
	note cs2 $01
	vol $a
	note e2  $01
	vol $9
	note c2  $01
	vol $8
	note d2  $01
	vol $7
	note cs2 $01
	vol $6
	note ds2 $01
	vol $5
	note c2  $01
	vol $4
	note ds2 $01
	vol $3
	note cs2 $01
	vol $2
	note ds2 $01
	cmdff

sndRollerChannel7:
	cmdf0 $f1
	note $52 $01
	note $56 $03
	cmdf0 $01
	note $00 $01
	cmdf0 $f1
	note $52 $01
	note $56 $03
	note $64 $04
	note $57 $06
	cmdf0 $43
	note $57 $1e
	cmdff
