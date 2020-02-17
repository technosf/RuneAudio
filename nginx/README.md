NGINX Upgrade with pushstream
---
- RuneAudio needs NGINx with **pushstream**
- **pushstream** is not available as a separated package

### compile
- NGINX mainline source files: https://archlinuxarm.org/packages/armv7h/nginx-mainline/files
```sh
# remove confilit file (mailcap reinstates it)
rm /etc/nginx/mime.types
pacman -Syu
pacman -S --needed base-devel geoip mailcap

# utilize all cpu cores
sed -i 's/.*MAKEFLAGS=.*/MAKEFLAGS="-j'$( nproc )'"/' /etc/makepkg.conf

su alarm
cd
mkdir nginx-mainline-pushstream
cd nginx-mainline-pushstream

# get build scripts
wget https://github.com/rern/RuneAudio/raw/master/Build_packages/getscripts.sh
. getscripts.sh
getScripts nginx-mainline
# RPi 1, Zero: getScripts nginx-mainline 1 

# get pushstream version: https://github.com/wandenberg/nginx-push-stream-module/releases

# customize
sed -i -e 's/\(pkgname=.*\)/\1-pushstream/
' -e "/^pkgver/ a\
pushstreamver=0.5.4
" -e '/^install/ d
' -e '/^source/ a\
        https://github.com/wandenberg/nginx-push-stream-module/archive/$pushstreamver.tar.gz
' -e '/md5sums/ {N;N;N;d}
' -e '/sha512sums/ {N;N;N;d}
' -e '/--with-threads/ a\
  --add-module=/home/alarm/nginx-mainline-pushstream/src/nginx-push-stream-module-$pushstreamver
' PKGBUILD

# set integrity
#makepkg -g >> PKGBUILD

makepkg -A --skipinteg
```
