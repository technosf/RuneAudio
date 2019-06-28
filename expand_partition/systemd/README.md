**systemd run once method**
```sh
# systemd unit file
/lib/systemd/expand.service
systemctl enable expand

# fdisk script
/root/expand.sh
chmod +x /root/expand.sh

# if not already available - 'partprobe' to avoid reboot
/usr/bin/partprobe
chmod +xr /usr/bin/partprobe
/usr/lib/libparted.so.2.0.1
ln -s /usr/lib/libparted.so.2.0.1 /usr/lib/libparted.so.2
```
