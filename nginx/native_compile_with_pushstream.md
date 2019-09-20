NGINX with pushstream
---
Native compile.

```sh
# on RuneAudio
useradd x
mkdir -p /home/x/nginx
chown -R x:x /home/x
su x
cd /home/x/nginx
```
- NGINX mainline source files: https://archlinuxarm.org/packages/armv7h/nginx-mainline/files/
- Copy-paste code from each file, direct download not available, to `/home/x/nginx/` (with last empty line without whitespace)
- Get pushstream version: https://github.com/wandenberg/nginx-push-stream-module/releases
- Edit `PKGBUILD`:
```sh
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
++    --add-module=/home/x/nginx/src/nginx-push-stream-module-$pushstreamver
#}

#package() {
...
++  mkdir -p "$pkgdir"/usr/lib/systemd/system/
++  install -Dm644 $srcdir/service "$pkgdir"/usr/lib/systemd/system/nginx.service
++  install -Dm644 $srcdir/logrotate "$pkgdir"/etc/logrotate.d/nginx
...
#}

#package() {
...
--  sed -e 's|\ "$pkgdir"/usr/share/man/man8/nginx.8.gz

--  for i in ftdetect indent syntax; do
--    install -Dm644 contrib/vim/$i/nginx.vim \
--      "$pkgdir/usr/share/vim/vimfiles/$i/nginx.vim"
--  done
...
#}
```

### Prepare build environment
```sh
pacman -Sy --needed base-devel guile git libutil-linux memcached mercurial perl-cache-memcached perl-fcgi perl-gd perl-io-socket-ssl
```

### Compile
```sh
makepkg -A --skipinteg
```
