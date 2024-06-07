; HACK-BASE: Expanded GFX, tilemap, and collision data for tilesets are stored here.


; Not using the "3BytePointer" macro here because we want the 1st byte "$ff" to mean "is a seasonal
; tileset". (Technically bank "$ff" could end up in use when ROM is expanded.)
.macro m_TilesetGfxPointer
	dwbe \1
	.db :\1
.endm

.SLOT 1
.section ExpandedTilesetPointers SUPERFREE

expandedTilesetGfxTable:
	m_TilesetGfxPointer gfx_tileset00
	m_TilesetGfxPointer gfx_tileset01
	m_TilesetGfxPointer gfx_tileset02
	m_TilesetGfxPointer gfx_tileset03
	m_TilesetGfxPointer gfx_tileset04
	m_TilesetGfxPointer gfx_tileset05
	m_TilesetGfxPointer gfx_tileset06
	m_TilesetGfxPointer gfx_tileset07
	m_TilesetGfxPointer gfx_tileset08
	m_TilesetGfxPointer gfx_tileset09
	m_TilesetGfxPointer gfx_tileset0a
	m_TilesetGfxPointer gfx_tileset0b
	m_TilesetGfxPointer gfx_tileset0c
	m_TilesetGfxPointer gfx_tileset0d
	m_TilesetGfxPointer gfx_tileset0e
	m_TilesetGfxPointer gfx_tileset0f
	m_TilesetGfxPointer gfx_tileset10
	m_TilesetGfxPointer gfx_tileset11
	m_TilesetGfxPointer gfx_tileset12
	m_TilesetGfxPointer gfx_tileset13
	m_TilesetGfxPointer gfx_tileset14
	m_TilesetGfxPointer gfx_tileset15
	m_TilesetGfxPointer gfx_tileset16
	m_TilesetGfxPointer gfx_tileset17
	m_TilesetGfxPointer gfx_tileset18
	m_TilesetGfxPointer gfx_tileset19
	m_TilesetGfxPointer gfx_tileset1a
	m_TilesetGfxPointer gfx_tileset1b
	m_TilesetGfxPointer gfx_tileset1c
	m_TilesetGfxPointer gfx_tileset1d
	m_TilesetGfxPointer gfx_tileset1e
	m_TilesetGfxPointer gfx_tileset1f
	m_TilesetGfxPointer gfx_tileset20
	m_TilesetGfxPointer gfx_tileset21
	m_TilesetGfxPointer gfx_tileset22
	m_TilesetGfxPointer gfx_tileset23
	m_TilesetGfxPointer gfx_tileset24
	m_TilesetGfxPointer gfx_tileset25
	m_TilesetGfxPointer gfx_tileset26
	m_TilesetGfxPointer gfx_tileset27
	m_TilesetGfxPointer gfx_tileset28
	m_TilesetGfxPointer gfx_tileset29
	m_TilesetGfxPointer gfx_tileset2a
	m_TilesetGfxPointer gfx_tileset2b
	m_TilesetGfxPointer gfx_tileset2c
	m_TilesetGfxPointer gfx_tileset2d
	m_TilesetGfxPointer gfx_tileset2e
	m_TilesetGfxPointer gfx_tileset2f
	m_TilesetGfxPointer gfx_tileset30
	m_TilesetGfxPointer gfx_tileset31
	m_TilesetGfxPointer gfx_tileset32
	m_TilesetGfxPointer gfx_tileset33
	m_TilesetGfxPointer gfx_tileset34
	m_TilesetGfxPointer gfx_tileset35
	m_TilesetGfxPointer gfx_tileset36
	m_TilesetGfxPointer gfx_tileset37
	m_TilesetGfxPointer gfx_tileset38
	m_TilesetGfxPointer gfx_tileset39
	m_TilesetGfxPointer gfx_tileset3a
	m_TilesetGfxPointer gfx_tileset3b
	m_TilesetGfxPointer gfx_tileset3c
	m_TilesetGfxPointer gfx_tileset3d
	m_TilesetGfxPointer gfx_tileset3e
	m_TilesetGfxPointer gfx_tileset3f
	m_TilesetGfxPointer gfx_tileset40
	m_TilesetGfxPointer gfx_tileset41
	m_TilesetGfxPointer gfx_tileset42
	m_TilesetGfxPointer gfx_tileset43
	m_TilesetGfxPointer gfx_tileset44
	m_TilesetGfxPointer gfx_tileset45
	m_TilesetGfxPointer gfx_tileset46
	m_TilesetGfxPointer gfx_tileset47
	m_TilesetGfxPointer gfx_tileset48
	m_TilesetGfxPointer gfx_tileset49
	m_TilesetGfxPointer gfx_tileset4a
	m_TilesetGfxPointer gfx_tileset4b
	m_TilesetGfxPointer gfx_tileset4c
	m_TilesetGfxPointer gfx_tileset4d
	m_TilesetGfxPointer gfx_tileset4e
	m_TilesetGfxPointer gfx_tileset4f
	m_TilesetGfxPointer gfx_tileset50
	m_TilesetGfxPointer gfx_tileset51
	m_TilesetGfxPointer gfx_tileset52
	m_TilesetGfxPointer gfx_tileset53
	m_TilesetGfxPointer gfx_tileset54
	m_TilesetGfxPointer gfx_tileset55
	m_TilesetGfxPointer gfx_tileset56
	m_TilesetGfxPointer gfx_tileset57
	m_TilesetGfxPointer gfx_tileset58
	m_TilesetGfxPointer gfx_tileset59
	m_TilesetGfxPointer gfx_tileset5a
	m_TilesetGfxPointer gfx_tileset5b
	m_TilesetGfxPointer gfx_tileset5c
	m_TilesetGfxPointer gfx_tileset5d
	m_TilesetGfxPointer gfx_tileset5e
	m_TilesetGfxPointer gfx_tileset5f
	m_TilesetGfxPointer gfx_tileset60
	m_TilesetGfxPointer gfx_tileset61
	m_TilesetGfxPointer gfx_tileset62
	m_TilesetGfxPointer gfx_tileset63
	m_TilesetGfxPointer gfx_tileset64
	m_TilesetGfxPointer gfx_tileset65
	m_TilesetGfxPointer gfx_tileset66
	m_TilesetGfxPointer gfx_tileset67
	m_TilesetGfxPointer gfx_tileset68
	m_TilesetGfxPointer gfx_tileset69
	m_TilesetGfxPointer gfx_tileset6a
	m_TilesetGfxPointer gfx_tileset6b
	m_TilesetGfxPointer gfx_tileset6c
	m_TilesetGfxPointer gfx_tileset6d
	m_TilesetGfxPointer gfx_tileset6e
	m_TilesetGfxPointer gfx_tileset6f
	m_TilesetGfxPointer gfx_tileset70
	m_TilesetGfxPointer gfx_tileset71
	m_TilesetGfxPointer gfx_tileset72
	m_TilesetGfxPointer gfx_tileset73
	m_TilesetGfxPointer gfx_tileset74
	m_TilesetGfxPointer gfx_tileset75
	m_TilesetGfxPointer gfx_tileset76
	m_TilesetGfxPointer gfx_tileset77
	m_TilesetGfxPointer gfx_tileset78
	m_TilesetGfxPointer gfx_tileset79
	m_TilesetGfxPointer gfx_tileset7a
	m_TilesetGfxPointer gfx_tileset7b
	m_TilesetGfxPointer gfx_tileset7c
	m_TilesetGfxPointer gfx_tileset7d
	m_TilesetGfxPointer gfx_tileset7e
	m_TilesetGfxPointer gfx_tileset7f


expandedTilesetMappingsTable:
	m_TilesetGfxPointer tilesetMappings00
	m_TilesetGfxPointer tilesetMappings01
	m_TilesetGfxPointer tilesetMappings02
	m_TilesetGfxPointer tilesetMappings03
	m_TilesetGfxPointer tilesetMappings04
	m_TilesetGfxPointer tilesetMappings05
	m_TilesetGfxPointer tilesetMappings06
	m_TilesetGfxPointer tilesetMappings07
	m_TilesetGfxPointer tilesetMappings08
	m_TilesetGfxPointer tilesetMappings09
	m_TilesetGfxPointer tilesetMappings0a
	m_TilesetGfxPointer tilesetMappings0b
	m_TilesetGfxPointer tilesetMappings0c
	m_TilesetGfxPointer tilesetMappings0d
	m_TilesetGfxPointer tilesetMappings0e
	m_TilesetGfxPointer tilesetMappings0f
	m_TilesetGfxPointer tilesetMappings10
	m_TilesetGfxPointer tilesetMappings11
	m_TilesetGfxPointer tilesetMappings12
	m_TilesetGfxPointer tilesetMappings13
	m_TilesetGfxPointer tilesetMappings14
	m_TilesetGfxPointer tilesetMappings15
	m_TilesetGfxPointer tilesetMappings16
	m_TilesetGfxPointer tilesetMappings17
	m_TilesetGfxPointer tilesetMappings18
	m_TilesetGfxPointer tilesetMappings19
	m_TilesetGfxPointer tilesetMappings1a
	m_TilesetGfxPointer tilesetMappings1b
	m_TilesetGfxPointer tilesetMappings1c
	m_TilesetGfxPointer tilesetMappings1d
	m_TilesetGfxPointer tilesetMappings1e
	m_TilesetGfxPointer tilesetMappings1f
	m_TilesetGfxPointer tilesetMappings20
	m_TilesetGfxPointer tilesetMappings21
	m_TilesetGfxPointer tilesetMappings22
	m_TilesetGfxPointer tilesetMappings23
	m_TilesetGfxPointer tilesetMappings24
	m_TilesetGfxPointer tilesetMappings25
	m_TilesetGfxPointer tilesetMappings26
	m_TilesetGfxPointer tilesetMappings27
	m_TilesetGfxPointer tilesetMappings28
	m_TilesetGfxPointer tilesetMappings29
	m_TilesetGfxPointer tilesetMappings2a
	m_TilesetGfxPointer tilesetMappings2b
	m_TilesetGfxPointer tilesetMappings2c
	m_TilesetGfxPointer tilesetMappings2d
	m_TilesetGfxPointer tilesetMappings2e
	m_TilesetGfxPointer tilesetMappings2f
	m_TilesetGfxPointer tilesetMappings30
	m_TilesetGfxPointer tilesetMappings31
	m_TilesetGfxPointer tilesetMappings32
	m_TilesetGfxPointer tilesetMappings33
	m_TilesetGfxPointer tilesetMappings34
	m_TilesetGfxPointer tilesetMappings35
	m_TilesetGfxPointer tilesetMappings36
	m_TilesetGfxPointer tilesetMappings37
	m_TilesetGfxPointer tilesetMappings38
	m_TilesetGfxPointer tilesetMappings39
	m_TilesetGfxPointer tilesetMappings3a
	m_TilesetGfxPointer tilesetMappings3b
	m_TilesetGfxPointer tilesetMappings3c
	m_TilesetGfxPointer tilesetMappings3d
	m_TilesetGfxPointer tilesetMappings3e
	m_TilesetGfxPointer tilesetMappings3f
	m_TilesetGfxPointer tilesetMappings40
	m_TilesetGfxPointer tilesetMappings41
	m_TilesetGfxPointer tilesetMappings42
	m_TilesetGfxPointer tilesetMappings43
	m_TilesetGfxPointer tilesetMappings44
	m_TilesetGfxPointer tilesetMappings45
	m_TilesetGfxPointer tilesetMappings46
	m_TilesetGfxPointer tilesetMappings47
	m_TilesetGfxPointer tilesetMappings48
	m_TilesetGfxPointer tilesetMappings49
	m_TilesetGfxPointer tilesetMappings4a
	m_TilesetGfxPointer tilesetMappings4b
	m_TilesetGfxPointer tilesetMappings4c
	m_TilesetGfxPointer tilesetMappings4d
	m_TilesetGfxPointer tilesetMappings4e
	m_TilesetGfxPointer tilesetMappings4f
	m_TilesetGfxPointer tilesetMappings50
	m_TilesetGfxPointer tilesetMappings51
	m_TilesetGfxPointer tilesetMappings52
	m_TilesetGfxPointer tilesetMappings53
	m_TilesetGfxPointer tilesetMappings54
	m_TilesetGfxPointer tilesetMappings55
	m_TilesetGfxPointer tilesetMappings56
	m_TilesetGfxPointer tilesetMappings57
	m_TilesetGfxPointer tilesetMappings58
	m_TilesetGfxPointer tilesetMappings59
	m_TilesetGfxPointer tilesetMappings5a
	m_TilesetGfxPointer tilesetMappings5b
	m_TilesetGfxPointer tilesetMappings5c
	m_TilesetGfxPointer tilesetMappings5d
	m_TilesetGfxPointer tilesetMappings5e
	m_TilesetGfxPointer tilesetMappings5f
	m_TilesetGfxPointer tilesetMappings60
	m_TilesetGfxPointer tilesetMappings61
	m_TilesetGfxPointer tilesetMappings62
	m_TilesetGfxPointer tilesetMappings63
	m_TilesetGfxPointer tilesetMappings64
	m_TilesetGfxPointer tilesetMappings65
	m_TilesetGfxPointer tilesetMappings66
	m_TilesetGfxPointer tilesetMappings67
	m_TilesetGfxPointer tilesetMappings68
	m_TilesetGfxPointer tilesetMappings69
	m_TilesetGfxPointer tilesetMappings6a
	m_TilesetGfxPointer tilesetMappings6b
	m_TilesetGfxPointer tilesetMappings6c
	m_TilesetGfxPointer tilesetMappings6d
	m_TilesetGfxPointer tilesetMappings6e
	m_TilesetGfxPointer tilesetMappings6f
	m_TilesetGfxPointer tilesetMappings70
	m_TilesetGfxPointer tilesetMappings71
	m_TilesetGfxPointer tilesetMappings72
	m_TilesetGfxPointer tilesetMappings73
	m_TilesetGfxPointer tilesetMappings74
	m_TilesetGfxPointer tilesetMappings75
	m_TilesetGfxPointer tilesetMappings76
	m_TilesetGfxPointer tilesetMappings77
	m_TilesetGfxPointer tilesetMappings78
	m_TilesetGfxPointer tilesetMappings79
	m_TilesetGfxPointer tilesetMappings7a
	m_TilesetGfxPointer tilesetMappings7b
	m_TilesetGfxPointer tilesetMappings7c
	m_TilesetGfxPointer tilesetMappings7d
	m_TilesetGfxPointer tilesetMappings7e
	m_TilesetGfxPointer tilesetMappings7f
.ends


.BANK $40 SLOT 1
.ORGA $4000

.redefine DATA_ADDR $4000
.redefine DATA_BANK $40

	; For simplicity I'm using the "m_GfxData" macro, which can handle data crossing banks.
	; But since each tileset is exactly 0x1000 bytes (and is uncompressed) it doesn't actually
	; cross over any banks.
	m_GfxData gfx_tileset00
	m_GfxData gfx_tileset01
	m_GfxData gfx_tileset02
	m_GfxData gfx_tileset03
	m_GfxData gfx_tileset04
	m_GfxData gfx_tileset05
	m_GfxData gfx_tileset06
	m_GfxData gfx_tileset07
	m_GfxData gfx_tileset08
	m_GfxData gfx_tileset09
	m_GfxData gfx_tileset0a
	m_GfxData gfx_tileset0b
	m_GfxData gfx_tileset0c
	m_GfxData gfx_tileset0d
	m_GfxData gfx_tileset0e
	m_GfxData gfx_tileset0f
	m_GfxData gfx_tileset10
	m_GfxData gfx_tileset11
	m_GfxData gfx_tileset12
	m_GfxData gfx_tileset13
	m_GfxData gfx_tileset14
	m_GfxData gfx_tileset15
	m_GfxData gfx_tileset16
	m_GfxData gfx_tileset17
	m_GfxData gfx_tileset18
	m_GfxData gfx_tileset19
	m_GfxData gfx_tileset1a
	m_GfxData gfx_tileset1b
	m_GfxData gfx_tileset1c
	m_GfxData gfx_tileset1d
	m_GfxData gfx_tileset1e
	m_GfxData gfx_tileset1f
	m_GfxData gfx_tileset20
	m_GfxData gfx_tileset21
	m_GfxData gfx_tileset22
	m_GfxData gfx_tileset23
	m_GfxData gfx_tileset24
	m_GfxData gfx_tileset25
	m_GfxData gfx_tileset26
	m_GfxData gfx_tileset27
	m_GfxData gfx_tileset28
	m_GfxData gfx_tileset29
	m_GfxData gfx_tileset2a
	m_GfxData gfx_tileset2b
	m_GfxData gfx_tileset2c
	m_GfxData gfx_tileset2d
	m_GfxData gfx_tileset2e
	m_GfxData gfx_tileset2f
	m_GfxData gfx_tileset30
	m_GfxData gfx_tileset31
	m_GfxData gfx_tileset32
	m_GfxData gfx_tileset33
	m_GfxData gfx_tileset34
	m_GfxData gfx_tileset35
	m_GfxData gfx_tileset36
	m_GfxData gfx_tileset37
	m_GfxData gfx_tileset38
	m_GfxData gfx_tileset39
	m_GfxData gfx_tileset3a
	m_GfxData gfx_tileset3b
	m_GfxData gfx_tileset3c
	m_GfxData gfx_tileset3d
	m_GfxData gfx_tileset3e
	m_GfxData gfx_tileset3f
	m_GfxData gfx_tileset40
	m_GfxData gfx_tileset41
	m_GfxData gfx_tileset42
	m_GfxData gfx_tileset43
	m_GfxData gfx_tileset44
	m_GfxData gfx_tileset45
	m_GfxData gfx_tileset46
	m_GfxData gfx_tileset47
	m_GfxData gfx_tileset48
	m_GfxData gfx_tileset49
	m_GfxData gfx_tileset4a
	m_GfxData gfx_tileset4b
	m_GfxData gfx_tileset4c
	m_GfxData gfx_tileset4d
	m_GfxData gfx_tileset4e
	m_GfxData gfx_tileset4f
	m_GfxData gfx_tileset50
	m_GfxData gfx_tileset51
	m_GfxData gfx_tileset52
	m_GfxData gfx_tileset53
	m_GfxData gfx_tileset54
	m_GfxData gfx_tileset55
	m_GfxData gfx_tileset56
	m_GfxData gfx_tileset57
	m_GfxData gfx_tileset58
	m_GfxData gfx_tileset59
	m_GfxData gfx_tileset5a
	m_GfxData gfx_tileset5b
	m_GfxData gfx_tileset5c
	m_GfxData gfx_tileset5d
	m_GfxData gfx_tileset5e
	m_GfxData gfx_tileset5f
	m_GfxData gfx_tileset60
	m_GfxData gfx_tileset61
	m_GfxData gfx_tileset62
	m_GfxData gfx_tileset63
	m_GfxData gfx_tileset64
	m_GfxData gfx_tileset65
	m_GfxData gfx_tileset66
	m_GfxData gfx_tileset67
	m_GfxData gfx_tileset68
	m_GfxData gfx_tileset69
	m_GfxData gfx_tileset6a
	m_GfxData gfx_tileset6b
	m_GfxData gfx_tileset6c
	m_GfxData gfx_tileset6d
	m_GfxData gfx_tileset6e
	m_GfxData gfx_tileset6f
	m_GfxData gfx_tileset70
	m_GfxData gfx_tileset71
	m_GfxData gfx_tileset72
	m_GfxData gfx_tileset73
	m_GfxData gfx_tileset74
	m_GfxData gfx_tileset75
	m_GfxData gfx_tileset76
	m_GfxData gfx_tileset77
	m_GfxData gfx_tileset78
	m_GfxData gfx_tileset79
	m_GfxData gfx_tileset7a
	m_GfxData gfx_tileset7b
	m_GfxData gfx_tileset7c
	m_GfxData gfx_tileset7d
	m_GfxData gfx_tileset7e
	m_GfxData gfx_tileset7f

.section expanded_tileset_mappings_00 SUPERFREE
tilesetMappings00:
	.incbin "tileset_layouts_expanded/ages/tilesetMappings00.bin"
	.incbin "tileset_layouts_expanded/ages/tilesetCollisions00.bin"
.ends

.section expanded_tileset_mappings_01 SUPERFREE
tilesetMappings01:
	.incbin "tileset_layouts_expanded/ages/tilesetMappings01.bin"
	.incbin "tileset_layouts_expanded/ages/tilesetCollisions01.bin"
.ends

.section expanded_tileset_mappings_02 SUPERFREE
tilesetMappings02:
	.incbin "tileset_layouts_expanded/ages/tilesetMappings02.bin"
	.incbin "tileset_layouts_expanded/ages/tilesetCollisions02.bin"
.ends

.section expanded_tileset_mappings_03 SUPERFREE
tilesetMappings03:
	.incbin "tileset_layouts_expanded/ages/tilesetMappings03.bin"
	.incbin "tileset_layouts_expanded/ages/tilesetCollisions03.bin"
.ends

.section expanded_tileset_mappings_04 SUPERFREE
tilesetMappings04:
	.incbin "tileset_layouts_expanded/ages/tilesetMappings04.bin"
	.incbin "tileset_layouts_expanded/ages/tilesetCollisions04.bin"
.ends

.section expanded_tileset_mappings_05 SUPERFREE
tilesetMappings05:
	.incbin "tileset_layouts_expanded/ages/tilesetMappings05.bin"
	.incbin "tileset_layouts_expanded/ages/tilesetCollisions05.bin"
.ends

.section expanded_tileset_mappings_06 SUPERFREE
tilesetMappings06:
	.incbin "tileset_layouts_expanded/ages/tilesetMappings06.bin"
	.incbin "tileset_layouts_expanded/ages/tilesetCollisions06.bin"
.ends

.section expanded_tileset_mappings_07 SUPERFREE
tilesetMappings07:
	.incbin "tileset_layouts_expanded/ages/tilesetMappings07.bin"
	.incbin "tileset_layouts_expanded/ages/tilesetCollisions07.bin"
.ends

.section expanded_tileset_mappings_08 SUPERFREE
tilesetMappings08:
	.incbin "tileset_layouts_expanded/ages/tilesetMappings08.bin"
	.incbin "tileset_layouts_expanded/ages/tilesetCollisions08.bin"
.ends

.section expanded_tileset_mappings_09 SUPERFREE
tilesetMappings09:
	.incbin "tileset_layouts_expanded/ages/tilesetMappings09.bin"
	.incbin "tileset_layouts_expanded/ages/tilesetCollisions09.bin"
.ends

.section expanded_tileset_mappings_0a SUPERFREE
tilesetMappings0a:
	.incbin "tileset_layouts_expanded/ages/tilesetMappings0a.bin"
	.incbin "tileset_layouts_expanded/ages/tilesetCollisions0a.bin"
.ends

.section expanded_tileset_mappings_0b SUPERFREE
tilesetMappings0b:
	.incbin "tileset_layouts_expanded/ages/tilesetMappings0b.bin"
	.incbin "tileset_layouts_expanded/ages/tilesetCollisions0b.bin"
.ends

.section expanded_tileset_mappings_0c SUPERFREE
tilesetMappings0c:
	.incbin "tileset_layouts_expanded/ages/tilesetMappings0c.bin"
	.incbin "tileset_layouts_expanded/ages/tilesetCollisions0c.bin"
.ends

.section expanded_tileset_mappings_0d SUPERFREE
tilesetMappings0d:
	.incbin "tileset_layouts_expanded/ages/tilesetMappings0d.bin"
	.incbin "tileset_layouts_expanded/ages/tilesetCollisions0d.bin"
.ends

.section expanded_tileset_mappings_0e SUPERFREE
tilesetMappings0e:
	.incbin "tileset_layouts_expanded/ages/tilesetMappings0e.bin"
	.incbin "tileset_layouts_expanded/ages/tilesetCollisions0e.bin"
.ends

.section expanded_tileset_mappings_0f SUPERFREE
tilesetMappings0f:
	.incbin "tileset_layouts_expanded/ages/tilesetMappings0f.bin"
	.incbin "tileset_layouts_expanded/ages/tilesetCollisions0f.bin"
.ends

.section expanded_tileset_mappings_10 SUPERFREE
tilesetMappings10:
	.incbin "tileset_layouts_expanded/ages/tilesetMappings10.bin"
	.incbin "tileset_layouts_expanded/ages/tilesetCollisions10.bin"
.ends

.section expanded_tileset_mappings_11 SUPERFREE
tilesetMappings11:
	.incbin "tileset_layouts_expanded/ages/tilesetMappings11.bin"
	.incbin "tileset_layouts_expanded/ages/tilesetCollisions11.bin"
.ends

.section expanded_tileset_mappings_12 SUPERFREE
tilesetMappings12:
	.incbin "tileset_layouts_expanded/ages/tilesetMappings12.bin"
	.incbin "tileset_layouts_expanded/ages/tilesetCollisions12.bin"
.ends

.section expanded_tileset_mappings_13 SUPERFREE
tilesetMappings13:
	.incbin "tileset_layouts_expanded/ages/tilesetMappings13.bin"
	.incbin "tileset_layouts_expanded/ages/tilesetCollisions13.bin"
.ends

.section expanded_tileset_mappings_14 SUPERFREE
tilesetMappings14:
	.incbin "tileset_layouts_expanded/ages/tilesetMappings14.bin"
	.incbin "tileset_layouts_expanded/ages/tilesetCollisions14.bin"
.ends

.section expanded_tileset_mappings_15 SUPERFREE
tilesetMappings15:
	.incbin "tileset_layouts_expanded/ages/tilesetMappings15.bin"
	.incbin "tileset_layouts_expanded/ages/tilesetCollisions15.bin"
.ends

.section expanded_tileset_mappings_16 SUPERFREE
tilesetMappings16:
	.incbin "tileset_layouts_expanded/ages/tilesetMappings16.bin"
	.incbin "tileset_layouts_expanded/ages/tilesetCollisions16.bin"
.ends

.section expanded_tileset_mappings_17 SUPERFREE
tilesetMappings17:
	.incbin "tileset_layouts_expanded/ages/tilesetMappings17.bin"
	.incbin "tileset_layouts_expanded/ages/tilesetCollisions17.bin"
.ends

.section expanded_tileset_mappings_18 SUPERFREE
tilesetMappings18:
	.incbin "tileset_layouts_expanded/ages/tilesetMappings18.bin"
	.incbin "tileset_layouts_expanded/ages/tilesetCollisions18.bin"
.ends

.section expanded_tileset_mappings_19 SUPERFREE
tilesetMappings19:
	.incbin "tileset_layouts_expanded/ages/tilesetMappings19.bin"
	.incbin "tileset_layouts_expanded/ages/tilesetCollisions19.bin"
.ends

.section expanded_tileset_mappings_1a SUPERFREE
tilesetMappings1a:
	.incbin "tileset_layouts_expanded/ages/tilesetMappings1a.bin"
	.incbin "tileset_layouts_expanded/ages/tilesetCollisions1a.bin"
.ends

.section expanded_tileset_mappings_1b SUPERFREE
tilesetMappings1b:
	.incbin "tileset_layouts_expanded/ages/tilesetMappings1b.bin"
	.incbin "tileset_layouts_expanded/ages/tilesetCollisions1b.bin"
.ends

.section expanded_tileset_mappings_1c SUPERFREE
tilesetMappings1c:
	.incbin "tileset_layouts_expanded/ages/tilesetMappings1c.bin"
	.incbin "tileset_layouts_expanded/ages/tilesetCollisions1c.bin"
.ends

.section expanded_tileset_mappings_1d SUPERFREE
tilesetMappings1d:
	.incbin "tileset_layouts_expanded/ages/tilesetMappings1d.bin"
	.incbin "tileset_layouts_expanded/ages/tilesetCollisions1d.bin"
.ends

.section expanded_tileset_mappings_1e SUPERFREE
tilesetMappings1e:
	.incbin "tileset_layouts_expanded/ages/tilesetMappings1e.bin"
	.incbin "tileset_layouts_expanded/ages/tilesetCollisions1e.bin"
.ends

.section expanded_tileset_mappings_1f SUPERFREE
tilesetMappings1f:
	.incbin "tileset_layouts_expanded/ages/tilesetMappings1f.bin"
	.incbin "tileset_layouts_expanded/ages/tilesetCollisions1f.bin"
.ends

.section expanded_tileset_mappings_20 SUPERFREE
tilesetMappings20:
	.incbin "tileset_layouts_expanded/ages/tilesetMappings20.bin"
	.incbin "tileset_layouts_expanded/ages/tilesetCollisions20.bin"
.ends

.section expanded_tileset_mappings_21 SUPERFREE
tilesetMappings21:
	.incbin "tileset_layouts_expanded/ages/tilesetMappings21.bin"
	.incbin "tileset_layouts_expanded/ages/tilesetCollisions21.bin"
.ends

.section expanded_tileset_mappings_22 SUPERFREE
tilesetMappings22:
	.incbin "tileset_layouts_expanded/ages/tilesetMappings22.bin"
	.incbin "tileset_layouts_expanded/ages/tilesetCollisions22.bin"
.ends

.section expanded_tileset_mappings_23 SUPERFREE
tilesetMappings23:
	.incbin "tileset_layouts_expanded/ages/tilesetMappings23.bin"
	.incbin "tileset_layouts_expanded/ages/tilesetCollisions23.bin"
.ends

.section expanded_tileset_mappings_24 SUPERFREE
tilesetMappings24:
	.incbin "tileset_layouts_expanded/ages/tilesetMappings24.bin"
	.incbin "tileset_layouts_expanded/ages/tilesetCollisions24.bin"
.ends

.section expanded_tileset_mappings_25 SUPERFREE
tilesetMappings25:
	.incbin "tileset_layouts_expanded/ages/tilesetMappings25.bin"
	.incbin "tileset_layouts_expanded/ages/tilesetCollisions25.bin"
.ends

.section expanded_tileset_mappings_26 SUPERFREE
tilesetMappings26:
	.incbin "tileset_layouts_expanded/ages/tilesetMappings26.bin"
	.incbin "tileset_layouts_expanded/ages/tilesetCollisions26.bin"
.ends

.section expanded_tileset_mappings_27 SUPERFREE
tilesetMappings27:
	.incbin "tileset_layouts_expanded/ages/tilesetMappings27.bin"
	.incbin "tileset_layouts_expanded/ages/tilesetCollisions27.bin"
.ends

.section expanded_tileset_mappings_28 SUPERFREE
tilesetMappings28:
	.incbin "tileset_layouts_expanded/ages/tilesetMappings28.bin"
	.incbin "tileset_layouts_expanded/ages/tilesetCollisions28.bin"
.ends

.section expanded_tileset_mappings_29 SUPERFREE
tilesetMappings29:
	.incbin "tileset_layouts_expanded/ages/tilesetMappings29.bin"
	.incbin "tileset_layouts_expanded/ages/tilesetCollisions29.bin"
.ends

.section expanded_tileset_mappings_2a SUPERFREE
tilesetMappings2a:
	.incbin "tileset_layouts_expanded/ages/tilesetMappings2a.bin"
	.incbin "tileset_layouts_expanded/ages/tilesetCollisions2a.bin"
.ends

.section expanded_tileset_mappings_2b SUPERFREE
tilesetMappings2b:
	.incbin "tileset_layouts_expanded/ages/tilesetMappings2b.bin"
	.incbin "tileset_layouts_expanded/ages/tilesetCollisions2b.bin"
.ends

.section expanded_tileset_mappings_2c SUPERFREE
tilesetMappings2c:
	.incbin "tileset_layouts_expanded/ages/tilesetMappings2c.bin"
	.incbin "tileset_layouts_expanded/ages/tilesetCollisions2c.bin"
.ends

.section expanded_tileset_mappings_2d SUPERFREE
tilesetMappings2d:
	.incbin "tileset_layouts_expanded/ages/tilesetMappings2d.bin"
	.incbin "tileset_layouts_expanded/ages/tilesetCollisions2d.bin"
.ends

.section expanded_tileset_mappings_2e SUPERFREE
tilesetMappings2e:
	.incbin "tileset_layouts_expanded/ages/tilesetMappings2e.bin"
	.incbin "tileset_layouts_expanded/ages/tilesetCollisions2e.bin"
.ends

.section expanded_tileset_mappings_2f SUPERFREE
tilesetMappings2f:
	.incbin "tileset_layouts_expanded/ages/tilesetMappings2f.bin"
	.incbin "tileset_layouts_expanded/ages/tilesetCollisions2f.bin"
.ends

.section expanded_tileset_mappings_30 SUPERFREE
tilesetMappings30:
	.incbin "tileset_layouts_expanded/ages/tilesetMappings30.bin"
	.incbin "tileset_layouts_expanded/ages/tilesetCollisions30.bin"
.ends

.section expanded_tileset_mappings_31 SUPERFREE
tilesetMappings31:
	.incbin "tileset_layouts_expanded/ages/tilesetMappings31.bin"
	.incbin "tileset_layouts_expanded/ages/tilesetCollisions31.bin"
.ends

.section expanded_tileset_mappings_32 SUPERFREE
tilesetMappings32:
	.incbin "tileset_layouts_expanded/ages/tilesetMappings32.bin"
	.incbin "tileset_layouts_expanded/ages/tilesetCollisions32.bin"
.ends

.section expanded_tileset_mappings_33 SUPERFREE
tilesetMappings33:
	.incbin "tileset_layouts_expanded/ages/tilesetMappings33.bin"
	.incbin "tileset_layouts_expanded/ages/tilesetCollisions33.bin"
.ends

.section expanded_tileset_mappings_34 SUPERFREE
tilesetMappings34:
	.incbin "tileset_layouts_expanded/ages/tilesetMappings34.bin"
	.incbin "tileset_layouts_expanded/ages/tilesetCollisions34.bin"
.ends

.section expanded_tileset_mappings_35 SUPERFREE
tilesetMappings35:
	.incbin "tileset_layouts_expanded/ages/tilesetMappings35.bin"
	.incbin "tileset_layouts_expanded/ages/tilesetCollisions35.bin"
.ends

.section expanded_tileset_mappings_36 SUPERFREE
tilesetMappings36:
	.incbin "tileset_layouts_expanded/ages/tilesetMappings36.bin"
	.incbin "tileset_layouts_expanded/ages/tilesetCollisions36.bin"
.ends

.section expanded_tileset_mappings_37 SUPERFREE
tilesetMappings37:
	.incbin "tileset_layouts_expanded/ages/tilesetMappings37.bin"
	.incbin "tileset_layouts_expanded/ages/tilesetCollisions37.bin"
.ends

.section expanded_tileset_mappings_38 SUPERFREE
tilesetMappings38:
	.incbin "tileset_layouts_expanded/ages/tilesetMappings38.bin"
	.incbin "tileset_layouts_expanded/ages/tilesetCollisions38.bin"
.ends

.section expanded_tileset_mappings_39 SUPERFREE
tilesetMappings39:
	.incbin "tileset_layouts_expanded/ages/tilesetMappings39.bin"
	.incbin "tileset_layouts_expanded/ages/tilesetCollisions39.bin"
.ends

.section expanded_tileset_mappings_3a SUPERFREE
tilesetMappings3a:
	.incbin "tileset_layouts_expanded/ages/tilesetMappings3a.bin"
	.incbin "tileset_layouts_expanded/ages/tilesetCollisions3a.bin"
.ends

.section expanded_tileset_mappings_3b SUPERFREE
tilesetMappings3b:
	.incbin "tileset_layouts_expanded/ages/tilesetMappings3b.bin"
	.incbin "tileset_layouts_expanded/ages/tilesetCollisions3b.bin"
.ends

.section expanded_tileset_mappings_3c SUPERFREE
tilesetMappings3c:
	.incbin "tileset_layouts_expanded/ages/tilesetMappings3c.bin"
	.incbin "tileset_layouts_expanded/ages/tilesetCollisions3c.bin"
.ends

.section expanded_tileset_mappings_3d SUPERFREE
tilesetMappings3d:
	.incbin "tileset_layouts_expanded/ages/tilesetMappings3d.bin"
	.incbin "tileset_layouts_expanded/ages/tilesetCollisions3d.bin"
.ends

.section expanded_tileset_mappings_3e SUPERFREE
tilesetMappings3e:
	.incbin "tileset_layouts_expanded/ages/tilesetMappings3e.bin"
	.incbin "tileset_layouts_expanded/ages/tilesetCollisions3e.bin"
.ends

.section expanded_tileset_mappings_3f SUPERFREE
tilesetMappings3f:
	.incbin "tileset_layouts_expanded/ages/tilesetMappings3f.bin"
	.incbin "tileset_layouts_expanded/ages/tilesetCollisions3f.bin"
.ends

.section expanded_tileset_mappings_40 SUPERFREE
tilesetMappings40:
	.incbin "tileset_layouts_expanded/ages/tilesetMappings40.bin"
	.incbin "tileset_layouts_expanded/ages/tilesetCollisions40.bin"
.ends

.section expanded_tileset_mappings_41 SUPERFREE
tilesetMappings41:
	.incbin "tileset_layouts_expanded/ages/tilesetMappings41.bin"
	.incbin "tileset_layouts_expanded/ages/tilesetCollisions41.bin"
.ends

.section expanded_tileset_mappings_42 SUPERFREE
tilesetMappings42:
	.incbin "tileset_layouts_expanded/ages/tilesetMappings42.bin"
	.incbin "tileset_layouts_expanded/ages/tilesetCollisions42.bin"
.ends

.section expanded_tileset_mappings_43 SUPERFREE
tilesetMappings43:
	.incbin "tileset_layouts_expanded/ages/tilesetMappings43.bin"
	.incbin "tileset_layouts_expanded/ages/tilesetCollisions43.bin"
.ends

.section expanded_tileset_mappings_44 SUPERFREE
tilesetMappings44:
	.incbin "tileset_layouts_expanded/ages/tilesetMappings44.bin"
	.incbin "tileset_layouts_expanded/ages/tilesetCollisions44.bin"
.ends

.section expanded_tileset_mappings_45 SUPERFREE
tilesetMappings45:
	.incbin "tileset_layouts_expanded/ages/tilesetMappings45.bin"
	.incbin "tileset_layouts_expanded/ages/tilesetCollisions45.bin"
.ends

.section expanded_tileset_mappings_46 SUPERFREE
tilesetMappings46:
	.incbin "tileset_layouts_expanded/ages/tilesetMappings46.bin"
	.incbin "tileset_layouts_expanded/ages/tilesetCollisions46.bin"
.ends

.section expanded_tileset_mappings_47 SUPERFREE
tilesetMappings47:
	.incbin "tileset_layouts_expanded/ages/tilesetMappings47.bin"
	.incbin "tileset_layouts_expanded/ages/tilesetCollisions47.bin"
.ends

.section expanded_tileset_mappings_48 SUPERFREE
tilesetMappings48:
	.incbin "tileset_layouts_expanded/ages/tilesetMappings48.bin"
	.incbin "tileset_layouts_expanded/ages/tilesetCollisions48.bin"
.ends

.section expanded_tileset_mappings_49 SUPERFREE
tilesetMappings49:
	.incbin "tileset_layouts_expanded/ages/tilesetMappings49.bin"
	.incbin "tileset_layouts_expanded/ages/tilesetCollisions49.bin"
.ends

.section expanded_tileset_mappings_4a SUPERFREE
tilesetMappings4a:
	.incbin "tileset_layouts_expanded/ages/tilesetMappings4a.bin"
	.incbin "tileset_layouts_expanded/ages/tilesetCollisions4a.bin"
.ends

.section expanded_tileset_mappings_4b SUPERFREE
tilesetMappings4b:
	.incbin "tileset_layouts_expanded/ages/tilesetMappings4b.bin"
	.incbin "tileset_layouts_expanded/ages/tilesetCollisions4b.bin"
.ends

.section expanded_tileset_mappings_4c SUPERFREE
tilesetMappings4c:
	.incbin "tileset_layouts_expanded/ages/tilesetMappings4c.bin"
	.incbin "tileset_layouts_expanded/ages/tilesetCollisions4c.bin"
.ends

.section expanded_tileset_mappings_4d SUPERFREE
tilesetMappings4d:
	.incbin "tileset_layouts_expanded/ages/tilesetMappings4d.bin"
	.incbin "tileset_layouts_expanded/ages/tilesetCollisions4d.bin"
.ends

.section expanded_tileset_mappings_4e SUPERFREE
tilesetMappings4e:
	.incbin "tileset_layouts_expanded/ages/tilesetMappings4e.bin"
	.incbin "tileset_layouts_expanded/ages/tilesetCollisions4e.bin"
.ends

.section expanded_tileset_mappings_4f SUPERFREE
tilesetMappings4f:
	.incbin "tileset_layouts_expanded/ages/tilesetMappings4f.bin"
	.incbin "tileset_layouts_expanded/ages/tilesetCollisions4f.bin"
.ends

.section expanded_tileset_mappings_50 SUPERFREE
tilesetMappings50:
	.incbin "tileset_layouts_expanded/ages/tilesetMappings50.bin"
	.incbin "tileset_layouts_expanded/ages/tilesetCollisions50.bin"
.ends

.section expanded_tileset_mappings_51 SUPERFREE
tilesetMappings51:
	.incbin "tileset_layouts_expanded/ages/tilesetMappings51.bin"
	.incbin "tileset_layouts_expanded/ages/tilesetCollisions51.bin"
.ends

.section expanded_tileset_mappings_52 SUPERFREE
tilesetMappings52:
	.incbin "tileset_layouts_expanded/ages/tilesetMappings52.bin"
	.incbin "tileset_layouts_expanded/ages/tilesetCollisions52.bin"
.ends

.section expanded_tileset_mappings_53 SUPERFREE
tilesetMappings53:
	.incbin "tileset_layouts_expanded/ages/tilesetMappings53.bin"
	.incbin "tileset_layouts_expanded/ages/tilesetCollisions53.bin"
.ends

.section expanded_tileset_mappings_54 SUPERFREE
tilesetMappings54:
	.incbin "tileset_layouts_expanded/ages/tilesetMappings54.bin"
	.incbin "tileset_layouts_expanded/ages/tilesetCollisions54.bin"
.ends

.section expanded_tileset_mappings_55 SUPERFREE
tilesetMappings55:
	.incbin "tileset_layouts_expanded/ages/tilesetMappings55.bin"
	.incbin "tileset_layouts_expanded/ages/tilesetCollisions55.bin"
.ends

.section expanded_tileset_mappings_56 SUPERFREE
tilesetMappings56:
	.incbin "tileset_layouts_expanded/ages/tilesetMappings56.bin"
	.incbin "tileset_layouts_expanded/ages/tilesetCollisions56.bin"
.ends

.section expanded_tileset_mappings_57 SUPERFREE
tilesetMappings57:
	.incbin "tileset_layouts_expanded/ages/tilesetMappings57.bin"
	.incbin "tileset_layouts_expanded/ages/tilesetCollisions57.bin"
.ends

.section expanded_tileset_mappings_58 SUPERFREE
tilesetMappings58:
	.incbin "tileset_layouts_expanded/ages/tilesetMappings58.bin"
	.incbin "tileset_layouts_expanded/ages/tilesetCollisions58.bin"
.ends

.section expanded_tileset_mappings_59 SUPERFREE
tilesetMappings59:
	.incbin "tileset_layouts_expanded/ages/tilesetMappings59.bin"
	.incbin "tileset_layouts_expanded/ages/tilesetCollisions59.bin"
.ends

.section expanded_tileset_mappings_5a SUPERFREE
tilesetMappings5a:
	.incbin "tileset_layouts_expanded/ages/tilesetMappings5a.bin"
	.incbin "tileset_layouts_expanded/ages/tilesetCollisions5a.bin"
.ends

.section expanded_tileset_mappings_5b SUPERFREE
tilesetMappings5b:
	.incbin "tileset_layouts_expanded/ages/tilesetMappings5b.bin"
	.incbin "tileset_layouts_expanded/ages/tilesetCollisions5b.bin"
.ends

.section expanded_tileset_mappings_5c SUPERFREE
tilesetMappings5c:
	.incbin "tileset_layouts_expanded/ages/tilesetMappings5c.bin"
	.incbin "tileset_layouts_expanded/ages/tilesetCollisions5c.bin"
.ends

.section expanded_tileset_mappings_5d SUPERFREE
tilesetMappings5d:
	.incbin "tileset_layouts_expanded/ages/tilesetMappings5d.bin"
	.incbin "tileset_layouts_expanded/ages/tilesetCollisions5d.bin"
.ends

.section expanded_tileset_mappings_5e SUPERFREE
tilesetMappings5e:
	.incbin "tileset_layouts_expanded/ages/tilesetMappings5e.bin"
	.incbin "tileset_layouts_expanded/ages/tilesetCollisions5e.bin"
.ends

.section expanded_tileset_mappings_5f SUPERFREE
tilesetMappings5f:
	.incbin "tileset_layouts_expanded/ages/tilesetMappings5f.bin"
	.incbin "tileset_layouts_expanded/ages/tilesetCollisions5f.bin"
.ends

.section expanded_tileset_mappings_60 SUPERFREE
tilesetMappings60:
	.incbin "tileset_layouts_expanded/ages/tilesetMappings60.bin"
	.incbin "tileset_layouts_expanded/ages/tilesetCollisions60.bin"
.ends

.section expanded_tileset_mappings_61 SUPERFREE
tilesetMappings61:
	.incbin "tileset_layouts_expanded/ages/tilesetMappings61.bin"
	.incbin "tileset_layouts_expanded/ages/tilesetCollisions61.bin"
.ends

.section expanded_tileset_mappings_62 SUPERFREE
tilesetMappings62:
	.incbin "tileset_layouts_expanded/ages/tilesetMappings62.bin"
	.incbin "tileset_layouts_expanded/ages/tilesetCollisions62.bin"
.ends

.section expanded_tileset_mappings_63 SUPERFREE
tilesetMappings63:
	.incbin "tileset_layouts_expanded/ages/tilesetMappings63.bin"
	.incbin "tileset_layouts_expanded/ages/tilesetCollisions63.bin"
.ends

.section expanded_tileset_mappings_64 SUPERFREE
tilesetMappings64:
	.incbin "tileset_layouts_expanded/ages/tilesetMappings64.bin"
	.incbin "tileset_layouts_expanded/ages/tilesetCollisions64.bin"
.ends

.section expanded_tileset_mappings_65 SUPERFREE
tilesetMappings65:
	.incbin "tileset_layouts_expanded/ages/tilesetMappings65.bin"
	.incbin "tileset_layouts_expanded/ages/tilesetCollisions65.bin"
.ends

.section expanded_tileset_mappings_66 SUPERFREE
tilesetMappings66:
	.incbin "tileset_layouts_expanded/ages/tilesetMappings66.bin"
	.incbin "tileset_layouts_expanded/ages/tilesetCollisions66.bin"
.ends

.section expanded_tileset_mappings_67 SUPERFREE
 tilesetMappings67:
	.incbin "tileset_layouts_expanded/ages/tilesetMappings67.bin"
	.incbin "tileset_layouts_expanded/ages/tilesetCollisions67.bin"
.ends

.section expanded_tileset_mappings_68 SUPERFREE
tilesetMappings68:
	.incbin "tileset_layouts_expanded/ages/tilesetMappings68.bin"
	.incbin "tileset_layouts_expanded/ages/tilesetCollisions68.bin"
.ends

.section expanded_tileset_mappings_69 SUPERFREE
tilesetMappings69:
	.incbin "tileset_layouts_expanded/ages/tilesetMappings69.bin"
	.incbin "tileset_layouts_expanded/ages/tilesetCollisions69.bin"
.ends

.section expanded_tileset_mappings_6a SUPERFREE
tilesetMappings6a:
	.incbin "tileset_layouts_expanded/ages/tilesetMappings6a.bin"
	.incbin "tileset_layouts_expanded/ages/tilesetCollisions6a.bin"
.ends

.section expanded_tileset_mappings_6b SUPERFREE
tilesetMappings6b:
	.incbin "tileset_layouts_expanded/ages/tilesetMappings6b.bin"
	.incbin "tileset_layouts_expanded/ages/tilesetCollisions6b.bin"
.ends

.section expanded_tileset_mappings_6c SUPERFREE
tilesetMappings6c:
	.incbin "tileset_layouts_expanded/ages/tilesetMappings6c.bin"
	.incbin "tileset_layouts_expanded/ages/tilesetCollisions6c.bin"
.ends

.section expanded_tileset_mappings_6d SUPERFREE
tilesetMappings6d:
	.incbin "tileset_layouts_expanded/ages/tilesetMappings6d.bin"
	.incbin "tileset_layouts_expanded/ages/tilesetCollisions6d.bin"
.ends

.section expanded_tileset_mappings_6e SUPERFREE
tilesetMappings6e:
	.incbin "tileset_layouts_expanded/ages/tilesetMappings6e.bin"
	.incbin "tileset_layouts_expanded/ages/tilesetCollisions6e.bin"
.ends

.section expanded_tileset_mappings_6f SUPERFREE
tilesetMappings6f:
	.incbin "tileset_layouts_expanded/ages/tilesetMappings6f.bin"
	.incbin "tileset_layouts_expanded/ages/tilesetCollisions6f.bin"
.ends

.section expanded_tileset_mappings_70 SUPERFREE
tilesetMappings70:
	.incbin "tileset_layouts_expanded/ages/tilesetMappings70.bin"
	.incbin "tileset_layouts_expanded/ages/tilesetCollisions70.bin"
.ends

.section expanded_tileset_mappings_71 SUPERFREE
tilesetMappings71:
	.incbin "tileset_layouts_expanded/ages/tilesetMappings71.bin"
	.incbin "tileset_layouts_expanded/ages/tilesetCollisions71.bin"
.ends

.section expanded_tileset_mappings_72 SUPERFREE
tilesetMappings72:
	.incbin "tileset_layouts_expanded/ages/tilesetMappings72.bin"
	.incbin "tileset_layouts_expanded/ages/tilesetCollisions72.bin"
.ends

.section expanded_tileset_mappings_73 SUPERFREE
tilesetMappings73:
	.incbin "tileset_layouts_expanded/ages/tilesetMappings73.bin"
	.incbin "tileset_layouts_expanded/ages/tilesetCollisions73.bin"
.ends

.section expanded_tileset_mappings_74 SUPERFREE
tilesetMappings74:
	.incbin "tileset_layouts_expanded/ages/tilesetMappings74.bin"
	.incbin "tileset_layouts_expanded/ages/tilesetCollisions74.bin"
.ends

.section expanded_tileset_mappings_75 SUPERFREE
tilesetMappings75:
	.incbin "tileset_layouts_expanded/ages/tilesetMappings75.bin"
	.incbin "tileset_layouts_expanded/ages/tilesetCollisions75.bin"
.ends

.section expanded_tileset_mappings_76 SUPERFREE
tilesetMappings76:
	.incbin "tileset_layouts_expanded/ages/tilesetMappings76.bin"
	.incbin "tileset_layouts_expanded/ages/tilesetCollisions76.bin"
.ends

.section expanded_tileset_mappings_77 SUPERFREE
tilesetMappings77:
	.incbin "tileset_layouts_expanded/ages/tilesetMappings77.bin"
	.incbin "tileset_layouts_expanded/ages/tilesetCollisions77.bin"
.ends

.section expanded_tileset_mappings_78 SUPERFREE
tilesetMappings78:
	.incbin "tileset_layouts_expanded/ages/tilesetMappings78.bin"
	.incbin "tileset_layouts_expanded/ages/tilesetCollisions78.bin"
.ends

.section expanded_tileset_mappings_79 SUPERFREE
tilesetMappings79:
	.incbin "tileset_layouts_expanded/ages/tilesetMappings79.bin"
	.incbin "tileset_layouts_expanded/ages/tilesetCollisions79.bin"
.ends

.section expanded_tileset_mappings_7a SUPERFREE
tilesetMappings7a:
	.incbin "tileset_layouts_expanded/ages/tilesetMappings7a.bin"
	.incbin "tileset_layouts_expanded/ages/tilesetCollisions7a.bin"
.ends

.section expanded_tileset_mappings_7b SUPERFREE
tilesetMappings7b:
	.incbin "tileset_layouts_expanded/ages/tilesetMappings7b.bin"
	.incbin "tileset_layouts_expanded/ages/tilesetCollisions7b.bin"
.ends

.section expanded_tileset_mappings_7c SUPERFREE
tilesetMappings7c:
	.incbin "tileset_layouts_expanded/ages/tilesetMappings7c.bin"
	.incbin "tileset_layouts_expanded/ages/tilesetCollisions7c.bin"
.ends

.section expanded_tileset_mappings_7d SUPERFREE
tilesetMappings7d:
	.incbin "tileset_layouts_expanded/ages/tilesetMappings7d.bin"
	.incbin "tileset_layouts_expanded/ages/tilesetCollisions7d.bin"
.ends

.section expanded_tileset_mappings_7e SUPERFREE
tilesetMappings7e:
	.incbin "tileset_layouts_expanded/ages/tilesetMappings7e.bin"
	.incbin "tileset_layouts_expanded/ages/tilesetCollisions7e.bin"
.ends

.section expanded_tileset_mappings_7f SUPERFREE
tilesetMappings7f:
	.incbin "tileset_layouts_expanded/ages/tilesetMappings7f.bin"
	.incbin "tileset_layouts_expanded/ages/tilesetCollisions7f.bin"
.ends
