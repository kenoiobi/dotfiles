# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/master.tar.gz";
in
{
  imports =
    [ # Include the results of the hardware scan.
      /etc/nixos/hardware-configuration.nix
      (import "${home-manager}/nixos")
# 	  ./nvidia.nix
    ];

  home-manager.useUserPackages = true;
  home-manager.useGlobalPkgs = true;
  home-manager.backupFileExtension = "backup";
  home-manager.users.kayon = import ./home.nix;

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelModules = [ "v4l2loopback" ];
  boot.extraModulePackages = [ pkgs.linuxPackages.v4l2loopback ];

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

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

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "br";
    variant = "";
  };

  # Configure console keymap
  console.keyMap = "br-abnt2";
  programs.zsh.enable = true;

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
  services.xserver.windowManager.qtile.enable = true;

  services.libinput.touchpad.naturalScrolling = true;

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
	# rxvt-unicode
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
  ];

  fonts.packages = with pkgs; [
	nerd-fonts.jetbrains-mono
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };
	programs.steam = {
	  enable = true;
	  remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
	  dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
	  localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
	};
# hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?
	hardware.bluetooth.enable = true; # enables support for Bluetooth
	hardware.bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot
  hardware.pulseaudio.enable = false; # Use Pipewire, the modern sound subsystem
}
