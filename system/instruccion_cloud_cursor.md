# Instrucción Cloud–Cursor

> Guía para LLMs: cómo funciona la comunicación entre Cloud (Orquestrador Máximo) y Cursor (Operador).  
> Objetivo: que un modelo entienda el protocolo en ambas direcciones y actúe correctamente según su rol.

---

## Roles

| Rol | Entidad | Responsabilidad |
|-----|---------|-----------------|
| **Orquestrador Máximo** | Cloud | Define metas, descompone en tareas, emite instrucciones, interpreta resultados y genera la respuesta final. |
| **Operador** | Cursor | Recibe instrucciones, ejecuta tareas en el repo, reporta avances, problemas y recomendaciones para que Cloud cierre el ciclo. |

La comunicación es **asíncrona y basada en archivos**: no hay API en tiempo real. Cloud escribe instrucciones; Cursor (o un humano usando Cursor) ejecuta y escribe resultados. Cloud lee esos resultados y decide el siguiente paso o la respuesta final.

---

## Cloud → Cursor: Cómo Cloud da instrucciones

Cloud actúa como orquestrador: analiza la meta, descompone en tareas y **escribe** lo que Cursor debe hacer.

### 1. Ubicación de las instrucciones

- **Directorio:** `.cursor/orchestrator/instructions/`
- **Formatos:**
  - `task_{task_id}_{timestamp}.json` — Tarea en JSON (estructura machine-readable).
  - `cursor_task_{task_id}_{timestamp}.md` — Instrucción en Markdown (legible por un LLM en Cursor).

### 2. Contenido que Cloud escribe (instrucción hacia Cursor)

En el **JSON** suele aparecer:

- `task_id`: identificador de la tarea.
- `agent_name`: agente a invocar (ej. `frontend-developer`, `ui-ux-designer`).
- `instruction`: texto completo de la tarea (objetivo, criterios de aceptación, contexto).
- `context`: meta del proyecto, descripción de la tarea, `acceptance_criteria`, etc.
- `status`: `pending` → luego Cloud/Cursor puede actualizarlo a `in_progress`, `completed`, `failed`.
- `created_at`, `result_file` (cuando aplica).

En el **Markdown** (para el operador en Cursor):

- Título: "Instrucción de Orquestrador - Tarea {id}".
- Sección "Agente a Invocar": p. ej. `@frontend-developer`.
- Sección "Instrucción": mismo contenido que `instruction` en JSON (objetivo, criterios, contexto de iteraciones previas).
- Sección "Resultado Esperado": qué debe hacer Cursor al terminar (ej. marcar como completada).

### 3. Resumen para un LLM en Cursor

- **Tu rol como Operador:** leer las instrucciones desde `.cursor/orchestrator/instructions/` (prioridad al `.md` más reciente de la tarea que te asignen).
- **Qué hacer:** ejecutar la tarea (código, tests, cambios en repo) e **informar** avances, problemas y recomendaciones (ver siguiente sección) para que Cloud pueda dar la respuesta final.

---

## Cursor → Cloud: Cómo Cursor indica avances, problemas y recomendaciones

Cursor no “responde” por API; **comunica** escribiendo en archivos que Cloud (u otro proceso) lee. Así Cloud sabe qué pasó y qué hacer a continuación.

### 1. Ubicación de los resultados

- **Directorio:** `.cursor/orchestrator/results/`
- **Archivo típico:** `result_{task_id}_{timestamp}.json`

### 2. Contenido que Cursor debe escribir (reporte hacia Cloud)

Estructura sugerida del JSON de resultado:

| Campo | Tipo | Descripción |
|-------|------|-------------|
| `task_id` | number | ID de la tarea (igual al de la instrucción). |
| `status` | string | `completed` o `failed`. |
| `success` | boolean | `true` si la tarea se cumplió; `false` si falló o se abandonó. |
| `completed_at` | string (ISO) | Fecha/hora de finalización. |
| `output` | string | Resumen breve en texto: qué se hizo y qué se entregó. |
| `files_created` | string[] | Lista de archivos creados. |
| `files_modified` | string[] | Lista de archivos modificados. |
| `errors` | string[] | Errores encontrados (build, tests, runtime, etc.). |
| `advances` | string[] | *(Opcional)* Avances concretos (ej. “Componente X creado”, “Tests pasando”). |
| `problems` | string[] | *(Opcional)* Problemas bloqueantes o riesgos. |
| `recommendations_next` | string[] | *(Opcional)* Recomendaciones para la siguiente tarea o para que Cloud genere la respuesta final. |

Cloud usa este objeto para:

- Decidir si la tarea está **completed** o **failed**.
- Actualizar el estado de la instrucción (p. ej. en el JSON de `instructions/`).
- Elegir la siguiente tarea o **generar la respuesta final** al usuario (resumen, próximos pasos, advertencias).

### 3. Si no hay escritura automática en `results/`

En muchos entornos, nadie escribe aún en `results/`. Entonces:

- **Avances / problemas / recomendaciones** pueden reportarse en el **mismo canal de conversación** (por ejemplo, en la respuesta del LLM en Cursor): lista breve de “Avances”, “Problemas” y “Recomendaciones próximas”.
- Cloud (el LLM que actúa como Orquestrador) debe **interpretar** esa respuesta como el reporte de Cursor y usarla para actualizar estado y respuesta final.
- Opcionalmente, se puede marcar la tarea como completada con:  
  `python3 .cursor/skills/orchestrator/cli.py mark-complete <TASK_ID>`  
  para que el orquestrador automático avance.

### 4. Resumen para un LLM en Cursor (reporte)

- **Al terminar una tarea (éxito o fallo):**
  1. Escribir en `.cursor/orchestrator/results/result_{task_id}_{timestamp}.json` el objeto anterior, **o**
  2. En la respuesta al usuario, incluir de forma explícita:
     - **Avances:** qué se completó y qué se entregó.
     - **Problemas:** errores o bloqueos.
     - **Recomendaciones próximas:** qué hacer después o qué debe considerar Cloud para la respuesta final.
- Así Cloud (Orquestrador Máximo) puede cerrar el ciclo y dar la respuesta final.

---

## Flujo completo (resumen para un LLM)

1. **Cloud (Orquestrador Máximo)**  
   - Define la meta y descompone en tareas.  
   - Escribe en `.cursor/orchestrator/instructions/` (JSON + MD).  
   - Opcionalmente ejecuta lógica (p. ej. `orchestrator`, `cli`) que crea esas instrucciones.

2. **Cursor (Operador)**  
   - Lee la instrucción desde `.cursor/orchestrator/instructions/` (idealmente el `.md` de la tarea asignada).  
   - Ejecuta la tarea (código, tests, archivos).  
   - Reporta:
     - En archivo: `.cursor/orchestrator/results/result_{task_id}_*.json`, **o**
     - En texto: avances, problemas y recomendaciones próximas en la respuesta.

3. **Cloud (Orquestrador Máximo)**  
   - Lee resultados en `results/` o interpreta la respuesta de Cursor.  
   - Actualiza estado (completed/failed).  
   - Decide siguiente tarea o **genera la respuesta final** al usuario usando avances, problemas y recomendaciones.

---

## Convenciones útiles

- **Idioma:** español para instrucciones y reportes (alineado con el resto del proyecto).
- **Tono:** directo, técnico, sin rodeos.
- **Criterios de aceptación:** deben estar en la instrucción; Cursor debe verificar y mencionar en el reporte si se cumplieron o no.
- **Marcado manual:** si no existe flujo que escriba en `results/`, usar `cli.py mark-complete <TASK_ID>` para que el orquestrador avance.

---

## Referencia rápida de archivos

| Archivo / directorio | Propósito |
|----------------------|-----------|
| `.cursor/orchestrator/instructions/*.json` | Instrucciones de Cloud (machine-readable). |
| `.cursor/orchestrator/instructions/cursor_task_*.md` | Instrucciones de Cloud para el operador en Cursor. |
| `.cursor/orchestrator/results/result_*.json` | Reportes de Cursor (avances, problemas, recomendaciones). |
| `instrucciones_cursor.md` (raíz) | Estado actual del proyecto y tareas; puede ser actualizado por Cloud o Cursor. |
| `.cursor/skills/orchestrator/cli.py` | Herramientas del orquestrador (p. ej. `mark-complete`, `status`). |

---

*Documento pensado para que un LLM entienda el protocolo Cloud–Cursor y se comporte correctamente como Orquestrador (Cloud) o como Operador (Cursor).*
