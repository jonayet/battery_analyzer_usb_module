#line 1 "F:/Projects/Personal/Embedded System/Pearl Enterprise/battery_analyzer_usb_module/v1/FirmwareProject/v1.0/Main.c"
#line 1 "f:/projects/personal/embedded system/pearl enterprise/battery_analyzer_usb_module/v1/firmwareproject/v1.0/hardwareprofile.h"








sbit _OP_SIG at LATC2_bit;
sbit _DR_SIG at TRISC2_bit;



void ConfigureIO();
void ConfigureModules();
void ConfigureInterrupts();
#line 1 "f:/projects/personal/embedded system/pearl enterprise/battery_analyzer_usb_module/v1/firmwareproject/v1.0/compilerdefinations.h"
#line 1 "f:/projects/personal/embedded system/pearl enterprise/battery_analyzer_usb_module/v1/firmwareproject/v1.0/library/mcp3304.h"




extern unsigned int MCP3304_Data;

void MCP3304_Init();
void MCP3304_Read(unsigned char Channel);
#line 1 "c:/users/jonayet.hossain/documents/mikroelektronika/mikroc pro for pic/include/built_in.h"
#line 1 "c:/users/jonayet.hossain/documents/mikroelektronika/mikroc pro for pic/include/stdint.h"




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
#line 38 "F:/Projects/Personal/Embedded System/Pearl Enterprise/battery_analyzer_usb_module/v1/FirmwareProject/v1.0/Main.c"
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
volatile char dataReceivedFlag = 0;
volatile char UsbDataSentFlag = 0;


unsigned int MCP3304_Data;
float Voltage_Constant;
unsigned int Voltage_offset;
float Current_Constant;
unsigned int Current_offset;

void SaveConstantsAndOffsets();
void LoadConstantsAndOffsets();



void main()
{
 char txt[10];
 unsigned char i = 0;
 unsigned char buffIndex = 0;
 unsigned int lastValue = 0;
 unsigned int AbsValue = 0;


 ConfigureIO();
 ConfigureModules();
 ConfigureInterrupts();
#line 95 "F:/Projects/Personal/Embedded System/Pearl Enterprise/battery_analyzer_usb_module/v1/FirmwareProject/v1.0/Main.c"
 SPI1_Init_Advanced(_SPI_MASTER_OSC_DIV16, _SPI_DATA_SAMPLE_MIDDLE, _SPI_CLK_IDLE_LOW, _SPI_LOW_2_HIGH);


 USBDev_HIDInit();


 USBDev_Init();


 IPEN_bit = 1;
 USBIP_bit = 1;
 USBIE_bit = 1;
 GIEH_bit = 1;


 MCP3304_Init();


 LoadConstantsAndOffsets();


 while(USBDev_GetDeviceState() != _USB_DEV_STATE_CONFIGURED) { }


 _OP_SIG = 0;
 _DR_SIG = 0;



 while(1)
 {

 _OP_SIG = 1;



 if(dataReceivedFlag)
 {
 if(readbuff[0] ==  0xA3 )
 {
 SaveConstantsAndOffsets();
 LoadConstantsAndOffsets();
 }
 dataReceivedFlag = 0;
 }


 buffIndex = 0;
 for(i = 0; i < 25; i++)
 {

 MCP3304_Read(0);


 if(MCP3304_Data & 0x8000)
 {
 AbsValue = MCP3304_Data * -1;
 MCP3304_Data = (AbsValue + lastValue) / 2;
 MCP3304_Data *= -1;
 Delay_us(5);
 }
 else
 {
 AbsValue = MCP3304_Data;
 MCP3304_Data = (AbsValue + lastValue) / 2;
 Delay_us(15);
 }
 lastValue = AbsValue;


 writebuff[buffIndex] =  ((char *)&MCP3304_Data)[0] ;
 writebuff[buffIndex + 1] =  ((char *)&MCP3304_Data)[1] ;
 buffIndex += 2;
 }


 MCP3304_Read(2);
 writebuff[50] =  ((char *)&MCP3304_Data)[0] ;
 writebuff[51] =  ((char *)&MCP3304_Data)[1] ;


 _OP_SIG = 0;



 UsbDataSentFlag = 0;
 USBDev_SendPacket(1, writebuff, 64);
 while(!UsbDataSentFlag) { }
 }
}

void SaveConstantsAndOffsets()
{

 EEPROM_Write(0, readbuff[1]);
 Delay_ms(5);
 EEPROM_Write(1, readbuff[2]);
 Delay_ms(5);
 EEPROM_Write(2, readbuff[3]);
 Delay_ms(5);
 EEPROM_Write(3, readbuff[4]);
 Delay_ms(5);


 EEPROM_Write(4, readbuff[5]);
 Delay_ms(5);
 EEPROM_Write(5, readbuff[6]);
 Delay_ms(5);


 EEPROM_Write(6, readbuff[7]);
 Delay_ms(5);
 EEPROM_Write(7, readbuff[8]);
 Delay_ms(5);
 EEPROM_Write(8, readbuff[9]);
 Delay_ms(5);
 EEPROM_Write(9, readbuff[10]);
 Delay_ms(5);


 EEPROM_Write(10, readbuff[11]);
 Delay_ms(5);
 EEPROM_Write(11, readbuff[12]);
 Delay_ms(5);
}

void LoadConstantsAndOffsets()
{

 writebuff[52] = EEPROM_Read(0);
 writebuff[53] = EEPROM_Read(1);
 writebuff[54] = EEPROM_Read(2);
 writebuff[55] = EEPROM_Read(3);


 writebuff[56] = EEPROM_Read(4);
 writebuff[57] = EEPROM_Read(5);


 writebuff[58] = EEPROM_Read(6);
 writebuff[59] = EEPROM_Read(7);
 writebuff[60] = EEPROM_Read(8);
 writebuff[61] = EEPROM_Read(9);


 writebuff[62] = EEPROM_Read(10);
 writebuff[63] = EEPROM_Read(11);
}


void USBDev_EventHandler(uint8_t event)
{
 switch(event)
 {

 case _USB_DEV_EVENT_CONFIGURED:

 USBDev_SetReceiveBuffer(1, readbuff);
 break;
 }
}


void USBDev_DataReceivedHandler(uint8_t ep, uint16_t size)
{
 if(ep == 1)
 {
 dataReceivedFlag = 1;
 }
}


void USBDev_DataSentHandler(uint8_t ep)
{
 if(ep == 1)
 {
 UsbDataSentFlag = 1;

 USBDev_SetReceiveBuffer(1, readbuff);
 }
}
