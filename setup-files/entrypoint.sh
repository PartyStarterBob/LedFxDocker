#!/bin/bash

# Start avahi daemon for WLED auto discovery
avahi-daemon --daemonize --no-drop-root

# https://superuser.com/questions/1539634/pulseaudio-daemon-wont-start-inside-docker
# Start the pulseaudio server
rm -rf /var/run/pulse /var/lib/pulse /root/.config/pulse
pulseaudio -D --verbose --exit-idle-time=-1 --system --disallow-exit

if [[ -v FORMAT ]]; then
    ./pipe-audio.sh
fi

if [[ -v HOST ]]; then
    snapclient --host "$HOST" --daemon 1
fi

if [[ -v SQUEEZE ]]; then
    ./squeeze.sh
fi

mkdir -p /app/ledfx-config

mv -vn /app/config.yaml /app/ledfx-config/
mkdir -p /root/.ledfx
ledfx -c /app/ledfx-config 
