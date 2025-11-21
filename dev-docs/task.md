# Tasks - N4N Engine

Reglas: cada task debe ser ejecutable en 1 commit. Si el commit necesita un “y”, divide en dos tasks. Mantén títulos cortos y medibles. Los ejecutores no pueden borrar o reescribir tasks; solo se marcan como Hechas cuando el validador las aprueba.

## En progreso

- Ninguna. Toma la siguiente de "Por hacer".

## Por hacer (micro-tasks)

### [TASK-006] Registro simple de comandos

- Criterios: función/objeto para registrar/listar comandos en `n4n-engine`; manejo de ids duplicados (rechazo o reemplazo definido); tests cubren alta/listado/ejecución.

### [TASK-007] Stub `SnippetProvider` y `CompletionProvider`

- Criterios: interfaces async en `n4n-engine`; valores de retorno tipados; exportadas; tests de tipo (al menos expected method signatures).

### [TASK-008] Storage in-memory para `NoteDraft`

- Criterios: tipo `NoteDraft` y store en memoria con `saveDraft/loadDraft/clear`; tests de lectura/escritura/reset.

### [TASK-009] `EditorShell` mínimo con CodeMirror

- Criterios: componente en `editor-core` que monta CodeMirror 6 con doc inicial; props para `value/onChange`; test/render básico (React Testing Library o equivalente).

### [TASK-010] Integrar `EditorShell` en `n4n-web`

- Criterios: app principal muestra `EditorShell`; modo actual visible en UI; comando de dev `pnpm dev` (Node >=20, Vite 6.x) funcional.

### [TASK-011] Palette base con `cmdk`

- Criterios: paleta abre con Cmd/Ctrl+K en `n4n-web`; lista comandos del registro; ejecuta uno de prueba; test de interacción básico.

### [TASK-013] Tests mínimos de modos/commands/storage

- Criterios: suite Vitest 2.x|3.x que cubre modos, command registry y storage; coverage objetivo alineado a ≥80% global.

### [TASK-015] Chequeo de arquitectura

- Criterios: usar `scripts/validate-architecture.sh` para asegurar que `packages/` no dependan de `apps/`, detectar tokens clínicos/IA en el motor y avisar sobre imports relativos profundos; se ejecuta en CI/local.

### [TASK-016] Coverage gate inicial

- Criterios: configurar threshold (Vitest 2.x|3.x) >=80% global (en `vitest.config.ts` o equivalente); falla en CI si se rompe el umbral.

### [TASK-020] Definir `Command` y `CommandCategory` (engine)

- Criterios: `packages/n4n-engine/src/commands/Command.ts` expone `Command<TArgs, TResult>` y `CommandCategory` solo con categorías técnicas (`editing`, `navigation`, `tools`, `custom`); sin tipos clínicos ni referencias a dominio; exportado desde el índice del paquete.

### [TASK-021] `CommandRegistry` con middleware de logging

- Criterios: `packages/n4n-engine/src/commands/CommandRegistry.ts` implementa `register/execute/getAll/search` con soporte de middleware; `packages/n4n-engine/src/middleware/logging.ts` registra `commandId/timestamp/success|failure`; tests cubren registro, ejecución y logging.

### [TASK-022] `CommandContext` agnóstico + factory

- Criterios: `packages/n4n-engine/src/commands/CommandContext.ts` define contexto sin dominio clínico (solo editor ops, storage/snippets/autocomplete/notifications genéricos, metadata `source/timestamp/executionId`) y factory inmutable; tests validan exposición de servicios y ausencia de tipos clínicos.

### [TASK-023] Comandos MVP (texto/navegación/UX)

- Criterios: `packages/n4n-engine/src/commands/builtin.ts` define comandos técnicos (`editor.insertText/deleteSelection/undo/redo/goTo*/jumpTo*`, `ui.openCommandPalette`, opcional `notes.saveDraft` genérico `NoteDraft { id, content, updatedAt }`); `CommandRegistry` los ejecuta contra stub de `EditorOperations`; tests cubren registro y ejecución de al menos 3–5 comandos.

### [TASK-024] Jerarquía mínima de errores

- Criterios: `packages/n4n-engine/src/errors/` contiene `CommandError`, `CommandNotFoundError`, `CommandDisabledError`; `execute` los utiliza; tests cubren comando inexistente, deshabilitado y error en handler.

## Hechas

### [TASK-001] Esqueleto de monorepo

- Resultado: existen `apps/n4n-web`, `packages/editor-core`, `packages/n4n-engine`; workspace pnpm configurado; `pnpm install` funciona.

### [TASK-002] Definir `EditorMode`

- Resultado: enum `EditorMode` con `INSERT`, `COMMAND` en `packages/editor-core/src/EditorMode.ts`; exportado desde índice; tests pasando en Node 20.x.

### [TASK-003] Definir `EditorState`

- Resultado: interfaz `EditorState` con helpers (`createEditorState`, `withDocument`, `withMode`) en `packages/editor-core/src/EditorState.ts`; tests pasando en Node 20.x.

### [TASK-004] Barril de exports `editor-core`

- Resultado: `packages/editor-core/src/index.ts` reexporta `EditorMode`, `EditorState` y aliases; build/type-check del paquete pasa; exports ESM/CJS apuntan a `dist/index.mjs` / `dist/index.js`.

### [TASK-005] Interfaces de comandos (`n4n-engine`)

- Resultado: `packages/n4n-engine/src/Command.ts` define `Command` y `CommandContext` base; type-check del paquete pasa; build CJS/ESM generado correctamente.

### [TASK-012] Guardrails lint/format locales

- Resultado: ESLint 8.57.0 con @typescript-eslint y react-hooks + Prettier 3.6.2 configurados; scripts `pnpm lint`/`pnpm format` funcionales; Husky 9 + lint-staged operativos en pre-commit; validado en Node 20.x.

### [TASK-014] Pipeline CI base

- Resultado: workflow CI con `actions/checkout@v4` + `pnpm/action-setup@v3`, Node 20.x matrix; pasos `pnpm lint`, `pnpm test -- --coverage`, `pnpm build`; cache pnpm/Turbo configurado.

### [TASK-017] Pinned runtime y package manager

- Resultado: `engines` exige Node >=20 y pnpm >=9 en package.json; `.nvmrc` apunta a Node 20.x; `packageManager` fijado a pnpm@9.0.0; validado en Node 20.19.5.
