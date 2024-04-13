.model TINY

CSEG SEGMENT
    assume CS:CSEG
    org 100h
main:
    jmp init

    handler_addr    dd 0
    is_init         db 1
    cur_time        db 0
    cur_speed       db 1Fh

inc_input_speed proc near
    pushf
    call cs:handler_addr

    mov ah, 02h
    int 1Ah

    cmp dh, cur_time
    je skip_speed_change

    mov cur_time, dh
    sub cur_speed, 5

    cmp cur_speed, 1Fh
    jbe set_speed
    
    mov cur_speed, 1Fh

set_speed:
    mov al, 0F3h
    out 60h, al

    mov al, cur_speed
    out 60h, al

skip_speed_change:
    iret
inc_input_speed endp

init:
    mov     ax, 351Ch
    int     21h

    cmp     es:is_init, 1
    je      exit

    mov     word ptr handler_addr, bx
    mov     word ptr handler_addr[2], es

    mov     ax, 251Ch
    lea     dx, inc_input_speed
    int     21h

    lea     dx, init_msg
    mov     ah, 09h
    int     21h

    lea     dx, init
    int     27h

exit:
    lea     dx, exit_msg
    mov     ah, 09h
    int     21h

    mov     al, 0F3h
    out     60h, al

    mov     al, 0
    out     60h, al
    
    mov     dx, word ptr es:handler_addr                       
    mov     ds, word ptr es:handler_addr[2]
    mov     ax, 251Ch
    int     21h

    mov     ah, 49h
    int     21h

    mov     ax, 4c00h
    int     21h
	
    init_msg db 'Delay activated', '$', 10, 13
    exit_msg db 'Delay diactivated', '$', 10, 13
CSEG ENDS
END main