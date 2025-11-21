# Tasks - N4N Engine

Reglas: cada task debe ser ejecutable en 1 commit. Si el commit necesita un “y”, divide en dos tasks. Mantén títulos cortos y medibles. Los ejecutores no pueden borrar o reescribir tasks; solo se marcan como Hechas cuando el validador las aprueba.

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
- Criterios: app principal muestra `EditorShell`; modo actual visible en UI; comando de dev `pnpm dev` (Node >=20, Vite 6.x) funcional.

### [TASK-011] Palette base con `cmdk`
- Criterios: paleta abre con Cmd/Ctrl+K en `n4n-web`; lista comandos del registro; ejecuta uno de prueba; test de interacción básico.

### [TASK-012] Guardrails lint/format locales
- Criterios: configs ESLint 8.x (@typescript-eslint, react-hooks) y Prettier 3.x alineadas al tech stack; scripts `pnpm lint`, `pnpm format` operativos; Husky (9.x+) + lint-staged (15.x+) instalados con pnpm y ejecutan lint/format en pre-commit verificado.

### [TASK-013] Tests mínimos de modos/commands/storage
- Criterios: suite Vitest 2.x|3.x que cubre modos, command registry y storage; coverage objetivo alineado a ≥80% global.

### [TASK-014] Pipeline CI base
- Criterios: workflow GitHub Actions (o equivalente) con `actions/checkout@v4|v5` + `pnpm/action-setup@v3|v4` (pnpm >=9, Node >=20); pasos `pnpm lint`, `pnpm test -- --coverage`, `pnpm build`; cache pnpm/Turbo 2.x configurado.

### [TASK-015] Chequeo de arquitectura
- Criterios: usar `scripts/validate-architecture.sh` para asegurar que `packages/` no dependan de `apps/`, detectar tokens clínicos/IA en el motor y avisar sobre imports relativos profundos; se ejecuta en CI/local.

### [TASK-016] Coverage gate inicial
- Criterios: configurar threshold (Vitest 2.x|3.x) >=80% global (en `vitest.config.ts` o equivalente); falla en CI si se rompe el umbral.

### [TASK-017] Pinned runtime y package manager
- Criterios: Node >=20 y pnpm >=9 declarados en `package.json` (`engines`, `packageManager`) y/o `.nvmrc`; docs actualizadas; verificación de versión en README o script.

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
