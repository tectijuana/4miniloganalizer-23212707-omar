// 🌴🌞 ¡Hola desde la Isla del ITT! 🍹🌊
// |￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣|
// | • Autor: Omar Gonzalez Cristóbal                                                         |
// | • Materia: Lenguajes de Interfaz                                                         |
// | • Grupo: SC6A                                                                            |
// | • Fecha: 2026/04/22                                                                      |
// | • Arquitectura: ARM64 (AArch64) en AWS Ubuntu 24                                         |
// | • Descripción: Mini Cloud Log Analyzer - Variante C.                                     |
// |   Este programa analiza flujos de logs HTTP y detecta el primer evento crítico 503       |
// |   utilizando syscalls de Linux y comparaciones directas en registros.                    |
// ￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣￣
// 🌺🏖️ ¡Código playero activado! 🏖️🌺
// ════════•°• Ubuntu + Github para clima perfecto •°•════════

/*
PSEUDOCÓDIGO:
1. Imprimir el encabezado del analizador en la terminal (Syscall write). 
2. Leer una línea de la entrada estándar (Syscall read). 
3. Si la lectura devuelve 0 bytes, saltar al final (EOF). 
4. Extraer los primeros 3 caracteres del buffer de lectura. 
5. Comparar byte a byte: ¿Es el primero '5', el segundo '0' y el tercero '3'? 
6. Si coinciden: Imprimir "Evento 503 detectado" y terminar ejecución. 
7. Si no coinciden: Volver al paso 2 para procesar la siguiente línea. 
*/

.section .data
    header:         .ascii "=== Mini Cloud Log Analyzer (Variante C) ===\n"
    header_len = . - header
    found_msg:      .ascii "CRÍTICO: Primer evento 503 detectado.\n"
    found_len = . - found_msg
    not_found:      .ascii "Finalizado: No se encontraron eventos 503.\n"
    not_found_len = . - not_found
    buffer:         .skip 16

.section .text
.global _start

_start:
    // --- PASO 1: Imprimir encabezado ---
    mov x0, 1           // File descriptor 1 = stdout
    ldr x1, =header
    ldr x2, =header_len
    mov x8, 64          // Syscall write (ARM64)
    svc 0

read_loop:
    // --- PASO 2: Leer de stdin ---
    mov x0, 0           // File descriptor 0 = stdin
    ldr x1, =buffer
    mov x2, 4           // Leer formato "503\n" (4 bytes)
    mov x8, 63          // Syscall read (ARM64)
    svc 0

    // --- PASO 3: Verificar fin de archivo (EOF) ---
    cmp x0, 0
    beq no_match_exit

    // --- PASO 4 y 5: Lógica de comparación ASCII ---
    ldr x3, =buffer
    ldrb w4, [x3]       // Cargar byte 1 (ej. '5')
    ldrb w5, [x3, 1]    // Cargar byte 2 (ej. '0')
    ldrb w6, [x3, 2]    // Cargar byte 3 (ej. '3')

    // '5'=53, '0'=48, '3'=51 en la tabla ASCII
    cmp w4, 53          
    bne read_loop       // Si no es 5, saltar a la siguiente lectura
    cmp w5, 48
    bne read_loop       // Si no es 0, saltar a la siguiente lectura
    cmp w6, 51
    bne read_loop       // Si no es 3, saltar a la siguiente lectura

    // --- PASO 6: Hallazgo detectado ---
    mov x0, 1
    ldr x1, =found_msg
    ldr x2, =found_len
    mov x8, 64
    svc 0
    b exit_program

no_match_exit:
    mov x0, 1
    ldr x1, =not_found
    ldr x2, =not_found_len
    mov x8, 64
    svc 0

exit_program:
    // Salida limpia del programa
    mov x0, 0
    mov x8, 93          // Syscall exit
    svc 0
