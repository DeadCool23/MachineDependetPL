_CS SEGMENT BYTE public 'CODE'
calc:
    mov bl, al  ; записываю в bl (Для хранения)
    add bl, 32  ; Поиск в таблице ASCII буквы в младшем регистре

output:
    ; Вывод \n
    mov ah, 02h
    mov dl, 10
    int 21h 

    ; Вывод буквы в строчном варианте
    mov ah, 02h
    mov dl, bl
    int 21h 
    
    mov ax, 4C00h ; Код завершения
    int 21h
_CS ENDS
END