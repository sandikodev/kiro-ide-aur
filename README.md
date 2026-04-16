# kiro-ide-bin

AUR package for [Kiro IDE](https://kiro.dev) — an agentic AI IDE with spec-driven development from prototype to production.

## About

This package installs Kiro IDE from the **official upstream `.tar.gz`** provided by Amazon, sourced directly from:

```
https://prod.download.desktop.kiro.dev/releases/stable/linux-x64/signed/$pkgver/tar/
```

Unlike the existing `kiro-ide` AUR package which uses `.deb`, this package:
- Extracts directly from the upstream tar.gz — no `ar`/`dpkg-deb` needed
- Verifies the download using Amazon's official `certificate.pem` + `signature.bin`
- Installs to `/opt/Kiro` with a symlink at `/usr/bin/kiro`
- Includes `.desktop` entries, shell completions (bash/zsh), and icon

## Installation

### Using yay
```bash
yay -S kiro-ide-bin
```

### Using paru
```bash
paru -S kiro-ide-bin
```

### Manual
```bash
git clone https://github.com/sandikodev/kiro-ide-bin.git
cd kiro-ide-bin
makepkg -si
```

## Checking for Updates

This repo includes `.nvchecker.toml` to track upstream releases:

```bash
nvchecker -c .nvchecker.toml
```

Or manually:
```bash
curl -s https://prod.download.desktop.kiro.dev/stable/metadata-linux-x64-stable.json | jq -r .currentRelease
```

## License

By installing Kiro IDE, you agree to:
- [AWS Customer Agreement](https://aws.amazon.com/agreement/)
- [AWS Intellectual Property License](https://aws.amazon.com/legal/aws-ip-license-terms/)
- [AWS Service Terms](https://aws.amazon.com/service-terms/)
- [AWS Privacy Notice](https://aws.amazon.com/privacy/)
