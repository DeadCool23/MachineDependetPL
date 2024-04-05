PUBLIC twodiv_inv
PUBLIC print_degree
PUBLIC calc_twodegree_mul_num

EXTRN newline: near

; Сообщение вывода степени двойки
PRINT_INVS SEGMENT PARA PUBLIC USE16 'MSGS'
    twodeg_mul_num_inv db "Num divided by 2^$"
PRINT_INVS ENDS

CSEG SEGMENT BYTE PUBLIC USE16 'CODE'
; Подсчет степени двойки, которой кратно число
; ax - Число
; dl - степень двойки
calc_twodegree_mul_num proc near
    push ax
    push bx
    push cx

    mov bx, 1
    mov cx, 0
    mov dl, 0
    find_degree:
        mov cx, ax
        and cx, bx
        cmp cx, 0
        jne _end

        inc dl
        shl bx, 1
        jmp find_degree

    _end:
    pop cx
    pop bx
    pop ax
    ret
calc_twodegree_mul_num endp

; Сообщение вывода степени двойки
twodiv_inv proc near
    push ax
    push dx
    push ds

    mov ax, seg twodeg_mul_num_inv
    mov ds, ax

    mov ah, 09h
    lea dx, twodeg_mul_num_inv
    int 21h

    pop ds
    pop dx
    pop ax 
    ret
twodiv_inv endp

; Вывод степени
; dl - степень
print_degree proc near
    push ax
    push dx

    mov ah, 2h
    add dl, '0'
    cmp dl, '9'
    jg print_older
    continue:
    int 21h

    call newline

    pop dx
    pop ax
    ret

    print_older:
    mov dh, dl
    mov dl, '1'
    int 21h
    mov dl, dh
    sub dl, 10
    jmp continue
print_degree endp
CSEG ENDS
END