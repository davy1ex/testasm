; ************************************************************************
; 	HIGH PRIORITY INTERRUPT VECTOR
; ************************************************************************
	org 0x08
	bcf INTCON,INT0IF
	bsf Y
	retfie
; ************************************************************************
; 	LOW PRIORITY INTERRUPT VECTOR
; ************************************************************************
	org 0x18
	movwf W_TEMP		; Saving important registers
	movff STATUS,ST_TEMP
;
	btfsc PIR1,RCIF
	bra PREC		; USART receive processing
;
	btfsc PIR1,TXIF
	bra PTRANS		; USART transmit processing
;
gback	movf W_TEMP,W
	movff ST_TEMP,STATUS	; Restoring important registers
	retfie
; ************************************************************************
;	Receiver interrupt processing 
; ************************************************************************
PREC	btfss RCSTA,FERR	; Framing error ?
	bra cntx
	movf RCREG,W		; if error, ignore interrupt 
	bra gback		
cntx	btfsc RCSTA,OERR	; receive buffer overflow ?
	call OerrP		; if yes, clear OERR
	movf RCREG,W
; *************************************************************************
; Command processing
; *************************************************************************
Str	sublw 0xAB		
	bnz $+4
	bsf X			; установить флаг передачи
	bra gback
;	
OerrP	bcf RCSTA,CREN		; if OERR is set, clear it
	bsf RCSTA,CREN		; data will be lost
	return
; ************************************************************************
;	USART transmit processing
; ************************************************************************
PTRANS	movff POSTINC0,TXREG	; Transmit current byte
	movlw BUFFER+6
	cpfseq FSR0L 
	bra gback
;
	btfss TXSTA,TRMT
	bra $-2
;
	bcf PIE1,TXIE		; disable transmission interrupt
	bcf TXSTA,TXEN		; disable transmission
	bcf PIR1,TXIF
	bcf ACT
	bra gback			