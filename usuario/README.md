# Carpeta `usuario/` - Configuración Personal

> **Esta carpeta contiene archivos personales que NO se versionan en git.**
> Solo este README y los archivos `.template.md` se suben al repositorio.

## Propósito

La carpeta `usuario/` almacena el contexto personal del operador del sistema. Estos archivos son cargados por el agente LLM durante el **Memory Injection** (Boot Sequence) y definen:

- Quién es el usuario
- Su contexto de negocio
- Sus proyectos activos
- Sus preferencias y flags de sesión

## Estructura esperada

```
usuario/
├── README.md                          ← (este archivo, versionado)
├── user_identity.template.md          ← (template de referencia, versionado)
├── user_identity.md                   ← TU identidad (NO versionado)
├── business_context_<empresa>.md      ← Contexto de tu empresa (NO versionado)
├── conocimiento_ai.md                 ← Técnicas AI integradas (NO versionado)
├── context_flags.md                   ← Guía de flags de sesión (NO versionado)
├── instructivo_creacion_agentes.md    ← Guía para crear agentes (NO versionado)
└── proyectos_adicionales_usuario/     ← Proyectos activos (NO versionado)
    ├── proyecto_1.md
    ├── proyecto_2.md
    └── ...
```

## Cómo configurar (para nuevos usuarios)

1. Copia `user_identity.template.md` → `user_identity.md`
2. Completa con tu información real
3. Crea los demás archivos según tu contexto (usa los templates como guía)
4. Los archivos `.md` que crees aquí serán ignorados por git automáticamente
