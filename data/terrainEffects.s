; @addr{4000}
shadowAnimation:
	.db $01
	.db $13 $04 $20 $08

; @addr{4005}
greenGrassAnimationFrame0:
	.db $02
	.db $11 $01 $24 $08
	.db $11 $07 $24 $08

; @addr{400e}
blueGrassAnimationFrame0:
	.db $02
	.db $11 $01 $24 $09
	.db $11 $07 $24 $09

; @addr{4017}
_puddleAnimationFrame0:
	.db $02
	.db $16 $03 $22 $08
	.db $16 $05 $22 $28

; @addr{4020}
orangeGrassAnimationFrame0:
	.db $02
	.db $11 $01 $24 $0b
	.db $11 $07 $24 $0b

; @addr{4029}
greenGrassAnimationFrame1:
	.db $02
	.db $11 $01 $24 $28
	.db $11 $07 $24 $28

; @addr{4032}
blueGrassAnimationFrame1:
	.db $02
	.db $11 $01 $24 $29
	.db $11 $07 $24 $29

; @addr{403b}
_puddleAnimationFrame1:
	.db $02
	.db $16 $02 $22 $08
	.db $16 $06 $22 $28

; @addr{4044}
orangeGrassAnimationFrame1:
	.db $02
	.db $11 $01 $24 $2b
	.db $11 $07 $24 $2b

; @addr{404d}
_puddleAnimationFrame2:
	.db $02
	.db $17 $01 $22 $08
	.db $17 $07 $22 $28

; @addr{4056}
_puddleAnimationFrame3:
	.db $02
	.db $18 $00 $22 $08
	.db $18 $08 $22 $28

; @addr{405f}
puddleAnimationFrames:
	.dw _puddleAnimationFrame0
	.dw _puddleAnimationFrame1
	.dw _puddleAnimationFrame2
	.dw _puddleAnimationFrame3
