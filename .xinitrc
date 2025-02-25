while true; do sleep 1; xsetroot -name "$(date)"; done &
xrdb ~/.Xresources
setxkbmap br -option ctrl:swapcaps
~/aa.sh
feh --bg-scale ~/git/dotfiles/wallpaper4.jpg
redshift &
picom &
firefox &
emacs &
exec dwm
