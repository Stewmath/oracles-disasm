OBJS = main.o

TARGET = rom.gbc

$(TARGET): $(OBJS) linkfile
	wlalink linkfile rom.gbc
	rgbfix -Cjv -t "ZELDA NAYRUAZ8E" -k 01 -l 0x33 -m 0x1b -r 0x02 rom.gbc
	md5sum -c ages.md5

main.s: $(wildcard interactions/*.s)

%.o: %.s
	wla-gb -o $(basename $@).s
	
linkfile: $(OBJS)
	echo "[objects]" > linkfile
	echo "$(OBJS)" | sed 's/ /\n/g' >> linkfile

.PHONY: clean run

clean:
	-rm *.o $(TARGET)

run:
	/c/Users/Matthew/Desktop/Things/Emulators/bgb/bgb.exe $(TARGET)
