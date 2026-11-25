# ESP32 avec ESP-IDF (via nixpkgs-esp-dev)
#
# ESP-IDF s'utilise dans un shell de développement, qui définit IDF_PATH,
# les toolchains et l'environnement Python attendus par idf.py :
#
#   nix develop ~/Documents/nixos#esp-idf          # toutes les puces ESP32
#   nix develop ~/Documents/nixos#esp-idf-xtensa   # ESP32, ESP32-S2, ESP32-S3
#   nix develop ~/Documents/nixos#esp-idf-riscv    # ESP32-C2/C3/C6, H2, P4
#
# ou dans le .envrc d'un projet (avec direnv) : use flake ~/Documents/nixos#esp-idf
{ inputs, ... }:

{
  # Construits avec le nixpkgs de nixpkgs-esp-dev, qui autorise déjà le paquet
  # python-ecdsa marqué comme non sûr (utilisé par esptool, sans impact pour
  # flasher une carte : https://github.com/mirrexagon/nixpkgs-esp-dev/issues/109)
  perSystem =
    { system, ... }:
    let
      espPkgs = inputs.esp-dev.packages.${system};
      inherit (inputs.esp-dev.inputs.nixpkgs.legacyPackages.${system}) mkShell;

      mkIdfShell =
        idf:
        mkShell {
          name = "esp-idf";
          buildInputs = [ idf ];
        };
    in
    {
      devShells = {
        esp-idf = mkIdfShell espPkgs.esp-idf-full;
        esp-idf-xtensa = mkIdfShell espPkgs.esp-idf-xtensa;
        esp-idf-riscv = mkIdfShell espPkgs.esp-idf-riscv;
      };
    };

  # Accès aux cartes sans root. Les ponts série (CP210x, CH340…) passent par
  # le groupe dialout, déjà ajouté par `embedded`.
  flake.modules.nixos.esp32 = {
    services.udev.extraRules = ''
      # USB-Serial/JTAG intégré (ESP32-C3, C6, S3, H2, P4…)
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="303a", ATTRS{idProduct}=="1001", MODE="0660", TAG+="uaccess"
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="303a", ATTRS{idProduct}=="1002", MODE="0660", TAG+="uaccess"
      # ESP-Prog (FTDI FT2232H) pour OpenOCD
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="0403", ATTRS{idProduct}=="6010", MODE="0660", TAG+="uaccess"
    '';
  };
}
