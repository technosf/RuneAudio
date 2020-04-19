### Synchronous multi-room audio player
Source: [Snapcast](https://github.com/badaix/snapcast)
```sh
pacman -Syu
pacman -S --needed base-devel boost libffi

# utilize all cpu cores
sed -i 's/.*MAKEFLAGS=.*/MAKEFLAGS="-j'$( nproc )'"/' /etc/makepkg.conf

su alarm
cd
curl -O https://aur.archlinux.org/cgit/aur.git/snapshot/snapcast.tar.gz
bsdtar xf snapcast.tar.gz
rm snapcast.tar.gz
cd snapcast

makepkg -A
```
### Configuration
**mpd.conf**
```sh
audio_output {
	type           "fifo"
	name           "snapcast"
	path           "/tmp/snapfifo"
	format         "48000:16:2"
	mixer_type     "software"
}
```
**/tmp/snapfifo**
```sh
touch /tmp/snapfifo
```
**Server**
```sh
systemctl start snapserver
```
**Client**
```sh
snapclient -h IPADDRESS
```
