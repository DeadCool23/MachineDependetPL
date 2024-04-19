#include "tests.H"

#include <iostream>

int main(void) {
    auto failed = asm_strlen_testing() + asm_strncpy_testing();
    std::cout << "Test FAILED: " << failed << std::endl;
    return failed;
}