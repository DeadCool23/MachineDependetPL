#include "tests.H"

#include <iostream>

int main(void) {
    uint16_t failed = asm_strlen_testing() + asm_memmove_testing();
    std::cout << "Test FAILED: " << failed << std::endl;
    return failed;
}