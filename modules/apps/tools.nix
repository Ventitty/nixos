{
  flake.modules.nixos.tools =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        vim
      ];

      # Gravure CD/DVD
      services.udev.packages = with pkgs; [
        cdrtools
        dvdplusrwtools
      ];

      # Permet de lancer des binaires non-Nix (toolchains téléchargées, PlatformIO…)
      programs.nix-ld.enable = true;
    };
}
