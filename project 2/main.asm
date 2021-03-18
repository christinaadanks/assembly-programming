; template to start a new project 
; 11/5/2020 Christinaa Danks
INCLUDE Irvine32.inc
.386
.model flat,stdcall
.stack 4096
ExitProcess proto,dwExitCode:dword

.data
	myString2 BYTE "h",0dh,0ah
	newline BYTE " ",0dh,0ah
	
.code
main proc
	; Exercise 1
	mov	al, 04h		;set al to 04h
	mov dl, 30h		;set dl to 30h
	add dl, al		;dl store ascii code 34h
	mov al, dl		;set al to 34h
	call WriteChar	;display  4 
	mov edx,OFFSET newline	;skip line
	call WriteString

	; Exercise 2
	mov al, 94h		;set al to 94h
	mov dh, al		;set dl to 94h
	AND dh, 0F0h	;get most significant nibble
	SHR dh, 4		;shift to be least significant nibble
	add dh, 30h		;dh store 39h
	mov dl, al		;set dl to 94h
	AND dl, 0Fh		;get least significant nibble
	add dl, 30h		;dl store 34h
	mov al, dh		;set al to 09
	call WriteChar	;display 9
	mov al, dl		;set al to 34h
	call WriteChar	;display 4
	mov edx, OFFSET myString2	;display h and newline
	call WriteString
	
	; Exercise 3
	call ReadChar	;get input from user
	mov dl, al		;dl store ASCII code of input
	sub dl, 30h		;convert dl to value of digit 

	; Exercise 4
	call ReadChar	;get input from user, MSN
	mov dl, al		;dl store ASCII code of input
	call ReadChar	;get input from user, LSN
	sub dl, 30h		;convert dl to value of digit
	sub al, 30h		;convert al to value of digit
	shl dl, 4		;shift left to make it MSN	
	add al, dl		;puts digit value into al

		invoke ExitProcess,3
main endp
end main