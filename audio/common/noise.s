; This table defines the types of noises the noise channel can make.
;
; Data format:
;   b0: "Note", aka the value passed to the "note" macro, used as a lookup index for this table
;   b1: Controls volume envelope, NR42 register (should always leave upper nybble as $0)
;   b2: Value written directly to NR43 register (determines most characteristics of the sound)

noiseFrequencyTable:
	.db $24 $01 $47
	.db $22 $00 $47
	.db $23 $02 $46
	.db $26 $02 $26
	.db $28 $00 $35
	.db $27 $02 $14
	.db $2a $01 $14
	.db $2e $06 $07
	.db $52 $03 $17
	.db $32 $02 $37
	.db $2f $02 $45
	.db $29 $02 $47
	.db $30 $00 $07
	.db $ff
