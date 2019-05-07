## Metadata Editing

### ALL tags
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

### FLAC tags
[**metaflac**](https://xiph.org/flac/documentation_tools_metaflac.html)
```sh
# no install needed

# list tag - case insensitive NAME
metaflac --show-tag=NAME [--show-tag=NAME] '/path/file'

# write tag - uppercase NAME ( keep timestamp > remove > write )
metaflac --preserve-modtime \
	--remove-tag="ARTIST" \
	--set-tag=ARTIST="VALUE" \
	--remove-tag="ALBUM" \
	--set-tag=ALBUM="VALUE" \
	--remove-tag="ALBUMARTIST" \
	--set-tag=ALBUMARTIST="VALUE" \
	--remove-tag="COMPOSER" \
	--set-tag=COMPOSER="VALUE" \
	--remove-tag="GENRE" \
	--set-tag=GENRE="VALUE" \
	--remove-tag="TITLE" \
	--set-tag=TITLE="VALUE" \
	--remove-tag="TRACKNUMBER" \
	--set-tag=TRACKNUMBER="VALUE" \
	"/path/file"
```

### ID3 tags
[**mid3v2**](https://mutagen.readthedocs.io/en/latest/man/mid3v2.html)
```sh
# install
pip install mutagen

# list all tags
mid3v2 -l '/path/file'

# write tag
mid3v2 \
	--artist="ARTIST" \
	--album="ALBUM" \
	--TPE2="ALBUMARTIST" \
	--TCOM="COMPOSER" \
	--genre="GENRE" \
	--song="TITLE" \
	--track="TRACK" \
	"/path/file"
```
