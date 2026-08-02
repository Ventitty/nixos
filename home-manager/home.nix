{ config, pkgs, ... }:

{
  home.username = "lyre";
  home.homeDirectory = "/home/lyre";
  home.stateVersion = "26.05";
  home.packages = with pkgs; [
    kdePackages.kate
    kdePackages.plasma-browser-integration
    discord
    google-chrome
    mangohud
    vscode
    python3
    zlib
    platformio
    alacritty

    papirus-icon-theme
  ];

  programs.git = {
     enable = true;

     settings.user = {
      name = "Lyre";
      email = "yvan.fedaouche@gmail.com";
     };
  };

  programs.alacritty = {
    enable = true;
    settings = {
      general.import = [
        "${pkgs.alacritty-theme}/catppuccin_mocha.toml"
      ];
      window = {
        opacity = 0.9;
        padding = { x = 10; y = 10; };
      };
    };
  };

  catppuccin = {
    enable = true;
    flavor = "mocha";
    accent = "mauve";
    plasma.enable = true; # Applique automatiquement le thème à KDE Plasma
  };

  programs.plasma = {
    enable = true;

    configFile = {
      "kwinrc" = {
        "Desktops" = {
          "Number" = 10;
          "Rows" = 2;
        };
      };
    };

    workspace = {
      iconTheme = "Papirus-Dark";
      wallpaper = ./../contents/wallpaper1.jpg;
    };

    shortcuts = {
      "kwin" = {
        "Switch to Desktop 1" = "Meta+&";
        "Window to Desktop 1" = "Meta+1";

        "Switch to Desktop 2" = "Meta+é";
        "Window to Desktop 2" = "Meta+2";

        "Switch to Desktop 3" = "Meta+\"";
        "Window to Desktop 3" = "Meta+3";

        "Switch to Desktop 4" = "Meta+'";
        "Window to Desktop 4" = "Meta+4";

        "Switch to Desktop 5" = "Meta+(";
        "Window to Desktop 5" = "Meta+5";

        "Switch to Desktop 6" = "Meta+-";
        "Window to Desktop 6" = "Meta+6";

        "Switch to Desktop 7" = "Meta+è";
        "Window to Desktop 7" = "Meta+7";

        "Switch to Desktop 8" = "Meta+_";
        "Window to Desktop 8" = "Meta+8";

        "Switch to Desktop 9" = "Meta+ç";
        "Window to Desktop 9" = "Meta+9";

        "Switch to Desktop 10" = "Meta+à";
        "Window to Desktop 10" = "Meta+0";

        "Window Close" = "Meta+Q";
      };

      "org.kde.krunner.desktop" = {
        "_launch" = "Meta+Space";
      };

      "Alacritty.desktop" = {
        "_launch" = "Meta+Return";
      };
    };
  };

  programs.home-manager.enable = true;
}
