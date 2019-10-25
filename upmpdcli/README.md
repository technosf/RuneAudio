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
pacman -Sy --needed base-devel libupnp libmpdclient

su alarm
cd

git clone https://aur.archlinux.org/libupnpp.git
cd libupnpp

makepkg -A -s

sudo pacman -U /home/alarm/libupnpp/libupnpp*

cd
git clone https://aur.archlinux.org/upmpdcli.git
cd upmpdcli

makepkg -A -s
```
