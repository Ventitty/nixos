# Socle flake-parts : active `flake.modules.<classe>.<nom>`, l'option sur laquelle
# repose tout le pattern dendritic.
{ inputs, ... }:

{
  imports = [ inputs.flake-parts.flakeModules.modules ];

  systems = [ "x86_64-linux" ];

  # nix fmt
  perSystem = { pkgs, ... }: {
    formatter = pkgs.nixfmt-tree;
  };
}
