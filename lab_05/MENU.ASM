; Функции
EXTRN quit: near
EXTRN phex_uint16_t: near
EXTRN read_uint16_t: near
EXTRN twodegree_mul_num: near
EXTRN pbin_int8_from_uint16: near

; Коды ошибок
ERR_ACT equ 3

PUBLIC proc_act
PUBLIC print_menu

EXTRN newline: near


SSEG SEGMENT PARA COMMON USE16 'STACK'
SSEG ENDS

MENUS SEGMENT PARA PUBLIC USE16 'MENU'
    inv_to_menu db "------------MENU------------", 10, 13, '$'
    entr db "1: Entry number(unsigned short)", 10, 13, '$'
    shprint db "2: Print hex number(unsigned short)", 10, 13, '$'
    cbprint db "3: Print bin number(signed char)", 10, 13, '$'
    two_task db "4: degree of two that is mult of num", 10, 13, '$'
    ext db "5: Exit", 10, 13, '$'
    inv_to_choose db 10, "Enter action: $"

    funcs dw 1 dup(read_uint16_t)
          dw 1 dup(phex_uint16_t)
          dw 1 dup(pbin_int8_from_uint16)
          dw 1 dup(twodegree_mul_num)
          dw 1 dup(quit)
MENUS ENDS

CSEG SEGMENT BYTE PUBLIC USE16 'CODE'
ASSUME DS:MENUS
; Выполнение переданной команды
; al - номер команды
; dx - код возврата
proc_act proc near
    push ax
    push bx

    mov bx, 0
    mov bl, al

    mov ax, MENUS
    mov ds, ax

    cmp bx, 0
    jle _eend
    cmp bx, 5
    jg _eend

    cmp bx, 1

    assume DS:MENUS
    sub bx, 1
    mov ax, bx
    mov bx, 2
    mul bx

    mov bx, ax

    call funcs[bx]

_end:
    pop bx
    pop ax 
    ret

_eend:
    mov dx, ERR_ACT
    jmp _end
proc_act endp

; Вывод меню
print_menu proc near
    push dx
    push ds
    mov ax, MENUS
    mov ds, ax

    mov ah, 9h
    lea dx, inv_to_menu
    int 21h

    lea dx, entr
    int 21h

    lea dx, shprint
    int 21h

    lea dx, cbprint
    int 21h

    lea dx, two_task
    int 21h

    lea dx, ext
    int 21h

    lea dx, inv_to_choose
    int 21h

    pop ds
    pop dx
    ret
print_menu endp
CSEG ENDS
END