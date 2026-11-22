# Thème Nord et fond d'écran partout : SDDM, écran de verrouillage, Plasma, GTK.
# Le paquet `nordic` de nixpkgs installe déjà les fichiers KDE (color-schemes,
# aurorae, konsole, icônes Nordic-darker) dans le profil.
# Nécessite la fonctionnalité `kde` (plasma-manager).
{ config, ... }:

let
  # Copié seul dans le store : son chemin ne change pas à chaque modification du dépôt
  wallpaper = builtins.path {
    path = ../../contents/wallpaper1.jpg;
    name = "wallpaper1.jpg";
  };
  homeModules = config.flake.modules.homeManager;
in
{
  flake.modules.nixos.theme =
    { pkgs, ... }:
    {
      # Fond d'écran de l'écran de connexion
      environment.systemPackages = [
        (pkgs.writeTextDir "share/sddm/themes/breeze/theme.conf.user" ''
          [General]
          background=${wallpaper}
        '')
      ];

      home-manager.sharedModules = [ homeModules.theme ];
    };

  flake.modules.homeManager.theme =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.nordic ];

      gtk = {
        enable = true;
        theme = {
          name = "Nordic";
          package = pkgs.nordic;
        };
      };

      programs.plasma = {
        workspace = {
          colorScheme = "Nordic";
          iconTheme = "Nordic-darker";
          windowDecorations = {
            library = "org.kde.kwin.aurorae";
            theme = "__aurorae__svg__Nordic";
          };
          inherit wallpaper;
        };

        kscreenlocker.appearance = { inherit wallpaper; };
      };
    };
}
