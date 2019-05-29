## kid3-cli 

[**Kid3**](https://kid3.sourceforge.io/)
```sh
# all format by common tag names
kid3-cli \
	-c 'set artist "ARTIST"' \
	-c 'set album "ALBUM"' \
	-c 'set albumartist "ALBUMARTIST"' \
	-c 'set composer "COMPOSER"' \
	-c 'set genre "GENRE"' \
	-c 'set title "TITLE"' \
	-c 'set tracknumber "TRACK"' \
	"/path/file"
	
# remove ID3v1
kid3-cli -c 'remove 1' "/path/file"
```

[**Tag Mapping**](https://kid3.sourceforge.io/kid3_en.html#table-frame-list)

| FLAC        | ID3v2  | RIFF | Kid3 name   |
| ----------- | ----   | ---- | ----------- |
| ARTIST      | TPE1   | IART | artist      
| ALBUM       | TALB   | IPRD | album       |
| ALBUMARTIST | TPE2   |      | albumartist |
| COMPOSER    | TCOM   | IMUS | composer    |
| GENRE       | TCON   | IGNR | genre       |
| TITLE       | TIT2   | INAM | title       |
| TRACKNUMBER | TRCK   | IPRT | tracknumber |

`*.wav` files use RIFF

**Build**
```sh
pacman -Sy base-devel qt5-tools extra-cmake-modules jsoncpp

useradd x
su x
cd
wget https://aur.archlinux.org/cgit/aur.git/snapshot/kid3-cli.tar.gz
bsdtar xf kid3-cli.tar.gz
rm kid3-cli.tar.gz
cd kid3-cli

makepkg -A --skipinteg
```
