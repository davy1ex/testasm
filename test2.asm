	include p18f452.inc
	include "test.h"
; ************************************************************************
;	RESET VECTOR
; ************************************************************************
 	ORG 0x00
	bra Pentry
; ************************************************************************
	include intvect1.inc
; ************************************************************************
;	I/O CONFIGURATION	
; ************************************************************************
Pentry	movlw 0xFE
	movwf TRISC		; RC0 - ˜˜˜˜˜, ˜˜˜˜˜˜˜˜˜ - ˜˜˜˜˜ (TRISC=0FE)
; ************************************************************************
;	GENERAL INITIALISATION
; ************************************************************************
	bcf INTCON2,NOT_RBPU	; ˜˜˜˜˜˜˜˜ ˜˜˜˜˜˜˜˜˜˜˜˜˜ ˜˜˜˜˜˜˜˜˜ ˜˜ ˜˜˜˜ ˜ (INTCON2=INTCON2[NOT_RBPU] = 0)
	movlw Period
	movwf Count		; ˜˜˜˜˜˜˜˜˜ ˜˜˜˜˜˜˜ (Count = Period)
	clrf paus		; (paus = b00000000)
	movlw 0xFF
	movwf PR2		; (PR2 = 255)
	bsf PIE1,TMR2IE		; ˜˜˜˜˜˜˜˜˜ ˜˜˜˜˜˜˜˜˜˜ ˜˜ ˜˜˜˜˜˜˜ 2 (PIE1[TMR2IE] = 1)
	movlw 0xC0
	movwf INTCON		; ˜˜˜˜˜˜˜˜˜ ˜˜˜˜˜˜˜˜˜˜ ˜˜˜˜˜˜˜˜˜ ˜ ˜˜˜˜˜˜˜˜˜˜˜˜ ˜˜˜˜˜˜˜˜˜˜ (INTCON = 0xC0 ˜˜˜ ˜˜ INTCON=192)
; ************************************************************************
; 	Start waiting loop
; ************************************************************************
Wentry	btfsc BUTTON		; ˜˜˜˜˜˜˜ ˜˜˜˜˜˜˜
	bra $-2
	rcall Pause
	btfsc BUTTON
	bra Wentry
	btfss BUTTON		; ˜˜˜˜˜˜˜ ˜˜˜˜˜˜˜˜˜˜
	bra $-2
	rcall Pause
	btfss BUTTON
	bra $-10
;
	bsf FIRE		; ˜˜˜˜˜˜ ˜˜˜˜˜˜˜˜
	bsf T2CON,TMR2ON	; ˜˜˜˜˜˜˜˜˜ ˜˜˜˜˜˜˜
	movlw 0xFA
	movwf Count
	clrf paus
	rcall Pause_10ms
	bra Wentry
; ************************************************************************
Pause	nop
	decfsz paus
	bra Pause
	decfsz Count
	bra Pause
	return
; ************************************************************************

Pause_10ms nop
	decfsz paus
	bra Pause
	decfsz Count
	bra Pause
	return
	
END
