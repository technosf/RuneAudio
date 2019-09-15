## Upgrade

```sh
pkgs=$( pacman -Qu ^x | cut -d' ' -f1 | cut -d/ -f2 )
pacman -Sy $pkgs
```
