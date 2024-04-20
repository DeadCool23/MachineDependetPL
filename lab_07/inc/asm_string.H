#ifndef __STRING_H__
#define __STRING_H__

#include <stdlib.h>

namespace _asm {
    size_t strlen(const char* _str);
    void memmove(char* dst, const char *src, size_t len);
}

#endif // __STRING_H__