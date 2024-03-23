EXTRN ROWS: byte
EXTRN COLS: byte
EXTRN MATRIX: byte

PUBLIC neighbor_swap

SSEG SEGMENT PARA COMMON 'STACK'
SSEG ENDS

_DSEG SEGMENT PARA COMMON 'DATA'
    REST db ?
_DSEG ENDS

DSEG SEGMENT PARA COMMON 'DATA'
DSEG ENDS

CSEG SEGMENT PARA PUBLIC 'CODE'
    assume CS:CSEG, DS:DSEG
neighbor_swap proc near
    mov ch, 0
    mov si, 0
    mov di, 9h
    mov al, ROWS
    swap_row:
        cmp al, 1
        jle _end
        mov bx, 0
        mov cl, 0
        swap_col:
            xchg ah, MATRIX[si][bx]
            xchg ah, MATRIX[di][bx]
            xchg ah, MATRIX[si][bx]
            inc bx

            inc cl
            cmp cl, COLS
            jne swap_col


        add si, [9 * 2]
        add di, [9 * 2]

        inc ch
        sub al, 2
        cmp ch, ROWS
        jne swap_row
    
    _end:
    ret
neighbor_swap endp
CSEG ENDS
END