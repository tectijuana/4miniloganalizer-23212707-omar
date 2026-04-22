<img width="1536" height="1024" alt="image" src="https://github.com/user-attachments/assets/a44bb0d7-30f9-4fff-95bf-f08277476255" />


# Mini Cloud Log Analyzer (Bash + ARM64 + GNU Make)

Práctica universitaria orientada a estudiantes principiantes para reforzar fundamentos de:
- Ensamblador **ARM64 (AArch64 Linux)**,
- uso de **syscalls Linux** sin libc,
- automatización con **Bash**,
- y flujo de trabajo con **GitHub Classroom**.

---

## 1) Enunciado formal de la práctica

Implemente un analizador de logs de servidor en ARM64 Assembly que reciba por `stdin` una secuencia de códigos HTTP (un entero por línea), y procese la información según la variante asignada por el docente.

La versión base proporcionada (Variante A) ya compila y ejecuta, y cuenta:
- códigos de éxito **2xx**,
- errores de cliente **4xx**,
- errores de servidor **5xx**.

Ejecución esperada:

```bash
cat logs.txt | ./analyzer
```

---

## 2) Objetivos de aprendizaje

Al finalizar esta práctica, el estudiante será capaz de:
1. Compilar y enlazar un programa ARM64 sin C ni libc.
2. Invocar syscalls Linux (`read`, `write`, `exit`).
3. Parsear enteros desde flujo de bytes (`stdin`).
4. Diseñar lógica condicional para análisis de códigos HTTP.
5. Validar resultados con scripts de prueba reproducibles.

---

## 3) Estructura del repositorio

```text
cloud-log-analyzer/
├── README.md
├── Makefile
├── run.sh
├── src/
│   └── analyzer.s
├── data/
│   ├── logs_A.txt
│   ├── logs_B.txt
│   ├── logs_C.txt
│   ├── logs_D.txt
│   └── logs_E.txt
├── tests/
│   ├── test.sh
│   └── expected_outputs.txt
└── instructor/
    └── VARIANTES.md
```

---

## 4) Requisitos técnicos

- Sistema objetivo: **AWS Ubuntu 24 ARM64**.
- Arquitectura: **AArch64 Linux**.
- Ensamblador: **GNU assembler** (o equivalente compatible para construir en entorno alterno).
- Restricciones:
  - Sin libc.
  - Sin lenguaje C.
  - Solo syscalls Linux + Bash + Make.

---

## 5) Flujo sugerido en GitHub Classroom

1. El docente crea la actividad en GitHub Classroom.
2. Cada estudiante acepta su repositorio individual.
3. Clona su repositorio en instancia AWS ARM64.
4. Implementa su variante en `src/analyzer.s`.
5. Ejecuta:
   - `make`
   - `make run`
   - `make test`
6. Hace commit/push y entrega el enlace del repositorio.

---

## 6) Instrucciones de uso en AWS Ubuntu 24 ARM64

### 6.1 Compilar

```bash
make
```

### 6.2 Ejecutar ejemplo base

```bash
make run
```

### 6.3 Ejecutar pruebas

```bash
make test
```

### 6.4 Limpiar artefactos

```bash
make clean
```

---

## 7) Variantes de práctica

- **A**: contar 2xx, 4xx, 5xx.
- **B**: encontrar código más frecuente.
- **C**: detectar primer 503.
- **D**: detectar 3 errores consecutivos.
- **E**: calcular health score.

Detalles de asignación docente: ver `instructor/VARIANTES.md`.

---

## 8) Rúbrica propuesta

Toda solución debe tener:
1. Encabezado del programador
2. Pseudocódigo
3. Código ARM64 comentado

| Criterio | Ponderación |
|---|---:|
| Correctitud funcional de la variante asignada | 40% |
| Dominio técnico de ARM64 + syscalls | 25% |
| Pruebas automatizadas y reproducibilidad | 20% |
| Calidad de documentación y claridad de código | 15% |

### Criterios de descuento sugeridos
- No compila en ARM64: hasta -40%.
- Usa C/libc: evaluación inválida por incumplir restricción.
- Sin evidencia de pruebas: hasta -20%. Utiliar Asciinema (con su nombre y preferente), o tambien LOOM.com compartido link

---

## 9) Notas para estudiantes

- Lean y entiendan el pseudocódigo al inicio de `src/analyzer.s`.
- Mantengan comentarios técnicos claros y breves.
- Trabajen incrementalmente: primero parser, luego lógica de variante, luego pruebas.
- Si trabajan en host x86_64, se recomienda emulación con `qemu-aarch64` o compilar/ejecutar directamente en AWS ARM64.

---

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

### Evidencias

Link de asciinema: <https://asciinema.org/a/1eYLKUy4P9xqYvoG>

