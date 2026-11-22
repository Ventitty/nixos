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
      "Alacritty.desktop"._launch = "Meta+Return";
    };
  };
}
