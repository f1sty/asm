FLAGS = -g -f elf64
NAMES = hello_world read_file print_uint64 argc argv
TARGETS = $(NAMES:%=bin/%)

all: bin $(TARGETS)

bin:
	mkdir -p bin

$(TARGETS): bin/%: %.o
	ld -o $@ $<

%.o: %.asm
	nasm $(FLAGS) $<

clean:
	rm -rf bin $(TARGETS:=.o)

.PHONY: all clean
