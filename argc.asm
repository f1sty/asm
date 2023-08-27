; print arguments count
%include "std.asm"

%define RADIX 10
%define BUFFER_SIZE 32

segment .text
  global _start

_start:
  mov rdi, STDOUT
  mov rsi, argc
  mov rdx, 6
  call print

  mov rdi, buffer
  mov rsi, BUFFER_SIZE
  mov rdx, RADIX
  mov rcx, rsp
  call print_uint64
  call print_new_line

  mov rdi, 0
  mov rax, SYS_EXIT
  syscall

segment .data
argc:       db "argc: "

segment .bss
buffer: resb BUFFER_SIZE
