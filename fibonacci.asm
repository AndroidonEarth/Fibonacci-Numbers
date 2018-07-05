TITLE Fibonacci Numbers     (fibonacci.asm)

; Author: Andrew Swaim
; Date: 1/28/2018
; Description: Displays the program title and author; Gets the user's name and greets the user;
;	Prompts the user to enter the number of Fibonacci terms to be displayed; Advises the user to
;	enter an integer in the range [1 .. 46]; Gets and validates the user input (n); Calculates and
;	displays 5 terms per line with at least 5 spaces between terms; Displays a parting message that
;	includes the user's name, and terminates the program.

INCLUDE Irvine32.inc

UPPER_LIMIT = 46

.data
program			BYTE	"Fibonacci Numbers",0
author			BYTE	"Programmed by Andrew Swaim",0
prompt1			BYTE	"What's your name? ",0
userName		BYTE	21 DUP (0)
greeting		BYTE	"Hello, ",0
rules1			BYTE	"Enter the number of Fibonacci terms to be displayed",0
rules2			BYTE	"Give the number as an integer in the range [1 .. 46].",0
prompt2			BYTE	"How many Fibonacci terms do you want? ",0
error			BYTE	"Out of range. Enter a number in [1 .. 46].",0
goodbye1		BYTE	"Results certified by Andrew Swaim.",0
goodbye2		BYTE	"Goodbye, ",0
numOfTerms		DWORD	?
nextTerm		DWORD	1	;To hold the next term in the sequence, starting with 1
newLineAccum	DWORD	0	;To determine if 5 terms have printed to move to next line
tabAccum		DWORD	0	;To determine if more than 35 terms have been printed for alignment
asciiTab		BYTE	9	;Tab character ASCII = '9'

.code
main PROC
;Display program name
	mov		edx,OFFSET program
	call	WriteString
	call	Crlf
;Display author name
	mov		edx,OFFSET author
	call	WriteString
	call	Crlf
	call	Crlf
;Prompt for user's name
	mov		edx,OFFSET prompt1
	call	WriteString
	mov		edx,OFFSET userName
	mov		ecx,SIZEOF userName
	call	ReadString
;Display greeting to user
	mov		edx,OFFSET greeting
	call	WriteString
	mov		edx,OFFSET userName
	call	WriteString
	call	Crlf

;--------------------------------------

;User instructions
	mov		edx,OFFSET rules1
	call	WriteString
	call	Crlf
	mov		edx,OFFSET rules2
	call	WriteString
	call	Crlf
	call	Crlf

;--------------------------------------

getInput:
;Prompt for and get number of terms
	mov		edx,OFFSET prompt2
	call	WriteString
	call	ReadInt
;Validate number of terms is >= 1
	mov		ebx,1
	cmp		eax,ebx
	jb		errorMessage
;Validate number of terms is <= 46 (upper limit)
	mov		ebx,UPPER_LIMIT
	cmp		eax,ebx
	ja		errorMessage
;If validation passed store number of terms in loop counter
	mov		ecx,eax
	call	Crlf
	jmp		inputOK

errorMessage:
;Display error message and prompt for user input again
	mov		edx,OFFSET error
	call	WriteString
	call	Crlf
	jmp		getInput

;--------------------------------------

inputOK:
;Initialize first term
	mov		ebx,1

calcFibNums:
;Move previous term and print it
	mov		eax,ebx
	call	WriteDec
;Get next term and add to prev term
	mov		ebx,nextTerm
	add		eax,ebx
;Store new term
	mov		nextTerm,eax
;Increment accumulators
	inc		newLineAccum
	inc		tabAccum
;Check if accumulator is 5, and if so add line break
	cmp		newLineAccum,5
	je		lineBreak
;If more than 35 terms printed, print only one tab
	cmp		tabAccum,35
	jae		oneTab
;For less than 35 terms, print two tabs
	mov		al,asciiTab
	call	WriteChar
	call	WriteChar

continue:
;Loop again or jump to goodbye message if loop counter is 0
	loop	calcFibNums
	jmp		goodbye

lineBreak:
;Print line break and reset new line accumulator
	call	Crlf
	mov		newLineAccum,0
	jmp		continue

oneTab:
;Print single alignment tab for more than 35 terms
	mov		al,asciiTab
	call	WriteChar
	jmp		continue

;--------------------------------------

goodbye:
;Say goodbye
	call	Crlf
	call	Crlf
	mov		edx,OFFSET goodbye1
	call	WriteString
	call	Crlf
	mov		edx,OFFSET goodbye2
	call	WriteString
	mov		edx,OFFSET userName
	call	WriteString
	call	Crlf
	call	Crlf

	exit	; exit to operating system
main ENDP

END main
