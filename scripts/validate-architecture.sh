#!/usr/bin/env bash
set -euo pipefail

echo "validate-architecture stub: TODO implement real checks"
echo "✅ Architecture: $(uname -m)"
echo "✅ Platform: $(uname -s)"
echo "✅ Node version: $(node --version)"
echo "✅ Package manager: $(pnpm --version)"

# Basic architecture validation
ARCH=$(uname -m)
if [[ "$ARCH" == "x86_64" || "$ARCH" == "arm64" ]]; then
  echo "✅ Supported architecture: $ARCH"
else
  echo "❌ Unsupported architecture: $ARCH"
  exit 1
fi

# Node version validation
NODE_VERSION=$(node --version | sed 's/v//')
if [[ "$(printf '%s\n' "20.10.0" "$NODE_VERSION" | sort -V | head -n1)" == "20.10.0" ]]; then
  echo "✅ Node version meets minimum: $NODE_VERSION"
else
  echo "❌ Node version below minimum: $NODE_VERSION (requires >=20.10.0)"
  exit 1
fi

echo "✅ validate-architecture: All checks passed"
exit 0