.SECTION CompassChimes SUPERFREE

.ifdef ROM_SEASONS

sndd5Start:
sndd5Channel2: ; D1 Chime
	duty 2

	vol 9
	note b4 $05
	vol 3
	note b4 $01

	vol 9
	note as4 $05
	vol 3
	note as4 $01

	vol 9
	note gs4 $05
	vol 3
	note gs4 $01

	vol 9
	note fs4 $05
	vol 3
	note fs4 $01

	vol 9
	note f4  $05
	vol 3
	note f4  $01

	rest 16

	vol 9
	note a4  $05
	vol 3
	note a4  $01

	vol 9
	note gs4 $05
	vol 3
	note gs4 $01

	vol 9
	note fs4 $05
	vol 3
	note fs4 $01

	vol 9
	note f4  $05
	vol 3
	note f4  $01

	vol 9
	note ds4 $05
	vol 3
	note ds4 $01
	cmdff

sndd6Start:
sndd6Channel2: ; D2 Chime
	duty 2
  
	vol 9
	note d4 $06
	vol 3
	note d4 $06
  
	vol 9
	note ds4 $06
	vol 3
	note ds4 $06
  
	vol 9
	note a4 $06
	vol 3
	note a4 $06
  
	vol 9
	note d5 $06
	vol 3
	note d5 $06

	rest $0c

	vol 9
	note c5 $06
	vol 3
	note c5 $06
	cmdff

sndd7Start:
sndd7Channel2: ; D3 Chime
	duty 2

	vol 9
	note e4 $06
	vol 3
	note e4 $06

	vol 9
	note b4 $06
	vol 3
	note b4 $06

	vol 9
	note e4 $06
	vol 3
	note e4 $06

	vol 9
	note ds4 $06
	vol 3
	note ds4 $06

	vol 9
	note as4 $06
	vol 3
	note as4 $06

	rest $0c

	vol 9
	note f5 $06
	vol 3
	note f5 $06

	vol 9
	note d5 $06
	vol 3
	note d5 $06
	cmdff


sndd8Start:
sndd8Channel2: ; D4 Chime
	duty 2

	vol 9
	note a3 $06
	vol 3
	note a3 $06

	vol 9
	note a3 $05
	vol 3
	note a3 $01

	vol 9
	note c4 $05
	vol 3
	note c4 $01

	vol 9
	note a3 $05
	vol 3
	note a3 $01

	vol 9
	note c4 $05
	vol 3
	note c4 $01

	vol 9
	note g4 $05
	vol 3
	note g4 $01

	vol 9
	note fs4 $06
	vol 3
	note fs4 $06
	cmdff


sndd9Start:
sndd9Channel2: ; D5 Chime
	duty 2
	vol 9
	note fs3 $06
	vol 3
	note fs3 $06

	vol 9
	note fs3 $05
	vol 3
	note fs3 $01

	vol 9
	note fs3 $05
	vol 3
	note fs3 $01

	vol 9
	note cs4 $06
	vol 3
	note cs4 $06
	rest $0c

	vol 9
	note c4 $06
	vol 3
	note c4 $06

	vol 9
	note a3 $05
	vol 3
	note a3 $01

	vol 9
	note fs3 $05
	vol 3
	note fs3 $01

	vol 9
	note e4 $06
	vol 3
	note e4 $06
	cmdff


snddaStart:
snddaChannel2: ; D6 Chime
	duty 2

	vol 9
	note fs4 $06
	vol 3
	note fs4 $06

	vol 9
	note cs5 $06
	vol 3
	note cs5 $06

	vol 9
	note c5 $06
	vol 3
	note c5 $06

	rest $0c

	vol 9
	note gs4 $05
	vol 3
	note gs4 $01

	vol 9
	note a4 $05
	vol 3
	note a4 $01

	vol 9
	note b4 $05
	vol 3
	note b4 $01

	vol 9
	note a4 $05
	vol 3
	note a4 $01

	vol 9
	note gs4 $06
	vol 3
	note gs4 $06
	cmdff


snddbStart:
snddbChannel2: ; D7 Chime
	duty 2

	vol 9
	note d4 $06
	vol 3
	note d4 $06

	vol 9
	note f4 $06
	vol 3
	note f4 $06

	vol 9
	note e4 $06
	vol 3
	note e4 $06

	vol 9
	note ds4 $06
	vol 3
	note ds4 $06

	rest $0c

	vol 9
	note d4 $06
	vol 3
	note d4 $06
	cmdff


snddcStart:
snddcChannel2: ; D8 Chime
	duty 2

	vol 9
	note c4 $06
	vol 3
	note c4 $06

	vol 9
	note cs4 $06
	vol 3
	note cs4 $06

	vol 9
	note c4 $06
	vol 3
	note c4 $06

	vol 9
	note cs4 $06
	vol 3
	note cs4 $06

	vol 9
	note c4 $05
	vol 3
	note c4 $01
	vol 9
	note c4 $05
	vol 3
	note c4 $01

	vol 9
	note c4 $05
	vol 3
	note c4 $01
	rest $06

	vol 9
	note c4 $06
	vol 3
	note c4 $06
	cmdff


.else; ROM_AGES

; RANDO-TODO

.endif


.ENDS
