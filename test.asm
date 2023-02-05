.386
.model flat, stdcall

includelib msvcrt.lib
extern exit: proc
extern printf: proc
extern scanf: proc
extern fopen: proc
extern fscanf: proc
extern fclose: proc
extern fgets: proc
extern strcmp: proc

public start


.data
n DWORD 0
x DB 0
sir DB 0
mode_read DB 'r',0
nume_fisier DB '123.txt',0
format_caracter DB '%c',0
format_sir DB '%s',0


.code

start:
	;deschid fisier
	push offset mode_read
	push offset nume_fisier
	call fopen
	add ESP,8
	
	mov EDI,EAX
	;citire fisier
	mov n,0
	loop_citire:
	;citesc caracter
	lea eax,x
	push eax
	push offset format_caracter
	push EDI
	call fscanf
	add ESP,12
	;verific daca sunt la final
	cmp eax,-1
	je gata_citire
	;adaug caracterul la sir
	mov edx,n
	mov eax,0
	mov al,x
	mov sir[edx],al
	add edx,1
	mov n,edx
	jmp loop_citire
	
	mov sir[edx],0
	;afisare text fisier
	gata_citire:
	push offset sir
	push offset format_sir
	call printf
	add ESP,8
	
	;terminarea programului
	push 0
	call exit
end start