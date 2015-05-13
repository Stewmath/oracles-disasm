# Set to true to read compressed graphics data from the gfx_precompressed folder.
# Set to anything else if you want to modify the graphics in the corresponding gfx_compressible folder.
# You may need to "make clean" after modifying this.
USE_PRECOMPRESSED_GFX = true

OBJS = main.o

TARGET = rom.gbc

GFXFILES = $(wildcard gfx/*.bin)
GFXFILES += $(wildcard gfx_compressible/*.bin)
GFXFILES := $(GFXFILES:.bin=.cmp)

GFXFILES := $(foreach file,$(GFXFILES),build/gfx/$(notdir $(file)))


$(TARGET): $(OBJS) linkfile
	wlalink linkfile rom.gbc
	rgbfix -Cjv -t "ZELDA NAYRUAZ8E" -k 01 -l 0x33 -m 0x1b -r 0x02 rom.gbc
	md5sum -c ages.md5

main.o: $(GFXFILES)

%.o: %.s interactions/*.s data/*.s
	wla-gb -o $(basename $@).s
	
linkfile: $(OBJS)
	echo "[objects]" > linkfile
	echo "$(OBJS)" | sed 's/ /\n/g' >> linkfile

build/gfx/%.cmp: gfx/%.bin
	@echo "Copying $< to $@..."
	@dd if=/dev/zero bs=1 count=1 of=$@ 2>/dev/null
	@cat $< >> $@


ifeq ($(USE_PRECOMPRESSED_GFX),true)

build/gfx/%.cmp: gfx_precompressed/%.cmp
	@echo "Copying $< to $@..."
	@cp $< $@

else

build/gfx/%.cmp: gfx_compressible/%.bin
	@echo "Compressing $<..."
	@python tools/compressGfx.py $< $@

endif



.PHONY: clean run

clean:
	-rm -R *.o build/ $(TARGET)

run:
	/c/Users/Matthew/Desktop/Things/Emulators/bgb/bgb.exe $(TARGET)
