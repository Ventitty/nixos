{ config, pkgs, ... }:

{
  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
 services.displayManager.sddm = {
    enable = true;
    theme = "catppuccin-mocha";
  };

  services.desktopManager.plasma6.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "fr";
    variant = "azerty";
  };

  environment.systemPackages = with pkgs; [
    (writeTextDir "share/sddm/themes/breeze/theme.conf.user" ''
      [General]
      background=${./../../contents/wallpaper1.jpg}
    '')
  ];
}
