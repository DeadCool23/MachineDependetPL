#include <iostream>

#include "mes.hpp"
#include "find_root.hpp"

int main(void) {
    measure_32_bit();
    std::cout << std::endl;
    measure_64_bit();

    std::cout << std::endl;
    measure_sin();

    std::cout << std::endl;
    find_root_mes();

    return ~0xFFFFFFFF;
}