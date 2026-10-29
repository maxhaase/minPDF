#!/usr/bin/env bash
# Master build script. Usage: ./build.sh [deb|rpm|win|all]
set -euo pipefail
cd "$(dirname "$0")"
TARGET="${1:-all}"

build_deb() { echo "=== Building .deb ==="; ./packaging/deb/build.sh; }
build_rpm() { echo "=== Building .rpm ==="; ./packaging/rpm/build.sh; }
build_win() { echo "=== Building Windows ==="; ./packaging/windows/build.sh; }

case "$TARGET" in
    deb) build_deb ;;
    rpm) build_rpm ;;
    win) build_win ;;
    all)
        build_deb
        command -v rpmbuild >/dev/null && build_rpm || echo "Skipping rpm (rpmbuild missing)."
        build_win
        ;;
    *) echo "Usage: $0 [deb|rpm|win|all]"; exit 1 ;;
esac
