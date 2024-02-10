assume cs: code, ds: data
.286

data segment
    minind dw 0
    strnum db "00000$"
    arr dw 3, 17, 11, 5, 21, 19, 30, 41, 18, 45
    lenarr dw 10
data ends

code segment

printnumber proc
    mov si, 4
	mov cx, 5
    mov bl, 10
	cycle:
		div bl
		mov strnum[si], ah
        add strnum[si], 48
		mov ah, 0
		dec si
	    loop cycle
	mov ah, 09h
	mov dx, offset strnum
	int 21h
	ret
printnumber endp

start:
    mov ax, data
    mov ds, ax

    mov si, 0
    mov cx, lenarr
    dec cx
    mov dx, 32767

    cycle1:
        mov ax, word ptr arr[si]
        mov bx, word ptr arr[si + 2]
        sub ax, bx
        cmp ax, 0
        jg notchsign
        neg ax
        notchsign:
        cmp ax, dx
        jg moremin
        mov dx, ax
        mov minind, si
        moremin:
        add si, 2
        loop cycle1

    mov ax, minind
    shr ax, 1
    call printnumber

    mov ax, 4c00h
    int 21h

code ends
end start