.PHONY: help install setup backup restore validate clean test doctor

help: ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

install: ## Install N4N Neovim configuration
	@echo "Installing Neovim for Nurses configuration..."
	@./scripts/setup.sh --install

setup: ## Initial setup and installation
	@echo "Setting up Neovim for Nurses..."
	@./scripts/setup.sh

backup: ## Backup current Neovim configuration
	@echo "Backing up current Neovim configuration..."
	@mkdir -p ~/.config/nvim.backup
	@cp -r ~/.config/nvim/* ~/.config/nvim.backup/ 2>/dev/null || true
	@echo "Backup completed at ~/.config/nvim.backup"

restore: ## Restore from backup
	@echo "Restoring from backup..."
	@if [ -d ~/.config/nvim.backup ]; then \
		cp -r ~/.config/nvim.backup/* ~/.config/nvim/; \
		echo "Configuration restored from backup"; \
	else \
		echo "No backup found at ~/.config/nvim.backup"; \
	fi

validate: ## Validate Neovim configuration syntax
	@echo "Validating N4N configuration..."
	@./scripts/validate-architecture.sh

test: ## Test clinical features
	@echo "Testing N4N clinical features..."
	@nvim --headless -c 'lua require("config").test_clinical()' -c 'quit' 2>/dev/null || echo "Tests require Neovim installation"

doctor: ## Check system requirements and configuration
	@echo "Neovim for Nurses - System Doctor"
	@echo "=================================="
	@echo "Checking Neovim installation..."
	@nvim --version | head -1 || echo "❌ Neovim not found"
	@echo ""
	@echo "Checking Lua configuration..."
	@nvim --headless -c 'lua print("✅ Lua working")' -c 'quit' 2>/dev/null || echo "❌ Lua not working"
	@echo ""
	@echo "Checking N4N configuration..."
	@[ -f ~/.config/nvim/config/init.lua ] && echo "✅ N4N configuration found" || echo "❌ N4N configuration not found"

clean: ## Clean temporary files and backups
	@echo "Cleaning temporary files..."
	@find ~/.config/nvim -name "*.swp" -delete 2>/dev/null || true
	@find ~/.config/nvim -name "*.swo" -delete 2>/dev/null || true
	@find ~/.config/nvim -name "*~" -delete 2>/dev/null || true
	@echo "Cleanup completed"

reset: clean backup setup ## Clean, backup and reset configuration

logs: ## Show Neovim configuration logs
	@echo "Configuration logs (last 50 lines):"
	@tail -50 ~/.local/share/nvim/log/nvim.log 2>/dev/null || echo "No logs found"
	$(COMPOSE) down
