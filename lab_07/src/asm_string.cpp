#include <stdio.h>
#include "asm_string.H"

size_t _asm::strlen(const char* _str) {
    size_t len = 0;

    __asm__ (
        "mov     rdi, %1\n\t"
        "mov     rcx, -1\n\t"
        "xor     al, al\n\t"
        "repne   scasb\n\t"
        "not     rcx\n\t"
        "dec     rcx\n\t"
        "mov     %0, rcx\n\t"
        : "=r"(len)
        : "m"(_str)
        : "%rax", "%rcx", "%rdi"
    );

    return len;
}

extern "C" { void __asm_memmove(char* dst, const char *src, size_t len); }

/**
 * @brief Функция обертка для __asm_strcpy
 */
void _asm::memmove(char* dst, const char *src, size_t len) {
    __asm__ (
        "mov rdx, %0 \n\t "
        "mov rsi, %1 \n\t "
        "mov rdi, %2 \n\t "
        "push rdx \n\t "
        "push rsi \n\t "
        "push rdi \n\t "
        :
        : "r"(len), "r"(src), "r"(dst)
        : "rsi", "rdi", "rdx"
    );

    __asm_memmove(dst, src, len);
}
