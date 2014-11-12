
_main:

;Main.c,63 :: 		void main()
;Main.c,66 :: 		unsigned char i = 0;
	CLRF        main_i_L0+0 
	CLRF        main_buffIndex_L0+0 
	CLRF        main_lastValue_L0+0 
	CLRF        main_lastValue_L0+1 
	CLRF        main_AbsValue_L0+0 
	CLRF        main_AbsValue_L0+1 
;Main.c,72 :: 		ConfigureIO();
	CALL        _ConfigureIO+0, 0
;Main.c,73 :: 		ConfigureModules();
	CALL        _ConfigureModules+0, 0
;Main.c,74 :: 		ConfigureInterrupts();
	CALL        _ConfigureInterrupts+0, 0
;Main.c,87 :: 		SPI1_Init_Advanced(_SPI_MASTER_OSC_DIV16, _SPI_DATA_SAMPLE_MIDDLE, _SPI_CLK_IDLE_LOW, _SPI_LOW_2_HIGH);
	MOVLW       1
	MOVWF       FARG_SPI1_Init_Advanced_master+0 
	CLRF        FARG_SPI1_Init_Advanced_data_sample+0 
	CLRF        FARG_SPI1_Init_Advanced_clock_idle+0 
	MOVLW       1
	MOVWF       FARG_SPI1_Init_Advanced_transmit_edge+0 
	CALL        _SPI1_Init_Advanced+0, 0
;Main.c,90 :: 		USBDev_HIDInit();
	CALL        _USBDev_HIDInit+0, 0
;Main.c,93 :: 		USBDev_Init();
	CALL        _USBDev_Init+0, 0
;Main.c,96 :: 		IPEN_bit = 1;
	BSF         IPEN_bit+0, BitPos(IPEN_bit+0) 
;Main.c,97 :: 		USBIP_bit = 1;
	BSF         USBIP_bit+0, BitPos(USBIP_bit+0) 
;Main.c,98 :: 		USBIE_bit = 1;
	BSF         USBIE_bit+0, BitPos(USBIE_bit+0) 
;Main.c,99 :: 		GIEH_bit = 1;
	BSF         GIEH_bit+0, BitPos(GIEH_bit+0) 
;Main.c,102 :: 		MCP3304_Init();
	CALL        _MCP3304_Init+0, 0
;Main.c,105 :: 		while(USBDev_GetDeviceState() != _USB_DEV_STATE_CONFIGURED) { }
L_main0:
	CALL        _USBDev_GetDeviceState+0, 0
	MOVF        R0, 0 
	XORLW       16
	BTFSC       STATUS+0, 2 
	GOTO        L_main1
	GOTO        L_main0
L_main1:
;Main.c,108 :: 		_OP_SIG = 0;
	BCF         LATC2_bit+0, BitPos(LATC2_bit+0) 
;Main.c,109 :: 		_DR_SIG = 0;
	BCF         TRISC2_bit+0, BitPos(TRISC2_bit+0) 
;Main.c,113 :: 		while(1)
L_main2:
;Main.c,116 :: 		_OP_SIG = 1;
	BSF         LATC2_bit+0, BitPos(LATC2_bit+0) 
;Main.c,120 :: 		buffIndex = 0;
	CLRF        main_buffIndex_L0+0 
;Main.c,121 :: 		for(i = 0; i < 25; i++)
	CLRF        main_i_L0+0 
L_main4:
	MOVLW       25
	SUBWF       main_i_L0+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_main5
;Main.c,124 :: 		MCP3304_Read(0);
	CLRF        FARG_MCP3304_Read_Channel+0 
	CALL        _MCP3304_Read+0, 0
;Main.c,127 :: 		if(MCP3304_Data & 0x8000)
	BTFSS       _MCP3304_Data+1, 7 
	GOTO        L_main7
;Main.c,129 :: 		AbsValue =  MCP3304_Data * -1;
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
;Main.c,130 :: 		MCP3304_Data = (AbsValue + lastValue) / 2;
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
;Main.c,131 :: 		MCP3304_Data *= -1;
	MOVLW       255
	MOVWF       R4 
	MOVLW       255
	MOVWF       R5 
	CALL        _Mul_16x16_U+0, 0
	MOVF        R0, 0 
	MOVWF       _MCP3304_Data+0 
	MOVF        R1, 0 
	MOVWF       _MCP3304_Data+1 
;Main.c,132 :: 		Delay_us(5);
	MOVLW       19
	MOVWF       R13, 0
L_main8:
	DECFSZ      R13, 1, 1
	BRA         L_main8
	NOP
	NOP
;Main.c,133 :: 		}
	GOTO        L_main9
L_main7:
;Main.c,136 :: 		AbsValue =  MCP3304_Data;
	MOVF        _MCP3304_Data+0, 0 
	MOVWF       main_AbsValue_L0+0 
	MOVF        _MCP3304_Data+1, 0 
	MOVWF       main_AbsValue_L0+1 
;Main.c,137 :: 		MCP3304_Data = (AbsValue + lastValue) / 2;
	MOVF        main_lastValue_L0+0, 0 
	ADDWF       _MCP3304_Data+0, 1 
	MOVF        main_lastValue_L0+1, 0 
	ADDWFC      _MCP3304_Data+1, 1 
	RRCF        _MCP3304_Data+1, 1 
	RRCF        _MCP3304_Data+0, 1 
	BCF         _MCP3304_Data+1, 7 
;Main.c,138 :: 		Delay_us(15);
	MOVLW       59
	MOVWF       R13, 0
L_main10:
	DECFSZ      R13, 1, 1
	BRA         L_main10
	NOP
	NOP
;Main.c,139 :: 		}
L_main9:
;Main.c,140 :: 		lastValue = AbsValue;
	MOVF        main_AbsValue_L0+0, 0 
	MOVWF       main_lastValue_L0+0 
	MOVF        main_AbsValue_L0+1, 0 
	MOVWF       main_lastValue_L0+1 
;Main.c,143 :: 		writebuff[buffIndex] = Lo(MCP3304_Data);
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
;Main.c,144 :: 		writebuff[buffIndex + 1] = Hi(MCP3304_Data);
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
;Main.c,145 :: 		buffIndex += 2;
	MOVLW       2
	ADDWF       main_buffIndex_L0+0, 1 
;Main.c,121 :: 		for(i = 0; i < 25; i++)
	INCF        main_i_L0+0, 1 
;Main.c,146 :: 		}
	GOTO        L_main4
L_main5:
;Main.c,149 :: 		MCP3304_Read(2);
	MOVLW       2
	MOVWF       FARG_MCP3304_Read_Channel+0 
	CALL        _MCP3304_Read+0, 0
;Main.c,150 :: 		writebuff[50] = Lo(MCP3304_Data);
	MOVF        _MCP3304_Data+0, 0 
	MOVWF       1394 
;Main.c,151 :: 		writebuff[51] = Hi(MCP3304_Data);
	MOVF        _MCP3304_Data+1, 0 
	MOVWF       1395 
;Main.c,154 :: 		_OP_SIG = 0;
	BCF         LATC2_bit+0, BitPos(LATC2_bit+0) 
;Main.c,158 :: 		UsbDataSentFlag = 0;
	CLRF        _UsbDataSentFlag+0 
;Main.c,159 :: 		USBDev_SendPacket(1, writebuff, 64);
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
;Main.c,160 :: 		while(!UsbDataSentFlag) { }
L_main11:
	MOVF        _UsbDataSentFlag+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_main12
	GOTO        L_main11
L_main12:
;Main.c,163 :: 		}
	GOTO        L_main2
;Main.c,164 :: 		}
L_end_main:
	GOTO        $+0
; end of _main

_USBDev_EventHandler:

;Main.c,167 :: 		void USBDev_EventHandler(uint8_t event)
;Main.c,169 :: 		switch(event)
	GOTO        L_USBDev_EventHandler13
;Main.c,172 :: 		case _USB_DEV_EVENT_CONFIGURED:
L_USBDev_EventHandler15:
;Main.c,174 :: 		USBDev_SetReceiveBuffer(1, readbuff);
	MOVLW       1
	MOVWF       FARG_USBDev_SetReceiveBuffer_epNum+0 
	MOVLW       _readbuff+0
	MOVWF       FARG_USBDev_SetReceiveBuffer_dataBuffer+0 
	MOVLW       hi_addr(_readbuff+0)
	MOVWF       FARG_USBDev_SetReceiveBuffer_dataBuffer+1 
	CALL        _USBDev_SetReceiveBuffer+0, 0
;Main.c,175 :: 		break;
	GOTO        L_USBDev_EventHandler14
;Main.c,176 :: 		}
L_USBDev_EventHandler13:
	MOVF        FARG_USBDev_EventHandler_event+0, 0 
	XORLW       5
	BTFSC       STATUS+0, 2 
	GOTO        L_USBDev_EventHandler15
L_USBDev_EventHandler14:
;Main.c,177 :: 		}
L_end_USBDev_EventHandler:
	RETURN      0
; end of _USBDev_EventHandler

_USBDev_DataReceivedHandler:

;Main.c,180 :: 		void USBDev_DataReceivedHandler(uint8_t ep, uint16_t size)
;Main.c,182 :: 		if(ep == 1)
	MOVF        FARG_USBDev_DataReceivedHandler_ep+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_USBDev_DataReceivedHandler16
;Main.c,184 :: 		dataReceivedFlag = 1;
	MOVLW       1
	MOVWF       _dataReceivedFlag+0 
;Main.c,185 :: 		}
L_USBDev_DataReceivedHandler16:
;Main.c,186 :: 		}
L_end_USBDev_DataReceivedHandler:
	RETURN      0
; end of _USBDev_DataReceivedHandler

_USBDev_DataSentHandler:

;Main.c,189 :: 		void USBDev_DataSentHandler(uint8_t ep)
;Main.c,191 :: 		if(ep == 1)
	MOVF        FARG_USBDev_DataSentHandler_ep+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_USBDev_DataSentHandler17
;Main.c,193 :: 		UsbDataSentFlag = 1;
	MOVLW       1
	MOVWF       _UsbDataSentFlag+0 
;Main.c,195 :: 		USBDev_SetReceiveBuffer(1, readbuff);
	MOVLW       1
	MOVWF       FARG_USBDev_SetReceiveBuffer_epNum+0 
	MOVLW       _readbuff+0
	MOVWF       FARG_USBDev_SetReceiveBuffer_dataBuffer+0 
	MOVLW       hi_addr(_readbuff+0)
	MOVWF       FARG_USBDev_SetReceiveBuffer_dataBuffer+1 
	CALL        _USBDev_SetReceiveBuffer+0, 0
;Main.c,196 :: 		}
L_USBDev_DataSentHandler17:
;Main.c,197 :: 		}
L_end_USBDev_DataSentHandler:
	RETURN      0
; end of _USBDev_DataSentHandler
