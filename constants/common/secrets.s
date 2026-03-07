; These are values for "wShortSecretIndex".
;
; TODO: substitute these secret values:
;   - In "var3f" loads for interactions which use "linkedGameNpcScript".
;   - In all loads to "wShortSecretIndex" variable.


; Linked Seasons secrets
.enum 0
	KING_ZORA_SECRET		db ; $00
	FAIRY_SECRET			db ; $01
	TROY_SECRET			db ; $02
	PLEN_SECRET			db ; $03
	LIBRARY_SECRET			db ; $04
	TOKAY_SECRET			db ; $05
	MAMAMU_SECRET			db ; $06
	TINGLE_SECRET			db ; $07
	ELDER_SECRET			db ; $08
	SYMMETRY_SECRET			db ; $09
.ende

; Linked Seasons return secrets
.enum $10
	KING_ZORA_RETURN_SECRET		db ; $10
	FAIRY_RETURN_SECRET		db ; $11
	TROY_RETURN_SECRET		db ; $12
	PLEN_RETURN_SECRET		db ; $13
	LIBRARY_RETURN_SECRET		db ; $14
	TOKAY_RETURN_SECRET		db ; $15
	MAMAMU_RETURN_SECRET		db ; $16
	TINGLE_RETURN_SECRET		db ; $17
	ELDER_RETURN_SECRET		db ; $18
	SYMMETRY_RETURN_SECRET		db ; $19
.ende

; Linked Ages secrets
.enum $20
	CLOCK_SHOP_SECRET		db ; $20
	GRAVEYARD_SECRET		db ; $21
	SUBROSIAN_SECRET		db ; $22
	DIVER_SECRET			db ; $23
	SMITH_SECRET			db ; $24
	PIRATE_SECRET			db ; $25
	TEMPLE_SECRET			db ; $26
	DEKU_SECRET			db ; $27
	BIGGORON_SECRET			db ; $28
	RUUL_SECRET			db ; $29
.ende

; Linked Ages return secrets
.enum $30
	CLOCK_SHOP_RETURN_SECRET	db ; $30
	GRAVEYARD_RETURN_SECRET		db ; $31
	SUBROSIAN_RETURN_SECRET		db ; $32
	DIVER_RETURN_SECRET		db ; $33
	SMITH_RETURN_SECRET		db ; $34
	PIRATE_RETURN_SECRET		db ; $35
	TEMPLE_RETURN_SECRET		db ; $36
	DEKU_RETURN_SECRET		db ; $37
	BIGGORON_RETURN_SECRET		db ; $38
	RUUL_RETURN_SECRET		db ; $39
.ende
