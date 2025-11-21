# Repository Guidelines

## Project Structure & Module Organization
- Monorepo powered by pnpm/Turbo; keep apps and packages isolated and domain-agnostic.
- `apps/n4n-web`: React + Vite SPA that consumes the engine.
- `packages/editor-core`: Editor shell, modes (`INSERT`, `COMMAND`), state helpers, CodeMirror wiring.
- `packages/n4n-engine`: Command system, palette integration, provider interfaces, local draft storage.
- `config/`: Tech stack declaration and guardrails; `dev-docs/`: context, tasks, ADRs; `.env.example`: baseline env variables.

## Build, Test, and Development Commands
- Install: `pnpm install` (run at repo root; pnpm >=9, Node >=20).
- Dev server: `cd apps/n4n-web && pnpm dev` (Vite).
- Quality gates: `pnpm lint`, `pnpm test`, `pnpm build` (pipeline defaults). If a Makefile is present, `make dev|test|lint|format` mirror these.
- Turbo tips: prefer `pnpm lint --filter ...` / `pnpm test --filter ...` to scope work when the workspace grows.

## Coding Style & Naming Conventions
- TypeScript-first; React 18, Tailwind utility styling, Radix optional. Default to Prettier formatting (2-space tabs, semicolons on).
- ESLint (typescript-eslint, react-hooks) is the source of truth; fix warnings before PR.
- Naming: types/interfaces PascalCase (`EditorState`, `CommandContext`), hooks camelCase (`useEditorMode`), constants UPPER_SNAKE. Command IDs are kebab-case and domain-neutral (no clinical terms).
- Folder names match package intent (`editor-core`, `n4n-engine`); avoid mixing UI concerns into engine packages.

## Testing Guidelines
- Vitest (via Turbo) with an 80%+ coverage target (`pnpm test`, `pnpm test -- --watch` locally).
- Test files: colocate as `*.test.ts`/`*.test.tsx` or under `__tests__/`.
- Follow ADR-003: isolate state with `beforeEach`/`afterEach`, reset in-memory stores, and generate unique fixtures to prevent cross-test leakage.
- Prefer deterministic keyboard-driven flows; mock external providers (snippets/completions/storage) instead of hitting real services.

## Commit & Pull Request Guidelines
- Micro-commits: if the message needs an “and,” split it. Examples: `Add EditorMode type`, `Wire editor-core into n4n-web root page`.
- Branches: `feature/TASK-###-slug` aligned with `dev-docs/task.md`.
- PRs: concise description, linked task/issue, tests run, and UI screenshot/GIF for `n4n-web` changes. Call out any deviations from guardrails (should be rare).

## Guardrails & Safety
- Read `config/rules/ai-guardrails.json` and `dev-docs/context.md` before coding; the engine stays domain-neutral (no clinical entities or IA SDK coupling).
- Keep secrets out of git; base configs live in `.env.example`.
- Agents: update `.context/active-context.md` if present and log task progress in `dev-docs/task.md`.
