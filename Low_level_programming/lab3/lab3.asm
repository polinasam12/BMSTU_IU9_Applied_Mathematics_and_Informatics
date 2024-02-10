assume cs: code, ds: data

data segment
    dummy db 0Ah, '$'
    str1 db 100, 99 dup ("$")
    str2 db 100, 99 dup ("$")
data ends

code segment

strcpy proc
    push bp
	mov bp, sp
	
    cld
    mov si, [bp + 4]
    mov di, [bp + 6]
    push ds
    pop es
	mov cx, 0
    mov cl, [si + 1]
	add cx, 4
    rep movsb
    
	mov ax, [bp + 6]
    pop bp
    pop bx
    push ax
    push bx

	ret
strcpy endp

start:
    mov ax, data
	mov ds, ax

	mov dx, offset str1
	mov ax, 0
	mov ah, 0Ah
	int 21h
		
	mov dx, offset dummy
	mov ah, 09h
	int 21h

	mov dx, offset str2
	mov ah, 0Ah
	int 21h
		
	mov dx, offset dummy
	mov ah, 09h
	int 21h
		
	mov dx, offset str1
	push dx
	mov dx, offset str2
	push dx
	call strcpy

    pop dx

	add dx, 2
	mov ax, 0
	mov ah, 09h
	int 21h

	mov ah, 4ch
	int 21h
		
code ends
end start