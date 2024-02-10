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
sign  db '+'

data ends

code segment

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

dumm proc
    lea dx, dummy
    mov ah, 09h
    int 21h
    ret
    dumm endp

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
                jge more30
                jmp errorExit2
            more30:
                cmp al, 39h
                jg more39
                sub al, 30h
                mov numC[di], al
                jmp breakCheckA
            more39:
                cmp al, 41h
                jge more41
                jmp errorExit2
            more41:
                cmp al, 46h
                jg more46
                sub al, 37h
                mov numC[di], al
                jmp breakCheckA
            more46:
                cmp al, 61h
                jge more61
                jmp errorExit2
            more61:
                cmp al, 66h
                jg more66
                sub al, 57h
                mov numC[di], al
                jmp breakCheckA
            more66:
                jmp errorExit2
            breakCheckA:
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
                jge more30B
                jmp errorExit2
            more30B:
                cmp al, 39h
                jg more39B
                sub al, 30h
                mov numD[di], al
                jmp breakCheckB
            more39B:
                cmp al, 41h
                jge more41B
                jmp errorExit2
            more41B:
                cmp al, 46h
                jg more46B
                sub al, 37h
                mov numD[di], al
                jmp breakCheckB
            more46B:
                cmp al, 61h
                jge more61B
                jmp errorExit2
            more61B:
                cmp al, 66h
                jg more66B
                sub al, 57h
                mov numD[di], al
                jmp breakCheckB
            more66B:
                jmp errorExit2
            breakCheckB:
                inc di
                inc si
                loop BtoD

        mov cx, 0
        mov cl, lenAns
        mov si, 0
        compare:
                mov ah, numC[si]
                mov al, numD[si]
                cmp ah, al
                jg noswap
                jl swap
                inc si
                loop compare
        jmp noswap

        swap:
                mov sign, '-'
                mov cx, 0
                mov cl, lenAns
                mov si, 0
        swaploop:
                mov ah, numC[si]
                mov al, numD[si]
                mov numD[si], ah
                mov numC[si], al
                inc si
                loop swaploop
        noswap:

        mov cx, 0
        mov cl, lenAns

        mov ax, 0
        mov al, lenAns
        mov si, ax
        sub si, 1

        mov ah, 0

        subtraction:
                mov al, numC[si]
                sub al, ah
                cmp al, numD[si]
                jl less

                mov ah, 0
                sub al, numD[si]

                cmp al, 9
                jg more9_1
                add al, 30h
                jmp pass10_1
            more9_1:
                add al, 37h
            pass10_1:

                mov numE[si], al
                dec si
                jmp pass
        less:   mov ah, 1
                add al, 16
                sub al, numD[si]

                cmp al, 9
                jg more9_2
                add al, 30h
                jmp pass10_2
            more9_2:
                add al, 37h
            pass10_2:

                mov numE[si], al
                dec si
        pass:   loop subtraction

        call answ

                mov al, sign
                cmp al, '-'
                jne plus

                mov ah, 02h
                mov dl, '-'
                int 21h
        plus:

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