; ************************************************************************
; 	INTERRUPT VECTOR
; ************************************************************************
	org 0x08
	movwf W_TEMP		; Saving important registers
	movff STATUS,ST_TEMP
;
 	btfsc PIR1,TMR2IF
	bra PTMR2		; Timer2 overflow processing (reserved)
;
gback	movf W_TEMP,W
	movff ST_TEMP,STATUS	; Restoring important registers
	retfie
; ************************************************************************
;	Timer2 interrupt processing 
; ************************************************************************
PTMR2	bcf PIR1,TMR2IF		; очистка флага прерывания
	bcf FIRE
	bcf T2CON,TMR2ON	; выключение таймера
	bra gback
