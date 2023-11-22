## Run compiz off container ( ubuntu ) on Clear Linux and also pass pipewire from container for running apps like mpv or vlc

- Define pulse-socket in pipewire-pulse.conf...
  
  For pipewire sound from container apps to host we need to tell pipewire to create a pulse socket.

  Copy /usr/share/pipewire/pipewire-pulse.conf to /etc/pipewire/pipewire-pulse.conf 

  Uncomment line 90 and change "something" to "unix:/tmp/pulse-socket" 

  Restart pipewire-pulse with ```systemctl --user restart pipewire-pulse```


- Set xhost...

  Best to have this start automatically during boot or login startup script.
  If you are on a true multi-user system, this may not be ideal. Best for single user systems. 

   ```xhost +si:localuser:${USER}```



    Create docker image. We will use ubuntu here and name the container ubuntu as well. 
    ```docker run -itd --name ubuntu --privileged -v ${HOME}:/root -e JACK_NO_AUDIO_RESERVATION=1 --device /dev/snd -v /dev/shm:/dev/shm:rw -v /tmp/pulse-socket --net=host -e DISPLAY=:0 ubuntu unix:/tmp/pulse-socket"```
    Start the container, run basic update and upgrade
    ```docker start ubuntu
   docker exec ubuntu apt update
    docker exec ubuntu apt upgrade -y```
    If planning to use nvidia driver on the caontiner, we need kmod installed
```
docker exec ubuntu apt install kmod -y
```
Download the same version of the nivida driver that is used on the host machine to $HOME/Downalods update the version in the command below to match that. 
```
docker exec ubuntu bash /root/Downloads/NVIDIA-Linux-x86_64-545.23.06.run --accept-license --ui=none --no-kernel-module --no-questions
```
Install compiz to run on the host.

```
docker exec ubuntu apt install compiz compizconfig-settings-manager compiz-plugins compiz-plugins-default compiz-plugins-extra compiz-plugins-main emerald emerald-themes -y

```
Start Compiz configuration manager and import profile, or set manually  
```
docker exec ubuntu ccsm
```
Import [compiz.profile](compiz.profile) provided as a download in this repository or unless you know how to set your own default plugins 

Then start compiz
```
docker exec ubuntu emerald --replace
docker exec ubuntu compiz --replace
```
Add to startup script to automatically start compiz at boot
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
