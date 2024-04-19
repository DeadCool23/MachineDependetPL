#include "asm_string.H"

extern "C" { void __asm_strncpy(char* dst, const char *src, size_t len); }

/**
 * @brief Функция обертка для __asm_strcpy
 */
void asm_strncpy(char* dst, const char *src, size_t len) {
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

    __asm_strncpy(dst, src, len);
}