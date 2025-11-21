# Plan - N4N Engine

## Arquitectura y principios
- Clean Architecture: `apps/` (UI) depende de `packages/` (motor). Motor expone interfaces; capas clínicas viven fuera del repo.
- Clean Code: funciones pequeñas, nombres explícitos, evitar estados globales; preferir composición sobre herencia.
- Dependencias: adaptadores delgados; nada de SDKs clínicos/IA dentro del motor.

## Calidad y toolchain
- Lint: `pnpm lint` (ESLint con @typescript-eslint, react-hooks). Fix antes de PR.
- Format: `pnpm format` (Prettier 3). Consistencia 2 espacios, punto y coma on.
- Tests: `pnpm test` (Vitest); objetivo 80% global; aislamiento obligatorio (ver ADR-003).
- Hooks: Husky + lint-staged para lint/format en pre-commit.
- Arquitectura: script/chequeo de dependencia limpia (no UI → packages, no imports clínicos).
- CI esperado: `pnpm lint && pnpm test && pnpm build` con Turbo cache.

## Workflows
- Instalación: `pnpm install` (Node >=20, pnpm >=9).
- Dev app: `cd apps/n4n-web && pnpm dev` (Vite).
- Scoping: usar `--filter` de pnpm/Turbo para limitar builds/tests por paquete.
- Branches sugeridas: `feature/TASK-###-slug`. Commits siempre atómicos.
- Revisiones: PR con descripción breve, tareas vinculadas, pruebas ejecutadas; adjuntar captura/GIF para cambios de UI.

## Versionado y artefactos
- Semver en paquetes cuando corresponda; mantener el motor neutral de dominio.
- Build: `pnpm build` en la raíz; produce artefactos por paquete/app según configuración de Vite/Turbo.

## Seguridad y configuración
- Variables en `.env.example`; no subir secretos.
- Revisar `config/rules/ai-guardrails.json` antes de tocar el motor.
- No mezclar gestores de paquetes; pnpm-lock.yaml es la fuente de verdad.

## Mantenimiento
- ADRs en `dev-docs/ADR/`; documentar decisiones relevantes.
- Ubiquitous Language en `dev-docs/domain/ubiquitous-language.md`.
- Actualizar este plan sólo cuando cambie la forma de trabajar (arquitectura, calidad, workflows).
