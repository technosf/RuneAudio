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
alsamixer -D bluealsa
amixer -D bluealsa
```
### MAC addresss
```sh
bluetoothctl devices

# paired
bluetoothctl paired-devices | cut -d' ' -f2
```
### mpd.conf
```
audio_output {
	name           "Bluetooth"
	device         "bluealsa:DEV=xx:xx:xx:xx:xx:xx,PROFILE=a2dp"
	type           "alsa"
	mixer_type     "software"
	auto_resample  "no"
	auto_format    "no"
	buffer_time    "500000"
	period_time    "256000000"
}
```
