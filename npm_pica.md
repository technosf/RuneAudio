### convert pica5 (npm) to browser pica.js
```sh
pacman -Syw openssl
tmpopenssl=/tmp/openssl
mkdir $tmpopenssl
bsdtar xf /var/cache/pacman/pkg/openssl* -C $tmpopenssl
cp $tmpopenssl/usr/lib/{libcrypto.so.1.1,libssl.so.1.1} /lib
rm -r $tmpopenssl
pacman -S npm icu libuv libtirpc

npm install -g browserify
npm install -g pica
npm install -g babelify @babel/core @babel/preset-env

echo "var pica = require('pica');" > tmp.js
browserify tmp.js -o /srv/http/assets/js/vendor/pica.js
rm tmp.js
```
