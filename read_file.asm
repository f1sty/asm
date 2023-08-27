%include "std.asm"

%define BUFFER_LEN 2048

segment .text
  global _start
  
_start:
  mov rdi, file_path
  mov rsi, O_RDONLY
  xor rdx, rdx
  call open

  cmp rax, 0
  jl .error           ; error: open(file_path, O_RDONLY, NULL) returned fd < 0

  mov rdi, rax
  mov rsi, buffer
  mov rdx, BUFFER_LEN
  call read

  cmp rax, 0
  jl .error           ; error: read(fd, buffer, BUFFER_LEN) returned read_bytes < 0

  mov rdi, STDOUT
  mov rsi, buffer
  mov rdx, rax
  call print

  cmp rax, 0
  jl .error           ; error: write(STDOUT, buffer, read_bytes) returned written_bytes < 0

  mov rdi, 0
  mov rax, SYS_EXIT
  syscall

  .error:
  neg rax
  mov rbx, rax        ; save errno to rbx

  mov rdi, STDOUT
  mov rsi, error_msg
  mov rdx, error_msg_len
  call print

  mov rdi, rbx
  mov rax, SYS_EXIT
  syscall
  
segment .data
file_path:     db "./read_file.asm", 0
error_msg:     db "error occured, please see return code", 13, 10
error_msg_len: equ $ - error_msg

segment .bss
buffer: resb BUFFER_LEN
