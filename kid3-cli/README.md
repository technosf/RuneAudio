## kid3-cli 

**Build**
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

**Install**
```sh
pacman -Sy --noconfirm chromaprint id3lib libmp4v2 qt5-multimedia taglib
file=kid3-cli-3.7.1-1-armv7h.pkg.tar.xz
wget https://github.com/rern/RuneAudio/raw/master/kid3-cli/$file
pacman -U --noconfirm $file
rm $file
```
