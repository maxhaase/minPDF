#!/usr/bin/env bash
set -euo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"
ROOT="$(cd "$HERE/../.." && pwd)"
VERSION=$(cat "$ROOT/VERSION" 2>/dev/null || echo "1.0.0")
STAGE="$ROOT/build/deb/minpdf_${VERSION}_all"
rm -rf "$STAGE"
mkdir -p "$STAGE/DEBIAN" "$STAGE/usr/bin" "$STAGE/usr/share/nautilus-python/extensions" "$STAGE/usr/share/kio/servicemenus"
sed "s/@VERSION@/$VERSION/" "$HERE/DEBIAN/control.in" > "$STAGE/DEBIAN/control"
install -m 755 "$ROOT/src/minpdf" "$STAGE/usr/bin/minpdf"
install -m 755 "$ROOT/src/minpdf-gui" "$STAGE/usr/bin/minpdf-gui"
install -m 644 "$ROOT/src/minpdf-nautilus.py" "$STAGE/usr/share/nautilus-python/extensions/minpdf-nautilus.py"
install -m 644 "$ROOT/src/minpdf.desktop" "$STAGE/usr/share/kio/servicemenus/minpdf.desktop"
mkdir -p "$ROOT/dist"
dpkg-deb --build --root-owner-group "$STAGE" "$ROOT/dist/minpdf_${VERSION}_all.deb"
echo "Built: dist/minpdf_${VERSION}_all.deb"
