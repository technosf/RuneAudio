### A spotify daemon
Source: [Spotifyd](https://github.com/Spotifyd/spotifyd)
```sh
pacman -Syu
pacman -S --needed base-devel cargo

# utilize all cpu cores
sed -i 's/.*MAKEFLAGS=.*/MAKEFLAGS="-j'$( nproc )'"/' /etc/makepkg.conf
 makepkg -A
