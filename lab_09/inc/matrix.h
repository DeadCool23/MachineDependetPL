#ifndef __MATRIX_H__
#define __MATRIX_H__

#include <cstdlib>
#include "matrix_mult.h"

struct Matrix {
    using value_type = int;
    using size_type = std::size_t;
    static const size_type max_size = 100;

public:
    size_type n, m;
    value_type matrix[max_size][max_size];

    void MatrixInput(void);
    Matrix(void) : n(0), m(0) {};
    Matrix(size_type n, size_type m, bool _rand = true);

    void MatrixOutput(void);

    Matrix Transpose(void) const;
    friend Matrix _asm::mult(const Matrix &fst, const Matrix &scd);
    friend Matrix _SSE::mult(const Matrix &fst, const Matrix &scd);
    friend Matrix _clang::mult(const Matrix &fst, const Matrix &scd);
};

#endif // __MATRIX_H__