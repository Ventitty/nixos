{ pkgs, ... }:

{
  # Session X11 conservée en secours (Plasma 6 tourne par défaut sous Wayland)
  services.xserver.enable = true;

  services.displayManager.sddm = {
    enable = true;
    theme = "breeze";
  };
  services.desktopManager.plasma6.enable = true;

  # Fond d'écran de l'écran de connexion
  environment.systemPackages = [
    (pkgs.writeTextDir "share/sddm/themes/breeze/theme.conf.user" ''
      [General]
      background=${../../contents/wallpaper1.jpg}
    '')
  ];
}
