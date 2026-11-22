{ inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix

    ../../modules/system/boot.nix
    ../../modules/system/intel.nix
    ../../modules/system/locale.nix
    ../../modules/system/network.nix
    ../../modules/system/nix.nix
    ../../modules/system/power.nix
    ../../modules/system/sound.nix

    ../../modules/desktop/kde.nix

    ../../modules/apps/embedded.nix
    ../../modules/apps/steam.nix
    ../../modules/apps/tools.nix
    ../../modules/apps/virtualisation.nix

    ../../modules/home-manager.nix
    ../../users/lyre.nix
  ];

  nixpkgs.overlays = [ inputs.self.overlays.default ];

  networking.hostName = "lyre_nixos";

  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 16 * 1024; # 16 GiB
    }
  ];

  system.stateVersion = "26.05"; # Ne pas modifier : voir `man configuration.nix`
}
