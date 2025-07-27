#!/bin/sh
# export DBUS_SESSION_BUS_ADDRESS="unix:path=$XDG_RUNTIME_DIR/bus"
# # while true; do sleep 1; xsetroot -name "$(echo -n " " && date '+%a %k:%M:%S %d-%m-%Y')"; done &
# xrdb ~/.Xresources
setxkbmap br

emacs --fg-daemon &
flameshot &
lxqt-policykit-agent &
feh --bg-scale ~/dotfiles/wallpaper/wallpaper6.jpg
redshift &
dunst &
blueman-applet &
picom &
warp-cli disconnect &
emacsclient -c
~/bash/sidebery.sh &
rclone mount drive:/ ~/drive --vfs-cache-mode full &

# chromium --user-data-dir=/home/kayon/chrome/whats --app=https://web.whatsapp.com --class="whatsapp" &

# slack &

xrandr --output DP-1 --off --output DP-2 --off --output DP-3 --mode 1680x1050 --pos 0x0 --rotate normal --output HDMI-1 --primary --mode 1920x1080 --pos 1680x0 --rotate normal

exec qtile start
