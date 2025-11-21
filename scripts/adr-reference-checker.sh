#!/bin/bash
# ADR Reference Checker Script
# Helps agents find relevant ADRs for their current work

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

ADR_DIR="dev-docs/ADR"

# help displays usage information, available commands with brief descriptions, and examples for the ADR Reference Checker.
help() {
    echo -e "${BLUE}ADR Reference Checker - Kit Fundador v2.0${NC}"
    echo ""
    echo "Usage: $0 [command] [options]"
    echo ""
    echo "Commands:"
    echo "  check-keyword <term>     Check if ADRs exist for keyword"
    echo "  suggest <task>          Suggest ADRs for common tasks"
    echo "  list                    List all available ADRs"
    echo "  current-task            Check ADRs for current git changes"
    echo "  help                   Show this help"
    echo ""
    echo "Examples:"
    echo "  $0 check-keyword database"
    echo "  $0 suggest 'implement user authentication'"
    echo "  $0 current-task"
}

# check_keyword searches ADR files in ADR_DIR for a given keyword and prints matching filenames with line-numbered context.
# If no keyword is provided it prints usage and exits; if no matches are found it prints suggestions to run adr-helper.sh check-required or create.
check_keyword() {
    local keyword="$1"
    if [ -z "$keyword" ]; then
        echo -e "${RED}Error: Keyword required${NC}"
        echo "Usage: $0 check-keyword <keyword>"
        exit 1
    fi

    echo -e "${GREEN}Searching ADRs for keyword: '$keyword'${NC}"
    echo ""

    found=false
    for adr in "$ADR_DIR"/ADR-*.md; do
        if [ -f "$adr" ]; then
            if grep -i -q "$keyword" "$adr"; then
                echo -e "${YELLOW}Found in $(basename "$adr"):${NC}"
                echo "$(basename "$adr"):"
                grep -i -n -C 2 "$keyword" "$adr" | sed 's/^/  /'
                echo ""
                found=true
            fi
        fi
    done

    if [ "$found" = false ]; then
        echo -e "${RED}No ADRs found for keyword: '$keyword'${NC}"
        echo ""
        echo -e "${BLUE}Suggestion:${NC} Check if this decision requires an ADR:"
        echo "./scripts/adr-helper.sh check-required"
        echo ""
        echo "Or create a new ADR:"
        echo "./scripts/adr-helper.sh create"
    fi
}

# suggest prints ADR suggestions for a given task keyword, showing shell commands to search existing ADRs and listing common ADR topics relevant to the task.
suggest() {
    local task="$1"
    echo -e "${GREEN}ADR Suggestions for task: '$task'${NC}"
    echo ""

    # Define suggestions based on common tasks
    case "$task" in
        *"database"*|*"migration"*|*"schema"*)
            echo -e "${BLUE}Check existing ADRs:${NC}"
            echo "  find $ADR_DIR -name 'ADR*.md' -exec grep -l -i 'database\|migration\|schema' {} \;"
            echo ""
            echo -e "${BLUE}Common ADR topics:${NC}"
            echo "  - Database selection (PostgreSQL, MongoDB, etc.)"
            echo "  - Migration strategy"
            echo "  - Data modeling approach"
            ;;
        *"auth"*|*"login"*|*"security"*)
            echo -e "${BLUE}Check existing ADRs:${NC}"
            echo "  find $ADR_DIR -name 'ADR*.md' -exec grep -l -i 'auth\|security\|login' {} \;"
            echo ""
            echo -e "${BLUE}Common ADR topics:${NC}"
            echo "  - Authentication method (JWT, OAuth, etc.)"
            echo "  - Authorization model"
            echo "  - Password hashing strategy"
            echo "  - Session management"
            ;;
        *"api"*|*"rest"*|*"graphql"*)
            echo -e "${BLUE}Check existing ADRs:${NC}"
            echo "  find $ADR_DIR -name 'ADR*.md' -exec grep -l -i 'api\|rest\|graphql' {} \;"
            echo ""
            echo -e "${BLUE}Common ADR topics:${NC}"
            echo "  - API design pattern"
            echo "  - REST vs GraphQL"
            echo "  - API versioning"
            echo "  - Error handling strategy"
            ;;
        *"test"*|*"testing"*)
            echo -e "${BLUE}Check existing ADRs:${NC}"
            echo "  find $ADR_DIR -name 'ADR*.md' -exec grep -l -i 'test\|testing\|tdd' {} \;"
            echo ""
            echo -e "${BLUE}Common ADR topics:${NC}"
            echo "  - Testing framework choice"
            echo "  - Test organization"
            echo "  - Test data management"
            echo "  - CI/CD testing integration"
            ;;
        *"deploy"*|*"docker"*|*"k8s"*)
            echo -e "${BLUE}Check existing ADRs:${NC}"
            echo "  find $ADR_DIR -name 'ADR*.md' -exec grep -l -i 'deploy\|docker\|k8s\|infra' {} \;"
            echo ""
            echo -e "${BLUE}Common ADR topics:${NC}"
            echo "  - Deployment strategy"
            echo "  - Containerization approach"
            echo "  - Orchestration (Docker Compose vs K8s)"
            echo "  - Environment configuration"
            ;;
        *)
            echo -e "${BLUE}General suggestions:${NC}"
            echo "  Search existing ADRs: ./scripts/adr-helper.sh list"
            echo "  Check if ADR required: ./scripts/adr-helper.sh check-required"
            echo "  Create new ADR: ./scripts/adr-helper.sh create"
            ;;
    esac
}

# list_adrs lists available Architecture Decision Records in $ADR_DIR, printing each ADR filename, a derived human-readable Title, an excerpt of the first "## Context" line when present, and then a total count or a suggestion to create an ADR if none are found.
list_adrs() {
    echo -e "${GREEN}Available Architecture Decision Records:${NC}"
    echo ""

    if [ ! -d "$ADR_DIR" ]; then
        echo -e "${RED}Error: ADR directory not found ($ADR_DIR)${NC}"
        exit 1
    fi

    count=0
    for adr in "$ADR_DIR"/ADR-*.md; do
        if [ -f "$adr" ]; then
            ((count++))
            basename "$adr"
            # Extract title
            title=$(basename "$adr" | sed 's/ADR-[0-9]*-//' | sed 's/-/ /g' | sed 's/\b\w/\u&/g')
            echo -e "  ${YELLOW}Title:${NC} $title"
            # Extract first line of context
            if grep -q "^## Context" "$adr"; then
                echo -e "  ${YELLOW}Context:${NC} $(grep -A 1 "^## Context" "$adr" | tail -n 1 | sed 's/^.*: //' | cut -c1-80)"
            fi
            echo ""
        fi
    done

    if [ $count -eq 0 ]; then
        echo -e "${YELLOW}No ADRs found. Create your first ADR:${NC}"
        echo "  ./scripts/adr-helper.sh create"
    else
        echo -e "${BLUE}Total ADRs: $count${NC}"
    fi
}

# current_task checks the working tree for relevant changes and suggests ADR actions based on git status (e.g., package.json, Dockerfile/docker, API files) or provides manual guidance when not in a git repository.
current_task() {
    echo -e "${GREEN}Checking ADRs for current task...${NC}"
    echo ""

    # Get git status if available
    if command -v git >/dev/null 2>&1 && [ -d ".git" ]; then
        echo -e "${BLUE}Current git status:${NC}"
        git status --porcelain | head -5
        echo ""

        # Analyze changed files for potential ADR requirements
        echo -e "${BLUE}Analyzing changes for ADR requirements...${NC}"

        # Check for package.json changes
        if git status --porcelain | grep -q "package.json"; then
            echo -e "${YELLOW}Package.json changed${NC} - Check if ADR required for technology changes"
            echo "  ./scripts/adr-helper.sh check-required"
            echo ""
        fi

        # Check for Docker changes
        if git status --porcelain | grep -q -E "(docker|Dockerfile)"; then
            echo -e "${YELLOW}Docker changes detected${NC} - Check ADR_DECISION_MATRIX.md"
            echo "  ./scripts/adr-helper.sh search docker"
            echo ""
        fi

        # Check for new API files
        if git status --porcelain | grep -q -E "(routes|api|controllers)"; then
            echo -e "${YELLOW}API changes detected${NC} - Check for ADR references"
            echo "  ./scripts/adr-helper.sh search api"
            echo ""
        fi
    else
        echo -e "${RED}Not in a git repository${NC}"
        echo ""
        echo -e "${BLUE}Manual check:${NC}"
        echo "  ./scripts/adr-helper.sh check-required"
        echo "  ./scripts/adr-helper.sh list"
    fi
}

# Main command routing
case "${1:-help}" in
    check-keyword)
        check_keyword "$2"
        ;;
    suggest)
        suggest "$2"
        ;;
    list)
        list_adrs
        ;;
    current-task)
        current_task
        ;;
    help|--help|-h)
        help
        ;;
    *)
        echo -e "${RED}Unknown command: $1${NC}"
        echo ""
        help
        exit 1
        ;;
esac