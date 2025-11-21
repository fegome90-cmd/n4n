# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## 🏗️ Project Overview

Neovim for Nurses (N4N) is a **comprehensive Neovim configuration bundle** designed for healthcare professionals and nurses. It streamlines digital documentation, patient care workflows, and clinical productivity with specialized tools and templates.

- **Editor**: Neovim 0.9+ with TypeScript tools
- **Purpose**: Clinical documentation and nursing workflow optimization
- **Specializations**: Medical templates, abbreviations, secure documentation
- **Features**: HIPAA-compliant tools, care plan templates, patient notes

## 🚀 Common Development Commands

### Setup & Installation
```bash
# Setup Neovim configuration
./scripts/setup.sh

# Backup existing Neovim config (recommended)
mv ~/.config/nvim ~/.config/nvim.backup

# Install N4N configuration
./scripts/setup.sh --install

# Update clinical templates
./scripts/setup.sh --update-templates
```

### Development Environment
```bash
# Start Neovim with N4N configuration
nvim

# Edit clinical templates
nvim ~/.config/nvim/templates/

# Update abbreviations
nvim ~/.config/nvim/config/abbreviations.lua

# Test configuration changes
nvim --headless -c 'Lua require("config").test()' -c 'quit'
```

### Testing
```bash
# Run all tests
make test
# Or: npm test

# Run specific test suites
npm run test:unit        # Unit tests only
npm run test:integration # Integration tests only
npm run test:e2e        # E2E tests only

# Run single test file
npm test -- tests/unit/domain/entities/User.test.ts

# Watch mode
npm run test:watch
# Or: make test-watch

# Coverage report (80% threshold enforced)
npm run test:coverage
# Or: make test-coverage

# Test setup script (harness)
npm run test:setup
# Or: make test:setup
```

### Build & Quality
```bash
# Build TypeScript
npm run build
# Or: tsc

# Linting
npm run lint
# Or: make lint

# Auto-fix linting issues
npm run lint:fix

# Format code
npm run format
# Or: make format

# Type checking
npm run type-check

# Validate architecture rules
make validate
```

### Database (PostgreSQL)
```bash
# Run migrations
make migrate
# Start Neovim with N4N configuration
nvim

# Edit clinical templates
nvim ~/.config/nvim/templates/

# Update abbreviations
nvim ~/.config/nvim/config/abbreviations.lua

# Test configuration changes
nvim --headless -c 'Lua require("config").test()' -c 'quit'
```

## 🏥 Healthcare-Specific Features

### Clinical Documentation
- **Templates**: Pre-built templates for patient notes, care plans, assessments
- **Abbreviations**: Medical terminology auto-expansion
- **Security**: HIPAA-compliant features and secure handling

### Nursing Workflow Integration
- **Quick Commands**: Fast access to common nursing tasks
- **Data Templates**: Standardized formats for patient information
- **Clinical Tools**: Built-in calculators and reference tools

## 🔧 Important Files & Configuration

### Neovim Configuration Files
- `config/init.lua`: Main Neovim configuration and initialization
- `config/clinical.lua`: Clinical-specific settings and workflows
- `config/abbreviations.lua`: Medical abbreviations and terminology
- `config/templates.lua`: Template management for clinical documents
- `config/plugins.lua`: Plugin configuration and management

### Helper Scripts
- `scripts/setup.sh`: Setup and installation script for N4N
- `scripts/validate-config.sh`: Validate Neovim configuration

### Template Structure
- `templates/`: Directory for clinical document templates
- `templates/nursing-notes/`: Patient note templates
- `templates/care-plans/`: Care plan templates
- `templates/assessments/`: Assessment templates

## 📋 Development Workflow

### 1. Configuration Customization
Personalize the configuration for your clinical environment:
```bash
# Edit main configuration
nvim ~/.config/nvim/config/

# Customize abbreviations
nvim ~/.config/nvim/config/abbreviations.lua

# Update templates
nvim ~/.config/nvim/templates/
```

### 2. Testing Configuration Changes
Always test configuration changes before deploying:
```bash
# Validate syntax
nvim --headless -c 'lua require("config").validate()' -c 'quit'

# Test clinical features
nvim --headless -c 'lua require("config").test_clinical()' -c 'quit'
```

### 3. Key Nursing Workflow Features
- **Medical Abbreviations**: Expand common nursing terms and abbreviations
- **Clinical Templates**: Quick access to standardized document formats
- **Security Features**: HIPAA-compliant handling of sensitive information
- **Quick Commands**: Streamlined workflows for common nursing tasks

## ⚠️ Important Notes

### Configuration Safety
- Always backup your existing Neovim configuration before installing N4N
- Test configuration changes in a safe environment before production use
- Ensure compliance with your healthcare facility's IT policies

### Security Considerations
- N4N is designed with healthcare data security in mind
- Follow your facility's guidelines for handling patient information
- Regularly update plugins and configurations for security patches

### Customization Guidelines
- Modify templates to match your facility's documentation requirements
- Customize abbreviations for your specialty area (ICU, ER, Pediatrics, etc.)
- Add specialty-specific workflows as needed

## 📚 Documentation Structure

Key documentation files:
- `README.md`: Project overview and quick start guide
- `docs/`: Extended documentation and user guides
- `config/`: Configuration files and customization options
- `templates/`: Clinical document templates

The project provides a professional foundation but requires consumers to replace placeholders and implement their specific business logic.