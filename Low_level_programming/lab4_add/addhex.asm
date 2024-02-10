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

addition macro C, D, E, less, pass
    mov cx, lenAnsDW
    mov si, lenAnsDW
    sub si, 1
    mov ah, 0
    summ:
        mov al, numC[si]
        add al, numD[si]
        add al, ah
        cmp al, 16
        jl less
        mov ah, 1
        sub al, 16
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
    less:
        mov ah, 0
        cmp al, 9
        jg more9_2
        add al, 30h
        jmp pass10_2
    more9_2:
        add al, 37h
    pass10_2:
        mov numE[si], al
        dec si
    pass:
        loop summ
    endm

subtract macro C, D, E, subtr, less, pass, more9a, pass10a, more9b, pass10b
    mov cx, lenAnsDW
    mov si, lenAnsDW
    sub si, 1
    mov ah, 0
    subtr:
        mov al, C[si]
        sub al, ah
        cmp al, D[si]
        jl less
        mov ah, 0
        sub al, D[si]
        cmp al, 9
        jg more9a
        add al, 30h
        jmp pass10a
    more9a:
        add al, 37h
    pass10a:
        mov E[si], al
        dec si
        jmp pass
    less:
        mov ah, 1
        add al, 16
        sub al, D[si]
        cmp al, 9
        jg more9b
        add al, 30h
        jmp pass10b
    more9b:
        add al, 37h
    pass10b:
        mov E[si], al
        dec si
    pass:
        loop subtr
    endm

compareXY macro X, Y
    mov cx, lenAnsDW
    mov si, 0
    compare:
        mov ah, X[si]
        mov al, Y[si]
        cmp ah, al
        jg noswap
        jl swap
        inc si
        loop compare
    jmp noswap
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

numC DB 15 DUP (0), '$'
numD DB 15 DUP (0), '$'
numE DB 15 DUP (0), '$'
signA db 0
signB db 0
sign2 dw 0
actLenA dw ?
actLenB dw ?
lenAns db 15
lenAnsDW dw 15
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

        mov ah, signA
        mov al, signB

        cmp ax, 0
        je addit
        cmp ax, 1
        je subst
        cmp ax, 256
        je subst
        cmp ax, 257
        je addit
    addit:
        mov sign2, ax
        addition numC, numD, numE, less3, pass3
        jmp passSub
    subst:
        mov sign2, ax
        compareXY numC, numD
        noswap:
            subtract numC, numD, numE, subtr4, less4, pass4, more9a4, pass10a4, more9b4, pass10b4
            jmp passSub
        swap:
            subtract numD, numC, numE, subtr5, less5, pass5, more9a5, pass10a5, more9b5, pass10b5
            mov ax, sign2
            add ax, 100
            mov sign2, ax
            jmp passSub
    passSub:

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

        mov ax, sign2
        cmp ax, 257
        je printMinus
        cmp ax, 256
        je printMinus
        cmp ax, 101
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
