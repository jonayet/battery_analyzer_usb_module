#include "UsbHelper.h"
#include <stdint.h>

volatile uint8_t UsbNewPacketReceived = 0;
volatile uint8_t UsbPacketSentComplete = 0;
uint16_t usbWriteTimeoutCounter;

uint8_t HID_WriteBuffer()
{
    // send to USB bus
    UsbPacketSentComplete = 0;
    USBDev_SendPacket(1, USB_WRITE_BUFFER, 64);
    
    // wait until timeout occured
    usbWriteTimeoutCounter = USB_WRITE_TIMEOUT;
    while(!UsbPacketSentComplete)
    {
        if(usbWriteTimeoutCounter == 0) { return 0; }
        usbWriteTimeoutCounter--;
    }
    return 0xFF;
}

// USB Device callback function called for various events
void USBDev_EventHandler(uint8_t event)
{
    switch(event)
    {
          // if device is configured (enumeration is successfully finished).
          case _USB_DEV_EVENT_CONFIGURED:
              // Set receive buffer where received data is stored
              USBDev_SetReceiveBuffer(1, USB_READ_BUFFER);
              break;
    }
}

// USB Device callback function called when packet received
void USBDev_DataReceivedHandler(uint8_t ep, uint16_t size)
{
    if(ep == 1) { UsbNewPacketReceived = 1; }
}

// USB Device callback function called when packet is sent
void USBDev_DataSentHandler(uint8_t ep)
{
    if(ep == 1)
    {
        UsbPacketSentComplete = 1;
        
        // prepare buffer for reception of next packet
        USBDev_SetReceiveBuffer(1, USB_READ_BUFFER);
    }
}