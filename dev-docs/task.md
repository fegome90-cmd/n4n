
## Hechas
### [TASK-001] Esqueleto de monorepo
- Resultado: existen `apps/n4n-web`, `packages/editor-core`, `packages/n4n-engine`; workspace pnpm configurado; `pnpm install` funciona.

### [TASK-INFRA-001] Crear pnpm-workspace.yaml
- **COMPLETADO**: Configurar workspace con apps/* y packages/*.

### [TASK-INFRA-002] Configurar package.json root  
- **COMPLETADO**: Scripts, devDependencies, engines sin workspaces duplicados.

### [TASK-CORE-005] Corregir exports ESM en editor-core
- **COMPLETADO**: Fix package.json module y exports para apuntar a index.mjs.

### [TASK-ENGINE-007] Crear estructura de n4n-engine
- **COMPLETADO**: Directorios src/ y package.json con peer dependencies.

### [TASK-ENGINE-008] Implementar interfaces de comandos
- **COMPLETADO**: Command.ts con CommandContext, Command interfaces y type-check pasando.
EOF'