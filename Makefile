all: bin/hello_world bin/read_file

bin/hello_world: hello_world.o
	ld -o $@ $<

hello_world.o: hello_world.asm
	nasm -f elf64 $<

bin/read_file: read_file.o
	ld -o $@ $<

read_file.o: read_file.asm
	nasm -f elf64 $<

clean:
	rm -rf *.o

.PHONY: all clean
