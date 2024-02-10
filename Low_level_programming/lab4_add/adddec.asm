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

moveStr macro X, Y, XtoY, signX, actLn, more, less, minus, plus, noSign
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
        jge more
        jmp errExit
    more:
        cmp al, 39h
        jle less
        jmp errExit
    less:
        sub al, 30h
        mov Y[di], al
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
    endm

subtract macro C, D, E, subtr, less, pass
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
        add al, 30h
        mov E[si], al
        dec si
        jmp pass
    less:
        mov ah, 1
        add al, 10
        sub al, D[si]
        add al, 30h
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
        moveStr numA, numC, AtoC, signA, actLenA, more1, less1, minus1, plus1, noSign1

        inputStr inputB, strB, actB, actLenB
        moveStr numB, numD, BtoD, signB, actLenB, more2, less2, minus2, plus2, noSign2

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
            subtract numC, numD, numE, subtr4, less4, pass4
            jmp passSub
        swap:
            subtract numD, numC, numE, subtr5, less5, pass5
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
