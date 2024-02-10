lenCounter macro string, LenDW, IndDW
        mov si, 0
        mov bx, 0
    cnt:
        mov al, string[si]
        cmp al, 24h
        je passCount
        inc bx
        inc si
        jmp cnt
    passCount:
        mov lenDW, bx
        dec bx
        mov IndDW, bx
    endm

printStr macro str1
    lea dx, str1
    mov ah, 09h
    int 21h
    endm

exitProg macro
    mov ah, 4ch
    int 21h
    endm

inputStr macro str2
    mov AH,0AH
    lea DX, str2
    int 21H
    endm

reverseStr macro A, B, LenDW
        mov cx, LenDW
        mov si, LenDW
        dec si
        mov di, 0
    AtoB:
        mov al, A[si]
        mov B[di], al
        inc di
        dec si
        loop AtoB
    endm

reverseWords macro X, Y, maxLen, maxInd
    mov si, 0
    mov bl, 0
    XtoY:
        mov al, X[si]
        cmp al, 20h
        je spaceXtoY
        mov bl, 0
        mov di, si
        cntWords:
            mov al, X[di]
            cmp al, 20h
            je cntBreak
            cmp di, maxInd
            je cntBreak2
            inc di
            inc bl
        jmp cntWords

        jmp pass
        cntBreak2:
        inc si
        pass:

        cntBreak:
        dec si
        swapWord:
            mov al, X[di]
            mov Y[si], al
            inc si
            dec di
            dec bl
            cmp bl, 0
        jge swapWord
        mov bl, 0
        jmp passCopy
        spaceXtoY:
            mov bl, 0
            mov Y[si], al
            inc si
        passCopy:
            cmp si, maxLen
    jl XtoY
    endm

openFile macro fileName, descriptor, mode
    MOV  AH, 3DH
    MOV  AL, mode
    LEA  DX, fileName
    INT  21H
    MOV  descriptor, AX
    endm

createFile macro fileName, descriptor, mode
    MOV  AH,3CH
    MOV  CX, mode
    LEA  DX, fileName
    INT  21H
    MOV  descriptor,AX
    endm

readFile macro strName, descriptor, length
    MOV  AH, 3FH
    MOV  BX, descriptor
    MOV  CX, length
    LEA  DX, strName
    INT  21H
    endm

closeFile macro descriptor
    MOV  AH,3EH
    MOV  BX, descriptor
    INT  21H
    endm

writeFile macro string, descriptor, lenDW
    MOV  AH, 40H
    MOV  BX, descriptor
    MOV  CX, lenDW
    LEA  DX, string
    INT  21H
    endm
