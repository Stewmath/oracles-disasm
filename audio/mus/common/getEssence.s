musGetEssenceStart:

musGetEssenceChannel1:
	duty $00
	vol $b
	note a5  $06
	vol $1
	note a5  $04
	vol $b
	note as5 $06
	vol $1
	note as5 $03
	vol $b
	note b5  $06
	vol $1
	note b5  $02
	vol $b
	note c6  $06
	vol $1
	note c6  $02
	vol $b
	note cs6 $06
	vol $1
	note cs6 $02
	vol $b
	env $0 $00
	vibrato $e1
	note d6  $52
	cmdff

musGetEssenceChannel0:
	duty $00
	vol $c
	note c5  $06
	vol $1
	note c5  $04
	vol $c
	note cs5 $06
	vol $1
	note cs5 $03
	vol $c
	note d5  $06
	vol $1
	note d5  $02
	vol $c
	note ds5 $06
	vol $1
	note ds5 $02
	vol $c
	note e5  $06
	vol $1
	note e5  $02
	vol $c
	env $0 $00
	vibrato $e1
	note f5  $52
	cmdff

musGetEssenceChannel4:
	duty $0a
	note f3  $06
	rest $04
	note fs3 $06
	rest $03
	note g3  $06
	rest $02
	note gs3 $06
	rest $02
	note a3  $06
	rest $02
	note as3 $4b
	cmdff

musGetEssenceChannel6:
	vol $0
	note $30 $1b
	vol $5
	note $30 $04
	vol $0
	note $30 $04
	vol $3
	note $30 $04
	vol $0
	note $30 $04
	vol $2
	note $30 $52
	cmdff
