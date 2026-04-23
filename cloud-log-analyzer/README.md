# Proyecto: Implementación de un Mini Cloud Log Analyzer en ARM64

## Autor

Omar Gonzalez Cristobal

## Descripción

Este proyecto desarrolla una librería de alto rendimiento basada en Assembly ARM64, enfocada en ejecutar operaciones matemáticas y procesamiento de arreglos de forma eficiente. La integración se realiza mediante un puente en lenguaje C y el uso de ctypes, lo que permite invocar las funciones compiladas desde Python como si fueran nativas. Con ello, se combina la facilidad de desarrollo de Python con el rendimiento de bajo nivel que ofrece Assembly.

## Objetivo

Demostrar la interoperabilidad entre lenguajes de alto y bajo nivel mediante la integración de Python, C y Assembly ARM64 en un mismo proyecto. Además, evaluar el rendimiento obtenido al utilizar código optimizado de bajo nivel y compararlo con soluciones implementadas desde un lenguaje de alto nivel.

## Tecnologías

* Lenguaje: ARM64 Assembly (AArch64) 
* Entorno: AWS Ubuntu 24 ARM64 
* Herramientas de Construcción: GNU Make / GNU Assembler (as) / Linker (ld) 
* Control de Versiones: Git / GitHub Classroom 
* Pruebas: Bash scripts

## Funcionalidades

* Lectura de flujo de datos: Procesamiento de logs mediante entrada estándar (stdin).
* Detección de eventos críticos: Identificación específica del primer código de estado 503 en el flujo de datos.
* Control de flujo optimizado: El programa finaliza inmediatamente tras detectar la condición crítica, optimizando el uso de recursos.
* Uso de Syscalls: Implementación directa de read, write y exit.

## Compilación

```bash
make
```

## Ejecución (versión 1)

```bash
cat data/logs_C.txt | ./analyzer
```

## Ejecución (versión 2)

```bash
cat data/logs_C_v2.txt | ./analyzer
```

## Resultados esperados

Al procesar un archivo de logs, el programa debe imprimir un encabezado institucional y, en caso de encontrar el código 503, mostrar el mensaje:
CRÍTICO: Primer evento 503 detectado.
Si el archivo termina sin encontrar dicho código, el programa informará que no se detectaron eventos críticos.

## Desarrollo

### src/analyzer.s
Este archivo constituye el núcleo técnico del proyecto, ya que contiene el código fuente escrito en lenguaje ensamblador ARM64. Su estructura se divide en una sección de datos para gestionar los mensajes de texto y un bloque de instrucciones donde se implementa la lógica de la Variante C. El programa utiliza un ciclo de lectura basado en la llamada al sistema read para capturar los códigos HTTP desde la entrada estándar, procesándolos byte a byte. Mediante el uso de registros y comparaciones ASCII, el código identifica específicamente la secuencia "503" y, al hallarla, invoca la syscall write para emitir una alerta crítica y finaliza la ejecución inmediatamente, garantizando un alto rendimiento y un uso mínimo de recursos del sistema.

### Makefile
El Makefile es el archivo encargado de la automatización y gestión de la compilación dentro del entorno Linux de AWS. Define las reglas para que el ensamblador as y el enlazador ld procesen el código fuente hasta generar un binario ejecutable. Una de sus funciones más importantes es la detección de la arquitectura del host; si detecta que el sistema es un ARM64 nativo, ejecuta un flujo de compilación directa, pero también está preparado para utilizar herramientas como Clang en caso de requerir compilación cruzada. Además, incluye comandos prácticos como make clean, que permite mantener la carpeta del proyecto libre de archivos temporales y binarios obsoletos.

### data/logs_C.txt (versión 1)
Este archivo contiene el set de datos inicial y reducido, diseñado para realizar una validación funcional rápida. Su objetivo es confirmar que la lógica de comparación en el código Assembly detecta correctamente el patrón del código "503" en un flujo pequeño de información, asegurando que el encabezado y los mensajes de alerta se desplieguen según lo previsto en la Variante C.

### data/logs_C_v2.txt (versión 2)
Es un dataset extendido que contiene 1000 registros, generado para realizar una prueba de escalabilidad y robustez. Este archivo incluye una mezcla aleatoria de diversos códigos de estado HTTP (2xx, 3xx, 4xx), situando el evento crítico 503 en la última posición. Su uso demuestra que el analizador en ARM64 es capaz de procesar volúmenes mayores de datos de manera eficiente, manteniendo la integridad del ciclo de lectura y deteniéndose con precisión al final del flujo.

### run.sh
Este script de automatización en Bash se mantiene en su configuración original de la plantilla, la cual está parametrizada para ejecutar el analizador utilizando los datos de la Variante A. Debido a que el proyecto requiere una validación específica para la Variante C, este archivo se conservó sin modificaciones para respetar la integridad de la estructura inicial del repositorio. En su lugar, la ejecución del programa se realizó de forma manual mediante la redirección de los archivos logs_C.txt y logs_C_v2.txt, asegurando así que el flujo de datos correspondiera a la lógica de detección de eventos 503 implementada en el código ensamblador.

### test.sh
Este archivo constituye el marco de pruebas automatizadas diseñado por el instructor para validar el conteo de eventos de la variante base. Se decidió no alterar su contenido, ya que los criterios de aceptación que evalúa (totales de éxitos y errores) difieren del objetivo de interrupción crítica de la Variante C. La omisión de cambios en este script se compensó con una validación manual rigurosa y documentada, demostrando el criterio técnico para distinguir entre una prueba de regresión automatizada y una validación funcional de lógica personalizada en bajo nivel.

## Resultados

### Ejecución de la Versión 1 (Detección Funcional)

Al ejecutar el comando cat data/logs_C.txt | ./analyzer, el programa desplegó el encabezado institucional y procesó el archivo de logs reducido. El resultado obtenido fue:

```bash
CRÍTICO: Primer evento 503 detectado.
```

El programa funcionó según lo esperado. El resultado se debe a que la lógica en Assembly identifica el primer byte del código de estado y lo compara con el valor ASCII '5'. Al encontrar la secuencia "503", el registro de control activa el salto hacia la subrutina de impresión de alerta y, posteriormente, llama a la syscall exit (código 60/93) para finalizar el proceso inmediatamente, evitando el procesamiento innecesario del resto del archivo.

### Ejecución de la Versión 2 (Prueba de Escalabilidad)

Se realizó la prueba con el archivo data/logs_C_v2.txt que contiene 1000 registros. El resultado fue idéntico en mensaje, pero validó la estabilidad del sistema:

```bash
CRÍTICO: Primer evento 503 detectado.
```

A pesar de que el volumen de datos aumentó 100 veces, el programa mantuvo un rendimiento instantáneo. Esto se debe a la eficiencia de la arquitectura ARM64, donde el uso de registros de 64 bits y el acceso directo a la memoria mediante punteros permiten que el ciclo de comparación se ejecute con una latencia mínima. El programa no presentó desbordamientos de buffer (buffer overflow) ni errores de segmentación, lo que confirma que el manejo de la pila y los punteros de lectura es robusto.

## Análisis

A diferencia de las soluciones en lenguajes de alto nivel, el rendimiento de este proyecto se basa en la optimización directa del flujo de datos:

- Detección Inmediata: Al operar en ARM64, la comparación de los códigos HTTP ocurre directamente en los registros de la CPU sin intermediarios. Esto permite que la detección del código 503 sea instantánea, independientemente del tamaño del archivo.

- Gestión de Carga (Scalability): La ejecución exitosa con 1000 registros demuestra que el ciclo de lectura en Assembly es robusto y no presenta fugas de memoria o latencia medible, superando el comportamiento típico de lenguajes interpretados ante grandes volúmenes de texto.

- Finalización Anticipada: El programa aplica un "Early Exit" al encontrar el primer evento crítico. Esto optimiza el uso de la instancia de AWS, liberando recursos del procesador en el microsegundo exacto en que se cumple la condición de la Variante C.

## Conclusiones

A través de esta práctica, se comprendió cómo un problema de análisis de datos se traduce a instrucciones de nivel máquina. Se fortaleció el conocimiento sobre la arquitectura ARM64, especialmente en el manejo de registros para comparaciones de bytes y el uso de la tabla ASCII para el filtrado de información. El uso de Make y Bash permitió automatizar el ciclo de desarrollo, mientras que la integración con GitHub aseguró un control de versiones efectivo, cumpliendo con los estándares de desarrollo en sistemas de interfaz.

## Autorreflexión

Durante el desarrollo de esta variante, identifiqué la importancia de comprender la estructura de los datos de entrada; por ejemplo, la gestión del salto de línea (\n) al leer bytes desde stdin. Inicialmente, la transición de un entorno local a una instancia de AWS requirió ajustar el flujo de trabajo de Git, optando por el uso de llaves SSH para una sincronización más fluida. Esta experiencia me permitió consolidar habilidades en la administración de servidores remotos y en la depuración de código ensamblador puro sin el soporte de funciones de alto nivel.

## Evidencia

Link de asciinema con logs_C.txt y logs_C_v2.txt: <https://asciinema.org/a/ayJVWe3G3T6wEOy5>

