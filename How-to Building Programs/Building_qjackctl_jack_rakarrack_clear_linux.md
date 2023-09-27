
### Building qjackctl, jack, and rakarrack on Clear Linux
```Bash
# Required bundles
swupd bundle-add curl c-basic qt5-dev devpkg-jack2 os-utils-gui-dev kde-frameworks5-dev

# Build Jack
git clone https://github.com/jackaudio/jack2.git jack-git
cd jack-git
./waf configure
./waf
./waf install

# Build Qjackctl
git clone https://git.code.sf.net/p/qjackctl/code qjackctl-git
cd qjackctl-git
## Temporary hack might be required
ln -s /usr/bin/androiddeployqt-qt6 /usr/bin/androiddeployqt
ln -s /usr/bin/androidtestrunner-qt6 /usr/bin/androidtestrunner
##
cmake -B build

## Nvidia Users: If build fails with OPENGL missing libs try...
cmake -D_OPENGL_LIB_PATH=/opt/nvidia/lib -B build

cmake --build build
cmake --install build

# Set the system in realtime mode
echo -1 > /proc/sys/kernel/sched_rt_runtime_us
# load kernel module snd_seq for midi mapping also required for rakarrack.
modprobe snd_seq
# You might need to tell qjackctl to use /usr/local/lib
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib/

# Run 
qjackctl

# Open qjackctl setting and set audio interface: hw:PCH or something similar, sample rate: 48khz, frames/period: 1024, midi driver: seq

# Restart qjackctl

#Buld rakarrack ( open up a new terminal in your development folder )
git clone git://rakarrack.git.sourceforge.net/gitroot/rakarrack/rakarrack rakarrack-git
cd rakarrack-git
./autogen.sh
./configure
make
make install

# Run
rakarrack
```
