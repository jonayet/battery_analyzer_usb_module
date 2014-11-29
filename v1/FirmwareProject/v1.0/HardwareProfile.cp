#line 1 "E:/Workplace/Projects/Embedded/PearlEnterprise/EngineAnalyzer/battery_analyzer_usb_module/v1/FirmwareProject/v1.0/HardwareProfile.c"
#line 1 "e:/workplace/projects/embedded/pearlenterprise/engineanalyzer/battery_analyzer_usb_module/v1/firmwareproject/v1.0/hardwareprofile.h"








sbit _OP_SIG at LATA0_bit;
sbit _DR_SIG at TRISA0_bit;



void ConfigureIO();
void ConfigureModules();
void ConfigureInterrupts();
#line 1 "e:/workplace/projects/embedded/pearlenterprise/engineanalyzer/battery_analyzer_usb_module/v1/firmwareproject/v1.0/compilerdefinations.h"
#line 6 "E:/Workplace/Projects/Embedded/PearlEnterprise/EngineAnalyzer/battery_analyzer_usb_module/v1/FirmwareProject/v1.0/HardwareProfile.c"
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
