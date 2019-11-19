## upmpdcli

An UPnP Audio Media Renderer based on MPD. [upmpdcli](https://www.lesbonscomptes.com/upmpdcli/)

### Install
```sh
libupnpp=libupnpp-0.17.1-1-armv7h.pkg.tar.xz
upmpdcli=upmpdcli-1.4.2-2-armv7h.pkg.tar.xz
wget https://github.com/rern/RuneAudio/raw/master/upmpdcli/$libupnpp
wget https://github.com/rern/RuneAudio/raw/master/upmpdcli/$upmpdcli

pacman -U $libupnpp $upmpdcli

rm $libupnpp $upmpdcli

ln -s /lib/libjsoncpp.so.{21,20}

sed -i -e 's/.*\(friendlyname = \).*/\1RuneAudio
' -e 's/.*\(ownqueue = \).*/\11
' /etc/upmpdcli.conf
```

### Compile
```sh
pacman -Syu
pacman -S --needed base-devel aspell-en id3lib git jsoncpp libmicrohttpd libmpdclient libupnp python-bottle python-mutagen python-requests python-setuptools python-waitress recoll

su alarm
cd

curl -O https://aur.archlinux.org/cgit/aur.git/snapshot/libupnpp.tar.gz
bsdtar xf libupnpp.tar.gz
rm libupnpp.tar.gz
cd libupnpp

sed -i "s/^arch=.*/arch=('any')/" PKGBUILD

makepkg -A

su
pacman -U /home/alarm/libupnpp/libupnpp-*-any.pkg.tar.xz
su alarm

curl -O https://aur.archlinux.org/cgit/aur.git/snapshot/upmpdcli.tar.gz
bsdtar xf upmpdcli.tar.gz
rm upmpdcli.tar.gz
cd upmpdcli

sed -i -e "s/^arch=.*/arch=('any')/" -e "s/'mutagen' //" PKGBUILD

makepkg -A
```
