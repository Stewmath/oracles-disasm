# If this is true, certain precompressed assets will be used from the
# "precompressed" folder, and sections will be marked with "FORCE" instead of
# "FREE" or "SUPERFREE". This is all to make sure the rom builds as an exact
# copy of the original game.
BUILD_VANILLA = false

# Sets the default target. Can be "ages", "seasons", or "all" (both).
.DEFAULT_GOAL = all

SHELL := /bin/bash

CC = wla-gb
LD = wlalink
PYTHON = python3

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
	DEFINES += -D ROM_SEASONS
	GAME = seasons
	OTHERGAME = ages
	TEXT_INSERT_ADDRESS = 0x71c00
else # ROM_AGES
	DEFINES += -D ROM_AGES
	GAME = ages
	OTHERGAME = seasons
	TEXT_INSERT_ADDRESS = 0x74000
endif

CFLAGS += $(DEFINES)

ifeq ($(BUILD_VANILLA), true)
AGES_BUILD_DIR = build_ages_v
SEASONS_BUILD_DIR = build_seasons_v
else
AGES_BUILD_DIR = build_ages_e
SEASONS_BUILD_DIR = build_seasons_e
endif


OBJS = build/$(GAME).o build/audio.o


BIN_GFX_FILES  = $(shell find gfx/ gfx_compressible/ -name '*.bin' | grep -v '/$(OTHERGAME)/')
PNG_GFX_FILES  = $(shell find gfx/ gfx_compressible/ -name '*.png' | grep -v '/$(OTHERGAME)/')

UNCMP_GFX_FILES  = $(shell find gfx/              -name '*.bin' -or -name '*.png' | grep -v '/$(OTHERGAME)/')
CMP_GFX_FILES    = $(shell find gfx_compressible/ -name '*.bin' -or -name '*.png' | grep -v '/$(OTHERGAME)/')
PRECMP_GFX_FILES = $(shell find precompressed/gfx_compressible/ -name '*.cmp' -or -name '*.png' | grep -v '/$(OTHERGAME)/')

GFXFILES := $(foreach file,$(CMP_GFX_FILES) $(UNCMP_GFX_FILES),build/gfx/$(notdir $(file)))
GFXFILES := $(foreach file,$(GFXFILES),$(basename $(file)).cmp)

ROOMLAYOUTFILES = $(wildcard rooms/$(GAME)/small/*.bin)
ROOMLAYOUTFILES += $(wildcard rooms/$(GAME)/large/*.bin)
ROOMLAYOUTFILES := $(ROOMLAYOUTFILES:.bin=.cmp)
ROOMLAYOUTFILES := $(foreach file,$(ROOMLAYOUTFILES),build/rooms/$(notdir $(file)))

COLLISIONFILES = $(wildcard tileset_layouts/$(GAME)/tilesetCollisions*.bin)
COLLISIONFILES := $(COLLISIONFILES:.bin=.cmp)
COLLISIONFILES := $(foreach file,$(COLLISIONFILES),build/tileset_layouts/$(notdir $(file)))

MAPPINGINDICESFILES = $(wildcard tileset_layouts/$(GAME)/tilesetMappings*.bin)
MAPPINGINDICESFILES := $(foreach file,$(MAPPINGINDICESFILES),build/tileset_layouts/$(notdir $(file)))
MAPPINGINDICESFILES := $(MAPPINGINDICESFILES:.bin=Indices.cmp)

# Common data files (for both games)
COMMONDATAFILES = $(shell find data/ -name '*.s' | grep -v '/ages/\|/seasons/')

# Game-specific data files
GAMEDATAFILES = $(wildcard data/$(GAME)/*.s)
GAMEDATAFILES := $(foreach file,$(GAMEDATAFILES),build/data/$(notdir $(file)))

MAIN_ASM_FILES = $(shell find code/ object_code/ objects/ scripts/ -name '*.s' | grep -v '/$(OTHERGAME)/')
AUDIO_FILES = $(shell find audio/ -name '*.s' -o -name '*.bin' | grep -v '/$(OTHERGAME)/')
COMMON_INCLUDE_FILES = $(shell find constants/ include/ -name '*.s' | grep -v '/$(OTHERGAME)/')


ifneq ($(BUILD_VANILLA),true)

OPTIMIZE := -o

endif


# Removal of temporary files is annoying, disable it.
.PRECIOUS:

.PHONY: all ages seasons clean run force test-gfx


all:
	@$(MAKE) --no-print-directory ages
	@$(MAKE) --no-print-directory seasons

ages:
	@echo '=====Ages====='
	@if [[ -L build ]]; then rm build; fi
	@if [[ -e build ]]; then echo "The 'build' folder is not a symlink; please delete it."; false; fi
	@if [[ ! -d $(AGES_BUILD_DIR) ]]; then mkdir $(AGES_BUILD_DIR); fi
	@ln -s $(AGES_BUILD_DIR) build
	@ROM_AGES=1 $(MAKE) ages.gbc

seasons:
	@echo '===Seasons==='
	@if [[ -L build ]]; then rm build; fi
	@if [[ -e build ]]; then echo "The 'build' folder is not a symlink; please delete it."; false; fi
	@if [[ ! -d $(SEASONS_BUILD_DIR) ]]; then mkdir $(SEASONS_BUILD_DIR); fi
	@ln -s $(SEASONS_BUILD_DIR) build
	@ROM_SEASONS=1 $(MAKE) seasons.gbc


$(GAME).gbc: $(OBJS) linkfile_$(GAME)
	$(LD) -S linkfile_$(GAME) $@
	@-tools/build/verify-checksum.sh $(GAME)


$(MAPPINGINDICESFILES): build/tileset_layouts/mappingsDictionary.bin
$(COLLISIONFILES): build/tileset_layouts/collisionsDictionary.bin

build/$(GAME).o: $(MAIN_ASM_FILES)
build/$(GAME).o: $(GFXFILES) $(ROOMLAYOUTFILES) $(COLLISIONFILES) $(MAPPINGINDICESFILES) $(COMMONDATAFILES) $(GAMEDATAFILES)
build/$(GAME).o: build/tileset_layouts/tileMappingTable.bin build/tileset_layouts/tileMappingIndexData.bin build/tileset_layouts/tileMappingAttributeData.bin
build/$(GAME).o: rooms/$(GAME)/*.bin

build/audio.o: $(AUDIO_FILES)
build/*.o: $(COMMON_INCLUDE_FILES) Makefile

build/$(GAME).o: $(GAME).s build/textData.s build/textDefines.s Makefile | build
	$(CC) -o $@ $(CFLAGS) $<

build/%.o: code/%.s | build
	$(CC) -o $@ $(CFLAGS) $<

build/rooms/%.cmp: rooms/$(GAME)/small/%.bin | build/rooms
	@echo "Compressing $< to $@..."
	@$(PYTHON) tools/build/compressRoomLayout.py $< $@ $(OPTIMIZE)

build/tileset_layouts/collisionsDictionary.bin: precompressed/tileset_layouts/$(GAME)/collisionsDictionary.bin | build/tileset_layouts
	@echo "Copying $< to $@..."
	@cp $< $@

# Data folder: copied from game-specific directory into a constant directory, so that the
# game's code knows where to look
build/data/%.s: data/$(GAME)/%.s | build/data
	@echo "Copying $< to $@..."
	@cp $< $@



# GFX rules
# ================================================================================

# I'm using defines and 'eval'ing them due to difficulties constructing rules when the source
# graphics file could be in any number of locations. Kind of ugly, but it works.


# Rule for copying GFX files to build/gfx directory
define define_copy_gfx_rules
build/gfx/$(notdir $(1)): $(1) | build/gfx
	@cp $$< $$@
	@echo "Copying $$< to build/gfx/..."
endef

# Rule for conversion of .PNG files to .BIN files
define define_png_gfx_rules
build/gfx/$(basename $(notdir $(1))).bin: $(1) $(wildcard $(basename $(1)).properties) | build/gfx
	@echo "Converting $$<..."
	@$$(PYTHON) tools/gfx/gfx.py --out $$@ auto $$<
endef

# Rule for handling uncompressible files
define define_uncmp_gfx_rules
build/gfx/$(basename $(notdir $(1))).cmp: build/gfx/$(basename $(notdir $(1))).bin
	@dd if=/dev/zero bs=1 count=1 of=$$@ 2>/dev/null
	@cat $$< >> $$@
endef

# Rule for handling compressible files
define define_cmp_gfx_rules
build/gfx/$(basename $(notdir $(1))).cmp: build/gfx/$(basename $(notdir $(1))).bin
	@echo "Compressing $$<..."
	@$$(PYTHON) tools/build/compressGfx.py $$< $$@
endef

# Define the gfx rules for the specific files which need them
$(foreach filename,$(BIN_GFX_FILES),  $(eval $(call define_copy_gfx_rules,$(filename))))
$(foreach filename,$(PNG_GFX_FILES),  $(eval $(call define_png_gfx_rules,$(filename))))
$(foreach filename,$(UNCMP_GFX_FILES),$(eval $(call define_uncmp_gfx_rules,$(filename))))

ifeq ($(BUILD_VANILLA),true)

# Copy precompressed gfx files to build/gfx
$(foreach filename,$(PRECMP_GFX_FILES),$(eval $(call define_copy_gfx_rules,$(filename))))

else

# Define rules for compression of these files
$(foreach filename,$(CMP_GFX_FILES),$(eval $(call define_cmp_gfx_rules,$(filename))))

endif


# ================================================================================


ifeq ($(BUILD_VANILLA),true)

build/tileset_layouts/%.bin: precompressed/tileset_layouts/$(GAME)/%.bin | build/tileset_layouts
	@echo "Copying $< to $@..."
	@cp $< $@
build/tileset_layouts/%.cmp: precompressed/tileset_layouts/$(GAME)/%.cmp | build/tileset_layouts
	@echo "Copying $< to $@..."
	@cp $< $@

build/rooms/room%.cmp: precompressed/rooms/$(GAME)/room%.cmp | build/rooms
	@echo "Copying $< to $@..."
	@cp $< $@

build/textData.s: precompressed/text/$(GAME)/textData.s | build
	@echo "Copying $< to $@..."
	@cp $< $@

build/textDefines.s: precompressed/text/$(GAME)/textDefines.s | build
	@echo "Copying $< to $@..."
	@cp $< $@

else

# The parseTilesetLayouts script generates all of these files.
# They need dummy rules in their recipes to convince make that they've been changed?
$(MAPPINGINDICESFILES:.cmp=.bin): build/tileset_layouts/mappingsUpdated
	@sleep 0
build/tileset_layouts/mappingsDictionary.bin: build/tileset_layouts/mappingsUpdated
	@sleep 0
build/tileset_layouts/tileMappingTable.bin: build/tileset_layouts/mappingsUpdated
	@sleep 0
build/tileset_layouts/tileMappingIndexData.bin: build/tileset_layouts/mappingsUpdated
	@sleep 0
build/tileset_layouts/tileMappingAttributeData.bin: build/tileset_layouts/mappingsUpdated
	@sleep 0

# mappingsUpdated is a stub file which is just used as a timestamp from the
# last time parseTilesetLayouts was run.
build/tileset_layouts/mappingsUpdated: $(wildcard tileset_layouts/$(GAME)/tilesetMappings*.bin) | build/tileset_layouts
	@echo "Compressing tileset mappings..."
	@$(PYTHON) tools/build/parseTilesetLayouts.py $(GAME)
	@echo "Done compressing tileset mappings."
	@touch $@

build/tileset_layouts/tilesetMappings%Indices.cmp: build/tileset_layouts/tilesetMappings%Indices.bin build/tileset_layouts/mappingsDictionary.bin | build/tileset_layouts
	@echo "Compressing $< to $@..."
	@$(PYTHON) tools/build/compressTilesetLayoutData.py $< $@ 1 build/tileset_layouts/mappingsDictionary.bin

build/tileset_layouts/tilesetCollisions%.cmp: tileset_layouts/$(GAME)/tilesetCollisions%.bin build/tileset_layouts/collisionsDictionary.bin | build/tileset_layouts
	@echo "Compressing $< to $@..."
	@$(PYTHON) tools/build/compressTilesetLayoutData.py $< $@ 0 build/tileset_layouts/collisionsDictionary.bin

build/rooms/room04%.cmp: rooms/$(GAME)/large/room04%.bin | build/rooms
	@echo "Compressing $< to $@..."
	@$(PYTHON) tools/build/compressRoomLayout.py $< $@ -d rooms/$(GAME)/dictionary4.bin
build/rooms/room05%.cmp: rooms/$(GAME)/large/room05%.bin | build/rooms
	@echo "Compressing $< to $@..."
	@$(PYTHON) tools/build/compressRoomLayout.py $< $@ -d rooms/$(GAME)/dictionary5.bin
build/rooms/room06%.cmp: rooms/$(GAME)/large/room06%.bin | build/rooms
	@echo "Compressing $< to $@..."
	@$(PYTHON) tools/build/compressRoomLayout.py $< $@ -d rooms/$(GAME)/dictionary6.bin

# Parse & compress text
build/textData.s: text/$(GAME)/text.yaml text/$(GAME)/dict.yaml tools/build/parseText.py | build
	@echo "Compressing text..."
	@$(PYTHON) tools/build/parseText.py text/$(GAME)/dict.yaml $< $@ $$(($(TEXT_INSERT_ADDRESS)))

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
build/tileset_layouts: | build
	mkdir build/tileset_layouts
build/doc: | build
	mkdir build/doc

clean:
	-rm -R build_ages_v/ build_ages_e/ build_seasons_v/ build_seasons_e/ doc/ ages.gbc seasons.gbc

run: ages
	$(GBEMU) ages.gbc 2>/dev/null

# --------------------------------------------------------------
# Documentation generation
# --------------------------------------------------------------

doc: $(DOCFILES) | build/doc
	doxygen

build/%-s.c: %.s | build/doc
	cd build/doc/; $(TOPDIR)/tools/build/asm4doxy.pl -ns ../../$<


# --------------------------------------------------------------------------------
# Testing graphics encoding: ensure that pngs are encoded correctly.
# --------------------------------------------------------------------------------

test-gfx:
	@$(PYTHON) tools/gfx/gfx.py auto gfx_compressible/common/*.png gfx_compressible/ages/*.png gfx_compressible/seasons/*.png
	@echo "Running diff against gfx files in 'test/gfx_compressible_encoded'..."
	@for f in $$(cd gfx_compressible; find -name 'gfx_*.bin' -or -name 'spr_*.bin'); do \
		diff gfx_compressible/$$f test/gfx_compressible_encoded/$$f; \
	done
