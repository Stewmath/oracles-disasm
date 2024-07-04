; List of sources from which a tile can be broken.
;
; Each value corresponds to a bit for the first 3 parameters in the m_BreakableTileModes macro in
; data/{game}/tile_properties/breakableTiles.s

.ENUM 0
	BREAKABLETILESOURCE_BRACELET:		db ; 0x00: power bracelet (both levels)
	BREAKABLETILESOURCE_SWORD_L1:		db ; 0x01: also ricky tornado
	BREAKABLETILESOURCE_SWORD_L2:		db ; 0x02: also biggoron's sword
	BREAKABLETILESOURCE_EXPERTS_RING:	db ; 0x03
	BREAKABLETILESOURCE_BOMB:		db ; 0x04
	BREAKABLETILESOURCE_LANDED:		db ; 0x05: Triggers when Link respawns after falling in a hole, or falls down a ledge
	BREAKABLETILESOURCE_SHOVEL:		db ; 0x06: Also used by ENEMY_PINCER emerging
	BREAKABLETILESOURCE_07:			db ; 0x07
	BREAKABLETILESOURCE_SWITCH_HOOK:	db ; 0x08
	BREAKABLETILESOURCE_09:			db ; 0x09
	BREAKABLETILESOURCE_0a:			db ; 0x0a
	BREAKABLETILESOURCE_0b:			db ; 0x0b
	BREAKABLETILESOURCE_EMBER_SEED:		db ; 0x0c
	BREAKABLETILESOURCE_GALE_SEED:		db ; 0x0d
	BREAKABLETILESOURCE_0e:			db ; 0x0e
	BREAKABLETILESOURCE_RICKY_PUNCH:	db ; 0x0f
	BREAKABLETILESOURCE_RICKY_LANDED:	db ; 0x10
	BREAKABLETILESOURCE_MOOSH_BUTTSTOMP:	db ; 0x11
	BREAKABLETILESOURCE_DIMITRI_EAT:	db ; 0x12
	BREAKABLETILESOURCE_COMPANION_MOVEMENT:	db ; 0x13
.ENDE
