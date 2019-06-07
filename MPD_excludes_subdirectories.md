### MPD - Exclude subdirectories from database

**Exclude all except `Music` at USB root**
```sh
cd /mnt/MPD/USB/rootdir
ls | sed '/Music/ d' | tr ' ' '\n' > .mpdignore
```

**Exclude all `Artwork*` and `artwork*` subdirectories in `Music`**
```sh
find /mnt/MPD/USB/rootdir/Music -iname artwork* -type d -execdir sh -c 'echo -e "Artwork*\nartwork*" > {}/.mpdignore' \;
```
- `-iname artwork*` case insensitive name
- `-type d` only directory
- `-execdir` run command in found directory
- `sh -c` child shell (`-execdir` cannot run command with arguments)
- `{}` path of found directory
