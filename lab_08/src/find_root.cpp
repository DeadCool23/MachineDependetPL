#include "find_root.hpp"

#include <math.h>
#include <limits>

double asm_find_root_of_sin(double beg, double end, std::size_t cnt /* double eps */) {
    double ans;

    double beg_val, end_val, step_val;

    double tmp_buf;
    __asm__ (
        "fldl    %[beg]        \n"
        "fldl    %[end]        \n"
        "fmulp                 \n"
        "fstpl   %[tmp_buf]    \n"

        "continue:             \n"
        "push    %[beg]        \n"
        "call __sin_func       \n"
        "pop     %[beg]        \n"
        "fstpl   %[beg_val]    \n"

        "push    %[end]        \n"
        "call __sin_func       \n"
        "pop     %[end]        \n"
        "fstpl   %[end_val]    \n"
        
        //  Количество итераций
        "movq    %[cnt], %%rcx \n"
        
        "finder:               \n"

        //  (end_val - beg_val)
        "   fldl    %[beg_val]  \n"
        "   fldl    %[end_val]  \n"
        "   fsubp               \n"

        //  (end - beg)
        "   fldl    %[beg]  \n"
        "   fldl    %[end]  \n"
        "   fsubp           \n"

        //  beg_val * (end - beg)
        "   fldl    %[beg_val]  \n"
        "   fmulp               \n"

        //  beg_val * (end - beg) / (end_val - beg_val);
        "   fdivp               \n"

        //  func = beg - beg_val * (end - beg) / (end_val - beg_val);
        "   fldl    %[end]  \n"
        "   fsubp           \n"
        
        "   fstpl   %[ans]       \n"  // ans = func
        "   push    %[ans]       \n"
        "   call __sin_func      \n"
        "   pop     %[ans]       \n"
        "   fstpl   %[step_val]  \n"

        "   fldl    %[ans]       \n"
        "   fldl    %[step_val]  \n"

        "   fstpl   %[beg_val]   \n"
        "   fstpl   %[beg]       \n"
        "   loop    finder       \n"

        "jmp __end               \n"

        // "   check_root:               \n"
        // "       fldl    %[step_val]   \n"
        // "       fabs                  \n"
        // "       fldl    %[eps]        \n"
        // "       fcompp                \n"
        // "       jl      finder        \n"
        // "       jmp     __end         \n"

        "__sin_func: \n"
        "   push     %%rbp         \n"
        "   mov      %%rsp, %%rbp  \n"
        "   fldl     8(%%rbp)      \n"
        "   fldl     8(%%rbp)      \n"
        "   fmulp                  \n"
        
        "   mov     $5, %%rax         \n"
        "   mov     %%rax, %[tmp_buf] \n"
        "   fildl   %4                \n"
        "   fldl    8(%%rbp)          \n"
        "   fmulp                     \n"

        "   faddp                     \n"

        "   fsin                      \n"

        "   pop     %%rbp  \n"
        "   ret            \n"

        "__end:                    \n"
        "   fldl    %[step_val]    \n"
        "   fstpl   %[ans]         \n"
        : [ans]"=m"(ans)
        : [beg]"m"(beg), [end]"m"(end), [cnt]"m"(cnt), [tmp_buf]"m"(tmp_buf), [beg_val]"m"(beg_val), [end_val]"m"(end_val), [step_val]"m"(step_val)
        : "%rax"
    );


    return ans;
}

double clang_find_root_of_sin(double beg, double end, std::size_t cnt /* double eps */) {
    auto __sin_func = [](double x) { return x * x + 5 * x; };


    auto beg_val = __sin_func(beg);
    auto end_val = __sin_func(end);

    double step;
    for (std::size_t i = 0; i < cnt; ++i) {
        step = beg - beg_val * (end - beg) / (end_val - beg_val);
        double step_val = __sin_func(step);

        beg_val = step_val;
        beg = step;
    }
    
    return step;
}
