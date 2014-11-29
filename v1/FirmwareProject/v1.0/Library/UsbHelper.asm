
_HID_WriteBuffer:

;UsbHelper.c,8 :: 		uint8_t HID_WriteBuffer()
;UsbHelper.c,11 :: 		UsbPacketSentComplete = 0;
	CLRF        _UsbPacketSentComplete+0 
;UsbHelper.c,12 :: 		USBDev_SendPacket(1, USB_WRITE_BUFFER, 64);
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
;UsbHelper.c,15 :: 		usbWriteTimeoutCounter = USB_WRITE_TIMEOUT;
	MOVLW       232
	MOVWF       _usbWriteTimeoutCounter+0 
	MOVLW       3
	MOVWF       _usbWriteTimeoutCounter+1 
;UsbHelper.c,16 :: 		while(!UsbPacketSentComplete)
L_HID_WriteBuffer0:
	MOVF        _UsbPacketSentComplete+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_HID_WriteBuffer1
;UsbHelper.c,18 :: 		if(usbWriteTimeoutCounter == 0) { return 0; }
	MOVLW       0
	XORWF       _usbWriteTimeoutCounter+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__HID_WriteBuffer9
	MOVLW       0
	XORWF       _usbWriteTimeoutCounter+0, 0 
L__HID_WriteBuffer9:
	BTFSS       STATUS+0, 2 
	GOTO        L_HID_WriteBuffer2
	CLRF        R0 
	GOTO        L_end_HID_WriteBuffer
L_HID_WriteBuffer2:
;UsbHelper.c,19 :: 		usbWriteTimeoutCounter--;
	MOVLW       1
	SUBWF       _usbWriteTimeoutCounter+0, 1 
	MOVLW       0
	SUBWFB      _usbWriteTimeoutCounter+1, 1 
;UsbHelper.c,20 :: 		}
	GOTO        L_HID_WriteBuffer0
L_HID_WriteBuffer1:
;UsbHelper.c,21 :: 		return 0xFF;
	MOVLW       255
	MOVWF       R0 
;UsbHelper.c,22 :: 		}
L_end_HID_WriteBuffer:
	RETURN      0
; end of _HID_WriteBuffer

_USBDev_EventHandler:

;UsbHelper.c,25 :: 		void USBDev_EventHandler(uint8_t event)
;UsbHelper.c,27 :: 		switch(event)
	GOTO        L_USBDev_EventHandler3
;UsbHelper.c,30 :: 		case _USB_DEV_EVENT_CONFIGURED:
L_USBDev_EventHandler5:
;UsbHelper.c,32 :: 		USBDev_SetReceiveBuffer(1, USB_READ_BUFFER);
	MOVLW       1
	MOVWF       FARG_USBDev_SetReceiveBuffer_epNum+0 
	MOVLW       _readbuff+0
	MOVWF       FARG_USBDev_SetReceiveBuffer_dataBuffer+0 
	MOVLW       hi_addr(_readbuff+0)
	MOVWF       FARG_USBDev_SetReceiveBuffer_dataBuffer+1 
	CALL        _USBDev_SetReceiveBuffer+0, 0
;UsbHelper.c,33 :: 		break;
	GOTO        L_USBDev_EventHandler4
;UsbHelper.c,34 :: 		}
L_USBDev_EventHandler3:
	MOVF        FARG_USBDev_EventHandler_event+0, 0 
	XORLW       5
	BTFSC       STATUS+0, 2 
	GOTO        L_USBDev_EventHandler5
L_USBDev_EventHandler4:
;UsbHelper.c,35 :: 		}
L_end_USBDev_EventHandler:
	RETURN      0
; end of _USBDev_EventHandler

_USBDev_DataReceivedHandler:

;UsbHelper.c,38 :: 		void USBDev_DataReceivedHandler(uint8_t ep, uint16_t size)
;UsbHelper.c,40 :: 		if(ep == 1) { UsbNewPacketReceived = 1; }
	MOVF        FARG_USBDev_DataReceivedHandler_ep+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_USBDev_DataReceivedHandler6
	MOVLW       1
	MOVWF       _UsbNewPacketReceived+0 
L_USBDev_DataReceivedHandler6:
;UsbHelper.c,41 :: 		}
L_end_USBDev_DataReceivedHandler:
	RETURN      0
; end of _USBDev_DataReceivedHandler

_USBDev_DataSentHandler:

;UsbHelper.c,44 :: 		void USBDev_DataSentHandler(uint8_t ep)
;UsbHelper.c,46 :: 		if(ep == 1)
	MOVF        FARG_USBDev_DataSentHandler_ep+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_USBDev_DataSentHandler7
;UsbHelper.c,48 :: 		UsbPacketSentComplete = 1;
	MOVLW       1
	MOVWF       _UsbPacketSentComplete+0 
;UsbHelper.c,51 :: 		USBDev_SetReceiveBuffer(1, USB_READ_BUFFER);
	MOVLW       1
	MOVWF       FARG_USBDev_SetReceiveBuffer_epNum+0 
	MOVLW       _readbuff+0
	MOVWF       FARG_USBDev_SetReceiveBuffer_dataBuffer+0 
	MOVLW       hi_addr(_readbuff+0)
	MOVWF       FARG_USBDev_SetReceiveBuffer_dataBuffer+1 
	CALL        _USBDev_SetReceiveBuffer+0, 0
;UsbHelper.c,52 :: 		}
L_USBDev_DataSentHandler7:
;UsbHelper.c,53 :: 		}
L_end_USBDev_DataSentHandler:
	RETURN      0
; end of _USBDev_DataSentHandler
