NGINX with pushstream
---

(ArchLinuxArm: Install [ArchLinuxArm for RPi2](https://github.com/rern/RuneAudio/tree/master/ArchLinuxArm))
```sh
# on RuneAudio
useradd alarm

mkdir -p /home/alarm/nginx
su alarm
cd
mkdir nginx
cd nginx
```
- [ArchLinuxArm Packages](https://archlinuxarm.org/packages): search `nginx` - `armv7h`
- `Source Files` > copy-paste code from each file, direct download not available, to `/home/alarm/nginx/` (with last empty line without whitespace)  
- Edit `PKGBUILD`:
```sh
...
--depends=(pcre zlib openssl geoip mailcap)
++depends=(pcre zlib openssl geoip)
...
#build() {
...
--    --with-mail
--    --with-mail_ssl_module
...
++    --add-module=/home/alarm/nginx/nginx-push-stream-module \
...
#}
--check() {
--  cd nginx-tests
--  TEST_NGINX_BINARY="$srcdir/$pkgname-$pkgver/objs/nginx" prove .
--}
#package() {
...
++  mkdir -p "$pkgdir"/usr/lib/systemd/system/
++  install -Dm644 service "$pkgdir"/usr/lib/systemd/system/nginx.service
++  install -Dm644 logrotate "$pkgdir"/etc/logrotate.d/nginx

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
git clone https://github.com/wandenberg/nginx-push-stream-module.git

makepkg -A --skipinteg
```
