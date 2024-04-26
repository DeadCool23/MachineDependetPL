#include "operations.hpp"

double _clang::sum_64(double fst, double scd) {
    return fst + scd;
}

double _asm::sum_64(double fst, double scd) {
    double sum;

    __asm__ (
        "fldl %1 \n"
        "fldl %2 \n"
        "faddp \n"
        "fstpl %0 \n"
        : "=m"(sum)
        : "m"(fst), "m"(scd)
    );

    return sum;
}

double _clang::mul_64(double fst, double scd) {
    return fst + scd;
}

double _asm::mul_64(double fst, double scd) {
    double mul;

    __asm__ (
        "fldl %1 \n"
        "fldl %2 \n"
        "fmulp \n"
        "fstpl %0 \n"
        : "=m"(mul)
        : "m"(fst), "m"(scd)
    );

    return mul;
}