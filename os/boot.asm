;; implement task at the end of https://www.youtube.com/watch?v=APiHPkPmwwU
[org 0x7c00]
jmp start
print_cstr:
  mov ah, 0x0e ; Write Character in TTY Mode routine
  lodsb
  test al, al
  jz .end
  int 0x10
  jmp print_cstr
  .end:
  ret
print_nl:
  mov ah, 0x0e ; Write Character in TTY Mode routine
  mov al, 10
  int 0x10
  mov ah, 0x0e ; Write Character in TTY Mode routine
  mov al, 13
  int 0x10
  ret
read_string:
  xor ah, ah
  int 0x16
  cmp al, `\r`
  je .end
  mov [bx], al
  dec cx
  test cx, cx
  jz .end
  inc bx
  jmp read_string
  .end:
  ret
read_string_stack:
  xor bx, bx
  push 0
  .loop:
  xor ah, ah
  int 0x16
  push ax
  cmp al, `\r`
  je .offset
  jmp .loop

  .offset:
  mov si, sp
  cmp word [si + bx], 0
  je .print
  inc bx
  jmp .offset
  .print:
  test bx, bx
  jz .end
  mov si, sp
  mov ax, [si + bx]
  mov ah, 0x0e
  int 0x10
  sub bx, 2
  jmp .print
  .end:
  ret
print_uint16:
  push 0
  .loop:
  xor dx, dx
  div bx
  add dx, '0'        ; add '0' ascii code to translate into digit char
  push dx
  test ax, ax
  jnz .loop

  .print:
  pop ax
  test ax, ax
  jz .end
  mov ah, 0x0e
  int 0x10
  jmp .print
  .end:
  ret
start:
  mov si, string
  call print_cstr
  mov si, login
  call print_cstr
  mov bx, buffer
  mov cx, buffer_len
  call read_string
  call print_nl
  mov si, buffer
  call print_cstr
  call print_nl
  mov si, password
  call print_cstr
  call read_string_stack
  mov si, length
  call print_cstr
  mov ax, buffer_len  ; number
  mov bx, 10          ; radix
  call print_uint16
  jmp $
string: db "starting castle os...", 10, 13, 0
login: db "login: ", 0
password: db "password: ", 0
length: db 10, 13, "length of the buffer: ", 0
buffer: times 16 db 0
buffer_len: equ $ - buffer
times 510 - ($ - $$) db 0
db 0x55, 0xaa
