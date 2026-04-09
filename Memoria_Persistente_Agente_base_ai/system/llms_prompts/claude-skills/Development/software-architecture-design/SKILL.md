---
name: software-architecture-design
description: >-
  Arquitecto pragmático de software: diseña sistemas correctamente dimensionados para las
  necesidades actuales. Define límites de dominio claros, flujos de datos explícitos,
  estructuras observables y manejo de fallos. Detecta anti-patrones (over-engineering,
  abstraction theater, microservicios prematuros). Aplica principios de dependencia
  unidireccional, diseño failure-aware, trazabilidad con correlation IDs, y criterios
  objetivos para transición monolito → servicios. Usar al diseñar arquitectura inicial,
  refactorizar código legado, definir modelos de datos, o decidir límites entre dominios.
source: https://mcpmarket.com/es/tools/skills/system-architecture
---

# Software Architecture Design — Arquitecto Pragmático

> Principio rector: **El mejor sistema es el más simple que resuelve el problema actual.**  
> No se diseña para el futuro imaginado. Se diseña para el problema real de hoy,  
> con capacidad de cambio sin dolor.

---

## 1. Filosofía de Diseño

### 1.1 Right-Sizing (Dimensionamiento correcto)

El sistema debe ser **tan grande como necesita ser, y no más**:

| Señal | Respuesta correcta |
|-------|--------------------|
| Equipo de 1-5 personas | Monolito modular, NO microservicios |
| < 10k usuarios | Un solo proceso, base de datos única |
| Un dominio bien entendido | Módulos internos, NO servicios separados |
| Múltiples equipos con deploys independientes | Considerar separación de servicios |
| Dominios con ciclos de vida muy diferentes | Evaluar separación |

### 1.2 Principio de Complejidad Diferida

```
Regla: No agregar complejidad hasta que el costo de NO tenerla
       sea mayor que el costo de implementarla.

Correcto: Empezar simple → crecer cuando el dolor sea real
Incorrecto: Diseñar para "cuando seamos 10x más grandes"
```

---

## 2. Estructura de Dominios y Límites

### 2.1 Definición de Bounded Contexts

Un **Bounded Context** es un límite donde un modelo de dominio es válido y consistente:

```text
CRITERIOS PARA SEPARAR DOMINIOS:
✓ Diferentes equipos de ownership
✓ Datos que cambian con frecuencias muy distintas
✓ Reglas de negocio que no se cruzan
✓ Diferentes ciclos de release
✓ Necesidades de escalado radicalmente distintas

CRITERIOS QUE NO JUSTIFICAN SEPARACIÓN:
✗ "Podría crecer"
✗ "Se ve bien en el diagrama"
✗ "Es la arquitectura de Netflix"
✗ "Queremos usar tecnología X en ese módulo"
```

### 2.2 Mapa de Contextos

```
┌─────────────────────────────────────────────────────────┐
│  DOMINIO CENTRAL (Core Domain)                          │
│  → Lo que hace único a tu negocio                       │
│  → Máxima inversión en diseño                           │
├─────────────────────────────────────────────────────────┤
│  DOMINIOS DE SOPORTE (Supporting Domains)               │
│  → Necesarios pero no diferenciadores                   │
│  → Considerar soluciones existentes primero             │
├─────────────────────────────────────────────────────────┤
│  DOMINIOS GENÉRICOS (Generic Domains)                   │
│  → Autenticación, notificaciones, pagos                 │
│  → Usar servicios externos/SaaS cuando sea posible      │
└─────────────────────────────────────────────────────────┘
```

---

## 3. Dirección de Dependencias

### 3.1 Regla de Dependencia

```
DIRECCIÓN PERMITIDA:
  Infraestructura → Aplicación → Dominio Core
  (Las capas externas dependen de las internas, NUNCA al revés)

VIOLACIÓN:
  Core Domain importa de infraestructura ← ✗ NUNCA
  Lógica de negocio depende de ORM ← ✗ NUNCA
  Módulo de auth depende de módulo de pedidos ← ✗ REVISAR
```

### 3.2 Capas y su contenido

```
┌──────────────────────────────────────────┐
│  INFRASTRUCTURE (externa)                │
│  → DB drivers, HTTP clients, Email       │
│  → Adapters e implementaciones           │
├──────────────────────────────────────────┤
│  APPLICATION                             │
│  → Use cases, servicios de aplicación    │
│  → Orquestación de dominio               │
├──────────────────────────────────────────┤
│  DOMAIN (centro, sin dependencias)       │
│  → Entidades, Value Objects              │
│  → Reglas de negocio, eventos de dominio │
│  → Interfaces (ports) para infraestructura│
└──────────────────────────────────────────┘
```

---

## 4. Modelos de Datos

### 4.1 Principios de Modelado

```text
PRINCIPIOS:
1. Los datos reflejan el dominio, no la infraestructura
2. Preferir datos explícitos sobre implícitos
3. Evitar null cuando un tipo suma (union type) es posible
4. Los IDs son del dominio, no del storage
5. Separar datos de lectura (queries) de escritura (commands) cuando el volumen lo justifica
```

### 4.2 Patrones de Modelos de Datos

**Entidad**: Identidad propia, muta en el tiempo
```typescript
// Entidad: tiene ID único y ciclo de vida propio
type Order = {
  id: OrderId          // ID del dominio, no DB
  status: OrderStatus  // enum explícito, no string libre
  items: OrderItem[]
  createdAt: Date
  updatedAt: Date
}
```

**Value Object**: Sin identidad, inmutable, describe características
```typescript
// Value Object: igualdad por valor, no por referencia
type Money = {
  amount: number    // en centavos, siempre entero
  currency: 'CLP' | 'USD' | 'EUR'
}
```

**Aggregate**: Unidad de consistencia transaccional
```typescript
// El Aggregate Root es la única entrada al grupo
// Nada externo modifica entidades internas directamente
type Cart = {
  id: CartId
  items: CartItem[]        // solo se modifica vía Cart.addItem()
  appliedCoupons: Coupon[] // solo vía Cart.applyCoupon()
}
```

### 4.3 Flujos de Datos Explícitos

```
REGLA: Cada dato tiene un origen claro y un flujo trazable

Correcto:
  UserRegistered(event) → SendWelcomeEmail(handler) → EmailSent(result)

Incorrecto:
  user.save() → "algo manda el email en algún lado"

HERRAMIENTA: Diagrama de flujo de datos para cada feature crítica
  Input → Transformación → Storage → Output
```

---

## 5. Manejo de Fallos (Failure-Aware Design)

### 5.1 Diseño desde el fallo

```text
PRINCIPIO: El fallo no es una excepción, es un ciudadano de primera clase.

Para cada operación crítica, definir ANTES de implementar:
1. ¿Qué falla aquí? (red, timeout, datos inválidos, dependencia caída)
2. ¿Cuál es la consecuencia del fallo?
3. ¿Cómo se detecta?
4. ¿Cómo se recupera? (retry, compensación, degradación, alerta)
```

### 5.2 Patrones de Compensación

```
OPERACIONES DISTRIBUIDAS — Saga Pattern:
  Paso 1: Reservar stock         → Compensación: Liberar stock
  Paso 2: Procesar pago          → Compensación: Reembolsar pago
  Paso 3: Confirmar pedido       → Compensación: Cancelar pedido

Si Paso 2 falla:
  → Ejecutar compensación de Paso 1 (Liberar stock)
  → NUNCA dejar el sistema en estado parcialmente comprometido
```

### 5.3 Niveles de Degradación

```
Nivel 1 — Servicio completo:    Todo funciona normalmente
Nivel 2 — Feature degradada:    Función secundaria desactivada (cache viejo, etc.)
Nivel 3 — Modo esencial:        Solo operaciones críticas del negocio
Nivel 4 — Read-only:            Solo lectura, sin escrituras
Nivel 5 — Offline/Mantenimiento: Página de estado con ETA
```

### 5.4 Circuit Breaker

```
ESTADOS:
  Closed   → Operación normal
  Open     → Fallo detectado, rechazar requests inmediatamente
  Half-Open → Probar si el servicio se recuperó

UMBRALES TÍPICOS:
  threshold: 5 fallos en 60 segundos → Open
  timeout: 30 segundos en Open → Half-Open
  success: 2 éxitos consecutivos en Half-Open → Closed
```

---

## 6. Observabilidad

### 6.1 Los tres pilares

```
LOGS    → Qué pasó (eventos discretos)
METRICS → Cuánto / qué tan rápido (valores numéricos en el tiempo)
TRACES  → Por qué pasó (contexto de un request completo)
```

### 6.2 Correlation IDs (obligatorio en sistemas distribuidos)

```typescript
// SIEMPRE propagar correlation_id desde el request inicial
type RequestContext = {
  correlationId: string    // UUID generado en el edge, propagado a todo
  traceId: string          // Para distributed tracing
  userId?: string          // Si hay auth
  sessionId?: string
}

// Todo log debe incluir el contexto
logger.info('order.created', {
  correlationId: ctx.correlationId,
  orderId: order.id,
  userId: ctx.userId,
  duration_ms: elapsed
})
```

### 6.3 SLIs/SLOs básicos

```
DEFINIR ANTES de producción:
  - Latencia P99 aceptable (ej: < 500ms)
  - Tasa de error aceptable (ej: < 0.1%)
  - Disponibilidad objetivo (ej: 99.9%)
  - Alertas automáticas cuando se rompen
```

---

## 7. Anti-Patrones — Detección y Solución

### 7.1 Over-Engineering / Abstraction Theater

```
SEÑALES:
  ✗ "Hagamos una interfaz para esto aunque solo haya una implementación"
  ✗ "Un factory que devuelve singletons a través de un registry"
  ✗ "Necesitamos un framework de plugins para esto"
  ✗ Más de 4 capas de abstracción para un CRUD simple

SOLUCIÓN:
  → Yagni (You Aren't Gonna Need It)
  → Implementar la cosa más simple que funcione
  → Refactorizar cuando el dolor sea REAL, no imaginado
```

### 7.2 Microservicios Prematuros

```
SEÑALES:
  ✗ Equipo de 1-3 personas con 8+ servicios
  ✗ Servicios que siempre se despliegan juntos
  ✗ Servicios que comparten base de datos
  ✗ Llamadas síncronas en cadena de 4+ servicios para una operación
  ✗ "Nuestro monolito tiene problemas, hagamos microservicios"

SOLUCIÓN:
  → Primero: Monolito bien modularizado
  → Separar solo cuando: equipos distintos, deploys distintos, escala distinta
  → El problema no es el monolito, es el monolito mal organizado
```

### 7.3 God Objects / Feature Envy

```
SEÑALES:
  ✗ Una clase/módulo de 2000+ líneas que "lo hace todo"
  ✗ Un módulo que accede constantemente a datos de otro módulo
  ✗ Un service que importa 15+ otros servicios

SOLUCIÓN:
  → Single Responsibility Principle aplicado con criterio
  → Si el módulo B "envidia" datos de A, quizás esa lógica pertenece a A
  → Dividir por responsabilidades de negocio, no por capas técnicas
```

### 7.4 Repositorio Innecesario

```
SEÑALES:
  ✗ Repository que solo wrappea el ORM sin lógica propia
  ✗ UserRepository con 40 métodos findByXxx

SOLUCIÓN:
  → Si el ORM ya es una abstracción suficiente, usarlo directamente
  → Repositorios solo cuando necesitas aislar la infraestructura de storage
  → Query objects para consultas complejas, no 40 métodos
```

---

## 8. Decisión: Monolito → Servicios

### 8.1 Framework de decisión

```
PREGUNTAS ANTES DE SEPARAR:
1. ¿Hay equipos distintos que necesitan deploys independientes? → SÍ separar
2. ¿Las partes necesitan escalar de forma radicalmente diferente? → SÍ separar
3. ¿Tienen stacks tecnológicos incompatibles? → Evaluar
4. ¿El problema es el monolito o es que está mal organizado? → Primero organizar
5. ¿Tenemos la madurez operacional para múltiples servicios? → Si no, NO separar
```

### 8.2 Escenarios tipo

| Escenario | Recomendación |
|-----------|---------------|
| Startup / MVP | Monolito modular |
| 1-5 devs, un producto | Monolito bien organizado |
| 5-20 devs, múltiples productos | Monolito modular o Monorepo con paquetes |
| 20+ devs, equipos autónomos | Microservicios por dominio de negocio |
| Parte del sistema escala 100x más | Extraer ese módulo como servicio |
| Dominio con regulación distinta | Separar (ej: pagos con PCI) |

---

## 9. Protocolo de Diseño Arquitectónico

### 9.1 Checklist antes de implementar

```
ANTES DE ESCRIBIR UNA LÍNEA DE CÓDIGO:

□ ¿Qué problema de negocio resuelve esto?
□ ¿Cuáles son los límites del sistema? (qué entra, qué sale)
□ ¿Cuál es el flujo de datos principal? (dibujarlo)
□ ¿Qué falla y cómo se maneja cada fallo?
□ ¿Cómo se observa que funciona correctamente?
□ ¿Qué tan grande necesita ser realmente? (right-sizing)
□ ¿Qué abstracciones son necesarias AHORA vs cuáles son especulativas?
```

### 9.2 Documentación de decisiones (ADR — Architecture Decision Records)

```markdown
# ADR-001: [Título de la decisión]

## Fecha
YYYY-MM-DD

## Estado
[Propuesto | Aceptado | Deprecado | Reemplazado por ADR-XXX]

## Contexto
[El problema o situación que requiere una decisión]

## Decisión
[La decisión tomada, con justificación]

## Consecuencias
[Trade-offs, qué se gana, qué se pierde, riesgos]

## Alternativas consideradas
[Opciones evaluadas y por qué se descartaron]
```

---

## 10. Integración con Sistema Base_AI

### Activación en Context Flags

```yaml
## CONTEXT FLAGS
- domain: [promosmart | general]
- task_type: decision         # Para diseño de arquitectura
- depth: deep                 # Siempre deep para arquitectura
- output: doc                 # Documentación + diagramas
- exploration: tree           # Usar ToT para explorar alternativas
```

### Protocolos que se activan

| Protocolo | Por qué |
|-----------|---------|
| **CoVe** | Toda decisión arquitectónica debe verificarse (checklist §9.1) |
| **ToT** | Explorar múltiples enfoques arquitectónicos antes de elegir |
| **Constraint Cascade** | Implementación multi-paso con validación por fase |
| **ReAct** | Cuando se usa con herramientas (leer código, analizar estructura) |

### Skill Pack Assignment

```yaml
skill_pack: architecture_design_v1
task_type: [decision, documentation, analysis]
triggers:
  - "diseñar arquitectura"
  - "estructura del sistema"
  - "modelo de datos"
  - "límites de dominio"
  - "cuando usar microservicios"
  - "refactorizar a"
  - "bounded context"
  - "flujo de datos"
```

---

**Versión**: 1.0.0  
**Fuente**: https://mcpmarket.com/es/tools/skills/system-architecture  
**Integrado en**: Base_AI System  
**Actualizado**: 2026-04-09
