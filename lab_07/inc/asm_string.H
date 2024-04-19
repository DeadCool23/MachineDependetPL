#ifndef __STRING_H__
#define __STRING_H__

#include <stdlib.h>

size_t asm_strlen(const char* _str);
void asm_strncpy(char* dst, const char *src, size_t len);
// extern "C" { void asm_strncpy(char* dst, const char *src, size_t len); }

#endif // __STRING_H__