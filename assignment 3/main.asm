; programming assignment 3 
; 11/13/2020 Christinaa Danks
INCLUDE Irvine32.inc
.386
.model flat,stdcall
.stack 4096
ExitProcess proto,dwExitCode:dword

.data
	
.code
main proc
;Exercise 6
	call ReadHexByte		;read user input - stored byte in register al
	call SumFirstN		;sum of the first n integers and store in register dx

	mov cx, dx		;move dx to cx
	mov al, ch		;move ch to al (first 2 digits)
	call WriteHexByte		;print first 2 digits (ch)
	mov al, cl		;move cl to al (last 2 digits)
	call WriteHexByte		;print last 2 digits (cl)

		invoke ExitProcess,0
main endp
;Exercise 1
DigitValue2ASCII proc
	mov dl, al		;move al to dl
	cmp dl, 09h		;compare dl to 9
	jbe C1		;jump to C1 if dl is less than or equal to 9
	ja C2		;jump to C2 if dl is greater than 9 (A-F)
C1:
	add dl, 30h		;convert dl value to ASCII code (30-39)
	jmp C3		;jump to C3 to skip C2
C2:
	sub dl, 0Ah		;convert dl from A-F to 0-5
	add dl, 41h		;convert dl value to ASCII code (41-46)
C3:
	ret		;return to stack pushed from call function
DigitValue2ASCII endp

;Exercise 2
WriteHexByte proc
	mov dh, al		;move al to dh
	AND al, 0F0h	;get most significant nibble
	SHR al, 4		;shift to right, making LSN
	call DigitValue2ASCII	;convert value to corresponding ASCII code (MSN)
	mov al, dl		;move dl ASCII code to al
	call WriteChar	;print ASCII value of al
	mov al, dh		;move dh to al (shifted, making LSN)
	AND al, 0Fh		;get least significant nibble
	call DigitValue2ASCII	;convert value to corresponding ASCII code (LSN)
	mov al, dl		;move dl ASCII code to al
	call WriteChar	;print ASCII value of al

	cmp dh, ch		;compare dh to ch, if the same do not print h
	JZ H2		;jump to H2 to skip H1 (do not print h)
H1:
	mov al, 68h		;68h is ASCII code for h
	call WriteChar
	mov al, 0Ah		;0Ah is ASCII code for line feed
	call WriteChar
	mov al, 0Dh		;0Dh is ASCII code for carriage return
	call WriteChar
H2:
	ret		;return to stack pushed from call function

WriteHexByte endp

;Exercise 3
ASCII2DigitValue proc
	mov dl, al		;move al to dl
	cmp dl, 39h		;compare dl to 39h
	jbe C1		;jump to C1 if dl is less than or equal to 39h
	ja C2		;jump to C2 if dl is greater than 39h (A-F)
C1:
	sub dl, 30h		;convert dl from ASCII code to value (0-9)
	jmp C3		;jump to C3 to skip C2
C2:
	sub dl, 41h		;convert dl from from ASCII code to value (0-5)
	add dl, 0Ah		;convert dl from 0-5 to A-F
C3:
	ret		;return to stack pushed from call instruction

ASCII2DigitValue endp

;Exercise 4
ReadHexByte proc
	call ReadChar	;get input from user, MSN
	call ASCII2DigitValue		;convert MSN from ASCII code to value and store in DL
	call ReadChar	;get input from user, LSN
	mov dh, dl		;move dl to dh (value)
	SHL dh, 4		;shift value 4 spaces to make it MSN
	call ASCII2DigitValue		;convert LSN from ASCII code to value and store in DL
	mov al, dl		;move dl to al (value)
	add al, dh		;creates value of byte and stores it in al
	ret		;return to stack pushed from call instruction

ReadHexByte endp

;Exercise 5
SumFirstN proc
	mov ecx, 00000000h		;set ECX to 0
	mov cl, al		;move al to cl
	mov dx, 0h		;set dx to start at 0
	mov bx, 1h		;bx will be added to each loop, needs to start at 1
Sum:
	add dx, bx		;EAX,ECX, and EDX are used, must use EBX
	INC bx		;increment bx
	LOOP sum		;loop sum until ECX is 0
	ret		;return to stack pushed from call instruction

SumFirstN endp

end main