### RuneAudio+R e1 - Upgrade all installed packages

```sh
# upgrade "nginx with pushstream" custom package
file=nginx-1.16.1-1-armv7h.pkg.tar.xz
wget -q --noconfirm https://github.com/rern/RuneAudio/raw/master/nginx/$file
pacman -U $file

# then upgrade all
pacman -Syu
```
