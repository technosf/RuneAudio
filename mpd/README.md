MPD Upgrade
---
_Tested on RuneAudio 0.3 and 0.4b_

Upgrade MPD to latest version, 0.3:0.19.17 / 0.4b:0.19.19 to **0.21.4** (as of 20190104). (changelog: [www.musicpd.org](www.musicpd.org))
- RuneAudio installed customized MPD 0.19 which cannot be upgraded normally
- RuneAudio has trouble with system wide upgrade. **Do not** `pacman -Syu`
- Fix issues in normal upgrade (but broken Midori):
	- fix missing libs
		- libcrypto.so.1.0
		- libssl.so.1.0
	- remove package conflicts
		- mpd-rune
		- ffmpeg-rune
		- ashuffle-rune
	- install missing packages
		- gcc-libs
		- ffmpeg
		- icu
		- libnfs
		- libwebp
		- wavpack
	- python
		- switch to python2
		- install flask
	- fix systemd unknown lvalue
	- fix mpd.log permission
- **mpc** will be upgraded as well
- **issue:**
	- broken Midori

**Upgrade**  
from [**Addons Menu**](https://github.com/rern/RuneAudio_Addons)
