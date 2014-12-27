
_MCP3304_Init:

;MCP3304.c,4 :: 		void MCP3304_Init()
;MCP3304.c,6 :: 		_MCP3304_OP_CS = 1;
	BSF         LATB2_bit+0, BitPos(LATB2_bit+0) 
;MCP3304.c,7 :: 		_MCP3304_DR_CS = 0;
	BCF         TRISB2_bit+0, BitPos(TRISB2_bit+0) 
;MCP3304.c,8 :: 		MCP3304_Data = 0;
	CLRF        _MCP3304_Data+0 
	CLRF        _MCP3304_Data+1 
;MCP3304.c,9 :: 		}
L_end_MCP3304_Init:
	RETURN      0
; end of _MCP3304_Init

_MCP3304_Read:

;MCP3304.c,13 :: 		void MCP3304_Read(unsigned char Channel)
;MCP3304.c,16 :: 		_MCP3304_OP_CS = 0;
	BCF         LATB2_bit+0, BitPos(LATB2_bit+0) 
;MCP3304.c,18 :: 		D0 = 0;
	CLRF        _D0+0 
;MCP3304.c,19 :: 		D2D1 = 0;
	CLRF        _D2D1+0 
;MCP3304.c,20 :: 		if(Channel & 0x01) { D0 = 0x80; }
	BTFSS       FARG_MCP3304_Read_Channel+0, 0 
	GOTO        L_MCP3304_Read0
	MOVLW       128
	MOVWF       _D0+0 
L_MCP3304_Read0:
;MCP3304.c,21 :: 		if(Channel & 0x02) { D2D1 = 0x01; }
	BTFSS       FARG_MCP3304_Read_Channel+0, 1 
	GOTO        L_MCP3304_Read1
	MOVLW       1
	MOVWF       _D2D1+0 
L_MCP3304_Read1:
;MCP3304.c,22 :: 		if(Channel & 0x04) { D2D1 |= 0x02; }
	BTFSS       FARG_MCP3304_Read_Channel+0, 2 
	GOTO        L_MCP3304_Read2
	BSF         _D2D1+0, 1 
L_MCP3304_Read2:
;MCP3304.c,25 :: 		_SPI_WRITE_READ(0b00001100 | D2D1);      // 0b00001000
	MOVLW       12
	IORWF       _D2D1+0, 0 
	MOVWF       FARG_SPI1_Read_buffer+0 
	CALL        _SPI1_Read+0, 0
;MCP3304.c,28 :: 		Hi(MCP3304_Data) = _SPI_WRITE_READ(D0) & 0x1F;
	MOVF        _D0+0, 0 
	MOVWF       FARG_SPI1_Read_buffer+0 
	CALL        _SPI1_Read+0, 0
	MOVLW       31
	ANDWF       R0, 0 
	MOVWF       _MCP3304_Data+1 
;MCP3304.c,31 :: 		Lo(MCP3304_Data) = _SPI_WRITE_READ(0);
	CLRF        FARG_SPI1_Read_buffer+0 
	CALL        _SPI1_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _MCP3304_Data+0 
;MCP3304.c,34 :: 		_MCP3304_OP_CS = 1;
	BSF         LATB2_bit+0, BitPos(LATB2_bit+0) 
;MCP3304.c,37 :: 		if(MCP3304_Data & 0x1000)
	BTFSS       _MCP3304_Data+1, 4 
	GOTO        L_MCP3304_Read3
;MCP3304.c,39 :: 		MCP3304_Data |= 0xE000;
	MOVLW       0
	IORWF       _MCP3304_Data+0, 1 
	MOVLW       224
	IORWF       _MCP3304_Data+1, 1 
;MCP3304.c,40 :: 		}
L_MCP3304_Read3:
;MCP3304.c,41 :: 		}
L_end_MCP3304_Read:
	RETURN      0
; end of _MCP3304_Read
