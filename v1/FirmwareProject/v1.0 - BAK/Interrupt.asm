
_interrupt:

;Interrupt.c,6 :: 		void interrupt()
;Interrupt.c,9 :: 		USB_Interrupt_Proc();
	CALL        _USB_Interrupt_Proc+0, 0
;Interrupt.c,10 :: 		}
L_end_interrupt:
L__interrupt1:
	RETFIE      1
; end of _interrupt
