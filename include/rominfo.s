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
.ramsize $02 ; 1 RAM bank
.romsize $05

.nintendologo
.romgbconly
.licenseecodenew "01"
.cartridgetype $1b

.ifdef REGION_JP
	.countrycode 0
.else
	.countrycode 1
.endif

.computegbcomplementcheck
.computegbchecksum


; Oracles use almost standard ascii
.ASCIITABLE
	MAP "~" = $5c
.ENDA
