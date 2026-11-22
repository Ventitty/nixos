final: prev: {
  # Paquets maison
  stlink-server = final.callPackage ../pkgs/stlink-server { };
  stm32cubeide-unwrapped = final.callPackage ../pkgs/stm32cubeide/unwrapped.nix { };
  stm32cubeide = final.callPackage ../pkgs/stm32cubeide { };

  # sshfs compilé avec OpenSSH + GSSAPI (Kerberos)
  sshfs = prev.sshfs.override { openssh = final.openssh_gssapi; };
}
