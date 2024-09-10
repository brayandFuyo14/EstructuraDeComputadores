.data
prompt_fib:       .asciiz "�Cu�ntos n�meros de la serie Fibonacci deseas generar?: "  # Pregunta cu�ntos n�meros generar
result_message:   .asciiz "La serie Fibonacci es: "   # Mensaje antes de mostrar la serie
sum_message:      .asciiz "La suma de los n�meros de la serie es: "  # Mensaje antes de mostrar la suma
newline:          .asciiz "\n"  # Salto de l�nea

    .text
    .globl main

main:
    # Pedir al usuario cu�ntos n�meros de la serie Fibonacci generar
    li $v0, 4                     # syscall para imprimir string
    la $a0, prompt_fib            # cargar direcci�n del mensaje
    syscall                       # llamada al sistema para imprimir

    # Leer la cantidad de n�meros
    li $v0, 5                     # syscall para leer entero
    syscall                       # llamada al sistema para leer
    move $t0, $v0                 # guardar el n�mero le�do en $t0 (cantidad de n�meros)

    # Verificar si la cantidad es v�lida (> 0)
    blez $t0, end_program          # si el n�mero es <= 0, terminar el programa

    # Inicializar valores de Fibonacci
    li $t1, 0                     # $t1 = 0, primer n�mero de la serie (F0)
    li $t2, 1                     # $t2 = 1, segundo n�mero de la serie (F1)
    li $t3, 0                     # $t3 ser� la suma total

    # Mostrar mensaje "La serie Fibonacci es: "
    li $v0, 4                     # syscall para imprimir string
    la $a0, result_message        # cargar direcci�n del mensaje
    syscall                       # llamada al sistema para imprimir

    # Mostrar el primer n�mero (F0)
    move $a0, $t1                 # cargar el valor de F0 (0)
    li $v0, 1                     # syscall para imprimir entero
    syscall                       # llamada al sistema para imprimir
    li $v0, 4                     # syscall para imprimir string (salto de l�nea)
    la $a0, newline
    syscall                       # llamada al sistema para imprimir salto de l�nea
    add $t3, $t3, $t1             # sumar F0 a la suma total

    # Si se requiere m�s de un n�mero, mostrar el segundo (F1)
    beq $t0, 1, show_sum          # si el usuario pidi� solo un n�mero, ir a mostrar la suma
    move $a0, $t2                 # cargar el valor de F1 (1)
    li $v0, 1                     # syscall para imprimir entero
    syscall                       # llamada al sistema para imprimir
    li $v0, 4                     # syscall para imprimir string (salto de l�nea)
    la $a0, newline
    syscall                       # llamada al sistema para imprimir salto de l�nea
    add $t3, $t3, $t2             # sumar F1 a la suma total

    # Bucle para calcular los n�meros restantes de la serie Fibonacci
    sub $t0, $t0, 2               # restar 2 de la cantidad total, ya imprimimos los dos primeros
fib_loop:
    beq $t0, $zero, show_sum      # si ya hemos impreso todos los n�meros, mostrar la suma

    # Calcular el siguiente n�mero de la serie Fibonacci
    add $t4, $t1, $t2             # $t4 = $t1 + $t2 (el siguiente n�mero de Fibonacci)
    move $a0, $t4                 # cargar el siguiente n�mero en $a0
    li $v0, 1                     # syscall para imprimir entero
    syscall                       # llamada al sistema para imprimir
    li $v0, 4                     # syscall para imprimir string (salto de l�nea)
    la $a0, newline
    syscall                       # llamada al sistema para imprimir salto de l�nea

    # Sumar el n�mero actual a la suma total
    add $t3, $t3, $t4             # suma el valor de $t4 a la suma total

    # Actualizar los valores de la serie para la pr�xima iteraci�n
    move $t1, $t2                 # $t1 toma el valor de $t2
    move $t2, $t4                 # $t2 toma el valor de $t4 (el nuevo Fibonacci)

    # Disminuir el contador de n�meros
    sub $t0, $t0, 1               # disminuir el contador
    j fib_loop                    # repetir el ciclo

show_sum:
    # Mostrar mensaje "La suma de los n�meros de la serie es: "
    li $v0, 4                     # syscall para imprimir string
    la $a0, sum_message           # cargar direcci�n del mensaje
    syscall                       # llamada al sistema para imprimir

    # Mostrar la suma total
    move $a0, $t3                 # cargar la suma total en $a0
    li $v0, 1                     # syscall para imprimir entero
    syscall                       # llamada al sistema para imprimir
    li $v0, 4                     # salto de l�nea
    la $a0, newline
    syscall

end_program:
    # Terminar el programa
    li $v0, 10                    # syscall para salir
    syscall                       # llamada al sistema para terminar el programa