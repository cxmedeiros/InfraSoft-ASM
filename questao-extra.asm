org 0x7c00
jmp 0x0000:start

color times 15 db 0
string db "Malu ", 0x82, " uma ", 0xa2, "tima monitora", 0

init_video:
	mov al, 13h
	mov ah, 0
	int 10h
	ret

getchar:
    mov ah, 0x0
    int 16h
    ret

endl:
  mov al, 0x0a          ; line feed
  call putchar
  mov al, 0x0d          ; carriage return
  call putchar
  ret

delchar:
  mov al, 0x08          ; backspace
  call putchar
  mov al, ' '
  call putchar
  mov al, 0x08          ; backspace
  call putchar
  ret

gets:                 ; mov di, string
    xor cx, cx          ; zerar contador

    .loop:
    call getchar
    cmp al, 0x08      ; backspace
    je .backspace
    cmp al, 0x0d      ; carriage return
    je .endloop
    cmp cl, 10        ; string limit checker
    je .loop

    stosb
    inc cl
    call putchar

    jmp .loop

    .backspace:
        cmp cl, 0       ; is empty?
        je .loop
        dec di
        dec cl
        mov byte[di], 0
        call delchar

    jmp .loop

    .endloop:
    mov al, 0
    stosb
    call endl
    ret

stoi:                ; mov si, string
  xor cx, cx
  xor ax, ax
  .loop:
    push ax
    lodsb
    mov cl, al
    pop ax
    cmp cl, 0        ; check EOF(NULL)
    je .endloop
    sub cl, 48       ; '9'-'0' = 9
    mov bx, 10
    mul bx           ; 999*10 = 9990
    add ax, cx       ; 9990+9 = 9999
    jmp .loop
  .endloop:
  ret

putchar:
    mov ah, 0x0e
    int 10h
    ret

puts:
    .loop:
        lodsb
        cmp al, 0

        je .endloop
        call putchar

        jmp .loop

    .endloop:
    ret

start:
    call init_video ; initialize video mode

    mov di, color
    call gets

    mov si, color
    call stoi

    mov si, string
    mov bl, al
    call puts

end:
    jmp $

times 510 - ($ - $$) db 0
dw 0xaa55
