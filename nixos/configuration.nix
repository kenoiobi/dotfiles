# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let
home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/master.tar.gz";
in
{
	imports =
		[
			./hardware-configuration.nix
			# ./nvidia.nix
			(import "${home-manager}/nixos")
			./emulation.nix
		];

    # Bootloader.
	boot.loader.systemd-boot.enable = true;
	boot.loader.efi.canTouchEfiVariables = true;

	boot.kernelModules = [ "v4l2loopback" ];
	boot.extraModulePackages = [ pkgs.linuxPackages.v4l2loopback ];

	networking.hostName = "nixos"; # Define your hostname.

	networking.networkmanager.enable = true;

	# Set your time zone.
	time.timeZone = "America/Recife";

	# Select internationalisation properties.
	i18n.defaultLocale = "en_US.UTF-8";

	i18n.extraLocaleSettings = {
		LC_ADDRESS = "pt_BR.UTF-8";
		LC_IDENTIFICATION = "pt_BR.UTF-8";
		LC_MEASUREMENT = "pt_BR.UTF-8";
		LC_MONETARY = "pt_BR.UTF-8";
		LC_NAME = "pt_BR.UTF-8";
		LC_NUMERIC = "pt_BR.UTF-8";
		LC_PAPER = "pt_BR.UTF-8";
		LC_TELEPHONE = "pt_BR.UTF-8";
		LC_TIME = "pt_BR.UTF-8";
	};

	# Configure console keymap
	console.keyMap = "br-abnt2";
	programs.zsh.enable = true;

	# Audio and bluetooth
	hardware.bluetooth.enable = true; # enables support for Bluetooth
	hardware.bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot
	services.pulseaudio.enable = false; # Use Pipewire, the modern sound subsystem

	# Configure keymap in X11
	services.xserver.xkb = {
		layout = "br";
		variant = "";
	};


	# Define a user account. Don't forget to set a password with ‘passwd’.
	users.users.kayon = {
		isNormalUser = true;
		description = "kayon";
		extraGroups = [ "networkmanager" "wheel" ];
		packages = with pkgs; [];
		shell = pkgs.zsh;
	};


	# Allow unfree packages
	nixpkgs.config.allowUnfree = true;

	services.xserver.enable = true;
	# services.xserver.displayManager.gdm.enable = true;
	services.xserver.displayManager.startx.enable = true;

	services.xserver.windowManager.dwm.enable = true;

	services.xserver.windowManager.dwm.package = pkgs.dwm.overrideAttrs {
	  src = /home/kayon/dotfiles/dwm;
	};

	services.libinput.touchpad.naturalScrolling = true;

	programs.gamemode.enable = true;

	environment.systemPackages = with pkgs; [
			vim
			neovim
			curl
			tmux
			librewolf-bin
			git
			terminator
			rofi
			brightnessctl
			alacritty
			redshift
			kdePackages.qtsvg
			kdePackages.dolphin
			kdePackages.ark
			rclone
			zsh
			fzf
			zoxide
			direnv
			xclip
			lf
			flameshot
			dunst
			lxqt.lxqt-policykit
			feh
			blueman
			picom
			chromium
			slack
			stow
			trash-cli
			lshw
			btop
			obs-studio
			gcc
			linuxPackages.v4l2loopback
			killall
			ffmpeg
			yazi
			alttab
			pavucontrol
			discord
			xorg.xev
			playerctl
			keepassxc
			unzip
			gnutar
			gzip
			nodejs
			sumneko-lua-language-server
			emacs
			tree
			postman
			fastfetch
			obsidian
			pcsx2
			dbeaver-bin
			vial
			coreutils-full
	];

	services.udev = {

	  packages = with pkgs; [
		qmk
		qmk-udev-rules # the only relevant
		qmk_hid
		via
		vial
	  ]; # packages

};
	programs.steam = {
		enable = true;
		remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
			dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
			localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
	};

	fonts.packages = with pkgs; [
		nerd-fonts.jetbrains-mono
	];

	services.openssh.enable = true;
	services.udisks2.enable = true;

	# home manager setup
	home-manager.useUserPackages = true;
	home-manager.useGlobalPkgs = true;
	home-manager.backupFileExtension = "backup";
	home-manager.users.kayon = import ./home.nix;

	system.stateVersion = "25.05";
}
