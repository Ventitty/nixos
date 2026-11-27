{
  flake.modules.nixos.nvidia = {
    hardware.graphics = {
        enable = true;
        enable32Bit = true;
    };

    services.xserver.videoDrivers = ["nvidia"];

    hardware.nvidia = {
        modesetting.enable = true;
        powerManagement.enable = false;
        open = false;
        nvidiaSettings = true;
        branch = "legacy_580";
    };

    nixpkgs.config.nvidia.acceptLicense = true;
  };
}
