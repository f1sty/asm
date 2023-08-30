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
  mov byte [disk_num], dl
  mov ah, 2
  mov al, 1   ; how many sectors to read
  mov ch, 0   ; cylinder
  mov cl, 2   ; sector
  mov dh, 0   ; head
  mov dl, [disk_num]
  xor bx, bx
  mov es, bx
  mov bx, 0x7e00
  int 0x13
  jc .error
  cmp al, 1
  jne .error
  mov ah, 0x0e
  mov al, [bx]
  int 0x10
  jmp $
  .error:
  mov si, error
  call print_cstr
  jmp $
disk_num: db 0
error: db "error occured while reading sector from disk", 0
string: db "starting castle os...", 10, 13, 0
login: db "login: ", 0
password: db "password: ", 0
length: db 10, 13, "length of the buffer: ", 0
buffer: times 16 db 0
buffer_len: equ $ - buffer
times 510 - ($ - $$) db 0
db 0x55, 0xaa
times 512 db 'A'
