### Shairport Sync

**Install**
```sh
# 0.5 - remove existing files
rm /etc/shairport-sync.conf \
	/usr/bin/shairport-sync \
	/usr/lib/systemd/system/shairport-sync.service \
	/usr/share/man/man7/shairport-sync.7.gz

# install with compiled packaged --with-metadata
file=shairport-sync-3.3.1-1-armv7h.pkg.tar.xz
wget -qN https://github.com/rern/RuneAudio/raw/master/shairport-sync/$file
pacman -U $file
rm $file

# on/off script
wget -qN https://github.com/rern/RuneAudio/raw/master/shairport-sync/shairport -P /srv/http
chown http:http /srv/http/shairport
chmod 755 /srv/http/shairport
```

**Configure**
```sh
# set user as http
sed -i 's/^User=.*/User=http/; s/Group=.*/Group=http/' /usr/lib/systemd/system/shairport-sync.service

# config
sed -i '/run_this_before_play_begins/ i\
	run_this_before_play_begins = "/srv/http/shairport &";
	run_this_after_play_ends = "/srv/http/shairport off &";
' /etc/shairport-sync.conf

# fix if needed - Failed to determine user credentials: No such process
systemctl daemon-reexec
```

**Usage**
```sh
# start
systemctl start shairport-sync

# standard named pipe cat
cat /tmp/shairport-sync-metadata
# ...
# <item><type>636f7265</type><code>6173616c</code><length>18</length>
# <data encoding="base64">
# U29uZ3Mgb2YgSW5ub2NlbmNl</data></item>
# ...
# ----------------------------------------------------------------------------------------------------------------
# hex       hex2bin field              base64 (JS coversion)
# ----------------------------------------------------------------------------------------------------------------
# 61736172  asar    artist             artist   = atob( DATA );
# 6d696e6d  minm    song               song     = atob( DATA );
# 6173616c  asal    album              album    = atob( DATA );
# 70726772  prgr    elapsed/start/end  st_el_en = atob( DATA ).split( '/' ); second = st_el_en[ n ] / 44100;
# 50494354  PICT    coverart           coverart = 'url( "data:image/jpeg;base64,DATA" )'; // no conversion

# shairport-sync-metadata-reader
shairport-sync-metadata-reader < /tmp/shairport-sync-metadata
```
