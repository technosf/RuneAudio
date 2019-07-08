Chromium Browser
---
(Install Chromium breaks default MPD. MPD Upgrade needed.)  

**Chromium** has the least issues as an alternative browser
- Chromium cannot be installed without `ffmpeg` upgrade
- `ffmpeg` upgrade breaks `mpd-rune`
- upgrade `ffmpeg` + `mpd` > install `chromium`
- fix ipv6 probing
- fix scaling

**Run without matchbox-window-manager**
```sh
# fix: Only console users are allowed to run the X server
cat << EOF > /etc/X11/Xwrapper.config
allowed_users=anybody
needs_root_rights=yes
EOF


exec chromium --app=http://localhost --start-fullscreen --disable-gpu --force-device-scale-factor=1.8

```
