printStr macro strng
    mov ah, 09h
    lea dx, strng
    int 21h
    endm

printSymb macro symb
    mov ah, 02h
    mov dl, symb
    int 21h
    endm

inputStr macro prompt, string, act, actDW
    lea dx, prompt
    mov ah, 09h
    int 21h
    MOV    AH,0AH
    LEA    DX, string
    INT    21H
    mov ax, 0
    mov al, act
    mov actDW, ax
    lea dx, dummy
    mov ah, 09h
    int 21h
    endm

moveStr macro X, Y, XtoY, signX, actLn, more, less, minus, plus, noSign, more30, more39, more41, more46, more61, more66, brCheck
        mov di, lenAnsDW
        sub di, actLn
        mov al, X[0]
        cmp al, '-'
        je minus
        cmp al, '+'
        je plus
        jmp noSign
    minus:
        mov signX, 1
        mov cx, actLn
        dec cx
        mov si, 1
        inc di
        jmp XtoY
    plus:
        mov cx, actLn
        dec cx
        mov si, 1
        inc di
        jmp XtoY
    noSign:
        mov cx, actLn
        mov si, 0
        jmp XtoY

    XtoY:
        mov al, X[si]
        cmp al, 30h
        jge more30
        jmp errExit
    more30:
        cmp al, 39h
        jg more39
        sub al, 30h
        mov Y[di], al
        jmp brCheck
    more39:
        cmp al, 41h
        jge more41
        jmp errExit
    more41:
        cmp al, 46h
        jg more46
        sub al, 37h
        mov Y[di], al
        jmp brCheck
    more46:
        cmp al, 61h
        jge more61
        jmp errExit
    more61:
        cmp al, 66h
        jg more66
        sub al, 57h
        mov Y[di], al
        jmp brCheck
    more66:
        jmp errExit
    brCheck:
        inc di
        inc si
        loop XtoY
    endm

multip macro
    mov ax, 0
    mov al, lenAns
    mov di, ax
    sub di, 1
    mov count, 0

    bigLoop:
            mov ax, 0
            mov al, lenAns
            mov si, ax
            sub si, 1

            mov cx, 0
            mov cl, actA
            add cl, 1
            mov bh, 0

    multiple:
            mov al, numC[si]
            mov bl, numD[di]
            mul bl
            add al, bh

            mov bl, 16
            div bl

            mov bh, al

            sub si, count
            mov tmp1[si], ah
            add si, count
            dec si

            loop multiple

            mov cx, 0
            mov cl, lenAns

            mov ax, 0
            mov al, lenAns
            mov si, ax
            sub si, 1

            mov ah, 0

            summ:
                    mov al, tmp1[si]
                    add al, numE[si]
                    add al, ah
                    cmp al, 16
                    jl less

                    mov ah, 1
                    sub al, 16
                    mov numE[si], al
                    dec si

                    jmp pass
                less:
                    mov ah, 0
                    mov numE[si], al
                    dec si

                pass:
                    loop summ

            dec di
            inc count

            mov cx, 0
            mov cl, lenAns

            mov ax, 0
            mov al, lenAns
            mov si, ax
            sub si, 1

        purgeTmp1:
            mov tmp1[si], 0
            dec si
            loop purgeTmp1

            mov ax, 0
            mov al, lenAns
            sub al, 1
            mov bl, actB

            sub al, bl

            cmp di, ax
            je breakBigLoop

            jmp bigLoop
    breakBigLoop:
    endm

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

numC DB 30 DUP (0), '$'
numD DB 30 DUP (0), '$'
numE DB 30 DUP (0), '$'
tmp1 DB 30 DUP (0), '$'
signA db 0
signB db 0
count dw 0
actLenA dw ?
actLenB dw ?
lenAns db 30
lenAnsDW dw 30
dummy db 0Ah, '$'

printAnsw db 'Answer : $'
inputA db 'Input A: $'
inputB db 'Input B: $'
errMsg db 'Wrong symbol: $'

data ends

code segment

start:	mov ax, data
		mov ds, ax

        inputStr inputA, strA, actA, actLenA
        moveStr numA, numC, AtoC, signA, actLenA, more1, less1, minus1, plus1, noSign1, more30a, more39a, more41a, more46a, more61a, more66a, brChecka

        inputStr inputB, strB, actB, actLenB
        moveStr numB, numD, BtoD, signB, actLenB, more2, less2, minus2, plus2, noSign2, more30b, more39b, more41b, more46b, more61b, more66b,brCheckb

        multip

        mov cx, lenAnsDW
        mov si, 0

    toASCII:
            mov al, numE[si]

            cmp al, 9
            jg more9_1
            add al, 30h
            jmp pass10_1
        more9_1:
            add al, 37h
        pass10_1:

            mov numE[si], al
            inc si
            loop toASCII

mov cx, lenAnsDW
    mov si, 0

    countZerros:
            mov al, numE[si]
            cmp al, 30h
            jne pass10
            inc si
            loop countZerros
    pass10:

        printStr printAnsw

        mov ax, lenAnsDW
        cmp ax, si
        je print0

        mov ah, signA
        mov al, signB

        cmp ax, 1
        je printMinus
        cmp ax, 256
        je printMinus

        jmp answer
    printMinus:
        printSymb '-'

    answer:
        mov ah, 09h
        lea dx, [numE + si]
        int 21h
        jmp normalExit

    print0:
        printSymb '0'
        jmp normalExit

    errExit:
        printStr errMsg
        printSymb al
        jmp normalExit

    normalExit:
        mov ah, 4ch
        int 21h

    code ends
    end start
