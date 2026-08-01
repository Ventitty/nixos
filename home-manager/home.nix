{ config, pkgs, ... }:

{
  # Paramètres de base de votre utilisateur
  home.username = "lyre";
  home.homeDirectory = "/home/lyre";

  # La version de l'état doit généralement correspondre à celle de votre système (26.05)
  home.stateVersion = "26.05";

  # C'est ici que vous pourrez installer des paquets spécifiques à votre utilisateur
  # (Vous pouvez y déplacer kdePackages.kate par exemple, ou y ajouter d'autres outils)
  home.packages = with pkgs; [
    kdePackages.kate
    kdePackages.plasma-browser-integration
  ];

  programs.git = {
     enable = true;
     userName = "Lyre";
     userEmail = "yvan.fedaouche@gmail.com";
  };

  # Demande à Home Manager de s'installer et de se gérer lui-même
  programs.home-manager.enable = true;
}
