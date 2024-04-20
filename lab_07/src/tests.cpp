#include "tests.H"
#include "asm_string.H"

#include <iostream>
#include <string.h>

static int asm_strlen_test(const char *str) {
    auto real_size = strlen(str);
    auto asm_size = _asm::strlen(str);
    auto is_correct = (real_size == asm_size);
    std::cout << "Test: " << str << std::endl;
    std::cout << "Real size: " << real_size << std::endl;
    std::cout << "Asm size: " << asm_size << std::endl;
    std::cout << "Result: " << (is_correct 
        ? "Passed" 
        : "Failed"
    ) << std::endl << std::endl;
    return !is_correct;
}

int asm_strlen_testing(void) {
    return 
        asm_strlen_test("") +
        asm_strlen_test("T") +
        asm_strlen_test("Test1") +
        asm_strlen_test("TestLong");
}

static int asm_memmove_test(const char *dst, const char *src, size_t len) {
    char rbuf[strlen(dst)];
    char asmbuf[strlen(dst)];
    strcpy(rbuf, dst); strcpy(asmbuf, dst);
    memmove(rbuf, src, len); _asm::memmove(asmbuf, src, len);
    auto is_correct = !strcmp(rbuf, asmbuf);
    std::cout << "Test: {"  << std::endl;
    std::cout << "    Dst: " << dst << std::endl;
    std::cout << "    Src: " << src << std::endl;
    std::cout << "    Len: " << len << std::endl;
    std::cout << "}"  << std::endl;
    std::cout << "Real copy: " << rbuf << std::endl;
    std::cout << "Asm copy: " << asmbuf << std::endl;
    std::cout << "Result: " << (is_correct 
        ? "Passed" 
        : "Failed"
    ) << std::endl << std::endl;
    return !is_correct;
}

int asm_memmove_testing(void) {
    return
        asm_memmove_test("efghij", "abc", 1) +
        asm_memmove_test("efghij", "abc", 2);
}
