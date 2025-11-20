%macro PRINT 2
    mov rax, 1
    mov rdi, 1
    mov rsi, %1
    mov rdx, %2
    syscall
%endmacro

%macro INPUT 2
    mov rax, 0
    mov rdi, 0
    mov rsi, %1
    mov rdx, %2
    syscall
%endmacro

section .data
menu_text db 10, "Choose Method:", 10
    db "1. Multiply (Successive Addition)", 10
    db "2. Multiply (Add and Shift)", 10
    db "3. Exit", 10
    db "Option: ", 10
menu_len equ $-menu_text
multiplicand_text db "Enter multiplicand:", 10
multiplicand_len equ $-multiplicand_text
multiplier_text db "Enter multiplier:", 10
multiplier_len equ $-multiplier_text
result_text db "Product Result: ", 10
result_len equ $-result_text
gap db 10,0
gap_len equ $-gap

section .bss
data_in resb 18
input_choice resb 2
display_buff resb 16
digit_count resq 1
val1 resq 1
val2 resq 1
accumulator resq 1
temp_mult resq 1
curr_mult resq 1
bit_counter resq 1

section .text
global _start

_start:
main_loop:
    PRINT gap, gap_len
    PRINT menu_text, menu_len
    INPUT input_choice, 2

    cmp byte [input_choice], '1'
    je multiply_successive

    cmp byte [input_choice], '2'
    je multiply_shift

    cmp byte [input_choice], '3'
    je program_exit

multiply_successive:
    PRINT multiplicand_text, multiplicand_len
    INPUT data_in, 18
    dec rax
    mov [digit_count], rax
    call to_int 
    mov [val1], rbx

    PRINT multiplier_text, multiplier_len
    INPUT data_in, 18
    dec rax
    mov [digit_count], rax
    call to_int 
    mov [val2], rbx

    mov rbx, 0
repeat_add:
    add rbx, [val1]
    dec qword [val2]
    cmp qword [val2], 0
    jne repeat_add

    PRINT result_text, result_len
    call show_value
    jmp main_loop

multiply_shift:
    PRINT multiplicand_text, multiplicand_len
    INPUT data_in, 18
    dec rax
    mov [digit_count], rax
    call to_int
    mov [temp_mult], rbx

    PRINT multiplier_text, multiplier_len
    INPUT data_in, 18
    dec rax
    mov [digit_count], rax
    call to_int
    mov [curr_mult], rbx

    mov [accumulator], 0
    mov [bit_counter], 64
shift_loop:
    mov rax, [curr_mult]
    and rax, 1
    cmp rax, 1
    jne shift_right
    mov rax, [accumulator]
    add rax, [temp_mult]
    mov [accumulator], rax
shift_right:
    mov rax, [accumulator]
    mov rbx, [curr_mult]
    shr rbx, 1
    mov rcx, rax
    and rcx, 1
    cmp rcx, 1
    jne continue_shift
    mov rdx, 1
    ror rdx, 1
    or rbx, rdx
continue_shift:
    shr rax, 1
    mov [accumulator], rax
    mov [curr_mult], rbx
    dec qword [bit_counter]
    jnz shift_loop

    PRINT result_text, result_len
    mov rbx, [accumulator]
    call show_value
    mov rbx, [curr_mult]
    call show_value
    jmp main_loop

program_exit:
    mov rax, 60
    xor rdi, rdi
    syscall

; Converts ASCII digits to integer
to_int:
    mov rbx, 0
    mov rsi, data_in
parse_digits:
    shl rbx, 4
    mov dl, [rsi]
    cmp dl, 39h
    jbe digit_subtract
    sub dl, 7h
digit_subtract:
    sub dl, 30h
    add rbx, rdx
    inc rsi
    dec qword [digit_count]
    jnz parse_digits
    ret

; Displays integer value as hex ASCII
show_value:
    mov rsi, display_buff
    mov rcx, 16
    mov rdx, 0
show_loop:
    rol rbx, 4
    mov dl, bl
    and dl, 0fh
    cmp dl, 9
    jbe smallhex
    add dl, 7h
smallhex:
    add dl, 30h
    mov [rsi], dl
    inc rsi
    dec rcx
    jnz show_loop
    PRINT display_buff, 16
    ret
