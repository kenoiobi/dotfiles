#/usr/bin/env sh

sudo apt update
sudo apt upgrade
sudo apt install\
    neovim\
	curl\
	tmux\
	git\
	rofi\
	brightnessctl\
	alacritty\
	redshift\
	dolphin\
	rclone\
	zsh\
	fzf\
	zoxide\
	direnv\
	xclip\
	flameshot\
	dunst\
	lxqt-policykit\
	feh\
	blueman\
	picom\
	chromium\
	slack\
	stow\
	trash-cli\
	lshw\
	btop\
	obs-studio\
	killall\
	ffmpeg\
	yazi\
	alttab\
	pavucontrol\
	playerctl\
	keepassxc\
	unzip\
	gnutar\
	gzip\
	nodejs\
	sumneko-lua-language-server\
	emacs\
	tree\
	postman\
	fastfetch\
	obsidian\
	pcsx2\
	dbeaver-bin\
	bc\
	findutils\
	qbittorrent\
    extrepo\
    docker\
    steam\
    flatpak\
    -y

sudo extrepo enable\
    librewolf\
    slack

sudo apt install\
    librewolf\
    slack

flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
flatpak install flathub com.discordapp.Discord
