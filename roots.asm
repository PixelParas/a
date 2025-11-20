extern printf,scanf
%macro PRINT 02
push rbp
mov rax,0
mov rdi,%1
mov rsi,%2
call printf
pop rbp
%endmacro
%macro SCAN 02
push rbp
mov rax,0
mov rdi,%1
mov rsi,%2
call scanf
pop rbp
%endmacro
%macro PRINTFLOAT 02
push rbp
mov rax,1
mov rdi,%1
movsd xmm0,%2
call printf
pop rbp
%endmacro
section .data
msg1 db "Enter a, b and c:",10,0
fmt_str db "%s",0
fmt_float db "%lf",0
msg_a_zero db "Not a quadratic equation (a = 0)",10,0
msg_real db "Roots are real and distinct",10,0
msg_equal db "Roots are real and equal",10,0
msg_cplx db "Roots are complex conjugates",10,0
msgR1 db "Root 1: ",0
msgR2 db "Root 2: ",0
msgRoot db "Root: ",0
plus_i db " + i",0
minus_i db " - i",0
newline db 10,0
section .bss
a resq 1
b resq 1
c resq 1
t1 resq 1
t2 resq 1
t3 resq 1
t4 resq 1
r1 resq 1
r2 resq 1
temp resw 1
section .text
global main
main:
; input
PRINT fmt_str,msg1
SCAN fmt_float,a
SCAN fmt_float,b
SCAN fmt_float,c
mov rax,[a]
test rax,rax
jne cont_quad
PRINT fmt_str,msg_a_zero
mov rax,0
ret
cont_quad:
finit
; t1 = b^2
fld qword [b]
fmul qword [b]
fstp qword [t1]
; t2 = 4ac
fld qword [a]
fmul qword [c]
mov word [temp],4
fimul word [temp]
fstp qword [t2]
; t1 = D = b^2 - 4ac
fld qword [t1]
fsub qword [t2]
fstp qword [t1]
; t2 = sqrt(|D|)
fld qword [t1]
fabs
fsqrt
fstp qword [t2]
; t3 = -b
fld qword [b]
fchs
fstp qword [t3]
; t4 = 2a
fld qword [a]
mov word [temp],2
fimul word [temp]
fstp qword [t4]
mov rax,[t1]
test rax,rax
js complex_case ; D < 0
je equal_case ; D == 0
real_case:
fld qword [t3]
fsub qword [t2]
fdiv qword [t4]
fstp qword [r1]
fld qword [t3]
fadd qword [t2]
fdiv qword [t4]
fstp qword [r2]
PRINT fmt_str,msg_real
PRINT fmt_str,newline
PRINT fmt_str,msgR1
PRINTFLOAT fmt_float,[r1]
PRINT fmt_str,newline
PRINT fmt_str,msgR2
PRINTFLOAT fmt_float,[r2]
PRINT fmt_str,newline
mov rax,0
ret
equal_case:
; r1 = -b / (2a)
fld qword [t3]
fdiv qword [t4]
fstp qword [r1]
PRINT fmt_str,msg_equal
PRINT fmt_str,newline
PRINT fmt_str,msgRoot
PRINTFLOAT fmt_float,[r1]
PRINT fmt_str,newline
mov rax,0
ret
complex_case:
fld qword [t3]
fdiv qword [t4]
fstp qword [r1]
fld qword [t2]
fdiv qword [t4]
fstp qword [r2]
PRINT fmt_str,msg_cplx
PRINT fmt_str,newline
; Root 1 = real + i imag
PRINT fmt_str,msgR1
PRINTFLOAT fmt_float,[r1]
PRINT fmt_str,plus_i
PRINTFLOAT fmt_float,[r2]
PRINT fmt_str,newline
; Root 2 = real - i imag
PRINT fmt_str,msgR2
PRINTFLOAT fmt_float,[r1]
PRINT fmt_str,minus_i
PRINTFLOAT fmt_float,[r2]
PRINT fmt_str,newline
mov rax,0
ret
