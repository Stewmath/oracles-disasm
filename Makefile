# If this is true, certain precompressed assets will be used from the
# "precompressed" folder, and sections will be marked with "FORCE" instead of
# "FREE" or "SUPERFREE". This is all to make sure the rom builds as an exact
# copy of the original game.
BUILD_VANILLA = true

CC = wla-gb
LD = wlalink
PYTHON = python2

ifeq ($(BUILD_VANILLA), true)

CFLAGS += -DBUILD_VANILLA

endif

TOPDIR = $(CURDIR)

OBJS = build/main.o
DOCFILES = $(OBJS:.o=-s.c)

TARGET = rom.gbc
SYMFILE = $(TARGET:.gbc=.sym)

# defines for wla-gb
DEFINES =

ifdef FORCE_SECTIONS
DEFINES += -D FORCE_SECTIONS
endif

CFLAGS += $(DEFINES)

PRECMP_FILE = build/use_precompressed
NO_PRECMP_FILE = build/no_use_precompressed

ifeq ($(BUILD_VANILLA), true)
CMP_MODE = $(PRECMP_FILE)
else
CMP_MODE = $(NO_PRECMP_FILE)
endif

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
	$(LD) -S linkfile $@

ifeq ($(BUILD_VANILLA),true)
	@-md5sum -c ages.md5
endif

build/main.o: $(GFXFILES) $(ROOMLAYOUTFILES) $(COLLISIONFILES) $(MAPPINGINDICESFILES) build/textData.s build/textDefines.s
build/main.o: code/*.s constants/*.s data/*.s include/*.s objects/*.s scripts/*.s audio/*.s audio/*.bin
build/main.o: build/tilesets/tileMappingTable.bin build/tilesets/tileMappingIndexData.bin build/tilesets/tileMappingAttributeData.bin
build/main.o: rooms/*.bin

$(MAPPINGINDICESFILES): build/tilesets/mappingsDictionary.bin
$(COLLISIONFILES): build/tilesets/collisionsDictionary.bin


build/%.o: %.s | build
	$(CC) -o $@ $(CFLAGS) $<
	
linkfile: $(OBJS)
	@echo "[objects]" > linkfile
	@echo "$(OBJS)" | sed 's/ /\n/g' >> linkfile

build/rooms/%.cmp: rooms/small/%.bin $(CMP_MODE) | build/rooms
	@echo "Compressing $< to $@..."
	@$(PYTHON) tools/compressRoomLayout.py $< $@ $(OPTIMIZE)

build/gfx/%.cmp: gfx/%.bin | build/gfx
	@echo "Copying $< to $@..."
	@dd if=/dev/zero bs=1 count=1 of=$@ 2>/dev/null
	@cat $< >> $@

build/tilesets/collisionsDictionary.bin: precompressed/tilesets/collisionsDictionary.bin | build/tilesets
	@echo "Copying $< to $@..."
	@cp $< $@


# Build mode management: for when you switch between precompressed & modifiable 
# modes

$(PRECMP_FILE): | build
	@[[ ! -f $(NO_PRECMP_FILE) ]] || (\
		echo "ERROR: the current 'build' directory does not use precompressed data, but the Makefile does. Please run fixbuild.sh." && \
		false )
	touch $@

$(NO_PRECMP_FILE): | build
	@[[ ! -f $(PRECMP_FILE) ]] || (\
		echo "ERROR: the current 'build' directory uses precompressed data, but the Makefile does not. Please run fixbuild.sh." && \
		false )
	touch $@


ifeq ($(BUILD_VANILLA),true)

build/tilesets/%.bin: precompressed/tilesets/%.bin $(CMP_MODE) | build/tilesets
	@echo "Copying $< to $@..."
	@cp $< $@
build/tilesets/%.cmp: precompressed/tilesets/%.cmp $(CMP_MODE) | build/tilesets
	@echo "Copying $< to $@..."
	@cp $< $@

build/rooms/room%.cmp: precompressed/rooms/room%.cmp $(CMP_MODE) | build/rooms
	@echo "Copying $< to $@..."
	@cp $< $@

build/gfx/%.cmp: precompressed/gfx_compressible/%.cmp $(CMP_MODE) | build/gfx
	@echo "Copying $< to $@..."
	@cp $< $@

build/textData.s: precompressed/textData.s $(CMP_MODE) | build
	@echo "Copying $< to $@..."
	@cp $< $@

build/textDefines.s: precompressed/textDefines.s $(CMP_MODE) | build
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
build/tilesets/mappingsUpdated: $(wildcard tilesets/tilesetMappings*.bin) $(CMP_MODE) | build/tilesets
	@echo "Compressing tileset mappings..."
	@$(PYTHON) tools/parseTilesets.py
	@touch $@

build/tilesets/tilesetMappings%Indices.cmp: build/tilesets/tilesetMappings%Indices.bin build/tilesets/mappingsDictionary.bin $(CMP_MODE) | build/tilesets
	@echo "Compressing $< to $@..."
	@$(PYTHON) tools/compressTilesetData.py $< $@ 1 build/tilesets/mappingsDictionary.bin
build/tilesets/tilesetCollisions%.cmp: tilesets/tilesetCollisions%.bin $(CMP_MODE) | build/tilesets
	@echo "Compressing $< to $@..."
	@$(PYTHON) tools/compressTilesetData.py $< $@ 0 build/tilesets/collisionsDictionary.bin

build/rooms/room04%.cmp: rooms/large/room04%.bin $(CMP_MODE) | build/rooms
	@echo "Compressing $< to $@..."
	@$(PYTHON) tools/compressRoomLayout.py $< $@ -d rooms/dictionary4.bin
build/rooms/room05%.cmp: rooms/large/room05%.bin $(CMP_MODE) | build/rooms
	@echo "Compressing $< to $@..."
	@$(PYTHON) tools/compressRoomLayout.py $< $@ -d rooms/dictionary5.bin

build/gfx/%.cmp: gfx_compressible/%.bin $(CMP_MODE) | build/gfx
	@echo "Compressing $< to $@..."
	@$(PYTHON) tools/compressGfx.py $< $@

build/textData.s: text/text.txt text/dict.txt tools/parseText.py $(CMP_MODE) | build
	@echo "Compressing text..."
	@$(PYTHON) tools/parseText.py text/dict.txt $< $@ $$((0x74000)) $$((0x2c))

build/textDefines.s: build/textData.s

endif


build:
	mkdir build
build/gfx: | build
	mkdir build/gfx
build/rooms: | build
	mkdir build/rooms
build/debug: | build
	mkdir build/debug
build/tilesets: | build
	mkdir build/tilesets
build/doc: | build
	mkdir build/doc


.PHONY: clean run force

force:
	$(MAKE) build/main.o --always-make
	$(MAKE)

clean:
	-rm -R build/ doc/ $(TARGET)

run: all
	$(GBEMU) $(TARGET) 2>/dev/null

# --------------------------------------------------------------
# Documentation generation
# --------------------------------------------------------------

doc: $(DOCFILES) | build/doc
	doxygen

build/%-s.c: %.s | build/doc
	cd build/doc/; $(TOPDIR)/tools/asm4doxy.pl -ns ../../$<
