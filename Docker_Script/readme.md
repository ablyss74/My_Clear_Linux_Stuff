

- Some things are expected...
 1. Docker bundle is already installed -- sudo swupd bundle-add containers-basic
 2. You will run this with sudo or root -- If using sudo just add it to the first line of this example to invoke it.
 3. Realtime mode set to -1 when using qjackctl   -- echo "-1" > /proc/sys/kernel/sched_rt_runtime_us
 4. $HOME will be mirrored to the docker /root $HOME directory.
 
```bash 

#----- Qjackctl Docker

# Create a docker Qjackctl template
docker rmi ubuntu_jackctl --force && echo -e 'FROM ubuntu \nRUN apt update \nRUN apt upgrade -y\nRUN apt install qjackctl -y\nENTRYPOINT qjackctl' > /tmp/Dockerfile && docker build -t ubuntu_jackctl < /tmp/Dockerfile -

# Run the program
xhost local:${USER} && docker run -it --privileged -v ${HOME}:/root -e JACK_NO_AUDIO_RESERVATION=1 --device /dev/snd -v /dev/shm:/dev/shm:rw --net=host -e DISPLAY=${DISPLAY} ubuntu_jackctl

# Create a startup exe with terminology
echo -e "xhost local:${USER}\nterminology -e docker run -it --privileged -v ${HOME}:/root -e JACK_NO_AUDIO_RESERVATION=1 --device /dev/snd -v /dev/shm:/dev/shm:rw --net=host -e DISPLAY=${DISPLAY} ubuntu_jackctl" > ./qjackctl && chmod +x ./qjackctl

# Or...

# Create a startup exe with gnome-terminal
echo -e "xhost local:${USER}\ngnome-terminal -- docker run -it --privileged -v ${HOME}:/root -e JACK_NO_AUDIO_RESERVATION=1 --device /dev/snd -v /dev/shm:/dev/shm:rw --net=host -e DISPLAY=${DISPLAY} ubuntu_jackctl" > ./qjackctl && chmod +x ./qjackctl

#----- JAMIN Docker

# Create a docker jamin template
docker rmi ubuntu_jamin --force && echo -e 'FROM ubuntu \nRUN apt update \nRUN apt upgrade -y\nRUN apt install jamin -y\nENTRYPOINT jamin' > /tmp/Dockerfile && docker build -t ubuntu_jamin < /tmp/Dockerfile -


# Run the program
xhost local:${USER} && docker run -it --privileged -v ${HOME}:/root -e JACK_NO_AUDIO_RESERVATION=1 --device /dev/snd -v /dev/shm:/dev/shm:rw --net=host -e DISPLAY=${DISPLAY} ubuntu_jamin

# Create a startup exe with terminology
echo -e "xhost local:${USER}\nterminology -e docker run -it --privileged -v ${HOME}:/root -e JACK_NO_AUDIO_RESERVATION=1 --device /dev/snd -v /dev/shm:/dev/shm:rw --net=host -e DISPLAY=${DISPLAY} ubuntu_jamin" > ./jamin && chmod +x ./jamin

# Or...

# Create a startup exe with gnome-terminal
echo -e "xhost local:${USER}\ngnome-terminal -- docker run -it --privileged -v ${HOME}:/root -e JACK_NO_AUDIO_RESERVATION=1 --device /dev/snd -v /dev/shm:/dev/shm:rw --net=host -e DISPLAY=${DISPLAY} ubuntu_jamin" > ./jamin && chmod +x ./jamin

#----- Rakarrack Docker
# Create a docker rakarrack template
docker rmi debian_rakarrack --force && echo -e 'FROM ubuntu \nRUN apt update \nRUN apt upgrade -y\nRUN apt install rakarrack -y\nENTRYPOINT rakarrack' > /tmp/Dockerfile && docker build -t debian_rakarrack < /tmp/Dockerfile -


# Run the program
xhost local:${USER} && docker run -it --privileged -v ${HOME}:/root -e JACK_NO_AUDIO_RESERVATION=1 --device /dev/snd -v /dev/shm:/dev/shm:rw --net=host -e DISPLAY=${DISPLAY} debian_rakarrack

# Create a startup exe with terminology
echo -e "xhost local:${USER}\nterminology -e docker run -it --privileged -v ${HOME}:/root -e JACK_NO_AUDIO_RESERVATION=1 --device /dev/snd -v /dev/shm:/dev/shm:rw --net=host -e DISPLAY=${DISPLAY} debian_rakarrack" > ./rakarrack && chmod +x ./rakarrack

# Or...

# Create a startup exe with gnome-terminal
echo -e "xhost local:${USER}\ngnome-terminal -- docker run -it --privileged -v ${HOME}:/root -e JACK_NO_AUDIO_RESERVATION=1 --device /dev/snd -v /dev/shm:/dev/shm:rw --net=host -e DISPLAY=${DISPLAY} debian_rakarrack" > ./rakarrack && chmod +x ./rakarrack

#----- LMMS Docker
# Create a docker lmms template
docker rmi debian_lmms --force && echo -e 'FROM ubuntu \nRUN apt update \nRUN apt upgrade -y\nRUN apt install lmms -y\nENTRYPOINT lmms --allowroot' > /tmp/Dockerfile && docker build -t debian_lmms < /tmp/Dockerfile -


# Run the program
xhost local:${USER} && docker run -it --privileged -v ${HOME}:/root -e JACK_NO_AUDIO_RESERVATION=1 --device /dev/snd -v /dev/shm:/dev/shm:rw --net=host -e DISPLAY=${DISPLAY} debian_lmms

# Create a startup exe with terminology
echo -e "xhost local:${USER}\nterminology -e docker run -it --privileged -v ${HOME}:/root -e JACK_NO_AUDIO_RESERVATION=1 --device /dev/snd -v /dev/shm:/dev/shm:rw --net=host -e DISPLAY=${DISPLAY} debian_lmms" > ./lmms && chmod +x ./lmms

# Or...

# Create a startup exe with gnome-terminal
echo -e "xhost local:${USER}\ngnome-terminal -- docker run -it --privileged -v ${HOME}:/root -e JACK_NO_AUDIO_RESERVATION=1 --device /dev/snd -v /dev/shm:/dev/shm:rw --net=host -e DISPLAY=${DISPLAY} debian_lmms" > ./lmms && chmod +x ./lmms
```
