#line 1 "E:/Workplace/Projects/Embedded/PearlEnterprise/EngineAnalyzer/VoltageCurrentReadingModule/v1/FirmwareProject/v1.0/HardwareProfile.c"
#line 1 "e:/workplace/projects/embedded/pearlenterprise/engineanalyzer/voltagecurrentreadingmodule/v1/firmwareproject/v1.0/hardwareprofile.h"
#line 16 "e:/workplace/projects/embedded/pearlenterprise/engineanalyzer/voltagecurrentreadingmodule/v1/firmwareproject/v1.0/hardwareprofile.h"
void ConfigureIO();
void ConfigureModules();
void ConfigureInterrupts();
#line 1 "e:/workplace/projects/embedded/pearlenterprise/engineanalyzer/voltagecurrentreadingmodule/v1/firmwareproject/v1.0/compilerdefinations.h"
#line 6 "E:/Workplace/Projects/Embedded/PearlEnterprise/EngineAnalyzer/VoltageCurrentReadingModule/v1/FirmwareProject/v1.0/HardwareProfile.c"
void ConfigureIO()
{

 PORTA = 0;
 PORtB = 0;
 PORTC = 0;


  RB1_bit  = 0;
  TRISB1_bit  = 0;


  RB0_bit  = 0;
  TRISB0_bit  = 1;
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
