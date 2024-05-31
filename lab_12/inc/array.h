#ifndef __ARRAY_H__
#define __ARRAY_H__

#include <ostream>
#include <cstdint>
#include <initializer_list>

template <uint16_t N>
class Array {
    public:
        Array() = default;
        Array(std::initializer_list<int> lst);

        friend std::ostream& operator<< (std::ostream& os, const Array& arr);
        friend Array arm::neon::operator+(const Array &fst, const Array &scd);

        ~Array() = default;

    protected:
        uint16_t size = N;
        int arr[N]
};

template <uint16_t N>
std::ostream& operator<< (std::ostream& os, const Array<N>& arr);

namespace arm {
    namespace neon {
        template <uint16_t N>
        Array<N> operator+(const Array<N> &fst, const Array<N> &scd); 
    }
}

#endif // __ARRAY_H__