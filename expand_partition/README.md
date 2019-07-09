Expand Partition
---

_Tested on RuneAudio 0.3 and 0.4b_  

- **RuneAudio** install to 2GB partition by default.  
- This left the rest of the SD card not available for use.  
- Expand the partiton to full capacity **without reboot**.  


**Expand**  
from [**Addons Menu**](https://github.com/rern/RuneAudio_Addons)  

or from SSH terminal
```sh
wget -qN --show-progress https://github.com/rern/RuneAudio/raw/master/expand_partition/expand.sh; chmod +x expand.sh; ./expand.sh
```

- Install package **Parted**  
- Expand default 2GB partition to full capacity of SD card with **fdisk**  
- Probe new partition with **partprobe** (by **Parted**)  
- Resize to new partition with **resize2fs**   

**Script**
```sh
echo -e "d\n\nn\n\n\n\n\nw" | fdisk /dev/mmcblk0 &>/dev/null
partprobe /dev/mmcblk0
resize2fs /dev/mmcblk0p2
```
