; See data/ages/staticDungeonObjects.s for documentation

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
	.dw dungeonAStaticObjects
	.dw dungeonBStaticObjects


dungeon0StaticObjects:
	.db $ff

dungeon1StaticObjects:
	.db $03 $15 INTERACID_MINECART $00 $28 $78
	.db $ff

dungeon2StaticObjects:
dungeon3StaticObjects:
	.db $ff

dungeon4StaticObjects:
	.db $03 $65 INTERACID_MINECART $00 $88 $38
	.db $03 $6f INTERACID_MINECART $01 $28 $58
	.db $03 $7c INTERACID_MINECART $02 $38 $38
	.db $03 $7f INTERACID_MINECART $00 $68 $28
	.db $ff

dungeon5StaticObjects:
	.db $03 $a5 INTERACID_MINECART $00 $38 $48
	.db $03 $a5 INTERACID_MINECART $00 $48 $78
	.db $03 $a1 INTERACID_MINECART $00 $78 $38
	.db $03 $89 INTERACID_DUNGEON_STUFF $05 $28 $88
	.db $03 $94 INTERACID_DUNGEON_STUFF $05 $18 $c8
	.db $03 $97 INTERACID_DUNGEON_STUFF $05 $78 $78
	.db $03 $9a INTERACID_D5_FALLING_MAGNET_BALL $00 $38 $48
	.db $ff

dungeon6StaticObjects:
	.db $03 $ab INTERACID_DUNGEON_STUFF $05 $98 $28
	.db $03 $ac INTERACID_DUNGEON_STUFF $05 $48 $98
	.db $03 $b6 INTERACID_DUNGEON_STUFF $05 $18 $18
	.db $03 $d2 INTERACID_DUNGEON_STUFF $05 $28 $c8
	.db $ff

dungeon7StaticObjects:
	.db $03 $47 INTERACID_DUNGEON_STUFF $05 $48 $78
	.db $ff

dungeon8StaticObjects:
	.db $03 $84 INTERACID_MINECART $00 $58 $28
	.db $03 $88 INTERACID_MINECART $00 $38 $38
	.db $03 $75 INTERACID_DUNGEON_STUFF $05 $18 $38
	.db $03 $8e INTERACID_DUNGEON_STUFF $05 $38 $48
	.db $ff

dungeon9StaticObjects:
dungeonAStaticObjects:
	.db $ff

dungeonBStaticObjects:
	.db $03 $24 INTERACID_DUNGEON_STUFF $05 $18 $18
	.db $ff
