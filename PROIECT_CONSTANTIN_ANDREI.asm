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
extern tolower: proc
extern strstr: proc
extern strlen: proc

public start


.data


format_sir DB "%s",0
format_caracter DB "%c",0

mode_read DB "r",0
mode_write DB "w",0



op1 DB "findc",0
op2 DB "find",0
op3 DB "replace",0
op4 DB "toUpper",0
op5 DB "toLower",0
op6 DB "toSentence",0
op7 DB "exit",0
op8 DB "list",0
operatie_model DB 100 DUP(0)

format_nr DB "%d ",0
mesaj_op1 DB "aparitii la index: ",0
mesaj_op3 DB "aparitii schimbate",0

mesaj_init DB "Introduceti calea spre fisier:",0
introduce_op DB "Introduceti operatia:",0

DA DB "DA",0
punct DB ".",0
spatiu DB " ",0
rand_nou DB 10,0

n DWORD 0
diff DWORD 0
lung_sir_cautat DWORD 0
lung_sir_schimb DWORD 0
nume_fisier DB 100 DUP(0)
operatie DB 100 DUP(0)
x DB "x",0
caracter_cautat DB "x",0
primul_caracter DB " ",0
nr_caractere DWORD 0
poz_caractere DWORD 100000 DUP(0)
nr_siruri DWORD 0
poz_siruri DWORD 100000 DUP(0)
sir DB 1000000 DUP(0)
sir_cautat DB 100 DUP(0)
sir_schimb DB 100 DUP(0)
.code


start:
	;afis mesaj initial
	push offset mesaj_init
	push offset format_sir
	call printf
	add ESP,8
	
	lea esi, nume_fisier
	;citesc nume fisier
	push offset nume_fisier
	push offset format_sir
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
	
	;citire fisier
	mov n,0
	mov EBX,0
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
	add EBX,1
	jmp loop_citire
	
	mov n,EBX
	mov sir[EBX],0
	;afisare text fisier
	gata_citire:
	; push offset sir
	; push offset format_sir
	; call printf
	; add ESP,8
	; ;rand nou
	; push 10
	; push offset format_caracter
	; call printf
	; add ESP,8
	;mesaj introduce operatie
	push offset introduce_op
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
	
	;verificare toUpper(op4)
	push offset operatie
	push offset op4
	call strcmp
	add ESP,8
	test eax,eax
	jnz verif_op5
	push ESI
	mov ecx,n
	loop_op4:
	sub ecx,1
	mov edx,0
	mov esi,ecx
	mov dl,sir[ecX]
	push edx
	call toupper
	add ESP,4
	mov ecx,esi
	mov sir[ecX],al
	cmp ECX,0
	jne loop_op4
	
	verif_op5:
	;verificare toLower(op5)
	push offset operatie
	push offset op5
	call strcmp
	add ESP,8
	test eax,eax
	jnz verif_op1
	push ESI
	mov ecx,n
	loop_op5:
	sub ecx,1
	mov edx,0
	mov esi,ecx
	mov dl,sir[ecX]
	push edx
	call tolower
	add ESP,4
	mov ecx,esi
	mov sir[ecx],al
	cmp ECX,0
	jne loop_op5
	
	;pop ESI
	verif_op1:
	push offset operatie
	push offset op1
	call strcmp
	add ESP,8
	test eax,eax
	jnz verif_op2
	;citesc caracter
	push offset x
	push offset format_sir
	call scanf
	add ESP,8
	;loop cautare si adaugare pozitii
	mov edx,0
	mov ecx,0
	mov ebx,0
	mov nr_caractere,0
	loop_op1:
	mov dl,sir[ecx]
	mov caracter_cautat[0],dl
	push ECX
	push offset caracter_cautat
	push offset x
	call strcmp
	add ESP,8
	test eax,eax
	pop ecx
	jnz continua
	mov EDX,nr_caractere
	mov poz_caractere[EDX*8],ECX
	add nr_caractere,1
	
	continua:
	add ecx,1
	cmp ecx,n
	jne loop_op1
	;afisare nr de aparitii
	mov edx,nr_caractere
	push edx
	push offset format_nr
	call printf
	add ESP,8
	
	push offset mesaj_op1
	push offset format_sir
	call printf
	add ESP,8
	
	mov ECX,0
	
	cmp nr_caractere,0
	je skip_afis
	
	loop2_op1:
	mov EDX,poz_caractere[ECX*8]
	push ECX
	push EDX
	push offset format_nr
	call printf
	add ESP,8
	pop ECX
	add ECX,1
	cmp ECX,nr_caractere
	jb loop2_op1
	
	skip_afis:
	push 10
	push offset format_caracter
	call printf
	add ESP,8
	
	verif_op2:
	push offset operatie
	push offset op2
	call strcmp
	add ESP,8
	test eax,eax
	jnz verif_op6
	
	push offset sir_cautat
	push offset format_sir
	call scanf
	add ESP,8
	
	push offset sir_cautat
	call strlen
	add ESP,4
	mov lung_sir_cautat,EAX
	
	mov nr_siruri,0
	mov ECX,0
	loop_op2:
	push ECX
	add ECX,lung_sir_cautat
	cmp ECX,n
	jg sari_peste
	pop ecx
	push ecx
	mov EBX,0
	verific_sir:
	push EBX
	push ECX
	
	pop ECX
	pop EBX
	push EBX
	push ECX
	
	mov EDX,0
	mov dl,sir[ECX]
	mov caracter_cautat[0],dl
	mov EDX,0
	mov dl,sir_cautat[EBX]
	mov primul_caracter[0],dl
	
	push offset caracter_cautat
	push offset primul_caracter
	call strcmp
	add ESP,8
	test eax,eax
	
	pop ECX
	pop EBX
	jnz sari_peste
	add ECX,1
	; cmp n,ECX
	; je sari_peste
	
	add EBX,1
	cmp lung_sir_cautat,EBX
	jne verific_sir
	;adaug pozitia
	pop ECX
	push ECX
	mov EDX,nr_siruri
	mov poz_siruri[EDX*8],ECX
	add nr_siruri,1
	
	
	sari_peste:
	pop ECX
	add ECX,1
	cmp ECX,n
	jne loop_op2
	
	mov edx,nr_siruri
	push edx
	push offset format_nr
	call printf
	add ESP,8
	
	push offset mesaj_op1
	push offset format_sir
	call printf
	add ESP,8
	
	mov ECX,0
	
	cmp nr_siruri,0
	je skip_afis_poz_siruri
	
	afis_poz_siruri:
	mov EDX,poz_siruri[ECX*8]
	push ECX
	push EDX
	push offset format_nr
	call printf
	add ESP,8
	pop ECX
	add ECX,1
	cmp ECX,nr_siruri
	jb afis_poz_siruri
	
	skip_afis_poz_siruri:
	push 10
	push offset format_caracter
	call printf
	add ESP,8
	
	
	
	verif_op6:
	push offset operatie
	push offset op6
	call strcmp
	add ESP,8
	test EAX,EAX
	jnz verif_op3
	
	mov EDX,0
	mov ECX,0
	mov ESI,1
	loop_op6:
	
	push ECX
	mov EDX,0
	mov dl,sir[ECX]
	mov caracter_cautat[0],dl
	
	push offset caracter_cautat
	push offset punct
	call strcmp
	add ESP,8
	
	test EAX,EAX
	jnz diferit_de_punct
	mov ESI,1
	jmp ok_punct
	diferit_de_punct:
	
	;verific daca e spatiu dupa punct
	pop ECX
	push ECX
	
	mov EDX,0
	mov dl,sir[ECX]
	mov caracter_cautat[0],dl
	
	push offset caracter_cautat
	push offset spatiu
	call strcmp
	add ESP,8
	
	test EAX,EAX
	jz ok_punct
	;verific daca e rand_nou dupa punct
	pop ECX
	push ECX
	
	mov EDX,0
	mov dl,sir[ECX]
	mov caracter_cautat[0],dl
	
	push offset caracter_cautat
	push offset rand_nou
	call strcmp
	add ESP,8
	
	test EAX,EAX
	jz ok_punct
	
	cmp ESI,1
	jne make_lo
	
	mov edx,0
	pop ECX
	push ECX
	mov dl,sir[ECX]
	push edx
	call toupper
	add ESP,4
	
	jmp made_h
	make_lo:
	mov edx,0
	pop ECX
	push ECX
	mov dl,sir[ECX]
	push edx
	call tolower
	add ESP,4
	
	made_h:
	pop ECX
	mov sir[ECX],al
	push ECX
	mov ESI,0
	ok_punct:
	pop ECX
	add ECX,1
	cmp ECX,n
	jne loop_op6
	
	verif_op3:
	push offset operatie
	push offset op3
	call strcmp
	add ESP,8
	test EAX,EAX
	jnz verif_op8
	
	push offset sir_cautat
	push offset format_sir
	call scanf
	add ESP,8
	
	push offset sir_schimb
	push offset format_sir
	call scanf
	add ESP,8
	;
	;
	;
	push offset sir_cautat
	call strlen
	add ESP,4
	mov lung_sir_cautat,EAX
	
	push offset sir_schimb
	call strlen
	add ESP,4
	mov lung_sir_schimb,EAX
	
	
	mov nr_siruri,0
	mov ECX,0
	loop_op3:
	push ECX
	add ECX,lung_sir_cautat
	cmp ECX,n
	jg sari_peste_cautare
	pop ecx
	push ecx
	mov EBX,0
	verific_sir_cautat:
	push EBX
	push ECX
	
	pop ECX
	pop EBX
	push EBX
	push ECX
	
	mov EDX,0
	mov dl,sir[ECX]
	mov caracter_cautat[0],dl
	mov EDX,0
	mov dl,sir_cautat[EBX]
	mov primul_caracter[0],dl
	
	push offset caracter_cautat
	push offset primul_caracter
	call strcmp
	add ESP,8
	test eax,eax
	
	pop ECX
	pop EBX
	jnz sari_peste_cautare
	add ECX,1
	
	add EBX,1
	cmp lung_sir_cautat,EBX
	jne verific_sir_cautat
	;adaug pozitia
	pop ECX
	push ECX
	mov EDX,nr_siruri
	mov poz_siruri[EDX*8],ECX
	add nr_siruri,1
	
	
	sari_peste_cautare:
	pop ECX
	add ECX,1
	cmp ECX,n
	jne loop_op3
	
	mov edx,nr_siruri
	push edx
	push offset format_nr
	call printf
	add ESP,8
	
	push offset mesaj_op3
	push offset format_sir
	call printf
	add ESP,8
	
	push 10
	push offset format_caracter
	call printf
	add ESP,8
	cmp nr_siruri,0
	je inchid
	
	mov ECX,0
	modific_sir:
	push ECX
	mov EDX,poz_siruri[ECX*8]
	push EDX
	
	mov EBX,lung_sir_schimb
	
	cmp lung_sir_cautat,EBX
	jg mai_mare
	jb mai_mic
	;egal
	pop EDX
	mov ECX,0
	loop_egal:
	;sir[EDX]=sir_schimb[ECX]
	mov EBX,0
	mov bl,sir_schimb[ECX]
	mov sir[EDX],bl
	add ECX,1
	add EDX,1
	cmp ECX,lung_sir_cautat
	jne loop_egal
	
	jmp urmatorul
	
	mai_mare:
	pop EDX
	mov ECX,EDX
	add ECX,lung_sir_schimb
	mov EAX,lung_sir_cautat
	sub EAX,lung_sir_schimb
	mov diff,EAX
	loop_trag_sir_peste:
	;sir[ECX]=sir[ECX+diff]
	mov EBX,ECX
	mov EAX,0
	add ECX,diff
	mov al,sir[ECX]
	mov sir[EBX],al
	mov ECX,EBX
	add ECX,1
	cmp ECX,n
	jne loop_trag_sir_peste
	
	mov ECX,lung_sir_cautat
	sub ECX,lung_sir_schimb
	sub n,ECX
	mov EBX,ECX
	
	pop ECX
	push ECX
	add ECX,1
	modif_poz_nr_siruri:
	mov EAX,poz_siruri[ECX*8]
	sub EAX,EBX
	mov poz_siruri[ECX*8],EAX
	add ECX,1
	cmp ECX,nr_siruri
	jb modif_poz_nr_siruri
	
	
	mov ECX,EDX
	mov EBX,0
	modif_sir:
	; ;sir[ECX]=sir_schimb[EBX]
	mov EAX,0
	mov al,sir_schimb[EBX]
	mov sir[ECX],al
	add ECX,1
	add EBX,1
	cmp EBX,lung_sir_schimb
	jne modif_sir
	
	jmp urmatorul
	mai_mic:
	
	pop EDX
	mov ECX,EDX
	add ECX,lung_sir_schimb
	mov EAX,n
	add EAX,lung_sir_schimb
	sub EAX,lung_sir_cautat
	mov n,EAX
	mov ESI,EDX
	add ESI,lung_sir_schimb
	sub ESI,lung_sir_cautat
	mov ECX,n
	mov EAX,lung_sir_schimb
	sub EAX,lung_sir_cautat
	mov diff,EAX
	loop_trag_sir_dreapta:
	;sir[ECX]=sir[ECX-diff]
	mov EBX,ECX
	mov EAX,0
	sub ECX,diff
	mov al,sir[ECX]
	mov sir[EBX],al
	mov ECX,EBX
	sub ECX,1
	cmp ECX,ESI
	jne loop_trag_sir_dreapta
	
	pop ECX
	push ECX
	add ECX,1
	modif_poz_nr_siruri_mai_mic:
	mov EAX,poz_siruri[ECX*8]
	add EAX,diff
	mov poz_siruri[ECX*8],EAX
	add ECX,1
	cmp ECX,nr_siruri
	jb modif_poz_nr_siruri_mai_mic
	
	
	mov ECX,EDX
	mov EBX,0
	modif_sir_mai_mic:
	;sir[ECX]=sir_schimb[EBX]
	mov EAX,0
	mov al,sir_schimb[EBX]
	mov sir[ECX],al
	add ECX,1
	add EBX,1
	cmp EBX,lung_sir_schimb
	jne modif_sir_mai_mic
	
	urmatorul:
	pop ECX
	add ECX,1
	cmp ECX,nr_siruri
	jb modific_sir
	;
	;
	;
	verif_op8:
	push offset operatie
	push offset op8
	call strcmp
	add ESP,8
	test EAX,EAX
	jnz inchid
	push offset sir
	push offset format_sir
	call printf
	add ESP,8
	;rand nou
	push 10
	push offset format_caracter
	call printf
	add ESP,8
	
	inchid:
	;inchid fisier
	push EDI
	call fclose
	add ESP,4
	;deschid fisier cu scriere
	push offset mode_write
	push offset nume_fisier
	call fopen
	add ESP,8
	
	mov EDI,EAX
	
	;scriu in fisier
	push offset sir
	push offset format_sir
	push EDI
	call fprintf
	add ESP,12
	;inchid fisier
	push EDI
	call fclose
	add ESP,4
	;deschid fisier cu citire
	push offset mode_read
	push offset nume_fisier
	call fopen
	add ESP,8
	mov ESI,EAX
	
	
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
