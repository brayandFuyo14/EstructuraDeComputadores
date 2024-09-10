.data
prompt_numbers:    .asciiz "Ingrese la cantidad de numeors a comparar (3-5): "  # Mensaje para pedir la cantidad de n�meros
error_input:       .asciiz "Error: Debes ingresar entre 3 y 5 numeros.\n"  # Mensaje de error si la entrada es inv�lida
prompt_input:      .asciiz "Ingresa un numero: "  # Mensaje para pedir un n�mero
result_message:    .asciiz "El numero menor es: "  # Mensaje para mostrar el n�mero menor
newline:           .asciiz "\n"  # Salto de l�nea

    .text
    .globl main

main:
    # Mostrar mensaje pidiendo cu�ntos n�meros desea comparar
    li $v0, 4                     # syscall para imprimir string
    la $a0, prompt_numbers        # cargar la direcci�n del mensaje
    syscall                       # llamada al sistema para imprimir

    # Leer la cantidad de n�meros (entre 3 y 5)
    li $v0, 5                     # syscall para leer entero
    syscall                       # llamada al sistema para leer entrada
    move $t0, $v0                 # mover el n�mero le�do a $t0 (cantidad de n�meros)

    # Verificar que est� entre 3 y 5
    li $t1, 3                     # cargar el valor 3 en $t1
    li $t2, 5                     # cargar el valor 5 en $t2
    blt $t0, $t1, error_handler   # si la cantidad es menor que 3, saltar a error_handler
    bgt $t0, $t2, error_handler   # si la cantidad es mayor que 5, saltar a error_handler

    # Inicializar el n�mero menor
    li $t3, 2147483647            # inicializar $t3 (el menor) con el mayor entero posible

    # Bucle para leer los n�meros
read_numbers:
    beq $t0, $zero, show_result   # si ya hemos le�do todos los n�meros, ir a mostrar resultado

    # Mostrar el mensaje para ingresar un n�mero
    li $v0, 4                     # syscall para imprimir string
    la $a0, prompt_input          # cargar la direcci�n del mensaje
    syscall                       # llamada al sistema para imprimir

    # Leer el n�mero
    li $v0, 5                     # syscall para leer entero
    syscall                       # llamada al sistema para leer
    move $t4, $v0                 # mover el n�mero le�do a $t4

    # Comparar con el n�mero menor actual
    bge $t4, $t3, skip_update     # si el n�mero ingresado es mayor o igual al actual menor, saltar
    move $t3, $t4                 # si es menor, actualizar el menor

skip_update:
    sub $t0, $t0, 1               # reducir el contador de n�meros
    j read_numbers                # repetir el proceso para el siguiente n�mero

show_result:
    # Mostrar el mensaje "El n�mero menor es: "
    li $v0, 4                     # syscall para imprimir string
    la $a0, result_message        # cargar la direcci�n del mensaje
    syscall                       # llamada al sistema para imprimir

    # Mostrar el n�mero menor
    move $a0, $t3                 # mover el valor menor a $a0
    li $v0, 1                     # syscall para imprimir entero
    syscall                       # llamada al sistema para imprimir el n�mero

    # Salto de l�nea
    li $v0, 4                     # syscall para imprimir string
    la $a0, newline               # cargar salto de l�nea
    syscall                       # llamada al sistema para imprimir

    # Terminar el programa
    li $v0, 10                    # syscall para salir
    syscall                       # llamada al sistema para salir

error_handler:
    # Mostrar mensaje de error
    li $v0, 4                     # syscall para imprimir string
    la $a0, error_input           # cargar la direcci�n del mensaje de error
    syscall                       # llamada al sistema para imprimir
    j main                        # regresar al inicio del programa