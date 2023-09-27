```bash
# So you want to get jack and pulseaudio working together and ....
# Keep your old pulseaudio to fall back ?

# Requires jack to be already installed and the necessary building tools/libs.
# Qjackctl works great for this.

# Create a folder called "Dev" if you want and open up a terminal and cd Dev

# Then run the following commands
# This will pull the latest pulseaudio into a folder called pulse-git
# Anytime you want to update the source code without downloading the entire package just type "git pull"

git clone git://anongit.freedesktop.org/pulseaudio/pulseaudio pulse-git
cd pulse-git
meson build
meson compile -C build

# Then open up the file default.pa with your text editor of choice.
# It's located build/src/daemon/default.pa

gnome-text-editor ./build/src/daemon/default.pa

# Then add these two lines under the "Load audio drivers statically" to load jack with pulse

load-module module-jack-sink
load-module module-jack-source

# You can then start up your custom pulseaudio with the following command.
# I'd recommend first starting jackd with Qjackctl
# From within the pulse-git directory type...

pulseaudio -k ; sleep 1s ; build/src/daemon/pulseaudio -D -n -F build/src/daemon/default.pa -p $(pwd)/build/src/modules/

# When you are done testing you can stop the custom pulse and jack and restart the default pulseaudio like so...

pkill jackd ; pulseaudio -k ; sleep 1s ; cd $HOME ; pulseaudio --start

```

