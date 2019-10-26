### matchbox-window-manager

```sh
pacman -Sy --needed base-devel fakeroot make
su alarm
cd

git clone https://aur.archlinux.org/matchbox-window-manager.git
cd matchbox-window-manager
makepkg -A -s  # -s install depends
```
