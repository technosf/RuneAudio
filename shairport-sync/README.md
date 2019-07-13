### Shairport Sync

**Install**
```sh
# 0.5 - remove existing files
rm /etc/shairport-sync.conf \
	/usr/bin/shairport-sync \
	/usr/lib/systemd/system/shairport-sync.service

# install with compiled packaged --with-metadata
file=shairport-sync-3.3.1-1-armv7h.pkg.tar.xz
wget -qN https://github.com/rern/RuneAudio/raw/master/shairport-sync/$file
pacman -U $file
rm $file

# (alrady in RuneUIe)
# on/off script 
# set sudoers.d for user shairport-sync
# fix coverart write permission

# config ( output_device = "hw:N" - aplay -l | grep "^card" )
file=/etc/shairport-sync.conf
mv $file{,.backup}
cat << 'EOF' > $file
sessioncontrol = {
	run_this_after_play_ends = "/srv/http/enhanceshairport off &";
}
alsa = {
	output_device = "hw:0";
}
EOF

# fix if needed - Failed to determine user credentials: No such process
systemctl daemon-reexec
```

**Metadata**
```sh
# start
systemctl start shairport-sync

# data from fifo / named pipe
cat /tmp/shairport-sync-metadata
# ...
# <item><type>636f7265</type><code>6173616c</code><length>18</length>
# <data encoding="base64">
# U29uZ3Mgb2YgSW5ub2NlbmNl</data></item>
# ...
# ----------------------------------------------------------------------------------------------------------------
# hex       hex2bin field              base64 decode - PHP / JS
# ----------------------------------------------------------------------------------------------------------------
# 61736172  asar    artist             base64_decode( $DATA ) / atob( DATA )
# 6d696e6d  minm    song               base64_decode( $DATA ) / atob( DATA )
# 6173616c  asal    album              base64_decode( $DATA ) / atob( DATA )
# 70726772  prgr    elapsed/start/end  base64_decode( $DATA ) / atob( DATA )
# 50494354  PICT    coverart           "data:image/jpeg;base64,$DATA" // already base64

# shairport-sync-metadata-reader
wget -qN https://github.com/rern/RuneAudio/raw/master/shairport-sync/shairport-sync-metadata-reader -P /usr/local/bin
chmod 755 /usr/local/bin/shairport-sync-metadata-reader
shairport-sync-metadata-reader < /tmp/shairport-sync-metadata
```
