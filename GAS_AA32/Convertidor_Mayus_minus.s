@Authors: Steven Loaíciga y Javier Vega

.data
	defaultText: .asciz "--------------[ Intercambiar Mayusculas y Minusculas ]--------------\nTu mensaje: "
	dTLarge= .-defaultText

	errorMsg: .asciz "Solo se admiten mayusculas, minusculas y espacios...\nTerminando programa..."
	errorLarge= .-errorMsg

.bss
	.lcomm texto, 100

.text
.global _start
_start:

	mov r0, #1  			@Imprime el menú principal
	ldr r1, =defaultText
	ldr r2, =dTLarge
	mov r7, #4
	swi 0

	mov r0, #0   			@Lee la entrada del usuario
	ldr r1, =texto
	mov r2, #100
	mov r7, #3
	swi 0

	ldr r1, =texto  		@Prepara para el bucle
	mov r3, #0

convertidor: 

	ldrb r0, [r1, r3]

	cmp r0, #0     			@Comprueba si es el final de una cadena
	beq print

	cmp r0, #10    			@Comprueba si es un salto de línea
	beq continuador

	cmp r0, #32   			@Comprueba si es un espacio
	beq continuador 

	cmp r0, #65   			@Comprueba si el valor ascii es menor a '65'
	blt error 			@En este caso el valor '65' pertenece a 'A'

	cmp r0, #90   			@Comprueba si el valor ascii es menor o igual a '90'
	ble procesador_lower         	@En este caso el valor '90' pertenece a 'Z'

	cmp r0, #97   			@Comprueba si el valor ascii es menor a '97'
	blt error  			@En este caso el valor '97' pertenece a 'a'

	cmp r0, #122  			@Comprueba si el valor ascii es mayor a '122'
	ble procesador_higher 		@En este caso el valor '122' pertenece a 'z'

	b error 			@Si llegamos aquí, el caracter es inválido

continuador:
	add r3, r3, #1
	b convertidor

procesador_lower:
	add r0, r0, #32  		@Suma '32' al valor ascii
	strb r0, [r1, r3]
	b continuador

procesador_higher:
	sub r0, r0, #32 		@Suma '32' al valor ascii
	strb r0, [r1, r3]
	b continuador

print:
	mov r0, #1  			@Imprime el resultado en consola
	ldr r1, =texto
	mov r2, r3
	mov r7, #4
	swi 0
	b exit

error: 
	mov r0, #1 			@Imprime el mensaje de error y
	ldr r1, =errorMsg   		@termina el programa
	ldr r2, =errorLarge
	mov r7, #4
	swi 0
	b exit

exit:
	mov r7, #1  			@Termina el programa
	mov r0, #0
	swi 0
