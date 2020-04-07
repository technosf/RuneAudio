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
curl -O https://github.com/rern/RuneAudio/raw/master/upmpdcli/PKGBUILD

# get version from: https://www.lesbonscomptes.com/upmpdcli/downloads/

makepkg -A --skipinteg

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
