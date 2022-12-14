org 0x7c00
jmp 0x0000:start

string times 30 db 0
endl db ' ', 13, 10, 0

video_mode:
    mov ax, 0013h
    mov bh, 0
    mov bl, 13 ; cor da fonte
    int 10h
    ret

putc:
    mov ah, 0x0e
    int 10h
    ret

readc:
    mov ah, 0x00
    int 16h
    ret

prints:
    .loop:
        lodsb
        cmp al, 0
        je .endloop
        call putc
        jmp .loop
    .endloop:
    ret

reverse:
    mov di, si
    xor cx, cx
    .loop:
        lodsb
        cmp al, 0
        je .endloop
        inc cl
        push ax
        jmp .loop
    .endloop:
    .loop1:
        cmp cl, 0
        je .endloop1
        dec cl
        pop ax
        stosb
        jmp .loop1

        .endloop1:
        ret

gets:
    mov al, 0
    .for:
        call readc
        stosb
        cmp al, 13
        je .fim
        call putc
        jmp .for
     .fim:
    dec di
    mov al, 0
    stosb
    mov si, endl
    call prints
    ret

start:
    xor ax, ax
    mov cx, ax
    mov dx, ax

    call video_mode

    mov di, string
    call gets
    mov si, string
    call reverse
    mov si, string
    call prints

times 510-($-$$) db 0
dw 0xaa55