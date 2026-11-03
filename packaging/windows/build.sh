#!/usr/bin/env bash
set -euo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"
ROOT="$(cd "$HERE/../.." && pwd)"
VERSION=$(cat "$ROOT/VERSION" 2>/dev/null || echo "1.0.0")
OUT="$ROOT/build/windows"
rm -rf "$OUT"
mkdir -p "$OUT/bin" "$ROOT/dist"
cp "$ROOT/src/minpdf.bat" "$OUT/"
cd "$OUT"
zip -r "$ROOT/dist/minpdf-${VERSION}-portable.zip" . >/dev/null
echo "Built portable: dist/minpdf-${VERSION}-portable.zip"
