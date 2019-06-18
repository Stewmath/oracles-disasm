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
