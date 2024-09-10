.data
prompt_fib:       .asciiz "¿Cuántos números de la serie Fibonacci deseas generar?: "  # Pregunta cuántos números generar
result_message:   .asciiz "La serie Fibonacci es: "   # Mensaje antes de mostrar la serie
sum_message:      .asciiz "La suma de los números de la serie es: "  # Mensaje antes de mostrar la suma
newline:          .asciiz "\n"  # Salto de línea

    .text
    .globl main

main:
    # Pedir al usuario cuántos números de la serie Fibonacci generar
    li $v0, 4                     # syscall para imprimir string
    la $a0, prompt_fib            # cargar dirección del mensaje
    syscall                       # llamada al sistema para imprimir

    # Leer la cantidad de números
    li $v0, 5                     # syscall para leer entero
    syscall                       # llamada al sistema para leer
    move $t0, $v0                 # guardar el número leído en $t0 (cantidad de números)

    # Verificar si la cantidad es válida (> 0)
    blez $t0, end_program          # si el número es <= 0, terminar el programa

    # Inicializar valores de Fibonacci
    li $t1, 0                     # $t1 = 0, primer número de la serie (F0)
    li $t2, 1                     # $t2 = 1, segundo número de la serie (F1)
    li $t3, 0                     # $t3 será la suma total

    # Mostrar mensaje "La serie Fibonacci es: "
    li $v0, 4                     # syscall para imprimir string
    la $a0, result_message        # cargar dirección del mensaje
    syscall                       # llamada al sistema para imprimir

    # Mostrar el primer número (F0)
    move $a0, $t1                 # cargar el valor de F0 (0)
    li $v0, 1                     # syscall para imprimir entero
    syscall                       # llamada al sistema para imprimir
    li $v0, 4                     # syscall para imprimir string (salto de línea)
    la $a0, newline
    syscall                       # llamada al sistema para imprimir salto de línea
    add $t3, $t3, $t1             # sumar F0 a la suma total

    # Si se requiere más de un número, mostrar el segundo (F1)
    beq $t0, 1, show_sum          # si el usuario pidió solo un número, ir a mostrar la suma
    move $a0, $t2                 # cargar el valor de F1 (1)
    li $v0, 1                     # syscall para imprimir entero
    syscall                       # llamada al sistema para imprimir
    li $v0, 4                     # syscall para imprimir string (salto de línea)
    la $a0, newline
    syscall                       # llamada al sistema para imprimir salto de línea
    add $t3, $t3, $t2             # sumar F1 a la suma total

    # Bucle para calcular los números restantes de la serie Fibonacci
    sub $t0, $t0, 2               # restar 2 de la cantidad total, ya imprimimos los dos primeros
fib_loop:
    beq $t0, $zero, show_sum      # si ya hemos impreso todos los números, mostrar la suma

    # Calcular el siguiente número de la serie Fibonacci
    add $t4, $t1, $t2             # $t4 = $t1 + $t2 (el siguiente número de Fibonacci)
    move $a0, $t4                 # cargar el siguiente número en $a0
    li $v0, 1                     # syscall para imprimir entero
    syscall                       # llamada al sistema para imprimir
    li $v0, 4                     # syscall para imprimir string (salto de línea)
    la $a0, newline
    syscall                       # llamada al sistema para imprimir salto de línea

    # Sumar el número actual a la suma total
    add $t3, $t3, $t4             # suma el valor de $t4 a la suma total

    # Actualizar los valores de la serie para la próxima iteración
    move $t1, $t2                 # $t1 toma el valor de $t2
    move $t2, $t4                 # $t2 toma el valor de $t4 (el nuevo Fibonacci)

    # Disminuir el contador de números
    sub $t0, $t0, 1               # disminuir el contador
    j fib_loop                    # repetir el ciclo

show_sum:
    # Mostrar mensaje "La suma de los números de la serie es: "
    li $v0, 4                     # syscall para imprimir string
    la $a0, sum_message           # cargar dirección del mensaje
    syscall                       # llamada al sistema para imprimir

    # Mostrar la suma total
    move $a0, $t3                 # cargar la suma total en $a0
    li $v0, 1                     # syscall para imprimir entero
    syscall                       # llamada al sistema para imprimir
    li $v0, 4                     # salto de línea
    la $a0, newline
    syscall

end_program:
    # Terminar el programa
    li $v0, 10                    # syscall para salir
    syscall                       # llamada al sistema para terminar el programa