# La machine : la liste des fonctionnalités qu'elle active, et ce qui lui est propre.
{ config, inputs, ... }:

{
  flake.nixosConfigurations.lyre_nixos = inputs.nixpkgs.lib.nixosSystem {
    modules = with config.flake.modules.nixos; [
      # Système
      boot
      intel
      locale
      network
      nix
      power
      sound

      # Bureau
      kde
      theme
      alacritty

      # Applications
      embedded
      esp32
      steam
      tools
      virtualisation

      # Utilisateurs
      home-manager
      lyre

      # Spécifique à cette machine
      ./_hardware-configuration.nix
      {
        networking.hostName = "lyre_nixos";

        swapDevices = [
          {
            device = "/var/lib/swapfile";
            size = 16 * 1024; # 16 GiB
          }
        ];

        system.stateVersion = "26.05"; # Ne pas modifier : voir `man configuration.nix`
      }
    ];
  };
}
