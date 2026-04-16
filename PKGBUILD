# Maintainer: sandikodev <androxoss at hotmail dot com>

pkgname=kiro-ide-bin
pkgver=0.11.131
pkgrel=1
epoch=1
pkgdesc='An agentic AI IDE with spec-driven development from prototype to production'
arch=(x86_64)
url='https://kiro.dev/'
# By downloading and using Kiro, you agree to the following:
#   AWS Customer Agreement: https://aws.amazon.com/agreement/
#   AWS Intellectual Property License: https://aws.amazon.com/legal/aws-ip-license-terms/
#   Service Terms: https://aws.amazon.com/service-terms/
#   Privacy Notice: https://aws.amazon.com/privacy/
license=(LicenseRef-Kiro)
depends=(alsa-lib
         at-spi2-core
         bash
         cairo
         curl
         dbus
         expat
         glib2
         glibc
         gtk3
         libcups
         libgcc
         libsecret
         libsoup3
         libstdc++
         libx11
         libxcb
         libxcomposite
         libxdamage
         libxext
         libxfixes
         libxkbcommon
         libxkbfile
         libxrandr
         mesa
         nspr
         nss
         openssl
         pango
         systemd-libs
         util-linux-libs)
conflicts=(kiro kiro-ide kiro-ide-deb)
options=(!debug !strip)
_pkgname=kiro-ide
_baseurl=https://prod.download.desktop.kiro.dev/releases/stable/linux-x64/signed/$pkgver/tar
source=("$_pkgname-$pkgver.tar.gz::$_baseurl/$_pkgname-$pkgver-stable-linux-x64.tar.gz"
        "$_pkgname-$pkgver-tar-signature.bin::$_baseurl/signature.bin"
        "$_pkgname-$pkgver-certificate.pem::$_baseurl/certificate.pem"
        "Kiro-LICENSE.txt")
b2sums=('6702966b9eeff3603e83dd3b83380d057c55778587753500c1af60db0c4edc08d120a5851cf3ef3f2972f7e128abba09e17b9630e81e0c70b8dc4346367f3e33'
        '416a2bc69782564765f36085214766b13ab8ab1a4d3644e75876311637f93e6f735498d6cfb112410b4260ed378de1a9269ab3f3a3bdfd494fac047d91e442c4'
        '4cba4d51523a883653b28e04abc4a0e444d7672636153be9c99058b4469137ab2c591466d9452c5471e1577c6ce9a54edca28f14c01e6d66b36b72eb53f92bc8'
        'cdf6d0032fa207b2a54079a5680557cff053daa63ae21ec312272b0b84740ff6a88688f37300ad382c7005d22c1d1abbd083eaa017b9259e6e71fb3f3a7b7838')

verify() {
    cd "$SRCDEST"
    openssl x509 -pubkey -noout -in $_pkgname-$pkgver-certificate.pem > kiro-pubkey.pem
    openssl dgst -sha256 -verify kiro-pubkey.pem -signature $_pkgname-$pkgver-tar-signature.bin \
        $_pkgname-$pkgver.tar.gz
}

package() {
    install -d "$pkgdir/opt/Kiro"
    cp -a Kiro/* "$pkgdir/opt/Kiro/"

    install -d "$pkgdir/usr/bin/"
    ln -s /opt/Kiro/bin/kiro "$pkgdir/usr/bin/kiro"

    install -Dm644 "$srcdir/Kiro-LICENSE.txt" "$pkgdir/usr/share/licenses/$pkgname/LICENSE.txt"
    ln -s /opt/Kiro/LICENSES.chromium.html "$pkgdir/usr/share/licenses/$pkgname/LICENSES.chromium.html"

    # Desktop entry (not bundled in tar.gz, unlike deb)
    install -Dm644 /dev/stdin "$pkgdir/usr/share/applications/kiro.desktop" << 'EOF'
[Desktop Entry]
Name=Kiro
Comment=An agentic AI IDE with spec-driven development from prototype to production
GenericName=Text Editor
Exec=/opt/Kiro/bin/kiro %F
Icon=kiro
Type=Application
StartupNotify=true
StartupWMClass=Kiro
Categories=TextEditor;Development;IDE;
MimeType=text/plain;inode/directory;application/x-kiro-workspace;
Actions=new-empty-window;
Keywords=kiro;

[Desktop Action new-empty-window]
Name=New Empty Window
Exec=/opt/Kiro/bin/kiro --new-window %F
Icon=kiro
EOF

    install -Dm644 /dev/stdin "$pkgdir/usr/share/applications/kiro-url-handler.desktop" << 'EOF'
[Desktop Entry]
Name=Kiro - URL Handler
Comment=Kiro URL Handler
Exec=/opt/Kiro/bin/kiro --open-url %U
Icon=kiro
Type=Application
NoDisplay=true
StartupNotify=true
MimeType=x-scheme-handler/kiro;
EOF

    install -Dm644 Kiro/resources/app/resources/linux/code.png \
        "$pkgdir/usr/share/pixmaps/kiro.png"

    install -Dm644 Kiro/resources/completions/bash/kiro \
        "$pkgdir/usr/share/bash-completion/completions/kiro"
    install -Dm644 Kiro/resources/completions/zsh/_kiro \
        "$pkgdir/usr/share/zsh/site-functions/_kiro"
}
