#include <iostream>

#include "mes.hpp"

int main(void) {
    measure_32_bit();
    std::cout << std::endl;
    measure_64_bit();

    std::cout << std::endl;
    measure_sin();
}