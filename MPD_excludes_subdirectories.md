### MPD - Exclude subdirectories from database

**Directory Tree**
```sh
/mnt
├────/MPD
├────/LocalStorage
├────/NAS
├────/USB
│    └────/rootdir
│         ├────/Movies
│         ├────/Music
│         │    ├────/A
│         │    │    ├────/Artwork
│         │    │    │    ├────/p.jpg
│         │    │    │    └────q.jpg
│         │    │    ├────.mpdignore
│         │    │    ├────a.mp3
│         │    │    └────b.mp3
│         │    └─----/B
│         │         ├────/artworks
│         │         │    ├────r.jpg
│         │         │    └────s.jpg
│         │         ├────.mpdignore
│         │         ├────c.flac
│         │         └────d.flac
│         ├────/Others
│         └────.mpdignore
└────/Webradio

```
**Exclude all except `Music` at USB root**
```sh
cd /mnt/MPD/USB/rootdir
ls | sed '/Music/ d' | tr ' ' '\n' > .mpdignore
```

**Exclude all `Artwork` and `artworks` subdirectories in `Music`**
```sh
find /mnt/MPD/USB/rootdir/Music -iname artwork* -type d -execdir sh -c 'echo -e "?rtwork*" > .mpdignore' \;
```
- `-iname artwork*` case insensitive name with wildcard
- `-type d` only directory
- `-execdir` run command in found directory
- `sh -c` child shell (`-execdir` cannot run command with arguments)
