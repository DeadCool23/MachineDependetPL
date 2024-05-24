#include "strlen.h"

int arm::strlen(const char *str) {
    int len = 0;
    
    __asm__ (
        "mov r0, %[str]         \n"
        "mov r1, #0             \n"
        "loop:                  \n"
        "   ldrb r2, [r0], #1   \n"
        "   cmp r2, #0          \n"
        "   beq done            \n"
        "   add r1, r1, #1      \n"
        "   b loop              \n"

        "done:\n"
        "   mov %[len], r1\n"
        : [len] "=r" (len)
        : [str] "r" (str)
        : "r0", "r1", "r2"
    );

    return len;
}
