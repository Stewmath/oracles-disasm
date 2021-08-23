sndSwordObtainedStart:

sndSwordObtainedChannel2:
	cmdf0 $00
	vol $0
	.db $00 $00 $09
	vol $6
	env $0 $07
	.db $07 $c0 $55
	cmdff

sndSwordObtainedChannel7:
	cmdf0 $80
	note $27 $01
	note $37 $01
	note $46 $01
	note $56 $01
	note $66 $01
	note $56 $01
	note $46 $01
	note $37 $01
	note $27 $01
	cmdff

.ifdef ROM_SEASONS
.ifdef BUILD_VANILLA
	.db $ff
.endif
.endif
