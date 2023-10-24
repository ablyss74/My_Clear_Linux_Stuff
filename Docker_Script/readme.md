### The below docker scripts are for running Ubuntu GUI apps from the container on the Clear Linux host via xhost forwarding. Apps like OBS can run from the container on Clear Linux with Nvidia driver support, and obsolete apps like Jamin can run with jackd/pulseaudio modules. 


 1. Add the docker container bundle with sudo swupd bundle-add containers-basic
 2. If planning on running jackd and qjackctl via containter, set Realtime mode to -1 with  echo "-1" > /proc/sys/kernel/sched_rt_runtime_us prior to running jackd and qjackctl
 3. $HOME will be mirrored to the docker /root directory.
 
```bash 
#----- Docker (Ubuntu)

# Create a Ubuntu docker template
docker rmi ubuntu --force && echo -e 'FROM ubuntu \nRUN apt update \nRUN apt upgrade -y\nRUN apt install kmod -y\nENTRYPOINT bash' > /tmp/Dockerfile && docker build -t ubuntu < /tmp/Dockerfile -

# Run the program
xhost local:${USER} && docker run -it --privileged -v ${HOME}:/root -e JACK_NO_AUDIO_RESERVATION=1 --device /dev/snd -v /dev/shm:/dev/shm:rw --net=host -e DISPLAY=${DISPLAY} ubuntu

# Optional Load Nvidia Driver
# You don't really need the nvidia driver unless running apps like obs that could make use of it.
# Ideally you'd already have the driver downloaded on the host machine so you just navitage to /root/Download folder, then at command prompt:
bash /root/Downloads/NVIDIA-Linux-x86_64-525.60.11.run --accept-license --ui=none --no-kernel-module --no-questions
# Then save the docker so you don't have to load nvidia driver every time
# docker ps
# Get the 1st docker ID and `docker commit ID ubuntu`

# Create a startup script with xterm, gnome-terminal, konsole, or terminology.
```
```bash
#!/bin/bash

# Masking the service I find helps speed up the boot procress.
# Save this as ubuntu.sh and chmod +x and just click it.

systemctl unmask docker.service
systemctl unmask docker.socket
systemctl start docker.service
xhost +local:${USER} && xterm -e docker run -it --privileged -v ${HOME}:/root -e JACK_NO_AUDIO_RESERVATION=1 --device /dev/snd -v /dev/shm:/dev/shm:rw --net=host -e DISPLAY=:0 ubuntu
systemctl mask docker.service
systemctl mask docker.socket
systemctl stop docker.service
systemctl stop docker.socket
systemctl stop containerd.service
```
