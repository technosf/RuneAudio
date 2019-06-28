## RuneAudio+RuneUIe.img

### Upgrade
- MPD 0.21.10
- Samba 4.10.5
- NGINX 1.16.0

## Reset
- mirrorlist reset - replace /etc/pacman.d/mirrorlist
- remove /srv/http/assets/img/{bookmarks,coverarts,playlists,webradios,webradiopl,tmp}
- clear packages cache - rm /var/cache/pacman/pkg/*
- mpd database reset : 
	- rm /var/lib/mpd/* /var/lib/mpd/playlists/*
	- unmount usb drive
	- mpd update

### Startup script
  - expand partition
	- makeDirLink : bookmarks, playlists, webradios, webradiopl
	- mpd update
	- count

### Conversion addons
	- playlists, webradios, bookmarks
  
