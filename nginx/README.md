NGINX Upgrade with pushstream
---
- RuneAudio needs NGINx with **pushstream**
- **pushstream** is not available as a separated package

### compile
- NGINX mainline source files: https://archlinuxarm.org/packages/armv7h/nginx-mainline/files
```sh
pacman -Syu
pacman -S --needed base-devel

# utilize all cpu cores
sed -i 's/.*MAKEFLAGS=.*/MAKEFLAGS="-j'$( nproc )'"/' /etc/makepkg.conf

su alarm
cd
mkdir nginx-mainline-pushstream
cd nginx-mainline-pushstream

# get build scripts
#   getScript PACKAGE 1 - RPi 1, Zero
#   getScript PACKAGE   - All except RPi 1, Zero
getScript() {
    [[ -z $2 ]] && arch=armv7h || arch=armv6h
    url=https://archlinuxarm.org/packages/$arch/$1
    echo Get build script list ...
    files=$( curl -s $url/files | sed -n '/<tbody/,/<\/tbody>/ p' | grep href= | sed 's/.*">\(.*\)<\/a>.*/\1/' )
    echo
    for file in $files; do
        echo Get $file ...
        curl -s $url/files/$file \
            | sed -n '/<pre>/,/<\/pre>/ p' \
            | sed 's/.*<pre><code>\|<\/code><\/pre>//g' > $file
    done
}
getScript nginx-mainline

# get pushstream version: https://github.com/wandenberg/nginx-push-stream-module/releases

# customize
sed -i -e 's/\(pkgname=.*\)/\1-pushstream/
' -e "/^pkgver/ a\
pushstreamver=0.5.4
" -e "s/ 'geoip' 'mailcap'//
" -e '/^install/ d
' -e '/^source/ a\
        https://github.com/wandenberg/nginx-push-stream-module/archive/$pushstreamver.tar.gz
' -e '/md5sums/ {N;N;N;d}
' -e '/sha512sums/ {N;N;N;d}
' -e '/--with-mail/ d
' -e '/geoip_module/ d
' -e '/--with-threads/ a\
  --add-module=/home/alarm/nginx-mainline-pushstream/src/nginx-push-stream-module-$pushstreamver
' -e '/make DESTDIR/ a\
  mkdir -p "$pkgdir"/usr/lib/systemd/system\
  mkdir -p "$pkgdir"/var/lib/nginx/client-body\
  install -Dm644 $srcdir/service "$pkgdir"/usr/lib/systemd/system/nginx.service\
  install -Dm644 $srcdir/logrotate "$pkgdir"/etc/logrotate.d/nginx
' -e '/nginx.8.gz/,/done/ d
' PKGBUILD

# set integrity
#makepkg -g >> PKGBUILD

makepkg -A --skipinteg
```
