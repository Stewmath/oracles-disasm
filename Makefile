# If true, compressed graphics will be read from the gfx_precompressed folder.
# Also, text will use the 'textData_precompressed.s' file instead of using the text.txt file.
# Set to anything but true if you want to modify text or anything in the gfx_compressible folder.
# You may need to "make clean" after modifying this.
USE_PRECOMPRESSED_ASSETS = true

OBJS = build/main.o

TARGET = rom.gbc

GFXFILES = $(wildcard gfx/*.bin)
GFXFILES += $(wildcard gfx_compressible/*.bin)
GFXFILES := $(GFXFILES:.bin=.cmp)
GFXFILES := $(foreach file,$(GFXFILES),build/gfx/$(notdir $(file)))

ROOMLAYOUTFILES = $(wildcard maps/small/*.bin)
ROOMLAYOUTFILES += $(wildcard maps/large/*.bin)
ROOMLAYOUTFILES := $(ROOMLAYOUTFILES:.bin=.cmp)
ROOMLAYOUTFILES := $(foreach file,$(ROOMLAYOUTFILES),build/maps/$(notdir $(file)))

TILESETFILES = $(wildcard tilesets/tilesetCollisions*.bin)
TILESETFILES += $(wildcard tilesets/tilesetMappings*.bin)
TILESETFILES := $(TILESETFILES:.bin=.cmp)
TILESETFILES := $(foreach file,$(TILESETFILES),build/tilesets/$(notdir $(file)))

ifneq ($(USE_PRECOMPRESSED_ASSETS),true)

OPTIMIZE := -o

endif


$(TARGET): $(OBJS) linkfile
	wlalink linkfile rom.gbc
	rgbfix -Cjv -t "ZELDA NAYRUAZ8E" -k 01 -l 0x33 -m 0x1b -r 0x02 rom.gbc
ifeq ($(USE_PRECOMPRESSED_ASSETS),true)
	@md5sum -c ages.md5
endif

build/main.o: $(GFXFILES) $(ROOMLAYOUTFILES) $(TILESETFILES) build/textData.s
build/main.o: constants/*.s data/*.s include/*.s interactions/*.s music/*.bin

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


ifeq ($(USE_PRECOMPRESSED_ASSETS),true)

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

build/tilesets/tilesetMappings%.cmp: tilesets/tilesetMappings%.bin
	@echo "Compressing $< to $@..."
	@python2 tools/compressTilesetData.py $< $@ 1 tilesets/mappingsDictionary.bin
build/tilesets/tilesetCollisions%.cmp: tilesets/tilesetCollisions%.bin
	@echo "Compressing $< to $@..."
	@python2 tools/compressTilesetData.py $< $@ 0 tilesets/collisionsDictionary.bin

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
