; print argument
%include "std.asm"

segment .text
  global _start

_start:
  mov rdi, STDOUT
  mov rsi, argv
  mov rdx, argv_len
  call print

  pop r8           ; argc
  .print_args:
  test r8, r8
  jz .no_more_args
  pop rdi          ; argv[n]
  call print_cstr
  mov rdi, space
  call print_cstr
  dec r8
  jmp .print_args

  .no_more_args:
  call print_new_line

  mov rdi, 0
  mov rax, SYS_EXIT
  syscall

segment .data
argv:       db "argv: "
argv_len:   equ $ - argv
space:      db " ", 0
