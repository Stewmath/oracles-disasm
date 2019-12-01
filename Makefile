# If this is true, certain precompressed assets will be used from the
# "precompressed" folder, and sections will be marked with "FORCE" instead of
# "FREE" or "SUPERFREE". This is all to make sure the rom builds as an exact
# copy of the original game.
BUILD_VANILLA = true

SHELL := /bin/bash

CC = wla-gb
LD = wlalink
PYTHON = python2

ifeq ($(BUILD_VANILLA), true)

CFLAGS += -DBUILD_VANILLA

endif

TOPDIR = $(CURDIR)

DOCFILES =

# defines for wla-gb
DEFINES =

ifdef FORCE_SECTIONS
	DEFINES += -D FORCE_SECTIONS
endif
ifdef ROM_SEASONS
	DEFINES += -D ROM_SEASONS -D FORCE_SECTIONS # TODO: remove force_sections later
	GAME = seasons
	TEXT_INSERT_ADDRESS = 0x71c00
else # ROM_AGES
	DEFINES += -D ROM_AGES
	GAME = ages
	TEXT_INSERT_ADDRESS = 0x74000
endif

CFLAGS += $(DEFINES)

PRECMP_FILE = build/use_precompressed
NO_PRECMP_FILE = build/no_use_precompressed

ifeq ($(BUILD_VANILLA), true)
CMP_MODE = $(PRECMP_FILE)
else
CMP_MODE = $(NO_PRECMP_FILE)
endif


OBJS = build/$(GAME).o build/audio.o

GFXFILES = $(wildcard gfx/*.bin)
GFXFILES += $(wildcard gfx/$(GAME)/*.bin)
GFXFILES += $(wildcard gfx_compressible/*.bin)
GFXFILES += $(wildcard gfx_compressible/$(GAME)/*.bin)
GFXFILES := $(GFXFILES:.bin=.cmp)
GFXFILES := $(foreach file,$(GFXFILES),build/gfx/$(notdir $(file)))

ROOMLAYOUTFILES = $(wildcard rooms/$(GAME)/small/*.bin)
ROOMLAYOUTFILES += $(wildcard rooms/$(GAME)/large/*.bin)
ROOMLAYOUTFILES := $(ROOMLAYOUTFILES:.bin=.cmp)
ROOMLAYOUTFILES := $(foreach file,$(ROOMLAYOUTFILES),build/rooms/$(notdir $(file)))

COLLISIONFILES = $(wildcard tilesets/$(GAME)/tilesetCollisions*.bin)
COLLISIONFILES := $(COLLISIONFILES:.bin=.cmp)
COLLISIONFILES := $(foreach file,$(COLLISIONFILES),build/tilesets/$(notdir $(file)))

MAPPINGINDICESFILES = $(wildcard tilesets/$(GAME)/tilesetMappings*.bin)
MAPPINGINDICESFILES := $(foreach file,$(MAPPINGINDICESFILES),build/tilesets/$(notdir $(file)))
MAPPINGINDICESFILES := $(MAPPINGINDICESFILES:.bin=Indices.cmp)

# Game-specific data files
GAMEDATAFILES = $(wildcard data/$(GAME)/*.s)
GAMEDATAFILES := $(foreach file,$(GAMEDATAFILES),build/data/$(notdir $(file)))


ifneq ($(BUILD_VANILLA),true)

OPTIMIZE := -o

endif


.PRECIOUS: build/%.o
.PHONY: all ages seasons clean run force


all:
	@$(MAKE) --no-print-directory ages
	@$(MAKE) --no-print-directory seasons

ages:
	@echo '=====Ages====='
	@if [[ -L build ]]; then rm build; fi
	@if [[ -e build ]]; then echo "The 'build' folder is not a symlink; please delete it."; false; fi
	@if [[ ! -d build_ages ]]; then mkdir build_ages; fi
	@ln -s build_ages build
	@ROM_AGES=1 $(MAKE) ages.gbc

seasons:
	@echo '===Seasons==='
	@if [[ -L build ]]; then rm build; fi
	@if [[ -e build ]]; then echo "The 'build' folder is not a symlink; please delete it."; false; fi
	@if [[ ! -d build_seasons ]]; then mkdir build_seasons; fi
	@ln -s build_seasons build
	@ROM_SEASONS=1 $(MAKE) seasons.gbc


$(GAME).gbc: $(OBJS) build/linkfile
	$(LD) -S build/linkfile $@

ifeq ($(BUILD_VANILLA),true)
	@-md5sum -c $(GAME).md5
endif

$(MAPPINGINDICESFILES): build/tilesets/mappingsDictionary.bin
$(COLLISIONFILES): build/tilesets/collisionsDictionary.bin

build/$(GAME).o: $(GFXFILES) $(ROOMLAYOUTFILES) $(COLLISIONFILES) $(MAPPINGINDICESFILES) $(GAMEDATAFILES)
build/$(GAME).o: build/textData.s build/textDefines.s
build/$(GAME).o: code/*.s code/items/*.s code/$(GAME)/*.s data/*.s objects/*.s objects/$(GAME)/*.s scripts/$(GAME)/*.s
build/$(GAME).o: build/tilesets/tileMappingTable.bin build/tilesets/tileMappingIndexData.bin build/tilesets/tileMappingAttributeData.bin
build/$(GAME).o: rooms/$(GAME)/*.bin

build/audio.o: audio/$(GAME)/*.s audio/$(GAME)/*.bin
build/*.o: include/*.s constants/*.s Makefile

build/$(GAME).o: $(GAME).s Makefile | build
	$(CC) -o $@ $(CFLAGS) $<

build/%.o: code/%.s | build
	$(CC) -o $@ $(CFLAGS) $<

build/linkfile: $(OBJS)
	@echo "[objects]" > $@
	@echo "$(OBJS)" | sed 's/ /\n/g' >> $@

build/rooms/%.cmp: rooms/$(GAME)/small/%.bin $(CMP_MODE) | build/rooms
	@echo "Compressing $< to $@..."
	@$(PYTHON) tools/compressRoomLayout.py $< $@ $(OPTIMIZE)

# Uncompressed graphics (from either game)
build/gfx/%.cmp: gfx/%.bin | build/gfx
	@echo "Copying $< to $@..."
	@dd if=/dev/zero bs=1 count=1 of=$@ 2>/dev/null
	@cat $< >> $@

# Uncompressed graphics (from a particular game)
build/gfx/%.cmp: gfx/$(GAME)/%.bin | build/gfx
	@echo "Copying $< to $@..."
	@dd if=/dev/zero bs=1 count=1 of=$@ 2>/dev/null
	@cat $< >> $@

build/tilesets/collisionsDictionary.bin: precompressed/tilesets/$(GAME)/collisionsDictionary.bin | build/tilesets
	@echo "Copying $< to $@..."
	@cp $< $@

# Data folder: copied from game-specific directory into a constant directory, so that the
# game's code knows where to look
build/data/%.s: data/$(GAME)/%.s | build/data
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

build/tilesets/%.bin: precompressed/tilesets/$(GAME)/%.bin $(CMP_MODE) | build/tilesets
	@echo "Copying $< to $@..."
	@cp $< $@
build/tilesets/%.cmp: precompressed/tilesets/$(GAME)/%.cmp $(CMP_MODE) | build/tilesets
	@echo "Copying $< to $@..."
	@cp $< $@

build/rooms/room%.cmp: precompressed/$(GAME)/rooms/room%.cmp $(CMP_MODE) | build/rooms
	@echo "Copying $< to $@..."
	@cp $< $@

# Precompressed graphics (from either game)
build/gfx/%.cmp: precompressed/gfx_compressible/%.cmp $(CMP_MODE) | build/gfx
	@echo "Copying $< to $@..."
	@cp $< $@

# Precompressed graphics (from a particular game)
build/gfx/%.cmp: precompressed/gfx_compressible/$(GAME)/%.cmp $(CMP_MODE) | build/gfx
	@echo "Copying $< to $@..."
	@cp $< $@

build/textData.s: precompressed/$(GAME)/textData.s $(CMP_MODE) | build
	@echo "Copying $< to $@..."
	@cp $< $@

build/textDefines.s: precompressed/$(GAME)/textDefines.s $(CMP_MODE) | build
	@echo "Copying $< to $@..."
	@cp $< $@

else

# The parseTilesets script generates all of these files.
# They need dummy rules in their recipes to convince make that they've been changed?
$(MAPPINGINDICESFILES:.cmp=.bin): build/tilesets/mappingsUpdated
	@sleep 0
build/tilesets/mappingsDictionary.bin: build/tilesets/mappingsUpdated
	@sleep 0
build/tilesets/tileMappingTable.bin: build/tilesets/mappingsUpdated
	@sleep 0
build/tilesets/tileMappingIndexData.bin: build/tilesets/mappingsUpdated
	@sleep 0
build/tilesets/tileMappingAttributeData.bin: build/tilesets/mappingsUpdated
	@sleep 0

# mappingsUpdated is a stub file which is just used as a timestamp from the
# last time parseTilesets was run.
build/tilesets/mappingsUpdated: $(wildcard tilesets/$(GAME)/tilesetMappings*.bin) $(CMP_MODE) | build/tilesets
	@echo "Compressing tileset mappings..."
	@$(PYTHON) tools/parseTilesets.py $(GAME)
	@echo "Done compressing tileset mappings."
	@touch $@

build/tilesets/tilesetMappings%Indices.cmp: build/tilesets/tilesetMappings%Indices.bin build/tilesets/mappingsDictionary.bin $(CMP_MODE) | build/tilesets
	@echo "Compressing $< to $@..."
	@$(PYTHON) tools/compressTilesetData.py $< $@ 1 build/tilesets/mappingsDictionary.bin

build/tilesets/tilesetCollisions%.cmp: tilesets/$(GAME)/tilesetCollisions%.bin build/tilesets/collisionsDictionary.bin $(CMP_MODE) | build/tilesets
	@echo "Compressing $< to $@..."
	@$(PYTHON) tools/compressTilesetData.py $< $@ 0 build/tilesets/collisionsDictionary.bin

build/rooms/room04%.cmp: rooms/$(GAME)/large/room04%.bin $(CMP_MODE) | build/rooms
	@echo "Compressing $< to $@..."
	@$(PYTHON) tools/compressRoomLayout.py $< $@ -d rooms/$(GAME)/dictionary4.bin
build/rooms/room05%.cmp: rooms/$(GAME)/large/room05%.bin $(CMP_MODE) | build/rooms
	@echo "Compressing $< to $@..."
	@$(PYTHON) tools/compressRoomLayout.py $< $@ -d rooms/$(GAME)/dictionary5.bin
build/rooms/room06%.cmp: rooms/$(GAME)/large/room06%.bin $(CMP_MODE) | build/rooms
	@echo "Compressing $< to $@..."
	@$(PYTHON) tools/compressRoomLayout.py $< $@ -d rooms/$(GAME)/dictionary6.bin

# Compress graphics (from either game)
build/gfx/%.cmp: gfx_compressible/%.bin $(CMP_MODE) | build/gfx
	@echo "Compressing $< to $@..."
	@$(PYTHON) tools/compressGfx.py $< $@

# Compress graphics (from a particular game)
build/gfx/%.cmp: gfx_compressible/$(GAME)/%.bin $(CMP_MODE) | build/gfx
	@echo "Compressing $< to $@..."
	@$(PYTHON) tools/compressGfx.py $< $@

build/textData.s: text/$(GAME)/text.txt text/$(GAME)/dict.txt tools/parseText.py $(CMP_MODE) | build
	@echo "Compressing text..."
	@$(PYTHON) tools/parseText.py text/$(GAME)/dict.txt $< $@ $$(($(TEXT_INSERT_ADDRESS))) $$((0x2c))

build/textDefines.s: build/textData.s

endif


build/data: | build
	mkdir build/data
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

clean:
	-rm -R build_ages/ build_seasons/ doc/ ages.gbc seasons.gbc

run: ages
	$(GBEMU) ages.gbc 2>/dev/null

# --------------------------------------------------------------
# Documentation generation
# --------------------------------------------------------------

doc: $(DOCFILES) | build/doc
	doxygen

build/%-s.c: %.s | build/doc
	cd build/doc/; $(TOPDIR)/tools/asm4doxy.pl -ns ../../$<
