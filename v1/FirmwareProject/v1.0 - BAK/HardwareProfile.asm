
_ConfigureIO:

;HardwareProfile.c,6 :: 		void ConfigureIO()
;HardwareProfile.c,9 :: 		PORTA = 0;
	CLRF        PORTA+0 
;HardwareProfile.c,10 :: 		PORtB = 0;
	CLRF        PORTB+0 
;HardwareProfile.c,11 :: 		PORTC = 0;
	CLRF        PORTC+0 
;HardwareProfile.c,14 :: 		_OP_LED1 = 0;
	BCF         RB1_bit+0, BitPos(RB1_bit+0) 
;HardwareProfile.c,15 :: 		_DR_LED1 = 0;
	BCF         TRISB1_bit+0, BitPos(TRISB1_bit+0) 
;HardwareProfile.c,18 :: 		_IP_SW1 = 0;
	BCF         RB0_bit+0, BitPos(RB0_bit+0) 
;HardwareProfile.c,19 :: 		_DR_SW1 = 1;
	BSF         TRISB0_bit+0, BitPos(TRISB0_bit+0) 
;HardwareProfile.c,20 :: 		}
L_end_ConfigureIO:
	RETURN      0
; end of _ConfigureIO

_ConfigureModules:

;HardwareProfile.c,24 :: 		void ConfigureModules()
;HardwareProfile.c,27 :: 		ADCON1 = 6;
	MOVLW       6
	MOVWF       ADCON1+0 
;HardwareProfile.c,30 :: 		CMCON = 7;
	MOVLW       7
	MOVWF       CMCON+0 
;HardwareProfile.c,31 :: 		}
L_end_ConfigureModules:
	RETURN      0
; end of _ConfigureModules

_ConfigureInterrupts:

;HardwareProfile.c,35 :: 		void ConfigureInterrupts()
;HardwareProfile.c,38 :: 		INTCON = 0;
	CLRF        INTCON+0 
;HardwareProfile.c,39 :: 		}
L_end_ConfigureInterrupts:
	RETURN      0
; end of _ConfigureInterrupts
