### MPD - Exclude subdirectories on update
- Exclude `Artwork*`, `artwork*`
```sh
find /mnt/MPD/ -iname artwork* -type d -exec echo -e "Artwork*\nartwork*" > {} \;
```

- Exclude all except `Music` for USB root
```sh
cd /mnt/MPD/USB/mountname
ls | sed '/Music/ d' | tr ' ' '\n' > .mpdignore
```
