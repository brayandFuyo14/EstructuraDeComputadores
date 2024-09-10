.data
    prompt_numbers:    .asciiz "Ingresa la cantidad de numeros a comparar (3-5): "  # Mensaje para pedir la cantidad de números
    error_input:       .asciiz "Error: Debes ingresar entre 3 y 5 numeros.\n"  # Mensaje de error si la entrada es inválida
    prompt_input:      .asciiz "Ingresa un numero: "  # Mensaje para pedir un número
    result_message:    .asciiz "El numero mayor es: "  # Mensaje para mostrar el número mayor
    newline:           .asciiz "\n"  # Salto de línea

    .text
    .globl main

main:
    # Mostrar mensaje pidiendo cuántos números desea comparar
    li $v0, 4                      # syscall para imprimir string
    la $a0, prompt_numbers         # cargar la dirección del mensaje
    syscall                        # llamada al sistema para imprimir

    # Leer la cantidad de números (entre 3 y 5)
    li $v0, 5                     # syscall para leer entero
    syscall                       # llamada al sistema para leer entrada
    move $t0, $v0                 # mover el número leído a $t0 (cantidad de números)

    # Verificar que esté entre 3 y 5
    li $t1, 3                     # cargar el valor 3 en $t1
    li $t2, 5                     # cargar el valor 5 en $t2
    blt $t0, $t1, error_handler   # si la cantidad es menor que 3, saltar a error_handler
    bgt $t0, $t2, error_handler   # si la cantidad es mayor que 5, saltar a error_handler

    # Inicializar el número mayor
    li $t3, -2147483648           # inicializar $t3 (el mayor) con el menor entero posible

    # Bucle para leer los números
read_numbers:
    beq $t0, $zero, show_result    # si ya hemos leído todos los números, ir a mostrar resultado

    # Mostrar el mensaje para ingresar un número
    li $v0, 4                     # syscall para imprimir string
    la $a0, prompt_input          # cargar la dirección del mensaje
    syscall                       # llamada al sistema para imprimir

    # Leer el número
    li $v0, 5                     # syscall para leer entero
    syscall                       # llamada al sistema para leer
    move $t4, $v0                 # mover el número leído a $t4

    # Comparar con el número mayor actual
    ble $t4, $t3, skip_update     # si el número ingresado es menor o igual al actual mayor, saltar
    move $t3, $t4                 # si es mayor, actualizar el mayor

skip_update:
    sub $t0, $t0, 1               # reducir el contador de números
    j read_numbers                # repetir el proceso para el siguiente número

show_result:
    # Mostrar el mensaje "El número mayor es: "
    li $v0, 4                     # syscall para imprimir string
    la $a0, result_message        # cargar la dirección del mensaje
    syscall                       # llamada al sistema para imprimir

    # Mostrar el número mayor
    move $a0, $t3                 # mover el valor mayor a $a0
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