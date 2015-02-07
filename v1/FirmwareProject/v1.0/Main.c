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
#include "Library/FloatConverter.h"
#include "Library/MCP3304.h"
#include "built_in.h"
#include "UsbHelper.h"

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

#define CMD_SET_NV_CONSTANT 0xA3
#define NV_CONST_CMD_ADDRESS 0
#define NV_CONST_MUSK_ADDRESS 1
#define NV_CONST_READ_DATA_ADDRESS 2
#define NV_CONST_WRITE_DATA_ADDRESS 48
#define NV_CONST_EEPROM_ADDRESS 0
#define ANALOG_CH1_ADDRESS 0
#define ANALOG_CH2_ADDRESS 24

unsigned int MCP3304_Data;

void SaveNonVolatileConstants(unsigned char musk);
void LoadNonVolatileConstants();

unsigned int lastChannel1Value = 0;
unsigned int lastChannel2Value = 0;


/*** Main function of the project ***/
void main()
{
    char txt[10];
    unsigned char i = 0;
    unsigned char nvConstantMusk = 0;
    unsigned char buffIndex = 0;
    unsigned int AbsValue = 0;
    unsigned int Counter = 0;

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
    
    // clear buff
    for(i = 0; i < 64; i++) { readbuff[i] = 0; writebuff[i] = 0; }
    
    // load Non Volatile Constants from EEPROM
    LoadNonVolatileConstants();
    
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
        
        // save and update Constatnts & Offsets if CMD_SET_CALIBRATION found
        if(UsbNewPacketReceived)
        {
            if(readbuff[NV_CONST_CMD_ADDRESS] == CMD_SET_NV_CONSTANT)
            {
                nvConstantMusk = readbuff[NV_CONST_MUSK_ADDRESS];
                SaveNonVolatileConstants(nvConstantMusk);
                LoadNonVolatileConstants();
            }
            UsbNewPacketReceived = 0;
        }
        
        // Channel to buffer
        for(i = 0; i < 24; i += 2)
        {
            // Channel 1
            MCP3304_Read(0);
            
            /******** for smooth curve *******/
            if(MCP3304_Data & 0x8000)
            {
                AbsValue =  MCP3304_Data * -1;
                MCP3304_Data = (AbsValue + lastChannel1Value) / 2;
                MCP3304_Data *= -1;
                Delay_us(5);
            }
            else
            {
                AbsValue =  MCP3304_Data;
                MCP3304_Data = (AbsValue + lastChannel1Value) / 2;
                Delay_us(15);
            }
            lastChannel1Value = AbsValue;
            /********************************/
            
            writebuff[ANALOG_CH1_ADDRESS + i] = Lo(MCP3304_Data);
            writebuff[ANALOG_CH1_ADDRESS + i + 1] = Hi(MCP3304_Data);
            
            // Channel 2
            MCP3304_Read(2);

            /******** for smooth curve *******/
            if(MCP3304_Data & 0x8000)
            {
                AbsValue =  MCP3304_Data * -1;
                MCP3304_Data = (AbsValue + lastChannel2Value) / 2;
                MCP3304_Data *= -1;
                Delay_us(5);
            }
            else
            {
                AbsValue =  MCP3304_Data;
                MCP3304_Data = (AbsValue + lastChannel2Value) / 2;
                Delay_us(15);
            }
            lastChannel2Value = AbsValue;
            /********************************/

            writebuff[ANALOG_CH2_ADDRESS + i] = Lo(MCP3304_Data);
            writebuff[ANALOG_CH2_ADDRESS + i + 1] = Hi(MCP3304_Data);
        }
        
        ///////////////////// DEBUG - 1ms loop ////////////////
        _OP_SIG = 0;
        ///////////////////////////////////////////////////////

        // send to USB bus
        HID_WriteBuffer();
    }
}

void SaveNonVolatileConstants(unsigned char musk)
{
    unsigned char i;
    
    // save nvConstant1 ?
    if(musk & 0x01)
    {
        for(i = 0; i < 4; i++)
        {
            EEPROM_Write(NV_CONST_EEPROM_ADDRESS + i, readbuff[NV_CONST_READ_DATA_ADDRESS + i]);
            Delay_ms(5);
        }
    }
    
    // save nvConstant2 ?
    if(musk & 0x02)
    {
        for(i = 4; i < 8; i++)
        {
            EEPROM_Write(NV_CONST_EEPROM_ADDRESS + i, readbuff[NV_CONST_READ_DATA_ADDRESS + i]);
            Delay_ms(5);
        }
    }
    
    // save nvConstant3 ?
    if(musk & 0x04)
    {
        for(i = 8; i < 12; i++)
        {
            EEPROM_Write(NV_CONST_EEPROM_ADDRESS + i, readbuff[NV_CONST_READ_DATA_ADDRESS + i]);
            Delay_ms(5);
        }
    }
    
    // save nvConstant4 ?
    if(musk & 0x08)
    {
        for(i = 12; i < 16; i++)
        {
            EEPROM_Write(NV_CONST_EEPROM_ADDRESS + i, readbuff[NV_CONST_READ_DATA_ADDRESS + i]);
            Delay_ms(5);
        }
    }
    
    /*
    Lo(nvConstant1) = readbuff[NV_CONST_READ_DATA_ADDRESS];
    Hi(nvConstant1) = readbuff[NV_CONST_READ_DATA_ADDRESS + 1];
    Higher(nvConstant1) = readbuff[NV_CONST_READ_DATA_ADDRESS + 2];
    Highest(nvConstant1) = readbuff[NV_CONST_READ_DATA_ADDRESS + 3];
    ConvertIEEE754FloatToMicrochip(&nvConstant1);
    */
}

void LoadNonVolatileConstants()
{
    unsigned char i;

    // read nvConstant1
    for(i = 0; i < 4; i++)
    {
        writebuff[NV_CONST_WRITE_DATA_ADDRESS + i] = EEPROM_Read(NV_CONST_EEPROM_ADDRESS + i);
        Delay_ms(5);
    }
    
    // read nvConstant2
    for(i = 4; i < 8; i++)
    {
        writebuff[NV_CONST_WRITE_DATA_ADDRESS + i] = EEPROM_Read(NV_CONST_EEPROM_ADDRESS + i);
        Delay_ms(5);
    }
    
    // read nvConstant3
    for(i = 8; i < 12; i++)
    {
        writebuff[NV_CONST_WRITE_DATA_ADDRESS + i] = EEPROM_Read(NV_CONST_EEPROM_ADDRESS + i);
        Delay_ms(5);
    }
    
    // read nvConstant4
    for(i = 12; i < 16; i++)
    {
        writebuff[NV_CONST_WRITE_DATA_ADDRESS + i] = EEPROM_Read(NV_CONST_EEPROM_ADDRESS + i);
        Delay_ms(5);
    }
    
    /*
    writebuff[48] = EEPROM_Read(0);                     // Lo(nvConstant1)
    writebuff[49] = EEPROM_Read(1);                     // Hi(nvConstant1)
    writebuff[50] = EEPROM_Read(2);                     // Higher(nvConstant1)
    writebuff[51] = EEPROM_Read(3);                     // Highest(nvConstant1)
    */
}