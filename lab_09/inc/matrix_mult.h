#ifndef __MATRIX_MULT_H__
#define __MATRIX_MULT_H__

#include <cstdlib>

struct Matrix;

namespace _asm { Matrix mult(const Matrix &fst, const Matrix &scd); };
namespace _SSE { Matrix mult(const Matrix &fst, const Matrix &scd); };
namespace _clang { Matrix mult(const Matrix &fst, const Matrix &scd); };

#endif // __MATRIX_MULT_H__