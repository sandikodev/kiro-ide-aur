#!/usr/bin/env bash
# update.sh — update PKGBUILD to latest upstream version
# Usage: ./scripts/update.sh [version]
set -euo pipefail

PKGBUILD="$(dirname "$0")/../PKGBUILD"
METADATA_URL="https://prod.download.desktop.kiro.dev/stable/metadata-linux-x64-stable.json"

CURRENT=$(grep '^pkgver=' "$PKGBUILD" | cut -d= -f2)
LATEST=${1:-$(curl -s "$METADATA_URL" | jq -r .currentRelease)}

if [[ "$CURRENT" == "$LATEST" ]]; then
    echo "Already up to date: $CURRENT"
    exit 0
fi

echo "Updating $CURRENT -> $LATEST"

BASE="https://prod.download.desktop.kiro.dev/releases/stable/linux-x64/signed/${LATEST}/tar"
TMPDIR=$(mktemp -d)
trap 'rm -rf "$TMPDIR"' EXIT

echo "Downloading sources for hashing..."
curl -L --progress-bar "$BASE/kiro-ide-${LATEST}-stable-linux-x64.tar.gz" -o "$TMPDIR/kiro.tar.gz"
curl -sL "$BASE/signature.bin" -o "$TMPDIR/signature.bin"
curl -sL "$BASE/certificate.pem" -o "$TMPDIR/certificate.pem"

echo "Computing b2sums..."
B2_TAR=$(b2sum "$TMPDIR/kiro.tar.gz" | cut -d' ' -f1)
B2_SIG=$(b2sum "$TMPDIR/signature.bin" | cut -d' ' -f1)
B2_CERT=$(b2sum "$TMPDIR/certificate.pem" | cut -d' ' -f1)
B2_LIC=$(b2sum "$(dirname "$0")/../Kiro-LICENSE.txt" | cut -d' ' -f1)

echo "Verifying signature..."
openssl x509 -pubkey -noout -in "$TMPDIR/certificate.pem" > "$TMPDIR/pubkey.pem"
openssl dgst -sha256 -verify "$TMPDIR/pubkey.pem" \
    -signature "$TMPDIR/signature.bin" "$TMPDIR/kiro.tar.gz"

echo "Patching PKGBUILD..."
sed -i "s/^pkgver=.*/pkgver=${LATEST}/" "$PKGBUILD"
sed -i "s/^pkgrel=.*/pkgrel=1/" "$PKGBUILD"

python3 - <<EOF
import re

with open('$PKGBUILD') as f:
    content = f.read()

new_b2sums = """b2sums=('${B2_TAR}'
        '${B2_SIG}'
        '${B2_CERT}'
        '${B2_LIC}')"""

content = re.sub(r"b2sums=\(.*?\)", new_b2sums, content, flags=re.DOTALL)

with open('$PKGBUILD', 'w') as f:
    f.write(content)
EOF

echo "Regenerating .SRCINFO..."
cd "$(dirname "$0")/.." && makepkg --printsrcinfo > .SRCINFO

echo "Done. Review changes with: git diff"
