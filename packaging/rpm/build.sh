#!/usr/bin/env bash
set -euo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"
ROOT="$(cd "$HERE/../.." && pwd)"
VERSION=$(cat "$ROOT/VERSION")

if ! command -v rpmbuild >/dev/null; then
    echo "rpmbuild not found. Install rpm-build / rpmdevtools." >&2
    exit 1
fi

TOPDIR="$ROOT/build/rpm"
rm -rf "$TOPDIR"
mkdir -p "$TOPDIR"/{BUILD,BUILDROOT,RPMS,SOURCES,SPECS,SRPMS}

# Stage sources
SRCDIR="$TOPDIR/SOURCES/minpdf-$VERSION"
mkdir -p "$SRCDIR"
cp "$ROOT/src/minpdf"          "$SRCDIR/"
cp "$ROOT/src/minpdf-gui"      "$SRCDIR/"
cp "$ROOT/src/minpdf.desktop"  "$SRCDIR/"
tar czf "$TOPDIR/SOURCES/minpdf-$VERSION.tar.gz" \
    -C "$TOPDIR/SOURCES" "minpdf-$VERSION"

# Render spec
sed "s/@VERSION@/$VERSION/" "$HERE/minpdf.spec.in" \
    > "$TOPDIR/SPECS/minpdf.spec"

rpmbuild --define "_topdir $TOPDIR" -ba "$TOPDIR/SPECS/minpdf.spec"

mkdir -p "$ROOT/dist"
find "$TOPDIR/RPMS" -name "*.rpm" -exec cp {} "$ROOT/dist/" \;
echo "Built:"
ls -1 "$ROOT"/dist/*.rpm
