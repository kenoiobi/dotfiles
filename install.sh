sudo pacman -S - < pacman.txt
cp -r ./.config/ ~/
sudo cp 00-keyboard.conf /etc/X11/xorg.conf.d/

cd ~/git
git clone https://github.com/kenoiobi/dwm
cd dwm
sudo make clean install

cd ~/git
git clone https://github.com/kenoiobi/st
cd dwm
sudo make clean install
