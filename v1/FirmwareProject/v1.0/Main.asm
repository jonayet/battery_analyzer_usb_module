
_main:

;Main.c,77 :: 		void main()
;Main.c,80 :: 		unsigned char i = 0;
	CLRF        main_i_L0+0 
	CLRF        main_buffIndex_L0+0 
	CLRF        main_AbsValue_L0+0 
	CLRF        main_AbsValue_L0+1 
;Main.c,87 :: 		ConfigureIO();
	CALL        _ConfigureIO+0, 0
;Main.c,88 :: 		ConfigureModules();
	CALL        _ConfigureModules+0, 0
;Main.c,89 :: 		ConfigureInterrupts();
	CALL        _ConfigureInterrupts+0, 0
;Main.c,102 :: 		SPI1_Init_Advanced(_SPI_MASTER_OSC_DIV16, _SPI_DATA_SAMPLE_MIDDLE, _SPI_CLK_IDLE_LOW, _SPI_LOW_2_HIGH);
	MOVLW       1
	MOVWF       FARG_SPI1_Init_Advanced_master+0 
	CLRF        FARG_SPI1_Init_Advanced_data_sample+0 
	CLRF        FARG_SPI1_Init_Advanced_clock_idle+0 
	MOVLW       1
	MOVWF       FARG_SPI1_Init_Advanced_transmit_edge+0 
	CALL        _SPI1_Init_Advanced+0, 0
;Main.c,105 :: 		USBDev_HIDInit();
	CALL        _USBDev_HIDInit+0, 0
;Main.c,108 :: 		USBDev_Init();
	CALL        _USBDev_Init+0, 0
;Main.c,111 :: 		IPEN_bit = 1;
	BSF         IPEN_bit+0, BitPos(IPEN_bit+0) 
;Main.c,112 :: 		USBIP_bit = 1;
	BSF         USBIP_bit+0, BitPos(USBIP_bit+0) 
;Main.c,113 :: 		USBIE_bit = 1;
	BSF         USBIE_bit+0, BitPos(USBIE_bit+0) 
;Main.c,114 :: 		GIEH_bit = 1;
	BSF         GIEH_bit+0, BitPos(GIEH_bit+0) 
;Main.c,117 :: 		MCP3304_Init();
	CALL        _MCP3304_Init+0, 0
;Main.c,120 :: 		for(i = 0; i < 64; i++) { readbuff[i] = 0; writebuff[i] = 0; }
	CLRF        main_i_L0+0 
L_main0:
	MOVLW       64
	SUBWF       main_i_L0+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_main1
	MOVLW       _readbuff+0
	MOVWF       FSR1 
	MOVLW       hi_addr(_readbuff+0)
	MOVWF       FSR1H 
	MOVF        main_i_L0+0, 0 
	ADDWF       FSR1, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR1H, 1 
	CLRF        POSTINC1+0 
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
;Main.c,123 :: 		LoadNonVolatileConstants();
	CALL        _LoadNonVolatileConstants+0, 0
;Main.c,126 :: 		while(USBDev_GetDeviceState() != _USB_DEV_STATE_CONFIGURED) { }
L_main3:
	CALL        _USBDev_GetDeviceState+0, 0
	MOVF        R0, 0 
	XORLW       16
	BTFSC       STATUS+0, 2 
	GOTO        L_main4
	GOTO        L_main3
L_main4:
;Main.c,129 :: 		_OP_SIG = 0;
	BCF         LATA0_bit+0, BitPos(LATA0_bit+0) 
;Main.c,130 :: 		_DR_SIG = 0;
	BCF         TRISA0_bit+0, BitPos(TRISA0_bit+0) 
;Main.c,134 :: 		while(1)
L_main5:
;Main.c,137 :: 		_OP_SIG = 1;
	BSF         LATA0_bit+0, BitPos(LATA0_bit+0) 
;Main.c,141 :: 		if(UsbNewPacketReceived)
	MOVF        _UsbNewPacketReceived+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main7
;Main.c,143 :: 		if(readbuff[NV_CONST_CMD_ADDRESS] == CMD_SET_NV_CONSTANT)
	MOVF        1280, 0 
	XORLW       163
	BTFSS       STATUS+0, 2 
	GOTO        L_main8
;Main.c,146 :: 		SaveNonVolatileConstants(nvConstantMusk);
	MOVF        1281, 0 
	MOVWF       FARG_SaveNonVolatileConstants_musk+0 
	CALL        _SaveNonVolatileConstants+0, 0
;Main.c,147 :: 		LoadNonVolatileConstants();
	CALL        _LoadNonVolatileConstants+0, 0
;Main.c,148 :: 		}
L_main8:
;Main.c,149 :: 		UsbNewPacketReceived = 0;
	CLRF        _UsbNewPacketReceived+0 
;Main.c,150 :: 		}
L_main7:
;Main.c,153 :: 		buffIndex = ANALOG_CH1_ADDRESS;
	CLRF        main_buffIndex_L0+0 
;Main.c,154 :: 		for(i = 0; i < 12; i++)
	CLRF        main_i_L0+0 
L_main9:
	MOVLW       12
	SUBWF       main_i_L0+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_main10
;Main.c,157 :: 		MCP3304_Read(0);
	CLRF        FARG_MCP3304_Read_Channel+0 
	CALL        _MCP3304_Read+0, 0
;Main.c,160 :: 		if(MCP3304_Data & 0x8000)
	BTFSS       _MCP3304_Data+1, 7 
	GOTO        L_main12
;Main.c,162 :: 		AbsValue =  MCP3304_Data * -1;
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
;Main.c,163 :: 		MCP3304_Data = (AbsValue + lastChannel1Value) / 2;
	MOVF        _lastChannel1Value+0, 0 
	ADDWF       R0, 0 
	MOVWF       R3 
	MOVF        _lastChannel1Value+1, 0 
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
;Main.c,164 :: 		MCP3304_Data *= -1;
	MOVLW       255
	MOVWF       R4 
	MOVLW       255
	MOVWF       R5 
	CALL        _Mul_16x16_U+0, 0
	MOVF        R0, 0 
	MOVWF       _MCP3304_Data+0 
	MOVF        R1, 0 
	MOVWF       _MCP3304_Data+1 
;Main.c,165 :: 		Delay_us(5);
	MOVLW       19
	MOVWF       R13, 0
L_main13:
	DECFSZ      R13, 1, 1
	BRA         L_main13
	NOP
	NOP
;Main.c,166 :: 		}
	GOTO        L_main14
L_main12:
;Main.c,169 :: 		AbsValue =  MCP3304_Data;
	MOVF        _MCP3304_Data+0, 0 
	MOVWF       main_AbsValue_L0+0 
	MOVF        _MCP3304_Data+1, 0 
	MOVWF       main_AbsValue_L0+1 
;Main.c,170 :: 		MCP3304_Data = (AbsValue + lastChannel1Value) / 2;
	MOVF        _lastChannel1Value+0, 0 
	ADDWF       _MCP3304_Data+0, 1 
	MOVF        _lastChannel1Value+1, 0 
	ADDWFC      _MCP3304_Data+1, 1 
	RRCF        _MCP3304_Data+1, 1 
	RRCF        _MCP3304_Data+0, 1 
	BCF         _MCP3304_Data+1, 7 
;Main.c,171 :: 		Delay_us(15);
	MOVLW       59
	MOVWF       R13, 0
L_main15:
	DECFSZ      R13, 1, 1
	BRA         L_main15
	NOP
	NOP
;Main.c,172 :: 		}
L_main14:
;Main.c,173 :: 		lastChannel1Value = AbsValue;
	MOVF        main_AbsValue_L0+0, 0 
	MOVWF       _lastChannel1Value+0 
	MOVF        main_AbsValue_L0+1, 0 
	MOVWF       _lastChannel1Value+1 
;Main.c,176 :: 		writebuff[buffIndex] = Lo(MCP3304_Data);
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
;Main.c,177 :: 		writebuff[buffIndex + 1] = Hi(MCP3304_Data);
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
;Main.c,178 :: 		buffIndex += 2;
	MOVLW       2
	ADDWF       main_buffIndex_L0+0, 1 
;Main.c,154 :: 		for(i = 0; i < 12; i++)
	INCF        main_i_L0+0, 1 
;Main.c,179 :: 		}
	GOTO        L_main9
L_main10:
;Main.c,182 :: 		buffIndex = ANALOG_CH2_ADDRESS;
	MOVLW       24
	MOVWF       main_buffIndex_L0+0 
;Main.c,183 :: 		for(i = 0; i < 12; i++)
	CLRF        main_i_L0+0 
L_main16:
	MOVLW       12
	SUBWF       main_i_L0+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_main17
;Main.c,186 :: 		MCP3304_Read(2);
	MOVLW       2
	MOVWF       FARG_MCP3304_Read_Channel+0 
	CALL        _MCP3304_Read+0, 0
;Main.c,189 :: 		if(MCP3304_Data & 0x8000)
	BTFSS       _MCP3304_Data+1, 7 
	GOTO        L_main19
;Main.c,191 :: 		AbsValue =  MCP3304_Data * -1;
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
;Main.c,192 :: 		MCP3304_Data = (AbsValue + lastChannel2Value) / 2;
	MOVF        _lastChannel2Value+0, 0 
	ADDWF       R0, 0 
	MOVWF       R3 
	MOVF        _lastChannel2Value+1, 0 
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
;Main.c,193 :: 		MCP3304_Data *= -1;
	MOVLW       255
	MOVWF       R4 
	MOVLW       255
	MOVWF       R5 
	CALL        _Mul_16x16_U+0, 0
	MOVF        R0, 0 
	MOVWF       _MCP3304_Data+0 
	MOVF        R1, 0 
	MOVWF       _MCP3304_Data+1 
;Main.c,194 :: 		Delay_us(5);
	MOVLW       19
	MOVWF       R13, 0
L_main20:
	DECFSZ      R13, 1, 1
	BRA         L_main20
	NOP
	NOP
;Main.c,195 :: 		}
	GOTO        L_main21
L_main19:
;Main.c,198 :: 		AbsValue =  MCP3304_Data;
	MOVF        _MCP3304_Data+0, 0 
	MOVWF       main_AbsValue_L0+0 
	MOVF        _MCP3304_Data+1, 0 
	MOVWF       main_AbsValue_L0+1 
;Main.c,199 :: 		MCP3304_Data = (AbsValue + lastChannel2Value) / 2;
	MOVF        _lastChannel2Value+0, 0 
	ADDWF       _MCP3304_Data+0, 1 
	MOVF        _lastChannel2Value+1, 0 
	ADDWFC      _MCP3304_Data+1, 1 
	RRCF        _MCP3304_Data+1, 1 
	RRCF        _MCP3304_Data+0, 1 
	BCF         _MCP3304_Data+1, 7 
;Main.c,200 :: 		Delay_us(15);
	MOVLW       59
	MOVWF       R13, 0
L_main22:
	DECFSZ      R13, 1, 1
	BRA         L_main22
	NOP
	NOP
;Main.c,201 :: 		}
L_main21:
;Main.c,202 :: 		lastChannel2Value = AbsValue;
	MOVF        main_AbsValue_L0+0, 0 
	MOVWF       _lastChannel2Value+0 
	MOVF        main_AbsValue_L0+1, 0 
	MOVWF       _lastChannel2Value+1 
;Main.c,205 :: 		writebuff[buffIndex] = Lo(MCP3304_Data);
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
;Main.c,206 :: 		writebuff[buffIndex + 1] = Hi(MCP3304_Data);
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
;Main.c,207 :: 		buffIndex += 2;
	MOVLW       2
	ADDWF       main_buffIndex_L0+0, 1 
;Main.c,183 :: 		for(i = 0; i < 12; i++)
	INCF        main_i_L0+0, 1 
;Main.c,208 :: 		}
	GOTO        L_main16
L_main17:
;Main.c,211 :: 		_OP_SIG = 0;
	BCF         LATA0_bit+0, BitPos(LATA0_bit+0) 
;Main.c,215 :: 		HID_WriteBuffer();
	CALL        _HID_WriteBuffer+0, 0
;Main.c,216 :: 		}
	GOTO        L_main5
;Main.c,217 :: 		}
L_end_main:
	GOTO        $+0
; end of _main

_SaveNonVolatileConstants:

;Main.c,219 :: 		void SaveNonVolatileConstants(unsigned char musk)
;Main.c,224 :: 		if(musk & 0x01)
	BTFSS       FARG_SaveNonVolatileConstants_musk+0, 0 
	GOTO        L_SaveNonVolatileConstants23
;Main.c,226 :: 		for(i = 0; i < 4; i++)
	CLRF        SaveNonVolatileConstants_i_L0+0 
L_SaveNonVolatileConstants24:
	MOVLW       4
	SUBWF       SaveNonVolatileConstants_i_L0+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_SaveNonVolatileConstants25
;Main.c,228 :: 		EEPROM_Write(NV_CONST_EEPROM_ADDRESS + i, readbuff[NV_CONST_READ_DATA_ADDRESS + i]);
	MOVF        SaveNonVolatileConstants_i_L0+0, 0 
	MOVWF       FARG_EEPROM_Write_address+0 
	MOVF        SaveNonVolatileConstants_i_L0+0, 0 
	ADDLW       2
	MOVWF       R0 
	CLRF        R1 
	MOVLW       0
	ADDWFC      R1, 1 
	MOVLW       _readbuff+0
	ADDWF       R0, 0 
	MOVWF       FSR0 
	MOVLW       hi_addr(_readbuff+0)
	ADDWFC      R1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_EEPROM_Write_data_+0 
	CALL        _EEPROM_Write+0, 0
;Main.c,229 :: 		Delay_ms(5);
	MOVLW       78
	MOVWF       R12, 0
	MOVLW       235
	MOVWF       R13, 0
L_SaveNonVolatileConstants27:
	DECFSZ      R13, 1, 1
	BRA         L_SaveNonVolatileConstants27
	DECFSZ      R12, 1, 1
	BRA         L_SaveNonVolatileConstants27
;Main.c,226 :: 		for(i = 0; i < 4; i++)
	INCF        SaveNonVolatileConstants_i_L0+0, 1 
;Main.c,230 :: 		}
	GOTO        L_SaveNonVolatileConstants24
L_SaveNonVolatileConstants25:
;Main.c,231 :: 		}
L_SaveNonVolatileConstants23:
;Main.c,234 :: 		if(musk & 0x02)
	BTFSS       FARG_SaveNonVolatileConstants_musk+0, 1 
	GOTO        L_SaveNonVolatileConstants28
;Main.c,236 :: 		for(i = 4; i < 8; i++)
	MOVLW       4
	MOVWF       SaveNonVolatileConstants_i_L0+0 
L_SaveNonVolatileConstants29:
	MOVLW       8
	SUBWF       SaveNonVolatileConstants_i_L0+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_SaveNonVolatileConstants30
;Main.c,238 :: 		EEPROM_Write(NV_CONST_EEPROM_ADDRESS + i, readbuff[NV_CONST_READ_DATA_ADDRESS + i]);
	MOVF        SaveNonVolatileConstants_i_L0+0, 0 
	MOVWF       FARG_EEPROM_Write_address+0 
	MOVF        SaveNonVolatileConstants_i_L0+0, 0 
	ADDLW       2
	MOVWF       R0 
	CLRF        R1 
	MOVLW       0
	ADDWFC      R1, 1 
	MOVLW       _readbuff+0
	ADDWF       R0, 0 
	MOVWF       FSR0 
	MOVLW       hi_addr(_readbuff+0)
	ADDWFC      R1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_EEPROM_Write_data_+0 
	CALL        _EEPROM_Write+0, 0
;Main.c,239 :: 		Delay_ms(5);
	MOVLW       78
	MOVWF       R12, 0
	MOVLW       235
	MOVWF       R13, 0
L_SaveNonVolatileConstants32:
	DECFSZ      R13, 1, 1
	BRA         L_SaveNonVolatileConstants32
	DECFSZ      R12, 1, 1
	BRA         L_SaveNonVolatileConstants32
;Main.c,236 :: 		for(i = 4; i < 8; i++)
	INCF        SaveNonVolatileConstants_i_L0+0, 1 
;Main.c,240 :: 		}
	GOTO        L_SaveNonVolatileConstants29
L_SaveNonVolatileConstants30:
;Main.c,241 :: 		}
L_SaveNonVolatileConstants28:
;Main.c,244 :: 		if(musk & 0x04)
	BTFSS       FARG_SaveNonVolatileConstants_musk+0, 2 
	GOTO        L_SaveNonVolatileConstants33
;Main.c,246 :: 		for(i = 8; i < 12; i++)
	MOVLW       8
	MOVWF       SaveNonVolatileConstants_i_L0+0 
L_SaveNonVolatileConstants34:
	MOVLW       12
	SUBWF       SaveNonVolatileConstants_i_L0+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_SaveNonVolatileConstants35
;Main.c,248 :: 		EEPROM_Write(NV_CONST_EEPROM_ADDRESS + i, readbuff[NV_CONST_READ_DATA_ADDRESS + i]);
	MOVF        SaveNonVolatileConstants_i_L0+0, 0 
	MOVWF       FARG_EEPROM_Write_address+0 
	MOVF        SaveNonVolatileConstants_i_L0+0, 0 
	ADDLW       2
	MOVWF       R0 
	CLRF        R1 
	MOVLW       0
	ADDWFC      R1, 1 
	MOVLW       _readbuff+0
	ADDWF       R0, 0 
	MOVWF       FSR0 
	MOVLW       hi_addr(_readbuff+0)
	ADDWFC      R1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_EEPROM_Write_data_+0 
	CALL        _EEPROM_Write+0, 0
;Main.c,249 :: 		Delay_ms(5);
	MOVLW       78
	MOVWF       R12, 0
	MOVLW       235
	MOVWF       R13, 0
L_SaveNonVolatileConstants37:
	DECFSZ      R13, 1, 1
	BRA         L_SaveNonVolatileConstants37
	DECFSZ      R12, 1, 1
	BRA         L_SaveNonVolatileConstants37
;Main.c,246 :: 		for(i = 8; i < 12; i++)
	INCF        SaveNonVolatileConstants_i_L0+0, 1 
;Main.c,250 :: 		}
	GOTO        L_SaveNonVolatileConstants34
L_SaveNonVolatileConstants35:
;Main.c,251 :: 		}
L_SaveNonVolatileConstants33:
;Main.c,254 :: 		if(musk & 0x08)
	BTFSS       FARG_SaveNonVolatileConstants_musk+0, 3 
	GOTO        L_SaveNonVolatileConstants38
;Main.c,256 :: 		for(i = 12; i < 16; i++)
	MOVLW       12
	MOVWF       SaveNonVolatileConstants_i_L0+0 
L_SaveNonVolatileConstants39:
	MOVLW       16
	SUBWF       SaveNonVolatileConstants_i_L0+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_SaveNonVolatileConstants40
;Main.c,258 :: 		EEPROM_Write(NV_CONST_EEPROM_ADDRESS + i, readbuff[NV_CONST_READ_DATA_ADDRESS + i]);
	MOVF        SaveNonVolatileConstants_i_L0+0, 0 
	MOVWF       FARG_EEPROM_Write_address+0 
	MOVF        SaveNonVolatileConstants_i_L0+0, 0 
	ADDLW       2
	MOVWF       R0 
	CLRF        R1 
	MOVLW       0
	ADDWFC      R1, 1 
	MOVLW       _readbuff+0
	ADDWF       R0, 0 
	MOVWF       FSR0 
	MOVLW       hi_addr(_readbuff+0)
	ADDWFC      R1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_EEPROM_Write_data_+0 
	CALL        _EEPROM_Write+0, 0
;Main.c,259 :: 		Delay_ms(5);
	MOVLW       78
	MOVWF       R12, 0
	MOVLW       235
	MOVWF       R13, 0
L_SaveNonVolatileConstants42:
	DECFSZ      R13, 1, 1
	BRA         L_SaveNonVolatileConstants42
	DECFSZ      R12, 1, 1
	BRA         L_SaveNonVolatileConstants42
;Main.c,256 :: 		for(i = 12; i < 16; i++)
	INCF        SaveNonVolatileConstants_i_L0+0, 1 
;Main.c,260 :: 		}
	GOTO        L_SaveNonVolatileConstants39
L_SaveNonVolatileConstants40:
;Main.c,261 :: 		}
L_SaveNonVolatileConstants38:
;Main.c,270 :: 		}
L_end_SaveNonVolatileConstants:
	RETURN      0
; end of _SaveNonVolatileConstants

_LoadNonVolatileConstants:

;Main.c,272 :: 		void LoadNonVolatileConstants()
;Main.c,277 :: 		for(i = 0; i < 4; i++)
	CLRF        LoadNonVolatileConstants_i_L0+0 
L_LoadNonVolatileConstants43:
	MOVLW       4
	SUBWF       LoadNonVolatileConstants_i_L0+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_LoadNonVolatileConstants44
;Main.c,279 :: 		writebuff[NV_CONST_WRITE_DATA_ADDRESS + i] = EEPROM_Read(NV_CONST_EEPROM_ADDRESS + i);
	MOVF        LoadNonVolatileConstants_i_L0+0, 0 
	ADDLW       48
	MOVWF       R0 
	CLRF        R1 
	MOVLW       0
	ADDWFC      R1, 1 
	MOVLW       _writebuff+0
	ADDWF       R0, 0 
	MOVWF       FLOC__LoadNonVolatileConstants+0 
	MOVLW       hi_addr(_writebuff+0)
	ADDWFC      R1, 0 
	MOVWF       FLOC__LoadNonVolatileConstants+1 
	MOVF        LoadNonVolatileConstants_i_L0+0, 0 
	MOVWF       FARG_EEPROM_Read_address+0 
	CALL        _EEPROM_Read+0, 0
	MOVFF       FLOC__LoadNonVolatileConstants+0, FSR1
	MOVFF       FLOC__LoadNonVolatileConstants+1, FSR1H
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
;Main.c,280 :: 		Delay_ms(5);
	MOVLW       78
	MOVWF       R12, 0
	MOVLW       235
	MOVWF       R13, 0
L_LoadNonVolatileConstants46:
	DECFSZ      R13, 1, 1
	BRA         L_LoadNonVolatileConstants46
	DECFSZ      R12, 1, 1
	BRA         L_LoadNonVolatileConstants46
;Main.c,277 :: 		for(i = 0; i < 4; i++)
	INCF        LoadNonVolatileConstants_i_L0+0, 1 
;Main.c,281 :: 		}
	GOTO        L_LoadNonVolatileConstants43
L_LoadNonVolatileConstants44:
;Main.c,284 :: 		for(i = 4; i < 8; i++)
	MOVLW       4
	MOVWF       LoadNonVolatileConstants_i_L0+0 
L_LoadNonVolatileConstants47:
	MOVLW       8
	SUBWF       LoadNonVolatileConstants_i_L0+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_LoadNonVolatileConstants48
;Main.c,286 :: 		writebuff[NV_CONST_WRITE_DATA_ADDRESS + i] = EEPROM_Read(NV_CONST_EEPROM_ADDRESS + i);
	MOVF        LoadNonVolatileConstants_i_L0+0, 0 
	ADDLW       48
	MOVWF       R0 
	CLRF        R1 
	MOVLW       0
	ADDWFC      R1, 1 
	MOVLW       _writebuff+0
	ADDWF       R0, 0 
	MOVWF       FLOC__LoadNonVolatileConstants+0 
	MOVLW       hi_addr(_writebuff+0)
	ADDWFC      R1, 0 
	MOVWF       FLOC__LoadNonVolatileConstants+1 
	MOVF        LoadNonVolatileConstants_i_L0+0, 0 
	MOVWF       FARG_EEPROM_Read_address+0 
	CALL        _EEPROM_Read+0, 0
	MOVFF       FLOC__LoadNonVolatileConstants+0, FSR1
	MOVFF       FLOC__LoadNonVolatileConstants+1, FSR1H
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
;Main.c,287 :: 		Delay_ms(5);
	MOVLW       78
	MOVWF       R12, 0
	MOVLW       235
	MOVWF       R13, 0
L_LoadNonVolatileConstants50:
	DECFSZ      R13, 1, 1
	BRA         L_LoadNonVolatileConstants50
	DECFSZ      R12, 1, 1
	BRA         L_LoadNonVolatileConstants50
;Main.c,284 :: 		for(i = 4; i < 8; i++)
	INCF        LoadNonVolatileConstants_i_L0+0, 1 
;Main.c,288 :: 		}
	GOTO        L_LoadNonVolatileConstants47
L_LoadNonVolatileConstants48:
;Main.c,291 :: 		for(i = 8; i < 12; i++)
	MOVLW       8
	MOVWF       LoadNonVolatileConstants_i_L0+0 
L_LoadNonVolatileConstants51:
	MOVLW       12
	SUBWF       LoadNonVolatileConstants_i_L0+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_LoadNonVolatileConstants52
;Main.c,293 :: 		writebuff[NV_CONST_WRITE_DATA_ADDRESS + i] = EEPROM_Read(NV_CONST_EEPROM_ADDRESS + i);
	MOVF        LoadNonVolatileConstants_i_L0+0, 0 
	ADDLW       48
	MOVWF       R0 
	CLRF        R1 
	MOVLW       0
	ADDWFC      R1, 1 
	MOVLW       _writebuff+0
	ADDWF       R0, 0 
	MOVWF       FLOC__LoadNonVolatileConstants+0 
	MOVLW       hi_addr(_writebuff+0)
	ADDWFC      R1, 0 
	MOVWF       FLOC__LoadNonVolatileConstants+1 
	MOVF        LoadNonVolatileConstants_i_L0+0, 0 
	MOVWF       FARG_EEPROM_Read_address+0 
	CALL        _EEPROM_Read+0, 0
	MOVFF       FLOC__LoadNonVolatileConstants+0, FSR1
	MOVFF       FLOC__LoadNonVolatileConstants+1, FSR1H
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
;Main.c,294 :: 		Delay_ms(5);
	MOVLW       78
	MOVWF       R12, 0
	MOVLW       235
	MOVWF       R13, 0
L_LoadNonVolatileConstants54:
	DECFSZ      R13, 1, 1
	BRA         L_LoadNonVolatileConstants54
	DECFSZ      R12, 1, 1
	BRA         L_LoadNonVolatileConstants54
;Main.c,291 :: 		for(i = 8; i < 12; i++)
	INCF        LoadNonVolatileConstants_i_L0+0, 1 
;Main.c,295 :: 		}
	GOTO        L_LoadNonVolatileConstants51
L_LoadNonVolatileConstants52:
;Main.c,298 :: 		for(i = 12; i < 16; i++)
	MOVLW       12
	MOVWF       LoadNonVolatileConstants_i_L0+0 
L_LoadNonVolatileConstants55:
	MOVLW       16
	SUBWF       LoadNonVolatileConstants_i_L0+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_LoadNonVolatileConstants56
;Main.c,300 :: 		writebuff[NV_CONST_WRITE_DATA_ADDRESS + i] = EEPROM_Read(NV_CONST_EEPROM_ADDRESS + i);
	MOVF        LoadNonVolatileConstants_i_L0+0, 0 
	ADDLW       48
	MOVWF       R0 
	CLRF        R1 
	MOVLW       0
	ADDWFC      R1, 1 
	MOVLW       _writebuff+0
	ADDWF       R0, 0 
	MOVWF       FLOC__LoadNonVolatileConstants+0 
	MOVLW       hi_addr(_writebuff+0)
	ADDWFC      R1, 0 
	MOVWF       FLOC__LoadNonVolatileConstants+1 
	MOVF        LoadNonVolatileConstants_i_L0+0, 0 
	MOVWF       FARG_EEPROM_Read_address+0 
	CALL        _EEPROM_Read+0, 0
	MOVFF       FLOC__LoadNonVolatileConstants+0, FSR1
	MOVFF       FLOC__LoadNonVolatileConstants+1, FSR1H
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
;Main.c,301 :: 		Delay_ms(5);
	MOVLW       78
	MOVWF       R12, 0
	MOVLW       235
	MOVWF       R13, 0
L_LoadNonVolatileConstants58:
	DECFSZ      R13, 1, 1
	BRA         L_LoadNonVolatileConstants58
	DECFSZ      R12, 1, 1
	BRA         L_LoadNonVolatileConstants58
;Main.c,298 :: 		for(i = 12; i < 16; i++)
	INCF        LoadNonVolatileConstants_i_L0+0, 1 
;Main.c,302 :: 		}
	GOTO        L_LoadNonVolatileConstants55
L_LoadNonVolatileConstants56:
;Main.c,310 :: 		}
L_end_LoadNonVolatileConstants:
	RETURN      0
; end of _LoadNonVolatileConstants
