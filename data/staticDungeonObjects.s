; Data format:
; b0: object type (3=interaction, 4=enemy, 5=part)
; b1: room index
; b2: High byte of ID
; b3: Bits 0-6 = low byte of id, bit 7 sets bit 1 of the object's ENABLED byte
; b4: Y
; b5: X

staticDungeonObjects:
	.dw dungeon0StaticObjects
	.dw dungeon1StaticObjects
	.dw dungeon2StaticObjects
	.dw dungeon3StaticObjects
	.dw dungeon4StaticObjects
	.dw dungeon5StaticObjects
	.dw dungeon6StaticObjects
	.dw dungeon7StaticObjects
	.dw dungeon8StaticObjects
	.dw dungeon9StaticObjects
	.dw dungeonaStaticObjects
	.dw dungeonbStaticObjects
	.dw dungeoncStaticObjects
	.dw dungeondStaticObjects
	.dw dungeoneStaticObjects
	.dw dungeonfStaticObjects

; @addr{50c7}
dungeon2StaticObjects:
	.db $03 $33 $16 $00 $38 $c8
	.db $03 $35 $16 $00 $68 $b8
	.db $03 $40 $16 $00 $58 $a8
	.db $ff 
; @addr{50da}
dungeon4StaticObjects:
	.db $03 $73 $16 $00 $58 $48
	.db $03 $75 $16 $00 $58 $a8
	.db $03 $78 $16 $00 $88 $78
	.db $03 $89 $16 $00 $88 $48
	.db $ff 
; @addr{50f3}
dungeon8StaticObjects:
	.db $03 $90 $16 $00 $38 $98
	.db $03 $92 $16 $00 $88 $48
	.db $ff 
; @addr{5100}
dungeonbStaticObjects:
	.db $03 $c3 $16 $00 $48 $28
	.db $ff 
; @addr{5107}
dungeon0StaticObjects:
dungeon1StaticObjects:
dungeon3StaticObjects:
dungeon5StaticObjects:
dungeon6StaticObjects:
dungeon7StaticObjects:
dungeon9StaticObjects:
dungeonaStaticObjects:
dungeoncStaticObjects:
dungeondStaticObjects:
dungeoneStaticObjects:
dungeonfStaticObjects:
	.db $ff
