
# Building Enlightenment, efl, and terminology on Clear Linux
If wanting to test wayland there are official steps online just not covered here. Besure to read the caution about using wayland with Nvidia drivers,

This will build enlightenment, efl, and terminology on Clear Linux w/ X11 and no support for testing wayland


```bash 
# Required bundles - 
swupd bundle-add desktop-dev os-clr-on-clr-dev c-basic-legacy os-utils-gui-dev devpkg-libspectre devpkg-LibRaw  

# Clone the repos
git clone https://git.enlightenment.org/enlightenment/efl.git efl-git
git clone https://git.enlightenment.org/enlightenment/enlightenment.git enlightenment-git
git clone https://git.enlightenment.org/enlightenment/terminology.git

# Enter efl directory and build
cd efl-git
export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig:/usr/lib/pkgconfig


# You can build here without Skim and ibus support if you want.
# -Dopengl=full is recommended if using nvidia driver. 
# meson . build -Dopengl=full -Decore-imf-loaders-disabler="scim,ibus"

 
# If building with Scim 
# First download it, build/intall

git clone https://github.com/scim-im/scim
cd scim
./bootstrap
./configure
make && make install

# Then proceed to configure meson for Ninja
meson . build -Dopengl=full 
ninja -C build
ninja -C build install 
# Done

#------------------------------------------ 
# Enter enlightenment directory and build  
cd enlightenment-git
export LD_LIBRARY_PATH=/opt/nvidia/lib:/usr/local/lib64:/usr/local/lib 

#******* Important Hackery  *******

## Make sure this path is correct otherwise enlightenment will not build
## Change $HOME/Dev to the correct path though as I keep on my builds in $HOME/Dev
export PKG_CONFIG_PATH=${PKG_CONFIG_PATH}:${HOME}/Dev/efl-git/build/meson-private/

# ******* /Important Hackery  ******* 

meson . build
ninja -C build
ninja -C build install
#done

#------------------------------------------
# Enter terminology directory and build  
meson . build
ninja -C build
ninja -C build install 
#Done
#------------------------------------------


# Disable Clear Linux graphical login service
# Not always required depending on your install
systemctl set-default multi-user.target

# Create an .xinitrc file and paste these lines.
# nvidia path optional but wont hurt to leave as is.
export LD_LIBRARY_PATH=/opt/nvidia/lib:/usr/local/lib64:/usr/local/lib
export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig:/usr/lib/pkgconfig

# Privileged user stuff - uncomment if need be.
# networkctl reload ## For some reason network state may stay degraded and this fixes that.
# echo "-1" > /proc/sys/kernel/sched_rt_runtime_us # -- If running jackd with realtime.
# modprobe snd_seq # if running midi apps like lmms or rakarrack this helps.

# XDG env variables may need to be manually set.
# If that's the case export them too
# Inlucded examples may not be the same for your system.
# export XDG_CONFIG_DIRS=/usr/share/xdg:/etc/xdg
# export XDG_SEAT=seat0
# export XDG_SESSION_TYPE=X11
# export XDG_CURRENT_DESKTOP=Enlightenment
# export XDG_ACTIVATION_TOKEN=
# export XDG_SESSION_CLASS=user
# export XDG_VTNR=1
# export XDG_SESSION_ID=1
# export XDG_RUNTIME_DIR=
# export XDG_DATA_DIRS=

# Logout or reboot if needed then once at command prompt run:
startx

# Optional Autologin
systemctl edit getty@tty1.service

# Then add the following replacing myusername with your login name
[Service]
ExecStart=
ExecStart=-/sbin/agetty --noissue --autologin myusername %I $TERM
Type=idle

# Last thing...
# Create or edit the file $HOME/.profile and add the following startup script.
# Sleep 1s is needed on my machine. W/ out it the dual monitor support doesn't register. :\ strange I know
[[ ! $(ps -A | grep enlightenment) ]] && sleep 1s && startx

### Privileged user stuff - uncomment if need be.
#[[ ! $(ps -A | grep enlightenment) ]] && sleep 1s &&  sudo -u $(whoami) startx
```
