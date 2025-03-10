; Authors: Steven Loaíciga y Javier Vega

section .data
defaultText db "----------------[ Intercambiar Mayusculas y Minusculas]----------------", 0xA, "Ingresa tu texto: "
dTLarge equ $ - defaultText

errorMsg db "Solo se admiten letras mayusculas, minusculas o espacios...", 0xA, "Terminando programa...", 0xA
errorLarge equ $ - errorMsg

section .bss
texto resb 100

section .text
global _start

_start:
	mov rdx, dTLarge			;Printea el menu principal
    mov rsi, defaultText
    mov rdi, 1
    mov rax, 1
    syscall

    mov rdi, 0  				;Lee la entrada del usuario
    mov rdx, 100
    mov rsi, texto
    mov rax, 0
    syscall

	mov rdi, texto				;Preparación del bucle
    xor rbx, rbx


convertidor: 
	movzx rax, byte [rdi + rbx] ;Carga en RAX el caracter actual en la iteracion

	cmp rax, 0  				;Compara caracter NULL (Final de la cadena)
	je print
	cmp rax, 10   				;Compara caracter de espacio (Lo omite)
	je continuador
	cmp rax, 32  				;Compara caracter de enter (Lo omite)
    je continuador
	cmp rax, 65  				;Compara los caracteres anteriores a la 'A'
	jl error
	cmp rax, 90    				;Compara los caracteres anteriores a 'Z'
	jle procesador_lower
	cmp rax, 97     			;Compara caracteres anteriores a 'a'
	jl error
	cmp rax, 123     			;Compara caracteres anteriores a 'z'
	jl procesador_higher
	cmp rax, 123  				;Compara caracteres posteriores a 'z'
	jbe error


procesador_lower:
	add byte [rdi + rbx], 32  	;Suma 32 en la tabla ascii, lo cual convierte en minúsculas las mayúsculas
	jmp continuador

procesador_higher: 
	sub byte [rdi + rbx], 32  	;Resta 32 en la tabla ascii, lo cual convierte en mayúsculas las minúsculas
	jmp continuador

continuador:
	inc rbx    					;Incrementa el iterador en 1
	jmp convertidor


print: 
	mov rdx, rbx   				;Printea el texto
    mov rsi, texto
    mov rdi, 1
    mov rax, 1
    syscall
    jmp exit


error:
    mov rdx, errorLarge		;Printea el mensaje de error
    mov rsi, errorMsg
    mov rdi, 1
    mov rax, 1
    syscall

    jmp exit 


exit: 
	mov eax, 60  			;Finaliza el programa
    xor ebx, ebx
    syscall