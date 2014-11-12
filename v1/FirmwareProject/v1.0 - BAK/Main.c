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
#include "built_in.h"

// Lcd pinout settings
sbit LCD_EN at LATB7_bit;
sbit LCD_RS at LATB6_bit;
sbit LCD_D7 at LATB5_bit;
sbit LCD_D6 at LATB4_bit;
sbit LCD_D5 at LATB3_bit;
sbit LCD_D4 at LATB2_bit;

// Pin direction
sbit LCD_EN_Direction at TRISB7_bit;
sbit LCD_RS_Direction at TRISB6_bit;
sbit LCD_D7_Direction at TRISB5_bit;
sbit LCD_D6_Direction at TRISB4_bit;
sbit LCD_D5_Direction at TRISB3_bit;
sbit LCD_D4_Direction at TRISB2_bit;

// Software I2C connections
sbit Soft_I2C_Scl           at RC7_bit;
sbit Soft_I2C_Sda           at RC6_bit;
sbit Soft_I2C_Scl_Direction at TRISC7_bit;
sbit Soft_I2C_Sda_Direction at TRISC6_bit;
// End Software I2C connections

// MCP3421 ADDRESS BYTE - MSB first
//
// 1 - 1 - 0 - 1 - A2 - A1 - A0 - R/W
//
/*
  Part Number - Address Option - Code on package
  MCP3421A0T-E/CH - A0 (000) - CANN
  MCP3421A1T-E/CH - A1 (001) - CBNN
  MCP3421A2T-E/CH - A2 (010) - CCNN
  MCP3421A3T-E/CH - A3 (011) - CDNN
  MCP3421A4T-E/CH - A4 (100) - CENN
  MCP3421A5T-E/CH - A5 (101) - CFNN
  MCP3421A6T-E/CH - A6 (110) - CGNN
  MCP3421A7T-E/CH - A7 (111) - CHNN
*/
#define VOLTAGE_MCP3421_ADDRESS 0b11010000
#define CURRENT_MCP3421_ADDRESS 0b11010000

void Config_MCP3421();
void Read_MCP3421();

unsigned char readbuff[8] absolute 0x500;
unsigned char writebuff[8] absolute 0x540;

signed int Voltage = 0;
signed int Current = 0;

/*** Main function of the project ***/
void main()
{
    char txt[10];
    unsigned int i = 0;

    // configure start-up settings
    ConfigureIO();
    ConfigureModules();
    ConfigureInterrupts();

    // LCD display module
    Lcd_Init();                        // Initialize LCD
    Lcd_Cmd(_LCD_CLEAR);               // Clear display
    Lcd_Cmd(_LCD_CURSOR_OFF);          // Cursor off

    // init I2C modules
    //I2C1_Init(100000);
    Soft_I2C_Init();

    // Enable HID communication
    HID_Enable(&readbuff, &writebuff);

    // config MCP3421
    Config_MCP3421();

    // show title
    Lcd_Out(1,1,"Voltage Current");

    // forever loop to continue
    while(1)
    {
        Read_MCP3421();

        // show to LCD
        IntToStr(Voltage, txt);
        Lcd_Out(2, 1, txt);
        IntToStr(Current, txt);
        Lcd_Out(2, 8, txt);

        // send to PC
        writebuff[1] = Hi(Voltage);
        writebuff[2] = Lo(Voltage);
        writebuff[3] = Hi(Current);
        writebuff[4] = Lo(Current);
        HID_Write(&writebuff, 8);

        Delay_ms(10);
    }
}

void Config_MCP3421()
{
/*// MCP4321 - Voltage ADC
    I2C1_Start();
    I2C1_Wr(VOLTAGE_MCP3421_ADDRESS);           // Address voltage module, use write mode
    I2C1_Wr(0b00010000);                        // Continuous conversion - 12bit - PGA = 1V/V
    I2C1_Stop();*/

    // MCP4321 - Current ADC
GIE_bit = 0;                                // disable interruption
    Soft_I2C_Start();
    Soft_I2C_Write(CURRENT_MCP3421_ADDRESS);    // Address voltage module, use write mode
    Soft_I2C_Write(0b00010000);                 // Continuous conversion - 12bit - PGA = 1V/V
    Soft_I2C_Stop();
    GIE_bit = 1;                              // re-enable interruption*
}

void Read_MCP3421()
{
/*// read Voltage
    I2C1_Start();
    I2C1_Wr(CURRENT_MCP3421_ADDRESS | 0x01);         // Address voltage module, use read mode
    Delay_us( 10 );
    Hi(Voltage) = I2C1_Rd(1);                        // read Byte0, give ack
    Lo(Voltage) = I2C1_Rd(0);                        // read Byte1, don't give ack
    I2C1_Stop();*/

// read Current
    GIE_bit = 0;                                     // disable interruption
    Soft_I2C_Start();
    Soft_I2C_Write(CURRENT_MCP3421_ADDRESS | 0x01);  // Address voltage module, use read mode
    Delay_us( 10 );
    Hi(Current) = Soft_I2C_Read(1);                  // read Byte1, give ack
    Lo(Current) = Soft_I2C_Read(0);                  // read Byte1, don't give ack
    Soft_I2C_Stop();
    GIE_bit = 1;                                    // re-enable interruption
}