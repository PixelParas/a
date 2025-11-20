section .data
msg db "Hello, world!", 10      ; Use straight quotes and a comma after string and 10

len equ $ - msg                 ; Match label case and spelling; 'len' is correct

section .text
global _start

_start:
    mov rax, 1                  ; sys_write
    mov rdi, 1                  ; stdout
    mov rsi, msg                ; address of string
    mov rdx, len                ; length of string
    syscall                     ; Call kernel

    mov rax, 60                 ; sys_exit
    mov rdi, 0                  ; exit code
    syscall                     ; Call kernel
