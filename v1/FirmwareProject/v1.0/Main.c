/*******************************************************************************
 * Project name:
        Name_Of_The_Project

 * Author:
        Jonayet Hossain
 
 * Copyright:
        (c) INFRA Technologies, 2008-2013.

 * Revision History:
        20110101:
                - initial release;   
 
 * Description:
        Discription_Of_The_Project
 
 * Test configuration:
        MCU:                        PIC16F877A
        Dev. Board:                _PCB_BOARD_NAME_
        Oscillator:                HS, 8.0000 MHz
        Ext. Modules:        LCD 2x16
        SW:                                mikroC PRO for PIC v4.60
 
 * NOTES:
     - Note 1
     - Note 2
*******************************************************************************/

// include all header files here
#include "HardwareProfile.h"
#include "CompilerDefinations.h"
#include "Library/MCP3304.h"
#include "built_in.h"
#include <stdint.h>

// Lcd pinout settings
sbit LCD_EN at LATC1_bit;
sbit LCD_RS at LATC0_bit;
sbit LCD_D7 at LATB5_bit;
sbit LCD_D6 at LATB4_bit;
sbit LCD_D5 at LATB3_bit;
sbit LCD_D4 at LATB2_bit;

// Pin direction
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
signed int Voltage = 0;
signed int Current = 0;

/*** Main function of the project ***/
void main()
{
    char txt[10];
    unsigned char i = 0;
    unsigned char buffIndex = 0;
    unsigned int lastValue = 0;
    unsigned int AbsValue = 0;

    // configure start-up settings
    ConfigureIO();
    ConfigureModules();
    ConfigureInterrupts();

    /*
    // LCD display module
    Lcd_Init();                        // Initialize LCD
    Lcd_Cmd(_LCD_CLEAR);               // Clear display
    Lcd_Cmd(_LCD_CURSOR_OFF);          // Cursor off
    
    // show title
    //Lcd_Out(1,1,"Voltage Current");
    */

    // Set SPI1 module to master mode, clock = Fosc/16, data sampled at the middle of interval, clock idle state low and data transmitted at low to high edge:
    SPI1_Init_Advanced(_SPI_MASTER_OSC_DIV16, _SPI_DATA_SAMPLE_MIDDLE, _SPI_CLK_IDLE_LOW, _SPI_LOW_2_HIGH);
    
    // Initialize HID Class
    USBDev_HIDInit();

    // Initialize USB device module
    USBDev_Init();

    // Enable USB device interrupt
    IPEN_bit = 1;
    USBIP_bit = 1;
    USBIE_bit = 1;
    GIEH_bit = 1;

    // config MCP3304
    MCP3304_Init();
    
    // Wait until device is configured (enumeration is successfully finished)
    while(USBDev_GetDeviceState() != _USB_DEV_STATE_CONFIGURED) { }

    ///////////////////// DEBUG - 1ms loop ////////////////
    _OP_SIG = 0;
    _DR_SIG = 0;
    ///////////////////////////////////////////////////////

    // forever loop to continue
    while(1)
    {
        ///////////////////// DEBUG - 1ms loop ////////////////
        _OP_SIG = 1;
        ///////////////////////////////////////////////////////
        
        // Voltage to buffer
        buffIndex = 0;
        for(i = 0; i < 25; i++)
        {
            // Voltage
            MCP3304_Read(0);
            
            /******** for smooth curve *******/
            if(MCP3304_Data & 0x8000)
            {
                AbsValue =  MCP3304_Data * -1;
                MCP3304_Data = (AbsValue + lastValue) / 2;
                MCP3304_Data *= -1;
                Delay_us(5);
            }
            else
            {
                AbsValue =  MCP3304_Data;
                MCP3304_Data = (AbsValue + lastValue) / 2;
                Delay_us(15);
            }
            lastValue = AbsValue;
            /********************************/
            
            writebuff[buffIndex] = Lo(MCP3304_Data);
            writebuff[buffIndex + 1] = Hi(MCP3304_Data);
            buffIndex += 2;
        }

        // Current
        MCP3304_Read(2);
        writebuff[50] = Lo(MCP3304_Data);
        writebuff[51] = Hi(MCP3304_Data);
        
        ///////////////////// DEBUG - 1ms loop ////////////////
        _OP_SIG = 0;
        ///////////////////////////////////////////////////////

        // send to USB bus
        UsbDataSentFlag = 0;
        USBDev_SendPacket(1, writebuff, 64);
        while(!UsbDataSentFlag) { }
        
//        delay_ms(10);
    }
}

// USB Device callback function called for various events
void USBDev_EventHandler(uint8_t event)
{
    switch(event)
    {
          // if device is configured (enumeration is successfully finished).
          case _USB_DEV_EVENT_CONFIGURED:
          // Set receive buffer where received data is stored
          USBDev_SetReceiveBuffer(1, readbuff);
          break;
    }
}

// USB Device callback function called when packet received
void USBDev_DataReceivedHandler(uint8_t ep, uint16_t size)
{
    if(ep == 1)
    {
        dataReceivedFlag = 1;
    }
}

// USB Device callback function called when packet is sent
void USBDev_DataSentHandler(uint8_t ep)
{
    if(ep == 1)
    {
        UsbDataSentFlag = 1;
        // prepare buffer for reception of next packet
        USBDev_SetReceiveBuffer(1, readbuff);
    }
}