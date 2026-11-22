{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    vim
  ];

  # Gravure CD/DVD
  services.udev.packages = with pkgs; [
    cdrtools
    dvdplusrwtools
  ];

  # Permet de lancer des binaires non-Nix (toolchains téléchargées, PlatformIO…)
  # (zlib, libstdc++… sont dans les bibliothèques par défaut de nix-ld)
  programs.nix-ld.enable = true;
}
