section .data
    num1 db 5
    num2 db 10

section .bss
    result resb 1

section .text
    global _start

_start:
    mov al, [num1]
    mov bl, [num2]

    add al, bl

    mov [result], al

    mov eax, 1
    int 0x80
