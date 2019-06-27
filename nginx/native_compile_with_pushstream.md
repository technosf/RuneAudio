NGINX with pushstream
---

```sh
# on RuneAudio
useradd alarm
mkdir -p /home/alarm/nginx/src
chown -R alarm:alarm /home/alarm
su alarm
cd /home/alarm/nginx
```
- [NGINX source files](https://archlinuxarm.org/packages/armv7h/nginx/files)
- Copy-paste code from each file, direct download not available, to `/home/alarm/nginx/` (with last empty line without whitespace)  
- Edit `PKGBUILD`:
```sh
...
--depends=(pcre zlib openssl geoip mailcap)
++depends=(pcre zlib openssl geoip)
...
#_common_flags=(
++    --add-module=$srcdir/nginx-push-stream-module
...
#}
#build() {
...
--    --with-mail
--    --with-mail_ssl_module
...
#}
--check() {
--  cd nginx-tests
--  TEST_NGINX_BINARY="$srcdir/$pkgname-$pkgver/objs/nginx" prove .
--}
#package() {
...
++  mkdir -p "$pkgdir"/usr/lib/systemd/system/
++  install -Dm644 $srcdir/service "$pkgdir"/usr/lib/systemd/system/nginx.service
++  install -Dm644 $srcdir/logrotate "$pkgdir"/etc/logrotate.d/nginx

--  sed -e 's|\ "$pkgdir"/usr/share/man/man8/nginx.8.gz

--  for i in ftdetect indent syntax; do
--    install -Dm644 contrib/vim/$i/nginx.vim \
--      "$pkgdir/usr/share/vim/vimfiles/$i/nginx.vim"
--  done
#}
```

### Prepare environment
(On RuneAudio, upgrade MPD first.)
```sh
pacman -Sy --needed base-devel pcre zlib guile git wget openssl mercurial perl-gd perl-io-socket-ssl perl-fcgi perl-cache-memcached memcached ffmpeg libutil-linux nettle
```

### Compile
```sh
git clone https://github.com/wandenberg/nginx-push-stream-module.git src/nginx-push-stream-module

makepkg -A --skipinteg
```
