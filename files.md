# tilesets/tilesetMappings\*.bin

Data which is somewhat abstracted for convenience; each 8 bytes define the
tiles and attributes for each metatile. That is, a metatile is made up of
4 sub-tiles, each with a particular index and attribute value.

# build/tilesets/tileMappingIndexData.bin

Part of the compression of tileset/tilesetMappings\*.bin.

# build/tilesets/tileMappingAttributeData.bin

Part of the compression of tileset/tilesetMappings\*.bin.

# build/tilesets/tileMappingTable.bin

Part of the compression of tileset/tilesetMappings\*.bin.

# build/tilesets/tilesetMappings\*Indices.bin

Part of the compression of tileset/tilesetMappings\*.bin.

# build/tilesets/tilesetMappings\*Indices.cmp

Same as above but compressed with compressTilesetData.py.

# tilesets/tilesetCollisions\*.bin

Each byte defines the collision property of a tile. Not as abstracted as
tilesetMappings.

# build/tilesets/tilesetCollisions\*.cmp

Same as above but compressed with compressTilesetData.py.
