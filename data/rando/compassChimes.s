.SECTION CompassChimes SUPERFREE

.ifdef ROM_SEASONS

sndd5Start:
sndd5Channel2: ; Seasons D1 Chime
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
sndd6Channel2: ; Seasons D2 Chime
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
sndd7Channel2: ; Seasons D3 Chime
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
sndd8Channel2: ; Seasons D4 Chime
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
sndd9Channel2: ; Seasons D5 Chime
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
snddaChannel2: ; Seasons D6 Chime
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
snddbChannel2: ; Seasons D7 Chime
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
snddcChannel2: ; Seasons D8 Chime
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

sndd5Start:
sndd5Channel2: ; Ages D1 Chime
	duty $2
	vol 9
	note as4 $06
	vol 3
	note as4 $06
	vol 9
	note f5 $06
	vol 3
	note f5 $06
	rest $0c

	vol 9
	note e5 $06
	vol 3
	note e5 $06
	vol 9
	note f5 $06
	vol 3
	note f5 $06
	rest $0c

	vol 9
	note gs5 $06
	vol 3
	note gs5 $06
	vol 9
	note b6 $06
	vol 3
	note b6 $06
	cmdff

sndd6Start:
sndd6Channel2: ; Ages D2 Chime
	duty $2
	vol 9
	note ds4 $06
	vol 3
	note ds4 $06
	vol 9
	note ds4 $06
	vol 3
	note ds4 $06
	vol 9
	note fs4 $06
	vol 3
	note fs4 $06
	rest $0c
	vol 9
	note ds4 $05
	vol 3
	note ds4 $01
	vol 9
	note ds4 $05
	vol 3
	note ds4 $01
	vol 9
	note ds4 $05
	vol 3
	note ds4 $01
	vol 9
	note ds4 $05
	vol 3
	note ds4 $01
	vol 9
	note fs4 $06
	vol 3
	note fs4 $06
	rest $0c
	cmdff

sndd7Start:
sndd7Channel2: ; Ages D3 Chime
	duty $2
	vol 9
	note c5 $06
	vol 3
	note c5 $06
	rest $06

	vol 9
	note c5 $03
	vol 3
	note c5 $03

	vol 9
	note ds5 $06
	vol 3
	note ds5 $06
	vol 9
	note d5 $06
	vol 3
	note d5 $06
	vol 9
	note cs5 $06
	vol 3
	note cs5 $06
	vol 9
	note c5 $06
	vol 3
	note c5 $06
	cmdff

sndd8Start:
sndd8Channel2: ; Ages D4 Chime
	duty $2
	vol 9
	note d4  $05
	vol 3
	note d4  $01
	vol 9
	note ds4 $05
	vol 3
	note ds4 $01
	vol 9
	note f4  $05
	vol 3
	note f4  $01
	vol 9
	note fs4 $05
	vol 3
	note fs4 $01
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
	vol 9
	note d4  $05
	vol 3
	note d4  $01
	vol 9
	note f4  $05
	vol 3
	note f4  $01
	vol 9
	note gs4 $05
	vol 3
	note gs4 $01
	vol 9
	note b4  $05
	vol 3
	note b4  $01
	vol 9
	note as4 $06
	vol 3
	note as4 $06
	cmdff

sndd9Start:
sndd9Channel2: ; Ages D5 Chime
	duty $2
	vol 9
	note a4 $06
	vol 3
	note a4 $06
	vol 9
	note gs4 $06
	vol 3
	note gs4 $06
	vol 9
	note g4 $06
	vol 3
	note g4 $06
	vol 9
	note cs5 $06
	vol 3
	note cs5 $06
	vol 9
	note c5 $06
	vol 3
	note c5 $06
	vol 9
	note fs4 $06
	vol 3
	note fs4 $06
	cmdff

snddaStart:
snddaChannel2: ; Ages D6 Chime
	duty $02
	vol 9
	note ds4 $06
	vol 3
	note ds4 $06
	vol 9
	note f4 $06
	vol 3
	note f4 $06
	vol 9
	note as4 $06
	vol 3
	note as4 $06
	rest $0c
	vol 9
	note ds4 $06
	vol 3
	note ds4 $06
	vol 9
	note f4 $06
	vol 3
	note f4 $06
	vol 9
	note b4 $06
	vol 3
	note b4 $06
	cmdff

snddbStart:
snddbChannel2: ; Ages D7 Chime
	duty $2
	vol 9
	note e4 $06
	vol 3
	note e4 $06
	vol 9
	note ds4 $06
	vol 3
	note ds4 $06
	vol 9
	note f4 $06
	vol 3
	note f4 $06
	vol 9
	note e4 $06
	vol 3
	note e4 $06
	vol 9
	note d4 $06
	vol 3
	note d4 $06

	rest $06
	vol 9
	note cs4 $03
	note c4 $03

	vol 9
	note as3 $06
	vol 3
	note as3 $06

	vol 9
	note g3 $06
	vol 3
	note g3 $06
	cmdff

snddcStart:
snddcChannel2: ; Ages D8 Chime
	duty $2
	vol 9
	note gs2 $06
	vol 3
	note gs2 $06
	vol 9
	note a2 $06
	vol 3
	note a2 $06
	vol 9
	note gs2 $06
	vol 3
	note gs2 $06
	vol 9
	note e2 $06
	vol 3
	note e2 $06
	vol 9
	note gs2 $06
	vol 3
	note gs2 $06
	vol 9
	note a2 $06
	vol 3
	note a2 $06
	vol 9
	note gs2 $06
	vol 3
	note gs2 $06
	vol 9
	note e2 $06
	vol 3
	note e2 $06
	cmdff

.endif


.ENDS
