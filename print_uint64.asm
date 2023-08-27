BITS 64

%define RADIX 10
%define STDOUT 1
%define SYS_WRITE 1
%define SYS_EXIT 60
%define BUFFER_SIZE 32

segment .text
  global _start

print_new_line:
  mov rdi, STDOUT
  mov rsi, new_line
  mov rdx, 2
  mov rax, SYS_WRITE
  syscall

  ret

; TODO: probably there is more efficient way to do it
clear_buffer:
  mov r8, rdi
  mov r9, r8
  add r9, rsi
  .loop:
  mov byte [r8], 0
  inc r8
  cmp r8, r9
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
  mov rax, SYS_WRITE
  syscall

  ret

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
new_line:   db 13, 10

segment .bss
buffer: resb BUFFER_SIZE
