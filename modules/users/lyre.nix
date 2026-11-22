{ config, ... }:

let
  inherit (config.my) username;
  homeModules = config.flake.modules.homeManager;
in
{
  # Compte système. Les groupes propres à un usage sont ajoutés par les
  # fonctionnalités concernées (dialout dans embedded, libvirtd dans virtualisation).
  # Mot de passe à définir avec `passwd`.
  flake.modules.nixos.lyre = {
    users.users.${username} = {
      isNormalUser = true;
      description = "Lyre";
      extraGroups = [
        "networkmanager"
        "wheel"
      ];
    };

    home-manager.users.${username}.imports = [ homeModules.lyre ];
  };

  # Environnement personnel
  flake.modules.homeManager.lyre =
    { pkgs, ... }:
    {
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

      programs.git = {
        enable = true;
        settings.user = {
          name = "Lyre";
          email = "yvan.fedaouche@gmail.com";
        };
      };

      programs.home-manager.enable = true;

      home.stateVersion = "26.05"; # Ne pas modifier
    };
}
