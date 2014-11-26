#line 1 "F:/Projects/Personal/Embedded System/Pearl Enterprise/battery_analyzer_usb_module/v1/FirmwareProject/v1.0/Library/FloatConverter.c"
#line 1 "f:/projects/personal/embedded system/pearl enterprise/battery_analyzer_usb_module/v1/firmwareproject/v1.0/library/floatconverter.h"
void ConvertIEEE754FloatToMicrochip(float *f);
void ConvertMicrochipFloatToIEEE754(float *f);
#line 3 "F:/Projects/Personal/Embedded System/Pearl Enterprise/battery_analyzer_usb_module/v1/FirmwareProject/v1.0/Library/FloatConverter.c"
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
