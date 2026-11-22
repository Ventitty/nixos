{ pkgs, ... }:

{
  networking.networkmanager.enable = true;

  # SSH avec support Kerberos (GSSAPI) ; sshfs est recompilé dans l'overlay
  programs.ssh.package = pkgs.openssh_gssapi;
  environment.systemPackages = with pkgs; [
    krb5
    sshfs
  ];
}
