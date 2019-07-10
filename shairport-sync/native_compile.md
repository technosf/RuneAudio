with normal ArchLinuxArm build environment already setup
```sh
pacman -Sy libconfig xmltoman

su alarm
cd
mkdir shairport-sync

# get source files: https://archlinuxarm.org/packages/armv7h/shairport-sync (with last empty line without whitespace)

makepkg -A
```
