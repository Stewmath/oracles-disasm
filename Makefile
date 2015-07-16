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

ROOMLAYOUTFILES = $(wildcard map/small/*.bin)
ROOMLAYOUTFILES += $(wildcard map/group*/*.bin)
ROOMLAYOUTFILES := $(ROOMLAYOUTFILES:.bin=.cmp)
ROOMLAYOUTFILES := $(foreach file,$(ROOMLAYOUTFILES),build/map/$(notdir $(file)))

ifneq ($(USE_PRECOMPRESSED_ASSETS),true)

OPTIMIZE := -o

endif


$(TARGET): $(OBJS) linkfile
	@echo "Linking objects..."
	@wlalink linkfile rom.gbc
	rgbfix -Cjv -t "ZELDA NAYRUAZ8E" -k 01 -l 0x33 -m 0x1b -r 0x02 rom.gbc
	md5sum -c ages.md5

build/main.o: $(GFXFILES) $(ROOMLAYOUTFILES) build/textData.s
build/main.o: interactions/*.s data/*.s include/*.s

build/%.o: %.s | build
	@echo "Building $@..."
	@wla-gb -o $< && mv $(basename $<).o $@
	
linkfile: $(OBJS)
	@echo "[objects]" > linkfile
	@echo "$(OBJS)" | sed 's/ /\n/g' >> linkfile

build/map/%.cmp: map/small/%.bin | build
	@echo "Compressing $< to $@..."
	@python2 tools/compressRoomLayout.py $< $@ $(OPTIMIZE)

build/gfx/%.cmp: gfx/%.bin | build
	@echo "Copying $< to $@..."
	@dd if=/dev/zero bs=1 count=1 of=$@ 2>/dev/null
	@cat $< >> $@


ifeq ($(USE_PRECOMPRESSED_ASSETS),true)

build/map/%.cmp: map/group4_precompressed/%.cmp | build
	@echo "Copying $< to $@..."
	@cp $< $@
build/map/%.cmp: map/group5_precompressed/%.cmp | build
	@echo "Copying $< to $@..."
	@cp $< $@

build/gfx/%.cmp: gfx_precompressed/%.cmp | build
	@echo "Copying $< to $@..."
	@cp $< $@

build/textData.s: text/textData_precompressed.s | build
	@echo "Copying $< to $@..."
	@cp $< $@

else

build/map/%.cmp: map/group4/%.bin | build
	@echo "Compressing $< to $@..."
	@python2 tools/compressRoomLayout.py $< $@ -d map/dictionary4.bin
build/map/%.cmp: map/group5/%.bin | build
	@echo "Compressing $< to $@..."
	@python2 tools/compressRoomLayout.py $< $@ -d map/dictionary5.bin

build/gfx/%.cmp: gfx_compressible/%.bin | build
	@echo "Compressing $< to $@..."
	@python2 tools/compressGfx.py $< $@

build/textData.s: text/text.txt | build
	@echo "Compressing text..."
	@python2 tools/parseText.py $< $@ $$((0x74000)) $$((0x2c))

endif


build:
	mkdir -p build/gfx/
	mkdir build/map
	mkdir build/debug


.PHONY: clean run force

force:
	touch main.s
	make

clean:
	-rm -R build/ $(TARGET)

run:
	$(GBEMU) $(TARGET)
