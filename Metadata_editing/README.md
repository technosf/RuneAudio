## Metadata Editing

### ID3 tags
[**mid3v2**](https://mutagen.readthedocs.io/en/latest/man/mid3v2.html)
```sh
pip install mutagen

# list all tags
mid3v2 -l /path/file

# write tag
mid3v2 --FRAMENAME=VALUE /path/file
```
**--FRAMENAME=VALUE**
- --artist=ARTIST (TPE1)
- --album=ALBUM (TALB)
- --TPE2=ALBUMARTIST
- --song=TITLE (TIT2)
- --genre=GENRE (TCON)
- --TCOM=COMPOSER
- --year=YEAR (TDRC)
- --track=TRACK (TRCK)
- --TPOS=DISC

### FLAC Tags
```sh
# list tag - case insensitive NAME
metaflac --show-tag=NAME [--show-tag=NAME]

# write tag - uppercase NAME ( keep timestamp > remove > write )
metaflac --preserve-modtime --remove-tag=NAME --set-tag=NAME=VALUE [--remove-tag=NAME --set-tag=NAME=VALUE]
```
**tag NAME**
- ARTIST
- ALBUM
- ALBUMARTIST
- TITLE
- GENRE
- COMPOSER
- DATE
- TRACKNUMBER
- DISCNUMBER

[**Tag Mapping**](https://wiki.hydrogenaud.io/index.php?title=Tag_Mapping)
