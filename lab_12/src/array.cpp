#include <array.h>

template <uint16_t N>
Array<N>::Array(std::initializer_list<int> lst) : size(N) {
    for (uint16_t i = 0; i < lst.size(); ++i) {
        arr[i] = lst[i];
    }
}

template <uint16_t N>
Array<N> arm::neon::operator+(const Array<N> &fst, const Array<N> &scd) {
    int i = 0;
    for (i = 0; i < (N / 4) * 4; i += 4)
    {
        asm volatile("ld1 {v0.4s},[%[fst]]\n"
        "ld1 {v1.4s},[%[scd]]\n"
        "add v2.4s,v0.4s,v1.4s\n"
        "st1 {v2.4s},[%[c]]\n"
        :
        :[fst]"r"(&fst.arr[i]), [scd]"r"(&scd[i]), [c]"r"(&c[i])
        :"v0" ,"v1","v2"
        );
    }
    for (; i < N; i++)
    {
        asm volatile(
            "ldr w0, [%[fst]]\n"
            "ldr w1, [%[scd]]\n"
            "add w2, w0,w1\n"
            "str w2,[%[c]]\n"
            :
            :[fst]"r"(&fst.arr[i]), [scd]"r"(&scd[i]),[c] "r" (&c[i])
            :"w0","w1","w2"
            );
    }
}

template <uint16_t N>
std::ostream& operator<< (std::ostream& os, const Array<N>& arr) {
    os << "[";
    for (uint16_t i = 0; i < N; i++) {
        os << (!i ? "", ", ") << arr.arr[i];
    }
    os << "]";
}