; List of sources from which a tile can be broken.
; Each value corresponds to a bit for the first 3 parameters in the m_BreakableTileModes
; macro.

.ENUM 0
	BREAKABLETILESOURCE_00		db ; 0x00: power bracelet (both levels?)
	BREAKABLETILESOURCE_SWORD_L1	db ; 0x01: also ricky tornado
	BREAKABLETILESOURCE_SWORD_L2	db ; 0x02: also biggoron's sword
	BREAKABLETILESOURCE_03		db ; 0x03: Expert's ring
	BREAKABLETILESOURCE_04		db ; 0x04: Explosion from a bomb (just Link's bombs, or other kinds?)
	BREAKABLETILESOURCE_05		db ; 0x05: Triggers when Link respawns after falling in a hole, lands on something after falling down a ledge
	BREAKABLETILESOURCE_06		db ; 0x06: Shovel, ENEMYID_PINCER emerging
	BREAKABLETILESOURCE_07		db ; 0x07
	BREAKABLETILESOURCE_SWITCH_HOOK	db ; 0x08 (This may be more general than the switch hook, not sure)
	BREAKABLETILESOURCE_09		db ; 0x09
	BREAKABLETILESOURCE_0a		db ; 0x0a
	BREAKABLETILESOURCE_0b		db ; 0x0b
	BREAKABLETILESOURCE_0c		db ; 0x0c: Ember seed?
	BREAKABLETILESOURCE_0d		db ; 0x0d: Gale seed?
	BREAKABLETILESOURCE_0e		db ; 0x0e
	BREAKABLETILESOURCE_0f		db ; 0x0f: Ricky punch?
	BREAKABLETILESOURCE_10		db ; 0x10: Ricky landed on the ground?
	BREAKABLETILESOURCE_11		db ; 0x11: Moosh buttstomp?
	BREAKABLETILESOURCE_DIMITRI_EAT	db ; 0x12
	BREAKABLETILESOURCE_13		db ; 0x13: Breakable by companion movement?
	BREAKABLETILESOURCE_14		db ; 0x14
	BREAKABLETILESOURCE_15		db ; 0x15
	BREAKABLETILESOURCE_16		db ; 0x16
	BREAKABLETILESOURCE_17		db ; 0x17
	BREAKABLETILESOURCE_18		db ; 0x18
	BREAKABLETILESOURCE_19		db ; 0x19
	BREAKABLETILESOURCE_1a		db ; 0x1a
	BREAKABLETILESOURCE_1b		db ; 0x1b
	BREAKABLETILESOURCE_1c		db ; 0x1c
	BREAKABLETILESOURCE_1d		db ; 0x1d
	BREAKABLETILESOURCE_1e		db ; 0x1e
	BREAKABLETILESOURCE_1f		db ; 0x1f
.ENDE
