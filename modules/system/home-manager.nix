# Home Manager comme module NixOS. Les fonctionnalités qui ont une partie
# utilisateur l'ajoutent via `home-manager.sharedModules`.
{ inputs, ... }:

{
  flake.modules.nixos.home-manager = {
    imports = [ inputs.home-manager.nixosModules.home-manager ];

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      backupFileExtension = "backup";
    };
  };
}
