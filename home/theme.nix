# Thème Nord partout : GTK, Plasma, décorations, Konsole, icônes.
# Le paquet `nordic` de nixpkgs installe déjà les fichiers KDE (color-schemes,
# aurorae, konsole, icônes Nordic-darker) dans le profil : pas besoin de les
# lier à la main dans ~/.local/share.
{ pkgs, ... }:

let
  wallpaper = ../contents/wallpaper1.jpg;
in
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
}
