#!/bin/bash
# Architecture Validation Script for N4N
# Validates project structure, dependencies, and basic architectural rules

set -e

echo "🏗️ Validating N4N Architecture..."

SCORE=0
TOTAL=100

# Check package structure
echo "📦 Checking package structure..."
if [ -d "packages/editor-core" ] && [ -d "packages/n4n-engine" ]; then
  SCORE=$((SCORE + 20))
  echo "✅ Core packages exist: +20 (Score: $SCORE/$TOTAL)"
else
  echo "❌ Core packages missing"
fi

# Check TypeScript configuration
echo "🔧 Checking TypeScript configuration..."
if [ -f "tsconfig.json" ]; then
  SCORE=$((SCORE + 10))
  echo "✅ Root tsconfig.json exists: +10 (Score: $SCORE/$TOTAL)"
else
  echo "❌ Root tsconfig.json missing"
fi

# Run TypeScript type checking
echo "🔍 Running TypeScript type check..."
if pnpm type-check >/dev/null 2>&1; then
  SCORE=$((SCORE + 30))
  echo "✅ Type checking passed: +30 (Score: $SCORE/$TOTAL)"
else
  echo "❌ Type checking failed"
fi

# Run linter
echo "🧹 Running ESLint..."
if pnpm lint >/dev/null 2>&1; then
  SCORE=$((SCORE + 20))
  echo "✅ Linting passed: +20 (Score: $SCORE/$TOTAL)"
else
  echo "⚠️  Linting issues detected (non-critical)"
  SCORE=$((SCORE + 10))
fi

# Check build
echo "🔨 Checking build..."
if pnpm build >/dev/null 2>&1; then
  SCORE=$((SCORE + 20))
  echo "✅ Build successful: +20 (Score: $SCORE/$TOTAL)"
else
  echo "❌ Build failed"
fi

# Final score
echo ""
echo "🎯 Final Architecture Validation Score: $SCORE/$TOTAL ($(( SCORE * 100 / TOTAL ))%)"

if [ $SCORE -ge 80 ]; then
  echo "✅ PASSED: Architecture validation successful"
  exit 0
else
  echo "❌ FAILED: Architecture validation score < 80%"
  echo "💡 Review failing validations before proceeding"
  exit 1
fi
