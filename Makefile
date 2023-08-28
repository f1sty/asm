FLAGS = -g -f elf64
TARGETS = hello_world read_file print_uint64 argc

all: bin $(TARGETS)

bin:
	mkdir bin

$(TARGETS): %: %.o
	ld -o $@ $<
	mv $@ bin

%.o: %.asm
	nasm $(FLAGS) $<

clean:
	rm -rf bin $(TARGETS:=.o)

.PHONY: all clean
