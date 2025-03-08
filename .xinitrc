#!/bin/sh
export DBUS_SESSION_BUS_ADDRESS="unix:path=$XDG_RUNTIME_DIR/bus"
while true; do sleep 1; xsetroot -name "$(date)"; done &
xrdb ~/.Xresources
setxkbmap br -option ctrl:swapcaps

# ~/audiorelay/mic.sh &
feh --bg-scale ~/git/dotfiles/wallpaper3.jpg
redshift &
picom &
dunst &

chromium &
firefox &
emacs &
flatpak run app.zen_browser.zen &
virt-manager &
audiorelay &
thunar &
urxvt -name btop -e btop &

exec dwm
