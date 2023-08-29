TARGET=boot.bin
FLAGS=-Wall -f bin

all: $(TARGET)

$(TARGET): %.bin: %.asm
	nasm $(FLAGS) -o $@ $<

clean:
	rm -rf $(TARGET)

.PHONY: all clean
