#include <stdint.h>

extern unsigned char readbuff[];
extern unsigned char writebuff[];
#define USB_READ_BUFFER readbuff
#define USB_WRITE_BUFFER writebuff
#define USB_WRITE_TIMEOUT 1000

extern uint8_t UsbNewPacketReceived;
extern uint8_t UsbPacketSentComplete;

uint8_t HID_WriteBuffer();