include module.asm
assume cs: code, ds: data

data segment
    strA LABEL  BYTE
        maxA DB 150
        actA DB ?
        numA DB 150 DUP ('$')
    strB DB 150 DUP ('$')
    strC DB 150 DUP ('$')
    dummy db 0Ah, '$'
    actLenDW DW ?
    maxIndDW DW ?
data ends

code segment
start:	mov ax, data
		mov ds, ax

        inputStr strA, actA, actLenDW, maxIndDW
        printStr dummy
        reverseStr   strA, strB, actLenDW
        reverseWords strB, strC, actLenDW, maxIndDW
        printStr strC
        exitProg

        code ends
        end start