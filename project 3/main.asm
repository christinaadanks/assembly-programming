; programming project 3 
; 11/21/2020 Christinaa Danks
INCLUDE Irvine32.inc
.386
.model flat,stdcall
.stack 4096
ExitProcess proto,dwExitCode:dword

.data
	userInput BYTE "Please enter a sentence: ", 0				
	userInput2 BYTE "Please enter a character: ", 0
	userInput3 BYTE "Please enter the first sentence: ", 0
	userInput4 BYTE "Please enter the second sentence: ", 0
	newLine BYTE " ", 0dh, 0ah, 0
	buffer BYTE 30 DUP (?)
	buffer2 BYTE 30 DUP (?)
	totalString BYTE 60 DUP (?)

.code
main proc
;Exercise 1
	call StringLength
;Exercise 2
	call CharacterOccurrence
;Exercise 3
	call ConcatenateStrings

		invoke ExitProcess,0
main endp

;Exercise 1
StringLength proc
	mov edx, OFFSET userInput	;move offset of "please enter a sentence:" to EDX
	call WriteString			;display "please enter a sentence:" on console
	mov edx, OFFSET buffer		;point to the buffer
	mov ecx, SIZEOF buffer		;specify max characters
	call ReadString				;input the string (user input)
	call WriteDec				;display length of string entered in decimal

	mov edx, OFFSET newLine		;move offset of a new line to EDX
	call WriteString			;start a new line
	call WriteHex				;display length of string entered in hexadecimal
	call WriteString			;start a new line

	mov edx, OFFSET buffer		;point to the buffer
	call WriteString			;display the string entered by user on console
	mov edx, OFFSET newLine		;move offset of a new line to EDX
	call WriteString			;start a new line

	ret							;return to stack pushed from call function
StringLength endp

;Exercise 2
CharacterOccurrence proc
	mov edx, OFFSET userInput	;move offset of "please enter a sentence:" to EDX
	call WriteString			;display "please enter a sentence:" on console
	mov edx, OFFSET buffer		;point to the buffer
	mov ecx, SIZEOF buffer		;specify max characters
	call ReadString				;input the string (user input)
	mov ecx, eax				;store in register ECX the number of characters inputted for loop

	mov edx, OFFSET userInput2	;move offset of "please enter a character:" to EDX
	call WriteString			;display "please enter a character:" on console
	call ReadChar				;reads single character from keyboard and returns character in the AL register

	mov esi, OFFSET buffer		;point to the buffer (set esi as the start)
	mov dl, 0					;initialize DL (0 occurrences)

C1:	cmp al, [esi]				;compare esi (the string) to al (the character)
	jnz C2						;jump to C2 if al != [esi]
	inc dl						;add an occurrence if al = [esi]

C2:	inc esi						;increment esi to move to the next character in the string
	loop C1						;loop back to compare the characters

	mov eax, 0h					;reset EAX to move DL to AL
	mov al, dl					;move number of character occurrences to AL
	call WriteDec				;display number of character occurrences in decimal
	mov edx, OFFSET newLine		;move offset of a new line to EDX
	call WriteString			;start a new line
	ret							;return to stack pushed from call function
CharacterOccurrence endp

;Exercise 3
ConcatenateStrings proc
	mov edx, OFFSET userInput3	;move offset of "please enter the first sentence:" to EDX
	call WriteString			;display "please enter the first sentence:" on console
	mov edx, OFFSET buffer		;point to the buffer
	mov ecx, SIZEOF buffer		;specify max characters
	call ReadString				;input the string (user input)
	mov ebx, eax				;store first sentence in EBX

	mov edx, OFFSET userInput4	;move offset of "please enter the second sentence:" to EDX
	call WriteString			;display "please enter the second sentence:" on console
	mov edx, OFFSET buffer2		;point to the buffer (second buffer)
	mov ecx, SIZEOF buffer2		;specify max characters
	call ReadString				;input the string (user input)

	cld							;set D to 0 to move forward
	mov esi, OFFSET buffer		;move offset of buffer to ESI (source - first string)
	mov edi, OFFSET totalString	;move offset of totalString to EDI (destination - the two strings combined)
	mov ecx, ebx				;store in ECX the number of characters inputted for first string for the loop
	rep movsb					;copy array from esi to edi

	mov esi, OFFSET buffer2		;move offset of buffer2 to ESI (source - second string)
	mov ecx, eax				;store in ECX the number of characters inputted for second string for the loop
	rep movsb					;copy array from esi to edi

	mov edx, OFFSET totalString	;move offset of the concatenated strings to EDX
	call WriteString			;display the concatenated string on console
	mov edx, OFFSET newLine		;move offset of a new line to EDX
	call WriteString			;start a new line
	add eax, ebx
	call WriteDec				;display length of concatenated string in decimal
	call WriteString			;start a new line
	call WriteHex				;display length of concatenated string in hexadecimal
	ret							;return to stack pushed from call instruction
ConcatenateStrings endp

end main