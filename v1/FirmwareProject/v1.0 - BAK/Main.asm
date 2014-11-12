
_main:

;Main.c,86 :: 		void main()
;Main.c,89 :: 		unsigned int i = 0;
;Main.c,92 :: 		ConfigureIO();
	CALL        _ConfigureIO+0, 0
;Main.c,93 :: 		ConfigureModules();
	CALL        _ConfigureModules+0, 0
;Main.c,94 :: 		ConfigureInterrupts();
	CALL        _ConfigureInterrupts+0, 0
;Main.c,97 :: 		Lcd_Init();                        // Initialize LCD
	CALL        _Lcd_Init+0, 0
;Main.c,98 :: 		Lcd_Cmd(_LCD_CLEAR);               // Clear display
	MOVLW       1
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;Main.c,99 :: 		Lcd_Cmd(_LCD_CURSOR_OFF);          // Cursor off
	MOVLW       12
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;Main.c,103 :: 		Soft_I2C_Init();
	CALL        _Soft_I2C_Init+0, 0
;Main.c,106 :: 		HID_Enable(&readbuff, &writebuff);
	MOVLW       _readbuff+0
	MOVWF       FARG_HID_Enable_readbuff+0 
	MOVLW       hi_addr(_readbuff+0)
	MOVWF       FARG_HID_Enable_readbuff+1 
	MOVLW       _writebuff+0
	MOVWF       FARG_HID_Enable_writebuff+0 
	MOVLW       hi_addr(_writebuff+0)
	MOVWF       FARG_HID_Enable_writebuff+1 
	CALL        _HID_Enable+0, 0
;Main.c,109 :: 		Config_MCP3421();
	CALL        _Config_MCP3421+0, 0
;Main.c,112 :: 		Lcd_Out(1,1,"Voltage Current");
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr1_Main+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr1_Main+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;Main.c,115 :: 		while(1)
L_main0:
;Main.c,117 :: 		Read_MCP3421();
	CALL        _Read_MCP3421+0, 0
;Main.c,120 :: 		IntToStr(Voltage, txt);
	MOVF        _Voltage+0, 0 
	MOVWF       FARG_IntToStr_input+0 
	MOVF        _Voltage+1, 0 
	MOVWF       FARG_IntToStr_input+1 
	MOVLW       main_txt_L0+0
	MOVWF       FARG_IntToStr_output+0 
	MOVLW       hi_addr(main_txt_L0+0)
	MOVWF       FARG_IntToStr_output+1 
	CALL        _IntToStr+0, 0
;Main.c,121 :: 		Lcd_Out(2, 1, txt);
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       main_txt_L0+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(main_txt_L0+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;Main.c,122 :: 		IntToStr(Current, txt);
	MOVF        _Current+0, 0 
	MOVWF       FARG_IntToStr_input+0 
	MOVF        _Current+1, 0 
	MOVWF       FARG_IntToStr_input+1 
	MOVLW       main_txt_L0+0
	MOVWF       FARG_IntToStr_output+0 
	MOVLW       hi_addr(main_txt_L0+0)
	MOVWF       FARG_IntToStr_output+1 
	CALL        _IntToStr+0, 0
;Main.c,123 :: 		Lcd_Out(2, 8, txt);
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       8
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       main_txt_L0+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(main_txt_L0+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;Main.c,126 :: 		writebuff[1] = Hi(Voltage);
	MOVF        _Voltage+1, 0 
	MOVWF       1345 
;Main.c,127 :: 		writebuff[2] = Lo(Voltage);
	MOVF        _Voltage+0, 0 
	MOVWF       1346 
;Main.c,128 :: 		writebuff[3] = Hi(Current);
	MOVF        _Current+1, 0 
	MOVWF       1347 
;Main.c,129 :: 		writebuff[4] = Lo(Current);
	MOVF        _Current+0, 0 
	MOVWF       1348 
;Main.c,130 :: 		HID_Write(&writebuff, 8);
	MOVLW       _writebuff+0
	MOVWF       FARG_HID_Write_writebuff+0 
	MOVLW       hi_addr(_writebuff+0)
	MOVWF       FARG_HID_Write_writebuff+1 
	MOVLW       8
	MOVWF       FARG_HID_Write_len+0 
	CALL        _HID_Write+0, 0
;Main.c,132 :: 		Delay_ms(10);
	MOVLW       78
	MOVWF       R12, 0
	MOVLW       235
	MOVWF       R13, 0
L_main2:
	DECFSZ      R13, 1, 1
	BRA         L_main2
	DECFSZ      R12, 1, 1
	BRA         L_main2
;Main.c,133 :: 		}
	GOTO        L_main0
;Main.c,134 :: 		}
L_end_main:
	GOTO        $+0
; end of _main

_Config_MCP3421:

;Main.c,136 :: 		void Config_MCP3421()
;Main.c,145 :: 		GIE_bit = 0;                                // disable interruption
	BCF         GIE_bit+0, BitPos(GIE_bit+0) 
;Main.c,146 :: 		Soft_I2C_Start();
	CALL        _Soft_I2C_Start+0, 0
;Main.c,147 :: 		Soft_I2C_Write(CURRENT_MCP3421_ADDRESS);    // Address voltage module, use write mode
	MOVLW       208
	MOVWF       FARG_Soft_I2C_Write_data_+0 
	CALL        _Soft_I2C_Write+0, 0
;Main.c,148 :: 		Soft_I2C_Write(0b00010000);                 // Continuous conversion - 12bit - PGA = 1V/V
	MOVLW       16
	MOVWF       FARG_Soft_I2C_Write_data_+0 
	CALL        _Soft_I2C_Write+0, 0
;Main.c,149 :: 		Soft_I2C_Stop();
	CALL        _Soft_I2C_Stop+0, 0
;Main.c,150 :: 		GIE_bit = 1;                              // re-enable interruption*
	BSF         GIE_bit+0, BitPos(GIE_bit+0) 
;Main.c,151 :: 		}
L_end_Config_MCP3421:
	RETURN      0
; end of _Config_MCP3421

_Read_MCP3421:

;Main.c,153 :: 		void Read_MCP3421()
;Main.c,164 :: 		GIE_bit = 0;                                     // disable interruption
	BCF         GIE_bit+0, BitPos(GIE_bit+0) 
;Main.c,165 :: 		Soft_I2C_Start();
	CALL        _Soft_I2C_Start+0, 0
;Main.c,166 :: 		Soft_I2C_Write(CURRENT_MCP3421_ADDRESS | 0x01);  // Address voltage module, use read mode
	MOVLW       209
	MOVWF       FARG_Soft_I2C_Write_data_+0 
	CALL        _Soft_I2C_Write+0, 0
;Main.c,167 :: 		Delay_us( 10 );
	MOVLW       19
	MOVWF       R13, 0
L_Read_MCP34213:
	DECFSZ      R13, 1, 1
	BRA         L_Read_MCP34213
	NOP
	NOP
;Main.c,168 :: 		Hi(Current) = Soft_I2C_Read(1);                  // read Byte1, give ack
	MOVLW       1
	MOVWF       FARG_Soft_I2C_Read_ack+0 
	MOVLW       0
	MOVWF       FARG_Soft_I2C_Read_ack+1 
	CALL        _Soft_I2C_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _Current+1 
;Main.c,169 :: 		Lo(Current) = Soft_I2C_Read(0);                  // read Byte1, don't give ack
	CLRF        FARG_Soft_I2C_Read_ack+0 
	CLRF        FARG_Soft_I2C_Read_ack+1 
	CALL        _Soft_I2C_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _Current+0 
;Main.c,170 :: 		Soft_I2C_Stop();
	CALL        _Soft_I2C_Stop+0, 0
;Main.c,171 :: 		GIE_bit = 1;                                    // re-enable interruption
	BSF         GIE_bit+0, BitPos(GIE_bit+0) 
;Main.c,172 :: 		}
L_end_Read_MCP3421:
	RETURN      0
; end of _Read_MCP3421
