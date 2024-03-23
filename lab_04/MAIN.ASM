PUBLIC ROWS
PUBLIC COLS
PUBLIC MATRIX

EXTRN print_matrix: near
EXTRN input_matrix: near
EXTRN neighbor_swap: near

SSEG SEGMENT PARA PUBLIC 'STACK'
    db 200 dup (?)
SSEG ENDS

DSEG SEGMENT PARA PUBLIC 'DATA'
    ROWS db 0 ; Строки
    COLS db 0 ; Сторлбцы
    MATRIX db 9 * 9 dup (?)
DSEG ENDS

CSEG SEGMENT PARA PUBLIC 'CODE'
main:
    mov ax, DSEG
    mov DS, ax

    call input_matrix
    call neighbor_swap
    call print_matrix

    mov ax, 4c00h
    int 21h
CSEG ENDS
END main
