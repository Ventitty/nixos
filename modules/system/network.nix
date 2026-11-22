{
  flake.modules.nixos.network =
    { pkgs, ... }:
    {
      networking.networkmanager.enable = true;

      # SSH et sshfs avec support Kerberos (GSSAPI)
      programs.ssh.package = pkgs.openssh_gssapi;
      nixpkgs.overlays = [
        (final: prev: { sshfs = prev.sshfs.override { openssh = final.openssh_gssapi; }; })
      ];
      environment.systemPackages = with pkgs; [
        krb5
        sshfs
      ];
    };
}
