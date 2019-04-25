### convert node pica to browser pica.js
[**pica**](https://github.com/nodeca/pica) - Resize image in browser with high quality and high speed

## Convert
Warning: This breaks **mpd**.
```sh
pacman -Syw --noconfirm openssl
tmpopenssl=/tmp/openssl
mkdir $tmpopenssl
bsdtar xf /var/cache/pacman/pkg/openssl* -C $tmpopenssl
cp $tmpopenssl/usr/lib/{libcrypto.so.1.1,libssl.so.1.1} /lib
rm -r $tmpopenssl
pacman -S --noconfirm npm icu libuv libtirpc

npm install -g browserify
npm install -g pica
npm install -g babelify @babel/core @babel/preset-env

echo "    pica = require('pica')();" > entry.js
browserify entry.js -o /srv/http/assets/js/vendor/pica.js
rm entry.js
```
## Fix broken mpd
```sh
ln -s /lib/libicui18n.so.{64.1,56}
ln -s /lib/libicuucso.{64.1,56}

```
## Usage
```js
var picaOption = {
	  unsharpAmount: 100  // 0...500 Default = 0 (try 50-100)
	, unsharpThreshold: 5 // 0...100 Default = 0 (try 10)
	, unsharpRadius: 0.6
//	, quality: 3          // 0...3 Default = 3 (Lanczos win=3)
//	, alpha: true         // Default = false (black crop background)
};
var img = $( '#orinialImgage' ).attr( 'src' );
var picacanvas = document.createElement( 'canvas' ); // create canvas object
picacanvas.width = 100;                              // set width
picacanvas.height = 200;                             // set height
pica.resize( img, picacanvas, picaOption ).then( function() {
	// picacanvas content = resized img
	var resizedbase64 = picacanvas.toDataURL( 'image/jpeg', 0.9 ); // canvas to base64 (jpg, qualtity)
} );
```
