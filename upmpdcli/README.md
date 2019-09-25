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

useradd x
mkdir /home/x
chown x:x /home/x
su x
cd

git clone https://aur.archlinux.org/cgit/aur.git/snapshot/libupnpp.tar.gz
cd libupnpp
sed -i 's/\(arch=(i686 x86_64\))/\1 armv7h)/' PKGBUILD

makepkg

sudo pacman -U /home/x/libupnpp/libupnpp-0.17.1-1-armv7h.pkg.tar.xz

su x
cd

git clone https://aur.archlinux.org/cgit/aur.git/snapshot/upmpdcli.tar.gz
cd upmpdcli

makepkg
```
