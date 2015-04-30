OBJS = main.o

TARGET = rom.gbc

$(TARGET): $(OBJS) linkfile
	wlalink -s linkfile rom.gbc
	rgbfix -Cv rom.gbc

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
