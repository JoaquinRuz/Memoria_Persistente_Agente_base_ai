# Guía de Contribución

¡Gracias por tu interés en contribuir a este repositorio de prompts para LLMs! Esta guía te ayudará a entender cómo puedes contribuir de manera efectiva.

## Formas de Contribuir

### 1. Agregar System Prompts

Si tienes system prompts de herramientas AI que no están en el repositorio:

1. **Crea una carpeta** en `system-prompts/[Nombre-Herramienta]/`
2. **Agrega los archivos** del prompt
3. **Incluye un README.md** (opcional) con:
   - Descripción de la herramienta
   - Versión del prompt
   - Fuente/origen
   - Fecha de obtención

**Ejemplo de estructura:**
```
system-prompts/
└── Nueva-Herramienta/
    ├── system-prompt.md
    ├── config.json (si aplica)
    └── README.md
```

### 2. Crear Claude Skills

Para agregar un nuevo Claude Skill:

1. **Elige la categoría apropiada** en `claude-skills/`:
   - `Development` - Herramientas de desarrollo
   - `Business` - Negocios y marketing
   - `Productivity` - Productividad
   - `Communication` - Comunicación y escritura
   - `Creative` - Contenido creativo
   - `Data-Analysis` - Análisis de datos
   - `Collaboration` - Colaboración
   - `Security` - Seguridad

2. **Crea una carpeta** con el nombre del skill: `claude-skills/[Categoría]/[nombre-skill]/`

3. **Crea el archivo SKILL.md** con el formato correcto:

```markdown
---
name: nombre-del-skill
description: Descripción clara de lo que hace este skill y cuándo usarlo
---

# Nombre del Skill

Descripción detallada del propósito y capacidades del skill.

## When to Use This Skill

- Caso de uso 1
- Caso de uso 2
- Caso de uso 3

## Instructions

[Instrucciones detalladas para Claude sobre cómo ejecutar este skill]

## Examples

[Ejemplos del mundo real mostrando el skill en acción]
```

4. **Agrega archivos adicionales** si es necesario (scripts, templates, recursos)

**Estructura de ejemplo:**
```
claude-skills/
└── Development/
    └── mi-nuevo-skill/
        ├── SKILL.md
        ├── scripts/ (opcional)
        ├── templates/ (opcional)
        └── resources/ (opcional)
```

### 3. Agregar Prompts Generales

Para prompts reutilizables generales:

1. **Elige la categoría** en `general-prompts/`:
   - `code-generation` - Generación de código
   - `documentation` - Documentación
   - `testing` - Testing
   - `refactoring` - Refactorización
   - `debugging` - Debugging
   - `code-review` - Revisión de código

2. **Crea un archivo** con nombre descriptivo: `general-prompts/[categoría]/[nombre].md`

3. **Incluye metadata** al inicio del archivo:
   - Descripción
   - Casos de uso
   - Ejemplos

**Formato sugerido:**
```markdown
# Nombre del Prompt

## Descripción
Breve descripción de para qué sirve este prompt.

## Casos de Uso
- Caso 1
- Caso 2

## Ejemplo de Uso
[Ejemplo concreto]

## Prompt
[El prompt completo aquí]
```

## Estándares de Calidad

### Para System Prompts
- ✅ Incluir la versión completa del prompt
- ✅ Mantener formato original cuando sea posible
- ✅ Documentar la fuente y fecha
- ✅ Verificar que el prompt esté completo

### Para Claude Skills
- ✅ Seguir el formato SKILL.md estándar
- ✅ Incluir ejemplos claros
- ✅ Documentar casos de uso
- ✅ Probar el skill antes de contribuir
- ✅ Incluir manejo de errores cuando sea relevante

### Para Prompts Generales
- ✅ Ser específico y claro
- ✅ Incluir ejemplos de uso
- ✅ Documentar casos de uso
- ✅ Mantener el prompt reutilizable

## Proceso de Contribución

### Opción 1: Pull Request (si el repo está en GitHub)

1. Fork el repositorio
2. Crea una rama para tu contribución: `git checkout -b mi-contribucion`
3. Realiza tus cambios
4. Valida la estructura: `./scripts/validate-structure.sh`
5. Actualiza el índice: `node scripts/generate-index.js`
6. Commit tus cambios: `git commit -m "Agregar: descripción de la contribución"`
7. Push a tu fork: `git push origin mi-contribucion`
8. Abre un Pull Request

### Opción 2: Contribución Directa

1. Agrega tus archivos en la estructura apropiada
2. Valida la estructura: `./scripts/validate-structure.sh`
3. Actualiza el índice: `node scripts/generate-index.js`
4. Commit tus cambios

## Validación

Antes de contribuir, asegúrate de:

1. **Validar la estructura:**
   ```bash
   ./scripts/validate-structure.sh
   ```

2. **Actualizar el índice:**
   ```bash
   node scripts/generate-index.js
   ```

3. **Verificar que los archivos estén bien formateados:**
   - Markdown válido
   - JSON válido (si aplica)
   - SKILL.md con frontmatter YAML válido

## Convenciones de Nombrado

### Carpetas
- Usar PascalCase para herramientas: `Devin-AI`, `Claude-Code`
- Usar kebab-case para skills: `artifacts-builder`, `file-organizer`
- Usar lowercase para categorías: `development`, `business`

### Archivos
- Usar kebab-case: `system-prompt.md`, `my-skill.md`
- Mantener extensiones apropiadas: `.md`, `.json`, `.sh`, `.js`

## Preguntas Frecuentes

### ¿Puedo agregar prompts de herramientas propietarias?
Sí, siempre que tengas permiso para compartirlos y no violen términos de servicio.

### ¿Qué pasa si un prompt está desactualizado?
Puedes actualizarlo creando una nueva versión o actualizando el existente. Documenta la versión y fecha.

### ¿Cómo sé en qué categoría poner un Claude Skill?
- Si es sobre código/desarrollo → `Development`
- Si es sobre negocios/marketing → `Business`
- Si ayuda a organizar/trabajar → `Productivity`
- Si es sobre comunicación → `Communication`
- Si es creativo/visual → `Creative`
- Si analiza datos → `Data-Analysis`
- Si facilita colaboración → `Collaboration`
- Si es sobre seguridad → `Security`

### ¿Puedo modificar prompts existentes?
Sí, pero por favor documenta los cambios y el motivo. Si es una mejora significativa, considera crear una nueva versión.

## Recursos

- [Formato de Claude Skills](https://support.claude.com/en/articles/12512198-creating-custom-skills)
- [Guía de Markdown](https://www.markdownguide.org/)
- [YAML Frontmatter](https://jekyllrb.com/docs/front-matter/)

## Contacto

Si tienes preguntas o necesitas ayuda, puedes:
- Abrir un issue en el repositorio
- Contactar a los mantenedores

---

¡Gracias por contribuir! 🎉
