PUBLIC quit

EXTRN newline: near

EXTRN print_msg: near

EXTRN proc_act: near
EXTRN print_menu: near

SSEG SEGMENT PARA PUBLIC USE16 'STACK'
    db 200 dup (?)
SSEG ENDS

CSEG SEGMENT BYTE PUBLIC USE16 'CODE'
; Окончание программы
quit proc near
    mov ax, 4c00h
    int 21h
    ret
quit endp

main:
    mov dx, 4
    while_true:
        call print_menu

        mov ah, 1h
        int 21h
        call newline

        sub al, '0'
        call proc_act
        cmp dx, 0
        je no_error
        call print_msg
        no_error:
            jmp while_true

CSEG ENDS
END main