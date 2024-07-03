; Defines tiles which have different "sword clink" behaviour.
;
; 2 lists per entry, each ending with $00:
; - The first is a list of tiles which produce an alternate "clinking" sound indicating they're
; bombable.
; - The second is a list of tiles which don't produce clinks at all.

clinkSoundTable:
	.dw @overworld
	.dw @indoors
	.dw @dungeons
	.dw @sidescrolling
	.dw @underwater
	.dw @five

@overworld:
@underwater:
	.db $c1 $c2 $c4 $d1 $cf
	.db $00

	.db $fd $fe $ff
	.db $00
	.db $00

@indoors:
@dungeons:
@five:
	.db $1f $30 $31 $32 $33 $38 $39 $3a $3b $68 $69
	.db $00

	.db $0a $0b
	.db $00

@sidescrolling:
	.db $12
	.db $00

	.db $00
