
_main:

;Main.c,72 :: 		void main()
;Main.c,75 :: 		unsigned char i = 0;
	CLRF        main_i_L0+0 
	CLRF        main_buffIndex_L0+0 
	CLRF        main_AbsValue_L0+0 
	CLRF        main_AbsValue_L0+1 
;Main.c,81 :: 		ConfigureIO();
	CALL        _ConfigureIO+0, 0
;Main.c,82 :: 		ConfigureModules();
	CALL        _ConfigureModules+0, 0
;Main.c,83 :: 		ConfigureInterrupts();
	CALL        _ConfigureInterrupts+0, 0
;Main.c,96 :: 		SPI1_Init_Advanced(_SPI_MASTER_OSC_DIV16, _SPI_DATA_SAMPLE_MIDDLE, _SPI_CLK_IDLE_LOW, _SPI_LOW_2_HIGH);
	MOVLW       1
	MOVWF       FARG_SPI1_Init_Advanced_master+0 
	CLRF        FARG_SPI1_Init_Advanced_data_sample+0 
	CLRF        FARG_SPI1_Init_Advanced_clock_idle+0 
	MOVLW       1
	MOVWF       FARG_SPI1_Init_Advanced_transmit_edge+0 
	CALL        _SPI1_Init_Advanced+0, 0
;Main.c,99 :: 		USBDev_HIDInit();
	CALL        _USBDev_HIDInit+0, 0
;Main.c,102 :: 		USBDev_Init();
	CALL        _USBDev_Init+0, 0
;Main.c,105 :: 		IPEN_bit = 1;
	BSF         IPEN_bit+0, BitPos(IPEN_bit+0) 
;Main.c,106 :: 		USBIP_bit = 1;
	BSF         USBIP_bit+0, BitPos(USBIP_bit+0) 
;Main.c,107 :: 		USBIE_bit = 1;
	BSF         USBIE_bit+0, BitPos(USBIE_bit+0) 
;Main.c,108 :: 		GIEH_bit = 1;
	BSF         GIEH_bit+0, BitPos(GIEH_bit+0) 
;Main.c,111 :: 		MCP3304_Init();
	CALL        _MCP3304_Init+0, 0
;Main.c,114 :: 		for(i = 0; i < 64; i++) { readbuff[1] = 0; writebuff[i] = 0; }
	CLRF        main_i_L0+0 
L_main0:
	MOVLW       64
	SUBWF       main_i_L0+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_main1
	CLRF        1281 
	MOVLW       _writebuff+0
	MOVWF       FSR1 
	MOVLW       hi_addr(_writebuff+0)
	MOVWF       FSR1H 
	MOVF        main_i_L0+0, 0 
	ADDWF       FSR1, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR1H, 1 
	CLRF        POSTINC1+0 
	INCF        main_i_L0+0, 1 
	GOTO        L_main0
L_main1:
;Main.c,117 :: 		LoadConstantsAndOffsets();
	CALL        _LoadConstantsAndOffsets+0, 0
;Main.c,120 :: 		while(USBDev_GetDeviceState() != _USB_DEV_STATE_CONFIGURED) { }
L_main3:
	CALL        _USBDev_GetDeviceState+0, 0
	MOVF        R0, 0 
	XORLW       16
	BTFSC       STATUS+0, 2 
	GOTO        L_main4
	GOTO        L_main3
L_main4:
;Main.c,123 :: 		_OP_SIG = 0;
	BCF         LATA0_bit+0, BitPos(LATA0_bit+0) 
;Main.c,124 :: 		_DR_SIG = 0;
	BCF         TRISA0_bit+0, BitPos(TRISA0_bit+0) 
;Main.c,128 :: 		while(1)
L_main5:
;Main.c,131 :: 		_OP_SIG = 1;
	BSF         LATA0_bit+0, BitPos(LATA0_bit+0) 
;Main.c,135 :: 		if(UsbNewPacketReceived)
	MOVF        _UsbNewPacketReceived+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main7
;Main.c,137 :: 		if(readbuff[0] == CMD_SET_CALIBRATION)
	MOVF        1280, 0 
	XORLW       163
	BTFSS       STATUS+0, 2 
	GOTO        L_main8
;Main.c,139 :: 		SaveConstantsAndOffsets();
	CALL        _SaveConstantsAndOffsets+0, 0
;Main.c,140 :: 		LoadConstantsAndOffsets();
	CALL        _LoadConstantsAndOffsets+0, 0
;Main.c,141 :: 		}
L_main8:
;Main.c,142 :: 		UsbNewPacketReceived = 0;
	CLRF        _UsbNewPacketReceived+0 
;Main.c,143 :: 		}
L_main7:
;Main.c,146 :: 		buffIndex = 0;
	CLRF        main_buffIndex_L0+0 
;Main.c,147 :: 		for(i = 0; i < 12; i++)
	CLRF        main_i_L0+0 
L_main9:
	MOVLW       12
	SUBWF       main_i_L0+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_main10
;Main.c,150 :: 		MCP3304_Read(0);
	CLRF        FARG_MCP3304_Read_Channel+0 
	CALL        _MCP3304_Read+0, 0
;Main.c,153 :: 		if(MCP3304_Data & 0x8000)
	BTFSS       _MCP3304_Data+1, 7 
	GOTO        L_main12
;Main.c,155 :: 		AbsValue =  MCP3304_Data * -1;
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
;Main.c,156 :: 		MCP3304_Data = (AbsValue + lastVoltageValue) / 2;
	MOVF        _lastVoltageValue+0, 0 
	ADDWF       R0, 0 
	MOVWF       R3 
	MOVF        _lastVoltageValue+1, 0 
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
;Main.c,157 :: 		MCP3304_Data *= -1;
	MOVLW       255
	MOVWF       R4 
	MOVLW       255
	MOVWF       R5 
	CALL        _Mul_16x16_U+0, 0
	MOVF        R0, 0 
	MOVWF       _MCP3304_Data+0 
	MOVF        R1, 0 
	MOVWF       _MCP3304_Data+1 
;Main.c,158 :: 		Delay_us(5);
	MOVLW       19
	MOVWF       R13, 0
L_main13:
	DECFSZ      R13, 1, 1
	BRA         L_main13
	NOP
	NOP
;Main.c,159 :: 		}
	GOTO        L_main14
L_main12:
;Main.c,162 :: 		AbsValue =  MCP3304_Data;
	MOVF        _MCP3304_Data+0, 0 
	MOVWF       main_AbsValue_L0+0 
	MOVF        _MCP3304_Data+1, 0 
	MOVWF       main_AbsValue_L0+1 
;Main.c,163 :: 		MCP3304_Data = (AbsValue + lastVoltageValue) / 2;
	MOVF        _lastVoltageValue+0, 0 
	ADDWF       _MCP3304_Data+0, 1 
	MOVF        _lastVoltageValue+1, 0 
	ADDWFC      _MCP3304_Data+1, 1 
	RRCF        _MCP3304_Data+1, 1 
	RRCF        _MCP3304_Data+0, 1 
	BCF         _MCP3304_Data+1, 7 
;Main.c,164 :: 		Delay_us(15);
	MOVLW       59
	MOVWF       R13, 0
L_main15:
	DECFSZ      R13, 1, 1
	BRA         L_main15
	NOP
	NOP
;Main.c,165 :: 		}
L_main14:
;Main.c,166 :: 		lastVoltageValue = AbsValue;
	MOVF        main_AbsValue_L0+0, 0 
	MOVWF       _lastVoltageValue+0 
	MOVF        main_AbsValue_L0+1, 0 
	MOVWF       _lastVoltageValue+1 
;Main.c,169 :: 		writebuff[buffIndex] = Lo(MCP3304_Data);
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
;Main.c,170 :: 		writebuff[buffIndex + 1] = Hi(MCP3304_Data);
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
;Main.c,171 :: 		buffIndex += 2;
	MOVLW       2
	ADDWF       main_buffIndex_L0+0, 1 
;Main.c,147 :: 		for(i = 0; i < 12; i++)
	INCF        main_i_L0+0, 1 
;Main.c,172 :: 		}
	GOTO        L_main9
L_main10:
;Main.c,175 :: 		buffIndex = 24;
	MOVLW       24
	MOVWF       main_buffIndex_L0+0 
;Main.c,176 :: 		for(i = 0; i < 12; i++)
	CLRF        main_i_L0+0 
L_main16:
	MOVLW       12
	SUBWF       main_i_L0+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_main17
;Main.c,179 :: 		MCP3304_Read(2);
	MOVLW       2
	MOVWF       FARG_MCP3304_Read_Channel+0 
	CALL        _MCP3304_Read+0, 0
;Main.c,182 :: 		if(MCP3304_Data & 0x8000)
	BTFSS       _MCP3304_Data+1, 7 
	GOTO        L_main19
;Main.c,184 :: 		AbsValue =  MCP3304_Data * -1;
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
;Main.c,185 :: 		MCP3304_Data = (AbsValue + lastCurrentValue) / 2;
	MOVF        _lastCurrentValue+0, 0 
	ADDWF       R0, 0 
	MOVWF       R3 
	MOVF        _lastCurrentValue+1, 0 
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
;Main.c,186 :: 		MCP3304_Data *= -1;
	MOVLW       255
	MOVWF       R4 
	MOVLW       255
	MOVWF       R5 
	CALL        _Mul_16x16_U+0, 0
	MOVF        R0, 0 
	MOVWF       _MCP3304_Data+0 
	MOVF        R1, 0 
	MOVWF       _MCP3304_Data+1 
;Main.c,187 :: 		Delay_us(5);
	MOVLW       19
	MOVWF       R13, 0
L_main20:
	DECFSZ      R13, 1, 1
	BRA         L_main20
	NOP
	NOP
;Main.c,188 :: 		}
	GOTO        L_main21
L_main19:
;Main.c,191 :: 		AbsValue =  MCP3304_Data;
	MOVF        _MCP3304_Data+0, 0 
	MOVWF       main_AbsValue_L0+0 
	MOVF        _MCP3304_Data+1, 0 
	MOVWF       main_AbsValue_L0+1 
;Main.c,192 :: 		MCP3304_Data = (AbsValue + lastCurrentValue) / 2;
	MOVF        _lastCurrentValue+0, 0 
	ADDWF       _MCP3304_Data+0, 1 
	MOVF        _lastCurrentValue+1, 0 
	ADDWFC      _MCP3304_Data+1, 1 
	RRCF        _MCP3304_Data+1, 1 
	RRCF        _MCP3304_Data+0, 1 
	BCF         _MCP3304_Data+1, 7 
;Main.c,193 :: 		Delay_us(15);
	MOVLW       59
	MOVWF       R13, 0
L_main22:
	DECFSZ      R13, 1, 1
	BRA         L_main22
	NOP
	NOP
;Main.c,194 :: 		}
L_main21:
;Main.c,195 :: 		lastCurrentValue = AbsValue;
	MOVF        main_AbsValue_L0+0, 0 
	MOVWF       _lastCurrentValue+0 
	MOVF        main_AbsValue_L0+1, 0 
	MOVWF       _lastCurrentValue+1 
;Main.c,198 :: 		writebuff[buffIndex] = Lo(MCP3304_Data);
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
;Main.c,199 :: 		writebuff[buffIndex + 1] = Hi(MCP3304_Data);
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
;Main.c,200 :: 		buffIndex += 2;
	MOVLW       2
	ADDWF       main_buffIndex_L0+0, 1 
;Main.c,176 :: 		for(i = 0; i < 12; i++)
	INCF        main_i_L0+0, 1 
;Main.c,201 :: 		}
	GOTO        L_main16
L_main17:
;Main.c,204 :: 		_OP_SIG = 0;
	BCF         LATA0_bit+0, BitPos(LATA0_bit+0) 
;Main.c,208 :: 		HID_WriteBuffer();
	CALL        _HID_WriteBuffer+0, 0
;Main.c,209 :: 		}
	GOTO        L_main5
;Main.c,210 :: 		}
L_end_main:
	GOTO        $+0
; end of _main

_SaveConstantsAndOffsets:

;Main.c,213 :: 		void SaveConstantsAndOffsets()
;Main.c,216 :: 		Lo(Voltage_Constant) = readbuff[1];
	MOVF        1281, 0 
	MOVWF       _Voltage_Constant+0 
;Main.c,217 :: 		Hi(Voltage_Constant) = readbuff[2];
	MOVF        1282, 0 
	MOVWF       _Voltage_Constant+1 
;Main.c,218 :: 		Higher(Voltage_Constant) = readbuff[3];
	MOVF        1283, 0 
	MOVWF       _Voltage_Constant+2 
;Main.c,219 :: 		Highest(Voltage_Constant) = readbuff[4];
	MOVF        1284, 0 
	MOVWF       _Voltage_Constant+3 
;Main.c,220 :: 		ConvertIEEE754FloatToMicrochip(&Voltage_Constant);
	MOVLW       _Voltage_Constant+0
	MOVWF       FARG_ConvertIEEE754FloatToMicrochip_f+0 
	MOVLW       hi_addr(_Voltage_Constant+0)
	MOVWF       FARG_ConvertIEEE754FloatToMicrochip_f+1 
	CALL        _ConvertIEEE754FloatToMicrochip+0, 0
;Main.c,223 :: 		if(Voltage_Constant != 0)
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
	GOTO        L_SaveConstantsAndOffsets23
;Main.c,226 :: 		EEPROM_Write(0, readbuff[1]);                     // Lo(Voltage_Constant)
	CLRF        FARG_EEPROM_Write_address+0 
	MOVF        1281, 0 
	MOVWF       FARG_EEPROM_Write_data_+0 
	CALL        _EEPROM_Write+0, 0
;Main.c,227 :: 		Delay_ms(5);
	MOVLW       78
	MOVWF       R12, 0
	MOVLW       235
	MOVWF       R13, 0
L_SaveConstantsAndOffsets24:
	DECFSZ      R13, 1, 1
	BRA         L_SaveConstantsAndOffsets24
	DECFSZ      R12, 1, 1
	BRA         L_SaveConstantsAndOffsets24
;Main.c,228 :: 		EEPROM_Write(1, readbuff[2]);                     // Hi(Voltage_Constant)
	MOVLW       1
	MOVWF       FARG_EEPROM_Write_address+0 
	MOVF        1282, 0 
	MOVWF       FARG_EEPROM_Write_data_+0 
	CALL        _EEPROM_Write+0, 0
;Main.c,229 :: 		Delay_ms(5);
	MOVLW       78
	MOVWF       R12, 0
	MOVLW       235
	MOVWF       R13, 0
L_SaveConstantsAndOffsets25:
	DECFSZ      R13, 1, 1
	BRA         L_SaveConstantsAndOffsets25
	DECFSZ      R12, 1, 1
	BRA         L_SaveConstantsAndOffsets25
;Main.c,230 :: 		EEPROM_Write(2, readbuff[3]);                     // Higher(Voltage_Constant)
	MOVLW       2
	MOVWF       FARG_EEPROM_Write_address+0 
	MOVF        1283, 0 
	MOVWF       FARG_EEPROM_Write_data_+0 
	CALL        _EEPROM_Write+0, 0
;Main.c,231 :: 		Delay_ms(5);
	MOVLW       78
	MOVWF       R12, 0
	MOVLW       235
	MOVWF       R13, 0
L_SaveConstantsAndOffsets26:
	DECFSZ      R13, 1, 1
	BRA         L_SaveConstantsAndOffsets26
	DECFSZ      R12, 1, 1
	BRA         L_SaveConstantsAndOffsets26
;Main.c,232 :: 		EEPROM_Write(3, readbuff[4]);                     // Highest(Voltage_Constant)
	MOVLW       3
	MOVWF       FARG_EEPROM_Write_address+0 
	MOVF        1284, 0 
	MOVWF       FARG_EEPROM_Write_data_+0 
	CALL        _EEPROM_Write+0, 0
;Main.c,233 :: 		Delay_ms(5);
	MOVLW       78
	MOVWF       R12, 0
	MOVLW       235
	MOVWF       R13, 0
L_SaveConstantsAndOffsets27:
	DECFSZ      R13, 1, 1
	BRA         L_SaveConstantsAndOffsets27
	DECFSZ      R12, 1, 1
	BRA         L_SaveConstantsAndOffsets27
;Main.c,236 :: 		EEPROM_Write(4, readbuff[5]);                     // Lo(Voltage_offset)
	MOVLW       4
	MOVWF       FARG_EEPROM_Write_address+0 
	MOVF        1285, 0 
	MOVWF       FARG_EEPROM_Write_data_+0 
	CALL        _EEPROM_Write+0, 0
;Main.c,237 :: 		Delay_ms(5);
	MOVLW       78
	MOVWF       R12, 0
	MOVLW       235
	MOVWF       R13, 0
L_SaveConstantsAndOffsets28:
	DECFSZ      R13, 1, 1
	BRA         L_SaveConstantsAndOffsets28
	DECFSZ      R12, 1, 1
	BRA         L_SaveConstantsAndOffsets28
;Main.c,238 :: 		EEPROM_Write(5, readbuff[6]);                     // Hi(Voltage_offset)
	MOVLW       5
	MOVWF       FARG_EEPROM_Write_address+0 
	MOVF        1286, 0 
	MOVWF       FARG_EEPROM_Write_data_+0 
	CALL        _EEPROM_Write+0, 0
;Main.c,239 :: 		Delay_ms(5);
	MOVLW       78
	MOVWF       R12, 0
	MOVLW       235
	MOVWF       R13, 0
L_SaveConstantsAndOffsets29:
	DECFSZ      R13, 1, 1
	BRA         L_SaveConstantsAndOffsets29
	DECFSZ      R12, 1, 1
	BRA         L_SaveConstantsAndOffsets29
;Main.c,240 :: 		}
L_SaveConstantsAndOffsets23:
;Main.c,243 :: 		Lo(Current_Constant) = readbuff[7];
	MOVF        1287, 0 
	MOVWF       _Current_Constant+0 
;Main.c,244 :: 		Hi(Current_Constant) = readbuff[8];
	MOVF        1288, 0 
	MOVWF       _Current_Constant+1 
;Main.c,245 :: 		Higher(Current_Constant) = readbuff[9];
	MOVF        1289, 0 
	MOVWF       _Current_Constant+2 
;Main.c,246 :: 		Highest(Current_Constant) = readbuff[10];
	MOVF        1290, 0 
	MOVWF       _Current_Constant+3 
;Main.c,247 :: 		ConvertIEEE754FloatToMicrochip(&Current_Constant);
	MOVLW       _Current_Constant+0
	MOVWF       FARG_ConvertIEEE754FloatToMicrochip_f+0 
	MOVLW       hi_addr(_Current_Constant+0)
	MOVWF       FARG_ConvertIEEE754FloatToMicrochip_f+1 
	CALL        _ConvertIEEE754FloatToMicrochip+0, 0
;Main.c,250 :: 		if(Current_Constant != 0)
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
	GOTO        L_SaveConstantsAndOffsets30
;Main.c,253 :: 		EEPROM_Write(6, readbuff[7]);                     // Lo(Current_Constant)
	MOVLW       6
	MOVWF       FARG_EEPROM_Write_address+0 
	MOVF        1287, 0 
	MOVWF       FARG_EEPROM_Write_data_+0 
	CALL        _EEPROM_Write+0, 0
;Main.c,254 :: 		Delay_ms(5);
	MOVLW       78
	MOVWF       R12, 0
	MOVLW       235
	MOVWF       R13, 0
L_SaveConstantsAndOffsets31:
	DECFSZ      R13, 1, 1
	BRA         L_SaveConstantsAndOffsets31
	DECFSZ      R12, 1, 1
	BRA         L_SaveConstantsAndOffsets31
;Main.c,255 :: 		EEPROM_Write(7, readbuff[8]);                     // Hi(Current_Constant)
	MOVLW       7
	MOVWF       FARG_EEPROM_Write_address+0 
	MOVF        1288, 0 
	MOVWF       FARG_EEPROM_Write_data_+0 
	CALL        _EEPROM_Write+0, 0
;Main.c,256 :: 		Delay_ms(5);
	MOVLW       78
	MOVWF       R12, 0
	MOVLW       235
	MOVWF       R13, 0
L_SaveConstantsAndOffsets32:
	DECFSZ      R13, 1, 1
	BRA         L_SaveConstantsAndOffsets32
	DECFSZ      R12, 1, 1
	BRA         L_SaveConstantsAndOffsets32
;Main.c,257 :: 		EEPROM_Write(8, readbuff[9]);                     // Higher(Current_Constant)
	MOVLW       8
	MOVWF       FARG_EEPROM_Write_address+0 
	MOVF        1289, 0 
	MOVWF       FARG_EEPROM_Write_data_+0 
	CALL        _EEPROM_Write+0, 0
;Main.c,258 :: 		Delay_ms(5);
	MOVLW       78
	MOVWF       R12, 0
	MOVLW       235
	MOVWF       R13, 0
L_SaveConstantsAndOffsets33:
	DECFSZ      R13, 1, 1
	BRA         L_SaveConstantsAndOffsets33
	DECFSZ      R12, 1, 1
	BRA         L_SaveConstantsAndOffsets33
;Main.c,259 :: 		EEPROM_Write(9, readbuff[10]);                    // Highest(Current_Constant)
	MOVLW       9
	MOVWF       FARG_EEPROM_Write_address+0 
	MOVF        1290, 0 
	MOVWF       FARG_EEPROM_Write_data_+0 
	CALL        _EEPROM_Write+0, 0
;Main.c,260 :: 		Delay_ms(5);
	MOVLW       78
	MOVWF       R12, 0
	MOVLW       235
	MOVWF       R13, 0
L_SaveConstantsAndOffsets34:
	DECFSZ      R13, 1, 1
	BRA         L_SaveConstantsAndOffsets34
	DECFSZ      R12, 1, 1
	BRA         L_SaveConstantsAndOffsets34
;Main.c,263 :: 		EEPROM_Write(10, readbuff[11]);                   // Lo(Current_offset)
	MOVLW       10
	MOVWF       FARG_EEPROM_Write_address+0 
	MOVF        1291, 0 
	MOVWF       FARG_EEPROM_Write_data_+0 
	CALL        _EEPROM_Write+0, 0
;Main.c,264 :: 		Delay_ms(5);
	MOVLW       78
	MOVWF       R12, 0
	MOVLW       235
	MOVWF       R13, 0
L_SaveConstantsAndOffsets35:
	DECFSZ      R13, 1, 1
	BRA         L_SaveConstantsAndOffsets35
	DECFSZ      R12, 1, 1
	BRA         L_SaveConstantsAndOffsets35
;Main.c,265 :: 		EEPROM_Write(11, readbuff[12]);                   // Hi(Current_offset)
	MOVLW       11
	MOVWF       FARG_EEPROM_Write_address+0 
	MOVF        1292, 0 
	MOVWF       FARG_EEPROM_Write_data_+0 
	CALL        _EEPROM_Write+0, 0
;Main.c,266 :: 		Delay_ms(5);
	MOVLW       78
	MOVWF       R12, 0
	MOVLW       235
	MOVWF       R13, 0
L_SaveConstantsAndOffsets36:
	DECFSZ      R13, 1, 1
	BRA         L_SaveConstantsAndOffsets36
	DECFSZ      R12, 1, 1
	BRA         L_SaveConstantsAndOffsets36
;Main.c,267 :: 		}
L_SaveConstantsAndOffsets30:
;Main.c,268 :: 		}
L_end_SaveConstantsAndOffsets:
	RETURN      0
; end of _SaveConstantsAndOffsets

_LoadConstantsAndOffsets:

;Main.c,271 :: 		void LoadConstantsAndOffsets()
;Main.c,274 :: 		writebuff[52] = EEPROM_Read(0);                     // Lo(Voltage_Constant)
	CLRF        FARG_EEPROM_Read_address+0 
	CALL        _EEPROM_Read+0, 0
	MOVF        R0, 0 
	MOVWF       1396 
;Main.c,275 :: 		writebuff[53] = EEPROM_Read(1);                     // Hi(Voltage_Constant)
	MOVLW       1
	MOVWF       FARG_EEPROM_Read_address+0 
	CALL        _EEPROM_Read+0, 0
	MOVF        R0, 0 
	MOVWF       1397 
;Main.c,276 :: 		writebuff[54] = EEPROM_Read(2);                     // Higher(Voltage_Constant)
	MOVLW       2
	MOVWF       FARG_EEPROM_Read_address+0 
	CALL        _EEPROM_Read+0, 0
	MOVF        R0, 0 
	MOVWF       1398 
;Main.c,277 :: 		writebuff[55] = EEPROM_Read(3);                     // Highest(Voltage_Constant)
	MOVLW       3
	MOVWF       FARG_EEPROM_Read_address+0 
	CALL        _EEPROM_Read+0, 0
	MOVF        R0, 0 
	MOVWF       1399 
;Main.c,280 :: 		writebuff[56] = EEPROM_Read(4);                     // Lo(Voltage_offset)
	MOVLW       4
	MOVWF       FARG_EEPROM_Read_address+0 
	CALL        _EEPROM_Read+0, 0
	MOVF        R0, 0 
	MOVWF       1400 
;Main.c,281 :: 		writebuff[57] = EEPROM_Read(5);                     // Hi(Voltage_offset)
	MOVLW       5
	MOVWF       FARG_EEPROM_Read_address+0 
	CALL        _EEPROM_Read+0, 0
	MOVF        R0, 0 
	MOVWF       1401 
;Main.c,284 :: 		writebuff[58] = EEPROM_Read(6);                     // Lo(Current_Constant)
	MOVLW       6
	MOVWF       FARG_EEPROM_Read_address+0 
	CALL        _EEPROM_Read+0, 0
	MOVF        R0, 0 
	MOVWF       1402 
;Main.c,285 :: 		writebuff[59] = EEPROM_Read(7);                     // Hi(Current_Constant)
	MOVLW       7
	MOVWF       FARG_EEPROM_Read_address+0 
	CALL        _EEPROM_Read+0, 0
	MOVF        R0, 0 
	MOVWF       1403 
;Main.c,286 :: 		writebuff[60] = EEPROM_Read(8);                     // Higher(Current_Constant)
	MOVLW       8
	MOVWF       FARG_EEPROM_Read_address+0 
	CALL        _EEPROM_Read+0, 0
	MOVF        R0, 0 
	MOVWF       1404 
;Main.c,287 :: 		writebuff[61] = EEPROM_Read(9);                     // Highest(Current_Constant)
	MOVLW       9
	MOVWF       FARG_EEPROM_Read_address+0 
	CALL        _EEPROM_Read+0, 0
	MOVF        R0, 0 
	MOVWF       1405 
;Main.c,290 :: 		writebuff[62] = EEPROM_Read(10);                    // Lo(Current_offset)
	MOVLW       10
	MOVWF       FARG_EEPROM_Read_address+0 
	CALL        _EEPROM_Read+0, 0
	MOVF        R0, 0 
	MOVWF       1406 
;Main.c,291 :: 		writebuff[63] = EEPROM_Read(11);                    // Hi(Current_offset)
	MOVLW       11
	MOVWF       FARG_EEPROM_Read_address+0 
	CALL        _EEPROM_Read+0, 0
	MOVF        R0, 0 
	MOVWF       1407 
;Main.c,292 :: 		}
L_end_LoadConstantsAndOffsets:
	RETURN      0
; end of _LoadConstantsAndOffsets
