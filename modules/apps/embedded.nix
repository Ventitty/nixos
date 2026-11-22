# Électronique embarquée : toolchain, FPGA, sondes J-Link, analyseur logique
{ config, ... }:

let
  inherit (config.my) username;
in
{
  flake.modules.nixos.embedded =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        # Toolchain et debug
        gcc
        gdb
        cmake
        picocom
      ];

      hardware.saleae-logic.enable = true;

      # Accès aux sondes sans root
      services.udev.packages = with pkgs; [
        openfpgaloader
        usb-blaster-udev-rules
      ];

      # SEGGER J-Link (pas de paquet de règles dans nixpkgs)
      services.udev.extraRules = ''
        ATTR{idVendor}=="1366", ATTR{idProduct}=="010[1-578]", MODE="0666", ENV{ID_MM_DEVICE_IGNORE}="1"
        ATTR{idVendor}=="1366", ATTR{idProduct}=="10[0-6][0-9a-f]", MODE="0666", ENV{ID_MM_DEVICE_IGNORE}="1"
        ATTR{idVendor}=="1366", ATTR{idProduct}=="1080", MODE="0666", ENV{ID_MM_DEVICE_IGNORE}="1"
        KERNEL=="hidraw*", ATTRS{idVendor}=="1366", MODE="0666"
        SUBSYSTEM=="tty", ATTRS{idVendor}=="1366", MODE="0666"
      '';

      # Ports série (/dev/ttyUSB*, /dev/ttyACM*)
      users.users.${username}.extraGroups = [ "dialout" ];
    };
}
