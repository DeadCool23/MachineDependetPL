EXTRN ROWS: byte
EXTRN COLS: byte
EXTRN MATRIX: byte

SSEG SEGMENT PARA COMMON 'STACK'
SSEG ENDS

DSEG SEGMENT PARA COMMON 'DATA'
DSEG ENDS

MSG SEGMENT PARA COMMON 'MSG'
    mtr_inv db "Matrix input", 10, 13, '$'
    size_inv db "Size input", 10, 13, '$'
    mtr_new db "New matrix", 10, 13, '$'
MSG ENDS

CSEG SEGMENT PARA PUBLIC 'CODE'
    assume CS:CSEG, DS:DSEG
; Реализация выводов
newline proc near
    mov ah, 2
    mov dl, 10
    int 21h
    mov dl, 13
    int 21h
    ret
newline endp

msg_choose proc near
    cmp bx, 1h
    je msize_inv
    cmp bx, 2h
    je mmtr_inv
    cmp bx, 3h
    je mmtr_new
    ret

msize_inv:
    lea dx, size_inv
    ret
mmtr_inv:
    lea dx, mtr_inv
    ret
mmtr_new:
    lea dx, mtr_new
    ret
msg_choose endp


msg_out proc near
    push DS

    mov ax, MSG
    mov ds, ax

    mov ah, 9h
    call msg_choose

    int 21h
    pop DS
    ret
msg_out endp

print_matrix proc near
    mov bx, 3h
    call msg_out
    mov ch, 0
    mov di, 0
    print_row:
        mov bx, 0
        mov cl, 0
        print_col:
            mov ah, 2h
            mov dl ,matrix[di][bx]
            int 21h

            inc bx

            call space

            inc cl
            cmp cl, COLS
            jne print_col

        call newline

        add di, 9

        inc ch
        cmp ch, ROWS
        jne print_row
        
    call newline
    ret
print_matrix endp

space proc near
    mov ah, 2h
    mov dl, " "
    int 21h
    ret
space endp

; Реализация вводов
input_num proc near
    mov ah, 1h
    int 21h
    mov bl, al
    sub bl, "0" ; Получаю реальное число а не ASCII код
    ret
input_num endp

input_matrix proc near
    mov bx, 1h
    call msg_out
    call input_num
    mov ROWS, bl

    call space

    call input_num
    mov COLS, bl

    call newline

    mov bx, 2h
    call msg_out
    mov ch, 0
    mov si, 0
    input_row:
        mov bx, 0
        mov cl, 0
        input_col:
            mov ah, 1h
            int 21h

            mov matrix[si][bx], al
            inc bx

            call space

            inc cl
            cmp cl, COLS
            jne input_col

        call newline

        add si, 9

        inc ch
        cmp ch, ROWS
        jne input_row
        
    call newline
    ret
input_matrix endp
CSEG ENDS
END