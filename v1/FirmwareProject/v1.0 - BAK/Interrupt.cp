#line 1 "E:/Workplace/Projects/Embedded/PearlEnterprise/EngineAnalyzer/VoltageCurrentReadingModule/v1/FirmwareProject/v1.0/Interrupt.c"
#line 1 "e:/workplace/projects/embedded/pearlenterprise/engineanalyzer/voltagecurrentreadingmodule/v1/firmwareproject/v1.0/hardwareprofile.h"
#line 16 "e:/workplace/projects/embedded/pearlenterprise/engineanalyzer/voltagecurrentreadingmodule/v1/firmwareproject/v1.0/hardwareprofile.h"
void ConfigureIO();
void ConfigureModules();
void ConfigureInterrupts();
#line 1 "e:/workplace/projects/embedded/pearlenterprise/engineanalyzer/voltagecurrentreadingmodule/v1/firmwareproject/v1.0/compilerdefinations.h"
#line 6 "E:/Workplace/Projects/Embedded/PearlEnterprise/EngineAnalyzer/VoltageCurrentReadingModule/v1/FirmwareProject/v1.0/Interrupt.c"
void interrupt()
{

 USB_Interrupt_Proc();
}
