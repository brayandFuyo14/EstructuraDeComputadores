.data
prompt_numbers:    .asciiz "Ingrese la cantidad de numeors a comparar (3-5): "  # Mensaje para pedir la cantidad de números
error_input:       .asciiz "Error: Debes ingresar entre 3 y 5 numeros.\n"  # Mensaje de error si la entrada es inválida
prompt_input:      .asciiz "Ingresa un numero: "  # Mensaje para pedir un número
result_message:    .asciiz "El numero menor es: "  # Mensaje para mostrar el número menor
newline:           .asciiz "\n"  # Salto de línea

    .text
    .globl main

main:
    # Mostrar mensaje pidiendo cuántos números desea comparar
    li $v0, 4                     # syscall para imprimir string
    la $a0, prompt_numbers        # cargar la dirección del mensaje
    syscall                       # llamada al sistema para imprimir

    # Leer la cantidad de números (entre 3 y 5)
    li $v0, 5                     # syscall para leer entero
    syscall                       # llamada al sistema para leer entrada
    move $t0, $v0                 # mover el número leído a $t0 (cantidad de números)

    # Verificar que esté entre 3 y 5
    li $t1, 3                     # cargar el valor 3 en $t1
    li $t2, 5                     # cargar el valor 5 en $t2
    blt $t0, $t1, error_handler   # si la cantidad es menor que 3, saltar a error_handler
    bgt $t0, $t2, error_handler   # si la cantidad es mayor que 5, saltar a error_handler

    # Inicializar el número menor
    li $t3, 2147483647            # inicializar $t3 (el menor) con el mayor entero posible

    # Bucle para leer los números
read_numbers:
    beq $t0, $zero, show_result   # si ya hemos leído todos los números, ir a mostrar resultado

    # Mostrar el mensaje para ingresar un número
    li $v0, 4                     # syscall para imprimir string
    la $a0, prompt_input          # cargar la dirección del mensaje
    syscall                       # llamada al sistema para imprimir

    # Leer el número
    li $v0, 5                     # syscall para leer entero
    syscall                       # llamada al sistema para leer
    move $t4, $v0                 # mover el número leído a $t4

    # Comparar con el número menor actual
    bge $t4, $t3, skip_update     # si el número ingresado es mayor o igual al actual menor, saltar
    move $t3, $t4                 # si es menor, actualizar el menor

skip_update:
    sub $t0, $t0, 1               # reducir el contador de números
    j read_numbers                # repetir el proceso para el siguiente número

show_result:
    # Mostrar el mensaje "El número menor es: "
    li $v0, 4                     # syscall para imprimir string
    la $a0, result_message        # cargar la dirección del mensaje
    syscall                       # llamada al sistema para imprimir

    # Mostrar el número menor
    move $a0, $t3                 # mover el valor menor a $a0
    li $v0, 1                     # syscall para imprimir entero
    syscall                       # llamada al sistema para imprimir el número

    # Salto de línea
    li $v0, 4                     # syscall para imprimir string
    la $a0, newline               # cargar salto de línea
    syscall                       # llamada al sistema para imprimir

    # Terminar el programa
    li $v0, 10                    # syscall para salir
    syscall                       # llamada al sistema para salir

error_handler:
    # Mostrar mensaje de error
    li $v0, 4                     # syscall para imprimir string
    la $a0, error_input           # cargar la dirección del mensaje de error
    syscall                       # llamada al sistema para imprimir
    j main                        # regresar al inicio del programa