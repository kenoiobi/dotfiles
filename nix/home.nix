{ config, pkgs, ... }:

{
	home.username = "kayon";
	home.homeDirectory = "/home/kayon";
	home.stateVersion = "25.05";

	programs.git = {
	  enable = true;
	  userEmail = "kenoiobi@gmail.com";
	  userName = "kenoiobi";
	};
	
	programs.firefox = {

		enable = true;
		package = pkgs.librewolf;
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

