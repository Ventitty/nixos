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
  ];

  programs.git = {
     enable = true;
     userName = "Lyre";
     userEmail = "yvan.fedaouche@gmail.com";
  };

  programs.home-manager.enable = true;
}
