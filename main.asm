section .data
    hello: db "Hello World", 10
    helloLen: equ $-hello

section .text
    global _start

_start:
    mov rax, 0x2000004
    mov rdi, 1
    lea rsi, [rel hello]
    mov rdx, helloLen
    syscall

    mov rax, 0x2000001
    mov rdi, 0
    syscall