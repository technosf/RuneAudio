NGINX Upgrade with pushstream
---

Upgrade from default customized **NGINX** to 1.16.0
- `pacman -S nginx` upgrades alone will break RuneUI
- RuneAudio needs NGINx with **pushstream**
- **pushstream** is not available as a separated package


### Arch Linux Arm - NGINX with pushstream + PHP-FPM
```sh
file=nginx-1.16.1-1-aarch64.pkg.tar.xz
wget https://github.com/rern/RuneAudio/raw/master/nginx/$file
pacman -U $file
rm $file

pacman -Sy php-fpm

wget https://github.com/rern/RuneAudio/raw/master/nginx/nginx.conf -O /etc/nginx/nginx.conf

systemctl restart nginx php-fpm
```
