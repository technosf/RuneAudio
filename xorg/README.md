## Upgrade

```sh
pkgs=$( pacman -Ss xorg | grep installed: | cut -d' ' -f1 | cut -d/ -f2 )
pacman -Sy $pkgs xf86-video-fbdev
```
