# sudo pacman -S - < pacman.txt
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

cd ~/

ln -s ~/git/dotfiles/home/.emacs
ln -s ~/git/dotfiles/home/.bookmark
ln -s ~/git/dotfiles/home/.vimrc
ln -s ~/git/dotfiles/home/.xinitrc
ln -s ~/git/dotfiles/home/.Xresources
ln -s ~/git/dotfiles/home/.zshrc

mkdir .emacs.d
cd ~/.emacs.d/
ln -s ~/git/dotfiles/home/.emacs.d/snippets/
