; TODO: substitute these secret values:
;   - In "generateoraskforsecret" opcodes.
;   - In "var3f" loads for interactions which use "linkedGameNpcScript".


; Linked Seasons secrets
.enum 0
	KING_ZORA_SECRET	db ; $00
	FAIRY_SECRET		db ; $01
	TROY_SECRET		db ; $02
	PLEN_SECRET		db ; $03
	LIBRARY_SECRET		db ; $04
	TOKAY_SECRET		db ; $05
	MAMAMU_SECRET		db ; $06
	TINGLE_SECRET		db ; $07
	ELDER_SECRET		db ; $08
	SYMMETRY_SECRET		db ; $09
.ende

; TODO: Identify all linked Ages secrets (also put them in "globalFlags.s" when it's done)
.define DIVER_SECRET $03
.define TEMPLE_SECRET $06
.define DEKU_SECRET $07
