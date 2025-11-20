%macro READ 02
mov rax,00
mov rdi,00
mov rsi,%1
mov rdx,%2
syscall
%endmacro
%macro WRITE 02
mov rax,01
mov rdi,01
mov rsi,%1
mov rdx,%2
syscall
%endmacro
%macro EXIT 00
mov rax,60
mov rdi,00
syscall
%endmacro
section .data
menu db 10,"1.BCD to Hex",10
db "2.Hex to BCD",10
db "3.EXIT",10
db "Enter your choice: "
menulen equ $-menu
msg1 db "Enter BCD number: "
len1 equ $-msg1
msg2 db "BCD to Hex converted number is : "
len2 equ $-msg2
msg3 db "Enter HEX number: "
len3 equ $-msg3
msg4 db "Hex to BCD converted number is : "
len4 equ $-msg4


msg5 db 10,"Exit",10
len5 equ $-msg5
msg6 db 10,"Invalid choice",10
len6 equ $-msg6
nl db 10
nll equ $-nl
section .bss
char_buff resb 17
actl resq 1
ans resq 1
num resq 1
cnt resb 1
x resb 1
choice resb 2
section .text
global _start
_start:
WRITE menu,menulen
READ choice,02
cmp byte [choice],31H
je bcd2hex
cmp byte [choice],32H
je hex2bcd
cmp byte [choice],33H
je exit
WRITE msg6,len6
jmp _start
bcd2hex:
WRITE msg1,len1
READ char_buff,17
dec rax
mov [actl],rax
mov rsi,char_buff
mov rax,0
mov rbx,0AH
l1:
mul rbx
mov rdx,0
mov dl,byte [rsi]
sub dl,30H
add rax,rdx
inc rsi
dec qword [actl]
jnz l1

mov [ans],rax
WRITE msg2,len2
mov rbx,[ans]
call display
WRITE nl,nll
jmp _start
hex2bcd:
WRITE msg3,len3
call accept
mov [num],rbx
mov byte [cnt],0
mov rax,[num]
l2:
mov rdx,0
mov rbx,0AH
div rbx
push rdx
inc byte [cnt]
cmp rax,0
jne l2
WRITE msg4,len4
l3:
pop rdx
add dl,30H
mov byte [x],dl
WRITE x,01
dec byte [cnt]
jnz l3
WRITE nl,nll
jmp _start
exit:
WRITE msg5,len5
EXIT
accept:
READ char_buff,17
dec rax
mov [actl],rax
mov rsi,char_buff
mov rbx,0
up:
shl rbx,4
mov rdx,0
mov dl,byte [rsi]
cmp dl,39H
jbe sub30
sub dl,07H
sub30:

sub dl,30H
add rbx,rdx
inc rsi
dec qword [actl]
jnz up
ret
display:
mov rsi,char_buff
mov rcx,16
above:
rol rbx,4
mov dl,bl
and dl,0FH
cmp dl,09H
jbe add30d
add dl,07H
add30d:
add dl,30H
mov byte [rsi],dl
inc rsi
dec rcx
jnz above
WRITE char_buff,16
ret
