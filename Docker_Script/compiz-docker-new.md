## Run compiz off container ( ubuntu ) on Clear Linux and also pass pipewire from container for running apps like mpv

### Before we do anything we need to install the docker software and start it

```
swupd bundle-add containers-basic
systemctl start docker.service # start the service
systemctl enable docker.service # enables startup at boot
```

### Set xhost...

  Best to have this start automatically during boot or login startup script.
  If you are on a true multi-user system, this may not be ideal. Best for single user systems. 

   ```xhost +si:localuser:${USER}```



### Create docker image. We will use ubuntu here and name the container ubuntu as well. 

```
docker run -itd --name ubuntu --privileged -v ${HOME}:/root -e JACK_NO_AUDIO_RESERVATION=1 --device /dev/snd -v /dev/shm:/dev/shm:rw -v /tmp/pulse-socket -e PULSE_SERVER=unix:/tmp/pulse-socket --net=host -e DISPLAY=:0 ubuntu
```

### Start the container, run basic update and upgrade
```
docker start ubuntu
docker exec ubuntu apt update
docker exec ubuntu apt upgrade -y
```

### If planning to use nvidia driver on the container, we need kmod installed
```
docker exec ubuntu apt install kmod -y
```
### Download the same version of the nivida driver that is used on the host machine to $HOME/Downalods update the version in the command below to match that. 
```
docker exec ubuntu bash /root/Downloads/NVIDIA-Linux-x86_64-545.29.06.run --accept-license --ui=none --no-kernel-module --no-questions
```
### Install compiz to passthru to the host.

```
docker exec ubuntu apt install compiz compizconfig-settings-manager compiz-plugins compiz-plugins-default compiz-plugins-extra compiz-plugins-main emerald emerald-themes -y

```
### Start Compiz configuration manager and import [compiz.profile](compiz.profile) provided as a download in this repository or unless you know how to set your own default plugins 
```
docker exec ubuntu ccsm
```

### Then start compiz
```
docker exec ubuntu emerald --replace
docker exec ubuntu compiz --replace
```
### Add to startup script to automatically start compiz at boot
```#!/bin/bash
xhost +si:localuser:${USER}
docker start ubuntu &
sleep 1s
docker exec ubuntu emerald --replace &
docker exec ubuntu compiz --replace &
```

### Revert back to other window manager
In krunner type: ```kwin_x11 --replace```

### Last thing stop the container
```docker ubuntu stop```

### Pass Pipewire Sound from container to host
### Define pulse-socket in pipewire-pulse.conf...
  
  For pipewire sound from container apps to host we need to tell pipewire to create a pulse socket.

  Copy /usr/share/pipewire/pipewire-pulse.conf to /etc/pipewire/pipewire-pulse.conf 

  Uncomment line 90 and change "something" to "unix:/tmp/pulse-socket" 

  After installing mpv inside the container, restart pipewire-pulse on the host with ```systemctl --user restart pipewire-pulse```
