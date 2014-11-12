
_interrupt:

;Interrupt.c,6 :: 		void interrupt()
;Interrupt.c,9 :: 		USBDev_IntHandler();
	CALL        _USBDev_IntHandler+0, 0
;Interrupt.c,10 :: 		}
L_end_interrupt:
L__interrupt1:
	RETFIE      1
; end of _interrupt

_interrupt_low:
	MOVWF       ___Low_saveWREG+0 
	MOVF        STATUS+0, 0 
	MOVWF       ___Low_saveSTATUS+0 
	MOVF        BSR+0, 0 
	MOVWF       ___Low_saveBSR+0 

;Interrupt.c,12 :: 		void interrupt_low()
;Interrupt.c,15 :: 		}
L_end_interrupt_low:
L__interrupt_low3:
	MOVF        ___Low_saveBSR+0, 0 
	MOVWF       BSR+0 
	MOVF        ___Low_saveSTATUS+0, 0 
	MOVWF       STATUS+0 
	SWAPF       ___Low_saveWREG+0, 1 
	SWAPF       ___Low_saveWREG+0, 0 
	RETFIE      0
; end of _interrupt_low

Interrupt____?ag:

L_end_Interrupt___?ag:
	RETURN      0
; end of Interrupt____?ag
