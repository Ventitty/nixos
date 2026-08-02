# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix

      ../../modules/system/boot.nix
      ../../modules/system/gc.nix
      ../../modules/system/intel.nix
      ../../modules/system/keyboard.nix
      ../../modules/system/network.nix
      ../../modules/system/power.nix
      ../../modules/system/sound.nix

      ../../modules/desktop/kde.nix

      ../../modules/apps/steam.nix

      ../../users/lyre.nix
    ];

  nixpkgs.config.allowUnfree = true;
  programs.nix-ld.enable = true;
  environment.systemPackages = with pkgs; [
    vim
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  system.stateVersion = "26.05"; # Did you read the comment?

}
