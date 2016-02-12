# If this is true, certain precompressed assets will be used from the
# "precompressed" folder, and sections will be marked with "FORCE" instead of
# "FREE" or "SUPERFREE". This is all to make sure the rom builds as an exact
# copy of the original game.
BUILD_VANILLA = false

CC = wla-gb
LD = wlalink

ifeq ($(BUILD_VANILLA), true)

CFLAGS += -DBUILD_VANILLA

endif

TOPDIR = $(CURDIR)

OBJS = build/main.o
DOCFILES = $(OBJS:.o=-s.c)

TARGET = rom.gbc
SYMFILE = $(TARGET:.gbc=.sym)

GFXFILES = $(wildcard gfx/*.bin)
GFXFILES += $(wildcard gfx_compressible/*.bin)
GFXFILES := $(GFXFILES:.bin=.cmp)
GFXFILES := $(foreach file,$(GFXFILES),build/gfx/$(notdir $(file)))

ROOMLAYOUTFILES = $(wildcard rooms/small/*.bin)
ROOMLAYOUTFILES += $(wildcard rooms/large/*.bin)
ROOMLAYOUTFILES := $(ROOMLAYOUTFILES:.bin=.cmp)
ROOMLAYOUTFILES := $(foreach file,$(ROOMLAYOUTFILES),build/rooms/$(notdir $(file)))

COLLISIONFILES = $(wildcard tilesets/tilesetCollisions*.bin)
COLLISIONFILES := $(COLLISIONFILES:.bin=.cmp)
COLLISIONFILES := $(foreach file,$(COLLISIONFILES),build/tilesets/$(notdir $(file)))

MAPPINGINDICESFILES = $(wildcard tilesets/tilesetMappings*.bin)
MAPPINGINDICESFILES := $(foreach file,$(MAPPINGINDICESFILES),build/tilesets/$(notdir $(file)))
MAPPINGINDICESFILES := $(MAPPINGINDICESFILES:.bin=Indices.cmp)

ifneq ($(BUILD_VANILLA),true)

OPTIMIZE := -o

endif


all: $(TARGET)

$(TARGET): $(OBJS) linkfile
	$(LD) -S linkfile rom.gbc
	rgbfix -Cjv -t "ZELDA NAYRUAZ8E" -k 01 -l 0x33 -m 0x1b -r 0x02 rom.gbc

# Fix the symbol file so that it's readable by bgb (not just no$gmb)
	@sed -i 's/^00//' $(SYMFILE)

ifeq ($(BUILD_VANILLA),true)
	@-md5sum -c ages.md5
endif

build/main.o: $(GFXFILES) $(ROOMLAYOUTFILES) $(COLLISIONFILES) $(MAPPINGINDICESFILES) build/textData.s build/textDefines.s
build/main.o: constants/*.s data/*.s include/*.s interactions/*.s scripts/*.s audio/*.s audio/*.bin
build/main.o: build/tilesets/tileMappingTable.bin build/tilesets/tileMappingIndexData.bin build/tilesets/tileMappingAttributeData.bin
build/main.o: rooms/group*Areas.bin

$(MAPPINGINDICESFILES): build/tilesets/mappingsDictionary.bin
$(COLLISIONFILES): build/tilesets/collisionsDictionary.bin


build/%.o: %.s | build
	@echo "Running $< through wlaParseLocalLabels.py..."
	@python2 tools/wlaParseLocalLabels.py $< build/$<
	@echo "Building $@..."
	@$(CC) -o $(CFLAGS) build/$< $@
	
linkfile: $(OBJS)
	@echo "[objects]" > linkfile
	@echo "$(OBJS)" | sed 's/ /\n/g' >> linkfile

build/rooms/%.cmp: rooms/small/%.bin | build
	@echo "Compressing $< to $@..."
	@python2 tools/compressRoomLayout.py $< $@ $(OPTIMIZE)

build/gfx/%.cmp: gfx/%.bin | build
	@echo "Copying $< to $@..."
	@dd if=/dev/zero bs=1 count=1 of=$@ 2>/dev/null
	@cat $< >> $@

build/tilesets/collisionsDictionary.bin: precompressed/tilesets/collisionsDictionary.bin | build
	@echo "Copying $< to $@..."
	@cp $< $@

ifeq ($(BUILD_VANILLA),true)

build/tilesets/%.bin: precompressed/tilesets/%.bin | build
	@echo "Copying $< to $@..."
	@cp $< $@
build/tilesets/%.cmp: precompressed/tilesets/%.cmp | build
	@echo "Copying $< to $@..."
	@cp $< $@

build/rooms/room%.cmp: precompressed/rooms/room%.cmp | build
	@echo "Copying $< to $@..."
	@cp $< $@

build/gfx/%.cmp: precompressed/gfx_compressible/%.cmp | build
	@echo "Copying $< to $@..."
	@cp $< $@

build/textData.s: precompressed/textData.s | build
	@echo "Copying $< to $@..."
	@cp $< $@

build/textDefines.s: precompressed/textDefines.s | build
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

build/rooms/room04%.cmp: rooms/large/room04%.bin | build
	@echo "Compressing $< to $@..."
	@python2 tools/compressRoomLayout.py $< $@ -d rooms/dictionary4.bin
build/rooms/room05%.cmp: rooms/large/room05%.bin | build
	@echo "Compressing $< to $@..."
	@python2 tools/compressRoomLayout.py $< $@ -d rooms/dictionary5.bin

build/gfx/%.cmp: gfx_compressible/%.bin | build
	@echo "Compressing $< to $@..."
	@python2 tools/compressGfx.py $< $@

build/textData.s: text/text.txt | build
	@echo "Compressing text..."
	@python2 tools/parseText.py $< $@ $$((0x74000)) $$((0x2c))

endif


build:
	mkdir -p build/gfx/
	mkdir build/rooms
	mkdir build/debug
	mkdir build/tilesets
	mkdir build/doc


.PHONY: clean run force

force:
	touch main.s
	make

clean:
	-rm -R build/ doc/ $(TARGET)

run: all
	$(GBEMU) $(TARGET) 2>/dev/null

# --------------------------------------------------------------
# Documentation generation
# --------------------------------------------------------------

doc: $(DOCFILES)
	doxygen

build/%-s.c: %.s | build
	cd build/doc/; $(TOPDIR)/tools/asm4doxy.pl -ns ../../$<
