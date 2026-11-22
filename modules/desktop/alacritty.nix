# Terminal Alacritty, thème Nord, lancé avec Meta+Entrée.
{ config, ... }:

let
  homeModules = config.flake.modules.homeManager;
in
{
  flake.modules.nixos.alacritty = {
    home-manager.sharedModules = [ homeModules.alacritty ];
  };

  flake.modules.homeManager.alacritty =
    { pkgs, ... }:
    {
      programs.alacritty = {
        enable = true;
        settings = {
          general.import = [ "${pkgs.alacritty-theme}/nord.toml" ];
          window = {
            opacity = 0.9;
            padding = {
              x = 10;
              y = 10;
            };
          };
        };
      };

      programs.plasma.shortcuts."Alacritty.desktop"._launch = "Meta+Return";
    };
}
