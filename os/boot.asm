;; implement task at the end of https://www.youtube.com/watch?v=APiHPkPmwwU
mov ah, 0x0e ; Write Character in TTY Mode routine
mov al, 'a'  ; character to write
mov bl, 32   ; shift
.next_char:
  int 0x10
  inc al
  neg bl
  add al, bl
  cmp al, 'z' + 1
  jne .next_char
jmp $
times 510 - ($ - $$) db 0
db 0x55, 0xaa
