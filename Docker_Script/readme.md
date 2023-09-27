

- Some things are expected...
 1. Docker bundle is already installed -- sudo swupd bundle-add containers-basic
 2. You will run this with sudo or root -- If using sudo just add it to the first line of this example to invoke it.
 3. Realtime mode set to -1 when using qjackctl   -- echo "-1" > /proc/sys/kernel/sched_rt_runtime_us
 4. $HOME will be mirrored to the docker /root $HOME directory.
 
```bash 
#----- Docker (Ubuntu)

# Create a Ubuntu docker template
docker rmi ubuntu --force && echo -e 'FROM ubuntu \nRUN apt update \nRUN apt upgrade -y\nRUN apt install kmod -y\nENTRYPOINT bash' > /tmp/Dockerfile && docker build -t ubuntu < /tmp/Dockerfile -

# Run the program
xhost local:${USER} && docker run -it --privileged -v ${HOME}:/root -e JACK_NO_AUDIO_RESERVATION=1 --device /dev/snd -v /dev/shm:/dev/shm:rw --net=host -e DISPLAY=${DISPLAY} ubuntu

# Optional Load Nvidia Driver ( Ideally you'd already have the driver in /root/Download folder )
# In docker terminal ...
bash /root/Downloads/NVIDIA-Linux-x86_64-525.60.11.run --accept-license --ui=none --no-kernel-module --no-questions
# Then save the docker so you don't have to load nvidia driver every time
# docker ps
# Get the 1st docker ID and `docker commit ID ubuntu`

# Create a startup scrip with xterm, gnome-terminal, konsole, or terminology. 

```
