# If this is true, certain precompressed assets will be used from the
# "precompressed" folder, and sections will be marked with "FORCE" instead of
# "FREE" or "SUPERFREE". This is all to make sure the rom builds as an exact
# copy of the original game.
BUILD_VANILLA = true

# Sets the default target. Can be "ages", "seasons", or "all" (both).
.DEFAULT_GOAL = all

SHELL := /bin/bash

CC = wla-gb
LD = wlalink
PYTHON = python3

TOPDIR = $(CURDIR)

DOCFILES =

# defines for wla-gb
DEFINES =
CFLAGS =

ifeq ($(BUILD_VANILLA), true)
	DEFINES += -D BUILD_VANILLA
endif

ifeq ($(BUILD_VANILLA), true)
	AGES_BUILD_DIR = build_ages_v
	SEASONS_BUILD_DIR = build_seasons_v
else
	AGES_BUILD_DIR = build_ages_e
	SEASONS_BUILD_DIR = build_seasons_e
endif

ifdef FORCE_SECTIONS
	DEFINES += -D FORCE_SECTIONS
endif

ifdef ROM_SEASONS
	DEFINES += -D ROM_SEASONS
	GAME = seasons
	OTHERGAME = ages
	TEXT_INSERT_ADDRESS = 0x71c00
	BUILD_DIR = $(SEASONS_BUILD_DIR)
else # ROM_AGES
	DEFINES += -D ROM_AGES
	GAME = ages
	OTHERGAME = seasons
	TEXT_INSERT_ADDRESS = 0x74000
	BUILD_DIR = $(AGES_BUILD_DIR)
endif

DEFINES += -D BUILD_DIR="$(BUILD_DIR)/"
CFLAGS += $(DEFINES)


OBJS = $(BUILD_DIR)/$(GAME).o $(BUILD_DIR)/audio.o


BIN_GFX_FILES  = $(shell find gfx/ gfx_compressible/ -name '*.bin' | grep -v '/$(OTHERGAME)/')
PNG_GFX_FILES  = $(shell find gfx/ gfx_compressible/ -name '*.png' | grep -v '/$(OTHERGAME)/')

UNCMP_GFX_FILES  = $(shell find gfx/              -name '*.bin' -or -name '*.png' | grep -v '/$(OTHERGAME)/')
CMP_GFX_FILES    = $(shell find gfx_compressible/ -name '*.bin' -or -name '*.png' | grep -v '/$(OTHERGAME)/')
PRECMP_GFX_FILES = $(shell find precompressed/gfx_compressible/ -name '*.cmp' -or -name '*.png' | grep -v '/$(OTHERGAME)/')

GFXFILES := $(foreach file,$(CMP_GFX_FILES) $(UNCMP_GFX_FILES),$(BUILD_DIR)/gfx/$(notdir $(file)))
GFXFILES := $(foreach file,$(GFXFILES),$(basename $(file)).cmp)

ROOMLAYOUTFILES = $(wildcard rooms/$(GAME)/small/*.bin)
ROOMLAYOUTFILES += $(wildcard rooms/$(GAME)/large/*.bin)
ROOMLAYOUTFILES := $(ROOMLAYOUTFILES:.bin=.cmp)
ROOMLAYOUTFILES := $(foreach file,$(ROOMLAYOUTFILES),$(BUILD_DIR)/rooms/$(notdir $(file)))

COLLISIONFILES = $(wildcard tileset_layouts/$(GAME)/tilesetCollisions*.bin)
COLLISIONFILES := $(COLLISIONFILES:.bin=.cmp)
COLLISIONFILES := $(foreach file,$(COLLISIONFILES),$(BUILD_DIR)/tileset_layouts/$(notdir $(file)))

MAPPINGINDICESFILES = $(wildcard tileset_layouts/$(GAME)/tilesetMappings*.bin)
MAPPINGINDICESFILES := $(foreach file,$(MAPPINGINDICESFILES),$(BUILD_DIR)/tileset_layouts/$(notdir $(file)))
MAPPINGINDICESFILES := $(MAPPINGINDICESFILES:.bin=Indices.cmp)

# Common data files (for both games)
COMMONDATAFILES = $(shell find data/ -name '*.s' | grep -v '/ages/\|/seasons/')

# Game-specific data files
GAMEDATAFILES = $(wildcard data/$(GAME)/*.s)

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
	@ROM_AGES=1 $(MAKE) ages.gbc

seasons:
	@echo '===Seasons==='
	@ROM_SEASONS=1 $(MAKE) seasons.gbc


$(GAME).gbc: $(OBJS) $(BUILD_DIR)/linkfile
	$(LD) -S $(BUILD_DIR)/linkfile $@
	@-tools/build/verify-checksum.sh $(GAME)

$(BUILD_DIR)/linkfile: linkfile_$(GAME)
	sed 's/BUILD_DIR/${BUILD_DIR}/' $< > $@

$(MAPPINGINDICESFILES): $(BUILD_DIR)/tileset_layouts/mappingsDictionary.bin
$(COLLISIONFILES): $(BUILD_DIR)/tileset_layouts/collisionsDictionary.bin

$(BUILD_DIR)/$(GAME).o: $(MAIN_ASM_FILES)
$(BUILD_DIR)/$(GAME).o: $(GFXFILES) $(ROOMLAYOUTFILES) $(COLLISIONFILES) $(MAPPINGINDICESFILES) $(COMMONDATAFILES) $(GAMEDATAFILES)
$(BUILD_DIR)/$(GAME).o: $(BUILD_DIR)/tileset_layouts/tileMappingTable.bin $(BUILD_DIR)/tileset_layouts/tileMappingIndexData.bin $(BUILD_DIR)/tileset_layouts/tileMappingAttributeData.bin
$(BUILD_DIR)/$(GAME).o: rooms/$(GAME)/*.bin

$(BUILD_DIR)/audio.o: $(AUDIO_FILES)
$(BUILD_DIR)/*.o: $(COMMON_INCLUDE_FILES) Makefile

$(BUILD_DIR)/$(GAME).o: $(GAME).s $(BUILD_DIR)/textData.s $(BUILD_DIR)/textDefines.s Makefile | $(BUILD_DIR)
	$(CC) -o $@ $(CFLAGS) $<

$(BUILD_DIR)/%.o: code/%.s | $(BUILD_DIR)
	$(CC) -o $@ $(CFLAGS) $<

$(BUILD_DIR)/rooms/%.cmp: rooms/$(GAME)/small/%.bin | $(BUILD_DIR)/rooms
	@echo "Compressing $< to $@..."
	@$(PYTHON) tools/build/compressRoomLayout.py $< $@ $(OPTIMIZE)

$(BUILD_DIR)/tileset_layouts/collisionsDictionary.bin: precompressed/tileset_layouts/$(GAME)/collisionsDictionary.bin | $(BUILD_DIR)/tileset_layouts
	@echo "Copying $< to $@..."
	@cp $< $@



# GFX rules
# ================================================================================

# I'm using defines and 'eval'ing them due to difficulties constructing rules when the source
# graphics file could be in any number of locations. Kind of ugly, but it works.


# Rule for copying GFX files to $(BUILD_DIR)/gfx directory
define define_copy_gfx_rules
$(BUILD_DIR)/gfx/$(notdir $(1)): $(1) | $(BUILD_DIR)/gfx
	@cp $$< $$@
	@echo "Copying $$< to $(BUILD_DIR)/gfx/..."
endef

# Rule for conversion of .PNG files to .BIN files
define define_png_gfx_rules
$(BUILD_DIR)/gfx/$(basename $(notdir $(1))).bin: $(1) $(wildcard $(basename $(1)).properties) | $(BUILD_DIR)/gfx
	@echo "Converting $$<..."
	@$$(PYTHON) tools/gfx/gfx.py --out $$@ auto $$<
endef

# Rule for handling uncompressible files
define define_uncmp_gfx_rules
$(BUILD_DIR)/gfx/$(basename $(notdir $(1))).cmp: $(BUILD_DIR)/gfx/$(basename $(notdir $(1))).bin
	@dd if=/dev/zero bs=1 count=1 of=$$@ 2>/dev/null
	@cat $$< >> $$@
endef

# Rule for handling compressible files
define define_cmp_gfx_rules
$(BUILD_DIR)/gfx/$(basename $(notdir $(1))).cmp: $(BUILD_DIR)/gfx/$(basename $(notdir $(1))).bin
	@echo "Compressing $$<..."
	@$$(PYTHON) tools/build/compressGfx.py $$< $$@
endef

# Define the gfx rules for the specific files which need them
$(foreach filename,$(BIN_GFX_FILES),  $(eval $(call define_copy_gfx_rules,$(filename))))
$(foreach filename,$(PNG_GFX_FILES),  $(eval $(call define_png_gfx_rules,$(filename))))
$(foreach filename,$(UNCMP_GFX_FILES),$(eval $(call define_uncmp_gfx_rules,$(filename))))

ifeq ($(BUILD_VANILLA),true)

# Copy precompressed gfx files to $(BUILD_DIR)/gfx
$(foreach filename,$(PRECMP_GFX_FILES),$(eval $(call define_copy_gfx_rules,$(filename))))

else

# Define rules for compression of these files
$(foreach filename,$(CMP_GFX_FILES),$(eval $(call define_cmp_gfx_rules,$(filename))))

endif


# ================================================================================


ifeq ($(BUILD_VANILLA),true)

$(BUILD_DIR)/tileset_layouts/%.bin: precompressed/tileset_layouts/$(GAME)/%.bin | $(BUILD_DIR)/tileset_layouts
	@echo "Copying $< to $@..."
	@cp $< $@
$(BUILD_DIR)/tileset_layouts/%.cmp: precompressed/tileset_layouts/$(GAME)/%.cmp | $(BUILD_DIR)/tileset_layouts
	@echo "Copying $< to $@..."
	@cp $< $@

$(BUILD_DIR)/rooms/room%.cmp: precompressed/rooms/$(GAME)/room%.cmp | $(BUILD_DIR)/rooms
	@echo "Copying $< to $@..."
	@cp $< $@

$(BUILD_DIR)/textData.s: precompressed/text/$(GAME)/textData.s | $(BUILD_DIR)
	@echo "Copying $< to $@..."
	@cp $< $@

$(BUILD_DIR)/textDefines.s: precompressed/text/$(GAME)/textDefines.s | $(BUILD_DIR)
	@echo "Copying $< to $@..."
	@cp $< $@

else

# The parseTilesetLayouts script generates all of these files.
# They need dummy rules in their recipes to convince make that they've been changed?
$(MAPPINGINDICESFILES:.cmp=.bin): $(BUILD_DIR)/tileset_layouts/mappingsUpdated
	@sleep 0
$(BUILD_DIR)/tileset_layouts/mappingsDictionary.bin: $(BUILD_DIR)/tileset_layouts/mappingsUpdated
	@sleep 0
$(BUILD_DIR)/tileset_layouts/tileMappingTable.bin: $(BUILD_DIR)/tileset_layouts/mappingsUpdated
	@sleep 0
$(BUILD_DIR)/tileset_layouts/tileMappingIndexData.bin: $(BUILD_DIR)/tileset_layouts/mappingsUpdated
	@sleep 0
$(BUILD_DIR)/tileset_layouts/tileMappingAttributeData.bin: $(BUILD_DIR)/tileset_layouts/mappingsUpdated
	@sleep 0

# mappingsUpdated is a stub file which is just used as a timestamp from the
# last time parseTilesetLayouts was run.
$(BUILD_DIR)/tileset_layouts/mappingsUpdated: $(wildcard tileset_layouts/$(GAME)/tilesetMappings*.bin) | $(BUILD_DIR)/tileset_layouts
	@echo "Compressing tileset mappings..."
	@$(PYTHON) tools/build/parseTilesetLayouts.py $(GAME) $(BUILD_DIR)
	@echo "Done compressing tileset mappings."
	@touch $@

$(BUILD_DIR)/tileset_layouts/tilesetMappings%Indices.cmp: $(BUILD_DIR)/tileset_layouts/tilesetMappings%Indices.bin $(BUILD_DIR)/tileset_layouts/mappingsDictionary.bin | $(BUILD_DIR)/tileset_layouts
	@echo "Compressing $< to $@..."
	@$(PYTHON) tools/build/compressTilesetLayoutData.py $< $@ 1 $(BUILD_DIR)/tileset_layouts/mappingsDictionary.bin

$(BUILD_DIR)/tileset_layouts/tilesetCollisions%.cmp: tileset_layouts/$(GAME)/tilesetCollisions%.bin $(BUILD_DIR)/tileset_layouts/collisionsDictionary.bin | $(BUILD_DIR)/tileset_layouts
	@echo "Compressing $< to $@..."
	@$(PYTHON) tools/build/compressTilesetLayoutData.py $< $@ 0 $(BUILD_DIR)/tileset_layouts/collisionsDictionary.bin

$(BUILD_DIR)/rooms/room04%.cmp: rooms/$(GAME)/large/room04%.bin | $(BUILD_DIR)/rooms
	@echo "Compressing $< to $@..."
	@$(PYTHON) tools/build/compressRoomLayout.py $< $@ -d rooms/$(GAME)/dictionary4.bin
$(BUILD_DIR)/rooms/room05%.cmp: rooms/$(GAME)/large/room05%.bin | $(BUILD_DIR)/rooms
	@echo "Compressing $< to $@..."
	@$(PYTHON) tools/build/compressRoomLayout.py $< $@ -d rooms/$(GAME)/dictionary5.bin
$(BUILD_DIR)/rooms/room06%.cmp: rooms/$(GAME)/large/room06%.bin | $(BUILD_DIR)/rooms
	@echo "Compressing $< to $@..."
	@$(PYTHON) tools/build/compressRoomLayout.py $< $@ -d rooms/$(GAME)/dictionary6.bin

# Parse & compress text
$(BUILD_DIR)/textData.s: text/$(GAME)/text.yaml text/$(GAME)/dict.yaml tools/build/parseText.py | $(BUILD_DIR)
	@echo "Compressing text..."
	@$(PYTHON) tools/build/parseText.py text/$(GAME)/dict.yaml $< $@ $$(($(TEXT_INSERT_ADDRESS)))

$(BUILD_DIR)/textDefines.s: $(BUILD_DIR)/textData.s

endif


$(BUILD_DIR)/gfx: | $(BUILD_DIR)
	mkdir $(BUILD_DIR)/gfx
$(BUILD_DIR)/rooms: | $(BUILD_DIR)
	mkdir $(BUILD_DIR)/rooms
$(BUILD_DIR)/debug: | $(BUILD_DIR)
	mkdir $(BUILD_DIR)/debug
$(BUILD_DIR)/tileset_layouts: | $(BUILD_DIR)
	mkdir $(BUILD_DIR)/tileset_layouts
$(BUILD_DIR)/doc: | $(BUILD_DIR)
	mkdir $(BUILD_DIR)/doc
$(BUILD_DIR):
	mkdir $(BUILD_DIR)

clean:
	-rm -R build build_ages_v/ build_ages_e/ build_seasons_v/ build_seasons_e/ doc/ \
		ages.gbc ages.sym seasons.gbc seasons.sym

run: ages
	$(GBEMU) ages.gbc 2>/dev/null

# --------------------------------------------------------------
# Documentation generation
# --------------------------------------------------------------

doc: $(DOCFILES) | $(BUILD_DIR)/doc
	doxygen

$(BUILD_DIR)/%-s.c: %.s | $(BUILD_DIR)/doc
	cd $(BUILD_DIR)/doc/; $(TOPDIR)/tools/build/asm4doxy.pl -ns ../../$<


# --------------------------------------------------------------------------------
# Testing graphics encoding: ensure that pngs are encoded correctly.
# --------------------------------------------------------------------------------

test-gfx:
	@$(PYTHON) tools/gfx/gfx.py auto gfx_compressible/common/*.png gfx_compressible/ages/*.png gfx_compressible/seasons/*.png
	@echo "Running diff against gfx files in 'test/gfx_compressible_encoded'..."
	@for f in $$(cd gfx_compressible; find -name 'gfx_*.bin' -or -name 'spr_*.bin'); do \
		diff gfx_compressible/$$f test/gfx_compressible_encoded/$$f; \
	done
