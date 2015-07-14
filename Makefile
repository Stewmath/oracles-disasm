# If true, compressed graphics will be read from the gfx_precompressed folder.
# Also, text will use the 'textData_precompressed.s' file instead of using the text.txt file.
# Set to anything but true if you want to modify text or anything in the gfx_compressible folder.
# You may need to "make clean" after modifying this.
USE_PRECOMPRESSED_ASSETS = false

OBJS = build/main.o

TARGET = rom.gbc

GFXFILES = $(wildcard gfx/*.bin)
GFXFILES += $(wildcard gfx_compressible/*.bin)
GFXFILES := $(GFXFILES:.bin=.cmp)

GFXFILES := $(foreach file,$(GFXFILES),build/gfx/$(notdir $(file)))


$(TARGET): $(OBJS) linkfile
	@echo "Linking objects..."
	@wlalink linkfile rom.gbc
	rgbfix -Cjv -t "ZELDA NAYRUAZ8E" -k 01 -l 0x33 -m 0x1b -r 0x02 rom.gbc
	md5sum -c ages.md5

build/main.o: $(GFXFILES) build/textData.s
build/main.o: interactions/*.s data/*.s include/*.s

build/%.o: %.s | build
	@echo "Building $@..."
	@wla-gb -o $<; mv $(basename $<).o $@
	
linkfile: $(OBJS)
	@echo "[objects]" > linkfile
	@echo "$(OBJS)" | sed 's/ /\n/g' >> linkfile

build/gfx/%.cmp: gfx/%.bin | build
	@echo "Copying $< to $@..."
	@dd if=/dev/zero bs=1 count=1 of=$@ 2>/dev/null
	@cat $< >> $@


ifeq ($(USE_PRECOMPRESSED_ASSETS),true)

build/gfx/%.cmp: gfx_precompressed/%.cmp | build
	@echo "Copying $< to $@..."
	@cp $< $@

build/textData.s: text/textData_precompressed.s
	@echo "Copying $< to $@..."
	@cp $< $@

else

build/gfx/%.cmp: gfx_compressible/%.bin | build
	@echo "Compressing $<..."
	@python2 tools/compressGfx.py $< $@

build/textData.s: text/text.txt | build
	@echo "Compressing text..."
	@python2 tools/parseText.py $< $@ 74000

endif


build:
	mkdir -p build/gfx/


.PHONY: clean run

clean:
	-rm -R build/ $(TARGET)

run:
	$(GBEMU) $(TARGET)
