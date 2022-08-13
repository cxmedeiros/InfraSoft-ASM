org 0x7c00
jmp 0x0000:start

string times 10 db 0

start:
        xor ax, ax ;zera ax, xor é mais rápido que mov
        xor bx, bx
        xor dx, dx
        xor cx, cx

        mov di, string
        call gets


        call getchar

        mov si, string
        call printar

gets: ;ler uma string
        xor cx, cx
        .loop1:
                call getchar
                cmp al, 0x08
                je .backspace
                cmp al, 0x0d
                je .done
                cmp cl, 50
                je .loop1
                stosb
                inc cl
                call putchar
                jmp .loop1

                .backspace:
                        cmp cl,0
                        je .loop1
                        dec di
                        dec cl
                        mov byte[di], 0
                        call delchar
                        jmp .loop1
        .done:
              mov al, 0
              stosb
              call endl
        ret

putchar: ;printar um caracter na tela

        mov ah, 0x0e
        int 10h
ret

getchar: ;ler um caracter do teclado

        mov ah, 0x00
        int 16h

    ret

delchar: ;deletar um caracter lido

        mov al, 0x08
        call putchar

        mov al, ''
        call putchar

        mov al, 0x08
        call putchar
ret

endl: ;quebra de linha

    mov al, 0x0a
    call putchar
    mov al, 0x0d
    call putchar

ret

printar:
    mov bl, al
    sub bl, 48
    xor cl, cl
    .loop:
        lodsb
        inc cl

        cmp cl, bl
        je .endloop
        pop dx

        jmp .loop

    .endloop:
        call putchar
    ret

times 510 - ($ - $$) db 0
dw 0xaa55 ;assinatura de boot