MPD Upgrade
---
_Tested on RuneAudio 0.5b_

Upgrade MPD to latest version, **0.21.10** (as of 20190606). (changelog: [www.musicpd.org](www.musicpd.org))
- RuneAudio installed customized MPD which cannot be upgraded normally
- RuneAudio has trouble with system wide upgrade. **Do not** `pacman -Syu`
- Fix issues in normal upgrade (but broken Midori):
	- fix missing libs
		- libcrypto
		- libssl
		- libicu*
		- libreadline
	- remove package conflicts
		- mpd-rune
		- ffmpeg-rune
		- ashuffle-rune
	- install missing packages
		- gcc
		- ffmpeg
		- libnfs
		- libwebp
		- wavpack
	- fix systemd unknown lvalue
	- fix mpd.log permission
- **mpc** will be upgraded as well
- **issue:**
	- broken Midori - install Chromium instead

**Upgrade**  
from [**Addons Menu**](https://github.com/rern/RuneAudio_Addons)
