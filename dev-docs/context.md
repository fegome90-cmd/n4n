# Context - N4N Engine

## Propósito
Motor técnico de **Neovim for Nurses (N4N)**: editor web keyboard-first inspirado en Neovim. Provee modos, comandos, providers y almacenamiento local. Es 100% agnóstico del dominio clínico.

## Alcance (qué sí)
- SPA `apps/n4n-web` consume el motor.
- Paquete `editor-core`: integración CodeMirror 6, modos (`INSERT`, `COMMAND`), estado del editor, shell base.
- Paquete `n4n-engine`: sistema de comandos, palette (`cmdk`), interfaces de `SnippetProvider` y `CompletionProvider`, storage local para `NoteDraft`.
- Infra mínima: monorepo pnpm/Turbo, toolchain definida en `config/tech-stack.json`.

## Fuera de alcance (qué no)
- Sin lógica clínica ni protocolos; la librería clínica vive en otro repo/capa.
- Sin SDKs de IA acoplados al motor.
- Sin EHR/FHIR ni backends externos en v1.
- Sin CLI/TUI nativa en esta fase.

## Arquitectura (visión rápida)
Monorepo con apps + packages. El motor sigue principios de Clean Architecture: UI (apps) depende de `editor-core` y `n4n-engine`; estos exponen interfaces para que cualquier capa clínica externa se conecte sin filtrarse al motor.

## Definición de Hecho – Motor v1
Se considera v1 completado cuando:
- `EditorShell` integrado con CodeMirror 6 y operando en `n4n-web`.
- Modos `INSERT` / `COMMAND` funcionales con estado visible.
- Command Palette (`cmdk`) con 5–10 comandos base.
- `SnippetProvider` stub + `CompletionProvider` stub integrados.
- Storage local in-memory para `NoteDrafts` funcionando.
- Tests cubren modos, comandos y storage (objetivo ≥80% coverage global).

## Stack esencial
- TypeScript + React 18 + Vite 6 + Tailwind 3 + CodeMirror 6 + cmdk.
- pnpm workspaces + Turbo.
- Calidad: ESLint (@typescript-eslint, react-hooks), Prettier; Husky/lint-staged para ganchos.
- Testing: Vitest (objetivo 80% global en v1 stable).

## Guardrails
- Motor y paquetes (`editor-core`, `n4n-engine`) no pueden incluir conceptos clínicos ni SDKs de IA.
- Mantener la separación UI (apps) vs. motor (packages); no mezclar UI en paquetes.
- Micro-commits: si el mensaje necesita “y”, dividir el cambio.

## Dónde seguir
- Contexto (este archivo) explica propósito y alcance.
- Plan (`dev-docs/plan.md`) detalla arquitectura, calidad, workflows.
- Tasks (`dev-docs/task.md`) lista micro-tareas ejecutables (1 commit cada una).
- Stack y reglas: `config/tech-stack.json` y `config/rules/ai-guardrails.json`.
