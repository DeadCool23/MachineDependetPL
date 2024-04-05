.386
PUBLIC pbin_int8_t
PUBLIC conv_uint16_to_int8

EXTRN unum16: word

EXTRN newline: near

UINT16_T SEGMENT BYTE COMMON USE16 'NUM'
UINT16_T ENDS

INT8_T SEGMENT BYTE PUBLIC USE16 'NUM'
    num8 byte (0)
INT8_T ENDS

PRINT_INVS SEGMENT PARA PUBLIC USE16 'MSGS'
    bint8_inv db "Bin int8_t number: $"
PRINT_INVS ENDS

CSEG SEGMENT BYTE PUBLIC USE16 'CODE'
; ================================
; Преобразование uint16_t в int8_t
conv_uint16_to_int8 proc near
    push ax
    push bx
    push ds

    mov ax, seg unum16
    mov ds, ax

    assume DS:UINT16_T
    mov bx, unum16

    mov ax, seg num8
    mov ds, ax

    assume DS:INT8_T
    mov num8, bl
    
    pop ds
    pop bx
    pop ax
    ret
conv_uint16_to_int8 endp

; =======================
; Вывод int8_t в 2-о1 с/с
pbin_int8_t proc near
    push ax
    push bx
    push dx
    push ds

    call binv

    mov ax, seg num8
    mov ds, ax

    assume DS:INT8_T
    mov bx, 0
    mov bl, num8
    call get_sign
    cmp bh, 0
    je no_sign
    call print_minus

    no_sign:
    mov cx, 7
    mov dx, 0
    print_bdigits:
        dec cx
        bt bx, cx
        inc cx
        jc _print_one
        jnc _print_zero

        printed_num:
        inc dx
        not_printing_zero:
        dec cx
        cmp cx, 0
        jne print_bdigits

    call newline
    pop ds
    pop dx
    pop bx
    pop ax
    ret

    _print_one:
        call print_one
        jmp printed_num

    _print_zero:
        cmp cx, 1
        je to_print
        cmp dx, 0
        je not_print

        to_print:
        call print_zero
        jmp printed_num
        not_print:
        jmp not_printing_zero
pbin_int8_t endp

; Вывод единицы
print_one proc near
    push ax
    push dx

    mov ah, 2h
    mov dl, '1'
    int 21h

    pop dx
    pop ax
    ret
print_one endp

; Вывод нуля
print_zero proc near
    push ax
    push dx

    mov ah, 2h
    mov dl, '0'
    int 21h

    pop dx
    pop ax
    ret
print_zero endp

; Вывод минуса
print_minus proc near
    push ax
    push dx

    mov ah, 2h
    mov dl, '-'
    int 21h

    pop dx
    pop ax
    ret
print_minus endp

; Получение знака числа
; bl - число
; bh - знак
; Если число отрицальное то оно преобразуется в доп код
get_sign proc near
    bt bx, 7
    jc is_neg
    jnc is_pos

    _end:
    ret

    is_neg:
        mov bh, 1
        neg bl
    is_pos:
        jmp _end
get_sign endp

; Сообщение о выводе числа в 2-ичной с/с
binv proc near
    push ax
    push dx
    push ds

    mov ax, seg bint8_inv
    mov ds, ax

    mov ah, 09h
    lea dx, bint8_inv
    int 21h

    pop ds
    pop dx
    pop ax 
    ret
binv endp
CSEG ENDS
END