PUBLIC unum16
PUBLIC phex_uint16_t
PUBLIC read_uint16_t
PUBLIC twodegree_mul_num
PUBLIC pbin_int8_from_uint16

; Функции
EXTRN newline: near
EXTRN pbin_int8_t: near
EXTRN conv_uint16_to_int8: near

EXTRN twodiv_inv: near
EXTRN print_degree: near
EXTRN calc_twodegree_mul_num: near

; Коды ошибок
OK equ 0
ERR_OVERFLOW equ 1
ERR_IO equ 2
EMPTY_NUM equ 4
ERR_DEGREE equ 5

; 16-ти разрядное число
UINT16_T SEGMENT BYTE PUBLIC USE16 'NUM'
    unum16 word (0)
UINT16_T ENDS

; Число в виде массива сиволов
STR_NUM SEGMENT BYTE public USE16 'DATA'
    num db 100 dup('$')
    num_inv db "Enter number: $"
STR_NUM ENDS

; Сообщение о действии
PRINT_INVS SEGMENT PARA PUBLIC USE16 'MSGS'
    huint16_inv db "Hex uint16_t number: $"
PRINT_INVS ENDS

CSEG SEGMENT BYTE PUBLIC USE16 'CODE'
; ===================================
; Считывание безнвкового целого числа
; dx - код ошибки
read_uint16_t proc near
    push ax
    push bx
    push ds
    push es
    
    mov ax, STR_NUM
    mov ds, ax

    call print_inv

    mov ah, 0Ah
    lea dx, num
    int 21h

    mov ax, UINT16_T
    mov es, ax

    call newline

    assume DS:STR_NUM, ES:UINT16_T
    mov cx, 0
    mov cl, num[1]
    mov ax, 0
    mov si, 0
    digits_read:
        cmp si, cx
        je _end

        mov bx, 10
        mul bx
        jo _err_overflow

        mov bl, num[si + 2]
        sub bx, '0'
        call check_digit
        cmp dx, 0
        jne _err_end
        add ax, bx
        jc _err_overflow

        add si, 1
        jmp digits_read
    
    _end:
    mov unum16, ax
    cmp si, 0
    je _err_size

    mov ax, UINT16_T
    mov ds, ax
    call newline

    _err_end:
    pop es
    pop ds
    pop bx
    pop ax
    ret

    _err_size:
    mov dx, ERR_IO
    jmp _err_end

    _err_overflow:
    mov dx, ERR_OVERFLOW
    jmp _err_end
read_uint16_t endp

; Приглашение ввода числа
print_inv proc near
    push ax
    push dx

    mov ah, 09h
    lea dx, num_inv
    int 21h

    pop dx
    pop ax
    ret
print_inv endp

; Проверка цифры
; bx - цифра
; dx - код ошибки
check_digit proc near
    mov dx, OK
    cmp bx, 0
    jl _err
    cmp bx, 9
    jg _err

    _end:
    ret

    _err:
    mov dx, ERR_IO
    jmp _end
check_digit endp

; ===========================
; Вывод числа в 16-ричной с/с
; dx - код ошибки
phex_uint16_t proc near
    push ax
    push bx
    push si
    push ds
    push es

    cmp dx, 2
    jle _check_err
    cmp dx, 4
    je _end

    _back:
    mov ax, seg unum16
    mov ds, ax

    call hinv
    mov ch, 4
    mov si, 0
    hex_digs_print:
        assume ds:UINT16_T
        mov bx, unum16
        mov ax, 0
        mov al, ch

        sub ax, 1
        mov dx, 4
        mul dx

        mov cl, al
        shr bx, cl
        and bl, 0Fh
        cmp bx, 0
        je print_zero

        printing_zero:
        call hprint_dig

        inc si

        non_printing_zero:      
        dec ch
        cmp ch, 0
        jne hex_digs_print
    
    call newline
    call newline
    mov dx, 0
    _end:
    pop es 
    pop ds
    pop si
    pop bx
    pop ax
    ret

    _check_err:
        cmp dx, OK
        je _back
        mov dx, EMPTY_NUM
        jmp _end

    print_zero:
        cmp ch, 1
        je printing_zero
        cmp si, 0
        je non_printing_zero
        jmp printing_zero
phex_uint16_t endp

; Печать цифры 16-ричной с/с
; bl - печатаемая цифра
hprint_dig proc near
    push ax
    push bx
    push dx

    mov ah, 2h
    mov dl, bl
    cmp dl, 10
    jl to_num_ascii
    jge to_letter_ascii

    printer:
    int 21h

    pop dx
    pop bx
    pop ax
    ret

    to_num_ascii:
        add dl, '0'
        jmp printer
    to_letter_ascii:
        sub dl, 10
        add dl, 'A'
        jmp printer
hprint_dig endp

; Сообщение о выводе числа в 16-ричной с/с
hinv proc near
    push ax
    push dx
    push ds

    mov ax, seg huint16_inv
    mov ds, ax

    mov ah, 09h
    lea dx, huint16_inv
    int 21h

    pop ds
    pop dx
    pop ax 
    ret
hinv endp

; =============================================
; Вывод сокращенного знакового числа в 2-ой с\с 
pbin_int8_from_uint16 proc near
    push ax
    push bx
    push ds

    cmp dx, 2
    jle _check_err
    cmp dx, 4
    je _end

_back:
    call conv_uint16_to_int8
    call pbin_int8_t
    call newline
    
    mov dx, 0
_end:
    pop ds
    pop bx
    pop ax
    ret

_check_err:
    cmp dx, OK
    je _back
    mov dx, EMPTY_NUM
    jmp _end
pbin_int8_from_uint16 endp

; ====================================================
; Вывод степень двойки, которой кратно введённое число
twodegree_mul_num proc near
    push ax
    push bx
    push ds

    cmp dx, 2
    jle _check_err
    cmp dx, 4
    je _end

_back:
    mov ax, seg unum16
    mov ds, ax
    assume DS:UINT16_T
    mov ax, unum16

    cmp ax, 0
    je not_degree

    call twodiv_inv
    call calc_twodegree_mul_num
    call print_degree
    call newline
    
    mov dx, 0
_end:
    pop ds
    pop bx
    pop ax
    ret

_check_err:
    cmp dx, OK
    je _back
    mov dx, EMPTY_NUM
    jmp _end

not_degree:
    mov dx, ERR_DEGREE
    jmp _end
twodegree_mul_num endp
CSEG ENDS
END