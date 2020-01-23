### HFS File System support
Source: [hfsprogs](https://github.com/muflone/pkgbuilds/tree/master/hfsprogs)
```sh
pacman -Syu
pacman -S --needed base-devel
# utilize all cpu cores
sed -i 's/.*MAKEFLAGS=.*/MAKEFLAGS="-j'$( nproc )'"/' /etc/makepkg.conf

su alarm
cd

curl -O https://aur.archlinux.org/cgit/aur.git/snapshot/hfsprogs.tar.gz
bsdtar xf hfsprogs.tar.gz
rm hfsprogs.tar.gz
cd hfsprogs

makepkg -A
```
