{ config, pkgs, ... }:

{
  home.username = "lyre";
  home.homeDirectory = "/home/lyre";
  home.stateVersion = "26.05";
  home.packages = with pkgs; [
    kdePackages.kate
    kdePackages.plasma-browser-integration
    discord
    google-chrome
    mangohud
    vscode
    python3
    zlib
    platformio
  ];

  programs.git = {
     enable = true;

     settings.user = {
      name = "Lyre";
      email = "yvan.fedaouche@gmail.com";
     };
  };

  programs.home-manager.enable = true;
}
