```sh
pacman -Syw openssl
mkdir /tmp/openssl
bsdtar xf /var/cache/pacman/pkg/openssl* -C /tmp/openssl
cp /tmp/openssl/usr/lib/{libcrypto.so.1.1,libssl.so.1.1} /lib
pacman -S npm icu libuv libtirpc

npm install -g browserify
npm install -g pica
npm install -g babelify @babel/core @babel/preset-env

```
