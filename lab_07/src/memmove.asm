global __asm_memmove

section .text
__asm_memmove:
   pop     rax  ; Сохраняю адрес возврата

   pop     rdi
   pop     rsi
   pop     rdx

   push    rax ; Возращаю адрес возврата в стек

   ; Реализация
   mov     rcx, rdx
   cmp     rsi, rdi
   je      exit

   cmp     rsi, rdi
   jg      std_copy

   mov     rax, rdi
   sub     rax, rsi

   cmp     rax, rcx
   jge     std_copy

   reverse_copy:
      add   rdi, rcx
      dec   rdi
      add   rsi, rcx
      dec   rsi

      std

   std_copy:
      rep movsb
      cld

   exit:
   ret
