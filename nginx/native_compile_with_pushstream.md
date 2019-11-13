NGINX with pushstream
---
Native compile on RPi.

```sh
# 
pacman -Sy --needed base-devel

su alarm
mkdir nginx-mainline-pushstream
cd nginx-mainline-pushstream
```
- NGINX mainline source files: https://archlinuxarm.org/packages/armv7h/nginx-mainline/files/
- Copy-paste code from each file, direct download not available, to `/home/x/nginx/` (with last empty line without whitespace)
- Get pushstream version: https://github.com/wandenberg/nginx-push-stream-module/releases
- Edit [`PKGBUILD`](https://github.com/rern/RuneAudio/blob/master/nginx/home/alarm/PKGBUILD):
```sh
--pkgname=nginx-mainline
++pkgname=nginx-mainline-pushstream
...
--arch=('x86_64')
++arch=('any')
...
++pushstreamver=0.5.4
--depends=(pcre zlib openssl geoip mailcap)
++depends=(pcre zlib openssl)
...
#source=(...
...
++    https://github.com/wandenberg/nginx-push-stream-module/archive/$pushstreamver.tar.gz
#)

#_common_flags=(
...
--    --with-http_geoip_module
...
--    --with-mail
--    --with-mail_ssl_module
...
--    --with-stream_geoip_module
...
++    --add-module=/home/alarm/nginx-mainline-pushstream/src/nginx-push-stream-module-$pushstreamver
#}
...

#package() {
...
++  mkdir -p "$pkgdir"/usr/lib/systemd/system
++  mkdir -p "$pkgdir"/var/lib/nginx/client-body
++  install -Dm644 $srcdir/service "$pkgdir"/usr/lib/systemd/system/nginx.service
++  install -Dm644 $srcdir/logrotate "$pkgdir"/etc/logrotate.d/nginx
--  sed -e 's|\ "$pkgdir"/usr/share/man/man8/nginx.8.gz
--
--  for i in ftdetect indent syntax; do
--    install -Dm644 contrib/vim/$i/nginx.vim \
--      "$pkgdir/usr/share/vim/vimfiles/$i/nginx.vim"
--  done
#}
```

### Compile
```sh
makepkg -A
```
