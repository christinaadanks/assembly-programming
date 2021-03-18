; programming assignment 4
; 12/2/2020 Christinaa Danks
INCLUDE Irvine32.inc
.386
.model flat,stdcall
.stack 4096
ExitProcess proto,dwExitCode:dword

.data
;prompts
	userInput BYTE "Please enter a sentence: ", 0				
	userInput2 BYTE "Please enter the number of characters to delete (in hexadecimal): ", 0
	userInput3 BYTE "Please enter the position from where to start deleting (in hexadecimal): ", 0
	userInput4 BYTE "Please enter a sentence S1 to insert: ", 0
	userInput5 BYTE "Please enter a sentence S2 in which to insert: ", 0
	userInput6 BYTE "Please enter the position P where to insert: ", 0
	newLine BYTE " ", 0dh, 0ah, 0
;buffers
	buffer BYTE 30 DUP (?)
	buffer2 BYTE 30 DUP (?)
	totalString BYTE 60 DUP (?)

.code
main proc
;Exercise 1
	call DeleteChars
;Exercise 2
	call InsertString
		invoke ExitProcess,0
main endp

;Exercise 1
DeleteChars proc
;save parameter and intermediary registers
	PUSH edx
	PUSH ecx
	PUSH ebx
	PUSH eax
	PUSH edi
	PUSH esi

;prompt user & get a sentence
	mov edx, OFFSET userInput	;move offset of userInput to EDX
	call WriteString			;display "please enter a sentence:" on console
	mov edx, OFFSET buffer		;point to the buffer
	mov ecx, SIZEOF buffer		;specify max characters (30)
	call ReadString				;input the string (user input) - # of chars stored in EAX

;prompt user & get number of characters to delete
	mov edx, OFFSET userInput2	;move offset of userInput2 to EDX
	call WriteString			;display "please enter the number of characters to delete (in hexadecimal):" on console
	call ReadHex				;reads 32 bit hexadecimal integer and stores binary value in EAX
	mov ebx, eax				;store in register EBX the number of characters to delete

;prompt user & get position from where to start deleting
	mov edx, OFFSET userInput3	;move offset of userInput3 to EDX
	call WriteString			;display "Please enter the position from where to start deleting (in hexadecimal):" on console
	call ReadHex				;reads 32 bit hexadecimal integer and stores binary value in EAX
	dec eax						;offset starts at 0, but length starts at 1, need to decrement for offset
	add ebx, eax				;combine starting position and # of characters to remove

;create a new sentence
	cld							;set flag D = 0 so MOVSB moves forward
	mov edi, OFFSET buffer		;point to the buffer
	add edi, eax				;move destination index to starting position
	mov esi, OFFSET buffer		;point to the buffer
	add esi, ebx				;move source index to starting position and deleted characters
	mov ecx, SIZEOF buffer		;specify max characters (30)
	sub ecx, ebx				;set ECX to length of string - # of times MOVSB will repeat
	rep movsb					;copy content of ESI to EDI

;display the new sentence
	mov edx, OFFSET buffer		;point to the buffer
	call WriteString			;display new string on console
	mov edx, OFFSET newLine		;move offset of a new line to EDX
	call WriteString			;start a new line
	
;restore parameter and intermediary registers
	POP esi
	POP edi
	POP eax
	POP ebx
	POP ecx
	POP edx

	ret							;return to stack pushed from call function
DeleteChars endp

;Exercise 2
InsertString proc
;save parameter and intermediary registers
	PUSH edx
	PUSH ecx
	PUSH ebx
	PUSH eax
	PUSH esi
	PUSH edi

;prompt user & get sentence S1
	mov edx, OFFSET userInput4	;move offset of userInput4 to EDX
	call WriteString			;display "Please enter a sentence S1 to insert:" on console
	mov edx, OFFSET buffer		;point to the buffer
	mov ecx, SIZEOF buffer		;specify max characters (30)
	call ReadString				;input the string (user input) - # of chars stored in EAX
	mov ebx, eax				;store # of characters entered in EBX

;prompt user & get sentence S2
	mov edx, OFFSET userInput5	;move offset of userInput5 to EDX
	call WriteString			;display "Please enter a sentence S2 in which to insert:"
	mov edx, OFFSET buffer2		;point to the buffer
	mov ecx, SIZEOF buffer2		;specify max characters (30)
	call ReadString				;input the string (user input) - # of chars stored in EAX
	PUSH eax					;save # of chars into stack

;prompt user & get position for insertion
	mov edx, OFFSET userInput6	;move offset of userInput6 to EDX
	call WriteString			;display "Please enter the position P where to insert:" on console
	call ReadHex				;reads 32 bit hexadecimal integer and stores binary value in EAX
	dec eax						;offset starts at 0, but length starts at 1, need to decrement for offset

;copy first part of S2 (before insertion of S1) to the new string
	cld							;set flag D = 0 so movsb moves forward
	mov esi, OFFSET buffer2		;move offset of buffer2 to ESI (source - S2)
	mov edi, OFFSET totalString	;move offset of combined string to EDI (destination - new string)
	mov ecx, eax				;set ECX to position of insertion - # of times MOVSB will repeat
	rep movsb					;copy content of ESI (S2) to EDI (new string)

;copy S1 to the new string (at point of insertion)
	mov esi, OFFSET buffer		;move offset of buffer to ESI (source - S1)
	mov ecx, ebx				;set ECX to length of S1 - # of times MOVSB will repeat
	rep movsb					;copy content of ESI (S1) to EDI (new string)

;copy the rest of S2 (after insertion of S1) to the new string
	mov esi, OFFSET buffer2		;move offset of buffer2 ESI (source - rest of S2)
	add esi, eax				;move to offset of S2 that was not completed
	POP ecx						;take length of S2 from stack, increment ESP
	sub ecx, eax				;set ECX to the # of characters to move - # of times MOVSB will repeat
	rep movsb					;copy remaining content of ESI (S2) to EDI (new string)

;display the new sentence
	mov edx, OFFSET totalString	;move offset of totalString to EDX
	call WriteString			;display new string on console
	mov edx, OFFSET newLine		;move offset of a new line to EDX
	call WriteString			;start a new line

;restore parameter and intermediary registers
	POP edi
	POP esi
	POP eax
	POP ebx
	POP ecx
	POP edx

	ret							;return to stack pushed from call function
InsertString endp

end main