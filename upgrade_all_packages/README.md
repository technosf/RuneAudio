### RuneAudio+R e1 - Upgrade all installed packages

```sh
# upgrade "nginx with pushstream" custom package
file1=nginx-1.16.1-1-armv7h.pkg.tar.xz
wget -q --noconfirm https://github.com/rern/RuneAudio/raw/master/nginx/$file1

# upgrade kid3-cli package
file2=kid3-cli-3.7.1-1-armv7h.pkg.tar.xz
wget -q --noconfirm https://github.com/rern/RuneAudio/raw/master/nginx/$file2

# upgrade upmpdcli package
file3=libupnpp-0.17.1-1-armv7h.pkg.tar.xz
wget -q --noconfirm https://github.com/rern/RuneAudio/raw/master/upmpdcli/$file3

file4=upmpdcli-1.4.2-2-armv7h.pkg.tar.xz
wget -q --noconfirm https://github.com/rern/RuneAudio/raw/master/upmpdcli/$file4

pacman -U $file1 $file2 $file3 $file4
rm $file1 $file2 $file3 $file4

# then upgrade all
pacman -Syu

# packages that cannot be upgraded
php-libevent
php-pthreads 
php-rune 
phpiredis-rune 
phpredis-rune
```
