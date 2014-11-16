#line 1 "E:/Workplace/Projects/Embedded/PearlEnterprise/EngineAnalyzer/battery_analyzer_usb_module/v1/FirmwareProject/v1.0/Library/MCP3304.c"
#line 1 "e:/workplace/projects/embedded/pearlenterprise/engineanalyzer/battery_analyzer_usb_module/v1/firmwareproject/v1.0/library/mcp3304.h"




extern unsigned int MCP3304_Data;

void MCP3304_Init();
void MCP3304_Read(unsigned char Channel);
#line 1 "c:/users/jonayet/documents/mikroelektronika/mikroc pro for pic/include/built_in.h"
#line 4 "E:/Workplace/Projects/Embedded/PearlEnterprise/EngineAnalyzer/battery_analyzer_usb_module/v1/FirmwareProject/v1.0/Library/MCP3304.c"
void MCP3304_Init()
{
  LATB2_Bit  = 1;
  TRISB2_Bit  = 0;
 MCP3304_Data = 0;
}

unsigned int last_data = 0;
unsigned char D2D1, D0;
void MCP3304_Read(unsigned char Channel)
{

  LATB2_Bit  = 0;

 D0 = 0;
 D2D1 = 0;
 if(Channel & 0x01) { D0 = 0x80; }
 if(Channel & 0x02) { D2D1 = 0x01; }
 if(Channel & 0x04) { D2D1 |= 0x02; }


  SPI1_Read (0b00001000 | D2D1);


  ((char *)&MCP3304_Data)[1]  =  SPI1_Read (D0) & 0x1F;


  ((char *)&MCP3304_Data)[0]  =  SPI1_Read (0);


  LATB2_Bit  = 1;


 if(MCP3304_Data & 0x1000)
 {
 MCP3304_Data |= 0xE000;
 }
}
