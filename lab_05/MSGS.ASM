PUBLIC newline
PUBLIC print_msg

PUBLIC bint8_inv
PUBLIC huint16_inv
PUBLIC twodeg_mul_num_inv

; Коды ошибок
OK equ 0
ERR_OVERFLOW equ 1
ERR_IO equ 2
ERR_ACT equ 3
EMPTY_NUM equ 4
ERR_DEGREE equ 5

MSGS SEGMENT PARA PUBLIC USE16 'MSG'
    _ok db "$"
    overflow db "ERROR: Number overflow", 10, 13, '$'
    ioerror db "ERROR: Incorrect input", 10, 13, '$'
    acterror db "ERROR: Incorrect action", 10, 13, '$'
    no_num db "ERROR: No number input", 10, 13, '$'
    error_degree db "Divisible by any number", 10, 13, '$'
MSGS ENDS

PRINT_INVS SEGMENT PARA PUBLIC USE16 'MSGS'
    huint16_inv db "Hex uint16_t number: $"
    bint8_inv db "Bin int8_t number: $"
    twodeg_mul_num_inv db "Num divided by 2^$"
PRINT_INVS ENDS

CSEG SEGMENT BYTE PUBLIC USE16 'CODE'
; Вывод сообщения ощб ошибке
; В dx хранится код ошибки
print_msg proc near
    push ds
    push ax
    push bx
    push dx

    mov ax, MSGS
    mov ds, ax

    mov bx, dx
    lea dx, _ok

    cmp bx, ERR_OVERFLOW
    je _oveflow
    cmp bx, ERR_IO
    je _ioerror
    cmp bx, ERR_ACT
    je _acterror
    cmp bx, EMPTY_NUM
    je _emptnum
    cmp bx, ERR_DEGREE
    je _error_degree

    jne _end

_oveflow:
    lea dx, overflow
    jmp _end

_ioerror:
    lea dx, ioerror
    jmp _end

_acterror:
    lea dx, acterror
    jmp _end

_emptnum:
    lea dx, no_num
    jmp _end

_error_degree:
    lea dx, error_degree
    jmp _end

_end:
    mov ah, 9h
    int 21h
    
    call newline

    pop dx
    pop bx
    pop ax
    pop ds
    ret
print_msg endp

; Переход на новую строку
newline proc near
    push dx
    push ax 
    mov ah, 2
    mov dl, 10
    int 21h
    mov dl, 13
    int 21h
    pop ax
    pop dx
    ret
newline endp
CSEG ENDS
END