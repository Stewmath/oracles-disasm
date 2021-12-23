musHoronVillageStart:

musHoronVillageChannel1:
	vibrato $00
	env $0 $03
	duty $02
musicec007:
	vol $6
	note ds5 $20
	note fs5 $20
	note cs5 $20
	note ds5 $10
	note e5  $10
	note ds5 $20
	note fs5 $20
	note cs5 $20
	note b4  $10
	note cs5 $10
	note ds5 $20
	note fs5 $20
	note cs6 $10
	note b5  $10
	note fs5 $10
	note ds5 $10
	note fs5 $20
	note e5  $10
	note ds5 $10
	note cs5 $20
	note e5  $10
	note fs5 $10
	note gs5 $20
	note ds6 $20
	note cs6 $20
	note as5 $10
	note gs5 $10
	note fs5 $20
	note cs6 $20
	note b5  $18
	rest $08
	note b5  $10
	note as5 $10
	vibrato $00
	env $0 $00
	note gs5 $04
	rest $04
	vol $3
	note gs5 $04
	rest $04
	vol $6
	note cs5 $04
	rest $04
	vol $3
	note cs5 $04
	rest $04
	vol $6
	note cs6 $04
	rest $04
	vol $3
	note cs6 $04
	rest $04
	vol $6
	note cs5 $04
	rest $04
	vol $3
	note cs5 $04
	rest $04
	vol $6
	note gs5 $04
	rest $04
	vol $3
	note gs5 $04
	rest $04
	vol $6
	note cs5 $04
	rest $04
	vol $3
	note cs5 $04
	rest $04
	vol $6
	note cs6 $04
	rest $04
	vol $3
	note cs6 $04
	rest $04
	vol $6
	note cs5 $04
	rest $04
	vol $3
	note cs5 $04
	rest $04
	vol $6
	note fs5 $08
	note gs5 $08
	note fs5 $08
	note gs5 $08
	note fs5 $08
	rest $04
	vol $3
	note fs5 $08
	rest $04
	vol $6
	note as5 $04
	note cs6 $04
	note fs6 $04
	rest $04
	vol $3
	note as5 $04
	note cs6 $04
	note fs6 $04
	rest $04
	vol $1
	note as5 $04
	note cs6 $04
	note fs6 $04
	rest $1c
	vibrato $00
	env $0 $03
	goto musicec007
	cmdff

musHoronVillageChannel0:
	vibrato $00
	env $0 $03
	duty $02
musicec0d8:
	vol $6
	note b3  $10
	note fs4 $10
	note b3  $10
	note fs4 $10
	note as3 $10
	note fs4 $10
	note fs3 $10
	note fs4 $10
	note b3  $10
	note fs4 $10
	note b3  $10
	note fs4 $10
	note as3 $10
	note fs3 $10
	note gs3 $10
	note as3 $10
	note b3  $10
	note fs4 $10
	note b3  $10
	note as3 $10
	note gs3 $10
	note ds4 $10
	note gs3 $10
	note ds4 $10
	note cs4 $10
	note gs4 $10
	note cs4 $10
	note gs4 $10
	note fs3 $10
	note gs3 $10
	note as3 $10
	note b3  $10
	note cs4 $10
	note e4  $10
	note cs4 $10
	note b3  $10
	note as3 $10
	note cs4 $10
	note fs3 $10
	note cs4 $10
	note ds3 $10
	note e3  $10
	note fs3 $10
	note as3 $10
	note gs3 $10
	note as3 $10
	note b3  $10
	note ds4 $10
	note e4  $20
	note ds4 $20
	note cs4 $20
	note b3  $20
	note as3 $10
	note fs4 $10
	note b3  $10
	note fs4 $10
	note c4  $10
	note fs4 $10
	note cs4 $10
	note fs4 $10
	goto musicec0d8
	cmdff

musHoronVillageChannel4:
	duty $0c
musicec157:
	note ds5 $0e
	note ds5 $20
	note fs5 $20
	note cs5 $20
	note ds5 $10
	note e5  $10
	note ds5 $20
	note fs5 $20
	note cs5 $20
	note b4  $10
	note cs5 $10
	note ds5 $20
	note fs5 $20
	note cs6 $10
	note b5  $10
	note fs5 $10
	note ds5 $10
	note fs5 $20
	note e5  $10
	note ds5 $10
	note cs5 $20
	note e5  $10
	note fs5 $10
	note gs5 $20
	note ds6 $20
	note cs6 $20
	note as5 $10
	note gs5 $10
	note fs5 $20
	note cs6 $20
	note b5  $18
	rest $08
	note b5  $10
	note as5 $10
	note gs5 $10
	note cs5 $10
	note cs6 $10
	note cs5 $10
	note gs5 $10
	note cs5 $10
	note cs6 $10
	note cs5 $10
	note fs5 $08
	note gs5 $08
	note fs5 $08
	note gs5 $08
	note fs5 $10
	rest $08
	note as5 $04
	note cs6 $04
	note fs6 $04
	rest $2e
	goto musicec157
	cmdff

.define musHoronVillageChannel6 MUSIC_CHANNEL_FALLBACK EXPORT
