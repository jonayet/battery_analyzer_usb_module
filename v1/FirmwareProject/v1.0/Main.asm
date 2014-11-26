
_main:

;Main.c,72 :: 		void main()
;Main.c,75 :: 		unsigned char i = 0;
	CLRF        main_i_L0+0 
	CLRF        main_buffIndex_L0+0 
	CLRF        main_lastValue_L0+0 
	CLRF        main_lastValue_L0+1 
	CLRF        main_AbsValue_L0+0 
	CLRF        main_AbsValue_L0+1 
	CLRF        main_Counter_L0+0 
	CLRF        main_Counter_L0+1 
;Main.c,82 :: 		ConfigureIO();
	CALL        _ConfigureIO+0, 0
;Main.c,83 :: 		ConfigureModules();
	CALL        _ConfigureModules+0, 0
;Main.c,84 :: 		ConfigureInterrupts();
	CALL        _ConfigureInterrupts+0, 0
;Main.c,97 :: 		SPI1_Init_Advanced(_SPI_MASTER_OSC_DIV16, _SPI_DATA_SAMPLE_MIDDLE, _SPI_CLK_IDLE_LOW, _SPI_LOW_2_HIGH);
	MOVLW       1
	MOVWF       FARG_SPI1_Init_Advanced_master+0 
	CLRF        FARG_SPI1_Init_Advanced_data_sample+0 
	CLRF        FARG_SPI1_Init_Advanced_clock_idle+0 
	MOVLW       1
	MOVWF       FARG_SPI1_Init_Advanced_transmit_edge+0 
	CALL        _SPI1_Init_Advanced+0, 0
;Main.c,100 :: 		USBDev_HIDInit();
	CALL        _USBDev_HIDInit+0, 0
;Main.c,103 :: 		USBDev_Init();
	CALL        _USBDev_Init+0, 0
;Main.c,106 :: 		IPEN_bit = 1;
	BSF         IPEN_bit+0, BitPos(IPEN_bit+0) 
;Main.c,107 :: 		USBIP_bit = 1;
	BSF         USBIP_bit+0, BitPos(USBIP_bit+0) 
;Main.c,108 :: 		USBIE_bit = 1;
	BSF         USBIE_bit+0, BitPos(USBIE_bit+0) 
;Main.c,109 :: 		GIEH_bit = 1;
	BSF         GIEH_bit+0, BitPos(GIEH_bit+0) 
;Main.c,112 :: 		MCP3304_Init();
	CALL        _MCP3304_Init+0, 0
;Main.c,115 :: 		LoadConstantsAndOffsets();
	CALL        _LoadConstantsAndOffsets+0, 0
;Main.c,118 :: 		while(USBDev_GetDeviceState() != _USB_DEV_STATE_CONFIGURED) { }
L_main0:
	CALL        _USBDev_GetDeviceState+0, 0
	MOVF        R0, 0 
	XORLW       16
	BTFSC       STATUS+0, 2 
	GOTO        L_main1
	GOTO        L_main0
L_main1:
;Main.c,121 :: 		_OP_SIG = 0;
	BCF         LATA0_bit+0, BitPos(LATA0_bit+0) 
;Main.c,122 :: 		_DR_SIG = 0;
	BCF         TRISA0_bit+0, BitPos(TRISA0_bit+0) 
;Main.c,126 :: 		while(1)
L_main2:
;Main.c,129 :: 		_OP_SIG = 1;
	BSF         LATA0_bit+0, BitPos(LATA0_bit+0) 
;Main.c,133 :: 		if(dataReceivedFlag)
	MOVF        _dataReceivedFlag+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main4
;Main.c,135 :: 		if(readbuff[0] == CMD_SET_CALIBRATION)
	MOVF        1280, 0 
	XORLW       163
	BTFSS       STATUS+0, 2 
	GOTO        L_main5
;Main.c,137 :: 		SaveConstantsAndOffsets();
	CALL        _SaveConstantsAndOffsets+0, 0
;Main.c,138 :: 		LoadConstantsAndOffsets();
	CALL        _LoadConstantsAndOffsets+0, 0
;Main.c,139 :: 		}
L_main5:
;Main.c,140 :: 		dataReceivedFlag = 0;
	CLRF        _dataReceivedFlag+0 
;Main.c,141 :: 		}
L_main4:
;Main.c,144 :: 		buffIndex = 0;
	CLRF        main_buffIndex_L0+0 
;Main.c,145 :: 		for(i = 0; i < 25; i++)
	CLRF        main_i_L0+0 
L_main6:
	MOVLW       25
	SUBWF       main_i_L0+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_main7
;Main.c,148 :: 		MCP3304_Read(0);
	CLRF        FARG_MCP3304_Read_Channel+0 
	CALL        _MCP3304_Read+0, 0
;Main.c,151 :: 		if(MCP3304_Data & 0x8000)
	BTFSS       _MCP3304_Data+1, 7 
	GOTO        L_main9
;Main.c,153 :: 		AbsValue =  MCP3304_Data * -1;
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
;Main.c,154 :: 		MCP3304_Data = (AbsValue + lastValue) / 2;
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
;Main.c,155 :: 		MCP3304_Data *= -1;
	MOVLW       255
	MOVWF       R4 
	MOVLW       255
	MOVWF       R5 
	CALL        _Mul_16x16_U+0, 0
	MOVF        R0, 0 
	MOVWF       _MCP3304_Data+0 
	MOVF        R1, 0 
	MOVWF       _MCP3304_Data+1 
;Main.c,156 :: 		Delay_us(5);
	MOVLW       19
	MOVWF       R13, 0
L_main10:
	DECFSZ      R13, 1, 1
	BRA         L_main10
	NOP
	NOP
;Main.c,157 :: 		}
	GOTO        L_main11
L_main9:
;Main.c,160 :: 		AbsValue =  MCP3304_Data;
	MOVF        _MCP3304_Data+0, 0 
	MOVWF       main_AbsValue_L0+0 
	MOVF        _MCP3304_Data+1, 0 
	MOVWF       main_AbsValue_L0+1 
;Main.c,161 :: 		MCP3304_Data = (AbsValue + lastValue) / 2;
	MOVF        main_lastValue_L0+0, 0 
	ADDWF       _MCP3304_Data+0, 1 
	MOVF        main_lastValue_L0+1, 0 
	ADDWFC      _MCP3304_Data+1, 1 
	RRCF        _MCP3304_Data+1, 1 
	RRCF        _MCP3304_Data+0, 1 
	BCF         _MCP3304_Data+1, 7 
;Main.c,162 :: 		Delay_us(15);
	MOVLW       59
	MOVWF       R13, 0
L_main12:
	DECFSZ      R13, 1, 1
	BRA         L_main12
	NOP
	NOP
;Main.c,163 :: 		}
L_main11:
;Main.c,164 :: 		lastValue = AbsValue;
	MOVF        main_AbsValue_L0+0, 0 
	MOVWF       main_lastValue_L0+0 
	MOVF        main_AbsValue_L0+1, 0 
	MOVWF       main_lastValue_L0+1 
;Main.c,167 :: 		writebuff[buffIndex] = Lo(MCP3304_Data);
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
;Main.c,168 :: 		writebuff[buffIndex + 1] = Hi(MCP3304_Data);
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
;Main.c,169 :: 		buffIndex += 2;
	MOVLW       2
	ADDWF       main_buffIndex_L0+0, 1 
;Main.c,145 :: 		for(i = 0; i < 25; i++)
	INCF        main_i_L0+0, 1 
;Main.c,170 :: 		}
	GOTO        L_main6
L_main7:
;Main.c,173 :: 		MCP3304_Read(2);
	MOVLW       2
	MOVWF       FARG_MCP3304_Read_Channel+0 
	CALL        _MCP3304_Read+0, 0
;Main.c,174 :: 		writebuff[50] = Lo(MCP3304_Data);
	MOVF        _MCP3304_Data+0, 0 
	MOVWF       1394 
;Main.c,175 :: 		writebuff[51] = Hi(MCP3304_Data);
	MOVF        _MCP3304_Data+1, 0 
	MOVWF       1395 
;Main.c,178 :: 		_OP_SIG = 0;
	BCF         LATA0_bit+0, BitPos(LATA0_bit+0) 
;Main.c,182 :: 		UsbDataSentFlag = 0;
	CLRF        _UsbDataSentFlag+0 
;Main.c,183 :: 		USBDev_SendPacket(1, writebuff, 64);
	MOVLW       1
	MOVWF       FARG_USBDev_SendPacket_epNum+0 
	MOVLW       _writebuff+0
	MOVWF       FARG_USBDev_SendPacket_buff+0 
	MOVLW       hi_addr(_writebuff+0)
	MOVWF       FARG_USBDev_SendPacket_buff+1 
	MOVLW       64
	MOVWF       FARG_USBDev_SendPacket_len+0 
	MOVLW       0
	MOVWF       FARG_USBDev_SendPacket_len+1 
	CALL        _USBDev_SendPacket+0, 0
;Main.c,184 :: 		Counter = 0;
	CLRF        main_Counter_L0+0 
	CLRF        main_Counter_L0+1 
;Main.c,185 :: 		while(!UsbDataSentFlag)
L_main13:
	MOVF        _UsbDataSentFlag+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_main14
;Main.c,187 :: 		Counter++;
	INFSNZ      main_Counter_L0+0, 1 
	INCF        main_Counter_L0+1, 1 
;Main.c,188 :: 		if(Counter > 60000){ break; }
	MOVF        main_Counter_L0+1, 0 
	SUBLW       234
	BTFSS       STATUS+0, 2 
	GOTO        L__main36
	MOVF        main_Counter_L0+0, 0 
	SUBLW       96
L__main36:
	BTFSC       STATUS+0, 0 
	GOTO        L_main15
	GOTO        L_main14
L_main15:
;Main.c,189 :: 		}
	GOTO        L_main13
L_main14:
;Main.c,190 :: 		}
	GOTO        L_main2
;Main.c,191 :: 		}
L_end_main:
	GOTO        $+0
; end of _main

_SaveConstantsAndOffsets:

;Main.c,194 :: 		void SaveConstantsAndOffsets()
;Main.c,197 :: 		Lo(Voltage_Constant) = readbuff[1];
	MOVF        1281, 0 
	MOVWF       _Voltage_Constant+0 
;Main.c,198 :: 		Hi(Voltage_Constant) = readbuff[2];
	MOVF        1282, 0 
	MOVWF       _Voltage_Constant+1 
;Main.c,199 :: 		Higher(Voltage_Constant) = readbuff[3];
	MOVF        1283, 0 
	MOVWF       _Voltage_Constant+2 
;Main.c,200 :: 		Highest(Voltage_Constant) = readbuff[4];
	MOVF        1284, 0 
	MOVWF       _Voltage_Constant+3 
;Main.c,201 :: 		ConvertIEEE754FloatToMicrochip(&Voltage_Constant);
	MOVLW       _Voltage_Constant+0
	MOVWF       FARG_ConvertIEEE754FloatToMicrochip_f+0 
	MOVLW       hi_addr(_Voltage_Constant+0)
	MOVWF       FARG_ConvertIEEE754FloatToMicrochip_f+1 
	CALL        _ConvertIEEE754FloatToMicrochip+0, 0
;Main.c,204 :: 		if(Voltage_Constant != 0)
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
	GOTO        L_SaveConstantsAndOffsets16
;Main.c,207 :: 		EEPROM_Write(0, readbuff[1]);                     // Lo(Voltage_Constant)
	CLRF        FARG_EEPROM_Write_address+0 
	MOVF        1281, 0 
	MOVWF       FARG_EEPROM_Write_data_+0 
	CALL        _EEPROM_Write+0, 0
;Main.c,208 :: 		Delay_ms(5);
	MOVLW       78
	MOVWF       R12, 0
	MOVLW       235
	MOVWF       R13, 0
L_SaveConstantsAndOffsets17:
	DECFSZ      R13, 1, 1
	BRA         L_SaveConstantsAndOffsets17
	DECFSZ      R12, 1, 1
	BRA         L_SaveConstantsAndOffsets17
;Main.c,209 :: 		EEPROM_Write(1, readbuff[2]);                     // Hi(Voltage_Constant)
	MOVLW       1
	MOVWF       FARG_EEPROM_Write_address+0 
	MOVF        1282, 0 
	MOVWF       FARG_EEPROM_Write_data_+0 
	CALL        _EEPROM_Write+0, 0
;Main.c,210 :: 		Delay_ms(5);
	MOVLW       78
	MOVWF       R12, 0
	MOVLW       235
	MOVWF       R13, 0
L_SaveConstantsAndOffsets18:
	DECFSZ      R13, 1, 1
	BRA         L_SaveConstantsAndOffsets18
	DECFSZ      R12, 1, 1
	BRA         L_SaveConstantsAndOffsets18
;Main.c,211 :: 		EEPROM_Write(2, readbuff[3]);                     // Higher(Voltage_Constant)
	MOVLW       2
	MOVWF       FARG_EEPROM_Write_address+0 
	MOVF        1283, 0 
	MOVWF       FARG_EEPROM_Write_data_+0 
	CALL        _EEPROM_Write+0, 0
;Main.c,212 :: 		Delay_ms(5);
	MOVLW       78
	MOVWF       R12, 0
	MOVLW       235
	MOVWF       R13, 0
L_SaveConstantsAndOffsets19:
	DECFSZ      R13, 1, 1
	BRA         L_SaveConstantsAndOffsets19
	DECFSZ      R12, 1, 1
	BRA         L_SaveConstantsAndOffsets19
;Main.c,213 :: 		EEPROM_Write(3, readbuff[4]);                     // Highest(Voltage_Constant)
	MOVLW       3
	MOVWF       FARG_EEPROM_Write_address+0 
	MOVF        1284, 0 
	MOVWF       FARG_EEPROM_Write_data_+0 
	CALL        _EEPROM_Write+0, 0
;Main.c,214 :: 		Delay_ms(5);
	MOVLW       78
	MOVWF       R12, 0
	MOVLW       235
	MOVWF       R13, 0
L_SaveConstantsAndOffsets20:
	DECFSZ      R13, 1, 1
	BRA         L_SaveConstantsAndOffsets20
	DECFSZ      R12, 1, 1
	BRA         L_SaveConstantsAndOffsets20
;Main.c,217 :: 		EEPROM_Write(4, readbuff[5]);                     // Lo(Voltage_offset)
	MOVLW       4
	MOVWF       FARG_EEPROM_Write_address+0 
	MOVF        1285, 0 
	MOVWF       FARG_EEPROM_Write_data_+0 
	CALL        _EEPROM_Write+0, 0
;Main.c,218 :: 		Delay_ms(5);
	MOVLW       78
	MOVWF       R12, 0
	MOVLW       235
	MOVWF       R13, 0
L_SaveConstantsAndOffsets21:
	DECFSZ      R13, 1, 1
	BRA         L_SaveConstantsAndOffsets21
	DECFSZ      R12, 1, 1
	BRA         L_SaveConstantsAndOffsets21
;Main.c,219 :: 		EEPROM_Write(5, readbuff[6]);                     // Hi(Voltage_offset)
	MOVLW       5
	MOVWF       FARG_EEPROM_Write_address+0 
	MOVF        1286, 0 
	MOVWF       FARG_EEPROM_Write_data_+0 
	CALL        _EEPROM_Write+0, 0
;Main.c,220 :: 		Delay_ms(5);
	MOVLW       78
	MOVWF       R12, 0
	MOVLW       235
	MOVWF       R13, 0
L_SaveConstantsAndOffsets22:
	DECFSZ      R13, 1, 1
	BRA         L_SaveConstantsAndOffsets22
	DECFSZ      R12, 1, 1
	BRA         L_SaveConstantsAndOffsets22
;Main.c,221 :: 		}
L_SaveConstantsAndOffsets16:
;Main.c,224 :: 		Lo(Current_Constant) = readbuff[7];
	MOVF        1287, 0 
	MOVWF       _Current_Constant+0 
;Main.c,225 :: 		Hi(Current_Constant) = readbuff[8];
	MOVF        1288, 0 
	MOVWF       _Current_Constant+1 
;Main.c,226 :: 		Higher(Current_Constant) = readbuff[9];
	MOVF        1289, 0 
	MOVWF       _Current_Constant+2 
;Main.c,227 :: 		Highest(Current_Constant) = readbuff[10];
	MOVF        1290, 0 
	MOVWF       _Current_Constant+3 
;Main.c,228 :: 		ConvertIEEE754FloatToMicrochip(&Current_Constant);
	MOVLW       _Current_Constant+0
	MOVWF       FARG_ConvertIEEE754FloatToMicrochip_f+0 
	MOVLW       hi_addr(_Current_Constant+0)
	MOVWF       FARG_ConvertIEEE754FloatToMicrochip_f+1 
	CALL        _ConvertIEEE754FloatToMicrochip+0, 0
;Main.c,231 :: 		if(Current_Constant != 0)
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
	GOTO        L_SaveConstantsAndOffsets23
;Main.c,234 :: 		EEPROM_Write(6, readbuff[7]);                     // Lo(Current_Constant)
	MOVLW       6
	MOVWF       FARG_EEPROM_Write_address+0 
	MOVF        1287, 0 
	MOVWF       FARG_EEPROM_Write_data_+0 
	CALL        _EEPROM_Write+0, 0
;Main.c,235 :: 		Delay_ms(5);
	MOVLW       78
	MOVWF       R12, 0
	MOVLW       235
	MOVWF       R13, 0
L_SaveConstantsAndOffsets24:
	DECFSZ      R13, 1, 1
	BRA         L_SaveConstantsAndOffsets24
	DECFSZ      R12, 1, 1
	BRA         L_SaveConstantsAndOffsets24
;Main.c,236 :: 		EEPROM_Write(7, readbuff[8]);                     // Hi(Current_Constant)
	MOVLW       7
	MOVWF       FARG_EEPROM_Write_address+0 
	MOVF        1288, 0 
	MOVWF       FARG_EEPROM_Write_data_+0 
	CALL        _EEPROM_Write+0, 0
;Main.c,237 :: 		Delay_ms(5);
	MOVLW       78
	MOVWF       R12, 0
	MOVLW       235
	MOVWF       R13, 0
L_SaveConstantsAndOffsets25:
	DECFSZ      R13, 1, 1
	BRA         L_SaveConstantsAndOffsets25
	DECFSZ      R12, 1, 1
	BRA         L_SaveConstantsAndOffsets25
;Main.c,238 :: 		EEPROM_Write(8, readbuff[9]);                     // Higher(Current_Constant)
	MOVLW       8
	MOVWF       FARG_EEPROM_Write_address+0 
	MOVF        1289, 0 
	MOVWF       FARG_EEPROM_Write_data_+0 
	CALL        _EEPROM_Write+0, 0
;Main.c,239 :: 		Delay_ms(5);
	MOVLW       78
	MOVWF       R12, 0
	MOVLW       235
	MOVWF       R13, 0
L_SaveConstantsAndOffsets26:
	DECFSZ      R13, 1, 1
	BRA         L_SaveConstantsAndOffsets26
	DECFSZ      R12, 1, 1
	BRA         L_SaveConstantsAndOffsets26
;Main.c,240 :: 		EEPROM_Write(9, readbuff[10]);                    // Highest(Current_Constant)
	MOVLW       9
	MOVWF       FARG_EEPROM_Write_address+0 
	MOVF        1290, 0 
	MOVWF       FARG_EEPROM_Write_data_+0 
	CALL        _EEPROM_Write+0, 0
;Main.c,241 :: 		Delay_ms(5);
	MOVLW       78
	MOVWF       R12, 0
	MOVLW       235
	MOVWF       R13, 0
L_SaveConstantsAndOffsets27:
	DECFSZ      R13, 1, 1
	BRA         L_SaveConstantsAndOffsets27
	DECFSZ      R12, 1, 1
	BRA         L_SaveConstantsAndOffsets27
;Main.c,244 :: 		EEPROM_Write(10, readbuff[11]);                   // Lo(Current_offset)
	MOVLW       10
	MOVWF       FARG_EEPROM_Write_address+0 
	MOVF        1291, 0 
	MOVWF       FARG_EEPROM_Write_data_+0 
	CALL        _EEPROM_Write+0, 0
;Main.c,245 :: 		Delay_ms(5);
	MOVLW       78
	MOVWF       R12, 0
	MOVLW       235
	MOVWF       R13, 0
L_SaveConstantsAndOffsets28:
	DECFSZ      R13, 1, 1
	BRA         L_SaveConstantsAndOffsets28
	DECFSZ      R12, 1, 1
	BRA         L_SaveConstantsAndOffsets28
;Main.c,246 :: 		EEPROM_Write(11, readbuff[12]);                   // Hi(Current_offset)
	MOVLW       11
	MOVWF       FARG_EEPROM_Write_address+0 
	MOVF        1292, 0 
	MOVWF       FARG_EEPROM_Write_data_+0 
	CALL        _EEPROM_Write+0, 0
;Main.c,247 :: 		Delay_ms(5);
	MOVLW       78
	MOVWF       R12, 0
	MOVLW       235
	MOVWF       R13, 0
L_SaveConstantsAndOffsets29:
	DECFSZ      R13, 1, 1
	BRA         L_SaveConstantsAndOffsets29
	DECFSZ      R12, 1, 1
	BRA         L_SaveConstantsAndOffsets29
;Main.c,248 :: 		}
L_SaveConstantsAndOffsets23:
;Main.c,249 :: 		}
L_end_SaveConstantsAndOffsets:
	RETURN      0
; end of _SaveConstantsAndOffsets

_LoadConstantsAndOffsets:

;Main.c,252 :: 		void LoadConstantsAndOffsets()
;Main.c,255 :: 		writebuff[52] = EEPROM_Read(0);                     // Lo(Voltage_Constant)
	CLRF        FARG_EEPROM_Read_address+0 
	CALL        _EEPROM_Read+0, 0
	MOVF        R0, 0 
	MOVWF       1396 
;Main.c,256 :: 		writebuff[53] = EEPROM_Read(1);                     // Hi(Voltage_Constant)
	MOVLW       1
	MOVWF       FARG_EEPROM_Read_address+0 
	CALL        _EEPROM_Read+0, 0
	MOVF        R0, 0 
	MOVWF       1397 
;Main.c,257 :: 		writebuff[54] = EEPROM_Read(2);                     // Higher(Voltage_Constant)
	MOVLW       2
	MOVWF       FARG_EEPROM_Read_address+0 
	CALL        _EEPROM_Read+0, 0
	MOVF        R0, 0 
	MOVWF       1398 
;Main.c,258 :: 		writebuff[55] = EEPROM_Read(3);                     // Highest(Voltage_Constant)
	MOVLW       3
	MOVWF       FARG_EEPROM_Read_address+0 
	CALL        _EEPROM_Read+0, 0
	MOVF        R0, 0 
	MOVWF       1399 
;Main.c,261 :: 		writebuff[56] = EEPROM_Read(4);                     // Lo(Voltage_offset)
	MOVLW       4
	MOVWF       FARG_EEPROM_Read_address+0 
	CALL        _EEPROM_Read+0, 0
	MOVF        R0, 0 
	MOVWF       1400 
;Main.c,262 :: 		writebuff[57] = EEPROM_Read(5);                     // Hi(Voltage_offset)
	MOVLW       5
	MOVWF       FARG_EEPROM_Read_address+0 
	CALL        _EEPROM_Read+0, 0
	MOVF        R0, 0 
	MOVWF       1401 
;Main.c,265 :: 		writebuff[58] = EEPROM_Read(6);                     // Lo(Current_Constant)
	MOVLW       6
	MOVWF       FARG_EEPROM_Read_address+0 
	CALL        _EEPROM_Read+0, 0
	MOVF        R0, 0 
	MOVWF       1402 
;Main.c,266 :: 		writebuff[59] = EEPROM_Read(7);                     // Hi(Current_Constant)
	MOVLW       7
	MOVWF       FARG_EEPROM_Read_address+0 
	CALL        _EEPROM_Read+0, 0
	MOVF        R0, 0 
	MOVWF       1403 
;Main.c,267 :: 		writebuff[60] = EEPROM_Read(8);                     // Higher(Current_Constant)
	MOVLW       8
	MOVWF       FARG_EEPROM_Read_address+0 
	CALL        _EEPROM_Read+0, 0
	MOVF        R0, 0 
	MOVWF       1404 
;Main.c,268 :: 		writebuff[61] = EEPROM_Read(9);                     // Highest(Current_Constant)
	MOVLW       9
	MOVWF       FARG_EEPROM_Read_address+0 
	CALL        _EEPROM_Read+0, 0
	MOVF        R0, 0 
	MOVWF       1405 
;Main.c,271 :: 		writebuff[62] = EEPROM_Read(10);                    // Lo(Current_offset)
	MOVLW       10
	MOVWF       FARG_EEPROM_Read_address+0 
	CALL        _EEPROM_Read+0, 0
	MOVF        R0, 0 
	MOVWF       1406 
;Main.c,272 :: 		writebuff[63] = EEPROM_Read(11);                    // Hi(Current_offset)
	MOVLW       11
	MOVWF       FARG_EEPROM_Read_address+0 
	CALL        _EEPROM_Read+0, 0
	MOVF        R0, 0 
	MOVWF       1407 
;Main.c,273 :: 		}
L_end_LoadConstantsAndOffsets:
	RETURN      0
; end of _LoadConstantsAndOffsets

_USBDev_EventHandler:

;Main.c,276 :: 		void USBDev_EventHandler(uint8_t event)
;Main.c,278 :: 		switch(event)
	GOTO        L_USBDev_EventHandler30
;Main.c,281 :: 		case _USB_DEV_EVENT_CONFIGURED:
L_USBDev_EventHandler32:
;Main.c,283 :: 		USBDev_SetReceiveBuffer(1, readbuff);
	MOVLW       1
	MOVWF       FARG_USBDev_SetReceiveBuffer_epNum+0 
	MOVLW       _readbuff+0
	MOVWF       FARG_USBDev_SetReceiveBuffer_dataBuffer+0 
	MOVLW       hi_addr(_readbuff+0)
	MOVWF       FARG_USBDev_SetReceiveBuffer_dataBuffer+1 
	CALL        _USBDev_SetReceiveBuffer+0, 0
;Main.c,284 :: 		break;
	GOTO        L_USBDev_EventHandler31
;Main.c,285 :: 		}
L_USBDev_EventHandler30:
	MOVF        FARG_USBDev_EventHandler_event+0, 0 
	XORLW       5
	BTFSC       STATUS+0, 2 
	GOTO        L_USBDev_EventHandler32
L_USBDev_EventHandler31:
;Main.c,286 :: 		}
L_end_USBDev_EventHandler:
	RETURN      0
; end of _USBDev_EventHandler

_USBDev_DataReceivedHandler:

;Main.c,289 :: 		void USBDev_DataReceivedHandler(uint8_t ep, uint16_t size)
;Main.c,291 :: 		if(ep == 1)
	MOVF        FARG_USBDev_DataReceivedHandler_ep+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_USBDev_DataReceivedHandler33
;Main.c,293 :: 		dataReceivedFlag = 1;
	MOVLW       1
	MOVWF       _dataReceivedFlag+0 
;Main.c,294 :: 		}
L_USBDev_DataReceivedHandler33:
;Main.c,295 :: 		}
L_end_USBDev_DataReceivedHandler:
	RETURN      0
; end of _USBDev_DataReceivedHandler

_USBDev_DataSentHandler:

;Main.c,298 :: 		void USBDev_DataSentHandler(uint8_t ep)
;Main.c,300 :: 		if(ep == 1)
	MOVF        FARG_USBDev_DataSentHandler_ep+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_USBDev_DataSentHandler34
;Main.c,302 :: 		UsbDataSentFlag = 1;
	MOVLW       1
	MOVWF       _UsbDataSentFlag+0 
;Main.c,304 :: 		USBDev_SetReceiveBuffer(1, readbuff);
	MOVLW       1
	MOVWF       FARG_USBDev_SetReceiveBuffer_epNum+0 
	MOVLW       _readbuff+0
	MOVWF       FARG_USBDev_SetReceiveBuffer_dataBuffer+0 
	MOVLW       hi_addr(_readbuff+0)
	MOVWF       FARG_USBDev_SetReceiveBuffer_dataBuffer+1 
	CALL        _USBDev_SetReceiveBuffer+0, 0
;Main.c,305 :: 		}
L_USBDev_DataSentHandler34:
;Main.c,306 :: 		}
L_end_USBDev_DataSentHandler:
	RETURN      0
; end of _USBDev_DataSentHandler
