#!/bin/sh
# Copies the MCP server's tools/list (the backend's golden file) into the
# eval mocks, so mocked tools carry the real names, descriptions and inputs.
# Usage: scripts/sync-tools.sh <cubecen-backend checkout>
set -e
src="${1:?usage: scripts/sync-tools.sh <cubecen-backend checkout>}/internal/mcpserver/testdata/tools.json"
[ -f "$src" ] || { echo "no $src" >&2; exit 1; }
dst="$(dirname "$0")/../plugins/cubecen/evals/mocks/cubecen/_tools.json"
mkdir -p "$(dirname "$dst")"
cp "$src" "$dst"
echo "copied $(grep -c '"name": "[a-z_]*",$' "$dst" 2>/dev/null || true) entries to $dst"
