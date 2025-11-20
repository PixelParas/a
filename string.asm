%macro PRINT 2
    mov rax, 1          ; sys_write
    mov rdi, 1
    mov rsi, %1
    mov rdx, %2
    syscall
%endmacro

%macro INPUT 2
    mov rax, 0          ; sys_read
    mov rdi, 0
    mov rsi, %1
    mov rdx, %2
    syscall
%endmacro

section .data
menutxt db 10,"Choose string operation:",10
    db "1. Length",10
    db "2. Copy",10
    db "3. Reverse",10
    db "4. Compare",10
    db "5. Concatenate",10
    db "6. Palindrome",10
    db "7. Substring",10
    db "8. Exit",10,"Option: "
menutxt_len equ $-menutxt

strmsg db "Enter string 1:",10
strmsg_len equ $-strmsg

str2msg db "Enter string 2:",10
str2msg_len equ $-str2msg

lenmsg db "String length: ",10
lenmsg_len equ $-lenmsg

copymsg db "String copied:",10
copymsg_len equ $-copymsg

revmsg db "Reversed string:",10
revmsg_len equ $-revmsg

equalmsg db "Strings are equal.",10
equalmsg_len equ $-equalmsg

diffmsg db "Strings are not equal.",10
diffmsg_len equ $-diffmsg

catmsg db "Concatenated string:",10
catmsg_len equ $-catmsg

palmsg db "Palindrome: Yes.",10
palmsg_len equ $-palmsg

npalmsg db "Palindrome: No.",10
npalmsg_len equ $-npalmsg

notfoundmsg db "Substring not found.",10
notfoundmsg_len equ $-notfoundmsg

foundmsg db "Substring found!",10
foundmsg_len equ $-foundmsg

errormsg db "Invalid choice.",10
errormsg_len equ $-errormsg

section .bss
user_in     resb 32
user_len    resq 1
user2_in    resb 32
user2_len   resq 1
output_buf  resb 64
option      resb 2

section .text
global _start, exitprog

; Define exit early (avoid late redefinition)
exitprog:
    mov rax, 60
    xor rdi, rdi
    syscall

_start:
mainmenu:
    PRINT menutxt, menutxt_len
    INPUT option, 2

    cmp byte [option], '1'
    je string_len
    cmp byte [option], '2'
    je string_cpy
    cmp byte [option], '3'
    je string_rev
    cmp byte [option], '4'
    je string_cmp
    cmp byte [option], '5'
    je string_cat
    cmp byte [option], '6'
    je string_pal
    cmp byte [option], '7'
    je string_substr
    cmp byte [option], '8'
    je exitprog
    PRINT errormsg, errormsg_len
    jmp mainmenu

; -----------------------------------------------------------
; 1. String Length
string_len:
    PRINT strmsg, strmsg_len
    INPUT user_in, 32
    ; rax = bytes read (includes newline if user pressed enter)
    cmp rax, 0
    jle .len_zero
    dec rax                  ; subtract newline (or last char) if present
    mov [user_len], rax
    jmp .len_print
.len_zero:
    mov qword [user_len], 0
.len_print:
    PRINT lenmsg, lenmsg_len
    mov rbx, [user_len]
    call display_num
    jmp mainmenu

; display_num: prints decimal in output_buf (preserves rbx)
; input: rbx = non-negative integer to print
display_num:
    push rbx                ; preserve callee-saved register
    mov rsi, output_buf
    mov rcx, 0
    mov rax, rbx
    cmp rax, 0
    jne .dn_nonzero
    ; special-case zero:
    mov byte [rsi], '0'
    inc rsi
    mov byte [rsi], 0
    ; print "0\n" or just "0" — we'll print single digit
    sub rsi, output_buf
    ; print one byte from output_buf
    mov rsi, output_buf
    PRINT output_buf, 1
    pop rbx
    ret
.dn_nonzero:
    xor rdx, rdx
.digit_loop:
    xor rdx, rdx
    mov r9, 10
    div r9                  ; rax = rax / 10, rdx = remainder
    add dl, '0'
    mov [rsi], dl
    inc rsi
    inc rcx
    test rax, rax
    jnz .digit_loop
    ; now reverse the digits into the buffer start
    mov rdi, output_buf
.rev_copy:
    dec rcx
    jl .rev_done
    dec rsi
    mov al, [rsi]
    mov [rdi], al
    inc rdi
    jmp .rev_copy
.rev_done:
    ; null-terminate (not strictly necessary for PRINT but safe)
    mov byte [rdi], 0
    ; print the digits (length = rdi - output_buf)
    mov rdx, rdi
    sub rdx, output_buf
    mov rsi, output_buf
    mov rax, 1
    mov rdi, 1
    syscall
    pop rbx
    ret

; -----------------------------------------------------------
; 2. String Copy
string_cpy:
    PRINT strmsg, strmsg_len
    INPUT user_in, 32
    dec rax
    mov [user_len], rax
    mov rsi, user_in
    mov rdi, output_buf
    mov rcx, [user_len]
    test rcx, rcx
    jz .cpy_done
    cld
    rep movsb
.cpy_done:
    PRINT copymsg, copymsg_len
    mov rdx, [user_len]
    PRINT output_buf, rdx
    jmp mainmenu

; -----------------------------------------------------------
; 3. String Reverse
string_rev:
    PRINT strmsg, strmsg_len
    INPUT user_in, 32
    dec rax
    mov [user_len], rax
    mov rcx, [user_len]
    mov rsi, user_in
    add rsi, rcx
    dec rsi
    mov rdi, output_buf
    test rcx, rcx
    jz .rev_done2
.rev_loop:
    mov al, [rsi]
    mov [rdi], al
    dec rsi
    inc rdi
    loop .rev_loop
.rev_done2:
    PRINT revmsg, revmsg_len
    mov rdx, [user_len]
    PRINT output_buf, rdx
    jmp mainmenu

; -----------------------------------------------------------
; 4. String Compare
string_cmp:
    PRINT strmsg, strmsg_len
    INPUT user_in, 32
    dec rax
    mov [user_len], rax
    PRINT str2msg, str2msg_len
    INPUT user2_in, 32
    dec rax
    mov [user2_len], rax
    mov rbx, [user_len]
    cmp rbx, [user2_len]
    jne not_equal
    mov rsi, user_in
    mov rdi, user2_in
    mov rcx, rbx
    cld
    repe cmpsb
    jne not_equal
    PRINT equalmsg, equalmsg_len
    jmp mainmenu
not_equal:
    PRINT diffmsg, diffmsg_len
    jmp mainmenu

; -----------------------------------------------------------
; 5. String Concatenate
string_cat:
    PRINT strmsg, strmsg_len
    INPUT user_in, 32
    dec rax
    mov [user_len], rax
    PRINT str2msg, str2msg_len
    INPUT user2_in, 32
    dec rax
    mov [user2_len], rax
    mov rsi, user_in
    mov rdi, output_buf
    mov rcx, [user_len]
    test rcx, rcx
    jz .skip_first
    cld
    rep movsb
.skip_first:
    mov rsi, user2_in
    mov rcx, [user2_len]
    test rcx, rcx
    jz .cat_done
    rep movsb
.cat_done:
    mov rbx, [user_len]
    add rbx, [user2_len]
    PRINT catmsg, catmsg_len
    PRINT output_buf, rbx
    jmp mainmenu

; -----------------------------------------------------------
; 6. Palindrome Check
string_pal:
    PRINT strmsg, strmsg_len
    INPUT user_in, 32
    dec rax
    mov [user_len], rax
    mov rsi, user_in
    mov rcx, [user_len]
    add rsi, rcx
    dec rsi
    mov rdi, output_buf
    mov rbx, [user_len]
    test rbx, rbx
    jz .pal_zero
.revpal_loop:
    mov al, [rsi]
    mov [rdi], al
    dec rsi
    inc rdi
    dec rbx
    jnz .revpal_loop
.pal_zero:
    mov rsi, user_in
    mov rdi, output_buf
    mov rcx, [user_len]
    cld
    repe cmpsb
    jne not_pal
    PRINT palmsg, palmsg_len
    jmp mainmenu
not_pal:
    PRINT npalmsg, npalmsg_len
    jmp mainmenu

; -----------------------------------------------------------
; 7. Substring Search (fixed label scoping)
string_substr:
    PRINT strmsg, strmsg_len
    INPUT user_in, 32
    dec rax
    mov [user_len], rax
    PRINT str2msg, str2msg_len
    INPUT user2_in, 32
    dec rax
    mov [user2_len], rax
    mov rsi, user_in
    mov rcx, [user_len]
substr_outer_loop:
    cmp rcx, 0
    jle substr_notfound
    mov rdi, user2_in
    mov rbx, [user2_len]
    mov rdx, rsi
substr_inner_loop:
    cmp rbx, 0
    je substr_found
    mov al, [rdx]
    cmp al, [rdi]
    jne substr_next
    inc rdi
    inc rdx
    dec rbx
    jmp substr_inner_loop
substr_found:
    PRINT foundmsg, foundmsg_len
    jmp mainmenu
substr_next:
    inc rsi
    dec rcx
    jmp substr_outer_loop
substr_notfound:
    PRINT notfoundmsg, notfoundmsg_len
    jmp mainmenu
