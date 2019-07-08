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
mkdir -p /home/http
cat << EOF > /home/http/.xinitrc
#!/bin/bash
exec chromium --app=http://localhost --start-fullscreen --disable-gpu --force-device-scale-factor=1.8
EOF
chown -R http:http /home/http

su http
startx -- -nocursor
```
