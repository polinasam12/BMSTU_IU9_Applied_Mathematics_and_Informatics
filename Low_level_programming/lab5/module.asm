inputStr macro str2, actLen, LenDW, IndDW
    mov AH,0AH
    lea DX, str2
    int 21H
    mov ax, 0
    mov al, actLen
    mov LenDW, ax
    dec al
    mov IndDW, ax
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

reverseStr macro A, B, maxLen
        mov cx, maxLen
        mov si, maxLen
        inc si
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
