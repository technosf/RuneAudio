#!/bin/bash

# minimized from original: https://github.com/Drewsif/PiShrink

# Args
img="$1"

# Gather info
beforesize=$(ls -lh "$img" | cut -d ' ' -f 5)
parted_output=$(parted -ms "$img" unit B print | tail -n 1)
partnum=$(echo "$parted_output" | cut -d ':' -f 1)
partstart=$(echo "$parted_output" | cut -d ':' -f 2 | tr -d 'B')
loopback=$(losetup -f --show -o $partstart "$img")
tune2fs_output=$(tune2fs -l "$loopback")
currentsize=$(echo "$tune2fs_output" | grep '^Block count:' | tr -d ' ' | cut -d ':' -f 2)
blocksize=$(echo "$tune2fs_output" | grep '^Block size:' | tr -d ' ' | cut -d ':' -f 2)

# Make sure filesystem is ok
e2fsck -p -f "$loopback"
minsize=$(resize2fs -P "$loopback" | cut -d ':' -f 2 | tr -d ' ')

# Add some free space to the end of the filesystem
minsize=$((minsize + 100))

# Shrink filesystem
resize2fs -p "$loopback" $minsize
if [[ $? != 0 ]]; then
  echo "ERROR: resize2fs failed..."
  mount "$loopback" "$mountdir"
  mv "$mountdir/etc/rc.local.bak" "$mountdir/etc/rc.local"
  umount "$mountdir"
  losetup -d "$loopback"
  exit -7
fi
sleep 1

# Shrink partition
partnewsize=$(($minsize * $blocksize))
newpartend=$(($partstart + $partnewsize))
parted -s -a minimal "$img" rm $partnum >/dev/null
parted -s "$img" unit B mkpart primary $partstart $newpartend >/dev/null

# Truncate the file
endresult=$(parted -ms "$img" unit B print free | tail -1 | cut -d ':' -f 2 | tr -d 'B')
truncate -s $endresult "$img"
aftersize=$(ls -lh "$img" | cut -d ' ' -f 5)

echo "$img : $beforesize > $aftersize"

losetup -d "$loopback"
