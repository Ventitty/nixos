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
}
