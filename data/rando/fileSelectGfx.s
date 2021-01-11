.SECTION RandoFileSelectGfx ALIGN 16 SUPERFREE

; uncompressed 2bpp format: capital letters, then four punctuation characters.
; The characters are one tile each and roughly match the single-tile digits.
; These need to be loaded in two steps due to DMA transfer limitations?

randoCustomFontLetters:
	.db $00,$ff,$3c,$ff,$66,$ff,$66,$ff,$7e,$ff,$66,$ff,$66,$ff,$00,$ff
	.db $00,$ff,$7c,$ff,$66,$ff,$7c,$ff,$66,$ff,$66,$ff,$7c,$ff,$00,$ff
	.db $00,$ff,$3c,$ff,$66,$ff,$60,$ff,$60,$ff,$66,$ff,$3c,$ff,$00,$ff
	.db $00,$ff,$7c,$ff,$66,$ff,$66,$ff,$66,$ff,$66,$ff,$7c,$ff,$00,$ff
	.db $00,$ff,$7e,$ff,$60,$ff,$7c,$ff,$60,$ff,$60,$ff,$7e,$ff,$00,$ff
	.db $00,$ff,$7e,$ff,$60,$ff,$7c,$ff,$60,$ff,$60,$ff,$60,$ff,$00,$ff
	.db $00,$ff,$3c,$ff,$66,$ff,$60,$ff,$6e,$ff,$66,$ff,$3c,$ff,$00,$ff
	.db $00,$ff,$66,$ff,$66,$ff,$7e,$ff,$66,$ff,$66,$ff,$66,$ff,$00,$ff
	.db $00,$ff,$3c,$ff,$18,$ff,$18,$ff,$18,$ff,$18,$ff,$3c,$ff,$00,$ff
	.db $00,$ff,$06,$ff,$06,$ff,$66,$ff,$66,$ff,$66,$ff,$3c,$ff,$00,$ff
	.db $00,$ff,$66,$ff,$6c,$ff,$78,$ff,$6c,$ff,$66,$ff,$66,$ff,$00,$ff
	.db $00,$ff,$60,$ff,$60,$ff,$60,$ff,$60,$ff,$60,$ff,$7e,$ff,$00,$ff
	.db $00,$ff,$7c,$ff,$7e,$ff,$6a,$ff,$6a,$ff,$6a,$ff,$6a,$ff,$00,$ff
	.db $00,$ff,$62,$ff,$72,$ff,$7a,$ff,$5e,$ff,$4e,$ff,$46,$ff,$00,$ff
	.db $00,$ff,$3c,$ff,$66,$ff,$66,$ff,$66,$ff,$66,$ff,$3c,$ff,$00,$ff
	.db $00,$ff,$7c,$ff,$66,$ff,$66,$ff,$7c,$ff,$60,$ff,$60,$ff,$00,$ff
	.db $00,$ff,$3c,$ff,$66,$ff,$66,$ff,$66,$ff,$3c,$ff,$0e,$ff,$00,$ff
	.db $00,$ff,$7c,$ff,$66,$ff,$66,$ff,$7c,$ff,$66,$ff,$66,$ff,$00,$ff
	.db $00,$ff,$3c,$ff,$66,$ff,$38,$ff,$1c,$ff,$66,$ff,$3c,$ff,$00,$ff
	.db $00,$ff,$7e,$ff,$18,$ff,$18,$ff,$18,$ff,$18,$ff,$18,$ff,$00,$ff
	.db $00,$ff,$66,$ff,$66,$ff,$66,$ff,$66,$ff,$66,$ff,$3c,$ff,$00,$ff
	.db $00,$ff,$66,$ff,$66,$ff,$66,$ff,$6c,$ff,$78,$ff,$70,$ff,$00,$ff
	.db $00,$ff,$6a,$ff,$6a,$ff,$6a,$ff,$6a,$ff,$7e,$ff,$3c,$ff,$00,$ff
	.db $00,$ff,$66,$ff,$7e,$ff,$18,$ff,$3c,$ff,$66,$ff,$66,$ff,$00,$ff
	.db $00,$ff,$66,$ff,$66,$ff,$3c,$ff,$18,$ff,$18,$ff,$18,$ff,$00,$ff
	.db $00,$ff,$7e,$ff,$06,$ff,$1c,$ff,$38,$ff,$60,$ff,$7e,$ff,$00,$ff

randoCustomFontPunct:
	.db $00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff
	.db $00,$ff,$10,$ff,$10,$ff,$7c,$ff,$10,$ff,$10,$ff,$00,$ff,$00,$ff
	.db $00,$ff,$00,$ff,$00,$ff,$7c,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff
	.db $00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$18,$ff,$18,$ff,$00,$ff

randoFileSelectStringAttrs:
	.db $0a,$0a,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$2a,$2a
	.db $0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a ; offscreen
	.db $0a,$0a,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$2a,$2a
	.db $0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a ; offscreen

; This will be modified by the randomizer.
randoFileSelectStringTiles:
	.db $74,$31,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$41,$40
	.db $02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02 ; offscreen
	.db $40,$41,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$51,$50
	.db $02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02 ; offscreen

.ENDS
