#!/usr/bin/env bash
set -euo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"
ROOT="$(cd "$HERE/../.." && pwd)"
VERSION=$(cat "$ROOT/VERSION" 2>/dev/null || echo "1.0.0")
TOPDIR="$ROOT/build/rpm"
rm -rf "$TOPDIR"
mkdir -p "$TOPDIR"/{BUILD,BUILDROOT,RPMS,SOURCES,SPECS,SRPMS}
SRCDIR="$TOPDIR/SOURCES/minpdf-$VERSION"
mkdir -p "$SRCDIR"
cp "$ROOT/src/minpdf" "$ROOT/src/minpdf-gui" "$SRCDIR/"
tar czf "$TOPDIR/SOURCES/minpdf-$VERSION.tar.gz" -C "$TOPDIR/SOURCES" "minpdf-$VERSION"
sed "s/@VERSION@/$VERSION/" "$HERE/minpdf.spec.in" > "$TOPDIR/SPECS/minpdf.spec"
rpmbuild --define "_topdir $TOPDIR" -ba "$TOPDIR/SPECS/minpdf.spec"
mkdir -p "$ROOT/dist"
find "$TOPDIR/RPMS" -name "*.rpm" -exec cp {} "$ROOT/dist/" \;
