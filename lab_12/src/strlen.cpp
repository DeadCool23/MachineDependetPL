#include "strlen.h"

#include <iostream>

int arm::strlen(const char *str) {
    std::size_t len = 0;

    __asm__ volatile (
        "mov x0, %[str]       \n"
        "mov x1, #0           \n"

        // Цикл счетчика
        "1:                   \n"
        "   ldrb w2, [x0], #1 \n"
        "   cbz w2, 2f        \n"
        "   add x1, x1, #1    \n"
        "   b 1b              \n"

        "2:                   \n"
        "   mov %[len], x1    \n"
        : [len] "=r" (len)
        : [str] "r" (str)
        : "x0", "x1", "x2"
    );

    return len;
}
