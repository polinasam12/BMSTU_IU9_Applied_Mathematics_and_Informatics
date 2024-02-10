assume cs: code, ds: data

data segment

strA LABEL  BYTE
    maxA DB 13
    actA DB ?
    numA DB 14 DUP ('$')

strB LABEL  BYTE
    maxB DB 13
    actB DB ?
    numB DB 14 DUP ('$')

numC DB 15 DUP (0), '$'
numD DB 15 DUP (0), '$'
numE DB 15 DUP (0), '$'
lenAns db 15
dummy db 0Ah, '$'

printAnsw db 'Answer : $'
inpA db 'Input A: $'
inpB db 'Input B: $'
errMsg2 db 'Wrong symbol: $'

data ends

code segment

dumm proc
    lea dx, dummy
    mov ah, 09h
    int 21h
    ret
    dumm endp

inputA proc
    lea dx, inpA
    mov ah, 09h
    int 21h
    ret
    inputA endp

inputB proc
    lea dx, inpB
    mov ah, 09h
    int 21h
    ret
    inputB endp

answ proc
    lea dx, printAnsw
    mov ah, 09h
    int 21h
    ret
    answ endp

start:	mov ax, data
		mov ds, ax

        call inputA
        MOV    AH,0AH
        LEA    DX, strA
        INT    21H
        call dumm

                mov cx, 0
                mov cl, actA

                mov si, 0
                mov ax, 0
                mov al, lenAns
                sub al, actA
                mov di, ax

        AtoC:
                mov al, numA[si]

                cmp al, 30h
                jge more1
                jmp errorExit2
            more1:
                cmp al, 39h
                jle less1
                jmp errorExit2

            less1:
                sub al, 30h
                mov numC[di], al
                inc di
                inc si
                loop AtoC

        call inputB
        MOV    AH,0AH
        LEA    DX, strB
        INT    21H
        call dumm

        mov cx, 0
        mov cl, actB
        mov si, 0
        mov ax, 0
        mov al, lenAns
        sub al, actB
        mov di, ax

        BtoD:
                mov al, numB[si]

                cmp al, 30h
                jge more2
                jmp errorExit2
            more2:
                cmp al, 39h
                jle less2
                jmp errorExit2

            less2:
                sub al, 30h
                mov numD[di], al
                inc di
                inc si
                loop BtoD

        mov cx, 0
        mov cl, lenAns


        mov ax, 0
        mov al, lenAns
        mov si, ax
        sub si, 1

        mov ah, 0

        summ:
                mov al, numC[si]
                add al, numD[si]
                add al, ah
                cmp al, 10

                jl less

                mov ah, 1
                sub al, 10
                add al, 30h
                mov numE[si], al
                dec si
                jmp pass
            less:
                mov ah, 0
                add al, 30h
                mov numE[si], al
                dec si

            pass:
                loop summ

        mov cx, 0
        mov cl, lenAns
        mov si, 0
        mov ah, 02h

        countZerros:
                mov al, numE[si]
                cmp al, 30h
                jne pass10
                inc si
                loop countZerros

        pass10:
            call answ
            mov ax, 0
            mov al, lenAns
            cmp ax, si
            je print0

            mov ah, 09h
            lea dx, [numE + si]
            int 21h
            jmp normalExit

        print0:
            lea dx, answ
            mov ah, 02h
            mov dl, 30h
            int 21h
            jmp normalExit

        errorExit2:
            lea dx, errMsg2
            mov ah, 09h
            int 21h
            mov ah, 02h
            mov dl, al
            int 21h
            jmp normalExit

        normalExit:
            mov ah, 4ch
            int 21h
            code ends
            end start