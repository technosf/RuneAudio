### RuneAudio+R e1 - Upgrade all installed packages
packages that not include in the upgrade
- kernel: linux-raspberrypi, linux-raspberrypi-headers
- php-libevent
- php-pthreads 
- php-rune 
- phpiredis-rune 
- phpredis-rune
```sh
# upgrade "nginx with pushstream" customized package
file=nginx-1.16.1-1-armv7h.pkg.tar.xz
wget -q --noconfirm https://github.com/rern/RuneAudio/raw/master/nginx/$file

pacman -U $file
rm $file

# then upgrade all
pacman -Syu
```
