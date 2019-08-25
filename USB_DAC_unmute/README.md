USB DAC Unmute
---
Fix mute USB DAC 

**amixer**
```sh
# device list
aplay -l | grep '^card'

# amixer list - numid ( names: amixer -c <card#> scontrols )
amixer -c <card#> controls

# master volume numid
amixer -c <card#> controls | grep "Playback Volume'$" | cut -d',' -f1

# set volume level 50%
amixer -c <card#> cset <numid=#> 50%
```
 
**ALSA mixer**  
```sh
alsamixer
```
![1](https://github.com/rern/RuneAudio/blob/master/USB_DAC_unmute/1.png)  

**Select Sound Device**  
`F6` select menu  
![2](https://github.com/rern/RuneAudio/blob/master/USB_DAC_unmute/2.png)  

**Setting**  
`MM` = mute  
![3](https://github.com/rern/RuneAudio/blob/master/USB_DAC_unmute/3.png)  

**Unmute**
- `M` toggles `MM` mute <-> `00` unmute  
- `left arrow` `right arrow` switches channel  
- `Esc` exit  

![4](https://github.com/rern/RuneAudio/blob/master/USB_DAC_unmute/4.png)  

**Save Setting**  
```sh
alsactl store
```
