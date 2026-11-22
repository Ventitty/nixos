{ config, ... }:

let
  inherit (config.my) username;
in
{
  flake.modules.nixos.virtualisation =
    { pkgs, ... }:
    {
      virtualisation.libvirtd.enable = true;
      programs.virt-manager.enable = true;

      # qemu en ligne de commande (libvirtd ne l'ajoute pas au PATH)
      environment.systemPackages = [ pkgs.qemu_kvm ];

      users.users.${username}.extraGroups = [ "libvirtd" ];
    };
}
