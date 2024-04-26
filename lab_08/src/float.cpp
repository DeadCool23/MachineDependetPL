#include "operations.hpp"

float _clang::sum_32(float fst, float scd) {
    return fst + scd;
}

float _asm::sum_32(float fst, float scd) {
    float sum;

    __asm__ (
        "flds %1 \n"
        "flds %2 \n"
        "faddp \n"
        "fstps %0 \n"
        : "=m"(sum)
        : "m"(fst), "m"(scd)
    );

    return sum;
}

float _clang::mul_32(float fst, float scd) {
    return fst + scd;
}

float _asm::mul_32(float fst, float scd) {
    float mul;

    __asm__ (
        "flds %1 \n"
        "flds %2 \n"
        "fmulp \n"
        "fstps %0 \n"
        : "=m"(mul)
        : "m"(fst), "m"(scd)
    );

    return mul;
}