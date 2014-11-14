#include "FloatConverter.h"

 char *ptr;
 char sign;
void ConvertIEEE754FloatToMicrochip(float *f)
{
   ptr = (char *)f;
   sign = ptr[3].B7;
   ptr[3] <<= 1;
   ptr[3].B0 = ptr[2].B7;
   ptr[2].B7 = sign;
}

void ConvertMicrochipFloatToIEEE754(float *f)
{
 ptr = (char *)f;
   sign = ptr[2].B7;
   ptr[2].B7 = ptr[3].B0;
   ptr[3] >>= 1;
   ptr[3].B7 = sign;
}