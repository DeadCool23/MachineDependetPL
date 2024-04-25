global __asm_memmove

section .text
__asm_memmove:
   ; Загружаем переданные параметры
   mov     rdi, [rsp + 8]  ; Загружаем параметр dst
   mov     rsi, [rsp + 16] ; Загружаем параметр src
   mov     rdx, [rsp + 24] ; Загружаем параметр len

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

      std ; устанавливаем DF = чтение в обратную сторону

   std_copy:
      rep movsb
      cld ; сбрасываем DF

   exit:
   ret
