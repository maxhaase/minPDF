#!/usr/bin/env bash
set -euo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"
ROOT="$(cd "$HERE/../.." && pwd)"
VERSION=$(cat "$ROOT/VERSION")
STAGE="$ROOT/build/deb/minpdf_${VERSION}_all"

rm -rf "$STAGE"
mkdir -p "$STAGE/DEBIAN" "$STAGE/usr/bin" \
         "$STAGE/usr/share/nautilus/scripts" \
         "$STAGE/usr/share/kio/servicemenus" \
         "$STAGE/usr/share/doc/minpdf"

sed "s/@VERSION@/$VERSION/" "$HERE/DEBIAN/control.in" > "$STAGE/DEBIAN/control"
install -m 755 "$HERE/DEBIAN/postinst" "$STAGE/DEBIAN/postinst"

install -m 755 "$ROOT/src/minpdf"     "$STAGE/usr/bin/minpdf"
install -m 755 "$ROOT/src/minpdf-gui" "$STAGE/usr/bin/minpdf-gui"

# Nautilus script: symlink so it always tracks the installed binary
ln -sf /usr/bin/minpdf-gui "$STAGE/usr/share/nautilus/scripts/minPDF-Compress"


















mkdir -p "$STAGE/usr/share/nautilus-python/extensions"

install -m 644 "$ROOT/src/minpdf-nautilus.py" "$STAGE/usr/share/nautilus-python/extensions/minpdf-nautilus.py"

install -m 644 "$ROOT/src/minpdf.desktop" \
    "$STAGE/usr/share/kio/servicemenus/minpdf.desktop"

install -m 644 "$ROOT/README.md" "$STAGE/usr/share/doc/minpdf/README.md" 2>/dev/null || true

mkdir -p "$ROOT/dist"
dpkg-deb --build --root-owner-group "$STAGE" \
    "$ROOT/dist/minpdf_${VERSION}_all.deb"
echo "Built: dist/minpdf_${VERSION}_all.deb"
