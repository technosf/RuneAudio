### Bluetooth Audio ALSA Backend
Source: [bluealsa](https://github.com/Arkq/bluez-alsa)
```sh
pacman -Syu
pacman -S --needed base-devel bluez bluez-libs bluez-utils git libfdk-aac sbc

# utilize all cpu cores
sed -i 's/.*MAKEFLAGS=.*/MAKEFLAGS="-j'$( nproc )'"/' /etc/makepkg.conf

su alarm
cd
curl -O https://aur.archlinux.org/cgit/aur.git/snapshot/bluez-alsa-git.tar.gz
bsdtar xf bluez-alsa-git.tar.gz
rm bluez-alsa-git.tar.gz
cd bluez-alsa-git
sed -i -e 's/\(enable-aac\)/\1 --enable-ofono --enable-debug/' PKGBUILD

makepkg -A
```
Note: upgrade - uninstall existing then install

### mixer devices
```sh
amixer -D bluealsa
```
### mpd.conf
```
audio_output {
	name           "Bluetooth"
	device         "bluealsa"
	type           "alsa"
	auto_resample  "yes"
	auto_format    "yes"
	mixer_control  "JBL Focus 500 - A2DP"
	mixer_device   "bluealsa"
}
```
