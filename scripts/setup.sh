#!/bin/bash
# Neovim for Nurses - Setup Script
# Basado en Kit Fundador v2.0 - Adaptado para configuración Neovim

set -e

SKIP_INSTALLS=${SETUP_SH_SKIP_INSTALLS:-false}

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

FORCE_MODE=false

usage() {
    cat <<USAGE
Uso: ./scripts/setup.sh [opciones]

Opciones:
  --install      Instala la configuración de N4N en ~/.config/nvim
  --force       Omite confirmaciones de sobrescritura y validaciones de prerequisitos.
  -h, --help    Muestra esta ayuda y termina.

Variables de entorno:
  SETUP_SH_SKIP_INSTALLS=true  Omite instalaciones de plugins (útil en CI).

Ejemplos:
  ./scripts/setup.sh              # Setup básico del entorno
  ./scripts/setup.sh --install    # Instala configuración completa
  ./scripts/setup.sh --force      # Modo forzado (sin confirmaciones)
USAGE
}

parse_args() {
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --install)
                INSTALL_MODE=true
                shift
                ;;
            --force)
                FORCE_MODE=true
                shift
                ;;
            -h|--help)
                usage
                exit 0
                ;;
            *)
                echo -e "${RED}Flag no reconocida: $1${NC}"
                usage
                exit 1
                ;;
        esac
    done
}

parse_args "$@"

utc_timestamp() {
    if command -v date &> /dev/null; then
        if ts=$(date -u +"%Y-%m-%dT%H:%M:%SZ" 2> /dev/null); then
            echo "$ts"
            return 0
        fi
    fi

    if command -v python3 &> /dev/null; then
        python3 - <<'PY'
import datetime
print(datetime.datetime.utcnow().replace(microsecond=0).isoformat() + "Z")
PY
        return 0
    fi

    echo "1970-01-01T00:00:00Z"
}

validate_prerequisites() {
    local mode=$1
    local -a missing

    # Git es obligatorio
    if ! command -v git &> /dev/null; then
        missing+=("git")
    fi

    # Para modo install, Neovim es requerido
    if [[ "$INSTALL_MODE" == "true" ]]; then
        if ! command -v nvim &> /dev/null; then
            missing+=("nvim (Neovim 0.9+)")
        fi
    fi

    # Verificar versión de Neovim si está instalado
    if command -v nvim &> /dev/null; then
        local nvim_version=$(nvim --version | head -1 | grep -oE '[0-9]+\.[0-9]+' | head -1)
        if [[ "$(echo "$nvim_version < 0.9" | bc -l 2>/dev/null || echo "0")" == "1" ]]; then
            echo -e "${YELLOW}Advertencia: Se recomienda Neovim 0.9 o superior. Versión actual: $nvim_version${NC}"
            if [[ "$FORCE_MODE" != "true" ]]; then
                read -p "¿Continuar de todos modos? (y/N): " -n 1 -r
                echo
                if [[ ! $REPLY =~ ^[Yy]$ ]]; then
                    exit 1
                fi
            fi
        fi
    fi

    if [[ ${#missing[@]} -gt 0 ]]; then
        echo -e "${RED}❌ Prerequisitos faltantes: ${missing[*]}${NC}"
        echo -e "${YELLOW}Por favor instala las herramientas faltantes antes de continuar.${NC}"
        exit 1
    fi

    echo -e "${GREEN}✅ Prerequisitos validados${NC}"
}

backup_existing_config() {
    if [[ -d ~/.config/nvim && ! -L ~/.config/nvim ]]; then
        if [[ "$FORCE_MODE" != "true" ]]; then
            echo -e "${YELLOW}⚠️  Se encontró una configuración existente de Neovim en ~/.config/nvim${NC}"
            read -p "¿Crear backup? (Y/n): " -n 1 -r
            echo
            if [[ $REPLY =~ ^[Nn]$ ]]; then
                echo -e "${RED}Cancelado por el usuario${NC}"
                exit 1
            fi
        fi

        local backup_dir="$HOME/.config/nvim.backup.$(utc_timestamp)"
        mv ~/.config/nvim "$backup_dir"
        echo -e "${GREEN}✅ Configuración existente backupeada en: $backup_dir${NC}"
    elif [[ -L ~/.config/nvim ]]; then
        echo -e "${YELLOW}⚠️  ~/.config/nvim es un symlink, se removerá${NC}"
        rm ~/.config/nvim
    fi
}

install_n4n_config() {
    echo -e "${BLUE}🚀 Instalando Neovim for Nurses...${NC}"

    # Crear directorios necesarios
    mkdir -p ~/.config/nvim
    mkdir -p ~/.local/share/nvim/site/pack/n4n/{start,opt}
    mkdir -p ~/.local/share/nvim/undos
    mkdir -p ~/.local/share/nvim/swap
    mkdir -p ~/.local/share/nvim/backup

    # Copiar configuración principal
    cp -r config/* ~/.config/nvim/
    cp config/init.lua ~/.config/nvim/ 2>/dev/null || true

    # Copiar templates clínicos
    mkdir -p ~/.config/nvim/templates
    cp -r templates/* ~/.config/nvim/templates/ 2>/dev/null || true

    # Establecer permisos
    chmod +x ~/.config/nvim/scripts/*.sh 2>/dev/null || true

    echo -e "${GREEN}✅ Configuración N4N instalada${NC}"
}

setup_clinic_templates() {
    echo -e "${BLUE}🏥 Configurando templates clínicos...${NC}"

    # Crear directorios de templates
    mkdir -p ~/.config/nvim/templates/{nursing-notes,care-plans,assessments}

    # Si existen templates personalizados, copiarlos
    if [[ -d templates/nursing-notes ]]; then
        cp -r templates/nursing-notes/* ~/.config/nvim/templates/nursing-notes/
    fi

    if [[ -d templates/care-plans ]]; then
        cp -r templates/care-plans/* ~/.config/nvim/templates/care-plans/
    fi

    if [[ -d templates/assessments ]]; then
        cp -r templates/assessments/* ~/.config/nvim/templates/assessments/
    fi

    echo -e "${GREEN}✅ Templates clínicos configurados${NC}"
}

install_plugins() {
    if [[ "$SKIP_INSTALLS" == "true" ]]; then
        echo -e "${YELLOW}⏭️  Saltando instalación de plugins (SETUP_SH_SKIP_INSTALLS=true)${NC}"
        return 0
    fi

    echo -e "${BLUE}📦 Instalando plugins...${NC}"

    # Dejar que Neovim instale sus plugins automáticamente
    nvim --headless -c 'lua vim.defer_fn(function() vim.cmd("quit") end, 3000)' +qa 2>/dev/null || true

    echo -e "${GREEN}✅ Plugins configurados${NC}"
}

validate_installation() {
    echo -e "${BLUE}🔍 Validando instalación...${NC}"

    # Validar configuración principal
    if [[ ! -f ~/.config/nvim/init.lua ]]; then
        echo -e "${RED}❌ No se encontró init.lua en ~/.config/nvim${NC}"
        exit 1
    fi

    # Validar sintaxis Lua
    if nvim --headless -c 'lua vim.cmd("quit")' +qa 2>/dev/null; then
        echo -e "${GREEN}✅ Sintaxis Lua validada${NC}"
    else
        echo -e "${RED}❌ Error en la sintaxis de la configuración${NC}"
        exit 1
    fi

    echo -e "${GREEN}✅ Instalación validada exitosamente${NC}"
}

show_next_steps() {
    echo -e "${BLUE}"
    cat <<NEXTSTEPS
🎉 ¡Neovim for Nurses está listo!

Próximos pasos:
1. Inicia Neovim: ${GREEN}nvim${NC}
2. Los plugins se instalarán automáticamente en el primer inicio
3. Usa ${YELLOW}:help n4n${NC} para ver la documentación interna
4. Revisa los templates clínicos en ${YELLOW}~/.config/nvim/templates/${NC}

Comandos útiles:
- make doctor    # Verificar sistema
- make validate  # Validar configuración
- make backup    # Backup de configuración

Documentación completa:
- docs/usage.md
- dev-docs/README.md
NEXTSTEPS
    echo -e "${NC}"
}

main() {
    echo -e "${BLUE}🏥 Neovim for Nurses - Setup Script${NC}"
    echo -e "${BLUE}=================================${NC}"
    echo

    validate_prerequisites "neovim"

    if [[ "$INSTALL_MODE" == "true" ]]; then
        backup_existing_config
        install_n4n_config
        setup_clinic_templates
        install_plugins
        validate_installation
        show_next_steps
    else
        echo -e "${GREEN}✅ Setup del entorno completado${NC}"
        echo -e "${YELLOW}💡 Usa --install para instalar la configuración completa de N4N${NC}"
    fi
}

main "$@"