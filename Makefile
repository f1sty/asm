FLAGS = -g -f elf64

all: bin/hello_world bin/read_file bin/print_uint64 bin/argc

bin/hello_world: hello_world.o
	ld -o $@ $<

hello_world.o: hello_world.asm
	nasm ${FLAGS} $<

bin/read_file: read_file.o
	ld -o $@ $<

read_file.o: read_file.asm
	nasm ${FLAGS} $<

bin/print_uint64: print_uint64.o
	ld -o $@ $<

print_uint64.o: print_uint64.asm
	nasm ${FLAGS} $<

bin/argc: argc.o
	ld -o $@ $<

argc.o: argc.asm
	nasm ${FLAGS} $<

clean:
	rm -rf *.o

.PHONY: all clean
