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
mkdir .emacs.d

ln -s ~/git/dotfiles/home/.emacs
ln -s ~/git/dotfiles/home/.bookmark
ln -s ~/git/dotfiles/home/.vimrc
ln -s ~/git/dotfiles/home/.xinitrc
ln -s ~/git/dotfiles/home/.Xresources
ln -s ~/git/dotfiles/home/.zshrc

mkdir ~/.config
cd ~/.config/
ln -s ~/git/dotfiles/.config/tmux/
ln -s ~/git/dotfiles/.config/lf/

git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

cd ~/.emacs.d/
ln -s ~/git/dotfiles/home/.emacs.d/snippets/
