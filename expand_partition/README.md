Expand Partition
---
As of 20190822, this has been integrated to [**RuneAudio+R e1**](https://github.com/rern/RuneAudio-Re1).

- **RuneAudio** install to 2GB partition by default.  
- This left the rest of the SD card not available for use.  
- Expand the partiton to full capacity **without reboot**.  
- Install package **Parted**  
- Expand default 2GB partition to full capacity of SD card with **fdisk**  
- Probe new partition with **partprobe** (by **Parted**)  
- Resize to new partition with **resize2fs**   

**Script - Expand /dev/mmcblk0p2**
```sh
echo -e "d\n\nn\n\n\n\n\nw" | fdisk /dev/mmcblk0 &>/dev/null
partprobe /dev/mmcblk0
resize2fs /dev/mmcblk0p2
```
