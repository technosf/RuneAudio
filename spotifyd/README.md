### A spotify daemon
Source: [Spotifyd](https://github.com/Spotifyd/spotifyd)
```sh
pacman -Syu
pacman -S --needed base-devel cargo

# utilize all cpu cores
sed -i 's/.*MAKEFLAGS=.*/MAKEFLAGS="-j'$( nproc )'"/' /etc/makepkg.conf

su alarm
cd
curl -O https://aur.archlinux.org/cgit/aur.git/snapshot/spotifyd.tar.gz
bsdtar xf spotifyd.tar.gz
rm spotifyd.tar.gz
cd spotifyd

makepkg -A
