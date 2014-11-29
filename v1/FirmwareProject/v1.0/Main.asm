
_main:

;Main.c,70 :: 		void main()
;Main.c,73 :: 		unsigned char i = 0;
	CLRF        main_i_L0+0 
	CLRF        main_buffIndex_L0+0 
	CLRF        main_lastValue_L0+0 
	CLRF        main_lastValue_L0+1 
	CLRF        main_AbsValue_L0+0 
	CLRF        main_AbsValue_L0+1 
;Main.c,80 :: 		ConfigureIO();
	CALL        _ConfigureIO+0, 0
;Main.c,81 :: 		ConfigureModules();
	CALL        _ConfigureModules+0, 0
;Main.c,82 :: 		ConfigureInterrupts();
	CALL        _ConfigureInterrupts+0, 0
;Main.c,95 :: 		SPI1_Init_Advanced(_SPI_MASTER_OSC_DIV16, _SPI_DATA_SAMPLE_MIDDLE, _SPI_CLK_IDLE_LOW, _SPI_LOW_2_HIGH);
	MOVLW       1
	MOVWF       FARG_SPI1_Init_Advanced_master+0 
	CLRF        FARG_SPI1_Init_Advanced_data_sample+0 
	CLRF        FARG_SPI1_Init_Advanced_clock_idle+0 
	MOVLW       1
	MOVWF       FARG_SPI1_Init_Advanced_transmit_edge+0 
	CALL        _SPI1_Init_Advanced+0, 0
;Main.c,98 :: 		USBDev_HIDInit();
	CALL        _USBDev_HIDInit+0, 0
;Main.c,101 :: 		USBDev_Init();
	CALL        _USBDev_Init+0, 0
;Main.c,104 :: 		IPEN_bit = 1;
	BSF         IPEN_bit+0, BitPos(IPEN_bit+0) 
;Main.c,105 :: 		USBIP_bit = 1;
	BSF         USBIP_bit+0, BitPos(USBIP_bit+0) 
;Main.c,106 :: 		USBIE_bit = 1;
	BSF         USBIE_bit+0, BitPos(USBIE_bit+0) 
;Main.c,107 :: 		GIEH_bit = 1;
	BSF         GIEH_bit+0, BitPos(GIEH_bit+0) 
;Main.c,110 :: 		MCP3304_Init();
	CALL        _MCP3304_Init+0, 0
;Main.c,113 :: 		LoadConstantsAndOffsets();
	CALL        _LoadConstantsAndOffsets+0, 0
;Main.c,116 :: 		while(USBDev_GetDeviceState() != _USB_DEV_STATE_CONFIGURED) { }
L_main0:
	CALL        _USBDev_GetDeviceState+0, 0
	MOVF        R0, 0 
	XORLW       16
	BTFSC       STATUS+0, 2 
	GOTO        L_main1
	GOTO        L_main0
L_main1:
;Main.c,119 :: 		_OP_SIG = 0;
	BCF         LATA0_bit+0, BitPos(LATA0_bit+0) 
;Main.c,120 :: 		_DR_SIG = 0;
	BCF         TRISA0_bit+0, BitPos(TRISA0_bit+0) 
;Main.c,124 :: 		while(1)
L_main2:
;Main.c,127 :: 		_OP_SIG = 1;
	BSF         LATA0_bit+0, BitPos(LATA0_bit+0) 
;Main.c,131 :: 		if(UsbNewPacketReceived)
	MOVF        _UsbNewPacketReceived+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main4
;Main.c,133 :: 		if(readbuff[0] == CMD_SET_CALIBRATION)
	MOVF        1280, 0 
	XORLW       163
	BTFSS       STATUS+0, 2 
	GOTO        L_main5
;Main.c,135 :: 		SaveConstantsAndOffsets();
	CALL        _SaveConstantsAndOffsets+0, 0
;Main.c,136 :: 		LoadConstantsAndOffsets();
	CALL        _LoadConstantsAndOffsets+0, 0
;Main.c,137 :: 		}
L_main5:
;Main.c,138 :: 		UsbNewPacketReceived = 0;
	CLRF        _UsbNewPacketReceived+0 
;Main.c,139 :: 		}
L_main4:
;Main.c,142 :: 		buffIndex = 0;
	CLRF        main_buffIndex_L0+0 
;Main.c,143 :: 		for(i = 0; i < 25; i++)
	CLRF        main_i_L0+0 
L_main6:
	MOVLW       25
	SUBWF       main_i_L0+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_main7
;Main.c,146 :: 		MCP3304_Read(0);
	CLRF        FARG_MCP3304_Read_Channel+0 
	CALL        _MCP3304_Read+0, 0
;Main.c,149 :: 		if(MCP3304_Data & 0x8000)
	BTFSS       _MCP3304_Data+1, 7 
	GOTO        L_main9
;Main.c,151 :: 		AbsValue =  MCP3304_Data * -1;
	MOVF        _MCP3304_Data+0, 0 
	MOVWF       R0 
	MOVF        _MCP3304_Data+1, 0 
	MOVWF       R1 
	MOVLW       255
	MOVWF       R4 
	MOVLW       255
	MOVWF       R5 
	CALL        _Mul_16x16_U+0, 0
	MOVF        R0, 0 
	MOVWF       main_AbsValue_L0+0 
	MOVF        R1, 0 
	MOVWF       main_AbsValue_L0+1 
;Main.c,152 :: 		MCP3304_Data = (AbsValue + lastValue) / 2;
	MOVF        main_lastValue_L0+0, 0 
	ADDWF       R0, 0 
	MOVWF       R3 
	MOVF        main_lastValue_L0+1, 0 
	ADDWFC      R1, 0 
	MOVWF       R4 
	MOVF        R3, 0 
	MOVWF       R0 
	MOVF        R4, 0 
	MOVWF       R1 
	RRCF        R1, 1 
	RRCF        R0, 1 
	BCF         R1, 7 
	MOVF        R0, 0 
	MOVWF       _MCP3304_Data+0 
	MOVF        R1, 0 
	MOVWF       _MCP3304_Data+1 
;Main.c,153 :: 		MCP3304_Data *= -1;
	MOVLW       255
	MOVWF       R4 
	MOVLW       255
	MOVWF       R5 
	CALL        _Mul_16x16_U+0, 0
	MOVF        R0, 0 
	MOVWF       _MCP3304_Data+0 
	MOVF        R1, 0 
	MOVWF       _MCP3304_Data+1 
;Main.c,154 :: 		Delay_us(5);
	MOVLW       19
	MOVWF       R13, 0
L_main10:
	DECFSZ      R13, 1, 1
	BRA         L_main10
	NOP
	NOP
;Main.c,155 :: 		}
	GOTO        L_main11
L_main9:
;Main.c,158 :: 		AbsValue =  MCP3304_Data;
	MOVF        _MCP3304_Data+0, 0 
	MOVWF       main_AbsValue_L0+0 
	MOVF        _MCP3304_Data+1, 0 
	MOVWF       main_AbsValue_L0+1 
;Main.c,159 :: 		MCP3304_Data = (AbsValue + lastValue) / 2;
	MOVF        main_lastValue_L0+0, 0 
	ADDWF       _MCP3304_Data+0, 1 
	MOVF        main_lastValue_L0+1, 0 
	ADDWFC      _MCP3304_Data+1, 1 
	RRCF        _MCP3304_Data+1, 1 
	RRCF        _MCP3304_Data+0, 1 
	BCF         _MCP3304_Data+1, 7 
;Main.c,160 :: 		Delay_us(15);
	MOVLW       59
	MOVWF       R13, 0
L_main12:
	DECFSZ      R13, 1, 1
	BRA         L_main12
	NOP
	NOP
;Main.c,161 :: 		}
L_main11:
;Main.c,162 :: 		lastValue = AbsValue;
	MOVF        main_AbsValue_L0+0, 0 
	MOVWF       main_lastValue_L0+0 
	MOVF        main_AbsValue_L0+1, 0 
	MOVWF       main_lastValue_L0+1 
;Main.c,165 :: 		writebuff[buffIndex] = Lo(MCP3304_Data);
	MOVLW       _writebuff+0
	MOVWF       FSR1 
	MOVLW       hi_addr(_writebuff+0)
	MOVWF       FSR1H 
	MOVF        main_buffIndex_L0+0, 0 
	ADDWF       FSR1, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR1H, 1 
	MOVF        _MCP3304_Data+0, 0 
	MOVWF       POSTINC1+0 
;Main.c,166 :: 		writebuff[buffIndex + 1] = Hi(MCP3304_Data);
	MOVF        main_buffIndex_L0+0, 0 
	ADDLW       1
	MOVWF       R0 
	CLRF        R1 
	MOVLW       0
	ADDWFC      R1, 1 
	MOVLW       _writebuff+0
	ADDWF       R0, 0 
	MOVWF       FSR1 
	MOVLW       hi_addr(_writebuff+0)
	ADDWFC      R1, 0 
	MOVWF       FSR1H 
	MOVF        _MCP3304_Data+1, 0 
	MOVWF       POSTINC1+0 
;Main.c,167 :: 		buffIndex += 2;
	MOVLW       2
	ADDWF       main_buffIndex_L0+0, 1 
;Main.c,143 :: 		for(i = 0; i < 25; i++)
	INCF        main_i_L0+0, 1 
;Main.c,168 :: 		}
	GOTO        L_main6
L_main7:
;Main.c,171 :: 		MCP3304_Read(2);
	MOVLW       2
	MOVWF       FARG_MCP3304_Read_Channel+0 
	CALL        _MCP3304_Read+0, 0
;Main.c,172 :: 		writebuff[50] = Lo(MCP3304_Data);
	MOVF        _MCP3304_Data+0, 0 
	MOVWF       1394 
;Main.c,173 :: 		writebuff[51] = Hi(MCP3304_Data);
	MOVF        _MCP3304_Data+1, 0 
	MOVWF       1395 
;Main.c,176 :: 		_OP_SIG = 0;
	BCF         LATA0_bit+0, BitPos(LATA0_bit+0) 
;Main.c,180 :: 		HID_WriteBuffer();
	CALL        _HID_WriteBuffer+0, 0
;Main.c,181 :: 		}
	GOTO        L_main2
;Main.c,182 :: 		}
L_end_main:
	GOTO        $+0
; end of _main

_SaveConstantsAndOffsets:

;Main.c,185 :: 		void SaveConstantsAndOffsets()
;Main.c,188 :: 		Lo(Voltage_Constant) = readbuff[1];
	MOVF        1281, 0 
	MOVWF       _Voltage_Constant+0 
;Main.c,189 :: 		Hi(Voltage_Constant) = readbuff[2];
	MOVF        1282, 0 
	MOVWF       _Voltage_Constant+1 
;Main.c,190 :: 		Higher(Voltage_Constant) = readbuff[3];
	MOVF        1283, 0 
	MOVWF       _Voltage_Constant+2 
;Main.c,191 :: 		Highest(Voltage_Constant) = readbuff[4];
	MOVF        1284, 0 
	MOVWF       _Voltage_Constant+3 
;Main.c,192 :: 		ConvertIEEE754FloatToMicrochip(&Voltage_Constant);
	MOVLW       _Voltage_Constant+0
	MOVWF       FARG_ConvertIEEE754FloatToMicrochip_f+0 
	MOVLW       hi_addr(_Voltage_Constant+0)
	MOVWF       FARG_ConvertIEEE754FloatToMicrochip_f+1 
	CALL        _ConvertIEEE754FloatToMicrochip+0, 0
;Main.c,195 :: 		if(Voltage_Constant != 0)
	MOVF        _Voltage_Constant+0, 0 
	MOVWF       R0 
	MOVF        _Voltage_Constant+1, 0 
	MOVWF       R1 
	MOVF        _Voltage_Constant+2, 0 
	MOVWF       R2 
	MOVF        _Voltage_Constant+3, 0 
	MOVWF       R3 
	CLRF        R4 
	CLRF        R5 
	CLRF        R6 
	CLRF        R7 
	CALL        _Equals_Double+0, 0
	MOVLW       0
	BTFSS       STATUS+0, 2 
	MOVLW       1
	MOVWF       R0 
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_SaveConstantsAndOffsets13
;Main.c,198 :: 		EEPROM_Write(0, readbuff[1]);                     // Lo(Voltage_Constant)
	CLRF        FARG_EEPROM_Write_address+0 
	MOVF        1281, 0 
	MOVWF       FARG_EEPROM_Write_data_+0 
	CALL        _EEPROM_Write+0, 0
;Main.c,199 :: 		Delay_ms(5);
	MOVLW       78
	MOVWF       R12, 0
	MOVLW       235
	MOVWF       R13, 0
L_SaveConstantsAndOffsets14:
	DECFSZ      R13, 1, 1
	BRA         L_SaveConstantsAndOffsets14
	DECFSZ      R12, 1, 1
	BRA         L_SaveConstantsAndOffsets14
;Main.c,200 :: 		EEPROM_Write(1, readbuff[2]);                     // Hi(Voltage_Constant)
	MOVLW       1
	MOVWF       FARG_EEPROM_Write_address+0 
	MOVF        1282, 0 
	MOVWF       FARG_EEPROM_Write_data_+0 
	CALL        _EEPROM_Write+0, 0
;Main.c,201 :: 		Delay_ms(5);
	MOVLW       78
	MOVWF       R12, 0
	MOVLW       235
	MOVWF       R13, 0
L_SaveConstantsAndOffsets15:
	DECFSZ      R13, 1, 1
	BRA         L_SaveConstantsAndOffsets15
	DECFSZ      R12, 1, 1
	BRA         L_SaveConstantsAndOffsets15
;Main.c,202 :: 		EEPROM_Write(2, readbuff[3]);                     // Higher(Voltage_Constant)
	MOVLW       2
	MOVWF       FARG_EEPROM_Write_address+0 
	MOVF        1283, 0 
	MOVWF       FARG_EEPROM_Write_data_+0 
	CALL        _EEPROM_Write+0, 0
;Main.c,203 :: 		Delay_ms(5);
	MOVLW       78
	MOVWF       R12, 0
	MOVLW       235
	MOVWF       R13, 0
L_SaveConstantsAndOffsets16:
	DECFSZ      R13, 1, 1
	BRA         L_SaveConstantsAndOffsets16
	DECFSZ      R12, 1, 1
	BRA         L_SaveConstantsAndOffsets16
;Main.c,204 :: 		EEPROM_Write(3, readbuff[4]);                     // Highest(Voltage_Constant)
	MOVLW       3
	MOVWF       FARG_EEPROM_Write_address+0 
	MOVF        1284, 0 
	MOVWF       FARG_EEPROM_Write_data_+0 
	CALL        _EEPROM_Write+0, 0
;Main.c,205 :: 		Delay_ms(5);
	MOVLW       78
	MOVWF       R12, 0
	MOVLW       235
	MOVWF       R13, 0
L_SaveConstantsAndOffsets17:
	DECFSZ      R13, 1, 1
	BRA         L_SaveConstantsAndOffsets17
	DECFSZ      R12, 1, 1
	BRA         L_SaveConstantsAndOffsets17
;Main.c,208 :: 		EEPROM_Write(4, readbuff[5]);                     // Lo(Voltage_offset)
	MOVLW       4
	MOVWF       FARG_EEPROM_Write_address+0 
	MOVF        1285, 0 
	MOVWF       FARG_EEPROM_Write_data_+0 
	CALL        _EEPROM_Write+0, 0
;Main.c,209 :: 		Delay_ms(5);
	MOVLW       78
	MOVWF       R12, 0
	MOVLW       235
	MOVWF       R13, 0
L_SaveConstantsAndOffsets18:
	DECFSZ      R13, 1, 1
	BRA         L_SaveConstantsAndOffsets18
	DECFSZ      R12, 1, 1
	BRA         L_SaveConstantsAndOffsets18
;Main.c,210 :: 		EEPROM_Write(5, readbuff[6]);                     // Hi(Voltage_offset)
	MOVLW       5
	MOVWF       FARG_EEPROM_Write_address+0 
	MOVF        1286, 0 
	MOVWF       FARG_EEPROM_Write_data_+0 
	CALL        _EEPROM_Write+0, 0
;Main.c,211 :: 		Delay_ms(5);
	MOVLW       78
	MOVWF       R12, 0
	MOVLW       235
	MOVWF       R13, 0
L_SaveConstantsAndOffsets19:
	DECFSZ      R13, 1, 1
	BRA         L_SaveConstantsAndOffsets19
	DECFSZ      R12, 1, 1
	BRA         L_SaveConstantsAndOffsets19
;Main.c,212 :: 		}
L_SaveConstantsAndOffsets13:
;Main.c,215 :: 		Lo(Current_Constant) = readbuff[7];
	MOVF        1287, 0 
	MOVWF       _Current_Constant+0 
;Main.c,216 :: 		Hi(Current_Constant) = readbuff[8];
	MOVF        1288, 0 
	MOVWF       _Current_Constant+1 
;Main.c,217 :: 		Higher(Current_Constant) = readbuff[9];
	MOVF        1289, 0 
	MOVWF       _Current_Constant+2 
;Main.c,218 :: 		Highest(Current_Constant) = readbuff[10];
	MOVF        1290, 0 
	MOVWF       _Current_Constant+3 
;Main.c,219 :: 		ConvertIEEE754FloatToMicrochip(&Current_Constant);
	MOVLW       _Current_Constant+0
	MOVWF       FARG_ConvertIEEE754FloatToMicrochip_f+0 
	MOVLW       hi_addr(_Current_Constant+0)
	MOVWF       FARG_ConvertIEEE754FloatToMicrochip_f+1 
	CALL        _ConvertIEEE754FloatToMicrochip+0, 0
;Main.c,222 :: 		if(Current_Constant != 0)
	MOVF        _Current_Constant+0, 0 
	MOVWF       R0 
	MOVF        _Current_Constant+1, 0 
	MOVWF       R1 
	MOVF        _Current_Constant+2, 0 
	MOVWF       R2 
	MOVF        _Current_Constant+3, 0 
	MOVWF       R3 
	CLRF        R4 
	CLRF        R5 
	CLRF        R6 
	CLRF        R7 
	CALL        _Equals_Double+0, 0
	MOVLW       0
	BTFSS       STATUS+0, 2 
	MOVLW       1
	MOVWF       R0 
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_SaveConstantsAndOffsets20
;Main.c,225 :: 		EEPROM_Write(6, readbuff[7]);                     // Lo(Current_Constant)
	MOVLW       6
	MOVWF       FARG_EEPROM_Write_address+0 
	MOVF        1287, 0 
	MOVWF       FARG_EEPROM_Write_data_+0 
	CALL        _EEPROM_Write+0, 0
;Main.c,226 :: 		Delay_ms(5);
	MOVLW       78
	MOVWF       R12, 0
	MOVLW       235
	MOVWF       R13, 0
L_SaveConstantsAndOffsets21:
	DECFSZ      R13, 1, 1
	BRA         L_SaveConstantsAndOffsets21
	DECFSZ      R12, 1, 1
	BRA         L_SaveConstantsAndOffsets21
;Main.c,227 :: 		EEPROM_Write(7, readbuff[8]);                     // Hi(Current_Constant)
	MOVLW       7
	MOVWF       FARG_EEPROM_Write_address+0 
	MOVF        1288, 0 
	MOVWF       FARG_EEPROM_Write_data_+0 
	CALL        _EEPROM_Write+0, 0
;Main.c,228 :: 		Delay_ms(5);
	MOVLW       78
	MOVWF       R12, 0
	MOVLW       235
	MOVWF       R13, 0
L_SaveConstantsAndOffsets22:
	DECFSZ      R13, 1, 1
	BRA         L_SaveConstantsAndOffsets22
	DECFSZ      R12, 1, 1
	BRA         L_SaveConstantsAndOffsets22
;Main.c,229 :: 		EEPROM_Write(8, readbuff[9]);                     // Higher(Current_Constant)
	MOVLW       8
	MOVWF       FARG_EEPROM_Write_address+0 
	MOVF        1289, 0 
	MOVWF       FARG_EEPROM_Write_data_+0 
	CALL        _EEPROM_Write+0, 0
;Main.c,230 :: 		Delay_ms(5);
	MOVLW       78
	MOVWF       R12, 0
	MOVLW       235
	MOVWF       R13, 0
L_SaveConstantsAndOffsets23:
	DECFSZ      R13, 1, 1
	BRA         L_SaveConstantsAndOffsets23
	DECFSZ      R12, 1, 1
	BRA         L_SaveConstantsAndOffsets23
;Main.c,231 :: 		EEPROM_Write(9, readbuff[10]);                    // Highest(Current_Constant)
	MOVLW       9
	MOVWF       FARG_EEPROM_Write_address+0 
	MOVF        1290, 0 
	MOVWF       FARG_EEPROM_Write_data_+0 
	CALL        _EEPROM_Write+0, 0
;Main.c,232 :: 		Delay_ms(5);
	MOVLW       78
	MOVWF       R12, 0
	MOVLW       235
	MOVWF       R13, 0
L_SaveConstantsAndOffsets24:
	DECFSZ      R13, 1, 1
	BRA         L_SaveConstantsAndOffsets24
	DECFSZ      R12, 1, 1
	BRA         L_SaveConstantsAndOffsets24
;Main.c,235 :: 		EEPROM_Write(10, readbuff[11]);                   // Lo(Current_offset)
	MOVLW       10
	MOVWF       FARG_EEPROM_Write_address+0 
	MOVF        1291, 0 
	MOVWF       FARG_EEPROM_Write_data_+0 
	CALL        _EEPROM_Write+0, 0
;Main.c,236 :: 		Delay_ms(5);
	MOVLW       78
	MOVWF       R12, 0
	MOVLW       235
	MOVWF       R13, 0
L_SaveConstantsAndOffsets25:
	DECFSZ      R13, 1, 1
	BRA         L_SaveConstantsAndOffsets25
	DECFSZ      R12, 1, 1
	BRA         L_SaveConstantsAndOffsets25
;Main.c,237 :: 		EEPROM_Write(11, readbuff[12]);                   // Hi(Current_offset)
	MOVLW       11
	MOVWF       FARG_EEPROM_Write_address+0 
	MOVF        1292, 0 
	MOVWF       FARG_EEPROM_Write_data_+0 
	CALL        _EEPROM_Write+0, 0
;Main.c,238 :: 		Delay_ms(5);
	MOVLW       78
	MOVWF       R12, 0
	MOVLW       235
	MOVWF       R13, 0
L_SaveConstantsAndOffsets26:
	DECFSZ      R13, 1, 1
	BRA         L_SaveConstantsAndOffsets26
	DECFSZ      R12, 1, 1
	BRA         L_SaveConstantsAndOffsets26
;Main.c,239 :: 		}
L_SaveConstantsAndOffsets20:
;Main.c,240 :: 		}
L_end_SaveConstantsAndOffsets:
	RETURN      0
; end of _SaveConstantsAndOffsets

_LoadConstantsAndOffsets:

;Main.c,243 :: 		void LoadConstantsAndOffsets()
;Main.c,246 :: 		writebuff[52] = EEPROM_Read(0);                     // Lo(Voltage_Constant)
	CLRF        FARG_EEPROM_Read_address+0 
	CALL        _EEPROM_Read+0, 0
	MOVF        R0, 0 
	MOVWF       1396 
;Main.c,247 :: 		writebuff[53] = EEPROM_Read(1);                     // Hi(Voltage_Constant)
	MOVLW       1
	MOVWF       FARG_EEPROM_Read_address+0 
	CALL        _EEPROM_Read+0, 0
	MOVF        R0, 0 
	MOVWF       1397 
;Main.c,248 :: 		writebuff[54] = EEPROM_Read(2);                     // Higher(Voltage_Constant)
	MOVLW       2
	MOVWF       FARG_EEPROM_Read_address+0 
	CALL        _EEPROM_Read+0, 0
	MOVF        R0, 0 
	MOVWF       1398 
;Main.c,249 :: 		writebuff[55] = EEPROM_Read(3);                     // Highest(Voltage_Constant)
	MOVLW       3
	MOVWF       FARG_EEPROM_Read_address+0 
	CALL        _EEPROM_Read+0, 0
	MOVF        R0, 0 
	MOVWF       1399 
;Main.c,252 :: 		writebuff[56] = EEPROM_Read(4);                     // Lo(Voltage_offset)
	MOVLW       4
	MOVWF       FARG_EEPROM_Read_address+0 
	CALL        _EEPROM_Read+0, 0
	MOVF        R0, 0 
	MOVWF       1400 
;Main.c,253 :: 		writebuff[57] = EEPROM_Read(5);                     // Hi(Voltage_offset)
	MOVLW       5
	MOVWF       FARG_EEPROM_Read_address+0 
	CALL        _EEPROM_Read+0, 0
	MOVF        R0, 0 
	MOVWF       1401 
;Main.c,256 :: 		writebuff[58] = EEPROM_Read(6);                     // Lo(Current_Constant)
	MOVLW       6
	MOVWF       FARG_EEPROM_Read_address+0 
	CALL        _EEPROM_Read+0, 0
	MOVF        R0, 0 
	MOVWF       1402 
;Main.c,257 :: 		writebuff[59] = EEPROM_Read(7);                     // Hi(Current_Constant)
	MOVLW       7
	MOVWF       FARG_EEPROM_Read_address+0 
	CALL        _EEPROM_Read+0, 0
	MOVF        R0, 0 
	MOVWF       1403 
;Main.c,258 :: 		writebuff[60] = EEPROM_Read(8);                     // Higher(Current_Constant)
	MOVLW       8
	MOVWF       FARG_EEPROM_Read_address+0 
	CALL        _EEPROM_Read+0, 0
	MOVF        R0, 0 
	MOVWF       1404 
;Main.c,259 :: 		writebuff[61] = EEPROM_Read(9);                     // Highest(Current_Constant)
	MOVLW       9
	MOVWF       FARG_EEPROM_Read_address+0 
	CALL        _EEPROM_Read+0, 0
	MOVF        R0, 0 
	MOVWF       1405 
;Main.c,262 :: 		writebuff[62] = EEPROM_Read(10);                    // Lo(Current_offset)
	MOVLW       10
	MOVWF       FARG_EEPROM_Read_address+0 
	CALL        _EEPROM_Read+0, 0
	MOVF        R0, 0 
	MOVWF       1406 
;Main.c,263 :: 		writebuff[63] = EEPROM_Read(11);                    // Hi(Current_offset)
	MOVLW       11
	MOVWF       FARG_EEPROM_Read_address+0 
	CALL        _EEPROM_Read+0, 0
	MOVF        R0, 0 
	MOVWF       1407 
;Main.c,264 :: 		}
L_end_LoadConstantsAndOffsets:
	RETURN      0
; end of _LoadConstantsAndOffsets
