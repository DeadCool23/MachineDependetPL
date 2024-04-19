global __asm_strncpy

section .text
__asm_strncpy:
   pop     rax  ; Сохраняю адрес возврата

   pop     rdi
   pop     rsi
   pop     rdx

   push    rax ; Возращаю адрес возврата в стек

   ; Реализация
   mov     rcx, rdx
   cmp     rsi, rdi
   je      exit
   ; copy_loop:
   ;    mov     ax, [rsi]
   ;    mov     [rdi], ax
   ;    inc     rsi
   ;    inc     rdi
   ;    loop    copy_loop
   rep movsb; - решение в одну строку
   exit:
   ret
