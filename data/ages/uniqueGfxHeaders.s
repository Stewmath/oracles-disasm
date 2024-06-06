uniqueGfxHeadersStart:

; HACK-BASE: All data removed for expanded tilesets patch.
; TODO: Fix "uniqueGfxHeader14" reference (what does it do?)
uniqueGfxHeader00:
uniqueGfxHeader01:
uniqueGfxHeader02:
uniqueGfxHeader03:
uniqueGfxHeader04:
uniqueGfxHeader05:
uniqueGfxHeader06:
uniqueGfxHeader07:
uniqueGfxHeader08:
uniqueGfxHeader09:
uniqueGfxHeader0a:
uniqueGfxHeader0b:
uniqueGfxHeader0c:
uniqueGfxHeader0d:
uniqueGfxHeader0e:
uniqueGfxHeader0f:
uniqueGfxHeader10:
uniqueGfxHeader11:
uniqueGfxHeader12:
uniqueGfxHeader13:
uniqueGfxHeader14: ; This actually references a palette
	.db $00
	.db PALH_63
