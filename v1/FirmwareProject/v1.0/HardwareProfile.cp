#line 1 "F:/Projects/Personal/Embedded System/Pearl Enterprise/battery_analyzer_usb_module/v1/FirmwareProject/v1.0/HardwareProfile.c"
#line 1 "f:/projects/personal/embedded system/pearl enterprise/battery_analyzer_usb_module/v1/firmwareproject/v1.0/hardwareprofile.h"








sbit _OP_SIG at LATC2_bit;
sbit _DR_SIG at TRISC2_bit;



void ConfigureIO();
void ConfigureModules();
void ConfigureInterrupts();
#line 1 "f:/projects/personal/embedded system/pearl enterprise/battery_analyzer_usb_module/v1/firmwareproject/v1.0/compilerdefinations.h"
#line 6 "F:/Projects/Personal/Embedded System/Pearl Enterprise/battery_analyzer_usb_module/v1/FirmwareProject/v1.0/HardwareProfile.c"
void ConfigureIO()
{

 PORTA = 0;
 PORtB = 0;
 PORTC = 0;
}



void ConfigureModules()
{

 ADCON1 = 6;


 CMCON = 7;
}



void ConfigureInterrupts()
{

 INTCON = 0;
}