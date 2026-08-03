{ config, pkgs, ... }:

{
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users."lyre" = {
    isNormalUser = true;
    description = "Lyre";
    extraGroups = [ "networkmanager" "wheel" "dialout" ];
  };

  services.udev.packages = with pkgs; [
    openfpgaloader
  ];
}
