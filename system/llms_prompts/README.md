# Repositorio de Prompts para LLMs

Un repositorio centralizado y organizado de prompts para diferentes modelos de lenguaje (LLMs), incluyendo system prompts de herramientas AI, Claude Skills, y prompts generales reutilizables.

## 📑 Tabla de Contenidos

- [Estructura del Repositorio](#estructura-del-repositorio)
- [System Prompts](#system-prompts)
- [Claude Skills](#claude-skills)
- [Prompts Generales](#prompts-generales)
- [Cómo Usar](#cómo-usar)
- [Acceso Directo a Prompts](#acceso-directo-a-prompts)
- [Contribuir](#contribuir)

## Estructura del Repositorio

Este repositorio está organizado en tres categorías principales:

```
llms_prompts/
├── system-prompts/      # System prompts de herramientas AI
├── claude-skills/       # Claude Skills (formato SKILL.md)
├── general-prompts/     # Prompts generales reutilizables
└── scripts/             # Scripts de utilidad
```

## System Prompts

System prompts extraídos de diferentes herramientas AI. Cada carpeta contiene los prompts específicos de esa herramienta.

### Herramientas Disponibles

- **[Cursor](./system-prompts/Cursor/)** - System prompts de Cursor AI
- **[Devin AI](./system-prompts/Devin-AI/)** - System prompts de Devin AI
- **[Claude Code](./system-prompts/Claude-Code/)** - System prompts de Claude Code
- **[Windsurf](./system-prompts/Windsurf/)** - System prompts de Windsurf
- **[v0](./system-prompts/v0/)** - Prompts y herramientas de v0
- **[Replit](./system-prompts/Replit/)** - System prompts de Replit
- **[VSCode Agent](./system-prompts/VSCode-Agent/)** - System prompts de VSCode Agent
- **[Trae](./system-prompts/Trae/)** - System prompts de Trae AI
- **[Perplexity](./system-prompts/Perplexity/)** - System prompts de Perplexity
- **[Cluely](./system-prompts/Cluely/)** - System prompts de Cluely
- **[Xcode](./system-prompts/Xcode/)** - System prompts de Xcode
- **[NotionAI](./system-prompts/NotionAI/)** - System prompts de Notion AI
- **[Orchids](./system-prompts/Orchids/)** - System prompts de Orchids.app
- **[Junie](./system-prompts/Junie/)** - System prompts de Junie
- **[Kiro](./system-prompts/Kiro/)** - System prompts de Kiro
- **[Warp](./system-prompts/Warp/)** - System prompts de Warp.dev
- **[Z.ai Code](./system-prompts/Z-ai-Code/)** - System prompts de Z.ai Code
- **[Qoder](./system-prompts/Qoder/)** - System prompts de Qoder
- **[Augment Code](./system-prompts/Augment-Code/)** - System prompts de Augment Code
- **[Lovable](./system-prompts/Lovable/)** - System prompts de Lovable
- **[Same.dev](./system-prompts/Same-dev/)** - System prompts de Same.dev
- **[CodeBuddy](./system-prompts/CodeBuddy/)** - System prompts de CodeBuddy
- **[Comet](./system-prompts/Comet/)** - System prompts de Comet Assistant
- **[Manus](./system-prompts/Manus/)** - System prompts de Manus Agent
- **[Open Source](./system-prompts/Open-Source/)** - Prompts de herramientas open source

## Claude Skills

Claude Skills organizados por categoría. Cada skill es una carpeta con un archivo `SKILL.md` que contiene las instrucciones completas.

### Categorías

#### Development
- **[Artifacts Builder](./claude-skills/Development/artifacts-builder/)** - Crea artefactos HTML complejos con React, Tailwind CSS, shadcn/ui
- **[Changelog Generator](./claude-skills/Development/changelog-generator/)** - Genera changelogs automáticamente desde commits de git
- **[MCP Builder](./claude-skills/Development/mcp-builder/)** - Guía para crear servidores MCP de alta calidad

#### Business
- **[Brand Guidelines](./claude-skills/Business/brand-guidelines/)** - Aplica colores y tipografía oficiales de Anthropic
- **[Competitive Ads Extractor](./claude-skills/Business/competitive-ads-extractor/)** - Extrae y analiza anuncios de competidores
- **[Domain Name Brainstormer](./claude-skills/Business/domain-name-brainstormer/)** - Genera ideas de nombres de dominio y verifica disponibilidad
- **[Lead Research Assistant](./claude-skills/Business/lead-research-assistant/)** - Identifica y califica leads de alta calidad

#### Productivity
- **[File Organizer](./claude-skills/Productivity/file-organizer/)** - Organiza archivos y carpetas inteligentemente
- **[Invoice Organizer](./claude-skills/Productivity/invoice-organizer/)** - Organiza facturas y recibos para preparación de impuestos

#### Communication
- **[Content Research Writer](./claude-skills/Communication/content-research-writer/)** - Asiste en escribir contenido de alta calidad con investigación
- **[Meeting Insights Analyzer](./claude-skills/Communication/meeting-insights-analyzer/)** - Analiza transcripciones de reuniones para descubrir patrones

#### Creative
- **[Canvas Design](./claude-skills/Creative/canvas-design/)** - Crea arte visual en PNG y PDF
- **[Image Enhancer](./claude-skills/Creative/image-enhancer/)** - Mejora calidad de imágenes y screenshots
- **[Theme Factory](./claude-skills/Creative/theme-factory/)** - Aplica temas profesionales de fuentes y colores

#### Data Analysis
- **[CSV Data Summarizer](./claude-skills/Data-Analysis/csv-data-summarizer/)** - Analiza archivos CSV y genera insights con visualizaciones

#### Collaboration
- **[Git Pushing](./claude-skills/Collaboration/git-pushing/)** - Automatiza operaciones git y interacciones con repositorios

#### Security
- **[Computer Forensics](./claude-skills/Security/computer-forensics/)** - Análisis de forensia digital e investigación

## Prompts Generales

Prompts reutilizables para tareas comunes de desarrollo y programación.

### Categorías

- **[Code Generation](./general-prompts/code-generation/)** - Prompts para generación de código
- **[Documentation](./general-prompts/documentation/)** - Prompts para documentación
- **[Testing](./general-prompts/testing/)** - Prompts para testing
- **[Refactoring](./general-prompts/refactoring/)** - Prompts para refactorización
- **[Debugging](./general-prompts/debugging/)** - Prompts para debugging
- **[Code Review](./general-prompts/code-review/)** - Prompts para revisión de código

## Cómo Usar

### Usar System Prompts

1. Navega a la carpeta de la herramienta que te interesa
2. Copia el contenido del prompt que necesites
3. Úsalo directamente en tu herramienta o como referencia

### Usar Claude Skills

#### En Claude.ai
1. Ve a Settings → Skills
2. Sube la carpeta del skill que quieres usar
3. El skill se activará automáticamente cuando sea relevante

#### En Claude Code
1. Copia la carpeta del skill a `~/.config/claude-code/skills/`
2. Inicia Claude Code
3. El skill se cargará automáticamente

#### Via API
```python
import anthropic

client = anthropic.Anthropic(api_key="your-api-key")

response = client.messages.create(
    model="claude-3-5-sonnet-20241022",
    skills=["skill-id-here"],
    messages=[{"role": "user", "content": "Your prompt"}]
)
```

### Usar Prompts Generales

1. Navega a la categoría relevante
2. Selecciona el prompt que necesitas
3. Copia y adapta según tus necesidades

## Acceso Directo a Prompts

Este repositorio incluye un archivo `INDEX.json` que permite acceso programático a todos los prompts. Puedes usar este índice para:

- Buscar prompts específicos
- Integrar con herramientas externas
- Generar documentación automática
- Compartir enlaces directos a prompts específicos

Para actualizar el índice automáticamente:

```bash
node scripts/generate-index.js
```

## Contribuir

¡Las contribuciones son bienvenidas! Por favor lee [CONTRIBUTING.md](./CONTRIBUTING.md) para más detalles sobre cómo contribuir.

### Formas de Contribuir

1. Agregar nuevos system prompts de herramientas AI
2. Crear nuevos Claude Skills
3. Agregar prompts generales útiles
4. Mejorar documentación
5. Reportar errores o sugerir mejoras

## Fuentes

Este repositorio incluye contenido de:

- [system-prompts-and-models-of-ai-tools](https://github.com/x1xhlol/system-prompts-and-models-of-ai-tools) - System prompts de herramientas AI
- [awesome-claude-skills](https://github.com/ComposioHQ/awesome-claude-skills) - Claude Skills

## Licencia

Este repositorio está bajo la licencia GPL-3.0. Los prompts individuales pueden tener licencias diferentes - por favor revisa cada carpeta para información específica de licencia.

---

⭐ **Si encuentras esto útil, ¡considera dar una estrella al repositorio!**
