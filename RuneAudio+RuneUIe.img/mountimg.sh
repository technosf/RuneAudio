#!/bin/bash

# usage: mountimg FILE.img [1]
# 1 - /boot partition

img=$1

fd=$( fdisk -lo Start "$img" )
unitbyte=$( echo "$fd" | grep '^Units' | cut -d' ' -f8 )

if [[ $# == 1 ]]; then  # root
  start=$( echo "$fd" | tail -1 )
  mntpoint=/media/root
else                    # boot
  start=$( echo "$fd" | tail -2 | head -1 )
  mntpoint=/media/boot
fi
mkdir -p $path
mount -o loop,offset=$(( unitbyte * start )) "$img" $mntpoint
echo "Partition available at $mntpoint
