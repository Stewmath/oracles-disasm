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
.ramsize $02 ; 1 RAM bank

; HACK-BASE: Ages is expanded to 2MB, Seasons to 4MB to accommodate expanded tilesets.
; Seasons takes more space due to the extra deduplication from each of the season tilesets.
.ifdef ROM_AGES

.rombanks 128
.romsize $06

.else ; Seasons

.rombanks 256
.romsize $07

.endif

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
