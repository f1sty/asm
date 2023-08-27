BITS 64

%define STDOUT 1
%define SYS_READ 0
%define SYS_WRITE 1
%define SYS_OPEN 2
%define SYS_EXIT 60
%define BUFFER_LEN 1024
%define O_RDONLY 0

segment .text
  global _start
_start:
  mov rdi, file_path
  mov rsi, O_RDONLY
  xor rdx, rdx
  mov rax, SYS_OPEN
  syscall

  mov rdi, rax
  mov rsi, buffer
  mov rdx, BUFFER_LEN
  mov rax, SYS_READ
  syscall

  mov rdi, STDOUT
  mov rsi, buffer
  mov rdx, rax
  mov rax, SYS_WRITE
  syscall

  mov rdi, 0
  mov rax, SYS_EXIT
  syscall
  
segment .data
file_path: db "./read_file.asm", 0

segment .bss
buffer: resb BUFFER_LEN
