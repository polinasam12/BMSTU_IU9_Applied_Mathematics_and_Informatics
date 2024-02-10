include mod2.asm
assume cs: code, ds: data

data segment
    strA db 201 DUP ('$')
    fileIn db 'fileIn.txt', 0
    fileOut db 'fileOut.txt', 0
    HANDLE1  DW ?
    HANDLE2  DW ?
    actLenDW dw ?
    maxIndDW dw ?
    strB DB 201 DUP ('$')
    strC DB 201 DUP ('$')
    dummy db 0Ah, '$'
data ends

code segment
start:	mov ax, data
		mov ds, ax

		openFile fileIn, HANDLE1, 0
        readFile strA,   HANDLE1, 200
        closeFile        HANDLE1

        lenCounter strA, actLenDW, maxIndDW
        reverseStr strA, strB, actLenDW
        reverseWords strB, strC, actLenDW, maxIndDW

        printStr strA
        printStr dummy
        printStr strC
        printStr dummy

        createFile fileOut , HANDLE2, 0
        openFile   fileOut,  HANDLE2, 2
        writeFile  strC,     HANDLE2, actLenDW
        closeFile HANDLE2

        exitProg

        code ends
        end start