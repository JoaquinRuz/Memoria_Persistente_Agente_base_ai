# Base_AI — Sistema Operativo para Agentes LLM

> Un framework de reglas, protocolos y memoria persistente que convierte cualquier LLM en un agente determinista, auditable y gobernable.

## Qué es esto

**Base_AI** es un sistema operativo para agentes LLM. No es código — es un conjunto estructurado de documentos que define:

- **Cómo** debe pensar el agente (protocolos obligatorios)
- **Qué** puede hacer (gobernado por Context Flags)
- **Cuándo** debe detenerse (Failure Mode, Governor)
- **Para quién** trabaja (identidad y contexto del usuario)

El agente no actúa libremente. **Opera bajo sistema.**

## Principios de Diseño

| Principio | Descripción |
|-----------|-------------|
| **Determinismo** | Mismos flags → mismo comportamiento. Sin ambigüedad. |
| **Gobernabilidad** | Todo pasa por el Governor (Execution Priority Stack). |
| **Fail-safe** | Ante duda, detener y preguntar. Nunca improvisar. |
| **Auditabilidad** | Protocolos explícitos (CoVe, ReAct, ToT) con pasos trazables. |

## Estructura del Proyecto

```
base_ai/
├── README.md                          ← Este archivo
├── .gitignore
│
├── system/                            ← Kernel del sistema (obligatorio)
│   ├── instructivo_base.md            ← Boot Sequence y reglas core
│   ├── llm_operating_rules.md         ← Protocolos ejecutables (CoVe, ReAct, ToT, etc.)
│   ├── interaction_contract.md        ← Cómo debe comunicarse el agente
│   ├── instruccion_cloud_cursor.md    ← Protocolo Cloud↔Cursor (orquestación)
│   └── llms_prompts/                  ← Colección de system prompts y skill packs
│       ├── claude-skills/             ← Skills organizados por categoría
│       ├── system-prompts/            ← System prompts de referencia (Cursor, Claude, etc.)
│       └── ...
│
└── usuario/                           ← Contexto personal (NO versionado, ver abajo)
    ├── README.md                      ← Guía de configuración (versionado)
    ├── user_identity.template.md      ← Template de identidad (versionado)
    └── ... (archivos personales)
```

## Protocolos Implementados

| Protocolo | Tipo | Trigger |
|-----------|------|---------|
| **Memory Injection** | Kernel | Inicio de sesión |
| **Context Flags** | Kernel | Obligatorio siempre (Cold Start si faltan) |
| **Chain of Verification (CoVe)** | Kernel | `task_type=decision/analysis` |
| **Constraint Cascade + Reflexion** | Kernel | Tareas multi-paso |
| **ReAct** | Kernel | Agente con herramientas |
| **Output Lock** | Kernel | Flag `output` presente |
| **Tree of Thoughts (ToT)** | Skill Pack | Flag `exploration: tree` |
| **Role Stacking** | Protocolo | Decisiones estratégicas |

## Context Flags (Boot)

Cada sesión comienza con un bloque obligatorio:

```yaml
## CONTEXT FLAGS
- domain: [promosmart | personal | general]
- task_type: [code | decision | documentation | analysis]
- depth: [medium | deep]
- output: [code | bullets | doc]
- exploration: [none | tree]  # opcional
```

Sin flags, el agente se detiene. No hay inferencia.

## Carpeta `usuario/` — Datos Personales

La carpeta `usuario/` contiene la identidad, contexto de negocio y proyectos del operador. **Estos archivos NO se suben a git** porque contienen información personal.

Para configurar tu propia instancia:

1. Copia `usuario/user_identity.template.md` → `usuario/user_identity.md`
2. Completa con tu información
3. Crea los archivos adicionales según tu contexto (business context, proyectos, etc.)

Ver [`usuario/README.md`](usuario/README.md) para la estructura completa.

## Cómo usar

> **Primera vez?** Abre [`INICIO_RAPIDO.md`](INICIO_RAPIDO.md) para una guía paso a paso con setup interactivo.

1. **Clona** el repo
2. **Configura** tu carpeta `usuario/` (ver instrucciones arriba)
3. **Carga** los archivos de `system/` como contexto en tu LLM favorito
4. **Inicia sesión** con Context Flags
5. El agente operará bajo el sistema definido

## Colección de Prompts y Skills

El directorio `system/llms_prompts/` incluye:

- **System prompts** de referencia de herramientas populares (Cursor, Claude Code, Windsurf, v0, Lovable, Devin, etc.)
- **Claude Skills** organizados por categoría (Business, Creative, Development, Productivity)
- **Scripts** de utilidad para gestión del catálogo

## Técnicas AI Integradas

El sistema implementa (con adaptaciones) investigación publicada:

- **CoVe** — Chain of Verification (Dhuliawala et al.)
- **ToT** — Tree of Thoughts (Yao et al., 2023)
- **ReAct** — Reasoning + Acting (Yao et al., 2022)
- **Reflexion** — Verbal Reinforcement Learning (Shinn et al., 2023)

Documentación técnica completa en los archivos de `system/`.

---

**Versión**: 1.0  
**Licencia**: MIT
