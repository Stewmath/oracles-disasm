# If true, compressed graphics will be read from the gfx_precompressed folder.
# Also, text will use the 'textData_precompressed.s' file instead of using the text.txt file.
# Set to anything but true if you want to modify text or anything in the gfx_compressible folder.
# You may need to "make clean" after modifying this.
USE_PRECOMPRESSED_ASSETS = true

OBJS = build/main.o

TARGET = rom.gbc
SYMFILE = $(TARGET:.gbc=.sym)

GFXFILES = $(wildcard gfx/*.bin)
GFXFILES += $(wildcard gfx_compressible/*.bin)
GFXFILES := $(GFXFILES:.bin=.cmp)
GFXFILES := $(foreach file,$(GFXFILES),build/gfx/$(notdir $(file)))

ROOMLAYOUTFILES = $(wildcard maps/small/*.bin)
ROOMLAYOUTFILES += $(wildcard maps/large/*.bin)
ROOMLAYOUTFILES := $(ROOMLAYOUTFILES:.bin=.cmp)
ROOMLAYOUTFILES := $(foreach file,$(ROOMLAYOUTFILES),build/maps/$(notdir $(file)))

COLLISIONFILES = $(wildcard tilesets/tilesetCollisions*.bin)
COLLISIONFILES := $(COLLISIONFILES:.bin=.cmp)
COLLISIONFILES := $(foreach file,$(COLLISIONFILES),build/tilesets/$(notdir $(file)))

MAPPINGINDICESFILES = $(wildcard tilesets/tilesetMappings*.bin)
MAPPINGINDICESFILES := $(foreach file,$(MAPPINGINDICESFILES),build/tilesets/$(notdir $(file)))
MAPPINGINDICESFILES := $(MAPPINGINDICESFILES:.bin=Indices.cmp)


ifneq ($(USE_PRECOMPRESSED_ASSETS),true)

OPTIMIZE := -o

endif

all: $(TARGET)

$(TARGET): $(OBJS) linkfile
	wlalink -s linkfile rom.gbc
	@sed -i 's/^00//' $(SYMFILE)
	rgbfix -Cjv -t "ZELDA NAYRUAZ8E" -k 01 -l 0x33 -m 0x1b -r 0x02 rom.gbc
ifeq ($(USE_PRECOMPRESSED_ASSETS),true)
	@md5sum -c ages.md5
endif

build/main.o: $(GFXFILES) $(ROOMLAYOUTFILES) $(COLLISIONFILES) $(MAPPINGINDICESFILES) build/textData.s
build/main.o: constants/*.s data/*.s include/*.s interactions/*.s music/*.bin
build/main.o: build/tilesets/tileMappingTable.bin build/tilesets/tileMappingIndexData.bin build/tilesets/tileMappingAttributeData.bin
build/main.o: maps/group*Areas.bin

$(MAPPINGINDICESFILES): build/tilesets/mappingsDictionary.bin
$(COLLISIONFILES): build/tilesets/collisionsDictionary.bin


build/%.o: %.s | build
	@echo "Building $@..."
	@wla-gb -o $< && mv $(basename $<).o $@
	
linkfile: $(OBJS)
	@echo "[objects]" > linkfile
	@echo "$(OBJS)" | sed 's/ /\n/g' >> linkfile

build/maps/%.cmp: maps/small/%.bin | build
	@echo "Compressing $< to $@..."
	@python2 tools/compressRoomLayout.py $< $@ $(OPTIMIZE)

build/gfx/%.cmp: gfx/%.bin | build
	@echo "Copying $< to $@..."
	@dd if=/dev/zero bs=1 count=1 of=$@ 2>/dev/null
	@cat $< >> $@

build/tilesets/collisionsDictionary.bin: precompressed/tilesets/collisionsDictionary.bin | build
	@echo "Copying $< to $@..."
	@cp $< $@

ifeq ($(USE_PRECOMPRESSED_ASSETS),true)

build/tilesets/%.bin: precompressed/tilesets/%.bin | build
	@echo "Copying $< to $@..."
	@cp $< $@
build/tilesets/%.cmp: precompressed/tilesets/%.cmp | build
	@echo "Copying $< to $@..."
	@cp $< $@

build/maps/room%.cmp: precompressed/maps/room%.cmp | build
	@echo "Copying $< to $@..."
	@cp $< $@

build/gfx/%.cmp: precompressed/gfx_compressible/%.cmp | build
	@echo "Copying $< to $@..."
	@cp $< $@

build/textData.s: precompressed/textData_precompressed.s | build
	@echo "Copying $< to $@..."
	@cp $< $@

else

# The parseTilesets script generates all of these files
$(MAPPINGINDICESFILES:.cmp=.bin): build/tilesets/mappingsUpdated
build/tilesets/mappingsDictionary.bin: build/tilesets/mappingsUpdated
build/tilesets/tileMappingTable.bin: build/tilesets/mappingsUpdated
build/tilesets/tileMappingIndexData.bin: build/tilesets/mappingsUpdated
build/tilesets/tileMappingAttributeData.bin: build/tilesets/mappingsUpdated

# mappingsUpdated is a stub file which is just used as a timestamp from the
# last time parseTilesets was run.
build/tilesets/mappingsUpdated: $(wildcard tilesets/tilesetMappings*.bin)
	@echo "Compressing tileset mappings..."
	@python2 tools/parseTilesets.py
	@touch $@

build/tilesets/tilesetMappings%Indices.cmp: build/tilesets/tilesetMappings%Indices.bin  build/tilesets/mappingsDictionary.bin
	@echo "Compressing $< to $@..."
	@python2 tools/compressTilesetData.py $< $@ 1 build/tilesets/mappingsDictionary.bin
build/tilesets/tilesetCollisions%.cmp: tilesets/tilesetCollisions%.bin
	@echo "Compressing $< to $@..."
	@python2 tools/compressTilesetData.py $< $@ 0 build/tilesets/collisionsDictionary.bin

build/maps/room04%.cmp: maps/large/room04%.bin | build
	@echo "Compressing $< to $@..."
	@python2 tools/compressRoomLayout.py $< $@ -d maps/dictionary4.bin
build/maps/room05%.cmp: maps/large/room05%.bin | build
	@echo "Compressing $< to $@..."
	@python2 tools/compressRoomLayout.py $< $@ -d maps/dictionary5.bin

build/gfx/%.cmp: gfx_compressible/%.bin | build
	@echo "Compressing $< to $@..."
	@python2 tools/compressGfx.py $< $@

build/textData.s: text/text.txt | build
	@echo "Compressing text..."
	@python2 tools/parseText.py $< $@ $$((0x74000)) $$((0x2c))

endif


build:
	mkdir -p build/gfx/
	mkdir build/maps
	mkdir build/debug
	mkdir build/tilesets


.PHONY: clean run force

force:
	touch main.s
	make

clean:
	rm -R build/ $(TARGET)

run:
	$(GBEMU) $(TARGET) 2>/dev/null
