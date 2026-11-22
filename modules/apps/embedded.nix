# Électronique embarquée : STM32, FPGA, analyseur logique
{ pkgs, inputs, ... }:

{
  environment.systemPackages = with pkgs; [
    # STM32
    inputs.stm32cubeide.packages.x86_64-linux.default # temporaire, voir flake.nix
    stm32cubemx
    stlink
    stlink-gui
    stlink-tool
    stlink-server

    # Toolchain et debug
    gcc
    gdb
    cmake
    picocom
  ];

  hardware.saleae-logic.enable = true;

  # Accès aux sondes sans root
  services.udev.packages = with pkgs; [
    stlink # ST-Link V1/V2/V3
    openfpgaloader
    usb-blaster-udev-rules
  ];

  services.udev.extraRules = ''
    # ST-Link V3 (loader, V3PWR) absents des règles du paquet stlink
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="3755", MODE="0666", TAG+="uaccess", ENV{ID_MM_DEVICE_IGNORE}="1", SYMLINK+="stlinkv3loader_%n"
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="3757", MODE="0666", TAG+="uaccess", ENV{ID_MM_DEVICE_IGNORE}="1", SYMLINK+="stlinkv3_%n"

    # SEGGER J-Link (pas de paquet de règles dans nixpkgs)
    ATTR{idVendor}=="1366", ATTR{idProduct}=="010[1-578]", MODE="0666", ENV{ID_MM_DEVICE_IGNORE}="1"
    ATTR{idVendor}=="1366", ATTR{idProduct}=="10[0-6][0-9a-f]", MODE="0666", ENV{ID_MM_DEVICE_IGNORE}="1"
    ATTR{idVendor}=="1366", ATTR{idProduct}=="1080", MODE="0666", ENV{ID_MM_DEVICE_IGNORE}="1"
    KERNEL=="hidraw*", ATTRS{idVendor}=="1366", MODE="0666"
    SUBSYSTEM=="tty", ATTRS{idVendor}=="1366", MODE="0666"
  '';

  # Ports série (/dev/ttyUSB*, /dev/ttyACM*)
  users.users.lyre.extraGroups = [ "dialout" ];
}
