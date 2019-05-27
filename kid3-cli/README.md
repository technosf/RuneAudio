## kid3-cli 

```sh
pacman -Sy
pacman -S base-devel qt5-tools extra-cmake-modules jsoncpp

useradd x
su x
cd
wget https://aur.archlinux.org/cgit/aur.git/snapshot/kid3-cli.tar.gz
bsdtar xf kid3-cli.tar.gz
rm kid3-cli.tar.gz
cd kid3-cli

makepkg -A --skipinteg
```
