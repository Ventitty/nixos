{
  description = "Configuration NixOS de Lyre";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    stm32cubeide.url = "path:./modules/apps/stm32cubeide";
  };

  outputs =
    { self, nixpkgs, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [ self.overlays.default ];
      };
    in
    {
      # Paquets maison (stlink-server, STM32CubeIDE), injectés dans pkgs.
      overlays.default = import ./overlays;

      # Pour construire un paquet seul : nix build .#stm32cubeide
      packages.${system} = {
        inherit (pkgs) stlink-server stm32cubeide;
      };

      nixosConfigurations.lyre_nixos = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [ ./hosts/lyre_nixos ];
      };

      # nix fmt
      formatter.${system} = pkgs.nixfmt-tree;
    };
}
