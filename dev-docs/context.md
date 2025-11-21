# Context - N4N Engine

## Propósito del Proyecto

Construir el **motor técnico** de *Neovim for Nurses (N4N)*:
un editor web keyboard-first inspirado en Neovim, diseñado para soportar
registros de enfermería (evoluciones, notas, planes) sin acoplarse a un dominio clínico específico.

Este repo NO implementa aún la librería clínica,
sólo el **motor**: editor, modos, comandos, providers y almacenamiento básico.

## Dominio de Negocio (nivel motor)

- Editor de texto web con modos estilo Neovim (INSERT, COMMAND).
- Paleta de comandos (Cmd/Ctrl+K) para ejecutar acciones.
- Sistema de comandos extensible.
- Integración con proveedores de snippets y autocompletado (interfaces).
- Almacenamiento local de borradores y estado del editor.

El dominio clínico (snippets de enfermería, work tree, protocolos) vivirá
en otra capa/repositorio y se conectará vía interfaces.

## Alcance – Qué SÍ

- Definir y codificar el **Editor Core** (React + CodeMirror 6).
- Implementar modos básicos: `INSERT` y `COMMAND`.
- Implementar una **command palette** con `cmdk`.
- Definir `Command` y `CommandContext` y un registro de comandos.
- Definir interfaces de `SnippetProvider` y `CompletionProvider`.
- Implementar almacenamiento local básico para borradores.
- Proveer una app `apps/n4n-web` que use estos paquetes.

## Alcance – Qué NO (en esta fase)

- No se implementa lógica clínica (ni diagnósticos, ni sistemas orgánicos).
- No se define aún la librería de snippets clínicos.
- No se integran modelos de IA clínicos ni validadores RAG.
- No hay integración con EHR, FHIR u otros sistemas hospitalarios.
- No se implementa la versión CLI/TUI nativa (terminal).

Esta fase es 100% foco en **motor estable, simple y extensible**.

## Stack Tecnológico

### Motor Principal
- **Lenguaje**: TypeScript + Node.js
- **Frontend**: React 18+ + Vite
- **Editor**: CodeMirror 6
- **UI**: TailwindCSS
- **Command Palette**: cmdk
- **Monorepo**: pnpm workspaces
- **Package Manager**: pnpm

### Estructura del Proyecto
- **Apps**: `apps/n4n-web` (SPA React)
- **Packages**: `packages/editor-core`, `packages/n4n-engine`
- **Testing**: TDD con estructura de tests preparada
- **Build**: Vite para bundling
- **Deployment**: Web-first, local-first con IndexedDB

Esta fase es 100% foco en **motor estable, simple y extensible**.

## Fuente de verdad
- `config/tech-stack.json` - Stack tecnológico definido
- `dev-docs/domain/ubiquitous-language.md` - Lenguaje común del motor

## Estado del setup interactivo
- Fases A/B completadas (dependencias auditadas, prerequisitos, confirmación/`--force`, prompt para `templates/`).
- C3.1 (harness Bash + `npm run test:setup`/`make test:setup`) y C3.3 (`utc_timestamp`, serialización via Python, `warn_missing_compose_file`) ya viven en `main`.
- La observabilidad mínima (C3.2) quedó registrada como opt-in en `TASK-015`; sólo se implementará si el consumidor lo solicita.
- Usa `SETUP_SH_SKIP_INSTALLS=true` en CI o en el harness cuando quieras validar el flujo sin acceder a npm/PyPI.

## Estado de infraestructura (TASK-003)
- No se incluye base de datos real en el starkit; se publicó [`dev-docs/infrastructure/database-blueprint.md`](infrastructure/database-blueprint.md)
  como guía agnóstica.
- El blueprint cubre docker-compose, migraciones, seeds y pruebas de smoke para que cada consumidor adapte el kit sin
  arrastrar dependencias.
- TASK-003 permanece pendiente hasta que el equipo defina proveedor y herramienta de migraciones en su fork.

## Estado de la capa de aplicación (TASK-004)
- La capa `application/` incluye únicamente stubs; el flujo real se documenta en [`dev-docs/application/use-case-blueprint.md`](application/use-case-blueprint.md).
- El blueprint describe contratos (DTOs/ports), handlers, stubs temporales y el plan de pruebas para guiar la implementación sin
  acoplar infraestructura.
- TASK-004 seguirá en "Pendiente" hasta que un consumidor adopte el blueprint y documente qué use case está construyendo.

## Estado de TASK-005 - API REST Endpoint

### Phase 2 - Contract Tests + Documentation ✅
- **Status**: ✅ COMPLETADO (2025-11-19)
- **Implementaciones**:
  - Contract tests con proper isolation (ADR-003)
  - HTTP status validation y conflict handling (409)
  - ADR documentation completa (ADR-003, ADR-004, ADR-005)
  - Testing tools suite para validación continua
- **Technical Improvements**:
  - TypeScript ES2022 module configuration
  - bcrypt security implementation (TD-SEC-001 resuelto)
  - Enhanced HTTP server con readonly properties

### Phase 2.5 - E2E Testing Foundation ✅
- **Status**: ✅ COMPLETADO (2025-11-19 via BUGFIX-E2E-001)
- **Implementaciones**:
  - Repository methods: findById() y findAll() para E2E testing
  - Working E2E test suite: 4 tests con excelente performance
  - Performance achievement: 5.93ms (84x mejor que requirement de 500ms)
  - Zero regression: Todos los tests existentes manteniendo (97/97 passing)
- **Quality Metrics**:
  - TypeScript strict mode: 0 errores
  - Architecture compliance: ADR-003 maintained
  - Test isolation: Perfect implementation

### Phase 3 - Performance, Security, Integration Tests 🚀
- **Status**: ✅ UNBLOCKED y foundation establecida
- **Componentes Listos**:
  - Cross-Component Integration Testing foundation
  - Advanced Performance Testing (load scenarios)
  - Security Testing framework (input validation y sanitization)
  - Final Quality Gates validation
- **Next Steps**:
  1. **Cross-Component Integration Testing**: Implementar tests API → Domain → Repository validation con ADR-003 compliance
  2. **Advanced Performance Testing**: Escenarios de carga con múltiples usuarios concurrentes (k6 suggested)
  3. **Security Testing Framework**: Validación de input sanitization y protección contra inyección SQL/XSS
  4. **Final Quality Gates**: Validación de producción con metrics específicos (100% coverage, <100ms por flow)

### Métricas de Calidad Actuales
- **Test Suites**: 9 passed, 1 skipped
- **Total Tests**: 97 passed, 0 failed
- **E2E Tests**: 4 passing con excelente performance (<10ms)
- **TypeScript Errors**: 0
- **Linting Errors**: 0
- **Architecture Violations**: 0
- **Build Status**: ✅ SUCCESSFUL

## Arquitectura

```
┌─────────────────────────────────────────────────┐
│           Infrastructure Layer                  │
│  (Frameworks, DB, APIs, External Services)      │
└─────────────────────────────────────────────────┘
           ↓ implements interfaces ↓
┌─────────────────────────────────────────────────┐
│           Application Layer                     │
│     (Use Cases, Command/Query Handlers)         │
└─────────────────────────────────────────────────┘
           ↓ orchestrates ↓
┌─────────────────────────────────────────────────┐
│              Domain Layer                       │
│  (Entities, Value Objects, Aggregates, Rules)   │
│         ← NO DEPENDENCIES →                     │
└─────────────────────────────────────────────────┘
```

## Decisiones Técnicas

### ADR-000: Usar Clean Architecture con DDD
- **Contexto**: Necesitamos arquitectura escalable y mantenible
- **Decisión**: Implementar Clean Architecture + Domain-Driven Design
- **Consecuencias**: 
  - ✅ Código independiente de frameworks
  - ✅ Testeable sin dependencias externas
  - ✅ Lógica de negocio protegida
  - ⚠️ Más boilerplate inicial
  - ⚠️ Curva de aprendizaje para el equipo

### ADR-001: [Próxima decisión]
- **Contexto**: [Por qué necesitamos decidir]
- **Decisión**: [Qué decidimos]
- **Consecuencias**: [Implicaciones positivas y negativas]

## Glosario (Ubiquitous Language)
Ver: `dev-docs/domain/ubiquitous-language.md`

## Referencias
- [Clean Architecture - Robert C. Martin](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- [Domain-Driven Design - Eric Evans](https://www.domainlanguage.com/ddd/)
- [Implementing Domain-Driven Design - Vaughn Vernon](https://vaughnvernon.com/)
