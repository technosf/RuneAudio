## upmpdcli

An UPnP Audio Media Renderer based on MPD. [upmpdcli](https://www.lesbonscomptes.com/upmpdcli/)
```sh
pacman -Syu
pacman -S --needed base-devel aspell-en id3lib git jsoncpp libmicrohttpd libmpdclient libupnp python-bottle python-mutagen python-requests python-setuptools python-waitress recoll

# utilize all cpu cores
sed -i 's/.*MAKEFLAGS=.*/MAKEFLAGS="-j'$( nproc )'"/' /etc/makepkg.conf

# libnpupnp - depend 1
su alarm
cd
mkdir libnpupnp
cd libnpupnp
wget https://github.com/rern/RuneAudio/raw/master/upmpdcli/libnpupnp/PKGBUILD
# get version from: https://www.lesbonscomptes.com/upmpdcli/downloads/

makepkg -A --skipinteg

su
pacman -U libnpupnp*.pkg.tar.xz

# libupupp - depend 2
su alarm
cd
mkdir libupupp
cd libupupp
wget https://github.com/rern/RuneAudio/raw/master/upmpdcli/libupnpp/PKGBUILD
# get version from: https://www.lesbonscomptes.com/upmpdcli/downloads/

makepkg -A --skipinteg

su
pacman -U libupupp*.pkg.tar.xz

# upmpdcli
su alarm
cd
git clone https://aur.archlinux.org/upmpdcli.git
cd upmpdcli
# get version from: https://www.lesbonscomptes.com/upmpdcli/downloads/

makepkg -A --skipinteg
```
