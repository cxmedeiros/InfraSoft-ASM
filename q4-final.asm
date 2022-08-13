org 0x7c00
jmp 0x0000:start

gets:                 ; mov di, string
    ; cl = 0
    xor cl, cl          ; zerar contador

    .loop:
    ; al = getchar()
    call getchar

    ; if al == 0x08
    cmp al, 0x08      ; backspace
    je .backspace

    ; if al == 0x0d
    cmp al, 0x0d      ; carriage return
    je .endloop

    ; if cl == 10
    cmp cl, 10        ; string limit checker
    je .loop

    ; *di = al
    ; ++di
    stosb

    ; ++c
    inc cl

    call putchar

    jmp .loop

    .backspace:
        ; if cl == 0
        cmp cl, 0       ; is empty?
        je .loop

        ; --di
        dec di

        ; --cl
        dec cl

        ; *di = 0
        mov byte[di], 0

        call delchar
        jmp .loop

    .endloop:
    ; *di = 0
    ; ++di
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

getchar:
    mov ah, 0
    int 16h
    ret

putchar:
    mov ah, 0x0e
    int 10h
    ret

delchar:
  mov al, 0x08          ; backspace
  call putchar
  mov al, ' '
  call putchar
  mov al, 0x08          ; backspace
  call putchar
  ret

endl:
  mov al, 0x0a          ; line feed
  call putchar
  mov al, 0x0d          ; carriage return
  call putchar
  ret

to_string:              ; mov ax, int / mov di, string
  push di

  .loop1:
    cmp ax, 0
    je .endloop1

    xor dx, dx
    mov bx, 10
    div bx            ; ax = 9999 -> ax = 999, dx = 9
    xchg ax, dx       ; swap ax, dx
    add ax, 48        ; 9 + '0' = '9'
    stosb
    xchg ax, dx
    jmp .loop1

  .endloop1:
  pop si
  cmp si, di
  jne .done
  mov al, 48
  stosb
  .done:
  mov al, 0
  stosb
  call reverse
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

reverse:              ; mov si, string
  mov di, si
  xor cx, cx          ; zerar contador
  .loop1:             ; botar string na stack
    lodsb
    cmp al, 0
    je .endloop1
    inc cl
    push ax
    jmp .loop1
  .endloop1:
  .loop2:             ; remover string da stack
    pop ax
    stosb
    loop .loop2
  ret

X dw 0
Y dw 0
Z dw 0
W dw 0

quot dw 0
rem dw 0

even db "Par", 0
odd db "Impar", 0

buffer times 6 db 0

read_int:
    mov di, buffer
    call gets

    mov si, buffer
    call stoi

    ret

read:
    call read_int
    mov [X], ax

    call read_int
    mov [Y], ax

    call read_int
    mov [Z], ax

    call read_int
    mov [W], ax

    ret

calculator: ; ((x + y) + (z - w)) / ((x + w) + (y - z))
    mov ax, [X] ; ax = x
    add ax, [Y] ; ax = x + y
    add ax, [Z] ; ax = x + y + z
    sub ax, [W] ; ax = x + y + z - w

    mov cx, [X] ; cx = x
    add cx, [W] ; cx = x + w
    add cx, [Y] ; cx = x + w + y
    sub cx, [Z] ; cx = x + w + y - z

    div cx ; ax = ax / cx, dx = ax % cx
    mov [quot], ax
    mov [rem], dx

    ret

print_int:
    mov di, buffer
    call to_string

    mov si, buffer
    call puts
    call endl

    ret

parity:

    and ax, 1
    cmp ax, 0
    je .even

    .odd:
        mov si, odd
        jmp .print

    .even:
        mov si, even
        jmp .print

    .print:
    call puts
    call endl

    ret

start:
    call read
    call calculator

    mov ax, [quot]
    call print_int

    mov ax, [rem]
    call print_int

    mov ax, [quot]
    call parity

end:
    jmp $

times 510-($-$$) db 0
dw 0xaa55