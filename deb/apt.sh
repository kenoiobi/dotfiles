#/usr/bin/env sh

sudo apt update -y
sudo apt upgrade -y

sudo apt install netselect-apt -y
netselect-apt

sudo apt install\
    neovim\
    build-essential\
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
    stow\
    trash-cli\
    lshw\
    btop\
    obs-studio\
    ffmpeg\
    alttab\
    pavucontrol\
    playerctl\
    keepassxc\
    unzip\
    gzip\
    nodejs\
    npm\
    emacs\
    tree\
    fastfetch\
    bc\
    findutils\
    qbittorrent\
    extrepo\
    flatpak\
    libx11-dev\
    libxft-dev\
    libxinerama-dev\
    ark\
    v4l2loopback-dkms\
    xinput\
    acpi\
    apt-transport-https\
    xonsh\
    fd-find\
    time\
    arandr\
    docker.io\
    gdb\
    -y

sudo extrepo enable\
  librewolf\

sudo apt install\
    librewolf\
    -y
