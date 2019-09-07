## upmpdcli

An UPnP Audio Media Renderer based on MPD
```sh
pacman -Sy expat python-requests recoll python-bottle python-mutagen mutagen aspell-en python-waitress

su x

cd
wget https://aur.archlinux.org/cgit/aur.git/snapshot/libupnpp.tar.gz
bsdtar xf libupnpp.tar.gz
rm libupnpp.tar.gz
cd libupnpp

makepkg -A --skipinteg

su
pacman -U /home/x/libupnpp/libupnpp-0.17.1-1-armv7h.pkg.tar.xz

su x

cd
wget https://aur.archlinux.org/cgit/aur.git/snapshot/upmpdcli.tar.gz
bsdtar xf upmpdcli.tar.gz
rm upmpdcli.tar.gz
cd upmpdcli

makepkg -A --skipinteg
```

`/etc/upmpdcli.conf`
```sh
sed -i -e 's/.*\(friendlyname = \).*/\1RuneAudio
' -e 's/.*\(ownqueue = \).*/\11
' /etc/upmpdcli.conf
```
