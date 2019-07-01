#!/bin/bash

# usage: mountimg FILE.img [1]
# 1 - /boot partition

loops=$( kpartx -l "$1" )

if (( $# == 1 )); then  # root
  loop=$( echo "$loops" | tail -1 | cut -d' ' -f1 )
  mntpoint=/media/root
else                     # boot
  loop=$( echo "$loops" | head -1 | cut -d' ' -f1 )
  mntpoint=/media/boot
fi

kpartx -a "$1"
mkdir -p $mntpoint
mount /dev/mapper/$loop $mntpoint
echo "Partition available at $mntpoint"
