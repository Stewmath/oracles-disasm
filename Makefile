# If BUILD_VANILLA is true, certain precompressed assets will be used from the
# "precompressed" folder, and sections will be marked with "FORCE" instead of
# "FREE" or "SUPERFREE". This is all to make sure the rom builds as an exact
# copy of the original game.
#
# The build folder also changes when this variable changes, to ensure the
# makefile doesn't get confused due to the different assets being loaded. (Also
# saves tons of time if you switch between branches a lot.)
BUILD_VANILLA = true

# ANSI color codes
BOLD=\033[1;37m
RED=\033[1;31m
BLUE=\033[1;34m
NC=\033[0m

# Sets the default target. Can be "ages", "seasons", or "all" (both).
.DEFAULT_GOAL = all

SHELL := /bin/bash

CC = wla-gb
LD = wlalink
PYTHON = python3

TOPDIR = $(CURDIR)

# Default to parallel build to make things much faster
ifeq (,$(findstring -j,$(MAKEFLAGS)))
CPUS ?= $(shell nproc)
MAKEFLAGS += -j $(CPUS)
$(info Note: using $(CPUS) threads by default, use -j flag to override.)
endif

# Reduce noise from make output
MAKEFLAGS += --no-print-directory


# Removal of temporary files is annoying, disable it.
.PRECIOUS:

# Disable builtin rules for a modest speedup
.SUFFIXES:

# Rules which don't correspond to filenames
.PHONY: all ages seasons clean test-gfx


all:
	@$(MAKE) ages
	@$(MAKE) seasons

ages:
	@echo -e "$(BOLD)====================$(NC)"
	@echo -e "$(BOLD)Building $(BLUE)Ages$(BOLD)...$(NC)"
	@echo -e "$(BOLD)====================$(NC)"
	@ROM_AGES=1 $(MAKE) $@.gbc

seasons:
	@echo -e "$(BOLD)====================$(NC)"
	@echo -e "$(BOLD)Building $(RED)Seasons$(BOLD)...$(NC)"
	@echo -e "$(BOLD)====================$(NC)"
	@ROM_SEASONS=1 $(MAKE) $@.gbc


# Skip the majority of this makefile if we haven't specified the game yet.
# One of ROM_AGES or ROM_SEASONS must be defined for the below stuff to make any
# sense.
ifneq ($(filter 1, $(ROM_AGES) $(ROM_SEASONS)),)

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
	GAME_DEFINE = ROM_SEASONS
	GAME = seasons
	OTHERGAME = ages
	TEXT_INSERT_ADDRESS = 0x71c00
	BUILD_DIR = $(SEASONS_BUILD_DIR)
	GAME_COLOR = $(RED)
else # ROM_AGES
	GAME_DEFINE = ROM_AGES
	GAME = ages
	OTHERGAME = seasons
	TEXT_INSERT_ADDRESS = 0x74000
	BUILD_DIR = $(AGES_BUILD_DIR)
	GAME_COLOR = $(BLUE)
endif

DEFINES += -D $(GAME_DEFINE) -D BUILD_DIR="$(BUILD_DIR)/"
CFLAGS += $(DEFINES)

# Locations for gfx files: uncompressible, compressible, and precompressed
GFX_UNCMP_DIR = 'gfx'
GFX_CMP_DIR = 'gfx_compressible'
GFX_PRECMP_DIR = 'precompressed/gfx_compressible'


OBJS = $(BUILD_DIR)/$(GAME).o $(BUILD_DIR)/audio.o


# All .bin gfx files
BIN_GFX_FILES  = $(shell find $(GFX_UNCMP_DIR)/common  $(GFX_CMP_DIR)/common \
                              $(GFX_UNCMP_DIR)/$(GAME) $(GFX_CMP_DIR)/$(GAME) -name '*.bin')

# All .png gfx files
PNG_GFX_FILES  = $(shell find $(GFX_UNCMP_DIR)/common  $(GFX_CMP_DIR)/common \
                              $(GFX_UNCMP_DIR)/$(GAME) $(GFX_CMP_DIR)/$(GAME) -name '*.png')

# All .bin & .png gfx files by category (uncompressible, compressible, precompressed)
UNCMP_GFX_FILES  = $(shell find $(GFX_UNCMP_DIR)/common $(GFX_UNCMP_DIR)/$(GAME) \
                     -name '*.bin' -or -name '*.png')
CMP_GFX_FILES    = $(shell find $(GFX_CMP_DIR)/common $(GFX_CMP_DIR)/$(GAME) \
                     -name '*.bin' -or -name '*.png')
PRECMP_GFX_FILES = $(shell find $(GFX_PRECMP_DIR)/common $(GFX_PRECMP_DIR)/$(GAME) -name '*.cmp')

# List of all gfx files in their final form, ie. $(BUILD_DIR)/gfx/spr_link.cmp
GFXFILES := $(foreach file, $(CMP_GFX_FILES) $(UNCMP_GFX_FILES), \
              $(BUILD_DIR)/gfx/$(basename $(notdir $(file))).cmp)

# List of gfx files from the last build.
OLD_GFXFILES := $(wildcard $(BUILD_DIR)/gfx/*.cmp)

# gfx files with no corresponding source file: these must be deleted.
# If they're not deleted then they could cause builds to succeed while depending
# on files that can no longer be properly generated.
# This could happen with other types of files but gfx files are the biggest
# concern.
ORPHANED_GFXFILES := $(filter-out '', $(foreach oldfile, $(OLD_GFXFILES), \
              $(if $(findstring $(oldfile), $(GFXFILES)), '', $(oldfile))))

# Delete the orphaned files
ifneq ($(ORPHANED_GFXFILES),)
$(shell rm $(ORPHANED_GFXFILES))
endif

ROOMLAYOUTFILES = $(wildcard rooms/$(GAME)/small/*.bin)
ROOMLAYOUTFILES += $(wildcard rooms/$(GAME)/large/*.bin)
ROOMLAYOUTFILES := $(ROOMLAYOUTFILES:.bin=.cmp)
ROOMLAYOUTFILES := $(foreach file, $(ROOMLAYOUTFILES), \
                    $(BUILD_DIR)/rooms/$(notdir $(file)))

COLLISIONFILES = $(wildcard tileset_layouts/$(GAME)/tilesetCollisions*.bin)
COLLISIONFILES := $(COLLISIONFILES:.bin=.cmp)
COLLISIONFILES := $(foreach file, $(COLLISIONFILES), \
                    $(BUILD_DIR)/tileset_layouts/$(notdir $(file)))

MAPPINGINDICESFILES = $(wildcard tileset_layouts/$(GAME)/tilesetMappings*.bin)
MAPPINGINDICESFILES := $(foreach file, $(MAPPINGINDICESFILES), \
                         $(BUILD_DIR)/tileset_layouts/$(notdir $(file)))

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


$(GAME).gbc: $(OBJS) $(BUILD_DIR)/linkfile
	$(LD) -S $(BUILD_DIR)/linkfile $@
ifeq ($(BUILD_VANILLA),true)
	@-tools/build/verify-checksum.sh $(GAME)
endif
	@echo -e "$(BOLD)Built $(GAME_COLOR)$@$(NC)."

$(BUILD_DIR)/linkfile: linkfile_$(GAME)
	sed 's/BUILD_DIR/${BUILD_DIR}/' $< > $@

$(MAPPINGINDICESFILES): $(BUILD_DIR)/tileset_layouts/mappingsDictionary.bin
$(COLLISIONFILES): $(BUILD_DIR)/tileset_layouts/collisionsDictionary.bin

$(BUILD_DIR)/$(GAME).o: $(MAIN_ASM_FILES) $(COMMONDATAFILES) $(GAMEDATAFILES)
$(BUILD_DIR)/$(GAME).o: $(GFXFILES) $(ROOMLAYOUTFILES) $(COLLISIONFILES) $(MAPPINGINDICESFILES)
$(BUILD_DIR)/$(GAME).o: $(BUILD_DIR)/tileset_layouts/tileMappingTable.bin
$(BUILD_DIR)/$(GAME).o: $(BUILD_DIR)/tileset_layouts/tileMappingIndexData.bin
$(BUILD_DIR)/$(GAME).o: $(BUILD_DIR)/tileset_layouts/tileMappingAttributeData.bin
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
	@echo "Copying $$< to $(BUILD_DIR)/gfx/..."
	@cp $$< $$@
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
	@echo "Converting $$<..."
	@$$(PYTHON) tools/build/compressGfx.py --mode 0 $$< $$@
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

endif # End of check for either ROM_AGES or ROM_SEASONS being defined


clean:
	-rm -R build build_ages_* build_seasons_* \
		ages.gbc ages.sym seasons.gbc seasons.sym

# --------------------------------------------------------------------------------
# Testing graphics encoding: ensure that pngs are encoded correctly.
# --------------------------------------------------------------------------------

test-gfx:
	@$(PYTHON) tools/gfx/gfx.py auto gfx_compressible/common/*.png gfx_compressible/ages/*.png gfx_compressible/seasons/*.png
	@echo "Running diff against gfx files in 'test/gfx_compressible_encoded'..."
	@for f in $$(cd gfx_compressible; find -name 'gfx_*.bin' -or -name 'spr_*.bin'); do \
		diff gfx_compressible/$$f test/gfx_compressible_encoded/$$f; \
	done
