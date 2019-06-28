**systemd run once method**
```sh
# systemd unit file
wget https://github.com/rern/RuneAudio/raw/master/expand_partition/systemd/expand.service -P /lib/systemd
systemctl enable expand

# fdisk script
wget https://github.com/rern/RuneAudio/raw/master/expand_partition/systemd/expand.sh -P /root
chmod +x /root/expand.sh

# if not already available - 'partprobe' to avoid reboot
wget https://github.com/rern/RuneAudio/raw/master/expand_partition/systemd/partprobe -P /usr/bin
chmod +xr /usr/bin/partprobe
wget https://github.com/rern/RuneAudio/raw/master/expand_partition/systemd/libparted.so.2.0.1 -P /lib
ln -s /lib/libparted.so.2.0.1 /lib/libparted.so.2
```
