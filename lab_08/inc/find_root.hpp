#ifndef __FIND_ROOT_HPP__
#define __FIND_ROOT_HPP__

#include <cstdlib>

// sin(x^2 * 5x)
double asm_find_root_of_sin(double beg, double end, std::size_t cnt /* double eps */);
double clang_find_root_of_sin(double beg, double end, std::size_t cnt /* double eps */);

#endif // __FIND_ROOT_HPP__