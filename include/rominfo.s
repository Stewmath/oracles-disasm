.memorymap
	SLOTSIZE $4000
	DEFAULTSLOT 1
	SLOT 0 $0000
	SLOT 1 $4000

	SLOTSIZE $1000
	SLOT 2 $c000
	SLOT 3 $d000
.endme

.banksize $4000
.rombanks 64


; In Seasons, the "empty" byte is the bank number, while in ages, it's 0.
.ifdef ROM_AGES
	.emptyfill $00
.else
; My custom mod of wla will see this define and use the bank number as "emptyfill" when it
; exists. If stock WLA is being used, it should still build without issues, but the
; checksum will be incorrect.
;
; WLA mod is located here: https://github.com/Drenn1/wla-dx/tree/emptyfill-banknumber
	.define _WLA_EMPTYFILL_BANKNUMBER
	.export _WLA_EMPTYFILL_BANKNUMBER
.endif

.nintendologo
.romgbconly
.licenseecodenew "01"
.cartridgetype $1b
.ramsize $02
.countrycode 1
.computegbcomplementcheck
.computegbchecksum


; Oracles use almost standard ascii
.ASCIITABLE
	MAP "~" = $5c
.ENDA
