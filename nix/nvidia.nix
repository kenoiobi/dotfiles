{ config, lib, pkgs, ... }:

{
  hardware.graphics = {
    enable = true;
  };

  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = false;

    nvidiaSettings = true;

    package = config.boot.kernelPackages.nvidiaPackages.legacy_535;
  };

 	 hardware.nvidia.prime = {

	    sync.enable = false;
 	 	# Make sure to use the correct Bus ID values for your system!
 	 	intelBusId = "PCI:0:2:0";
 	 	nvidiaBusId = "PCI:1:0:0";
 	 };


}

