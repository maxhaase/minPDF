#!/usr/bin/env bash
set -euo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"
ROOT="$(cd "$HERE/../.." && pwd)"
VERSION=$(cat "$ROOT/VERSION")
OUT="$ROOT/build/windows"
PORTABLE="$ROOT/dist/minpdf-${VERSION}-portable.zip"

rm -rf "$OUT"
mkdir -p "$OUT/bin"

cp "$ROOT/src/minpdf.bat" "$OUT/"
cp "$ROOT/README.md"      "$OUT/README.txt" 2>/dev/null || true

mkdir -p "$ROOT/dist"
( cd "$OUT" && zip -r "$PORTABLE" . >/dev/null )
echo "Built portable: dist/minpdf-${VERSION}-portable.zip"

if command -v makensis >/dev/null; then
    ( cd "$OUT" && makensis -DVERSION="$VERSION" \
        "$HERE/installer.nsi" )
    [ -f "$OUT/minpdf-${VERSION}-setup.exe" ] && \
        cp "$OUT/minpdf-${VERSION}-setup.exe" "$ROOT/dist/"
    echo "Built installer: dist/minpdf-${VERSION}-setup.exe"
else
    echo "makensis not installed — skipped .exe installer (portable ZIP only)."
    echo "  Install: sudo apt install nsis   (or: sudo dnf install mingw32-nsis)"
fi
