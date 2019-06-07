### MPD - Exclude subdirectories on update
- Exclude `Artwork*`, `artwork*`
```sh
find /mnt/MPD/ -iname artwork* -type d -exec echo -e "Artwork*\nartwork*" > {} \;
```
