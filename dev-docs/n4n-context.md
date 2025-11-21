# Context - Neovim for Nurses

## Propósito del Proyecto

**Neovim for Nurses (N4N)** es una configuración especializada de Neovim diseñada específicamente para profesionales de enfermería y healthcare. Combina herramientas de productividad con templates y atajos específicos para la documentación clínica, optimizando flujos de trabajo digitales en entornos médicos.

## Alcance

### En Scope
- **Configuración Neovim Especializada**: Setup completo de Neovim con plugins y configuraciones optimizadas para uso clínico
- **Templates Médicos**: Templates predefinidos para notas de enfermería, planes de cuidado, evaluaciones y documentación clínica
- **Abreviaciones Clínicas**: Sistema de expansión automática para terminología médica y términos de enfermería comunes
- **Integración Healthcare**: Conectividad con sistemas de información hospitalaria y herramientas de documentación digital
- **Seguridad HIPAA**: Características de seguridad y manejo seguro de información de pacientes

### Out of Scope
- Implementación de sistemas EHR completos (integración, no reemplazo)
- Almacenamiento de datos de pacientes (solo configuración y templates)
- Funcionalidades de diagnóstico o decisiones clínicas automatizadas
- Certificación médica o aprobación regulatoria (herramienta de productividad únicamente)

## Stack Tecnológico

### Core Engine
- **Editor**: Neovim 0.9+ (Lua scripting engine)
- **Configuración**: Lua modules con arquitectura modular
- **Plugins**: Gestión via packer.nvim/vim-plug con optimización healthcare

### Framework de Desarrollo
- **Lenguaje**: Lua (para configuración) + TypeScript (para herramientas de desarrollo)
- **Testing**: busted (Lua), Jest (TypeScript)
- **Lint/Format**: stylua (Lua), ESLint + Prettier (TypeScript)
- **Build**: Make + npm scripts

### Integración y Datos
- **Templates**: Lua templates con placeholders clínicos
- **Abreviaciones**: Sistema custom de expansión basado en trigger-strings
- **Storage**: Configuración local con sincronización opcional
- **Security**: Encriptación local y manejo seguro de PHI

### Entorno de Desarrollo
- **Version Control**: Git + GitHub
- **CI/CD**: GitHub Actions para testing y distribución
- **Documentation**: Markdown + Lua docstrings
- **Package Management**: npm (para herramientas), LuaRocks (opcional)

## Arquitectura del Sistema

### Domain Layer
- **Entidades Clínicas**: Patient, Assessment, CarePlan, NursingNote
- **Value Objects**: MedicalAbbreviation, ClinicalTemplate, VitalSigns
- **Eventos de Dominio**: TemplateUsed, AbbreviationExpanded, NoteCreated

### Application Layer
- **Casos de Uso**: Template Management, Abbreviation Expansion, Clinical Documentation
- **Servicios**: ClinicalValidator, SecurityCompliance, TemplateEngine

### Infrastructure Layer
- **Neovim Integration**: Plugin system, key mappings, autocommands
- **File System**: Template storage, configuration persistence
- **Security**: Data encryption, audit logging, PHI protection

## Estado del setup interactivo

### Fases Completadas
- **Fase A**: Estructura básica del proyecto y scripts de setup del kit fundador
- **Fase B**: Validación de arquitectura y herramientas de desarrollo
- **Fase C**: Configuración específica N4N y templates clínicos

### Componentes Operativos
- **scripts/setup.sh**: Instalación y configuración automática de N4N
- **scripts/validate-architecture.sh**: Validación de estructura y compliance
- **dev-docs/**: Documentación completa de desarrollo y arquitectura
- **config/**: Configuración modular Neovim con especialización healthcare

### Variables de Entorno
```bash
# Setup configuration
SETUP_SH_SKIP_INSTALLS=true    # Omitir instalaciones en CI
N4N_INSTALL_MODE=full         # Instalación completa vs minimal
N4N_BACKUP_EXISTING=true       # Backup automático de config existente

# Development
N4N_DEV_MODE=true             # Modo desarrollo con logs adicionales
N4N_TEST_PLUGINS=true         # Testing de plugins específicos
```

## Fuente de Verdad
- `README.md`: Overview y quick start para usuarios finales
- `CLAUDE.md`: Configuración y guía para Claude Code
- `dev-docs/n4n-context.md`: Contexto técnico y arquitectura (este archivo)
- `dev-docs/plan.md`: Plan de desarrollo y roadmap
- `dev-docs/task.md`: Log de implementación y tareas completadas

## Consideraciones de Compliance

### HIPAA y Healthcare Security
- Todos los templates y configuraciones diseñados para manejo seguro de PHI
- No se almacenan datos de pacientes en la configuración
- Enfoque en productividad sin comprometer la seguridad de datos

### Validation Requirements
- Testing continuo de sintaxis Lua y compatibilidad Neovim
- Validación de templates médicos con profesionales de enfermería
- Revisión regular de actualizaciones de seguridad y compliance

## Ecosystem Integration

### MemTech Universal Integration
El proyecto está diseñado para integrarse con el ecosistema MemTech:
- Memoria persistente de configuraciones y personalizaciones
- Aprendizaje de patrones de uso y optimización de templates
- Contexto compartido entre múltiples instancias N4N

### Multi-Agent Framework Compatibility
- Compatible con los 48 agentes especializados del ecosistema
- Soporte para TDD workflows y desarrollo coordinado
- Integración con herramientas de calidad y automatización