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
extern toupper: proc
extern fprintf: proc

public start


.data



mode_read DB "r",0
nume_fisier DB 0
format_nume_fisier DB "%s",0
mode_write DB "w",0


op1 DB "findc",0
op2 DB "find",0
op3 DB "replace",0
op4 DB "toUpper",0
op5 DB "toLower",0
op6 DB "toSentence",0
op7 DB "exit",0


mesaj_init DB "Introduceti calea spre fisier:",0
mesaj_init2 DB "Introduceti operatia:",0
format_mesaj_init DB "%s",0
format_sir DB "%s",0
n DWORD 0
x DB 0
format_caracter DB "%c",0
operatie DB "1234567890",0
sir DB 0
.code


start:
	;afis mesaj initial
	push offset mesaj_init
	push offset format_mesaj_init
	call printf
	add ESP,8
	
	lea esi, nume_fisier
	;citesc nume fisier
	push offset nume_fisier
	push offset format_mesaj_init
	call scanf
	add ESP,8
	
	;deschid fisier
	push offset mode_read
	push offset nume_fisier
	call fopen
	add ESP,8
	
	mov EDI,EAX
	
	;rand nou
	;push 10
	;push offset format_caracter
	;call printf
	;add ESP,8
	
	;loop operatii
	loop_op:
	
	;mesaj introduce operatie
	push offset mesaj_init2
	push offset format_sir
	call printf
	add ESP,8
	
	;citire operatie
	push offset operatie
	push offset format_sir
	call scanf
	add ESP,8
	
	;verificare exit
	push offset operatie
	push offset op7
	call strcmp
	add ESP,8
	test eax,eax
	jz close_program
	
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
	;rand nou
	push 10
	push offset format_caracter
	call printf
	add ESP,8
	
	;verificare toUpper(op4)
	push offset operatie
	push offset op4
	call strcmp
	add ESP,8
	test eax,eax
	jnz pas_urmator
	push ESI
	mov ecx,n
	loop_op4:
	sub ecx,1
	mov edx,0
	mov esi,ecx
	mov dl,sir[ecx]
	push edx
	call toupper
	add ESP,4
	mov ecx,esi
	mov sir[ecx],al
	cmp ECX,0
	jne loop_op4
	
	pop ESI
	
	push EDI
	call fclose
	add ESP,4
	
	push offset mode_write
	push ESI
	call fopen
	add ESP,8
	
	mov EDI,EAX
	
	push offset sir
	push offset format_sir
	push EDI
	call fprintf
	add ESP,12
	
	pas_urmator:
	
	jmp loop_op
	
	;inchid fisier
	close_program:
	push EDI
	call fclose
	add ESP,4
	;terminarea programului
	push 0
	call exit
end start
