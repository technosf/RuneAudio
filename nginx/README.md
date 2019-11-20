NGINX Upgrade with pushstream
---
- RuneAudio needs NGINx with **pushstream**
- **pushstream** is not available as a separated package

### compile
- NGINX mainline source files: https://archlinuxarm.org/packages/armv7h/nginx-mainline/files
- Copy-paste code from each file, direct download not available, to `/home/x/nginx/` (with last empty line without whitespace)
- Get pushstream version: https://github.com/wandenberg/nginx-push-stream-module/releases
```sh
pacman -Syu
pacman -S --needed base-devel

su alarm
mkdir nginx-mainline-pushstream
cd nginx-mainline-pushstream

sed -i -e 's/\(pkgname=.*\)/\1-pushstream/
' -e "s/^arch=.*/arch=('any')/
" -e '/^depends/ s/ geoip mailcap//; i\
pushstreamver=0.5.4
' -e '/^source/ a\
    https://github.com/wandenberg/nginx-push-stream-module/archive/$pushstreamver.tar.gz
' -e '/--with-http_geoip_module/ d
' -e '/--with-mail/ d
' -e '/--with-stream_geoip_module/ d
' -e '/--with-threads/ a\
    --add-module=/home/alarm/nginx-mainline-pushstream/src/nginx-push-stream-module-$pushstreamver
' -e '/make DESTDIR/ a\
  mkdir -p "$pkgdir"/usr/lib/systemd/system
  mkdir -p "$pkgdir"/var/lib/nginx/client-body
  install -Dm644 $srcdir/service "$pkgdir"/usr/lib/systemd/system/nginx.service
  install -Dm644 $srcdir/logrotate "$pkgdir"/etc/logrotate.d/nginx
' -e '/nginx.8.gz/,/done/ d
' PKGBUILD

makepkg --skipinteg
```
