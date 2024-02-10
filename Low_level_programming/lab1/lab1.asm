assume cs: code, ds: data
.286

data segment
    a db 15
    b db 10
    c db 17
    d db 11
data ends

code segment
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

    mov ax, 04c00h
    int 21h

code ends
end start