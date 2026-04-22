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

## Ejecución

```bash
cat data/logs_C.txt | ./analyzer
```

## Resultados esperados

Al procesar un archivo de logs, el programa debe imprimir un encabezado institucional y, en caso de encontrar el código 503, mostrar el mensaje:
CRÍTICO: Primer evento 503 detectado.
Si el archivo termina sin encontrar dicho código, el programa informará que no se detectaron eventos críticos.

## Conclusiones

A través de esta práctica, se comprendió cómo un problema de análisis de datos se traduce a instrucciones de nivel máquina. Se fortaleció el conocimiento sobre la arquitectura ARM64, especialmente en el manejo de registros para comparaciones de bytes y el uso de la tabla ASCII para el filtrado de información. El uso de Make y Bash permitió automatizar el ciclo de desarrollo, mientras que la integración con GitHub aseguró un control de versiones efectivo, cumpliendo con los estándares de desarrollo en sistemas de interfaz.

## Autorreflexión

Durante el desarrollo de esta variante, identifiqué la importancia de comprender la estructura de los datos de entrada; por ejemplo, la gestión del salto de línea (\n) al leer bytes desde stdin. Inicialmente, la transición de un entorno local a una instancia de AWS requirió ajustar el flujo de trabajo de Git, optando por el uso de llaves SSH para una sincronización más fluida. Esta experiencia me permitió consolidar habilidades en la administración de servidores remotos y en la depuración de código ensamblador puro sin el soporte de funciones de alto nivel.

### Desarrollo

### src/analyzer.s
Este archivo constituye el núcleo técnico del proyecto, ya que contiene el código fuente escrito en lenguaje ensamblador ARM64. Su estructura se divide en una sección de datos para gestionar los mensajes de texto y un bloque de instrucciones donde se implementa la lógica de la Variante C. El programa utiliza un ciclo de lectura basado en la llamada al sistema read para capturar los códigos HTTP desde la entrada estándar, procesándolos byte a byte. Mediante el uso de registros y comparaciones ASCII, el código identifica específicamente la secuencia "503" y, al hallarla, invoca la syscall write para emitir una alerta crítica y finaliza la ejecución inmediatamente, garantizando un alto rendimiento y un uso mínimo de recursos del sistema.

### Makefile
El Makefile es el archivo encargado de la automatización y gestión de la compilación dentro del entorno Linux de AWS. Define las reglas para que el ensamblador as y el enlazador ld procesen el código fuente hasta generar un binario ejecutable. Una de sus funciones más importantes es la detección de la arquitectura del host; si detecta que el sistema es un ARM64 nativo, ejecuta un flujo de compilación directa, pero también está preparado para utilizar herramientas como Clang en caso de requerir compilación cruzada. Además, incluye comandos prácticos como make clean, que permite mantener la carpeta del proyecto libre de archivos temporales y binarios obsoletos.

### data/logs_C.txt
Este archivo de texto plano funciona como el conjunto de datos de prueba (dataset) específico para la variante asignada. Contiene una lista de códigos de estado HTTP que simulan el tráfico de un servidor real. Su papel en el desarrollo es fundamental para la validación funcional, ya que permite verificar que el analizador no solo lee correctamente los datos, sino que es capaz de detenerse y reportar el evento crítico en el momento exacto en que aparece el primer código 503, ignorando los códigos de éxito (2xx) o errores de cliente (4xx) previos.

### run.sh
Es un script de automatización en Bash diseñado para facilitar la ejecución del analizador sin necesidad de escribir comandos complejos en la terminal. Su función principal es servir de puente entre los datos y el ejecutable; mediante el uso de tuberías o "pipes", redirige el contenido de los archivos de log directamente hacia la entrada estándar (stdin) del programa en ensamblador. Para el desarrollo de esta práctica, el script fue una herramienta clave para realizar pruebas rápidas y asegurar que el binario interactuara correctamente con el sistema operativo bajo diferentes escenarios de carga.

### test.sh
Este archivo implementa un marco de pruebas automatizadas que evalúa la correctitud del programa. Su lógica consiste en ejecutar el analizador contra múltiples archivos de log y comparar la salida generada con un resultado esperado previamente definido. Aunque el script base estaba orientado a la variante de conteo, su estructura fue esencial durante el desarrollo para comprender los estándares de validación de software y asegurar que el programa cumpliera con los requisitos de salida profesional exigidos por la rúbrica de la materia.
### Evidencias

Link de asciinema: <https://asciinema.org/a/1eYLKUy4P9xqYvoG>

