#!/bin/sh
# export DBUS_SESSION_BUS_ADDRESS="unix:path=$XDG_RUNTIME_DIR/bus"

# Include Flatpak app desktop entries so Rofi (and other launchers) can find them
export XDG_DATA_DIRS="${HOME}/.local/share/flatpak/exports/share:/var/lib/flatpak/exports/share:${XDG_DATA_DIRS:-/usr/local/share:/usr/share}"

while true; do
	sleep 1
	xsetroot -name "$(echo -n " " && date '+%a %k:%M:%S %d-%m-%Y ')"
done &
xrdb ~/.Xresources
setxkbmap br
# kanata -c ~/dotfiles/kanata/.config/kanata/kanata.kbd

# Necessary for xdg to properly work on nixos
# dbus-update-activation-environment --systemd DISPLAY
# systemctl --user import-environment PATH
# systemctl --user restart xdg-desktop-portal.service

# background processes
flameshot &
lxqt-policykit-agent &
# feh --bg-scale ~/dotfiles/wallpaper/wallpaper7.jpg
# dunst &
blueman-applet &
# picom &
# warp-cli disconnect &
# ~/bash/sidebery.sh &
# rclone mount drive:/ ~/drive --vfs-cache-mode full &
nm-applet &
# cbatticon &
# mechvibes &

# autostart
# emacs &
# librewolf &
# steam &
# flatpak run com.usebottles.bottles &

# keepassxc &
# obs &
# Vial &

# redshift &

# dev
# emacs --name emacs-dev "~/tmp/tmp/next/app/(dashboard)/page.tsx" &
# emacs --name project-dev ~/tmp/tmp/next/project.org &
# emacs --name chinese ~/drive/orgs/chinese.org &


xrandr --output eDP-1 --mode 2880x1800 --pos 1920x0 --rotate normal --output HDMI-1 --primary --mode 1920x1080 --rate 180 --pos 0x0 --rotate normal --output DP-1 --off --output DP-2 --off

exec qtile start
# exec dwm
