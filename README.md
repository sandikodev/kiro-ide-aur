# kiro-ide-bin

[![Update](https://github.com/sandikodev/kiro-ide-bin/actions/workflows/update.yml/badge.svg)](https://github.com/sandikodev/kiro-ide-bin/actions/workflows/update.yml)
[![Validate](https://github.com/sandikodev/kiro-ide-bin/actions/workflows/validate.yml/badge.svg)](https://github.com/sandikodev/kiro-ide-bin/actions/workflows/validate.yml)

AUR package for [Kiro IDE](https://kiro.dev) — an agentic AI IDE with spec-driven development from prototype to production.

> **Status**: Pending listing on AUR. Install via paru custom repo or manually (see below).

## About

Installs Kiro IDE from the **official upstream `.tar.gz`** — not `.deb`:

```
https://prod.download.desktop.kiro.dev/releases/stable/linux-x64/signed/$pkgver/tar/
```

- No `.deb` extraction — uses upstream tar.gz directly
- Verifies download with Amazon's `certificate.pem` + `signature.bin`
- Installs to `/opt/Kiro` with symlink at `/usr/bin/kiro`
- Includes `.desktop` entries, shell completions (bash/zsh), and icon
- Auto-updates via GitHub Actions every 6 hours

## Installation

### Option 1 — paru custom repo (recommended)

Add to `~/.config/paru/paru.conf`:

```ini
[sandikodev]
Url = https://github.com/sandikodev/kiro-ide-bin
```

Then sync and install:

```bash
paru -Sy --pkgbuilds
paru -S sandikodev/kiro-ide-bin
```

### Option 2 — manual

```bash
git clone https://github.com/sandikodev/kiro-ide-bin.git
cd kiro-ide-bin
makepkg -si
```

### Option 3 — once listed on AUR

```bash
yay -S kiro-ide-bin
# or
paru -S kiro-ide-bin
```

## For Contributors / Developers

### Requirements

```bash
sudo pacman -S base-devel namcap
pip install jq          # for nvchecker
sudo pacman -S nvchecker
```

### Check for upstream update

```bash
nvchecker -c .nvchecker.toml
# or
curl -s https://prod.download.desktop.kiro.dev/stable/metadata-linux-x64-stable.json | jq -r .currentRelease
```

### Update to new version

```bash
./scripts/update.sh           # auto-detect latest
./scripts/update.sh 0.11.131  # specific version
```

### Validate before pushing

```bash
./scripts/test.sh
```

This runs:
1. `namcap` — lint PKGBUILD
2. `.SRCINFO` sync check
3. `makepkg --verifysource` — checksum + signature verification

### Push to AUR

```bash
git remote add aur ssh://aur@aur.archlinux.org/kiro-ide-bin.git
git push aur main:master
```

## CI/CD

| Workflow | Trigger | What it does |
|---|---|---|
| `update.yml` | Every 6h + manual | Detects new version, updates hashes, pushes to GitHub + AUR |
| `validate.yml` | Push/PR to PKGBUILD | namcap lint, .SRCINFO sync, b2sums format check |

### Required GitHub Secrets

| Secret | Description |
|---|---|
| `AUR_SSH_KEY` | Private SSH key registered at aur.archlinux.org |

## License

By installing Kiro IDE, you agree to:
- [AWS Customer Agreement](https://aws.amazon.com/agreement/)
- [AWS Intellectual Property License](https://aws.amazon.com/legal/aws-ip-license-terms/)
- [AWS Service Terms](https://aws.amazon.com/service-terms/)
- [AWS Privacy Notice](https://aws.amazon.com/privacy/)
