```bash
# This enables jackd and pulseaudio to work together
# While also keeping the original pulseaudio to fall back on.

# Requires jackd to be already installed unless using jackd in a container and the necessary building tools/libs.


git clone git://anongit.freedesktop.org/pulseaudio/pulseaudio pulse-git
cd pulse-git
meson build
meson compile -C build

# Edit  ./build/src/daemon/default.pa
# Add these two lines under the "Load audio drivers statically" to load jack with pulse

load-module module-jack-sink
load-module module-jack-source

# From within the pulse-git directory type...

pulseaudio -k ; sleep 1s ; build/src/daemon/pulseaudio -D -n -F build/src/daemon/default.pa -p $(pwd)/build/src/modules/

# When done testing, stop the custom pulse and jack and restart the default pulseaudio like so...

pkill jackd ; pulseaudio -k ; sleep 1s ; cd $HOME ; pulseaudio --start

```

