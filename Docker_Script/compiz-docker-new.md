For pipewire sound from container apps to host we need to tell pipewire to create a pulse socket.

Define pulse-socket in pipewire-pulse.conf 

Copy /usr/share/pipewire/pipewire-pulse.conf to /etc/pipewire/pipewire-pulse.conf 

Change "something" and uncomment line 90  "unix:/tmp/pulse-socket" 

estart pipewire-pulse with systemctl --user restart pipewire-pulse
```
xhost +local:${USER} && docker run -itd --name ubuntu --privileged -v ${HOME}:/root -e JACK_NO_AUDIO_RESERVATION=1 --device /dev/snd -v /dev/shm:/dev/shm:rw -v /tmp/pulse-socket --net=host -e DISPLAY=:0 ubuntu unix:/tmp/pulse-socket" 
```
```
docker start ubuntu
docker exec ubuntu apt update
docker exec ubuntu apt upgrade -y
```
For install the nvidia kernel we need kmod
```docker exec ubuntu apt install kmod -y
docker exec ubuntu bash /root/Downloads/NVIDIA-Linux-x86_64-545.23.06.run --accept-license --ui=none --no-kernel-module --no-questions
```
Install compiz to run on the host.
``` docker exec ubuntu apt install compiz compizconfig-settings-manager compiz-plugins compiz-plugins-default compiz-plugins-extra compiz-plugins-main emerald emerald-themes -y
```
Start Compiz configuration manager and import profile, or set manually  
```docker exec ubuntu ccsm
```
Start compiz
```
docker exec ubuntu emerald --replace
docker exec ubuntu compiz --replace
```
Add to a startup script to automatically starte compiz at boot
```#!/bin/bash
docker start ubuntu &
sleep 1s
docker exec ubuntu emerald --replace &
docker exec ubuntu compiz --replace &
```

Revert back to other window manager
in krunner type: ```kwin_x11 --replace```
Last thing stop the container
```Docker ubuntu stop```
