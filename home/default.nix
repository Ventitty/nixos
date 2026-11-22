{ pkgs, ... }:

{
  imports = [
    ./alacritty.nix
    ./git.nix
    ./plasma.nix
    ./theme.nix
  ];

  home.packages = with pkgs; [
    # Bureau
    kdePackages.kate
    kdePackages.plasma-browser-integration
    discord
    google-chrome
    mangohud

    # Développement
    vscode
    python3
    platformio
  ];

  programs.home-manager.enable = true;

  home.stateVersion = "26.05"; # Ne pas modifier
}
