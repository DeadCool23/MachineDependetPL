#include <iostream>

#include "array.h"
#include "strlen.h"

int main(void) {
    // ---
    char str[] = "Hello, world!";
    std::cout << "Length of string \"" << str << "\" is" << arm::strlen(str) << std::endl;

    // ---
    Array<5> fst = {1, 2, 3, 4, 5};
    Array<5> scd = {1, 2, 3, 4, 5};
    auto res = fst + scd;

    return ~0xFFFFFFFF;
}