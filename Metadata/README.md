## Metadata

### ALL tags and tags mapping
[**Kid3**](https://github.com/rern/RuneAudio/tree/master/kid3-cli)

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
