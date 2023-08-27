TARGETS=hello_world

all: bin/$(TARGETS)

bin/$(TARGETS): $(TARGETS).o
	ld -o $@ $<

$(TARGETS).o: $(TARGETS).asm
	nasm -f elf64 $<

clean:
	rm -rf *.o

.PHONY: all clean
