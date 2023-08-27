%include "std.asm"

segment .text
  global _start

_start:
  mov rdi, 1
  mov rsi, string
  mov rdx, len
  call print

  mov rdi, 0
  mov rax, SYS_EXIT
  syscall
  
segment .data
string: db  "Hello, world", 10
len:    equ $ - string
