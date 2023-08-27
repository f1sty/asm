%include "std.asm"

%define RADIX 10
%define BUFFER_SIZE 32

segment .text
  global _start

_start:
  mov rdi, buffer
  mov rsi, BUFFER_SIZE
  mov rdx, RADIX
  mov rcx, max_number
  call print_uint64
  call print_new_line

  mov rdi, buffer
  mov rsi, BUFFER_SIZE
  mov rdx, RADIX
  mov rcx, min_number
  call print_uint64
  call print_new_line

  mov rdi, buffer
  mov rsi, BUFFER_SIZE
  mov rdx, RADIX
  mov rcx, number
  call print_uint64
  call print_new_line

  mov rdi, 0
  mov rax, SYS_EXIT
  syscall

segment .data
max_number: dq 18446744073709551615
number:     dq 1337817
min_number: dq 0

segment .bss
buffer: resb BUFFER_SIZE
