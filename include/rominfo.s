.memorymap
	SLOTSIZE $4000
	DEFAULTSLOT 1
	SLOT 0 $0000
	SLOT 1 $4000

	SLOTSIZE $1000
	SLOT 2 $c000
	SLOT 3 $d000

	SLOTSIZE $4000
	SLOT 4 $a000

.endme

.banksize $4000
.rombanks 512
.ramsize $03 ; 1 RAM bank

.nintendologo
.romgbconly
.licenseecodenew "01"
.cartridgetype $1b
.countrycode 1
.computegbcomplementcheck
.computegbchecksum


; Oracles use almost standard ascii
.ASCIITABLE
	MAP "~" = $5c
.ENDA
