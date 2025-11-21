# Tasks - N4N Engine

Reglas: cada task debe ser ejecutable en 1 commit. Si el commit necesita un “y”, divide en dos tasks. Mantén títulos cortos y medibles.

## En progreso
- Ninguna. Toma la siguiente de "Por hacer".

## Por hacer (micro-tasks)
### [TASK-002] Definir `EditorMode`
- Criterios: crear tipo/enum con `INSERT`, `COMMAND` en `packages/editor-core`; exportado desde su índice; test mínimo que valida los valores.

### [TASK-003] Definir `EditorState`
- Criterios: interfaz con `mode: EditorMode` y `doc: string`; exportada desde el índice de `editor-core`; test que asegura shape básico.

### [TASK-004] Barril de exports `editor-core`
- Criterios: `packages/editor-core/src/index.ts` reexporta `EditorMode`, `EditorState`; build/type-check del paquete pasa.

### [TASK-005] Interfaces de comandos (`n4n-engine`)
- Criterios: definir `Command` (`id`, `label`, `handler(ctx)`), `CommandContext` (estado/mutadores mínimos) en `packages/n4n-engine`; exportadas desde índice; test de tipado/shape.

### [TASK-006] Registro simple de comandos
- Criterios: función/objeto para registrar/listar comandos en `n4n-engine`; manejo de ids duplicados (rechazo o reemplazo definido); tests cubren alta/listado/ejecución.

### [TASK-007] Stub `SnippetProvider` y `CompletionProvider`
- Criterios: interfaces async en `n4n-engine`; valores de retorno tipados; exportadas; tests de tipo (al menos expected method signatures).

### [TASK-008] Storage in-memory para `NoteDraft`
- Criterios: tipo `NoteDraft` y store en memoria con `saveDraft/loadDraft/clear`; tests de lectura/escritura/reset.

### [TASK-009] `EditorShell` mínimo con CodeMirror
- Criterios: componente en `editor-core` que monta CodeMirror 6 con doc inicial; props para `value/onChange`; test/render básico (React Testing Library o equivalente).

### [TASK-010] Integrar `EditorShell` en `n4n-web`
- Criterios: app principal muestra `EditorShell`; modo actual visible en UI; comando de dev `pnpm dev` funcional.

### [TASK-011] Palette base con `cmdk`
- Criterios: paleta abre con Cmd/Ctrl+K en `n4n-web`; lista comandos del registro; ejecuta uno de prueba; test de interacción básico.

### [TASK-012] Rule de lint/format en CI local
- Criterios: scripts `pnpm lint`, `pnpm format` definidos; Husky/lint-staged ejecutan lint+format en pre-commit; comprobado con un commit de prueba.

### [TASK-013] Tests mínimos de modos/commands/storage
- Criterios: suite Vitest que cubre modos, command registry y storage; coverage objetivo inicial ~50% en estas áreas.

### [TASK-014] Pipeline CI base
- Criterios: workflow GitHub Actions (o equivalente) con `pnpm lint`, `pnpm test -- --coverage`, `pnpm build`; cache pnpm/Turbo configurado.

### [TASK-015] Chequeo de arquitectura
- Criterios: script simple (e.g., node/bash) que verifica que `apps/` no importe desde `packages/` prohibidos y que `packages/` no incluyan imports clínicos/IA; se ejecuta en CI/local.

### [TASK-016] Coverage gate inicial
- Criterios: configurar threshold (Vitest) >=80% global o mínimo en áreas core; falla en CI si se rompe el umbral.

## Hechas
### [TASK-001] Esqueleto de monorepo
- Resultado: existen `apps/n4n-web`, `packages/editor-core`, `packages/n4n-engine`; workspace pnpm configurado; `pnpm install` funciona.
