#include "matrix.h"
#include <iostream>

int main(void) {
    Matrix fst;
    std::cout << "First matrix input(fst)" << std::endl;
    fst.MatrixInput();
    std::cout << std::endl << std::endl;

    Matrix scd;
    std::cout << "Second matrix input(scd)" << std::endl;
    scd.MatrixInput();

    std::cout << std::endl << std::endl;
    Matrix res = _clang::mult(fst, scd);
    std::cout << "Clang multiply" << std::endl;
    res.MatrixOutput();

    res = _asm::mult(fst, scd);
    std::cout << std::endl << std::endl;
    std::cout << "ASM multiply" << std::endl;
    res.MatrixOutput();

    res = _SSE::mult(fst, scd);
    std::cout << std::endl << std::endl;
    std::cout << "SSE multiply" << std::endl;
    res.MatrixOutput();
}