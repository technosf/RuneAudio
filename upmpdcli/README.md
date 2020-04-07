## upmpdcli

An UPnP Audio Media Renderer based on MPD. [upmpdcli](https://www.lesbonscomptes.com/upmpdcli/)
```sh
pacman -Syu
pacman -S --needed base-devel aspell-en id3lib git jsoncpp libmicrohttpd libmpdclient libupnp python-bottle python-mutagen python-requests python-setuptools python-waitress recoll

# utilize all cpu cores
sed -i 's/.*MAKEFLAGS=.*/MAKEFLAGS="-j'$( nproc )'"/' /etc/makepkg.conf

su alarm
cd

# libupnpp - depend
curl -O https://aur.archlinux.org/cgit/aur.git/snapshot/libupnpp.tar.gz
bsdtar xf libupnpp.tar.gz
rm libupnpp.tar.gz
cd libupnpp

# get version from: https://framagit.org/medoc92/libupnpp
version=2.2
sed -i -e "s/^\(pkgver=\).*/\1$version/
" -e 's|^\(source=("\).*|\1https://framagit.org/medoc92/libupnpp/-/archive/master/libupnpp-master.tar.gz"|
' -e '/sha256sums=/ d
' PKGBUILD

makepkg -A

su
pacman -U /home/alarm/libupnpp/libupnpp*.pkg.tar.xz

su alarm
cd
curl -O https://aur.archlinux.org/cgit/aur.git/snapshot/upmpdcli.tar.gz
bsdtar xf upmpdcli.tar.gz
rm upmpdcli.tar.gz
cd upmpdcli
sed -i "s/'mutagen' //" PKGBUILD

makepkg -A
```
