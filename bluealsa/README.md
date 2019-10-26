### Bluetooth Audio ALSA Backend

```sh
pacman -Sy --needed base-devel alsa-lib bluez bluez-utils bluez-libs bluez-tools fdkaac sbc

su alarm
wget https://github.com/Arkq/bluez-alsa/archive/v2.0.0.tar.gz
bsdtar xvf v2.0.0.tar.gz
rm v2.0.0.tar.gz
cd bluez-alsa-2.0.0

autoreconf --install
mkdir build
cd build
../configure --enable-aac --enable-ofono --enable-debug
make
make install
```
