#include "operations.hpp"

#include <math.h>

double _asm::Pi(void) {
    double _pi;
    __asm__ (
        "fldpi     \n"
        "fstpl  %0 \n"
        : "=m"(_pi)
    );
    return _pi;
}

double _asm::sin(double x) {
    double _sin;
    __asm__ (
        "fldl   %1 \n"
        "fsin      \n"
        "fstpl  %0 \n"
        : "=m"(_sin)
        : "m"(x)
    );
    return _sin;
}

static double __sin(double x) { return sin(x); }
double _clang::sin(double x) { return __sin(x); }