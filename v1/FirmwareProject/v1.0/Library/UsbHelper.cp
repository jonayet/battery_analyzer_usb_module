#line 1 "E:/Workplace/Projects/Embedded/PearlEnterprise/EngineAnalyzer/battery_analyzer_usb_module/v1/FirmwareProject/v1.0/Library/UsbHelper.c"
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
#line 1 "c:/users/jonayet/documents/mikroelektronika/mikroc pro for pic/include/stdint.h"
#line 4 "E:/Workplace/Projects/Embedded/PearlEnterprise/EngineAnalyzer/battery_analyzer_usb_module/v1/FirmwareProject/v1.0/Library/UsbHelper.c"
volatile uint8_t UsbNewPacketReceived = 0;
volatile uint8_t UsbPacketSentComplete = 0;
uint16_t usbWriteTimeoutCounter;

uint8_t HID_WriteBuffer()
{

 UsbPacketSentComplete = 0;
 USBDev_SendPacket(1,  writebuff , 64);


 usbWriteTimeoutCounter =  1000 ;
 while(!UsbPacketSentComplete)
 {
 if(usbWriteTimeoutCounter == 0) { return 0; }
 usbWriteTimeoutCounter--;
 }
 return 0xFF;
}


void USBDev_EventHandler(uint8_t event)
{
 switch(event)
 {

 case _USB_DEV_EVENT_CONFIGURED:

 USBDev_SetReceiveBuffer(1,  readbuff );
 break;
 }
}


void USBDev_DataReceivedHandler(uint8_t ep, uint16_t size)
{
 if(ep == 1) { UsbNewPacketReceived = 1; }
}


void USBDev_DataSentHandler(uint8_t ep)
{
 if(ep == 1)
 {
 UsbPacketSentComplete = 1;


 USBDev_SetReceiveBuffer(1,  readbuff );
 }
}
