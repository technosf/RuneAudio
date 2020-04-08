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
pacman -U /home/alarm/libnpupnp/libnpupnp*.pkg.tar.xz

# libupupp - depend 2
su alarm
cd
mkdir libupupp
cd libupupp
wget https://github.com/rern/RuneAudio/raw/master/upmpdcli/libupupp/PKGBUILD
# get version from: https://www.lesbonscomptes.com/upmpdcli/downloads/

makepkg -A --skipinteg

su
pacman -U /home/alarm/libupupp/libupupp*.pkg.tar.xz

# upmpdcli
su alarm
cd
mkdir upmpdcli
cd upmpdcli
wget https://github.com/rern/RuneAudio/raw/master/upmpdcli/upmpdcli/PKGBUILD
wget https://github.com/rern/RuneAudio/raw/master/upmpdcli/upmpdcli/upmpdcli.install
wget https://github.com/rern/RuneAudio/raw/master/upmpdcli/upmpdcli/upmpdcli.service

makepkg -A
```
