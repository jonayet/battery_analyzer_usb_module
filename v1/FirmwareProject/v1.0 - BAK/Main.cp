#line 1 "E:/Workplace/Projects/Embedded/PearlEnterprise/EngineAnalyzer/VoltageCurrentReadingModule/v1/FirmwareProject/v1.0/Main.c"
#line 1 "e:/workplace/projects/embedded/pearlenterprise/engineanalyzer/voltagecurrentreadingmodule/v1/firmwareproject/v1.0/hardwareprofile.h"
#line 16 "e:/workplace/projects/embedded/pearlenterprise/engineanalyzer/voltagecurrentreadingmodule/v1/firmwareproject/v1.0/hardwareprofile.h"
void ConfigureIO();
void ConfigureModules();
void ConfigureInterrupts();
#line 1 "e:/workplace/projects/embedded/pearlenterprise/engineanalyzer/voltagecurrentreadingmodule/v1/firmwareproject/v1.0/compilerdefinations.h"
#line 1 "c:/users/jonayet/documents/mikroelektronika/mikroc pro for pic/include/built_in.h"
#line 36 "E:/Workplace/Projects/Embedded/PearlEnterprise/EngineAnalyzer/VoltageCurrentReadingModule/v1/FirmwareProject/v1.0/Main.c"
sbit LCD_EN at LATB7_bit;
sbit LCD_RS at LATB6_bit;
sbit LCD_D7 at LATB5_bit;
sbit LCD_D6 at LATB4_bit;
sbit LCD_D5 at LATB3_bit;
sbit LCD_D4 at LATB2_bit;


sbit LCD_EN_Direction at TRISB7_bit;
sbit LCD_RS_Direction at TRISB6_bit;
sbit LCD_D7_Direction at TRISB5_bit;
sbit LCD_D6_Direction at TRISB4_bit;
sbit LCD_D5_Direction at TRISB3_bit;
sbit LCD_D4_Direction at TRISB2_bit;


sbit Soft_I2C_Scl at RC7_bit;
sbit Soft_I2C_Sda at RC6_bit;
sbit Soft_I2C_Scl_Direction at TRISC7_bit;
sbit Soft_I2C_Sda_Direction at TRISC6_bit;
#line 76 "E:/Workplace/Projects/Embedded/PearlEnterprise/EngineAnalyzer/VoltageCurrentReadingModule/v1/FirmwareProject/v1.0/Main.c"
void Config_MCP3421();
void Read_MCP3421();

unsigned char readbuff[8] absolute 0x500;
unsigned char writebuff[8] absolute 0x540;

signed int Voltage = 0;
signed int Current = 0;


void main()
{
 char txt[10];
 unsigned int i = 0;


 ConfigureIO();
 ConfigureModules();
 ConfigureInterrupts();


 Lcd_Init();
 Lcd_Cmd(_LCD_CLEAR);
 Lcd_Cmd(_LCD_CURSOR_OFF);



 Soft_I2C_Init();


 HID_Enable(&readbuff, &writebuff);


 Config_MCP3421();


 Lcd_Out(1,1,"Voltage Current");


 while(1)
 {
 Read_MCP3421();


 IntToStr(Voltage, txt);
 Lcd_Out(2, 1, txt);
 IntToStr(Current, txt);
 Lcd_Out(2, 8, txt);


 writebuff[1] =  ((char *)&Voltage)[1] ;
 writebuff[2] =  ((char *)&Voltage)[0] ;
 writebuff[3] =  ((char *)&Current)[1] ;
 writebuff[4] =  ((char *)&Current)[0] ;
 HID_Write(&writebuff, 8);

 Delay_ms(10);
 }
}

void Config_MCP3421()
{
#line 145 "E:/Workplace/Projects/Embedded/PearlEnterprise/EngineAnalyzer/VoltageCurrentReadingModule/v1/FirmwareProject/v1.0/Main.c"
GIE_bit = 0;
 Soft_I2C_Start();
 Soft_I2C_Write( 0b11010000 );
 Soft_I2C_Write(0b00010000);
 Soft_I2C_Stop();
 GIE_bit = 1;
}

void Read_MCP3421()
{
#line 164 "E:/Workplace/Projects/Embedded/PearlEnterprise/EngineAnalyzer/VoltageCurrentReadingModule/v1/FirmwareProject/v1.0/Main.c"
 GIE_bit = 0;
 Soft_I2C_Start();
 Soft_I2C_Write( 0b11010000  | 0x01);
 Delay_us( 10 );
  ((char *)&Current)[1]  = Soft_I2C_Read(1);
  ((char *)&Current)[0]  = Soft_I2C_Read(0);
 Soft_I2C_Stop();
 GIE_bit = 1;
}
