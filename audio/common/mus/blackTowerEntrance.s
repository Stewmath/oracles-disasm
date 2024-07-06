musBlackTowerEntranceStart:

musBlackTowerEntranceChannel1:
	vibrato $00
	env $0 $00
	duty $01
musicf6412:
	vol $6
	note b3  $2c
	note cs4 $42
	vol $3
	note cs4 $16
	vol $6
	note cs4 $2c
	note ds4 $42
	vol $3
	note ds4 $16
	vol $6
	note ds4 $2c
	note e4  $2c
	note g4  $2c
	note as4 $2c
	note cs5 $2c
	note e5  $2c
	note g5  $2c
	vol $6
	note as5 $03
	rest $03
	note d6  $05
	vol $4
	note as5 $03
	vol $6
	note as5 $03
	vol $4
	note d6  $05
	rest $03
	note as5 $03
	vol $6
	note as5 $05
	rest $07
	vol $4
	note as5 $04
	vol $6
	note as5 $03
	rest $03
	note d6  $05
	vol $4
	note as5 $03
	vol $6
	note as5 $03
	vol $4
	note d6  $05
	rest $03
	note as5 $03
	vol $6
	note as5 $05
	rest $07
	vol $4
	note as5 $04
	vol $6
	note as5 $03
	rest $03
	note d6  $05
	vol $4
	note as5 $03
	vol $6
	note as5 $03
	vol $4
	note d6  $05
	rest $03
	note as5 $03
	vol $6
	note as5 $05
	rest $07
	vol $4
	note as5 $04
	vol $6
	note as5 $03
	rest $03
	note d6  $05
	vol $4
	note as5 $03
	vol $6
	note as5 $03
	vol $4
	note d6  $05
	rest $03
	note as5 $03
	vol $6
	note as5 $05
	rest $07
	vol $4
	note as5 $04
	vol $6
	note d6  $0b
	note f6  $0b
	note gs6 $0b
	note c7  $0b
	rest $58
	vol $6
	note cs4 $2c
	note ds4 $42
	vol $3
	note ds4 $16
	vol $6
	note ds4 $2c
	note f4  $42
	vol $3
	note f4  $16
	vol $6
	note f4  $2c
	vol $6
	note fs4 $2c
	note a4  $2c
	note c5  $2c
	note ds5 $2c
	note fs5 $2c
	note a5  $2c
	note c6  $03
	rest $03
	note e6  $05
	vol $4
	note c6  $03
	vol $6
	note c6  $03
	vol $4
	note e6  $05
	rest $03
	note c6  $03
	vol $6
	note c6  $05
	rest $07
	vol $4
	note c6  $04
	vol $6
	note c6  $03
	rest $03
	note e6  $05
	vol $4
	note c6  $03
	vol $6
	note c6  $03
	vol $4
	note e6  $05
	rest $03
	note c6  $03
	vol $6
	note c6  $05
	rest $07
	vol $4
	note c6  $04
	vol $6
	note c6  $03
	rest $03
	note e6  $05
	vol $4
	note c6  $03
	vol $6
	note c6  $03
	vol $4
	note e6  $05
	rest $03
	note c6  $03
	vol $6
	note c6  $05
	rest $07
	vol $4
	note c6  $04
	vol $6
	note c6  $03
	rest $03
	note e6  $05
	vol $3
	note c6  $03
	vol $6
	note c6  $03
	vol $3
	note e6  $05
	rest $03
	note c6  $03
	vol $6
	note c6  $05
	rest $07
	vol $3
	note c6  $04
	vol $6
	note e6  $0b
	note g6  $0b
	note as6 $0b
	note c7  $0b
	rest $58
	goto musicf6412
	cmdff

musBlackTowerEntranceChannel0:
	vibrato $00
	env $0 $00
	duty $01
musicf6550:
	vol $7
	note fs3 $2c
	note gs3 $4d
	vol $3
	note gs3 $0b
	vol $7
	note gs3 $2c
	note as3 $4d
	vol $3
	note as3 $0b
	vol $7
	note as3 $2c
	note b3  $2c
	note d4  $2c
	note f4  $2c
	note gs4 $2c
	note b4  $2c
	note d5  $2c
	note e5  $b0
	rest $10
	vol $3
	note d6  $0b
	note f6  $0b
	note gs6 $0b
	note c7  $0b
	rest $48
	vol $6
	note gs3 $2c
	note as3 $4d
	vol $3
	note as3 $0b
	vol $6
	note as3 $2c
	note c4  $4d
	vol $3
	note c4  $0b
	vol $6
	note c4  $2c
	note cs4 $2c
	note e4  $2c
	note g4  $2c
	note as4 $2c
	note cs5 $2c
	note e5  $2c
	note fs5 $b0
	rest $10
	vol $3
	note e6  $0b
	note g6  $0b
	note as6 $0b
	note c7  $0b
	rest $48
	goto musicf6550
	cmdff

musBlackTowerEntranceChannel4:
musicf65b0:
	duty $0e
	note g2  $2c
	note a2  $42
	rest $16
	note a2  $2c
	note b2  $42
	rest $16
	note b2  $2c
	note c3  $2c
	note e3  $2c
	note g3  $2c
	note as3 $2c
	note cs4 $2c
	note e4  $2c
	note g4  $b0
	rest $84
	note a2  $2c
	note b2  $42
	rest $16
	note b2  $2c
	note cs3 $42
	rest $16
	note cs3 $2c
	note d3  $2c
	note fs3 $2c
	note a3  $2c
	note c4  $2c
	note ds4 $2c
	note fs4 $2c
	note a4  $b0
	rest $84
	goto musicf65b0
	cmdff

.define musBlackTowerEntranceChannel6 MUSIC_CHANNEL_FALLBACK EXPORT
