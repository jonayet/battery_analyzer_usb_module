#line 1 "F:/Projects/Personal/Embedded System/Pearl Enterprise/battery_analyzer_usb_module/v1/FirmwareProject/v1.0/Interrupt.c"
#line 1 "f:/projects/personal/embedded system/pearl enterprise/battery_analyzer_usb_module/v1/firmwareproject/v1.0/hardwareprofile.h"








sbit _OP_SIG at LATA0_bit;
sbit _DR_SIG at TRISA0_bit;



void ConfigureIO();
void ConfigureModules();
void ConfigureInterrupts();
#line 1 "f:/projects/personal/embedded system/pearl enterprise/battery_analyzer_usb_module/v1/firmwareproject/v1.0/compilerdefinations.h"
#line 6 "F:/Projects/Personal/Embedded System/Pearl Enterprise/battery_analyzer_usb_module/v1/FirmwareProject/v1.0/Interrupt.c"
void interrupt()
{

 USBDev_IntHandler();
}

void interrupt_low()
{

}
