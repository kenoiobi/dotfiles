#!/bin/sh
# export DBUS_SESSION_BUS_ADDRESS="unix:path=$XDG_RUNTIME_DIR/bus"
while true; do sleep 1; xsetroot -name "$(echo -n " " && date '+%a %k:%M:%S %d-%m-%Y ')"; done &
xrdb ~/.Xresources
# setxkbmap br -option ctrl:swapcaps
kanata -c ~/dotfiles/kanata/.config/kanata/kanata.kbd

# Necessary for xdg to properly work on nixos
dbus-update-activation-environment --systemd DISPLAY
systemctl --user import-environment PATH
systemctl --user restart xdg-desktop-portal.service

# background processes
flameshot &
lxqt-policykit-agent &
feh --bg-scale ~/dotfiles/wallpaper/wallpaper3.jpg
redshift &
dunst &
blueman-applet &
# picom &
warp-cli disconnect &
# ~/bash/sidebery.sh &
rclone mount drive:/ ~/drive --vfs-cache-mode full &
nm-applet &
cbatticon &
# mechvibes &


# autostart
emacs &
librewolf &

keepassxc &
obs &
Vial &

pavucontrol &
blueman-manager &

xrandr --output DisplayPort-0 --off --output DisplayPort-1 --off --output DisplayPort-2 --mode 1680x1050 --pos 0x0 --rotate normal --output HDMI-A-0 --primary --mode 1920x1080 --pos 1680x0 --rotate normal

# exec qtile start
exec dwm
