{
  # Mot de passe à définir avec `passwd`.
  # Les groupes propres à un usage sont ajoutés par les modules concernés
  # (dialout dans embedded.nix, libvirtd dans virtualisation.nix).
  users.users.lyre = {
    isNormalUser = true;
    description = "Lyre";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
  };

  home-manager.users.lyre = import ../home;
}
