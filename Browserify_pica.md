### Browserify - node pica.js to browser pica.js
[**Browserify**](browserify.org) - Let you require('modules') in the browser by bundling up all dependencies.
[**Pica**](https://github.com/nodeca/pica) - Resize image in browser with high quality and high speed.

## Convert
Warning: **MPD** will be broken so it must be upgraded afterward.
```sh
pacman -S --noconfirm --needed openssl-cryptodev icu libuv libtirpc npm openssl-cryptodev

npm install -g browserify pica babelify @babel/core @babel/preset-env

echo "    pica = require('pica')();" > entry.js
browserify entry.js -o /srv/http/assets/js/vendor/pica.js
rm entry.js
```

## Usage
```js
var picaOption = {
	  unsharpAmount    : 100  // 0...500 Default = 0 (try 50-100)
	, unsharpThreshold : 5    // 0...100 Default = 0 (try 10)
	, unsharpRadius    : 0.6
//	, quality          : 3    // 0...3 Default = 3 (Lanczos win=3)
//	, alpha            : true // Default = false (black crop background)
};
var img = $( '#orinialImgage' ).attr( 'src' );
var picacanvas = document.createElement( 'canvas' ); // create canvas object
picacanvas.width = 100;                              // set width
picacanvas.height = 200;                             // set height
pica.resize( img, picacanvas, picaOption ).then( function() {
	// img resized to picacanvas
	var resizedbase64 = picacanvas.toDataURL( 'image/jpeg', 0.9 ); // canvas to base64 (jpg, qualtity)
} );
```
