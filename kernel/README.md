### Kernel Update

**RuneAudio+R e1.1** was successfully upgraded to **`4.19.71-2-ARCH`**.
```sh
mv /boot/cmdline.txt{,.backup}
mv /boot/config.txt{,.backup}

pacman -Sy raspberrypi-firmware raspberrypi-bootloader linux-raspberrypi linux-raspberrypi-headers

mv /boot/cmdline.txt{.backup,}
mv /boot/config.txt{.backup,}

reboot
```

### `/boot/overlays`
- I2S modules: https://github.com/raspberrypi/linux/tree/rpi-4.19.y/arch/arm/boot/dts
