# Bureau KDE Plasma 6 : partie système (SDDM, Plasma) et partie utilisateur
# (plasma-manager : bureaux virtuels, raccourcis).
{ config, inputs, ... }:

let
  homeModules = config.flake.modules.homeManager;
in
{
  flake.modules.nixos.kde = {
    # Session X11 conservée en secours (Plasma 6 tourne par défaut sous Wayland)
    services.xserver.enable = true;

    services.displayManager.sddm = {
      enable = true;
      theme = "breeze";
    };
    services.desktopManager.plasma6.enable = true;

    home-manager.sharedModules = [
      inputs.plasma-manager.homeModules.plasma-manager
      homeModules.kde
    ];
  };

  flake.modules.homeManager.kde =
    { lib, ... }:
    let
      # Touches de la rangée du haut en AZERTY, bureaux 1 à 10
      azertyRow = [ "&" "é" "\"" "'" "(" "-" "è" "_" "ç" "à" ];

      # Meta+<touche> : aller au bureau N ; Meta+<chiffre> : y envoyer la fenêtre
      desktopShortcuts = lib.listToAttrs (
        lib.concatLists (
          lib.imap1 (n: key: [
            (lib.nameValuePair "Switch to Desktop ${toString n}" "Meta+${key}")
            (lib.nameValuePair "Window to Desktop ${toString n}" "Meta+${toString (lib.mod n 10)}")
          ]) azertyRow
        )
      );
    in
    {
      programs.plasma = {
        enable = true;

        configFile.kwinrc.Desktops = {
          Number = 10;
          Rows = 2;
        };

        shortcuts = {
          kwin = desktopShortcuts // {
            "Window Close" = "Meta+Q";
          };
          "org.kde.krunner.desktop"._launch = "Meta+Space";
        };
      };
    };
}
