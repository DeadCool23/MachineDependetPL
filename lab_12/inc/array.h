#ifndef __ARRAY_H__
#define __ARRAY_H__

#include <cstdint>
#include <iostream>
#include <initializer_list>

template <uint16_t N>
class Array {
    public:
        Array() = default;
        Array(std::initializer_list<int> lst);

        void print(void) const;
        int size(void) const { return _size; }
        Array<N> operator*(const Array<N> &other) const;

        ~Array() = default;

    protected:
        uint16_t _size;
        int arr[N];
};

template <uint16_t N>
Array<N>::Array(std::initializer_list<int> lst) : _size(N) {
    uint16_t i = 0;
    for (const auto &el : lst) {
        arr[i++] = el;
    }
}

template <uint16_t N>
Array<N> Array<N>::operator*(const Array<N> &other) const {
    Array<N> result;

    for (uint16_t i = 0; i < N; i += 4) {
        if (N - i > 4) {
            __asm__ volatile (
                "ld1 {v0.4s},[%[fst]]       \n"
                "ld1 {v1.4s},[%[scd]]       \n"
                "mul v2.4s, v0.4s, v1.4s    \n"
                "st1 {v2.4s},[%[res]]       \n"
                :
                : [fst]"r"(&this->arr[i]), [scd]"r"(&other.arr[i]), [res]"r"(&result.arr[i])
                : "v0", "v1", "v2"
            );
        } else {
            for ( ; i < N; ++i) {
                __asm__ volatile (
                    "ldr w0, [%[fst]]  \n"
                    "ldr w1, [%[scd]]  \n"
                    "mul w2, w0, w1    \n"
                    "str w2, [%[res]]  \n"
                    :
                    : [fst]"r"(&this->arr[i]), [scd]"r"(&other.arr[i]), [res]"r"(&result.arr[i])
                    : "w0", "w1", "w2"
                );
            }
        }
    }

    return result;
}

template <uint16_t N>
void Array<N>::print(void) const {
    std::cout << "[";
    for (uint16_t i = 0; i < N; i++) {
        std::cout << (!i ? "" : ", ") << this->arr[i];
    }
    std::cout << "]";
}

#endif // __ARRAY_H__