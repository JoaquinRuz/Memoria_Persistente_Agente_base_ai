# Integración MemPalace + Sistema Matrix

> **Fecha:** 2026-02-28
> **Versión MemPalace:** v3.0.0 (commit main, 23.5k stars)
> **Auditoría de seguridad:** APROBADA (ver sección 6)

---

## 1. Qué es MemPalace y por qué se integra

MemPalace es un sistema de memoria vectorial local para LLMs:
- **96.6% recall** en LongMemEval (R@5, modo raw, zero API calls)
- 100% local, sin cloud, sin API keys
- ChromaDB como motor de búsqueda semántica
- Arquitectura palace: wings → rooms → closets → drawers
- Knowledge graph temporal (SQLite)
- 19 herramientas MCP para agentes

**Complementa** el sistema Matrix existente (reglas estáticas + context flags) con **memoria dinámica semántica** que persiste entre sesiones.

---

## 2. Arquitectura combinada

```
┌─────────────────────────────────────────────────────┐
│  SISTEMA MATRIX (Reglas + Identidad)                │
│  ├── instructivo_base.md    ← Contrato de ejecución │
│  ├── llm_operating_rules.md ← Protocolos            │
│  ├── interaction_contract.md ← Estilo comunicación   │
│  └── context_flags.md       ← Control de sesión     │
│                                                     │
│  ↕ Memory Injection (Boot Sequence paso 2.3)        │
│                                                     │
│  MEMPALACE (Memoria Dinámica Semántica)             │
│  ├── L0: identity.txt       ← Quién soy (~100 tok) │
│  ├── L1: Essential Story    ← Top memorias (~500t)  │
│  ├── L2: On-Demand          ← Por wing/room         │
│  └── L3: Deep Search        ← Búsqueda semántica    │
│                                                     │
│  Wings configuradas:                                │
│  ├── wing_matrix     (este sistema)                 │
│  ├── wing_promosmart (negocio principal)            │
│  ├── wing_financial  (inversiones)                  │
│  ├── wing_solefrutti (proyecto agrícola)            │
│  ├── wing_joaquin    (identidad personal)           │
│  └── wing_orchestration (automatización)            │
└─────────────────────────────────────────────────────┘
```

### Mapeo de conceptos

| Matrix (actual)                    | MemPalace (nuevo)                        |
|------------------------------------|------------------------------------------|
| `usuario/user_identity.md`         | `L0 identity.txt` (siempre cargado)      |
| `context_flags.md`                 | No reemplazado — flags siguen controlando sesión |
| `business_context_*.md`            | `wing_promosmart` / `wing_financial`     |
| Memoria histórica (peso 0.3)       | `L1 + L2 + L3` (búsqueda semántica)     |
| Proyectos adicionales              | Wings dedicadas por proyecto             |

---

## 3. Instalación rápida

```bash
# Opción A: Ejecutar bootstrap automático
cd Memoria_Persistente_Agente_base_ai/system/mempalace_config
./bootstrap_palace.sh

# Opción B: Manual paso a paso
pip install mempalace
cp system/mempalace_config/config.json ~/.mempalace/config.json
cp system/mempalace_config/wing_config.json ~/.mempalace/wing_config.json
cp system/mempalace_config/identity.txt ~/.mempalace/identity.txt

# Minar datos existentes
mempalace mine system/ --wing wing_matrix
mempalace mine usuario/ --wing wing_joaquin
```

---

## 4. Uso diario

### Desde CLI
```bash
mempalace search "por qué elegimos GraphQL"
mempalace search "decisiones de auth" --wing wing_matrix
mempalace wake-up                          # Carga L0+L1 (~170 tokens)
mempalace status                           # Estado del palace
```

### Desde Cursor (MCP)
```bash
# Agregar como MCP server en Cursor
# En settings, MCP servers:
python -m mempalace.mcp_server
```

El agente de Cursor tendrá acceso a las 19 herramientas automáticamente:
- `mempalace_search` — búsqueda semántica
- `mempalace_add_drawer` — guardar memoria nueva
- `mempalace_kg_query` — consultar knowledge graph
- `mempalace_status` — estado del palace

### Desde Python
```python
from mempalace.layers import MemoryStack

stack = MemoryStack()
print(stack.wake_up())                           # L0 + L1
print(stack.search("auth migration decisions"))  # L3 deep search
print(stack.recall(wing="wing_promosmart"))      # L2 on-demand
```

---

## 5. Alimentar el palace

### Minar proyectos (código, docs, notas)
```bash
mempalace mine ~/ruta/proyecto --wing wing_nombre
```

### Minar conversaciones (Claude, ChatGPT, Slack)
```bash
mempalace mine ~/chats/ --mode convos
mempalace mine ~/chats/ --mode convos --extract general  # clasifica automáticamente
```

### Desde agente (MCP tool)
El agente puede usar `mempalace_add_drawer` para guardar decisiones, descubrimientos y hechos durante la conversación.

---

## 6. Auditoría de seguridad (2026-02-28)

| Aspecto                          | Estado     | Detalle |
|----------------------------------|------------|---------|
| Shell injection hooks (#110)     | CORREGIDO  | `$TRANSCRIPT_PATH` via `sys.argv` |
| Path traversal SESSION_ID (#121) | CORREGIDO  | Sanitizado con `tr -cd` |
| Dependencias                     | OK         | chromadb + pyyaml únicamente |
| Red/Cloud                        | NINGUNA    | 100% local |
| Credenciales                     | NINGUNA    | No maneja secrets |
| Licencia                         | MIT        | Permisiva |

---

## 7. Modificación al Boot Sequence

El paso 2.3 del `instructivo_base.md` (Memory Injection) se extiende:

```
Orden de carga con MemPalace:
1. usuario/user_identity.md        (peso 1.0)  ← ya existente
2. system/interaction_contract.md  (peso 1.0)  ← ya existente
3. system/llm_operating_rules.md   (peso 1.0)  ← ya existente
4. MemPalace L0 (identity.txt)     (peso 0.9)  ← NUEVO
5. MemPalace L1 (essential story)  (peso 0.8)  ← NUEVO
6. Contexto de dominio             (peso 0.8)  ← ya existente
7. Proyecto activo                 (peso 0.7)  ← ya existente
8. MemPalace L2/L3 (on-demand)    (peso 0.5)  ← NUEVO (bajo demanda)
9. Memoria histórica               (peso 0.3)  ← ya existente
```

**Regla:** FLAGS > MATRIX RULES > MEMPALACE. MemPalace complementa, no sobreescribe.

---

## 8. Estructura de archivos

```
Memoria_Persistente_Agente_base_ai/
├── INICIO_RAPIDO.md                    ← Incluye sección MemPalace obligatoria
├── INTEGRACION_MEMPALACE.md            ← Este archivo
├── system/
│   ├── instructivo_base.md             ← Sección 3: MemPalace obligatorio
│   ├── interaction_contract.md
│   ├── llm_operating_rules.md
│   ├── llms_prompts/
│   ├── mempalace/                      ← Repositorio clonado (v3.0.13)
│   │   ├── mempalace/                  ← Core package Python
│   │   ├── hooks/                      ← Auto-save hooks
│   │   ├── benchmarks/                 ← Runners reproducibles
│   │   ├── examples/                   ← Guías de uso
│   │   └── pyproject.toml
│   └── mempalace_config/               ← Config personalizada
│       ├── config.json                 ← Config global del palace
│       ├── wing_config.json            ← Mapeo de wings a proyectos
│       ├── identity.txt                ← Layer 0 personalizado
│       └── bootstrap_palace.sh         ← Script de inicialización
└── usuario/
```
