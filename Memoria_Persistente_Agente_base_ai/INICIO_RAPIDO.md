# Base_AI — Inicio Rapido

> **Tiempo estimado:** 10-15 minutos
> **Resultado:** Tu agente principal configurado y operativo.

---

## Como usar esta guia

Tienes **dos opciones**:

### Opcion A: Paso a paso manual
Lee este documento de arriba a abajo y sigue cada paso.

### Opcion B: Setup interactivo con tu LLM (recomendado)
Copia el bloque de la **Seccion 7** de este documento, pegalo como primer mensaje en tu LLM favorito (Cursor, Claude, ChatGPT, etc.), y el agente te guiara interactivamente por todo el proceso.

---

## Paso 1: Verifica la estructura

Asegurate de tener la carpeta `Memoria_Persistente_Agente_base_ai/` con esta estructura minima:

```
Memoria_Persistente_Agente_base_ai/
├── README.md
├── INICIO_RAPIDO.md              ← Este archivo
├── system/
│   ├── instructivo_base.md
│   ├── llm_operating_rules.md
│   ├── interaction_contract.md
│   └── instruccion_cloud_cursor.md
└── usuario/
    ├── README.md
    └── user_identity.template.md
```

Si falta algun archivo de `system/`, clona el repo:
```bash
git clone https://github.com/JoaquinRuz/Memoria_Persistente_Agente_base_ai.git
```

**Checkpoint:** Todos los archivos de `system/` estan presentes. Continua al Paso 2.

---

## Paso 2: Crea tu identidad

Este es el paso mas importante. El agente necesita saber **quien eres** para trabajar bien.

1. Copia el archivo template:
   ```
   usuario/user_identity.template.md  →  usuario/user_identity.md
   ```

2. Abre `usuario/user_identity.md` y completa cada seccion:

### Seccion: Quien soy
Reemplaza los placeholders con tu informacion real:

```markdown
## Quien soy

**Tu Nombre** (Tu Apodo)
- Tu profesion o rol principal.
- Tus intereses principales.
- **Idiomas:** Los idiomas que manejas.

### Intereses personales
- **Deportes:** Tus deportes.
- **Tech:** Areas tech que te interesan.
- **Otros:** Otros intereses relevantes.
```

### Seccion: Preferencias Tecnicas
Define como trabajas:

```markdown
## Preferencias Tecnicas Personales

### Scripting y Automatizacion
| Area | Eleccion |
|------|----------|
| **Lenguaje Base** | Python / TypeScript / etc. |
| **Uso** | Automatizacion, web, datos, etc. |
| **Filosofia** | Tu enfoque al escribir codigo |
```

### Seccion: Principios de Trabajo
Define tus 5 principios fundamentales. Ejemplos:

```markdown
## Principios de Trabajo (Core)

1. **Claridad sobre velocidad** - Prefiero entender bien antes de actuar rapido.
2. **Automatizar lo repetitivo** - Si lo hago 3 veces, lo automatizo.
3. **Documentar decisiones** - Cada decision importante queda registrada.
4. **Iterar rapido** - MVP primero, perfeccionar despues.
5. **No reinventar la rueda** - Usar soluciones existentes antes de crear nuevas.
```

**Checkpoint:** Tu archivo `usuario/user_identity.md` esta completo con tu informacion real. Continua al Paso 3.

---

## Paso 3: Configura tu contexto de negocio (opcional)

Si trabajas para una empresa o tienes un proyecto principal, crea:

```
usuario/business_context_<nombre>.md
```

Contenido minimo:

```markdown
# Contexto de Negocio: [Nombre de tu empresa/proyecto]

## Que es
[1-2 oraciones describiendo la empresa o proyecto]

## Stack Tecnico
- **Frontend:** [React, Vue, etc.]
- **Backend:** [Node, Python, etc.]
- **Base de datos:** [PostgreSQL, MongoDB, etc.]
- **Hosting:** [Vercel, AWS, etc.]

## Estructura del proyecto
[Descripcion breve de como esta organizado el codigo]

## Reglas de negocio clave
- [Regla 1]
- [Regla 2]
- [Regla 3]
```

Si no aplica, salta este paso. Podras crearlo despues.

**Checkpoint:** Contexto de negocio creado (o decidiste saltarlo por ahora). Continua al Paso 4.

---

## Paso 4: Entiende los Context Flags

Los Context Flags son el **interruptor** del sistema. Sin ellos, el agente no arranca.

Cada sesion comienza pegando este bloque en tu LLM:

```yaml
## CONTEXT FLAGS
- domain: [tu_dominio]
- task_type: [tipo_de_tarea]
- depth: [profundidad]
- output: [formato]
- exploration: none
```

### Referencia rapida de valores:

| Flag | Valores | Cuando usar |
|------|---------|-------------|
| `domain` | `general`, `personal`, o el nombre de tu empresa | Segun el contexto de tu pregunta |
| `task_type` | `code` | Programar, debuggear, crear features |
| | `decision` | Elegir entre opciones, arquitectura, estrategia |
| | `documentation` | Crear o actualizar documentacion |
| | `analysis` | Revisar, auditar, investigar |
| `depth` | `medium` | Respuesta rapida y eficiente |
| | `deep` | Analisis exhaustivo, edge cases |
| `output` | `code` | Solo codigo, sin explicaciones |
| | `bullets` | Bullet points concisos |
| | `doc` | Markdown estructurado |
| `exploration` | `none` | Razonamiento normal (default) |
| | `tree` | Explorar multiples alternativas antes de decidir |

### Ejemplo: quieres programar una feature

```yaml
## CONTEXT FLAGS
- domain: general
- task_type: code
- depth: medium
- output: code
```

### Ejemplo: quieres tomar una decision de arquitectura

```yaml
## CONTEXT FLAGS
- domain: general
- task_type: decision
- depth: deep
- output: bullets
- exploration: tree
```

**Checkpoint:** Entiendes que son los flags y como usarlos. Continua al Paso 5.

---

## Paso 5: Tu primera sesion operativa

Ahora vas a arrancar el sistema por primera vez.

### 5.1 Carga los archivos del sistema como contexto

Dependiendo de tu herramienta:

- **Cursor:** Arrastra los archivos de `system/` y `usuario/user_identity.md` a la conversacion, o usa `@` para referenciarlos.
- **Claude:** Sube los archivos como adjuntos.
- **ChatGPT:** Copia el contenido de los archivos clave en el system prompt o primer mensaje.

**Archivos a cargar (en este orden):**
1. `system/instructivo_base.md` — El Kernel
2. `system/llm_operating_rules.md` — Los protocolos
3. `system/interaction_contract.md` — Como debe comunicarse
4. `usuario/user_identity.md` — Tu identidad

### 5.2 Envia tus Context Flags

Pega como primer mensaje:

```yaml
## CONTEXT FLAGS
- domain: general
- task_type: documentation
- depth: medium
- output: bullets
```

### 5.3 Haz tu primera pregunta

```
Confirma que tienes cargado mi contexto. Resume en 3 bullets: quien soy, que protocolos tienes activos, y como vas a responderme.
```

Si el agente responde correctamente con tu nombre, los protocolos activos y el formato de comunicacion, **el sistema esta operativo**.

**Checkpoint:** Primera sesion exitosa. El agente te reconoce y opera bajo el sistema.

---

## Paso 6: Crea tu proyecto principal (opcional)

Si quieres que el agente tenga contexto sobre un proyecto especifico:

1. Crea la carpeta:
   ```
   usuario/proyectos_adicionales_usuario/
   ```

2. Crea un archivo por proyecto:
   ```
   usuario/proyectos_adicionales_usuario/mi_proyecto.md
   ```

3. Contenido minimo:
   ```markdown
   # Proyecto: [Nombre]

   ## Objetivo
   [Que quieres lograr]

   ## Estado actual
   [En que punto esta]

   ## Stack
   [Tecnologias que usas]

   ## Proximos pasos
   - [Paso 1]
   - [Paso 2]
   ```

4. En tu siguiente sesion, carga este archivo como contexto adicional.

**Checkpoint:** Proyecto configurado. El agente tiene contexto completo de tu trabajo.

---

## Paso 7: Setup Interactivo (Opcion B)

> **Instrucciones:** Copia TODO el bloque de abajo (desde `---INICIO PROMPT---` hasta `---FIN PROMPT---`) y pegalo como **primer mensaje** en una nueva conversacion con tu LLM.
> El agente te guiara paso a paso por todo el proceso de configuracion.

```
---INICIO PROMPT---

Eres un asistente de configuracion para el sistema Base_AI (Memoria Persistente para Agentes LLM).

Tu objetivo: guiar al usuario paso a paso para configurar su sistema desde cero hasta dejarlo 100% operativo.

REGLAS DE COMPORTAMIENTO:
- Habla en espanol.
- Se directo y conciso.
- Un paso a la vez. No avances hasta que el usuario confirme que termino.
- Despues de cada paso muestra: "[Paso X de 6 completado]" y pregunta si quiere continuar.
- Si el usuario no entiende algo, explica con un ejemplo concreto.
- Nunca asumas informacion del usuario. Pregunta todo.

SECUENCIA DE PASOS:

PASO 1 - BIENVENIDA Y VERIFICACION
- Saluda brevemente.
- Pregunta: "¿Ya tienes la carpeta Memoria_Persistente_Agente_base_ai con los archivos de system/? (si/no)"
- Si NO: indica que clone el repo: git clone https://github.com/JoaquinRuz/Memoria_Persistente_Agente_base_ai.git
- Si SI: continua.

PASO 2 - CREAR IDENTIDAD (user_identity.md)
- Explica que vas a crear su archivo de identidad personal.
- Pregunta uno por uno (no todo de golpe):
  1. "¿Como te llamas? ¿Tienes un apodo o nombre corto?"
  2. "¿Cual es tu profesion o rol principal?"
  3. "¿Que idiomas manejas?"
  4. "¿Cuales son tus intereses personales? (deportes, tech, otros)"
  5. "¿Cual es tu lenguaje de programacion preferido y para que lo usas?"
  6. "¿Tienes redes sociales o web personal que quieras incluir? (opcional)"
  7. "Dame 3-5 principios de trabajo que te definan. Por ejemplo: 'Claridad sobre velocidad', 'Automatizar lo repetitivo'."
- Con las respuestas, genera el archivo user_identity.md completo y listo para copiar.
- Indica: "Copia este contenido y guardalo como usuario/user_identity.md"

PASO 3 - CONTEXTO DE NEGOCIO (opcional)
- Pregunta: "¿Trabajas para una empresa o tienes un proyecto principal? (si/no)"
- Si SI: pregunta nombre, stack tecnico, y 3 reglas de negocio clave. Genera el archivo business_context.
- Si NO: "Sin problema, puedes crearlo despues. Continuamos."

PASO 4 - ENTENDER CONTEXT FLAGS
- Explica en 3 oraciones que son los Context Flags y por que importan.
- Muestra la tabla de valores posibles.
- Pide al usuario que cree su primer bloque de flags para un escenario real:
  "Piensa en la tarea mas comun que haces con un LLM. ¿Que seria? Yo te ayudo a armar los flags."
- Genera el bloque de flags y explica cada eleccion.

PASO 5 - PRIMERA SESION OPERATIVA
- Indica que archivos cargar como contexto (instructivo_base.md, llm_operating_rules.md, interaction_contract.md, user_identity.md).
- Genera el mensaje de primera sesion:
  "Pega tus Context Flags seguido de: 'Confirma que tienes mi contexto cargado. Resume quien soy, protocolos activos, y formato de comunicacion.'"
- Explica que esperar: el agente debe reconocerlo y operar bajo el sistema.

PASO 6 - RESUMEN Y PROXIMOS PASOS
- Resume todo lo que se configuro.
- Lista los archivos creados.
- Sugiere: "Tu siguiente paso seria crear un proyecto en usuario/proyectos_adicionales_usuario/ con el contexto de lo que estes trabajando."
- Cierra con: "Tu sistema Base_AI esta operativo. Cada nueva sesion, carga los archivos de system/ y tu user_identity.md, pega tus Context Flags, y el agente operara bajo tu sistema personalizado."

COMIENZA AHORA con el Paso 1.

---FIN PROMPT---
```

---

## Resumen: Que tienes despues de completar esta guia

| Archivo | Estado |
|---------|--------|
| `system/instructivo_base.md` | Listo (viene con el repo) |
| `system/llm_operating_rules.md` | Listo (viene con el repo) |
| `system/interaction_contract.md` | Listo (viene con el repo) |
| `usuario/user_identity.md` | Creado por ti |
| `usuario/business_context_*.md` | Opcional, creado si aplica |
| `usuario/proyectos_adicionales_usuario/` | Opcional, para tus proyectos |

Tu agente principal:
- Te reconoce por nombre
- Sabe tu contexto de trabajo
- Opera bajo protocolos deterministas (CoVe, ReAct, etc.)
- Respeta tu formato de comunicacion preferido
- Se detiene ante dudas en lugar de improvisar

---

## Problemas comunes

| Problema | Solucion |
|----------|----------|
| El agente no me reconoce | Verifica que cargaste `user_identity.md` como contexto |
| El agente responde sin estructura | Asegurate de incluir Context Flags al inicio |
| El agente improvisa respuestas | Verifica que `instructivo_base.md` y `llm_operating_rules.md` estan cargados |
| No se como elegir flags | Usa la tabla de referencia del Paso 4 o pide ayuda al agente |
| Quiero cambiar de tarea a mitad de sesion | Envia un nuevo bloque de Context Flags con los valores actualizados |

---

**Version**: 1.0
**Compatible con**: Cursor, Claude, ChatGPT, y cualquier LLM que acepte contexto largo.
