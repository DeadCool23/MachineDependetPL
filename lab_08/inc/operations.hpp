#ifndef __OPERATIONS_H__
#define __OPERATIONS_H__

namespace _asm {
    double Pi(void);
    double sin(double x);

    float sum_32(float fst, float scd);
    float mul_32(float fst, float scd);

    double sum_64(double fst, double scd);
    double mul_64(double fst, double scd);
}

namespace _clang {
    double sin(double x);

    float sum_32(float fst, float scd);
    float mul_32(float fst, float scd);

    double sum_64(double fst, double scd);
    double mul_64(double fst, double scd);
}

#endif // __OPERATIONS_H__