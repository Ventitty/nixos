{
  flake.modules.nixos.power = {
    services.power-profiles-daemon.enable = true;
    services.thermald.enable = true;
  };
}
