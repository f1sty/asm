BITS 64

%define STDOUT 1
%define SYS_READ 0
%define SYS_WRITE 1
%define SYS_OPEN 2
%define SYS_EXIT 60
%define SYS_STATFS 137
%define SYS_FSTATFS 138
%define BUFFER_LEN 2048
%define O_RDONLY 0

segment .text

open:
  mov rax, SYS_OPEN
  syscall

  ret

read:
  mov rax, SYS_READ
  syscall

  ret

print:
  mov rax, SYS_WRITE
  syscall

  ret

print_cstr:
  mov rsi, rdi
  mov rdi, STDOUT
  mov rdx, 1
  mov rax, SYS_WRITE
  .next_char:
  cmp byte [rsi], 0
  jz .break
  syscall
  inc rsi
  jmp .next_char
  .break:

  ret

print_new_line:
  mov rdi, STDOUT
  mov rsi, new_line
  mov rdx, 2
  call print

  ret

clear_buffer:
  xor rax, rax
  mov r8, rdi
  add r8, rsi
  .loop:
  stosb
  inc rdi
  cmp rdi, r8
  jl .loop

  ret

; int print_uint64(char *buffer, size_t buf_size, int radix, uint *number)
print_uint64:
  call clear_buffer

  mov rax, [rcx]     ; number -> rax
  add rdi, rsi
  mov rcx, rdi       ; buffer[BUFFER_SIZE] -> rcx
  dec rdi            ; buffer[BUFFER_SIZE - 1] -> rdi
  mov rbx, rdx       ; radix -> rbx
  xor rdx, rdx       ; set msb in `div` to 0
  .next_digit:
  div rbx
  add rdx, 48        ; add '0' ascii code to translate into digit char
  mov byte [rdi], dl ; adding digits from the end of the buffer
  dec rdi            ; `rdi` will be used to get string length later
  xor rdx, rdx
  test rax, rax
  jnz .next_digit
  sub rcx, rdi       ; length(buffer[rdi]) -> rcx

  mov rsi, rdi       ; where to start from
  mov rdi, STDOUT
  mov rdx, rcx       ; string len is in `rbx`
  call print

  ret

segment .data
new_line:   db `\n`
