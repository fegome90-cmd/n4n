#!/bin/bash
# Neovim for Nurses - Architecture Validation Script
# Basado en Kit Fundador v2.0 - Adaptado para configuración Neovim

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

FAILED_CHECKS=0
TOTAL_CHECKS=0

log_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

log_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

log_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

log_error() {
    echo -e "${RED}❌ $1${NC}"
    ((FAILED_CHECKS++))
}

check_file() {
    local file=$1
    local description=$2
    ((TOTAL_CHECKS++))

    if [[ -f "$file" ]]; then
        log_success "$description encontrado: $file"
        return 0
    else
        log_error "$description no encontrado: $file"
        return 1
    fi
}

check_directory() {
    local dir=$1
    local description=$2
    ((TOTAL_CHECKS++))

    if [[ -d "$dir" ]]; then
        log_success "$description encontrado: $dir"
        return 0
    else
        log_error "$description no encontrado: $dir"
        return 1
    fi
}

check_lua_syntax() {
    local file=$1
    local description=$2
    ((TOTAL_CHECKS++))

    if command -v nvim &> /dev/null; then
        if nvim --headless -c "luafile $file" -c 'quit' 2>/dev/null; then
            log_success "$description - Sintaxis válida"
            return 0
        else
            log_error "$description - Error de sintaxis"
            return 1
        fi
    else
        log_warning "$description - No se puede validar (nvim no disponible)"
        return 0
    fi
}

validate_project_structure() {
    log_info "Validando estructura del proyecto..."
    echo

    # Directorios principales
    check_directory "config" "Directorio de configuración"
    check_directory "templates" "Directorio de templates"
    check_directory "scripts" "Directorio de scripts"
    check_directory "dev-docs" "Documentación de desarrollo"

    # Archivos principales
    check_file "README.md" "README principal"
    check_file "CLAUDE.md" "Configuración de Claude Code"
    check_file "Makefile" "Makefile del proyecto"
    check_file "package.json" "Package JSON"

    echo
}

validate_neovim_config() {
    log_info "Validando configuración de Neovim..."
    echo

    # Configuración principal
    check_file "config/init.lua" "Configuración principal de Neovim"
    check_file "config/clinical.lua" "Configuración clínica"
    check_file "config/abbreviations.lua" "Abreviaciones médicas"

    # Validar sintaxis Lua si los archivos existen
    for file in config/init.lua config/clinical.lua config/abbreviations.lua; do
        if [[ -f "$file" ]]; then
            check_lua_syntax "$file" "Validación de sintaxis Lua: $(basename $file)"
        fi
    done

    echo
}

validate_clinical_templates() {
    log_info "Validando templates clínicos..."
    echo

    # Directorios de templates
    check_directory "templates/nursing-notes" "Templates de notas de enfermería"
    check_directory "templates/care-plans" "Templates de planes de cuidado"
    check_directory "templates/assessments" "Templates de evaluaciones"

    # Verificar si existen archivos de ejemplo
    local template_files=(
        "templates/nursing-notes/basic-note.lua"
        "templates/care-plans/standard-plan.lua"
        "templates/assessments/initial-assessment.lua"
    )

    for file in "${template_files[@]}"; do
        if [[ -f "$file" ]]; then
            log_success "Template encontrado: $(basename $file)"
        else
            log_warning "Template opcional no encontrado: $file"
        fi
    done

    echo
}

validate_dev_docs() {
    log_info "Validando documentación de desarrollo..."
    echo

    # Archivos core de dev-docs
    check_file "dev-docs/context.md" "Contexto del proyecto"
    check_file "dev-docs/plan.md" "Plan de desarrollo"
    check_file "dev-docs/task.md" "Log de tareas"
    check_file "dev-docs/consumer-checklist.md" "Checklist para consumidores"

    # Verificar estructura de directorios esperados
    check_directory "dev-docs/domain" "Documentación de dominio"
    check_directory "dev-docs/application" "Documentación de aplicación"

    echo
}

validate_makefile() {
    log_info "Validando Makefile..."
    echo

    ((TOTAL_CHECKS++))

    # Verificar que el Makefile tenga las reglas esperadas
    if [[ -f "Makefile" ]]; then
        local required_rules=("install" "setup" "validate" "test" "doctor")
        local missing_rules=()

        for rule in "${required_rules[@]}"; do
            if grep -q "^$rule:" Makefile; then
                log_success "Regla Makefile encontrada: $rule"
            else
                missing_rules+=("$rule")
            fi
        done

        if [[ ${#missing_rules[@]} -eq 0 ]]; then
            log_success "Makefile contiene todas las reglas requeridas"
        else
            log_warning "Makefile缺少 reglas: ${missing_rules[*]}"
        fi
    else
        log_error "Makefile no encontrado"
    fi

    echo
}

validate_scripts() {
    log_info "Validando scripts..."
    echo

    # Scripts principales
    check_file "scripts/setup.sh" "Script de setup"
    check_file "scripts/validate-architecture.sh" "Script de validación de arquitectura"

    # Verificar permisos de ejecución
    if [[ -x "scripts/setup.sh" ]]; then
        log_success "setup.sh tiene permisos de ejecución"
    else
        log_warning "setup.sh no tiene permisos de ejecución"
    fi

    if [[ -x "scripts/validate-architecture.sh" ]]; then
        log_success "validate-architecture.sh tiene permisos de ejecución"
    else
        log_warning "validate-architecture.sh no tiene permisos de ejecución"
    fi

    echo
}

validate_security_considerations() {
    log_info "Validando consideraciones de seguridad..."
    echo

    ((TOTAL_CHECKS++))

    # Verificar que no haya credenciales hardcodeadas
    local dangerous_patterns=("password" "secret" "token" "key")
    local config_files=(config/*.lua *.json *.env*)

    local found_issues=false
    for file in "${config_files[@]}"; do
        if [[ -f "$file" ]]; then
            for pattern in "${dangerous_patterns[@]}"; do
                if grep -i "$pattern" "$file" | grep -v "example" | grep -v "template" | grep -q "="; then
                    log_warning "Posible información sensible encontrada en $file"
                    found_issues=true
                fi
            done
        fi
    done

    if [[ "$found_issues" != "true" ]]; then
        log_success "No se detectaron problemas de seguridad obvios"
    fi

    echo
}

validate_healthcare_compliance() {
    log_info "Validando cumplimiento healthcare..."
    echo

    ((TOTAL_CHECKS++))

    # Verificar que exista documentación sobre HIPAA o compliance
    if [[ -f "docs/security.md" ]] || [[ -f "docs/compliance.md" ]] || grep -q -i "hipaa\|compliance\|security" README.md; then
        log_success "Documentación de compliance encontrada"
    else
        log_warning "Se recomienda agregar documentación de compliance healthcare"
    fi

    # Verificar templates médicos
    local medical_templates=($(find templates/ -name "*.lua" 2>/dev/null || true))
    if [[ ${#medical_templates[@]} -gt 0 ]]; then
        log_success "Templates médicos encontrados: ${#medical_templates[@]} archivos"
    else
        log_warning "No se encontraron templates médicos"
    fi

    echo
}

show_summary() {
    echo -e "${BLUE}"
    cat <<SUMMARY
========================================
Resumen de Validación de Arquitectura
========================================
SUMMARY
    echo -e "${NC}"

    if [[ $FAILED_CHECKS -eq 0 ]]; then
        echo -e "${GREEN}🎉 Todos los checks pasaron exitosamente! ($TOTAL_CHECKS/$TOTAL_CHECKS)${NC}"
        echo -e "${GREEN}✅ La arquitectura del proyecto N4N es válida${NC}"
        return 0
    else
        echo -e "${RED}❌ $FAILED_CHECKS de $TOTAL_CHECKS checks fallaron${NC}"
        echo -e "${YELLOW}⚠️  Se recomienda corregir los problemas antes de continuar${NC}"
        return 1
    fi
}

main() {
    echo -e "${BLUE}🏥 Neovim for Nurses - Architecture Validation${NC}"
    echo -e "${BLUE}===============================================${NC}"
    echo

    validate_project_structure
    validate_neovim_config
    validate_clinical_templates
    validate_dev_docs
    validate_makefile
    validate_scripts
    validate_security_considerations
    validate_healthcare_compliance

    show_summary
}

# Ejecutar validación
main "$@"
