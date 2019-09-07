## upmpdcli

An UPnP Audio Media Renderer based on MPD
```sh
pacman -Sy expat libmicrohttpd

su x

cd \
wget https://aur.archlinux.org/cgit/aur.git/snapshot/libupnpp.tar.gz
bsdtar xf libupnpp.tar.gz
rm libupnpp.tar.gz
cd libupnpp

makepkg -A --skipinteg

cd \
wget https://aur.archlinux.org/cgit/aur.git/snapshot/upmpdcli.tar.gz
bsdtar xf upmpdcli.tar.gz
rm upmpdcli.tar.gz
cd upmpdcli

makepkg -A --skipinteg
```
