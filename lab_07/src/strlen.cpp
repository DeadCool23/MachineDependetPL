#include <stdio.h>
#include "asm_string.H"

size_t asm_strlen(const char* _str) {
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
