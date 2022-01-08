shadowAnimation:
	.db $01
	.db $13 $04 $20 $08

greenGrassAnimationFrame0:
	.db $02
	.db $11 $01 $24 $08
	.db $11 $07 $24 $08

blueGrassAnimationFrame0:
	.db $02
	.db $11 $01 $24 $09
	.db $11 $07 $24 $09

puddleAnimationFrame0:
	.db $02
	.db $16 $03 $22 $08
	.db $16 $05 $22 $28

orangeGrassAnimationFrame0:
	.db $02
	.db $11 $01 $24 $0b
	.db $11 $07 $24 $0b

greenGrassAnimationFrame1:
	.db $02
	.db $11 $01 $24 $28
	.db $11 $07 $24 $28

blueGrassAnimationFrame1:
	.db $02
	.db $11 $01 $24 $29
	.db $11 $07 $24 $29

puddleAnimationFrame1:
	.db $02
	.db $16 $02 $22 $08
	.db $16 $06 $22 $28

orangeGrassAnimationFrame1:
	.db $02
	.db $11 $01 $24 $2b
	.db $11 $07 $24 $2b

puddleAnimationFrame2:
	.db $02
	.db $17 $01 $22 $08
	.db $17 $07 $22 $28

puddleAnimationFrame3:
	.db $02
	.db $18 $00 $22 $08
	.db $18 $08 $22 $28

puddleAnimationFrames:
	.dw puddleAnimationFrame0
	.dw puddleAnimationFrame1
	.dw puddleAnimationFrame2
	.dw puddleAnimationFrame3
