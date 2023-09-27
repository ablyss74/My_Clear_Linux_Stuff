#!/bin/bash

# This is basically a startup script I use for starting my docker container in Clear Linux for running container apps
# Masking the service I find helps speed up the boot procress.
# change docker_id to match your container id. 


systemctl unmask docker.service
systemctl unmask docker.socket
systemctl start docker.service
xhost +local:${USER} && xterm -e docker run -it --privileged -v ${HOME}:/root -e JACK_NO_AUDIO_RESERVATION=1 --device /dev/snd -v /dev/shm:/dev/shm:rw --net=host -e DISPLAY=:0 docker_id
systemctl mask docker.service
systemctl mask docker.socket
systemctl stop docker.service
systemctl stop docker.socket
systemctl stop containerd.service
