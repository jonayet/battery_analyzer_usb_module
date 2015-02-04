
_ConfigureIO:

;HardwareProfile.c,6 :: 		void ConfigureIO()
;HardwareProfile.c,9 :: 		PORTA = 0;
	CLRF        PORTA+0 
;HardwareProfile.c,10 :: 		PORTB = 0;
	CLRF        PORTB+0 
;HardwareProfile.c,11 :: 		PORTC = 0;
	CLRF        PORTC+0 
;HardwareProfile.c,12 :: 		}
L_end_ConfigureIO:
	RETURN      0
; end of _ConfigureIO

_ConfigureModules:

;HardwareProfile.c,16 :: 		void ConfigureModules()
;HardwareProfile.c,19 :: 		ADCON1 = 6;
	MOVLW       6
	MOVWF       ADCON1+0 
;HardwareProfile.c,22 :: 		CMCON = 7;
	MOVLW       7
	MOVWF       CMCON+0 
;HardwareProfile.c,23 :: 		}
L_end_ConfigureModules:
	RETURN      0
; end of _ConfigureModules

_ConfigureInterrupts:

;HardwareProfile.c,27 :: 		void ConfigureInterrupts()
;HardwareProfile.c,30 :: 		INTCON = 0;
	CLRF        INTCON+0 
;HardwareProfile.c,31 :: 		}
L_end_ConfigureInterrupts:
	RETURN      0
; end of _ConfigureInterrupts
