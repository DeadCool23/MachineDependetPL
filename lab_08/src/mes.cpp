#include "mes.hpp"

#include <chrono>
#include <iomanip>
#include <iostream>
#include <functional>

#include "operations.hpp"

#define COUNT 1000

static std::size_t fmes_32(const std::function<float(float, float)> &f, std::size_t count) {
    auto start = std::chrono::high_resolution_clock::now();
    float fst = 1362.21, scd = 1212.312;

    for (int i = 0; i < count; ++i) 
        (void)f(fst, scd);

    auto end = std::chrono::high_resolution_clock::now();
    auto duration = std::chrono::duration_cast<std::chrono::nanoseconds>(end - start);
    return duration.count() / count;
}

void measure_32_bit(void) {
    std::cout << "---32-bit float num measuring---" << std::endl;

    std::cout << std::endl << "All funcs reply 1000 times" << std::endl;

    std::cout << std::endl << "Sum measures {" << std::endl;
    std::cout << "\tSum by C: " << fmes_32(_clang::sum_32, COUNT) << "ns" << std::endl;
    std::cout << "\tSum by ASM: " << fmes_32(_asm::sum_32, COUNT) << "ns" << std::endl;
    std::cout << "}" << std::endl;

    std::cout << std::endl;

    std::cout << std::endl << "Mul measures {" << std::endl;
    std::cout << "\tMul by C: " << fmes_32(_clang::mul_32, COUNT) << "ns" << std::endl;
    std::cout << "\tMul by ASM: " << fmes_32(_asm::mul_32, COUNT) << "ns" << std::endl;
    std::cout << "}" << std::endl;

    std::cout << std::endl;
    std::cout << "---32-bit float measuring end---" << std::endl;
}

static std::size_t fmes_64(const std::function<double(double, double)> &f, std::size_t count) {
    auto start = std::chrono::high_resolution_clock::now();
    double fst = 1362.21, scd = 1212.312;

    for (int i = 0; i < count; ++i) 
        (void)f(fst, scd);

    auto end = std::chrono::high_resolution_clock::now();
    auto duration = std::chrono::duration_cast<std::chrono::nanoseconds>(end - start);
    return duration.count() / count;
}

void measure_64_bit(void) {
    std::cout << "---64-bit float num measuring---" << std::endl;

    std::cout << std::endl << "All funcs reply 1000 times" << std::endl;
    
    std::cout << std::endl << "Sum measures {" << std::endl;
    std::cout << "\tSum by C: " << fmes_32(_clang::sum_64, COUNT) << "ns" << std::endl;
    std::cout << "\tSum by ASM: " << fmes_32(_asm::sum_64, COUNT) << "ns" << std::endl;
    std::cout << "}" << std::endl;

    std::cout << std::endl;

    std::cout << std::endl << "Mul measures {" << std::endl;
    std::cout << "\tMul by C: " << fmes_32(_clang::mul_64, COUNT) << "ns" << std::endl;
    std::cout << "\tMul by ASM: " << fmes_32(_asm::mul_64, COUNT) << "ns" << std::endl;
    std::cout << "}" << std::endl;

    std::cout << std::endl;
    std::cout << "---64-bit float measuring end---" << std::endl;
}

#define Small_PI 3.14
#define Big_PI 3.141596
#define ASM_PI _asm::Pi()

static void clang_mes_sin(void) {
    std::cout << "Sin by Clang {" << std::endl;

    std::cout << "\tSin(" << Small_PI << ") = " << _clang::sin(Small_PI) << std::endl;
    std::cout << "\tSin(" << Big_PI << ") = " << _clang::sin(Big_PI) << std::endl;
    std::cout << "\tSin(" << ASM_PI << ") = " << _clang::sin(ASM_PI) << std::endl;

    std::cout << std::endl;

    std::cout << "\tSin(" << Small_PI << " / 2)  = " << _clang::sin(Small_PI / 2) << std::endl;
    std::cout << "\tSin(" << Big_PI << " / 2) = " << _clang::sin(Big_PI / 2) << std::endl;
    std::cout << "\tSin(" << ASM_PI << " / 2) = " << _clang::sin(ASM_PI / 2) << std::endl;

    std::cout << "}" << std::endl;
}

static void asm_mes_sin(void) {
    std::cout << "Sin by ASM {" << std::endl;

    std::cout << "\tSin(" << Small_PI << ") = " << _asm::sin(Small_PI) << std::endl;
    std::cout << "\tSin(" << Big_PI << ") = " << _asm::sin(Big_PI) << std::endl;
    std::cout << "\tSin(" << ASM_PI << ") = " << _asm::sin(ASM_PI) << std::endl;

    std::cout << std::endl;

    std::cout << "\tSin(" << Small_PI << " / 2)  = " << _asm::sin(Small_PI / 2) << std::endl;
    std::cout << "\tSin(" << Big_PI << " / 2) = " << _asm::sin(Big_PI / 2) << std::endl;
    std::cout << "\tSin(" << ASM_PI << " / 2) = " << _asm::sin(ASM_PI / 2) << std::endl;

    std::cout << "}" << std::endl;
}

void measure_sin(void) {
    std::cout << "---Sinus measure start---" << std::endl;

    std::cout << std::endl << "Note: " << ASM_PI << " - ASM_PI by fldpy" << std::endl;

    std::cout << std::endl;

    clang_mes_sin();

    std::cout << std::endl;

    asm_mes_sin();

    std::cout << "---Sinus measure end---" << std::endl;
}

#define BEG 0.2
#define END 0.8

#define CNT 100

#include "find_root.hpp"

void find_root_mes(void) {
    std::cout << "Find root of sin(x^2 + 5x) on [" << BEG << ", " << END << "] {" << std::endl;
    std::cout << "\tCpp root: " << clang_find_root_of_sin(BEG, END, CNT) << std::endl;
    std::cout << "\tASM root: " << asm_find_root_of_sin(BEG, END, CNT) << std::endl;
    std::cout << "}" << std::endl;
}

#undef CNT

#undef END
#undef BEG

#undef BigPI
#undef ASM_PI
#undef SmallPI