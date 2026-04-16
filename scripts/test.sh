#!/usr/bin/env bash
# test.sh — validate PKGBUILD locally before pushing
# Usage: ./scripts/test.sh
set -euo pipefail

cd "$(dirname "$0")/.."

echo "==> [1/3] namcap lint"
PYENV_VERSION=system namcap PKGBUILD && echo "namcap: OK"

echo ""
echo "==> [2/3] .SRCINFO sync check"
CURRENT_SRCINFO=$(cat .SRCINFO)
GENERATED=$(PYENV_VERSION=system makepkg --printsrcinfo 2>/dev/null)
if [[ "$CURRENT_SRCINFO" == "$GENERATED" ]]; then
    echo ".SRCINFO: in sync"
else
    echo "ERROR: .SRCINFO is out of sync with PKGBUILD. Run: makepkg --printsrcinfo > .SRCINFO"
    diff <(echo "$CURRENT_SRCINFO") <(echo "$GENERATED") || true
    exit 1
fi

echo ""
echo "==> [3/3] verifysource (uses cached sources if available)"
SRCDEST="${SRCDEST:-/tmp/kiro-srcdest}"
mkdir -p "$SRCDEST"

# symlink existing tar.gz if found locally to avoid re-download
PKGVER=$(grep '^pkgver=' PKGBUILD | cut -d= -f2)
PKGNAME=kiro-ide
for f in \
    "$HOME/Downloads/kiro-ide/${PKGNAME}-${PKGVER}-stable-linux-x64.tar.gz" \
    "/tmp/${PKGNAME}-${PKGVER}-stable-linux-x64.tar.gz"; do
    if [[ -f "$f" ]]; then
        ln -sf "$f" "$SRCDEST/${PKGNAME}-${PKGVER}.tar.gz" 2>/dev/null || true
        echo "Using cached tar.gz: $f"
        break
    fi
done

SRCDEST="$SRCDEST" PYENV_VERSION=system makepkg --verifysource --noprepare

echo ""
echo "==> All checks passed!"
