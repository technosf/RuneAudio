### RuneAudio+R e1 - Upgrade all installed packages

```sh
# upgrade "nginx with pushstream" custom package
file=nginx-1.16.1-1-armv7h.pkg.tar.xz
wget -q --noconfirm https://github.com/rern/RuneAudio/raw/master/nginx/$file
pacman -U $file

# upgrade kid3-cli package
file=https://github.com/rern/RuneAudio/blob/master/kid3-cli/kid3-cli-3.7.1-1-armv7h.pkg.tar.xz
wget -q --noconfirm https://github.com/rern/RuneAudio/raw/master/nginx/$file
pacman -U $file

# then upgrade all
pacman -Syu

# packages that cannot be upgraded
php-libevent
php-pthreads 
php-rune 
phpiredis-rune 
phpredis-rune
```
