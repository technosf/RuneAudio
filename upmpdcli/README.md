## upmpdcli

An UPnP Audio Media Renderer based on MPD. [upmpdcli](https://www.lesbonscomptes.com/upmpdcli/)
```sh
pacman -Syu
pacman -S --needed base-devel aspell-en id3lib git jsoncpp libmicrohttpd libmpdclient libupnp python-bottle python-mutagen python-requests python-setuptools python-waitress recoll

# utilize 4 cores of cpu
sed -i 's/.*MAKEFLAGS=.*/MAKEFLAGS="-j4"/' /etc/makepkg.conf

su alarm
cd

# libupnpp - depend
curl -O https://aur.archlinux.org/cgit/aur.git/snapshot/libupnpp.tar.gz
bsdtar xf libupnpp.tar.gz
rm libupnpp.tar.gz
cd libupnpp

sed -i "s/^arch=.*/arch=('any')/" PKGBUILD

makepkg

su
pacman -U /home/alarm/libupnpp/libupnpp*.pkg.tar.xz
su alarm
cd

curl -O https://aur.archlinux.org/cgit/aur.git/snapshot/upmpdcli.tar.gz
bsdtar xf upmpdcli.tar.gz
rm upmpdcli.tar.gz
cd upmpdcli

sed -i -e "s/^arch=.*/arch=('any')/" -e "s/'mutagen' //" PKGBUILD

makepkg
```
