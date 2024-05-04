#include "matrix.h"

#include <chrono>
#include <iomanip>
#include <iostream>
#include <exception>

Matrix::Matrix(size_type n, size_type m, bool _rand) : n(n), m(m) {
    for (Matrix::size_type i = 0; i < n; ++i)
        for (Matrix::size_type j = 0; j < m; ++j)
            this->matrix[i][j] = _rand ? rand() : 0;
}

void Matrix::MatrixInput(void) {
    std::cout << "Input Matrix sizes: ";
    int tmp_n, tmp_m;
    try {
        std::cin >> tmp_n >> tmp_m;
    } catch (std::exception &e) {
        throw e;
    }

    if ((tmp_n < 0 || tmp_n > max_size) || (tmp_m < 0 || tmp_m > max_size))
        throw std::logic_error("Incorrect sizes");

    n = tmp_n; m = tmp_m;
    std::cout << "Input Matrix:" << std::endl;
    for (size_type i = 0; i < n; ++i) {
        for (size_type j = 0; j < m; ++j) {
            try {
                std::cin >> matrix[i][j];
            } catch (std::exception &e) {
                throw e;
            }
        }
    }
}

void Matrix::MatrixOutput(void) {
#define FORMAT std::setw(10)
    std::cout << "Matrix sizes: " << n << " " << m << std::endl;

    std::cout << "Matrix:" << std::endl;
    for (size_type i = 0; i < n; ++i) {
        for (size_type j = 0; j < m; ++j)
            std::cout << FORMAT << matrix[i][j];
        std::cout << std::endl;
    }
#undef FORMAT
}

Matrix Matrix::Transpose() const {
    Matrix res;
    res.n = this->m;
    res.m = this->n;

    for (size_type i = 0; i < this->n; i++)
        for (size_type j = 0; j < this->m; j++)
            res.matrix[j][i] = this->matrix[i][j];
    
    return res;
}

Matrix _asm::mult(const Matrix &fst, const Matrix &scd) {
    if (fst.m != scd.n) throw std::logic_error("Incorrect sizes for matrix multiplication");

    Matrix res;
    res.n = fst.n;
    res.m = scd.m;

    for (Matrix::size_type i = 0; i < fst.n; i++) {
        for (Matrix::size_type k = 0; k < scd.m; k++) {
            Matrix::value_type sum_el = 0;
            for (Matrix::size_type j = 0; j < fst.m; j++) {
                __asm__ (
                    "movl   %[fst_el], %%eax \n"
                    "movl   %[scd_el], %%ebx \n"
                    "imull  %%eax, %%ebx     \n"
                    "addl   %%ebx, %[sum_el] \n"
                    : [sum_el]"+r"(sum_el)
                    : [fst_el]"r"(fst.matrix[i][j]), [scd_el]"r"(scd.matrix[j][k])
                    : "%rax", "%rbx"
                );
            }
            res.matrix[i][k] = sum_el;
        }
    }

    return res;
}

Matrix _SSE::mult(const Matrix &fst, const Matrix &scd) {
    if (fst.m != scd.n) throw std::logic_error("Incorrect sizes for matrix multiplication");

    Matrix res;
    res.n = fst.n;
    res.m = scd.m;
    Matrix tscd = scd.Transpose();

    for (Matrix::size_type i = 0; i < fst.n; i++) {
        for (Matrix::size_type k = 0; k < scd.m; k++) {
            Matrix::value_type sum_el = 0;
            for (Matrix::size_type j = 0; j < fst.m; j += 4) {
                if (fst.m - j >= 4) {
                    __asm__ (
                        "movdqu (%[bfst_el]), %%xmm0 \n"
                        "movdqu (%[bscd_el]), %%xmm1 \n"
                        "pmullw  %%xmm1, %%xmm0      \n"
                        "phaddd %%xmm0, %%xmm0       \n"
                        "phaddd %%xmm0, %%xmm0       \n"

                        "movd %%xmm0, %%edx          \n"
                        "addl %%edx, %[sum_el]       \n"
                        : [sum_el]"+m"(sum_el)
                        : [bfst_el]"r"(fst.matrix[i] + j), [bscd_el]"r"(tscd.matrix[k] + j)
                        : "%rdi", "%rsi"
                    );
                } else {
                    for (Matrix::size_type _j = j; _j < fst.m; ++_j) {
                        __asm__ (
                            "movl   %[fst_el], %%eax \n"
                            "movl   %[scd_el], %%ebx \n"
                            "imull  %%eax, %%ebx     \n"
                            "addl   %%ebx, %[sum_el] \n"
                            : [sum_el]"+r"(sum_el)
                            : [fst_el]"r"(fst.matrix[i][_j]), [scd_el]"r"(tscd.matrix[k][_j])
                            : "%rax", "%rbx"
                        );
                    }
                }
            }
            res.matrix[i][k] = sum_el;
        }
    }

    return res;
}

Matrix _clang::mult(const Matrix &fst, const Matrix &scd) {
    if (fst.m != scd.n) throw std::logic_error("Incorrect sizes for matrix multiplication");

    Matrix res;
    res.n = fst.n;
    res.m = scd.m;

    for (Matrix::size_type i = 0; i < fst.n; ++i) {
        for (Matrix::size_type k = 0; k < scd.m; ++k) {
            double sum_el = 0;
            for (Matrix::size_type j = 0; j < fst.m; ++j)
                sum_el += fst.matrix[i][j] * scd.matrix[j][k];
            res.matrix[i][k] = sum_el;
        }
    }

    return res;
}