{ config, lib, pkgs, modulesPath, ... }:


let
	retroarchWithCores = (pkgs.retroarch.withCores (cores: with cores; [
				pcsx2
				snes9x
				sameboy
				dolphin
				mgba
				citra
	]));
in
{
	environment.systemPackages = [
		retroarchWithCores
	];
}
