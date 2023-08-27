BITS 64

%define SYS_WRITE 1
%define SYS_EXIT 60

segment .text
  global _start
_start:
  mov rdi, 1
  mov rsi, string
  mov rdx, len
  mov rax, SYS_WRITE
  syscall

  mov rdi, 0
  mov rax, SYS_EXIT
  syscall
  
segment .data
string: db  "Hello, world", 10
len:    equ $ - string
