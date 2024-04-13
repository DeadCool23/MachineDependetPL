.386
.model tiny

GMEM equ 0B800h      ; Сегмент видеопамяти
CLOCK_STYLE equ 02h  ; Стиль вывода часов

code segment use16
    assume  cs:code, ds:code
    org     100h
main:  
    jmp load
    old       dd  0
    is_loaded db 1
    buf       db  ' 00:00:00 ', 0

decode  proc
    mov     ah,  al
    and     al,  15
    shr     ah,  4
    add     al,  '0'
    add     ah,  '0'
    mov     buf[bx + 1],  ah
    mov     buf[bx + 2],  al
    add     bx,  3
    ret
decode  endp
 
clock   proc
    pushf
    call    cs:old
    push    ds
    push    es
    push    cs
    pop     ds
    pusha

    mov     ah,  2              ; функция BIOS для получения текущего времени
    int     1Ah                 ; прерывание BIOS

    xor     bx,  bx
    mov     al,  ch
    call    decode

    mov     al,  cl
    call    decode

    mov     al,  dh
    call    decode

    mov     ax,  GMEM
    mov     es,  ax
    xor     di,  [(80 - 10) * 2] ; Вывод в правом углу
    xor     bx,  bx
    mov     ah,  CLOCK_STYLE

    printer:   
        mov     al,  buf[bx]
        stosw
        inc     bx
        cmp     buf[bx],  0
        jnz     printer

    popa
    pop     es
    pop     ds
    iret
clock   endp

load:
    mov     ax,  351Ch
    int     21h

    cmp     es:is_loaded, 1
    je      exit
    
    lea     dx, load_msg
    mov     ah, 09h
    int 21h

    mov     word ptr old,  bx
    mov     word ptr old[2],  es

    mov     ax,  251Ch
    lea     dx,  clock
    int     21h

    lea     dx, load
    int     27h

exit:
    lea     dx, unload_msg
    mov     ah, 09h
    int     21h

    mov     ax, 251Ch
    mov     dx, word ptr es:old                       
    mov     ds, word ptr es:old[2]
    int     21h

    mov     ah, 49h
    int     21h

    mov     ax, 4c00h
    int     21h

load_msg db 'Clock are activated', '$', 10, 13, 0
unload_msg db 'Clock are diactivated', '$', 10, 13, 0

code ends
end main