STK SEGMENT BYTE STACK 'STACK'
    db 100 dup(?)
STK ENDS

_CS SEGMENT PARA public 'CODE'
main:
    ; Функция считывания символа
    ; Символ считывается в al
    mov ah, 01h
    int 21h 
_CS ENDS
END main