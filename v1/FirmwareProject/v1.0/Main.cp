#line 1 "E:/Workplace/Projects/Embedded/PearlEnterprise/EngineAnalyzer/battery_analyzer_usb_module/v1/FirmwareProject/v1.0/Main.c"
#line 1 "e:/workplace/projects/embedded/pearlenterprise/engineanalyzer/battery_analyzer_usb_module/v1/firmwareproject/v1.0/hardwareprofile.h"








sbit _OP_SIG at LATA0_bit;
sbit _DR_SIG at TRISA0_bit;



void ConfigureIO();
void ConfigureModules();
void ConfigureInterrupts();
#line 1 "e:/workplace/projects/embedded/pearlenterprise/engineanalyzer/battery_analyzer_usb_module/v1/firmwareproject/v1.0/compilerdefinations.h"
#line 1 "e:/workplace/projects/embedded/pearlenterprise/engineanalyzer/battery_analyzer_usb_module/v1/firmwareproject/v1.0/library/floatconverter.h"
void ConvertIEEE754FloatToMicrochip(float *f);
void ConvertMicrochipFloatToIEEE754(float *f);
#line 1 "e:/workplace/projects/embedded/pearlenterprise/engineanalyzer/battery_analyzer_usb_module/v1/firmwareproject/v1.0/library/mcp3304.h"




extern unsigned int MCP3304_Data;

void MCP3304_Init();
void MCP3304_Read(unsigned char Channel);
#line 1 "c:/users/jonayet/documents/mikroelektronika/mikroc pro for pic/include/built_in.h"
#line 1 "e:/workplace/projects/embedded/pearlenterprise/engineanalyzer/battery_analyzer_usb_module/v1/firmwareproject/v1.0/library/usbhelper.h"
#line 1 "c:/users/jonayet/documents/mikroelektronika/mikroc pro for pic/include/stdint.h"




typedef signed char int8_t;
typedef signed int int16_t;
typedef signed long int int32_t;


typedef unsigned char uint8_t;
typedef unsigned int uint16_t;
typedef unsigned long int uint32_t;


typedef signed char int_least8_t;
typedef signed int int_least16_t;
typedef signed long int int_least32_t;


typedef unsigned char uint_least8_t;
typedef unsigned int uint_least16_t;
typedef unsigned long int uint_least32_t;



typedef signed char int_fast8_t;
typedef signed int int_fast16_t;
typedef signed long int int_fast32_t;


typedef unsigned char uint_fast8_t;
typedef unsigned int uint_fast16_t;
typedef unsigned long int uint_fast32_t;


typedef signed int intptr_t;
typedef unsigned int uintptr_t;


typedef signed long int intmax_t;
typedef unsigned long int uintmax_t;
#line 3 "e:/workplace/projects/embedded/pearlenterprise/engineanalyzer/battery_analyzer_usb_module/v1/firmwareproject/v1.0/library/usbhelper.h"
extern unsigned char readbuff[];
extern unsigned char writebuff[];




extern uint8_t UsbNewPacketReceived;
extern uint8_t UsbPacketSentComplete;

uint8_t HID_WriteBuffer();
#line 39 "E:/Workplace/Projects/Embedded/PearlEnterprise/EngineAnalyzer/battery_analyzer_usb_module/v1/FirmwareProject/v1.0/Main.c"
sbit LCD_EN at LATC1_bit;
sbit LCD_RS at LATC0_bit;
sbit LCD_D7 at LATB5_bit;
sbit LCD_D6 at LATB4_bit;
sbit LCD_D5 at LATB3_bit;
sbit LCD_D4 at LATB2_bit;


sbit LCD_EN_Direction at TRISC1_bit;
sbit LCD_RS_Direction at TRISC0_bit;
sbit LCD_D7_Direction at TRISB5_bit;
sbit LCD_D6_Direction at TRISB4_bit;
sbit LCD_D5_Direction at TRISB3_bit;
sbit LCD_D4_Direction at TRISB2_bit;


unsigned char readbuff[64] absolute 0x500;
unsigned char writebuff[64] absolute 0x540;










unsigned int MCP3304_Data;

void SaveNonVolatileConstants(unsigned char musk);
void LoadNonVolatileConstants();

unsigned int lastChannel1Value = 0;
unsigned int lastChannel2Value = 0;



void main()
{
 char txt[10];
 unsigned char i = 0;
 unsigned char nvConstantMusk = 0;
 unsigned char buffIndex = 0;
 unsigned int AbsValue = 0;
 unsigned int Counter = 0;


 ConfigureIO();
 ConfigureModules();
 ConfigureInterrupts();
#line 102 "E:/Workplace/Projects/Embedded/PearlEnterprise/EngineAnalyzer/battery_analyzer_usb_module/v1/FirmwareProject/v1.0/Main.c"
 SPI1_Init_Advanced(_SPI_MASTER_OSC_DIV16, _SPI_DATA_SAMPLE_MIDDLE, _SPI_CLK_IDLE_LOW, _SPI_LOW_2_HIGH);


 USBDev_HIDInit();


 USBDev_Init();


 IPEN_bit = 1;
 USBIP_bit = 1;
 USBIE_bit = 1;
 GIEH_bit = 1;


 MCP3304_Init();


 for(i = 0; i < 64; i++) { readbuff[i] = 0; writebuff[i] = 0; }


 LoadNonVolatileConstants();


 while(USBDev_GetDeviceState() != _USB_DEV_STATE_CONFIGURED) { }


 _OP_SIG = 0;
 _DR_SIG = 0;



 while(1)
 {

 _OP_SIG = 1;



 if(UsbNewPacketReceived)
 {
 if(readbuff[ 0 ] ==  0xA3 )
 {
 nvConstantMusk = readbuff[ 1 ];
 SaveNonVolatileConstants(nvConstantMusk);
 LoadNonVolatileConstants();
 }
 UsbNewPacketReceived = 0;
 }


 for(i = 0; i < 24; i += 2)
 {

 MCP3304_Read(0);


 if(MCP3304_Data & 0x8000)
 {
 AbsValue = MCP3304_Data * -1;
 MCP3304_Data = (AbsValue + lastChannel1Value) / 2;
 MCP3304_Data *= -1;
 Delay_us(5);
 }
 else
 {
 AbsValue = MCP3304_Data;
 MCP3304_Data = (AbsValue + lastChannel1Value) / 2;
 Delay_us(15);
 }
 lastChannel1Value = AbsValue;


 writebuff[ 0  + i] =  ((char *)&MCP3304_Data)[0] ;
 writebuff[ 0  + i + 1] =  ((char *)&MCP3304_Data)[1] ;


 MCP3304_Read(2);


 if(MCP3304_Data & 0x8000)
 {
 AbsValue = MCP3304_Data * -1;
 MCP3304_Data = (AbsValue + lastChannel2Value) / 2;
 MCP3304_Data *= -1;
 Delay_us(5);
 }
 else
 {
 AbsValue = MCP3304_Data;
 MCP3304_Data = (AbsValue + lastChannel2Value) / 2;
 Delay_us(15);
 }
 lastChannel2Value = AbsValue;


 writebuff[ 24  + i] =  ((char *)&MCP3304_Data)[0] ;
 writebuff[ 24  + i + 1] =  ((char *)&MCP3304_Data)[1] ;
 }


 _OP_SIG = 0;



 HID_WriteBuffer();
 }
}

void SaveNonVolatileConstants(unsigned char musk)
{
 unsigned char i;


 if(musk & 0x01)
 {
 for(i = 0; i < 4; i++)
 {
 EEPROM_Write( 0  + i, readbuff[ 2  + i]);
 Delay_ms(5);
 }
 }


 if(musk & 0x02)
 {
 for(i = 4; i < 8; i++)
 {
 EEPROM_Write( 0  + i, readbuff[ 2  + i]);
 Delay_ms(5);
 }
 }


 if(musk & 0x04)
 {
 for(i = 8; i < 12; i++)
 {
 EEPROM_Write( 0  + i, readbuff[ 2  + i]);
 Delay_ms(5);
 }
 }


 if(musk & 0x08)
 {
 for(i = 12; i < 16; i++)
 {
 EEPROM_Write( 0  + i, readbuff[ 2  + i]);
 Delay_ms(5);
 }
 }
#line 262 "E:/Workplace/Projects/Embedded/PearlEnterprise/EngineAnalyzer/battery_analyzer_usb_module/v1/FirmwareProject/v1.0/Main.c"
}

void LoadNonVolatileConstants()
{
 unsigned char i;


 for(i = 0; i < 4; i++)
 {
 writebuff[ 48  + i] = EEPROM_Read( 0  + i);
 Delay_ms(5);
 }


 for(i = 4; i < 8; i++)
 {
 writebuff[ 48  + i] = EEPROM_Read( 0  + i);
 Delay_ms(5);
 }


 for(i = 8; i < 12; i++)
 {
 writebuff[ 48  + i] = EEPROM_Read( 0  + i);
 Delay_ms(5);
 }


 for(i = 12; i < 16; i++)
 {
 writebuff[ 48  + i] = EEPROM_Read( 0  + i);
 Delay_ms(5);
 }
#line 302 "E:/Workplace/Projects/Embedded/PearlEnterprise/EngineAnalyzer/battery_analyzer_usb_module/v1/FirmwareProject/v1.0/Main.c"
}
