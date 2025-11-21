# Neovim for Nurses – Engine (N4N Engine)

Motor técnico de **Neovim for Nurses (N4N)**:  
un editor web keyboard-first inspirado en Neovim, pensado para registros de enfermería, pero **sin lógica clínica dentro del repo**.

Este proyecto define:

- El **Editor Core** (modos, teclado, integración con CodeMirror).
- La **Command Palette** (Cmd/Ctrl+K) y el sistema de comandos.
- Las **interfaces** para providers de snippets y autocompletado.
- El esqueleto de **almacenamiento local** de borradores.

La librería clínica (snippets de enfermería, work tree, protocolos) vive en otro repositorio/capa.

---

## Objetivo del proyecto

Construir un motor:

- **Estable**: capaz de vivir años sin convertirse en bola de barro.
- **Extensible**: se enchufa a diferentes librerías clínicas vía interfaces.
- **Keyboard-first**: pensado para flujos tipo Neovim, no para clics.
- **Neutro de dominio**: no conoce “paciente”, “hemodinámico”, “drenaje”, etc.

Este repo NO intenta resolver IA clínica, protocolos ni integración con fichas EHR.  
Su único trabajo es proveer un **editor de alto nivel con modos y comandos**, listo para que encima se monte N4N clínico.

---

## Alcance (qué SÍ y qué NO)

### Qué SÍ hace este repo (v1)

- SPA web base: `apps/n4n-web` (React + Vite + TypeScript).
- Paquete `editor-core`:
  - Wrapper de editor (CodeMirror 6 u otro).
  - Modos (`INSERT`, `COMMAND`).
  - Estado del editor (`EditorState`).
- Paquete `n4n-engine`:
  - Sistema de **comandos** (`Command`, `CommandContext`).
  - Integra la **command palette** (cmdk).
  - Interfaces de `SnippetProvider` y `CompletionProvider`.
  - Almacenamiento local básico de **NoteDrafts**.
- Infraestructura mínima de desarrollo:
  - Monorepo con `pnpm`.
  - TS configs base.
  - Hooks para tests/lint.

### Qué NO hace este repo (en esta fase)

- No trae snippets clínicos ni plantillas de enfermería.
- No habla de sistemas orgánicos (neuro, resp, hemo, etc.).
- No integra modelos de IA clínicos ni RAG.
- No implementa CLI/TUI nativa (terminal).
- No integra EHR/FHIR ni sistemas hospitalarios externos.

Todo lo clínico va **afuera**.  
Este proyecto es el “frame” sobre el que se monta el contenido.

---

## Arquitectura

Monorepo simple con apps y packages:

```txt
.
├── apps/
│   └── n4n-web/           # SPA React que usa el motor
├── packages/
│   ├── editor-core/       # Núcleo del editor (modos, estado, integración editor)
│   └── n4n-engine/        # Motor de comandos, providers y storage
├── config/
│   └── tech-stack.json    # Stack declarado para el agente y humanos
├── dev-docs/
│   ├── context.md         # Contexto y alcance del motor
│   ├── task.md            # Task board con tareas atómicas
│   └── domain/
│       └── ubiquitous-language.md  # Lenguaje compartido del motor
└── config/rules/
    └── ai-guardrails.json # Reglas para el agente IA (no mezclar motor y clínica)

Paquetes

packages/editor-core
	•	Tipos:
	•	EditorMode (INSERT, COMMAND en v1).
	•	EditorState (al menos mode + doc).
	•	Componente:
	•	EditorShell: contenedor del editor real.
	•	API pública:
	•	Hooks y componentes para que n4n-web pueda montar el editor y manejar modos.

packages/n4n-engine
	•	Tipos:
	•	Command, CommandContext.
	•	SnippetProvider, CompletionProvider.
	•	NoteDraft.
	•	Funciones:
	•	Registro y ejecución de comandos.
	•	Almacenamiento local básico de borradores.
	•	Integración:
	•	Se consume desde n4n-web y futuros consumidores.

⸻

Tech Stack
	•	Lenguaje: TypeScript
	•	Runtime: Node.js
	•	Gestor de paquetes: pnpm
	•	Frontend:
	•	React
	•	Vite
	•	TailwindCSS (u otra lib de estilos utilitaria)
	•	CodeMirror 6 (editor)
	•	cmdk (command palette)
	•	Arquitectura: Monorepo (apps + packages)
	•	Persistencia v1: In-memory / IndexedDB stub (local-first). Backend REST vendrá después.

La definición detallada está en config/tech-stack.json.

⸻

Quick Start

1. Configurar Tech Stack

nano config/tech-stack.json

Revisa y ajusta el JSON de stack según tu entorno (Node, pnpm, etc.).

2. Completar Contexto

nano dev-docs/context.md

Asegúrate de que el contexto refleja:
	•	Propósito del motor (no clínica).
	•	Alcance de esta fase.
	•	Lo que queda explícitamente fuera.

3. Definir Lenguaje Ubiquo

nano dev-docs/domain/ubiquitous-language.md

Revisa/ajusta términos:
	•	EditorMode, Command, CommandContext, SnippetProvider, etc.
	•	Prohibir términos clínicos en esta capa (no “paciente”, “neuro”, etc.).

4. Revisar y elegir la primera Task

nano dev-docs/task.md

Toma TASK-001 (estructura de monorepo) o la siguiente pendiente.

5. Levantar entorno de desarrollo

Si el Makefile ya está configurado:

make dev

O manual:

cd apps/n4n-web
pnpm install
pnpm dev


⸻

Workflow de Desarrollo

Regla dura de micro-commits

Si el mensaje de commit necesita un “y”, probablemente es dos commits.

Ejemplos válidos:
	•	Add EditorMode type
	•	Add EditorState interface
	•	Wire editor-core into n4n-web root page

Ejemplo inválido:
	•	Add editor types and integrate into app ✅ → dividir en dos.

Para Humanos
	1.	Elegir una task en dev-docs/task.md (ej. TASK-002 – EditorMode).
	2.	Crear branch:

git checkout -b feature/TASK-002-editor-mode


	3.	Seguir TDD cuando aplique:
	•	Test que falle → implementación → refactor.
	4.	Hacer commits pequeños y atómicos.
	5.	Push + PR.
	6.	Code review con foco en:
	•	No mezclar motor y clínica.
	•	Respetar lenguaje ubiquo.
	•	Mantener el motor simple y extensible.

Para el Agente IA
	1.	Antes de tocar código:
	•	Leer config/rules/ai-guardrails.json.
	•	Leer .context/project-state.json (si existe).
	•	Elegir una task concreta en dev-docs/task.md.
	2.	Durante desarrollo:
	•	Proponer cambios acotados por commit.
	•	Respetar la separación:
	•	editor-core = editor.
	•	n4n-engine = comandos/providers/storage.
	•	No inventar conceptos clínicos en el motor.
	3.	Después de codificar:
	•	Actualizar .context/active-context.md.
	•	Marcar avance en dev-docs/task.md.

⸻

Comandos útiles (objetivo)

Algunos de estos pueden ser echo "TODO" al inicio. La idea es converger hacia esto.

# Desarrollo
make dev              # Levantar entorno dev (n4n-web)
make logs             # Ver logs
make shell            # Entrar a shell del entorno (si usas Docker)

# Testing
make test             # Ejecutar tests
make test-watch       # Tests en modo watch
make test-coverage    # Tests con coverage

# Calidad
make lint             # Linter
make format           # Formatter
make validate         # Validar arquitectura/reglas

# Cleanup
make clean            # Limpiar artefactos
make reset            # Reset completo del entorno


⸻

Roadmap (Motor v1)
	1.	Esqueleto de monorepo
	•	apps/n4n-web, packages/editor-core, packages/n4n-engine.
	2.	Editor Core básico
	•	EditorMode, EditorState, EditorShell.
	3.	Sistema de modos
	•	Cambios de modo por teclado.
	•	Status bar con modo actual.
	4.	Command System + Palette
	•	Definir Command/CommandContext.
	•	Integrar cmdk.
	•	10–15 comandos base (edición/navegación).
	5.	Providers e interfaces
	•	SnippetProvider, CompletionProvider.
	•	Implementaciones dummy para desarrollo.
	6.	Storage local mínimo
	•	NoteDraft + saveDraft/loadDraft.

Fases posteriores (fuera del alcance de este repo):
librería clínica, work tree, IA clínica, integración con EHR.

⸻

Licencia

Por definir (LICENSE pendiente).
Hasta entonces, tratar como código privado/interno.

