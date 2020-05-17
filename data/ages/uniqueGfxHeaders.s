uniqueGfxHeadersStart:

; HACK-BASE: All data removed for expanded tilesets patch.
; TODO: Fix "uniqueGfxHeader14" reference (what does it do?)
uniqueGfxHeader00: ; 4:59d0
uniqueGfxHeader01:
uniqueGfxHeader02: ; 4:59e2
uniqueGfxHeader03: ; 4:59f4
uniqueGfxHeader04: ; 4:5a06
uniqueGfxHeader05: ; 4:5a18
uniqueGfxHeader06: ; 4:5a2a
uniqueGfxHeader07: ; 4:5a3c
uniqueGfxHeader08: ; 4:5a4e
uniqueGfxHeader09: ; 4:5a60
uniqueGfxHeader0a: ; 4:5a72
uniqueGfxHeader0b: ; 4:5a84
uniqueGfxHeader0c: ; 4:5a96
uniqueGfxHeader0d: ; 4:5aa8
uniqueGfxHeader0e: ; 4:5aba
uniqueGfxHeader0f: ; 4:5acc
uniqueGfxHeader10: ; 4:5ade
uniqueGfxHeader11: ; 4:5af0
uniqueGfxHeader12: ; 4:5b02
uniqueGfxHeader13: ; 4:5b14
uniqueGfxHeader14: ; This actually references a palette
	.db $00
	.db PALH_63
