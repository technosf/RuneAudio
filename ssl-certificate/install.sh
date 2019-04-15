$!/bin/bash

rm $0

. /srv/http/addonstitle.sh

timestart

title -l '=' "$bar Install SSL Certicicate ..."

pacman -Sy --noconfirm certbot certbot-nginx python-setuptools python-six python-appdirs python-pyparsing
wgetnc https://github.com/rern/RuneAudio/raw/master/mpd/usr/lib/libcrypto.so.1.1 -P /usr/lib
wgetnc https://github.com/rern/RuneAudio/raw/master/mpd/usr/lib/libssl.so.1.1 -P /usr/lib
chown root:root /usr/lib/{libcrypto.so.1.1,libssl.so.1.1}
chmod 755 /usr/lib/{libcrypto.so.1.1,libssl.so.1.1}
certbot --nginx

timestop

title -nt "$bar SSL Certicicate installed successfully."
