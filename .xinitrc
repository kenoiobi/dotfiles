#!/bin/sh
export DBUS_SESSION_BUS_ADDRESS="unix:path=$XDG_RUNTIME_DIR/bus"
while true; do sleep 1; xsetroot -name "$(echo -n " " && date '+%a %k:%M:%S %d-%m-%Y')"; done &
xrdb ~/.Xresources
# setxkbmap br -option ctrl:swapcaps

# ~/audiorelay/mic.sh &
lxqt-policykit-agent &
# pulseaudio --start
feh --bg-scale ~/git/dotfiles/wallpaper6.jpg
redshift &
picom &
dunst &
warp-cli disconnect

# chromium &
firefox &
emacs &
zen-browser &
virt-manager &
audiorelay &
thunar &
urxvt -name btop -e btop &

# scratchpads
chromium --user-data-dir=/home/kayon/chrome/whats --class=whatsapp "https://web.whatsapp.com" &
discord &
slack &

exec dwm
