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
    std::cout << "Fst arr: "; fst.print(); std::cout << std::endl;
    std::cout << "Scd arr: "; scd.print(); std::cout << std::endl;
    
    auto res = fst * scd;
    std::cout << std::endl << "Multiply result: "; res.print(); std::cout << std::endl;


    res.print();

    return ~0xFFFFFFFF;
}