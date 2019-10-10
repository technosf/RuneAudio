## upmpdcli

An UPnP Audio Media Renderer based on MPD

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
pacman -Sy expat python-requests recoll python-bottle python-mutagen mutagen aspell-en python-waitress

useradd alarm
mkdir /home/alarm
chown alarm:alarm /home/alarm
su alarm
cd

git clone https://aur.archlinux.org/cgit/aur.git/snapshot/libupnpp.tar.gz
cd libupnpp
sed -i 's/\(arch=(i686 x86_64\))/\1 armv7h)/' PKGBUILD

makepkg -A

sudo pacman -U /home/alarm/libupnpp/libupnpp-0.17.1-1-armv7h.pkg.tar.xz

git clone https://aur.archlinux.org/cgit/aur.git/snapshot/upmpdcli.tar.gz
cd upmpdcli

makepkg -A
```
