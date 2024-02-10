assume cs: code, ds: data
.286

data segment
    strnum db "00000$"
    newline db 13, 10, "$"
    a db 15
    b db 10
    c db 17
    d db 11
    ans dw ?
data ends

code segment

print proc   ; вывод строки strnum
	mov ah, 09h
	mov dx, offset strnum
	int 21h
	ret
print endp

printnumber proc
    mov si, 4   ; индекс в строке
	mov cx, 5   ; счетчик цикла
	cycle:
		div bl   ; получение цифры
		mov strnum[si], ah
        add strnum[si], 48
        cmp ah, 10
        jl number
		letter: add strnum[si], 7
        number:
		mov ah, 0
		sub si, 1
	loop cycle
	call print
	ret
printnumber endp

printnewline proc   ; переход на новую строку
    mov ah, 09h
    mov dx, offset newline
    int 21h
    ret
printnewline endp

start:
    mov ax, data
    mov ds, ax

;   (8 * a) / b + (c + d) / 2

;   (8 * a) / b
    mov ax, 0   ; ax = 0
    mov al, a   ; al = a
    shl ax, 3   ; ax = ax * 8
    div b   ; ax делится на b, целая часть помещается в al, остаток - в ah
    mov ah, 0   ; ah = 0
    mov bx, ax   ; bx = ax

;   (c + d) / 2
    mov ax, 0   ; ax = 0
    mov al, c   ; al = c
    mov cx, 0   ; cx = 0
    mov cl, d   ; cl = d
    add ax, cx   ; ax = ax + cx
    shr ax, 1   ; ax = ax / 2

;   (8 * a) / b + (c + d) / 2
    add ax, bx   ; ax = ax + bx

    mov ans, ax
    mov bl, 10
    call printnumber   ; вывод числа в десятичной системе
    call printnewline
    mov ax, ans
    mov bl, 16
	call printnumber   ; вывод числа в шестнадцатеричной системе

    mov ax, 4C00h
	int 21h

code ends
end start