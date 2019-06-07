### MPD - Exclude subdirectories on update
- Exclude `Artwork*`, `artwork*`
```sh
find /mnt/MPD/ -iname artwork* -type d -execdir echo -e "Artwork*\nartwork*" > {}/.mpdignore \;
```

- Exclude all except `Music` for USB root
```sh
cd /mnt/MPD/USB/mountname
ls | sed '/Music/ d' | tr ' ' '\n' > .mpdignore
```
