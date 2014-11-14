
_ConvertIEEE754FloatToMicrochip:

;FloatConverter.c,5 :: 		void ConvertIEEE754FloatToMicrochip(float *f)
;FloatConverter.c,7 :: 		ptr = (char *)f;
	MOVF        FARG_ConvertIEEE754FloatToMicrochip_f+0, 0 
	MOVWF       _ptr+0 
	MOVF        FARG_ConvertIEEE754FloatToMicrochip_f+1, 0 
	MOVWF       _ptr+1 
;FloatConverter.c,8 :: 		sign = ptr[3].B7;
	MOVLW       3
	ADDWF       FARG_ConvertIEEE754FloatToMicrochip_f+0, 0 
	MOVWF       R3 
	MOVLW       0
	ADDWFC      FARG_ConvertIEEE754FloatToMicrochip_f+1, 0 
	MOVWF       R4 
	MOVFF       R3, FSR0
	MOVFF       R4, FSR0H
	MOVF        POSTINC0+0, 0 
	MOVWF       R0 
	MOVLW       0
	BTFSC       R0, 7 
	MOVLW       1
	MOVWF       _sign+0 
;FloatConverter.c,9 :: 		ptr[3] <<= 1;
	MOVFF       R3, FSR0
	MOVFF       R4, FSR0H
	MOVF        POSTINC0+0, 0 
	MOVWF       R2 
	MOVF        R2, 0 
	MOVWF       R0 
	RLCF        R0, 1 
	BCF         R0, 0 
	MOVFF       R3, FSR1
	MOVFF       R4, FSR1H
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
;FloatConverter.c,10 :: 		ptr[3].B0 = ptr[2].B7;
	MOVLW       3
	ADDWF       _ptr+0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      _ptr+1, 0 
	MOVWF       FSR1H 
	MOVLW       2
	ADDWF       _ptr+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      _ptr+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       R0 
	BTFSC       R0, 7 
	GOTO        L__ConvertIEEE754FloatToMicrochip1
	BCF         POSTINC1+0, 0 
	GOTO        L__ConvertIEEE754FloatToMicrochip2
L__ConvertIEEE754FloatToMicrochip1:
	BSF         POSTINC1+0, 0 
L__ConvertIEEE754FloatToMicrochip2:
;FloatConverter.c,11 :: 		ptr[2].B7 = sign;
	MOVLW       2
	ADDWF       _ptr+0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      _ptr+1, 0 
	MOVWF       FSR1H 
	BTFSC       _sign+0, 0 
	GOTO        L__ConvertIEEE754FloatToMicrochip3
	BCF         POSTINC1+0, 7 
	GOTO        L__ConvertIEEE754FloatToMicrochip4
L__ConvertIEEE754FloatToMicrochip3:
	BSF         POSTINC1+0, 7 
L__ConvertIEEE754FloatToMicrochip4:
;FloatConverter.c,12 :: 		}
L_end_ConvertIEEE754FloatToMicrochip:
	RETURN      0
; end of _ConvertIEEE754FloatToMicrochip

_ConvertMicrochipFloatToIEEE754:

;FloatConverter.c,14 :: 		void ConvertMicrochipFloatToIEEE754(float *f)
;FloatConverter.c,16 :: 		ptr = (char *)f;
	MOVF        FARG_ConvertMicrochipFloatToIEEE754_f+0, 0 
	MOVWF       _ptr+0 
	MOVF        FARG_ConvertMicrochipFloatToIEEE754_f+1, 0 
	MOVWF       _ptr+1 
;FloatConverter.c,17 :: 		sign = ptr[2].B7;
	MOVLW       2
	ADDWF       FARG_ConvertMicrochipFloatToIEEE754_f+0, 0 
	MOVWF       R1 
	MOVLW       0
	ADDWFC      FARG_ConvertMicrochipFloatToIEEE754_f+1, 0 
	MOVWF       R2 
	MOVFF       R1, FSR0
	MOVFF       R2, FSR0H
	MOVF        POSTINC0+0, 0 
	MOVWF       R0 
	MOVLW       0
	BTFSC       R0, 7 
	MOVLW       1
	MOVWF       _sign+0 
;FloatConverter.c,18 :: 		ptr[2].B7 = ptr[3].B0;
	MOVLW       3
	ADDWF       FARG_ConvertMicrochipFloatToIEEE754_f+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_ConvertMicrochipFloatToIEEE754_f+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       R0 
	MOVFF       R1, FSR1
	MOVFF       R2, FSR1H
	BTFSC       R0, 0 
	GOTO        L__ConvertMicrochipFloatToIEEE7546
	BCF         POSTINC1+0, 7 
	GOTO        L__ConvertMicrochipFloatToIEEE7547
L__ConvertMicrochipFloatToIEEE7546:
	BSF         POSTINC1+0, 7 
L__ConvertMicrochipFloatToIEEE7547:
;FloatConverter.c,19 :: 		ptr[3] >>= 1;
	MOVLW       3
	ADDWF       _ptr+0, 0 
	MOVWF       R3 
	MOVLW       0
	ADDWFC      _ptr+1, 0 
	MOVWF       R4 
	MOVFF       R3, FSR0
	MOVFF       R4, FSR0H
	MOVF        POSTINC0+0, 0 
	MOVWF       R2 
	MOVF        R2, 0 
	MOVWF       R0 
	RRCF        R0, 1 
	BCF         R0, 7 
	MOVFF       R3, FSR1
	MOVFF       R4, FSR1H
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
;FloatConverter.c,20 :: 		ptr[3].B7 = sign;
	MOVLW       3
	ADDWF       _ptr+0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      _ptr+1, 0 
	MOVWF       FSR1H 
	BTFSC       _sign+0, 0 
	GOTO        L__ConvertMicrochipFloatToIEEE7548
	BCF         POSTINC1+0, 7 
	GOTO        L__ConvertMicrochipFloatToIEEE7549
L__ConvertMicrochipFloatToIEEE7548:
	BSF         POSTINC1+0, 7 
L__ConvertMicrochipFloatToIEEE7549:
;FloatConverter.c,21 :: 		}
L_end_ConvertMicrochipFloatToIEEE754:
	RETURN      0
; end of _ConvertMicrochipFloatToIEEE754
