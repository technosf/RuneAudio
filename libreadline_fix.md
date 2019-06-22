**Fix needed latest version of `readline`**
- Upgrade samba
```sh
pacman -Sy
pkg=$( pacman -Qi readline | grep '^Required By' | cut -d':' -f2 )
pacman -S --needed $pkg readline
```
