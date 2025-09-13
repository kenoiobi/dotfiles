{ config, pkgs, ... }:

{
	home.username = "kayon";
	home.homeDirectory = "/home/kayon";
	home.stateVersion = "25.05";

	nixpkgs.config.allowUnfree = true;

	home.packages = [
		pkgs.neovim
		pkgs.curl
		pkgs.wget
		pkgs.tmux
		pkgs.git
		pkgs.rofi
		pkgs.brightnessctl
		pkgs.alacritty
		pkgs.redshift
		pkgs.kdePackages.qtsvg
		pkgs.kdePackages.dolphin
		pkgs.kdePackages.ark
		pkgs.rclone
		pkgs.zsh
		pkgs.fzf
		pkgs.zoxide
		pkgs.direnv
		pkgs.xclip
		pkgs.flameshot
		pkgs.dunst
		pkgs.lxqt.lxqt-policykit
		pkgs.feh
		pkgs.blueman
		pkgs.picom
		pkgs.chromium
		pkgs.slack
		pkgs.stow
		pkgs.trash-cli
		pkgs.lshw
		pkgs.btop
		pkgs.obs-studio
		pkgs.killall
		pkgs.ffmpeg
		pkgs.yazi
		pkgs.alttab
		pkgs.pavucontrol
		pkgs.xorg.xev
		pkgs.playerctl
		pkgs.keepassxc
		pkgs.unzip
		pkgs.gnutar
		pkgs.gzip
		pkgs.nodejs
		pkgs.sumneko-lua-language-server
		pkgs.emacs
		pkgs.tree
		pkgs.postman
		pkgs.fastfetch
		pkgs.obsidian
		pkgs.pcsx2
		pkgs.dbeaver-bin
		pkgs.vial
		pkgs.coreutils-full
		pkgs.bc
		pkgs.prettierd
		pkgs.nil
		pkgs.ripgrep
		pkgs.kdePackages.qtstyleplugin-kvantum
		pkgs.gruvbox-kvantum
		pkgs.python314
		pkgs.zellij
		pkgs.findutils
		pkgs.github-desktop
		pkgs.qbittorrent
		pkgs.pandoc
		pkgs.sublime-merge
		pkgs.v4l-utils
		pkgs.vscode
		pkgs.via
		pkgs.ardour
		pkgs.bucklespring
		pkgs.spotify
		pkgs.xdotool
		pkgs.xorg.xwininfo
		pkgs.xbindkeys
		pkgs.gcc
		pkgs.fd
		pkgs.scrcpy
		pkgs.fish
		pkgs.xonsh
		pkgs.jless
		pkgs.bluetui
		pkgs.arandr
		pkgs.vlc
	];

	programs.git = {
	  enable = true;
	  userEmail = "kenoiobi@gmail.com";
	  userName = "kenoiobi";
	};

	programs.firefox = {

		enable = true;
		package = pkgs.librewolf-bin;
		policies = {
		    DisableTelemetry = true;
			DisableFirefoxStudies = true;

			ExtensionSettings = {
				"Sidebery" = {
					install_url = "https://addons.mozilla.org/firefox/downloads/file/4442132/sidebery-5.3.3.xpi";
					installation_mode = "force_installed";
				};
				"Ublock" = {
					install_url = "https://addons.mozilla.org/firefox/downloads/file/4531307/ublock_origin-1.65.0.xpi";
					installation_mode = "force_installed";
				};
				"Vimium" = {
					install_url = "https://addons.mozilla.org/firefox/downloads/file/4524018/vimium_ff-2.3.xpi";
					installation_mode = "force_installed";
				};
				"Tomato Clock" = {
					install_url = "https://addons.mozilla.org/firefox/downloads/file/3835234/tomato_clock-6.0.2.xpi";
					installation_mode = "force_installed";
				};
				"202020" = {
					install_url = "https://addons.mozilla.org/firefox/downloads/file/3859289/20_20_20_rule-1.0.xpi";
					installation_mode = "force_installed";
				};
			};
		};

	};

}

